import std/os
import std/strformat
import libyuv_nim
import libyuv_nim/core/errors

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

  fillNv12Rect(image, 0, 0, halfWidth, halfHeight, 0, 0, 255)                    # blue
  fillNv12Rect(image, halfWidth, 0, width - halfWidth, halfHeight, 0, 255, 0)    # green
  fillNv12Rect(image, 0, halfHeight, halfWidth, height - halfHeight, 255, 0, 0)  # red
  fillNv12Rect(image, halfWidth, halfHeight, width - halfWidth, height - halfHeight,
      255, 255, 255)                                                              # white

  result = ok(image)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc dumpPixel(label: string; image: RgbaImage; x, y: int) =
  let rowStride = image.stride div 4
  let pixel = image.data[y * rowStride + x]
  echo &"  {label}: rgba=({pixel.r}, {pixel.g}, {pixel.b}, {pixel.a})"

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc main(): LY[void] =
  let srcRes = makeQuadrantNv12Image(640, 480)
  if srcRes.isErr:
    return err(srcRes.error)

  let rgbaRes = toRgba(srcRes.get)
  if rgbaRes.isErr:
    return err(rgbaRes.error)

  let image = rgbaRes.get

  createDir("tests/out")
  let outPath = "tests/out/test_rgba_quadrants.pam"
  let saveRes = savePam(outPath, image)
  if saveRes.isErr:
    return err(saveRes.error)

  echo "[test_rgba_pam]"
  echo &"  saved  = {outPath}"
  echo &"  width  = {image.width}"
  echo &"  height = {image.height}"
  echo &"  stride = {image.stride}"

  dumpPixel("top-left", image, image.width div 4, image.height div 4)
  dumpPixel("top-right", image, image.width * 3 div 4, image.height div 4)
  dumpPixel("bottom-left", image, image.width div 4, image.height * 3 div 4)
  dumpPixel("bottom-right", image, image.width * 3 div 4, image.height * 3 div 4)

  result = okVoid()


when isMainModule:
  let res = main()
  if res.isErr:
    stderr.writeLine(res.error.msg)
    quit(1)
