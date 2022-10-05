
#include <stdio.h>

#include <tcl.h>

#include <mpi.h>

#define UNUSED __attribute__ ((__unused__))

int
f1(UNUSED ClientData clientData, Tcl_Interp* interp,
  int objc, Tcl_Obj *const objv[])
{
  printf("f1(): OK\n");
  fflush(stdout);
  return TCL_OK;
}

int
f2(UNUSED ClientData clientData, Tcl_Interp* interp,
  int objc, Tcl_Obj *const objv[])
{
  printf("f2(): OK\n");
  fflush(stdout);
  MPI_Init(NULL, NULL);
  MPI_Barrier(MPI_COMM_WORLD);
  MPI_Finalize();
  return TCL_OK;
}

#if MAC
#define EXT_NAME Ext_Init
#else // Linux
#define EXT_NAME _Ext_Init
#endif

int
EXT_NAME(Tcl_Interp* interp)
{
  Tcl_CreateObjCommand(interp, "f1", f1, NULL, NULL);
  Tcl_CreateObjCommand(interp, "f2", f2, NULL, NULL);
  return TCL_OK;
}
