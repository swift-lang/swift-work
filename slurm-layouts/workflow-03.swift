
app task(int i)
{
  "./task-pmi.sh" i ;
}

// Pasted from EQ/Py
pragma worktypedef resident_work;
@dispatch=resident_work
(string output) _string_py(string code, string expr) "turbine" "0.1.0"
    [ "set <<output>> [ turbine::python 1 1 <<code>> <<expr>> ]" ];

_string_py("print('resident task:')", "repr(0)");

foreach i in [0:4]
{
  task(i);
}
