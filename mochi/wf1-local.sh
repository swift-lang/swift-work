#!/bin/zsh

# WF1 LOCAL
# Run wf1.swift on local machine

THIS=${0:h:A}

export PYTHONPATH=$PWD

which swift-t

swift-t $THIS/wf1.swift ${*}
