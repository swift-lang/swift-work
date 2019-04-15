
#include "profile.h"

#ifdef WLM_PROFILE

#include <assert.h>
#include <inttypes.h>
#include <stdio.h>

#include "time_double.h"

static bool enabled = true;

static bool locked = false;
static double start = -1;
static double last_event = -1;
static double time_unlocked = 0;
static double time_locked = 0;
static uint64_t locks = 0;

static inline void
event(void)
{
  last_event = time_double();
}

void
wlm_profile_init(bool b)
{
  enabled = b;
  event();
  start = last_event;
}

void
wlm_profile_lock_acquire()
{
  time_unlocked += time_double() - last_event;
  event();
  locks++;
}

void
wlm_profile_lock_release()
{
  time_locked += time_double() - last_event;
  event();
}

void
wlm_profile_done()
{
  assert(!locked);
  double now = time_double();
  time_unlocked += now - last_event;
  double time_total = now - start;
  double fraction = 100.0 * time_locked/time_total;
  double locks_s = ((double) locks) / time_total;
  printf("wlm: time    total: %2.4f\n",     time_total);
  printf("wlm: time unlocked: %0.3f\n",     time_unlocked);
  printf("wlm: time   locked: %0.3f\n",     time_locked);
  printf("wlm: busy fraction: %02.3f %%\n", fraction);
  printf("wlm:         locks: %li\n",       locks);
  printf("wlm:       locks/s: %4.2f\n",     locks_s);
}

#endif
