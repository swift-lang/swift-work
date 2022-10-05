
CC  = gcc
STD = -std=gnu99

# Wozniak
CPPFLAGS = -I /usr/include/tcl8.6
SO_SUFFIX = so
TCL_INCLUDE = -I $(TCL)/include
TCL_LIB = -L $(TCL)/lib
PIC = -fPIC
SHARED = -shared

# GCE Mac
# TCL_INCLUDE = -I $(TCL)/include
# TCL_LIB = -L $(TCL)/lib
# RPATH = -Wl,-rpath -Wl,$(TCL)/lib
# PIC = -fPIC
# SHARED = -dynamiclib -Wl,-flat_namespace
# MAC_NAME = -install_name lib/lib
# SO_SUFFIX = dylib

CFLAGS = -Wall $(STD) $(PIC)

LIB_EXT = libext.$(SO_SUFFIX)

all: $(LIB_EXT)

$(LIB_EXT): ext.o
	gcc $(SHARED) -o $(@) ext.o

clean:
	rm -fv $(LIB_EXT) *.o
