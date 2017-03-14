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
  while (i<MAXSHM){ // busco el primer espacio desocupado
    if (shmtable.sharedmemory[i].refcount == -1){ // si es -1, esta desocupado el espacio.
      shmtable.sharedmemory[i].addr = kalloc(); // El "kalloc" asigna una pagina de 4096 bytes de memoria fisica,
                                                // si todo sale bien, me retorna como resultado un puntero (direccion), 
                                                // a esta direccion la almaceno en "sharedmemory.addr".
                                                // Si el kalloc no pudo asignar la memoria me devuelve como resultado 0.
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE); 
      shmtable.sharedmemory[i].refcount++; // Incremento el refcount en una unidad, estaba en -1, ahora en 0, inicialmente.
      shmtable.quantity++; // se tomo un espacio del arreglo 
      release(&shmtable.lock);
      return i; // retorno el indice (key) del arreglo en donde se encuentra el espacio de memoria compartida.
    } else
      ++i;
  }
  release(&shmtable.lock);
  //return -2 si proc->sharedmemory == MAXSHMPROC; // Consultar?: el proceso ya alcanzo el maximo de recursos posibles.
  return -1; // no ahi mas recursos disponbles en el sistema.
}

//Frees the memory block previously obtained.
int
shm_close(int key)
{
  acquire(&shmtable.lock);  
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == -1){
    release(&shmtable.lock);
    return -1; // key invalidad por que no esta dentro de los indices (0 - 12), o en ese espacio esta vacio (refcount = -1)
  }
  int i = 0;
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
    i++; // avanzo al proximo
  }
  if (i == MAXSHMPROC){ 
    release(&shmtable.lock);
    return -1; // se alcazo a recorrer todos los espacios de memoria compartida del proceso.
  }  
  shmtable.sharedmemory[key].refcount--; // encontre la direccion, luego decremento refcount.
  if (shmtable.sharedmemory[key].refcount == 0){ 
    shmtable.sharedmemory[key].refcount = -1; // reinicio el espacio en el arreglo, como solo quedo uno, lo reinicio.
  }
  release(&shmtable.lock);
  return 0;  // todo en orden
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
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
    i++;
  }
  if (i == MAXSHMPROC ){ // si agoto los 4 espacios que posee el proceso disponible, entonces..
    release(&shmtable.lock); 
    return -1; // no ahi mas recursos disponibles (esp. de memoria compartida) por este proceso.
  } else {  
            
    j = mappages(proc->pgdir, (void *)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
            // parametros mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
            // MAPPAGES: crea PTEs para direcciones virtuales comenzando en va que se refieren a
            // direcciones físicas empezando por pa.
            // Llena entradas de la tabla de paginas, mapeo de direcciones virtuales segun direc. fisicas

            // PTE_U: controla que el proceso de usuario pueda utilizar la pagina, si no solo el kernel puede usar la pagina.
            // PTE_W: controla si las instrucciones se les permite escribir en la pagina.

    if (j==-1) { cprintf("mappages error \n"); }

    proc->shmref[i] = shmtable.sharedmemory[key].addr; // la guardo en shmref[i]
    shmtable.sharedmemory[key].refcount++; 
    *addr = (char *)PGROUNDDOWN(proc->sz); // guardo la direccion en *addr, de la pagina que se encuentra por debajo de proc->sz
    proc->shmemquantity++; // aumento la cantidad de espacio de memoria compartida por el proceso
    proc->sz = proc->sz + PGSIZE; // actualizo el tamaño de la memoria del proceso, debido a que ya se realizo el mapeo
    release(&shmtable.lock);
    return 0; // todo salio bien.
  }   
}

//Obtains the array from type sharedmemory
struct sharedmemory* get_shm_table(){
  return shmtable.sharedmemory; // como resultado, mi arreglo principal sharedmemory 
}


