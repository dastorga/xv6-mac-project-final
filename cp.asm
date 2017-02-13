
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
  12:	c7 44 24 04 90 09 00 	movl   $0x990,0x4(%esp)
  19:	00 
  1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  21:	e8 a4 05 00 00       	call   5ca <printf>
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
  78:	c7 44 24 04 a4 09 00 	movl   $0x9a4,0x4(%esp)
  7f:	00 
  80:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  87:	e8 3e 05 00 00       	call   5ca <printf>
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
  c4:	c7 44 24 04 c0 09 00 	movl   $0x9c0,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  d3:	e8 f2 04 00 00       	call   5ca <printf>
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
 17a:	c7 44 24 04 e0 09 00 	movl   $0x9e0,0x4(%esp)
 181:	00 
 182:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 189:	e8 3c 04 00 00       	call   5ca <printf>

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

000004aa <procstat>:
 4aa:	b8 18 00 00 00       	mov    $0x18,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <set_priority>:
 4b2:	b8 19 00 00 00       	mov    $0x19,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <semget>:
 4ba:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <semfree>:
 4c2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <semdown>:
 4ca:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <semup>:
 4d2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <shm_create>:
 4da:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <shm_close>:
 4e2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <shm_get>:
 4ea:	b8 20 00 00 00       	mov    $0x20,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f2:	55                   	push   %ebp
 4f3:	89 e5                	mov    %esp,%ebp
 4f5:	83 ec 28             	sub    $0x28,%esp
 4f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4fe:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 505:	00 
 506:	8d 45 f4             	lea    -0xc(%ebp),%eax
 509:	89 44 24 04          	mov    %eax,0x4(%esp)
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	89 04 24             	mov    %eax,(%esp)
 513:	e8 02 ff ff ff       	call   41a <write>
}
 518:	c9                   	leave  
 519:	c3                   	ret    

0000051a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51a:	55                   	push   %ebp
 51b:	89 e5                	mov    %esp,%ebp
 51d:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 520:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 527:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 52b:	74 17                	je     544 <printint+0x2a>
 52d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 531:	79 11                	jns    544 <printint+0x2a>
    neg = 1;
 533:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 53a:	8b 45 0c             	mov    0xc(%ebp),%eax
 53d:	f7 d8                	neg    %eax
 53f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 542:	eb 06                	jmp    54a <printint+0x30>
  } else {
    x = xx;
 544:	8b 45 0c             	mov    0xc(%ebp),%eax
 547:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 54a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 551:	8b 4d 10             	mov    0x10(%ebp),%ecx
 554:	8b 45 ec             	mov    -0x14(%ebp),%eax
 557:	ba 00 00 00 00       	mov    $0x0,%edx
 55c:	f7 f1                	div    %ecx
 55e:	89 d0                	mov    %edx,%eax
 560:	8a 80 40 0c 00 00    	mov    0xc40(%eax),%al
 566:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 569:	8b 55 f4             	mov    -0xc(%ebp),%edx
 56c:	01 ca                	add    %ecx,%edx
 56e:	88 02                	mov    %al,(%edx)
 570:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 573:	8b 55 10             	mov    0x10(%ebp),%edx
 576:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 579:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57c:	ba 00 00 00 00       	mov    $0x0,%edx
 581:	f7 75 d4             	divl   -0x2c(%ebp)
 584:	89 45 ec             	mov    %eax,-0x14(%ebp)
 587:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58b:	75 c4                	jne    551 <printint+0x37>
  if(neg)
 58d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 591:	74 2c                	je     5bf <printint+0xa5>
    buf[i++] = '-';
 593:	8d 55 dc             	lea    -0x24(%ebp),%edx
 596:	8b 45 f4             	mov    -0xc(%ebp),%eax
 599:	01 d0                	add    %edx,%eax
 59b:	c6 00 2d             	movb   $0x2d,(%eax)
 59e:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 5a1:	eb 1c                	jmp    5bf <printint+0xa5>
    putc(fd, buf[i]);
 5a3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a9:	01 d0                	add    %edx,%eax
 5ab:	8a 00                	mov    (%eax),%al
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	89 04 24             	mov    %eax,(%esp)
 5ba:	e8 33 ff ff ff       	call   4f2 <putc>
  while(--i >= 0)
 5bf:	ff 4d f4             	decl   -0xc(%ebp)
 5c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c6:	79 db                	jns    5a3 <printint+0x89>
}
 5c8:	c9                   	leave  
 5c9:	c3                   	ret    

000005ca <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d7:	8d 45 0c             	lea    0xc(%ebp),%eax
 5da:	83 c0 04             	add    $0x4,%eax
 5dd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e7:	e9 78 01 00 00       	jmp    764 <printf+0x19a>
    c = fmt[i] & 0xff;
 5ec:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f2:	01 d0                	add    %edx,%eax
 5f4:	8a 00                	mov    (%eax),%al
 5f6:	0f be c0             	movsbl %al,%eax
 5f9:	25 ff 00 00 00       	and    $0xff,%eax
 5fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 605:	75 2c                	jne    633 <printf+0x69>
      if(c == '%'){
 607:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60b:	75 0c                	jne    619 <printf+0x4f>
        state = '%';
 60d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 614:	e9 48 01 00 00       	jmp    761 <printf+0x197>
      } else {
        putc(fd, c);
 619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61c:	0f be c0             	movsbl %al,%eax
 61f:	89 44 24 04          	mov    %eax,0x4(%esp)
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	89 04 24             	mov    %eax,(%esp)
 629:	e8 c4 fe ff ff       	call   4f2 <putc>
 62e:	e9 2e 01 00 00       	jmp    761 <printf+0x197>
      }
    } else if(state == '%'){
 633:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 637:	0f 85 24 01 00 00    	jne    761 <printf+0x197>
      if(c == 'd'){
 63d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 641:	75 2d                	jne    670 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 643:	8b 45 e8             	mov    -0x18(%ebp),%eax
 646:	8b 00                	mov    (%eax),%eax
 648:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 64f:	00 
 650:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 657:	00 
 658:	89 44 24 04          	mov    %eax,0x4(%esp)
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
 65f:	89 04 24             	mov    %eax,(%esp)
 662:	e8 b3 fe ff ff       	call   51a <printint>
        ap++;
 667:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66b:	e9 ea 00 00 00       	jmp    75a <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 670:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 674:	74 06                	je     67c <printf+0xb2>
 676:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 67a:	75 2d                	jne    6a9 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 67c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 688:	00 
 689:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 690:	00 
 691:	89 44 24 04          	mov    %eax,0x4(%esp)
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	89 04 24             	mov    %eax,(%esp)
 69b:	e8 7a fe ff ff       	call   51a <printint>
        ap++;
 6a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a4:	e9 b1 00 00 00       	jmp    75a <printf+0x190>
      } else if(c == 's'){
 6a9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ad:	75 43                	jne    6f2 <printf+0x128>
        s = (char*)*ap;
 6af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6bf:	75 25                	jne    6e6 <printf+0x11c>
          s = "(null)";
 6c1:	c7 45 f4 fc 09 00 00 	movl   $0x9fc,-0xc(%ebp)
        while(*s != 0){
 6c8:	eb 1c                	jmp    6e6 <printf+0x11c>
          putc(fd, *s);
 6ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cd:	8a 00                	mov    (%eax),%al
 6cf:	0f be c0             	movsbl %al,%eax
 6d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d6:	8b 45 08             	mov    0x8(%ebp),%eax
 6d9:	89 04 24             	mov    %eax,(%esp)
 6dc:	e8 11 fe ff ff       	call   4f2 <putc>
          s++;
 6e1:	ff 45 f4             	incl   -0xc(%ebp)
 6e4:	eb 01                	jmp    6e7 <printf+0x11d>
        while(*s != 0){
 6e6:	90                   	nop
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	8a 00                	mov    (%eax),%al
 6ec:	84 c0                	test   %al,%al
 6ee:	75 da                	jne    6ca <printf+0x100>
 6f0:	eb 68                	jmp    75a <printf+0x190>
        }
      } else if(c == 'c'){
 6f2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f6:	75 1d                	jne    715 <printf+0x14b>
        putc(fd, *ap);
 6f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fb:	8b 00                	mov    (%eax),%eax
 6fd:	0f be c0             	movsbl %al,%eax
 700:	89 44 24 04          	mov    %eax,0x4(%esp)
 704:	8b 45 08             	mov    0x8(%ebp),%eax
 707:	89 04 24             	mov    %eax,(%esp)
 70a:	e8 e3 fd ff ff       	call   4f2 <putc>
        ap++;
 70f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 713:	eb 45                	jmp    75a <printf+0x190>
      } else if(c == '%'){
 715:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 719:	75 17                	jne    732 <printf+0x168>
        putc(fd, c);
 71b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71e:	0f be c0             	movsbl %al,%eax
 721:	89 44 24 04          	mov    %eax,0x4(%esp)
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 c2 fd ff ff       	call   4f2 <putc>
 730:	eb 28                	jmp    75a <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 732:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 739:	00 
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	89 04 24             	mov    %eax,(%esp)
 740:	e8 ad fd ff ff       	call   4f2 <putc>
        putc(fd, c);
 745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 748:	0f be c0             	movsbl %al,%eax
 74b:	89 44 24 04          	mov    %eax,0x4(%esp)
 74f:	8b 45 08             	mov    0x8(%ebp),%eax
 752:	89 04 24             	mov    %eax,(%esp)
 755:	e8 98 fd ff ff       	call   4f2 <putc>
      }
      state = 0;
 75a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 761:	ff 45 f0             	incl   -0x10(%ebp)
 764:	8b 55 0c             	mov    0xc(%ebp),%edx
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	01 d0                	add    %edx,%eax
 76c:	8a 00                	mov    (%eax),%al
 76e:	84 c0                	test   %al,%al
 770:	0f 85 76 fe ff ff    	jne    5ec <printf+0x22>
    }
  }
}
 776:	c9                   	leave  
 777:	c3                   	ret    

00000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	83 e8 08             	sub    $0x8,%eax
 784:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 787:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 78c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78f:	eb 24                	jmp    7b5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8b 00                	mov    (%eax),%eax
 796:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 799:	77 12                	ja     7ad <free+0x35>
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a1:	77 24                	ja     7c7 <free+0x4f>
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ab:	77 1a                	ja     7c7 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 00                	mov    (%eax),%eax
 7b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bb:	76 d4                	jbe    791 <free+0x19>
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c5:	76 ca                	jbe    791 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d7:	01 c2                	add    %eax,%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	8b 00                	mov    (%eax),%eax
 7de:	39 c2                	cmp    %eax,%edx
 7e0:	75 24                	jne    806 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	8b 50 04             	mov    0x4(%eax),%edx
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	8b 40 04             	mov    0x4(%eax),%eax
 7f0:	01 c2                	add    %eax,%edx
 7f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	8b 10                	mov    (%eax),%edx
 7ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 802:	89 10                	mov    %edx,(%eax)
 804:	eb 0a                	jmp    810 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 10                	mov    (%eax),%edx
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 810:	8b 45 fc             	mov    -0x4(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	01 d0                	add    %edx,%eax
 822:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 825:	75 20                	jne    847 <free+0xcf>
    p->s.size += bp->s.size;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 50 04             	mov    0x4(%eax),%edx
 82d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	01 c2                	add    %eax,%edx
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83e:	8b 10                	mov    (%eax),%edx
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	89 10                	mov    %edx,(%eax)
 845:	eb 08                	jmp    84f <free+0xd7>
  } else
    p->s.ptr = bp;
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84d:	89 10                	mov    %edx,(%eax)
  freep = p;
 84f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 852:	a3 5c 0c 00 00       	mov    %eax,0xc5c
}
 857:	c9                   	leave  
 858:	c3                   	ret    

00000859 <morecore>:

static Header*
morecore(uint nu)
{
 859:	55                   	push   %ebp
 85a:	89 e5                	mov    %esp,%ebp
 85c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 85f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 866:	77 07                	ja     86f <morecore+0x16>
    nu = 4096;
 868:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 86f:	8b 45 08             	mov    0x8(%ebp),%eax
 872:	c1 e0 03             	shl    $0x3,%eax
 875:	89 04 24             	mov    %eax,(%esp)
 878:	e8 05 fc ff ff       	call   482 <sbrk>
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 880:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 884:	75 07                	jne    88d <morecore+0x34>
    return 0;
 886:	b8 00 00 00 00       	mov    $0x0,%eax
 88b:	eb 22                	jmp    8af <morecore+0x56>
  hp = (Header*)p;
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 893:	8b 45 f0             	mov    -0x10(%ebp),%eax
 896:	8b 55 08             	mov    0x8(%ebp),%edx
 899:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89f:	83 c0 08             	add    $0x8,%eax
 8a2:	89 04 24             	mov    %eax,(%esp)
 8a5:	e8 ce fe ff ff       	call   778 <free>
  return freep;
 8aa:	a1 5c 0c 00 00       	mov    0xc5c,%eax
}
 8af:	c9                   	leave  
 8b0:	c3                   	ret    

000008b1 <malloc>:

void*
malloc(uint nbytes)
{
 8b1:	55                   	push   %ebp
 8b2:	89 e5                	mov    %esp,%ebp
 8b4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ba:	83 c0 07             	add    $0x7,%eax
 8bd:	c1 e8 03             	shr    $0x3,%eax
 8c0:	40                   	inc    %eax
 8c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c4:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 8c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d0:	75 23                	jne    8f5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8d2:	c7 45 f0 54 0c 00 00 	movl   $0xc54,-0x10(%ebp)
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	a3 5c 0c 00 00       	mov    %eax,0xc5c
 8e1:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 8e6:	a3 54 0c 00 00       	mov    %eax,0xc54
    base.s.size = 0;
 8eb:	c7 05 58 0c 00 00 00 	movl   $0x0,0xc58
 8f2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f8:	8b 00                	mov    (%eax),%eax
 8fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 906:	72 4d                	jb     955 <malloc+0xa4>
      if(p->s.size == nunits)
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 40 04             	mov    0x4(%eax),%eax
 90e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 911:	75 0c                	jne    91f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 10                	mov    (%eax),%edx
 918:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91b:	89 10                	mov    %edx,(%eax)
 91d:	eb 26                	jmp    945 <malloc+0x94>
      else {
        p->s.size -= nunits;
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	89 c2                	mov    %eax,%edx
 927:	2b 55 ec             	sub    -0x14(%ebp),%edx
 92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	c1 e0 03             	shl    $0x3,%eax
 939:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 942:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 945:	8b 45 f0             	mov    -0x10(%ebp),%eax
 948:	a3 5c 0c 00 00       	mov    %eax,0xc5c
      return (void*)(p + 1);
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	83 c0 08             	add    $0x8,%eax
 953:	eb 38                	jmp    98d <malloc+0xdc>
    }
    if(p == freep)
 955:	a1 5c 0c 00 00       	mov    0xc5c,%eax
 95a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 95d:	75 1b                	jne    97a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 95f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 962:	89 04 24             	mov    %eax,(%esp)
 965:	e8 ef fe ff ff       	call   859 <morecore>
 96a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 96d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 971:	75 07                	jne    97a <malloc+0xc9>
        return 0;
 973:	b8 00 00 00 00       	mov    $0x0,%eax
 978:	eb 13                	jmp    98d <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 980:	8b 45 f4             	mov    -0xc(%ebp),%eax
 983:	8b 00                	mov    (%eax),%eax
 985:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 988:	e9 70 ff ff ff       	jmp    8fd <malloc+0x4c>
}
 98d:	c9                   	leave  
 98e:	c3                   	ret    
