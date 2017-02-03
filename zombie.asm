
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

0000031c <procstat>:
 31c:	b8 18 00 00 00       	mov    $0x18,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <set_priority>:
 324:	b8 19 00 00 00       	mov    $0x19,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 28             	sub    $0x28,%esp
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 338:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 33f:	00 
 340:	8d 45 f4             	lea    -0xc(%ebp),%eax
 343:	89 44 24 04          	mov    %eax,0x4(%esp)
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	89 04 24             	mov    %eax,(%esp)
 34d:	e8 3a ff ff ff       	call   28c <write>
}
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 361:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 365:	74 17                	je     37e <printint+0x2a>
 367:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36b:	79 11                	jns    37e <printint+0x2a>
    neg = 1;
 36d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	f7 d8                	neg    %eax
 379:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37c:	eb 06                	jmp    384 <printint+0x30>
  } else {
    x = xx;
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 391:	ba 00 00 00 00       	mov    $0x0,%edx
 396:	f7 f1                	div    %ecx
 398:	89 d0                	mov    %edx,%eax
 39a:	8a 80 0c 0a 00 00    	mov    0xa0c(%eax),%al
 3a0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a6:	01 ca                	add    %ecx,%edx
 3a8:	88 02                	mov    %al,(%edx)
 3aa:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3ad:	8b 55 10             	mov    0x10(%ebp),%edx
 3b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b6:	ba 00 00 00 00       	mov    $0x0,%edx
 3bb:	f7 75 d4             	divl   -0x2c(%ebp)
 3be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c5:	75 c4                	jne    38b <printint+0x37>
  if(neg)
 3c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cb:	74 2c                	je     3f9 <printint+0xa5>
    buf[i++] = '-';
 3cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d3:	01 d0                	add    %edx,%eax
 3d5:	c6 00 2d             	movb   $0x2d,(%eax)
 3d8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3db:	eb 1c                	jmp    3f9 <printint+0xa5>
    putc(fd, buf[i]);
 3dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	8a 00                	mov    (%eax),%al
 3e7:	0f be c0             	movsbl %al,%eax
 3ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	89 04 24             	mov    %eax,(%esp)
 3f4:	e8 33 ff ff ff       	call   32c <putc>
  while(--i >= 0)
 3f9:	ff 4d f4             	decl   -0xc(%ebp)
 3fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 400:	79 db                	jns    3dd <printint+0x89>
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 411:	8d 45 0c             	lea    0xc(%ebp),%eax
 414:	83 c0 04             	add    $0x4,%eax
 417:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 41a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 421:	e9 78 01 00 00       	jmp    59e <printf+0x19a>
    c = fmt[i] & 0xff;
 426:	8b 55 0c             	mov    0xc(%ebp),%edx
 429:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42c:	01 d0                	add    %edx,%eax
 42e:	8a 00                	mov    (%eax),%al
 430:	0f be c0             	movsbl %al,%eax
 433:	25 ff 00 00 00       	and    $0xff,%eax
 438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 43b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43f:	75 2c                	jne    46d <printf+0x69>
      if(c == '%'){
 441:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 445:	75 0c                	jne    453 <printf+0x4f>
        state = '%';
 447:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 44e:	e9 48 01 00 00       	jmp    59b <printf+0x197>
      } else {
        putc(fd, c);
 453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 456:	0f be c0             	movsbl %al,%eax
 459:	89 44 24 04          	mov    %eax,0x4(%esp)
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 c4 fe ff ff       	call   32c <putc>
 468:	e9 2e 01 00 00       	jmp    59b <printf+0x197>
      }
    } else if(state == '%'){
 46d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 471:	0f 85 24 01 00 00    	jne    59b <printf+0x197>
      if(c == 'd'){
 477:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 47b:	75 2d                	jne    4aa <printf+0xa6>
        printint(fd, *ap, 10, 1);
 47d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 480:	8b 00                	mov    (%eax),%eax
 482:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 489:	00 
 48a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 491:	00 
 492:	89 44 24 04          	mov    %eax,0x4(%esp)
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	89 04 24             	mov    %eax,(%esp)
 49c:	e8 b3 fe ff ff       	call   354 <printint>
        ap++;
 4a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a5:	e9 ea 00 00 00       	jmp    594 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4aa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ae:	74 06                	je     4b6 <printf+0xb2>
 4b0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b4:	75 2d                	jne    4e3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b9:	8b 00                	mov    (%eax),%eax
 4bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4c2:	00 
 4c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ca:	00 
 4cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	89 04 24             	mov    %eax,(%esp)
 4d5:	e8 7a fe ff ff       	call   354 <printint>
        ap++;
 4da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4de:	e9 b1 00 00 00       	jmp    594 <printf+0x190>
      } else if(c == 's'){
 4e3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4e7:	75 43                	jne    52c <printf+0x128>
        s = (char*)*ap;
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	75 25                	jne    520 <printf+0x11c>
          s = "(null)";
 4fb:	c7 45 f4 c9 07 00 00 	movl   $0x7c9,-0xc(%ebp)
        while(*s != 0){
 502:	eb 1c                	jmp    520 <printf+0x11c>
          putc(fd, *s);
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	8a 00                	mov    (%eax),%al
 509:	0f be c0             	movsbl %al,%eax
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 11 fe ff ff       	call   32c <putc>
          s++;
 51b:	ff 45 f4             	incl   -0xc(%ebp)
 51e:	eb 01                	jmp    521 <printf+0x11d>
        while(*s != 0){
 520:	90                   	nop
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	8a 00                	mov    (%eax),%al
 526:	84 c0                	test   %al,%al
 528:	75 da                	jne    504 <printf+0x100>
 52a:	eb 68                	jmp    594 <printf+0x190>
        }
      } else if(c == 'c'){
 52c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 530:	75 1d                	jne    54f <printf+0x14b>
        putc(fd, *ap);
 532:	8b 45 e8             	mov    -0x18(%ebp),%eax
 535:	8b 00                	mov    (%eax),%eax
 537:	0f be c0             	movsbl %al,%eax
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 e3 fd ff ff       	call   32c <putc>
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	eb 45                	jmp    594 <printf+0x190>
      } else if(c == '%'){
 54f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 553:	75 17                	jne    56c <printf+0x168>
        putc(fd, c);
 555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 c2 fd ff ff       	call   32c <putc>
 56a:	eb 28                	jmp    594 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 573:	00 
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 ad fd ff ff       	call   32c <putc>
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 98 fd ff ff       	call   32c <putc>
      }
      state = 0;
 594:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 59b:	ff 45 f0             	incl   -0x10(%ebp)
 59e:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a4:	01 d0                	add    %edx,%eax
 5a6:	8a 00                	mov    (%eax),%al
 5a8:	84 c0                	test   %al,%al
 5aa:	0f 85 76 fe ff ff    	jne    426 <printf+0x22>
    }
  }
}
 5b0:	c9                   	leave  
 5b1:	c3                   	ret    

000005b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	83 e8 08             	sub    $0x8,%eax
 5be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	a1 28 0a 00 00       	mov    0xa28,%eax
 5c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c9:	eb 24                	jmp    5ef <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d3:	77 12                	ja     5e7 <free+0x35>
 5d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5db:	77 24                	ja     601 <free+0x4f>
 5dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e5:	77 1a                	ja     601 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f5:	76 d4                	jbe    5cb <free+0x19>
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ff:	76 ca                	jbe    5cb <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 601:	8b 45 f8             	mov    -0x8(%ebp),%eax
 604:	8b 40 04             	mov    0x4(%eax),%eax
 607:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	01 c2                	add    %eax,%edx
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	39 c2                	cmp    %eax,%edx
 61a:	75 24                	jne    640 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	8b 50 04             	mov    0x4(%eax),%edx
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	8b 40 04             	mov    0x4(%eax),%eax
 62a:	01 c2                	add    %eax,%edx
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	8b 10                	mov    (%eax),%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	89 10                	mov    %edx,(%eax)
 63e:	eb 0a                	jmp    64a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 10                	mov    (%eax),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 40 04             	mov    0x4(%eax),%eax
 650:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	75 20                	jne    681 <free+0xcf>
    p->s.size += bp->s.size;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 50 04             	mov    0x4(%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	01 c2                	add    %eax,%edx
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
 67f:	eb 08                	jmp    689 <free+0xd7>
  } else
    p->s.ptr = bp;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 55 f8             	mov    -0x8(%ebp),%edx
 687:	89 10                	mov    %edx,(%eax)
  freep = p;
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	a3 28 0a 00 00       	mov    %eax,0xa28
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <morecore>:

static Header*
morecore(uint nu)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 699:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a0:	77 07                	ja     6a9 <morecore+0x16>
    nu = 4096;
 6a2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	c1 e0 03             	shl    $0x3,%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 3d fc ff ff       	call   2f4 <sbrk>
 6b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6be:	75 07                	jne    6c7 <morecore+0x34>
    return 0;
 6c0:	b8 00 00 00 00       	mov    $0x0,%eax
 6c5:	eb 22                	jmp    6e9 <morecore+0x56>
  hp = (Header*)p;
 6c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d0:	8b 55 08             	mov    0x8(%ebp),%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d9:	83 c0 08             	add    $0x8,%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 ce fe ff ff       	call   5b2 <free>
  return freep;
 6e4:	a1 28 0a 00 00       	mov    0xa28,%eax
}
 6e9:	c9                   	leave  
 6ea:	c3                   	ret    

000006eb <malloc>:

void*
malloc(uint nbytes)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	83 c0 07             	add    $0x7,%eax
 6f7:	c1 e8 03             	shr    $0x3,%eax
 6fa:	40                   	inc    %eax
 6fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fe:	a1 28 0a 00 00       	mov    0xa28,%eax
 703:	89 45 f0             	mov    %eax,-0x10(%ebp)
 706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70a:	75 23                	jne    72f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 70c:	c7 45 f0 20 0a 00 00 	movl   $0xa20,-0x10(%ebp)
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	a3 28 0a 00 00       	mov    %eax,0xa28
 71b:	a1 28 0a 00 00       	mov    0xa28,%eax
 720:	a3 20 0a 00 00       	mov    %eax,0xa20
    base.s.size = 0;
 725:	c7 05 24 0a 00 00 00 	movl   $0x0,0xa24
 72c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 740:	72 4d                	jb     78f <malloc+0xa4>
      if(p->s.size == nunits)
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74b:	75 0c                	jne    759 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 26                	jmp    77f <malloc+0x94>
      else {
        p->s.size -= nunits;
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	89 c2                	mov    %eax,%edx
 761:	2b 55 ec             	sub    -0x14(%ebp),%edx
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	c1 e0 03             	shl    $0x3,%eax
 773:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 776:	8b 45 f4             	mov    -0xc(%ebp),%eax
 779:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	a3 28 0a 00 00       	mov    %eax,0xa28
      return (void*)(p + 1);
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	eb 38                	jmp    7c7 <malloc+0xdc>
    }
    if(p == freep)
 78f:	a1 28 0a 00 00       	mov    0xa28,%eax
 794:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 797:	75 1b                	jne    7b4 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 799:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 ef fe ff ff       	call   693 <morecore>
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ab:	75 07                	jne    7b4 <malloc+0xc9>
        return 0;
 7ad:	b8 00 00 00 00       	mov    $0x0,%eax
 7b2:	eb 13                	jmp    7c7 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7c2:	e9 70 ff ff ff       	jmp    737 <malloc+0x4c>
}
 7c7:	c9                   	leave  
 7c8:	c3                   	ret    
