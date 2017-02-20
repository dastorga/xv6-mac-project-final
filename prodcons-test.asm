
_prodcons-test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <produce>:
int semcom;
int sembuff;

void
produce( char* memProducer)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  printf(1,"-- Inicia Productor --\n");
   6:	c7 44 24 04 04 0c 00 	movl   $0xc04,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 24 08 00 00       	call   83e <printf>
  int i;
  for(i = 0; i < MAX_IT * CONSUMERS; i++){ // el i va hasta 10
  1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  21:	eb 78                	jmp    9b <produce+0x9b>
    semdown(semprod); // empty
  23:	a1 28 10 00 00       	mov    0x1028,%eax
  28:	89 04 24             	mov    %eax,(%esp)
  2b:	e8 0e 07 00 00       	call   73e <semdown>
    semdown(sembuff); // mutex
  30:	a1 2c 10 00 00       	mov    0x102c,%eax
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 01 07 00 00       	call   73e <semdown>
    //  REGION CRITICA
    *memProducer= ((int)*memProducer) + 1;
  3d:	8b 45 08             	mov    0x8(%ebp),%eax
  40:	8a 00                	mov    (%eax),%al
  42:	40                   	inc    %eax
  43:	88 c2                	mov    %al,%dl
  45:	8b 45 08             	mov    0x8(%ebp),%eax
  48:	88 10                	mov    %dl,(%eax)
    // 
    printf(1,"Productor libera [%x]\n", *memProducer);
  4a:	8b 45 08             	mov    0x8(%ebp),%eax
  4d:	8a 00                	mov    (%eax),%al
  4f:	0f be c0             	movsbl %al,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	c7 44 24 04 1c 0c 00 	movl   $0xc1c,0x4(%esp)
  5d:	00 
  5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  65:	e8 d4 07 00 00       	call   83e <printf>
    semup(sembuff); //mutex
  6a:	a1 2c 10 00 00       	mov    0x102c,%eax
  6f:	89 04 24             	mov    %eax,(%esp)
  72:	e8 cf 06 00 00       	call   746 <semup>
    semup(semcom); // full
  77:	a1 34 10 00 00       	mov    0x1034,%eax
  7c:	89 04 24             	mov    %eax,(%esp)
  7f:	e8 c2 06 00 00       	call   746 <semup>
    printf(1,"-- Termina Productor --\n");
  84:	c7 44 24 04 33 0c 00 	movl   $0xc33,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 a6 07 00 00       	call   83e <printf>
  for(i = 0; i < MAX_IT * CONSUMERS; i++){ // el i va hasta 10
  98:	ff 45 f4             	incl   -0xc(%ebp)
  9b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
  9f:	7e 82                	jle    23 <produce+0x23>
  }
}
  a1:	c9                   	leave  
  a2:	c3                   	ret    

000000a3 <consume>:

void
consume(char* memConsumer)
{ //shm_get(key, &memConsumer);
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	83 ec 28             	sub    $0x28,%esp
  
  printf(1,"-- Inicia Consumidor --\n");
  a9:	c7 44 24 04 4c 0c 00 	movl   $0xc4c,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 81 07 00 00       	call   83e <printf>
  int i;
  for(i = 0; i < MAX_IT * PRODUCERS; i++){ // hasta 20
  bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  c4:	eb 78                	jmp    13e <consume+0x9b>
    //printf(1,"consumer obtiene\n");
    semdown(semcom);
  c6:	a1 34 10 00 00       	mov    0x1034,%eax
  cb:	89 04 24             	mov    %eax,(%esp)
  ce:	e8 6b 06 00 00       	call   73e <semdown>
    semdown(sembuff);
  d3:	a1 2c 10 00 00       	mov    0x102c,%eax
  d8:	89 04 24             	mov    %eax,(%esp)
  db:	e8 5e 06 00 00       	call   73e <semdown>
    // REGION CRITICA
    *memConsumer= ((int)*memConsumer) - 1;
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	8a 00                	mov    (%eax),%al
  e5:	48                   	dec    %eax
  e6:	88 c2                	mov    %al,%dl
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	88 10                	mov    %dl,(%eax)
    // 
    printf(1,"Consumidor libera [%x]\n", *memConsumer);
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 00                	mov    (%eax),%al
  f2:	0f be c0             	movsbl %al,%eax
  f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  f9:	c7 44 24 04 65 0c 00 	movl   $0xc65,0x4(%esp)
 100:	00 
 101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 108:	e8 31 07 00 00       	call   83e <printf>
    semup(sembuff);
 10d:	a1 2c 10 00 00       	mov    0x102c,%eax
 112:	89 04 24             	mov    %eax,(%esp)
 115:	e8 2c 06 00 00       	call   746 <semup>
    semup(semprod);
 11a:	a1 28 10 00 00       	mov    0x1028,%eax
 11f:	89 04 24             	mov    %eax,(%esp)
 122:	e8 1f 06 00 00       	call   746 <semup>
    printf(1,"-- Termina Consumidor --\n");
 127:	c7 44 24 04 7d 0c 00 	movl   $0xc7d,0x4(%esp)
 12e:	00 
 12f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 136:	e8 03 07 00 00       	call   83e <printf>
  for(i = 0; i < MAX_IT * PRODUCERS; i++){ // hasta 20
 13b:	ff 45 f4             	incl   -0xc(%ebp)
 13e:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 142:	7e 82                	jle    c6 <consume+0x23>
  }
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <main>:

// print process list running in the system 
// calling system procstat
int
main(void)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 e4 f0             	and    $0xfffffff0,%esp
 14c:	83 ec 30             	sub    $0x30,%esp
  int k;  
  char* mem= 0;
 14f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 156:	00 
  k = shm_create(); // creo espacio de memoria que sera para compartir
 157:	e8 f2 05 00 00       	call   74e <shm_create>
 15c:	89 44 24 28          	mov    %eax,0x28(%esp)
  shm_get(k,&mem);  // mapeo el espacio 
 160:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 164:	89 44 24 04          	mov    %eax,0x4(%esp)
 168:	8b 44 24 28          	mov    0x28(%esp),%eax
 16c:	89 04 24             	mov    %eax,(%esp)
 16f:	e8 ea 05 00 00       	call   75e <shm_get>
  *mem = (int)8;  // inicialmente con 8 
 174:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 178:	c6 00 08             	movb   $0x8,(%eax)

  int pid_prod, pid_com, i;
  printf(1,"-------------------------- VALOR INICIAL: [%x] \n", *mem);
 17b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	0f be c0             	movsbl %al,%eax
 184:	89 44 24 08          	mov    %eax,0x8(%esp)
 188:	c7 44 24 04 98 0c 00 	movl   $0xc98,0x4(%esp)
 18f:	00 
 190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 197:	e8 a2 06 00 00       	call   83e <printf>
  printf(1,"Tamaño de buffer: %d\n", BUFF_SIZE);
 19c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 1a3:	00 
 1a4:	c7 44 24 04 c9 0c 00 	movl   $0xcc9,0x4(%esp)
 1ab:	00 
 1ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b3:	e8 86 06 00 00       	call   83e <printf>
  
  // init buffer file
    for (i = 0; i < NUMSEM; i++) {
 1b8:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 1bf:	00 
 1c0:	e9 b5 00 00 00       	jmp    27a <main+0x134>
      // create producer semaphore
      semprod = semget(-1,BUFF_SIZE); // empty
 1c5:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 1cc:	00 
 1cd:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1d4:	e8 55 05 00 00       	call   72e <semget>
 1d9:	a3 28 10 00 00       	mov    %eax,0x1028
      if(semprod < 0){
 1de:	a1 28 10 00 00       	mov    0x1028,%eax
 1e3:	85 c0                	test   %eax,%eax
 1e5:	79 19                	jns    200 <main+0xba>
        printf(1,"invalid semprod \n");
 1e7:	c7 44 24 04 e0 0c 00 	movl   $0xce0,0x4(%esp)
 1ee:	00 
 1ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f6:	e8 43 06 00 00       	call   83e <printf>
        exit();
 1fb:	e8 6e 04 00 00       	call   66e <exit>
      }
    
      // create consumer semaphore
      semcom = semget(-1,0); // full
 200:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 207:	00 
 208:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 20f:	e8 1a 05 00 00       	call   72e <semget>
 214:	a3 34 10 00 00       	mov    %eax,0x1034
      if(semcom < 0){
 219:	a1 34 10 00 00       	mov    0x1034,%eax
 21e:	85 c0                	test   %eax,%eax
 220:	79 19                	jns    23b <main+0xf5>
        printf(1,"invalid semcom\n");
 222:	c7 44 24 04 f2 0c 00 	movl   $0xcf2,0x4(%esp)
 229:	00 
 22a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 231:	e8 08 06 00 00       	call   83e <printf>
        exit();
 236:	e8 33 04 00 00       	call   66e <exit>
      }
    
      // create buffer semaphore
      sembuff = semget(-1,1); // mutex
 23b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 242:	00 
 243:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 24a:	e8 df 04 00 00       	call   72e <semget>
 24f:	a3 2c 10 00 00       	mov    %eax,0x102c
      if(sembuff < 0){
 254:	a1 2c 10 00 00       	mov    0x102c,%eax
 259:	85 c0                	test   %eax,%eax
 25b:	79 19                	jns    276 <main+0x130>
        printf(1,"invalid sembuff\n");
 25d:	c7 44 24 04 02 0d 00 	movl   $0xd02,0x4(%esp)
 264:	00 
 265:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26c:	e8 cd 05 00 00       	call   83e <printf>
        exit();
 271:	e8 f8 03 00 00       	call   66e <exit>
    for (i = 0; i < NUMSEM; i++) {
 276:	ff 44 24 2c          	incl   0x2c(%esp)
 27a:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
 27f:	0f 8e 40 ff ff ff    	jle    1c5 <main+0x7f>
      }
  }

  for (i = 0; i < PRODUCERS; i++) {
 285:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 28c:	00 
 28d:	e9 98 00 00 00       	jmp    32a <main+0x1e4>
    // create producer process
    pid_prod = fork();
 292:	e8 cf 03 00 00       	call   666 <fork>
 297:	89 44 24 24          	mov    %eax,0x24(%esp)
    if(pid_prod < 0){
 29b:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 2a0:	79 19                	jns    2bb <main+0x175>
      printf(1,"can't create producer process\n");
 2a2:	c7 44 24 04 14 0d 00 	movl   $0xd14,0x4(%esp)
 2a9:	00 
 2aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b1:	e8 88 05 00 00       	call   83e <printf>
      exit(); 
 2b6:	e8 b3 03 00 00       	call   66e <exit>
    }
    // launch producer process
    if(pid_prod == 0){ // hijo
 2bb:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 2c0:	75 64                	jne    326 <main+0x1e0>
      shm_get(k, &mem);
 2c2:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 2c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ca:	8b 44 24 28          	mov    0x28(%esp),%eax
 2ce:	89 04 24             	mov    %eax,(%esp)
 2d1:	e8 88 04 00 00       	call   75e <shm_get>
      semget(semprod,0);
 2d6:	a1 28 10 00 00       	mov    0x1028,%eax
 2db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e2:	00 
 2e3:	89 04 24             	mov    %eax,(%esp)
 2e6:	e8 43 04 00 00       	call   72e <semget>
      semget(semcom,0);
 2eb:	a1 34 10 00 00       	mov    0x1034,%eax
 2f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2f7:	00 
 2f8:	89 04 24             	mov    %eax,(%esp)
 2fb:	e8 2e 04 00 00       	call   72e <semget>
      semget(sembuff,0);
 300:	a1 2c 10 00 00       	mov    0x102c,%eax
 305:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 30c:	00 
 30d:	89 04 24             	mov    %eax,(%esp)
 310:	e8 19 04 00 00       	call   72e <semget>
      produce(mem);
 315:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 319:	89 04 24             	mov    %eax,(%esp)
 31c:	e8 df fc ff ff       	call   0 <produce>
      exit();
 321:	e8 48 03 00 00       	call   66e <exit>
  for (i = 0; i < PRODUCERS; i++) {
 326:	ff 44 24 2c          	incl   0x2c(%esp)
 32a:	83 7c 24 2c 03       	cmpl   $0x3,0x2c(%esp)
 32f:	0f 8e 5d ff ff ff    	jle    292 <main+0x14c>
    }
  }

  for (i = 0; i < CONSUMERS; i++) {
 335:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 33c:	00 
 33d:	e9 98 00 00 00       	jmp    3da <main+0x294>
    // create consumer process
    pid_com = fork();
 342:	e8 1f 03 00 00       	call   666 <fork>
 347:	89 44 24 20          	mov    %eax,0x20(%esp)
    if(pid_com < 0){
 34b:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
 350:	79 19                	jns    36b <main+0x225>
      printf(1,"can't create consumer process\n");
 352:	c7 44 24 04 34 0d 00 	movl   $0xd34,0x4(%esp)
 359:	00 
 35a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 361:	e8 d8 04 00 00       	call   83e <printf>
      exit(); 
 366:	e8 03 03 00 00       	call   66e <exit>
    }
    // launch consumer process
    if(pid_com == 0){ // hijo
 36b:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
 370:	75 64                	jne    3d6 <main+0x290>
      shm_get(k, &mem);
 372:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 376:	89 44 24 04          	mov    %eax,0x4(%esp)
 37a:	8b 44 24 28          	mov    0x28(%esp),%eax
 37e:	89 04 24             	mov    %eax,(%esp)
 381:	e8 d8 03 00 00       	call   75e <shm_get>
      semget(semprod,0);
 386:	a1 28 10 00 00       	mov    0x1028,%eax
 38b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 392:	00 
 393:	89 04 24             	mov    %eax,(%esp)
 396:	e8 93 03 00 00       	call   72e <semget>
      semget(semcom,0);
 39b:	a1 34 10 00 00       	mov    0x1034,%eax
 3a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3a7:	00 
 3a8:	89 04 24             	mov    %eax,(%esp)
 3ab:	e8 7e 03 00 00       	call   72e <semget>
      semget(sembuff,0);
 3b0:	a1 2c 10 00 00       	mov    0x102c,%eax
 3b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3bc:	00 
 3bd:	89 04 24             	mov    %eax,(%esp)
 3c0:	e8 69 03 00 00       	call   72e <semget>
      consume(mem);
 3c5:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 3c9:	89 04 24             	mov    %eax,(%esp)
 3cc:	e8 d2 fc ff ff       	call   a3 <consume>
      exit();
 3d1:	e8 98 02 00 00       	call   66e <exit>
  for (i = 0; i < CONSUMERS; i++) {
 3d6:	ff 44 24 2c          	incl   0x2c(%esp)
 3da:	83 7c 24 2c 01       	cmpl   $0x1,0x2c(%esp)
 3df:	0f 8e 5d ff ff ff    	jle    342 <main+0x1fc>
    }
  }

  for (i = 0; i < PRODUCERS + CONSUMERS; i++) { // espero 6 wait
 3e5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 3ec:	00 
 3ed:	eb 09                	jmp    3f8 <main+0x2b2>
    wait();
 3ef:	e8 82 02 00 00       	call   676 <wait>
  for (i = 0; i < PRODUCERS + CONSUMERS; i++) { // espero 6 wait
 3f4:	ff 44 24 2c          	incl   0x2c(%esp)
 3f8:	83 7c 24 2c 05       	cmpl   $0x5,0x2c(%esp)
 3fd:	7e f0                	jle    3ef <main+0x2a9>
  }
   
  printf(1,"-------------------------- VALOR FINAL: [%x]  \n", *mem);
 3ff:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 403:	8a 00                	mov    (%eax),%al
 405:	0f be c0             	movsbl %al,%eax
 408:	89 44 24 08          	mov    %eax,0x8(%esp)
 40c:	c7 44 24 04 54 0d 00 	movl   $0xd54,0x4(%esp)
 413:	00 
 414:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 41b:	e8 1e 04 00 00       	call   83e <printf>
  exit();
 420:	e8 49 02 00 00       	call   66e <exit>

00000425 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	57                   	push   %edi
 429:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 42a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 42d:	8b 55 10             	mov    0x10(%ebp),%edx
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	89 cb                	mov    %ecx,%ebx
 435:	89 df                	mov    %ebx,%edi
 437:	89 d1                	mov    %edx,%ecx
 439:	fc                   	cld    
 43a:	f3 aa                	rep stos %al,%es:(%edi)
 43c:	89 ca                	mov    %ecx,%edx
 43e:	89 fb                	mov    %edi,%ebx
 440:	89 5d 08             	mov    %ebx,0x8(%ebp)
 443:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 446:	5b                   	pop    %ebx
 447:	5f                   	pop    %edi
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    

0000044a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 456:	90                   	nop
 457:	8b 45 0c             	mov    0xc(%ebp),%eax
 45a:	8a 10                	mov    (%eax),%dl
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	88 10                	mov    %dl,(%eax)
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	8a 00                	mov    (%eax),%al
 466:	84 c0                	test   %al,%al
 468:	0f 95 c0             	setne  %al
 46b:	ff 45 08             	incl   0x8(%ebp)
 46e:	ff 45 0c             	incl   0xc(%ebp)
 471:	84 c0                	test   %al,%al
 473:	75 e2                	jne    457 <strcpy+0xd>
    ;
  return os;
 475:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 478:	c9                   	leave  
 479:	c3                   	ret    

0000047a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 47d:	eb 06                	jmp    485 <strcmp+0xb>
    p++, q++;
 47f:	ff 45 08             	incl   0x8(%ebp)
 482:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	8a 00                	mov    (%eax),%al
 48a:	84 c0                	test   %al,%al
 48c:	74 0e                	je     49c <strcmp+0x22>
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	8a 10                	mov    (%eax),%dl
 493:	8b 45 0c             	mov    0xc(%ebp),%eax
 496:	8a 00                	mov    (%eax),%al
 498:	38 c2                	cmp    %al,%dl
 49a:	74 e3                	je     47f <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	8a 00                	mov    (%eax),%al
 4a1:	0f b6 d0             	movzbl %al,%edx
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	8a 00                	mov    (%eax),%al
 4a9:	0f b6 c0             	movzbl %al,%eax
 4ac:	89 d1                	mov    %edx,%ecx
 4ae:	29 c1                	sub    %eax,%ecx
 4b0:	89 c8                	mov    %ecx,%eax
}
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    

000004b4 <strlen>:

uint
strlen(char *s)
{
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4c1:	eb 03                	jmp    4c6 <strlen+0x12>
 4c3:	ff 45 fc             	incl   -0x4(%ebp)
 4c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	8a 00                	mov    (%eax),%al
 4d0:	84 c0                	test   %al,%al
 4d2:	75 ef                	jne    4c3 <strlen+0xf>
    ;
  return n;
 4d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d7:	c9                   	leave  
 4d8:	c3                   	ret    

000004d9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 4d9:	55                   	push   %ebp
 4da:	89 e5                	mov    %esp,%ebp
 4dc:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 4df:	8b 45 10             	mov    0x10(%ebp),%eax
 4e2:	89 44 24 08          	mov    %eax,0x8(%esp)
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
 4f0:	89 04 24             	mov    %eax,(%esp)
 4f3:	e8 2d ff ff ff       	call   425 <stosb>
  return dst;
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fb:	c9                   	leave  
 4fc:	c3                   	ret    

000004fd <strchr>:

char*
strchr(const char *s, char c)
{
 4fd:	55                   	push   %ebp
 4fe:	89 e5                	mov    %esp,%ebp
 500:	83 ec 04             	sub    $0x4,%esp
 503:	8b 45 0c             	mov    0xc(%ebp),%eax
 506:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 509:	eb 12                	jmp    51d <strchr+0x20>
    if(*s == c)
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	8a 00                	mov    (%eax),%al
 510:	3a 45 fc             	cmp    -0x4(%ebp),%al
 513:	75 05                	jne    51a <strchr+0x1d>
      return (char*)s;
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	eb 11                	jmp    52b <strchr+0x2e>
  for(; *s; s++)
 51a:	ff 45 08             	incl   0x8(%ebp)
 51d:	8b 45 08             	mov    0x8(%ebp),%eax
 520:	8a 00                	mov    (%eax),%al
 522:	84 c0                	test   %al,%al
 524:	75 e5                	jne    50b <strchr+0xe>
  return 0;
 526:	b8 00 00 00 00       	mov    $0x0,%eax
}
 52b:	c9                   	leave  
 52c:	c3                   	ret    

0000052d <gets>:

char*
gets(char *buf, int max)
{
 52d:	55                   	push   %ebp
 52e:	89 e5                	mov    %esp,%ebp
 530:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 533:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 53a:	eb 42                	jmp    57e <gets+0x51>
    cc = read(0, &c, 1);
 53c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 543:	00 
 544:	8d 45 ef             	lea    -0x11(%ebp),%eax
 547:	89 44 24 04          	mov    %eax,0x4(%esp)
 54b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 552:	e8 2f 01 00 00       	call   686 <read>
 557:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 55a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55e:	7e 29                	jle    589 <gets+0x5c>
      break;
    buf[i++] = c;
 560:	8b 55 f4             	mov    -0xc(%ebp),%edx
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	01 c2                	add    %eax,%edx
 568:	8a 45 ef             	mov    -0x11(%ebp),%al
 56b:	88 02                	mov    %al,(%edx)
 56d:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 570:	8a 45 ef             	mov    -0x11(%ebp),%al
 573:	3c 0a                	cmp    $0xa,%al
 575:	74 13                	je     58a <gets+0x5d>
 577:	8a 45 ef             	mov    -0x11(%ebp),%al
 57a:	3c 0d                	cmp    $0xd,%al
 57c:	74 0c                	je     58a <gets+0x5d>
  for(i=0; i+1 < max; ){
 57e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 581:	40                   	inc    %eax
 582:	3b 45 0c             	cmp    0xc(%ebp),%eax
 585:	7c b5                	jl     53c <gets+0xf>
 587:	eb 01                	jmp    58a <gets+0x5d>
      break;
 589:	90                   	nop
      break;
  }
  buf[i] = '\0';
 58a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	01 d0                	add    %edx,%eax
 592:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 595:	8b 45 08             	mov    0x8(%ebp),%eax
}
 598:	c9                   	leave  
 599:	c3                   	ret    

0000059a <stat>:

int
stat(char *n, struct stat *st)
{
 59a:	55                   	push   %ebp
 59b:	89 e5                	mov    %esp,%ebp
 59d:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5a7:	00 
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 fb 00 00 00       	call   6ae <open>
 5b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ba:	79 07                	jns    5c3 <stat+0x29>
    return -1;
 5bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5c1:	eb 23                	jmp    5e6 <stat+0x4c>
  r = fstat(fd, st);
 5c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 f1 00 00 00       	call   6c6 <fstat>
 5d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	89 04 24             	mov    %eax,(%esp)
 5de:	e8 b3 00 00 00       	call   696 <close>
  return r;
 5e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 5e6:	c9                   	leave  
 5e7:	c3                   	ret    

000005e8 <atoi>:

int
atoi(const char *s)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 5ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5f5:	eb 21                	jmp    618 <atoi+0x30>
    n = n*10 + *s++ - '0';
 5f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5fa:	89 d0                	mov    %edx,%eax
 5fc:	c1 e0 02             	shl    $0x2,%eax
 5ff:	01 d0                	add    %edx,%eax
 601:	d1 e0                	shl    %eax
 603:	89 c2                	mov    %eax,%edx
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	8a 00                	mov    (%eax),%al
 60a:	0f be c0             	movsbl %al,%eax
 60d:	01 d0                	add    %edx,%eax
 60f:	83 e8 30             	sub    $0x30,%eax
 612:	89 45 fc             	mov    %eax,-0x4(%ebp)
 615:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	8a 00                	mov    (%eax),%al
 61d:	3c 2f                	cmp    $0x2f,%al
 61f:	7e 09                	jle    62a <atoi+0x42>
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	8a 00                	mov    (%eax),%al
 626:	3c 39                	cmp    $0x39,%al
 628:	7e cd                	jle    5f7 <atoi+0xf>
  return n;
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 62d:	c9                   	leave  
 62e:	c3                   	ret    

0000062f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 635:	8b 45 08             	mov    0x8(%ebp),%eax
 638:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 63b:	8b 45 0c             	mov    0xc(%ebp),%eax
 63e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 641:	eb 10                	jmp    653 <memmove+0x24>
    *dst++ = *src++;
 643:	8b 45 f8             	mov    -0x8(%ebp),%eax
 646:	8a 10                	mov    (%eax),%dl
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	88 10                	mov    %dl,(%eax)
 64d:	ff 45 fc             	incl   -0x4(%ebp)
 650:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 653:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 657:	0f 9f c0             	setg   %al
 65a:	ff 4d 10             	decl   0x10(%ebp)
 65d:	84 c0                	test   %al,%al
 65f:	75 e2                	jne    643 <memmove+0x14>
  return vdst;
 661:	8b 45 08             	mov    0x8(%ebp),%eax
}
 664:	c9                   	leave  
 665:	c3                   	ret    

00000666 <fork>:
 666:	b8 01 00 00 00       	mov    $0x1,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <exit>:
 66e:	b8 02 00 00 00       	mov    $0x2,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <wait>:
 676:	b8 03 00 00 00       	mov    $0x3,%eax
 67b:	cd 40                	int    $0x40
 67d:	c3                   	ret    

0000067e <pipe>:
 67e:	b8 04 00 00 00       	mov    $0x4,%eax
 683:	cd 40                	int    $0x40
 685:	c3                   	ret    

00000686 <read>:
 686:	b8 05 00 00 00       	mov    $0x5,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <write>:
 68e:	b8 10 00 00 00       	mov    $0x10,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <close>:
 696:	b8 15 00 00 00       	mov    $0x15,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <kill>:
 69e:	b8 06 00 00 00       	mov    $0x6,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <exec>:
 6a6:	b8 07 00 00 00       	mov    $0x7,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <open>:
 6ae:	b8 0f 00 00 00       	mov    $0xf,%eax
 6b3:	cd 40                	int    $0x40
 6b5:	c3                   	ret    

000006b6 <mknod>:
 6b6:	b8 11 00 00 00       	mov    $0x11,%eax
 6bb:	cd 40                	int    $0x40
 6bd:	c3                   	ret    

000006be <unlink>:
 6be:	b8 12 00 00 00       	mov    $0x12,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <fstat>:
 6c6:	b8 08 00 00 00       	mov    $0x8,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <link>:
 6ce:	b8 13 00 00 00       	mov    $0x13,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <mkdir>:
 6d6:	b8 14 00 00 00       	mov    $0x14,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <chdir>:
 6de:	b8 09 00 00 00       	mov    $0x9,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <dup>:
 6e6:	b8 0a 00 00 00       	mov    $0xa,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <getpid>:
 6ee:	b8 0b 00 00 00       	mov    $0xb,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <sbrk>:
 6f6:	b8 0c 00 00 00       	mov    $0xc,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <sleep>:
 6fe:	b8 0d 00 00 00       	mov    $0xd,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <uptime>:
 706:	b8 0e 00 00 00       	mov    $0xe,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <lseek>:
 70e:	b8 16 00 00 00       	mov    $0x16,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <isatty>:
 716:	b8 17 00 00 00       	mov    $0x17,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <procstat>:
 71e:	b8 18 00 00 00       	mov    $0x18,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <set_priority>:
 726:	b8 19 00 00 00       	mov    $0x19,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <semget>:
 72e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 733:	cd 40                	int    $0x40
 735:	c3                   	ret    

00000736 <semfree>:
 736:	b8 1b 00 00 00       	mov    $0x1b,%eax
 73b:	cd 40                	int    $0x40
 73d:	c3                   	ret    

0000073e <semdown>:
 73e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 743:	cd 40                	int    $0x40
 745:	c3                   	ret    

00000746 <semup>:
 746:	b8 1d 00 00 00       	mov    $0x1d,%eax
 74b:	cd 40                	int    $0x40
 74d:	c3                   	ret    

0000074e <shm_create>:
 74e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 753:	cd 40                	int    $0x40
 755:	c3                   	ret    

00000756 <shm_close>:
 756:	b8 1f 00 00 00       	mov    $0x1f,%eax
 75b:	cd 40                	int    $0x40
 75d:	c3                   	ret    

0000075e <shm_get>:
 75e:	b8 20 00 00 00       	mov    $0x20,%eax
 763:	cd 40                	int    $0x40
 765:	c3                   	ret    

00000766 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	83 ec 28             	sub    $0x28,%esp
 76c:	8b 45 0c             	mov    0xc(%ebp),%eax
 76f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 772:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 779:	00 
 77a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 77d:	89 44 24 04          	mov    %eax,0x4(%esp)
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	89 04 24             	mov    %eax,(%esp)
 787:	e8 02 ff ff ff       	call   68e <write>
}
 78c:	c9                   	leave  
 78d:	c3                   	ret    

0000078e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 78e:	55                   	push   %ebp
 78f:	89 e5                	mov    %esp,%ebp
 791:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 79b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 79f:	74 17                	je     7b8 <printint+0x2a>
 7a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7a5:	79 11                	jns    7b8 <printint+0x2a>
    neg = 1;
 7a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b1:	f7 d8                	neg    %eax
 7b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7b6:	eb 06                	jmp    7be <printint+0x30>
  } else {
    x = xx;
 7b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cb:	ba 00 00 00 00       	mov    $0x0,%edx
 7d0:	f7 f1                	div    %ecx
 7d2:	89 d0                	mov    %edx,%eax
 7d4:	8a 80 08 10 00 00    	mov    0x1008(%eax),%al
 7da:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 7dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7e0:	01 ca                	add    %ecx,%edx
 7e2:	88 02                	mov    %al,(%edx)
 7e4:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 7e7:	8b 55 10             	mov    0x10(%ebp),%edx
 7ea:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 7ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f0:	ba 00 00 00 00       	mov    $0x0,%edx
 7f5:	f7 75 d4             	divl   -0x2c(%ebp)
 7f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ff:	75 c4                	jne    7c5 <printint+0x37>
  if(neg)
 801:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 805:	74 2c                	je     833 <printint+0xa5>
    buf[i++] = '-';
 807:	8d 55 dc             	lea    -0x24(%ebp),%edx
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	01 d0                	add    %edx,%eax
 80f:	c6 00 2d             	movb   $0x2d,(%eax)
 812:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 815:	eb 1c                	jmp    833 <printint+0xa5>
    putc(fd, buf[i]);
 817:	8d 55 dc             	lea    -0x24(%ebp),%edx
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	01 d0                	add    %edx,%eax
 81f:	8a 00                	mov    (%eax),%al
 821:	0f be c0             	movsbl %al,%eax
 824:	89 44 24 04          	mov    %eax,0x4(%esp)
 828:	8b 45 08             	mov    0x8(%ebp),%eax
 82b:	89 04 24             	mov    %eax,(%esp)
 82e:	e8 33 ff ff ff       	call   766 <putc>
  while(--i >= 0)
 833:	ff 4d f4             	decl   -0xc(%ebp)
 836:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83a:	79 db                	jns    817 <printint+0x89>
}
 83c:	c9                   	leave  
 83d:	c3                   	ret    

0000083e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 83e:	55                   	push   %ebp
 83f:	89 e5                	mov    %esp,%ebp
 841:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 844:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 84b:	8d 45 0c             	lea    0xc(%ebp),%eax
 84e:	83 c0 04             	add    $0x4,%eax
 851:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 854:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 85b:	e9 78 01 00 00       	jmp    9d8 <printf+0x19a>
    c = fmt[i] & 0xff;
 860:	8b 55 0c             	mov    0xc(%ebp),%edx
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	01 d0                	add    %edx,%eax
 868:	8a 00                	mov    (%eax),%al
 86a:	0f be c0             	movsbl %al,%eax
 86d:	25 ff 00 00 00       	and    $0xff,%eax
 872:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 875:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 879:	75 2c                	jne    8a7 <printf+0x69>
      if(c == '%'){
 87b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 87f:	75 0c                	jne    88d <printf+0x4f>
        state = '%';
 881:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 888:	e9 48 01 00 00       	jmp    9d5 <printf+0x197>
      } else {
        putc(fd, c);
 88d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 890:	0f be c0             	movsbl %al,%eax
 893:	89 44 24 04          	mov    %eax,0x4(%esp)
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	89 04 24             	mov    %eax,(%esp)
 89d:	e8 c4 fe ff ff       	call   766 <putc>
 8a2:	e9 2e 01 00 00       	jmp    9d5 <printf+0x197>
      }
    } else if(state == '%'){
 8a7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8ab:	0f 85 24 01 00 00    	jne    9d5 <printf+0x197>
      if(c == 'd'){
 8b1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8b5:	75 2d                	jne    8e4 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 8b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ba:	8b 00                	mov    (%eax),%eax
 8bc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8c3:	00 
 8c4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8cb:	00 
 8cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d0:	8b 45 08             	mov    0x8(%ebp),%eax
 8d3:	89 04 24             	mov    %eax,(%esp)
 8d6:	e8 b3 fe ff ff       	call   78e <printint>
        ap++;
 8db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8df:	e9 ea 00 00 00       	jmp    9ce <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 8e4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8e8:	74 06                	je     8f0 <printf+0xb2>
 8ea:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8ee:	75 2d                	jne    91d <printf+0xdf>
        printint(fd, *ap, 16, 0);
 8f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8f3:	8b 00                	mov    (%eax),%eax
 8f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8fc:	00 
 8fd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 904:	00 
 905:	89 44 24 04          	mov    %eax,0x4(%esp)
 909:	8b 45 08             	mov    0x8(%ebp),%eax
 90c:	89 04 24             	mov    %eax,(%esp)
 90f:	e8 7a fe ff ff       	call   78e <printint>
        ap++;
 914:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 918:	e9 b1 00 00 00       	jmp    9ce <printf+0x190>
      } else if(c == 's'){
 91d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 921:	75 43                	jne    966 <printf+0x128>
        s = (char*)*ap;
 923:	8b 45 e8             	mov    -0x18(%ebp),%eax
 926:	8b 00                	mov    (%eax),%eax
 928:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 92b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 92f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 933:	75 25                	jne    95a <printf+0x11c>
          s = "(null)";
 935:	c7 45 f4 84 0d 00 00 	movl   $0xd84,-0xc(%ebp)
        while(*s != 0){
 93c:	eb 1c                	jmp    95a <printf+0x11c>
          putc(fd, *s);
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8a 00                	mov    (%eax),%al
 943:	0f be c0             	movsbl %al,%eax
 946:	89 44 24 04          	mov    %eax,0x4(%esp)
 94a:	8b 45 08             	mov    0x8(%ebp),%eax
 94d:	89 04 24             	mov    %eax,(%esp)
 950:	e8 11 fe ff ff       	call   766 <putc>
          s++;
 955:	ff 45 f4             	incl   -0xc(%ebp)
 958:	eb 01                	jmp    95b <printf+0x11d>
        while(*s != 0){
 95a:	90                   	nop
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8a 00                	mov    (%eax),%al
 960:	84 c0                	test   %al,%al
 962:	75 da                	jne    93e <printf+0x100>
 964:	eb 68                	jmp    9ce <printf+0x190>
        }
      } else if(c == 'c'){
 966:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 96a:	75 1d                	jne    989 <printf+0x14b>
        putc(fd, *ap);
 96c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 96f:	8b 00                	mov    (%eax),%eax
 971:	0f be c0             	movsbl %al,%eax
 974:	89 44 24 04          	mov    %eax,0x4(%esp)
 978:	8b 45 08             	mov    0x8(%ebp),%eax
 97b:	89 04 24             	mov    %eax,(%esp)
 97e:	e8 e3 fd ff ff       	call   766 <putc>
        ap++;
 983:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 987:	eb 45                	jmp    9ce <printf+0x190>
      } else if(c == '%'){
 989:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 98d:	75 17                	jne    9a6 <printf+0x168>
        putc(fd, c);
 98f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 992:	0f be c0             	movsbl %al,%eax
 995:	89 44 24 04          	mov    %eax,0x4(%esp)
 999:	8b 45 08             	mov    0x8(%ebp),%eax
 99c:	89 04 24             	mov    %eax,(%esp)
 99f:	e8 c2 fd ff ff       	call   766 <putc>
 9a4:	eb 28                	jmp    9ce <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9a6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9ad:	00 
 9ae:	8b 45 08             	mov    0x8(%ebp),%eax
 9b1:	89 04 24             	mov    %eax,(%esp)
 9b4:	e8 ad fd ff ff       	call   766 <putc>
        putc(fd, c);
 9b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9bc:	0f be c0             	movsbl %al,%eax
 9bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c3:	8b 45 08             	mov    0x8(%ebp),%eax
 9c6:	89 04 24             	mov    %eax,(%esp)
 9c9:	e8 98 fd ff ff       	call   766 <putc>
      }
      state = 0;
 9ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 9d5:	ff 45 f0             	incl   -0x10(%ebp)
 9d8:	8b 55 0c             	mov    0xc(%ebp),%edx
 9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9de:	01 d0                	add    %edx,%eax
 9e0:	8a 00                	mov    (%eax),%al
 9e2:	84 c0                	test   %al,%al
 9e4:	0f 85 76 fe ff ff    	jne    860 <printf+0x22>
    }
  }
}
 9ea:	c9                   	leave  
 9eb:	c3                   	ret    

000009ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ec:	55                   	push   %ebp
 9ed:	89 e5                	mov    %esp,%ebp
 9ef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f2:	8b 45 08             	mov    0x8(%ebp),%eax
 9f5:	83 e8 08             	sub    $0x8,%eax
 9f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fb:	a1 24 10 00 00       	mov    0x1024,%eax
 a00:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a03:	eb 24                	jmp    a29 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	8b 00                	mov    (%eax),%eax
 a0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a0d:	77 12                	ja     a21 <free+0x35>
 a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a12:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a15:	77 24                	ja     a3b <free+0x4f>
 a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1a:	8b 00                	mov    (%eax),%eax
 a1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a1f:	77 1a                	ja     a3b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a24:	8b 00                	mov    (%eax),%eax
 a26:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a2f:	76 d4                	jbe    a05 <free+0x19>
 a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a34:	8b 00                	mov    (%eax),%eax
 a36:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a39:	76 ca                	jbe    a05 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3e:	8b 40 04             	mov    0x4(%eax),%eax
 a41:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a48:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4b:	01 c2                	add    %eax,%edx
 a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a50:	8b 00                	mov    (%eax),%eax
 a52:	39 c2                	cmp    %eax,%edx
 a54:	75 24                	jne    a7a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a59:	8b 50 04             	mov    0x4(%eax),%edx
 a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5f:	8b 00                	mov    (%eax),%eax
 a61:	8b 40 04             	mov    0x4(%eax),%eax
 a64:	01 c2                	add    %eax,%edx
 a66:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a69:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6f:	8b 00                	mov    (%eax),%eax
 a71:	8b 10                	mov    (%eax),%edx
 a73:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a76:	89 10                	mov    %edx,(%eax)
 a78:	eb 0a                	jmp    a84 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7d:	8b 10                	mov    (%eax),%edx
 a7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a82:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a87:	8b 40 04             	mov    0x4(%eax),%eax
 a8a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a91:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a94:	01 d0                	add    %edx,%eax
 a96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a99:	75 20                	jne    abb <free+0xcf>
    p->s.size += bp->s.size;
 a9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9e:	8b 50 04             	mov    0x4(%eax),%edx
 aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa4:	8b 40 04             	mov    0x4(%eax),%eax
 aa7:	01 c2                	add    %eax,%edx
 aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 aaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab2:	8b 10                	mov    (%eax),%edx
 ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab7:	89 10                	mov    %edx,(%eax)
 ab9:	eb 08                	jmp    ac3 <free+0xd7>
  } else
    p->s.ptr = bp;
 abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ac1:	89 10                	mov    %edx,(%eax)
  freep = p;
 ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac6:	a3 24 10 00 00       	mov    %eax,0x1024
}
 acb:	c9                   	leave  
 acc:	c3                   	ret    

00000acd <morecore>:

static Header*
morecore(uint nu)
{
 acd:	55                   	push   %ebp
 ace:	89 e5                	mov    %esp,%ebp
 ad0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ad3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ada:	77 07                	ja     ae3 <morecore+0x16>
    nu = 4096;
 adc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ae3:	8b 45 08             	mov    0x8(%ebp),%eax
 ae6:	c1 e0 03             	shl    $0x3,%eax
 ae9:	89 04 24             	mov    %eax,(%esp)
 aec:	e8 05 fc ff ff       	call   6f6 <sbrk>
 af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 af4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 af8:	75 07                	jne    b01 <morecore+0x34>
    return 0;
 afa:	b8 00 00 00 00       	mov    $0x0,%eax
 aff:	eb 22                	jmp    b23 <morecore+0x56>
  hp = (Header*)p;
 b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0a:	8b 55 08             	mov    0x8(%ebp),%edx
 b0d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b13:	83 c0 08             	add    $0x8,%eax
 b16:	89 04 24             	mov    %eax,(%esp)
 b19:	e8 ce fe ff ff       	call   9ec <free>
  return freep;
 b1e:	a1 24 10 00 00       	mov    0x1024,%eax
}
 b23:	c9                   	leave  
 b24:	c3                   	ret    

00000b25 <malloc>:

void*
malloc(uint nbytes)
{
 b25:	55                   	push   %ebp
 b26:	89 e5                	mov    %esp,%ebp
 b28:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b2b:	8b 45 08             	mov    0x8(%ebp),%eax
 b2e:	83 c0 07             	add    $0x7,%eax
 b31:	c1 e8 03             	shr    $0x3,%eax
 b34:	40                   	inc    %eax
 b35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b38:	a1 24 10 00 00       	mov    0x1024,%eax
 b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b44:	75 23                	jne    b69 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 b46:	c7 45 f0 1c 10 00 00 	movl   $0x101c,-0x10(%ebp)
 b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b50:	a3 24 10 00 00       	mov    %eax,0x1024
 b55:	a1 24 10 00 00       	mov    0x1024,%eax
 b5a:	a3 1c 10 00 00       	mov    %eax,0x101c
    base.s.size = 0;
 b5f:	c7 05 20 10 00 00 00 	movl   $0x0,0x1020
 b66:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6c:	8b 00                	mov    (%eax),%eax
 b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b74:	8b 40 04             	mov    0x4(%eax),%eax
 b77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b7a:	72 4d                	jb     bc9 <malloc+0xa4>
      if(p->s.size == nunits)
 b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7f:	8b 40 04             	mov    0x4(%eax),%eax
 b82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b85:	75 0c                	jne    b93 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8a:	8b 10                	mov    (%eax),%edx
 b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8f:	89 10                	mov    %edx,(%eax)
 b91:	eb 26                	jmp    bb9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b96:	8b 40 04             	mov    0x4(%eax),%eax
 b99:	89 c2                	mov    %eax,%edx
 b9b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba7:	8b 40 04             	mov    0x4(%eax),%eax
 baa:	c1 e0 03             	shl    $0x3,%eax
 bad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bb6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bbc:	a3 24 10 00 00       	mov    %eax,0x1024
      return (void*)(p + 1);
 bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc4:	83 c0 08             	add    $0x8,%eax
 bc7:	eb 38                	jmp    c01 <malloc+0xdc>
    }
    if(p == freep)
 bc9:	a1 24 10 00 00       	mov    0x1024,%eax
 bce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bd1:	75 1b                	jne    bee <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bd6:	89 04 24             	mov    %eax,(%esp)
 bd9:	e8 ef fe ff ff       	call   acd <morecore>
 bde:	89 45 f4             	mov    %eax,-0xc(%ebp)
 be1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 be5:	75 07                	jne    bee <malloc+0xc9>
        return 0;
 be7:	b8 00 00 00 00       	mov    $0x0,%eax
 bec:	eb 13                	jmp    c01 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf7:	8b 00                	mov    (%eax),%eax
 bf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 bfc:	e9 70 ff ff ff       	jmp    b71 <malloc+0x4c>
}
 c01:	c9                   	leave  
 c02:	c3                   	ret    
