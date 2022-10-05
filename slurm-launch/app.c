
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int
main(int argc, char* argv[])
{
  sleep(1);

  char name[1024];
  gethostname(name, 1024);
  printf("hostname: %s\n", name);

  // getcoreid();

  char* p = getenv("PMI_SIZE");
  if (p == NULL) p = "NULL";

  printf("PMI_SIZE: %s\n", p);

  sleep(1);

  return 0;
}
