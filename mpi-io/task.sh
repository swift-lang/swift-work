#!/bin/sh

# TASK SH

# Sleep a random amount of time:
sleep $(( $$ % 10 ))

# Report task identity for debugging
echo ADLB: SELF=$ADLB_RANK_SELF LEADER=$ADLB_RANK_LEADER $( hostname )

# This should be where the hook copied the data
DATA=/tmp/$USR/data

# If the DATA exists, show that we have it:
if [ -d $DATA ]
then
  find $DATA
else
  echo "No DATA!"
fi
