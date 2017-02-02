
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
  19:	c7 44 24 04 de 07 00 	movl   $0x7de,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 ec 03 00 00       	call   419 <printf>
  2d:	eb 14                	jmp    43 <main+0x43>
	else
		printf(1, "stdin is not a tty\n");
  2f:	c7 44 24 04 ee 07 00 	movl   $0x7ee,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 d6 03 00 00       	call   419 <printf>

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

00000341 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	83 ec 28             	sub    $0x28,%esp
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 34d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 354:	00 
 355:	8d 45 f4             	lea    -0xc(%ebp),%eax
 358:	89 44 24 04          	mov    %eax,0x4(%esp)
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	89 04 24             	mov    %eax,(%esp)
 362:	e8 4a ff ff ff       	call   2b1 <write>
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 36f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 376:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 37a:	74 17                	je     393 <printint+0x2a>
 37c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 380:	79 11                	jns    393 <printint+0x2a>
    neg = 1;
 382:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 389:	8b 45 0c             	mov    0xc(%ebp),%eax
 38c:	f7 d8                	neg    %eax
 38e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 391:	eb 06                	jmp    399 <printint+0x30>
  } else {
    x = xx;
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 399:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a6:	ba 00 00 00 00       	mov    $0x0,%edx
 3ab:	f7 f1                	div    %ecx
 3ad:	89 d0                	mov    %edx,%eax
 3af:	8a 80 48 0a 00 00    	mov    0xa48(%eax),%al
 3b5:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3bb:	01 ca                	add    %ecx,%edx
 3bd:	88 02                	mov    %al,(%edx)
 3bf:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3c2:	8b 55 10             	mov    0x10(%ebp),%edx
 3c5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cb:	ba 00 00 00 00       	mov    $0x0,%edx
 3d0:	f7 75 d4             	divl   -0x2c(%ebp)
 3d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3da:	75 c4                	jne    3a0 <printint+0x37>
  if(neg)
 3dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3e0:	74 2c                	je     40e <printint+0xa5>
    buf[i++] = '-';
 3e2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e8:	01 d0                	add    %edx,%eax
 3ea:	c6 00 2d             	movb   $0x2d,(%eax)
 3ed:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3f0:	eb 1c                	jmp    40e <printint+0xa5>
    putc(fd, buf[i]);
 3f2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f8:	01 d0                	add    %edx,%eax
 3fa:	8a 00                	mov    (%eax),%al
 3fc:	0f be c0             	movsbl %al,%eax
 3ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	89 04 24             	mov    %eax,(%esp)
 409:	e8 33 ff ff ff       	call   341 <putc>
  while(--i >= 0)
 40e:	ff 4d f4             	decl   -0xc(%ebp)
 411:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 415:	79 db                	jns    3f2 <printint+0x89>
}
 417:	c9                   	leave  
 418:	c3                   	ret    

00000419 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 419:	55                   	push   %ebp
 41a:	89 e5                	mov    %esp,%ebp
 41c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 426:	8d 45 0c             	lea    0xc(%ebp),%eax
 429:	83 c0 04             	add    $0x4,%eax
 42c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 436:	e9 78 01 00 00       	jmp    5b3 <printf+0x19a>
    c = fmt[i] & 0xff;
 43b:	8b 55 0c             	mov    0xc(%ebp),%edx
 43e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 441:	01 d0                	add    %edx,%eax
 443:	8a 00                	mov    (%eax),%al
 445:	0f be c0             	movsbl %al,%eax
 448:	25 ff 00 00 00       	and    $0xff,%eax
 44d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 450:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 454:	75 2c                	jne    482 <printf+0x69>
      if(c == '%'){
 456:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 45a:	75 0c                	jne    468 <printf+0x4f>
        state = '%';
 45c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 463:	e9 48 01 00 00       	jmp    5b0 <printf+0x197>
      } else {
        putc(fd, c);
 468:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 46b:	0f be c0             	movsbl %al,%eax
 46e:	89 44 24 04          	mov    %eax,0x4(%esp)
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	89 04 24             	mov    %eax,(%esp)
 478:	e8 c4 fe ff ff       	call   341 <putc>
 47d:	e9 2e 01 00 00       	jmp    5b0 <printf+0x197>
      }
    } else if(state == '%'){
 482:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 486:	0f 85 24 01 00 00    	jne    5b0 <printf+0x197>
      if(c == 'd'){
 48c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 490:	75 2d                	jne    4bf <printf+0xa6>
        printint(fd, *ap, 10, 1);
 492:	8b 45 e8             	mov    -0x18(%ebp),%eax
 495:	8b 00                	mov    (%eax),%eax
 497:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 49e:	00 
 49f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4a6:	00 
 4a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	89 04 24             	mov    %eax,(%esp)
 4b1:	e8 b3 fe ff ff       	call   369 <printint>
        ap++;
 4b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ba:	e9 ea 00 00 00       	jmp    5a9 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4bf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4c3:	74 06                	je     4cb <printf+0xb2>
 4c5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c9:	75 2d                	jne    4f8 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ce:	8b 00                	mov    (%eax),%eax
 4d0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4d7:	00 
 4d8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4df:	00 
 4e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	89 04 24             	mov    %eax,(%esp)
 4ea:	e8 7a fe ff ff       	call   369 <printint>
        ap++;
 4ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f3:	e9 b1 00 00 00       	jmp    5a9 <printf+0x190>
      } else if(c == 's'){
 4f8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4fc:	75 43                	jne    541 <printf+0x128>
        s = (char*)*ap;
 4fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 501:	8b 00                	mov    (%eax),%eax
 503:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 506:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 50a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 50e:	75 25                	jne    535 <printf+0x11c>
          s = "(null)";
 510:	c7 45 f4 02 08 00 00 	movl   $0x802,-0xc(%ebp)
        while(*s != 0){
 517:	eb 1c                	jmp    535 <printf+0x11c>
          putc(fd, *s);
 519:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51c:	8a 00                	mov    (%eax),%al
 51e:	0f be c0             	movsbl %al,%eax
 521:	89 44 24 04          	mov    %eax,0x4(%esp)
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	89 04 24             	mov    %eax,(%esp)
 52b:	e8 11 fe ff ff       	call   341 <putc>
          s++;
 530:	ff 45 f4             	incl   -0xc(%ebp)
 533:	eb 01                	jmp    536 <printf+0x11d>
        while(*s != 0){
 535:	90                   	nop
 536:	8b 45 f4             	mov    -0xc(%ebp),%eax
 539:	8a 00                	mov    (%eax),%al
 53b:	84 c0                	test   %al,%al
 53d:	75 da                	jne    519 <printf+0x100>
 53f:	eb 68                	jmp    5a9 <printf+0x190>
        }
      } else if(c == 'c'){
 541:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 545:	75 1d                	jne    564 <printf+0x14b>
        putc(fd, *ap);
 547:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54a:	8b 00                	mov    (%eax),%eax
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 e3 fd ff ff       	call   341 <putc>
        ap++;
 55e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 562:	eb 45                	jmp    5a9 <printf+0x190>
      } else if(c == '%'){
 564:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 568:	75 17                	jne    581 <printf+0x168>
        putc(fd, c);
 56a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	89 44 24 04          	mov    %eax,0x4(%esp)
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 c2 fd ff ff       	call   341 <putc>
 57f:	eb 28                	jmp    5a9 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 581:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 588:	00 
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 ad fd ff ff       	call   341 <putc>
        putc(fd, c);
 594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 597:	0f be c0             	movsbl %al,%eax
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 98 fd ff ff       	call   341 <putc>
      }
      state = 0;
 5a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5b0:	ff 45 f0             	incl   -0x10(%ebp)
 5b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b9:	01 d0                	add    %edx,%eax
 5bb:	8a 00                	mov    (%eax),%al
 5bd:	84 c0                	test   %al,%al
 5bf:	0f 85 76 fe ff ff    	jne    43b <printf+0x22>
    }
  }
}
 5c5:	c9                   	leave  
 5c6:	c3                   	ret    

000005c7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	83 e8 08             	sub    $0x8,%eax
 5d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d6:	a1 64 0a 00 00       	mov    0xa64,%eax
 5db:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5de:	eb 24                	jmp    604 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e3:	8b 00                	mov    (%eax),%eax
 5e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e8:	77 12                	ja     5fc <free+0x35>
 5ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f0:	77 24                	ja     616 <free+0x4f>
 5f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5fa:	77 1a                	ja     616 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	89 45 fc             	mov    %eax,-0x4(%ebp)
 604:	8b 45 f8             	mov    -0x8(%ebp),%eax
 607:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60a:	76 d4                	jbe    5e0 <free+0x19>
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8b 00                	mov    (%eax),%eax
 611:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 614:	76 ca                	jbe    5e0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 616:	8b 45 f8             	mov    -0x8(%ebp),%eax
 619:	8b 40 04             	mov    0x4(%eax),%eax
 61c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 623:	8b 45 f8             	mov    -0x8(%ebp),%eax
 626:	01 c2                	add    %eax,%edx
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	39 c2                	cmp    %eax,%edx
 62f:	75 24                	jne    655 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 631:	8b 45 f8             	mov    -0x8(%ebp),%eax
 634:	8b 50 04             	mov    0x4(%eax),%edx
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	8b 40 04             	mov    0x4(%eax),%eax
 63f:	01 c2                	add    %eax,%edx
 641:	8b 45 f8             	mov    -0x8(%ebp),%eax
 644:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	8b 10                	mov    (%eax),%edx
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	89 10                	mov    %edx,(%eax)
 653:	eb 0a                	jmp    65f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 10                	mov    (%eax),%edx
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 65f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 662:	8b 40 04             	mov    0x4(%eax),%eax
 665:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	01 d0                	add    %edx,%eax
 671:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 674:	75 20                	jne    696 <free+0xcf>
    p->s.size += bp->s.size;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 50 04             	mov    0x4(%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	01 c2                	add    %eax,%edx
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 68a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68d:	8b 10                	mov    (%eax),%edx
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	89 10                	mov    %edx,(%eax)
 694:	eb 08                	jmp    69e <free+0xd7>
  } else
    p->s.ptr = bp;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	8b 55 f8             	mov    -0x8(%ebp),%edx
 69c:	89 10                	mov    %edx,(%eax)
  freep = p;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	a3 64 0a 00 00       	mov    %eax,0xa64
}
 6a6:	c9                   	leave  
 6a7:	c3                   	ret    

000006a8 <morecore>:

static Header*
morecore(uint nu)
{
 6a8:	55                   	push   %ebp
 6a9:	89 e5                	mov    %esp,%ebp
 6ab:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ae:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b5:	77 07                	ja     6be <morecore+0x16>
    nu = 4096;
 6b7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	c1 e0 03             	shl    $0x3,%eax
 6c4:	89 04 24             	mov    %eax,(%esp)
 6c7:	e8 4d fc ff ff       	call   319 <sbrk>
 6cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6d3:	75 07                	jne    6dc <morecore+0x34>
    return 0;
 6d5:	b8 00 00 00 00       	mov    $0x0,%eax
 6da:	eb 22                	jmp    6fe <morecore+0x56>
  hp = (Header*)p;
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e5:	8b 55 08             	mov    0x8(%ebp),%edx
 6e8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ee:	83 c0 08             	add    $0x8,%eax
 6f1:	89 04 24             	mov    %eax,(%esp)
 6f4:	e8 ce fe ff ff       	call   5c7 <free>
  return freep;
 6f9:	a1 64 0a 00 00       	mov    0xa64,%eax
}
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <malloc>:

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	83 c0 07             	add    $0x7,%eax
 70c:	c1 e8 03             	shr    $0x3,%eax
 70f:	40                   	inc    %eax
 710:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 713:	a1 64 0a 00 00       	mov    0xa64,%eax
 718:	89 45 f0             	mov    %eax,-0x10(%ebp)
 71b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71f:	75 23                	jne    744 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 721:	c7 45 f0 5c 0a 00 00 	movl   $0xa5c,-0x10(%ebp)
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	a3 64 0a 00 00       	mov    %eax,0xa64
 730:	a1 64 0a 00 00       	mov    0xa64,%eax
 735:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    base.s.size = 0;
 73a:	c7 05 60 0a 00 00 00 	movl   $0x0,0xa60
 741:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 744:	8b 45 f0             	mov    -0x10(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	8b 40 04             	mov    0x4(%eax),%eax
 752:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 755:	72 4d                	jb     7a4 <malloc+0xa4>
      if(p->s.size == nunits)
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	8b 40 04             	mov    0x4(%eax),%eax
 75d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 760:	75 0c                	jne    76e <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	8b 10                	mov    (%eax),%edx
 767:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76a:	89 10                	mov    %edx,(%eax)
 76c:	eb 26                	jmp    794 <malloc+0x94>
      else {
        p->s.size -= nunits;
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	89 c2                	mov    %eax,%edx
 776:	2b 55 ec             	sub    -0x14(%ebp),%edx
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	c1 e0 03             	shl    $0x3,%eax
 788:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 791:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	a3 64 0a 00 00       	mov    %eax,0xa64
      return (void*)(p + 1);
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	83 c0 08             	add    $0x8,%eax
 7a2:	eb 38                	jmp    7dc <malloc+0xdc>
    }
    if(p == freep)
 7a4:	a1 64 0a 00 00       	mov    0xa64,%eax
 7a9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ac:	75 1b                	jne    7c9 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7b1:	89 04 24             	mov    %eax,(%esp)
 7b4:	e8 ef fe ff ff       	call   6a8 <morecore>
 7b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c0:	75 07                	jne    7c9 <malloc+0xc9>
        return 0;
 7c2:	b8 00 00 00 00       	mov    $0x0,%eax
 7c7:	eb 13                	jmp    7dc <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7d7:	e9 70 ff ff ff       	jmp    74c <malloc+0x4c>
}
 7dc:	c9                   	leave  
 7dd:	c3                   	ret    
