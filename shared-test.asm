
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
   d:	e8 a0 08 00 00       	call   8b2 <shm_create>
  12:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"*index = %d  \n" , *index ); 
  15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  18:	8a 00                	mov    (%eax),%al
  1a:	0f be c0             	movsbl %al,%eax
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	c7 44 24 04 68 0d 00 	movl   $0xd68,0x4(%esp)
  28:	00 
  29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  30:	e8 6d 09 00 00       	call   9a2 <printf>
  printf(1,"index= %d  \n" , index ); 
  35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 77 0d 00 	movl   $0xd77,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 52 09 00 00       	call   9a2 <printf>
  printf(1,"&index= %d  \n" , &index );
  50:	8d 45 ec             	lea    -0x14(%ebp),%eax
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	c7 44 24 04 84 0d 00 	movl   $0xd84,0x4(%esp)
  5e:	00 
  5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  66:	e8 37 09 00 00       	call   9a2 <printf>
  printf(1,"Indice del arreglo= %d  \n" , keyIndex ); // primer indice del arreglo
  6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6e:	89 44 24 08          	mov    %eax,0x8(%esp)
  72:	c7 44 24 04 92 0d 00 	movl   $0xd92,0x4(%esp)
  79:	00 
  7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  81:	e8 1c 09 00 00       	call   9a2 <printf>

  int a;
  a = shm_get(keyIndex, &index); //tomo el espacio de memoria compartida
  86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  89:	89 44 24 04          	mov    %eax,0x4(%esp)
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	89 04 24             	mov    %eax,(%esp)
  93:	e8 2a 08 00 00       	call   8c2 <shm_get>
  98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"return shm_get %d  \n" , a);  // si retorna 0, pudo obtener el espacio de memoria asociado a el indice keyIndex
  9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  a2:	c7 44 24 04 ac 0d 00 	movl   $0xdac,0x4(%esp)
  a9:	00 
  aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b1:	e8 ec 08 00 00       	call   9a2 <printf>
}
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <test_1>:

// test shm_close
void
test_1(){
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	83 ec 28             	sub    $0x28,%esp
  int keyIndex;
  keyIndex = shm_create(); // creo el espacio de memoria y guardo el indice
  be:	e8 ef 07 00 00       	call   8b2 <shm_create>
  c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1,"creo el espacio de memoria y guardo el indice %d  \n" , keyIndex );
  c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  cd:	c7 44 24 04 c4 0d 00 	movl   $0xdc4,0x4(%esp)
  d4:	00 
  d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  dc:	e8 c1 08 00 00       	call   9a2 <printf>
  printf(1,"resultado del shm_close %d  \n" , shm_close(keyIndex));
  e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e4:	89 04 24             	mov    %eax,(%esp)
  e7:	e8 ce 07 00 00       	call   8ba <shm_close>
  ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  f0:	c7 44 24 04 f8 0d 00 	movl   $0xdf8,0x4(%esp)
  f7:	00 
  f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ff:	e8 9e 08 00 00       	call   9a2 <printf>
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <test_2>:

// test shm_create
void
test_2(){
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 ec 28             	sub    $0x28,%esp
  int keyIndex;
  int keyIndex_2;
  keyIndex = shm_create(); //Creates a shared memory block.
 10c:	e8 a1 07 00 00       	call   8b2 <shm_create>
 111:	89 45 f4             	mov    %eax,-0xc(%ebp)
  keyIndex_2 = shm_create(); //Creates a shared memory block.
 114:	e8 99 07 00 00       	call   8b2 <shm_create>
 119:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1,"keyIndex  %d  \n" , keyIndex);
 11c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 11f:	89 44 24 08          	mov    %eax,0x8(%esp)
 123:	c7 44 24 04 16 0e 00 	movl   $0xe16,0x4(%esp)
 12a:	00 
 12b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 132:	e8 6b 08 00 00       	call   9a2 <printf>
  printf(1,"keyIndex_2 %d  \n" , keyIndex_2);
 137:	8b 45 f0             	mov    -0x10(%ebp),%eax
 13a:	89 44 24 08          	mov    %eax,0x8(%esp)
 13e:	c7 44 24 04 26 0e 00 	movl   $0xe26,0x4(%esp)
 145:	00 
 146:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14d:	e8 50 08 00 00       	call   9a2 <printf>
  exit();
 152:	e8 7b 06 00 00       	call   7d2 <exit>

00000157 <test>:
}

void
test(){
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	83 ec 28             	sub    $0x28,%esp
  int pid, keyIndex;
  char* index = 0;
 15d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

  keyIndex = shm_create(); //creo el espacio de memoria
 164:	e8 49 07 00 00       	call   8b2 <shm_create>
 169:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1,"init index= %d  \n" , *index );
 16c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 16f:	8a 00                	mov    (%eax),%al
 171:	0f be c0             	movsbl %al,%eax
 174:	89 44 24 08          	mov    %eax,0x8(%esp)
 178:	c7 44 24 04 37 0e 00 	movl   $0xe37,0x4(%esp)
 17f:	00 
 180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 187:	e8 16 08 00 00       	call   9a2 <printf>
  printf(1,"init index= %d  \n" , &index );
 18c:	8d 45 ec             	lea    -0x14(%ebp),%eax
 18f:	89 44 24 08          	mov    %eax,0x8(%esp)
 193:	c7 44 24 04 37 0e 00 	movl   $0xe37,0x4(%esp)
 19a:	00 
 19b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a2:	e8 fb 07 00 00       	call   9a2 <printf>

  shm_get(keyIndex, &index); // map
 1a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
 1aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b1:	89 04 24             	mov    %eax,(%esp)
 1b4:	e8 09 07 00 00       	call   8c2 <shm_get>

  pid = fork(); // creo un proceso (hijo) - printf(1,"pid= %d  \n" , pid );
 1b9:	e8 0c 06 00 00       	call   7ca <fork>
 1be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  *index = 3;
 1c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1c4:	c6 00 03             	movb   $0x3,(%eax)

  printf(1,"father index= %d  \n" , &index );
 1c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
 1ca:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ce:	c7 44 24 04 49 0e 00 	movl   $0xe49,0x4(%esp)
 1d5:	00 
 1d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1dd:	e8 c0 07 00 00       	call   9a2 <printf>
  printf(1,"father= %d  \n" , *index);
 1e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1e5:	8a 00                	mov    (%eax),%al
 1e7:	0f be c0             	movsbl %al,%eax
 1ea:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ee:	c7 44 24 04 5d 0e 00 	movl   $0xe5d,0x4(%esp)
 1f5:	00 
 1f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1fd:	e8 a0 07 00 00       	call   9a2 <printf>

  printf(1,"** ** ** ** ** \n");
 202:	c7 44 24 04 6b 0e 00 	movl   $0xe6b,0x4(%esp)
 209:	00 
 20a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 211:	e8 8c 07 00 00       	call   9a2 <printf>

  if(pid == 0 ){
 216:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 21a:	75 4b                	jne    267 <test+0x110>
    //shm_get(keyIndex, &index);
    printf(1,"child index= %d  \n" , *(index) );
 21c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 21f:	8a 00                	mov    (%eax),%al
 221:	0f be c0             	movsbl %al,%eax
 224:	89 44 24 08          	mov    %eax,0x8(%esp)
 228:	c7 44 24 04 7c 0e 00 	movl   $0xe7c,0x4(%esp)
 22f:	00 
 230:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 237:	e8 66 07 00 00       	call   9a2 <printf>
    *index = 4;
 23c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 23f:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child index= %d  \n" , *(index) );
 242:	8b 45 ec             	mov    -0x14(%ebp),%eax
 245:	8a 00                	mov    (%eax),%al
 247:	0f be c0             	movsbl %al,%eax
 24a:	89 44 24 08          	mov    %eax,0x8(%esp)
 24e:	c7 44 24 04 7c 0e 00 	movl   $0xe7c,0x4(%esp)
 255:	00 
 256:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25d:	e8 40 07 00 00       	call   9a2 <printf>
    //shm_close(keyIndex);
    exit();
 262:	e8 6b 05 00 00       	call   7d2 <exit>
  }
  printf(1,"exit *(index)= %d  \n" , *(index) );
 267:	8b 45 ec             	mov    -0x14(%ebp),%eax
 26a:	8a 00                	mov    (%eax),%al
 26c:	0f be c0             	movsbl %al,%eax
 26f:	89 44 24 08          	mov    %eax,0x8(%esp)
 273:	c7 44 24 04 8f 0e 00 	movl   $0xe8f,0x4(%esp)
 27a:	00 
 27b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 282:	e8 1b 07 00 00       	call   9a2 <printf>
  wait();
 287:	e8 4e 05 00 00       	call   7da <wait>
  printf(1,"exit &(index)= %d  \n" , &(index) );
 28c:	8d 45 ec             	lea    -0x14(%ebp),%eax
 28f:	89 44 24 08          	mov    %eax,0x8(%esp)
 293:	c7 44 24 04 a4 0e 00 	movl   $0xea4,0x4(%esp)
 29a:	00 
 29b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2a2:	e8 fb 06 00 00       	call   9a2 <printf>
  printf(1,"exit *(index)= %d  \n" , *(index) );
 2a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2aa:	8a 00                	mov    (%eax),%al
 2ac:	0f be c0             	movsbl %al,%eax
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 8f 0e 00 	movl   $0xe8f,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 db 06 00 00       	call   9a2 <printf>
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <main>:

int
main(int argc, char *argv[]) {
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 e4 f0             	and    $0xfffffff0,%esp
 2cf:	83 ec 30             	sub    $0x30,%esp
  // test();
 
  int pid;
  int keyIndex;
  int keyIndex_2;
  char* index = 0; 
 2d2:	c7 44 24 20 00 00 00 	movl   $0x0,0x20(%esp)
 2d9:	00 
  char* index_2 = 0; 
 2da:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 2e1:	00 

  keyIndex = shm_create(); //Creates a shared memory block.
 2e2:	e8 cb 05 00 00       	call   8b2 <shm_create>
 2e7:	89 44 24 2c          	mov    %eax,0x2c(%esp)
  keyIndex_2 = shm_create(); //Creates a shared memory block.
 2eb:	e8 c2 05 00 00       	call   8b2 <shm_create>
 2f0:	89 44 24 28          	mov    %eax,0x28(%esp)

  printf(1,"init *index = %d  \n" , *index );
 2f4:	8b 44 24 20          	mov    0x20(%esp),%eax
 2f8:	8a 00                	mov    (%eax),%al
 2fa:	0f be c0             	movsbl %al,%eax
 2fd:	89 44 24 08          	mov    %eax,0x8(%esp)
 301:	c7 44 24 04 b9 0e 00 	movl   $0xeb9,0x4(%esp)
 308:	00 
 309:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 310:	e8 8d 06 00 00       	call   9a2 <printf>
  printf(1,"init &index = %d  \n" , &index );
 315:	8d 44 24 20          	lea    0x20(%esp),%eax
 319:	89 44 24 08          	mov    %eax,0x8(%esp)
 31d:	c7 44 24 04 cd 0e 00 	movl   $0xecd,0x4(%esp)
 324:	00 
 325:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 32c:	e8 71 06 00 00       	call   9a2 <printf>
  printf(1,"init *index_2 = %d  \n" , *index_2 );
 331:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 335:	8a 00                	mov    (%eax),%al
 337:	0f be c0             	movsbl %al,%eax
 33a:	89 44 24 08          	mov    %eax,0x8(%esp)
 33e:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
 345:	00 
 346:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 34d:	e8 50 06 00 00       	call   9a2 <printf>
  printf(1,"init &index_2 = %d  \n" , &index_2 );
 352:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 356:	89 44 24 08          	mov    %eax,0x8(%esp)
 35a:	c7 44 24 04 f7 0e 00 	movl   $0xef7,0x4(%esp)
 361:	00 
 362:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 369:	e8 34 06 00 00       	call   9a2 <printf>
  
  printf(1,"keyIndex: %d  \n" , keyIndex);
 36e:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 372:	89 44 24 08          	mov    %eax,0x8(%esp)
 376:	c7 44 24 04 0d 0f 00 	movl   $0xf0d,0x4(%esp)
 37d:	00 
 37e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 385:	e8 18 06 00 00       	call   9a2 <printf>
  printf(1,"keyIndex_2: %d  \n" , keyIndex_2);
 38a:	8b 44 24 28          	mov    0x28(%esp),%eax
 38e:	89 44 24 08          	mov    %eax,0x8(%esp)
 392:	c7 44 24 04 1d 0f 00 	movl   $0xf1d,0x4(%esp)
 399:	00 
 39a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3a1:	e8 fc 05 00 00       	call   9a2 <printf>

  shm_get(keyIndex, &index); // obtiene la direccion del bloque de memoria asociado a la keyIndex
 3a6:	8d 44 24 20          	lea    0x20(%esp),%eax
 3aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ae:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 3b2:	89 04 24             	mov    %eax,(%esp)
 3b5:	e8 08 05 00 00       	call   8c2 <shm_get>
  shm_get(keyIndex_2, &index_2);
 3ba:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 3be:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c2:	8b 44 24 28          	mov    0x28(%esp),%eax
 3c6:	89 04 24             	mov    %eax,(%esp)
 3c9:	e8 f4 04 00 00       	call   8c2 <shm_get>

  printf(1," * * * * fork() * * * *\n");
 3ce:	c7 44 24 04 2f 0f 00 	movl   $0xf2f,0x4(%esp)
 3d5:	00 
 3d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3dd:	e8 c0 05 00 00       	call   9a2 <printf>
  pid = fork(); 
 3e2:	e8 e3 03 00 00       	call   7ca <fork>
 3e7:	89 44 24 24          	mov    %eax,0x24(%esp)
  *index = 3; 
 3eb:	8b 44 24 20          	mov    0x20(%esp),%eax
 3ef:	c6 00 03             	movb   $0x3,(%eax)

  printf(1,"despues del fork *index = %d  \n" , *index);
 3f2:	8b 44 24 20          	mov    0x20(%esp),%eax
 3f6:	8a 00                	mov    (%eax),%al
 3f8:	0f be c0             	movsbl %al,%eax
 3fb:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ff:	c7 44 24 04 48 0f 00 	movl   $0xf48,0x4(%esp)
 406:	00 
 407:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 40e:	e8 8f 05 00 00       	call   9a2 <printf>
  printf(1,"despues del fork &index = %d  \n" , &index );
 413:	8d 44 24 20          	lea    0x20(%esp),%eax
 417:	89 44 24 08          	mov    %eax,0x8(%esp)
 41b:	c7 44 24 04 68 0f 00 	movl   $0xf68,0x4(%esp)
 422:	00 
 423:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 42a:	e8 73 05 00 00       	call   9a2 <printf>
  
  if(pid == 0 ){
 42f:	83 7c 24 24 00       	cmpl   $0x0,0x24(%esp)
 434:	0f 85 b2 00 00 00    	jne    4ec <main+0x223>
    printf(1," * * * * Hijo * * * *\n");
 43a:	c7 44 24 04 88 0f 00 	movl   $0xf88,0x4(%esp)
 441:	00 
 442:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 449:	e8 54 05 00 00       	call   9a2 <printf>
    shm_get(keyIndex, &index);
 44e:	8d 44 24 20          	lea    0x20(%esp),%eax
 452:	89 44 24 04          	mov    %eax,0x4(%esp)
 456:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 45a:	89 04 24             	mov    %eax,(%esp)
 45d:	e8 60 04 00 00       	call   8c2 <shm_get>
    shm_get(keyIndex_2, &index_2);
 462:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 466:	89 44 24 04          	mov    %eax,0x4(%esp)
 46a:	8b 44 24 28          	mov    0x28(%esp),%eax
 46e:	89 04 24             	mov    %eax,(%esp)
 471:	e8 4c 04 00 00       	call   8c2 <shm_get>
    printf(1,"child *(index) = %d  \n" , *(index));
 476:	8b 44 24 20          	mov    0x20(%esp),%eax
 47a:	8a 00                	mov    (%eax),%al
 47c:	0f be c0             	movsbl %al,%eax
 47f:	89 44 24 08          	mov    %eax,0x8(%esp)
 483:	c7 44 24 04 9f 0f 00 	movl   $0xf9f,0x4(%esp)
 48a:	00 
 48b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 492:	e8 0b 05 00 00       	call   9a2 <printf>
    *index = 4;
 497:	8b 44 24 20          	mov    0x20(%esp),%eax
 49b:	c6 00 04             	movb   $0x4,(%eax)
    printf(1,"child *(index) = %d  \n" , *(index));
 49e:	8b 44 24 20          	mov    0x20(%esp),%eax
 4a2:	8a 00                	mov    (%eax),%al
 4a4:	0f be c0             	movsbl %al,%eax
 4a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 4ab:	c7 44 24 04 9f 0f 00 	movl   $0xf9f,0x4(%esp)
 4b2:	00 
 4b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4ba:	e8 e3 04 00 00       	call   9a2 <printf>
    *index_2 = 5;
 4bf:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 4c3:	c6 00 05             	movb   $0x5,(%eax)
    printf(1,"child *(index_2) = %d  \n" , *(index_2));
 4c6:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 4ca:	8a 00                	mov    (%eax),%al
 4cc:	0f be c0             	movsbl %al,%eax
 4cf:	89 44 24 08          	mov    %eax,0x8(%esp)
 4d3:	c7 44 24 04 b6 0f 00 	movl   $0xfb6,0x4(%esp)
 4da:	00 
 4db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 4e2:	e8 bb 04 00 00       	call   9a2 <printf>
    exit();
 4e7:	e8 e6 02 00 00       	call   7d2 <exit>
  }
  printf(1,"antes del wait *(index) = %d  \n" , *(index) );
 4ec:	8b 44 24 20          	mov    0x20(%esp),%eax
 4f0:	8a 00                	mov    (%eax),%al
 4f2:	0f be c0             	movsbl %al,%eax
 4f5:	89 44 24 08          	mov    %eax,0x8(%esp)
 4f9:	c7 44 24 04 d0 0f 00 	movl   $0xfd0,0x4(%esp)
 500:	00 
 501:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 508:	e8 95 04 00 00       	call   9a2 <printf>
  wait();
 50d:	e8 c8 02 00 00       	call   7da <wait>
  printf(1," * * * * Padre * * * *\n");
 512:	c7 44 24 04 f0 0f 00 	movl   $0xff0,0x4(%esp)
 519:	00 
 51a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 521:	e8 7c 04 00 00       	call   9a2 <printf>
  printf(1,"father *(index_2) = %d  \n" , *(index_2));
 526:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 52a:	8a 00                	mov    (%eax),%al
 52c:	0f be c0             	movsbl %al,%eax
 52f:	89 44 24 08          	mov    %eax,0x8(%esp)
 533:	c7 44 24 04 08 10 00 	movl   $0x1008,0x4(%esp)
 53a:	00 
 53b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 542:	e8 5b 04 00 00       	call   9a2 <printf>
  printf(1,"father &(index) = %d  \n" , &(index));
 547:	8d 44 24 20          	lea    0x20(%esp),%eax
 54b:	89 44 24 08          	mov    %eax,0x8(%esp)
 54f:	c7 44 24 04 22 10 00 	movl   $0x1022,0x4(%esp)
 556:	00 
 557:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 55e:	e8 3f 04 00 00       	call   9a2 <printf>
  printf(1,"father *(index) = %d  \n" , *(index));
 563:	8b 44 24 20          	mov    0x20(%esp),%eax
 567:	8a 00                	mov    (%eax),%al
 569:	0f be c0             	movsbl %al,%eax
 56c:	89 44 24 08          	mov    %eax,0x8(%esp)
 570:	c7 44 24 04 3a 10 00 	movl   $0x103a,0x4(%esp)
 577:	00 
 578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 57f:	e8 1e 04 00 00       	call   9a2 <printf>
  exit();
 584:	e8 49 02 00 00       	call   7d2 <exit>

00000589 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 589:	55                   	push   %ebp
 58a:	89 e5                	mov    %esp,%ebp
 58c:	57                   	push   %edi
 58d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 58e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 591:	8b 55 10             	mov    0x10(%ebp),%edx
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	89 cb                	mov    %ecx,%ebx
 599:	89 df                	mov    %ebx,%edi
 59b:	89 d1                	mov    %edx,%ecx
 59d:	fc                   	cld    
 59e:	f3 aa                	rep stos %al,%es:(%edi)
 5a0:	89 ca                	mov    %ecx,%edx
 5a2:	89 fb                	mov    %edi,%ebx
 5a4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 5a7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 5aa:	5b                   	pop    %ebx
 5ab:	5f                   	pop    %edi
 5ac:	5d                   	pop    %ebp
 5ad:	c3                   	ret    

000005ae <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 5ae:	55                   	push   %ebp
 5af:	89 e5                	mov    %esp,%ebp
 5b1:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 5ba:	90                   	nop
 5bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5be:	8a 10                	mov    (%eax),%dl
 5c0:	8b 45 08             	mov    0x8(%ebp),%eax
 5c3:	88 10                	mov    %dl,(%eax)
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	8a 00                	mov    (%eax),%al
 5ca:	84 c0                	test   %al,%al
 5cc:	0f 95 c0             	setne  %al
 5cf:	ff 45 08             	incl   0x8(%ebp)
 5d2:	ff 45 0c             	incl   0xc(%ebp)
 5d5:	84 c0                	test   %al,%al
 5d7:	75 e2                	jne    5bb <strcpy+0xd>
    ;
  return os;
 5d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5dc:	c9                   	leave  
 5dd:	c3                   	ret    

000005de <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5de:	55                   	push   %ebp
 5df:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 5e1:	eb 06                	jmp    5e9 <strcmp+0xb>
    p++, q++;
 5e3:	ff 45 08             	incl   0x8(%ebp)
 5e6:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	8a 00                	mov    (%eax),%al
 5ee:	84 c0                	test   %al,%al
 5f0:	74 0e                	je     600 <strcmp+0x22>
 5f2:	8b 45 08             	mov    0x8(%ebp),%eax
 5f5:	8a 10                	mov    (%eax),%dl
 5f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fa:	8a 00                	mov    (%eax),%al
 5fc:	38 c2                	cmp    %al,%dl
 5fe:	74 e3                	je     5e3 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 600:	8b 45 08             	mov    0x8(%ebp),%eax
 603:	8a 00                	mov    (%eax),%al
 605:	0f b6 d0             	movzbl %al,%edx
 608:	8b 45 0c             	mov    0xc(%ebp),%eax
 60b:	8a 00                	mov    (%eax),%al
 60d:	0f b6 c0             	movzbl %al,%eax
 610:	89 d1                	mov    %edx,%ecx
 612:	29 c1                	sub    %eax,%ecx
 614:	89 c8                	mov    %ecx,%eax
}
 616:	5d                   	pop    %ebp
 617:	c3                   	ret    

00000618 <strlen>:

uint
strlen(char *s)
{
 618:	55                   	push   %ebp
 619:	89 e5                	mov    %esp,%ebp
 61b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 61e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 625:	eb 03                	jmp    62a <strlen+0x12>
 627:	ff 45 fc             	incl   -0x4(%ebp)
 62a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
 630:	01 d0                	add    %edx,%eax
 632:	8a 00                	mov    (%eax),%al
 634:	84 c0                	test   %al,%al
 636:	75 ef                	jne    627 <strlen+0xf>
    ;
  return n;
 638:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <memset>:

void*
memset(void *dst, int c, uint n)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 643:	8b 45 10             	mov    0x10(%ebp),%eax
 646:	89 44 24 08          	mov    %eax,0x8(%esp)
 64a:	8b 45 0c             	mov    0xc(%ebp),%eax
 64d:	89 44 24 04          	mov    %eax,0x4(%esp)
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	89 04 24             	mov    %eax,(%esp)
 657:	e8 2d ff ff ff       	call   589 <stosb>
  return dst;
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 65f:	c9                   	leave  
 660:	c3                   	ret    

00000661 <strchr>:

char*
strchr(const char *s, char c)
{
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	83 ec 04             	sub    $0x4,%esp
 667:	8b 45 0c             	mov    0xc(%ebp),%eax
 66a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 66d:	eb 12                	jmp    681 <strchr+0x20>
    if(*s == c)
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	8a 00                	mov    (%eax),%al
 674:	3a 45 fc             	cmp    -0x4(%ebp),%al
 677:	75 05                	jne    67e <strchr+0x1d>
      return (char*)s;
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	eb 11                	jmp    68f <strchr+0x2e>
  for(; *s; s++)
 67e:	ff 45 08             	incl   0x8(%ebp)
 681:	8b 45 08             	mov    0x8(%ebp),%eax
 684:	8a 00                	mov    (%eax),%al
 686:	84 c0                	test   %al,%al
 688:	75 e5                	jne    66f <strchr+0xe>
  return 0;
 68a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 68f:	c9                   	leave  
 690:	c3                   	ret    

00000691 <gets>:

char*
gets(char *buf, int max)
{
 691:	55                   	push   %ebp
 692:	89 e5                	mov    %esp,%ebp
 694:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 697:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 69e:	eb 42                	jmp    6e2 <gets+0x51>
    cc = read(0, &c, 1);
 6a0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6a7:	00 
 6a8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 6af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6b6:	e8 2f 01 00 00       	call   7ea <read>
 6bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c2:	7e 29                	jle    6ed <gets+0x5c>
      break;
    buf[i++] = c;
 6c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6c7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ca:	01 c2                	add    %eax,%edx
 6cc:	8a 45 ef             	mov    -0x11(%ebp),%al
 6cf:	88 02                	mov    %al,(%edx)
 6d1:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
 6d4:	8a 45 ef             	mov    -0x11(%ebp),%al
 6d7:	3c 0a                	cmp    $0xa,%al
 6d9:	74 13                	je     6ee <gets+0x5d>
 6db:	8a 45 ef             	mov    -0x11(%ebp),%al
 6de:	3c 0d                	cmp    $0xd,%al
 6e0:	74 0c                	je     6ee <gets+0x5d>
  for(i=0; i+1 < max; ){
 6e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e5:	40                   	inc    %eax
 6e6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6e9:	7c b5                	jl     6a0 <gets+0xf>
 6eb:	eb 01                	jmp    6ee <gets+0x5d>
      break;
 6ed:	90                   	nop
      break;
  }
  buf[i] = '\0';
 6ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	01 d0                	add    %edx,%eax
 6f6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6fc:	c9                   	leave  
 6fd:	c3                   	ret    

000006fe <stat>:

int
stat(char *n, struct stat *st)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 704:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 70b:	00 
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	89 04 24             	mov    %eax,(%esp)
 712:	e8 fb 00 00 00       	call   812 <open>
 717:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 71a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71e:	79 07                	jns    727 <stat+0x29>
    return -1;
 720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 725:	eb 23                	jmp    74a <stat+0x4c>
  r = fstat(fd, st);
 727:	8b 45 0c             	mov    0xc(%ebp),%eax
 72a:	89 44 24 04          	mov    %eax,0x4(%esp)
 72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 731:	89 04 24             	mov    %eax,(%esp)
 734:	e8 f1 00 00 00       	call   82a <fstat>
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 73c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73f:	89 04 24             	mov    %eax,(%esp)
 742:	e8 b3 00 00 00       	call   7fa <close>
  return r;
 747:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 74a:	c9                   	leave  
 74b:	c3                   	ret    

0000074c <atoi>:

int
atoi(const char *s)
{
 74c:	55                   	push   %ebp
 74d:	89 e5                	mov    %esp,%ebp
 74f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 752:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 759:	eb 21                	jmp    77c <atoi+0x30>
    n = n*10 + *s++ - '0';
 75b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 75e:	89 d0                	mov    %edx,%eax
 760:	c1 e0 02             	shl    $0x2,%eax
 763:	01 d0                	add    %edx,%eax
 765:	d1 e0                	shl    %eax
 767:	89 c2                	mov    %eax,%edx
 769:	8b 45 08             	mov    0x8(%ebp),%eax
 76c:	8a 00                	mov    (%eax),%al
 76e:	0f be c0             	movsbl %al,%eax
 771:	01 d0                	add    %edx,%eax
 773:	83 e8 30             	sub    $0x30,%eax
 776:	89 45 fc             	mov    %eax,-0x4(%ebp)
 779:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
 77f:	8a 00                	mov    (%eax),%al
 781:	3c 2f                	cmp    $0x2f,%al
 783:	7e 09                	jle    78e <atoi+0x42>
 785:	8b 45 08             	mov    0x8(%ebp),%eax
 788:	8a 00                	mov    (%eax),%al
 78a:	3c 39                	cmp    $0x39,%al
 78c:	7e cd                	jle    75b <atoi+0xf>
  return n;
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 791:	c9                   	leave  
 792:	c3                   	ret    

00000793 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 793:	55                   	push   %ebp
 794:	89 e5                	mov    %esp,%ebp
 796:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 79f:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7a5:	eb 10                	jmp    7b7 <memmove+0x24>
    *dst++ = *src++;
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8a 10                	mov    (%eax),%dl
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	88 10                	mov    %dl,(%eax)
 7b1:	ff 45 fc             	incl   -0x4(%ebp)
 7b4:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
 7b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 7bb:	0f 9f c0             	setg   %al
 7be:	ff 4d 10             	decl   0x10(%ebp)
 7c1:	84 c0                	test   %al,%al
 7c3:	75 e2                	jne    7a7 <memmove+0x14>
  return vdst;
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7c8:	c9                   	leave  
 7c9:	c3                   	ret    

000007ca <fork>:
 7ca:	b8 01 00 00 00       	mov    $0x1,%eax
 7cf:	cd 40                	int    $0x40
 7d1:	c3                   	ret    

000007d2 <exit>:
 7d2:	b8 02 00 00 00       	mov    $0x2,%eax
 7d7:	cd 40                	int    $0x40
 7d9:	c3                   	ret    

000007da <wait>:
 7da:	b8 03 00 00 00       	mov    $0x3,%eax
 7df:	cd 40                	int    $0x40
 7e1:	c3                   	ret    

000007e2 <pipe>:
 7e2:	b8 04 00 00 00       	mov    $0x4,%eax
 7e7:	cd 40                	int    $0x40
 7e9:	c3                   	ret    

000007ea <read>:
 7ea:	b8 05 00 00 00       	mov    $0x5,%eax
 7ef:	cd 40                	int    $0x40
 7f1:	c3                   	ret    

000007f2 <write>:
 7f2:	b8 10 00 00 00       	mov    $0x10,%eax
 7f7:	cd 40                	int    $0x40
 7f9:	c3                   	ret    

000007fa <close>:
 7fa:	b8 15 00 00 00       	mov    $0x15,%eax
 7ff:	cd 40                	int    $0x40
 801:	c3                   	ret    

00000802 <kill>:
 802:	b8 06 00 00 00       	mov    $0x6,%eax
 807:	cd 40                	int    $0x40
 809:	c3                   	ret    

0000080a <exec>:
 80a:	b8 07 00 00 00       	mov    $0x7,%eax
 80f:	cd 40                	int    $0x40
 811:	c3                   	ret    

00000812 <open>:
 812:	b8 0f 00 00 00       	mov    $0xf,%eax
 817:	cd 40                	int    $0x40
 819:	c3                   	ret    

0000081a <mknod>:
 81a:	b8 11 00 00 00       	mov    $0x11,%eax
 81f:	cd 40                	int    $0x40
 821:	c3                   	ret    

00000822 <unlink>:
 822:	b8 12 00 00 00       	mov    $0x12,%eax
 827:	cd 40                	int    $0x40
 829:	c3                   	ret    

0000082a <fstat>:
 82a:	b8 08 00 00 00       	mov    $0x8,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <link>:
 832:	b8 13 00 00 00       	mov    $0x13,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <mkdir>:
 83a:	b8 14 00 00 00       	mov    $0x14,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <chdir>:
 842:	b8 09 00 00 00       	mov    $0x9,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <dup>:
 84a:	b8 0a 00 00 00       	mov    $0xa,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <getpid>:
 852:	b8 0b 00 00 00       	mov    $0xb,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <sbrk>:
 85a:	b8 0c 00 00 00       	mov    $0xc,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    

00000862 <sleep>:
 862:	b8 0d 00 00 00       	mov    $0xd,%eax
 867:	cd 40                	int    $0x40
 869:	c3                   	ret    

0000086a <uptime>:
 86a:	b8 0e 00 00 00       	mov    $0xe,%eax
 86f:	cd 40                	int    $0x40
 871:	c3                   	ret    

00000872 <lseek>:
 872:	b8 16 00 00 00       	mov    $0x16,%eax
 877:	cd 40                	int    $0x40
 879:	c3                   	ret    

0000087a <isatty>:
 87a:	b8 17 00 00 00       	mov    $0x17,%eax
 87f:	cd 40                	int    $0x40
 881:	c3                   	ret    

00000882 <procstat>:
 882:	b8 18 00 00 00       	mov    $0x18,%eax
 887:	cd 40                	int    $0x40
 889:	c3                   	ret    

0000088a <set_priority>:
 88a:	b8 19 00 00 00       	mov    $0x19,%eax
 88f:	cd 40                	int    $0x40
 891:	c3                   	ret    

00000892 <semget>:
 892:	b8 1a 00 00 00       	mov    $0x1a,%eax
 897:	cd 40                	int    $0x40
 899:	c3                   	ret    

0000089a <semfree>:
 89a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 89f:	cd 40                	int    $0x40
 8a1:	c3                   	ret    

000008a2 <semdown>:
 8a2:	b8 1c 00 00 00       	mov    $0x1c,%eax
 8a7:	cd 40                	int    $0x40
 8a9:	c3                   	ret    

000008aa <semup>:
 8aa:	b8 1d 00 00 00       	mov    $0x1d,%eax
 8af:	cd 40                	int    $0x40
 8b1:	c3                   	ret    

000008b2 <shm_create>:
 8b2:	b8 1e 00 00 00       	mov    $0x1e,%eax
 8b7:	cd 40                	int    $0x40
 8b9:	c3                   	ret    

000008ba <shm_close>:
 8ba:	b8 1f 00 00 00       	mov    $0x1f,%eax
 8bf:	cd 40                	int    $0x40
 8c1:	c3                   	ret    

000008c2 <shm_get>:
 8c2:	b8 20 00 00 00       	mov    $0x20,%eax
 8c7:	cd 40                	int    $0x40
 8c9:	c3                   	ret    

000008ca <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8ca:	55                   	push   %ebp
 8cb:	89 e5                	mov    %esp,%ebp
 8cd:	83 ec 28             	sub    $0x28,%esp
 8d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8d6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8dd:	00 
 8de:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8e1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e5:	8b 45 08             	mov    0x8(%ebp),%eax
 8e8:	89 04 24             	mov    %eax,(%esp)
 8eb:	e8 02 ff ff ff       	call   7f2 <write>
}
 8f0:	c9                   	leave  
 8f1:	c3                   	ret    

000008f2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8f2:	55                   	push   %ebp
 8f3:	89 e5                	mov    %esp,%ebp
 8f5:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 8ff:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 903:	74 17                	je     91c <printint+0x2a>
 905:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 909:	79 11                	jns    91c <printint+0x2a>
    neg = 1;
 90b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 912:	8b 45 0c             	mov    0xc(%ebp),%eax
 915:	f7 d8                	neg    %eax
 917:	89 45 ec             	mov    %eax,-0x14(%ebp)
 91a:	eb 06                	jmp    922 <printint+0x30>
  } else {
    x = xx;
 91c:	8b 45 0c             	mov    0xc(%ebp),%eax
 91f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 929:	8b 4d 10             	mov    0x10(%ebp),%ecx
 92c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 92f:	ba 00 00 00 00       	mov    $0x0,%edx
 934:	f7 f1                	div    %ecx
 936:	89 d0                	mov    %edx,%eax
 938:	8a 80 14 13 00 00    	mov    0x1314(%eax),%al
 93e:	8d 4d dc             	lea    -0x24(%ebp),%ecx
 941:	8b 55 f4             	mov    -0xc(%ebp),%edx
 944:	01 ca                	add    %ecx,%edx
 946:	88 02                	mov    %al,(%edx)
 948:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
 94b:	8b 55 10             	mov    0x10(%ebp),%edx
 94e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 951:	8b 45 ec             	mov    -0x14(%ebp),%eax
 954:	ba 00 00 00 00       	mov    $0x0,%edx
 959:	f7 75 d4             	divl   -0x2c(%ebp)
 95c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 95f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 963:	75 c4                	jne    929 <printint+0x37>
  if(neg)
 965:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 969:	74 2c                	je     997 <printint+0xa5>
    buf[i++] = '-';
 96b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	01 d0                	add    %edx,%eax
 973:	c6 00 2d             	movb   $0x2d,(%eax)
 976:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
 979:	eb 1c                	jmp    997 <printint+0xa5>
    putc(fd, buf[i]);
 97b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 97e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 981:	01 d0                	add    %edx,%eax
 983:	8a 00                	mov    (%eax),%al
 985:	0f be c0             	movsbl %al,%eax
 988:	89 44 24 04          	mov    %eax,0x4(%esp)
 98c:	8b 45 08             	mov    0x8(%ebp),%eax
 98f:	89 04 24             	mov    %eax,(%esp)
 992:	e8 33 ff ff ff       	call   8ca <putc>
  while(--i >= 0)
 997:	ff 4d f4             	decl   -0xc(%ebp)
 99a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99e:	79 db                	jns    97b <printint+0x89>
}
 9a0:	c9                   	leave  
 9a1:	c3                   	ret    

000009a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9a2:	55                   	push   %ebp
 9a3:	89 e5                	mov    %esp,%ebp
 9a5:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9af:	8d 45 0c             	lea    0xc(%ebp),%eax
 9b2:	83 c0 04             	add    $0x4,%eax
 9b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9bf:	e9 78 01 00 00       	jmp    b3c <printf+0x19a>
    c = fmt[i] & 0xff;
 9c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 9c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ca:	01 d0                	add    %edx,%eax
 9cc:	8a 00                	mov    (%eax),%al
 9ce:	0f be c0             	movsbl %al,%eax
 9d1:	25 ff 00 00 00       	and    $0xff,%eax
 9d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9dd:	75 2c                	jne    a0b <printf+0x69>
      if(c == '%'){
 9df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9e3:	75 0c                	jne    9f1 <printf+0x4f>
        state = '%';
 9e5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9ec:	e9 48 01 00 00       	jmp    b39 <printf+0x197>
      } else {
        putc(fd, c);
 9f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9f4:	0f be c0             	movsbl %al,%eax
 9f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9fb:	8b 45 08             	mov    0x8(%ebp),%eax
 9fe:	89 04 24             	mov    %eax,(%esp)
 a01:	e8 c4 fe ff ff       	call   8ca <putc>
 a06:	e9 2e 01 00 00       	jmp    b39 <printf+0x197>
      }
    } else if(state == '%'){
 a0b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a0f:	0f 85 24 01 00 00    	jne    b39 <printf+0x197>
      if(c == 'd'){
 a15:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a19:	75 2d                	jne    a48 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a1e:	8b 00                	mov    (%eax),%eax
 a20:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a27:	00 
 a28:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a2f:	00 
 a30:	89 44 24 04          	mov    %eax,0x4(%esp)
 a34:	8b 45 08             	mov    0x8(%ebp),%eax
 a37:	89 04 24             	mov    %eax,(%esp)
 a3a:	e8 b3 fe ff ff       	call   8f2 <printint>
        ap++;
 a3f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a43:	e9 ea 00 00 00       	jmp    b32 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
 a48:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a4c:	74 06                	je     a54 <printf+0xb2>
 a4e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a52:	75 2d                	jne    a81 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a54:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a57:	8b 00                	mov    (%eax),%eax
 a59:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a60:	00 
 a61:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a68:	00 
 a69:	89 44 24 04          	mov    %eax,0x4(%esp)
 a6d:	8b 45 08             	mov    0x8(%ebp),%eax
 a70:	89 04 24             	mov    %eax,(%esp)
 a73:	e8 7a fe ff ff       	call   8f2 <printint>
        ap++;
 a78:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a7c:	e9 b1 00 00 00       	jmp    b32 <printf+0x190>
      } else if(c == 's'){
 a81:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a85:	75 43                	jne    aca <printf+0x128>
        s = (char*)*ap;
 a87:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a8a:	8b 00                	mov    (%eax),%eax
 a8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a8f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a97:	75 25                	jne    abe <printf+0x11c>
          s = "(null)";
 a99:	c7 45 f4 52 10 00 00 	movl   $0x1052,-0xc(%ebp)
        while(*s != 0){
 aa0:	eb 1c                	jmp    abe <printf+0x11c>
          putc(fd, *s);
 aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa5:	8a 00                	mov    (%eax),%al
 aa7:	0f be c0             	movsbl %al,%eax
 aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
 aae:	8b 45 08             	mov    0x8(%ebp),%eax
 ab1:	89 04 24             	mov    %eax,(%esp)
 ab4:	e8 11 fe ff ff       	call   8ca <putc>
          s++;
 ab9:	ff 45 f4             	incl   -0xc(%ebp)
 abc:	eb 01                	jmp    abf <printf+0x11d>
        while(*s != 0){
 abe:	90                   	nop
 abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac2:	8a 00                	mov    (%eax),%al
 ac4:	84 c0                	test   %al,%al
 ac6:	75 da                	jne    aa2 <printf+0x100>
 ac8:	eb 68                	jmp    b32 <printf+0x190>
        }
      } else if(c == 'c'){
 aca:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ace:	75 1d                	jne    aed <printf+0x14b>
        putc(fd, *ap);
 ad0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ad3:	8b 00                	mov    (%eax),%eax
 ad5:	0f be c0             	movsbl %al,%eax
 ad8:	89 44 24 04          	mov    %eax,0x4(%esp)
 adc:	8b 45 08             	mov    0x8(%ebp),%eax
 adf:	89 04 24             	mov    %eax,(%esp)
 ae2:	e8 e3 fd ff ff       	call   8ca <putc>
        ap++;
 ae7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aeb:	eb 45                	jmp    b32 <printf+0x190>
      } else if(c == '%'){
 aed:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 af1:	75 17                	jne    b0a <printf+0x168>
        putc(fd, c);
 af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 af6:	0f be c0             	movsbl %al,%eax
 af9:	89 44 24 04          	mov    %eax,0x4(%esp)
 afd:	8b 45 08             	mov    0x8(%ebp),%eax
 b00:	89 04 24             	mov    %eax,(%esp)
 b03:	e8 c2 fd ff ff       	call   8ca <putc>
 b08:	eb 28                	jmp    b32 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b0a:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b11:	00 
 b12:	8b 45 08             	mov    0x8(%ebp),%eax
 b15:	89 04 24             	mov    %eax,(%esp)
 b18:	e8 ad fd ff ff       	call   8ca <putc>
        putc(fd, c);
 b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b20:	0f be c0             	movsbl %al,%eax
 b23:	89 44 24 04          	mov    %eax,0x4(%esp)
 b27:	8b 45 08             	mov    0x8(%ebp),%eax
 b2a:	89 04 24             	mov    %eax,(%esp)
 b2d:	e8 98 fd ff ff       	call   8ca <putc>
      }
      state = 0;
 b32:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 b39:	ff 45 f0             	incl   -0x10(%ebp)
 b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
 b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b42:	01 d0                	add    %edx,%eax
 b44:	8a 00                	mov    (%eax),%al
 b46:	84 c0                	test   %al,%al
 b48:	0f 85 76 fe ff ff    	jne    9c4 <printf+0x22>
    }
  }
}
 b4e:	c9                   	leave  
 b4f:	c3                   	ret    

00000b50 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b50:	55                   	push   %ebp
 b51:	89 e5                	mov    %esp,%ebp
 b53:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b56:	8b 45 08             	mov    0x8(%ebp),%eax
 b59:	83 e8 08             	sub    $0x8,%eax
 b5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b5f:	a1 30 13 00 00       	mov    0x1330,%eax
 b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b67:	eb 24                	jmp    b8d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b6c:	8b 00                	mov    (%eax),%eax
 b6e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b71:	77 12                	ja     b85 <free+0x35>
 b73:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b76:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b79:	77 24                	ja     b9f <free+0x4f>
 b7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b7e:	8b 00                	mov    (%eax),%eax
 b80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b83:	77 1a                	ja     b9f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b88:	8b 00                	mov    (%eax),%eax
 b8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b90:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b93:	76 d4                	jbe    b69 <free+0x19>
 b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b98:	8b 00                	mov    (%eax),%eax
 b9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b9d:	76 ca                	jbe    b69 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba2:	8b 40 04             	mov    0x4(%eax),%eax
 ba5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 baf:	01 c2                	add    %eax,%edx
 bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb4:	8b 00                	mov    (%eax),%eax
 bb6:	39 c2                	cmp    %eax,%edx
 bb8:	75 24                	jne    bde <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bbd:	8b 50 04             	mov    0x4(%eax),%edx
 bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc3:	8b 00                	mov    (%eax),%eax
 bc5:	8b 40 04             	mov    0x4(%eax),%eax
 bc8:	01 c2                	add    %eax,%edx
 bca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bcd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd3:	8b 00                	mov    (%eax),%eax
 bd5:	8b 10                	mov    (%eax),%edx
 bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bda:	89 10                	mov    %edx,(%eax)
 bdc:	eb 0a                	jmp    be8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be1:	8b 10                	mov    (%eax),%edx
 be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 beb:	8b 40 04             	mov    0x4(%eax),%eax
 bee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf8:	01 d0                	add    %edx,%eax
 bfa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bfd:	75 20                	jne    c1f <free+0xcf>
    p->s.size += bp->s.size;
 bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c02:	8b 50 04             	mov    0x4(%eax),%edx
 c05:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c08:	8b 40 04             	mov    0x4(%eax),%eax
 c0b:	01 c2                	add    %eax,%edx
 c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c10:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c16:	8b 10                	mov    (%eax),%edx
 c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1b:	89 10                	mov    %edx,(%eax)
 c1d:	eb 08                	jmp    c27 <free+0xd7>
  } else
    p->s.ptr = bp;
 c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c22:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c25:	89 10                	mov    %edx,(%eax)
  freep = p;
 c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2a:	a3 30 13 00 00       	mov    %eax,0x1330
}
 c2f:	c9                   	leave  
 c30:	c3                   	ret    

00000c31 <morecore>:

static Header*
morecore(uint nu)
{
 c31:	55                   	push   %ebp
 c32:	89 e5                	mov    %esp,%ebp
 c34:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c37:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c3e:	77 07                	ja     c47 <morecore+0x16>
    nu = 4096;
 c40:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c47:	8b 45 08             	mov    0x8(%ebp),%eax
 c4a:	c1 e0 03             	shl    $0x3,%eax
 c4d:	89 04 24             	mov    %eax,(%esp)
 c50:	e8 05 fc ff ff       	call   85a <sbrk>
 c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c58:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c5c:	75 07                	jne    c65 <morecore+0x34>
    return 0;
 c5e:	b8 00 00 00 00       	mov    $0x0,%eax
 c63:	eb 22                	jmp    c87 <morecore+0x56>
  hp = (Header*)p;
 c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c6e:	8b 55 08             	mov    0x8(%ebp),%edx
 c71:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c77:	83 c0 08             	add    $0x8,%eax
 c7a:	89 04 24             	mov    %eax,(%esp)
 c7d:	e8 ce fe ff ff       	call   b50 <free>
  return freep;
 c82:	a1 30 13 00 00       	mov    0x1330,%eax
}
 c87:	c9                   	leave  
 c88:	c3                   	ret    

00000c89 <malloc>:

void*
malloc(uint nbytes)
{
 c89:	55                   	push   %ebp
 c8a:	89 e5                	mov    %esp,%ebp
 c8c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c8f:	8b 45 08             	mov    0x8(%ebp),%eax
 c92:	83 c0 07             	add    $0x7,%eax
 c95:	c1 e8 03             	shr    $0x3,%eax
 c98:	40                   	inc    %eax
 c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c9c:	a1 30 13 00 00       	mov    0x1330,%eax
 ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ca4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ca8:	75 23                	jne    ccd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 caa:	c7 45 f0 28 13 00 00 	movl   $0x1328,-0x10(%ebp)
 cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb4:	a3 30 13 00 00       	mov    %eax,0x1330
 cb9:	a1 30 13 00 00       	mov    0x1330,%eax
 cbe:	a3 28 13 00 00       	mov    %eax,0x1328
    base.s.size = 0;
 cc3:	c7 05 2c 13 00 00 00 	movl   $0x0,0x132c
 cca:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cd0:	8b 00                	mov    (%eax),%eax
 cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd8:	8b 40 04             	mov    0x4(%eax),%eax
 cdb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cde:	72 4d                	jb     d2d <malloc+0xa4>
      if(p->s.size == nunits)
 ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce3:	8b 40 04             	mov    0x4(%eax),%eax
 ce6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ce9:	75 0c                	jne    cf7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cee:	8b 10                	mov    (%eax),%edx
 cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf3:	89 10                	mov    %edx,(%eax)
 cf5:	eb 26                	jmp    d1d <malloc+0x94>
      else {
        p->s.size -= nunits;
 cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfa:	8b 40 04             	mov    0x4(%eax),%eax
 cfd:	89 c2                	mov    %eax,%edx
 cff:	2b 55 ec             	sub    -0x14(%ebp),%edx
 d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d05:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0b:	8b 40 04             	mov    0x4(%eax),%eax
 d0e:	c1 e0 03             	shl    $0x3,%eax
 d11:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d17:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d1a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d20:	a3 30 13 00 00       	mov    %eax,0x1330
      return (void*)(p + 1);
 d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d28:	83 c0 08             	add    $0x8,%eax
 d2b:	eb 38                	jmp    d65 <malloc+0xdc>
    }
    if(p == freep)
 d2d:	a1 30 13 00 00       	mov    0x1330,%eax
 d32:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d35:	75 1b                	jne    d52 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d3a:	89 04 24             	mov    %eax,(%esp)
 d3d:	e8 ef fe ff ff       	call   c31 <morecore>
 d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d49:	75 07                	jne    d52 <malloc+0xc9>
        return 0;
 d4b:	b8 00 00 00 00       	mov    $0x0,%eax
 d50:	eb 13                	jmp    d65 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d55:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5b:	8b 00                	mov    (%eax),%eax
 d5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 d60:	e9 70 ff ff ff       	jmp    cd5 <malloc+0x4c>
}
 d65:	c9                   	leave  
 d66:	c3                   	ret    
