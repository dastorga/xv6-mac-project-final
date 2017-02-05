#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "semaphore.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// New: Add in proyect 1: implementation of system call procstat
int
sys_procstat(void){             
  procdump(); // Print a process listing to console.
  return 0; 
}

// New: Add in project 2: implementation of syscall set_priority
int
sys_set_priority(void){
  int pr;
  argint(0, &pr);
  proc->priority=pr;
  return 0;
}

// New: Add in project final - (semaphore)
int
sys_semget(void)
{
  int semid, init_value;
  if( argint(1, &init_value) < 0 || argint(0, &semid) < 0)
    return -1;
  return semget(semid,init_value);
}

// New: Add in project final - (semaphore)
int 
sys_semfree(void)
{
  int semid;
  if(argint(0, &semid) < 0)
    return -1;
  return semfree(semid);
}

// New: Add in project final - (semaphore)
int 
sys_semdown(void)
{
  int semid;
  if(argint(0, &semid) < 0)
    return -1;
  return semdown(semid);
}

// New: Add in project final - (semaphore)
int 
sys_semup(void)
{
  int semid;
  if(argint(0, &semid) < 0)
    return -1;
  return semup(semid);
}
