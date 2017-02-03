
_isatty-test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
	// stdin
	if (isatty(0))
   9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10:	e8 24 03 00 00       	call   339 <isatty>
  15:	85 c0                	test   %eax,%eax
  17:	74 16                	je     2f <main+0x2f>
		printf(1, "stdin is a tty\n");
  19:	c7 44 24 04 ee 07 00 	movl   $0x7ee,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 fc 03 00 00       	call   429 <printf>
  2d:	eb 14                	jmp    43 <main+0x43>
	else
		printf(1, "stdin is not a tty\n");
  2f:	c7 44 24 04 fe 07 00 	movl   $0x7fe,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 e6 03 00 00       	call   429 <printf>

	exit();
  43:	e8 49 02 00 00       	call   291 <exit>

00000048 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	57                   	push   %edi
  4c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  4d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  50:	8b 55 10             	mov    0x10(%ebp),%edx
  53:	8b 45 0c             	mov    0xc(%ebp),%eax
  56:	89 cb                	mov    %ecx,%ebx
  58:	89 df                	mov    %ebx,%edi
  5a:	89 d1                	mov    %edx,%ecx
  5c:	fc                   	cld    
  5d:	f3 aa                	rep stos %al,%es:(%edi)
  5f:	89 ca                	mov    %ecx,%edx
  61:	89 fb                	mov    %edi,%ebx
  63:	89 5d 08             	mov    %ebx,0x8(%ebp)
  66:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  69:	5b                   	pop    %ebx
  6a:	5f                   	pop    %edi
  6b:	5d                   	pop    %ebp
  6c:	c3                   	ret    

0000006d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  6d:	55                   	push   %ebp
  6e:	89 e5                	mov    %esp,%ebp
  70:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  73:	8b 45 08             	mov    0x8(%ebp),%eax
  76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  79:	90                   	nop
  7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  7d:	8a 10                	mov    (%eax),%dl
  7f:	8b 45 08             	mov    0x8(%ebp),%eax
  82:	88 10                	mov    %dl,(%eax)
  84:	8b 45 08             	mov    0x8(%ebp),%eax
  87:	8a 00                	mov    (%eax),%al
  89:	84 c0                	test   %al,%al
  8b:	0f 95 c0             	setne  %al
  8e:	ff 45 08             	incl   0x8(%ebp)
  91:	ff 45 0c             	incl   0xc(%ebp)
  94:	84 c0                	test   %al,%al
  96:	75 e2                	jne    7a <strcpy+0xd>
    ;
  return os;
  98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  9b:	c9                   	leave  
  9c:	c3                   	ret    

0000009d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  a0:	eb 06                	jmp    a8 <strcmp+0xb>
    p++, q++;
  a2:	ff 45 08             	incl   0x8(%ebp)
  a5:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	8a 00                	mov    (%eax),%al
  ad:	84 c0                	test   %al,%al
  af:	74 0e                	je     bf <strcmp+0x22>
  b1:	8b 45 08             	mov    0x8(%ebp),%eax
  b4:	8a 10                	mov    (%eax),%dl
  b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  b9:	8a 00                	mov    (%eax),%al
  bb:	38 c2                	cmp    %al,%dl
  bd:	74 e3                	je     a2 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	8a 00                	mov    (%eax),%al
  c4:	0f b6 d0             	movzbl %al,%edx
  c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ca:	8a 00                	mov    (%eax),%al
  cc:	0f b6 c0             	movzbl %al,%eax
  cf:	89 d1                	mov    %edx,%ecx
  d1:	29 c1                	sub    %eax,%ecx
  d3:	89 c8                	mov    %ecx,%eax
}
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    

000000d7 <strlen>:

uint
strlen(char *s)
{
  d7:	55                   	push   %ebp
  d8:	89 e5                	mov    %esp,%ebp
  da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  e4:	eb 03                	jmp    e9 <strlen+0x12>
  e6:	ff 45 fc             	incl   -0x4(%ebp)
  e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	01 d0                	add    %edx,%eax
  f1:	8a 00                	mov    (%eax),%al
  f3:	84 c0                	test   %al,%al
  f5:	75 ef                	jne    e6 <strlen+0xf>
    ;
  return n;
  f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  fa:	c9                   	leave  
  fb:	c3                   	ret    

000000fc <memset>:

void*
memset(void *dst, int c, uint n)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 102:	8b 45 10             	mov    0x10(%ebp),%eax
 105:	89 44 24 08          	mov    %eax,0x8(%esp)
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	89 44 24 04          	mov    %eax,0x4(%esp)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	89 04 24             	mov    %eax,(%esp)
 116:	e8 2d ff ff ff       	call   48 <stosb>
  return dst;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 11e:	c9                   	leave  
 11f:	c3                   	ret    

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 04             	sub    $0x4,%esp
 126:	8b 45 0c             	mov    0xc(%ebp),%eax
 129:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 12c:	eb 12                	jmp    140 <strchr+0x20>
    if(*s == c)
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	8a 00                	mov    (%eax),%al
 133:	3a 45 fc             	cmp    -0x4(%ebp),%al
 136:	75 05                	jne    13d <strchr+0x1d>
      return (char*)s;
 138:	8b 45 08             	mov    0x8(%ebp),%eax
 13b:	eb 11                	jmp    14e <strchr+0x2e>
  for(; *s; s++)
 13d:	ff 45 08             	incl   0x8(%ebp)
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	8a 00                	mov    (%eax),%al
 145:	84 c0                	test   %al,%al
 147:	75 e5                	jne    12e <strchr+0xe>
  return 0;
 149:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14e:	c9                   	leave  
 14f:	c3                   	ret    

00000150 <gets>:

char*
gets(char *buf, int max)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15d:	eb 42                	jmp    1a1 <gets+0x51>
    cc = read(0, &c, 1);
 15f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 166:	00 
 167:	8d 45 ef             	lea    -0x11(%ebp),%eax
 16a:	89 44 24 04          	mov    %eax,0x4(%esp)
 16e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 175:	e8 2f 01 00 00       	call   2a9 <read>
 17a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 17d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 181:	7e 29                	jle    1ac <gets+0x5c>
      break;
    buf[i++] = c;
 183:	8b 55 f4             	mov    -0xc(%ebp),%edx
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	01 c2                	add    %eax,%edx
 18b:	8a 45 ef             	mov    -0x11(%ebp),%al
 18e:	88 02                	mov    %al,(%edx)
 190:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 193:	8a 45 ef             	mov    -0x11(%ebp),%al
 196:	3c 0a                	cmp    $0xa,%al
 198:	74 13                	je     1ad <gets+0x5d>
 19a:	8a 45 ef             	mov    -0x11(%ebp),%al
 19d:	3c 0d                	cmp    $0xd,%al
 19f:	74 0c                	je     1ad <gets+0x5d>
  for(i=0; i+1 < max; ){
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	40                   	inc    %eax
 1a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1a8:	7c b5                	jl     15f <gets+0xf>
 1aa:	eb 01                	jmp    1ad <gets+0x5d>
      break;
 1ac:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	01 d0                	add    %edx,%eax
 1b5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <stat>:

int
stat(char *n, struct stat *st)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ca:	00 
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	89 04 24             	mov    %eax,(%esp)
 1d1:	e8 fb 00 00 00       	call   2d1 <open>
 1d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1dd:	79 07                	jns    1e6 <stat+0x29>
    return -1;
 1df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e4:	eb 23                	jmp    209 <stat+0x4c>
  r = fstat(fd, st);
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f0:	89 04 24             	mov    %eax,(%esp)
 1f3:	e8 f1 00 00 00       	call   2e9 <fstat>
 1f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fe:	89 04 24             	mov    %eax,(%esp)
 201:	e8 b3 00 00 00       	call   2b9 <close>
  return r;
 206:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 209:	c9                   	leave  
 20a:	c3                   	ret    

0000020b <atoi>:

int
atoi(const char *s)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 218:	eb 21                	jmp    23b <atoi+0x30>
    n = n*10 + *s++ - '0';
 21a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21d:	89 d0                	mov    %edx,%eax
 21f:	c1 e0 02             	shl    $0x2,%eax
 222:	01 d0                	add    %edx,%eax
 224:	d1 e0                	shl    %eax
 226:	89 c2                	mov    %eax,%edx
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	8a 00                	mov    (%eax),%al
 22d:	0f be c0             	movsbl %al,%eax
 230:	01 d0                	add    %edx,%eax
 232:	83 e8 30             	sub    $0x30,%eax
 235:	89 45 fc             	mov    %eax,-0x4(%ebp)
 238:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	8a 00                	mov    (%eax),%al
 240:	3c 2f                	cmp    $0x2f,%al
 242:	7e 09                	jle    24d <atoi+0x42>
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	8a 00                	mov    (%eax),%al
 249:	3c 39                	cmp    $0x39,%al
 24b:	7e cd                	jle    21a <atoi+0xf>
  return n;
 24d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 25e:	8b 45 0c             	mov    0xc(%ebp),%eax
 261:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 264:	eb 10                	jmp    276 <memmove+0x24>
    *dst++ = *src++;
 266:	8b 45 f8             	mov    -0x8(%ebp),%eax
 269:	8a 10                	mov    (%eax),%dl
 26b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26e:	88 10                	mov    %dl,(%eax)
 270:	ff 45 fc             	incl   -0x4(%ebp)
 273:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 276:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 27a:	0f 9f c0             	setg   %al
 27d:	ff 4d 10             	decl   0x10(%ebp)
 280:	84 c0                	test   %al,%al
 282:	75 e2                	jne    266 <memmove+0x14>
  return vdst;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <fork>:
 289:	b8 01 00 00 00       	mov    $0x1,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <exit>:
 291:	b8 02 00 00 00       	mov    $0x2,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <wait>:
 299:	b8 03 00 00 00       	mov    $0x3,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <pipe>:
 2a1:	b8 04 00 00 00       	mov    $0x4,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <read>:
 2a9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <write>:
 2b1:	b8 10 00 00 00       	mov    $0x10,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <close>:
 2b9:	b8 15 00 00 00       	mov    $0x15,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <kill>:
 2c1:	b8 06 00 00 00       	mov    $0x6,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exec>:
 2c9:	b8 07 00 00 00       	mov    $0x7,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <open>:
 2d1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <mknod>:
 2d9:	b8 11 00 00 00       	mov    $0x11,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <unlink>:
 2e1:	b8 12 00 00 00       	mov    $0x12,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <fstat>:
 2e9:	b8 08 00 00 00       	mov    $0x8,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <link>:
 2f1:	b8 13 00 00 00       	mov    $0x13,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <mkdir>:
 2f9:	b8 14 00 00 00       	mov    $0x14,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <chdir>:
 301:	b8 09 00 00 00       	mov    $0x9,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <dup>:
 309:	b8 0a 00 00 00       	mov    $0xa,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <getpid>:
 311:	b8 0b 00 00 00       	mov    $0xb,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <sbrk>:
 319:	b8 0c 00 00 00       	mov    $0xc,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <sleep>:
 321:	b8 0d 00 00 00       	mov    $0xd,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <uptime>:
 329:	b8 0e 00 00 00       	mov    $0xe,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <lseek>:
 331:	b8 16 00 00 00       	mov    $0x16,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <isatty>:
 339:	b8 17 00 00 00       	mov    $0x17,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <procstat>:
 341:	b8 18 00 00 00       	mov    $0x18,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <set_priority>:
 349:	b8 19 00 00 00       	mov    $0x19,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 351:	55                   	push   %ebp
 352:	89 e5                	mov    %esp,%ebp
 354:	83 ec 28             	sub    $0x28,%esp
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 35d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 364:	00 
 365:	8d 45 f4             	lea    -0xc(%ebp),%eax
 368:	89 44 24 04          	mov    %eax,0x4(%esp)
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 3a ff ff ff       	call   2b1 <write>
}
 377:	c9                   	leave  
 378:	c3                   	ret    

00000379 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 37f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 386:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38a:	74 17                	je     3a3 <printint+0x2a>
 38c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 390:	79 11                	jns    3a3 <printint+0x2a>
    neg = 1;
 392:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 399:	8b 45 0c             	mov    0xc(%ebp),%eax
 39c:	f7 d8                	neg    %eax
 39e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a1:	eb 06                	jmp    3a9 <printint+0x30>
  } else {
    x = xx;
 3a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b6:	ba 00 00 00 00       	mov    $0x0,%edx
 3bb:	f7 f1                	div    %ecx
 3bd:	89 d0                	mov    %edx,%eax
 3bf:	8a 80 58 0a 00 00    	mov    0xa58(%eax),%al
 3c5:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3cb:	01 ca                	add    %ecx,%edx
 3cd:	88 02                	mov    %al,(%edx)
 3cf:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3d2:	8b 55 10             	mov    0x10(%ebp),%edx
 3d5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3db:	ba 00 00 00 00       	mov    $0x0,%edx
 3e0:	f7 75 d4             	divl   -0x2c(%ebp)
 3e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ea:	75 c4                	jne    3b0 <printint+0x37>
  if(neg)
 3ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f0:	74 2c                	je     41e <printint+0xa5>
    buf[i++] = '-';
 3f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f8:	01 d0                	add    %edx,%eax
 3fa:	c6 00 2d             	movb   $0x2d,(%eax)
 3fd:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 400:	eb 1c                	jmp    41e <printint+0xa5>
    putc(fd, buf[i]);
 402:	8d 55 dc             	lea    -0x24(%ebp),%edx
 405:	8b 45 f4             	mov    -0xc(%ebp),%eax
 408:	01 d0                	add    %edx,%eax
 40a:	8a 00                	mov    (%eax),%al
 40c:	0f be c0             	movsbl %al,%eax
 40f:	89 44 24 04          	mov    %eax,0x4(%esp)
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	89 04 24             	mov    %eax,(%esp)
 419:	e8 33 ff ff ff       	call   351 <putc>
  while(--i >= 0)
 41e:	ff 4d f4             	decl   -0xc(%ebp)
 421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 425:	79 db                	jns    402 <printint+0x89>
}
 427:	c9                   	leave  
 428:	c3                   	ret    

00000429 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 429:	55                   	push   %ebp
 42a:	89 e5                	mov    %esp,%ebp
 42c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 42f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 436:	8d 45 0c             	lea    0xc(%ebp),%eax
 439:	83 c0 04             	add    $0x4,%eax
 43c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 43f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 446:	e9 78 01 00 00       	jmp    5c3 <printf+0x19a>
    c = fmt[i] & 0xff;
 44b:	8b 55 0c             	mov    0xc(%ebp),%edx
 44e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 451:	01 d0                	add    %edx,%eax
 453:	8a 00                	mov    (%eax),%al
 455:	0f be c0             	movsbl %al,%eax
 458:	25 ff 00 00 00       	and    $0xff,%eax
 45d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 460:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 464:	75 2c                	jne    492 <printf+0x69>
      if(c == '%'){
 466:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 46a:	75 0c                	jne    478 <printf+0x4f>
        state = '%';
 46c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 473:	e9 48 01 00 00       	jmp    5c0 <printf+0x197>
      } else {
        putc(fd, c);
 478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 47b:	0f be c0             	movsbl %al,%eax
 47e:	89 44 24 04          	mov    %eax,0x4(%esp)
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	89 04 24             	mov    %eax,(%esp)
 488:	e8 c4 fe ff ff       	call   351 <putc>
 48d:	e9 2e 01 00 00       	jmp    5c0 <printf+0x197>
      }
    } else if(state == '%'){
 492:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 496:	0f 85 24 01 00 00    	jne    5c0 <printf+0x197>
      if(c == 'd'){
 49c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a0:	75 2d                	jne    4cf <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4a5:	8b 00                	mov    (%eax),%eax
 4a7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4ae:	00 
 4af:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4b6:	00 
 4b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	89 04 24             	mov    %eax,(%esp)
 4c1:	e8 b3 fe ff ff       	call   379 <printint>
        ap++;
 4c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ca:	e9 ea 00 00 00       	jmp    5b9 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4cf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4d3:	74 06                	je     4db <printf+0xb2>
 4d5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d9:	75 2d                	jne    508 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4de:	8b 00                	mov    (%eax),%eax
 4e0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4e7:	00 
 4e8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ef:	00 
 4f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 7a fe ff ff       	call   379 <printint>
        ap++;
 4ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 503:	e9 b1 00 00 00       	jmp    5b9 <printf+0x190>
      } else if(c == 's'){
 508:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 50c:	75 43                	jne    551 <printf+0x128>
        s = (char*)*ap;
 50e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 511:	8b 00                	mov    (%eax),%eax
 513:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 516:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 51a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51e:	75 25                	jne    545 <printf+0x11c>
          s = "(null)";
 520:	c7 45 f4 12 08 00 00 	movl   $0x812,-0xc(%ebp)
        while(*s != 0){
 527:	eb 1c                	jmp    545 <printf+0x11c>
          putc(fd, *s);
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	8a 00                	mov    (%eax),%al
 52e:	0f be c0             	movsbl %al,%eax
 531:	89 44 24 04          	mov    %eax,0x4(%esp)
 535:	8b 45 08             	mov    0x8(%ebp),%eax
 538:	89 04 24             	mov    %eax,(%esp)
 53b:	e8 11 fe ff ff       	call   351 <putc>
          s++;
 540:	ff 45 f4             	incl   -0xc(%ebp)
 543:	eb 01                	jmp    546 <printf+0x11d>
        while(*s != 0){
 545:	90                   	nop
 546:	8b 45 f4             	mov    -0xc(%ebp),%eax
 549:	8a 00                	mov    (%eax),%al
 54b:	84 c0                	test   %al,%al
 54d:	75 da                	jne    529 <printf+0x100>
 54f:	eb 68                	jmp    5b9 <printf+0x190>
        }
      } else if(c == 'c'){
 551:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 555:	75 1d                	jne    574 <printf+0x14b>
        putc(fd, *ap);
 557:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55a:	8b 00                	mov    (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 e3 fd ff ff       	call   351 <putc>
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 572:	eb 45                	jmp    5b9 <printf+0x190>
      } else if(c == '%'){
 574:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 578:	75 17                	jne    591 <printf+0x168>
        putc(fd, c);
 57a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57d:	0f be c0             	movsbl %al,%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 c2 fd ff ff       	call   351 <putc>
 58f:	eb 28                	jmp    5b9 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 591:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 598:	00 
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	89 04 24             	mov    %eax,(%esp)
 59f:	e8 ad fd ff ff       	call   351 <putc>
        putc(fd, c);
 5a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a7:	0f be c0             	movsbl %al,%eax
 5aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ae:	8b 45 08             	mov    0x8(%ebp),%eax
 5b1:	89 04 24             	mov    %eax,(%esp)
 5b4:	e8 98 fd ff ff       	call   351 <putc>
      }
      state = 0;
 5b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5c0:	ff 45 f0             	incl   -0x10(%ebp)
 5c3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c9:	01 d0                	add    %edx,%eax
 5cb:	8a 00                	mov    (%eax),%al
 5cd:	84 c0                	test   %al,%al
 5cf:	0f 85 76 fe ff ff    	jne    44b <printf+0x22>
    }
  }
}
 5d5:	c9                   	leave  
 5d6:	c3                   	ret    

000005d7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5d7:	55                   	push   %ebp
 5d8:	89 e5                	mov    %esp,%ebp
 5da:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	83 e8 08             	sub    $0x8,%eax
 5e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e6:	a1 74 0a 00 00       	mov    0xa74,%eax
 5eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ee:	eb 24                	jmp    614 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f8:	77 12                	ja     60c <free+0x35>
 5fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 600:	77 24                	ja     626 <free+0x4f>
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60a:	77 1a                	ja     626 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	89 45 fc             	mov    %eax,-0x4(%ebp)
 614:	8b 45 f8             	mov    -0x8(%ebp),%eax
 617:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61a:	76 d4                	jbe    5f0 <free+0x19>
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 624:	76 ca                	jbe    5f0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	8b 40 04             	mov    0x4(%eax),%eax
 62c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 633:	8b 45 f8             	mov    -0x8(%ebp),%eax
 636:	01 c2                	add    %eax,%edx
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	39 c2                	cmp    %eax,%edx
 63f:	75 24                	jne    665 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	8b 50 04             	mov    0x4(%eax),%edx
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	8b 40 04             	mov    0x4(%eax),%eax
 64f:	01 c2                	add    %eax,%edx
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	8b 10                	mov    (%eax),%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 10                	mov    %edx,(%eax)
 663:	eb 0a                	jmp    66f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 10                	mov    (%eax),%edx
 66a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	8b 40 04             	mov    0x4(%eax),%eax
 675:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	01 d0                	add    %edx,%eax
 681:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 684:	75 20                	jne    6a6 <free+0xcf>
    p->s.size += bp->s.size;
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 50 04             	mov    0x4(%eax),%edx
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	01 c2                	add    %eax,%edx
 694:	8b 45 fc             	mov    -0x4(%ebp),%eax
 697:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
 6a4:	eb 08                	jmp    6ae <free+0xd7>
  } else
    p->s.ptr = bp;
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ac:	89 10                	mov    %edx,(%eax)
  freep = p;
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	a3 74 0a 00 00       	mov    %eax,0xa74
}
 6b6:	c9                   	leave  
 6b7:	c3                   	ret    

000006b8 <morecore>:

static Header*
morecore(uint nu)
{
 6b8:	55                   	push   %ebp
 6b9:	89 e5                	mov    %esp,%ebp
 6bb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6be:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6c5:	77 07                	ja     6ce <morecore+0x16>
    nu = 4096;
 6c7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	c1 e0 03             	shl    $0x3,%eax
 6d4:	89 04 24             	mov    %eax,(%esp)
 6d7:	e8 3d fc ff ff       	call   319 <sbrk>
 6dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6df:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6e3:	75 07                	jne    6ec <morecore+0x34>
    return 0;
 6e5:	b8 00 00 00 00       	mov    $0x0,%eax
 6ea:	eb 22                	jmp    70e <morecore+0x56>
  hp = (Header*)p;
 6ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f5:	8b 55 08             	mov    0x8(%ebp),%edx
 6f8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fe:	83 c0 08             	add    $0x8,%eax
 701:	89 04 24             	mov    %eax,(%esp)
 704:	e8 ce fe ff ff       	call   5d7 <free>
  return freep;
 709:	a1 74 0a 00 00       	mov    0xa74,%eax
}
 70e:	c9                   	leave  
 70f:	c3                   	ret    

00000710 <malloc>:

void*
malloc(uint nbytes)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 716:	8b 45 08             	mov    0x8(%ebp),%eax
 719:	83 c0 07             	add    $0x7,%eax
 71c:	c1 e8 03             	shr    $0x3,%eax
 71f:	40                   	inc    %eax
 720:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 723:	a1 74 0a 00 00       	mov    0xa74,%eax
 728:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 72f:	75 23                	jne    754 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 731:	c7 45 f0 6c 0a 00 00 	movl   $0xa6c,-0x10(%ebp)
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	a3 74 0a 00 00       	mov    %eax,0xa74
 740:	a1 74 0a 00 00       	mov    0xa74,%eax
 745:	a3 6c 0a 00 00       	mov    %eax,0xa6c
    base.s.size = 0;
 74a:	c7 05 70 0a 00 00 00 	movl   $0x0,0xa70
 751:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 754:	8b 45 f0             	mov    -0x10(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 765:	72 4d                	jb     7b4 <malloc+0xa4>
      if(p->s.size == nunits)
 767:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 770:	75 0c                	jne    77e <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
 77c:	eb 26                	jmp    7a4 <malloc+0x94>
      else {
        p->s.size -= nunits;
 77e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	89 c2                	mov    %eax,%edx
 786:	2b 55 ec             	sub    -0x14(%ebp),%edx
 789:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	c1 e0 03             	shl    $0x3,%eax
 798:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a7:	a3 74 0a 00 00       	mov    %eax,0xa74
      return (void*)(p + 1);
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	83 c0 08             	add    $0x8,%eax
 7b2:	eb 38                	jmp    7ec <malloc+0xdc>
    }
    if(p == freep)
 7b4:	a1 74 0a 00 00       	mov    0xa74,%eax
 7b9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bc:	75 1b                	jne    7d9 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c1:	89 04 24             	mov    %eax,(%esp)
 7c4:	e8 ef fe ff ff       	call   6b8 <morecore>
 7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d0:	75 07                	jne    7d9 <malloc+0xc9>
        return 0;
 7d2:	b8 00 00 00 00       	mov    $0x0,%eax
 7d7:	eb 13                	jmp    7ec <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 00                	mov    (%eax),%eax
 7e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7e7:	e9 70 ff ff ff       	jmp    75c <malloc+0x4c>
}
 7ec:	c9                   	leave  
 7ed:	c3                   	ret    
