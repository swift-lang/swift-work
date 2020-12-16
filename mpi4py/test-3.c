
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
  // comm = MPI_COMM_WORLD; // MODE 1: WORKS
  MPI_Comm_dup(MPI_COMM_WORLD, &comm); // MODE 2: WORKS NOW 2019-05-29 OpenMPI/Spack Py3
  MPI_Barrier(comm);
  if (rank == 0) printf("barrier ok\n");
  long long int i = (long long int) comm;
  sprintf(code, "test_3.go(%lli)", i);
  if (rank == 0) { printf("%s\n", code); fflush(stdout); }
  python_code(code);
  bool rc = python_eval("repr(42)", &result);
  if (rank == 0) printf("rc: %i\n", rc);
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
