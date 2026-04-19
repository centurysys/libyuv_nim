import ./c_api

type
  ## Generic libyuv return code.
  LibYuvResult* = cint

  ## Common scalar aliases used by libyuv APIs.
  Pixel8* = uint8
  Pixel16* = uint16

  ## Public enum aliases with less C-ish names.
  FilterMode* = c_api.enum_FilterMode
  RotationMode* = c_api.enum_RotationMode

const
  ## Filter modes
  filterNone* = c_api.kFilterNone
  filterLinear* = c_api.kFilterLinear
  filterBilinear* = c_api.kFilterBilinear
  filterBox* = c_api.kFilterBox

  ## Rotation modes
  rotate0* = c_api.kRotate0
  rotate90* = c_api.kRotate90
  rotate180* = c_api.kRotate180
  rotate270* = c_api.kRotate270

  ## libyuv compatibility aliases
  rotateNone* = c_api.kRotateNone
  rotateClockwise* = c_api.kRotateClockwise
  rotateCounterClockwise* = c_api.kRotateCounterClockwise

template isSuccess*(rc: LibYuvResult): bool =
  result = (rc == 0)

template isFailure*(rc: LibYuvResult): bool =
  result = (rc != 0)

proc `$`*(mode: FilterMode): string =
  case mode
  of filterNone: "filterNone"
  of filterLinear: "filterLinear"
  of filterBilinear: "filterBilinear"
  of filterBox: "filterBox"

proc `$`*(mode: RotationMode): string =
  case mode
  of rotate0: "rotate0"
  of rotate90: "rotate90"
  of rotate180: "rotate180"
  of rotate270: "rotate270"
