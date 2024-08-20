##  Joystick definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

type
  Joystick* = ptr object
    ##  Joystick.

type
  HatPosition* = distinct byte
    ##  Hat position.

func `or`*(a, b: HatPosition): HatPosition {.borrow.}

const
  HAT_CENTERED*   = HatPosition 0x00
  HAT_UP*         = HatPosition 0x01
  HAT_RIGHT*      = HatPosition 0x02
  HAT_DOWN*       = HatPosition 0x04
  HAT_LEFT*       = HatPosition 0x08
  HAT_RIGHTUP*    = HAT_RIGHT or HAT_UP
  HAT_RIGHTDOWN*  = HAT_RIGHT or HAT_DOWN
  HAT_LEFTUP*     = HAT_LEFT or HAT_UP
  HAT_LEFTDOWN*   = HAT_LEFT or HAT_DOWN

# vim: set sts=2 et sw=2:
