
#pragma once

#include <mpi.h>

#include <stdbool.h>

void wlm_init(bool manager, int extra_ranks_in);

/**
   Only necessary if the app does not already call MPI_Init()
*/
int wlm_mpi_init(void);

/**
   @return size(MPI_COMM_WORLD)
*/
int wlm_mpi_size(void);

/**
   @return 1 on success, else 0
 */
int wlm_acquire(int mgr_rank);

int wlm_release(int mgr_rank);

void wlm_shutdown(int mgr_rank);

/**
   Only necessary if the app does not already call MPI_Finalize()
*/
void wlm_mpi_finalize(void);
