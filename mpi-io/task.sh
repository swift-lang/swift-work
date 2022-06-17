#!/bin/sh

# Sleep a random amount of time:
sleep $(( $$ % 10 ))

echo TASK:
echo HOST: $( hostname )
ls /tmp/$USER/data
