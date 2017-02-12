#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void
test(){
  int pid, keyIndex; // creo dos indices
  char* index = 0; // creo una direco inicializada en 0
  
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
  int pid, keyIndex, keyIndex_2;
  char* index = 0;
  char* index_2 = 0;
  keyIndex = shm_create();
  keyIndex_2 = shm_create();
  printf(1,"init index= %d  \n" , *index );
  printf(1,"init index= %d  \n" , &index );
  shm_get(keyIndex, &index);
  shm_get(keyIndex_2, &index_2);
  pid = fork(); 
  *index = 3;
  printf(1,"father index= %d  \n" , &index );
  printf(1,"father= %d  \n" , *index);
  
  if(pid == 0 ){
    shm_get(keyIndex, &index);
    shm_get(keyIndex_2, &index_2);
    printf(1,"child index= %d  \n" , *(index) );
    *index = 4;
    printf(1,"child index= %d  \n" , *(index) );
    *index_2 = 5;
    printf(1,"child index_2= %d  \n" , *(index_2) );
    exit();
  }
  printf(1,"exit index= %d  \n" , *(index) );
  wait();
  printf(1,"exit index_2= %d  \n" , *(index_2) );
  printf(1,"exit index= %d  \n" , &(index) );
  printf(1,"exit index= %d  \n" , *(index) );
  exit();
}
