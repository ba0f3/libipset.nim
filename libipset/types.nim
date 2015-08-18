# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
# 

# Family rules:
#  - NFPROTO_UNSPEC:		type is family-neutral
#  - NFPROTO_IPV4:		type supports IPv4 only
#  - NFPROTO_IPV6:		type supports IPv6 only
#  Special (userspace) ipset-only extra value:
#  - NFPROTO_IPSET_IPV46:	type supports both IPv4 and IPv6
# 

const 
  NFPROTO_IPSET_IPV46* = 255

# The maximal type dimension userspace supports 

const 
  IPSET_DIM_UMAX* = 3

# Parser options 

const 
  IPSET_NO_ARG* = - 1
  IPSET_OPTIONAL_ARG* = 0
  IPSET_MANDATORY_ARG* = 1
  IPSET_MANDATORY_ARG2* = 2

type 
  ipset_session* = object 
  

# Parse and print type-specific arguments 

type 
  ipset_arg* = object 
    name*: array[2, cstring]  # option names 
    has_arg*: cint            # mandatory/optional/no arg 
    opt*: ipset_opt           # argumentum type 
    parse*: ipset_parsefn     # parser function 
    print*: ipset_printfn     # printing function 
  

# Type check against the kernel 

const 
  IPSET_KERNEL_MISMATCH* = - 1
  IPSET_KERNEL_CHECK_NEEDED* = 0
  IPSET_KERNEL_OK* = 1

# How element parts are parsed 

type 
  ipset_elem* = object 
    parse*: ipset_parsefn     # elem parser function 
    print*: ipset_printfn     # elem print function 
    opt*: ipset_opt           # elem option 
  

# The set types in userspace
#  we could collapse 'args' and 'mandatory' to two-element lists
#  but for the readability the full list is supported.
#  

type 
  ipset_type* = object 
    name*: cstring
    revision*: uint8_t        # revision number 
    family*: uint8_t          # supported family 
    dimension*: uint8_t       # elem dimension 
    kernel_check*: int8_t     # kernel check 
    last_elem_optional*: bool # last element optional 
    elem*: array[IPSET_DIM_UMAX, ipset_elem] # parse elem 
    compat_parse_elem*: ipset_parsefn # compatibility parser 
    args*: array[IPSET_CADT_MAX, ptr ipset_arg] # create/ADT args besides elem 
    mandatory*: array[IPSET_CADT_MAX, uint64_t] # create/ADT mandatory flags 
    full*: array[IPSET_CADT_MAX, uint64_t] # full args flags 
    usage*: cstring           # terse usage 
    usagefn*: proc () {.cdecl.} # additional usage 
    description*: cstring     # short revision description 
    next*: ptr ipset_type
    alias*: ptr cstring       # name alias(es) 
  

proc ipset_cache_add*(name: cstring; `type`: ptr ipset_type; family: uint8_t): cint {.
    cdecl, importc: "ipset_cache_add", dynlib: libipset.}
proc ipset_cache_del*(name: cstring): cint {.cdecl, importc: "ipset_cache_del", 
    dynlib: libipset.}
proc ipset_cache_rename*(`from`: cstring; to: cstring): cint {.cdecl, 
    importc: "ipset_cache_rename", dynlib: libipset.}
proc ipset_cache_swap*(`from`: cstring; to: cstring): cint {.cdecl, 
    importc: "ipset_cache_swap", dynlib: libipset.}
proc ipset_cache_init*(): cint {.cdecl, importc: "ipset_cache_init", 
                                 dynlib: libipset.}
proc ipset_cache_fini*() {.cdecl, importc: "ipset_cache_fini", dynlib: libipset.}
proc ipset_type_get*(session: ptr ipset_session; cmd: ipset_cmd): ptr ipset_type {.
    cdecl, importc: "ipset_type_get", dynlib: libipset.}
proc ipset_type_check*(session: ptr ipset_session): ptr ipset_type {.cdecl, 
    importc: "ipset_type_check", dynlib: libipset.}
proc ipset_type_add*(`type`: ptr ipset_type): cint {.cdecl, 
    importc: "ipset_type_add", dynlib: libipset.}
proc ipset_types*(): ptr ipset_type {.cdecl, importc: "ipset_types", 
                                      dynlib: libipset.}
proc ipset_typename_resolve*(str: cstring): cstring {.cdecl, 
    importc: "ipset_typename_resolve", dynlib: libipset.}
proc ipset_match_typename*(str: cstring; t: ptr ipset_type): bool {.cdecl, 
    importc: "ipset_match_typename", dynlib: libipset.}
proc ipset_load_types*() {.cdecl, importc: "ipset_load_types", dynlib: libipset.}