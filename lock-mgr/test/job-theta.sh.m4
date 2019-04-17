#!/bin/bash -l
ifelse(getenv_nospace(PROJECT), `',,#COBALT -A getenv_nospace(PROJECT)
)ifelse(getenv_nospace(QUEUE), `',,#COBALT -q getenv(QUEUE)
)#COBALT -n getenv(NODES)
#COBALT -t getenv(WALLTIME)
#COBALT --cwd getenv(PWD)
# These COBALT directives have to stay right at the top of the file!
# No blank lines are allowed, making this look cluttered.

# JOB THETA SH
# User must set PROCS and NODES

# Created: esyscmd(`date')

source /opt/modules/default/init/bash
module load modules
PATH=/opt/cray/elogin/eproxy/2.0.14-4.3/bin:$PATH # For aprun
module swap PrgEnv-intel/6.0.4 PrgEnv-gnu
module load alps

set -eu

# Get the time zone: for time stamps on log messages
export TZ=getenv(TZ)

PROCS=getenv(PROCS)
COMMAND="getenv(COMMAND)"

set -x
aprun -n ${PROCS} ${COMMAND}
CODE=${?}
set +x

echo
echo "CODE: ${CODE}"
echo "COMPLETE: $(date)"

exit ${CODE}

# Local Variables:
# mode: m4
# End:
