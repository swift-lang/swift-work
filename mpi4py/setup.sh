
# SETUP SH

# Some exports are needed to pass to the Makefile

echo SETUP.SH START

if ! SPACK=$( which spack )
then
  echo "Not found: spack"
  return 1
fi
SPACK_HOME=$( dirname $( dirname $( readlink --canonicalize $SPACK ) ) )
. /usr/share/modules/init/bash
. $SPACK_HOME/share/spack/setup-env.sh

# spack load python@2.7.16
spack load python@3.7.3
# spack find mpi
# spack load mpi
# spack load openmpi
spack load mpich
spack load "py-mpi4py^mpich"
# spack load "stc^openmpi"
spack load stc

which mpicc python swift-t

# export HASH_MPI=openmpi-3.1.2-z6mtvidhv5je6gwxoc57fwqzoll2w5i2
# export HASH_STC=stc-0.7.4-2rigcsxs3wig3eeeia5bqrc3je5je2x6
# HASH_MPI4PY=py-mpi4py-3.0.0-mksuft7mkyn3ekitlpx6cfj4eszm6xft

HASH_PYTHON=$( dirname $( dirname $( which python ) ) )
export HASH_PYTHON

export PYTHONPATH=$PWD:$PYTHONPATH

echo SETUP.SH DONE
echo
