
#include <stdio.h>

#include <mpi.h>

static int rank, size;

int
main(int argc, char* argv[])
{
  MPI_Init(0, 0);

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  printf("CHILD: %i/%i\n", rank, size);

  MPI_Finalize();
  return 0;
}
