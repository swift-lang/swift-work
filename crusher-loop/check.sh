#!/bin/bash

# This should report the number of      Swift/T workers
# Note that at least 1 rank is always a Swift/T server

if (( ${#} ))
then
  FILE=$1
else
  FILE=turbine-output/output.txt
fi

# Check workflow exit code:
grep "CODE:" $FILE
grep "TIME:" $FILE

echo "Number of tasks run:"
grep "trace:" $FILE           | wc -l

echo "Number of workers reporting:"
grep "trace:" $FILE | sort -u | wc -l
