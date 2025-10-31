
import io;
import stats;
import string;
import sys;

@dispatch=WORKER
(string s) evaluate(int i, int c, int limit) "evaluate" "0.0" [
  "set <<s>> [ evaluate <<i>> <<c>> <<limit>> ]"
];

int n = string2int(argp(1));

(int r) search(int i, int c)
{
  str = evaluate(i, c, n);
  string tokens[] = split(str, ",");
  int A[];
  foreach token, index in tokens
  {
    A[index] = search(i+1, string2int(token));
  }

  r = sum_integer(A) + 1;
  // printf("i=%i c=%i r=%i", i, c, r);
}

total = search(1, 0);
printf("total: %i", total);
