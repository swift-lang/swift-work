
# SETUP SH

# Some exports are needed to pass to the Makefile

echo "SETUP.SH START"

if ! SPACK=$( which spack )
then
  echo "Not found: spack"
  return 1
fi
SPACK_HOME=$( dirname $( dirname $( readlink --canonicalize $SPACK ) ) )
echo SPACK_HOME=$SPACK_HOME
if [[ ${#LMOD_CMD} == "" ]]
then
  # Set up environment modules if not using Lmod:
  . /usr/share/modules/init/bash
fi
. $SPACK_HOME/share/spack/setup-env.sh

# SPACK SETTINGS START:
# Python (optional)
# spack load python@3.7.6

# SPACK MPI SETTINGS:

# MPI (optional)
# spack find mpi
# spack load mpi

# MPICH (Bebop)
# spack load mpich
# spack load "py-mpi4py^mpich"

# spack load mpich

spack load openmpi

# SPACK MPI APPS SETTINGS:

spack load "py-mpi4py^openmpi"

# spack load "stc^openmpi"
# spack load stc
# SPACK SETTINGS END:

echo "USING:"
which mpicc python swift-t

# Detect MPI mode:
if mpiexec -h | grep -q OpenRTE
then
  export MPI_MODE="OpenMPI"
elif mpiexec -h | grep -q mpich.org
then
  export MPI_MODE="MPICH"
else
  echo "Could not detect MPI mode!"]
  exit 1
fi

echo "MPI_MODE=$MPI_MODE"

# export HASH_MPI=openmpi-3.1.2-z6mtvidhv5je6gwxoc57fwqzoll2w5i2
# export HASH_STC=stc-0.7.4-2rigcsxs3wig3eeeia5bqrc3je5je2x6
# HASH_MPI4PY=py-mpi4py-3.0.0-mksuft7mkyn3ekitlpx6cfj4eszm6xft

HASH_PYTHON=$( dirname $( dirname $( which python ) ) )
export HASH_PYTHON

export PYTHONPATH=$PWD:$PYTHONPATH

echo "SETUP.SH DONE"
echo
