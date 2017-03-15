#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

// test shm_create and shm_get
void
test_0(){
  // Operador de Dirección (&): Este nos permite acceder a la dirección de memoria de una variable.
  // Operador de Indirección (*): Además de que nos permite declarar un tipo de dato puntero, también nos permite ver el VALOR que está en la dirección asignada.
  int keyIndex; 
  char *index = 0; // declaro puntero

  keyIndex = shm_create(); // creo el espacio de memoria a compartir

  printf(1,"*index = %d  \n" , *index ); 
  printf(1,"index= %d  \n" , index ); 
  printf(1,"&index= %d  \n" , &index );
  printf(1,"Indice del arreglo= %d  \n" , keyIndex ); // primer indice del arreglo

  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  printf(1,"return shm_get %d  \n" , a);  // si retorna 0, pudo obtener el espacio de memoria asociado a el indice keyIndex
}

// test shm_close
// void
// test_1(){
//   int keyIndex;
//   keyIndex = shm_create(); // creo el espacio de memoria y guardo el indice
//   printf(1,"creo el espacio de memoria y guardo el indice %d  \n" , keyIndex );
//   printf(1,"resultado del shm_close %d  \n" , shm_close(keyIndex));
// }

// test shm_create
void
test_2(){
  int keyIndex;
  int keyIndex_2;
  keyIndex = shm_create(); //Creates a shared memory block.
  keyIndex_2 = shm_create(); //Creates a shared memory block.
  printf(1,"keyIndex  %d  \n" , keyIndex);
  printf(1,"keyIndex_2 %d  \n" , keyIndex_2);
  exit();
}

void
test(){
  int pid, keyIndex;
  char* index = 0;

  keyIndex = shm_create(); //creo el espacio de memoria

  printf(1,"init index= %d  \n" , *index );
  printf(1,"init index= %d  \n" , &index );

  shm_get(keyIndex, &index); // map

  pid = fork(); // creo un proceso (hijo) - printf(1,"pid= %d  \n" , pid );
  *index = 3;

  printf(1,"father index= %d  \n" , &index );
  printf(1,"father= %d  \n" , *index);

  printf(1,"** ** ** ** ** \n");

  if(pid == 0 ){
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
    *index = 4;
    printf(1,"child index= %d  \n" , *(index) );
    //shm_close(keyIndex);
    exit();
  }
  printf(1,"exit *(index)= %d  \n" , *(index) );
  wait();
  printf(1,"exit &(index)= %d  \n" , &(index) );
  printf(1,"exit *(index)= %d  \n" , *(index) );
}

void
test_4(){
  int a;
  int k;
  char* mem= 0;
  *mem = (int)8; 
  k = shm_create();  // creo espacio de memoria que sera para compartir
  printf(1,"salida shm_create %d  \n" , k);

  shm_get(k,&mem);  // mapeo el espacio 
  a = shm_close(k);

  printf(1,"salida shm_close %d  \n" , a);
  exit();
}

int
main(int argc, char *argv[]) {

  // test_0();
  // test_1();
  // test();
  // test_4();
 
  // int pid;
  // int keyIndex;
  // int keyIndex_2;
  // char* index = 0; 
  // char* index_2 = 0; 

  // keyIndex = shm_create(); //Creates a shared memory block.
  // keyIndex_2 = shm_create(); //Creates a shared memory block.

  // printf(1,"init *index = %d  \n" , *index );
  // printf(1,"init &index = %d  \n" , &index );
  // printf(1,"init *index_2 = %d  \n" , *index_2 );
  // printf(1,"init &index_2 = %d  \n" , &index_2 );
  
  // printf(1,"keyIndex: %d  \n" , keyIndex);
  // printf(1,"keyIndex_2: %d  \n" , keyIndex_2);

  // shm_get(keyIndex, &index); // obtiene la direccion del bloque de memoria asociado a la keyIndex
  // shm_get(keyIndex_2, &index_2);

  // printf(1," * * * * fork() * * * *\n");
  // pid = fork(); 
  // *index = 3; 

  // printf(1,"despues del fork *index = %d  \n" , *index);
  // printf(1,"despues del fork &index = %d  \n" , &index );
  
  // if(pid == 0 ){
  //   printf(1," * * * * Hijo * * * *\n");
  //   shm_get(keyIndex, &index);
  //   shm_get(keyIndex_2, &index_2);
  //   printf(1,"child *(index) = %d  \n" , *(index));
  //   *index = 4;
  //   printf(1,"child *(index) = %d  \n" , *(index));
  //   *index_2 = 5;
  //   printf(1,"child *(index_2) = %d  \n" , *(index_2));
  //   exit();
  // }
  // printf(1,"antes del wait *(index) = %d  \n" , *(index) );
  // wait();
  // printf(1," * * * * Padre * * * *\n");
  // printf(1,"father *(index_2) = %d  \n" , *(index_2));
  // printf(1,"father &(index) = %d  \n" , &(index));
  // printf(1,"father *(index) = %d  \n" , *(index));
   exit();
}



