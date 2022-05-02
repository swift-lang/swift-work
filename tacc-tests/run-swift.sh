#!/bin/bash
set -eu

# RUN SWIFT

PATH=/work2/01163/wozniak/stampede2/Public/sfw/stampede2/swift-t/2022-04-25/stc/bin:$PATH

export QUEUE=development
export TURBINE_LAUNCHER=ibrun

which swift-t
swift-t -m slurm $*
