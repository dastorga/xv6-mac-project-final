
_wc:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 62                	jmp    84 <wc+0x84>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 51                	jmp    7c <wc+0x7c>
      c++;
  2b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
  2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  31:	05 80 0c 00 00       	add    $0xc80,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 80 0c 00 00       	add    $0xc80,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 b0 09 00 00 	movl   $0x9b0,(%esp)
  57:	e8 4e 02 00 00       	call   2aa <strchr>
  5c:	85 c0                	test   %eax,%eax
  5e:	74 09                	je     69 <wc+0x69>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  67:	eb 10                	jmp    79 <wc+0x79>
      else if(!inword){
  69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  6d:	75 0a                	jne    79 <wc+0x79>
        w++;
  6f:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
  72:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  79:	ff 45 f4             	incl   -0xc(%ebp)
  7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  82:	7c a7                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  84:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8b:	00 
  8c:	c7 44 24 04 80 0c 00 	movl   $0xc80,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 94 03 00 00       	call   433 <read>
  9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  a6:	0f 8f 76 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b0:	79 19                	jns    cb <wc+0xcb>
    printf(1, "wc: read error\n");
  b2:	c7 44 24 04 b6 09 00 	movl   $0x9b6,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 25 05 00 00       	call   5eb <printf>
    exit();
  c6:	e8 50 03 00 00       	call   41b <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	89 44 24 14          	mov    %eax,0x14(%esp)
  d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 c6 09 00 	movl   $0x9c6,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 f0 04 00 00       	call   5eb <printf>
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <main>:

int
main(int argc, char *argv[])
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 e4 f0             	and    $0xfffffff0,%esp
 103:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 106:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10a:	7f 19                	jg     125 <main+0x28>
    wc(0, "");
 10c:	c7 44 24 04 d3 09 00 	movl   $0x9d3,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 f6 02 00 00       	call   41b <exit>
  }

  for(i = 1; i < argc; i++){
 125:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 12c:	00 
 12d:	e9 8e 00 00 00       	jmp    1c0 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
 132:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 136:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	8b 00                	mov    (%eax),%eax
 144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14b:	00 
 14c:	89 04 24             	mov    %eax,(%esp)
 14f:	e8 07 03 00 00       	call   45b <open>
 154:	89 44 24 18          	mov    %eax,0x18(%esp)
 158:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 15d:	79 2f                	jns    18e <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	01 d0                	add    %edx,%eax
 16f:	8b 00                	mov    (%eax),%eax
 171:	89 44 24 08          	mov    %eax,0x8(%esp)
 175:	c7 44 24 04 d4 09 00 	movl   $0x9d4,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 62 04 00 00       	call   5eb <printf>
      exit();
 189:	e8 8d 02 00 00       	call   41b <exit>
    }
    wc(fd, argv[i]);
 18e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	01 d0                	add    %edx,%eax
 19e:	8b 00                	mov    (%eax),%eax
 1a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a4:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a8:	89 04 24             	mov    %eax,(%esp)
 1ab:	e8 50 fe ff ff       	call   0 <wc>
    close(fd);
 1b0:	8b 44 24 18          	mov    0x18(%esp),%eax
 1b4:	89 04 24             	mov    %eax,(%esp)
 1b7:	e8 87 02 00 00       	call   443 <close>
  for(i = 1; i < argc; i++){
 1bc:	ff 44 24 1c          	incl   0x1c(%esp)
 1c0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1c4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1c7:	0f 8c 65 ff ff ff    	jl     132 <main+0x35>
  }
  exit();
 1cd:	e8 49 02 00 00       	call   41b <exit>

000001d2 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d2:	55                   	push   %ebp
 1d3:	89 e5                	mov    %esp,%ebp
 1d5:	57                   	push   %edi
 1d6:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1da:	8b 55 10             	mov    0x10(%ebp),%edx
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	89 cb                	mov    %ecx,%ebx
 1e2:	89 df                	mov    %ebx,%edi
 1e4:	89 d1                	mov    %edx,%ecx
 1e6:	fc                   	cld    
 1e7:	f3 aa                	rep stos %al,%es:(%edi)
 1e9:	89 ca                	mov    %ecx,%edx
 1eb:	89 fb                	mov    %edi,%ebx
 1ed:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1f3:	5b                   	pop    %ebx
 1f4:	5f                   	pop    %edi
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 203:	90                   	nop
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	8a 10                	mov    (%eax),%dl
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	88 10                	mov    %dl,(%eax)
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8a 00                	mov    (%eax),%al
 213:	84 c0                	test   %al,%al
 215:	0f 95 c0             	setne  %al
 218:	ff 45 08             	incl   0x8(%ebp)
 21b:	ff 45 0c             	incl   0xc(%ebp)
 21e:	84 c0                	test   %al,%al
 220:	75 e2                	jne    204 <strcpy+0xd>
    ;
  return os;
 222:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 225:	c9                   	leave  
 226:	c3                   	ret    

00000227 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 22a:	eb 06                	jmp    232 <strcmp+0xb>
    p++, q++;
 22c:	ff 45 08             	incl   0x8(%ebp)
 22f:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	8a 00                	mov    (%eax),%al
 237:	84 c0                	test   %al,%al
 239:	74 0e                	je     249 <strcmp+0x22>
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	8a 10                	mov    (%eax),%dl
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	38 c2                	cmp    %al,%dl
 247:	74 e3                	je     22c <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	8a 00                	mov    (%eax),%al
 24e:	0f b6 d0             	movzbl %al,%edx
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	8a 00                	mov    (%eax),%al
 256:	0f b6 c0             	movzbl %al,%eax
 259:	89 d1                	mov    %edx,%ecx
 25b:	29 c1                	sub    %eax,%ecx
 25d:	89 c8                	mov    %ecx,%eax
}
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    

00000261 <strlen>:

uint
strlen(char *s)
{
 261:	55                   	push   %ebp
 262:	89 e5                	mov    %esp,%ebp
 264:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 26e:	eb 03                	jmp    273 <strlen+0x12>
 270:	ff 45 fc             	incl   -0x4(%ebp)
 273:	8b 55 fc             	mov    -0x4(%ebp),%edx
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	01 d0                	add    %edx,%eax
 27b:	8a 00                	mov    (%eax),%al
 27d:	84 c0                	test   %al,%al
 27f:	75 ef                	jne    270 <strlen+0xf>
    ;
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memset>:

void*
memset(void *dst, int c, uint n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 28c:	8b 45 10             	mov    0x10(%ebp),%eax
 28f:	89 44 24 08          	mov    %eax,0x8(%esp)
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	89 44 24 04          	mov    %eax,0x4(%esp)
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	89 04 24             	mov    %eax,(%esp)
 2a0:	e8 2d ff ff ff       	call   1d2 <stosb>
  return dst;
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a8:	c9                   	leave  
 2a9:	c3                   	ret    

000002aa <strchr>:

char*
strchr(const char *s, char c)
{
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	83 ec 04             	sub    $0x4,%esp
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2b6:	eb 12                	jmp    2ca <strchr+0x20>
    if(*s == c)
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8a 00                	mov    (%eax),%al
 2bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2c0:	75 05                	jne    2c7 <strchr+0x1d>
      return (char*)s;
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	eb 11                	jmp    2d8 <strchr+0x2e>
  for(; *s; s++)
 2c7:	ff 45 08             	incl   0x8(%ebp)
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	8a 00                	mov    (%eax),%al
 2cf:	84 c0                	test   %al,%al
 2d1:	75 e5                	jne    2b8 <strchr+0xe>
  return 0;
 2d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d8:	c9                   	leave  
 2d9:	c3                   	ret    

000002da <gets>:

char*
gets(char *buf, int max)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2e7:	eb 42                	jmp    32b <gets+0x51>
    cc = read(0, &c, 1);
 2e9:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2f0:	00 
 2f1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ff:	e8 2f 01 00 00       	call   433 <read>
 304:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 307:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30b:	7e 29                	jle    336 <gets+0x5c>
      break;
    buf[i++] = c;
 30d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	01 c2                	add    %eax,%edx
 315:	8a 45 ef             	mov    -0x11(%ebp),%al
 318:	88 02                	mov    %al,(%edx)
 31a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 31d:	8a 45 ef             	mov    -0x11(%ebp),%al
 320:	3c 0a                	cmp    $0xa,%al
 322:	74 13                	je     337 <gets+0x5d>
 324:	8a 45 ef             	mov    -0x11(%ebp),%al
 327:	3c 0d                	cmp    $0xd,%al
 329:	74 0c                	je     337 <gets+0x5d>
  for(i=0; i+1 < max; ){
 32b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32e:	40                   	inc    %eax
 32f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 332:	7c b5                	jl     2e9 <gets+0xf>
 334:	eb 01                	jmp    337 <gets+0x5d>
      break;
 336:	90                   	nop
      break;
  }
  buf[i] = '\0';
 337:	8b 55 f4             	mov    -0xc(%ebp),%edx
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	01 d0                	add    %edx,%eax
 33f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 342:	8b 45 08             	mov    0x8(%ebp),%eax
}
 345:	c9                   	leave  
 346:	c3                   	ret    

00000347 <stat>:

int
stat(char *n, struct stat *st)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 354:	00 
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	89 04 24             	mov    %eax,(%esp)
 35b:	e8 fb 00 00 00       	call   45b <open>
 360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 363:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 367:	79 07                	jns    370 <stat+0x29>
    return -1;
 369:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 36e:	eb 23                	jmp    393 <stat+0x4c>
  r = fstat(fd, st);
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 44 24 04          	mov    %eax,0x4(%esp)
 377:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 f1 00 00 00       	call   473 <fstat>
 382:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 385:	8b 45 f4             	mov    -0xc(%ebp),%eax
 388:	89 04 24             	mov    %eax,(%esp)
 38b:	e8 b3 00 00 00       	call   443 <close>
  return r;
 390:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 393:	c9                   	leave  
 394:	c3                   	ret    

00000395 <atoi>:

int
atoi(const char *s)
{
 395:	55                   	push   %ebp
 396:	89 e5                	mov    %esp,%ebp
 398:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 39b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3a2:	eb 21                	jmp    3c5 <atoi+0x30>
    n = n*10 + *s++ - '0';
 3a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	c1 e0 02             	shl    $0x2,%eax
 3ac:	01 d0                	add    %edx,%eax
 3ae:	d1 e0                	shl    %eax
 3b0:	89 c2                	mov    %eax,%edx
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	8a 00                	mov    (%eax),%al
 3b7:	0f be c0             	movsbl %al,%eax
 3ba:	01 d0                	add    %edx,%eax
 3bc:	83 e8 30             	sub    $0x30,%eax
 3bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3c2:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	8a 00                	mov    (%eax),%al
 3ca:	3c 2f                	cmp    $0x2f,%al
 3cc:	7e 09                	jle    3d7 <atoi+0x42>
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	8a 00                	mov    (%eax),%al
 3d3:	3c 39                	cmp    $0x39,%al
 3d5:	7e cd                	jle    3a4 <atoi+0xf>
  return n;
 3d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3da:	c9                   	leave  
 3db:	c3                   	ret    

000003dc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3dc:	55                   	push   %ebp
 3dd:	89 e5                	mov    %esp,%ebp
 3df:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3ee:	eb 10                	jmp    400 <memmove+0x24>
    *dst++ = *src++;
 3f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f3:	8a 10                	mov    (%eax),%dl
 3f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3f8:	88 10                	mov    %dl,(%eax)
 3fa:	ff 45 fc             	incl   -0x4(%ebp)
 3fd:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 404:	0f 9f c0             	setg   %al
 407:	ff 4d 10             	decl   0x10(%ebp)
 40a:	84 c0                	test   %al,%al
 40c:	75 e2                	jne    3f0 <memmove+0x14>
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <fork>:
 413:	b8 01 00 00 00       	mov    $0x1,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <exit>:
 41b:	b8 02 00 00 00       	mov    $0x2,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <wait>:
 423:	b8 03 00 00 00       	mov    $0x3,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <pipe>:
 42b:	b8 04 00 00 00       	mov    $0x4,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <read>:
 433:	b8 05 00 00 00       	mov    $0x5,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <write>:
 43b:	b8 10 00 00 00       	mov    $0x10,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <close>:
 443:	b8 15 00 00 00       	mov    $0x15,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <kill>:
 44b:	b8 06 00 00 00       	mov    $0x6,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <exec>:
 453:	b8 07 00 00 00       	mov    $0x7,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <open>:
 45b:	b8 0f 00 00 00       	mov    $0xf,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <mknod>:
 463:	b8 11 00 00 00       	mov    $0x11,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <unlink>:
 46b:	b8 12 00 00 00       	mov    $0x12,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <fstat>:
 473:	b8 08 00 00 00       	mov    $0x8,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <link>:
 47b:	b8 13 00 00 00       	mov    $0x13,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <mkdir>:
 483:	b8 14 00 00 00       	mov    $0x14,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <chdir>:
 48b:	b8 09 00 00 00       	mov    $0x9,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <dup>:
 493:	b8 0a 00 00 00       	mov    $0xa,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <getpid>:
 49b:	b8 0b 00 00 00       	mov    $0xb,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sbrk>:
 4a3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <sleep>:
 4ab:	b8 0d 00 00 00       	mov    $0xd,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <uptime>:
 4b3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <lseek>:
 4bb:	b8 16 00 00 00       	mov    $0x16,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <isatty>:
 4c3:	b8 17 00 00 00       	mov    $0x17,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <procstat>:
 4cb:	b8 18 00 00 00       	mov    $0x18,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <set_priority>:
 4d3:	b8 19 00 00 00       	mov    $0x19,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <semget>:
 4db:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <semfree>:
 4e3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <semdown>:
 4eb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <semup>:
 4f3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <shm_create>:
 4fb:	b8 1e 00 00 00       	mov    $0x1e,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <shm_close>:
 503:	b8 1f 00 00 00       	mov    $0x1f,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <shm_get>:
 50b:	b8 20 00 00 00       	mov    $0x20,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 513:	55                   	push   %ebp
 514:	89 e5                	mov    %esp,%ebp
 516:	83 ec 28             	sub    $0x28,%esp
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 51f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 526:	00 
 527:	8d 45 f4             	lea    -0xc(%ebp),%eax
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 02 ff ff ff       	call   43b <write>
}
 539:	c9                   	leave  
 53a:	c3                   	ret    

0000053b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 541:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 548:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 54c:	74 17                	je     565 <printint+0x2a>
 54e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 552:	79 11                	jns    565 <printint+0x2a>
    neg = 1;
 554:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 55b:	8b 45 0c             	mov    0xc(%ebp),%eax
 55e:	f7 d8                	neg    %eax
 560:	89 45 ec             	mov    %eax,-0x14(%ebp)
 563:	eb 06                	jmp    56b <printint+0x30>
  } else {
    x = xx;
 565:	8b 45 0c             	mov    0xc(%ebp),%eax
 568:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 56b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 572:	8b 4d 10             	mov    0x10(%ebp),%ecx
 575:	8b 45 ec             	mov    -0x14(%ebp),%eax
 578:	ba 00 00 00 00       	mov    $0x0,%edx
 57d:	f7 f1                	div    %ecx
 57f:	89 d0                	mov    %edx,%eax
 581:	8a 80 4c 0c 00 00    	mov    0xc4c(%eax),%al
 587:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 58a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 58d:	01 ca                	add    %ecx,%edx
 58f:	88 02                	mov    %al,(%edx)
 591:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 594:	8b 55 10             	mov    0x10(%ebp),%edx
 597:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 59a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59d:	ba 00 00 00 00       	mov    $0x0,%edx
 5a2:	f7 75 d4             	divl   -0x2c(%ebp)
 5a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ac:	75 c4                	jne    572 <printint+0x37>
  if(neg)
 5ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b2:	74 2c                	je     5e0 <printint+0xa5>
    buf[i++] = '-';
 5b4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	01 d0                	add    %edx,%eax
 5bc:	c6 00 2d             	movb   $0x2d,(%eax)
 5bf:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 5c2:	eb 1c                	jmp    5e0 <printint+0xa5>
    putc(fd, buf[i]);
 5c4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ca:	01 d0                	add    %edx,%eax
 5cc:	8a 00                	mov    (%eax),%al
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	89 04 24             	mov    %eax,(%esp)
 5db:	e8 33 ff ff ff       	call   513 <putc>
  while(--i >= 0)
 5e0:	ff 4d f4             	decl   -0xc(%ebp)
 5e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e7:	79 db                	jns    5c4 <printint+0x89>
}
 5e9:	c9                   	leave  
 5ea:	c3                   	ret    

000005eb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5eb:	55                   	push   %ebp
 5ec:	89 e5                	mov    %esp,%ebp
 5ee:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5f8:	8d 45 0c             	lea    0xc(%ebp),%eax
 5fb:	83 c0 04             	add    $0x4,%eax
 5fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 601:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 608:	e9 78 01 00 00       	jmp    785 <printf+0x19a>
    c = fmt[i] & 0xff;
 60d:	8b 55 0c             	mov    0xc(%ebp),%edx
 610:	8b 45 f0             	mov    -0x10(%ebp),%eax
 613:	01 d0                	add    %edx,%eax
 615:	8a 00                	mov    (%eax),%al
 617:	0f be c0             	movsbl %al,%eax
 61a:	25 ff 00 00 00       	and    $0xff,%eax
 61f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 622:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 626:	75 2c                	jne    654 <printf+0x69>
      if(c == '%'){
 628:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62c:	75 0c                	jne    63a <printf+0x4f>
        state = '%';
 62e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 635:	e9 48 01 00 00       	jmp    782 <printf+0x197>
      } else {
        putc(fd, c);
 63a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63d:	0f be c0             	movsbl %al,%eax
 640:	89 44 24 04          	mov    %eax,0x4(%esp)
 644:	8b 45 08             	mov    0x8(%ebp),%eax
 647:	89 04 24             	mov    %eax,(%esp)
 64a:	e8 c4 fe ff ff       	call   513 <putc>
 64f:	e9 2e 01 00 00       	jmp    782 <printf+0x197>
      }
    } else if(state == '%'){
 654:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 658:	0f 85 24 01 00 00    	jne    782 <printf+0x197>
      if(c == 'd'){
 65e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 662:	75 2d                	jne    691 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 664:	8b 45 e8             	mov    -0x18(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 670:	00 
 671:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 678:	00 
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 b3 fe ff ff       	call   53b <printint>
        ap++;
 688:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68c:	e9 ea 00 00 00       	jmp    77b <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 691:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 695:	74 06                	je     69d <printf+0xb2>
 697:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 69b:	75 2d                	jne    6ca <printf+0xdf>
        printint(fd, *ap, 16, 0);
 69d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6a9:	00 
 6aa:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6b1:	00 
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	89 04 24             	mov    %eax,(%esp)
 6bc:	e8 7a fe ff ff       	call   53b <printint>
        ap++;
 6c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c5:	e9 b1 00 00 00       	jmp    77b <printf+0x190>
      } else if(c == 's'){
 6ca:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ce:	75 43                	jne    713 <printf+0x128>
        s = (char*)*ap;
 6d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d3:	8b 00                	mov    (%eax),%eax
 6d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e0:	75 25                	jne    707 <printf+0x11c>
          s = "(null)";
 6e2:	c7 45 f4 e8 09 00 00 	movl   $0x9e8,-0xc(%ebp)
        while(*s != 0){
 6e9:	eb 1c                	jmp    707 <printf+0x11c>
          putc(fd, *s);
 6eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ee:	8a 00                	mov    (%eax),%al
 6f0:	0f be c0             	movsbl %al,%eax
 6f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f7:	8b 45 08             	mov    0x8(%ebp),%eax
 6fa:	89 04 24             	mov    %eax,(%esp)
 6fd:	e8 11 fe ff ff       	call   513 <putc>
          s++;
 702:	ff 45 f4             	incl   -0xc(%ebp)
 705:	eb 01                	jmp    708 <printf+0x11d>
        while(*s != 0){
 707:	90                   	nop
 708:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70b:	8a 00                	mov    (%eax),%al
 70d:	84 c0                	test   %al,%al
 70f:	75 da                	jne    6eb <printf+0x100>
 711:	eb 68                	jmp    77b <printf+0x190>
        }
      } else if(c == 'c'){
 713:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 717:	75 1d                	jne    736 <printf+0x14b>
        putc(fd, *ap);
 719:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	0f be c0             	movsbl %al,%eax
 721:	89 44 24 04          	mov    %eax,0x4(%esp)
 725:	8b 45 08             	mov    0x8(%ebp),%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 e3 fd ff ff       	call   513 <putc>
        ap++;
 730:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 734:	eb 45                	jmp    77b <printf+0x190>
      } else if(c == '%'){
 736:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73a:	75 17                	jne    753 <printf+0x168>
        putc(fd, c);
 73c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73f:	0f be c0             	movsbl %al,%eax
 742:	89 44 24 04          	mov    %eax,0x4(%esp)
 746:	8b 45 08             	mov    0x8(%ebp),%eax
 749:	89 04 24             	mov    %eax,(%esp)
 74c:	e8 c2 fd ff ff       	call   513 <putc>
 751:	eb 28                	jmp    77b <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 753:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 75a:	00 
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	89 04 24             	mov    %eax,(%esp)
 761:	e8 ad fd ff ff       	call   513 <putc>
        putc(fd, c);
 766:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 769:	0f be c0             	movsbl %al,%eax
 76c:	89 44 24 04          	mov    %eax,0x4(%esp)
 770:	8b 45 08             	mov    0x8(%ebp),%eax
 773:	89 04 24             	mov    %eax,(%esp)
 776:	e8 98 fd ff ff       	call   513 <putc>
      }
      state = 0;
 77b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 782:	ff 45 f0             	incl   -0x10(%ebp)
 785:	8b 55 0c             	mov    0xc(%ebp),%edx
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	01 d0                	add    %edx,%eax
 78d:	8a 00                	mov    (%eax),%al
 78f:	84 c0                	test   %al,%al
 791:	0f 85 76 fe ff ff    	jne    60d <printf+0x22>
    }
  }
}
 797:	c9                   	leave  
 798:	c3                   	ret    

00000799 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 799:	55                   	push   %ebp
 79a:	89 e5                	mov    %esp,%ebp
 79c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79f:	8b 45 08             	mov    0x8(%ebp),%eax
 7a2:	83 e8 08             	sub    $0x8,%eax
 7a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	a1 68 0c 00 00       	mov    0xc68,%eax
 7ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b0:	eb 24                	jmp    7d6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ba:	77 12                	ja     7ce <free+0x35>
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c2:	77 24                	ja     7e8 <free+0x4f>
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 00                	mov    (%eax),%eax
 7c9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cc:	77 1a                	ja     7e8 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 00                	mov    (%eax),%eax
 7d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7dc:	76 d4                	jbe    7b2 <free+0x19>
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	8b 00                	mov    (%eax),%eax
 7e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e6:	76 ca                	jbe    7b2 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	01 c2                	add    %eax,%edx
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 00                	mov    (%eax),%eax
 7ff:	39 c2                	cmp    %eax,%edx
 801:	75 24                	jne    827 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 803:	8b 45 f8             	mov    -0x8(%ebp),%eax
 806:	8b 50 04             	mov    0x4(%eax),%edx
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 00                	mov    (%eax),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	01 c2                	add    %eax,%edx
 813:	8b 45 f8             	mov    -0x8(%ebp),%eax
 816:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	8b 10                	mov    (%eax),%edx
 820:	8b 45 f8             	mov    -0x8(%ebp),%eax
 823:	89 10                	mov    %edx,(%eax)
 825:	eb 0a                	jmp    831 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 10                	mov    (%eax),%edx
 82c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 841:	01 d0                	add    %edx,%eax
 843:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 846:	75 20                	jne    868 <free+0xcf>
    p->s.size += bp->s.size;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 50 04             	mov    0x4(%eax),%edx
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	01 c2                	add    %eax,%edx
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
 859:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	8b 10                	mov    (%eax),%edx
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	89 10                	mov    %edx,(%eax)
 866:	eb 08                	jmp    870 <free+0xd7>
  } else
    p->s.ptr = bp;
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86e:	89 10                	mov    %edx,(%eax)
  freep = p;
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 878:	c9                   	leave  
 879:	c3                   	ret    

0000087a <morecore>:

static Header*
morecore(uint nu)
{
 87a:	55                   	push   %ebp
 87b:	89 e5                	mov    %esp,%ebp
 87d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 880:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 887:	77 07                	ja     890 <morecore+0x16>
    nu = 4096;
 889:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 890:	8b 45 08             	mov    0x8(%ebp),%eax
 893:	c1 e0 03             	shl    $0x3,%eax
 896:	89 04 24             	mov    %eax,(%esp)
 899:	e8 05 fc ff ff       	call   4a3 <sbrk>
 89e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a5:	75 07                	jne    8ae <morecore+0x34>
    return 0;
 8a7:	b8 00 00 00 00       	mov    $0x0,%eax
 8ac:	eb 22                	jmp    8d0 <morecore+0x56>
  hp = (Header*)p;
 8ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b7:	8b 55 08             	mov    0x8(%ebp),%edx
 8ba:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	83 c0 08             	add    $0x8,%eax
 8c3:	89 04 24             	mov    %eax,(%esp)
 8c6:	e8 ce fe ff ff       	call   799 <free>
  return freep;
 8cb:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 8d0:	c9                   	leave  
 8d1:	c3                   	ret    

000008d2 <malloc>:

void*
malloc(uint nbytes)
{
 8d2:	55                   	push   %ebp
 8d3:	89 e5                	mov    %esp,%ebp
 8d5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d8:	8b 45 08             	mov    0x8(%ebp),%eax
 8db:	83 c0 07             	add    $0x7,%eax
 8de:	c1 e8 03             	shr    $0x3,%eax
 8e1:	40                   	inc    %eax
 8e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8e5:	a1 68 0c 00 00       	mov    0xc68,%eax
 8ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f1:	75 23                	jne    916 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 8f3:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	a3 68 0c 00 00       	mov    %eax,0xc68
 902:	a1 68 0c 00 00       	mov    0xc68,%eax
 907:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 90c:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 913:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	8b 45 f0             	mov    -0x10(%ebp),%eax
 919:	8b 00                	mov    (%eax),%eax
 91b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	8b 40 04             	mov    0x4(%eax),%eax
 924:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 927:	72 4d                	jb     976 <malloc+0xa4>
      if(p->s.size == nunits)
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	8b 40 04             	mov    0x4(%eax),%eax
 92f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 932:	75 0c                	jne    940 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	8b 10                	mov    (%eax),%edx
 939:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93c:	89 10                	mov    %edx,(%eax)
 93e:	eb 26                	jmp    966 <malloc+0x94>
      else {
        p->s.size -= nunits;
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 40 04             	mov    0x4(%eax),%eax
 946:	89 c2                	mov    %eax,%edx
 948:	2b 55 ec             	sub    -0x14(%ebp),%edx
 94b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	c1 e0 03             	shl    $0x3,%eax
 95a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 95d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 960:	8b 55 ec             	mov    -0x14(%ebp),%edx
 963:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 966:	8b 45 f0             	mov    -0x10(%ebp),%eax
 969:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	83 c0 08             	add    $0x8,%eax
 974:	eb 38                	jmp    9ae <malloc+0xdc>
    }
    if(p == freep)
 976:	a1 68 0c 00 00       	mov    0xc68,%eax
 97b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 97e:	75 1b                	jne    99b <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 980:	8b 45 ec             	mov    -0x14(%ebp),%eax
 983:	89 04 24             	mov    %eax,(%esp)
 986:	e8 ef fe ff ff       	call   87a <morecore>
 98b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 98e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 992:	75 07                	jne    99b <malloc+0xc9>
        return 0;
 994:	b8 00 00 00 00       	mov    $0x0,%eax
 999:	eb 13                	jmp    9ae <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 9a9:	e9 70 ff ff ff       	jmp    91e <malloc+0x4c>
}
 9ae:	c9                   	leave  
 9af:	c3                   	ret    
