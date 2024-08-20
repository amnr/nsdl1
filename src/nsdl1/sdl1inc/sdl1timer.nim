##  Timer definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

const
  TIMESLICE*  = 10
    ##  OS scheduler timeslice (ms).

  TIMER_RESOLUTION* = 10
    ##  Maximum resolution of the timer on all platforms.

type
  TimerCallback* = proc (interval: uint32): uint32 {.cdecl, gcsafe, raises: [].}

  NewTimerCallback* = proc (interval: uint32,
                            param: pointer): uint32 {.cdecl, gcsafe, raises: [].}

type
  TimerID* = ptr object

#endif /* _SDL_timer_h.
