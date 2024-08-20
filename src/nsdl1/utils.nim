##  SDL ABI utils.
##
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

when defined uselogging:
  import std/logging
import std/macros

const
  uselogging {.booldefine.} = false

when uselogging:
  template log_error*(args: varargs[typed, `$`]) =
    try:
      unpackVarargs echo, "ERROR: SDL1: ", args
    except Exception:
      discard
else:
  template log_error*(args: varargs[typed, `$`]) =
    unpackVarargs echo, "ERROR: SDL1: ", args

macro available_since*(procvar: typed, minver: string) =
  ##  Check whether unchecked function is available.
  ##
  ##  If the function is not available, the default value of return type
  ##  is returned.
  let procname = $procvar
  quote do:
    if `procvar` == nil:
      log_error `procname`, " is available since SDL ", `minver`
      return result.type.default

template ensure_not_nil*(procname: string, body: untyped) =
  when result.typeof isnot ptr:
    {.fatal: "ensure_not_nil requires function that returns pointer".}
  result = body
  if unlikely result == nil:
    log_error procname, " failed: ", $SDL_GetError()
    return nil

template ensure_non_zero*(procname: string, body: untyped) =
  let res {.inject.} = body
  if unlikely res == 0:
    log_error procname, " failed: ", $SDL_GetError()
    result = false
  else:
    result = true

template ensure_zero*(procname: string, body: untyped) =
  let res {.inject.} = body
  if unlikely res != 0:
    log_error procname, " failed: ", $SDL_GetError()
    result = false
  else:
    result = true

# vim: set sts=2 et sw=2:
