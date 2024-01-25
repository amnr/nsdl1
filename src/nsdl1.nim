##  High level SDL 1.2 shared library wrapper for Nim.
##
##  Documentation below comes from SDL 1.2 library documentation.
##
##  Usage
##  -----
##
##  ```nim
##  # Load all symbols from SDL 1.2 shared library.
##  # This must be the first proc called.
##  if not open_sdl1_library():
##    echo "Failed to load SDL 1.2 library: ", last_sdl1_error()
##    quit QuitFailure
##  defer:
##    close_sdl1_library()
##
##  # Initialize SDL 1.2.
##  if not Init INIT_VIDEO or INIT_NOPARACHUTE:
##    echo "Failed to initialize SDL 1.2: ", GetError()
##    quit QuitFailure
##  defer:
##    Quit()
##
##  # SDL 1.2 calls follow…
##  ```
##
##  Configuration
##  -------------
##
##  You can disable functions you don't use.
##  All function groups are enabled by default.
##
##  | Group       | Define              | Functions Defined In        |
##  | ----------- | ------------------- | --------------------------- |
##  | Audio       | `sdl1.audio=0`      | ``<SDL/SDL_audio.h>``       |
##  | Clipboard   | `sdl1.clipboard=0`  | ``<SDL/SDL_clipboard.h>``   |
##  | Joystick    | `sdl1.joystick=0`   | ``<SDL/SDL_joystick.h>``    |
##  | Keyboard    | `sdl1.keyboard=0`   | ``<SDL/SDL_keyboard.h>``    |
##  | Mouse       | `sdl1.mouse=0`      | ``<SDL/SDL_mouse.h>``       |
##
##  For example if you don't need audio functions compile with:
##
##  ```
##  nim c -d=sdl1.audio=0 file(s)
##  ```
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

when NimMajor >= 2 and defined nimPreviewSlimSystem:
  from std/assertions import assert

import nsdl1/config
import nsdl1/libsdl1
import nsdl1/utils

export open_sdl1_library, close_sdl1_library, last_sdl1_error

import nsdl1/sdl1inc/active
when enable_audio:
  import nsdl1/sdl1inc/audio
import nsdl1/sdl1inc/events
import nsdl1/sdl1inc/init
when enable_joystick:
  import nsdl1/sdl1inc/joystick
import nsdl1/sdl1inc/keyboard
import nsdl1/sdl1inc/keysym
when enable_mouse:
  import nsdl1/sdl1inc/mouse
import nsdl1/sdl1inc/rwops
import nsdl1/sdl1inc/timer
import nsdl1/sdl1inc/video

export active
when enable_audio:
  export audio
export events
export init
export keyboard
export keysym
when enable_mouse:
  export mouse
export video

# =========================================================================== #
# ==  SDL 1.2 library functions                                            == #
# =========================================================================== #

type
  SurfacePtr* = ptr Surface
    ##  Surface.

converter from_sdl_bool(b: SdlBool): bool =
  b.int != 0

# converter to_sdl_bool(b: bool): SdlBool =
#   b.Bool

proc c_free(mem: pointer) {.header: "<stdlib.h>", importc: "free", nodecl.}

# --------------------------------------------------------------------------- #
# <SDL/SDL.h>                                                                 #
# --------------------------------------------------------------------------- #

proc Init*(flags: InitFlags): bool =
  ##  Initializes SDL.
  ##
  ##  Initializes SDL. This should be called before all other SDL functions.
  ##  The `flags` parameter specifies what part(s) of SDL to initialize.
  ##
  ##  - `INIT_TIMER`: Initializes the timer subsystem.
  ##  - `INIT_AUDIO`: Initializes the audio subsystem.
  ##  - `INIT_VIDEO`: Initializes the video subsystem.
  ##  - `INIT_CDROM`: Initializes the cdrom subsystem.
  ##  - `INIT_JOYSTICK`: Initializes the joystick subsystem.
  ##  - `INIT_EVERYTHING`: Initialize all of the above.
  ##  - `INIT_NOPARACHUTE`: Prevents SDL from catching fatal signals.
  ##  - `INIT_EVENTTHREAD`  
  ##
  ##  Returns `false` on an error or `true` on success.
  ##
  ##  Original name: `SDL_Init`
  assert SDL_Init != nil, "did you forget to call open_sdl1_library?"
  ensure_zero "SDL_Init":
    SDL_Init flags

proc InitSubSystem*(flags: InitFlags): bool =
  ##  Initialize subsystems.
  ##
  ##  After SDL has been initialized with `Init` you may initialize
  ##  uninitialized subsystems with `init_sub_system`. The flags parameter
  ##  is the same as that used in `Init`_.
  ##
  ##  Returns `false` on an error or `true` on success.
  ##
  ##  Original name: `SDL_InitSubSystem`
  ensure_zero "SDL_InitSubSystem":
    SDL_InitSubSystem flags

proc Quit*() =
  ##  Shut down SDL.
  ##
  ##  `quit_sdl` shuts down all SDL subsystems and frees the resources
  ##  allocated to them. This should always be called before you exit.
  ##
  ##  Original name: `SDL_Quit`
  SDL_Quit()

proc QuitSubSystem*(flags: InitFlags) =
  ##  Shut down a subsystem.
  ##
  ##  `QuitSubSystem` allows you to shut down a subsystem that has been
  ##  previously initialized by `Init`_ or `InitSubSystem`_.
  ##  The `flags` tells `quit_sub_system` which subsystems to shut down,
  ##  it uses the same values that are passed to `Init`_.
  ##
  ##  Original name: `SDL_QuitSubSystem`
  SDL_QuitSubSystem flags

proc WasInit*(flags: InitFlags = INIT_NONE): InitFlags {.inline.} =
  ##  Check which subsystems are initialized.
  ##
  ##  `was_init` allows you to see which SDL subsytems have been initialized.
  ##  `flags` is a bitwise OR'd combination of the subsystems you wish to check
  ##  (see `Init`_ for a list of subsystem flags).
  ##
  ##  `WasInit` returns a bitwised OR'd combination of the initialized
  ##  subsystems.
  ##
  ##  Original name: `SDL_WasInit`
  SDL_WasInit flags

# --------------------------------------------------------------------------- #
# <SDL/SDL_audio.h>                                                           #
# --------------------------------------------------------------------------- #

when enable_audio:

  proc AudioDriverName*(maxnamelen: uint = 64): string =
    ##  Original name: `SDL_AudioDriverName`
    var namebuf = newString maxnamelen
    if SDL_AudioDriverName(namebuf[0].addr, namebuf.len.cint) == nil:
      return ""

    $namebuf

  # int SDL_AudioInit(const char *driver_name)
  # void SDL_AudioQuit(void)

  proc BuildAudioCVT*(cvt: ptr AudioCVT, src_format: uint16,
                      src_channels: byte, src_rate: int, dst_format: uint16,
                      dst_channels: byte, dst_rate: int): bool =
    ##  Original name: `SDL_BuildAudioCVT`
    ensure_zero "SDL_BuildAudioCVT":
      SDL_BuildAudioCVT(cvt, src_format, src_channels, src_rate.cint,
                                  dst_format, dst_channels, dst_rate.cint)

  proc CloseAudio*() =
    ##  Shuts down audio processing and closes the audio device.
    ##
    ##  This function shuts down audio processing and closes the audio device.
    ##
    ##  Original name: `SDL_CloseAudio`
    SDL_CloseAudio()

  proc ConvertAudio*(cvt: var AudioCVT): bool =
    ##  Original name: `SDL_ConvertAudio`
    ensure_zero "SDL_ConvertAudio":
      SDL_ConvertAudio cvt.addr

  proc FreeWAV*(audio_buf: ptr UncheckedArray[byte]) =
    ##  Original name: `SDL_FreeWAV`
    if audio_buf != nil:
      SDL_FreeWAV audio_buf[0].addr

  proc GetAudioStatus*(): AudioStatus {.inline.} =
    ##  Get the current audio state.
    ##
    ##  Returns either `AUDIO_STOPPED`, `AUDIO_PAUSED` or `AUDIO_PLAYING`
    ##  depending on the current audio state.
    ##
    ##  Original name: `SDL_GetAudioStatus`
    SDL_GetAudioStatus()

  proc LoadWAV_RW*(src: RWopsPtr, freesrc: bool, spec: var AudioSpec,
                   audio_buf: var ptr UncheckedArray[byte],
                   audio_len: var uint32): ptr AudioSpec =
    ##  Original name: `SDL_LoadWAV_RW`
    ensure_not_nil "SDL_LoadWAV_RW":
      SDL_LoadWAV_RW src, freesrc.cint, spec.addr, audio_buf.addr,
                     audio_len.addr

  proc LoadWAV_RW_unchecked(src: RWopsPtr, freesrc: bool, spec: var AudioSpec,
                            audio_buf: var ptr UncheckedArray[byte],
                            audio_len: var uint32): ptr AudioSpec =
    ##  Unchecked version. Used by `load_wav` not to generate multiple errors
    ##  such as:
    ##    - SDL_RWFromFile failed: Couldn't open test.wav
    ##    - SDL_LoadWAV_RW failed: Parameter 'src' is invalid
    ##
    ##  Original name: `SDL_LoadWAV_RW`
    SDL_LoadWAV_RW src, freesrc.cint, spec.addr, audio_buf.addr,
                   audio_len.addr

  proc LockAudio*() {.inline.} =
    ##  Original name: `SDL_LockAudio`
    SDL_LockAudio()

  proc MixAudio*(dst: ptr UncheckedArray[byte],
                 src: ptr byte or ptr UncheckedArray[byte],
                 len: uint32, volume: int) =
    ##  Mix audio data.
    ##
    ##  This function takes two audio buffers of len bytes each of the playing
    ##  audio format and mixes them, performing addition, volume adjustment,
    ##  and overflow clipping. The volume ranges from 0 to `MIX_MAXVOLUME`
    ##  and should be set to the maximum value for full audio volume.
    ##  Note this does not change hardware volume. This is provided for
    ##  convenience -- you can mix your own audio data.
    ##
    ##  Do not use this function for mixing together more than two streams
    ##  of sample data. The output from repeated application of this function
    ##  may be distorted by clipping, because there is no accumulator with
    ##  greater range than the input (not to mention this being an inefficient
    ##  way of doing it). Use mixing functions from SDL_mixer, OpenAL, or write
    ##  your own mixer instead.
    ##
    ##  Original name: `SDL_MixAudio`.
    SDL_MixAudio(cast[ptr byte](dst), src, len, volume.cint)

  proc OpenAudio*(desired: var AudioSpec): bool =
    ##  Original name: `SDL_OpenAudio`
    ensure_zero "SDL_OpenAudio":
      SDL_OpenAudio(desired.addr, nil)

  proc OpenAudio*(desired: var AudioSpec, obtained: var AudioSpec): bool =
    ##  Original name: `SDL_OpenAudio`
    ensure_zero "SDL_OpenAudio":
      SDL_OpenAudio(desired.addr, obtained.addr)

  proc PauseAudio*(pause_on: bool) {.inline.} =
    ##  Pauses and unpauses the audio callback processing.
    ##
    ##  This function pauses and unpauses the audio callback processing.
    ##  It should be called with `pause_on=false` after opening the audio
    ##  device to start playing sound. This is so you can safely initialize
    ##  data for your callback function after opening the audio device.
    ##  Silence will be written to the audio device during the pause.
    ##
    ##  Original name: `SDL_PauseAudio`.
    SDL_PauseAudio pause_on.cint

  proc UnlockAudio*() {.inline.} =
    ##  Original name: `SDL_UnlockAudio`
    SDL_UnlockAudio()

# --------------------------------------------------------------------------- #
# <SDL/SDL_error.h>                                                           #
# --------------------------------------------------------------------------- #

proc ClearError*() {.inline.} =
  ##  Clears any previous error message for this thread.
  ##
  ##  Original name: `SDL_ClearError`
  SDL_ClearError()

# void SDL_Error(SDL_errorcode code)

proc GetError*(): string {.inline.} =
  ##  Get SDL error string.
  ##
  ##  `get_error` returns a string containing information about the last
  ##  internal SDL error.
  ##
  ##  `get_error` returns a string containing the last error.
  ##
  ##  Original name: `SDL_GetError`
  $SDL_GetError()

proc SetError*(msg: string) {.inline.} =
  ##  Set the SDL error message for the current thread.
  ##
  ##  Original name: `SDL_SetError`
  SDL_SetError("%s".cstring, msg.cstring)

# --------------------------------------------------------------------------- #
# <SDL/SDL_events.h>                                                          #
# --------------------------------------------------------------------------- #

proc EventState*(typ: EventType, state: bool): bool {.discardable, inline.} =
  ##  Set the state of processing events.
  ##
  ##  Return ``true`` if the event was enable prior calling this function,
  ##  ``false`` otherwise.
  ##
  ##  ```c
  ##  Uint8 SDL_EventState(Uint8 type, int state);
  ##  ```
  SDL_EventState(typ.byte, state.cint) == ENABLE.byte

# SDL_EventFilter SDL_GetEventFilter(void)

proc PeepEvents*(events: var openArray[Event], numevents: int,
                 action: EventAction, mask: EventMask): int =
  ##  Original name: `SDL_PeepEvents`
  let num_events = cint min(numevents, events.len)
  result = SDL_PeepEvents(events[0].addr, num_events, action, mask)
  if result < 0:
    log_error "SDL_PeepEvents failed: ", $SDL_GetError()

proc PeepEvents*(events: var openArray[Event], action: EventAction,
                  mask: EventMask): int {.inline.} =
  PeepEvents events, events.len, action, mask

proc PollEvent*(): bool {.inline.} =
  ##  Original name: `SDL_PollEvent`
  SDL_PollEvent(nil) != 0

proc PollEvent*(event: var Event): bool {.inline.} =
  ##  Original name: `SDL_PollEvent`
  SDL_PollEvent(event.addr) != 0

proc PumpEvents*() {.inline.} =
  ##  Original name: `SDL_PumpEvents`
  SDL_PumpEvents()

proc PushEvent*(event: Event): bool =
  ##  Pushes an event onto the event queue.
  ##
  ##  The event queue can actually be used as a two way communication channel.
  ##  Not only can events be read from the queue, but the user can also push
  ##  their own events onto it. event is a pointer to the event structure you
  ##  wish to push onto the queue.
  ##
  ##  .. note::
  ##    Pushing device input events onto the queue doesn't modify the state of
  ##    the device within SDL.
  ##
  ##  Returns `true` on success or `false` if the event couldn't be pushed.
  ##
  ##  Original name: `SDL_PushEvent`
  ensure_zero "SDL_PushEvent":
    when NimMajor >= 2:
      SDL_PushEvent event.addr
    else:
      SDL_PushEvent event.unsafeAddr

proc SetEventFilter*(filter: EventFilter) {.inline.} =
  ##  Original name: `SDL_SetEventFilter`
  SDL_SetEventFilter filter

proc WaitEvent*(event: var Event): bool {.inline.} =
  ##  Original name: `SDL_WaitEvent`
  SDL_WaitEvent(event.addr) != 0

# --------------------------------------------------------------------------- #
# <SDL/SDL_joystick.h>                                                        #
# --------------------------------------------------------------------------- #

when enable_joystick:

  proc JoystickClose*(joystick: Joystick) {.inline.} =
    ##  `SDL_JoystickClose`
    SDL_JoystickClose joystick

  # int SDL_JoystickEventState(int state)
  # Sint16 SDL_JoystickGetAxis(joystick: Joystick, int axis)
  # int SDL_JoystickGetBall(joystick: Joystick, int ball, int *dx, int *dy)
  # Uint8 SDL_JoystickGetButton(joystick: Joystick, int button)
  # Uint8 SDL_JoystickGetHat(joystick: Joystick, int hat)
  # int SDL_JoystickIndex(joystick: Joystick)

  # XXX: check for error
  proc JoystickName*(device_index: int): string =
    ##  `SDL_JoystickName`
    $SDL_JoystickName device_index.cint

  # XXX: check for error
  proc JoystickNumAxes*(joystick: Joystick): int =
    ##  `SDL_JoystickNumAxes`
    SDL_JoystickNumAxes joystick

  # XXX: check for error
  proc JoystickNumBalls*(joystick: Joystick): int =
    ##  `SDL_JoystickNumBalls`
    SDL_JoystickNumBalls joystick

  # XXX: check for error
  proc JoystickNumButtons*(joystick: Joystick): int =
    ##  `SDL_JoystickNumButtons`
    SDL_JoystickNumButtons joystick

  # XXX: check for error
  proc JoystickNumHats*(joystick: Joystick): int =
    ##  `SDL_JoystickNumHats`
    SDL_JoystickNumHats joystick

  # XXX: check for error
  proc JoystickOpen*(device_index: int): Joystick =
    ##  `SDL_JoystickOpen`
    ensure_not_nil "SDL_JoystickOpen":
      SDL_JoystickOpen device_index.cint

  # int SDL_JoystickOpened(int device_index)

  proc JoystickUpdate*() =
    ##  Updates the state of all joysticks.
    ##
    ##  Updates the state(position, buttons, etc.) of all open joysticks.
    ##  If joystick events have been enabled with `JoystickEventState`_
    ##  then this is called automatically in the event loop.
    ##
    ##  Original name: `SDL_JoystickUpdate`
    SDL_JoystickUpdate()

  proc NumJoysticks*(): int =
    ##  Count available joysticks.
    ##
    ##  Counts the number of joysticks attached to the system.
    ##
    ##  Returns the number of attached joysticks.
    ##
    ##  Original name: `SDL_NumJoysticks`
    SDL_NumJoysticks()

# --------------------------------------------------------------------------- #
# <SDL/SDL_keyboard.h>                                                        #
# --------------------------------------------------------------------------- #

when enable_keyboard:

  # int SDL_EnableKeyRepeat(int delay, int interval)
  # int SDL_EnableUNICODE(int enable)

  proc GetKeyName*(key: Key): string {.inline.} =
    ##  Original name: `SDL_GetKeyName`
    $SDL_GetKeyName key

  # void SDL_GetKeyRepeat(int *delay, int *interval)
  # Uint8 * SDL_GetKeyState(int *numkeys)

  proc GetModState*(): Mod {.inline.} =
    ##  Original name: `SDL_GetModState`
    SDL_GetModState()

  # void SDL_SetModState(SDLMod modstate)

# --------------------------------------------------------------------------- #
# <SDL/SDL_main.h>                                                            #
# --------------------------------------------------------------------------- #

# int SDL_RegisterApp(char *name, Uint32 style, void *hInst)
# void SDL_SetModuleHandle(void *hInst)
# void SDL_UnregisterApp(void)

# --------------------------------------------------------------------------- #
# <SDL/SDL_mouse.h>                                                           #
# --------------------------------------------------------------------------- #

when enable_mouse:

  # SDL_Cursor * SDL_CreateCursor(Uint8 *data, Uint8 *mask, int w, int h,
  #     int hot_x, int hot_y)
  # void SDL_FreeCursor(SDL_Cursor *cursor)
  # SDL_Cursor * SDL_GetCursor(void)

  proc GetMouseState*(): tuple[x, y: int, buttons: MouseButton] {.inline.} =
    ##  Original name: `SDL_GetMouseState`
    var outx, outy: cint = 0
    let buttons = SDL_GetMouseState(outx.addr, outy.addr)
    (outx.int, outy.int, buttons)

  proc GetRelativeMouseState*(): tuple[x, y: int, buttons: MouseButton] {.inline.} =
    ##  Original name: `SDL_GetRelativeMouseState`
    var outx, outy: cint = 0
    let buttons = SDL_GetRelativeMouseState(outx.addr, outy.addr)
    (outx.int, outy.int, buttons)

  # void SDL_SetCursor(SDL_Cursor *cursor)

  proc ShowCursor*(toggle: bool): bool {.discardable, inline.} =
    ##  Toggle whether or not the cursor is shown on the screen.
    ##
    ##  Toggle whether or not the cursor is shown on the screen. Passing `true`
    ##  displays the cursor and passing `false` hides it.
    ##
    ##  The cursor starts off displayed, but can be turned off.
    ##
    ##  Returns the current state of the cursor.
    ##
    ##  Original name: `SDL_ShowCursor`
    #
    #[The current state
    #  of the mouse cursor can be queried by passing SDL_QUERY @@@, either
    #  `true` or `enable` will be returned.
    ]#
    bool SDL_ShowCursor toggle.cint

  proc WarpMouse*(x: uint16, y: uint16) {.inline.} =
    ##  Set the position of the mouse cursor.
    ##
    ##  Set the position of the mouse cursor (generates a mouse motion event).
    ##
    ##  Original name: `SDL_WarpMouse`
    SDL_WarpMouse x, y

# --------------------------------------------------------------------------- #
# <SDL/SDL_rwops.h>                                                           #
# --------------------------------------------------------------------------- #

# NOTE: Only single function imported.

proc RWFromFile*(file: string, mode: string): RWopsPtr =
  ##  Original name: `SDL_RWFromFile`
  ensure_not_nil "SDL_RWFromFile":
    SDL_RWFromFile file.cstring, mode.cstring

# --------------------------------------------------------------------------- #
# <SDL/SDL_syswm.h>                                                           #
# --------------------------------------------------------------------------- #

# int SDL_GetWMInfo(SDL_SysWMinfo *info)

# --------------------------------------------------------------------------- #
# <SDL/SDL_timer.h>                                                           #
# --------------------------------------------------------------------------- #

proc AddTimer*(interval: uint32, callback: NewTimerCallback,
               param: pointer = nil): TimerID {.inline.} =
  ##  Add a timer which will call a callback after the specified number of
  ##  milliseconds has elapsed
  ##
  ##  Adds a callback function to be run after the specified number of
  ##  milliseconds has elapsed. The callback function is passed the current
  ##  timer interval and the user supplied parameter from the `add_timer` call
  ##  and returns the next timer interval. If the returned value from
  ##  the callback is the same as the one passed in, the periodic alarm
  ##  continues, otherwise a new alarm is scheduled.
  ##
  ##  To cancel a currently running timer call `RemoveTimer`_ with the timer ID
  ##  returned from `AddTimer`.
  ##
  ##  The timer callback function may run in a different thread than your main
  ##  program, and so shouldn't call any functions from within itself. You may
  ##  always call `PushEvent`_, however.
  ##
  ##  The granularity of the timer is platform-dependent, but you should count
  ##  on it being at least 10 ms as this is the most common number. This means
  ##  that if you request a 16 ms timer, your callback will run approximately
  ##  20 ms later on an unloaded system. If you wanted to set a flag signaling
  ##  a frame update at 30 frames per second (every 33 ms), you might set
  ##  a timer for 30 ms (see example below). If you use this function, you need
  ##  to pass `INIT_TIMER` to `Init`_.
  ##
  ##  Returns an ID value for the added timer or `nil` if there was an error.
  ##
  ##  Original name: `SDL_AddTimer`
  # XXX: create nil timer ID and update the docs.
  ensure_not_nil "SDL_AddTimer":
    SDL_AddTimer interval, callback, param

proc Delay*(ms: uint32) {.inline.} =
  ##  Wait a specified number of milliseconds before returning.
  ##
  ##  Wait a specified number of milliseconds before returning. `Delay` will
  ##  wait at least the specified time, but possible longer due to OS
  ##  scheduling.
  ##
  ##  .. note::
  ##    Count on a delay granularity of at least 10 ms. Some platforms have
  ##    shorter clock ticks but this is the most common.
  ##
  ##  Original name: `SDL_Delay`
  SDL_Delay ms

proc GetTicks*(): uint32 {.inline.} =
  ##  Get the number of milliseconds since the SDL library initialization.
  ##
  ##  Get the number of milliseconds since the SDL library initialization.
  ##  Note that this value wraps if the program runs for more than ~49 days.
  ##
  ##  Original name: `SDL_GetTicks`
  SDL_GetTicks()

proc RemoveTimer*(t: TimerID): bool {.discardable.} =
  ##  Remove a timer which was added with `add_timer`_.
  ##
  ##  Returns a `bool` value indicating success.
  ##
  ##  Original name: `SDL_RemoveTimer`
  {.warning: "print a warning?".}
  SDL_RemoveTimer t

proc SetTimer*(interval: uint32, callback: TimerCallback): bool =
  ##  Set a callback to run after the specified number of milliseconds
  ##  has elapsed.
  ##
  ##  Set a callback to run after the specified number of milliseconds has
  ##  elapsed. The callback function is passed the current timer interval
  ##  and returns the next timer interval. If the returned value is the same
  ##  as the one passed in, the periodic alarm continues, otherwise a new alarm
  ##  is scheduled.
  ##
  ##  To cancel a currently running timer, call `set_timer(0, nil)`.
  ##
  ##  The timer callback function may run in a different thread than your main
  ##  constant, and so shouldn't call any functions from within itself.
  ##
  ##  The maximum resolution of this timer is 10 ms, which means that if you
  ##  request a 16 ms timer, your callback will run approximately 20 ms later
  ##  on an unloaded system. If you wanted to set a flag signaling a frame
  ##  update at 30 frames per second (every 33 ms), you might set a timer
  ##  for 30 ms (see example below).
  ##
  ##  If you use this function, you need to pass `INIT_TIMER` to `Init`_.
  ##
  ##  .. note::
  ##    This function is kept for compatibility but has been superseded by
  ##    the new timer functions `AddTimer`_ and `RemoveTimer`_ which support
  ##    multiple timers.
  ##
  ##  ```nim
  ##  set_timer((33 div 10) * 10, my_callback)
  ##  ```
  ##
  ##  Original name: `SDL_SetTimer`
  ensure_zero "SDL_SetTimer":
    SDL_SetTimer interval, callback

# --------------------------------------------------------------------------- #
# <SDL/SDL_version.h>                                                         #
# --------------------------------------------------------------------------- #

proc LinkedVersion*(): tuple[major, minor, patch: int] =
  ##  Return SDL linked version.
  ##
  ##  Returns tuple of `(major, minor, patch)`.
  ##
  ##  Original name: `SDL_Linked_Version`
  let ver = SDL_Linked_Version()
  (ver.major.int, ver.minor.int, ver.patch.int)

# --------------------------------------------------------------------------- #
# <SDL/SDL_video.h>                                                           #
# --------------------------------------------------------------------------- #

# SDL_Surface * SDL_ConvertSurface(SDL_Surface *src, SDL_PixelFormat *fmt,
#     Uint32 flags)

proc CreateRGBSurface*(flags: SurfaceFlags, width: int, height: int,
                       depth: int, rmask: uint32, gmask: uint32, bmask: uint32,
                       amask: uint32): SurfacePtr =
  ##  Create an empty `Surface`.
  ##
  ##  Allocate an empty surface (must be called after `SetVideoMode`_).
  ##
  ##  If `depth` is 8 bits an empty palette is allocated for the surface,
  ##  otherwise a 'packed-pixel' `PixelFormat`_ is created using
  ##  the `[RGBA]mask`'s provided (see `PixelFormat`_). The `flags` specifies
  ##  the type of surface that should be created, it is an OR'd combination
  ##  of the following possible values.
  ##
  ##  `SWSURFACE`:
  ##    SDL will create the surface in system memory. This improves
  ##    the performance of pixel level access, however you may not be able
  ##    to take advantage of some types of hardware blitting.
  ##  `HWSURFACE`:
  ##    SDL will attempt to create the surface in video memory. This will allow
  ##    SDL to take advantage of Video->Video blits (which are often
  ##    accelerated).
  ##  `SRCCOLORKEY`:
  ##    This flag turns on colourkeying for blits from this surface.
  ##    If `HWSURFACE` is also specified and colourkeyed blits are
  ##    hardware-accelerated, then SDL will attempt to place the surface
  ##    in video memory. Use `SetColorKey`_ to set or clear this flag after
  ##    surface creation.
  ##  `SRCALPHA`:
  ##    This flag turns on alpha-blending for blits from this surface.
  ##    If `HWSURFACE` is also specified and alpha-blending blits are
  ##    hardware-accelerated, then the surface will be placed in video memory
  ##    if possible. Use `SetAlpha`_ to set or clear this flag after surface
  ##    creation.
  ##
  ##  .. note::
  ##    If an alpha-channel is specified (that is, if `amask` is nonzero), then
  ##    the `SRCALPHA` flag is automatically set. You may remove this flag by
  ##    calling `SetAlpha`_ after surface creation.
  ##
  ##  Returns the created surface, or `nil` upon error.
  ##
  ##  ```nim
  ##  # Create a 32-bit surface with the bytes of each pixel in R,G,B,A order,
  ##  # as expected by OpenGL for textures.
  ##
  ##  # SDL interprets each pixel as a 32-bit number, so our masks must depend
  ##  # on the endianness (byte order) of the machine.
  ##  when cpuEndian == bigEndian:
  ##    let rmask = 0xff000000
  ##    let gmask = 0x00ff0000
  ##    let bmask = 0x0000ff00
  ##    let amask = 0x000000ff
  ##  else:
  ##    let rmask = 0x000000ff
  ##    let gmask = 0x0000ff00
  ##    let bmask = 0x00ff0000
  ##    let amask = 0xff000000
  ##
  ##  let surface = create_rgb_surface(SWSURFACE, width, height, 32,
  ##                                   rmask, gmask, bmask, amask)
  ##  if surface == nil:
  ##    echo "CreateRGBSurface failed: ", get_error()
  ##    quit QuitFailure
  ##  ```
  ##
  ##  Original name: `SDL_CreateRGBSurface`
  ensure_not_nil "SDL_CreateRGBSurface":
    SDL_CreateRGBSurface flags.uint32, width.cint, height.cint, depth.cint,
                         rmask, gmask, bmask, amask

proc CreateRGBSurface*(width: int, height: int, depth: int, rmask: uint32,
                       gmask: uint32, bmask: uint32,
                       amask: uint32): SurfacePtr =
  ##  Create an empty `Surface` with `flags` set to `SWSURFACE`.
  ##
  ##  See `create_rgb_surface <#create_rgb_surface,SurfaceFlags,int,int,int,uint32,uint32,uint32,uint32>`_.
  CreateRGBSurface SWSURFACE, width, height, depth, rmask, gmask, bmask, amask

proc CreateRGBSurfaceFrom*(pixels: pointer, width: int, height: int,
                           depth: int, pitch: int, rmask: uint32,
                           gmask: uint32, bmask: uint32,
                           amask: uint32): SurfacePtr =
  ##  Create an `Surface` from pixel data.
  ##
  ##  Creates an `Surface` from the provided pixel data.
  ##
  ##  The data stored in pixels is assumed to be of the `depth` specified in
  ##  the parameter list. The pixel data is not copied into the `Surface`
  ##  structure so it should not be freed until the surface has been freed with
  ##  a called to `free <#free,SurfacePtr>`_. `pitch` is the length of each
  ##  scanline in bytes.
  ##
  ##  See `create_rgb_surface <#create_rgb_surface,SurfaceFlags,int,int,int,uint32,uint32,uint32,uint32>`_
  ##  for a more detailed description of the other parameters.
  ##
  ##  Returns the created surface, or `nil` upon error.
  ##
  ##  Original name: `SDL_CreateRGBSurfaceFrom`
  ensure_not_nil "SDL_CreateRGBSurfaceFrom":
    SDL_CreateRGBSurfaceFrom pixels, width.cint, height.cint, depth.cint,
                             pitch.cint, rmask, gmask, bmask, amask

proc DisplayFormat*(surface: SurfacePtr): SurfacePtr =
  ##  Original name: `SDL_DisplayFormat`
  ensure_not_nil "SDL_DisplayFormat":
    SDL_DisplayFormat surface

# SDL_Surface * SDL_DisplayFormatAlpha(SDL_Surface *surface)
# int SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect)

proc FillRect*(dst: SurfacePtr, color: uint32): bool =
  ##  Original name: `SDL_FillRect`
  ensure_zero "SDL_FillRect":
    SDL_FillRect dst, nil, color

proc FillRect*(dst: SurfacePtr, dstrect: Rect, color: uint32): bool =
  ##  Original name: `SDL_FillRect`
  when NimMajor < 2:
    var dstrect = dstrect
  ensure_zero "SDL_FillRect":
    SDL_FillRect dst, dstrect.addr, color

proc Flip*(surface: SurfacePtr): bool =
  ##  Swaps screen buffers.
  ##
  ##  On hardware that supports double-buffering, this function sets up a flip
  ##  and returns. The hardware will wait for vertical retrace, and then swap
  ##  video buffers before the next video surface blit or lock will return.
  ##  On hardware that doesn't support double-buffering, this is equivalent
  ##  to calling `UpdateRect`_ `(screen, 0, 0, 0, 0)`.
  ##
  ##  The `DOUBLEBUF` flag must have been passed to `SetVideoMode`_, when
  ##  setting the video mode for this function to perform hardware flipping.
  ##
  ##  This function returns `true` if successful, or `false` if there was
  ##  an error.
  ##
  ##  Original name: `SDL_Flip`
  ensure_zero "SDL_Flip":
    SDL_Flip surface

proc FreeSurface*(surface: SurfacePtr) {.inline.} =
  ##  Frees (deletes) a `Surface`.
  ##
  ##  Frees the resources used by a previously created `Surface`.
  ##  If the surface was created using `CreateRGBSurfaceFrom` then the pixel
  ##  data is not freed.
  ##
  ##  Original name: `SDL_FreeSurface`
  SDL_FreeSurface surface

# void SDL_FreeYUVOverlay(SDL_Overlay *overlay)
# int SDL_GL_GetAttribute(SDL_GLattr attr, int* value)
# void * SDL_GL_GetProcAddress(const char* proc)
# int SDL_GL_LoadLibrary(const char *path)
# void SDL_GL_Lock(void)
# int SDL_GL_SetAttribute(SDL_GLattr attr, int value)
# void SDL_GL_SwapBuffers(void)
# void SDL_GL_Unlock(void)
# void SDL_GL_UpdateRects(int numrects, SDL_Rect* rects)
# void SDL_GetClipRect(SDL_Surface *surface, SDL_Rect *rect)
# int SDL_GetGammaRamp(Uint16 *red, Uint16 *green, Uint16 *blue)
# void SDL_GetRGB(Uint32 pixel, const SDL_PixelFormat *const fmt,
#     Uint8 *r, Uint8 *g, Uint8 *b)
# void SDL_GetRGBA(Uint32 pixel, const SDL_PixelFormat *const fmt,
#     Uint8 *r, Uint8 *g, Uint8 *b, Uint8 *a)

proc GetVideoInfo*(): ptr VideoInfo =
  ##  Returns a pointer to information about the video hardware.
  ##
  ##  This function returns a read-only pointer
  ##  to `information <nsdl1/sdl1inc/video.html#VideoInfo>`_ about the video
  ##  hardware. If this is called before `SetVideoMode`_, the `vfmt` member
  ##  of the returned structure will contain the pixel format of the "best"
  ##  video mode.
  ##
  ##  Original name: `SDL_GetVideoInfo`
  ##
  ensure_not_nil "SDL_GetVideoInfo":
    SDL_GetVideoInfo()

proc GetVideoSurface*(): SurfacePtr =
  ##  Returns a pointer to the current display surface.
  ##
  ##  This function returns a pointer to the current display surface.
  ##  If SDL is doing format conversion on the display surface, this function
  ##  returns the publicly visible surface, not the real video surface.
  ##
  ##  Original name: `SDL_GetVideoSurface`
  ##
  # XXX: can this return nil?
  ensure_not_nil "SDL_GetVideoSurface":
    SDL_GetVideoSurface()

proc ListModes(format: ptr PixelFormat,
               flags: SurfaceFlags = SWSURFACE): seq[tuple[w, h: int]] =
  ##  ListModes. Internal.
  let modes = SDL_ListModes(format, flags)
  if modes == nil:
    return
  if modes.pointer == cast[pointer](-1):
    result.add (-1, -1)
  else:
    var i = 0
    while modes[i] != nil:
      result.add (modes[i].w.int, modes[i].h.int)
      inc i

proc ListModes*(format: PixelFormat,
                flags: SurfaceFlags = SWSURFACE): seq[tuple[w, h: int]] =
  ##  Returns a seq of available screen dimensions for the given format
  ##  and video flags.
  ##
  ##  Return a seq of available screen dimensions for the given format and video
  ##  flags, sorted largest to smallest. Returns empty seq if there are no
  ##  dimensions available for a particular format, or seq of `(-1, -1)` if any
  ##  dimension is okay for the given format.
  ##
  ##  The `flag` parameter is an OR'd combination of surface flags.
  ##  The flags are the same as those used `SetVideoMode`_ and they play
  ##  a strong role in deciding what modes are valid. For instance, if you pass
  ##  `HWSURFACE` as a flag only modes that support hardware video surfaces will
  ##  be returned.
  ##
  ##  Original name: `SDL_ListModes`
  when NimMajor >= 2:
    ListModes format.addr, flags
  else:
    ListModes format.unsafeAddr, flags

proc ListModes*(flags: SurfaceFlags = SWSURFACE): seq[tuple[w, h: int]] {.inline.} =
  ##  Returns a seq of available screen dimensions for the given video flags.
  ##
  ##  Return a seq of available screen dimensions for the given video
  ##  flags, sorted largest to smallest. Returns empty seq if there are no
  ##  dimensions available for a particular flags, or seq of `(-1, -1)` if any
  ##  dimension is okay for the given flags.
  ##
  ##  The mode list will be for the format returned by `get_video_info().vfmt`.
  ##  The `flag` parameter is an OR'd combination of surface flags.
  ##  The flags are the same as those used `SetVideoMode`_ and they play
  ##  a strong role in deciding what modes are valid. For instance, if you pass
  ##  `HWSURFACE` as a flag only modes that support hardware video surfaces will
  ##  be returned.
  ##
  ##  Original name: `SDL_ListModes`
  ListModes nil, flags

proc LoadBMP_RW*(src: RWopsPtr, freesrc: bool): SurfacePtr =
  ##  Original name: `SDL_LoadBMP_RW`
  ensure_not_nil "SDL_LoadBMP_RW":
    SDL_LoadBMP_RW src, freesrc.cint

proc LoadBMP_RW_unchecked(src: RWopsPtr,
                          freesrc: bool): SurfacePtr {.inline.} =
  ##  Unchecked version. Used by `load_bmp` not to generate multiple errors
  ##  such as:
  ##    - SDL_RWFromFile failed: Couldn't open sail.bmp
  ##    - SDL_LoadBMP_RW failed: Parameter 'src' is invalid
  ##
  ##  ```c
  ##  SDL_Surface * SDL_LoadBMP_RW(SDL_RWops *src, int freesrc);
  ##  ```
  SDL_LoadBMP_RW src, freesrc.cint

proc LockSurface*(surface: SurfacePtr): bool {.inline.} =
  ##  Lock a surface for directly access.
  ##
  ##  `lock` sets up a surface for directly accessing the pixels. Between calls
  ##  to `LockSurface` and `UnlockSurface`_, you can write to and read from
  ##  `surface.pixels`, using the pixel format stored in `surface.format`.
  ##  Once you are done accessing the surface, you should use `UnlockSurface`_
  ##  to release it.
  ##
  ##  Not all surfaces require locking. If `MUSTLOCK`_ `(surface)` evaluates
  ##  to `false`, then you can read and write to the surface at any time,
  ##  and the pixel format of the surface will not change.
  ##
  ##  No operating system or library calls should be made between lock/unlock
  ##  pairs, as critical system locks may be held during this time.
  ##
  ##  It should be noted, that since SDL 1.1.8 surface locks are recursive.
  ##  This means that you can lock a surface multiple times, but each lock must
  ##  have a match unlock.
  ##
  ##  ```nim
  ##  lock surface
  ##
  ##  # Surface is locked.
  ##  # Direct pixel access on surface here.
  ##
  ##  lock surface
  ##
  ##  # More direct pixel access on surface.
  ##
  ##  unlock surface
  ##  # Surface is still locked.
  ##  # Note: Is versions < 1.1.8, the surface would have been
  ##  # no longer locked at this stage.
  ##
  ##  unlock surface
  ##  # Surface is now unlocked.
  ##  ```
  ##
  ##  Returns `true`, or `false` if the surface couldn't be locked.
  ##
  ##  Original name: `SDL_LockSurface`
  SDL_LockSurface(surface) == 0

# int SDL_LockYUVOverlay(SDL_Overlay *overlay)
# int SDL_LowerBlit(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst,
#     SDL_Rect *dstrect)

proc MapRGB*(format: ptr PixelFormat, r: byte, g: byte,
             b: byte): uint32 {.inline.} =
  ##  Map a RGB color value to a pixel format.
  ##
  ##  Maps the RGB color value to the specified pixel format and returns
  ##  the pixel value as a 32-bit int.
  ##
  ##  If the format has a palette (8-bit) the index of the closest matching
  ##  color in the palette will be returned.
  ##
  ##  If the specified pixel format has an alpha component it will be returned
  ##  as all 1 bits (fully opaque).
  ##
  ##  Returns a pixel value best approximating the given RGB color value for
  ##  a given pixel format. If the pixel format bpp (color depth) is less than
  ##  32-bpp then the unused upper bits of the return value can safely be
  ##  ignored (e.g., with a 16-bpp format the return value can be assigned
  ##  to a `uint16`, and similarly a `uint8` for an 8-bpp format).
  ##
  ##  Original name: `SDL_MapRGB`
  # XXX: TODO: check result for error?
  SDL_MapRGB format, r, g, b

proc MapRGBA*(format: ptr PixelFormat, r: byte, g: byte, b: byte,
              a: byte): uint32 {.inline.} =
  ##  Map a RGBA color value to a pixel format.
  ##
  ##  Maps the RGBA color value to the specified pixel format and returns
  ##  the pixel value as a 32-bit int.
  ##
  ##  If the format has a palette (8-bit) the index of the closest matching
  ##  color in the palette will be returned.
  ##
  ##  If the specified pixel format has no alpha component the alpha value will
  ##  be ignored (as it will be in formats with a palette).
  ##
  ##  Returns a pixel value best approximating the given RGBA color value for
  ##  a given pixel format. If the pixel format bpp (color depth) is less than
  ##  32-bpp then the unused upper bits of the return value can safely be
  ##  ignored (e.g., with a 16-bpp format the return value can be assigned
  ##  to a `uint16`, and similarly a `uint8` for an 8-bpp format.
  ##
  ##  Original name: `SDL_MapRGBA`
  # XXX: TODO: check result for error?
  SDL_MapRGBA format, r, g, b, a

# int SDL_SaveBMP_RW(SDL_Surface *surface, SDL_RWops *dst, int freedst)

proc SetAlpha*(surface: SurfacePtr, flag: SurfaceFlags, alpha: byte): bool =
  ##  Original name: `SDL_SetAlpha`
  ensure_zero "SDL_SetAlpha":
    SDL_SetAlpha surface, flag, alpha

# SDL_bool SDL_SetClipRect(SDL_Surface *surface, const SDL_Rect *rect)

proc SetColorKey*(surface: SurfacePtr, flag: SurfaceFlags, key: uint32): bool =
  ##  Sets the color key (transparent pixel) in a blittable surface and RLE
  ##  acceleration.
  ##
  ##  Sets the color key (transparent pixel) in a blittable surface and enables
  ##  or disables RLE blit acceleration.
  ##
  ##  RLE acceleration can substantially speed up blitting of images with large
  ##  horizontal runs of transparent pixels (i.e., pixels that match the key
  ##  value). The key must be of the same pixel format as the surface,
  ##  `MapRGB`_ is often useful for obtaining an acceptable value.
  ##
  ##  If flag is `SRCCOLORKEY` then key is the transparent pixel value
  ##  in the source image of a blit.
  ##
  ##  If flag is OR'd with `RLEACCEL` then the surface will be draw using RLE
  ##  acceleration when drawn with `BlitSurface`_. The surface will actually
  ##  be encoded for RLE acceleration the first time `BlitSurface`_
  ##  or `DisplayFormat`_ is called on the surface.
  ##
  ##  If `flag` is `SWSURFACE`, this function clears any current color key.
  ##
  ##  This function returns `true`, or `false` if there was an error.
  ##
  ##  Original name: `SDL_SetColorKey`
  ensure_zero "SDL_SetColorKey":
    SDL_SetColorKey surface, flag, key

proc SetColors*(surface: SurfacePtr, colors: openArray[Color],
                firstcolor: int, ncolors: int): bool =
  ##  Original name: `SDL_SetColors`
  ensure_zero "SDL_SetColors":
    when NimMajor >= 2:
      SDL_SetColors surface, colors[0].addr, firstcolor.cint, ncolors.cint
    else:
      SDL_SetColors surface, colors[0].unsafeAddr, firstcolor.cint, ncolors.cint

proc SetColors*(surface: SurfacePtr, colors: ptr UncheckedArray[Color],
                firstcolor: int, ncolors: int): bool =
  ##  Original name: `SDL_SetColors`
  ensure_zero "SDL_SetColors":
    SDL_SetColors surface, colors[0].addr, firstcolor.cint, ncolors.cint

proc SetGamma*(red: float, green: float, blue: float): bool =
  ##  Sets the color gamma function for the display.
  ##
  ##  Sets the "gamma function" for the display of each color component.
  ##  Gamma controls the brightness/contrast of colors displayed on the screen.
  ##  A gamma value of `1.0` is identity (i.e., no adjustment is made).
  ##
  ##  This function adjusts the gamma based on the "gamma function" parameter,
  ##  you can directly specify lookup tables for gamma adjustment
  ##  with `SetGammaRamp`_.
  ##
  ##  Not all display hardware is able to change gamma.
  ##
  ##  Returns `false` on error (or if gamma adjustment is not supported).
  ##
  ##  Original name: `SDL_SetGamma`
  ensure_zero "SDL_SetGamma":
    SDL_SetGamma red.cfloat, green.cfloat, blue.cfloat

when NimMajor >= 2:
  proc SetGammaRamp*(red: array[256, uint16], green: array[256, uint16],
                     blue: array[256, uint16]): bool =
    ##  Sets the color gamma lookup tables for the display.
    ##
    ##  Sets the gamma lookup tables for the display for each color component.
    ##  Each table is an array of 256 `uint16` values, representing a mapping
    ##  between the input and output for that channel. The input is the index
    ##  into the array, and the output is the 16-bit gamma value at that index,
    ##  scaled to the output color precision. You may pass NULL (@@@) to any of
    ##  the channels to leave them unchanged.
    ##
    ##  This function adjusts the gamma based on lookup tables, you can also
    ##  have the gamma calculated based on a "gamma function" parameter with
    ##  `SetGamma`_.
    ##
    ##  Not all display hardware is able to change gamma.
    ##
    ##  Returns `false` on error (or if gamma adjustment is not supported.
    ##
    ##  Original name: `SDL_SetGammaRamp`
    ensure_zero "SDL_SetGammaRamp":
      SDL_SetGammaRamp red[0].addr, green[0].addr, blue[0].addr
else:
  proc SetGammaRamp*(red: var array[256, uint16],
                     green: var array[256, uint16],
                     blue: var array[256, uint16]): bool =
    ##  @@@
    ensure_zero "SDL_SetGammaRamp":
      SDL_SetGammaRamp red[0].addr, green[0].addr, blue[0].addr

proc SetPalette*(surface: SurfacePtr, flags: PaletteFlags,
                 colors: openArray[Color], firstcolor: int,
                 ncolors: int): bool =
  ##  Original name: `SDL_SetPalette`
  ensure_zero "SDL_SetPalette":
    when NimMajor >= 2:
      SDL_SetPalette surface, flags, colors[0].addr, firstcolor.cint,
                     ncolors.cint
    else:
      SDL_SetPalette surface, flags, colors[0].unsafeAddr, firstcolor.cint,
                     ncolors.cint

proc SetPalette*(surface: SurfacePtr, flags: PaletteFlags,
                 colors: ptr UncheckedArray[Color], firstcolor: int,
                 ncolors: int): bool =
  ##
  ##  .. note::
  ##    Used for easy passing `Surface` format.palette_colors.
  ##
  ##  ```c
  ##  int SDL_SetPalette(SDL_Surface *surface, int flags, SDL_Color *colors,
  ##                     int firstcolor, int ncolors);
  ##  ```
  ensure_zero "SDL_SetPalette":
    SDL_SetPalette surface, flags, colors[0].addr, firstcolor.cint,
                   ncolors.cint

proc SetVideoMode*(width, height: int, bpp: int,
                   flags: SurfaceFlags = SWSURFACE): SurfacePtr =
  ##  Set up a video mode with the specified width, height and bits-per-pixel.
  ##
  ##  If bpp is 0, it is treated as the current display bits per pixel.
  ##
  ##  The `flags` parameter is the same as the `flags` field of the `SurfacePtr`
  ##  structure. OR'd combinations of the following values are valid.
  ##
  ##  - `SWSURFACE`:
  ##    Create the video surface in system memory
  ##  - `HWSURFACE`:
  ##    Create the video surface in video memory
  ##  - `ASYNCBLIT`:
  ##    Enables the use of asynchronous updates of the display surface.
  ##    This will usually slow down blitting on single CPU machines, but may
  ##    provide a speed increase on SMP systems.
  ##  - `ANYFORMAT`:
  ##    Normally, if a video surface of the requested bits-per-pixel (bpp)
  ##    is not available, SDL will emulate one with a shadow surface.
  ##    Passing `ANYFORMAT` prevents this and causes SDL to use the video
  ##    surface, regardless of its pixel depth.
  ##  - `HWPALETTE`:
  ##    Give SDL exclusive palette access. Without this flag you may not always
  ##    get the the colors you request with `SetColors`_ or `SetPalette`_.
  ##  - `DOUBLEBUF`:
  ##    Enable hardware double buffering; only valid with `HWSURFACE`.
  ##    Calling `Flip`_ will flip the buffers and update the screen.
  ##    All drawing will take place on the surface that is not displayed
  ##    at the moment. If double buffering could not be enabled then `Flip`_
  ##    will just perform a `UpdateRect`_ on the entire screen.
  ##  - `FULLSCREEN`:
  ##    SDL will attempt to use a fullscreen mode. If a hardware resolution
  ##    change is not possible (for whatever reason), the next higher resolution
  ##    will be used and the display window centered on a black background.
  ##  - `OPENGL`:
  ##    Create an OpenGL rendering context. You should have previously set
  ##    OpenGL video attributes with `gl_set_attribute`.
  ##  - `OPENGLBLIT`:
  ##    Create an OpenGL rendering context, like above, but allow normal
  ##    blitting operations. The screen (2D) surface may have an alpha channel,
  ##    and `UpdateRects`_ must be used for updating changes to the screen
  ##    surface. NOTE: This option is kept for compatibility only, and is not
  ##    recommended for new code.
  ##  - `RESIZABLE`:
  ##    Create a resizable window. When the window is resized by the user
  ##    a `VIDEORESIZE` event is generated and `SetVideoMode`_ can be called
  ##    again with the new size.
  ##  - `NOFRAME`:
  ##    If possible, `NOFRAME` causes SDL to create a window with no title bar
  ##    or frame decoration. Fullscreen modes automatically have this flag set.
  ##
  ##  .. note::
  ##    Whatever flags `set_video_mode` could satisfy are set in the `flags`
  ##    member of the returned surface
  ##
  ##  .. note::
  ##    The `bpp` parameter is the number of bits per pixel, so a bpp of 24 uses
  ##    the packed representation of 3 bytes/pixel. For the more common
  ##    4 bytes/pixel mode, use a bpp of 32. Somewhat oddly, both 15 and 16 will
  ##    request a 2 bytes/pixel mode, but different pixel formats.
  ##
  ##  Returns the framebuffer surface, or `nil` if it fails. The surface
  ##  returned is freed by `Quit`_ and should nt be freed by the caller.
  ##
  ##  Original name: `SDL_SetVideoMode`
  ensure_not_nil "SDL_SetVideoMode":
    SDL_SetVideoMode width.cint, height.cint, bpp.cint, flags

proc UnlockSurface*(surface: SurfacePtr) =
  ##  Unlocks a previously locked surface.
  ##
  ##  Surfaces that were previously locked using `LockSurface`_ must
  ##  be unlocked with `UnlockSurface`. Surfaces should be unlocked
  ##  as soon as possible.
  ##
  ##  It should be noted that since 1.1.8, surface locks are recursive.
  ##  See `LockSurface`_.
  ##
  ##  Original name: `SDL_UnlockSurface`
  SDL_UnlockSurface surface

proc UpdateRect*(screen: SurfacePtr, x: int32, y: int32,
                 w: uint32, h: uint32) =
  ##  Original name: `SDL_UpdateRect`
  SDL_UpdateRect screen, x.int32, y.int32, w.uint32, h.uint32

proc UpdateRects*(screen: SurfacePtr, rects: openArray[Rect]) =
  ##  Original name: `SDL_UpdateRects`
  when NimMajor >= 2:
    SDL_UpdateRects screen, rects.len.cint, rects[0].addr
  else:
    SDL_UpdateRects screen, rects.len.cint, rects[0].unsafeAddr

proc UpdateRects*(screen: SurfacePtr, numrects: int, rects: openArray[Rect]) =
  ##  Original name: `SDL_UpdateRects`
  # XXX: TODO: check relation numrects vs rects len
  when NimMajor >= 2:
    SDL_UpdateRects screen, numrects.cint, rects[0].addr
  else:
    SDL_UpdateRects screen, numrects.cint, rects[0].unsafeAddr

proc UpperBlit*(src: SurfacePtr, dst: SurfacePtr): bool {.inline.} =
  ##  Original name: `SDL_UpperBlit`
  ensure_zero "SDL_UpperBlit":
    SDL_UpperBlit src, nil, dst, nil

proc UpperBlit*(src: SurfacePtr, dst: SurfacePtr,
                dstrect: Rect): bool {.inline.} =
  ##  Original name: `SDL_UpperBlit`
  when NimMajor < 2:
    var dstrect = dstrect
  ensure_zero "SDL_UpperBlit":
    SDL_UpperBlit src, nil, dst, dstrect.addr

proc UpperBlit*(src: SurfacePtr, srcrect: Rect,
                dst: SurfacePtr, dstrect: Rect): bool {.inline.} =
  ##  Original name: `SDL_UpperBlit`
  when NimMajor < 2:
    var srcrect = srcrect
    var dstrect = dstrect
  ensure_zero "SDL_UpperBlit":
    SDL_UpperBlit src, srcrect.addr, dst, dstrect.addr

when NimMajor < 2:
  proc UpperBlit*(src: SurfacePtr, srcrect: var Rect,
                  dst: SurfacePtr, dstrect: var Rect): bool {.inline.} =
    ##  Original name: `SDL_UpperBlit`
    ##
    ##  .. note:: Fallback for `addr`. Nim 1.6 only.
    ensure_zero "SDL_UpperBlit":
      SDL_UpperBlit src, srcrect.addr, dst, dstrect.addr

proc VideoDriverName*(): string =
  ##  Returns a pointer to information about the video hardware.
  ##
  ##  This function returns a read-only pointer to information about the video
  ##  hardware. If this is called before `SetVideoMode`_, the `vfmt` member
  ##  of the returned structure will contain the pixel format of the "best"
  ##  video mode.
  ##
  ##  Original name: `SDL_VideoDriverName`
  var buf: array[128, char]
  $SDL_VideoDriverName(buf[0].addr, buf.len.cint)

# int SDL_VideoInit(const char *driver_name, Uint32 flags)

proc VideoModeOK*(width: int, height: int, bpp: int,
                  flags: SurfaceFlags = SWSURFACE): int =
  ##  Check to see if a particular video mode is supported.
  ##
  ##  `VideoModeOK` returns 0 if the requested mode is not supported under
  ##  any bit depth, or returns the bits-per-pixel of the closest available
  ##  mode with the given width, height and requested surface `flags`
  ##  (see `SetVideoMode`_).
  ##
  ##  The bits-per-pixel value returned is only a suggested mode. You can
  ##  usually request and `bpp` you want when setting the video mode and SDL
  ##  will emulate that color depth with a shadow video surface.
  ##
  ##  The arguments to `VideoModeOK` are the same ones you would pass
  ##  to `SetVideoMode`_.
  ##
  ##  Original name: `SDL_VideoModeOK`
  SDL_VideoModeOK(width.cint, height.cint, bpp.cint, flags)

# void SDL_VideoQuit(void)

proc WM_GetCaption*(): tuple[title, icon: string] =
  ##  Gets the window title and icon name.
  ##
  ##  Returns window `title` and `icon` name.
  ##
  ##  Original name: `SDL_WM_GetCaption`
  var title, icon: cstring
  SDL_WM_GetCaption title.addr, icon.addr
  ($title, $icon)

proc WM_GrabInput*(mode: GrabMode): GrabMode {.inline.} =
  ##  Grabs mouse and keyboard input.
  ##
  ##  Grabbing means that the mouse is confined to the application window,
  ##  and nearly all keyboard input is passed directly to the application,
  ##  and not interpreted by a window manager, if any.
  ##
  ##  When mode is `GRAB_QUERY` the grab mode is not changed, but the current
  ##  grab mode is returned.
  ##
  ##  Original name: `SDL_WM_GrabInput`
  SDL_WM_GrabInput mode

proc WM_IconifyWindow*(): bool =
  ##  Iconify/minimize the window.
  ##
  ##  If the application is running in a window managed environment SDL
  ##  attempts to iconify/minimize it. If `wm_iconify_window` is successful,
  ##  the application will receive a `APPACTIVE` loss event.
  ##
  ##  Returns `true` on success or `false` if iconification is not support
  ##  or was refused by the window manager
  ##
  ##  Original name: `SDL_WM_IconifyWindow`
  ensure_non_zero "SDL_WM_IconifyWindow":
    SDL_WM_IconifyWindow()

proc WM_SetCaption*(title: string, icon: string) {.inline.} =
  ##  Sets the window tile and icon name.
  ##
  ##  Sets the title-bar and icon name of the display window.
  ##
  ##  Original name: `SDL_WM_SetCaption`
  SDL_WM_SetCaption title.cstring, icon.cstring

proc WM_SetIcon*(icon: SurfacePtr) =
  ##  Sets the icon for the display window.
  ##
  ##  Sets the icon for the display window. Win32 icons must be 32x32.
  ##
  ##  This function must be called before the first call to `SetVideoMode`_.
  ##
  ##  The shape is determined by the colorkey of icon, if any, or makes
  ##  the icon rectangular (no transparency) otherwise.
  ##
  ##  ```nim
  ##  wm_set_icon load_bmp("icon.bmp)
  ##  ```
  ##
  ##  Original name: `SDL_WM_SetIcon`
  SDL_WM_SetIcon icon, nil

proc WM_SetIcon*(icon: SurfacePtr, mask: openArray[byte]) =
  ##  Sets the icon for the display window.
  ##
  ##  Sets the icon for the display window. Win32 icons must be 32x32.
  ##
  ##  This function must be called before the first call to `SetVideoMode`_.
  ##
  ##  The `mask` is a bitmask that describes the shape of the icon.
  ##
  ##  The `mask` points to a bitmap with bits set where the corresponding
  ##  pixel should be visible. The format of the bitmap is as follows:
  ##  Scanlines come in the usual top-down order. Each scanline consists of
  ##  `(width div 8)` bytes, rounded up. The most significant bit of each byte
  ##  represents the leftmost pixel.
  ##
  ##  Original name: `SDL_WM_SetIcon`
  when NimMajor >= 2:
    SDL_WM_SetIcon icon, mask[0].addr         # XXX: TODO: check bitmask size.
  else:
    SDL_WM_SetIcon icon, mask[0].unsafeAddr   # XXX: TODO: check bitmask size.

proc WM_ToggleFullScreen*(surface: SurfacePtr): bool =
  ##  Toggles fullscreen mode.
  ##
  ##  Toggles the application between windowed and fullscreen mode,
  ##  if supported. (X11 is the only target currently supported,
  ##  BeOS support is experimental).
  ##
  ##  Returns `false` on failure or `true` on success.
  ##
  ##  Original name: `SDL_WM_ToggleFullScreen`
  ensure_zero "SDL_WM_ToggleFullScreen":
    SDL_WM_ToggleFullScreen surface

# =========================================================================== #
# ==  C macros                                                             == #
# =========================================================================== #

# --------------------------------------------------------------------------- #
# <SDL/SDL_audio.h>                                                           #
# --------------------------------------------------------------------------- #

when enable_audio:
  proc LoadWAV*(file: string, spec: var AudioSpec,
                audio_buf: var ptr UncheckedArray[byte],
                audio_len: var uint32): ptr AudioSpec {.inline.} =
    ##  Original name: `SDL_LoadWAV`
    LoadWAV_RW_unchecked RWFromFile(file, "rb"), true, spec, audio_buf, audio_len

# --------------------------------------------------------------------------- #
# <SDL/SDL_quit.h>                                                            #
# --------------------------------------------------------------------------- #

proc QuitRequested*(): bool =
  ##  Original name: `SDL_QuitRequested`
  PumpEvents()
  var events: seq[Event] = @[]
  PeepEvents(events, 0, PEEKEVENT, QUITMASK) > 0

# --------------------------------------------------------------------------- #
# <SDL/SDL_video.h>                                                           #
# --------------------------------------------------------------------------- #

template AllocSurface*(flags: SurfaceFlags, width: int, height: int,
                       depth: int, rmask: uint32, gmask: uint32, bmask: uint32,
                       amask: uint32): SurfacePtr =
  ##  ```c
  ##  #define SDL_AllocSurface SDL_CreateRGBSurface
  ##  ```
  CreateRGBSurface flags, width, height, depth, rmask, gmask, bmask, amask

template BlitSurface*(src: SurfacePtr, dst: SurfacePtr): bool =
  ##  Original name: `SDL_BlitSurface`
  UpperBlit src, dst

# template blit_surface*(src: ptr Surface, dst: ptr Surface, dstrect: Rect): bool =
proc BlitSurface*(src: SurfacePtr, dst: SurfacePtr,
                  dstrect: Rect): bool {.inline.} =
  ##  Original name: `SDL_BlitSurface`
  UpperBlit src, dst, dstrect

template BlitSurface*(src: SurfacePtr, srcrect: Rect,
                      dst: SurfacePtr, dstrect: Rect): bool =
  ##  Original name: `SDL_BlitSurface`
  UpperBlit src, srcrect, dst, dstrect

proc LoadBMP*(file: string): SurfacePtr {.inline.} =
  ##  Original name: `SDL_LoadBMP`
  LoadBMP_RW_unchecked(RWFromFile(file, "rb"), true)

# SDL_SaveBMP(surface, file) SDL_SaveBMP_RW(surface, SDL_RWFromFile(file, "wb"), 1)

# =========================================================================== #
# ==  Helper functions                                                     == #
# =========================================================================== #

proc sdl1_avail*(flags: InitFlags = INIT_VIDEO): bool =
  result = Init flags
  if result:
    Quit()

# vim: set sts=2 et sw=2:
