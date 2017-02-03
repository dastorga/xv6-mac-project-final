
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
  11:	c7 04 24 bd 08 00 00 	movl   $0x8bd,(%esp)
  18:	e8 80 03 00 00       	call   39d <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 bd 08 00 00 	movl   $0x8bd,(%esp)
  38:	e8 68 03 00 00       	call   3a5 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 bd 08 00 00 	movl   $0x8bd,(%esp)
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
  6c:	c7 44 24 04 c5 08 00 	movl   $0x8c5,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 75 04 00 00       	call   4f5 <printf>
    pid = fork();
  80:	e8 d0 02 00 00       	call   355 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 d8 08 00 	movl   $0x8d8,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 51 04 00 00       	call   4f5 <printf>
      exit();
  a4:	e8 b4 02 00 00       	call   35d <exit>
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 50 0b 00 	movl   $0xb50,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 ba 08 00 00 	movl   $0x8ba,(%esp)
  bf:	e8 d1 02 00 00       	call   395 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 eb 08 00 	movl   $0x8eb,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 1d 04 00 00       	call   4f5 <printf>
      exit();
  d8:	e8 80 02 00 00       	call   35d <exit>
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 01 09 00 	movl   $0x901,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 04 04 00 00       	call   4f5 <printf>
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

0000041d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 41d:	55                   	push   %ebp
 41e:	89 e5                	mov    %esp,%ebp
 420:	83 ec 28             	sub    $0x28,%esp
 423:	8b 45 0c             	mov    0xc(%ebp),%eax
 426:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 429:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 430:	00 
 431:	8d 45 f4             	lea    -0xc(%ebp),%eax
 434:	89 44 24 04          	mov    %eax,0x4(%esp)
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	89 04 24             	mov    %eax,(%esp)
 43e:	e8 3a ff ff ff       	call   37d <write>
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 452:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 456:	74 17                	je     46f <printint+0x2a>
 458:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 45c:	79 11                	jns    46f <printint+0x2a>
    neg = 1;
 45e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 465:	8b 45 0c             	mov    0xc(%ebp),%eax
 468:	f7 d8                	neg    %eax
 46a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 46d:	eb 06                	jmp    475 <printint+0x30>
  } else {
    x = xx;
 46f:	8b 45 0c             	mov    0xc(%ebp),%eax
 472:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 475:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 47c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 47f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 482:	ba 00 00 00 00       	mov    $0x0,%edx
 487:	f7 f1                	div    %ecx
 489:	89 d0                	mov    %edx,%eax
 48b:	8a 80 58 0b 00 00    	mov    0xb58(%eax),%al
 491:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 494:	8b 55 f4             	mov    -0xc(%ebp),%edx
 497:	01 ca                	add    %ecx,%edx
 499:	88 02                	mov    %al,(%edx)
 49b:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 49e:	8b 55 10             	mov    0x10(%ebp),%edx
 4a1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a7:	ba 00 00 00 00       	mov    $0x0,%edx
 4ac:	f7 75 d4             	divl   -0x2c(%ebp)
 4af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b6:	75 c4                	jne    47c <printint+0x37>
  if(neg)
 4b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bc:	74 2c                	je     4ea <printint+0xa5>
    buf[i++] = '-';
 4be:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c4:	01 d0                	add    %edx,%eax
 4c6:	c6 00 2d             	movb   $0x2d,(%eax)
 4c9:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 4cc:	eb 1c                	jmp    4ea <printint+0xa5>
    putc(fd, buf[i]);
 4ce:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d4:	01 d0                	add    %edx,%eax
 4d6:	8a 00                	mov    (%eax),%al
 4d8:	0f be c0             	movsbl %al,%eax
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 33 ff ff ff       	call   41d <putc>
  while(--i >= 0)
 4ea:	ff 4d f4             	decl   -0xc(%ebp)
 4ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f1:	79 db                	jns    4ce <printint+0x89>
}
 4f3:	c9                   	leave  
 4f4:	c3                   	ret    

000004f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4f5:	55                   	push   %ebp
 4f6:	89 e5                	mov    %esp,%ebp
 4f8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 502:	8d 45 0c             	lea    0xc(%ebp),%eax
 505:	83 c0 04             	add    $0x4,%eax
 508:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 50b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 512:	e9 78 01 00 00       	jmp    68f <printf+0x19a>
    c = fmt[i] & 0xff;
 517:	8b 55 0c             	mov    0xc(%ebp),%edx
 51a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 51d:	01 d0                	add    %edx,%eax
 51f:	8a 00                	mov    (%eax),%al
 521:	0f be c0             	movsbl %al,%eax
 524:	25 ff 00 00 00       	and    $0xff,%eax
 529:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 52c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 530:	75 2c                	jne    55e <printf+0x69>
      if(c == '%'){
 532:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 536:	75 0c                	jne    544 <printf+0x4f>
        state = '%';
 538:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 53f:	e9 48 01 00 00       	jmp    68c <printf+0x197>
      } else {
        putc(fd, c);
 544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 547:	0f be c0             	movsbl %al,%eax
 54a:	89 44 24 04          	mov    %eax,0x4(%esp)
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	89 04 24             	mov    %eax,(%esp)
 554:	e8 c4 fe ff ff       	call   41d <putc>
 559:	e9 2e 01 00 00       	jmp    68c <printf+0x197>
      }
    } else if(state == '%'){
 55e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 562:	0f 85 24 01 00 00    	jne    68c <printf+0x197>
      if(c == 'd'){
 568:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 56c:	75 2d                	jne    59b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 56e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 571:	8b 00                	mov    (%eax),%eax
 573:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 57a:	00 
 57b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 582:	00 
 583:	89 44 24 04          	mov    %eax,0x4(%esp)
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	89 04 24             	mov    %eax,(%esp)
 58d:	e8 b3 fe ff ff       	call   445 <printint>
        ap++;
 592:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 596:	e9 ea 00 00 00       	jmp    685 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 59b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 59f:	74 06                	je     5a7 <printf+0xb2>
 5a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a5:	75 2d                	jne    5d4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 5a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5aa:	8b 00                	mov    (%eax),%eax
 5ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5b3:	00 
 5b4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5bb:	00 
 5bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 7a fe ff ff       	call   445 <printint>
        ap++;
 5cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cf:	e9 b1 00 00 00       	jmp    685 <printf+0x190>
      } else if(c == 's'){
 5d4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5d8:	75 43                	jne    61d <printf+0x128>
        s = (char*)*ap;
 5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ea:	75 25                	jne    611 <printf+0x11c>
          s = "(null)";
 5ec:	c7 45 f4 0a 09 00 00 	movl   $0x90a,-0xc(%ebp)
        while(*s != 0){
 5f3:	eb 1c                	jmp    611 <printf+0x11c>
          putc(fd, *s);
 5f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f8:	8a 00                	mov    (%eax),%al
 5fa:	0f be c0             	movsbl %al,%eax
 5fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 601:	8b 45 08             	mov    0x8(%ebp),%eax
 604:	89 04 24             	mov    %eax,(%esp)
 607:	e8 11 fe ff ff       	call   41d <putc>
          s++;
 60c:	ff 45 f4             	incl   -0xc(%ebp)
 60f:	eb 01                	jmp    612 <printf+0x11d>
        while(*s != 0){
 611:	90                   	nop
 612:	8b 45 f4             	mov    -0xc(%ebp),%eax
 615:	8a 00                	mov    (%eax),%al
 617:	84 c0                	test   %al,%al
 619:	75 da                	jne    5f5 <printf+0x100>
 61b:	eb 68                	jmp    685 <printf+0x190>
        }
      } else if(c == 'c'){
 61d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 621:	75 1d                	jne    640 <printf+0x14b>
        putc(fd, *ap);
 623:	8b 45 e8             	mov    -0x18(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	0f be c0             	movsbl %al,%eax
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	8b 45 08             	mov    0x8(%ebp),%eax
 632:	89 04 24             	mov    %eax,(%esp)
 635:	e8 e3 fd ff ff       	call   41d <putc>
        ap++;
 63a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 63e:	eb 45                	jmp    685 <printf+0x190>
      } else if(c == '%'){
 640:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 644:	75 17                	jne    65d <printf+0x168>
        putc(fd, c);
 646:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 649:	0f be c0             	movsbl %al,%eax
 64c:	89 44 24 04          	mov    %eax,0x4(%esp)
 650:	8b 45 08             	mov    0x8(%ebp),%eax
 653:	89 04 24             	mov    %eax,(%esp)
 656:	e8 c2 fd ff ff       	call   41d <putc>
 65b:	eb 28                	jmp    685 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 664:	00 
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 ad fd ff ff       	call   41d <putc>
        putc(fd, c);
 670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 673:	0f be c0             	movsbl %al,%eax
 676:	89 44 24 04          	mov    %eax,0x4(%esp)
 67a:	8b 45 08             	mov    0x8(%ebp),%eax
 67d:	89 04 24             	mov    %eax,(%esp)
 680:	e8 98 fd ff ff       	call   41d <putc>
      }
      state = 0;
 685:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 68c:	ff 45 f0             	incl   -0x10(%ebp)
 68f:	8b 55 0c             	mov    0xc(%ebp),%edx
 692:	8b 45 f0             	mov    -0x10(%ebp),%eax
 695:	01 d0                	add    %edx,%eax
 697:	8a 00                	mov    (%eax),%al
 699:	84 c0                	test   %al,%al
 69b:	0f 85 76 fe ff ff    	jne    517 <printf+0x22>
    }
  }
}
 6a1:	c9                   	leave  
 6a2:	c3                   	ret    

000006a3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6a3:	55                   	push   %ebp
 6a4:	89 e5                	mov    %esp,%ebp
 6a6:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	83 e8 08             	sub    $0x8,%eax
 6af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6b2:	a1 74 0b 00 00       	mov    0xb74,%eax
 6b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ba:	eb 24                	jmp    6e0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bf:	8b 00                	mov    (%eax),%eax
 6c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6c4:	77 12                	ja     6d8 <free+0x35>
 6c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cc:	77 24                	ja     6f2 <free+0x4f>
 6ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d6:	77 1a                	ja     6f2 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e6:	76 d4                	jbe    6bc <free+0x19>
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f0:	76 ca                	jbe    6bc <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	8b 40 04             	mov    0x4(%eax),%eax
 6f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 702:	01 c2                	add    %eax,%edx
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	39 c2                	cmp    %eax,%edx
 70b:	75 24                	jne    731 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 70d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 710:	8b 50 04             	mov    0x4(%eax),%edx
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	8b 40 04             	mov    0x4(%eax),%eax
 71b:	01 c2                	add    %eax,%edx
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	8b 10                	mov    (%eax),%edx
 72a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72d:	89 10                	mov    %edx,(%eax)
 72f:	eb 0a                	jmp    73b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	8b 10                	mov    (%eax),%edx
 736:	8b 45 f8             	mov    -0x8(%ebp),%eax
 739:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 748:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74b:	01 d0                	add    %edx,%eax
 74d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 750:	75 20                	jne    772 <free+0xcf>
    p->s.size += bp->s.size;
 752:	8b 45 fc             	mov    -0x4(%ebp),%eax
 755:	8b 50 04             	mov    0x4(%eax),%edx
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	01 c2                	add    %eax,%edx
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	89 10                	mov    %edx,(%eax)
 770:	eb 08                	jmp    77a <free+0xd7>
  } else
    p->s.ptr = bp;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 55 f8             	mov    -0x8(%ebp),%edx
 778:	89 10                	mov    %edx,(%eax)
  freep = p;
 77a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77d:	a3 74 0b 00 00       	mov    %eax,0xb74
}
 782:	c9                   	leave  
 783:	c3                   	ret    

00000784 <morecore>:

static Header*
morecore(uint nu)
{
 784:	55                   	push   %ebp
 785:	89 e5                	mov    %esp,%ebp
 787:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 78a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 791:	77 07                	ja     79a <morecore+0x16>
    nu = 4096;
 793:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 79a:	8b 45 08             	mov    0x8(%ebp),%eax
 79d:	c1 e0 03             	shl    $0x3,%eax
 7a0:	89 04 24             	mov    %eax,(%esp)
 7a3:	e8 3d fc ff ff       	call   3e5 <sbrk>
 7a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7ab:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7af:	75 07                	jne    7b8 <morecore+0x34>
    return 0;
 7b1:	b8 00 00 00 00       	mov    $0x0,%eax
 7b6:	eb 22                	jmp    7da <morecore+0x56>
  hp = (Header*)p;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c1:	8b 55 08             	mov    0x8(%ebp),%edx
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ca:	83 c0 08             	add    $0x8,%eax
 7cd:	89 04 24             	mov    %eax,(%esp)
 7d0:	e8 ce fe ff ff       	call   6a3 <free>
  return freep;
 7d5:	a1 74 0b 00 00       	mov    0xb74,%eax
}
 7da:	c9                   	leave  
 7db:	c3                   	ret    

000007dc <malloc>:

void*
malloc(uint nbytes)
{
 7dc:	55                   	push   %ebp
 7dd:	89 e5                	mov    %esp,%ebp
 7df:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	8b 45 08             	mov    0x8(%ebp),%eax
 7e5:	83 c0 07             	add    $0x7,%eax
 7e8:	c1 e8 03             	shr    $0x3,%eax
 7eb:	40                   	inc    %eax
 7ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ef:	a1 74 0b 00 00       	mov    0xb74,%eax
 7f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7fb:	75 23                	jne    820 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 7fd:	c7 45 f0 6c 0b 00 00 	movl   $0xb6c,-0x10(%ebp)
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	a3 74 0b 00 00       	mov    %eax,0xb74
 80c:	a1 74 0b 00 00       	mov    0xb74,%eax
 811:	a3 6c 0b 00 00       	mov    %eax,0xb6c
    base.s.size = 0;
 816:	c7 05 70 0b 00 00 00 	movl   $0x0,0xb70
 81d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	8b 00                	mov    (%eax),%eax
 825:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 831:	72 4d                	jb     880 <malloc+0xa4>
      if(p->s.size == nunits)
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83c:	75 0c                	jne    84a <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	8b 10                	mov    (%eax),%edx
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	89 10                	mov    %edx,(%eax)
 848:	eb 26                	jmp    870 <malloc+0x94>
      else {
        p->s.size -= nunits;
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	8b 40 04             	mov    0x4(%eax),%eax
 850:	89 c2                	mov    %eax,%edx
 852:	2b 55 ec             	sub    -0x14(%ebp),%edx
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8b 40 04             	mov    0x4(%eax),%eax
 861:	c1 e0 03             	shl    $0x3,%eax
 864:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	a3 74 0b 00 00       	mov    %eax,0xb74
      return (void*)(p + 1);
 878:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87b:	83 c0 08             	add    $0x8,%eax
 87e:	eb 38                	jmp    8b8 <malloc+0xdc>
    }
    if(p == freep)
 880:	a1 74 0b 00 00       	mov    0xb74,%eax
 885:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 888:	75 1b                	jne    8a5 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 88a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88d:	89 04 24             	mov    %eax,(%esp)
 890:	e8 ef fe ff ff       	call   784 <morecore>
 895:	89 45 f4             	mov    %eax,-0xc(%ebp)
 898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89c:	75 07                	jne    8a5 <malloc+0xc9>
        return 0;
 89e:	b8 00 00 00 00       	mov    $0x0,%eax
 8a3:	eb 13                	jmp    8b8 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 00                	mov    (%eax),%eax
 8b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8b3:	e9 70 ff ff ff       	jmp    828 <malloc+0x4c>
}
 8b8:	c9                   	leave  
 8b9:	c3                   	ret    
