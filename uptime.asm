
_uptime:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int main (int argc, char *argv[]){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
	int ut;
	ut = uptime();
   9:	e8 06 03 00 00       	call   314 <uptime>
   e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	printf(1, "up %d ticks\n", ut);
  12:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  16:	89 44 24 08          	mov    %eax,0x8(%esp)
  1a:	c7 44 24 04 c9 07 00 	movl   $0x7c9,0x4(%esp)
  21:	00 
  22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  29:	e8 d6 03 00 00       	call   404 <printf>
	exit();
  2e:	e8 49 02 00 00       	call   27c <exit>

00000033 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	57                   	push   %edi
  37:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3b:	8b 55 10             	mov    0x10(%ebp),%edx
  3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  41:	89 cb                	mov    %ecx,%ebx
  43:	89 df                	mov    %ebx,%edi
  45:	89 d1                	mov    %edx,%ecx
  47:	fc                   	cld    
  48:	f3 aa                	rep stos %al,%es:(%edi)
  4a:	89 ca                	mov    %ecx,%edx
  4c:	89 fb                	mov    %edi,%ebx
  4e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  51:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  54:	5b                   	pop    %ebx
  55:	5f                   	pop    %edi
  56:	5d                   	pop    %ebp
  57:	c3                   	ret    

00000058 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  64:	90                   	nop
  65:	8b 45 0c             	mov    0xc(%ebp),%eax
  68:	8a 10                	mov    (%eax),%dl
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	88 10                	mov    %dl,(%eax)
  6f:	8b 45 08             	mov    0x8(%ebp),%eax
  72:	8a 00                	mov    (%eax),%al
  74:	84 c0                	test   %al,%al
  76:	0f 95 c0             	setne  %al
  79:	ff 45 08             	incl   0x8(%ebp)
  7c:	ff 45 0c             	incl   0xc(%ebp)
  7f:	84 c0                	test   %al,%al
  81:	75 e2                	jne    65 <strcpy+0xd>
    ;
  return os;
  83:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  86:	c9                   	leave  
  87:	c3                   	ret    

00000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	55                   	push   %ebp
  89:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  8b:	eb 06                	jmp    93 <strcmp+0xb>
    p++, q++;
  8d:	ff 45 08             	incl   0x8(%ebp)
  90:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	8a 00                	mov    (%eax),%al
  98:	84 c0                	test   %al,%al
  9a:	74 0e                	je     aa <strcmp+0x22>
  9c:	8b 45 08             	mov    0x8(%ebp),%eax
  9f:	8a 10                	mov    (%eax),%dl
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	8a 00                	mov    (%eax),%al
  a6:	38 c2                	cmp    %al,%dl
  a8:	74 e3                	je     8d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  aa:	8b 45 08             	mov    0x8(%ebp),%eax
  ad:	8a 00                	mov    (%eax),%al
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	8a 00                	mov    (%eax),%al
  b7:	0f b6 c0             	movzbl %al,%eax
  ba:	89 d1                	mov    %edx,%ecx
  bc:	29 c1                	sub    %eax,%ecx
  be:	89 c8                	mov    %ecx,%eax
}
  c0:	5d                   	pop    %ebp
  c1:	c3                   	ret    

000000c2 <strlen>:

uint
strlen(char *s)
{
  c2:	55                   	push   %ebp
  c3:	89 e5                	mov    %esp,%ebp
  c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cf:	eb 03                	jmp    d4 <strlen+0x12>
  d1:	ff 45 fc             	incl   -0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	8a 00                	mov    (%eax),%al
  de:	84 c0                	test   %al,%al
  e0:	75 ef                	jne    d1 <strlen+0xf>
    ;
  return n;
  e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  ea:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  ed:	8b 45 10             	mov    0x10(%ebp),%eax
  f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 2d ff ff ff       	call   33 <stosb>
  return dst;
 106:	8b 45 08             	mov    0x8(%ebp),%eax
}
 109:	c9                   	leave  
 10a:	c3                   	ret    

0000010b <strchr>:

char*
strchr(const char *s, char c)
{
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	83 ec 04             	sub    $0x4,%esp
 111:	8b 45 0c             	mov    0xc(%ebp),%eax
 114:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 117:	eb 12                	jmp    12b <strchr+0x20>
    if(*s == c)
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	8a 00                	mov    (%eax),%al
 11e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 121:	75 05                	jne    128 <strchr+0x1d>
      return (char*)s;
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	eb 11                	jmp    139 <strchr+0x2e>
  for(; *s; s++)
 128:	ff 45 08             	incl   0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	8a 00                	mov    (%eax),%al
 130:	84 c0                	test   %al,%al
 132:	75 e5                	jne    119 <strchr+0xe>
  return 0;
 134:	b8 00 00 00 00       	mov    $0x0,%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <gets>:

char*
gets(char *buf, int max)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 148:	eb 42                	jmp    18c <gets+0x51>
    cc = read(0, &c, 1);
 14a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 151:	00 
 152:	8d 45 ef             	lea    -0x11(%ebp),%eax
 155:	89 44 24 04          	mov    %eax,0x4(%esp)
 159:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 160:	e8 2f 01 00 00       	call   294 <read>
 165:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 168:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16c:	7e 29                	jle    197 <gets+0x5c>
      break;
    buf[i++] = c;
 16e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	01 c2                	add    %eax,%edx
 176:	8a 45 ef             	mov    -0x11(%ebp),%al
 179:	88 02                	mov    %al,(%edx)
 17b:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 17e:	8a 45 ef             	mov    -0x11(%ebp),%al
 181:	3c 0a                	cmp    $0xa,%al
 183:	74 13                	je     198 <gets+0x5d>
 185:	8a 45 ef             	mov    -0x11(%ebp),%al
 188:	3c 0d                	cmp    $0xd,%al
 18a:	74 0c                	je     198 <gets+0x5d>
  for(i=0; i+1 < max; ){
 18c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18f:	40                   	inc    %eax
 190:	3b 45 0c             	cmp    0xc(%ebp),%eax
 193:	7c b5                	jl     14a <gets+0xf>
 195:	eb 01                	jmp    198 <gets+0x5d>
      break;
 197:	90                   	nop
      break;
  }
  buf[i] = '\0';
 198:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	01 d0                	add    %edx,%eax
 1a0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <stat>:

int
stat(char *n, struct stat *st)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
 1ab:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b5:	00 
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	89 04 24             	mov    %eax,(%esp)
 1bc:	e8 fb 00 00 00       	call   2bc <open>
 1c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x29>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 23                	jmp    1f4 <stat+0x4c>
  r = fstat(fd, st);
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1db:	89 04 24             	mov    %eax,(%esp)
 1de:	e8 f1 00 00 00       	call   2d4 <fstat>
 1e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e9:	89 04 24             	mov    %eax,(%esp)
 1ec:	e8 b3 00 00 00       	call   2a4 <close>
  return r;
 1f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 203:	eb 21                	jmp    226 <atoi+0x30>
    n = n*10 + *s++ - '0';
 205:	8b 55 fc             	mov    -0x4(%ebp),%edx
 208:	89 d0                	mov    %edx,%eax
 20a:	c1 e0 02             	shl    $0x2,%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	d1 e0                	shl    %eax
 211:	89 c2                	mov    %eax,%edx
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	8a 00                	mov    (%eax),%al
 218:	0f be c0             	movsbl %al,%eax
 21b:	01 d0                	add    %edx,%eax
 21d:	83 e8 30             	sub    $0x30,%eax
 220:	89 45 fc             	mov    %eax,-0x4(%ebp)
 223:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	8a 00                	mov    (%eax),%al
 22b:	3c 2f                	cmp    $0x2f,%al
 22d:	7e 09                	jle    238 <atoi+0x42>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	8a 00                	mov    (%eax),%al
 234:	3c 39                	cmp    $0x39,%al
 236:	7e cd                	jle    205 <atoi+0xf>
  return n;
 238:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23b:	c9                   	leave  
 23c:	c3                   	ret    

0000023d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
 240:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 249:	8b 45 0c             	mov    0xc(%ebp),%eax
 24c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24f:	eb 10                	jmp    261 <memmove+0x24>
    *dst++ = *src++;
 251:	8b 45 f8             	mov    -0x8(%ebp),%eax
 254:	8a 10                	mov    (%eax),%dl
 256:	8b 45 fc             	mov    -0x4(%ebp),%eax
 259:	88 10                	mov    %dl,(%eax)
 25b:	ff 45 fc             	incl   -0x4(%ebp)
 25e:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 261:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 265:	0f 9f c0             	setg   %al
 268:	ff 4d 10             	decl   0x10(%ebp)
 26b:	84 c0                	test   %al,%al
 26d:	75 e2                	jne    251 <memmove+0x14>
  return vdst;
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 272:	c9                   	leave  
 273:	c3                   	ret    

00000274 <fork>:
 274:	b8 01 00 00 00       	mov    $0x1,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <exit>:
 27c:	b8 02 00 00 00       	mov    $0x2,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <wait>:
 284:	b8 03 00 00 00       	mov    $0x3,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <pipe>:
 28c:	b8 04 00 00 00       	mov    $0x4,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <read>:
 294:	b8 05 00 00 00       	mov    $0x5,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <write>:
 29c:	b8 10 00 00 00       	mov    $0x10,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <close>:
 2a4:	b8 15 00 00 00       	mov    $0x15,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <kill>:
 2ac:	b8 06 00 00 00       	mov    $0x6,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <exec>:
 2b4:	b8 07 00 00 00       	mov    $0x7,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <open>:
 2bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <mknod>:
 2c4:	b8 11 00 00 00       	mov    $0x11,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <unlink>:
 2cc:	b8 12 00 00 00       	mov    $0x12,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <fstat>:
 2d4:	b8 08 00 00 00       	mov    $0x8,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <link>:
 2dc:	b8 13 00 00 00       	mov    $0x13,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <mkdir>:
 2e4:	b8 14 00 00 00       	mov    $0x14,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <chdir>:
 2ec:	b8 09 00 00 00       	mov    $0x9,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <dup>:
 2f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <getpid>:
 2fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <sbrk>:
 304:	b8 0c 00 00 00       	mov    $0xc,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <sleep>:
 30c:	b8 0d 00 00 00       	mov    $0xd,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <uptime>:
 314:	b8 0e 00 00 00       	mov    $0xe,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <lseek>:
 31c:	b8 16 00 00 00       	mov    $0x16,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <isatty>:
 324:	b8 17 00 00 00       	mov    $0x17,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 32c:	55                   	push   %ebp
 32d:	89 e5                	mov    %esp,%ebp
 32f:	83 ec 28             	sub    $0x28,%esp
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 338:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 33f:	00 
 340:	8d 45 f4             	lea    -0xc(%ebp),%eax
 343:	89 44 24 04          	mov    %eax,0x4(%esp)
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	89 04 24             	mov    %eax,(%esp)
 34d:	e8 4a ff ff ff       	call   29c <write>
}
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 35a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 361:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 365:	74 17                	je     37e <printint+0x2a>
 367:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 36b:	79 11                	jns    37e <printint+0x2a>
    neg = 1;
 36d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	f7 d8                	neg    %eax
 379:	89 45 ec             	mov    %eax,-0x14(%ebp)
 37c:	eb 06                	jmp    384 <printint+0x30>
  } else {
    x = xx;
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 38b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 38e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 391:	ba 00 00 00 00       	mov    $0x0,%edx
 396:	f7 f1                	div    %ecx
 398:	89 d0                	mov    %edx,%eax
 39a:	8a 80 1c 0a 00 00    	mov    0xa1c(%eax),%al
 3a0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a6:	01 ca                	add    %ecx,%edx
 3a8:	88 02                	mov    %al,(%edx)
 3aa:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3ad:	8b 55 10             	mov    0x10(%ebp),%edx
 3b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3b6:	ba 00 00 00 00       	mov    $0x0,%edx
 3bb:	f7 75 d4             	divl   -0x2c(%ebp)
 3be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3c5:	75 c4                	jne    38b <printint+0x37>
  if(neg)
 3c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3cb:	74 2c                	je     3f9 <printint+0xa5>
    buf[i++] = '-';
 3cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d3:	01 d0                	add    %edx,%eax
 3d5:	c6 00 2d             	movb   $0x2d,(%eax)
 3d8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3db:	eb 1c                	jmp    3f9 <printint+0xa5>
    putc(fd, buf[i]);
 3dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	8a 00                	mov    (%eax),%al
 3e7:	0f be c0             	movsbl %al,%eax
 3ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	89 04 24             	mov    %eax,(%esp)
 3f4:	e8 33 ff ff ff       	call   32c <putc>
  while(--i >= 0)
 3f9:	ff 4d f4             	decl   -0xc(%ebp)
 3fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 400:	79 db                	jns    3dd <printint+0x89>
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 40a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 411:	8d 45 0c             	lea    0xc(%ebp),%eax
 414:	83 c0 04             	add    $0x4,%eax
 417:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 41a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 421:	e9 78 01 00 00       	jmp    59e <printf+0x19a>
    c = fmt[i] & 0xff;
 426:	8b 55 0c             	mov    0xc(%ebp),%edx
 429:	8b 45 f0             	mov    -0x10(%ebp),%eax
 42c:	01 d0                	add    %edx,%eax
 42e:	8a 00                	mov    (%eax),%al
 430:	0f be c0             	movsbl %al,%eax
 433:	25 ff 00 00 00       	and    $0xff,%eax
 438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 43b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 43f:	75 2c                	jne    46d <printf+0x69>
      if(c == '%'){
 441:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 445:	75 0c                	jne    453 <printf+0x4f>
        state = '%';
 447:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 44e:	e9 48 01 00 00       	jmp    59b <printf+0x197>
      } else {
        putc(fd, c);
 453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 456:	0f be c0             	movsbl %al,%eax
 459:	89 44 24 04          	mov    %eax,0x4(%esp)
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	89 04 24             	mov    %eax,(%esp)
 463:	e8 c4 fe ff ff       	call   32c <putc>
 468:	e9 2e 01 00 00       	jmp    59b <printf+0x197>
      }
    } else if(state == '%'){
 46d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 471:	0f 85 24 01 00 00    	jne    59b <printf+0x197>
      if(c == 'd'){
 477:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 47b:	75 2d                	jne    4aa <printf+0xa6>
        printint(fd, *ap, 10, 1);
 47d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 480:	8b 00                	mov    (%eax),%eax
 482:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 489:	00 
 48a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 491:	00 
 492:	89 44 24 04          	mov    %eax,0x4(%esp)
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	89 04 24             	mov    %eax,(%esp)
 49c:	e8 b3 fe ff ff       	call   354 <printint>
        ap++;
 4a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4a5:	e9 ea 00 00 00       	jmp    594 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4aa:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4ae:	74 06                	je     4b6 <printf+0xb2>
 4b0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4b4:	75 2d                	jne    4e3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b9:	8b 00                	mov    (%eax),%eax
 4bb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4c2:	00 
 4c3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ca:	00 
 4cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	89 04 24             	mov    %eax,(%esp)
 4d5:	e8 7a fe ff ff       	call   354 <printint>
        ap++;
 4da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4de:	e9 b1 00 00 00       	jmp    594 <printf+0x190>
      } else if(c == 's'){
 4e3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4e7:	75 43                	jne    52c <printf+0x128>
        s = (char*)*ap;
 4e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ec:	8b 00                	mov    (%eax),%eax
 4ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	75 25                	jne    520 <printf+0x11c>
          s = "(null)";
 4fb:	c7 45 f4 d6 07 00 00 	movl   $0x7d6,-0xc(%ebp)
        while(*s != 0){
 502:	eb 1c                	jmp    520 <printf+0x11c>
          putc(fd, *s);
 504:	8b 45 f4             	mov    -0xc(%ebp),%eax
 507:	8a 00                	mov    (%eax),%al
 509:	0f be c0             	movsbl %al,%eax
 50c:	89 44 24 04          	mov    %eax,0x4(%esp)
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	89 04 24             	mov    %eax,(%esp)
 516:	e8 11 fe ff ff       	call   32c <putc>
          s++;
 51b:	ff 45 f4             	incl   -0xc(%ebp)
 51e:	eb 01                	jmp    521 <printf+0x11d>
        while(*s != 0){
 520:	90                   	nop
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	8a 00                	mov    (%eax),%al
 526:	84 c0                	test   %al,%al
 528:	75 da                	jne    504 <printf+0x100>
 52a:	eb 68                	jmp    594 <printf+0x190>
        }
      } else if(c == 'c'){
 52c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 530:	75 1d                	jne    54f <printf+0x14b>
        putc(fd, *ap);
 532:	8b 45 e8             	mov    -0x18(%ebp),%eax
 535:	8b 00                	mov    (%eax),%eax
 537:	0f be c0             	movsbl %al,%eax
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 e3 fd ff ff       	call   32c <putc>
        ap++;
 549:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 54d:	eb 45                	jmp    594 <printf+0x190>
      } else if(c == '%'){
 54f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 553:	75 17                	jne    56c <printf+0x168>
        putc(fd, c);
 555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 c2 fd ff ff       	call   32c <putc>
 56a:	eb 28                	jmp    594 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 573:	00 
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	89 04 24             	mov    %eax,(%esp)
 57a:	e8 ad fd ff ff       	call   32c <putc>
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 98 fd ff ff       	call   32c <putc>
      }
      state = 0;
 594:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 59b:	ff 45 f0             	incl   -0x10(%ebp)
 59e:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a4:	01 d0                	add    %edx,%eax
 5a6:	8a 00                	mov    (%eax),%al
 5a8:	84 c0                	test   %al,%al
 5aa:	0f 85 76 fe ff ff    	jne    426 <printf+0x22>
    }
  }
}
 5b0:	c9                   	leave  
 5b1:	c3                   	ret    

000005b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	83 e8 08             	sub    $0x8,%eax
 5be:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c1:	a1 38 0a 00 00       	mov    0xa38,%eax
 5c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c9:	eb 24                	jmp    5ef <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5d3:	77 12                	ja     5e7 <free+0x35>
 5d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5db:	77 24                	ja     601 <free+0x4f>
 5dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5e5:	77 1a                	ja     601 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f5:	76 d4                	jbe    5cb <free+0x19>
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5ff:	76 ca                	jbe    5cb <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 601:	8b 45 f8             	mov    -0x8(%ebp),%eax
 604:	8b 40 04             	mov    0x4(%eax),%eax
 607:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	01 c2                	add    %eax,%edx
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	39 c2                	cmp    %eax,%edx
 61a:	75 24                	jne    640 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 61c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61f:	8b 50 04             	mov    0x4(%eax),%edx
 622:	8b 45 fc             	mov    -0x4(%ebp),%eax
 625:	8b 00                	mov    (%eax),%eax
 627:	8b 40 04             	mov    0x4(%eax),%eax
 62a:	01 c2                	add    %eax,%edx
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	8b 10                	mov    (%eax),%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	89 10                	mov    %edx,(%eax)
 63e:	eb 0a                	jmp    64a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 640:	8b 45 fc             	mov    -0x4(%ebp),%eax
 643:	8b 10                	mov    (%eax),%edx
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	8b 40 04             	mov    0x4(%eax),%eax
 650:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 65f:	75 20                	jne    681 <free+0xcf>
    p->s.size += bp->s.size;
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 50 04             	mov    0x4(%eax),%edx
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 40 04             	mov    0x4(%eax),%eax
 66d:	01 c2                	add    %eax,%edx
 66f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 672:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 675:	8b 45 f8             	mov    -0x8(%ebp),%eax
 678:	8b 10                	mov    (%eax),%edx
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	89 10                	mov    %edx,(%eax)
 67f:	eb 08                	jmp    689 <free+0xd7>
  } else
    p->s.ptr = bp;
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 55 f8             	mov    -0x8(%ebp),%edx
 687:	89 10                	mov    %edx,(%eax)
  freep = p;
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	a3 38 0a 00 00       	mov    %eax,0xa38
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <morecore>:

static Header*
morecore(uint nu)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 699:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6a0:	77 07                	ja     6a9 <morecore+0x16>
    nu = 4096;
 6a2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	c1 e0 03             	shl    $0x3,%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 4d fc ff ff       	call   304 <sbrk>
 6b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ba:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6be:	75 07                	jne    6c7 <morecore+0x34>
    return 0;
 6c0:	b8 00 00 00 00       	mov    $0x0,%eax
 6c5:	eb 22                	jmp    6e9 <morecore+0x56>
  hp = (Header*)p;
 6c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d0:	8b 55 08             	mov    0x8(%ebp),%edx
 6d3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d9:	83 c0 08             	add    $0x8,%eax
 6dc:	89 04 24             	mov    %eax,(%esp)
 6df:	e8 ce fe ff ff       	call   5b2 <free>
  return freep;
 6e4:	a1 38 0a 00 00       	mov    0xa38,%eax
}
 6e9:	c9                   	leave  
 6ea:	c3                   	ret    

000006eb <malloc>:

void*
malloc(uint nbytes)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	83 c0 07             	add    $0x7,%eax
 6f7:	c1 e8 03             	shr    $0x3,%eax
 6fa:	40                   	inc    %eax
 6fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6fe:	a1 38 0a 00 00       	mov    0xa38,%eax
 703:	89 45 f0             	mov    %eax,-0x10(%ebp)
 706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70a:	75 23                	jne    72f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 70c:	c7 45 f0 30 0a 00 00 	movl   $0xa30,-0x10(%ebp)
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	a3 38 0a 00 00       	mov    %eax,0xa38
 71b:	a1 38 0a 00 00       	mov    0xa38,%eax
 720:	a3 30 0a 00 00       	mov    %eax,0xa30
    base.s.size = 0;
 725:	c7 05 34 0a 00 00 00 	movl   $0x0,0xa34
 72c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 740:	72 4d                	jb     78f <malloc+0xa4>
      if(p->s.size == nunits)
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	8b 40 04             	mov    0x4(%eax),%eax
 748:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 74b:	75 0c                	jne    759 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 74d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 750:	8b 10                	mov    (%eax),%edx
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	89 10                	mov    %edx,(%eax)
 757:	eb 26                	jmp    77f <malloc+0x94>
      else {
        p->s.size -= nunits;
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	89 c2                	mov    %eax,%edx
 761:	2b 55 ec             	sub    -0x14(%ebp),%edx
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 76a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76d:	8b 40 04             	mov    0x4(%eax),%eax
 770:	c1 e0 03             	shl    $0x3,%eax
 773:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 776:	8b 45 f4             	mov    -0xc(%ebp),%eax
 779:	8b 55 ec             	mov    -0x14(%ebp),%edx
 77c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 77f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 782:	a3 38 0a 00 00       	mov    %eax,0xa38
      return (void*)(p + 1);
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	83 c0 08             	add    $0x8,%eax
 78d:	eb 38                	jmp    7c7 <malloc+0xdc>
    }
    if(p == freep)
 78f:	a1 38 0a 00 00       	mov    0xa38,%eax
 794:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 797:	75 1b                	jne    7b4 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 799:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79c:	89 04 24             	mov    %eax,(%esp)
 79f:	e8 ef fe ff ff       	call   693 <morecore>
 7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ab:	75 07                	jne    7b4 <malloc+0xc9>
        return 0;
 7ad:	b8 00 00 00 00       	mov    $0x0,%eax
 7b2:	eb 13                	jmp    7c7 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bd:	8b 00                	mov    (%eax),%eax
 7bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7c2:	e9 70 ff ff ff       	jmp    737 <malloc+0x4c>
}
 7c7:	c9                   	leave  
 7c8:	c3                   	ret    
