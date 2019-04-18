
import location;
import python;

LOCK_MGR = locationFromRank(0);

@location=LOCK_MGR
python(----
import _wlmpy
_wlmpy.wlm_init(True, 1)
----);

int A[];
foreach i in [0,9]
{
  A[i] = string2int(
python_persist(----
import _wlmpy
_wlmpy.wlm_init(False, 1)
_wlmpy.wlm_acquire(0)
_wlmpy.wlm_release(0)
----,
----
repr(0)
----));
}

wait deep(A)
{
  foreach i in [1,turbine_workers()-1]
  {
    @location=locationFromRank(i)
    python_persist(----
import _wlmpy
_wlmpy.wlm_shutdown(0)
----);
  }
}
