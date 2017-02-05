#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sharedmem.h"
#include "elf.h"

//Creates a shared memory block.
int
sys_shm_create(void)
{
  int k = shm_create();
  return k;
}

//Obtains the address of the memory block associated with key.
int
sys_shm_get(void)
{
  cprintf("sys_shm_get= %x \n",mem)
  int k;
  int mem = 0;  
  if (proc->shmemquantity >= MAXSHMPROC)
    return -1;
  if(argint(0, &k) < 0)
    return -1;
  argint(1,&mem); 
  if (!shm_get(k,&mem)){ 
    return 0;
  }
  return -1;
}

//Frees the memory block previously obtained.
int
sys_shm_close(void)
{
  int k;
  if(argint(0, &k) < 0)
    return -1;
  if (!shm_close(k)){    
    return 0;
  }
  return -1;
}