
_rm:     formato del fichero elf32-i386


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
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 34 08 00 	movl   $0x834,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 4c 04 00 00       	call   46f <printf>
    exit();
  23:	e8 af 02 00 00       	call   2d7 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 db 02 00 00       	call   327 <unlink>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 48 08 00 	movl   $0x848,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 f5 03 00 00       	call   46f <printf>
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

00000387 <procstat>:
 387:	b8 18 00 00 00       	mov    $0x18,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <set_priority>:
 38f:	b8 19 00 00 00       	mov    $0x19,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 397:	55                   	push   %ebp
 398:	89 e5                	mov    %esp,%ebp
 39a:	83 ec 28             	sub    $0x28,%esp
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3aa:	00 
 3ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	89 04 24             	mov    %eax,(%esp)
 3b8:	e8 3a ff ff ff       	call   2f7 <write>
}
 3bd:	c9                   	leave  
 3be:	c3                   	ret    

000003bf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3bf:	55                   	push   %ebp
 3c0:	89 e5                	mov    %esp,%ebp
 3c2:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d0:	74 17                	je     3e9 <printint+0x2a>
 3d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d6:	79 11                	jns    3e9 <printint+0x2a>
    neg = 1;
 3d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	f7 d8                	neg    %eax
 3e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e7:	eb 06                	jmp    3ef <printint+0x30>
  } else {
    x = xx;
 3e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fc:	ba 00 00 00 00       	mov    $0x0,%edx
 401:	f7 f1                	div    %ecx
 403:	89 d0                	mov    %edx,%eax
 405:	8a 80 a4 0a 00 00    	mov    0xaa4(%eax),%al
 40b:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 40e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 411:	01 ca                	add    %ecx,%edx
 413:	88 02                	mov    %al,(%edx)
 415:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 418:	8b 55 10             	mov    0x10(%ebp),%edx
 41b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 41e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 421:	ba 00 00 00 00       	mov    $0x0,%edx
 426:	f7 75 d4             	divl   -0x2c(%ebp)
 429:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 430:	75 c4                	jne    3f6 <printint+0x37>
  if(neg)
 432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 436:	74 2c                	je     464 <printint+0xa5>
    buf[i++] = '-';
 438:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	c6 00 2d             	movb   $0x2d,(%eax)
 443:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 446:	eb 1c                	jmp    464 <printint+0xa5>
    putc(fd, buf[i]);
 448:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	8a 00                	mov    (%eax),%al
 452:	0f be c0             	movsbl %al,%eax
 455:	89 44 24 04          	mov    %eax,0x4(%esp)
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	89 04 24             	mov    %eax,(%esp)
 45f:	e8 33 ff ff ff       	call   397 <putc>
  while(--i >= 0)
 464:	ff 4d f4             	decl   -0xc(%ebp)
 467:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46b:	79 db                	jns    448 <printint+0x89>
}
 46d:	c9                   	leave  
 46e:	c3                   	ret    

0000046f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 475:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47c:	8d 45 0c             	lea    0xc(%ebp),%eax
 47f:	83 c0 04             	add    $0x4,%eax
 482:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 485:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48c:	e9 78 01 00 00       	jmp    609 <printf+0x19a>
    c = fmt[i] & 0xff;
 491:	8b 55 0c             	mov    0xc(%ebp),%edx
 494:	8b 45 f0             	mov    -0x10(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	8a 00                	mov    (%eax),%al
 49b:	0f be c0             	movsbl %al,%eax
 49e:	25 ff 00 00 00       	and    $0xff,%eax
 4a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4aa:	75 2c                	jne    4d8 <printf+0x69>
      if(c == '%'){
 4ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b0:	75 0c                	jne    4be <printf+0x4f>
        state = '%';
 4b2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b9:	e9 48 01 00 00       	jmp    606 <printf+0x197>
      } else {
        putc(fd, c);
 4be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c1:	0f be c0             	movsbl %al,%eax
 4c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	89 04 24             	mov    %eax,(%esp)
 4ce:	e8 c4 fe ff ff       	call   397 <putc>
 4d3:	e9 2e 01 00 00       	jmp    606 <printf+0x197>
      }
    } else if(state == '%'){
 4d8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4dc:	0f 85 24 01 00 00    	jne    606 <printf+0x197>
      if(c == 'd'){
 4e2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e6:	75 2d                	jne    515 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f4:	00 
 4f5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fc:	00 
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	89 04 24             	mov    %eax,(%esp)
 507:	e8 b3 fe ff ff       	call   3bf <printint>
        ap++;
 50c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 510:	e9 ea 00 00 00       	jmp    5ff <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 515:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 519:	74 06                	je     521 <printf+0xb2>
 51b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51f:	75 2d                	jne    54e <printf+0xdf>
        printint(fd, *ap, 16, 0);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	8b 00                	mov    (%eax),%eax
 526:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52d:	00 
 52e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 535:	00 
 536:	89 44 24 04          	mov    %eax,0x4(%esp)
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	89 04 24             	mov    %eax,(%esp)
 540:	e8 7a fe ff ff       	call   3bf <printint>
        ap++;
 545:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 549:	e9 b1 00 00 00       	jmp    5ff <printf+0x190>
      } else if(c == 's'){
 54e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 552:	75 43                	jne    597 <printf+0x128>
        s = (char*)*ap;
 554:	8b 45 e8             	mov    -0x18(%ebp),%eax
 557:	8b 00                	mov    (%eax),%eax
 559:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 560:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 564:	75 25                	jne    58b <printf+0x11c>
          s = "(null)";
 566:	c7 45 f4 61 08 00 00 	movl   $0x861,-0xc(%ebp)
        while(*s != 0){
 56d:	eb 1c                	jmp    58b <printf+0x11c>
          putc(fd, *s);
 56f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 572:	8a 00                	mov    (%eax),%al
 574:	0f be c0             	movsbl %al,%eax
 577:	89 44 24 04          	mov    %eax,0x4(%esp)
 57b:	8b 45 08             	mov    0x8(%ebp),%eax
 57e:	89 04 24             	mov    %eax,(%esp)
 581:	e8 11 fe ff ff       	call   397 <putc>
          s++;
 586:	ff 45 f4             	incl   -0xc(%ebp)
 589:	eb 01                	jmp    58c <printf+0x11d>
        while(*s != 0){
 58b:	90                   	nop
 58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58f:	8a 00                	mov    (%eax),%al
 591:	84 c0                	test   %al,%al
 593:	75 da                	jne    56f <printf+0x100>
 595:	eb 68                	jmp    5ff <printf+0x190>
        }
      } else if(c == 'c'){
 597:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59b:	75 1d                	jne    5ba <printf+0x14b>
        putc(fd, *ap);
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	89 04 24             	mov    %eax,(%esp)
 5af:	e8 e3 fd ff ff       	call   397 <putc>
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b8:	eb 45                	jmp    5ff <printf+0x190>
      } else if(c == '%'){
 5ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5be:	75 17                	jne    5d7 <printf+0x168>
        putc(fd, c);
 5c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c3:	0f be c0             	movsbl %al,%eax
 5c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ca:	8b 45 08             	mov    0x8(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 c2 fd ff ff       	call   397 <putc>
 5d5:	eb 28                	jmp    5ff <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5de:	00 
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	89 04 24             	mov    %eax,(%esp)
 5e5:	e8 ad fd ff ff       	call   397 <putc>
        putc(fd, c);
 5ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	89 04 24             	mov    %eax,(%esp)
 5fa:	e8 98 fd ff ff       	call   397 <putc>
      }
      state = 0;
 5ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 606:	ff 45 f0             	incl   -0x10(%ebp)
 609:	8b 55 0c             	mov    0xc(%ebp),%edx
 60c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60f:	01 d0                	add    %edx,%eax
 611:	8a 00                	mov    (%eax),%al
 613:	84 c0                	test   %al,%al
 615:	0f 85 76 fe ff ff    	jne    491 <printf+0x22>
    }
  }
}
 61b:	c9                   	leave  
 61c:	c3                   	ret    

0000061d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61d:	55                   	push   %ebp
 61e:	89 e5                	mov    %esp,%ebp
 620:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	83 e8 08             	sub    $0x8,%eax
 629:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62c:	a1 c0 0a 00 00       	mov    0xac0,%eax
 631:	89 45 fc             	mov    %eax,-0x4(%ebp)
 634:	eb 24                	jmp    65a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63e:	77 12                	ja     652 <free+0x35>
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 646:	77 24                	ja     66c <free+0x4f>
 648:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64b:	8b 00                	mov    (%eax),%eax
 64d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 650:	77 1a                	ja     66c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 660:	76 d4                	jbe    636 <free+0x19>
 662:	8b 45 fc             	mov    -0x4(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66a:	76 ca                	jbe    636 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 66c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 679:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67c:	01 c2                	add    %eax,%edx
 67e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	39 c2                	cmp    %eax,%edx
 685:	75 24                	jne    6ab <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 687:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68a:	8b 50 04             	mov    0x4(%eax),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 00                	mov    (%eax),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	01 c2                	add    %eax,%edx
 697:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
 6a9:	eb 0a                	jmp    6b5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	01 d0                	add    %edx,%eax
 6c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ca:	75 20                	jne    6ec <free+0xcf>
    p->s.size += bp->s.size;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cf:	8b 50 04             	mov    0x4(%eax),%edx
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 40 04             	mov    0x4(%eax),%eax
 6d8:	01 c2                	add    %eax,%edx
 6da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	8b 10                	mov    (%eax),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	89 10                	mov    %edx,(%eax)
 6ea:	eb 08                	jmp    6f4 <free+0xd7>
  } else
    p->s.ptr = bp;
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f2:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	a3 c0 0a 00 00       	mov    %eax,0xac0
}
 6fc:	c9                   	leave  
 6fd:	c3                   	ret    

000006fe <morecore>:

static Header*
morecore(uint nu)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 704:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70b:	77 07                	ja     714 <morecore+0x16>
    nu = 4096;
 70d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 714:	8b 45 08             	mov    0x8(%ebp),%eax
 717:	c1 e0 03             	shl    $0x3,%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 3d fc ff ff       	call   35f <sbrk>
 722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 725:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 729:	75 07                	jne    732 <morecore+0x34>
    return 0;
 72b:	b8 00 00 00 00       	mov    $0x0,%eax
 730:	eb 22                	jmp    754 <morecore+0x56>
  hp = (Header*)p;
 732:	8b 45 f4             	mov    -0xc(%ebp),%eax
 735:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 738:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73b:	8b 55 08             	mov    0x8(%ebp),%edx
 73e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	83 c0 08             	add    $0x8,%eax
 747:	89 04 24             	mov    %eax,(%esp)
 74a:	e8 ce fe ff ff       	call   61d <free>
  return freep;
 74f:	a1 c0 0a 00 00       	mov    0xac0,%eax
}
 754:	c9                   	leave  
 755:	c3                   	ret    

00000756 <malloc>:

void*
malloc(uint nbytes)
{
 756:	55                   	push   %ebp
 757:	89 e5                	mov    %esp,%ebp
 759:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	83 c0 07             	add    $0x7,%eax
 762:	c1 e8 03             	shr    $0x3,%eax
 765:	40                   	inc    %eax
 766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 769:	a1 c0 0a 00 00       	mov    0xac0,%eax
 76e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 771:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 775:	75 23                	jne    79a <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 777:	c7 45 f0 b8 0a 00 00 	movl   $0xab8,-0x10(%ebp)
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	a3 c0 0a 00 00       	mov    %eax,0xac0
 786:	a1 c0 0a 00 00       	mov    0xac0,%eax
 78b:	a3 b8 0a 00 00       	mov    %eax,0xab8
    base.s.size = 0;
 790:	c7 05 bc 0a 00 00 00 	movl   $0x0,0xabc
 797:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	8b 00                	mov    (%eax),%eax
 79f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8b 40 04             	mov    0x4(%eax),%eax
 7a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ab:	72 4d                	jb     7fa <malloc+0xa4>
      if(p->s.size == nunits)
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 40 04             	mov    0x4(%eax),%eax
 7b3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b6:	75 0c                	jne    7c4 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	89 10                	mov    %edx,(%eax)
 7c2:	eb 26                	jmp    7ea <malloc+0x94>
      else {
        p->s.size -= nunits;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	89 c2                	mov    %eax,%edx
 7cc:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 40 04             	mov    0x4(%eax),%eax
 7db:	c1 e0 03             	shl    $0x3,%eax
 7de:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	a3 c0 0a 00 00       	mov    %eax,0xac0
      return (void*)(p + 1);
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	83 c0 08             	add    $0x8,%eax
 7f8:	eb 38                	jmp    832 <malloc+0xdc>
    }
    if(p == freep)
 7fa:	a1 c0 0a 00 00       	mov    0xac0,%eax
 7ff:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 802:	75 1b                	jne    81f <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 804:	8b 45 ec             	mov    -0x14(%ebp),%eax
 807:	89 04 24             	mov    %eax,(%esp)
 80a:	e8 ef fe ff ff       	call   6fe <morecore>
 80f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 816:	75 07                	jne    81f <malloc+0xc9>
        return 0;
 818:	b8 00 00 00 00       	mov    $0x0,%eax
 81d:	eb 13                	jmp    832 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	89 45 f0             	mov    %eax,-0x10(%ebp)
 825:	8b 45 f4             	mov    -0xc(%ebp),%eax
 828:	8b 00                	mov    (%eax),%eax
 82a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 82d:	e9 70 ff ff ff       	jmp    7a2 <malloc+0x4c>
}
 832:	c9                   	leave  
 833:	c3                   	ret    
