import std/strformat
import results
import ../bindings/c_api
import ../core/errors
import ../core/image_types
import ../core/image_alloc

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc ptrOrNil(s: var seq[uint8]): ptr uint8 =
  if s.len == 0:
    result = nil
    return

  result = addr s[0]

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc ptrOrNil(s: seq[uint8]): ptr uint8 =
  if s.len == 0:
    result = nil
    return

  result = cast[ptr uint8](unsafeAddr s[0])

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc requireValidImage(src: I420Image): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid I420 image: width={src.width}, height={src.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc requireValidImage(src: Nv12Image): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid NV12 image: width={src.width}, height={src.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc requireValidImage(src: RgbaImage): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid RGBA image: width={src.width}, height={src.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc requireValidImage(src: RgbImage): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid RGB image: width={src.width}, height={src.height}"
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toI420*(src: Nv12Image): LY[I420Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocI420Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = NV12ToI420(
    ptrOrNil(src.y),
    src.strideY.cint,
    ptrOrNil(src.uv),
    src.strideUV.cint,
    ptrOrNil(dst.y),
    dst.strideY.cint,
    ptrOrNil(dst.u),
    dst.strideU.cint,
    ptrOrNil(dst.v),
    dst.strideV.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToI420 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toI420*(src: RgbaImage): LY[I420Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocI420Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = ABGRToI420(
    rgbaDataPtr(src),
    src.stride.cint,
    ptrOrNil(dst.y),
    dst.strideY.cint,
    ptrOrNil(dst.u),
    dst.strideU.cint,
    ptrOrNil(dst.v),
    dst.strideV.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ABGRToI420 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toI420*(src: RgbImage): LY[I420Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocI420Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = RGB24ToI420(
    ptrOrNil(src.data),
    src.stride.cint,
    ptrOrNil(dst.y),
    dst.strideY.cint,
    ptrOrNil(dst.u),
    dst.strideU.cint,
    ptrOrNil(dst.v),
    dst.strideV.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"RGB24ToI420 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgba*(src: I420Image): LY[RgbaImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbaImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = I420ToABGR(
    ptrOrNil(src.y),
    src.strideY.cint,
    ptrOrNil(src.u),
    src.strideU.cint,
    ptrOrNil(src.v),
    src.strideV.cint,
    rgbaDataPtr(dst),
    dst.stride.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"I420ToABGR failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgba*(src: Nv12Image): LY[RgbaImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbaImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = NV12ToABGR(
    ptrOrNil(src.y),
    src.strideY.cint,
    ptrOrNil(src.uv),
    src.strideUV.cint,
    rgbaDataPtr(dst),
    dst.stride.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToABGR failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgb*(src: I420Image): LY[RgbImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = I420ToRGB24(
    ptrOrNil(src.y),
    src.strideY.cint,
    ptrOrNil(src.u),
    src.strideU.cint,
    ptrOrNil(src.v),
    src.strideV.cint,
    ptrOrNil(dst.data),
    dst.stride.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"I420ToRGB24 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgb*(src: Nv12Image): LY[RgbImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)

  var dst = dstRes.get()
  let rc = NV12ToRGB24(
    ptrOrNil(src.y),
    src.strideY.cint,
    ptrOrNil(src.uv),
    src.strideUV.cint,
    ptrOrNil(dst.data),
    dst.stride.cint,
    src.width.cint,
    src.height.cint
  )

  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToRGB24 failed: rc={rc}"
    ))

  result = ok(dst)
