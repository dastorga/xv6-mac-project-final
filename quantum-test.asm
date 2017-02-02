
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
  55:	c7 44 24 04 0e 08 00 	movl   $0x80e,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 e0 03 00 00       	call   449 <printf>
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

00000371 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 371:	55                   	push   %ebp
 372:	89 e5                	mov    %esp,%ebp
 374:	83 ec 28             	sub    $0x28,%esp
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 384:	00 
 385:	8d 45 f4             	lea    -0xc(%ebp),%eax
 388:	89 44 24 04          	mov    %eax,0x4(%esp)
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	89 04 24             	mov    %eax,(%esp)
 392:	e8 4a ff ff ff       	call   2e1 <write>
}
 397:	c9                   	leave  
 398:	c3                   	ret    

00000399 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3aa:	74 17                	je     3c3 <printint+0x2a>
 3ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b0:	79 11                	jns    3c3 <printint+0x2a>
    neg = 1;
 3b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	f7 d8                	neg    %eax
 3be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c1:	eb 06                	jmp    3c9 <printint+0x30>
  } else {
    x = xx;
 3c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d6:	ba 00 00 00 00       	mov    $0x0,%edx
 3db:	f7 f1                	div    %ecx
 3dd:	89 d0                	mov    %edx,%eax
 3df:	8a 80 60 0a 00 00    	mov    0xa60(%eax),%al
 3e5:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3eb:	01 ca                	add    %ecx,%edx
 3ed:	88 02                	mov    %al,(%edx)
 3ef:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3f2:	8b 55 10             	mov    0x10(%ebp),%edx
 3f5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fb:	ba 00 00 00 00       	mov    $0x0,%edx
 400:	f7 75 d4             	divl   -0x2c(%ebp)
 403:	89 45 ec             	mov    %eax,-0x14(%ebp)
 406:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40a:	75 c4                	jne    3d0 <printint+0x37>
  if(neg)
 40c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 410:	74 2c                	je     43e <printint+0xa5>
    buf[i++] = '-';
 412:	8d 55 dc             	lea    -0x24(%ebp),%edx
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	01 d0                	add    %edx,%eax
 41a:	c6 00 2d             	movb   $0x2d,(%eax)
 41d:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 420:	eb 1c                	jmp    43e <printint+0xa5>
    putc(fd, buf[i]);
 422:	8d 55 dc             	lea    -0x24(%ebp),%edx
 425:	8b 45 f4             	mov    -0xc(%ebp),%eax
 428:	01 d0                	add    %edx,%eax
 42a:	8a 00                	mov    (%eax),%al
 42c:	0f be c0             	movsbl %al,%eax
 42f:	89 44 24 04          	mov    %eax,0x4(%esp)
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	89 04 24             	mov    %eax,(%esp)
 439:	e8 33 ff ff ff       	call   371 <putc>
  while(--i >= 0)
 43e:	ff 4d f4             	decl   -0xc(%ebp)
 441:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 445:	79 db                	jns    422 <printint+0x89>
}
 447:	c9                   	leave  
 448:	c3                   	ret    

00000449 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 456:	8d 45 0c             	lea    0xc(%ebp),%eax
 459:	83 c0 04             	add    $0x4,%eax
 45c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 466:	e9 78 01 00 00       	jmp    5e3 <printf+0x19a>
    c = fmt[i] & 0xff;
 46b:	8b 55 0c             	mov    0xc(%ebp),%edx
 46e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 471:	01 d0                	add    %edx,%eax
 473:	8a 00                	mov    (%eax),%al
 475:	0f be c0             	movsbl %al,%eax
 478:	25 ff 00 00 00       	and    $0xff,%eax
 47d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 480:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 484:	75 2c                	jne    4b2 <printf+0x69>
      if(c == '%'){
 486:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48a:	75 0c                	jne    498 <printf+0x4f>
        state = '%';
 48c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 493:	e9 48 01 00 00       	jmp    5e0 <printf+0x197>
      } else {
        putc(fd, c);
 498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49b:	0f be c0             	movsbl %al,%eax
 49e:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a2:	8b 45 08             	mov    0x8(%ebp),%eax
 4a5:	89 04 24             	mov    %eax,(%esp)
 4a8:	e8 c4 fe ff ff       	call   371 <putc>
 4ad:	e9 2e 01 00 00       	jmp    5e0 <printf+0x197>
      }
    } else if(state == '%'){
 4b2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b6:	0f 85 24 01 00 00    	jne    5e0 <printf+0x197>
      if(c == 'd'){
 4bc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c0:	75 2d                	jne    4ef <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c5:	8b 00                	mov    (%eax),%eax
 4c7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ce:	00 
 4cf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d6:	00 
 4d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	89 04 24             	mov    %eax,(%esp)
 4e1:	e8 b3 fe ff ff       	call   399 <printint>
        ap++;
 4e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ea:	e9 ea 00 00 00       	jmp    5d9 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f3:	74 06                	je     4fb <printf+0xb2>
 4f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f9:	75 2d                	jne    528 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fe:	8b 00                	mov    (%eax),%eax
 500:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 507:	00 
 508:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50f:	00 
 510:	89 44 24 04          	mov    %eax,0x4(%esp)
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	89 04 24             	mov    %eax,(%esp)
 51a:	e8 7a fe ff ff       	call   399 <printint>
        ap++;
 51f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 523:	e9 b1 00 00 00       	jmp    5d9 <printf+0x190>
      } else if(c == 's'){
 528:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 52c:	75 43                	jne    571 <printf+0x128>
        s = (char*)*ap;
 52e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 531:	8b 00                	mov    (%eax),%eax
 533:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 536:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 53a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53e:	75 25                	jne    565 <printf+0x11c>
          s = "(null)";
 540:	c7 45 f4 1a 08 00 00 	movl   $0x81a,-0xc(%ebp)
        while(*s != 0){
 547:	eb 1c                	jmp    565 <printf+0x11c>
          putc(fd, *s);
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	8a 00                	mov    (%eax),%al
 54e:	0f be c0             	movsbl %al,%eax
 551:	89 44 24 04          	mov    %eax,0x4(%esp)
 555:	8b 45 08             	mov    0x8(%ebp),%eax
 558:	89 04 24             	mov    %eax,(%esp)
 55b:	e8 11 fe ff ff       	call   371 <putc>
          s++;
 560:	ff 45 f4             	incl   -0xc(%ebp)
 563:	eb 01                	jmp    566 <printf+0x11d>
        while(*s != 0){
 565:	90                   	nop
 566:	8b 45 f4             	mov    -0xc(%ebp),%eax
 569:	8a 00                	mov    (%eax),%al
 56b:	84 c0                	test   %al,%al
 56d:	75 da                	jne    549 <printf+0x100>
 56f:	eb 68                	jmp    5d9 <printf+0x190>
        }
      } else if(c == 'c'){
 571:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 575:	75 1d                	jne    594 <printf+0x14b>
        putc(fd, *ap);
 577:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	0f be c0             	movsbl %al,%eax
 57f:	89 44 24 04          	mov    %eax,0x4(%esp)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	89 04 24             	mov    %eax,(%esp)
 589:	e8 e3 fd ff ff       	call   371 <putc>
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 592:	eb 45                	jmp    5d9 <printf+0x190>
      } else if(c == '%'){
 594:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 598:	75 17                	jne    5b1 <printf+0x168>
        putc(fd, c);
 59a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59d:	0f be c0             	movsbl %al,%eax
 5a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a4:	8b 45 08             	mov    0x8(%ebp),%eax
 5a7:	89 04 24             	mov    %eax,(%esp)
 5aa:	e8 c2 fd ff ff       	call   371 <putc>
 5af:	eb 28                	jmp    5d9 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b1:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b8:	00 
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 ad fd ff ff       	call   371 <putc>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 98 fd ff ff       	call   371 <putc>
      }
      state = 0;
 5d9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5e0:	ff 45 f0             	incl   -0x10(%ebp)
 5e3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e9:	01 d0                	add    %edx,%eax
 5eb:	8a 00                	mov    (%eax),%al
 5ed:	84 c0                	test   %al,%al
 5ef:	0f 85 76 fe ff ff    	jne    46b <printf+0x22>
    }
  }
}
 5f5:	c9                   	leave  
 5f6:	c3                   	ret    

000005f7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f7:	55                   	push   %ebp
 5f8:	89 e5                	mov    %esp,%ebp
 5fa:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	83 e8 08             	sub    $0x8,%eax
 603:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 606:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 60b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60e:	eb 24                	jmp    634 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 00                	mov    (%eax),%eax
 615:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 618:	77 12                	ja     62c <free+0x35>
 61a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 620:	77 24                	ja     646 <free+0x4f>
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62a:	77 1a                	ja     646 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	89 45 fc             	mov    %eax,-0x4(%ebp)
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	76 d4                	jbe    610 <free+0x19>
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 644:	76 ca                	jbe    610 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	8b 40 04             	mov    0x4(%eax),%eax
 64c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	01 c2                	add    %eax,%edx
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	39 c2                	cmp    %eax,%edx
 65f:	75 24                	jne    685 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	8b 50 04             	mov    0x4(%eax),%edx
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	8b 40 04             	mov    0x4(%eax),%eax
 66f:	01 c2                	add    %eax,%edx
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	8b 10                	mov    (%eax),%edx
 67e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 681:	89 10                	mov    %edx,(%eax)
 683:	eb 0a                	jmp    68f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 10                	mov    (%eax),%edx
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	01 d0                	add    %edx,%eax
 6a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a4:	75 20                	jne    6c6 <free+0xcf>
    p->s.size += bp->s.size;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 50 04             	mov    0x4(%eax),%edx
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 40 04             	mov    0x4(%eax),%eax
 6b2:	01 c2                	add    %eax,%edx
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	89 10                	mov    %edx,(%eax)
 6c4:	eb 08                	jmp    6ce <free+0xd7>
  } else
    p->s.ptr = bp;
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cc:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6d6:	c9                   	leave  
 6d7:	c3                   	ret    

000006d8 <morecore>:

static Header*
morecore(uint nu)
{
 6d8:	55                   	push   %ebp
 6d9:	89 e5                	mov    %esp,%ebp
 6db:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6de:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e5:	77 07                	ja     6ee <morecore+0x16>
    nu = 4096;
 6e7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	c1 e0 03             	shl    $0x3,%eax
 6f4:	89 04 24             	mov    %eax,(%esp)
 6f7:	e8 4d fc ff ff       	call   349 <sbrk>
 6fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ff:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 703:	75 07                	jne    70c <morecore+0x34>
    return 0;
 705:	b8 00 00 00 00       	mov    $0x0,%eax
 70a:	eb 22                	jmp    72e <morecore+0x56>
  hp = (Header*)p;
 70c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	8b 55 08             	mov    0x8(%ebp),%edx
 718:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71e:	83 c0 08             	add    $0x8,%eax
 721:	89 04 24             	mov    %eax,(%esp)
 724:	e8 ce fe ff ff       	call   5f7 <free>
  return freep;
 729:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 72e:	c9                   	leave  
 72f:	c3                   	ret    

00000730 <malloc>:

void*
malloc(uint nbytes)
{
 730:	55                   	push   %ebp
 731:	89 e5                	mov    %esp,%ebp
 733:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 736:	8b 45 08             	mov    0x8(%ebp),%eax
 739:	83 c0 07             	add    $0x7,%eax
 73c:	c1 e8 03             	shr    $0x3,%eax
 73f:	40                   	inc    %eax
 740:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 743:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 748:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74f:	75 23                	jne    774 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 751:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 760:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 765:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 76a:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 771:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 774:	8b 45 f0             	mov    -0x10(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 785:	72 4d                	jb     7d4 <malloc+0xa4>
      if(p->s.size == nunits)
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 790:	75 0c                	jne    79e <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	8b 10                	mov    (%eax),%edx
 797:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79a:	89 10                	mov    %edx,(%eax)
 79c:	eb 26                	jmp    7c4 <malloc+0x94>
      else {
        p->s.size -= nunits;
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	8b 40 04             	mov    0x4(%eax),%eax
 7a4:	89 c2                	mov    %eax,%edx
 7a6:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	c1 e0 03             	shl    $0x3,%eax
 7b8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	83 c0 08             	add    $0x8,%eax
 7d2:	eb 38                	jmp    80c <malloc+0xdc>
    }
    if(p == freep)
 7d4:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7d9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7dc:	75 1b                	jne    7f9 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e1:	89 04 24             	mov    %eax,(%esp)
 7e4:	e8 ef fe ff ff       	call   6d8 <morecore>
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <malloc+0xc9>
        return 0;
 7f2:	b8 00 00 00 00       	mov    $0x0,%eax
 7f7:	eb 13                	jmp    80c <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 807:	e9 70 ff ff ff       	jmp    77c <malloc+0x4c>
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    
