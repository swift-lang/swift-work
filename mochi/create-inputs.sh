#!/bin/zsh
set -eu

# CREATE INPUTS

if (( ${#*} != 1 )) {
  print "create-inputs.sh: Provide N!"
  return 1
}
N=$1

touch data/data-{000..$[N-1]}-000.txt
