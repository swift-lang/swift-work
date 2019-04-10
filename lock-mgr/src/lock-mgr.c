
#include <mpi.h>

#include "lock-mgr.h"

static void run_manager(void);

void
wlm_init(bool manager)
{
  if (manager)
    run_manager();
}

static void manager_loop(void);

static void
run_manager(void)
{
  int size;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  manager_loop();
}

static void
manager_loop()
{
  int data;
  MPI_Status status;
  while (true)
  {
    MPI_Recv(&data, 1, MPI_INT, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD,
    			&status);
    int sender = status.MPI_SOURCE;
    data = 1;
    MPI_Send(&data, 1, MPI_INT, sender, 0, MPI_COMM_WORLD);
    MPI_Recv(&data, 1, MPI_INT, sender, 0, MPI_COMM_WORLD,
        			&status);
  }
}

const int WLM_SHUTDOWN = 100;

/**
   Return 1 on success, else 0
 */
int
wlm_acquire(int mgr_rank)
{
  int data = 0;
  MPI_Send(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD);
  MPI_Status status;
  MPI_Recv(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD, &status);
  return data;
}

int
wlm_release(int mgr_rank)
{
  int data = 0;
  MPI_Send(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD);
  MPI_Status status;
  MPI_Recv(&data, 1, MPI_INT, mgr_rank, 0, MPI_COMM_WORLD, &status);
  return data;
}

void
wlm_shutdown(int mgr_rank)
{
  int data = WLM_SHUTDOWN;
  MPI_Send(&data, MPI_INT, 1, mgr_rank, 0, MPI_COMM_WORLD);
}
