
import blob;
import location;

blob source = blob_read(input("f.data"));

foreach i in [0:turbine_workers()-1]
{
  location L = rank2location(i);
  file sink<"f-%i.data"%i> = @location=L blob_write(source);
}
