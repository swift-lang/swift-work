
#pragma once

#include <sys/timeb.h>

// #include <stdio.h>

static inline double
time_double(void)
{
  struct timeb tb;
  ftime(&tb);
  double result = tb.time;
  result += ((double) tb.millitm) / 1000.0;
  return result;
}
