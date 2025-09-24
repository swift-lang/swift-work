
import string;

@dispatch=WORKER
(string s) evaluate(int i, int c) "evaluate" "0.0" [
  "set s [ evaluate <<i>> <<c>> ]"
];

search(int i, int c)
{
  str = evaluate(i, c);
  string tokens[] = split(str, ",");
  foreach token in tokens
  {
    search(i+1, string2int(token));
  }
}

search(1, 0);
