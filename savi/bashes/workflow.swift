
import sys;

N = string2int(argv("N"));

app bash(string message)
{
  "bash" "-c" ("echo "+message) ;
}

foreach i in [0:N-1]
{
  bash(int2string(i));
}
