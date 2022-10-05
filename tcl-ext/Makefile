
CC  = gcc
STD = -std=gnu99

# Dunedin
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
MPI = ${HOME}/Public/sfw/mac/mpich-4.0.2
MPI_INCLUDE = -I $(MPI)/include
MPI_LIB = -L $(MPI)/lib -l mpi
RPATH = -Wl,-rpath -Wl,$(TCL)/lib -Wl,-rpath -Wl,$(MPI)/lib
PIC = -fPIC
SHARED = -dynamiclib -Wl,-flat_namespace
MAC_NAME = -install_name lib/libext
SO_SUFFIX = dylib

CPPFLAGS = $(TCL_INCLUDE) $(MPI_INCLUDE)
CFLAGS = -Wall $(STD) $(PIC) -D MAC=$(MAC)
LDFLAGS = $(TCL_LIB) $(MPI_LIB) $(RPATH)

LIB_EXT = libext.$(SO_SUFFIX)

all: $(LIB_EXT)

$(LIB_EXT): ext.o
	gcc $(SHARED) -o $(@) ext.o $(LDFLAGS)

clean:
	rm -fv $(LIB_EXT) *.o
