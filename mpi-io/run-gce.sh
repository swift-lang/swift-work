#!/bin/bash

THIS=$( realpath . )

swift-t \
  -n 4 \
  -t f:hosts-gce.txt \
  -e TURBINE_LEADER_HOOK_STARTUP="$( < ${THIS}/hook.tcl )" \
  $THIS/workflow.swift
