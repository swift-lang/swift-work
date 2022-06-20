#!/bin/bash

mpiexec -n 4 -f hosts-gce.txt hostname
