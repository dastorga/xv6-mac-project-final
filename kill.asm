
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
   f:	c7 44 24 04 fc 07 00 	movl   $0x7fc,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 14 04 00 00       	call   437 <printf>
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

0000035f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	83 ec 28             	sub    $0x28,%esp
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 372:	00 
 373:	8d 45 f4             	lea    -0xc(%ebp),%eax
 376:	89 44 24 04          	mov    %eax,0x4(%esp)
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	89 04 24             	mov    %eax,(%esp)
 380:	e8 4a ff ff ff       	call   2cf <write>
}
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 394:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 398:	74 17                	je     3b1 <printint+0x2a>
 39a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39e:	79 11                	jns    3b1 <printint+0x2a>
    neg = 1;
 3a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	f7 d8                	neg    %eax
 3ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3af:	eb 06                	jmp    3b7 <printint+0x30>
  } else {
    x = xx;
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3be:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c4:	ba 00 00 00 00       	mov    $0x0,%edx
 3c9:	f7 f1                	div    %ecx
 3cb:	89 d0                	mov    %edx,%eax
 3cd:	8a 80 54 0a 00 00    	mov    0xa54(%eax),%al
 3d3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3d9:	01 ca                	add    %ecx,%edx
 3db:	88 02                	mov    %al,(%edx)
 3dd:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3e0:	8b 55 10             	mov    0x10(%ebp),%edx
 3e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ee:	f7 75 d4             	divl   -0x2c(%ebp)
 3f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f8:	75 c4                	jne    3be <printint+0x37>
  if(neg)
 3fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fe:	74 2c                	je     42c <printint+0xa5>
    buf[i++] = '-';
 400:	8d 55 dc             	lea    -0x24(%ebp),%edx
 403:	8b 45 f4             	mov    -0xc(%ebp),%eax
 406:	01 d0                	add    %edx,%eax
 408:	c6 00 2d             	movb   $0x2d,(%eax)
 40b:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 40e:	eb 1c                	jmp    42c <printint+0xa5>
    putc(fd, buf[i]);
 410:	8d 55 dc             	lea    -0x24(%ebp),%edx
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	01 d0                	add    %edx,%eax
 418:	8a 00                	mov    (%eax),%al
 41a:	0f be c0             	movsbl %al,%eax
 41d:	89 44 24 04          	mov    %eax,0x4(%esp)
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	89 04 24             	mov    %eax,(%esp)
 427:	e8 33 ff ff ff       	call   35f <putc>
  while(--i >= 0)
 42c:	ff 4d f4             	decl   -0xc(%ebp)
 42f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 433:	79 db                	jns    410 <printint+0x89>
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 444:	8d 45 0c             	lea    0xc(%ebp),%eax
 447:	83 c0 04             	add    $0x4,%eax
 44a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 454:	e9 78 01 00 00       	jmp    5d1 <printf+0x19a>
    c = fmt[i] & 0xff;
 459:	8b 55 0c             	mov    0xc(%ebp),%edx
 45c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	8a 00                	mov    (%eax),%al
 463:	0f be c0             	movsbl %al,%eax
 466:	25 ff 00 00 00       	and    $0xff,%eax
 46b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 472:	75 2c                	jne    4a0 <printf+0x69>
      if(c == '%'){
 474:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 478:	75 0c                	jne    486 <printf+0x4f>
        state = '%';
 47a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 481:	e9 48 01 00 00       	jmp    5ce <printf+0x197>
      } else {
        putc(fd, c);
 486:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 489:	0f be c0             	movsbl %al,%eax
 48c:	89 44 24 04          	mov    %eax,0x4(%esp)
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	89 04 24             	mov    %eax,(%esp)
 496:	e8 c4 fe ff ff       	call   35f <putc>
 49b:	e9 2e 01 00 00       	jmp    5ce <printf+0x197>
      }
    } else if(state == '%'){
 4a0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a4:	0f 85 24 01 00 00    	jne    5ce <printf+0x197>
      if(c == 'd'){
 4aa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ae:	75 2d                	jne    4dd <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b3:	8b 00                	mov    (%eax),%eax
 4b5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4bc:	00 
 4bd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c4:	00 
 4c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	89 04 24             	mov    %eax,(%esp)
 4cf:	e8 b3 fe ff ff       	call   387 <printint>
        ap++;
 4d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d8:	e9 ea 00 00 00       	jmp    5c7 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e1:	74 06                	je     4e9 <printf+0xb2>
 4e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e7:	75 2d                	jne    516 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f5:	00 
 4f6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4fd:	00 
 4fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	89 04 24             	mov    %eax,(%esp)
 508:	e8 7a fe ff ff       	call   387 <printint>
        ap++;
 50d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 511:	e9 b1 00 00 00       	jmp    5c7 <printf+0x190>
      } else if(c == 's'){
 516:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51a:	75 43                	jne    55f <printf+0x128>
        s = (char*)*ap;
 51c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51f:	8b 00                	mov    (%eax),%eax
 521:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 524:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52c:	75 25                	jne    553 <printf+0x11c>
          s = "(null)";
 52e:	c7 45 f4 10 08 00 00 	movl   $0x810,-0xc(%ebp)
        while(*s != 0){
 535:	eb 1c                	jmp    553 <printf+0x11c>
          putc(fd, *s);
 537:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53a:	8a 00                	mov    (%eax),%al
 53c:	0f be c0             	movsbl %al,%eax
 53f:	89 44 24 04          	mov    %eax,0x4(%esp)
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	89 04 24             	mov    %eax,(%esp)
 549:	e8 11 fe ff ff       	call   35f <putc>
          s++;
 54e:	ff 45 f4             	incl   -0xc(%ebp)
 551:	eb 01                	jmp    554 <printf+0x11d>
        while(*s != 0){
 553:	90                   	nop
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8a 00                	mov    (%eax),%al
 559:	84 c0                	test   %al,%al
 55b:	75 da                	jne    537 <printf+0x100>
 55d:	eb 68                	jmp    5c7 <printf+0x190>
        }
      } else if(c == 'c'){
 55f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 563:	75 1d                	jne    582 <printf+0x14b>
        putc(fd, *ap);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 e3 fd ff ff       	call   35f <putc>
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 580:	eb 45                	jmp    5c7 <printf+0x190>
      } else if(c == '%'){
 582:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 586:	75 17                	jne    59f <printf+0x168>
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 c2 fd ff ff       	call   35f <putc>
 59d:	eb 28                	jmp    5c7 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a6:	00 
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 ad fd ff ff       	call   35f <putc>
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 98 fd ff ff       	call   35f <putc>
      }
      state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5ce:	ff 45 f0             	incl   -0x10(%ebp)
 5d1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d7:	01 d0                	add    %edx,%eax
 5d9:	8a 00                	mov    (%eax),%al
 5db:	84 c0                	test   %al,%al
 5dd:	0f 85 76 fe ff ff    	jne    459 <printf+0x22>
    }
  }
}
 5e3:	c9                   	leave  
 5e4:	c3                   	ret    

000005e5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e5:	55                   	push   %ebp
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	83 e8 08             	sub    $0x8,%eax
 5f1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f4:	a1 70 0a 00 00       	mov    0xa70,%eax
 5f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fc:	eb 24                	jmp    622 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 601:	8b 00                	mov    (%eax),%eax
 603:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 606:	77 12                	ja     61a <free+0x35>
 608:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60e:	77 24                	ja     634 <free+0x4f>
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 618:	77 1a                	ja     634 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 622:	8b 45 f8             	mov    -0x8(%ebp),%eax
 625:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 628:	76 d4                	jbe    5fe <free+0x19>
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 632:	76 ca                	jbe    5fe <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	8b 40 04             	mov    0x4(%eax),%eax
 63a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	01 c2                	add    %eax,%edx
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	39 c2                	cmp    %eax,%edx
 64d:	75 24                	jne    673 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 64f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 652:	8b 50 04             	mov    0x4(%eax),%edx
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 00                	mov    (%eax),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	01 c2                	add    %eax,%edx
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	8b 10                	mov    (%eax),%edx
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	89 10                	mov    %edx,(%eax)
 671:	eb 0a                	jmp    67d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 10                	mov    (%eax),%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 40 04             	mov    0x4(%eax),%eax
 683:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	01 d0                	add    %edx,%eax
 68f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 692:	75 20                	jne    6b4 <free+0xcf>
    p->s.size += bp->s.size;
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	8b 50 04             	mov    0x4(%eax),%edx
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	8b 40 04             	mov    0x4(%eax),%eax
 6a0:	01 c2                	add    %eax,%edx
 6a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 10                	mov    (%eax),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	89 10                	mov    %edx,(%eax)
 6b2:	eb 08                	jmp    6bc <free+0xd7>
  } else
    p->s.ptr = bp;
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ba:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 6c4:	c9                   	leave  
 6c5:	c3                   	ret    

000006c6 <morecore>:

static Header*
morecore(uint nu)
{
 6c6:	55                   	push   %ebp
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d3:	77 07                	ja     6dc <morecore+0x16>
    nu = 4096;
 6d5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	c1 e0 03             	shl    $0x3,%eax
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 4d fc ff ff       	call   337 <sbrk>
 6ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ed:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f1:	75 07                	jne    6fa <morecore+0x34>
    return 0;
 6f3:	b8 00 00 00 00       	mov    $0x0,%eax
 6f8:	eb 22                	jmp    71c <morecore+0x56>
  hp = (Header*)p;
 6fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 700:	8b 45 f0             	mov    -0x10(%ebp),%eax
 703:	8b 55 08             	mov    0x8(%ebp),%edx
 706:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	83 c0 08             	add    $0x8,%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 ce fe ff ff       	call   5e5 <free>
  return freep;
 717:	a1 70 0a 00 00       	mov    0xa70,%eax
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <malloc>:

void*
malloc(uint nbytes)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	83 c0 07             	add    $0x7,%eax
 72a:	c1 e8 03             	shr    $0x3,%eax
 72d:	40                   	inc    %eax
 72e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 731:	a1 70 0a 00 00       	mov    0xa70,%eax
 736:	89 45 f0             	mov    %eax,-0x10(%ebp)
 739:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 73d:	75 23                	jne    762 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 73f:	c7 45 f0 68 0a 00 00 	movl   $0xa68,-0x10(%ebp)
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	a3 70 0a 00 00       	mov    %eax,0xa70
 74e:	a1 70 0a 00 00       	mov    0xa70,%eax
 753:	a3 68 0a 00 00       	mov    %eax,0xa68
    base.s.size = 0;
 758:	c7 05 6c 0a 00 00 00 	movl   $0x0,0xa6c
 75f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 762:	8b 45 f0             	mov    -0x10(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 773:	72 4d                	jb     7c2 <malloc+0xa4>
      if(p->s.size == nunits)
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	8b 40 04             	mov    0x4(%eax),%eax
 77b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 77e:	75 0c                	jne    78c <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	8b 10                	mov    (%eax),%edx
 785:	8b 45 f0             	mov    -0x10(%ebp),%eax
 788:	89 10                	mov    %edx,(%eax)
 78a:	eb 26                	jmp    7b2 <malloc+0x94>
      else {
        p->s.size -= nunits;
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	89 c2                	mov    %eax,%edx
 794:	2b 55 ec             	sub    -0x14(%ebp),%edx
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	c1 e0 03             	shl    $0x3,%eax
 7a6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7af:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b5:	a3 70 0a 00 00       	mov    %eax,0xa70
      return (void*)(p + 1);
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	83 c0 08             	add    $0x8,%eax
 7c0:	eb 38                	jmp    7fa <malloc+0xdc>
    }
    if(p == freep)
 7c2:	a1 70 0a 00 00       	mov    0xa70,%eax
 7c7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ca:	75 1b                	jne    7e7 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7cf:	89 04 24             	mov    %eax,(%esp)
 7d2:	e8 ef fe ff ff       	call   6c6 <morecore>
 7d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7de:	75 07                	jne    7e7 <malloc+0xc9>
        return 0;
 7e0:	b8 00 00 00 00       	mov    $0x0,%eax
 7e5:	eb 13                	jmp    7fa <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	8b 00                	mov    (%eax),%eax
 7f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7f5:	e9 70 ff ff ff       	jmp    76a <malloc+0x4c>
}
 7fa:	c9                   	leave  
 7fb:	c3                   	ret    
