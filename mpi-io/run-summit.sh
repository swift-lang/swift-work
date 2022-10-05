#!/bin/bash

# RUN SUMMIT

THIS=$( realpath . )

SWIFT=/gpfs/alpine/world-shared/med106/sw/summit/gcc-7.5.0/swift-t/2022-07-04
PATH=$SWIFT/stc/bin:$PATH
PATH=$THIS:$PATH

which swift-t

source $THIS/settings-summit-med106.sh

# NOTE: We cannot export USER due to Summit system policy
# Hook is collected into environment after using sed to
#      1) strip comments and
#      2) insert semicolons at line end.
swift-t -m lsf \
        -e TURBINE_LEADER_HOOK_STARTUP="$( sed 's/#.*//;s/$/;/' ${THIS}/hook.tcl )" \
        -e USR=$USER \
        -e EDITOR \
         $THIS/workflow.swift
