
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
  19:	c7 44 24 04 26 08 00 	movl   $0x826,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 34 04 00 00       	call   461 <printf>
  2d:	eb 14                	jmp    43 <main+0x43>
	else
		printf(1, "stdin is not a tty\n");
  2f:	c7 44 24 04 36 08 00 	movl   $0x836,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 1e 04 00 00       	call   461 <printf>

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

00000351 <semget>:
 351:	b8 1a 00 00 00       	mov    $0x1a,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <semfree>:
 359:	b8 1b 00 00 00       	mov    $0x1b,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <semdown>:
 361:	b8 1c 00 00 00       	mov    $0x1c,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <semup>:
 369:	b8 1d 00 00 00       	mov    $0x1d,%eax
 36e:	cd 40                	int    $0x40
 370:	c3                   	ret    

00000371 <shm_create>:
 371:	b8 1e 00 00 00       	mov    $0x1e,%eax
 376:	cd 40                	int    $0x40
 378:	c3                   	ret    

00000379 <shm_close>:
 379:	b8 1f 00 00 00       	mov    $0x1f,%eax
 37e:	cd 40                	int    $0x40
 380:	c3                   	ret    

00000381 <shm_get>:
 381:	b8 20 00 00 00       	mov    $0x20,%eax
 386:	cd 40                	int    $0x40
 388:	c3                   	ret    

00000389 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 28             	sub    $0x28,%esp
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 395:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39c:	00 
 39d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	89 04 24             	mov    %eax,(%esp)
 3aa:	e8 02 ff ff ff       	call   2b1 <write>
}
 3af:	c9                   	leave  
 3b0:	c3                   	ret    

000003b1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b1:	55                   	push   %ebp
 3b2:	89 e5                	mov    %esp,%ebp
 3b4:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c2:	74 17                	je     3db <printint+0x2a>
 3c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c8:	79 11                	jns    3db <printint+0x2a>
    neg = 1;
 3ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	f7 d8                	neg    %eax
 3d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d9:	eb 06                	jmp    3e1 <printint+0x30>
  } else {
    x = xx;
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ee:	ba 00 00 00 00       	mov    $0x0,%edx
 3f3:	f7 f1                	div    %ecx
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	8a 80 90 0a 00 00    	mov    0xa90(%eax),%al
 3fd:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 400:	8b 55 f4             	mov    -0xc(%ebp),%edx
 403:	01 ca                	add    %ecx,%edx
 405:	88 02                	mov    %al,(%edx)
 407:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 40a:	8b 55 10             	mov    0x10(%ebp),%edx
 40d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 410:	8b 45 ec             	mov    -0x14(%ebp),%eax
 413:	ba 00 00 00 00       	mov    $0x0,%edx
 418:	f7 75 d4             	divl   -0x2c(%ebp)
 41b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 422:	75 c4                	jne    3e8 <printint+0x37>
  if(neg)
 424:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 428:	74 2c                	je     456 <printint+0xa5>
    buf[i++] = '-';
 42a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 430:	01 d0                	add    %edx,%eax
 432:	c6 00 2d             	movb   $0x2d,(%eax)
 435:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 438:	eb 1c                	jmp    456 <printint+0xa5>
    putc(fd, buf[i]);
 43a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 440:	01 d0                	add    %edx,%eax
 442:	8a 00                	mov    (%eax),%al
 444:	0f be c0             	movsbl %al,%eax
 447:	89 44 24 04          	mov    %eax,0x4(%esp)
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	89 04 24             	mov    %eax,(%esp)
 451:	e8 33 ff ff ff       	call   389 <putc>
  while(--i >= 0)
 456:	ff 4d f4             	decl   -0xc(%ebp)
 459:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45d:	79 db                	jns    43a <printint+0x89>
}
 45f:	c9                   	leave  
 460:	c3                   	ret    

00000461 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 461:	55                   	push   %ebp
 462:	89 e5                	mov    %esp,%ebp
 464:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 467:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46e:	8d 45 0c             	lea    0xc(%ebp),%eax
 471:	83 c0 04             	add    $0x4,%eax
 474:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 477:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47e:	e9 78 01 00 00       	jmp    5fb <printf+0x19a>
    c = fmt[i] & 0xff;
 483:	8b 55 0c             	mov    0xc(%ebp),%edx
 486:	8b 45 f0             	mov    -0x10(%ebp),%eax
 489:	01 d0                	add    %edx,%eax
 48b:	8a 00                	mov    (%eax),%al
 48d:	0f be c0             	movsbl %al,%eax
 490:	25 ff 00 00 00       	and    $0xff,%eax
 495:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 498:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49c:	75 2c                	jne    4ca <printf+0x69>
      if(c == '%'){
 49e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a2:	75 0c                	jne    4b0 <printf+0x4f>
        state = '%';
 4a4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ab:	e9 48 01 00 00       	jmp    5f8 <printf+0x197>
      } else {
        putc(fd, c);
 4b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	89 04 24             	mov    %eax,(%esp)
 4c0:	e8 c4 fe ff ff       	call   389 <putc>
 4c5:	e9 2e 01 00 00       	jmp    5f8 <printf+0x197>
      }
    } else if(state == '%'){
 4ca:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ce:	0f 85 24 01 00 00    	jne    5f8 <printf+0x197>
      if(c == 'd'){
 4d4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d8:	75 2d                	jne    507 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4dd:	8b 00                	mov    (%eax),%eax
 4df:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e6:	00 
 4e7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ee:	00 
 4ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	89 04 24             	mov    %eax,(%esp)
 4f9:	e8 b3 fe ff ff       	call   3b1 <printint>
        ap++;
 4fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 502:	e9 ea 00 00 00       	jmp    5f1 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 507:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50b:	74 06                	je     513 <printf+0xb2>
 50d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 511:	75 2d                	jne    540 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 513:	8b 45 e8             	mov    -0x18(%ebp),%eax
 516:	8b 00                	mov    (%eax),%eax
 518:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 51f:	00 
 520:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 527:	00 
 528:	89 44 24 04          	mov    %eax,0x4(%esp)
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	89 04 24             	mov    %eax,(%esp)
 532:	e8 7a fe ff ff       	call   3b1 <printint>
        ap++;
 537:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53b:	e9 b1 00 00 00       	jmp    5f1 <printf+0x190>
      } else if(c == 's'){
 540:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 544:	75 43                	jne    589 <printf+0x128>
        s = (char*)*ap;
 546:	8b 45 e8             	mov    -0x18(%ebp),%eax
 549:	8b 00                	mov    (%eax),%eax
 54b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 556:	75 25                	jne    57d <printf+0x11c>
          s = "(null)";
 558:	c7 45 f4 4a 08 00 00 	movl   $0x84a,-0xc(%ebp)
        while(*s != 0){
 55f:	eb 1c                	jmp    57d <printf+0x11c>
          putc(fd, *s);
 561:	8b 45 f4             	mov    -0xc(%ebp),%eax
 564:	8a 00                	mov    (%eax),%al
 566:	0f be c0             	movsbl %al,%eax
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	8b 45 08             	mov    0x8(%ebp),%eax
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 11 fe ff ff       	call   389 <putc>
          s++;
 578:	ff 45 f4             	incl   -0xc(%ebp)
 57b:	eb 01                	jmp    57e <printf+0x11d>
        while(*s != 0){
 57d:	90                   	nop
 57e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 581:	8a 00                	mov    (%eax),%al
 583:	84 c0                	test   %al,%al
 585:	75 da                	jne    561 <printf+0x100>
 587:	eb 68                	jmp    5f1 <printf+0x190>
        }
      } else if(c == 'c'){
 589:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58d:	75 1d                	jne    5ac <printf+0x14b>
        putc(fd, *ap);
 58f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 592:	8b 00                	mov    (%eax),%eax
 594:	0f be c0             	movsbl %al,%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	89 04 24             	mov    %eax,(%esp)
 5a1:	e8 e3 fd ff ff       	call   389 <putc>
        ap++;
 5a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5aa:	eb 45                	jmp    5f1 <printf+0x190>
      } else if(c == '%'){
 5ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b0:	75 17                	jne    5c9 <printf+0x168>
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 c2 fd ff ff       	call   389 <putc>
 5c7:	eb 28                	jmp    5f1 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d0:	00 
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	89 04 24             	mov    %eax,(%esp)
 5d7:	e8 ad fd ff ff       	call   389 <putc>
        putc(fd, c);
 5dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	89 04 24             	mov    %eax,(%esp)
 5ec:	e8 98 fd ff ff       	call   389 <putc>
      }
      state = 0;
 5f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f8:	ff 45 f0             	incl   -0x10(%ebp)
 5fb:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 601:	01 d0                	add    %edx,%eax
 603:	8a 00                	mov    (%eax),%al
 605:	84 c0                	test   %al,%al
 607:	0f 85 76 fe ff ff    	jne    483 <printf+0x22>
    }
  }
}
 60d:	c9                   	leave  
 60e:	c3                   	ret    

0000060f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60f:	55                   	push   %ebp
 610:	89 e5                	mov    %esp,%ebp
 612:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	83 e8 08             	sub    $0x8,%eax
 61b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	a1 ac 0a 00 00       	mov    0xaac,%eax
 623:	89 45 fc             	mov    %eax,-0x4(%ebp)
 626:	eb 24                	jmp    64c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 628:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62b:	8b 00                	mov    (%eax),%eax
 62d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 630:	77 12                	ja     644 <free+0x35>
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 638:	77 24                	ja     65e <free+0x4f>
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 642:	77 1a                	ja     65e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 644:	8b 45 fc             	mov    -0x4(%ebp),%eax
 647:	8b 00                	mov    (%eax),%eax
 649:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 652:	76 d4                	jbe    628 <free+0x19>
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65c:	76 ca                	jbe    628 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	8b 40 04             	mov    0x4(%eax),%eax
 664:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	01 c2                	add    %eax,%edx
 670:	8b 45 fc             	mov    -0x4(%ebp),%eax
 673:	8b 00                	mov    (%eax),%eax
 675:	39 c2                	cmp    %eax,%edx
 677:	75 24                	jne    69d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	8b 50 04             	mov    0x4(%eax),%edx
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	01 c2                	add    %eax,%edx
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	8b 10                	mov    (%eax),%edx
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	89 10                	mov    %edx,(%eax)
 69b:	eb 0a                	jmp    6a7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 10                	mov    (%eax),%edx
 6a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 40 04             	mov    0x4(%eax),%eax
 6ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	01 d0                	add    %edx,%eax
 6b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bc:	75 20                	jne    6de <free+0xcf>
    p->s.size += bp->s.size;
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 50 04             	mov    0x4(%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	8b 40 04             	mov    0x4(%eax),%eax
 6ca:	01 c2                	add    %eax,%edx
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 10                	mov    (%eax),%edx
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	89 10                	mov    %edx,(%eax)
 6dc:	eb 08                	jmp    6e6 <free+0xd7>
  } else
    p->s.ptr = bp;
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e4:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	a3 ac 0a 00 00       	mov    %eax,0xaac
}
 6ee:	c9                   	leave  
 6ef:	c3                   	ret    

000006f0 <morecore>:

static Header*
morecore(uint nu)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fd:	77 07                	ja     706 <morecore+0x16>
    nu = 4096;
 6ff:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	c1 e0 03             	shl    $0x3,%eax
 70c:	89 04 24             	mov    %eax,(%esp)
 70f:	e8 05 fc ff ff       	call   319 <sbrk>
 714:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 717:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71b:	75 07                	jne    724 <morecore+0x34>
    return 0;
 71d:	b8 00 00 00 00       	mov    $0x0,%eax
 722:	eb 22                	jmp    746 <morecore+0x56>
  hp = (Header*)p;
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	8b 55 08             	mov    0x8(%ebp),%edx
 730:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 733:	8b 45 f0             	mov    -0x10(%ebp),%eax
 736:	83 c0 08             	add    $0x8,%eax
 739:	89 04 24             	mov    %eax,(%esp)
 73c:	e8 ce fe ff ff       	call   60f <free>
  return freep;
 741:	a1 ac 0a 00 00       	mov    0xaac,%eax
}
 746:	c9                   	leave  
 747:	c3                   	ret    

00000748 <malloc>:

void*
malloc(uint nbytes)
{
 748:	55                   	push   %ebp
 749:	89 e5                	mov    %esp,%ebp
 74b:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74e:	8b 45 08             	mov    0x8(%ebp),%eax
 751:	83 c0 07             	add    $0x7,%eax
 754:	c1 e8 03             	shr    $0x3,%eax
 757:	40                   	inc    %eax
 758:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 75b:	a1 ac 0a 00 00       	mov    0xaac,%eax
 760:	89 45 f0             	mov    %eax,-0x10(%ebp)
 763:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 767:	75 23                	jne    78c <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 769:	c7 45 f0 a4 0a 00 00 	movl   $0xaa4,-0x10(%ebp)
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	a3 ac 0a 00 00       	mov    %eax,0xaac
 778:	a1 ac 0a 00 00       	mov    0xaac,%eax
 77d:	a3 a4 0a 00 00       	mov    %eax,0xaa4
    base.s.size = 0;
 782:	c7 05 a8 0a 00 00 00 	movl   $0x0,0xaa8
 789:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 794:	8b 45 f4             	mov    -0xc(%ebp),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79d:	72 4d                	jb     7ec <malloc+0xa4>
      if(p->s.size == nunits)
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a8:	75 0c                	jne    7b6 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	8b 10                	mov    (%eax),%edx
 7af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b2:	89 10                	mov    %edx,(%eax)
 7b4:	eb 26                	jmp    7dc <malloc+0x94>
      else {
        p->s.size -= nunits;
 7b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b9:	8b 40 04             	mov    0x4(%eax),%eax
 7bc:	89 c2                	mov    %eax,%edx
 7be:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ca:	8b 40 04             	mov    0x4(%eax),%eax
 7cd:	c1 e0 03             	shl    $0x3,%eax
 7d0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7df:	a3 ac 0a 00 00       	mov    %eax,0xaac
      return (void*)(p + 1);
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	83 c0 08             	add    $0x8,%eax
 7ea:	eb 38                	jmp    824 <malloc+0xdc>
    }
    if(p == freep)
 7ec:	a1 ac 0a 00 00       	mov    0xaac,%eax
 7f1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f4:	75 1b                	jne    811 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f9:	89 04 24             	mov    %eax,(%esp)
 7fc:	e8 ef fe ff ff       	call   6f0 <morecore>
 801:	89 45 f4             	mov    %eax,-0xc(%ebp)
 804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 808:	75 07                	jne    811 <malloc+0xc9>
        return 0;
 80a:	b8 00 00 00 00       	mov    $0x0,%eax
 80f:	eb 13                	jmp    824 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	89 45 f0             	mov    %eax,-0x10(%ebp)
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 81f:	e9 70 ff ff ff       	jmp    794 <malloc+0x4c>
}
 824:	c9                   	leave  
 825:	c3                   	ret    
