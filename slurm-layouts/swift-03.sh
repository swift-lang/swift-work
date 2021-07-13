#!/bin/bash

export TURBINE_RESIDENT_WORK_WORKERS=1
export ADLB_DEBUG_HOSTMAP=1
export PYTHONUNBUFFERED=1

swift-t -l \
        -n 4 \
        -t f:hostfile-swift-mpich-02.txt \
        workflow-03.swift
