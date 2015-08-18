# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
# 

# Report and output buffer sizes 

const 
  IPSET_ERRORBUFLEN* = 1024
  IPSET_OUTBUFLEN* = 8192

type 
  ipset_session* = object 
  
  ipset_data* = object 
  
  ipset_handle* = object 
  

proc ipset_session_data*(session: ptr ipset_session): ptr ipset_data {.cdecl, 
    importc: "ipset_session_data", dynlib: libipset.}
proc ipset_session_handle*(session: ptr ipset_session): ptr ipset_handle {.
    cdecl, importc: "ipset_session_handle", dynlib: libipset.}
proc ipset_saved_type*(session: ptr ipset_session): ptr ipset_type {.cdecl, 
    importc: "ipset_saved_type", dynlib: libipset.}
proc ipset_session_lineno*(session: ptr ipset_session; lineno: uint32_t) {.
    cdecl, importc: "ipset_session_lineno", dynlib: libipset.}
type 
  ipset_err_type* {.size: sizeof(cint).} = enum 
    IPSET_ERROR, IPSET_WARNING


proc ipset_session_report*(session: ptr ipset_session; `type`: ipset_err_type; 
                           fmt: cstring): cint {.varargs, cdecl, 
    importc: "ipset_session_report", dynlib: libipset.}
proc ipset_session_report_reset*(session: ptr ipset_session) {.cdecl, 
    importc: "ipset_session_report_reset", dynlib: libipset.}
proc ipset_session_error*(session: ptr ipset_session): cstring {.cdecl, 
    importc: "ipset_session_error", dynlib: libipset.}
proc ipset_session_warning*(session: ptr ipset_session): cstring {.cdecl, 
    importc: "ipset_session_warning", dynlib: libipset.}
template ipset_session_data_set*(session, opt, value: expr): expr = 
  ipset_data_set(ipset_session_data(session), opt, value)

template ipset_session_data_get*(session, opt: expr): expr = 
  ipset_data_get(ipset_session_data(session), opt)

# Environment option flags 

type 
  ipset_envopt* {.size: sizeof(cint).} = enum 
    IPSET_ENV_BIT_SORTED = 0, IPSET_ENV_SORTED = (1 shl IPSET_ENV_BIT_SORTED), 
    IPSET_ENV_BIT_QUIET = 1, IPSET_ENV_QUIET = (1 shl IPSET_ENV_BIT_QUIET), 
    IPSET_ENV_BIT_RESOLVE = 2, 
    IPSET_ENV_RESOLVE = (1 shl IPSET_ENV_BIT_RESOLVE), IPSET_ENV_BIT_EXIST = 3, 
    IPSET_ENV_EXIST = (1 shl IPSET_ENV_BIT_EXIST), 
    IPSET_ENV_BIT_LIST_SETNAME = 4, 
    IPSET_ENV_LIST_SETNAME = (1 shl IPSET_ENV_BIT_LIST_SETNAME), 
    IPSET_ENV_BIT_LIST_HEADER = 5, 
    IPSET_ENV_LIST_HEADER = (1 shl IPSET_ENV_BIT_LIST_HEADER)


proc ipset_envopt_parse*(session: ptr ipset_session; env: cint; str: cstring): cint {.
    cdecl, importc: "ipset_envopt_parse", dynlib: libipset.}
proc ipset_envopt_test*(session: ptr ipset_session; env: ipset_envopt): bool {.
    cdecl, importc: "ipset_envopt_test", dynlib: libipset.}
type 
  ipset_output_mode* {.size: sizeof(cint).} = enum 
    IPSET_LIST_NONE, IPSET_LIST_PLAIN, IPSET_LIST_SAVE, IPSET_LIST_XML


proc ipset_session_output*(session: ptr ipset_session; mode: ipset_output_mode): cint {.
    cdecl, importc: "ipset_session_output", dynlib: libipset.}
proc ipset_commit*(session: ptr ipset_session): cint {.cdecl, 
    importc: "ipset_commit", dynlib: libipset.}
proc ipset_cmd*(session: ptr ipset_session; cmd: ipset_cmd; lineno: uint32_t): cint {.
    cdecl, importc: "ipset_cmd", dynlib: libipset.}
proc ipset_session_outfn*(session: ptr ipset_session; outfn: ipset_outfn): cint {.
    cdecl, importc: "ipset_session_outfn", dynlib: libipset.}
proc ipset_session_init*(outfn: ipset_outfn): ptr ipset_session {.cdecl, 
    importc: "ipset_session_init", dynlib: libipset.}
proc ipset_session_fini*(session: ptr ipset_session): cint {.cdecl, 
    importc: "ipset_session_fini", dynlib: libipset.}
proc ipset_debug_msg*(dir: cstring; buffer: pointer; len: cint) {.cdecl, 
    importc: "ipset_debug_msg", dynlib: libipset.}