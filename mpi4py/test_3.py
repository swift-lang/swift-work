print("test_3.py ...")
import sys
print("mpi4py ...") ; sys.stdout.flush()
from mpi4py import MPI
print("mpi4py OK ...") ; sys.stdout.flush()
import ctypes

def go(comm_int):
    print("go(%i) ..." % comm_int)
    comm = MPI.COMM_WORLD
    print("size: %i" % comm.Get_size())
    comm.barrier()

    # # MPICH mode:
    # MPI_Comm = ctypes.c_int
    # # MPI_Comm.from_address(comm_int)
    # newcomm = MPI.Intracomm()
    # newcomm_ptr = MPI._addressof(newcomm)
    # print("go(): newcomm_ptr: ", newcomm_ptr)
    # sys.stdout.flush()
    # newcomm_val = MPI_Comm.from_address(newcomm_ptr)
    # newcomm_val.value = comm_int
    # newcomm.barrier()
    # print("go(): barrier ok")
    # sys.stdout.flush()

    # # OpenMPI mode (from Zaki)
    comm_pointer = ctypes.c_void_p
    mpi4py_comm = MPI.Intracomm()
    print("go(): comm_int: ", comm_int)
    handle = comm_pointer.from_address(MPI._addressof(mpi4py_comm))
    handle.value = comm_int
    mpi4py_comm.barrier()
    print("go(): barrier ok")
