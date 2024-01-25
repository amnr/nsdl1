##  Display checkerboard.
#[
  SPDX-License-Identifier: NCSA
]#

when NimMajor >= 2 or defined nimPreviewSlimSystem:
  import std/assertions

import nsdl1

const
  win_width   = 800
  win_height  = 600

proc draw_checkerboard(surface: ptr Surface) =
  let pal = [
    MapRGB(surface.format, 0x99, 0x99, 0x99),
    MapRGB(surface.format, 0x66, 0x66, 0x66)
  ]

  var byte_offset = 0

  for y in 0 ..< surface.h:
    for x in 0 ..< surface.w:
      let color = pal[((x xor y) div 8) and 1]
      case surface.format.bits_per_pixel
      of 8:
        surface.pixels[byte_offset + x] = byte color
      of 16:
        # cast[ptr uint16](surface.pixels[byte_offset + 2 * x].addr)[] = uint16 color
        surface.pixels16[(byte_offset div 2) + x] = uint16 color
      of 24:
        when cpuEndian == bigEndian:
          surface.pixels[byte_offset + 3 * x + 0] = byte color shr 16
          surface.pixels[byte_offset + 3 * x + 1] = byte color shr 8
          surface.pixels[byte_offset + 3 * x + 2] = byte color
        else:
          surface.pixels[byte_offset + 3 * x + 0] = byte color
          surface.pixels[byte_offset + 3 * x + 1] = byte color shr 8
          surface.pixels[byte_offset + 3 * x + 2] = byte color shr 16
      of 32:
        # cast[ptr uint32](surface.pixels[byte_offset + 4 * x].addr)[] = color
        surface.pixels32[(byte_offset div 4) + x] = color
      else:
        echo "Unsupported bits/pixel: ", surface.format.bits_per_pixel
        return

    byte_offset += int32 surface.pitch

proc main() =
  # Load library.
  if not open_sdl1_library():
    echo "Failed to load SDL 1.2 library: ", last_sdl1_error()
    quit QuitFailure
  defer:
    close_sdl1_library()

  # Initialize SDL.
  if not Init INIT_VIDEO or INIT_NOPARACHUTE:
    echo "Failed to initialize SDL: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  const
    amask = 0xff000000'u32
    rmask = 0x00ff0000'u32
    gmask = 0x0000ff00'u32
    bmask = 0x000000ff'u32

  # Create the image.
  let image = CreateRGBSurface(win_width, win_height,
                               32, rmask, gmask, bmask, amask)
  defer:
    FreeSurface image

  draw_checkerboard image

  # Check if the mode is supported.
  if VideoModeOK(win_width, win_height, 32, SWSURFACE) == 0:
    echo "Requested video mode isn't supported"
    quit QuitFailure

  # Create window screen.
  let screen = SetVideoMode(win_width, win_height, 32)
  if screen == nil:
    echo "Setting video mode failed: ", GetError()
    quit QuitFailure
  defer:
    FreeSurface screen

  # Blit image to screen.
  assert BlitSurface(image, screen)
  UpdateRect screen, 0, 0, win_width, win_height

  WM_SetCaption("Checkerboard", "Checkerboard")

  # Wait for events.
  var event: Event
  while true:
    if PollEvent event:
      case event.typ
      of EVENT_KEYUP:
        case event.key.keysym.sym
        of SDLK_q, SDLK_ESCAPE:
          break
        else:
          discard
      of EVENT_MOUSEBUTTONDOWN:
        echo "mouse down: ", event.button
      of EVENT_VIDEORESIZE:
        echo "resize: ", event.resize
      of EVENT_QUIT:
        echo "quit"
        break
      else:
        discard
    else:
      Delay 20

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
