#!/bin/zsh

# WF1 AURORA
# Run wf1.swift on Aurora

THIS=${0:h:A}
source $THIS/settings-aurora.sh

export PYTHONPATH=$PWD

which swift-t

swift-t -m pbs wf1.swift ${*}
