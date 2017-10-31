
import location;
import stats;

int D[];
foreach leader in hostmapLeaders()
{
  // Initialization code can go here, we just do a trace()
  location L = rank2location(leader);
  @location=L trace(leader) => D[leader] = 0;
}

wait (sum(D))
{
  go();
}

go
{
  // Main workflow logic is here...
  trace("Actual workflow starting...");
  // ...
}
