print("test_3.py ...")
import sys, traceback
print("mpi4py ...") ; sys.stdout.flush()
from mpi4py import MPI
print("mpi4py OK ...") ; sys.stdout.flush()
import ctypes

def go(comm_int):
    print("go(%i) ..." % comm_int)
    comm = MPI.COMM_WORLD
    world_size = comm.Get_size()
    world_rank = comm.Get_rank()
    print("go(): world rank: %i/%i" % (world_rank, world_size))
    sys.stdout.flush()
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

    try:
        # # OpenMPI mode (from Zaki)
        comm_pointer = ctypes.c_void_p
        newcomm = MPI.Intracomm()
        print("go(): comm_int: ", comm_int)
        sys.stdout.flush()
        newcomm_ptr = MPI._addressof(newcomm)
        handle = comm_pointer.from_address(newcomm_ptr)
        handle.value = comm_int

        # USER CODE:
        new_size = newcomm.Get_size()
        new_rank = newcomm.Get_rank()
        if new_rank == 1:
            print("go(): new rank: %i/%i" % (new_rank, new_size))
        newcomm.barrier()
        if new_rank == 1:
            print("go(): barrier ok")
        sys.stdout.flush()
    except Exception as e:
        info = sys.exc_info()
        s = traceback.format_tb(info[2])
        print(str(e) + ' ... \\n' + ''.join(s))
        sys.stdout.flush()
