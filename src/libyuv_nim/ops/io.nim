import std/os
import std/strformat
import ../core/errors
import ../core/image_types

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc ensureParentDir(path: string): LY[void] =
  let parentDir = splitFile(path).dir
  if parentDir.len == 0:
    return okVoid()

  try:
    createDir(parentDir)
  except CatchableError as e:
    return makeError(
      lyOperationFailed,
      &"failed to create directory: {parentDir}: {e.msg}"
    ).err

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc openFileForWrite(path: string): LY[File] =
  let dirRes = ensureParentDir(path)
  if dirRes.isErr:
    return err(dirRes.error)

  var f: File
  if not open(f, path, fmWrite):
    return makeError(
      lyOperationFailed,
      &"failed to open file for write: {path}"
    ).err

  result = ok(f)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc savePpm*(path: string; image: RgbImage): LY[void] =
  if not image.isValid:
    return makeError(lyInvalidArgument, "RgbImage is invalid").err

  let fileRes = openFileForWrite(path)
  if fileRes.isErr:
    return err(fileRes.error)

  var f = fileRes.get
  defer:
    close(f)

  f.write(&"P6\n{image.width} {image.height}\n255\n")

  let rowBytes = image.width * 3
  for y in 0 ..< image.height:
    let rowStart = y * image.stride
    discard f.writeBuffer(unsafeAddr image.data[rowStart], rowBytes)

  result = okVoid()

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc savePam*(path: string; image: RgbaImage): LY[void] =
  if not image.isValid:
    return makeError(lyInvalidArgument, "RgbaImage is invalid").err

  let fileRes = openFileForWrite(path)
  if fileRes.isErr:
    return err(fileRes.error)

  var f = fileRes.get
  defer:
    close(f)

  f.write(&"P7\n")
  f.write(&"WIDTH {image.width}\n")
  f.write(&"HEIGHT {image.height}\n")
  f.write("DEPTH 4\n")
  f.write("MAXVAL 255\n")
  f.write("TUPLTYPE RGB_ALPHA\n")
  f.write("ENDHDR\n")

  let rowBytes = image.width * 4
  let pixelsPerRow = image.stride div 4

  for y in 0 ..< image.height:
    let rowStart = y * pixelsPerRow
    discard f.writeBuffer(unsafeAddr image.data[rowStart], rowBytes)

  result = okVoid()
