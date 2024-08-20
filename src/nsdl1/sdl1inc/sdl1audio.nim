##  Audio related definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

type
  AudioFormat* = distinct uint16
    ##  Audio format (ported to `nsdl1` from SDL2).

func `and`*(a, b: AudioFormat): AudioFormat {.borrow.}
func `or`*(a, b: AudioFormat): AudioFormat {.borrow.}

func `==`*(a, b: AudioFormat): bool {.borrow.}

type
  AudioCallback* = proc (userdata: pointer, stream: ptr UncheckedArray[byte],
                         len: cint) {.cdecl, raises: [].}

type
  AudioSpec* {.final, pure.} = object
    ##  Audio specification.
    freq*       : cint            ##  Frequency (samples per second).
                                  ##  `ms` = 1000 * `samples` / `freq`.
    format*     : AudioFormat     ##  Audio data format.
    channels*   : byte            ##  Number of channels: 1 mono, 2 stereo.
    silence*    : byte            ##  Audio buffer silence value. Calculated.
    samples*    : uint16          ##  Audio buffer size (samples). Power of 2.
                                  ##  Common buffer sizes: 512 - 8096.
    padding     : uint16
    size*       : uint32          ##  Audio buffer size (bytes). Calculated.
    callback*   : AudioCallback   ##  Audio feed callback.
    userdata*   : pointer         ##  User defined pointer.

const
  # Audio format flags.
  AUDIO_U8*       = AudioFormat 0x0008    ##  Unsigned 8-bit samples.
  AUDIO_S8*       = AudioFormat 0x8008    ##  Signed 8-bit samples.
  AUDIO_U16LSB*   = AudioFormat 0x0010    ##  Unsigned 16-bit samples (little endian).
  AUDIO_S16LSB*   = AudioFormat 0x8010    ##  Signed 16-bit samples (little endian).
  AUDIO_U16MSB*   = AudioFormat 0x1010    ##  Unsigned 16-bit samples (big endian).
  AUDIO_S16MSB*   = AudioFormat 0x9010    ##  Signed 16-bit samples (big endian).
  AUDIO_U16*      = AUDIO_U16LSB
  AUDIO_S16*      = AUDIO_S16LSB

when cpuEndian == littleEndian:
  const
    AUDIO_U16SYS* = AUDIO_U16LSB
    AUDIO_S16SYS* = AUDIO_S16LSB
else:
  const
    AUDIO_U16SYS* = AUDIO_U16MSB
    AUDIO_S16SYS* = AUDIO_S16MSB

type
  AudioFilter* = proc (cvt: ptr AudioCVT,
                       format: AudioFormat) {.cdecl, gcsafe, raises: [].}
    ##  Audio filter (ported to `nsdl1` from SDL2).

  AudioCVT* {.final, pure.} = object
    ##  Audio conversion filters and buffers.
    needed*       : cint          ##  Set to 1 if conversion possible.
    src_format*   : AudioFormat   ##  Source audio format.
    dst_format*   : AudioFormat   ##  Target audio format.
    rate_incr*    : cdouble       ##  Rate conversion increment.
    buf*          : ptr byte      ##  Buffer to hold entire audio data.
    len*          : cint          ##  Length of original audio buffer.
    len_cvt*      : cint          ##  Length of converted audio buffer.
    len_mult*     : cint          ##  buffer must be len*len_mult big.
    len_ratio*    : cdouble       ##  Given len, final size is len * len_ratio.
    filters*      : array[10, AudioFilter]
    filter_index* : cint          ##  Current audio conversion function.

type
  AudioStatus* {.size: cint.sizeof.} = enum
    AUDIO_STOPPED = 0
    AUDIO_PLAYING
    AUDIO_PAUSED

const
  MIX_MAXVOLUME*  = 128

# --------------------------------------------------------------------------- #
#   Sanity checks                                                             #
# --------------------------------------------------------------------------- #

when defined(gcc) and hostCPU == "amd64":
  when AudioSpec.sizeof != 32:
    {.fatal: "invalid AudioSpec size: " & $AudioSpec.sizeof.}
  when AudioCVT.sizeof != 136:
    {.fatal: "invalid AudioCVT size: " & $AudioCVT.sizeof.}

# vim: set sts=2 et sw=2:
