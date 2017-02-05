// System call numbers
#define SYS_fork    1
#define SYS_exit    2
#define SYS_wait    3
#define SYS_pipe    4
#define SYS_read    5
#define SYS_kill    6
#define SYS_exec    7
#define SYS_fstat   8
#define SYS_chdir   9
#define SYS_dup    10
#define SYS_getpid 11
#define SYS_sbrk   12
#define SYS_sleep  13
#define SYS_uptime 14
#define SYS_open   15
#define SYS_write  16
#define SYS_mknod  17
#define SYS_unlink 18
#define SYS_link   19
#define SYS_mkdir  20
#define SYS_close  21
#define SYS_lseek  22
#define SYS_isatty 23
#define SYS_procstat 24 // New - number the system call procstat
#define SYS_set_priority 25 // New: Add in proyect 2: new number for set_priority calls
#define SYS_semget	   26 // New: Add in project final - (semaphore)
#define SYS_semfree	   27 // New: Add in project final - (semaphore)
#define SYS_semdown	   28 // New: Add in project final - (semaphore)
#define SYS_semup  	   29 // New: Add in project final - (semaphore)
#define SYS_shm_create 30 // New: Add in project final - (shared memory)
#define SYS_shm_close  31 // New: Add in project final - (shared memory)
#define SYS_shm_get    32 // New: Add in project final - (shared memory)
