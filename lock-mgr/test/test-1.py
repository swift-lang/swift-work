
# TEST 1
# Just test basic MPI startup/shutdown

import _wlmpy

_wlmpy.wlm_mpi_init()

_wlmpy.wlm_mpi_finalize()
