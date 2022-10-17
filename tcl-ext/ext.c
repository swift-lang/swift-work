
#include <stdio.h>

#include <tcl.h>

#include <mpi.h>

#include <adlb.h>

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

  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  MPI_Comm c;
  int types[1] = {0};
  int am_server;

  /* adlb_code ADLB_Init(int nservers, int ntypes, int type_vect[], */
  /*                   int* am_server, MPI_Comm adlb_comm, */
  /*                   MPI_Comm* worker_comm); */
  ADLB_Init(1, 1, types, &am_server, MPI_COMM_WORLD, &c);

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
