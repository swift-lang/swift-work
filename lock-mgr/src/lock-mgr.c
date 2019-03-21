
#include <mpi.h>

#include "lock-mgr.h"

static void manager(void);

void
wlm_init(bool manager)
{
  if (manager)
    manager();
}

static void manager_loop(int size, int* lifo);

static void
manager(void)
{
  int size;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  struct lifo* L;
  lifo_init(&L, size);
  manager_loop(lifo, size);
  free(lifo);
}

static void
manager_loop(struct lifo* L, int size)
{
  int data;
  bool locked = false;
  MPI_Status status;
  while (true)
  {
    MPI_Recv(&data, 1, MPI_INT, MPI_RANK_ANY, 0, MPI_COMM_WORLD, &status);
    int sender = status.MPI_SOURCE;
    
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
