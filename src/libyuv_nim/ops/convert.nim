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
proc requireValidImage(src: I420View): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid I420 view: width={src.width}, height={src.height}"
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
proc requireValidImage(src: Nv12View): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid NV12 view: width={src.width}, height={src.height}"
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
proc requireValidImage(src: RgbaView): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid RGBA view: width={src.width}, height={src.height}"
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
proc requireValidImage(src: RgbView): LY[void] =
  if not src.isValid:
    return err(makeError(
      lyInvalidArgument,
      &"invalid RGB view: width={src.width}, height={src.height}"
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
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.uv), src.strideUV.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.u), dst.strideU.cint,
    ptrOrNil(dst.v), dst.strideV.cint,
    src.width.cint, src.height.cint
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
proc toI420*(src: Nv12View): LY[I420Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocI420Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = NV12ToI420(
    src.y, src.strideY.cint,
    src.uv, src.strideUV.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.u), dst.strideU.cint,
    ptrOrNil(dst.v), dst.strideV.cint,
    src.width.cint, src.height.cint
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
    rgbaDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.u), dst.strideU.cint,
    ptrOrNil(dst.v), dst.strideV.cint,
    src.width.cint, src.height.cint
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
proc toI420*(src: RgbaView): LY[I420Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocI420Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = ABGRToI420(
    rgbaDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.u), dst.strideU.cint,
    ptrOrNil(dst.v), dst.strideV.cint,
    src.width.cint, src.height.cint
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
proc toNv12*(src: RgbaImage): LY[Nv12Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocNv12Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = ABGRToNV12(
    rgbaDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.uv), dst.strideUV.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ARGBToNV12 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toNv12*(src: RgbaView): LY[Nv12Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocNv12Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = ABGRToNV12(
    rgbaDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.uv), dst.strideUV.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ARGBToNV12 failed: rc={rc}"
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
    ptrOrNil(src.data), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.u), dst.strideU.cint,
    ptrOrNil(dst.v), dst.strideV.cint,
    src.width.cint, src.height.cint
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
proc toI420*(src: RgbView): LY[I420Image] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocI420Image(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = RGB24ToI420(
    rgbDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.u), dst.strideU.cint,
    ptrOrNil(dst.v), dst.strideV.cint,
    src.width.cint, src.height.cint
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
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.u), src.strideU.cint,
    ptrOrNil(src.v), src.strideV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
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
proc toRgba*(src: I420View): LY[RgbaImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbaImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = I420ToABGR(
    src.y, src.strideY.cint,
    src.u, src.strideU.cint,
    src.v, src.strideV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
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
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.uv), src.strideUV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
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
proc toRgba*(src: Nv12View): LY[RgbaImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbaImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = NV12ToABGR(
    src.y, src.strideY.cint,
    src.uv, src.strideUV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
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
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.u), src.strideU.cint,
    ptrOrNil(src.v), src.strideV.cint,
    ptrOrNil(dst.data), dst.stride.cint,
    src.width.cint, src.height.cint
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
proc toRgb*(src: I420View): LY[RgbImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = I420ToRGB24(
    src.y, src.strideY.cint,
    src.u, src.strideU.cint,
    src.v, src.strideV.cint,
    ptrOrNil(dst.data), dst.stride.cint,
    src.width.cint, src.height.cint
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
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.uv), src.strideUV.cint,
    ptrOrNil(dst.data), dst.stride.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToRGB24 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgb*(src: Nv12View): LY[RgbImage] =
  let validCheck = requireValidImage(src)
  if validCheck.isErr:
    return err(validCheck.error)

  let dstRes = allocRgbImage(src.width, src.height)
  if dstRes.isErr:
    return err(dstRes.error)
  var dst = dstRes.get()

  let rc = NV12ToRGB24(
    src.y, src.strideY.cint,
    src.uv, src.strideUV.cint,
    ptrOrNil(dst.data), dst.stride.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToRGB24 failed: rc={rc}"
    ))

  result = ok(dst)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc requireSameSize(srcWidth, srcHeight, dstWidth, dstHeight: int;
                     op: string): LY[void] =
  if srcWidth != dstWidth or srcHeight != dstHeight:
    return err(makeError(
      lyInvalidArgument,
      &"{op}: size mismatch: src={srcWidth}x{srcHeight}, dst={dstWidth}x{dstHeight}"
    ))
  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgbaInto*(src: Nv12Image; dst: var RgbaImage): LY[void] =
  ## Convert NV12 image to a preallocated RGBA image.
  ##
  ## Memory order of RGBA is R,G,B,A.
  ## libyuv API name is NV12ToABGR for this byte layout on little-endian systems.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "NV12ToRGBA")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = NV12ToABGR(
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.uv), src.strideUV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToABGR failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgbaInto*(src: Nv12Image; dst: RgbaView): LY[void] =
  ## Convert NV12 image to a borrowed RGBA destination view.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "NV12ToRGBA")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = NV12ToABGR(
    ptrOrNil(src.y), src.strideY.cint,
    ptrOrNil(src.uv), src.strideUV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToABGR failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgbaInto*(src: Nv12View; dst: var RgbaImage): LY[void] =
  ## Convert borrowed NV12 view to a preallocated RGBA image.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "NV12ToRGBA")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = NV12ToABGR(
    src.y, src.strideY.cint,
    src.uv, src.strideUV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToABGR failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toRgbaInto*(src: Nv12View; dst: RgbaView): LY[void] =
  ## Convert borrowed NV12 view to a borrowed RGBA destination view.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "NV12ToRGBA")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = NV12ToABGR(
    src.y, src.strideY.cint,
    src.uv, src.strideUV.cint,
    rgbaDataPtr(dst), dst.stride.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"NV12ToABGR failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toNv12Into*(src: RgbaImage; dst: var Nv12Image): LY[void] =
  ## Convert RGBA image to a preallocated NV12 image.
  ##
  ## Memory order of RGBA is R,G,B,A.
  ## libyuv API name is ABGRToNV12 for this byte layout on little-endian systems.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "RGBAToNV12")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = ABGRToNV12(
    rgbaDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.uv), dst.strideUV.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ABGRToNV12 failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toNv12Into*(src: RgbaImage; dst: Nv12View): LY[void] =
  ## Convert RGBA image to a borrowed NV12 destination view.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "RGBAToNV12")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = ABGRToNV12(
    rgbaDataPtr(src), src.stride.cint,
    dst.y, dst.strideY.cint,
    dst.uv, dst.strideUV.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ABGRToNV12 failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toNv12Into*(src: RgbaView; dst: var Nv12Image): LY[void] =
  ## Convert borrowed RGBA view to a preallocated NV12 image.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "RGBAToNV12")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = ABGRToNV12(
    rgbaDataPtr(src), src.stride.cint,
    ptrOrNil(dst.y), dst.strideY.cint,
    ptrOrNil(dst.uv), dst.strideUV.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ABGRToNV12 failed: rc={rc}",
      rc
    ))

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc toNv12Into*(src: RgbaView; dst: Nv12View): LY[void] =
  ## Convert borrowed RGBA view to a borrowed NV12 destination view.
  let srcCheck = requireValidImage(src)
  if srcCheck.isErr:
    return err(srcCheck.error)

  let dstCheck = requireValidImage(dst)
  if dstCheck.isErr:
    return err(dstCheck.error)

  let sizeCheck = requireSameSize(src.width, src.height, dst.width, dst.height,
                                  "RGBAToNV12")
  if sizeCheck.isErr:
    return err(sizeCheck.error)

  let rc = ABGRToNV12(
    rgbaDataPtr(src), src.stride.cint,
    dst.y, dst.strideY.cint,
    dst.uv, dst.strideUV.cint,
    src.width.cint, src.height.cint
  )
  if rc != 0:
    return err(makeError(
      lyOperationFailed,
      &"ABGRToNV12 failed: rc={rc}",
      rc
    ))

  result = okVoid()
