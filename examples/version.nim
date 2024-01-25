##  Display library version.
#[
  SPDX-License-Identifier: NCSA
]#

{.push raises: [].}

import nsdl1

proc main() =
  # Load library.
  if not open_sdl1_library():
    echo "Failed to load SDL 1.2 library: ", last_sdl1_error()
    quit QuitFailure
  defer:
    close_sdl1_library()

  let ver = LinkedVersion()
  echo "SDL ", ver.major, '.', ver.minor, '.', ver.patch

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
