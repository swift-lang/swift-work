
#include "log.h"

#include <stdarg.h>
#include <stdio.h>

#include "time_double.h"

static bool enabled = true;
static double time_start = -1;

void
wlm_log_init()
{
  time_start = time_double();
}

void
wlm_log_enabled(bool b)
{
  enabled = b;
}

void
wlm_log_printf(const char* fmt, ...)
{
  if (!enabled)
    return;

  double t = time_double() - time_start;

  int fmt_prefix_size = 1024;
  char fmt_prefix[fmt_prefix_size];
  sprintf(fmt_prefix, "wlm: %03.6f %s\n", t, fmt);

  va_list ap;
  va_start(ap, fmt);
  vprintf(fmt_prefix, ap);
  va_end(ap);
}
