##  Play WAV file.
#[
  SPDX-License-Identifier: NCSA
]#

import std/os

import nsdl1

type
  PlayContext = object
    spec    : AudioSpec
    data    : ptr UncheckedArray[byte]
    datalen : uint32
    pos     : uint32

func `$`(format: AudioFormat): string =
  case format
  of AUDIO_U8     : "AUDIO_U8"
  of AUDIO_S8     : "AUDIO_S8"
  of AUDIO_U16LSB : "AUDIO_U16LSB"
  of AUDIO_S16LSB : "AUDIO_S16LSB"
  of AUDIO_U16MSB : "AUDIO_U16MSB"
  of AUDIO_S16MSB : "AUDIO_S16MSB"
  else            : "(unknown)"

func `$`*(self: PlayContext): string =
  "PlayContext(pos: " & $self.pos & " / " & $self.datalen & ")"

var
  wav: PlayContext

proc callback(userdata: pointer, stream: ptr UncheckedArray[byte],
              len: cint) {.cdecl, raises: [].} =
  let ctx = cast[ptr PlayContext](userdata)

  assert ctx.pos == wav.pos
  assert ctx.datalen == wav.datalen
  assert ctx.data == wav.data

  if wav.pos >= wav.datalen:
    echo "AGAIN"
    wav.pos = 0
    # return

  let bytes_left = wav.datalen - wav.pos

  let num_bytes = min(len.uint32, bytes_left)

  # echo "callback, len: ", len, " pos: ", wav.pos, " / ", wav.datalen, " num_bytes: ", num_bytes

  MixAudio stream, wav.data[wav.pos].addr, num_bytes, MIX_MAXVOLUME

  wav.pos += num_bytes
  # audio_len -= num_bytes

proc play_wav(path: string): bool =
  if LoadWAV(path, wav.spec, wav.data, wav.datalen) == nil:
    echo "Failed to load WAV file: ", GetError()
    return false
  defer:
    FreeWAV wav.data

  echo "WAV file: ", wav.spec.format, " format, ",
       wav.spec.channels, " channels, ", wav.spec.freq, " Hz, ",
       wav.spec.samples, " samples"
  echo wav.repr

  var wanted: AudioSpec

  wanted.freq     = wav.spec.freq
  wanted.format   = wav.spec.format
  wanted.channels = wav.spec.channels
  wanted.samples  = wav.spec.samples
  wanted.callback = callback
  wanted.userdata = wav.addr

  echo "driver: ", AudioDriverName()

  if not OpenAudio wanted:
    echo "Failed to open audio: ", GetError()
    return false
  defer:
    CloseAudio()

  echo "driver: ", AudioDriverName()

  echo "Native format? ", wanted.format == AUDIO_S16SYS

  echo "Ready to rock."

  PauseAudio false

  var event: Event

  while true:#wav.pos < wav.datalen:
    while PollEvent event:
      discard

    Delay 100

  PauseAudio true

  true

proc main() =
  if paramCount() != 1:
    echo "Usage: ", getAppFilename(), " <wav>"
    quit QuitSuccess

  let test_file = paramStr 1

  # Load library.
  if not open_sdl1_library():
    echo "Failed to load SDL 1.2 library: ", last_sdl1_error()
    quit QuitFailure
  defer:
    close_sdl1_library()

  # Initialize SDL.
  if not Init INIT_AUDIO or INIT_NOPARACHUTE:
    echo "Failed to initialize SDL: ", GetError()
    quit QuitFailure
  defer:
    Quit()

  if not play_wav test_file:
    quit QuitFailure

when isMainModule:
  main()

# vim: set sts=2 et sw=2:
