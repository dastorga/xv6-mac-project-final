
_mkdir:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 24 08 00 	movl   $0x824,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 3c 04 00 00       	call   45f <printf>
    exit();
  23:	e8 af 02 00 00       	call   2d7 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 f3 02 00 00       	call   33f <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 3b 08 00 	movl   $0x83b,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 e5 03 00 00       	call   45f <printf>
      break;
  7a:	eb 0d                	jmp    89 <main+0x89>
  for(i = 1; i < argc; i++){
  7c:	ff 44 24 1c          	incl   0x1c(%esp)
  80:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  84:	3b 45 08             	cmp    0x8(%ebp),%eax
  87:	7c a9                	jl     32 <main+0x32>
    }
  }

  exit();
  89:	e8 49 02 00 00       	call   2d7 <exit>

0000008e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	57                   	push   %edi
  92:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  96:	8b 55 10             	mov    0x10(%ebp),%edx
  99:	8b 45 0c             	mov    0xc(%ebp),%eax
  9c:	89 cb                	mov    %ecx,%ebx
  9e:	89 df                	mov    %ebx,%edi
  a0:	89 d1                	mov    %edx,%ecx
  a2:	fc                   	cld    
  a3:	f3 aa                	rep stos %al,%es:(%edi)
  a5:	89 ca                	mov    %ecx,%edx
  a7:	89 fb                	mov    %edi,%ebx
  a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ac:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  af:	5b                   	pop    %ebx
  b0:	5f                   	pop    %edi
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b3:	55                   	push   %ebp
  b4:	89 e5                	mov    %esp,%ebp
  b6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  bf:	90                   	nop
  c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  c3:	8a 10                	mov    (%eax),%dl
  c5:	8b 45 08             	mov    0x8(%ebp),%eax
  c8:	88 10                	mov    %dl,(%eax)
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	8a 00                	mov    (%eax),%al
  cf:	84 c0                	test   %al,%al
  d1:	0f 95 c0             	setne  %al
  d4:	ff 45 08             	incl   0x8(%ebp)
  d7:	ff 45 0c             	incl   0xc(%ebp)
  da:	84 c0                	test   %al,%al
  dc:	75 e2                	jne    c0 <strcpy+0xd>
    ;
  return os;
  de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e1:	c9                   	leave  
  e2:	c3                   	ret    

000000e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e6:	eb 06                	jmp    ee <strcmp+0xb>
    p++, q++;
  e8:	ff 45 08             	incl   0x8(%ebp)
  eb:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	8a 00                	mov    (%eax),%al
  f3:	84 c0                	test   %al,%al
  f5:	74 0e                	je     105 <strcmp+0x22>
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
  fa:	8a 10                	mov    (%eax),%dl
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	8a 00                	mov    (%eax),%al
 101:	38 c2                	cmp    %al,%dl
 103:	74 e3                	je     e8 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	8a 00                	mov    (%eax),%al
 10a:	0f b6 d0             	movzbl %al,%edx
 10d:	8b 45 0c             	mov    0xc(%ebp),%eax
 110:	8a 00                	mov    (%eax),%al
 112:	0f b6 c0             	movzbl %al,%eax
 115:	89 d1                	mov    %edx,%ecx
 117:	29 c1                	sub    %eax,%ecx
 119:	89 c8                	mov    %ecx,%eax
}
 11b:	5d                   	pop    %ebp
 11c:	c3                   	ret    

0000011d <strlen>:

uint
strlen(char *s)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 123:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12a:	eb 03                	jmp    12f <strlen+0x12>
 12c:	ff 45 fc             	incl   -0x4(%ebp)
 12f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	01 d0                	add    %edx,%eax
 137:	8a 00                	mov    (%eax),%al
 139:	84 c0                	test   %al,%al
 13b:	75 ef                	jne    12c <strlen+0xf>
    ;
  return n;
 13d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 140:	c9                   	leave  
 141:	c3                   	ret    

00000142 <memset>:

void*
memset(void *dst, int c, uint n)
{
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	89 44 24 04          	mov    %eax,0x4(%esp)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	89 04 24             	mov    %eax,(%esp)
 15c:	e8 2d ff ff ff       	call   8e <stosb>
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 12                	jmp    186 <strchr+0x20>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17c:	75 05                	jne    183 <strchr+0x1d>
      return (char*)s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	eb 11                	jmp    194 <strchr+0x2e>
  for(; *s; s++)
 183:	ff 45 08             	incl   0x8(%ebp)
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	8a 00                	mov    (%eax),%al
 18b:	84 c0                	test   %al,%al
 18d:	75 e5                	jne    174 <strchr+0xe>
  return 0;
 18f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <gets>:

char*
gets(char *buf, int max)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a3:	eb 42                	jmp    1e7 <gets+0x51>
    cc = read(0, &c, 1);
 1a5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ac:	00 
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bb:	e8 2f 01 00 00       	call   2ef <read>
 1c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c7:	7e 29                	jle    1f2 <gets+0x5c>
      break;
    buf[i++] = c;
 1c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	01 c2                	add    %eax,%edx
 1d1:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d4:	88 02                	mov    %al,(%edx)
 1d6:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1d9:	8a 45 ef             	mov    -0x11(%ebp),%al
 1dc:	3c 0a                	cmp    $0xa,%al
 1de:	74 13                	je     1f3 <gets+0x5d>
 1e0:	8a 45 ef             	mov    -0x11(%ebp),%al
 1e3:	3c 0d                	cmp    $0xd,%al
 1e5:	74 0c                	je     1f3 <gets+0x5d>
  for(i=0; i+1 < max; ){
 1e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ea:	40                   	inc    %eax
 1eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ee:	7c b5                	jl     1a5 <gets+0xf>
 1f0:	eb 01                	jmp    1f3 <gets+0x5d>
      break;
 1f2:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	01 d0                	add    %edx,%eax
 1fb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
 201:	c9                   	leave  
 202:	c3                   	ret    

00000203 <stat>:

int
stat(char *n, struct stat *st)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 209:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 210:	00 
 211:	8b 45 08             	mov    0x8(%ebp),%eax
 214:	89 04 24             	mov    %eax,(%esp)
 217:	e8 fb 00 00 00       	call   317 <open>
 21c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 223:	79 07                	jns    22c <stat+0x29>
    return -1;
 225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22a:	eb 23                	jmp    24f <stat+0x4c>
  r = fstat(fd, st);
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	89 44 24 04          	mov    %eax,0x4(%esp)
 233:	8b 45 f4             	mov    -0xc(%ebp),%eax
 236:	89 04 24             	mov    %eax,(%esp)
 239:	e8 f1 00 00 00       	call   32f <fstat>
 23e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 241:	8b 45 f4             	mov    -0xc(%ebp),%eax
 244:	89 04 24             	mov    %eax,(%esp)
 247:	e8 b3 00 00 00       	call   2ff <close>
  return r;
 24c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <atoi>:

int
atoi(const char *s)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 257:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25e:	eb 21                	jmp    281 <atoi+0x30>
    n = n*10 + *s++ - '0';
 260:	8b 55 fc             	mov    -0x4(%ebp),%edx
 263:	89 d0                	mov    %edx,%eax
 265:	c1 e0 02             	shl    $0x2,%eax
 268:	01 d0                	add    %edx,%eax
 26a:	d1 e0                	shl    %eax
 26c:	89 c2                	mov    %eax,%edx
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	8a 00                	mov    (%eax),%al
 273:	0f be c0             	movsbl %al,%eax
 276:	01 d0                	add    %edx,%eax
 278:	83 e8 30             	sub    $0x30,%eax
 27b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27e:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	8a 00                	mov    (%eax),%al
 286:	3c 2f                	cmp    $0x2f,%al
 288:	7e 09                	jle    293 <atoi+0x42>
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	8a 00                	mov    (%eax),%al
 28f:	3c 39                	cmp    $0x39,%al
 291:	7e cd                	jle    260 <atoi+0xf>
  return n;
 293:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2aa:	eb 10                	jmp    2bc <memmove+0x24>
    *dst++ = *src++;
 2ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2af:	8a 10                	mov    (%eax),%dl
 2b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b4:	88 10                	mov    %dl,(%eax)
 2b6:	ff 45 fc             	incl   -0x4(%ebp)
 2b9:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 2bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c0:	0f 9f c0             	setg   %al
 2c3:	ff 4d 10             	decl   0x10(%ebp)
 2c6:	84 c0                	test   %al,%al
 2c8:	75 e2                	jne    2ac <memmove+0x14>
  return vdst;
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cd:	c9                   	leave  
 2ce:	c3                   	ret    

000002cf <fork>:
 2cf:	b8 01 00 00 00       	mov    $0x1,%eax
 2d4:	cd 40                	int    $0x40
 2d6:	c3                   	ret    

000002d7 <exit>:
 2d7:	b8 02 00 00 00       	mov    $0x2,%eax
 2dc:	cd 40                	int    $0x40
 2de:	c3                   	ret    

000002df <wait>:
 2df:	b8 03 00 00 00       	mov    $0x3,%eax
 2e4:	cd 40                	int    $0x40
 2e6:	c3                   	ret    

000002e7 <pipe>:
 2e7:	b8 04 00 00 00       	mov    $0x4,%eax
 2ec:	cd 40                	int    $0x40
 2ee:	c3                   	ret    

000002ef <read>:
 2ef:	b8 05 00 00 00       	mov    $0x5,%eax
 2f4:	cd 40                	int    $0x40
 2f6:	c3                   	ret    

000002f7 <write>:
 2f7:	b8 10 00 00 00       	mov    $0x10,%eax
 2fc:	cd 40                	int    $0x40
 2fe:	c3                   	ret    

000002ff <close>:
 2ff:	b8 15 00 00 00       	mov    $0x15,%eax
 304:	cd 40                	int    $0x40
 306:	c3                   	ret    

00000307 <kill>:
 307:	b8 06 00 00 00       	mov    $0x6,%eax
 30c:	cd 40                	int    $0x40
 30e:	c3                   	ret    

0000030f <exec>:
 30f:	b8 07 00 00 00       	mov    $0x7,%eax
 314:	cd 40                	int    $0x40
 316:	c3                   	ret    

00000317 <open>:
 317:	b8 0f 00 00 00       	mov    $0xf,%eax
 31c:	cd 40                	int    $0x40
 31e:	c3                   	ret    

0000031f <mknod>:
 31f:	b8 11 00 00 00       	mov    $0x11,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <unlink>:
 327:	b8 12 00 00 00       	mov    $0x12,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <fstat>:
 32f:	b8 08 00 00 00       	mov    $0x8,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <link>:
 337:	b8 13 00 00 00       	mov    $0x13,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <mkdir>:
 33f:	b8 14 00 00 00       	mov    $0x14,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <chdir>:
 347:	b8 09 00 00 00       	mov    $0x9,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <dup>:
 34f:	b8 0a 00 00 00       	mov    $0xa,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <getpid>:
 357:	b8 0b 00 00 00       	mov    $0xb,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <sbrk>:
 35f:	b8 0c 00 00 00       	mov    $0xc,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <sleep>:
 367:	b8 0d 00 00 00       	mov    $0xd,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <uptime>:
 36f:	b8 0e 00 00 00       	mov    $0xe,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <lseek>:
 377:	b8 16 00 00 00       	mov    $0x16,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <isatty>:
 37f:	b8 17 00 00 00       	mov    $0x17,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 387:	55                   	push   %ebp
 388:	89 e5                	mov    %esp,%ebp
 38a:	83 ec 28             	sub    $0x28,%esp
 38d:	8b 45 0c             	mov    0xc(%ebp),%eax
 390:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 393:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39a:	00 
 39b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39e:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	89 04 24             	mov    %eax,(%esp)
 3a8:	e8 4a ff ff ff       	call   2f7 <write>
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c0:	74 17                	je     3d9 <printint+0x2a>
 3c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c6:	79 11                	jns    3d9 <printint+0x2a>
    neg = 1;
 3c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d2:	f7 d8                	neg    %eax
 3d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d7:	eb 06                	jmp    3df <printint+0x30>
  } else {
    x = xx;
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ec:	ba 00 00 00 00       	mov    $0x0,%edx
 3f1:	f7 f1                	div    %ecx
 3f3:	89 d0                	mov    %edx,%eax
 3f5:	8a 80 9c 0a 00 00    	mov    0xa9c(%eax),%al
 3fb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
 401:	01 ca                	add    %ecx,%edx
 403:	88 02                	mov    %al,(%edx)
 405:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 408:	8b 55 10             	mov    0x10(%ebp),%edx
 40b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 40e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 411:	ba 00 00 00 00       	mov    $0x0,%edx
 416:	f7 75 d4             	divl   -0x2c(%ebp)
 419:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 420:	75 c4                	jne    3e6 <printint+0x37>
  if(neg)
 422:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 426:	74 2c                	je     454 <printint+0xa5>
    buf[i++] = '-';
 428:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42e:	01 d0                	add    %edx,%eax
 430:	c6 00 2d             	movb   $0x2d,(%eax)
 433:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 436:	eb 1c                	jmp    454 <printint+0xa5>
    putc(fd, buf[i]);
 438:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	8a 00                	mov    (%eax),%al
 442:	0f be c0             	movsbl %al,%eax
 445:	89 44 24 04          	mov    %eax,0x4(%esp)
 449:	8b 45 08             	mov    0x8(%ebp),%eax
 44c:	89 04 24             	mov    %eax,(%esp)
 44f:	e8 33 ff ff ff       	call   387 <putc>
  while(--i >= 0)
 454:	ff 4d f4             	decl   -0xc(%ebp)
 457:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45b:	79 db                	jns    438 <printint+0x89>
}
 45d:	c9                   	leave  
 45e:	c3                   	ret    

0000045f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 465:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46c:	8d 45 0c             	lea    0xc(%ebp),%eax
 46f:	83 c0 04             	add    $0x4,%eax
 472:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47c:	e9 78 01 00 00       	jmp    5f9 <printf+0x19a>
    c = fmt[i] & 0xff;
 481:	8b 55 0c             	mov    0xc(%ebp),%edx
 484:	8b 45 f0             	mov    -0x10(%ebp),%eax
 487:	01 d0                	add    %edx,%eax
 489:	8a 00                	mov    (%eax),%al
 48b:	0f be c0             	movsbl %al,%eax
 48e:	25 ff 00 00 00       	and    $0xff,%eax
 493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 496:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49a:	75 2c                	jne    4c8 <printf+0x69>
      if(c == '%'){
 49c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a0:	75 0c                	jne    4ae <printf+0x4f>
        state = '%';
 4a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a9:	e9 48 01 00 00       	jmp    5f6 <printf+0x197>
      } else {
        putc(fd, c);
 4ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b1:	0f be c0             	movsbl %al,%eax
 4b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	89 04 24             	mov    %eax,(%esp)
 4be:	e8 c4 fe ff ff       	call   387 <putc>
 4c3:	e9 2e 01 00 00       	jmp    5f6 <printf+0x197>
      }
    } else if(state == '%'){
 4c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cc:	0f 85 24 01 00 00    	jne    5f6 <printf+0x197>
      if(c == 'd'){
 4d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d6:	75 2d                	jne    505 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4db:	8b 00                	mov    (%eax),%eax
 4dd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e4:	00 
 4e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4ec:	00 
 4ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	89 04 24             	mov    %eax,(%esp)
 4f7:	e8 b3 fe ff ff       	call   3af <printint>
        ap++;
 4fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 500:	e9 ea 00 00 00       	jmp    5ef <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 505:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 509:	74 06                	je     511 <printf+0xb2>
 50b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 50f:	75 2d                	jne    53e <printf+0xdf>
        printint(fd, *ap, 16, 0);
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 51d:	00 
 51e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 525:	00 
 526:	89 44 24 04          	mov    %eax,0x4(%esp)
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	89 04 24             	mov    %eax,(%esp)
 530:	e8 7a fe ff ff       	call   3af <printint>
        ap++;
 535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 539:	e9 b1 00 00 00       	jmp    5ef <printf+0x190>
      } else if(c == 's'){
 53e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 542:	75 43                	jne    587 <printf+0x128>
        s = (char*)*ap;
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	8b 00                	mov    (%eax),%eax
 549:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 554:	75 25                	jne    57b <printf+0x11c>
          s = "(null)";
 556:	c7 45 f4 57 08 00 00 	movl   $0x857,-0xc(%ebp)
        while(*s != 0){
 55d:	eb 1c                	jmp    57b <printf+0x11c>
          putc(fd, *s);
 55f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 562:	8a 00                	mov    (%eax),%al
 564:	0f be c0             	movsbl %al,%eax
 567:	89 44 24 04          	mov    %eax,0x4(%esp)
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	89 04 24             	mov    %eax,(%esp)
 571:	e8 11 fe ff ff       	call   387 <putc>
          s++;
 576:	ff 45 f4             	incl   -0xc(%ebp)
 579:	eb 01                	jmp    57c <printf+0x11d>
        while(*s != 0){
 57b:	90                   	nop
 57c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57f:	8a 00                	mov    (%eax),%al
 581:	84 c0                	test   %al,%al
 583:	75 da                	jne    55f <printf+0x100>
 585:	eb 68                	jmp    5ef <printf+0x190>
        }
      } else if(c == 'c'){
 587:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58b:	75 1d                	jne    5aa <printf+0x14b>
        putc(fd, *ap);
 58d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 590:	8b 00                	mov    (%eax),%eax
 592:	0f be c0             	movsbl %al,%eax
 595:	89 44 24 04          	mov    %eax,0x4(%esp)
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	89 04 24             	mov    %eax,(%esp)
 59f:	e8 e3 fd ff ff       	call   387 <putc>
        ap++;
 5a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a8:	eb 45                	jmp    5ef <printf+0x190>
      } else if(c == '%'){
 5aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ae:	75 17                	jne    5c7 <printf+0x168>
        putc(fd, c);
 5b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 c2 fd ff ff       	call   387 <putc>
 5c5:	eb 28                	jmp    5ef <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5ce:	00 
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 ad fd ff ff       	call   387 <putc>
        putc(fd, c);
 5da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e4:	8b 45 08             	mov    0x8(%ebp),%eax
 5e7:	89 04 24             	mov    %eax,(%esp)
 5ea:	e8 98 fd ff ff       	call   387 <putc>
      }
      state = 0;
 5ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f6:	ff 45 f0             	incl   -0x10(%ebp)
 5f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ff:	01 d0                	add    %edx,%eax
 601:	8a 00                	mov    (%eax),%al
 603:	84 c0                	test   %al,%al
 605:	0f 85 76 fe ff ff    	jne    481 <printf+0x22>
    }
  }
}
 60b:	c9                   	leave  
 60c:	c3                   	ret    

0000060d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60d:	55                   	push   %ebp
 60e:	89 e5                	mov    %esp,%ebp
 610:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	83 e8 08             	sub    $0x8,%eax
 619:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61c:	a1 b8 0a 00 00       	mov    0xab8,%eax
 621:	89 45 fc             	mov    %eax,-0x4(%ebp)
 624:	eb 24                	jmp    64a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62e:	77 12                	ja     642 <free+0x35>
 630:	8b 45 f8             	mov    -0x8(%ebp),%eax
 633:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 636:	77 24                	ja     65c <free+0x4f>
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63b:	8b 00                	mov    (%eax),%eax
 63d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 640:	77 1a                	ja     65c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 650:	76 d4                	jbe    626 <free+0x19>
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65a:	76 ca                	jbe    626 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 65c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65f:	8b 40 04             	mov    0x4(%eax),%eax
 662:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 669:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66c:	01 c2                	add    %eax,%edx
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	39 c2                	cmp    %eax,%edx
 675:	75 24                	jne    69b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	8b 50 04             	mov    0x4(%eax),%edx
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	8b 40 04             	mov    0x4(%eax),%eax
 685:	01 c2                	add    %eax,%edx
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	8b 10                	mov    (%eax),%edx
 694:	8b 45 f8             	mov    -0x8(%ebp),%eax
 697:	89 10                	mov    %edx,(%eax)
 699:	eb 0a                	jmp    6a5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 10                	mov    (%eax),%edx
 6a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 40 04             	mov    0x4(%eax),%eax
 6ab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	01 d0                	add    %edx,%eax
 6b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ba:	75 20                	jne    6dc <free+0xcf>
    p->s.size += bp->s.size;
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 50 04             	mov    0x4(%eax),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	8b 40 04             	mov    0x4(%eax),%eax
 6c8:	01 c2                	add    %eax,%edx
 6ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	8b 10                	mov    (%eax),%edx
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	89 10                	mov    %edx,(%eax)
 6da:	eb 08                	jmp    6e4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6df:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	a3 b8 0a 00 00       	mov    %eax,0xab8
}
 6ec:	c9                   	leave  
 6ed:	c3                   	ret    

000006ee <morecore>:

static Header*
morecore(uint nu)
{
 6ee:	55                   	push   %ebp
 6ef:	89 e5                	mov    %esp,%ebp
 6f1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fb:	77 07                	ja     704 <morecore+0x16>
    nu = 4096;
 6fd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 704:	8b 45 08             	mov    0x8(%ebp),%eax
 707:	c1 e0 03             	shl    $0x3,%eax
 70a:	89 04 24             	mov    %eax,(%esp)
 70d:	e8 4d fc ff ff       	call   35f <sbrk>
 712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 715:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 719:	75 07                	jne    722 <morecore+0x34>
    return 0;
 71b:	b8 00 00 00 00       	mov    $0x0,%eax
 720:	eb 22                	jmp    744 <morecore+0x56>
  hp = (Header*)p;
 722:	8b 45 f4             	mov    -0xc(%ebp),%eax
 725:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 728:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72b:	8b 55 08             	mov    0x8(%ebp),%edx
 72e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 731:	8b 45 f0             	mov    -0x10(%ebp),%eax
 734:	83 c0 08             	add    $0x8,%eax
 737:	89 04 24             	mov    %eax,(%esp)
 73a:	e8 ce fe ff ff       	call   60d <free>
  return freep;
 73f:	a1 b8 0a 00 00       	mov    0xab8,%eax
}
 744:	c9                   	leave  
 745:	c3                   	ret    

00000746 <malloc>:

void*
malloc(uint nbytes)
{
 746:	55                   	push   %ebp
 747:	89 e5                	mov    %esp,%ebp
 749:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
 74f:	83 c0 07             	add    $0x7,%eax
 752:	c1 e8 03             	shr    $0x3,%eax
 755:	40                   	inc    %eax
 756:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 759:	a1 b8 0a 00 00       	mov    0xab8,%eax
 75e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 761:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 765:	75 23                	jne    78a <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 767:	c7 45 f0 b0 0a 00 00 	movl   $0xab0,-0x10(%ebp)
 76e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 771:	a3 b8 0a 00 00       	mov    %eax,0xab8
 776:	a1 b8 0a 00 00       	mov    0xab8,%eax
 77b:	a3 b0 0a 00 00       	mov    %eax,0xab0
    base.s.size = 0;
 780:	c7 05 b4 0a 00 00 00 	movl   $0x0,0xab4
 787:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	8b 40 04             	mov    0x4(%eax),%eax
 798:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79b:	72 4d                	jb     7ea <malloc+0xa4>
      if(p->s.size == nunits)
 79d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a6:	75 0c                	jne    7b4 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	8b 10                	mov    (%eax),%edx
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	89 10                	mov    %edx,(%eax)
 7b2:	eb 26                	jmp    7da <malloc+0x94>
      else {
        p->s.size -= nunits;
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	89 c2                	mov    %eax,%edx
 7bc:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	c1 e0 03             	shl    $0x3,%eax
 7ce:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dd:	a3 b8 0a 00 00       	mov    %eax,0xab8
      return (void*)(p + 1);
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	83 c0 08             	add    $0x8,%eax
 7e8:	eb 38                	jmp    822 <malloc+0xdc>
    }
    if(p == freep)
 7ea:	a1 b8 0a 00 00       	mov    0xab8,%eax
 7ef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f2:	75 1b                	jne    80f <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f7:	89 04 24             	mov    %eax,(%esp)
 7fa:	e8 ef fe ff ff       	call   6ee <morecore>
 7ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 806:	75 07                	jne    80f <malloc+0xc9>
        return 0;
 808:	b8 00 00 00 00       	mov    $0x0,%eax
 80d:	eb 13                	jmp    822 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	89 45 f0             	mov    %eax,-0x10(%ebp)
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	8b 00                	mov    (%eax),%eax
 81a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 81d:	e9 70 ff ff ff       	jmp    792 <malloc+0x4c>
}
 822:	c9                   	leave  
 823:	c3                   	ret    
