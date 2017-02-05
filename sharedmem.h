struct sharedmemory {
  char* addr;    //shared memory address
  int refcount; //quantity of references
};

struct {
  struct sharedmemory sharedmemory[MAXSHM];
  struct spinlock lock;
  unsigned short quantity; //quantity of actives espaces of shared memory
} shmtable;

struct sharedmemory* getshmtable();