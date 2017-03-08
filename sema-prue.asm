
_sema-prue:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test_0>:
int res;
// int res2;

// Test_0: ERROR, en la creacion de 5 semaforos para un proceso.
void
test_0(){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  semprod = semget(-1,BUFF_SIZE); 
   6:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
   d:	00 
   e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  15:	e8 ca 06 00 00       	call   6e4 <semget>
  1a:	a3 7c 10 00 00       	mov    %eax,0x107c
  printf(1,"LOG semaforo: %d\n", semprod);
  1f:	a1 7c 10 00 00       	mov    0x107c,%eax
  24:	89 44 24 08          	mov    %eax,0x8(%esp)
  28:	c7 44 24 04 bc 0b 00 	movl   $0xbbc,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 b8 07 00 00       	call   7f4 <printf>
  if(semprod < 0){
  3c:	a1 7c 10 00 00       	mov    0x107c,%eax
  41:	85 c0                	test   %eax,%eax
  43:	79 19                	jns    5e <test_0+0x5e>
    printf(1,"invalid semprod \n");
  45:	c7 44 24 04 ce 0b 00 	movl   $0xbce,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 9b 07 00 00       	call   7f4 <printf>
    exit();
  59:	e8 c6 05 00 00       	call   624 <exit>
  }
  semcom = semget(-1,0);   
  5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  65:	00 
  66:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  6d:	e8 72 06 00 00       	call   6e4 <semget>
  72:	a3 88 10 00 00       	mov    %eax,0x1088
  printf(1,"LOG semaforo: %d\n", semcom);
  77:	a1 88 10 00 00       	mov    0x1088,%eax
  7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  80:	c7 44 24 04 bc 0b 00 	movl   $0xbbc,0x4(%esp)
  87:	00 
  88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8f:	e8 60 07 00 00       	call   7f4 <printf>
  if(semcom < 0){
  94:	a1 88 10 00 00       	mov    0x1088,%eax
  99:	85 c0                	test   %eax,%eax
  9b:	79 19                	jns    b6 <test_0+0xb6>
    printf(1,"invalid semcom\n");
  9d:	c7 44 24 04 e0 0b 00 	movl   $0xbe0,0x4(%esp)
  a4:	00 
  a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ac:	e8 43 07 00 00       	call   7f4 <printf>
    exit();
  b1:	e8 6e 05 00 00       	call   624 <exit>
  }
  sembuff = semget(-1,1); 
  b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  bd:	00 
  be:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  c5:	e8 1a 06 00 00       	call   6e4 <semget>
  ca:	a3 84 10 00 00       	mov    %eax,0x1084
  printf(1,"LOG semaforo: %d\n", sembuff);
  cf:	a1 84 10 00 00       	mov    0x1084,%eax
  d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  d8:	c7 44 24 04 bc 0b 00 	movl   $0xbbc,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 08 07 00 00       	call   7f4 <printf>
  if(sembuff < 0){
  ec:	a1 84 10 00 00       	mov    0x1084,%eax
  f1:	85 c0                	test   %eax,%eax
  f3:	79 19                	jns    10e <test_0+0x10e>
    printf(1,"invalid sembuff\n");
  f5:	c7 44 24 04 f0 0b 00 	movl   $0xbf0,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 104:	e8 eb 06 00 00       	call   7f4 <printf>
    exit();
 109:	e8 16 05 00 00       	call   624 <exit>
  }
  semprueba1 = semget(-1,5); 
 10e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
 115:	00 
 116:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 11d:	e8 c2 05 00 00       	call   6e4 <semget>
 122:	a3 8c 10 00 00       	mov    %eax,0x108c
  printf(1,"LOG: semaforo: %d\n", semprueba1); 
 127:	a1 8c 10 00 00       	mov    0x108c,%eax
 12c:	89 44 24 08          	mov    %eax,0x8(%esp)
 130:	c7 44 24 04 01 0c 00 	movl   $0xc01,0x4(%esp)
 137:	00 
 138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13f:	e8 b0 06 00 00       	call   7f4 <printf>
  if(semprueba1 < 0){
 144:	a1 8c 10 00 00       	mov    0x108c,%eax
 149:	85 c0                	test   %eax,%eax
 14b:	79 19                	jns    166 <test_0+0x166>
    printf(1,"invalid semprueba1\n");
 14d:	c7 44 24 04 14 0c 00 	movl   $0xc14,0x4(%esp)
 154:	00 
 155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15c:	e8 93 06 00 00       	call   7f4 <printf>
    exit();
 161:	e8 be 04 00 00       	call   624 <exit>
  }

  semprueba2 = semget(-1,6); 
 166:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
 16d:	00 
 16e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 175:	e8 6a 05 00 00       	call   6e4 <semget>
 17a:	a3 80 10 00 00       	mov    %eax,0x1080
  printf(1,"LOG: semaforo: %d\n", semprueba2); 
 17f:	a1 80 10 00 00       	mov    0x1080,%eax
 184:	89 44 24 08          	mov    %eax,0x8(%esp)
 188:	c7 44 24 04 01 0c 00 	movl   $0xc01,0x4(%esp)
 18f:	00 
 190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 197:	e8 58 06 00 00       	call   7f4 <printf>
  if(semprueba2 == -2){
 19c:	a1 80 10 00 00       	mov    0x1080,%eax
 1a1:	83 f8 fe             	cmp    $0xfffffffe,%eax
 1a4:	75 19                	jne    1bf <test_0+0x1bf>
    printf(1,"ERROR el proceso corriente ya obtuvo el numero maximo de semaforos\n");
 1a6:	c7 44 24 04 28 0c 00 	movl   $0xc28,0x4(%esp)
 1ad:	00 
 1ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b5:	e8 3a 06 00 00       	call   7f4 <printf>
    exit();
 1ba:	e8 65 04 00 00       	call   624 <exit>
  }
  if(semprueba2 == -3){
 1bf:	a1 80 10 00 00       	mov    0x1080,%eax
 1c4:	83 f8 fd             	cmp    $0xfffffffd,%eax
 1c7:	75 19                	jne    1e2 <test_0+0x1e2>
    printf(1,"ERROR no ahi mas semaforos disponibles en el sistema\n");
 1c9:	c7 44 24 04 6c 0c 00 	movl   $0xc6c,0x4(%esp)
 1d0:	00 
 1d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d8:	e8 17 06 00 00       	call   7f4 <printf>
    exit();
 1dd:	e8 42 04 00 00       	call   624 <exit>
  }
}
 1e2:	c9                   	leave  
 1e3:	c3                   	ret    

000001e4 <test_1>:

// Test_1: Creacion y Obtencion del descriptor de un semaforo
void
test_1(){
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 18             	sub    $0x18,%esp

  semprod = semget(-1,4); 
 1ea:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 1f1:	00 
 1f2:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 1f9:	e8 e6 04 00 00       	call   6e4 <semget>
 1fe:	a3 7c 10 00 00       	mov    %eax,0x107c
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
 203:	a1 7c 10 00 00       	mov    0x107c,%eax
 208:	89 44 24 08          	mov    %eax,0x8(%esp)
 20c:	c7 44 24 04 a4 0c 00 	movl   $0xca4,0x4(%esp)
 213:	00 
 214:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 21b:	e8 d4 05 00 00       	call   7f4 <printf>
  if(semprod < 0){
 220:	a1 7c 10 00 00       	mov    0x107c,%eax
 225:	85 c0                	test   %eax,%eax
 227:	79 19                	jns    242 <test_1+0x5e>
    printf(1,"Error! en la creacion del semaforo\n");
 229:	c7 44 24 04 d4 0c 00 	movl   $0xcd4,0x4(%esp)
 230:	00 
 231:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 238:	e8 b7 05 00 00       	call   7f4 <printf>
    exit();
 23d:	e8 e2 03 00 00       	call   624 <exit>
  }

  res = semget(1,0); // le paso el identificador 1, y el unico semaforo creado que tengo es con identificador 0
 242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 249:	00 
 24a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 251:	e8 8e 04 00 00       	call   6e4 <semget>
 256:	a3 90 10 00 00       	mov    %eax,0x1090
  if(res == -1){
 25b:	a1 90 10 00 00       	mov    0x1090,%eax
 260:	83 f8 ff             	cmp    $0xffffffff,%eax
 263:	75 19                	jne    27e <test_1+0x9a>
    printf(1,"ERROR, el semaforo con ese identificador no esta en uso\n");
 265:	c7 44 24 04 f8 0c 00 	movl   $0xcf8,0x4(%esp)
 26c:	00 
 26d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 274:	e8 7b 05 00 00       	call   7f4 <printf>
    exit();
 279:	e8 a6 03 00 00       	call   624 <exit>
  }
  if(res == -2){
 27e:	a1 90 10 00 00       	mov    0x1090,%eax
 283:	83 f8 fe             	cmp    $0xfffffffe,%eax
 286:	75 19                	jne    2a1 <test_1+0xbd>
    printf(1,"ERROR, el proceso ya obtuvo el maximo de semaforos\n");
 288:	c7 44 24 04 34 0d 00 	movl   $0xd34,0x4(%esp)
 28f:	00 
 290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 297:	e8 58 05 00 00       	call   7f4 <printf>
    exit();
 29c:	e8 83 03 00 00       	call   624 <exit>
  }
  printf(1,"El identificador del semaforo obtenido es: %d\n", res);
 2a1:	a1 90 10 00 00       	mov    0x1090,%eax
 2a6:	89 44 24 08          	mov    %eax,0x8(%esp)
 2aa:	c7 44 24 04 68 0d 00 	movl   $0xd68,0x4(%esp)
 2b1:	00 
 2b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b9:	e8 36 05 00 00       	call   7f4 <printf>
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <test_2>:

// Test_2: contador de semaforos en el proceso padre corriente 
void
test_2(){
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 18             	sub    $0x18,%esp
  semprod = semget(-1,4); 
 2c6:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 2cd:	00 
 2ce:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 2d5:	e8 0a 04 00 00       	call   6e4 <semget>
 2da:	a3 7c 10 00 00       	mov    %eax,0x107c
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
 2df:	a1 7c 10 00 00       	mov    0x107c,%eax
 2e4:	89 44 24 08          	mov    %eax,0x8(%esp)
 2e8:	c7 44 24 04 a4 0c 00 	movl   $0xca4,0x4(%esp)
 2ef:	00 
 2f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2f7:	e8 f8 04 00 00       	call   7f4 <printf>
  if(semprod < 0){
 2fc:	a1 7c 10 00 00       	mov    0x107c,%eax
 301:	85 c0                	test   %eax,%eax
 303:	79 19                	jns    31e <test_2+0x5e>
    printf(1,"Error! en la creacion del semaforo\n");
 305:	c7 44 24 04 d4 0c 00 	movl   $0xcd4,0x4(%esp)
 30c:	00 
 30d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 314:	e8 db 04 00 00       	call   7f4 <printf>
    exit();
 319:	e8 06 03 00 00       	call   624 <exit>
  }

}
 31e:	c9                   	leave  
 31f:	c3                   	ret    

00000320 <test_3>:

void
test_3(){
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	83 ec 18             	sub    $0x18,%esp
  semprod = semget(-1,4); 
 326:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 32d:	00 
 32e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 335:	e8 aa 03 00 00       	call   6e4 <semget>
 33a:	a3 7c 10 00 00       	mov    %eax,0x107c
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
 33f:	a1 7c 10 00 00       	mov    0x107c,%eax
 344:	89 44 24 08          	mov    %eax,0x8(%esp)
 348:	c7 44 24 04 a4 0c 00 	movl   $0xca4,0x4(%esp)
 34f:	00 
 350:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 357:	e8 98 04 00 00       	call   7f4 <printf>
  if(semprod < 0){
 35c:	a1 7c 10 00 00       	mov    0x107c,%eax
 361:	85 c0                	test   %eax,%eax
 363:	79 19                	jns    37e <test_3+0x5e>
    printf(1,"Error! en la creacion del semaforo\n");
 365:	c7 44 24 04 d4 0c 00 	movl   $0xcd4,0x4(%esp)
 36c:	00 
 36d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 374:	e8 7b 04 00 00       	call   7f4 <printf>
    exit();
 379:	e8 a6 02 00 00       	call   624 <exit>
  }
  semprod = semget(0,4); 
 37e:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 385:	00 
 386:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 38d:	e8 52 03 00 00       	call   6e4 <semget>
 392:	a3 7c 10 00 00       	mov    %eax,0x107c
  semprod = semget(0,4); 
 397:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 39e:	00 
 39f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3a6:	e8 39 03 00 00       	call   6e4 <semget>
 3ab:	a3 7c 10 00 00       	mov    %eax,0x107c
  semprod = semget(0,4); 
 3b0:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 3b7:	00 
 3b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3bf:	e8 20 03 00 00       	call   6e4 <semget>
 3c4:	a3 7c 10 00 00       	mov    %eax,0x107c
}
 3c9:	c9                   	leave  
 3ca:	c3                   	ret    

000003cb <main>:

int
main(void)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 e4 f0             	and    $0xfffffff0,%esp
  //test_0();
  //test_1();
  //test_2();
  test_3();
 3d1:	e8 4a ff ff ff       	call   320 <test_3>

  exit();
 3d6:	e8 49 02 00 00       	call   624 <exit>

000003db <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	57                   	push   %edi
 3df:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3e3:	8b 55 10             	mov    0x10(%ebp),%edx
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	89 cb                	mov    %ecx,%ebx
 3eb:	89 df                	mov    %ebx,%edi
 3ed:	89 d1                	mov    %edx,%ecx
 3ef:	fc                   	cld    
 3f0:	f3 aa                	rep stos %al,%es:(%edi)
 3f2:	89 ca                	mov    %ecx,%edx
 3f4:	89 fb                	mov    %edi,%ebx
 3f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3f9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3fc:	5b                   	pop    %ebx
 3fd:	5f                   	pop    %edi
 3fe:	5d                   	pop    %ebp
 3ff:	c3                   	ret    

00000400 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 406:	8b 45 08             	mov    0x8(%ebp),%eax
 409:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 40c:	90                   	nop
 40d:	8b 45 0c             	mov    0xc(%ebp),%eax
 410:	8a 10                	mov    (%eax),%dl
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	88 10                	mov    %dl,(%eax)
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	8a 00                	mov    (%eax),%al
 41c:	84 c0                	test   %al,%al
 41e:	0f 95 c0             	setne  %al
 421:	ff 45 08             	incl   0x8(%ebp)
 424:	ff 45 0c             	incl   0xc(%ebp)
 427:	84 c0                	test   %al,%al
 429:	75 e2                	jne    40d <strcpy+0xd>
    ;
  return os;
 42b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 42e:	c9                   	leave  
 42f:	c3                   	ret    

00000430 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 433:	eb 06                	jmp    43b <strcmp+0xb>
    p++, q++;
 435:	ff 45 08             	incl   0x8(%ebp)
 438:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	8a 00                	mov    (%eax),%al
 440:	84 c0                	test   %al,%al
 442:	74 0e                	je     452 <strcmp+0x22>
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	8a 10                	mov    (%eax),%dl
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	8a 00                	mov    (%eax),%al
 44e:	38 c2                	cmp    %al,%dl
 450:	74 e3                	je     435 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	8a 00                	mov    (%eax),%al
 457:	0f b6 d0             	movzbl %al,%edx
 45a:	8b 45 0c             	mov    0xc(%ebp),%eax
 45d:	8a 00                	mov    (%eax),%al
 45f:	0f b6 c0             	movzbl %al,%eax
 462:	89 d1                	mov    %edx,%ecx
 464:	29 c1                	sub    %eax,%ecx
 466:	89 c8                	mov    %ecx,%eax
}
 468:	5d                   	pop    %ebp
 469:	c3                   	ret    

0000046a <strlen>:

uint
strlen(char *s)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 477:	eb 03                	jmp    47c <strlen+0x12>
 479:	ff 45 fc             	incl   -0x4(%ebp)
 47c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	01 d0                	add    %edx,%eax
 484:	8a 00                	mov    (%eax),%al
 486:	84 c0                	test   %al,%al
 488:	75 ef                	jne    479 <strlen+0xf>
    ;
  return n;
 48a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 48d:	c9                   	leave  
 48e:	c3                   	ret    

0000048f <memset>:

void*
memset(void *dst, int c, uint n)
{
 48f:	55                   	push   %ebp
 490:	89 e5                	mov    %esp,%ebp
 492:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 495:	8b 45 10             	mov    0x10(%ebp),%eax
 498:	89 44 24 08          	mov    %eax,0x8(%esp)
 49c:	8b 45 0c             	mov    0xc(%ebp),%eax
 49f:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	89 04 24             	mov    %eax,(%esp)
 4a9:	e8 2d ff ff ff       	call   3db <stosb>
  return dst;
 4ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4b1:	c9                   	leave  
 4b2:	c3                   	ret    

000004b3 <strchr>:

char*
strchr(const char *s, char c)
{
 4b3:	55                   	push   %ebp
 4b4:	89 e5                	mov    %esp,%ebp
 4b6:	83 ec 04             	sub    $0x4,%esp
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4bf:	eb 12                	jmp    4d3 <strchr+0x20>
    if(*s == c)
 4c1:	8b 45 08             	mov    0x8(%ebp),%eax
 4c4:	8a 00                	mov    (%eax),%al
 4c6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4c9:	75 05                	jne    4d0 <strchr+0x1d>
      return (char*)s;
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	eb 11                	jmp    4e1 <strchr+0x2e>
  for(; *s; s++)
 4d0:	ff 45 08             	incl   0x8(%ebp)
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	8a 00                	mov    (%eax),%al
 4d8:	84 c0                	test   %al,%al
 4da:	75 e5                	jne    4c1 <strchr+0xe>
  return 0;
 4dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4e1:	c9                   	leave  
 4e2:	c3                   	ret    

000004e3 <gets>:

char*
gets(char *buf, int max)
{
 4e3:	55                   	push   %ebp
 4e4:	89 e5                	mov    %esp,%ebp
 4e6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4f0:	eb 42                	jmp    534 <gets+0x51>
    cc = read(0, &c, 1);
 4f2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f9:	00 
 4fa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 501:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 508:	e8 2f 01 00 00       	call   63c <read>
 50d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 514:	7e 29                	jle    53f <gets+0x5c>
      break;
    buf[i++] = c;
 516:	8b 55 f4             	mov    -0xc(%ebp),%edx
 519:	8b 45 08             	mov    0x8(%ebp),%eax
 51c:	01 c2                	add    %eax,%edx
 51e:	8a 45 ef             	mov    -0x11(%ebp),%al
 521:	88 02                	mov    %al,(%edx)
 523:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 526:	8a 45 ef             	mov    -0x11(%ebp),%al
 529:	3c 0a                	cmp    $0xa,%al
 52b:	74 13                	je     540 <gets+0x5d>
 52d:	8a 45 ef             	mov    -0x11(%ebp),%al
 530:	3c 0d                	cmp    $0xd,%al
 532:	74 0c                	je     540 <gets+0x5d>
  for(i=0; i+1 < max; ){
 534:	8b 45 f4             	mov    -0xc(%ebp),%eax
 537:	40                   	inc    %eax
 538:	3b 45 0c             	cmp    0xc(%ebp),%eax
 53b:	7c b5                	jl     4f2 <gets+0xf>
 53d:	eb 01                	jmp    540 <gets+0x5d>
      break;
 53f:	90                   	nop
      break;
  }
  buf[i] = '\0';
 540:	8b 55 f4             	mov    -0xc(%ebp),%edx
 543:	8b 45 08             	mov    0x8(%ebp),%eax
 546:	01 d0                	add    %edx,%eax
 548:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 54e:	c9                   	leave  
 54f:	c3                   	ret    

00000550 <stat>:

int
stat(char *n, struct stat *st)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 556:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 55d:	00 
 55e:	8b 45 08             	mov    0x8(%ebp),%eax
 561:	89 04 24             	mov    %eax,(%esp)
 564:	e8 fb 00 00 00       	call   664 <open>
 569:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 56c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 570:	79 07                	jns    579 <stat+0x29>
    return -1;
 572:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 577:	eb 23                	jmp    59c <stat+0x4c>
  r = fstat(fd, st);
 579:	8b 45 0c             	mov    0xc(%ebp),%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	8b 45 f4             	mov    -0xc(%ebp),%eax
 583:	89 04 24             	mov    %eax,(%esp)
 586:	e8 f1 00 00 00       	call   67c <fstat>
 58b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 58e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 591:	89 04 24             	mov    %eax,(%esp)
 594:	e8 b3 00 00 00       	call   64c <close>
  return r;
 599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 59c:	c9                   	leave  
 59d:	c3                   	ret    

0000059e <atoi>:

int
atoi(const char *s)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 5a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5ab:	eb 21                	jmp    5ce <atoi+0x30>
    n = n*10 + *s++ - '0';
 5ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5b0:	89 d0                	mov    %edx,%eax
 5b2:	c1 e0 02             	shl    $0x2,%eax
 5b5:	01 d0                	add    %edx,%eax
 5b7:	d1 e0                	shl    %eax
 5b9:	89 c2                	mov    %eax,%edx
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	8a 00                	mov    (%eax),%al
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	01 d0                	add    %edx,%eax
 5c5:	83 e8 30             	sub    $0x30,%eax
 5c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5cb:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 5ce:	8b 45 08             	mov    0x8(%ebp),%eax
 5d1:	8a 00                	mov    (%eax),%al
 5d3:	3c 2f                	cmp    $0x2f,%al
 5d5:	7e 09                	jle    5e0 <atoi+0x42>
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	8a 00                	mov    (%eax),%al
 5dc:	3c 39                	cmp    $0x39,%al
 5de:	7e cd                	jle    5ad <atoi+0xf>
  return n;
 5e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5e3:	c9                   	leave  
 5e4:	c3                   	ret    

000005e5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5e5:	55                   	push   %ebp
 5e6:	89 e5                	mov    %esp,%ebp
 5e8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5eb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5f7:	eb 10                	jmp    609 <memmove+0x24>
    *dst++ = *src++;
 5f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5fc:	8a 10                	mov    (%eax),%dl
 5fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 601:	88 10                	mov    %dl,(%eax)
 603:	ff 45 fc             	incl   -0x4(%ebp)
 606:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 609:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 60d:	0f 9f c0             	setg   %al
 610:	ff 4d 10             	decl   0x10(%ebp)
 613:	84 c0                	test   %al,%al
 615:	75 e2                	jne    5f9 <memmove+0x14>
  return vdst;
 617:	8b 45 08             	mov    0x8(%ebp),%eax
}
 61a:	c9                   	leave  
 61b:	c3                   	ret    

0000061c <fork>:
 61c:	b8 01 00 00 00       	mov    $0x1,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <exit>:
 624:	b8 02 00 00 00       	mov    $0x2,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <wait>:
 62c:	b8 03 00 00 00       	mov    $0x3,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <pipe>:
 634:	b8 04 00 00 00       	mov    $0x4,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <read>:
 63c:	b8 05 00 00 00       	mov    $0x5,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <write>:
 644:	b8 10 00 00 00       	mov    $0x10,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <close>:
 64c:	b8 15 00 00 00       	mov    $0x15,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <kill>:
 654:	b8 06 00 00 00       	mov    $0x6,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <exec>:
 65c:	b8 07 00 00 00       	mov    $0x7,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <open>:
 664:	b8 0f 00 00 00       	mov    $0xf,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <mknod>:
 66c:	b8 11 00 00 00       	mov    $0x11,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <unlink>:
 674:	b8 12 00 00 00       	mov    $0x12,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <fstat>:
 67c:	b8 08 00 00 00       	mov    $0x8,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <link>:
 684:	b8 13 00 00 00       	mov    $0x13,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <mkdir>:
 68c:	b8 14 00 00 00       	mov    $0x14,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <chdir>:
 694:	b8 09 00 00 00       	mov    $0x9,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <dup>:
 69c:	b8 0a 00 00 00       	mov    $0xa,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <getpid>:
 6a4:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a9:	cd 40                	int    $0x40
 6ab:	c3                   	ret    

000006ac <sbrk>:
 6ac:	b8 0c 00 00 00       	mov    $0xc,%eax
 6b1:	cd 40                	int    $0x40
 6b3:	c3                   	ret    

000006b4 <sleep>:
 6b4:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b9:	cd 40                	int    $0x40
 6bb:	c3                   	ret    

000006bc <uptime>:
 6bc:	b8 0e 00 00 00       	mov    $0xe,%eax
 6c1:	cd 40                	int    $0x40
 6c3:	c3                   	ret    

000006c4 <lseek>:
 6c4:	b8 16 00 00 00       	mov    $0x16,%eax
 6c9:	cd 40                	int    $0x40
 6cb:	c3                   	ret    

000006cc <isatty>:
 6cc:	b8 17 00 00 00       	mov    $0x17,%eax
 6d1:	cd 40                	int    $0x40
 6d3:	c3                   	ret    

000006d4 <procstat>:
 6d4:	b8 18 00 00 00       	mov    $0x18,%eax
 6d9:	cd 40                	int    $0x40
 6db:	c3                   	ret    

000006dc <set_priority>:
 6dc:	b8 19 00 00 00       	mov    $0x19,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <semget>:
 6e4:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <semfree>:
 6ec:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <semdown>:
 6f4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <semup>:
 6fc:	b8 1d 00 00 00       	mov    $0x1d,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <shm_create>:
 704:	b8 1e 00 00 00       	mov    $0x1e,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <shm_close>:
 70c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 711:	cd 40                	int    $0x40
 713:	c3                   	ret    

00000714 <shm_get>:
 714:	b8 20 00 00 00       	mov    $0x20,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	83 ec 28             	sub    $0x28,%esp
 722:	8b 45 0c             	mov    0xc(%ebp),%eax
 725:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 728:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 72f:	00 
 730:	8d 45 f4             	lea    -0xc(%ebp),%eax
 733:	89 44 24 04          	mov    %eax,0x4(%esp)
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 02 ff ff ff       	call   644 <write>
}
 742:	c9                   	leave  
 743:	c3                   	ret    

00000744 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 74a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 751:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 755:	74 17                	je     76e <printint+0x2a>
 757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 75b:	79 11                	jns    76e <printint+0x2a>
    neg = 1;
 75d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 764:	8b 45 0c             	mov    0xc(%ebp),%eax
 767:	f7 d8                	neg    %eax
 769:	89 45 ec             	mov    %eax,-0x14(%ebp)
 76c:	eb 06                	jmp    774 <printint+0x30>
  } else {
    x = xx;
 76e:	8b 45 0c             	mov    0xc(%ebp),%eax
 771:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 774:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 77b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 77e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 781:	ba 00 00 00 00       	mov    $0x0,%edx
 786:	f7 f1                	div    %ecx
 788:	89 d0                	mov    %edx,%eax
 78a:	8a 80 5c 10 00 00    	mov    0x105c(%eax),%al
 790:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 793:	8b 55 f4             	mov    -0xc(%ebp),%edx
 796:	01 ca                	add    %ecx,%edx
 798:	88 02                	mov    %al,(%edx)
 79a:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 79d:	8b 55 10             	mov    0x10(%ebp),%edx
 7a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 7a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a6:	ba 00 00 00 00       	mov    $0x0,%edx
 7ab:	f7 75 d4             	divl   -0x2c(%ebp)
 7ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7b5:	75 c4                	jne    77b <printint+0x37>
  if(neg)
 7b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bb:	74 2c                	je     7e9 <printint+0xa5>
    buf[i++] = '-';
 7bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	01 d0                	add    %edx,%eax
 7c5:	c6 00 2d             	movb   $0x2d,(%eax)
 7c8:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 7cb:	eb 1c                	jmp    7e9 <printint+0xa5>
    putc(fd, buf[i]);
 7cd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	01 d0                	add    %edx,%eax
 7d5:	8a 00                	mov    (%eax),%al
 7d7:	0f be c0             	movsbl %al,%eax
 7da:	89 44 24 04          	mov    %eax,0x4(%esp)
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	89 04 24             	mov    %eax,(%esp)
 7e4:	e8 33 ff ff ff       	call   71c <putc>
  while(--i >= 0)
 7e9:	ff 4d f4             	decl   -0xc(%ebp)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	79 db                	jns    7cd <printint+0x89>
}
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 801:	8d 45 0c             	lea    0xc(%ebp),%eax
 804:	83 c0 04             	add    $0x4,%eax
 807:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 80a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 811:	e9 78 01 00 00       	jmp    98e <printf+0x19a>
    c = fmt[i] & 0xff;
 816:	8b 55 0c             	mov    0xc(%ebp),%edx
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	01 d0                	add    %edx,%eax
 81e:	8a 00                	mov    (%eax),%al
 820:	0f be c0             	movsbl %al,%eax
 823:	25 ff 00 00 00       	and    $0xff,%eax
 828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 82b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82f:	75 2c                	jne    85d <printf+0x69>
      if(c == '%'){
 831:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 835:	75 0c                	jne    843 <printf+0x4f>
        state = '%';
 837:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 83e:	e9 48 01 00 00       	jmp    98b <printf+0x197>
      } else {
        putc(fd, c);
 843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 846:	0f be c0             	movsbl %al,%eax
 849:	89 44 24 04          	mov    %eax,0x4(%esp)
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	89 04 24             	mov    %eax,(%esp)
 853:	e8 c4 fe ff ff       	call   71c <putc>
 858:	e9 2e 01 00 00       	jmp    98b <printf+0x197>
      }
    } else if(state == '%'){
 85d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 861:	0f 85 24 01 00 00    	jne    98b <printf+0x197>
      if(c == 'd'){
 867:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 86b:	75 2d                	jne    89a <printf+0xa6>
        printint(fd, *ap, 10, 1);
 86d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 870:	8b 00                	mov    (%eax),%eax
 872:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 879:	00 
 87a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 881:	00 
 882:	89 44 24 04          	mov    %eax,0x4(%esp)
 886:	8b 45 08             	mov    0x8(%ebp),%eax
 889:	89 04 24             	mov    %eax,(%esp)
 88c:	e8 b3 fe ff ff       	call   744 <printint>
        ap++;
 891:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 895:	e9 ea 00 00 00       	jmp    984 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 89a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 89e:	74 06                	je     8a6 <printf+0xb2>
 8a0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8a4:	75 2d                	jne    8d3 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 8a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8b2:	00 
 8b3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8ba:	00 
 8bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8bf:	8b 45 08             	mov    0x8(%ebp),%eax
 8c2:	89 04 24             	mov    %eax,(%esp)
 8c5:	e8 7a fe ff ff       	call   744 <printint>
        ap++;
 8ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ce:	e9 b1 00 00 00       	jmp    984 <printf+0x190>
      } else if(c == 's'){
 8d3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8d7:	75 43                	jne    91c <printf+0x128>
        s = (char*)*ap;
 8d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8e1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e9:	75 25                	jne    910 <printf+0x11c>
          s = "(null)";
 8eb:	c7 45 f4 97 0d 00 00 	movl   $0xd97,-0xc(%ebp)
        while(*s != 0){
 8f2:	eb 1c                	jmp    910 <printf+0x11c>
          putc(fd, *s);
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8a 00                	mov    (%eax),%al
 8f9:	0f be c0             	movsbl %al,%eax
 8fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 900:	8b 45 08             	mov    0x8(%ebp),%eax
 903:	89 04 24             	mov    %eax,(%esp)
 906:	e8 11 fe ff ff       	call   71c <putc>
          s++;
 90b:	ff 45 f4             	incl   -0xc(%ebp)
 90e:	eb 01                	jmp    911 <printf+0x11d>
        while(*s != 0){
 910:	90                   	nop
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8a 00                	mov    (%eax),%al
 916:	84 c0                	test   %al,%al
 918:	75 da                	jne    8f4 <printf+0x100>
 91a:	eb 68                	jmp    984 <printf+0x190>
        }
      } else if(c == 'c'){
 91c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 920:	75 1d                	jne    93f <printf+0x14b>
        putc(fd, *ap);
 922:	8b 45 e8             	mov    -0x18(%ebp),%eax
 925:	8b 00                	mov    (%eax),%eax
 927:	0f be c0             	movsbl %al,%eax
 92a:	89 44 24 04          	mov    %eax,0x4(%esp)
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	89 04 24             	mov    %eax,(%esp)
 934:	e8 e3 fd ff ff       	call   71c <putc>
        ap++;
 939:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 93d:	eb 45                	jmp    984 <printf+0x190>
      } else if(c == '%'){
 93f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 943:	75 17                	jne    95c <printf+0x168>
        putc(fd, c);
 945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 948:	0f be c0             	movsbl %al,%eax
 94b:	89 44 24 04          	mov    %eax,0x4(%esp)
 94f:	8b 45 08             	mov    0x8(%ebp),%eax
 952:	89 04 24             	mov    %eax,(%esp)
 955:	e8 c2 fd ff ff       	call   71c <putc>
 95a:	eb 28                	jmp    984 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 95c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 963:	00 
 964:	8b 45 08             	mov    0x8(%ebp),%eax
 967:	89 04 24             	mov    %eax,(%esp)
 96a:	e8 ad fd ff ff       	call   71c <putc>
        putc(fd, c);
 96f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 972:	0f be c0             	movsbl %al,%eax
 975:	89 44 24 04          	mov    %eax,0x4(%esp)
 979:	8b 45 08             	mov    0x8(%ebp),%eax
 97c:	89 04 24             	mov    %eax,(%esp)
 97f:	e8 98 fd ff ff       	call   71c <putc>
      }
      state = 0;
 984:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 98b:	ff 45 f0             	incl   -0x10(%ebp)
 98e:	8b 55 0c             	mov    0xc(%ebp),%edx
 991:	8b 45 f0             	mov    -0x10(%ebp),%eax
 994:	01 d0                	add    %edx,%eax
 996:	8a 00                	mov    (%eax),%al
 998:	84 c0                	test   %al,%al
 99a:	0f 85 76 fe ff ff    	jne    816 <printf+0x22>
    }
  }
}
 9a0:	c9                   	leave  
 9a1:	c3                   	ret    

000009a2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a2:	55                   	push   %ebp
 9a3:	89 e5                	mov    %esp,%ebp
 9a5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a8:	8b 45 08             	mov    0x8(%ebp),%eax
 9ab:	83 e8 08             	sub    $0x8,%eax
 9ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b1:	a1 78 10 00 00       	mov    0x1078,%eax
 9b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9b9:	eb 24                	jmp    9df <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9be:	8b 00                	mov    (%eax),%eax
 9c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c3:	77 12                	ja     9d7 <free+0x35>
 9c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9cb:	77 24                	ja     9f1 <free+0x4f>
 9cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d0:	8b 00                	mov    (%eax),%eax
 9d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d5:	77 1a                	ja     9f1 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9da:	8b 00                	mov    (%eax),%eax
 9dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e5:	76 d4                	jbe    9bb <free+0x19>
 9e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ea:	8b 00                	mov    (%eax),%eax
 9ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ef:	76 ca                	jbe    9bb <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f4:	8b 40 04             	mov    0x4(%eax),%eax
 9f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a01:	01 c2                	add    %eax,%edx
 a03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a06:	8b 00                	mov    (%eax),%eax
 a08:	39 c2                	cmp    %eax,%edx
 a0a:	75 24                	jne    a30 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0f:	8b 50 04             	mov    0x4(%eax),%edx
 a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a15:	8b 00                	mov    (%eax),%eax
 a17:	8b 40 04             	mov    0x4(%eax),%eax
 a1a:	01 c2                	add    %eax,%edx
 a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a25:	8b 00                	mov    (%eax),%eax
 a27:	8b 10                	mov    (%eax),%edx
 a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2c:	89 10                	mov    %edx,(%eax)
 a2e:	eb 0a                	jmp    a3a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a33:	8b 10                	mov    (%eax),%edx
 a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a38:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3d:	8b 40 04             	mov    0x4(%eax),%eax
 a40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4a:	01 d0                	add    %edx,%eax
 a4c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a4f:	75 20                	jne    a71 <free+0xcf>
    p->s.size += bp->s.size;
 a51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a54:	8b 50 04             	mov    0x4(%eax),%edx
 a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5a:	8b 40 04             	mov    0x4(%eax),%eax
 a5d:	01 c2                	add    %eax,%edx
 a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a62:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a65:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a68:	8b 10                	mov    (%eax),%edx
 a6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6d:	89 10                	mov    %edx,(%eax)
 a6f:	eb 08                	jmp    a79 <free+0xd7>
  } else
    p->s.ptr = bp;
 a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a74:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a77:	89 10                	mov    %edx,(%eax)
  freep = p;
 a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7c:	a3 78 10 00 00       	mov    %eax,0x1078
}
 a81:	c9                   	leave  
 a82:	c3                   	ret    

00000a83 <morecore>:

static Header*
morecore(uint nu)
{
 a83:	55                   	push   %ebp
 a84:	89 e5                	mov    %esp,%ebp
 a86:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a89:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a90:	77 07                	ja     a99 <morecore+0x16>
    nu = 4096;
 a92:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a99:	8b 45 08             	mov    0x8(%ebp),%eax
 a9c:	c1 e0 03             	shl    $0x3,%eax
 a9f:	89 04 24             	mov    %eax,(%esp)
 aa2:	e8 05 fc ff ff       	call   6ac <sbrk>
 aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 aaa:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aae:	75 07                	jne    ab7 <morecore+0x34>
    return 0;
 ab0:	b8 00 00 00 00       	mov    $0x0,%eax
 ab5:	eb 22                	jmp    ad9 <morecore+0x56>
  hp = (Header*)p;
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac0:	8b 55 08             	mov    0x8(%ebp),%edx
 ac3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac9:	83 c0 08             	add    $0x8,%eax
 acc:	89 04 24             	mov    %eax,(%esp)
 acf:	e8 ce fe ff ff       	call   9a2 <free>
  return freep;
 ad4:	a1 78 10 00 00       	mov    0x1078,%eax
}
 ad9:	c9                   	leave  
 ada:	c3                   	ret    

00000adb <malloc>:

void*
malloc(uint nbytes)
{
 adb:	55                   	push   %ebp
 adc:	89 e5                	mov    %esp,%ebp
 ade:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ae1:	8b 45 08             	mov    0x8(%ebp),%eax
 ae4:	83 c0 07             	add    $0x7,%eax
 ae7:	c1 e8 03             	shr    $0x3,%eax
 aea:	40                   	inc    %eax
 aeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 aee:	a1 78 10 00 00       	mov    0x1078,%eax
 af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 afa:	75 23                	jne    b1f <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 afc:	c7 45 f0 70 10 00 00 	movl   $0x1070,-0x10(%ebp)
 b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b06:	a3 78 10 00 00       	mov    %eax,0x1078
 b0b:	a1 78 10 00 00       	mov    0x1078,%eax
 b10:	a3 70 10 00 00       	mov    %eax,0x1070
    base.s.size = 0;
 b15:	c7 05 74 10 00 00 00 	movl   $0x0,0x1074
 b1c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b22:	8b 00                	mov    (%eax),%eax
 b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2a:	8b 40 04             	mov    0x4(%eax),%eax
 b2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b30:	72 4d                	jb     b7f <malloc+0xa4>
      if(p->s.size == nunits)
 b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b35:	8b 40 04             	mov    0x4(%eax),%eax
 b38:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b3b:	75 0c                	jne    b49 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	8b 10                	mov    (%eax),%edx
 b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b45:	89 10                	mov    %edx,(%eax)
 b47:	eb 26                	jmp    b6f <malloc+0x94>
      else {
        p->s.size -= nunits;
 b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4c:	8b 40 04             	mov    0x4(%eax),%eax
 b4f:	89 c2                	mov    %eax,%edx
 b51:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b57:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5d:	8b 40 04             	mov    0x4(%eax),%eax
 b60:	c1 e0 03             	shl    $0x3,%eax
 b63:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b6c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b72:	a3 78 10 00 00       	mov    %eax,0x1078
      return (void*)(p + 1);
 b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7a:	83 c0 08             	add    $0x8,%eax
 b7d:	eb 38                	jmp    bb7 <malloc+0xdc>
    }
    if(p == freep)
 b7f:	a1 78 10 00 00       	mov    0x1078,%eax
 b84:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b87:	75 1b                	jne    ba4 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b89:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b8c:	89 04 24             	mov    %eax,(%esp)
 b8f:	e8 ef fe ff ff       	call   a83 <morecore>
 b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b9b:	75 07                	jne    ba4 <malloc+0xc9>
        return 0;
 b9d:	b8 00 00 00 00       	mov    $0x0,%eax
 ba2:	eb 13                	jmp    bb7 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bad:	8b 00                	mov    (%eax),%eax
 baf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 bb2:	e9 70 ff ff ff       	jmp    b27 <malloc+0x4c>
}
 bb7:	c9                   	leave  
 bb8:	c3                   	ret    
