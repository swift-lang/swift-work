#!/bin/bash

mpirun -n 4 -hostfile hostfile-02.txt ./task-pmix.sh
