#!/bin/bash

mpirun -n 4 --oversubscribe -hostfile hostfile-ompi-02.txt ./task-pmix.sh | sort
