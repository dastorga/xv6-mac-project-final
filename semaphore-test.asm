
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
   6:	c7 44 24 04 f8 0a 00 	movl   $0xaf8,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 17 07 00 00       	call   731 <printf>
  int i;
  for(i = 0; i < 4; i++){ 
  1a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  21:	eb 78                	jmp    9b <productor+0x9b>
    semdown(semprod); // empty
  23:	a1 fc 0e 00 00       	mov    0xefc,%eax
  28:	89 04 24             	mov    %eax,(%esp)
  2b:	e8 01 06 00 00       	call   631 <semdown>
    semdown(sembuff); // mutex
  30:	a1 00 0f 00 00       	mov    0xf00,%eax
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 f4 05 00 00       	call   631 <semdown>
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
  56:	c7 44 24 04 10 0b 00 	movl   $0xb10,0x4(%esp)
  5d:	00 
  5e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  65:	e8 c7 06 00 00       	call   731 <printf>
    semup(sembuff); //mutex
  6a:	a1 00 0f 00 00       	mov    0xf00,%eax
  6f:	89 04 24             	mov    %eax,(%esp)
  72:	e8 c2 05 00 00       	call   639 <semup>
    semup(semcom); // full
  77:	a1 08 0f 00 00       	mov    0xf08,%eax
  7c:	89 04 24             	mov    %eax,(%esp)
  7f:	e8 b5 05 00 00       	call   639 <semup>
    printf(1,"-- Termina Productor --\n");
  84:	c7 44 24 04 34 0b 00 	movl   $0xb34,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 99 06 00 00       	call   731 <printf>
  for(i = 0; i < 4; i++){ 
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
  a9:	c7 44 24 04 4d 0b 00 	movl   $0xb4d,0x4(%esp)
  b0:	00 
  b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b8:	e8 74 06 00 00       	call   731 <printf>
  int i;
  for(i = 0; i < 2; i++){
  bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  c4:	eb 78                	jmp    13e <consumidor+0x9b>
    semdown(semcom); // full
  c6:	a1 08 0f 00 00       	mov    0xf08,%eax
  cb:	89 04 24             	mov    %eax,(%esp)
  ce:	e8 5e 05 00 00       	call   631 <semdown>
    semdown(sembuff); // mutex
  d3:	a1 00 0f 00 00       	mov    0xf00,%eax
  d8:	89 04 24             	mov    %eax,(%esp)
  db:	e8 51 05 00 00       	call   631 <semdown>
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
  f9:	c7 44 24 04 68 0b 00 	movl   $0xb68,0x4(%esp)
 100:	00 
 101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 108:	e8 24 06 00 00       	call   731 <printf>
    semup(sembuff); // mutex
 10d:	a1 00 0f 00 00       	mov    0xf00,%eax
 112:	89 04 24             	mov    %eax,(%esp)
 115:	e8 1f 05 00 00       	call   639 <semup>
    semup(semprod); // empty
 11a:	a1 fc 0e 00 00       	mov    0xefc,%eax
 11f:	89 04 24             	mov    %eax,(%esp)
 122:	e8 12 05 00 00       	call   639 <semup>
    printf(1,"-- Termina Consumidor --\n");
 127:	c7 44 24 04 8d 0b 00 	movl   $0xb8d,0x4(%esp)
 12e:	00 
 12f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 136:	e8 f6 05 00 00       	call   731 <printf>
  for(i = 0; i < 2; i++){
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
 14f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 156:	00 
  *mem = (int)8;   // inicio con 8
 157:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 15b:	c6 00 08             	movb   $0x8,(%eax)
  // int pid_productor, pid_consumidor, i;

  printf(1,"-------------------------- VALOR INICIAL: [%x] \n", *mem);
 15e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 162:	8a 00                	mov    (%eax),%al
 164:	0f be c0             	movsbl %al,%eax
 167:	89 44 24 08          	mov    %eax,0x8(%esp)
 16b:	c7 44 24 04 a8 0b 00 	movl   $0xba8,0x4(%esp)
 172:	00 
 173:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17a:	e8 b2 05 00 00       	call   731 <printf>
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
 17f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 186:	00 
 187:	c7 44 24 04 d9 0b 00 	movl   $0xbd9,0x4(%esp)
 18e:	00 
 18f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 196:	e8 96 05 00 00       	call   731 <printf>
  
  // creo semaforo productor
  semprod = semget(-1,BUFF_SIZE); // empty
 19b:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 1a2:	00 
 1a3:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1aa:	e8 72 04 00 00       	call   621 <semget>
 1af:	a3 fc 0e 00 00       	mov    %eax,0xefc
  if(semprod < 0){
 1b4:	a1 fc 0e 00 00       	mov    0xefc,%eax
 1b9:	85 c0                	test   %eax,%eax
 1bb:	79 19                	jns    1d6 <main+0x90>
    printf(1,"invalid semprod \n");
 1bd:	c7 44 24 04 f4 0b 00 	movl   $0xbf4,0x4(%esp)
 1c4:	00 
 1c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1cc:	e8 60 05 00 00       	call   731 <printf>
    exit();
 1d1:	e8 8b 03 00 00       	call   561 <exit>
  }
  // creo semaforo consumidor 
  semcom = semget(-1,0); // full
 1d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1dd:	00 
 1de:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1e5:	e8 37 04 00 00       	call   621 <semget>
 1ea:	a3 08 0f 00 00       	mov    %eax,0xf08
  if(semcom < 0){
 1ef:	a1 08 0f 00 00       	mov    0xf08,%eax
 1f4:	85 c0                	test   %eax,%eax
 1f6:	79 19                	jns    211 <main+0xcb>
    printf(1,"invalid semcom\n");
 1f8:	c7 44 24 04 06 0c 00 	movl   $0xc06,0x4(%esp)
 1ff:	00 
 200:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 207:	e8 25 05 00 00       	call   731 <printf>
    exit();
 20c:	e8 50 03 00 00       	call   561 <exit>
  }
  // creo semaforo buffer 
  sembuff = semget(-1,1); // mutex
 211:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 218:	00 
 219:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 220:	e8 fc 03 00 00       	call   621 <semget>
 225:	a3 00 0f 00 00       	mov    %eax,0xf00
  if(sembuff < 0){
 22a:	a1 00 0f 00 00       	mov    0xf00,%eax
 22f:	85 c0                	test   %eax,%eax
 231:	79 19                	jns    24c <main+0x106>
    printf(1,"invalid sembuff\n");
 233:	c7 44 24 04 16 0c 00 	movl   $0xc16,0x4(%esp)
 23a:	00 
 23b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 242:	e8 ea 04 00 00       	call   731 <printf>
    exit();
 247:	e8 15 03 00 00       	call   561 <exit>
  //     semget(sembuff,0);
  //     consumidor(mem);
  //     exit();
  //   }
  // }
  if(fork()==0){
 24c:	e8 08 03 00 00       	call   559 <fork>
 251:	85 c0                	test   %eax,%eax
 253:	75 4d                	jne    2a2 <main+0x15c>
     semget(semprod,0);
 255:	a1 fc 0e 00 00       	mov    0xefc,%eax
 25a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 261:	00 
 262:	89 04 24             	mov    %eax,(%esp)
 265:	e8 b7 03 00 00       	call   621 <semget>
      semget(semcom,0);
 26a:	a1 08 0f 00 00       	mov    0xf08,%eax
 26f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 276:	00 
 277:	89 04 24             	mov    %eax,(%esp)
 27a:	e8 a2 03 00 00       	call   621 <semget>
      semget(sembuff,0);
 27f:	a1 00 0f 00 00       	mov    0xf00,%eax
 284:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 28b:	00 
 28c:	89 04 24             	mov    %eax,(%esp)
 28f:	e8 8d 03 00 00       	call   621 <semget>
     productor(mem);
 294:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 60 fd ff ff       	call   0 <productor>
 2a0:	eb 50                	jmp    2f2 <main+0x1ac>

  }else{
     semget(semprod,0);
 2a2:	a1 fc 0e 00 00       	mov    0xefc,%eax
 2a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ae:	00 
 2af:	89 04 24             	mov    %eax,(%esp)
 2b2:	e8 6a 03 00 00       	call   621 <semget>
      semget(semcom,0);
 2b7:	a1 08 0f 00 00       	mov    0xf08,%eax
 2bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2c3:	00 
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 55 03 00 00       	call   621 <semget>
      semget(sembuff,0);
 2cc:	a1 00 0f 00 00       	mov    0xf00,%eax
 2d1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d8:	00 
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 40 03 00 00       	call   621 <semget>
     consumidor(mem);
 2e1:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 2e5:	89 04 24             	mov    %eax,(%esp)
 2e8:	e8 b6 fd ff ff       	call   a3 <consumidor>
     wait();
 2ed:	e8 77 02 00 00       	call   569 <wait>
   }
   
  printf(1,"-------------------------- VALOR FINAL: [%x]  \n", *mem);
 2f2:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 2f6:	8a 00                	mov    (%eax),%al
 2f8:	0f be c0             	movsbl %al,%eax
 2fb:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ff:	c7 44 24 04 28 0c 00 	movl   $0xc28,0x4(%esp)
 306:	00 
 307:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 30e:	e8 1e 04 00 00       	call   731 <printf>
  exit();
 313:	e8 49 02 00 00       	call   561 <exit>

00000318 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	57                   	push   %edi
 31c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 31d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 320:	8b 55 10             	mov    0x10(%ebp),%edx
 323:	8b 45 0c             	mov    0xc(%ebp),%eax
 326:	89 cb                	mov    %ecx,%ebx
 328:	89 df                	mov    %ebx,%edi
 32a:	89 d1                	mov    %edx,%ecx
 32c:	fc                   	cld    
 32d:	f3 aa                	rep stos %al,%es:(%edi)
 32f:	89 ca                	mov    %ecx,%edx
 331:	89 fb                	mov    %edi,%ebx
 333:	89 5d 08             	mov    %ebx,0x8(%ebp)
 336:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 339:	5b                   	pop    %ebx
 33a:	5f                   	pop    %edi
 33b:	5d                   	pop    %ebp
 33c:	c3                   	ret    

0000033d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 349:	90                   	nop
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	8a 10                	mov    (%eax),%dl
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	88 10                	mov    %dl,(%eax)
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	8a 00                	mov    (%eax),%al
 359:	84 c0                	test   %al,%al
 35b:	0f 95 c0             	setne  %al
 35e:	ff 45 08             	incl   0x8(%ebp)
 361:	ff 45 0c             	incl   0xc(%ebp)
 364:	84 c0                	test   %al,%al
 366:	75 e2                	jne    34a <strcpy+0xd>
    ;
  return os;
 368:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 370:	eb 06                	jmp    378 <strcmp+0xb>
    p++, q++;
 372:	ff 45 08             	incl   0x8(%ebp)
 375:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	8a 00                	mov    (%eax),%al
 37d:	84 c0                	test   %al,%al
 37f:	74 0e                	je     38f <strcmp+0x22>
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	8a 10                	mov    (%eax),%dl
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	8a 00                	mov    (%eax),%al
 38b:	38 c2                	cmp    %al,%dl
 38d:	74 e3                	je     372 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	8a 00                	mov    (%eax),%al
 394:	0f b6 d0             	movzbl %al,%edx
 397:	8b 45 0c             	mov    0xc(%ebp),%eax
 39a:	8a 00                	mov    (%eax),%al
 39c:	0f b6 c0             	movzbl %al,%eax
 39f:	89 d1                	mov    %edx,%ecx
 3a1:	29 c1                	sub    %eax,%ecx
 3a3:	89 c8                	mov    %ecx,%eax
}
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    

000003a7 <strlen>:

uint
strlen(char *s)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3b4:	eb 03                	jmp    3b9 <strlen+0x12>
 3b6:	ff 45 fc             	incl   -0x4(%ebp)
 3b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	01 d0                	add    %edx,%eax
 3c1:	8a 00                	mov    (%eax),%al
 3c3:	84 c0                	test   %al,%al
 3c5:	75 ef                	jne    3b6 <strlen+0xf>
    ;
  return n;
 3c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <memset>:

void*
memset(void *dst, int c, uint n)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3d2:	8b 45 10             	mov    0x10(%ebp),%eax
 3d5:	89 44 24 08          	mov    %eax,0x8(%esp)
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	89 04 24             	mov    %eax,(%esp)
 3e6:	e8 2d ff ff ff       	call   318 <stosb>
  return dst;
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ee:	c9                   	leave  
 3ef:	c3                   	ret    

000003f0 <strchr>:

char*
strchr(const char *s, char c)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	83 ec 04             	sub    $0x4,%esp
 3f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3fc:	eb 12                	jmp    410 <strchr+0x20>
    if(*s == c)
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	8a 00                	mov    (%eax),%al
 403:	3a 45 fc             	cmp    -0x4(%ebp),%al
 406:	75 05                	jne    40d <strchr+0x1d>
      return (char*)s;
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	eb 11                	jmp    41e <strchr+0x2e>
  for(; *s; s++)
 40d:	ff 45 08             	incl   0x8(%ebp)
 410:	8b 45 08             	mov    0x8(%ebp),%eax
 413:	8a 00                	mov    (%eax),%al
 415:	84 c0                	test   %al,%al
 417:	75 e5                	jne    3fe <strchr+0xe>
  return 0;
 419:	b8 00 00 00 00       	mov    $0x0,%eax
}
 41e:	c9                   	leave  
 41f:	c3                   	ret    

00000420 <gets>:

char*
gets(char *buf, int max)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 42d:	eb 42                	jmp    471 <gets+0x51>
    cc = read(0, &c, 1);
 42f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 436:	00 
 437:	8d 45 ef             	lea    -0x11(%ebp),%eax
 43a:	89 44 24 04          	mov    %eax,0x4(%esp)
 43e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 445:	e8 2f 01 00 00       	call   579 <read>
 44a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 44d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 451:	7e 29                	jle    47c <gets+0x5c>
      break;
    buf[i++] = c;
 453:	8b 55 f4             	mov    -0xc(%ebp),%edx
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	01 c2                	add    %eax,%edx
 45b:	8a 45 ef             	mov    -0x11(%ebp),%al
 45e:	88 02                	mov    %al,(%edx)
 460:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 463:	8a 45 ef             	mov    -0x11(%ebp),%al
 466:	3c 0a                	cmp    $0xa,%al
 468:	74 13                	je     47d <gets+0x5d>
 46a:	8a 45 ef             	mov    -0x11(%ebp),%al
 46d:	3c 0d                	cmp    $0xd,%al
 46f:	74 0c                	je     47d <gets+0x5d>
  for(i=0; i+1 < max; ){
 471:	8b 45 f4             	mov    -0xc(%ebp),%eax
 474:	40                   	inc    %eax
 475:	3b 45 0c             	cmp    0xc(%ebp),%eax
 478:	7c b5                	jl     42f <gets+0xf>
 47a:	eb 01                	jmp    47d <gets+0x5d>
      break;
 47c:	90                   	nop
      break;
  }
  buf[i] = '\0';
 47d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	01 d0                	add    %edx,%eax
 485:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 488:	8b 45 08             	mov    0x8(%ebp),%eax
}
 48b:	c9                   	leave  
 48c:	c3                   	ret    

0000048d <stat>:

int
stat(char *n, struct stat *st)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 493:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 49a:	00 
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	89 04 24             	mov    %eax,(%esp)
 4a1:	e8 fb 00 00 00       	call   5a1 <open>
 4a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ad:	79 07                	jns    4b6 <stat+0x29>
    return -1;
 4af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4b4:	eb 23                	jmp    4d9 <stat+0x4c>
  r = fstat(fd, st);
 4b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c0:	89 04 24             	mov    %eax,(%esp)
 4c3:	e8 f1 00 00 00       	call   5b9 <fstat>
 4c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ce:	89 04 24             	mov    %eax,(%esp)
 4d1:	e8 b3 00 00 00       	call   589 <close>
  return r;
 4d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4d9:	c9                   	leave  
 4da:	c3                   	ret    

000004db <atoi>:

int
atoi(const char *s)
{
 4db:	55                   	push   %ebp
 4dc:	89 e5                	mov    %esp,%ebp
 4de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4e8:	eb 21                	jmp    50b <atoi+0x30>
    n = n*10 + *s++ - '0';
 4ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ed:	89 d0                	mov    %edx,%eax
 4ef:	c1 e0 02             	shl    $0x2,%eax
 4f2:	01 d0                	add    %edx,%eax
 4f4:	d1 e0                	shl    %eax
 4f6:	89 c2                	mov    %eax,%edx
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	8a 00                	mov    (%eax),%al
 4fd:	0f be c0             	movsbl %al,%eax
 500:	01 d0                	add    %edx,%eax
 502:	83 e8 30             	sub    $0x30,%eax
 505:	89 45 fc             	mov    %eax,-0x4(%ebp)
 508:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	8a 00                	mov    (%eax),%al
 510:	3c 2f                	cmp    $0x2f,%al
 512:	7e 09                	jle    51d <atoi+0x42>
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	8a 00                	mov    (%eax),%al
 519:	3c 39                	cmp    $0x39,%al
 51b:	7e cd                	jle    4ea <atoi+0xf>
  return n;
 51d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 520:	c9                   	leave  
 521:	c3                   	ret    

00000522 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 522:	55                   	push   %ebp
 523:	89 e5                	mov    %esp,%ebp
 525:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 52e:	8b 45 0c             	mov    0xc(%ebp),%eax
 531:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 534:	eb 10                	jmp    546 <memmove+0x24>
    *dst++ = *src++;
 536:	8b 45 f8             	mov    -0x8(%ebp),%eax
 539:	8a 10                	mov    (%eax),%dl
 53b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 53e:	88 10                	mov    %dl,(%eax)
 540:	ff 45 fc             	incl   -0x4(%ebp)
 543:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 546:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 54a:	0f 9f c0             	setg   %al
 54d:	ff 4d 10             	decl   0x10(%ebp)
 550:	84 c0                	test   %al,%al
 552:	75 e2                	jne    536 <memmove+0x14>
  return vdst;
 554:	8b 45 08             	mov    0x8(%ebp),%eax
}
 557:	c9                   	leave  
 558:	c3                   	ret    

00000559 <fork>:
 559:	b8 01 00 00 00       	mov    $0x1,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <exit>:
 561:	b8 02 00 00 00       	mov    $0x2,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <wait>:
 569:	b8 03 00 00 00       	mov    $0x3,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <pipe>:
 571:	b8 04 00 00 00       	mov    $0x4,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <read>:
 579:	b8 05 00 00 00       	mov    $0x5,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <write>:
 581:	b8 10 00 00 00       	mov    $0x10,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <close>:
 589:	b8 15 00 00 00       	mov    $0x15,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <kill>:
 591:	b8 06 00 00 00       	mov    $0x6,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <exec>:
 599:	b8 07 00 00 00       	mov    $0x7,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <open>:
 5a1:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <mknod>:
 5a9:	b8 11 00 00 00       	mov    $0x11,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <unlink>:
 5b1:	b8 12 00 00 00       	mov    $0x12,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <fstat>:
 5b9:	b8 08 00 00 00       	mov    $0x8,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <link>:
 5c1:	b8 13 00 00 00       	mov    $0x13,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <mkdir>:
 5c9:	b8 14 00 00 00       	mov    $0x14,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <chdir>:
 5d1:	b8 09 00 00 00       	mov    $0x9,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <dup>:
 5d9:	b8 0a 00 00 00       	mov    $0xa,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <getpid>:
 5e1:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <sbrk>:
 5e9:	b8 0c 00 00 00       	mov    $0xc,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <sleep>:
 5f1:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <uptime>:
 5f9:	b8 0e 00 00 00       	mov    $0xe,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <lseek>:
 601:	b8 16 00 00 00       	mov    $0x16,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <isatty>:
 609:	b8 17 00 00 00       	mov    $0x17,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <procstat>:
 611:	b8 18 00 00 00       	mov    $0x18,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <set_priority>:
 619:	b8 19 00 00 00       	mov    $0x19,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <semget>:
 621:	b8 1a 00 00 00       	mov    $0x1a,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <semfree>:
 629:	b8 1b 00 00 00       	mov    $0x1b,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <semdown>:
 631:	b8 1c 00 00 00       	mov    $0x1c,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <semup>:
 639:	b8 1d 00 00 00       	mov    $0x1d,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <shm_create>:
 641:	b8 1e 00 00 00       	mov    $0x1e,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <shm_close>:
 649:	b8 1f 00 00 00       	mov    $0x1f,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <shm_get>:
 651:	b8 20 00 00 00       	mov    $0x20,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 28             	sub    $0x28,%esp
 65f:	8b 45 0c             	mov    0xc(%ebp),%eax
 662:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 665:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 66c:	00 
 66d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 670:	89 44 24 04          	mov    %eax,0x4(%esp)
 674:	8b 45 08             	mov    0x8(%ebp),%eax
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 02 ff ff ff       	call   581 <write>
}
 67f:	c9                   	leave  
 680:	c3                   	ret    

00000681 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 681:	55                   	push   %ebp
 682:	89 e5                	mov    %esp,%ebp
 684:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 687:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 68e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 692:	74 17                	je     6ab <printint+0x2a>
 694:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 698:	79 11                	jns    6ab <printint+0x2a>
    neg = 1;
 69a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a4:	f7 d8                	neg    %eax
 6a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a9:	eb 06                	jmp    6b1 <printint+0x30>
  } else {
    x = xx;
 6ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6be:	ba 00 00 00 00       	mov    $0x0,%edx
 6c3:	f7 f1                	div    %ecx
 6c5:	89 d0                	mov    %edx,%eax
 6c7:	8a 80 dc 0e 00 00    	mov    0xedc(%eax),%al
 6cd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6d3:	01 ca                	add    %ecx,%edx
 6d5:	88 02                	mov    %al,(%edx)
 6d7:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 6da:	8b 55 10             	mov    0x10(%ebp),%edx
 6dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e3:	ba 00 00 00 00       	mov    $0x0,%edx
 6e8:	f7 75 d4             	divl   -0x2c(%ebp)
 6eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f2:	75 c4                	jne    6b8 <printint+0x37>
  if(neg)
 6f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f8:	74 2c                	je     726 <printint+0xa5>
    buf[i++] = '-';
 6fa:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	01 d0                	add    %edx,%eax
 702:	c6 00 2d             	movb   $0x2d,(%eax)
 705:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 708:	eb 1c                	jmp    726 <printint+0xa5>
    putc(fd, buf[i]);
 70a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	01 d0                	add    %edx,%eax
 712:	8a 00                	mov    (%eax),%al
 714:	0f be c0             	movsbl %al,%eax
 717:	89 44 24 04          	mov    %eax,0x4(%esp)
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 33 ff ff ff       	call   659 <putc>
  while(--i >= 0)
 726:	ff 4d f4             	decl   -0xc(%ebp)
 729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72d:	79 db                	jns    70a <printint+0x89>
}
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 737:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 73e:	8d 45 0c             	lea    0xc(%ebp),%eax
 741:	83 c0 04             	add    $0x4,%eax
 744:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 747:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 74e:	e9 78 01 00 00       	jmp    8cb <printf+0x19a>
    c = fmt[i] & 0xff;
 753:	8b 55 0c             	mov    0xc(%ebp),%edx
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	01 d0                	add    %edx,%eax
 75b:	8a 00                	mov    (%eax),%al
 75d:	0f be c0             	movsbl %al,%eax
 760:	25 ff 00 00 00       	and    $0xff,%eax
 765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 768:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 76c:	75 2c                	jne    79a <printf+0x69>
      if(c == '%'){
 76e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 772:	75 0c                	jne    780 <printf+0x4f>
        state = '%';
 774:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 77b:	e9 48 01 00 00       	jmp    8c8 <printf+0x197>
      } else {
        putc(fd, c);
 780:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 783:	0f be c0             	movsbl %al,%eax
 786:	89 44 24 04          	mov    %eax,0x4(%esp)
 78a:	8b 45 08             	mov    0x8(%ebp),%eax
 78d:	89 04 24             	mov    %eax,(%esp)
 790:	e8 c4 fe ff ff       	call   659 <putc>
 795:	e9 2e 01 00 00       	jmp    8c8 <printf+0x197>
      }
    } else if(state == '%'){
 79a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 79e:	0f 85 24 01 00 00    	jne    8c8 <printf+0x197>
      if(c == 'd'){
 7a4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7a8:	75 2d                	jne    7d7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7b6:	00 
 7b7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7be:	00 
 7bf:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	89 04 24             	mov    %eax,(%esp)
 7c9:	e8 b3 fe ff ff       	call   681 <printint>
        ap++;
 7ce:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d2:	e9 ea 00 00 00       	jmp    8c1 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 7d7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7db:	74 06                	je     7e3 <printf+0xb2>
 7dd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7e1:	75 2d                	jne    810 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 7e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7ef:	00 
 7f0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7f7:	00 
 7f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	89 04 24             	mov    %eax,(%esp)
 802:	e8 7a fe ff ff       	call   681 <printint>
        ap++;
 807:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80b:	e9 b1 00 00 00       	jmp    8c1 <printf+0x190>
      } else if(c == 's'){
 810:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 814:	75 43                	jne    859 <printf+0x128>
        s = (char*)*ap;
 816:	8b 45 e8             	mov    -0x18(%ebp),%eax
 819:	8b 00                	mov    (%eax),%eax
 81b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 81e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 826:	75 25                	jne    84d <printf+0x11c>
          s = "(null)";
 828:	c7 45 f4 58 0c 00 00 	movl   $0xc58,-0xc(%ebp)
        while(*s != 0){
 82f:	eb 1c                	jmp    84d <printf+0x11c>
          putc(fd, *s);
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8a 00                	mov    (%eax),%al
 836:	0f be c0             	movsbl %al,%eax
 839:	89 44 24 04          	mov    %eax,0x4(%esp)
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	89 04 24             	mov    %eax,(%esp)
 843:	e8 11 fe ff ff       	call   659 <putc>
          s++;
 848:	ff 45 f4             	incl   -0xc(%ebp)
 84b:	eb 01                	jmp    84e <printf+0x11d>
        while(*s != 0){
 84d:	90                   	nop
 84e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 851:	8a 00                	mov    (%eax),%al
 853:	84 c0                	test   %al,%al
 855:	75 da                	jne    831 <printf+0x100>
 857:	eb 68                	jmp    8c1 <printf+0x190>
        }
      } else if(c == 'c'){
 859:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 85d:	75 1d                	jne    87c <printf+0x14b>
        putc(fd, *ap);
 85f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	0f be c0             	movsbl %al,%eax
 867:	89 44 24 04          	mov    %eax,0x4(%esp)
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	89 04 24             	mov    %eax,(%esp)
 871:	e8 e3 fd ff ff       	call   659 <putc>
        ap++;
 876:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 87a:	eb 45                	jmp    8c1 <printf+0x190>
      } else if(c == '%'){
 87c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 880:	75 17                	jne    899 <printf+0x168>
        putc(fd, c);
 882:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 885:	0f be c0             	movsbl %al,%eax
 888:	89 44 24 04          	mov    %eax,0x4(%esp)
 88c:	8b 45 08             	mov    0x8(%ebp),%eax
 88f:	89 04 24             	mov    %eax,(%esp)
 892:	e8 c2 fd ff ff       	call   659 <putc>
 897:	eb 28                	jmp    8c1 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 899:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8a0:	00 
 8a1:	8b 45 08             	mov    0x8(%ebp),%eax
 8a4:	89 04 24             	mov    %eax,(%esp)
 8a7:	e8 ad fd ff ff       	call   659 <putc>
        putc(fd, c);
 8ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8af:	0f be c0             	movsbl %al,%eax
 8b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b6:	8b 45 08             	mov    0x8(%ebp),%eax
 8b9:	89 04 24             	mov    %eax,(%esp)
 8bc:	e8 98 fd ff ff       	call   659 <putc>
      }
      state = 0;
 8c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8c8:	ff 45 f0             	incl   -0x10(%ebp)
 8cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	01 d0                	add    %edx,%eax
 8d3:	8a 00                	mov    (%eax),%al
 8d5:	84 c0                	test   %al,%al
 8d7:	0f 85 76 fe ff ff    	jne    753 <printf+0x22>
    }
  }
}
 8dd:	c9                   	leave  
 8de:	c3                   	ret    

000008df <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8df:	55                   	push   %ebp
 8e0:	89 e5                	mov    %esp,%ebp
 8e2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	83 e8 08             	sub    $0x8,%eax
 8eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ee:	a1 f8 0e 00 00       	mov    0xef8,%eax
 8f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f6:	eb 24                	jmp    91c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	8b 00                	mov    (%eax),%eax
 8fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 900:	77 12                	ja     914 <free+0x35>
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 908:	77 24                	ja     92e <free+0x4f>
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 912:	77 1a                	ja     92e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	8b 00                	mov    (%eax),%eax
 919:	89 45 fc             	mov    %eax,-0x4(%ebp)
 91c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 922:	76 d4                	jbe    8f8 <free+0x19>
 924:	8b 45 fc             	mov    -0x4(%ebp),%eax
 927:	8b 00                	mov    (%eax),%eax
 929:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92c:	76 ca                	jbe    8f8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 931:	8b 40 04             	mov    0x4(%eax),%eax
 934:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93e:	01 c2                	add    %eax,%edx
 940:	8b 45 fc             	mov    -0x4(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	39 c2                	cmp    %eax,%edx
 947:	75 24                	jne    96d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 949:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94c:	8b 50 04             	mov    0x4(%eax),%edx
 94f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	01 c2                	add    %eax,%edx
 959:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	8b 10                	mov    (%eax),%edx
 966:	8b 45 f8             	mov    -0x8(%ebp),%eax
 969:	89 10                	mov    %edx,(%eax)
 96b:	eb 0a                	jmp    977 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	8b 10                	mov    (%eax),%edx
 972:	8b 45 f8             	mov    -0x8(%ebp),%eax
 975:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 977:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97a:	8b 40 04             	mov    0x4(%eax),%eax
 97d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 984:	8b 45 fc             	mov    -0x4(%ebp),%eax
 987:	01 d0                	add    %edx,%eax
 989:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 98c:	75 20                	jne    9ae <free+0xcf>
    p->s.size += bp->s.size;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 50 04             	mov    0x4(%eax),%edx
 994:	8b 45 f8             	mov    -0x8(%ebp),%eax
 997:	8b 40 04             	mov    0x4(%eax),%eax
 99a:	01 c2                	add    %eax,%edx
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a5:	8b 10                	mov    (%eax),%edx
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	89 10                	mov    %edx,(%eax)
 9ac:	eb 08                	jmp    9b6 <free+0xd7>
  } else
    p->s.ptr = bp;
 9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9b4:	89 10                	mov    %edx,(%eax)
  freep = p;
 9b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b9:	a3 f8 0e 00 00       	mov    %eax,0xef8
}
 9be:	c9                   	leave  
 9bf:	c3                   	ret    

000009c0 <morecore>:

static Header*
morecore(uint nu)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9c6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9cd:	77 07                	ja     9d6 <morecore+0x16>
    nu = 4096;
 9cf:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9d6:	8b 45 08             	mov    0x8(%ebp),%eax
 9d9:	c1 e0 03             	shl    $0x3,%eax
 9dc:	89 04 24             	mov    %eax,(%esp)
 9df:	e8 05 fc ff ff       	call   5e9 <sbrk>
 9e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9eb:	75 07                	jne    9f4 <morecore+0x34>
    return 0;
 9ed:	b8 00 00 00 00       	mov    $0x0,%eax
 9f2:	eb 22                	jmp    a16 <morecore+0x56>
  hp = (Header*)p;
 9f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fd:	8b 55 08             	mov    0x8(%ebp),%edx
 a00:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a06:	83 c0 08             	add    $0x8,%eax
 a09:	89 04 24             	mov    %eax,(%esp)
 a0c:	e8 ce fe ff ff       	call   8df <free>
  return freep;
 a11:	a1 f8 0e 00 00       	mov    0xef8,%eax
}
 a16:	c9                   	leave  
 a17:	c3                   	ret    

00000a18 <malloc>:

void*
malloc(uint nbytes)
{
 a18:	55                   	push   %ebp
 a19:	89 e5                	mov    %esp,%ebp
 a1b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a1e:	8b 45 08             	mov    0x8(%ebp),%eax
 a21:	83 c0 07             	add    $0x7,%eax
 a24:	c1 e8 03             	shr    $0x3,%eax
 a27:	40                   	inc    %eax
 a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a2b:	a1 f8 0e 00 00       	mov    0xef8,%eax
 a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a37:	75 23                	jne    a5c <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a39:	c7 45 f0 f0 0e 00 00 	movl   $0xef0,-0x10(%ebp)
 a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a43:	a3 f8 0e 00 00       	mov    %eax,0xef8
 a48:	a1 f8 0e 00 00       	mov    0xef8,%eax
 a4d:	a3 f0 0e 00 00       	mov    %eax,0xef0
    base.s.size = 0;
 a52:	c7 05 f4 0e 00 00 00 	movl   $0x0,0xef4
 a59:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5f:	8b 00                	mov    (%eax),%eax
 a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	8b 40 04             	mov    0x4(%eax),%eax
 a6a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a6d:	72 4d                	jb     abc <malloc+0xa4>
      if(p->s.size == nunits)
 a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a72:	8b 40 04             	mov    0x4(%eax),%eax
 a75:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a78:	75 0c                	jne    a86 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	8b 10                	mov    (%eax),%edx
 a7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a82:	89 10                	mov    %edx,(%eax)
 a84:	eb 26                	jmp    aac <malloc+0x94>
      else {
        p->s.size -= nunits;
 a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a89:	8b 40 04             	mov    0x4(%eax),%eax
 a8c:	89 c2                	mov    %eax,%edx
 a8e:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a94:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9a:	8b 40 04             	mov    0x4(%eax),%eax
 a9d:	c1 e0 03             	shl    $0x3,%eax
 aa0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aa9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aaf:	a3 f8 0e 00 00       	mov    %eax,0xef8
      return (void*)(p + 1);
 ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab7:	83 c0 08             	add    $0x8,%eax
 aba:	eb 38                	jmp    af4 <malloc+0xdc>
    }
    if(p == freep)
 abc:	a1 f8 0e 00 00       	mov    0xef8,%eax
 ac1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ac4:	75 1b                	jne    ae1 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac9:	89 04 24             	mov    %eax,(%esp)
 acc:	e8 ef fe ff ff       	call   9c0 <morecore>
 ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ad4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad8:	75 07                	jne    ae1 <malloc+0xc9>
        return 0;
 ada:	b8 00 00 00 00       	mov    $0x0,%eax
 adf:	eb 13                	jmp    af4 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aea:	8b 00                	mov    (%eax),%eax
 aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 aef:	e9 70 ff ff ff       	jmp    a64 <malloc+0x4c>
}
 af4:	c9                   	leave  
 af5:	c3                   	ret    
