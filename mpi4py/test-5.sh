#!/bin/sh
set -eu

. ./setup.sh

swift-t -l -n 4 test-5.swift
