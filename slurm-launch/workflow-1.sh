#!/bin/bash

THIS=$( readlink --canonicalize $( dirname $0 ) )

PATH=/home/woz/Public/sfw/bebop/compute/swift-t/2022-07-22/stc/bin:$PATH
PATH=$THIS:$PATH

swift-t -m slurm workflow-1.swift
