#!/bin/bash

mpiexec -n 4 -f hostfile-mpich-02.txt ./task-pmi.sh
