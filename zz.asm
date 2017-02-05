
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
   9:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 1e 04 00 00       	call   43b <printf>
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

0000032b <semget>:
 32b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <semfree>:
 333:	b8 1b 00 00 00       	mov    $0x1b,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <semdown>:
 33b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <semup>:
 343:	b8 1d 00 00 00       	mov    $0x1d,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <shm_create>:
 34b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <shm_close>:
 353:	b8 1f 00 00 00       	mov    $0x1f,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <shm_get>:
 35b:	b8 20 00 00 00       	mov    $0x20,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 363:	55                   	push   %ebp
 364:	89 e5                	mov    %esp,%ebp
 366:	83 ec 28             	sub    $0x28,%esp
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 36f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 376:	00 
 377:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37a:	89 44 24 04          	mov    %eax,0x4(%esp)
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	89 04 24             	mov    %eax,(%esp)
 384:	e8 02 ff ff ff       	call   28b <write>
}
 389:	c9                   	leave  
 38a:	c3                   	ret    

0000038b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 391:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 398:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39c:	74 17                	je     3b5 <printint+0x2a>
 39e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a2:	79 11                	jns    3b5 <printint+0x2a>
    neg = 1;
 3a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	f7 d8                	neg    %eax
 3b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b3:	eb 06                	jmp    3bb <printint+0x30>
  } else {
    x = xx;
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c8:	ba 00 00 00 00       	mov    $0x0,%edx
 3cd:	f7 f1                	div    %ecx
 3cf:	89 d0                	mov    %edx,%eax
 3d1:	8a 80 48 0a 00 00    	mov    0xa48(%eax),%al
 3d7:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3dd:	01 ca                	add    %ecx,%edx
 3df:	88 02                	mov    %al,(%edx)
 3e1:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3e4:	8b 55 10             	mov    0x10(%ebp),%edx
 3e7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ed:	ba 00 00 00 00       	mov    $0x0,%edx
 3f2:	f7 75 d4             	divl   -0x2c(%ebp)
 3f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fc:	75 c4                	jne    3c2 <printint+0x37>
  if(neg)
 3fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 402:	74 2c                	je     430 <printint+0xa5>
    buf[i++] = '-';
 404:	8d 55 dc             	lea    -0x24(%ebp),%edx
 407:	8b 45 f4             	mov    -0xc(%ebp),%eax
 40a:	01 d0                	add    %edx,%eax
 40c:	c6 00 2d             	movb   $0x2d,(%eax)
 40f:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 412:	eb 1c                	jmp    430 <printint+0xa5>
    putc(fd, buf[i]);
 414:	8d 55 dc             	lea    -0x24(%ebp),%edx
 417:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41a:	01 d0                	add    %edx,%eax
 41c:	8a 00                	mov    (%eax),%al
 41e:	0f be c0             	movsbl %al,%eax
 421:	89 44 24 04          	mov    %eax,0x4(%esp)
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	89 04 24             	mov    %eax,(%esp)
 42b:	e8 33 ff ff ff       	call   363 <putc>
  while(--i >= 0)
 430:	ff 4d f4             	decl   -0xc(%ebp)
 433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 437:	79 db                	jns    414 <printint+0x89>
}
 439:	c9                   	leave  
 43a:	c3                   	ret    

0000043b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43b:	55                   	push   %ebp
 43c:	89 e5                	mov    %esp,%ebp
 43e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 441:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 448:	8d 45 0c             	lea    0xc(%ebp),%eax
 44b:	83 c0 04             	add    $0x4,%eax
 44e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 451:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 458:	e9 78 01 00 00       	jmp    5d5 <printf+0x19a>
    c = fmt[i] & 0xff;
 45d:	8b 55 0c             	mov    0xc(%ebp),%edx
 460:	8b 45 f0             	mov    -0x10(%ebp),%eax
 463:	01 d0                	add    %edx,%eax
 465:	8a 00                	mov    (%eax),%al
 467:	0f be c0             	movsbl %al,%eax
 46a:	25 ff 00 00 00       	and    $0xff,%eax
 46f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 472:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 476:	75 2c                	jne    4a4 <printf+0x69>
      if(c == '%'){
 478:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47c:	75 0c                	jne    48a <printf+0x4f>
        state = '%';
 47e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 485:	e9 48 01 00 00       	jmp    5d2 <printf+0x197>
      } else {
        putc(fd, c);
 48a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48d:	0f be c0             	movsbl %al,%eax
 490:	89 44 24 04          	mov    %eax,0x4(%esp)
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	89 04 24             	mov    %eax,(%esp)
 49a:	e8 c4 fe ff ff       	call   363 <putc>
 49f:	e9 2e 01 00 00       	jmp    5d2 <printf+0x197>
      }
    } else if(state == '%'){
 4a4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a8:	0f 85 24 01 00 00    	jne    5d2 <printf+0x197>
      if(c == 'd'){
 4ae:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b2:	75 2d                	jne    4e1 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b7:	8b 00                	mov    (%eax),%eax
 4b9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4c0:	00 
 4c1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c8:	00 
 4c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	89 04 24             	mov    %eax,(%esp)
 4d3:	e8 b3 fe ff ff       	call   38b <printint>
        ap++;
 4d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4dc:	e9 ea 00 00 00       	jmp    5cb <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4e1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e5:	74 06                	je     4ed <printf+0xb2>
 4e7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4eb:	75 2d                	jne    51a <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4f0:	8b 00                	mov    (%eax),%eax
 4f2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f9:	00 
 4fa:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 501:	00 
 502:	89 44 24 04          	mov    %eax,0x4(%esp)
 506:	8b 45 08             	mov    0x8(%ebp),%eax
 509:	89 04 24             	mov    %eax,(%esp)
 50c:	e8 7a fe ff ff       	call   38b <printint>
        ap++;
 511:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 515:	e9 b1 00 00 00       	jmp    5cb <printf+0x190>
      } else if(c == 's'){
 51a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51e:	75 43                	jne    563 <printf+0x128>
        s = (char*)*ap;
 520:	8b 45 e8             	mov    -0x18(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 528:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 530:	75 25                	jne    557 <printf+0x11c>
          s = "(null)";
 532:	c7 45 f4 05 08 00 00 	movl   $0x805,-0xc(%ebp)
        while(*s != 0){
 539:	eb 1c                	jmp    557 <printf+0x11c>
          putc(fd, *s);
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	8a 00                	mov    (%eax),%al
 540:	0f be c0             	movsbl %al,%eax
 543:	89 44 24 04          	mov    %eax,0x4(%esp)
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 11 fe ff ff       	call   363 <putc>
          s++;
 552:	ff 45 f4             	incl   -0xc(%ebp)
 555:	eb 01                	jmp    558 <printf+0x11d>
        while(*s != 0){
 557:	90                   	nop
 558:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55b:	8a 00                	mov    (%eax),%al
 55d:	84 c0                	test   %al,%al
 55f:	75 da                	jne    53b <printf+0x100>
 561:	eb 68                	jmp    5cb <printf+0x190>
        }
      } else if(c == 'c'){
 563:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 567:	75 1d                	jne    586 <printf+0x14b>
        putc(fd, *ap);
 569:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56c:	8b 00                	mov    (%eax),%eax
 56e:	0f be c0             	movsbl %al,%eax
 571:	89 44 24 04          	mov    %eax,0x4(%esp)
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	89 04 24             	mov    %eax,(%esp)
 57b:	e8 e3 fd ff ff       	call   363 <putc>
        ap++;
 580:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 584:	eb 45                	jmp    5cb <printf+0x190>
      } else if(c == '%'){
 586:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58a:	75 17                	jne    5a3 <printf+0x168>
        putc(fd, c);
 58c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58f:	0f be c0             	movsbl %al,%eax
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 c2 fd ff ff       	call   363 <putc>
 5a1:	eb 28                	jmp    5cb <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5aa:	00 
 5ab:	8b 45 08             	mov    0x8(%ebp),%eax
 5ae:	89 04 24             	mov    %eax,(%esp)
 5b1:	e8 ad fd ff ff       	call   363 <putc>
        putc(fd, c);
 5b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 98 fd ff ff       	call   363 <putc>
      }
      state = 0;
 5cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5d2:	ff 45 f0             	incl   -0x10(%ebp)
 5d5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5db:	01 d0                	add    %edx,%eax
 5dd:	8a 00                	mov    (%eax),%al
 5df:	84 c0                	test   %al,%al
 5e1:	0f 85 76 fe ff ff    	jne    45d <printf+0x22>
    }
  }
}
 5e7:	c9                   	leave  
 5e8:	c3                   	ret    

000005e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e9:	55                   	push   %ebp
 5ea:	89 e5                	mov    %esp,%ebp
 5ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ef:	8b 45 08             	mov    0x8(%ebp),%eax
 5f2:	83 e8 08             	sub    $0x8,%eax
 5f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f8:	a1 64 0a 00 00       	mov    0xa64,%eax
 5fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 600:	eb 24                	jmp    626 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60a:	77 12                	ja     61e <free+0x35>
 60c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 612:	77 24                	ja     638 <free+0x4f>
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61c:	77 1a                	ja     638 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	89 45 fc             	mov    %eax,-0x4(%ebp)
 626:	8b 45 f8             	mov    -0x8(%ebp),%eax
 629:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62c:	76 d4                	jbe    602 <free+0x19>
 62e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 631:	8b 00                	mov    (%eax),%eax
 633:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 636:	76 ca                	jbe    602 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	8b 40 04             	mov    0x4(%eax),%eax
 63e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	01 c2                	add    %eax,%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	39 c2                	cmp    %eax,%edx
 651:	75 24                	jne    677 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
 656:	8b 50 04             	mov    0x4(%eax),%edx
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	01 c2                	add    %eax,%edx
 663:	8b 45 f8             	mov    -0x8(%ebp),%eax
 666:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 669:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	8b 10                	mov    (%eax),%edx
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	89 10                	mov    %edx,(%eax)
 675:	eb 0a                	jmp    681 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 10                	mov    (%eax),%edx
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 40 04             	mov    0x4(%eax),%eax
 687:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	01 d0                	add    %edx,%eax
 693:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 696:	75 20                	jne    6b8 <free+0xcf>
    p->s.size += bp->s.size;
 698:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69b:	8b 50 04             	mov    0x4(%eax),%edx
 69e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a1:	8b 40 04             	mov    0x4(%eax),%eax
 6a4:	01 c2                	add    %eax,%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6af:	8b 10                	mov    (%eax),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	89 10                	mov    %edx,(%eax)
 6b6:	eb 08                	jmp    6c0 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6be:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	a3 64 0a 00 00       	mov    %eax,0xa64
}
 6c8:	c9                   	leave  
 6c9:	c3                   	ret    

000006ca <morecore>:

static Header*
morecore(uint nu)
{
 6ca:	55                   	push   %ebp
 6cb:	89 e5                	mov    %esp,%ebp
 6cd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d7:	77 07                	ja     6e0 <morecore+0x16>
    nu = 4096;
 6d9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	c1 e0 03             	shl    $0x3,%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 05 fc ff ff       	call   2f3 <sbrk>
 6ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f5:	75 07                	jne    6fe <morecore+0x34>
    return 0;
 6f7:	b8 00 00 00 00       	mov    $0x0,%eax
 6fc:	eb 22                	jmp    720 <morecore+0x56>
  hp = (Header*)p;
 6fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 701:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	8b 55 08             	mov    0x8(%ebp),%edx
 70a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	83 c0 08             	add    $0x8,%eax
 713:	89 04 24             	mov    %eax,(%esp)
 716:	e8 ce fe ff ff       	call   5e9 <free>
  return freep;
 71b:	a1 64 0a 00 00       	mov    0xa64,%eax
}
 720:	c9                   	leave  
 721:	c3                   	ret    

00000722 <malloc>:

void*
malloc(uint nbytes)
{
 722:	55                   	push   %ebp
 723:	89 e5                	mov    %esp,%ebp
 725:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	83 c0 07             	add    $0x7,%eax
 72e:	c1 e8 03             	shr    $0x3,%eax
 731:	40                   	inc    %eax
 732:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 735:	a1 64 0a 00 00       	mov    0xa64,%eax
 73a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 741:	75 23                	jne    766 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 743:	c7 45 f0 5c 0a 00 00 	movl   $0xa5c,-0x10(%ebp)
 74a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74d:	a3 64 0a 00 00       	mov    %eax,0xa64
 752:	a1 64 0a 00 00       	mov    0xa64,%eax
 757:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    base.s.size = 0;
 75c:	c7 05 60 0a 00 00 00 	movl   $0x0,0xa60
 763:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 777:	72 4d                	jb     7c6 <malloc+0xa4>
      if(p->s.size == nunits)
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 782:	75 0c                	jne    790 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 10                	mov    (%eax),%edx
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	89 10                	mov    %edx,(%eax)
 78e:	eb 26                	jmp    7b6 <malloc+0x94>
      else {
        p->s.size -= nunits;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	89 c2                	mov    %eax,%edx
 798:	2b 55 ec             	sub    -0x14(%ebp),%edx
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	c1 e0 03             	shl    $0x3,%eax
 7aa:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	a3 64 0a 00 00       	mov    %eax,0xa64
      return (void*)(p + 1);
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	83 c0 08             	add    $0x8,%eax
 7c4:	eb 38                	jmp    7fe <malloc+0xdc>
    }
    if(p == freep)
 7c6:	a1 64 0a 00 00       	mov    0xa64,%eax
 7cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ce:	75 1b                	jne    7eb <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d3:	89 04 24             	mov    %eax,(%esp)
 7d6:	e8 ef fe ff ff       	call   6ca <morecore>
 7db:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e2:	75 07                	jne    7eb <malloc+0xc9>
        return 0;
 7e4:	b8 00 00 00 00       	mov    $0x0,%eax
 7e9:	eb 13                	jmp    7fe <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7f9:	e9 70 ff ff ff       	jmp    76e <malloc+0x4c>
}
 7fe:	c9                   	leave  
 7ff:	c3                   	ret    
