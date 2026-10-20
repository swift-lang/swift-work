
# ADLB TIME AWK
# Obtain average time from data like this:

# ADLB Total Elapsed Time[49150]: 405.312
# ADLB Total Elapsed Time[49151]: 405.310
# ADLB Total Elapsed Time[49149]: 405.316
# ADLB Total Elapsed Time[49148]: 405.318

BEGIN {
  total = 0;
  count = 0;
}

$1 " " $2 " " $3 == "ADLB Total Elapsed" { total += $5 ; count++; }

END {
  if (count == 0) {
    print "adlb-time.awk: No ADLB times!";
    exit(1);
  }
  printf "ADLB Average:     %0.3f\n", total / count;
}
