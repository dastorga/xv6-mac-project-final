
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
  11:	c7 04 24 70 08 00 00 	movl   $0x870,(%esp)
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
  3d:	c7 44 24 04 75 08 00 	movl   $0x875,0x4(%esp)
  44:	00 
  45:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  49:	89 04 24             	mov    %eax,(%esp)
  4c:	e8 5a 04 00 00       	call   4ab <printf>
	lseek(fd, 1000, SEEK_END);
  51:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
  58:	00 
  59:	c7 44 24 04 e8 03 00 	movl   $0x3e8,0x4(%esp)
  60:	00 
  61:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  65:	89 04 24             	mov    %eax,(%esp)
  68:	e8 0e 03 00 00       	call   37b <lseek>
	printf(fd, "moar stuff\n");
  6d:	c7 44 24 04 7d 08 00 	movl   $0x87d,0x4(%esp)
  74:	00 
  75:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  79:	89 04 24             	mov    %eax,(%esp)
  7c:	e8 2a 04 00 00       	call   4ab <printf>
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

0000039b <semget>:
 39b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <semfree>:
 3a3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <semdown>:
 3ab:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <semup>:
 3b3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <shm_create>:
 3bb:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <shm_close>:
 3c3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <shm_get>:
 3cb:	b8 20 00 00 00       	mov    $0x20,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3d3:	55                   	push   %ebp
 3d4:	89 e5                	mov    %esp,%ebp
 3d6:	83 ec 28             	sub    $0x28,%esp
 3d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3dc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3df:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e6:	00 
 3e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	89 04 24             	mov    %eax,(%esp)
 3f4:	e8 02 ff ff ff       	call   2fb <write>
}
 3f9:	c9                   	leave  
 3fa:	c3                   	ret    

000003fb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 401:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 408:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 40c:	74 17                	je     425 <printint+0x2a>
 40e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 412:	79 11                	jns    425 <printint+0x2a>
    neg = 1;
 414:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	f7 d8                	neg    %eax
 420:	89 45 ec             	mov    %eax,-0x14(%ebp)
 423:	eb 06                	jmp    42b <printint+0x30>
  } else {
    x = xx;
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 42b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 432:	8b 4d 10             	mov    0x10(%ebp),%ecx
 435:	8b 45 ec             	mov    -0x14(%ebp),%eax
 438:	ba 00 00 00 00       	mov    $0x0,%edx
 43d:	f7 f1                	div    %ecx
 43f:	89 d0                	mov    %edx,%eax
 441:	8a 80 cc 0a 00 00    	mov    0xacc(%eax),%al
 447:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 44a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 44d:	01 ca                	add    %ecx,%edx
 44f:	88 02                	mov    %al,(%edx)
 451:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 454:	8b 55 10             	mov    0x10(%ebp),%edx
 457:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 45a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45d:	ba 00 00 00 00       	mov    $0x0,%edx
 462:	f7 75 d4             	divl   -0x2c(%ebp)
 465:	89 45 ec             	mov    %eax,-0x14(%ebp)
 468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46c:	75 c4                	jne    432 <printint+0x37>
  if(neg)
 46e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 472:	74 2c                	je     4a0 <printint+0xa5>
    buf[i++] = '-';
 474:	8d 55 dc             	lea    -0x24(%ebp),%edx
 477:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	c6 00 2d             	movb   $0x2d,(%eax)
 47f:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 482:	eb 1c                	jmp    4a0 <printint+0xa5>
    putc(fd, buf[i]);
 484:	8d 55 dc             	lea    -0x24(%ebp),%edx
 487:	8b 45 f4             	mov    -0xc(%ebp),%eax
 48a:	01 d0                	add    %edx,%eax
 48c:	8a 00                	mov    (%eax),%al
 48e:	0f be c0             	movsbl %al,%eax
 491:	89 44 24 04          	mov    %eax,0x4(%esp)
 495:	8b 45 08             	mov    0x8(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 33 ff ff ff       	call   3d3 <putc>
  while(--i >= 0)
 4a0:	ff 4d f4             	decl   -0xc(%ebp)
 4a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a7:	79 db                	jns    484 <printint+0x89>
}
 4a9:	c9                   	leave  
 4aa:	c3                   	ret    

000004ab <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ab:	55                   	push   %ebp
 4ac:	89 e5                	mov    %esp,%ebp
 4ae:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b8:	8d 45 0c             	lea    0xc(%ebp),%eax
 4bb:	83 c0 04             	add    $0x4,%eax
 4be:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c8:	e9 78 01 00 00       	jmp    645 <printf+0x19a>
    c = fmt[i] & 0xff;
 4cd:	8b 55 0c             	mov    0xc(%ebp),%edx
 4d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4d3:	01 d0                	add    %edx,%eax
 4d5:	8a 00                	mov    (%eax),%al
 4d7:	0f be c0             	movsbl %al,%eax
 4da:	25 ff 00 00 00       	and    $0xff,%eax
 4df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e6:	75 2c                	jne    514 <printf+0x69>
      if(c == '%'){
 4e8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4ec:	75 0c                	jne    4fa <printf+0x4f>
        state = '%';
 4ee:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f5:	e9 48 01 00 00       	jmp    642 <printf+0x197>
      } else {
        putc(fd, c);
 4fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4fd:	0f be c0             	movsbl %al,%eax
 500:	89 44 24 04          	mov    %eax,0x4(%esp)
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	89 04 24             	mov    %eax,(%esp)
 50a:	e8 c4 fe ff ff       	call   3d3 <putc>
 50f:	e9 2e 01 00 00       	jmp    642 <printf+0x197>
      }
    } else if(state == '%'){
 514:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 518:	0f 85 24 01 00 00    	jne    642 <printf+0x197>
      if(c == 'd'){
 51e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 522:	75 2d                	jne    551 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 524:	8b 45 e8             	mov    -0x18(%ebp),%eax
 527:	8b 00                	mov    (%eax),%eax
 529:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 530:	00 
 531:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 538:	00 
 539:	89 44 24 04          	mov    %eax,0x4(%esp)
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
 540:	89 04 24             	mov    %eax,(%esp)
 543:	e8 b3 fe ff ff       	call   3fb <printint>
        ap++;
 548:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54c:	e9 ea 00 00 00       	jmp    63b <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 551:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 555:	74 06                	je     55d <printf+0xb2>
 557:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 55b:	75 2d                	jne    58a <printf+0xdf>
        printint(fd, *ap, 16, 0);
 55d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 560:	8b 00                	mov    (%eax),%eax
 562:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 569:	00 
 56a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 571:	00 
 572:	89 44 24 04          	mov    %eax,0x4(%esp)
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	89 04 24             	mov    %eax,(%esp)
 57c:	e8 7a fe ff ff       	call   3fb <printint>
        ap++;
 581:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 585:	e9 b1 00 00 00       	jmp    63b <printf+0x190>
      } else if(c == 's'){
 58a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58e:	75 43                	jne    5d3 <printf+0x128>
        s = (char*)*ap;
 590:	8b 45 e8             	mov    -0x18(%ebp),%eax
 593:	8b 00                	mov    (%eax),%eax
 595:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 598:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a0:	75 25                	jne    5c7 <printf+0x11c>
          s = "(null)";
 5a2:	c7 45 f4 89 08 00 00 	movl   $0x889,-0xc(%ebp)
        while(*s != 0){
 5a9:	eb 1c                	jmp    5c7 <printf+0x11c>
          putc(fd, *s);
 5ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ae:	8a 00                	mov    (%eax),%al
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ba:	89 04 24             	mov    %eax,(%esp)
 5bd:	e8 11 fe ff ff       	call   3d3 <putc>
          s++;
 5c2:	ff 45 f4             	incl   -0xc(%ebp)
 5c5:	eb 01                	jmp    5c8 <printf+0x11d>
        while(*s != 0){
 5c7:	90                   	nop
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	8a 00                	mov    (%eax),%al
 5cd:	84 c0                	test   %al,%al
 5cf:	75 da                	jne    5ab <printf+0x100>
 5d1:	eb 68                	jmp    63b <printf+0x190>
        }
      } else if(c == 'c'){
 5d3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d7:	75 1d                	jne    5f6 <printf+0x14b>
        putc(fd, *ap);
 5d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dc:	8b 00                	mov    (%eax),%eax
 5de:	0f be c0             	movsbl %al,%eax
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 e3 fd ff ff       	call   3d3 <putc>
        ap++;
 5f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f4:	eb 45                	jmp    63b <printf+0x190>
      } else if(c == '%'){
 5f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fa:	75 17                	jne    613 <printf+0x168>
        putc(fd, c);
 5fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ff:	0f be c0             	movsbl %al,%eax
 602:	89 44 24 04          	mov    %eax,0x4(%esp)
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	89 04 24             	mov    %eax,(%esp)
 60c:	e8 c2 fd ff ff       	call   3d3 <putc>
 611:	eb 28                	jmp    63b <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 613:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 61a:	00 
 61b:	8b 45 08             	mov    0x8(%ebp),%eax
 61e:	89 04 24             	mov    %eax,(%esp)
 621:	e8 ad fd ff ff       	call   3d3 <putc>
        putc(fd, c);
 626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 629:	0f be c0             	movsbl %al,%eax
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 04 24             	mov    %eax,(%esp)
 636:	e8 98 fd ff ff       	call   3d3 <putc>
      }
      state = 0;
 63b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 642:	ff 45 f0             	incl   -0x10(%ebp)
 645:	8b 55 0c             	mov    0xc(%ebp),%edx
 648:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64b:	01 d0                	add    %edx,%eax
 64d:	8a 00                	mov    (%eax),%al
 64f:	84 c0                	test   %al,%al
 651:	0f 85 76 fe ff ff    	jne    4cd <printf+0x22>
    }
  }
}
 657:	c9                   	leave  
 658:	c3                   	ret    

00000659 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	83 e8 08             	sub    $0x8,%eax
 665:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	a1 e8 0a 00 00       	mov    0xae8,%eax
 66d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 670:	eb 24                	jmp    696 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67a:	77 12                	ja     68e <free+0x35>
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	77 24                	ja     6a8 <free+0x4f>
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68c:	77 1a                	ja     6a8 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	89 45 fc             	mov    %eax,-0x4(%ebp)
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69c:	76 d4                	jbe    672 <free+0x19>
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a6:	76 ca                	jbe    672 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	39 c2                	cmp    %eax,%edx
 6c1:	75 24                	jne    6e7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 50 04             	mov    0x4(%eax),%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	8b 40 04             	mov    0x4(%eax),%eax
 6d1:	01 c2                	add    %eax,%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 0a                	jmp    6f1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 40 04             	mov    0x4(%eax),%eax
 6f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 706:	75 20                	jne    728 <free+0xcf>
    p->s.size += bp->s.size;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	01 c2                	add    %eax,%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 10                	mov    (%eax),%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 10                	mov    %edx,(%eax)
 726:	eb 08                	jmp    730 <free+0xd7>
  } else
    p->s.ptr = bp;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72e:	89 10                	mov    %edx,(%eax)
  freep = p;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	a3 e8 0a 00 00       	mov    %eax,0xae8
}
 738:	c9                   	leave  
 739:	c3                   	ret    

0000073a <morecore>:

static Header*
morecore(uint nu)
{
 73a:	55                   	push   %ebp
 73b:	89 e5                	mov    %esp,%ebp
 73d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 740:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 747:	77 07                	ja     750 <morecore+0x16>
    nu = 4096;
 749:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	c1 e0 03             	shl    $0x3,%eax
 756:	89 04 24             	mov    %eax,(%esp)
 759:	e8 05 fc ff ff       	call   363 <sbrk>
 75e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 761:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 765:	75 07                	jne    76e <morecore+0x34>
    return 0;
 767:	b8 00 00 00 00       	mov    $0x0,%eax
 76c:	eb 22                	jmp    790 <morecore+0x56>
  hp = (Header*)p;
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 774:	8b 45 f0             	mov    -0x10(%ebp),%eax
 777:	8b 55 08             	mov    0x8(%ebp),%edx
 77a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	83 c0 08             	add    $0x8,%eax
 783:	89 04 24             	mov    %eax,(%esp)
 786:	e8 ce fe ff ff       	call   659 <free>
  return freep;
 78b:	a1 e8 0a 00 00       	mov    0xae8,%eax
}
 790:	c9                   	leave  
 791:	c3                   	ret    

00000792 <malloc>:

void*
malloc(uint nbytes)
{
 792:	55                   	push   %ebp
 793:	89 e5                	mov    %esp,%ebp
 795:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	83 c0 07             	add    $0x7,%eax
 79e:	c1 e8 03             	shr    $0x3,%eax
 7a1:	40                   	inc    %eax
 7a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a5:	a1 e8 0a 00 00       	mov    0xae8,%eax
 7aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b1:	75 23                	jne    7d6 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7b3:	c7 45 f0 e0 0a 00 00 	movl   $0xae0,-0x10(%ebp)
 7ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bd:	a3 e8 0a 00 00       	mov    %eax,0xae8
 7c2:	a1 e8 0a 00 00       	mov    0xae8,%eax
 7c7:	a3 e0 0a 00 00       	mov    %eax,0xae0
    base.s.size = 0;
 7cc:	c7 05 e4 0a 00 00 00 	movl   $0x0,0xae4
 7d3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	8b 00                	mov    (%eax),%eax
 7db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e1:	8b 40 04             	mov    0x4(%eax),%eax
 7e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e7:	72 4d                	jb     836 <malloc+0xa4>
      if(p->s.size == nunits)
 7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f2:	75 0c                	jne    800 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	8b 10                	mov    (%eax),%edx
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	89 10                	mov    %edx,(%eax)
 7fe:	eb 26                	jmp    826 <malloc+0x94>
      else {
        p->s.size -= nunits;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	8b 40 04             	mov    0x4(%eax),%eax
 806:	89 c2                	mov    %eax,%edx
 808:	2b 55 ec             	sub    -0x14(%ebp),%edx
 80b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	c1 e0 03             	shl    $0x3,%eax
 81a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 820:	8b 55 ec             	mov    -0x14(%ebp),%edx
 823:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	a3 e8 0a 00 00       	mov    %eax,0xae8
      return (void*)(p + 1);
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	83 c0 08             	add    $0x8,%eax
 834:	eb 38                	jmp    86e <malloc+0xdc>
    }
    if(p == freep)
 836:	a1 e8 0a 00 00       	mov    0xae8,%eax
 83b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 83e:	75 1b                	jne    85b <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 840:	8b 45 ec             	mov    -0x14(%ebp),%eax
 843:	89 04 24             	mov    %eax,(%esp)
 846:	e8 ef fe ff ff       	call   73a <morecore>
 84b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 84e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 852:	75 07                	jne    85b <malloc+0xc9>
        return 0;
 854:	b8 00 00 00 00       	mov    $0x0,%eax
 859:	eb 13                	jmp    86e <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 869:	e9 70 ff ff ff       	jmp    7de <malloc+0x4c>
}
 86e:	c9                   	leave  
 86f:	c3                   	ret    
