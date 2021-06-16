
/*
  TEST 8 SWIFT
*/

import io;
import python;
import string;

string xs[];

foreach pl,i in [1:10:1] {

    string foo = python_persist("res = 'hayoo!'", "res");

    printf(foo);

    xs[i] = @par=4 python_parallel_persist("import test_8;test_8.f('TEST-8')",
                                           "repr(test_8.get())");

}

string foo = join(xs);

printf(foo);
