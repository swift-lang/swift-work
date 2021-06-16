
import __main__

use_world = False

def get_task_comm():
    import sys
    from mpi4py import MPI
    global use_world

    if use_world:
        return MPI.COMM_WORLD

    print("msg1") ; sys.stdout.flush()

    print("msg2");sys.stdout.flush()
    import ctypes
    print("msg3");sys.stdout.flush()
    # task_comm_string = os.getenv("task_comm")
    # print("task_comm_string: " + task_comm_string)
    import turbine_helpers as TH
    print("TH.task_comm: %i" % TH.task_comm);sys.stdout.flush()

    # # MPICH mode
    comm_int = ctypes.c_int
    mpi4py_comm = MPI.Intracomm()
    # print("mpi4py_comm: ", dir(mpi4py_comm))
    mpi4py_comm_ptr = comm_int.from_address(MPI._addressof(mpi4py_comm))
    print("mpi4py_comm_ptr 1: ", mpi4py_comm_ptr)
    mpi4py_comm_ptr.value = TH.task_comm
    # handle = comm_pointer.from_address(MPI._addressof(mpi4py_comm))
    print("mpi4py_comm_ptr 2: ", mpi4py_comm_ptr)
    print("mpi4py_comm_ptr d: ", dir(mpi4py_comm_ptr))
    print("mpi4py_comm_ptr c: ", mpi4py_comm_ptr.__class__)
    # mpi4py_comm_ptr = comm_int

    # # OpenMPI mode (from Zaki)
    # comm_pointer = ctypes.c_void_p
    # print("msg8");sys.stdout.flush()
    # mpi4py_comm = MPI.Intracomm()
    # print("msg9");sys.stdout.flush()
    # handle = comm_pointer.from_address(MPI._addressof(mpi4py_comm))
    # print("msg10");sys.stdout.flush()
    # # handle.value = comm_int
    # handle.value = TH.task_comm
    # print("msg11");sys.stdout.flush()
    # mpi4py_comm.barrier()

    print("msg15");sys.stdout.flush()
    # print("size="+str(mpi4py_comm.size()));sys.stdout.flush()
    # mpi4py_comm.barrier()
    print("msg20");sys.stdout.flush()
    return mpi4py_comm

def f(msg):
    import sys
    print("f(): 1");sys.stdout.flush()
    # from mpi4py import MPI
    print("f(): 2");sys.stdout.flush()
    global result
    comm = get_task_comm()
    print("comm: " + str(comm))

    ### USER CODE GOES HERE
    size = comm.Get_size()
    rank = comm.Get_rank()
    print("f('%s'): rank: %i/%i" % (msg, rank, size))

    comm.barrier()
    result = "PYTHON_OK"
    ### END USER CODE

    # import horovod.keras as hvd
    # hvd.init(comm=comm)
    # benchmark.run(params) # params a dict of hyperparameters
    # hvd.shutdown()

def get():
    global result
    return result

# import turbine_helpers as TH
# print("TH.task_comm: %i" % TH.task_comm)

# print("myvar...")
# print("myvar: %i" % __main__.myvar)

if __name__ == "__main__":
    use_world = True
    f("MY PARAMETERS")
