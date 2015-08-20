# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#

# For parsing/printing data
 const
   libipset = "libipset.so(.3|)"

const
  IPSET_CIDR_SEPARATOR* = "/"
  IPSET_RANGE_SEPARATOR* = "-"
  IPSET_ELEM_SEPARATOR* = ","
  IPSET_NAME_SEPARATOR* = ","
  IPSET_PROTO_SEPARATOR* = ":"
  IPSET_ESCAPE_START* = "["
  IPSET_ESCAPE_END* = "]"

type
  ipset_session* = object

  ipset_arg* = object

  ipset_parsefn* = proc (s: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
      cdecl.}

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
proc ipset_parse_name*(session: ptr ipset_session; opt: ipset_opt; str: cstring): cint {.
    cdecl, importc: "ipset_parse_name", dynlib: libipset.}
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
