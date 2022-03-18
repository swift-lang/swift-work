
import files;
import io;

app (void v) processdata(file f)
{
  "./processdata.sh" f ;
}

for (boolean b = true; b; b=c)
{
  boolean c;
  // You can change the number of data files while the workflow is running
  file data[] = glob("*.data");
  void V[];
  foreach f, i in data
  {
    V[i] = processdata(f);
  }
  printf("processed %i files.", size(V)) => c = true;
}
