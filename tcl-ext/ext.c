
#include <stdio.h>

#include <tcl.h>

#define UNUSED __attribute__ ((__unused__))

int
f(UNUSED ClientData clientData, Tcl_Interp* interp,
  int objc, Tcl_Obj *const objv[])
{
  printf("f(): OK\n");
  fflush(stdout);
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
  Tcl_CreateObjCommand(interp, "f", f, NULL, NULL);
  return TCL_OK;
}
