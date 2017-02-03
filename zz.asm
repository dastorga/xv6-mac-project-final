
_zz:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
	printf(1, "foo\n");
   9:	c7 44 24 04 c8 07 00 	movl   $0x7c8,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 e6 03 00 00       	call   403 <printf>
	exit();
  1d:	e8 49 02 00 00       	call   26b <exit>

00000022 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  22:	55                   	push   %ebp
  23:	89 e5                	mov    %esp,%ebp
  25:	57                   	push   %edi
  26:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2a:	8b 55 10             	mov    0x10(%ebp),%edx
  2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  30:	89 cb                	mov    %ecx,%ebx
  32:	89 df                	mov    %ebx,%edi
  34:	89 d1                	mov    %edx,%ecx
  36:	fc                   	cld    
  37:	f3 aa                	rep stos %al,%es:(%edi)
  39:	89 ca                	mov    %ecx,%edx
  3b:	89 fb                	mov    %edi,%ebx
  3d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  40:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  43:	5b                   	pop    %ebx
  44:	5f                   	pop    %edi
  45:	5d                   	pop    %ebp
  46:	c3                   	ret    

00000047 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  47:	55                   	push   %ebp
  48:	89 e5                	mov    %esp,%ebp
  4a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4d:	8b 45 08             	mov    0x8(%ebp),%eax
  50:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  53:	90                   	nop
  54:	8b 45 0c             	mov    0xc(%ebp),%eax
  57:	8a 10                	mov    (%eax),%dl
  59:	8b 45 08             	mov    0x8(%ebp),%eax
  5c:	88 10                	mov    %dl,(%eax)
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8a 00                	mov    (%eax),%al
  63:	84 c0                	test   %al,%al
  65:	0f 95 c0             	setne  %al
  68:	ff 45 08             	incl   0x8(%ebp)
  6b:	ff 45 0c             	incl   0xc(%ebp)
  6e:	84 c0                	test   %al,%al
  70:	75 e2                	jne    54 <strcpy+0xd>
    ;
  return os;
  72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  75:	c9                   	leave  
  76:	c3                   	ret    

00000077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7a:	eb 06                	jmp    82 <strcmp+0xb>
    p++, q++;
  7c:	ff 45 08             	incl   0x8(%ebp)
  7f:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  82:	8b 45 08             	mov    0x8(%ebp),%eax
  85:	8a 00                	mov    (%eax),%al
  87:	84 c0                	test   %al,%al
  89:	74 0e                	je     99 <strcmp+0x22>
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	8a 10                	mov    (%eax),%dl
  90:	8b 45 0c             	mov    0xc(%ebp),%eax
  93:	8a 00                	mov    (%eax),%al
  95:	38 c2                	cmp    %al,%dl
  97:	74 e3                	je     7c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8a 00                	mov    (%eax),%al
  9e:	0f b6 d0             	movzbl %al,%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	8a 00                	mov    (%eax),%al
  a6:	0f b6 c0             	movzbl %al,%eax
  a9:	89 d1                	mov    %edx,%ecx
  ab:	29 c1                	sub    %eax,%ecx
  ad:	89 c8                	mov    %ecx,%eax
}
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    

000000b1 <strlen>:

uint
strlen(char *s)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  be:	eb 03                	jmp    c3 <strlen+0x12>
  c0:	ff 45 fc             	incl   -0x4(%ebp)
  c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	01 d0                	add    %edx,%eax
  cb:	8a 00                	mov    (%eax),%al
  cd:	84 c0                	test   %al,%al
  cf:	75 ef                	jne    c0 <strlen+0xf>
    ;
  return n;
  d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d4:	c9                   	leave  
  d5:	c3                   	ret    

000000d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d6:	55                   	push   %ebp
  d7:	89 e5                	mov    %esp,%ebp
  d9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  dc:	8b 45 10             	mov    0x10(%ebp),%eax
  df:	89 44 24 08          	mov    %eax,0x8(%esp)
  e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 2d ff ff ff       	call   22 <stosb>
  return dst;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 04             	sub    $0x4,%esp
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 106:	eb 12                	jmp    11a <strchr+0x20>
    if(*s == c)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	8a 00                	mov    (%eax),%al
 10d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 110:	75 05                	jne    117 <strchr+0x1d>
      return (char*)s;
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	eb 11                	jmp    128 <strchr+0x2e>
  for(; *s; s++)
 117:	ff 45 08             	incl   0x8(%ebp)
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	8a 00                	mov    (%eax),%al
 11f:	84 c0                	test   %al,%al
 121:	75 e5                	jne    108 <strchr+0xe>
  return 0;
 123:	b8 00 00 00 00       	mov    $0x0,%eax
}
 128:	c9                   	leave  
 129:	c3                   	ret    

0000012a <gets>:

char*
gets(char *buf, int max)
{
 12a:	55                   	push   %ebp
 12b:	89 e5                	mov    %esp,%ebp
 12d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 137:	eb 42                	jmp    17b <gets+0x51>
    cc = read(0, &c, 1);
 139:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 140:	00 
 141:	8d 45 ef             	lea    -0x11(%ebp),%eax
 144:	89 44 24 04          	mov    %eax,0x4(%esp)
 148:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 14f:	e8 2f 01 00 00       	call   283 <read>
 154:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 157:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15b:	7e 29                	jle    186 <gets+0x5c>
      break;
    buf[i++] = c;
 15d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	01 c2                	add    %eax,%edx
 165:	8a 45 ef             	mov    -0x11(%ebp),%al
 168:	88 02                	mov    %al,(%edx)
 16a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 16d:	8a 45 ef             	mov    -0x11(%ebp),%al
 170:	3c 0a                	cmp    $0xa,%al
 172:	74 13                	je     187 <gets+0x5d>
 174:	8a 45 ef             	mov    -0x11(%ebp),%al
 177:	3c 0d                	cmp    $0xd,%al
 179:	74 0c                	je     187 <gets+0x5d>
  for(i=0; i+1 < max; ){
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	40                   	inc    %eax
 17f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 182:	7c b5                	jl     139 <gets+0xf>
 184:	eb 01                	jmp    187 <gets+0x5d>
      break;
 186:	90                   	nop
      break;
  }
  buf[i] = '\0';
 187:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	01 d0                	add    %edx,%eax
 18f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 192:	8b 45 08             	mov    0x8(%ebp),%eax
}
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <stat>:

int
stat(char *n, struct stat *st)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a4:	00 
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	89 04 24             	mov    %eax,(%esp)
 1ab:	e8 fb 00 00 00       	call   2ab <open>
 1b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b7:	79 07                	jns    1c0 <stat+0x29>
    return -1;
 1b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1be:	eb 23                	jmp    1e3 <stat+0x4c>
  r = fstat(fd, st);
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ca:	89 04 24             	mov    %eax,(%esp)
 1cd:	e8 f1 00 00 00       	call   2c3 <fstat>
 1d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d8:	89 04 24             	mov    %eax,(%esp)
 1db:	e8 b3 00 00 00       	call   293 <close>
  return r;
 1e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <atoi>:

int
atoi(const char *s)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f2:	eb 21                	jmp    215 <atoi+0x30>
    n = n*10 + *s++ - '0';
 1f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	c1 e0 02             	shl    $0x2,%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	d1 e0                	shl    %eax
 200:	89 c2                	mov    %eax,%edx
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	8a 00                	mov    (%eax),%al
 207:	0f be c0             	movsbl %al,%eax
 20a:	01 d0                	add    %edx,%eax
 20c:	83 e8 30             	sub    $0x30,%eax
 20f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 212:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	8a 00                	mov    (%eax),%al
 21a:	3c 2f                	cmp    $0x2f,%al
 21c:	7e 09                	jle    227 <atoi+0x42>
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	8a 00                	mov    (%eax),%al
 223:	3c 39                	cmp    $0x39,%al
 225:	7e cd                	jle    1f4 <atoi+0xf>
  return n;
 227:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 23e:	eb 10                	jmp    250 <memmove+0x24>
    *dst++ = *src++;
 240:	8b 45 f8             	mov    -0x8(%ebp),%eax
 243:	8a 10                	mov    (%eax),%dl
 245:	8b 45 fc             	mov    -0x4(%ebp),%eax
 248:	88 10                	mov    %dl,(%eax)
 24a:	ff 45 fc             	incl   -0x4(%ebp)
 24d:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 250:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 254:	0f 9f c0             	setg   %al
 257:	ff 4d 10             	decl   0x10(%ebp)
 25a:	84 c0                	test   %al,%al
 25c:	75 e2                	jne    240 <memmove+0x14>
  return vdst;
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 261:	c9                   	leave  
 262:	c3                   	ret    

00000263 <fork>:
 263:	b8 01 00 00 00       	mov    $0x1,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <exit>:
 26b:	b8 02 00 00 00       	mov    $0x2,%eax
 270:	cd 40                	int    $0x40
 272:	c3                   	ret    

00000273 <wait>:
 273:	b8 03 00 00 00       	mov    $0x3,%eax
 278:	cd 40                	int    $0x40
 27a:	c3                   	ret    

0000027b <pipe>:
 27b:	b8 04 00 00 00       	mov    $0x4,%eax
 280:	cd 40                	int    $0x40
 282:	c3                   	ret    

00000283 <read>:
 283:	b8 05 00 00 00       	mov    $0x5,%eax
 288:	cd 40                	int    $0x40
 28a:	c3                   	ret    

0000028b <write>:
 28b:	b8 10 00 00 00       	mov    $0x10,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <close>:
 293:	b8 15 00 00 00       	mov    $0x15,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <kill>:
 29b:	b8 06 00 00 00       	mov    $0x6,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <exec>:
 2a3:	b8 07 00 00 00       	mov    $0x7,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <open>:
 2ab:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <mknod>:
 2b3:	b8 11 00 00 00       	mov    $0x11,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <unlink>:
 2bb:	b8 12 00 00 00       	mov    $0x12,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <fstat>:
 2c3:	b8 08 00 00 00       	mov    $0x8,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <link>:
 2cb:	b8 13 00 00 00       	mov    $0x13,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <mkdir>:
 2d3:	b8 14 00 00 00       	mov    $0x14,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <chdir>:
 2db:	b8 09 00 00 00       	mov    $0x9,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <dup>:
 2e3:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <getpid>:
 2eb:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <sbrk>:
 2f3:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <sleep>:
 2fb:	b8 0d 00 00 00       	mov    $0xd,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <uptime>:
 303:	b8 0e 00 00 00       	mov    $0xe,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <lseek>:
 30b:	b8 16 00 00 00       	mov    $0x16,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <isatty>:
 313:	b8 17 00 00 00       	mov    $0x17,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <procstat>:
 31b:	b8 18 00 00 00       	mov    $0x18,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <set_priority>:
 323:	b8 19 00 00 00       	mov    $0x19,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	83 ec 28             	sub    $0x28,%esp
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 337:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 33e:	00 
 33f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 342:	89 44 24 04          	mov    %eax,0x4(%esp)
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	89 04 24             	mov    %eax,(%esp)
 34c:	e8 3a ff ff ff       	call   28b <write>
}
 351:	c9                   	leave  
 352:	c3                   	ret    

00000353 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 359:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 360:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 364:	74 17                	je     37d <printint+0x2a>
 366:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36a:	79 11                	jns    37d <printint+0x2a>
    neg = 1;
 36c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 373:	8b 45 0c             	mov    0xc(%ebp),%eax
 376:	f7 d8                	neg    %eax
 378:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37b:	eb 06                	jmp    383 <printint+0x30>
  } else {
    x = xx;
 37d:	8b 45 0c             	mov    0xc(%ebp),%eax
 380:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 383:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38a:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 390:	ba 00 00 00 00       	mov    $0x0,%edx
 395:	f7 f1                	div    %ecx
 397:	89 d0                	mov    %edx,%eax
 399:	8a 80 10 0a 00 00    	mov    0xa10(%eax),%al
 39f:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a5:	01 ca                	add    %ecx,%edx
 3a7:	88 02                	mov    %al,(%edx)
 3a9:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3ac:	8b 55 10             	mov    0x10(%ebp),%edx
 3af:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ba:	f7 75 d4             	divl   -0x2c(%ebp)
 3bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c4:	75 c4                	jne    38a <printint+0x37>
  if(neg)
 3c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3ca:	74 2c                	je     3f8 <printint+0xa5>
    buf[i++] = '-';
 3cc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d2:	01 d0                	add    %edx,%eax
 3d4:	c6 00 2d             	movb   $0x2d,(%eax)
 3d7:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3da:	eb 1c                	jmp    3f8 <printint+0xa5>
    putc(fd, buf[i]);
 3dc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e2:	01 d0                	add    %edx,%eax
 3e4:	8a 00                	mov    (%eax),%al
 3e6:	0f be c0             	movsbl %al,%eax
 3e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	89 04 24             	mov    %eax,(%esp)
 3f3:	e8 33 ff ff ff       	call   32b <putc>
  while(--i >= 0)
 3f8:	ff 4d f4             	decl   -0xc(%ebp)
 3fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ff:	79 db                	jns    3dc <printint+0x89>
}
 401:	c9                   	leave  
 402:	c3                   	ret    

00000403 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 409:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 410:	8d 45 0c             	lea    0xc(%ebp),%eax
 413:	83 c0 04             	add    $0x4,%eax
 416:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 419:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 420:	e9 78 01 00 00       	jmp    59d <printf+0x19a>
    c = fmt[i] & 0xff;
 425:	8b 55 0c             	mov    0xc(%ebp),%edx
 428:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	8a 00                	mov    (%eax),%al
 42f:	0f be c0             	movsbl %al,%eax
 432:	25 ff 00 00 00       	and    $0xff,%eax
 437:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 43a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43e:	75 2c                	jne    46c <printf+0x69>
      if(c == '%'){
 440:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 444:	75 0c                	jne    452 <printf+0x4f>
        state = '%';
 446:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 44d:	e9 48 01 00 00       	jmp    59a <printf+0x197>
      } else {
        putc(fd, c);
 452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 455:	0f be c0             	movsbl %al,%eax
 458:	89 44 24 04          	mov    %eax,0x4(%esp)
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	89 04 24             	mov    %eax,(%esp)
 462:	e8 c4 fe ff ff       	call   32b <putc>
 467:	e9 2e 01 00 00       	jmp    59a <printf+0x197>
      }
    } else if(state == '%'){
 46c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 470:	0f 85 24 01 00 00    	jne    59a <printf+0x197>
      if(c == 'd'){
 476:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 47a:	75 2d                	jne    4a9 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 47c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 47f:	8b 00                	mov    (%eax),%eax
 481:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 488:	00 
 489:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 490:	00 
 491:	89 44 24 04          	mov    %eax,0x4(%esp)
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 b3 fe ff ff       	call   353 <printint>
        ap++;
 4a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a4:	e9 ea 00 00 00       	jmp    593 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4a9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ad:	74 06                	je     4b5 <printf+0xb2>
 4af:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b3:	75 2d                	jne    4e2 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b8:	8b 00                	mov    (%eax),%eax
 4ba:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4c1:	00 
 4c2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4c9:	00 
 4ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	89 04 24             	mov    %eax,(%esp)
 4d4:	e8 7a fe ff ff       	call   353 <printint>
        ap++;
 4d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4dd:	e9 b1 00 00 00       	jmp    593 <printf+0x190>
      } else if(c == 's'){
 4e2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4e6:	75 43                	jne    52b <printf+0x128>
        s = (char*)*ap;
 4e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4eb:	8b 00                	mov    (%eax),%eax
 4ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f8:	75 25                	jne    51f <printf+0x11c>
          s = "(null)";
 4fa:	c7 45 f4 cd 07 00 00 	movl   $0x7cd,-0xc(%ebp)
        while(*s != 0){
 501:	eb 1c                	jmp    51f <printf+0x11c>
          putc(fd, *s);
 503:	8b 45 f4             	mov    -0xc(%ebp),%eax
 506:	8a 00                	mov    (%eax),%al
 508:	0f be c0             	movsbl %al,%eax
 50b:	89 44 24 04          	mov    %eax,0x4(%esp)
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	89 04 24             	mov    %eax,(%esp)
 515:	e8 11 fe ff ff       	call   32b <putc>
          s++;
 51a:	ff 45 f4             	incl   -0xc(%ebp)
 51d:	eb 01                	jmp    520 <printf+0x11d>
        while(*s != 0){
 51f:	90                   	nop
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	8a 00                	mov    (%eax),%al
 525:	84 c0                	test   %al,%al
 527:	75 da                	jne    503 <printf+0x100>
 529:	eb 68                	jmp    593 <printf+0x190>
        }
      } else if(c == 'c'){
 52b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 52f:	75 1d                	jne    54e <printf+0x14b>
        putc(fd, *ap);
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	89 44 24 04          	mov    %eax,0x4(%esp)
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	89 04 24             	mov    %eax,(%esp)
 543:	e8 e3 fd ff ff       	call   32b <putc>
        ap++;
 548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54c:	eb 45                	jmp    593 <printf+0x190>
      } else if(c == '%'){
 54e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 552:	75 17                	jne    56b <printf+0x168>
        putc(fd, c);
 554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 557:	0f be c0             	movsbl %al,%eax
 55a:	89 44 24 04          	mov    %eax,0x4(%esp)
 55e:	8b 45 08             	mov    0x8(%ebp),%eax
 561:	89 04 24             	mov    %eax,(%esp)
 564:	e8 c2 fd ff ff       	call   32b <putc>
 569:	eb 28                	jmp    593 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 572:	00 
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	89 04 24             	mov    %eax,(%esp)
 579:	e8 ad fd ff ff       	call   32b <putc>
        putc(fd, c);
 57e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 98 fd ff ff       	call   32b <putc>
      }
      state = 0;
 593:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 59a:	ff 45 f0             	incl   -0x10(%ebp)
 59d:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a3:	01 d0                	add    %edx,%eax
 5a5:	8a 00                	mov    (%eax),%al
 5a7:	84 c0                	test   %al,%al
 5a9:	0f 85 76 fe ff ff    	jne    425 <printf+0x22>
    }
  }
}
 5af:	c9                   	leave  
 5b0:	c3                   	ret    

000005b1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b1:	55                   	push   %ebp
 5b2:	89 e5                	mov    %esp,%ebp
 5b4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	83 e8 08             	sub    $0x8,%eax
 5bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c0:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 5c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c8:	eb 24                	jmp    5ee <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d2:	77 12                	ja     5e6 <free+0x35>
 5d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5da:	77 24                	ja     600 <free+0x4f>
 5dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5df:	8b 00                	mov    (%eax),%eax
 5e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e4:	77 1a                	ja     600 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f4:	76 d4                	jbe    5ca <free+0x19>
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5fe:	76 ca                	jbe    5ca <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 600:	8b 45 f8             	mov    -0x8(%ebp),%eax
 603:	8b 40 04             	mov    0x4(%eax),%eax
 606:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 60d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 610:	01 c2                	add    %eax,%edx
 612:	8b 45 fc             	mov    -0x4(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	39 c2                	cmp    %eax,%edx
 619:	75 24                	jne    63f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	8b 50 04             	mov    0x4(%eax),%edx
 621:	8b 45 fc             	mov    -0x4(%ebp),%eax
 624:	8b 00                	mov    (%eax),%eax
 626:	8b 40 04             	mov    0x4(%eax),%eax
 629:	01 c2                	add    %eax,%edx
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 00                	mov    (%eax),%eax
 636:	8b 10                	mov    (%eax),%edx
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	89 10                	mov    %edx,(%eax)
 63d:	eb 0a                	jmp    649 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 10                	mov    (%eax),%edx
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 40 04             	mov    0x4(%eax),%eax
 64f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	01 d0                	add    %edx,%eax
 65b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65e:	75 20                	jne    680 <free+0xcf>
    p->s.size += bp->s.size;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	8b 50 04             	mov    0x4(%eax),%edx
 666:	8b 45 f8             	mov    -0x8(%ebp),%eax
 669:	8b 40 04             	mov    0x4(%eax),%eax
 66c:	01 c2                	add    %eax,%edx
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	8b 10                	mov    (%eax),%edx
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67c:	89 10                	mov    %edx,(%eax)
 67e:	eb 08                	jmp    688 <free+0xd7>
  } else
    p->s.ptr = bp;
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 55 f8             	mov    -0x8(%ebp),%edx
 686:	89 10                	mov    %edx,(%eax)
  freep = p;
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	a3 2c 0a 00 00       	mov    %eax,0xa2c
}
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <morecore>:

static Header*
morecore(uint nu)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 698:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 69f:	77 07                	ja     6a8 <morecore+0x16>
    nu = 4096;
 6a1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	c1 e0 03             	shl    $0x3,%eax
 6ae:	89 04 24             	mov    %eax,(%esp)
 6b1:	e8 3d fc ff ff       	call   2f3 <sbrk>
 6b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6b9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6bd:	75 07                	jne    6c6 <morecore+0x34>
    return 0;
 6bf:	b8 00 00 00 00       	mov    $0x0,%eax
 6c4:	eb 22                	jmp    6e8 <morecore+0x56>
  hp = (Header*)p;
 6c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cf:	8b 55 08             	mov    0x8(%ebp),%edx
 6d2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d8:	83 c0 08             	add    $0x8,%eax
 6db:	89 04 24             	mov    %eax,(%esp)
 6de:	e8 ce fe ff ff       	call   5b1 <free>
  return freep;
 6e3:	a1 2c 0a 00 00       	mov    0xa2c,%eax
}
 6e8:	c9                   	leave  
 6e9:	c3                   	ret    

000006ea <malloc>:

void*
malloc(uint nbytes)
{
 6ea:	55                   	push   %ebp
 6eb:	89 e5                	mov    %esp,%ebp
 6ed:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f0:	8b 45 08             	mov    0x8(%ebp),%eax
 6f3:	83 c0 07             	add    $0x7,%eax
 6f6:	c1 e8 03             	shr    $0x3,%eax
 6f9:	40                   	inc    %eax
 6fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fd:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 702:	89 45 f0             	mov    %eax,-0x10(%ebp)
 705:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 709:	75 23                	jne    72e <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 70b:	c7 45 f0 24 0a 00 00 	movl   $0xa24,-0x10(%ebp)
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	a3 2c 0a 00 00       	mov    %eax,0xa2c
 71a:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 71f:	a3 24 0a 00 00       	mov    %eax,0xa24
    base.s.size = 0;
 724:	c7 05 28 0a 00 00 00 	movl   $0x0,0xa28
 72b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 731:	8b 00                	mov    (%eax),%eax
 733:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	8b 40 04             	mov    0x4(%eax),%eax
 73c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73f:	72 4d                	jb     78e <malloc+0xa4>
      if(p->s.size == nunits)
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8b 40 04             	mov    0x4(%eax),%eax
 747:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74a:	75 0c                	jne    758 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 74c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74f:	8b 10                	mov    (%eax),%edx
 751:	8b 45 f0             	mov    -0x10(%ebp),%eax
 754:	89 10                	mov    %edx,(%eax)
 756:	eb 26                	jmp    77e <malloc+0x94>
      else {
        p->s.size -= nunits;
 758:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	89 c2                	mov    %eax,%edx
 760:	2b 55 ec             	sub    -0x14(%ebp),%edx
 763:	8b 45 f4             	mov    -0xc(%ebp),%eax
 766:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	c1 e0 03             	shl    $0x3,%eax
 772:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 775:	8b 45 f4             	mov    -0xc(%ebp),%eax
 778:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 781:	a3 2c 0a 00 00       	mov    %eax,0xa2c
      return (void*)(p + 1);
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	83 c0 08             	add    $0x8,%eax
 78c:	eb 38                	jmp    7c6 <malloc+0xdc>
    }
    if(p == freep)
 78e:	a1 2c 0a 00 00       	mov    0xa2c,%eax
 793:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 796:	75 1b                	jne    7b3 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 798:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79b:	89 04 24             	mov    %eax,(%esp)
 79e:	e8 ef fe ff ff       	call   692 <morecore>
 7a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7aa:	75 07                	jne    7b3 <malloc+0xc9>
        return 0;
 7ac:	b8 00 00 00 00       	mov    $0x0,%eax
 7b1:	eb 13                	jmp    7c6 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7c1:	e9 70 ff ff ff       	jmp    736 <malloc+0x4c>
}
 7c6:	c9                   	leave  
 7c7:	c3                   	ret    
