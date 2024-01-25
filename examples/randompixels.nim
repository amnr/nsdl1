##  Display random pixels.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

when NimMajor >= 2 or defined nimPreviewSlimSystem:
  import std/assertions
import std/random
from std/os import putEnv

import nsdl1

const
  WindowTitle = "Random Pixels"
  Width       = 320     # Texture width.
  Height      = 240     # Texture height.
  Scale       = 3       # Window pixel scale.
  MaxPixels   = 1000
  DrawDelay   = 10

const
  pixel_bpp   = 32
  pixel_rmask = 0x000000ff'u32
  pixel_gmask = 0x0000ff00'u32
  pixel_bmask = 0x00ff0000'u32
  pixel_amask = 0x00000000'u32

proc clear_surface(surface: ptr Surface) =
  ##  Clear surface (fill it with black color).
  let color = MapRGB(surface.format, 0x00, 0x00, 0x00)
  discard FillRect(surface, color)

proc draw_scaled_pixel(surface: ptr Surface, x, y: int, color: uint32) =
  ##  Draw scaled pixel at position (x, y) with color.
  if MUSTLOCK surface:
    discard LockSurface surface
    defer:
      UnlockSurface surface

  var pixels = cast[ptr UncheckedArray[uint32]](surface.pixels)
  let pitchwords = surface.pitch.int32 div uint32.sizeof
  for sy in 0 ..< Scale:
    let pixoffset = pitchwords * (Scale * y + sy) + Scale * x
    for sx in 0 ..< Scale:
      pixels[pixoffset + sx] = color

proc draw_random_scaled_pixel(surface: ptr Surface) =
  ##  Draw pixel on the surface at random position and random color.
  let
    x = rand Width - 1
    y = rand Height - 1
    r = byte rand 0xff
    g = byte rand 0xff
    b = byte rand 0xff
    color = MapRGB(surface.format, r, g, b)
  surface.draw_scaled_pixel x, y, color

proc loop(screen, texture: ptr Surface) =
  var
    event: Event
    cnt = 0

  # Randomize RNG for the loop.
  randomize()

  while true:
    while PollEvent event:
      case event.typ
      of EVENT_KEYDOWN:
        if event.key.keysym.sym == SDLK_ESCAPE or event.key.keysym.sym == SDLK_q:
          return
      of EVENT_QUIT:
        return
      else:
        discard

    if cnt < MaxPixels:
      # Set random pixel with random color.
      texture.draw_random_scaled_pixel
      inc cnt
    else:
      # Clear the pixmap if max number of pixels were drawn.
      texture.clear_surface
      cnt = 0

    # Update the texture with new pixel data.
    assert BlitSurface(texture, screen)

    # Render the texture.
    assert Flip screen

    Delay DrawDelay

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

  # Center the window.
  try:
    putEnv "SDL_VIDEO_WINDOW_POS", "center"
  except OSError as err:
    echo "Failed to set window position env variable: ", err.msg

  # Create the window.
  let screen = SetVideoMode(Scale * Width, Scale * Height, 32,
                            DOUBLEBUF or HWSURFACE or RESIZABLE)
  if screen == nil:
    echo "Failed to create the window: ", GetError()
    quit QuitFailure
  defer:
    FreeSurface screen

  WM_SetCaption WindowTitle, WindowTitle

  # Create texture.
  let texture = CreateRGBSurface(HWSURFACE, Scale * Width, Scale * Height,
                                 pixel_bpp, pixel_rmask, pixel_gmask,
                                 pixel_bmask, pixel_amask)
  if texture == nil:
    echo "Failed to create the texture: ", GetError()
    quit QuitFailure
  defer:
    FreeSurface texture

  loop screen, texture

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
