
_sema-prue:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test_0>:
int semprueba2;


// CREACION DE 5 SEMAFOROS PARA UN PROCESO
void
test_0(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  semprod = semget(-1,BUFF_SIZE); 
   6:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
   d:	00 
   e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  15:	e8 e3 04 00 00       	call   4fd <semget>
  1a:	a3 40 0d 00 00       	mov    %eax,0xd40
  printf(1,"LOG semaforo: %d\n", semprod);
  1f:	a1 40 0d 00 00       	mov    0xd40,%eax
  24:	89 44 24 08          	mov    %eax,0x8(%esp)
  28:	c7 44 24 04 d4 09 00 	movl   $0x9d4,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 d1 05 00 00       	call   60d <printf>
  if(semprod < 0){
  3c:	a1 40 0d 00 00       	mov    0xd40,%eax
  41:	85 c0                	test   %eax,%eax
  43:	79 19                	jns    5e <test_0+0x5e>
    printf(1,"invalid semprod \n");
  45:	c7 44 24 04 e6 09 00 	movl   $0x9e6,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 b4 05 00 00       	call   60d <printf>
    exit();
  59:	e8 df 03 00 00       	call   43d <exit>
  }
  semcom = semget(-1,0);   
  5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  65:	00 
  66:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  6d:	e8 8b 04 00 00       	call   4fd <semget>
  72:	a3 4c 0d 00 00       	mov    %eax,0xd4c
  printf(1,"LOG semaforo: %d\n", semcom);
  77:	a1 4c 0d 00 00       	mov    0xd4c,%eax
  7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  80:	c7 44 24 04 d4 09 00 	movl   $0x9d4,0x4(%esp)
  87:	00 
  88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8f:	e8 79 05 00 00       	call   60d <printf>
  if(semcom < 0){
  94:	a1 4c 0d 00 00       	mov    0xd4c,%eax
  99:	85 c0                	test   %eax,%eax
  9b:	79 19                	jns    b6 <test_0+0xb6>
    printf(1,"invalid semcom\n");
  9d:	c7 44 24 04 f8 09 00 	movl   $0x9f8,0x4(%esp)
  a4:	00 
  a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ac:	e8 5c 05 00 00       	call   60d <printf>
    exit();
  b1:	e8 87 03 00 00       	call   43d <exit>
  }
  sembuff = semget(-1,1); 
  b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  bd:	00 
  be:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  c5:	e8 33 04 00 00       	call   4fd <semget>
  ca:	a3 48 0d 00 00       	mov    %eax,0xd48
  printf(1,"LOG semaforo: %d\n", sembuff);
  cf:	a1 48 0d 00 00       	mov    0xd48,%eax
  d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  d8:	c7 44 24 04 d4 09 00 	movl   $0x9d4,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 21 05 00 00       	call   60d <printf>
  if(sembuff < 0){
  ec:	a1 48 0d 00 00       	mov    0xd48,%eax
  f1:	85 c0                	test   %eax,%eax
  f3:	79 19                	jns    10e <test_0+0x10e>
    printf(1,"invalid sembuff\n");
  f5:	c7 44 24 04 08 0a 00 	movl   $0xa08,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 104:	e8 04 05 00 00       	call   60d <printf>
    exit();
 109:	e8 2f 03 00 00       	call   43d <exit>
  }
  semprueba1 = semget(-1,5); 
 10e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
 115:	00 
 116:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 11d:	e8 db 03 00 00       	call   4fd <semget>
 122:	a3 50 0d 00 00       	mov    %eax,0xd50
  printf(1,"LOG: semaforo: %d\n", semprueba1); 
 127:	a1 50 0d 00 00       	mov    0xd50,%eax
 12c:	89 44 24 08          	mov    %eax,0x8(%esp)
 130:	c7 44 24 04 19 0a 00 	movl   $0xa19,0x4(%esp)
 137:	00 
 138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13f:	e8 c9 04 00 00       	call   60d <printf>
  if(semprueba1 < 0){
 144:	a1 50 0d 00 00       	mov    0xd50,%eax
 149:	85 c0                	test   %eax,%eax
 14b:	79 19                	jns    166 <test_0+0x166>
    printf(1,"invalid semprueba1\n");
 14d:	c7 44 24 04 2c 0a 00 	movl   $0xa2c,0x4(%esp)
 154:	00 
 155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15c:	e8 ac 04 00 00       	call   60d <printf>
    exit();
 161:	e8 d7 02 00 00       	call   43d <exit>
  }

  semprueba2 = semget(-1,6); 
 166:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
 16d:	00 
 16e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 175:	e8 83 03 00 00       	call   4fd <semget>
 17a:	a3 44 0d 00 00       	mov    %eax,0xd44
  printf(1,"LOG: semaforo: %d\n", semprueba2); 
 17f:	a1 44 0d 00 00       	mov    0xd44,%eax
 184:	89 44 24 08          	mov    %eax,0x8(%esp)
 188:	c7 44 24 04 19 0a 00 	movl   $0xa19,0x4(%esp)
 18f:	00 
 190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 197:	e8 71 04 00 00       	call   60d <printf>
  if(semprueba2 == -2){
 19c:	a1 44 0d 00 00       	mov    0xd44,%eax
 1a1:	83 f8 fe             	cmp    $0xfffffffe,%eax
 1a4:	75 19                	jne    1bf <test_0+0x1bf>
    printf(1,"ERROR el proceso corriente ya obtuvo el numero maximo de semaforos\n");
 1a6:	c7 44 24 04 40 0a 00 	movl   $0xa40,0x4(%esp)
 1ad:	00 
 1ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b5:	e8 53 04 00 00       	call   60d <printf>
    exit();
 1ba:	e8 7e 02 00 00       	call   43d <exit>
  }
  if(semprueba2 == -3){
 1bf:	a1 44 0d 00 00       	mov    0xd44,%eax
 1c4:	83 f8 fd             	cmp    $0xfffffffd,%eax
 1c7:	75 19                	jne    1e2 <test_0+0x1e2>
    printf(1,"ERROR no ahi mas semaforos disponibles en el sistema\n");
 1c9:	c7 44 24 04 84 0a 00 	movl   $0xa84,0x4(%esp)
 1d0:	00 
 1d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d8:	e8 30 04 00 00       	call   60d <printf>
    exit();
 1dd:	e8 5b 02 00 00       	call   43d <exit>
  }
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <main>:
 
// }

int
main(void)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 e4 f0             	and    $0xfffffff0,%esp
  test_0();
 1ea:	e8 11 fe ff ff       	call   0 <test_0>

  exit();
 1ef:	e8 49 02 00 00       	call   43d <exit>

000001f4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	57                   	push   %edi
 1f8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1fc:	8b 55 10             	mov    0x10(%ebp),%edx
 1ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 202:	89 cb                	mov    %ecx,%ebx
 204:	89 df                	mov    %ebx,%edi
 206:	89 d1                	mov    %edx,%ecx
 208:	fc                   	cld    
 209:	f3 aa                	rep stos %al,%es:(%edi)
 20b:	89 ca                	mov    %ecx,%edx
 20d:	89 fb                	mov    %edi,%ebx
 20f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 212:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 215:	5b                   	pop    %ebx
 216:	5f                   	pop    %edi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    

00000219 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
 21c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 225:	90                   	nop
 226:	8b 45 0c             	mov    0xc(%ebp),%eax
 229:	8a 10                	mov    (%eax),%dl
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	88 10                	mov    %dl,(%eax)
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	8a 00                	mov    (%eax),%al
 235:	84 c0                	test   %al,%al
 237:	0f 95 c0             	setne  %al
 23a:	ff 45 08             	incl   0x8(%ebp)
 23d:	ff 45 0c             	incl   0xc(%ebp)
 240:	84 c0                	test   %al,%al
 242:	75 e2                	jne    226 <strcpy+0xd>
    ;
  return os;
 244:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 247:	c9                   	leave  
 248:	c3                   	ret    

00000249 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 249:	55                   	push   %ebp
 24a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 24c:	eb 06                	jmp    254 <strcmp+0xb>
    p++, q++;
 24e:	ff 45 08             	incl   0x8(%ebp)
 251:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8a 00                	mov    (%eax),%al
 259:	84 c0                	test   %al,%al
 25b:	74 0e                	je     26b <strcmp+0x22>
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	8a 10                	mov    (%eax),%dl
 262:	8b 45 0c             	mov    0xc(%ebp),%eax
 265:	8a 00                	mov    (%eax),%al
 267:	38 c2                	cmp    %al,%dl
 269:	74 e3                	je     24e <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	8a 00                	mov    (%eax),%al
 270:	0f b6 d0             	movzbl %al,%edx
 273:	8b 45 0c             	mov    0xc(%ebp),%eax
 276:	8a 00                	mov    (%eax),%al
 278:	0f b6 c0             	movzbl %al,%eax
 27b:	89 d1                	mov    %edx,%ecx
 27d:	29 c1                	sub    %eax,%ecx
 27f:	89 c8                	mov    %ecx,%eax
}
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    

00000283 <strlen>:

uint
strlen(char *s)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 290:	eb 03                	jmp    295 <strlen+0x12>
 292:	ff 45 fc             	incl   -0x4(%ebp)
 295:	8b 55 fc             	mov    -0x4(%ebp),%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	8a 00                	mov    (%eax),%al
 29f:	84 c0                	test   %al,%al
 2a1:	75 ef                	jne    292 <strlen+0xf>
    ;
  return n;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a6:	c9                   	leave  
 2a7:	c3                   	ret    

000002a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2ae:	8b 45 10             	mov    0x10(%ebp),%eax
 2b1:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	89 04 24             	mov    %eax,(%esp)
 2c2:	e8 2d ff ff ff       	call   1f4 <stosb>
  return dst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <strchr>:

char*
strchr(const char *s, char c)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	83 ec 04             	sub    $0x4,%esp
 2d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d8:	eb 12                	jmp    2ec <strchr+0x20>
    if(*s == c)
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	8a 00                	mov    (%eax),%al
 2df:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e2:	75 05                	jne    2e9 <strchr+0x1d>
      return (char*)s;
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	eb 11                	jmp    2fa <strchr+0x2e>
  for(; *s; s++)
 2e9:	ff 45 08             	incl   0x8(%ebp)
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	8a 00                	mov    (%eax),%al
 2f1:	84 c0                	test   %al,%al
 2f3:	75 e5                	jne    2da <strchr+0xe>
  return 0;
 2f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2fa:	c9                   	leave  
 2fb:	c3                   	ret    

000002fc <gets>:

char*
gets(char *buf, int max)
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 309:	eb 42                	jmp    34d <gets+0x51>
    cc = read(0, &c, 1);
 30b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 312:	00 
 313:	8d 45 ef             	lea    -0x11(%ebp),%eax
 316:	89 44 24 04          	mov    %eax,0x4(%esp)
 31a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 321:	e8 2f 01 00 00       	call   455 <read>
 326:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 329:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 32d:	7e 29                	jle    358 <gets+0x5c>
      break;
    buf[i++] = c;
 32f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	01 c2                	add    %eax,%edx
 337:	8a 45 ef             	mov    -0x11(%ebp),%al
 33a:	88 02                	mov    %al,(%edx)
 33c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 33f:	8a 45 ef             	mov    -0x11(%ebp),%al
 342:	3c 0a                	cmp    $0xa,%al
 344:	74 13                	je     359 <gets+0x5d>
 346:	8a 45 ef             	mov    -0x11(%ebp),%al
 349:	3c 0d                	cmp    $0xd,%al
 34b:	74 0c                	je     359 <gets+0x5d>
  for(i=0; i+1 < max; ){
 34d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 350:	40                   	inc    %eax
 351:	3b 45 0c             	cmp    0xc(%ebp),%eax
 354:	7c b5                	jl     30b <gets+0xf>
 356:	eb 01                	jmp    359 <gets+0x5d>
      break;
 358:	90                   	nop
      break;
  }
  buf[i] = '\0';
 359:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	01 d0                	add    %edx,%eax
 361:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <stat>:

int
stat(char *n, struct stat *st)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 376:	00 
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 fb 00 00 00       	call   47d <open>
 382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 389:	79 07                	jns    392 <stat+0x29>
    return -1;
 38b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 390:	eb 23                	jmp    3b5 <stat+0x4c>
  r = fstat(fd, st);
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	89 44 24 04          	mov    %eax,0x4(%esp)
 399:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39c:	89 04 24             	mov    %eax,(%esp)
 39f:	e8 f1 00 00 00       	call   495 <fstat>
 3a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 b3 00 00 00       	call   465 <close>
  return r;
 3b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b5:	c9                   	leave  
 3b6:	c3                   	ret    

000003b7 <atoi>:

int
atoi(const char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c4:	eb 21                	jmp    3e7 <atoi+0x30>
    n = n*10 + *s++ - '0';
 3c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c9:	89 d0                	mov    %edx,%eax
 3cb:	c1 e0 02             	shl    $0x2,%eax
 3ce:	01 d0                	add    %edx,%eax
 3d0:	d1 e0                	shl    %eax
 3d2:	89 c2                	mov    %eax,%edx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	8a 00                	mov    (%eax),%al
 3d9:	0f be c0             	movsbl %al,%eax
 3dc:	01 d0                	add    %edx,%eax
 3de:	83 e8 30             	sub    $0x30,%eax
 3e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3e4:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	8a 00                	mov    (%eax),%al
 3ec:	3c 2f                	cmp    $0x2f,%al
 3ee:	7e 09                	jle    3f9 <atoi+0x42>
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	8a 00                	mov    (%eax),%al
 3f5:	3c 39                	cmp    $0x39,%al
 3f7:	7e cd                	jle    3c6 <atoi+0xf>
  return n;
 3f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fc:	c9                   	leave  
 3fd:	c3                   	ret    

000003fe <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 40a:	8b 45 0c             	mov    0xc(%ebp),%eax
 40d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 410:	eb 10                	jmp    422 <memmove+0x24>
    *dst++ = *src++;
 412:	8b 45 f8             	mov    -0x8(%ebp),%eax
 415:	8a 10                	mov    (%eax),%dl
 417:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41a:	88 10                	mov    %dl,(%eax)
 41c:	ff 45 fc             	incl   -0x4(%ebp)
 41f:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 422:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 426:	0f 9f c0             	setg   %al
 429:	ff 4d 10             	decl   0x10(%ebp)
 42c:	84 c0                	test   %al,%al
 42e:	75 e2                	jne    412 <memmove+0x14>
  return vdst;
 430:	8b 45 08             	mov    0x8(%ebp),%eax
}
 433:	c9                   	leave  
 434:	c3                   	ret    

00000435 <fork>:
 435:	b8 01 00 00 00       	mov    $0x1,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <exit>:
 43d:	b8 02 00 00 00       	mov    $0x2,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <wait>:
 445:	b8 03 00 00 00       	mov    $0x3,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <pipe>:
 44d:	b8 04 00 00 00       	mov    $0x4,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <read>:
 455:	b8 05 00 00 00       	mov    $0x5,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <write>:
 45d:	b8 10 00 00 00       	mov    $0x10,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <close>:
 465:	b8 15 00 00 00       	mov    $0x15,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <kill>:
 46d:	b8 06 00 00 00       	mov    $0x6,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <exec>:
 475:	b8 07 00 00 00       	mov    $0x7,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <open>:
 47d:	b8 0f 00 00 00       	mov    $0xf,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <mknod>:
 485:	b8 11 00 00 00       	mov    $0x11,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <unlink>:
 48d:	b8 12 00 00 00       	mov    $0x12,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <fstat>:
 495:	b8 08 00 00 00       	mov    $0x8,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <link>:
 49d:	b8 13 00 00 00       	mov    $0x13,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <mkdir>:
 4a5:	b8 14 00 00 00       	mov    $0x14,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <chdir>:
 4ad:	b8 09 00 00 00       	mov    $0x9,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <dup>:
 4b5:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <getpid>:
 4bd:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <sbrk>:
 4c5:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <sleep>:
 4cd:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <uptime>:
 4d5:	b8 0e 00 00 00       	mov    $0xe,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <lseek>:
 4dd:	b8 16 00 00 00       	mov    $0x16,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <isatty>:
 4e5:	b8 17 00 00 00       	mov    $0x17,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <procstat>:
 4ed:	b8 18 00 00 00       	mov    $0x18,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <set_priority>:
 4f5:	b8 19 00 00 00       	mov    $0x19,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <semget>:
 4fd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <semfree>:
 505:	b8 1b 00 00 00       	mov    $0x1b,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <semdown>:
 50d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <semup>:
 515:	b8 1d 00 00 00       	mov    $0x1d,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <shm_create>:
 51d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <shm_close>:
 525:	b8 1f 00 00 00       	mov    $0x1f,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <shm_get>:
 52d:	b8 20 00 00 00       	mov    $0x20,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 535:	55                   	push   %ebp
 536:	89 e5                	mov    %esp,%ebp
 538:	83 ec 28             	sub    $0x28,%esp
 53b:	8b 45 0c             	mov    0xc(%ebp),%eax
 53e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 541:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 548:	00 
 549:	8d 45 f4             	lea    -0xc(%ebp),%eax
 54c:	89 44 24 04          	mov    %eax,0x4(%esp)
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	89 04 24             	mov    %eax,(%esp)
 556:	e8 02 ff ff ff       	call   45d <write>
}
 55b:	c9                   	leave  
 55c:	c3                   	ret    

0000055d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 55d:	55                   	push   %ebp
 55e:	89 e5                	mov    %esp,%ebp
 560:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 563:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 56a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 56e:	74 17                	je     587 <printint+0x2a>
 570:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 574:	79 11                	jns    587 <printint+0x2a>
    neg = 1;
 576:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 57d:	8b 45 0c             	mov    0xc(%ebp),%eax
 580:	f7 d8                	neg    %eax
 582:	89 45 ec             	mov    %eax,-0x14(%ebp)
 585:	eb 06                	jmp    58d <printint+0x30>
  } else {
    x = xx;
 587:	8b 45 0c             	mov    0xc(%ebp),%eax
 58a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 58d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 594:	8b 4d 10             	mov    0x10(%ebp),%ecx
 597:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59a:	ba 00 00 00 00       	mov    $0x0,%edx
 59f:	f7 f1                	div    %ecx
 5a1:	89 d0                	mov    %edx,%eax
 5a3:	8a 80 20 0d 00 00    	mov    0xd20(%eax),%al
 5a9:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 5ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5af:	01 ca                	add    %ecx,%edx
 5b1:	88 02                	mov    %al,(%edx)
 5b3:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 5b6:	8b 55 10             	mov    0x10(%ebp),%edx
 5b9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5bf:	ba 00 00 00 00       	mov    $0x0,%edx
 5c4:	f7 75 d4             	divl   -0x2c(%ebp)
 5c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ce:	75 c4                	jne    594 <printint+0x37>
  if(neg)
 5d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d4:	74 2c                	je     602 <printint+0xa5>
    buf[i++] = '-';
 5d6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5dc:	01 d0                	add    %edx,%eax
 5de:	c6 00 2d             	movb   $0x2d,(%eax)
 5e1:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 5e4:	eb 1c                	jmp    602 <printint+0xa5>
    putc(fd, buf[i]);
 5e6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ec:	01 d0                	add    %edx,%eax
 5ee:	8a 00                	mov    (%eax),%al
 5f0:	0f be c0             	movsbl %al,%eax
 5f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	89 04 24             	mov    %eax,(%esp)
 5fd:	e8 33 ff ff ff       	call   535 <putc>
  while(--i >= 0)
 602:	ff 4d f4             	decl   -0xc(%ebp)
 605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 609:	79 db                	jns    5e6 <printint+0x89>
}
 60b:	c9                   	leave  
 60c:	c3                   	ret    

0000060d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60d:	55                   	push   %ebp
 60e:	89 e5                	mov    %esp,%ebp
 610:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 613:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 61a:	8d 45 0c             	lea    0xc(%ebp),%eax
 61d:	83 c0 04             	add    $0x4,%eax
 620:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 623:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 62a:	e9 78 01 00 00       	jmp    7a7 <printf+0x19a>
    c = fmt[i] & 0xff;
 62f:	8b 55 0c             	mov    0xc(%ebp),%edx
 632:	8b 45 f0             	mov    -0x10(%ebp),%eax
 635:	01 d0                	add    %edx,%eax
 637:	8a 00                	mov    (%eax),%al
 639:	0f be c0             	movsbl %al,%eax
 63c:	25 ff 00 00 00       	and    $0xff,%eax
 641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 644:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 648:	75 2c                	jne    676 <printf+0x69>
      if(c == '%'){
 64a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64e:	75 0c                	jne    65c <printf+0x4f>
        state = '%';
 650:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 657:	e9 48 01 00 00       	jmp    7a4 <printf+0x197>
      } else {
        putc(fd, c);
 65c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	89 44 24 04          	mov    %eax,0x4(%esp)
 666:	8b 45 08             	mov    0x8(%ebp),%eax
 669:	89 04 24             	mov    %eax,(%esp)
 66c:	e8 c4 fe ff ff       	call   535 <putc>
 671:	e9 2e 01 00 00       	jmp    7a4 <printf+0x197>
      }
    } else if(state == '%'){
 676:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 67a:	0f 85 24 01 00 00    	jne    7a4 <printf+0x197>
      if(c == 'd'){
 680:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 684:	75 2d                	jne    6b3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 686:	8b 45 e8             	mov    -0x18(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 692:	00 
 693:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 69a:	00 
 69b:	89 44 24 04          	mov    %eax,0x4(%esp)
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	89 04 24             	mov    %eax,(%esp)
 6a5:	e8 b3 fe ff ff       	call   55d <printint>
        ap++;
 6aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ae:	e9 ea 00 00 00       	jmp    79d <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 6b3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6b7:	74 06                	je     6bf <printf+0xb2>
 6b9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6bd:	75 2d                	jne    6ec <printf+0xdf>
        printint(fd, *ap, 16, 0);
 6bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6cb:	00 
 6cc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6d3:	00 
 6d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d8:	8b 45 08             	mov    0x8(%ebp),%eax
 6db:	89 04 24             	mov    %eax,(%esp)
 6de:	e8 7a fe ff ff       	call   55d <printint>
        ap++;
 6e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e7:	e9 b1 00 00 00       	jmp    79d <printf+0x190>
      } else if(c == 's'){
 6ec:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6f0:	75 43                	jne    735 <printf+0x128>
        s = (char*)*ap;
 6f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f5:	8b 00                	mov    (%eax),%eax
 6f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 702:	75 25                	jne    729 <printf+0x11c>
          s = "(null)";
 704:	c7 45 f4 ba 0a 00 00 	movl   $0xaba,-0xc(%ebp)
        while(*s != 0){
 70b:	eb 1c                	jmp    729 <printf+0x11c>
          putc(fd, *s);
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	8a 00                	mov    (%eax),%al
 712:	0f be c0             	movsbl %al,%eax
 715:	89 44 24 04          	mov    %eax,0x4(%esp)
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 11 fe ff ff       	call   535 <putc>
          s++;
 724:	ff 45 f4             	incl   -0xc(%ebp)
 727:	eb 01                	jmp    72a <printf+0x11d>
        while(*s != 0){
 729:	90                   	nop
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	8a 00                	mov    (%eax),%al
 72f:	84 c0                	test   %al,%al
 731:	75 da                	jne    70d <printf+0x100>
 733:	eb 68                	jmp    79d <printf+0x190>
        }
      } else if(c == 'c'){
 735:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 739:	75 1d                	jne    758 <printf+0x14b>
        putc(fd, *ap);
 73b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	89 44 24 04          	mov    %eax,0x4(%esp)
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 e3 fd ff ff       	call   535 <putc>
        ap++;
 752:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 756:	eb 45                	jmp    79d <printf+0x190>
      } else if(c == '%'){
 758:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75c:	75 17                	jne    775 <printf+0x168>
        putc(fd, c);
 75e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 761:	0f be c0             	movsbl %al,%eax
 764:	89 44 24 04          	mov    %eax,0x4(%esp)
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	89 04 24             	mov    %eax,(%esp)
 76e:	e8 c2 fd ff ff       	call   535 <putc>
 773:	eb 28                	jmp    79d <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 775:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 77c:	00 
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	89 04 24             	mov    %eax,(%esp)
 783:	e8 ad fd ff ff       	call   535 <putc>
        putc(fd, c);
 788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78b:	0f be c0             	movsbl %al,%eax
 78e:	89 44 24 04          	mov    %eax,0x4(%esp)
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	89 04 24             	mov    %eax,(%esp)
 798:	e8 98 fd ff ff       	call   535 <putc>
      }
      state = 0;
 79d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7a4:	ff 45 f0             	incl   -0x10(%ebp)
 7a7:	8b 55 0c             	mov    0xc(%ebp),%edx
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	01 d0                	add    %edx,%eax
 7af:	8a 00                	mov    (%eax),%al
 7b1:	84 c0                	test   %al,%al
 7b3:	0f 85 76 fe ff ff    	jne    62f <printf+0x22>
    }
  }
}
 7b9:	c9                   	leave  
 7ba:	c3                   	ret    

000007bb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bb:	55                   	push   %ebp
 7bc:	89 e5                	mov    %esp,%ebp
 7be:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c1:	8b 45 08             	mov    0x8(%ebp),%eax
 7c4:	83 e8 08             	sub    $0x8,%eax
 7c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	a1 3c 0d 00 00       	mov    0xd3c,%eax
 7cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d2:	eb 24                	jmp    7f8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7dc:	77 12                	ja     7f0 <free+0x35>
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e4:	77 24                	ja     80a <free+0x4f>
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ee:	77 1a                	ja     80a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fe:	76 d4                	jbe    7d4 <free+0x19>
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 808:	76 ca                	jbe    7d4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	01 c2                	add    %eax,%edx
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	39 c2                	cmp    %eax,%edx
 823:	75 24                	jne    849 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	8b 50 04             	mov    0x4(%eax),%edx
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	01 c2                	add    %eax,%edx
 835:	8b 45 f8             	mov    -0x8(%ebp),%eax
 838:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	8b 00                	mov    (%eax),%eax
 840:	8b 10                	mov    (%eax),%edx
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	89 10                	mov    %edx,(%eax)
 847:	eb 0a                	jmp    853 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 10                	mov    (%eax),%edx
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 853:	8b 45 fc             	mov    -0x4(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	01 d0                	add    %edx,%eax
 865:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 868:	75 20                	jne    88a <free+0xcf>
    p->s.size += bp->s.size;
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	8b 40 04             	mov    0x4(%eax),%eax
 876:	01 c2                	add    %eax,%edx
 878:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 87e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 881:	8b 10                	mov    (%eax),%edx
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
 886:	89 10                	mov    %edx,(%eax)
 888:	eb 08                	jmp    892 <free+0xd7>
  } else
    p->s.ptr = bp;
 88a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 890:	89 10                	mov    %edx,(%eax)
  freep = p;
 892:	8b 45 fc             	mov    -0x4(%ebp),%eax
 895:	a3 3c 0d 00 00       	mov    %eax,0xd3c
}
 89a:	c9                   	leave  
 89b:	c3                   	ret    

0000089c <morecore>:

static Header*
morecore(uint nu)
{
 89c:	55                   	push   %ebp
 89d:	89 e5                	mov    %esp,%ebp
 89f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8a2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8a9:	77 07                	ja     8b2 <morecore+0x16>
    nu = 4096;
 8ab:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8b2:	8b 45 08             	mov    0x8(%ebp),%eax
 8b5:	c1 e0 03             	shl    $0x3,%eax
 8b8:	89 04 24             	mov    %eax,(%esp)
 8bb:	e8 05 fc ff ff       	call   4c5 <sbrk>
 8c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8c3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8c7:	75 07                	jne    8d0 <morecore+0x34>
    return 0;
 8c9:	b8 00 00 00 00       	mov    $0x0,%eax
 8ce:	eb 22                	jmp    8f2 <morecore+0x56>
  hp = (Header*)p;
 8d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	8b 55 08             	mov    0x8(%ebp),%edx
 8dc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	83 c0 08             	add    $0x8,%eax
 8e5:	89 04 24             	mov    %eax,(%esp)
 8e8:	e8 ce fe ff ff       	call   7bb <free>
  return freep;
 8ed:	a1 3c 0d 00 00       	mov    0xd3c,%eax
}
 8f2:	c9                   	leave  
 8f3:	c3                   	ret    

000008f4 <malloc>:

void*
malloc(uint nbytes)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fa:	8b 45 08             	mov    0x8(%ebp),%eax
 8fd:	83 c0 07             	add    $0x7,%eax
 900:	c1 e8 03             	shr    $0x3,%eax
 903:	40                   	inc    %eax
 904:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 907:	a1 3c 0d 00 00       	mov    0xd3c,%eax
 90c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 913:	75 23                	jne    938 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 915:	c7 45 f0 34 0d 00 00 	movl   $0xd34,-0x10(%ebp)
 91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91f:	a3 3c 0d 00 00       	mov    %eax,0xd3c
 924:	a1 3c 0d 00 00       	mov    0xd3c,%eax
 929:	a3 34 0d 00 00       	mov    %eax,0xd34
    base.s.size = 0;
 92e:	c7 05 38 0d 00 00 00 	movl   $0x0,0xd38
 935:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 949:	72 4d                	jb     998 <malloc+0xa4>
      if(p->s.size == nunits)
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	8b 40 04             	mov    0x4(%eax),%eax
 951:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 954:	75 0c                	jne    962 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	8b 10                	mov    (%eax),%edx
 95b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95e:	89 10                	mov    %edx,(%eax)
 960:	eb 26                	jmp    988 <malloc+0x94>
      else {
        p->s.size -= nunits;
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	89 c2                	mov    %eax,%edx
 96a:	2b 55 ec             	sub    -0x14(%ebp),%edx
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	8b 40 04             	mov    0x4(%eax),%eax
 979:	c1 e0 03             	shl    $0x3,%eax
 97c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 97f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 982:	8b 55 ec             	mov    -0x14(%ebp),%edx
 985:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 988:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98b:	a3 3c 0d 00 00       	mov    %eax,0xd3c
      return (void*)(p + 1);
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	83 c0 08             	add    $0x8,%eax
 996:	eb 38                	jmp    9d0 <malloc+0xdc>
    }
    if(p == freep)
 998:	a1 3c 0d 00 00       	mov    0xd3c,%eax
 99d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9a0:	75 1b                	jne    9bd <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 9a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a5:	89 04 24             	mov    %eax,(%esp)
 9a8:	e8 ef fe ff ff       	call   89c <morecore>
 9ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b4:	75 07                	jne    9bd <malloc+0xc9>
        return 0;
 9b6:	b8 00 00 00 00       	mov    $0x0,%eax
 9bb:	eb 13                	jmp    9d0 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 00                	mov    (%eax),%eax
 9c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 9cb:	e9 70 ff ff ff       	jmp    940 <malloc+0x4c>
}
 9d0:	c9                   	leave  
 9d1:	c3                   	ret    
