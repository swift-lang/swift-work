#include <mpi.h>
#include <stdio.h>

static int rank, size;

int
main(int argc, char* argv[])
{
  MPI_Init(0, 0);

  MPIX_Comm_rankpool(MPI_COMM_WORLD, NULL, 30);

  MPI_Finalize();
  return 0;
}
