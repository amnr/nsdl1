##  Event definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

import keyboard
from active import AppState
from joystick import HatPosition
from mouse import MouseButton

# XXX: TODO: make it an enum?
type
  MouseState* = distinct byte
    ##  Mouse state.

const
  RELEASED*   = MouseState 0
  PRESSED*    = MouseState 1

type
  EventType* {.size: byte.sizeof.} = enum
    ##  Event types.
    EVENT_NOEVENT = 0       ##  Unused.
    EVENT_ACTIVEEVENT       ##  Application loses/gains visibility.
    EVENT_KEYDOWN           ##  Keys pressed.
    EVENT_KEYUP             ##  Keys released.
    EVENT_MOUSEMOTION       ##  Mouse moved.
    EVENT_MOUSEBUTTONDOWN   ##  Mouse button pressed.
    EVENT_MOUSEBUTTONUP     ##  Mouse button released.
    EVENT_JOYAXISMOTION     ##  Joystick axis motion.
    EVENT_JOYBALLMOTION     ##  Joystick trackball motion.
    EVENT_JOYHATMOTION      ##  Joystick hat position change.
    EVENT_JOYBUTTONDOWN     ##  Joystick button pressed.
    EVENT_JOYBUTTONUP       ##  Joystick button released.
    EVENT_QUIT              ##  User-requested quit.
    EVENT_SYSWMEVENT        ##  System specific event.
    EVENT_EVENTRESERVEDA    ##  Reserved.
    EVENT_EVENTRESERVEDB    ##  Reserved.
    EVENT_VIDEORESIZE       ##  User resized video mode.
    EVENT_VIDEOEXPOSE       ##  Screen needs to be redrawn.
    EVENT_EVENTRESERVED2    ##  Reserved.
    EVENT_EVENTRESERVED3    ##  Reserved.
    EVENT_EVENTRESERVED4    ##  Reserved.
    EVENT_EVENTRESERVED5    ##  Reserved.
    EVENT_EVENTRESERVED6    ##  Reserved.
    EVENT_EVENTRESERVED7    ##  Reserved.
    # User defined events.
    # Nim exclusive defines. 10 custom user events ought to be enough for anyone.
    EVENT_USEREVENT  = 24
    EVENT_USEREVENT2
    EVENT_USEREVENT3
    EVENT_USEREVENT4
    EVENT_USEREVENT5
    EVENT_USEREVENT6
    EVENT_USEREVENT7
    EVENT_USEREVENT8
    EVENT_USEREVENT9

func eventmask(e: EventType): uint32 {.compiletime.} =
  1'u32 shl e.uint32

type
  EventMask* {.pure, size: uint32.sizeof.} = enum
    ##  Event masks.
    ACTIVEEVENTMASK     = eventmask EVENT_ACTIVEEVENT
    KEYDOWNMASK         = eventmask EVENT_KEYDOWN
    KEYUPMASK           = eventmask EVENT_KEYUP
    KEYEVENTMASK        = (eventmask EVENT_KEYDOWN) or
                          (eventmask EVENT_KEYUP)
    MOUSEMOTIONMASK     = eventmask EVENT_MOUSEMOTION
    MOUSEBUTTONDOWNMASK = eventmask EVENT_MOUSEBUTTONDOWN
    MOUSEBUTTONUPMASK   = eventmask EVENT_MOUSEBUTTONUP
    MOUSEEVENTMASK      = (eventmask EVENT_MOUSEMOTION) or
                          (eventmask EVENT_MOUSEBUTTONDOWN) or
                          (eventmask EVENT_MOUSEBUTTONUP)
    JOYAXISMOTIONMASK   = eventmask EVENT_JOYAXISMOTION
    JOYBALLMOTIONMASK   = eventmask EVENT_JOYBALLMOTION
    JOYHATMOTIONMASK    = eventmask EVENT_JOYHATMOTION
    JOYBUTTONDOWNMASK   = eventmask EVENT_JOYBUTTONDOWN
    JOYBUTTONUPMASK     = eventmask EVENT_JOYBUTTONUP
    JOYEVENTMASK        = (eventmask EVENT_JOYAXISMOTION) or
                          (eventmask EVENT_JOYBALLMOTION) or
                          (eventmask EVENT_JOYHATMOTION) or
                          (eventmask EVENT_JOYBUTTONDOWN) or
                          (eventmask EVENT_JOYBUTTONUP)
    QUITMASK            = eventmask EVENT_QUIT
    SYSWMEVENTMASK      = eventmask EVENT_SYSWMEVENT
    VIDEORESIZEMASK     = eventmask EVENT_VIDEORESIZE
    VIDEOEXPOSEMASK     = eventmask EVENT_VIDEOEXPOSE
    ALLEVENTS           = 0xffff_ffff'u32

type
  ActiveEvent* {.final, pure.} = object
    ##  Application visibility event.
    typ*      : EventType     ##  `EVENT_ACTIVEEVENT`.
    gain*     : byte          ##  State gain (1) or lost (0).
    state*    : AppState      ##  App focus state.

  KeyboardEvent* {.final, pure.} = object
    ##  Keyboard event.
    typ*      : EventType     ##  `EVENT_KEYDOWN` or `EVENT_KEYUP`.
    which*    : byte          ##  Keyboard device index.
    state*    : byte          ##  Key state: `PRESSED` or `RELEASED`.
    keysym*   : Keysym        ##  Keysym.

  MouseMotionEvent* {.final, pure.} = object
    ##  Mouse motion event.
    typ*      : EventType     ##  `EVENT_MOUSEMOTION`.
    which*    : byte          ##  Mouse device index.
    state*    : byte          ##  Button state.
    x*        : uint16        ##  Mouse X position.
    y*        : uint16        ##  Mouse Y position.
    xrel*     : int16         ##  Relative motion (X direction).
    yrel*     : int16         ##  Relative motion (Y direction).

  MouseButtonEvent* {.final, pure.} = object
    ##  Mouse button event.
    typ*      : EventType     ##  `EVENT_MOUSEBUTTONDOWN` or `EVENT_MOUSEBUTTONUP`.
    which*    : byte          ##  Mouse device index.
    button*   : MouseButton   ##  Mouse button index.
    state*    : MouseState    ##  Button state: `PRESSED` or `RELEASED`.
    x*        : uint16        ##  Mouse X position (at press time).
    y*        : uint16        ##  Mouse Y position (at press time).

  JoyAxisEvent* {.final, pure.} = object
    ##  Joystick axis motion event.
    typ*      : EventType     ##  `EVENT_JOYAXISMOTION`.
    which*    : byte          ##  Joystick device index.
    axis*     : byte          ##  Joystick axis index.
    value*    : int16         ##  Axis value (range: -32768 to 32767).

  JoyBallEvent* {.final, pure.} = object
    ##  Joystick trackball motion event.
    typ*      : EventType     ##  `EVENT_JOYBALLMOTION`.
    which*    : byte          ##  Joystick device index.
    ball*     : byte          ##  Joystick trackball index.
    xrel*     : int16         ##  Relative motion (X direction).
    yrel*     : int16         ##  Relative motion (Y direction).

  JoyHatEvent* {.final, pure.} = object
    ##  Joystick hat position change event.
    typ*      : EventType     ##  `EVENT_JOYHATMOTION`.
    which*    : byte          ##  Joystick device index.
    # XXX: make it a `Hat` value?
    hat*      : byte          ##  Joystick hat index.
    value*    : HatPosition   ##  Hat position.

  JoyButtonEvent* {.final, pure.} = object
    ##  Joystick button event.
    typ*      : EventType     ##  `EVENT_JOYBUTTONDOWN` or `EVENT_JOYBUTTONUP`.
    which*    : byte          ##  Joystick device index.
    button*   : byte          ##  Joystick button index.
    state*    : byte          ##  Button state: `PRESSED` or `RELEASED`.

  ResizeEvent* {.final, pure.} = object
    ##  The window resize event. The user is responsible for setting a new
    ##  video mode with new size.
    typ*      : EventType     ##  `EVENT_VIDEORESIZE`.
    w*        : cint          ##  New width.
    h*        : cint          ##  New height.

  ExposeEvent* {.final, pure.} = object
    ##  The screen redraw event.
    typ*      : EventType     ##  `EVENT_VIDEOEXPOSE`.

  QuitEvent* {.final, pure.} = object
    ##  The quit request event.
    typ*      : EventType     ##  `EVENT_QUIT`.

  UserEvent* {.final, pure.} = object
    ##  A user defined event.
    typ*      : EventType     ##  `EVENT_USEREVENT` - `EVENT_USEREVENT9`.
    code*     : cint          ##  User defined event code.
    data1*    : pointer       ##  User defined data pointer.
    data2*    : pointer       ##  User defined data pointer.

  SysWMmsg {.final, incompletestruct, pure.} = object

  SysWMmsgPtr* = ptr SysWMmsg

  SysWMEvent* {.final, pure.} = object
    typ*      : EventType
    msg*      : SysWMmsgPtr

type
  Event* {.bycopy, final, pure, union.} = object
    ##  Event.
    typ*      : EventType
    active*   : ActiveEvent
    key*      : KeyboardEvent
    motion*   : MouseMotionEvent
    button*   : MouseButtonEvent
    jaxis*    : JoyAxisEvent
    jball*    : JoyBallEvent
    jhat*     : JoyHatEvent
    jbutton*  : JoyButtonEvent
    resize*   : ResizeEvent
    expose*   : ExposeEvent
    quit*     : QuitEvent
    user*     : UserEvent
    syswm*    : SysWMEvent

type
  EventAction* {.size: cint.sizeof.} = enum
    ADDEVENT
    PEEKEVENT
    GETEVENT

type
  EventState* = distinct cint
    ##  Event state.

# XXX: make the type pure?
const
  QUERY*    = EventState -1
  IGNORE*   = EventState 0
  DISABLE*  = EventState 0
  ENABLE*   = EventState 1

type
  EventFilter* = proc (event: ptr Event): cint {.cdecl, gcsafe, raises: [].}

# ============================================================================ #
# ==  Nim specific                                                          == #
# ============================================================================ #

# Calling default `$` and repr on union in Nim results with:
# SIGSEGV: Illegal storage access. (Attempt to read from nil?)

when defined release:
  func `$`*(event: ptr Event): string {.error: "do not `$` unions in Nim".}
  func repr*(event: Event): string {.error: "do not repr unions in Nim".}
else:
  func `$`*(event: Event): string = "(typ: " & $event.typ & ", ...)"
  func repr*(event: Event): string = "[typ = " & $event.typ & ", ...]"

func repr*(event: ptr Event): string {.error: "do not repr unions in Nim".}

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when ActiveEvent.sizeof != 3:
    {.fatal: "invalid ActiveEvent size: " & $ActiveEvent.sizeof.}

# vim: set sts=2 et sw=2:
