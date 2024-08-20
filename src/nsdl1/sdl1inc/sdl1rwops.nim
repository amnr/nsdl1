##  RWops definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

type
  RWops {.final, incompleteStruct, pure.} = object

  RWopsPtr* = ptr RWops

# vim: set sts=2 et sw=2:
