
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
   f:	c7 44 24 04 23 08 00 	movl   $0x823,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 3b 04 00 00       	call   45e <printf>
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
  74:	c7 44 24 04 3e 08 00 	movl   $0x83e,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  83:	e8 d6 03 00 00       	call   45e <printf>

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

00000386 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	83 ec 28             	sub    $0x28,%esp
 38c:	8b 45 0c             	mov    0xc(%ebp),%eax
 38f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 392:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 399:	00 
 39a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39d:	89 44 24 04          	mov    %eax,0x4(%esp)
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	89 04 24             	mov    %eax,(%esp)
 3a7:	e8 4a ff ff ff       	call   2f6 <write>
}
 3ac:	c9                   	leave  
 3ad:	c3                   	ret    

000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
 3b1:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bf:	74 17                	je     3d8 <printint+0x2a>
 3c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c5:	79 11                	jns    3d8 <printint+0x2a>
    neg = 1;
 3c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	f7 d8                	neg    %eax
 3d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d6:	eb 06                	jmp    3de <printint+0x30>
  } else {
    x = xx;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3eb:	ba 00 00 00 00       	mov    $0x0,%edx
 3f0:	f7 f1                	div    %ecx
 3f2:	89 d0                	mov    %edx,%eax
 3f4:	8a 80 98 0a 00 00    	mov    0xa98(%eax),%al
 3fa:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 400:	01 ca                	add    %ecx,%edx
 402:	88 02                	mov    %al,(%edx)
 404:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 407:	8b 55 10             	mov    0x10(%ebp),%edx
 40a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 40d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 410:	ba 00 00 00 00       	mov    $0x0,%edx
 415:	f7 75 d4             	divl   -0x2c(%ebp)
 418:	89 45 ec             	mov    %eax,-0x14(%ebp)
 41b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41f:	75 c4                	jne    3e5 <printint+0x37>
  if(neg)
 421:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 425:	74 2c                	je     453 <printint+0xa5>
    buf[i++] = '-';
 427:	8d 55 dc             	lea    -0x24(%ebp),%edx
 42a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42d:	01 d0                	add    %edx,%eax
 42f:	c6 00 2d             	movb   $0x2d,(%eax)
 432:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 435:	eb 1c                	jmp    453 <printint+0xa5>
    putc(fd, buf[i]);
 437:	8d 55 dc             	lea    -0x24(%ebp),%edx
 43a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43d:	01 d0                	add    %edx,%eax
 43f:	8a 00                	mov    (%eax),%al
 441:	0f be c0             	movsbl %al,%eax
 444:	89 44 24 04          	mov    %eax,0x4(%esp)
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	89 04 24             	mov    %eax,(%esp)
 44e:	e8 33 ff ff ff       	call   386 <putc>
  while(--i >= 0)
 453:	ff 4d f4             	decl   -0xc(%ebp)
 456:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 45a:	79 db                	jns    437 <printint+0x89>
}
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 464:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46b:	8d 45 0c             	lea    0xc(%ebp),%eax
 46e:	83 c0 04             	add    $0x4,%eax
 471:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 474:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47b:	e9 78 01 00 00       	jmp    5f8 <printf+0x19a>
    c = fmt[i] & 0xff;
 480:	8b 55 0c             	mov    0xc(%ebp),%edx
 483:	8b 45 f0             	mov    -0x10(%ebp),%eax
 486:	01 d0                	add    %edx,%eax
 488:	8a 00                	mov    (%eax),%al
 48a:	0f be c0             	movsbl %al,%eax
 48d:	25 ff 00 00 00       	and    $0xff,%eax
 492:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 495:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 499:	75 2c                	jne    4c7 <printf+0x69>
      if(c == '%'){
 49b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49f:	75 0c                	jne    4ad <printf+0x4f>
        state = '%';
 4a1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a8:	e9 48 01 00 00       	jmp    5f5 <printf+0x197>
      } else {
        putc(fd, c);
 4ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b0:	0f be c0             	movsbl %al,%eax
 4b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	89 04 24             	mov    %eax,(%esp)
 4bd:	e8 c4 fe ff ff       	call   386 <putc>
 4c2:	e9 2e 01 00 00       	jmp    5f5 <printf+0x197>
      }
    } else if(state == '%'){
 4c7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cb:	0f 85 24 01 00 00    	jne    5f5 <printf+0x197>
      if(c == 'd'){
 4d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d5:	75 2d                	jne    504 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4da:	8b 00                	mov    (%eax),%eax
 4dc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4e3:	00 
 4e4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4eb:	00 
 4ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	89 04 24             	mov    %eax,(%esp)
 4f6:	e8 b3 fe ff ff       	call   3ae <printint>
        ap++;
 4fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ff:	e9 ea 00 00 00       	jmp    5ee <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 504:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 508:	74 06                	je     510 <printf+0xb2>
 50a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 50e:	75 2d                	jne    53d <printf+0xdf>
        printint(fd, *ap, 16, 0);
 510:	8b 45 e8             	mov    -0x18(%ebp),%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 51c:	00 
 51d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 524:	00 
 525:	89 44 24 04          	mov    %eax,0x4(%esp)
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	89 04 24             	mov    %eax,(%esp)
 52f:	e8 7a fe ff ff       	call   3ae <printint>
        ap++;
 534:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 538:	e9 b1 00 00 00       	jmp    5ee <printf+0x190>
      } else if(c == 's'){
 53d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 541:	75 43                	jne    586 <printf+0x128>
        s = (char*)*ap;
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 54b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 54f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 553:	75 25                	jne    57a <printf+0x11c>
          s = "(null)";
 555:	c7 45 f4 52 08 00 00 	movl   $0x852,-0xc(%ebp)
        while(*s != 0){
 55c:	eb 1c                	jmp    57a <printf+0x11c>
          putc(fd, *s);
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	8a 00                	mov    (%eax),%al
 563:	0f be c0             	movsbl %al,%eax
 566:	89 44 24 04          	mov    %eax,0x4(%esp)
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	89 04 24             	mov    %eax,(%esp)
 570:	e8 11 fe ff ff       	call   386 <putc>
          s++;
 575:	ff 45 f4             	incl   -0xc(%ebp)
 578:	eb 01                	jmp    57b <printf+0x11d>
        while(*s != 0){
 57a:	90                   	nop
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	8a 00                	mov    (%eax),%al
 580:	84 c0                	test   %al,%al
 582:	75 da                	jne    55e <printf+0x100>
 584:	eb 68                	jmp    5ee <printf+0x190>
        }
      } else if(c == 'c'){
 586:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 58a:	75 1d                	jne    5a9 <printf+0x14b>
        putc(fd, *ap);
 58c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 58f:	8b 00                	mov    (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	89 44 24 04          	mov    %eax,0x4(%esp)
 598:	8b 45 08             	mov    0x8(%ebp),%eax
 59b:	89 04 24             	mov    %eax,(%esp)
 59e:	e8 e3 fd ff ff       	call   386 <putc>
        ap++;
 5a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5a7:	eb 45                	jmp    5ee <printf+0x190>
      } else if(c == '%'){
 5a9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ad:	75 17                	jne    5c6 <printf+0x168>
        putc(fd, c);
 5af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	89 04 24             	mov    %eax,(%esp)
 5bf:	e8 c2 fd ff ff       	call   386 <putc>
 5c4:	eb 28                	jmp    5ee <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c6:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5cd:	00 
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	89 04 24             	mov    %eax,(%esp)
 5d4:	e8 ad fd ff ff       	call   386 <putc>
        putc(fd, c);
 5d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 98 fd ff ff       	call   386 <putc>
      }
      state = 0;
 5ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5f5:	ff 45 f0             	incl   -0x10(%ebp)
 5f8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5fe:	01 d0                	add    %edx,%eax
 600:	8a 00                	mov    (%eax),%al
 602:	84 c0                	test   %al,%al
 604:	0f 85 76 fe ff ff    	jne    480 <printf+0x22>
    }
  }
}
 60a:	c9                   	leave  
 60b:	c3                   	ret    

0000060c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 60c:	55                   	push   %ebp
 60d:	89 e5                	mov    %esp,%ebp
 60f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 612:	8b 45 08             	mov    0x8(%ebp),%eax
 615:	83 e8 08             	sub    $0x8,%eax
 618:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61b:	a1 b4 0a 00 00       	mov    0xab4,%eax
 620:	89 45 fc             	mov    %eax,-0x4(%ebp)
 623:	eb 24                	jmp    649 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	77 12                	ja     641 <free+0x35>
 62f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 632:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 635:	77 24                	ja     65b <free+0x4f>
 637:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63a:	8b 00                	mov    (%eax),%eax
 63c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 63f:	77 1a                	ja     65b <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	8b 45 fc             	mov    -0x4(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	89 45 fc             	mov    %eax,-0x4(%ebp)
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 64f:	76 d4                	jbe    625 <free+0x19>
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 00                	mov    (%eax),%eax
 656:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 659:	76 ca                	jbe    625 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	8b 40 04             	mov    0x4(%eax),%eax
 661:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 668:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66b:	01 c2                	add    %eax,%edx
 66d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 670:	8b 00                	mov    (%eax),%eax
 672:	39 c2                	cmp    %eax,%edx
 674:	75 24                	jne    69a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 676:	8b 45 f8             	mov    -0x8(%ebp),%eax
 679:	8b 50 04             	mov    0x4(%eax),%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	8b 40 04             	mov    0x4(%eax),%eax
 684:	01 c2                	add    %eax,%edx
 686:	8b 45 f8             	mov    -0x8(%ebp),%eax
 689:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 68c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	8b 10                	mov    (%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	89 10                	mov    %edx,(%eax)
 698:	eb 0a                	jmp    6a4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 69a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69d:	8b 10                	mov    (%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a7:	8b 40 04             	mov    0x4(%eax),%eax
 6aa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b4:	01 d0                	add    %edx,%eax
 6b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b9:	75 20                	jne    6db <free+0xcf>
    p->s.size += bp->s.size;
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 50 04             	mov    0x4(%eax),%edx
 6c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c4:	8b 40 04             	mov    0x4(%eax),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	8b 10                	mov    (%eax),%edx
 6d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d7:	89 10                	mov    %edx,(%eax)
 6d9:	eb 08                	jmp    6e3 <free+0xd7>
  } else
    p->s.ptr = bp;
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6e1:	89 10                	mov    %edx,(%eax)
  freep = p;
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	a3 b4 0a 00 00       	mov    %eax,0xab4
}
 6eb:	c9                   	leave  
 6ec:	c3                   	ret    

000006ed <morecore>:

static Header*
morecore(uint nu)
{
 6ed:	55                   	push   %ebp
 6ee:	89 e5                	mov    %esp,%ebp
 6f0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6f3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6fa:	77 07                	ja     703 <morecore+0x16>
    nu = 4096;
 6fc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	c1 e0 03             	shl    $0x3,%eax
 709:	89 04 24             	mov    %eax,(%esp)
 70c:	e8 4d fc ff ff       	call   35e <sbrk>
 711:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 714:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 718:	75 07                	jne    721 <morecore+0x34>
    return 0;
 71a:	b8 00 00 00 00       	mov    $0x0,%eax
 71f:	eb 22                	jmp    743 <morecore+0x56>
  hp = (Header*)p;
 721:	8b 45 f4             	mov    -0xc(%ebp),%eax
 724:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 727:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72a:	8b 55 08             	mov    0x8(%ebp),%edx
 72d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	83 c0 08             	add    $0x8,%eax
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 ce fe ff ff       	call   60c <free>
  return freep;
 73e:	a1 b4 0a 00 00       	mov    0xab4,%eax
}
 743:	c9                   	leave  
 744:	c3                   	ret    

00000745 <malloc>:

void*
malloc(uint nbytes)
{
 745:	55                   	push   %ebp
 746:	89 e5                	mov    %esp,%ebp
 748:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	83 c0 07             	add    $0x7,%eax
 751:	c1 e8 03             	shr    $0x3,%eax
 754:	40                   	inc    %eax
 755:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 758:	a1 b4 0a 00 00       	mov    0xab4,%eax
 75d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 760:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 764:	75 23                	jne    789 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 766:	c7 45 f0 ac 0a 00 00 	movl   $0xaac,-0x10(%ebp)
 76d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 770:	a3 b4 0a 00 00       	mov    %eax,0xab4
 775:	a1 b4 0a 00 00       	mov    0xab4,%eax
 77a:	a3 ac 0a 00 00       	mov    %eax,0xaac
    base.s.size = 0;
 77f:	c7 05 b0 0a 00 00 00 	movl   $0x0,0xab0
 786:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 789:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	8b 40 04             	mov    0x4(%eax),%eax
 797:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 79a:	72 4d                	jb     7e9 <malloc+0xa4>
      if(p->s.size == nunits)
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7a5:	75 0c                	jne    7b3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	89 10                	mov    %edx,(%eax)
 7b1:	eb 26                	jmp    7d9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	8b 40 04             	mov    0x4(%eax),%eax
 7b9:	89 c2                	mov    %eax,%edx
 7bb:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	8b 40 04             	mov    0x4(%eax),%eax
 7ca:	c1 e0 03             	shl    $0x3,%eax
 7cd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7dc:	a3 b4 0a 00 00       	mov    %eax,0xab4
      return (void*)(p + 1);
 7e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e4:	83 c0 08             	add    $0x8,%eax
 7e7:	eb 38                	jmp    821 <malloc+0xdc>
    }
    if(p == freep)
 7e9:	a1 b4 0a 00 00       	mov    0xab4,%eax
 7ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7f1:	75 1b                	jne    80e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 ef fe ff ff       	call   6ed <morecore>
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 805:	75 07                	jne    80e <malloc+0xc9>
        return 0;
 807:	b8 00 00 00 00       	mov    $0x0,%eax
 80c:	eb 13                	jmp    821 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	89 45 f0             	mov    %eax,-0x10(%ebp)
 814:	8b 45 f4             	mov    -0xc(%ebp),%eax
 817:	8b 00                	mov    (%eax),%eax
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 81c:	e9 70 ff ff ff       	jmp    791 <malloc+0x4c>
}
 821:	c9                   	leave  
 822:	c3                   	ret    
