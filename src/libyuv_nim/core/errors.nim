import std/strformat
import results
export results

type
  LibYuvErrorKind* = enum
    lyInvalidArgument
    lyBufferTooSmall
    lyUnsupportedFormat
    lyOperationFailed

  LibYuvError* = ref object
    kind*: LibYuvErrorKind
    rc*: cint
    msg*: string
    #trace*: seq[string]

  LY*[T] = Result[T, LibYuvError]

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc `$`*(kind: LibYuvErrorKind): string =
  case kind
  of lyInvalidArgument:
    result = "InvalidArgument"
  of lyBufferTooSmall:
    result = "BufferTooSmall"
  of lyUnsupportedFormat:
    result = "UnsupportedFormat"
  of lyOperationFailed:
    result = "OperationFailed"

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc `$`*(err: LibYuvError): string =
  result = &"LibYuvError: {err.kind}"
  if err.rc != 0:
    result.add(&" (rc={err.rc})")
  if err.msg.len > 0:
    result.add(&": {err.msg}")

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc makeError*(kind: LibYuvErrorKind; msg: string; rc: cint = 0): LibYuvError =
  result = LibYuvError(kind: kind, rc: rc, msg: msg)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc withTrace(err: LibYuvError; where: static[string]): LibYuvError {.inline.} =
  result = err
  #result.trace.add(where)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc trace*[T](res: LY[T]; where: static[string]): LY[T] {.inline.} =
  if res.isErr:
    result = err(res.error.withTrace(where))
  else:
    result = res

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc errKind*[T](res: LY[T]): LibYuvErrorKind =
  if res.isErr:
    result = res.error.kind
  else:
    result = lyOperationFailed

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc errRc*[T](res: LY[T]): cint =
  if res.isErr:
    result = res.error.rc
  else:
    result = 0

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc errMsg*[T](res: LY[T]): string =
  if res.isErr:
    result = res.error.msg
  else:
    result = "No LibYuvError"

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc okVoid*(): LY[void] =
  result = ok()
