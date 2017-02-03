
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
  1a:	c7 44 24 04 d9 07 00 	movl   $0x7d9,0x4(%esp)
  21:	00 
  22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  29:	e8 e6 03 00 00       	call   414 <printf>
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

0000032c <procstat>:
 32c:	b8 18 00 00 00       	mov    $0x18,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <set_priority>:
 334:	b8 19 00 00 00       	mov    $0x19,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 33c:	55                   	push   %ebp
 33d:	89 e5                	mov    %esp,%ebp
 33f:	83 ec 28             	sub    $0x28,%esp
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 348:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 34f:	00 
 350:	8d 45 f4             	lea    -0xc(%ebp),%eax
 353:	89 44 24 04          	mov    %eax,0x4(%esp)
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	89 04 24             	mov    %eax,(%esp)
 35d:	e8 3a ff ff ff       	call   29c <write>
}
 362:	c9                   	leave  
 363:	c3                   	ret    

00000364 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 36a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 371:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 375:	74 17                	je     38e <printint+0x2a>
 377:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 37b:	79 11                	jns    38e <printint+0x2a>
    neg = 1;
 37d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	f7 d8                	neg    %eax
 389:	89 45 ec             	mov    %eax,-0x14(%ebp)
 38c:	eb 06                	jmp    394 <printint+0x30>
  } else {
    x = xx;
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 394:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 39b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a1:	ba 00 00 00 00       	mov    $0x0,%edx
 3a6:	f7 f1                	div    %ecx
 3a8:	89 d0                	mov    %edx,%eax
 3aa:	8a 80 2c 0a 00 00    	mov    0xa2c(%eax),%al
 3b0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3b6:	01 ca                	add    %ecx,%edx
 3b8:	88 02                	mov    %al,(%edx)
 3ba:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3bd:	8b 55 10             	mov    0x10(%ebp),%edx
 3c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c6:	ba 00 00 00 00       	mov    $0x0,%edx
 3cb:	f7 75 d4             	divl   -0x2c(%ebp)
 3ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3d5:	75 c4                	jne    39b <printint+0x37>
  if(neg)
 3d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3db:	74 2c                	je     409 <printint+0xa5>
    buf[i++] = '-';
 3dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	c6 00 2d             	movb   $0x2d,(%eax)
 3e8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 3eb:	eb 1c                	jmp    409 <printint+0xa5>
    putc(fd, buf[i]);
 3ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f3:	01 d0                	add    %edx,%eax
 3f5:	8a 00                	mov    (%eax),%al
 3f7:	0f be c0             	movsbl %al,%eax
 3fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	89 04 24             	mov    %eax,(%esp)
 404:	e8 33 ff ff ff       	call   33c <putc>
  while(--i >= 0)
 409:	ff 4d f4             	decl   -0xc(%ebp)
 40c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 410:	79 db                	jns    3ed <printint+0x89>
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 41a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 421:	8d 45 0c             	lea    0xc(%ebp),%eax
 424:	83 c0 04             	add    $0x4,%eax
 427:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 42a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 431:	e9 78 01 00 00       	jmp    5ae <printf+0x19a>
    c = fmt[i] & 0xff;
 436:	8b 55 0c             	mov    0xc(%ebp),%edx
 439:	8b 45 f0             	mov    -0x10(%ebp),%eax
 43c:	01 d0                	add    %edx,%eax
 43e:	8a 00                	mov    (%eax),%al
 440:	0f be c0             	movsbl %al,%eax
 443:	25 ff 00 00 00       	and    $0xff,%eax
 448:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 44b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44f:	75 2c                	jne    47d <printf+0x69>
      if(c == '%'){
 451:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 455:	75 0c                	jne    463 <printf+0x4f>
        state = '%';
 457:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 45e:	e9 48 01 00 00       	jmp    5ab <printf+0x197>
      } else {
        putc(fd, c);
 463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 466:	0f be c0             	movsbl %al,%eax
 469:	89 44 24 04          	mov    %eax,0x4(%esp)
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	89 04 24             	mov    %eax,(%esp)
 473:	e8 c4 fe ff ff       	call   33c <putc>
 478:	e9 2e 01 00 00       	jmp    5ab <printf+0x197>
      }
    } else if(state == '%'){
 47d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 481:	0f 85 24 01 00 00    	jne    5ab <printf+0x197>
      if(c == 'd'){
 487:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 48b:	75 2d                	jne    4ba <printf+0xa6>
        printint(fd, *ap, 10, 1);
 48d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 490:	8b 00                	mov    (%eax),%eax
 492:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 499:	00 
 49a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4a1:	00 
 4a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a6:	8b 45 08             	mov    0x8(%ebp),%eax
 4a9:	89 04 24             	mov    %eax,(%esp)
 4ac:	e8 b3 fe ff ff       	call   364 <printint>
        ap++;
 4b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b5:	e9 ea 00 00 00       	jmp    5a4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4ba:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4be:	74 06                	je     4c6 <printf+0xb2>
 4c0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4c4:	75 2d                	jne    4f3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c9:	8b 00                	mov    (%eax),%eax
 4cb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4d2:	00 
 4d3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4da:	00 
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 7a fe ff ff       	call   364 <printint>
        ap++;
 4ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ee:	e9 b1 00 00 00       	jmp    5a4 <printf+0x190>
      } else if(c == 's'){
 4f3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f7:	75 43                	jne    53c <printf+0x128>
        s = (char*)*ap;
 4f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fc:	8b 00                	mov    (%eax),%eax
 4fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 501:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 509:	75 25                	jne    530 <printf+0x11c>
          s = "(null)";
 50b:	c7 45 f4 e6 07 00 00 	movl   $0x7e6,-0xc(%ebp)
        while(*s != 0){
 512:	eb 1c                	jmp    530 <printf+0x11c>
          putc(fd, *s);
 514:	8b 45 f4             	mov    -0xc(%ebp),%eax
 517:	8a 00                	mov    (%eax),%al
 519:	0f be c0             	movsbl %al,%eax
 51c:	89 44 24 04          	mov    %eax,0x4(%esp)
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	89 04 24             	mov    %eax,(%esp)
 526:	e8 11 fe ff ff       	call   33c <putc>
          s++;
 52b:	ff 45 f4             	incl   -0xc(%ebp)
 52e:	eb 01                	jmp    531 <printf+0x11d>
        while(*s != 0){
 530:	90                   	nop
 531:	8b 45 f4             	mov    -0xc(%ebp),%eax
 534:	8a 00                	mov    (%eax),%al
 536:	84 c0                	test   %al,%al
 538:	75 da                	jne    514 <printf+0x100>
 53a:	eb 68                	jmp    5a4 <printf+0x190>
        }
      } else if(c == 'c'){
 53c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 540:	75 1d                	jne    55f <printf+0x14b>
        putc(fd, *ap);
 542:	8b 45 e8             	mov    -0x18(%ebp),%eax
 545:	8b 00                	mov    (%eax),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	89 44 24 04          	mov    %eax,0x4(%esp)
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 04 24             	mov    %eax,(%esp)
 554:	e8 e3 fd ff ff       	call   33c <putc>
        ap++;
 559:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55d:	eb 45                	jmp    5a4 <printf+0x190>
      } else if(c == '%'){
 55f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 563:	75 17                	jne    57c <printf+0x168>
        putc(fd, c);
 565:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 568:	0f be c0             	movsbl %al,%eax
 56b:	89 44 24 04          	mov    %eax,0x4(%esp)
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	89 04 24             	mov    %eax,(%esp)
 575:	e8 c2 fd ff ff       	call   33c <putc>
 57a:	eb 28                	jmp    5a4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 583:	00 
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 04 24             	mov    %eax,(%esp)
 58a:	e8 ad fd ff ff       	call   33c <putc>
        putc(fd, c);
 58f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 592:	0f be c0             	movsbl %al,%eax
 595:	89 44 24 04          	mov    %eax,0x4(%esp)
 599:	8b 45 08             	mov    0x8(%ebp),%eax
 59c:	89 04 24             	mov    %eax,(%esp)
 59f:	e8 98 fd ff ff       	call   33c <putc>
      }
      state = 0;
 5a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5ab:	ff 45 f0             	incl   -0x10(%ebp)
 5ae:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b4:	01 d0                	add    %edx,%eax
 5b6:	8a 00                	mov    (%eax),%al
 5b8:	84 c0                	test   %al,%al
 5ba:	0f 85 76 fe ff ff    	jne    436 <printf+0x22>
    }
  }
}
 5c0:	c9                   	leave  
 5c1:	c3                   	ret    

000005c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	83 e8 08             	sub    $0x8,%eax
 5ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d1:	a1 48 0a 00 00       	mov    0xa48,%eax
 5d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d9:	eb 24                	jmp    5ff <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5de:	8b 00                	mov    (%eax),%eax
 5e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e3:	77 12                	ja     5f7 <free+0x35>
 5e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5eb:	77 24                	ja     611 <free+0x4f>
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f5:	77 1a                	ja     611 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 602:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 605:	76 d4                	jbe    5db <free+0x19>
 607:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60f:	76 ca                	jbe    5db <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 611:	8b 45 f8             	mov    -0x8(%ebp),%eax
 614:	8b 40 04             	mov    0x4(%eax),%eax
 617:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	01 c2                	add    %eax,%edx
 623:	8b 45 fc             	mov    -0x4(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	39 c2                	cmp    %eax,%edx
 62a:	75 24                	jne    650 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 62c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62f:	8b 50 04             	mov    0x4(%eax),%edx
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 00                	mov    (%eax),%eax
 637:	8b 40 04             	mov    0x4(%eax),%eax
 63a:	01 c2                	add    %eax,%edx
 63c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 642:	8b 45 fc             	mov    -0x4(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	8b 10                	mov    (%eax),%edx
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	89 10                	mov    %edx,(%eax)
 64e:	eb 0a                	jmp    65a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 650:	8b 45 fc             	mov    -0x4(%ebp),%eax
 653:	8b 10                	mov    (%eax),%edx
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 667:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66a:	01 d0                	add    %edx,%eax
 66c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66f:	75 20                	jne    691 <free+0xcf>
    p->s.size += bp->s.size;
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 50 04             	mov    0x4(%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	8b 40 04             	mov    0x4(%eax),%eax
 67d:	01 c2                	add    %eax,%edx
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 685:	8b 45 f8             	mov    -0x8(%ebp),%eax
 688:	8b 10                	mov    (%eax),%edx
 68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68d:	89 10                	mov    %edx,(%eax)
 68f:	eb 08                	jmp    699 <free+0xd7>
  } else
    p->s.ptr = bp;
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 55 f8             	mov    -0x8(%ebp),%edx
 697:	89 10                	mov    %edx,(%eax)
  freep = p;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	a3 48 0a 00 00       	mov    %eax,0xa48
}
 6a1:	c9                   	leave  
 6a2:	c3                   	ret    

000006a3 <morecore>:

static Header*
morecore(uint nu)
{
 6a3:	55                   	push   %ebp
 6a4:	89 e5                	mov    %esp,%ebp
 6a6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6b0:	77 07                	ja     6b9 <morecore+0x16>
    nu = 4096;
 6b2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
 6bc:	c1 e0 03             	shl    $0x3,%eax
 6bf:	89 04 24             	mov    %eax,(%esp)
 6c2:	e8 3d fc ff ff       	call   304 <sbrk>
 6c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ca:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ce:	75 07                	jne    6d7 <morecore+0x34>
    return 0;
 6d0:	b8 00 00 00 00       	mov    $0x0,%eax
 6d5:	eb 22                	jmp    6f9 <morecore+0x56>
  hp = (Header*)p;
 6d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e0:	8b 55 08             	mov    0x8(%ebp),%edx
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e9:	83 c0 08             	add    $0x8,%eax
 6ec:	89 04 24             	mov    %eax,(%esp)
 6ef:	e8 ce fe ff ff       	call   5c2 <free>
  return freep;
 6f4:	a1 48 0a 00 00       	mov    0xa48,%eax
}
 6f9:	c9                   	leave  
 6fa:	c3                   	ret    

000006fb <malloc>:

void*
malloc(uint nbytes)
{
 6fb:	55                   	push   %ebp
 6fc:	89 e5                	mov    %esp,%ebp
 6fe:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 701:	8b 45 08             	mov    0x8(%ebp),%eax
 704:	83 c0 07             	add    $0x7,%eax
 707:	c1 e8 03             	shr    $0x3,%eax
 70a:	40                   	inc    %eax
 70b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 70e:	a1 48 0a 00 00       	mov    0xa48,%eax
 713:	89 45 f0             	mov    %eax,-0x10(%ebp)
 716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71a:	75 23                	jne    73f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 71c:	c7 45 f0 40 0a 00 00 	movl   $0xa40,-0x10(%ebp)
 723:	8b 45 f0             	mov    -0x10(%ebp),%eax
 726:	a3 48 0a 00 00       	mov    %eax,0xa48
 72b:	a1 48 0a 00 00       	mov    0xa48,%eax
 730:	a3 40 0a 00 00       	mov    %eax,0xa40
    base.s.size = 0;
 735:	c7 05 44 0a 00 00 00 	movl   $0x0,0xa44
 73c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	8b 00                	mov    (%eax),%eax
 744:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 750:	72 4d                	jb     79f <malloc+0xa4>
      if(p->s.size == nunits)
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 75b:	75 0c                	jne    769 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 10                	mov    (%eax),%edx
 762:	8b 45 f0             	mov    -0x10(%ebp),%eax
 765:	89 10                	mov    %edx,(%eax)
 767:	eb 26                	jmp    78f <malloc+0x94>
      else {
        p->s.size -= nunits;
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8b 40 04             	mov    0x4(%eax),%eax
 76f:	89 c2                	mov    %eax,%edx
 771:	2b 55 ec             	sub    -0x14(%ebp),%edx
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 77a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	c1 e0 03             	shl    $0x3,%eax
 783:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 786:	8b 45 f4             	mov    -0xc(%ebp),%eax
 789:	8b 55 ec             	mov    -0x14(%ebp),%edx
 78c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	a3 48 0a 00 00       	mov    %eax,0xa48
      return (void*)(p + 1);
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	83 c0 08             	add    $0x8,%eax
 79d:	eb 38                	jmp    7d7 <malloc+0xdc>
    }
    if(p == freep)
 79f:	a1 48 0a 00 00       	mov    0xa48,%eax
 7a4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7a7:	75 1b                	jne    7c4 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 ef fe ff ff       	call   6a3 <morecore>
 7b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7bb:	75 07                	jne    7c4 <malloc+0xc9>
        return 0;
 7bd:	b8 00 00 00 00       	mov    $0x0,%eax
 7c2:	eb 13                	jmp    7d7 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	8b 00                	mov    (%eax),%eax
 7cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 7d2:	e9 70 ff ff ff       	jmp    747 <malloc+0x4c>
}
 7d7:	c9                   	leave  
 7d8:	c3                   	ret    
