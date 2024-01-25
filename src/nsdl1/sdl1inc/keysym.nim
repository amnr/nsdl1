##  Keysym definitions.
#[
  SPDX-License-Identifier: NCSA OR MIT OR LGPL-2.1-only
]#

{.push raises: [].}

type
  Key* = distinct cint
    ##  Keyboard syms.

func `==`*(a, b: Key): bool {.borrow.}
func `<`*(a, b: Key): bool {.borrow.}

const
  # ASCII mapped keysyms.
  SDLK_UNKNOWN*       = Key 0
  SDLK_FIRST*         = Key 0
  SDLK_BACKSPACE*     = Key 8
  SDLK_TAB*           = Key 9
  SDLK_CLEAR*         = Key 12
  SDLK_RETURN*        = Key 13
  SDLK_PAUSE*         = Key 19
  SDLK_ESCAPE*        = Key 27
  SDLK_SPACE*         = Key 32
  SDLK_EXCLAIM*       = Key 33
  SDLK_QUOTEDBL*      = Key 34
  SDLK_HASH*          = Key 35
  SDLK_DOLLAR*        = Key 36
  SDLK_AMPERSAND*     = Key 38
  SDLK_QUOTE*         = Key 39
  SDLK_LEFTPAREN*     = Key 40
  SDLK_RIGHTPAREN*    = Key 41
  SDLK_ASTERISK*      = Key 42
  SDLK_PLUS*          = Key 43
  SDLK_COMMA*         = Key 44
  SDLK_MINUS*         = Key 45
  SDLK_PERIOD*        = Key 46
  SDLK_SLASH*         = Key 47
  SDLK_0*             = Key 48
  SDLK_1*             = Key 49
  SDLK_2*             = Key 50
  SDLK_3*             = Key 51
  SDLK_4*             = Key 52
  SDLK_5*             = Key 53
  SDLK_6*             = Key 54
  SDLK_7*             = Key 55
  SDLK_8*             = Key 56
  SDLK_9*             = Key 57
  SDLK_COLON*         = Key 58
  SDLK_SEMICOLON*     = Key 59
  SDLK_LESS*          = Key 60
  SDLK_EQUALS*        = Key 61
  SDLK_GREATER*       = Key 62
  SDLK_QUESTION*      = Key 63
  SDLK_AT*            = Key 64
  SDLK_LEFTBRACKET*   = Key 91
  SDLK_BACKSLASH*     = Key 92
  SDLK_RIGHTBRACKET*  = Key 93
  SDLK_CARET*         = Key 94
  SDLK_UNDERSCORE*    = Key 95
  SDLK_BACKQUOTE*     = Key 96
  SDLK_a*             = Key 97
  SDLK_b*             = Key 98
  SDLK_c*             = Key 99
  SDLK_d*             = Key 100
  SDLK_e*             = Key 101
  SDLK_f*             = Key 102
  SDLK_g*             = Key 103
  SDLK_h*             = Key 104
  SDLK_i*             = Key 105
  SDLK_j*             = Key 106
  SDLK_k*             = Key 107
  SDLK_l*             = Key 108
  SDLK_m*             = Key 109
  SDLK_n*             = Key 110
  SDLK_o*             = Key 111
  SDLK_p*             = Key 112
  SDLK_q*             = Key 113
  SDLK_r*             = Key 114
  SDLK_s*             = Key 115
  SDLK_t*             = Key 116
  SDLK_u*             = Key 117
  SDLK_v*             = Key 118
  SDLK_w*             = Key 119
  SDLK_x*             = Key 120
  SDLK_y*             = Key 121
  SDLK_z*             = Key 122
  SDLK_DELETE*        = Key 127

  # International keyboard syms.
  SDLK_WORLD_0*       = Key 160
  SDLK_WORLD_1*       = Key 161
  SDLK_WORLD_2*       = Key 162
  SDLK_WORLD_3*       = Key 163
  SDLK_WORLD_4*       = Key 164
  SDLK_WORLD_5*       = Key 165
  SDLK_WORLD_6*       = Key 166
  SDLK_WORLD_7*       = Key 167
  SDLK_WORLD_8*       = Key 168
  SDLK_WORLD_9*       = Key 169
  SDLK_WORLD_10*      = Key 170
  SDLK_WORLD_11*      = Key 171
  SDLK_WORLD_12*      = Key 172
  SDLK_WORLD_13*      = Key 173
  SDLK_WORLD_14*      = Key 174
  SDLK_WORLD_15*      = Key 175
  SDLK_WORLD_16*      = Key 176
  SDLK_WORLD_17*      = Key 177
  SDLK_WORLD_18*      = Key 178
  SDLK_WORLD_19*      = Key 179
  SDLK_WORLD_20*      = Key 180
  SDLK_WORLD_21*      = Key 181
  SDLK_WORLD_22*      = Key 182
  SDLK_WORLD_23*      = Key 183
  SDLK_WORLD_24*      = Key 184
  SDLK_WORLD_25*      = Key 185
  SDLK_WORLD_26*      = Key 186
  SDLK_WORLD_27*      = Key 187
  SDLK_WORLD_28*      = Key 188
  SDLK_WORLD_29*      = Key 189
  SDLK_WORLD_30*      = Key 190
  SDLK_WORLD_31*      = Key 191
  SDLK_WORLD_32*      = Key 192
  SDLK_WORLD_33*      = Key 193
  SDLK_WORLD_34*      = Key 194
  SDLK_WORLD_35*      = Key 195
  SDLK_WORLD_36*      = Key 196
  SDLK_WORLD_37*      = Key 197
  SDLK_WORLD_38*      = Key 198
  SDLK_WORLD_39*      = Key 199
  SDLK_WORLD_40*      = Key 200
  SDLK_WORLD_41*      = Key 201
  SDLK_WORLD_42*      = Key 202
  SDLK_WORLD_43*      = Key 203
  SDLK_WORLD_44*      = Key 204
  SDLK_WORLD_45*      = Key 205
  SDLK_WORLD_46*      = Key 206
  SDLK_WORLD_47*      = Key 207
  SDLK_WORLD_48*      = Key 208
  SDLK_WORLD_49*      = Key 209
  SDLK_WORLD_50*      = Key 210
  SDLK_WORLD_51*      = Key 211
  SDLK_WORLD_52*      = Key 212
  SDLK_WORLD_53*      = Key 213
  SDLK_WORLD_54*      = Key 214
  SDLK_WORLD_55*      = Key 215
  SDLK_WORLD_56*      = Key 216
  SDLK_WORLD_57*      = Key 217
  SDLK_WORLD_58*      = Key 218
  SDLK_WORLD_59*      = Key 219
  SDLK_WORLD_60*      = Key 220
  SDLK_WORLD_61*      = Key 221
  SDLK_WORLD_62*      = Key 222
  SDLK_WORLD_63*      = Key 223
  SDLK_WORLD_64*      = Key 224
  SDLK_WORLD_65*      = Key 225
  SDLK_WORLD_66*      = Key 226
  SDLK_WORLD_67*      = Key 227
  SDLK_WORLD_68*      = Key 228
  SDLK_WORLD_69*      = Key 229
  SDLK_WORLD_70*      = Key 230
  SDLK_WORLD_71*      = Key 231
  SDLK_WORLD_72*      = Key 232
  SDLK_WORLD_73*      = Key 233
  SDLK_WORLD_74*      = Key 234
  SDLK_WORLD_75*      = Key 235
  SDLK_WORLD_76*      = Key 236
  SDLK_WORLD_77*      = Key 237
  SDLK_WORLD_78*      = Key 238
  SDLK_WORLD_79*      = Key 239
  SDLK_WORLD_80*      = Key 240
  SDLK_WORLD_81*      = Key 241
  SDLK_WORLD_82*      = Key 242
  SDLK_WORLD_83*      = Key 243
  SDLK_WORLD_84*      = Key 244
  SDLK_WORLD_85*      = Key 245
  SDLK_WORLD_86*      = Key 246
  SDLK_WORLD_87*      = Key 247
  SDLK_WORLD_88*      = Key 248
  SDLK_WORLD_89*      = Key 249
  SDLK_WORLD_90*      = Key 250
  SDLK_WORLD_91*      = Key 251
  SDLK_WORLD_92*      = Key 252
  SDLK_WORLD_93*      = Key 253
  SDLK_WORLD_94*      = Key 254
  SDLK_WORLD_95*      = Key 255

  # Numeric keypad.
  SDLK_KP0*           = Key 256
  SDLK_KP1*           = Key 257
  SDLK_KP2*           = Key 258
  SDLK_KP3*           = Key 259
  SDLK_KP4*           = Key 260
  SDLK_KP5*           = Key 261
  SDLK_KP6*           = Key 262
  SDLK_KP7*           = Key 263
  SDLK_KP8*           = Key 264
  SDLK_KP9*           = Key 265
  SDLK_KP_PERIOD*     = Key 266
  SDLK_KP_DIVIDE*     = Key 267
  SDLK_KP_MULTIPLY*   = Key 268
  SDLK_KP_MINUS*      = Key 269
  SDLK_KP_PLUS*       = Key 270
  SDLK_KP_ENTER*      = Key 271
  SDLK_KP_EQUALS*     = Key 272

  # Arrows + Home/End pad.
  SDLK_UP*            = Key 273
  SDLK_DOWN*          = Key 274
  SDLK_RIGHT*         = Key 275
  SDLK_LEFT*          = Key 276
  SDLK_INSERT*        = Key 277
  SDLK_HOME*          = Key 278
  SDLK_END*           = Key 279
  SDLK_PAGEUP*        = Key 280
  SDLK_PAGEDOWN*      = Key 281

  # Function keys.
  SDLK_F1*            = Key 282
  SDLK_F2*            = Key 283
  SDLK_F3*            = Key 284
  SDLK_F4*            = Key 285
  SDLK_F5*            = Key 286
  SDLK_F6*            = Key 287
  SDLK_F7*            = Key 288
  SDLK_F8*            = Key 289
  SDLK_F9*            = Key 290
  SDLK_F10*           = Key 291
  SDLK_F11*           = Key 292
  SDLK_F12*           = Key 293
  SDLK_F13*           = Key 294
  SDLK_F14*           = Key 295
  SDLK_F15*           = Key 296

  # Key state modifier keys.
  SDLK_NUMLOCK*       = Key 300
  SDLK_CAPSLOCK*      = Key 301
  SDLK_SCROLLOCK*     = Key 302
  SDLK_RSHIFT*        = Key 303
  SDLK_LSHIFT*        = Key 304
  SDLK_RCTRL*         = Key 305
  SDLK_LCTRL*         = Key 306
  SDLK_RALT*          = Key 307
  SDLK_LALT*          = Key 308
  SDLK_RMETA*         = Key 309
  SDLK_LMETA*         = Key 310
  SDLK_LSUPER*        = Key 311   ##  Left "Windows" key.
  SDLK_RSUPER*        = Key 312   ##  Right "Windows" key.
  SDLK_MODE*          = Key 313   ##  "Alt Gr" key.
  SDLK_COMPOSE*       = Key 314   ##  Multi-key compose key.

  # Miscellaneous function keys.
  SDLK_HELP*          = Key 315
  SDLK_PRINT*         = Key 316
  SDLK_SYSREQ*        = Key 317
  SDLK_BREAK*         = Key 318
  SDLK_MENU*          = Key 319
  SDLK_POWER*         = Key 320   ##  Power Macintosh power key.
  SDLK_EURO*          = Key 321   ##  Some european keyboards.
  SDLK_UNDO*          = Key 322   ##  Atari keyboard has Undo.

  # Add any other keys here.
  SDLK_LAST*          = Key 323

type
  Mod* = distinct cint
    ##  Key mod.

proc `and`*(a, b: Mod): Mod {.borrow.}
proc `or`(a, b: Mod): Mod {.borrow.}

proc `==`*(a, b: Mod): bool {.borrow.}
proc `==`*(a: Mod, b: int): bool {.borrow.}

const
  KMOD_NONE*      = Mod 0x0000
  KMOD_LSHIFT*    = Mod 0x0001
  KMOD_RSHIFT*    = Mod 0x0002
  KMOD_LCTRL*     = Mod 0x0040
  KMOD_RCTRL*     = Mod 0x0080
  KMOD_LALT*      = Mod 0x0100
  KMOD_RALT*      = Mod 0x0200
  KMOD_LMETA*     = Mod 0x0400
  KMOD_RMETA*     = Mod 0x0800
  KMOD_NUM*       = Mod 0x1000
  KMOD_CAPS*      = Mod 0x2000
  KMOD_MODE*      = Mod 0x4000
  KMOD_RESERVED*  = Mod 0x8000
  KMOD_CTRL*      = KMOD_LCTRL or KMOD_RCTRL
  KMOD_SHIFT*     = KMOD_LSHIFT or KMOD_RSHIFT
  KMOD_ALT*       = KMOD_LALT or KMOD_RALT
  KMOD_META*      = KMOD_LMETA or KMOD_RMETA

# vim: set sts=2 et sw=2:
