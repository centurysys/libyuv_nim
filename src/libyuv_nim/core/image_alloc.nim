import std/strformat
import ./image_types
import ./errors

# ------------------------------------------------------------------------------
# Internal helpers
# ------------------------------------------------------------------------------
proc requirePositiveDimension(width, height: int): LY[void] =
  if width <= 0:
    return makeError(
      lyInvalidArgument,
      &"width must be > 0: width={width}, height={height}"
    ).err

  if height <= 0:
    return makeError(
      lyInvalidArgument,
      &"height must be > 0: width={width}, height={height}"
    ).err

  result = okVoid()

# ------------------------------------------------------------------------------
# I420 allocation
# ------------------------------------------------------------------------------
proc allocI420Image*(width, height: int): LY[I420Image] =
  let dimCheck = requirePositiveDimension(width, height)
  if dimCheck.isErr:
    return err(dimCheck.error)

  var image: I420Image
  image.width = width
  image.height = height
  image.strideY = width
  image.strideU = (width + 1) div 2
  image.strideV = (width + 1) div 2
  image.y = newSeq[uint8](image.yPlaneLen)
  image.u = newSeq[uint8](image.uPlaneLen)
  image.v = newSeq[uint8](image.vPlaneLen)

  result = ok(image)

# ------------------------------------------------------------------------------
# NV12 allocation
# ------------------------------------------------------------------------------
proc allocNv12Image*(width, height: int): LY[Nv12Image] =
  let dimCheck = requirePositiveDimension(width, height)
  if dimCheck.isErr:
    return err(dimCheck.error)

  var image: Nv12Image
  image.width = width
  image.height = height
  image.strideY = width
  image.strideUV = width
  image.y = newSeq[uint8](image.yPlaneLen)
  image.uv = newSeq[uint8](image.uvPlaneLen)

  result = ok(image)

# ------------------------------------------------------------------------------
# RGBA allocation
# ------------------------------------------------------------------------------
proc allocRgbaImage*(width, height: int): LY[RgbaImage] =
  let dimCheck = requirePositiveDimension(width, height)
  if dimCheck.isErr:
    return err(dimCheck.error)

  var image: RgbaImage
  image.width = width
  image.height = height
  image.stride = width * 4
  image.data = newSeq[uint8](image.dataLen)

  result = ok(image)

# ------------------------------------------------------------------------------
# RGBA allocation with custom stride
# ------------------------------------------------------------------------------
proc allocRgbaImageWithStride*(width, height, stride: int): LY[RgbaImage] =
  let dimCheck = requirePositiveDimension(width, height)
  if dimCheck.isErr:
    return err(dimCheck.error)

  if stride < width * 4:
    return makeError(
      lyInvalidArgument,
      &"stride is too small for RGBA: stride={stride}, width={width}, " &
      &"minStride={width * 4}"
    ).err

  var image: RgbaImage
  image.width = width
  image.height = height
  image.stride = stride
  image.data = newSeq[uint8](image.dataLen)

  result = ok(image)

# ------------------------------------------------------------------------------
# RGB allocation
# ------------------------------------------------------------------------------
proc allocRgbImage*(width, height: int): LY[RgbImage] =
  let dimCheck = requirePositiveDimension(width, height)
  if dimCheck.isErr:
    return err(dimCheck.error)

  var image: RgbImage
  image.width = width
  image.height = height
  image.stride = width * 3
  image.data = newSeq[uint8](image.dataLen)

  result = ok(image)

# ------------------------------------------------------------------------------
# RGB allocation with custom stride
# ------------------------------------------------------------------------------
proc allocRgbImageWithStride*(width, height, stride: int): LY[RgbImage] =
  let dimCheck = requirePositiveDimension(width, height)
  if dimCheck.isErr:
    return err(dimCheck.error)

  if stride < width * 3:
    return makeError(
      lyInvalidArgument,
      &"stride is too small for RGB24: stride={stride}, width={width}, " &
      &"minStride={width * 3}"
    ).err

  var image: RgbImage
  image.width = width
  image.height = height
  image.stride = stride
  image.data = newSeq[uint8](image.dataLen)

  result = ok(image)
