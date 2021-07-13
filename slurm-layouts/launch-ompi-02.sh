#!/bin/bash

mpirun -hostfile hostfile-ompi-02.txt ./task-pmix.sh | sort
