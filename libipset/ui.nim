# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#
const
  libipset = "libipset.so(.3|)"


const
  IPSET_CMD_ALIASES* = 3

# Commands in userspace

type
  ipset_commands* = object
    cmd*: ipset_cmd
    has_arg*: cint
    name*: array[IPSET_CMD_ALIASES, cstring]
    help*: cstring


var ipset_commands* {.importc: "ipset_commands", dynlib: libipset.}: ptr ipset_commands

type
  ipset_session* = object

  ipset_data* = object


# Environment options

type
  ipset_envopts* = object
    flag*: cint
    has_arg*: cint
    name*: array[2, cstring]
    help*: cstring
    parse*: proc (s: ptr ipset_session; flag: cint; str: cstring): cint {.cdecl.}
    print*: proc (buf: cstring; len: cuint; data: ptr ipset_data; flag: cint;
                  env: uint8_t): cint {.cdecl.}


var ipset_envopts* {.importc: "ipset_envopts", dynlib: libipset.}: ptr ipset_envopts

proc ipset_match_cmd*(arg: cstring; name: ptr cstring): bool {.cdecl,
    importc: "ipset_match_cmd", dynlib: libipset.}
proc ipset_match_option*(arg: cstring; name: ptr cstring): bool {.cdecl,
    importc: "ipset_match_option", dynlib: libipset.}
proc ipset_match_envopt*(arg: cstring; name: ptr cstring): bool {.cdecl,
    importc: "ipset_match_envopt", dynlib: libipset.}
proc ipset_shift_argv*(argc: ptr cint; argv: ptr cstring; `from`: cint) {.cdecl,
    importc: "ipset_shift_argv", dynlib: libipset.}
proc ipset_port_usage*() {.cdecl, importc: "ipset_port_usage", dynlib: libipset.}
proc ipset_parse_file*(s: ptr ipset_session; opt: cint; str: cstring): cint {.
    cdecl, importc: "ipset_parse_file", dynlib: libipset.}
