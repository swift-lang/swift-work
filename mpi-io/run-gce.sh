#!/bin/bash

# RUN GCE

THIS=$( realpath . )

# Rename this for compatibility with other systems (Summit):
export USR=$USER

swift-t \
  -n 4 \
  -t f:hosts-gce.txt \
  -e TURBINE_LEADER_HOOK_STARTUP="$( < ${THIS}/hook.tcl )" \
  $THIS/workflow.swift
