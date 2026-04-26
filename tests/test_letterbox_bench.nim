import std/monotimes
import std/os
import std/strformat
import std/strutils
import std/times

import libyuv_nim
import libyuv_nim/core/errors

# ------------------------------------------------------------------------------
# Helpers: byte / color generation
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
# Helpers: BT.601 limited-range approximation
# ------------------------------------------------------------------------------
proc rgbToNv12Yuv(r, g, b: int): tuple[y, u, v: uint8] =
  let y = ((66 * r + 129 * g + 25 * b + 128) shr 8) + 16
  let u = ((-38 * r - 74 * g + 112 * b + 128) shr 8) + 128
  let v = ((112 * r - 94 * g - 18 *  b + 128) shr 8) + 128

  result.y = clampByte(y)
  result.u = clampByte(u)
  result.v = clampByte(v)

# ------------------------------------------------------------------------------
# Helpers: view constructors used by Into() APIs
# ------------------------------------------------------------------------------
proc asNv12View(image: var Nv12Image): Nv12View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideUV = image.strideUV
  result.y = if image.y.len == 0: nil else: addr image.y[0]
  result.uv = if image.uv.len == 0: nil else: addr image.uv[0]

proc asNv12View(image: Nv12Image): Nv12View =
  result.width = image.width
  result.height = image.height
  result.strideY = image.strideY
  result.strideUV = image.strideUV
  result.y = if image.y.len == 0: nil else: cast[ptr uint8](unsafeAddr image.y[0])
  result.uv = if image.uv.len == 0: nil else: cast[ptr uint8](unsafeAddr image.uv[0])

proc asRgbView(image: var RgbImage): RgbView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = if image.data.len == 0: nil else: addr image.data[0]

proc asRgbView(image: RgbImage): RgbView =
  result.width = image.width
  result.height = image.height
  result.stride = image.stride
  result.data = if image.data.len == 0: nil else: cast[ptr uint8](unsafeAddr image.data[0])

# ------------------------------------------------------------------------------
# Helpers: source image generation
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

  fillNv12Rect(image, 0, 0, halfWidth, halfHeight, 0, 0, 255)
  fillNv12Rect(image, halfWidth, 0, width - halfWidth, halfHeight, 0, 255, 0)
  fillNv12Rect(image, 0, halfHeight, halfWidth, height - halfHeight, 255, 0, 0)
  fillNv12Rect(image, halfWidth, halfHeight, width - halfWidth, height - halfHeight,
               255, 255, 255)

  result = ok(image)

# ------------------------------------------------------------------------------
# Legacy path: emulate the previous implementation.
#
# This intentionally keeps the old allocation/copy structure:
#   NV12 scale -> temporary NV12
#   temporary NV12 -> temporary RGB
#   allocate final RGB
#   fill padding
#   blit temporary RGB into final RGB
# ------------------------------------------------------------------------------
proc legacyNv12ToRgbLetterbox(
  src: Nv12Image,
  dstWidth: int,
  dstHeight: int,
  padValue: uint8 = 114'u8
): LY[tuple[image: RgbImage, info: LetterboxInfo]] =
  if not src.isValid:
    return makeError(lyInvalidArgument, "source NV12 image is invalid").err

  let info = ?computeLetterboxInfo(src.width, src.height, dstWidth, dstHeight)
  let scaled = ?scale(src, info.resizedWidth, info.resizedHeight)
  let rgb = ?toRgb(scaled)

  var dst = ?allocRgbImage(dstWidth, dstHeight)
  dst.fill(padValue)

  ?blit(dst, rgb, info.offsetX, info.offsetY)

  result = ok((image: dst, info: info))

# ------------------------------------------------------------------------------
# Benchmark helpers
# ------------------------------------------------------------------------------
type BenchStats = object
  minUs: int64
  maxUs: int64
  avgUs: float64
  lastChecksum: uint64

proc checksum(image: RgbImage): uint64 =
  ## FNV-1a over RGB data. This is outside the timed region.
  var h = 1469598103934665603'u64
  for b in image.data:
    h = h xor uint64(b)
    h = h * 1099511628211'u64

  result = h

proc parseEnvInt(name: string; defaultValue: int): int =
  let value = getEnv(name)
  if value.len == 0:
    result = defaultValue
    return

  try:
    result = parseInt(value)
  except ValueError:
    result = defaultValue

proc updateStats(stats: var BenchStats; elapsedUs: int64; checksumValue: uint64;
                 n: int) =
  if n == 0:
    stats.minUs = elapsedUs
    stats.maxUs = elapsedUs
    stats.avgUs = elapsedUs.float64
  else:
    if elapsedUs < stats.minUs:
      stats.minUs = elapsedUs
    if elapsedUs > stats.maxUs:
      stats.maxUs = elapsedUs
    stats.avgUs = stats.avgUs + elapsedUs.float64

  stats.lastChecksum = checksumValue

proc finishStats(stats: var BenchStats; reps: int) =
  if reps > 0:
    stats.avgUs = stats.avgUs / reps.float64

proc benchLegacy(
  src: Nv12Image,
  dstWidth: int,
  dstHeight: int,
  warmup: int,
  reps: int
): LY[BenchStats] =
  for _ in 0 ..< warmup:
    let warmupRes = legacyNv12ToRgbLetterbox(src, dstWidth, dstHeight)
    if warmupRes.isErr:
      return err(warmupRes.error)

  var stats: BenchStats

  for i in 0 ..< reps:
    let tsStart = getMonoTime()
    let lbRes = legacyNv12ToRgbLetterbox(src, dstWidth, dstHeight)
    let tsEnd = getMonoTime()

    if lbRes.isErr:
      return err(lbRes.error)

    let elapsedUs = (tsEnd - tsStart).inMicroseconds()
    let checksumValue = checksum(lbRes.get.image)
    updateStats(stats, elapsedUs, checksumValue, i)

  finishStats(stats, reps)
  result = ok(stats)

proc benchInto(
  src: Nv12Image,
  dstWidth: int,
  dstHeight: int,
  warmup: int,
  reps: int
): LY[BenchStats] =
  var dst = ?allocRgbImage(dstWidth, dstHeight)
  var scratch: Nv12Image
  let srcView = src.asNv12View()
  let dstView = dst.asRgbView()

  for _ in 0 ..< warmup:
    let warmupRes = toRgbLetterboxInto(srcView, dstView, scratch, yoloPadRgb)
    if warmupRes.isErr:
      return err(warmupRes.error)

  var stats: BenchStats

  for i in 0 ..< reps:
    let tsStart = getMonoTime()
    let lbRes = toRgbLetterboxInto(srcView, dstView, scratch, yoloPadRgb)
    let tsEnd = getMonoTime()

    if lbRes.isErr:
      return err(lbRes.error)

    let elapsedUs = (tsEnd - tsStart).inMicroseconds()
    let checksumValue = checksum(dst)
    updateStats(stats, elapsedUs, checksumValue, i)

  finishStats(stats, reps)
  result = ok(stats)

proc printStats(name: string; legacyStats, intoStats: BenchStats) =
  let ratio = legacyStats.avgUs / intoStats.avgUs
  let saved = legacyStats.avgUs - intoStats.avgUs

  echo &"[{name}]"
  echo &"  legacy: min={legacyStats.minUs} us, avg={legacyStats.avgUs:.2f} us, max={legacyStats.maxUs} us"
  echo &"  into  : min={intoStats.minUs} us, avg={intoStats.avgUs:.2f} us, max={intoStats.maxUs} us"
  echo &"  speed : {ratio:.3f}x faster, saved={saved:.2f} us/frame"
  echo &"  checksum legacy=0x{legacyStats.lastChecksum.toHex}, into=0x{intoStats.lastChecksum.toHex}"

  if legacyStats.lastChecksum != intoStats.lastChecksum:
    echo "  WARNING: checksum differs. Check whether the new path changed conversion order or color layout."

proc runCase(
  name: string,
  srcWidth: int,
  srcHeight: int,
  dstWidth: int,
  dstHeight: int,
  warmup: int,
  reps: int
): LY[void] =
  let srcRes = makeQuadrantNv12Image(srcWidth, srcHeight)
  if srcRes.isErr:
    return err(srcRes.error)

  let src = srcRes.get

  let info = ?computeLetterboxInfo(srcWidth, srcHeight, dstWidth, dstHeight)
  echo &"[{name}: geometry]"
  echo &"  src={srcWidth}x{srcHeight}, dst={dstWidth}x{dstHeight}"
  echo &"  resized={info.resizedWidth}x{info.resizedHeight}, offset=({info.offsetX}, {info.offsetY})"
  echo &"  warmup={warmup}, reps={reps}"

  let legacyStats = ?benchLegacy(src, dstWidth, dstHeight, warmup, reps)
  let intoStats = ?benchInto(src, dstWidth, dstHeight, warmup, reps)

  printStats(name, legacyStats, intoStats)
  result = okVoid()

proc main(): LY[void] =
  let dstWidth = parseEnvInt("LB_DST_W", 640)
  let dstHeight = parseEnvInt("LB_DST_H", 640)
  let warmup = parseEnvInt("LB_WARMUP", 10)
  let reps = parseEnvInt("LB_REPS", 100)

  ?runCase("nv12_landscape", 1920, 1080, dstWidth, dstHeight, warmup, reps)
  ?runCase("nv12_portrait", 1080, 1920, dstWidth, dstHeight, warmup, reps)

  result = okVoid()

when isMainModule:
  let res = main()
  if res.isErr:
    stderr.writeLine(res.error.msg)
    quit(1)
