
# TEST 2
# Just test client init/finalize

import _wlmpy

_wlmpy.wlm_mpi_init()
_wlmpy.wlm_init(False, 0)

_wlmpy.wlm_mpi_finalize()
