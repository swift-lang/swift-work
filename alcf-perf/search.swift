
import io;
import stats;
import string;
import sys;

/**
   IDEA
   i: basically the recursion level
   c: cursor for tasks
   m: limit for number of recursions and tasks per recursion
*/

@dispatch=WORKER
(string s) evaluate(int i, int c, int m) "evaluate" "0.0" [
  "set <<s>> [ evaluate <<i>> <<c>> <<m>> ]"
];

int m = string2int(argv("m"));

(int r) search(int i, int c)
{
  string s = evaluate(i, c, m);
  string tokens[] = split(s, ",");
  int A[];
  foreach token, index in tokens
  {
    A[index] = search(i+1, string2int(token));
  }

  r = sum_integer(A) + 1;
  printf("i=%i c=%i r=%i", i, c, r);
}

total = search(1, 0);
printf("M:     %i", m);
printf("TASKS: %i", total);
