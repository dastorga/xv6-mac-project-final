#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sharedmem.h"

// "shmtable" contiene:
// struct {
//   struct sharedmemory sharedmemory[MAXSHM]; // array from type sharedmemory
//   struct spinlock lock;
//   unsigned short quantity; //quantity of actives espaces of shared memory
// } shmtable;

int
shm_init()
{
  int i;
  initlock(&shmtable.lock, "shmtable");
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los 12 espacios de memoria compartida del sistema.
    shmtable.sharedmemory[i].refcount = -1;
  }
  return 0;
}

//Creates a shared memory block.
int
shm_create()
{ 
  acquire(&shmtable.lock);
  if ( shmtable.quantity == MAXSHM ){
    release(&shmtable.lock);
    return -1;
  }
  int i = 0;
  while (i<MAXSHM){
    if (shmtable.sharedmemory[i].refcount == -1){
      shmtable.sharedmemory[i].addr = kalloc();
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE);
      shmtable.sharedmemory[i].refcount++;
      shmtable.quantity++;
      release(&shmtable.lock);
      return i;
    } else
      ++i;
  }
  release(&shmtable.lock);
  return -1;
}

//Frees the memory block previously obtained.
int
shm_close(int key)
{
  acquire(&shmtable.lock);  
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == -1){
    release(&shmtable.lock);
    return -1;
  }
  int i = 0;
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){
    i++;
  }
  if (i == MAXSHMPROC){
    release(&shmtable.lock);
    return -1;
  }
  shmtable.sharedmemory[key].refcount--;
  if (shmtable.sharedmemory[key].refcount == 0){
    shmtable.sharedmemory[key].refcount = -1;
  }
  release(&shmtable.lock);
  return 0;  
}

//Obtains the address of the memory block associated with key.
int
shm_get(int key, char** addr)
{
  acquire(&shmtable.lock);
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == MAXSHMPROC ){
    release(&shmtable.lock); 
    return -1;
  }  
  int i = 0;
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){
    i++;
  }
  if (i == MAXSHMPROC ){
    release(&shmtable.lock); 
    return -1;
  } else {
    mappages(proc->pgdir, (void *)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
    proc->shmref[i] = shmtable.sharedmemory[key].addr;
    shmtable.sharedmemory[key].refcount++;
    *addr = (char *)PGROUNDDOWN(proc->sz);
    proc->shmemquantity++;
    proc->sz = proc->sz + PGSIZE;
    release(&shmtable.lock);
    return 0;
  }   
}

struct sharedmemory*
getshmtable(){
  return shmtable.sharedmemory;
}
