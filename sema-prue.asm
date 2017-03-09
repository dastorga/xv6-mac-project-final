
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
  15:	e8 c5 06 00 00       	call   6df <semget>
  1a:	a3 74 10 00 00       	mov    %eax,0x1074
  printf(1,"LOG semaforo: %d\n", semprod);
  1f:	a1 74 10 00 00       	mov    0x1074,%eax
  24:	89 44 24 08          	mov    %eax,0x8(%esp)
  28:	c7 44 24 04 b4 0b 00 	movl   $0xbb4,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 b3 07 00 00       	call   7ef <printf>
  if(semprod < 0){
  3c:	a1 74 10 00 00       	mov    0x1074,%eax
  41:	85 c0                	test   %eax,%eax
  43:	79 19                	jns    5e <test_0+0x5e>
    printf(1,"invalid semprod \n");
  45:	c7 44 24 04 c6 0b 00 	movl   $0xbc6,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 96 07 00 00       	call   7ef <printf>
    exit();
  59:	e8 c1 05 00 00       	call   61f <exit>
  }
  semcom = semget(-1,0);   
  5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  65:	00 
  66:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  6d:	e8 6d 06 00 00       	call   6df <semget>
  72:	a3 80 10 00 00       	mov    %eax,0x1080
  printf(1,"LOG semaforo: %d\n", semcom);
  77:	a1 80 10 00 00       	mov    0x1080,%eax
  7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  80:	c7 44 24 04 b4 0b 00 	movl   $0xbb4,0x4(%esp)
  87:	00 
  88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8f:	e8 5b 07 00 00       	call   7ef <printf>
  if(semcom < 0){
  94:	a1 80 10 00 00       	mov    0x1080,%eax
  99:	85 c0                	test   %eax,%eax
  9b:	79 19                	jns    b6 <test_0+0xb6>
    printf(1,"invalid semcom\n");
  9d:	c7 44 24 04 d8 0b 00 	movl   $0xbd8,0x4(%esp)
  a4:	00 
  a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ac:	e8 3e 07 00 00       	call   7ef <printf>
    exit();
  b1:	e8 69 05 00 00       	call   61f <exit>
  }
  sembuff = semget(-1,1); 
  b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  bd:	00 
  be:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  c5:	e8 15 06 00 00       	call   6df <semget>
  ca:	a3 7c 10 00 00       	mov    %eax,0x107c
  printf(1,"LOG semaforo: %d\n", sembuff);
  cf:	a1 7c 10 00 00       	mov    0x107c,%eax
  d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  d8:	c7 44 24 04 b4 0b 00 	movl   $0xbb4,0x4(%esp)
  df:	00 
  e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e7:	e8 03 07 00 00       	call   7ef <printf>
  if(sembuff < 0){
  ec:	a1 7c 10 00 00       	mov    0x107c,%eax
  f1:	85 c0                	test   %eax,%eax
  f3:	79 19                	jns    10e <test_0+0x10e>
    printf(1,"invalid sembuff\n");
  f5:	c7 44 24 04 e8 0b 00 	movl   $0xbe8,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 104:	e8 e6 06 00 00       	call   7ef <printf>
    exit();
 109:	e8 11 05 00 00       	call   61f <exit>
  }
  semprueba1 = semget(-1,5); 
 10e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
 115:	00 
 116:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 11d:	e8 bd 05 00 00       	call   6df <semget>
 122:	a3 84 10 00 00       	mov    %eax,0x1084
  printf(1,"LOG: semaforo: %d\n", semprueba1); 
 127:	a1 84 10 00 00       	mov    0x1084,%eax
 12c:	89 44 24 08          	mov    %eax,0x8(%esp)
 130:	c7 44 24 04 f9 0b 00 	movl   $0xbf9,0x4(%esp)
 137:	00 
 138:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13f:	e8 ab 06 00 00       	call   7ef <printf>
  if(semprueba1 < 0){
 144:	a1 84 10 00 00       	mov    0x1084,%eax
 149:	85 c0                	test   %eax,%eax
 14b:	79 19                	jns    166 <test_0+0x166>
    printf(1,"invalid semprueba1\n");
 14d:	c7 44 24 04 0c 0c 00 	movl   $0xc0c,0x4(%esp)
 154:	00 
 155:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15c:	e8 8e 06 00 00       	call   7ef <printf>
    exit();
 161:	e8 b9 04 00 00       	call   61f <exit>
  }

  semprueba2 = semget(-1,6); 
 166:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
 16d:	00 
 16e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 175:	e8 65 05 00 00       	call   6df <semget>
 17a:	a3 78 10 00 00       	mov    %eax,0x1078
  printf(1,"LOG: semaforo: %d\n", semprueba2); 
 17f:	a1 78 10 00 00       	mov    0x1078,%eax
 184:	89 44 24 08          	mov    %eax,0x8(%esp)
 188:	c7 44 24 04 f9 0b 00 	movl   $0xbf9,0x4(%esp)
 18f:	00 
 190:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 197:	e8 53 06 00 00       	call   7ef <printf>
  if(semprueba2 == -2){
 19c:	a1 78 10 00 00       	mov    0x1078,%eax
 1a1:	83 f8 fe             	cmp    $0xfffffffe,%eax
 1a4:	75 19                	jne    1bf <test_0+0x1bf>
    printf(1,"ERROR el proceso corriente ya obtuvo el numero maximo de semaforos\n");
 1a6:	c7 44 24 04 20 0c 00 	movl   $0xc20,0x4(%esp)
 1ad:	00 
 1ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1b5:	e8 35 06 00 00       	call   7ef <printf>
    exit();
 1ba:	e8 60 04 00 00       	call   61f <exit>
  }
  if(semprueba2 == -3){
 1bf:	a1 78 10 00 00       	mov    0x1078,%eax
 1c4:	83 f8 fd             	cmp    $0xfffffffd,%eax
 1c7:	75 19                	jne    1e2 <test_0+0x1e2>
    printf(1,"ERROR no ahi mas semaforos disponibles en el sistema\n");
 1c9:	c7 44 24 04 64 0c 00 	movl   $0xc64,0x4(%esp)
 1d0:	00 
 1d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1d8:	e8 12 06 00 00       	call   7ef <printf>
    exit();
 1dd:	e8 3d 04 00 00       	call   61f <exit>
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
 1f9:	e8 e1 04 00 00       	call   6df <semget>
 1fe:	a3 74 10 00 00       	mov    %eax,0x1074
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
 203:	a1 74 10 00 00       	mov    0x1074,%eax
 208:	89 44 24 08          	mov    %eax,0x8(%esp)
 20c:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 213:	00 
 214:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 21b:	e8 cf 05 00 00       	call   7ef <printf>
  if(semprod < 0){
 220:	a1 74 10 00 00       	mov    0x1074,%eax
 225:	85 c0                	test   %eax,%eax
 227:	79 19                	jns    242 <test_1+0x5e>
    printf(1,"Error! en la creacion del semaforo\n");
 229:	c7 44 24 04 cc 0c 00 	movl   $0xccc,0x4(%esp)
 230:	00 
 231:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 238:	e8 b2 05 00 00       	call   7ef <printf>
    exit();
 23d:	e8 dd 03 00 00       	call   61f <exit>
  }

  res = semget(1,0); // le paso el identificador 1, y el unico semaforo creado que tengo es con identificador 0
 242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 249:	00 
 24a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 251:	e8 89 04 00 00       	call   6df <semget>
 256:	a3 88 10 00 00       	mov    %eax,0x1088
  if(res == -1){
 25b:	a1 88 10 00 00       	mov    0x1088,%eax
 260:	83 f8 ff             	cmp    $0xffffffff,%eax
 263:	75 19                	jne    27e <test_1+0x9a>
    printf(1,"ERROR, el semaforo con ese identificador no esta en uso\n");
 265:	c7 44 24 04 f0 0c 00 	movl   $0xcf0,0x4(%esp)
 26c:	00 
 26d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 274:	e8 76 05 00 00       	call   7ef <printf>
    exit();
 279:	e8 a1 03 00 00       	call   61f <exit>
  }
  if(res == -2){
 27e:	a1 88 10 00 00       	mov    0x1088,%eax
 283:	83 f8 fe             	cmp    $0xfffffffe,%eax
 286:	75 19                	jne    2a1 <test_1+0xbd>
    printf(1,"ERROR, el proceso ya obtuvo el maximo de semaforos\n");
 288:	c7 44 24 04 2c 0d 00 	movl   $0xd2c,0x4(%esp)
 28f:	00 
 290:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 297:	e8 53 05 00 00       	call   7ef <printf>
    exit();
 29c:	e8 7e 03 00 00       	call   61f <exit>
  }
  printf(1,"El identificador del semaforo obtenido es: %d\n", res);
 2a1:	a1 88 10 00 00       	mov    0x1088,%eax
 2a6:	89 44 24 08          	mov    %eax,0x8(%esp)
 2aa:	c7 44 24 04 60 0d 00 	movl   $0xd60,0x4(%esp)
 2b1:	00 
 2b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b9:	e8 31 05 00 00       	call   7ef <printf>
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
 2d5:	e8 05 04 00 00       	call   6df <semget>
 2da:	a3 74 10 00 00       	mov    %eax,0x1074
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
 2df:	a1 74 10 00 00       	mov    0x1074,%eax
 2e4:	89 44 24 08          	mov    %eax,0x8(%esp)
 2e8:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 2ef:	00 
 2f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2f7:	e8 f3 04 00 00       	call   7ef <printf>
  if(semprod < 0){
 2fc:	a1 74 10 00 00       	mov    0x1074,%eax
 301:	85 c0                	test   %eax,%eax
 303:	79 19                	jns    31e <test_2+0x5e>
    printf(1,"Error! en la creacion del semaforo\n");
 305:	c7 44 24 04 cc 0c 00 	movl   $0xccc,0x4(%esp)
 30c:	00 
 30d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 314:	e8 d6 04 00 00       	call   7ef <printf>
    exit();
 319:	e8 01 03 00 00       	call   61f <exit>
  }

}
 31e:	c9                   	leave  
 31f:	c3                   	ret    

00000320 <test_3>:

// Test_3: verifico que a la hora de obtener el semaforo no aunmente el semquantity (quenada tiene que ver)
void
test_3(){
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	83 ec 18             	sub    $0x18,%esp
  semprod = semget(-1,4); 
 326:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 32d:	00 
 32e:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 335:	e8 a5 03 00 00       	call   6df <semget>
 33a:	a3 74 10 00 00       	mov    %eax,0x1074
  printf(1,"El identificador del semaforo creado es: %d\n", semprod);
 33f:	a1 74 10 00 00       	mov    0x1074,%eax
 344:	89 44 24 08          	mov    %eax,0x8(%esp)
 348:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
 34f:	00 
 350:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 357:	e8 93 04 00 00       	call   7ef <printf>
  if(semprod < 0){
 35c:	a1 74 10 00 00       	mov    0x1074,%eax
 361:	85 c0                	test   %eax,%eax
 363:	79 19                	jns    37e <test_3+0x5e>
    printf(1,"Error! en la creacion del semaforo\n");
 365:	c7 44 24 04 cc 0c 00 	movl   $0xccc,0x4(%esp)
 36c:	00 
 36d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 374:	e8 76 04 00 00       	call   7ef <printf>
    exit();
 379:	e8 a1 02 00 00       	call   61f <exit>
  }
  // lo obtengo tres veces
  semprod = semget(0,4); 
 37e:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 385:	00 
 386:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 38d:	e8 4d 03 00 00       	call   6df <semget>
 392:	a3 74 10 00 00       	mov    %eax,0x1074
  semprod = semget(0,4); 
 397:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 39e:	00 
 39f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3a6:	e8 34 03 00 00       	call   6df <semget>
 3ab:	a3 74 10 00 00       	mov    %eax,0x1074
  semprod = semget(0,4); 
 3b0:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 3b7:	00 
 3b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 3bf:	e8 1b 03 00 00       	call   6df <semget>
 3c4:	a3 74 10 00 00       	mov    %eax,0x1074
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
  //test_3();

  exit();
 3d1:	e8 49 02 00 00       	call   61f <exit>

000003d6 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	57                   	push   %edi
 3da:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3db:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3de:	8b 55 10             	mov    0x10(%ebp),%edx
 3e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e4:	89 cb                	mov    %ecx,%ebx
 3e6:	89 df                	mov    %ebx,%edi
 3e8:	89 d1                	mov    %edx,%ecx
 3ea:	fc                   	cld    
 3eb:	f3 aa                	rep stos %al,%es:(%edi)
 3ed:	89 ca                	mov    %ecx,%edx
 3ef:	89 fb                	mov    %edi,%ebx
 3f1:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3f4:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 3f7:	5b                   	pop    %ebx
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    

000003fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 3fb:	55                   	push   %ebp
 3fc:	89 e5                	mov    %esp,%ebp
 3fe:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 407:	90                   	nop
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	8a 10                	mov    (%eax),%dl
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	88 10                	mov    %dl,(%eax)
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	8a 00                	mov    (%eax),%al
 417:	84 c0                	test   %al,%al
 419:	0f 95 c0             	setne  %al
 41c:	ff 45 08             	incl   0x8(%ebp)
 41f:	ff 45 0c             	incl   0xc(%ebp)
 422:	84 c0                	test   %al,%al
 424:	75 e2                	jne    408 <strcpy+0xd>
    ;
  return os;
 426:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 42b:	55                   	push   %ebp
 42c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 42e:	eb 06                	jmp    436 <strcmp+0xb>
    p++, q++;
 430:	ff 45 08             	incl   0x8(%ebp)
 433:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	8a 00                	mov    (%eax),%al
 43b:	84 c0                	test   %al,%al
 43d:	74 0e                	je     44d <strcmp+0x22>
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	8a 10                	mov    (%eax),%dl
 444:	8b 45 0c             	mov    0xc(%ebp),%eax
 447:	8a 00                	mov    (%eax),%al
 449:	38 c2                	cmp    %al,%dl
 44b:	74 e3                	je     430 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	8a 00                	mov    (%eax),%al
 452:	0f b6 d0             	movzbl %al,%edx
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	8a 00                	mov    (%eax),%al
 45a:	0f b6 c0             	movzbl %al,%eax
 45d:	89 d1                	mov    %edx,%ecx
 45f:	29 c1                	sub    %eax,%ecx
 461:	89 c8                	mov    %ecx,%eax
}
 463:	5d                   	pop    %ebp
 464:	c3                   	ret    

00000465 <strlen>:

uint
strlen(char *s)
{
 465:	55                   	push   %ebp
 466:	89 e5                	mov    %esp,%ebp
 468:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 46b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 472:	eb 03                	jmp    477 <strlen+0x12>
 474:	ff 45 fc             	incl   -0x4(%ebp)
 477:	8b 55 fc             	mov    -0x4(%ebp),%edx
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	01 d0                	add    %edx,%eax
 47f:	8a 00                	mov    (%eax),%al
 481:	84 c0                	test   %al,%al
 483:	75 ef                	jne    474 <strlen+0xf>
    ;
  return n;
 485:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 488:	c9                   	leave  
 489:	c3                   	ret    

0000048a <memset>:

void*
memset(void *dst, int c, uint n)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 490:	8b 45 10             	mov    0x10(%ebp),%eax
 493:	89 44 24 08          	mov    %eax,0x8(%esp)
 497:	8b 45 0c             	mov    0xc(%ebp),%eax
 49a:	89 44 24 04          	mov    %eax,0x4(%esp)
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	89 04 24             	mov    %eax,(%esp)
 4a4:	e8 2d ff ff ff       	call   3d6 <stosb>
  return dst;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <strchr>:

char*
strchr(const char *s, char c)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 04             	sub    $0x4,%esp
 4b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 4ba:	eb 12                	jmp    4ce <strchr+0x20>
    if(*s == c)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	8a 00                	mov    (%eax),%al
 4c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 4c4:	75 05                	jne    4cb <strchr+0x1d>
      return (char*)s;
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	eb 11                	jmp    4dc <strchr+0x2e>
  for(; *s; s++)
 4cb:	ff 45 08             	incl   0x8(%ebp)
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	8a 00                	mov    (%eax),%al
 4d3:	84 c0                	test   %al,%al
 4d5:	75 e5                	jne    4bc <strchr+0xe>
  return 0;
 4d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4dc:	c9                   	leave  
 4dd:	c3                   	ret    

000004de <gets>:

char*
gets(char *buf, int max)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 4eb:	eb 42                	jmp    52f <gets+0x51>
    cc = read(0, &c, 1);
 4ed:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f4:	00 
 4f5:	8d 45 ef             	lea    -0x11(%ebp),%eax
 4f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 503:	e8 2f 01 00 00       	call   637 <read>
 508:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 50b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50f:	7e 29                	jle    53a <gets+0x5c>
      break;
    buf[i++] = c;
 511:	8b 55 f4             	mov    -0xc(%ebp),%edx
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	01 c2                	add    %eax,%edx
 519:	8a 45 ef             	mov    -0x11(%ebp),%al
 51c:	88 02                	mov    %al,(%edx)
 51e:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 521:	8a 45 ef             	mov    -0x11(%ebp),%al
 524:	3c 0a                	cmp    $0xa,%al
 526:	74 13                	je     53b <gets+0x5d>
 528:	8a 45 ef             	mov    -0x11(%ebp),%al
 52b:	3c 0d                	cmp    $0xd,%al
 52d:	74 0c                	je     53b <gets+0x5d>
  for(i=0; i+1 < max; ){
 52f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 532:	40                   	inc    %eax
 533:	3b 45 0c             	cmp    0xc(%ebp),%eax
 536:	7c b5                	jl     4ed <gets+0xf>
 538:	eb 01                	jmp    53b <gets+0x5d>
      break;
 53a:	90                   	nop
      break;
  }
  buf[i] = '\0';
 53b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	01 d0                	add    %edx,%eax
 543:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 546:	8b 45 08             	mov    0x8(%ebp),%eax
}
 549:	c9                   	leave  
 54a:	c3                   	ret    

0000054b <stat>:

int
stat(char *n, struct stat *st)
{
 54b:	55                   	push   %ebp
 54c:	89 e5                	mov    %esp,%ebp
 54e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 551:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 558:	00 
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	89 04 24             	mov    %eax,(%esp)
 55f:	e8 fb 00 00 00       	call   65f <open>
 564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56b:	79 07                	jns    574 <stat+0x29>
    return -1;
 56d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 572:	eb 23                	jmp    597 <stat+0x4c>
  r = fstat(fd, st);
 574:	8b 45 0c             	mov    0xc(%ebp),%eax
 577:	89 44 24 04          	mov    %eax,0x4(%esp)
 57b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57e:	89 04 24             	mov    %eax,(%esp)
 581:	e8 f1 00 00 00       	call   677 <fstat>
 586:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 589:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 b3 00 00 00       	call   647 <close>
  return r;
 594:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 597:	c9                   	leave  
 598:	c3                   	ret    

00000599 <atoi>:

int
atoi(const char *s)
{
 599:	55                   	push   %ebp
 59a:	89 e5                	mov    %esp,%ebp
 59c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 59f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 5a6:	eb 21                	jmp    5c9 <atoi+0x30>
    n = n*10 + *s++ - '0';
 5a8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5ab:	89 d0                	mov    %edx,%eax
 5ad:	c1 e0 02             	shl    $0x2,%eax
 5b0:	01 d0                	add    %edx,%eax
 5b2:	d1 e0                	shl    %eax
 5b4:	89 c2                	mov    %eax,%edx
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
 5b9:	8a 00                	mov    (%eax),%al
 5bb:	0f be c0             	movsbl %al,%eax
 5be:	01 d0                	add    %edx,%eax
 5c0:	83 e8 30             	sub    $0x30,%eax
 5c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c6:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 5c9:	8b 45 08             	mov    0x8(%ebp),%eax
 5cc:	8a 00                	mov    (%eax),%al
 5ce:	3c 2f                	cmp    $0x2f,%al
 5d0:	7e 09                	jle    5db <atoi+0x42>
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	8a 00                	mov    (%eax),%al
 5d7:	3c 39                	cmp    $0x39,%al
 5d9:	7e cd                	jle    5a8 <atoi+0xf>
  return n;
 5db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5de:	c9                   	leave  
 5df:	c3                   	ret    

000005e0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5e6:	8b 45 08             	mov    0x8(%ebp),%eax
 5e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 5ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5f2:	eb 10                	jmp    604 <memmove+0x24>
    *dst++ = *src++;
 5f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f7:	8a 10                	mov    (%eax),%dl
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	88 10                	mov    %dl,(%eax)
 5fe:	ff 45 fc             	incl   -0x4(%ebp)
 601:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 604:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 608:	0f 9f c0             	setg   %al
 60b:	ff 4d 10             	decl   0x10(%ebp)
 60e:	84 c0                	test   %al,%al
 610:	75 e2                	jne    5f4 <memmove+0x14>
  return vdst;
 612:	8b 45 08             	mov    0x8(%ebp),%eax
}
 615:	c9                   	leave  
 616:	c3                   	ret    

00000617 <fork>:
 617:	b8 01 00 00 00       	mov    $0x1,%eax
 61c:	cd 40                	int    $0x40
 61e:	c3                   	ret    

0000061f <exit>:
 61f:	b8 02 00 00 00       	mov    $0x2,%eax
 624:	cd 40                	int    $0x40
 626:	c3                   	ret    

00000627 <wait>:
 627:	b8 03 00 00 00       	mov    $0x3,%eax
 62c:	cd 40                	int    $0x40
 62e:	c3                   	ret    

0000062f <pipe>:
 62f:	b8 04 00 00 00       	mov    $0x4,%eax
 634:	cd 40                	int    $0x40
 636:	c3                   	ret    

00000637 <read>:
 637:	b8 05 00 00 00       	mov    $0x5,%eax
 63c:	cd 40                	int    $0x40
 63e:	c3                   	ret    

0000063f <write>:
 63f:	b8 10 00 00 00       	mov    $0x10,%eax
 644:	cd 40                	int    $0x40
 646:	c3                   	ret    

00000647 <close>:
 647:	b8 15 00 00 00       	mov    $0x15,%eax
 64c:	cd 40                	int    $0x40
 64e:	c3                   	ret    

0000064f <kill>:
 64f:	b8 06 00 00 00       	mov    $0x6,%eax
 654:	cd 40                	int    $0x40
 656:	c3                   	ret    

00000657 <exec>:
 657:	b8 07 00 00 00       	mov    $0x7,%eax
 65c:	cd 40                	int    $0x40
 65e:	c3                   	ret    

0000065f <open>:
 65f:	b8 0f 00 00 00       	mov    $0xf,%eax
 664:	cd 40                	int    $0x40
 666:	c3                   	ret    

00000667 <mknod>:
 667:	b8 11 00 00 00       	mov    $0x11,%eax
 66c:	cd 40                	int    $0x40
 66e:	c3                   	ret    

0000066f <unlink>:
 66f:	b8 12 00 00 00       	mov    $0x12,%eax
 674:	cd 40                	int    $0x40
 676:	c3                   	ret    

00000677 <fstat>:
 677:	b8 08 00 00 00       	mov    $0x8,%eax
 67c:	cd 40                	int    $0x40
 67e:	c3                   	ret    

0000067f <link>:
 67f:	b8 13 00 00 00       	mov    $0x13,%eax
 684:	cd 40                	int    $0x40
 686:	c3                   	ret    

00000687 <mkdir>:
 687:	b8 14 00 00 00       	mov    $0x14,%eax
 68c:	cd 40                	int    $0x40
 68e:	c3                   	ret    

0000068f <chdir>:
 68f:	b8 09 00 00 00       	mov    $0x9,%eax
 694:	cd 40                	int    $0x40
 696:	c3                   	ret    

00000697 <dup>:
 697:	b8 0a 00 00 00       	mov    $0xa,%eax
 69c:	cd 40                	int    $0x40
 69e:	c3                   	ret    

0000069f <getpid>:
 69f:	b8 0b 00 00 00       	mov    $0xb,%eax
 6a4:	cd 40                	int    $0x40
 6a6:	c3                   	ret    

000006a7 <sbrk>:
 6a7:	b8 0c 00 00 00       	mov    $0xc,%eax
 6ac:	cd 40                	int    $0x40
 6ae:	c3                   	ret    

000006af <sleep>:
 6af:	b8 0d 00 00 00       	mov    $0xd,%eax
 6b4:	cd 40                	int    $0x40
 6b6:	c3                   	ret    

000006b7 <uptime>:
 6b7:	b8 0e 00 00 00       	mov    $0xe,%eax
 6bc:	cd 40                	int    $0x40
 6be:	c3                   	ret    

000006bf <lseek>:
 6bf:	b8 16 00 00 00       	mov    $0x16,%eax
 6c4:	cd 40                	int    $0x40
 6c6:	c3                   	ret    

000006c7 <isatty>:
 6c7:	b8 17 00 00 00       	mov    $0x17,%eax
 6cc:	cd 40                	int    $0x40
 6ce:	c3                   	ret    

000006cf <procstat>:
 6cf:	b8 18 00 00 00       	mov    $0x18,%eax
 6d4:	cd 40                	int    $0x40
 6d6:	c3                   	ret    

000006d7 <set_priority>:
 6d7:	b8 19 00 00 00       	mov    $0x19,%eax
 6dc:	cd 40                	int    $0x40
 6de:	c3                   	ret    

000006df <semget>:
 6df:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6e4:	cd 40                	int    $0x40
 6e6:	c3                   	ret    

000006e7 <semfree>:
 6e7:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6ec:	cd 40                	int    $0x40
 6ee:	c3                   	ret    

000006ef <semdown>:
 6ef:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6f4:	cd 40                	int    $0x40
 6f6:	c3                   	ret    

000006f7 <semup>:
 6f7:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6fc:	cd 40                	int    $0x40
 6fe:	c3                   	ret    

000006ff <shm_create>:
 6ff:	b8 1e 00 00 00       	mov    $0x1e,%eax
 704:	cd 40                	int    $0x40
 706:	c3                   	ret    

00000707 <shm_close>:
 707:	b8 1f 00 00 00       	mov    $0x1f,%eax
 70c:	cd 40                	int    $0x40
 70e:	c3                   	ret    

0000070f <shm_get>:
 70f:	b8 20 00 00 00       	mov    $0x20,%eax
 714:	cd 40                	int    $0x40
 716:	c3                   	ret    

00000717 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 717:	55                   	push   %ebp
 718:	89 e5                	mov    %esp,%ebp
 71a:	83 ec 28             	sub    $0x28,%esp
 71d:	8b 45 0c             	mov    0xc(%ebp),%eax
 720:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 723:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 72a:	00 
 72b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 72e:	89 44 24 04          	mov    %eax,0x4(%esp)
 732:	8b 45 08             	mov    0x8(%ebp),%eax
 735:	89 04 24             	mov    %eax,(%esp)
 738:	e8 02 ff ff ff       	call   63f <write>
}
 73d:	c9                   	leave  
 73e:	c3                   	ret    

0000073f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73f:	55                   	push   %ebp
 740:	89 e5                	mov    %esp,%ebp
 742:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 745:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 74c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 750:	74 17                	je     769 <printint+0x2a>
 752:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 756:	79 11                	jns    769 <printint+0x2a>
    neg = 1;
 758:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 75f:	8b 45 0c             	mov    0xc(%ebp),%eax
 762:	f7 d8                	neg    %eax
 764:	89 45 ec             	mov    %eax,-0x14(%ebp)
 767:	eb 06                	jmp    76f <printint+0x30>
  } else {
    x = xx;
 769:	8b 45 0c             	mov    0xc(%ebp),%eax
 76c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 76f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 776:	8b 4d 10             	mov    0x10(%ebp),%ecx
 779:	8b 45 ec             	mov    -0x14(%ebp),%eax
 77c:	ba 00 00 00 00       	mov    $0x0,%edx
 781:	f7 f1                	div    %ecx
 783:	89 d0                	mov    %edx,%eax
 785:	8a 80 54 10 00 00    	mov    0x1054(%eax),%al
 78b:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 78e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 791:	01 ca                	add    %ecx,%edx
 793:	88 02                	mov    %al,(%edx)
 795:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 798:	8b 55 10             	mov    0x10(%ebp),%edx
 79b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 79e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a1:	ba 00 00 00 00       	mov    $0x0,%edx
 7a6:	f7 75 d4             	divl   -0x2c(%ebp)
 7a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7b0:	75 c4                	jne    776 <printint+0x37>
  if(neg)
 7b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b6:	74 2c                	je     7e4 <printint+0xa5>
    buf[i++] = '-';
 7b8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7be:	01 d0                	add    %edx,%eax
 7c0:	c6 00 2d             	movb   $0x2d,(%eax)
 7c3:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 7c6:	eb 1c                	jmp    7e4 <printint+0xa5>
    putc(fd, buf[i]);
 7c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	01 d0                	add    %edx,%eax
 7d0:	8a 00                	mov    (%eax),%al
 7d2:	0f be c0             	movsbl %al,%eax
 7d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	89 04 24             	mov    %eax,(%esp)
 7df:	e8 33 ff ff ff       	call   717 <putc>
  while(--i >= 0)
 7e4:	ff 4d f4             	decl   -0xc(%ebp)
 7e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7eb:	79 db                	jns    7c8 <printint+0x89>
}
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7fc:	8d 45 0c             	lea    0xc(%ebp),%eax
 7ff:	83 c0 04             	add    $0x4,%eax
 802:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 805:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80c:	e9 78 01 00 00       	jmp    989 <printf+0x19a>
    c = fmt[i] & 0xff;
 811:	8b 55 0c             	mov    0xc(%ebp),%edx
 814:	8b 45 f0             	mov    -0x10(%ebp),%eax
 817:	01 d0                	add    %edx,%eax
 819:	8a 00                	mov    (%eax),%al
 81b:	0f be c0             	movsbl %al,%eax
 81e:	25 ff 00 00 00       	and    $0xff,%eax
 823:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 826:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82a:	75 2c                	jne    858 <printf+0x69>
      if(c == '%'){
 82c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 830:	75 0c                	jne    83e <printf+0x4f>
        state = '%';
 832:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 839:	e9 48 01 00 00       	jmp    986 <printf+0x197>
      } else {
        putc(fd, c);
 83e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 841:	0f be c0             	movsbl %al,%eax
 844:	89 44 24 04          	mov    %eax,0x4(%esp)
 848:	8b 45 08             	mov    0x8(%ebp),%eax
 84b:	89 04 24             	mov    %eax,(%esp)
 84e:	e8 c4 fe ff ff       	call   717 <putc>
 853:	e9 2e 01 00 00       	jmp    986 <printf+0x197>
      }
    } else if(state == '%'){
 858:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 85c:	0f 85 24 01 00 00    	jne    986 <printf+0x197>
      if(c == 'd'){
 862:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 866:	75 2d                	jne    895 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 868:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86b:	8b 00                	mov    (%eax),%eax
 86d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 874:	00 
 875:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 87c:	00 
 87d:	89 44 24 04          	mov    %eax,0x4(%esp)
 881:	8b 45 08             	mov    0x8(%ebp),%eax
 884:	89 04 24             	mov    %eax,(%esp)
 887:	e8 b3 fe ff ff       	call   73f <printint>
        ap++;
 88c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 890:	e9 ea 00 00 00       	jmp    97f <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 895:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 899:	74 06                	je     8a1 <printf+0xb2>
 89b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 89f:	75 2d                	jne    8ce <printf+0xdf>
        printint(fd, *ap, 16, 0);
 8a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 8ad:	00 
 8ae:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8b5:	00 
 8b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ba:	8b 45 08             	mov    0x8(%ebp),%eax
 8bd:	89 04 24             	mov    %eax,(%esp)
 8c0:	e8 7a fe ff ff       	call   73f <printint>
        ap++;
 8c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c9:	e9 b1 00 00 00       	jmp    97f <printf+0x190>
      } else if(c == 's'){
 8ce:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8d2:	75 43                	jne    917 <printf+0x128>
        s = (char*)*ap;
 8d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e4:	75 25                	jne    90b <printf+0x11c>
          s = "(null)";
 8e6:	c7 45 f4 8f 0d 00 00 	movl   $0xd8f,-0xc(%ebp)
        while(*s != 0){
 8ed:	eb 1c                	jmp    90b <printf+0x11c>
          putc(fd, *s);
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	8a 00                	mov    (%eax),%al
 8f4:	0f be c0             	movsbl %al,%eax
 8f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	89 04 24             	mov    %eax,(%esp)
 901:	e8 11 fe ff ff       	call   717 <putc>
          s++;
 906:	ff 45 f4             	incl   -0xc(%ebp)
 909:	eb 01                	jmp    90c <printf+0x11d>
        while(*s != 0){
 90b:	90                   	nop
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	8a 00                	mov    (%eax),%al
 911:	84 c0                	test   %al,%al
 913:	75 da                	jne    8ef <printf+0x100>
 915:	eb 68                	jmp    97f <printf+0x190>
        }
      } else if(c == 'c'){
 917:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 91b:	75 1d                	jne    93a <printf+0x14b>
        putc(fd, *ap);
 91d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 920:	8b 00                	mov    (%eax),%eax
 922:	0f be c0             	movsbl %al,%eax
 925:	89 44 24 04          	mov    %eax,0x4(%esp)
 929:	8b 45 08             	mov    0x8(%ebp),%eax
 92c:	89 04 24             	mov    %eax,(%esp)
 92f:	e8 e3 fd ff ff       	call   717 <putc>
        ap++;
 934:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 938:	eb 45                	jmp    97f <printf+0x190>
      } else if(c == '%'){
 93a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 93e:	75 17                	jne    957 <printf+0x168>
        putc(fd, c);
 940:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 943:	0f be c0             	movsbl %al,%eax
 946:	89 44 24 04          	mov    %eax,0x4(%esp)
 94a:	8b 45 08             	mov    0x8(%ebp),%eax
 94d:	89 04 24             	mov    %eax,(%esp)
 950:	e8 c2 fd ff ff       	call   717 <putc>
 955:	eb 28                	jmp    97f <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 957:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 95e:	00 
 95f:	8b 45 08             	mov    0x8(%ebp),%eax
 962:	89 04 24             	mov    %eax,(%esp)
 965:	e8 ad fd ff ff       	call   717 <putc>
        putc(fd, c);
 96a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 96d:	0f be c0             	movsbl %al,%eax
 970:	89 44 24 04          	mov    %eax,0x4(%esp)
 974:	8b 45 08             	mov    0x8(%ebp),%eax
 977:	89 04 24             	mov    %eax,(%esp)
 97a:	e8 98 fd ff ff       	call   717 <putc>
      }
      state = 0;
 97f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 986:	ff 45 f0             	incl   -0x10(%ebp)
 989:	8b 55 0c             	mov    0xc(%ebp),%edx
 98c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98f:	01 d0                	add    %edx,%eax
 991:	8a 00                	mov    (%eax),%al
 993:	84 c0                	test   %al,%al
 995:	0f 85 76 fe ff ff    	jne    811 <printf+0x22>
    }
  }
}
 99b:	c9                   	leave  
 99c:	c3                   	ret    

0000099d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 99d:	55                   	push   %ebp
 99e:	89 e5                	mov    %esp,%ebp
 9a0:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	83 e8 08             	sub    $0x8,%eax
 9a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ac:	a1 70 10 00 00       	mov    0x1070,%eax
 9b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9b4:	eb 24                	jmp    9da <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b9:	8b 00                	mov    (%eax),%eax
 9bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9be:	77 12                	ja     9d2 <free+0x35>
 9c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c6:	77 24                	ja     9ec <free+0x4f>
 9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cb:	8b 00                	mov    (%eax),%eax
 9cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d0:	77 1a                	ja     9ec <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d5:	8b 00                	mov    (%eax),%eax
 9d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9dd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e0:	76 d4                	jbe    9b6 <free+0x19>
 9e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e5:	8b 00                	mov    (%eax),%eax
 9e7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9ea:	76 ca                	jbe    9b6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ef:	8b 40 04             	mov    0x4(%eax),%eax
 9f2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fc:	01 c2                	add    %eax,%edx
 9fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a01:	8b 00                	mov    (%eax),%eax
 a03:	39 c2                	cmp    %eax,%edx
 a05:	75 24                	jne    a2b <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0a:	8b 50 04             	mov    0x4(%eax),%edx
 a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a10:	8b 00                	mov    (%eax),%eax
 a12:	8b 40 04             	mov    0x4(%eax),%eax
 a15:	01 c2                	add    %eax,%edx
 a17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1a:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a20:	8b 00                	mov    (%eax),%eax
 a22:	8b 10                	mov    (%eax),%edx
 a24:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a27:	89 10                	mov    %edx,(%eax)
 a29:	eb 0a                	jmp    a35 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2e:	8b 10                	mov    (%eax),%edx
 a30:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a33:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a38:	8b 40 04             	mov    0x4(%eax),%eax
 a3b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a45:	01 d0                	add    %edx,%eax
 a47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a4a:	75 20                	jne    a6c <free+0xcf>
    p->s.size += bp->s.size;
 a4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4f:	8b 50 04             	mov    0x4(%eax),%edx
 a52:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a55:	8b 40 04             	mov    0x4(%eax),%eax
 a58:	01 c2                	add    %eax,%edx
 a5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a63:	8b 10                	mov    (%eax),%edx
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	89 10                	mov    %edx,(%eax)
 a6a:	eb 08                	jmp    a74 <free+0xd7>
  } else
    p->s.ptr = bp;
 a6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a72:	89 10                	mov    %edx,(%eax)
  freep = p;
 a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a77:	a3 70 10 00 00       	mov    %eax,0x1070
}
 a7c:	c9                   	leave  
 a7d:	c3                   	ret    

00000a7e <morecore>:

static Header*
morecore(uint nu)
{
 a7e:	55                   	push   %ebp
 a7f:	89 e5                	mov    %esp,%ebp
 a81:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a84:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a8b:	77 07                	ja     a94 <morecore+0x16>
    nu = 4096;
 a8d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a94:	8b 45 08             	mov    0x8(%ebp),%eax
 a97:	c1 e0 03             	shl    $0x3,%eax
 a9a:	89 04 24             	mov    %eax,(%esp)
 a9d:	e8 05 fc ff ff       	call   6a7 <sbrk>
 aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 aa5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 aa9:	75 07                	jne    ab2 <morecore+0x34>
    return 0;
 aab:	b8 00 00 00 00       	mov    $0x0,%eax
 ab0:	eb 22                	jmp    ad4 <morecore+0x56>
  hp = (Header*)p;
 ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 abb:	8b 55 08             	mov    0x8(%ebp),%edx
 abe:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac4:	83 c0 08             	add    $0x8,%eax
 ac7:	89 04 24             	mov    %eax,(%esp)
 aca:	e8 ce fe ff ff       	call   99d <free>
  return freep;
 acf:	a1 70 10 00 00       	mov    0x1070,%eax
}
 ad4:	c9                   	leave  
 ad5:	c3                   	ret    

00000ad6 <malloc>:

void*
malloc(uint nbytes)
{
 ad6:	55                   	push   %ebp
 ad7:	89 e5                	mov    %esp,%ebp
 ad9:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 adc:	8b 45 08             	mov    0x8(%ebp),%eax
 adf:	83 c0 07             	add    $0x7,%eax
 ae2:	c1 e8 03             	shr    $0x3,%eax
 ae5:	40                   	inc    %eax
 ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ae9:	a1 70 10 00 00       	mov    0x1070,%eax
 aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
 af1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 af5:	75 23                	jne    b1a <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 af7:	c7 45 f0 68 10 00 00 	movl   $0x1068,-0x10(%ebp)
 afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b01:	a3 70 10 00 00       	mov    %eax,0x1070
 b06:	a1 70 10 00 00       	mov    0x1070,%eax
 b0b:	a3 68 10 00 00       	mov    %eax,0x1068
    base.s.size = 0;
 b10:	c7 05 6c 10 00 00 00 	movl   $0x0,0x106c
 b17:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1d:	8b 00                	mov    (%eax),%eax
 b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b25:	8b 40 04             	mov    0x4(%eax),%eax
 b28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b2b:	72 4d                	jb     b7a <malloc+0xa4>
      if(p->s.size == nunits)
 b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b30:	8b 40 04             	mov    0x4(%eax),%eax
 b33:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b36:	75 0c                	jne    b44 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3b:	8b 10                	mov    (%eax),%edx
 b3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b40:	89 10                	mov    %edx,(%eax)
 b42:	eb 26                	jmp    b6a <malloc+0x94>
      else {
        p->s.size -= nunits;
 b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b47:	8b 40 04             	mov    0x4(%eax),%eax
 b4a:	89 c2                	mov    %eax,%edx
 b4c:	2b 55 ec             	sub    -0x14(%ebp),%edx
 b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b52:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b58:	8b 40 04             	mov    0x4(%eax),%eax
 b5b:	c1 e0 03             	shl    $0x3,%eax
 b5e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b64:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b67:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6d:	a3 70 10 00 00       	mov    %eax,0x1070
      return (void*)(p + 1);
 b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b75:	83 c0 08             	add    $0x8,%eax
 b78:	eb 38                	jmp    bb2 <malloc+0xdc>
    }
    if(p == freep)
 b7a:	a1 70 10 00 00       	mov    0x1070,%eax
 b7f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b82:	75 1b                	jne    b9f <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b87:	89 04 24             	mov    %eax,(%esp)
 b8a:	e8 ef fe ff ff       	call   a7e <morecore>
 b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b96:	75 07                	jne    b9f <malloc+0xc9>
        return 0;
 b98:	b8 00 00 00 00       	mov    $0x0,%eax
 b9d:	eb 13                	jmp    bb2 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba8:	8b 00                	mov    (%eax),%eax
 baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 bad:	e9 70 ff ff ff       	jmp    b22 <malloc+0x4c>
}
 bb2:	c9                   	leave  
 bb3:	c3                   	ret    
