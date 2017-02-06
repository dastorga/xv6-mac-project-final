
_ln:     formato del fichero elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 57 08 00 	movl   $0x857,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 6f 04 00 00       	call   492 <printf>
    exit();
  23:	e8 9a 02 00 00       	call   2c2 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 de 02 00 00       	call   322 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 6a 08 00 	movl   $0x86a,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 1e 04 00 00       	call   492 <printf>
  exit();
  74:	e8 49 02 00 00       	call   2c2 <exit>

00000079 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  79:	55                   	push   %ebp
  7a:	89 e5                	mov    %esp,%ebp
  7c:	57                   	push   %edi
  7d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 10             	mov    0x10(%ebp),%edx
  84:	8b 45 0c             	mov    0xc(%ebp),%eax
  87:	89 cb                	mov    %ecx,%ebx
  89:	89 df                	mov    %ebx,%edi
  8b:	89 d1                	mov    %edx,%ecx
  8d:	fc                   	cld    
  8e:	f3 aa                	rep stos %al,%es:(%edi)
  90:	89 ca                	mov    %ecx,%edx
  92:	89 fb                	mov    %edi,%ebx
  94:	89 5d 08             	mov    %ebx,0x8(%ebp)
  97:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9a:	5b                   	pop    %ebx
  9b:	5f                   	pop    %edi
  9c:	5d                   	pop    %ebp
  9d:	c3                   	ret    

0000009e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9e:	55                   	push   %ebp
  9f:	89 e5                	mov    %esp,%ebp
  a1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  aa:	90                   	nop
  ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  ae:	8a 10                	mov    (%eax),%dl
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	88 10                	mov    %dl,(%eax)
  b5:	8b 45 08             	mov    0x8(%ebp),%eax
  b8:	8a 00                	mov    (%eax),%al
  ba:	84 c0                	test   %al,%al
  bc:	0f 95 c0             	setne  %al
  bf:	ff 45 08             	incl   0x8(%ebp)
  c2:	ff 45 0c             	incl   0xc(%ebp)
  c5:	84 c0                	test   %al,%al
  c7:	75 e2                	jne    ab <strcpy+0xd>
    ;
  return os;
  c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cc:	c9                   	leave  
  cd:	c3                   	ret    

000000ce <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ce:	55                   	push   %ebp
  cf:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d1:	eb 06                	jmp    d9 <strcmp+0xb>
    p++, q++;
  d3:	ff 45 08             	incl   0x8(%ebp)
  d6:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  d9:	8b 45 08             	mov    0x8(%ebp),%eax
  dc:	8a 00                	mov    (%eax),%al
  de:	84 c0                	test   %al,%al
  e0:	74 0e                	je     f0 <strcmp+0x22>
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	8a 10                	mov    (%eax),%dl
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	8a 00                	mov    (%eax),%al
  ec:	38 c2                	cmp    %al,%dl
  ee:	74 e3                	je     d3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	8a 00                	mov    (%eax),%al
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	8a 00                	mov    (%eax),%al
  fd:	0f b6 c0             	movzbl %al,%eax
 100:	89 d1                	mov    %edx,%ecx
 102:	29 c1                	sub    %eax,%ecx
 104:	89 c8                	mov    %ecx,%eax
}
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    

00000108 <strlen>:

uint
strlen(char *s)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 115:	eb 03                	jmp    11a <strlen+0x12>
 117:	ff 45 fc             	incl   -0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	8a 00                	mov    (%eax),%al
 124:	84 c0                	test   %al,%al
 126:	75 ef                	jne    117 <strlen+0xf>
    ;
  return n;
 128:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <memset>:

void*
memset(void *dst, int c, uint n)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	89 44 24 08          	mov    %eax,0x8(%esp)
 13a:	8b 45 0c             	mov    0xc(%ebp),%eax
 13d:	89 44 24 04          	mov    %eax,0x4(%esp)
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	89 04 24             	mov    %eax,(%esp)
 147:	e8 2d ff ff ff       	call   79 <stosb>
  return dst;
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 14f:	c9                   	leave  
 150:	c3                   	ret    

00000151 <strchr>:

char*
strchr(const char *s, char c)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	83 ec 04             	sub    $0x4,%esp
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 15d:	eb 12                	jmp    171 <strchr+0x20>
    if(*s == c)
 15f:	8b 45 08             	mov    0x8(%ebp),%eax
 162:	8a 00                	mov    (%eax),%al
 164:	3a 45 fc             	cmp    -0x4(%ebp),%al
 167:	75 05                	jne    16e <strchr+0x1d>
      return (char*)s;
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	eb 11                	jmp    17f <strchr+0x2e>
  for(; *s; s++)
 16e:	ff 45 08             	incl   0x8(%ebp)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	8a 00                	mov    (%eax),%al
 176:	84 c0                	test   %al,%al
 178:	75 e5                	jne    15f <strchr+0xe>
  return 0;
 17a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17f:	c9                   	leave  
 180:	c3                   	ret    

00000181 <gets>:

char*
gets(char *buf, int max)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18e:	eb 42                	jmp    1d2 <gets+0x51>
    cc = read(0, &c, 1);
 190:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 197:	00 
 198:	8d 45 ef             	lea    -0x11(%ebp),%eax
 19b:	89 44 24 04          	mov    %eax,0x4(%esp)
 19f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a6:	e8 2f 01 00 00       	call   2da <read>
 1ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b2:	7e 29                	jle    1dd <gets+0x5c>
      break;
    buf[i++] = c;
 1b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	01 c2                	add    %eax,%edx
 1bc:	8a 45 ef             	mov    -0x11(%ebp),%al
 1bf:	88 02                	mov    %al,(%edx)
 1c1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1c4:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c7:	3c 0a                	cmp    $0xa,%al
 1c9:	74 13                	je     1de <gets+0x5d>
 1cb:	8a 45 ef             	mov    -0x11(%ebp),%al
 1ce:	3c 0d                	cmp    $0xd,%al
 1d0:	74 0c                	je     1de <gets+0x5d>
  for(i=0; i+1 < max; ){
 1d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d5:	40                   	inc    %eax
 1d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d9:	7c b5                	jl     190 <gets+0xf>
 1db:	eb 01                	jmp    1de <gets+0x5d>
      break;
 1dd:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1de:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	01 d0                	add    %edx,%eax
 1e6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ec:	c9                   	leave  
 1ed:	c3                   	ret    

000001ee <stat>:

int
stat(char *n, struct stat *st)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1fb:	00 
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	89 04 24             	mov    %eax,(%esp)
 202:	e8 fb 00 00 00       	call   302 <open>
 207:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 20a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 20e:	79 07                	jns    217 <stat+0x29>
    return -1;
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb 23                	jmp    23a <stat+0x4c>
  r = fstat(fd, st);
 217:	8b 45 0c             	mov    0xc(%ebp),%eax
 21a:	89 44 24 04          	mov    %eax,0x4(%esp)
 21e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 221:	89 04 24             	mov    %eax,(%esp)
 224:	e8 f1 00 00 00       	call   31a <fstat>
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 22c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 22f:	89 04 24             	mov    %eax,(%esp)
 232:	e8 b3 00 00 00       	call   2ea <close>
  return r;
 237:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 23a:	c9                   	leave  
 23b:	c3                   	ret    

0000023c <atoi>:

int
atoi(const char *s)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 242:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 249:	eb 21                	jmp    26c <atoi+0x30>
    n = n*10 + *s++ - '0';
 24b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24e:	89 d0                	mov    %edx,%eax
 250:	c1 e0 02             	shl    $0x2,%eax
 253:	01 d0                	add    %edx,%eax
 255:	d1 e0                	shl    %eax
 257:	89 c2                	mov    %eax,%edx
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	8a 00                	mov    (%eax),%al
 25e:	0f be c0             	movsbl %al,%eax
 261:	01 d0                	add    %edx,%eax
 263:	83 e8 30             	sub    $0x30,%eax
 266:	89 45 fc             	mov    %eax,-0x4(%ebp)
 269:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8a 00                	mov    (%eax),%al
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 09                	jle    27e <atoi+0x42>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	8a 00                	mov    (%eax),%al
 27a:	3c 39                	cmp    $0x39,%al
 27c:	7e cd                	jle    24b <atoi+0xf>
  return n;
 27e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 295:	eb 10                	jmp    2a7 <memmove+0x24>
    *dst++ = *src++;
 297:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29a:	8a 10                	mov    (%eax),%dl
 29c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29f:	88 10                	mov    %dl,(%eax)
 2a1:	ff 45 fc             	incl   -0x4(%ebp)
 2a4:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 2a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ab:	0f 9f c0             	setg   %al
 2ae:	ff 4d 10             	decl   0x10(%ebp)
 2b1:	84 c0                	test   %al,%al
 2b3:	75 e2                	jne    297 <memmove+0x14>
  return vdst;
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <fork>:
 2ba:	b8 01 00 00 00       	mov    $0x1,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <exit>:
 2c2:	b8 02 00 00 00       	mov    $0x2,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <wait>:
 2ca:	b8 03 00 00 00       	mov    $0x3,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <pipe>:
 2d2:	b8 04 00 00 00       	mov    $0x4,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <read>:
 2da:	b8 05 00 00 00       	mov    $0x5,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <write>:
 2e2:	b8 10 00 00 00       	mov    $0x10,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <close>:
 2ea:	b8 15 00 00 00       	mov    $0x15,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <kill>:
 2f2:	b8 06 00 00 00       	mov    $0x6,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <exec>:
 2fa:	b8 07 00 00 00       	mov    $0x7,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <open>:
 302:	b8 0f 00 00 00       	mov    $0xf,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <mknod>:
 30a:	b8 11 00 00 00       	mov    $0x11,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <unlink>:
 312:	b8 12 00 00 00       	mov    $0x12,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <fstat>:
 31a:	b8 08 00 00 00       	mov    $0x8,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <link>:
 322:	b8 13 00 00 00       	mov    $0x13,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <mkdir>:
 32a:	b8 14 00 00 00       	mov    $0x14,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <chdir>:
 332:	b8 09 00 00 00       	mov    $0x9,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <dup>:
 33a:	b8 0a 00 00 00       	mov    $0xa,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <getpid>:
 342:	b8 0b 00 00 00       	mov    $0xb,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sbrk>:
 34a:	b8 0c 00 00 00       	mov    $0xc,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <sleep>:
 352:	b8 0d 00 00 00       	mov    $0xd,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <uptime>:
 35a:	b8 0e 00 00 00       	mov    $0xe,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <lseek>:
 362:	b8 16 00 00 00       	mov    $0x16,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <isatty>:
 36a:	b8 17 00 00 00       	mov    $0x17,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <procstat>:
 372:	b8 18 00 00 00       	mov    $0x18,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <set_priority>:
 37a:	b8 19 00 00 00       	mov    $0x19,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <semget>:
 382:	b8 1a 00 00 00       	mov    $0x1a,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <semfree>:
 38a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <semdown>:
 392:	b8 1c 00 00 00       	mov    $0x1c,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <semup>:
 39a:	b8 1d 00 00 00       	mov    $0x1d,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <shm_create>:
 3a2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <shm_close>:
 3aa:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <shm_get>:
 3b2:	b8 20 00 00 00       	mov    $0x20,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ba:	55                   	push   %ebp
 3bb:	89 e5                	mov    %esp,%ebp
 3bd:	83 ec 28             	sub    $0x28,%esp
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3c6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3cd:	00 
 3ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	89 04 24             	mov    %eax,(%esp)
 3db:	e8 02 ff ff ff       	call   2e2 <write>
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    

000003e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3ef:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f3:	74 17                	je     40c <printint+0x2a>
 3f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3f9:	79 11                	jns    40c <printint+0x2a>
    neg = 1;
 3fb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	f7 d8                	neg    %eax
 407:	89 45 ec             	mov    %eax,-0x14(%ebp)
 40a:	eb 06                	jmp    412 <printint+0x30>
  } else {
    x = xx;
 40c:	8b 45 0c             	mov    0xc(%ebp),%eax
 40f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 412:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 419:	8b 4d 10             	mov    0x10(%ebp),%ecx
 41c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 41f:	ba 00 00 00 00       	mov    $0x0,%edx
 424:	f7 f1                	div    %ecx
 426:	89 d0                	mov    %edx,%eax
 428:	8a 80 c4 0a 00 00    	mov    0xac4(%eax),%al
 42e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 431:	8b 55 f4             	mov    -0xc(%ebp),%edx
 434:	01 ca                	add    %ecx,%edx
 436:	88 02                	mov    %al,(%edx)
 438:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 43b:	8b 55 10             	mov    0x10(%ebp),%edx
 43e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 441:	8b 45 ec             	mov    -0x14(%ebp),%eax
 444:	ba 00 00 00 00       	mov    $0x0,%edx
 449:	f7 75 d4             	divl   -0x2c(%ebp)
 44c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 453:	75 c4                	jne    419 <printint+0x37>
  if(neg)
 455:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 459:	74 2c                	je     487 <printint+0xa5>
    buf[i++] = '-';
 45b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 45e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 461:	01 d0                	add    %edx,%eax
 463:	c6 00 2d             	movb   $0x2d,(%eax)
 466:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 469:	eb 1c                	jmp    487 <printint+0xa5>
    putc(fd, buf[i]);
 46b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 46e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 471:	01 d0                	add    %edx,%eax
 473:	8a 00                	mov    (%eax),%al
 475:	0f be c0             	movsbl %al,%eax
 478:	89 44 24 04          	mov    %eax,0x4(%esp)
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	89 04 24             	mov    %eax,(%esp)
 482:	e8 33 ff ff ff       	call   3ba <putc>
  while(--i >= 0)
 487:	ff 4d f4             	decl   -0xc(%ebp)
 48a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48e:	79 db                	jns    46b <printint+0x89>
}
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 498:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 49f:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a2:	83 c0 04             	add    $0x4,%eax
 4a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4af:	e9 78 01 00 00       	jmp    62c <printf+0x19a>
    c = fmt[i] & 0xff;
 4b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 4b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ba:	01 d0                	add    %edx,%eax
 4bc:	8a 00                	mov    (%eax),%al
 4be:	0f be c0             	movsbl %al,%eax
 4c1:	25 ff 00 00 00       	and    $0xff,%eax
 4c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4cd:	75 2c                	jne    4fb <printf+0x69>
      if(c == '%'){
 4cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d3:	75 0c                	jne    4e1 <printf+0x4f>
        state = '%';
 4d5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4dc:	e9 48 01 00 00       	jmp    629 <printf+0x197>
      } else {
        putc(fd, c);
 4e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e4:	0f be c0             	movsbl %al,%eax
 4e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	89 04 24             	mov    %eax,(%esp)
 4f1:	e8 c4 fe ff ff       	call   3ba <putc>
 4f6:	e9 2e 01 00 00       	jmp    629 <printf+0x197>
      }
    } else if(state == '%'){
 4fb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ff:	0f 85 24 01 00 00    	jne    629 <printf+0x197>
      if(c == 'd'){
 505:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 509:	75 2d                	jne    538 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 50b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50e:	8b 00                	mov    (%eax),%eax
 510:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 517:	00 
 518:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 51f:	00 
 520:	89 44 24 04          	mov    %eax,0x4(%esp)
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	89 04 24             	mov    %eax,(%esp)
 52a:	e8 b3 fe ff ff       	call   3e2 <printint>
        ap++;
 52f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 533:	e9 ea 00 00 00       	jmp    622 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 538:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 53c:	74 06                	je     544 <printf+0xb2>
 53e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 542:	75 2d                	jne    571 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	8b 00                	mov    (%eax),%eax
 549:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 550:	00 
 551:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 558:	00 
 559:	89 44 24 04          	mov    %eax,0x4(%esp)
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	89 04 24             	mov    %eax,(%esp)
 563:	e8 7a fe ff ff       	call   3e2 <printint>
        ap++;
 568:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56c:	e9 b1 00 00 00       	jmp    622 <printf+0x190>
      } else if(c == 's'){
 571:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 575:	75 43                	jne    5ba <printf+0x128>
        s = (char*)*ap;
 577:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57a:	8b 00                	mov    (%eax),%eax
 57c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 57f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 587:	75 25                	jne    5ae <printf+0x11c>
          s = "(null)";
 589:	c7 45 f4 7e 08 00 00 	movl   $0x87e,-0xc(%ebp)
        while(*s != 0){
 590:	eb 1c                	jmp    5ae <printf+0x11c>
          putc(fd, *s);
 592:	8b 45 f4             	mov    -0xc(%ebp),%eax
 595:	8a 00                	mov    (%eax),%al
 597:	0f be c0             	movsbl %al,%eax
 59a:	89 44 24 04          	mov    %eax,0x4(%esp)
 59e:	8b 45 08             	mov    0x8(%ebp),%eax
 5a1:	89 04 24             	mov    %eax,(%esp)
 5a4:	e8 11 fe ff ff       	call   3ba <putc>
          s++;
 5a9:	ff 45 f4             	incl   -0xc(%ebp)
 5ac:	eb 01                	jmp    5af <printf+0x11d>
        while(*s != 0){
 5ae:	90                   	nop
 5af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b2:	8a 00                	mov    (%eax),%al
 5b4:	84 c0                	test   %al,%al
 5b6:	75 da                	jne    592 <printf+0x100>
 5b8:	eb 68                	jmp    622 <printf+0x190>
        }
      } else if(c == 'c'){
 5ba:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5be:	75 1d                	jne    5dd <printf+0x14b>
        putc(fd, *ap);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cc:	8b 45 08             	mov    0x8(%ebp),%eax
 5cf:	89 04 24             	mov    %eax,(%esp)
 5d2:	e8 e3 fd ff ff       	call   3ba <putc>
        ap++;
 5d7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5db:	eb 45                	jmp    622 <printf+0x190>
      } else if(c == '%'){
 5dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e1:	75 17                	jne    5fa <printf+0x168>
        putc(fd, c);
 5e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ed:	8b 45 08             	mov    0x8(%ebp),%eax
 5f0:	89 04 24             	mov    %eax,(%esp)
 5f3:	e8 c2 fd ff ff       	call   3ba <putc>
 5f8:	eb 28                	jmp    622 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5fa:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 601:	00 
 602:	8b 45 08             	mov    0x8(%ebp),%eax
 605:	89 04 24             	mov    %eax,(%esp)
 608:	e8 ad fd ff ff       	call   3ba <putc>
        putc(fd, c);
 60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 98 fd ff ff       	call   3ba <putc>
      }
      state = 0;
 622:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 629:	ff 45 f0             	incl   -0x10(%ebp)
 62c:	8b 55 0c             	mov    0xc(%ebp),%edx
 62f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 632:	01 d0                	add    %edx,%eax
 634:	8a 00                	mov    (%eax),%al
 636:	84 c0                	test   %al,%al
 638:	0f 85 76 fe ff ff    	jne    4b4 <printf+0x22>
    }
  }
}
 63e:	c9                   	leave  
 63f:	c3                   	ret    

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 646:	8b 45 08             	mov    0x8(%ebp),%eax
 649:	83 e8 08             	sub    $0x8,%eax
 64c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 64f:	a1 e0 0a 00 00       	mov    0xae0,%eax
 654:	89 45 fc             	mov    %eax,-0x4(%ebp)
 657:	eb 24                	jmp    67d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 661:	77 12                	ja     675 <free+0x35>
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 669:	77 24                	ja     68f <free+0x4f>
 66b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 673:	77 1a                	ja     68f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 675:	8b 45 fc             	mov    -0x4(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 683:	76 d4                	jbe    659 <free+0x19>
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
 688:	8b 00                	mov    (%eax),%eax
 68a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68d:	76 ca                	jbe    659 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 692:	8b 40 04             	mov    0x4(%eax),%eax
 695:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	39 c2                	cmp    %eax,%edx
 6a8:	75 24                	jne    6ce <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ad:	8b 50 04             	mov    0x4(%eax),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	8b 40 04             	mov    0x4(%eax),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 00                	mov    (%eax),%eax
 6c5:	8b 10                	mov    (%eax),%edx
 6c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ca:	89 10                	mov    %edx,(%eax)
 6cc:	eb 0a                	jmp    6d8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 10                	mov    (%eax),%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	01 d0                	add    %edx,%eax
 6ea:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ed:	75 20                	jne    70f <free+0xcf>
    p->s.size += bp->s.size;
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 50 04             	mov    0x4(%eax),%edx
 6f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f8:	8b 40 04             	mov    0x4(%eax),%eax
 6fb:	01 c2                	add    %eax,%edx
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 703:	8b 45 f8             	mov    -0x8(%ebp),%eax
 706:	8b 10                	mov    (%eax),%edx
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	89 10                	mov    %edx,(%eax)
 70d:	eb 08                	jmp    717 <free+0xd7>
  } else
    p->s.ptr = bp;
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 55 f8             	mov    -0x8(%ebp),%edx
 715:	89 10                	mov    %edx,(%eax)
  freep = p;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	a3 e0 0a 00 00       	mov    %eax,0xae0
}
 71f:	c9                   	leave  
 720:	c3                   	ret    

00000721 <morecore>:

static Header*
morecore(uint nu)
{
 721:	55                   	push   %ebp
 722:	89 e5                	mov    %esp,%ebp
 724:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 727:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 72e:	77 07                	ja     737 <morecore+0x16>
    nu = 4096;
 730:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	c1 e0 03             	shl    $0x3,%eax
 73d:	89 04 24             	mov    %eax,(%esp)
 740:	e8 05 fc ff ff       	call   34a <sbrk>
 745:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 748:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74c:	75 07                	jne    755 <morecore+0x34>
    return 0;
 74e:	b8 00 00 00 00       	mov    $0x0,%eax
 753:	eb 22                	jmp    777 <morecore+0x56>
  hp = (Header*)p;
 755:	8b 45 f4             	mov    -0xc(%ebp),%eax
 758:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	8b 55 08             	mov    0x8(%ebp),%edx
 761:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 764:	8b 45 f0             	mov    -0x10(%ebp),%eax
 767:	83 c0 08             	add    $0x8,%eax
 76a:	89 04 24             	mov    %eax,(%esp)
 76d:	e8 ce fe ff ff       	call   640 <free>
  return freep;
 772:	a1 e0 0a 00 00       	mov    0xae0,%eax
}
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <malloc>:

void*
malloc(uint nbytes)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	83 c0 07             	add    $0x7,%eax
 785:	c1 e8 03             	shr    $0x3,%eax
 788:	40                   	inc    %eax
 789:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 78c:	a1 e0 0a 00 00       	mov    0xae0,%eax
 791:	89 45 f0             	mov    %eax,-0x10(%ebp)
 794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 798:	75 23                	jne    7bd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 79a:	c7 45 f0 d8 0a 00 00 	movl   $0xad8,-0x10(%ebp)
 7a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a4:	a3 e0 0a 00 00       	mov    %eax,0xae0
 7a9:	a1 e0 0a 00 00       	mov    0xae0,%eax
 7ae:	a3 d8 0a 00 00       	mov    %eax,0xad8
    base.s.size = 0;
 7b3:	c7 05 dc 0a 00 00 00 	movl   $0x0,0xadc
 7ba:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c0:	8b 00                	mov    (%eax),%eax
 7c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	8b 40 04             	mov    0x4(%eax),%eax
 7cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ce:	72 4d                	jb     81d <malloc+0xa4>
      if(p->s.size == nunits)
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 40 04             	mov    0x4(%eax),%eax
 7d6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d9:	75 0c                	jne    7e7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7de:	8b 10                	mov    (%eax),%edx
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	89 10                	mov    %edx,(%eax)
 7e5:	eb 26                	jmp    80d <malloc+0x94>
      else {
        p->s.size -= nunits;
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	8b 40 04             	mov    0x4(%eax),%eax
 7ed:	89 c2                	mov    %eax,%edx
 7ef:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	c1 e0 03             	shl    $0x3,%eax
 801:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 804:	8b 45 f4             	mov    -0xc(%ebp),%eax
 807:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	a3 e0 0a 00 00       	mov    %eax,0xae0
      return (void*)(p + 1);
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	83 c0 08             	add    $0x8,%eax
 81b:	eb 38                	jmp    855 <malloc+0xdc>
    }
    if(p == freep)
 81d:	a1 e0 0a 00 00       	mov    0xae0,%eax
 822:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 825:	75 1b                	jne    842 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 827:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82a:	89 04 24             	mov    %eax,(%esp)
 82d:	e8 ef fe ff ff       	call   721 <morecore>
 832:	89 45 f4             	mov    %eax,-0xc(%ebp)
 835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 839:	75 07                	jne    842 <malloc+0xc9>
        return 0;
 83b:	b8 00 00 00 00       	mov    $0x0,%eax
 840:	eb 13                	jmp    855 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	89 45 f0             	mov    %eax,-0x10(%ebp)
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 00                	mov    (%eax),%eax
 84d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 850:	e9 70 ff ff ff       	jmp    7c5 <malloc+0x4c>
}
 855:	c9                   	leave  
 856:	c3                   	ret    
