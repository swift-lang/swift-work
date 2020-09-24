#!/bin/bash
set -eu

# RUN SWIFT

PATH=/home1/01163/wozniak/Public/sfw/stampede2/swift-t/2020-09-24/stc/bin:$PATH

export QUEUE=development
export TURBINE_LAUNCHER=ibrun

swift-t -m slurm $*
