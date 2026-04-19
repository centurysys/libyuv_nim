import std/os
import std/monotimes
import std/strformat
import std/times
import libyuv_nim

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc clampByte(x: int): uint8 =
  if x < 0:
    result = 0'u8
    return

  if x > 255:
    result = 255'u8
    return

  result = uint8(x)

# ------------------------------------------------------------------------------
#
# BT.601 limited-range approximation
# ------------------------------------------------------------------------------
proc rgbToNv12Yuv(r, g, b: int): tuple[y, u, v: uint8] =
  let y = ((66 * r + 129 * g + 25 * b + 128) shr 8) + 16
  let u = ((-38 * r - 74 * g + 112 * b + 128) shr 8) + 128
  let v = ((112 * r - 94 * g - 18 * b + 128) shr 8) + 128

  result.y = clampByte(y)
  result.u = clampByte(u)
  result.v = clampByte(v)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc fillNv12Rect(image: var Nv12Image; x, y, w, h: int; r, g, b: int) =
  let yuv = rgbToNv12Yuv(r, g, b)

  for py in y ..< y + h:
    let rowBase = py * image.strideY
    for px in x ..< x + w:
      image.y[rowBase + px] = yuv.y

  let uvX = x div 2
  let uvY = y div 2
  let uvW = w div 2
  let uvH = h div 2

  for py in uvY ..< uvY + uvH:
    let rowBase = py * image.strideUV
    for px in uvX ..< uvX + uvW:
      let i = rowBase + px * 2
      image.uv[i + 0] = yuv.u
      image.uv[i + 1] = yuv.v

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc makeQuadrantNv12Image(width, height: int): LY[Nv12Image] =
  let imageRes = allocNv12Image(width, height)
  if imageRes.isErr:
    return err(imageRes.error)

  var image = imageRes.get

  for i in 0 ..< image.y.len:
    image.y[i] = 16'u8

  if image.uv.len >= 2:
    for i in countup(0, image.uv.len - 2, 2):
      image.uv[i + 0] = 128'u8
      image.uv[i + 1] = 128'u8

  let halfWidth = width div 2
  let halfHeight = height div 2

  fillNv12Rect(image, 0, 0, halfWidth, halfHeight, 0, 0, 255)                 # blue
  fillNv12Rect(image, halfWidth, 0, width - halfWidth, halfHeight, 0, 255, 0) # green
  fillNv12Rect(image, 0, halfHeight, halfWidth, height - halfHeight, 255, 0, 0) # red
  fillNv12Rect(image, halfWidth, halfHeight, width - halfWidth, height - halfHeight,
      255, 255, 255) # white

  result = ok(image)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc savePpm(path: string; image: RgbImage): LY[void] =
  let parentDir = splitFile(path).dir
  if parentDir.len > 0:
    createDir(parentDir)
  var f: File
  if not open(f, path, fmWrite):
    return makeError(lyOperationFailed,
        &"failed to open file for write: {path}").err
  defer:
    close(f)
  f.write(&"P6\n{image.width} {image.height}\n255\n")
  let expectedLen = image.height * image.stride
  if image.data.len < expectedLen:
    return makeError(lyInvalidArgument,
        &"RgbImage buffer too small: actual={image.data.len}, expected>={expectedLen}"
    ).err
  for y in 0 ..< image.height:
    let rowStart = y * image.stride
    discard f.writeBuffer(unsafeAddr image.data[rowStart], image.width * 3)
  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc runCase(name: string; srcWidth, srcHeight: int): LY[void] =
  let srcRes = makeQuadrantNv12Image(srcWidth, srcHeight)
  if srcRes.isErr:
    return err(srcRes.error)
  let src = srcRes.get
  let tsStart = getMonoTime()
  let lbRes = toRgbLetterbox(
    src = src,
    dstWidth = 640,
    dstHeight = 640,
    padValue = 114'u8
  )
  let tsEnd = getMonoTime()
  if lbRes.isErr:
    return err(lbRes.error)
  let elapsedTime = (tsEnd - tsStart).inMicroseconds()
  let (image, info) = lbRes.get
  echo &"[{name}]"
  echo &"  srcWidth      = {info.srcWidth}"
  echo &"  srcHeight     = {info.srcHeight}"
  echo &"  resizedWidth  = {info.resizedWidth}"
  echo &"  resizedHeight = {info.resizedHeight}"
  echo &"  offsetX       = {info.offsetX}"
  echo &"  offsetY       = {info.offsetY}"
  echo &"  scaleX        = {info.scaleX:.6f}"
  echo &"  scaleY        = {info.scaleY:.6f}"
  let outPath = &"tests/out/{name}.ppm"
  let saveRes = savePpm(outPath, image)
  if saveRes.isErr:
    return err(saveRes.error)
  echo &"  saved         = {outPath}"
  echo &"  elapsed       = {elapsedTime} [us]"
  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc main(): LY[void] =
  let landscapeRes = runCase("test_letterbox_landscape", 1920, 1080)
  if landscapeRes.isErr:
    return err(landscapeRes.error)
  let portraitRes = runCase("test_letterbox_portrait", 1080, 1920)
  if portraitRes.isErr:
    return err(portraitRes.error)
  result = okVoid()


when isMainModule:
  let res = main()
  if res.isErr:
    stderr.writeLine(res.error.msg)
    quit(1)
