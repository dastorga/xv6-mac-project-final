
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
  1d:	b8 0f 08 00 00       	mov    $0x80f,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 11 08 00 00       	mov    $0x811,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 13 08 00 	movl   $0x813,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 f3 03 00 00       	call   44a <printf>
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

00000362 <procstat>:
 362:	b8 18 00 00 00       	mov    $0x18,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <set_priority>:
 36a:	b8 19 00 00 00       	mov    $0x19,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 28             	sub    $0x28,%esp
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 37e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 385:	00 
 386:	8d 45 f4             	lea    -0xc(%ebp),%eax
 389:	89 44 24 04          	mov    %eax,0x4(%esp)
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	89 04 24             	mov    %eax,(%esp)
 393:	e8 3a ff ff ff       	call   2d2 <write>
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ab:	74 17                	je     3c4 <printint+0x2a>
 3ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b1:	79 11                	jns    3c4 <printint+0x2a>
    neg = 1;
 3b3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	f7 d8                	neg    %eax
 3bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c2:	eb 06                	jmp    3ca <printint+0x30>
  } else {
    x = xx;
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d7:	ba 00 00 00 00       	mov    $0x0,%edx
 3dc:	f7 f1                	div    %ecx
 3de:	89 d0                	mov    %edx,%eax
 3e0:	8a 80 5c 0a 00 00    	mov    0xa5c(%eax),%al
 3e6:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ec:	01 ca                	add    %ecx,%edx
 3ee:	88 02                	mov    %al,(%edx)
 3f0:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3f3:	8b 55 10             	mov    0x10(%ebp),%edx
 3f6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fc:	ba 00 00 00 00       	mov    $0x0,%edx
 401:	f7 75 d4             	divl   -0x2c(%ebp)
 404:	89 45 ec             	mov    %eax,-0x14(%ebp)
 407:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40b:	75 c4                	jne    3d1 <printint+0x37>
  if(neg)
 40d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 411:	74 2c                	je     43f <printint+0xa5>
    buf[i++] = '-';
 413:	8d 55 dc             	lea    -0x24(%ebp),%edx
 416:	8b 45 f4             	mov    -0xc(%ebp),%eax
 419:	01 d0                	add    %edx,%eax
 41b:	c6 00 2d             	movb   $0x2d,(%eax)
 41e:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 421:	eb 1c                	jmp    43f <printint+0xa5>
    putc(fd, buf[i]);
 423:	8d 55 dc             	lea    -0x24(%ebp),%edx
 426:	8b 45 f4             	mov    -0xc(%ebp),%eax
 429:	01 d0                	add    %edx,%eax
 42b:	8a 00                	mov    (%eax),%al
 42d:	0f be c0             	movsbl %al,%eax
 430:	89 44 24 04          	mov    %eax,0x4(%esp)
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	89 04 24             	mov    %eax,(%esp)
 43a:	e8 33 ff ff ff       	call   372 <putc>
  while(--i >= 0)
 43f:	ff 4d f4             	decl   -0xc(%ebp)
 442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 446:	79 db                	jns    423 <printint+0x89>
}
 448:	c9                   	leave  
 449:	c3                   	ret    

0000044a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 450:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 457:	8d 45 0c             	lea    0xc(%ebp),%eax
 45a:	83 c0 04             	add    $0x4,%eax
 45d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 467:	e9 78 01 00 00       	jmp    5e4 <printf+0x19a>
    c = fmt[i] & 0xff;
 46c:	8b 55 0c             	mov    0xc(%ebp),%edx
 46f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 472:	01 d0                	add    %edx,%eax
 474:	8a 00                	mov    (%eax),%al
 476:	0f be c0             	movsbl %al,%eax
 479:	25 ff 00 00 00       	and    $0xff,%eax
 47e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 481:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 485:	75 2c                	jne    4b3 <printf+0x69>
      if(c == '%'){
 487:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48b:	75 0c                	jne    499 <printf+0x4f>
        state = '%';
 48d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 494:	e9 48 01 00 00       	jmp    5e1 <printf+0x197>
      } else {
        putc(fd, c);
 499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49c:	0f be c0             	movsbl %al,%eax
 49f:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	89 04 24             	mov    %eax,(%esp)
 4a9:	e8 c4 fe ff ff       	call   372 <putc>
 4ae:	e9 2e 01 00 00       	jmp    5e1 <printf+0x197>
      }
    } else if(state == '%'){
 4b3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b7:	0f 85 24 01 00 00    	jne    5e1 <printf+0x197>
      if(c == 'd'){
 4bd:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c1:	75 2d                	jne    4f0 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c6:	8b 00                	mov    (%eax),%eax
 4c8:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4cf:	00 
 4d0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d7:	00 
 4d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	89 04 24             	mov    %eax,(%esp)
 4e2:	e8 b3 fe ff ff       	call   39a <printint>
        ap++;
 4e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4eb:	e9 ea 00 00 00       	jmp    5da <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f4:	74 06                	je     4fc <printf+0xb2>
 4f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fa:	75 2d                	jne    529 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ff:	8b 00                	mov    (%eax),%eax
 501:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 508:	00 
 509:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 510:	00 
 511:	89 44 24 04          	mov    %eax,0x4(%esp)
 515:	8b 45 08             	mov    0x8(%ebp),%eax
 518:	89 04 24             	mov    %eax,(%esp)
 51b:	e8 7a fe ff ff       	call   39a <printint>
        ap++;
 520:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 524:	e9 b1 00 00 00       	jmp    5da <printf+0x190>
      } else if(c == 's'){
 529:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 52d:	75 43                	jne    572 <printf+0x128>
        s = (char*)*ap;
 52f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 532:	8b 00                	mov    (%eax),%eax
 534:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 537:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 53b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53f:	75 25                	jne    566 <printf+0x11c>
          s = "(null)";
 541:	c7 45 f4 18 08 00 00 	movl   $0x818,-0xc(%ebp)
        while(*s != 0){
 548:	eb 1c                	jmp    566 <printf+0x11c>
          putc(fd, *s);
 54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54d:	8a 00                	mov    (%eax),%al
 54f:	0f be c0             	movsbl %al,%eax
 552:	89 44 24 04          	mov    %eax,0x4(%esp)
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	89 04 24             	mov    %eax,(%esp)
 55c:	e8 11 fe ff ff       	call   372 <putc>
          s++;
 561:	ff 45 f4             	incl   -0xc(%ebp)
 564:	eb 01                	jmp    567 <printf+0x11d>
        while(*s != 0){
 566:	90                   	nop
 567:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56a:	8a 00                	mov    (%eax),%al
 56c:	84 c0                	test   %al,%al
 56e:	75 da                	jne    54a <printf+0x100>
 570:	eb 68                	jmp    5da <printf+0x190>
        }
      } else if(c == 'c'){
 572:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 576:	75 1d                	jne    595 <printf+0x14b>
        putc(fd, *ap);
 578:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57b:	8b 00                	mov    (%eax),%eax
 57d:	0f be c0             	movsbl %al,%eax
 580:	89 44 24 04          	mov    %eax,0x4(%esp)
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 e3 fd ff ff       	call   372 <putc>
        ap++;
 58f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 593:	eb 45                	jmp    5da <printf+0x190>
      } else if(c == '%'){
 595:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 599:	75 17                	jne    5b2 <printf+0x168>
        putc(fd, c);
 59b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	89 04 24             	mov    %eax,(%esp)
 5ab:	e8 c2 fd ff ff       	call   372 <putc>
 5b0:	eb 28                	jmp    5da <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5b9:	00 
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	89 04 24             	mov    %eax,(%esp)
 5c0:	e8 ad fd ff ff       	call   372 <putc>
        putc(fd, c);
 5c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 98 fd ff ff       	call   372 <putc>
      }
      state = 0;
 5da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5e1:	ff 45 f0             	incl   -0x10(%ebp)
 5e4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ea:	01 d0                	add    %edx,%eax
 5ec:	8a 00                	mov    (%eax),%al
 5ee:	84 c0                	test   %al,%al
 5f0:	0f 85 76 fe ff ff    	jne    46c <printf+0x22>
    }
  }
}
 5f6:	c9                   	leave  
 5f7:	c3                   	ret    

000005f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f8:	55                   	push   %ebp
 5f9:	89 e5                	mov    %esp,%ebp
 5fb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	83 e8 08             	sub    $0x8,%eax
 604:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 607:	a1 78 0a 00 00       	mov    0xa78,%eax
 60c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60f:	eb 24                	jmp    635 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 611:	8b 45 fc             	mov    -0x4(%ebp),%eax
 614:	8b 00                	mov    (%eax),%eax
 616:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 619:	77 12                	ja     62d <free+0x35>
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 621:	77 24                	ja     647 <free+0x4f>
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62b:	77 1a                	ja     647 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	89 45 fc             	mov    %eax,-0x4(%ebp)
 635:	8b 45 f8             	mov    -0x8(%ebp),%eax
 638:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63b:	76 d4                	jbe    611 <free+0x19>
 63d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 645:	76 ca                	jbe    611 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 647:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64a:	8b 40 04             	mov    0x4(%eax),%eax
 64d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	01 c2                	add    %eax,%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	39 c2                	cmp    %eax,%edx
 660:	75 24                	jne    686 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	8b 50 04             	mov    0x4(%eax),%edx
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 40 04             	mov    0x4(%eax),%eax
 670:	01 c2                	add    %eax,%edx
 672:	8b 45 f8             	mov    -0x8(%ebp),%eax
 675:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 00                	mov    (%eax),%eax
 67d:	8b 10                	mov    (%eax),%edx
 67f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 682:	89 10                	mov    %edx,(%eax)
 684:	eb 0a                	jmp    690 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 686:	8b 45 fc             	mov    -0x4(%ebp),%eax
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 690:	8b 45 fc             	mov    -0x4(%ebp),%eax
 693:	8b 40 04             	mov    0x4(%eax),%eax
 696:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	01 d0                	add    %edx,%eax
 6a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a5:	75 20                	jne    6c7 <free+0xcf>
    p->s.size += bp->s.size;
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	8b 50 04             	mov    0x4(%eax),%edx
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	8b 40 04             	mov    0x4(%eax),%eax
 6b3:	01 c2                	add    %eax,%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6be:	8b 10                	mov    (%eax),%edx
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	89 10                	mov    %edx,(%eax)
 6c5:	eb 08                	jmp    6cf <free+0xd7>
  } else
    p->s.ptr = bp;
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	a3 78 0a 00 00       	mov    %eax,0xa78
}
 6d7:	c9                   	leave  
 6d8:	c3                   	ret    

000006d9 <morecore>:

static Header*
morecore(uint nu)
{
 6d9:	55                   	push   %ebp
 6da:	89 e5                	mov    %esp,%ebp
 6dc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6df:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e6:	77 07                	ja     6ef <morecore+0x16>
    nu = 4096;
 6e8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	c1 e0 03             	shl    $0x3,%eax
 6f5:	89 04 24             	mov    %eax,(%esp)
 6f8:	e8 3d fc ff ff       	call   33a <sbrk>
 6fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 700:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 704:	75 07                	jne    70d <morecore+0x34>
    return 0;
 706:	b8 00 00 00 00       	mov    $0x0,%eax
 70b:	eb 22                	jmp    72f <morecore+0x56>
  hp = (Header*)p;
 70d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 710:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	8b 55 08             	mov    0x8(%ebp),%edx
 719:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71f:	83 c0 08             	add    $0x8,%eax
 722:	89 04 24             	mov    %eax,(%esp)
 725:	e8 ce fe ff ff       	call   5f8 <free>
  return freep;
 72a:	a1 78 0a 00 00       	mov    0xa78,%eax
}
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <malloc>:

void*
malloc(uint nbytes)
{
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	83 c0 07             	add    $0x7,%eax
 73d:	c1 e8 03             	shr    $0x3,%eax
 740:	40                   	inc    %eax
 741:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 744:	a1 78 0a 00 00       	mov    0xa78,%eax
 749:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 750:	75 23                	jne    775 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 752:	c7 45 f0 70 0a 00 00 	movl   $0xa70,-0x10(%ebp)
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	a3 78 0a 00 00       	mov    %eax,0xa78
 761:	a1 78 0a 00 00       	mov    0xa78,%eax
 766:	a3 70 0a 00 00       	mov    %eax,0xa70
    base.s.size = 0;
 76b:	c7 05 74 0a 00 00 00 	movl   $0x0,0xa74
 772:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 775:	8b 45 f0             	mov    -0x10(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	8b 40 04             	mov    0x4(%eax),%eax
 783:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 786:	72 4d                	jb     7d5 <malloc+0xa4>
      if(p->s.size == nunits)
 788:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 791:	75 0c                	jne    79f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 793:	8b 45 f4             	mov    -0xc(%ebp),%eax
 796:	8b 10                	mov    (%eax),%edx
 798:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79b:	89 10                	mov    %edx,(%eax)
 79d:	eb 26                	jmp    7c5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	89 c2                	mov    %eax,%edx
 7a7:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	8b 40 04             	mov    0x4(%eax),%eax
 7b6:	c1 e0 03             	shl    $0x3,%eax
 7b9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	a3 78 0a 00 00       	mov    %eax,0xa78
      return (void*)(p + 1);
 7cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d0:	83 c0 08             	add    $0x8,%eax
 7d3:	eb 38                	jmp    80d <malloc+0xdc>
    }
    if(p == freep)
 7d5:	a1 78 0a 00 00       	mov    0xa78,%eax
 7da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7dd:	75 1b                	jne    7fa <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 ef fe ff ff       	call   6d9 <morecore>
 7ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f1:	75 07                	jne    7fa <malloc+0xc9>
        return 0;
 7f3:	b8 00 00 00 00       	mov    $0x0,%eax
 7f8:	eb 13                	jmp    80d <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 00                	mov    (%eax),%eax
 805:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 808:	e9 70 ff ff ff       	jmp    77d <malloc+0x4c>
}
 80d:	c9                   	leave  
 80e:	c3                   	ret    
