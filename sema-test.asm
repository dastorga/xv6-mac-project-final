
_sema-test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <productor>:
int semcom;
int sembuff;

void
productor(int val)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(1,"-- Inicia Productor --\n");
   6:	c7 44 24 04 88 0a 00 	movl   $0xa88,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 a8 06 00 00       	call   6c2 <printf>
  semdown(semprod); // empty
  1a:	a1 40 0e 00 00       	mov    0xe40,%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 9b 05 00 00       	call   5c2 <semdown>
  semdown(sembuff); // mutex
  27:	a1 44 0e 00 00       	mov    0xe44,%eax
  2c:	89 04 24             	mov    %eax,(%esp)
  2f:	e8 8e 05 00 00       	call   5c2 <semdown>
  //  REGION CRITICA
  val = (val) + 1;
  34:	ff 45 08             	incl   0x8(%ebp)
  //
  semup(sembuff); //mutex
  37:	a1 44 0e 00 00       	mov    0xe44,%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 86 05 00 00       	call   5ca <semup>
  semup(semcom); // full
  44:	a1 4c 0e 00 00       	mov    0xe4c,%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 79 05 00 00       	call   5ca <semup>
  printf(1,"-- Termina Productor --\n");
  51:	c7 44 24 04 a0 0a 00 	movl   $0xaa0,0x4(%esp)
  58:	00 
  59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  60:	e8 5d 06 00 00       	call   6c2 <printf>
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
  6d:	c7 44 24 04 b9 0a 00 	movl   $0xab9,0x4(%esp)
  74:	00 
  75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7c:	e8 41 06 00 00       	call   6c2 <printf>
  semdown(semcom); // full
  81:	a1 4c 0e 00 00       	mov    0xe4c,%eax
  86:	89 04 24             	mov    %eax,(%esp)
  89:	e8 34 05 00 00       	call   5c2 <semdown>
  semdown(sembuff); // mutex
  8e:	a1 44 0e 00 00       	mov    0xe44,%eax
  93:	89 04 24             	mov    %eax,(%esp)
  96:	e8 27 05 00 00       	call   5c2 <semdown>
  // REGION CRITICA
  val = (val) - 1;
  9b:	ff 4d 08             	decl   0x8(%ebp)
  //
  semup(sembuff); // mutex
  9e:	a1 44 0e 00 00       	mov    0xe44,%eax
  a3:	89 04 24             	mov    %eax,(%esp)
  a6:	e8 1f 05 00 00       	call   5ca <semup>
  semup(semprod); // empty
  ab:	a1 40 0e 00 00       	mov    0xe40,%eax
  b0:	89 04 24             	mov    %eax,(%esp)
  b3:	e8 12 05 00 00       	call   5ca <semup>
  printf(1,"-- Termina Consumidor --\n");
  b8:	c7 44 24 04 d2 0a 00 	movl   $0xad2,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 f6 05 00 00       	call   6c2 <printf>
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
  e7:	c7 44 24 04 ec 0a 00 	movl   $0xaec,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 c7 05 00 00       	call   6c2 <printf>
  printf(1,"--- Tamaño de buffer: %d\n", BUFF_SIZE);
  fb:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
 102:	00 
 103:	c7 44 24 04 1d 0b 00 	movl   $0xb1d,0x4(%esp)
 10a:	00 
 10b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 112:	e8 ab 05 00 00       	call   6c2 <printf>
  
  // creo semaforo productor 
  semprod = semget(-1,BUFF_SIZE); // empty
 117:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 11e:	00 
 11f:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 126:	e8 87 04 00 00       	call   5b2 <semget>
 12b:	a3 40 0e 00 00       	mov    %eax,0xe40
  if(semprod < 0){
 130:	a1 40 0e 00 00       	mov    0xe40,%eax
 135:	85 c0                	test   %eax,%eax
 137:	79 19                	jns    152 <main+0x84>
    printf(1,"invalid semprod \n");
 139:	c7 44 24 04 38 0b 00 	movl   $0xb38,0x4(%esp)
 140:	00 
 141:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 148:	e8 75 05 00 00       	call   6c2 <printf>
    exit();
 14d:	e8 a0 03 00 00       	call   4f2 <exit>
  }
  // creo semaforo consumidor
  semcom = semget(-1,0); // full
 152:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 159:	00 
 15a:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 161:	e8 4c 04 00 00       	call   5b2 <semget>
 166:	a3 4c 0e 00 00       	mov    %eax,0xe4c
  if(semcom < 0){
 16b:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 170:	85 c0                	test   %eax,%eax
 172:	79 19                	jns    18d <main+0xbf>
    printf(1,"invalid semcom\n");
 174:	c7 44 24 04 4a 0b 00 	movl   $0xb4a,0x4(%esp)
 17b:	00 
 17c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 183:	e8 3a 05 00 00       	call   6c2 <printf>
    exit();
 188:	e8 65 03 00 00       	call   4f2 <exit>
  }
  // creo semaforo buffer
  sembuff = semget(-1,1); // mutex
 18d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 194:	00 
 195:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 19c:	e8 11 04 00 00       	call   5b2 <semget>
 1a1:	a3 44 0e 00 00       	mov    %eax,0xe44
  if(sembuff < 0){
 1a6:	a1 44 0e 00 00       	mov    0xe44,%eax
 1ab:	85 c0                	test   %eax,%eax
 1ad:	79 19                	jns    1c8 <main+0xfa>
    printf(1,"invalid sembuff\n");
 1af:	c7 44 24 04 5a 0b 00 	movl   $0xb5a,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 ff 04 00 00       	call   6c2 <printf>
    exit();
 1c3:	e8 2a 03 00 00       	call   4f2 <exit>
  }

  for (i = 0; i < 4; i++) { 
 1c8:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 1cf:	00 
 1d0:	eb 4f                	jmp    221 <main+0x153>
    semget(semprod,0);
 1d2:	a1 40 0e 00 00       	mov    0xe40,%eax
 1d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1de:	00 
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 cb 03 00 00       	call   5b2 <semget>
    semget(semcom,0);
 1e7:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 1ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f3:	00 
 1f4:	89 04 24             	mov    %eax,(%esp)
 1f7:	e8 b6 03 00 00       	call   5b2 <semget>
    semget(sembuff,0);
 1fc:	a1 44 0e 00 00       	mov    0xe44,%eax
 201:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 208:	00 
 209:	89 04 24             	mov    %eax,(%esp)
 20c:	e8 a1 03 00 00       	call   5b2 <semget>
    productor(val);
 211:	8b 44 24 18          	mov    0x18(%esp),%eax
 215:	89 04 24             	mov    %eax,(%esp)
 218:	e8 e3 fd ff ff       	call   0 <productor>
  for (i = 0; i < 4; i++) { 
 21d:	ff 44 24 1c          	incl   0x1c(%esp)
 221:	83 7c 24 1c 03       	cmpl   $0x3,0x1c(%esp)
 226:	7e aa                	jle    1d2 <main+0x104>
  }

  for (i = 0; i < 3; i++) { 
 228:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 22f:	00 
 230:	eb 4f                	jmp    281 <main+0x1b3>
    semget(semprod,0);
 232:	a1 40 0e 00 00       	mov    0xe40,%eax
 237:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23e:	00 
 23f:	89 04 24             	mov    %eax,(%esp)
 242:	e8 6b 03 00 00       	call   5b2 <semget>
    semget(semcom,0);
 247:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 24c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 253:	00 
 254:	89 04 24             	mov    %eax,(%esp)
 257:	e8 56 03 00 00       	call   5b2 <semget>
    semget(sembuff,0);
 25c:	a1 44 0e 00 00       	mov    0xe44,%eax
 261:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 268:	00 
 269:	89 04 24             	mov    %eax,(%esp)
 26c:	e8 41 03 00 00       	call   5b2 <semget>
    consumidor(val); 
 271:	8b 44 24 18          	mov    0x18(%esp),%eax
 275:	89 04 24             	mov    %eax,(%esp)
 278:	e8 ea fd ff ff       	call   67 <consumidor>
  for (i = 0; i < 3; i++) { 
 27d:	ff 44 24 1c          	incl   0x1c(%esp)
 281:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
 286:	7e aa                	jle    232 <main+0x164>
  }

  printf(1,"-------------------------- VALOR FINAL: [%d]  \n", val);
 288:	8b 44 24 18          	mov    0x18(%esp),%eax
 28c:	89 44 24 08          	mov    %eax,0x8(%esp)
 290:	c7 44 24 04 6c 0b 00 	movl   $0xb6c,0x4(%esp)
 297:	00 
 298:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 29f:	e8 1e 04 00 00       	call   6c2 <printf>
  exit();
 2a4:	e8 49 02 00 00       	call   4f2 <exit>

000002a9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	57                   	push   %edi
 2ad:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b1:	8b 55 10             	mov    0x10(%ebp),%edx
 2b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b7:	89 cb                	mov    %ecx,%ebx
 2b9:	89 df                	mov    %ebx,%edi
 2bb:	89 d1                	mov    %edx,%ecx
 2bd:	fc                   	cld    
 2be:	f3 aa                	rep stos %al,%es:(%edi)
 2c0:	89 ca                	mov    %ecx,%edx
 2c2:	89 fb                	mov    %edi,%ebx
 2c4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2c7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2ca:	5b                   	pop    %ebx
 2cb:	5f                   	pop    %edi
 2cc:	5d                   	pop    %ebp
 2cd:	c3                   	ret    

000002ce <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2da:	90                   	nop
 2db:	8b 45 0c             	mov    0xc(%ebp),%eax
 2de:	8a 10                	mov    (%eax),%dl
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	88 10                	mov    %dl,(%eax)
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	8a 00                	mov    (%eax),%al
 2ea:	84 c0                	test   %al,%al
 2ec:	0f 95 c0             	setne  %al
 2ef:	ff 45 08             	incl   0x8(%ebp)
 2f2:	ff 45 0c             	incl   0xc(%ebp)
 2f5:	84 c0                	test   %al,%al
 2f7:	75 e2                	jne    2db <strcpy+0xd>
    ;
  return os;
 2f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fc:	c9                   	leave  
 2fd:	c3                   	ret    

000002fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 301:	eb 06                	jmp    309 <strcmp+0xb>
    p++, q++;
 303:	ff 45 08             	incl   0x8(%ebp)
 306:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	8a 00                	mov    (%eax),%al
 30e:	84 c0                	test   %al,%al
 310:	74 0e                	je     320 <strcmp+0x22>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	8a 10                	mov    (%eax),%dl
 317:	8b 45 0c             	mov    0xc(%ebp),%eax
 31a:	8a 00                	mov    (%eax),%al
 31c:	38 c2                	cmp    %al,%dl
 31e:	74 e3                	je     303 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	8a 00                	mov    (%eax),%al
 325:	0f b6 d0             	movzbl %al,%edx
 328:	8b 45 0c             	mov    0xc(%ebp),%eax
 32b:	8a 00                	mov    (%eax),%al
 32d:	0f b6 c0             	movzbl %al,%eax
 330:	89 d1                	mov    %edx,%ecx
 332:	29 c1                	sub    %eax,%ecx
 334:	89 c8                	mov    %ecx,%eax
}
 336:	5d                   	pop    %ebp
 337:	c3                   	ret    

00000338 <strlen>:

uint
strlen(char *s)
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 33e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 345:	eb 03                	jmp    34a <strlen+0x12>
 347:	ff 45 fc             	incl   -0x4(%ebp)
 34a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	01 d0                	add    %edx,%eax
 352:	8a 00                	mov    (%eax),%al
 354:	84 c0                	test   %al,%al
 356:	75 ef                	jne    347 <strlen+0xf>
    ;
  return n;
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <memset>:

void*
memset(void *dst, int c, uint n)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 363:	8b 45 10             	mov    0x10(%ebp),%eax
 366:	89 44 24 08          	mov    %eax,0x8(%esp)
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 44 24 04          	mov    %eax,0x4(%esp)
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 04 24             	mov    %eax,(%esp)
 377:	e8 2d ff ff ff       	call   2a9 <stosb>
  return dst;
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37f:	c9                   	leave  
 380:	c3                   	ret    

00000381 <strchr>:

char*
strchr(const char *s, char c)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 04             	sub    $0x4,%esp
 387:	8b 45 0c             	mov    0xc(%ebp),%eax
 38a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 38d:	eb 12                	jmp    3a1 <strchr+0x20>
    if(*s == c)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	8a 00                	mov    (%eax),%al
 394:	3a 45 fc             	cmp    -0x4(%ebp),%al
 397:	75 05                	jne    39e <strchr+0x1d>
      return (char*)s;
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	eb 11                	jmp    3af <strchr+0x2e>
  for(; *s; s++)
 39e:	ff 45 08             	incl   0x8(%ebp)
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	8a 00                	mov    (%eax),%al
 3a6:	84 c0                	test   %al,%al
 3a8:	75 e5                	jne    38f <strchr+0xe>
  return 0;
 3aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3af:	c9                   	leave  
 3b0:	c3                   	ret    

000003b1 <gets>:

char*
gets(char *buf, int max)
{
 3b1:	55                   	push   %ebp
 3b2:	89 e5                	mov    %esp,%ebp
 3b4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3be:	eb 42                	jmp    402 <gets+0x51>
    cc = read(0, &c, 1);
 3c0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3c7:	00 
 3c8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 3cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3d6:	e8 2f 01 00 00       	call   50a <read>
 3db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e2:	7e 29                	jle    40d <gets+0x5c>
      break;
    buf[i++] = c;
 3e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	01 c2                	add    %eax,%edx
 3ec:	8a 45 ef             	mov    -0x11(%ebp),%al
 3ef:	88 02                	mov    %al,(%edx)
 3f1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 3f4:	8a 45 ef             	mov    -0x11(%ebp),%al
 3f7:	3c 0a                	cmp    $0xa,%al
 3f9:	74 13                	je     40e <gets+0x5d>
 3fb:	8a 45 ef             	mov    -0x11(%ebp),%al
 3fe:	3c 0d                	cmp    $0xd,%al
 400:	74 0c                	je     40e <gets+0x5d>
  for(i=0; i+1 < max; ){
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	40                   	inc    %eax
 406:	3b 45 0c             	cmp    0xc(%ebp),%eax
 409:	7c b5                	jl     3c0 <gets+0xf>
 40b:	eb 01                	jmp    40e <gets+0x5d>
      break;
 40d:	90                   	nop
      break;
  }
  buf[i] = '\0';
 40e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 419:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <stat>:

int
stat(char *n, struct stat *st)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 424:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 42b:	00 
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
 42f:	89 04 24             	mov    %eax,(%esp)
 432:	e8 fb 00 00 00       	call   532 <open>
 437:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 43a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43e:	79 07                	jns    447 <stat+0x29>
    return -1;
 440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 445:	eb 23                	jmp    46a <stat+0x4c>
  r = fstat(fd, st);
 447:	8b 45 0c             	mov    0xc(%ebp),%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 451:	89 04 24             	mov    %eax,(%esp)
 454:	e8 f1 00 00 00       	call   54a <fstat>
 459:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 45c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45f:	89 04 24             	mov    %eax,(%esp)
 462:	e8 b3 00 00 00       	call   51a <close>
  return r;
 467:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 46a:	c9                   	leave  
 46b:	c3                   	ret    

0000046c <atoi>:

int
atoi(const char *s)
{
 46c:	55                   	push   %ebp
 46d:	89 e5                	mov    %esp,%ebp
 46f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 479:	eb 21                	jmp    49c <atoi+0x30>
    n = n*10 + *s++ - '0';
 47b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 47e:	89 d0                	mov    %edx,%eax
 480:	c1 e0 02             	shl    $0x2,%eax
 483:	01 d0                	add    %edx,%eax
 485:	d1 e0                	shl    %eax
 487:	89 c2                	mov    %eax,%edx
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	8a 00                	mov    (%eax),%al
 48e:	0f be c0             	movsbl %al,%eax
 491:	01 d0                	add    %edx,%eax
 493:	83 e8 30             	sub    $0x30,%eax
 496:	89 45 fc             	mov    %eax,-0x4(%ebp)
 499:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	8a 00                	mov    (%eax),%al
 4a1:	3c 2f                	cmp    $0x2f,%al
 4a3:	7e 09                	jle    4ae <atoi+0x42>
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	8a 00                	mov    (%eax),%al
 4aa:	3c 39                	cmp    $0x39,%al
 4ac:	7e cd                	jle    47b <atoi+0xf>
  return n;
 4ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4c5:	eb 10                	jmp    4d7 <memmove+0x24>
    *dst++ = *src++;
 4c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4ca:	8a 10                	mov    (%eax),%dl
 4cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4cf:	88 10                	mov    %dl,(%eax)
 4d1:	ff 45 fc             	incl   -0x4(%ebp)
 4d4:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 4d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4db:	0f 9f c0             	setg   %al
 4de:	ff 4d 10             	decl   0x10(%ebp)
 4e1:	84 c0                	test   %al,%al
 4e3:	75 e2                	jne    4c7 <memmove+0x14>
  return vdst;
 4e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e8:	c9                   	leave  
 4e9:	c3                   	ret    

000004ea <fork>:
 4ea:	b8 01 00 00 00       	mov    $0x1,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <exit>:
 4f2:	b8 02 00 00 00       	mov    $0x2,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <wait>:
 4fa:	b8 03 00 00 00       	mov    $0x3,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <pipe>:
 502:	b8 04 00 00 00       	mov    $0x4,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <read>:
 50a:	b8 05 00 00 00       	mov    $0x5,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <write>:
 512:	b8 10 00 00 00       	mov    $0x10,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <close>:
 51a:	b8 15 00 00 00       	mov    $0x15,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <kill>:
 522:	b8 06 00 00 00       	mov    $0x6,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <exec>:
 52a:	b8 07 00 00 00       	mov    $0x7,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <open>:
 532:	b8 0f 00 00 00       	mov    $0xf,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mknod>:
 53a:	b8 11 00 00 00       	mov    $0x11,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <unlink>:
 542:	b8 12 00 00 00       	mov    $0x12,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <fstat>:
 54a:	b8 08 00 00 00       	mov    $0x8,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <link>:
 552:	b8 13 00 00 00       	mov    $0x13,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <mkdir>:
 55a:	b8 14 00 00 00       	mov    $0x14,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <chdir>:
 562:	b8 09 00 00 00       	mov    $0x9,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <dup>:
 56a:	b8 0a 00 00 00       	mov    $0xa,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <getpid>:
 572:	b8 0b 00 00 00       	mov    $0xb,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <sbrk>:
 57a:	b8 0c 00 00 00       	mov    $0xc,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <sleep>:
 582:	b8 0d 00 00 00       	mov    $0xd,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <uptime>:
 58a:	b8 0e 00 00 00       	mov    $0xe,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <lseek>:
 592:	b8 16 00 00 00       	mov    $0x16,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <isatty>:
 59a:	b8 17 00 00 00       	mov    $0x17,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <procstat>:
 5a2:	b8 18 00 00 00       	mov    $0x18,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <set_priority>:
 5aa:	b8 19 00 00 00       	mov    $0x19,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <semget>:
 5b2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <semfree>:
 5ba:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <semdown>:
 5c2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <semup>:
 5ca:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <shm_create>:
 5d2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <shm_close>:
 5da:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <shm_get>:
 5e2:	b8 20 00 00 00       	mov    $0x20,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ea:	55                   	push   %ebp
 5eb:	89 e5                	mov    %esp,%ebp
 5ed:	83 ec 28             	sub    $0x28,%esp
 5f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5f6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5fd:	00 
 5fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
 601:	89 44 24 04          	mov    %eax,0x4(%esp)
 605:	8b 45 08             	mov    0x8(%ebp),%eax
 608:	89 04 24             	mov    %eax,(%esp)
 60b:	e8 02 ff ff ff       	call   512 <write>
}
 610:	c9                   	leave  
 611:	c3                   	ret    

00000612 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 612:	55                   	push   %ebp
 613:	89 e5                	mov    %esp,%ebp
 615:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 618:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 61f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 623:	74 17                	je     63c <printint+0x2a>
 625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 629:	79 11                	jns    63c <printint+0x2a>
    neg = 1;
 62b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 632:	8b 45 0c             	mov    0xc(%ebp),%eax
 635:	f7 d8                	neg    %eax
 637:	89 45 ec             	mov    %eax,-0x14(%ebp)
 63a:	eb 06                	jmp    642 <printint+0x30>
  } else {
    x = xx;
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
 63f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 649:	8b 4d 10             	mov    0x10(%ebp),%ecx
 64c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64f:	ba 00 00 00 00       	mov    $0x0,%edx
 654:	f7 f1                	div    %ecx
 656:	89 d0                	mov    %edx,%eax
 658:	8a 80 20 0e 00 00    	mov    0xe20(%eax),%al
 65e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 661:	8b 55 f4             	mov    -0xc(%ebp),%edx
 664:	01 ca                	add    %ecx,%edx
 666:	88 02                	mov    %al,(%edx)
 668:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 66b:	8b 55 10             	mov    0x10(%ebp),%edx
 66e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 671:	8b 45 ec             	mov    -0x14(%ebp),%eax
 674:	ba 00 00 00 00       	mov    $0x0,%edx
 679:	f7 75 d4             	divl   -0x2c(%ebp)
 67c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 67f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 683:	75 c4                	jne    649 <printint+0x37>
  if(neg)
 685:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 689:	74 2c                	je     6b7 <printint+0xa5>
    buf[i++] = '-';
 68b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 68e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	c6 00 2d             	movb   $0x2d,(%eax)
 696:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 699:	eb 1c                	jmp    6b7 <printint+0xa5>
    putc(fd, buf[i]);
 69b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 69e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a1:	01 d0                	add    %edx,%eax
 6a3:	8a 00                	mov    (%eax),%al
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 33 ff ff ff       	call   5ea <putc>
  while(--i >= 0)
 6b7:	ff 4d f4             	decl   -0xc(%ebp)
 6ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6be:	79 db                	jns    69b <printint+0x89>
}
 6c0:	c9                   	leave  
 6c1:	c3                   	ret    

000006c2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6c2:	55                   	push   %ebp
 6c3:	89 e5                	mov    %esp,%ebp
 6c5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6cf:	8d 45 0c             	lea    0xc(%ebp),%eax
 6d2:	83 c0 04             	add    $0x4,%eax
 6d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6df:	e9 78 01 00 00       	jmp    85c <printf+0x19a>
    c = fmt[i] & 0xff;
 6e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	01 d0                	add    %edx,%eax
 6ec:	8a 00                	mov    (%eax),%al
 6ee:	0f be c0             	movsbl %al,%eax
 6f1:	25 ff 00 00 00       	and    $0xff,%eax
 6f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6fd:	75 2c                	jne    72b <printf+0x69>
      if(c == '%'){
 6ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 703:	75 0c                	jne    711 <printf+0x4f>
        state = '%';
 705:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 70c:	e9 48 01 00 00       	jmp    859 <printf+0x197>
      } else {
        putc(fd, c);
 711:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 714:	0f be c0             	movsbl %al,%eax
 717:	89 44 24 04          	mov    %eax,0x4(%esp)
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 c4 fe ff ff       	call   5ea <putc>
 726:	e9 2e 01 00 00       	jmp    859 <printf+0x197>
      }
    } else if(state == '%'){
 72b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 72f:	0f 85 24 01 00 00    	jne    859 <printf+0x197>
      if(c == 'd'){
 735:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 739:	75 2d                	jne    768 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 73b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 747:	00 
 748:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 74f:	00 
 750:	89 44 24 04          	mov    %eax,0x4(%esp)
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 b3 fe ff ff       	call   612 <printint>
        ap++;
 75f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 763:	e9 ea 00 00 00       	jmp    852 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 768:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 76c:	74 06                	je     774 <printf+0xb2>
 76e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 772:	75 2d                	jne    7a1 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 780:	00 
 781:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 788:	00 
 789:	89 44 24 04          	mov    %eax,0x4(%esp)
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 7a fe ff ff       	call   612 <printint>
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	e9 b1 00 00 00       	jmp    852 <printf+0x190>
      } else if(c == 's'){
 7a1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7a5:	75 43                	jne    7ea <printf+0x128>
        s = (char*)*ap;
 7a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b7:	75 25                	jne    7de <printf+0x11c>
          s = "(null)";
 7b9:	c7 45 f4 9c 0b 00 00 	movl   $0xb9c,-0xc(%ebp)
        while(*s != 0){
 7c0:	eb 1c                	jmp    7de <printf+0x11c>
          putc(fd, *s);
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8a 00                	mov    (%eax),%al
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	89 04 24             	mov    %eax,(%esp)
 7d4:	e8 11 fe ff ff       	call   5ea <putc>
          s++;
 7d9:	ff 45 f4             	incl   -0xc(%ebp)
 7dc:	eb 01                	jmp    7df <printf+0x11d>
        while(*s != 0){
 7de:	90                   	nop
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8a 00                	mov    (%eax),%al
 7e4:	84 c0                	test   %al,%al
 7e6:	75 da                	jne    7c2 <printf+0x100>
 7e8:	eb 68                	jmp    852 <printf+0x190>
        }
      } else if(c == 'c'){
 7ea:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ee:	75 1d                	jne    80d <printf+0x14b>
        putc(fd, *ap);
 7f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	0f be c0             	movsbl %al,%eax
 7f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	89 04 24             	mov    %eax,(%esp)
 802:	e8 e3 fd ff ff       	call   5ea <putc>
        ap++;
 807:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80b:	eb 45                	jmp    852 <printf+0x190>
      } else if(c == '%'){
 80d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 811:	75 17                	jne    82a <printf+0x168>
        putc(fd, c);
 813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	89 44 24 04          	mov    %eax,0x4(%esp)
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	89 04 24             	mov    %eax,(%esp)
 823:	e8 c2 fd ff ff       	call   5ea <putc>
 828:	eb 28                	jmp    852 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 82a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 831:	00 
 832:	8b 45 08             	mov    0x8(%ebp),%eax
 835:	89 04 24             	mov    %eax,(%esp)
 838:	e8 ad fd ff ff       	call   5ea <putc>
        putc(fd, c);
 83d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 840:	0f be c0             	movsbl %al,%eax
 843:	89 44 24 04          	mov    %eax,0x4(%esp)
 847:	8b 45 08             	mov    0x8(%ebp),%eax
 84a:	89 04 24             	mov    %eax,(%esp)
 84d:	e8 98 fd ff ff       	call   5ea <putc>
      }
      state = 0;
 852:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 859:	ff 45 f0             	incl   -0x10(%ebp)
 85c:	8b 55 0c             	mov    0xc(%ebp),%edx
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	01 d0                	add    %edx,%eax
 864:	8a 00                	mov    (%eax),%al
 866:	84 c0                	test   %al,%al
 868:	0f 85 76 fe ff ff    	jne    6e4 <printf+0x22>
    }
  }
}
 86e:	c9                   	leave  
 86f:	c3                   	ret    

00000870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	83 e8 08             	sub    $0x8,%eax
 87c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87f:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 884:	89 45 fc             	mov    %eax,-0x4(%ebp)
 887:	eb 24                	jmp    8ad <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 889:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88c:	8b 00                	mov    (%eax),%eax
 88e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 891:	77 12                	ja     8a5 <free+0x35>
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 899:	77 24                	ja     8bf <free+0x4f>
 89b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89e:	8b 00                	mov    (%eax),%eax
 8a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a3:	77 1a                	ja     8bf <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	8b 00                	mov    (%eax),%eax
 8aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b3:	76 d4                	jbe    889 <free+0x19>
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bd:	76 ca                	jbe    889 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	8b 40 04             	mov    0x4(%eax),%eax
 8c5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cf:	01 c2                	add    %eax,%edx
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	39 c2                	cmp    %eax,%edx
 8d8:	75 24                	jne    8fe <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dd:	8b 50 04             	mov    0x4(%eax),%edx
 8e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	8b 40 04             	mov    0x4(%eax),%eax
 8e8:	01 c2                	add    %eax,%edx
 8ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ed:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	8b 00                	mov    (%eax),%eax
 8f5:	8b 10                	mov    (%eax),%edx
 8f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fa:	89 10                	mov    %edx,(%eax)
 8fc:	eb 0a                	jmp    908 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	8b 10                	mov    (%eax),%edx
 903:	8b 45 f8             	mov    -0x8(%ebp),%eax
 906:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 908:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 915:	8b 45 fc             	mov    -0x4(%ebp),%eax
 918:	01 d0                	add    %edx,%eax
 91a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91d:	75 20                	jne    93f <free+0xcf>
    p->s.size += bp->s.size;
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 50 04             	mov    0x4(%eax),%edx
 925:	8b 45 f8             	mov    -0x8(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	01 c2                	add    %eax,%edx
 92d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 930:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 933:	8b 45 f8             	mov    -0x8(%ebp),%eax
 936:	8b 10                	mov    (%eax),%edx
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	89 10                	mov    %edx,(%eax)
 93d:	eb 08                	jmp    947 <free+0xd7>
  } else
    p->s.ptr = bp;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 55 f8             	mov    -0x8(%ebp),%edx
 945:	89 10                	mov    %edx,(%eax)
  freep = p;
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	a3 3c 0e 00 00       	mov    %eax,0xe3c
}
 94f:	c9                   	leave  
 950:	c3                   	ret    

00000951 <morecore>:

static Header*
morecore(uint nu)
{
 951:	55                   	push   %ebp
 952:	89 e5                	mov    %esp,%ebp
 954:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 957:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 95e:	77 07                	ja     967 <morecore+0x16>
    nu = 4096;
 960:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	c1 e0 03             	shl    $0x3,%eax
 96d:	89 04 24             	mov    %eax,(%esp)
 970:	e8 05 fc ff ff       	call   57a <sbrk>
 975:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 978:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 97c:	75 07                	jne    985 <morecore+0x34>
    return 0;
 97e:	b8 00 00 00 00       	mov    $0x0,%eax
 983:	eb 22                	jmp    9a7 <morecore+0x56>
  hp = (Header*)p;
 985:	8b 45 f4             	mov    -0xc(%ebp),%eax
 988:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 98b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98e:	8b 55 08             	mov    0x8(%ebp),%edx
 991:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 994:	8b 45 f0             	mov    -0x10(%ebp),%eax
 997:	83 c0 08             	add    $0x8,%eax
 99a:	89 04 24             	mov    %eax,(%esp)
 99d:	e8 ce fe ff ff       	call   870 <free>
  return freep;
 9a2:	a1 3c 0e 00 00       	mov    0xe3c,%eax
}
 9a7:	c9                   	leave  
 9a8:	c3                   	ret    

000009a9 <malloc>:

void*
malloc(uint nbytes)
{
 9a9:	55                   	push   %ebp
 9aa:	89 e5                	mov    %esp,%ebp
 9ac:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9af:	8b 45 08             	mov    0x8(%ebp),%eax
 9b2:	83 c0 07             	add    $0x7,%eax
 9b5:	c1 e8 03             	shr    $0x3,%eax
 9b8:	40                   	inc    %eax
 9b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9bc:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 9c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9c8:	75 23                	jne    9ed <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 9ca:	c7 45 f0 34 0e 00 00 	movl   $0xe34,-0x10(%ebp)
 9d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d4:	a3 3c 0e 00 00       	mov    %eax,0xe3c
 9d9:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 9de:	a3 34 0e 00 00       	mov    %eax,0xe34
    base.s.size = 0;
 9e3:	c7 05 38 0e 00 00 00 	movl   $0x0,0xe38
 9ea:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f0:	8b 00                	mov    (%eax),%eax
 9f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f8:	8b 40 04             	mov    0x4(%eax),%eax
 9fb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9fe:	72 4d                	jb     a4d <malloc+0xa4>
      if(p->s.size == nunits)
 a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a03:	8b 40 04             	mov    0x4(%eax),%eax
 a06:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a09:	75 0c                	jne    a17 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0e:	8b 10                	mov    (%eax),%edx
 a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a13:	89 10                	mov    %edx,(%eax)
 a15:	eb 26                	jmp    a3d <malloc+0x94>
      else {
        p->s.size -= nunits;
 a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1a:	8b 40 04             	mov    0x4(%eax),%eax
 a1d:	89 c2                	mov    %eax,%edx
 a1f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 04             	mov    0x4(%eax),%eax
 a2e:	c1 e0 03             	shl    $0x3,%eax
 a31:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a37:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a3a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a40:	a3 3c 0e 00 00       	mov    %eax,0xe3c
      return (void*)(p + 1);
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	83 c0 08             	add    $0x8,%eax
 a4b:	eb 38                	jmp    a85 <malloc+0xdc>
    }
    if(p == freep)
 a4d:	a1 3c 0e 00 00       	mov    0xe3c,%eax
 a52:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a55:	75 1b                	jne    a72 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a5a:	89 04 24             	mov    %eax,(%esp)
 a5d:	e8 ef fe ff ff       	call   951 <morecore>
 a62:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a69:	75 07                	jne    a72 <malloc+0xc9>
        return 0;
 a6b:	b8 00 00 00 00       	mov    $0x0,%eax
 a70:	eb 13                	jmp    a85 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	8b 00                	mov    (%eax),%eax
 a7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a80:	e9 70 ff ff ff       	jmp    9f5 <malloc+0x4c>
}
 a85:	c9                   	leave  
 a86:	c3                   	ret    
