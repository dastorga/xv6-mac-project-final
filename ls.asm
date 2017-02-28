
_ls:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 cf 03 00 00       	call   3e1 <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 03                	jmp    1f <fmtname+0x1f>
  1c:	ff 4d f4             	decl   -0xc(%ebp)
  1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  22:	3b 45 08             	cmp    0x8(%ebp),%eax
  25:	72 09                	jb     30 <fmtname+0x30>
  27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2a:	8a 00                	mov    (%eax),%al
  2c:	3c 2f                	cmp    $0x2f,%al
  2e:	75 ec                	jne    1c <fmtname+0x1c>
    ;
  p++;
  30:	ff 45 f4             	incl   -0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	89 04 24             	mov    %eax,(%esp)
  39:	e8 a3 03 00 00       	call   3e1 <strlen>
  3e:	83 f8 0d             	cmp    $0xd,%eax
  41:	76 05                	jbe    48 <fmtname+0x48>
    return p;
  43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  46:	eb 5f                	jmp    a7 <fmtname+0xa7>
  memmove(buf, p, strlen(p));
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 8e 03 00 00       	call   3e1 <strlen>
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  5e:	c7 04 24 28 0e 00 00 	movl   $0xe28,(%esp)
  65:	e8 f2 04 00 00       	call   55c <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6d:	89 04 24             	mov    %eax,(%esp)
  70:	e8 6c 03 00 00       	call   3e1 <strlen>
  75:	ba 0e 00 00 00       	mov    $0xe,%edx
  7a:	89 d3                	mov    %edx,%ebx
  7c:	29 c3                	sub    %eax,%ebx
  7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  81:	89 04 24             	mov    %eax,(%esp)
  84:	e8 58 03 00 00       	call   3e1 <strlen>
  89:	05 28 0e 00 00       	add    $0xe28,%eax
  8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  99:	00 
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 64 03 00 00       	call   406 <memset>
  return buf;
  a2:	b8 28 0e 00 00       	mov    $0xe28,%eax
}
  a7:	83 c4 24             	add    $0x24,%esp
  aa:	5b                   	pop    %ebx
  ab:	5d                   	pop    %ebp
  ac:	c3                   	ret    

000000ad <ls>:

void
ls(char *path)
{
  ad:	55                   	push   %ebp
  ae:	89 e5                	mov    %esp,%ebp
  b0:	57                   	push   %edi
  b1:	56                   	push   %esi
  b2:	53                   	push   %ebx
  b3:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c0:	00 
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	89 04 24             	mov    %eax,(%esp)
  c7:	e8 0f 05 00 00       	call   5db <open>
  cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d3:	79 20                	jns    f5 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  dc:	c7 44 24 04 30 0b 00 	movl   $0xb30,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  eb:	e8 7b 06 00 00       	call   76b <printf>
  f0:	e9 fc 01 00 00       	jmp    2f1 <ls+0x244>
    return;
  }
  
  if(fstat(fd, &st) < 0){
  f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 102:	89 04 24             	mov    %eax,(%esp)
 105:	e8 e9 04 00 00       	call   5f3 <fstat>
 10a:	85 c0                	test   %eax,%eax
 10c:	79 2b                	jns    139 <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	89 44 24 08          	mov    %eax,0x8(%esp)
 115:	c7 44 24 04 44 0b 00 	movl   $0xb44,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 42 06 00 00       	call   76b <printf>
    close(fd);
 129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12c:	89 04 24             	mov    %eax,(%esp)
 12f:	e8 8f 04 00 00       	call   5c3 <close>
 134:	e9 b8 01 00 00       	jmp    2f1 <ls+0x244>
    return;
  }
  
  switch(st.type){
 139:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 52                	je     197 <ls+0xea>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 98 01 00 00    	jne    2e6 <ls+0x239>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 160:	0f bf d8             	movswl %ax,%ebx
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 04 24             	mov    %eax,(%esp)
 169:	e8 92 fe ff ff       	call   0 <fmtname>
 16e:	89 7c 24 14          	mov    %edi,0x14(%esp)
 172:	89 74 24 10          	mov    %esi,0x10(%esp)
 176:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17a:	89 44 24 08          	mov    %eax,0x8(%esp)
 17e:	c7 44 24 04 58 0b 00 	movl   $0xb58,0x4(%esp)
 185:	00 
 186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18d:	e8 d9 05 00 00       	call   76b <printf>
    break;
 192:	e9 4f 01 00 00       	jmp    2e6 <ls+0x239>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 3f 02 00 00       	call   3e1 <strlen>
 1a2:	83 c0 10             	add    $0x10,%eax
 1a5:	3d 00 02 00 00       	cmp    $0x200,%eax
 1aa:	76 19                	jbe    1c5 <ls+0x118>
      printf(1, "ls: path too long\n");
 1ac:	c7 44 24 04 65 0b 00 	movl   $0xb65,0x4(%esp)
 1b3:	00 
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 ab 05 00 00       	call   76b <printf>
      break;
 1c0:	e9 21 01 00 00       	jmp    2e6 <ls+0x239>
    }
    strcpy(buf, path);
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d2:	89 04 24             	mov    %eax,(%esp)
 1d5:	e8 9d 01 00 00       	call   377 <strcpy>
    p = buf+strlen(buf);
 1da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e0:	89 04 24             	mov    %eax,(%esp)
 1e3:	e8 f9 01 00 00       	call   3e1 <strlen>
 1e8:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1ee:	01 d0                	add    %edx,%eax
 1f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f6:	c6 00 2f             	movb   $0x2f,(%eax)
 1f9:	ff 45 e0             	incl   -0x20(%ebp)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 be 00 00 00       	jmp    2bf <ls+0x212>
      if(de.inum == 0)
 201:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
 207:	66 85 c0             	test   %ax,%ax
 20a:	0f 84 ae 00 00 00    	je     2be <ls+0x211>
        continue;
      memmove(p, de.name, DIRSIZ);
 210:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 217:	00 
 218:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21e:	83 c0 02             	add    $0x2,%eax
 221:	89 44 24 04          	mov    %eax,0x4(%esp)
 225:	8b 45 e0             	mov    -0x20(%ebp),%eax
 228:	89 04 24             	mov    %eax,(%esp)
 22b:	e8 2c 03 00 00       	call   55c <memmove>
      p[DIRSIZ] = 0;
 230:	8b 45 e0             	mov    -0x20(%ebp),%eax
 233:	83 c0 0e             	add    $0xe,%eax
 236:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 239:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23f:	89 44 24 04          	mov    %eax,0x4(%esp)
 243:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 76 02 00 00       	call   4c7 <stat>
 251:	85 c0                	test   %eax,%eax
 253:	79 20                	jns    275 <ls+0x1c8>
        printf(1, "ls: cannot stat %s\n", buf);
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	89 44 24 08          	mov    %eax,0x8(%esp)
 25f:	c7 44 24 04 44 0b 00 	movl   $0xb44,0x4(%esp)
 266:	00 
 267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26e:	e8 f8 04 00 00       	call   76b <printf>
        continue;
 273:	eb 4a                	jmp    2bf <ls+0x212>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 275:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 27b:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 281:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
 287:	0f bf d8             	movswl %ax,%ebx
 28a:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 290:	89 04 24             	mov    %eax,(%esp)
 293:	e8 68 fd ff ff       	call   0 <fmtname>
 298:	89 7c 24 14          	mov    %edi,0x14(%esp)
 29c:	89 74 24 10          	mov    %esi,0x10(%esp)
 2a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a8:	c7 44 24 04 58 0b 00 	movl   $0xb58,0x4(%esp)
 2af:	00 
 2b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b7:	e8 af 04 00 00       	call   76b <printf>
 2bc:	eb 01                	jmp    2bf <ls+0x212>
        continue;
 2be:	90                   	nop
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2bf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2c6:	00 
 2c7:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 d7 02 00 00       	call   5b3 <read>
 2dc:	83 f8 10             	cmp    $0x10,%eax
 2df:	0f 84 1c ff ff ff    	je     201 <ls+0x154>
    }
    break;
 2e5:	90                   	nop
  }
  close(fd);
 2e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2e9:	89 04 24             	mov    %eax,(%esp)
 2ec:	e8 d2 02 00 00       	call   5c3 <close>
}
 2f1:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2f7:	5b                   	pop    %ebx
 2f8:	5e                   	pop    %esi
 2f9:	5f                   	pop    %edi
 2fa:	5d                   	pop    %ebp
 2fb:	c3                   	ret    

000002fc <main>:

int
main(int argc, char *argv[])
{
 2fc:	55                   	push   %ebp
 2fd:	89 e5                	mov    %esp,%ebp
 2ff:	83 e4 f0             	and    $0xfffffff0,%esp
 302:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 305:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 309:	7f 11                	jg     31c <main+0x20>
    ls(".");
 30b:	c7 04 24 78 0b 00 00 	movl   $0xb78,(%esp)
 312:	e8 96 fd ff ff       	call   ad <ls>
    exit();
 317:	e8 7f 02 00 00       	call   59b <exit>
  }
  for(i=1; i<argc; i++)
 31c:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 323:	00 
 324:	eb 1e                	jmp    344 <main+0x48>
    ls(argv[i]);
 326:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 32a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	01 d0                	add    %edx,%eax
 336:	8b 00                	mov    (%eax),%eax
 338:	89 04 24             	mov    %eax,(%esp)
 33b:	e8 6d fd ff ff       	call   ad <ls>
  for(i=1; i<argc; i++)
 340:	ff 44 24 1c          	incl   0x1c(%esp)
 344:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 348:	3b 45 08             	cmp    0x8(%ebp),%eax
 34b:	7c d9                	jl     326 <main+0x2a>
  exit();
 34d:	e8 49 02 00 00       	call   59b <exit>

00000352 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 352:	55                   	push   %ebp
 353:	89 e5                	mov    %esp,%ebp
 355:	57                   	push   %edi
 356:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 357:	8b 4d 08             	mov    0x8(%ebp),%ecx
 35a:	8b 55 10             	mov    0x10(%ebp),%edx
 35d:	8b 45 0c             	mov    0xc(%ebp),%eax
 360:	89 cb                	mov    %ecx,%ebx
 362:	89 df                	mov    %ebx,%edi
 364:	89 d1                	mov    %edx,%ecx
 366:	fc                   	cld    
 367:	f3 aa                	rep stos %al,%es:(%edi)
 369:	89 ca                	mov    %ecx,%edx
 36b:	89 fb                	mov    %edi,%ebx
 36d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 370:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 373:	5b                   	pop    %ebx
 374:	5f                   	pop    %edi
 375:	5d                   	pop    %ebp
 376:	c3                   	ret    

00000377 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 377:	55                   	push   %ebp
 378:	89 e5                	mov    %esp,%ebp
 37a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 383:	90                   	nop
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	8a 10                	mov    (%eax),%dl
 389:	8b 45 08             	mov    0x8(%ebp),%eax
 38c:	88 10                	mov    %dl,(%eax)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	8a 00                	mov    (%eax),%al
 393:	84 c0                	test   %al,%al
 395:	0f 95 c0             	setne  %al
 398:	ff 45 08             	incl   0x8(%ebp)
 39b:	ff 45 0c             	incl   0xc(%ebp)
 39e:	84 c0                	test   %al,%al
 3a0:	75 e2                	jne    384 <strcpy+0xd>
    ;
  return os;
 3a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3aa:	eb 06                	jmp    3b2 <strcmp+0xb>
    p++, q++;
 3ac:	ff 45 08             	incl   0x8(%ebp)
 3af:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	8a 00                	mov    (%eax),%al
 3b7:	84 c0                	test   %al,%al
 3b9:	74 0e                	je     3c9 <strcmp+0x22>
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	8a 10                	mov    (%eax),%dl
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	8a 00                	mov    (%eax),%al
 3c5:	38 c2                	cmp    %al,%dl
 3c7:	74 e3                	je     3ac <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	8a 00                	mov    (%eax),%al
 3ce:	0f b6 d0             	movzbl %al,%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	8a 00                	mov    (%eax),%al
 3d6:	0f b6 c0             	movzbl %al,%eax
 3d9:	89 d1                	mov    %edx,%ecx
 3db:	29 c1                	sub    %eax,%ecx
 3dd:	89 c8                	mov    %ecx,%eax
}
 3df:	5d                   	pop    %ebp
 3e0:	c3                   	ret    

000003e1 <strlen>:

uint
strlen(char *s)
{
 3e1:	55                   	push   %ebp
 3e2:	89 e5                	mov    %esp,%ebp
 3e4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ee:	eb 03                	jmp    3f3 <strlen+0x12>
 3f0:	ff 45 fc             	incl   -0x4(%ebp)
 3f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f6:	8b 45 08             	mov    0x8(%ebp),%eax
 3f9:	01 d0                	add    %edx,%eax
 3fb:	8a 00                	mov    (%eax),%al
 3fd:	84 c0                	test   %al,%al
 3ff:	75 ef                	jne    3f0 <strlen+0xf>
    ;
  return n;
 401:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 404:	c9                   	leave  
 405:	c3                   	ret    

00000406 <memset>:

void*
memset(void *dst, int c, uint n)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 40c:	8b 45 10             	mov    0x10(%ebp),%eax
 40f:	89 44 24 08          	mov    %eax,0x8(%esp)
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	89 44 24 04          	mov    %eax,0x4(%esp)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	89 04 24             	mov    %eax,(%esp)
 420:	e8 2d ff ff ff       	call   352 <stosb>
  return dst;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
}
 428:	c9                   	leave  
 429:	c3                   	ret    

0000042a <strchr>:

char*
strchr(const char *s, char c)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 04             	sub    $0x4,%esp
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 436:	eb 12                	jmp    44a <strchr+0x20>
    if(*s == c)
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	8a 00                	mov    (%eax),%al
 43d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 440:	75 05                	jne    447 <strchr+0x1d>
      return (char*)s;
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	eb 11                	jmp    458 <strchr+0x2e>
  for(; *s; s++)
 447:	ff 45 08             	incl   0x8(%ebp)
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	8a 00                	mov    (%eax),%al
 44f:	84 c0                	test   %al,%al
 451:	75 e5                	jne    438 <strchr+0xe>
  return 0;
 453:	b8 00 00 00 00       	mov    $0x0,%eax
}
 458:	c9                   	leave  
 459:	c3                   	ret    

0000045a <gets>:

char*
gets(char *buf, int max)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 460:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 467:	eb 42                	jmp    4ab <gets+0x51>
    cc = read(0, &c, 1);
 469:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 470:	00 
 471:	8d 45 ef             	lea    -0x11(%ebp),%eax
 474:	89 44 24 04          	mov    %eax,0x4(%esp)
 478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 47f:	e8 2f 01 00 00       	call   5b3 <read>
 484:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48b:	7e 29                	jle    4b6 <gets+0x5c>
      break;
    buf[i++] = c;
 48d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	01 c2                	add    %eax,%edx
 495:	8a 45 ef             	mov    -0x11(%ebp),%al
 498:	88 02                	mov    %al,(%edx)
 49a:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 49d:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a0:	3c 0a                	cmp    $0xa,%al
 4a2:	74 13                	je     4b7 <gets+0x5d>
 4a4:	8a 45 ef             	mov    -0x11(%ebp),%al
 4a7:	3c 0d                	cmp    $0xd,%al
 4a9:	74 0c                	je     4b7 <gets+0x5d>
  for(i=0; i+1 < max; ){
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	40                   	inc    %eax
 4af:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4b2:	7c b5                	jl     469 <gets+0xf>
 4b4:	eb 01                	jmp    4b7 <gets+0x5d>
      break;
 4b6:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	01 d0                	add    %edx,%eax
 4bf:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c5:	c9                   	leave  
 4c6:	c3                   	ret    

000004c7 <stat>:

int
stat(char *n, struct stat *st)
{
 4c7:	55                   	push   %ebp
 4c8:	89 e5                	mov    %esp,%ebp
 4ca:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4d4:	00 
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	89 04 24             	mov    %eax,(%esp)
 4db:	e8 fb 00 00 00       	call   5db <open>
 4e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4e7:	79 07                	jns    4f0 <stat+0x29>
    return -1;
 4e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4ee:	eb 23                	jmp    513 <stat+0x4c>
  r = fstat(fd, st);
 4f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fa:	89 04 24             	mov    %eax,(%esp)
 4fd:	e8 f1 00 00 00       	call   5f3 <fstat>
 502:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 505:	8b 45 f4             	mov    -0xc(%ebp),%eax
 508:	89 04 24             	mov    %eax,(%esp)
 50b:	e8 b3 00 00 00       	call   5c3 <close>
  return r;
 510:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 513:	c9                   	leave  
 514:	c3                   	ret    

00000515 <atoi>:

int
atoi(const char *s)
{
 515:	55                   	push   %ebp
 516:	89 e5                	mov    %esp,%ebp
 518:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 51b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 522:	eb 21                	jmp    545 <atoi+0x30>
    n = n*10 + *s++ - '0';
 524:	8b 55 fc             	mov    -0x4(%ebp),%edx
 527:	89 d0                	mov    %edx,%eax
 529:	c1 e0 02             	shl    $0x2,%eax
 52c:	01 d0                	add    %edx,%eax
 52e:	d1 e0                	shl    %eax
 530:	89 c2                	mov    %eax,%edx
 532:	8b 45 08             	mov    0x8(%ebp),%eax
 535:	8a 00                	mov    (%eax),%al
 537:	0f be c0             	movsbl %al,%eax
 53a:	01 d0                	add    %edx,%eax
 53c:	83 e8 30             	sub    $0x30,%eax
 53f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 542:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	8a 00                	mov    (%eax),%al
 54a:	3c 2f                	cmp    $0x2f,%al
 54c:	7e 09                	jle    557 <atoi+0x42>
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	8a 00                	mov    (%eax),%al
 553:	3c 39                	cmp    $0x39,%al
 555:	7e cd                	jle    524 <atoi+0xf>
  return n;
 557:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 55a:	c9                   	leave  
 55b:	c3                   	ret    

0000055c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 55c:	55                   	push   %ebp
 55d:	89 e5                	mov    %esp,%ebp
 55f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 562:	8b 45 08             	mov    0x8(%ebp),%eax
 565:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 568:	8b 45 0c             	mov    0xc(%ebp),%eax
 56b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 56e:	eb 10                	jmp    580 <memmove+0x24>
    *dst++ = *src++;
 570:	8b 45 f8             	mov    -0x8(%ebp),%eax
 573:	8a 10                	mov    (%eax),%dl
 575:	8b 45 fc             	mov    -0x4(%ebp),%eax
 578:	88 10                	mov    %dl,(%eax)
 57a:	ff 45 fc             	incl   -0x4(%ebp)
 57d:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 580:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 584:	0f 9f c0             	setg   %al
 587:	ff 4d 10             	decl   0x10(%ebp)
 58a:	84 c0                	test   %al,%al
 58c:	75 e2                	jne    570 <memmove+0x14>
  return vdst;
 58e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 591:	c9                   	leave  
 592:	c3                   	ret    

00000593 <fork>:
 593:	b8 01 00 00 00       	mov    $0x1,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <exit>:
 59b:	b8 02 00 00 00       	mov    $0x2,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <wait>:
 5a3:	b8 03 00 00 00       	mov    $0x3,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <pipe>:
 5ab:	b8 04 00 00 00       	mov    $0x4,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <read>:
 5b3:	b8 05 00 00 00       	mov    $0x5,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <write>:
 5bb:	b8 10 00 00 00       	mov    $0x10,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <close>:
 5c3:	b8 15 00 00 00       	mov    $0x15,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <kill>:
 5cb:	b8 06 00 00 00       	mov    $0x6,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <exec>:
 5d3:	b8 07 00 00 00       	mov    $0x7,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <open>:
 5db:	b8 0f 00 00 00       	mov    $0xf,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <mknod>:
 5e3:	b8 11 00 00 00       	mov    $0x11,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <unlink>:
 5eb:	b8 12 00 00 00       	mov    $0x12,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <fstat>:
 5f3:	b8 08 00 00 00       	mov    $0x8,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <link>:
 5fb:	b8 13 00 00 00       	mov    $0x13,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <mkdir>:
 603:	b8 14 00 00 00       	mov    $0x14,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <chdir>:
 60b:	b8 09 00 00 00       	mov    $0x9,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <dup>:
 613:	b8 0a 00 00 00       	mov    $0xa,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <getpid>:
 61b:	b8 0b 00 00 00       	mov    $0xb,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <sbrk>:
 623:	b8 0c 00 00 00       	mov    $0xc,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <sleep>:
 62b:	b8 0d 00 00 00       	mov    $0xd,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <uptime>:
 633:	b8 0e 00 00 00       	mov    $0xe,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <lseek>:
 63b:	b8 16 00 00 00       	mov    $0x16,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <isatty>:
 643:	b8 17 00 00 00       	mov    $0x17,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <procstat>:
 64b:	b8 18 00 00 00       	mov    $0x18,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <set_priority>:
 653:	b8 19 00 00 00       	mov    $0x19,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <semget>:
 65b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <semfree>:
 663:	b8 1b 00 00 00       	mov    $0x1b,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <semdown>:
 66b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <semup>:
 673:	b8 1d 00 00 00       	mov    $0x1d,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <shm_create>:
 67b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <shm_close>:
 683:	b8 1f 00 00 00       	mov    $0x1f,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <shm_get>:
 68b:	b8 20 00 00 00       	mov    $0x20,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 693:	55                   	push   %ebp
 694:	89 e5                	mov    %esp,%ebp
 696:	83 ec 28             	sub    $0x28,%esp
 699:	8b 45 0c             	mov    0xc(%ebp),%eax
 69c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 69f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a6:	00 
 6a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ae:	8b 45 08             	mov    0x8(%ebp),%eax
 6b1:	89 04 24             	mov    %eax,(%esp)
 6b4:	e8 02 ff ff ff       	call   5bb <write>
}
 6b9:	c9                   	leave  
 6ba:	c3                   	ret    

000006bb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6bb:	55                   	push   %ebp
 6bc:	89 e5                	mov    %esp,%ebp
 6be:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6c8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6cc:	74 17                	je     6e5 <printint+0x2a>
 6ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6d2:	79 11                	jns    6e5 <printint+0x2a>
    neg = 1;
 6d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6db:	8b 45 0c             	mov    0xc(%ebp),%eax
 6de:	f7 d8                	neg    %eax
 6e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e3:	eb 06                	jmp    6eb <printint+0x30>
  } else {
    x = xx;
 6e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6f8:	ba 00 00 00 00       	mov    $0x0,%edx
 6fd:	f7 f1                	div    %ecx
 6ff:	89 d0                	mov    %edx,%eax
 701:	8a 80 14 0e 00 00    	mov    0xe14(%eax),%al
 707:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 70a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 70d:	01 ca                	add    %ecx,%edx
 70f:	88 02                	mov    %al,(%edx)
 711:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 714:	8b 55 10             	mov    0x10(%ebp),%edx
 717:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 71a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71d:	ba 00 00 00 00       	mov    $0x0,%edx
 722:	f7 75 d4             	divl   -0x2c(%ebp)
 725:	89 45 ec             	mov    %eax,-0x14(%ebp)
 728:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 72c:	75 c4                	jne    6f2 <printint+0x37>
  if(neg)
 72e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 732:	74 2c                	je     760 <printint+0xa5>
    buf[i++] = '-';
 734:	8d 55 dc             	lea    -0x24(%ebp),%edx
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	01 d0                	add    %edx,%eax
 73c:	c6 00 2d             	movb   $0x2d,(%eax)
 73f:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 742:	eb 1c                	jmp    760 <printint+0xa5>
    putc(fd, buf[i]);
 744:	8d 55 dc             	lea    -0x24(%ebp),%edx
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	01 d0                	add    %edx,%eax
 74c:	8a 00                	mov    (%eax),%al
 74e:	0f be c0             	movsbl %al,%eax
 751:	89 44 24 04          	mov    %eax,0x4(%esp)
 755:	8b 45 08             	mov    0x8(%ebp),%eax
 758:	89 04 24             	mov    %eax,(%esp)
 75b:	e8 33 ff ff ff       	call   693 <putc>
  while(--i >= 0)
 760:	ff 4d f4             	decl   -0xc(%ebp)
 763:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 767:	79 db                	jns    744 <printint+0x89>
}
 769:	c9                   	leave  
 76a:	c3                   	ret    

0000076b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 76b:	55                   	push   %ebp
 76c:	89 e5                	mov    %esp,%ebp
 76e:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 771:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 778:	8d 45 0c             	lea    0xc(%ebp),%eax
 77b:	83 c0 04             	add    $0x4,%eax
 77e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 781:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 788:	e9 78 01 00 00       	jmp    905 <printf+0x19a>
    c = fmt[i] & 0xff;
 78d:	8b 55 0c             	mov    0xc(%ebp),%edx
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	01 d0                	add    %edx,%eax
 795:	8a 00                	mov    (%eax),%al
 797:	0f be c0             	movsbl %al,%eax
 79a:	25 ff 00 00 00       	and    $0xff,%eax
 79f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7a6:	75 2c                	jne    7d4 <printf+0x69>
      if(c == '%'){
 7a8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7ac:	75 0c                	jne    7ba <printf+0x4f>
        state = '%';
 7ae:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7b5:	e9 48 01 00 00       	jmp    902 <printf+0x197>
      } else {
        putc(fd, c);
 7ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7bd:	0f be c0             	movsbl %al,%eax
 7c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
 7c7:	89 04 24             	mov    %eax,(%esp)
 7ca:	e8 c4 fe ff ff       	call   693 <putc>
 7cf:	e9 2e 01 00 00       	jmp    902 <printf+0x197>
      }
    } else if(state == '%'){
 7d4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7d8:	0f 85 24 01 00 00    	jne    902 <printf+0x197>
      if(c == 'd'){
 7de:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7e2:	75 2d                	jne    811 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7f0:	00 
 7f1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7f8:	00 
 7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	89 04 24             	mov    %eax,(%esp)
 803:	e8 b3 fe ff ff       	call   6bb <printint>
        ap++;
 808:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80c:	e9 ea 00 00 00       	jmp    8fb <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 811:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 815:	74 06                	je     81d <printf+0xb2>
 817:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 81b:	75 2d                	jne    84a <printf+0xdf>
        printint(fd, *ap, 16, 0);
 81d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 820:	8b 00                	mov    (%eax),%eax
 822:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 829:	00 
 82a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 831:	00 
 832:	89 44 24 04          	mov    %eax,0x4(%esp)
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	89 04 24             	mov    %eax,(%esp)
 83c:	e8 7a fe ff ff       	call   6bb <printint>
        ap++;
 841:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 845:	e9 b1 00 00 00       	jmp    8fb <printf+0x190>
      } else if(c == 's'){
 84a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 84e:	75 43                	jne    893 <printf+0x128>
        s = (char*)*ap;
 850:	8b 45 e8             	mov    -0x18(%ebp),%eax
 853:	8b 00                	mov    (%eax),%eax
 855:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 858:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 85c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 860:	75 25                	jne    887 <printf+0x11c>
          s = "(null)";
 862:	c7 45 f4 7a 0b 00 00 	movl   $0xb7a,-0xc(%ebp)
        while(*s != 0){
 869:	eb 1c                	jmp    887 <printf+0x11c>
          putc(fd, *s);
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8a 00                	mov    (%eax),%al
 870:	0f be c0             	movsbl %al,%eax
 873:	89 44 24 04          	mov    %eax,0x4(%esp)
 877:	8b 45 08             	mov    0x8(%ebp),%eax
 87a:	89 04 24             	mov    %eax,(%esp)
 87d:	e8 11 fe ff ff       	call   693 <putc>
          s++;
 882:	ff 45 f4             	incl   -0xc(%ebp)
 885:	eb 01                	jmp    888 <printf+0x11d>
        while(*s != 0){
 887:	90                   	nop
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8a 00                	mov    (%eax),%al
 88d:	84 c0                	test   %al,%al
 88f:	75 da                	jne    86b <printf+0x100>
 891:	eb 68                	jmp    8fb <printf+0x190>
        }
      } else if(c == 'c'){
 893:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 897:	75 1d                	jne    8b6 <printf+0x14b>
        putc(fd, *ap);
 899:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89c:	8b 00                	mov    (%eax),%eax
 89e:	0f be c0             	movsbl %al,%eax
 8a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a5:	8b 45 08             	mov    0x8(%ebp),%eax
 8a8:	89 04 24             	mov    %eax,(%esp)
 8ab:	e8 e3 fd ff ff       	call   693 <putc>
        ap++;
 8b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b4:	eb 45                	jmp    8fb <printf+0x190>
      } else if(c == '%'){
 8b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ba:	75 17                	jne    8d3 <printf+0x168>
        putc(fd, c);
 8bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8bf:	0f be c0             	movsbl %al,%eax
 8c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	89 04 24             	mov    %eax,(%esp)
 8cc:	e8 c2 fd ff ff       	call   693 <putc>
 8d1:	eb 28                	jmp    8fb <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8da:	00 
 8db:	8b 45 08             	mov    0x8(%ebp),%eax
 8de:	89 04 24             	mov    %eax,(%esp)
 8e1:	e8 ad fd ff ff       	call   693 <putc>
        putc(fd, c);
 8e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e9:	0f be c0             	movsbl %al,%eax
 8ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f0:	8b 45 08             	mov    0x8(%ebp),%eax
 8f3:	89 04 24             	mov    %eax,(%esp)
 8f6:	e8 98 fd ff ff       	call   693 <putc>
      }
      state = 0;
 8fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 902:	ff 45 f0             	incl   -0x10(%ebp)
 905:	8b 55 0c             	mov    0xc(%ebp),%edx
 908:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90b:	01 d0                	add    %edx,%eax
 90d:	8a 00                	mov    (%eax),%al
 90f:	84 c0                	test   %al,%al
 911:	0f 85 76 fe ff ff    	jne    78d <printf+0x22>
    }
  }
}
 917:	c9                   	leave  
 918:	c3                   	ret    

00000919 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 919:	55                   	push   %ebp
 91a:	89 e5                	mov    %esp,%ebp
 91c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 91f:	8b 45 08             	mov    0x8(%ebp),%eax
 922:	83 e8 08             	sub    $0x8,%eax
 925:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 928:	a1 40 0e 00 00       	mov    0xe40,%eax
 92d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 930:	eb 24                	jmp    956 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 932:	8b 45 fc             	mov    -0x4(%ebp),%eax
 935:	8b 00                	mov    (%eax),%eax
 937:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93a:	77 12                	ja     94e <free+0x35>
 93c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 942:	77 24                	ja     968 <free+0x4f>
 944:	8b 45 fc             	mov    -0x4(%ebp),%eax
 947:	8b 00                	mov    (%eax),%eax
 949:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94c:	77 1a                	ja     968 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	8b 00                	mov    (%eax),%eax
 953:	89 45 fc             	mov    %eax,-0x4(%ebp)
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95c:	76 d4                	jbe    932 <free+0x19>
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	8b 00                	mov    (%eax),%eax
 963:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 966:	76 ca                	jbe    932 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 968:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96b:	8b 40 04             	mov    0x4(%eax),%eax
 96e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 975:	8b 45 f8             	mov    -0x8(%ebp),%eax
 978:	01 c2                	add    %eax,%edx
 97a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97d:	8b 00                	mov    (%eax),%eax
 97f:	39 c2                	cmp    %eax,%edx
 981:	75 24                	jne    9a7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	8b 50 04             	mov    0x4(%eax),%edx
 989:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98c:	8b 00                	mov    (%eax),%eax
 98e:	8b 40 04             	mov    0x4(%eax),%eax
 991:	01 c2                	add    %eax,%edx
 993:	8b 45 f8             	mov    -0x8(%ebp),%eax
 996:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	8b 00                	mov    (%eax),%eax
 99e:	8b 10                	mov    (%eax),%edx
 9a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a3:	89 10                	mov    %edx,(%eax)
 9a5:	eb 0a                	jmp    9b1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9aa:	8b 10                	mov    (%eax),%edx
 9ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9af:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b4:	8b 40 04             	mov    0x4(%eax),%eax
 9b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c1:	01 d0                	add    %edx,%eax
 9c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c6:	75 20                	jne    9e8 <free+0xcf>
    p->s.size += bp->s.size;
 9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cb:	8b 50 04             	mov    0x4(%eax),%edx
 9ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d1:	8b 40 04             	mov    0x4(%eax),%eax
 9d4:	01 c2                	add    %eax,%edx
 9d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9df:	8b 10                	mov    (%eax),%edx
 9e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e4:	89 10                	mov    %edx,(%eax)
 9e6:	eb 08                	jmp    9f0 <free+0xd7>
  } else
    p->s.ptr = bp;
 9e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9eb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9ee:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f3:	a3 40 0e 00 00       	mov    %eax,0xe40
}
 9f8:	c9                   	leave  
 9f9:	c3                   	ret    

000009fa <morecore>:

static Header*
morecore(uint nu)
{
 9fa:	55                   	push   %ebp
 9fb:	89 e5                	mov    %esp,%ebp
 9fd:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a00:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a07:	77 07                	ja     a10 <morecore+0x16>
    nu = 4096;
 a09:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	c1 e0 03             	shl    $0x3,%eax
 a16:	89 04 24             	mov    %eax,(%esp)
 a19:	e8 05 fc ff ff       	call   623 <sbrk>
 a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a21:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a25:	75 07                	jne    a2e <morecore+0x34>
    return 0;
 a27:	b8 00 00 00 00       	mov    $0x0,%eax
 a2c:	eb 22                	jmp    a50 <morecore+0x56>
  hp = (Header*)p;
 a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a37:	8b 55 08             	mov    0x8(%ebp),%edx
 a3a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a40:	83 c0 08             	add    $0x8,%eax
 a43:	89 04 24             	mov    %eax,(%esp)
 a46:	e8 ce fe ff ff       	call   919 <free>
  return freep;
 a4b:	a1 40 0e 00 00       	mov    0xe40,%eax
}
 a50:	c9                   	leave  
 a51:	c3                   	ret    

00000a52 <malloc>:

void*
malloc(uint nbytes)
{
 a52:	55                   	push   %ebp
 a53:	89 e5                	mov    %esp,%ebp
 a55:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a58:	8b 45 08             	mov    0x8(%ebp),%eax
 a5b:	83 c0 07             	add    $0x7,%eax
 a5e:	c1 e8 03             	shr    $0x3,%eax
 a61:	40                   	inc    %eax
 a62:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a65:	a1 40 0e 00 00       	mov    0xe40,%eax
 a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a6d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a71:	75 23                	jne    a96 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a73:	c7 45 f0 38 0e 00 00 	movl   $0xe38,-0x10(%ebp)
 a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7d:	a3 40 0e 00 00       	mov    %eax,0xe40
 a82:	a1 40 0e 00 00       	mov    0xe40,%eax
 a87:	a3 38 0e 00 00       	mov    %eax,0xe38
    base.s.size = 0;
 a8c:	c7 05 3c 0e 00 00 00 	movl   $0x0,0xe3c
 a93:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a99:	8b 00                	mov    (%eax),%eax
 a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa1:	8b 40 04             	mov    0x4(%eax),%eax
 aa4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 aa7:	72 4d                	jb     af6 <malloc+0xa4>
      if(p->s.size == nunits)
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	8b 40 04             	mov    0x4(%eax),%eax
 aaf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab2:	75 0c                	jne    ac0 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab7:	8b 10                	mov    (%eax),%edx
 ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abc:	89 10                	mov    %edx,(%eax)
 abe:	eb 26                	jmp    ae6 <malloc+0x94>
      else {
        p->s.size -= nunits;
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	89 c2                	mov    %eax,%edx
 ac8:	2b 55 ec             	sub    -0x14(%ebp),%edx
 acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ace:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad4:	8b 40 04             	mov    0x4(%eax),%eax
 ad7:	c1 e0 03             	shl    $0x3,%eax
 ada:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 add:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ae3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae9:	a3 40 0e 00 00       	mov    %eax,0xe40
      return (void*)(p + 1);
 aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af1:	83 c0 08             	add    $0x8,%eax
 af4:	eb 38                	jmp    b2e <malloc+0xdc>
    }
    if(p == freep)
 af6:	a1 40 0e 00 00       	mov    0xe40,%eax
 afb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 afe:	75 1b                	jne    b1b <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b03:	89 04 24             	mov    %eax,(%esp)
 b06:	e8 ef fe ff ff       	call   9fa <morecore>
 b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b12:	75 07                	jne    b1b <malloc+0xc9>
        return 0;
 b14:	b8 00 00 00 00       	mov    $0x0,%eax
 b19:	eb 13                	jmp    b2e <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b24:	8b 00                	mov    (%eax),%eax
 b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 b29:	e9 70 ff ff ff       	jmp    a9e <malloc+0x4c>
}
 b2e:	c9                   	leave  
 b2f:	c3                   	ret    
