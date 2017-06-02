#include <assert.h>
#include <stdio.h>

#include <mpi.h>

void
f(){
  printf("f()\n");
}

int
main()
{
  MPI_Init(0,0);
  
  printf("hello\n");

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  printf("my rank: %i\n", rank);

  int data[2];

  if (rank == 0)
  {
    data[0] = 42;
    data[1] = 43;
    
    MPI_Send(&data[0], 2, MPI_INT, 1, 0, MPI_COMM_WORLD);
  // (const void *buf, int count, MPI_Datatype datatype, int dest, int tag,
  // MPI_Comm comm)
  }
  else
  {
    assert(rank == 1);
    printf("data[0]=%i\n", data[0]);
    MPI_Status status;
    MPI_Recv(&data[0], 2, MPI_INT, 0, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
    printf("data[0]=%i\n", data[0]);
    f();
  }

  MPI_Finalize();
  return 0;
}




#if 0






#endif
