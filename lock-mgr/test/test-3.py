
import _wlmpy

rank = _wlmpy.wlm_mpi_init()

if rank == 0:
    _wlmpy.wlm_init(True)
else:
    _wlmpy.wlm_init(False)
    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
