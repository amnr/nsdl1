##  Desktop related functions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

import ../../nsdl1

proc get_desktop_size*(width, height: var int): bool =
  ##  Return desktop size.
  let info = GetVideoInfo()
  if unlikely info == nil:
    return false

  width   = info.current_w.int
  height  = info.current_h.int

  true

proc get_window_size*(): tuple[width, height: int] =
  ##  Return window size.
  ##
  ##  Return (0, 0) on error.
  ##
  ##  .. note::
  ##    If called before `set_video_mode`, result tuple
  ##    will contain desktop size.
  let info = GetVideoInfo()
  if unlikely info == nil:
    return (0, 0)
  (info.current_w.int, info.current_h.int)

# vim: set sts=4 et sw=4:
