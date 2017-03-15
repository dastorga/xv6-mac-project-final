#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include "sharedmem.h"

// Initialization of shmtable.sharedmemory[i].refcount
int
shm_init()
{
  int i;
  initlock(&shmtable.lock, "shmtable");
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
    shmtable.sharedmemory[i].refcount = -1; // inician todos los espacios con su contador de referencia en -1.
  }
  return 0;
}

//Creates a shared memory block.
int
shm_create()
{ 
  acquire(&shmtable.lock);
  if ( shmtable.quantity == MAXSHM ){ // si la cantidad de espacios activos en sharedmemory es igual a 12
    release(&shmtable.lock);         // es la logitud maxima del array sharedmemory, entonces:
    return -1;                      // no ahi mas espacios de memoria compartida, se fueron los 12 espacios que habia.
  }
  int i = 0;
  while (i<MAXSHM){ 
    if (shmtable.sharedmemory[i].refcount == -1){ // si es -1, esta desocupado el espacio.
      shmtable.sharedmemory[i].addr = kalloc(); // El "kalloc" me retorna dirección virtual en modo kernel                                      
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
  while (i<MAXSHMPROC && proc->shmem[i] != key){ 
    i++; 
  }
  if (i == MAXSHMPROC){ 
    release(&shmtable.lock);
    return -1; 
  }  
  proc->shmemquantity--; // decrement quantity of spaces in shared memory  
  proc->shmem[i] = -1;
  shmtable.sharedmemory[key].refcount--; // decrement quantity of references
  if (shmtable.sharedmemory[key].refcount == 0){ 
    shmtable.sharedmemory[key].refcount = -1; 
    shmtable.quantity--;
  }
  unmap(proc->pgdir, proc->shmref[i], PGSIZE, shmtable.sharedmemory[key].refcount);
  release(&shmtable.lock);
  return 0;  
}

//Obtains the address of the memory block associated with key.
int
shm_get(int key, char** addr)
{
  int j;
  acquire(&shmtable.lock);
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == MAXSHMPROC ){ 
    release(&shmtable.lock);                 
    return -1; // key invalida, debido a que esta fuera de los indices la key.
  }  
  int i = 0;
  while (i<MAXSHMPROC && proc->shmem[i] != -1 ){ 
    i++;
  }
  if (i == MAXSHMPROC ){ 
    release(&shmtable.lock); 
    return -1; // no ahi mas recursos disponibles (esp. de memoria compartida) por este proceso.
  } else {   
    shmtable.sharedmemory[key].refcount++;
    proc->shmem[i]=key;
    proc->shmemquantity++;

    j = mappages(proc->pgdir, (void*)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
    if (j==-1) { cprintf("mappages error \n"); }
    proc->shmref[i] = (char*)PGROUNDDOWN(proc->sz);
    *addr = (char*)PGROUNDDOWN(proc->sz); 
    proc->sz = proc->sz + PGSIZE;
    release(&shmtable.lock);
    return 0; 
  }   
}

//Obtains the array from type sharedmemory
struct sharedmemory* get_shm_table(){
  return shmtable.sharedmemory; // como resultado, mi arreglo principal sharedmemory 
}

