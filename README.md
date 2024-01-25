# High level SDL 1.2 shared library wrapper for Nim

**nsdl1** is a high level **SDL 1.2** shared library wrapper for Nim.

## Features

- Tries to hide as many C types from the user as possible.
- Replaces generic C types with Nim distinct ones.
- Does not require **SDL 1.2** library headers during build process.
- The executable is not linked again a specific **SDL 1.2** library version.
- Loads **SDL 1.2** library only when you need it (via `dynlib` module).
- Single external dependency: [dlutils](https://github.com/amnr/dlutils).

> **_NOTE:_** Not everything is implemented yet.

> **_NOTE:_** This is a mirror of my local git repository.

## API

Original C `SDL_` prefix is dropped:

- `SDL_INIT_VIDEO` becomes `INIT_VIDEO`
- `SDL_GetTicks` becomes `GetTicks`
- etc.

Refer to the [documentation](https://amnr.github.io/nsdl1/) for the complete
list of changes.

## Installation

```sh
git clone https://github.com/amnr/nsdl1/
cd nsdl1
nimble install
```

## Configuration

You can disable functions you don't use.
All function groups are enabled by default.

| Group       | Define              | Functions Defined In        |
| ----------- | ------------------- | --------------------------- |
| Audio       | `sdl1.audio=0`      | ``<SDL/SDL_audio.h>``       |
| Clipboard   | `sdl1.clipboard=0`  | ``<SDL/SDL_clipboard.h>``   |
| Joystick    | `sdl1.joystick=0`   | ``<SDL/SDL_joystick.h>``    |
| Keyboard    | `sdl1.keyboard=0`   | ``<SDL/SDL_keyboard.h>``    |
| Mouse       | `sdl1.mouse=0`      | ``<SDL/SDL_mouse.h>``       |

For example if you don't need audio functions compile with:

```sh
nim c -d=sdl1.audio=0 file(s)
```

## Basic Usage

```nim
import nsdl1

proc main() =
  # Load all symbols from SDL 1.2 shared library.
  # This must be the first proc called.
  if not open_sdl1_library():
    echo "Failed to load SDL 1.2 library: ", last_sdl1_error()
    quit QuitFailure
  defer:
    close_sdl1_library()

  # Initialize the library.
  if not Init INIT_VIDEO or INIT_NOPARACHUTE:
    echo "Error initializing SDL: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  # Create the window.
  let window = SetVideoMode(640, 480, 32)
  if window == nil:
    echo "Error creating window: ", GetError()
    quit QuitFailure
  defer:
    FreeSurface window

  # Set window title.
  WM_SetCaption "Sample Window", "Sample Window"

  # Basic event loop.
  var event: Event
  while true:
    while PollEvent event:
      case event.typ
      of EVENT_QUIT:
        return
      else:
       discard
    Delay 100

when isMainModule:
  main()
```

You can find more examples [here](examples/).

## Author

- [Amun](https://github.com/amnr/)

## License

`nsdl1` is released under:

- [**LGPL-2.1**](LICENSE-LGPL-2.1.txt) &mdash; SDL 1.2 license
- [**MIT**](LICENSE-MIT.txt) &mdash; Nim license
- [**NCSA**](LICENSE-NCSA.txt) &mdash; author's license of choice

Pick the one you prefer (or all).
