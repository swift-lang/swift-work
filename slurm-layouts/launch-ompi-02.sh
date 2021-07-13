#!/bin/bash

mpirun -hostfile hostfile-02.txt ./task-pmix.sh | sort
