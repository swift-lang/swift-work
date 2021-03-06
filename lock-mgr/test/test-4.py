
# TEST 4
# Test manager/client, multiple accesses

import random
import time
import _wlmpy

rank = _wlmpy.wlm_mpi_init()

if rank == 0:
    _wlmpy.wlm_init(True, 0)
else:
    _wlmpy.wlm_init(False, 0)

    for i in range(0,5):
        _wlmpy.wlm_acquire(0)
        # Sleep for 0-1000 milliseconds
        time.sleep(random.randint(0,1000)/1000.0)
        _wlmpy.wlm_release(0)

    _wlmpy.wlm_shutdown(0)

_wlmpy.wlm_mpi_finalize()
