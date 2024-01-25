##  Test SDL 1.2 ABI.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

import nsdl1/libsdl1

proc main() =
  do_assert open_sdl1_library()
  defer:
    close_sdl1_library()

  let ver = SDL_Linked_Version()

  do_assert ver.major == 1
  do_assert ver.minor == 2

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
