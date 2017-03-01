
_init:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 0b 09 00 00 	movl   $0x90b,(%esp)
  18:	e8 94 03 00 00       	call   3b1 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 0b 09 00 00 	movl   $0x90b,(%esp)
  38:	e8 7c 03 00 00       	call   3b9 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 0b 09 00 00 	movl   $0x90b,(%esp)
  4c:	e8 60 03 00 00       	call   3b1 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 8c 03 00 00       	call   3e9 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 80 03 00 00       	call   3e9 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 13 09 00 	movl   $0x913,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 c1 04 00 00       	call   541 <printf>
    pid = fork();
  80:	e8 e4 02 00 00       	call   369 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 26 09 00 	movl   $0x926,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 9d 04 00 00       	call   541 <printf>
      exit();
  a4:	e8 c8 02 00 00       	call   371 <exit>
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 55                	jne    105 <main+0x105>
       printf(1, "CICLO INFINITO DE SH esperando comandos\n");
  b0:	c7 44 24 04 3c 09 00 	movl   $0x93c,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bf:	e8 7d 04 00 00       	call   541 <printf>
      exec("sh", argv);
  c4:	c7 44 24 04 c8 0b 00 	movl   $0xbc8,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 08 09 00 00 	movl   $0x908,(%esp)
  d3:	e8 d1 02 00 00       	call   3a9 <exec>
      printf(1, "init: exec sh failed\n");
  d8:	c7 44 24 04 65 09 00 	movl   $0x965,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 55 04 00 00       	call   541 <printf>
      exit();
  ec:	e8 80 02 00 00       	call   371 <exit>
      printf(1, "zombie!\n");
  f1:	c7 44 24 04 7b 09 00 	movl   $0x97b,0x4(%esp)
  f8:	00 
  f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 100:	e8 3c 04 00 00       	call   541 <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
 105:	e8 6f 02 00 00       	call   379 <wait>
 10a:	89 44 24 18          	mov    %eax,0x18(%esp)
 10e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 113:	0f 88 52 ff ff ff    	js     6b <main+0x6b>
 119:	8b 44 24 18          	mov    0x18(%esp),%eax
 11d:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 121:	75 ce                	jne    f1 <main+0xf1>
  }
 123:	e9 43 ff ff ff       	jmp    6b <main+0x6b>

00000128 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	57                   	push   %edi
 12c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 12d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 130:	8b 55 10             	mov    0x10(%ebp),%edx
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	89 cb                	mov    %ecx,%ebx
 138:	89 df                	mov    %ebx,%edi
 13a:	89 d1                	mov    %edx,%ecx
 13c:	fc                   	cld    
 13d:	f3 aa                	rep stos %al,%es:(%edi)
 13f:	89 ca                	mov    %ecx,%edx
 141:	89 fb                	mov    %edi,%ebx
 143:	89 5d 08             	mov    %ebx,0x8(%ebp)
 146:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 149:	5b                   	pop    %ebx
 14a:	5f                   	pop    %edi
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    

0000014d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 159:	90                   	nop
 15a:	8b 45 0c             	mov    0xc(%ebp),%eax
 15d:	8a 10                	mov    (%eax),%dl
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	88 10                	mov    %dl,(%eax)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	8a 00                	mov    (%eax),%al
 169:	84 c0                	test   %al,%al
 16b:	0f 95 c0             	setne  %al
 16e:	ff 45 08             	incl   0x8(%ebp)
 171:	ff 45 0c             	incl   0xc(%ebp)
 174:	84 c0                	test   %al,%al
 176:	75 e2                	jne    15a <strcpy+0xd>
    ;
  return os;
 178:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 180:	eb 06                	jmp    188 <strcmp+0xb>
    p++, q++;
 182:	ff 45 08             	incl   0x8(%ebp)
 185:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	8a 00                	mov    (%eax),%al
 18d:	84 c0                	test   %al,%al
 18f:	74 0e                	je     19f <strcmp+0x22>
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	8a 10                	mov    (%eax),%dl
 196:	8b 45 0c             	mov    0xc(%ebp),%eax
 199:	8a 00                	mov    (%eax),%al
 19b:	38 c2                	cmp    %al,%dl
 19d:	74 e3                	je     182 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8a 00                	mov    (%eax),%al
 1a4:	0f b6 d0             	movzbl %al,%edx
 1a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1aa:	8a 00                	mov    (%eax),%al
 1ac:	0f b6 c0             	movzbl %al,%eax
 1af:	89 d1                	mov    %edx,%ecx
 1b1:	29 c1                	sub    %eax,%ecx
 1b3:	89 c8                	mov    %ecx,%eax
}
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    

000001b7 <strlen>:

uint
strlen(char *s)
{
 1b7:	55                   	push   %ebp
 1b8:	89 e5                	mov    %esp,%ebp
 1ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c4:	eb 03                	jmp    1c9 <strlen+0x12>
 1c6:	ff 45 fc             	incl   -0x4(%ebp)
 1c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	01 d0                	add    %edx,%eax
 1d1:	8a 00                	mov    (%eax),%al
 1d3:	84 c0                	test   %al,%al
 1d5:	75 ef                	jne    1c6 <strlen+0xf>
    ;
  return n;
 1d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1da:	c9                   	leave  
 1db:	c3                   	ret    

000001dc <memset>:

void*
memset(void *dst, int c, uint n)
{
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1e2:	8b 45 10             	mov    0x10(%ebp),%eax
 1e5:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	89 04 24             	mov    %eax,(%esp)
 1f6:	e8 2d ff ff ff       	call   128 <stosb>
  return dst;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fe:	c9                   	leave  
 1ff:	c3                   	ret    

00000200 <strchr>:

char*
strchr(const char *s, char c)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 04             	sub    $0x4,%esp
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20c:	eb 12                	jmp    220 <strchr+0x20>
    if(*s == c)
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8a 00                	mov    (%eax),%al
 213:	3a 45 fc             	cmp    -0x4(%ebp),%al
 216:	75 05                	jne    21d <strchr+0x1d>
      return (char*)s;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	eb 11                	jmp    22e <strchr+0x2e>
  for(; *s; s++)
 21d:	ff 45 08             	incl   0x8(%ebp)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	8a 00                	mov    (%eax),%al
 225:	84 c0                	test   %al,%al
 227:	75 e5                	jne    20e <strchr+0xe>
  return 0;
 229:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22e:	c9                   	leave  
 22f:	c3                   	ret    

00000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23d:	eb 42                	jmp    281 <gets+0x51>
    cc = read(0, &c, 1);
 23f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 246:	00 
 247:	8d 45 ef             	lea    -0x11(%ebp),%eax
 24a:	89 44 24 04          	mov    %eax,0x4(%esp)
 24e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 255:	e8 2f 01 00 00       	call   389 <read>
 25a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 261:	7e 29                	jle    28c <gets+0x5c>
      break;
    buf[i++] = c;
 263:	8b 55 f4             	mov    -0xc(%ebp),%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 c2                	add    %eax,%edx
 26b:	8a 45 ef             	mov    -0x11(%ebp),%al
 26e:	88 02                	mov    %al,(%edx)
 270:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 273:	8a 45 ef             	mov    -0x11(%ebp),%al
 276:	3c 0a                	cmp    $0xa,%al
 278:	74 13                	je     28d <gets+0x5d>
 27a:	8a 45 ef             	mov    -0x11(%ebp),%al
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 0c                	je     28d <gets+0x5d>
  for(i=0; i+1 < max; ){
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	40                   	inc    %eax
 285:	3b 45 0c             	cmp    0xc(%ebp),%eax
 288:	7c b5                	jl     23f <gets+0xf>
 28a:	eb 01                	jmp    28d <gets+0x5d>
      break;
 28c:	90                   	nop
      break;
  }
  buf[i] = '\0';
 28d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 290:	8b 45 08             	mov    0x8(%ebp),%eax
 293:	01 d0                	add    %edx,%eax
 295:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <stat>:

int
stat(char *n, struct stat *st)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2aa:	00 
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	89 04 24             	mov    %eax,(%esp)
 2b1:	e8 fb 00 00 00       	call   3b1 <open>
 2b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bd:	79 07                	jns    2c6 <stat+0x29>
    return -1;
 2bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c4:	eb 23                	jmp    2e9 <stat+0x4c>
  r = fstat(fd, st);
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d0:	89 04 24             	mov    %eax,(%esp)
 2d3:	e8 f1 00 00 00       	call   3c9 <fstat>
 2d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	89 04 24             	mov    %eax,(%esp)
 2e1:	e8 b3 00 00 00       	call   399 <close>
  return r;
 2e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <atoi>:

int
atoi(const char *s)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f8:	eb 21                	jmp    31b <atoi+0x30>
    n = n*10 + *s++ - '0';
 2fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fd:	89 d0                	mov    %edx,%eax
 2ff:	c1 e0 02             	shl    $0x2,%eax
 302:	01 d0                	add    %edx,%eax
 304:	d1 e0                	shl    %eax
 306:	89 c2                	mov    %eax,%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	8a 00                	mov    (%eax),%al
 30d:	0f be c0             	movsbl %al,%eax
 310:	01 d0                	add    %edx,%eax
 312:	83 e8 30             	sub    $0x30,%eax
 315:	89 45 fc             	mov    %eax,-0x4(%ebp)
 318:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	3c 2f                	cmp    $0x2f,%al
 322:	7e 09                	jle    32d <atoi+0x42>
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8a 00                	mov    (%eax),%al
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e cd                	jle    2fa <atoi+0xf>
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 344:	eb 10                	jmp    356 <memmove+0x24>
    *dst++ = *src++;
 346:	8b 45 f8             	mov    -0x8(%ebp),%eax
 349:	8a 10                	mov    (%eax),%dl
 34b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34e:	88 10                	mov    %dl,(%eax)
 350:	ff 45 fc             	incl   -0x4(%ebp)
 353:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 356:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 35a:	0f 9f c0             	setg   %al
 35d:	ff 4d 10             	decl   0x10(%ebp)
 360:	84 c0                	test   %al,%al
 362:	75 e2                	jne    346 <memmove+0x14>
  return vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <fork>:
 369:	b8 01 00 00 00       	mov    $0x1,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <exit>:
 371:	b8 02 00 00 00       	mov    $0x2,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <wait>:
 379:	b8 03 00 00 00       	mov    $0x3,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <pipe>:
 381:	b8 04 00 00 00       	mov    $0x4,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <read>:
 389:	b8 05 00 00 00       	mov    $0x5,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <write>:
 391:	b8 10 00 00 00       	mov    $0x10,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <close>:
 399:	b8 15 00 00 00       	mov    $0x15,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <kill>:
 3a1:	b8 06 00 00 00       	mov    $0x6,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <exec>:
 3a9:	b8 07 00 00 00       	mov    $0x7,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <open>:
 3b1:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <mknod>:
 3b9:	b8 11 00 00 00       	mov    $0x11,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <unlink>:
 3c1:	b8 12 00 00 00       	mov    $0x12,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <fstat>:
 3c9:	b8 08 00 00 00       	mov    $0x8,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <link>:
 3d1:	b8 13 00 00 00       	mov    $0x13,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <mkdir>:
 3d9:	b8 14 00 00 00       	mov    $0x14,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <chdir>:
 3e1:	b8 09 00 00 00       	mov    $0x9,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <dup>:
 3e9:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <getpid>:
 3f1:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <sbrk>:
 3f9:	b8 0c 00 00 00       	mov    $0xc,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <sleep>:
 401:	b8 0d 00 00 00       	mov    $0xd,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <uptime>:
 409:	b8 0e 00 00 00       	mov    $0xe,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <lseek>:
 411:	b8 16 00 00 00       	mov    $0x16,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <isatty>:
 419:	b8 17 00 00 00       	mov    $0x17,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <procstat>:
 421:	b8 18 00 00 00       	mov    $0x18,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <set_priority>:
 429:	b8 19 00 00 00       	mov    $0x19,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <semget>:
 431:	b8 1a 00 00 00       	mov    $0x1a,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <semfree>:
 439:	b8 1b 00 00 00       	mov    $0x1b,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <semdown>:
 441:	b8 1c 00 00 00       	mov    $0x1c,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <semup>:
 449:	b8 1d 00 00 00       	mov    $0x1d,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <shm_create>:
 451:	b8 1e 00 00 00       	mov    $0x1e,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <shm_close>:
 459:	b8 1f 00 00 00       	mov    $0x1f,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <shm_get>:
 461:	b8 20 00 00 00       	mov    $0x20,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 28             	sub    $0x28,%esp
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 475:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 47c:	00 
 47d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 480:	89 44 24 04          	mov    %eax,0x4(%esp)
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	89 04 24             	mov    %eax,(%esp)
 48a:	e8 02 ff ff ff       	call   391 <write>
}
 48f:	c9                   	leave  
 490:	c3                   	ret    

00000491 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 491:	55                   	push   %ebp
 492:	89 e5                	mov    %esp,%ebp
 494:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 497:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a2:	74 17                	je     4bb <printint+0x2a>
 4a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a8:	79 11                	jns    4bb <printint+0x2a>
    neg = 1;
 4aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b4:	f7 d8                	neg    %eax
 4b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b9:	eb 06                	jmp    4c1 <printint+0x30>
  } else {
    x = xx;
 4bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ce:	ba 00 00 00 00       	mov    $0x0,%edx
 4d3:	f7 f1                	div    %ecx
 4d5:	89 d0                	mov    %edx,%eax
 4d7:	8a 80 d0 0b 00 00    	mov    0xbd0(%eax),%al
 4dd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4e3:	01 ca                	add    %ecx,%edx
 4e5:	88 02                	mov    %al,(%edx)
 4e7:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4ea:	8b 55 10             	mov    0x10(%ebp),%edx
 4ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f3:	ba 00 00 00 00       	mov    $0x0,%edx
 4f8:	f7 75 d4             	divl   -0x2c(%ebp)
 4fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 502:	75 c4                	jne    4c8 <printint+0x37>
  if(neg)
 504:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 508:	74 2c                	je     536 <printint+0xa5>
    buf[i++] = '-';
 50a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 510:	01 d0                	add    %edx,%eax
 512:	c6 00 2d             	movb   $0x2d,(%eax)
 515:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 518:	eb 1c                	jmp    536 <printint+0xa5>
    putc(fd, buf[i]);
 51a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 51d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 520:	01 d0                	add    %edx,%eax
 522:	8a 00                	mov    (%eax),%al
 524:	0f be c0             	movsbl %al,%eax
 527:	89 44 24 04          	mov    %eax,0x4(%esp)
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	89 04 24             	mov    %eax,(%esp)
 531:	e8 33 ff ff ff       	call   469 <putc>
  while(--i >= 0)
 536:	ff 4d f4             	decl   -0xc(%ebp)
 539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53d:	79 db                	jns    51a <printint+0x89>
}
 53f:	c9                   	leave  
 540:	c3                   	ret    

00000541 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 541:	55                   	push   %ebp
 542:	89 e5                	mov    %esp,%ebp
 544:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 547:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 54e:	8d 45 0c             	lea    0xc(%ebp),%eax
 551:	83 c0 04             	add    $0x4,%eax
 554:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 557:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 55e:	e9 78 01 00 00       	jmp    6db <printf+0x19a>
    c = fmt[i] & 0xff;
 563:	8b 55 0c             	mov    0xc(%ebp),%edx
 566:	8b 45 f0             	mov    -0x10(%ebp),%eax
 569:	01 d0                	add    %edx,%eax
 56b:	8a 00                	mov    (%eax),%al
 56d:	0f be c0             	movsbl %al,%eax
 570:	25 ff 00 00 00       	and    $0xff,%eax
 575:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57c:	75 2c                	jne    5aa <printf+0x69>
      if(c == '%'){
 57e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 582:	75 0c                	jne    590 <printf+0x4f>
        state = '%';
 584:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 58b:	e9 48 01 00 00       	jmp    6d8 <printf+0x197>
      } else {
        putc(fd, c);
 590:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 593:	0f be c0             	movsbl %al,%eax
 596:	89 44 24 04          	mov    %eax,0x4(%esp)
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 04 24             	mov    %eax,(%esp)
 5a0:	e8 c4 fe ff ff       	call   469 <putc>
 5a5:	e9 2e 01 00 00       	jmp    6d8 <printf+0x197>
      }
    } else if(state == '%'){
 5aa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ae:	0f 85 24 01 00 00    	jne    6d8 <printf+0x197>
      if(c == 'd'){
 5b4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b8:	75 2d                	jne    5e7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5bd:	8b 00                	mov    (%eax),%eax
 5bf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5c6:	00 
 5c7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ce:	00 
 5cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	89 04 24             	mov    %eax,(%esp)
 5d9:	e8 b3 fe ff ff       	call   491 <printint>
        ap++;
 5de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e2:	e9 ea 00 00 00       	jmp    6d1 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5e7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5eb:	74 06                	je     5f3 <printf+0xb2>
 5ed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f1:	75 2d                	jne    620 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f6:	8b 00                	mov    (%eax),%eax
 5f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ff:	00 
 600:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 607:	00 
 608:	89 44 24 04          	mov    %eax,0x4(%esp)
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	89 04 24             	mov    %eax,(%esp)
 612:	e8 7a fe ff ff       	call   491 <printint>
        ap++;
 617:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61b:	e9 b1 00 00 00       	jmp    6d1 <printf+0x190>
      } else if(c == 's'){
 620:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 624:	75 43                	jne    669 <printf+0x128>
        s = (char*)*ap;
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 62e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 636:	75 25                	jne    65d <printf+0x11c>
          s = "(null)";
 638:	c7 45 f4 84 09 00 00 	movl   $0x984,-0xc(%ebp)
        while(*s != 0){
 63f:	eb 1c                	jmp    65d <printf+0x11c>
          putc(fd, *s);
 641:	8b 45 f4             	mov    -0xc(%ebp),%eax
 644:	8a 00                	mov    (%eax),%al
 646:	0f be c0             	movsbl %al,%eax
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 11 fe ff ff       	call   469 <putc>
          s++;
 658:	ff 45 f4             	incl   -0xc(%ebp)
 65b:	eb 01                	jmp    65e <printf+0x11d>
        while(*s != 0){
 65d:	90                   	nop
 65e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 661:	8a 00                	mov    (%eax),%al
 663:	84 c0                	test   %al,%al
 665:	75 da                	jne    641 <printf+0x100>
 667:	eb 68                	jmp    6d1 <printf+0x190>
        }
      } else if(c == 'c'){
 669:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 66d:	75 1d                	jne    68c <printf+0x14b>
        putc(fd, *ap);
 66f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 e3 fd ff ff       	call   469 <putc>
        ap++;
 686:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68a:	eb 45                	jmp    6d1 <printf+0x190>
      } else if(c == '%'){
 68c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 690:	75 17                	jne    6a9 <printf+0x168>
        putc(fd, c);
 692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 695:	0f be c0             	movsbl %al,%eax
 698:	89 44 24 04          	mov    %eax,0x4(%esp)
 69c:	8b 45 08             	mov    0x8(%ebp),%eax
 69f:	89 04 24             	mov    %eax,(%esp)
 6a2:	e8 c2 fd ff ff       	call   469 <putc>
 6a7:	eb 28                	jmp    6d1 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6b0:	00 
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	89 04 24             	mov    %eax,(%esp)
 6b7:	e8 ad fd ff ff       	call   469 <putc>
        putc(fd, c);
 6bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bf:	0f be c0             	movsbl %al,%eax
 6c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c6:	8b 45 08             	mov    0x8(%ebp),%eax
 6c9:	89 04 24             	mov    %eax,(%esp)
 6cc:	e8 98 fd ff ff       	call   469 <putc>
      }
      state = 0;
 6d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6d8:	ff 45 f0             	incl   -0x10(%ebp)
 6db:	8b 55 0c             	mov    0xc(%ebp),%edx
 6de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e1:	01 d0                	add    %edx,%eax
 6e3:	8a 00                	mov    (%eax),%al
 6e5:	84 c0                	test   %al,%al
 6e7:	0f 85 76 fe ff ff    	jne    563 <printf+0x22>
    }
  }
}
 6ed:	c9                   	leave  
 6ee:	c3                   	ret    

000006ef <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f5:	8b 45 08             	mov    0x8(%ebp),%eax
 6f8:	83 e8 08             	sub    $0x8,%eax
 6fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fe:	a1 ec 0b 00 00       	mov    0xbec,%eax
 703:	89 45 fc             	mov    %eax,-0x4(%ebp)
 706:	eb 24                	jmp    72c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 00                	mov    (%eax),%eax
 70d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 710:	77 12                	ja     724 <free+0x35>
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 718:	77 24                	ja     73e <free+0x4f>
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 722:	77 1a                	ja     73e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 00                	mov    (%eax),%eax
 729:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	76 d4                	jbe    708 <free+0x19>
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73c:	76 ca                	jbe    708 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	8b 40 04             	mov    0x4(%eax),%eax
 744:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	01 c2                	add    %eax,%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	39 c2                	cmp    %eax,%edx
 757:	75 24                	jne    77d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	8b 50 04             	mov    0x4(%eax),%edx
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	8b 40 04             	mov    0x4(%eax),%eax
 767:	01 c2                	add    %eax,%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
 77b:	eb 0a                	jmp    787 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 77d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 780:	8b 10                	mov    (%eax),%edx
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	01 d0                	add    %edx,%eax
 799:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79c:	75 20                	jne    7be <free+0xcf>
    p->s.size += bp->s.size;
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 50 04             	mov    0x4(%eax),%edx
 7a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a7:	8b 40 04             	mov    0x4(%eax),%eax
 7aa:	01 c2                	add    %eax,%edx
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
 7bc:	eb 08                	jmp    7c6 <free+0xd7>
  } else
    p->s.ptr = bp;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c4:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	a3 ec 0b 00 00       	mov    %eax,0xbec
}
 7ce:	c9                   	leave  
 7cf:	c3                   	ret    

000007d0 <morecore>:

static Header*
morecore(uint nu)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7dd:	77 07                	ja     7e6 <morecore+0x16>
    nu = 4096;
 7df:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e6:	8b 45 08             	mov    0x8(%ebp),%eax
 7e9:	c1 e0 03             	shl    $0x3,%eax
 7ec:	89 04 24             	mov    %eax,(%esp)
 7ef:	e8 05 fc ff ff       	call   3f9 <sbrk>
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7fb:	75 07                	jne    804 <morecore+0x34>
    return 0;
 7fd:	b8 00 00 00 00       	mov    $0x0,%eax
 802:	eb 22                	jmp    826 <morecore+0x56>
  hp = (Header*)p;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 80a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80d:	8b 55 08             	mov    0x8(%ebp),%edx
 810:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 813:	8b 45 f0             	mov    -0x10(%ebp),%eax
 816:	83 c0 08             	add    $0x8,%eax
 819:	89 04 24             	mov    %eax,(%esp)
 81c:	e8 ce fe ff ff       	call   6ef <free>
  return freep;
 821:	a1 ec 0b 00 00       	mov    0xbec,%eax
}
 826:	c9                   	leave  
 827:	c3                   	ret    

00000828 <malloc>:

void*
malloc(uint nbytes)
{
 828:	55                   	push   %ebp
 829:	89 e5                	mov    %esp,%ebp
 82b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	8b 45 08             	mov    0x8(%ebp),%eax
 831:	83 c0 07             	add    $0x7,%eax
 834:	c1 e8 03             	shr    $0x3,%eax
 837:	40                   	inc    %eax
 838:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 83b:	a1 ec 0b 00 00       	mov    0xbec,%eax
 840:	89 45 f0             	mov    %eax,-0x10(%ebp)
 843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 847:	75 23                	jne    86c <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 849:	c7 45 f0 e4 0b 00 00 	movl   $0xbe4,-0x10(%ebp)
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	a3 ec 0b 00 00       	mov    %eax,0xbec
 858:	a1 ec 0b 00 00       	mov    0xbec,%eax
 85d:	a3 e4 0b 00 00       	mov    %eax,0xbe4
    base.s.size = 0;
 862:	c7 05 e8 0b 00 00 00 	movl   $0x0,0xbe8
 869:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87d:	72 4d                	jb     8cc <malloc+0xa4>
      if(p->s.size == nunits)
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 888:	75 0c                	jne    896 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	89 10                	mov    %edx,(%eax)
 894:	eb 26                	jmp    8bc <malloc+0x94>
      else {
        p->s.size -= nunits;
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	89 c2                	mov    %eax,%edx
 89e:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 40 04             	mov    0x4(%eax),%eax
 8ad:	c1 e0 03             	shl    $0x3,%eax
 8b0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	a3 ec 0b 00 00       	mov    %eax,0xbec
      return (void*)(p + 1);
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	83 c0 08             	add    $0x8,%eax
 8ca:	eb 38                	jmp    904 <malloc+0xdc>
    }
    if(p == freep)
 8cc:	a1 ec 0b 00 00       	mov    0xbec,%eax
 8d1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d4:	75 1b                	jne    8f1 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d9:	89 04 24             	mov    %eax,(%esp)
 8dc:	e8 ef fe ff ff       	call   7d0 <morecore>
 8e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e8:	75 07                	jne    8f1 <malloc+0xc9>
        return 0;
 8ea:	b8 00 00 00 00       	mov    $0x0,%eax
 8ef:	eb 13                	jmp    904 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8ff:	e9 70 ff ff ff       	jmp    874 <malloc+0x4c>
}
 904:	c9                   	leave  
 905:	c3                   	ret    
