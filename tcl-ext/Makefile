
CC  = gcc
STD = -std=gnu99

# Wozniak
# MAC = 0
# TCL = /usr
# SO_SUFFIX = so
# TCL_INCLUDE = -I $(TCL)/include/tcl8.6
# TCL_LIB = -L $(TCL)/lib
# PIC = -fPIC
# SHARED = -shared

# GCE Mac
MAC = 1
TCL = ${HOME}/Public/sfw/mac/tcl-8.6.8
TCL_INCLUDE = -I $(TCL)/include
TCL_LIB = -L $(TCL)/lib -l tcl
RPATH = -Wl,-rpath -Wl,$(TCL)/lib
PIC = -fPIC
SHARED = -dynamiclib -Wl,-flat_namespace
MAC_NAME = -install_name lib/lib
SO_SUFFIX = dylib

CPPFLAGS = $(TCL_INCLUDE)
CFLAGS = -Wall $(STD) $(PIC) -D MAC=$(MAC)
LDFLAGS = $(TCL_LIB) $(RPATH)

LIB_EXT = libext.$(SO_SUFFIX)

all: $(LIB_EXT)

$(LIB_EXT): ext.o
	gcc $(SHARED) -o $(@) ext.o $(LDFLAGS)

clean:
	rm -fv $(LIB_EXT) *.o
