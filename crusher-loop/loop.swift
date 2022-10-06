
import python;
import sys;

// Get count off the command line as int:
count = string2int(argv("count", "0"));

// Run each task:
foreach i in [0:count-1]
{
  s = python_persist("""
import os, socket, time
time.sleep(1)
""",
"'%-11s %5s' % (socket.gethostname(), os.environ['ADLB_RANK_SELF'])");
  trace(s);
}
