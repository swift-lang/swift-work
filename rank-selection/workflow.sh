#!/bin/sh

export ADLB_DEBUG_HOSTMAP=1

which swift-t

swift-t -l -n 6 -t f:hosts.txt workflow.swift
