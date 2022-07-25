
import python;

params1 = "MY PARAMETERS";

x1 = @par=6 python_parallel_persist("import test_6;test_6.f('INTRO')",
                                    "repr(test_6.get())");
trace("x1", x1);

<<<<<<< Updated upstream
x2 = @par=5 python_parallel_persist("import test_6;test_6.f('%s')" % params1,
                                    "repr(test_6.get())");
trace("x2", x2);

x3 = @par=3 python_parallel_persist("import test_6;test_6.f('HELLO')",
                                   "repr(test_6.get())");
trace("x3", x3);

=======
// x2 = @par=5 python_parallel_persist("import test_6;test_6.f('%s')" % params1,
//                                    "repr(test_6.get())");

// x3 = @par=3 python_parallel_persist("import test_6;test_6.f('HELLO')",
//                                    "repr(test_6.get())");
>>>>>>> Stashed changes

// x4 = @par=2 python_parallel_persist("import test_6;test_6.f('BYE')",
//                                    "repr(test_6.get())");

// trace(x1,x2,x3,x4);
