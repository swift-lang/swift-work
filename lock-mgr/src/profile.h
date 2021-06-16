
#pragma once

#include <stdbool.h>

#define WLM_PROFILE

void wlm_profile_init(bool b);
void wlm_profile_lock_acquire(void);
void wlm_profile_lock_release(void);
void wlm_profile_done(void);

#ifndef WLM_PROFILE

// Just a bunch of noops

static inline void wlm_profile_init(bool b) {}
static inline void wlm_profile_lock_acquire() {}
static inline void wlm_profile_lock_release() {}
static inline void wlm_profile_done() {}

#endif
