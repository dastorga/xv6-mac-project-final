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
struct sem sem[MAXSEM];
} stable;

struct sem** checkprocsem(){
struct sem **r;
for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
if (*r == 0)
return r;
}
return 0;
}

struct sem* getstable(){
return stable.sem;
}

int semget(int sem_id, int init_value){
// int i;
struct sem *t;
struct sem *s;
struct sem **r;
static int first_time = 1;

if (first_time) {
initlock(&stable.lock, "stable");
first_time = 0;
}

acquire(&stable.lock);
if (sem_id == -1) {
for (t = stable.sem; t < stable.sem + MAXSEM; t++)
if (t->refcount == 0){
s = t;
if (*(r = checkprocsem()) == 0)
	goto found;
release(&stable.lock);
return -2;
}
release(&stable.lock);
return -3;

found:
s->value = init_value;
s->refcount=1;
*r = s;

// cprintf("SEMGET>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s - stable.sem, s->value, s->refcount);
// for (i = 0; i < MAXSEMPROC; i++) {
// 	if (*(proc->procsem + i) == 0) {
// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i));
// 	} else
// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i) - stable.sem);
// }

release(&stable.lock);
return s - stable.sem;	

} else {
s = stable.sem + sem_id;
if (s->refcount == 0){
release(&stable.lock);
return -1;
}else if (*(r = checkprocsem()) == 0){
*r = s;
s->refcount++;
release(&stable.lock);
return sem_id;
}	else {
release(&stable.lock);
return -2;
}
}
}


int semfree(int sem_id){
struct sem *s;
struct sem **r;

s = stable.sem + sem_id;
if (s->refcount == 0)
return -1;

for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
if (*r == s) {
*r = 0;
acquire(&stable.lock);
s->refcount--;
release(&stable.lock);
return 0;
}
}
return -1;
}


int semdown(int sem_id){
struct sem *s;

s = stable.sem + sem_id;
// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
acquire(&stable.lock);
if (s->refcount <= 0) {
release(&stable.lock);
// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
return -1;
}
while (s->value == 0)
sleep(s, &stable.lock);

s->value--;
// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
release(&stable.lock);
return 0;
}


int semup(int sem_id){
struct sem *s;

s = stable.sem + sem_id;
// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
acquire(&stable.lock);
if (s->refcount <= 0) {
release(&stable.lock);
// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
return -1;
}
if (s->value >= 0) {
if (s->value == 0){
s->value++;
wakeup(s);
}else
s->value++;
release(&stable.lock);
// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
}
return 0;
}