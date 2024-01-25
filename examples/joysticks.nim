##  Display information about all connected joysticks.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

import std/strformat

import nsdl1

proc main() =
  # Load library.
  if not open_sdl1_library():
    echo "Failed to load SDL 1.2 library: ", last_sdl1_error()
    quit QuitFailure
  defer:
    close_sdl1_library()

  # Initialize SDL.
  if not Init INIT_JOYSTICK or INIT_NOPARACHUTE:
    echo "Failed to initialize SDL 1.2: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  let num_joys = NumJoysticks()

  if num_joys < 0:
    echo "Error"
    quit QuitFailure

  if num_joys == 0:
    echo "No joysticks found."
    return

  for i in 0 ..< num_joys:
    echo "Joystick #", i, ':'
    let joy = JoystickOpen i
    if joy == nil:
      echo "Failed to open joystick #", i
      continue
    defer:
      JoystickClose joy

    echo "  name . . : ", JoystickName i
    echo "  details  : ",
         JoystickNumAxes joy, " axes, ",
         JoystickNumBalls joy, " balls, ",
         JoystickNumButtons joy, " buttons, ",
         JoystickNumHats joy, " hats"

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
