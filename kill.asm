
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
   f:	c7 44 24 04 44 08 00 	movl   $0x844,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 5c 04 00 00       	call   47f <printf>
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

0000036f <semget>:
 36f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <semfree>:
 377:	b8 1b 00 00 00       	mov    $0x1b,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <semdown>:
 37f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <semup>:
 387:	b8 1d 00 00 00       	mov    $0x1d,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <shm_create>:
 38f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <shm_close>:
 397:	b8 1f 00 00 00       	mov    $0x1f,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <shm_get>:
 39f:	b8 20 00 00 00       	mov    $0x20,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	83 ec 28             	sub    $0x28,%esp
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3b3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ba:	00 
 3bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3be:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	89 04 24             	mov    %eax,(%esp)
 3c8:	e8 02 ff ff ff       	call   2cf <write>
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3e0:	74 17                	je     3f9 <printint+0x2a>
 3e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3e6:	79 11                	jns    3f9 <printint+0x2a>
    neg = 1;
 3e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	f7 d8                	neg    %eax
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f7:	eb 06                	jmp    3ff <printint+0x30>
  } else {
    x = xx;
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 406:	8b 4d 10             	mov    0x10(%ebp),%ecx
 409:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40c:	ba 00 00 00 00       	mov    $0x0,%edx
 411:	f7 f1                	div    %ecx
 413:	89 d0                	mov    %edx,%eax
 415:	8a 80 9c 0a 00 00    	mov    0xa9c(%eax),%al
 41b:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 41e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 421:	01 ca                	add    %ecx,%edx
 423:	88 02                	mov    %al,(%edx)
 425:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 428:	8b 55 10             	mov    0x10(%ebp),%edx
 42b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 42e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 431:	ba 00 00 00 00       	mov    $0x0,%edx
 436:	f7 75 d4             	divl   -0x2c(%ebp)
 439:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 440:	75 c4                	jne    406 <printint+0x37>
  if(neg)
 442:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 446:	74 2c                	je     474 <printint+0xa5>
    buf[i++] = '-';
 448:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	c6 00 2d             	movb   $0x2d,(%eax)
 453:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 456:	eb 1c                	jmp    474 <printint+0xa5>
    putc(fd, buf[i]);
 458:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45e:	01 d0                	add    %edx,%eax
 460:	8a 00                	mov    (%eax),%al
 462:	0f be c0             	movsbl %al,%eax
 465:	89 44 24 04          	mov    %eax,0x4(%esp)
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	89 04 24             	mov    %eax,(%esp)
 46f:	e8 33 ff ff ff       	call   3a7 <putc>
  while(--i >= 0)
 474:	ff 4d f4             	decl   -0xc(%ebp)
 477:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 47b:	79 db                	jns    458 <printint+0x89>
}
 47d:	c9                   	leave  
 47e:	c3                   	ret    

0000047f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 47f:	55                   	push   %ebp
 480:	89 e5                	mov    %esp,%ebp
 482:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 485:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 48c:	8d 45 0c             	lea    0xc(%ebp),%eax
 48f:	83 c0 04             	add    $0x4,%eax
 492:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 495:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 49c:	e9 78 01 00 00       	jmp    619 <printf+0x19a>
    c = fmt[i] & 0xff;
 4a1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4a7:	01 d0                	add    %edx,%eax
 4a9:	8a 00                	mov    (%eax),%al
 4ab:	0f be c0             	movsbl %al,%eax
 4ae:	25 ff 00 00 00       	and    $0xff,%eax
 4b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ba:	75 2c                	jne    4e8 <printf+0x69>
      if(c == '%'){
 4bc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4c0:	75 0c                	jne    4ce <printf+0x4f>
        state = '%';
 4c2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4c9:	e9 48 01 00 00       	jmp    616 <printf+0x197>
      } else {
        putc(fd, c);
 4ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d1:	0f be c0             	movsbl %al,%eax
 4d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	89 04 24             	mov    %eax,(%esp)
 4de:	e8 c4 fe ff ff       	call   3a7 <putc>
 4e3:	e9 2e 01 00 00       	jmp    616 <printf+0x197>
      }
    } else if(state == '%'){
 4e8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ec:	0f 85 24 01 00 00    	jne    616 <printf+0x197>
      if(c == 'd'){
 4f2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4f6:	75 2d                	jne    525 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fb:	8b 00                	mov    (%eax),%eax
 4fd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 504:	00 
 505:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 50c:	00 
 50d:	89 44 24 04          	mov    %eax,0x4(%esp)
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	89 04 24             	mov    %eax,(%esp)
 517:	e8 b3 fe ff ff       	call   3cf <printint>
        ap++;
 51c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 520:	e9 ea 00 00 00       	jmp    60f <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 525:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 529:	74 06                	je     531 <printf+0xb2>
 52b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 52f:	75 2d                	jne    55e <printf+0xdf>
        printint(fd, *ap, 16, 0);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 53d:	00 
 53e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 545:	00 
 546:	89 44 24 04          	mov    %eax,0x4(%esp)
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	89 04 24             	mov    %eax,(%esp)
 550:	e8 7a fe ff ff       	call   3cf <printint>
        ap++;
 555:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 559:	e9 b1 00 00 00       	jmp    60f <printf+0x190>
      } else if(c == 's'){
 55e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 562:	75 43                	jne    5a7 <printf+0x128>
        s = (char*)*ap;
 564:	8b 45 e8             	mov    -0x18(%ebp),%eax
 567:	8b 00                	mov    (%eax),%eax
 569:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 56c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 574:	75 25                	jne    59b <printf+0x11c>
          s = "(null)";
 576:	c7 45 f4 58 08 00 00 	movl   $0x858,-0xc(%ebp)
        while(*s != 0){
 57d:	eb 1c                	jmp    59b <printf+0x11c>
          putc(fd, *s);
 57f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 582:	8a 00                	mov    (%eax),%al
 584:	0f be c0             	movsbl %al,%eax
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 11 fe ff ff       	call   3a7 <putc>
          s++;
 596:	ff 45 f4             	incl   -0xc(%ebp)
 599:	eb 01                	jmp    59c <printf+0x11d>
        while(*s != 0){
 59b:	90                   	nop
 59c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59f:	8a 00                	mov    (%eax),%al
 5a1:	84 c0                	test   %al,%al
 5a3:	75 da                	jne    57f <printf+0x100>
 5a5:	eb 68                	jmp    60f <printf+0x190>
        }
      } else if(c == 'c'){
 5a7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5ab:	75 1d                	jne    5ca <printf+0x14b>
        putc(fd, *ap);
 5ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 e3 fd ff ff       	call   3a7 <putc>
        ap++;
 5c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c8:	eb 45                	jmp    60f <printf+0x190>
      } else if(c == '%'){
 5ca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ce:	75 17                	jne    5e7 <printf+0x168>
        putc(fd, c);
 5d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d3:	0f be c0             	movsbl %al,%eax
 5d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	89 04 24             	mov    %eax,(%esp)
 5e0:	e8 c2 fd ff ff       	call   3a7 <putc>
 5e5:	eb 28                	jmp    60f <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5e7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ee:	00 
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	89 04 24             	mov    %eax,(%esp)
 5f5:	e8 ad fd ff ff       	call   3a7 <putc>
        putc(fd, c);
 5fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fd:	0f be c0             	movsbl %al,%eax
 600:	89 44 24 04          	mov    %eax,0x4(%esp)
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	89 04 24             	mov    %eax,(%esp)
 60a:	e8 98 fd ff ff       	call   3a7 <putc>
      }
      state = 0;
 60f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 616:	ff 45 f0             	incl   -0x10(%ebp)
 619:	8b 55 0c             	mov    0xc(%ebp),%edx
 61c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61f:	01 d0                	add    %edx,%eax
 621:	8a 00                	mov    (%eax),%al
 623:	84 c0                	test   %al,%al
 625:	0f 85 76 fe ff ff    	jne    4a1 <printf+0x22>
    }
  }
}
 62b:	c9                   	leave  
 62c:	c3                   	ret    

0000062d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62d:	55                   	push   %ebp
 62e:	89 e5                	mov    %esp,%ebp
 630:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	83 e8 08             	sub    $0x8,%eax
 639:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63c:	a1 b8 0a 00 00       	mov    0xab8,%eax
 641:	89 45 fc             	mov    %eax,-0x4(%ebp)
 644:	eb 24                	jmp    66a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64e:	77 12                	ja     662 <free+0x35>
 650:	8b 45 f8             	mov    -0x8(%ebp),%eax
 653:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 656:	77 24                	ja     67c <free+0x4f>
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 660:	77 1a                	ja     67c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 670:	76 d4                	jbe    646 <free+0x19>
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67a:	76 ca                	jbe    646 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	01 c2                	add    %eax,%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	39 c2                	cmp    %eax,%edx
 695:	75 24                	jne    6bb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	8b 50 04             	mov    0x4(%eax),%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	01 c2                	add    %eax,%edx
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	89 10                	mov    %edx,(%eax)
 6b9:	eb 0a                	jmp    6c5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 10                	mov    (%eax),%edx
 6c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 40 04             	mov    0x4(%eax),%eax
 6cb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6da:	75 20                	jne    6fc <free+0xcf>
    p->s.size += bp->s.size;
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 50 04             	mov    0x4(%eax),%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	8b 40 04             	mov    0x4(%eax),%eax
 6e8:	01 c2                	add    %eax,%edx
 6ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ed:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f3:	8b 10                	mov    (%eax),%edx
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	89 10                	mov    %edx,(%eax)
 6fa:	eb 08                	jmp    704 <free+0xd7>
  } else
    p->s.ptr = bp;
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 55 f8             	mov    -0x8(%ebp),%edx
 702:	89 10                	mov    %edx,(%eax)
  freep = p;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 70c:	c9                   	leave  
 70d:	c3                   	ret    

0000070e <morecore>:

static Header*
morecore(uint nu)
{
 70e:	55                   	push   %ebp
 70f:	89 e5                	mov    %esp,%ebp
 711:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 714:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 71b:	77 07                	ja     724 <morecore+0x16>
    nu = 4096;
 71d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 724:	8b 45 08             	mov    0x8(%ebp),%eax
 727:	c1 e0 03             	shl    $0x3,%eax
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 05 fc ff ff       	call   337 <sbrk>
 732:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 735:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 739:	75 07                	jne    742 <morecore+0x34>
    return 0;
 73b:	b8 00 00 00 00       	mov    $0x0,%eax
 740:	eb 22                	jmp    764 <morecore+0x56>
  hp = (Header*)p;
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 748:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74b:	8b 55 08             	mov    0x8(%ebp),%edx
 74e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 751:	8b 45 f0             	mov    -0x10(%ebp),%eax
 754:	83 c0 08             	add    $0x8,%eax
 757:	89 04 24             	mov    %eax,(%esp)
 75a:	e8 ce fe ff ff       	call   62d <free>
  return freep;
 75f:	a1 b8 0a 00 00       	mov    0xab8,%eax
}
 764:	c9                   	leave  
 765:	c3                   	ret    

00000766 <malloc>:

void*
malloc(uint nbytes)
{
 766:	55                   	push   %ebp
 767:	89 e5                	mov    %esp,%ebp
 769:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 76c:	8b 45 08             	mov    0x8(%ebp),%eax
 76f:	83 c0 07             	add    $0x7,%eax
 772:	c1 e8 03             	shr    $0x3,%eax
 775:	40                   	inc    %eax
 776:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 779:	a1 b8 0a 00 00       	mov    0xab8,%eax
 77e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 781:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 785:	75 23                	jne    7aa <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 787:	c7 45 f0 b0 0a 00 00 	movl   $0xab0,-0x10(%ebp)
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	a3 b8 0a 00 00       	mov    %eax,0xab8
 796:	a1 b8 0a 00 00       	mov    0xab8,%eax
 79b:	a3 b0 0a 00 00       	mov    %eax,0xab0
    base.s.size = 0;
 7a0:	c7 05 b4 0a 00 00 00 	movl   $0x0,0xab4
 7a7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7bb:	72 4d                	jb     80a <malloc+0xa4>
      if(p->s.size == nunits)
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7c6:	75 0c                	jne    7d4 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 10                	mov    (%eax),%edx
 7cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d0:	89 10                	mov    %edx,(%eax)
 7d2:	eb 26                	jmp    7fa <malloc+0x94>
      else {
        p->s.size -= nunits;
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	89 c2                	mov    %eax,%edx
 7dc:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	c1 e0 03             	shl    $0x3,%eax
 7ee:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7f7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fd:	a3 b8 0a 00 00       	mov    %eax,0xab8
      return (void*)(p + 1);
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	83 c0 08             	add    $0x8,%eax
 808:	eb 38                	jmp    842 <malloc+0xdc>
    }
    if(p == freep)
 80a:	a1 b8 0a 00 00       	mov    0xab8,%eax
 80f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 812:	75 1b                	jne    82f <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 814:	8b 45 ec             	mov    -0x14(%ebp),%eax
 817:	89 04 24             	mov    %eax,(%esp)
 81a:	e8 ef fe ff ff       	call   70e <morecore>
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 826:	75 07                	jne    82f <malloc+0xc9>
        return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb 13                	jmp    842 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 83d:	e9 70 ff ff ff       	jmp    7b2 <malloc+0x4c>
}
 842:	c9                   	leave  
 843:	c3                   	ret    
