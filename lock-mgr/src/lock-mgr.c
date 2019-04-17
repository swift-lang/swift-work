
#include <assert.h>
#include <stdio.h>

#include <mpi.h>

#include "lock-mgr.h"
#include "log.h"
#include "profile.h"

static int world_size = -1;
static int extra_ranks = -1;

static void run_manager(void);

/**
   @param extras: Number of ranks that do not participate in WLMPY,
                               E.g., Swift/T servers
*/
void
wlm_init(bool manager, int extra_ranks_in)
{
  extra_ranks = extra_ranks_in;
  wlm_log_init();
  if (manager)
    wlm_log_printf("starting manager");
  else
    wlm_log_printf("starting client");
  if (manager)
    run_manager();
}

int
wlm_mpi_init()
{
  MPI_Init(0, 0);
  int rank, size;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  printf("rank: %i/%i\n", rank, size);
  return rank;
}

static void manager_loop(void);

static void
run_manager(void)
{
  wlm_profile_init(true);
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
  manager_loop();
  wlm_profile_done();
}

enum wlm_messages
{
  WLM_ACQUIRE = 10,
  WLM_RELEASE,
  WLM_OK,
  WLM_SHUTDOWN
};

static void
manager_loop()
{
  int data;
  int shutdowns = 0;
  MPI_Status status;
  while (true)
  {
    MPI_Recv(&data, 1, MPI_INT, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD,
    			&status);
    int sender = status.MPI_SOURCE;
    // printf("recvd: %i from %i\n", data, sender);
    if (data == WLM_SHUTDOWN)
    {
      wlm_log_printf("received shutdown from rank: %i", sender);
      shutdowns++;
      if (shutdowns == world_size - extra_ranks - 1)
        break;
      continue;
    }
    assert(data == WLM_ACQUIRE);
    data = WLM_OK;
    MPI_Send(&data, 1, MPI_INT, sender, 0, MPI_COMM_WORLD);
    wlm_profile_lock_acquire();
    MPI_Recv(&data, 1, MPI_INT, sender, 0, MPI_COMM_WORLD, &status);
    assert(data == WLM_RELEASE);
    wlm_profile_lock_release();
  }
}

/**
   Return 1 on success, else 0
 */
int
wlm_acquire(int mgr_rank)
{
  int data = WLM_ACQUIRE;
  MPI_Send(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD);
  MPI_Status status;
  MPI_Recv(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD, &status);
  return data;
}

int
wlm_release(int mgr_rank)
{
  int data = WLM_RELEASE;
  MPI_Send(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD);
  return data;
}

void
wlm_shutdown(int mgr_rank)
{
  int data = WLM_SHUTDOWN;
  MPI_Send(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD);
  wlm_log_printf("shutdown");
}

void
wlm_mpi_finalize()
{
  MPI_Finalize();
}
