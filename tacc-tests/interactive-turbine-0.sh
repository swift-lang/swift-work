#!/bin/bash

PATH=/home1/01163/wozniak/Public/sfw/stampede2/swift-t/2020-09-24/turbine/bin:$PATH

ibrun -n 2 turbine-pilot ./hi.tcl
