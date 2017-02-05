#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define N  4


void consumer (int sFactory, int sConsumer, char* memConsumer, int pid){

  int i;
  int j = 0;
  while (j<5){    
    semdown(sConsumer);
    semdown(sFactory);
    *memConsumer= ((int)*memConsumer) -1;
    printf(1,"consumer:%d, value= %d \n", pid,*memConsumer);
    i = 0;
    while (i<5000){ 
      i++;
    }
    semup(sFactory);
    j++;
  }   
}


void producer (int sFactory, int sConsumer, char* mem, int pid){
  int i;
  int j = 0; 
  while (j<5){
    i = 0;
    while (i<5000){
      i++;
    }
    semdown(sFactory);
    *mem= ((int)*mem)+1;
    printf(1,"producer:%d, value= %d \n", pid,*mem);
    semup(sFactory);
    semup(sConsumer); 
    j++;
  }    
}


int
main(int argc, char *argv[])
{

  int sConsumer,sFactory,pid,n,k; 

  sFactory= semget(-1,1); //init semaphore
  sConsumer= semget(-1,0);
  k = shm_create(1); //init shared memory
  char* mem= 0;
  shm_get(k,&mem);
  *mem = (int)0;
  for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      char* memH= 0;
      int flag = shm_get(k,&memH);
      if (flag == 0) 
        consumer(sFactory,sConsumer,memH,getpid());
      semfree(sFactory);
      semfree(sConsumer);
      if (flag == 0)
        shm_close(k); 
      exit();
    }       
  }  
  for(n=0; n<N; n++){
    pid = fork(); 
    if(pid == 0){
      char* memH= 0;
      int flag = shm_get(k,&memH);
      if (flag == 0)
        producer(sFactory,sConsumer,memH,getpid()); 
      semfree(sFactory);
      semfree(sConsumer); 
      if (flag == 0)
        shm_close(k);  
      exit();      
    }   
  }
  for(n=0; n<N*2; n++){
    wait();
  }
  semfree(sFactory);
  semfree(sConsumer);
  shm_close(k);
  exit();
}
