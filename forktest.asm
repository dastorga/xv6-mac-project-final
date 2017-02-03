
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
   c:	e8 af 01 00 00       	call   1c0 <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 73 03 00 00       	call   39a <write>
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
  2f:	c7 44 24 04 3c 04 00 	movl   $0x43c,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 3b                	jmp    87 <forktest+0x5e>
   if (n >= 5){ // fifth fork()
  4c:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  50:	7e 19                	jle    6b <forktest+0x42>
      printf(1,"new system call procstat\n");
  52:	c7 44 24 04 47 04 00 	movl   $0x447,0x4(%esp)
  59:	00 
  5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  61:	e8 9a ff ff ff       	call   0 <printf>
      procstat(); // New - system call procstat
  66:	e8 bf 03 00 00       	call   42a <procstat>
    } 
    pid = fork();
  6b:	e8 02 03 00 00       	call   372 <fork>
  70:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  77:	78 19                	js     92 <forktest+0x69>
      break;
    if(pid == 0)
  79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  7d:	75 05                	jne    84 <forktest+0x5b>
      exit();
  7f:	e8 f6 02 00 00       	call   37a <exit>
  for(n=0; n<N; n++){
  84:	ff 45 f4             	incl   -0xc(%ebp)
  87:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  8e:	7e bc                	jle    4c <forktest+0x23>
  90:	eb 01                	jmp    93 <forktest+0x6a>
      break;
  92:	90                   	nop
  }
  
  if(n == N){
  93:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  9a:	75 46                	jne    e2 <forktest+0xb9>
    printf(1, "fork claimed to work N times!\n", N);
  9c:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  a3:	00 
  a4:	c7 44 24 04 64 04 00 	movl   $0x464,0x4(%esp)
  ab:	00 
  ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b3:	e8 48 ff ff ff       	call   0 <printf>
    exit();
  b8:	e8 bd 02 00 00       	call   37a <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
  bd:	e8 c0 02 00 00       	call   382 <wait>
  c2:	85 c0                	test   %eax,%eax
  c4:	79 19                	jns    df <forktest+0xb6>
      printf(1, "wait stopped early\n");
  c6:	c7 44 24 04 83 04 00 	movl   $0x483,0x4(%esp)
  cd:	00 
  ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d5:	e8 26 ff ff ff       	call   0 <printf>
      exit();
  da:	e8 9b 02 00 00       	call   37a <exit>
  for(; n > 0; n--){
  df:	ff 4d f4             	decl   -0xc(%ebp)
  e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  e6:	7f d5                	jg     bd <forktest+0x94>
    }
  }
  
  if(wait() != -1){
  e8:	e8 95 02 00 00       	call   382 <wait>
  ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  f0:	74 19                	je     10b <forktest+0xe2>
    printf(1, "wait got too many\n");
  f2:	c7 44 24 04 97 04 00 	movl   $0x497,0x4(%esp)
  f9:	00 
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	e8 fa fe ff ff       	call   0 <printf>
    exit();
 106:	e8 6f 02 00 00       	call   37a <exit>
  }
  
  printf(1, "fork test OK\n");
 10b:	c7 44 24 04 aa 04 00 	movl   $0x4aa,0x4(%esp)
 112:	00 
 113:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 11a:	e8 e1 fe ff ff       	call   0 <printf>
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <main>:

int
main(void)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 127:	e8 fd fe ff ff       	call   29 <forktest>
  exit();
 12c:	e8 49 02 00 00       	call   37a <exit>

00000131 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	57                   	push   %edi
 135:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 136:	8b 4d 08             	mov    0x8(%ebp),%ecx
 139:	8b 55 10             	mov    0x10(%ebp),%edx
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	89 cb                	mov    %ecx,%ebx
 141:	89 df                	mov    %ebx,%edi
 143:	89 d1                	mov    %edx,%ecx
 145:	fc                   	cld    
 146:	f3 aa                	rep stos %al,%es:(%edi)
 148:	89 ca                	mov    %ecx,%edx
 14a:	89 fb                	mov    %edi,%ebx
 14c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 14f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 152:	5b                   	pop    %ebx
 153:	5f                   	pop    %edi
 154:	5d                   	pop    %ebp
 155:	c3                   	ret    

00000156 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 156:	55                   	push   %ebp
 157:	89 e5                	mov    %esp,%ebp
 159:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 162:	90                   	nop
 163:	8b 45 0c             	mov    0xc(%ebp),%eax
 166:	8a 10                	mov    (%eax),%dl
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	88 10                	mov    %dl,(%eax)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	8a 00                	mov    (%eax),%al
 172:	84 c0                	test   %al,%al
 174:	0f 95 c0             	setne  %al
 177:	ff 45 08             	incl   0x8(%ebp)
 17a:	ff 45 0c             	incl   0xc(%ebp)
 17d:	84 c0                	test   %al,%al
 17f:	75 e2                	jne    163 <strcpy+0xd>
    ;
  return os;
 181:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 184:	c9                   	leave  
 185:	c3                   	ret    

00000186 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 189:	eb 06                	jmp    191 <strcmp+0xb>
    p++, q++;
 18b:	ff 45 08             	incl   0x8(%ebp)
 18e:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	8a 00                	mov    (%eax),%al
 196:	84 c0                	test   %al,%al
 198:	74 0e                	je     1a8 <strcmp+0x22>
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	8a 10                	mov    (%eax),%dl
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	8a 00                	mov    (%eax),%al
 1a4:	38 c2                	cmp    %al,%dl
 1a6:	74 e3                	je     18b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1a8:	8b 45 08             	mov    0x8(%ebp),%eax
 1ab:	8a 00                	mov    (%eax),%al
 1ad:	0f b6 d0             	movzbl %al,%edx
 1b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b3:	8a 00                	mov    (%eax),%al
 1b5:	0f b6 c0             	movzbl %al,%eax
 1b8:	89 d1                	mov    %edx,%ecx
 1ba:	29 c1                	sub    %eax,%ecx
 1bc:	89 c8                	mov    %ecx,%eax
}
 1be:	5d                   	pop    %ebp
 1bf:	c3                   	ret    

000001c0 <strlen>:

uint
strlen(char *s)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cd:	eb 03                	jmp    1d2 <strlen+0x12>
 1cf:	ff 45 fc             	incl   -0x4(%ebp)
 1d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	01 d0                	add    %edx,%eax
 1da:	8a 00                	mov    (%eax),%al
 1dc:	84 c0                	test   %al,%al
 1de:	75 ef                	jne    1cf <strlen+0xf>
    ;
  return n;
 1e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1eb:	8b 45 10             	mov    0x10(%ebp),%eax
 1ee:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	89 04 24             	mov    %eax,(%esp)
 1ff:	e8 2d ff ff ff       	call   131 <stosb>
  return dst;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
}
 207:	c9                   	leave  
 208:	c3                   	ret    

00000209 <strchr>:

char*
strchr(const char *s, char c)
{
 209:	55                   	push   %ebp
 20a:	89 e5                	mov    %esp,%ebp
 20c:	83 ec 04             	sub    $0x4,%esp
 20f:	8b 45 0c             	mov    0xc(%ebp),%eax
 212:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 215:	eb 12                	jmp    229 <strchr+0x20>
    if(*s == c)
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8a 00                	mov    (%eax),%al
 21c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 21f:	75 05                	jne    226 <strchr+0x1d>
      return (char*)s;
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	eb 11                	jmp    237 <strchr+0x2e>
  for(; *s; s++)
 226:	ff 45 08             	incl   0x8(%ebp)
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	8a 00                	mov    (%eax),%al
 22e:	84 c0                	test   %al,%al
 230:	75 e5                	jne    217 <strchr+0xe>
  return 0;
 232:	b8 00 00 00 00       	mov    $0x0,%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <gets>:

char*
gets(char *buf, int max)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 23f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 246:	eb 42                	jmp    28a <gets+0x51>
    cc = read(0, &c, 1);
 248:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 24f:	00 
 250:	8d 45 ef             	lea    -0x11(%ebp),%eax
 253:	89 44 24 04          	mov    %eax,0x4(%esp)
 257:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 25e:	e8 2f 01 00 00       	call   392 <read>
 263:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 26a:	7e 29                	jle    295 <gets+0x5c>
      break;
    buf[i++] = c;
 26c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	01 c2                	add    %eax,%edx
 274:	8a 45 ef             	mov    -0x11(%ebp),%al
 277:	88 02                	mov    %al,(%edx)
 279:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 27c:	8a 45 ef             	mov    -0x11(%ebp),%al
 27f:	3c 0a                	cmp    $0xa,%al
 281:	74 13                	je     296 <gets+0x5d>
 283:	8a 45 ef             	mov    -0x11(%ebp),%al
 286:	3c 0d                	cmp    $0xd,%al
 288:	74 0c                	je     296 <gets+0x5d>
  for(i=0; i+1 < max; ){
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28d:	40                   	inc    %eax
 28e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 291:	7c b5                	jl     248 <gets+0xf>
 293:	eb 01                	jmp    296 <gets+0x5d>
      break;
 295:	90                   	nop
      break;
  }
  buf[i] = '\0';
 296:	8b 55 f4             	mov    -0xc(%ebp),%edx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	01 d0                	add    %edx,%eax
 29e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <stat>:

int
stat(char *n, struct stat *st)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2b3:	00 
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	89 04 24             	mov    %eax,(%esp)
 2ba:	e8 fb 00 00 00       	call   3ba <open>
 2bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2c6:	79 07                	jns    2cf <stat+0x29>
    return -1;
 2c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2cd:	eb 23                	jmp    2f2 <stat+0x4c>
  r = fstat(fd, st);
 2cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 f1 00 00 00       	call   3d2 <fstat>
 2e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e7:	89 04 24             	mov    %eax,(%esp)
 2ea:	e8 b3 00 00 00       	call   3a2 <close>
  return r;
 2ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2f2:	c9                   	leave  
 2f3:	c3                   	ret    

000002f4 <atoi>:

int
atoi(const char *s)
{
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 301:	eb 21                	jmp    324 <atoi+0x30>
    n = n*10 + *s++ - '0';
 303:	8b 55 fc             	mov    -0x4(%ebp),%edx
 306:	89 d0                	mov    %edx,%eax
 308:	c1 e0 02             	shl    $0x2,%eax
 30b:	01 d0                	add    %edx,%eax
 30d:	d1 e0                	shl    %eax
 30f:	89 c2                	mov    %eax,%edx
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	8a 00                	mov    (%eax),%al
 316:	0f be c0             	movsbl %al,%eax
 319:	01 d0                	add    %edx,%eax
 31b:	83 e8 30             	sub    $0x30,%eax
 31e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 321:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8a 00                	mov    (%eax),%al
 329:	3c 2f                	cmp    $0x2f,%al
 32b:	7e 09                	jle    336 <atoi+0x42>
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	8a 00                	mov    (%eax),%al
 332:	3c 39                	cmp    $0x39,%al
 334:	7e cd                	jle    303 <atoi+0xf>
  return n;
 336:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 34d:	eb 10                	jmp    35f <memmove+0x24>
    *dst++ = *src++;
 34f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 352:	8a 10                	mov    (%eax),%dl
 354:	8b 45 fc             	mov    -0x4(%ebp),%eax
 357:	88 10                	mov    %dl,(%eax)
 359:	ff 45 fc             	incl   -0x4(%ebp)
 35c:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 35f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 363:	0f 9f c0             	setg   %al
 366:	ff 4d 10             	decl   0x10(%ebp)
 369:	84 c0                	test   %al,%al
 36b:	75 e2                	jne    34f <memmove+0x14>
  return vdst;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <fork>:
 372:	b8 01 00 00 00       	mov    $0x1,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <exit>:
 37a:	b8 02 00 00 00       	mov    $0x2,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <wait>:
 382:	b8 03 00 00 00       	mov    $0x3,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <pipe>:
 38a:	b8 04 00 00 00       	mov    $0x4,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <read>:
 392:	b8 05 00 00 00       	mov    $0x5,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <write>:
 39a:	b8 10 00 00 00       	mov    $0x10,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <close>:
 3a2:	b8 15 00 00 00       	mov    $0x15,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <kill>:
 3aa:	b8 06 00 00 00       	mov    $0x6,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <exec>:
 3b2:	b8 07 00 00 00       	mov    $0x7,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <open>:
 3ba:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <mknod>:
 3c2:	b8 11 00 00 00       	mov    $0x11,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <unlink>:
 3ca:	b8 12 00 00 00       	mov    $0x12,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <fstat>:
 3d2:	b8 08 00 00 00       	mov    $0x8,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <link>:
 3da:	b8 13 00 00 00       	mov    $0x13,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <mkdir>:
 3e2:	b8 14 00 00 00       	mov    $0x14,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <chdir>:
 3ea:	b8 09 00 00 00       	mov    $0x9,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <dup>:
 3f2:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <getpid>:
 3fa:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <sbrk>:
 402:	b8 0c 00 00 00       	mov    $0xc,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sleep>:
 40a:	b8 0d 00 00 00       	mov    $0xd,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <uptime>:
 412:	b8 0e 00 00 00       	mov    $0xe,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <lseek>:
 41a:	b8 16 00 00 00       	mov    $0x16,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <isatty>:
 422:	b8 17 00 00 00       	mov    $0x17,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <procstat>:
 42a:	b8 18 00 00 00       	mov    $0x18,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <set_priority>:
 432:	b8 19 00 00 00       	mov    $0x19,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    
