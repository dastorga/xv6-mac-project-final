
_quantum-test:     formato del fichero elf32-i386


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
   6:	83 ec 20             	sub    $0x20,%esp
  int count, t1=0, t2=1, display=0;
   9:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
  10:	00 
  11:	c7 44 24 14 01 00 00 	movl   $0x1,0x14(%esp)
  18:	00 
  19:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  20:	00 
  count=2;   
  21:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
  28:	00 
  while (count<1000)  
  29:	eb 3e                	jmp    69 <main+0x69>
  {
      display=t1+t2;
  2b:	8b 44 24 14          	mov    0x14(%esp),%eax
  2f:	8b 54 24 18          	mov    0x18(%esp),%edx
  33:	01 d0                	add    %edx,%eax
  35:	89 44 24 10          	mov    %eax,0x10(%esp)
      t1=t2;
  39:	8b 44 24 14          	mov    0x14(%esp),%eax
  3d:	89 44 24 18          	mov    %eax,0x18(%esp)
      t2=display;
  41:	8b 44 24 10          	mov    0x10(%esp),%eax
  45:	89 44 24 14          	mov    %eax,0x14(%esp)
      ++count;
  49:	ff 44 24 1c          	incl   0x1c(%esp)
      printf(1, "display %d\n", display);
  4d:	8b 44 24 10          	mov    0x10(%esp),%eax
  51:	89 44 24 08          	mov    %eax,0x8(%esp)
  55:	c7 44 24 04 56 08 00 	movl   $0x856,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 28 04 00 00       	call   491 <printf>
  while (count<1000)  
  69:	81 7c 24 1c e7 03 00 	cmpl   $0x3e7,0x1c(%esp)
  70:	00 
  71:	7e b8                	jle    2b <main+0x2b>
  }
  exit();
  73:	e8 49 02 00 00       	call   2c1 <exit>

00000078 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	57                   	push   %edi
  7c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80:	8b 55 10             	mov    0x10(%ebp),%edx
  83:	8b 45 0c             	mov    0xc(%ebp),%eax
  86:	89 cb                	mov    %ecx,%ebx
  88:	89 df                	mov    %ebx,%edi
  8a:	89 d1                	mov    %edx,%ecx
  8c:	fc                   	cld    
  8d:	f3 aa                	rep stos %al,%es:(%edi)
  8f:	89 ca                	mov    %ecx,%edx
  91:	89 fb                	mov    %edi,%ebx
  93:	89 5d 08             	mov    %ebx,0x8(%ebp)
  96:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  99:	5b                   	pop    %ebx
  9a:	5f                   	pop    %edi
  9b:	5d                   	pop    %ebp
  9c:	c3                   	ret    

0000009d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a3:	8b 45 08             	mov    0x8(%ebp),%eax
  a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a9:	90                   	nop
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	8a 10                	mov    (%eax),%dl
  af:	8b 45 08             	mov    0x8(%ebp),%eax
  b2:	88 10                	mov    %dl,(%eax)
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	8a 00                	mov    (%eax),%al
  b9:	84 c0                	test   %al,%al
  bb:	0f 95 c0             	setne  %al
  be:	ff 45 08             	incl   0x8(%ebp)
  c1:	ff 45 0c             	incl   0xc(%ebp)
  c4:	84 c0                	test   %al,%al
  c6:	75 e2                	jne    aa <strcpy+0xd>
    ;
  return os;
  c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cb:	c9                   	leave  
  cc:	c3                   	ret    

000000cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cd:	55                   	push   %ebp
  ce:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d0:	eb 06                	jmp    d8 <strcmp+0xb>
    p++, q++;
  d2:	ff 45 08             	incl   0x8(%ebp)
  d5:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	8a 00                	mov    (%eax),%al
  dd:	84 c0                	test   %al,%al
  df:	74 0e                	je     ef <strcmp+0x22>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	8a 10                	mov    (%eax),%dl
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	8a 00                	mov    (%eax),%al
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 e3                	je     d2 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	8a 00                	mov    (%eax),%al
  f4:	0f b6 d0             	movzbl %al,%edx
  f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  fa:	8a 00                	mov    (%eax),%al
  fc:	0f b6 c0             	movzbl %al,%eax
  ff:	89 d1                	mov    %edx,%ecx
 101:	29 c1                	sub    %eax,%ecx
 103:	89 c8                	mov    %ecx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 03                	jmp    119 <strlen+0x12>
 116:	ff 45 fc             	incl   -0x4(%ebp)
 119:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	01 d0                	add    %edx,%eax
 121:	8a 00                	mov    (%eax),%al
 123:	84 c0                	test   %al,%al
 125:	75 ef                	jne    116 <strlen+0xf>
    ;
  return n;
 127:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12a:	c9                   	leave  
 12b:	c3                   	ret    

0000012c <memset>:

void*
memset(void *dst, int c, uint n)
{
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 132:	8b 45 10             	mov    0x10(%ebp),%eax
 135:	89 44 24 08          	mov    %eax,0x8(%esp)
 139:	8b 45 0c             	mov    0xc(%ebp),%eax
 13c:	89 44 24 04          	mov    %eax,0x4(%esp)
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	89 04 24             	mov    %eax,(%esp)
 146:	e8 2d ff ff ff       	call   78 <stosb>
  return dst;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14e:	c9                   	leave  
 14f:	c3                   	ret    

00000150 <strchr>:

char*
strchr(const char *s, char c)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 04             	sub    $0x4,%esp
 156:	8b 45 0c             	mov    0xc(%ebp),%eax
 159:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15c:	eb 12                	jmp    170 <strchr+0x20>
    if(*s == c)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8a 00                	mov    (%eax),%al
 163:	3a 45 fc             	cmp    -0x4(%ebp),%al
 166:	75 05                	jne    16d <strchr+0x1d>
      return (char*)s;
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	eb 11                	jmp    17e <strchr+0x2e>
  for(; *s; s++)
 16d:	ff 45 08             	incl   0x8(%ebp)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	8a 00                	mov    (%eax),%al
 175:	84 c0                	test   %al,%al
 177:	75 e5                	jne    15e <strchr+0xe>
  return 0;
 179:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <gets>:

char*
gets(char *buf, int max)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18d:	eb 42                	jmp    1d1 <gets+0x51>
    cc = read(0, &c, 1);
 18f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 196:	00 
 197:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19a:	89 44 24 04          	mov    %eax,0x4(%esp)
 19e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a5:	e8 2f 01 00 00       	call   2d9 <read>
 1aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b1:	7e 29                	jle    1dc <gets+0x5c>
      break;
    buf[i++] = c;
 1b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	01 c2                	add    %eax,%edx
 1bb:	8a 45 ef             	mov    -0x11(%ebp),%al
 1be:	88 02                	mov    %al,(%edx)
 1c0:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c3:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c6:	3c 0a                	cmp    $0xa,%al
 1c8:	74 13                	je     1dd <gets+0x5d>
 1ca:	8a 45 ef             	mov    -0x11(%ebp),%al
 1cd:	3c 0d                	cmp    $0xd,%al
 1cf:	74 0c                	je     1dd <gets+0x5d>
  for(i=0; i+1 < max; ){
 1d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d4:	40                   	inc    %eax
 1d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d8:	7c b5                	jl     18f <gets+0xf>
 1da:	eb 01                	jmp    1dd <gets+0x5d>
      break;
 1dc:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	01 d0                	add    %edx,%eax
 1e5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <stat>:

int
stat(char *n, struct stat *st)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fa:	00 
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	89 04 24             	mov    %eax,(%esp)
 201:	e8 fb 00 00 00       	call   301 <open>
 206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20d:	79 07                	jns    216 <stat+0x29>
    return -1;
 20f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 214:	eb 23                	jmp    239 <stat+0x4c>
  r = fstat(fd, st);
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	89 44 24 04          	mov    %eax,0x4(%esp)
 21d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 220:	89 04 24             	mov    %eax,(%esp)
 223:	e8 f1 00 00 00       	call   319 <fstat>
 228:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22e:	89 04 24             	mov    %eax,(%esp)
 231:	e8 b3 00 00 00       	call   2e9 <close>
  return r;
 236:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 239:	c9                   	leave  
 23a:	c3                   	ret    

0000023b <atoi>:

int
atoi(const char *s)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 248:	eb 21                	jmp    26b <atoi+0x30>
    n = n*10 + *s++ - '0';
 24a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24d:	89 d0                	mov    %edx,%eax
 24f:	c1 e0 02             	shl    $0x2,%eax
 252:	01 d0                	add    %edx,%eax
 254:	d1 e0                	shl    %eax
 256:	89 c2                	mov    %eax,%edx
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	8a 00                	mov    (%eax),%al
 25d:	0f be c0             	movsbl %al,%eax
 260:	01 d0                	add    %edx,%eax
 262:	83 e8 30             	sub    $0x30,%eax
 265:	89 45 fc             	mov    %eax,-0x4(%ebp)
 268:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	8a 00                	mov    (%eax),%al
 270:	3c 2f                	cmp    $0x2f,%al
 272:	7e 09                	jle    27d <atoi+0x42>
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8a 00                	mov    (%eax),%al
 279:	3c 39                	cmp    $0x39,%al
 27b:	7e cd                	jle    24a <atoi+0xf>
  return n;
 27d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 280:	c9                   	leave  
 281:	c3                   	ret    

00000282 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 282:	55                   	push   %ebp
 283:	89 e5                	mov    %esp,%ebp
 285:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 294:	eb 10                	jmp    2a6 <memmove+0x24>
    *dst++ = *src++;
 296:	8b 45 f8             	mov    -0x8(%ebp),%eax
 299:	8a 10                	mov    (%eax),%dl
 29b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29e:	88 10                	mov    %dl,(%eax)
 2a0:	ff 45 fc             	incl   -0x4(%ebp)
 2a3:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 2a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2aa:	0f 9f c0             	setg   %al
 2ad:	ff 4d 10             	decl   0x10(%ebp)
 2b0:	84 c0                	test   %al,%al
 2b2:	75 e2                	jne    296 <memmove+0x14>
  return vdst;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b7:	c9                   	leave  
 2b8:	c3                   	ret    

000002b9 <fork>:
 2b9:	b8 01 00 00 00       	mov    $0x1,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <exit>:
 2c1:	b8 02 00 00 00       	mov    $0x2,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <wait>:
 2c9:	b8 03 00 00 00       	mov    $0x3,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <pipe>:
 2d1:	b8 04 00 00 00       	mov    $0x4,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <read>:
 2d9:	b8 05 00 00 00       	mov    $0x5,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <write>:
 2e1:	b8 10 00 00 00       	mov    $0x10,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <close>:
 2e9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <kill>:
 2f1:	b8 06 00 00 00       	mov    $0x6,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <exec>:
 2f9:	b8 07 00 00 00       	mov    $0x7,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <open>:
 301:	b8 0f 00 00 00       	mov    $0xf,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <mknod>:
 309:	b8 11 00 00 00       	mov    $0x11,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <unlink>:
 311:	b8 12 00 00 00       	mov    $0x12,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <fstat>:
 319:	b8 08 00 00 00       	mov    $0x8,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <link>:
 321:	b8 13 00 00 00       	mov    $0x13,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <mkdir>:
 329:	b8 14 00 00 00       	mov    $0x14,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <chdir>:
 331:	b8 09 00 00 00       	mov    $0x9,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <dup>:
 339:	b8 0a 00 00 00       	mov    $0xa,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <getpid>:
 341:	b8 0b 00 00 00       	mov    $0xb,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <sbrk>:
 349:	b8 0c 00 00 00       	mov    $0xc,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sleep>:
 351:	b8 0d 00 00 00       	mov    $0xd,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <uptime>:
 359:	b8 0e 00 00 00       	mov    $0xe,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <lseek>:
 361:	b8 16 00 00 00       	mov    $0x16,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <isatty>:
 369:	b8 17 00 00 00       	mov    $0x17,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <procstat>:
 371:	b8 18 00 00 00       	mov    $0x18,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <set_priority>:
 379:	b8 19 00 00 00       	mov    $0x19,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <semget>:
 381:	b8 1a 00 00 00       	mov    $0x1a,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <semfree>:
 389:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38e:	cd 40                	int    $0x40
 390:	c3                   	ret    

00000391 <semdown>:
 391:	b8 1c 00 00 00       	mov    $0x1c,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <semup>:
 399:	b8 1d 00 00 00       	mov    $0x1d,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <shm_create>:
 3a1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <shm_close>:
 3a9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <shm_get>:
 3b1:	b8 20 00 00 00       	mov    $0x20,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b9:	55                   	push   %ebp
 3ba:	89 e5                	mov    %esp,%ebp
 3bc:	83 ec 28             	sub    $0x28,%esp
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3cc:	00 
 3cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	89 04 24             	mov    %eax,(%esp)
 3da:	e8 02 ff ff ff       	call   2e1 <write>
}
 3df:	c9                   	leave  
 3e0:	c3                   	ret    

000003e1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ee:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f2:	74 17                	je     40b <printint+0x2a>
 3f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f8:	79 11                	jns    40b <printint+0x2a>
    neg = 1;
 3fa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	f7 d8                	neg    %eax
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 409:	eb 06                	jmp    411 <printint+0x30>
  } else {
    x = xx;
 40b:	8b 45 0c             	mov    0xc(%ebp),%eax
 40e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 411:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 418:	8b 4d 10             	mov    0x10(%ebp),%ecx
 41b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41e:	ba 00 00 00 00       	mov    $0x0,%edx
 423:	f7 f1                	div    %ecx
 425:	89 d0                	mov    %edx,%eax
 427:	8a 80 a8 0a 00 00    	mov    0xaa8(%eax),%al
 42d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 430:	8b 55 f4             	mov    -0xc(%ebp),%edx
 433:	01 ca                	add    %ecx,%edx
 435:	88 02                	mov    %al,(%edx)
 437:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 43a:	8b 55 10             	mov    0x10(%ebp),%edx
 43d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 440:	8b 45 ec             	mov    -0x14(%ebp),%eax
 443:	ba 00 00 00 00       	mov    $0x0,%edx
 448:	f7 75 d4             	divl   -0x2c(%ebp)
 44b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 452:	75 c4                	jne    418 <printint+0x37>
  if(neg)
 454:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 458:	74 2c                	je     486 <printint+0xa5>
    buf[i++] = '-';
 45a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 460:	01 d0                	add    %edx,%eax
 462:	c6 00 2d             	movb   $0x2d,(%eax)
 465:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 468:	eb 1c                	jmp    486 <printint+0xa5>
    putc(fd, buf[i]);
 46a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 470:	01 d0                	add    %edx,%eax
 472:	8a 00                	mov    (%eax),%al
 474:	0f be c0             	movsbl %al,%eax
 477:	89 44 24 04          	mov    %eax,0x4(%esp)
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	89 04 24             	mov    %eax,(%esp)
 481:	e8 33 ff ff ff       	call   3b9 <putc>
  while(--i >= 0)
 486:	ff 4d f4             	decl   -0xc(%ebp)
 489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48d:	79 db                	jns    46a <printint+0x89>
}
 48f:	c9                   	leave  
 490:	c3                   	ret    

00000491 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 491:	55                   	push   %ebp
 492:	89 e5                	mov    %esp,%ebp
 494:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 497:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49e:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a1:	83 c0 04             	add    $0x4,%eax
 4a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ae:	e9 78 01 00 00       	jmp    62b <printf+0x19a>
    c = fmt[i] & 0xff;
 4b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b9:	01 d0                	add    %edx,%eax
 4bb:	8a 00                	mov    (%eax),%al
 4bd:	0f be c0             	movsbl %al,%eax
 4c0:	25 ff 00 00 00       	and    $0xff,%eax
 4c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cc:	75 2c                	jne    4fa <printf+0x69>
      if(c == '%'){
 4ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d2:	75 0c                	jne    4e0 <printf+0x4f>
        state = '%';
 4d4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4db:	e9 48 01 00 00       	jmp    628 <printf+0x197>
      } else {
        putc(fd, c);
 4e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e3:	0f be c0             	movsbl %al,%eax
 4e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	89 04 24             	mov    %eax,(%esp)
 4f0:	e8 c4 fe ff ff       	call   3b9 <putc>
 4f5:	e9 2e 01 00 00       	jmp    628 <printf+0x197>
      }
    } else if(state == '%'){
 4fa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fe:	0f 85 24 01 00 00    	jne    628 <printf+0x197>
      if(c == 'd'){
 504:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 508:	75 2d                	jne    537 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 50a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50d:	8b 00                	mov    (%eax),%eax
 50f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 516:	00 
 517:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 51e:	00 
 51f:	89 44 24 04          	mov    %eax,0x4(%esp)
 523:	8b 45 08             	mov    0x8(%ebp),%eax
 526:	89 04 24             	mov    %eax,(%esp)
 529:	e8 b3 fe ff ff       	call   3e1 <printint>
        ap++;
 52e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 532:	e9 ea 00 00 00       	jmp    621 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 537:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53b:	74 06                	je     543 <printf+0xb2>
 53d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 541:	75 2d                	jne    570 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 54f:	00 
 550:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 557:	00 
 558:	89 44 24 04          	mov    %eax,0x4(%esp)
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	89 04 24             	mov    %eax,(%esp)
 562:	e8 7a fe ff ff       	call   3e1 <printint>
        ap++;
 567:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56b:	e9 b1 00 00 00       	jmp    621 <printf+0x190>
      } else if(c == 's'){
 570:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 574:	75 43                	jne    5b9 <printf+0x128>
        s = (char*)*ap;
 576:	8b 45 e8             	mov    -0x18(%ebp),%eax
 579:	8b 00                	mov    (%eax),%eax
 57b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 582:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 586:	75 25                	jne    5ad <printf+0x11c>
          s = "(null)";
 588:	c7 45 f4 62 08 00 00 	movl   $0x862,-0xc(%ebp)
        while(*s != 0){
 58f:	eb 1c                	jmp    5ad <printf+0x11c>
          putc(fd, *s);
 591:	8b 45 f4             	mov    -0xc(%ebp),%eax
 594:	8a 00                	mov    (%eax),%al
 596:	0f be c0             	movsbl %al,%eax
 599:	89 44 24 04          	mov    %eax,0x4(%esp)
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	89 04 24             	mov    %eax,(%esp)
 5a3:	e8 11 fe ff ff       	call   3b9 <putc>
          s++;
 5a8:	ff 45 f4             	incl   -0xc(%ebp)
 5ab:	eb 01                	jmp    5ae <printf+0x11d>
        while(*s != 0){
 5ad:	90                   	nop
 5ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b1:	8a 00                	mov    (%eax),%al
 5b3:	84 c0                	test   %al,%al
 5b5:	75 da                	jne    591 <printf+0x100>
 5b7:	eb 68                	jmp    621 <printf+0x190>
        }
      } else if(c == 'c'){
 5b9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5bd:	75 1d                	jne    5dc <printf+0x14b>
        putc(fd, *ap);
 5bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	89 04 24             	mov    %eax,(%esp)
 5d1:	e8 e3 fd ff ff       	call   3b9 <putc>
        ap++;
 5d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5da:	eb 45                	jmp    621 <printf+0x190>
      } else if(c == '%'){
 5dc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e0:	75 17                	jne    5f9 <printf+0x168>
        putc(fd, c);
 5e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e5:	0f be c0             	movsbl %al,%eax
 5e8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ec:	8b 45 08             	mov    0x8(%ebp),%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 c2 fd ff ff       	call   3b9 <putc>
 5f7:	eb 28                	jmp    621 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 600:	00 
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	89 04 24             	mov    %eax,(%esp)
 607:	e8 ad fd ff ff       	call   3b9 <putc>
        putc(fd, c);
 60c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	89 44 24 04          	mov    %eax,0x4(%esp)
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	89 04 24             	mov    %eax,(%esp)
 61c:	e8 98 fd ff ff       	call   3b9 <putc>
      }
      state = 0;
 621:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 628:	ff 45 f0             	incl   -0x10(%ebp)
 62b:	8b 55 0c             	mov    0xc(%ebp),%edx
 62e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 631:	01 d0                	add    %edx,%eax
 633:	8a 00                	mov    (%eax),%al
 635:	84 c0                	test   %al,%al
 637:	0f 85 76 fe ff ff    	jne    4b3 <printf+0x22>
    }
  }
}
 63d:	c9                   	leave  
 63e:	c3                   	ret    

0000063f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63f:	55                   	push   %ebp
 640:	89 e5                	mov    %esp,%ebp
 642:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	83 e8 08             	sub    $0x8,%eax
 64b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64e:	a1 c4 0a 00 00       	mov    0xac4,%eax
 653:	89 45 fc             	mov    %eax,-0x4(%ebp)
 656:	eb 24                	jmp    67c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	77 12                	ja     674 <free+0x35>
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 668:	77 24                	ja     68e <free+0x4f>
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 672:	77 1a                	ja     68e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
 677:	8b 00                	mov    (%eax),%eax
 679:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	76 d4                	jbe    658 <free+0x19>
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68c:	76 ca                	jbe    658 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 68e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 691:	8b 40 04             	mov    0x4(%eax),%eax
 694:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	01 c2                	add    %eax,%edx
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 00                	mov    (%eax),%eax
 6a5:	39 c2                	cmp    %eax,%edx
 6a7:	75 24                	jne    6cd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	8b 40 04             	mov    0x4(%eax),%eax
 6b7:	01 c2                	add    %eax,%edx
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	8b 00                	mov    (%eax),%eax
 6c4:	8b 10                	mov    (%eax),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	89 10                	mov    %edx,(%eax)
 6cb:	eb 0a                	jmp    6d7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 10                	mov    (%eax),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	01 d0                	add    %edx,%eax
 6e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ec:	75 20                	jne    70e <free+0xcf>
    p->s.size += bp->s.size;
 6ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f1:	8b 50 04             	mov    0x4(%eax),%edx
 6f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f7:	8b 40 04             	mov    0x4(%eax),%eax
 6fa:	01 c2                	add    %eax,%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	8b 10                	mov    (%eax),%edx
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	89 10                	mov    %edx,(%eax)
 70c:	eb 08                	jmp    716 <free+0xd7>
  } else
    p->s.ptr = bp;
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 55 f8             	mov    -0x8(%ebp),%edx
 714:	89 10                	mov    %edx,(%eax)
  freep = p;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	a3 c4 0a 00 00       	mov    %eax,0xac4
}
 71e:	c9                   	leave  
 71f:	c3                   	ret    

00000720 <morecore>:

static Header*
morecore(uint nu)
{
 720:	55                   	push   %ebp
 721:	89 e5                	mov    %esp,%ebp
 723:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 726:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72d:	77 07                	ja     736 <morecore+0x16>
    nu = 4096;
 72f:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	c1 e0 03             	shl    $0x3,%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 05 fc ff ff       	call   349 <sbrk>
 744:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 747:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74b:	75 07                	jne    754 <morecore+0x34>
    return 0;
 74d:	b8 00 00 00 00       	mov    $0x0,%eax
 752:	eb 22                	jmp    776 <morecore+0x56>
  hp = (Header*)p;
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75d:	8b 55 08             	mov    0x8(%ebp),%edx
 760:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 763:	8b 45 f0             	mov    -0x10(%ebp),%eax
 766:	83 c0 08             	add    $0x8,%eax
 769:	89 04 24             	mov    %eax,(%esp)
 76c:	e8 ce fe ff ff       	call   63f <free>
  return freep;
 771:	a1 c4 0a 00 00       	mov    0xac4,%eax
}
 776:	c9                   	leave  
 777:	c3                   	ret    

00000778 <malloc>:

void*
malloc(uint nbytes)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77e:	8b 45 08             	mov    0x8(%ebp),%eax
 781:	83 c0 07             	add    $0x7,%eax
 784:	c1 e8 03             	shr    $0x3,%eax
 787:	40                   	inc    %eax
 788:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78b:	a1 c4 0a 00 00       	mov    0xac4,%eax
 790:	89 45 f0             	mov    %eax,-0x10(%ebp)
 793:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 797:	75 23                	jne    7bc <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 799:	c7 45 f0 bc 0a 00 00 	movl   $0xabc,-0x10(%ebp)
 7a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a3:	a3 c4 0a 00 00       	mov    %eax,0xac4
 7a8:	a1 c4 0a 00 00       	mov    0xac4,%eax
 7ad:	a3 bc 0a 00 00       	mov    %eax,0xabc
    base.s.size = 0;
 7b2:	c7 05 c0 0a 00 00 00 	movl   $0x0,0xac0
 7b9:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	8b 00                	mov    (%eax),%eax
 7c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cd:	72 4d                	jb     81c <malloc+0xa4>
      if(p->s.size == nunits)
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 40 04             	mov    0x4(%eax),%eax
 7d5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d8:	75 0c                	jne    7e6 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	89 10                	mov    %edx,(%eax)
 7e4:	eb 26                	jmp    80c <malloc+0x94>
      else {
        p->s.size -= nunits;
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	89 c2                	mov    %eax,%edx
 7ee:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	c1 e0 03             	shl    $0x3,%eax
 800:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	8b 55 ec             	mov    -0x14(%ebp),%edx
 809:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	a3 c4 0a 00 00       	mov    %eax,0xac4
      return (void*)(p + 1);
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	83 c0 08             	add    $0x8,%eax
 81a:	eb 38                	jmp    854 <malloc+0xdc>
    }
    if(p == freep)
 81c:	a1 c4 0a 00 00       	mov    0xac4,%eax
 821:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 824:	75 1b                	jne    841 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 826:	8b 45 ec             	mov    -0x14(%ebp),%eax
 829:	89 04 24             	mov    %eax,(%esp)
 82c:	e8 ef fe ff ff       	call   720 <morecore>
 831:	89 45 f4             	mov    %eax,-0xc(%ebp)
 834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 838:	75 07                	jne    841 <malloc+0xc9>
        return 0;
 83a:	b8 00 00 00 00       	mov    $0x0,%eax
 83f:	eb 13                	jmp    854 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 841:	8b 45 f4             	mov    -0xc(%ebp),%eax
 844:	89 45 f0             	mov    %eax,-0x10(%ebp)
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 84f:	e9 70 ff ff ff       	jmp    7c4 <malloc+0x4c>
}
 854:	c9                   	leave  
 855:	c3                   	ret    
