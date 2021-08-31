
/**
   SUM ALL SWIFT
   usage: swift-t sum-all.swift data/*.txt
   This workflow reads the input files in parallel!
*/

import io;
import files;
import stats;
import sys;

int S[];

foreach i in [1:argc()]
{
  S[i] = sum_file(argp(i));
}

(int s) sum_file(string f)
{
  printf("input: '%s'", f);
  string L[] = file_lines(input(f));
  int N[];
  foreach line, i in L
  {
    N[i] = string2int(line);
  }
  s = sum_integer(N);
  printf("output: '%s' -> %i", f, s);
}

total = sum_integer(S);
printf("total: %i", total);
