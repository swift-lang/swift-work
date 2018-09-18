
import python;

x = @par=2 python_parallel_persist("import test_6;test_6.f()",
                                   "repr(test_6.get())");

trace(x);
