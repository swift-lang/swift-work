
# TEST 8 PY

import turbine_helpers as TH

# The user result
result = None

def f(msg):
    comm = TH.get_task_comm()

    # This is not needed for basic uses:
    # from mpi4py import MPI

    ### USER CODE GOES HERE
    size = comm.Get_size()
    rank = comm.Get_rank()
    print("f('%s'): rank: %i/%i" % (msg, rank, size))

    comm.barrier()
    global result
    result = "RESULT:PYTHON_OK"
    ### END USER CODE

def get():
    global result
    return result
