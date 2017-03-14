
_sema-test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <productor>:
int semprueba;
int semprueba2;

void
productor(int val)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(1,"-- INICIA PRODUCTOR --\n");
   6:	c7 44 24 04 78 0b 00 	movl   $0xb78,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 98 07 00 00       	call   7b2 <printf>
  semdown(semprod); // empty
  1a:	a1 b0 0f 00 00       	mov    0xfb0,%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 8b 06 00 00       	call   6b2 <semdown>
  semdown(sembuff); // mutex
  27:	a1 b8 0f 00 00       	mov    0xfb8,%eax
  2c:	89 04 24             	mov    %eax,(%esp)
  2f:	e8 7e 06 00 00       	call   6b2 <semdown>
  //  REGION CRITICA
  val = (val) + 1;
  34:	ff 45 08             	incl   0x8(%ebp)
  printf(1,"-- Produce: %d\n",val);
  37:	8b 45 08             	mov    0x8(%ebp),%eax
  3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  3e:	c7 44 24 04 90 0b 00 	movl   $0xb90,0x4(%esp)
  45:	00 
  46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4d:	e8 60 07 00 00       	call   7b2 <printf>
  semup(sembuff); //mutex
  52:	a1 b8 0f 00 00       	mov    0xfb8,%eax
  57:	89 04 24             	mov    %eax,(%esp)
  5a:	e8 5b 06 00 00       	call   6ba <semup>
  semup(semcom); // full
  5f:	a1 c4 0f 00 00       	mov    0xfc4,%eax
  64:	89 04 24             	mov    %eax,(%esp)
  67:	e8 4e 06 00 00       	call   6ba <semup>
  printf(1,"-- FIN PRODUCTOR --\n");
  6c:	c7 44 24 04 a0 0b 00 	movl   $0xba0,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 32 07 00 00       	call   7b2 <printf>
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <consumidor>:

void
consumidor(int val)
{ 
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  85:	83 ec 18             	sub    $0x18,%esp
  printf(1,"-- INICIA CONSUMIDOR --\n");
  88:	c7 44 24 04 b5 0b 00 	movl   $0xbb5,0x4(%esp)
  8f:	00 
  90:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  97:	e8 16 07 00 00       	call   7b2 <printf>
  semdown(semcom); // full
  9c:	a1 c4 0f 00 00       	mov    0xfc4,%eax
  a1:	89 04 24             	mov    %eax,(%esp)
  a4:	e8 09 06 00 00       	call   6b2 <semdown>
  semdown(sembuff); // mutex
  a9:	a1 b8 0f 00 00       	mov    0xfb8,%eax
  ae:	89 04 24             	mov    %eax,(%esp)
  b1:	e8 fc 05 00 00       	call   6b2 <semdown>
  // REGION CRITICA
  val = (val) - 1;
  b6:	ff 4d 08             	decl   0x8(%ebp)
  printf(1,"-- Consume: %d\n",val);
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  c0:	c7 44 24 04 ce 0b 00 	movl   $0xbce,0x4(%esp)
  c7:	00 
  c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cf:	e8 de 06 00 00       	call   7b2 <printf>
  semup(sembuff); // mutex
  d4:	a1 b8 0f 00 00       	mov    0xfb8,%eax
  d9:	89 04 24             	mov    %eax,(%esp)
  dc:	e8 d9 05 00 00       	call   6ba <semup>
  semup(semprod); // empty
  e1:	a1 b0 0f 00 00       	mov    0xfb0,%eax
  e6:	89 04 24             	mov    %eax,(%esp)
  e9:	e8 cc 05 00 00       	call   6ba <semup>
  printf(1,"-- FIN CONSUMIDOR --\n");
  ee:	c7 44 24 04 de 0b 00 	movl   $0xbde,0x4(%esp)
  f5:	00 
  f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fd:	e8 b0 06 00 00       	call   7b2 <printf>
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <main>:

int
main(void)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 e4 f0             	and    $0xfffffff0,%esp
 10a:	83 ec 20             	sub    $0x20,%esp
  int val = 8; 
 10d:	c7 44 24 18 08 00 00 	movl   $0x8,0x18(%esp)
 114:	00 
  int pid_prod, pid_com, i;

  printf(1,"-------------------------- VALOR INICIAL: [%d] \n", val);
 115:	8b 44 24 18          	mov    0x18(%esp),%eax
 119:	89 44 24 08          	mov    %eax,0x8(%esp)
 11d:	c7 44 24 04 f4 0b 00 	movl   $0xbf4,0x4(%esp)
 124:	00 
 125:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 12c:	e8 81 06 00 00       	call   7b2 <printf>
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
 131:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 138:	00 
 139:	c7 44 24 04 25 0c 00 	movl   $0xc25,0x4(%esp)
 140:	00 
 141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 148:	e8 65 06 00 00       	call   7b2 <printf>
  
  // creo semaforo productor 
  semprod = semget(-1,BUFF_SIZE); // empty
 14d:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 154:	00 
 155:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 15c:	e8 41 05 00 00       	call   6a2 <semget>
 161:	a3 b0 0f 00 00       	mov    %eax,0xfb0
  // semprod es cero
  if(semprod < 0){
 166:	a1 b0 0f 00 00       	mov    0xfb0,%eax
 16b:	85 c0                	test   %eax,%eax
 16d:	79 19                	jns    188 <main+0x84>
    printf(1,"invalid semprod \n");
 16f:	c7 44 24 04 40 0c 00 	movl   $0xc40,0x4(%esp)
 176:	00 
 177:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17e:	e8 2f 06 00 00       	call   7b2 <printf>
    exit();
 183:	e8 5a 04 00 00       	call   5e2 <exit>
  }
  // creo semaforo consumidor
  semcom = semget(-1,0); // full   
 188:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 18f:	00 
 190:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 197:	e8 06 05 00 00       	call   6a2 <semget>
 19c:	a3 c4 0f 00 00       	mov    %eax,0xfc4
  if(semcom < 0){
 1a1:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 1a6:	85 c0                	test   %eax,%eax
 1a8:	79 19                	jns    1c3 <main+0xbf>
    printf(1,"invalid semcom\n");
 1aa:	c7 44 24 04 52 0c 00 	movl   $0xc52,0x4(%esp)
 1b1:	00 
 1b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b9:	e8 f4 05 00 00       	call   7b2 <printf>
    exit();
 1be:	e8 1f 04 00 00       	call   5e2 <exit>
  }
  // creo semaforo buffer
  sembuff = semget(-1,1); // mutex 
 1c3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 1ca:	00 
 1cb:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1d2:	e8 cb 04 00 00       	call   6a2 <semget>
 1d7:	a3 b8 0f 00 00       	mov    %eax,0xfb8
  if(sembuff < 0){
 1dc:	a1 b8 0f 00 00       	mov    0xfb8,%eax
 1e1:	85 c0                	test   %eax,%eax
 1e3:	79 19                	jns    1fe <main+0xfa>
    printf(1,"invalid sembuff\n");
 1e5:	c7 44 24 04 62 0c 00 	movl   $0xc62,0x4(%esp)
 1ec:	00 
 1ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f4:	e8 b9 05 00 00       	call   7b2 <printf>
    exit();
 1f9:	e8 e4 03 00 00       	call   5e2 <exit>
  }

  for (i = 0; i < PRODUCERS; i++) { // 4 productores 
 1fe:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 205:	00 
 206:	e9 98 00 00 00       	jmp    2a3 <main+0x19f>
    // create producer process
    pid_prod = fork();
 20b:	e8 ca 03 00 00       	call   5da <fork>
 210:	89 44 24 14          	mov    %eax,0x14(%esp)
    if(pid_prod < 0){
 214:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 219:	79 19                	jns    234 <main+0x130>
      printf(1,"can't create producer process\n");
 21b:	c7 44 24 04 74 0c 00 	movl   $0xc74,0x4(%esp)
 222:	00 
 223:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 22a:	e8 83 05 00 00       	call   7b2 <printf>
      exit(); 
 22f:	e8 ae 03 00 00       	call   5e2 <exit>
    }
    // launch producer process
    if(pid_prod == 0){ // hijo
 234:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 239:	75 64                	jne    29f <main+0x19b>
      printf(1," # hijo productor\n");
 23b:	c7 44 24 04 93 0c 00 	movl   $0xc93,0x4(%esp)
 242:	00 
 243:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 24a:	e8 63 05 00 00       	call   7b2 <printf>
      semget(semprod,0);
 24f:	a1 b0 0f 00 00       	mov    0xfb0,%eax
 254:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 25b:	00 
 25c:	89 04 24             	mov    %eax,(%esp)
 25f:	e8 3e 04 00 00       	call   6a2 <semget>
      semget(semcom,0);
 264:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 269:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 270:	00 
 271:	89 04 24             	mov    %eax,(%esp)
 274:	e8 29 04 00 00       	call   6a2 <semget>
      semget(sembuff,0);
 279:	a1 b8 0f 00 00       	mov    0xfb8,%eax
 27e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 285:	00 
 286:	89 04 24             	mov    %eax,(%esp)
 289:	e8 14 04 00 00       	call   6a2 <semget>
      productor(val); 
 28e:	8b 44 24 18          	mov    0x18(%esp),%eax
 292:	89 04 24             	mov    %eax,(%esp)
 295:	e8 66 fd ff ff       	call   0 <productor>
      exit();
 29a:	e8 43 03 00 00       	call   5e2 <exit>
  for (i = 0; i < PRODUCERS; i++) { // 4 productores 
 29f:	ff 44 24 1c          	incl   0x1c(%esp)
 2a3:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
 2a8:	0f 8e 5d ff ff ff    	jle    20b <main+0x107>
    }
  }

  for (i = 0; i < CONSUMERS; i++) { // 2 consumidores 
 2ae:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 2b5:	00 
 2b6:	e9 98 00 00 00       	jmp    353 <main+0x24f>
    // create consumer process
    pid_com = fork();
 2bb:	e8 1a 03 00 00       	call   5da <fork>
 2c0:	89 44 24 10          	mov    %eax,0x10(%esp)
    if(pid_com < 0){
 2c4:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
 2c9:	79 19                	jns    2e4 <main+0x1e0>
      printf(1,"can't create consumer process\n");
 2cb:	c7 44 24 04 a8 0c 00 	movl   $0xca8,0x4(%esp)
 2d2:	00 
 2d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2da:	e8 d3 04 00 00       	call   7b2 <printf>
      exit(); 
 2df:	e8 fe 02 00 00       	call   5e2 <exit>
    }
    // launch consumer process
    if(pid_com == 0){ // hijo
 2e4:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
 2e9:	75 64                	jne    34f <main+0x24b>
      printf(1," # hijo consumidor\n");
 2eb:	c7 44 24 04 c7 0c 00 	movl   $0xcc7,0x4(%esp)
 2f2:	00 
 2f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2fa:	e8 b3 04 00 00       	call   7b2 <printf>
      semget(semprod,0);
 2ff:	a1 b0 0f 00 00       	mov    0xfb0,%eax
 304:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 30b:	00 
 30c:	89 04 24             	mov    %eax,(%esp)
 30f:	e8 8e 03 00 00       	call   6a2 <semget>
      semget(semcom,0);
 314:	a1 c4 0f 00 00       	mov    0xfc4,%eax
 319:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 320:	00 
 321:	89 04 24             	mov    %eax,(%esp)
 324:	e8 79 03 00 00       	call   6a2 <semget>
      semget(sembuff,0);
 329:	a1 b8 0f 00 00       	mov    0xfb8,%eax
 32e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 335:	00 
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 64 03 00 00       	call   6a2 <semget>
      consumidor(val); 
 33e:	8b 44 24 18          	mov    0x18(%esp),%eax
 342:	89 04 24             	mov    %eax,(%esp)
 345:	e8 38 fd ff ff       	call   82 <consumidor>
      exit();
 34a:	e8 93 02 00 00       	call   5e2 <exit>
  for (i = 0; i < CONSUMERS; i++) { // 2 consumidores 
 34f:	ff 44 24 1c          	incl   0x1c(%esp)
 353:	83 7c 24 1c 01       	cmpl   $0x1,0x1c(%esp)
 358:	0f 8e 5d ff ff ff    	jle    2bb <main+0x1b7>
    }
  }

  for (i = 0; i < PRODUCERS + CONSUMERS; i++) { // 6 
 35e:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 365:	00 
 366:	eb 09                	jmp    371 <main+0x26d>
    wait();
 368:	e8 7d 02 00 00       	call   5ea <wait>
  for (i = 0; i < PRODUCERS + CONSUMERS; i++) { // 6 
 36d:	ff 44 24 1c          	incl   0x1c(%esp)
 371:	83 7c 24 1c 05       	cmpl   $0x5,0x1c(%esp)
 376:	7e f0                	jle    368 <main+0x264>
  }
   
  printf(1,"-------------------------- VALOR FINAL: [%x]  \n", val);
 378:	8b 44 24 18          	mov    0x18(%esp),%eax
 37c:	89 44 24 08          	mov    %eax,0x8(%esp)
 380:	c7 44 24 04 dc 0c 00 	movl   $0xcdc,0x4(%esp)
 387:	00 
 388:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38f:	e8 1e 04 00 00       	call   7b2 <printf>
  exit();
 394:	e8 49 02 00 00       	call   5e2 <exit>

00000399 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	57                   	push   %edi
 39d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 39e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3a1:	8b 55 10             	mov    0x10(%ebp),%edx
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	89 cb                	mov    %ecx,%ebx
 3a9:	89 df                	mov    %ebx,%edi
 3ab:	89 d1                	mov    %edx,%ecx
 3ad:	fc                   	cld    
 3ae:	f3 aa                	rep stos %al,%es:(%edi)
 3b0:	89 ca                	mov    %ecx,%edx
 3b2:	89 fb                	mov    %edi,%ebx
 3b4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3b7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3ba:	5b                   	pop    %ebx
 3bb:	5f                   	pop    %edi
 3bc:	5d                   	pop    %ebp
 3bd:	c3                   	ret    

000003be <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3be:	55                   	push   %ebp
 3bf:	89 e5                	mov    %esp,%ebp
 3c1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 3ca:	90                   	nop
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	8a 10                	mov    (%eax),%dl
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	88 10                	mov    %dl,(%eax)
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	8a 00                	mov    (%eax),%al
 3da:	84 c0                	test   %al,%al
 3dc:	0f 95 c0             	setne  %al
 3df:	ff 45 08             	incl   0x8(%ebp)
 3e2:	ff 45 0c             	incl   0xc(%ebp)
 3e5:	84 c0                	test   %al,%al
 3e7:	75 e2                	jne    3cb <strcpy+0xd>
    ;
  return os;
 3e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ec:	c9                   	leave  
 3ed:	c3                   	ret    

000003ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ee:	55                   	push   %ebp
 3ef:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3f1:	eb 06                	jmp    3f9 <strcmp+0xb>
    p++, q++;
 3f3:	ff 45 08             	incl   0x8(%ebp)
 3f6:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	8a 00                	mov    (%eax),%al
 3fe:	84 c0                	test   %al,%al
 400:	74 0e                	je     410 <strcmp+0x22>
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	8a 10                	mov    (%eax),%dl
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	8a 00                	mov    (%eax),%al
 40c:	38 c2                	cmp    %al,%dl
 40e:	74 e3                	je     3f3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	8a 00                	mov    (%eax),%al
 415:	0f b6 d0             	movzbl %al,%edx
 418:	8b 45 0c             	mov    0xc(%ebp),%eax
 41b:	8a 00                	mov    (%eax),%al
 41d:	0f b6 c0             	movzbl %al,%eax
 420:	89 d1                	mov    %edx,%ecx
 422:	29 c1                	sub    %eax,%ecx
 424:	89 c8                	mov    %ecx,%eax
}
 426:	5d                   	pop    %ebp
 427:	c3                   	ret    

00000428 <strlen>:

uint
strlen(char *s)
{
 428:	55                   	push   %ebp
 429:	89 e5                	mov    %esp,%ebp
 42b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 42e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 435:	eb 03                	jmp    43a <strlen+0x12>
 437:	ff 45 fc             	incl   -0x4(%ebp)
 43a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	01 d0                	add    %edx,%eax
 442:	8a 00                	mov    (%eax),%al
 444:	84 c0                	test   %al,%al
 446:	75 ef                	jne    437 <strlen+0xf>
    ;
  return n;
 448:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <memset>:

void*
memset(void *dst, int c, uint n)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 453:	8b 45 10             	mov    0x10(%ebp),%eax
 456:	89 44 24 08          	mov    %eax,0x8(%esp)
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	89 44 24 04          	mov    %eax,0x4(%esp)
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	89 04 24             	mov    %eax,(%esp)
 467:	e8 2d ff ff ff       	call   399 <stosb>
  return dst;
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <strchr>:

char*
strchr(const char *s, char c)
{
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	83 ec 04             	sub    $0x4,%esp
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 47d:	eb 12                	jmp    491 <strchr+0x20>
    if(*s == c)
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	8a 00                	mov    (%eax),%al
 484:	3a 45 fc             	cmp    -0x4(%ebp),%al
 487:	75 05                	jne    48e <strchr+0x1d>
      return (char*)s;
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	eb 11                	jmp    49f <strchr+0x2e>
  for(; *s; s++)
 48e:	ff 45 08             	incl   0x8(%ebp)
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	8a 00                	mov    (%eax),%al
 496:	84 c0                	test   %al,%al
 498:	75 e5                	jne    47f <strchr+0xe>
  return 0;
 49a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 49f:	c9                   	leave  
 4a0:	c3                   	ret    

000004a1 <gets>:

char*
gets(char *buf, int max)
{
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4ae:	eb 42                	jmp    4f2 <gets+0x51>
    cc = read(0, &c, 1);
 4b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b7:	00 
 4b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4c6:	e8 2f 01 00 00       	call   5fa <read>
 4cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4d2:	7e 29                	jle    4fd <gets+0x5c>
      break;
    buf[i++] = c;
 4d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	01 c2                	add    %eax,%edx
 4dc:	8a 45 ef             	mov    -0x11(%ebp),%al
 4df:	88 02                	mov    %al,(%edx)
 4e1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 4e4:	8a 45 ef             	mov    -0x11(%ebp),%al
 4e7:	3c 0a                	cmp    $0xa,%al
 4e9:	74 13                	je     4fe <gets+0x5d>
 4eb:	8a 45 ef             	mov    -0x11(%ebp),%al
 4ee:	3c 0d                	cmp    $0xd,%al
 4f0:	74 0c                	je     4fe <gets+0x5d>
  for(i=0; i+1 < max; ){
 4f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f5:	40                   	inc    %eax
 4f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4f9:	7c b5                	jl     4b0 <gets+0xf>
 4fb:	eb 01                	jmp    4fe <gets+0x5d>
      break;
 4fd:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	01 d0                	add    %edx,%eax
 506:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 509:	8b 45 08             	mov    0x8(%ebp),%eax
}
 50c:	c9                   	leave  
 50d:	c3                   	ret    

0000050e <stat>:

int
stat(char *n, struct stat *st)
{
 50e:	55                   	push   %ebp
 50f:	89 e5                	mov    %esp,%ebp
 511:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 514:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 51b:	00 
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 fb 00 00 00       	call   622 <open>
 527:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 52a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52e:	79 07                	jns    537 <stat+0x29>
    return -1;
 530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 535:	eb 23                	jmp    55a <stat+0x4c>
  r = fstat(fd, st);
 537:	8b 45 0c             	mov    0xc(%ebp),%eax
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 f1 00 00 00       	call   63a <fstat>
 549:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 54c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54f:	89 04 24             	mov    %eax,(%esp)
 552:	e8 b3 00 00 00       	call   60a <close>
  return r;
 557:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 55a:	c9                   	leave  
 55b:	c3                   	ret    

0000055c <atoi>:

int
atoi(const char *s)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 562:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 569:	eb 21                	jmp    58c <atoi+0x30>
    n = n*10 + *s++ - '0';
 56b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 56e:	89 d0                	mov    %edx,%eax
 570:	c1 e0 02             	shl    $0x2,%eax
 573:	01 d0                	add    %edx,%eax
 575:	d1 e0                	shl    %eax
 577:	89 c2                	mov    %eax,%edx
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	8a 00                	mov    (%eax),%al
 57e:	0f be c0             	movsbl %al,%eax
 581:	01 d0                	add    %edx,%eax
 583:	83 e8 30             	sub    $0x30,%eax
 586:	89 45 fc             	mov    %eax,-0x4(%ebp)
 589:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	8a 00                	mov    (%eax),%al
 591:	3c 2f                	cmp    $0x2f,%al
 593:	7e 09                	jle    59e <atoi+0x42>
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	8a 00                	mov    (%eax),%al
 59a:	3c 39                	cmp    $0x39,%al
 59c:	7e cd                	jle    56b <atoi+0xf>
  return n;
 59e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5a1:	c9                   	leave  
 5a2:	c3                   	ret    

000005a3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp
 5a6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5af:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5b5:	eb 10                	jmp    5c7 <memmove+0x24>
    *dst++ = *src++;
 5b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ba:	8a 10                	mov    (%eax),%dl
 5bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bf:	88 10                	mov    %dl,(%eax)
 5c1:	ff 45 fc             	incl   -0x4(%ebp)
 5c4:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 5c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5cb:	0f 9f c0             	setg   %al
 5ce:	ff 4d 10             	decl   0x10(%ebp)
 5d1:	84 c0                	test   %al,%al
 5d3:	75 e2                	jne    5b7 <memmove+0x14>
  return vdst;
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5d8:	c9                   	leave  
 5d9:	c3                   	ret    

000005da <fork>:
 5da:	b8 01 00 00 00       	mov    $0x1,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <exit>:
 5e2:	b8 02 00 00 00       	mov    $0x2,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <wait>:
 5ea:	b8 03 00 00 00       	mov    $0x3,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <pipe>:
 5f2:	b8 04 00 00 00       	mov    $0x4,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <read>:
 5fa:	b8 05 00 00 00       	mov    $0x5,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <write>:
 602:	b8 10 00 00 00       	mov    $0x10,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <close>:
 60a:	b8 15 00 00 00       	mov    $0x15,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <kill>:
 612:	b8 06 00 00 00       	mov    $0x6,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <exec>:
 61a:	b8 07 00 00 00       	mov    $0x7,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <open>:
 622:	b8 0f 00 00 00       	mov    $0xf,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mknod>:
 62a:	b8 11 00 00 00       	mov    $0x11,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <unlink>:
 632:	b8 12 00 00 00       	mov    $0x12,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <fstat>:
 63a:	b8 08 00 00 00       	mov    $0x8,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <link>:
 642:	b8 13 00 00 00       	mov    $0x13,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mkdir>:
 64a:	b8 14 00 00 00       	mov    $0x14,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <chdir>:
 652:	b8 09 00 00 00       	mov    $0x9,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <dup>:
 65a:	b8 0a 00 00 00       	mov    $0xa,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getpid>:
 662:	b8 0b 00 00 00       	mov    $0xb,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <sbrk>:
 66a:	b8 0c 00 00 00       	mov    $0xc,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <sleep>:
 672:	b8 0d 00 00 00       	mov    $0xd,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <uptime>:
 67a:	b8 0e 00 00 00       	mov    $0xe,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <lseek>:
 682:	b8 16 00 00 00       	mov    $0x16,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <isatty>:
 68a:	b8 17 00 00 00       	mov    $0x17,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <procstat>:
 692:	b8 18 00 00 00       	mov    $0x18,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <set_priority>:
 69a:	b8 19 00 00 00       	mov    $0x19,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <semget>:
 6a2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <semfree>:
 6aa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    

000006b2 <semdown>:
 6b2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6b7:	cd 40                	int    $0x40
 6b9:	c3                   	ret    

000006ba <semup>:
 6ba:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6bf:	cd 40                	int    $0x40
 6c1:	c3                   	ret    

000006c2 <shm_create>:
 6c2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 6c7:	cd 40                	int    $0x40
 6c9:	c3                   	ret    

000006ca <shm_close>:
 6ca:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6cf:	cd 40                	int    $0x40
 6d1:	c3                   	ret    

000006d2 <shm_get>:
 6d2:	b8 20 00 00 00       	mov    $0x20,%eax
 6d7:	cd 40                	int    $0x40
 6d9:	c3                   	ret    

000006da <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6da:	55                   	push   %ebp
 6db:	89 e5                	mov    %esp,%ebp
 6dd:	83 ec 28             	sub    $0x28,%esp
 6e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6e6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ed:	00 
 6ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	89 04 24             	mov    %eax,(%esp)
 6fb:	e8 02 ff ff ff       	call   602 <write>
}
 700:	c9                   	leave  
 701:	c3                   	ret    

00000702 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 702:	55                   	push   %ebp
 703:	89 e5                	mov    %esp,%ebp
 705:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 708:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 70f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 713:	74 17                	je     72c <printint+0x2a>
 715:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 719:	79 11                	jns    72c <printint+0x2a>
    neg = 1;
 71b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 722:	8b 45 0c             	mov    0xc(%ebp),%eax
 725:	f7 d8                	neg    %eax
 727:	89 45 ec             	mov    %eax,-0x14(%ebp)
 72a:	eb 06                	jmp    732 <printint+0x30>
  } else {
    x = xx;
 72c:	8b 45 0c             	mov    0xc(%ebp),%eax
 72f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 732:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 739:	8b 4d 10             	mov    0x10(%ebp),%ecx
 73c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 73f:	ba 00 00 00 00       	mov    $0x0,%edx
 744:	f7 f1                	div    %ecx
 746:	89 d0                	mov    %edx,%eax
 748:	8a 80 90 0f 00 00    	mov    0xf90(%eax),%al
 74e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 751:	8b 55 f4             	mov    -0xc(%ebp),%edx
 754:	01 ca                	add    %ecx,%edx
 756:	88 02                	mov    %al,(%edx)
 758:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 75b:	8b 55 10             	mov    0x10(%ebp),%edx
 75e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 761:	8b 45 ec             	mov    -0x14(%ebp),%eax
 764:	ba 00 00 00 00       	mov    $0x0,%edx
 769:	f7 75 d4             	divl   -0x2c(%ebp)
 76c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 76f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 773:	75 c4                	jne    739 <printint+0x37>
  if(neg)
 775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 779:	74 2c                	je     7a7 <printint+0xa5>
    buf[i++] = '-';
 77b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	01 d0                	add    %edx,%eax
 783:	c6 00 2d             	movb   $0x2d,(%eax)
 786:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 789:	eb 1c                	jmp    7a7 <printint+0xa5>
    putc(fd, buf[i]);
 78b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 78e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 791:	01 d0                	add    %edx,%eax
 793:	8a 00                	mov    (%eax),%al
 795:	0f be c0             	movsbl %al,%eax
 798:	89 44 24 04          	mov    %eax,0x4(%esp)
 79c:	8b 45 08             	mov    0x8(%ebp),%eax
 79f:	89 04 24             	mov    %eax,(%esp)
 7a2:	e8 33 ff ff ff       	call   6da <putc>
  while(--i >= 0)
 7a7:	ff 4d f4             	decl   -0xc(%ebp)
 7aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ae:	79 db                	jns    78b <printint+0x89>
}
 7b0:	c9                   	leave  
 7b1:	c3                   	ret    

000007b2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7b2:	55                   	push   %ebp
 7b3:	89 e5                	mov    %esp,%ebp
 7b5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7bf:	8d 45 0c             	lea    0xc(%ebp),%eax
 7c2:	83 c0 04             	add    $0x4,%eax
 7c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7cf:	e9 78 01 00 00       	jmp    94c <printf+0x19a>
    c = fmt[i] & 0xff;
 7d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7da:	01 d0                	add    %edx,%eax
 7dc:	8a 00                	mov    (%eax),%al
 7de:	0f be c0             	movsbl %al,%eax
 7e1:	25 ff 00 00 00       	and    $0xff,%eax
 7e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ed:	75 2c                	jne    81b <printf+0x69>
      if(c == '%'){
 7ef:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f3:	75 0c                	jne    801 <printf+0x4f>
        state = '%';
 7f5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7fc:	e9 48 01 00 00       	jmp    949 <printf+0x197>
      } else {
        putc(fd, c);
 801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 804:	0f be c0             	movsbl %al,%eax
 807:	89 44 24 04          	mov    %eax,0x4(%esp)
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	89 04 24             	mov    %eax,(%esp)
 811:	e8 c4 fe ff ff       	call   6da <putc>
 816:	e9 2e 01 00 00       	jmp    949 <printf+0x197>
      }
    } else if(state == '%'){
 81b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 81f:	0f 85 24 01 00 00    	jne    949 <printf+0x197>
      if(c == 'd'){
 825:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 829:	75 2d                	jne    858 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 82b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 837:	00 
 838:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 83f:	00 
 840:	89 44 24 04          	mov    %eax,0x4(%esp)
 844:	8b 45 08             	mov    0x8(%ebp),%eax
 847:	89 04 24             	mov    %eax,(%esp)
 84a:	e8 b3 fe ff ff       	call   702 <printint>
        ap++;
 84f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 853:	e9 ea 00 00 00       	jmp    942 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 858:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 85c:	74 06                	je     864 <printf+0xb2>
 85e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 862:	75 2d                	jne    891 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 864:	8b 45 e8             	mov    -0x18(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 870:	00 
 871:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 878:	00 
 879:	89 44 24 04          	mov    %eax,0x4(%esp)
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
 880:	89 04 24             	mov    %eax,(%esp)
 883:	e8 7a fe ff ff       	call   702 <printint>
        ap++;
 888:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 88c:	e9 b1 00 00 00       	jmp    942 <printf+0x190>
      } else if(c == 's'){
 891:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 895:	75 43                	jne    8da <printf+0x128>
        s = (char*)*ap;
 897:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89a:	8b 00                	mov    (%eax),%eax
 89c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 89f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a7:	75 25                	jne    8ce <printf+0x11c>
          s = "(null)";
 8a9:	c7 45 f4 0c 0d 00 00 	movl   $0xd0c,-0xc(%ebp)
        while(*s != 0){
 8b0:	eb 1c                	jmp    8ce <printf+0x11c>
          putc(fd, *s);
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	8a 00                	mov    (%eax),%al
 8b7:	0f be c0             	movsbl %al,%eax
 8ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 8be:	8b 45 08             	mov    0x8(%ebp),%eax
 8c1:	89 04 24             	mov    %eax,(%esp)
 8c4:	e8 11 fe ff ff       	call   6da <putc>
          s++;
 8c9:	ff 45 f4             	incl   -0xc(%ebp)
 8cc:	eb 01                	jmp    8cf <printf+0x11d>
        while(*s != 0){
 8ce:	90                   	nop
 8cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d2:	8a 00                	mov    (%eax),%al
 8d4:	84 c0                	test   %al,%al
 8d6:	75 da                	jne    8b2 <printf+0x100>
 8d8:	eb 68                	jmp    942 <printf+0x190>
        }
      } else if(c == 'c'){
 8da:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8de:	75 1d                	jne    8fd <printf+0x14b>
        putc(fd, *ap);
 8e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	0f be c0             	movsbl %al,%eax
 8e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ec:	8b 45 08             	mov    0x8(%ebp),%eax
 8ef:	89 04 24             	mov    %eax,(%esp)
 8f2:	e8 e3 fd ff ff       	call   6da <putc>
        ap++;
 8f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8fb:	eb 45                	jmp    942 <printf+0x190>
      } else if(c == '%'){
 8fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 901:	75 17                	jne    91a <printf+0x168>
        putc(fd, c);
 903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 906:	0f be c0             	movsbl %al,%eax
 909:	89 44 24 04          	mov    %eax,0x4(%esp)
 90d:	8b 45 08             	mov    0x8(%ebp),%eax
 910:	89 04 24             	mov    %eax,(%esp)
 913:	e8 c2 fd ff ff       	call   6da <putc>
 918:	eb 28                	jmp    942 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 91a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 921:	00 
 922:	8b 45 08             	mov    0x8(%ebp),%eax
 925:	89 04 24             	mov    %eax,(%esp)
 928:	e8 ad fd ff ff       	call   6da <putc>
        putc(fd, c);
 92d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 930:	0f be c0             	movsbl %al,%eax
 933:	89 44 24 04          	mov    %eax,0x4(%esp)
 937:	8b 45 08             	mov    0x8(%ebp),%eax
 93a:	89 04 24             	mov    %eax,(%esp)
 93d:	e8 98 fd ff ff       	call   6da <putc>
      }
      state = 0;
 942:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 949:	ff 45 f0             	incl   -0x10(%ebp)
 94c:	8b 55 0c             	mov    0xc(%ebp),%edx
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	01 d0                	add    %edx,%eax
 954:	8a 00                	mov    (%eax),%al
 956:	84 c0                	test   %al,%al
 958:	0f 85 76 fe ff ff    	jne    7d4 <printf+0x22>
    }
  }
}
 95e:	c9                   	leave  
 95f:	c3                   	ret    

00000960 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 966:	8b 45 08             	mov    0x8(%ebp),%eax
 969:	83 e8 08             	sub    $0x8,%eax
 96c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 96f:	a1 ac 0f 00 00       	mov    0xfac,%eax
 974:	89 45 fc             	mov    %eax,-0x4(%ebp)
 977:	eb 24                	jmp    99d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	8b 00                	mov    (%eax),%eax
 97e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 981:	77 12                	ja     995 <free+0x35>
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 989:	77 24                	ja     9af <free+0x4f>
 98b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98e:	8b 00                	mov    (%eax),%eax
 990:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 993:	77 1a                	ja     9af <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 00                	mov    (%eax),%eax
 99a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 99d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a3:	76 d4                	jbe    979 <free+0x19>
 9a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a8:	8b 00                	mov    (%eax),%eax
 9aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ad:	76 ca                	jbe    979 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	8b 40 04             	mov    0x4(%eax),%eax
 9b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9bf:	01 c2                	add    %eax,%edx
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	8b 00                	mov    (%eax),%eax
 9c6:	39 c2                	cmp    %eax,%edx
 9c8:	75 24                	jne    9ee <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9cd:	8b 50 04             	mov    0x4(%eax),%edx
 9d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d3:	8b 00                	mov    (%eax),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	01 c2                	add    %eax,%edx
 9da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9dd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e3:	8b 00                	mov    (%eax),%eax
 9e5:	8b 10                	mov    (%eax),%edx
 9e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ea:	89 10                	mov    %edx,(%eax)
 9ec:	eb 0a                	jmp    9f8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f1:	8b 10                	mov    (%eax),%edx
 9f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fb:	8b 40 04             	mov    0x4(%eax),%eax
 9fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	01 d0                	add    %edx,%eax
 a0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a0d:	75 20                	jne    a2f <free+0xcf>
    p->s.size += bp->s.size;
 a0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a12:	8b 50 04             	mov    0x4(%eax),%edx
 a15:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a18:	8b 40 04             	mov    0x4(%eax),%eax
 a1b:	01 c2                	add    %eax,%edx
 a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a20:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a26:	8b 10                	mov    (%eax),%edx
 a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2b:	89 10                	mov    %edx,(%eax)
 a2d:	eb 08                	jmp    a37 <free+0xd7>
  } else
    p->s.ptr = bp;
 a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a32:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a35:	89 10                	mov    %edx,(%eax)
  freep = p;
 a37:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3a:	a3 ac 0f 00 00       	mov    %eax,0xfac
}
 a3f:	c9                   	leave  
 a40:	c3                   	ret    

00000a41 <morecore>:

static Header*
morecore(uint nu)
{
 a41:	55                   	push   %ebp
 a42:	89 e5                	mov    %esp,%ebp
 a44:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a47:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a4e:	77 07                	ja     a57 <morecore+0x16>
    nu = 4096;
 a50:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a57:	8b 45 08             	mov    0x8(%ebp),%eax
 a5a:	c1 e0 03             	shl    $0x3,%eax
 a5d:	89 04 24             	mov    %eax,(%esp)
 a60:	e8 05 fc ff ff       	call   66a <sbrk>
 a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a68:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a6c:	75 07                	jne    a75 <morecore+0x34>
    return 0;
 a6e:	b8 00 00 00 00       	mov    $0x0,%eax
 a73:	eb 22                	jmp    a97 <morecore+0x56>
  hp = (Header*)p;
 a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7e:	8b 55 08             	mov    0x8(%ebp),%edx
 a81:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a87:	83 c0 08             	add    $0x8,%eax
 a8a:	89 04 24             	mov    %eax,(%esp)
 a8d:	e8 ce fe ff ff       	call   960 <free>
  return freep;
 a92:	a1 ac 0f 00 00       	mov    0xfac,%eax
}
 a97:	c9                   	leave  
 a98:	c3                   	ret    

00000a99 <malloc>:

void*
malloc(uint nbytes)
{
 a99:	55                   	push   %ebp
 a9a:	89 e5                	mov    %esp,%ebp
 a9c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a9f:	8b 45 08             	mov    0x8(%ebp),%eax
 aa2:	83 c0 07             	add    $0x7,%eax
 aa5:	c1 e8 03             	shr    $0x3,%eax
 aa8:	40                   	inc    %eax
 aa9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 aac:	a1 ac 0f 00 00       	mov    0xfac,%eax
 ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ab8:	75 23                	jne    add <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 aba:	c7 45 f0 a4 0f 00 00 	movl   $0xfa4,-0x10(%ebp)
 ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac4:	a3 ac 0f 00 00       	mov    %eax,0xfac
 ac9:	a1 ac 0f 00 00       	mov    0xfac,%eax
 ace:	a3 a4 0f 00 00       	mov    %eax,0xfa4
    base.s.size = 0;
 ad3:	c7 05 a8 0f 00 00 00 	movl   $0x0,0xfa8
 ada:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 add:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae0:	8b 00                	mov    (%eax),%eax
 ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae8:	8b 40 04             	mov    0x4(%eax),%eax
 aeb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aee:	72 4d                	jb     b3d <malloc+0xa4>
      if(p->s.size == nunits)
 af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af3:	8b 40 04             	mov    0x4(%eax),%eax
 af6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 af9:	75 0c                	jne    b07 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afe:	8b 10                	mov    (%eax),%edx
 b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b03:	89 10                	mov    %edx,(%eax)
 b05:	eb 26                	jmp    b2d <malloc+0x94>
      else {
        p->s.size -= nunits;
 b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0a:	8b 40 04             	mov    0x4(%eax),%eax
 b0d:	89 c2                	mov    %eax,%edx
 b0f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b15:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1b:	8b 40 04             	mov    0x4(%eax),%eax
 b1e:	c1 e0 03             	shl    $0x3,%eax
 b21:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b27:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b2a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b30:	a3 ac 0f 00 00       	mov    %eax,0xfac
      return (void*)(p + 1);
 b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b38:	83 c0 08             	add    $0x8,%eax
 b3b:	eb 38                	jmp    b75 <malloc+0xdc>
    }
    if(p == freep)
 b3d:	a1 ac 0f 00 00       	mov    0xfac,%eax
 b42:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b45:	75 1b                	jne    b62 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b4a:	89 04 24             	mov    %eax,(%esp)
 b4d:	e8 ef fe ff ff       	call   a41 <morecore>
 b52:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b59:	75 07                	jne    b62 <malloc+0xc9>
        return 0;
 b5b:	b8 00 00 00 00       	mov    $0x0,%eax
 b60:	eb 13                	jmp    b75 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b65:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6b:	8b 00                	mov    (%eax),%eax
 b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 b70:	e9 70 ff ff ff       	jmp    ae5 <malloc+0x4c>
}
 b75:	c9                   	leave  
 b76:	c3                   	ret    
