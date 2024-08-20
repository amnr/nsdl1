##  Keyboard definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

import sdl1keysym

type
  Keysym* {.final, pure.} = object
    ##  Keysym.
    ##
    ##  Unicode translation must be enabled by `enable_unicode()`.
    ##
    ##  .. code-block:: nim
    ##    if (keysym.unicode and 0xff80) == 0:
    ##      let ch = char keysym.unicode and 0x7f
    ##    else:
    ##      let unicode = keysym.unicode
    ##
    scancode*   : byte    ##  Hardware dependent scancode (0 if not available).
    sym*        : Key     ##  SDL keysym (virtual).
    `mod`*      : Mod     ##  Key modifiers (current).
    unicode*    : uint16  ##  Translated character (0 if no Unicode character
                          ##  maps to the keypress). Contains ASCII character
                          ##  if bits 15-7 are set to 0.

const
  DEFAULT_REPEAT_DELAY*     = 500
  DEFAULT_REPEAT_INTERVAL*  = 30

  ALL_HOTKEYS* = 0xffffffff'u32
    ##  The mask to all hotkey bindings.

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when Keysym.sizeof != 16:
    {.fatal: "invalid Keysym size".}

# vim: set sts=2 et sw=2:
