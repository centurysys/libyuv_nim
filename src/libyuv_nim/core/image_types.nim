type
  PixelFormat* = enum
    pfI420
    pfNv12
    pfRgba
    pfRgb

  PixelRGBA* = object
    r*: uint8
    g*: uint8
    b*: uint8
    a*: uint8

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
    data*: seq[PixelRGBA]

  RgbImage* = object
    width*: int
    height*: int
    stride*: int
    data*: seq[uint8]

  # ----------------------------------------------------------------------------
  # Borrowed / zero-copy views
  # ----------------------------------------------------------------------------
  I420View* = object
    ## Borrowed view over I420 planes. Does not own memory.
    width*: int
    height*: int
    strideY*: int
    strideU*: int
    strideV*: int
    y*: ptr uint8
    u*: ptr uint8
    v*: ptr uint8

  Nv12View* = object
    ## Borrowed view over NV12 planes. Does not own memory.
    width*: int
    height*: int
    strideY*: int
    strideUV*: int
    y*: ptr uint8
    uv*: ptr uint8

  RgbaView* = object
    ## Borrowed view over RGBA pixels (byte order R,G,B,A in memory).
    width*: int
    height*: int
    stride*: int
    data*: ptr uint8

  RgbView* = object
    ## Borrowed view over packed RGB24 pixels.
    width*: int
    height*: int
    stride*: int
    data*: ptr uint8

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
proc pixelFormat*(image: I420View): PixelFormat =
  result = pfI420

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: Nv12View): PixelFormat =
  result = pfNv12

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: RgbaView): PixelFormat =
  result = pfRgba

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelFormat*(image: RgbView): PixelFormat =
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
proc bytesPerPixel*(_: typedesc[PixelRGBA]): int =
  result = 4

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
proc yPlaneLen*(image: I420View): int =
  result = image.strideY * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc uPlaneLen*(image: I420View): int =
  result = image.strideU * chromaHeight(image.height)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc vPlaneLen*(image: I420View): int =
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
proc yPlaneLen*(image: Nv12View): int =
  result = image.strideY * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc uvPlaneLen*(image: Nv12View): int =
  result = image.strideUV * chromaHeight(image.height)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc pixelLen*(image: RgbaImage): int =
  result = image.data.len

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
proc dataLen*(image: RgbaView): int =
  result = image.stride * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc dataLen*(image: RgbView): int =
  result = image.stride * image.height

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbaDataLen*(image: RgbaImage): int =
  result = image.data.len * bytesPerPixel(PixelRGBA)

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbaDataPtr*(image: var RgbaImage): ptr uint8 =
  if image.data.len == 0:
    result = nil
  else:
    result = cast[ptr uint8](addr image.data[0])

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbaDataPtr*(image: RgbaImage): ptr uint8 =
  if image.data.len == 0:
    result = nil
  else:
    result = cast[ptr uint8](unsafeAddr image.data[0])

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbaDataPtr*(image: RgbaView): ptr uint8 =
  result = image.data

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbDataPtr*(image: var RgbImage): ptr uint8 =
  if image.data.len == 0:
    result = nil
  else:
    result = addr image.data[0]

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbDataPtr*(image: RgbImage): ptr uint8 =
  if image.data.len == 0:
    result = nil
  else:
    result = cast[ptr uint8](unsafeAddr image.data[0])

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc rgbDataPtr*(image: RgbView): ptr uint8 =
  result = image.data

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
proc isValid*(image: I420View): bool =
  result =
    image.width > 0 and
    image.height > 0 and
    image.strideY >= image.width and
    image.strideU >= chromaWidth(image.width) and
    image.strideV >= chromaWidth(image.width) and
    image.y != nil and
    image.u != nil and
    image.v != nil

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
proc isValid*(image: Nv12View): bool =
  result =
    image.width > 0 and
    image.height > 0 and
    image.strideY >= image.width and
    image.strideUV >= chromaWidth(image.width) * 2 and
    image.y != nil and
    image.uv != nil

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc isValid*(image: RgbaImage): bool =
  let expected = image.dataLen()
  result =
    image.width > 0 and
    image.height > 0 and
    image.stride >= image.width * bytesPerPixel(pfRgba) and
    image.rgbaDataLen() >= expected

# ------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------
proc isValid*(image: RgbaView): bool =
  result =
    image.width > 0 and
    image.height > 0 and
    image.stride >= image.width * bytesPerPixel(pfRgba) and
    image.data != nil

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
proc isValid*(image: RgbView): bool =
  result =
    image.width > 0 and
    image.height > 0 and
    image.stride >= image.width * bytesPerPixel(pfRgb) and
    image.data != nil

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
