
_cat:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 1b                	jmp    23 <cat+0x23>
    write(1, buf, n);
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 80 0b 00 	movl   $0xb80,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 62 03 00 00       	call   385 <write>
  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 80 0b 00 	movl   $0xb80,0x4(%esp)
  32:	00 
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 3f 03 00 00       	call   37d <read>
  3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  45:	7f c1                	jg     8 <cat+0x8>
  if(n < 0){
  47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  4b:	79 19                	jns    66 <cat+0x66>
    printf(1, "cat: read error\n");
  4d:	c7 44 24 04 c2 08 00 	movl   $0x8c2,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 9c 04 00 00       	call   4fd <printf>
    exit();
  61:	e8 ff 02 00 00       	call   365 <exit>
  }
}
  66:	c9                   	leave  
  67:	c3                   	ret    

00000068 <main>:

int
main(int argc, char *argv[])
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	83 e4 f0             	and    $0xfffffff0,%esp
  6e:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  71:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  75:	7f 11                	jg     88 <main+0x20>
    cat(0);
  77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  7e:	e8 7d ff ff ff       	call   0 <cat>
    exit();
  83:	e8 dd 02 00 00       	call   365 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  8f:	00 
  90:	eb 78                	jmp    10a <main+0xa2>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  a0:	01 d0                	add    %edx,%eax
  a2:	8b 00                	mov    (%eax),%eax
  a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ab:	00 
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 f1 02 00 00       	call   3a5 <open>
  b4:	89 44 24 18          	mov    %eax,0x18(%esp)
  b8:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  bd:	79 2f                	jns    ee <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	01 d0                	add    %edx,%eax
  cf:	8b 00                	mov    (%eax),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 d3 08 00 	movl   $0x8d3,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 14 04 00 00       	call   4fd <printf>
      exit();
  e9:	e8 77 02 00 00       	call   365 <exit>
    }
    cat(fd);
  ee:	8b 44 24 18          	mov    0x18(%esp),%eax
  f2:	89 04 24             	mov    %eax,(%esp)
  f5:	e8 06 ff ff ff       	call   0 <cat>
    close(fd);
  fa:	8b 44 24 18          	mov    0x18(%esp),%eax
  fe:	89 04 24             	mov    %eax,(%esp)
 101:	e8 87 02 00 00       	call   38d <close>
  for(i = 1; i < argc; i++){
 106:	ff 44 24 1c          	incl   0x1c(%esp)
 10a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10e:	3b 45 08             	cmp    0x8(%ebp),%eax
 111:	0f 8c 7b ff ff ff    	jl     92 <main+0x2a>
  }
  exit();
 117:	e8 49 02 00 00       	call   365 <exit>

0000011c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 121:	8b 4d 08             	mov    0x8(%ebp),%ecx
 124:	8b 55 10             	mov    0x10(%ebp),%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	89 cb                	mov    %ecx,%ebx
 12c:	89 df                	mov    %ebx,%edi
 12e:	89 d1                	mov    %edx,%ecx
 130:	fc                   	cld    
 131:	f3 aa                	rep stos %al,%es:(%edi)
 133:	89 ca                	mov    %ecx,%edx
 135:	89 fb                	mov    %edi,%ebx
 137:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13d:	5b                   	pop    %ebx
 13e:	5f                   	pop    %edi
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14d:	90                   	nop
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	8a 10                	mov    (%eax),%dl
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	88 10                	mov    %dl,(%eax)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	8a 00                	mov    (%eax),%al
 15d:	84 c0                	test   %al,%al
 15f:	0f 95 c0             	setne  %al
 162:	ff 45 08             	incl   0x8(%ebp)
 165:	ff 45 0c             	incl   0xc(%ebp)
 168:	84 c0                	test   %al,%al
 16a:	75 e2                	jne    14e <strcpy+0xd>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 174:	eb 06                	jmp    17c <strcmp+0xb>
    p++, q++;
 176:	ff 45 08             	incl   0x8(%ebp)
 179:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	8a 00                	mov    (%eax),%al
 181:	84 c0                	test   %al,%al
 183:	74 0e                	je     193 <strcmp+0x22>
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8a 10                	mov    (%eax),%dl
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	8a 00                	mov    (%eax),%al
 18f:	38 c2                	cmp    %al,%dl
 191:	74 e3                	je     176 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 d0             	movzbl %al,%edx
 19b:	8b 45 0c             	mov    0xc(%ebp),%eax
 19e:	8a 00                	mov    (%eax),%al
 1a0:	0f b6 c0             	movzbl %al,%eax
 1a3:	89 d1                	mov    %edx,%ecx
 1a5:	29 c1                	sub    %eax,%ecx
 1a7:	89 c8                	mov    %ecx,%eax
}
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strlen>:

uint
strlen(char *s)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b8:	eb 03                	jmp    1bd <strlen+0x12>
 1ba:	ff 45 fc             	incl   -0x4(%ebp)
 1bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	8a 00                	mov    (%eax),%al
 1c7:	84 c0                	test   %al,%al
 1c9:	75 ef                	jne    1ba <strlen+0xf>
    ;
  return n;
 1cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ce:	c9                   	leave  
 1cf:	c3                   	ret    

000001d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d6:	8b 45 10             	mov    0x10(%ebp),%eax
 1d9:	89 44 24 08          	mov    %eax,0x8(%esp)
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	89 04 24             	mov    %eax,(%esp)
 1ea:	e8 2d ff ff ff       	call   11c <stosb>
  return dst;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 04             	sub    $0x4,%esp
 1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 200:	eb 12                	jmp    214 <strchr+0x20>
    if(*s == c)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	8a 00                	mov    (%eax),%al
 207:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20a:	75 05                	jne    211 <strchr+0x1d>
      return (char*)s;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	eb 11                	jmp    222 <strchr+0x2e>
  for(; *s; s++)
 211:	ff 45 08             	incl   0x8(%ebp)
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8a 00                	mov    (%eax),%al
 219:	84 c0                	test   %al,%al
 21b:	75 e5                	jne    202 <strchr+0xe>
  return 0;
 21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 222:	c9                   	leave  
 223:	c3                   	ret    

00000224 <gets>:

char*
gets(char *buf, int max)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 231:	eb 42                	jmp    275 <gets+0x51>
    cc = read(0, &c, 1);
 233:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 23a:	00 
 23b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23e:	89 44 24 04          	mov    %eax,0x4(%esp)
 242:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 249:	e8 2f 01 00 00       	call   37d <read>
 24e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 251:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 255:	7e 29                	jle    280 <gets+0x5c>
      break;
    buf[i++] = c;
 257:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	01 c2                	add    %eax,%edx
 25f:	8a 45 ef             	mov    -0x11(%ebp),%al
 262:	88 02                	mov    %al,(%edx)
 264:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 267:	8a 45 ef             	mov    -0x11(%ebp),%al
 26a:	3c 0a                	cmp    $0xa,%al
 26c:	74 13                	je     281 <gets+0x5d>
 26e:	8a 45 ef             	mov    -0x11(%ebp),%al
 271:	3c 0d                	cmp    $0xd,%al
 273:	74 0c                	je     281 <gets+0x5d>
  for(i=0; i+1 < max; ){
 275:	8b 45 f4             	mov    -0xc(%ebp),%eax
 278:	40                   	inc    %eax
 279:	3b 45 0c             	cmp    0xc(%ebp),%eax
 27c:	7c b5                	jl     233 <gets+0xf>
 27e:	eb 01                	jmp    281 <gets+0x5d>
      break;
 280:	90                   	nop
      break;
  }
  buf[i] = '\0';
 281:	8b 55 f4             	mov    -0xc(%ebp),%edx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	01 d0                	add    %edx,%eax
 289:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <stat>:

int
stat(char *n, struct stat *st)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 297:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 29e:	00 
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	89 04 24             	mov    %eax,(%esp)
 2a5:	e8 fb 00 00 00       	call   3a5 <open>
 2aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b1:	79 07                	jns    2ba <stat+0x29>
    return -1;
 2b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b8:	eb 23                	jmp    2dd <stat+0x4c>
  r = fstat(fd, st);
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c4:	89 04 24             	mov    %eax,(%esp)
 2c7:	e8 f1 00 00 00       	call   3bd <fstat>
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 b3 00 00 00       	call   38d <close>
  return r;
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <atoi>:

int
atoi(const char *s)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
 2e2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2ec:	eb 21                	jmp    30f <atoi+0x30>
    n = n*10 + *s++ - '0';
 2ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f1:	89 d0                	mov    %edx,%eax
 2f3:	c1 e0 02             	shl    $0x2,%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	d1 e0                	shl    %eax
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	8a 00                	mov    (%eax),%al
 301:	0f be c0             	movsbl %al,%eax
 304:	01 d0                	add    %edx,%eax
 306:	83 e8 30             	sub    $0x30,%eax
 309:	89 45 fc             	mov    %eax,-0x4(%ebp)
 30c:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	8a 00                	mov    (%eax),%al
 314:	3c 2f                	cmp    $0x2f,%al
 316:	7e 09                	jle    321 <atoi+0x42>
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	8a 00                	mov    (%eax),%al
 31d:	3c 39                	cmp    $0x39,%al
 31f:	7e cd                	jle    2ee <atoi+0xf>
  return n;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 332:	8b 45 0c             	mov    0xc(%ebp),%eax
 335:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 338:	eb 10                	jmp    34a <memmove+0x24>
    *dst++ = *src++;
 33a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33d:	8a 10                	mov    (%eax),%dl
 33f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 342:	88 10                	mov    %dl,(%eax)
 344:	ff 45 fc             	incl   -0x4(%ebp)
 347:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 34a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 34e:	0f 9f c0             	setg   %al
 351:	ff 4d 10             	decl   0x10(%ebp)
 354:	84 c0                	test   %al,%al
 356:	75 e2                	jne    33a <memmove+0x14>
  return vdst;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <fork>:
 35d:	b8 01 00 00 00       	mov    $0x1,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <exit>:
 365:	b8 02 00 00 00       	mov    $0x2,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <wait>:
 36d:	b8 03 00 00 00       	mov    $0x3,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <pipe>:
 375:	b8 04 00 00 00       	mov    $0x4,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <read>:
 37d:	b8 05 00 00 00       	mov    $0x5,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <write>:
 385:	b8 10 00 00 00       	mov    $0x10,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <close>:
 38d:	b8 15 00 00 00       	mov    $0x15,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <kill>:
 395:	b8 06 00 00 00       	mov    $0x6,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <exec>:
 39d:	b8 07 00 00 00       	mov    $0x7,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <open>:
 3a5:	b8 0f 00 00 00       	mov    $0xf,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <mknod>:
 3ad:	b8 11 00 00 00       	mov    $0x11,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <unlink>:
 3b5:	b8 12 00 00 00       	mov    $0x12,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <fstat>:
 3bd:	b8 08 00 00 00       	mov    $0x8,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <link>:
 3c5:	b8 13 00 00 00       	mov    $0x13,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <mkdir>:
 3cd:	b8 14 00 00 00       	mov    $0x14,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <chdir>:
 3d5:	b8 09 00 00 00       	mov    $0x9,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <dup>:
 3dd:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <getpid>:
 3e5:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <sbrk>:
 3ed:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <sleep>:
 3f5:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <uptime>:
 3fd:	b8 0e 00 00 00       	mov    $0xe,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <lseek>:
 405:	b8 16 00 00 00       	mov    $0x16,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <isatty>:
 40d:	b8 17 00 00 00       	mov    $0x17,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <procstat>:
 415:	b8 18 00 00 00       	mov    $0x18,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <set_priority>:
 41d:	b8 19 00 00 00       	mov    $0x19,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	83 ec 28             	sub    $0x28,%esp
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 431:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 438:	00 
 439:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43c:	89 44 24 04          	mov    %eax,0x4(%esp)
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	89 04 24             	mov    %eax,(%esp)
 446:	e8 3a ff ff ff       	call   385 <write>
}
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 453:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45e:	74 17                	je     477 <printint+0x2a>
 460:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 464:	79 11                	jns    477 <printint+0x2a>
    neg = 1;
 466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	f7 d8                	neg    %eax
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
 475:	eb 06                	jmp    47d <printint+0x30>
  } else {
    x = xx;
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 484:	8b 4d 10             	mov    0x10(%ebp),%ecx
 487:	8b 45 ec             	mov    -0x14(%ebp),%eax
 48a:	ba 00 00 00 00       	mov    $0x0,%edx
 48f:	f7 f1                	div    %ecx
 491:	89 d0                	mov    %edx,%eax
 493:	8a 80 4c 0b 00 00    	mov    0xb4c(%eax),%al
 499:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 49c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 49f:	01 ca                	add    %ecx,%edx
 4a1:	88 02                	mov    %al,(%edx)
 4a3:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4a6:	8b 55 10             	mov    0x10(%ebp),%edx
 4a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4af:	ba 00 00 00 00       	mov    $0x0,%edx
 4b4:	f7 75 d4             	divl   -0x2c(%ebp)
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4be:	75 c4                	jne    484 <printint+0x37>
  if(neg)
 4c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c4:	74 2c                	je     4f2 <printint+0xa5>
    buf[i++] = '-';
 4c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	c6 00 2d             	movb   $0x2d,(%eax)
 4d1:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4d4:	eb 1c                	jmp    4f2 <printint+0xa5>
    putc(fd, buf[i]);
 4d6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dc:	01 d0                	add    %edx,%eax
 4de:	8a 00                	mov    (%eax),%al
 4e0:	0f be c0             	movsbl %al,%eax
 4e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	89 04 24             	mov    %eax,(%esp)
 4ed:	e8 33 ff ff ff       	call   425 <putc>
  while(--i >= 0)
 4f2:	ff 4d f4             	decl   -0xc(%ebp)
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	79 db                	jns    4d6 <printint+0x89>
}
 4fb:	c9                   	leave  
 4fc:	c3                   	ret    

000004fd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fd:	55                   	push   %ebp
 4fe:	89 e5                	mov    %esp,%ebp
 500:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 503:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50a:	8d 45 0c             	lea    0xc(%ebp),%eax
 50d:	83 c0 04             	add    $0x4,%eax
 510:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51a:	e9 78 01 00 00       	jmp    697 <printf+0x19a>
    c = fmt[i] & 0xff;
 51f:	8b 55 0c             	mov    0xc(%ebp),%edx
 522:	8b 45 f0             	mov    -0x10(%ebp),%eax
 525:	01 d0                	add    %edx,%eax
 527:	8a 00                	mov    (%eax),%al
 529:	0f be c0             	movsbl %al,%eax
 52c:	25 ff 00 00 00       	and    $0xff,%eax
 531:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 534:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 538:	75 2c                	jne    566 <printf+0x69>
      if(c == '%'){
 53a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53e:	75 0c                	jne    54c <printf+0x4f>
        state = '%';
 540:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 547:	e9 48 01 00 00       	jmp    694 <printf+0x197>
      } else {
        putc(fd, c);
 54c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54f:	0f be c0             	movsbl %al,%eax
 552:	89 44 24 04          	mov    %eax,0x4(%esp)
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	89 04 24             	mov    %eax,(%esp)
 55c:	e8 c4 fe ff ff       	call   425 <putc>
 561:	e9 2e 01 00 00       	jmp    694 <printf+0x197>
      }
    } else if(state == '%'){
 566:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 56a:	0f 85 24 01 00 00    	jne    694 <printf+0x197>
      if(c == 'd'){
 570:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 574:	75 2d                	jne    5a3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 576:	8b 45 e8             	mov    -0x18(%ebp),%eax
 579:	8b 00                	mov    (%eax),%eax
 57b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 582:	00 
 583:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 58a:	00 
 58b:	89 44 24 04          	mov    %eax,0x4(%esp)
 58f:	8b 45 08             	mov    0x8(%ebp),%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 b3 fe ff ff       	call   44d <printint>
        ap++;
 59a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 59e:	e9 ea 00 00 00       	jmp    68d <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a7:	74 06                	je     5af <printf+0xb2>
 5a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ad:	75 2d                	jne    5dc <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b2:	8b 00                	mov    (%eax),%eax
 5b4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5bb:	00 
 5bc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5c3:	00 
 5c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c8:	8b 45 08             	mov    0x8(%ebp),%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 7a fe ff ff       	call   44d <printint>
        ap++;
 5d3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d7:	e9 b1 00 00 00       	jmp    68d <printf+0x190>
      } else if(c == 's'){
 5dc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5e0:	75 43                	jne    625 <printf+0x128>
        s = (char*)*ap;
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ea:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5f2:	75 25                	jne    619 <printf+0x11c>
          s = "(null)";
 5f4:	c7 45 f4 e8 08 00 00 	movl   $0x8e8,-0xc(%ebp)
        while(*s != 0){
 5fb:	eb 1c                	jmp    619 <printf+0x11c>
          putc(fd, *s);
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	8a 00                	mov    (%eax),%al
 602:	0f be c0             	movsbl %al,%eax
 605:	89 44 24 04          	mov    %eax,0x4(%esp)
 609:	8b 45 08             	mov    0x8(%ebp),%eax
 60c:	89 04 24             	mov    %eax,(%esp)
 60f:	e8 11 fe ff ff       	call   425 <putc>
          s++;
 614:	ff 45 f4             	incl   -0xc(%ebp)
 617:	eb 01                	jmp    61a <printf+0x11d>
        while(*s != 0){
 619:	90                   	nop
 61a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61d:	8a 00                	mov    (%eax),%al
 61f:	84 c0                	test   %al,%al
 621:	75 da                	jne    5fd <printf+0x100>
 623:	eb 68                	jmp    68d <printf+0x190>
        }
      } else if(c == 'c'){
 625:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 629:	75 1d                	jne    648 <printf+0x14b>
        putc(fd, *ap);
 62b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62e:	8b 00                	mov    (%eax),%eax
 630:	0f be c0             	movsbl %al,%eax
 633:	89 44 24 04          	mov    %eax,0x4(%esp)
 637:	8b 45 08             	mov    0x8(%ebp),%eax
 63a:	89 04 24             	mov    %eax,(%esp)
 63d:	e8 e3 fd ff ff       	call   425 <putc>
        ap++;
 642:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 646:	eb 45                	jmp    68d <printf+0x190>
      } else if(c == '%'){
 648:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64c:	75 17                	jne    665 <printf+0x168>
        putc(fd, c);
 64e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	89 44 24 04          	mov    %eax,0x4(%esp)
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	89 04 24             	mov    %eax,(%esp)
 65e:	e8 c2 fd ff ff       	call   425 <putc>
 663:	eb 28                	jmp    68d <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 665:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 66c:	00 
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 ad fd ff ff       	call   425 <putc>
        putc(fd, c);
 678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67b:	0f be c0             	movsbl %al,%eax
 67e:	89 44 24 04          	mov    %eax,0x4(%esp)
 682:	8b 45 08             	mov    0x8(%ebp),%eax
 685:	89 04 24             	mov    %eax,(%esp)
 688:	e8 98 fd ff ff       	call   425 <putc>
      }
      state = 0;
 68d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 694:	ff 45 f0             	incl   -0x10(%ebp)
 697:	8b 55 0c             	mov    0xc(%ebp),%edx
 69a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 69d:	01 d0                	add    %edx,%eax
 69f:	8a 00                	mov    (%eax),%al
 6a1:	84 c0                	test   %al,%al
 6a3:	0f 85 76 fe ff ff    	jne    51f <printf+0x22>
    }
  }
}
 6a9:	c9                   	leave  
 6aa:	c3                   	ret    

000006ab <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ab:	55                   	push   %ebp
 6ac:	89 e5                	mov    %esp,%ebp
 6ae:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	83 e8 08             	sub    $0x8,%eax
 6b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ba:	a1 68 0b 00 00       	mov    0xb68,%eax
 6bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c2:	eb 24                	jmp    6e8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c7:	8b 00                	mov    (%eax),%eax
 6c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cc:	77 12                	ja     6e0 <free+0x35>
 6ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d4:	77 24                	ja     6fa <free+0x4f>
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6de:	77 1a                	ja     6fa <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ee:	76 d4                	jbe    6c4 <free+0x19>
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f8:	76 ca                	jbe    6c4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	8b 40 04             	mov    0x4(%eax),%eax
 700:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	01 c2                	add    %eax,%edx
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	39 c2                	cmp    %eax,%edx
 713:	75 24                	jne    739 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	8b 10                	mov    (%eax),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	89 10                	mov    %edx,(%eax)
 737:	eb 0a                	jmp    743 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 10                	mov    (%eax),%edx
 73e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 741:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	01 d0                	add    %edx,%eax
 755:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 758:	75 20                	jne    77a <free+0xcf>
    p->s.size += bp->s.size;
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	01 c2                	add    %eax,%edx
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	89 10                	mov    %edx,(%eax)
 778:	eb 08                	jmp    782 <free+0xd7>
  } else
    p->s.ptr = bp;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 780:	89 10                	mov    %edx,(%eax)
  freep = p;
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 78a:	c9                   	leave  
 78b:	c3                   	ret    

0000078c <morecore>:

static Header*
morecore(uint nu)
{
 78c:	55                   	push   %ebp
 78d:	89 e5                	mov    %esp,%ebp
 78f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 792:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 799:	77 07                	ja     7a2 <morecore+0x16>
    nu = 4096;
 79b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7a2:	8b 45 08             	mov    0x8(%ebp),%eax
 7a5:	c1 e0 03             	shl    $0x3,%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 3d fc ff ff       	call   3ed <sbrk>
 7b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7b3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7b7:	75 07                	jne    7c0 <morecore+0x34>
    return 0;
 7b9:	b8 00 00 00 00       	mov    $0x0,%eax
 7be:	eb 22                	jmp    7e2 <morecore+0x56>
  hp = (Header*)p;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c9:	8b 55 08             	mov    0x8(%ebp),%edx
 7cc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d2:	83 c0 08             	add    $0x8,%eax
 7d5:	89 04 24             	mov    %eax,(%esp)
 7d8:	e8 ce fe ff ff       	call   6ab <free>
  return freep;
 7dd:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7e2:	c9                   	leave  
 7e3:	c3                   	ret    

000007e4 <malloc>:

void*
malloc(uint nbytes)
{
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	83 c0 07             	add    $0x7,%eax
 7f0:	c1 e8 03             	shr    $0x3,%eax
 7f3:	40                   	inc    %eax
 7f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7f7:	a1 68 0b 00 00       	mov    0xb68,%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 803:	75 23                	jne    828 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 805:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 80c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80f:	a3 68 0b 00 00       	mov    %eax,0xb68
 814:	a1 68 0b 00 00       	mov    0xb68,%eax
 819:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 81e:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 825:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	8b 00                	mov    (%eax),%eax
 82d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8b 40 04             	mov    0x4(%eax),%eax
 836:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 839:	72 4d                	jb     888 <malloc+0xa4>
      if(p->s.size == nunits)
 83b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83e:	8b 40 04             	mov    0x4(%eax),%eax
 841:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 844:	75 0c                	jne    852 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
 850:	eb 26                	jmp    878 <malloc+0x94>
      else {
        p->s.size -= nunits;
 852:	8b 45 f4             	mov    -0xc(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	89 c2                	mov    %eax,%edx
 85a:	2b 55 ec             	sub    -0x14(%ebp),%edx
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 863:	8b 45 f4             	mov    -0xc(%ebp),%eax
 866:	8b 40 04             	mov    0x4(%eax),%eax
 869:	c1 e0 03             	shl    $0x3,%eax
 86c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	8b 55 ec             	mov    -0x14(%ebp),%edx
 875:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	83 c0 08             	add    $0x8,%eax
 886:	eb 38                	jmp    8c0 <malloc+0xdc>
    }
    if(p == freep)
 888:	a1 68 0b 00 00       	mov    0xb68,%eax
 88d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 890:	75 1b                	jne    8ad <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 892:	8b 45 ec             	mov    -0x14(%ebp),%eax
 895:	89 04 24             	mov    %eax,(%esp)
 898:	e8 ef fe ff ff       	call   78c <morecore>
 89d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a4:	75 07                	jne    8ad <malloc+0xc9>
        return 0;
 8a6:	b8 00 00 00 00       	mov    $0x0,%eax
 8ab:	eb 13                	jmp    8c0 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8bb:	e9 70 ff ff ff       	jmp    830 <malloc+0x4c>
}
 8c0:	c9                   	leave  
 8c1:	c3                   	ret    
