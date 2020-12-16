#!/bin/bash
set -eu

# SUMMIT RUN BATCH SWIFT

THIS=$(    readlink --canonicalize $( dirname $0 ) )
PROJECT=$( readlink --canonicalize $THIS/../.. )

source $THIS/settings.sh
export PYTHONPATH=$PROJECT:${PYTHONPATH:-}

swift-t ${*}
