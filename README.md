# libyuv_nim

Minimal and practical Nim bindings for libyuv, focused on efficient image format conversion with a clear and predictable memory layout.

## Features
- NV12 / I420 / RGB24 / RGBA conversion
- Explicit RGBA memory layout (R, G, B, A)
- Zero-copy friendly design
- Debug output (PPM / PAM)

## Design

### RGBA layout
Memory layout is always:

R, G, B, A

Internally libyuv ABGR conversions are used to guarantee this on little-endian systems.

### Types

```nim
type
  PixelRGBA = object
    r, g, b, a: uint8

  RgbaImage = object
    width: int
    height: int
    stride: int
    data: seq[PixelRGBA]
```

## Usage

### NV12 -> RGBA

```nim
let rgba = nv12.toRgba()
```

### Save debug images

```nim
savePam("out.pam", rgba)
```

Convert to PNG:

```bash
convert out.pam out.png
```

## License

MIT
