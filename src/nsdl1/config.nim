##  SDL1 config.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

const
  ndoc = defined nimdoc

const
  enable_audio*     {.booldefine: "sdl1.audio".}      = true or ndoc
    ##  Include audio functions.

  enable_clipboard* {.booldefine: "sdl1.clipboard".}  = true or ndoc
    ##  Include clipboard functions

  enable_joystick*  {.booldefine: "sdl1.joystick".}   = true or ndoc
    ##  Include joystick functions.

  enable_keyboard*  {.booldefine: "sdl1.keyboard".}   = true or ndoc
    ##  Include keyboard functions.

  enable_mouse*     {.booldefine: "sdl1.mouse".}      = true or ndoc
    ##  Include mouse functions.

# vim: set sts=2 et sw=2:
