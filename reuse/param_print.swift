// printf("exectime(%i, %i, %i, %i, %i, %i, %i): %f",
//        params[0], params[1], params[2], params[3], params[4], params[5], params[6], exectime);

import sys;

string params[];
n = string2int(argv("n"));

foreach i in [0:n]
{
  params[i] = "param=" + i;
}

// (void v)
// report(string p[]) "turbine" "1.0"
// [
// """
// set s "<<p>>"
// set D [ dict create {*}$s ]
// puts [ dict values $D ]
// """
// ];

app report(string params[])
{
 "echo" params ;
}

report(params);
