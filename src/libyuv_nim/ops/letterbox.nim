import std/monotimes
import std/strformat
import std/times
import ../core/errors
import ../core/image_types
import ../core/image_alloc
import ./convert
import ./scale

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
type
  LetterboxInfo* = object
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
#
# ------------------------------------------------------------------------------
proc requireNonNegativeOffset(offsetX, offsetY: int): LY[void] =
  if offsetX < 0 or offsetY < 0:
    return makeError(lyInvalidArgument,
        &"offset must be >= 0: offsetX={offsetX}, offsetY={offsetY}").err
  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc fill*(image: var RgbImage, value: uint8) =
  for i in 0 ..< image.data.len:
    image.data[i] = value

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc fill*(image: var RgbImage, r, g, b: uint8) =
  var i = 0
  while i + 2 < image.data.len:
    image.data[i] = r
    image.data[i + 1] = g
    image.data[i + 2] = b
    inc i, 3

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc blit*(dst: var RgbImage, src: RgbImage, dstX, dstY: int): LY[void] =
  if not dst.isValid:
    return makeError(lyInvalidArgument, "destination image is invalid").err
  if not src.isValid:
    return makeError(lyInvalidArgument, "source image is invalid").err
  let offsetCheck = requireNonNegativeOffset(dstX, dstY)
  if offsetCheck.isErr:
    return err(offsetCheck.error)
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
#
# ------------------------------------------------------------------------------
proc computeLetterboxInfo*(srcWidth, srcHeight, dstWidth, dstHeight: int): LY[LetterboxInfo] =
  if srcWidth <= 0 or srcHeight <= 0:
    return makeError(lyInvalidArgument,
        &"source size must be > 0: srcWidth={srcWidth}, srcHeight={srcHeight}"
    ).err
  if dstWidth <= 0 or dstHeight <= 0:
    return makeError(lyInvalidArgument,
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
#
# ------------------------------------------------------------------------------
proc letterbox*(src: RgbImage, dstWidth: int, dstHeight: int, padValue: uint8 = 114):
    LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source image is invalid").err
  let infoRes = computeLetterboxInfo(src.width, src.height, dstWidth, dstHeight)
  if infoRes.isErr:
    return err(infoRes.error)
  let info = infoRes.get
  let scaledRes = scale(src, info.resizedWidth, info.resizedHeight)
  if scaledRes.isErr:
    return err(scaledRes.error)
  let dstRes = allocRgbImage(dstWidth, dstHeight)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()
  dst.fill(padValue)
  let blitRes = blit(dst, scaledRes.get, info.offsetX, info.offsetY)
  if blitRes.isErr:
    return err(blitRes.error)
  result = ok((image: dst, info: info))

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgbLetterbox*(src: Nv12Image, dstWidth: int = 640, dstHeight: int = 640,
    padValue: uint8 = 114): LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  proc elapsedTime(ts1, ts0: MonoTime): int64 =
    result = (ts1 - ts0).inMicroseconds()

  var ts0, ts1: MonoTime
  let infoRes = computeLetterboxInfo(src.width, src.height, dstWidth, dstHeight)
  if infoRes.isErr:
    return err(infoRes.error)
  let info = infoRes.get
  ts0 = getMonoTime()
  let scaledRes = scale(src, info.resizedWidth, info.resizedHeight)
  ts1 = getMonoTime()
  if scaledRes.isErr:
    return err(scaledRes.error)
  echo &"scale: {elapsedTime(ts1, ts0)} [us]"
  ts0 = getMonoTime()
  let rgbRes = toRgb(scaledRes.get)
  ts1 = getMonoTime()
  if rgbRes.isErr:
    return err(rgbRes.error)
  echo &"toRgb: {elapsedTime(ts1, ts0)} [us]"

  ts0 = getMonoTime()
  let dstRes = allocRgbImage(dstWidth, dstHeight)
  ts1 = getMonoTime()
  if dstRes.isErr:
    return err(dstRes.error)
  echo &"allocRgbImage: {elapsedTime(ts1, ts0)} [us]"
  var dst = dstRes.get()
  ts0 = getMonoTime()
  dst.fill(padValue)
  ts1 = getMonoTime()
  echo &"fill: {elapsedTime(ts1, ts0)} [us]"

  ts0 = getMonoTime()
  let blitRes = blit(dst, rgbRes.get, info.offsetX, info.offsetY)
  ts1 = getMonoTime()
  if blitRes.isErr:
    return err(blitRes.error)
  echo &"blit: {elapsedTime(ts1, ts0)} [us]"
  result = ok((image: dst, info: info))
