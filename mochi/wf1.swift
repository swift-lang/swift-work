
import files;
import io;
import string;
import python;
import sys;

main()
{
  data = argp(1);
  pattern = data + "/data-*-000.txt";
  printf("glob: " + pattern);
  L = glob(pattern);
  printf("data count: %i", size(L));

  steps = string2int(argp(2));

  file F[][];
  foreach i1 in [0:size(L)-1]
  {
    F[i1][0] = input("data/data-%03i-000.txt" % i1);
  }

  foreach i1 in [0:size(L)-1]
  {
    foreach i2 in [0:steps-1]
    {
      output_name = "data/data-%03i-%03i.txt" % (i1, i2+1);
      file output<output_name> = transform(F[i1][i2]);
      F[i1][i2+1] = output;
    }
  }
}

(file o) transform(file i)
{
  o = emit(python_persist("import transforms",
                          "transforms.tf1('%s', '%s')" %
                          (ready(i), filename(o))));
}
