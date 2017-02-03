
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
   f:	c7 44 24 04 1c 08 00 	movl   $0x81c,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 34 04 00 00       	call   457 <printf>
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
  5d:	c7 44 24 04 32 08 00 	movl   $0x832,0x4(%esp)
  64:	00 
  65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6c:	e8 e6 03 00 00       	call   457 <printf>
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

0000037f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	83 ec 28             	sub    $0x28,%esp
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 38b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 392:	00 
 393:	8d 45 f4             	lea    -0xc(%ebp),%eax
 396:	89 44 24 04          	mov    %eax,0x4(%esp)
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	89 04 24             	mov    %eax,(%esp)
 3a0:	e8 3a ff ff ff       	call   2df <write>
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b8:	74 17                	je     3d1 <printint+0x2a>
 3ba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3be:	79 11                	jns    3d1 <printint+0x2a>
    neg = 1;
 3c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	f7 d8                	neg    %eax
 3cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3cf:	eb 06                	jmp    3d7 <printint+0x30>
  } else {
    x = xx;
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3de:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e4:	ba 00 00 00 00       	mov    $0x0,%edx
 3e9:	f7 f1                	div    %ecx
 3eb:	89 d0                	mov    %edx,%eax
 3ed:	8a 80 8c 0a 00 00    	mov    0xa8c(%eax),%al
 3f3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f9:	01 ca                	add    %ecx,%edx
 3fb:	88 02                	mov    %al,(%edx)
 3fd:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 400:	8b 55 10             	mov    0x10(%ebp),%edx
 403:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 406:	8b 45 ec             	mov    -0x14(%ebp),%eax
 409:	ba 00 00 00 00       	mov    $0x0,%edx
 40e:	f7 75 d4             	divl   -0x2c(%ebp)
 411:	89 45 ec             	mov    %eax,-0x14(%ebp)
 414:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 418:	75 c4                	jne    3de <printint+0x37>
  if(neg)
 41a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41e:	74 2c                	je     44c <printint+0xa5>
    buf[i++] = '-';
 420:	8d 55 dc             	lea    -0x24(%ebp),%edx
 423:	8b 45 f4             	mov    -0xc(%ebp),%eax
 426:	01 d0                	add    %edx,%eax
 428:	c6 00 2d             	movb   $0x2d,(%eax)
 42b:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 42e:	eb 1c                	jmp    44c <printint+0xa5>
    putc(fd, buf[i]);
 430:	8d 55 dc             	lea    -0x24(%ebp),%edx
 433:	8b 45 f4             	mov    -0xc(%ebp),%eax
 436:	01 d0                	add    %edx,%eax
 438:	8a 00                	mov    (%eax),%al
 43a:	0f be c0             	movsbl %al,%eax
 43d:	89 44 24 04          	mov    %eax,0x4(%esp)
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	89 04 24             	mov    %eax,(%esp)
 447:	e8 33 ff ff ff       	call   37f <putc>
  while(--i >= 0)
 44c:	ff 4d f4             	decl   -0xc(%ebp)
 44f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 453:	79 db                	jns    430 <printint+0x89>
}
 455:	c9                   	leave  
 456:	c3                   	ret    

00000457 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 457:	55                   	push   %ebp
 458:	89 e5                	mov    %esp,%ebp
 45a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 45d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 464:	8d 45 0c             	lea    0xc(%ebp),%eax
 467:	83 c0 04             	add    $0x4,%eax
 46a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 46d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 474:	e9 78 01 00 00       	jmp    5f1 <printf+0x19a>
    c = fmt[i] & 0xff;
 479:	8b 55 0c             	mov    0xc(%ebp),%edx
 47c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 47f:	01 d0                	add    %edx,%eax
 481:	8a 00                	mov    (%eax),%al
 483:	0f be c0             	movsbl %al,%eax
 486:	25 ff 00 00 00       	and    $0xff,%eax
 48b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 48e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 492:	75 2c                	jne    4c0 <printf+0x69>
      if(c == '%'){
 494:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 498:	75 0c                	jne    4a6 <printf+0x4f>
        state = '%';
 49a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a1:	e9 48 01 00 00       	jmp    5ee <printf+0x197>
      } else {
        putc(fd, c);
 4a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a9:	0f be c0             	movsbl %al,%eax
 4ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	89 04 24             	mov    %eax,(%esp)
 4b6:	e8 c4 fe ff ff       	call   37f <putc>
 4bb:	e9 2e 01 00 00       	jmp    5ee <printf+0x197>
      }
    } else if(state == '%'){
 4c0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c4:	0f 85 24 01 00 00    	jne    5ee <printf+0x197>
      if(c == 'd'){
 4ca:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ce:	75 2d                	jne    4fd <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d3:	8b 00                	mov    (%eax),%eax
 4d5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4dc:	00 
 4dd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4e4:	00 
 4e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 b3 fe ff ff       	call   3a7 <printint>
        ap++;
 4f4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f8:	e9 ea 00 00 00       	jmp    5e7 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4fd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 501:	74 06                	je     509 <printf+0xb2>
 503:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 507:	75 2d                	jne    536 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 509:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50c:	8b 00                	mov    (%eax),%eax
 50e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 515:	00 
 516:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 51d:	00 
 51e:	89 44 24 04          	mov    %eax,0x4(%esp)
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	89 04 24             	mov    %eax,(%esp)
 528:	e8 7a fe ff ff       	call   3a7 <printint>
        ap++;
 52d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 531:	e9 b1 00 00 00       	jmp    5e7 <printf+0x190>
      } else if(c == 's'){
 536:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 53a:	75 43                	jne    57f <printf+0x128>
        s = (char*)*ap;
 53c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 53f:	8b 00                	mov    (%eax),%eax
 541:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 544:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54c:	75 25                	jne    573 <printf+0x11c>
          s = "(null)";
 54e:	c7 45 f4 47 08 00 00 	movl   $0x847,-0xc(%ebp)
        while(*s != 0){
 555:	eb 1c                	jmp    573 <printf+0x11c>
          putc(fd, *s);
 557:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55a:	8a 00                	mov    (%eax),%al
 55c:	0f be c0             	movsbl %al,%eax
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 11 fe ff ff       	call   37f <putc>
          s++;
 56e:	ff 45 f4             	incl   -0xc(%ebp)
 571:	eb 01                	jmp    574 <printf+0x11d>
        while(*s != 0){
 573:	90                   	nop
 574:	8b 45 f4             	mov    -0xc(%ebp),%eax
 577:	8a 00                	mov    (%eax),%al
 579:	84 c0                	test   %al,%al
 57b:	75 da                	jne    557 <printf+0x100>
 57d:	eb 68                	jmp    5e7 <printf+0x190>
        }
      } else if(c == 'c'){
 57f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 583:	75 1d                	jne    5a2 <printf+0x14b>
        putc(fd, *ap);
 585:	8b 45 e8             	mov    -0x18(%ebp),%eax
 588:	8b 00                	mov    (%eax),%eax
 58a:	0f be c0             	movsbl %al,%eax
 58d:	89 44 24 04          	mov    %eax,0x4(%esp)
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	89 04 24             	mov    %eax,(%esp)
 597:	e8 e3 fd ff ff       	call   37f <putc>
        ap++;
 59c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a0:	eb 45                	jmp    5e7 <printf+0x190>
      } else if(c == '%'){
 5a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a6:	75 17                	jne    5bf <printf+0x168>
        putc(fd, c);
 5a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 c2 fd ff ff       	call   37f <putc>
 5bd:	eb 28                	jmp    5e7 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5bf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5c6:	00 
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 ad fd ff ff       	call   37f <putc>
        putc(fd, c);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f be c0             	movsbl %al,%eax
 5d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dc:	8b 45 08             	mov    0x8(%ebp),%eax
 5df:	89 04 24             	mov    %eax,(%esp)
 5e2:	e8 98 fd ff ff       	call   37f <putc>
      }
      state = 0;
 5e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5ee:	ff 45 f0             	incl   -0x10(%ebp)
 5f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f7:	01 d0                	add    %edx,%eax
 5f9:	8a 00                	mov    (%eax),%al
 5fb:	84 c0                	test   %al,%al
 5fd:	0f 85 76 fe ff ff    	jne    479 <printf+0x22>
    }
  }
}
 603:	c9                   	leave  
 604:	c3                   	ret    

00000605 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 605:	55                   	push   %ebp
 606:	89 e5                	mov    %esp,%ebp
 608:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	83 e8 08             	sub    $0x8,%eax
 611:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 614:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 619:	89 45 fc             	mov    %eax,-0x4(%ebp)
 61c:	eb 24                	jmp    642 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 626:	77 12                	ja     63a <free+0x35>
 628:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62e:	77 24                	ja     654 <free+0x4f>
 630:	8b 45 fc             	mov    -0x4(%ebp),%eax
 633:	8b 00                	mov    (%eax),%eax
 635:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 638:	77 1a                	ja     654 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 642:	8b 45 f8             	mov    -0x8(%ebp),%eax
 645:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 648:	76 d4                	jbe    61e <free+0x19>
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 652:	76 ca                	jbe    61e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	8b 40 04             	mov    0x4(%eax),%eax
 65a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	01 c2                	add    %eax,%edx
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	39 c2                	cmp    %eax,%edx
 66d:	75 24                	jne    693 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	8b 50 04             	mov    0x4(%eax),%edx
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	01 c2                	add    %eax,%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	8b 10                	mov    (%eax),%edx
 68c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68f:	89 10                	mov    %edx,(%eax)
 691:	eb 0a                	jmp    69d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 10                	mov    (%eax),%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 40 04             	mov    0x4(%eax),%eax
 6a3:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	01 d0                	add    %edx,%eax
 6af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b2:	75 20                	jne    6d4 <free+0xcf>
    p->s.size += bp->s.size;
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 50 04             	mov    0x4(%eax),%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	8b 40 04             	mov    0x4(%eax),%eax
 6c0:	01 c2                	add    %eax,%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cb:	8b 10                	mov    (%eax),%edx
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	89 10                	mov    %edx,(%eax)
 6d2:	eb 08                	jmp    6dc <free+0xd7>
  } else
    p->s.ptr = bp;
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6da:	89 10                	mov    %edx,(%eax)
  freep = p;
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 6e4:	c9                   	leave  
 6e5:	c3                   	ret    

000006e6 <morecore>:

static Header*
morecore(uint nu)
{
 6e6:	55                   	push   %ebp
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6ec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6f3:	77 07                	ja     6fc <morecore+0x16>
    nu = 4096;
 6f5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6fc:	8b 45 08             	mov    0x8(%ebp),%eax
 6ff:	c1 e0 03             	shl    $0x3,%eax
 702:	89 04 24             	mov    %eax,(%esp)
 705:	e8 3d fc ff ff       	call   347 <sbrk>
 70a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 70d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 711:	75 07                	jne    71a <morecore+0x34>
    return 0;
 713:	b8 00 00 00 00       	mov    $0x0,%eax
 718:	eb 22                	jmp    73c <morecore+0x56>
  hp = (Header*)p;
 71a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 720:	8b 45 f0             	mov    -0x10(%ebp),%eax
 723:	8b 55 08             	mov    0x8(%ebp),%edx
 726:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 729:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72c:	83 c0 08             	add    $0x8,%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 ce fe ff ff       	call   605 <free>
  return freep;
 737:	a1 a8 0a 00 00       	mov    0xaa8,%eax
}
 73c:	c9                   	leave  
 73d:	c3                   	ret    

0000073e <malloc>:

void*
malloc(uint nbytes)
{
 73e:	55                   	push   %ebp
 73f:	89 e5                	mov    %esp,%ebp
 741:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	83 c0 07             	add    $0x7,%eax
 74a:	c1 e8 03             	shr    $0x3,%eax
 74d:	40                   	inc    %eax
 74e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 751:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 756:	89 45 f0             	mov    %eax,-0x10(%ebp)
 759:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75d:	75 23                	jne    782 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 75f:	c7 45 f0 a0 0a 00 00 	movl   $0xaa0,-0x10(%ebp)
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	a3 a8 0a 00 00       	mov    %eax,0xaa8
 76e:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 773:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    base.s.size = 0;
 778:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 77f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 793:	72 4d                	jb     7e2 <malloc+0xa4>
      if(p->s.size == nunits)
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 40 04             	mov    0x4(%eax),%eax
 79b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79e:	75 0c                	jne    7ac <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 10                	mov    (%eax),%edx
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	89 10                	mov    %edx,(%eax)
 7aa:	eb 26                	jmp    7d2 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	89 c2                	mov    %eax,%edx
 7b4:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8b 40 04             	mov    0x4(%eax),%eax
 7c3:	c1 e0 03             	shl    $0x3,%eax
 7c6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7cf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	a3 a8 0a 00 00       	mov    %eax,0xaa8
      return (void*)(p + 1);
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	83 c0 08             	add    $0x8,%eax
 7e0:	eb 38                	jmp    81a <malloc+0xdc>
    }
    if(p == freep)
 7e2:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 7e7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ea:	75 1b                	jne    807 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ef:	89 04 24             	mov    %eax,(%esp)
 7f2:	e8 ef fe ff ff       	call   6e6 <morecore>
 7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7fe:	75 07                	jne    807 <malloc+0xc9>
        return 0;
 800:	b8 00 00 00 00       	mov    $0x0,%eax
 805:	eb 13                	jmp    81a <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 815:	e9 70 ff ff ff       	jmp    78a <malloc+0x4c>
}
 81a:	c9                   	leave  
 81b:	c3                   	ret    
