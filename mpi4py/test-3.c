
#include <mpi.h>
#include "py.c"

int
main()
{
  python_init();
  char* result;
  python_code("import test_3");
  char code[1024];
  sprintf(code, "test_3.go(%i)", MPI_COMM_WORLD);
  python_code(code);
  python_eval("repr(42)", &result);
  printf("result: %s\n", result);
  python_finalize();
  free(result);
  return EXIT_SUCCESS;
}
