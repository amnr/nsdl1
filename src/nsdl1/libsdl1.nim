##  SDL 1.2 ABI.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

import pkg/dlutils

import config

when enable_audio:
  import sdl1inc/sdl1audio
import sdl1inc/sdl1events
import sdl1inc/sdl1init
when enable_joystick:
  import sdl1inc/sdl1joystick
import sdl1inc/sdl1keysym
when enable_mouse:
  import sdl1inc/sdl1mouse
import sdl1inc/sdl1rwops
import sdl1inc/sdl1timer
import sdl1inc/sdl1version
import sdl1inc/sdl1video

when defined macosx:
  const libpaths = [
    "libSDL-1.2.0.dylib",
    "libSDL.dylib"
  ]
elif defined posix:
  const libpaths = [
    "libSDL-1.2.so",
    "libSDL-1.2.so.0",
    "libSDL-1.2.so.1",
    "libSDL-1.2.so.1.2.68",
  ]
elif defined windows:
  const libpaths = [
    "SDL.dll"
  ]
else:
  {.fatal: "unsupported platform for SDL 1.2.".}

# =========================================================================== #
# ==  SDL 1.2 library object                                               == #
# =========================================================================== #

dlgencalls "sdl1", libpaths:

  # ------------------------------------------------------------------------- #
  # <SDL/SDL.h>                                                               #
  # ------------------------------------------------------------------------- #

  proc SDL_Init(
    flags       : InitFlags
  ): cint

  proc SDL_InitSubSystem(
    flags       : InitFlags
  ): cint

  proc SDL_Quit()

  proc SDL_QuitSubSystem(
    flags       : InitFlags
  )

  proc SDL_WasInit(
    flags       : InitFlags
  ): InitFlags

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_active.h>                                                        #
  # ------------------------------------------------------------------------- #

  # Uint8 SDL_GetAppState(void)

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_audio.h>                                                         #
  # ------------------------------------------------------------------------- #

  when enable_audio:

    proc SDL_AudioDriverName(
      namebuf   : ptr char,
      maxlen    : cint
    ): ptr char

    proc SDL_AudioInit(
      driver_name   : cstring
    ): cint

    proc SDL_AudioQuit()

    proc SDL_BuildAudioCVT(
      cvt           : ptr AudioCVT,
      src_format    : uint16,
      src_channels  : byte,
      src_rate      : cint,
      dst_format    : uint16,
      dst_channels  : byte,
      dst_rate      : cint
    ): cint

    proc SDL_CloseAudio()

    proc SDL_ConvertAudio(
      cvt       : ptr AudioCVT
    ): cint

    proc SDL_GetAudioStatus(): AudioStatus

    proc SDL_FreeWAV(
      audio_buf : ptr byte
    )

    proc SDL_LoadWAV_RW(
      src       : RWopsPtr,
      freesrc   : cint,
      spec      : ptr AudioSpec,
      audio_buf : ptr ptr UncheckedArray[byte],
      audio_len : ptr uint32
    ): ptr AudioSpec

    proc SDL_LockAudio()

    proc SDL_MixAudio(
      dst       : ptr byte,
      src       : ptr byte,
      len       : uint32,
      volume    : cint
    )

    proc SDL_OpenAudio(
      desired   : ptr AudioSpec,
      obtained  : ptr AudioSpec
    ): cint

    proc SDL_PauseAudio(
      pause_on  : cint
    )

    proc SDL_UnlockAudio()

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_error.h>                                                         #
  # ------------------------------------------------------------------------- #

  proc SDL_ClearError()

  # void SDL_Error(SDL_errorcode code)

  proc SDL_GetError(): cstring

  proc SDL_SetError(
    fmt       : cstring
  ) {.varargs.}

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_events.h>                                                        #
  # ------------------------------------------------------------------------- #

  proc SDL_EventState(
    typ       : byte,
    state     : cint
  ): byte

  # SDL_EventFilter SDL_GetEventFilter(void)

  proc SDL_PeepEvents(
    event     : ptr Event,
    numevents : cint,
    action    : EventAction,
    mask      : EventMask
  ): cint

  proc SDL_PollEvent(
    event     : ptr Event
  ): cint

  proc SDL_PumpEvents()

  proc SDL_PushEvent(
    event     : ptr Event
  ): cint

  proc SDL_SetEventFilter(
    filter    : EventFilter
  )

  proc SDL_WaitEvent(
    event     : ptr Event
  ): cint

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_joystick.h>                                                      #
  # ------------------------------------------------------------------------- #

  when enable_joystick:

    proc SDL_JoystickClose(
      joystick      : Joystick
    )

    proc SDL_JoystickEventState(
      state         : cint
    ): cint

    proc SDL_JoystickGetAxis(
      joystick      : Joystick,
      axis          : cint
    ): int16

    proc SDL_JoystickGetBall(
      joystick      : Joystick,
      ball          : cint,
      dx            : ptr cint,
      dy            : ptr cint
    ): cint

    proc SDL_JoystickGetButton(
      joystick      : Joystick,
      button        : cint
    ): byte

    proc SDL_JoystickGetHat(
      joystick      : Joystick,
      hat           : cint
    ): byte

    proc SDL_JoystickIndex(
      joystick      : Joystick
    ): cint

    proc SDL_JoystickName(
      device_index  : cint
    ): cstring

    proc SDL_JoystickNumAxes(
      joystick      : Joystick
    ): cint

    proc SDL_JoystickNumBalls(
      joystick      : Joystick
    ): cint

    proc SDL_JoystickNumButtons(
      joystick      : Joystick
    ): cint

    proc SDL_JoystickNumHats(
      joystick      : Joystick
    ): cint

    proc SDL_JoystickOpen(
      device_index  : cint
    ): Joystick

    proc SDL_JoystickOpened(
      device_index  : cint
    ): cint

    proc SDL_JoystickUpdate()

    proc SDL_NumJoysticks(): cint

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_keyboard.h>                                                      #
  # ------------------------------------------------------------------------- #

  when enable_keyboard:

    proc SDL_EnableKeyRepeat(
      delay     : cint,
      interval  : cint
    ): cint

    proc SDL_EnableUNICODE(
      enable    : cint
    ): cint

    proc SDL_GetKeyName(
      key       : Key
    ): cstring

    proc SDL_GetKeyRepeat(
      delay     : ptr cint,
      interval  : ptr cint
    )

    proc SDL_GetKeyState(
      numkeys   : ptr cint
    ): ptr byte

    proc SDL_GetModState(): Mod

    proc SDL_SetModState(
      modstate  : Mod
    )

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_main.h>                                                          #
  # ------------------------------------------------------------------------- #

  # int SDL_RegisterApp(char *name, Uint32 style, void *hInst)
  # void SDL_SetModuleHandle(void *hInst)
  # void SDL_UnregisterApp(void)

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_mouse.h>                                                         #
  # ------------------------------------------------------------------------- #

  when enable_mouse:

    proc SDL_CreateCursor(
      data    : ptr byte,
      mask    : ptr byte,
      w       : cint,
      h       : cint,
      hot_x   : cint,
      hot_y   : cint
    ): ptr Cursor

    proc SDL_FreeCursor(
      cursor  : ptr Cursor
    )

    proc SDL_GetCursor(): ptr Cursor

    proc SDL_GetMouseState(
      x       : ptr cint,
      y       : ptr cint
    ): MouseButton

    proc SDL_GetRelativeMouseState(
      x       : ptr cint,
      y       : ptr cint
    ): MouseButton

    proc SDL_SetCursor(
      cursor  : ptr Cursor
    )

    proc SDL_ShowCursor(
      toggle  : cint
    ): cint

    proc SDL_WarpMouse(
      x       : uint16,
      y       : uint16
    )

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_rwops.h>                                                         #
  # ------------------------------------------------------------------------- #

  # NOTE: Only single function imported.

  proc SDL_RWFromFile(
    file      : cstring,
    mode      : cstring
  ): RWopsPtr

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_syswm.h>                                                         #
  # ------------------------------------------------------------------------- #

  # int SDL_GetWMInfo(SDL_SysWMinfo *info)

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_timer.h>                                                         #
  # ------------------------------------------------------------------------- #

  proc SDL_AddTimer(
    interval  : uint32,
    callback  : NewTimerCallback,
    param     : pointer
  ): TimerID

  proc SDL_Delay(ms: uint32)

  proc SDL_GetTicks(): uint32

  proc SDL_RemoveTimer(
    t         : TimerID
  ): SdlBool

  proc SDL_SetTimer(
    interval  : uint32,
    callback  : TimerCallback
  ): cint

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_version.h>                                                       #
  # ------------------------------------------------------------------------- #

  proc SDL_Linked_Version(): ptr Version

  # ------------------------------------------------------------------------- #
  # <SDL/SDL_video.h>                                                         #
  # ------------------------------------------------------------------------- #

  proc SDL_ConvertSurface(
    src       : ptr Surface,
    fmt       : ptr PixelFormat,
    flags     : SurfaceFlags
  ): ptr Surface

  proc SDL_CreateRGBSurface(
    flags     : uint32,
    width     : cint,
    height    : cint,
    depth     : cint,
    rmask     : uint32,
    gmask     : uint32,
    bmask     : uint32,
    amask     : uint32
  ): ptr Surface

  proc SDL_CreateRGBSurfaceFrom(
    pixels    : pointer,
    width     : cint,
    height    : cint,
    depth     : cint,
    pitch     : cint,
    rmask     : uint32,
    gmask     : uint32,
    bmask     : uint32,
    amask     : uint32
  ): ptr Surface

  # SDL_Overlay * SDL_CreateYUVOverlay(int width, int height, Uint32 format,
  #     proc SDL_Surface *display)

  proc SDL_DisplayFormat(
    surface   : ptr Surface
  ): ptr Surface

  proc SDL_DisplayFormatAlpha(
    surface   : ptr Surface
  ): ptr Surface

  # int SDL_DisplayYUVOverlay(SDL_Overlay *overlay, SDL_Rect *dstrect)
  
  proc SDL_FillRect(
    dst       : ptr Surface,
    dstrect   : ptr Rect,
    color     : uint32
  ): cint

  proc SDL_Flip(
    surface   : ptr Surface
  ): cint

  proc SDL_FreeSurface(
    surface   : ptr Surface
  )

  # void SDL_FreeYUVOverlay(SDL_Overlay *overlay)
  # int SDL_GL_GetAttribute(SDL_GLattr attr, int* value)
  # void * SDL_GL_GetProcAddress(const char* proc)
  # int SDL_GL_LoadLibrary(const char *path)
  # void SDL_GL_Lock(void)
  # int SDL_GL_SetAttribute(SDL_GLattr attr, int value)
  # void SDL_GL_SwapBuffers(void)
  # void SDL_GL_Unlock(void)
  # void SDL_GL_UpdateRects(int numrects, SDL_Rect* rects)

  proc SDL_GetClipRect(
    surface   : ptr Surface,
    rect      : ptr Rect
  )

  proc SDL_GetGammaRamp(
    red       : ptr uint16,
    green     : ptr uint16,
    blue      : ptr uint16
  ): cint

  proc SDL_GetRGB(
    pixel     : uint32,
    fmt       : ptr PixelFormat,
    r         : ptr byte,
    g         : ptr byte,
    b         : ptr byte
  )

  proc SDL_GetRGBA(
    pixel     : uint32,
    fmt       : ptr PixelFormat,
    r         : ptr byte,
    g         : ptr byte,
    b         : ptr byte,
    a         : ptr byte
  )

  proc SDL_GetVideoInfo(): ptr VideoInfo

  proc SDL_GetVideoSurface(): ptr Surface

  proc SDL_ListModes(
    format    : ptr PixelFormat,
    flags     : SurfaceFlags
  ): ptr UncheckedArray[ptr Rect]

  proc SDL_LoadBMP_RW(
    src       : RWopsPtr,
    freesrc   : cint
  ): ptr Surface

  proc SDL_LockSurface(
    surface   : ptr Surface
  ): cint

  # int SDL_LockYUVOverlay(SDL_Overlay *overlay)
  # int SDL_LowerBlit(SDL_Surface *src, SDL_Rect *srcrect, SDL_Surface *dst,
  #     proc SDL_Rect *dstrect)

  proc SDL_MapRGB(
    format    : ptr PixelFormat,
    r         : byte,
    g         : byte,
    b         : byte
  ): uint32

  proc SDL_MapRGBA(
    format    : ptr PixelFormat,
    r         : byte,
    g         : byte,
    b         : byte,
    a         : byte
  ): uint32

  # int SDL_SaveBMP_RW(SDL_Surface *surface, SDL_RWops *dst, int freedst)

  proc SDL_SetAlpha(
    surface   : ptr Surface,
    flag      : SurfaceFlags,
    alpha     : byte
  ): cint

  proc SDL_SetClipRect(
    surface   : ptr Surface,
    rect      : ptr Rect
  ): SdlBool

  proc SDL_SetColorKey(
    surface   : ptr Surface,
    flag      : SurfaceFlags,
    key       : uint32
  ): cint

  # XXX: version?
  proc SDL_SetColors(
    surface     : ptr Surface,
    colors      : ptr Color,
    firstcolor  : cint,
    ncolors     : cint
  ): cint

  proc SDL_SetGamma(
    red       : cfloat,
    green     : cfloat,
    blue      : cfloat
  ): cint

  proc SDL_SetGammaRamp(
    red       : ptr uint16,     # UncheckedArray[256].
    green     : ptr uint16,
    blue      : ptr uint16
  ): cint

  proc SDL_SetPalette(
    surface     : ptr Surface,
    flags       : PaletteFlags,
    colors      : ptr Color,    # ptr UncheckedArray[Color]
    firstcolor  : cint,
    ncolors     : cint
  ): cint

  proc SDL_SetVideoMode(
    width     : cint,
    height    : cint,
    bpp       : cint,
    flags     : SurfaceFlags
  ): ptr Surface

  proc SDL_UnlockSurface(
    surface   : ptr Surface
  )

  # void SDL_UnlockYUVOverlay(SDL_Overlay *overlay)

  proc SDL_UpdateRect(
    screen    : ptr Surface,
    x         : int32,
    y         : int32,
    w         : uint32,
    h         : uint32
  )

  proc SDL_UpdateRects(
    screen    : ptr Surface,
    numrects  : cint,
    rects     : ptr Rect
  )

  proc SDL_UpperBlit(
    src       : ptr Surface,
    srcrect   : ptr Rect,
    dst       : ptr Surface,
    dstrect   : ptr Rect
  ): cint

  proc SDL_VideoDriverName(
    namebuf   : ptr char,
    maxlen    : cint
  ): cstring

  proc SDL_VideoInit(
    driver_name : cstring,
    flags       : SurfaceFlags
  ): cint

  proc SDL_VideoModeOK(
    width     : cint,
    height    : cint,
    bpp       : cint,
    flags     : SurfaceFlags
  ): cint

  proc SDL_VideoQuit()

  proc SDL_WM_GetCaption(
    title     : ptr cstring,
    icon      : ptr cstring
  )

  proc SDL_WM_GrabInput(
    mode      : GrabMode
  ): GrabMode

  proc SDL_WM_IconifyWindow(): cint

  proc SDL_WM_SetCaption(
    title     : cstring,
    icon      : cstring
  )

  proc SDL_WM_SetIcon(
    icon      : ptr Surface,
    mask      : ptr byte
  )

  proc SDL_WM_ToggleFullScreen(
    surface   : ptr Surface
  ): cint

# vim: set sts=2 et sw=2:
