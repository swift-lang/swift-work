#!/bin/sh
set -eu

PATH=$HOME/sfw/anaconda3/bin:$PATH

which swift-t python

export PYTHONPATH=$PWD

swift-t -n 4 test-6.swift
