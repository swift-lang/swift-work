
#include <mpi.h>
#include "py.c"

int
main()
{
  MPI_Init(NULL, NULL);
  python_init();

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  char* result;
  python_code("import test_3");

  // This is the Python code: User can put other code in here:
  char code[1024];

  MPI_Comm comm;
  // comm = MPI_COMM_WORLD;
  MPI_Comm_dup(MPI_COMM_WORLD, &comm);
  MPI_Barrier(comm);
  if (rank == 0) printf("barrier ok\n");
  unsigned long long int comm_int;
  comm_int = (unsigned long long int) comm;
  sprintf(code, "test_3.go(%llu)", comm_int);
  if (rank == 0) { printf("%s\n", code); fflush(stdout); }

  python_code(code);

  MPI_Comm comm2;
  MPI_Comm_split(comm, rank%2, rank, &comm2);
  comm_int = (unsigned long long int) comm2;
  if (rank == 0)
    printf("C comm: %llu\n", comm_int);
  sprintf(code, "test_3.go(%llu)", comm_int);
  python_code(code);
  python_code(code);
  python_code(code);
  python_code(code);
  bool rc = python_eval("repr(42)", &result);
   // if (rank == 0) printf("rc: %i\n", rc);
  if (!rc)
  {
    printf("python_eval() failed!\n");
    return EXIT_FAILURE;
  }
  if (rank == 0) printf("result: %s\n", result);
  python_finalize();
  free(result);
  MPI_Finalize();
  return EXIT_SUCCESS;
}
