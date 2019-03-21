
CC = mpicc

CPPFLAGS = -I /usr/include/python2.7
CFLAGS = -Wall -fPIC

WLMPY_SO = lib/_wlmpy.so

all: $(WLMPY_SO)

lib:
	mkdir -pv $(@)

OBJS = src/wlm_wrap.o src/lock-mgr.o src/lifo.o

$(WLMPY_SO): $(OBJS) lib
	gcc -shared -o $(@) $(OBJS)

src/wlm_wrap.c: src/wlm.i src/lock-mgr.c
	swig -python -o $(@) $(<)

clean:
	rm -fv src/*.o src/*_wrap.c

