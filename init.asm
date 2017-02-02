
_init:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 ad 08 00 00 	movl   $0x8ad,(%esp)
  18:	e8 80 03 00 00       	call   39d <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 ad 08 00 00 	movl   $0x8ad,(%esp)
  38:	e8 68 03 00 00       	call   3a5 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 ad 08 00 00 	movl   $0x8ad,(%esp)
  4c:	e8 4c 03 00 00       	call   39d <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 78 03 00 00       	call   3d5 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 6c 03 00 00       	call   3d5 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 b5 08 00 	movl   $0x8b5,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 65 04 00 00       	call   4e5 <printf>
    pid = fork();
  80:	e8 d0 02 00 00       	call   355 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 c8 08 00 	movl   $0x8c8,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 41 04 00 00       	call   4e5 <printf>
      exit();
  a4:	e8 b4 02 00 00       	call   35d <exit>
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 40 0b 00 	movl   $0xb40,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 aa 08 00 00 	movl   $0x8aa,(%esp)
  bf:	e8 d1 02 00 00       	call   395 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 db 08 00 	movl   $0x8db,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 0d 04 00 00       	call   4e5 <printf>
      exit();
  d8:	e8 80 02 00 00       	call   35d <exit>
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 f1 08 00 	movl   $0x8f1,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 f4 03 00 00       	call   4e5 <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 6f 02 00 00       	call   365 <wait>
  f6:	89 44 24 18          	mov    %eax,0x18(%esp)
  fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ff:	0f 88 66 ff ff ff    	js     6b <main+0x6b>
 105:	8b 44 24 18          	mov    0x18(%esp),%eax
 109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 10d:	75 ce                	jne    dd <main+0xdd>
  }
 10f:	e9 57 ff ff ff       	jmp    6b <main+0x6b>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	8a 10                	mov    (%eax),%dl
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	88 10                	mov    %dl,(%eax)
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8a 00                	mov    (%eax),%al
 155:	84 c0                	test   %al,%al
 157:	0f 95 c0             	setne  %al
 15a:	ff 45 08             	incl   0x8(%ebp)
 15d:	ff 45 0c             	incl   0xc(%ebp)
 160:	84 c0                	test   %al,%al
 162:	75 e2                	jne    146 <strcpy+0xd>
    ;
  return os;
 164:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 167:	c9                   	leave  
 168:	c3                   	ret    

00000169 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16c:	eb 06                	jmp    174 <strcmp+0xb>
    p++, q++;
 16e:	ff 45 08             	incl   0x8(%ebp)
 171:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	84 c0                	test   %al,%al
 17b:	74 0e                	je     18b <strcmp+0x22>
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	8a 10                	mov    (%eax),%dl
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	8a 00                	mov    (%eax),%al
 187:	38 c2                	cmp    %al,%dl
 189:	74 e3                	je     16e <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 00                	mov    (%eax),%al
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	8a 00                	mov    (%eax),%al
 198:	0f b6 c0             	movzbl %al,%eax
 19b:	89 d1                	mov    %edx,%ecx
 19d:	29 c1                	sub    %eax,%ecx
 19f:	89 c8                	mov    %ecx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 03                	jmp    1b5 <strlen+0x12>
 1b2:	ff 45 fc             	incl   -0x4(%ebp)
 1b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 d0                	add    %edx,%eax
 1bd:	8a 00                	mov    (%eax),%al
 1bf:	84 c0                	test   %al,%al
 1c1:	75 ef                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c6:	c9                   	leave  
 1c7:	c3                   	ret    

000001c8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c8:	55                   	push   %ebp
 1c9:	89 e5                	mov    %esp,%ebp
 1cb:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1dc:	8b 45 08             	mov    0x8(%ebp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 2d ff ff ff       	call   114 <stosb>
  return dst;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <strchr>:

char*
strchr(const char *s, char c)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f8:	eb 12                	jmp    20c <strchr+0x20>
    if(*s == c)
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	8a 00                	mov    (%eax),%al
 1ff:	3a 45 fc             	cmp    -0x4(%ebp),%al
 202:	75 05                	jne    209 <strchr+0x1d>
      return (char*)s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	eb 11                	jmp    21a <strchr+0x2e>
  for(; *s; s++)
 209:	ff 45 08             	incl   0x8(%ebp)
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8a 00                	mov    (%eax),%al
 211:	84 c0                	test   %al,%al
 213:	75 e5                	jne    1fa <strchr+0xe>
  return 0;
 215:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <gets>:

char*
gets(char *buf, int max)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
 21f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 229:	eb 42                	jmp    26d <gets+0x51>
    cc = read(0, &c, 1);
 22b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 232:	00 
 233:	8d 45 ef             	lea    -0x11(%ebp),%eax
 236:	89 44 24 04          	mov    %eax,0x4(%esp)
 23a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 241:	e8 2f 01 00 00       	call   375 <read>
 246:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 249:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24d:	7e 29                	jle    278 <gets+0x5c>
      break;
    buf[i++] = c;
 24f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	01 c2                	add    %eax,%edx
 257:	8a 45 ef             	mov    -0x11(%ebp),%al
 25a:	88 02                	mov    %al,(%edx)
 25c:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 25f:	8a 45 ef             	mov    -0x11(%ebp),%al
 262:	3c 0a                	cmp    $0xa,%al
 264:	74 13                	je     279 <gets+0x5d>
 266:	8a 45 ef             	mov    -0x11(%ebp),%al
 269:	3c 0d                	cmp    $0xd,%al
 26b:	74 0c                	je     279 <gets+0x5d>
  for(i=0; i+1 < max; ){
 26d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 270:	40                   	inc    %eax
 271:	3b 45 0c             	cmp    0xc(%ebp),%eax
 274:	7c b5                	jl     22b <gets+0xf>
 276:	eb 01                	jmp    279 <gets+0x5d>
      break;
 278:	90                   	nop
      break;
  }
  buf[i] = '\0';
 279:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	01 d0                	add    %edx,%eax
 281:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 284:	8b 45 08             	mov    0x8(%ebp),%eax
}
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <stat>:

int
stat(char *n, struct stat *st)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 296:	00 
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 fb 00 00 00       	call   39d <open>
 2a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a9:	79 07                	jns    2b2 <stat+0x29>
    return -1;
 2ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b0:	eb 23                	jmp    2d5 <stat+0x4c>
  r = fstat(fd, st);
 2b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bc:	89 04 24             	mov    %eax,(%esp)
 2bf:	e8 f1 00 00 00       	call   3b5 <fstat>
 2c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 b3 00 00 00       	call   385 <close>
  return r;
 2d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <atoi>:

int
atoi(const char *s)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e4:	eb 21                	jmp    307 <atoi+0x30>
    n = n*10 + *s++ - '0';
 2e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e9:	89 d0                	mov    %edx,%eax
 2eb:	c1 e0 02             	shl    $0x2,%eax
 2ee:	01 d0                	add    %edx,%eax
 2f0:	d1 e0                	shl    %eax
 2f2:	89 c2                	mov    %eax,%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	8a 00                	mov    (%eax),%al
 2f9:	0f be c0             	movsbl %al,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	83 e8 30             	sub    $0x30,%eax
 301:	89 45 fc             	mov    %eax,-0x4(%ebp)
 304:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	8a 00                	mov    (%eax),%al
 30c:	3c 2f                	cmp    $0x2f,%al
 30e:	7e 09                	jle    319 <atoi+0x42>
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8a 00                	mov    (%eax),%al
 315:	3c 39                	cmp    $0x39,%al
 317:	7e cd                	jle    2e6 <atoi+0xf>
  return n;
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 330:	eb 10                	jmp    342 <memmove+0x24>
    *dst++ = *src++;
 332:	8b 45 f8             	mov    -0x8(%ebp),%eax
 335:	8a 10                	mov    (%eax),%dl
 337:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33a:	88 10                	mov    %dl,(%eax)
 33c:	ff 45 fc             	incl   -0x4(%ebp)
 33f:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 342:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 346:	0f 9f c0             	setg   %al
 349:	ff 4d 10             	decl   0x10(%ebp)
 34c:	84 c0                	test   %al,%al
 34e:	75 e2                	jne    332 <memmove+0x14>
  return vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <fork>:
 355:	b8 01 00 00 00       	mov    $0x1,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <exit>:
 35d:	b8 02 00 00 00       	mov    $0x2,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <wait>:
 365:	b8 03 00 00 00       	mov    $0x3,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <pipe>:
 36d:	b8 04 00 00 00       	mov    $0x4,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <read>:
 375:	b8 05 00 00 00       	mov    $0x5,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <write>:
 37d:	b8 10 00 00 00       	mov    $0x10,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <close>:
 385:	b8 15 00 00 00       	mov    $0x15,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <kill>:
 38d:	b8 06 00 00 00       	mov    $0x6,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <exec>:
 395:	b8 07 00 00 00       	mov    $0x7,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <open>:
 39d:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <mknod>:
 3a5:	b8 11 00 00 00       	mov    $0x11,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <unlink>:
 3ad:	b8 12 00 00 00       	mov    $0x12,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <fstat>:
 3b5:	b8 08 00 00 00       	mov    $0x8,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <link>:
 3bd:	b8 13 00 00 00       	mov    $0x13,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <mkdir>:
 3c5:	b8 14 00 00 00       	mov    $0x14,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <chdir>:
 3cd:	b8 09 00 00 00       	mov    $0x9,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <dup>:
 3d5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <getpid>:
 3dd:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <sbrk>:
 3e5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <sleep>:
 3ed:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <uptime>:
 3f5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <lseek>:
 3fd:	b8 16 00 00 00       	mov    $0x16,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <isatty>:
 405:	b8 17 00 00 00       	mov    $0x17,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
 410:	83 ec 28             	sub    $0x28,%esp
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 419:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 420:	00 
 421:	8d 45 f4             	lea    -0xc(%ebp),%eax
 424:	89 44 24 04          	mov    %eax,0x4(%esp)
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	89 04 24             	mov    %eax,(%esp)
 42e:	e8 4a ff ff ff       	call   37d <write>
}
 433:	c9                   	leave  
 434:	c3                   	ret    

00000435 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 435:	55                   	push   %ebp
 436:	89 e5                	mov    %esp,%ebp
 438:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 43b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 442:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 446:	74 17                	je     45f <printint+0x2a>
 448:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 44c:	79 11                	jns    45f <printint+0x2a>
    neg = 1;
 44e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	f7 d8                	neg    %eax
 45a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 45d:	eb 06                	jmp    465 <printint+0x30>
  } else {
    x = xx;
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 465:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 46c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 46f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 472:	ba 00 00 00 00       	mov    $0x0,%edx
 477:	f7 f1                	div    %ecx
 479:	89 d0                	mov    %edx,%eax
 47b:	8a 80 48 0b 00 00    	mov    0xb48(%eax),%al
 481:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 484:	8b 55 f4             	mov    -0xc(%ebp),%edx
 487:	01 ca                	add    %ecx,%edx
 489:	88 02                	mov    %al,(%edx)
 48b:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 48e:	8b 55 10             	mov    0x10(%ebp),%edx
 491:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 494:	8b 45 ec             	mov    -0x14(%ebp),%eax
 497:	ba 00 00 00 00       	mov    $0x0,%edx
 49c:	f7 75 d4             	divl   -0x2c(%ebp)
 49f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4a6:	75 c4                	jne    46c <printint+0x37>
  if(neg)
 4a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ac:	74 2c                	je     4da <printint+0xa5>
    buf[i++] = '-';
 4ae:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	c6 00 2d             	movb   $0x2d,(%eax)
 4b9:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4bc:	eb 1c                	jmp    4da <printint+0xa5>
    putc(fd, buf[i]);
 4be:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c4:	01 d0                	add    %edx,%eax
 4c6:	8a 00                	mov    (%eax),%al
 4c8:	0f be c0             	movsbl %al,%eax
 4cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	89 04 24             	mov    %eax,(%esp)
 4d5:	e8 33 ff ff ff       	call   40d <putc>
  while(--i >= 0)
 4da:	ff 4d f4             	decl   -0xc(%ebp)
 4dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e1:	79 db                	jns    4be <printint+0x89>
}
 4e3:	c9                   	leave  
 4e4:	c3                   	ret    

000004e5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4e5:	55                   	push   %ebp
 4e6:	89 e5                	mov    %esp,%ebp
 4e8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4f2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4f5:	83 c0 04             	add    $0x4,%eax
 4f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 502:	e9 78 01 00 00       	jmp    67f <printf+0x19a>
    c = fmt[i] & 0xff;
 507:	8b 55 0c             	mov    0xc(%ebp),%edx
 50a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 50d:	01 d0                	add    %edx,%eax
 50f:	8a 00                	mov    (%eax),%al
 511:	0f be c0             	movsbl %al,%eax
 514:	25 ff 00 00 00       	and    $0xff,%eax
 519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 51c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 520:	75 2c                	jne    54e <printf+0x69>
      if(c == '%'){
 522:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 526:	75 0c                	jne    534 <printf+0x4f>
        state = '%';
 528:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 52f:	e9 48 01 00 00       	jmp    67c <printf+0x197>
      } else {
        putc(fd, c);
 534:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 537:	0f be c0             	movsbl %al,%eax
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 c4 fe ff ff       	call   40d <putc>
 549:	e9 2e 01 00 00       	jmp    67c <printf+0x197>
      }
    } else if(state == '%'){
 54e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 552:	0f 85 24 01 00 00    	jne    67c <printf+0x197>
      if(c == 'd'){
 558:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 55c:	75 2d                	jne    58b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 55e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 561:	8b 00                	mov    (%eax),%eax
 563:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 56a:	00 
 56b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 572:	00 
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	8b 45 08             	mov    0x8(%ebp),%eax
 57a:	89 04 24             	mov    %eax,(%esp)
 57d:	e8 b3 fe ff ff       	call   435 <printint>
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	e9 ea 00 00 00       	jmp    675 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 58b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 58f:	74 06                	je     597 <printf+0xb2>
 591:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 595:	75 2d                	jne    5c4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 597:	8b 45 e8             	mov    -0x18(%ebp),%eax
 59a:	8b 00                	mov    (%eax),%eax
 59c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5a3:	00 
 5a4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ab:	00 
 5ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	89 04 24             	mov    %eax,(%esp)
 5b6:	e8 7a fe ff ff       	call   435 <printint>
        ap++;
 5bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5bf:	e9 b1 00 00 00       	jmp    675 <printf+0x190>
      } else if(c == 's'){
 5c4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c8:	75 43                	jne    60d <printf+0x128>
        s = (char*)*ap;
 5ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cd:	8b 00                	mov    (%eax),%eax
 5cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5da:	75 25                	jne    601 <printf+0x11c>
          s = "(null)";
 5dc:	c7 45 f4 fa 08 00 00 	movl   $0x8fa,-0xc(%ebp)
        while(*s != 0){
 5e3:	eb 1c                	jmp    601 <printf+0x11c>
          putc(fd, *s);
 5e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e8:	8a 00                	mov    (%eax),%al
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f1:	8b 45 08             	mov    0x8(%ebp),%eax
 5f4:	89 04 24             	mov    %eax,(%esp)
 5f7:	e8 11 fe ff ff       	call   40d <putc>
          s++;
 5fc:	ff 45 f4             	incl   -0xc(%ebp)
 5ff:	eb 01                	jmp    602 <printf+0x11d>
        while(*s != 0){
 601:	90                   	nop
 602:	8b 45 f4             	mov    -0xc(%ebp),%eax
 605:	8a 00                	mov    (%eax),%al
 607:	84 c0                	test   %al,%al
 609:	75 da                	jne    5e5 <printf+0x100>
 60b:	eb 68                	jmp    675 <printf+0x190>
        }
      } else if(c == 'c'){
 60d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 611:	75 1d                	jne    630 <printf+0x14b>
        putc(fd, *ap);
 613:	8b 45 e8             	mov    -0x18(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	0f be c0             	movsbl %al,%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 e3 fd ff ff       	call   40d <putc>
        ap++;
 62a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62e:	eb 45                	jmp    675 <printf+0x190>
      } else if(c == '%'){
 630:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 634:	75 17                	jne    64d <printf+0x168>
        putc(fd, c);
 636:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 639:	0f be c0             	movsbl %al,%eax
 63c:	89 44 24 04          	mov    %eax,0x4(%esp)
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	89 04 24             	mov    %eax,(%esp)
 646:	e8 c2 fd ff ff       	call   40d <putc>
 64b:	eb 28                	jmp    675 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 654:	00 
 655:	8b 45 08             	mov    0x8(%ebp),%eax
 658:	89 04 24             	mov    %eax,(%esp)
 65b:	e8 ad fd ff ff       	call   40d <putc>
        putc(fd, c);
 660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 663:	0f be c0             	movsbl %al,%eax
 666:	89 44 24 04          	mov    %eax,0x4(%esp)
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	89 04 24             	mov    %eax,(%esp)
 670:	e8 98 fd ff ff       	call   40d <putc>
      }
      state = 0;
 675:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 67c:	ff 45 f0             	incl   -0x10(%ebp)
 67f:	8b 55 0c             	mov    0xc(%ebp),%edx
 682:	8b 45 f0             	mov    -0x10(%ebp),%eax
 685:	01 d0                	add    %edx,%eax
 687:	8a 00                	mov    (%eax),%al
 689:	84 c0                	test   %al,%al
 68b:	0f 85 76 fe ff ff    	jne    507 <printf+0x22>
    }
  }
}
 691:	c9                   	leave  
 692:	c3                   	ret    

00000693 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 699:	8b 45 08             	mov    0x8(%ebp),%eax
 69c:	83 e8 08             	sub    $0x8,%eax
 69f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a2:	a1 64 0b 00 00       	mov    0xb64,%eax
 6a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6aa:	eb 24                	jmp    6d0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6af:	8b 00                	mov    (%eax),%eax
 6b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b4:	77 12                	ja     6c8 <free+0x35>
 6b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bc:	77 24                	ja     6e2 <free+0x4f>
 6be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c1:	8b 00                	mov    (%eax),%eax
 6c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c6:	77 1a                	ja     6e2 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d6:	76 d4                	jbe    6ac <free+0x19>
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e0:	76 ca                	jbe    6ac <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	8b 40 04             	mov    0x4(%eax),%eax
 6e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	01 c2                	add    %eax,%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	39 c2                	cmp    %eax,%edx
 6fb:	75 24                	jne    721 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 700:	8b 50 04             	mov    0x4(%eax),%edx
 703:	8b 45 fc             	mov    -0x4(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	8b 40 04             	mov    0x4(%eax),%eax
 70b:	01 c2                	add    %eax,%edx
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	8b 10                	mov    (%eax),%edx
 71a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71d:	89 10                	mov    %edx,(%eax)
 71f:	eb 0a                	jmp    72b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	8b 10                	mov    (%eax),%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 40 04             	mov    0x4(%eax),%eax
 731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	01 d0                	add    %edx,%eax
 73d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 740:	75 20                	jne    762 <free+0xcf>
    p->s.size += bp->s.size;
 742:	8b 45 fc             	mov    -0x4(%ebp),%eax
 745:	8b 50 04             	mov    0x4(%eax),%edx
 748:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	01 c2                	add    %eax,%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	8b 10                	mov    (%eax),%edx
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	89 10                	mov    %edx,(%eax)
 760:	eb 08                	jmp    76a <free+0xd7>
  } else
    p->s.ptr = bp;
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 55 f8             	mov    -0x8(%ebp),%edx
 768:	89 10                	mov    %edx,(%eax)
  freep = p;
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	a3 64 0b 00 00       	mov    %eax,0xb64
}
 772:	c9                   	leave  
 773:	c3                   	ret    

00000774 <morecore>:

static Header*
morecore(uint nu)
{
 774:	55                   	push   %ebp
 775:	89 e5                	mov    %esp,%ebp
 777:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 781:	77 07                	ja     78a <morecore+0x16>
    nu = 4096;
 783:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78a:	8b 45 08             	mov    0x8(%ebp),%eax
 78d:	c1 e0 03             	shl    $0x3,%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 4d fc ff ff       	call   3e5 <sbrk>
 798:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 79b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 79f:	75 07                	jne    7a8 <morecore+0x34>
    return 0;
 7a1:	b8 00 00 00 00       	mov    $0x0,%eax
 7a6:	eb 22                	jmp    7ca <morecore+0x56>
  hp = (Header*)p;
 7a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b1:	8b 55 08             	mov    0x8(%ebp),%edx
 7b4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ba:	83 c0 08             	add    $0x8,%eax
 7bd:	89 04 24             	mov    %eax,(%esp)
 7c0:	e8 ce fe ff ff       	call   693 <free>
  return freep;
 7c5:	a1 64 0b 00 00       	mov    0xb64,%eax
}
 7ca:	c9                   	leave  
 7cb:	c3                   	ret    

000007cc <malloc>:

void*
malloc(uint nbytes)
{
 7cc:	55                   	push   %ebp
 7cd:	89 e5                	mov    %esp,%ebp
 7cf:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d2:	8b 45 08             	mov    0x8(%ebp),%eax
 7d5:	83 c0 07             	add    $0x7,%eax
 7d8:	c1 e8 03             	shr    $0x3,%eax
 7db:	40                   	inc    %eax
 7dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7df:	a1 64 0b 00 00       	mov    0xb64,%eax
 7e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7eb:	75 23                	jne    810 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7ed:	c7 45 f0 5c 0b 00 00 	movl   $0xb5c,-0x10(%ebp)
 7f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f7:	a3 64 0b 00 00       	mov    %eax,0xb64
 7fc:	a1 64 0b 00 00       	mov    0xb64,%eax
 801:	a3 5c 0b 00 00       	mov    %eax,0xb5c
    base.s.size = 0;
 806:	c7 05 60 0b 00 00 00 	movl   $0x0,0xb60
 80d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	8b 45 f0             	mov    -0x10(%ebp),%eax
 813:	8b 00                	mov    (%eax),%eax
 815:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 821:	72 4d                	jb     870 <malloc+0xa4>
      if(p->s.size == nunits)
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	8b 40 04             	mov    0x4(%eax),%eax
 829:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82c:	75 0c                	jne    83a <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 82e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 831:	8b 10                	mov    (%eax),%edx
 833:	8b 45 f0             	mov    -0x10(%ebp),%eax
 836:	89 10                	mov    %edx,(%eax)
 838:	eb 26                	jmp    860 <malloc+0x94>
      else {
        p->s.size -= nunits;
 83a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83d:	8b 40 04             	mov    0x4(%eax),%eax
 840:	89 c2                	mov    %eax,%edx
 842:	2b 55 ec             	sub    -0x14(%ebp),%edx
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	8b 40 04             	mov    0x4(%eax),%eax
 851:	c1 e0 03             	shl    $0x3,%eax
 854:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 85d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 860:	8b 45 f0             	mov    -0x10(%ebp),%eax
 863:	a3 64 0b 00 00       	mov    %eax,0xb64
      return (void*)(p + 1);
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	83 c0 08             	add    $0x8,%eax
 86e:	eb 38                	jmp    8a8 <malloc+0xdc>
    }
    if(p == freep)
 870:	a1 64 0b 00 00       	mov    0xb64,%eax
 875:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 878:	75 1b                	jne    895 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 87a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87d:	89 04 24             	mov    %eax,(%esp)
 880:	e8 ef fe ff ff       	call   774 <morecore>
 885:	89 45 f4             	mov    %eax,-0xc(%ebp)
 888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88c:	75 07                	jne    895 <malloc+0xc9>
        return 0;
 88e:	b8 00 00 00 00       	mov    $0x0,%eax
 893:	eb 13                	jmp    8a8 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 895:	8b 45 f4             	mov    -0xc(%ebp),%eax
 898:	89 45 f0             	mov    %eax,-0x10(%ebp)
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 00                	mov    (%eax),%eax
 8a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8a3:	e9 70 ff ff ff       	jmp    818 <malloc+0x4c>
}
 8a8:	c9                   	leave  
 8a9:	c3                   	ret    
