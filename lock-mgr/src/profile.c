
#include "profile.h"

#ifdef WLM_PROFILE

#include <assert.h>
#include <stdio.h>

#include "time_float.h"

static bool enabled = true;

static bool locked = false;
static float last_event = -1;
static float time_unlocked = 0;
static float time_locked = 0;

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
}

void
wlm_profile_lock_acquire()
{
  time_unlocked += time_float() - last_event;
  event();
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
  time_unlocked += time_float() - last_event;
  float fraction = 100.0 * time_locked/time_unlocked;
  printf("wlm: time unlocked: %0.4f\n", time_unlocked);
  printf("wlm: time   locked: %0.4f\n", time_locked);
  printf("wlm: busy fraction: %2.4f %%\n", fraction);
}

#endif
