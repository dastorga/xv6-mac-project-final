#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

// test shm_create and shm_get
void
test_0(){
  int keyIndex; //declaro variable de tipo int
  char* index = 0; // declaro puntero

  keyIndex = shm_create(); // creo el espacio de memoria a compartir
  // Operador de Dirección (&): Este nos permite acceder a la dirección de memoria de una variable.
  // Operador de Indirección (*): Además de que nos permite declarar un tipo de dato puntero, también nos permite ver el VALOR que está en la dirección asignada.
  printf(1,"*index = %d  \n" , *index );
  printf(1,"&index= %d  \n" , &index );
  printf(1,"keyIndex= %d  \n" , keyIndex ); // primer indice del arreglo
  
  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  printf(1,"return shm_get %d  \n" , a);  // si retorna 0, pudo obtener el espacio de memoria asociado a el keyIndex
}

void
test(){
  int pid, keyIndex;
  char* index = 0;
  keyIndex = shm_create();
  printf(1,"init index= %d  \n" , *index );
  printf(1,"init index= %d  \n" , &index );
  shm_get(keyIndex, &index);
  pid = fork(); 
  *index = 3;
  printf(1,"father index= %d  \n" , &index );
  printf(1,"father= %d  \n" , *index);
  
  if(pid == 0 ){
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
    *index = 4;
    printf(1,"child index= %d  \n" , *(index) );
    //shm_close(keyIndex);
    exit();
  }
  printf(1,"exit index= %d  \n" , *(index) );
  wait();
  printf(1,"exit index= %d  \n" , &(index) );
  printf(1,"exit index= %d  \n" , *(index) );
  
}


int
main(int argc, char *argv[]) {

  test_0();

  // int pid, keyIndex, keyIndex_2;
  // char* index = 0;
  // char* index_2 = 0;
  // keyIndex = shm_create();
  // keyIndex_2 = shm_create();
  // printf(1,"init index= %d  \n" , *index );
  // printf(1,"init index= %d  \n" , &index );
  // shm_get(keyIndex, &index);
  // shm_get(keyIndex_2, &index_2);
  // pid = fork(); 
  // *index = 3;
  // printf(1,"father index= %d  \n" , &index );
  // printf(1,"father= %d  \n" , *index);
  
  // if(pid == 0 ){
  //   shm_get(keyIndex, &index);
  //   shm_get(keyIndex_2, &index_2);
  //   printf(1,"child index= %d  \n" , *(index) );
  //   *index = 4;
  //   printf(1,"child index= %d  \n" , *(index) );
  //   *index_2 = 5;
  //   printf(1,"child index_2= %d  \n" , *(index_2) );
  //   exit();
  // }
  // printf(1,"exit index= %d  \n" , *(index) );
  // wait();
  // printf(1,"exit index_2= %d  \n" , *(index_2) );
  // printf(1,"exit index= %d  \n" , &(index) );
  // printf(1,"exit index= %d  \n" , *(index) );
  exit();
}
