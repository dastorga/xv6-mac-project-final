
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
  1a:	c7 44 24 04 11 08 00 	movl   $0x811,0x4(%esp)
  21:	00 
  22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  29:	e8 1e 04 00 00       	call   44c <printf>
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

0000033c <semget>:
 33c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <semfree>:
 344:	b8 1b 00 00 00       	mov    $0x1b,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <semdown>:
 34c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <semup>:
 354:	b8 1d 00 00 00       	mov    $0x1d,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <shm_create>:
 35c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <shm_close>:
 364:	b8 1f 00 00 00       	mov    $0x1f,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <shm_get>:
 36c:	b8 20 00 00 00       	mov    $0x20,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 28             	sub    $0x28,%esp
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 380:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 387:	00 
 388:	8d 45 f4             	lea    -0xc(%ebp),%eax
 38b:	89 44 24 04          	mov    %eax,0x4(%esp)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	89 04 24             	mov    %eax,(%esp)
 395:	e8 02 ff ff ff       	call   29c <write>
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3a9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ad:	74 17                	je     3c6 <printint+0x2a>
 3af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3b3:	79 11                	jns    3c6 <printint+0x2a>
    neg = 1;
 3b5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	f7 d8                	neg    %eax
 3c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3c4:	eb 06                	jmp    3cc <printint+0x30>
  } else {
    x = xx;
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d9:	ba 00 00 00 00       	mov    $0x0,%edx
 3de:	f7 f1                	div    %ecx
 3e0:	89 d0                	mov    %edx,%eax
 3e2:	8a 80 64 0a 00 00    	mov    0xa64(%eax),%al
 3e8:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 3eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3ee:	01 ca                	add    %ecx,%edx
 3f0:	88 02                	mov    %al,(%edx)
 3f2:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 3f5:	8b 55 10             	mov    0x10(%ebp),%edx
 3f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3fe:	ba 00 00 00 00       	mov    $0x0,%edx
 403:	f7 75 d4             	divl   -0x2c(%ebp)
 406:	89 45 ec             	mov    %eax,-0x14(%ebp)
 409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 40d:	75 c4                	jne    3d3 <printint+0x37>
  if(neg)
 40f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 413:	74 2c                	je     441 <printint+0xa5>
    buf[i++] = '-';
 415:	8d 55 dc             	lea    -0x24(%ebp),%edx
 418:	8b 45 f4             	mov    -0xc(%ebp),%eax
 41b:	01 d0                	add    %edx,%eax
 41d:	c6 00 2d             	movb   $0x2d,(%eax)
 420:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 423:	eb 1c                	jmp    441 <printint+0xa5>
    putc(fd, buf[i]);
 425:	8d 55 dc             	lea    -0x24(%ebp),%edx
 428:	8b 45 f4             	mov    -0xc(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	8a 00                	mov    (%eax),%al
 42f:	0f be c0             	movsbl %al,%eax
 432:	89 44 24 04          	mov    %eax,0x4(%esp)
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	89 04 24             	mov    %eax,(%esp)
 43c:	e8 33 ff ff ff       	call   374 <putc>
  while(--i >= 0)
 441:	ff 4d f4             	decl   -0xc(%ebp)
 444:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 448:	79 db                	jns    425 <printint+0x89>
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 452:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 459:	8d 45 0c             	lea    0xc(%ebp),%eax
 45c:	83 c0 04             	add    $0x4,%eax
 45f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 462:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 469:	e9 78 01 00 00       	jmp    5e6 <printf+0x19a>
    c = fmt[i] & 0xff;
 46e:	8b 55 0c             	mov    0xc(%ebp),%edx
 471:	8b 45 f0             	mov    -0x10(%ebp),%eax
 474:	01 d0                	add    %edx,%eax
 476:	8a 00                	mov    (%eax),%al
 478:	0f be c0             	movsbl %al,%eax
 47b:	25 ff 00 00 00       	and    $0xff,%eax
 480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 487:	75 2c                	jne    4b5 <printf+0x69>
      if(c == '%'){
 489:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 48d:	75 0c                	jne    49b <printf+0x4f>
        state = '%';
 48f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 496:	e9 48 01 00 00       	jmp    5e3 <printf+0x197>
      } else {
        putc(fd, c);
 49b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 49e:	0f be c0             	movsbl %al,%eax
 4a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	89 04 24             	mov    %eax,(%esp)
 4ab:	e8 c4 fe ff ff       	call   374 <putc>
 4b0:	e9 2e 01 00 00       	jmp    5e3 <printf+0x197>
      }
    } else if(state == '%'){
 4b5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4b9:	0f 85 24 01 00 00    	jne    5e3 <printf+0x197>
      if(c == 'd'){
 4bf:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4c3:	75 2d                	jne    4f2 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c8:	8b 00                	mov    (%eax),%eax
 4ca:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4d1:	00 
 4d2:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4d9:	00 
 4da:	89 44 24 04          	mov    %eax,0x4(%esp)
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
 4e1:	89 04 24             	mov    %eax,(%esp)
 4e4:	e8 b3 fe ff ff       	call   39c <printint>
        ap++;
 4e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ed:	e9 ea 00 00 00       	jmp    5dc <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 4f2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f6:	74 06                	je     4fe <printf+0xb2>
 4f8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fc:	75 2d                	jne    52b <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 501:	8b 00                	mov    (%eax),%eax
 503:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 50a:	00 
 50b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 512:	00 
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 7a fe ff ff       	call   39c <printint>
        ap++;
 522:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 526:	e9 b1 00 00 00       	jmp    5dc <printf+0x190>
      } else if(c == 's'){
 52b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 52f:	75 43                	jne    574 <printf+0x128>
        s = (char*)*ap;
 531:	8b 45 e8             	mov    -0x18(%ebp),%eax
 534:	8b 00                	mov    (%eax),%eax
 536:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 539:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 53d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 541:	75 25                	jne    568 <printf+0x11c>
          s = "(null)";
 543:	c7 45 f4 1e 08 00 00 	movl   $0x81e,-0xc(%ebp)
        while(*s != 0){
 54a:	eb 1c                	jmp    568 <printf+0x11c>
          putc(fd, *s);
 54c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54f:	8a 00                	mov    (%eax),%al
 551:	0f be c0             	movsbl %al,%eax
 554:	89 44 24 04          	mov    %eax,0x4(%esp)
 558:	8b 45 08             	mov    0x8(%ebp),%eax
 55b:	89 04 24             	mov    %eax,(%esp)
 55e:	e8 11 fe ff ff       	call   374 <putc>
          s++;
 563:	ff 45 f4             	incl   -0xc(%ebp)
 566:	eb 01                	jmp    569 <printf+0x11d>
        while(*s != 0){
 568:	90                   	nop
 569:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56c:	8a 00                	mov    (%eax),%al
 56e:	84 c0                	test   %al,%al
 570:	75 da                	jne    54c <printf+0x100>
 572:	eb 68                	jmp    5dc <printf+0x190>
        }
      } else if(c == 'c'){
 574:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 578:	75 1d                	jne    597 <printf+0x14b>
        putc(fd, *ap);
 57a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57d:	8b 00                	mov    (%eax),%eax
 57f:	0f be c0             	movsbl %al,%eax
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	89 04 24             	mov    %eax,(%esp)
 58c:	e8 e3 fd ff ff       	call   374 <putc>
        ap++;
 591:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 595:	eb 45                	jmp    5dc <printf+0x190>
      } else if(c == '%'){
 597:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59b:	75 17                	jne    5b4 <printf+0x168>
        putc(fd, c);
 59d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 c2 fd ff ff       	call   374 <putc>
 5b2:	eb 28                	jmp    5dc <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5bb:	00 
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 ad fd ff ff       	call   374 <putc>
        putc(fd, c);
 5c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ca:	0f be c0             	movsbl %al,%eax
 5cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	89 04 24             	mov    %eax,(%esp)
 5d7:	e8 98 fd ff ff       	call   374 <putc>
      }
      state = 0;
 5dc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5e3:	ff 45 f0             	incl   -0x10(%ebp)
 5e6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ec:	01 d0                	add    %edx,%eax
 5ee:	8a 00                	mov    (%eax),%al
 5f0:	84 c0                	test   %al,%al
 5f2:	0f 85 76 fe ff ff    	jne    46e <printf+0x22>
    }
  }
}
 5f8:	c9                   	leave  
 5f9:	c3                   	ret    

000005fa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5fa:	55                   	push   %ebp
 5fb:	89 e5                	mov    %esp,%ebp
 5fd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	83 e8 08             	sub    $0x8,%eax
 606:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 609:	a1 80 0a 00 00       	mov    0xa80,%eax
 60e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 611:	eb 24                	jmp    637 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61b:	77 12                	ja     62f <free+0x35>
 61d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 623:	77 24                	ja     649 <free+0x4f>
 625:	8b 45 fc             	mov    -0x4(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62d:	77 1a                	ja     649 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	89 45 fc             	mov    %eax,-0x4(%ebp)
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 63d:	76 d4                	jbe    613 <free+0x19>
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 647:	76 ca                	jbe    613 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	8b 40 04             	mov    0x4(%eax),%eax
 64f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 656:	8b 45 f8             	mov    -0x8(%ebp),%eax
 659:	01 c2                	add    %eax,%edx
 65b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	39 c2                	cmp    %eax,%edx
 662:	75 24                	jne    688 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	8b 50 04             	mov    0x4(%eax),%edx
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	8b 40 04             	mov    0x4(%eax),%eax
 672:	01 c2                	add    %eax,%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 67a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	8b 10                	mov    (%eax),%edx
 681:	8b 45 f8             	mov    -0x8(%ebp),%eax
 684:	89 10                	mov    %edx,(%eax)
 686:	eb 0a                	jmp    692 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68b:	8b 10                	mov    (%eax),%edx
 68d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 690:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
 695:	8b 40 04             	mov    0x4(%eax),%eax
 698:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 69f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a2:	01 d0                	add    %edx,%eax
 6a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a7:	75 20                	jne    6c9 <free+0xcf>
    p->s.size += bp->s.size;
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 50 04             	mov    0x4(%eax),%edx
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	8b 40 04             	mov    0x4(%eax),%eax
 6b5:	01 c2                	add    %eax,%edx
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c0:	8b 10                	mov    (%eax),%edx
 6c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c5:	89 10                	mov    %edx,(%eax)
 6c7:	eb 08                	jmp    6d1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6cf:	89 10                	mov    %edx,(%eax)
  freep = p;
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	a3 80 0a 00 00       	mov    %eax,0xa80
}
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <morecore>:

static Header*
morecore(uint nu)
{
 6db:	55                   	push   %ebp
 6dc:	89 e5                	mov    %esp,%ebp
 6de:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6e1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e8:	77 07                	ja     6f1 <morecore+0x16>
    nu = 4096;
 6ea:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	c1 e0 03             	shl    $0x3,%eax
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 05 fc ff ff       	call   304 <sbrk>
 6ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 702:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 706:	75 07                	jne    70f <morecore+0x34>
    return 0;
 708:	b8 00 00 00 00       	mov    $0x0,%eax
 70d:	eb 22                	jmp    731 <morecore+0x56>
  hp = (Header*)p;
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 715:	8b 45 f0             	mov    -0x10(%ebp),%eax
 718:	8b 55 08             	mov    0x8(%ebp),%edx
 71b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 721:	83 c0 08             	add    $0x8,%eax
 724:	89 04 24             	mov    %eax,(%esp)
 727:	e8 ce fe ff ff       	call   5fa <free>
  return freep;
 72c:	a1 80 0a 00 00       	mov    0xa80,%eax
}
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <malloc>:

void*
malloc(uint nbytes)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	83 c0 07             	add    $0x7,%eax
 73f:	c1 e8 03             	shr    $0x3,%eax
 742:	40                   	inc    %eax
 743:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 746:	a1 80 0a 00 00       	mov    0xa80,%eax
 74b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 74e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 752:	75 23                	jne    777 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 754:	c7 45 f0 78 0a 00 00 	movl   $0xa78,-0x10(%ebp)
 75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75e:	a3 80 0a 00 00       	mov    %eax,0xa80
 763:	a1 80 0a 00 00       	mov    0xa80,%eax
 768:	a3 78 0a 00 00       	mov    %eax,0xa78
    base.s.size = 0;
 76d:	c7 05 7c 0a 00 00 00 	movl   $0x0,0xa7c
 774:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 777:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 788:	72 4d                	jb     7d7 <malloc+0xa4>
      if(p->s.size == nunits)
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	8b 40 04             	mov    0x4(%eax),%eax
 790:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 793:	75 0c                	jne    7a1 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	8b 10                	mov    (%eax),%edx
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79d:	89 10                	mov    %edx,(%eax)
 79f:	eb 26                	jmp    7c7 <malloc+0x94>
      else {
        p->s.size -= nunits;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	89 c2                	mov    %eax,%edx
 7a9:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	c1 e0 03             	shl    $0x3,%eax
 7bb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	a3 80 0a 00 00       	mov    %eax,0xa80
      return (void*)(p + 1);
 7cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d2:	83 c0 08             	add    $0x8,%eax
 7d5:	eb 38                	jmp    80f <malloc+0xdc>
    }
    if(p == freep)
 7d7:	a1 80 0a 00 00       	mov    0xa80,%eax
 7dc:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7df:	75 1b                	jne    7fc <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e4:	89 04 24             	mov    %eax,(%esp)
 7e7:	e8 ef fe ff ff       	call   6db <morecore>
 7ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f3:	75 07                	jne    7fc <malloc+0xc9>
        return 0;
 7f5:	b8 00 00 00 00       	mov    $0x0,%eax
 7fa:	eb 13                	jmp    80f <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 80a:	e9 70 ff ff ff       	jmp    77f <malloc+0x4c>
}
 80f:	c9                   	leave  
 810:	c3                   	ret    
