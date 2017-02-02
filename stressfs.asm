
_stressfs:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 e4 f0             	and    $0xfffffff0,%esp
   9:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   f:	8d 94 24 1e 02 00 00 	lea    0x21e(%esp),%edx
  16:	bb 65 09 00 00       	mov    $0x965,%ebx
  1b:	b8 0a 00 00 00       	mov    $0xa,%eax
  20:	89 d7                	mov    %edx,%edi
  22:	89 de                	mov    %ebx,%esi
  24:	89 c1                	mov    %eax,%ecx
  26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	c7 44 24 04 42 09 00 	movl   $0x942,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 41 05 00 00       	call   57d <printf>
  memset(data, 'a', sizeof(data));
  3c:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  43:	00 
  44:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4b:	00 
  4c:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 08 02 00 00       	call   260 <memset>

  for(i = 0; i < 4; i++)
  58:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  5f:	00 00 00 00 
  63:	eb 10                	jmp    75 <main+0x75>
    if(fork() > 0)
  65:	e8 83 03 00 00       	call   3ed <fork>
  6a:	85 c0                	test   %eax,%eax
  6c:	7f 13                	jg     81 <main+0x81>
  for(i = 0; i < 4; i++)
  6e:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
  75:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  7c:	03 
  7d:	7e e6                	jle    65 <main+0x65>
  7f:	eb 01                	jmp    82 <main+0x82>
      break;
  81:	90                   	nop

  printf(1, "write %d\n", i);
  82:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  89:	89 44 24 08          	mov    %eax,0x8(%esp)
  8d:	c7 44 24 04 55 09 00 	movl   $0x955,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 dc 04 00 00       	call   57d <printf>

  path[8] += i;
  a1:	8a 84 24 26 02 00 00 	mov    0x226(%esp),%al
  a8:	88 c2                	mov    %al,%dl
  aa:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b1:	01 d0                	add    %edx,%eax
  b3:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  ba:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c1:	00 
  c2:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  c9:	89 04 24             	mov    %eax,(%esp)
  cc:	e8 64 03 00 00       	call   435 <open>
  d1:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  d8:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  df:	00 00 00 00 
  e3:	eb 26                	jmp    10b <main+0x10b>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  e5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  ec:	00 
  ed:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  f5:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 11 03 00 00       	call   415 <write>
  for(i = 0; i < 20; i++)
 104:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
 10b:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 112:	13 
 113:	7e d0                	jle    e5 <main+0xe5>
  close(fd);
 115:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 f9 02 00 00       	call   41d <close>

  printf(1, "read\n");
 124:	c7 44 24 04 5f 09 00 	movl   $0x95f,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 45 04 00 00       	call   57d <printf>

  fd = open(path, O_RDONLY);
 138:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 13f:	00 
 140:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 147:	89 04 24             	mov    %eax,(%esp)
 14a:	e8 e6 02 00 00       	call   435 <open>
 14f:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 156:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 15d:	00 00 00 00 
 161:	eb 26                	jmp    189 <main+0x189>
    read(fd, data, sizeof(data));
 163:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 16a:	00 
 16b:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 16f:	89 44 24 04          	mov    %eax,0x4(%esp)
 173:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 17a:	89 04 24             	mov    %eax,(%esp)
 17d:	e8 8b 02 00 00       	call   40d <read>
  for (i = 0; i < 20; i++)
 182:	ff 84 24 2c 02 00 00 	incl   0x22c(%esp)
 189:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 190:	13 
 191:	7e d0                	jle    163 <main+0x163>
  close(fd);
 193:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 7b 02 00 00       	call   41d <close>

  wait();
 1a2:	e8 56 02 00 00       	call   3fd <wait>
  
  exit();
 1a7:	e8 49 02 00 00       	call   3f5 <exit>

000001ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	57                   	push   %edi
 1b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b4:	8b 55 10             	mov    0x10(%ebp),%edx
 1b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ba:	89 cb                	mov    %ecx,%ebx
 1bc:	89 df                	mov    %ebx,%edi
 1be:	89 d1                	mov    %edx,%ecx
 1c0:	fc                   	cld    
 1c1:	f3 aa                	rep stos %al,%es:(%edi)
 1c3:	89 ca                	mov    %ecx,%edx
 1c5:	89 fb                	mov    %edi,%ebx
 1c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1cd:	5b                   	pop    %ebx
 1ce:	5f                   	pop    %edi
 1cf:	5d                   	pop    %ebp
 1d0:	c3                   	ret    

000001d1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1dd:	90                   	nop
 1de:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e1:	8a 10                	mov    (%eax),%dl
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	88 10                	mov    %dl,(%eax)
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	8a 00                	mov    (%eax),%al
 1ed:	84 c0                	test   %al,%al
 1ef:	0f 95 c0             	setne  %al
 1f2:	ff 45 08             	incl   0x8(%ebp)
 1f5:	ff 45 0c             	incl   0xc(%ebp)
 1f8:	84 c0                	test   %al,%al
 1fa:	75 e2                	jne    1de <strcpy+0xd>
    ;
  return os;
 1fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 204:	eb 06                	jmp    20c <strcmp+0xb>
    p++, q++;
 206:	ff 45 08             	incl   0x8(%ebp)
 209:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	84 c0                	test   %al,%al
 213:	74 0e                	je     223 <strcmp+0x22>
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8a 10                	mov    (%eax),%dl
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	8a 00                	mov    (%eax),%al
 21f:	38 c2                	cmp    %al,%dl
 221:	74 e3                	je     206 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 00                	mov    (%eax),%al
 228:	0f b6 d0             	movzbl %al,%edx
 22b:	8b 45 0c             	mov    0xc(%ebp),%eax
 22e:	8a 00                	mov    (%eax),%al
 230:	0f b6 c0             	movzbl %al,%eax
 233:	89 d1                	mov    %edx,%ecx
 235:	29 c1                	sub    %eax,%ecx
 237:	89 c8                	mov    %ecx,%eax
}
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <strlen>:

uint
strlen(char *s)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 241:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 248:	eb 03                	jmp    24d <strlen+0x12>
 24a:	ff 45 fc             	incl   -0x4(%ebp)
 24d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	01 d0                	add    %edx,%eax
 255:	8a 00                	mov    (%eax),%al
 257:	84 c0                	test   %al,%al
 259:	75 ef                	jne    24a <strlen+0xf>
    ;
  return n;
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 266:	8b 45 10             	mov    0x10(%ebp),%eax
 269:	89 44 24 08          	mov    %eax,0x8(%esp)
 26d:	8b 45 0c             	mov    0xc(%ebp),%eax
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	89 04 24             	mov    %eax,(%esp)
 27a:	e8 2d ff ff ff       	call   1ac <stosb>
  return dst;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <strchr>:

char*
strchr(const char *s, char c)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 04             	sub    $0x4,%esp
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 290:	eb 12                	jmp    2a4 <strchr+0x20>
    if(*s == c)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	8a 00                	mov    (%eax),%al
 297:	3a 45 fc             	cmp    -0x4(%ebp),%al
 29a:	75 05                	jne    2a1 <strchr+0x1d>
      return (char*)s;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	eb 11                	jmp    2b2 <strchr+0x2e>
  for(; *s; s++)
 2a1:	ff 45 08             	incl   0x8(%ebp)
 2a4:	8b 45 08             	mov    0x8(%ebp),%eax
 2a7:	8a 00                	mov    (%eax),%al
 2a9:	84 c0                	test   %al,%al
 2ab:	75 e5                	jne    292 <strchr+0xe>
  return 0;
 2ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <gets>:

char*
gets(char *buf, int max)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2c1:	eb 42                	jmp    305 <gets+0x51>
    cc = read(0, &c, 1);
 2c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2ca:	00 
 2cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2d9:	e8 2f 01 00 00       	call   40d <read>
 2de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2e5:	7e 29                	jle    310 <gets+0x5c>
      break;
    buf[i++] = c;
 2e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	01 c2                	add    %eax,%edx
 2ef:	8a 45 ef             	mov    -0x11(%ebp),%al
 2f2:	88 02                	mov    %al,(%edx)
 2f4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 2f7:	8a 45 ef             	mov    -0x11(%ebp),%al
 2fa:	3c 0a                	cmp    $0xa,%al
 2fc:	74 13                	je     311 <gets+0x5d>
 2fe:	8a 45 ef             	mov    -0x11(%ebp),%al
 301:	3c 0d                	cmp    $0xd,%al
 303:	74 0c                	je     311 <gets+0x5d>
  for(i=0; i+1 < max; ){
 305:	8b 45 f4             	mov    -0xc(%ebp),%eax
 308:	40                   	inc    %eax
 309:	3b 45 0c             	cmp    0xc(%ebp),%eax
 30c:	7c b5                	jl     2c3 <gets+0xf>
 30e:	eb 01                	jmp    311 <gets+0x5d>
      break;
 310:	90                   	nop
      break;
  }
  buf[i] = '\0';
 311:	8b 55 f4             	mov    -0xc(%ebp),%edx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	01 d0                	add    %edx,%eax
 319:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <stat>:

int
stat(char *n, struct stat *st)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 327:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 32e:	00 
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	89 04 24             	mov    %eax,(%esp)
 335:	e8 fb 00 00 00       	call   435 <open>
 33a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 33d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 341:	79 07                	jns    34a <stat+0x29>
    return -1;
 343:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 348:	eb 23                	jmp    36d <stat+0x4c>
  r = fstat(fd, st);
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 44 24 04          	mov    %eax,0x4(%esp)
 351:	8b 45 f4             	mov    -0xc(%ebp),%eax
 354:	89 04 24             	mov    %eax,(%esp)
 357:	e8 f1 00 00 00       	call   44d <fstat>
 35c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 35f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 362:	89 04 24             	mov    %eax,(%esp)
 365:	e8 b3 00 00 00       	call   41d <close>
  return r;
 36a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <atoi>:

int
atoi(const char *s)
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 375:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 37c:	eb 21                	jmp    39f <atoi+0x30>
    n = n*10 + *s++ - '0';
 37e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 381:	89 d0                	mov    %edx,%eax
 383:	c1 e0 02             	shl    $0x2,%eax
 386:	01 d0                	add    %edx,%eax
 388:	d1 e0                	shl    %eax
 38a:	89 c2                	mov    %eax,%edx
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	8a 00                	mov    (%eax),%al
 391:	0f be c0             	movsbl %al,%eax
 394:	01 d0                	add    %edx,%eax
 396:	83 e8 30             	sub    $0x30,%eax
 399:	89 45 fc             	mov    %eax,-0x4(%ebp)
 39c:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8a 00                	mov    (%eax),%al
 3a4:	3c 2f                	cmp    $0x2f,%al
 3a6:	7e 09                	jle    3b1 <atoi+0x42>
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	8a 00                	mov    (%eax),%al
 3ad:	3c 39                	cmp    $0x39,%al
 3af:	7e cd                	jle    37e <atoi+0xf>
  return n;
 3b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3c8:	eb 10                	jmp    3da <memmove+0x24>
    *dst++ = *src++;
 3ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3cd:	8a 10                	mov    (%eax),%dl
 3cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d2:	88 10                	mov    %dl,(%eax)
 3d4:	ff 45 fc             	incl   -0x4(%ebp)
 3d7:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 3da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3de:	0f 9f c0             	setg   %al
 3e1:	ff 4d 10             	decl   0x10(%ebp)
 3e4:	84 c0                	test   %al,%al
 3e6:	75 e2                	jne    3ca <memmove+0x14>
  return vdst;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3eb:	c9                   	leave  
 3ec:	c3                   	ret    

000003ed <fork>:
 3ed:	b8 01 00 00 00       	mov    $0x1,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <exit>:
 3f5:	b8 02 00 00 00       	mov    $0x2,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <wait>:
 3fd:	b8 03 00 00 00       	mov    $0x3,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <pipe>:
 405:	b8 04 00 00 00       	mov    $0x4,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <read>:
 40d:	b8 05 00 00 00       	mov    $0x5,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <write>:
 415:	b8 10 00 00 00       	mov    $0x10,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <close>:
 41d:	b8 15 00 00 00       	mov    $0x15,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <kill>:
 425:	b8 06 00 00 00       	mov    $0x6,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <exec>:
 42d:	b8 07 00 00 00       	mov    $0x7,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <open>:
 435:	b8 0f 00 00 00       	mov    $0xf,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <mknod>:
 43d:	b8 11 00 00 00       	mov    $0x11,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <unlink>:
 445:	b8 12 00 00 00       	mov    $0x12,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <fstat>:
 44d:	b8 08 00 00 00       	mov    $0x8,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <link>:
 455:	b8 13 00 00 00       	mov    $0x13,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <mkdir>:
 45d:	b8 14 00 00 00       	mov    $0x14,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <chdir>:
 465:	b8 09 00 00 00       	mov    $0x9,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <dup>:
 46d:	b8 0a 00 00 00       	mov    $0xa,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <getpid>:
 475:	b8 0b 00 00 00       	mov    $0xb,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <sbrk>:
 47d:	b8 0c 00 00 00       	mov    $0xc,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <sleep>:
 485:	b8 0d 00 00 00       	mov    $0xd,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <uptime>:
 48d:	b8 0e 00 00 00       	mov    $0xe,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <lseek>:
 495:	b8 16 00 00 00       	mov    $0x16,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <isatty>:
 49d:	b8 17 00 00 00       	mov    $0x17,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a5:	55                   	push   %ebp
 4a6:	89 e5                	mov    %esp,%ebp
 4a8:	83 ec 28             	sub    $0x28,%esp
 4ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ae:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4b1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b8:	00 
 4b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	89 04 24             	mov    %eax,(%esp)
 4c6:	e8 4a ff ff ff       	call   415 <write>
}
 4cb:	c9                   	leave  
 4cc:	c3                   	ret    

000004cd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4cd:	55                   	push   %ebp
 4ce:	89 e5                	mov    %esp,%ebp
 4d0:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4da:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4de:	74 17                	je     4f7 <printint+0x2a>
 4e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e4:	79 11                	jns    4f7 <printint+0x2a>
    neg = 1;
 4e6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	f7 d8                	neg    %eax
 4f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f5:	eb 06                	jmp    4fd <printint+0x30>
  } else {
    x = xx;
 4f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 504:	8b 4d 10             	mov    0x10(%ebp),%ecx
 507:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50a:	ba 00 00 00 00       	mov    $0x0,%edx
 50f:	f7 f1                	div    %ecx
 511:	89 d0                	mov    %edx,%eax
 513:	8a 80 b8 0b 00 00    	mov    0xbb8(%eax),%al
 519:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 51c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 51f:	01 ca                	add    %ecx,%edx
 521:	88 02                	mov    %al,(%edx)
 523:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 526:	8b 55 10             	mov    0x10(%ebp),%edx
 529:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 52c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52f:	ba 00 00 00 00       	mov    $0x0,%edx
 534:	f7 75 d4             	divl   -0x2c(%ebp)
 537:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53e:	75 c4                	jne    504 <printint+0x37>
  if(neg)
 540:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 544:	74 2c                	je     572 <printint+0xa5>
    buf[i++] = '-';
 546:	8d 55 dc             	lea    -0x24(%ebp),%edx
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	01 d0                	add    %edx,%eax
 54e:	c6 00 2d             	movb   $0x2d,(%eax)
 551:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 554:	eb 1c                	jmp    572 <printint+0xa5>
    putc(fd, buf[i]);
 556:	8d 55 dc             	lea    -0x24(%ebp),%edx
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	01 d0                	add    %edx,%eax
 55e:	8a 00                	mov    (%eax),%al
 560:	0f be c0             	movsbl %al,%eax
 563:	89 44 24 04          	mov    %eax,0x4(%esp)
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	89 04 24             	mov    %eax,(%esp)
 56d:	e8 33 ff ff ff       	call   4a5 <putc>
  while(--i >= 0)
 572:	ff 4d f4             	decl   -0xc(%ebp)
 575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 579:	79 db                	jns    556 <printint+0x89>
}
 57b:	c9                   	leave  
 57c:	c3                   	ret    

0000057d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 57d:	55                   	push   %ebp
 57e:	89 e5                	mov    %esp,%ebp
 580:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 583:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58a:	8d 45 0c             	lea    0xc(%ebp),%eax
 58d:	83 c0 04             	add    $0x4,%eax
 590:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 593:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59a:	e9 78 01 00 00       	jmp    717 <printf+0x19a>
    c = fmt[i] & 0xff;
 59f:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a5:	01 d0                	add    %edx,%eax
 5a7:	8a 00                	mov    (%eax),%al
 5a9:	0f be c0             	movsbl %al,%eax
 5ac:	25 ff 00 00 00       	and    $0xff,%eax
 5b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b8:	75 2c                	jne    5e6 <printf+0x69>
      if(c == '%'){
 5ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5be:	75 0c                	jne    5cc <printf+0x4f>
        state = '%';
 5c0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c7:	e9 48 01 00 00       	jmp    714 <printf+0x197>
      } else {
        putc(fd, c);
 5cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d6:	8b 45 08             	mov    0x8(%ebp),%eax
 5d9:	89 04 24             	mov    %eax,(%esp)
 5dc:	e8 c4 fe ff ff       	call   4a5 <putc>
 5e1:	e9 2e 01 00 00       	jmp    714 <printf+0x197>
      }
    } else if(state == '%'){
 5e6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ea:	0f 85 24 01 00 00    	jne    714 <printf+0x197>
      if(c == 'd'){
 5f0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f4:	75 2d                	jne    623 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 602:	00 
 603:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 60a:	00 
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 b3 fe ff ff       	call   4cd <printint>
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61e:	e9 ea 00 00 00       	jmp    70d <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 623:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 627:	74 06                	je     62f <printf+0xb2>
 629:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 62d:	75 2d                	jne    65c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 62f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 63b:	00 
 63c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 643:	00 
 644:	89 44 24 04          	mov    %eax,0x4(%esp)
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	89 04 24             	mov    %eax,(%esp)
 64e:	e8 7a fe ff ff       	call   4cd <printint>
        ap++;
 653:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 657:	e9 b1 00 00 00       	jmp    70d <printf+0x190>
      } else if(c == 's'){
 65c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 660:	75 43                	jne    6a5 <printf+0x128>
        s = (char*)*ap;
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 66e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 672:	75 25                	jne    699 <printf+0x11c>
          s = "(null)";
 674:	c7 45 f4 6f 09 00 00 	movl   $0x96f,-0xc(%ebp)
        while(*s != 0){
 67b:	eb 1c                	jmp    699 <printf+0x11c>
          putc(fd, *s);
 67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 680:	8a 00                	mov    (%eax),%al
 682:	0f be c0             	movsbl %al,%eax
 685:	89 44 24 04          	mov    %eax,0x4(%esp)
 689:	8b 45 08             	mov    0x8(%ebp),%eax
 68c:	89 04 24             	mov    %eax,(%esp)
 68f:	e8 11 fe ff ff       	call   4a5 <putc>
          s++;
 694:	ff 45 f4             	incl   -0xc(%ebp)
 697:	eb 01                	jmp    69a <printf+0x11d>
        while(*s != 0){
 699:	90                   	nop
 69a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69d:	8a 00                	mov    (%eax),%al
 69f:	84 c0                	test   %al,%al
 6a1:	75 da                	jne    67d <printf+0x100>
 6a3:	eb 68                	jmp    70d <printf+0x190>
        }
      } else if(c == 'c'){
 6a5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a9:	75 1d                	jne    6c8 <printf+0x14b>
        putc(fd, *ap);
 6ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	0f be c0             	movsbl %al,%eax
 6b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 e3 fd ff ff       	call   4a5 <putc>
        ap++;
 6c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c6:	eb 45                	jmp    70d <printf+0x190>
      } else if(c == '%'){
 6c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6cc:	75 17                	jne    6e5 <printf+0x168>
        putc(fd, c);
 6ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d8:	8b 45 08             	mov    0x8(%ebp),%eax
 6db:	89 04 24             	mov    %eax,(%esp)
 6de:	e8 c2 fd ff ff       	call   4a5 <putc>
 6e3:	eb 28                	jmp    70d <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6ec:	00 
 6ed:	8b 45 08             	mov    0x8(%ebp),%eax
 6f0:	89 04 24             	mov    %eax,(%esp)
 6f3:	e8 ad fd ff ff       	call   4a5 <putc>
        putc(fd, c);
 6f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fb:	0f be c0             	movsbl %al,%eax
 6fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	89 04 24             	mov    %eax,(%esp)
 708:	e8 98 fd ff ff       	call   4a5 <putc>
      }
      state = 0;
 70d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 714:	ff 45 f0             	incl   -0x10(%ebp)
 717:	8b 55 0c             	mov    0xc(%ebp),%edx
 71a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71d:	01 d0                	add    %edx,%eax
 71f:	8a 00                	mov    (%eax),%al
 721:	84 c0                	test   %al,%al
 723:	0f 85 76 fe ff ff    	jne    59f <printf+0x22>
    }
  }
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 e8 08             	sub    $0x8,%eax
 737:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 73f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 742:	eb 24                	jmp    768 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	77 12                	ja     760 <free+0x35>
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 754:	77 24                	ja     77a <free+0x4f>
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75e:	77 1a                	ja     77a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 00                	mov    (%eax),%eax
 765:	89 45 fc             	mov    %eax,-0x4(%ebp)
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76e:	76 d4                	jbe    744 <free+0x19>
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 778:	76 ca                	jbe    744 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	01 c2                	add    %eax,%edx
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	39 c2                	cmp    %eax,%edx
 793:	75 24                	jne    7b9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	8b 50 04             	mov    0x4(%eax),%edx
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 00                	mov    (%eax),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	01 c2                	add    %eax,%edx
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	8b 10                	mov    (%eax),%edx
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	89 10                	mov    %edx,(%eax)
 7b7:	eb 0a                	jmp    7c3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 10                	mov    (%eax),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	01 d0                	add    %edx,%eax
 7d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d8:	75 20                	jne    7fa <free+0xcf>
    p->s.size += bp->s.size;
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 50 04             	mov    0x4(%eax),%edx
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	01 c2                	add    %eax,%edx
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	89 10                	mov    %edx,(%eax)
 7f8:	eb 08                	jmp    802 <free+0xd7>
  } else
    p->s.ptr = bp;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 800:	89 10                	mov    %edx,(%eax)
  freep = p;
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	a3 d4 0b 00 00       	mov    %eax,0xbd4
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    

0000080c <morecore>:

static Header*
morecore(uint nu)
{
 80c:	55                   	push   %ebp
 80d:	89 e5                	mov    %esp,%ebp
 80f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 812:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 819:	77 07                	ja     822 <morecore+0x16>
    nu = 4096;
 81b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 822:	8b 45 08             	mov    0x8(%ebp),%eax
 825:	c1 e0 03             	shl    $0x3,%eax
 828:	89 04 24             	mov    %eax,(%esp)
 82b:	e8 4d fc ff ff       	call   47d <sbrk>
 830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 833:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 837:	75 07                	jne    840 <morecore+0x34>
    return 0;
 839:	b8 00 00 00 00       	mov    $0x0,%eax
 83e:	eb 22                	jmp    862 <morecore+0x56>
  hp = (Header*)p;
 840:	8b 45 f4             	mov    -0xc(%ebp),%eax
 843:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 846:	8b 45 f0             	mov    -0x10(%ebp),%eax
 849:	8b 55 08             	mov    0x8(%ebp),%edx
 84c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 84f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 852:	83 c0 08             	add    $0x8,%eax
 855:	89 04 24             	mov    %eax,(%esp)
 858:	e8 ce fe ff ff       	call   72b <free>
  return freep;
 85d:	a1 d4 0b 00 00       	mov    0xbd4,%eax
}
 862:	c9                   	leave  
 863:	c3                   	ret    

00000864 <malloc>:

void*
malloc(uint nbytes)
{
 864:	55                   	push   %ebp
 865:	89 e5                	mov    %esp,%ebp
 867:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	8b 45 08             	mov    0x8(%ebp),%eax
 86d:	83 c0 07             	add    $0x7,%eax
 870:	c1 e8 03             	shr    $0x3,%eax
 873:	40                   	inc    %eax
 874:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 877:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 87c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 883:	75 23                	jne    8a8 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 885:	c7 45 f0 cc 0b 00 00 	movl   $0xbcc,-0x10(%ebp)
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	a3 d4 0b 00 00       	mov    %eax,0xbd4
 894:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 899:	a3 cc 0b 00 00       	mov    %eax,0xbcc
    base.s.size = 0;
 89e:	c7 05 d0 0b 00 00 00 	movl   $0x0,0xbd0
 8a5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ab:	8b 00                	mov    (%eax),%eax
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 40 04             	mov    0x4(%eax),%eax
 8b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b9:	72 4d                	jb     908 <malloc+0xa4>
      if(p->s.size == nunits)
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c4:	75 0c                	jne    8d2 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 10                	mov    (%eax),%edx
 8cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ce:	89 10                	mov    %edx,(%eax)
 8d0:	eb 26                	jmp    8f8 <malloc+0x94>
      else {
        p->s.size -= nunits;
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	8b 40 04             	mov    0x4(%eax),%eax
 8d8:	89 c2                	mov    %eax,%edx
 8da:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	8b 40 04             	mov    0x4(%eax),%eax
 8e9:	c1 e0 03             	shl    $0x3,%eax
 8ec:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fb:	a3 d4 0b 00 00       	mov    %eax,0xbd4
      return (void*)(p + 1);
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	83 c0 08             	add    $0x8,%eax
 906:	eb 38                	jmp    940 <malloc+0xdc>
    }
    if(p == freep)
 908:	a1 d4 0b 00 00       	mov    0xbd4,%eax
 90d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 910:	75 1b                	jne    92d <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 912:	8b 45 ec             	mov    -0x14(%ebp),%eax
 915:	89 04 24             	mov    %eax,(%esp)
 918:	e8 ef fe ff ff       	call   80c <morecore>
 91d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 920:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 924:	75 07                	jne    92d <malloc+0xc9>
        return 0;
 926:	b8 00 00 00 00       	mov    $0x0,%eax
 92b:	eb 13                	jmp    940 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 930:	89 45 f0             	mov    %eax,-0x10(%ebp)
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	8b 00                	mov    (%eax),%eax
 938:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 93b:	e9 70 ff ff ff       	jmp    8b0 <malloc+0x4c>
}
 940:	c9                   	leave  
 941:	c3                   	ret    
