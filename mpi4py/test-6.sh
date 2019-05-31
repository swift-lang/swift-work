#!/bin/bash

. ./setup.sh

set -eu

swift-t -l -n 4 test-6.swift
