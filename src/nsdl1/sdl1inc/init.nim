##  Main definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

type
  SdlBool* = distinct cint

type
  InitFlags* = distinct uint32
    ##  Init flags.

func `+`*(x, y: InitFlags): InitFlags {.borrow.}

func `or`*(x, y: InitFlags): InitFlags {.borrow.}

const
  INIT_NONE*          = InitFlags 0x0000_0000
  INIT_TIMER*         = InitFlags 0x0000_0001
  INIT_AUDIO*         = InitFlags 0x0000_0010
  INIT_VIDEO*         = InitFlags 0x0000_0020
  INIT_CDROM*         = InitFlags 0x0000_0100
  INIT_JOYSTICK*      = InitFlags 0x0000_0200
  INIT_NOPARACHUTE*   = InitFlags 0x0010_0000   ##  Don't catch fatal signals.
  INIT_EVENTTHREAD*   = InitFlags 0x0100_0000
  INIT_EVERYTHING*    = InitFlags 0x0000_ffff

# vim: set sts=2 et sw=2:
