STOP=$( date +%s.%N )
DURATION=$(( STOP - START ))
TOTAL=$(( ITRNS * BYTES ))
MBPS="infty"
if (( DURATION > 0 ))
then
  MB=$(( 1024 * 1024 ))
  MBPS=$(( TOTAL / DURATION / MB ))
fi
print  "TOTAL: $TOTAL"
printf "TIME:  %0.3f\n" $DURATION
printf "MBPS:  %0.3f\n" $MBPS
