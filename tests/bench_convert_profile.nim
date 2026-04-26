# tests/bench_convert_profile.nim
#
# Purpose:
#   Profile libyuv_nim conversion costs with timing points separated enough to
#   distinguish:
#
#   - allocation/fill overhead
#   - high-level API cost, which allocates destination images
#   - low-level direct libyuv calls into preallocated buffers
#   - direct ABGR -> NV12 vs ABGR -> I420 -> NV12
#   - optional copy/memset baseline
#
# Build:
#   nim c -d:release tests/bench_convert_profile.nim
#
# Run examples:
#   ./tests/bench_convert_profile 1920 1080 100
#   ./tests/bench_convert_profile 1920 1080 100 /home/user1/picture.rgba
#
# Notes:
#   libyuv_nim uses RGBA memory layout as R,G,B,A and calls libyuv ABGR APIs
#   internally on little-endian systems.

import std/monotimes
import std/os
import std/strformat
import std/strutils
import std/times

import libyuv_nim
import libyuv_nim/bindings/types
import libyuv_nim/core/errors

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
proc usage() =
  let exe = getAppFilename().extractFilename()
  echo &"Usage: {exe} <width> <height> <loops> [input.rgba]"
  echo ""
  echo "Examples:"
  echo &"  {exe} 1920 1080 100"
  echo &"  {exe} 1920 1080 100 /home/user1/picture.rgba"

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc die(msg: string) =
  quit msg, 1

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc ptrOrNil(s: var seq[uint8]): ptr uint8 {.inline.} =
  if s.len == 0:
    result = nil
    return
  result = addr s[0]

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc ptrOrNil[T](s: var seq[T]): ptr T {.inline.} =
  if s.len == 0:
    result = nil
    return
  result = addr s[0]

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc checksumBytes(data: openArray[uint8]): uint64 =
  ## Cheap sparse checksum. This is intentionally not cryptographic.
  ## It prevents the compiler from making the benchmark obviously dead.
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
proc fillSyntheticRgba(rgba: var seq[uint8]; width, height: int) =
  ## RGBA byte order: R, G, B, A
  for y in 0 ..< height:
    let row = y * width * 4
    for x in 0 ..< width:
      let i = row + x * 4
      rgba[i + 0] = uint8((x + y) and 0xff)
      rgba[i + 1] = uint8((x * 2 + y) and 0xff)
      rgba[i + 2] = uint8((x + y * 3) and 0xff)
      rgba[i + 3] = 255'u8

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc fillSyntheticNv12(yPlane, uvPlane: var seq[uint8]; width, height: int) =
  for y in 0 ..< height:
    let row = y * width
    for x in 0 ..< width:
      yPlane[row + x] = uint8((16 + ((x + y) mod 220)) and 0xff)

  for y in 0 ..< (height div 2):
    let row = y * width
    for x in countup(0, width - 2, 2):
      uvPlane[row + x + 0] = uint8((96 + x + y) and 0xff)
      uvPlane[row + x + 1] = uint8((160 + x * 2 + y) and 0xff)

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
proc checkRc(op: string; rc: cint) =
  if rc != 0:
    die(&"{op} failed: rc={rc}")

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc main() =
  if paramCount() notin [3, 4]:
    usage()
    quit 2

  let width = parseInt(paramStr(1))
  let height = parseInt(paramStr(2))
  let loops = parseInt(paramStr(3))
  let rgbaPath = if paramCount() == 4: paramStr(4) else: ""

  if width <= 0 or height <= 0:
    die("width/height must be positive")
  if (width mod 2) != 0 or (height mod 2) != 0:
    die("width/height must be even for NV12")
  if loops <= 0:
    die("loops must be positive")

  let rgbaSize = width * height * 4
  let ySize = width * height
  let uvSize = width * (height div 2)
  let nv12Size = ySize + uvSize
  let chromaWidth = (width + 1) div 2
  let chromaHeight = (height + 1) div 2
  let i420USize = chromaWidth * chromaHeight
  let i420VSize = chromaWidth * chromaHeight

  echo &"width       : {width}"
  echo &"height      : {height}"
  echo &"loops       : {loops}"
  echo &"rgba bytes  : {rgbaSize}"
  echo &"nv12 bytes  : {nv12Size}"
  if rgbaPath.len > 0:
    echo &"input rgba  : {rgbaPath}"
  else:
    echo "input rgba  : synthetic"
  echo ""

  # --------------------------------------------------------------------------
  # Input source preparation
  # --------------------------------------------------------------------------
  let tAlloc0 = getMonoTime()

  var rgbaBytes = newSeq[uint8](rgbaSize)
  var nv12Y = newSeq[uint8](ySize)
  var nv12UV = newSeq[uint8](uvSize)
  var outRgba = newSeq[uint8](rgbaSize)
  var outY = newSeq[uint8](ySize)
  var outUV = newSeq[uint8](uvSize)
  var tmpY = newSeq[uint8](ySize)
  var tmpU = newSeq[uint8](i420USize)
  var tmpV = newSeq[uint8](i420VSize)
  var copyDst = newSeq[uint8](max(rgbaSize, nv12Size))

  let tAlloc1 = getMonoTime()

  if rgbaPath.len > 0:
    let data = readFile(rgbaPath)
    if data.len != rgbaSize:
      die(&"input rgba size mismatch: got {data.len}, expected {rgbaSize}")
    copyMem(addr rgbaBytes[0], unsafeAddr data[0], rgbaSize)
  else:
    fillSyntheticRgba(rgbaBytes, width, height)

  fillSyntheticNv12(nv12Y, nv12UV, width, height)

  let tFill1 = getMonoTime()

  echo &"alloc       : {float((tAlloc1 - tAlloc0).inMicroseconds) / 1000.0:.3f} ms"
  echo &"fill/read   : {float((tFill1 - tAlloc1).inMicroseconds) / 1000.0:.3f} ms"
  echo ""

  # --------------------------------------------------------------------------
  # libyuv_nim high-level images/views
  # --------------------------------------------------------------------------
  var nv12Image = Nv12Image(
    width: width,
    height: height,
    strideY: width,
    strideUV: width,
    y: nv12Y,
    uv: nv12UV
  )

  var rgbaImage = RgbaImage(
    width: width,
    height: height,
    stride: width * 4,
    data: cast[seq[PixelRGBA]](rgbaBytes)
  )

  var nv12View = Nv12View(
    width: width,
    height: height,
    strideY: width,
    strideUV: width,
    y: ptrOrNil(nv12Y),
    uv: ptrOrNil(nv12UV)
  )

  var rgbaView = RgbaView(
    width: width,
    height: height,
    stride: width * 4,
    data: ptrOrNil(rgbaBytes)
  )

  # --------------------------------------------------------------------------
  # Warm-up
  # --------------------------------------------------------------------------
  checkRc("NV12ToABGR warm-up", NV12ToABGR(
    ptrOrNil(nv12Y), width.cint,
    ptrOrNil(nv12UV), width.cint,
    ptrOrNil(outRgba), (width * 4).cint,
    width.cint, height.cint
  ))

  checkRc("ABGRToNV12 warm-up", ABGRToNV12(
    ptrOrNil(rgbaBytes), (width * 4).cint,
    ptrOrNil(outY), width.cint,
    ptrOrNil(outUV), width.cint,
    width.cint, height.cint
  ))

  echo "== direct low-level libyuv calls, destination preallocated =="
  printResult(timeIt("NV12ToABGR -> preallocated RGBA", loops, proc(): uint64 =
    let rc = NV12ToABGR(
      ptrOrNil(nv12Y), width.cint,
      ptrOrNil(nv12UV), width.cint,
      ptrOrNil(outRgba), (width * 4).cint,
      width.cint, height.cint
    )
    checkRc("NV12ToABGR", rc)
    result = checksumBytes(outRgba)
  ))

  printResult(timeIt("ABGRToNV12 -> preallocated NV12", loops, proc(): uint64 =
    let rc = ABGRToNV12(
      ptrOrNil(rgbaBytes), (width * 4).cint,
      ptrOrNil(outY), width.cint,
      ptrOrNil(outUV), width.cint,
      width.cint, height.cint
    )
    checkRc("ABGRToNV12", rc)
    result = checksumBytes(outY) xor checksumBytes(outUV)
  ))

  printResult(timeIt("ABGRToI420 + I420ToNV12 -> preallocated NV12", loops, proc(): uint64 =
    let rc1 = ABGRToI420(
      ptrOrNil(rgbaBytes), (width * 4).cint,
      ptrOrNil(tmpY), width.cint,
      ptrOrNil(tmpU), chromaWidth.cint,
      ptrOrNil(tmpV), chromaWidth.cint,
      width.cint, height.cint
    )
    checkRc("ABGRToI420", rc1)

    let rc2 = I420ToNV12(
      ptrOrNil(tmpY), width.cint,
      ptrOrNil(tmpU), chromaWidth.cint,
      ptrOrNil(tmpV), chromaWidth.cint,
      ptrOrNil(outY), width.cint,
      ptrOrNil(outUV), width.cint,
      width.cint, height.cint
    )
    checkRc("I420ToNV12", rc2)

    result = checksumBytes(outY) xor checksumBytes(outUV)
  ))

  echo ""
  echo "== libyuv_nim high-level API, destination allocated inside each call =="
  printResult(timeIt("Nv12Image.toRgba() allocates RgbaImage", loops, proc(): uint64 =
    let res = nv12Image.toRgba()
    if res.isErr:
      die($res.error)
    let img = res.get()
    result = checksumBytes(cast[seq[uint8]](img.data))
  ))

  printResult(timeIt("Nv12View.toRgba() allocates RgbaImage", loops, proc(): uint64 =
    let res = nv12View.toRgba()
    if res.isErr:
      die($res.error)
    let img = res.get()
    result = checksumBytes(cast[seq[uint8]](img.data))
  ))

  printResult(timeIt("RgbaImage.toNv12() allocates Nv12Image", loops, proc(): uint64 =
    let res = rgbaImage.toNv12()
    if res.isErr:
      die($res.error)
    let img = res.get()
    result = checksumBytes(img.y) xor checksumBytes(img.uv)
  ))

  printResult(timeIt("RgbaView.toNv12() allocates Nv12Image", loops, proc(): uint64 =
    let res = rgbaView.toNv12()
    if res.isErr:
      die($res.error)
    let img = res.get()
    result = checksumBytes(img.y) xor checksumBytes(img.uv)
  ))

  echo ""
  echo "== memory baseline =="
  printResult(timeIt("copy RGBA buffer", loops, proc(): uint64 =
    copyMem(addr copyDst[0], addr rgbaBytes[0], rgbaSize)
    result = checksumBytes(toOpenArray(copyDst, 0, rgbaSize - 1))
  ))

  printResult(timeIt("copy NV12 planes", loops, proc(): uint64 =
    copyMem(addr copyDst[0], addr nv12Y[0], ySize)
    copyMem(addr copyDst[ySize], addr nv12UV[0], uvSize)
    result = checksumBytes(toOpenArray(copyDst, 0, nv12Size - 1))
  ))

  printResult(timeIt("zero RGBA buffer", loops, proc(): uint64 =
    zeroMem(addr copyDst[0], rgbaSize)
    result = uint64(copyDst[0])
  ))

when isMainModule:
  main()
