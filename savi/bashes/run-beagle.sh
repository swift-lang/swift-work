#!/bin/sh
set -eu

THIS=$( dirname $0 )

# Ian's project:
export PROJECT=CI-CCR000040

PATH=/lustre/beagle2/wozniak/Public/sfw/swift-t/py2r/stc:$PATH

export LD_LIBRARY_PATH=
LD_LIBRARY_PATH+=/opt/gcc/4.9.2/snos/lib64:
LD_LIBRARY_PATH+=/lustre/beagle2/lpBuild/CANDLE/python/Python-2.7.12-inst/lib

export PPN=10

N=10

swift-t -m cray -n $N $THIS/workflow.swift -N=$N
