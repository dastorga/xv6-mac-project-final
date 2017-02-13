
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
  // Operador de Dirección (&): Este nos permite acceder a la dirección de memoria de una variable.
  // Operador de Indirección (*): Además de que nos permite declarar un tipo de dato puntero, también nos permite ver el VALOR que está en la dirección asignada.
  int keyIndex; 
  char *index = 0; // declaro puntero
   6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  keyIndex = shm_create(); // creo el espacio de memoria a compartir
   d:	e8 a0 05 00 00       	call   5b2 <shm_create>
  12:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"*index = %d  \n" , *index ); 
  15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  18:	8a 00                	mov    (%eax),%al
  1a:	0f be c0             	movsbl %al,%eax
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	c7 44 24 04 68 0a 00 	movl   $0xa68,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 6d 06 00 00       	call   6a2 <printf>
  printf(1,"index= %d  \n" , index ); 
  35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 77 0a 00 	movl   $0xa77,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 52 06 00 00       	call   6a2 <printf>
  printf(1,"&index= %d  \n" , &index );
  50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	c7 44 24 04 84 0a 00 	movl   $0xa84,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 37 06 00 00       	call   6a2 <printf>
  printf(1,"Indice del arreglo= %d  \n" , keyIndex ); // primer indice del arreglo
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  72:	c7 44 24 04 92 0a 00 	movl   $0xa92,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 1c 06 00 00       	call   6a2 <printf>

  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  89:	89 44 24 04          	mov    %eax,0x4(%esp)
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	89 04 24             	mov    %eax,(%esp)
  93:	e8 2a 05 00 00       	call   5c2 <shm_get>
  98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"return shm_get %d  \n" , a);  // si retorna 0, pudo obtener el espacio de memoria asociado a el indice keyIndex
  9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  a2:	c7 44 24 04 ac 0a 00 	movl   $0xaac,0x4(%esp)
  a9:	00 
  aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b1:	e8 ec 05 00 00       	call   6a2 <printf>
}
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <test>:

void
test(){
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 28             	sub    $0x28,%esp
  int pid, keyIndex;
  char* index = 0;
  be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  keyIndex = shm_create(); //creo el espacio de memoria
  c5:	e8 e8 04 00 00       	call   5b2 <shm_create>
  ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"init index= %d  \n" , *index );
  cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  d0:	8a 00                	mov    (%eax),%al
  d2:	0f be c0             	movsbl %al,%eax
  d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  d9:	c7 44 24 04 c1 0a 00 	movl   $0xac1,0x4(%esp)
  e0:	00 
  e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e8:	e8 b5 05 00 00       	call   6a2 <printf>
  printf(1,"init index= %d  \n" , &index );
  ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  f4:	c7 44 24 04 c1 0a 00 	movl   $0xac1,0x4(%esp)
  fb:	00 
  fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 103:	e8 9a 05 00 00       	call   6a2 <printf>

  shm_get(keyIndex, &index); // tomo el espacio de memoria creado anteriormente
 108:	8d 45 ec             	lea    -0x14(%ebp),%eax
 10b:	89 44 24 04          	mov    %eax,0x4(%esp)
 10f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 112:	89 04 24             	mov    %eax,(%esp)
 115:	e8 a8 04 00 00       	call   5c2 <shm_get>

  pid = fork(); // creo un proceso (hijo) - printf(1,"pid= %d  \n" , pid );
 11a:	e8 ab 03 00 00       	call   4ca <fork>
 11f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *index = 3;
 122:	8b 45 ec             	mov    -0x14(%ebp),%eax
 125:	c6 00 03             	movb   $0x3,(%eax)

  printf(1,"father index= %d  \n" , &index );
 128:	8d 45 ec             	lea    -0x14(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	c7 44 24 04 d3 0a 00 	movl   $0xad3,0x4(%esp)
 136:	00 
 137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13e:	e8 5f 05 00 00       	call   6a2 <printf>
  printf(1,"father= %d  \n" , *index);
 143:	8b 45 ec             	mov    -0x14(%ebp),%eax
 146:	8a 00                	mov    (%eax),%al
 148:	0f be c0             	movsbl %al,%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	c7 44 24 04 e7 0a 00 	movl   $0xae7,0x4(%esp)
 156:	00 
 157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15e:	e8 3f 05 00 00       	call   6a2 <printf>

  printf(1,"****************\n");
 163:	c7 44 24 04 f5 0a 00 	movl   $0xaf5,0x4(%esp)
 16a:	00 
 16b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 172:	e8 2b 05 00 00       	call   6a2 <printf>

  if(pid == 0 ){
 177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17b:	75 4b                	jne    1c8 <test+0x110>
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
 17d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 180:	8a 00                	mov    (%eax),%al
 182:	0f be c0             	movsbl %al,%eax
 185:	89 44 24 08          	mov    %eax,0x8(%esp)
 189:	c7 44 24 04 07 0b 00 	movl   $0xb07,0x4(%esp)
 190:	00 
 191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 198:	e8 05 05 00 00       	call   6a2 <printf>
    *index = 4;
 19d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1a0:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
 1a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1a6:	8a 00                	mov    (%eax),%al
 1a8:	0f be c0             	movsbl %al,%eax
 1ab:	89 44 24 08          	mov    %eax,0x8(%esp)
 1af:	c7 44 24 04 07 0b 00 	movl   $0xb07,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 df 04 00 00       	call   6a2 <printf>
    //shm_close(keyIndex);
    exit();
 1c3:	e8 0a 03 00 00       	call   4d2 <exit>
  }
  printf(1,"exit *(index)= %d  \n" , *(index) );
 1c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1cb:	8a 00                	mov    (%eax),%al
 1cd:	0f be c0             	movsbl %al,%eax
 1d0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d4:	c7 44 24 04 1a 0b 00 	movl   $0xb1a,0x4(%esp)
 1db:	00 
 1dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e3:	e8 ba 04 00 00       	call   6a2 <printf>
  wait();
 1e8:	e8 ed 02 00 00       	call   4da <wait>
  printf(1,"exit &(index)= %d  \n" , &(index) );
 1ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
 1f0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f4:	c7 44 24 04 2f 0b 00 	movl   $0xb2f,0x4(%esp)
 1fb:	00 
 1fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 203:	e8 9a 04 00 00       	call   6a2 <printf>
  printf(1,"exit *(index)= %d  \n" , *(index) );
 208:	8b 45 ec             	mov    -0x14(%ebp),%eax
 20b:	8a 00                	mov    (%eax),%al
 20d:	0f be c0             	movsbl %al,%eax
 210:	89 44 24 08          	mov    %eax,0x8(%esp)
 214:	c7 44 24 04 1a 0b 00 	movl   $0xb1a,0x4(%esp)
 21b:	00 
 21c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 223:	e8 7a 04 00 00       	call   6a2 <printf>
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <test_1>:

// test shm_close
void
test_1(){
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 28             	sub    $0x28,%esp
  int keyIndex;
  // int keyIndex2;
  // int result;

  keyIndex = shm_create(); // creo el espacio de memoria y guardo el indice
 230:	e8 7d 03 00 00       	call   5b2 <shm_create>
 235:	89 45 f4             	mov    %eax,-0xc(%ebp)
  // keyIndex2 = shm_create();
  printf(1,"creo el espacio de memoria y guardo el indice %d  \n" , keyIndex );
 238:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23b:	89 44 24 08          	mov    %eax,0x8(%esp)
 23f:	c7 44 24 04 44 0b 00 	movl   $0xb44,0x4(%esp)
 246:	00 
 247:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 24e:	e8 4f 04 00 00       	call   6a2 <printf>

  // result = ; // libero el espacio de memoria obtenido anteriormente
  printf(1,"resultado del shm_close %d  \n" , shm_close(1));
 253:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25a:	e8 5b 03 00 00       	call   5ba <shm_close>
 25f:	89 44 24 08          	mov    %eax,0x8(%esp)
 263:	c7 44 24 04 78 0b 00 	movl   $0xb78,0x4(%esp)
 26a:	00 
 26b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 272:	e8 2b 04 00 00       	call   6a2 <printf>

}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <main>:


int
main(int argc, char *argv[]) {
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 e4 f0             	and    $0xfffffff0,%esp

  // test_0();
  // test();
  test_1();
 27f:	e8 a6 ff ff ff       	call   22a <test_1>
  // printf(1,"exit index= %d  \n" , *(index) );
  // wait();
  // printf(1,"exit index_2= %d  \n" , *(index_2) );
  // printf(1,"exit index= %d  \n" , &(index) );
  // printf(1,"exit index= %d  \n" , *(index) );
  exit();
 284:	e8 49 02 00 00       	call   4d2 <exit>

00000289 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	57                   	push   %edi
 28d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 28e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 291:	8b 55 10             	mov    0x10(%ebp),%edx
 294:	8b 45 0c             	mov    0xc(%ebp),%eax
 297:	89 cb                	mov    %ecx,%ebx
 299:	89 df                	mov    %ebx,%edi
 29b:	89 d1                	mov    %edx,%ecx
 29d:	fc                   	cld    
 29e:	f3 aa                	rep stos %al,%es:(%edi)
 2a0:	89 ca                	mov    %ecx,%edx
 2a2:	89 fb                	mov    %edi,%ebx
 2a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2a7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2aa:	5b                   	pop    %ebx
 2ab:	5f                   	pop    %edi
 2ac:	5d                   	pop    %ebp
 2ad:	c3                   	ret    

000002ae <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2ba:	90                   	nop
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	8a 10                	mov    (%eax),%dl
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	88 10                	mov    %dl,(%eax)
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	8a 00                	mov    (%eax),%al
 2ca:	84 c0                	test   %al,%al
 2cc:	0f 95 c0             	setne  %al
 2cf:	ff 45 08             	incl   0x8(%ebp)
 2d2:	ff 45 0c             	incl   0xc(%ebp)
 2d5:	84 c0                	test   %al,%al
 2d7:	75 e2                	jne    2bb <strcpy+0xd>
    ;
  return os;
 2d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e1:	eb 06                	jmp    2e9 <strcmp+0xb>
    p++, q++;
 2e3:	ff 45 08             	incl   0x8(%ebp)
 2e6:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	8a 00                	mov    (%eax),%al
 2ee:	84 c0                	test   %al,%al
 2f0:	74 0e                	je     300 <strcmp+0x22>
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	8a 10                	mov    (%eax),%dl
 2f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fa:	8a 00                	mov    (%eax),%al
 2fc:	38 c2                	cmp    %al,%dl
 2fe:	74 e3                	je     2e3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	8a 00                	mov    (%eax),%al
 305:	0f b6 d0             	movzbl %al,%edx
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	8a 00                	mov    (%eax),%al
 30d:	0f b6 c0             	movzbl %al,%eax
 310:	89 d1                	mov    %edx,%ecx
 312:	29 c1                	sub    %eax,%ecx
 314:	89 c8                	mov    %ecx,%eax
}
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    

00000318 <strlen>:

uint
strlen(char *s)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 31e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 325:	eb 03                	jmp    32a <strlen+0x12>
 327:	ff 45 fc             	incl   -0x4(%ebp)
 32a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	01 d0                	add    %edx,%eax
 332:	8a 00                	mov    (%eax),%al
 334:	84 c0                	test   %al,%al
 336:	75 ef                	jne    327 <strlen+0xf>
    ;
  return n;
 338:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 33b:	c9                   	leave  
 33c:	c3                   	ret    

0000033d <memset>:

void*
memset(void *dst, int c, uint n)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 343:	8b 45 10             	mov    0x10(%ebp),%eax
 346:	89 44 24 08          	mov    %eax,0x8(%esp)
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 44 24 04          	mov    %eax,0x4(%esp)
 351:	8b 45 08             	mov    0x8(%ebp),%eax
 354:	89 04 24             	mov    %eax,(%esp)
 357:	e8 2d ff ff ff       	call   289 <stosb>
  return dst;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <strchr>:

char*
strchr(const char *s, char c)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 04             	sub    $0x4,%esp
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 36d:	eb 12                	jmp    381 <strchr+0x20>
    if(*s == c)
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	8a 00                	mov    (%eax),%al
 374:	3a 45 fc             	cmp    -0x4(%ebp),%al
 377:	75 05                	jne    37e <strchr+0x1d>
      return (char*)s;
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	eb 11                	jmp    38f <strchr+0x2e>
  for(; *s; s++)
 37e:	ff 45 08             	incl   0x8(%ebp)
 381:	8b 45 08             	mov    0x8(%ebp),%eax
 384:	8a 00                	mov    (%eax),%al
 386:	84 c0                	test   %al,%al
 388:	75 e5                	jne    36f <strchr+0xe>
  return 0;
 38a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 38f:	c9                   	leave  
 390:	c3                   	ret    

00000391 <gets>:

char*
gets(char *buf, int max)
{
 391:	55                   	push   %ebp
 392:	89 e5                	mov    %esp,%ebp
 394:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 39e:	eb 42                	jmp    3e2 <gets+0x51>
    cc = read(0, &c, 1);
 3a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3a7:	00 
 3a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 3af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3b6:	e8 2f 01 00 00       	call   4ea <read>
 3bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3c2:	7e 29                	jle    3ed <gets+0x5c>
      break;
    buf[i++] = c;
 3c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	01 c2                	add    %eax,%edx
 3cc:	8a 45 ef             	mov    -0x11(%ebp),%al
 3cf:	88 02                	mov    %al,(%edx)
 3d1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 3d4:	8a 45 ef             	mov    -0x11(%ebp),%al
 3d7:	3c 0a                	cmp    $0xa,%al
 3d9:	74 13                	je     3ee <gets+0x5d>
 3db:	8a 45 ef             	mov    -0x11(%ebp),%al
 3de:	3c 0d                	cmp    $0xd,%al
 3e0:	74 0c                	je     3ee <gets+0x5d>
  for(i=0; i+1 < max; ){
 3e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e5:	40                   	inc    %eax
 3e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3e9:	7c b5                	jl     3a0 <gets+0xf>
 3eb:	eb 01                	jmp    3ee <gets+0x5d>
      break;
 3ed:	90                   	nop
      break;
  }
  buf[i] = '\0';
 3ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3fc:	c9                   	leave  
 3fd:	c3                   	ret    

000003fe <stat>:

int
stat(char *n, struct stat *st)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 404:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 40b:	00 
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	89 04 24             	mov    %eax,(%esp)
 412:	e8 fb 00 00 00       	call   512 <open>
 417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 41a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 41e:	79 07                	jns    427 <stat+0x29>
    return -1;
 420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 425:	eb 23                	jmp    44a <stat+0x4c>
  r = fstat(fd, st);
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	89 44 24 04          	mov    %eax,0x4(%esp)
 42e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 431:	89 04 24             	mov    %eax,(%esp)
 434:	e8 f1 00 00 00       	call   52a <fstat>
 439:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 43c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43f:	89 04 24             	mov    %eax,(%esp)
 442:	e8 b3 00 00 00       	call   4fa <close>
  return r;
 447:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 44a:	c9                   	leave  
 44b:	c3                   	ret    

0000044c <atoi>:

int
atoi(const char *s)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 452:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 459:	eb 21                	jmp    47c <atoi+0x30>
    n = n*10 + *s++ - '0';
 45b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 45e:	89 d0                	mov    %edx,%eax
 460:	c1 e0 02             	shl    $0x2,%eax
 463:	01 d0                	add    %edx,%eax
 465:	d1 e0                	shl    %eax
 467:	89 c2                	mov    %eax,%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	8a 00                	mov    (%eax),%al
 46e:	0f be c0             	movsbl %al,%eax
 471:	01 d0                	add    %edx,%eax
 473:	83 e8 30             	sub    $0x30,%eax
 476:	89 45 fc             	mov    %eax,-0x4(%ebp)
 479:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	8a 00                	mov    (%eax),%al
 481:	3c 2f                	cmp    $0x2f,%al
 483:	7e 09                	jle    48e <atoi+0x42>
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	8a 00                	mov    (%eax),%al
 48a:	3c 39                	cmp    $0x39,%al
 48c:	7e cd                	jle    45b <atoi+0xf>
  return n;
 48e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 491:	c9                   	leave  
 492:	c3                   	ret    

00000493 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 493:	55                   	push   %ebp
 494:	89 e5                	mov    %esp,%ebp
 496:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 49f:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4a5:	eb 10                	jmp    4b7 <memmove+0x24>
    *dst++ = *src++;
 4a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4aa:	8a 10                	mov    (%eax),%dl
 4ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4af:	88 10                	mov    %dl,(%eax)
 4b1:	ff 45 fc             	incl   -0x4(%ebp)
 4b4:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 4b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4bb:	0f 9f c0             	setg   %al
 4be:	ff 4d 10             	decl   0x10(%ebp)
 4c1:	84 c0                	test   %al,%al
 4c3:	75 e2                	jne    4a7 <memmove+0x14>
  return vdst;
 4c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4c8:	c9                   	leave  
 4c9:	c3                   	ret    

000004ca <fork>:
 4ca:	b8 01 00 00 00       	mov    $0x1,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <exit>:
 4d2:	b8 02 00 00 00       	mov    $0x2,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <wait>:
 4da:	b8 03 00 00 00       	mov    $0x3,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <pipe>:
 4e2:	b8 04 00 00 00       	mov    $0x4,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <read>:
 4ea:	b8 05 00 00 00       	mov    $0x5,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <write>:
 4f2:	b8 10 00 00 00       	mov    $0x10,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <close>:
 4fa:	b8 15 00 00 00       	mov    $0x15,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <kill>:
 502:	b8 06 00 00 00       	mov    $0x6,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <exec>:
 50a:	b8 07 00 00 00       	mov    $0x7,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <open>:
 512:	b8 0f 00 00 00       	mov    $0xf,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <mknod>:
 51a:	b8 11 00 00 00       	mov    $0x11,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <unlink>:
 522:	b8 12 00 00 00       	mov    $0x12,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <fstat>:
 52a:	b8 08 00 00 00       	mov    $0x8,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <link>:
 532:	b8 13 00 00 00       	mov    $0x13,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <mkdir>:
 53a:	b8 14 00 00 00       	mov    $0x14,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <chdir>:
 542:	b8 09 00 00 00       	mov    $0x9,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <dup>:
 54a:	b8 0a 00 00 00       	mov    $0xa,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <getpid>:
 552:	b8 0b 00 00 00       	mov    $0xb,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <sbrk>:
 55a:	b8 0c 00 00 00       	mov    $0xc,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <sleep>:
 562:	b8 0d 00 00 00       	mov    $0xd,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <uptime>:
 56a:	b8 0e 00 00 00       	mov    $0xe,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <lseek>:
 572:	b8 16 00 00 00       	mov    $0x16,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <isatty>:
 57a:	b8 17 00 00 00       	mov    $0x17,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <procstat>:
 582:	b8 18 00 00 00       	mov    $0x18,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <set_priority>:
 58a:	b8 19 00 00 00       	mov    $0x19,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <semget>:
 592:	b8 1a 00 00 00       	mov    $0x1a,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <semfree>:
 59a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <semdown>:
 5a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <semup>:
 5aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <shm_create>:
 5b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <shm_close>:
 5ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <shm_get>:
 5c2:	b8 20 00 00 00       	mov    $0x20,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5ca:	55                   	push   %ebp
 5cb:	89 e5                	mov    %esp,%ebp
 5cd:	83 ec 28             	sub    $0x28,%esp
 5d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5dd:	00 
 5de:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	89 04 24             	mov    %eax,(%esp)
 5eb:	e8 02 ff ff ff       	call   4f2 <write>
}
 5f0:	c9                   	leave  
 5f1:	c3                   	ret    

000005f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
 5f5:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 603:	74 17                	je     61c <printint+0x2a>
 605:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 609:	79 11                	jns    61c <printint+0x2a>
    neg = 1;
 60b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 612:	8b 45 0c             	mov    0xc(%ebp),%eax
 615:	f7 d8                	neg    %eax
 617:	89 45 ec             	mov    %eax,-0x14(%ebp)
 61a:	eb 06                	jmp    622 <printint+0x30>
  } else {
    x = xx;
 61c:	8b 45 0c             	mov    0xc(%ebp),%eax
 61f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 622:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 629:	8b 4d 10             	mov    0x10(%ebp),%ecx
 62c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 62f:	ba 00 00 00 00       	mov    $0x0,%edx
 634:	f7 f1                	div    %ecx
 636:	89 d0                	mov    %edx,%eax
 638:	8a 80 3c 0e 00 00    	mov    0xe3c(%eax),%al
 63e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 641:	8b 55 f4             	mov    -0xc(%ebp),%edx
 644:	01 ca                	add    %ecx,%edx
 646:	88 02                	mov    %al,(%edx)
 648:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 64b:	8b 55 10             	mov    0x10(%ebp),%edx
 64e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 651:	8b 45 ec             	mov    -0x14(%ebp),%eax
 654:	ba 00 00 00 00       	mov    $0x0,%edx
 659:	f7 75 d4             	divl   -0x2c(%ebp)
 65c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 65f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 663:	75 c4                	jne    629 <printint+0x37>
  if(neg)
 665:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 669:	74 2c                	je     697 <printint+0xa5>
    buf[i++] = '-';
 66b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 66e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 671:	01 d0                	add    %edx,%eax
 673:	c6 00 2d             	movb   $0x2d,(%eax)
 676:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 679:	eb 1c                	jmp    697 <printint+0xa5>
    putc(fd, buf[i]);
 67b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 67e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 681:	01 d0                	add    %edx,%eax
 683:	8a 00                	mov    (%eax),%al
 685:	0f be c0             	movsbl %al,%eax
 688:	89 44 24 04          	mov    %eax,0x4(%esp)
 68c:	8b 45 08             	mov    0x8(%ebp),%eax
 68f:	89 04 24             	mov    %eax,(%esp)
 692:	e8 33 ff ff ff       	call   5ca <putc>
  while(--i >= 0)
 697:	ff 4d f4             	decl   -0xc(%ebp)
 69a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69e:	79 db                	jns    67b <printint+0x89>
}
 6a0:	c9                   	leave  
 6a1:	c3                   	ret    

000006a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6a2:	55                   	push   %ebp
 6a3:	89 e5                	mov    %esp,%ebp
 6a5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6af:	8d 45 0c             	lea    0xc(%ebp),%eax
 6b2:	83 c0 04             	add    $0x4,%eax
 6b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6bf:	e9 78 01 00 00       	jmp    83c <printf+0x19a>
    c = fmt[i] & 0xff;
 6c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ca:	01 d0                	add    %edx,%eax
 6cc:	8a 00                	mov    (%eax),%al
 6ce:	0f be c0             	movsbl %al,%eax
 6d1:	25 ff 00 00 00       	and    $0xff,%eax
 6d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6dd:	75 2c                	jne    70b <printf+0x69>
      if(c == '%'){
 6df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e3:	75 0c                	jne    6f1 <printf+0x4f>
        state = '%';
 6e5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ec:	e9 48 01 00 00       	jmp    839 <printf+0x197>
      } else {
        putc(fd, c);
 6f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	89 04 24             	mov    %eax,(%esp)
 701:	e8 c4 fe ff ff       	call   5ca <putc>
 706:	e9 2e 01 00 00       	jmp    839 <printf+0x197>
      }
    } else if(state == '%'){
 70b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 70f:	0f 85 24 01 00 00    	jne    839 <printf+0x197>
      if(c == 'd'){
 715:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 719:	75 2d                	jne    748 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 71b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 727:	00 
 728:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 72f:	00 
 730:	89 44 24 04          	mov    %eax,0x4(%esp)
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	89 04 24             	mov    %eax,(%esp)
 73a:	e8 b3 fe ff ff       	call   5f2 <printint>
        ap++;
 73f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 743:	e9 ea 00 00 00       	jmp    832 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 748:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 74c:	74 06                	je     754 <printf+0xb2>
 74e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 752:	75 2d                	jne    781 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 754:	8b 45 e8             	mov    -0x18(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 760:	00 
 761:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 768:	00 
 769:	89 44 24 04          	mov    %eax,0x4(%esp)
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	89 04 24             	mov    %eax,(%esp)
 773:	e8 7a fe ff ff       	call   5f2 <printint>
        ap++;
 778:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77c:	e9 b1 00 00 00       	jmp    832 <printf+0x190>
      } else if(c == 's'){
 781:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 785:	75 43                	jne    7ca <printf+0x128>
        s = (char*)*ap;
 787:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78a:	8b 00                	mov    (%eax),%eax
 78c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 78f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 793:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 797:	75 25                	jne    7be <printf+0x11c>
          s = "(null)";
 799:	c7 45 f4 96 0b 00 00 	movl   $0xb96,-0xc(%ebp)
        while(*s != 0){
 7a0:	eb 1c                	jmp    7be <printf+0x11c>
          putc(fd, *s);
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	8a 00                	mov    (%eax),%al
 7a7:	0f be c0             	movsbl %al,%eax
 7aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	89 04 24             	mov    %eax,(%esp)
 7b4:	e8 11 fe ff ff       	call   5ca <putc>
          s++;
 7b9:	ff 45 f4             	incl   -0xc(%ebp)
 7bc:	eb 01                	jmp    7bf <printf+0x11d>
        while(*s != 0){
 7be:	90                   	nop
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	8a 00                	mov    (%eax),%al
 7c4:	84 c0                	test   %al,%al
 7c6:	75 da                	jne    7a2 <printf+0x100>
 7c8:	eb 68                	jmp    832 <printf+0x190>
        }
      } else if(c == 'c'){
 7ca:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ce:	75 1d                	jne    7ed <printf+0x14b>
        putc(fd, *ap);
 7d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	0f be c0             	movsbl %al,%eax
 7d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
 7df:	89 04 24             	mov    %eax,(%esp)
 7e2:	e8 e3 fd ff ff       	call   5ca <putc>
        ap++;
 7e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7eb:	eb 45                	jmp    832 <printf+0x190>
      } else if(c == '%'){
 7ed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f1:	75 17                	jne    80a <printf+0x168>
        putc(fd, c);
 7f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f6:	0f be c0             	movsbl %al,%eax
 7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fd:	8b 45 08             	mov    0x8(%ebp),%eax
 800:	89 04 24             	mov    %eax,(%esp)
 803:	e8 c2 fd ff ff       	call   5ca <putc>
 808:	eb 28                	jmp    832 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 80a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 811:	00 
 812:	8b 45 08             	mov    0x8(%ebp),%eax
 815:	89 04 24             	mov    %eax,(%esp)
 818:	e8 ad fd ff ff       	call   5ca <putc>
        putc(fd, c);
 81d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 820:	0f be c0             	movsbl %al,%eax
 823:	89 44 24 04          	mov    %eax,0x4(%esp)
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	89 04 24             	mov    %eax,(%esp)
 82d:	e8 98 fd ff ff       	call   5ca <putc>
      }
      state = 0;
 832:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 839:	ff 45 f0             	incl   -0x10(%ebp)
 83c:	8b 55 0c             	mov    0xc(%ebp),%edx
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	01 d0                	add    %edx,%eax
 844:	8a 00                	mov    (%eax),%al
 846:	84 c0                	test   %al,%al
 848:	0f 85 76 fe ff ff    	jne    6c4 <printf+0x22>
    }
  }
}
 84e:	c9                   	leave  
 84f:	c3                   	ret    

00000850 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 856:	8b 45 08             	mov    0x8(%ebp),%eax
 859:	83 e8 08             	sub    $0x8,%eax
 85c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85f:	a1 58 0e 00 00       	mov    0xe58,%eax
 864:	89 45 fc             	mov    %eax,-0x4(%ebp)
 867:	eb 24                	jmp    88d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 869:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 871:	77 12                	ja     885 <free+0x35>
 873:	8b 45 f8             	mov    -0x8(%ebp),%eax
 876:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 879:	77 24                	ja     89f <free+0x4f>
 87b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87e:	8b 00                	mov    (%eax),%eax
 880:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 883:	77 1a                	ja     89f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 885:	8b 45 fc             	mov    -0x4(%ebp),%eax
 888:	8b 00                	mov    (%eax),%eax
 88a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 88d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 890:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 893:	76 d4                	jbe    869 <free+0x19>
 895:	8b 45 fc             	mov    -0x4(%ebp),%eax
 898:	8b 00                	mov    (%eax),%eax
 89a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89d:	76 ca                	jbe    869 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 89f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a2:	8b 40 04             	mov    0x4(%eax),%eax
 8a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8af:	01 c2                	add    %eax,%edx
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	8b 00                	mov    (%eax),%eax
 8b6:	39 c2                	cmp    %eax,%edx
 8b8:	75 24                	jne    8de <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bd:	8b 50 04             	mov    0x4(%eax),%edx
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	8b 40 04             	mov    0x4(%eax),%eax
 8c8:	01 c2                	add    %eax,%edx
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	8b 10                	mov    (%eax),%edx
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	89 10                	mov    %edx,(%eax)
 8dc:	eb 0a                	jmp    8e8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 10                	mov    (%eax),%edx
 8e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8eb:	8b 40 04             	mov    0x4(%eax),%eax
 8ee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f8:	01 d0                	add    %edx,%eax
 8fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8fd:	75 20                	jne    91f <free+0xcf>
    p->s.size += bp->s.size;
 8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 902:	8b 50 04             	mov    0x4(%eax),%edx
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	8b 40 04             	mov    0x4(%eax),%eax
 90b:	01 c2                	add    %eax,%edx
 90d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 910:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	8b 10                	mov    (%eax),%edx
 918:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91b:	89 10                	mov    %edx,(%eax)
 91d:	eb 08                	jmp    927 <free+0xd7>
  } else
    p->s.ptr = bp;
 91f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 922:	8b 55 f8             	mov    -0x8(%ebp),%edx
 925:	89 10                	mov    %edx,(%eax)
  freep = p;
 927:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92a:	a3 58 0e 00 00       	mov    %eax,0xe58
}
 92f:	c9                   	leave  
 930:	c3                   	ret    

00000931 <morecore>:

static Header*
morecore(uint nu)
{
 931:	55                   	push   %ebp
 932:	89 e5                	mov    %esp,%ebp
 934:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 937:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 93e:	77 07                	ja     947 <morecore+0x16>
    nu = 4096;
 940:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 947:	8b 45 08             	mov    0x8(%ebp),%eax
 94a:	c1 e0 03             	shl    $0x3,%eax
 94d:	89 04 24             	mov    %eax,(%esp)
 950:	e8 05 fc ff ff       	call   55a <sbrk>
 955:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 958:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 95c:	75 07                	jne    965 <morecore+0x34>
    return 0;
 95e:	b8 00 00 00 00       	mov    $0x0,%eax
 963:	eb 22                	jmp    987 <morecore+0x56>
  hp = (Header*)p;
 965:	8b 45 f4             	mov    -0xc(%ebp),%eax
 968:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 96b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96e:	8b 55 08             	mov    0x8(%ebp),%edx
 971:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 974:	8b 45 f0             	mov    -0x10(%ebp),%eax
 977:	83 c0 08             	add    $0x8,%eax
 97a:	89 04 24             	mov    %eax,(%esp)
 97d:	e8 ce fe ff ff       	call   850 <free>
  return freep;
 982:	a1 58 0e 00 00       	mov    0xe58,%eax
}
 987:	c9                   	leave  
 988:	c3                   	ret    

00000989 <malloc>:

void*
malloc(uint nbytes)
{
 989:	55                   	push   %ebp
 98a:	89 e5                	mov    %esp,%ebp
 98c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 98f:	8b 45 08             	mov    0x8(%ebp),%eax
 992:	83 c0 07             	add    $0x7,%eax
 995:	c1 e8 03             	shr    $0x3,%eax
 998:	40                   	inc    %eax
 999:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 99c:	a1 58 0e 00 00       	mov    0xe58,%eax
 9a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a8:	75 23                	jne    9cd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 9aa:	c7 45 f0 50 0e 00 00 	movl   $0xe50,-0x10(%ebp)
 9b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b4:	a3 58 0e 00 00       	mov    %eax,0xe58
 9b9:	a1 58 0e 00 00       	mov    0xe58,%eax
 9be:	a3 50 0e 00 00       	mov    %eax,0xe50
    base.s.size = 0;
 9c3:	c7 05 54 0e 00 00 00 	movl   $0x0,0xe54
 9ca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d0:	8b 00                	mov    (%eax),%eax
 9d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d8:	8b 40 04             	mov    0x4(%eax),%eax
 9db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9de:	72 4d                	jb     a2d <malloc+0xa4>
      if(p->s.size == nunits)
 9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e3:	8b 40 04             	mov    0x4(%eax),%eax
 9e6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e9:	75 0c                	jne    9f7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 9eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ee:	8b 10                	mov    (%eax),%edx
 9f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f3:	89 10                	mov    %edx,(%eax)
 9f5:	eb 26                	jmp    a1d <malloc+0x94>
      else {
        p->s.size -= nunits;
 9f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fa:	8b 40 04             	mov    0x4(%eax),%eax
 9fd:	89 c2                	mov    %eax,%edx
 9ff:	2b 55 ec             	sub    -0x14(%ebp),%edx
 a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a05:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0b:	8b 40 04             	mov    0x4(%eax),%eax
 a0e:	c1 e0 03             	shl    $0x3,%eax
 a11:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a1a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a20:	a3 58 0e 00 00       	mov    %eax,0xe58
      return (void*)(p + 1);
 a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a28:	83 c0 08             	add    $0x8,%eax
 a2b:	eb 38                	jmp    a65 <malloc+0xdc>
    }
    if(p == freep)
 a2d:	a1 58 0e 00 00       	mov    0xe58,%eax
 a32:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a35:	75 1b                	jne    a52 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a3a:	89 04 24             	mov    %eax,(%esp)
 a3d:	e8 ef fe ff ff       	call   931 <morecore>
 a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a49:	75 07                	jne    a52 <malloc+0xc9>
        return 0;
 a4b:	b8 00 00 00 00       	mov    $0x0,%eax
 a50:	eb 13                	jmp    a65 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5b:	8b 00                	mov    (%eax),%eax
 a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a60:	e9 70 ff ff ff       	jmp    9d5 <malloc+0x4c>
}
 a65:	c9                   	leave  
 a66:	c3                   	ret    
