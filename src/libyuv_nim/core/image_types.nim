#import ../bindings/types

type
  PixelFormat* = enum
    pfI420
    pfNv12
    pfRgba
    pfRgb

  I420Image* = object
    width*: int
    height*: int
    strideY*: int
    strideU*: int
    strideV*: int
    y*: seq[uint8]
    u*: seq[uint8]
    v*: seq[uint8]

  Nv12Image* = object
    width*: int
    height*: int
    strideY*: int
    strideUV*: int
    y*: seq[uint8]
    uv*: seq[uint8]

  RgbaImage* = object
    width*: int
    height*: int
    stride*: int
    data*: seq[uint8]

  RgbImage* = object
    width*: int
    height*: int
    stride*: int
    data*: seq[uint8]

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: I420Image): PixelFormat =
  result = pfI420

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: Nv12Image): PixelFormat =
  result = pfNv12

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: RgbaImage): PixelFormat =
  result = pfRgba

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: RgbImage): PixelFormat =
  result = pfRgb

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc bytesPerPixel*(format: PixelFormat): int =
  case format
  of pfRgba:
    result = 4
  of pfRgb:
    result = 3
  of pfI420, pfNv12:
    result = 1

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc chromaWidth*(width: int): int =
  result = (width + 1) div 2

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc chromaHeight*(height: int): int =
  result = (height + 1) div 2

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc yPlaneLen*(image: I420Image): int =
  result = image.strideY * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc uPlaneLen*(image: I420Image): int =
  result = image.strideU * chromaHeight(image.height)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc vPlaneLen*(image: I420Image): int =
  result = image.strideV * chromaHeight(image.height)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc yPlaneLen*(image: Nv12Image): int =
  result = image.strideY * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc uvPlaneLen*(image: Nv12Image): int =
  result = image.strideUV * chromaHeight(image.height)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc dataLen*(image: RgbaImage): int =
  result = image.stride * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc dataLen*(image: RgbImage): int =
  result = image.stride * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc isValid*(image: I420Image): bool =
  let expectedY = image.yPlaneLen()
  let expectedU = image.uPlaneLen()
  let expectedV = image.vPlaneLen()

  result =
    image.width > 0 and
    image.height > 0 and
    image.strideY >= image.width and
    image.strideU >= chromaWidth(image.width) and
    image.strideV >= chromaWidth(image.width) and
    image.y.len >= expectedY and
    image.u.len >= expectedU and
    image.v.len >= expectedV

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc isValid*(image: Nv12Image): bool =
  let expectedY = image.yPlaneLen()
  let expectedUV = image.uvPlaneLen()

  result =
    image.width > 0 and
    image.height > 0 and
    image.strideY >= image.width and
    image.strideUV >= chromaWidth(image.width) * 2 and
    image.y.len >= expectedY and
    image.uv.len >= expectedUV

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc isValid*(image: RgbaImage): bool =
  let expected = image.dataLen()

  result =
    image.width > 0 and
    image.height > 0 and
    image.stride >= image.width * bytesPerPixel(pfRgba) and
    image.data.len >= expected

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc isValid*(image: RgbImage): bool =
  let expected = image.dataLen()

  result =
    image.width > 0 and
    image.height > 0 and
    image.stride >= image.width * bytesPerPixel(pfRgb) and
    image.data.len >= expected

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc `$`*(format: PixelFormat): string =
  case format
  of pfI420:
    result = "I420"
  of pfNv12:
    result = "NV12"
  of pfRgba:
    result = "RGBA"
  of pfRgb:
    result = "RGB"
