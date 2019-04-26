
CC = mpicc

CPPFLAGS = -I /usr/include/python2.7
# CPPFLAGS = -I /usr/include/python3.6m
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

# May need this for Python3
# -L /usb1/wozniak/Public/sfw/anaconda3/lib -l python3.6m
# SWIG_PY3 = -py3

src/wlm_wrap.c: src/wlm.i src/lock-mgr.h Makefile
	swig -python $(SWIG_PY3) -o $(@) $(<)
	sed -i 1i"#include <stdbool.h>" $(@)

clean:
	rm -fv src/*.o src/*_wrap.c
