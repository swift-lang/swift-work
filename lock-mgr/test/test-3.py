
# TEST 3
# Just test manager/client startup/shutdown
# Requires at least 2 processes!

import _wlmpy

rank = _wlmpy.wlm_mpi_init()

print(_wlmpy.wlm_mpi_size())

if _wlmpy.wlm_mpi_size() < 2:
    print("This test requires >= 2 MPI ranks!")
    exit(1)

if rank == 0:
    _wlmpy.wlm_init(True, 0)
else:
    _wlmpy.wlm_init(False, 0)
    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
