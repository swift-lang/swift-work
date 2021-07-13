#!/bin/bash

mpirun -n 4 --oversubscribe -hostfile hostfile-02.txt ./task-pmix.sh | sort
