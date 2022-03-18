#!/bin/bash

printf "%s %-5s %s %s\n" \
       $(hostname) $$    \
       PMI:$PMIX_RANK/$PMI_SIZE \
       OMPI:${OMPI_COMM_WORLD_RANK}/$OMPI_COMM_WORLD_SIZE

printenv -0 | sort -z | tr '\0' '\n' > pe-$$.txt
