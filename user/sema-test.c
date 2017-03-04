// Ejemplo de Productor consumidor.
//   // printf(1,"LOG semprod %d\n", semprod);
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
productor(int val)
{
  printf(1,"-- Inicia Productor --\n");
  semdown(semprod); // empty
  semdown(sembuff); // mutex
  //  REGION CRITICA
  val = (val) + 1;
  //
  semup(sembuff); //mutex
  semup(semcom); // full
  printf(1,"-- Termina Productor --\n");
}

void
consumidor(int val)
{ 
  printf(1,"-- Inicia Consumidor --\n");
  semdown(semcom); // full
  semdown(sembuff); // mutex
  // REGION CRITICA
  val = (val) - 1;
  //
  semup(sembuff); // mutex
  semup(semprod); // empty
  printf(1,"-- Termina Consumidor --\n");
  //}
}

int
main(void)
{
  int val = 8; 
  int i;

  printf(1,"-------------------------- VALOR INICIAL: [%d] \n", val);
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

  for (i = 0; i < 4; i++) { 
    semget(semprod,0);
    semget(semcom,0);
    semget(sembuff,0);
    productor(val);
  }

  for (i = 0; i < 3; i++) { 
    semget(semprod,0);
    semget(semcom,0);
    semget(sembuff,0);
    consumidor(val); 
  }

  printf(1,"-------------------------- VALOR FINAL: [%d]  \n", val);
  exit();
}









