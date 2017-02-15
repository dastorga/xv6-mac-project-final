struct sharedmemory {
  char* addr;    //shared memory address
  int refcount; //quantity of references
};

struct {
  struct sharedmemory sharedmemory[MAXSHM]; // array from type sharedmemory
  struct spinlock lock;
  unsigned short quantity; //quantity of actives espaces of shared memory
} shmtable;
   
struct sharedmemory* get_shm_table();