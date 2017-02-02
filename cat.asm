
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
  4d:	c7 44 24 04 b2 08 00 	movl   $0x8b2,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 8c 04 00 00       	call   4ed <printf>
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
  d5:	c7 44 24 04 c3 08 00 	movl   $0x8c3,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 04 04 00 00       	call   4ed <printf>
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

00000415 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 28             	sub    $0x28,%esp
 41b:	8b 45 0c             	mov    0xc(%ebp),%eax
 41e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 421:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 428:	00 
 429:	8d 45 f4             	lea    -0xc(%ebp),%eax
 42c:	89 44 24 04          	mov    %eax,0x4(%esp)
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	89 04 24             	mov    %eax,(%esp)
 436:	e8 4a ff ff ff       	call   385 <write>
}
 43b:	c9                   	leave  
 43c:	c3                   	ret    

0000043d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 43d:	55                   	push   %ebp
 43e:	89 e5                	mov    %esp,%ebp
 440:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 443:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 44a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 44e:	74 17                	je     467 <printint+0x2a>
 450:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 454:	79 11                	jns    467 <printint+0x2a>
    neg = 1;
 456:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 45d:	8b 45 0c             	mov    0xc(%ebp),%eax
 460:	f7 d8                	neg    %eax
 462:	89 45 ec             	mov    %eax,-0x14(%ebp)
 465:	eb 06                	jmp    46d <printint+0x30>
  } else {
    x = xx;
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 46d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 474:	8b 4d 10             	mov    0x10(%ebp),%ecx
 477:	8b 45 ec             	mov    -0x14(%ebp),%eax
 47a:	ba 00 00 00 00       	mov    $0x0,%edx
 47f:	f7 f1                	div    %ecx
 481:	89 d0                	mov    %edx,%eax
 483:	8a 80 3c 0b 00 00    	mov    0xb3c(%eax),%al
 489:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 48c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 48f:	01 ca                	add    %ecx,%edx
 491:	88 02                	mov    %al,(%edx)
 493:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 496:	8b 55 10             	mov    0x10(%ebp),%edx
 499:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 49c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 49f:	ba 00 00 00 00       	mov    $0x0,%edx
 4a4:	f7 75 d4             	divl   -0x2c(%ebp)
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ae:	75 c4                	jne    474 <printint+0x37>
  if(neg)
 4b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4b4:	74 2c                	je     4e2 <printint+0xa5>
    buf[i++] = '-';
 4b6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4bc:	01 d0                	add    %edx,%eax
 4be:	c6 00 2d             	movb   $0x2d,(%eax)
 4c1:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4c4:	eb 1c                	jmp    4e2 <printint+0xa5>
    putc(fd, buf[i]);
 4c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cc:	01 d0                	add    %edx,%eax
 4ce:	8a 00                	mov    (%eax),%al
 4d0:	0f be c0             	movsbl %al,%eax
 4d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	89 04 24             	mov    %eax,(%esp)
 4dd:	e8 33 ff ff ff       	call   415 <putc>
  while(--i >= 0)
 4e2:	ff 4d f4             	decl   -0xc(%ebp)
 4e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e9:	79 db                	jns    4c6 <printint+0x89>
}
 4eb:	c9                   	leave  
 4ec:	c3                   	ret    

000004ed <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4ed:	55                   	push   %ebp
 4ee:	89 e5                	mov    %esp,%ebp
 4f0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4fa:	8d 45 0c             	lea    0xc(%ebp),%eax
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 503:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 50a:	e9 78 01 00 00       	jmp    687 <printf+0x19a>
    c = fmt[i] & 0xff;
 50f:	8b 55 0c             	mov    0xc(%ebp),%edx
 512:	8b 45 f0             	mov    -0x10(%ebp),%eax
 515:	01 d0                	add    %edx,%eax
 517:	8a 00                	mov    (%eax),%al
 519:	0f be c0             	movsbl %al,%eax
 51c:	25 ff 00 00 00       	and    $0xff,%eax
 521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 524:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 528:	75 2c                	jne    556 <printf+0x69>
      if(c == '%'){
 52a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 52e:	75 0c                	jne    53c <printf+0x4f>
        state = '%';
 530:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 537:	e9 48 01 00 00       	jmp    684 <printf+0x197>
      } else {
        putc(fd, c);
 53c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 53f:	0f be c0             	movsbl %al,%eax
 542:	89 44 24 04          	mov    %eax,0x4(%esp)
 546:	8b 45 08             	mov    0x8(%ebp),%eax
 549:	89 04 24             	mov    %eax,(%esp)
 54c:	e8 c4 fe ff ff       	call   415 <putc>
 551:	e9 2e 01 00 00       	jmp    684 <printf+0x197>
      }
    } else if(state == '%'){
 556:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 55a:	0f 85 24 01 00 00    	jne    684 <printf+0x197>
      if(c == 'd'){
 560:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 564:	75 2d                	jne    593 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 572:	00 
 573:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 57a:	00 
 57b:	89 44 24 04          	mov    %eax,0x4(%esp)
 57f:	8b 45 08             	mov    0x8(%ebp),%eax
 582:	89 04 24             	mov    %eax,(%esp)
 585:	e8 b3 fe ff ff       	call   43d <printint>
        ap++;
 58a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58e:	e9 ea 00 00 00       	jmp    67d <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 593:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 597:	74 06                	je     59f <printf+0xb2>
 599:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59d:	75 2d                	jne    5cc <printf+0xdf>
        printint(fd, *ap, 16, 0);
 59f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ab:	00 
 5ac:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5b3:	00 
 5b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	89 04 24             	mov    %eax,(%esp)
 5be:	e8 7a fe ff ff       	call   43d <printint>
        ap++;
 5c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c7:	e9 b1 00 00 00       	jmp    67d <printf+0x190>
      } else if(c == 's'){
 5cc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d0:	75 43                	jne    615 <printf+0x128>
        s = (char*)*ap;
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e2:	75 25                	jne    609 <printf+0x11c>
          s = "(null)";
 5e4:	c7 45 f4 d8 08 00 00 	movl   $0x8d8,-0xc(%ebp)
        while(*s != 0){
 5eb:	eb 1c                	jmp    609 <printf+0x11c>
          putc(fd, *s);
 5ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f0:	8a 00                	mov    (%eax),%al
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	89 04 24             	mov    %eax,(%esp)
 5ff:	e8 11 fe ff ff       	call   415 <putc>
          s++;
 604:	ff 45 f4             	incl   -0xc(%ebp)
 607:	eb 01                	jmp    60a <printf+0x11d>
        while(*s != 0){
 609:	90                   	nop
 60a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60d:	8a 00                	mov    (%eax),%al
 60f:	84 c0                	test   %al,%al
 611:	75 da                	jne    5ed <printf+0x100>
 613:	eb 68                	jmp    67d <printf+0x190>
        }
      } else if(c == 'c'){
 615:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 619:	75 1d                	jne    638 <printf+0x14b>
        putc(fd, *ap);
 61b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	0f be c0             	movsbl %al,%eax
 623:	89 44 24 04          	mov    %eax,0x4(%esp)
 627:	8b 45 08             	mov    0x8(%ebp),%eax
 62a:	89 04 24             	mov    %eax,(%esp)
 62d:	e8 e3 fd ff ff       	call   415 <putc>
        ap++;
 632:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 636:	eb 45                	jmp    67d <printf+0x190>
      } else if(c == '%'){
 638:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 63c:	75 17                	jne    655 <printf+0x168>
        putc(fd, c);
 63e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	89 44 24 04          	mov    %eax,0x4(%esp)
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	89 04 24             	mov    %eax,(%esp)
 64e:	e8 c2 fd ff ff       	call   415 <putc>
 653:	eb 28                	jmp    67d <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 655:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 65c:	00 
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	89 04 24             	mov    %eax,(%esp)
 663:	e8 ad fd ff ff       	call   415 <putc>
        putc(fd, c);
 668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	89 44 24 04          	mov    %eax,0x4(%esp)
 672:	8b 45 08             	mov    0x8(%ebp),%eax
 675:	89 04 24             	mov    %eax,(%esp)
 678:	e8 98 fd ff ff       	call   415 <putc>
      }
      state = 0;
 67d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 684:	ff 45 f0             	incl   -0x10(%ebp)
 687:	8b 55 0c             	mov    0xc(%ebp),%edx
 68a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68d:	01 d0                	add    %edx,%eax
 68f:	8a 00                	mov    (%eax),%al
 691:	84 c0                	test   %al,%al
 693:	0f 85 76 fe ff ff    	jne    50f <printf+0x22>
    }
  }
}
 699:	c9                   	leave  
 69a:	c3                   	ret    

0000069b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 69b:	55                   	push   %ebp
 69c:	89 e5                	mov    %esp,%ebp
 69e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a1:	8b 45 08             	mov    0x8(%ebp),%eax
 6a4:	83 e8 08             	sub    $0x8,%eax
 6a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6aa:	a1 68 0b 00 00       	mov    0xb68,%eax
 6af:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6b2:	eb 24                	jmp    6d8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b7:	8b 00                	mov    (%eax),%eax
 6b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bc:	77 12                	ja     6d0 <free+0x35>
 6be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c4:	77 24                	ja     6ea <free+0x4f>
 6c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ce:	77 1a                	ja     6ea <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6de:	76 d4                	jbe    6b4 <free+0x19>
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e8:	76 ca                	jbe    6b4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ed:	8b 40 04             	mov    0x4(%eax),%eax
 6f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	01 c2                	add    %eax,%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	39 c2                	cmp    %eax,%edx
 703:	75 24                	jne    729 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 50 04             	mov    0x4(%eax),%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	8b 40 04             	mov    0x4(%eax),%eax
 713:	01 c2                	add    %eax,%edx
 715:	8b 45 f8             	mov    -0x8(%ebp),%eax
 718:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	8b 10                	mov    (%eax),%edx
 722:	8b 45 f8             	mov    -0x8(%ebp),%eax
 725:	89 10                	mov    %edx,(%eax)
 727:	eb 0a                	jmp    733 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 731:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 740:	8b 45 fc             	mov    -0x4(%ebp),%eax
 743:	01 d0                	add    %edx,%eax
 745:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 748:	75 20                	jne    76a <free+0xcf>
    p->s.size += bp->s.size;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	8b 40 04             	mov    0x4(%eax),%eax
 756:	01 c2                	add    %eax,%edx
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	8b 10                	mov    (%eax),%edx
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	89 10                	mov    %edx,(%eax)
 768:	eb 08                	jmp    772 <free+0xd7>
  } else
    p->s.ptr = bp;
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 770:	89 10                	mov    %edx,(%eax)
  freep = p;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	a3 68 0b 00 00       	mov    %eax,0xb68
}
 77a:	c9                   	leave  
 77b:	c3                   	ret    

0000077c <morecore>:

static Header*
morecore(uint nu)
{
 77c:	55                   	push   %ebp
 77d:	89 e5                	mov    %esp,%ebp
 77f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 782:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 789:	77 07                	ja     792 <morecore+0x16>
    nu = 4096;
 78b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	c1 e0 03             	shl    $0x3,%eax
 798:	89 04 24             	mov    %eax,(%esp)
 79b:	e8 4d fc ff ff       	call   3ed <sbrk>
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a7:	75 07                	jne    7b0 <morecore+0x34>
    return 0;
 7a9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ae:	eb 22                	jmp    7d2 <morecore+0x56>
  hp = (Header*)p;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	8b 55 08             	mov    0x8(%ebp),%edx
 7bc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	83 c0 08             	add    $0x8,%eax
 7c5:	89 04 24             	mov    %eax,(%esp)
 7c8:	e8 ce fe ff ff       	call   69b <free>
  return freep;
 7cd:	a1 68 0b 00 00       	mov    0xb68,%eax
}
 7d2:	c9                   	leave  
 7d3:	c3                   	ret    

000007d4 <malloc>:

void*
malloc(uint nbytes)
{
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7da:	8b 45 08             	mov    0x8(%ebp),%eax
 7dd:	83 c0 07             	add    $0x7,%eax
 7e0:	c1 e8 03             	shr    $0x3,%eax
 7e3:	40                   	inc    %eax
 7e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e7:	a1 68 0b 00 00       	mov    0xb68,%eax
 7ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f3:	75 23                	jne    818 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7f5:	c7 45 f0 60 0b 00 00 	movl   $0xb60,-0x10(%ebp)
 7fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ff:	a3 68 0b 00 00       	mov    %eax,0xb68
 804:	a1 68 0b 00 00       	mov    0xb68,%eax
 809:	a3 60 0b 00 00       	mov    %eax,0xb60
    base.s.size = 0;
 80e:	c7 05 64 0b 00 00 00 	movl   $0x0,0xb64
 815:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 818:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 820:	8b 45 f4             	mov    -0xc(%ebp),%eax
 823:	8b 40 04             	mov    0x4(%eax),%eax
 826:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 829:	72 4d                	jb     878 <malloc+0xa4>
      if(p->s.size == nunits)
 82b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82e:	8b 40 04             	mov    0x4(%eax),%eax
 831:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 834:	75 0c                	jne    842 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 10                	mov    (%eax),%edx
 83b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83e:	89 10                	mov    %edx,(%eax)
 840:	eb 26                	jmp    868 <malloc+0x94>
      else {
        p->s.size -= nunits;
 842:	8b 45 f4             	mov    -0xc(%ebp),%eax
 845:	8b 40 04             	mov    0x4(%eax),%eax
 848:	89 c2                	mov    %eax,%edx
 84a:	2b 55 ec             	sub    -0x14(%ebp),%edx
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	8b 40 04             	mov    0x4(%eax),%eax
 859:	c1 e0 03             	shl    $0x3,%eax
 85c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8b 55 ec             	mov    -0x14(%ebp),%edx
 865:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 868:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86b:	a3 68 0b 00 00       	mov    %eax,0xb68
      return (void*)(p + 1);
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	83 c0 08             	add    $0x8,%eax
 876:	eb 38                	jmp    8b0 <malloc+0xdc>
    }
    if(p == freep)
 878:	a1 68 0b 00 00       	mov    0xb68,%eax
 87d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 880:	75 1b                	jne    89d <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 882:	8b 45 ec             	mov    -0x14(%ebp),%eax
 885:	89 04 24             	mov    %eax,(%esp)
 888:	e8 ef fe ff ff       	call   77c <morecore>
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 894:	75 07                	jne    89d <malloc+0xc9>
        return 0;
 896:	b8 00 00 00 00       	mov    $0x0,%eax
 89b:	eb 13                	jmp    8b0 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8b 00                	mov    (%eax),%eax
 8a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8ab:	e9 70 ff ff ff       	jmp    820 <malloc+0x4c>
}
 8b0:	c9                   	leave  
 8b1:	c3                   	ret    
