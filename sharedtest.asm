
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
   d:	e8 51 05 00 00       	call   563 <shm_create>
  12:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"*index = %d  \n" , *index ); 
  15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  18:	8a 00                	mov    (%eax),%al
  1a:	0f be c0             	movsbl %al,%eax
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	c7 44 24 04 18 0a 00 	movl   $0xa18,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 1e 06 00 00       	call   653 <printf>
  printf(1,"index= %d  \n" , index ); 
  35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 27 0a 00 	movl   $0xa27,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 03 06 00 00       	call   653 <printf>
  printf(1,"&index= %d  \n" , &index );
  50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	c7 44 24 04 34 0a 00 	movl   $0xa34,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 e8 05 00 00       	call   653 <printf>
  printf(1,"Indice del arreglo= %d  \n" , keyIndex ); // primer indice del arreglo
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  72:	c7 44 24 04 42 0a 00 	movl   $0xa42,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 cd 05 00 00       	call   653 <printf>

  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  89:	89 44 24 04          	mov    %eax,0x4(%esp)
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	89 04 24             	mov    %eax,(%esp)
  93:	e8 db 04 00 00       	call   573 <shm_get>
  98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"return shm_get %d  \n" , a);  // si retorna 0, pudo obtener el espacio de memoria asociado a el indice keyIndex
  9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  a2:	c7 44 24 04 5c 0a 00 	movl   $0xa5c,0x4(%esp)
  a9:	00 
  aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b1:	e8 9d 05 00 00       	call   653 <printf>
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
  c5:	e8 99 04 00 00       	call   563 <shm_create>
  ca:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"init index= %d  \n" , *index );
  cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  d0:	8a 00                	mov    (%eax),%al
  d2:	0f be c0             	movsbl %al,%eax
  d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  d9:	c7 44 24 04 71 0a 00 	movl   $0xa71,0x4(%esp)
  e0:	00 
  e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e8:	e8 66 05 00 00       	call   653 <printf>
  printf(1,"init index= %d  \n" , &index );
  ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
  f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  f4:	c7 44 24 04 71 0a 00 	movl   $0xa71,0x4(%esp)
  fb:	00 
  fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 103:	e8 4b 05 00 00       	call   653 <printf>

  shm_get(keyIndex, &index); // tomo el espacio de memoria creado anteriormente
 108:	8d 45 ec             	lea    -0x14(%ebp),%eax
 10b:	89 44 24 04          	mov    %eax,0x4(%esp)
 10f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 112:	89 04 24             	mov    %eax,(%esp)
 115:	e8 59 04 00 00       	call   573 <shm_get>

  pid = fork(); // creo un proceso (hijo) - printf(1,"pid= %d  \n" , pid );
 11a:	e8 5c 03 00 00       	call   47b <fork>
 11f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *index = 3;
 122:	8b 45 ec             	mov    -0x14(%ebp),%eax
 125:	c6 00 03             	movb   $0x3,(%eax)

  printf(1,"father index= %d  \n" , &index );
 128:	8d 45 ec             	lea    -0x14(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	c7 44 24 04 83 0a 00 	movl   $0xa83,0x4(%esp)
 136:	00 
 137:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13e:	e8 10 05 00 00       	call   653 <printf>
  printf(1,"father= %d  \n" , *index);
 143:	8b 45 ec             	mov    -0x14(%ebp),%eax
 146:	8a 00                	mov    (%eax),%al
 148:	0f be c0             	movsbl %al,%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	c7 44 24 04 97 0a 00 	movl   $0xa97,0x4(%esp)
 156:	00 
 157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15e:	e8 f0 04 00 00       	call   653 <printf>

  printf(1,"****************\n");
 163:	c7 44 24 04 a5 0a 00 	movl   $0xaa5,0x4(%esp)
 16a:	00 
 16b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 172:	e8 dc 04 00 00       	call   653 <printf>

  if(pid == 0 ){
 177:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17b:	75 4b                	jne    1c8 <test+0x110>
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
 17d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 180:	8a 00                	mov    (%eax),%al
 182:	0f be c0             	movsbl %al,%eax
 185:	89 44 24 08          	mov    %eax,0x8(%esp)
 189:	c7 44 24 04 b7 0a 00 	movl   $0xab7,0x4(%esp)
 190:	00 
 191:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 198:	e8 b6 04 00 00       	call   653 <printf>
    *index = 4;
 19d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1a0:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
 1a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1a6:	8a 00                	mov    (%eax),%al
 1a8:	0f be c0             	movsbl %al,%eax
 1ab:	89 44 24 08          	mov    %eax,0x8(%esp)
 1af:	c7 44 24 04 b7 0a 00 	movl   $0xab7,0x4(%esp)
 1b6:	00 
 1b7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1be:	e8 90 04 00 00       	call   653 <printf>
    //shm_close(keyIndex);
    exit();
 1c3:	e8 bb 02 00 00       	call   483 <exit>
  }
  printf(1,"exit *(index)= %d  \n" , *(index) );
 1c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1cb:	8a 00                	mov    (%eax),%al
 1cd:	0f be c0             	movsbl %al,%eax
 1d0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d4:	c7 44 24 04 ca 0a 00 	movl   $0xaca,0x4(%esp)
 1db:	00 
 1dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e3:	e8 6b 04 00 00       	call   653 <printf>
  wait();
 1e8:	e8 9e 02 00 00       	call   48b <wait>
  printf(1,"exit &(index)= %d  \n" , &(index) );
 1ed:	8d 45 ec             	lea    -0x14(%ebp),%eax
 1f0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f4:	c7 44 24 04 df 0a 00 	movl   $0xadf,0x4(%esp)
 1fb:	00 
 1fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 203:	e8 4b 04 00 00       	call   653 <printf>
  printf(1,"exit *(index)= %d  \n" , *(index) );
 208:	8b 45 ec             	mov    -0x14(%ebp),%eax
 20b:	8a 00                	mov    (%eax),%al
 20d:	0f be c0             	movsbl %al,%eax
 210:	89 44 24 08          	mov    %eax,0x8(%esp)
 214:	c7 44 24 04 ca 0a 00 	movl   $0xaca,0x4(%esp)
 21b:	00 
 21c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 223:	e8 2b 04 00 00       	call   653 <printf>
  
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <main>:


int
main(int argc, char *argv[]) {
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 e4 f0             	and    $0xfffffff0,%esp

  //test_0();
  test();
 230:	e8 83 fe ff ff       	call   b8 <test>
  // printf(1,"exit index= %d  \n" , *(index) );
  // wait();
  // printf(1,"exit index_2= %d  \n" , *(index_2) );
  // printf(1,"exit index= %d  \n" , &(index) );
  // printf(1,"exit index= %d  \n" , *(index) );
  exit();
 235:	e8 49 02 00 00       	call   483 <exit>

0000023a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	57                   	push   %edi
 23e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 23f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 242:	8b 55 10             	mov    0x10(%ebp),%edx
 245:	8b 45 0c             	mov    0xc(%ebp),%eax
 248:	89 cb                	mov    %ecx,%ebx
 24a:	89 df                	mov    %ebx,%edi
 24c:	89 d1                	mov    %edx,%ecx
 24e:	fc                   	cld    
 24f:	f3 aa                	rep stos %al,%es:(%edi)
 251:	89 ca                	mov    %ecx,%edx
 253:	89 fb                	mov    %edi,%ebx
 255:	89 5d 08             	mov    %ebx,0x8(%ebp)
 258:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 25b:	5b                   	pop    %ebx
 25c:	5f                   	pop    %edi
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret    

0000025f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
 262:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 26b:	90                   	nop
 26c:	8b 45 0c             	mov    0xc(%ebp),%eax
 26f:	8a 10                	mov    (%eax),%dl
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	88 10                	mov    %dl,(%eax)
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	8a 00                	mov    (%eax),%al
 27b:	84 c0                	test   %al,%al
 27d:	0f 95 c0             	setne  %al
 280:	ff 45 08             	incl   0x8(%ebp)
 283:	ff 45 0c             	incl   0xc(%ebp)
 286:	84 c0                	test   %al,%al
 288:	75 e2                	jne    26c <strcpy+0xd>
    ;
  return os;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 292:	eb 06                	jmp    29a <strcmp+0xb>
    p++, q++;
 294:	ff 45 08             	incl   0x8(%ebp)
 297:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	8a 00                	mov    (%eax),%al
 29f:	84 c0                	test   %al,%al
 2a1:	74 0e                	je     2b1 <strcmp+0x22>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8a 10                	mov    (%eax),%dl
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	8a 00                	mov    (%eax),%al
 2ad:	38 c2                	cmp    %al,%dl
 2af:	74 e3                	je     294 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	8a 00                	mov    (%eax),%al
 2b6:	0f b6 d0             	movzbl %al,%edx
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	8a 00                	mov    (%eax),%al
 2be:	0f b6 c0             	movzbl %al,%eax
 2c1:	89 d1                	mov    %edx,%ecx
 2c3:	29 c1                	sub    %eax,%ecx
 2c5:	89 c8                	mov    %ecx,%eax
}
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret    

000002c9 <strlen>:

uint
strlen(char *s)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2d6:	eb 03                	jmp    2db <strlen+0x12>
 2d8:	ff 45 fc             	incl   -0x4(%ebp)
 2db:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	01 d0                	add    %edx,%eax
 2e3:	8a 00                	mov    (%eax),%al
 2e5:	84 c0                	test   %al,%al
 2e7:	75 ef                	jne    2d8 <strlen+0xf>
    ;
  return n;
 2e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2f4:	8b 45 10             	mov    0x10(%ebp),%eax
 2f7:	89 44 24 08          	mov    %eax,0x8(%esp)
 2fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	89 04 24             	mov    %eax,(%esp)
 308:	e8 2d ff ff ff       	call   23a <stosb>
  return dst;
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <strchr>:

char*
strchr(const char *s, char c)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 04             	sub    $0x4,%esp
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 31e:	eb 12                	jmp    332 <strchr+0x20>
    if(*s == c)
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	8a 00                	mov    (%eax),%al
 325:	3a 45 fc             	cmp    -0x4(%ebp),%al
 328:	75 05                	jne    32f <strchr+0x1d>
      return (char*)s;
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	eb 11                	jmp    340 <strchr+0x2e>
  for(; *s; s++)
 32f:	ff 45 08             	incl   0x8(%ebp)
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	8a 00                	mov    (%eax),%al
 337:	84 c0                	test   %al,%al
 339:	75 e5                	jne    320 <strchr+0xe>
  return 0;
 33b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 340:	c9                   	leave  
 341:	c3                   	ret    

00000342 <gets>:

char*
gets(char *buf, int max)
{
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
 345:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 34f:	eb 42                	jmp    393 <gets+0x51>
    cc = read(0, &c, 1);
 351:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 358:	00 
 359:	8d 45 ef             	lea    -0x11(%ebp),%eax
 35c:	89 44 24 04          	mov    %eax,0x4(%esp)
 360:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 367:	e8 2f 01 00 00       	call   49b <read>
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 36f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 373:	7e 29                	jle    39e <gets+0x5c>
      break;
    buf[i++] = c;
 375:	8b 55 f4             	mov    -0xc(%ebp),%edx
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	01 c2                	add    %eax,%edx
 37d:	8a 45 ef             	mov    -0x11(%ebp),%al
 380:	88 02                	mov    %al,(%edx)
 382:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 385:	8a 45 ef             	mov    -0x11(%ebp),%al
 388:	3c 0a                	cmp    $0xa,%al
 38a:	74 13                	je     39f <gets+0x5d>
 38c:	8a 45 ef             	mov    -0x11(%ebp),%al
 38f:	3c 0d                	cmp    $0xd,%al
 391:	74 0c                	je     39f <gets+0x5d>
  for(i=0; i+1 < max; ){
 393:	8b 45 f4             	mov    -0xc(%ebp),%eax
 396:	40                   	inc    %eax
 397:	3b 45 0c             	cmp    0xc(%ebp),%eax
 39a:	7c b5                	jl     351 <gets+0xf>
 39c:	eb 01                	jmp    39f <gets+0x5d>
      break;
 39e:	90                   	nop
      break;
  }
  buf[i] = '\0';
 39f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	01 d0                	add    %edx,%eax
 3a7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <stat>:

int
stat(char *n, struct stat *st)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3bc:	00 
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	89 04 24             	mov    %eax,(%esp)
 3c3:	e8 fb 00 00 00       	call   4c3 <open>
 3c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3cf:	79 07                	jns    3d8 <stat+0x29>
    return -1;
 3d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d6:	eb 23                	jmp    3fb <stat+0x4c>
  r = fstat(fd, st);
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	89 44 24 04          	mov    %eax,0x4(%esp)
 3df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e2:	89 04 24             	mov    %eax,(%esp)
 3e5:	e8 f1 00 00 00       	call   4db <fstat>
 3ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f0:	89 04 24             	mov    %eax,(%esp)
 3f3:	e8 b3 00 00 00       	call   4ab <close>
  return r;
 3f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3fb:	c9                   	leave  
 3fc:	c3                   	ret    

000003fd <atoi>:

int
atoi(const char *s)
{
 3fd:	55                   	push   %ebp
 3fe:	89 e5                	mov    %esp,%ebp
 400:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 403:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 40a:	eb 21                	jmp    42d <atoi+0x30>
    n = n*10 + *s++ - '0';
 40c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40f:	89 d0                	mov    %edx,%eax
 411:	c1 e0 02             	shl    $0x2,%eax
 414:	01 d0                	add    %edx,%eax
 416:	d1 e0                	shl    %eax
 418:	89 c2                	mov    %eax,%edx
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	8a 00                	mov    (%eax),%al
 41f:	0f be c0             	movsbl %al,%eax
 422:	01 d0                	add    %edx,%eax
 424:	83 e8 30             	sub    $0x30,%eax
 427:	89 45 fc             	mov    %eax,-0x4(%ebp)
 42a:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 42d:	8b 45 08             	mov    0x8(%ebp),%eax
 430:	8a 00                	mov    (%eax),%al
 432:	3c 2f                	cmp    $0x2f,%al
 434:	7e 09                	jle    43f <atoi+0x42>
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	8a 00                	mov    (%eax),%al
 43b:	3c 39                	cmp    $0x39,%al
 43d:	7e cd                	jle    40c <atoi+0xf>
  return n;
 43f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 442:	c9                   	leave  
 443:	c3                   	ret    

00000444 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 456:	eb 10                	jmp    468 <memmove+0x24>
    *dst++ = *src++;
 458:	8b 45 f8             	mov    -0x8(%ebp),%eax
 45b:	8a 10                	mov    (%eax),%dl
 45d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 460:	88 10                	mov    %dl,(%eax)
 462:	ff 45 fc             	incl   -0x4(%ebp)
 465:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 468:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 46c:	0f 9f c0             	setg   %al
 46f:	ff 4d 10             	decl   0x10(%ebp)
 472:	84 c0                	test   %al,%al
 474:	75 e2                	jne    458 <memmove+0x14>
  return vdst;
 476:	8b 45 08             	mov    0x8(%ebp),%eax
}
 479:	c9                   	leave  
 47a:	c3                   	ret    

0000047b <fork>:
 47b:	b8 01 00 00 00       	mov    $0x1,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <exit>:
 483:	b8 02 00 00 00       	mov    $0x2,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <wait>:
 48b:	b8 03 00 00 00       	mov    $0x3,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <pipe>:
 493:	b8 04 00 00 00       	mov    $0x4,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <read>:
 49b:	b8 05 00 00 00       	mov    $0x5,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <write>:
 4a3:	b8 10 00 00 00       	mov    $0x10,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <close>:
 4ab:	b8 15 00 00 00       	mov    $0x15,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <kill>:
 4b3:	b8 06 00 00 00       	mov    $0x6,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <exec>:
 4bb:	b8 07 00 00 00       	mov    $0x7,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <open>:
 4c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mknod>:
 4cb:	b8 11 00 00 00       	mov    $0x11,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <unlink>:
 4d3:	b8 12 00 00 00       	mov    $0x12,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <fstat>:
 4db:	b8 08 00 00 00       	mov    $0x8,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <link>:
 4e3:	b8 13 00 00 00       	mov    $0x13,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <mkdir>:
 4eb:	b8 14 00 00 00       	mov    $0x14,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <chdir>:
 4f3:	b8 09 00 00 00       	mov    $0x9,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <dup>:
 4fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <getpid>:
 503:	b8 0b 00 00 00       	mov    $0xb,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <sbrk>:
 50b:	b8 0c 00 00 00       	mov    $0xc,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <sleep>:
 513:	b8 0d 00 00 00       	mov    $0xd,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <uptime>:
 51b:	b8 0e 00 00 00       	mov    $0xe,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <lseek>:
 523:	b8 16 00 00 00       	mov    $0x16,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <isatty>:
 52b:	b8 17 00 00 00       	mov    $0x17,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <procstat>:
 533:	b8 18 00 00 00       	mov    $0x18,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <set_priority>:
 53b:	b8 19 00 00 00       	mov    $0x19,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <semget>:
 543:	b8 1a 00 00 00       	mov    $0x1a,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <semfree>:
 54b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <semdown>:
 553:	b8 1c 00 00 00       	mov    $0x1c,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <semup>:
 55b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <shm_create>:
 563:	b8 1e 00 00 00       	mov    $0x1e,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <shm_close>:
 56b:	b8 1f 00 00 00       	mov    $0x1f,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <shm_get>:
 573:	b8 20 00 00 00       	mov    $0x20,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 57b:	55                   	push   %ebp
 57c:	89 e5                	mov    %esp,%ebp
 57e:	83 ec 28             	sub    $0x28,%esp
 581:	8b 45 0c             	mov    0xc(%ebp),%eax
 584:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 587:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58e:	00 
 58f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 592:	89 44 24 04          	mov    %eax,0x4(%esp)
 596:	8b 45 08             	mov    0x8(%ebp),%eax
 599:	89 04 24             	mov    %eax,(%esp)
 59c:	e8 02 ff ff ff       	call   4a3 <write>
}
 5a1:	c9                   	leave  
 5a2:	c3                   	ret    

000005a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp
 5a6:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5b0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5b4:	74 17                	je     5cd <printint+0x2a>
 5b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ba:	79 11                	jns    5cd <printint+0x2a>
    neg = 1;
 5bc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c6:	f7 d8                	neg    %eax
 5c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cb:	eb 06                	jmp    5d3 <printint+0x30>
  } else {
    x = xx;
 5cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5da:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e0:	ba 00 00 00 00       	mov    $0x0,%edx
 5e5:	f7 f1                	div    %ecx
 5e7:	89 d0                	mov    %edx,%eax
 5e9:	8a 80 78 0d 00 00    	mov    0xd78(%eax),%al
 5ef:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 5f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5f5:	01 ca                	add    %ecx,%edx
 5f7:	88 02                	mov    %al,(%edx)
 5f9:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 5fc:	8b 55 10             	mov    0x10(%ebp),%edx
 5ff:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 602:	8b 45 ec             	mov    -0x14(%ebp),%eax
 605:	ba 00 00 00 00       	mov    $0x0,%edx
 60a:	f7 75 d4             	divl   -0x2c(%ebp)
 60d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 610:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 614:	75 c4                	jne    5da <printint+0x37>
  if(neg)
 616:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 61a:	74 2c                	je     648 <printint+0xa5>
    buf[i++] = '-';
 61c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 61f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 622:	01 d0                	add    %edx,%eax
 624:	c6 00 2d             	movb   $0x2d,(%eax)
 627:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 62a:	eb 1c                	jmp    648 <printint+0xa5>
    putc(fd, buf[i]);
 62c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 632:	01 d0                	add    %edx,%eax
 634:	8a 00                	mov    (%eax),%al
 636:	0f be c0             	movsbl %al,%eax
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	89 04 24             	mov    %eax,(%esp)
 643:	e8 33 ff ff ff       	call   57b <putc>
  while(--i >= 0)
 648:	ff 4d f4             	decl   -0xc(%ebp)
 64b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64f:	79 db                	jns    62c <printint+0x89>
}
 651:	c9                   	leave  
 652:	c3                   	ret    

00000653 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 653:	55                   	push   %ebp
 654:	89 e5                	mov    %esp,%ebp
 656:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 659:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 660:	8d 45 0c             	lea    0xc(%ebp),%eax
 663:	83 c0 04             	add    $0x4,%eax
 666:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 669:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 670:	e9 78 01 00 00       	jmp    7ed <printf+0x19a>
    c = fmt[i] & 0xff;
 675:	8b 55 0c             	mov    0xc(%ebp),%edx
 678:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67b:	01 d0                	add    %edx,%eax
 67d:	8a 00                	mov    (%eax),%al
 67f:	0f be c0             	movsbl %al,%eax
 682:	25 ff 00 00 00       	and    $0xff,%eax
 687:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 68a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 68e:	75 2c                	jne    6bc <printf+0x69>
      if(c == '%'){
 690:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 694:	75 0c                	jne    6a2 <printf+0x4f>
        state = '%';
 696:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 69d:	e9 48 01 00 00       	jmp    7ea <printf+0x197>
      } else {
        putc(fd, c);
 6a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 c4 fe ff ff       	call   57b <putc>
 6b7:	e9 2e 01 00 00       	jmp    7ea <printf+0x197>
      }
    } else if(state == '%'){
 6bc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6c0:	0f 85 24 01 00 00    	jne    7ea <printf+0x197>
      if(c == 'd'){
 6c6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6ca:	75 2d                	jne    6f9 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 6cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cf:	8b 00                	mov    (%eax),%eax
 6d1:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6d8:	00 
 6d9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6e0:	00 
 6e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e5:	8b 45 08             	mov    0x8(%ebp),%eax
 6e8:	89 04 24             	mov    %eax,(%esp)
 6eb:	e8 b3 fe ff ff       	call   5a3 <printint>
        ap++;
 6f0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f4:	e9 ea 00 00 00       	jmp    7e3 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 6f9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6fd:	74 06                	je     705 <printf+0xb2>
 6ff:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 703:	75 2d                	jne    732 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 705:	8b 45 e8             	mov    -0x18(%ebp),%eax
 708:	8b 00                	mov    (%eax),%eax
 70a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 711:	00 
 712:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 719:	00 
 71a:	89 44 24 04          	mov    %eax,0x4(%esp)
 71e:	8b 45 08             	mov    0x8(%ebp),%eax
 721:	89 04 24             	mov    %eax,(%esp)
 724:	e8 7a fe ff ff       	call   5a3 <printint>
        ap++;
 729:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72d:	e9 b1 00 00 00       	jmp    7e3 <printf+0x190>
      } else if(c == 's'){
 732:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 736:	75 43                	jne    77b <printf+0x128>
        s = (char*)*ap;
 738:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 740:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 744:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 748:	75 25                	jne    76f <printf+0x11c>
          s = "(null)";
 74a:	c7 45 f4 f4 0a 00 00 	movl   $0xaf4,-0xc(%ebp)
        while(*s != 0){
 751:	eb 1c                	jmp    76f <printf+0x11c>
          putc(fd, *s);
 753:	8b 45 f4             	mov    -0xc(%ebp),%eax
 756:	8a 00                	mov    (%eax),%al
 758:	0f be c0             	movsbl %al,%eax
 75b:	89 44 24 04          	mov    %eax,0x4(%esp)
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	89 04 24             	mov    %eax,(%esp)
 765:	e8 11 fe ff ff       	call   57b <putc>
          s++;
 76a:	ff 45 f4             	incl   -0xc(%ebp)
 76d:	eb 01                	jmp    770 <printf+0x11d>
        while(*s != 0){
 76f:	90                   	nop
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8a 00                	mov    (%eax),%al
 775:	84 c0                	test   %al,%al
 777:	75 da                	jne    753 <printf+0x100>
 779:	eb 68                	jmp    7e3 <printf+0x190>
        }
      } else if(c == 'c'){
 77b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 77f:	75 1d                	jne    79e <printf+0x14b>
        putc(fd, *ap);
 781:	8b 45 e8             	mov    -0x18(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	0f be c0             	movsbl %al,%eax
 789:	89 44 24 04          	mov    %eax,0x4(%esp)
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 e3 fd ff ff       	call   57b <putc>
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	eb 45                	jmp    7e3 <printf+0x190>
      } else if(c == '%'){
 79e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a2:	75 17                	jne    7bb <printf+0x168>
        putc(fd, c);
 7a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a7:	0f be c0             	movsbl %al,%eax
 7aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	89 04 24             	mov    %eax,(%esp)
 7b4:	e8 c2 fd ff ff       	call   57b <putc>
 7b9:	eb 28                	jmp    7e3 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7bb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7c2:	00 
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	89 04 24             	mov    %eax,(%esp)
 7c9:	e8 ad fd ff ff       	call   57b <putc>
        putc(fd, c);
 7ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	89 04 24             	mov    %eax,(%esp)
 7de:	e8 98 fd ff ff       	call   57b <putc>
      }
      state = 0;
 7e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7ea:	ff 45 f0             	incl   -0x10(%ebp)
 7ed:	8b 55 0c             	mov    0xc(%ebp),%edx
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	01 d0                	add    %edx,%eax
 7f5:	8a 00                	mov    (%eax),%al
 7f7:	84 c0                	test   %al,%al
 7f9:	0f 85 76 fe ff ff    	jne    675 <printf+0x22>
    }
  }
}
 7ff:	c9                   	leave  
 800:	c3                   	ret    

00000801 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 801:	55                   	push   %ebp
 802:	89 e5                	mov    %esp,%ebp
 804:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	83 e8 08             	sub    $0x8,%eax
 80d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	a1 94 0d 00 00       	mov    0xd94,%eax
 815:	89 45 fc             	mov    %eax,-0x4(%ebp)
 818:	eb 24                	jmp    83e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 822:	77 12                	ja     836 <free+0x35>
 824:	8b 45 f8             	mov    -0x8(%ebp),%eax
 827:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82a:	77 24                	ja     850 <free+0x4f>
 82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 834:	77 1a                	ja     850 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	8b 00                	mov    (%eax),%eax
 83b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 83e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 841:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 844:	76 d4                	jbe    81a <free+0x19>
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 00                	mov    (%eax),%eax
 84b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84e:	76 ca                	jbe    81a <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 850:	8b 45 f8             	mov    -0x8(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 860:	01 c2                	add    %eax,%edx
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 00                	mov    (%eax),%eax
 867:	39 c2                	cmp    %eax,%edx
 869:	75 24                	jne    88f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 86b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86e:	8b 50 04             	mov    0x4(%eax),%edx
 871:	8b 45 fc             	mov    -0x4(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	8b 40 04             	mov    0x4(%eax),%eax
 879:	01 c2                	add    %eax,%edx
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	8b 10                	mov    (%eax),%edx
 888:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88b:	89 10                	mov    %edx,(%eax)
 88d:	eb 0a                	jmp    899 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	8b 10                	mov    (%eax),%edx
 894:	8b 45 f8             	mov    -0x8(%ebp),%eax
 897:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 899:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	01 d0                	add    %edx,%eax
 8ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ae:	75 20                	jne    8d0 <free+0xcf>
    p->s.size += bp->s.size;
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 50 04             	mov    0x4(%eax),%edx
 8b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b9:	8b 40 04             	mov    0x4(%eax),%eax
 8bc:	01 c2                	add    %eax,%edx
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	8b 10                	mov    (%eax),%edx
 8c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cc:	89 10                	mov    %edx,(%eax)
 8ce:	eb 08                	jmp    8d8 <free+0xd7>
  } else
    p->s.ptr = bp;
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d6:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	a3 94 0d 00 00       	mov    %eax,0xd94
}
 8e0:	c9                   	leave  
 8e1:	c3                   	ret    

000008e2 <morecore>:

static Header*
morecore(uint nu)
{
 8e2:	55                   	push   %ebp
 8e3:	89 e5                	mov    %esp,%ebp
 8e5:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ef:	77 07                	ja     8f8 <morecore+0x16>
    nu = 4096;
 8f1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f8:	8b 45 08             	mov    0x8(%ebp),%eax
 8fb:	c1 e0 03             	shl    $0x3,%eax
 8fe:	89 04 24             	mov    %eax,(%esp)
 901:	e8 05 fc ff ff       	call   50b <sbrk>
 906:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 909:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 90d:	75 07                	jne    916 <morecore+0x34>
    return 0;
 90f:	b8 00 00 00 00       	mov    $0x0,%eax
 914:	eb 22                	jmp    938 <morecore+0x56>
  hp = (Header*)p;
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91f:	8b 55 08             	mov    0x8(%ebp),%edx
 922:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 925:	8b 45 f0             	mov    -0x10(%ebp),%eax
 928:	83 c0 08             	add    $0x8,%eax
 92b:	89 04 24             	mov    %eax,(%esp)
 92e:	e8 ce fe ff ff       	call   801 <free>
  return freep;
 933:	a1 94 0d 00 00       	mov    0xd94,%eax
}
 938:	c9                   	leave  
 939:	c3                   	ret    

0000093a <malloc>:

void*
malloc(uint nbytes)
{
 93a:	55                   	push   %ebp
 93b:	89 e5                	mov    %esp,%ebp
 93d:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 940:	8b 45 08             	mov    0x8(%ebp),%eax
 943:	83 c0 07             	add    $0x7,%eax
 946:	c1 e8 03             	shr    $0x3,%eax
 949:	40                   	inc    %eax
 94a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 94d:	a1 94 0d 00 00       	mov    0xd94,%eax
 952:	89 45 f0             	mov    %eax,-0x10(%ebp)
 955:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 959:	75 23                	jne    97e <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 95b:	c7 45 f0 8c 0d 00 00 	movl   $0xd8c,-0x10(%ebp)
 962:	8b 45 f0             	mov    -0x10(%ebp),%eax
 965:	a3 94 0d 00 00       	mov    %eax,0xd94
 96a:	a1 94 0d 00 00       	mov    0xd94,%eax
 96f:	a3 8c 0d 00 00       	mov    %eax,0xd8c
    base.s.size = 0;
 974:	c7 05 90 0d 00 00 00 	movl   $0x0,0xd90
 97b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 986:	8b 45 f4             	mov    -0xc(%ebp),%eax
 989:	8b 40 04             	mov    0x4(%eax),%eax
 98c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 98f:	72 4d                	jb     9de <malloc+0xa4>
      if(p->s.size == nunits)
 991:	8b 45 f4             	mov    -0xc(%ebp),%eax
 994:	8b 40 04             	mov    0x4(%eax),%eax
 997:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99a:	75 0c                	jne    9a8 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 99c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99f:	8b 10                	mov    (%eax),%edx
 9a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a4:	89 10                	mov    %edx,(%eax)
 9a6:	eb 26                	jmp    9ce <malloc+0x94>
      else {
        p->s.size -= nunits;
 9a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ab:	8b 40 04             	mov    0x4(%eax),%eax
 9ae:	89 c2                	mov    %eax,%edx
 9b0:	2b 55 ec             	sub    -0x14(%ebp),%edx
 9b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bc:	8b 40 04             	mov    0x4(%eax),%eax
 9bf:	c1 e0 03             	shl    $0x3,%eax
 9c2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9cb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d1:	a3 94 0d 00 00       	mov    %eax,0xd94
      return (void*)(p + 1);
 9d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d9:	83 c0 08             	add    $0x8,%eax
 9dc:	eb 38                	jmp    a16 <malloc+0xdc>
    }
    if(p == freep)
 9de:	a1 94 0d 00 00       	mov    0xd94,%eax
 9e3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e6:	75 1b                	jne    a03 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 9e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9eb:	89 04 24             	mov    %eax,(%esp)
 9ee:	e8 ef fe ff ff       	call   8e2 <morecore>
 9f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9fa:	75 07                	jne    a03 <malloc+0xc9>
        return 0;
 9fc:	b8 00 00 00 00       	mov    $0x0,%eax
 a01:	eb 13                	jmp    a16 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0c:	8b 00                	mov    (%eax),%eax
 a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a11:	e9 70 ff ff ff       	jmp    986 <malloc+0x4c>
}
 a16:	c9                   	leave  
 a17:	c3                   	ret    
