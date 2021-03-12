
import python;
import string;
import io;
import unix;

//printenv();

params1 = "MY PARAMETERS";

string xs[];

foreach pl,i in [1:10:1] {

    string foo = python_persist("res = 'hayoo!'", "res");

    printf(foo);

    xs[i] = @par=4 python_parallel_persist("import test_6;test_6.f('INTRO')",
                                   "repr(test_6.get())");

}

string foo = join(xs);

printf(foo);


