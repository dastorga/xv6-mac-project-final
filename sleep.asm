
_sleep:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
	int sleep_sec;
	if (argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
		printf(2, "Usage: sleep seconds\n");
   f:	c7 44 24 04 54 08 00 	movl   $0x854,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 6c 04 00 00       	call   48f <printf>
		exit();
  23:	e8 97 02 00 00       	call   2bf <exit>
	}

	sleep_sec = atoi(argv[1]);
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 04             	add    $0x4,%eax
  2e:	8b 00                	mov    (%eax),%eax
  30:	89 04 24             	mov    %eax,(%esp)
  33:	e8 01 02 00 00       	call   239 <atoi>
  38:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	if (sleep_sec > 0){
  3c:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  41:	7e 0e                	jle    51 <main+0x51>
		sleep(sleep_sec);
  43:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  47:	89 04 24             	mov    %eax,(%esp)
  4a:	e8 00 03 00 00       	call   34f <sleep>
  4f:	eb 20                	jmp    71 <main+0x71>
	} else {
		printf(2, "Invalid interval %s\n", argv[1]);
  51:	8b 45 0c             	mov    0xc(%ebp),%eax
  54:	83 c0 04             	add    $0x4,%eax
  57:	8b 00                	mov    (%eax),%eax
  59:	89 44 24 08          	mov    %eax,0x8(%esp)
  5d:	c7 44 24 04 6a 08 00 	movl   $0x86a,0x4(%esp)
  64:	00 
  65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6c:	e8 1e 04 00 00       	call   48f <printf>
	}
	exit();
  71:	e8 49 02 00 00       	call   2bf <exit>

00000076 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	57                   	push   %edi
  7a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7e:	8b 55 10             	mov    0x10(%ebp),%edx
  81:	8b 45 0c             	mov    0xc(%ebp),%eax
  84:	89 cb                	mov    %ecx,%ebx
  86:	89 df                	mov    %ebx,%edi
  88:	89 d1                	mov    %edx,%ecx
  8a:	fc                   	cld    
  8b:	f3 aa                	rep stos %al,%es:(%edi)
  8d:	89 ca                	mov    %ecx,%edx
  8f:	89 fb                	mov    %edi,%ebx
  91:	89 5d 08             	mov    %ebx,0x8(%ebp)
  94:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  97:	5b                   	pop    %ebx
  98:	5f                   	pop    %edi
  99:	5d                   	pop    %ebp
  9a:	c3                   	ret    

0000009b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a7:	90                   	nop
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	8a 10                	mov    (%eax),%dl
  ad:	8b 45 08             	mov    0x8(%ebp),%eax
  b0:	88 10                	mov    %dl,(%eax)
  b2:	8b 45 08             	mov    0x8(%ebp),%eax
  b5:	8a 00                	mov    (%eax),%al
  b7:	84 c0                	test   %al,%al
  b9:	0f 95 c0             	setne  %al
  bc:	ff 45 08             	incl   0x8(%ebp)
  bf:	ff 45 0c             	incl   0xc(%ebp)
  c2:	84 c0                	test   %al,%al
  c4:	75 e2                	jne    a8 <strcpy+0xd>
    ;
  return os;
  c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c9:	c9                   	leave  
  ca:	c3                   	ret    

000000cb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ce:	eb 06                	jmp    d6 <strcmp+0xb>
    p++, q++;
  d0:	ff 45 08             	incl   0x8(%ebp)
  d3:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	8a 00                	mov    (%eax),%al
  db:	84 c0                	test   %al,%al
  dd:	74 0e                	je     ed <strcmp+0x22>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	8a 10                	mov    (%eax),%dl
  e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  e7:	8a 00                	mov    (%eax),%al
  e9:	38 c2                	cmp    %al,%dl
  eb:	74 e3                	je     d0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 00                	mov    (%eax),%al
  f2:	0f b6 d0             	movzbl %al,%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	8a 00                	mov    (%eax),%al
  fa:	0f b6 c0             	movzbl %al,%eax
  fd:	89 d1                	mov    %edx,%ecx
  ff:	29 c1                	sub    %eax,%ecx
 101:	89 c8                	mov    %ecx,%eax
}
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <strlen>:

uint
strlen(char *s)
{
 105:	55                   	push   %ebp
 106:	89 e5                	mov    %esp,%ebp
 108:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 112:	eb 03                	jmp    117 <strlen+0x12>
 114:	ff 45 fc             	incl   -0x4(%ebp)
 117:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	01 d0                	add    %edx,%eax
 11f:	8a 00                	mov    (%eax),%al
 121:	84 c0                	test   %al,%al
 123:	75 ef                	jne    114 <strlen+0xf>
    ;
  return n;
 125:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 128:	c9                   	leave  
 129:	c3                   	ret    

0000012a <memset>:

void*
memset(void *dst, int c, uint n)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 130:	8b 45 10             	mov    0x10(%ebp),%eax
 133:	89 44 24 08          	mov    %eax,0x8(%esp)
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	89 44 24 04          	mov    %eax,0x4(%esp)
 13e:	8b 45 08             	mov    0x8(%ebp),%eax
 141:	89 04 24             	mov    %eax,(%esp)
 144:	e8 2d ff ff ff       	call   76 <stosb>
  return dst;
 149:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <strchr>:

char*
strchr(const char *s, char c)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	83 ec 04             	sub    $0x4,%esp
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15a:	eb 12                	jmp    16e <strchr+0x20>
    if(*s == c)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	8a 00                	mov    (%eax),%al
 161:	3a 45 fc             	cmp    -0x4(%ebp),%al
 164:	75 05                	jne    16b <strchr+0x1d>
      return (char*)s;
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	eb 11                	jmp    17c <strchr+0x2e>
  for(; *s; s++)
 16b:	ff 45 08             	incl   0x8(%ebp)
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	8a 00                	mov    (%eax),%al
 173:	84 c0                	test   %al,%al
 175:	75 e5                	jne    15c <strchr+0xe>
  return 0;
 177:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18b:	eb 42                	jmp    1cf <gets+0x51>
    cc = read(0, &c, 1);
 18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 194:	00 
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 2f 01 00 00       	call   2d7 <read>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	7e 29                	jle    1da <gets+0x5c>
      break;
    buf[i++] = c;
 1b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 c2                	add    %eax,%edx
 1b9:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bc:	88 02                	mov    %al,(%edx)
 1be:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c1:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c4:	3c 0a                	cmp    $0xa,%al
 1c6:	74 13                	je     1db <gets+0x5d>
 1c8:	8a 45 ef             	mov    -0x11(%ebp),%al
 1cb:	3c 0d                	cmp    $0xd,%al
 1cd:	74 0c                	je     1db <gets+0x5d>
  for(i=0; i+1 < max; ){
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	40                   	inc    %eax
 1d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d6:	7c b5                	jl     18d <gets+0xf>
 1d8:	eb 01                	jmp    1db <gets+0x5d>
      break;
 1da:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1db:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	01 d0                	add    %edx,%eax
 1e3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <stat>:

int
stat(char *n, struct stat *st)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f8:	00 
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	89 04 24             	mov    %eax,(%esp)
 1ff:	e8 fb 00 00 00       	call   2ff <open>
 204:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 207:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20b:	79 07                	jns    214 <stat+0x29>
    return -1;
 20d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 212:	eb 23                	jmp    237 <stat+0x4c>
  r = fstat(fd, st);
 214:	8b 45 0c             	mov    0xc(%ebp),%eax
 217:	89 44 24 04          	mov    %eax,0x4(%esp)
 21b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21e:	89 04 24             	mov    %eax,(%esp)
 221:	e8 f1 00 00 00       	call   317 <fstat>
 226:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 229:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 b3 00 00 00       	call   2e7 <close>
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 21                	jmp    269 <atoi+0x30>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	d1 e0                	shl    %eax
 254:	89 c2                	mov    %eax,%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8a 00                	mov    (%eax),%al
 25b:	0f be c0             	movsbl %al,%eax
 25e:	01 d0                	add    %edx,%eax
 260:	83 e8 30             	sub    $0x30,%eax
 263:	89 45 fc             	mov    %eax,-0x4(%ebp)
 266:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	8a 00                	mov    (%eax),%al
 26e:	3c 2f                	cmp    $0x2f,%al
 270:	7e 09                	jle    27b <atoi+0x42>
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8a 00                	mov    (%eax),%al
 277:	3c 39                	cmp    $0x39,%al
 279:	7e cd                	jle    248 <atoi+0xf>
  return n;
 27b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27e:	c9                   	leave  
 27f:	c3                   	ret    

00000280 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28c:	8b 45 0c             	mov    0xc(%ebp),%eax
 28f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 292:	eb 10                	jmp    2a4 <memmove+0x24>
    *dst++ = *src++;
 294:	8b 45 f8             	mov    -0x8(%ebp),%eax
 297:	8a 10                	mov    (%eax),%dl
 299:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29c:	88 10                	mov    %dl,(%eax)
 29e:	ff 45 fc             	incl   -0x4(%ebp)
 2a1:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 2a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2a8:	0f 9f c0             	setg   %al
 2ab:	ff 4d 10             	decl   0x10(%ebp)
 2ae:	84 c0                	test   %al,%al
 2b0:	75 e2                	jne    294 <memmove+0x14>
  return vdst;
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b5:	c9                   	leave  
 2b6:	c3                   	ret    

000002b7 <fork>:
 2b7:	b8 01 00 00 00       	mov    $0x1,%eax
 2bc:	cd 40                	int    $0x40
 2be:	c3                   	ret    

000002bf <exit>:
 2bf:	b8 02 00 00 00       	mov    $0x2,%eax
 2c4:	cd 40                	int    $0x40
 2c6:	c3                   	ret    

000002c7 <wait>:
 2c7:	b8 03 00 00 00       	mov    $0x3,%eax
 2cc:	cd 40                	int    $0x40
 2ce:	c3                   	ret    

000002cf <pipe>:
 2cf:	b8 04 00 00 00       	mov    $0x4,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <read>:
 2d7:	b8 05 00 00 00       	mov    $0x5,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <write>:
 2df:	b8 10 00 00 00       	mov    $0x10,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <close>:
 2e7:	b8 15 00 00 00       	mov    $0x15,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <kill>:
 2ef:	b8 06 00 00 00       	mov    $0x6,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <exec>:
 2f7:	b8 07 00 00 00       	mov    $0x7,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <open>:
 2ff:	b8 0f 00 00 00       	mov    $0xf,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <mknod>:
 307:	b8 11 00 00 00       	mov    $0x11,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <unlink>:
 30f:	b8 12 00 00 00       	mov    $0x12,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <fstat>:
 317:	b8 08 00 00 00       	mov    $0x8,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <link>:
 31f:	b8 13 00 00 00       	mov    $0x13,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <mkdir>:
 327:	b8 14 00 00 00       	mov    $0x14,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <chdir>:
 32f:	b8 09 00 00 00       	mov    $0x9,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <dup>:
 337:	b8 0a 00 00 00       	mov    $0xa,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <getpid>:
 33f:	b8 0b 00 00 00       	mov    $0xb,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <sbrk>:
 347:	b8 0c 00 00 00       	mov    $0xc,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <sleep>:
 34f:	b8 0d 00 00 00       	mov    $0xd,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <uptime>:
 357:	b8 0e 00 00 00       	mov    $0xe,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <lseek>:
 35f:	b8 16 00 00 00       	mov    $0x16,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <isatty>:
 367:	b8 17 00 00 00       	mov    $0x17,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <procstat>:
 36f:	b8 18 00 00 00       	mov    $0x18,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <set_priority>:
 377:	b8 19 00 00 00       	mov    $0x19,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <semget>:
 37f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <semfree>:
 387:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <semdown>:
 38f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <semup>:
 397:	b8 1d 00 00 00       	mov    $0x1d,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <shm_create>:
 39f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <shm_close>:
 3a7:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <shm_get>:
 3af:	b8 20 00 00 00       	mov    $0x20,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 28             	sub    $0x28,%esp
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ca:	00 
 3cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	89 04 24             	mov    %eax,(%esp)
 3d8:	e8 02 ff ff ff       	call   2df <write>
}
 3dd:	c9                   	leave  
 3de:	c3                   	ret    

000003df <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
 3e2:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ec:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f0:	74 17                	je     409 <printint+0x2a>
 3f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f6:	79 11                	jns    409 <printint+0x2a>
    neg = 1;
 3f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 402:	f7 d8                	neg    %eax
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	eb 06                	jmp    40f <printint+0x30>
  } else {
    x = xx;
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 40f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 416:	8b 4d 10             	mov    0x10(%ebp),%ecx
 419:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41c:	ba 00 00 00 00       	mov    $0x0,%edx
 421:	f7 f1                	div    %ecx
 423:	89 d0                	mov    %edx,%eax
 425:	8a 80 c4 0a 00 00    	mov    0xac4(%eax),%al
 42b:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 42e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 431:	01 ca                	add    %ecx,%edx
 433:	88 02                	mov    %al,(%edx)
 435:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 438:	8b 55 10             	mov    0x10(%ebp),%edx
 43b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 441:	ba 00 00 00 00       	mov    $0x0,%edx
 446:	f7 75 d4             	divl   -0x2c(%ebp)
 449:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 450:	75 c4                	jne    416 <printint+0x37>
  if(neg)
 452:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 456:	74 2c                	je     484 <printint+0xa5>
    buf[i++] = '-';
 458:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45e:	01 d0                	add    %edx,%eax
 460:	c6 00 2d             	movb   $0x2d,(%eax)
 463:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 466:	eb 1c                	jmp    484 <printint+0xa5>
    putc(fd, buf[i]);
 468:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46e:	01 d0                	add    %edx,%eax
 470:	8a 00                	mov    (%eax),%al
 472:	0f be c0             	movsbl %al,%eax
 475:	89 44 24 04          	mov    %eax,0x4(%esp)
 479:	8b 45 08             	mov    0x8(%ebp),%eax
 47c:	89 04 24             	mov    %eax,(%esp)
 47f:	e8 33 ff ff ff       	call   3b7 <putc>
  while(--i >= 0)
 484:	ff 4d f4             	decl   -0xc(%ebp)
 487:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48b:	79 db                	jns    468 <printint+0x89>
}
 48d:	c9                   	leave  
 48e:	c3                   	ret    

0000048f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 48f:	55                   	push   %ebp
 490:	89 e5                	mov    %esp,%ebp
 492:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 495:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49c:	8d 45 0c             	lea    0xc(%ebp),%eax
 49f:	83 c0 04             	add    $0x4,%eax
 4a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4ac:	e9 78 01 00 00       	jmp    629 <printf+0x19a>
    c = fmt[i] & 0xff;
 4b1:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4b7:	01 d0                	add    %edx,%eax
 4b9:	8a 00                	mov    (%eax),%al
 4bb:	0f be c0             	movsbl %al,%eax
 4be:	25 ff 00 00 00       	and    $0xff,%eax
 4c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ca:	75 2c                	jne    4f8 <printf+0x69>
      if(c == '%'){
 4cc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d0:	75 0c                	jne    4de <printf+0x4f>
        state = '%';
 4d2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4d9:	e9 48 01 00 00       	jmp    626 <printf+0x197>
      } else {
        putc(fd, c);
 4de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e1:	0f be c0             	movsbl %al,%eax
 4e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e8:	8b 45 08             	mov    0x8(%ebp),%eax
 4eb:	89 04 24             	mov    %eax,(%esp)
 4ee:	e8 c4 fe ff ff       	call   3b7 <putc>
 4f3:	e9 2e 01 00 00       	jmp    626 <printf+0x197>
      }
    } else if(state == '%'){
 4f8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4fc:	0f 85 24 01 00 00    	jne    626 <printf+0x197>
      if(c == 'd'){
 502:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 506:	75 2d                	jne    535 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 508:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50b:	8b 00                	mov    (%eax),%eax
 50d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 514:	00 
 515:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 51c:	00 
 51d:	89 44 24 04          	mov    %eax,0x4(%esp)
 521:	8b 45 08             	mov    0x8(%ebp),%eax
 524:	89 04 24             	mov    %eax,(%esp)
 527:	e8 b3 fe ff ff       	call   3df <printint>
        ap++;
 52c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 530:	e9 ea 00 00 00       	jmp    61f <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 535:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 539:	74 06                	je     541 <printf+0xb2>
 53b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 53f:	75 2d                	jne    56e <printf+0xdf>
        printint(fd, *ap, 16, 0);
 541:	8b 45 e8             	mov    -0x18(%ebp),%eax
 544:	8b 00                	mov    (%eax),%eax
 546:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 54d:	00 
 54e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 555:	00 
 556:	89 44 24 04          	mov    %eax,0x4(%esp)
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	89 04 24             	mov    %eax,(%esp)
 560:	e8 7a fe ff ff       	call   3df <printint>
        ap++;
 565:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 569:	e9 b1 00 00 00       	jmp    61f <printf+0x190>
      } else if(c == 's'){
 56e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 572:	75 43                	jne    5b7 <printf+0x128>
        s = (char*)*ap;
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 584:	75 25                	jne    5ab <printf+0x11c>
          s = "(null)";
 586:	c7 45 f4 7f 08 00 00 	movl   $0x87f,-0xc(%ebp)
        while(*s != 0){
 58d:	eb 1c                	jmp    5ab <printf+0x11c>
          putc(fd, *s);
 58f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 592:	8a 00                	mov    (%eax),%al
 594:	0f be c0             	movsbl %al,%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	8b 45 08             	mov    0x8(%ebp),%eax
 59e:	89 04 24             	mov    %eax,(%esp)
 5a1:	e8 11 fe ff ff       	call   3b7 <putc>
          s++;
 5a6:	ff 45 f4             	incl   -0xc(%ebp)
 5a9:	eb 01                	jmp    5ac <printf+0x11d>
        while(*s != 0){
 5ab:	90                   	nop
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	8a 00                	mov    (%eax),%al
 5b1:	84 c0                	test   %al,%al
 5b3:	75 da                	jne    58f <printf+0x100>
 5b5:	eb 68                	jmp    61f <printf+0x190>
        }
      } else if(c == 'c'){
 5b7:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5bb:	75 1d                	jne    5da <printf+0x14b>
        putc(fd, *ap);
 5bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	89 04 24             	mov    %eax,(%esp)
 5cf:	e8 e3 fd ff ff       	call   3b7 <putc>
        ap++;
 5d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d8:	eb 45                	jmp    61f <printf+0x190>
      } else if(c == '%'){
 5da:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5de:	75 17                	jne    5f7 <printf+0x168>
        putc(fd, c);
 5e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 c2 fd ff ff       	call   3b7 <putc>
 5f5:	eb 28                	jmp    61f <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5f7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5fe:	00 
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	89 04 24             	mov    %eax,(%esp)
 605:	e8 ad fd ff ff       	call   3b7 <putc>
        putc(fd, c);
 60a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 98 fd ff ff       	call   3b7 <putc>
      }
      state = 0;
 61f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 626:	ff 45 f0             	incl   -0x10(%ebp)
 629:	8b 55 0c             	mov    0xc(%ebp),%edx
 62c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	8a 00                	mov    (%eax),%al
 633:	84 c0                	test   %al,%al
 635:	0f 85 76 fe ff ff    	jne    4b1 <printf+0x22>
    }
  }
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	83 e8 08             	sub    $0x8,%eax
 649:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64c:	a1 e0 0a 00 00       	mov    0xae0,%eax
 651:	89 45 fc             	mov    %eax,-0x4(%ebp)
 654:	eb 24                	jmp    67a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65e:	77 12                	ja     672 <free+0x35>
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 666:	77 24                	ja     68c <free+0x4f>
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 670:	77 1a                	ja     68c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 680:	76 d4                	jbe    656 <free+0x19>
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68a:	76 ca                	jbe    656 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	8b 40 04             	mov    0x4(%eax),%eax
 692:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 699:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69c:	01 c2                	add    %eax,%edx
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	39 c2                	cmp    %eax,%edx
 6a5:	75 24                	jne    6cb <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	8b 10                	mov    (%eax),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	89 10                	mov    %edx,(%eax)
 6c9:	eb 0a                	jmp    6d5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 10                	mov    (%eax),%edx
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 40 04             	mov    0x4(%eax),%eax
 6db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ea:	75 20                	jne    70c <free+0xcf>
    p->s.size += bp->s.size;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 50 04             	mov    0x4(%eax),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	01 c2                	add    %eax,%edx
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 10                	mov    (%eax),%edx
 705:	8b 45 fc             	mov    -0x4(%ebp),%eax
 708:	89 10                	mov    %edx,(%eax)
 70a:	eb 08                	jmp    714 <free+0xd7>
  } else
    p->s.ptr = bp;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 712:	89 10                	mov    %edx,(%eax)
  freep = p;
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 71c:	c9                   	leave  
 71d:	c3                   	ret    

0000071e <morecore>:

static Header*
morecore(uint nu)
{
 71e:	55                   	push   %ebp
 71f:	89 e5                	mov    %esp,%ebp
 721:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 724:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72b:	77 07                	ja     734 <morecore+0x16>
    nu = 4096;
 72d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	c1 e0 03             	shl    $0x3,%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 05 fc ff ff       	call   347 <sbrk>
 742:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 745:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 749:	75 07                	jne    752 <morecore+0x34>
    return 0;
 74b:	b8 00 00 00 00       	mov    $0x0,%eax
 750:	eb 22                	jmp    774 <morecore+0x56>
  hp = (Header*)p;
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	8b 55 08             	mov    0x8(%ebp),%edx
 75e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 761:	8b 45 f0             	mov    -0x10(%ebp),%eax
 764:	83 c0 08             	add    $0x8,%eax
 767:	89 04 24             	mov    %eax,(%esp)
 76a:	e8 ce fe ff ff       	call   63d <free>
  return freep;
 76f:	a1 e0 0a 00 00       	mov    0xae0,%eax
}
 774:	c9                   	leave  
 775:	c3                   	ret    

00000776 <malloc>:

void*
malloc(uint nbytes)
{
 776:	55                   	push   %ebp
 777:	89 e5                	mov    %esp,%ebp
 779:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	83 c0 07             	add    $0x7,%eax
 782:	c1 e8 03             	shr    $0x3,%eax
 785:	40                   	inc    %eax
 786:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 789:	a1 e0 0a 00 00       	mov    0xae0,%eax
 78e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 795:	75 23                	jne    7ba <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 797:	c7 45 f0 d8 0a 00 00 	movl   $0xad8,-0x10(%ebp)
 79e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a1:	a3 e0 0a 00 00       	mov    %eax,0xae0
 7a6:	a1 e0 0a 00 00       	mov    0xae0,%eax
 7ab:	a3 d8 0a 00 00       	mov    %eax,0xad8
    base.s.size = 0;
 7b0:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 7b7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7cb:	72 4d                	jb     81a <malloc+0xa4>
      if(p->s.size == nunits)
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	8b 40 04             	mov    0x4(%eax),%eax
 7d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d6:	75 0c                	jne    7e4 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7db:	8b 10                	mov    (%eax),%edx
 7dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e0:	89 10                	mov    %edx,(%eax)
 7e2:	eb 26                	jmp    80a <malloc+0x94>
      else {
        p->s.size -= nunits;
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	89 c2                	mov    %eax,%edx
 7ec:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	c1 e0 03             	shl    $0x3,%eax
 7fe:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 55 ec             	mov    -0x14(%ebp),%edx
 807:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80d:	a3 e0 0a 00 00       	mov    %eax,0xae0
      return (void*)(p + 1);
 812:	8b 45 f4             	mov    -0xc(%ebp),%eax
 815:	83 c0 08             	add    $0x8,%eax
 818:	eb 38                	jmp    852 <malloc+0xdc>
    }
    if(p == freep)
 81a:	a1 e0 0a 00 00       	mov    0xae0,%eax
 81f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 822:	75 1b                	jne    83f <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 824:	8b 45 ec             	mov    -0x14(%ebp),%eax
 827:	89 04 24             	mov    %eax,(%esp)
 82a:	e8 ef fe ff ff       	call   71e <morecore>
 82f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 832:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 836:	75 07                	jne    83f <malloc+0xc9>
        return 0;
 838:	b8 00 00 00 00       	mov    $0x0,%eax
 83d:	eb 13                	jmp    852 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 842:	89 45 f0             	mov    %eax,-0x10(%ebp)
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 84d:	e9 70 ff ff ff       	jmp    7c2 <malloc+0x4c>
}
 852:	c9                   	leave  
 853:	c3                   	ret    
