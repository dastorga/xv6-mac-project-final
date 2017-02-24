
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
   6:	c7 44 24 04 2c 0c 00 	movl   $0xc2c,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 4c 08 00 00       	call   866 <printf>
  int i;
  for(i = 0; i < CONSUMERS; i++){ 
  1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  21:	eb 78                	jmp    9b <produce+0x9b>
    semdown(semprod); // empty
  23:	a1 98 10 00 00       	mov    0x1098,%eax
  28:	89 04 24             	mov    %eax,(%esp)
  2b:	e8 36 07 00 00       	call   766 <semdown>
    semdown(sembuff); // mutex
  30:	a1 9c 10 00 00       	mov    0x109c,%eax
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 29 07 00 00       	call   766 <semdown>
    //  REGION CRITICA
    *memProducer= ((int)*memProducer) + 1;
  3d:	8b 45 08             	mov    0x8(%ebp),%eax
  40:	8a 00                	mov    (%eax),%al
  42:	40                   	inc    %eax
  43:	88 c2                	mov    %al,%dl
  45:	8b 45 08             	mov    0x8(%ebp),%eax
  48:	88 10                	mov    %dl,(%eax)
    // 
    printf(1,"Productor libera, actualizo a [%x]\n", *memProducer);
  4a:	8b 45 08             	mov    0x8(%ebp),%eax
  4d:	8a 00                	mov    (%eax),%al
  4f:	0f be c0             	movsbl %al,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	c7 44 24 04 44 0c 00 	movl   $0xc44,0x4(%esp)
  5d:	00 
  5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  65:	e8 fc 07 00 00       	call   866 <printf>
    semup(sembuff); //mutex
  6a:	a1 9c 10 00 00       	mov    0x109c,%eax
  6f:	89 04 24             	mov    %eax,(%esp)
  72:	e8 f7 06 00 00       	call   76e <semup>
    semup(semcom); // full
  77:	a1 a4 10 00 00       	mov    0x10a4,%eax
  7c:	89 04 24             	mov    %eax,(%esp)
  7f:	e8 ea 06 00 00       	call   76e <semup>
    printf(1,"-- Termina Productor --\n");
  84:	c7 44 24 04 68 0c 00 	movl   $0xc68,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 ce 07 00 00       	call   866 <printf>
  for(i = 0; i < CONSUMERS; i++){ 
  98:	ff 45 f4             	incl   -0xc(%ebp)
  9b:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
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
  a9:	c7 44 24 04 81 0c 00 	movl   $0xc81,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 a9 07 00 00       	call   866 <printf>
  int i;
  for(i = 0; i < PRODUCERS; i++){ 
  bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  c4:	eb 78                	jmp    13e <consume+0x9b>
    //printf(1,"consumer obtiene\n");
    semdown(semcom);
  c6:	a1 a4 10 00 00       	mov    0x10a4,%eax
  cb:	89 04 24             	mov    %eax,(%esp)
  ce:	e8 93 06 00 00       	call   766 <semdown>
    semdown(sembuff);
  d3:	a1 9c 10 00 00       	mov    0x109c,%eax
  d8:	89 04 24             	mov    %eax,(%esp)
  db:	e8 86 06 00 00       	call   766 <semdown>
    // REGION CRITICA
    *memConsumer= ((int)*memConsumer) - 1;
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	8a 00                	mov    (%eax),%al
  e5:	48                   	dec    %eax
  e6:	88 c2                	mov    %al,%dl
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	88 10                	mov    %dl,(%eax)
    // 
    printf(1,"Consumidor libera, actualizo a [%x]\n", *memConsumer);
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 00                	mov    (%eax),%al
  f2:	0f be c0             	movsbl %al,%eax
  f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  f9:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 100:	00 
 101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 108:	e8 59 07 00 00       	call   866 <printf>
    semup(sembuff);
 10d:	a1 9c 10 00 00       	mov    0x109c,%eax
 112:	89 04 24             	mov    %eax,(%esp)
 115:	e8 54 06 00 00       	call   76e <semup>
    semup(semprod);
 11a:	a1 98 10 00 00       	mov    0x1098,%eax
 11f:	89 04 24             	mov    %eax,(%esp)
 122:	e8 47 06 00 00       	call   76e <semup>
    printf(1,"-- Termina Consumidor --\n");
 127:	c7 44 24 04 c1 0c 00 	movl   $0xcc1,0x4(%esp)
 12e:	00 
 12f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 136:	e8 2b 07 00 00       	call   866 <printf>
  for(i = 0; i < PRODUCERS; i++){ 
 13b:	ff 45 f4             	incl   -0xc(%ebp)
 13e:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
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
 157:	e8 1a 06 00 00       	call   776 <shm_create>
 15c:	89 44 24 28          	mov    %eax,0x28(%esp)
  shm_get(k,&mem);  // mapeo el espacio 
 160:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 164:	89 44 24 04          	mov    %eax,0x4(%esp)
 168:	8b 44 24 28          	mov    0x28(%esp),%eax
 16c:	89 04 24             	mov    %eax,(%esp)
 16f:	e8 12 06 00 00       	call   786 <shm_get>
  *mem = (int)8;  // inicialmente con 8 
 174:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 178:	c6 00 08             	movb   $0x8,(%eax)

  int pid_prod, pid_com, i;
  printf(1,"-------------------------- VALOR INICIAL: [%x] \n", *mem);
 17b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	0f be c0             	movsbl %al,%eax
 184:	89 44 24 08          	mov    %eax,0x8(%esp)
 188:	c7 44 24 04 dc 0c 00 	movl   $0xcdc,0x4(%esp)
 18f:	00 
 190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 197:	e8 ca 06 00 00       	call   866 <printf>
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
 19c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 1a3:	00 
 1a4:	c7 44 24 04 0d 0d 00 	movl   $0xd0d,0x4(%esp)
 1ab:	00 
 1ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b3:	e8 ae 06 00 00       	call   866 <printf>
  
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
 1d4:	e8 7d 05 00 00       	call   756 <semget>
 1d9:	a3 98 10 00 00       	mov    %eax,0x1098
      if(semprod < 0){
 1de:	a1 98 10 00 00       	mov    0x1098,%eax
 1e3:	85 c0                	test   %eax,%eax
 1e5:	79 19                	jns    200 <main+0xba>
        printf(1,"invalid semprod \n");
 1e7:	c7 44 24 04 28 0d 00 	movl   $0xd28,0x4(%esp)
 1ee:	00 
 1ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f6:	e8 6b 06 00 00       	call   866 <printf>
        exit();
 1fb:	e8 96 04 00 00       	call   696 <exit>
      }
    
      // create consumer semaphore
      semcom = semget(-1,0); // full
 200:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 207:	00 
 208:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 20f:	e8 42 05 00 00       	call   756 <semget>
 214:	a3 a4 10 00 00       	mov    %eax,0x10a4
      if(semcom < 0){
 219:	a1 a4 10 00 00       	mov    0x10a4,%eax
 21e:	85 c0                	test   %eax,%eax
 220:	79 19                	jns    23b <main+0xf5>
        printf(1,"invalid semcom\n");
 222:	c7 44 24 04 3a 0d 00 	movl   $0xd3a,0x4(%esp)
 229:	00 
 22a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 231:	e8 30 06 00 00       	call   866 <printf>
        exit();
 236:	e8 5b 04 00 00       	call   696 <exit>
      }
    
      // create buffer semaphore
      sembuff = semget(-1,1); // mutex
 23b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 242:	00 
 243:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 24a:	e8 07 05 00 00       	call   756 <semget>
 24f:	a3 9c 10 00 00       	mov    %eax,0x109c
      if(sembuff < 0){
 254:	a1 9c 10 00 00       	mov    0x109c,%eax
 259:	85 c0                	test   %eax,%eax
 25b:	79 19                	jns    276 <main+0x130>
        printf(1,"invalid sembuff\n");
 25d:	c7 44 24 04 4a 0d 00 	movl   $0xd4a,0x4(%esp)
 264:	00 
 265:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26c:	e8 f5 05 00 00       	call   866 <printf>
        exit();
 271:	e8 20 04 00 00       	call   696 <exit>
    for (i = 0; i < NUMSEM; i++) {
 276:	ff 44 24 2c          	incl   0x2c(%esp)
 27a:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
 27f:	0f 8e 40 ff ff ff    	jle    1c5 <main+0x7f>
      }
  }

  for (i = 0; i < PRODUCERS; i++) {
 285:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 28c:	00 
 28d:	e9 ac 00 00 00       	jmp    33e <main+0x1f8>
    // create producer process
    pid_prod = fork();
 292:	e8 f7 03 00 00       	call   68e <fork>
 297:	89 44 24 24          	mov    %eax,0x24(%esp)
    if(pid_prod < 0){
 29b:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 2a0:	79 19                	jns    2bb <main+0x175>
      printf(1,"can't create producer process\n");
 2a2:	c7 44 24 04 5c 0d 00 	movl   $0xd5c,0x4(%esp)
 2a9:	00 
 2aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b1:	e8 b0 05 00 00       	call   866 <printf>
      exit(); 
 2b6:	e8 db 03 00 00       	call   696 <exit>
    }
    // launch producer process
    if(pid_prod == 0){ // hijo
 2bb:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 2c0:	75 78                	jne    33a <main+0x1f4>
      printf(1," # hijo productor\n");
 2c2:	c7 44 24 04 7b 0d 00 	movl   $0xd7b,0x4(%esp)
 2c9:	00 
 2ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2d1:	e8 90 05 00 00       	call   866 <printf>
      shm_get(k, &mem);
 2d6:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 2da:	89 44 24 04          	mov    %eax,0x4(%esp)
 2de:	8b 44 24 28          	mov    0x28(%esp),%eax
 2e2:	89 04 24             	mov    %eax,(%esp)
 2e5:	e8 9c 04 00 00       	call   786 <shm_get>
      semget(semprod,0);
 2ea:	a1 98 10 00 00       	mov    0x1098,%eax
 2ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2f6:	00 
 2f7:	89 04 24             	mov    %eax,(%esp)
 2fa:	e8 57 04 00 00       	call   756 <semget>
      semget(semcom,0);
 2ff:	a1 a4 10 00 00       	mov    0x10a4,%eax
 304:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 30b:	00 
 30c:	89 04 24             	mov    %eax,(%esp)
 30f:	e8 42 04 00 00       	call   756 <semget>
      semget(sembuff,0);
 314:	a1 9c 10 00 00       	mov    0x109c,%eax
 319:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 320:	00 
 321:	89 04 24             	mov    %eax,(%esp)
 324:	e8 2d 04 00 00       	call   756 <semget>
      produce(mem);
 329:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 32d:	89 04 24             	mov    %eax,(%esp)
 330:	e8 cb fc ff ff       	call   0 <produce>
      exit();
 335:	e8 5c 03 00 00       	call   696 <exit>
  for (i = 0; i < PRODUCERS; i++) {
 33a:	ff 44 24 2c          	incl   0x2c(%esp)
 33e:	83 7c 24 2c 03       	cmpl   $0x3,0x2c(%esp)
 343:	0f 8e 49 ff ff ff    	jle    292 <main+0x14c>
    }
  }

  for (i = 0; i < CONSUMERS; i++) {
 349:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 350:	00 
 351:	e9 ac 00 00 00       	jmp    402 <main+0x2bc>
    // create consumer process
    pid_com = fork();
 356:	e8 33 03 00 00       	call   68e <fork>
 35b:	89 44 24 20          	mov    %eax,0x20(%esp)
    if(pid_com < 0){
 35f:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
 364:	79 19                	jns    37f <main+0x239>
      printf(1,"can't create consumer process\n");
 366:	c7 44 24 04 90 0d 00 	movl   $0xd90,0x4(%esp)
 36d:	00 
 36e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 375:	e8 ec 04 00 00       	call   866 <printf>
      exit(); 
 37a:	e8 17 03 00 00       	call   696 <exit>
    }
    // launch consumer process
    if(pid_com == 0){ // hijo
 37f:	83 7c 24 20 00       	cmpl   $0x0,0x20(%esp)
 384:	75 78                	jne    3fe <main+0x2b8>
      printf(1," # hijo consumidor\n");
 386:	c7 44 24 04 af 0d 00 	movl   $0xdaf,0x4(%esp)
 38d:	00 
 38e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 395:	e8 cc 04 00 00       	call   866 <printf>
      shm_get(k, &mem);
 39a:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 39e:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a2:	8b 44 24 28          	mov    0x28(%esp),%eax
 3a6:	89 04 24             	mov    %eax,(%esp)
 3a9:	e8 d8 03 00 00       	call   786 <shm_get>
      semget(semprod,0);
 3ae:	a1 98 10 00 00       	mov    0x1098,%eax
 3b3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3ba:	00 
 3bb:	89 04 24             	mov    %eax,(%esp)
 3be:	e8 93 03 00 00       	call   756 <semget>
      semget(semcom,0);
 3c3:	a1 a4 10 00 00       	mov    0x10a4,%eax
 3c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3cf:	00 
 3d0:	89 04 24             	mov    %eax,(%esp)
 3d3:	e8 7e 03 00 00       	call   756 <semget>
      semget(sembuff,0);
 3d8:	a1 9c 10 00 00       	mov    0x109c,%eax
 3dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3e4:	00 
 3e5:	89 04 24             	mov    %eax,(%esp)
 3e8:	e8 69 03 00 00       	call   756 <semget>
      consume(mem);
 3ed:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 3f1:	89 04 24             	mov    %eax,(%esp)
 3f4:	e8 aa fc ff ff       	call   a3 <consume>
      exit();
 3f9:	e8 98 02 00 00       	call   696 <exit>
  for (i = 0; i < CONSUMERS; i++) {
 3fe:	ff 44 24 2c          	incl   0x2c(%esp)
 402:	83 7c 24 2c 01       	cmpl   $0x1,0x2c(%esp)
 407:	0f 8e 49 ff ff ff    	jle    356 <main+0x210>
    }
  }

  for (i = 0; i < PRODUCERS + CONSUMERS; i++) { // espero 6 wait
 40d:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 414:	00 
 415:	eb 09                	jmp    420 <main+0x2da>
    wait();
 417:	e8 82 02 00 00       	call   69e <wait>
  for (i = 0; i < PRODUCERS + CONSUMERS; i++) { // espero 6 wait
 41c:	ff 44 24 2c          	incl   0x2c(%esp)
 420:	83 7c 24 2c 05       	cmpl   $0x5,0x2c(%esp)
 425:	7e f0                	jle    417 <main+0x2d1>
  }
   
  printf(1,"-------------------------- VALOR FINAL: [%x]  \n", *mem);
 427:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 42b:	8a 00                	mov    (%eax),%al
 42d:	0f be c0             	movsbl %al,%eax
 430:	89 44 24 08          	mov    %eax,0x8(%esp)
 434:	c7 44 24 04 c4 0d 00 	movl   $0xdc4,0x4(%esp)
 43b:	00 
 43c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 443:	e8 1e 04 00 00       	call   866 <printf>
  exit();
 448:	e8 49 02 00 00       	call   696 <exit>

0000044d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	57                   	push   %edi
 451:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 452:	8b 4d 08             	mov    0x8(%ebp),%ecx
 455:	8b 55 10             	mov    0x10(%ebp),%edx
 458:	8b 45 0c             	mov    0xc(%ebp),%eax
 45b:	89 cb                	mov    %ecx,%ebx
 45d:	89 df                	mov    %ebx,%edi
 45f:	89 d1                	mov    %edx,%ecx
 461:	fc                   	cld    
 462:	f3 aa                	rep stos %al,%es:(%edi)
 464:	89 ca                	mov    %ecx,%edx
 466:	89 fb                	mov    %edi,%ebx
 468:	89 5d 08             	mov    %ebx,0x8(%ebp)
 46b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 46e:	5b                   	pop    %ebx
 46f:	5f                   	pop    %edi
 470:	5d                   	pop    %ebp
 471:	c3                   	ret    

00000472 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 472:	55                   	push   %ebp
 473:	89 e5                	mov    %esp,%ebp
 475:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 47e:	90                   	nop
 47f:	8b 45 0c             	mov    0xc(%ebp),%eax
 482:	8a 10                	mov    (%eax),%dl
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	88 10                	mov    %dl,(%eax)
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	8a 00                	mov    (%eax),%al
 48e:	84 c0                	test   %al,%al
 490:	0f 95 c0             	setne  %al
 493:	ff 45 08             	incl   0x8(%ebp)
 496:	ff 45 0c             	incl   0xc(%ebp)
 499:	84 c0                	test   %al,%al
 49b:	75 e2                	jne    47f <strcpy+0xd>
    ;
  return os;
 49d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4a0:	c9                   	leave  
 4a1:	c3                   	ret    

000004a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4a5:	eb 06                	jmp    4ad <strcmp+0xb>
    p++, q++;
 4a7:	ff 45 08             	incl   0x8(%ebp)
 4aa:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	8a 00                	mov    (%eax),%al
 4b2:	84 c0                	test   %al,%al
 4b4:	74 0e                	je     4c4 <strcmp+0x22>
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	8a 10                	mov    (%eax),%dl
 4bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4be:	8a 00                	mov    (%eax),%al
 4c0:	38 c2                	cmp    %al,%dl
 4c2:	74 e3                	je     4a7 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	8a 00                	mov    (%eax),%al
 4c9:	0f b6 d0             	movzbl %al,%edx
 4cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cf:	8a 00                	mov    (%eax),%al
 4d1:	0f b6 c0             	movzbl %al,%eax
 4d4:	89 d1                	mov    %edx,%ecx
 4d6:	29 c1                	sub    %eax,%ecx
 4d8:	89 c8                	mov    %ecx,%eax
}
 4da:	5d                   	pop    %ebp
 4db:	c3                   	ret    

000004dc <strlen>:

uint
strlen(char *s)
{
 4dc:	55                   	push   %ebp
 4dd:	89 e5                	mov    %esp,%ebp
 4df:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4e9:	eb 03                	jmp    4ee <strlen+0x12>
 4eb:	ff 45 fc             	incl   -0x4(%ebp)
 4ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	01 d0                	add    %edx,%eax
 4f6:	8a 00                	mov    (%eax),%al
 4f8:	84 c0                	test   %al,%al
 4fa:	75 ef                	jne    4eb <strlen+0xf>
    ;
  return n;
 4fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ff:	c9                   	leave  
 500:	c3                   	ret    

00000501 <memset>:

void*
memset(void *dst, int c, uint n)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 507:	8b 45 10             	mov    0x10(%ebp),%eax
 50a:	89 44 24 08          	mov    %eax,0x8(%esp)
 50e:	8b 45 0c             	mov    0xc(%ebp),%eax
 511:	89 44 24 04          	mov    %eax,0x4(%esp)
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	89 04 24             	mov    %eax,(%esp)
 51b:	e8 2d ff ff ff       	call   44d <stosb>
  return dst;
 520:	8b 45 08             	mov    0x8(%ebp),%eax
}
 523:	c9                   	leave  
 524:	c3                   	ret    

00000525 <strchr>:

char*
strchr(const char *s, char c)
{
 525:	55                   	push   %ebp
 526:	89 e5                	mov    %esp,%ebp
 528:	83 ec 04             	sub    $0x4,%esp
 52b:	8b 45 0c             	mov    0xc(%ebp),%eax
 52e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 531:	eb 12                	jmp    545 <strchr+0x20>
    if(*s == c)
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	8a 00                	mov    (%eax),%al
 538:	3a 45 fc             	cmp    -0x4(%ebp),%al
 53b:	75 05                	jne    542 <strchr+0x1d>
      return (char*)s;
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	eb 11                	jmp    553 <strchr+0x2e>
  for(; *s; s++)
 542:	ff 45 08             	incl   0x8(%ebp)
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	8a 00                	mov    (%eax),%al
 54a:	84 c0                	test   %al,%al
 54c:	75 e5                	jne    533 <strchr+0xe>
  return 0;
 54e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 553:	c9                   	leave  
 554:	c3                   	ret    

00000555 <gets>:

char*
gets(char *buf, int max)
{
 555:	55                   	push   %ebp
 556:	89 e5                	mov    %esp,%ebp
 558:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 55b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 562:	eb 42                	jmp    5a6 <gets+0x51>
    cc = read(0, &c, 1);
 564:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 56b:	00 
 56c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 56f:	89 44 24 04          	mov    %eax,0x4(%esp)
 573:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 57a:	e8 2f 01 00 00       	call   6ae <read>
 57f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 586:	7e 29                	jle    5b1 <gets+0x5c>
      break;
    buf[i++] = c;
 588:	8b 55 f4             	mov    -0xc(%ebp),%edx
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	01 c2                	add    %eax,%edx
 590:	8a 45 ef             	mov    -0x11(%ebp),%al
 593:	88 02                	mov    %al,(%edx)
 595:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 598:	8a 45 ef             	mov    -0x11(%ebp),%al
 59b:	3c 0a                	cmp    $0xa,%al
 59d:	74 13                	je     5b2 <gets+0x5d>
 59f:	8a 45 ef             	mov    -0x11(%ebp),%al
 5a2:	3c 0d                	cmp    $0xd,%al
 5a4:	74 0c                	je     5b2 <gets+0x5d>
  for(i=0; i+1 < max; ){
 5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a9:	40                   	inc    %eax
 5aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5ad:	7c b5                	jl     564 <gets+0xf>
 5af:	eb 01                	jmp    5b2 <gets+0x5d>
      break;
 5b1:	90                   	nop
      break;
  }
  buf[i] = '\0';
 5b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5b5:	8b 45 08             	mov    0x8(%ebp),%eax
 5b8:	01 d0                	add    %edx,%eax
 5ba:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5c0:	c9                   	leave  
 5c1:	c3                   	ret    

000005c2 <stat>:

int
stat(char *n, struct stat *st)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5cf:	00 
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 fb 00 00 00       	call   6d6 <open>
 5db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 5de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e2:	79 07                	jns    5eb <stat+0x29>
    return -1;
 5e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5e9:	eb 23                	jmp    60e <stat+0x4c>
  r = fstat(fd, st);
 5eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f5:	89 04 24             	mov    %eax,(%esp)
 5f8:	e8 f1 00 00 00       	call   6ee <fstat>
 5fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 600:	8b 45 f4             	mov    -0xc(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 b3 00 00 00       	call   6be <close>
  return r;
 60b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 60e:	c9                   	leave  
 60f:	c3                   	ret    

00000610 <atoi>:

int
atoi(const char *s)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 616:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 61d:	eb 21                	jmp    640 <atoi+0x30>
    n = n*10 + *s++ - '0';
 61f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 622:	89 d0                	mov    %edx,%eax
 624:	c1 e0 02             	shl    $0x2,%eax
 627:	01 d0                	add    %edx,%eax
 629:	d1 e0                	shl    %eax
 62b:	89 c2                	mov    %eax,%edx
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	8a 00                	mov    (%eax),%al
 632:	0f be c0             	movsbl %al,%eax
 635:	01 d0                	add    %edx,%eax
 637:	83 e8 30             	sub    $0x30,%eax
 63a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 63d:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	8a 00                	mov    (%eax),%al
 645:	3c 2f                	cmp    $0x2f,%al
 647:	7e 09                	jle    652 <atoi+0x42>
 649:	8b 45 08             	mov    0x8(%ebp),%eax
 64c:	8a 00                	mov    (%eax),%al
 64e:	3c 39                	cmp    $0x39,%al
 650:	7e cd                	jle    61f <atoi+0xf>
  return n;
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 655:	c9                   	leave  
 656:	c3                   	ret    

00000657 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 663:	8b 45 0c             	mov    0xc(%ebp),%eax
 666:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 669:	eb 10                	jmp    67b <memmove+0x24>
    *dst++ = *src++;
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8a 10                	mov    (%eax),%dl
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	88 10                	mov    %dl,(%eax)
 675:	ff 45 fc             	incl   -0x4(%ebp)
 678:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 67b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 67f:	0f 9f c0             	setg   %al
 682:	ff 4d 10             	decl   0x10(%ebp)
 685:	84 c0                	test   %al,%al
 687:	75 e2                	jne    66b <memmove+0x14>
  return vdst;
 689:	8b 45 08             	mov    0x8(%ebp),%eax
}
 68c:	c9                   	leave  
 68d:	c3                   	ret    

0000068e <fork>:
 68e:	b8 01 00 00 00       	mov    $0x1,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <exit>:
 696:	b8 02 00 00 00       	mov    $0x2,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <wait>:
 69e:	b8 03 00 00 00       	mov    $0x3,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <pipe>:
 6a6:	b8 04 00 00 00       	mov    $0x4,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <read>:
 6ae:	b8 05 00 00 00       	mov    $0x5,%eax
 6b3:	cd 40                	int    $0x40
 6b5:	c3                   	ret    

000006b6 <write>:
 6b6:	b8 10 00 00 00       	mov    $0x10,%eax
 6bb:	cd 40                	int    $0x40
 6bd:	c3                   	ret    

000006be <close>:
 6be:	b8 15 00 00 00       	mov    $0x15,%eax
 6c3:	cd 40                	int    $0x40
 6c5:	c3                   	ret    

000006c6 <kill>:
 6c6:	b8 06 00 00 00       	mov    $0x6,%eax
 6cb:	cd 40                	int    $0x40
 6cd:	c3                   	ret    

000006ce <exec>:
 6ce:	b8 07 00 00 00       	mov    $0x7,%eax
 6d3:	cd 40                	int    $0x40
 6d5:	c3                   	ret    

000006d6 <open>:
 6d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 6db:	cd 40                	int    $0x40
 6dd:	c3                   	ret    

000006de <mknod>:
 6de:	b8 11 00 00 00       	mov    $0x11,%eax
 6e3:	cd 40                	int    $0x40
 6e5:	c3                   	ret    

000006e6 <unlink>:
 6e6:	b8 12 00 00 00       	mov    $0x12,%eax
 6eb:	cd 40                	int    $0x40
 6ed:	c3                   	ret    

000006ee <fstat>:
 6ee:	b8 08 00 00 00       	mov    $0x8,%eax
 6f3:	cd 40                	int    $0x40
 6f5:	c3                   	ret    

000006f6 <link>:
 6f6:	b8 13 00 00 00       	mov    $0x13,%eax
 6fb:	cd 40                	int    $0x40
 6fd:	c3                   	ret    

000006fe <mkdir>:
 6fe:	b8 14 00 00 00       	mov    $0x14,%eax
 703:	cd 40                	int    $0x40
 705:	c3                   	ret    

00000706 <chdir>:
 706:	b8 09 00 00 00       	mov    $0x9,%eax
 70b:	cd 40                	int    $0x40
 70d:	c3                   	ret    

0000070e <dup>:
 70e:	b8 0a 00 00 00       	mov    $0xa,%eax
 713:	cd 40                	int    $0x40
 715:	c3                   	ret    

00000716 <getpid>:
 716:	b8 0b 00 00 00       	mov    $0xb,%eax
 71b:	cd 40                	int    $0x40
 71d:	c3                   	ret    

0000071e <sbrk>:
 71e:	b8 0c 00 00 00       	mov    $0xc,%eax
 723:	cd 40                	int    $0x40
 725:	c3                   	ret    

00000726 <sleep>:
 726:	b8 0d 00 00 00       	mov    $0xd,%eax
 72b:	cd 40                	int    $0x40
 72d:	c3                   	ret    

0000072e <uptime>:
 72e:	b8 0e 00 00 00       	mov    $0xe,%eax
 733:	cd 40                	int    $0x40
 735:	c3                   	ret    

00000736 <lseek>:
 736:	b8 16 00 00 00       	mov    $0x16,%eax
 73b:	cd 40                	int    $0x40
 73d:	c3                   	ret    

0000073e <isatty>:
 73e:	b8 17 00 00 00       	mov    $0x17,%eax
 743:	cd 40                	int    $0x40
 745:	c3                   	ret    

00000746 <procstat>:
 746:	b8 18 00 00 00       	mov    $0x18,%eax
 74b:	cd 40                	int    $0x40
 74d:	c3                   	ret    

0000074e <set_priority>:
 74e:	b8 19 00 00 00       	mov    $0x19,%eax
 753:	cd 40                	int    $0x40
 755:	c3                   	ret    

00000756 <semget>:
 756:	b8 1a 00 00 00       	mov    $0x1a,%eax
 75b:	cd 40                	int    $0x40
 75d:	c3                   	ret    

0000075e <semfree>:
 75e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 763:	cd 40                	int    $0x40
 765:	c3                   	ret    

00000766 <semdown>:
 766:	b8 1c 00 00 00       	mov    $0x1c,%eax
 76b:	cd 40                	int    $0x40
 76d:	c3                   	ret    

0000076e <semup>:
 76e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 773:	cd 40                	int    $0x40
 775:	c3                   	ret    

00000776 <shm_create>:
 776:	b8 1e 00 00 00       	mov    $0x1e,%eax
 77b:	cd 40                	int    $0x40
 77d:	c3                   	ret    

0000077e <shm_close>:
 77e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 783:	cd 40                	int    $0x40
 785:	c3                   	ret    

00000786 <shm_get>:
 786:	b8 20 00 00 00       	mov    $0x20,%eax
 78b:	cd 40                	int    $0x40
 78d:	c3                   	ret    

0000078e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 78e:	55                   	push   %ebp
 78f:	89 e5                	mov    %esp,%ebp
 791:	83 ec 28             	sub    $0x28,%esp
 794:	8b 45 0c             	mov    0xc(%ebp),%eax
 797:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 79a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a1:	00 
 7a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 02 ff ff ff       	call   6b6 <write>
}
 7b4:	c9                   	leave  
 7b5:	c3                   	ret    

000007b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b6:	55                   	push   %ebp
 7b7:	89 e5                	mov    %esp,%ebp
 7b9:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7c7:	74 17                	je     7e0 <printint+0x2a>
 7c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7cd:	79 11                	jns    7e0 <printint+0x2a>
    neg = 1;
 7cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d9:	f7 d8                	neg    %eax
 7db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7de:	eb 06                	jmp    7e6 <printint+0x30>
  } else {
    x = xx;
 7e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
 7f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f3:	ba 00 00 00 00       	mov    $0x0,%edx
 7f8:	f7 f1                	div    %ecx
 7fa:	89 d0                	mov    %edx,%eax
 7fc:	8a 80 78 10 00 00    	mov    0x1078(%eax),%al
 802:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 805:	8b 55 f4             	mov    -0xc(%ebp),%edx
 808:	01 ca                	add    %ecx,%edx
 80a:	88 02                	mov    %al,(%edx)
 80c:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 80f:	8b 55 10             	mov    0x10(%ebp),%edx
 812:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 815:	8b 45 ec             	mov    -0x14(%ebp),%eax
 818:	ba 00 00 00 00       	mov    $0x0,%edx
 81d:	f7 75 d4             	divl   -0x2c(%ebp)
 820:	89 45 ec             	mov    %eax,-0x14(%ebp)
 823:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 827:	75 c4                	jne    7ed <printint+0x37>
  if(neg)
 829:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82d:	74 2c                	je     85b <printint+0xa5>
    buf[i++] = '-';
 82f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	01 d0                	add    %edx,%eax
 837:	c6 00 2d             	movb   $0x2d,(%eax)
 83a:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 83d:	eb 1c                	jmp    85b <printint+0xa5>
    putc(fd, buf[i]);
 83f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	01 d0                	add    %edx,%eax
 847:	8a 00                	mov    (%eax),%al
 849:	0f be c0             	movsbl %al,%eax
 84c:	89 44 24 04          	mov    %eax,0x4(%esp)
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	89 04 24             	mov    %eax,(%esp)
 856:	e8 33 ff ff ff       	call   78e <putc>
  while(--i >= 0)
 85b:	ff 4d f4             	decl   -0xc(%ebp)
 85e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 862:	79 db                	jns    83f <printint+0x89>
}
 864:	c9                   	leave  
 865:	c3                   	ret    

00000866 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 866:	55                   	push   %ebp
 867:	89 e5                	mov    %esp,%ebp
 869:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 86c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 873:	8d 45 0c             	lea    0xc(%ebp),%eax
 876:	83 c0 04             	add    $0x4,%eax
 879:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 87c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 883:	e9 78 01 00 00       	jmp    a00 <printf+0x19a>
    c = fmt[i] & 0xff;
 888:	8b 55 0c             	mov    0xc(%ebp),%edx
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	01 d0                	add    %edx,%eax
 890:	8a 00                	mov    (%eax),%al
 892:	0f be c0             	movsbl %al,%eax
 895:	25 ff 00 00 00       	and    $0xff,%eax
 89a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 89d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8a1:	75 2c                	jne    8cf <printf+0x69>
      if(c == '%'){
 8a3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8a7:	75 0c                	jne    8b5 <printf+0x4f>
        state = '%';
 8a9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8b0:	e9 48 01 00 00       	jmp    9fd <printf+0x197>
      } else {
        putc(fd, c);
 8b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b8:	0f be c0             	movsbl %al,%eax
 8bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bf:	8b 45 08             	mov    0x8(%ebp),%eax
 8c2:	89 04 24             	mov    %eax,(%esp)
 8c5:	e8 c4 fe ff ff       	call   78e <putc>
 8ca:	e9 2e 01 00 00       	jmp    9fd <printf+0x197>
      }
    } else if(state == '%'){
 8cf:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8d3:	0f 85 24 01 00 00    	jne    9fd <printf+0x197>
      if(c == 'd'){
 8d9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8dd:	75 2d                	jne    90c <printf+0xa6>
        printint(fd, *ap, 10, 1);
 8df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8eb:	00 
 8ec:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8f3:	00 
 8f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f8:	8b 45 08             	mov    0x8(%ebp),%eax
 8fb:	89 04 24             	mov    %eax,(%esp)
 8fe:	e8 b3 fe ff ff       	call   7b6 <printint>
        ap++;
 903:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 907:	e9 ea 00 00 00       	jmp    9f6 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 90c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 910:	74 06                	je     918 <printf+0xb2>
 912:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 916:	75 2d                	jne    945 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 918:	8b 45 e8             	mov    -0x18(%ebp),%eax
 91b:	8b 00                	mov    (%eax),%eax
 91d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 924:	00 
 925:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 92c:	00 
 92d:	89 44 24 04          	mov    %eax,0x4(%esp)
 931:	8b 45 08             	mov    0x8(%ebp),%eax
 934:	89 04 24             	mov    %eax,(%esp)
 937:	e8 7a fe ff ff       	call   7b6 <printint>
        ap++;
 93c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 940:	e9 b1 00 00 00       	jmp    9f6 <printf+0x190>
      } else if(c == 's'){
 945:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 949:	75 43                	jne    98e <printf+0x128>
        s = (char*)*ap;
 94b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 953:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 957:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95b:	75 25                	jne    982 <printf+0x11c>
          s = "(null)";
 95d:	c7 45 f4 f4 0d 00 00 	movl   $0xdf4,-0xc(%ebp)
        while(*s != 0){
 964:	eb 1c                	jmp    982 <printf+0x11c>
          putc(fd, *s);
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	8a 00                	mov    (%eax),%al
 96b:	0f be c0             	movsbl %al,%eax
 96e:	89 44 24 04          	mov    %eax,0x4(%esp)
 972:	8b 45 08             	mov    0x8(%ebp),%eax
 975:	89 04 24             	mov    %eax,(%esp)
 978:	e8 11 fe ff ff       	call   78e <putc>
          s++;
 97d:	ff 45 f4             	incl   -0xc(%ebp)
 980:	eb 01                	jmp    983 <printf+0x11d>
        while(*s != 0){
 982:	90                   	nop
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	8a 00                	mov    (%eax),%al
 988:	84 c0                	test   %al,%al
 98a:	75 da                	jne    966 <printf+0x100>
 98c:	eb 68                	jmp    9f6 <printf+0x190>
        }
      } else if(c == 'c'){
 98e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 992:	75 1d                	jne    9b1 <printf+0x14b>
        putc(fd, *ap);
 994:	8b 45 e8             	mov    -0x18(%ebp),%eax
 997:	8b 00                	mov    (%eax),%eax
 999:	0f be c0             	movsbl %al,%eax
 99c:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a0:	8b 45 08             	mov    0x8(%ebp),%eax
 9a3:	89 04 24             	mov    %eax,(%esp)
 9a6:	e8 e3 fd ff ff       	call   78e <putc>
        ap++;
 9ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9af:	eb 45                	jmp    9f6 <printf+0x190>
      } else if(c == '%'){
 9b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9b5:	75 17                	jne    9ce <printf+0x168>
        putc(fd, c);
 9b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ba:	0f be c0             	movsbl %al,%eax
 9bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c1:	8b 45 08             	mov    0x8(%ebp),%eax
 9c4:	89 04 24             	mov    %eax,(%esp)
 9c7:	e8 c2 fd ff ff       	call   78e <putc>
 9cc:	eb 28                	jmp    9f6 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9ce:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9d5:	00 
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	89 04 24             	mov    %eax,(%esp)
 9dc:	e8 ad fd ff ff       	call   78e <putc>
        putc(fd, c);
 9e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9e4:	0f be c0             	movsbl %al,%eax
 9e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	89 04 24             	mov    %eax,(%esp)
 9f1:	e8 98 fd ff ff       	call   78e <putc>
      }
      state = 0;
 9f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 9fd:	ff 45 f0             	incl   -0x10(%ebp)
 a00:	8b 55 0c             	mov    0xc(%ebp),%edx
 a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a06:	01 d0                	add    %edx,%eax
 a08:	8a 00                	mov    (%eax),%al
 a0a:	84 c0                	test   %al,%al
 a0c:	0f 85 76 fe ff ff    	jne    888 <printf+0x22>
    }
  }
}
 a12:	c9                   	leave  
 a13:	c3                   	ret    

00000a14 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a14:	55                   	push   %ebp
 a15:	89 e5                	mov    %esp,%ebp
 a17:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a1a:	8b 45 08             	mov    0x8(%ebp),%eax
 a1d:	83 e8 08             	sub    $0x8,%eax
 a20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a23:	a1 94 10 00 00       	mov    0x1094,%eax
 a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a2b:	eb 24                	jmp    a51 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a30:	8b 00                	mov    (%eax),%eax
 a32:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a35:	77 12                	ja     a49 <free+0x35>
 a37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a3d:	77 24                	ja     a63 <free+0x4f>
 a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a42:	8b 00                	mov    (%eax),%eax
 a44:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a47:	77 1a                	ja     a63 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4c:	8b 00                	mov    (%eax),%eax
 a4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a51:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a54:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a57:	76 d4                	jbe    a2d <free+0x19>
 a59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5c:	8b 00                	mov    (%eax),%eax
 a5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a61:	76 ca                	jbe    a2d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a63:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a66:	8b 40 04             	mov    0x4(%eax),%eax
 a69:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a70:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a73:	01 c2                	add    %eax,%edx
 a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a78:	8b 00                	mov    (%eax),%eax
 a7a:	39 c2                	cmp    %eax,%edx
 a7c:	75 24                	jne    aa2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a81:	8b 50 04             	mov    0x4(%eax),%edx
 a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a87:	8b 00                	mov    (%eax),%eax
 a89:	8b 40 04             	mov    0x4(%eax),%eax
 a8c:	01 c2                	add    %eax,%edx
 a8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a91:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a97:	8b 00                	mov    (%eax),%eax
 a99:	8b 10                	mov    (%eax),%edx
 a9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a9e:	89 10                	mov    %edx,(%eax)
 aa0:	eb 0a                	jmp    aac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 aa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa5:	8b 10                	mov    (%eax),%edx
 aa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 aac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aaf:	8b 40 04             	mov    0x4(%eax),%eax
 ab2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abc:	01 d0                	add    %edx,%eax
 abe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ac1:	75 20                	jne    ae3 <free+0xcf>
    p->s.size += bp->s.size;
 ac3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac6:	8b 50 04             	mov    0x4(%eax),%edx
 ac9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 acc:	8b 40 04             	mov    0x4(%eax),%eax
 acf:	01 c2                	add    %eax,%edx
 ad1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ad7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ada:	8b 10                	mov    (%eax),%edx
 adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adf:	89 10                	mov    %edx,(%eax)
 ae1:	eb 08                	jmp    aeb <free+0xd7>
  } else
    p->s.ptr = bp;
 ae3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ae9:	89 10                	mov    %edx,(%eax)
  freep = p;
 aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aee:	a3 94 10 00 00       	mov    %eax,0x1094
}
 af3:	c9                   	leave  
 af4:	c3                   	ret    

00000af5 <morecore>:

static Header*
morecore(uint nu)
{
 af5:	55                   	push   %ebp
 af6:	89 e5                	mov    %esp,%ebp
 af8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 afb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b02:	77 07                	ja     b0b <morecore+0x16>
    nu = 4096;
 b04:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b0b:	8b 45 08             	mov    0x8(%ebp),%eax
 b0e:	c1 e0 03             	shl    $0x3,%eax
 b11:	89 04 24             	mov    %eax,(%esp)
 b14:	e8 05 fc ff ff       	call   71e <sbrk>
 b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b1c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b20:	75 07                	jne    b29 <morecore+0x34>
    return 0;
 b22:	b8 00 00 00 00       	mov    $0x0,%eax
 b27:	eb 22                	jmp    b4b <morecore+0x56>
  hp = (Header*)p;
 b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b32:	8b 55 08             	mov    0x8(%ebp),%edx
 b35:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b3b:	83 c0 08             	add    $0x8,%eax
 b3e:	89 04 24             	mov    %eax,(%esp)
 b41:	e8 ce fe ff ff       	call   a14 <free>
  return freep;
 b46:	a1 94 10 00 00       	mov    0x1094,%eax
}
 b4b:	c9                   	leave  
 b4c:	c3                   	ret    

00000b4d <malloc>:

void*
malloc(uint nbytes)
{
 b4d:	55                   	push   %ebp
 b4e:	89 e5                	mov    %esp,%ebp
 b50:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b53:	8b 45 08             	mov    0x8(%ebp),%eax
 b56:	83 c0 07             	add    $0x7,%eax
 b59:	c1 e8 03             	shr    $0x3,%eax
 b5c:	40                   	inc    %eax
 b5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b60:	a1 94 10 00 00       	mov    0x1094,%eax
 b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b6c:	75 23                	jne    b91 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 b6e:	c7 45 f0 8c 10 00 00 	movl   $0x108c,-0x10(%ebp)
 b75:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b78:	a3 94 10 00 00       	mov    %eax,0x1094
 b7d:	a1 94 10 00 00       	mov    0x1094,%eax
 b82:	a3 8c 10 00 00       	mov    %eax,0x108c
    base.s.size = 0;
 b87:	c7 05 90 10 00 00 00 	movl   $0x0,0x1090
 b8e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b94:	8b 00                	mov    (%eax),%eax
 b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9c:	8b 40 04             	mov    0x4(%eax),%eax
 b9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ba2:	72 4d                	jb     bf1 <malloc+0xa4>
      if(p->s.size == nunits)
 ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba7:	8b 40 04             	mov    0x4(%eax),%eax
 baa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bad:	75 0c                	jne    bbb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb2:	8b 10                	mov    (%eax),%edx
 bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb7:	89 10                	mov    %edx,(%eax)
 bb9:	eb 26                	jmp    be1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbe:	8b 40 04             	mov    0x4(%eax),%eax
 bc1:	89 c2                	mov    %eax,%edx
 bc3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bcf:	8b 40 04             	mov    0x4(%eax),%eax
 bd2:	c1 e0 03             	shl    $0x3,%eax
 bd5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bde:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be4:	a3 94 10 00 00       	mov    %eax,0x1094
      return (void*)(p + 1);
 be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bec:	83 c0 08             	add    $0x8,%eax
 bef:	eb 38                	jmp    c29 <malloc+0xdc>
    }
    if(p == freep)
 bf1:	a1 94 10 00 00       	mov    0x1094,%eax
 bf6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bf9:	75 1b                	jne    c16 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bfe:	89 04 24             	mov    %eax,(%esp)
 c01:	e8 ef fe ff ff       	call   af5 <morecore>
 c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c0d:	75 07                	jne    c16 <malloc+0xc9>
        return 0;
 c0f:	b8 00 00 00 00       	mov    $0x0,%eax
 c14:	eb 13                	jmp    c29 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1f:	8b 00                	mov    (%eax),%eax
 c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 c24:	e9 70 ff ff ff       	jmp    b99 <malloc+0x4c>
}
 c29:	c9                   	leave  
 c2a:	c3                   	ret    
