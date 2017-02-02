
_cp:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  char buf[512];
  int fd, dfd, r, w;
  char *src;
  char *dest;

  if(argc != 3){
   c:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
  10:	74 19                	je     2b <main+0x2b>
    printf(2, "Usage: cp src dest\n");
  12:	c7 44 24 04 48 09 00 	movl   $0x948,0x4(%esp)
  19:	00 
  1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  21:	e8 5c 05 00 00       	call   582 <printf>
    exit();
  26:	e8 cf 03 00 00       	call   3fa <exit>
  }

  src = argv[1];
  2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  2e:	8b 40 04             	mov    0x4(%eax),%eax
  31:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  dest = argv[2];
  38:	8b 45 0c             	mov    0xc(%ebp),%eax
  3b:	8b 40 08             	mov    0x8(%eax),%eax
  3e:	89 84 24 24 02 00 00 	mov    %eax,0x224(%esp)

  if ((fd = open(src, O_RDONLY)) < 0) {
  45:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  4c:	00 
  4d:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 de 03 00 00       	call   43a <open>
  5c:	89 84 24 20 02 00 00 	mov    %eax,0x220(%esp)
  63:	83 bc 24 20 02 00 00 	cmpl   $0x0,0x220(%esp)
  6a:	00 
  6b:	79 24                	jns    91 <main+0x91>
    printf(2, "cp: cannot open source %s\n", src);
  6d:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
  74:	89 44 24 08          	mov    %eax,0x8(%esp)
  78:	c7 44 24 04 5c 09 00 	movl   $0x95c,0x4(%esp)
  7f:	00 
  80:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  87:	e8 f6 04 00 00       	call   582 <printf>
    exit();
  8c:	e8 69 03 00 00       	call   3fa <exit>
  }
  if ((dfd = open(dest, O_CREATE|O_WRONLY)) < 0) {
  91:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  98:	00 
  99:	8b 84 24 24 02 00 00 	mov    0x224(%esp),%eax
  a0:	89 04 24             	mov    %eax,(%esp)
  a3:	e8 92 03 00 00       	call   43a <open>
  a8:	89 84 24 1c 02 00 00 	mov    %eax,0x21c(%esp)
  af:	83 bc 24 1c 02 00 00 	cmpl   $0x0,0x21c(%esp)
  b6:	00 
  b7:	79 67                	jns    120 <main+0x120>
    printf(2, "cp: cannot open destination %s\n", dest);
  b9:	8b 84 24 24 02 00 00 	mov    0x224(%esp),%eax
  c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  c4:	c7 44 24 04 78 09 00 	movl   $0x978,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  d3:	e8 aa 04 00 00       	call   582 <printf>
    exit();
  d8:	e8 1d 03 00 00       	call   3fa <exit>
  }
  
  while ((r = read(fd, buf, sizeof(buf))) > 0) {
    w = write(dfd, buf, r);
  dd:	8b 84 24 18 02 00 00 	mov    0x218(%esp),%eax
  e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  e8:	8d 44 24 18          	lea    0x18(%esp),%eax
  ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  f0:	8b 84 24 1c 02 00 00 	mov    0x21c(%esp),%eax
  f7:	89 04 24             	mov    %eax,(%esp)
  fa:	e8 1b 03 00 00       	call   41a <write>
  ff:	89 84 24 2c 02 00 00 	mov    %eax,0x22c(%esp)
    if (w != r || w < 0) 
 106:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
 10d:	3b 84 24 18 02 00 00 	cmp    0x218(%esp),%eax
 114:	75 3a                	jne    150 <main+0x150>
 116:	83 bc 24 2c 02 00 00 	cmpl   $0x0,0x22c(%esp)
 11d:	00 
 11e:	78 30                	js     150 <main+0x150>
  while ((r = read(fd, buf, sizeof(buf))) > 0) {
 120:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 127:	00 
 128:	8d 44 24 18          	lea    0x18(%esp),%eax
 12c:	89 44 24 04          	mov    %eax,0x4(%esp)
 130:	8b 84 24 20 02 00 00 	mov    0x220(%esp),%eax
 137:	89 04 24             	mov    %eax,(%esp)
 13a:	e8 d3 02 00 00       	call   412 <read>
 13f:	89 84 24 18 02 00 00 	mov    %eax,0x218(%esp)
 146:	83 bc 24 18 02 00 00 	cmpl   $0x0,0x218(%esp)
 14d:	00 
 14e:	7f 8d                	jg     dd <main+0xdd>
      break;
  }
  if (r < 0 || w < 0)
 150:	83 bc 24 18 02 00 00 	cmpl   $0x0,0x218(%esp)
 157:	00 
 158:	78 0a                	js     164 <main+0x164>
 15a:	83 bc 24 2c 02 00 00 	cmpl   $0x0,0x22c(%esp)
 161:	00 
 162:	79 2a                	jns    18e <main+0x18e>
    printf(2, "cp: error copying %s to %s\n", src, dest);
 164:	8b 84 24 24 02 00 00 	mov    0x224(%esp),%eax
 16b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 16f:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 176:	89 44 24 08          	mov    %eax,0x8(%esp)
 17a:	c7 44 24 04 98 09 00 	movl   $0x998,0x4(%esp)
 181:	00 
 182:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 189:	e8 f4 03 00 00       	call   582 <printf>

  close(fd);
 18e:	8b 84 24 20 02 00 00 	mov    0x220(%esp),%eax
 195:	89 04 24             	mov    %eax,(%esp)
 198:	e8 85 02 00 00       	call   422 <close>
  close(dfd);
 19d:	8b 84 24 1c 02 00 00 	mov    0x21c(%esp),%eax
 1a4:	89 04 24             	mov    %eax,(%esp)
 1a7:	e8 76 02 00 00       	call   422 <close>

  exit();
 1ac:	e8 49 02 00 00       	call   3fa <exit>

000001b1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	57                   	push   %edi
 1b5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b9:	8b 55 10             	mov    0x10(%ebp),%edx
 1bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bf:	89 cb                	mov    %ecx,%ebx
 1c1:	89 df                	mov    %ebx,%edi
 1c3:	89 d1                	mov    %edx,%ecx
 1c5:	fc                   	cld    
 1c6:	f3 aa                	rep stos %al,%es:(%edi)
 1c8:	89 ca                	mov    %ecx,%edx
 1ca:	89 fb                	mov    %edi,%ebx
 1cc:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1cf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d2:	5b                   	pop    %ebx
 1d3:	5f                   	pop    %edi
 1d4:	5d                   	pop    %ebp
 1d5:	c3                   	ret    

000001d6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e2:	90                   	nop
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	8a 10                	mov    (%eax),%dl
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	88 10                	mov    %dl,(%eax)
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	8a 00                	mov    (%eax),%al
 1f2:	84 c0                	test   %al,%al
 1f4:	0f 95 c0             	setne  %al
 1f7:	ff 45 08             	incl   0x8(%ebp)
 1fa:	ff 45 0c             	incl   0xc(%ebp)
 1fd:	84 c0                	test   %al,%al
 1ff:	75 e2                	jne    1e3 <strcpy+0xd>
    ;
  return os;
 201:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 209:	eb 06                	jmp    211 <strcmp+0xb>
    p++, q++;
 20b:	ff 45 08             	incl   0x8(%ebp)
 20e:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	8a 00                	mov    (%eax),%al
 216:	84 c0                	test   %al,%al
 218:	74 0e                	je     228 <strcmp+0x22>
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	8a 10                	mov    (%eax),%dl
 21f:	8b 45 0c             	mov    0xc(%ebp),%eax
 222:	8a 00                	mov    (%eax),%al
 224:	38 c2                	cmp    %al,%dl
 226:	74 e3                	je     20b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	8a 00                	mov    (%eax),%al
 22d:	0f b6 d0             	movzbl %al,%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	8a 00                	mov    (%eax),%al
 235:	0f b6 c0             	movzbl %al,%eax
 238:	89 d1                	mov    %edx,%ecx
 23a:	29 c1                	sub    %eax,%ecx
 23c:	89 c8                	mov    %ecx,%eax
}
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <strlen>:

uint
strlen(char *s)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 246:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 24d:	eb 03                	jmp    252 <strlen+0x12>
 24f:	ff 45 fc             	incl   -0x4(%ebp)
 252:	8b 55 fc             	mov    -0x4(%ebp),%edx
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	01 d0                	add    %edx,%eax
 25a:	8a 00                	mov    (%eax),%al
 25c:	84 c0                	test   %al,%al
 25e:	75 ef                	jne    24f <strlen+0xf>
    ;
  return n;
 260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <memset>:

void*
memset(void *dst, int c, uint n)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 26b:	8b 45 10             	mov    0x10(%ebp),%eax
 26e:	89 44 24 08          	mov    %eax,0x8(%esp)
 272:	8b 45 0c             	mov    0xc(%ebp),%eax
 275:	89 44 24 04          	mov    %eax,0x4(%esp)
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	89 04 24             	mov    %eax,(%esp)
 27f:	e8 2d ff ff ff       	call   1b1 <stosb>
  return dst;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <strchr>:

char*
strchr(const char *s, char c)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 04             	sub    $0x4,%esp
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 295:	eb 12                	jmp    2a9 <strchr+0x20>
    if(*s == c)
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8a 00                	mov    (%eax),%al
 29c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 29f:	75 05                	jne    2a6 <strchr+0x1d>
      return (char*)s;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	eb 11                	jmp    2b7 <strchr+0x2e>
  for(; *s; s++)
 2a6:	ff 45 08             	incl   0x8(%ebp)
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	8a 00                	mov    (%eax),%al
 2ae:	84 c0                	test   %al,%al
 2b0:	75 e5                	jne    297 <strchr+0xe>
  return 0;
 2b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    

000002b9 <gets>:

char*
gets(char *buf, int max)
{
 2b9:	55                   	push   %ebp
 2ba:	89 e5                	mov    %esp,%ebp
 2bc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2c6:	eb 42                	jmp    30a <gets+0x51>
    cc = read(0, &c, 1);
 2c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2cf:	00 
 2d0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2de:	e8 2f 01 00 00       	call   412 <read>
 2e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ea:	7e 29                	jle    315 <gets+0x5c>
      break;
    buf[i++] = c;
 2ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	01 c2                	add    %eax,%edx
 2f4:	8a 45 ef             	mov    -0x11(%ebp),%al
 2f7:	88 02                	mov    %al,(%edx)
 2f9:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 2fc:	8a 45 ef             	mov    -0x11(%ebp),%al
 2ff:	3c 0a                	cmp    $0xa,%al
 301:	74 13                	je     316 <gets+0x5d>
 303:	8a 45 ef             	mov    -0x11(%ebp),%al
 306:	3c 0d                	cmp    $0xd,%al
 308:	74 0c                	je     316 <gets+0x5d>
  for(i=0; i+1 < max; ){
 30a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30d:	40                   	inc    %eax
 30e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 311:	7c b5                	jl     2c8 <gets+0xf>
 313:	eb 01                	jmp    316 <gets+0x5d>
      break;
 315:	90                   	nop
      break;
  }
  buf[i] = '\0';
 316:	8b 55 f4             	mov    -0xc(%ebp),%edx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	01 d0                	add    %edx,%eax
 31e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 321:	8b 45 08             	mov    0x8(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <stat>:

int
stat(char *n, struct stat *st)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 333:	00 
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	89 04 24             	mov    %eax,(%esp)
 33a:	e8 fb 00 00 00       	call   43a <open>
 33f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 346:	79 07                	jns    34f <stat+0x29>
    return -1;
 348:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 34d:	eb 23                	jmp    372 <stat+0x4c>
  r = fstat(fd, st);
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	89 44 24 04          	mov    %eax,0x4(%esp)
 356:	8b 45 f4             	mov    -0xc(%ebp),%eax
 359:	89 04 24             	mov    %eax,(%esp)
 35c:	e8 f1 00 00 00       	call   452 <fstat>
 361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 364:	8b 45 f4             	mov    -0xc(%ebp),%eax
 367:	89 04 24             	mov    %eax,(%esp)
 36a:	e8 b3 00 00 00       	call   422 <close>
  return r;
 36f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <atoi>:

int
atoi(const char *s)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 37a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 381:	eb 21                	jmp    3a4 <atoi+0x30>
    n = n*10 + *s++ - '0';
 383:	8b 55 fc             	mov    -0x4(%ebp),%edx
 386:	89 d0                	mov    %edx,%eax
 388:	c1 e0 02             	shl    $0x2,%eax
 38b:	01 d0                	add    %edx,%eax
 38d:	d1 e0                	shl    %eax
 38f:	89 c2                	mov    %eax,%edx
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	8a 00                	mov    (%eax),%al
 396:	0f be c0             	movsbl %al,%eax
 399:	01 d0                	add    %edx,%eax
 39b:	83 e8 30             	sub    $0x30,%eax
 39e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3a1:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	8a 00                	mov    (%eax),%al
 3a9:	3c 2f                	cmp    $0x2f,%al
 3ab:	7e 09                	jle    3b6 <atoi+0x42>
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	8a 00                	mov    (%eax),%al
 3b2:	3c 39                	cmp    $0x39,%al
 3b4:	7e cd                	jle    383 <atoi+0xf>
  return n;
 3b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b9:	c9                   	leave  
 3ba:	c3                   	ret    

000003bb <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3bb:	55                   	push   %ebp
 3bc:	89 e5                	mov    %esp,%ebp
 3be:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3cd:	eb 10                	jmp    3df <memmove+0x24>
    *dst++ = *src++;
 3cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3d2:	8a 10                	mov    (%eax),%dl
 3d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d7:	88 10                	mov    %dl,(%eax)
 3d9:	ff 45 fc             	incl   -0x4(%ebp)
 3dc:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 3df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3e3:	0f 9f c0             	setg   %al
 3e6:	ff 4d 10             	decl   0x10(%ebp)
 3e9:	84 c0                	test   %al,%al
 3eb:	75 e2                	jne    3cf <memmove+0x14>
  return vdst;
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <fork>:
 3f2:	b8 01 00 00 00       	mov    $0x1,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <exit>:
 3fa:	b8 02 00 00 00       	mov    $0x2,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <wait>:
 402:	b8 03 00 00 00       	mov    $0x3,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <pipe>:
 40a:	b8 04 00 00 00       	mov    $0x4,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <read>:
 412:	b8 05 00 00 00       	mov    $0x5,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <write>:
 41a:	b8 10 00 00 00       	mov    $0x10,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <close>:
 422:	b8 15 00 00 00       	mov    $0x15,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <kill>:
 42a:	b8 06 00 00 00       	mov    $0x6,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <exec>:
 432:	b8 07 00 00 00       	mov    $0x7,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <open>:
 43a:	b8 0f 00 00 00       	mov    $0xf,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <mknod>:
 442:	b8 11 00 00 00       	mov    $0x11,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <unlink>:
 44a:	b8 12 00 00 00       	mov    $0x12,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <fstat>:
 452:	b8 08 00 00 00       	mov    $0x8,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <link>:
 45a:	b8 13 00 00 00       	mov    $0x13,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <mkdir>:
 462:	b8 14 00 00 00       	mov    $0x14,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <chdir>:
 46a:	b8 09 00 00 00       	mov    $0x9,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <dup>:
 472:	b8 0a 00 00 00       	mov    $0xa,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <getpid>:
 47a:	b8 0b 00 00 00       	mov    $0xb,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <sbrk>:
 482:	b8 0c 00 00 00       	mov    $0xc,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <sleep>:
 48a:	b8 0d 00 00 00       	mov    $0xd,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <uptime>:
 492:	b8 0e 00 00 00       	mov    $0xe,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <lseek>:
 49a:	b8 16 00 00 00       	mov    $0x16,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <isatty>:
 4a2:	b8 17 00 00 00       	mov    $0x17,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4aa:	55                   	push   %ebp
 4ab:	89 e5                	mov    %esp,%ebp
 4ad:	83 ec 28             	sub    $0x28,%esp
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4bd:	00 
 4be:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
 4c8:	89 04 24             	mov    %eax,(%esp)
 4cb:	e8 4a ff ff ff       	call   41a <write>
}
 4d0:	c9                   	leave  
 4d1:	c3                   	ret    

000004d2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e3:	74 17                	je     4fc <printint+0x2a>
 4e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e9:	79 11                	jns    4fc <printint+0x2a>
    neg = 1;
 4eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f5:	f7 d8                	neg    %eax
 4f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fa:	eb 06                	jmp    502 <printint+0x30>
  } else {
    x = xx;
 4fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 509:	8b 4d 10             	mov    0x10(%ebp),%ecx
 50c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50f:	ba 00 00 00 00       	mov    $0x0,%edx
 514:	f7 f1                	div    %ecx
 516:	89 d0                	mov    %edx,%eax
 518:	8a 80 f8 0b 00 00    	mov    0xbf8(%eax),%al
 51e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 521:	8b 55 f4             	mov    -0xc(%ebp),%edx
 524:	01 ca                	add    %ecx,%edx
 526:	88 02                	mov    %al,(%edx)
 528:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 52b:	8b 55 10             	mov    0x10(%ebp),%edx
 52e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 531:	8b 45 ec             	mov    -0x14(%ebp),%eax
 534:	ba 00 00 00 00       	mov    $0x0,%edx
 539:	f7 75 d4             	divl   -0x2c(%ebp)
 53c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 543:	75 c4                	jne    509 <printint+0x37>
  if(neg)
 545:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 549:	74 2c                	je     577 <printint+0xa5>
    buf[i++] = '-';
 54b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	01 d0                	add    %edx,%eax
 553:	c6 00 2d             	movb   $0x2d,(%eax)
 556:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 559:	eb 1c                	jmp    577 <printint+0xa5>
    putc(fd, buf[i]);
 55b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	01 d0                	add    %edx,%eax
 563:	8a 00                	mov    (%eax),%al
 565:	0f be c0             	movsbl %al,%eax
 568:	89 44 24 04          	mov    %eax,0x4(%esp)
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	89 04 24             	mov    %eax,(%esp)
 572:	e8 33 ff ff ff       	call   4aa <putc>
  while(--i >= 0)
 577:	ff 4d f4             	decl   -0xc(%ebp)
 57a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57e:	79 db                	jns    55b <printint+0x89>
}
 580:	c9                   	leave  
 581:	c3                   	ret    

00000582 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 588:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58f:	8d 45 0c             	lea    0xc(%ebp),%eax
 592:	83 c0 04             	add    $0x4,%eax
 595:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59f:	e9 78 01 00 00       	jmp    71c <printf+0x19a>
    c = fmt[i] & 0xff;
 5a4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	8a 00                	mov    (%eax),%al
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	25 ff 00 00 00       	and    $0xff,%eax
 5b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 2c                	jne    5eb <printf+0x69>
      if(c == '%'){
 5bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c3:	75 0c                	jne    5d1 <printf+0x4f>
        state = '%';
 5c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cc:	e9 48 01 00 00       	jmp    719 <printf+0x197>
      } else {
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 c4 fe ff ff       	call   4aa <putc>
 5e6:	e9 2e 01 00 00       	jmp    719 <printf+0x197>
      }
    } else if(state == '%'){
 5eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ef:	0f 85 24 01 00 00    	jne    719 <printf+0x197>
      if(c == 'd'){
 5f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f9:	75 2d                	jne    628 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 607:	00 
 608:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 60f:	00 
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 b3 fe ff ff       	call   4d2 <printint>
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 623:	e9 ea 00 00 00       	jmp    712 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 628:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62c:	74 06                	je     634 <printf+0xb2>
 62e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 632:	75 2d                	jne    661 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 640:	00 
 641:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 648:	00 
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 7a fe ff ff       	call   4d2 <printint>
        ap++;
 658:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65c:	e9 b1 00 00 00       	jmp    712 <printf+0x190>
      } else if(c == 's'){
 661:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 665:	75 43                	jne    6aa <printf+0x128>
        s = (char*)*ap;
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 677:	75 25                	jne    69e <printf+0x11c>
          s = "(null)";
 679:	c7 45 f4 b4 09 00 00 	movl   $0x9b4,-0xc(%ebp)
        while(*s != 0){
 680:	eb 1c                	jmp    69e <printf+0x11c>
          putc(fd, *s);
 682:	8b 45 f4             	mov    -0xc(%ebp),%eax
 685:	8a 00                	mov    (%eax),%al
 687:	0f be c0             	movsbl %al,%eax
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	89 04 24             	mov    %eax,(%esp)
 694:	e8 11 fe ff ff       	call   4aa <putc>
          s++;
 699:	ff 45 f4             	incl   -0xc(%ebp)
 69c:	eb 01                	jmp    69f <printf+0x11d>
        while(*s != 0){
 69e:	90                   	nop
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	8a 00                	mov    (%eax),%al
 6a4:	84 c0                	test   %al,%al
 6a6:	75 da                	jne    682 <printf+0x100>
 6a8:	eb 68                	jmp    712 <printf+0x190>
        }
      } else if(c == 'c'){
 6aa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6ae:	75 1d                	jne    6cd <printf+0x14b>
        putc(fd, *ap);
 6b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
 6bf:	89 04 24             	mov    %eax,(%esp)
 6c2:	e8 e3 fd ff ff       	call   4aa <putc>
        ap++;
 6c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cb:	eb 45                	jmp    712 <printf+0x190>
      } else if(c == '%'){
 6cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d1:	75 17                	jne    6ea <printf+0x168>
        putc(fd, c);
 6d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d6:	0f be c0             	movsbl %al,%eax
 6d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	89 04 24             	mov    %eax,(%esp)
 6e3:	e8 c2 fd ff ff       	call   4aa <putc>
 6e8:	eb 28                	jmp    712 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ea:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6f1:	00 
 6f2:	8b 45 08             	mov    0x8(%ebp),%eax
 6f5:	89 04 24             	mov    %eax,(%esp)
 6f8:	e8 ad fd ff ff       	call   4aa <putc>
        putc(fd, c);
 6fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 700:	0f be c0             	movsbl %al,%eax
 703:	89 44 24 04          	mov    %eax,0x4(%esp)
 707:	8b 45 08             	mov    0x8(%ebp),%eax
 70a:	89 04 24             	mov    %eax,(%esp)
 70d:	e8 98 fd ff ff       	call   4aa <putc>
      }
      state = 0;
 712:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 719:	ff 45 f0             	incl   -0x10(%ebp)
 71c:	8b 55 0c             	mov    0xc(%ebp),%edx
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	01 d0                	add    %edx,%eax
 724:	8a 00                	mov    (%eax),%al
 726:	84 c0                	test   %al,%al
 728:	0f 85 76 fe ff ff    	jne    5a4 <printf+0x22>
    }
  }
}
 72e:	c9                   	leave  
 72f:	c3                   	ret    

00000730 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	83 e8 08             	sub    $0x8,%eax
 73c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73f:	a1 14 0c 00 00       	mov    0xc14,%eax
 744:	89 45 fc             	mov    %eax,-0x4(%ebp)
 747:	eb 24                	jmp    76d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 751:	77 12                	ja     765 <free+0x35>
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 759:	77 24                	ja     77f <free+0x4f>
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 763:	77 1a                	ja     77f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 773:	76 d4                	jbe    749 <free+0x19>
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 77d:	76 ca                	jbe    749 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	01 c2                	add    %eax,%edx
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	39 c2                	cmp    %eax,%edx
 798:	75 24                	jne    7be <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	8b 00                	mov    (%eax),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	01 c2                	add    %eax,%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	8b 00                	mov    (%eax),%eax
 7b5:	8b 10                	mov    (%eax),%edx
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	89 10                	mov    %edx,(%eax)
 7bc:	eb 0a                	jmp    7c8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 10                	mov    (%eax),%edx
 7c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	01 d0                	add    %edx,%eax
 7da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7dd:	75 20                	jne    7ff <free+0xcf>
    p->s.size += bp->s.size;
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 50 04             	mov    0x4(%eax),%edx
 7e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	01 c2                	add    %eax,%edx
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	89 10                	mov    %edx,(%eax)
 7fd:	eb 08                	jmp    807 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 55 f8             	mov    -0x8(%ebp),%edx
 805:	89 10                	mov    %edx,(%eax)
  freep = p;
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	a3 14 0c 00 00       	mov    %eax,0xc14
}
 80f:	c9                   	leave  
 810:	c3                   	ret    

00000811 <morecore>:

static Header*
morecore(uint nu)
{
 811:	55                   	push   %ebp
 812:	89 e5                	mov    %esp,%ebp
 814:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 817:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 81e:	77 07                	ja     827 <morecore+0x16>
    nu = 4096;
 820:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	c1 e0 03             	shl    $0x3,%eax
 82d:	89 04 24             	mov    %eax,(%esp)
 830:	e8 4d fc ff ff       	call   482 <sbrk>
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 838:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83c:	75 07                	jne    845 <morecore+0x34>
    return 0;
 83e:	b8 00 00 00 00       	mov    $0x0,%eax
 843:	eb 22                	jmp    867 <morecore+0x56>
  hp = (Header*)p;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	8b 55 08             	mov    0x8(%ebp),%edx
 851:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	83 c0 08             	add    $0x8,%eax
 85a:	89 04 24             	mov    %eax,(%esp)
 85d:	e8 ce fe ff ff       	call   730 <free>
  return freep;
 862:	a1 14 0c 00 00       	mov    0xc14,%eax
}
 867:	c9                   	leave  
 868:	c3                   	ret    

00000869 <malloc>:

void*
malloc(uint nbytes)
{
 869:	55                   	push   %ebp
 86a:	89 e5                	mov    %esp,%ebp
 86c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86f:	8b 45 08             	mov    0x8(%ebp),%eax
 872:	83 c0 07             	add    $0x7,%eax
 875:	c1 e8 03             	shr    $0x3,%eax
 878:	40                   	inc    %eax
 879:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 87c:	a1 14 0c 00 00       	mov    0xc14,%eax
 881:	89 45 f0             	mov    %eax,-0x10(%ebp)
 884:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 888:	75 23                	jne    8ad <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 88a:	c7 45 f0 0c 0c 00 00 	movl   $0xc0c,-0x10(%ebp)
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	a3 14 0c 00 00       	mov    %eax,0xc14
 899:	a1 14 0c 00 00       	mov    0xc14,%eax
 89e:	a3 0c 0c 00 00       	mov    %eax,0xc0c
    base.s.size = 0;
 8a3:	c7 05 10 0c 00 00 00 	movl   $0x0,0xc10
 8aa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b0:	8b 00                	mov    (%eax),%eax
 8b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 40 04             	mov    0x4(%eax),%eax
 8bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8be:	72 4d                	jb     90d <malloc+0xa4>
      if(p->s.size == nunits)
 8c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c3:	8b 40 04             	mov    0x4(%eax),%eax
 8c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c9:	75 0c                	jne    8d7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ce:	8b 10                	mov    (%eax),%edx
 8d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d3:	89 10                	mov    %edx,(%eax)
 8d5:	eb 26                	jmp    8fd <malloc+0x94>
      else {
        p->s.size -= nunits;
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	8b 40 04             	mov    0x4(%eax),%eax
 8dd:	89 c2                	mov    %eax,%edx
 8df:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	8b 40 04             	mov    0x4(%eax),%eax
 8ee:	c1 e0 03             	shl    $0x3,%eax
 8f1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8fa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 900:	a3 14 0c 00 00       	mov    %eax,0xc14
      return (void*)(p + 1);
 905:	8b 45 f4             	mov    -0xc(%ebp),%eax
 908:	83 c0 08             	add    $0x8,%eax
 90b:	eb 38                	jmp    945 <malloc+0xdc>
    }
    if(p == freep)
 90d:	a1 14 0c 00 00       	mov    0xc14,%eax
 912:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 915:	75 1b                	jne    932 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 917:	8b 45 ec             	mov    -0x14(%ebp),%eax
 91a:	89 04 24             	mov    %eax,(%esp)
 91d:	e8 ef fe ff ff       	call   811 <morecore>
 922:	89 45 f4             	mov    %eax,-0xc(%ebp)
 925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 929:	75 07                	jne    932 <malloc+0xc9>
        return 0;
 92b:	b8 00 00 00 00       	mov    $0x0,%eax
 930:	eb 13                	jmp    945 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	89 45 f0             	mov    %eax,-0x10(%ebp)
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 940:	e9 70 ff ff ff       	jmp    8b5 <malloc+0x4c>
}
 945:	c9                   	leave  
 946:	c3                   	ret    
