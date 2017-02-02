#include "types.h"
#include "stat.h"
#include "user.h"

int
main(void)
{
  int count, t1=0, t2=1, display=0;
  count=2;   
  while (count<1000)  
  {
      display=t1+t2;
      t1=t2;
      t2=display;
      ++count;
      printf(1, "display %d\n", display);
  }
  exit();
}