# Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
# 
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License version 2 as
#  published by the Free Software Foundation.
# 

# String equality tests 

template STREQ*(a, b: expr): expr = 
  (strcmp(a, b) == 0)

template STRNEQ*(a, b, n: expr): expr = 
  (strncmp(a, b, n) == 0)

template STRCASEQ*(a, b: expr): expr = 
  (strcasecmp(a, b) == 0)

template STRNCASEQ*(a, b, n: expr): expr = 
  (strncasecmp(a, b, n) == 0)

# Min/max 

template MIN*(a, b: expr): expr = 
  (if a < b: a else: b)

template MAX*(a, b: expr): expr = 
  (if a > b: a else: b)

const 
  UNUSED* = __attribute__((unused))

when defined(NDEBUG): 
  const 
    ASSERT_UNUSED* = UNUSED
else: 
  const 
    ASSERT_UNUSED* = true
when not defined(ARRAY_SIZE): 
  template ARRAY_SIZE*(x: expr): expr = 
    (sizeof((x) div sizeof(((x)[]))))

proc in4cpy*(dest: ptr in_addr; src: ptr in_addr) {.inline, cdecl.} = 
  dest.s_addr = src.s_addr

proc in6cpy*(dest: ptr in6_addr; src: ptr in6_addr) {.inline, cdecl.} = 
  memcpy(dest, src, sizeof(in6_addr))
