struct sem {
int value;
int refcount;
};

int semget(int sem_id, int init_value);
int semfree(int sem_id);
int semdown(int sem_id);
int semup(int sem_id);

struct sem* getstable();