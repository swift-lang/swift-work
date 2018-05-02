
#include <stdarg.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <mpi.h>

static int rank, size;

int
main(int argc, char* argv[])
{
  MPI_Init(0, 0);

  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  printf("MAIN: %i/%i\n", rank, size);

  int maxprocs = 1;
  int codes[maxprocs];

  MPI_Comm comm;
  MPI_Comm_spawn("./child.x", NULL, maxprocs, MPI_INFO_NULL, 0,
                 MPI_COMM_WORLD, &comm, codes);

  MPI_Finalize();
  return 0;
}
