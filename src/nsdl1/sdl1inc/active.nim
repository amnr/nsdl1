##  Application focus event definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

type
  AppState* = distinct byte
    ##  Application state.

func `and`*(a, b: AppState): AppState {.borrow.}
func `or`*(a, b: AppState): AppState {.borrow.}

func `==`*(a: AppState, b: byte): bool {.borrow.}

const
  APPMOUSEFOCUS*  = AppState 0x01   ##  The application has mouse coverage.
  APPINPUTFOCUS*  = AppState 0x02   ##  The application has input focus.
  APPACTIVE*      = AppState 0x04   ##  The application is active.

# vim: set sts=2 et sw=2:
