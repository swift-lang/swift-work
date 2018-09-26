
def get_task_comm():
    import os,sys
    print("gtc");sys.stdout.flush()
    from mpi4py import MPI
    print("gtc2");sys.stdout.flush()
    import ctypes
    task_comm_string = os.getenv("task_comm")
    task_comm_int = int(task_comm_string)
    MPI_Comm = ctypes.c_int
    MPI_Comm.from_address(task_comm_int)
    newcomm = MPI.Intracomm()
    newcomm_ptr = MPI._addressof(newcomm)
    comm_val = MPI_Comm.from_address(newcomm_ptr)
    comm_val.value = task_comm_int
    print("gtc3");sys.stdout.flush()
    newcomm.barrier()
    print("gtc4");sys.stdout.flush()
    return newcomm

def f():
    import sys
    print("f()");sys.stdout.flush()
    # from mpi4py import MPI
    print("f2()");sys.stdout.flush()
    global result
    comm = get_task_comm()
    print(str(comm))
    comm.barrier()
    result = "XX"

def get():
    global result
    return result
