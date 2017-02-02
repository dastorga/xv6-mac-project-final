
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
   f:	c7 44 24 04 0c 08 00 	movl   $0x80c,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 24 04 00 00       	call   447 <printf>
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
  5d:	c7 44 24 04 22 08 00 	movl   $0x822,0x4(%esp)
  64:	00 
  65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6c:	e8 d6 03 00 00       	call   447 <printf>
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

0000036f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 28             	sub    $0x28,%esp
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 382:	00 
 383:	8d 45 f4             	lea    -0xc(%ebp),%eax
 386:	89 44 24 04          	mov    %eax,0x4(%esp)
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	89 04 24             	mov    %eax,(%esp)
 390:	e8 4a ff ff ff       	call   2df <write>
}
 395:	c9                   	leave  
 396:	c3                   	ret    

00000397 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 39d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3a8:	74 17                	je     3c1 <printint+0x2a>
 3aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ae:	79 11                	jns    3c1 <printint+0x2a>
    neg = 1;
 3b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	f7 d8                	neg    %eax
 3bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3bf:	eb 06                	jmp    3c7 <printint+0x30>
  } else {
    x = xx;
 3c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d4:	ba 00 00 00 00       	mov    $0x0,%edx
 3d9:	f7 f1                	div    %ecx
 3db:	89 d0                	mov    %edx,%eax
 3dd:	8a 80 7c 0a 00 00    	mov    0xa7c(%eax),%al
 3e3:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e9:	01 ca                	add    %ecx,%edx
 3eb:	88 02                	mov    %al,(%edx)
 3ed:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3f0:	8b 55 10             	mov    0x10(%ebp),%edx
 3f3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f9:	ba 00 00 00 00       	mov    $0x0,%edx
 3fe:	f7 75 d4             	divl   -0x2c(%ebp)
 401:	89 45 ec             	mov    %eax,-0x14(%ebp)
 404:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 408:	75 c4                	jne    3ce <printint+0x37>
  if(neg)
 40a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 40e:	74 2c                	je     43c <printint+0xa5>
    buf[i++] = '-';
 410:	8d 55 dc             	lea    -0x24(%ebp),%edx
 413:	8b 45 f4             	mov    -0xc(%ebp),%eax
 416:	01 d0                	add    %edx,%eax
 418:	c6 00 2d             	movb   $0x2d,(%eax)
 41b:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 41e:	eb 1c                	jmp    43c <printint+0xa5>
    putc(fd, buf[i]);
 420:	8d 55 dc             	lea    -0x24(%ebp),%edx
 423:	8b 45 f4             	mov    -0xc(%ebp),%eax
 426:	01 d0                	add    %edx,%eax
 428:	8a 00                	mov    (%eax),%al
 42a:	0f be c0             	movsbl %al,%eax
 42d:	89 44 24 04          	mov    %eax,0x4(%esp)
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	89 04 24             	mov    %eax,(%esp)
 437:	e8 33 ff ff ff       	call   36f <putc>
  while(--i >= 0)
 43c:	ff 4d f4             	decl   -0xc(%ebp)
 43f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 443:	79 db                	jns    420 <printint+0x89>
}
 445:	c9                   	leave  
 446:	c3                   	ret    

00000447 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 44d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 454:	8d 45 0c             	lea    0xc(%ebp),%eax
 457:	83 c0 04             	add    $0x4,%eax
 45a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 45d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 464:	e9 78 01 00 00       	jmp    5e1 <printf+0x19a>
    c = fmt[i] & 0xff;
 469:	8b 55 0c             	mov    0xc(%ebp),%edx
 46c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 46f:	01 d0                	add    %edx,%eax
 471:	8a 00                	mov    (%eax),%al
 473:	0f be c0             	movsbl %al,%eax
 476:	25 ff 00 00 00       	and    $0xff,%eax
 47b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 47e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 482:	75 2c                	jne    4b0 <printf+0x69>
      if(c == '%'){
 484:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 488:	75 0c                	jne    496 <printf+0x4f>
        state = '%';
 48a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 491:	e9 48 01 00 00       	jmp    5de <printf+0x197>
      } else {
        putc(fd, c);
 496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 499:	0f be c0             	movsbl %al,%eax
 49c:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a0:	8b 45 08             	mov    0x8(%ebp),%eax
 4a3:	89 04 24             	mov    %eax,(%esp)
 4a6:	e8 c4 fe ff ff       	call   36f <putc>
 4ab:	e9 2e 01 00 00       	jmp    5de <printf+0x197>
      }
    } else if(state == '%'){
 4b0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b4:	0f 85 24 01 00 00    	jne    5de <printf+0x197>
      if(c == 'd'){
 4ba:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4be:	75 2d                	jne    4ed <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c3:	8b 00                	mov    (%eax),%eax
 4c5:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4cc:	00 
 4cd:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d4:	00 
 4d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	89 04 24             	mov    %eax,(%esp)
 4df:	e8 b3 fe ff ff       	call   397 <printint>
        ap++;
 4e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4e8:	e9 ea 00 00 00       	jmp    5d7 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4ed:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f1:	74 06                	je     4f9 <printf+0xb2>
 4f3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4f7:	75 2d                	jne    526 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 505:	00 
 506:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 50d:	00 
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 7a fe ff ff       	call   397 <printint>
        ap++;
 51d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 521:	e9 b1 00 00 00       	jmp    5d7 <printf+0x190>
      } else if(c == 's'){
 526:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 52a:	75 43                	jne    56f <printf+0x128>
        s = (char*)*ap;
 52c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52f:	8b 00                	mov    (%eax),%eax
 531:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 534:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53c:	75 25                	jne    563 <printf+0x11c>
          s = "(null)";
 53e:	c7 45 f4 37 08 00 00 	movl   $0x837,-0xc(%ebp)
        while(*s != 0){
 545:	eb 1c                	jmp    563 <printf+0x11c>
          putc(fd, *s);
 547:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54a:	8a 00                	mov    (%eax),%al
 54c:	0f be c0             	movsbl %al,%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 11 fe ff ff       	call   36f <putc>
          s++;
 55e:	ff 45 f4             	incl   -0xc(%ebp)
 561:	eb 01                	jmp    564 <printf+0x11d>
        while(*s != 0){
 563:	90                   	nop
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	8a 00                	mov    (%eax),%al
 569:	84 c0                	test   %al,%al
 56b:	75 da                	jne    547 <printf+0x100>
 56d:	eb 68                	jmp    5d7 <printf+0x190>
        }
      } else if(c == 'c'){
 56f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 573:	75 1d                	jne    592 <printf+0x14b>
        putc(fd, *ap);
 575:	8b 45 e8             	mov    -0x18(%ebp),%eax
 578:	8b 00                	mov    (%eax),%eax
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 08             	mov    0x8(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 e3 fd ff ff       	call   36f <putc>
        ap++;
 58c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 590:	eb 45                	jmp    5d7 <printf+0x190>
      } else if(c == '%'){
 592:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 596:	75 17                	jne    5af <printf+0x168>
        putc(fd, c);
 598:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59b:	0f be c0             	movsbl %al,%eax
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	8b 45 08             	mov    0x8(%ebp),%eax
 5a5:	89 04 24             	mov    %eax,(%esp)
 5a8:	e8 c2 fd ff ff       	call   36f <putc>
 5ad:	eb 28                	jmp    5d7 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5af:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b6:	00 
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 ad fd ff ff       	call   36f <putc>
        putc(fd, c);
 5c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 98 fd ff ff       	call   36f <putc>
      }
      state = 0;
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5de:	ff 45 f0             	incl   -0x10(%ebp)
 5e1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e7:	01 d0                	add    %edx,%eax
 5e9:	8a 00                	mov    (%eax),%al
 5eb:	84 c0                	test   %al,%al
 5ed:	0f 85 76 fe ff ff    	jne    469 <printf+0x22>
    }
  }
}
 5f3:	c9                   	leave  
 5f4:	c3                   	ret    

000005f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f5:	55                   	push   %ebp
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	83 e8 08             	sub    $0x8,%eax
 601:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 604:	a1 98 0a 00 00       	mov    0xa98,%eax
 609:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60c:	eb 24                	jmp    632 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 616:	77 12                	ja     62a <free+0x35>
 618:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61e:	77 24                	ja     644 <free+0x4f>
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 628:	77 1a                	ja     644 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 632:	8b 45 f8             	mov    -0x8(%ebp),%eax
 635:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 638:	76 d4                	jbe    60e <free+0x19>
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 642:	76 ca                	jbe    60e <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	8b 40 04             	mov    0x4(%eax),%eax
 64a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 651:	8b 45 f8             	mov    -0x8(%ebp),%eax
 654:	01 c2                	add    %eax,%edx
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	39 c2                	cmp    %eax,%edx
 65d:	75 24                	jne    683 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 65f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 662:	8b 50 04             	mov    0x4(%eax),%edx
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	01 c2                	add    %eax,%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 10                	mov    %edx,(%eax)
 681:	eb 0a                	jmp    68d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 683:	8b 45 fc             	mov    -0x4(%ebp),%eax
 686:	8b 10                	mov    (%eax),%edx
 688:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 40 04             	mov    0x4(%eax),%eax
 693:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	01 d0                	add    %edx,%eax
 69f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a2:	75 20                	jne    6c4 <free+0xcf>
    p->s.size += bp->s.size;
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 50 04             	mov    0x4(%eax),%edx
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 40 04             	mov    0x4(%eax),%eax
 6b0:	01 c2                	add    %eax,%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bb:	8b 10                	mov    (%eax),%edx
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	89 10                	mov    %edx,(%eax)
 6c2:	eb 08                	jmp    6cc <free+0xd7>
  } else
    p->s.ptr = bp;
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ca:	89 10                	mov    %edx,(%eax)
  freep = p;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	a3 98 0a 00 00       	mov    %eax,0xa98
}
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    

000006d6 <morecore>:

static Header*
morecore(uint nu)
{
 6d6:	55                   	push   %ebp
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e3:	77 07                	ja     6ec <morecore+0x16>
    nu = 4096;
 6e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	c1 e0 03             	shl    $0x3,%eax
 6f2:	89 04 24             	mov    %eax,(%esp)
 6f5:	e8 4d fc ff ff       	call   347 <sbrk>
 6fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 701:	75 07                	jne    70a <morecore+0x34>
    return 0;
 703:	b8 00 00 00 00       	mov    $0x0,%eax
 708:	eb 22                	jmp    72c <morecore+0x56>
  hp = (Header*)p;
 70a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 710:	8b 45 f0             	mov    -0x10(%ebp),%eax
 713:	8b 55 08             	mov    0x8(%ebp),%edx
 716:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 719:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71c:	83 c0 08             	add    $0x8,%eax
 71f:	89 04 24             	mov    %eax,(%esp)
 722:	e8 ce fe ff ff       	call   5f5 <free>
  return freep;
 727:	a1 98 0a 00 00       	mov    0xa98,%eax
}
 72c:	c9                   	leave  
 72d:	c3                   	ret    

0000072e <malloc>:

void*
malloc(uint nbytes)
{
 72e:	55                   	push   %ebp
 72f:	89 e5                	mov    %esp,%ebp
 731:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	83 c0 07             	add    $0x7,%eax
 73a:	c1 e8 03             	shr    $0x3,%eax
 73d:	40                   	inc    %eax
 73e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 741:	a1 98 0a 00 00       	mov    0xa98,%eax
 746:	89 45 f0             	mov    %eax,-0x10(%ebp)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	75 23                	jne    772 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 74f:	c7 45 f0 90 0a 00 00 	movl   $0xa90,-0x10(%ebp)
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
 759:	a3 98 0a 00 00       	mov    %eax,0xa98
 75e:	a1 98 0a 00 00       	mov    0xa98,%eax
 763:	a3 90 0a 00 00       	mov    %eax,0xa90
    base.s.size = 0;
 768:	c7 05 94 0a 00 00 00 	movl   $0x0,0xa94
 76f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	8b 00                	mov    (%eax),%eax
 777:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 783:	72 4d                	jb     7d2 <malloc+0xa4>
      if(p->s.size == nunits)
 785:	8b 45 f4             	mov    -0xc(%ebp),%eax
 788:	8b 40 04             	mov    0x4(%eax),%eax
 78b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78e:	75 0c                	jne    79c <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 10                	mov    (%eax),%edx
 795:	8b 45 f0             	mov    -0x10(%ebp),%eax
 798:	89 10                	mov    %edx,(%eax)
 79a:	eb 26                	jmp    7c2 <malloc+0x94>
      else {
        p->s.size -= nunits;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	89 c2                	mov    %eax,%edx
 7a4:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	c1 e0 03             	shl    $0x3,%eax
 7b6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7bf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c5:	a3 98 0a 00 00       	mov    %eax,0xa98
      return (void*)(p + 1);
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	83 c0 08             	add    $0x8,%eax
 7d0:	eb 38                	jmp    80a <malloc+0xdc>
    }
    if(p == freep)
 7d2:	a1 98 0a 00 00       	mov    0xa98,%eax
 7d7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7da:	75 1b                	jne    7f7 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 ef fe ff ff       	call   6d6 <morecore>
 7e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ee:	75 07                	jne    7f7 <malloc+0xc9>
        return 0;
 7f0:	b8 00 00 00 00       	mov    $0x0,%eax
 7f5:	eb 13                	jmp    80a <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 805:	e9 70 ff ff ff       	jmp    77a <malloc+0x4c>
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    
