
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
  5e:	c7 04 24 f0 0d 00 00 	movl   $0xdf0,(%esp)
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
  89:	05 f0 0d 00 00       	add    $0xdf0,%eax
  8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  99:	00 
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 64 03 00 00       	call   406 <memset>
  return buf;
  a2:	b8 f0 0d 00 00       	mov    $0xdf0,%eax
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
  dc:	c7 44 24 04 f8 0a 00 	movl   $0xaf8,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  eb:	e8 43 06 00 00       	call   733 <printf>
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
 115:	c7 44 24 04 0c 0b 00 	movl   $0xb0c,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 0a 06 00 00       	call   733 <printf>
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
 17e:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
 185:	00 
 186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18d:	e8 a1 05 00 00       	call   733 <printf>
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
 1ac:	c7 44 24 04 2d 0b 00 	movl   $0xb2d,0x4(%esp)
 1b3:	00 
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 73 05 00 00       	call   733 <printf>
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
 25f:	c7 44 24 04 0c 0b 00 	movl   $0xb0c,0x4(%esp)
 266:	00 
 267:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26e:	e8 c0 04 00 00       	call   733 <printf>
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
 2a8:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
 2af:	00 
 2b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b7:	e8 77 04 00 00       	call   733 <printf>
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
 30b:	c7 04 24 40 0b 00 00 	movl   $0xb40,(%esp)
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

0000065b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 65b:	55                   	push   %ebp
 65c:	89 e5                	mov    %esp,%ebp
 65e:	83 ec 28             	sub    $0x28,%esp
 661:	8b 45 0c             	mov    0xc(%ebp),%eax
 664:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 667:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 66e:	00 
 66f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 672:	89 44 24 04          	mov    %eax,0x4(%esp)
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	89 04 24             	mov    %eax,(%esp)
 67c:	e8 3a ff ff ff       	call   5bb <write>
}
 681:	c9                   	leave  
 682:	c3                   	ret    

00000683 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 683:	55                   	push   %ebp
 684:	89 e5                	mov    %esp,%ebp
 686:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 689:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 690:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 694:	74 17                	je     6ad <printint+0x2a>
 696:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 69a:	79 11                	jns    6ad <printint+0x2a>
    neg = 1;
 69c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a6:	f7 d8                	neg    %eax
 6a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6ab:	eb 06                	jmp    6b3 <printint+0x30>
  } else {
    x = xx;
 6ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6c0:	ba 00 00 00 00       	mov    $0x0,%edx
 6c5:	f7 f1                	div    %ecx
 6c7:	89 d0                	mov    %edx,%eax
 6c9:	8a 80 dc 0d 00 00    	mov    0xddc(%eax),%al
 6cf:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6d5:	01 ca                	add    %ecx,%edx
 6d7:	88 02                	mov    %al,(%edx)
 6d9:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 6dc:	8b 55 10             	mov    0x10(%ebp),%edx
 6df:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e5:	ba 00 00 00 00       	mov    $0x0,%edx
 6ea:	f7 75 d4             	divl   -0x2c(%ebp)
 6ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6f4:	75 c4                	jne    6ba <printint+0x37>
  if(neg)
 6f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fa:	74 2c                	je     728 <printint+0xa5>
    buf[i++] = '-';
 6fc:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 702:	01 d0                	add    %edx,%eax
 704:	c6 00 2d             	movb   $0x2d,(%eax)
 707:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 70a:	eb 1c                	jmp    728 <printint+0xa5>
    putc(fd, buf[i]);
 70c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	01 d0                	add    %edx,%eax
 714:	8a 00                	mov    (%eax),%al
 716:	0f be c0             	movsbl %al,%eax
 719:	89 44 24 04          	mov    %eax,0x4(%esp)
 71d:	8b 45 08             	mov    0x8(%ebp),%eax
 720:	89 04 24             	mov    %eax,(%esp)
 723:	e8 33 ff ff ff       	call   65b <putc>
  while(--i >= 0)
 728:	ff 4d f4             	decl   -0xc(%ebp)
 72b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72f:	79 db                	jns    70c <printint+0x89>
}
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 739:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 740:	8d 45 0c             	lea    0xc(%ebp),%eax
 743:	83 c0 04             	add    $0x4,%eax
 746:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 749:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 750:	e9 78 01 00 00       	jmp    8cd <printf+0x19a>
    c = fmt[i] & 0xff;
 755:	8b 55 0c             	mov    0xc(%ebp),%edx
 758:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75b:	01 d0                	add    %edx,%eax
 75d:	8a 00                	mov    (%eax),%al
 75f:	0f be c0             	movsbl %al,%eax
 762:	25 ff 00 00 00       	and    $0xff,%eax
 767:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 76a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 76e:	75 2c                	jne    79c <printf+0x69>
      if(c == '%'){
 770:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 774:	75 0c                	jne    782 <printf+0x4f>
        state = '%';
 776:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 77d:	e9 48 01 00 00       	jmp    8ca <printf+0x197>
      } else {
        putc(fd, c);
 782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 785:	0f be c0             	movsbl %al,%eax
 788:	89 44 24 04          	mov    %eax,0x4(%esp)
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 c4 fe ff ff       	call   65b <putc>
 797:	e9 2e 01 00 00       	jmp    8ca <printf+0x197>
      }
    } else if(state == '%'){
 79c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7a0:	0f 85 24 01 00 00    	jne    8ca <printf+0x197>
      if(c == 'd'){
 7a6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7aa:	75 2d                	jne    7d9 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 7b8:	00 
 7b9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7c0:	00 
 7c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	89 04 24             	mov    %eax,(%esp)
 7cb:	e8 b3 fe ff ff       	call   683 <printint>
        ap++;
 7d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d4:	e9 ea 00 00 00       	jmp    8c3 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 7d9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7dd:	74 06                	je     7e5 <printf+0xb2>
 7df:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7e3:	75 2d                	jne    812 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 7e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7e8:	8b 00                	mov    (%eax),%eax
 7ea:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7f1:	00 
 7f2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7f9:	00 
 7fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	89 04 24             	mov    %eax,(%esp)
 804:	e8 7a fe ff ff       	call   683 <printint>
        ap++;
 809:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80d:	e9 b1 00 00 00       	jmp    8c3 <printf+0x190>
      } else if(c == 's'){
 812:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 816:	75 43                	jne    85b <printf+0x128>
        s = (char*)*ap;
 818:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 820:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 824:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 828:	75 25                	jne    84f <printf+0x11c>
          s = "(null)";
 82a:	c7 45 f4 42 0b 00 00 	movl   $0xb42,-0xc(%ebp)
        while(*s != 0){
 831:	eb 1c                	jmp    84f <printf+0x11c>
          putc(fd, *s);
 833:	8b 45 f4             	mov    -0xc(%ebp),%eax
 836:	8a 00                	mov    (%eax),%al
 838:	0f be c0             	movsbl %al,%eax
 83b:	89 44 24 04          	mov    %eax,0x4(%esp)
 83f:	8b 45 08             	mov    0x8(%ebp),%eax
 842:	89 04 24             	mov    %eax,(%esp)
 845:	e8 11 fe ff ff       	call   65b <putc>
          s++;
 84a:	ff 45 f4             	incl   -0xc(%ebp)
 84d:	eb 01                	jmp    850 <printf+0x11d>
        while(*s != 0){
 84f:	90                   	nop
 850:	8b 45 f4             	mov    -0xc(%ebp),%eax
 853:	8a 00                	mov    (%eax),%al
 855:	84 c0                	test   %al,%al
 857:	75 da                	jne    833 <printf+0x100>
 859:	eb 68                	jmp    8c3 <printf+0x190>
        }
      } else if(c == 'c'){
 85b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 85f:	75 1d                	jne    87e <printf+0x14b>
        putc(fd, *ap);
 861:	8b 45 e8             	mov    -0x18(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	0f be c0             	movsbl %al,%eax
 869:	89 44 24 04          	mov    %eax,0x4(%esp)
 86d:	8b 45 08             	mov    0x8(%ebp),%eax
 870:	89 04 24             	mov    %eax,(%esp)
 873:	e8 e3 fd ff ff       	call   65b <putc>
        ap++;
 878:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 87c:	eb 45                	jmp    8c3 <printf+0x190>
      } else if(c == '%'){
 87e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 882:	75 17                	jne    89b <printf+0x168>
        putc(fd, c);
 884:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 887:	0f be c0             	movsbl %al,%eax
 88a:	89 44 24 04          	mov    %eax,0x4(%esp)
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
 891:	89 04 24             	mov    %eax,(%esp)
 894:	e8 c2 fd ff ff       	call   65b <putc>
 899:	eb 28                	jmp    8c3 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 89b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8a2:	00 
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
 8a6:	89 04 24             	mov    %eax,(%esp)
 8a9:	e8 ad fd ff ff       	call   65b <putc>
        putc(fd, c);
 8ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8b1:	0f be c0             	movsbl %al,%eax
 8b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b8:	8b 45 08             	mov    0x8(%ebp),%eax
 8bb:	89 04 24             	mov    %eax,(%esp)
 8be:	e8 98 fd ff ff       	call   65b <putc>
      }
      state = 0;
 8c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8ca:	ff 45 f0             	incl   -0x10(%ebp)
 8cd:	8b 55 0c             	mov    0xc(%ebp),%edx
 8d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d3:	01 d0                	add    %edx,%eax
 8d5:	8a 00                	mov    (%eax),%al
 8d7:	84 c0                	test   %al,%al
 8d9:	0f 85 76 fe ff ff    	jne    755 <printf+0x22>
    }
  }
}
 8df:	c9                   	leave  
 8e0:	c3                   	ret    

000008e1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e1:	55                   	push   %ebp
 8e2:	89 e5                	mov    %esp,%ebp
 8e4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ea:	83 e8 08             	sub    $0x8,%eax
 8ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f0:	a1 08 0e 00 00       	mov    0xe08,%eax
 8f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8f8:	eb 24                	jmp    91e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 902:	77 12                	ja     916 <free+0x35>
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 90a:	77 24                	ja     930 <free+0x4f>
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 00                	mov    (%eax),%eax
 911:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 914:	77 1a                	ja     930 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	8b 45 fc             	mov    -0x4(%ebp),%eax
 919:	8b 00                	mov    (%eax),%eax
 91b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 91e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 921:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 924:	76 d4                	jbe    8fa <free+0x19>
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	8b 00                	mov    (%eax),%eax
 92b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 92e:	76 ca                	jbe    8fa <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 93d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 940:	01 c2                	add    %eax,%edx
 942:	8b 45 fc             	mov    -0x4(%ebp),%eax
 945:	8b 00                	mov    (%eax),%eax
 947:	39 c2                	cmp    %eax,%edx
 949:	75 24                	jne    96f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 94b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 94e:	8b 50 04             	mov    0x4(%eax),%edx
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	8b 40 04             	mov    0x4(%eax),%eax
 959:	01 c2                	add    %eax,%edx
 95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	8b 00                	mov    (%eax),%eax
 966:	8b 10                	mov    (%eax),%edx
 968:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96b:	89 10                	mov    %edx,(%eax)
 96d:	eb 0a                	jmp    979 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 96f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 972:	8b 10                	mov    (%eax),%edx
 974:	8b 45 f8             	mov    -0x8(%ebp),%eax
 977:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	8b 40 04             	mov    0x4(%eax),%eax
 97f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 986:	8b 45 fc             	mov    -0x4(%ebp),%eax
 989:	01 d0                	add    %edx,%eax
 98b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 98e:	75 20                	jne    9b0 <free+0xcf>
    p->s.size += bp->s.size;
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	8b 50 04             	mov    0x4(%eax),%edx
 996:	8b 45 f8             	mov    -0x8(%ebp),%eax
 999:	8b 40 04             	mov    0x4(%eax),%eax
 99c:	01 c2                	add    %eax,%edx
 99e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9a4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a7:	8b 10                	mov    (%eax),%edx
 9a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ac:	89 10                	mov    %edx,(%eax)
 9ae:	eb 08                	jmp    9b8 <free+0xd7>
  } else
    p->s.ptr = bp;
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9b6:	89 10                	mov    %edx,(%eax)
  freep = p;
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bb:	a3 08 0e 00 00       	mov    %eax,0xe08
}
 9c0:	c9                   	leave  
 9c1:	c3                   	ret    

000009c2 <morecore>:

static Header*
morecore(uint nu)
{
 9c2:	55                   	push   %ebp
 9c3:	89 e5                	mov    %esp,%ebp
 9c5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9c8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9cf:	77 07                	ja     9d8 <morecore+0x16>
    nu = 4096;
 9d1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9d8:	8b 45 08             	mov    0x8(%ebp),%eax
 9db:	c1 e0 03             	shl    $0x3,%eax
 9de:	89 04 24             	mov    %eax,(%esp)
 9e1:	e8 3d fc ff ff       	call   623 <sbrk>
 9e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9e9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9ed:	75 07                	jne    9f6 <morecore+0x34>
    return 0;
 9ef:	b8 00 00 00 00       	mov    $0x0,%eax
 9f4:	eb 22                	jmp    a18 <morecore+0x56>
  hp = (Header*)p;
 9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ff:	8b 55 08             	mov    0x8(%ebp),%edx
 a02:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a08:	83 c0 08             	add    $0x8,%eax
 a0b:	89 04 24             	mov    %eax,(%esp)
 a0e:	e8 ce fe ff ff       	call   8e1 <free>
  return freep;
 a13:	a1 08 0e 00 00       	mov    0xe08,%eax
}
 a18:	c9                   	leave  
 a19:	c3                   	ret    

00000a1a <malloc>:

void*
malloc(uint nbytes)
{
 a1a:	55                   	push   %ebp
 a1b:	89 e5                	mov    %esp,%ebp
 a1d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a20:	8b 45 08             	mov    0x8(%ebp),%eax
 a23:	83 c0 07             	add    $0x7,%eax
 a26:	c1 e8 03             	shr    $0x3,%eax
 a29:	40                   	inc    %eax
 a2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a2d:	a1 08 0e 00 00       	mov    0xe08,%eax
 a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a39:	75 23                	jne    a5e <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a3b:	c7 45 f0 00 0e 00 00 	movl   $0xe00,-0x10(%ebp)
 a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a45:	a3 08 0e 00 00       	mov    %eax,0xe08
 a4a:	a1 08 0e 00 00       	mov    0xe08,%eax
 a4f:	a3 00 0e 00 00       	mov    %eax,0xe00
    base.s.size = 0;
 a54:	c7 05 04 0e 00 00 00 	movl   $0x0,0xe04
 a5b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a61:	8b 00                	mov    (%eax),%eax
 a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	8b 40 04             	mov    0x4(%eax),%eax
 a6c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a6f:	72 4d                	jb     abe <malloc+0xa4>
      if(p->s.size == nunits)
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 40 04             	mov    0x4(%eax),%eax
 a77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a7a:	75 0c                	jne    a88 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	8b 10                	mov    (%eax),%edx
 a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a84:	89 10                	mov    %edx,(%eax)
 a86:	eb 26                	jmp    aae <malloc+0x94>
      else {
        p->s.size -= nunits;
 a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8b:	8b 40 04             	mov    0x4(%eax),%eax
 a8e:	89 c2                	mov    %eax,%edx
 a90:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a96:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9c:	8b 40 04             	mov    0x4(%eax),%eax
 a9f:	c1 e0 03             	shl    $0x3,%eax
 aa2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 aab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab1:	a3 08 0e 00 00       	mov    %eax,0xe08
      return (void*)(p + 1);
 ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab9:	83 c0 08             	add    $0x8,%eax
 abc:	eb 38                	jmp    af6 <malloc+0xdc>
    }
    if(p == freep)
 abe:	a1 08 0e 00 00       	mov    0xe08,%eax
 ac3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ac6:	75 1b                	jne    ae3 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 acb:	89 04 24             	mov    %eax,(%esp)
 ace:	e8 ef fe ff ff       	call   9c2 <morecore>
 ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ada:	75 07                	jne    ae3 <malloc+0xc9>
        return 0;
 adc:	b8 00 00 00 00       	mov    $0x0,%eax
 ae1:	eb 13                	jmp    af6 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aec:	8b 00                	mov    (%eax),%eax
 aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 af1:	e9 70 ff ff ff       	jmp    a66 <malloc+0x4c>
}
 af6:	c9                   	leave  
 af7:	c3                   	ret    
