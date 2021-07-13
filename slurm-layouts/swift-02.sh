#!/bin/bash

export ADLB_DEBUG_HOSTMAP=1
swift-t -l \
        -n 4 \
        -t f:hostfile-swift-mpich-02.txt \
        workflow-01.swift
