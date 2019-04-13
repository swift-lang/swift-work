
#include "profile.h"

#ifdef WLM_PROFILE

#include <assert.h>
#include <inttypes.h>
#include <stdio.h>

#include "time_float.h"

static bool enabled = true;

static bool locked = false;
static float start = -1;
static float last_event = -1;
static float time_unlocked = 0;
static float time_locked = 0;
static uint64_t locks = 0;

static inline void
event(void)
{
  last_event = time_float();
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
  time_unlocked += time_float() - last_event;
  event();
  locks++;
}

void
wlm_profile_lock_release()
{
  time_locked += time_float() - last_event;
  event();
}

void
wlm_profile_done()
{
  assert(!locked);
  float now = time_float();
  time_unlocked += now - last_event;
  float time_total = now - last_event;
  float fraction = 100.0 * time_locked/time_unlocked;
  float locks_s = ((float) locks) / time_total;
  printf("wlm: time    total: %2.4f\n",    time_total);
  printf("wlm: time unlocked: %0.4f\n",    time_unlocked);
  printf("wlm: time   locked: %0.4f\n",    time_locked);
  printf("wlm: busy fraction: %2.4f %%\n", fraction);
  printf("wlm:         locks: %li\n",      locks);
  printf("wlm:       locks/s: %4.2f\n",    locks_s);
}

#endif
