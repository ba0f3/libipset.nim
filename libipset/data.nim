# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#

# Data options
 const
   libipset = "libipset.so(.3|)"

type
  ipset_opt* {.size: sizeof(cint).} = enum
    IPSET_OPT_NONE = 0,       # Common ones
    IPSET_SETNAME, IPSET_OPT_TYPENAME, IPSET_OPT_FAMILY, # CADT options
    IPSET_OPT_IP, IPSET_OPT_IP_TO, IPSET_OPT_CIDR, IPSET_OPT_MARK,
    IPSET_OPT_PORT, IPSET_OPT_PORT_TO, IPSET_OPT_TIMEOUT, # Create-specific options
    IPSET_OPT_GC, IPSET_OPT_HASHSIZE, IPSET_OPT_MAXELEM, IPSET_OPT_MARKMASK,
    IPSET_OPT_NETMASK, IPSET_OPT_PROBES, IPSET_OPT_RESIZE, IPSET_OPT_SIZE, IPSET_OPT_FORCEADD, #
                                                                                               # Create-specific
                                                                                               # options,
                                                                                               # filled
                                                                                               # out
                                                                                               # by
                                                                                               # the
                                                                                               # kernel
    IPSET_OPT_ELEMENTS, IPSET_OPT_REFERENCES, IPSET_OPT_MEMSIZE, # ADT-specific options
    IPSET_OPT_ETHER, IPSET_OPT_NAME, IPSET_OPT_NAMEREF, IPSET_OPT_IP2,
    IPSET_OPT_CIDR2, IPSET_OPT_IP2_TO, IPSET_OPT_PROTO, IPSET_OPT_IFACE, #
                                                                         # Swap/rename to
    IPSET_OPT_SETNAME2,       # Flags
    IPSET_OPT_EXIST, IPSET_OPT_BEFORE, IPSET_OPT_PHYSDEV, IPSET_OPT_NOMATCH,
    IPSET_OPT_COUNTERS, IPSET_OPT_PACKETS, IPSET_OPT_BYTES,
    IPSET_OPT_CREATE_COMMENT, IPSET_OPT_ADT_COMMENT, IPSET_OPT_SKBINFO,
    IPSET_OPT_SKBMARK, IPSET_OPT_SKBPRIO, IPSET_OPT_SKBQUEUE, # Internal options
    IPSET_OPT_FLAGS = 48,     # IPSET_FLAG_EXIST|
    IPSET_OPT_CADT_FLAGS,     # IPSET_FLAG_BEFORE|
    IPSET_OPT_ELEM, IPSET_OPT_TYPE, IPSET_OPT_LINENO, IPSET_OPT_REVISION,
    IPSET_OPT_REVISION_MIN, IPSET_OPT_MAX

const
  IPSET_OPT_IP_FROM = IPSET_OPT_IP
  IPSET_OPT_PORT_FROM = IPSET_OPT_PORT

template IPSET_FLAG*(opt: expr): expr =
  (1 shl (opt))

const
  IPSET_FLAGS_ALL* = (not 0)
  IPSET_CREATE_FLAGS* = (IPSET_FLAG(IPSET_OPT_FAMILY) or
      IPSET_FLAG(IPSET_OPT_TYPENAME) or IPSET_FLAG(IPSET_OPT_TYPE) or
      IPSET_FLAG(IPSET_OPT_IP) or IPSET_FLAG(IPSET_OPT_IP_TO) or
      IPSET_FLAG(IPSET_OPT_CIDR) or IPSET_FLAG(IPSET_OPT_PORT) or
      IPSET_FLAG(IPSET_OPT_PORT_TO) or IPSET_FLAG(IPSET_OPT_TIMEOUT) or
      IPSET_FLAG(IPSET_OPT_GC) or IPSET_FLAG(IPSET_OPT_HASHSIZE) or
      IPSET_FLAG(IPSET_OPT_MAXELEM) or IPSET_FLAG(IPSET_OPT_MARKMASK) or
      IPSET_FLAG(IPSET_OPT_NETMASK) or IPSET_FLAG(IPSET_OPT_PROBES) or
      IPSET_FLAG(IPSET_OPT_RESIZE) or IPSET_FLAG(IPSET_OPT_SIZE) or
      IPSET_FLAG(IPSET_OPT_COUNTERS) or IPSET_FLAG(IPSET_OPT_CREATE_COMMENT) or
      IPSET_FLAG(IPSET_OPT_FORCEADD) or IPSET_FLAG(IPSET_OPT_SKBINFO))
  IPSET_ADT_FLAGS* = (IPSET_FLAG(IPSET_OPT_IP) or IPSET_FLAG(IPSET_OPT_IP_TO) or
      IPSET_FLAG(IPSET_OPT_CIDR) or IPSET_FLAG(IPSET_OPT_MARK) or
      IPSET_FLAG(IPSET_OPT_PORT) or IPSET_FLAG(IPSET_OPT_PORT_TO) or
      IPSET_FLAG(IPSET_OPT_TIMEOUT) or IPSET_FLAG(IPSET_OPT_ETHER) or
      IPSET_FLAG(IPSET_OPT_NAME) or IPSET_FLAG(IPSET_OPT_NAMEREF) or
      IPSET_FLAG(IPSET_OPT_IP2) or IPSET_FLAG(IPSET_OPT_CIDR2) or
      IPSET_FLAG(IPSET_OPT_PROTO) or IPSET_FLAG(IPSET_OPT_IFACE) or
      IPSET_FLAG(IPSET_OPT_CADT_FLAGS) or IPSET_FLAG(IPSET_OPT_BEFORE) or
      IPSET_FLAG(IPSET_OPT_PHYSDEV) or IPSET_FLAG(IPSET_OPT_NOMATCH) or
      IPSET_FLAG(IPSET_OPT_PACKETS) or IPSET_FLAG(IPSET_OPT_BYTES) or
      IPSET_FLAG(IPSET_OPT_ADT_COMMENT) or IPSET_FLAG(IPSET_OPT_SKBMARK) or
      IPSET_FLAG(IPSET_OPT_SKBPRIO) or IPSET_FLAG(IPSET_OPT_SKBQUEUE))

type
  ipset_data* = object


proc ipset_strlcpy*(dst: cstring; src: cstring; len: csize) {.cdecl,
    importc: "ipset_strlcpy", dynlib: libipsetlibipset.}
proc ipset_strlcat*(dst: cstring; src: cstring; len: csize) {.cdecl,
    importc: "ipset_strlcat", dynlib: libipset.}
proc ipset_data_flags_test*(data: ptr ipset_data; flags: uint64_t): bool {.
    cdecl, importc: "ipset_data_flags_test", dynlib: libipset.}
proc ipset_data_flags_set*(data: ptr ipset_data; flags: uint64_t) {.cdecl,
    importc: "ipset_data_flags_set", dynlib: libipset.}
proc ipset_data_flags_unset*(data: ptr ipset_data; flags: uint64_t) {.cdecl,
    importc: "ipset_data_flags_unset", dynlib: libipset.}
proc ipset_data_ignored*(data: ptr ipset_data; opt: ipset_opt): bool {.cdecl,
    importc: "ipset_data_ignored", dynlib: libipset.}
proc ipset_data_test_ignored*(data: ptr ipset_data; opt: ipset_opt): bool {.
    cdecl, importc: "ipset_data_test_ignored", dynlib: libipset.}
proc ipset_data_set*(data: ptr ipset_data; opt: ipset_opt; value: pointer): cint {.
    cdecl, importc: "ipset_data_set", dynlib: libipset.}
proc ipset_data_get*(data: ptr ipset_data; opt: ipset_opt): pointer {.cdecl,
    importc: "ipset_data_get", dynlib: libipset.}
proc ipset_data_test*(data: ptr ipset_data; opt: ipset_opt): bool {.inline,
    cdecl.} =
  return ipset_data_flags_test(data, IPSET_FLAG(opt))

# Shortcuts

proc ipset_data_setname*(data: ptr ipset_data): cstring {.cdecl,
    importc: "ipset_data_setname", dynlib: libipset.}
proc ipset_data_family*(data: ptr ipset_data): uint8_t {.cdecl,
    importc: "ipset_data_family", dynlib: libipset.}
proc ipset_data_cidr*(data: ptr ipset_data): uint8_t {.cdecl,
    importc: "ipset_data_cidr", dynlib: libipset.}
proc ipset_data_flags*(data: ptr ipset_data): uint64_t {.cdecl,
    importc: "ipset_data_flags", dynlib: libipset.}
proc ipset_data_reset*(data: ptr ipset_data) {.cdecl,
    importc: "ipset_data_reset", dynlib: libipset.}
proc ipset_data_init*(): ptr ipset_data {.cdecl, importc: "ipset_data_init",
    dynlib: libipset.}
proc ipset_data_fini*(data: ptr ipset_data) {.cdecl, importc: "ipset_data_fini",
    dynlib: libipset.}
proc ipset_data_sizeof*(opt: ipset_opt; family: uint8_t): csize {.cdecl,
    importc: "ipset_data_sizeof", dynlib: libipset.}
