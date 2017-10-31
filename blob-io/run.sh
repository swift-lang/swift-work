#!/bin/sh
set -e

# This program is in turbine/bin
# Create f.data (contains many NULs)
turbine-write-doubles f.data 0 1 2 3

export TURBINE_LOG=1
swift-t -l -n 5 blob-io.swift
