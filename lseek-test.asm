
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
  11:	c7 04 24 38 08 00 00 	movl   $0x838,(%esp)
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
  3d:	c7 44 24 04 3d 08 00 	movl   $0x83d,0x4(%esp)
  44:	00 
  45:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 22 04 00 00       	call   473 <printf>
	lseek(fd, 1000, SEEK_END);
  51:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  58:	00 
  59:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  60:	00 
  61:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  65:	89 04 24             	mov    %eax,(%esp)
  68:	e8 0e 03 00 00       	call   37b <lseek>
	printf(fd, "moar stuff\n");
  6d:	c7 44 24 04 45 08 00 	movl   $0x845,0x4(%esp)
  74:	00 
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	89 04 24             	mov    %eax,(%esp)
  7c:	e8 f2 03 00 00       	call   473 <printf>
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

0000038b <procstat>:
 38b:	b8 18 00 00 00       	mov    $0x18,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <set_priority>:
 393:	b8 19 00 00 00       	mov    $0x19,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
 39e:	83 ec 28             	sub    $0x28,%esp
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ae:	00 
 3af:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	89 04 24             	mov    %eax,(%esp)
 3bc:	e8 3a ff ff ff       	call   2fb <write>
}
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3d0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3d4:	74 17                	je     3ed <printint+0x2a>
 3d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3da:	79 11                	jns    3ed <printint+0x2a>
    neg = 1;
 3dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	f7 d8                	neg    %eax
 3e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3eb:	eb 06                	jmp    3f3 <printint+0x30>
  } else {
    x = xx;
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 400:	ba 00 00 00 00       	mov    $0x0,%edx
 405:	f7 f1                	div    %ecx
 407:	89 d0                	mov    %edx,%eax
 409:	8a 80 94 0a 00 00    	mov    0xa94(%eax),%al
 40f:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 412:	8b 55 f4             	mov    -0xc(%ebp),%edx
 415:	01 ca                	add    %ecx,%edx
 417:	88 02                	mov    %al,(%edx)
 419:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 41c:	8b 55 10             	mov    0x10(%ebp),%edx
 41f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 422:	8b 45 ec             	mov    -0x14(%ebp),%eax
 425:	ba 00 00 00 00       	mov    $0x0,%edx
 42a:	f7 75 d4             	divl   -0x2c(%ebp)
 42d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 430:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 434:	75 c4                	jne    3fa <printint+0x37>
  if(neg)
 436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43a:	74 2c                	je     468 <printint+0xa5>
    buf[i++] = '-';
 43c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 442:	01 d0                	add    %edx,%eax
 444:	c6 00 2d             	movb   $0x2d,(%eax)
 447:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 44a:	eb 1c                	jmp    468 <printint+0xa5>
    putc(fd, buf[i]);
 44c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	8a 00                	mov    (%eax),%al
 456:	0f be c0             	movsbl %al,%eax
 459:	89 44 24 04          	mov    %eax,0x4(%esp)
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 33 ff ff ff       	call   39b <putc>
  while(--i >= 0)
 468:	ff 4d f4             	decl   -0xc(%ebp)
 46b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46f:	79 db                	jns    44c <printint+0x89>
}
 471:	c9                   	leave  
 472:	c3                   	ret    

00000473 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 473:	55                   	push   %ebp
 474:	89 e5                	mov    %esp,%ebp
 476:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 479:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 480:	8d 45 0c             	lea    0xc(%ebp),%eax
 483:	83 c0 04             	add    $0x4,%eax
 486:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 490:	e9 78 01 00 00       	jmp    60d <printf+0x19a>
    c = fmt[i] & 0xff;
 495:	8b 55 0c             	mov    0xc(%ebp),%edx
 498:	8b 45 f0             	mov    -0x10(%ebp),%eax
 49b:	01 d0                	add    %edx,%eax
 49d:	8a 00                	mov    (%eax),%al
 49f:	0f be c0             	movsbl %al,%eax
 4a2:	25 ff 00 00 00       	and    $0xff,%eax
 4a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ae:	75 2c                	jne    4dc <printf+0x69>
      if(c == '%'){
 4b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4b4:	75 0c                	jne    4c2 <printf+0x4f>
        state = '%';
 4b6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4bd:	e9 48 01 00 00       	jmp    60a <printf+0x197>
      } else {
        putc(fd, c);
 4c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c5:	0f be c0             	movsbl %al,%eax
 4c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cc:	8b 45 08             	mov    0x8(%ebp),%eax
 4cf:	89 04 24             	mov    %eax,(%esp)
 4d2:	e8 c4 fe ff ff       	call   39b <putc>
 4d7:	e9 2e 01 00 00       	jmp    60a <printf+0x197>
      }
    } else if(state == '%'){
 4dc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4e0:	0f 85 24 01 00 00    	jne    60a <printf+0x197>
      if(c == 'd'){
 4e6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ea:	75 2d                	jne    519 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ef:	8b 00                	mov    (%eax),%eax
 4f1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f8:	00 
 4f9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 500:	00 
 501:	89 44 24 04          	mov    %eax,0x4(%esp)
 505:	8b 45 08             	mov    0x8(%ebp),%eax
 508:	89 04 24             	mov    %eax,(%esp)
 50b:	e8 b3 fe ff ff       	call   3c3 <printint>
        ap++;
 510:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 514:	e9 ea 00 00 00       	jmp    603 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 519:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 51d:	74 06                	je     525 <printf+0xb2>
 51f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 523:	75 2d                	jne    552 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 525:	8b 45 e8             	mov    -0x18(%ebp),%eax
 528:	8b 00                	mov    (%eax),%eax
 52a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 531:	00 
 532:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 539:	00 
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 7a fe ff ff       	call   3c3 <printint>
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	e9 b1 00 00 00       	jmp    603 <printf+0x190>
      } else if(c == 's'){
 552:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 556:	75 43                	jne    59b <printf+0x128>
        s = (char*)*ap;
 558:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55b:	8b 00                	mov    (%eax),%eax
 55d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 560:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 568:	75 25                	jne    58f <printf+0x11c>
          s = "(null)";
 56a:	c7 45 f4 51 08 00 00 	movl   $0x851,-0xc(%ebp)
        while(*s != 0){
 571:	eb 1c                	jmp    58f <printf+0x11c>
          putc(fd, *s);
 573:	8b 45 f4             	mov    -0xc(%ebp),%eax
 576:	8a 00                	mov    (%eax),%al
 578:	0f be c0             	movsbl %al,%eax
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 11 fe ff ff       	call   39b <putc>
          s++;
 58a:	ff 45 f4             	incl   -0xc(%ebp)
 58d:	eb 01                	jmp    590 <printf+0x11d>
        while(*s != 0){
 58f:	90                   	nop
 590:	8b 45 f4             	mov    -0xc(%ebp),%eax
 593:	8a 00                	mov    (%eax),%al
 595:	84 c0                	test   %al,%al
 597:	75 da                	jne    573 <printf+0x100>
 599:	eb 68                	jmp    603 <printf+0x190>
        }
      } else if(c == 'c'){
 59b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59f:	75 1d                	jne    5be <printf+0x14b>
        putc(fd, *ap);
 5a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a4:	8b 00                	mov    (%eax),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	8b 45 08             	mov    0x8(%ebp),%eax
 5b0:	89 04 24             	mov    %eax,(%esp)
 5b3:	e8 e3 fd ff ff       	call   39b <putc>
        ap++;
 5b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bc:	eb 45                	jmp    603 <printf+0x190>
      } else if(c == '%'){
 5be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c2:	75 17                	jne    5db <printf+0x168>
        putc(fd, c);
 5c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 c2 fd ff ff       	call   39b <putc>
 5d9:	eb 28                	jmp    603 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5e2:	00 
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 ad fd ff ff       	call   39b <putc>
        putc(fd, c);
 5ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f1:	0f be c0             	movsbl %al,%eax
 5f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 98 fd ff ff       	call   39b <putc>
      }
      state = 0;
 603:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 60a:	ff 45 f0             	incl   -0x10(%ebp)
 60d:	8b 55 0c             	mov    0xc(%ebp),%edx
 610:	8b 45 f0             	mov    -0x10(%ebp),%eax
 613:	01 d0                	add    %edx,%eax
 615:	8a 00                	mov    (%eax),%al
 617:	84 c0                	test   %al,%al
 619:	0f 85 76 fe ff ff    	jne    495 <printf+0x22>
    }
  }
}
 61f:	c9                   	leave  
 620:	c3                   	ret    

00000621 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 621:	55                   	push   %ebp
 622:	89 e5                	mov    %esp,%ebp
 624:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	83 e8 08             	sub    $0x8,%eax
 62d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 630:	a1 c8 0a 00 00       	mov    0xac8,%eax
 635:	89 45 fc             	mov    %eax,-0x4(%ebp)
 638:	eb 24                	jmp    65e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 63a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 642:	77 12                	ja     656 <free+0x35>
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64a:	77 24                	ja     670 <free+0x4f>
 64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64f:	8b 00                	mov    (%eax),%eax
 651:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 654:	77 1a                	ja     670 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 656:	8b 45 fc             	mov    -0x4(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 664:	76 d4                	jbe    63a <free+0x19>
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66e:	76 ca                	jbe    63a <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 670:	8b 45 f8             	mov    -0x8(%ebp),%eax
 673:	8b 40 04             	mov    0x4(%eax),%eax
 676:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	01 c2                	add    %eax,%edx
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	39 c2                	cmp    %eax,%edx
 689:	75 24                	jne    6af <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	8b 50 04             	mov    0x4(%eax),%edx
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	8b 40 04             	mov    0x4(%eax),%eax
 699:	01 c2                	add    %eax,%edx
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	8b 10                	mov    (%eax),%edx
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	89 10                	mov    %edx,(%eax)
 6ad:	eb 0a                	jmp    6b9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 40 04             	mov    0x4(%eax),%eax
 6bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	01 d0                	add    %edx,%eax
 6cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ce:	75 20                	jne    6f0 <free+0xcf>
    p->s.size += bp->s.size;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d9:	8b 40 04             	mov    0x4(%eax),%eax
 6dc:	01 c2                	add    %eax,%edx
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e7:	8b 10                	mov    (%eax),%edx
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	89 10                	mov    %edx,(%eax)
 6ee:	eb 08                	jmp    6f8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	a3 c8 0a 00 00       	mov    %eax,0xac8
}
 700:	c9                   	leave  
 701:	c3                   	ret    

00000702 <morecore>:

static Header*
morecore(uint nu)
{
 702:	55                   	push   %ebp
 703:	89 e5                	mov    %esp,%ebp
 705:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 708:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70f:	77 07                	ja     718 <morecore+0x16>
    nu = 4096;
 711:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	c1 e0 03             	shl    $0x3,%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 3d fc ff ff       	call   363 <sbrk>
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 729:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 72d:	75 07                	jne    736 <morecore+0x34>
    return 0;
 72f:	b8 00 00 00 00       	mov    $0x0,%eax
 734:	eb 22                	jmp    758 <morecore+0x56>
  hp = (Header*)p;
 736:	8b 45 f4             	mov    -0xc(%ebp),%eax
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 73c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73f:	8b 55 08             	mov    0x8(%ebp),%edx
 742:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	83 c0 08             	add    $0x8,%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 ce fe ff ff       	call   621 <free>
  return freep;
 753:	a1 c8 0a 00 00       	mov    0xac8,%eax
}
 758:	c9                   	leave  
 759:	c3                   	ret    

0000075a <malloc>:

void*
malloc(uint nbytes)
{
 75a:	55                   	push   %ebp
 75b:	89 e5                	mov    %esp,%ebp
 75d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 760:	8b 45 08             	mov    0x8(%ebp),%eax
 763:	83 c0 07             	add    $0x7,%eax
 766:	c1 e8 03             	shr    $0x3,%eax
 769:	40                   	inc    %eax
 76a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 76d:	a1 c8 0a 00 00       	mov    0xac8,%eax
 772:	89 45 f0             	mov    %eax,-0x10(%ebp)
 775:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 779:	75 23                	jne    79e <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 77b:	c7 45 f0 c0 0a 00 00 	movl   $0xac0,-0x10(%ebp)
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
 785:	a3 c8 0a 00 00       	mov    %eax,0xac8
 78a:	a1 c8 0a 00 00       	mov    0xac8,%eax
 78f:	a3 c0 0a 00 00       	mov    %eax,0xac0
    base.s.size = 0;
 794:	c7 05 c4 0a 00 00 00 	movl   $0x0,0xac4
 79b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7af:	72 4d                	jb     7fe <malloc+0xa4>
      if(p->s.size == nunits)
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ba:	75 0c                	jne    7c8 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bf:	8b 10                	mov    (%eax),%edx
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	89 10                	mov    %edx,(%eax)
 7c6:	eb 26                	jmp    7ee <malloc+0x94>
      else {
        p->s.size -= nunits;
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	89 c2                	mov    %eax,%edx
 7d0:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	c1 e0 03             	shl    $0x3,%eax
 7e2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	a3 c8 0a 00 00       	mov    %eax,0xac8
      return (void*)(p + 1);
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	83 c0 08             	add    $0x8,%eax
 7fc:	eb 38                	jmp    836 <malloc+0xdc>
    }
    if(p == freep)
 7fe:	a1 c8 0a 00 00       	mov    0xac8,%eax
 803:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 806:	75 1b                	jne    823 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 808:	8b 45 ec             	mov    -0x14(%ebp),%eax
 80b:	89 04 24             	mov    %eax,(%esp)
 80e:	e8 ef fe ff ff       	call   702 <morecore>
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
 816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 81a:	75 07                	jne    823 <malloc+0xc9>
        return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 13                	jmp    836 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 831:	e9 70 ff ff ff       	jmp    7a6 <malloc+0x4c>
}
 836:	c9                   	leave  
 837:	c3                   	ret    
