
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

0000032c <semget>:
 32c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <semfree>:
 334:	b8 1b 00 00 00       	mov    $0x1b,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <semdown>:
 33c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <semup>:
 344:	b8 1d 00 00 00       	mov    $0x1d,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <shm_create>:
 34c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <shm_close>:
 354:	b8 1f 00 00 00       	mov    $0x1f,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <shm_get>:
 35c:	b8 20 00 00 00       	mov    $0x20,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 28             	sub    $0x28,%esp
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 370:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 377:	00 
 378:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37b:	89 44 24 04          	mov    %eax,0x4(%esp)
 37f:	8b 45 08             	mov    0x8(%ebp),%eax
 382:	89 04 24             	mov    %eax,(%esp)
 385:	e8 02 ff ff ff       	call   28c <write>
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
 38f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 399:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39d:	74 17                	je     3b6 <printint+0x2a>
 39f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a3:	79 11                	jns    3b6 <printint+0x2a>
    neg = 1;
 3a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	f7 d8                	neg    %eax
 3b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b4:	eb 06                	jmp    3bc <printint+0x30>
  } else {
    x = xx;
 3b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ce:	f7 f1                	div    %ecx
 3d0:	89 d0                	mov    %edx,%eax
 3d2:	8a 80 44 0a 00 00    	mov    0xa44(%eax),%al
 3d8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3db:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3de:	01 ca                	add    %ecx,%edx
 3e0:	88 02                	mov    %al,(%edx)
 3e2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3e5:	8b 55 10             	mov    0x10(%ebp),%edx
 3e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ee:	ba 00 00 00 00       	mov    $0x0,%edx
 3f3:	f7 75 d4             	divl   -0x2c(%ebp)
 3f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fd:	75 c4                	jne    3c3 <printint+0x37>
  if(neg)
 3ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 403:	74 2c                	je     431 <printint+0xa5>
    buf[i++] = '-';
 405:	8d 55 dc             	lea    -0x24(%ebp),%edx
 408:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40b:	01 d0                	add    %edx,%eax
 40d:	c6 00 2d             	movb   $0x2d,(%eax)
 410:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 413:	eb 1c                	jmp    431 <printint+0xa5>
    putc(fd, buf[i]);
 415:	8d 55 dc             	lea    -0x24(%ebp),%edx
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	01 d0                	add    %edx,%eax
 41d:	8a 00                	mov    (%eax),%al
 41f:	0f be c0             	movsbl %al,%eax
 422:	89 44 24 04          	mov    %eax,0x4(%esp)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	89 04 24             	mov    %eax,(%esp)
 42c:	e8 33 ff ff ff       	call   364 <putc>
  while(--i >= 0)
 431:	ff 4d f4             	decl   -0xc(%ebp)
 434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 438:	79 db                	jns    415 <printint+0x89>
}
 43a:	c9                   	leave  
 43b:	c3                   	ret    

0000043c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 442:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 449:	8d 45 0c             	lea    0xc(%ebp),%eax
 44c:	83 c0 04             	add    $0x4,%eax
 44f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 452:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 459:	e9 78 01 00 00       	jmp    5d6 <printf+0x19a>
    c = fmt[i] & 0xff;
 45e:	8b 55 0c             	mov    0xc(%ebp),%edx
 461:	8b 45 f0             	mov    -0x10(%ebp),%eax
 464:	01 d0                	add    %edx,%eax
 466:	8a 00                	mov    (%eax),%al
 468:	0f be c0             	movsbl %al,%eax
 46b:	25 ff 00 00 00       	and    $0xff,%eax
 470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 477:	75 2c                	jne    4a5 <printf+0x69>
      if(c == '%'){
 479:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47d:	75 0c                	jne    48b <printf+0x4f>
        state = '%';
 47f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 486:	e9 48 01 00 00       	jmp    5d3 <printf+0x197>
      } else {
        putc(fd, c);
 48b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48e:	0f be c0             	movsbl %al,%eax
 491:	89 44 24 04          	mov    %eax,0x4(%esp)
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 c4 fe ff ff       	call   364 <putc>
 4a0:	e9 2e 01 00 00       	jmp    5d3 <printf+0x197>
      }
    } else if(state == '%'){
 4a5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a9:	0f 85 24 01 00 00    	jne    5d3 <printf+0x197>
      if(c == 'd'){
 4af:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b3:	75 2d                	jne    4e2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b8:	8b 00                	mov    (%eax),%eax
 4ba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4c1:	00 
 4c2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c9:	00 
 4ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	89 04 24             	mov    %eax,(%esp)
 4d4:	e8 b3 fe ff ff       	call   38c <printint>
        ap++;
 4d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4dd:	e9 ea 00 00 00       	jmp    5cc <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4e2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e6:	74 06                	je     4ee <printf+0xb2>
 4e8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ec:	75 2d                	jne    51b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f1:	8b 00                	mov    (%eax),%eax
 4f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4fa:	00 
 4fb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 502:	00 
 503:	89 44 24 04          	mov    %eax,0x4(%esp)
 507:	8b 45 08             	mov    0x8(%ebp),%eax
 50a:	89 04 24             	mov    %eax,(%esp)
 50d:	e8 7a fe ff ff       	call   38c <printint>
        ap++;
 512:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 516:	e9 b1 00 00 00       	jmp    5cc <printf+0x190>
      } else if(c == 's'){
 51b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51f:	75 43                	jne    564 <printf+0x128>
        s = (char*)*ap;
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 529:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 531:	75 25                	jne    558 <printf+0x11c>
          s = "(null)";
 533:	c7 45 f4 01 08 00 00 	movl   $0x801,-0xc(%ebp)
        while(*s != 0){
 53a:	eb 1c                	jmp    558 <printf+0x11c>
          putc(fd, *s);
 53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53f:	8a 00                	mov    (%eax),%al
 541:	0f be c0             	movsbl %al,%eax
 544:	89 44 24 04          	mov    %eax,0x4(%esp)
 548:	8b 45 08             	mov    0x8(%ebp),%eax
 54b:	89 04 24             	mov    %eax,(%esp)
 54e:	e8 11 fe ff ff       	call   364 <putc>
          s++;
 553:	ff 45 f4             	incl   -0xc(%ebp)
 556:	eb 01                	jmp    559 <printf+0x11d>
        while(*s != 0){
 558:	90                   	nop
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	8a 00                	mov    (%eax),%al
 55e:	84 c0                	test   %al,%al
 560:	75 da                	jne    53c <printf+0x100>
 562:	eb 68                	jmp    5cc <printf+0x190>
        }
      } else if(c == 'c'){
 564:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 568:	75 1d                	jne    587 <printf+0x14b>
        putc(fd, *ap);
 56a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 e3 fd ff ff       	call   364 <putc>
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 585:	eb 45                	jmp    5cc <printf+0x190>
      } else if(c == '%'){
 587:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58b:	75 17                	jne    5a4 <printf+0x168>
        putc(fd, c);
 58d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	89 44 24 04          	mov    %eax,0x4(%esp)
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	89 04 24             	mov    %eax,(%esp)
 59d:	e8 c2 fd ff ff       	call   364 <putc>
 5a2:	eb 28                	jmp    5cc <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ab:	00 
 5ac:	8b 45 08             	mov    0x8(%ebp),%eax
 5af:	89 04 24             	mov    %eax,(%esp)
 5b2:	e8 ad fd ff ff       	call   364 <putc>
        putc(fd, c);
 5b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ba:	0f be c0             	movsbl %al,%eax
 5bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c1:	8b 45 08             	mov    0x8(%ebp),%eax
 5c4:	89 04 24             	mov    %eax,(%esp)
 5c7:	e8 98 fd ff ff       	call   364 <putc>
      }
      state = 0;
 5cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5d3:	ff 45 f0             	incl   -0x10(%ebp)
 5d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5dc:	01 d0                	add    %edx,%eax
 5de:	8a 00                	mov    (%eax),%al
 5e0:	84 c0                	test   %al,%al
 5e2:	0f 85 76 fe ff ff    	jne    45e <printf+0x22>
    }
  }
}
 5e8:	c9                   	leave  
 5e9:	c3                   	ret    

000005ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ea:	55                   	push   %ebp
 5eb:	89 e5                	mov    %esp,%ebp
 5ed:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	83 e8 08             	sub    $0x8,%eax
 5f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f9:	a1 60 0a 00 00       	mov    0xa60,%eax
 5fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 601:	eb 24                	jmp    627 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60b:	77 12                	ja     61f <free+0x35>
 60d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 610:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 613:	77 24                	ja     639 <free+0x4f>
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61d:	77 1a                	ja     639 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	89 45 fc             	mov    %eax,-0x4(%ebp)
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	76 d4                	jbe    603 <free+0x19>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	76 ca                	jbe    603 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	8b 40 04             	mov    0x4(%eax),%eax
 63f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	01 c2                	add    %eax,%edx
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	39 c2                	cmp    %eax,%edx
 652:	75 24                	jne    678 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	8b 50 04             	mov    0x4(%eax),%edx
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	8b 40 04             	mov    0x4(%eax),%eax
 662:	01 c2                	add    %eax,%edx
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	8b 10                	mov    (%eax),%edx
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	89 10                	mov    %edx,(%eax)
 676:	eb 0a                	jmp    682 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 10                	mov    (%eax),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 40 04             	mov    0x4(%eax),%eax
 688:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	01 d0                	add    %edx,%eax
 694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 697:	75 20                	jne    6b9 <free+0xcf>
    p->s.size += bp->s.size;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 50 04             	mov    0x4(%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	01 c2                	add    %eax,%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	8b 10                	mov    (%eax),%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	89 10                	mov    %edx,(%eax)
 6b7:	eb 08                	jmp    6c1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bf:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <morecore>:

static Header*
morecore(uint nu)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d8:	77 07                	ja     6e1 <morecore+0x16>
    nu = 4096;
 6da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	c1 e0 03             	shl    $0x3,%eax
 6e7:	89 04 24             	mov    %eax,(%esp)
 6ea:	e8 05 fc ff ff       	call   2f4 <sbrk>
 6ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f6:	75 07                	jne    6ff <morecore+0x34>
    return 0;
 6f8:	b8 00 00 00 00       	mov    $0x0,%eax
 6fd:	eb 22                	jmp    721 <morecore+0x56>
  hp = (Header*)p;
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 705:	8b 45 f0             	mov    -0x10(%ebp),%eax
 708:	8b 55 08             	mov    0x8(%ebp),%edx
 70b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 711:	83 c0 08             	add    $0x8,%eax
 714:	89 04 24             	mov    %eax,(%esp)
 717:	e8 ce fe ff ff       	call   5ea <free>
  return freep;
 71c:	a1 60 0a 00 00       	mov    0xa60,%eax
}
 721:	c9                   	leave  
 722:	c3                   	ret    

00000723 <malloc>:

void*
malloc(uint nbytes)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 729:	8b 45 08             	mov    0x8(%ebp),%eax
 72c:	83 c0 07             	add    $0x7,%eax
 72f:	c1 e8 03             	shr    $0x3,%eax
 732:	40                   	inc    %eax
 733:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 736:	a1 60 0a 00 00       	mov    0xa60,%eax
 73b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 742:	75 23                	jne    767 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 744:	c7 45 f0 58 0a 00 00 	movl   $0xa58,-0x10(%ebp)
 74b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74e:	a3 60 0a 00 00       	mov    %eax,0xa60
 753:	a1 60 0a 00 00       	mov    0xa60,%eax
 758:	a3 58 0a 00 00       	mov    %eax,0xa58
    base.s.size = 0;
 75d:	c7 05 5c 0a 00 00 00 	movl   $0x0,0xa5c
 764:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 778:	72 4d                	jb     7c7 <malloc+0xa4>
      if(p->s.size == nunits)
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 783:	75 0c                	jne    791 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 10                	mov    (%eax),%edx
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	89 10                	mov    %edx,(%eax)
 78f:	eb 26                	jmp    7b7 <malloc+0x94>
      else {
        p->s.size -= nunits;
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 40 04             	mov    0x4(%eax),%eax
 797:	89 c2                	mov    %eax,%edx
 799:	2b 55 ec             	sub    -0x14(%ebp),%edx
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	c1 e0 03             	shl    $0x3,%eax
 7ab:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	a3 60 0a 00 00       	mov    %eax,0xa60
      return (void*)(p + 1);
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	83 c0 08             	add    $0x8,%eax
 7c5:	eb 38                	jmp    7ff <malloc+0xdc>
    }
    if(p == freep)
 7c7:	a1 60 0a 00 00       	mov    0xa60,%eax
 7cc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7cf:	75 1b                	jne    7ec <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d4:	89 04 24             	mov    %eax,(%esp)
 7d7:	e8 ef fe ff ff       	call   6cb <morecore>
 7dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e3:	75 07                	jne    7ec <malloc+0xc9>
        return 0;
 7e5:	b8 00 00 00 00       	mov    $0x0,%eax
 7ea:	eb 13                	jmp    7ff <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8b 00                	mov    (%eax),%eax
 7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7fa:	e9 70 ff ff ff       	jmp    76f <malloc+0x4c>
}
 7ff:	c9                   	leave  
 800:	c3                   	ret    
