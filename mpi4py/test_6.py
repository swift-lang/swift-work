
def get_task_comm():
    import os,sys
    print("msg1");sys.stdout.flush()
    from mpi4py import MPI
    print("msg2");sys.stdout.flush()
    import ctypes
    task_comm_string = os.getenv("task_comm")
    print("task_comm_string: " + task_comm_string)
    # task_comm_int = int(task_comm_string)
    # MPI_Comm = ctypes.c_int
    # MPI_Comm.from_address(task_comm_int)
    # newcomm = MPI.Intracomm()
    # newcomm_ptr = MPI._addressof(newcomm)
    # comm_val = MPI_Comm.from_address(newcomm_ptr)
    # comm_val.value = task_comm_int

    # OpenMPI mode (from Zaki)
    comm_int = int(task_comm_string)
    comm_pointer = ctypes.c_void_p
    mpi4py_comm = MPI.Intracomm()
    handle = comm_pointer.from_address(MPI._addressof(mpi4py_comm))
    handle.value = comm_int
    mpi4py_comm.barrier()

    print("msg3");sys.stdout.flush()
    # print("size="+str(mpi4py_comm.size()));sys.stdout.flush()
    # mpi4py_comm.barrier()
    print("msg4");sys.stdout.flush()
    return mpi4py_comm

def f():
    import sys
    print("f()");sys.stdout.flush()
    # from mpi4py import MPI
    print("f2()");sys.stdout.flush()
    global result
    comm = get_task_comm()
    print("comm: " + str(comm))
    comm.barrier()
    result = "XX"

def get():
    global result
    return result
