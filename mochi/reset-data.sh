#!/bin/zsh
set -eu
setopt extendedglob

# RESET DATA
# Remove all workflow outputs, keeping the seeds from create-inputs.sh

THIS=${0:h:A}

rm -f $THIS/data/data-*-[0-9][0-9][0-9].txt~*-000.txt
