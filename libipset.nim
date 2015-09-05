# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#
import posix
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

type
  ipset_data* = object
  ipset_parsefn* = proc (s: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.cdecl.}
  ipset_printfn* = proc (buf: cstring; len: cuint; data: ptr ipset_data; opt: ipset_opt; env: uint8): cint {.cdecl.}
  ipset_outfn* = proc (fmt: cstring) {.cdecl, varargs.}

  ipset_session* = object

  ipset_arg* = object
    name*: array[2, cstring]  # option names
    has_arg*: cint            # mandatory/optional/no arg
    opt*: ipset_opt           # argumentum type
    parse*: ipset_parsefn     # parser function
    print*: ipset_printfn     # printing function

  ipset_elem* = object
    parse*: ipset_parsefn     # elem parser function
    print*: ipset_printfn     # elem print function
    opt*: ipset_opt           # elem option


const
  NFPROTO_IPSET_IPV46* = 255
  IPSET_DIM_UMAX* = 3
  IPSET_NO_ARG* = - 1
  IPSET_OPTIONAL_ARG* = 0
  IPSET_MANDATORY_ARG* = 1
  IPSET_MANDATORY_ARG2* = 2
  IPSET_KERNEL_MISMATCH* = - 1
  IPSET_KERNEL_CHECK_NEEDED* = 0
  IPSET_KERNEL_OK* = 1


type
  ipset_adt = enum
    IPSET_ADD,
    IPSET_DEL,
    IPSET_TEST,
    IPSET_ADT_MAX,
    IPSET_CADT_MAX

const
  IPSET_CREATE = IPSET_ADT_MAX

type
  ipset_type* = object
    name*: cstring
    revision*: uint8        # revision number
    family*: uint8          # supported family
    dimension*: uint8       # elem dimension
    kernel_check*: int8     # kernel check
    last_elem_optional*: bool # last element optional
    elem*: array[IPSET_DIM_UMAX, ipset_elem] # parse elem
    compat_parse_elem*: ipset_parsefn # compatibility parser
    args*: array[IPSET_CADT_MAX, ptr ipset_arg] # create/ADT args besides elem
    mandatory*: array[IPSET_CADT_MAX, uint64] # create/ADT mandatory flags
    full*: array[IPSET_CADT_MAX, uint64] # full args flags
    usage*: cstring           # terse usage
    usagefn*: proc () {.cdecl.} # additional usage
    description*: cstring     # short revision description
    next*: ptr ipset_type
    alias*: ptr cstring       # name alias(es)

type
  ipset_envopts* = object
    flag*: cint
    has_arg*: cint
    name*: array[2, cstring]
    help*: cstring
    parse*: proc (s: ptr ipset_session; flag: cint; str: cstring): cint {.cdecl.}
    print*: proc (buf: cstring; len: cuint; data: ptr ipset_data; flag: cint;
                  env: uint8): cint {.cdecl.}

type
  ipset_cmd_enum* {.size: sizeof(cint).} = enum
    IPSET_CMD_NONE, IPSET_CMD_PROTOCOL, # 1: Return protocol version
    IPSET_CMD_CREATE,         # 2: Create a new (empty) set
    IPSET_CMD_DESTROY,        # 3: Destroy a (empty) set
    IPSET_CMD_FLUSH,          # 4: Remove all elements from a set
    IPSET_CMD_RENAME,         # 5: Rename a set
    IPSET_CMD_SWAP,           # 6: Swap two sets
    IPSET_CMD_LIST,           # 7: List sets
    IPSET_CMD_SAVE,           # 8: Save sets
    IPSET_CMD_ADD,            # 9: Add an element to a set
    IPSET_CMD_DEL,            # 10: Delete an element from a set
    IPSET_CMD_TEST,           # 11: Test an element in a set
    IPSET_CMD_HEADER,         # 12: Get set header data only
    IPSET_CMD_TYPE,           # 13: Get set type
    IPSET_MSG_MAX,            # Netlink message commands
                              # Commands in userspace:
    IPSET_CMD_HELP,           # 15: Get help
    IPSET_CMD_VERSION,        # 16: Get program version
    IPSET_CMD_QUIT,           # 17: Quit from interactive mode
    IPSET_CMD_MAX



type
  ipset_commands* = object
    cmd*: ipset_cmd_enum
    has_arg*: cint
    name*: array[3, cstring]
    help*: cstring


const
  IPSET_OPT_IP_FROM = IPSET_OPT_IP
  IPSET_OPT_PORT_FROM = IPSET_OPT_PORT

template IPSET_FLAG*(opt: expr): expr =
  (1 shl opt.ord)

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


proc ipset_strlcpy*(dst: cstring; src: cstring; len: csize) {.cdecl,
    importc: "ipset_strlcpy", dynlib: libipset.}
proc ipset_strlcat*(dst: cstring; src: cstring; len: csize) {.cdecl,
    importc: "ipset_strlcat", dynlib: libipset.}
proc ipset_data_flags_test*(data: ptr ipset_data; flags: uint64): bool {.
    cdecl, importc: "ipset_data_flags_test", dynlib: libipset.}
proc ipset_data_flags_set*(data: ptr ipset_data; flags: uint64) {.cdecl,
    importc: "ipset_data_flags_set", dynlib: libipset.}
proc ipset_data_flags_unset*(data: ptr ipset_data; flags: uint64) {.cdecl,
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
  return ipset_data_flags_test(data, IPSET_FLAG(opt).uint64)

# Shortcuts

proc ipset_data_setname*(data: ptr ipset_data): cstring {.cdecl,
    importc: "ipset_data_setname", dynlib: libipset.}
proc ipset_data_family*(data: ptr ipset_data): uint8 {.cdecl,
    importc: "ipset_data_family", dynlib: libipset.}
proc ipset_data_cidr*(data: ptr ipset_data): uint8 {.cdecl,
    importc: "ipset_data_cidr", dynlib: libipset.}
proc ipset_data_flags*(data: ptr ipset_data): uint64 {.cdecl,
    importc: "ipset_data_flags", dynlib: libipset.}
proc ipset_data_reset*(data: ptr ipset_data) {.cdecl,
    importc: "ipset_data_reset", dynlib: libipset.}
proc ipset_data_init*(): ptr ipset_data {.cdecl, importc: "ipset_data_init",
    dynlib: libipset.}
proc ipset_data_fini*(data: ptr ipset_data) {.cdecl, importc: "ipset_data_fini",
    dynlib: libipset.}
proc ipset_data_sizeof*(opt: ipset_opt; family: uint8): csize {.cdecl,
    importc: "ipset_data_sizeof", dynlib: libipset.}

const
  IPSET_CIDR_SEPARATOR* = "/"
  IPSET_RANGE_SEPARATOR* = "-"
  IPSET_ELEM_SEPARATOR* = ","
  IPSET_NAME_SEPARATOR* = ","
  IPSET_PROTO_SEPARATOR* = ":"
  IPSET_ESCAPE_START* = "["
  IPSET_ESCAPE_END* = "]"



proc ipset_parse_ether*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_ether", dynlib: libipset.}
proc ipset_parse_port*(session: ptr ipset_session; opt: ipset_opt; str: cstring;
                       proto: cstring): cint {.cdecl,
    importc: "ipset_parse_port", dynlib: libipset.}
proc ipset_parse_mark*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_mark", dynlib: libipset.}
proc ipset_parse_tcpudp_port*(session: ptr ipset_session; opt: ipset_opt;
                              str: cstring; proto: cstring): cint {.cdecl,
    importc: "ipset_parse_tcpudp_port", dynlib: libipset.}
proc ipset_parse_tcp_port*(session: ptr ipset_session; opt: ipset_opt;
                           str: cstring): cint {.cdecl,
    importc: "ipset_parse_tcp_port", dynlib: libipset.}
proc ipset_parse_single_tcp_port*(session: ptr ipset_session; opt: ipset_opt;
                                  str: cstring): cint {.cdecl,
    importc: "ipset_parse_single_tcp_port", dynlib: libipset.}
proc ipset_parse_proto*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_proto", dynlib: libipset.}
proc ipset_parse_icmp*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_icmp", dynlib: libipset.}
proc ipset_parse_icmpv6*(session: ptr ipset_session; opt: ipset_opt;
                         str: cstring): cint {.cdecl,
    importc: "ipset_parse_icmpv6", dynlib: libipset.}
proc ipset_parse_proto_port*(session: ptr ipset_session; opt: ipset_opt;
                             str: cstring): cint {.cdecl,
    importc: "ipset_parse_proto_port", dynlib: libipset.}
proc ipset_parse_tcp_udp_port*(session: ptr ipset_session; opt: ipset_opt;
                               str: cstring): cint {.cdecl,
    importc: "ipset_parse_tcp_udp_port", dynlib: libipset.}
proc ipset_parse_family*(session: ptr ipset_session; opt: ipset_opt;
                         str: cstring): cint {.cdecl,
    importc: "ipset_parse_family", dynlib: libipset.}
proc ipset_parse_ip*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_ip", dynlib: libipset.}
proc ipset_parse_single_ip*(session: ptr ipset_session; opt: ipset_opt;
                            str: cstring): cint {.cdecl,
    importc: "ipset_parse_single_ip", dynlib: libipset.}
proc ipset_parse_net*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_net", dynlib: libipset.}
proc ipset_parse_range*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_range", dynlib: libipset.}
proc ipset_parse_netrange*(session: ptr ipset_session; opt: ipset_opt;
                           str: cstring): cint {.cdecl,
    importc: "ipset_parse_netrange", dynlib: libipset.}
proc ipset_parse_iprange*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_iprange", dynlib: libipset.}
proc ipset_parse_ipnet*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_ipnet", dynlib: libipset.}
proc ipset_parse_ip4_single6*(session: ptr ipset_session; opt: ipset_opt;
                              str: cstring): cint {.cdecl,
    importc: "ipset_parse_ip4_single6", dynlib: libipset.}
proc ipset_parse_ip4_net6*(session: ptr ipset_session; opt: ipset_opt;
                           str: cstring): cint {.cdecl,
    importc: "ipset_parse_ip4_net6", dynlib: libipset.}
#proc ipset_parse_name*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
#    cdecl, importc: "ipset_parse_name", dynlib: libipset.}
proc ipset_parse_before*(session: ptr ipset_session; opt: ipset_opt;
                         str: cstring): cint {.cdecl,
    importc: "ipset_parse_before", dynlib: libipset.}
proc ipset_parse_after*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_after", dynlib: libipset.}
proc ipset_parse_setname*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_setname", dynlib: libipset.}
proc ipset_parse_timeout*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_timeout", dynlib: libipset.}
proc ipset_parse_uint64*(session: ptr ipset_session; opt: ipset_opt;
                         str: cstring): cint {.cdecl,
    importc: "ipset_parse_uint64", dynlib: libipset.}
proc ipset_parse_uint32*(session: ptr ipset_session; opt: ipset_opt;
                         str: cstring): cint {.cdecl,
    importc: "ipset_parse_uint32", dynlib: libipset.}
proc ipset_parse_uint16*(session: ptr ipset_session; opt: ipset_opt;
                         str: cstring): cint {.cdecl,
    importc: "ipset_parse_uint16", dynlib: libipset.}
proc ipset_parse_uint8*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_uint8", dynlib: libipset.}
proc ipset_parse_netmask*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_netmask", dynlib: libipset.}
proc ipset_parse_flag*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_flag", dynlib: libipset.}
proc ipset_parse_typename*(session: ptr ipset_session; opt: ipset_opt;
                           str: cstring): cint {.cdecl,
    importc: "ipset_parse_typename", dynlib: libipset.}
proc ipset_parse_iface*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_iface", dynlib: libipset.}
proc ipset_parse_comment*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_comment", dynlib: libipset.}
proc ipset_parse_skbmark*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_skbmark", dynlib: libipset.}
proc ipset_parse_skbprio*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_skbprio", dynlib: libipset.}
proc ipset_parse_output*(session: ptr ipset_session; opt: cint; str: cstring): cint {.
    cdecl, importc: "ipset_parse_output", dynlib: libipset.}
proc ipset_parse_ignored*(session: ptr ipset_session; opt: ipset_opt;
                          str: cstring): cint {.cdecl,
    importc: "ipset_parse_ignored", dynlib: libipset.}
proc ipset_parse_elem*(session: ptr ipset_session; optional: bool; str: cstring): cint {.
    cdecl, importc: "ipset_parse_elem", dynlib: libipset.}
proc ipset_call_parser*(session: ptr ipset_session; arg: ptr ipset_arg;
                        str: cstring): cint {.cdecl,
    importc: "ipset_call_parser", dynlib: libipset.}
# Compatibility parser functions

proc ipset_parse_iptimeout*(session: ptr ipset_session; opt: ipset_opt;
                            str: cstring): cint {.cdecl,
    importc: "ipset_parse_iptimeout", dynlib: libipset.}
proc ipset_parse_name_compat*(session: ptr ipset_session; opt: ipset_opt;
                              str: cstring): cint {.cdecl,
    importc: "ipset_parse_name_compat", dynlib: libipset.}

# Report and output buffer sizes

const
  IPSET_ERRORBUFLEN* = 1024
  IPSET_OUTBUFLEN* = 8192

type
  ipset_handle* = object


proc ipset_session_data*(session: ptr ipset_session): ptr ipset_data {.cdecl,
    importc: "ipset_session_data", dynlib: libipset.}
proc ipset_session_handle*(session: ptr ipset_session): ptr ipset_handle {.
    cdecl, importc: "ipset_session_handle", dynlib: libipset.}
proc ipset_saved_type*(session: ptr ipset_session): ptr ipset_type {.cdecl,
    importc: "ipset_saved_type", dynlib: libipset.}
proc ipset_session_lineno*(session: ptr ipset_session; lineno: uint32) {.
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
    IPSET_ENV_BIT_SORTED = 0,
    IPSET_ENV_BIT_QUIET = 1,
    IPSET_ENV_BIT_RESOLVE = 2,
    IPSET_ENV_BIT_EXIST = 3,
    IPSET_ENV_BIT_LIST_SETNAME = 4,
    IPSET_ENV_BIT_LIST_HEADER = 5

const
  IPSET_ENV_SORTED* = (1 shl IPSET_ENV_BIT_SORTED.ord)
  IPSET_ENV_QUIET* = (1 shl IPSET_ENV_BIT_QUIET.ord)
  IPSET_ENV_RESOLVE* = (1 shl IPSET_ENV_BIT_RESOLVE.ord)
  IPSET_ENV_EXIST = (1 shl IPSET_ENV_BIT_EXIST.ord)
  IPSET_ENV_LIST_SETNAME = (1 shl IPSET_ENV_BIT_LIST_SETNAME.ord)
  IPSET_ENV_LIST_HEADER = (1 shl IPSET_ENV_BIT_LIST_HEADER.ord)

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
proc ipset_cmd*(session: ptr ipset_session; cmd: ipset_cmd_enum; lineno: uint32): cint {.
    cdecl, importc: "ipset_cmd", dynlib: libipset.}
proc ipset_session_outfn*(session: ptr ipset_session; outfn: ipset_outfn): cint {.
    cdecl, importc: "ipset_session_outfn", dynlib: libipset.}
proc ipset_session_init*(outfn: proc (fmt: cstring) {.cdecl, varargs.}): ptr ipset_session {.cdecl,
    importc: "ipset_session_init", dynlib: libipset.}
proc ipset_session_fini*(session: ptr ipset_session): cint {.cdecl,
    importc: "ipset_session_fini", dynlib: libipset.}

proc ipset_cache_add*(name: cstring; `type`: ptr ipset_type; family: uint8): cint {.
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

proc ipset_type_get*(session: ptr ipset_session; cmd: ipset_cmd_enum): ptr ipset_type {.
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

const
  IPSET_CMD_ALIASES* = 3


proc ipset_port_usage*() {.cdecl, importc: "ipset_port_usage", dynlib: libipset.}
