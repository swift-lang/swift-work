
# SUBMIT SETTINGS SUMMIT

MED106=/gpfs/alpine/world-shared/med106
SWIFT=$MED106/wozniak/sw/gcc-6.4.0/swift-t/2020-12-16

export TURBINE_HOME=$SWIFT/turbine
PATH=$SWIFT/stc/bin:$PATH
PATH=$SWIFT/turbine/bin:$PATH

which stc turbine

SPACK=$HOME/S/proj/spack.submit
source $SPACK/share/spack/setup-env.sh
spack load py-mpi4py

export TURBINE_LAUNCHER=jsrun
