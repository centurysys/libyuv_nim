
type
  enum_FilterMode* {.size: sizeof(cuint).} = enum
    kFilterNone = 0, kFilterLinear = 1, kFilterBilinear = 2, kFilterBox = 3
type
  enum_RotationMode* {.size: sizeof(cuint).} = enum
    kRotate0 = 0, kRotate90 = 90, kRotate180 = 180, kRotate270 = 270
const
  kRotateNone* = enum_RotationMode.kRotate0
const
  kRotateClockwise* = enum_RotationMode.kRotate90
const
  kRotateCounterClockwise* = enum_RotationMode.kRotate270
type
  struct_YuvConstants* = object
type
  FilterModeEnum* = enum_FilterMode ## Generated based on /usr/include/libyuv/scale.h:27:3
var kYvuI601Constants* {.importc: "kYvuI601Constants".}: struct_YuvConstants
var kYvuJPEGConstants* {.importc: "kYvuJPEGConstants".}: struct_YuvConstants
var kYvuH709Constants* {.importc: "kYvuH709Constants".}: struct_YuvConstants
var kYvuF709Constants* {.importc: "kYvuF709Constants".}: struct_YuvConstants
var kYvu2020Constants* {.importc: "kYvu2020Constants".}: struct_YuvConstants
var kYvuV2020Constants* {.importc: "kYvuV2020Constants".}: struct_YuvConstants
proc ARGBCopy*(src_argb: ptr uint8; src_stride_argb: cint; dst_argb: ptr uint8;
               dst_stride_argb: cint; width: cint; height: cint): cint {.cdecl,
    importc: "ARGBCopy".}
proc I400ToARGB*(src_y: ptr uint8; src_stride_y: cint; dst_argb: ptr uint8;
                 dst_stride_argb: cint; width: cint; height: cint): cint {.
    cdecl, importc: "I400ToARGB".}
proc RGB24ToARGB*(src_rgb24: ptr uint8; src_stride_rgb24: cint;
                  dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "RGB24ToARGB".}
proc AR30ToABGR*(src_ar30: ptr uint8; src_stride_ar30: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "AR30ToABGR".}
proc AR30ToARGB*(src_ar30: ptr uint8; src_stride_ar30: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "AR30ToARGB".}
proc AR30ToAB30*(src_ar30: ptr uint8; src_stride_ar30: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "AR30ToAB30".}
proc AR64ToARGB*(src_ar64: ptr uint16; src_stride_ar64: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "AR64ToARGB".}
proc AB64ToARGB*(src_ab64: ptr uint16; src_stride_ab64: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "AB64ToARGB".}
proc AR64ToAB64*(src_ar64: ptr uint16; src_stride_ar64: cint;
                 dst_ab64: ptr uint16; dst_stride_ab64: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "AR64ToAB64".}
proc P010ToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint;
                       src_uv: ptr uint16; src_stride_uv: cint;
                       dst_argb: ptr uint8; dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "P010ToARGBMatrix".}
proc P010ToAR30Matrix*(src_y: ptr uint16; src_stride_y: cint;
                       src_uv: ptr uint16; src_stride_uv: cint;
                       dst_ar30: ptr uint8; dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "P010ToAR30Matrix".}
proc P210ToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint;
                       src_uv: ptr uint16; src_stride_uv: cint;
                       dst_argb: ptr uint8; dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "P210ToARGBMatrix".}
proc P210ToAR30Matrix*(src_y: ptr uint16; src_stride_y: cint;
                       src_uv: ptr uint16; src_stride_uv: cint;
                       dst_ar30: ptr uint8; dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "P210ToAR30Matrix".}
proc I420ToI010*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I420ToI010".}
proc I420ToI012*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I420ToI012".}
proc I420Copy*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
               src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
               dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
               dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
               width: cint; height: cint): cint {.cdecl, importc: "I420Copy".}
proc I010Copy*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
               src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
               dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
               dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
               width: cint; height: cint): cint {.cdecl, importc: "I010Copy".}
proc I010ToI420*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I010ToI420".}
proc I210ToI420*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I210ToI420".}
proc I210ToI422*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I210ToI422".}
proc I410ToI420*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I410ToI420".}
proc I410ToI444*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I410ToI444".}
proc I012ToI420*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I012ToI420".}
proc I212ToI422*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I212ToI422".}
proc I212ToI420*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I212ToI420".}
proc I412ToI444*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I412ToI444".}
proc I412ToI420*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I412ToI420".}
proc I410ToI010*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I410ToI010".}
proc I210ToI010*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I210ToI010".}
proc I010ToI410*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I010ToI410".}
proc I210ToI410*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I210ToI410".}
proc I400ToI420*(src_y: ptr uint8; src_stride_y: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "I400ToI420".}
proc P010ToP410*(src_y: ptr uint16; src_stride_y: cint; src_uv: ptr uint16;
                 src_stride_uv: cint; dst_y: ptr uint16; dst_stride_y: cint;
                 dst_uv: ptr uint16; dst_stride_uv: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "P010ToP410".}
proc P210ToP410*(src_y: ptr uint16; src_stride_y: cint; src_uv: ptr uint16;
                 src_stride_uv: cint; dst_y: ptr uint16; dst_stride_y: cint;
                 dst_uv: ptr uint16; dst_stride_uv: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "P210ToP410".}
proc ABGRToAR30*(src_abgr: ptr uint8; src_stride_abgr: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ABGRToAR30".}
proc ARGBToAR30*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToAR30".}
proc ARGBToRAW*(src_argb: ptr uint8; src_stride_argb: cint; dst_raw: ptr uint8;
                dst_stride_raw: cint; width: cint; height: cint): cint {.cdecl,
    importc: "ARGBToRAW".}
proc ARGBToRGB24*(src_argb: ptr uint8; src_stride_argb: cint;
                  dst_rgb24: ptr uint8; dst_stride_rgb24: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "ARGBToRGB24".}
proc ARGBToAR64*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_ar64: ptr uint16; dst_stride_ar64: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToAR64".}
proc ARGBToAB64*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_ab64: ptr uint16; dst_stride_ab64: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToAB64".}
proc ScalePlane*(src: ptr uint8; src_stride: cint; src_width: cint;
                 src_height: cint; dst: ptr uint8; dst_stride: cint;
                 dst_width: cint; dst_height: cint; filtering: enum_FilterMode): cint {.
    cdecl, importc: "ScalePlane".}
proc ScalePlane_16*(src: ptr uint16; src_stride: cint; src_width: cint;
                    src_height: cint; dst: ptr uint16; dst_stride: cint;
                    dst_width: cint; dst_height: cint;
                    filtering: enum_FilterMode): cint {.cdecl,
    importc: "ScalePlane_16".}
proc ScalePlane_12*(src: ptr uint16; src_stride: cint; src_width: cint;
                    src_height: cint; dst: ptr uint16; dst_stride: cint;
                    dst_width: cint; dst_height: cint;
                    filtering: enum_FilterMode): cint {.cdecl,
    importc: "ScalePlane_12".}
proc I420Scale*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                src_width: cint; src_height: cint; dst_y: ptr uint8;
                dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                dst_v: ptr uint8; dst_stride_v: cint; dst_width: cint;
                dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I420Scale".}
proc I420Scale_16*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                   src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                   src_width: cint; src_height: cint; dst_y: ptr uint16;
                   dst_stride_y: cint; dst_u: ptr uint16; dst_stride_u: cint;
                   dst_v: ptr uint16; dst_stride_v: cint; dst_width: cint;
                   dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I420Scale_16".}
proc I420Scale_12*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                   src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                   src_width: cint; src_height: cint; dst_y: ptr uint16;
                   dst_stride_y: cint; dst_u: ptr uint16; dst_stride_u: cint;
                   dst_v: ptr uint16; dst_stride_v: cint; dst_width: cint;
                   dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I420Scale_12".}
proc I444Scale*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                src_width: cint; src_height: cint; dst_y: ptr uint8;
                dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                dst_v: ptr uint8; dst_stride_v: cint; dst_width: cint;
                dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I444Scale".}
proc I444Scale_16*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                   src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                   src_width: cint; src_height: cint; dst_y: ptr uint16;
                   dst_stride_y: cint; dst_u: ptr uint16; dst_stride_u: cint;
                   dst_v: ptr uint16; dst_stride_v: cint; dst_width: cint;
                   dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I444Scale_16".}
proc I444Scale_12*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                   src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                   src_width: cint; src_height: cint; dst_y: ptr uint16;
                   dst_stride_y: cint; dst_u: ptr uint16; dst_stride_u: cint;
                   dst_v: ptr uint16; dst_stride_v: cint; dst_width: cint;
                   dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I444Scale_12".}
proc I422Scale*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                src_width: cint; src_height: cint; dst_y: ptr uint8;
                dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                dst_v: ptr uint8; dst_stride_v: cint; dst_width: cint;
                dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I422Scale".}
proc I422Scale_16*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                   src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                   src_width: cint; src_height: cint; dst_y: ptr uint16;
                   dst_stride_y: cint; dst_u: ptr uint16; dst_stride_u: cint;
                   dst_v: ptr uint16; dst_stride_v: cint; dst_width: cint;
                   dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I422Scale_16".}
proc I422Scale_12*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                   src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                   src_width: cint; src_height: cint; dst_y: ptr uint16;
                   dst_stride_y: cint; dst_u: ptr uint16; dst_stride_u: cint;
                   dst_v: ptr uint16; dst_stride_v: cint; dst_width: cint;
                   dst_height: cint; filtering: enum_FilterMode): cint {.cdecl,
    importc: "I422Scale_12".}
proc NV12Scale*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                src_stride_uv: cint; src_width: cint; src_height: cint;
                dst_y: ptr uint8; dst_stride_y: cint; dst_uv: ptr uint8;
                dst_stride_uv: cint; dst_width: cint; dst_height: cint;
                filtering: enum_FilterMode): cint {.cdecl, importc: "NV12Scale".}
var kYuvI601Constants* {.importc: "kYuvI601Constants".}: struct_YuvConstants
var kYuvJPEGConstants* {.importc: "kYuvJPEGConstants".}: struct_YuvConstants
var kYuvH709Constants* {.importc: "kYuvH709Constants".}: struct_YuvConstants
var kYuvF709Constants* {.importc: "kYuvF709Constants".}: struct_YuvConstants
var kYuv2020Constants* {.importc: "kYuv2020Constants".}: struct_YuvConstants
var kYuvV2020Constants* {.importc: "kYuvV2020Constants".}: struct_YuvConstants
proc I420ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToARGB".}
proc I420ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToABGR".}
proc J420ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "J420ToARGB".}
proc J420ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "J420ToABGR".}
proc H420ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H420ToARGB".}
proc H420ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H420ToABGR".}
proc U420ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U420ToARGB".}
proc U420ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U420ToABGR".}
proc I422ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I422ToARGB".}
proc I422ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I422ToABGR".}
proc J422ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "J422ToARGB".}
proc J422ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "J422ToABGR".}
proc H422ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H422ToARGB".}
proc H422ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H422ToABGR".}
proc U422ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U422ToARGB".}
proc U422ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U422ToABGR".}
proc I444ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I444ToARGB".}
proc I444ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I444ToABGR".}
proc J444ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "J444ToARGB".}
proc J444ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "J444ToABGR".}
proc H444ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H444ToARGB".}
proc H444ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H444ToABGR".}
proc U444ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U444ToARGB".}
proc U444ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U444ToABGR".}
proc I444ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                  src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                  dst_rgb24: ptr uint8; dst_stride_rgb24: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "I444ToRGB24".}
proc I444ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                dst_raw: ptr uint8; dst_stride_raw: cint; width: cint;
                height: cint): cint {.cdecl, importc: "I444ToRAW".}
proc I010ToARGB*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I010ToARGB".}
proc I010ToABGR*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I010ToABGR".}
proc H010ToARGB*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H010ToARGB".}
proc H010ToABGR*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H010ToABGR".}
proc U010ToARGB*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U010ToARGB".}
proc U010ToABGR*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U010ToABGR".}
proc I210ToARGB*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I210ToARGB".}
proc I210ToABGR*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I210ToABGR".}
proc H210ToARGB*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H210ToARGB".}
proc H210ToABGR*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H210ToABGR".}
proc U210ToARGB*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U210ToARGB".}
proc U210ToABGR*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U210ToABGR".}
proc I420AlphaToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                      src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                      src_a: ptr uint8; src_stride_a: cint; dst_argb: ptr uint8;
                      dst_stride_argb: cint; width: cint; height: cint;
                      attenuate: cint): cint {.cdecl, importc: "I420AlphaToARGB".}
proc I420AlphaToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                      src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                      src_a: ptr uint8; src_stride_a: cint; dst_abgr: ptr uint8;
                      dst_stride_abgr: cint; width: cint; height: cint;
                      attenuate: cint): cint {.cdecl, importc: "I420AlphaToABGR".}
proc I422AlphaToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                      src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                      src_a: ptr uint8; src_stride_a: cint; dst_argb: ptr uint8;
                      dst_stride_argb: cint; width: cint; height: cint;
                      attenuate: cint): cint {.cdecl, importc: "I422AlphaToARGB".}
proc I422AlphaToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                      src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                      src_a: ptr uint8; src_stride_a: cint; dst_abgr: ptr uint8;
                      dst_stride_abgr: cint; width: cint; height: cint;
                      attenuate: cint): cint {.cdecl, importc: "I422AlphaToABGR".}
proc I444AlphaToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                      src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                      src_a: ptr uint8; src_stride_a: cint; dst_argb: ptr uint8;
                      dst_stride_argb: cint; width: cint; height: cint;
                      attenuate: cint): cint {.cdecl, importc: "I444AlphaToARGB".}
proc I444AlphaToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                      src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                      src_a: ptr uint8; src_stride_a: cint; dst_abgr: ptr uint8;
                      dst_stride_abgr: cint; width: cint; height: cint;
                      attenuate: cint): cint {.cdecl, importc: "I444AlphaToABGR".}
proc J400ToARGB*(src_y: ptr uint8; src_stride_y: cint; dst_argb: ptr uint8;
                 dst_stride_argb: cint; width: cint; height: cint): cint {.
    cdecl, importc: "J400ToARGB".}
proc NV12ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_argb: ptr uint8;
                 dst_stride_argb: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV12ToARGB".}
proc NV21ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                 src_stride_vu: cint; dst_argb: ptr uint8;
                 dst_stride_argb: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV21ToARGB".}
proc NV12ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_abgr: ptr uint8;
                 dst_stride_abgr: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV12ToABGR".}
proc NV21ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                 src_stride_vu: cint; dst_abgr: ptr uint8;
                 dst_stride_abgr: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV21ToABGR".}
proc NV12ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                  src_stride_uv: cint; dst_rgb24: ptr uint8;
                  dst_stride_rgb24: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV12ToRGB24".}
proc NV21ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                  src_stride_vu: cint; dst_rgb24: ptr uint8;
                  dst_stride_rgb24: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV21ToRGB24".}
proc NV21ToYUV24*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                  src_stride_vu: cint; dst_yuv24: ptr uint8;
                  dst_stride_yuv24: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV21ToYUV24".}
proc NV12ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                src_stride_uv: cint; dst_raw: ptr uint8; dst_stride_raw: cint;
                width: cint; height: cint): cint {.cdecl, importc: "NV12ToRAW".}
proc NV21ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                src_stride_vu: cint; dst_raw: ptr uint8; dst_stride_raw: cint;
                width: cint; height: cint): cint {.cdecl, importc: "NV21ToRAW".}
proc YUY2ToARGB*(src_yuy2: ptr uint8; src_stride_yuy2: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "YUY2ToARGB".}
proc UYVYToARGB*(src_uyvy: ptr uint8; src_stride_uyvy: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "UYVYToARGB".}
proc I010ToAR30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I010ToAR30".}
proc H010ToAR30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H010ToAR30".}
proc I010ToAB30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I010ToAB30".}
proc H010ToAB30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H010ToAB30".}
proc U010ToAR30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U010ToAR30".}
proc U010ToAB30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U010ToAB30".}
proc I210ToAR30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I210ToAR30".}
proc I210ToAB30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I210ToAB30".}
proc H210ToAR30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H210ToAR30".}
proc H210ToAB30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H210ToAB30".}
proc U210ToAR30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U210ToAR30".}
proc U210ToAB30*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "U210ToAB30".}
proc BGRAToARGB*(src_bgra: ptr uint8; src_stride_bgra: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "BGRAToARGB".}
proc ABGRToARGB*(src_abgr: ptr uint8; src_stride_abgr: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ABGRToARGB".}
proc RGBAToARGB*(src_rgba: ptr uint8; src_stride_rgba: cint;
                 dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "RGBAToARGB".}
proc RAWToARGB*(src_raw: ptr uint8; src_stride_raw: cint; dst_argb: ptr uint8;
                dst_stride_argb: cint; width: cint; height: cint): cint {.cdecl,
    importc: "RAWToARGB".}
proc RAWToRGBA*(src_raw: ptr uint8; src_stride_raw: cint; dst_rgba: ptr uint8;
                dst_stride_rgba: cint; width: cint; height: cint): cint {.cdecl,
    importc: "RAWToRGBA".}
proc RGB565ToARGB*(src_rgb565: ptr uint8; src_stride_rgb565: cint;
                   dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                   height: cint): cint {.cdecl, importc: "RGB565ToARGB".}
proc ARGB1555ToARGB*(src_argb1555: ptr uint8; src_stride_argb1555: cint;
                     dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                     height: cint): cint {.cdecl, importc: "ARGB1555ToARGB".}
proc ARGB4444ToARGB*(src_argb4444: ptr uint8; src_stride_argb4444: cint;
                     dst_argb: ptr uint8; dst_stride_argb: cint; width: cint;
                     height: cint): cint {.cdecl, importc: "ARGB4444ToARGB".}
proc MJPGToARGB*(sample: ptr uint8; sample_size: csize_t; dst_argb: ptr uint8;
                 dst_stride_argb: cint; src_width: cint; src_height: cint;
                 dst_width: cint; dst_height: cint): cint {.cdecl,
    importc: "MJPGToARGB".}
proc Android420ToARGB*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       src_pixel_stride_uv: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint; width: cint; height: cint): cint {.
    cdecl, importc: "Android420ToARGB".}
proc Android420ToABGR*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       src_pixel_stride_uv: cint; dst_abgr: ptr uint8;
                       dst_stride_abgr: cint; width: cint; height: cint): cint {.
    cdecl, importc: "Android420ToABGR".}
proc NV12ToRGB565*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                   src_stride_uv: cint; dst_rgb565: ptr uint8;
                   dst_stride_rgb565: cint; width: cint; height: cint): cint {.
    cdecl, importc: "NV12ToRGB565".}
proc I422ToBGRA*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_bgra: ptr uint8; dst_stride_bgra: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I422ToBGRA".}
proc I422ToRGBA*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_rgba: ptr uint8; dst_stride_rgba: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I422ToRGBA".}
proc I420ToBGRA*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_bgra: ptr uint8; dst_stride_bgra: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToBGRA".}
proc I420ToRGBA*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_rgba: ptr uint8; dst_stride_rgba: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToRGBA".}
proc I420ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                  src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                  dst_rgb24: ptr uint8; dst_stride_rgb24: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "I420ToRGB24".}
proc I420ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                dst_raw: ptr uint8; dst_stride_raw: cint; width: cint;
                height: cint): cint {.cdecl, importc: "I420ToRAW".}
proc H420ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                  src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                  dst_rgb24: ptr uint8; dst_stride_rgb24: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "H420ToRGB24".}
proc H420ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                dst_raw: ptr uint8; dst_stride_raw: cint; width: cint;
                height: cint): cint {.cdecl, importc: "H420ToRAW".}
proc J420ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                  src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                  dst_rgb24: ptr uint8; dst_stride_rgb24: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "J420ToRGB24".}
proc J420ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                dst_raw: ptr uint8; dst_stride_raw: cint; width: cint;
                height: cint): cint {.cdecl, importc: "J420ToRAW".}
proc I422ToRGB24*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                  src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                  dst_rgb24: ptr uint8; dst_stride_rgb24: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "I422ToRGB24".}
proc I422ToRAW*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                dst_raw: ptr uint8; dst_stride_raw: cint; width: cint;
                height: cint): cint {.cdecl, importc: "I422ToRAW".}
proc I420ToRGB565*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                   src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                   dst_rgb565: ptr uint8; dst_stride_rgb565: cint; width: cint;
                   height: cint): cint {.cdecl, importc: "I420ToRGB565".}
proc J420ToRGB565*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                   src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                   dst_rgb565: ptr uint8; dst_stride_rgb565: cint; width: cint;
                   height: cint): cint {.cdecl, importc: "J420ToRGB565".}
proc H420ToRGB565*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                   src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                   dst_rgb565: ptr uint8; dst_stride_rgb565: cint; width: cint;
                   height: cint): cint {.cdecl, importc: "H420ToRGB565".}
proc I422ToRGB565*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                   src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                   dst_rgb565: ptr uint8; dst_stride_rgb565: cint; width: cint;
                   height: cint): cint {.cdecl, importc: "I422ToRGB565".}
proc I420ToRGB565Dither*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                         src_stride_u: cint; src_v: ptr uint8;
                         src_stride_v: cint; dst_rgb565: ptr uint8;
                         dst_stride_rgb565: cint; dither4x4: ptr uint8;
                         width: cint; height: cint): cint {.cdecl,
    importc: "I420ToRGB565Dither".}
proc I420ToARGB1555*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                     src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                     dst_argb1555: ptr uint8; dst_stride_argb1555: cint;
                     width: cint; height: cint): cint {.cdecl,
    importc: "I420ToARGB1555".}
proc I420ToARGB4444*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                     src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                     dst_argb4444: ptr uint8; dst_stride_argb4444: cint;
                     width: cint; height: cint): cint {.cdecl,
    importc: "I420ToARGB4444".}
proc I420ToAR30*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToAR30".}
proc I420ToAB30*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToAB30".}
proc H420ToAR30*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_ar30: ptr uint8; dst_stride_ar30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H420ToAR30".}
proc H420ToAB30*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_ab30: ptr uint8; dst_stride_ab30: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "H420ToAB30".}
proc I420ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       dst_argb: ptr uint8; dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I420ToARGBMatrix".}
proc I422ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       dst_argb: ptr uint8; dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I422ToARGBMatrix".}
proc I444ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       dst_argb: ptr uint8; dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I444ToARGBMatrix".}
proc I444ToRGB24Matrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                        src_stride_u: cint; src_v: ptr uint8;
                        src_stride_v: cint; dst_rgb24: ptr uint8;
                        dst_stride_rgb24: cint;
                        yuvconstants: ptr struct_YuvConstants; width: cint;
                        height: cint): cint {.cdecl,
    importc: "I444ToRGB24Matrix".}
proc I010ToAR30Matrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_ar30: ptr uint8;
                       dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I010ToAR30Matrix".}
proc I210ToAR30Matrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_ar30: ptr uint8;
                       dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I210ToAR30Matrix".}
proc I410ToAR30Matrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_ar30: ptr uint8;
                       dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I410ToAR30Matrix".}
proc I010ToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I010ToARGBMatrix".}
proc I012ToAR30Matrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_ar30: ptr uint8;
                       dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I012ToAR30Matrix".}
proc I012ToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I012ToARGBMatrix".}
proc I210ToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I210ToARGBMatrix".}
proc I410ToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                       src_stride_u: cint; src_v: ptr uint16;
                       src_stride_v: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I410ToARGBMatrix".}
proc I420AlphaToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint;
                            src_u: ptr uint8; src_stride_u: cint;
                            src_v: ptr uint8; src_stride_v: cint;
                            src_a: ptr uint8; src_stride_a: cint;
                            dst_argb: ptr uint8; dst_stride_argb: cint;
                            yuvconstants: ptr struct_YuvConstants; width: cint;
                            height: cint; attenuate: cint): cint {.cdecl,
    importc: "I420AlphaToARGBMatrix".}
proc I422AlphaToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint;
                            src_u: ptr uint8; src_stride_u: cint;
                            src_v: ptr uint8; src_stride_v: cint;
                            src_a: ptr uint8; src_stride_a: cint;
                            dst_argb: ptr uint8; dst_stride_argb: cint;
                            yuvconstants: ptr struct_YuvConstants; width: cint;
                            height: cint; attenuate: cint): cint {.cdecl,
    importc: "I422AlphaToARGBMatrix".}
proc I444AlphaToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint;
                            src_u: ptr uint8; src_stride_u: cint;
                            src_v: ptr uint8; src_stride_v: cint;
                            src_a: ptr uint8; src_stride_a: cint;
                            dst_argb: ptr uint8; dst_stride_argb: cint;
                            yuvconstants: ptr struct_YuvConstants; width: cint;
                            height: cint; attenuate: cint): cint {.cdecl,
    importc: "I444AlphaToARGBMatrix".}
proc I010AlphaToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint;
                            src_u: ptr uint16; src_stride_u: cint;
                            src_v: ptr uint16; src_stride_v: cint;
                            src_a: ptr uint16; src_stride_a: cint;
                            dst_argb: ptr uint8; dst_stride_argb: cint;
                            yuvconstants: ptr struct_YuvConstants; width: cint;
                            height: cint; attenuate: cint): cint {.cdecl,
    importc: "I010AlphaToARGBMatrix".}
proc I210AlphaToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint;
                            src_u: ptr uint16; src_stride_u: cint;
                            src_v: ptr uint16; src_stride_v: cint;
                            src_a: ptr uint16; src_stride_a: cint;
                            dst_argb: ptr uint8; dst_stride_argb: cint;
                            yuvconstants: ptr struct_YuvConstants; width: cint;
                            height: cint; attenuate: cint): cint {.cdecl,
    importc: "I210AlphaToARGBMatrix".}
proc I410AlphaToARGBMatrix*(src_y: ptr uint16; src_stride_y: cint;
                            src_u: ptr uint16; src_stride_u: cint;
                            src_v: ptr uint16; src_stride_v: cint;
                            src_a: ptr uint16; src_stride_a: cint;
                            dst_argb: ptr uint8; dst_stride_argb: cint;
                            yuvconstants: ptr struct_YuvConstants; width: cint;
                            height: cint; attenuate: cint): cint {.cdecl,
    importc: "I410AlphaToARGBMatrix".}
proc NV12ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                       src_stride_uv: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "NV12ToARGBMatrix".}
proc NV21ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                       src_stride_vu: cint; dst_argb: ptr uint8;
                       dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "NV21ToARGBMatrix".}
proc NV12ToRGB565Matrix*(src_y: ptr uint8; src_stride_y: cint;
                         src_uv: ptr uint8; src_stride_uv: cint;
                         dst_rgb565: ptr uint8; dst_stride_rgb565: cint;
                         yuvconstants: ptr struct_YuvConstants; width: cint;
                         height: cint): cint {.cdecl,
    importc: "NV12ToRGB565Matrix".}
proc NV12ToRGB24Matrix*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                        src_stride_uv: cint; dst_rgb24: ptr uint8;
                        dst_stride_rgb24: cint;
                        yuvconstants: ptr struct_YuvConstants; width: cint;
                        height: cint): cint {.cdecl,
    importc: "NV12ToRGB24Matrix".}
proc NV21ToRGB24Matrix*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                        src_stride_vu: cint; dst_rgb24: ptr uint8;
                        dst_stride_rgb24: cint;
                        yuvconstants: ptr struct_YuvConstants; width: cint;
                        height: cint): cint {.cdecl,
    importc: "NV21ToRGB24Matrix".}
proc Android420ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint;
                             src_u: ptr uint8; src_stride_u: cint;
                             src_v: ptr uint8; src_stride_v: cint;
                             src_pixel_stride_uv: cint; dst_argb: ptr uint8;
                             dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint): cint {.cdecl,
    importc: "Android420ToARGBMatrix".}
proc I422ToRGBAMatrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       dst_rgba: ptr uint8; dst_stride_rgba: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I422ToRGBAMatrix".}
proc I420ToRGBAMatrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       dst_rgba: ptr uint8; dst_stride_rgba: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I420ToRGBAMatrix".}
proc I420ToRGB24Matrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                        src_stride_u: cint; src_v: ptr uint8;
                        src_stride_v: cint; dst_rgb24: ptr uint8;
                        dst_stride_rgb24: cint;
                        yuvconstants: ptr struct_YuvConstants; width: cint;
                        height: cint): cint {.cdecl,
    importc: "I420ToRGB24Matrix".}
proc I422ToRGB24Matrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                        src_stride_u: cint; src_v: ptr uint8;
                        src_stride_v: cint; dst_rgb24: ptr uint8;
                        dst_stride_rgb24: cint;
                        yuvconstants: ptr struct_YuvConstants; width: cint;
                        height: cint): cint {.cdecl,
    importc: "I422ToRGB24Matrix".}
proc I420ToRGB565Matrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                         src_stride_u: cint; src_v: ptr uint8;
                         src_stride_v: cint; dst_rgb565: ptr uint8;
                         dst_stride_rgb565: cint;
                         yuvconstants: ptr struct_YuvConstants; width: cint;
                         height: cint): cint {.cdecl,
    importc: "I420ToRGB565Matrix".}
proc I422ToRGB565Matrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                         src_stride_u: cint; src_v: ptr uint8;
                         src_stride_v: cint; dst_rgb565: ptr uint8;
                         dst_stride_rgb565: cint;
                         yuvconstants: ptr struct_YuvConstants; width: cint;
                         height: cint): cint {.cdecl,
    importc: "I422ToRGB565Matrix".}
proc I420ToAR30Matrix*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       dst_ar30: ptr uint8; dst_stride_ar30: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I420ToAR30Matrix".}
proc I400ToARGBMatrix*(src_y: ptr uint8; src_stride_y: cint;
                       dst_argb: ptr uint8; dst_stride_argb: cint;
                       yuvconstants: ptr struct_YuvConstants; width: cint;
                       height: cint): cint {.cdecl, importc: "I400ToARGBMatrix".}
proc I420ToARGBMatrixFilter*(src_y: ptr uint8; src_stride_y: cint;
                             src_u: ptr uint8; src_stride_u: cint;
                             src_v: ptr uint8; src_stride_v: cint;
                             dst_argb: ptr uint8; dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I420ToARGBMatrixFilter".}
proc I422ToARGBMatrixFilter*(src_y: ptr uint8; src_stride_y: cint;
                             src_u: ptr uint8; src_stride_u: cint;
                             src_v: ptr uint8; src_stride_v: cint;
                             dst_argb: ptr uint8; dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I422ToARGBMatrixFilter".}
proc I422ToRGB24MatrixFilter*(src_y: ptr uint8; src_stride_y: cint;
                              src_u: ptr uint8; src_stride_u: cint;
                              src_v: ptr uint8; src_stride_v: cint;
                              dst_rgb24: ptr uint8; dst_stride_rgb24: cint;
                              yuvconstants: ptr struct_YuvConstants;
                              width: cint; height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I422ToRGB24MatrixFilter".}
proc I420ToRGB24MatrixFilter*(src_y: ptr uint8; src_stride_y: cint;
                              src_u: ptr uint8; src_stride_u: cint;
                              src_v: ptr uint8; src_stride_v: cint;
                              dst_rgb24: ptr uint8; dst_stride_rgb24: cint;
                              yuvconstants: ptr struct_YuvConstants;
                              width: cint; height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I420ToRGB24MatrixFilter".}
proc I010ToAR30MatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_u: ptr uint16; src_stride_u: cint;
                             src_v: ptr uint16; src_stride_v: cint;
                             dst_ar30: ptr uint8; dst_stride_ar30: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I010ToAR30MatrixFilter".}
proc I210ToAR30MatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_u: ptr uint16; src_stride_u: cint;
                             src_v: ptr uint16; src_stride_v: cint;
                             dst_ar30: ptr uint8; dst_stride_ar30: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I210ToAR30MatrixFilter".}
proc I010ToARGBMatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_u: ptr uint16; src_stride_u: cint;
                             src_v: ptr uint16; src_stride_v: cint;
                             dst_argb: ptr uint8; dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I010ToARGBMatrixFilter".}
proc I210ToARGBMatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_u: ptr uint16; src_stride_u: cint;
                             src_v: ptr uint16; src_stride_v: cint;
                             dst_argb: ptr uint8; dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "I210ToARGBMatrixFilter".}
proc I420AlphaToARGBMatrixFilter*(src_y: ptr uint8; src_stride_y: cint;
                                  src_u: ptr uint8; src_stride_u: cint;
                                  src_v: ptr uint8; src_stride_v: cint;
                                  src_a: ptr uint8; src_stride_a: cint;
                                  dst_argb: ptr uint8; dst_stride_argb: cint;
                                  yuvconstants: ptr struct_YuvConstants;
                                  width: cint; height: cint; attenuate: cint;
                                  filter: enum_FilterMode): cint {.cdecl,
    importc: "I420AlphaToARGBMatrixFilter".}
proc I422AlphaToARGBMatrixFilter*(src_y: ptr uint8; src_stride_y: cint;
                                  src_u: ptr uint8; src_stride_u: cint;
                                  src_v: ptr uint8; src_stride_v: cint;
                                  src_a: ptr uint8; src_stride_a: cint;
                                  dst_argb: ptr uint8; dst_stride_argb: cint;
                                  yuvconstants: ptr struct_YuvConstants;
                                  width: cint; height: cint; attenuate: cint;
                                  filter: enum_FilterMode): cint {.cdecl,
    importc: "I422AlphaToARGBMatrixFilter".}
proc I010AlphaToARGBMatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                                  src_u: ptr uint16; src_stride_u: cint;
                                  src_v: ptr uint16; src_stride_v: cint;
                                  src_a: ptr uint16; src_stride_a: cint;
                                  dst_argb: ptr uint8; dst_stride_argb: cint;
                                  yuvconstants: ptr struct_YuvConstants;
                                  width: cint; height: cint; attenuate: cint;
                                  filter: enum_FilterMode): cint {.cdecl,
    importc: "I010AlphaToARGBMatrixFilter".}
proc I210AlphaToARGBMatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                                  src_u: ptr uint16; src_stride_u: cint;
                                  src_v: ptr uint16; src_stride_v: cint;
                                  src_a: ptr uint16; src_stride_a: cint;
                                  dst_argb: ptr uint8; dst_stride_argb: cint;
                                  yuvconstants: ptr struct_YuvConstants;
                                  width: cint; height: cint; attenuate: cint;
                                  filter: enum_FilterMode): cint {.cdecl,
    importc: "I210AlphaToARGBMatrixFilter".}
proc P010ToARGBMatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_uv: ptr uint16; src_stride_uv: cint;
                             dst_argb: ptr uint8; dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "P010ToARGBMatrixFilter".}
proc P210ToARGBMatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_uv: ptr uint16; src_stride_uv: cint;
                             dst_argb: ptr uint8; dst_stride_argb: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "P210ToARGBMatrixFilter".}
proc P010ToAR30MatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_uv: ptr uint16; src_stride_uv: cint;
                             dst_ar30: ptr uint8; dst_stride_ar30: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "P010ToAR30MatrixFilter".}
proc P210ToAR30MatrixFilter*(src_y: ptr uint16; src_stride_y: cint;
                             src_uv: ptr uint16; src_stride_uv: cint;
                             dst_ar30: ptr uint8; dst_stride_ar30: cint;
                             yuvconstants: ptr struct_YuvConstants; width: cint;
                             height: cint; filter: enum_FilterMode): cint {.
    cdecl, importc: "P210ToAR30MatrixFilter".}
proc ConvertToARGB*(sample: ptr uint8; sample_size: csize_t;
                    dst_argb: ptr uint8; dst_stride_argb: cint; crop_x: cint;
                    crop_y: cint; src_width: cint; src_height: cint;
                    crop_width: cint; crop_height: cint;
                    rotation: enum_RotationMode; fourcc: uint32): cint {.cdecl,
    importc: "ConvertToARGB".}
proc I420ToI422*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I420ToI422".}
proc I420ToI444*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I420ToI444".}
proc I400Copy*(src_y: ptr uint8; src_stride_y: cint; dst_y: ptr uint8;
               dst_stride_y: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I400Copy".}
proc I420ToNV12*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_uv: ptr uint8;
                 dst_stride_uv: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I420ToNV12".}
proc I420ToNV21*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_vu: ptr uint8;
                 dst_stride_vu: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I420ToNV21".}
proc I420ToYUY2*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_yuy2: ptr uint8; dst_stride_yuy2: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToYUY2".}
proc I420ToUYVY*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_uyvy: ptr uint8; dst_stride_uyvy: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "I420ToUYVY".}
proc ConvertFromI420*(y: ptr uint8; y_stride: cint; u: ptr uint8;
                      u_stride: cint; v: ptr uint8; v_stride: cint;
                      dst_sample: ptr uint8; dst_sample_stride: cint;
                      width: cint; height: cint; fourcc: uint32): cint {.cdecl,
    importc: "ConvertFromI420".}
proc I444ToI420*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I444ToI420".}
proc I444ToNV12*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_uv: ptr uint8;
                 dst_stride_uv: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I444ToNV12".}
proc I444ToNV21*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_vu: ptr uint8;
                 dst_stride_vu: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I444ToNV21".}
proc I422ToI420*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I422ToI420".}
proc I422ToI444*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                 dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I422ToI444".}
proc I422ToI210*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_u: ptr uint16;
                 dst_stride_u: cint; dst_v: ptr uint16; dst_stride_v: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I422ToI210".}
proc MM21ToNV12*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_y: ptr uint8; dst_stride_y: cint;
                 dst_uv: ptr uint8; dst_stride_uv: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "MM21ToNV12".}
proc MM21ToI420*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_y: ptr uint8; dst_stride_y: cint;
                 dst_u: ptr uint8; dst_stride_u: cint; dst_v: ptr uint8;
                 dst_stride_v: cint; width: cint; height: cint): cint {.cdecl,
    importc: "MM21ToI420".}
proc MM21ToYUY2*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_yuy2: ptr uint8;
                 dst_stride_yuy2: cint; width: cint; height: cint): cint {.
    cdecl, importc: "MM21ToYUY2".}
proc MT2TToP010*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_y: ptr uint16; dst_stride_y: cint;
                 dst_uv: ptr uint16; dst_stride_uv: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "MT2TToP010".}
proc I422ToNV21*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                 src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                 dst_y: ptr uint8; dst_stride_y: cint; dst_vu: ptr uint8;
                 dst_stride_vu: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I422ToNV21".}
proc I010ToP010*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_uv: ptr uint16;
                 dst_stride_uv: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I010ToP010".}
proc I210ToP210*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_uv: ptr uint16;
                 dst_stride_uv: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I210ToP210".}
proc I012ToP012*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_uv: ptr uint16;
                 dst_stride_uv: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I012ToP012".}
proc I212ToP212*(src_y: ptr uint16; src_stride_y: cint; src_u: ptr uint16;
                 src_stride_u: cint; src_v: ptr uint16; src_stride_v: cint;
                 dst_y: ptr uint16; dst_stride_y: cint; dst_uv: ptr uint16;
                 dst_stride_uv: cint; width: cint; height: cint): cint {.cdecl,
    importc: "I212ToP212".}
proc I400ToNV21*(src_y: ptr uint8; src_stride_y: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_vu: ptr uint8; dst_stride_vu: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "I400ToNV21".}
proc NV12ToI420*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_y: ptr uint8; dst_stride_y: cint;
                 dst_u: ptr uint8; dst_stride_u: cint; dst_v: ptr uint8;
                 dst_stride_v: cint; width: cint; height: cint): cint {.cdecl,
    importc: "NV12ToI420".}
proc NV21ToI420*(src_y: ptr uint8; src_stride_y: cint; src_vu: ptr uint8;
                 src_stride_vu: cint; dst_y: ptr uint8; dst_stride_y: cint;
                 dst_u: ptr uint8; dst_stride_u: cint; dst_v: ptr uint8;
                 dst_stride_v: cint; width: cint; height: cint): cint {.cdecl,
    importc: "NV21ToI420".}
proc NV12ToNV24*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_y: ptr uint8; dst_stride_y: cint;
                 dst_uv: ptr uint8; dst_stride_uv: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "NV12ToNV24".}
proc NV16ToNV24*(src_y: ptr uint8; src_stride_y: cint; src_uv: ptr uint8;
                 src_stride_uv: cint; dst_y: ptr uint8; dst_stride_y: cint;
                 dst_uv: ptr uint8; dst_stride_uv: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "NV16ToNV24".}
proc P010ToI010*(src_y: ptr uint16; src_stride_y: cint; src_uv: ptr uint16;
                 src_stride_uv: cint; dst_y: ptr uint16; dst_stride_y: cint;
                 dst_u: ptr uint16; dst_stride_u: cint; dst_v: ptr uint16;
                 dst_stride_v: cint; width: cint; height: cint): cint {.cdecl,
    importc: "P010ToI010".}
proc P012ToI012*(src_y: ptr uint16; src_stride_y: cint; src_uv: ptr uint16;
                 src_stride_uv: cint; dst_y: ptr uint16; dst_stride_y: cint;
                 dst_u: ptr uint16; dst_stride_u: cint; dst_v: ptr uint16;
                 dst_stride_v: cint; width: cint; height: cint): cint {.cdecl,
    importc: "P012ToI012".}
proc YUY2ToI420*(src_yuy2: ptr uint8; src_stride_yuy2: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "YUY2ToI420".}
proc UYVYToI420*(src_uyvy: ptr uint8; src_stride_uyvy: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "UYVYToI420".}
proc AYUVToNV12*(src_ayuv: ptr uint8; src_stride_ayuv: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_uv: ptr uint8; dst_stride_uv: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "AYUVToNV12".}
proc AYUVToNV21*(src_ayuv: ptr uint8; src_stride_ayuv: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_vu: ptr uint8; dst_stride_vu: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "AYUVToNV21".}
proc Android420ToI420*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                       src_stride_u: cint; src_v: ptr uint8; src_stride_v: cint;
                       src_pixel_stride_uv: cint; dst_y: ptr uint8;
                       dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                       dst_v: ptr uint8; dst_stride_v: cint; width: cint;
                       height: cint): cint {.cdecl, importc: "Android420ToI420".}
proc ARGBToI420*(src_argb: ptr uint8; src_stride_argb: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "ARGBToI420".}
proc ARGBToI420Alpha*(src_argb: ptr uint8; src_stride_argb: cint;
                      dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                      dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                      dst_a: ptr uint8; dst_stride_a: cint; width: cint;
                      height: cint): cint {.cdecl, importc: "ARGBToI420Alpha".}
proc BGRAToI420*(src_bgra: ptr uint8; src_stride_bgra: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "BGRAToI420".}
proc ABGRToI420*(src_abgr: ptr uint8; src_stride_abgr: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "ABGRToI420".}
proc RGBAToI420*(src_rgba: ptr uint8; src_stride_rgba: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "RGBAToI420".}
proc RGB24ToI420*(src_rgb24: ptr uint8; src_stride_rgb24: cint;
                  dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                  dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                  width: cint; height: cint): cint {.cdecl,
    importc: "RGB24ToI420".}
proc RGB24ToJ420*(src_rgb24: ptr uint8; src_stride_rgb24: cint;
                  dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                  dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                  width: cint; height: cint): cint {.cdecl,
    importc: "RGB24ToJ420".}
proc RAWToI420*(src_raw: ptr uint8; src_stride_raw: cint; dst_y: ptr uint8;
                dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "RAWToI420".}
proc RAWToJ420*(src_raw: ptr uint8; src_stride_raw: cint; dst_y: ptr uint8;
                dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "RAWToJ420".}
proc RGB565ToI420*(src_rgb565: ptr uint8; src_stride_rgb565: cint;
                   dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                   dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                   width: cint; height: cint): cint {.cdecl,
    importc: "RGB565ToI420".}
proc ARGB1555ToI420*(src_argb1555: ptr uint8; src_stride_argb1555: cint;
                     dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                     dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                     width: cint; height: cint): cint {.cdecl,
    importc: "ARGB1555ToI420".}
proc ARGB4444ToI420*(src_argb4444: ptr uint8; src_stride_argb4444: cint;
                     dst_y: ptr uint8; dst_stride_y: cint; dst_u: ptr uint8;
                     dst_stride_u: cint; dst_v: ptr uint8; dst_stride_v: cint;
                     width: cint; height: cint): cint {.cdecl,
    importc: "ARGB4444ToI420".}
proc RGB24ToJ400*(src_rgb24: ptr uint8; src_stride_rgb24: cint;
                  dst_yj: ptr uint8; dst_stride_yj: cint; width: cint;
                  height: cint): cint {.cdecl, importc: "RGB24ToJ400".}
proc RAWToJ400*(src_raw: ptr uint8; src_stride_raw: cint; dst_yj: ptr uint8;
                dst_stride_yj: cint; width: cint; height: cint): cint {.cdecl,
    importc: "RAWToJ400".}
proc MJPGToI420*(sample: ptr uint8; sample_size: csize_t; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; src_width: cint;
                 src_height: cint; dst_width: cint; dst_height: cint): cint {.
    cdecl, importc: "MJPGToI420".}
proc MJPGToNV21*(sample: ptr uint8; sample_size: csize_t; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_vu: ptr uint8; dst_stride_vu: cint;
                 src_width: cint; src_height: cint; dst_width: cint;
                 dst_height: cint): cint {.cdecl, importc: "MJPGToNV21".}
proc MJPGToNV12*(sample: ptr uint8; sample_size: csize_t; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_uv: ptr uint8; dst_stride_uv: cint;
                 src_width: cint; src_height: cint; dst_width: cint;
                 dst_height: cint): cint {.cdecl, importc: "MJPGToNV12".}
proc MJPGSize*(sample: ptr uint8; sample_size: csize_t; width: ptr cint;
               height: ptr cint): cint {.cdecl, importc: "MJPGSize".}
proc ConvertToI420*(sample: ptr uint8; sample_size: csize_t; dst_y: ptr uint8;
                    dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                    dst_v: ptr uint8; dst_stride_v: cint; crop_x: cint;
                    crop_y: cint; src_width: cint; src_height: cint;
                    crop_width: cint; crop_height: cint;
                    rotation: enum_RotationMode; fourcc: uint32): cint {.cdecl,
    importc: "ConvertToI420".}
proc ARGBScale*(src_argb: ptr uint8; src_stride_argb: cint; src_width: cint;
                src_height: cint; dst_argb: ptr uint8; dst_stride_argb: cint;
                dst_width: cint; dst_height: cint; filtering: enum_FilterMode): cint {.
    cdecl, importc: "ARGBScale".}
proc ARGBScaleClip*(src_argb: ptr uint8; src_stride_argb: cint; src_width: cint;
                    src_height: cint; dst_argb: ptr uint8;
                    dst_stride_argb: cint; dst_width: cint; dst_height: cint;
                    clip_x: cint; clip_y: cint; clip_width: cint;
                    clip_height: cint; filtering: enum_FilterMode): cint {.
    cdecl, importc: "ARGBScaleClip".}
proc YUVToARGBScaleClip*(src_y: ptr uint8; src_stride_y: cint; src_u: ptr uint8;
                         src_stride_u: cint; src_v: ptr uint8;
                         src_stride_v: cint; src_fourcc: uint32;
                         src_width: cint; src_height: cint; dst_argb: ptr uint8;
                         dst_stride_argb: cint; dst_fourcc: uint32;
                         dst_width: cint; dst_height: cint; clip_x: cint;
                         clip_y: cint; clip_width: cint; clip_height: cint;
                         filtering: enum_FilterMode): cint {.cdecl,
    importc: "YUVToARGBScaleClip".}
proc RGBScale*(src_rgb: ptr uint8; src_stride_rgb: cint; src_width: cint;
               src_height: cint; dst_rgb: ptr uint8; dst_stride_rgb: cint;
               dst_width: cint; dst_height: cint; filtering: enum_FilterMode): cint {.
    cdecl, importc: "RGBScale".}
proc ARGBToBGRA*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_bgra: ptr uint8; dst_stride_bgra: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToBGRA".}
proc ARGBToABGR*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_abgr: ptr uint8; dst_stride_abgr: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToABGR".}
proc ARGBToRGBA*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_rgba: ptr uint8; dst_stride_rgba: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToRGBA".}
proc ARGBToRGB565*(src_argb: ptr uint8; src_stride_argb: cint;
                   dst_rgb565: ptr uint8; dst_stride_rgb565: cint; width: cint;
                   height: cint): cint {.cdecl, importc: "ARGBToRGB565".}
proc ARGBToRGB565Dither*(src_argb: ptr uint8; src_stride_argb: cint;
                         dst_rgb565: ptr uint8; dst_stride_rgb565: cint;
                         dither4x4: ptr uint8; width: cint; height: cint): cint {.
    cdecl, importc: "ARGBToRGB565Dither".}
proc ARGBToARGB1555*(src_argb: ptr uint8; src_stride_argb: cint;
                     dst_argb1555: ptr uint8; dst_stride_argb1555: cint;
                     width: cint; height: cint): cint {.cdecl,
    importc: "ARGBToARGB1555".}
proc ARGBToARGB4444*(src_argb: ptr uint8; src_stride_argb: cint;
                     dst_argb4444: ptr uint8; dst_stride_argb4444: cint;
                     width: cint; height: cint): cint {.cdecl,
    importc: "ARGBToARGB4444".}
proc ARGBToI444*(src_argb: ptr uint8; src_stride_argb: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "ARGBToI444".}
proc ARGBToI422*(src_argb: ptr uint8; src_stride_argb: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_u: ptr uint8; dst_stride_u: cint;
                 dst_v: ptr uint8; dst_stride_v: cint; width: cint; height: cint): cint {.
    cdecl, importc: "ARGBToI422".}
proc ARGBToJ420*(src_argb: ptr uint8; src_stride_argb: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; dst_uj: ptr uint8; dst_stride_uj: cint;
                 dst_vj: ptr uint8; dst_stride_vj: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToJ420".}
proc ARGBToJ422*(src_argb: ptr uint8; src_stride_argb: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; dst_uj: ptr uint8; dst_stride_uj: cint;
                 dst_vj: ptr uint8; dst_stride_vj: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToJ422".}
proc ARGBToJ400*(src_argb: ptr uint8; src_stride_argb: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; width: cint; height: cint): cint {.cdecl,
    importc: "ARGBToJ400".}
proc ABGRToJ420*(src_abgr: ptr uint8; src_stride_abgr: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; dst_uj: ptr uint8; dst_stride_uj: cint;
                 dst_vj: ptr uint8; dst_stride_vj: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ABGRToJ420".}
proc ABGRToJ422*(src_abgr: ptr uint8; src_stride_abgr: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; dst_uj: ptr uint8; dst_stride_uj: cint;
                 dst_vj: ptr uint8; dst_stride_vj: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ABGRToJ422".}
proc ABGRToJ400*(src_abgr: ptr uint8; src_stride_abgr: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; width: cint; height: cint): cint {.cdecl,
    importc: "ABGRToJ400".}
proc RGBAToJ400*(src_rgba: ptr uint8; src_stride_rgba: cint; dst_yj: ptr uint8;
                 dst_stride_yj: cint; width: cint; height: cint): cint {.cdecl,
    importc: "RGBAToJ400".}
proc ARGBToI400*(src_argb: ptr uint8; src_stride_argb: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; width: cint; height: cint): cint {.cdecl,
    importc: "ARGBToI400".}
proc ARGBToG*(src_argb: ptr uint8; src_stride_argb: cint; dst_g: ptr uint8;
              dst_stride_g: cint; width: cint; height: cint): cint {.cdecl,
    importc: "ARGBToG".}
proc ARGBToNV12*(src_argb: ptr uint8; src_stride_argb: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_uv: ptr uint8; dst_stride_uv: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "ARGBToNV12".}
proc ARGBToNV21*(src_argb: ptr uint8; src_stride_argb: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_vu: ptr uint8; dst_stride_vu: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "ARGBToNV21".}
proc ABGRToNV12*(src_abgr: ptr uint8; src_stride_abgr: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_uv: ptr uint8; dst_stride_uv: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "ABGRToNV12".}
proc ABGRToNV21*(src_abgr: ptr uint8; src_stride_abgr: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_vu: ptr uint8; dst_stride_vu: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "ABGRToNV21".}
proc ARGBToYUY2*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_yuy2: ptr uint8; dst_stride_yuy2: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToYUY2".}
proc ARGBToUYVY*(src_argb: ptr uint8; src_stride_argb: cint;
                 dst_uyvy: ptr uint8; dst_stride_uyvy: cint; width: cint;
                 height: cint): cint {.cdecl, importc: "ARGBToUYVY".}
proc RAWToJNV21*(src_raw: ptr uint8; src_stride_raw: cint; dst_y: ptr uint8;
                 dst_stride_y: cint; dst_vu: ptr uint8; dst_stride_vu: cint;
                 width: cint; height: cint): cint {.cdecl, importc: "RAWToJNV21".}