
# SETTINGS AURORA

SFW=/lus/flare/projects/Diaspora/sfw
SWIFT=$SFW/swift-t/2026-08-26-Mochi

PATH=$THIS:$SWIFT/stc/bin:$PATH

# Swift/T scheduler settings follow:

export PROJECT=Diaspora

# Edit this based on your workload!
# Aurora limits queue debug to 1 hour
export QUEUE=${QUEUE:-debug}
export WALLTIME=${WALLTIME:-00:05:00}
PROCS=${PROCS:-2}
export PPN=${PPN:-2}

# See https://docs.alcf.anl.gov/aurora/running-jobs-aurora/#submitting-a-job
export TURBINE_DIRECTIVE="#PBS -l filesystems=home:flare"
