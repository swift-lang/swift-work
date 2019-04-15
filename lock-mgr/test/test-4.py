
import random
import time
import _wlmpy

rank = _wlmpy.wlm_mpi_init()

if rank == 0:
    _wlmpy.wlm_init(True)
else:
    _wlmpy.wlm_init(False)

    for i in range(0,5):
        _wlmpy.wlm_acquire(0)
        time.sleep(random.randint(0,1000)/1000.0)
        _wlmpy.wlm_release(0)

    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
