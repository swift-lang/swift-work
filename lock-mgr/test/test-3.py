
# TEST 3
# Just test manager/client startup/shutdown

import _wlmpy

rank = _wlmpy.wlm_mpi_init()

if rank == 0:
    _wlmpy.wlm_init(True, 0)
else:
    _wlmpy.wlm_init(False, 0)
    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
