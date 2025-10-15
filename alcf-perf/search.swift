
import sys;
import string;

@dispatch=WORKER
(string s) evaluate(int i, int c, int limit) "evaluate" "0.0" [
  "set <<s>> [ evaluate <<i>> <<c>> <<limit>> ]"
];

int n = string2int(argp(1));

search(int i, int c)
{
  str = evaluate(i, c, n);
  string tokens[] = split(str, ",");
  foreach token in tokens
  {
    search(i+1, string2int(token));
  }
}

search(1, 0);
