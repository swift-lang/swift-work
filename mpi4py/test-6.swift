
import python;

// x1 = @par=4 python_parallel_persist("import test_6;test_6.f()",
//                                     "repr(test_6.get())");

// trace(x1);

params1 = "MY PARAMETERS";

x2 = @par=3 python_parallel_persist("import test_6;test_6.f('%s')" % params1,
                                   "repr(test_6.get())");

x3 = @par=3 python_parallel_persist("import test_6;test_6.f('HELLO')",
                                   "repr(test_6.get())");

// x4 = @par=2 python_parallel_persist("import test_6;test_6.f()",
//                                    "repr(test_6.get())");

// trace(x1,x2,x3,x4);
