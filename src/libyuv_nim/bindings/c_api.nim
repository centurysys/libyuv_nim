const LibYuvDynLib =
  when defined(windows):
    "yuv.dll"
  elif defined(macosx):
    "libyuv.dylib"
  else:
    "libyuv.so(|.0)"

{.push dynlib: LibYuvDynLib.}
include ./generated/libyuv_gen
{.pop.}
