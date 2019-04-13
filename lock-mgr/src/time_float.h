
#pragma once

#include <sys/timeb.h>

static inline float
time_float(void)
{
  struct timeb tb;
  ftime(&tb);
  float result = tb.time;
  result += ((float) tb.millitm) / 1000.0;
  return result;
}
