
app task(int i)
{
  "./task-pmi.sh" i ;
}

foreach i in [0:4]
{
  task(i);
}
