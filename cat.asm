
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
   f:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 62 03 00 00       	call   385 <write>
  while((n = read(fd, buf, sizeof(buf))) > 0)
  23:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  2a:	00 
  2b:	c7 44 24 04 c0 0b 00 	movl   $0xbc0,0x4(%esp)
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
  4d:	c7 44 24 04 fa 08 00 	movl   $0x8fa,0x4(%esp)
  54:	00 
  55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5c:	e8 d4 04 00 00       	call   535 <printf>
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
  d5:	c7 44 24 04 0b 09 00 	movl   $0x90b,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 4c 04 00 00       	call   535 <printf>
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

00000425 <semget>:
 425:	b8 1a 00 00 00       	mov    $0x1a,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <semfree>:
 42d:	b8 1b 00 00 00       	mov    $0x1b,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <semdown>:
 435:	b8 1c 00 00 00       	mov    $0x1c,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <semup>:
 43d:	b8 1d 00 00 00       	mov    $0x1d,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <shm_create>:
 445:	b8 1e 00 00 00       	mov    $0x1e,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <shm_close>:
 44d:	b8 1f 00 00 00       	mov    $0x1f,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <shm_get>:
 455:	b8 20 00 00 00       	mov    $0x20,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45d:	55                   	push   %ebp
 45e:	89 e5                	mov    %esp,%ebp
 460:	83 ec 28             	sub    $0x28,%esp
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 469:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 470:	00 
 471:	8d 45 f4             	lea    -0xc(%ebp),%eax
 474:	89 44 24 04          	mov    %eax,0x4(%esp)
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	89 04 24             	mov    %eax,(%esp)
 47e:	e8 02 ff ff ff       	call   385 <write>
}
 483:	c9                   	leave  
 484:	c3                   	ret    

00000485 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 492:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 496:	74 17                	je     4af <printint+0x2a>
 498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49c:	79 11                	jns    4af <printint+0x2a>
    neg = 1;
 49e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a8:	f7 d8                	neg    %eax
 4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ad:	eb 06                	jmp    4b5 <printint+0x30>
  } else {
    x = xx;
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c2:	ba 00 00 00 00       	mov    $0x0,%edx
 4c7:	f7 f1                	div    %ecx
 4c9:	89 d0                	mov    %edx,%eax
 4cb:	8a 80 84 0b 00 00    	mov    0xb84(%eax),%al
 4d1:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d7:	01 ca                	add    %ecx,%edx
 4d9:	88 02                	mov    %al,(%edx)
 4db:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4de:	8b 55 10             	mov    0x10(%ebp),%edx
 4e1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e7:	ba 00 00 00 00       	mov    $0x0,%edx
 4ec:	f7 75 d4             	divl   -0x2c(%ebp)
 4ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f6:	75 c4                	jne    4bc <printint+0x37>
  if(neg)
 4f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fc:	74 2c                	je     52a <printint+0xa5>
    buf[i++] = '-';
 4fe:	8d 55 dc             	lea    -0x24(%ebp),%edx
 501:	8b 45 f4             	mov    -0xc(%ebp),%eax
 504:	01 d0                	add    %edx,%eax
 506:	c6 00 2d             	movb   $0x2d,(%eax)
 509:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 50c:	eb 1c                	jmp    52a <printint+0xa5>
    putc(fd, buf[i]);
 50e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	8a 00                	mov    (%eax),%al
 518:	0f be c0             	movsbl %al,%eax
 51b:	89 44 24 04          	mov    %eax,0x4(%esp)
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	89 04 24             	mov    %eax,(%esp)
 525:	e8 33 ff ff ff       	call   45d <putc>
  while(--i >= 0)
 52a:	ff 4d f4             	decl   -0xc(%ebp)
 52d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 531:	79 db                	jns    50e <printint+0x89>
}
 533:	c9                   	leave  
 534:	c3                   	ret    

00000535 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 535:	55                   	push   %ebp
 536:	89 e5                	mov    %esp,%ebp
 538:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 53b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 542:	8d 45 0c             	lea    0xc(%ebp),%eax
 545:	83 c0 04             	add    $0x4,%eax
 548:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 54b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 552:	e9 78 01 00 00       	jmp    6cf <printf+0x19a>
    c = fmt[i] & 0xff;
 557:	8b 55 0c             	mov    0xc(%ebp),%edx
 55a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 55d:	01 d0                	add    %edx,%eax
 55f:	8a 00                	mov    (%eax),%al
 561:	0f be c0             	movsbl %al,%eax
 564:	25 ff 00 00 00       	and    $0xff,%eax
 569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 56c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 570:	75 2c                	jne    59e <printf+0x69>
      if(c == '%'){
 572:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 576:	75 0c                	jne    584 <printf+0x4f>
        state = '%';
 578:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57f:	e9 48 01 00 00       	jmp    6cc <printf+0x197>
      } else {
        putc(fd, c);
 584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	89 44 24 04          	mov    %eax,0x4(%esp)
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 c4 fe ff ff       	call   45d <putc>
 599:	e9 2e 01 00 00       	jmp    6cc <printf+0x197>
      }
    } else if(state == '%'){
 59e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a2:	0f 85 24 01 00 00    	jne    6cc <printf+0x197>
      if(c == 'd'){
 5a8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ac:	75 2d                	jne    5db <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5ba:	00 
 5bb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5c2:	00 
 5c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ca:	89 04 24             	mov    %eax,(%esp)
 5cd:	e8 b3 fe ff ff       	call   485 <printint>
        ap++;
 5d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d6:	e9 ea 00 00 00       	jmp    6c5 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5db:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5df:	74 06                	je     5e7 <printf+0xb2>
 5e1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e5:	75 2d                	jne    614 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5f3:	00 
 5f4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5fb:	00 
 5fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	89 04 24             	mov    %eax,(%esp)
 606:	e8 7a fe ff ff       	call   485 <printint>
        ap++;
 60b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60f:	e9 b1 00 00 00       	jmp    6c5 <printf+0x190>
      } else if(c == 's'){
 614:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 618:	75 43                	jne    65d <printf+0x128>
        s = (char*)*ap;
 61a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61d:	8b 00                	mov    (%eax),%eax
 61f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62a:	75 25                	jne    651 <printf+0x11c>
          s = "(null)";
 62c:	c7 45 f4 20 09 00 00 	movl   $0x920,-0xc(%ebp)
        while(*s != 0){
 633:	eb 1c                	jmp    651 <printf+0x11c>
          putc(fd, *s);
 635:	8b 45 f4             	mov    -0xc(%ebp),%eax
 638:	8a 00                	mov    (%eax),%al
 63a:	0f be c0             	movsbl %al,%eax
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 11 fe ff ff       	call   45d <putc>
          s++;
 64c:	ff 45 f4             	incl   -0xc(%ebp)
 64f:	eb 01                	jmp    652 <printf+0x11d>
        while(*s != 0){
 651:	90                   	nop
 652:	8b 45 f4             	mov    -0xc(%ebp),%eax
 655:	8a 00                	mov    (%eax),%al
 657:	84 c0                	test   %al,%al
 659:	75 da                	jne    635 <printf+0x100>
 65b:	eb 68                	jmp    6c5 <printf+0x190>
        }
      } else if(c == 'c'){
 65d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 661:	75 1d                	jne    680 <printf+0x14b>
        putc(fd, *ap);
 663:	8b 45 e8             	mov    -0x18(%ebp),%eax
 666:	8b 00                	mov    (%eax),%eax
 668:	0f be c0             	movsbl %al,%eax
 66b:	89 44 24 04          	mov    %eax,0x4(%esp)
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 e3 fd ff ff       	call   45d <putc>
        ap++;
 67a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67e:	eb 45                	jmp    6c5 <printf+0x190>
      } else if(c == '%'){
 680:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 684:	75 17                	jne    69d <printf+0x168>
        putc(fd, c);
 686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	89 44 24 04          	mov    %eax,0x4(%esp)
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 04 24             	mov    %eax,(%esp)
 696:	e8 c2 fd ff ff       	call   45d <putc>
 69b:	eb 28                	jmp    6c5 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a4:	00 
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	89 04 24             	mov    %eax,(%esp)
 6ab:	e8 ad fd ff ff       	call   45d <putc>
        putc(fd, c);
 6b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b3:	0f be c0             	movsbl %al,%eax
 6b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	89 04 24             	mov    %eax,(%esp)
 6c0:	e8 98 fd ff ff       	call   45d <putc>
      }
      state = 0;
 6c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6cc:	ff 45 f0             	incl   -0x10(%ebp)
 6cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d5:	01 d0                	add    %edx,%eax
 6d7:	8a 00                	mov    (%eax),%al
 6d9:	84 c0                	test   %al,%al
 6db:	0f 85 76 fe ff ff    	jne    557 <printf+0x22>
    }
  }
}
 6e1:	c9                   	leave  
 6e2:	c3                   	ret    

000006e3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e3:	55                   	push   %ebp
 6e4:	89 e5                	mov    %esp,%ebp
 6e6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	83 e8 08             	sub    $0x8,%eax
 6ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f2:	a1 a8 0b 00 00       	mov    0xba8,%eax
 6f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fa:	eb 24                	jmp    720 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 704:	77 12                	ja     718 <free+0x35>
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70c:	77 24                	ja     732 <free+0x4f>
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 716:	77 1a                	ja     732 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71b:	8b 00                	mov    (%eax),%eax
 71d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 726:	76 d4                	jbe    6fc <free+0x19>
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 00                	mov    (%eax),%eax
 72d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 730:	76 ca                	jbe    6fc <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	8b 40 04             	mov    0x4(%eax),%eax
 738:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	01 c2                	add    %eax,%edx
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	39 c2                	cmp    %eax,%edx
 74b:	75 24                	jne    771 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 74d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 00                	mov    (%eax),%eax
 758:	8b 40 04             	mov    0x4(%eax),%eax
 75b:	01 c2                	add    %eax,%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	8b 00                	mov    (%eax),%eax
 768:	8b 10                	mov    (%eax),%edx
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	89 10                	mov    %edx,(%eax)
 76f:	eb 0a                	jmp    77b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 10                	mov    (%eax),%edx
 776:	8b 45 f8             	mov    -0x8(%ebp),%eax
 779:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	01 d0                	add    %edx,%eax
 78d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 790:	75 20                	jne    7b2 <free+0xcf>
    p->s.size += bp->s.size;
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 50 04             	mov    0x4(%eax),%edx
 798:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	01 c2                	add    %eax,%edx
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	8b 10                	mov    (%eax),%edx
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	89 10                	mov    %edx,(%eax)
 7b0:	eb 08                	jmp    7ba <free+0xd7>
  } else
    p->s.ptr = bp;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b8:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	a3 a8 0b 00 00       	mov    %eax,0xba8
}
 7c2:	c9                   	leave  
 7c3:	c3                   	ret    

000007c4 <morecore>:

static Header*
morecore(uint nu)
{
 7c4:	55                   	push   %ebp
 7c5:	89 e5                	mov    %esp,%ebp
 7c7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ca:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d1:	77 07                	ja     7da <morecore+0x16>
    nu = 4096;
 7d3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7da:	8b 45 08             	mov    0x8(%ebp),%eax
 7dd:	c1 e0 03             	shl    $0x3,%eax
 7e0:	89 04 24             	mov    %eax,(%esp)
 7e3:	e8 05 fc ff ff       	call   3ed <sbrk>
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7eb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ef:	75 07                	jne    7f8 <morecore+0x34>
    return 0;
 7f1:	b8 00 00 00 00       	mov    $0x0,%eax
 7f6:	eb 22                	jmp    81a <morecore+0x56>
  hp = (Header*)p;
 7f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	8b 55 08             	mov    0x8(%ebp),%edx
 804:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 807:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80a:	83 c0 08             	add    $0x8,%eax
 80d:	89 04 24             	mov    %eax,(%esp)
 810:	e8 ce fe ff ff       	call   6e3 <free>
  return freep;
 815:	a1 a8 0b 00 00       	mov    0xba8,%eax
}
 81a:	c9                   	leave  
 81b:	c3                   	ret    

0000081c <malloc>:

void*
malloc(uint nbytes)
{
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 822:	8b 45 08             	mov    0x8(%ebp),%eax
 825:	83 c0 07             	add    $0x7,%eax
 828:	c1 e8 03             	shr    $0x3,%eax
 82b:	40                   	inc    %eax
 82c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82f:	a1 a8 0b 00 00       	mov    0xba8,%eax
 834:	89 45 f0             	mov    %eax,-0x10(%ebp)
 837:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83b:	75 23                	jne    860 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 83d:	c7 45 f0 a0 0b 00 00 	movl   $0xba0,-0x10(%ebp)
 844:	8b 45 f0             	mov    -0x10(%ebp),%eax
 847:	a3 a8 0b 00 00       	mov    %eax,0xba8
 84c:	a1 a8 0b 00 00       	mov    0xba8,%eax
 851:	a3 a0 0b 00 00       	mov    %eax,0xba0
    base.s.size = 0;
 856:	c7 05 a4 0b 00 00 00 	movl   $0x0,0xba4
 85d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	8b 00                	mov    (%eax),%eax
 865:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 871:	72 4d                	jb     8c0 <malloc+0xa4>
      if(p->s.size == nunits)
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87c:	75 0c                	jne    88a <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 10                	mov    (%eax),%edx
 883:	8b 45 f0             	mov    -0x10(%ebp),%eax
 886:	89 10                	mov    %edx,(%eax)
 888:	eb 26                	jmp    8b0 <malloc+0x94>
      else {
        p->s.size -= nunits;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 40 04             	mov    0x4(%eax),%eax
 890:	89 c2                	mov    %eax,%edx
 892:	2b 55 ec             	sub    -0x14(%ebp),%edx
 895:	8b 45 f4             	mov    -0xc(%ebp),%eax
 898:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	c1 e0 03             	shl    $0x3,%eax
 8a4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ad:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b3:	a3 a8 0b 00 00       	mov    %eax,0xba8
      return (void*)(p + 1);
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	83 c0 08             	add    $0x8,%eax
 8be:	eb 38                	jmp    8f8 <malloc+0xdc>
    }
    if(p == freep)
 8c0:	a1 a8 0b 00 00       	mov    0xba8,%eax
 8c5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c8:	75 1b                	jne    8e5 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8cd:	89 04 24             	mov    %eax,(%esp)
 8d0:	e8 ef fe ff ff       	call   7c4 <morecore>
 8d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dc:	75 07                	jne    8e5 <malloc+0xc9>
        return 0;
 8de:	b8 00 00 00 00       	mov    $0x0,%eax
 8e3:	eb 13                	jmp    8f8 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8f3:	e9 70 ff ff ff       	jmp    868 <malloc+0x4c>
}
 8f8:	c9                   	leave  
 8f9:	c3                   	ret    
