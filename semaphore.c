#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "semaphore.h"

struct {
	struct spinlock lock;
	struct sem sem[MAXSEM]; // atrib. (value,refcount) (MAXSEM = 16)
} stable;

// proc->procsem es la lista de semaforos por proceso
// MAXSEMPROC = 4 es la cantidad maxima de semaforos por proceso
struct sem** checkprocsem(){
	struct sem **r;
	// a "r" le asigno el arreglo de la list of semaphores del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
		if (*r == 0)
			return r;
	}
	return 0;
}

struct sem* getstable(){
	return stable.sem;
}

// crea u obtiene un descriptor de un semaforo existente
int semget(int sem_id, int init_value){
	int i;
	struct sem *t;
	struct sem *s;
	struct sem **r;
	static int first_time = 1;

	if (first_time) {
		initlock(&stable.lock, "stable"); // begin the mutual exclusion
		first_time = 0;
	}

	acquire(&stable.lock);
	if (sem_id == -1) { // se desea CREAR un semaforo nuevo
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
		if (t->refcount == 0){
			s = t;
			if (*(r = checkprocsem()) == 0)
				goto found; // encontro
			release(&stable.lock);
			return -2; // el proceso ya obtuvo el numero maximo de semaforos
		}
		release(&stable.lock);
		return -3; // no ahi mas semaforos disponibles en el sistema

		found:
		s->value = init_value;
		s->refcount=1;
		proc->semquantity++; // new
		*r = s;

		cprintf("SEMGET>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s - stable.sem, s->value, s->refcount);
		for (i = 0; i < MAXSEMPROC; i++) {
			if (*(proc->procsem + i) == 0) {
				cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i));
			} else
				cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i) - stable.sem);
		}

		release(&stable.lock);
		cprintf("cantidad de semaforos del proceso hasta aca --->%d\n", proc->semquantity);
		return s - stable.sem;	// retorna el semaforo

	} else { // en caso de que NO se desea crear un semaforo nuevo
		s = stable.sem + sem_id;
		if (s->refcount == 0){
			release(&stable.lock);
			return -1; // el semaforo con ese "sem_id" no esta en uso 
		}else if (*(r = checkprocsem()) == 0){
			*r = s;
			s->refcount++; //aumento referencia
			release(&stable.lock);
			return sem_id; // retorno identificador del semaforo
		}	else {
			release(&stable.lock);
			return -2; // el proceso ya obtuvo el maximo de semaforos

		}
	}
}

// libera el semaforo.
// como parametro toma un descriptor.
int semfree(int sem_id){
	struct sem *s;
	struct sem **r;

	s = stable.sem + sem_id;
	if (s->refcount == 0) // si no tiene ninguna referencia, entonces no esta en uso,	
		return -1;		 //  y no es posible liberarlo, se produce un ERROR! 

	// recorro todos los semaforos del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
		if (*r == s) {
			*r = 0;
			acquire(&stable.lock);
			s->refcount--; // disminuyo el contador, debido a q es un semaforo q se va.
			proc->semquantity--; // new
			release(&stable.lock);
			return 0;
		}
	}
	return -1;
}

// decrementa una unidad el valor del semaforo.
int semdown(int sem_id){
	struct sem *s;

	s = stable.sem + sem_id;
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
	if (s->refcount <= 0) {
		release(&stable.lock);
		// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error!!
	}
	while (s->value == 0)
		sleep(s, &stable.lock); 

	s->value--;
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	release(&stable.lock);
	return 0;
}

// incrementa una unidad el valor del semaforo
int semup(int sem_id){
struct sem *s;

	s = stable.sem + sem_id;
	// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
	if (s->refcount <= 0) {
		release(&stable.lock);
		// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error, por que no ahi referencias en este semaforo.
	}
	if (s->value >= 0) {
		if (s->value == 0){
			s->value++;
			wakeup(s); // despierto
		}else
			s->value++;
			release(&stable.lock);
			// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	}
	return 0;
}