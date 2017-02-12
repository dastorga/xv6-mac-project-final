
_sharedtest:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test_0>:
#include "user.h"
#include "fcntl.h"

// test shm_create and shm_get
void
test_0(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int keyIndex; //declaro variable de tipo int
  char* index = 0; // declaro puntero
   6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  keyIndex = shm_create(); // creo el espacio de memoria a compartir
   d:	e8 22 05 00 00       	call   534 <shm_create>
  12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // Operador de Dirección (&): Este nos permite acceder a la dirección de memoria de una variable.
  // Operador de Indirección (*): Además de que nos permite declarar un tipo de dato puntero, también nos permite ver el VALOR que está en la dirección asignada.
  printf(1,"*index = %d  \n" , *index );
  15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  18:	8a 00                	mov    (%eax),%al
  1a:	0f be c0             	movsbl %al,%eax
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	c7 44 24 04 e9 09 00 	movl   $0x9e9,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 ef 05 00 00       	call   624 <printf>
  printf(1,"&index= %d  \n" , &index );
  35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 f8 09 00 	movl   $0x9f8,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 d4 05 00 00       	call   624 <printf>
  printf(1,"keyIndex= %d  \n" , keyIndex ); // primer indice del arreglo
  50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	c7 44 24 04 06 0a 00 	movl   $0xa06,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 b9 05 00 00       	call   624 <printf>

  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  75:	89 04 24             	mov    %eax,(%esp)
  78:	e8 c7 04 00 00       	call   544 <shm_get>
  7d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  printf(1,"return shm_get %d  \n" , a);  
  80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  83:	89 44 24 08          	mov    %eax,0x8(%esp)
  87:	c7 44 24 04 16 0a 00 	movl   $0xa16,0x4(%esp)
  8e:	00 
  8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  96:	e8 89 05 00 00       	call   624 <printf>
}
  9b:	c9                   	leave  
  9c:	c3                   	ret    

0000009d <test>:

void
test(){
  9d:	55                   	push   %ebp
  9e:	89 e5                	mov    %esp,%ebp
  a0:	83 ec 28             	sub    $0x28,%esp
  int pid, keyIndex;
  char* index = 0;
  a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  keyIndex = shm_create();
  aa:	e8 85 04 00 00       	call   534 <shm_create>
  af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"init index= %d  \n" , *index );
  b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  b5:	8a 00                	mov    (%eax),%al
  b7:	0f be c0             	movsbl %al,%eax
  ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  be:	c7 44 24 04 2b 0a 00 	movl   $0xa2b,0x4(%esp)
  c5:	00 
  c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cd:	e8 52 05 00 00       	call   624 <printf>
  printf(1,"init index= %d  \n" , &index );
  d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  d9:	c7 44 24 04 2b 0a 00 	movl   $0xa2b,0x4(%esp)
  e0:	00 
  e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e8:	e8 37 05 00 00       	call   624 <printf>
  shm_get(keyIndex, &index);
  ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  f7:	89 04 24             	mov    %eax,(%esp)
  fa:	e8 45 04 00 00       	call   544 <shm_get>
  pid = fork(); 
  ff:	e8 48 03 00 00       	call   44c <fork>
 104:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *index = 3;
 107:	8b 45 ec             	mov    -0x14(%ebp),%eax
 10a:	c6 00 03             	movb   $0x3,(%eax)
  printf(1,"father index= %d  \n" , &index );
 10d:	8d 45 ec             	lea    -0x14(%ebp),%eax
 110:	89 44 24 08          	mov    %eax,0x8(%esp)
 114:	c7 44 24 04 3d 0a 00 	movl   $0xa3d,0x4(%esp)
 11b:	00 
 11c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 123:	e8 fc 04 00 00       	call   624 <printf>
  printf(1,"father= %d  \n" , *index);
 128:	8b 45 ec             	mov    -0x14(%ebp),%eax
 12b:	8a 00                	mov    (%eax),%al
 12d:	0f be c0             	movsbl %al,%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	c7 44 24 04 51 0a 00 	movl   $0xa51,0x4(%esp)
 13b:	00 
 13c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 143:	e8 dc 04 00 00       	call   624 <printf>
  
  if(pid == 0 ){
 148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14c:	75 4b                	jne    199 <test+0xfc>
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
 14e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 151:	8a 00                	mov    (%eax),%al
 153:	0f be c0             	movsbl %al,%eax
 156:	89 44 24 08          	mov    %eax,0x8(%esp)
 15a:	c7 44 24 04 5f 0a 00 	movl   $0xa5f,0x4(%esp)
 161:	00 
 162:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 169:	e8 b6 04 00 00       	call   624 <printf>
    *index = 4;
 16e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 171:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
 174:	8b 45 ec             	mov    -0x14(%ebp),%eax
 177:	8a 00                	mov    (%eax),%al
 179:	0f be c0             	movsbl %al,%eax
 17c:	89 44 24 08          	mov    %eax,0x8(%esp)
 180:	c7 44 24 04 5f 0a 00 	movl   $0xa5f,0x4(%esp)
 187:	00 
 188:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18f:	e8 90 04 00 00       	call   624 <printf>
    //shm_close(keyIndex);
    exit();
 194:	e8 bb 02 00 00       	call   454 <exit>
  }
  printf(1,"exit index= %d  \n" , *(index) );
 199:	8b 45 ec             	mov    -0x14(%ebp),%eax
 19c:	8a 00                	mov    (%eax),%al
 19e:	0f be c0             	movsbl %al,%eax
 1a1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a5:	c7 44 24 04 72 0a 00 	movl   $0xa72,0x4(%esp)
 1ac:	00 
 1ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b4:	e8 6b 04 00 00       	call   624 <printf>
  wait();
 1b9:	e8 9e 02 00 00       	call   45c <wait>
  printf(1,"exit index= %d  \n" , &(index) );
 1be:	8d 45 ec             	lea    -0x14(%ebp),%eax
 1c1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1c5:	c7 44 24 04 72 0a 00 	movl   $0xa72,0x4(%esp)
 1cc:	00 
 1cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d4:	e8 4b 04 00 00       	call   624 <printf>
  printf(1,"exit index= %d  \n" , *(index) );
 1d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1dc:	8a 00                	mov    (%eax),%al
 1de:	0f be c0             	movsbl %al,%eax
 1e1:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e5:	c7 44 24 04 72 0a 00 	movl   $0xa72,0x4(%esp)
 1ec:	00 
 1ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f4:	e8 2b 04 00 00       	call   624 <printf>
  
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <main>:


int
main(int argc, char *argv[]) {
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 e4 f0             	and    $0xfffffff0,%esp

  test_0();
 201:	e8 fa fd ff ff       	call   0 <test_0>
  // printf(1,"exit index= %d  \n" , *(index) );
  // wait();
  // printf(1,"exit index_2= %d  \n" , *(index_2) );
  // printf(1,"exit index= %d  \n" , &(index) );
  // printf(1,"exit index= %d  \n" , *(index) );
  exit();
 206:	e8 49 02 00 00       	call   454 <exit>

0000020b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	57                   	push   %edi
 20f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 210:	8b 4d 08             	mov    0x8(%ebp),%ecx
 213:	8b 55 10             	mov    0x10(%ebp),%edx
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	89 cb                	mov    %ecx,%ebx
 21b:	89 df                	mov    %ebx,%edi
 21d:	89 d1                	mov    %edx,%ecx
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
 222:	89 ca                	mov    %ecx,%edx
 224:	89 fb                	mov    %edi,%ebx
 226:	89 5d 08             	mov    %ebx,0x8(%ebp)
 229:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 22c:	5b                   	pop    %ebx
 22d:	5f                   	pop    %edi
 22e:	5d                   	pop    %ebp
 22f:	c3                   	ret    

00000230 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 23c:	90                   	nop
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	8a 10                	mov    (%eax),%dl
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	88 10                	mov    %dl,(%eax)
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8a 00                	mov    (%eax),%al
 24c:	84 c0                	test   %al,%al
 24e:	0f 95 c0             	setne  %al
 251:	ff 45 08             	incl   0x8(%ebp)
 254:	ff 45 0c             	incl   0xc(%ebp)
 257:	84 c0                	test   %al,%al
 259:	75 e2                	jne    23d <strcpy+0xd>
    ;
  return os;
 25b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 25e:	c9                   	leave  
 25f:	c3                   	ret    

00000260 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 263:	eb 06                	jmp    26b <strcmp+0xb>
    p++, q++;
 265:	ff 45 08             	incl   0x8(%ebp)
 268:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	8a 00                	mov    (%eax),%al
 270:	84 c0                	test   %al,%al
 272:	74 0e                	je     282 <strcmp+0x22>
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8a 10                	mov    (%eax),%dl
 279:	8b 45 0c             	mov    0xc(%ebp),%eax
 27c:	8a 00                	mov    (%eax),%al
 27e:	38 c2                	cmp    %al,%dl
 280:	74 e3                	je     265 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8a 00                	mov    (%eax),%al
 287:	0f b6 d0             	movzbl %al,%edx
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	8a 00                	mov    (%eax),%al
 28f:	0f b6 c0             	movzbl %al,%eax
 292:	89 d1                	mov    %edx,%ecx
 294:	29 c1                	sub    %eax,%ecx
 296:	89 c8                	mov    %ecx,%eax
}
 298:	5d                   	pop    %ebp
 299:	c3                   	ret    

0000029a <strlen>:

uint
strlen(char *s)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2a7:	eb 03                	jmp    2ac <strlen+0x12>
 2a9:	ff 45 fc             	incl   -0x4(%ebp)
 2ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	8a 00                	mov    (%eax),%al
 2b6:	84 c0                	test   %al,%al
 2b8:	75 ef                	jne    2a9 <strlen+0xf>
    ;
  return n;
 2ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2bd:	c9                   	leave  
 2be:	c3                   	ret    

000002bf <memset>:

void*
memset(void *dst, int c, uint n)
{
 2bf:	55                   	push   %ebp
 2c0:	89 e5                	mov    %esp,%ebp
 2c2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2c5:	8b 45 10             	mov    0x10(%ebp),%eax
 2c8:	89 44 24 08          	mov    %eax,0x8(%esp)
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	89 04 24             	mov    %eax,(%esp)
 2d9:	e8 2d ff ff ff       	call   20b <stosb>
  return dst;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e1:	c9                   	leave  
 2e2:	c3                   	ret    

000002e3 <strchr>:

char*
strchr(const char *s, char c)
{
 2e3:	55                   	push   %ebp
 2e4:	89 e5                	mov    %esp,%ebp
 2e6:	83 ec 04             	sub    $0x4,%esp
 2e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ef:	eb 12                	jmp    303 <strchr+0x20>
    if(*s == c)
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8a 00                	mov    (%eax),%al
 2f6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2f9:	75 05                	jne    300 <strchr+0x1d>
      return (char*)s;
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	eb 11                	jmp    311 <strchr+0x2e>
  for(; *s; s++)
 300:	ff 45 08             	incl   0x8(%ebp)
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	8a 00                	mov    (%eax),%al
 308:	84 c0                	test   %al,%al
 30a:	75 e5                	jne    2f1 <strchr+0xe>
  return 0;
 30c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 311:	c9                   	leave  
 312:	c3                   	ret    

00000313 <gets>:

char*
gets(char *buf, int max)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 319:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 320:	eb 42                	jmp    364 <gets+0x51>
    cc = read(0, &c, 1);
 322:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 329:	00 
 32a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 32d:	89 44 24 04          	mov    %eax,0x4(%esp)
 331:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 338:	e8 2f 01 00 00       	call   46c <read>
 33d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 340:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 344:	7e 29                	jle    36f <gets+0x5c>
      break;
    buf[i++] = c;
 346:	8b 55 f4             	mov    -0xc(%ebp),%edx
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	01 c2                	add    %eax,%edx
 34e:	8a 45 ef             	mov    -0x11(%ebp),%al
 351:	88 02                	mov    %al,(%edx)
 353:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 356:	8a 45 ef             	mov    -0x11(%ebp),%al
 359:	3c 0a                	cmp    $0xa,%al
 35b:	74 13                	je     370 <gets+0x5d>
 35d:	8a 45 ef             	mov    -0x11(%ebp),%al
 360:	3c 0d                	cmp    $0xd,%al
 362:	74 0c                	je     370 <gets+0x5d>
  for(i=0; i+1 < max; ){
 364:	8b 45 f4             	mov    -0xc(%ebp),%eax
 367:	40                   	inc    %eax
 368:	3b 45 0c             	cmp    0xc(%ebp),%eax
 36b:	7c b5                	jl     322 <gets+0xf>
 36d:	eb 01                	jmp    370 <gets+0x5d>
      break;
 36f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 370:	8b 55 f4             	mov    -0xc(%ebp),%edx
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	01 d0                	add    %edx,%eax
 378:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <stat>:

int
stat(char *n, struct stat *st)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 386:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 38d:	00 
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	89 04 24             	mov    %eax,(%esp)
 394:	e8 fb 00 00 00       	call   494 <open>
 399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 39c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3a0:	79 07                	jns    3a9 <stat+0x29>
    return -1;
 3a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a7:	eb 23                	jmp    3cc <stat+0x4c>
  r = fstat(fd, st);
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b3:	89 04 24             	mov    %eax,(%esp)
 3b6:	e8 f1 00 00 00       	call   4ac <fstat>
 3bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3c1:	89 04 24             	mov    %eax,(%esp)
 3c4:	e8 b3 00 00 00       	call   47c <close>
  return r;
 3c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <atoi>:

int
atoi(const char *s)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
 3d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3db:	eb 21                	jmp    3fe <atoi+0x30>
    n = n*10 + *s++ - '0';
 3dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e0:	89 d0                	mov    %edx,%eax
 3e2:	c1 e0 02             	shl    $0x2,%eax
 3e5:	01 d0                	add    %edx,%eax
 3e7:	d1 e0                	shl    %eax
 3e9:	89 c2                	mov    %eax,%edx
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ee:	8a 00                	mov    (%eax),%al
 3f0:	0f be c0             	movsbl %al,%eax
 3f3:	01 d0                	add    %edx,%eax
 3f5:	83 e8 30             	sub    $0x30,%eax
 3f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 3fb:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3fe:	8b 45 08             	mov    0x8(%ebp),%eax
 401:	8a 00                	mov    (%eax),%al
 403:	3c 2f                	cmp    $0x2f,%al
 405:	7e 09                	jle    410 <atoi+0x42>
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	8a 00                	mov    (%eax),%al
 40c:	3c 39                	cmp    $0x39,%al
 40e:	7e cd                	jle    3dd <atoi+0xf>
  return n;
 410:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 413:	c9                   	leave  
 414:	c3                   	ret    

00000415 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 421:	8b 45 0c             	mov    0xc(%ebp),%eax
 424:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 427:	eb 10                	jmp    439 <memmove+0x24>
    *dst++ = *src++;
 429:	8b 45 f8             	mov    -0x8(%ebp),%eax
 42c:	8a 10                	mov    (%eax),%dl
 42e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 431:	88 10                	mov    %dl,(%eax)
 433:	ff 45 fc             	incl   -0x4(%ebp)
 436:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 439:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 43d:	0f 9f c0             	setg   %al
 440:	ff 4d 10             	decl   0x10(%ebp)
 443:	84 c0                	test   %al,%al
 445:	75 e2                	jne    429 <memmove+0x14>
  return vdst;
 447:	8b 45 08             	mov    0x8(%ebp),%eax
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <fork>:
 44c:	b8 01 00 00 00       	mov    $0x1,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <exit>:
 454:	b8 02 00 00 00       	mov    $0x2,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <wait>:
 45c:	b8 03 00 00 00       	mov    $0x3,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <pipe>:
 464:	b8 04 00 00 00       	mov    $0x4,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <read>:
 46c:	b8 05 00 00 00       	mov    $0x5,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <write>:
 474:	b8 10 00 00 00       	mov    $0x10,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <close>:
 47c:	b8 15 00 00 00       	mov    $0x15,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <kill>:
 484:	b8 06 00 00 00       	mov    $0x6,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <exec>:
 48c:	b8 07 00 00 00       	mov    $0x7,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <open>:
 494:	b8 0f 00 00 00       	mov    $0xf,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <mknod>:
 49c:	b8 11 00 00 00       	mov    $0x11,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <unlink>:
 4a4:	b8 12 00 00 00       	mov    $0x12,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <fstat>:
 4ac:	b8 08 00 00 00       	mov    $0x8,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <link>:
 4b4:	b8 13 00 00 00       	mov    $0x13,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <mkdir>:
 4bc:	b8 14 00 00 00       	mov    $0x14,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <chdir>:
 4c4:	b8 09 00 00 00       	mov    $0x9,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <dup>:
 4cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <getpid>:
 4d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <sbrk>:
 4dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <sleep>:
 4e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <uptime>:
 4ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <lseek>:
 4f4:	b8 16 00 00 00       	mov    $0x16,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <isatty>:
 4fc:	b8 17 00 00 00       	mov    $0x17,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <procstat>:
 504:	b8 18 00 00 00       	mov    $0x18,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <set_priority>:
 50c:	b8 19 00 00 00       	mov    $0x19,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <semget>:
 514:	b8 1a 00 00 00       	mov    $0x1a,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <semfree>:
 51c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <semdown>:
 524:	b8 1c 00 00 00       	mov    $0x1c,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <semup>:
 52c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <shm_create>:
 534:	b8 1e 00 00 00       	mov    $0x1e,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <shm_close>:
 53c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <shm_get>:
 544:	b8 20 00 00 00       	mov    $0x20,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 54c:	55                   	push   %ebp
 54d:	89 e5                	mov    %esp,%ebp
 54f:	83 ec 28             	sub    $0x28,%esp
 552:	8b 45 0c             	mov    0xc(%ebp),%eax
 555:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 558:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 55f:	00 
 560:	8d 45 f4             	lea    -0xc(%ebp),%eax
 563:	89 44 24 04          	mov    %eax,0x4(%esp)
 567:	8b 45 08             	mov    0x8(%ebp),%eax
 56a:	89 04 24             	mov    %eax,(%esp)
 56d:	e8 02 ff ff ff       	call   474 <write>
}
 572:	c9                   	leave  
 573:	c3                   	ret    

00000574 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 57a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 581:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 585:	74 17                	je     59e <printint+0x2a>
 587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 58b:	79 11                	jns    59e <printint+0x2a>
    neg = 1;
 58d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	f7 d8                	neg    %eax
 599:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59c:	eb 06                	jmp    5a4 <printint+0x30>
  } else {
    x = xx;
 59e:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b1:	ba 00 00 00 00       	mov    $0x0,%edx
 5b6:	f7 f1                	div    %ecx
 5b8:	89 d0                	mov    %edx,%eax
 5ba:	8a 80 08 0d 00 00    	mov    0xd08(%eax),%al
 5c0:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 5c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5c6:	01 ca                	add    %ecx,%edx
 5c8:	88 02                	mov    %al,(%edx)
 5ca:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 5cd:	8b 55 10             	mov    0x10(%ebp),%edx
 5d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d6:	ba 00 00 00 00       	mov    $0x0,%edx
 5db:	f7 75 d4             	divl   -0x2c(%ebp)
 5de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e5:	75 c4                	jne    5ab <printint+0x37>
  if(neg)
 5e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5eb:	74 2c                	je     619 <printint+0xa5>
    buf[i++] = '-';
 5ed:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f3:	01 d0                	add    %edx,%eax
 5f5:	c6 00 2d             	movb   $0x2d,(%eax)
 5f8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 5fb:	eb 1c                	jmp    619 <printint+0xa5>
    putc(fd, buf[i]);
 5fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 600:	8b 45 f4             	mov    -0xc(%ebp),%eax
 603:	01 d0                	add    %edx,%eax
 605:	8a 00                	mov    (%eax),%al
 607:	0f be c0             	movsbl %al,%eax
 60a:	89 44 24 04          	mov    %eax,0x4(%esp)
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	89 04 24             	mov    %eax,(%esp)
 614:	e8 33 ff ff ff       	call   54c <putc>
  while(--i >= 0)
 619:	ff 4d f4             	decl   -0xc(%ebp)
 61c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 620:	79 db                	jns    5fd <printint+0x89>
}
 622:	c9                   	leave  
 623:	c3                   	ret    

00000624 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 62a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 631:	8d 45 0c             	lea    0xc(%ebp),%eax
 634:	83 c0 04             	add    $0x4,%eax
 637:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 63a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 641:	e9 78 01 00 00       	jmp    7be <printf+0x19a>
    c = fmt[i] & 0xff;
 646:	8b 55 0c             	mov    0xc(%ebp),%edx
 649:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64c:	01 d0                	add    %edx,%eax
 64e:	8a 00                	mov    (%eax),%al
 650:	0f be c0             	movsbl %al,%eax
 653:	25 ff 00 00 00       	and    $0xff,%eax
 658:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 65b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 65f:	75 2c                	jne    68d <printf+0x69>
      if(c == '%'){
 661:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 665:	75 0c                	jne    673 <printf+0x4f>
        state = '%';
 667:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 66e:	e9 48 01 00 00       	jmp    7bb <printf+0x197>
      } else {
        putc(fd, c);
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	0f be c0             	movsbl %al,%eax
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 c4 fe ff ff       	call   54c <putc>
 688:	e9 2e 01 00 00       	jmp    7bb <printf+0x197>
      }
    } else if(state == '%'){
 68d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 691:	0f 85 24 01 00 00    	jne    7bb <printf+0x197>
      if(c == 'd'){
 697:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 69b:	75 2d                	jne    6ca <printf+0xa6>
        printint(fd, *ap, 10, 1);
 69d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6a9:	00 
 6aa:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6b1:	00 
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	89 04 24             	mov    %eax,(%esp)
 6bc:	e8 b3 fe ff ff       	call   574 <printint>
        ap++;
 6c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c5:	e9 ea 00 00 00       	jmp    7b4 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 6ca:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ce:	74 06                	je     6d6 <printf+0xb2>
 6d0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6d4:	75 2d                	jne    703 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 6d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6e2:	00 
 6e3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6ea:	00 
 6eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	89 04 24             	mov    %eax,(%esp)
 6f5:	e8 7a fe ff ff       	call   574 <printint>
        ap++;
 6fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fe:	e9 b1 00 00 00       	jmp    7b4 <printf+0x190>
      } else if(c == 's'){
 703:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 707:	75 43                	jne    74c <printf+0x128>
        s = (char*)*ap;
 709:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 711:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 719:	75 25                	jne    740 <printf+0x11c>
          s = "(null)";
 71b:	c7 45 f4 84 0a 00 00 	movl   $0xa84,-0xc(%ebp)
        while(*s != 0){
 722:	eb 1c                	jmp    740 <printf+0x11c>
          putc(fd, *s);
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	8a 00                	mov    (%eax),%al
 729:	0f be c0             	movsbl %al,%eax
 72c:	89 44 24 04          	mov    %eax,0x4(%esp)
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	89 04 24             	mov    %eax,(%esp)
 736:	e8 11 fe ff ff       	call   54c <putc>
          s++;
 73b:	ff 45 f4             	incl   -0xc(%ebp)
 73e:	eb 01                	jmp    741 <printf+0x11d>
        while(*s != 0){
 740:	90                   	nop
 741:	8b 45 f4             	mov    -0xc(%ebp),%eax
 744:	8a 00                	mov    (%eax),%al
 746:	84 c0                	test   %al,%al
 748:	75 da                	jne    724 <printf+0x100>
 74a:	eb 68                	jmp    7b4 <printf+0x190>
        }
      } else if(c == 'c'){
 74c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 750:	75 1d                	jne    76f <printf+0x14b>
        putc(fd, *ap);
 752:	8b 45 e8             	mov    -0x18(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	0f be c0             	movsbl %al,%eax
 75a:	89 44 24 04          	mov    %eax,0x4(%esp)
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	89 04 24             	mov    %eax,(%esp)
 764:	e8 e3 fd ff ff       	call   54c <putc>
        ap++;
 769:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76d:	eb 45                	jmp    7b4 <printf+0x190>
      } else if(c == '%'){
 76f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 773:	75 17                	jne    78c <printf+0x168>
        putc(fd, c);
 775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 778:	0f be c0             	movsbl %al,%eax
 77b:	89 44 24 04          	mov    %eax,0x4(%esp)
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	89 04 24             	mov    %eax,(%esp)
 785:	e8 c2 fd ff ff       	call   54c <putc>
 78a:	eb 28                	jmp    7b4 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 793:	00 
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	89 04 24             	mov    %eax,(%esp)
 79a:	e8 ad fd ff ff       	call   54c <putc>
        putc(fd, c);
 79f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a2:	0f be c0             	movsbl %al,%eax
 7a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 98 fd ff ff       	call   54c <putc>
      }
      state = 0;
 7b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7bb:	ff 45 f0             	incl   -0x10(%ebp)
 7be:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	01 d0                	add    %edx,%eax
 7c6:	8a 00                	mov    (%eax),%al
 7c8:	84 c0                	test   %al,%al
 7ca:	0f 85 76 fe ff ff    	jne    646 <printf+0x22>
    }
  }
}
 7d0:	c9                   	leave  
 7d1:	c3                   	ret    

000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	83 e8 08             	sub    $0x8,%eax
 7de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 24 0d 00 00       	mov    0xd24,%eax
 7e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e9:	eb 24                	jmp    80f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f3:	77 12                	ja     807 <free+0x35>
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fb:	77 24                	ja     821 <free+0x4f>
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 805:	77 1a                	ja     821 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 815:	76 d4                	jbe    7eb <free+0x19>
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81f:	76 ca                	jbe    7eb <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 821:	8b 45 f8             	mov    -0x8(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	01 c2                	add    %eax,%edx
 833:	8b 45 fc             	mov    -0x4(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	39 c2                	cmp    %eax,%edx
 83a:	75 24                	jne    860 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	8b 50 04             	mov    0x4(%eax),%edx
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	8b 00                	mov    (%eax),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	01 c2                	add    %eax,%edx
 84c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	8b 45 fc             	mov    -0x4(%ebp),%eax
 855:	8b 00                	mov    (%eax),%eax
 857:	8b 10                	mov    (%eax),%edx
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	89 10                	mov    %edx,(%eax)
 85e:	eb 0a                	jmp    86a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	8b 10                	mov    (%eax),%edx
 865:	8b 45 f8             	mov    -0x8(%ebp),%eax
 868:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	8b 40 04             	mov    0x4(%eax),%eax
 870:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	01 d0                	add    %edx,%eax
 87c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87f:	75 20                	jne    8a1 <free+0xcf>
    p->s.size += bp->s.size;
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 50 04             	mov    0x4(%eax),%edx
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	8b 40 04             	mov    0x4(%eax),%eax
 88d:	01 c2                	add    %eax,%edx
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 895:	8b 45 f8             	mov    -0x8(%ebp),%eax
 898:	8b 10                	mov    (%eax),%edx
 89a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89d:	89 10                	mov    %edx,(%eax)
 89f:	eb 08                	jmp    8a9 <free+0xd7>
  } else
    p->s.ptr = bp;
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8a7:	89 10                	mov    %edx,(%eax)
  freep = p;
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	a3 24 0d 00 00       	mov    %eax,0xd24
}
 8b1:	c9                   	leave  
 8b2:	c3                   	ret    

000008b3 <morecore>:

static Header*
morecore(uint nu)
{
 8b3:	55                   	push   %ebp
 8b4:	89 e5                	mov    %esp,%ebp
 8b6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8b9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8c0:	77 07                	ja     8c9 <morecore+0x16>
    nu = 4096;
 8c2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8c9:	8b 45 08             	mov    0x8(%ebp),%eax
 8cc:	c1 e0 03             	shl    $0x3,%eax
 8cf:	89 04 24             	mov    %eax,(%esp)
 8d2:	e8 05 fc ff ff       	call   4dc <sbrk>
 8d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8de:	75 07                	jne    8e7 <morecore+0x34>
    return 0;
 8e0:	b8 00 00 00 00       	mov    $0x0,%eax
 8e5:	eb 22                	jmp    909 <morecore+0x56>
  hp = (Header*)p;
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f0:	8b 55 08             	mov    0x8(%ebp),%edx
 8f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f9:	83 c0 08             	add    $0x8,%eax
 8fc:	89 04 24             	mov    %eax,(%esp)
 8ff:	e8 ce fe ff ff       	call   7d2 <free>
  return freep;
 904:	a1 24 0d 00 00       	mov    0xd24,%eax
}
 909:	c9                   	leave  
 90a:	c3                   	ret    

0000090b <malloc>:

void*
malloc(uint nbytes)
{
 90b:	55                   	push   %ebp
 90c:	89 e5                	mov    %esp,%ebp
 90e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 911:	8b 45 08             	mov    0x8(%ebp),%eax
 914:	83 c0 07             	add    $0x7,%eax
 917:	c1 e8 03             	shr    $0x3,%eax
 91a:	40                   	inc    %eax
 91b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 91e:	a1 24 0d 00 00       	mov    0xd24,%eax
 923:	89 45 f0             	mov    %eax,-0x10(%ebp)
 926:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 92a:	75 23                	jne    94f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 92c:	c7 45 f0 1c 0d 00 00 	movl   $0xd1c,-0x10(%ebp)
 933:	8b 45 f0             	mov    -0x10(%ebp),%eax
 936:	a3 24 0d 00 00       	mov    %eax,0xd24
 93b:	a1 24 0d 00 00       	mov    0xd24,%eax
 940:	a3 1c 0d 00 00       	mov    %eax,0xd1c
    base.s.size = 0;
 945:	c7 05 20 0d 00 00 00 	movl   $0x0,0xd20
 94c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 94f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 952:	8b 00                	mov    (%eax),%eax
 954:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 960:	72 4d                	jb     9af <malloc+0xa4>
      if(p->s.size == nunits)
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 96b:	75 0c                	jne    979 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 10                	mov    (%eax),%edx
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	89 10                	mov    %edx,(%eax)
 977:	eb 26                	jmp    99f <malloc+0x94>
      else {
        p->s.size -= nunits;
 979:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97c:	8b 40 04             	mov    0x4(%eax),%eax
 97f:	89 c2                	mov    %eax,%edx
 981:	2b 55 ec             	sub    -0x14(%ebp),%edx
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	c1 e0 03             	shl    $0x3,%eax
 993:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 996:	8b 45 f4             	mov    -0xc(%ebp),%eax
 999:	8b 55 ec             	mov    -0x14(%ebp),%edx
 99c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	a3 24 0d 00 00       	mov    %eax,0xd24
      return (void*)(p + 1);
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	83 c0 08             	add    $0x8,%eax
 9ad:	eb 38                	jmp    9e7 <malloc+0xdc>
    }
    if(p == freep)
 9af:	a1 24 0d 00 00       	mov    0xd24,%eax
 9b4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9b7:	75 1b                	jne    9d4 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 9b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9bc:	89 04 24             	mov    %eax,(%esp)
 9bf:	e8 ef fe ff ff       	call   8b3 <morecore>
 9c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9cb:	75 07                	jne    9d4 <malloc+0xc9>
        return 0;
 9cd:	b8 00 00 00 00       	mov    $0x0,%eax
 9d2:	eb 13                	jmp    9e7 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	8b 00                	mov    (%eax),%eax
 9df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 9e2:	e9 70 ff ff ff       	jmp    957 <malloc+0x4c>
}
 9e7:	c9                   	leave  
 9e8:	c3                   	ret    
