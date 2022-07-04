#!/bin/sh

# Sleep a random amount of time:
sleep $(( $$ % 10 ))

echo ADLB: SELF=$ADLB_RANK_SELF LEADER=$ADLB_RANK_LEADER $( hostname )

DATA=/tmp/$USER/data
if [ -d $DATA ]
then
  ls $DATA
else
  echo "No DATA!"
fi
