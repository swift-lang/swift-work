
#pragma once

#include <mpi.h>

#include <stdbool.h>

void wlm_init(bool manager);

/**
   Only necessary if the app does not already call MPI_Init()
*/
void wlm_mpi_init(void);

/**
   Return 1 on success, else 0
 */
int wlm_acquire(int mgr_rank);

int wlm_release(int mgr_rank);

void wlm_shutdown(int mgr_rank);
