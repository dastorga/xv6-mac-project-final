
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
   f:	c7 44 24 04 6b 08 00 	movl   $0x86b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 83 04 00 00       	call   4a6 <printf>
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
  74:	c7 44 24 04 86 08 00 	movl   $0x886,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  83:	e8 1e 04 00 00       	call   4a6 <printf>

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

00000396 <semget>:
 396:	b8 1a 00 00 00       	mov    $0x1a,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <semfree>:
 39e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <semdown>:
 3a6:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <semup>:
 3ae:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <shm_create>:
 3b6:	b8 1e 00 00 00       	mov    $0x1e,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <shm_close>:
 3be:	b8 1f 00 00 00       	mov    $0x1f,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <shm_get>:
 3c6:	b8 20 00 00 00       	mov    $0x20,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
 3d1:	83 ec 28             	sub    $0x28,%esp
 3d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3da:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3e1:	00 
 3e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	89 04 24             	mov    %eax,(%esp)
 3ef:	e8 02 ff ff ff       	call   2f6 <write>
}
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    

000003f6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 403:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 407:	74 17                	je     420 <printint+0x2a>
 409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 40d:	79 11                	jns    420 <printint+0x2a>
    neg = 1;
 40f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 416:	8b 45 0c             	mov    0xc(%ebp),%eax
 419:	f7 d8                	neg    %eax
 41b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41e:	eb 06                	jmp    426 <printint+0x30>
  } else {
    x = xx;
 420:	8b 45 0c             	mov    0xc(%ebp),%eax
 423:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 426:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 42d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 430:	8b 45 ec             	mov    -0x14(%ebp),%eax
 433:	ba 00 00 00 00       	mov    $0x0,%edx
 438:	f7 f1                	div    %ecx
 43a:	89 d0                	mov    %edx,%eax
 43c:	8a 80 e0 0a 00 00    	mov    0xae0(%eax),%al
 442:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 445:	8b 55 f4             	mov    -0xc(%ebp),%edx
 448:	01 ca                	add    %ecx,%edx
 44a:	88 02                	mov    %al,(%edx)
 44c:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 44f:	8b 55 10             	mov    0x10(%ebp),%edx
 452:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 455:	8b 45 ec             	mov    -0x14(%ebp),%eax
 458:	ba 00 00 00 00       	mov    $0x0,%edx
 45d:	f7 75 d4             	divl   -0x2c(%ebp)
 460:	89 45 ec             	mov    %eax,-0x14(%ebp)
 463:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 467:	75 c4                	jne    42d <printint+0x37>
  if(neg)
 469:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 46d:	74 2c                	je     49b <printint+0xa5>
    buf[i++] = '-';
 46f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 472:	8b 45 f4             	mov    -0xc(%ebp),%eax
 475:	01 d0                	add    %edx,%eax
 477:	c6 00 2d             	movb   $0x2d,(%eax)
 47a:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 47d:	eb 1c                	jmp    49b <printint+0xa5>
    putc(fd, buf[i]);
 47f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 482:	8b 45 f4             	mov    -0xc(%ebp),%eax
 485:	01 d0                	add    %edx,%eax
 487:	8a 00                	mov    (%eax),%al
 489:	0f be c0             	movsbl %al,%eax
 48c:	89 44 24 04          	mov    %eax,0x4(%esp)
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	89 04 24             	mov    %eax,(%esp)
 496:	e8 33 ff ff ff       	call   3ce <putc>
  while(--i >= 0)
 49b:	ff 4d f4             	decl   -0xc(%ebp)
 49e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a2:	79 db                	jns    47f <printint+0x89>
}
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4b3:	8d 45 0c             	lea    0xc(%ebp),%eax
 4b6:	83 c0 04             	add    $0x4,%eax
 4b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4c3:	e9 78 01 00 00       	jmp    640 <printf+0x19a>
    c = fmt[i] & 0xff;
 4c8:	8b 55 0c             	mov    0xc(%ebp),%edx
 4cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ce:	01 d0                	add    %edx,%eax
 4d0:	8a 00                	mov    (%eax),%al
 4d2:	0f be c0             	movsbl %al,%eax
 4d5:	25 ff 00 00 00       	and    $0xff,%eax
 4da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e1:	75 2c                	jne    50f <printf+0x69>
      if(c == '%'){
 4e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4e7:	75 0c                	jne    4f5 <printf+0x4f>
        state = '%';
 4e9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4f0:	e9 48 01 00 00       	jmp    63d <printf+0x197>
      } else {
        putc(fd, c);
 4f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f8:	0f be c0             	movsbl %al,%eax
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 c4 fe ff ff       	call   3ce <putc>
 50a:	e9 2e 01 00 00       	jmp    63d <printf+0x197>
      }
    } else if(state == '%'){
 50f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 513:	0f 85 24 01 00 00    	jne    63d <printf+0x197>
      if(c == 'd'){
 519:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 51d:	75 2d                	jne    54c <printf+0xa6>
        printint(fd, *ap, 10, 1);
 51f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 522:	8b 00                	mov    (%eax),%eax
 524:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 52b:	00 
 52c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 533:	00 
 534:	89 44 24 04          	mov    %eax,0x4(%esp)
 538:	8b 45 08             	mov    0x8(%ebp),%eax
 53b:	89 04 24             	mov    %eax,(%esp)
 53e:	e8 b3 fe ff ff       	call   3f6 <printint>
        ap++;
 543:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 547:	e9 ea 00 00 00       	jmp    636 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 54c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 550:	74 06                	je     558 <printf+0xb2>
 552:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 556:	75 2d                	jne    585 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 558:	8b 45 e8             	mov    -0x18(%ebp),%eax
 55b:	8b 00                	mov    (%eax),%eax
 55d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 564:	00 
 565:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 56c:	00 
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 7a fe ff ff       	call   3f6 <printint>
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 580:	e9 b1 00 00 00       	jmp    636 <printf+0x190>
      } else if(c == 's'){
 585:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 589:	75 43                	jne    5ce <printf+0x128>
        s = (char*)*ap;
 58b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58e:	8b 00                	mov    (%eax),%eax
 590:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 593:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59b:	75 25                	jne    5c2 <printf+0x11c>
          s = "(null)";
 59d:	c7 45 f4 9a 08 00 00 	movl   $0x89a,-0xc(%ebp)
        while(*s != 0){
 5a4:	eb 1c                	jmp    5c2 <printf+0x11c>
          putc(fd, *s);
 5a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a9:	8a 00                	mov    (%eax),%al
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b2:	8b 45 08             	mov    0x8(%ebp),%eax
 5b5:	89 04 24             	mov    %eax,(%esp)
 5b8:	e8 11 fe ff ff       	call   3ce <putc>
          s++;
 5bd:	ff 45 f4             	incl   -0xc(%ebp)
 5c0:	eb 01                	jmp    5c3 <printf+0x11d>
        while(*s != 0){
 5c2:	90                   	nop
 5c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c6:	8a 00                	mov    (%eax),%al
 5c8:	84 c0                	test   %al,%al
 5ca:	75 da                	jne    5a6 <printf+0x100>
 5cc:	eb 68                	jmp    636 <printf+0x190>
        }
      } else if(c == 'c'){
 5ce:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d2:	75 1d                	jne    5f1 <printf+0x14b>
        putc(fd, *ap);
 5d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d7:	8b 00                	mov    (%eax),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e0:	8b 45 08             	mov    0x8(%ebp),%eax
 5e3:	89 04 24             	mov    %eax,(%esp)
 5e6:	e8 e3 fd ff ff       	call   3ce <putc>
        ap++;
 5eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ef:	eb 45                	jmp    636 <printf+0x190>
      } else if(c == '%'){
 5f1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f5:	75 17                	jne    60e <printf+0x168>
        putc(fd, c);
 5f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fa:	0f be c0             	movsbl %al,%eax
 5fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	89 04 24             	mov    %eax,(%esp)
 607:	e8 c2 fd ff ff       	call   3ce <putc>
 60c:	eb 28                	jmp    636 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60e:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 615:	00 
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	89 04 24             	mov    %eax,(%esp)
 61c:	e8 ad fd ff ff       	call   3ce <putc>
        putc(fd, c);
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	89 44 24 04          	mov    %eax,0x4(%esp)
 62b:	8b 45 08             	mov    0x8(%ebp),%eax
 62e:	89 04 24             	mov    %eax,(%esp)
 631:	e8 98 fd ff ff       	call   3ce <putc>
      }
      state = 0;
 636:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 63d:	ff 45 f0             	incl   -0x10(%ebp)
 640:	8b 55 0c             	mov    0xc(%ebp),%edx
 643:	8b 45 f0             	mov    -0x10(%ebp),%eax
 646:	01 d0                	add    %edx,%eax
 648:	8a 00                	mov    (%eax),%al
 64a:	84 c0                	test   %al,%al
 64c:	0f 85 76 fe ff ff    	jne    4c8 <printf+0x22>
    }
  }
}
 652:	c9                   	leave  
 653:	c3                   	ret    

00000654 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	83 e8 08             	sub    $0x8,%eax
 660:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 663:	a1 fc 0a 00 00       	mov    0xafc,%eax
 668:	89 45 fc             	mov    %eax,-0x4(%ebp)
 66b:	eb 24                	jmp    691 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 675:	77 12                	ja     689 <free+0x35>
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67d:	77 24                	ja     6a3 <free+0x4f>
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 687:	77 1a                	ja     6a3 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 697:	76 d4                	jbe    66d <free+0x19>
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a1:	76 ca                	jbe    66d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	8b 40 04             	mov    0x4(%eax),%eax
 6a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b3:	01 c2                	add    %eax,%edx
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	8b 00                	mov    (%eax),%eax
 6ba:	39 c2                	cmp    %eax,%edx
 6bc:	75 24                	jne    6e2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	8b 50 04             	mov    0x4(%eax),%edx
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	8b 40 04             	mov    0x4(%eax),%eax
 6cc:	01 c2                	add    %eax,%edx
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	8b 00                	mov    (%eax),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
 6e0:	eb 0a                	jmp    6ec <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e5:	8b 10                	mov    (%eax),%edx
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ea:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ef:	8b 40 04             	mov    0x4(%eax),%eax
 6f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	01 d0                	add    %edx,%eax
 6fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 701:	75 20                	jne    723 <free+0xcf>
    p->s.size += bp->s.size;
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 50 04             	mov    0x4(%eax),%edx
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	8b 40 04             	mov    0x4(%eax),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	8b 10                	mov    (%eax),%edx
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	89 10                	mov    %edx,(%eax)
 721:	eb 08                	jmp    72b <free+0xd7>
  } else
    p->s.ptr = bp;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 55 f8             	mov    -0x8(%ebp),%edx
 729:	89 10                	mov    %edx,(%eax)
  freep = p;
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	a3 fc 0a 00 00       	mov    %eax,0xafc
}
 733:	c9                   	leave  
 734:	c3                   	ret    

00000735 <morecore>:

static Header*
morecore(uint nu)
{
 735:	55                   	push   %ebp
 736:	89 e5                	mov    %esp,%ebp
 738:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 73b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 742:	77 07                	ja     74b <morecore+0x16>
    nu = 4096;
 744:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	c1 e0 03             	shl    $0x3,%eax
 751:	89 04 24             	mov    %eax,(%esp)
 754:	e8 05 fc ff ff       	call   35e <sbrk>
 759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 75c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 760:	75 07                	jne    769 <morecore+0x34>
    return 0;
 762:	b8 00 00 00 00       	mov    $0x0,%eax
 767:	eb 22                	jmp    78b <morecore+0x56>
  hp = (Header*)p;
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 76f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 772:	8b 55 08             	mov    0x8(%ebp),%edx
 775:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	83 c0 08             	add    $0x8,%eax
 77e:	89 04 24             	mov    %eax,(%esp)
 781:	e8 ce fe ff ff       	call   654 <free>
  return freep;
 786:	a1 fc 0a 00 00       	mov    0xafc,%eax
}
 78b:	c9                   	leave  
 78c:	c3                   	ret    

0000078d <malloc>:

void*
malloc(uint nbytes)
{
 78d:	55                   	push   %ebp
 78e:	89 e5                	mov    %esp,%ebp
 790:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	83 c0 07             	add    $0x7,%eax
 799:	c1 e8 03             	shr    $0x3,%eax
 79c:	40                   	inc    %eax
 79d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7a0:	a1 fc 0a 00 00       	mov    0xafc,%eax
 7a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ac:	75 23                	jne    7d1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7ae:	c7 45 f0 f4 0a 00 00 	movl   $0xaf4,-0x10(%ebp)
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	a3 fc 0a 00 00       	mov    %eax,0xafc
 7bd:	a1 fc 0a 00 00       	mov    0xafc,%eax
 7c2:	a3 f4 0a 00 00       	mov    %eax,0xaf4
    base.s.size = 0;
 7c7:	c7 05 f8 0a 00 00 00 	movl   $0x0,0xaf8
 7ce:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dc:	8b 40 04             	mov    0x4(%eax),%eax
 7df:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7e2:	72 4d                	jb     831 <malloc+0xa4>
      if(p->s.size == nunits)
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	8b 40 04             	mov    0x4(%eax),%eax
 7ea:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ed:	75 0c                	jne    7fb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	8b 10                	mov    (%eax),%edx
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	89 10                	mov    %edx,(%eax)
 7f9:	eb 26                	jmp    821 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fe:	8b 40 04             	mov    0x4(%eax),%eax
 801:	89 c2                	mov    %eax,%edx
 803:	2b 55 ec             	sub    -0x14(%ebp),%edx
 806:	8b 45 f4             	mov    -0xc(%ebp),%eax
 809:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	c1 e0 03             	shl    $0x3,%eax
 815:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 81e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 821:	8b 45 f0             	mov    -0x10(%ebp),%eax
 824:	a3 fc 0a 00 00       	mov    %eax,0xafc
      return (void*)(p + 1);
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	83 c0 08             	add    $0x8,%eax
 82f:	eb 38                	jmp    869 <malloc+0xdc>
    }
    if(p == freep)
 831:	a1 fc 0a 00 00       	mov    0xafc,%eax
 836:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 839:	75 1b                	jne    856 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 83b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83e:	89 04 24             	mov    %eax,(%esp)
 841:	e8 ef fe ff ff       	call   735 <morecore>
 846:	89 45 f4             	mov    %eax,-0xc(%ebp)
 849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 84d:	75 07                	jne    856 <malloc+0xc9>
        return 0;
 84f:	b8 00 00 00 00       	mov    $0x0,%eax
 854:	eb 13                	jmp    869 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 856:	8b 45 f4             	mov    -0xc(%ebp),%eax
 859:	89 45 f0             	mov    %eax,-0x10(%ebp)
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 00                	mov    (%eax),%eax
 861:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 864:	e9 70 ff ff ff       	jmp    7d9 <malloc+0x4c>
}
 869:	c9                   	leave  
 86a:	c3                   	ret    
