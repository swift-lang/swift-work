
# SETUP SH

# Some exports are needed to pass to the Makefile

export SPACK=/usb1/spack/opt/spack/linux-ubuntu18.04-x86_64/gcc-7.3.0

export HASH_MPI=openmpi-3.1.2-z6mtvidhv5je6gwxoc57fwqzoll2w5i2
export HASH_STC=stc-0.7.4-2rigcsxs3wig3eeeia5bqrc3je5je2x6
export HASH_PYTHON=python-2.7.15-5npcxih4rwxbzkkkxmfcffm7im2t2pbr
HASH_MPI4PY=py-mpi4py-3.0.0-mksuft7mkyn3ekitlpx6cfj4eszm6xft

path_add()
{
  local H=$1
  local P=$SPACK/$H/bin
  if ! [ -d $P ]
  then
    echo "Path does not exist: $P"
    return 1
  fi
  PATH=$P:$PATH
}

for H in $HASH_PYTHON $HASH_MPI $HASH_STC
do
  path_add $H || return 1
done

which mpicc python swift-t
echo

MPI4PY=$SPACK/$HASH_MPI4PY/lib/python2.7/site-packages

if ! [ -d $MPI4PY ]
then
  echo "Bad MPI4PY: $HASH_MPI4PY"
  return 1
fi

export PYTHONPATH=$PWD:$MPI4PY
