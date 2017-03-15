
_shared-test:     formato del fichero elf32-i386


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
  // Operador de Dirección (&): Este nos permite acceder a la dirección de memoria de una variable.
  // Operador de Indirección (*): Además de que nos permite declarar un tipo de dato puntero, también nos permite ver el VALOR que está en la dirección asignada.
  int keyIndex; 
  char *index = 0; // declaro puntero
   6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  keyIndex = shm_create(); // creo el espacio de memoria a compartir
   d:	e8 18 06 00 00       	call   62a <shm_create>
  12:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"*index = %d  \n" , *index ); 
  15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  18:	8a 00                	mov    (%eax),%al
  1a:	0f be c0             	movsbl %al,%eax
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	c7 44 24 04 df 0a 00 	movl   $0xadf,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 e5 06 00 00       	call   71a <printf>
  printf(1,"index= %d  \n" , index ); 
  35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 ee 0a 00 	movl   $0xaee,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 ca 06 00 00       	call   71a <printf>
  printf(1,"&index= %d  \n" , &index );
  50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	c7 44 24 04 fb 0a 00 	movl   $0xafb,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 af 06 00 00       	call   71a <printf>
  printf(1,"Indice del arreglo= %d  \n" , keyIndex ); // primer indice del arreglo
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  72:	c7 44 24 04 09 0b 00 	movl   $0xb09,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 94 06 00 00       	call   71a <printf>

  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  89:	89 44 24 04          	mov    %eax,0x4(%esp)
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	89 04 24             	mov    %eax,(%esp)
  93:	e8 a2 05 00 00       	call   63a <shm_get>
  98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"return shm_get %d  \n" , a);  // si retorna 0, pudo obtener el espacio de memoria asociado a el indice keyIndex
  9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  a2:	c7 44 24 04 23 0b 00 	movl   $0xb23,0x4(%esp)
  a9:	00 
  aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b1:	e8 64 06 00 00       	call   71a <printf>
}
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <test_2>:
//   printf(1,"resultado del shm_close %d  \n" , shm_close(keyIndex));
// }

// test shm_create
void
test_2(){
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 28             	sub    $0x28,%esp
  int keyIndex;
  int keyIndex_2;
  keyIndex = shm_create(); //Creates a shared memory block.
  be:	e8 67 05 00 00       	call   62a <shm_create>
  c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  keyIndex_2 = shm_create(); //Creates a shared memory block.
  c6:	e8 5f 05 00 00       	call   62a <shm_create>
  cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"keyIndex  %d  \n" , keyIndex);
  ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  d5:	c7 44 24 04 38 0b 00 	movl   $0xb38,0x4(%esp)
  dc:	00 
  dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e4:	e8 31 06 00 00       	call   71a <printf>
  printf(1,"keyIndex_2 %d  \n" , keyIndex_2);
  e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  f0:	c7 44 24 04 48 0b 00 	movl   $0xb48,0x4(%esp)
  f7:	00 
  f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ff:	e8 16 06 00 00       	call   71a <printf>
  exit();
 104:	e8 41 04 00 00       	call   54a <exit>

00000109 <test>:
}

void
test(){
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 28             	sub    $0x28,%esp
  int pid, keyIndex;
  char* index = 0;
 10f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  keyIndex = shm_create(); //creo el espacio de memoria
 116:	e8 0f 05 00 00       	call   62a <shm_create>
 11b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"init index= %d  \n" , *index );
 11e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 121:	8a 00                	mov    (%eax),%al
 123:	0f be c0             	movsbl %al,%eax
 126:	89 44 24 08          	mov    %eax,0x8(%esp)
 12a:	c7 44 24 04 59 0b 00 	movl   $0xb59,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 dc 05 00 00       	call   71a <printf>
  printf(1,"init index= %d  \n" , &index );
 13e:	8d 45 ec             	lea    -0x14(%ebp),%eax
 141:	89 44 24 08          	mov    %eax,0x8(%esp)
 145:	c7 44 24 04 59 0b 00 	movl   $0xb59,0x4(%esp)
 14c:	00 
 14d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 154:	e8 c1 05 00 00       	call   71a <printf>

  shm_get(keyIndex, &index); // map
 159:	8d 45 ec             	lea    -0x14(%ebp),%eax
 15c:	89 44 24 04          	mov    %eax,0x4(%esp)
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	89 04 24             	mov    %eax,(%esp)
 166:	e8 cf 04 00 00       	call   63a <shm_get>

  pid = fork(); // creo un proceso (hijo) - printf(1,"pid= %d  \n" , pid );
 16b:	e8 d2 03 00 00       	call   542 <fork>
 170:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *index = 3;
 173:	8b 45 ec             	mov    -0x14(%ebp),%eax
 176:	c6 00 03             	movb   $0x3,(%eax)

  printf(1,"father index= %d  \n" , &index );
 179:	8d 45 ec             	lea    -0x14(%ebp),%eax
 17c:	89 44 24 08          	mov    %eax,0x8(%esp)
 180:	c7 44 24 04 6b 0b 00 	movl   $0xb6b,0x4(%esp)
 187:	00 
 188:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18f:	e8 86 05 00 00       	call   71a <printf>
  printf(1,"father= %d  \n" , *index);
 194:	8b 45 ec             	mov    -0x14(%ebp),%eax
 197:	8a 00                	mov    (%eax),%al
 199:	0f be c0             	movsbl %al,%eax
 19c:	89 44 24 08          	mov    %eax,0x8(%esp)
 1a0:	c7 44 24 04 7f 0b 00 	movl   $0xb7f,0x4(%esp)
 1a7:	00 
 1a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1af:	e8 66 05 00 00       	call   71a <printf>

  printf(1,"** ** ** ** ** \n");
 1b4:	c7 44 24 04 8d 0b 00 	movl   $0xb8d,0x4(%esp)
 1bb:	00 
 1bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c3:	e8 52 05 00 00       	call   71a <printf>

  if(pid == 0 ){
 1c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1cc:	75 4b                	jne    219 <test+0x110>
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
 1ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1d1:	8a 00                	mov    (%eax),%al
 1d3:	0f be c0             	movsbl %al,%eax
 1d6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1da:	c7 44 24 04 9e 0b 00 	movl   $0xb9e,0x4(%esp)
 1e1:	00 
 1e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e9:	e8 2c 05 00 00       	call   71a <printf>
    *index = 4;
 1ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1f1:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
 1f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1f7:	8a 00                	mov    (%eax),%al
 1f9:	0f be c0             	movsbl %al,%eax
 1fc:	89 44 24 08          	mov    %eax,0x8(%esp)
 200:	c7 44 24 04 9e 0b 00 	movl   $0xb9e,0x4(%esp)
 207:	00 
 208:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 20f:	e8 06 05 00 00       	call   71a <printf>
    //shm_close(keyIndex);
    exit();
 214:	e8 31 03 00 00       	call   54a <exit>
  }
  printf(1,"exit *(index)= %d  \n" , *(index) );
 219:	8b 45 ec             	mov    -0x14(%ebp),%eax
 21c:	8a 00                	mov    (%eax),%al
 21e:	0f be c0             	movsbl %al,%eax
 221:	89 44 24 08          	mov    %eax,0x8(%esp)
 225:	c7 44 24 04 b1 0b 00 	movl   $0xbb1,0x4(%esp)
 22c:	00 
 22d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 234:	e8 e1 04 00 00       	call   71a <printf>
  wait();
 239:	e8 14 03 00 00       	call   552 <wait>
  printf(1,"exit &(index)= %d  \n" , &(index) );
 23e:	8d 45 ec             	lea    -0x14(%ebp),%eax
 241:	89 44 24 08          	mov    %eax,0x8(%esp)
 245:	c7 44 24 04 c6 0b 00 	movl   $0xbc6,0x4(%esp)
 24c:	00 
 24d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 254:	e8 c1 04 00 00       	call   71a <printf>
  printf(1,"exit *(index)= %d  \n" , *(index) );
 259:	8b 45 ec             	mov    -0x14(%ebp),%eax
 25c:	8a 00                	mov    (%eax),%al
 25e:	0f be c0             	movsbl %al,%eax
 261:	89 44 24 08          	mov    %eax,0x8(%esp)
 265:	c7 44 24 04 b1 0b 00 	movl   $0xbb1,0x4(%esp)
 26c:	00 
 26d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 274:	e8 a1 04 00 00       	call   71a <printf>
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <test_4>:


void
test_4(){
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp
 27e:	83 ec 28             	sub    $0x28,%esp
  int a;
  int k;
  char* mem= 0;
 281:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  *mem = (int)8; 
 288:	8b 45 ec             	mov    -0x14(%ebp),%eax
 28b:	c6 00 08             	movb   $0x8,(%eax)
  k = shm_create();  // creo espacio de memoria que sera para compartir
 28e:	e8 97 03 00 00       	call   62a <shm_create>
 293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"salida shm_create %d  \n" , k);
 296:	8b 45 f4             	mov    -0xc(%ebp),%eax
 299:	89 44 24 08          	mov    %eax,0x8(%esp)
 29d:	c7 44 24 04 db 0b 00 	movl   $0xbdb,0x4(%esp)
 2a4:	00 
 2a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ac:	e8 69 04 00 00       	call   71a <printf>

  shm_get(k,&mem);  // mapeo el espacio 
 2b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
 2b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bb:	89 04 24             	mov    %eax,(%esp)
 2be:	e8 77 03 00 00       	call   63a <shm_get>
  a = shm_close(k);
 2c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c6:	89 04 24             	mov    %eax,(%esp)
 2c9:	e8 64 03 00 00       	call   632 <shm_close>
 2ce:	89 45 f0             	mov    %eax,-0x10(%ebp)

  printf(1,"salida shm_close %d  \n" , a);
 2d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 2d8:	c7 44 24 04 f3 0b 00 	movl   $0xbf3,0x4(%esp)
 2df:	00 
 2e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2e7:	e8 2e 04 00 00       	call   71a <printf>
  exit();
 2ec:	e8 59 02 00 00       	call   54a <exit>

000002f1 <main>:
}

int
main(int argc, char *argv[]) {
 2f1:	55                   	push   %ebp
 2f2:	89 e5                	mov    %esp,%ebp
 2f4:	83 e4 f0             	and    $0xfffffff0,%esp

  // test_0();
  // test_1();
  // test();
  test_4();
 2f7:	e8 7f ff ff ff       	call   27b <test_4>
  // wait();
  // printf(1," * * * * Padre * * * *\n");
  // printf(1,"father *(index_2) = %d  \n" , *(index_2));
  // printf(1,"father &(index) = %d  \n" , &(index));
  // printf(1,"father *(index) = %d  \n" , *(index));
   exit();
 2fc:	e8 49 02 00 00       	call   54a <exit>

00000301 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	57                   	push   %edi
 305:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 306:	8b 4d 08             	mov    0x8(%ebp),%ecx
 309:	8b 55 10             	mov    0x10(%ebp),%edx
 30c:	8b 45 0c             	mov    0xc(%ebp),%eax
 30f:	89 cb                	mov    %ecx,%ebx
 311:	89 df                	mov    %ebx,%edi
 313:	89 d1                	mov    %edx,%ecx
 315:	fc                   	cld    
 316:	f3 aa                	rep stos %al,%es:(%edi)
 318:	89 ca                	mov    %ecx,%edx
 31a:	89 fb                	mov    %edi,%ebx
 31c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 31f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 322:	5b                   	pop    %ebx
 323:	5f                   	pop    %edi
 324:	5d                   	pop    %ebp
 325:	c3                   	ret    

00000326 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 332:	90                   	nop
 333:	8b 45 0c             	mov    0xc(%ebp),%eax
 336:	8a 10                	mov    (%eax),%dl
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	88 10                	mov    %dl,(%eax)
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	8a 00                	mov    (%eax),%al
 342:	84 c0                	test   %al,%al
 344:	0f 95 c0             	setne  %al
 347:	ff 45 08             	incl   0x8(%ebp)
 34a:	ff 45 0c             	incl   0xc(%ebp)
 34d:	84 c0                	test   %al,%al
 34f:	75 e2                	jne    333 <strcpy+0xd>
    ;
  return os;
 351:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 359:	eb 06                	jmp    361 <strcmp+0xb>
    p++, q++;
 35b:	ff 45 08             	incl   0x8(%ebp)
 35e:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	8a 00                	mov    (%eax),%al
 366:	84 c0                	test   %al,%al
 368:	74 0e                	je     378 <strcmp+0x22>
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	8a 10                	mov    (%eax),%dl
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	8a 00                	mov    (%eax),%al
 374:	38 c2                	cmp    %al,%dl
 376:	74 e3                	je     35b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	8a 00                	mov    (%eax),%al
 37d:	0f b6 d0             	movzbl %al,%edx
 380:	8b 45 0c             	mov    0xc(%ebp),%eax
 383:	8a 00                	mov    (%eax),%al
 385:	0f b6 c0             	movzbl %al,%eax
 388:	89 d1                	mov    %edx,%ecx
 38a:	29 c1                	sub    %eax,%ecx
 38c:	89 c8                	mov    %ecx,%eax
}
 38e:	5d                   	pop    %ebp
 38f:	c3                   	ret    

00000390 <strlen>:

uint
strlen(char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 39d:	eb 03                	jmp    3a2 <strlen+0x12>
 39f:	ff 45 fc             	incl   -0x4(%ebp)
 3a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	01 d0                	add    %edx,%eax
 3aa:	8a 00                	mov    (%eax),%al
 3ac:	84 c0                	test   %al,%al
 3ae:	75 ef                	jne    39f <strlen+0xf>
    ;
  return n;
 3b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3bb:	8b 45 10             	mov    0x10(%ebp),%eax
 3be:	89 44 24 08          	mov    %eax,0x8(%esp)
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	89 04 24             	mov    %eax,(%esp)
 3cf:	e8 2d ff ff ff       	call   301 <stosb>
  return dst;
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3d7:	c9                   	leave  
 3d8:	c3                   	ret    

000003d9 <strchr>:

char*
strchr(const char *s, char c)
{
 3d9:	55                   	push   %ebp
 3da:	89 e5                	mov    %esp,%ebp
 3dc:	83 ec 04             	sub    $0x4,%esp
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3e5:	eb 12                	jmp    3f9 <strchr+0x20>
    if(*s == c)
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	8a 00                	mov    (%eax),%al
 3ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3ef:	75 05                	jne    3f6 <strchr+0x1d>
      return (char*)s;
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	eb 11                	jmp    407 <strchr+0x2e>
  for(; *s; s++)
 3f6:	ff 45 08             	incl   0x8(%ebp)
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	8a 00                	mov    (%eax),%al
 3fe:	84 c0                	test   %al,%al
 400:	75 e5                	jne    3e7 <strchr+0xe>
  return 0;
 402:	b8 00 00 00 00       	mov    $0x0,%eax
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <gets>:

char*
gets(char *buf, int max)
{
 409:	55                   	push   %ebp
 40a:	89 e5                	mov    %esp,%ebp
 40c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 40f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 416:	eb 42                	jmp    45a <gets+0x51>
    cc = read(0, &c, 1);
 418:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41f:	00 
 420:	8d 45 ef             	lea    -0x11(%ebp),%eax
 423:	89 44 24 04          	mov    %eax,0x4(%esp)
 427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 42e:	e8 2f 01 00 00       	call   562 <read>
 433:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 43a:	7e 29                	jle    465 <gets+0x5c>
      break;
    buf[i++] = c;
 43c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	01 c2                	add    %eax,%edx
 444:	8a 45 ef             	mov    -0x11(%ebp),%al
 447:	88 02                	mov    %al,(%edx)
 449:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 44c:	8a 45 ef             	mov    -0x11(%ebp),%al
 44f:	3c 0a                	cmp    $0xa,%al
 451:	74 13                	je     466 <gets+0x5d>
 453:	8a 45 ef             	mov    -0x11(%ebp),%al
 456:	3c 0d                	cmp    $0xd,%al
 458:	74 0c                	je     466 <gets+0x5d>
  for(i=0; i+1 < max; ){
 45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45d:	40                   	inc    %eax
 45e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 461:	7c b5                	jl     418 <gets+0xf>
 463:	eb 01                	jmp    466 <gets+0x5d>
      break;
 465:	90                   	nop
      break;
  }
  buf[i] = '\0';
 466:	8b 55 f4             	mov    -0xc(%ebp),%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	01 d0                	add    %edx,%eax
 46e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 471:	8b 45 08             	mov    0x8(%ebp),%eax
}
 474:	c9                   	leave  
 475:	c3                   	ret    

00000476 <stat>:

int
stat(char *n, struct stat *st)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 483:	00 
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	89 04 24             	mov    %eax,(%esp)
 48a:	e8 fb 00 00 00       	call   58a <open>
 48f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 496:	79 07                	jns    49f <stat+0x29>
    return -1;
 498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 49d:	eb 23                	jmp    4c2 <stat+0x4c>
  r = fstat(fd, st);
 49f:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a9:	89 04 24             	mov    %eax,(%esp)
 4ac:	e8 f1 00 00 00       	call   5a2 <fstat>
 4b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b7:	89 04 24             	mov    %eax,(%esp)
 4ba:	e8 b3 00 00 00       	call   572 <close>
  return r;
 4bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    

000004c4 <atoi>:

int
atoi(const char *s)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4d1:	eb 21                	jmp    4f4 <atoi+0x30>
    n = n*10 + *s++ - '0';
 4d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d6:	89 d0                	mov    %edx,%eax
 4d8:	c1 e0 02             	shl    $0x2,%eax
 4db:	01 d0                	add    %edx,%eax
 4dd:	d1 e0                	shl    %eax
 4df:	89 c2                	mov    %eax,%edx
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	8a 00                	mov    (%eax),%al
 4e6:	0f be c0             	movsbl %al,%eax
 4e9:	01 d0                	add    %edx,%eax
 4eb:	83 e8 30             	sub    $0x30,%eax
 4ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
 4f1:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	8a 00                	mov    (%eax),%al
 4f9:	3c 2f                	cmp    $0x2f,%al
 4fb:	7e 09                	jle    506 <atoi+0x42>
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
 500:	8a 00                	mov    (%eax),%al
 502:	3c 39                	cmp    $0x39,%al
 504:	7e cd                	jle    4d3 <atoi+0xf>
  return n;
 506:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 517:	8b 45 0c             	mov    0xc(%ebp),%eax
 51a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 51d:	eb 10                	jmp    52f <memmove+0x24>
    *dst++ = *src++;
 51f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 522:	8a 10                	mov    (%eax),%dl
 524:	8b 45 fc             	mov    -0x4(%ebp),%eax
 527:	88 10                	mov    %dl,(%eax)
 529:	ff 45 fc             	incl   -0x4(%ebp)
 52c:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 52f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 533:	0f 9f c0             	setg   %al
 536:	ff 4d 10             	decl   0x10(%ebp)
 539:	84 c0                	test   %al,%al
 53b:	75 e2                	jne    51f <memmove+0x14>
  return vdst;
 53d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 540:	c9                   	leave  
 541:	c3                   	ret    

00000542 <fork>:
 542:	b8 01 00 00 00       	mov    $0x1,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <exit>:
 54a:	b8 02 00 00 00       	mov    $0x2,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <wait>:
 552:	b8 03 00 00 00       	mov    $0x3,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <pipe>:
 55a:	b8 04 00 00 00       	mov    $0x4,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <read>:
 562:	b8 05 00 00 00       	mov    $0x5,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <write>:
 56a:	b8 10 00 00 00       	mov    $0x10,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <close>:
 572:	b8 15 00 00 00       	mov    $0x15,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <kill>:
 57a:	b8 06 00 00 00       	mov    $0x6,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <exec>:
 582:	b8 07 00 00 00       	mov    $0x7,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <open>:
 58a:	b8 0f 00 00 00       	mov    $0xf,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <mknod>:
 592:	b8 11 00 00 00       	mov    $0x11,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <unlink>:
 59a:	b8 12 00 00 00       	mov    $0x12,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <fstat>:
 5a2:	b8 08 00 00 00       	mov    $0x8,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <link>:
 5aa:	b8 13 00 00 00       	mov    $0x13,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <mkdir>:
 5b2:	b8 14 00 00 00       	mov    $0x14,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <chdir>:
 5ba:	b8 09 00 00 00       	mov    $0x9,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <dup>:
 5c2:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <getpid>:
 5ca:	b8 0b 00 00 00       	mov    $0xb,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <sbrk>:
 5d2:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <sleep>:
 5da:	b8 0d 00 00 00       	mov    $0xd,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <uptime>:
 5e2:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <lseek>:
 5ea:	b8 16 00 00 00       	mov    $0x16,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <isatty>:
 5f2:	b8 17 00 00 00       	mov    $0x17,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <procstat>:
 5fa:	b8 18 00 00 00       	mov    $0x18,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <set_priority>:
 602:	b8 19 00 00 00       	mov    $0x19,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <semget>:
 60a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <semfree>:
 612:	b8 1b 00 00 00       	mov    $0x1b,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <semdown>:
 61a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <semup>:
 622:	b8 1d 00 00 00       	mov    $0x1d,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <shm_create>:
 62a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <shm_close>:
 632:	b8 1f 00 00 00       	mov    $0x1f,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <shm_get>:
 63a:	b8 20 00 00 00       	mov    $0x20,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 642:	55                   	push   %ebp
 643:	89 e5                	mov    %esp,%ebp
 645:	83 ec 28             	sub    $0x28,%esp
 648:	8b 45 0c             	mov    0xc(%ebp),%eax
 64b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 64e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 655:	00 
 656:	8d 45 f4             	lea    -0xc(%ebp),%eax
 659:	89 44 24 04          	mov    %eax,0x4(%esp)
 65d:	8b 45 08             	mov    0x8(%ebp),%eax
 660:	89 04 24             	mov    %eax,(%esp)
 663:	e8 02 ff ff ff       	call   56a <write>
}
 668:	c9                   	leave  
 669:	c3                   	ret    

0000066a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 66a:	55                   	push   %ebp
 66b:	89 e5                	mov    %esp,%ebp
 66d:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 670:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 677:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 67b:	74 17                	je     694 <printint+0x2a>
 67d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 681:	79 11                	jns    694 <printint+0x2a>
    neg = 1;
 683:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 68a:	8b 45 0c             	mov    0xc(%ebp),%eax
 68d:	f7 d8                	neg    %eax
 68f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 692:	eb 06                	jmp    69a <printint+0x30>
  } else {
    x = xx;
 694:	8b 45 0c             	mov    0xc(%ebp),%eax
 697:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 69a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a7:	ba 00 00 00 00       	mov    $0x0,%edx
 6ac:	f7 f1                	div    %ecx
 6ae:	89 d0                	mov    %edx,%eax
 6b0:	8a 80 c8 0e 00 00    	mov    0xec8(%eax),%al
 6b6:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 6b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6bc:	01 ca                	add    %ecx,%edx
 6be:	88 02                	mov    %al,(%edx)
 6c0:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 6c3:	8b 55 10             	mov    0x10(%ebp),%edx
 6c6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 6c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6cc:	ba 00 00 00 00       	mov    $0x0,%edx
 6d1:	f7 75 d4             	divl   -0x2c(%ebp)
 6d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6db:	75 c4                	jne    6a1 <printint+0x37>
  if(neg)
 6dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e1:	74 2c                	je     70f <printint+0xa5>
    buf[i++] = '-';
 6e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e9:	01 d0                	add    %edx,%eax
 6eb:	c6 00 2d             	movb   $0x2d,(%eax)
 6ee:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 6f1:	eb 1c                	jmp    70f <printint+0xa5>
    putc(fd, buf[i]);
 6f3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f9:	01 d0                	add    %edx,%eax
 6fb:	8a 00                	mov    (%eax),%al
 6fd:	0f be c0             	movsbl %al,%eax
 700:	89 44 24 04          	mov    %eax,0x4(%esp)
 704:	8b 45 08             	mov    0x8(%ebp),%eax
 707:	89 04 24             	mov    %eax,(%esp)
 70a:	e8 33 ff ff ff       	call   642 <putc>
  while(--i >= 0)
 70f:	ff 4d f4             	decl   -0xc(%ebp)
 712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 716:	79 db                	jns    6f3 <printint+0x89>
}
 718:	c9                   	leave  
 719:	c3                   	ret    

0000071a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 71a:	55                   	push   %ebp
 71b:	89 e5                	mov    %esp,%ebp
 71d:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 720:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 727:	8d 45 0c             	lea    0xc(%ebp),%eax
 72a:	83 c0 04             	add    $0x4,%eax
 72d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 737:	e9 78 01 00 00       	jmp    8b4 <printf+0x19a>
    c = fmt[i] & 0xff;
 73c:	8b 55 0c             	mov    0xc(%ebp),%edx
 73f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 742:	01 d0                	add    %edx,%eax
 744:	8a 00                	mov    (%eax),%al
 746:	0f be c0             	movsbl %al,%eax
 749:	25 ff 00 00 00       	and    $0xff,%eax
 74e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 751:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 755:	75 2c                	jne    783 <printf+0x69>
      if(c == '%'){
 757:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75b:	75 0c                	jne    769 <printf+0x4f>
        state = '%';
 75d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 764:	e9 48 01 00 00       	jmp    8b1 <printf+0x197>
      } else {
        putc(fd, c);
 769:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 76c:	0f be c0             	movsbl %al,%eax
 76f:	89 44 24 04          	mov    %eax,0x4(%esp)
 773:	8b 45 08             	mov    0x8(%ebp),%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 c4 fe ff ff       	call   642 <putc>
 77e:	e9 2e 01 00 00       	jmp    8b1 <printf+0x197>
      }
    } else if(state == '%'){
 783:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 787:	0f 85 24 01 00 00    	jne    8b1 <printf+0x197>
      if(c == 'd'){
 78d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 791:	75 2d                	jne    7c0 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 793:	8b 45 e8             	mov    -0x18(%ebp),%eax
 796:	8b 00                	mov    (%eax),%eax
 798:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 79f:	00 
 7a0:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 7a7:	00 
 7a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 b3 fe ff ff       	call   66a <printint>
        ap++;
 7b7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7bb:	e9 ea 00 00 00       	jmp    8aa <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 7c0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7c4:	74 06                	je     7cc <printf+0xb2>
 7c6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ca:	75 2d                	jne    7f9 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 7cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7d8:	00 
 7d9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7e0:	00 
 7e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e5:	8b 45 08             	mov    0x8(%ebp),%eax
 7e8:	89 04 24             	mov    %eax,(%esp)
 7eb:	e8 7a fe ff ff       	call   66a <printint>
        ap++;
 7f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7f4:	e9 b1 00 00 00       	jmp    8aa <printf+0x190>
      } else if(c == 's'){
 7f9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7fd:	75 43                	jne    842 <printf+0x128>
        s = (char*)*ap;
 7ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 807:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 80b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80f:	75 25                	jne    836 <printf+0x11c>
          s = "(null)";
 811:	c7 45 f4 0a 0c 00 00 	movl   $0xc0a,-0xc(%ebp)
        while(*s != 0){
 818:	eb 1c                	jmp    836 <printf+0x11c>
          putc(fd, *s);
 81a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81d:	8a 00                	mov    (%eax),%al
 81f:	0f be c0             	movsbl %al,%eax
 822:	89 44 24 04          	mov    %eax,0x4(%esp)
 826:	8b 45 08             	mov    0x8(%ebp),%eax
 829:	89 04 24             	mov    %eax,(%esp)
 82c:	e8 11 fe ff ff       	call   642 <putc>
          s++;
 831:	ff 45 f4             	incl   -0xc(%ebp)
 834:	eb 01                	jmp    837 <printf+0x11d>
        while(*s != 0){
 836:	90                   	nop
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	8a 00                	mov    (%eax),%al
 83c:	84 c0                	test   %al,%al
 83e:	75 da                	jne    81a <printf+0x100>
 840:	eb 68                	jmp    8aa <printf+0x190>
        }
      } else if(c == 'c'){
 842:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 846:	75 1d                	jne    865 <printf+0x14b>
        putc(fd, *ap);
 848:	8b 45 e8             	mov    -0x18(%ebp),%eax
 84b:	8b 00                	mov    (%eax),%eax
 84d:	0f be c0             	movsbl %al,%eax
 850:	89 44 24 04          	mov    %eax,0x4(%esp)
 854:	8b 45 08             	mov    0x8(%ebp),%eax
 857:	89 04 24             	mov    %eax,(%esp)
 85a:	e8 e3 fd ff ff       	call   642 <putc>
        ap++;
 85f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 863:	eb 45                	jmp    8aa <printf+0x190>
      } else if(c == '%'){
 865:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 869:	75 17                	jne    882 <printf+0x168>
        putc(fd, c);
 86b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 86e:	0f be c0             	movsbl %al,%eax
 871:	89 44 24 04          	mov    %eax,0x4(%esp)
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	89 04 24             	mov    %eax,(%esp)
 87b:	e8 c2 fd ff ff       	call   642 <putc>
 880:	eb 28                	jmp    8aa <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 882:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 889:	00 
 88a:	8b 45 08             	mov    0x8(%ebp),%eax
 88d:	89 04 24             	mov    %eax,(%esp)
 890:	e8 ad fd ff ff       	call   642 <putc>
        putc(fd, c);
 895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 898:	0f be c0             	movsbl %al,%eax
 89b:	89 44 24 04          	mov    %eax,0x4(%esp)
 89f:	8b 45 08             	mov    0x8(%ebp),%eax
 8a2:	89 04 24             	mov    %eax,(%esp)
 8a5:	e8 98 fd ff ff       	call   642 <putc>
      }
      state = 0;
 8aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8b1:	ff 45 f0             	incl   -0x10(%ebp)
 8b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 8b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ba:	01 d0                	add    %edx,%eax
 8bc:	8a 00                	mov    (%eax),%al
 8be:	84 c0                	test   %al,%al
 8c0:	0f 85 76 fe ff ff    	jne    73c <printf+0x22>
    }
  }
}
 8c6:	c9                   	leave  
 8c7:	c3                   	ret    

000008c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	83 e8 08             	sub    $0x8,%eax
 8d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d7:	a1 e4 0e 00 00       	mov    0xee4,%eax
 8dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8df:	eb 24                	jmp    905 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e9:	77 12                	ja     8fd <free+0x35>
 8eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8f1:	77 24                	ja     917 <free+0x4f>
 8f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f6:	8b 00                	mov    (%eax),%eax
 8f8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8fb:	77 1a                	ja     917 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	89 45 fc             	mov    %eax,-0x4(%ebp)
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 90b:	76 d4                	jbe    8e1 <free+0x19>
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 915:	76 ca                	jbe    8e1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	8b 40 04             	mov    0x4(%eax),%eax
 91d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 924:	8b 45 f8             	mov    -0x8(%ebp),%eax
 927:	01 c2                	add    %eax,%edx
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	39 c2                	cmp    %eax,%edx
 930:	75 24                	jne    956 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	8b 50 04             	mov    0x4(%eax),%edx
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	01 c2                	add    %eax,%edx
 942:	8b 45 f8             	mov    -0x8(%ebp),%eax
 945:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	8b 10                	mov    (%eax),%edx
 94f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 952:	89 10                	mov    %edx,(%eax)
 954:	eb 0a                	jmp    960 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 956:	8b 45 fc             	mov    -0x4(%ebp),%eax
 959:	8b 10                	mov    (%eax),%edx
 95b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 960:	8b 45 fc             	mov    -0x4(%ebp),%eax
 963:	8b 40 04             	mov    0x4(%eax),%eax
 966:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 96d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 970:	01 d0                	add    %edx,%eax
 972:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 975:	75 20                	jne    997 <free+0xcf>
    p->s.size += bp->s.size;
 977:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97a:	8b 50 04             	mov    0x4(%eax),%edx
 97d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 980:	8b 40 04             	mov    0x4(%eax),%eax
 983:	01 c2                	add    %eax,%edx
 985:	8b 45 fc             	mov    -0x4(%ebp),%eax
 988:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 98b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 98e:	8b 10                	mov    (%eax),%edx
 990:	8b 45 fc             	mov    -0x4(%ebp),%eax
 993:	89 10                	mov    %edx,(%eax)
 995:	eb 08                	jmp    99f <free+0xd7>
  } else
    p->s.ptr = bp;
 997:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 99d:	89 10                	mov    %edx,(%eax)
  freep = p;
 99f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a2:	a3 e4 0e 00 00       	mov    %eax,0xee4
}
 9a7:	c9                   	leave  
 9a8:	c3                   	ret    

000009a9 <morecore>:

static Header*
morecore(uint nu)
{
 9a9:	55                   	push   %ebp
 9aa:	89 e5                	mov    %esp,%ebp
 9ac:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9af:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9b6:	77 07                	ja     9bf <morecore+0x16>
    nu = 4096;
 9b8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9bf:	8b 45 08             	mov    0x8(%ebp),%eax
 9c2:	c1 e0 03             	shl    $0x3,%eax
 9c5:	89 04 24             	mov    %eax,(%esp)
 9c8:	e8 05 fc ff ff       	call   5d2 <sbrk>
 9cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9d0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9d4:	75 07                	jne    9dd <morecore+0x34>
    return 0;
 9d6:	b8 00 00 00 00       	mov    $0x0,%eax
 9db:	eb 22                	jmp    9ff <morecore+0x56>
  hp = (Header*)p;
 9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e6:	8b 55 08             	mov    0x8(%ebp),%edx
 9e9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ef:	83 c0 08             	add    $0x8,%eax
 9f2:	89 04 24             	mov    %eax,(%esp)
 9f5:	e8 ce fe ff ff       	call   8c8 <free>
  return freep;
 9fa:	a1 e4 0e 00 00       	mov    0xee4,%eax
}
 9ff:	c9                   	leave  
 a00:	c3                   	ret    

00000a01 <malloc>:

void*
malloc(uint nbytes)
{
 a01:	55                   	push   %ebp
 a02:	89 e5                	mov    %esp,%ebp
 a04:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	83 c0 07             	add    $0x7,%eax
 a0d:	c1 e8 03             	shr    $0x3,%eax
 a10:	40                   	inc    %eax
 a11:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a14:	a1 e4 0e 00 00       	mov    0xee4,%eax
 a19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a20:	75 23                	jne    a45 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 a22:	c7 45 f0 dc 0e 00 00 	movl   $0xedc,-0x10(%ebp)
 a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2c:	a3 e4 0e 00 00       	mov    %eax,0xee4
 a31:	a1 e4 0e 00 00       	mov    0xee4,%eax
 a36:	a3 dc 0e 00 00       	mov    %eax,0xedc
    base.s.size = 0;
 a3b:	c7 05 e0 0e 00 00 00 	movl   $0x0,0xee0
 a42:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a48:	8b 00                	mov    (%eax),%eax
 a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a50:	8b 40 04             	mov    0x4(%eax),%eax
 a53:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a56:	72 4d                	jb     aa5 <malloc+0xa4>
      if(p->s.size == nunits)
 a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5b:	8b 40 04             	mov    0x4(%eax),%eax
 a5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a61:	75 0c                	jne    a6f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a66:	8b 10                	mov    (%eax),%edx
 a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6b:	89 10                	mov    %edx,(%eax)
 a6d:	eb 26                	jmp    a95 <malloc+0x94>
      else {
        p->s.size -= nunits;
 a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a72:	8b 40 04             	mov    0x4(%eax),%eax
 a75:	89 c2                	mov    %eax,%edx
 a77:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	8b 40 04             	mov    0x4(%eax),%eax
 a86:	c1 e0 03             	shl    $0x3,%eax
 a89:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a92:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a98:	a3 e4 0e 00 00       	mov    %eax,0xee4
      return (void*)(p + 1);
 a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa0:	83 c0 08             	add    $0x8,%eax
 aa3:	eb 38                	jmp    add <malloc+0xdc>
    }
    if(p == freep)
 aa5:	a1 e4 0e 00 00       	mov    0xee4,%eax
 aaa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aad:	75 1b                	jne    aca <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 aaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab2:	89 04 24             	mov    %eax,(%esp)
 ab5:	e8 ef fe ff ff       	call   9a9 <morecore>
 aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 abd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac1:	75 07                	jne    aca <malloc+0xc9>
        return 0;
 ac3:	b8 00 00 00 00       	mov    $0x0,%eax
 ac8:	eb 13                	jmp    add <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad3:	8b 00                	mov    (%eax),%eax
 ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 ad8:	e9 70 ff ff ff       	jmp    a4d <malloc+0x4c>
}
 add:	c9                   	leave  
 ade:	c3                   	ret    
