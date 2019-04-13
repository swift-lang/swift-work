
import _wlmpy

rank = _wlmpy.wlm_mpi_init()

if rank == 0:
    _wlmpy.wlm_init(True)
else:
    _wlmpy.wlm_init(False)

    for i in range(0,9):
        _wlmpy.wlm_acquire(0)
        _wlmpy.wlm_release(0)

    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
