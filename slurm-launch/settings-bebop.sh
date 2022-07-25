
# For Python or app workflows:
NODES=4
export PPN=2
export PROCS=$(( PPN * NODES ))
export ADLB_PAR_MOD=2

export WALLTIME=00:07:00
export QUEUE=dis
export PROJECT="CONDO"

# export TURBINE_STDOUT=out-%r.txt
# export TURBINE_OUTPUT=$PWD/X

export PYTHONHOME=/soft/anaconda3/2020.07
export PYTHONPATH=${TOY_HOME:-}

module load gcc/8.2.0-xhxgy33 \
       mvapich2/2.3-bebop-a66r4jf \
       anaconda3/2020.11 \
       intel-mkl/2020.4.304-d6zw4xa
