
/*
  WORKFLOW SWIFT
*/

import io;
import sys;

int n = string2int(argv("n"));
printf("TASKS: %i", n);

app do_sleep(int i)
{
  ( getenv("THIS") / "sleep.sh" ) i ;
}

foreach i in [0:n-1]
{
  do_sleep(10);
}
