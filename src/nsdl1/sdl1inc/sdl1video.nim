##  Video definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

when NimMajor >= 2 and defined nimPreviewSlimSystem:
  from std/assertions import assert

# Transparency.
const
  ALPHA_OPAQUE*       = 255
  ALPHA_TRANSPARENT*  = 0

type
  Rect* {.bycopy, final, pure.} = object
    ##  Rectangle.
    x*        : int16
    y*        : int16
    w*        : uint16
    h*        : uint16

func init*(T: typedesc[Rect], x, y: int16, w, h: uint16): T {.inline.} =
  ##  Initialize rectangle.
  T(x: x, y: y, w: w, h: h)

type
  Color* {.final, pure.} = object
    ##  Color.
    r*        : byte
    g*        : byte
    b*        : byte
    unused    : byte

func init*(T: typedesc[Color], r, g, b: byte): T {.inline.} =
  ##  Initialize color.
  T(r: r, g: g, b: b, unused: 0x00)

type
  Palette* {.final, pure.} = object
    ##  Color palette.
    ncolors*  : cint
    colors*   : ptr UncheckedArray[Color]

  PixelFormat* {.final, pure.} = object
    ##  Pixel format object. All fields are read only.
    palette*          : ptr Palette
    bits_per_pixel*   : byte
    bytes_per_pixel*  : byte
    rloss*            : byte
    gloss*            : byte
    bloss*            : byte
    aloss*            : byte
    rshift*           : byte
    gshift*           : byte
    bshift*           : byte
    ashift*           : byte
    rmask*            : uint32
    gmask*            : uint32
    bmask*            : uint32
    amask*            : uint32
    colorkey*         : uint32  ##  RGB color key information.
    alpha*            : byte    ##  Alpha value information (per-surface alpha).

  Surface* {.final, pure.} = object
    ##  Surface object. All fields except for `pixels` are read only.
    flags*          : SurfaceFlags              ##  Surface flags.
    format*         : ptr PixelFormat           ##  Pixel format.
    w*, h*          : cint                      ##  Width and height.
    pitch*          : uint16                    ##  Pitch.
    pixels*         : ptr UncheckedArray[byte]  ##  Surface pixel data (or `nil`).
    offset          : cint                      ##  Private.
    hwdata          : pointer                   ##  Private.
    clip_rect*      : Rect                      ##  Clipping.
    unused1         : uint32
    locked          : uint32                    ##  Private.
    map             : pointer                   ##  Private.
    format_version  : cuint                     ##  Private.
    refcount        : cint                      ##  Reference count.

  SurfaceFlags* = distinct uint32
    ##  Surface Flags.

func pixels16*(self: ptr Surface): ptr UncheckedArray[uint16] {.inline.} =
  ##  `Surface` pixels as unchecked array of `uint16`.
  cast[ptr UncheckedArray[uint16]](self.pixels)

func pixels32*(self: ptr Surface): ptr UncheckedArray[uint32] {.inline.} =
  ##  `Surface` pixels as unchecked array of `uint32`.
  cast[ptr UncheckedArray[uint32]](self.pixels)

func `+`*(x, y: SurfaceFlags): SurfaceFlags {.borrow.}
func `+=`*(x: var SurfaceFlags, y: SurfaceFlags) {.borrow.}
func `==`*(x, y: SurfaceFlags): bool {.borrow.}

# Used to compare flags with zero.
func `==`*(x: SurfaceFlags, y: uint32): bool {.borrow.}

func `and`*(x, y: SurfaceFlags): SurfaceFlags {.borrow.}
func `or`*(x, y: SurfaceFlags): SurfaceFlags {.borrow.}
func `xor`*(x, y: SurfaceFlags): SurfaceFlags {.borrow.}

const
  # Flags available for `create_rgb_surface()` and `set_video_mode()`.
  SWSURFACE*    = SurfaceFlags 0x00000000   ##  System memory surface.
  HWSURFACE*    = SurfaceFlags 0x00000001   ##  Video memory surface.
  ASYNCBLIT*    = SurfaceFlags 0x00000004   ##  Use async blits if possible.

  # Flags available for `set_video_mode()`.
  ANYFORMAT*    = SurfaceFlags 0x10000000   ##  Allow any video depth/pixel format.
  HWPALETTE*    = SurfaceFlags 0x20000000   ##  Surface has exclusive palette.
  DOUBLEBUF*    = SurfaceFlags 0x40000000   ##  Double-buffered video mode.
  FULLSCREEN*   = SurfaceFlags 0x80000000   ##  Full screen display surface.
  OPENGL*       = SurfaceFlags 0x00000002   ##  Create an OpenGL rendering context.
  OPENGLBLIT*   = SurfaceFlags 0x0000000a   ##  Create an OpenGL rendering context
                                            ##  and use it for blitting.
  RESIZABLE*    = SurfaceFlags 0x00000010   ##  Video mode may be resized.
  NOFRAME*      = SurfaceFlags 0x00000020   ##  No window caption or edge frame.

  # Used internally (read-only).
  HWACCEL*      = SurfaceFlags 0x00000100   ##  Blit uses hardware acceleration.
  SRCCOLORKEY*  = SurfaceFlags 0x00001000   ##  Blit uses a source color key.
  RLEACCELOK*   = SurfaceFlags 0x00002000   ##  Private flag.
  RLEACCEL*     = SurfaceFlags 0x00004000   ##  Surface is RLE encoded.
  SRCALPHA*     = SurfaceFlags 0x00010000   ##  Blit uses source alpha blending.
  PREALLOC*     = SurfaceFlags 0x01000000   ##  Surface uses preallocated mem.

func MUSTLOCK*(self: ptr Surface): bool {.inline.} =
  ##  Return `true` if the surface needs to be locked before access.
  (self.offset != 0) or ((self.flags and (HWSURFACE or ASYNCBLIT or RLEACCEL)) != 0)

type
  VideoInfo* {.bycopy, final, pure.} = object
    ##  Video hardware information.
    hw_available* {.bitsize: 1.} : uint32   ##  Hardware surfaces available.
    wm_available* {.bitsize: 1.} : uint32   ##  Window manager available.
    unused_bits1  {.bitsize: 6.} : uint32
    unused_bits2  {.bitsize: 1.} : uint32
    blit_hw*      {.bitsize: 1.} : uint32   ##  Accelerated blits HW --> HW.
    blit_hw_cc*   {.bitsize: 1.} : uint32   ##  Accelerated blits with Colorkey.
    blit_hw_a*    {.bitsize: 1.} : uint32   ##  Accelerated blits with Alpha.
    blit_sw*      {.bitsize: 1.} : uint32   ##  Accelerated blits SW --> HW.
    blit_sw_cc*   {.bitsize: 1.} : uint32   ##  Accelerated blits with Colorkey.
    blit_sw_a*    {.bitsize: 1.} : uint32   ##  Accelerated blits with Alpha.
    blit_fill*    {.bitsize: 1.} : uint32   ##  Accelerated color fill.
    unused_bits3  {.bitsize: 16.}: uint32
    video_mem*    : uint32                  ##  Video memory size (KB).
    vfmt*         : ptr PixelFormat         ##  Video surface pixel format.
    current_w*    : cint                    ##  Video mode width.
    current_h*    : cint                    ##  Video mode height.

type
  PaletteFlags* = distinct cint
    ##  Flags for `set_palette`.

const
  LOGPAL*   = PaletteFlags 0x01
  PHYSPAL*  = PaletteFlags 0x02

type
  GrabMode* {.size: cint.sizeof.} = enum
    ##  Grab mode.
    GRAB_QUERY        = -1
    GRAB_OFF          = 0
    GRAB_ON           = 1
    GRAB_FULLSCREEN   ##  Used internally.

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when PixelFormat.sizeof != 48:
    {.fatal: "invalid PixelFormat size: " & $PixelFormat.sizeof.}
  when Surface.sizeof != 88:
    {.fatal: "invalid Surface size: " & $Surface.sizeof.}

  # See: https://github.com/nim-lang/Nim/issues/23128
  assert VideoInfo.sizeof == 24, "invalid VideoInfo size: " & $VideoInfo.sizeof
  # when VideoInfo.sizeof != 24:
  #   {.fatal: "invalid VideoInfo size: " & $VideoInfo.sizeof.}

# vim: set sts=2 et sw=2:
