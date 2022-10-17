
CC  = mpicc
STD = -std=gnu99

# Wozniak/Shade:
SWIFT = ${HOME}/proj/swift-t

# Dunedin
# MAC = 0
# TCL = /usr
# SO_SUFFIX = so
# TCL_INCLUDE = -I $(TCL)/include/tcl8.6
# TCL_LIB = -L $(TCL)/lib
# SHARED = -shared

# GCE Mac
MAC = 1
TCL = ${HOME}/Public/sfw/mac/tcl-8.6.8
TCL_INCLUDE = -I $(TCL)/include
TCL_LIB = -L $(TCL)/lib -l tcl
MPI = ${HOME}/Public/sfw/mac/mpich-4.0.2
MPI_INCLUDE = -I $(MPI)/include
MPI_LIB = -L $(MPI)/lib -l mpi
SHARED = -dynamiclib -Wl,-flat_namespace
MAC_NAME = -install_name lib/libext
SO_SUFFIX = dylib

CUTILS = $(SWIFT)/c-utils/code
ADLB   = $(SWIFT)/lb/code

CUTILS_INCLUDE = -I $(CUTILS)/src
ADLB_INCLUDE = -I $(ADLB)/src
ADLB_LIB = -L $(ADLB)/lib -l adlb

CPPFLAGS = $(TCL_INCLUDE) $(MPI_INCLUDE) $(ADLB_INCLUDE) $(CUTILS_INCLUDE)
PIC = -fPIC
CFLAGS = -Wall $(STD) $(PIC) -D MAC=$(MAC)
RPATH = -Wl,-rpath -Wl,$(TCL)/lib  \
        -Wl,-rpath -Wl,$(MPI)/lib  \
        -Wl,-rpath -Wl,$(ADLB)/lib
LDFLAGS = $(TCL_LIB) $(MPI_LIB) $(ADLB_LIB) $(RPATH)

LIB_EXT = libext.$(SO_SUFFIX)

all: $(LIB_EXT)

ext.o: Makefile

$(LIB_EXT): ext.o Makefile
	$(CC) $(SHARED) -o $(@) ext.o $(LDFLAGS)

clean:
	rm -fv $(LIB_EXT) *.o
