#!/bin/bash
set -eu

# SUMMIT RUN BATCH

THIS=$(    readlink --canonicalize $( dirname $0 ) )
PROJECT=$( readlink --canonicalize $THIS/../.. )

source $THIS/settings.sh
export PYTHONPATH=$PROJECT:${PYTHONPATH:-}

jsrun -n 4 --stdio_mode prepended ${*}
