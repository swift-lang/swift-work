
# Dunedin Anaconda3
# PYTHON_HOME = /home/wozniak/sfw/anaconda3
# PYTHON_VERSION_MAJOR = 3
# PYTHON_VERSION_MINOR = 6
# PYTHON_VERSION_SUFFIX = m

# Spack
PYTHON_HOME = ${HASH_PYTHON}
PYTHON_VERSION_MAJOR = 2
PYTHON_VERSION_MINOR = 7
PYTHON_VERSION_SUFFIX =

PYTHON_VERSION = $(PYTHON_VERSION_MAJOR).$(PYTHON_VERSION_MINOR)$(PYTHON_VERSION_SUFFIX)
INCLUDES = -I $(PYTHON_HOME)/include/python$(PYTHON_VERSION)
LIBS     = -L $(PYTHON_HOME)/lib -lpython$(PYTHON_VERSION)
RPATHS   = -Wl,-rpath -Wl,$(PYTHON_HOME)/lib

DEFINES = -DPYTHON_VERSION_MAJOR=$(PYTHON_VERSION_MAJOR)

CC = mpicc
CFLAGS = -g -Wall -O0 -fPIC $(DEFINES) $(INCLUDES) -fdiagnostics-color=always

%.o: %.c py.c

%.x: %.o
	$(CC) -o $(@) $(^) \
		$(LIBS) \
		$(RPATHS)

.PRECIOUS: %.o

clean:
	@ rm -rfv *.x *.o *.tic __pycache__
