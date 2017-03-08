
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
  printf(1,"-- Inicia Productor --\n");
   6:	c7 44 24 04 38 0b 00 	movl   $0xb38,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 58 07 00 00       	call   772 <printf>
  semdown(semprod); // empty
  1a:	a1 3c 0f 00 00       	mov    0xf3c,%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 4b 06 00 00       	call   672 <semdown>
  semdown(sembuff); // mutex
  27:	a1 44 0f 00 00       	mov    0xf44,%eax
  2c:	89 04 24             	mov    %eax,(%esp)
  2f:	e8 3e 06 00 00       	call   672 <semdown>
  //  REGION CRITICA
  val = (val) + 1;
  34:	ff 45 08             	incl   0x8(%ebp)
  //
  semup(sembuff); //mutex
  37:	a1 44 0f 00 00       	mov    0xf44,%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 36 06 00 00       	call   67a <semup>
  semup(semcom); // full
  44:	a1 50 0f 00 00       	mov    0xf50,%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 29 06 00 00       	call   67a <semup>
  printf(1,"-- Termina Productor --\n");
  51:	c7 44 24 04 50 0b 00 	movl   $0xb50,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 0d 07 00 00       	call   772 <printf>
}
  65:	c9                   	leave  
  66:	c3                   	ret    

00000067 <consumidor>:

void
consumidor(int val)
{ 
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	83 ec 18             	sub    $0x18,%esp
  printf(1,"-- Inicia Consumidor --\n");
  6d:	c7 44 24 04 69 0b 00 	movl   $0xb69,0x4(%esp)
  74:	00 
  75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7c:	e8 f1 06 00 00       	call   772 <printf>
  semdown(semcom); // full
  81:	a1 50 0f 00 00       	mov    0xf50,%eax
  86:	89 04 24             	mov    %eax,(%esp)
  89:	e8 e4 05 00 00       	call   672 <semdown>
  semdown(sembuff); // mutex
  8e:	a1 44 0f 00 00       	mov    0xf44,%eax
  93:	89 04 24             	mov    %eax,(%esp)
  96:	e8 d7 05 00 00       	call   672 <semdown>
  // REGION CRITICA
  val = (val) - 1;
  9b:	ff 4d 08             	decl   0x8(%ebp)
  //
  semup(sembuff); // mutex
  9e:	a1 44 0f 00 00       	mov    0xf44,%eax
  a3:	89 04 24             	mov    %eax,(%esp)
  a6:	e8 cf 05 00 00       	call   67a <semup>
  semup(semprod); // empty
  ab:	a1 3c 0f 00 00       	mov    0xf3c,%eax
  b0:	89 04 24             	mov    %eax,(%esp)
  b3:	e8 c2 05 00 00       	call   67a <semup>
  printf(1,"-- Termina Consumidor --\n");
  b8:	c7 44 24 04 82 0b 00 	movl   $0xb82,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 a6 06 00 00       	call   772 <printf>
  //}
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <main>:

int
main(void)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  d1:	83 e4 f0             	and    $0xfffffff0,%esp
  d4:	83 ec 20             	sub    $0x20,%esp
  int val = 8; 
  d7:	c7 44 24 18 08 00 00 	movl   $0x8,0x18(%esp)
  de:	00 
  int i;

  printf(1,"-------------------------- VALOR INICIAL: [%d] \n", val);
  df:	8b 44 24 18          	mov    0x18(%esp),%eax
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 9c 0b 00 	movl   $0xb9c,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 77 06 00 00       	call   772 <printf>
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
  fb:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 102:	00 
 103:	c7 44 24 04 cd 0b 00 	movl   $0xbcd,0x4(%esp)
 10a:	00 
 10b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 112:	e8 5b 06 00 00       	call   772 <printf>
  
  // creo semaforo productor 
  semprod = semget(-1,BUFF_SIZE); // empty
 117:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 11e:	00 
 11f:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 126:	e8 37 05 00 00       	call   662 <semget>
 12b:	a3 3c 0f 00 00       	mov    %eax,0xf3c
  // semprod es cero
  if(semprod < 0){
 130:	a1 3c 0f 00 00       	mov    0xf3c,%eax
 135:	85 c0                	test   %eax,%eax
 137:	79 19                	jns    152 <main+0x84>
    printf(1,"invalid semprod \n");
 139:	c7 44 24 04 e8 0b 00 	movl   $0xbe8,0x4(%esp)
 140:	00 
 141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 148:	e8 25 06 00 00       	call   772 <printf>
    exit();
 14d:	e8 50 04 00 00       	call   5a2 <exit>
  }
  // creo semaforo consumidor
  semcom = semget(-1,0); // full   // printf(1,"LOG semprod %d\n", semcom);
 152:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 159:	00 
 15a:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 161:	e8 fc 04 00 00       	call   662 <semget>
 166:	a3 50 0f 00 00       	mov    %eax,0xf50
  if(semcom < 0){
 16b:	a1 50 0f 00 00       	mov    0xf50,%eax
 170:	85 c0                	test   %eax,%eax
 172:	79 19                	jns    18d <main+0xbf>
    printf(1,"invalid semcom\n");
 174:	c7 44 24 04 fa 0b 00 	movl   $0xbfa,0x4(%esp)
 17b:	00 
 17c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 183:	e8 ea 05 00 00       	call   772 <printf>
    exit();
 188:	e8 15 04 00 00       	call   5a2 <exit>
  }
  // creo semaforo buffer
  sembuff = semget(-1,1); // mutex // printf(1,"LOG semprod %d\n", sembuff);
 18d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 194:	00 
 195:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 19c:	e8 c1 04 00 00       	call   662 <semget>
 1a1:	a3 44 0f 00 00       	mov    %eax,0xf44
  if(sembuff < 0){
 1a6:	a1 44 0f 00 00       	mov    0xf44,%eax
 1ab:	85 c0                	test   %eax,%eax
 1ad:	79 19                	jns    1c8 <main+0xfa>
    printf(1,"invalid sembuff\n");
 1af:	c7 44 24 04 0a 0c 00 	movl   $0xc0a,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 af 05 00 00       	call   772 <printf>
    exit();
 1c3:	e8 da 03 00 00       	call   5a2 <exit>
  }


  // CREO SEMAFORO DE PRUEBA
  semprueba = semget(-1,5); // prueba
 1c8:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
 1cf:	00 
 1d0:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1d7:	e8 86 04 00 00       	call   662 <semget>
 1dc:	a3 48 0f 00 00       	mov    %eax,0xf48
  printf(1,"LOG: identificador del semaforo: %d\n", semprueba); 
 1e1:	a1 48 0f 00 00       	mov    0xf48,%eax
 1e6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ea:	c7 44 24 04 1c 0c 00 	movl   $0xc1c,0x4(%esp)
 1f1:	00 
 1f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f9:	e8 74 05 00 00       	call   772 <printf>
  if(sembuff < 0){
 1fe:	a1 44 0f 00 00       	mov    0xf44,%eax
 203:	85 c0                	test   %eax,%eax
 205:	79 19                	jns    220 <main+0x152>
    printf(1,"invalid semprueba\n");
 207:	c7 44 24 04 41 0c 00 	movl   $0xc41,0x4(%esp)
 20e:	00 
 20f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 216:	e8 57 05 00 00       	call   772 <printf>
    exit();
 21b:	e8 82 03 00 00       	call   5a2 <exit>
  }

  semprueba2 = semget(-1,6); // prueba
 220:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
 227:	00 
 228:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 22f:	e8 2e 04 00 00       	call   662 <semget>
 234:	a3 40 0f 00 00       	mov    %eax,0xf40
  printf(1,"LOG: identificador del semaforo: %d\n", semprueba2); 
 239:	a1 40 0f 00 00       	mov    0xf40,%eax
 23e:	89 44 24 08          	mov    %eax,0x8(%esp)
 242:	c7 44 24 04 1c 0c 00 	movl   $0xc1c,0x4(%esp)
 249:	00 
 24a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 251:	e8 1c 05 00 00       	call   772 <printf>
  if(sembuff < 0){
 256:	a1 44 0f 00 00       	mov    0xf44,%eax
 25b:	85 c0                	test   %eax,%eax
 25d:	79 19                	jns    278 <main+0x1aa>
    printf(1,"invalid semprueba2\n");
 25f:	c7 44 24 04 54 0c 00 	movl   $0xc54,0x4(%esp)
 266:	00 
 267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26e:	e8 ff 04 00 00       	call   772 <printf>
    exit();
 273:	e8 2a 03 00 00       	call   5a2 <exit>
  }


  for (i = 0; i < 4; i++) { 
 278:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 27f:	00 
 280:	eb 4f                	jmp    2d1 <main+0x203>
    semget(semprod,0);
 282:	a1 3c 0f 00 00       	mov    0xf3c,%eax
 287:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 28e:	00 
 28f:	89 04 24             	mov    %eax,(%esp)
 292:	e8 cb 03 00 00       	call   662 <semget>
    semget(semcom,0);
 297:	a1 50 0f 00 00       	mov    0xf50,%eax
 29c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a3:	00 
 2a4:	89 04 24             	mov    %eax,(%esp)
 2a7:	e8 b6 03 00 00       	call   662 <semget>
    semget(sembuff,0);
 2ac:	a1 44 0f 00 00       	mov    0xf44,%eax
 2b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b8:	00 
 2b9:	89 04 24             	mov    %eax,(%esp)
 2bc:	e8 a1 03 00 00       	call   662 <semget>
    productor(val);
 2c1:	8b 44 24 18          	mov    0x18(%esp),%eax
 2c5:	89 04 24             	mov    %eax,(%esp)
 2c8:	e8 33 fd ff ff       	call   0 <productor>
  for (i = 0; i < 4; i++) { 
 2cd:	ff 44 24 1c          	incl   0x1c(%esp)
 2d1:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
 2d6:	7e aa                	jle    282 <main+0x1b4>
  }

  for (i = 0; i < 3; i++) { 
 2d8:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 2df:	00 
 2e0:	eb 4f                	jmp    331 <main+0x263>
    semget(semprod,0);
 2e2:	a1 3c 0f 00 00       	mov    0xf3c,%eax
 2e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ee:	00 
 2ef:	89 04 24             	mov    %eax,(%esp)
 2f2:	e8 6b 03 00 00       	call   662 <semget>
    semget(semcom,0);
 2f7:	a1 50 0f 00 00       	mov    0xf50,%eax
 2fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 303:	00 
 304:	89 04 24             	mov    %eax,(%esp)
 307:	e8 56 03 00 00       	call   662 <semget>
    semget(sembuff,0);
 30c:	a1 44 0f 00 00       	mov    0xf44,%eax
 311:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 318:	00 
 319:	89 04 24             	mov    %eax,(%esp)
 31c:	e8 41 03 00 00       	call   662 <semget>
    consumidor(val); 
 321:	8b 44 24 18          	mov    0x18(%esp),%eax
 325:	89 04 24             	mov    %eax,(%esp)
 328:	e8 3a fd ff ff       	call   67 <consumidor>
  for (i = 0; i < 3; i++) { 
 32d:	ff 44 24 1c          	incl   0x1c(%esp)
 331:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
 336:	7e aa                	jle    2e2 <main+0x214>
  }

  printf(1,"-------------------------- VALOR FINAL: [%d]  \n", val);
 338:	8b 44 24 18          	mov    0x18(%esp),%eax
 33c:	89 44 24 08          	mov    %eax,0x8(%esp)
 340:	c7 44 24 04 68 0c 00 	movl   $0xc68,0x4(%esp)
 347:	00 
 348:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 34f:	e8 1e 04 00 00       	call   772 <printf>
  exit();
 354:	e8 49 02 00 00       	call   5a2 <exit>

00000359 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	57                   	push   %edi
 35d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 35e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 361:	8b 55 10             	mov    0x10(%ebp),%edx
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	89 cb                	mov    %ecx,%ebx
 369:	89 df                	mov    %ebx,%edi
 36b:	89 d1                	mov    %edx,%ecx
 36d:	fc                   	cld    
 36e:	f3 aa                	rep stos %al,%es:(%edi)
 370:	89 ca                	mov    %ecx,%edx
 372:	89 fb                	mov    %edi,%ebx
 374:	89 5d 08             	mov    %ebx,0x8(%ebp)
 377:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37a:	5b                   	pop    %ebx
 37b:	5f                   	pop    %edi
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret    

0000037e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 37e:	55                   	push   %ebp
 37f:	89 e5                	mov    %esp,%ebp
 381:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38a:	90                   	nop
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	8a 10                	mov    (%eax),%dl
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	88 10                	mov    %dl,(%eax)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	8a 00                	mov    (%eax),%al
 39a:	84 c0                	test   %al,%al
 39c:	0f 95 c0             	setne  %al
 39f:	ff 45 08             	incl   0x8(%ebp)
 3a2:	ff 45 0c             	incl   0xc(%ebp)
 3a5:	84 c0                	test   %al,%al
 3a7:	75 e2                	jne    38b <strcpy+0xd>
    ;
  return os;
 3a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ac:	c9                   	leave  
 3ad:	c3                   	ret    

000003ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b1:	eb 06                	jmp    3b9 <strcmp+0xb>
    p++, q++;
 3b3:	ff 45 08             	incl   0x8(%ebp)
 3b6:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	8a 00                	mov    (%eax),%al
 3be:	84 c0                	test   %al,%al
 3c0:	74 0e                	je     3d0 <strcmp+0x22>
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	8a 10                	mov    (%eax),%dl
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	8a 00                	mov    (%eax),%al
 3cc:	38 c2                	cmp    %al,%dl
 3ce:	74 e3                	je     3b3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	8a 00                	mov    (%eax),%al
 3d5:	0f b6 d0             	movzbl %al,%edx
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	8a 00                	mov    (%eax),%al
 3dd:	0f b6 c0             	movzbl %al,%eax
 3e0:	89 d1                	mov    %edx,%ecx
 3e2:	29 c1                	sub    %eax,%ecx
 3e4:	89 c8                	mov    %ecx,%eax
}
 3e6:	5d                   	pop    %ebp
 3e7:	c3                   	ret    

000003e8 <strlen>:

uint
strlen(char *s)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f5:	eb 03                	jmp    3fa <strlen+0x12>
 3f7:	ff 45 fc             	incl   -0x4(%ebp)
 3fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	01 d0                	add    %edx,%eax
 402:	8a 00                	mov    (%eax),%al
 404:	84 c0                	test   %al,%al
 406:	75 ef                	jne    3f7 <strlen+0xf>
    ;
  return n;
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 40b:	c9                   	leave  
 40c:	c3                   	ret    

0000040d <memset>:

void*
memset(void *dst, int c, uint n)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
 410:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 413:	8b 45 10             	mov    0x10(%ebp),%eax
 416:	89 44 24 08          	mov    %eax,0x8(%esp)
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	89 44 24 04          	mov    %eax,0x4(%esp)
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	89 04 24             	mov    %eax,(%esp)
 427:	e8 2d ff ff ff       	call   359 <stosb>
  return dst;
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <strchr>:

char*
strchr(const char *s, char c)
{
 431:	55                   	push   %ebp
 432:	89 e5                	mov    %esp,%ebp
 434:	83 ec 04             	sub    $0x4,%esp
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 43d:	eb 12                	jmp    451 <strchr+0x20>
    if(*s == c)
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	8a 00                	mov    (%eax),%al
 444:	3a 45 fc             	cmp    -0x4(%ebp),%al
 447:	75 05                	jne    44e <strchr+0x1d>
      return (char*)s;
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	eb 11                	jmp    45f <strchr+0x2e>
  for(; *s; s++)
 44e:	ff 45 08             	incl   0x8(%ebp)
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	8a 00                	mov    (%eax),%al
 456:	84 c0                	test   %al,%al
 458:	75 e5                	jne    43f <strchr+0xe>
  return 0;
 45a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <gets>:

char*
gets(char *buf, int max)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 467:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 46e:	eb 42                	jmp    4b2 <gets+0x51>
    cc = read(0, &c, 1);
 470:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 477:	00 
 478:	8d 45 ef             	lea    -0x11(%ebp),%eax
 47b:	89 44 24 04          	mov    %eax,0x4(%esp)
 47f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 486:	e8 2f 01 00 00       	call   5ba <read>
 48b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 48e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 492:	7e 29                	jle    4bd <gets+0x5c>
      break;
    buf[i++] = c;
 494:	8b 55 f4             	mov    -0xc(%ebp),%edx
 497:	8b 45 08             	mov    0x8(%ebp),%eax
 49a:	01 c2                	add    %eax,%edx
 49c:	8a 45 ef             	mov    -0x11(%ebp),%al
 49f:	88 02                	mov    %al,(%edx)
 4a1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 4a4:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a7:	3c 0a                	cmp    $0xa,%al
 4a9:	74 13                	je     4be <gets+0x5d>
 4ab:	8a 45 ef             	mov    -0x11(%ebp),%al
 4ae:	3c 0d                	cmp    $0xd,%al
 4b0:	74 0c                	je     4be <gets+0x5d>
  for(i=0; i+1 < max; ){
 4b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b5:	40                   	inc    %eax
 4b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4b9:	7c b5                	jl     470 <gets+0xf>
 4bb:	eb 01                	jmp    4be <gets+0x5d>
      break;
 4bd:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4be:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	01 d0                	add    %edx,%eax
 4c6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4cc:	c9                   	leave  
 4cd:	c3                   	ret    

000004ce <stat>:

int
stat(char *n, struct stat *st)
{
 4ce:	55                   	push   %ebp
 4cf:	89 e5                	mov    %esp,%ebp
 4d1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4db:	00 
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	89 04 24             	mov    %eax,(%esp)
 4e2:	e8 fb 00 00 00       	call   5e2 <open>
 4e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ee:	79 07                	jns    4f7 <stat+0x29>
    return -1;
 4f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4f5:	eb 23                	jmp    51a <stat+0x4c>
  r = fstat(fd, st);
 4f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 501:	89 04 24             	mov    %eax,(%esp)
 504:	e8 f1 00 00 00       	call   5fa <fstat>
 509:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 50c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50f:	89 04 24             	mov    %eax,(%esp)
 512:	e8 b3 00 00 00       	call   5ca <close>
  return r;
 517:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 51a:	c9                   	leave  
 51b:	c3                   	ret    

0000051c <atoi>:

int
atoi(const char *s)
{
 51c:	55                   	push   %ebp
 51d:	89 e5                	mov    %esp,%ebp
 51f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 522:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 529:	eb 21                	jmp    54c <atoi+0x30>
    n = n*10 + *s++ - '0';
 52b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 52e:	89 d0                	mov    %edx,%eax
 530:	c1 e0 02             	shl    $0x2,%eax
 533:	01 d0                	add    %edx,%eax
 535:	d1 e0                	shl    %eax
 537:	89 c2                	mov    %eax,%edx
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	8a 00                	mov    (%eax),%al
 53e:	0f be c0             	movsbl %al,%eax
 541:	01 d0                	add    %edx,%eax
 543:	83 e8 30             	sub    $0x30,%eax
 546:	89 45 fc             	mov    %eax,-0x4(%ebp)
 549:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	8a 00                	mov    (%eax),%al
 551:	3c 2f                	cmp    $0x2f,%al
 553:	7e 09                	jle    55e <atoi+0x42>
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	8a 00                	mov    (%eax),%al
 55a:	3c 39                	cmp    $0x39,%al
 55c:	7e cd                	jle    52b <atoi+0xf>
  return n;
 55e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 561:	c9                   	leave  
 562:	c3                   	ret    

00000563 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 563:	55                   	push   %ebp
 564:	89 e5                	mov    %esp,%ebp
 566:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 575:	eb 10                	jmp    587 <memmove+0x24>
    *dst++ = *src++;
 577:	8b 45 f8             	mov    -0x8(%ebp),%eax
 57a:	8a 10                	mov    (%eax),%dl
 57c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 57f:	88 10                	mov    %dl,(%eax)
 581:	ff 45 fc             	incl   -0x4(%ebp)
 584:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 587:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 58b:	0f 9f c0             	setg   %al
 58e:	ff 4d 10             	decl   0x10(%ebp)
 591:	84 c0                	test   %al,%al
 593:	75 e2                	jne    577 <memmove+0x14>
  return vdst;
 595:	8b 45 08             	mov    0x8(%ebp),%eax
}
 598:	c9                   	leave  
 599:	c3                   	ret    

0000059a <fork>:
 59a:	b8 01 00 00 00       	mov    $0x1,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <exit>:
 5a2:	b8 02 00 00 00       	mov    $0x2,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <wait>:
 5aa:	b8 03 00 00 00       	mov    $0x3,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <pipe>:
 5b2:	b8 04 00 00 00       	mov    $0x4,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <read>:
 5ba:	b8 05 00 00 00       	mov    $0x5,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <write>:
 5c2:	b8 10 00 00 00       	mov    $0x10,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <close>:
 5ca:	b8 15 00 00 00       	mov    $0x15,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <kill>:
 5d2:	b8 06 00 00 00       	mov    $0x6,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <exec>:
 5da:	b8 07 00 00 00       	mov    $0x7,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <open>:
 5e2:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <mknod>:
 5ea:	b8 11 00 00 00       	mov    $0x11,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <unlink>:
 5f2:	b8 12 00 00 00       	mov    $0x12,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <fstat>:
 5fa:	b8 08 00 00 00       	mov    $0x8,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <link>:
 602:	b8 13 00 00 00       	mov    $0x13,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <mkdir>:
 60a:	b8 14 00 00 00       	mov    $0x14,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <chdir>:
 612:	b8 09 00 00 00       	mov    $0x9,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <dup>:
 61a:	b8 0a 00 00 00       	mov    $0xa,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <getpid>:
 622:	b8 0b 00 00 00       	mov    $0xb,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <sbrk>:
 62a:	b8 0c 00 00 00       	mov    $0xc,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <sleep>:
 632:	b8 0d 00 00 00       	mov    $0xd,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <uptime>:
 63a:	b8 0e 00 00 00       	mov    $0xe,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <lseek>:
 642:	b8 16 00 00 00       	mov    $0x16,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <isatty>:
 64a:	b8 17 00 00 00       	mov    $0x17,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <procstat>:
 652:	b8 18 00 00 00       	mov    $0x18,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <set_priority>:
 65a:	b8 19 00 00 00       	mov    $0x19,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <semget>:
 662:	b8 1a 00 00 00       	mov    $0x1a,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <semfree>:
 66a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <semdown>:
 672:	b8 1c 00 00 00       	mov    $0x1c,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <semup>:
 67a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <shm_create>:
 682:	b8 1e 00 00 00       	mov    $0x1e,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <shm_close>:
 68a:	b8 1f 00 00 00       	mov    $0x1f,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <shm_get>:
 692:	b8 20 00 00 00       	mov    $0x20,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 69a:	55                   	push   %ebp
 69b:	89 e5                	mov    %esp,%ebp
 69d:	83 ec 28             	sub    $0x28,%esp
 6a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ad:	00 
 6ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b5:	8b 45 08             	mov    0x8(%ebp),%eax
 6b8:	89 04 24             	mov    %eax,(%esp)
 6bb:	e8 02 ff ff ff       	call   5c2 <write>
}
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    

000006c2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6c2:	55                   	push   %ebp
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6d3:	74 17                	je     6ec <printint+0x2a>
 6d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6d9:	79 11                	jns    6ec <printint+0x2a>
    neg = 1;
 6db:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e5:	f7 d8                	neg    %eax
 6e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ea:	eb 06                	jmp    6f2 <printint+0x30>
  } else {
    x = xx;
 6ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ff:	ba 00 00 00 00       	mov    $0x0,%edx
 704:	f7 f1                	div    %ecx
 706:	89 d0                	mov    %edx,%eax
 708:	8a 80 1c 0f 00 00    	mov    0xf1c(%eax),%al
 70e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 711:	8b 55 f4             	mov    -0xc(%ebp),%edx
 714:	01 ca                	add    %ecx,%edx
 716:	88 02                	mov    %al,(%edx)
 718:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 71b:	8b 55 10             	mov    0x10(%ebp),%edx
 71e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 721:	8b 45 ec             	mov    -0x14(%ebp),%eax
 724:	ba 00 00 00 00       	mov    $0x0,%edx
 729:	f7 75 d4             	divl   -0x2c(%ebp)
 72c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 72f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 733:	75 c4                	jne    6f9 <printint+0x37>
  if(neg)
 735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 739:	74 2c                	je     767 <printint+0xa5>
    buf[i++] = '-';
 73b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 741:	01 d0                	add    %edx,%eax
 743:	c6 00 2d             	movb   $0x2d,(%eax)
 746:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 749:	eb 1c                	jmp    767 <printint+0xa5>
    putc(fd, buf[i]);
 74b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	01 d0                	add    %edx,%eax
 753:	8a 00                	mov    (%eax),%al
 755:	0f be c0             	movsbl %al,%eax
 758:	89 44 24 04          	mov    %eax,0x4(%esp)
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	89 04 24             	mov    %eax,(%esp)
 762:	e8 33 ff ff ff       	call   69a <putc>
  while(--i >= 0)
 767:	ff 4d f4             	decl   -0xc(%ebp)
 76a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 76e:	79 db                	jns    74b <printint+0x89>
}
 770:	c9                   	leave  
 771:	c3                   	ret    

00000772 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 772:	55                   	push   %ebp
 773:	89 e5                	mov    %esp,%ebp
 775:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 778:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 77f:	8d 45 0c             	lea    0xc(%ebp),%eax
 782:	83 c0 04             	add    $0x4,%eax
 785:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 788:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 78f:	e9 78 01 00 00       	jmp    90c <printf+0x19a>
    c = fmt[i] & 0xff;
 794:	8b 55 0c             	mov    0xc(%ebp),%edx
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	01 d0                	add    %edx,%eax
 79c:	8a 00                	mov    (%eax),%al
 79e:	0f be c0             	movsbl %al,%eax
 7a1:	25 ff 00 00 00       	and    $0xff,%eax
 7a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ad:	75 2c                	jne    7db <printf+0x69>
      if(c == '%'){
 7af:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7b3:	75 0c                	jne    7c1 <printf+0x4f>
        state = '%';
 7b5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7bc:	e9 48 01 00 00       	jmp    909 <printf+0x197>
      } else {
        putc(fd, c);
 7c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c4:	0f be c0             	movsbl %al,%eax
 7c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ce:	89 04 24             	mov    %eax,(%esp)
 7d1:	e8 c4 fe ff ff       	call   69a <putc>
 7d6:	e9 2e 01 00 00       	jmp    909 <printf+0x197>
      }
    } else if(state == '%'){
 7db:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7df:	0f 85 24 01 00 00    	jne    909 <printf+0x197>
      if(c == 'd'){
 7e5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7e9:	75 2d                	jne    818 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7f7:	00 
 7f8:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7ff:	00 
 800:	89 44 24 04          	mov    %eax,0x4(%esp)
 804:	8b 45 08             	mov    0x8(%ebp),%eax
 807:	89 04 24             	mov    %eax,(%esp)
 80a:	e8 b3 fe ff ff       	call   6c2 <printint>
        ap++;
 80f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 813:	e9 ea 00 00 00       	jmp    902 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 818:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 81c:	74 06                	je     824 <printf+0xb2>
 81e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 822:	75 2d                	jne    851 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 824:	8b 45 e8             	mov    -0x18(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 830:	00 
 831:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 838:	00 
 839:	89 44 24 04          	mov    %eax,0x4(%esp)
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	89 04 24             	mov    %eax,(%esp)
 843:	e8 7a fe ff ff       	call   6c2 <printint>
        ap++;
 848:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 84c:	e9 b1 00 00 00       	jmp    902 <printf+0x190>
      } else if(c == 's'){
 851:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 855:	75 43                	jne    89a <printf+0x128>
        s = (char*)*ap;
 857:	8b 45 e8             	mov    -0x18(%ebp),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 85f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 867:	75 25                	jne    88e <printf+0x11c>
          s = "(null)";
 869:	c7 45 f4 98 0c 00 00 	movl   $0xc98,-0xc(%ebp)
        while(*s != 0){
 870:	eb 1c                	jmp    88e <printf+0x11c>
          putc(fd, *s);
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8a 00                	mov    (%eax),%al
 877:	0f be c0             	movsbl %al,%eax
 87a:	89 44 24 04          	mov    %eax,0x4(%esp)
 87e:	8b 45 08             	mov    0x8(%ebp),%eax
 881:	89 04 24             	mov    %eax,(%esp)
 884:	e8 11 fe ff ff       	call   69a <putc>
          s++;
 889:	ff 45 f4             	incl   -0xc(%ebp)
 88c:	eb 01                	jmp    88f <printf+0x11d>
        while(*s != 0){
 88e:	90                   	nop
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8a 00                	mov    (%eax),%al
 894:	84 c0                	test   %al,%al
 896:	75 da                	jne    872 <printf+0x100>
 898:	eb 68                	jmp    902 <printf+0x190>
        }
      } else if(c == 'c'){
 89a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 89e:	75 1d                	jne    8bd <printf+0x14b>
        putc(fd, *ap);
 8a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	0f be c0             	movsbl %al,%eax
 8a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ac:	8b 45 08             	mov    0x8(%ebp),%eax
 8af:	89 04 24             	mov    %eax,(%esp)
 8b2:	e8 e3 fd ff ff       	call   69a <putc>
        ap++;
 8b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8bb:	eb 45                	jmp    902 <printf+0x190>
      } else if(c == '%'){
 8bd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8c1:	75 17                	jne    8da <printf+0x168>
        putc(fd, c);
 8c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c6:	0f be c0             	movsbl %al,%eax
 8c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8cd:	8b 45 08             	mov    0x8(%ebp),%eax
 8d0:	89 04 24             	mov    %eax,(%esp)
 8d3:	e8 c2 fd ff ff       	call   69a <putc>
 8d8:	eb 28                	jmp    902 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8da:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8e1:	00 
 8e2:	8b 45 08             	mov    0x8(%ebp),%eax
 8e5:	89 04 24             	mov    %eax,(%esp)
 8e8:	e8 ad fd ff ff       	call   69a <putc>
        putc(fd, c);
 8ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8f0:	0f be c0             	movsbl %al,%eax
 8f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	89 04 24             	mov    %eax,(%esp)
 8fd:	e8 98 fd ff ff       	call   69a <putc>
      }
      state = 0;
 902:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 909:	ff 45 f0             	incl   -0x10(%ebp)
 90c:	8b 55 0c             	mov    0xc(%ebp),%edx
 90f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 912:	01 d0                	add    %edx,%eax
 914:	8a 00                	mov    (%eax),%al
 916:	84 c0                	test   %al,%al
 918:	0f 85 76 fe ff ff    	jne    794 <printf+0x22>
    }
  }
}
 91e:	c9                   	leave  
 91f:	c3                   	ret    

00000920 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 920:	55                   	push   %ebp
 921:	89 e5                	mov    %esp,%ebp
 923:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 926:	8b 45 08             	mov    0x8(%ebp),%eax
 929:	83 e8 08             	sub    $0x8,%eax
 92c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92f:	a1 38 0f 00 00       	mov    0xf38,%eax
 934:	89 45 fc             	mov    %eax,-0x4(%ebp)
 937:	eb 24                	jmp    95d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 00                	mov    (%eax),%eax
 93e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 941:	77 12                	ja     955 <free+0x35>
 943:	8b 45 f8             	mov    -0x8(%ebp),%eax
 946:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 949:	77 24                	ja     96f <free+0x4f>
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 953:	77 1a                	ja     96f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 955:	8b 45 fc             	mov    -0x4(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 95d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 960:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 963:	76 d4                	jbe    939 <free+0x19>
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8b 00                	mov    (%eax),%eax
 96a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 96d:	76 ca                	jbe    939 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 96f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 972:	8b 40 04             	mov    0x4(%eax),%eax
 975:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 97c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97f:	01 c2                	add    %eax,%edx
 981:	8b 45 fc             	mov    -0x4(%ebp),%eax
 984:	8b 00                	mov    (%eax),%eax
 986:	39 c2                	cmp    %eax,%edx
 988:	75 24                	jne    9ae <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 98a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98d:	8b 50 04             	mov    0x4(%eax),%edx
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	8b 00                	mov    (%eax),%eax
 995:	8b 40 04             	mov    0x4(%eax),%eax
 998:	01 c2                	add    %eax,%edx
 99a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 99d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a3:	8b 00                	mov    (%eax),%eax
 9a5:	8b 10                	mov    (%eax),%edx
 9a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9aa:	89 10                	mov    %edx,(%eax)
 9ac:	eb 0a                	jmp    9b8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b1:	8b 10                	mov    (%eax),%edx
 9b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	8b 40 04             	mov    0x4(%eax),%eax
 9be:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c8:	01 d0                	add    %edx,%eax
 9ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9cd:	75 20                	jne    9ef <free+0xcf>
    p->s.size += bp->s.size;
 9cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d2:	8b 50 04             	mov    0x4(%eax),%edx
 9d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d8:	8b 40 04             	mov    0x4(%eax),%eax
 9db:	01 c2                	add    %eax,%edx
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e6:	8b 10                	mov    (%eax),%edx
 9e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9eb:	89 10                	mov    %edx,(%eax)
 9ed:	eb 08                	jmp    9f7 <free+0xd7>
  } else
    p->s.ptr = bp;
 9ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f5:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9fa:	a3 38 0f 00 00       	mov    %eax,0xf38
}
 9ff:	c9                   	leave  
 a00:	c3                   	ret    

00000a01 <morecore>:

static Header*
morecore(uint nu)
{
 a01:	55                   	push   %ebp
 a02:	89 e5                	mov    %esp,%ebp
 a04:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a07:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a0e:	77 07                	ja     a17 <morecore+0x16>
    nu = 4096;
 a10:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a17:	8b 45 08             	mov    0x8(%ebp),%eax
 a1a:	c1 e0 03             	shl    $0x3,%eax
 a1d:	89 04 24             	mov    %eax,(%esp)
 a20:	e8 05 fc ff ff       	call   62a <sbrk>
 a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a28:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a2c:	75 07                	jne    a35 <morecore+0x34>
    return 0;
 a2e:	b8 00 00 00 00       	mov    $0x0,%eax
 a33:	eb 22                	jmp    a57 <morecore+0x56>
  hp = (Header*)p;
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3e:	8b 55 08             	mov    0x8(%ebp),%edx
 a41:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a47:	83 c0 08             	add    $0x8,%eax
 a4a:	89 04 24             	mov    %eax,(%esp)
 a4d:	e8 ce fe ff ff       	call   920 <free>
  return freep;
 a52:	a1 38 0f 00 00       	mov    0xf38,%eax
}
 a57:	c9                   	leave  
 a58:	c3                   	ret    

00000a59 <malloc>:

void*
malloc(uint nbytes)
{
 a59:	55                   	push   %ebp
 a5a:	89 e5                	mov    %esp,%ebp
 a5c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	83 c0 07             	add    $0x7,%eax
 a65:	c1 e8 03             	shr    $0x3,%eax
 a68:	40                   	inc    %eax
 a69:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a6c:	a1 38 0f 00 00       	mov    0xf38,%eax
 a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a78:	75 23                	jne    a9d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a7a:	c7 45 f0 30 0f 00 00 	movl   $0xf30,-0x10(%ebp)
 a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a84:	a3 38 0f 00 00       	mov    %eax,0xf38
 a89:	a1 38 0f 00 00       	mov    0xf38,%eax
 a8e:	a3 30 0f 00 00       	mov    %eax,0xf30
    base.s.size = 0;
 a93:	c7 05 34 0f 00 00 00 	movl   $0x0,0xf34
 a9a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa0:	8b 00                	mov    (%eax),%eax
 aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa8:	8b 40 04             	mov    0x4(%eax),%eax
 aab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aae:	72 4d                	jb     afd <malloc+0xa4>
      if(p->s.size == nunits)
 ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab3:	8b 40 04             	mov    0x4(%eax),%eax
 ab6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab9:	75 0c                	jne    ac7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abe:	8b 10                	mov    (%eax),%edx
 ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac3:	89 10                	mov    %edx,(%eax)
 ac5:	eb 26                	jmp    aed <malloc+0x94>
      else {
        p->s.size -= nunits;
 ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aca:	8b 40 04             	mov    0x4(%eax),%eax
 acd:	89 c2                	mov    %eax,%edx
 acf:	2b 55 ec             	sub    -0x14(%ebp),%edx
 ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adb:	8b 40 04             	mov    0x4(%eax),%eax
 ade:	c1 e0 03             	shl    $0x3,%eax
 ae1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aea:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af0:	a3 38 0f 00 00       	mov    %eax,0xf38
      return (void*)(p + 1);
 af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af8:	83 c0 08             	add    $0x8,%eax
 afb:	eb 38                	jmp    b35 <malloc+0xdc>
    }
    if(p == freep)
 afd:	a1 38 0f 00 00       	mov    0xf38,%eax
 b02:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b05:	75 1b                	jne    b22 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b0a:	89 04 24             	mov    %eax,(%esp)
 b0d:	e8 ef fe ff ff       	call   a01 <morecore>
 b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b19:	75 07                	jne    b22 <malloc+0xc9>
        return 0;
 b1b:	b8 00 00 00 00       	mov    $0x0,%eax
 b20:	eb 13                	jmp    b35 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2b:	8b 00                	mov    (%eax),%eax
 b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 b30:	e9 70 ff ff ff       	jmp    aa5 <malloc+0x4c>
}
 b35:	c9                   	leave  
 b36:	c3                   	ret    
