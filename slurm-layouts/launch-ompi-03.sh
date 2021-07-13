#!/bin/bash

mpirun -n 4 -hostfile hostfile-ompi-02.txt ./task-pmix.sh
