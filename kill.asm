
_kill:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 1){
   9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 0c 08 00 	movl   $0x80c,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 24 04 00 00       	call   447 <printf>
    exit();
  23:	e8 87 02 00 00       	call   2af <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 26                	jmp    58 <main+0x58>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 dd 01 00 00       	call   229 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 8b 02 00 00       	call   2df <kill>
  for(i=1; i<argc; i++)
  54:	ff 44 24 1c          	incl   0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c d1                	jl     32 <main+0x32>
  exit();
  61:	e8 49 02 00 00       	call   2af <exit>

00000066 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  66:	55                   	push   %ebp
  67:	89 e5                	mov    %esp,%ebp
  69:	57                   	push   %edi
  6a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6e:	8b 55 10             	mov    0x10(%ebp),%edx
  71:	8b 45 0c             	mov    0xc(%ebp),%eax
  74:	89 cb                	mov    %ecx,%ebx
  76:	89 df                	mov    %ebx,%edi
  78:	89 d1                	mov    %edx,%ecx
  7a:	fc                   	cld    
  7b:	f3 aa                	rep stos %al,%es:(%edi)
  7d:	89 ca                	mov    %ecx,%edx
  7f:	89 fb                	mov    %edi,%ebx
  81:	89 5d 08             	mov    %ebx,0x8(%ebp)
  84:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 0c             	mov    0xc(%ebp),%eax
  9b:	8a 10                	mov    (%eax),%dl
  9d:	8b 45 08             	mov    0x8(%ebp),%eax
  a0:	88 10                	mov    %dl,(%eax)
  a2:	8b 45 08             	mov    0x8(%ebp),%eax
  a5:	8a 00                	mov    (%eax),%al
  a7:	84 c0                	test   %al,%al
  a9:	0f 95 c0             	setne  %al
  ac:	ff 45 08             	incl   0x8(%ebp)
  af:	ff 45 0c             	incl   0xc(%ebp)
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 06                	jmp    c6 <strcmp+0xb>
    p++, q++;
  c0:	ff 45 08             	incl   0x8(%ebp)
  c3:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	8a 00                	mov    (%eax),%al
  cb:	84 c0                	test   %al,%al
  cd:	74 0e                	je     dd <strcmp+0x22>
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	8a 10                	mov    (%eax),%dl
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	8a 00                	mov    (%eax),%al
  d9:	38 c2                	cmp    %al,%dl
  db:	74 e3                	je     c0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	8a 00                	mov    (%eax),%al
  e2:	0f b6 d0             	movzbl %al,%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	8a 00                	mov    (%eax),%al
  ea:	0f b6 c0             	movzbl %al,%eax
  ed:	89 d1                	mov    %edx,%ecx
  ef:	29 c1                	sub    %eax,%ecx
  f1:	89 c8                	mov    %ecx,%eax
}
  f3:	5d                   	pop    %ebp
  f4:	c3                   	ret    

000000f5 <strlen>:

uint
strlen(char *s)
{
  f5:	55                   	push   %ebp
  f6:	89 e5                	mov    %esp,%ebp
  f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 102:	eb 03                	jmp    107 <strlen+0x12>
 104:	ff 45 fc             	incl   -0x4(%ebp)
 107:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10a:	8b 45 08             	mov    0x8(%ebp),%eax
 10d:	01 d0                	add    %edx,%eax
 10f:	8a 00                	mov    (%eax),%al
 111:	84 c0                	test   %al,%al
 113:	75 ef                	jne    104 <strlen+0xf>
    ;
  return n;
 115:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 118:	c9                   	leave  
 119:	c3                   	ret    

0000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	55                   	push   %ebp
 11b:	89 e5                	mov    %esp,%ebp
 11d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 120:	8b 45 10             	mov    0x10(%ebp),%eax
 123:	89 44 24 08          	mov    %eax,0x8(%esp)
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 44 24 04          	mov    %eax,0x4(%esp)
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	89 04 24             	mov    %eax,(%esp)
 134:	e8 2d ff ff ff       	call   66 <stosb>
  return dst;
 139:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13c:	c9                   	leave  
 13d:	c3                   	ret    

0000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	55                   	push   %ebp
 13f:	89 e5                	mov    %esp,%ebp
 141:	83 ec 04             	sub    $0x4,%esp
 144:	8b 45 0c             	mov    0xc(%ebp),%eax
 147:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14a:	eb 12                	jmp    15e <strchr+0x20>
    if(*s == c)
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	8a 00                	mov    (%eax),%al
 151:	3a 45 fc             	cmp    -0x4(%ebp),%al
 154:	75 05                	jne    15b <strchr+0x1d>
      return (char*)s;
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	eb 11                	jmp    16c <strchr+0x2e>
  for(; *s; s++)
 15b:	ff 45 08             	incl   0x8(%ebp)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8a 00                	mov    (%eax),%al
 163:	84 c0                	test   %al,%al
 165:	75 e5                	jne    14c <strchr+0xe>
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 184:	00 
 185:	8d 45 ef             	lea    -0x11(%ebp),%eax
 188:	89 44 24 04          	mov    %eax,0x4(%esp)
 18c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 193:	e8 2f 01 00 00       	call   2c7 <read>
 198:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19f:	7e 29                	jle    1ca <gets+0x5c>
      break;
    buf[i++] = c;
 1a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ac:	88 02                	mov    %al,(%edx)
 1ae:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b1:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b4:	3c 0a                	cmp    $0xa,%al
 1b6:	74 13                	je     1cb <gets+0x5d>
 1b8:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0c                	je     1cb <gets+0x5d>
  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	40                   	inc    %eax
 1c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c6:	7c b5                	jl     17d <gets+0xf>
 1c8:	eb 01                	jmp    1cb <gets+0x5d>
      break;
 1ca:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <stat>:

int
stat(char *n, struct stat *st)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1e8:	00 
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 fb 00 00 00       	call   2ef <open>
 1f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fb:	79 07                	jns    204 <stat+0x29>
    return -1;
 1fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 202:	eb 23                	jmp    227 <stat+0x4c>
  r = fstat(fd, st);
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	89 44 24 04          	mov    %eax,0x4(%esp)
 20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 20e:	89 04 24             	mov    %eax,(%esp)
 211:	e8 f1 00 00 00       	call   307 <fstat>
 216:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 219:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 b3 00 00 00       	call   2d7 <close>
  return r;
 224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 227:	c9                   	leave  
 228:	c3                   	ret    

00000229 <atoi>:

int
atoi(const char *s)
{
 229:	55                   	push   %ebp
 22a:	89 e5                	mov    %esp,%ebp
 22c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 22f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 236:	eb 21                	jmp    259 <atoi+0x30>
    n = n*10 + *s++ - '0';
 238:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23b:	89 d0                	mov    %edx,%eax
 23d:	c1 e0 02             	shl    $0x2,%eax
 240:	01 d0                	add    %edx,%eax
 242:	d1 e0                	shl    %eax
 244:	89 c2                	mov    %eax,%edx
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	8a 00                	mov    (%eax),%al
 24b:	0f be c0             	movsbl %al,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	83 e8 30             	sub    $0x30,%eax
 253:	89 45 fc             	mov    %eax,-0x4(%ebp)
 256:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	8a 00                	mov    (%eax),%al
 25e:	3c 2f                	cmp    $0x2f,%al
 260:	7e 09                	jle    26b <atoi+0x42>
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	8a 00                	mov    (%eax),%al
 267:	3c 39                	cmp    $0x39,%al
 269:	7e cd                	jle    238 <atoi+0xf>
  return n;
 26b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26e:	c9                   	leave  
 26f:	c3                   	ret    

00000270 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 27c:	8b 45 0c             	mov    0xc(%ebp),%eax
 27f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 282:	eb 10                	jmp    294 <memmove+0x24>
    *dst++ = *src++;
 284:	8b 45 f8             	mov    -0x8(%ebp),%eax
 287:	8a 10                	mov    (%eax),%dl
 289:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28c:	88 10                	mov    %dl,(%eax)
 28e:	ff 45 fc             	incl   -0x4(%ebp)
 291:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 294:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 298:	0f 9f c0             	setg   %al
 29b:	ff 4d 10             	decl   0x10(%ebp)
 29e:	84 c0                	test   %al,%al
 2a0:	75 e2                	jne    284 <memmove+0x14>
  return vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a5:	c9                   	leave  
 2a6:	c3                   	ret    

000002a7 <fork>:
 2a7:	b8 01 00 00 00       	mov    $0x1,%eax
 2ac:	cd 40                	int    $0x40
 2ae:	c3                   	ret    

000002af <exit>:
 2af:	b8 02 00 00 00       	mov    $0x2,%eax
 2b4:	cd 40                	int    $0x40
 2b6:	c3                   	ret    

000002b7 <wait>:
 2b7:	b8 03 00 00 00       	mov    $0x3,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <pipe>:
 2bf:	b8 04 00 00 00       	mov    $0x4,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <read>:
 2c7:	b8 05 00 00 00       	mov    $0x5,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <write>:
 2cf:	b8 10 00 00 00       	mov    $0x10,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <close>:
 2d7:	b8 15 00 00 00       	mov    $0x15,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <kill>:
 2df:	b8 06 00 00 00       	mov    $0x6,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <exec>:
 2e7:	b8 07 00 00 00       	mov    $0x7,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <open>:
 2ef:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <mknod>:
 2f7:	b8 11 00 00 00       	mov    $0x11,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <unlink>:
 2ff:	b8 12 00 00 00       	mov    $0x12,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <fstat>:
 307:	b8 08 00 00 00       	mov    $0x8,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <link>:
 30f:	b8 13 00 00 00       	mov    $0x13,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <mkdir>:
 317:	b8 14 00 00 00       	mov    $0x14,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <chdir>:
 31f:	b8 09 00 00 00       	mov    $0x9,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <dup>:
 327:	b8 0a 00 00 00       	mov    $0xa,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <getpid>:
 32f:	b8 0b 00 00 00       	mov    $0xb,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <sbrk>:
 337:	b8 0c 00 00 00       	mov    $0xc,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <sleep>:
 33f:	b8 0d 00 00 00       	mov    $0xd,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <uptime>:
 347:	b8 0e 00 00 00       	mov    $0xe,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <lseek>:
 34f:	b8 16 00 00 00       	mov    $0x16,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <isatty>:
 357:	b8 17 00 00 00       	mov    $0x17,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <procstat>:
 35f:	b8 18 00 00 00       	mov    $0x18,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <set_priority>:
 367:	b8 19 00 00 00       	mov    $0x19,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 28             	sub    $0x28,%esp
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 382:	00 
 383:	8d 45 f4             	lea    -0xc(%ebp),%eax
 386:	89 44 24 04          	mov    %eax,0x4(%esp)
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	89 04 24             	mov    %eax,(%esp)
 390:	e8 3a ff ff ff       	call   2cf <write>
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a8:	74 17                	je     3c1 <printint+0x2a>
 3aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ae:	79 11                	jns    3c1 <printint+0x2a>
    neg = 1;
 3b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	f7 d8                	neg    %eax
 3bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bf:	eb 06                	jmp    3c7 <printint+0x30>
  } else {
    x = xx;
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f1                	div    %ecx
 3db:	89 d0                	mov    %edx,%eax
 3dd:	8a 80 64 0a 00 00    	mov    0xa64(%eax),%al
 3e3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e9:	01 ca                	add    %ecx,%edx
 3eb:	88 02                	mov    %al,(%edx)
 3ed:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3f0:	8b 55 10             	mov    0x10(%ebp),%edx
 3f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f9:	ba 00 00 00 00       	mov    $0x0,%edx
 3fe:	f7 75 d4             	divl   -0x2c(%ebp)
 401:	89 45 ec             	mov    %eax,-0x14(%ebp)
 404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 408:	75 c4                	jne    3ce <printint+0x37>
  if(neg)
 40a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40e:	74 2c                	je     43c <printint+0xa5>
    buf[i++] = '-';
 410:	8d 55 dc             	lea    -0x24(%ebp),%edx
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	01 d0                	add    %edx,%eax
 418:	c6 00 2d             	movb   $0x2d,(%eax)
 41b:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 41e:	eb 1c                	jmp    43c <printint+0xa5>
    putc(fd, buf[i]);
 420:	8d 55 dc             	lea    -0x24(%ebp),%edx
 423:	8b 45 f4             	mov    -0xc(%ebp),%eax
 426:	01 d0                	add    %edx,%eax
 428:	8a 00                	mov    (%eax),%al
 42a:	0f be c0             	movsbl %al,%eax
 42d:	89 44 24 04          	mov    %eax,0x4(%esp)
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	89 04 24             	mov    %eax,(%esp)
 437:	e8 33 ff ff ff       	call   36f <putc>
  while(--i >= 0)
 43c:	ff 4d f4             	decl   -0xc(%ebp)
 43f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 443:	79 db                	jns    420 <printint+0x89>
}
 445:	c9                   	leave  
 446:	c3                   	ret    

00000447 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 454:	8d 45 0c             	lea    0xc(%ebp),%eax
 457:	83 c0 04             	add    $0x4,%eax
 45a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 464:	e9 78 01 00 00       	jmp    5e1 <printf+0x19a>
    c = fmt[i] & 0xff;
 469:	8b 55 0c             	mov    0xc(%ebp),%edx
 46c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46f:	01 d0                	add    %edx,%eax
 471:	8a 00                	mov    (%eax),%al
 473:	0f be c0             	movsbl %al,%eax
 476:	25 ff 00 00 00       	and    $0xff,%eax
 47b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 482:	75 2c                	jne    4b0 <printf+0x69>
      if(c == '%'){
 484:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 488:	75 0c                	jne    496 <printf+0x4f>
        state = '%';
 48a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 491:	e9 48 01 00 00       	jmp    5de <printf+0x197>
      } else {
        putc(fd, c);
 496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	89 04 24             	mov    %eax,(%esp)
 4a6:	e8 c4 fe ff ff       	call   36f <putc>
 4ab:	e9 2e 01 00 00       	jmp    5de <printf+0x197>
      }
    } else if(state == '%'){
 4b0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b4:	0f 85 24 01 00 00    	jne    5de <printf+0x197>
      if(c == 'd'){
 4ba:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4be:	75 2d                	jne    4ed <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c3:	8b 00                	mov    (%eax),%eax
 4c5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4cc:	00 
 4cd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d4:	00 
 4d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	89 04 24             	mov    %eax,(%esp)
 4df:	e8 b3 fe ff ff       	call   397 <printint>
        ap++;
 4e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e8:	e9 ea 00 00 00       	jmp    5d7 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4ed:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f1:	74 06                	je     4f9 <printf+0xb2>
 4f3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f7:	75 2d                	jne    526 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 505:	00 
 506:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50d:	00 
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 7a fe ff ff       	call   397 <printint>
        ap++;
 51d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 521:	e9 b1 00 00 00       	jmp    5d7 <printf+0x190>
      } else if(c == 's'){
 526:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 52a:	75 43                	jne    56f <printf+0x128>
        s = (char*)*ap;
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 534:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53c:	75 25                	jne    563 <printf+0x11c>
          s = "(null)";
 53e:	c7 45 f4 20 08 00 00 	movl   $0x820,-0xc(%ebp)
        while(*s != 0){
 545:	eb 1c                	jmp    563 <printf+0x11c>
          putc(fd, *s);
 547:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54a:	8a 00                	mov    (%eax),%al
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 11 fe ff ff       	call   36f <putc>
          s++;
 55e:	ff 45 f4             	incl   -0xc(%ebp)
 561:	eb 01                	jmp    564 <printf+0x11d>
        while(*s != 0){
 563:	90                   	nop
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	8a 00                	mov    (%eax),%al
 569:	84 c0                	test   %al,%al
 56b:	75 da                	jne    547 <printf+0x100>
 56d:	eb 68                	jmp    5d7 <printf+0x190>
        }
      } else if(c == 'c'){
 56f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 573:	75 1d                	jne    592 <printf+0x14b>
        putc(fd, *ap);
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 e3 fd ff ff       	call   36f <putc>
        ap++;
 58c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 590:	eb 45                	jmp    5d7 <printf+0x190>
      } else if(c == '%'){
 592:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 596:	75 17                	jne    5af <printf+0x168>
        putc(fd, c);
 598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	89 04 24             	mov    %eax,(%esp)
 5a8:	e8 c2 fd ff ff       	call   36f <putc>
 5ad:	eb 28                	jmp    5d7 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5af:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b6:	00 
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 ad fd ff ff       	call   36f <putc>
        putc(fd, c);
 5c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 98 fd ff ff       	call   36f <putc>
      }
      state = 0;
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5de:	ff 45 f0             	incl   -0x10(%ebp)
 5e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e7:	01 d0                	add    %edx,%eax
 5e9:	8a 00                	mov    (%eax),%al
 5eb:	84 c0                	test   %al,%al
 5ed:	0f 85 76 fe ff ff    	jne    469 <printf+0x22>
    }
  }
}
 5f3:	c9                   	leave  
 5f4:	c3                   	ret    

000005f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f5:	55                   	push   %ebp
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	83 e8 08             	sub    $0x8,%eax
 601:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 604:	a1 80 0a 00 00       	mov    0xa80,%eax
 609:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60c:	eb 24                	jmp    632 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 616:	77 12                	ja     62a <free+0x35>
 618:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61e:	77 24                	ja     644 <free+0x4f>
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 628:	77 1a                	ja     644 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 638:	76 d4                	jbe    60e <free+0x19>
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 642:	76 ca                	jbe    60e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	8b 40 04             	mov    0x4(%eax),%eax
 64a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	01 c2                	add    %eax,%edx
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	39 c2                	cmp    %eax,%edx
 65d:	75 24                	jne    683 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	8b 50 04             	mov    0x4(%eax),%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	01 c2                	add    %eax,%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 10                	mov    %edx,(%eax)
 681:	eb 0a                	jmp    68d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 10                	mov    (%eax),%edx
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 40 04             	mov    0x4(%eax),%eax
 693:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	01 d0                	add    %edx,%eax
 69f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a2:	75 20                	jne    6c4 <free+0xcf>
    p->s.size += bp->s.size;
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 50 04             	mov    0x4(%eax),%edx
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	01 c2                	add    %eax,%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bb:	8b 10                	mov    (%eax),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	89 10                	mov    %edx,(%eax)
 6c2:	eb 08                	jmp    6cc <free+0xd7>
  } else
    p->s.ptr = bp;
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ca:	89 10                	mov    %edx,(%eax)
  freep = p;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	a3 80 0a 00 00       	mov    %eax,0xa80
}
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    

000006d6 <morecore>:

static Header*
morecore(uint nu)
{
 6d6:	55                   	push   %ebp
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e3:	77 07                	ja     6ec <morecore+0x16>
    nu = 4096;
 6e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	c1 e0 03             	shl    $0x3,%eax
 6f2:	89 04 24             	mov    %eax,(%esp)
 6f5:	e8 3d fc ff ff       	call   337 <sbrk>
 6fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 701:	75 07                	jne    70a <morecore+0x34>
    return 0;
 703:	b8 00 00 00 00       	mov    $0x0,%eax
 708:	eb 22                	jmp    72c <morecore+0x56>
  hp = (Header*)p;
 70a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 710:	8b 45 f0             	mov    -0x10(%ebp),%eax
 713:	8b 55 08             	mov    0x8(%ebp),%edx
 716:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 719:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71c:	83 c0 08             	add    $0x8,%eax
 71f:	89 04 24             	mov    %eax,(%esp)
 722:	e8 ce fe ff ff       	call   5f5 <free>
  return freep;
 727:	a1 80 0a 00 00       	mov    0xa80,%eax
}
 72c:	c9                   	leave  
 72d:	c3                   	ret    

0000072e <malloc>:

void*
malloc(uint nbytes)
{
 72e:	55                   	push   %ebp
 72f:	89 e5                	mov    %esp,%ebp
 731:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	83 c0 07             	add    $0x7,%eax
 73a:	c1 e8 03             	shr    $0x3,%eax
 73d:	40                   	inc    %eax
 73e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 741:	a1 80 0a 00 00       	mov    0xa80,%eax
 746:	89 45 f0             	mov    %eax,-0x10(%ebp)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	75 23                	jne    772 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 74f:	c7 45 f0 78 0a 00 00 	movl   $0xa78,-0x10(%ebp)
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	a3 80 0a 00 00       	mov    %eax,0xa80
 75e:	a1 80 0a 00 00       	mov    0xa80,%eax
 763:	a3 78 0a 00 00       	mov    %eax,0xa78
    base.s.size = 0;
 768:	c7 05 7c 0a 00 00 00 	movl   $0x0,0xa7c
 76f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 783:	72 4d                	jb     7d2 <malloc+0xa4>
      if(p->s.size == nunits)
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78e:	75 0c                	jne    79c <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 10                	mov    (%eax),%edx
 795:	8b 45 f0             	mov    -0x10(%ebp),%eax
 798:	89 10                	mov    %edx,(%eax)
 79a:	eb 26                	jmp    7c2 <malloc+0x94>
      else {
        p->s.size -= nunits;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	89 c2                	mov    %eax,%edx
 7a4:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	c1 e0 03             	shl    $0x3,%eax
 7b6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	a3 80 0a 00 00       	mov    %eax,0xa80
      return (void*)(p + 1);
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	83 c0 08             	add    $0x8,%eax
 7d0:	eb 38                	jmp    80a <malloc+0xdc>
    }
    if(p == freep)
 7d2:	a1 80 0a 00 00       	mov    0xa80,%eax
 7d7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7da:	75 1b                	jne    7f7 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 ef fe ff ff       	call   6d6 <morecore>
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <malloc+0xc9>
        return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 13                	jmp    80a <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 805:	e9 70 ff ff ff       	jmp    77a <malloc+0x4c>
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    
