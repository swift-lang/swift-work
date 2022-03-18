#!/bin/bash

set -x
srun --cpus-per-task=48 --ntasks=2 ./task-pmi.sh \
     --cpus-per-task=24 --ntasks=2 ./task-pmi.sh
