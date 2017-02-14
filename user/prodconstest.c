#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"
#include "syscall.h"

#define PRODUCERS 4
#define CONSUMERS 2
#define BUFF_SIZE 4
#define MAX_IT 5
#define NUMSEM 1
#define N  4

int buffer;
int semprod;
int semcom;
int sembuff;

void
produce( char* memProducer)
{
  printf(1,">> Start Producer\n");
  int i;
  for(i = 0; i < MAX_IT * CONSUMERS; i++){
    semdown(semprod); // empty
    semdown(sembuff); // mutex
    *memProducer= ((int)*memProducer)+1;
    printf(1,"producer libera [%x]\n", *memProducer);
    semup(sembuff); //mutex
    semup(semcom); // full
    printf(1,">> Termina producer\n");
  }
}

void
consume(char* memConsumer)
{
  //shm_get(key, &memConsumer);
  
  printf(1,">> Start Consumer\n");
  int i;
  for(i = 0; i < MAX_IT * PRODUCERS; i++){
    //printf(1,"consumer obtiene\n");
    semdown(semcom);
    semdown(sembuff);
    *memConsumer= ((int)*memConsumer) -1;
    printf(1,"consumer libera [%x]\n", *memConsumer);
    semup(sembuff);
    semup(semprod);
    printf(1,">> Termina consumer\n");
  }
}
// print process list running in the system 
// calling system procstat
int
main(void)
{
  int k;  
  char* mem= 0;
  k = shm_create();
  shm_get(k,&mem);
  *mem = (int)8;

  int pid_prod, pid_com, i;
  printf(1,"***************Valor Inicial[%x]***************\n", *mem);
  printf(1,"Buffer size: %d\n", BUFF_SIZE);
  // init buffer file
    for (i = 0; i < NUMSEM; i++) {
      // create producer semaphore
      semprod = semget(-1,BUFF_SIZE); // empty
      if(semprod < 0){
        printf(1,"invalid semprod \n");
        exit();
    }
    
    // create consumer semaphore
    semcom = semget(-1,0); // full
    if(semcom < 0){
      printf(1,"invalid semcom\n");
      exit();
    }
    
    // create buffer semaphore
    sembuff = semget(-1,1); // mutex
    if(sembuff < 0){
      printf(1,"invalid sembuff\n");
      exit();
    }
  }
  for (i = 0; i < PRODUCERS; i++) {
    // create producer process
    pid_prod = fork();
    if(pid_prod < 0){
      printf(1,"can't create producer process\n");
      exit(); 
    }
    // launch producer process
    if(pid_prod == 0){
      shm_get(k, &mem);
      semget(semprod,0);
      semget(semcom,0);
      semget(sembuff,0);
      produce(mem);
      exit();
    }
  }
  for (i = 0; i < CONSUMERS; i++) {

    // create consumer process
    pid_com = fork();
    if(pid_com < 0){
      printf(1,"can't create consumer process\n");
      exit(); 
    }
    // launch consumer process
    if(pid_com == 0){
      shm_get(k, &mem);
      semget(semprod,0);
      semget(semcom,0);
      semget(sembuff,0);
      consume(mem);
      exit();
    }
  }
  for (i = 0; i < PRODUCERS + CONSUMERS; i++) {
    wait();
  }
  printf(1,"***************Valor Final[%x]***************\n", *mem);
  exit();
}