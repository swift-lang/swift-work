print("test_3.py ...")
import sys
from mpi4py import MPI
import ctypes

def go(comm_int):
    print("go(%i) ..." % comm_int)
    comm = MPI.COMM_WORLD
    print("size: %i" % comm.Get_size())
    comm.barrier()

    # MPICH mode:
    MPI_Comm = ctypes.c_int
    MPI_Comm.from_address(comm_int)
    newcomm = MPI.Intracomm()
    newcomm_ptr = MPI._addressof(newcomm)
    comm_val = MPI_Comm.from_address(newcomm_ptr)
    comm_val.value = comm_int
    newcomm.barrier()
    sys.stdout.flush()
