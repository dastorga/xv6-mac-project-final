
_forktest:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 90 01 00 00       	call   1a1 <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 54 03 00 00       	call   37b <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 0c 04 00 	movl   $0x40c,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1c                	jmp    68 <forktest+0x3f>
    pid = fork();
  4c:	e8 02 03 00 00       	call   353 <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	78 19                	js     73 <forktest+0x4a>
      break;
    if(pid == 0)
  5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  5e:	75 05                	jne    65 <forktest+0x3c>
      exit();
  60:	e8 f6 02 00 00       	call   35b <exit>
  for(n=0; n<N; n++){
  65:	ff 45 f4             	incl   -0xc(%ebp)
  68:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  6f:	7e db                	jle    4c <forktest+0x23>
  71:	eb 01                	jmp    74 <forktest+0x4b>
      break;
  73:	90                   	nop
  }
  
  if(n == N){
  74:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  7b:	75 46                	jne    c3 <forktest+0x9a>
    printf(1, "fork claimed to work N times!\n", N);
  7d:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  84:	00 
  85:	c7 44 24 04 18 04 00 	movl   $0x418,0x4(%esp)
  8c:	00 
  8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  94:	e8 67 ff ff ff       	call   0 <printf>
    exit();
  99:	e8 bd 02 00 00       	call   35b <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
  9e:	e8 c0 02 00 00       	call   363 <wait>
  a3:	85 c0                	test   %eax,%eax
  a5:	79 19                	jns    c0 <forktest+0x97>
      printf(1, "wait stopped early\n");
  a7:	c7 44 24 04 37 04 00 	movl   $0x437,0x4(%esp)
  ae:	00 
  af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b6:	e8 45 ff ff ff       	call   0 <printf>
      exit();
  bb:	e8 9b 02 00 00       	call   35b <exit>
  for(; n > 0; n--){
  c0:	ff 4d f4             	decl   -0xc(%ebp)
  c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c7:	7f d5                	jg     9e <forktest+0x75>
    }
  }
  
  if(wait() != -1){
  c9:	e8 95 02 00 00       	call   363 <wait>
  ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  d1:	74 19                	je     ec <forktest+0xc3>
    printf(1, "wait got too many\n");
  d3:	c7 44 24 04 4b 04 00 	movl   $0x44b,0x4(%esp)
  da:	00 
  db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e2:	e8 19 ff ff ff       	call   0 <printf>
    exit();
  e7:	e8 6f 02 00 00       	call   35b <exit>
  }
  
  printf(1, "fork test OK\n");
  ec:	c7 44 24 04 5e 04 00 	movl   $0x45e,0x4(%esp)
  f3:	00 
  f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fb:	e8 00 ff ff ff       	call   0 <printf>
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <main>:

int
main(void)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 108:	e8 1c ff ff ff       	call   29 <forktest>
  exit();
 10d:	e8 49 02 00 00       	call   35b <exit>

00000112 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	57                   	push   %edi
 116:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 117:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11a:	8b 55 10             	mov    0x10(%ebp),%edx
 11d:	8b 45 0c             	mov    0xc(%ebp),%eax
 120:	89 cb                	mov    %ecx,%ebx
 122:	89 df                	mov    %ebx,%edi
 124:	89 d1                	mov    %edx,%ecx
 126:	fc                   	cld    
 127:	f3 aa                	rep stos %al,%es:(%edi)
 129:	89 ca                	mov    %ecx,%edx
 12b:	89 fb                	mov    %edi,%ebx
 12d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 130:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 133:	5b                   	pop    %ebx
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	c3                   	ret    

00000137 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 137:	55                   	push   %ebp
 138:	89 e5                	mov    %esp,%ebp
 13a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 143:	90                   	nop
 144:	8b 45 0c             	mov    0xc(%ebp),%eax
 147:	8a 10                	mov    (%eax),%dl
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	88 10                	mov    %dl,(%eax)
 14e:	8b 45 08             	mov    0x8(%ebp),%eax
 151:	8a 00                	mov    (%eax),%al
 153:	84 c0                	test   %al,%al
 155:	0f 95 c0             	setne  %al
 158:	ff 45 08             	incl   0x8(%ebp)
 15b:	ff 45 0c             	incl   0xc(%ebp)
 15e:	84 c0                	test   %al,%al
 160:	75 e2                	jne    144 <strcpy+0xd>
    ;
  return os;
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 165:	c9                   	leave  
 166:	c3                   	ret    

00000167 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16a:	eb 06                	jmp    172 <strcmp+0xb>
    p++, q++;
 16c:	ff 45 08             	incl   0x8(%ebp)
 16f:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	8a 00                	mov    (%eax),%al
 177:	84 c0                	test   %al,%al
 179:	74 0e                	je     189 <strcmp+0x22>
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	8a 10                	mov    (%eax),%dl
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	8a 00                	mov    (%eax),%al
 185:	38 c2                	cmp    %al,%dl
 187:	74 e3                	je     16c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	8a 00                	mov    (%eax),%al
 18e:	0f b6 d0             	movzbl %al,%edx
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	8a 00                	mov    (%eax),%al
 196:	0f b6 c0             	movzbl %al,%eax
 199:	89 d1                	mov    %edx,%ecx
 19b:	29 c1                	sub    %eax,%ecx
 19d:	89 c8                	mov    %ecx,%eax
}
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    

000001a1 <strlen>:

uint
strlen(char *s)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ae:	eb 03                	jmp    1b3 <strlen+0x12>
 1b0:	ff 45 fc             	incl   -0x4(%ebp)
 1b3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	01 d0                	add    %edx,%eax
 1bb:	8a 00                	mov    (%eax),%al
 1bd:	84 c0                	test   %al,%al
 1bf:	75 ef                	jne    1b0 <strlen+0xf>
    ;
  return n;
 1c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c4:	c9                   	leave  
 1c5:	c3                   	ret    

000001c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1cc:	8b 45 10             	mov    0x10(%ebp),%eax
 1cf:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	89 04 24             	mov    %eax,(%esp)
 1e0:	e8 2d ff ff ff       	call   112 <stosb>
  return dst;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <strchr>:

char*
strchr(const char *s, char c)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 04             	sub    $0x4,%esp
 1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f6:	eb 12                	jmp    20a <strchr+0x20>
    if(*s == c)
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	8a 00                	mov    (%eax),%al
 1fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 200:	75 05                	jne    207 <strchr+0x1d>
      return (char*)s;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	eb 11                	jmp    218 <strchr+0x2e>
  for(; *s; s++)
 207:	ff 45 08             	incl   0x8(%ebp)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	8a 00                	mov    (%eax),%al
 20f:	84 c0                	test   %al,%al
 211:	75 e5                	jne    1f8 <strchr+0xe>
  return 0;
 213:	b8 00 00 00 00       	mov    $0x0,%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 220:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 227:	eb 42                	jmp    26b <gets+0x51>
    cc = read(0, &c, 1);
 229:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 230:	00 
 231:	8d 45 ef             	lea    -0x11(%ebp),%eax
 234:	89 44 24 04          	mov    %eax,0x4(%esp)
 238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 23f:	e8 2f 01 00 00       	call   373 <read>
 244:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24b:	7e 29                	jle    276 <gets+0x5c>
      break;
    buf[i++] = c;
 24d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	01 c2                	add    %eax,%edx
 255:	8a 45 ef             	mov    -0x11(%ebp),%al
 258:	88 02                	mov    %al,(%edx)
 25a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 25d:	8a 45 ef             	mov    -0x11(%ebp),%al
 260:	3c 0a                	cmp    $0xa,%al
 262:	74 13                	je     277 <gets+0x5d>
 264:	8a 45 ef             	mov    -0x11(%ebp),%al
 267:	3c 0d                	cmp    $0xd,%al
 269:	74 0c                	je     277 <gets+0x5d>
  for(i=0; i+1 < max; ){
 26b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26e:	40                   	inc    %eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b5                	jl     229 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5d>
      break;
 276:	90                   	nop
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 294:	00 
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 04 24             	mov    %eax,(%esp)
 29b:	e8 fb 00 00 00       	call   39b <open>
 2a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a7:	79 07                	jns    2b0 <stat+0x29>
    return -1;
 2a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ae:	eb 23                	jmp    2d3 <stat+0x4c>
  r = fstat(fd, st);
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ba:	89 04 24             	mov    %eax,(%esp)
 2bd:	e8 f1 00 00 00       	call   3b3 <fstat>
 2c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c8:	89 04 24             	mov    %eax,(%esp)
 2cb:	e8 b3 00 00 00       	call   383 <close>
  return r;
 2d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    

000002d5 <atoi>:

int
atoi(const char *s)
{
 2d5:	55                   	push   %ebp
 2d6:	89 e5                	mov    %esp,%ebp
 2d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e2:	eb 21                	jmp    305 <atoi+0x30>
    n = n*10 + *s++ - '0';
 2e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	c1 e0 02             	shl    $0x2,%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	d1 e0                	shl    %eax
 2f0:	89 c2                	mov    %eax,%edx
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	8a 00                	mov    (%eax),%al
 2f7:	0f be c0             	movsbl %al,%eax
 2fa:	01 d0                	add    %edx,%eax
 2fc:	83 e8 30             	sub    $0x30,%eax
 2ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
 302:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	8a 00                	mov    (%eax),%al
 30a:	3c 2f                	cmp    $0x2f,%al
 30c:	7e 09                	jle    317 <atoi+0x42>
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	8a 00                	mov    (%eax),%al
 313:	3c 39                	cmp    $0x39,%al
 315:	7e cd                	jle    2e4 <atoi+0xf>
  return n;
 317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31a:	c9                   	leave  
 31b:	c3                   	ret    

0000031c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 328:	8b 45 0c             	mov    0xc(%ebp),%eax
 32b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 32e:	eb 10                	jmp    340 <memmove+0x24>
    *dst++ = *src++;
 330:	8b 45 f8             	mov    -0x8(%ebp),%eax
 333:	8a 10                	mov    (%eax),%dl
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
 338:	88 10                	mov    %dl,(%eax)
 33a:	ff 45 fc             	incl   -0x4(%ebp)
 33d:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 340:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 344:	0f 9f c0             	setg   %al
 347:	ff 4d 10             	decl   0x10(%ebp)
 34a:	84 c0                	test   %al,%al
 34c:	75 e2                	jne    330 <memmove+0x14>
  return vdst;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 351:	c9                   	leave  
 352:	c3                   	ret    

00000353 <fork>:
 353:	b8 01 00 00 00       	mov    $0x1,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <exit>:
 35b:	b8 02 00 00 00       	mov    $0x2,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <wait>:
 363:	b8 03 00 00 00       	mov    $0x3,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <pipe>:
 36b:	b8 04 00 00 00       	mov    $0x4,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <read>:
 373:	b8 05 00 00 00       	mov    $0x5,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <write>:
 37b:	b8 10 00 00 00       	mov    $0x10,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <close>:
 383:	b8 15 00 00 00       	mov    $0x15,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <kill>:
 38b:	b8 06 00 00 00       	mov    $0x6,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <exec>:
 393:	b8 07 00 00 00       	mov    $0x7,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <open>:
 39b:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <mknod>:
 3a3:	b8 11 00 00 00       	mov    $0x11,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <unlink>:
 3ab:	b8 12 00 00 00       	mov    $0x12,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <fstat>:
 3b3:	b8 08 00 00 00       	mov    $0x8,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <link>:
 3bb:	b8 13 00 00 00       	mov    $0x13,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <mkdir>:
 3c3:	b8 14 00 00 00       	mov    $0x14,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <chdir>:
 3cb:	b8 09 00 00 00       	mov    $0x9,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <dup>:
 3d3:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <getpid>:
 3db:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <sbrk>:
 3e3:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sleep>:
 3eb:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <uptime>:
 3f3:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <lseek>:
 3fb:	b8 16 00 00 00       	mov    $0x16,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <isatty>:
 403:	b8 17 00 00 00       	mov    $0x17,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    
