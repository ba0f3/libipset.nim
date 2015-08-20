# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
#
const
  libipset = "libipset.so(.3|)"

proc in4cpy*(dest: ptr in_addr; src: ptr in_addr) {.inline, cdecl.} =
  dest.s_addr = src.s_addr

proc in6cpy*(dest: ptr in6_addr; src: ptr in6_addr) {.inline, cdecl.} =
  memcpy(dest, src, sizeof(in6_addr))
