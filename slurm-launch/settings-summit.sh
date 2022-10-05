
# For Python or app workflows:
NODES=1
export PPN=4
export PROCS=$(( PPN * NODES ))
export ADLB_PAR_MOD=2

export WALLTIME=00:02:00
export PROJECT="MED106"

MED106=/gpfs/alpine/world-shared/med106
ROOT=$MED106/sw/summit/gcc-7.5.0
SWIFT=$ROOT/swift-t/2022-07-25/stc

PATH=$SWIFT/stc/bin:$PATH
PATH=$THIS:$PATH
