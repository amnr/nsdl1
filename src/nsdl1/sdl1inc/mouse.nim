##  Mouse definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

from video import Rect

type
  WMcursor {.final, incompleteStruct, pure.} = object
    ##  Cursor (window manager dependent).

  Cursor* {.final, pure.} = object
    ##  Cursor.
    area*           : Rect                ##  Cursor area.
    hot_x*, hot_y*  : int16               ##  Cursor hot tip.
    data            : ptr byte            ##  Cursor data.
    mask            : ptr byte            ##  Cursor mask.
    save            : array[2, ptr byte]
    cursor          : ptr WMcursor        ##  Cursor (window manager).

type
  MouseButton* = distinct byte
    ##  Button state.

func button(x: MouseButton): byte = 1'u8 shl (x.byte - 1)

const
  BUTTON_LEFT*        = MouseButton 1
  BUTTON_MIDDLE*      = MouseButton 2
  BUTTON_RIGHT*       = MouseButton 3
  BUTTON_WHEELUP*     = MouseButton 4
  BUTTON_WHEELDOWN*   = MouseButton 5
  BUTTON_X1*          = MouseButton 6
  BUTTON_X2*          = MouseButton 7

const
  BUTTON_LMASK*     = button BUTTON_LEFT
  BUTTON_MMASK*     = button BUTTON_MIDDLE
  BUTTON_RMASK*     = button BUTTON_RIGHT
  BUTTON_X1MASK*    = button BUTTON_X1
  BUTTON_X2MASK*    = button BUTTON_X2

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when Cursor.sizeof != 56:
    {.fatal: "invalid Cursor size: " & $Cursor.sizeof.}

# vim: set sts=2 et sw=2:
