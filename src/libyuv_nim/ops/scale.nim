import std/strformat
import results
import ../bindings/types
import ../core/errors
import ../core/image_types
import ../core/image_alloc

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc ptrOrNil(s: seq[uint8]): ptr uint8 =
  if s.len == 0:
    result = nil
    return

  result = cast[ptr uint8](unsafeAddr s[0])

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc ptrOrNil(s: var seq[uint8]): ptr uint8 =
  if s.len == 0:
    result = nil
    return

  result = addr s[0]

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc toCFilterMode(mode: FilterMode): enum_FilterMode =
  case mode
  of filterNone:
    result = kFilterNone
  of filterLinear:
    result = kFilterLinear
  of filterBilinear:
    result = kFilterBilinear
  of filterBox:
    result = kFilterBox

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requirePositiveDimension(width, height: int): LY[void] =
  if width <= 0:
    return err(makeError(
      lyInvalidArgument,
      &"width must be > 0: width={width}, height={height}"
    ))

  if height <= 0:
    return err(makeError(
      lyInvalidArgument,
      &"height must be > 0: width={width}, height={height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidImage(src: Nv12Image): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid NV12 image: width={src.width}, height={src.height}, " &
      &"y.len={src.y.len}, uv.len={src.uv.len}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidImage(src: I420Image): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid I420 image: width={src.width}, height={src.height}, " &
      &"y.len={src.y.len}, u.len={src.u.len}, v.len={src.v.len}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidImage(src: RgbImage): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid RGB image: width={src.width}, height={src.height}, " &
      &"stride={src.stride}, data.len={src.data.len}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidImage(src: RgbaImage): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid RGBA image: width={src.width}, height={src.height}, " &
      &"stride={src.stride}, data.len={src.data.len}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidView(src: Nv12View, name: string): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid {name} NV12 view: width={src.width}, height={src.height}, " &
      &"strideY={src.strideY}, strideUV={src.strideUV}, " &
      &"y.isNil={src.y == nil}, uv.isNil={src.uv == nil}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidView(src: I420View, name: string): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid {name} I420 view: width={src.width}, height={src.height}, " &
      &"strideY={src.strideY}, strideU={src.strideU}, strideV={src.strideV}, " &
      &"y.isNil={src.y == nil}, u.isNil={src.u == nil}, v.isNil={src.v == nil}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidView(src: RgbView, name: string): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid {name} RGB view: width={src.width}, height={src.height}, " &
      &"stride={src.stride}, data.isNil={src.data == nil}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requireValidView(src: RgbaView, name: string): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid {name} RGBA view: width={src.width}, height={src.height}, " &
      &"stride={src.stride}, data.isNil={src.data == nil}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: I420Image): I420View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideU = image.strideU
  result.strideV = image.strideV
  result.y = ptrOrNil(image.y)
  result.u = ptrOrNil(image.u)
  result.v = ptrOrNil(image.v)

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: var I420Image): I420View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideU = image.strideU
  result.strideV = image.strideV
  result.y = ptrOrNil(image.y)
  result.u = ptrOrNil(image.u)
  result.v = ptrOrNil(image.v)

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: Nv12Image): Nv12View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideUV = image.strideUV
  result.y = ptrOrNil(image.y)
  result.uv = ptrOrNil(image.uv)

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: var Nv12Image): Nv12View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideUV = image.strideUV
  result.y = ptrOrNil(image.y)
  result.uv = ptrOrNil(image.uv)

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: RgbImage): RgbView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: var RgbImage): RgbView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: RgbaImage): RgbaView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbaDataPtr()

# ------------------------------------------------------------------------------
# Internal helpers: Image -> borrowed View
# ------------------------------------------------------------------------------
proc toView(image: var RgbaImage): RgbaView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = image.rgbaDataPtr()

# ------------------------------------------------------------------------------
# API: NV12 scale into a pre-allocated destination view
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: Nv12View,
  dst: Nv12View,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidView(src, "source")
  ?requireValidView(dst, "destination")

  let rc = NV12Scale(
    src_y = src.y,
    src_stride_y = src.strideY.cint,
    src_uv = src.uv,
    src_stride_uv = src.strideUV.cint,
    src_width = src.width.cint,
    src_height = src.height.cint,
    dst_y = dst.y,
    dst_stride_y = dst.strideY.cint,
    dst_uv = dst.uv,
    dst_stride_uv = dst.strideUV.cint,
    dst_width = dst.width.cint,
    dst_height = dst.height.cint,
    filtering = toCFilterMode(mode)
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12Scale failed: rc={rc}, src={src.width}x{src.height}, " &
      &"dst={dst.width}x{dst.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# API: NV12 scale into a pre-allocated destination image
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: Nv12Image,
  dst: var Nv12Image,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidImage(src)
  ?requireValidImage(dst)

  result = scaleInto(src.toView(), dst.toView(), mode)

# ------------------------------------------------------------------------------
# API: NV12 scale and allocate destination
# ------------------------------------------------------------------------------
proc scale*(
  src: Nv12Image,
  dstWidth, dstHeight: int,
  mode: FilterMode = filterBilinear
): LY[Nv12Image] =
  ?requirePositiveDimension(dstWidth, dstHeight)
  ?requireValidImage(src)

  var dst = ?allocNv12Image(dstWidth, dstHeight)
  ?scaleInto(src, dst, mode)

  result = ok(dst)

# ------------------------------------------------------------------------------
# API: I420 scale into a pre-allocated destination view
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: I420View,
  dst: I420View,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidView(src, "source")
  ?requireValidView(dst, "destination")

  let rc = I420Scale(
    src_y = src.y,
    src_stride_y = src.strideY.cint,
    src_u = src.u,
    src_stride_u = src.strideU.cint,
    src_v = src.v,
    src_stride_v = src.strideV.cint,
    src_width = src.width.cint,
    src_height = src.height.cint,
    dst_y = dst.y,
    dst_stride_y = dst.strideY.cint,
    dst_u = dst.u,
    dst_stride_u = dst.strideU.cint,
    dst_v = dst.v,
    dst_stride_v = dst.strideV.cint,
    dst_width = dst.width.cint,
    dst_height = dst.height.cint,
    filtering = toCFilterMode(mode)
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"I420Scale failed: rc={rc}, src={src.width}x{src.height}, " &
      &"dst={dst.width}x{dst.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# API: I420 scale into a pre-allocated destination image
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: I420Image,
  dst: var I420Image,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidImage(src)
  ?requireValidImage(dst)

  result = scaleInto(src.toView(), dst.toView(), mode)

# ------------------------------------------------------------------------------
# API: I420 scale and allocate destination
# ------------------------------------------------------------------------------
proc scale*(
  src: I420Image,
  dstWidth, dstHeight: int,
  mode: FilterMode = filterBilinear
): LY[I420Image] =
  ?requirePositiveDimension(dstWidth, dstHeight)
  ?requireValidImage(src)

  var dst = ?allocI420Image(dstWidth, dstHeight)
  ?scaleInto(src, dst, mode)

  result = ok(dst)

# ------------------------------------------------------------------------------
# API: RGB24 scale into a pre-allocated destination view
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: RgbView,
  dst: RgbView,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidView(src, "source")
  ?requireValidView(dst, "destination")

  let rc = RGBScale(
    src_rgb = src.data,
    src_stride_rgb = src.stride.cint,
    src_width = src.width.cint,
    src_height = src.height.cint,
    dst_rgb = dst.data,
    dst_stride_rgb = dst.stride.cint,
    dst_width = dst.width.cint,
    dst_height = dst.height.cint,
    filtering = toCFilterMode(mode)
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"RGBScale failed: rc={rc}, src={src.width}x{src.height}, " &
      &"dst={dst.width}x{dst.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# API: RGB24 scale into a pre-allocated destination image
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: RgbImage,
  dst: var RgbImage,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidImage(src)
  ?requireValidImage(dst)

  result = scaleInto(src.toView(), dst.toView(), mode)

# ------------------------------------------------------------------------------
# API: RGB24 scale and allocate destination
# ------------------------------------------------------------------------------
proc scale*(
  src: RgbImage,
  dstWidth, dstHeight: int,
  mode: FilterMode = filterBilinear
): LY[RgbImage] =
  ?requirePositiveDimension(dstWidth, dstHeight)
  ?requireValidImage(src)

  var dst = ?allocRgbImage(dstWidth, dstHeight)
  ?scaleInto(src, dst, mode)

  result = ok(dst)

# ------------------------------------------------------------------------------
# API: RGBA scale into a pre-allocated destination view
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: RgbaView,
  dst: RgbaView,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidView(src, "source")
  ?requireValidView(dst, "destination")

  let rc = ARGBScale(
    src_argb = src.data,
    src_stride_argb = src.stride.cint,
    src_width = src.width.cint,
    src_height = src.height.cint,
    dst_argb = dst.data,
    dst_stride_argb = dst.stride.cint,
    dst_width = dst.width.cint,
    dst_height = dst.height.cint,
    filtering = toCFilterMode(mode)
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ARGBScale failed for RGBA buffer: rc={rc}, " &
      &"src={src.width}x{src.height}, dst={dst.width}x{dst.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
# API: RGBA scale into a pre-allocated destination image
# ------------------------------------------------------------------------------
proc scaleInto*(
  src: RgbaImage,
  dst: var RgbaImage,
  mode: FilterMode = filterBilinear
): LY[void] =
  ?requireValidImage(src)
  ?requireValidImage(dst)

  result = scaleInto(src.toView(), dst.toView(), mode)

# ------------------------------------------------------------------------------
# API: RGBA scale and allocate destination
# ------------------------------------------------------------------------------
proc scale*(
  src: RgbaImage,
  dstWidth, dstHeight: int,
  mode: FilterMode = filterBilinear
): LY[RgbaImage] =
  ?requirePositiveDimension(dstWidth, dstHeight)
  ?requireValidImage(src)

  var dst = ?allocRgbaImage(dstWidth, dstHeight)
  ?scaleInto(src, dst, mode)

  result = ok(dst)
