
_lseek-test:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

char buf[40];

int main(int argc, char *argv[]) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp

	int fd = open("file", O_CREATE | O_RDWR);
   9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  10:	00 
  11:	c7 04 24 28 08 00 00 	movl   $0x828,(%esp)
  18:	e8 fe 02 00 00       	call   31b <open>
  1d:	89 44 24 1c          	mov    %eax,0x1c(%esp)

	lseek(fd, 500, SEEK_CUR);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  30:	00 
  31:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  35:	89 04 24             	mov    %eax,(%esp)
  38:	e8 3e 03 00 00       	call   37b <lseek>
	printf(fd,"stuff\n\n");
  3d:	c7 44 24 04 2d 08 00 	movl   $0x82d,0x4(%esp)
  44:	00 
  45:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 12 04 00 00       	call   463 <printf>
	lseek(fd, 1000, SEEK_END);
  51:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  58:	00 
  59:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  60:	00 
  61:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  65:	89 04 24             	mov    %eax,(%esp)
  68:	e8 0e 03 00 00       	call   37b <lseek>
	printf(fd, "moar stuff\n");
  6d:	c7 44 24 04 35 08 00 	movl   $0x835,0x4(%esp)
  74:	00 
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	89 04 24             	mov    %eax,(%esp)
  7c:	e8 e2 03 00 00       	call   463 <printf>
	// This lseek should fail. Sometimes it even returns an error.
	/* lseek(fd, -100, SEEK_SET);
	printf(fd, "shouldn't work\n");
	*/

	close(fd);
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	89 04 24             	mov    %eax,(%esp)
  88:	e8 76 02 00 00       	call   303 <close>
	exit();
  8d:	e8 49 02 00 00       	call   2db <exit>

00000092 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  97:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9a:	8b 55 10             	mov    0x10(%ebp),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	89 cb                	mov    %ecx,%ebx
  a2:	89 df                	mov    %ebx,%edi
  a4:	89 d1                	mov    %edx,%ecx
  a6:	fc                   	cld    
  a7:	f3 aa                	rep stos %al,%es:(%edi)
  a9:	89 ca                	mov    %ecx,%edx
  ab:	89 fb                	mov    %edi,%ebx
  ad:	89 5d 08             	mov    %ebx,0x8(%ebp)
  b0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b3:	5b                   	pop    %ebx
  b4:	5f                   	pop    %edi
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bd:	8b 45 08             	mov    0x8(%ebp),%eax
  c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c3:	90                   	nop
  c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  c7:	8a 10                	mov    (%eax),%dl
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	88 10                	mov    %dl,(%eax)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	8a 00                	mov    (%eax),%al
  d3:	84 c0                	test   %al,%al
  d5:	0f 95 c0             	setne  %al
  d8:	ff 45 08             	incl   0x8(%ebp)
  db:	ff 45 0c             	incl   0xc(%ebp)
  de:	84 c0                	test   %al,%al
  e0:	75 e2                	jne    c4 <strcpy+0xd>
    ;
  return os;
  e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  ea:	eb 06                	jmp    f2 <strcmp+0xb>
    p++, q++;
  ec:	ff 45 08             	incl   0x8(%ebp)
  ef:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	8a 00                	mov    (%eax),%al
  f7:	84 c0                	test   %al,%al
  f9:	74 0e                	je     109 <strcmp+0x22>
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	8a 10                	mov    (%eax),%dl
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	8a 00                	mov    (%eax),%al
 105:	38 c2                	cmp    %al,%dl
 107:	74 e3                	je     ec <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	8a 00                	mov    (%eax),%al
 10e:	0f b6 d0             	movzbl %al,%edx
 111:	8b 45 0c             	mov    0xc(%ebp),%eax
 114:	8a 00                	mov    (%eax),%al
 116:	0f b6 c0             	movzbl %al,%eax
 119:	89 d1                	mov    %edx,%ecx
 11b:	29 c1                	sub    %eax,%ecx
 11d:	89 c8                	mov    %ecx,%eax
}
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    

00000121 <strlen>:

uint
strlen(char *s)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 127:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 12e:	eb 03                	jmp    133 <strlen+0x12>
 130:	ff 45 fc             	incl   -0x4(%ebp)
 133:	8b 55 fc             	mov    -0x4(%ebp),%edx
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	01 d0                	add    %edx,%eax
 13b:	8a 00                	mov    (%eax),%al
 13d:	84 c0                	test   %al,%al
 13f:	75 ef                	jne    130 <strlen+0xf>
    ;
  return n;
 141:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <memset>:

void*
memset(void *dst, int c, uint n)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 14c:	8b 45 10             	mov    0x10(%ebp),%eax
 14f:	89 44 24 08          	mov    %eax,0x8(%esp)
 153:	8b 45 0c             	mov    0xc(%ebp),%eax
 156:	89 44 24 04          	mov    %eax,0x4(%esp)
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	89 04 24             	mov    %eax,(%esp)
 160:	e8 2d ff ff ff       	call   92 <stosb>
  return dst;
 165:	8b 45 08             	mov    0x8(%ebp),%eax
}
 168:	c9                   	leave  
 169:	c3                   	ret    

0000016a <strchr>:

char*
strchr(const char *s, char c)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 04             	sub    $0x4,%esp
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 176:	eb 12                	jmp    18a <strchr+0x20>
    if(*s == c)
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	8a 00                	mov    (%eax),%al
 17d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 180:	75 05                	jne    187 <strchr+0x1d>
      return (char*)s;
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	eb 11                	jmp    198 <strchr+0x2e>
  for(; *s; s++)
 187:	ff 45 08             	incl   0x8(%ebp)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	8a 00                	mov    (%eax),%al
 18f:	84 c0                	test   %al,%al
 191:	75 e5                	jne    178 <strchr+0xe>
  return 0;
 193:	b8 00 00 00 00       	mov    $0x0,%eax
}
 198:	c9                   	leave  
 199:	c3                   	ret    

0000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	55                   	push   %ebp
 19b:	89 e5                	mov    %esp,%ebp
 19d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a7:	eb 42                	jmp    1eb <gets+0x51>
    cc = read(0, &c, 1);
 1a9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b0:	00 
 1b1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1bf:	e8 2f 01 00 00       	call   2f3 <read>
 1c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cb:	7e 29                	jle    1f6 <gets+0x5c>
      break;
    buf[i++] = c;
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 c2                	add    %eax,%edx
 1d5:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d8:	88 02                	mov    %al,(%edx)
 1da:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1dd:	8a 45 ef             	mov    -0x11(%ebp),%al
 1e0:	3c 0a                	cmp    $0xa,%al
 1e2:	74 13                	je     1f7 <gets+0x5d>
 1e4:	8a 45 ef             	mov    -0x11(%ebp),%al
 1e7:	3c 0d                	cmp    $0xd,%al
 1e9:	74 0c                	je     1f7 <gets+0x5d>
  for(i=0; i+1 < max; ){
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	40                   	inc    %eax
 1ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f2:	7c b5                	jl     1a9 <gets+0xf>
 1f4:	eb 01                	jmp    1f7 <gets+0x5d>
      break;
 1f6:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	01 d0                	add    %edx,%eax
 1ff:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <stat>:

int
stat(char *n, struct stat *st)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 214:	00 
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	89 04 24             	mov    %eax,(%esp)
 21b:	e8 fb 00 00 00       	call   31b <open>
 220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 223:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 227:	79 07                	jns    230 <stat+0x29>
    return -1;
 229:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22e:	eb 23                	jmp    253 <stat+0x4c>
  r = fstat(fd, st);
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	89 44 24 04          	mov    %eax,0x4(%esp)
 237:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23a:	89 04 24             	mov    %eax,(%esp)
 23d:	e8 f1 00 00 00       	call   333 <fstat>
 242:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 245:	8b 45 f4             	mov    -0xc(%ebp),%eax
 248:	89 04 24             	mov    %eax,(%esp)
 24b:	e8 b3 00 00 00       	call   303 <close>
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 262:	eb 21                	jmp    285 <atoi+0x30>
    n = n*10 + *s++ - '0';
 264:	8b 55 fc             	mov    -0x4(%ebp),%edx
 267:	89 d0                	mov    %edx,%eax
 269:	c1 e0 02             	shl    $0x2,%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	d1 e0                	shl    %eax
 270:	89 c2                	mov    %eax,%edx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8a 00                	mov    (%eax),%al
 277:	0f be c0             	movsbl %al,%eax
 27a:	01 d0                	add    %edx,%eax
 27c:	83 e8 30             	sub    $0x30,%eax
 27f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 282:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	8a 00                	mov    (%eax),%al
 28a:	3c 2f                	cmp    $0x2f,%al
 28c:	7e 09                	jle    297 <atoi+0x42>
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	8a 00                	mov    (%eax),%al
 293:	3c 39                	cmp    $0x39,%al
 295:	7e cd                	jle    264 <atoi+0xf>
  return n;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ae:	eb 10                	jmp    2c0 <memmove+0x24>
    *dst++ = *src++;
 2b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b3:	8a 10                	mov    (%eax),%dl
 2b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b8:	88 10                	mov    %dl,(%eax)
 2ba:	ff 45 fc             	incl   -0x4(%ebp)
 2bd:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 2c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c4:	0f 9f c0             	setg   %al
 2c7:	ff 4d 10             	decl   0x10(%ebp)
 2ca:	84 c0                	test   %al,%al
 2cc:	75 e2                	jne    2b0 <memmove+0x14>
  return vdst;
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d1:	c9                   	leave  
 2d2:	c3                   	ret    

000002d3 <fork>:
 2d3:	b8 01 00 00 00       	mov    $0x1,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <exit>:
 2db:	b8 02 00 00 00       	mov    $0x2,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <wait>:
 2e3:	b8 03 00 00 00       	mov    $0x3,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <pipe>:
 2eb:	b8 04 00 00 00       	mov    $0x4,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <read>:
 2f3:	b8 05 00 00 00       	mov    $0x5,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <write>:
 2fb:	b8 10 00 00 00       	mov    $0x10,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <close>:
 303:	b8 15 00 00 00       	mov    $0x15,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <kill>:
 30b:	b8 06 00 00 00       	mov    $0x6,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <exec>:
 313:	b8 07 00 00 00       	mov    $0x7,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <open>:
 31b:	b8 0f 00 00 00       	mov    $0xf,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <mknod>:
 323:	b8 11 00 00 00       	mov    $0x11,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <unlink>:
 32b:	b8 12 00 00 00       	mov    $0x12,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <fstat>:
 333:	b8 08 00 00 00       	mov    $0x8,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <link>:
 33b:	b8 13 00 00 00       	mov    $0x13,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <mkdir>:
 343:	b8 14 00 00 00       	mov    $0x14,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <chdir>:
 34b:	b8 09 00 00 00       	mov    $0x9,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <dup>:
 353:	b8 0a 00 00 00       	mov    $0xa,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <getpid>:
 35b:	b8 0b 00 00 00       	mov    $0xb,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sbrk>:
 363:	b8 0c 00 00 00       	mov    $0xc,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <sleep>:
 36b:	b8 0d 00 00 00       	mov    $0xd,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <uptime>:
 373:	b8 0e 00 00 00       	mov    $0xe,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <lseek>:
 37b:	b8 16 00 00 00       	mov    $0x16,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <isatty>:
 383:	b8 17 00 00 00       	mov    $0x17,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	83 ec 28             	sub    $0x28,%esp
 391:	8b 45 0c             	mov    0xc(%ebp),%eax
 394:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 397:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 39e:	00 
 39f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	89 04 24             	mov    %eax,(%esp)
 3ac:	e8 4a ff ff ff       	call   2fb <write>
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3c0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3c4:	74 17                	je     3dd <printint+0x2a>
 3c6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ca:	79 11                	jns    3dd <printint+0x2a>
    neg = 1;
 3cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	f7 d8                	neg    %eax
 3d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3db:	eb 06                	jmp    3e3 <printint+0x30>
  } else {
    x = xx;
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3f0:	ba 00 00 00 00       	mov    $0x0,%edx
 3f5:	f7 f1                	div    %ecx
 3f7:	89 d0                	mov    %edx,%eax
 3f9:	8a 80 84 0a 00 00    	mov    0xa84(%eax),%al
 3ff:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 402:	8b 55 f4             	mov    -0xc(%ebp),%edx
 405:	01 ca                	add    %ecx,%edx
 407:	88 02                	mov    %al,(%edx)
 409:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 40c:	8b 55 10             	mov    0x10(%ebp),%edx
 40f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 412:	8b 45 ec             	mov    -0x14(%ebp),%eax
 415:	ba 00 00 00 00       	mov    $0x0,%edx
 41a:	f7 75 d4             	divl   -0x2c(%ebp)
 41d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 420:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 424:	75 c4                	jne    3ea <printint+0x37>
  if(neg)
 426:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 42a:	74 2c                	je     458 <printint+0xa5>
    buf[i++] = '-';
 42c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 432:	01 d0                	add    %edx,%eax
 434:	c6 00 2d             	movb   $0x2d,(%eax)
 437:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 43a:	eb 1c                	jmp    458 <printint+0xa5>
    putc(fd, buf[i]);
 43c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 442:	01 d0                	add    %edx,%eax
 444:	8a 00                	mov    (%eax),%al
 446:	0f be c0             	movsbl %al,%eax
 449:	89 44 24 04          	mov    %eax,0x4(%esp)
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	89 04 24             	mov    %eax,(%esp)
 453:	e8 33 ff ff ff       	call   38b <putc>
  while(--i >= 0)
 458:	ff 4d f4             	decl   -0xc(%ebp)
 45b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45f:	79 db                	jns    43c <printint+0x89>
}
 461:	c9                   	leave  
 462:	c3                   	ret    

00000463 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 463:	55                   	push   %ebp
 464:	89 e5                	mov    %esp,%ebp
 466:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 469:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 470:	8d 45 0c             	lea    0xc(%ebp),%eax
 473:	83 c0 04             	add    $0x4,%eax
 476:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 479:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 480:	e9 78 01 00 00       	jmp    5fd <printf+0x19a>
    c = fmt[i] & 0xff;
 485:	8b 55 0c             	mov    0xc(%ebp),%edx
 488:	8b 45 f0             	mov    -0x10(%ebp),%eax
 48b:	01 d0                	add    %edx,%eax
 48d:	8a 00                	mov    (%eax),%al
 48f:	0f be c0             	movsbl %al,%eax
 492:	25 ff 00 00 00       	and    $0xff,%eax
 497:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 49a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49e:	75 2c                	jne    4cc <printf+0x69>
      if(c == '%'){
 4a0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a4:	75 0c                	jne    4b2 <printf+0x4f>
        state = '%';
 4a6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4ad:	e9 48 01 00 00       	jmp    5fa <printf+0x197>
      } else {
        putc(fd, c);
 4b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b5:	0f be c0             	movsbl %al,%eax
 4b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	89 04 24             	mov    %eax,(%esp)
 4c2:	e8 c4 fe ff ff       	call   38b <putc>
 4c7:	e9 2e 01 00 00       	jmp    5fa <printf+0x197>
      }
    } else if(state == '%'){
 4cc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4d0:	0f 85 24 01 00 00    	jne    5fa <printf+0x197>
      if(c == 'd'){
 4d6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4da:	75 2d                	jne    509 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4df:	8b 00                	mov    (%eax),%eax
 4e1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e8:	00 
 4e9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4f0:	00 
 4f1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	89 04 24             	mov    %eax,(%esp)
 4fb:	e8 b3 fe ff ff       	call   3b3 <printint>
        ap++;
 500:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 504:	e9 ea 00 00 00       	jmp    5f3 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 509:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 50d:	74 06                	je     515 <printf+0xb2>
 50f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 513:	75 2d                	jne    542 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 515:	8b 45 e8             	mov    -0x18(%ebp),%eax
 518:	8b 00                	mov    (%eax),%eax
 51a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 521:	00 
 522:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 529:	00 
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 7a fe ff ff       	call   3b3 <printint>
        ap++;
 539:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53d:	e9 b1 00 00 00       	jmp    5f3 <printf+0x190>
      } else if(c == 's'){
 542:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 546:	75 43                	jne    58b <printf+0x128>
        s = (char*)*ap;
 548:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54b:	8b 00                	mov    (%eax),%eax
 54d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 550:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 558:	75 25                	jne    57f <printf+0x11c>
          s = "(null)";
 55a:	c7 45 f4 41 08 00 00 	movl   $0x841,-0xc(%ebp)
        while(*s != 0){
 561:	eb 1c                	jmp    57f <printf+0x11c>
          putc(fd, *s);
 563:	8b 45 f4             	mov    -0xc(%ebp),%eax
 566:	8a 00                	mov    (%eax),%al
 568:	0f be c0             	movsbl %al,%eax
 56b:	89 44 24 04          	mov    %eax,0x4(%esp)
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	89 04 24             	mov    %eax,(%esp)
 575:	e8 11 fe ff ff       	call   38b <putc>
          s++;
 57a:	ff 45 f4             	incl   -0xc(%ebp)
 57d:	eb 01                	jmp    580 <printf+0x11d>
        while(*s != 0){
 57f:	90                   	nop
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	8a 00                	mov    (%eax),%al
 585:	84 c0                	test   %al,%al
 587:	75 da                	jne    563 <printf+0x100>
 589:	eb 68                	jmp    5f3 <printf+0x190>
        }
      } else if(c == 'c'){
 58b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58f:	75 1d                	jne    5ae <printf+0x14b>
        putc(fd, *ap);
 591:	8b 45 e8             	mov    -0x18(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	89 44 24 04          	mov    %eax,0x4(%esp)
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	89 04 24             	mov    %eax,(%esp)
 5a3:	e8 e3 fd ff ff       	call   38b <putc>
        ap++;
 5a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ac:	eb 45                	jmp    5f3 <printf+0x190>
      } else if(c == '%'){
 5ae:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b2:	75 17                	jne    5cb <printf+0x168>
        putc(fd, c);
 5b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b7:	0f be c0             	movsbl %al,%eax
 5ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 5be:	8b 45 08             	mov    0x8(%ebp),%eax
 5c1:	89 04 24             	mov    %eax,(%esp)
 5c4:	e8 c2 fd ff ff       	call   38b <putc>
 5c9:	eb 28                	jmp    5f3 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5cb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5d2:	00 
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	89 04 24             	mov    %eax,(%esp)
 5d9:	e8 ad fd ff ff       	call   38b <putc>
        putc(fd, c);
 5de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e1:	0f be c0             	movsbl %al,%eax
 5e4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	89 04 24             	mov    %eax,(%esp)
 5ee:	e8 98 fd ff ff       	call   38b <putc>
      }
      state = 0;
 5f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5fa:	ff 45 f0             	incl   -0x10(%ebp)
 5fd:	8b 55 0c             	mov    0xc(%ebp),%edx
 600:	8b 45 f0             	mov    -0x10(%ebp),%eax
 603:	01 d0                	add    %edx,%eax
 605:	8a 00                	mov    (%eax),%al
 607:	84 c0                	test   %al,%al
 609:	0f 85 76 fe ff ff    	jne    485 <printf+0x22>
    }
  }
}
 60f:	c9                   	leave  
 610:	c3                   	ret    

00000611 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 611:	55                   	push   %ebp
 612:	89 e5                	mov    %esp,%ebp
 614:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	83 e8 08             	sub    $0x8,%eax
 61d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 620:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 625:	89 45 fc             	mov    %eax,-0x4(%ebp)
 628:	eb 24                	jmp    64e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 632:	77 12                	ja     646 <free+0x35>
 634:	8b 45 f8             	mov    -0x8(%ebp),%eax
 637:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63a:	77 24                	ja     660 <free+0x4f>
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 00                	mov    (%eax),%eax
 641:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 644:	77 1a                	ja     660 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 646:	8b 45 fc             	mov    -0x4(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 654:	76 d4                	jbe    62a <free+0x19>
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65e:	76 ca                	jbe    62a <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 660:	8b 45 f8             	mov    -0x8(%ebp),%eax
 663:	8b 40 04             	mov    0x4(%eax),%eax
 666:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 66d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 670:	01 c2                	add    %eax,%edx
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	39 c2                	cmp    %eax,%edx
 679:	75 24                	jne    69f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	8b 50 04             	mov    0x4(%eax),%edx
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	8b 40 04             	mov    0x4(%eax),%eax
 689:	01 c2                	add    %eax,%edx
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	8b 10                	mov    (%eax),%edx
 698:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69b:	89 10                	mov    %edx,(%eax)
 69d:	eb 0a                	jmp    6a9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	8b 10                	mov    (%eax),%edx
 6a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 40 04             	mov    0x4(%eax),%eax
 6af:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b9:	01 d0                	add    %edx,%eax
 6bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6be:	75 20                	jne    6e0 <free+0xcf>
    p->s.size += bp->s.size;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 50 04             	mov    0x4(%eax),%edx
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	01 c2                	add    %eax,%edx
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d7:	8b 10                	mov    (%eax),%edx
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	89 10                	mov    %edx,(%eax)
 6de:	eb 08                	jmp    6e8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 6f0:	c9                   	leave  
 6f1:	c3                   	ret    

000006f2 <morecore>:

static Header*
morecore(uint nu)
{
 6f2:	55                   	push   %ebp
 6f3:	89 e5                	mov    %esp,%ebp
 6f5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ff:	77 07                	ja     708 <morecore+0x16>
    nu = 4096;
 701:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 708:	8b 45 08             	mov    0x8(%ebp),%eax
 70b:	c1 e0 03             	shl    $0x3,%eax
 70e:	89 04 24             	mov    %eax,(%esp)
 711:	e8 4d fc ff ff       	call   363 <sbrk>
 716:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 719:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 71d:	75 07                	jne    726 <morecore+0x34>
    return 0;
 71f:	b8 00 00 00 00       	mov    $0x0,%eax
 724:	eb 22                	jmp    748 <morecore+0x56>
  hp = (Header*)p;
 726:	8b 45 f4             	mov    -0xc(%ebp),%eax
 729:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 72c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72f:	8b 55 08             	mov    0x8(%ebp),%edx
 732:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 735:	8b 45 f0             	mov    -0x10(%ebp),%eax
 738:	83 c0 08             	add    $0x8,%eax
 73b:	89 04 24             	mov    %eax,(%esp)
 73e:	e8 ce fe ff ff       	call   611 <free>
  return freep;
 743:	a1 a8 0a 00 00       	mov    0xaa8,%eax
}
 748:	c9                   	leave  
 749:	c3                   	ret    

0000074a <malloc>:

void*
malloc(uint nbytes)
{
 74a:	55                   	push   %ebp
 74b:	89 e5                	mov    %esp,%ebp
 74d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	83 c0 07             	add    $0x7,%eax
 756:	c1 e8 03             	shr    $0x3,%eax
 759:	40                   	inc    %eax
 75a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 75d:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 762:	89 45 f0             	mov    %eax,-0x10(%ebp)
 765:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 769:	75 23                	jne    78e <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 76b:	c7 45 f0 a0 0a 00 00 	movl   $0xaa0,-0x10(%ebp)
 772:	8b 45 f0             	mov    -0x10(%ebp),%eax
 775:	a3 a8 0a 00 00       	mov    %eax,0xaa8
 77a:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 77f:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    base.s.size = 0;
 784:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 78b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 791:	8b 00                	mov    (%eax),%eax
 793:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 796:	8b 45 f4             	mov    -0xc(%ebp),%eax
 799:	8b 40 04             	mov    0x4(%eax),%eax
 79c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79f:	72 4d                	jb     7ee <malloc+0xa4>
      if(p->s.size == nunits)
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7aa:	75 0c                	jne    7b8 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 10                	mov    (%eax),%edx
 7b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b4:	89 10                	mov    %edx,(%eax)
 7b6:	eb 26                	jmp    7de <malloc+0x94>
      else {
        p->s.size -= nunits;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 40 04             	mov    0x4(%eax),%eax
 7be:	89 c2                	mov    %eax,%edx
 7c0:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	c1 e0 03             	shl    $0x3,%eax
 7d2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7db:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e1:	a3 a8 0a 00 00       	mov    %eax,0xaa8
      return (void*)(p + 1);
 7e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e9:	83 c0 08             	add    $0x8,%eax
 7ec:	eb 38                	jmp    826 <malloc+0xdc>
    }
    if(p == freep)
 7ee:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 7f3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f6:	75 1b                	jne    813 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7fb:	89 04 24             	mov    %eax,(%esp)
 7fe:	e8 ef fe ff ff       	call   6f2 <morecore>
 803:	89 45 f4             	mov    %eax,-0xc(%ebp)
 806:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80a:	75 07                	jne    813 <malloc+0xc9>
        return 0;
 80c:	b8 00 00 00 00       	mov    $0x0,%eax
 811:	eb 13                	jmp    826 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	89 45 f0             	mov    %eax,-0x10(%ebp)
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 821:	e9 70 ff ff ff       	jmp    796 <malloc+0x4c>
}
 826:	c9                   	leave  
 827:	c3                   	ret    
