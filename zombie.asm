
_zombie:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 56 02 00 00       	call   264 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 de 02 00 00       	call   2fc <sleep>
  exit();
  1e:	e8 49 02 00 00       	call   26c <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 0c             	mov    0xc(%ebp),%eax
  58:	8a 10                	mov    (%eax),%dl
  5a:	8b 45 08             	mov    0x8(%ebp),%eax
  5d:	88 10                	mov    %dl,(%eax)
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8a 00                	mov    (%eax),%al
  64:	84 c0                	test   %al,%al
  66:	0f 95 c0             	setne  %al
  69:	ff 45 08             	incl   0x8(%ebp)
  6c:	ff 45 0c             	incl   0xc(%ebp)
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 06                	jmp    83 <strcmp+0xb>
    p++, q++;
  7d:	ff 45 08             	incl   0x8(%ebp)
  80:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  83:	8b 45 08             	mov    0x8(%ebp),%eax
  86:	8a 00                	mov    (%eax),%al
  88:	84 c0                	test   %al,%al
  8a:	74 0e                	je     9a <strcmp+0x22>
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	8a 10                	mov    (%eax),%dl
  91:	8b 45 0c             	mov    0xc(%ebp),%eax
  94:	8a 00                	mov    (%eax),%al
  96:	38 c2                	cmp    %al,%dl
  98:	74 e3                	je     7d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	8a 00                	mov    (%eax),%al
  9f:	0f b6 d0             	movzbl %al,%edx
  a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  a5:	8a 00                	mov    (%eax),%al
  a7:	0f b6 c0             	movzbl %al,%eax
  aa:	89 d1                	mov    %edx,%ecx
  ac:	29 c1                	sub    %eax,%ecx
  ae:	89 c8                	mov    %ecx,%eax
}
  b0:	5d                   	pop    %ebp
  b1:	c3                   	ret    

000000b2 <strlen>:

uint
strlen(char *s)
{
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  bf:	eb 03                	jmp    c4 <strlen+0x12>
  c1:	ff 45 fc             	incl   -0x4(%ebp)
  c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	01 d0                	add    %edx,%eax
  cc:	8a 00                	mov    (%eax),%al
  ce:	84 c0                	test   %al,%al
  d0:	75 ef                	jne    c1 <strlen+0xf>
    ;
  return n;
  d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d5:	c9                   	leave  
  d6:	c3                   	ret    

000000d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  dd:	8b 45 10             	mov    0x10(%ebp),%eax
  e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	89 04 24             	mov    %eax,(%esp)
  f1:	e8 2d ff ff ff       	call   23 <stosb>
  return dst;
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <strchr>:

char*
strchr(const char *s, char c)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 04             	sub    $0x4,%esp
 101:	8b 45 0c             	mov    0xc(%ebp),%eax
 104:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 107:	eb 12                	jmp    11b <strchr+0x20>
    if(*s == c)
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	8a 00                	mov    (%eax),%al
 10e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 111:	75 05                	jne    118 <strchr+0x1d>
      return (char*)s;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	eb 11                	jmp    129 <strchr+0x2e>
  for(; *s; s++)
 118:	ff 45 08             	incl   0x8(%ebp)
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	8a 00                	mov    (%eax),%al
 120:	84 c0                	test   %al,%al
 122:	75 e5                	jne    109 <strchr+0xe>
  return 0;
 124:	b8 00 00 00 00       	mov    $0x0,%eax
}
 129:	c9                   	leave  
 12a:	c3                   	ret    

0000012b <gets>:

char*
gets(char *buf, int max)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
 12e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 131:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 138:	eb 42                	jmp    17c <gets+0x51>
    cc = read(0, &c, 1);
 13a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 141:	00 
 142:	8d 45 ef             	lea    -0x11(%ebp),%eax
 145:	89 44 24 04          	mov    %eax,0x4(%esp)
 149:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 150:	e8 2f 01 00 00       	call   284 <read>
 155:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 158:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15c:	7e 29                	jle    187 <gets+0x5c>
      break;
    buf[i++] = c;
 15e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	01 c2                	add    %eax,%edx
 166:	8a 45 ef             	mov    -0x11(%ebp),%al
 169:	88 02                	mov    %al,(%edx)
 16b:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 16e:	8a 45 ef             	mov    -0x11(%ebp),%al
 171:	3c 0a                	cmp    $0xa,%al
 173:	74 13                	je     188 <gets+0x5d>
 175:	8a 45 ef             	mov    -0x11(%ebp),%al
 178:	3c 0d                	cmp    $0xd,%al
 17a:	74 0c                	je     188 <gets+0x5d>
  for(i=0; i+1 < max; ){
 17c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17f:	40                   	inc    %eax
 180:	3b 45 0c             	cmp    0xc(%ebp),%eax
 183:	7c b5                	jl     13a <gets+0xf>
 185:	eb 01                	jmp    188 <gets+0x5d>
      break;
 187:	90                   	nop
      break;
  }
  buf[i] = '\0';
 188:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	01 d0                	add    %edx,%eax
 190:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <stat>:

int
stat(char *n, struct stat *st)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a5:	00 
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	89 04 24             	mov    %eax,(%esp)
 1ac:	e8 fb 00 00 00       	call   2ac <open>
 1b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b8:	79 07                	jns    1c1 <stat+0x29>
    return -1;
 1ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1bf:	eb 23                	jmp    1e4 <stat+0x4c>
  r = fstat(fd, st);
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cb:	89 04 24             	mov    %eax,(%esp)
 1ce:	e8 f1 00 00 00       	call   2c4 <fstat>
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	89 04 24             	mov    %eax,(%esp)
 1dc:	e8 b3 00 00 00       	call   294 <close>
  return r;
 1e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e4:	c9                   	leave  
 1e5:	c3                   	ret    

000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	55                   	push   %ebp
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f3:	eb 21                	jmp    216 <atoi+0x30>
    n = n*10 + *s++ - '0';
 1f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f8:	89 d0                	mov    %edx,%eax
 1fa:	c1 e0 02             	shl    $0x2,%eax
 1fd:	01 d0                	add    %edx,%eax
 1ff:	d1 e0                	shl    %eax
 201:	89 c2                	mov    %eax,%edx
 203:	8b 45 08             	mov    0x8(%ebp),%eax
 206:	8a 00                	mov    (%eax),%al
 208:	0f be c0             	movsbl %al,%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	83 e8 30             	sub    $0x30,%eax
 210:	89 45 fc             	mov    %eax,-0x4(%ebp)
 213:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8a 00                	mov    (%eax),%al
 21b:	3c 2f                	cmp    $0x2f,%al
 21d:	7e 09                	jle    228 <atoi+0x42>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	8a 00                	mov    (%eax),%al
 224:	3c 39                	cmp    $0x39,%al
 226:	7e cd                	jle    1f5 <atoi+0xf>
  return n;
 228:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23f:	eb 10                	jmp    251 <memmove+0x24>
    *dst++ = *src++;
 241:	8b 45 f8             	mov    -0x8(%ebp),%eax
 244:	8a 10                	mov    (%eax),%dl
 246:	8b 45 fc             	mov    -0x4(%ebp),%eax
 249:	88 10                	mov    %dl,(%eax)
 24b:	ff 45 fc             	incl   -0x4(%ebp)
 24e:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 251:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 255:	0f 9f c0             	setg   %al
 258:	ff 4d 10             	decl   0x10(%ebp)
 25b:	84 c0                	test   %al,%al
 25d:	75 e2                	jne    241 <memmove+0x14>
  return vdst;
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 262:	c9                   	leave  
 263:	c3                   	ret    

00000264 <fork>:
 264:	b8 01 00 00 00       	mov    $0x1,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <exit>:
 26c:	b8 02 00 00 00       	mov    $0x2,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <wait>:
 274:	b8 03 00 00 00       	mov    $0x3,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <pipe>:
 27c:	b8 04 00 00 00       	mov    $0x4,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <read>:
 284:	b8 05 00 00 00       	mov    $0x5,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <write>:
 28c:	b8 10 00 00 00       	mov    $0x10,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <close>:
 294:	b8 15 00 00 00       	mov    $0x15,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <kill>:
 29c:	b8 06 00 00 00       	mov    $0x6,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <exec>:
 2a4:	b8 07 00 00 00       	mov    $0x7,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <open>:
 2ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <mknod>:
 2b4:	b8 11 00 00 00       	mov    $0x11,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <unlink>:
 2bc:	b8 12 00 00 00       	mov    $0x12,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <fstat>:
 2c4:	b8 08 00 00 00       	mov    $0x8,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <link>:
 2cc:	b8 13 00 00 00       	mov    $0x13,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <mkdir>:
 2d4:	b8 14 00 00 00       	mov    $0x14,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <chdir>:
 2dc:	b8 09 00 00 00       	mov    $0x9,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <dup>:
 2e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <getpid>:
 2ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <sbrk>:
 2f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <sleep>:
 2fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <uptime>:
 304:	b8 0e 00 00 00       	mov    $0xe,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <lseek>:
 30c:	b8 16 00 00 00       	mov    $0x16,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <isatty>:
 314:	b8 17 00 00 00       	mov    $0x17,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 28             	sub    $0x28,%esp
 322:	8b 45 0c             	mov    0xc(%ebp),%eax
 325:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 328:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 32f:	00 
 330:	8d 45 f4             	lea    -0xc(%ebp),%eax
 333:	89 44 24 04          	mov    %eax,0x4(%esp)
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	89 04 24             	mov    %eax,(%esp)
 33d:	e8 4a ff ff ff       	call   28c <write>
}
 342:	c9                   	leave  
 343:	c3                   	ret    

00000344 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 34a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 351:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 355:	74 17                	je     36e <printint+0x2a>
 357:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 35b:	79 11                	jns    36e <printint+0x2a>
    neg = 1;
 35d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	f7 d8                	neg    %eax
 369:	89 45 ec             	mov    %eax,-0x14(%ebp)
 36c:	eb 06                	jmp    374 <printint+0x30>
  } else {
    x = xx;
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 37b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 37e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 381:	ba 00 00 00 00       	mov    $0x0,%edx
 386:	f7 f1                	div    %ecx
 388:	89 d0                	mov    %edx,%eax
 38a:	8a 80 fc 09 00 00    	mov    0x9fc(%eax),%al
 390:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 393:	8b 55 f4             	mov    -0xc(%ebp),%edx
 396:	01 ca                	add    %ecx,%edx
 398:	88 02                	mov    %al,(%edx)
 39a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 39d:	8b 55 10             	mov    0x10(%ebp),%edx
 3a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a6:	ba 00 00 00 00       	mov    $0x0,%edx
 3ab:	f7 75 d4             	divl   -0x2c(%ebp)
 3ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3b5:	75 c4                	jne    37b <printint+0x37>
  if(neg)
 3b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3bb:	74 2c                	je     3e9 <printint+0xa5>
    buf[i++] = '-';
 3bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c3:	01 d0                	add    %edx,%eax
 3c5:	c6 00 2d             	movb   $0x2d,(%eax)
 3c8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3cb:	eb 1c                	jmp    3e9 <printint+0xa5>
    putc(fd, buf[i]);
 3cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d3:	01 d0                	add    %edx,%eax
 3d5:	8a 00                	mov    (%eax),%al
 3d7:	0f be c0             	movsbl %al,%eax
 3da:	89 44 24 04          	mov    %eax,0x4(%esp)
 3de:	8b 45 08             	mov    0x8(%ebp),%eax
 3e1:	89 04 24             	mov    %eax,(%esp)
 3e4:	e8 33 ff ff ff       	call   31c <putc>
  while(--i >= 0)
 3e9:	ff 4d f4             	decl   -0xc(%ebp)
 3ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3f0:	79 db                	jns    3cd <printint+0x89>
}
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 401:	8d 45 0c             	lea    0xc(%ebp),%eax
 404:	83 c0 04             	add    $0x4,%eax
 407:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 40a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 411:	e9 78 01 00 00       	jmp    58e <printf+0x19a>
    c = fmt[i] & 0xff;
 416:	8b 55 0c             	mov    0xc(%ebp),%edx
 419:	8b 45 f0             	mov    -0x10(%ebp),%eax
 41c:	01 d0                	add    %edx,%eax
 41e:	8a 00                	mov    (%eax),%al
 420:	0f be c0             	movsbl %al,%eax
 423:	25 ff 00 00 00       	and    $0xff,%eax
 428:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 42b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42f:	75 2c                	jne    45d <printf+0x69>
      if(c == '%'){
 431:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 435:	75 0c                	jne    443 <printf+0x4f>
        state = '%';
 437:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 43e:	e9 48 01 00 00       	jmp    58b <printf+0x197>
      } else {
        putc(fd, c);
 443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 446:	0f be c0             	movsbl %al,%eax
 449:	89 44 24 04          	mov    %eax,0x4(%esp)
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	89 04 24             	mov    %eax,(%esp)
 453:	e8 c4 fe ff ff       	call   31c <putc>
 458:	e9 2e 01 00 00       	jmp    58b <printf+0x197>
      }
    } else if(state == '%'){
 45d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 461:	0f 85 24 01 00 00    	jne    58b <printf+0x197>
      if(c == 'd'){
 467:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 46b:	75 2d                	jne    49a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 46d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 470:	8b 00                	mov    (%eax),%eax
 472:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 479:	00 
 47a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 481:	00 
 482:	89 44 24 04          	mov    %eax,0x4(%esp)
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	89 04 24             	mov    %eax,(%esp)
 48c:	e8 b3 fe ff ff       	call   344 <printint>
        ap++;
 491:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 495:	e9 ea 00 00 00       	jmp    584 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 49a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 49e:	74 06                	je     4a6 <printf+0xb2>
 4a0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a4:	75 2d                	jne    4d3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a9:	8b 00                	mov    (%eax),%eax
 4ab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4b2:	00 
 4b3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ba:	00 
 4bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bf:	8b 45 08             	mov    0x8(%ebp),%eax
 4c2:	89 04 24             	mov    %eax,(%esp)
 4c5:	e8 7a fe ff ff       	call   344 <printint>
        ap++;
 4ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ce:	e9 b1 00 00 00       	jmp    584 <printf+0x190>
      } else if(c == 's'){
 4d3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d7:	75 43                	jne    51c <printf+0x128>
        s = (char*)*ap;
 4d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4dc:	8b 00                	mov    (%eax),%eax
 4de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e9:	75 25                	jne    510 <printf+0x11c>
          s = "(null)";
 4eb:	c7 45 f4 b9 07 00 00 	movl   $0x7b9,-0xc(%ebp)
        while(*s != 0){
 4f2:	eb 1c                	jmp    510 <printf+0x11c>
          putc(fd, *s);
 4f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f7:	8a 00                	mov    (%eax),%al
 4f9:	0f be c0             	movsbl %al,%eax
 4fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	89 04 24             	mov    %eax,(%esp)
 506:	e8 11 fe ff ff       	call   31c <putc>
          s++;
 50b:	ff 45 f4             	incl   -0xc(%ebp)
 50e:	eb 01                	jmp    511 <printf+0x11d>
        while(*s != 0){
 510:	90                   	nop
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	8a 00                	mov    (%eax),%al
 516:	84 c0                	test   %al,%al
 518:	75 da                	jne    4f4 <printf+0x100>
 51a:	eb 68                	jmp    584 <printf+0x190>
        }
      } else if(c == 'c'){
 51c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 520:	75 1d                	jne    53f <printf+0x14b>
        putc(fd, *ap);
 522:	8b 45 e8             	mov    -0x18(%ebp),%eax
 525:	8b 00                	mov    (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 e3 fd ff ff       	call   31c <putc>
        ap++;
 539:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53d:	eb 45                	jmp    584 <printf+0x190>
      } else if(c == '%'){
 53f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 543:	75 17                	jne    55c <printf+0x168>
        putc(fd, c);
 545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 c2 fd ff ff       	call   31c <putc>
 55a:	eb 28                	jmp    584 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 563:	00 
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 04 24             	mov    %eax,(%esp)
 56a:	e8 ad fd ff ff       	call   31c <putc>
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	89 44 24 04          	mov    %eax,0x4(%esp)
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	89 04 24             	mov    %eax,(%esp)
 57f:	e8 98 fd ff ff       	call   31c <putc>
      }
      state = 0;
 584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 58b:	ff 45 f0             	incl   -0x10(%ebp)
 58e:	8b 55 0c             	mov    0xc(%ebp),%edx
 591:	8b 45 f0             	mov    -0x10(%ebp),%eax
 594:	01 d0                	add    %edx,%eax
 596:	8a 00                	mov    (%eax),%al
 598:	84 c0                	test   %al,%al
 59a:	0f 85 76 fe ff ff    	jne    416 <printf+0x22>
    }
  }
}
 5a0:	c9                   	leave  
 5a1:	c3                   	ret    

000005a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a2:	55                   	push   %ebp
 5a3:	89 e5                	mov    %esp,%ebp
 5a5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	83 e8 08             	sub    $0x8,%eax
 5ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 18 0a 00 00       	mov    0xa18,%eax
 5b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5b9:	eb 24                	jmp    5df <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c3:	77 12                	ja     5d7 <free+0x35>
 5c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5cb:	77 24                	ja     5f1 <free+0x4f>
 5cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d5:	77 1a                	ja     5f1 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e5:	76 d4                	jbe    5bb <free+0x19>
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ef:	76 ca                	jbe    5bb <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f4:	8b 40 04             	mov    0x4(%eax),%eax
 5f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 601:	01 c2                	add    %eax,%edx
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	39 c2                	cmp    %eax,%edx
 60a:	75 24                	jne    630 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	8b 50 04             	mov    0x4(%eax),%edx
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	8b 40 04             	mov    0x4(%eax),%eax
 61a:	01 c2                	add    %eax,%edx
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	8b 10                	mov    (%eax),%edx
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	89 10                	mov    %edx,(%eax)
 62e:	eb 0a                	jmp    63a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 10                	mov    (%eax),%edx
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 40 04             	mov    0x4(%eax),%eax
 640:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	01 d0                	add    %edx,%eax
 64c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64f:	75 20                	jne    671 <free+0xcf>
    p->s.size += bp->s.size;
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 50 04             	mov    0x4(%eax),%edx
 657:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	01 c2                	add    %eax,%edx
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 665:	8b 45 f8             	mov    -0x8(%ebp),%eax
 668:	8b 10                	mov    (%eax),%edx
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	89 10                	mov    %edx,(%eax)
 66f:	eb 08                	jmp    679 <free+0xd7>
  } else
    p->s.ptr = bp;
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 55 f8             	mov    -0x8(%ebp),%edx
 677:	89 10                	mov    %edx,(%eax)
  freep = p;
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 681:	c9                   	leave  
 682:	c3                   	ret    

00000683 <morecore>:

static Header*
morecore(uint nu)
{
 683:	55                   	push   %ebp
 684:	89 e5                	mov    %esp,%ebp
 686:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 689:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 690:	77 07                	ja     699 <morecore+0x16>
    nu = 4096;
 692:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 699:	8b 45 08             	mov    0x8(%ebp),%eax
 69c:	c1 e0 03             	shl    $0x3,%eax
 69f:	89 04 24             	mov    %eax,(%esp)
 6a2:	e8 4d fc ff ff       	call   2f4 <sbrk>
 6a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6aa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ae:	75 07                	jne    6b7 <morecore+0x34>
    return 0;
 6b0:	b8 00 00 00 00       	mov    $0x0,%eax
 6b5:	eb 22                	jmp    6d9 <morecore+0x56>
  hp = (Header*)p;
 6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c0:	8b 55 08             	mov    0x8(%ebp),%edx
 6c3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c9:	83 c0 08             	add    $0x8,%eax
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 ce fe ff ff       	call   5a2 <free>
  return freep;
 6d4:	a1 18 0a 00 00       	mov    0xa18,%eax
}
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <malloc>:

void*
malloc(uint nbytes)
{
 6db:	55                   	push   %ebp
 6dc:	89 e5                	mov    %esp,%ebp
 6de:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	83 c0 07             	add    $0x7,%eax
 6e7:	c1 e8 03             	shr    $0x3,%eax
 6ea:	40                   	inc    %eax
 6eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6ee:	a1 18 0a 00 00       	mov    0xa18,%eax
 6f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fa:	75 23                	jne    71f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6fc:	c7 45 f0 10 0a 00 00 	movl   $0xa10,-0x10(%ebp)
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	a3 18 0a 00 00       	mov    %eax,0xa18
 70b:	a1 18 0a 00 00       	mov    0xa18,%eax
 710:	a3 10 0a 00 00       	mov    %eax,0xa10
    base.s.size = 0;
 715:	c7 05 14 0a 00 00 00 	movl   $0x0,0xa14
 71c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 71f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	8b 40 04             	mov    0x4(%eax),%eax
 72d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 730:	72 4d                	jb     77f <malloc+0xa4>
      if(p->s.size == nunits)
 732:	8b 45 f4             	mov    -0xc(%ebp),%eax
 735:	8b 40 04             	mov    0x4(%eax),%eax
 738:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73b:	75 0c                	jne    749 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	8b 10                	mov    (%eax),%edx
 742:	8b 45 f0             	mov    -0x10(%ebp),%eax
 745:	89 10                	mov    %edx,(%eax)
 747:	eb 26                	jmp    76f <malloc+0x94>
      else {
        p->s.size -= nunits;
 749:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74c:	8b 40 04             	mov    0x4(%eax),%eax
 74f:	89 c2                	mov    %eax,%edx
 751:	2b 55 ec             	sub    -0x14(%ebp),%edx
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75d:	8b 40 04             	mov    0x4(%eax),%eax
 760:	c1 e0 03             	shl    $0x3,%eax
 763:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 766:	8b 45 f4             	mov    -0xc(%ebp),%eax
 769:	8b 55 ec             	mov    -0x14(%ebp),%edx
 76c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 76f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 772:	a3 18 0a 00 00       	mov    %eax,0xa18
      return (void*)(p + 1);
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	83 c0 08             	add    $0x8,%eax
 77d:	eb 38                	jmp    7b7 <malloc+0xdc>
    }
    if(p == freep)
 77f:	a1 18 0a 00 00       	mov    0xa18,%eax
 784:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 787:	75 1b                	jne    7a4 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 789:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78c:	89 04 24             	mov    %eax,(%esp)
 78f:	e8 ef fe ff ff       	call   683 <morecore>
 794:	89 45 f4             	mov    %eax,-0xc(%ebp)
 797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79b:	75 07                	jne    7a4 <malloc+0xc9>
        return 0;
 79d:	b8 00 00 00 00       	mov    $0x0,%eax
 7a2:	eb 13                	jmp    7b7 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 00                	mov    (%eax),%eax
 7af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7b2:	e9 70 ff ff ff       	jmp    727 <malloc+0x4c>
}
 7b7:	c9                   	leave  
 7b8:	c3                   	ret    
