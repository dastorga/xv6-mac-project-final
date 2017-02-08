#define NPROC        64  // maximum number of processes
#define KSTACKSIZE 4096  // size of per-process kernel stack
#define NCPU          8  // maximum number of CPUs
#define NOFILE       16  // open files per process
#define NFILE       100  // open files per system
#define NBUF         10  // size of disk block cache
#define NINODE       50  // maximum number of active i-nodes
#define NDEV         10  // maximum major device number
#define ROOTDEV       1  // device number of file system root disk
#define MAXARG       32  // max exec arguments
#define LOGSIZE      10  // max data sectors in on-disk log
#define QUANTUM		  6  // New: Add in proyect 0: representation the quantum of ticks
#define MLF_LEVELS    4  // New: Add in proyect 2: Levels
#define SIZEMLF       4  // New: Add in proyect 2: size mlf
#define MAXSEM		 16	 // New: Add in project final: semaphores per system
#define MAXSEMPROC	  4	 // New: Add in project final: semaphores per process

#define MAXPAGES      1  // New: Add in project final - maximum allocated pages
#define LIMITPS      16  // New: Add in project final - limit to access in new page stack
#define MAXSHM       12  // New: Add in project final - maximum quantity of spaces of shared memory in system
#define MAXSHMPROC    4  // New: Add in project final - maximum quantity of spaces of shared memory per process