
# Dunedin Anaconda3
PYTHON_HOME = /home/wozniak/sfw/anaconda3
PYTHON_VERSION_MAJOR = 3
PYTHON_VERSION_MINOR = 6
PYTHON_VERSION_SUFFIX = m

# End Python settings

PYTHON_VERSION = $(PYTHON_VERSION_MAJOR).$(PYTHON_VERSION_MINOR)$(PYTHON_VERSION_SUFFIX)
INCLUDES = -I $(PYTHON_HOME)/include/python$(PYTHON_VERSION)
LIBS     = -L $(PYTHON_HOME)/lib -lpython$(PYTHON_VERSION)
RPATHS   = -Wl,-rpath -Wl,$(PYTHON_HOME)/lib

DEFINES = -DPYTHON_VERSION_MAJOR=$(PYTHON_VERSION_MAJOR)

CC = mpicc
CFLAGS = -g -Wall -O0 -fPIC $(DEFINES) $(INCLUDES) -fdiagnostics-color=always

%.x: %.o
	$(CC) -o $(@) $(^) \
		$(LIBS) \
		$(RPATHS)

.PRECIOUS: %.o

clean:
	@ rm -fv *.x *.o
