
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
if [[ ${LMOD_CMD:-} == "" ]]
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
# spack load mpich      || exit 1
module swap intel gcc/7.1.0-4bgguyp
module list
module load jdk/8u172-b11-of5fvnd
PATH=/home/woz/Public/sfw/bebop/login/mpich-3.1.2/bin:$PATH
PATH=/home/woz/Public/sfw/bebop/login/swift-t/2021-03-18/stc/bin:$PATH
DIST=()

# MPICH (Dunedin)
# spack load mpich python py-mpi4py  || exit 1
# PATH=$HOME/sfw/swift-t-mpich/stc/bin:$PATH
# DIST=( ~/proj/spack/mpi4py-mpich/opt/spack/linux-ubuntu20.04-broadwell/gcc-9.3.0/py-mpi4py-*/lib/python3/dist-packages )

# OpenMPI (Dunedin)
# spack load openmpi python py-mpi4py  || exit 1
# PATH=$HOME/sfw/swift-t-openmpi/stc/bin:$PATH
# DIST=( ~/proj/spack/mpi4py-openmpi/opt/spack/linux-ubuntu20.04-broadwell/gcc-9.3.0/py-mpi4py-*/lib/python3/dist-packages )

spack find --loaded
echo PP: $PYTHONPATH

# PYTHONPATH=/usb3/wozniak/proj/spack/mpi4py-mpich/opt/spack/linux-ubuntu20.04-broadwell/gcc-9.3.0/py-mpi4py-3.0.3-kr3pohgnqy4a3yoi4p4ippm2b4qt4hrx/lib/python3/dist-packages:$PYTHONPATH

PYTHONPATH=$DIST:$PYTHONPATH

echo PP: $PYTHONPATH

# python3

echo "USING MPI:"
which mpicc

# Detect MPI impl:
if mpiexec -h | grep -q OpenRTE
then
  export MPI_IMPL="OpenMPI"
elif mpiexec -h | grep -q mpich.org
then
  export MPI_IMPL="MPICH"
else
  echo "Could not detect MPI impl!"]
  exit 1
fi

echo MPI_IMPL=$MPI_IMPL

# SPACK MPI APPS SETTINGS:

if [[ $MPI_IMPL == "OpenMPI" ]]
then
  spack load "py-mpi4py^openmpi"
  # spack load "stc^openmpi"
elif [[ $MPI_IMPL == "MPICH" ]]
then
  spack load "py-mpi4py^mpich"
else
  echo "Bad MPI impl!  '$MPI_IMPL'"]
  exit 1
fi

# spack load stc
# SPACK SETTINGS END:

echo "USING:"
which python swift-t

# export HASH_MPI=openmpi-3.1.2-z6mtvidhv5je6gwxoc57fwqzoll2w5i2
# export HASH_STC=stc-0.7.4-2rigcsxs3wig3eeeia5bqrc3je5je2x6
# HASH_MPI4PY=py-mpi4py-3.0.0-mksuft7mkyn3ekitlpx6cfj4eszm6xft

HASH_PYTHON=$( dirname $( dirname $( which python ) ) )
export HASH_PYTHON

export PYTHONPATH=$PWD:$PYTHONPATH

echo "SETUP.SH DONE"
echo
