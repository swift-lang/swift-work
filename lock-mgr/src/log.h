
#pragma once

#include <stdbool.h>

#define WLM_LOG

void wlm_log_init(void);
void wlm_log_enabled(bool b);
void wlm_log_printf(const char* fmt, ...);

#ifndef WLM_LOG

// Just a bunch of noops

static inline void wlm_log_printf(const char* fmt, ...) {}

#endif
