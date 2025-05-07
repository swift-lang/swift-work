
import sys
import mpi4py
import turbine_helpers as TH

# We need to flush in Swift/T
def msg(s):
    print(s)
    sys.stdout.flush()

def f():
    msg("f(): HELLO")
    msg("TH: " + str(TH))
    comm = TH.get_task_comm()
    msg("comm: " + str(comm))
    rank = comm.Get_rank()
    size = comm.Get_size()
    msg("f(): rank: %i/%i" % (rank, size))
    return "HELLO"
