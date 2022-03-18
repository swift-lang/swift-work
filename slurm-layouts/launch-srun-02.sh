#!/bin/bash

srun -n 2 --ntasks-per-node 1 ./task-pmi.sh \
     -n 2 --ntasks-per-node 2 ./task-pmi.sh
