#!/bin/sh
set -eu

PATH=$HOME/sfw/anaconda3/bin:$PATH

which swift-t python

export PYTHONPATH=$PWD

swift-t test-4.swift
