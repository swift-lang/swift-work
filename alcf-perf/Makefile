# Makefile for sim.c
#
# sim.c uses the heap (heap-template.h) and dynamic-array
# (dyn_array_i.h) data structures from c-utils, which is part of
# the swift-t source tree.  Point CUTILS at a built c-utils/code
# directory (it must already contain lib/libexmcutils.so) if yours
# is not at the default location below.

CUTILS ?= $(HOME)/proj/swift-t/c-utils/code

CC      = gcc
CFLAGS  = -O3 -Wall -I$(CUTILS)/src -I$(CUTILS)
LDFLAGS = -L$(CUTILS)/lib -Wl,-rpath,$(CUTILS)/lib
LDLIBS  = -lexmcutils -lm

.PHONY: all clean

all: sim

sim: sim.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS) $(LDLIBS)

clean:
	rm -f sim
