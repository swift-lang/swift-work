#!/bin/bash

# Bebop modules start
module unload intel
module load gcc/8.2.0-g7hppkz # for openmpi
module load openmpi/3.1.4     # for mpirun
# Bebop modules end

mpirun ./task-pmix.sh
