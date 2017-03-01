// Ejemplo de Productor-Consumidor con "semaforos"
//
// Recordar: 
// * acceso al contenido
// & obtension de la direccion

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
productor( char* memProducer)
{
  printf(1,"-- Inicia Productor --\n");
  int i;
  for(i = 0; i < 4; i++){ 
    semdown(semprod); // empty
    semdown(sembuff); // mutex
    //  REGION CRITICA
    *memProducer= ((int)*memProducer) + 1;
    // 
    printf(1,"Productor libera, actualizo a [%x]\n", *memProducer);
    semup(sembuff); //mutex
    semup(semcom); // full
    printf(1,"-- Termina Productor --\n");
  }
}

void
consumidor(char* memConsumer)
{ 
  printf(1,"-- Inicia Consumidor --\n");
  int i;
  for(i = 0; i < 2; i++){
    semdown(semcom); // full
    semdown(sembuff); // mutex
    // REGION CRITICA
    *memConsumer= ((int)*memConsumer) - 1;
    // 
    printf(1,"Consumidor libera, actualizo a [%x]\n", *memConsumer);
    semup(sembuff); // mutex
    semup(semprod); // empty
    printf(1,"-- Termina Consumidor --\n");
  }
}

int
main(void)
{


  char* mem= 0;
  *mem = (int)8;   // inicio con 8
  int pid_productor, pid_consumidor, i;

  printf(1,"-------------------------- VALOR INICIAL: [%x] \n", *mem);
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
  
  // creo semaforo productor
  semprod = semget(-1,BUFF_SIZE); // empty
  if(semprod < 0){
    printf(1,"invalid semprod \n");
    exit();
  }
  // creo semaforo consumidor 
  semcom = semget(-1,0); // full
  if(semcom < 0){
    printf(1,"invalid semcom\n");
    exit();
  }
  // creo semaforo buffer 
  sembuff = semget(-1,1); // mutex
  if(sembuff < 0){
    printf(1,"invalid sembuff\n");
    exit();
  }

  for (i = 0; i < PRODUCERS; i++) { 
    // create producer process
    pid_productor = fork();
    if(pid_productor < 0){
      printf(1,"can't create producer process\n");
      exit(); 
    }
    // launch producer process
    if(pid_productor == 0){ // hijo
      printf(1," # hijo productor\n");
      semget(semprod,0);
      semget(semcom,0);
      semget(sembuff,0);
      productor(mem);
      exit();
    }
  }

  for (i = 0; i < CONSUMERS; i++) { 
    // create consumer process
    pid_consumidor = fork();
    if(pid_consumidor < 0){
      printf(1,"can't create consumer process\n");
      exit(); 
    }
    // launch consumer process
    if(pid_consumidor == 0){ // hijo
      printf(1," # hijo consumidor\n");
      semget(semprod,0);
      semget(semcom,0);
      semget(sembuff,0);
      consumidor(mem);
      exit();
    }
  }

  printf(1,"-------------------------- VALOR FINAL: [%x]  \n", *mem);
  exit();
}