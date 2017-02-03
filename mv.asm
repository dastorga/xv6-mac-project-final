
_mv:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if (argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: mv oldname newname\n");
   f:	c7 44 24 04 33 08 00 	movl   $0x833,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 4b 04 00 00       	call   46e <printf>
    exit();
  23:	e8 ae 02 00 00       	call   2d6 <exit>
  }
  if ((link(argv[1], argv[2]) < 0) || (unlink(argv[1]) < 0))
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 f2 02 00 00       	call   336 <link>
  44:	85 c0                	test   %eax,%eax
  46:	78 14                	js     5c <main+0x5c>
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 04             	add    $0x4,%eax
  4e:	8b 00                	mov    (%eax),%eax
  50:	89 04 24             	mov    %eax,(%esp)
  53:	e8 ce 02 00 00       	call   326 <unlink>
  58:	85 c0                	test   %eax,%eax
  5a:	79 2c                	jns    88 <main+0x88>
    printf(2, "mv %s to %s failed\n", argv[1], argv[2]);
  5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  5f:	83 c0 08             	add    $0x8,%eax
  62:	8b 10                	mov    (%eax),%edx
  64:	8b 45 0c             	mov    0xc(%ebp),%eax
  67:	83 c0 04             	add    $0x4,%eax
  6a:	8b 00                	mov    (%eax),%eax
  6c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  70:	89 44 24 08          	mov    %eax,0x8(%esp)
  74:	c7 44 24 04 4e 08 00 	movl   $0x84e,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  83:	e8 e6 03 00 00       	call   46e <printf>

  exit();
  88:	e8 49 02 00 00       	call   2d6 <exit>

0000008d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	57                   	push   %edi
  91:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  95:	8b 55 10             	mov    0x10(%ebp),%edx
  98:	8b 45 0c             	mov    0xc(%ebp),%eax
  9b:	89 cb                	mov    %ecx,%ebx
  9d:	89 df                	mov    %ebx,%edi
  9f:	89 d1                	mov    %edx,%ecx
  a1:	fc                   	cld    
  a2:	f3 aa                	rep stos %al,%es:(%edi)
  a4:	89 ca                	mov    %ecx,%edx
  a6:	89 fb                	mov    %edi,%ebx
  a8:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ab:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  ae:	5b                   	pop    %ebx
  af:	5f                   	pop    %edi
  b0:	5d                   	pop    %ebp
  b1:	c3                   	ret    

000000b2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  b5:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  be:	90                   	nop
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	8a 10                	mov    (%eax),%dl
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	88 10                	mov    %dl,(%eax)
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	8a 00                	mov    (%eax),%al
  ce:	84 c0                	test   %al,%al
  d0:	0f 95 c0             	setne  %al
  d3:	ff 45 08             	incl   0x8(%ebp)
  d6:	ff 45 0c             	incl   0xc(%ebp)
  d9:	84 c0                	test   %al,%al
  db:	75 e2                	jne    bf <strcpy+0xd>
    ;
  return os;
  dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e0:	c9                   	leave  
  e1:	c3                   	ret    

000000e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e2:	55                   	push   %ebp
  e3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e5:	eb 06                	jmp    ed <strcmp+0xb>
    p++, q++;
  e7:	ff 45 08             	incl   0x8(%ebp)
  ea:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  ed:	8b 45 08             	mov    0x8(%ebp),%eax
  f0:	8a 00                	mov    (%eax),%al
  f2:	84 c0                	test   %al,%al
  f4:	74 0e                	je     104 <strcmp+0x22>
  f6:	8b 45 08             	mov    0x8(%ebp),%eax
  f9:	8a 10                	mov    (%eax),%dl
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	8a 00                	mov    (%eax),%al
 100:	38 c2                	cmp    %al,%dl
 102:	74 e3                	je     e7 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8a 00                	mov    (%eax),%al
 109:	0f b6 d0             	movzbl %al,%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	8a 00                	mov    (%eax),%al
 111:	0f b6 c0             	movzbl %al,%eax
 114:	89 d1                	mov    %edx,%ecx
 116:	29 c1                	sub    %eax,%ecx
 118:	89 c8                	mov    %ecx,%eax
}
 11a:	5d                   	pop    %ebp
 11b:	c3                   	ret    

0000011c <strlen>:

uint
strlen(char *s)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 122:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 129:	eb 03                	jmp    12e <strlen+0x12>
 12b:	ff 45 fc             	incl   -0x4(%ebp)
 12e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	01 d0                	add    %edx,%eax
 136:	8a 00                	mov    (%eax),%al
 138:	84 c0                	test   %al,%al
 13a:	75 ef                	jne    12b <strlen+0xf>
    ;
  return n;
 13c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 13f:	c9                   	leave  
 140:	c3                   	ret    

00000141 <memset>:

void*
memset(void *dst, int c, uint n)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 147:	8b 45 10             	mov    0x10(%ebp),%eax
 14a:	89 44 24 08          	mov    %eax,0x8(%esp)
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	89 44 24 04          	mov    %eax,0x4(%esp)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	89 04 24             	mov    %eax,(%esp)
 15b:	e8 2d ff ff ff       	call   8d <stosb>
  return dst;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strchr>:

char*
strchr(const char *s, char c)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 171:	eb 12                	jmp    185 <strchr+0x20>
    if(*s == c)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	8a 00                	mov    (%eax),%al
 178:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17b:	75 05                	jne    182 <strchr+0x1d>
      return (char*)s;
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	eb 11                	jmp    193 <strchr+0x2e>
  for(; *s; s++)
 182:	ff 45 08             	incl   0x8(%ebp)
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8a 00                	mov    (%eax),%al
 18a:	84 c0                	test   %al,%al
 18c:	75 e5                	jne    173 <strchr+0xe>
  return 0;
 18e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <gets>:

char*
gets(char *buf, int max)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a2:	eb 42                	jmp    1e6 <gets+0x51>
    cc = read(0, &c, 1);
 1a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1ab:	00 
 1ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1af:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ba:	e8 2f 01 00 00       	call   2ee <read>
 1bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c6:	7e 29                	jle    1f1 <gets+0x5c>
      break;
    buf[i++] = c;
 1c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	01 c2                	add    %eax,%edx
 1d0:	8a 45 ef             	mov    -0x11(%ebp),%al
 1d3:	88 02                	mov    %al,(%edx)
 1d5:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 1d8:	8a 45 ef             	mov    -0x11(%ebp),%al
 1db:	3c 0a                	cmp    $0xa,%al
 1dd:	74 13                	je     1f2 <gets+0x5d>
 1df:	8a 45 ef             	mov    -0x11(%ebp),%al
 1e2:	3c 0d                	cmp    $0xd,%al
 1e4:	74 0c                	je     1f2 <gets+0x5d>
  for(i=0; i+1 < max; ){
 1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e9:	40                   	inc    %eax
 1ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ed:	7c b5                	jl     1a4 <gets+0xf>
 1ef:	eb 01                	jmp    1f2 <gets+0x5d>
      break;
 1f1:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	01 d0                	add    %edx,%eax
 1fa:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 200:	c9                   	leave  
 201:	c3                   	ret    

00000202 <stat>:

int
stat(char *n, struct stat *st)
{
 202:	55                   	push   %ebp
 203:	89 e5                	mov    %esp,%ebp
 205:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 208:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20f:	00 
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	89 04 24             	mov    %eax,(%esp)
 216:	e8 fb 00 00 00       	call   316 <open>
 21b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 222:	79 07                	jns    22b <stat+0x29>
    return -1;
 224:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 229:	eb 23                	jmp    24e <stat+0x4c>
  r = fstat(fd, st);
 22b:	8b 45 0c             	mov    0xc(%ebp),%eax
 22e:	89 44 24 04          	mov    %eax,0x4(%esp)
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 f1 00 00 00       	call   32e <fstat>
 23d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 240:	8b 45 f4             	mov    -0xc(%ebp),%eax
 243:	89 04 24             	mov    %eax,(%esp)
 246:	e8 b3 00 00 00       	call   2fe <close>
  return r;
 24b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24e:	c9                   	leave  
 24f:	c3                   	ret    

00000250 <atoi>:

int
atoi(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 256:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25d:	eb 21                	jmp    280 <atoi+0x30>
    n = n*10 + *s++ - '0';
 25f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 262:	89 d0                	mov    %edx,%eax
 264:	c1 e0 02             	shl    $0x2,%eax
 267:	01 d0                	add    %edx,%eax
 269:	d1 e0                	shl    %eax
 26b:	89 c2                	mov    %eax,%edx
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	8a 00                	mov    (%eax),%al
 272:	0f be c0             	movsbl %al,%eax
 275:	01 d0                	add    %edx,%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27d:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	8a 00                	mov    (%eax),%al
 285:	3c 2f                	cmp    $0x2f,%al
 287:	7e 09                	jle    292 <atoi+0x42>
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	8a 00                	mov    (%eax),%al
 28e:	3c 39                	cmp    $0x39,%al
 290:	7e cd                	jle    25f <atoi+0xf>
  return n;
 292:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a9:	eb 10                	jmp    2bb <memmove+0x24>
    *dst++ = *src++;
 2ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ae:	8a 10                	mov    (%eax),%dl
 2b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b3:	88 10                	mov    %dl,(%eax)
 2b5:	ff 45 fc             	incl   -0x4(%ebp)
 2b8:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 2bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2bf:	0f 9f c0             	setg   %al
 2c2:	ff 4d 10             	decl   0x10(%ebp)
 2c5:	84 c0                	test   %al,%al
 2c7:	75 e2                	jne    2ab <memmove+0x14>
  return vdst;
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <fork>:
 2ce:	b8 01 00 00 00       	mov    $0x1,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <exit>:
 2d6:	b8 02 00 00 00       	mov    $0x2,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <wait>:
 2de:	b8 03 00 00 00       	mov    $0x3,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <pipe>:
 2e6:	b8 04 00 00 00       	mov    $0x4,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <read>:
 2ee:	b8 05 00 00 00       	mov    $0x5,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <write>:
 2f6:	b8 10 00 00 00       	mov    $0x10,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <close>:
 2fe:	b8 15 00 00 00       	mov    $0x15,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <kill>:
 306:	b8 06 00 00 00       	mov    $0x6,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <exec>:
 30e:	b8 07 00 00 00       	mov    $0x7,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <open>:
 316:	b8 0f 00 00 00       	mov    $0xf,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <mknod>:
 31e:	b8 11 00 00 00       	mov    $0x11,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    

00000326 <unlink>:
 326:	b8 12 00 00 00       	mov    $0x12,%eax
 32b:	cd 40                	int    $0x40
 32d:	c3                   	ret    

0000032e <fstat>:
 32e:	b8 08 00 00 00       	mov    $0x8,%eax
 333:	cd 40                	int    $0x40
 335:	c3                   	ret    

00000336 <link>:
 336:	b8 13 00 00 00       	mov    $0x13,%eax
 33b:	cd 40                	int    $0x40
 33d:	c3                   	ret    

0000033e <mkdir>:
 33e:	b8 14 00 00 00       	mov    $0x14,%eax
 343:	cd 40                	int    $0x40
 345:	c3                   	ret    

00000346 <chdir>:
 346:	b8 09 00 00 00       	mov    $0x9,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <dup>:
 34e:	b8 0a 00 00 00       	mov    $0xa,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <getpid>:
 356:	b8 0b 00 00 00       	mov    $0xb,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <sbrk>:
 35e:	b8 0c 00 00 00       	mov    $0xc,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <sleep>:
 366:	b8 0d 00 00 00       	mov    $0xd,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <uptime>:
 36e:	b8 0e 00 00 00       	mov    $0xe,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <lseek>:
 376:	b8 16 00 00 00       	mov    $0x16,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <isatty>:
 37e:	b8 17 00 00 00       	mov    $0x17,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <procstat>:
 386:	b8 18 00 00 00       	mov    $0x18,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <set_priority>:
 38e:	b8 19 00 00 00       	mov    $0x19,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 28             	sub    $0x28,%esp
 39c:	8b 45 0c             	mov    0xc(%ebp),%eax
 39f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3a2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a9:	00 
 3aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b1:	8b 45 08             	mov    0x8(%ebp),%eax
 3b4:	89 04 24             	mov    %eax,(%esp)
 3b7:	e8 3a ff ff ff       	call   2f6 <write>
}
 3bc:	c9                   	leave  
 3bd:	c3                   	ret    

000003be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3be:	55                   	push   %ebp
 3bf:	89 e5                	mov    %esp,%ebp
 3c1:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3cb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3cf:	74 17                	je     3e8 <printint+0x2a>
 3d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3d5:	79 11                	jns    3e8 <printint+0x2a>
    neg = 1;
 3d7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3de:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e1:	f7 d8                	neg    %eax
 3e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e6:	eb 06                	jmp    3ee <printint+0x30>
  } else {
    x = xx;
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fb:	ba 00 00 00 00       	mov    $0x0,%edx
 400:	f7 f1                	div    %ecx
 402:	89 d0                	mov    %edx,%eax
 404:	8a 80 a8 0a 00 00    	mov    0xaa8(%eax),%al
 40a:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 40d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 410:	01 ca                	add    %ecx,%edx
 412:	88 02                	mov    %al,(%edx)
 414:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 417:	8b 55 10             	mov    0x10(%ebp),%edx
 41a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 41d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 420:	ba 00 00 00 00       	mov    $0x0,%edx
 425:	f7 75 d4             	divl   -0x2c(%ebp)
 428:	89 45 ec             	mov    %eax,-0x14(%ebp)
 42b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42f:	75 c4                	jne    3f5 <printint+0x37>
  if(neg)
 431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 435:	74 2c                	je     463 <printint+0xa5>
    buf[i++] = '-';
 437:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43d:	01 d0                	add    %edx,%eax
 43f:	c6 00 2d             	movb   $0x2d,(%eax)
 442:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 445:	eb 1c                	jmp    463 <printint+0xa5>
    putc(fd, buf[i]);
 447:	8d 55 dc             	lea    -0x24(%ebp),%edx
 44a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44d:	01 d0                	add    %edx,%eax
 44f:	8a 00                	mov    (%eax),%al
 451:	0f be c0             	movsbl %al,%eax
 454:	89 44 24 04          	mov    %eax,0x4(%esp)
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	89 04 24             	mov    %eax,(%esp)
 45e:	e8 33 ff ff ff       	call   396 <putc>
  while(--i >= 0)
 463:	ff 4d f4             	decl   -0xc(%ebp)
 466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 46a:	79 db                	jns    447 <printint+0x89>
}
 46c:	c9                   	leave  
 46d:	c3                   	ret    

0000046e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 474:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 47b:	8d 45 0c             	lea    0xc(%ebp),%eax
 47e:	83 c0 04             	add    $0x4,%eax
 481:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 484:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 48b:	e9 78 01 00 00       	jmp    608 <printf+0x19a>
    c = fmt[i] & 0xff;
 490:	8b 55 0c             	mov    0xc(%ebp),%edx
 493:	8b 45 f0             	mov    -0x10(%ebp),%eax
 496:	01 d0                	add    %edx,%eax
 498:	8a 00                	mov    (%eax),%al
 49a:	0f be c0             	movsbl %al,%eax
 49d:	25 ff 00 00 00       	and    $0xff,%eax
 4a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a9:	75 2c                	jne    4d7 <printf+0x69>
      if(c == '%'){
 4ab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4af:	75 0c                	jne    4bd <printf+0x4f>
        state = '%';
 4b1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4b8:	e9 48 01 00 00       	jmp    605 <printf+0x197>
      } else {
        putc(fd, c);
 4bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4c0:	0f be c0             	movsbl %al,%eax
 4c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	89 04 24             	mov    %eax,(%esp)
 4cd:	e8 c4 fe ff ff       	call   396 <putc>
 4d2:	e9 2e 01 00 00       	jmp    605 <printf+0x197>
      }
    } else if(state == '%'){
 4d7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4db:	0f 85 24 01 00 00    	jne    605 <printf+0x197>
      if(c == 'd'){
 4e1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4e5:	75 2d                	jne    514 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ea:	8b 00                	mov    (%eax),%eax
 4ec:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4f3:	00 
 4f4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4fb:	00 
 4fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 500:	8b 45 08             	mov    0x8(%ebp),%eax
 503:	89 04 24             	mov    %eax,(%esp)
 506:	e8 b3 fe ff ff       	call   3be <printint>
        ap++;
 50b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50f:	e9 ea 00 00 00       	jmp    5fe <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 514:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 518:	74 06                	je     520 <printf+0xb2>
 51a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 51e:	75 2d                	jne    54d <printf+0xdf>
        printint(fd, *ap, 16, 0);
 520:	8b 45 e8             	mov    -0x18(%ebp),%eax
 523:	8b 00                	mov    (%eax),%eax
 525:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 52c:	00 
 52d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 534:	00 
 535:	89 44 24 04          	mov    %eax,0x4(%esp)
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	89 04 24             	mov    %eax,(%esp)
 53f:	e8 7a fe ff ff       	call   3be <printint>
        ap++;
 544:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 548:	e9 b1 00 00 00       	jmp    5fe <printf+0x190>
      } else if(c == 's'){
 54d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 551:	75 43                	jne    596 <printf+0x128>
        s = (char*)*ap;
 553:	8b 45 e8             	mov    -0x18(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 55b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 55f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 563:	75 25                	jne    58a <printf+0x11c>
          s = "(null)";
 565:	c7 45 f4 62 08 00 00 	movl   $0x862,-0xc(%ebp)
        while(*s != 0){
 56c:	eb 1c                	jmp    58a <printf+0x11c>
          putc(fd, *s);
 56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 571:	8a 00                	mov    (%eax),%al
 573:	0f be c0             	movsbl %al,%eax
 576:	89 44 24 04          	mov    %eax,0x4(%esp)
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	89 04 24             	mov    %eax,(%esp)
 580:	e8 11 fe ff ff       	call   396 <putc>
          s++;
 585:	ff 45 f4             	incl   -0xc(%ebp)
 588:	eb 01                	jmp    58b <printf+0x11d>
        while(*s != 0){
 58a:	90                   	nop
 58b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58e:	8a 00                	mov    (%eax),%al
 590:	84 c0                	test   %al,%al
 592:	75 da                	jne    56e <printf+0x100>
 594:	eb 68                	jmp    5fe <printf+0x190>
        }
      } else if(c == 'c'){
 596:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 59a:	75 1d                	jne    5b9 <printf+0x14b>
        putc(fd, *ap);
 59c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59f:	8b 00                	mov    (%eax),%eax
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 e3 fd ff ff       	call   396 <putc>
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b7:	eb 45                	jmp    5fe <printf+0x190>
      } else if(c == '%'){
 5b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5bd:	75 17                	jne    5d6 <printf+0x168>
        putc(fd, c);
 5bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	89 04 24             	mov    %eax,(%esp)
 5cf:	e8 c2 fd ff ff       	call   396 <putc>
 5d4:	eb 28                	jmp    5fe <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5d6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5dd:	00 
 5de:	8b 45 08             	mov    0x8(%ebp),%eax
 5e1:	89 04 24             	mov    %eax,(%esp)
 5e4:	e8 ad fd ff ff       	call   396 <putc>
        putc(fd, c);
 5e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ec:	0f be c0             	movsbl %al,%eax
 5ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	89 04 24             	mov    %eax,(%esp)
 5f9:	e8 98 fd ff ff       	call   396 <putc>
      }
      state = 0;
 5fe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 605:	ff 45 f0             	incl   -0x10(%ebp)
 608:	8b 55 0c             	mov    0xc(%ebp),%edx
 60b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60e:	01 d0                	add    %edx,%eax
 610:	8a 00                	mov    (%eax),%al
 612:	84 c0                	test   %al,%al
 614:	0f 85 76 fe ff ff    	jne    490 <printf+0x22>
    }
  }
}
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 61c:	55                   	push   %ebp
 61d:	89 e5                	mov    %esp,%ebp
 61f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	83 e8 08             	sub    $0x8,%eax
 628:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62b:	a1 c4 0a 00 00       	mov    0xac4,%eax
 630:	89 45 fc             	mov    %eax,-0x4(%ebp)
 633:	eb 24                	jmp    659 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63d:	77 12                	ja     651 <free+0x35>
 63f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 642:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 645:	77 24                	ja     66b <free+0x4f>
 647:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64a:	8b 00                	mov    (%eax),%eax
 64c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 64f:	77 1a                	ja     66b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	89 45 fc             	mov    %eax,-0x4(%ebp)
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 65f:	76 d4                	jbe    635 <free+0x19>
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 669:	76 ca                	jbe    635 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	8b 40 04             	mov    0x4(%eax),%eax
 671:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	01 c2                	add    %eax,%edx
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 00                	mov    (%eax),%eax
 682:	39 c2                	cmp    %eax,%edx
 684:	75 24                	jne    6aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	8b 50 04             	mov    0x4(%eax),%edx
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	8b 40 04             	mov    0x4(%eax),%eax
 694:	01 c2                	add    %eax,%edx
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 69c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69f:	8b 00                	mov    (%eax),%eax
 6a1:	8b 10                	mov    (%eax),%edx
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	89 10                	mov    %edx,(%eax)
 6a8:	eb 0a                	jmp    6b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ad:	8b 10                	mov    (%eax),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 40 04             	mov    0x4(%eax),%eax
 6ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	01 d0                	add    %edx,%eax
 6c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c9:	75 20                	jne    6eb <free+0xcf>
    p->s.size += bp->s.size;
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 50 04             	mov    0x4(%eax),%edx
 6d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d4:	8b 40 04             	mov    0x4(%eax),%eax
 6d7:	01 c2                	add    %eax,%edx
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	8b 10                	mov    (%eax),%edx
 6e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e7:	89 10                	mov    %edx,(%eax)
 6e9:	eb 08                	jmp    6f3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	a3 c4 0a 00 00       	mov    %eax,0xac4
}
 6fb:	c9                   	leave  
 6fc:	c3                   	ret    

000006fd <morecore>:

static Header*
morecore(uint nu)
{
 6fd:	55                   	push   %ebp
 6fe:	89 e5                	mov    %esp,%ebp
 700:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 703:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 70a:	77 07                	ja     713 <morecore+0x16>
    nu = 4096;
 70c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 713:	8b 45 08             	mov    0x8(%ebp),%eax
 716:	c1 e0 03             	shl    $0x3,%eax
 719:	89 04 24             	mov    %eax,(%esp)
 71c:	e8 3d fc ff ff       	call   35e <sbrk>
 721:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 724:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 728:	75 07                	jne    731 <morecore+0x34>
    return 0;
 72a:	b8 00 00 00 00       	mov    $0x0,%eax
 72f:	eb 22                	jmp    753 <morecore+0x56>
  hp = (Header*)p;
 731:	8b 45 f4             	mov    -0xc(%ebp),%eax
 734:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 737:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73a:	8b 55 08             	mov    0x8(%ebp),%edx
 73d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 740:	8b 45 f0             	mov    -0x10(%ebp),%eax
 743:	83 c0 08             	add    $0x8,%eax
 746:	89 04 24             	mov    %eax,(%esp)
 749:	e8 ce fe ff ff       	call   61c <free>
  return freep;
 74e:	a1 c4 0a 00 00       	mov    0xac4,%eax
}
 753:	c9                   	leave  
 754:	c3                   	ret    

00000755 <malloc>:

void*
malloc(uint nbytes)
{
 755:	55                   	push   %ebp
 756:	89 e5                	mov    %esp,%ebp
 758:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	83 c0 07             	add    $0x7,%eax
 761:	c1 e8 03             	shr    $0x3,%eax
 764:	40                   	inc    %eax
 765:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 768:	a1 c4 0a 00 00       	mov    0xac4,%eax
 76d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 770:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 774:	75 23                	jne    799 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 776:	c7 45 f0 bc 0a 00 00 	movl   $0xabc,-0x10(%ebp)
 77d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 780:	a3 c4 0a 00 00       	mov    %eax,0xac4
 785:	a1 c4 0a 00 00       	mov    0xac4,%eax
 78a:	a3 bc 0a 00 00       	mov    %eax,0xabc
    base.s.size = 0;
 78f:	c7 05 c0 0a 00 00 00 	movl   $0x0,0xac0
 796:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 799:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79c:	8b 00                	mov    (%eax),%eax
 79e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7aa:	72 4d                	jb     7f9 <malloc+0xa4>
      if(p->s.size == nunits)
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7b5:	75 0c                	jne    7c3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7bf:	89 10                	mov    %edx,(%eax)
 7c1:	eb 26                	jmp    7e9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	89 c2                	mov    %eax,%edx
 7cb:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	c1 e0 03             	shl    $0x3,%eax
 7dd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	a3 c4 0a 00 00       	mov    %eax,0xac4
      return (void*)(p + 1);
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	83 c0 08             	add    $0x8,%eax
 7f7:	eb 38                	jmp    831 <malloc+0xdc>
    }
    if(p == freep)
 7f9:	a1 c4 0a 00 00       	mov    0xac4,%eax
 7fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 801:	75 1b                	jne    81e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 803:	8b 45 ec             	mov    -0x14(%ebp),%eax
 806:	89 04 24             	mov    %eax,(%esp)
 809:	e8 ef fe ff ff       	call   6fd <morecore>
 80e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 815:	75 07                	jne    81e <malloc+0xc9>
        return 0;
 817:	b8 00 00 00 00       	mov    $0x0,%eax
 81c:	eb 13                	jmp    831 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	8b 00                	mov    (%eax),%eax
 829:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 82c:	e9 70 ff ff ff       	jmp    7a1 <malloc+0x4c>
}
 831:	c9                   	leave  
 832:	c3                   	ret    
