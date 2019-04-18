
CC = mpicc

CPPFLAGS = -I /usr/include/python2.7
CFLAGS = -Wall -fPIC

WLMPY_SO = lib/_wlmpy.so

all: $(WLMPY_SO)

lib:
	mkdir -pv $(@)

HEADERS = $(wildcard src/*.h)
OBJS = src/wlm_wrap.o src/lock-mgr.o src/log.o src/profile.o
# src/lifo.o

$(OBJS): Makefile $(HEADERS)

$(WLMPY_SO): $(OBJS) lib
	$(CC) -shared -o $(@) $(OBJS)

src/wlm_wrap.c: src/wlm.i src/lock-mgr.h Makefile
	swig -python -o $(@) $(<)
	sed -i 1i"#include <stdbool.h>" $(@)

clean:
	rm -fv src/*.o src/*_wrap.c
