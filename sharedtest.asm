
_sharedtest:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test>:
#include "stat.h"
#include "user.h"
#include "fcntl.h"

void
test(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int pid, keyIndex;
  char* index = 0;
   6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  keyIndex = shm_create();
   d:	e8 84 06 00 00       	call   696 <shm_create>
  12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"init index= %d  \n" , *index );
  15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  18:	8a 00                	mov    (%eax),%al
  1a:	0f be c0             	movsbl %al,%eax
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	c7 44 24 04 4b 0b 00 	movl   $0xb4b,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 51 07 00 00       	call   786 <printf>
  printf(1,"init index= %d  \n" , &index );
  35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 4b 0b 00 	movl   $0xb4b,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 36 07 00 00       	call   786 <printf>
  shm_get(keyIndex, &index);
  50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  53:	89 44 24 04          	mov    %eax,0x4(%esp)
  57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5a:	89 04 24             	mov    %eax,(%esp)
  5d:	e8 44 06 00 00       	call   6a6 <shm_get>
  pid = fork(); 
  62:	e8 47 05 00 00       	call   5ae <fork>
  67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *index = 3;
  6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  6d:	c6 00 03             	movb   $0x3,(%eax)
  printf(1,"father index= %d  \n" , &index );
  70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  73:	89 44 24 08          	mov    %eax,0x8(%esp)
  77:	c7 44 24 04 5d 0b 00 	movl   $0xb5d,0x4(%esp)
  7e:	00 
  7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  86:	e8 fb 06 00 00       	call   786 <printf>
  printf(1,"father= %d  \n" , *index);
  8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8e:	8a 00                	mov    (%eax),%al
  90:	0f be c0             	movsbl %al,%eax
  93:	89 44 24 08          	mov    %eax,0x8(%esp)
  97:	c7 44 24 04 71 0b 00 	movl   $0xb71,0x4(%esp)
  9e:	00 
  9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a6:	e8 db 06 00 00       	call   786 <printf>
  
  if(pid == 0 ){
  ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  af:	75 4b                	jne    fc <test+0xfc>
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
  b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  b4:	8a 00                	mov    (%eax),%al
  b6:	0f be c0             	movsbl %al,%eax
  b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  bd:	c7 44 24 04 7f 0b 00 	movl   $0xb7f,0x4(%esp)
  c4:	00 
  c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  cc:	e8 b5 06 00 00       	call   786 <printf>
    *index = 4;
  d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  d4:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
  d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  da:	8a 00                	mov    (%eax),%al
  dc:	0f be c0             	movsbl %al,%eax
  df:	89 44 24 08          	mov    %eax,0x8(%esp)
  e3:	c7 44 24 04 7f 0b 00 	movl   $0xb7f,0x4(%esp)
  ea:	00 
  eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f2:	e8 8f 06 00 00       	call   786 <printf>
    //shm_close(keyIndex);
    exit();
  f7:	e8 ba 04 00 00       	call   5b6 <exit>
  }
  printf(1,"exit index= %d  \n" , *(index) );
  fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  ff:	8a 00                	mov    (%eax),%al
 101:	0f be c0             	movsbl %al,%eax
 104:	89 44 24 08          	mov    %eax,0x8(%esp)
 108:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 10f:	00 
 110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 117:	e8 6a 06 00 00       	call   786 <printf>
  wait();
 11c:	e8 9d 04 00 00       	call   5be <wait>
  printf(1,"exit index= %d  \n" , &(index) );
 121:	8d 45 ec             	lea    -0x14(%ebp),%eax
 124:	89 44 24 08          	mov    %eax,0x8(%esp)
 128:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 12f:	00 
 130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 137:	e8 4a 06 00 00       	call   786 <printf>
  printf(1,"exit index= %d  \n" , *(index) );
 13c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 13f:	8a 00                	mov    (%eax),%al
 141:	0f be c0             	movsbl %al,%eax
 144:	89 44 24 08          	mov    %eax,0x8(%esp)
 148:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 14f:	00 
 150:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 157:	e8 2a 06 00 00       	call   786 <printf>
  
}
 15c:	c9                   	leave  
 15d:	c3                   	ret    

0000015e <main>:


int
main(int argc, char *argv[]) {
 15e:	55                   	push   %ebp
 15f:	89 e5                	mov    %esp,%ebp
 161:	83 e4 f0             	and    $0xfffffff0,%esp
 164:	83 ec 30             	sub    $0x30,%esp
  int pid, keyIndex, keyIndex_2;
  char* index = 0;
 167:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
 16e:	00 
  char* index_2 = 0;
 16f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 176:	00 
  keyIndex = shm_create();
 177:	e8 1a 05 00 00       	call   696 <shm_create>
 17c:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  keyIndex_2 = shm_create();
 180:	e8 11 05 00 00       	call   696 <shm_create>
 185:	89 44 24 28          	mov    %eax,0x28(%esp)
  printf(1,"init index= %d  \n" , *index );
 189:	8b 44 24 20          	mov    0x20(%esp),%eax
 18d:	8a 00                	mov    (%eax),%al
 18f:	0f be c0             	movsbl %al,%eax
 192:	89 44 24 08          	mov    %eax,0x8(%esp)
 196:	c7 44 24 04 4b 0b 00 	movl   $0xb4b,0x4(%esp)
 19d:	00 
 19e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a5:	e8 dc 05 00 00       	call   786 <printf>
  printf(1,"init index= %d  \n" , &index );
 1aa:	8d 44 24 20          	lea    0x20(%esp),%eax
 1ae:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b2:	c7 44 24 04 4b 0b 00 	movl   $0xb4b,0x4(%esp)
 1b9:	00 
 1ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c1:	e8 c0 05 00 00       	call   786 <printf>
  shm_get(keyIndex, &index);
 1c6:	8d 44 24 20          	lea    0x20(%esp),%eax
 1ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ce:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 1d2:	89 04 24             	mov    %eax,(%esp)
 1d5:	e8 cc 04 00 00       	call   6a6 <shm_get>
  shm_get(keyIndex_2, &index_2);
 1da:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 1de:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e2:	8b 44 24 28          	mov    0x28(%esp),%eax
 1e6:	89 04 24             	mov    %eax,(%esp)
 1e9:	e8 b8 04 00 00       	call   6a6 <shm_get>
  pid = fork(); 
 1ee:	e8 bb 03 00 00       	call   5ae <fork>
 1f3:	89 44 24 24          	mov    %eax,0x24(%esp)
  *index = 3;
 1f7:	8b 44 24 20          	mov    0x20(%esp),%eax
 1fb:	c6 00 03             	movb   $0x3,(%eax)
  printf(1,"father index= %d  \n" , &index );
 1fe:	8d 44 24 20          	lea    0x20(%esp),%eax
 202:	89 44 24 08          	mov    %eax,0x8(%esp)
 206:	c7 44 24 04 5d 0b 00 	movl   $0xb5d,0x4(%esp)
 20d:	00 
 20e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 215:	e8 6c 05 00 00       	call   786 <printf>
  printf(1,"father= %d  \n" , *index);
 21a:	8b 44 24 20          	mov    0x20(%esp),%eax
 21e:	8a 00                	mov    (%eax),%al
 220:	0f be c0             	movsbl %al,%eax
 223:	89 44 24 08          	mov    %eax,0x8(%esp)
 227:	c7 44 24 04 71 0b 00 	movl   $0xb71,0x4(%esp)
 22e:	00 
 22f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 236:	e8 4b 05 00 00       	call   786 <printf>
  
  if(pid == 0 ){
 23b:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 240:	0f 85 9e 00 00 00    	jne    2e4 <main+0x186>
    shm_get(keyIndex, &index);
 246:	8d 44 24 20          	lea    0x20(%esp),%eax
 24a:	89 44 24 04          	mov    %eax,0x4(%esp)
 24e:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 252:	89 04 24             	mov    %eax,(%esp)
 255:	e8 4c 04 00 00       	call   6a6 <shm_get>
    shm_get(keyIndex_2, &index_2);
 25a:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 25e:	89 44 24 04          	mov    %eax,0x4(%esp)
 262:	8b 44 24 28          	mov    0x28(%esp),%eax
 266:	89 04 24             	mov    %eax,(%esp)
 269:	e8 38 04 00 00       	call   6a6 <shm_get>
    printf(1,"child index= %d  \n" , *(index) );
 26e:	8b 44 24 20          	mov    0x20(%esp),%eax
 272:	8a 00                	mov    (%eax),%al
 274:	0f be c0             	movsbl %al,%eax
 277:	89 44 24 08          	mov    %eax,0x8(%esp)
 27b:	c7 44 24 04 7f 0b 00 	movl   $0xb7f,0x4(%esp)
 282:	00 
 283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 28a:	e8 f7 04 00 00       	call   786 <printf>
    *index = 4;
 28f:	8b 44 24 20          	mov    0x20(%esp),%eax
 293:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
 296:	8b 44 24 20          	mov    0x20(%esp),%eax
 29a:	8a 00                	mov    (%eax),%al
 29c:	0f be c0             	movsbl %al,%eax
 29f:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a3:	c7 44 24 04 7f 0b 00 	movl   $0xb7f,0x4(%esp)
 2aa:	00 
 2ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b2:	e8 cf 04 00 00       	call   786 <printf>
    *index_2 = 5;
 2b7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 2bb:	c6 00 05             	movb   $0x5,(%eax)
    printf(1,"child index_2= %d  \n" , *(index_2) );
 2be:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 2c2:	8a 00                	mov    (%eax),%al
 2c4:	0f be c0             	movsbl %al,%eax
 2c7:	89 44 24 08          	mov    %eax,0x8(%esp)
 2cb:	c7 44 24 04 a4 0b 00 	movl   $0xba4,0x4(%esp)
 2d2:	00 
 2d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2da:	e8 a7 04 00 00       	call   786 <printf>
    exit();
 2df:	e8 d2 02 00 00       	call   5b6 <exit>
  }
  printf(1,"exit index= %d  \n" , *(index) );
 2e4:	8b 44 24 20          	mov    0x20(%esp),%eax
 2e8:	8a 00                	mov    (%eax),%al
 2ea:	0f be c0             	movsbl %al,%eax
 2ed:	89 44 24 08          	mov    %eax,0x8(%esp)
 2f1:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 2f8:	00 
 2f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 300:	e8 81 04 00 00       	call   786 <printf>
  wait();
 305:	e8 b4 02 00 00       	call   5be <wait>
  printf(1,"exit index_2= %d  \n" , *(index_2) );
 30a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 30e:	8a 00                	mov    (%eax),%al
 310:	0f be c0             	movsbl %al,%eax
 313:	89 44 24 08          	mov    %eax,0x8(%esp)
 317:	c7 44 24 04 b9 0b 00 	movl   $0xbb9,0x4(%esp)
 31e:	00 
 31f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 326:	e8 5b 04 00 00       	call   786 <printf>
  printf(1,"exit index= %d  \n" , &(index) );
 32b:	8d 44 24 20          	lea    0x20(%esp),%eax
 32f:	89 44 24 08          	mov    %eax,0x8(%esp)
 333:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 33a:	00 
 33b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 342:	e8 3f 04 00 00       	call   786 <printf>
  printf(1,"exit index= %d  \n" , *(index) );
 347:	8b 44 24 20          	mov    0x20(%esp),%eax
 34b:	8a 00                	mov    (%eax),%al
 34d:	0f be c0             	movsbl %al,%eax
 350:	89 44 24 08          	mov    %eax,0x8(%esp)
 354:	c7 44 24 04 92 0b 00 	movl   $0xb92,0x4(%esp)
 35b:	00 
 35c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 363:	e8 1e 04 00 00       	call   786 <printf>
  exit();
 368:	e8 49 02 00 00       	call   5b6 <exit>

0000036d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	57                   	push   %edi
 371:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 372:	8b 4d 08             	mov    0x8(%ebp),%ecx
 375:	8b 55 10             	mov    0x10(%ebp),%edx
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	89 cb                	mov    %ecx,%ebx
 37d:	89 df                	mov    %ebx,%edi
 37f:	89 d1                	mov    %edx,%ecx
 381:	fc                   	cld    
 382:	f3 aa                	rep stos %al,%es:(%edi)
 384:	89 ca                	mov    %ecx,%edx
 386:	89 fb                	mov    %edi,%ebx
 388:	89 5d 08             	mov    %ebx,0x8(%ebp)
 38b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 38e:	5b                   	pop    %ebx
 38f:	5f                   	pop    %edi
 390:	5d                   	pop    %ebp
 391:	c3                   	ret    

00000392 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 39e:	90                   	nop
 39f:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a2:	8a 10                	mov    (%eax),%dl
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	88 10                	mov    %dl,(%eax)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	8a 00                	mov    (%eax),%al
 3ae:	84 c0                	test   %al,%al
 3b0:	0f 95 c0             	setne  %al
 3b3:	ff 45 08             	incl   0x8(%ebp)
 3b6:	ff 45 0c             	incl   0xc(%ebp)
 3b9:	84 c0                	test   %al,%al
 3bb:	75 e2                	jne    39f <strcpy+0xd>
    ;
  return os;
 3bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    

000003c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3c5:	eb 06                	jmp    3cd <strcmp+0xb>
    p++, q++;
 3c7:	ff 45 08             	incl   0x8(%ebp)
 3ca:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	8a 00                	mov    (%eax),%al
 3d2:	84 c0                	test   %al,%al
 3d4:	74 0e                	je     3e4 <strcmp+0x22>
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	8a 10                	mov    (%eax),%dl
 3db:	8b 45 0c             	mov    0xc(%ebp),%eax
 3de:	8a 00                	mov    (%eax),%al
 3e0:	38 c2                	cmp    %al,%dl
 3e2:	74 e3                	je     3c7 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	8a 00                	mov    (%eax),%al
 3e9:	0f b6 d0             	movzbl %al,%edx
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	8a 00                	mov    (%eax),%al
 3f1:	0f b6 c0             	movzbl %al,%eax
 3f4:	89 d1                	mov    %edx,%ecx
 3f6:	29 c1                	sub    %eax,%ecx
 3f8:	89 c8                	mov    %ecx,%eax
}
 3fa:	5d                   	pop    %ebp
 3fb:	c3                   	ret    

000003fc <strlen>:

uint
strlen(char *s)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 409:	eb 03                	jmp    40e <strlen+0x12>
 40b:	ff 45 fc             	incl   -0x4(%ebp)
 40e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	8a 00                	mov    (%eax),%al
 418:	84 c0                	test   %al,%al
 41a:	75 ef                	jne    40b <strlen+0xf>
    ;
  return n;
 41c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <memset>:

void*
memset(void *dst, int c, uint n)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 427:	8b 45 10             	mov    0x10(%ebp),%eax
 42a:	89 44 24 08          	mov    %eax,0x8(%esp)
 42e:	8b 45 0c             	mov    0xc(%ebp),%eax
 431:	89 44 24 04          	mov    %eax,0x4(%esp)
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	89 04 24             	mov    %eax,(%esp)
 43b:	e8 2d ff ff ff       	call   36d <stosb>
  return dst;
 440:	8b 45 08             	mov    0x8(%ebp),%eax
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <strchr>:

char*
strchr(const char *s, char c)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 04             	sub    $0x4,%esp
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 451:	eb 12                	jmp    465 <strchr+0x20>
    if(*s == c)
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	8a 00                	mov    (%eax),%al
 458:	3a 45 fc             	cmp    -0x4(%ebp),%al
 45b:	75 05                	jne    462 <strchr+0x1d>
      return (char*)s;
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	eb 11                	jmp    473 <strchr+0x2e>
  for(; *s; s++)
 462:	ff 45 08             	incl   0x8(%ebp)
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	8a 00                	mov    (%eax),%al
 46a:	84 c0                	test   %al,%al
 46c:	75 e5                	jne    453 <strchr+0xe>
  return 0;
 46e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 473:	c9                   	leave  
 474:	c3                   	ret    

00000475 <gets>:

char*
gets(char *buf, int max)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 47b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 482:	eb 42                	jmp    4c6 <gets+0x51>
    cc = read(0, &c, 1);
 484:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48b:	00 
 48c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 48f:	89 44 24 04          	mov    %eax,0x4(%esp)
 493:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 49a:	e8 2f 01 00 00       	call   5ce <read>
 49f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 4a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a6:	7e 29                	jle    4d1 <gets+0x5c>
      break;
    buf[i++] = c;
 4a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ab:	8b 45 08             	mov    0x8(%ebp),%eax
 4ae:	01 c2                	add    %eax,%edx
 4b0:	8a 45 ef             	mov    -0x11(%ebp),%al
 4b3:	88 02                	mov    %al,(%edx)
 4b5:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 4b8:	8a 45 ef             	mov    -0x11(%ebp),%al
 4bb:	3c 0a                	cmp    $0xa,%al
 4bd:	74 13                	je     4d2 <gets+0x5d>
 4bf:	8a 45 ef             	mov    -0x11(%ebp),%al
 4c2:	3c 0d                	cmp    $0xd,%al
 4c4:	74 0c                	je     4d2 <gets+0x5d>
  for(i=0; i+1 < max; ){
 4c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c9:	40                   	inc    %eax
 4ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4cd:	7c b5                	jl     484 <gets+0xf>
 4cf:	eb 01                	jmp    4d2 <gets+0x5d>
      break;
 4d1:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d5:	8b 45 08             	mov    0x8(%ebp),%eax
 4d8:	01 d0                	add    %edx,%eax
 4da:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e0:	c9                   	leave  
 4e1:	c3                   	ret    

000004e2 <stat>:

int
stat(char *n, struct stat *st)
{
 4e2:	55                   	push   %ebp
 4e3:	89 e5                	mov    %esp,%ebp
 4e5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4ef:	00 
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	89 04 24             	mov    %eax,(%esp)
 4f6:	e8 fb 00 00 00       	call   5f6 <open>
 4fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 502:	79 07                	jns    50b <stat+0x29>
    return -1;
 504:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 509:	eb 23                	jmp    52e <stat+0x4c>
  r = fstat(fd, st);
 50b:	8b 45 0c             	mov    0xc(%ebp),%eax
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 f1 00 00 00       	call   60e <fstat>
 51d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	89 04 24             	mov    %eax,(%esp)
 526:	e8 b3 00 00 00       	call   5de <close>
  return r;
 52b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 52e:	c9                   	leave  
 52f:	c3                   	ret    

00000530 <atoi>:

int
atoi(const char *s)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 536:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53d:	eb 21                	jmp    560 <atoi+0x30>
    n = n*10 + *s++ - '0';
 53f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 542:	89 d0                	mov    %edx,%eax
 544:	c1 e0 02             	shl    $0x2,%eax
 547:	01 d0                	add    %edx,%eax
 549:	d1 e0                	shl    %eax
 54b:	89 c2                	mov    %eax,%edx
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	8a 00                	mov    (%eax),%al
 552:	0f be c0             	movsbl %al,%eax
 555:	01 d0                	add    %edx,%eax
 557:	83 e8 30             	sub    $0x30,%eax
 55a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 55d:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	8a 00                	mov    (%eax),%al
 565:	3c 2f                	cmp    $0x2f,%al
 567:	7e 09                	jle    572 <atoi+0x42>
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	8a 00                	mov    (%eax),%al
 56e:	3c 39                	cmp    $0x39,%al
 570:	7e cd                	jle    53f <atoi+0xf>
  return n;
 572:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 575:	c9                   	leave  
 576:	c3                   	ret    

00000577 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 577:	55                   	push   %ebp
 578:	89 e5                	mov    %esp,%ebp
 57a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 583:	8b 45 0c             	mov    0xc(%ebp),%eax
 586:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 589:	eb 10                	jmp    59b <memmove+0x24>
    *dst++ = *src++;
 58b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 58e:	8a 10                	mov    (%eax),%dl
 590:	8b 45 fc             	mov    -0x4(%ebp),%eax
 593:	88 10                	mov    %dl,(%eax)
 595:	ff 45 fc             	incl   -0x4(%ebp)
 598:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 59b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 59f:	0f 9f c0             	setg   %al
 5a2:	ff 4d 10             	decl   0x10(%ebp)
 5a5:	84 c0                	test   %al,%al
 5a7:	75 e2                	jne    58b <memmove+0x14>
  return vdst;
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ac:	c9                   	leave  
 5ad:	c3                   	ret    

000005ae <fork>:
 5ae:	b8 01 00 00 00       	mov    $0x1,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <exit>:
 5b6:	b8 02 00 00 00       	mov    $0x2,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <wait>:
 5be:	b8 03 00 00 00       	mov    $0x3,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <pipe>:
 5c6:	b8 04 00 00 00       	mov    $0x4,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <read>:
 5ce:	b8 05 00 00 00       	mov    $0x5,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <write>:
 5d6:	b8 10 00 00 00       	mov    $0x10,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <close>:
 5de:	b8 15 00 00 00       	mov    $0x15,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <kill>:
 5e6:	b8 06 00 00 00       	mov    $0x6,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <exec>:
 5ee:	b8 07 00 00 00       	mov    $0x7,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <open>:
 5f6:	b8 0f 00 00 00       	mov    $0xf,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <mknod>:
 5fe:	b8 11 00 00 00       	mov    $0x11,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <unlink>:
 606:	b8 12 00 00 00       	mov    $0x12,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <fstat>:
 60e:	b8 08 00 00 00       	mov    $0x8,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <link>:
 616:	b8 13 00 00 00       	mov    $0x13,%eax
 61b:	cd 40                	int    $0x40
 61d:	c3                   	ret    

0000061e <mkdir>:
 61e:	b8 14 00 00 00       	mov    $0x14,%eax
 623:	cd 40                	int    $0x40
 625:	c3                   	ret    

00000626 <chdir>:
 626:	b8 09 00 00 00       	mov    $0x9,%eax
 62b:	cd 40                	int    $0x40
 62d:	c3                   	ret    

0000062e <dup>:
 62e:	b8 0a 00 00 00       	mov    $0xa,%eax
 633:	cd 40                	int    $0x40
 635:	c3                   	ret    

00000636 <getpid>:
 636:	b8 0b 00 00 00       	mov    $0xb,%eax
 63b:	cd 40                	int    $0x40
 63d:	c3                   	ret    

0000063e <sbrk>:
 63e:	b8 0c 00 00 00       	mov    $0xc,%eax
 643:	cd 40                	int    $0x40
 645:	c3                   	ret    

00000646 <sleep>:
 646:	b8 0d 00 00 00       	mov    $0xd,%eax
 64b:	cd 40                	int    $0x40
 64d:	c3                   	ret    

0000064e <uptime>:
 64e:	b8 0e 00 00 00       	mov    $0xe,%eax
 653:	cd 40                	int    $0x40
 655:	c3                   	ret    

00000656 <lseek>:
 656:	b8 16 00 00 00       	mov    $0x16,%eax
 65b:	cd 40                	int    $0x40
 65d:	c3                   	ret    

0000065e <isatty>:
 65e:	b8 17 00 00 00       	mov    $0x17,%eax
 663:	cd 40                	int    $0x40
 665:	c3                   	ret    

00000666 <procstat>:
 666:	b8 18 00 00 00       	mov    $0x18,%eax
 66b:	cd 40                	int    $0x40
 66d:	c3                   	ret    

0000066e <set_priority>:
 66e:	b8 19 00 00 00       	mov    $0x19,%eax
 673:	cd 40                	int    $0x40
 675:	c3                   	ret    

00000676 <semget>:
 676:	b8 1a 00 00 00       	mov    $0x1a,%eax
 67b:	cd 40                	int    $0x40
 67d:	c3                   	ret    

0000067e <semfree>:
 67e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 683:	cd 40                	int    $0x40
 685:	c3                   	ret    

00000686 <semdown>:
 686:	b8 1c 00 00 00       	mov    $0x1c,%eax
 68b:	cd 40                	int    $0x40
 68d:	c3                   	ret    

0000068e <semup>:
 68e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 693:	cd 40                	int    $0x40
 695:	c3                   	ret    

00000696 <shm_create>:
 696:	b8 1e 00 00 00       	mov    $0x1e,%eax
 69b:	cd 40                	int    $0x40
 69d:	c3                   	ret    

0000069e <shm_close>:
 69e:	b8 1f 00 00 00       	mov    $0x1f,%eax
 6a3:	cd 40                	int    $0x40
 6a5:	c3                   	ret    

000006a6 <shm_get>:
 6a6:	b8 20 00 00 00       	mov    $0x20,%eax
 6ab:	cd 40                	int    $0x40
 6ad:	c3                   	ret    

000006ae <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6ae:	55                   	push   %ebp
 6af:	89 e5                	mov    %esp,%ebp
 6b1:	83 ec 28             	sub    $0x28,%esp
 6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6ba:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6c1:	00 
 6c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	89 04 24             	mov    %eax,(%esp)
 6cf:	e8 02 ff ff ff       	call   5d6 <write>
}
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    

000006d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d6:	55                   	push   %ebp
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e7:	74 17                	je     700 <printint+0x2a>
 6e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ed:	79 11                	jns    700 <printint+0x2a>
    neg = 1;
 6ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f9:	f7 d8                	neg    %eax
 6fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6fe:	eb 06                	jmp    706 <printint+0x30>
  } else {
    x = xx;
 700:	8b 45 0c             	mov    0xc(%ebp),%eax
 703:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 706:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 70d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 710:	8b 45 ec             	mov    -0x14(%ebp),%eax
 713:	ba 00 00 00 00       	mov    $0x0,%edx
 718:	f7 f1                	div    %ecx
 71a:	89 d0                	mov    %edx,%eax
 71c:	8a 80 30 0e 00 00    	mov    0xe30(%eax),%al
 722:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 725:	8b 55 f4             	mov    -0xc(%ebp),%edx
 728:	01 ca                	add    %ecx,%edx
 72a:	88 02                	mov    %al,(%edx)
 72c:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 72f:	8b 55 10             	mov    0x10(%ebp),%edx
 732:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 735:	8b 45 ec             	mov    -0x14(%ebp),%eax
 738:	ba 00 00 00 00       	mov    $0x0,%edx
 73d:	f7 75 d4             	divl   -0x2c(%ebp)
 740:	89 45 ec             	mov    %eax,-0x14(%ebp)
 743:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 747:	75 c4                	jne    70d <printint+0x37>
  if(neg)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	74 2c                	je     77b <printint+0xa5>
    buf[i++] = '-';
 74f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	01 d0                	add    %edx,%eax
 757:	c6 00 2d             	movb   $0x2d,(%eax)
 75a:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 75d:	eb 1c                	jmp    77b <printint+0xa5>
    putc(fd, buf[i]);
 75f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	01 d0                	add    %edx,%eax
 767:	8a 00                	mov    (%eax),%al
 769:	0f be c0             	movsbl %al,%eax
 76c:	89 44 24 04          	mov    %eax,0x4(%esp)
 770:	8b 45 08             	mov    0x8(%ebp),%eax
 773:	89 04 24             	mov    %eax,(%esp)
 776:	e8 33 ff ff ff       	call   6ae <putc>
  while(--i >= 0)
 77b:	ff 4d f4             	decl   -0xc(%ebp)
 77e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 782:	79 db                	jns    75f <printint+0x89>
}
 784:	c9                   	leave  
 785:	c3                   	ret    

00000786 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 786:	55                   	push   %ebp
 787:	89 e5                	mov    %esp,%ebp
 789:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 78c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 793:	8d 45 0c             	lea    0xc(%ebp),%eax
 796:	83 c0 04             	add    $0x4,%eax
 799:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 79c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a3:	e9 78 01 00 00       	jmp    920 <printf+0x19a>
    c = fmt[i] & 0xff;
 7a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ae:	01 d0                	add    %edx,%eax
 7b0:	8a 00                	mov    (%eax),%al
 7b2:	0f be c0             	movsbl %al,%eax
 7b5:	25 ff 00 00 00       	and    $0xff,%eax
 7ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c1:	75 2c                	jne    7ef <printf+0x69>
      if(c == '%'){
 7c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c7:	75 0c                	jne    7d5 <printf+0x4f>
        state = '%';
 7c9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d0:	e9 48 01 00 00       	jmp    91d <printf+0x197>
      } else {
        putc(fd, c);
 7d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d8:	0f be c0             	movsbl %al,%eax
 7db:	89 44 24 04          	mov    %eax,0x4(%esp)
 7df:	8b 45 08             	mov    0x8(%ebp),%eax
 7e2:	89 04 24             	mov    %eax,(%esp)
 7e5:	e8 c4 fe ff ff       	call   6ae <putc>
 7ea:	e9 2e 01 00 00       	jmp    91d <printf+0x197>
      }
    } else if(state == '%'){
 7ef:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f3:	0f 85 24 01 00 00    	jne    91d <printf+0x197>
      if(c == 'd'){
 7f9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7fd:	75 2d                	jne    82c <printf+0xa6>
        printint(fd, *ap, 10, 1);
 7ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 80b:	00 
 80c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 813:	00 
 814:	89 44 24 04          	mov    %eax,0x4(%esp)
 818:	8b 45 08             	mov    0x8(%ebp),%eax
 81b:	89 04 24             	mov    %eax,(%esp)
 81e:	e8 b3 fe ff ff       	call   6d6 <printint>
        ap++;
 823:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 827:	e9 ea 00 00 00       	jmp    916 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 82c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 830:	74 06                	je     838 <printf+0xb2>
 832:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 836:	75 2d                	jne    865 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 838:	8b 45 e8             	mov    -0x18(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 844:	00 
 845:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 84c:	00 
 84d:	89 44 24 04          	mov    %eax,0x4(%esp)
 851:	8b 45 08             	mov    0x8(%ebp),%eax
 854:	89 04 24             	mov    %eax,(%esp)
 857:	e8 7a fe ff ff       	call   6d6 <printint>
        ap++;
 85c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 860:	e9 b1 00 00 00       	jmp    916 <printf+0x190>
      } else if(c == 's'){
 865:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 869:	75 43                	jne    8ae <printf+0x128>
        s = (char*)*ap;
 86b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86e:	8b 00                	mov    (%eax),%eax
 870:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 873:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87b:	75 25                	jne    8a2 <printf+0x11c>
          s = "(null)";
 87d:	c7 45 f4 cd 0b 00 00 	movl   $0xbcd,-0xc(%ebp)
        while(*s != 0){
 884:	eb 1c                	jmp    8a2 <printf+0x11c>
          putc(fd, *s);
 886:	8b 45 f4             	mov    -0xc(%ebp),%eax
 889:	8a 00                	mov    (%eax),%al
 88b:	0f be c0             	movsbl %al,%eax
 88e:	89 44 24 04          	mov    %eax,0x4(%esp)
 892:	8b 45 08             	mov    0x8(%ebp),%eax
 895:	89 04 24             	mov    %eax,(%esp)
 898:	e8 11 fe ff ff       	call   6ae <putc>
          s++;
 89d:	ff 45 f4             	incl   -0xc(%ebp)
 8a0:	eb 01                	jmp    8a3 <printf+0x11d>
        while(*s != 0){
 8a2:	90                   	nop
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	8a 00                	mov    (%eax),%al
 8a8:	84 c0                	test   %al,%al
 8aa:	75 da                	jne    886 <printf+0x100>
 8ac:	eb 68                	jmp    916 <printf+0x190>
        }
      } else if(c == 'c'){
 8ae:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8b2:	75 1d                	jne    8d1 <printf+0x14b>
        putc(fd, *ap);
 8b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	0f be c0             	movsbl %al,%eax
 8bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c0:	8b 45 08             	mov    0x8(%ebp),%eax
 8c3:	89 04 24             	mov    %eax,(%esp)
 8c6:	e8 e3 fd ff ff       	call   6ae <putc>
        ap++;
 8cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8cf:	eb 45                	jmp    916 <printf+0x190>
      } else if(c == '%'){
 8d1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d5:	75 17                	jne    8ee <printf+0x168>
        putc(fd, c);
 8d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8da:	0f be c0             	movsbl %al,%eax
 8dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e1:	8b 45 08             	mov    0x8(%ebp),%eax
 8e4:	89 04 24             	mov    %eax,(%esp)
 8e7:	e8 c2 fd ff ff       	call   6ae <putc>
 8ec:	eb 28                	jmp    916 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8ee:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 8f5:	00 
 8f6:	8b 45 08             	mov    0x8(%ebp),%eax
 8f9:	89 04 24             	mov    %eax,(%esp)
 8fc:	e8 ad fd ff ff       	call   6ae <putc>
        putc(fd, c);
 901:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 904:	0f be c0             	movsbl %al,%eax
 907:	89 44 24 04          	mov    %eax,0x4(%esp)
 90b:	8b 45 08             	mov    0x8(%ebp),%eax
 90e:	89 04 24             	mov    %eax,(%esp)
 911:	e8 98 fd ff ff       	call   6ae <putc>
      }
      state = 0;
 916:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 91d:	ff 45 f0             	incl   -0x10(%ebp)
 920:	8b 55 0c             	mov    0xc(%ebp),%edx
 923:	8b 45 f0             	mov    -0x10(%ebp),%eax
 926:	01 d0                	add    %edx,%eax
 928:	8a 00                	mov    (%eax),%al
 92a:	84 c0                	test   %al,%al
 92c:	0f 85 76 fe ff ff    	jne    7a8 <printf+0x22>
    }
  }
}
 932:	c9                   	leave  
 933:	c3                   	ret    

00000934 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 934:	55                   	push   %ebp
 935:	89 e5                	mov    %esp,%ebp
 937:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93a:	8b 45 08             	mov    0x8(%ebp),%eax
 93d:	83 e8 08             	sub    $0x8,%eax
 940:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 943:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 948:	89 45 fc             	mov    %eax,-0x4(%ebp)
 94b:	eb 24                	jmp    971 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 00                	mov    (%eax),%eax
 952:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 955:	77 12                	ja     969 <free+0x35>
 957:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95d:	77 24                	ja     983 <free+0x4f>
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 00                	mov    (%eax),%eax
 964:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 967:	77 1a                	ja     983 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	8b 00                	mov    (%eax),%eax
 96e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 971:	8b 45 f8             	mov    -0x8(%ebp),%eax
 974:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 977:	76 d4                	jbe    94d <free+0x19>
 979:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97c:	8b 00                	mov    (%eax),%eax
 97e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 981:	76 ca                	jbe    94d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 983:	8b 45 f8             	mov    -0x8(%ebp),%eax
 986:	8b 40 04             	mov    0x4(%eax),%eax
 989:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 990:	8b 45 f8             	mov    -0x8(%ebp),%eax
 993:	01 c2                	add    %eax,%edx
 995:	8b 45 fc             	mov    -0x4(%ebp),%eax
 998:	8b 00                	mov    (%eax),%eax
 99a:	39 c2                	cmp    %eax,%edx
 99c:	75 24                	jne    9c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 99e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a1:	8b 50 04             	mov    0x4(%eax),%edx
 9a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a7:	8b 00                	mov    (%eax),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	01 c2                	add    %eax,%edx
 9ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 00                	mov    (%eax),%eax
 9b9:	8b 10                	mov    (%eax),%edx
 9bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9be:	89 10                	mov    %edx,(%eax)
 9c0:	eb 0a                	jmp    9cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c5:	8b 10                	mov    (%eax),%edx
 9c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cf:	8b 40 04             	mov    0x4(%eax),%eax
 9d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	01 d0                	add    %edx,%eax
 9de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9e1:	75 20                	jne    a03 <free+0xcf>
    p->s.size += bp->s.size;
 9e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e6:	8b 50 04             	mov    0x4(%eax),%edx
 9e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ec:	8b 40 04             	mov    0x4(%eax),%eax
 9ef:	01 c2                	add    %eax,%edx
 9f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fa:	8b 10                	mov    (%eax),%edx
 9fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ff:	89 10                	mov    %edx,(%eax)
 a01:	eb 08                	jmp    a0b <free+0xd7>
  } else
    p->s.ptr = bp;
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a09:	89 10                	mov    %edx,(%eax)
  freep = p;
 a0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0e:	a3 4c 0e 00 00       	mov    %eax,0xe4c
}
 a13:	c9                   	leave  
 a14:	c3                   	ret    

00000a15 <morecore>:

static Header*
morecore(uint nu)
{
 a15:	55                   	push   %ebp
 a16:	89 e5                	mov    %esp,%ebp
 a18:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a1b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a22:	77 07                	ja     a2b <morecore+0x16>
    nu = 4096;
 a24:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a2b:	8b 45 08             	mov    0x8(%ebp),%eax
 a2e:	c1 e0 03             	shl    $0x3,%eax
 a31:	89 04 24             	mov    %eax,(%esp)
 a34:	e8 05 fc ff ff       	call   63e <sbrk>
 a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a3c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a40:	75 07                	jne    a49 <morecore+0x34>
    return 0;
 a42:	b8 00 00 00 00       	mov    $0x0,%eax
 a47:	eb 22                	jmp    a6b <morecore+0x56>
  hp = (Header*)p;
 a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a52:	8b 55 08             	mov    0x8(%ebp),%edx
 a55:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5b:	83 c0 08             	add    $0x8,%eax
 a5e:	89 04 24             	mov    %eax,(%esp)
 a61:	e8 ce fe ff ff       	call   934 <free>
  return freep;
 a66:	a1 4c 0e 00 00       	mov    0xe4c,%eax
}
 a6b:	c9                   	leave  
 a6c:	c3                   	ret    

00000a6d <malloc>:

void*
malloc(uint nbytes)
{
 a6d:	55                   	push   %ebp
 a6e:	89 e5                	mov    %esp,%ebp
 a70:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a73:	8b 45 08             	mov    0x8(%ebp),%eax
 a76:	83 c0 07             	add    $0x7,%eax
 a79:	c1 e8 03             	shr    $0x3,%eax
 a7c:	40                   	inc    %eax
 a7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a80:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a88:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8c:	75 23                	jne    ab1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a8e:	c7 45 f0 44 0e 00 00 	movl   $0xe44,-0x10(%ebp)
 a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a98:	a3 4c 0e 00 00       	mov    %eax,0xe4c
 a9d:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 aa2:	a3 44 0e 00 00       	mov    %eax,0xe44
    base.s.size = 0;
 aa7:	c7 05 48 0e 00 00 00 	movl   $0x0,0xe48
 aae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab4:	8b 00                	mov    (%eax),%eax
 ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abc:	8b 40 04             	mov    0x4(%eax),%eax
 abf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac2:	72 4d                	jb     b11 <malloc+0xa4>
      if(p->s.size == nunits)
 ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac7:	8b 40 04             	mov    0x4(%eax),%eax
 aca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 acd:	75 0c                	jne    adb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	8b 10                	mov    (%eax),%edx
 ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad7:	89 10                	mov    %edx,(%eax)
 ad9:	eb 26                	jmp    b01 <malloc+0x94>
      else {
        p->s.size -= nunits;
 adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ade:	8b 40 04             	mov    0x4(%eax),%eax
 ae1:	89 c2                	mov    %eax,%edx
 ae3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	8b 40 04             	mov    0x4(%eax),%eax
 af2:	c1 e0 03             	shl    $0x3,%eax
 af5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 afe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b04:	a3 4c 0e 00 00       	mov    %eax,0xe4c
      return (void*)(p + 1);
 b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0c:	83 c0 08             	add    $0x8,%eax
 b0f:	eb 38                	jmp    b49 <malloc+0xdc>
    }
    if(p == freep)
 b11:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 b16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b19:	75 1b                	jne    b36 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b1e:	89 04 24             	mov    %eax,(%esp)
 b21:	e8 ef fe ff ff       	call   a15 <morecore>
 b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b2d:	75 07                	jne    b36 <malloc+0xc9>
        return 0;
 b2f:	b8 00 00 00 00       	mov    $0x0,%eax
 b34:	eb 13                	jmp    b49 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b39:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3f:	8b 00                	mov    (%eax),%eax
 b41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 b44:	e9 70 ff ff ff       	jmp    ab9 <malloc+0x4c>
}
 b49:	c9                   	leave  
 b4a:	c3                   	ret    
