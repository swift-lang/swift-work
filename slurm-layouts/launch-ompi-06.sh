#!/bin/bash

set -x
mpirun -n 4 \
       -rankfile rankfile-05.txt \
       -hostfile hostfile-ompi-02.txt \
       ./task-pmix.sh | sort
