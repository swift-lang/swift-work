#!/bin/zsh

#PBS -N MPI
#PBS -l nodes=1:ppn=12
#PBS -l walltime=00:10:00
#PBS -j oe
#PBS -o /home/wozniak/proj/swork/alcf-perf/mpi-out.txt
#PBS -V

#PBS -A workflow_scaling

#PBS -q debug

#PBS -l filesystems=home:flare

mod
module unload cray-pals
module   load cray-pals

set -x

mpiexec $HOME/mcs/ste/mpi/main.x
