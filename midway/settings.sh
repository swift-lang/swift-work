
SWIFT=$HOME/Public/sfw/compute/gcc/swift-t/mpich-py
PATH=$SWIFT/stc/bin:$PATH

# Try to avoid user environment problems
unset LD_LIBRARY_PATH

which swift-t

# For compute jobs.  These are known to Swift/T.
export PROJECT=pi-jozik
export QUEUE=broadwl
export WALLTIME=00:05:00
