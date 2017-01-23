
N = 5;

app (file d) A(int i)
{
  "./A.sh" d i ;
}

app B(int i, file d)
{
  "./B.sh" d i ;
}

foreach i in [0:N-1]
{
  file D<"D-%i"%i>;
  D = @prio=0 A(i);
  @prio=1 B(i, D);
}
