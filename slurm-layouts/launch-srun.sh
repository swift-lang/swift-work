#!/bin/bash

srun -n 4 --ntasks-per-node 3 ./task-pmi.sh
# srun -n 2 --ntasks-per-node 1 ./task.sh -n 2 --ntasks-per-node 2 ./task.sh
