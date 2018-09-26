
#include "py.c"

int
main()
{
  python_init();
  char* result;
  python_code("from mpi4py import MPI");
  python_eval("repr(42)", &result);
  printf("result: %s\n", result);
  python_finalize();
  free(result);
  return EXIT_SUCCESS;
}
