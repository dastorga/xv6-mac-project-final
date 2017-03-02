
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
  11:	c7 04 24 f5 08 00 00 	movl   $0x8f5,(%esp)
  18:	e8 80 03 00 00       	call   39d <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 f5 08 00 00 	movl   $0x8f5,(%esp)
  38:	e8 68 03 00 00       	call   3a5 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 f5 08 00 00 	movl   $0x8f5,(%esp)
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
  6c:	c7 44 24 04 fd 08 00 	movl   $0x8fd,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 ad 04 00 00       	call   52d <printf>
    pid = fork();
  80:	e8 d0 02 00 00       	call   355 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 10 09 00 	movl   $0x910,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 89 04 00 00       	call   52d <printf>
      exit();
  a4:	e8 b4 02 00 00       	call   35d <exit>
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 88 0b 00 	movl   $0xb88,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 f2 08 00 00 	movl   $0x8f2,(%esp)
  bf:	e8 d1 02 00 00       	call   395 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 23 09 00 	movl   $0x923,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 55 04 00 00       	call   52d <printf>
      exit();
  d8:	e8 80 02 00 00       	call   35d <exit>
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 39 09 00 	movl   $0x939,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 3c 04 00 00       	call   52d <printf>
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

0000040d <procstat>:
 40d:	b8 18 00 00 00       	mov    $0x18,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <set_priority>:
 415:	b8 19 00 00 00       	mov    $0x19,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <semget>:
 41d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <semfree>:
 425:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <semdown>:
 42d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <semup>:
 435:	b8 1d 00 00 00       	mov    $0x1d,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <shm_create>:
 43d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <shm_close>:
 445:	b8 1f 00 00 00       	mov    $0x1f,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <shm_get>:
 44d:	b8 20 00 00 00       	mov    $0x20,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 455:	55                   	push   %ebp
 456:	89 e5                	mov    %esp,%ebp
 458:	83 ec 28             	sub    $0x28,%esp
 45b:	8b 45 0c             	mov    0xc(%ebp),%eax
 45e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 468:	00 
 469:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46c:	89 44 24 04          	mov    %eax,0x4(%esp)
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	89 04 24             	mov    %eax,(%esp)
 476:	e8 02 ff ff ff       	call   37d <write>
}
 47b:	c9                   	leave  
 47c:	c3                   	ret    

0000047d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47d:	55                   	push   %ebp
 47e:	89 e5                	mov    %esp,%ebp
 480:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 483:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 48e:	74 17                	je     4a7 <printint+0x2a>
 490:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 494:	79 11                	jns    4a7 <printint+0x2a>
    neg = 1;
 496:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 49d:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a0:	f7 d8                	neg    %eax
 4a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a5:	eb 06                	jmp    4ad <printint+0x30>
  } else {
    x = xx;
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ba:	ba 00 00 00 00       	mov    $0x0,%edx
 4bf:	f7 f1                	div    %ecx
 4c1:	89 d0                	mov    %edx,%eax
 4c3:	8a 80 90 0b 00 00    	mov    0xb90(%eax),%al
 4c9:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 4cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4cf:	01 ca                	add    %ecx,%edx
 4d1:	88 02                	mov    %al,(%edx)
 4d3:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 4d6:	8b 55 10             	mov    0x10(%ebp),%edx
 4d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4df:	ba 00 00 00 00       	mov    $0x0,%edx
 4e4:	f7 75 d4             	divl   -0x2c(%ebp)
 4e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ee:	75 c4                	jne    4b4 <printint+0x37>
  if(neg)
 4f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f4:	74 2c                	je     522 <printint+0xa5>
    buf[i++] = '-';
 4f6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	01 d0                	add    %edx,%eax
 4fe:	c6 00 2d             	movb   $0x2d,(%eax)
 501:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 504:	eb 1c                	jmp    522 <printint+0xa5>
    putc(fd, buf[i]);
 506:	8d 55 dc             	lea    -0x24(%ebp),%edx
 509:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50c:	01 d0                	add    %edx,%eax
 50e:	8a 00                	mov    (%eax),%al
 510:	0f be c0             	movsbl %al,%eax
 513:	89 44 24 04          	mov    %eax,0x4(%esp)
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	89 04 24             	mov    %eax,(%esp)
 51d:	e8 33 ff ff ff       	call   455 <putc>
  while(--i >= 0)
 522:	ff 4d f4             	decl   -0xc(%ebp)
 525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 529:	79 db                	jns    506 <printint+0x89>
}
 52b:	c9                   	leave  
 52c:	c3                   	ret    

0000052d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 52d:	55                   	push   %ebp
 52e:	89 e5                	mov    %esp,%ebp
 530:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 533:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53a:	8d 45 0c             	lea    0xc(%ebp),%eax
 53d:	83 c0 04             	add    $0x4,%eax
 540:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 543:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54a:	e9 78 01 00 00       	jmp    6c7 <printf+0x19a>
    c = fmt[i] & 0xff;
 54f:	8b 55 0c             	mov    0xc(%ebp),%edx
 552:	8b 45 f0             	mov    -0x10(%ebp),%eax
 555:	01 d0                	add    %edx,%eax
 557:	8a 00                	mov    (%eax),%al
 559:	0f be c0             	movsbl %al,%eax
 55c:	25 ff 00 00 00       	and    $0xff,%eax
 561:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 564:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 568:	75 2c                	jne    596 <printf+0x69>
      if(c == '%'){
 56a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 56e:	75 0c                	jne    57c <printf+0x4f>
        state = '%';
 570:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 577:	e9 48 01 00 00       	jmp    6c4 <printf+0x197>
      } else {
        putc(fd, c);
 57c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 57f:	0f be c0             	movsbl %al,%eax
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	89 04 24             	mov    %eax,(%esp)
 58c:	e8 c4 fe ff ff       	call   455 <putc>
 591:	e9 2e 01 00 00       	jmp    6c4 <printf+0x197>
      }
    } else if(state == '%'){
 596:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59a:	0f 85 24 01 00 00    	jne    6c4 <printf+0x197>
      if(c == 'd'){
 5a0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a4:	75 2d                	jne    5d3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 5a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a9:	8b 00                	mov    (%eax),%eax
 5ab:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b2:	00 
 5b3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5ba:	00 
 5bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	89 04 24             	mov    %eax,(%esp)
 5c5:	e8 b3 fe ff ff       	call   47d <printint>
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5ce:	e9 ea 00 00 00       	jmp    6bd <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 5d3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d7:	74 06                	je     5df <printf+0xb2>
 5d9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5dd:	75 2d                	jne    60c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e2:	8b 00                	mov    (%eax),%eax
 5e4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5eb:	00 
 5ec:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5f3:	00 
 5f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f8:	8b 45 08             	mov    0x8(%ebp),%eax
 5fb:	89 04 24             	mov    %eax,(%esp)
 5fe:	e8 7a fe ff ff       	call   47d <printint>
        ap++;
 603:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 607:	e9 b1 00 00 00       	jmp    6bd <printf+0x190>
      } else if(c == 's'){
 60c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 610:	75 43                	jne    655 <printf+0x128>
        s = (char*)*ap;
 612:	8b 45 e8             	mov    -0x18(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 61e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 622:	75 25                	jne    649 <printf+0x11c>
          s = "(null)";
 624:	c7 45 f4 42 09 00 00 	movl   $0x942,-0xc(%ebp)
        while(*s != 0){
 62b:	eb 1c                	jmp    649 <printf+0x11c>
          putc(fd, *s);
 62d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 630:	8a 00                	mov    (%eax),%al
 632:	0f be c0             	movsbl %al,%eax
 635:	89 44 24 04          	mov    %eax,0x4(%esp)
 639:	8b 45 08             	mov    0x8(%ebp),%eax
 63c:	89 04 24             	mov    %eax,(%esp)
 63f:	e8 11 fe ff ff       	call   455 <putc>
          s++;
 644:	ff 45 f4             	incl   -0xc(%ebp)
 647:	eb 01                	jmp    64a <printf+0x11d>
        while(*s != 0){
 649:	90                   	nop
 64a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64d:	8a 00                	mov    (%eax),%al
 64f:	84 c0                	test   %al,%al
 651:	75 da                	jne    62d <printf+0x100>
 653:	eb 68                	jmp    6bd <printf+0x190>
        }
      } else if(c == 'c'){
 655:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 659:	75 1d                	jne    678 <printf+0x14b>
        putc(fd, *ap);
 65b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65e:	8b 00                	mov    (%eax),%eax
 660:	0f be c0             	movsbl %al,%eax
 663:	89 44 24 04          	mov    %eax,0x4(%esp)
 667:	8b 45 08             	mov    0x8(%ebp),%eax
 66a:	89 04 24             	mov    %eax,(%esp)
 66d:	e8 e3 fd ff ff       	call   455 <putc>
        ap++;
 672:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 676:	eb 45                	jmp    6bd <printf+0x190>
      } else if(c == '%'){
 678:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 67c:	75 17                	jne    695 <printf+0x168>
        putc(fd, c);
 67e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 681:	0f be c0             	movsbl %al,%eax
 684:	89 44 24 04          	mov    %eax,0x4(%esp)
 688:	8b 45 08             	mov    0x8(%ebp),%eax
 68b:	89 04 24             	mov    %eax,(%esp)
 68e:	e8 c2 fd ff ff       	call   455 <putc>
 693:	eb 28                	jmp    6bd <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 695:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 69c:	00 
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	89 04 24             	mov    %eax,(%esp)
 6a3:	e8 ad fd ff ff       	call   455 <putc>
        putc(fd, c);
 6a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ab:	0f be c0             	movsbl %al,%eax
 6ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b2:	8b 45 08             	mov    0x8(%ebp),%eax
 6b5:	89 04 24             	mov    %eax,(%esp)
 6b8:	e8 98 fd ff ff       	call   455 <putc>
      }
      state = 0;
 6bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6c4:	ff 45 f0             	incl   -0x10(%ebp)
 6c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cd:	01 d0                	add    %edx,%eax
 6cf:	8a 00                	mov    (%eax),%al
 6d1:	84 c0                	test   %al,%al
 6d3:	0f 85 76 fe ff ff    	jne    54f <printf+0x22>
    }
  }
}
 6d9:	c9                   	leave  
 6da:	c3                   	ret    

000006db <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6db:	55                   	push   %ebp
 6dc:	89 e5                	mov    %esp,%ebp
 6de:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	83 e8 08             	sub    $0x8,%eax
 6e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ea:	a1 ac 0b 00 00       	mov    0xbac,%eax
 6ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f2:	eb 24                	jmp    718 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6fc:	77 12                	ja     710 <free+0x35>
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 704:	77 24                	ja     72a <free+0x4f>
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70e:	77 1a                	ja     72a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 710:	8b 45 fc             	mov    -0x4(%ebp),%eax
 713:	8b 00                	mov    (%eax),%eax
 715:	89 45 fc             	mov    %eax,-0x4(%ebp)
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71e:	76 d4                	jbe    6f4 <free+0x19>
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 728:	76 ca                	jbe    6f4 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	8b 40 04             	mov    0x4(%eax),%eax
 730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	01 c2                	add    %eax,%edx
 73c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	39 c2                	cmp    %eax,%edx
 743:	75 24                	jne    769 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	8b 50 04             	mov    0x4(%eax),%edx
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	8b 40 04             	mov    0x4(%eax),%eax
 753:	01 c2                	add    %eax,%edx
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	8b 10                	mov    (%eax),%edx
 762:	8b 45 f8             	mov    -0x8(%ebp),%eax
 765:	89 10                	mov    %edx,(%eax)
 767:	eb 0a                	jmp    773 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 10                	mov    (%eax),%edx
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	8b 40 04             	mov    0x4(%eax),%eax
 779:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 780:	8b 45 fc             	mov    -0x4(%ebp),%eax
 783:	01 d0                	add    %edx,%eax
 785:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 788:	75 20                	jne    7aa <free+0xcf>
    p->s.size += bp->s.size;
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	01 c2                	add    %eax,%edx
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 10                	mov    (%eax),%edx
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	89 10                	mov    %edx,(%eax)
 7a8:	eb 08                	jmp    7b2 <free+0xd7>
  } else
    p->s.ptr = bp;
 7aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	a3 ac 0b 00 00       	mov    %eax,0xbac
}
 7ba:	c9                   	leave  
 7bb:	c3                   	ret    

000007bc <morecore>:

static Header*
morecore(uint nu)
{
 7bc:	55                   	push   %ebp
 7bd:	89 e5                	mov    %esp,%ebp
 7bf:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c9:	77 07                	ja     7d2 <morecore+0x16>
    nu = 4096;
 7cb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d2:	8b 45 08             	mov    0x8(%ebp),%eax
 7d5:	c1 e0 03             	shl    $0x3,%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 05 fc ff ff       	call   3e5 <sbrk>
 7e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e7:	75 07                	jne    7f0 <morecore+0x34>
    return 0;
 7e9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ee:	eb 22                	jmp    812 <morecore+0x56>
  hp = (Header*)p;
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	8b 55 08             	mov    0x8(%ebp),%edx
 7fc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	83 c0 08             	add    $0x8,%eax
 805:	89 04 24             	mov    %eax,(%esp)
 808:	e8 ce fe ff ff       	call   6db <free>
  return freep;
 80d:	a1 ac 0b 00 00       	mov    0xbac,%eax
}
 812:	c9                   	leave  
 813:	c3                   	ret    

00000814 <malloc>:

void*
malloc(uint nbytes)
{
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	83 c0 07             	add    $0x7,%eax
 820:	c1 e8 03             	shr    $0x3,%eax
 823:	40                   	inc    %eax
 824:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 827:	a1 ac 0b 00 00       	mov    0xbac,%eax
 82c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 82f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 833:	75 23                	jne    858 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 835:	c7 45 f0 a4 0b 00 00 	movl   $0xba4,-0x10(%ebp)
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	a3 ac 0b 00 00       	mov    %eax,0xbac
 844:	a1 ac 0b 00 00       	mov    0xbac,%eax
 849:	a3 a4 0b 00 00       	mov    %eax,0xba4
    base.s.size = 0;
 84e:	c7 05 a8 0b 00 00 00 	movl   $0x0,0xba8
 855:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	8b 00                	mov    (%eax),%eax
 85d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 869:	72 4d                	jb     8b8 <malloc+0xa4>
      if(p->s.size == nunits)
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 40 04             	mov    0x4(%eax),%eax
 871:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 874:	75 0c                	jne    882 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 10                	mov    (%eax),%edx
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	89 10                	mov    %edx,(%eax)
 880:	eb 26                	jmp    8a8 <malloc+0x94>
      else {
        p->s.size -= nunits;
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	8b 40 04             	mov    0x4(%eax),%eax
 888:	89 c2                	mov    %eax,%edx
 88a:	2b 55 ec             	sub    -0x14(%ebp),%edx
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	c1 e0 03             	shl    $0x3,%eax
 89c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ab:	a3 ac 0b 00 00       	mov    %eax,0xbac
      return (void*)(p + 1);
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	83 c0 08             	add    $0x8,%eax
 8b6:	eb 38                	jmp    8f0 <malloc+0xdc>
    }
    if(p == freep)
 8b8:	a1 ac 0b 00 00       	mov    0xbac,%eax
 8bd:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c0:	75 1b                	jne    8dd <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 8c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c5:	89 04 24             	mov    %eax,(%esp)
 8c8:	e8 ef fe ff ff       	call   7bc <morecore>
 8cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d4:	75 07                	jne    8dd <malloc+0xc9>
        return 0;
 8d6:	b8 00 00 00 00       	mov    $0x0,%eax
 8db:	eb 13                	jmp    8f0 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	8b 00                	mov    (%eax),%eax
 8e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8eb:	e9 70 ff ff ff       	jmp    860 <malloc+0x4c>
}
 8f0:	c9                   	leave  
 8f1:	c3                   	ret    
