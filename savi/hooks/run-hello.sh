#!/bin/sh
set -eu

# Get canonical directory containing this script
THIS=$( cd $( dirname $0 ) ; /bin/pwd )

# Define startup/shutdown hooks
export TURBINE_LEADER_HOOK_STARTUP="puts [ exec $THIS/hook-startup.sh ]"
export TURBINE_LEADER_HOOK_SHUTDOWN="puts [ exec $THIS/hook-shutdown.sh ]"

swift-t -O0 hello.swift
