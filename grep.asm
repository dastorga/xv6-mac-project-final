
_grep:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
   d:	e9 bb 00 00 00       	jmp    cd <grep+0xcd>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    p = buf;
  18:	c7 45 f0 60 0e 00 00 	movl   $0xe60,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  1f:	eb 4f                	jmp    70 <grep+0x70>
      *q = 0;
  21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  24:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  2e:	8b 45 08             	mov    0x8(%ebp),%eax
  31:	89 04 24             	mov    %eax,(%esp)
  34:	e8 bd 01 00 00       	call   1f6 <match>
  39:	85 c0                	test   %eax,%eax
  3b:	74 2c                	je     69 <grep+0x69>
        *q = '\n';
  3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  40:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  46:	40                   	inc    %eax
  47:	89 c2                	mov    %eax,%edx
  49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  4c:	89 d1                	mov    %edx,%ecx
  4e:	29 c1                	sub    %eax,%ecx
  50:	89 c8                	mov    %ecx,%eax
  52:	89 44 24 08          	mov    %eax,0x8(%esp)
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	89 44 24 04          	mov    %eax,0x4(%esp)
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 46 05 00 00       	call   5af <write>
      }
      p = q+1;
  69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  6c:	40                   	inc    %eax
  6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  70:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  77:	00 
  78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  7b:	89 04 24             	mov    %eax,(%esp)
  7e:	e8 9b 03 00 00       	call   41e <strchr>
  83:	89 45 e8             	mov    %eax,-0x18(%ebp)
  86:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8a:	75 95                	jne    21 <grep+0x21>
    }
    if(p == buf)
  8c:	81 7d f0 60 0e 00 00 	cmpl   $0xe60,-0x10(%ebp)
  93:	75 07                	jne    9c <grep+0x9c>
      m = 0;
  95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a0:	7e 2b                	jle    cd <grep+0xcd>
      m -= p - buf;
  a2:	ba 60 0e 00 00       	mov    $0xe60,%edx
  a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  aa:	89 d1                	mov    %edx,%ecx
  ac:	29 c1                	sub    %eax,%ecx
  ae:	89 c8                	mov    %ecx,%eax
  b0:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  c1:	c7 04 24 60 0e 00 00 	movl   $0xe60,(%esp)
  c8:	e8 83 04 00 00       	call   550 <memmove>
  while((n = read(fd, buf+m, sizeof(buf)-m)) > 0){
  cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d0:	ba 00 04 00 00       	mov    $0x400,%edx
  d5:	89 d1                	mov    %edx,%ecx
  d7:	29 c1                	sub    %eax,%ecx
  d9:	89 c8                	mov    %ecx,%eax
  db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  de:	81 c2 60 0e 00 00    	add    $0xe60,%edx
  e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  e8:	89 54 24 04          	mov    %edx,0x4(%esp)
  ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  ef:	89 04 24             	mov    %eax,(%esp)
  f2:	e8 b0 04 00 00       	call   5a7 <read>
  f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  fe:	0f 8f 0e ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <main>:

int
main(int argc, char *argv[])
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 e4 f0             	and    $0xfffffff0,%esp
 10c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 10f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 113:	7f 19                	jg     12e <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 115:	c7 44 24 04 24 0b 00 	movl   $0xb24,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 36 06 00 00       	call   75f <printf>
    exit();
 129:	e8 61 04 00 00       	call   58f <exit>
  }
  pattern = argv[1];
 12e:	8b 45 0c             	mov    0xc(%ebp),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 44 24 18          	mov    %eax,0x18(%esp)
  
  if(argc <= 2){
 138:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 13c:	7f 19                	jg     157 <main+0x51>
    grep(pattern, 0);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8b 44 24 18          	mov    0x18(%esp),%eax
 14a:	89 04 24             	mov    %eax,(%esp)
 14d:	e8 ae fe ff ff       	call   0 <grep>
    exit();
 152:	e8 38 04 00 00       	call   58f <exit>
  }

  for(i = 2; i < argc; i++){
 157:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 15e:	00 
 15f:	e9 80 00 00 00       	jmp    1e4 <main+0xde>
    if((fd = open(argv[i], 0)) < 0){
 164:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16f:	8b 45 0c             	mov    0xc(%ebp),%eax
 172:	01 d0                	add    %edx,%eax
 174:	8b 00                	mov    (%eax),%eax
 176:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 17d:	00 
 17e:	89 04 24             	mov    %eax,(%esp)
 181:	e8 49 04 00 00       	call   5cf <open>
 186:	89 44 24 14          	mov    %eax,0x14(%esp)
 18a:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 18f:	79 2f                	jns    1c0 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 191:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 195:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19c:	8b 45 0c             	mov    0xc(%ebp),%eax
 19f:	01 d0                	add    %edx,%eax
 1a1:	8b 00                	mov    (%eax),%eax
 1a3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a7:	c7 44 24 04 44 0b 00 	movl   $0xb44,0x4(%esp)
 1ae:	00 
 1af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b6:	e8 a4 05 00 00       	call   75f <printf>
      exit();
 1bb:	e8 cf 03 00 00       	call   58f <exit>
    }
    grep(pattern, fd);
 1c0:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	8b 44 24 18          	mov    0x18(%esp),%eax
 1cc:	89 04 24             	mov    %eax,(%esp)
 1cf:	e8 2c fe ff ff       	call   0 <grep>
    close(fd);
 1d4:	8b 44 24 14          	mov    0x14(%esp),%eax
 1d8:	89 04 24             	mov    %eax,(%esp)
 1db:	e8 d7 03 00 00       	call   5b7 <close>
  for(i = 2; i < argc; i++){
 1e0:	ff 44 24 1c          	incl   0x1c(%esp)
 1e4:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1e8:	3b 45 08             	cmp    0x8(%ebp),%eax
 1eb:	0f 8c 73 ff ff ff    	jl     164 <main+0x5e>
  }
  exit();
 1f1:	e8 99 03 00 00       	call   58f <exit>

000001f6 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	8a 00                	mov    (%eax),%al
 201:	3c 5e                	cmp    $0x5e,%al
 203:	75 17                	jne    21c <match+0x26>
    return matchhere(re+1, text);
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8d 50 01             	lea    0x1(%eax),%edx
 20b:	8b 45 0c             	mov    0xc(%ebp),%eax
 20e:	89 44 24 04          	mov    %eax,0x4(%esp)
 212:	89 14 24             	mov    %edx,(%esp)
 215:	e8 37 00 00 00       	call   251 <matchhere>
 21a:	eb 33                	jmp    24f <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	89 44 24 04          	mov    %eax,0x4(%esp)
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	89 04 24             	mov    %eax,(%esp)
 229:	e8 23 00 00 00       	call   251 <matchhere>
 22e:	85 c0                	test   %eax,%eax
 230:	74 07                	je     239 <match+0x43>
      return 1;
 232:	b8 01 00 00 00       	mov    $0x1,%eax
 237:	eb 16                	jmp    24f <match+0x59>
  }while(*text++ != '\0');
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8a 00                	mov    (%eax),%al
 23e:	84 c0                	test   %al,%al
 240:	0f 95 c0             	setne  %al
 243:	ff 45 0c             	incl   0xc(%ebp)
 246:	84 c0                	test   %al,%al
 248:	75 d2                	jne    21c <match+0x26>
  return 0;
 24a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24f:	c9                   	leave  
 250:	c3                   	ret    

00000251 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	8a 00                	mov    (%eax),%al
 25c:	84 c0                	test   %al,%al
 25e:	75 0a                	jne    26a <matchhere+0x19>
    return 1;
 260:	b8 01 00 00 00       	mov    $0x1,%eax
 265:	e9 8c 00 00 00       	jmp    2f6 <matchhere+0xa5>
  if(re[1] == '*')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	40                   	inc    %eax
 26e:	8a 00                	mov    (%eax),%al
 270:	3c 2a                	cmp    $0x2a,%al
 272:	75 23                	jne    297 <matchhere+0x46>
    return matchstar(re[0], re+2, text);
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8d 48 02             	lea    0x2(%eax),%ecx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	8a 00                	mov    (%eax),%al
 27f:	0f be c0             	movsbl %al,%eax
 282:	8b 55 0c             	mov    0xc(%ebp),%edx
 285:	89 54 24 08          	mov    %edx,0x8(%esp)
 289:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 28d:	89 04 24             	mov    %eax,(%esp)
 290:	e8 63 00 00 00       	call   2f8 <matchstar>
 295:	eb 5f                	jmp    2f6 <matchhere+0xa5>
  if(re[0] == '$' && re[1] == '\0')
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8a 00                	mov    (%eax),%al
 29c:	3c 24                	cmp    $0x24,%al
 29e:	75 19                	jne    2b9 <matchhere+0x68>
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	40                   	inc    %eax
 2a4:	8a 00                	mov    (%eax),%al
 2a6:	84 c0                	test   %al,%al
 2a8:	75 0f                	jne    2b9 <matchhere+0x68>
    return *text == '\0';
 2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ad:	8a 00                	mov    (%eax),%al
 2af:	84 c0                	test   %al,%al
 2b1:	0f 94 c0             	sete   %al
 2b4:	0f b6 c0             	movzbl %al,%eax
 2b7:	eb 3d                	jmp    2f6 <matchhere+0xa5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	8a 00                	mov    (%eax),%al
 2be:	84 c0                	test   %al,%al
 2c0:	74 2f                	je     2f1 <matchhere+0xa0>
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8a 00                	mov    (%eax),%al
 2c7:	3c 2e                	cmp    $0x2e,%al
 2c9:	74 0e                	je     2d9 <matchhere+0x88>
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	8a 10                	mov    (%eax),%dl
 2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d3:	8a 00                	mov    (%eax),%al
 2d5:	38 c2                	cmp    %al,%dl
 2d7:	75 18                	jne    2f1 <matchhere+0xa0>
    return matchhere(re+1, text+1);
 2d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2dc:	8d 50 01             	lea    0x1(%eax),%edx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	40                   	inc    %eax
 2e3:	89 54 24 04          	mov    %edx,0x4(%esp)
 2e7:	89 04 24             	mov    %eax,(%esp)
 2ea:	e8 62 ff ff ff       	call   251 <matchhere>
 2ef:	eb 05                	jmp    2f6 <matchhere+0xa5>
  return 0;
 2f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2fe:	8b 45 10             	mov    0x10(%ebp),%eax
 301:	89 44 24 04          	mov    %eax,0x4(%esp)
 305:	8b 45 0c             	mov    0xc(%ebp),%eax
 308:	89 04 24             	mov    %eax,(%esp)
 30b:	e8 41 ff ff ff       	call   251 <matchhere>
 310:	85 c0                	test   %eax,%eax
 312:	74 07                	je     31b <matchstar+0x23>
      return 1;
 314:	b8 01 00 00 00       	mov    $0x1,%eax
 319:	eb 29                	jmp    344 <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 31b:	8b 45 10             	mov    0x10(%ebp),%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	84 c0                	test   %al,%al
 322:	74 1b                	je     33f <matchstar+0x47>
 324:	8b 45 10             	mov    0x10(%ebp),%eax
 327:	8a 00                	mov    (%eax),%al
 329:	0f be c0             	movsbl %al,%eax
 32c:	3b 45 08             	cmp    0x8(%ebp),%eax
 32f:	0f 94 c0             	sete   %al
 332:	ff 45 10             	incl   0x10(%ebp)
 335:	84 c0                	test   %al,%al
 337:	75 c5                	jne    2fe <matchstar+0x6>
 339:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 33d:	74 bf                	je     2fe <matchstar+0x6>
  return 0;
 33f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	5b                   	pop    %ebx
 368:	5f                   	pop    %edi
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    

0000036b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 377:	90                   	nop
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	8a 10                	mov    (%eax),%dl
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	88 10                	mov    %dl,(%eax)
 382:	8b 45 08             	mov    0x8(%ebp),%eax
 385:	8a 00                	mov    (%eax),%al
 387:	84 c0                	test   %al,%al
 389:	0f 95 c0             	setne  %al
 38c:	ff 45 08             	incl   0x8(%ebp)
 38f:	ff 45 0c             	incl   0xc(%ebp)
 392:	84 c0                	test   %al,%al
 394:	75 e2                	jne    378 <strcpy+0xd>
    ;
  return os;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39e:	eb 06                	jmp    3a6 <strcmp+0xb>
    p++, q++;
 3a0:	ff 45 08             	incl   0x8(%ebp)
 3a3:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8a 00                	mov    (%eax),%al
 3ab:	84 c0                	test   %al,%al
 3ad:	74 0e                	je     3bd <strcmp+0x22>
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	8a 10                	mov    (%eax),%dl
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	38 c2                	cmp    %al,%dl
 3bb:	74 e3                	je     3a0 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	8a 00                	mov    (%eax),%al
 3c2:	0f b6 d0             	movzbl %al,%edx
 3c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c8:	8a 00                	mov    (%eax),%al
 3ca:	0f b6 c0             	movzbl %al,%eax
 3cd:	89 d1                	mov    %edx,%ecx
 3cf:	29 c1                	sub    %eax,%ecx
 3d1:	89 c8                	mov    %ecx,%eax
}
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    

000003d5 <strlen>:

uint
strlen(char *s)
{
 3d5:	55                   	push   %ebp
 3d6:	89 e5                	mov    %esp,%ebp
 3d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e2:	eb 03                	jmp    3e7 <strlen+0x12>
 3e4:	ff 45 fc             	incl   -0x4(%ebp)
 3e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	01 d0                	add    %edx,%eax
 3ef:	8a 00                	mov    (%eax),%al
 3f1:	84 c0                	test   %al,%al
 3f3:	75 ef                	jne    3e4 <strlen+0xf>
    ;
  return n;
 3f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f8:	c9                   	leave  
 3f9:	c3                   	ret    

000003fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 400:	8b 45 10             	mov    0x10(%ebp),%eax
 403:	89 44 24 08          	mov    %eax,0x8(%esp)
 407:	8b 45 0c             	mov    0xc(%ebp),%eax
 40a:	89 44 24 04          	mov    %eax,0x4(%esp)
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	89 04 24             	mov    %eax,(%esp)
 414:	e8 2d ff ff ff       	call   346 <stosb>
  return dst;
 419:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <strchr>:

char*
strchr(const char *s, char c)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 04             	sub    $0x4,%esp
 424:	8b 45 0c             	mov    0xc(%ebp),%eax
 427:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 42a:	eb 12                	jmp    43e <strchr+0x20>
    if(*s == c)
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
 42f:	8a 00                	mov    (%eax),%al
 431:	3a 45 fc             	cmp    -0x4(%ebp),%al
 434:	75 05                	jne    43b <strchr+0x1d>
      return (char*)s;
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	eb 11                	jmp    44c <strchr+0x2e>
  for(; *s; s++)
 43b:	ff 45 08             	incl   0x8(%ebp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	8a 00                	mov    (%eax),%al
 443:	84 c0                	test   %al,%al
 445:	75 e5                	jne    42c <strchr+0xe>
  return 0;
 447:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44c:	c9                   	leave  
 44d:	c3                   	ret    

0000044e <gets>:

char*
gets(char *buf, int max)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45b:	eb 42                	jmp    49f <gets+0x51>
    cc = read(0, &c, 1);
 45d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 464:	00 
 465:	8d 45 ef             	lea    -0x11(%ebp),%eax
 468:	89 44 24 04          	mov    %eax,0x4(%esp)
 46c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 473:	e8 2f 01 00 00       	call   5a7 <read>
 478:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 47b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 47f:	7e 29                	jle    4aa <gets+0x5c>
      break;
    buf[i++] = c;
 481:	8b 55 f4             	mov    -0xc(%ebp),%edx
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	01 c2                	add    %eax,%edx
 489:	8a 45 ef             	mov    -0x11(%ebp),%al
 48c:	88 02                	mov    %al,(%edx)
 48e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 491:	8a 45 ef             	mov    -0x11(%ebp),%al
 494:	3c 0a                	cmp    $0xa,%al
 496:	74 13                	je     4ab <gets+0x5d>
 498:	8a 45 ef             	mov    -0x11(%ebp),%al
 49b:	3c 0d                	cmp    $0xd,%al
 49d:	74 0c                	je     4ab <gets+0x5d>
  for(i=0; i+1 < max; ){
 49f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a2:	40                   	inc    %eax
 4a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a6:	7c b5                	jl     45d <gets+0xf>
 4a8:	eb 01                	jmp    4ab <gets+0x5d>
      break;
 4aa:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ae:	8b 45 08             	mov    0x8(%ebp),%eax
 4b1:	01 d0                	add    %edx,%eax
 4b3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4b9:	c9                   	leave  
 4ba:	c3                   	ret    

000004bb <stat>:

int
stat(char *n, struct stat *st)
{
 4bb:	55                   	push   %ebp
 4bc:	89 e5                	mov    %esp,%ebp
 4be:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4c8:	00 
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	89 04 24             	mov    %eax,(%esp)
 4cf:	e8 fb 00 00 00       	call   5cf <open>
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x29>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 23                	jmp    507 <stat+0x4c>
  r = fstat(fd, st);
 4e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ee:	89 04 24             	mov    %eax,(%esp)
 4f1:	e8 f1 00 00 00       	call   5e7 <fstat>
 4f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 b3 00 00 00       	call   5b7 <close>
  return r;
 504:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <atoi>:

int
atoi(const char *s)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 50f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 516:	eb 21                	jmp    539 <atoi+0x30>
    n = n*10 + *s++ - '0';
 518:	8b 55 fc             	mov    -0x4(%ebp),%edx
 51b:	89 d0                	mov    %edx,%eax
 51d:	c1 e0 02             	shl    $0x2,%eax
 520:	01 d0                	add    %edx,%eax
 522:	d1 e0                	shl    %eax
 524:	89 c2                	mov    %eax,%edx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8a 00                	mov    (%eax),%al
 52b:	0f be c0             	movsbl %al,%eax
 52e:	01 d0                	add    %edx,%eax
 530:	83 e8 30             	sub    $0x30,%eax
 533:	89 45 fc             	mov    %eax,-0x4(%ebp)
 536:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	8a 00                	mov    (%eax),%al
 53e:	3c 2f                	cmp    $0x2f,%al
 540:	7e 09                	jle    54b <atoi+0x42>
 542:	8b 45 08             	mov    0x8(%ebp),%eax
 545:	8a 00                	mov    (%eax),%al
 547:	3c 39                	cmp    $0x39,%al
 549:	7e cd                	jle    518 <atoi+0xf>
  return n;
 54b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 54e:	c9                   	leave  
 54f:	c3                   	ret    

00000550 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 556:	8b 45 08             	mov    0x8(%ebp),%eax
 559:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 55c:	8b 45 0c             	mov    0xc(%ebp),%eax
 55f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 562:	eb 10                	jmp    574 <memmove+0x24>
    *dst++ = *src++;
 564:	8b 45 f8             	mov    -0x8(%ebp),%eax
 567:	8a 10                	mov    (%eax),%dl
 569:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56c:	88 10                	mov    %dl,(%eax)
 56e:	ff 45 fc             	incl   -0x4(%ebp)
 571:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 574:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 578:	0f 9f c0             	setg   %al
 57b:	ff 4d 10             	decl   0x10(%ebp)
 57e:	84 c0                	test   %al,%al
 580:	75 e2                	jne    564 <memmove+0x14>
  return vdst;
 582:	8b 45 08             	mov    0x8(%ebp),%eax
}
 585:	c9                   	leave  
 586:	c3                   	ret    

00000587 <fork>:
 587:	b8 01 00 00 00       	mov    $0x1,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <exit>:
 58f:	b8 02 00 00 00       	mov    $0x2,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <wait>:
 597:	b8 03 00 00 00       	mov    $0x3,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <pipe>:
 59f:	b8 04 00 00 00       	mov    $0x4,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <read>:
 5a7:	b8 05 00 00 00       	mov    $0x5,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <write>:
 5af:	b8 10 00 00 00       	mov    $0x10,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <close>:
 5b7:	b8 15 00 00 00       	mov    $0x15,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <kill>:
 5bf:	b8 06 00 00 00       	mov    $0x6,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <exec>:
 5c7:	b8 07 00 00 00       	mov    $0x7,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <open>:
 5cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <mknod>:
 5d7:	b8 11 00 00 00       	mov    $0x11,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <unlink>:
 5df:	b8 12 00 00 00       	mov    $0x12,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <fstat>:
 5e7:	b8 08 00 00 00       	mov    $0x8,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <link>:
 5ef:	b8 13 00 00 00       	mov    $0x13,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <mkdir>:
 5f7:	b8 14 00 00 00       	mov    $0x14,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <chdir>:
 5ff:	b8 09 00 00 00       	mov    $0x9,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <dup>:
 607:	b8 0a 00 00 00       	mov    $0xa,%eax
 60c:	cd 40                	int    $0x40
 60e:	c3                   	ret    

0000060f <getpid>:
 60f:	b8 0b 00 00 00       	mov    $0xb,%eax
 614:	cd 40                	int    $0x40
 616:	c3                   	ret    

00000617 <sbrk>:
 617:	b8 0c 00 00 00       	mov    $0xc,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <sleep>:
 61f:	b8 0d 00 00 00       	mov    $0xd,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <uptime>:
 627:	b8 0e 00 00 00       	mov    $0xe,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <lseek>:
 62f:	b8 16 00 00 00       	mov    $0x16,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <isatty>:
 637:	b8 17 00 00 00       	mov    $0x17,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <procstat>:
 63f:	b8 18 00 00 00       	mov    $0x18,%eax
 644:	cd 40                	int    $0x40
 646:	c3                   	ret    

00000647 <set_priority>:
 647:	b8 19 00 00 00       	mov    $0x19,%eax
 64c:	cd 40                	int    $0x40
 64e:	c3                   	ret    

0000064f <semget>:
 64f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 654:	cd 40                	int    $0x40
 656:	c3                   	ret    

00000657 <semfree>:
 657:	b8 1b 00 00 00       	mov    $0x1b,%eax
 65c:	cd 40                	int    $0x40
 65e:	c3                   	ret    

0000065f <semdown>:
 65f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 664:	cd 40                	int    $0x40
 666:	c3                   	ret    

00000667 <semup>:
 667:	b8 1d 00 00 00       	mov    $0x1d,%eax
 66c:	cd 40                	int    $0x40
 66e:	c3                   	ret    

0000066f <shm_create>:
 66f:	b8 1e 00 00 00       	mov    $0x1e,%eax
 674:	cd 40                	int    $0x40
 676:	c3                   	ret    

00000677 <shm_close>:
 677:	b8 1f 00 00 00       	mov    $0x1f,%eax
 67c:	cd 40                	int    $0x40
 67e:	c3                   	ret    

0000067f <shm_get>:
 67f:	b8 20 00 00 00       	mov    $0x20,%eax
 684:	cd 40                	int    $0x40
 686:	c3                   	ret    

00000687 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 687:	55                   	push   %ebp
 688:	89 e5                	mov    %esp,%ebp
 68a:	83 ec 28             	sub    $0x28,%esp
 68d:	8b 45 0c             	mov    0xc(%ebp),%eax
 690:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 693:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 69a:	00 
 69b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 69e:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a2:	8b 45 08             	mov    0x8(%ebp),%eax
 6a5:	89 04 24             	mov    %eax,(%esp)
 6a8:	e8 02 ff ff ff       	call   5af <write>
}
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    

000006af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6bc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6c0:	74 17                	je     6d9 <printint+0x2a>
 6c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6c6:	79 11                	jns    6d9 <printint+0x2a>
    neg = 1;
 6c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d2:	f7 d8                	neg    %eax
 6d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d7:	eb 06                	jmp    6df <printint+0x30>
  } else {
    x = xx;
 6d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6ec:	ba 00 00 00 00       	mov    $0x0,%edx
 6f1:	f7 f1                	div    %ecx
 6f3:	89 d0                	mov    %edx,%eax
 6f5:	8a 80 20 0e 00 00    	mov    0xe20(%eax),%al
 6fb:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
 701:	01 ca                	add    %ecx,%edx
 703:	88 02                	mov    %al,(%edx)
 705:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 708:	8b 55 10             	mov    0x10(%ebp),%edx
 70b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 70e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 711:	ba 00 00 00 00       	mov    $0x0,%edx
 716:	f7 75 d4             	divl   -0x2c(%ebp)
 719:	89 45 ec             	mov    %eax,-0x14(%ebp)
 71c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 720:	75 c4                	jne    6e6 <printint+0x37>
  if(neg)
 722:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 726:	74 2c                	je     754 <printint+0xa5>
    buf[i++] = '-';
 728:	8d 55 dc             	lea    -0x24(%ebp),%edx
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	01 d0                	add    %edx,%eax
 730:	c6 00 2d             	movb   $0x2d,(%eax)
 733:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 736:	eb 1c                	jmp    754 <printint+0xa5>
    putc(fd, buf[i]);
 738:	8d 55 dc             	lea    -0x24(%ebp),%edx
 73b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	8a 00                	mov    (%eax),%al
 742:	0f be c0             	movsbl %al,%eax
 745:	89 44 24 04          	mov    %eax,0x4(%esp)
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	89 04 24             	mov    %eax,(%esp)
 74f:	e8 33 ff ff ff       	call   687 <putc>
  while(--i >= 0)
 754:	ff 4d f4             	decl   -0xc(%ebp)
 757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75b:	79 db                	jns    738 <printint+0x89>
}
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 765:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 76c:	8d 45 0c             	lea    0xc(%ebp),%eax
 76f:	83 c0 04             	add    $0x4,%eax
 772:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 775:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 77c:	e9 78 01 00 00       	jmp    8f9 <printf+0x19a>
    c = fmt[i] & 0xff;
 781:	8b 55 0c             	mov    0xc(%ebp),%edx
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	01 d0                	add    %edx,%eax
 789:	8a 00                	mov    (%eax),%al
 78b:	0f be c0             	movsbl %al,%eax
 78e:	25 ff 00 00 00       	and    $0xff,%eax
 793:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 796:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 79a:	75 2c                	jne    7c8 <printf+0x69>
      if(c == '%'){
 79c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a0:	75 0c                	jne    7ae <printf+0x4f>
        state = '%';
 7a2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7a9:	e9 48 01 00 00       	jmp    8f6 <printf+0x197>
      } else {
        putc(fd, c);
 7ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b1:	0f be c0             	movsbl %al,%eax
 7b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b8:	8b 45 08             	mov    0x8(%ebp),%eax
 7bb:	89 04 24             	mov    %eax,(%esp)
 7be:	e8 c4 fe ff ff       	call   687 <putc>
 7c3:	e9 2e 01 00 00       	jmp    8f6 <printf+0x197>
      }
    } else if(state == '%'){
 7c8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7cc:	0f 85 24 01 00 00    	jne    8f6 <printf+0x197>
      if(c == 'd'){
 7d2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7d6:	75 2d                	jne    805 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7e4:	00 
 7e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7ec:	00 
 7ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f1:	8b 45 08             	mov    0x8(%ebp),%eax
 7f4:	89 04 24             	mov    %eax,(%esp)
 7f7:	e8 b3 fe ff ff       	call   6af <printint>
        ap++;
 7fc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 800:	e9 ea 00 00 00       	jmp    8ef <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 805:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 809:	74 06                	je     811 <printf+0xb2>
 80b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 80f:	75 2d                	jne    83e <printf+0xdf>
        printint(fd, *ap, 16, 0);
 811:	8b 45 e8             	mov    -0x18(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 81d:	00 
 81e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 825:	00 
 826:	89 44 24 04          	mov    %eax,0x4(%esp)
 82a:	8b 45 08             	mov    0x8(%ebp),%eax
 82d:	89 04 24             	mov    %eax,(%esp)
 830:	e8 7a fe ff ff       	call   6af <printint>
        ap++;
 835:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 839:	e9 b1 00 00 00       	jmp    8ef <printf+0x190>
      } else if(c == 's'){
 83e:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 842:	75 43                	jne    887 <printf+0x128>
        s = (char*)*ap;
 844:	8b 45 e8             	mov    -0x18(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 84c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 850:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 854:	75 25                	jne    87b <printf+0x11c>
          s = "(null)";
 856:	c7 45 f4 5a 0b 00 00 	movl   $0xb5a,-0xc(%ebp)
        while(*s != 0){
 85d:	eb 1c                	jmp    87b <printf+0x11c>
          putc(fd, *s);
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	8a 00                	mov    (%eax),%al
 864:	0f be c0             	movsbl %al,%eax
 867:	89 44 24 04          	mov    %eax,0x4(%esp)
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	89 04 24             	mov    %eax,(%esp)
 871:	e8 11 fe ff ff       	call   687 <putc>
          s++;
 876:	ff 45 f4             	incl   -0xc(%ebp)
 879:	eb 01                	jmp    87c <printf+0x11d>
        while(*s != 0){
 87b:	90                   	nop
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8a 00                	mov    (%eax),%al
 881:	84 c0                	test   %al,%al
 883:	75 da                	jne    85f <printf+0x100>
 885:	eb 68                	jmp    8ef <printf+0x190>
        }
      } else if(c == 'c'){
 887:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 88b:	75 1d                	jne    8aa <printf+0x14b>
        putc(fd, *ap);
 88d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 890:	8b 00                	mov    (%eax),%eax
 892:	0f be c0             	movsbl %al,%eax
 895:	89 44 24 04          	mov    %eax,0x4(%esp)
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	89 04 24             	mov    %eax,(%esp)
 89f:	e8 e3 fd ff ff       	call   687 <putc>
        ap++;
 8a4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8a8:	eb 45                	jmp    8ef <printf+0x190>
      } else if(c == '%'){
 8aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ae:	75 17                	jne    8c7 <printf+0x168>
        putc(fd, c);
 8b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b3:	0f be c0             	movsbl %al,%eax
 8b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ba:	8b 45 08             	mov    0x8(%ebp),%eax
 8bd:	89 04 24             	mov    %eax,(%esp)
 8c0:	e8 c2 fd ff ff       	call   687 <putc>
 8c5:	eb 28                	jmp    8ef <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8c7:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8ce:	00 
 8cf:	8b 45 08             	mov    0x8(%ebp),%eax
 8d2:	89 04 24             	mov    %eax,(%esp)
 8d5:	e8 ad fd ff ff       	call   687 <putc>
        putc(fd, c);
 8da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8dd:	0f be c0             	movsbl %al,%eax
 8e0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e4:	8b 45 08             	mov    0x8(%ebp),%eax
 8e7:	89 04 24             	mov    %eax,(%esp)
 8ea:	e8 98 fd ff ff       	call   687 <putc>
      }
      state = 0;
 8ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8f6:	ff 45 f0             	incl   -0x10(%ebp)
 8f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	01 d0                	add    %edx,%eax
 901:	8a 00                	mov    (%eax),%al
 903:	84 c0                	test   %al,%al
 905:	0f 85 76 fe ff ff    	jne    781 <printf+0x22>
    }
  }
}
 90b:	c9                   	leave  
 90c:	c3                   	ret    

0000090d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 90d:	55                   	push   %ebp
 90e:	89 e5                	mov    %esp,%ebp
 910:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 913:	8b 45 08             	mov    0x8(%ebp),%eax
 916:	83 e8 08             	sub    $0x8,%eax
 919:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91c:	a1 48 0e 00 00       	mov    0xe48,%eax
 921:	89 45 fc             	mov    %eax,-0x4(%ebp)
 924:	eb 24                	jmp    94a <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	8b 00                	mov    (%eax),%eax
 92b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 92e:	77 12                	ja     942 <free+0x35>
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 936:	77 24                	ja     95c <free+0x4f>
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 940:	77 1a                	ja     95c <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 942:	8b 45 fc             	mov    -0x4(%ebp),%eax
 945:	8b 00                	mov    (%eax),%eax
 947:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 950:	76 d4                	jbe    926 <free+0x19>
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	8b 00                	mov    (%eax),%eax
 957:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 95a:	76 ca                	jbe    926 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 95c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95f:	8b 40 04             	mov    0x4(%eax),%eax
 962:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 969:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96c:	01 c2                	add    %eax,%edx
 96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 971:	8b 00                	mov    (%eax),%eax
 973:	39 c2                	cmp    %eax,%edx
 975:	75 24                	jne    99b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 977:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97a:	8b 50 04             	mov    0x4(%eax),%edx
 97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	8b 40 04             	mov    0x4(%eax),%eax
 985:	01 c2                	add    %eax,%edx
 987:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 98d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 990:	8b 00                	mov    (%eax),%eax
 992:	8b 10                	mov    (%eax),%edx
 994:	8b 45 f8             	mov    -0x8(%ebp),%eax
 997:	89 10                	mov    %edx,(%eax)
 999:	eb 0a                	jmp    9a5 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 99b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99e:	8b 10                	mov    (%eax),%edx
 9a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a3:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a8:	8b 40 04             	mov    0x4(%eax),%eax
 9ab:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b5:	01 d0                	add    %edx,%eax
 9b7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ba:	75 20                	jne    9dc <free+0xcf>
    p->s.size += bp->s.size;
 9bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bf:	8b 50 04             	mov    0x4(%eax),%edx
 9c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c5:	8b 40 04             	mov    0x4(%eax),%eax
 9c8:	01 c2                	add    %eax,%edx
 9ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d3:	8b 10                	mov    (%eax),%edx
 9d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d8:	89 10                	mov    %edx,(%eax)
 9da:	eb 08                	jmp    9e4 <free+0xd7>
  } else
    p->s.ptr = bp;
 9dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9df:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9e2:	89 10                	mov    %edx,(%eax)
  freep = p;
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	a3 48 0e 00 00       	mov    %eax,0xe48
}
 9ec:	c9                   	leave  
 9ed:	c3                   	ret    

000009ee <morecore>:

static Header*
morecore(uint nu)
{
 9ee:	55                   	push   %ebp
 9ef:	89 e5                	mov    %esp,%ebp
 9f1:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9f4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9fb:	77 07                	ja     a04 <morecore+0x16>
    nu = 4096;
 9fd:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a04:	8b 45 08             	mov    0x8(%ebp),%eax
 a07:	c1 e0 03             	shl    $0x3,%eax
 a0a:	89 04 24             	mov    %eax,(%esp)
 a0d:	e8 05 fc ff ff       	call   617 <sbrk>
 a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a15:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a19:	75 07                	jne    a22 <morecore+0x34>
    return 0;
 a1b:	b8 00 00 00 00       	mov    $0x0,%eax
 a20:	eb 22                	jmp    a44 <morecore+0x56>
  hp = (Header*)p;
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2b:	8b 55 08             	mov    0x8(%ebp),%edx
 a2e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a34:	83 c0 08             	add    $0x8,%eax
 a37:	89 04 24             	mov    %eax,(%esp)
 a3a:	e8 ce fe ff ff       	call   90d <free>
  return freep;
 a3f:	a1 48 0e 00 00       	mov    0xe48,%eax
}
 a44:	c9                   	leave  
 a45:	c3                   	ret    

00000a46 <malloc>:

void*
malloc(uint nbytes)
{
 a46:	55                   	push   %ebp
 a47:	89 e5                	mov    %esp,%ebp
 a49:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a4c:	8b 45 08             	mov    0x8(%ebp),%eax
 a4f:	83 c0 07             	add    $0x7,%eax
 a52:	c1 e8 03             	shr    $0x3,%eax
 a55:	40                   	inc    %eax
 a56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a59:	a1 48 0e 00 00       	mov    0xe48,%eax
 a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a65:	75 23                	jne    a8a <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a67:	c7 45 f0 40 0e 00 00 	movl   $0xe40,-0x10(%ebp)
 a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a71:	a3 48 0e 00 00       	mov    %eax,0xe48
 a76:	a1 48 0e 00 00       	mov    0xe48,%eax
 a7b:	a3 40 0e 00 00       	mov    %eax,0xe40
    base.s.size = 0;
 a80:	c7 05 44 0e 00 00 00 	movl   $0x0,0xe44
 a87:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8d:	8b 00                	mov    (%eax),%eax
 a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a95:	8b 40 04             	mov    0x4(%eax),%eax
 a98:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a9b:	72 4d                	jb     aea <malloc+0xa4>
      if(p->s.size == nunits)
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	8b 40 04             	mov    0x4(%eax),%eax
 aa3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa6:	75 0c                	jne    ab4 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aab:	8b 10                	mov    (%eax),%edx
 aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab0:	89 10                	mov    %edx,(%eax)
 ab2:	eb 26                	jmp    ada <malloc+0x94>
      else {
        p->s.size -= nunits;
 ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab7:	8b 40 04             	mov    0x4(%eax),%eax
 aba:	89 c2                	mov    %eax,%edx
 abc:	2b 55 ec             	sub    -0x14(%ebp),%edx
 abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac8:	8b 40 04             	mov    0x4(%eax),%eax
 acb:	c1 e0 03             	shl    $0x3,%eax
 ace:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ad7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ada:	8b 45 f0             	mov    -0x10(%ebp),%eax
 add:	a3 48 0e 00 00       	mov    %eax,0xe48
      return (void*)(p + 1);
 ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae5:	83 c0 08             	add    $0x8,%eax
 ae8:	eb 38                	jmp    b22 <malloc+0xdc>
    }
    if(p == freep)
 aea:	a1 48 0e 00 00       	mov    0xe48,%eax
 aef:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 af2:	75 1b                	jne    b0f <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 af4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 af7:	89 04 24             	mov    %eax,(%esp)
 afa:	e8 ef fe ff ff       	call   9ee <morecore>
 aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b06:	75 07                	jne    b0f <malloc+0xc9>
        return 0;
 b08:	b8 00 00 00 00       	mov    $0x0,%eax
 b0d:	eb 13                	jmp    b22 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b18:	8b 00                	mov    (%eax),%eax
 b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 b1d:	e9 70 ff ff ff       	jmp    a92 <malloc+0x4c>
}
 b22:	c9                   	leave  
 b23:	c3                   	ret    
