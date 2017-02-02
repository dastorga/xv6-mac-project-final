
_echo:     formato del fichero elf32-i386


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

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 48                	jmp    5b <main+0x5b>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	40                   	inc    %eax
  18:	3b 45 08             	cmp    0x8(%ebp),%eax
  1b:	7d 07                	jge    24 <main+0x24>
  1d:	b8 ff 07 00 00       	mov    $0x7ff,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 01 08 00 00       	mov    $0x801,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 03 08 00 	movl   $0x803,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 e3 03 00 00       	call   43a <printf>
  for(i = 1; i < argc; i++)
  57:	ff 44 24 1c          	incl   0x1c(%esp)
  5b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  62:	7c af                	jl     13 <main+0x13>
  exit();
  64:	e8 49 02 00 00       	call   2b2 <exit>

00000069 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  69:	55                   	push   %ebp
  6a:	89 e5                	mov    %esp,%ebp
  6c:	57                   	push   %edi
  6d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  71:	8b 55 10             	mov    0x10(%ebp),%edx
  74:	8b 45 0c             	mov    0xc(%ebp),%eax
  77:	89 cb                	mov    %ecx,%ebx
  79:	89 df                	mov    %ebx,%edi
  7b:	89 d1                	mov    %edx,%ecx
  7d:	fc                   	cld    
  7e:	f3 aa                	rep stos %al,%es:(%edi)
  80:	89 ca                	mov    %ecx,%edx
  82:	89 fb                	mov    %edi,%ebx
  84:	89 5d 08             	mov    %ebx,0x8(%ebp)
  87:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8a:	5b                   	pop    %ebx
  8b:	5f                   	pop    %edi
  8c:	5d                   	pop    %ebp
  8d:	c3                   	ret    

0000008e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9a:	90                   	nop
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	8a 10                	mov    (%eax),%dl
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	88 10                	mov    %dl,(%eax)
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8a 00                	mov    (%eax),%al
  aa:	84 c0                	test   %al,%al
  ac:	0f 95 c0             	setne  %al
  af:	ff 45 08             	incl   0x8(%ebp)
  b2:	ff 45 0c             	incl   0xc(%ebp)
  b5:	84 c0                	test   %al,%al
  b7:	75 e2                	jne    9b <strcpy+0xd>
    ;
  return os;
  b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bc:	c9                   	leave  
  bd:	c3                   	ret    

000000be <strcmp>:

int
strcmp(const char *p, const char *q)
{
  be:	55                   	push   %ebp
  bf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c1:	eb 06                	jmp    c9 <strcmp+0xb>
    p++, q++;
  c3:	ff 45 08             	incl   0x8(%ebp)
  c6:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	8a 00                	mov    (%eax),%al
  ce:	84 c0                	test   %al,%al
  d0:	74 0e                	je     e0 <strcmp+0x22>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	8a 10                	mov    (%eax),%dl
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	8a 00                	mov    (%eax),%al
  dc:	38 c2                	cmp    %al,%dl
  de:	74 e3                	je     c3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	8a 00                	mov    (%eax),%al
  e5:	0f b6 d0             	movzbl %al,%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	8a 00                	mov    (%eax),%al
  ed:	0f b6 c0             	movzbl %al,%eax
  f0:	89 d1                	mov    %edx,%ecx
  f2:	29 c1                	sub    %eax,%ecx
  f4:	89 c8                	mov    %ecx,%eax
}
  f6:	5d                   	pop    %ebp
  f7:	c3                   	ret    

000000f8 <strlen>:

uint
strlen(char *s)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 105:	eb 03                	jmp    10a <strlen+0x12>
 107:	ff 45 fc             	incl   -0x4(%ebp)
 10a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	01 d0                	add    %edx,%eax
 112:	8a 00                	mov    (%eax),%al
 114:	84 c0                	test   %al,%al
 116:	75 ef                	jne    107 <strlen+0xf>
    ;
  return n;
 118:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11b:	c9                   	leave  
 11c:	c3                   	ret    

0000011d <memset>:

void*
memset(void *dst, int c, uint n)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 123:	8b 45 10             	mov    0x10(%ebp),%eax
 126:	89 44 24 08          	mov    %eax,0x8(%esp)
 12a:	8b 45 0c             	mov    0xc(%ebp),%eax
 12d:	89 44 24 04          	mov    %eax,0x4(%esp)
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	89 04 24             	mov    %eax,(%esp)
 137:	e8 2d ff ff ff       	call   69 <stosb>
  return dst;
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13f:	c9                   	leave  
 140:	c3                   	ret    

00000141 <strchr>:

char*
strchr(const char *s, char c)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 04             	sub    $0x4,%esp
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 14d:	eb 12                	jmp    161 <strchr+0x20>
    if(*s == c)
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	8a 00                	mov    (%eax),%al
 154:	3a 45 fc             	cmp    -0x4(%ebp),%al
 157:	75 05                	jne    15e <strchr+0x1d>
      return (char*)s;
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	eb 11                	jmp    16f <strchr+0x2e>
  for(; *s; s++)
 15e:	ff 45 08             	incl   0x8(%ebp)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	8a 00                	mov    (%eax),%al
 166:	84 c0                	test   %al,%al
 168:	75 e5                	jne    14f <strchr+0xe>
  return 0;
 16a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <gets>:

char*
gets(char *buf, int max)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
 174:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 177:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17e:	eb 42                	jmp    1c2 <gets+0x51>
    cc = read(0, &c, 1);
 180:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 187:	00 
 188:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18b:	89 44 24 04          	mov    %eax,0x4(%esp)
 18f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 196:	e8 2f 01 00 00       	call   2ca <read>
 19b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a2:	7e 29                	jle    1cd <gets+0x5c>
      break;
    buf[i++] = c;
 1a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	01 c2                	add    %eax,%edx
 1ac:	8a 45 ef             	mov    -0x11(%ebp),%al
 1af:	88 02                	mov    %al,(%edx)
 1b1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1b4:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b7:	3c 0a                	cmp    $0xa,%al
 1b9:	74 13                	je     1ce <gets+0x5d>
 1bb:	8a 45 ef             	mov    -0x11(%ebp),%al
 1be:	3c 0d                	cmp    $0xd,%al
 1c0:	74 0c                	je     1ce <gets+0x5d>
  for(i=0; i+1 < max; ){
 1c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c5:	40                   	inc    %eax
 1c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c9:	7c b5                	jl     180 <gets+0xf>
 1cb:	eb 01                	jmp    1ce <gets+0x5d>
      break;
 1cd:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	01 d0                	add    %edx,%eax
 1d6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1dc:	c9                   	leave  
 1dd:	c3                   	ret    

000001de <stat>:

int
stat(char *n, struct stat *st)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1eb:	00 
 1ec:	8b 45 08             	mov    0x8(%ebp),%eax
 1ef:	89 04 24             	mov    %eax,(%esp)
 1f2:	e8 fb 00 00 00       	call   2f2 <open>
 1f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fe:	79 07                	jns    207 <stat+0x29>
    return -1;
 200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 205:	eb 23                	jmp    22a <stat+0x4c>
  r = fstat(fd, st);
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	89 44 24 04          	mov    %eax,0x4(%esp)
 20e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 f1 00 00 00       	call   30a <fstat>
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21f:	89 04 24             	mov    %eax,(%esp)
 222:	e8 b3 00 00 00       	call   2da <close>
  return r;
 227:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <atoi>:

int
atoi(const char *s)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 239:	eb 21                	jmp    25c <atoi+0x30>
    n = n*10 + *s++ - '0';
 23b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23e:	89 d0                	mov    %edx,%eax
 240:	c1 e0 02             	shl    $0x2,%eax
 243:	01 d0                	add    %edx,%eax
 245:	d1 e0                	shl    %eax
 247:	89 c2                	mov    %eax,%edx
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	8a 00                	mov    (%eax),%al
 24e:	0f be c0             	movsbl %al,%eax
 251:	01 d0                	add    %edx,%eax
 253:	83 e8 30             	sub    $0x30,%eax
 256:	89 45 fc             	mov    %eax,-0x4(%ebp)
 259:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	8a 00                	mov    (%eax),%al
 261:	3c 2f                	cmp    $0x2f,%al
 263:	7e 09                	jle    26e <atoi+0x42>
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	8a 00                	mov    (%eax),%al
 26a:	3c 39                	cmp    $0x39,%al
 26c:	7e cd                	jle    23b <atoi+0xf>
  return n;
 26e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 271:	c9                   	leave  
 272:	c3                   	ret    

00000273 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 273:	55                   	push   %ebp
 274:	89 e5                	mov    %esp,%ebp
 276:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 27f:	8b 45 0c             	mov    0xc(%ebp),%eax
 282:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 285:	eb 10                	jmp    297 <memmove+0x24>
    *dst++ = *src++;
 287:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28a:	8a 10                	mov    (%eax),%dl
 28c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28f:	88 10                	mov    %dl,(%eax)
 291:	ff 45 fc             	incl   -0x4(%ebp)
 294:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 297:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 29b:	0f 9f c0             	setg   %al
 29e:	ff 4d 10             	decl   0x10(%ebp)
 2a1:	84 c0                	test   %al,%al
 2a3:	75 e2                	jne    287 <memmove+0x14>
  return vdst;
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a8:	c9                   	leave  
 2a9:	c3                   	ret    

000002aa <fork>:
 2aa:	b8 01 00 00 00       	mov    $0x1,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <exit>:
 2b2:	b8 02 00 00 00       	mov    $0x2,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <wait>:
 2ba:	b8 03 00 00 00       	mov    $0x3,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <pipe>:
 2c2:	b8 04 00 00 00       	mov    $0x4,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <read>:
 2ca:	b8 05 00 00 00       	mov    $0x5,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <write>:
 2d2:	b8 10 00 00 00       	mov    $0x10,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <close>:
 2da:	b8 15 00 00 00       	mov    $0x15,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <kill>:
 2e2:	b8 06 00 00 00       	mov    $0x6,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <exec>:
 2ea:	b8 07 00 00 00       	mov    $0x7,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <open>:
 2f2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <mknod>:
 2fa:	b8 11 00 00 00       	mov    $0x11,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <unlink>:
 302:	b8 12 00 00 00       	mov    $0x12,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <fstat>:
 30a:	b8 08 00 00 00       	mov    $0x8,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <link>:
 312:	b8 13 00 00 00       	mov    $0x13,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mkdir>:
 31a:	b8 14 00 00 00       	mov    $0x14,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <chdir>:
 322:	b8 09 00 00 00       	mov    $0x9,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <dup>:
 32a:	b8 0a 00 00 00       	mov    $0xa,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <getpid>:
 332:	b8 0b 00 00 00       	mov    $0xb,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <sbrk>:
 33a:	b8 0c 00 00 00       	mov    $0xc,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sleep>:
 342:	b8 0d 00 00 00       	mov    $0xd,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <uptime>:
 34a:	b8 0e 00 00 00       	mov    $0xe,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <lseek>:
 352:	b8 16 00 00 00       	mov    $0x16,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <isatty>:
 35a:	b8 17 00 00 00       	mov    $0x17,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 28             	sub    $0x28,%esp
 368:	8b 45 0c             	mov    0xc(%ebp),%eax
 36b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 375:	00 
 376:	8d 45 f4             	lea    -0xc(%ebp),%eax
 379:	89 44 24 04          	mov    %eax,0x4(%esp)
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	89 04 24             	mov    %eax,(%esp)
 383:	e8 4a ff ff ff       	call   2d2 <write>
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 390:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 397:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39b:	74 17                	je     3b4 <printint+0x2a>
 39d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a1:	79 11                	jns    3b4 <printint+0x2a>
    neg = 1;
 3a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ad:	f7 d8                	neg    %eax
 3af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b2:	eb 06                	jmp    3ba <printint+0x30>
  } else {
    x = xx;
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c7:	ba 00 00 00 00       	mov    $0x0,%edx
 3cc:	f7 f1                	div    %ecx
 3ce:	89 d0                	mov    %edx,%eax
 3d0:	8a 80 4c 0a 00 00    	mov    0xa4c(%eax),%al
 3d6:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3dc:	01 ca                	add    %ecx,%edx
 3de:	88 02                	mov    %al,(%edx)
 3e0:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3e3:	8b 55 10             	mov    0x10(%ebp),%edx
 3e6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ec:	ba 00 00 00 00       	mov    $0x0,%edx
 3f1:	f7 75 d4             	divl   -0x2c(%ebp)
 3f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fb:	75 c4                	jne    3c1 <printint+0x37>
  if(neg)
 3fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 401:	74 2c                	je     42f <printint+0xa5>
    buf[i++] = '-';
 403:	8d 55 dc             	lea    -0x24(%ebp),%edx
 406:	8b 45 f4             	mov    -0xc(%ebp),%eax
 409:	01 d0                	add    %edx,%eax
 40b:	c6 00 2d             	movb   $0x2d,(%eax)
 40e:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 411:	eb 1c                	jmp    42f <printint+0xa5>
    putc(fd, buf[i]);
 413:	8d 55 dc             	lea    -0x24(%ebp),%edx
 416:	8b 45 f4             	mov    -0xc(%ebp),%eax
 419:	01 d0                	add    %edx,%eax
 41b:	8a 00                	mov    (%eax),%al
 41d:	0f be c0             	movsbl %al,%eax
 420:	89 44 24 04          	mov    %eax,0x4(%esp)
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	89 04 24             	mov    %eax,(%esp)
 42a:	e8 33 ff ff ff       	call   362 <putc>
  while(--i >= 0)
 42f:	ff 4d f4             	decl   -0xc(%ebp)
 432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 436:	79 db                	jns    413 <printint+0x89>
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 440:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 447:	8d 45 0c             	lea    0xc(%ebp),%eax
 44a:	83 c0 04             	add    $0x4,%eax
 44d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 450:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 457:	e9 78 01 00 00       	jmp    5d4 <printf+0x19a>
    c = fmt[i] & 0xff;
 45c:	8b 55 0c             	mov    0xc(%ebp),%edx
 45f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 462:	01 d0                	add    %edx,%eax
 464:	8a 00                	mov    (%eax),%al
 466:	0f be c0             	movsbl %al,%eax
 469:	25 ff 00 00 00       	and    $0xff,%eax
 46e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 471:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 475:	75 2c                	jne    4a3 <printf+0x69>
      if(c == '%'){
 477:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47b:	75 0c                	jne    489 <printf+0x4f>
        state = '%';
 47d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 484:	e9 48 01 00 00       	jmp    5d1 <printf+0x197>
      } else {
        putc(fd, c);
 489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48c:	0f be c0             	movsbl %al,%eax
 48f:	89 44 24 04          	mov    %eax,0x4(%esp)
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	89 04 24             	mov    %eax,(%esp)
 499:	e8 c4 fe ff ff       	call   362 <putc>
 49e:	e9 2e 01 00 00       	jmp    5d1 <printf+0x197>
      }
    } else if(state == '%'){
 4a3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a7:	0f 85 24 01 00 00    	jne    5d1 <printf+0x197>
      if(c == 'd'){
 4ad:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b1:	75 2d                	jne    4e0 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b6:	8b 00                	mov    (%eax),%eax
 4b8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4bf:	00 
 4c0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c7:	00 
 4c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cc:	8b 45 08             	mov    0x8(%ebp),%eax
 4cf:	89 04 24             	mov    %eax,(%esp)
 4d2:	e8 b3 fe ff ff       	call   38a <printint>
        ap++;
 4d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4db:	e9 ea 00 00 00       	jmp    5ca <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4e0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e4:	74 06                	je     4ec <printf+0xb2>
 4e6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4ea:	75 2d                	jne    519 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ef:	8b 00                	mov    (%eax),%eax
 4f1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f8:	00 
 4f9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 500:	00 
 501:	89 44 24 04          	mov    %eax,0x4(%esp)
 505:	8b 45 08             	mov    0x8(%ebp),%eax
 508:	89 04 24             	mov    %eax,(%esp)
 50b:	e8 7a fe ff ff       	call   38a <printint>
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 b1 00 00 00       	jmp    5ca <printf+0x190>
      } else if(c == 's'){
 519:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51d:	75 43                	jne    562 <printf+0x128>
        s = (char*)*ap;
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 527:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52f:	75 25                	jne    556 <printf+0x11c>
          s = "(null)";
 531:	c7 45 f4 08 08 00 00 	movl   $0x808,-0xc(%ebp)
        while(*s != 0){
 538:	eb 1c                	jmp    556 <printf+0x11c>
          putc(fd, *s);
 53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53d:	8a 00                	mov    (%eax),%al
 53f:	0f be c0             	movsbl %al,%eax
 542:	89 44 24 04          	mov    %eax,0x4(%esp)
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	89 04 24             	mov    %eax,(%esp)
 54c:	e8 11 fe ff ff       	call   362 <putc>
          s++;
 551:	ff 45 f4             	incl   -0xc(%ebp)
 554:	eb 01                	jmp    557 <printf+0x11d>
        while(*s != 0){
 556:	90                   	nop
 557:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55a:	8a 00                	mov    (%eax),%al
 55c:	84 c0                	test   %al,%al
 55e:	75 da                	jne    53a <printf+0x100>
 560:	eb 68                	jmp    5ca <printf+0x190>
        }
      } else if(c == 'c'){
 562:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 566:	75 1d                	jne    585 <printf+0x14b>
        putc(fd, *ap);
 568:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56b:	8b 00                	mov    (%eax),%eax
 56d:	0f be c0             	movsbl %al,%eax
 570:	89 44 24 04          	mov    %eax,0x4(%esp)
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 e3 fd ff ff       	call   362 <putc>
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 583:	eb 45                	jmp    5ca <printf+0x190>
      } else if(c == '%'){
 585:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 589:	75 17                	jne    5a2 <printf+0x168>
        putc(fd, c);
 58b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58e:	0f be c0             	movsbl %al,%eax
 591:	89 44 24 04          	mov    %eax,0x4(%esp)
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	89 04 24             	mov    %eax,(%esp)
 59b:	e8 c2 fd ff ff       	call   362 <putc>
 5a0:	eb 28                	jmp    5ca <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a9:	00 
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	89 04 24             	mov    %eax,(%esp)
 5b0:	e8 ad fd ff ff       	call   362 <putc>
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	89 04 24             	mov    %eax,(%esp)
 5c5:	e8 98 fd ff ff       	call   362 <putc>
      }
      state = 0;
 5ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5d1:	ff 45 f0             	incl   -0x10(%ebp)
 5d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5da:	01 d0                	add    %edx,%eax
 5dc:	8a 00                	mov    (%eax),%al
 5de:	84 c0                	test   %al,%al
 5e0:	0f 85 76 fe ff ff    	jne    45c <printf+0x22>
    }
  }
}
 5e6:	c9                   	leave  
 5e7:	c3                   	ret    

000005e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	83 e8 08             	sub    $0x8,%eax
 5f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	a1 68 0a 00 00       	mov    0xa68,%eax
 5fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ff:	eb 24                	jmp    625 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 12                	ja     61d <free+0x35>
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 611:	77 24                	ja     637 <free+0x4f>
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61b:	77 1a                	ja     637 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	89 45 fc             	mov    %eax,-0x4(%ebp)
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	76 d4                	jbe    601 <free+0x19>
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 635:	76 ca                	jbe    601 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 40 04             	mov    0x4(%eax),%eax
 63d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	01 c2                	add    %eax,%edx
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	39 c2                	cmp    %eax,%edx
 650:	75 24                	jne    676 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	01 c2                	add    %eax,%edx
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
 674:	eb 0a                	jmp    680 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 10                	mov    (%eax),%edx
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 40 04             	mov    0x4(%eax),%eax
 686:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	01 d0                	add    %edx,%eax
 692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 695:	75 20                	jne    6b7 <free+0xcf>
    p->s.size += bp->s.size;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 50 04             	mov    0x4(%eax),%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	8b 40 04             	mov    0x4(%eax),%eax
 6a3:	01 c2                	add    %eax,%edx
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
 6b5:	eb 08                	jmp    6bf <free+0xd7>
  } else
    p->s.ptr = bp;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	a3 68 0a 00 00       	mov    %eax,0xa68
}
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    

000006c9 <morecore>:

static Header*
morecore(uint nu)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d6:	77 07                	ja     6df <morecore+0x16>
    nu = 4096;
 6d8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	c1 e0 03             	shl    $0x3,%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 4d fc ff ff       	call   33a <sbrk>
 6ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f4:	75 07                	jne    6fd <morecore+0x34>
    return 0;
 6f6:	b8 00 00 00 00       	mov    $0x0,%eax
 6fb:	eb 22                	jmp    71f <morecore+0x56>
  hp = (Header*)p;
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	8b 55 08             	mov    0x8(%ebp),%edx
 709:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	83 c0 08             	add    $0x8,%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 ce fe ff ff       	call   5e8 <free>
  return freep;
 71a:	a1 68 0a 00 00       	mov    0xa68,%eax
}
 71f:	c9                   	leave  
 720:	c3                   	ret    

00000721 <malloc>:

void*
malloc(uint nbytes)
{
 721:	55                   	push   %ebp
 722:	89 e5                	mov    %esp,%ebp
 724:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	83 c0 07             	add    $0x7,%eax
 72d:	c1 e8 03             	shr    $0x3,%eax
 730:	40                   	inc    %eax
 731:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 734:	a1 68 0a 00 00       	mov    0xa68,%eax
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 740:	75 23                	jne    765 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 742:	c7 45 f0 60 0a 00 00 	movl   $0xa60,-0x10(%ebp)
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	a3 68 0a 00 00       	mov    %eax,0xa68
 751:	a1 68 0a 00 00       	mov    0xa68,%eax
 756:	a3 60 0a 00 00       	mov    %eax,0xa60
    base.s.size = 0;
 75b:	c7 05 64 0a 00 00 00 	movl   $0x0,0xa64
 762:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 776:	72 4d                	jb     7c5 <malloc+0xa4>
      if(p->s.size == nunits)
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 781:	75 0c                	jne    78f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	89 10                	mov    %edx,(%eax)
 78d:	eb 26                	jmp    7b5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	89 c2                	mov    %eax,%edx
 797:	2b 55 ec             	sub    -0x14(%ebp),%edx
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	c1 e0 03             	shl    $0x3,%eax
 7a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	a3 68 0a 00 00       	mov    %eax,0xa68
      return (void*)(p + 1);
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	83 c0 08             	add    $0x8,%eax
 7c3:	eb 38                	jmp    7fd <malloc+0xdc>
    }
    if(p == freep)
 7c5:	a1 68 0a 00 00       	mov    0xa68,%eax
 7ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7cd:	75 1b                	jne    7ea <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d2:	89 04 24             	mov    %eax,(%esp)
 7d5:	e8 ef fe ff ff       	call   6c9 <morecore>
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e1:	75 07                	jne    7ea <malloc+0xc9>
        return 0;
 7e3:	b8 00 00 00 00       	mov    $0x0,%eax
 7e8:	eb 13                	jmp    7fd <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7f8:	e9 70 ff ff ff       	jmp    76d <malloc+0x4c>
}
 7fd:	c9                   	leave  
 7fe:	c3                   	ret    
