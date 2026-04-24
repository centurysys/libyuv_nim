# tests/bench_convert_into_profile.nim
#
# Benchmark the preallocated "into" conversion APIs.
#
# Build:
#   nim c -d:release tests/bench_convert_into_profile.nim
#
# Run:
#   ./tests/bench_convert_into_profile 1920 1080 100 /home/user1/picture.rgba
#
# This assumes src/libyuv_nim/ops/convert.nim has the toRgbaInto/toNv12Into
# additions appended.

import std/monotimes
import std/os
import std/strformat
import std/strutils
import std/times

import libyuv_nim
import libyuv_nim/core/errors
import libyuv_nim/core/image_alloc
import libyuv_nim/core/image_types

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
type
  BenchResult = object
    name: string
    loops: int
    elapsedUs: int64
    checksum: uint64

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc die(msg: string) =
  quit msg, 1

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc checksumBytes(data: openArray[uint8]): uint64 =
  if data.len == 0:
    result = 0
    return

  var h = 1469598103934665603'u64
  let step = max(1, data.len div 4096)
  var i = 0
  while i < data.len:
    h = h xor uint64(data[i])
    h = h * 1099511628211'u64
    i += step
  h = h xor uint64(data[^1])
  result = h

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc checksumRgba(image: RgbaImage): uint64 =
  result = checksumBytes(cast[seq[uint8]](image.data))

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc checksumNv12(image: Nv12Image): uint64 =
  result = checksumBytes(image.y) xor checksumBytes(image.uv)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc fillSyntheticNv12(image: var Nv12Image) =
  for y in 0 ..< image.height:
    let row = y * image.strideY
    for x in 0 ..< image.width:
      image.y[row + x] = uint8((16 + ((x + y) mod 220)) and 0xff)

  for y in 0 ..< ((image.height + 1) div 2):
    let row = y * image.strideUV
    for x in countup(0, image.width - 2, 2):
      image.uv[row + x + 0] = uint8((96 + x + y) and 0xff)
      image.uv[row + x + 1] = uint8((160 + x * 2 + y) and 0xff)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc loadRgba(path: string; image: var RgbaImage) =
  let expected = image.width * image.height * 4
  let data = readFile(path)
  if data.len != expected:
    die(&"input rgba size mismatch: got {data.len}, expected {expected}")

  copyMem(rgbaDataPtr(image), unsafeAddr data[0], expected)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc timeIt(name: string; loops: int; body: proc(): uint64): BenchResult =
  let t0 = getMonoTime()
  var checksum = 0'u64
  for _ in 0 ..< loops:
    checksum = checksum xor body()
  let t1 = getMonoTime()

  result.name = name
  result.loops = loops
  result.elapsedUs = (t1 - t0).inMicroseconds
  result.checksum = checksum

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc printResult(r: BenchResult) =
  let totalMs = float(r.elapsedUs) / 1000.0
  let avgUs = float(r.elapsedUs) / float(r.loops)
  let avgMs = avgUs / 1000.0
  let fps = 1_000_000.0 / avgUs

  echo &"{r.name}"
  echo &"  loops      : {r.loops}"
  echo &"  total      : {totalMs:.3f} ms"
  echo &"  avg        : {avgUs:.3f} us ({avgMs:.3f} ms)"
  echo &"  throughput : {fps:.2f} fps"
  echo &"  checksum   : 0x{r.checksum.toHex}"

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc check(res: LY[void]; what: string) =
  if res.isErr:
    die(what & ": " & $res.error)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc main() =
  if paramCount() notin [3, 4]:
    let exe = getAppFilename().extractFilename()
    echo &"Usage: {exe} <width> <height> <loops> [input.rgba]"
    quit 2

  let width = parseInt(paramStr(1))
  let height = parseInt(paramStr(2))
  let loops = parseInt(paramStr(3))
  let inputPath = if paramCount() == 4: paramStr(4) else: ""

  if width <= 0 or height <= 0:
    die("width/height must be positive")
  if (width mod 2) != 0 or (height mod 2) != 0:
    die("width/height must be even for NV12")
  if loops <= 0:
    die("loops must be positive")

  let rgbaRes = allocRgbaImage(width, height)
  if rgbaRes.isErr:
    die($rgbaRes.error)
  var rgba = rgbaRes.get()

  let rgbaOutRes = allocRgbaImage(width, height)
  if rgbaOutRes.isErr:
    die($rgbaOutRes.error)
  var rgbaOut = rgbaOutRes.get()

  let nv12Res = allocNv12Image(width, height)
  if nv12Res.isErr:
    die($nv12Res.error)
  var nv12 = nv12Res.get()

  let nv12OutRes = allocNv12Image(width, height)
  if nv12OutRes.isErr:
    die($nv12OutRes.error)
  var nv12Out = nv12OutRes.get()

  if inputPath.len > 0:
    loadRgba(inputPath, rgba)
  else:
    # Create RGBA through NV12 -> RGBA so both inputs are non-zero and realistic.
    fillSyntheticNv12(nv12)
    check(nv12.toRgbaInto(rgba), "initial NV12 -> RGBA")
  fillSyntheticNv12(nv12)

  echo &"width       : {width}"
  echo &"height      : {height}"
  echo &"loops       : {loops}"
  echo &"rgba bytes  : {rgba.rgbaDataLen}"
  echo &"nv12 bytes  : {nv12.y.len + nv12.uv.len}"
  if inputPath.len > 0:
    echo &"input rgba  : {inputPath}"
  else:
    echo "input rgba  : synthetic"
  echo ""

  # Warm-up
  check(nv12.toRgbaInto(rgbaOut), "warm-up NV12 -> RGBA")
  check(rgba.toNv12Into(nv12Out), "warm-up RGBA -> NV12")

  printResult(timeIt("Nv12Image.toRgbaInto(var RgbaImage)", loops, proc(): uint64 =
    check(nv12.toRgbaInto(rgbaOut), "NV12 -> RGBA")
    result = checksumRgba(rgbaOut)
  ))

  printResult(timeIt("RgbaImage.toNv12Into(var Nv12Image)", loops, proc(): uint64 =
    check(rgba.toNv12Into(nv12Out), "RGBA -> NV12")
    result = checksumNv12(nv12Out)
  ))

  printResult(timeIt("roundtrip: NV12 -> RGBA -> NV12", loops, proc(): uint64 =
    check(nv12.toRgbaInto(rgbaOut), "roundtrip NV12 -> RGBA")
    check(rgbaOut.toNv12Into(nv12Out), "roundtrip RGBA -> NV12")
    result = checksumNv12(nv12Out)
  ))

when isMainModule:
  main()
