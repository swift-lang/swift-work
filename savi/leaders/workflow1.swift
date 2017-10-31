
import location;

foreach leader in hostmapLeaders()
{
  location L = rank2location(leader);
  @location=L trace(leader);
}
