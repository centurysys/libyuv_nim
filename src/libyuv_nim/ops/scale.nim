import std/strformat
import results

import ../bindings/c_api
import ../bindings/types
import ../core/errors
import ../core/image_types
import ../core/image_alloc

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc ptrOrNil(s: seq[uint8]): ptr uint8 =
  if s.len == 0:
    result = nil
    return

  result = addr s[0]

# ------------------------------------------------------------------------------
#
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
#
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
#
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
#
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
#
# ------------------------------------------------------------------------------
proc scale*(src: Nv12Image, dstWidth, dstHeight: int,
            mode: FilterMode = filterBilinear): LY[Nv12Image] =
  let dimCheck = requirePositiveDimension(dstWidth, dstHeight)
  if dimCheck.isErr:
    return err(dimCheck.error)

  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let allocResult = allocNv12Image(dstWidth, dstHeight)
  if allocResult.isErr:
    return err(allocResult.error)

  var dst = allocResult.get
  var srcCopy = src

  let rc = NV12Scale(
    ptrOrNil(srcCopy.y),
    src.strideY.cint,
    ptrOrNil(srcCopy.uv),
    src.strideUV.cint,
    src.width.cint,
    src.height.cint,
    ptrOrNil(dst.y),
    dst.strideY.cint,
    ptrOrNil(dst.uv),
    dst.strideUV.cint,
    dst.width.cint,
    dst.height.cint,
    mode
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12Scale failed: rc={rc}, src={src.width}x{src.height}, dst={dstWidth}x{dstHeight}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc scale*(src: I420Image, dstWidth, dstHeight: int,
            mode: FilterMode = filterBilinear): LY[I420Image] =
  let dimCheck = requirePositiveDimension(dstWidth, dstHeight)
  if dimCheck.isErr:
    return err(dimCheck.error)

  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let allocResult = allocI420Image(dstWidth, dstHeight)
  if allocResult.isErr:
    return err(allocResult.error)

  var dst = allocResult.get
  var srcCopy = src

  let rc = I420Scale(
    ptrOrNil(srcCopy.y),
    src.strideY.cint,
    ptrOrNil(srcCopy.u),
    src.strideU.cint,
    ptrOrNil(srcCopy.v),
    src.strideV.cint,
    src.width.cint,
    src.height.cint,
    ptrOrNil(dst.y),
    dst.strideY.cint,
    ptrOrNil(dst.u),
    dst.strideU.cint,
    ptrOrNil(dst.v),
    dst.strideV.cint,
    dst.width.cint,
    dst.height.cint,
    mode
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"I420Scale failed: rc={rc}, src={src.width}x{src.height}, dst={dstWidth}x{dstHeight}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc scale*(src: RgbImage, dstWidth, dstHeight: int,
            mode: FilterMode = filterBilinear): LY[RgbImage] =
  let dimCheck = requirePositiveDimension(dstWidth, dstHeight)
  if dimCheck.isErr:
    return err(dimCheck.error)

  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      "src image is invalid"
    ))

  let dstRes = allocRgbImage(dstWidth, dstHeight)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get

  let rc = RGBScale(
    src_rgb = ptrOrNil(src.data),
    src_stride_rgb = src.stride.cint,
    src_width = src.width.cint,
    src_height = src.height.cint,
    dst_rgb = ptrOrNil(dst.data),
    dst_stride_rgb = dst.stride.cint,
    dst_width = dst.width.cint,
    dst_height = dst.height.cint,
    filtering = toCFilterMode(mode)
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"RGBScale failed: rc={rc}"
    ))

  result = ok(dst)
