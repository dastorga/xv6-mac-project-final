// Pruebas para semaforo.

#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "stat.h"
#include "syscall.h"

#define BUFF_SIZE 4
#define MAX_IT 5
#define NUMSEM 1
#define N  4

int semprod;
int semcom;
int sembuff;
int semprueba1;
int semprueba2;
int res;
// int res2;

// Test_0: ERROR, en la creacion de 5 semaforos para un proceso.
void
test_0(){
  semprod = semget(-1,BUFF_SIZE); 
  printf(1,"LOG semaforo: %d\n", semprod);
  if(semprod < 0){
    printf(1,"invalid semprod \n");
    exit();
  }
  semcom = semget(-1,0);   
  printf(1,"LOG semaforo: %d\n", semcom);
  if(semcom < 0){
    printf(1,"invalid semcom\n");
    exit();
  }
  sembuff = semget(-1,1); 
  printf(1,"LOG semaforo: %d\n", sembuff);
  if(sembuff < 0){
    printf(1,"invalid sembuff\n");
    exit();
  }
  semprueba1 = semget(-1,5); 
  printf(1,"LOG: semaforo: %d\n", semprueba1); 
  if(semprueba1 < 0){
    printf(1,"invalid semprueba1\n");
    exit();
  }

  semprueba2 = semget(-1,6); 
  printf(1,"LOG: semaforo: %d\n", semprueba2); 
  if(semprueba2 == -2){
    printf(1,"ERROR el proceso corriente ya obtuvo el numero maximo de semaforos\n");
    exit();
  }
  if(semprueba2 == -3){
    printf(1,"ERROR no ahi mas semaforos disponibles en el sistema\n");
    exit();
  }
}

// Test_1: Creacion y Obtencion del descriptor de un semaforo
void
test_1(){

  semprod = semget(-1,4); 
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
  if(semprod < 0){
    printf(1,"Error! en la creacion del semaforo\n");
    exit();
  }

  res = semget(1,0); // le paso el identificador 1, y el unico semaforo creado que tengo es con identificador 0
  if(res == -1){
    printf(1,"ERROR, el semaforo con ese identificador no esta en uso\n");
    exit();
  }
  if(res == -2){
    printf(1,"ERROR, el proceso ya obtuvo el maximo de semaforos\n");
    exit();
  }
  printf(1,"El identificador del semaforo obtenido es: %d\n", res);
}

// Test_2: contador de semaforos en el proceso padre corriente 
void
test_2(){
  semprod = semget(-1,4); 
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
  if(semprod < 0){
    printf(1,"Error! en la creacion del semaforo\n");
    exit();
  }

}

void
test_3(){
  semprod = semget(-1,4); 
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
  if(semprod < 0){
    printf(1,"Error! en la creacion del semaforo\n");
    exit();
  }
  semprod = semget(0,4); 
  semprod = semget(0,4); 
  semprod = semget(0,4); 
}

int
main(void)
{
  //test_0();
  //test_1();
  //test_2();
  test_3();

  exit();
}






















