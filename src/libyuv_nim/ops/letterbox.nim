import std/strformat

import results

import ../bindings/types
import ../core/errors
import ../core/image_types
import ../core/image_alloc
import ./scale

# ------------------------------------------------------------------------------
# Types
# ------------------------------------------------------------------------------
type LetterboxInfo* = object
  srcWidth*: int
  srcHeight*: int
  dstWidth*: int
  dstHeight*: int
  resizedWidth*: int
  resizedHeight*: int
  offsetX*: int
  offsetY*: int
  scaleX*: float32
  scaleY*: float32

# ------------------------------------------------------------------------------
# Types
# ------------------------------------------------------------------------------
type RgbPadColor* = object
  r*: uint8
  g*: uint8
  b*: uint8

# ------------------------------------------------------------------------------
# Constants
# ------------------------------------------------------------------------------
const yoloPadRgb* = RgbPadColor(r: 114'u8, g: 114'u8, b: 114'u8)

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc offsetPtr(p: ptr uint8, offset: int): ptr uint8 =
  result = cast[ptr uint8](cast[uint](p) + cast[uint](offset))

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toRgbView(image: RgbImage): RgbView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toRgbView(image: var RgbImage): RgbView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toRgbaView(image: RgbaImage): RgbaView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbaDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toRgbaView(image: var RgbaImage): RgbaView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbaDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toNv12View(image: Nv12Image): Nv12View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideUV = image.strideUV
  result.y = if image.y.len == 0: nil else: cast[ptr uint8](unsafeAddr image.y[0])
  result.uv = if image.uv.len == 0: nil else: cast[ptr uint8](unsafeAddr image.uv[0])

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toNv12View(image: var Nv12Image): Nv12View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideUV = image.strideUV
  result.y = if image.y.len == 0: nil else: addr image.y[0]
  result.uv = if image.uv.len == 0: nil else: addr image.uv[0]

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toI420View(image: I420Image): I420View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideU = image.strideU
  result.strideV = image.strideV
  result.y = if image.y.len == 0: nil else: cast[ptr uint8](unsafeAddr image.y[0])
  result.u = if image.u.len == 0: nil else: cast[ptr uint8](unsafeAddr image.u[0])
  result.v = if image.v.len == 0: nil else: cast[ptr uint8](unsafeAddr image.v[0])

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toI420View(image: var I420Image): I420View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideU = image.strideU
  result.strideV = image.strideV
  result.y = if image.y.len == 0: nil else: addr image.y[0]
  result.u = if image.u.len == 0: nil else: addr image.u[0]
  result.v = if image.v.len == 0: nil else: addr image.v[0]

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc subRgbView(dst: RgbView, info: LetterboxInfo): RgbView =
  result.width = info.resizedWidth
  result.height = info.resizedHeight
  result.stride = dst.stride
  result.data = offsetPtr(dst.data, info.offsetY * dst.stride + info.offsetX * 3)

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireNonNegativeOffset(offsetX, offsetY: int): LY[void] =
  if offsetX < 0 or offsetY < 0:
    return makeError(
      lyInvalidArgument,
      &"offset must be >= 0: offsetX={offsetX}, offsetY={offsetY}"
    ).err

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidRgbView(dst: RgbView, name: string): LY[void] =
  if not dst.isValid:
    return makeError(
      lyInvalidArgument,
      &"invalid {name} RGB view: width={dst.width}, height={dst.height}, " &
      &"stride={dst.stride}, data.isNil={dst.data == nil}"
    ).err

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireScratch(scratch: var RgbaImage, width, height: int): LY[void] =
  if scratch.isValid and scratch.width == width and scratch.height == height:
    result = okVoid()
    return

  scratch = ?allocRgbaImage(width, height)
  result = okVoid()

# ------------------------------------------------------------------------------
# API: fill RGB image/view
# ------------------------------------------------------------------------------
proc fill*(image: RgbView, color: RgbPadColor) =
  for row in 0 ..< image.height:
    let rowPtr = cast[ptr UncheckedArray[uint8]](
      offsetPtr(image.data, row * image.stride)
    )
    var x = 0
    while x < image.width:
      let i = x * 3
      rowPtr[i] = color.r
      rowPtr[i + 1] = color.g
      rowPtr[i + 2] = color.b
      inc x

# ------------------------------------------------------------------------------
# API: fill RGB image/view
# ------------------------------------------------------------------------------
proc fill*(image: RgbView, value: uint8) =
  image.fill(RgbPadColor(r: value, g: value, b: value))

# ------------------------------------------------------------------------------
# API: fill RGB image/view
# ------------------------------------------------------------------------------
proc fill*(image: var RgbImage, color: RgbPadColor) =
  image.toRgbView().fill(color)

# ------------------------------------------------------------------------------
# API: fill RGB image/view
# ------------------------------------------------------------------------------
proc fill*(image: var RgbImage, value: uint8) =
  image.toRgbView().fill(value)

# ------------------------------------------------------------------------------
# API: fill RGB image/view
# ------------------------------------------------------------------------------
proc fill*(image: var RgbImage, r, g, b: uint8) =
  image.fill(RgbPadColor(r: r, g: g, b: b))

# ------------------------------------------------------------------------------
# API: copy RGB image into destination image
# ------------------------------------------------------------------------------
proc blit*(dst: var RgbImage, src: RgbImage, dstX, dstY: int): LY[void] =
  if not dst.isValid:
    return makeError(lyInvalidArgument, "destination image is invalid").err

  if not src.isValid:
    return makeError(lyInvalidArgument, "source image is invalid").err

  ?requireNonNegativeOffset(dstX, dstY)

  if dstX + src.width > dst.width or dstY + src.height > dst.height:
    return makeError(
      lyInvalidArgument,
      &"source image does not fit in destination: " &
      &"dst={dst.width}x{dst.height}, src={src.width}x{src.height}, " &
      &"offset=({dstX}, {dstY})"
    ).err

  for row in 0 ..< src.height:
    let srcIndex = row * src.stride
    let dstIndex = (dstY + row) * dst.stride + dstX * 3
    copyMem(
      addr dst.data[dstIndex],
      unsafeAddr src.data[srcIndex],
      src.width * 3
    )

  result = okVoid()

# ------------------------------------------------------------------------------
# API: compute letterbox geometry
# ------------------------------------------------------------------------------
proc computeLetterboxInfo*(
  srcWidth, srcHeight, dstWidth, dstHeight: int
): LY[LetterboxInfo] =
  if srcWidth <= 0 or srcHeight <= 0:
    return makeError(
      lyInvalidArgument,
      &"source size must be > 0: srcWidth={srcWidth}, srcHeight={srcHeight}"
    ).err

  if dstWidth <= 0 or dstHeight <= 0:
    return makeError(
      lyInvalidArgument,
      &"destination size must be > 0: dstWidth={dstWidth}, dstHeight={dstHeight}"
    ).err

  let scale = min(dstWidth.float64 / srcWidth.float64,
                  dstHeight.float64 / srcHeight.float64)
  let resizedWidth = max(1, int(srcWidth.float64 * scale))
  let resizedHeight = max(1, int(srcHeight.float64 * scale))

  var info: LetterboxInfo
  info.srcWidth = srcWidth
  info.srcHeight = srcHeight
  info.dstWidth = dstWidth
  info.dstHeight = dstHeight
  info.resizedWidth = resizedWidth
  info.resizedHeight = resizedHeight
  info.offsetX = (dstWidth - resizedWidth) div 2
  info.offsetY = (dstHeight - resizedHeight) div 2
  info.scaleX = resizedWidth.float32 / srcWidth.float32
  info.scaleY = resizedHeight.float32 / srcHeight.float32

  result = ok(info)

# ------------------------------------------------------------------------------
# API: RGB -> RGB letterbox into pre-allocated destination view
# ------------------------------------------------------------------------------
proc letterboxInto*(
  src: RgbView,
  dst: RgbView,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source RGB view is invalid").err

  ?requireValidRgbView(dst, "destination")

  let info = ?computeLetterboxInfo(src.width, src.height, dst.width, dst.height)
  dst.fill(padColor)

  let resizedDst = dst.subRgbView(info)
  ?scaleInto(src, resizedDst, mode)

  result = ok(info)

# ------------------------------------------------------------------------------
# API: RGB -> RGB letterbox into pre-allocated destination image
# ------------------------------------------------------------------------------
proc letterboxInto*(
  src: RgbImage,
  dst: var RgbImage,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source RGB image is invalid").err

  if not dst.isValid:
    return makeError(lyInvalidArgument, "destination RGB image is invalid").err

  result = letterboxInto(src.toRgbView(), dst.toRgbView(), padColor, mode)

# ------------------------------------------------------------------------------
# API: RGB -> RGB letterbox and allocate destination
# ------------------------------------------------------------------------------
proc letterbox*(
  src: RgbImage,
  dstWidth: int,
  dstHeight: int,
  padValue: uint8 = 114,
  mode: FilterMode = filterBilinear
): LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source image is invalid").err

  var dst = ?allocRgbImage(dstWidth, dstHeight)
  let info = ?letterboxInto(src, dst, RgbPadColor(r: padValue, g: padValue, b: padValue), mode)

  result = ok((image: dst, info: info))

# ------------------------------------------------------------------------------
# API: RGBA -> RGB letterbox into pre-allocated destination view
# ------------------------------------------------------------------------------
proc toRgbLetterboxInto*(
  src: RgbaView,
  dst: RgbView,
  scratch: var RgbaImage,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source RGBA view is invalid").err

  ?requireValidRgbView(dst, "destination")

  let info = ?computeLetterboxInfo(src.width, src.height, dst.width, dst.height)
  dst.fill(padColor)

  ?requireScratch(scratch, info.resizedWidth, info.resizedHeight)
  ?scaleInto(src, scratch.toRgbaView(), mode)

  let rgbDst = dst.subRgbView(info)
  let rc = ARGBToRAW(
    scratch.rgbaDataPtr(),
    scratch.stride.cint,
    rgbDst.data,
    rgbDst.stride.cint,
    info.resizedWidth.cint,
    info.resizedHeight.cint
  )

  if rc != 0:
    return makeError(
      lyOperationFailed,
      &"ARGBToRAW failed for RGBA->RGB letterbox: rc={rc}, " &
      &"src={src.width}x{src.height}, dst={dst.width}x{dst.height}"
    ).err

  result = ok(info)

# ------------------------------------------------------------------------------
# API: RGBA -> RGB letterbox into pre-allocated destination view
# ------------------------------------------------------------------------------
proc toRgbLetterboxInto*(
  src: RgbaView,
  dst: RgbView,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  var scratch: RgbaImage
  result = toRgbLetterboxInto(src, dst, scratch, padColor, mode)

# ------------------------------------------------------------------------------
# API: RGBA -> RGB letterbox into pre-allocated destination image
# ------------------------------------------------------------------------------
proc toRgbLetterboxInto*(
  src: RgbaImage,
  dst: var RgbImage,
  scratch: var RgbaImage,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source RGBA image is invalid").err

  if not dst.isValid:
    return makeError(lyInvalidArgument, "destination RGB image is invalid").err

  result = toRgbLetterboxInto(src.toRgbaView(), dst.toRgbView(), scratch, padColor, mode)

# ------------------------------------------------------------------------------
# API: RGBA -> RGB letterbox into pre-allocated destination image
# ------------------------------------------------------------------------------
proc toRgbLetterboxInto*(
  src: RgbaImage,
  dst: var RgbImage,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  var scratch: RgbaImage
  result = toRgbLetterboxInto(src, dst, scratch, padColor, mode)

# ------------------------------------------------------------------------------
# API: RGBA -> RGB letterbox and allocate destination
# ------------------------------------------------------------------------------
proc toRgbLetterbox*(
  src: RgbaImage,
  dstWidth: int = 640,
  dstHeight: int = 640,
  padValue: uint8 = 114,
  mode: FilterMode = filterBilinear
): LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source RGBA image is invalid").err

  var dst = ?allocRgbImage(dstWidth, dstHeight)
  let info = ?toRgbLetterboxInto(
    src,
    dst,
    RgbPadColor(r: padValue, g: padValue, b: padValue),
    mode
  )

  result = ok((image: dst, info: info))

# ------------------------------------------------------------------------------
# API: NV12 -> RGB letterbox into pre-allocated destination view
# ------------------------------------------------------------------------------
proc toRgbLetterboxInto*(
  src: Nv12View,
  dst: RgbView,
  scratch: var Nv12Image,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source NV12 view is invalid").err

  ?requireValidRgbView(dst, "destination")

  let info = ?computeLetterboxInfo(src.width, src.height, dst.width, dst.height)
  dst.fill(padColor)

  if not scratch.isValid or scratch.width != info.resizedWidth or scratch.height != info.resizedHeight:
    scratch = ?allocNv12Image(info.resizedWidth, info.resizedHeight)

  ?scaleInto(src, scratch.toNv12View(), mode)

  let rgbDst = dst.subRgbView(info)
  let rc = NV12ToRGB24(
    (if scratch.y.len == 0: nil else: addr scratch.y[0]),
    scratch.strideY.cint,
    (if scratch.uv.len == 0: nil else: addr scratch.uv[0]),
    scratch.strideUV.cint,
    rgbDst.data,
    rgbDst.stride.cint,
    info.resizedWidth.cint,
    info.resizedHeight.cint
  )

  if rc != 0:
    return makeError(lyOperationFailed, &"NV12ToRGB24 failed: rc={rc}").err

  result = ok(info)

# ------------------------------------------------------------------------------
# API: NV12 -> RGB letterbox and allocate destination
# ------------------------------------------------------------------------------
proc toRgbLetterbox*(
  src: Nv12Image,
  dstWidth: int = 640,
  dstHeight: int = 640,
  padValue: uint8 = 114,
  mode: FilterMode = filterBilinear
): LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source NV12 image is invalid").err

  var dst = ?allocRgbImage(dstWidth, dstHeight)
  var scratch: Nv12Image
  let info = ?toRgbLetterboxInto(
    src.toNv12View(),
    dst.toRgbView(),
    scratch,
    RgbPadColor(r: padValue, g: padValue, b: padValue),
    mode
  )

  result = ok((image: dst, info: info))

# ------------------------------------------------------------------------------
# API: I420 -> RGB letterbox into pre-allocated destination view
# ------------------------------------------------------------------------------
proc toRgbLetterboxInto*(
  src: I420View,
  dst: RgbView,
  scratch: var I420Image,
  padColor: RgbPadColor = yoloPadRgb,
  mode: FilterMode = filterBilinear
): LY[LetterboxInfo] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source I420 view is invalid").err

  ?requireValidRgbView(dst, "destination")

  let info = ?computeLetterboxInfo(src.width, src.height, dst.width, dst.height)
  dst.fill(padColor)

  if not scratch.isValid or scratch.width != info.resizedWidth or scratch.height != info.resizedHeight:
    scratch = ?allocI420Image(info.resizedWidth, info.resizedHeight)

  ?scaleInto(src, scratch.toI420View(), mode)

  let rgbDst = dst.subRgbView(info)
  let rc = I420ToRGB24(
    (if scratch.y.len == 0: nil else: addr scratch.y[0]),
    scratch.strideY.cint,
    (if scratch.u.len == 0: nil else: addr scratch.u[0]),
    scratch.strideU.cint,
    (if scratch.v.len == 0: nil else: addr scratch.v[0]),
    scratch.strideV.cint,
    rgbDst.data,
    rgbDst.stride.cint,
    info.resizedWidth.cint,
    info.resizedHeight.cint
  )

  if rc != 0:
    return makeError(lyOperationFailed, &"I420ToRGB24 failed: rc={rc}").err

  result = ok(info)

# ------------------------------------------------------------------------------
# API: I420 -> RGB letterbox and allocate destination
# ------------------------------------------------------------------------------
proc toRgbLetterbox*(
  src: I420Image,
  dstWidth: int = 640,
  dstHeight: int = 640,
  padValue: uint8 = 114,
  mode: FilterMode = filterBilinear
): LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source I420 image is invalid").err

  var dst = ?allocRgbImage(dstWidth, dstHeight)
  var scratch: I420Image
  let info = ?toRgbLetterboxInto(
    src.toI420View(),
    dst.toRgbView(),
    scratch,
    RgbPadColor(r: padValue, g: padValue, b: padValue),
    mode
  )

  result = ok((image: dst, info: info))
