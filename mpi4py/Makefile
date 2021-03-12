
# Dunedin Anaconda3
# PYTHON_HOME = /home/wozniak/sfw/anaconda3
# PYTHON_VERSION_MAJOR = 3
# PYTHON_VERSION_MINOR = 6
# PYTHON_VERSION_SUFFIX = m

# # Spack
# PYTHON_HOME = ${HASH_PYTHON}
# PYTHON_VERSION_MAJOR = 2
# PYTHON_VERSION_MINOR = 7
# PYTHON_VERSION_SUFFIX =

# # Spack
# PYTHON_HOME = ${HASH_PYTHON}
# PYTHON_VERSION_MAJOR = 3
# PYTHON_VERSION_MINOR = 8
# # PYTHON_VERSION_SUFFIX = m

# # Summit med106 opence010env
# PYTHON_HOME = /gpfs/alpine/world-shared/med106/sw2/opence010env
# PYTHON_VERSION_MAJOR = 3
# PYTHON_VERSION_MINOR = 6
# PYTHON_VERSION_SUFFIX = m

# Bebop gcc/7.1.0-4bgguyp python/3.6.2-3dp4bht
PYTHON_HOME = /blues/gpfs/home/software/spack-0.10.1/opt/spack/linux-centos7-x86_64/gcc-7.1.0/python-3.6.2-3dp4bht6wfnham4now6w2iv7t7fpdazx
PYTHON_VERSION_MAJOR = 3
PYTHON_VERSION_MINOR = 6
PYTHON_VERSION_SUFFIX = m

PYTHON_VERSION = $(PYTHON_VERSION_MAJOR).$(PYTHON_VERSION_MINOR)$(PYTHON_VERSION_SUFFIX)
INCLUDES = -I $(PYTHON_HOME)/include/python$(PYTHON_VERSION)
LIBS     = -L $(PYTHON_HOME)/lib -lpython$(PYTHON_VERSION)
RPATHS   = -Wl,-rpath -Wl,$(PYTHON_HOME)/lib

DEFINES = -DPYTHON_VERSION_MAJOR=$(PYTHON_VERSION_MAJOR)

CC = mpicc
CFLAGS = -g -Wall -Werror -O0 -fPIC $(DEFINES) $(INCLUDES) \
         -fdiagnostics-color=always

%.o: %.c py.c

%.x: %.o Makefile
	$(CC) -o $(@) $(<) \
		$(LIBS) \
		$(RPATHS)

.PRECIOUS: %.o

clean:
	@ rm -rfv *.x *.o *.tic __pycache__ */*/core.*
