
_semaphore-test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <productor>:
int semcom;
int sembuff;

void
productor( char* memProducer)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  printf(1,"-- Inicia Productor --\n");
   6:	c7 44 24 04 b0 0b 00 	movl   $0xbb0,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 d1 07 00 00       	call   7eb <printf>
  int i;
  for(i = 0; i < PRODUCERS; i++){ 
  1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  21:	eb 78                	jmp    9b <productor+0x9b>
    semdown(semprod); // empty
  23:	a1 1c 10 00 00       	mov    0x101c,%eax
  28:	89 04 24             	mov    %eax,(%esp)
  2b:	e8 bb 06 00 00       	call   6eb <semdown>
    semdown(sembuff); // mutex
  30:	a1 20 10 00 00       	mov    0x1020,%eax
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 ae 06 00 00       	call   6eb <semdown>
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
  56:	c7 44 24 04 c8 0b 00 	movl   $0xbc8,0x4(%esp)
  5d:	00 
  5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  65:	e8 81 07 00 00       	call   7eb <printf>
    semup(sembuff); //mutex
  6a:	a1 20 10 00 00       	mov    0x1020,%eax
  6f:	89 04 24             	mov    %eax,(%esp)
  72:	e8 7c 06 00 00       	call   6f3 <semup>
    semup(semcom); // full
  77:	a1 28 10 00 00       	mov    0x1028,%eax
  7c:	89 04 24             	mov    %eax,(%esp)
  7f:	e8 6f 06 00 00       	call   6f3 <semup>
    printf(1,"-- Termina Productor --\n");
  84:	c7 44 24 04 ec 0b 00 	movl   $0xbec,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 53 07 00 00       	call   7eb <printf>
  for(i = 0; i < PRODUCERS; i++){ 
  98:	ff 45 f4             	incl   -0xc(%ebp)
  9b:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  9f:	7e 82                	jle    23 <productor+0x23>
  }
}
  a1:	c9                   	leave  
  a2:	c3                   	ret    

000000a3 <consumidor>:

void
consumidor(char* memConsumer)
{ 
  a3:	55                   	push   %ebp
  a4:	89 e5                	mov    %esp,%ebp
  a6:	83 ec 28             	sub    $0x28,%esp
  printf(1,"-- Inicia Consumidor --\n");
  a9:	c7 44 24 04 05 0c 00 	movl   $0xc05,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 2e 07 00 00       	call   7eb <printf>
  int i;
  for(i = 0; i < CONSUMERS; i++){
  bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  c4:	eb 78                	jmp    13e <consumidor+0x9b>
    semdown(semcom); // full
  c6:	a1 28 10 00 00       	mov    0x1028,%eax
  cb:	89 04 24             	mov    %eax,(%esp)
  ce:	e8 18 06 00 00       	call   6eb <semdown>
    semdown(sembuff); // mutex
  d3:	a1 20 10 00 00       	mov    0x1020,%eax
  d8:	89 04 24             	mov    %eax,(%esp)
  db:	e8 0b 06 00 00       	call   6eb <semdown>
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
  f9:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
 100:	00 
 101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 108:	e8 de 06 00 00       	call   7eb <printf>
    semup(sembuff); // mutex
 10d:	a1 20 10 00 00       	mov    0x1020,%eax
 112:	89 04 24             	mov    %eax,(%esp)
 115:	e8 d9 05 00 00       	call   6f3 <semup>
    semup(semprod); // empty
 11a:	a1 1c 10 00 00       	mov    0x101c,%eax
 11f:	89 04 24             	mov    %eax,(%esp)
 122:	e8 cc 05 00 00       	call   6f3 <semup>
    printf(1,"-- Termina Consumidor --\n");
 127:	c7 44 24 04 45 0c 00 	movl   $0xc45,0x4(%esp)
 12e:	00 
 12f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 136:	e8 b0 06 00 00       	call   7eb <printf>
  for(i = 0; i < CONSUMERS; i++){
 13b:	ff 45 f4             	incl   -0xc(%ebp)
 13e:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
 142:	7e 82                	jle    c6 <consumidor+0x23>
  }
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <main>:

int
main(void)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 e4 f0             	and    $0xfffffff0,%esp
 14c:	83 ec 20             	sub    $0x20,%esp


  char* mem= 0;
 14f:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
 156:	00 
  *mem = (int)8;   // inicio con 8
 157:	8b 44 24 18          	mov    0x18(%esp),%eax
 15b:	c6 00 08             	movb   $0x8,(%eax)
  int pid_productor, pid_consumidor, i;

  printf(1,"-------------------------- VALOR INICIAL: [%x] \n", *mem);
 15e:	8b 44 24 18          	mov    0x18(%esp),%eax
 162:	8a 00                	mov    (%eax),%al
 164:	0f be c0             	movsbl %al,%eax
 167:	89 44 24 08          	mov    %eax,0x8(%esp)
 16b:	c7 44 24 04 60 0c 00 	movl   $0xc60,0x4(%esp)
 172:	00 
 173:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17a:	e8 6c 06 00 00       	call   7eb <printf>
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
 17f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 186:	00 
 187:	c7 44 24 04 91 0c 00 	movl   $0xc91,0x4(%esp)
 18e:	00 
 18f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 196:	e8 50 06 00 00       	call   7eb <printf>
  
  // creo semaforo productor
  semprod = semget(-1,BUFF_SIZE); // empty
 19b:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 1a2:	00 
 1a3:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1aa:	e8 2c 05 00 00       	call   6db <semget>
 1af:	a3 1c 10 00 00       	mov    %eax,0x101c
  if(semprod < 0){
 1b4:	a1 1c 10 00 00       	mov    0x101c,%eax
 1b9:	85 c0                	test   %eax,%eax
 1bb:	79 19                	jns    1d6 <main+0x90>
    printf(1,"invalid semprod \n");
 1bd:	c7 44 24 04 ac 0c 00 	movl   $0xcac,0x4(%esp)
 1c4:	00 
 1c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1cc:	e8 1a 06 00 00       	call   7eb <printf>
    exit();
 1d1:	e8 45 04 00 00       	call   61b <exit>
  }
  // creo semaforo consumidor 
  semcom = semget(-1,0); // full
 1d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1dd:	00 
 1de:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1e5:	e8 f1 04 00 00       	call   6db <semget>
 1ea:	a3 28 10 00 00       	mov    %eax,0x1028
  if(semcom < 0){
 1ef:	a1 28 10 00 00       	mov    0x1028,%eax
 1f4:	85 c0                	test   %eax,%eax
 1f6:	79 19                	jns    211 <main+0xcb>
    printf(1,"invalid semcom\n");
 1f8:	c7 44 24 04 be 0c 00 	movl   $0xcbe,0x4(%esp)
 1ff:	00 
 200:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 207:	e8 df 05 00 00       	call   7eb <printf>
    exit();
 20c:	e8 0a 04 00 00       	call   61b <exit>
  }
  // creo semaforo buffer 
  sembuff = semget(-1,1); // mutex
 211:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 218:	00 
 219:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 220:	e8 b6 04 00 00       	call   6db <semget>
 225:	a3 20 10 00 00       	mov    %eax,0x1020
  if(sembuff < 0){
 22a:	a1 20 10 00 00       	mov    0x1020,%eax
 22f:	85 c0                	test   %eax,%eax
 231:	79 19                	jns    24c <main+0x106>
    printf(1,"invalid sembuff\n");
 233:	c7 44 24 04 ce 0c 00 	movl   $0xcce,0x4(%esp)
 23a:	00 
 23b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 242:	e8 a4 05 00 00       	call   7eb <printf>
    exit();
 247:	e8 cf 03 00 00       	call   61b <exit>
  }

  for (i = 0; i < PRODUCERS; i++) { 
 24c:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 253:	00 
 254:	e9 98 00 00 00       	jmp    2f1 <main+0x1ab>
    // create producer process
    pid_productor = fork();
 259:	e8 b5 03 00 00       	call   613 <fork>
 25e:	89 44 24 14          	mov    %eax,0x14(%esp)
    if(pid_productor < 0){
 262:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 267:	79 19                	jns    282 <main+0x13c>
      printf(1,"can't create producer process\n");
 269:	c7 44 24 04 e0 0c 00 	movl   $0xce0,0x4(%esp)
 270:	00 
 271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 278:	e8 6e 05 00 00       	call   7eb <printf>
      exit(); 
 27d:	e8 99 03 00 00       	call   61b <exit>
    }
    // launch producer process
    if(pid_productor == 0){ // hijo
 282:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 287:	75 64                	jne    2ed <main+0x1a7>
      printf(1," # hijo productor\n");
 289:	c7 44 24 04 ff 0c 00 	movl   $0xcff,0x4(%esp)
 290:	00 
 291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 298:	e8 4e 05 00 00       	call   7eb <printf>
      semget(semprod,0);
 29d:	a1 1c 10 00 00       	mov    0x101c,%eax
 2a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a9:	00 
 2aa:	89 04 24             	mov    %eax,(%esp)
 2ad:	e8 29 04 00 00       	call   6db <semget>
      semget(semcom,0);
 2b2:	a1 28 10 00 00       	mov    0x1028,%eax
 2b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2be:	00 
 2bf:	89 04 24             	mov    %eax,(%esp)
 2c2:	e8 14 04 00 00       	call   6db <semget>
      semget(sembuff,0);
 2c7:	a1 20 10 00 00       	mov    0x1020,%eax
 2cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d3:	00 
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 ff 03 00 00       	call   6db <semget>
      productor(mem);
 2dc:	8b 44 24 18          	mov    0x18(%esp),%eax
 2e0:	89 04 24             	mov    %eax,(%esp)
 2e3:	e8 18 fd ff ff       	call   0 <productor>
      exit();
 2e8:	e8 2e 03 00 00       	call   61b <exit>
  for (i = 0; i < PRODUCERS; i++) { 
 2ed:	ff 44 24 1c          	incl   0x1c(%esp)
 2f1:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
 2f6:	0f 8e 5d ff ff ff    	jle    259 <main+0x113>
    }
  }

  for (i = 0; i < CONSUMERS; i++) { 
 2fc:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 303:	00 
 304:	e9 98 00 00 00       	jmp    3a1 <main+0x25b>
    // create consumer process
    pid_consumidor = fork();
 309:	e8 05 03 00 00       	call   613 <fork>
 30e:	89 44 24 10          	mov    %eax,0x10(%esp)
    if(pid_consumidor < 0){
 312:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
 317:	79 19                	jns    332 <main+0x1ec>
      printf(1,"can't create consumer process\n");
 319:	c7 44 24 04 14 0d 00 	movl   $0xd14,0x4(%esp)
 320:	00 
 321:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 328:	e8 be 04 00 00       	call   7eb <printf>
      exit(); 
 32d:	e8 e9 02 00 00       	call   61b <exit>
    }
    // launch consumer process
    if(pid_consumidor == 0){ // hijo
 332:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
 337:	75 64                	jne    39d <main+0x257>
      printf(1," # hijo consumidor\n");
 339:	c7 44 24 04 33 0d 00 	movl   $0xd33,0x4(%esp)
 340:	00 
 341:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 348:	e8 9e 04 00 00       	call   7eb <printf>
      semget(semprod,0);
 34d:	a1 1c 10 00 00       	mov    0x101c,%eax
 352:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 359:	00 
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 79 03 00 00       	call   6db <semget>
      semget(semcom,0);
 362:	a1 28 10 00 00       	mov    0x1028,%eax
 367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 36e:	00 
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 64 03 00 00       	call   6db <semget>
      semget(sembuff,0);
 377:	a1 20 10 00 00       	mov    0x1020,%eax
 37c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 383:	00 
 384:	89 04 24             	mov    %eax,(%esp)
 387:	e8 4f 03 00 00       	call   6db <semget>
      consumidor(mem);
 38c:	8b 44 24 18          	mov    0x18(%esp),%eax
 390:	89 04 24             	mov    %eax,(%esp)
 393:	e8 0b fd ff ff       	call   a3 <consumidor>
      exit();
 398:	e8 7e 02 00 00       	call   61b <exit>
  for (i = 0; i < CONSUMERS; i++) { 
 39d:	ff 44 24 1c          	incl   0x1c(%esp)
 3a1:	83 7c 24 1c 01       	cmpl   $0x1,0x1c(%esp)
 3a6:	0f 8e 5d ff ff ff    	jle    309 <main+0x1c3>
    }
  }

  printf(1,"-------------------------- VALOR FINAL: [%x]  \n", *mem);
 3ac:	8b 44 24 18          	mov    0x18(%esp),%eax
 3b0:	8a 00                	mov    (%eax),%al
 3b2:	0f be c0             	movsbl %al,%eax
 3b5:	89 44 24 08          	mov    %eax,0x8(%esp)
 3b9:	c7 44 24 04 48 0d 00 	movl   $0xd48,0x4(%esp)
 3c0:	00 
 3c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c8:	e8 1e 04 00 00       	call   7eb <printf>
  exit();
 3cd:	e8 49 02 00 00       	call   61b <exit>

000003d2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	57                   	push   %edi
 3d6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3da:	8b 55 10             	mov    0x10(%ebp),%edx
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	89 cb                	mov    %ecx,%ebx
 3e2:	89 df                	mov    %ebx,%edi
 3e4:	89 d1                	mov    %edx,%ecx
 3e6:	fc                   	cld    
 3e7:	f3 aa                	rep stos %al,%es:(%edi)
 3e9:	89 ca                	mov    %ecx,%edx
 3eb:	89 fb                	mov    %edi,%ebx
 3ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3f0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3f3:	5b                   	pop    %ebx
 3f4:	5f                   	pop    %edi
 3f5:	5d                   	pop    %ebp
 3f6:	c3                   	ret    

000003f7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3f7:	55                   	push   %ebp
 3f8:	89 e5                	mov    %esp,%ebp
 3fa:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 403:	90                   	nop
 404:	8b 45 0c             	mov    0xc(%ebp),%eax
 407:	8a 10                	mov    (%eax),%dl
 409:	8b 45 08             	mov    0x8(%ebp),%eax
 40c:	88 10                	mov    %dl,(%eax)
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	8a 00                	mov    (%eax),%al
 413:	84 c0                	test   %al,%al
 415:	0f 95 c0             	setne  %al
 418:	ff 45 08             	incl   0x8(%ebp)
 41b:	ff 45 0c             	incl   0xc(%ebp)
 41e:	84 c0                	test   %al,%al
 420:	75 e2                	jne    404 <strcpy+0xd>
    ;
  return os;
 422:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 425:	c9                   	leave  
 426:	c3                   	ret    

00000427 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 427:	55                   	push   %ebp
 428:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 42a:	eb 06                	jmp    432 <strcmp+0xb>
    p++, q++;
 42c:	ff 45 08             	incl   0x8(%ebp)
 42f:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	8a 00                	mov    (%eax),%al
 437:	84 c0                	test   %al,%al
 439:	74 0e                	je     449 <strcmp+0x22>
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	8a 10                	mov    (%eax),%dl
 440:	8b 45 0c             	mov    0xc(%ebp),%eax
 443:	8a 00                	mov    (%eax),%al
 445:	38 c2                	cmp    %al,%dl
 447:	74 e3                	je     42c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	8a 00                	mov    (%eax),%al
 44e:	0f b6 d0             	movzbl %al,%edx
 451:	8b 45 0c             	mov    0xc(%ebp),%eax
 454:	8a 00                	mov    (%eax),%al
 456:	0f b6 c0             	movzbl %al,%eax
 459:	89 d1                	mov    %edx,%ecx
 45b:	29 c1                	sub    %eax,%ecx
 45d:	89 c8                	mov    %ecx,%eax
}
 45f:	5d                   	pop    %ebp
 460:	c3                   	ret    

00000461 <strlen>:

uint
strlen(char *s)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 467:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 46e:	eb 03                	jmp    473 <strlen+0x12>
 470:	ff 45 fc             	incl   -0x4(%ebp)
 473:	8b 55 fc             	mov    -0x4(%ebp),%edx
 476:	8b 45 08             	mov    0x8(%ebp),%eax
 479:	01 d0                	add    %edx,%eax
 47b:	8a 00                	mov    (%eax),%al
 47d:	84 c0                	test   %al,%al
 47f:	75 ef                	jne    470 <strlen+0xf>
    ;
  return n;
 481:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 484:	c9                   	leave  
 485:	c3                   	ret    

00000486 <memset>:

void*
memset(void *dst, int c, uint n)
{
 486:	55                   	push   %ebp
 487:	89 e5                	mov    %esp,%ebp
 489:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 48c:	8b 45 10             	mov    0x10(%ebp),%eax
 48f:	89 44 24 08          	mov    %eax,0x8(%esp)
 493:	8b 45 0c             	mov    0xc(%ebp),%eax
 496:	89 44 24 04          	mov    %eax,0x4(%esp)
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	89 04 24             	mov    %eax,(%esp)
 4a0:	e8 2d ff ff ff       	call   3d2 <stosb>
  return dst;
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a8:	c9                   	leave  
 4a9:	c3                   	ret    

000004aa <strchr>:

char*
strchr(const char *s, char c)
{
 4aa:	55                   	push   %ebp
 4ab:	89 e5                	mov    %esp,%ebp
 4ad:	83 ec 04             	sub    $0x4,%esp
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4b6:	eb 12                	jmp    4ca <strchr+0x20>
    if(*s == c)
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	8a 00                	mov    (%eax),%al
 4bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4c0:	75 05                	jne    4c7 <strchr+0x1d>
      return (char*)s;
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	eb 11                	jmp    4d8 <strchr+0x2e>
  for(; *s; s++)
 4c7:	ff 45 08             	incl   0x8(%ebp)
 4ca:	8b 45 08             	mov    0x8(%ebp),%eax
 4cd:	8a 00                	mov    (%eax),%al
 4cf:	84 c0                	test   %al,%al
 4d1:	75 e5                	jne    4b8 <strchr+0xe>
  return 0;
 4d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4d8:	c9                   	leave  
 4d9:	c3                   	ret    

000004da <gets>:

char*
gets(char *buf, int max)
{
 4da:	55                   	push   %ebp
 4db:	89 e5                	mov    %esp,%ebp
 4dd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4e7:	eb 42                	jmp    52b <gets+0x51>
    cc = read(0, &c, 1);
 4e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f0:	00 
 4f1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4ff:	e8 2f 01 00 00       	call   633 <read>
 504:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 507:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50b:	7e 29                	jle    536 <gets+0x5c>
      break;
    buf[i++] = c;
 50d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	01 c2                	add    %eax,%edx
 515:	8a 45 ef             	mov    -0x11(%ebp),%al
 518:	88 02                	mov    %al,(%edx)
 51a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 51d:	8a 45 ef             	mov    -0x11(%ebp),%al
 520:	3c 0a                	cmp    $0xa,%al
 522:	74 13                	je     537 <gets+0x5d>
 524:	8a 45 ef             	mov    -0x11(%ebp),%al
 527:	3c 0d                	cmp    $0xd,%al
 529:	74 0c                	je     537 <gets+0x5d>
  for(i=0; i+1 < max; ){
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	40                   	inc    %eax
 52f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 532:	7c b5                	jl     4e9 <gets+0xf>
 534:	eb 01                	jmp    537 <gets+0x5d>
      break;
 536:	90                   	nop
      break;
  }
  buf[i] = '\0';
 537:	8b 55 f4             	mov    -0xc(%ebp),%edx
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	01 d0                	add    %edx,%eax
 53f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 542:	8b 45 08             	mov    0x8(%ebp),%eax
}
 545:	c9                   	leave  
 546:	c3                   	ret    

00000547 <stat>:

int
stat(char *n, struct stat *st)
{
 547:	55                   	push   %ebp
 548:	89 e5                	mov    %esp,%ebp
 54a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 54d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 554:	00 
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	89 04 24             	mov    %eax,(%esp)
 55b:	e8 fb 00 00 00       	call   65b <open>
 560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 563:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 567:	79 07                	jns    570 <stat+0x29>
    return -1;
 569:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 56e:	eb 23                	jmp    593 <stat+0x4c>
  r = fstat(fd, st);
 570:	8b 45 0c             	mov    0xc(%ebp),%eax
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57a:	89 04 24             	mov    %eax,(%esp)
 57d:	e8 f1 00 00 00       	call   673 <fstat>
 582:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 585:	8b 45 f4             	mov    -0xc(%ebp),%eax
 588:	89 04 24             	mov    %eax,(%esp)
 58b:	e8 b3 00 00 00       	call   643 <close>
  return r;
 590:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <atoi>:

int
atoi(const char *s)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 59b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5a2:	eb 21                	jmp    5c5 <atoi+0x30>
    n = n*10 + *s++ - '0';
 5a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5a7:	89 d0                	mov    %edx,%eax
 5a9:	c1 e0 02             	shl    $0x2,%eax
 5ac:	01 d0                	add    %edx,%eax
 5ae:	d1 e0                	shl    %eax
 5b0:	89 c2                	mov    %eax,%edx
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	8a 00                	mov    (%eax),%al
 5b7:	0f be c0             	movsbl %al,%eax
 5ba:	01 d0                	add    %edx,%eax
 5bc:	83 e8 30             	sub    $0x30,%eax
 5bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c2:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	8a 00                	mov    (%eax),%al
 5ca:	3c 2f                	cmp    $0x2f,%al
 5cc:	7e 09                	jle    5d7 <atoi+0x42>
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	8a 00                	mov    (%eax),%al
 5d3:	3c 39                	cmp    $0x39,%al
 5d5:	7e cd                	jle    5a4 <atoi+0xf>
  return n;
 5d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5da:	c9                   	leave  
 5db:	c3                   	ret    

000005dc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5ee:	eb 10                	jmp    600 <memmove+0x24>
    *dst++ = *src++;
 5f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f3:	8a 10                	mov    (%eax),%dl
 5f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f8:	88 10                	mov    %dl,(%eax)
 5fa:	ff 45 fc             	incl   -0x4(%ebp)
 5fd:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 600:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 604:	0f 9f c0             	setg   %al
 607:	ff 4d 10             	decl   0x10(%ebp)
 60a:	84 c0                	test   %al,%al
 60c:	75 e2                	jne    5f0 <memmove+0x14>
  return vdst;
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 611:	c9                   	leave  
 612:	c3                   	ret    

00000613 <fork>:
 613:	b8 01 00 00 00       	mov    $0x1,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <exit>:
 61b:	b8 02 00 00 00       	mov    $0x2,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <wait>:
 623:	b8 03 00 00 00       	mov    $0x3,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <pipe>:
 62b:	b8 04 00 00 00       	mov    $0x4,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <read>:
 633:	b8 05 00 00 00       	mov    $0x5,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <write>:
 63b:	b8 10 00 00 00       	mov    $0x10,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <close>:
 643:	b8 15 00 00 00       	mov    $0x15,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <kill>:
 64b:	b8 06 00 00 00       	mov    $0x6,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <exec>:
 653:	b8 07 00 00 00       	mov    $0x7,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <open>:
 65b:	b8 0f 00 00 00       	mov    $0xf,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <mknod>:
 663:	b8 11 00 00 00       	mov    $0x11,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <unlink>:
 66b:	b8 12 00 00 00       	mov    $0x12,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <fstat>:
 673:	b8 08 00 00 00       	mov    $0x8,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <link>:
 67b:	b8 13 00 00 00       	mov    $0x13,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <mkdir>:
 683:	b8 14 00 00 00       	mov    $0x14,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <chdir>:
 68b:	b8 09 00 00 00       	mov    $0x9,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <dup>:
 693:	b8 0a 00 00 00       	mov    $0xa,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <getpid>:
 69b:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <sbrk>:
 6a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    

000006ab <sleep>:
 6ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b0:	cd 40                	int    $0x40
 6b2:	c3                   	ret    

000006b3 <uptime>:
 6b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 6b8:	cd 40                	int    $0x40
 6ba:	c3                   	ret    

000006bb <lseek>:
 6bb:	b8 16 00 00 00       	mov    $0x16,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret    

000006c3 <isatty>:
 6c3:	b8 17 00 00 00       	mov    $0x17,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret    

000006cb <procstat>:
 6cb:	b8 18 00 00 00       	mov    $0x18,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret    

000006d3 <set_priority>:
 6d3:	b8 19 00 00 00       	mov    $0x19,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret    

000006db <semget>:
 6db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret    

000006e3 <semfree>:
 6e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret    

000006eb <semdown>:
 6eb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret    

000006f3 <semup>:
 6f3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret    

000006fb <shm_create>:
 6fb:	b8 1e 00 00 00       	mov    $0x1e,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret    

00000703 <shm_close>:
 703:	b8 1f 00 00 00       	mov    $0x1f,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret    

0000070b <shm_get>:
 70b:	b8 20 00 00 00       	mov    $0x20,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret    

00000713 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 713:	55                   	push   %ebp
 714:	89 e5                	mov    %esp,%ebp
 716:	83 ec 28             	sub    $0x28,%esp
 719:	8b 45 0c             	mov    0xc(%ebp),%eax
 71c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 71f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 726:	00 
 727:	8d 45 f4             	lea    -0xc(%ebp),%eax
 72a:	89 44 24 04          	mov    %eax,0x4(%esp)
 72e:	8b 45 08             	mov    0x8(%ebp),%eax
 731:	89 04 24             	mov    %eax,(%esp)
 734:	e8 02 ff ff ff       	call   63b <write>
}
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73b:	55                   	push   %ebp
 73c:	89 e5                	mov    %esp,%ebp
 73e:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 741:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 748:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 74c:	74 17                	je     765 <printint+0x2a>
 74e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 752:	79 11                	jns    765 <printint+0x2a>
    neg = 1;
 754:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 75b:	8b 45 0c             	mov    0xc(%ebp),%eax
 75e:	f7 d8                	neg    %eax
 760:	89 45 ec             	mov    %eax,-0x14(%ebp)
 763:	eb 06                	jmp    76b <printint+0x30>
  } else {
    x = xx;
 765:	8b 45 0c             	mov    0xc(%ebp),%eax
 768:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 76b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 772:	8b 4d 10             	mov    0x10(%ebp),%ecx
 775:	8b 45 ec             	mov    -0x14(%ebp),%eax
 778:	ba 00 00 00 00       	mov    $0x0,%edx
 77d:	f7 f1                	div    %ecx
 77f:	89 d0                	mov    %edx,%eax
 781:	8a 80 fc 0f 00 00    	mov    0xffc(%eax),%al
 787:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 78a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 78d:	01 ca                	add    %ecx,%edx
 78f:	88 02                	mov    %al,(%edx)
 791:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 794:	8b 55 10             	mov    0x10(%ebp),%edx
 797:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 79a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79d:	ba 00 00 00 00       	mov    $0x0,%edx
 7a2:	f7 75 d4             	divl   -0x2c(%ebp)
 7a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ac:	75 c4                	jne    772 <printint+0x37>
  if(neg)
 7ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b2:	74 2c                	je     7e0 <printint+0xa5>
    buf[i++] = '-';
 7b4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	01 d0                	add    %edx,%eax
 7bc:	c6 00 2d             	movb   $0x2d,(%eax)
 7bf:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 7c2:	eb 1c                	jmp    7e0 <printint+0xa5>
    putc(fd, buf[i]);
 7c4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	01 d0                	add    %edx,%eax
 7cc:	8a 00                	mov    (%eax),%al
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 33 ff ff ff       	call   713 <putc>
  while(--i >= 0)
 7e0:	ff 4d f4             	decl   -0xc(%ebp)
 7e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e7:	79 db                	jns    7c4 <printint+0x89>
}
 7e9:	c9                   	leave  
 7ea:	c3                   	ret    

000007eb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7f8:	8d 45 0c             	lea    0xc(%ebp),%eax
 7fb:	83 c0 04             	add    $0x4,%eax
 7fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 801:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 808:	e9 78 01 00 00       	jmp    985 <printf+0x19a>
    c = fmt[i] & 0xff;
 80d:	8b 55 0c             	mov    0xc(%ebp),%edx
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	01 d0                	add    %edx,%eax
 815:	8a 00                	mov    (%eax),%al
 817:	0f be c0             	movsbl %al,%eax
 81a:	25 ff 00 00 00       	and    $0xff,%eax
 81f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 826:	75 2c                	jne    854 <printf+0x69>
      if(c == '%'){
 828:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82c:	75 0c                	jne    83a <printf+0x4f>
        state = '%';
 82e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 835:	e9 48 01 00 00       	jmp    982 <printf+0x197>
      } else {
        putc(fd, c);
 83a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 83d:	0f be c0             	movsbl %al,%eax
 840:	89 44 24 04          	mov    %eax,0x4(%esp)
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	89 04 24             	mov    %eax,(%esp)
 84a:	e8 c4 fe ff ff       	call   713 <putc>
 84f:	e9 2e 01 00 00       	jmp    982 <printf+0x197>
      }
    } else if(state == '%'){
 854:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 858:	0f 85 24 01 00 00    	jne    982 <printf+0x197>
      if(c == 'd'){
 85e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 862:	75 2d                	jne    891 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 864:	8b 45 e8             	mov    -0x18(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 870:	00 
 871:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 878:	00 
 879:	89 44 24 04          	mov    %eax,0x4(%esp)
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	89 04 24             	mov    %eax,(%esp)
 883:	e8 b3 fe ff ff       	call   73b <printint>
        ap++;
 888:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 88c:	e9 ea 00 00 00       	jmp    97b <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 891:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 895:	74 06                	je     89d <printf+0xb2>
 897:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 89b:	75 2d                	jne    8ca <printf+0xdf>
        printint(fd, *ap, 16, 0);
 89d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8a9:	00 
 8aa:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8b1:	00 
 8b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b6:	8b 45 08             	mov    0x8(%ebp),%eax
 8b9:	89 04 24             	mov    %eax,(%esp)
 8bc:	e8 7a fe ff ff       	call   73b <printint>
        ap++;
 8c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c5:	e9 b1 00 00 00       	jmp    97b <printf+0x190>
      } else if(c == 's'){
 8ca:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8ce:	75 43                	jne    913 <printf+0x128>
        s = (char*)*ap;
 8d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e0:	75 25                	jne    907 <printf+0x11c>
          s = "(null)";
 8e2:	c7 45 f4 78 0d 00 00 	movl   $0xd78,-0xc(%ebp)
        while(*s != 0){
 8e9:	eb 1c                	jmp    907 <printf+0x11c>
          putc(fd, *s);
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8a 00                	mov    (%eax),%al
 8f0:	0f be c0             	movsbl %al,%eax
 8f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	89 04 24             	mov    %eax,(%esp)
 8fd:	e8 11 fe ff ff       	call   713 <putc>
          s++;
 902:	ff 45 f4             	incl   -0xc(%ebp)
 905:	eb 01                	jmp    908 <printf+0x11d>
        while(*s != 0){
 907:	90                   	nop
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8a 00                	mov    (%eax),%al
 90d:	84 c0                	test   %al,%al
 90f:	75 da                	jne    8eb <printf+0x100>
 911:	eb 68                	jmp    97b <printf+0x190>
        }
      } else if(c == 'c'){
 913:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 917:	75 1d                	jne    936 <printf+0x14b>
        putc(fd, *ap);
 919:	8b 45 e8             	mov    -0x18(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	0f be c0             	movsbl %al,%eax
 921:	89 44 24 04          	mov    %eax,0x4(%esp)
 925:	8b 45 08             	mov    0x8(%ebp),%eax
 928:	89 04 24             	mov    %eax,(%esp)
 92b:	e8 e3 fd ff ff       	call   713 <putc>
        ap++;
 930:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 934:	eb 45                	jmp    97b <printf+0x190>
      } else if(c == '%'){
 936:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 93a:	75 17                	jne    953 <printf+0x168>
        putc(fd, c);
 93c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 93f:	0f be c0             	movsbl %al,%eax
 942:	89 44 24 04          	mov    %eax,0x4(%esp)
 946:	8b 45 08             	mov    0x8(%ebp),%eax
 949:	89 04 24             	mov    %eax,(%esp)
 94c:	e8 c2 fd ff ff       	call   713 <putc>
 951:	eb 28                	jmp    97b <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 953:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 95a:	00 
 95b:	8b 45 08             	mov    0x8(%ebp),%eax
 95e:	89 04 24             	mov    %eax,(%esp)
 961:	e8 ad fd ff ff       	call   713 <putc>
        putc(fd, c);
 966:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 969:	0f be c0             	movsbl %al,%eax
 96c:	89 44 24 04          	mov    %eax,0x4(%esp)
 970:	8b 45 08             	mov    0x8(%ebp),%eax
 973:	89 04 24             	mov    %eax,(%esp)
 976:	e8 98 fd ff ff       	call   713 <putc>
      }
      state = 0;
 97b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 982:	ff 45 f0             	incl   -0x10(%ebp)
 985:	8b 55 0c             	mov    0xc(%ebp),%edx
 988:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98b:	01 d0                	add    %edx,%eax
 98d:	8a 00                	mov    (%eax),%al
 98f:	84 c0                	test   %al,%al
 991:	0f 85 76 fe ff ff    	jne    80d <printf+0x22>
    }
  }
}
 997:	c9                   	leave  
 998:	c3                   	ret    

00000999 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 999:	55                   	push   %ebp
 99a:	89 e5                	mov    %esp,%ebp
 99c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	83 e8 08             	sub    $0x8,%eax
 9a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a8:	a1 18 10 00 00       	mov    0x1018,%eax
 9ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9b0:	eb 24                	jmp    9d6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	8b 00                	mov    (%eax),%eax
 9b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ba:	77 12                	ja     9ce <free+0x35>
 9bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c2:	77 24                	ja     9e8 <free+0x4f>
 9c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c7:	8b 00                	mov    (%eax),%eax
 9c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9cc:	77 1a                	ja     9e8 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d1:	8b 00                	mov    (%eax),%eax
 9d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9dc:	76 d4                	jbe    9b2 <free+0x19>
 9de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e1:	8b 00                	mov    (%eax),%eax
 9e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e6:	76 ca                	jbe    9b2 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9eb:	8b 40 04             	mov    0x4(%eax),%eax
 9ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f8:	01 c2                	add    %eax,%edx
 9fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fd:	8b 00                	mov    (%eax),%eax
 9ff:	39 c2                	cmp    %eax,%edx
 a01:	75 24                	jne    a27 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a03:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a06:	8b 50 04             	mov    0x4(%eax),%edx
 a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0c:	8b 00                	mov    (%eax),%eax
 a0e:	8b 40 04             	mov    0x4(%eax),%eax
 a11:	01 c2                	add    %eax,%edx
 a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a16:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1c:	8b 00                	mov    (%eax),%eax
 a1e:	8b 10                	mov    (%eax),%edx
 a20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a23:	89 10                	mov    %edx,(%eax)
 a25:	eb 0a                	jmp    a31 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2a:	8b 10                	mov    (%eax),%edx
 a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a34:	8b 40 04             	mov    0x4(%eax),%eax
 a37:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a41:	01 d0                	add    %edx,%eax
 a43:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a46:	75 20                	jne    a68 <free+0xcf>
    p->s.size += bp->s.size;
 a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4b:	8b 50 04             	mov    0x4(%eax),%edx
 a4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a51:	8b 40 04             	mov    0x4(%eax),%eax
 a54:	01 c2                	add    %eax,%edx
 a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a59:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5f:	8b 10                	mov    (%eax),%edx
 a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a64:	89 10                	mov    %edx,(%eax)
 a66:	eb 08                	jmp    a70 <free+0xd7>
  } else
    p->s.ptr = bp;
 a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a6e:	89 10                	mov    %edx,(%eax)
  freep = p;
 a70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a73:	a3 18 10 00 00       	mov    %eax,0x1018
}
 a78:	c9                   	leave  
 a79:	c3                   	ret    

00000a7a <morecore>:

static Header*
morecore(uint nu)
{
 a7a:	55                   	push   %ebp
 a7b:	89 e5                	mov    %esp,%ebp
 a7d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a80:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a87:	77 07                	ja     a90 <morecore+0x16>
    nu = 4096;
 a89:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a90:	8b 45 08             	mov    0x8(%ebp),%eax
 a93:	c1 e0 03             	shl    $0x3,%eax
 a96:	89 04 24             	mov    %eax,(%esp)
 a99:	e8 05 fc ff ff       	call   6a3 <sbrk>
 a9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 aa1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aa5:	75 07                	jne    aae <morecore+0x34>
    return 0;
 aa7:	b8 00 00 00 00       	mov    $0x0,%eax
 aac:	eb 22                	jmp    ad0 <morecore+0x56>
  hp = (Header*)p;
 aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab7:	8b 55 08             	mov    0x8(%ebp),%edx
 aba:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac0:	83 c0 08             	add    $0x8,%eax
 ac3:	89 04 24             	mov    %eax,(%esp)
 ac6:	e8 ce fe ff ff       	call   999 <free>
  return freep;
 acb:	a1 18 10 00 00       	mov    0x1018,%eax
}
 ad0:	c9                   	leave  
 ad1:	c3                   	ret    

00000ad2 <malloc>:

void*
malloc(uint nbytes)
{
 ad2:	55                   	push   %ebp
 ad3:	89 e5                	mov    %esp,%ebp
 ad5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	83 c0 07             	add    $0x7,%eax
 ade:	c1 e8 03             	shr    $0x3,%eax
 ae1:	40                   	inc    %eax
 ae2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ae5:	a1 18 10 00 00       	mov    0x1018,%eax
 aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af1:	75 23                	jne    b16 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 af3:	c7 45 f0 10 10 00 00 	movl   $0x1010,-0x10(%ebp)
 afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 afd:	a3 18 10 00 00       	mov    %eax,0x1018
 b02:	a1 18 10 00 00       	mov    0x1018,%eax
 b07:	a3 10 10 00 00       	mov    %eax,0x1010
    base.s.size = 0;
 b0c:	c7 05 14 10 00 00 00 	movl   $0x0,0x1014
 b13:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b19:	8b 00                	mov    (%eax),%eax
 b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b21:	8b 40 04             	mov    0x4(%eax),%eax
 b24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b27:	72 4d                	jb     b76 <malloc+0xa4>
      if(p->s.size == nunits)
 b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2c:	8b 40 04             	mov    0x4(%eax),%eax
 b2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b32:	75 0c                	jne    b40 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b37:	8b 10                	mov    (%eax),%edx
 b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b3c:	89 10                	mov    %edx,(%eax)
 b3e:	eb 26                	jmp    b66 <malloc+0x94>
      else {
        p->s.size -= nunits;
 b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b43:	8b 40 04             	mov    0x4(%eax),%eax
 b46:	89 c2                	mov    %eax,%edx
 b48:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b54:	8b 40 04             	mov    0x4(%eax),%eax
 b57:	c1 e0 03             	shl    $0x3,%eax
 b5a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b60:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b63:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b69:	a3 18 10 00 00       	mov    %eax,0x1018
      return (void*)(p + 1);
 b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b71:	83 c0 08             	add    $0x8,%eax
 b74:	eb 38                	jmp    bae <malloc+0xdc>
    }
    if(p == freep)
 b76:	a1 18 10 00 00       	mov    0x1018,%eax
 b7b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b7e:	75 1b                	jne    b9b <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b83:	89 04 24             	mov    %eax,(%esp)
 b86:	e8 ef fe ff ff       	call   a7a <morecore>
 b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b92:	75 07                	jne    b9b <malloc+0xc9>
        return 0;
 b94:	b8 00 00 00 00       	mov    $0x0,%eax
 b99:	eb 13                	jmp    bae <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba4:	8b 00                	mov    (%eax),%eax
 ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 ba9:	e9 70 ff ff ff       	jmp    b1e <malloc+0x4c>
}
 bae:	c9                   	leave  
 baf:	c3                   	ret    
