#!/bin/zsh

# WF1 LOCAL
# Run wf1.swift on local machine

THIS=${0:h:A}

export PYTHONPATH=$PWD
PATH=$THIS/swift-t-install/stc/bin:$PATH

which swift-t

swift-t wf1.swift ${*}
