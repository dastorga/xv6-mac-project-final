
_usertests:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <opentest>:

// simple file system tests

void
opentest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
       6:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
       b:	c7 44 24 04 6a 41 00 	movl   $0x416a,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 72 3d 00 00       	call   3d8d <printf>
  fd = open("echo", 0);
      1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      22:	00 
      23:	c7 04 24 54 41 00 00 	movl   $0x4154,(%esp)
      2a:	e8 16 3c 00 00       	call   3c45 <open>
      2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
      32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      36:	79 1a                	jns    52 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
      38:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
      3d:	c7 44 24 04 75 41 00 	movl   $0x4175,0x4(%esp)
      44:	00 
      45:	89 04 24             	mov    %eax,(%esp)
      48:	e8 40 3d 00 00       	call   3d8d <printf>
    exit();
      4d:	e8 b3 3b 00 00       	call   3c05 <exit>
  }
  close(fd);
      52:	8b 45 f4             	mov    -0xc(%ebp),%eax
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 d0 3b 00 00       	call   3c2d <close>
  fd = open("doesnotexist", 0);
      5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      64:	00 
      65:	c7 04 24 88 41 00 00 	movl   $0x4188,(%esp)
      6c:	e8 d4 3b 00 00       	call   3c45 <open>
      71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
      74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      78:	78 1a                	js     94 <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
      7a:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
      7f:	c7 44 24 04 95 41 00 	movl   $0x4195,0x4(%esp)
      86:	00 
      87:	89 04 24             	mov    %eax,(%esp)
      8a:	e8 fe 3c 00 00       	call   3d8d <printf>
    exit();
      8f:	e8 71 3b 00 00       	call   3c05 <exit>
  }
  printf(stdout, "open test ok\n");
      94:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
      99:	c7 44 24 04 b3 41 00 	movl   $0x41b3,0x4(%esp)
      a0:	00 
      a1:	89 04 24             	mov    %eax,(%esp)
      a4:	e8 e4 3c 00 00       	call   3d8d <printf>
}
      a9:	c9                   	leave  
      aa:	c3                   	ret    

000000ab <writetest>:

void
writetest(void)
{
      ab:	55                   	push   %ebp
      ac:	89 e5                	mov    %esp,%ebp
      ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
      b1:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
      b6:	c7 44 24 04 c1 41 00 	movl   $0x41c1,0x4(%esp)
      bd:	00 
      be:	89 04 24             	mov    %eax,(%esp)
      c1:	e8 c7 3c 00 00       	call   3d8d <printf>
  fd = open("small", O_CREATE|O_RDWR);
      c6:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
      cd:	00 
      ce:	c7 04 24 d2 41 00 00 	movl   $0x41d2,(%esp)
      d5:	e8 6b 3b 00 00       	call   3c45 <open>
      da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
      dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      e1:	78 21                	js     104 <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
      e3:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
      e8:	c7 44 24 04 d8 41 00 	movl   $0x41d8,0x4(%esp)
      ef:	00 
      f0:	89 04 24             	mov    %eax,(%esp)
      f3:	e8 95 3c 00 00       	call   3d8d <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
      f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      ff:	e9 9f 00 00 00       	jmp    1a3 <writetest+0xf8>
    printf(stdout, "error: creat small failed!\n");
     104:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     109:	c7 44 24 04 f3 41 00 	movl   $0x41f3,0x4(%esp)
     110:	00 
     111:	89 04 24             	mov    %eax,(%esp)
     114:	e8 74 3c 00 00       	call   3d8d <printf>
    exit();
     119:	e8 e7 3a 00 00       	call   3c05 <exit>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     11e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     125:	00 
     126:	c7 44 24 04 0f 42 00 	movl   $0x420f,0x4(%esp)
     12d:	00 
     12e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     131:	89 04 24             	mov    %eax,(%esp)
     134:	e8 ec 3a 00 00       	call   3c25 <write>
     139:	83 f8 0a             	cmp    $0xa,%eax
     13c:	74 21                	je     15f <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     13e:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     143:	8b 55 f4             	mov    -0xc(%ebp),%edx
     146:	89 54 24 08          	mov    %edx,0x8(%esp)
     14a:	c7 44 24 04 1c 42 00 	movl   $0x421c,0x4(%esp)
     151:	00 
     152:	89 04 24             	mov    %eax,(%esp)
     155:	e8 33 3c 00 00       	call   3d8d <printf>
      exit();
     15a:	e8 a6 3a 00 00       	call   3c05 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     15f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     166:	00 
     167:	c7 44 24 04 40 42 00 	movl   $0x4240,0x4(%esp)
     16e:	00 
     16f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     172:	89 04 24             	mov    %eax,(%esp)
     175:	e8 ab 3a 00 00       	call   3c25 <write>
     17a:	83 f8 0a             	cmp    $0xa,%eax
     17d:	74 21                	je     1a0 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     17f:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     184:	8b 55 f4             	mov    -0xc(%ebp),%edx
     187:	89 54 24 08          	mov    %edx,0x8(%esp)
     18b:	c7 44 24 04 4c 42 00 	movl   $0x424c,0x4(%esp)
     192:	00 
     193:	89 04 24             	mov    %eax,(%esp)
     196:	e8 f2 3b 00 00       	call   3d8d <printf>
      exit();
     19b:	e8 65 3a 00 00       	call   3c05 <exit>
  for(i = 0; i < 100; i++){
     1a0:	ff 45 f4             	incl   -0xc(%ebp)
     1a3:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     1a7:	0f 8e 71 ff ff ff    	jle    11e <writetest+0x73>
    }
  }
  printf(stdout, "writes ok\n");
     1ad:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     1b2:	c7 44 24 04 70 42 00 	movl   $0x4270,0x4(%esp)
     1b9:	00 
     1ba:	89 04 24             	mov    %eax,(%esp)
     1bd:	e8 cb 3b 00 00       	call   3d8d <printf>
  close(fd);
     1c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1c5:	89 04 24             	mov    %eax,(%esp)
     1c8:	e8 60 3a 00 00       	call   3c2d <close>
  fd = open("small", O_RDONLY);
     1cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     1d4:	00 
     1d5:	c7 04 24 d2 41 00 00 	movl   $0x41d2,(%esp)
     1dc:	e8 64 3a 00 00       	call   3c45 <open>
     1e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     1e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1e8:	78 3e                	js     228 <writetest+0x17d>
    printf(stdout, "open small succeeded ok\n");
     1ea:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     1ef:	c7 44 24 04 7b 42 00 	movl   $0x427b,0x4(%esp)
     1f6:	00 
     1f7:	89 04 24             	mov    %eax,(%esp)
     1fa:	e8 8e 3b 00 00       	call   3d8d <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     1ff:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     206:	00 
     207:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     20e:	00 
     20f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     212:	89 04 24             	mov    %eax,(%esp)
     215:	e8 03 3a 00 00       	call   3c1d <read>
     21a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     21d:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     224:	74 1c                	je     242 <writetest+0x197>
     226:	eb 4c                	jmp    274 <writetest+0x1c9>
    printf(stdout, "error: open small failed!\n");
     228:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     22d:	c7 44 24 04 94 42 00 	movl   $0x4294,0x4(%esp)
     234:	00 
     235:	89 04 24             	mov    %eax,(%esp)
     238:	e8 50 3b 00 00       	call   3d8d <printf>
    exit();
     23d:	e8 c3 39 00 00       	call   3c05 <exit>
    printf(stdout, "read succeeded ok\n");
     242:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     247:	c7 44 24 04 af 42 00 	movl   $0x42af,0x4(%esp)
     24e:	00 
     24f:	89 04 24             	mov    %eax,(%esp)
     252:	e8 36 3b 00 00       	call   3d8d <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     257:	8b 45 f0             	mov    -0x10(%ebp),%eax
     25a:	89 04 24             	mov    %eax,(%esp)
     25d:	e8 cb 39 00 00       	call   3c2d <close>

  if(unlink("small") < 0){
     262:	c7 04 24 d2 41 00 00 	movl   $0x41d2,(%esp)
     269:	e8 e7 39 00 00       	call   3c55 <unlink>
     26e:	85 c0                	test   %eax,%eax
     270:	78 1c                	js     28e <writetest+0x1e3>
     272:	eb 34                	jmp    2a8 <writetest+0x1fd>
    printf(stdout, "read failed\n");
     274:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     279:	c7 44 24 04 c2 42 00 	movl   $0x42c2,0x4(%esp)
     280:	00 
     281:	89 04 24             	mov    %eax,(%esp)
     284:	e8 04 3b 00 00       	call   3d8d <printf>
    exit();
     289:	e8 77 39 00 00       	call   3c05 <exit>
    printf(stdout, "unlink small failed\n");
     28e:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     293:	c7 44 24 04 cf 42 00 	movl   $0x42cf,0x4(%esp)
     29a:	00 
     29b:	89 04 24             	mov    %eax,(%esp)
     29e:	e8 ea 3a 00 00       	call   3d8d <printf>
    exit();
     2a3:	e8 5d 39 00 00       	call   3c05 <exit>
  }
  printf(stdout, "small file test ok\n");
     2a8:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     2ad:	c7 44 24 04 e4 42 00 	movl   $0x42e4,0x4(%esp)
     2b4:	00 
     2b5:	89 04 24             	mov    %eax,(%esp)
     2b8:	e8 d0 3a 00 00       	call   3d8d <printf>
}
     2bd:	c9                   	leave  
     2be:	c3                   	ret    

000002bf <writetest1>:

void
writetest1(void)
{
     2bf:	55                   	push   %ebp
     2c0:	89 e5                	mov    %esp,%ebp
     2c2:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     2c5:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     2ca:	c7 44 24 04 f8 42 00 	movl   $0x42f8,0x4(%esp)
     2d1:	00 
     2d2:	89 04 24             	mov    %eax,(%esp)
     2d5:	e8 b3 3a 00 00       	call   3d8d <printf>

  fd = open("big", O_CREATE|O_RDWR);
     2da:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     2e1:	00 
     2e2:	c7 04 24 08 43 00 00 	movl   $0x4308,(%esp)
     2e9:	e8 57 39 00 00       	call   3c45 <open>
     2ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     2f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     2f5:	79 1a                	jns    311 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     2f7:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     2fc:	c7 44 24 04 0c 43 00 	movl   $0x430c,0x4(%esp)
     303:	00 
     304:	89 04 24             	mov    %eax,(%esp)
     307:	e8 81 3a 00 00       	call   3d8d <printf>
    exit();
     30c:	e8 f4 38 00 00       	call   3c05 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     311:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     318:	eb 50                	jmp    36a <writetest1+0xab>
    ((int*)buf)[0] = i;
     31a:	b8 a0 86 00 00       	mov    $0x86a0,%eax
     31f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     322:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     324:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     32b:	00 
     32c:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     333:	00 
     334:	8b 45 ec             	mov    -0x14(%ebp),%eax
     337:	89 04 24             	mov    %eax,(%esp)
     33a:	e8 e6 38 00 00       	call   3c25 <write>
     33f:	3d 00 02 00 00       	cmp    $0x200,%eax
     344:	74 21                	je     367 <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     346:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     34b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     34e:	89 54 24 08          	mov    %edx,0x8(%esp)
     352:	c7 44 24 04 26 43 00 	movl   $0x4326,0x4(%esp)
     359:	00 
     35a:	89 04 24             	mov    %eax,(%esp)
     35d:	e8 2b 3a 00 00       	call   3d8d <printf>
      exit();
     362:	e8 9e 38 00 00       	call   3c05 <exit>
  for(i = 0; i < MAXFILE; i++){
     367:	ff 45 f4             	incl   -0xc(%ebp)
     36a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     36d:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     372:	76 a6                	jbe    31a <writetest1+0x5b>
    }
  }

  close(fd);
     374:	8b 45 ec             	mov    -0x14(%ebp),%eax
     377:	89 04 24             	mov    %eax,(%esp)
     37a:	e8 ae 38 00 00       	call   3c2d <close>

  fd = open("big", O_RDONLY);
     37f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     386:	00 
     387:	c7 04 24 08 43 00 00 	movl   $0x4308,(%esp)
     38e:	e8 b2 38 00 00       	call   3c45 <open>
     393:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     396:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     39a:	79 1a                	jns    3b6 <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     39c:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     3a1:	c7 44 24 04 44 43 00 	movl   $0x4344,0x4(%esp)
     3a8:	00 
     3a9:	89 04 24             	mov    %eax,(%esp)
     3ac:	e8 dc 39 00 00       	call   3d8d <printf>
    exit();
     3b1:	e8 4f 38 00 00       	call   3c05 <exit>
  }

  n = 0;
     3b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     3bd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     3c4:	00 
     3c5:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     3cc:	00 
     3cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     3d0:	89 04 24             	mov    %eax,(%esp)
     3d3:	e8 45 38 00 00       	call   3c1d <read>
     3d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     3db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     3df:	75 2e                	jne    40f <writetest1+0x150>
      if(n == MAXFILE - 1){
     3e1:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     3e8:	0f 85 8b 00 00 00    	jne    479 <writetest1+0x1ba>
        printf(stdout, "read only %d blocks from big", n);
     3ee:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     3f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3f6:	89 54 24 08          	mov    %edx,0x8(%esp)
     3fa:	c7 44 24 04 5d 43 00 	movl   $0x435d,0x4(%esp)
     401:	00 
     402:	89 04 24             	mov    %eax,(%esp)
     405:	e8 83 39 00 00       	call   3d8d <printf>
        exit();
     40a:	e8 f6 37 00 00       	call   3c05 <exit>
      }
      break;
    } else if(i != 512){
     40f:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     416:	74 21                	je     439 <writetest1+0x17a>
      printf(stdout, "read failed %d\n", i);
     418:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     41d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     420:	89 54 24 08          	mov    %edx,0x8(%esp)
     424:	c7 44 24 04 7a 43 00 	movl   $0x437a,0x4(%esp)
     42b:	00 
     42c:	89 04 24             	mov    %eax,(%esp)
     42f:	e8 59 39 00 00       	call   3d8d <printf>
      exit();
     434:	e8 cc 37 00 00       	call   3c05 <exit>
    }
    if(((int*)buf)[0] != n){
     439:	b8 a0 86 00 00       	mov    $0x86a0,%eax
     43e:	8b 00                	mov    (%eax),%eax
     440:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     443:	74 2c                	je     471 <writetest1+0x1b2>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     445:	b8 a0 86 00 00       	mov    $0x86a0,%eax
      printf(stdout, "read content of block %d is %d\n",
     44a:	8b 10                	mov    (%eax),%edx
     44c:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     451:	89 54 24 0c          	mov    %edx,0xc(%esp)
     455:	8b 55 f0             	mov    -0x10(%ebp),%edx
     458:	89 54 24 08          	mov    %edx,0x8(%esp)
     45c:	c7 44 24 04 8c 43 00 	movl   $0x438c,0x4(%esp)
     463:	00 
     464:	89 04 24             	mov    %eax,(%esp)
     467:	e8 21 39 00 00       	call   3d8d <printf>
      exit();
     46c:	e8 94 37 00 00       	call   3c05 <exit>
    }
    n++;
     471:	ff 45 f0             	incl   -0x10(%ebp)
  }
     474:	e9 44 ff ff ff       	jmp    3bd <writetest1+0xfe>
      break;
     479:	90                   	nop
  close(fd);
     47a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     47d:	89 04 24             	mov    %eax,(%esp)
     480:	e8 a8 37 00 00       	call   3c2d <close>
  if(unlink("big") < 0){
     485:	c7 04 24 08 43 00 00 	movl   $0x4308,(%esp)
     48c:	e8 c4 37 00 00       	call   3c55 <unlink>
     491:	85 c0                	test   %eax,%eax
     493:	79 1a                	jns    4af <writetest1+0x1f0>
    printf(stdout, "unlink big failed\n");
     495:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     49a:	c7 44 24 04 ac 43 00 	movl   $0x43ac,0x4(%esp)
     4a1:	00 
     4a2:	89 04 24             	mov    %eax,(%esp)
     4a5:	e8 e3 38 00 00       	call   3d8d <printf>
    exit();
     4aa:	e8 56 37 00 00       	call   3c05 <exit>
  }
  printf(stdout, "big files ok\n");
     4af:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     4b4:	c7 44 24 04 bf 43 00 	movl   $0x43bf,0x4(%esp)
     4bb:	00 
     4bc:	89 04 24             	mov    %eax,(%esp)
     4bf:	e8 c9 38 00 00       	call   3d8d <printf>
}
     4c4:	c9                   	leave  
     4c5:	c3                   	ret    

000004c6 <createtest>:

void
createtest(void)
{
     4c6:	55                   	push   %ebp
     4c7:	89 e5                	mov    %esp,%ebp
     4c9:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     4cc:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     4d1:	c7 44 24 04 d0 43 00 	movl   $0x43d0,0x4(%esp)
     4d8:	00 
     4d9:	89 04 24             	mov    %eax,(%esp)
     4dc:	e8 ac 38 00 00       	call   3d8d <printf>

  name[0] = 'a';
     4e1:	c6 05 a0 a6 00 00 61 	movb   $0x61,0xa6a0
  name[2] = '\0';
     4e8:	c6 05 a2 a6 00 00 00 	movb   $0x0,0xa6a2
  for(i = 0; i < 52; i++){
     4ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4f6:	eb 30                	jmp    528 <createtest+0x62>
    name[1] = '0' + i;
     4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fb:	83 c0 30             	add    $0x30,%eax
     4fe:	a2 a1 a6 00 00       	mov    %al,0xa6a1
    fd = open(name, O_CREATE|O_RDWR);
     503:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     50a:	00 
     50b:	c7 04 24 a0 a6 00 00 	movl   $0xa6a0,(%esp)
     512:	e8 2e 37 00 00       	call   3c45 <open>
     517:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     51a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     51d:	89 04 24             	mov    %eax,(%esp)
     520:	e8 08 37 00 00       	call   3c2d <close>
  for(i = 0; i < 52; i++){
     525:	ff 45 f4             	incl   -0xc(%ebp)
     528:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     52c:	7e ca                	jle    4f8 <createtest+0x32>
  }
  name[0] = 'a';
     52e:	c6 05 a0 a6 00 00 61 	movb   $0x61,0xa6a0
  name[2] = '\0';
     535:	c6 05 a2 a6 00 00 00 	movb   $0x0,0xa6a2
  for(i = 0; i < 52; i++){
     53c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     543:	eb 1a                	jmp    55f <createtest+0x99>
    name[1] = '0' + i;
     545:	8b 45 f4             	mov    -0xc(%ebp),%eax
     548:	83 c0 30             	add    $0x30,%eax
     54b:	a2 a1 a6 00 00       	mov    %al,0xa6a1
    unlink(name);
     550:	c7 04 24 a0 a6 00 00 	movl   $0xa6a0,(%esp)
     557:	e8 f9 36 00 00       	call   3c55 <unlink>
  for(i = 0; i < 52; i++){
     55c:	ff 45 f4             	incl   -0xc(%ebp)
     55f:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     563:	7e e0                	jle    545 <createtest+0x7f>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     565:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     56a:	c7 44 24 04 f8 43 00 	movl   $0x43f8,0x4(%esp)
     571:	00 
     572:	89 04 24             	mov    %eax,(%esp)
     575:	e8 13 38 00 00       	call   3d8d <printf>
}
     57a:	c9                   	leave  
     57b:	c3                   	ret    

0000057c <dirtest>:

void dirtest(void)
{
     57c:	55                   	push   %ebp
     57d:	89 e5                	mov    %esp,%ebp
     57f:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     582:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     587:	c7 44 24 04 1e 44 00 	movl   $0x441e,0x4(%esp)
     58e:	00 
     58f:	89 04 24             	mov    %eax,(%esp)
     592:	e8 f6 37 00 00       	call   3d8d <printf>

  if(mkdir("dir0") < 0){
     597:	c7 04 24 2a 44 00 00 	movl   $0x442a,(%esp)
     59e:	e8 ca 36 00 00       	call   3c6d <mkdir>
     5a3:	85 c0                	test   %eax,%eax
     5a5:	79 1a                	jns    5c1 <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     5a7:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     5ac:	c7 44 24 04 2f 44 00 	movl   $0x442f,0x4(%esp)
     5b3:	00 
     5b4:	89 04 24             	mov    %eax,(%esp)
     5b7:	e8 d1 37 00 00       	call   3d8d <printf>
    exit();
     5bc:	e8 44 36 00 00       	call   3c05 <exit>
  }

  if(chdir("dir0") < 0){
     5c1:	c7 04 24 2a 44 00 00 	movl   $0x442a,(%esp)
     5c8:	e8 a8 36 00 00       	call   3c75 <chdir>
     5cd:	85 c0                	test   %eax,%eax
     5cf:	79 1a                	jns    5eb <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     5d1:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     5d6:	c7 44 24 04 3d 44 00 	movl   $0x443d,0x4(%esp)
     5dd:	00 
     5de:	89 04 24             	mov    %eax,(%esp)
     5e1:	e8 a7 37 00 00       	call   3d8d <printf>
    exit();
     5e6:	e8 1a 36 00 00       	call   3c05 <exit>
  }

  if(chdir("..") < 0){
     5eb:	c7 04 24 50 44 00 00 	movl   $0x4450,(%esp)
     5f2:	e8 7e 36 00 00       	call   3c75 <chdir>
     5f7:	85 c0                	test   %eax,%eax
     5f9:	79 1a                	jns    615 <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     5fb:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     600:	c7 44 24 04 53 44 00 	movl   $0x4453,0x4(%esp)
     607:	00 
     608:	89 04 24             	mov    %eax,(%esp)
     60b:	e8 7d 37 00 00       	call   3d8d <printf>
    exit();
     610:	e8 f0 35 00 00       	call   3c05 <exit>
  }

  if(unlink("dir0") < 0){
     615:	c7 04 24 2a 44 00 00 	movl   $0x442a,(%esp)
     61c:	e8 34 36 00 00       	call   3c55 <unlink>
     621:	85 c0                	test   %eax,%eax
     623:	79 1a                	jns    63f <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     625:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     62a:	c7 44 24 04 64 44 00 	movl   $0x4464,0x4(%esp)
     631:	00 
     632:	89 04 24             	mov    %eax,(%esp)
     635:	e8 53 37 00 00       	call   3d8d <printf>
    exit();
     63a:	e8 c6 35 00 00       	call   3c05 <exit>
  }
  printf(stdout, "mkdir test\n");
     63f:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     644:	c7 44 24 04 1e 44 00 	movl   $0x441e,0x4(%esp)
     64b:	00 
     64c:	89 04 24             	mov    %eax,(%esp)
     64f:	e8 39 37 00 00       	call   3d8d <printf>
}
     654:	c9                   	leave  
     655:	c3                   	ret    

00000656 <exectest>:

void
exectest(void)
{
     656:	55                   	push   %ebp
     657:	89 e5                	mov    %esp,%ebp
     659:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     65c:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     661:	c7 44 24 04 78 44 00 	movl   $0x4478,0x4(%esp)
     668:	00 
     669:	89 04 24             	mov    %eax,(%esp)
     66c:	e8 1c 37 00 00       	call   3d8d <printf>
  if(exec("echo", echoargv) < 0){
     671:	c7 44 24 04 94 5e 00 	movl   $0x5e94,0x4(%esp)
     678:	00 
     679:	c7 04 24 54 41 00 00 	movl   $0x4154,(%esp)
     680:	e8 b8 35 00 00       	call   3c3d <exec>
     685:	85 c0                	test   %eax,%eax
     687:	79 1a                	jns    6a3 <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     689:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
     68e:	c7 44 24 04 83 44 00 	movl   $0x4483,0x4(%esp)
     695:	00 
     696:	89 04 24             	mov    %eax,(%esp)
     699:	e8 ef 36 00 00       	call   3d8d <printf>
    exit();
     69e:	e8 62 35 00 00       	call   3c05 <exit>
  }
}
     6a3:	c9                   	leave  
     6a4:	c3                   	ret    

000006a5 <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     6a5:	55                   	push   %ebp
     6a6:	89 e5                	mov    %esp,%ebp
     6a8:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     6ab:	8d 45 d8             	lea    -0x28(%ebp),%eax
     6ae:	89 04 24             	mov    %eax,(%esp)
     6b1:	e8 5f 35 00 00       	call   3c15 <pipe>
     6b6:	85 c0                	test   %eax,%eax
     6b8:	74 19                	je     6d3 <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     6ba:	c7 44 24 04 95 44 00 	movl   $0x4495,0x4(%esp)
     6c1:	00 
     6c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6c9:	e8 bf 36 00 00       	call   3d8d <printf>
    exit();
     6ce:	e8 32 35 00 00       	call   3c05 <exit>
  }
  pid = fork();
     6d3:	e8 25 35 00 00       	call   3bfd <fork>
     6d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     6db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     6e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     6e6:	0f 85 83 00 00 00    	jne    76f <pipe1+0xca>
    close(fds[0]);
     6ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
     6ef:	89 04 24             	mov    %eax,(%esp)
     6f2:	e8 36 35 00 00       	call   3c2d <close>
    for(n = 0; n < 5; n++){
     6f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     6fe:	eb 64                	jmp    764 <pipe1+0xbf>
      for(i = 0; i < 1033; i++)
     700:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     707:	eb 14                	jmp    71d <pipe1+0x78>
        buf[i] = seq++;
     709:	8b 45 f4             	mov    -0xc(%ebp),%eax
     70c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     70f:	81 c2 a0 86 00 00    	add    $0x86a0,%edx
     715:	88 02                	mov    %al,(%edx)
     717:	ff 45 f4             	incl   -0xc(%ebp)
      for(i = 0; i < 1033; i++)
     71a:	ff 45 f0             	incl   -0x10(%ebp)
     71d:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     724:	7e e3                	jle    709 <pipe1+0x64>
      if(write(fds[1], buf, 1033) != 1033){
     726:	8b 45 dc             	mov    -0x24(%ebp),%eax
     729:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     730:	00 
     731:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     738:	00 
     739:	89 04 24             	mov    %eax,(%esp)
     73c:	e8 e4 34 00 00       	call   3c25 <write>
     741:	3d 09 04 00 00       	cmp    $0x409,%eax
     746:	74 19                	je     761 <pipe1+0xbc>
        printf(1, "pipe1 oops 1\n");
     748:	c7 44 24 04 a4 44 00 	movl   $0x44a4,0x4(%esp)
     74f:	00 
     750:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     757:	e8 31 36 00 00       	call   3d8d <printf>
        exit();
     75c:	e8 a4 34 00 00       	call   3c05 <exit>
    for(n = 0; n < 5; n++){
     761:	ff 45 ec             	incl   -0x14(%ebp)
     764:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     768:	7e 96                	jle    700 <pipe1+0x5b>
      }
    }
    exit();
     76a:	e8 96 34 00 00       	call   3c05 <exit>
  } else if(pid > 0){
     76f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     773:	0f 8e f9 00 00 00    	jle    872 <pipe1+0x1cd>
    close(fds[1]);
     779:	8b 45 dc             	mov    -0x24(%ebp),%eax
     77c:	89 04 24             	mov    %eax,(%esp)
     77f:	e8 a9 34 00 00       	call   3c2d <close>
    total = 0;
     784:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     78b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     792:	eb 68                	jmp    7fc <pipe1+0x157>
      for(i = 0; i < n; i++){
     794:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     79b:	eb 3d                	jmp    7da <pipe1+0x135>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     79d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7a0:	05 a0 86 00 00       	add    $0x86a0,%eax
     7a5:	8a 00                	mov    (%eax),%al
     7a7:	0f be c0             	movsbl %al,%eax
     7aa:	33 45 f4             	xor    -0xc(%ebp),%eax
     7ad:	25 ff 00 00 00       	and    $0xff,%eax
     7b2:	85 c0                	test   %eax,%eax
     7b4:	0f 95 c0             	setne  %al
     7b7:	ff 45 f4             	incl   -0xc(%ebp)
     7ba:	84 c0                	test   %al,%al
     7bc:	74 19                	je     7d7 <pipe1+0x132>
          printf(1, "pipe1 oops 2\n");
     7be:	c7 44 24 04 b2 44 00 	movl   $0x44b2,0x4(%esp)
     7c5:	00 
     7c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     7cd:	e8 bb 35 00 00       	call   3d8d <printf>
     7d2:	e9 b4 00 00 00       	jmp    88b <pipe1+0x1e6>
      for(i = 0; i < n; i++){
     7d7:	ff 45 f0             	incl   -0x10(%ebp)
     7da:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     7e0:	7c bb                	jl     79d <pipe1+0xf8>
          return;
        }
      }
      total += n;
     7e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     7e5:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     7e8:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     7eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     7ee:	3d 00 20 00 00       	cmp    $0x2000,%eax
     7f3:	76 07                	jbe    7fc <pipe1+0x157>
        cc = sizeof(buf);
     7f5:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     7fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
     7ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
     802:	89 54 24 08          	mov    %edx,0x8(%esp)
     806:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     80d:	00 
     80e:	89 04 24             	mov    %eax,(%esp)
     811:	e8 07 34 00 00       	call   3c1d <read>
     816:	89 45 ec             	mov    %eax,-0x14(%ebp)
     819:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     81d:	0f 8f 71 ff ff ff    	jg     794 <pipe1+0xef>
    }
    if(total != 5 * 1033){
     823:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     82a:	74 20                	je     84c <pipe1+0x1a7>
      printf(1, "pipe1 oops 3 total %d\n", total);
     82c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     82f:	89 44 24 08          	mov    %eax,0x8(%esp)
     833:	c7 44 24 04 c0 44 00 	movl   $0x44c0,0x4(%esp)
     83a:	00 
     83b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     842:	e8 46 35 00 00       	call   3d8d <printf>
      exit();
     847:	e8 b9 33 00 00       	call   3c05 <exit>
    }
    close(fds[0]);
     84c:	8b 45 d8             	mov    -0x28(%ebp),%eax
     84f:	89 04 24             	mov    %eax,(%esp)
     852:	e8 d6 33 00 00       	call   3c2d <close>
    wait();
     857:	e8 b1 33 00 00       	call   3c0d <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     85c:	c7 44 24 04 d7 44 00 	movl   $0x44d7,0x4(%esp)
     863:	00 
     864:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     86b:	e8 1d 35 00 00       	call   3d8d <printf>
     870:	eb 19                	jmp    88b <pipe1+0x1e6>
    printf(1, "fork() failed\n");
     872:	c7 44 24 04 e1 44 00 	movl   $0x44e1,0x4(%esp)
     879:	00 
     87a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     881:	e8 07 35 00 00       	call   3d8d <printf>
    exit();
     886:	e8 7a 33 00 00       	call   3c05 <exit>
}
     88b:	c9                   	leave  
     88c:	c3                   	ret    

0000088d <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     88d:	55                   	push   %ebp
     88e:	89 e5                	mov    %esp,%ebp
     890:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     893:	c7 44 24 04 f0 44 00 	movl   $0x44f0,0x4(%esp)
     89a:	00 
     89b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8a2:	e8 e6 34 00 00       	call   3d8d <printf>
  pid1 = fork();
     8a7:	e8 51 33 00 00       	call   3bfd <fork>
     8ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     8af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     8b3:	75 02                	jne    8b7 <preempt+0x2a>
    for(;;)
      ;
     8b5:	eb fe                	jmp    8b5 <preempt+0x28>

  pid2 = fork();
     8b7:	e8 41 33 00 00       	call   3bfd <fork>
     8bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     8bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8c3:	75 02                	jne    8c7 <preempt+0x3a>
    for(;;)
      ;
     8c5:	eb fe                	jmp    8c5 <preempt+0x38>

  pipe(pfds);
     8c7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     8ca:	89 04 24             	mov    %eax,(%esp)
     8cd:	e8 43 33 00 00       	call   3c15 <pipe>
  pid3 = fork();
     8d2:	e8 26 33 00 00       	call   3bfd <fork>
     8d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     8da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8de:	75 4c                	jne    92c <preempt+0x9f>
    close(pfds[0]);
     8e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8e3:	89 04 24             	mov    %eax,(%esp)
     8e6:	e8 42 33 00 00       	call   3c2d <close>
    if(write(pfds[1], "x", 1) != 1)
     8eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     8f5:	00 
     8f6:	c7 44 24 04 fa 44 00 	movl   $0x44fa,0x4(%esp)
     8fd:	00 
     8fe:	89 04 24             	mov    %eax,(%esp)
     901:	e8 1f 33 00 00       	call   3c25 <write>
     906:	83 f8 01             	cmp    $0x1,%eax
     909:	74 14                	je     91f <preempt+0x92>
      printf(1, "preempt write error");
     90b:	c7 44 24 04 fc 44 00 	movl   $0x44fc,0x4(%esp)
     912:	00 
     913:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     91a:	e8 6e 34 00 00       	call   3d8d <printf>
    close(pfds[1]);
     91f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     922:	89 04 24             	mov    %eax,(%esp)
     925:	e8 03 33 00 00       	call   3c2d <close>
    for(;;)
      ;
     92a:	eb fe                	jmp    92a <preempt+0x9d>
  }

  close(pfds[1]);
     92c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     92f:	89 04 24             	mov    %eax,(%esp)
     932:	e8 f6 32 00 00       	call   3c2d <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     937:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     93a:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     941:	00 
     942:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     949:	00 
     94a:	89 04 24             	mov    %eax,(%esp)
     94d:	e8 cb 32 00 00       	call   3c1d <read>
     952:	83 f8 01             	cmp    $0x1,%eax
     955:	74 16                	je     96d <preempt+0xe0>
    printf(1, "preempt read error");
     957:	c7 44 24 04 10 45 00 	movl   $0x4510,0x4(%esp)
     95e:	00 
     95f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     966:	e8 22 34 00 00       	call   3d8d <printf>
     96b:	eb 77                	jmp    9e4 <preempt+0x157>
    return;
  }
  close(pfds[0]);
     96d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     970:	89 04 24             	mov    %eax,(%esp)
     973:	e8 b5 32 00 00       	call   3c2d <close>
  printf(1, "kill... ");
     978:	c7 44 24 04 23 45 00 	movl   $0x4523,0x4(%esp)
     97f:	00 
     980:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     987:	e8 01 34 00 00       	call   3d8d <printf>
  kill(pid1);
     98c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     98f:	89 04 24             	mov    %eax,(%esp)
     992:	e8 9e 32 00 00       	call   3c35 <kill>
  kill(pid2);
     997:	8b 45 f0             	mov    -0x10(%ebp),%eax
     99a:	89 04 24             	mov    %eax,(%esp)
     99d:	e8 93 32 00 00       	call   3c35 <kill>
  kill(pid3);
     9a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9a5:	89 04 24             	mov    %eax,(%esp)
     9a8:	e8 88 32 00 00       	call   3c35 <kill>
  printf(1, "wait... ");
     9ad:	c7 44 24 04 2c 45 00 	movl   $0x452c,0x4(%esp)
     9b4:	00 
     9b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9bc:	e8 cc 33 00 00       	call   3d8d <printf>
  wait();
     9c1:	e8 47 32 00 00       	call   3c0d <wait>
  wait();
     9c6:	e8 42 32 00 00       	call   3c0d <wait>
  wait();
     9cb:	e8 3d 32 00 00       	call   3c0d <wait>
  printf(1, "preempt ok\n");
     9d0:	c7 44 24 04 35 45 00 	movl   $0x4535,0x4(%esp)
     9d7:	00 
     9d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9df:	e8 a9 33 00 00       	call   3d8d <printf>
}
     9e4:	c9                   	leave  
     9e5:	c3                   	ret    

000009e6 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     9e6:	55                   	push   %ebp
     9e7:	89 e5                	mov    %esp,%ebp
     9e9:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     9ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9f3:	eb 52                	jmp    a47 <exitwait+0x61>
    pid = fork();
     9f5:	e8 03 32 00 00       	call   3bfd <fork>
     9fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     9fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a01:	79 16                	jns    a19 <exitwait+0x33>
      printf(1, "fork failed\n");
     a03:	c7 44 24 04 41 45 00 	movl   $0x4541,0x4(%esp)
     a0a:	00 
     a0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a12:	e8 76 33 00 00       	call   3d8d <printf>
      return;
     a17:	eb 48                	jmp    a61 <exitwait+0x7b>
    }
    if(pid){
     a19:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     a1d:	74 20                	je     a3f <exitwait+0x59>
      if(wait() != pid){
     a1f:	e8 e9 31 00 00       	call   3c0d <wait>
     a24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     a27:	74 1b                	je     a44 <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     a29:	c7 44 24 04 4e 45 00 	movl   $0x454e,0x4(%esp)
     a30:	00 
     a31:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a38:	e8 50 33 00 00       	call   3d8d <printf>
        return;
     a3d:	eb 22                	jmp    a61 <exitwait+0x7b>
      }
    } else {
      exit();
     a3f:	e8 c1 31 00 00       	call   3c05 <exit>
  for(i = 0; i < 100; i++){
     a44:	ff 45 f4             	incl   -0xc(%ebp)
     a47:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     a4b:	7e a8                	jle    9f5 <exitwait+0xf>
    }
  }
  printf(1, "exitwait ok\n");
     a4d:	c7 44 24 04 5e 45 00 	movl   $0x455e,0x4(%esp)
     a54:	00 
     a55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a5c:	e8 2c 33 00 00       	call   3d8d <printf>
}
     a61:	c9                   	leave  
     a62:	c3                   	ret    

00000a63 <mem>:

void
mem(void)
{
     a63:	55                   	push   %ebp
     a64:	89 e5                	mov    %esp,%ebp
     a66:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     a69:	c7 44 24 04 6b 45 00 	movl   $0x456b,0x4(%esp)
     a70:	00 
     a71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a78:	e8 10 33 00 00       	call   3d8d <printf>
  ppid = getpid();
     a7d:	e8 03 32 00 00       	call   3c85 <getpid>
     a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     a85:	e8 73 31 00 00       	call   3bfd <fork>
     a8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     a8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     a91:	0f 85 aa 00 00 00    	jne    b41 <mem+0xde>
    m1 = 0;
     a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     a9e:	eb 0e                	jmp    aae <mem+0x4b>
      *(char**)m2 = m1;
     aa0:	8b 45 e8             	mov    -0x18(%ebp),%eax
     aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     aa6:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     aae:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     ab5:	e8 ba 35 00 00       	call   4074 <malloc>
     aba:	89 45 e8             	mov    %eax,-0x18(%ebp)
     abd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     ac1:	75 dd                	jne    aa0 <mem+0x3d>
    }
    while(m1){
     ac3:	eb 19                	jmp    ade <mem+0x7b>
      m2 = *(char**)m1;
     ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ac8:	8b 00                	mov    (%eax),%eax
     aca:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ad0:	89 04 24             	mov    %eax,(%esp)
     ad3:	e8 63 34 00 00       	call   3f3b <free>
      m1 = m2;
     ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(m1){
     ade:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ae2:	75 e1                	jne    ac5 <mem+0x62>
    }
    m1 = malloc(1024*20);
     ae4:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     aeb:	e8 84 35 00 00       	call   4074 <malloc>
     af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     af7:	75 24                	jne    b1d <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     af9:	c7 44 24 04 75 45 00 	movl   $0x4575,0x4(%esp)
     b00:	00 
     b01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b08:	e8 80 32 00 00       	call   3d8d <printf>
      kill(ppid);
     b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b10:	89 04 24             	mov    %eax,(%esp)
     b13:	e8 1d 31 00 00       	call   3c35 <kill>
      exit();
     b18:	e8 e8 30 00 00       	call   3c05 <exit>
    }
    free(m1);
     b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b20:	89 04 24             	mov    %eax,(%esp)
     b23:	e8 13 34 00 00       	call   3f3b <free>
    printf(1, "mem ok\n");
     b28:	c7 44 24 04 8f 45 00 	movl   $0x458f,0x4(%esp)
     b2f:	00 
     b30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b37:	e8 51 32 00 00       	call   3d8d <printf>
    exit();
     b3c:	e8 c4 30 00 00       	call   3c05 <exit>
  } else {
    wait();
     b41:	e8 c7 30 00 00       	call   3c0d <wait>
  }
}
     b46:	c9                   	leave  
     b47:	c3                   	ret    

00000b48 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     b48:	55                   	push   %ebp
     b49:	89 e5                	mov    %esp,%ebp
     b4b:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     b4e:	c7 44 24 04 97 45 00 	movl   $0x4597,0x4(%esp)
     b55:	00 
     b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b5d:	e8 2b 32 00 00       	call   3d8d <printf>

  unlink("sharedfd");
     b62:	c7 04 24 a6 45 00 00 	movl   $0x45a6,(%esp)
     b69:	e8 e7 30 00 00       	call   3c55 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     b6e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     b75:	00 
     b76:	c7 04 24 a6 45 00 00 	movl   $0x45a6,(%esp)
     b7d:	e8 c3 30 00 00       	call   3c45 <open>
     b82:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     b85:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b89:	79 19                	jns    ba4 <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     b8b:	c7 44 24 04 b0 45 00 	movl   $0x45b0,0x4(%esp)
     b92:	00 
     b93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b9a:	e8 ee 31 00 00       	call   3d8d <printf>
     b9f:	e9 9a 01 00 00       	jmp    d3e <sharedfd+0x1f6>
    return;
  }
  pid = fork();
     ba4:	e8 54 30 00 00       	call   3bfd <fork>
     ba9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     bac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     bb0:	75 07                	jne    bb9 <sharedfd+0x71>
     bb2:	b8 63 00 00 00       	mov    $0x63,%eax
     bb7:	eb 05                	jmp    bbe <sharedfd+0x76>
     bb9:	b8 70 00 00 00       	mov    $0x70,%eax
     bbe:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     bc5:	00 
     bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
     bca:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     bcd:	89 04 24             	mov    %eax,(%esp)
     bd0:	e8 9b 2e 00 00       	call   3a70 <memset>
  for(i = 0; i < 1000; i++){
     bd5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bdc:	eb 38                	jmp    c16 <sharedfd+0xce>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     bde:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     be5:	00 
     be6:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     be9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf0:	89 04 24             	mov    %eax,(%esp)
     bf3:	e8 2d 30 00 00       	call   3c25 <write>
     bf8:	83 f8 0a             	cmp    $0xa,%eax
     bfb:	74 16                	je     c13 <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     bfd:	c7 44 24 04 dc 45 00 	movl   $0x45dc,0x4(%esp)
     c04:	00 
     c05:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c0c:	e8 7c 31 00 00       	call   3d8d <printf>
      break;
     c11:	eb 0c                	jmp    c1f <sharedfd+0xd7>
  for(i = 0; i < 1000; i++){
     c13:	ff 45 f4             	incl   -0xc(%ebp)
     c16:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     c1d:	7e bf                	jle    bde <sharedfd+0x96>
    }
  }
  if(pid == 0)
     c1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     c23:	75 05                	jne    c2a <sharedfd+0xe2>
    exit();
     c25:	e8 db 2f 00 00       	call   3c05 <exit>
  else
    wait();
     c2a:	e8 de 2f 00 00       	call   3c0d <wait>
  close(fd);
     c2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c32:	89 04 24             	mov    %eax,(%esp)
     c35:	e8 f3 2f 00 00       	call   3c2d <close>
  fd = open("sharedfd", 0);
     c3a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c41:	00 
     c42:	c7 04 24 a6 45 00 00 	movl   $0x45a6,(%esp)
     c49:	e8 f7 2f 00 00       	call   3c45 <open>
     c4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     c51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c55:	79 19                	jns    c70 <sharedfd+0x128>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     c57:	c7 44 24 04 fc 45 00 	movl   $0x45fc,0x4(%esp)
     c5e:	00 
     c5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c66:	e8 22 31 00 00       	call   3d8d <printf>
     c6b:	e9 ce 00 00 00       	jmp    d3e <sharedfd+0x1f6>
    return;
  }
  nc = np = 0;
     c70:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     c7d:	eb 36                	jmp    cb5 <sharedfd+0x16d>
    for(i = 0; i < sizeof(buf); i++){
     c7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c86:	eb 25                	jmp    cad <sharedfd+0x165>
      if(buf[i] == 'c')
     c88:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c8e:	01 d0                	add    %edx,%eax
     c90:	8a 00                	mov    (%eax),%al
     c92:	3c 63                	cmp    $0x63,%al
     c94:	75 03                	jne    c99 <sharedfd+0x151>
        nc++;
     c96:	ff 45 f0             	incl   -0x10(%ebp)
      if(buf[i] == 'p')
     c99:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9f:	01 d0                	add    %edx,%eax
     ca1:	8a 00                	mov    (%eax),%al
     ca3:	3c 70                	cmp    $0x70,%al
     ca5:	75 03                	jne    caa <sharedfd+0x162>
        np++;
     ca7:	ff 45 ec             	incl   -0x14(%ebp)
    for(i = 0; i < sizeof(buf); i++){
     caa:	ff 45 f4             	incl   -0xc(%ebp)
     cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb0:	83 f8 09             	cmp    $0x9,%eax
     cb3:	76 d3                	jbe    c88 <sharedfd+0x140>
  while((n = read(fd, buf, sizeof(buf))) > 0){
     cb5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     cbc:	00 
     cbd:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
     cc4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cc7:	89 04 24             	mov    %eax,(%esp)
     cca:	e8 4e 2f 00 00       	call   3c1d <read>
     ccf:	89 45 e0             	mov    %eax,-0x20(%ebp)
     cd2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     cd6:	7f a7                	jg     c7f <sharedfd+0x137>
    }
  }
  close(fd);
     cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cdb:	89 04 24             	mov    %eax,(%esp)
     cde:	e8 4a 2f 00 00       	call   3c2d <close>
  unlink("sharedfd");
     ce3:	c7 04 24 a6 45 00 00 	movl   $0x45a6,(%esp)
     cea:	e8 66 2f 00 00       	call   3c55 <unlink>
  if(nc == 10000 && np == 10000){
     cef:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     cf6:	75 1f                	jne    d17 <sharedfd+0x1cf>
     cf8:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     cff:	75 16                	jne    d17 <sharedfd+0x1cf>
    printf(1, "sharedfd ok\n");
     d01:	c7 44 24 04 27 46 00 	movl   $0x4627,0x4(%esp)
     d08:	00 
     d09:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d10:	e8 78 30 00 00       	call   3d8d <printf>
     d15:	eb 27                	jmp    d3e <sharedfd+0x1f6>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d21:	89 44 24 08          	mov    %eax,0x8(%esp)
     d25:	c7 44 24 04 34 46 00 	movl   $0x4634,0x4(%esp)
     d2c:	00 
     d2d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d34:	e8 54 30 00 00       	call   3d8d <printf>
    exit();
     d39:	e8 c7 2e 00 00       	call   3c05 <exit>
  }
}
     d3e:	c9                   	leave  
     d3f:	c3                   	ret    

00000d40 <twofiles>:

// two processes write two different files at the same
// time, to test block allocation.
void
twofiles(void)
{
     d40:	55                   	push   %ebp
     d41:	89 e5                	mov    %esp,%ebp
     d43:	83 ec 38             	sub    $0x38,%esp
  int fd, pid, i, j, n, total;
  char *fname;

  printf(1, "twofiles test\n");
     d46:	c7 44 24 04 49 46 00 	movl   $0x4649,0x4(%esp)
     d4d:	00 
     d4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d55:	e8 33 30 00 00       	call   3d8d <printf>

  unlink("f1");
     d5a:	c7 04 24 58 46 00 00 	movl   $0x4658,(%esp)
     d61:	e8 ef 2e 00 00       	call   3c55 <unlink>
  unlink("f2");
     d66:	c7 04 24 5b 46 00 00 	movl   $0x465b,(%esp)
     d6d:	e8 e3 2e 00 00       	call   3c55 <unlink>

  pid = fork();
     d72:	e8 86 2e 00 00       	call   3bfd <fork>
     d77:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(pid < 0){
     d7a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d7e:	79 19                	jns    d99 <twofiles+0x59>
    printf(1, "fork failed\n");
     d80:	c7 44 24 04 41 45 00 	movl   $0x4541,0x4(%esp)
     d87:	00 
     d88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d8f:	e8 f9 2f 00 00       	call   3d8d <printf>
    exit();
     d94:	e8 6c 2e 00 00       	call   3c05 <exit>
  }

  fname = pid ? "f1" : "f2";
     d99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d9d:	74 07                	je     da6 <twofiles+0x66>
     d9f:	b8 58 46 00 00       	mov    $0x4658,%eax
     da4:	eb 05                	jmp    dab <twofiles+0x6b>
     da6:	b8 5b 46 00 00       	mov    $0x465b,%eax
     dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  fd = open(fname, O_CREATE | O_RDWR);
     dae:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     db5:	00 
     db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     db9:	89 04 24             	mov    %eax,(%esp)
     dbc:	e8 84 2e 00 00       	call   3c45 <open>
     dc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(fd < 0){
     dc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     dc8:	79 19                	jns    de3 <twofiles+0xa3>
    printf(1, "create failed\n");
     dca:	c7 44 24 04 5e 46 00 	movl   $0x465e,0x4(%esp)
     dd1:	00 
     dd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dd9:	e8 af 2f 00 00       	call   3d8d <printf>
    exit();
     dde:	e8 22 2e 00 00       	call   3c05 <exit>
  }

  memset(buf, pid?'p':'c', 512);
     de3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     de7:	74 07                	je     df0 <twofiles+0xb0>
     de9:	b8 70 00 00 00       	mov    $0x70,%eax
     dee:	eb 05                	jmp    df5 <twofiles+0xb5>
     df0:	b8 63 00 00 00       	mov    $0x63,%eax
     df5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     dfc:	00 
     dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
     e01:	c7 04 24 a0 86 00 00 	movl   $0x86a0,(%esp)
     e08:	e8 63 2c 00 00       	call   3a70 <memset>
  for(i = 0; i < 12; i++){
     e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e14:	eb 4a                	jmp    e60 <twofiles+0x120>
    if((n = write(fd, buf, 500)) != 500){
     e16:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
     e1d:	00 
     e1e:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     e25:	00 
     e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e29:	89 04 24             	mov    %eax,(%esp)
     e2c:	e8 f4 2d 00 00       	call   3c25 <write>
     e31:	89 45 dc             	mov    %eax,-0x24(%ebp)
     e34:	81 7d dc f4 01 00 00 	cmpl   $0x1f4,-0x24(%ebp)
     e3b:	74 20                	je     e5d <twofiles+0x11d>
      printf(1, "write failed %d\n", n);
     e3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
     e40:	89 44 24 08          	mov    %eax,0x8(%esp)
     e44:	c7 44 24 04 6d 46 00 	movl   $0x466d,0x4(%esp)
     e4b:	00 
     e4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e53:	e8 35 2f 00 00       	call   3d8d <printf>
      exit();
     e58:	e8 a8 2d 00 00       	call   3c05 <exit>
  for(i = 0; i < 12; i++){
     e5d:	ff 45 f4             	incl   -0xc(%ebp)
     e60:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
     e64:	7e b0                	jle    e16 <twofiles+0xd6>
    }
  }
  close(fd);
     e66:	8b 45 e0             	mov    -0x20(%ebp),%eax
     e69:	89 04 24             	mov    %eax,(%esp)
     e6c:	e8 bc 2d 00 00       	call   3c2d <close>
  if(pid)
     e71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e75:	74 11                	je     e88 <twofiles+0x148>
    wait();
     e77:	e8 91 2d 00 00       	call   3c0d <wait>
  else
    exit();

  for(i = 0; i < 2; i++){
     e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e83:	e9 e4 00 00 00       	jmp    f6c <twofiles+0x22c>
    exit();
     e88:	e8 78 2d 00 00       	call   3c05 <exit>
    fd = open(i?"f1":"f2", 0);
     e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e91:	74 07                	je     e9a <twofiles+0x15a>
     e93:	b8 58 46 00 00       	mov    $0x4658,%eax
     e98:	eb 05                	jmp    e9f <twofiles+0x15f>
     e9a:	b8 5b 46 00 00       	mov    $0x465b,%eax
     e9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     ea6:	00 
     ea7:	89 04 24             	mov    %eax,(%esp)
     eaa:	e8 96 2d 00 00       	call   3c45 <open>
     eaf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    total = 0;
     eb2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     eb9:	eb 56                	jmp    f11 <twofiles+0x1d1>
      for(j = 0; j < n; j++){
     ebb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ec2:	eb 3f                	jmp    f03 <twofiles+0x1c3>
        if(buf[j] != (i?'p':'c')){
     ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ec7:	05 a0 86 00 00       	add    $0x86a0,%eax
     ecc:	8a 00                	mov    (%eax),%al
     ece:	0f be d0             	movsbl %al,%edx
     ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ed5:	74 07                	je     ede <twofiles+0x19e>
     ed7:	b8 70 00 00 00       	mov    $0x70,%eax
     edc:	eb 05                	jmp    ee3 <twofiles+0x1a3>
     ede:	b8 63 00 00 00       	mov    $0x63,%eax
     ee3:	39 c2                	cmp    %eax,%edx
     ee5:	74 19                	je     f00 <twofiles+0x1c0>
          printf(1, "wrong char\n");
     ee7:	c7 44 24 04 7e 46 00 	movl   $0x467e,0x4(%esp)
     eee:	00 
     eef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ef6:	e8 92 2e 00 00       	call   3d8d <printf>
          exit();
     efb:	e8 05 2d 00 00       	call   3c05 <exit>
      for(j = 0; j < n; j++){
     f00:	ff 45 f0             	incl   -0x10(%ebp)
     f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f06:	3b 45 dc             	cmp    -0x24(%ebp),%eax
     f09:	7c b9                	jl     ec4 <twofiles+0x184>
        }
      }
      total += n;
     f0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     f0e:	01 45 ec             	add    %eax,-0x14(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f11:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     f18:	00 
     f19:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
     f20:	00 
     f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f24:	89 04 24             	mov    %eax,(%esp)
     f27:	e8 f1 2c 00 00       	call   3c1d <read>
     f2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
     f2f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
     f33:	7f 86                	jg     ebb <twofiles+0x17b>
    }
    close(fd);
     f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f38:	89 04 24             	mov    %eax,(%esp)
     f3b:	e8 ed 2c 00 00       	call   3c2d <close>
    if(total != 12*500){
     f40:	81 7d ec 70 17 00 00 	cmpl   $0x1770,-0x14(%ebp)
     f47:	74 20                	je     f69 <twofiles+0x229>
      printf(1, "wrong length %d\n", total);
     f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f4c:	89 44 24 08          	mov    %eax,0x8(%esp)
     f50:	c7 44 24 04 8a 46 00 	movl   $0x468a,0x4(%esp)
     f57:	00 
     f58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f5f:	e8 29 2e 00 00       	call   3d8d <printf>
      exit();
     f64:	e8 9c 2c 00 00       	call   3c05 <exit>
  for(i = 0; i < 2; i++){
     f69:	ff 45 f4             	incl   -0xc(%ebp)
     f6c:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
     f70:	0f 8e 17 ff ff ff    	jle    e8d <twofiles+0x14d>
    }
  }

  unlink("f1");
     f76:	c7 04 24 58 46 00 00 	movl   $0x4658,(%esp)
     f7d:	e8 d3 2c 00 00       	call   3c55 <unlink>
  unlink("f2");
     f82:	c7 04 24 5b 46 00 00 	movl   $0x465b,(%esp)
     f89:	e8 c7 2c 00 00       	call   3c55 <unlink>

  printf(1, "twofiles ok\n");
     f8e:	c7 44 24 04 9b 46 00 	movl   $0x469b,0x4(%esp)
     f95:	00 
     f96:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f9d:	e8 eb 2d 00 00       	call   3d8d <printf>
}
     fa2:	c9                   	leave  
     fa3:	c3                   	ret    

00000fa4 <createdelete>:

// two processes create and delete different files in same directory
void
createdelete(void)
{
     fa4:	55                   	push   %ebp
     fa5:	89 e5                	mov    %esp,%ebp
     fa7:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd;
  char name[32];

  printf(1, "createdelete test\n");
     faa:	c7 44 24 04 a8 46 00 	movl   $0x46a8,0x4(%esp)
     fb1:	00 
     fb2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fb9:	e8 cf 2d 00 00       	call   3d8d <printf>
  pid = fork();
     fbe:	e8 3a 2c 00 00       	call   3bfd <fork>
     fc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid < 0){
     fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fca:	79 19                	jns    fe5 <createdelete+0x41>
    printf(1, "fork failed\n");
     fcc:	c7 44 24 04 41 45 00 	movl   $0x4541,0x4(%esp)
     fd3:	00 
     fd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fdb:	e8 ad 2d 00 00       	call   3d8d <printf>
    exit();
     fe0:	e8 20 2c 00 00       	call   3c05 <exit>
  }

  name[0] = pid ? 'p' : 'c';
     fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fe9:	74 04                	je     fef <createdelete+0x4b>
     feb:	b0 70                	mov    $0x70,%al
     fed:	eb 02                	jmp    ff1 <createdelete+0x4d>
     fef:	b0 63                	mov    $0x63,%al
     ff1:	88 45 cc             	mov    %al,-0x34(%ebp)
  name[2] = '\0';
     ff4:	c6 45 ce 00          	movb   $0x0,-0x32(%ebp)
  for(i = 0; i < N; i++){
     ff8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     fff:	e9 96 00 00 00       	jmp    109a <createdelete+0xf6>
    name[1] = '0' + i;
    1004:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1007:	83 c0 30             	add    $0x30,%eax
    100a:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, O_CREATE | O_RDWR);
    100d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1014:	00 
    1015:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1018:	89 04 24             	mov    %eax,(%esp)
    101b:	e8 25 2c 00 00       	call   3c45 <open>
    1020:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    1023:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1027:	79 19                	jns    1042 <createdelete+0x9e>
      printf(1, "create failed\n");
    1029:	c7 44 24 04 5e 46 00 	movl   $0x465e,0x4(%esp)
    1030:	00 
    1031:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1038:	e8 50 2d 00 00       	call   3d8d <printf>
      exit();
    103d:	e8 c3 2b 00 00       	call   3c05 <exit>
    }
    close(fd);
    1042:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1045:	89 04 24             	mov    %eax,(%esp)
    1048:	e8 e0 2b 00 00       	call   3c2d <close>
    if(i > 0 && (i % 2 ) == 0){
    104d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1051:	7e 44                	jle    1097 <createdelete+0xf3>
    1053:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1056:	83 e0 01             	and    $0x1,%eax
    1059:	85 c0                	test   %eax,%eax
    105b:	75 3a                	jne    1097 <createdelete+0xf3>
      name[1] = '0' + (i / 2);
    105d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1060:	89 c2                	mov    %eax,%edx
    1062:	c1 ea 1f             	shr    $0x1f,%edx
    1065:	01 d0                	add    %edx,%eax
    1067:	d1 f8                	sar    %eax
    1069:	83 c0 30             	add    $0x30,%eax
    106c:	88 45 cd             	mov    %al,-0x33(%ebp)
      if(unlink(name) < 0){
    106f:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1072:	89 04 24             	mov    %eax,(%esp)
    1075:	e8 db 2b 00 00       	call   3c55 <unlink>
    107a:	85 c0                	test   %eax,%eax
    107c:	79 19                	jns    1097 <createdelete+0xf3>
        printf(1, "unlink failed\n");
    107e:	c7 44 24 04 bb 46 00 	movl   $0x46bb,0x4(%esp)
    1085:	00 
    1086:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    108d:	e8 fb 2c 00 00       	call   3d8d <printf>
        exit();
    1092:	e8 6e 2b 00 00       	call   3c05 <exit>
  for(i = 0; i < N; i++){
    1097:	ff 45 f4             	incl   -0xc(%ebp)
    109a:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    109e:	0f 8e 60 ff ff ff    	jle    1004 <createdelete+0x60>
      }
    }
  }

  if(pid==0)
    10a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    10a8:	75 05                	jne    10af <createdelete+0x10b>
    exit();
    10aa:	e8 56 2b 00 00       	call   3c05 <exit>
  else
    wait();
    10af:	e8 59 2b 00 00       	call   3c0d <wait>

  for(i = 0; i < N; i++){
    10b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    10bb:	e9 33 01 00 00       	jmp    11f3 <createdelete+0x24f>
    name[0] = 'p';
    10c0:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    10c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10c7:	83 c0 30             	add    $0x30,%eax
    10ca:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    10cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    10d4:	00 
    10d5:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10d8:	89 04 24             	mov    %eax,(%esp)
    10db:	e8 65 2b 00 00       	call   3c45 <open>
    10e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    10e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10e7:	74 06                	je     10ef <createdelete+0x14b>
    10e9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    10ed:	7e 26                	jle    1115 <createdelete+0x171>
    10ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    10f3:	79 20                	jns    1115 <createdelete+0x171>
      printf(1, "oops createdelete %s didn't exist\n", name);
    10f5:	8d 45 cc             	lea    -0x34(%ebp),%eax
    10f8:	89 44 24 08          	mov    %eax,0x8(%esp)
    10fc:	c7 44 24 04 cc 46 00 	movl   $0x46cc,0x4(%esp)
    1103:	00 
    1104:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    110b:	e8 7d 2c 00 00       	call   3d8d <printf>
      exit();
    1110:	e8 f0 2a 00 00       	call   3c05 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    1115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1119:	7e 2c                	jle    1147 <createdelete+0x1a3>
    111b:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    111f:	7f 26                	jg     1147 <createdelete+0x1a3>
    1121:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1125:	78 20                	js     1147 <createdelete+0x1a3>
      printf(1, "oops createdelete %s did exist\n", name);
    1127:	8d 45 cc             	lea    -0x34(%ebp),%eax
    112a:	89 44 24 08          	mov    %eax,0x8(%esp)
    112e:	c7 44 24 04 f0 46 00 	movl   $0x46f0,0x4(%esp)
    1135:	00 
    1136:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    113d:	e8 4b 2c 00 00       	call   3d8d <printf>
      exit();
    1142:	e8 be 2a 00 00       	call   3c05 <exit>
    }
    if(fd >= 0)
    1147:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    114b:	78 0b                	js     1158 <createdelete+0x1b4>
      close(fd);
    114d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1150:	89 04 24             	mov    %eax,(%esp)
    1153:	e8 d5 2a 00 00       	call   3c2d <close>

    name[0] = 'c';
    1158:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    name[1] = '0' + i;
    115c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    115f:	83 c0 30             	add    $0x30,%eax
    1162:	88 45 cd             	mov    %al,-0x33(%ebp)
    fd = open(name, 0);
    1165:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    116c:	00 
    116d:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1170:	89 04 24             	mov    %eax,(%esp)
    1173:	e8 cd 2a 00 00       	call   3c45 <open>
    1178:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((i == 0 || i >= N/2) && fd < 0){
    117b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    117f:	74 06                	je     1187 <createdelete+0x1e3>
    1181:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1185:	7e 26                	jle    11ad <createdelete+0x209>
    1187:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    118b:	79 20                	jns    11ad <createdelete+0x209>
      printf(1, "oops createdelete %s didn't exist\n", name);
    118d:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1190:	89 44 24 08          	mov    %eax,0x8(%esp)
    1194:	c7 44 24 04 cc 46 00 	movl   $0x46cc,0x4(%esp)
    119b:	00 
    119c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11a3:	e8 e5 2b 00 00       	call   3d8d <printf>
      exit();
    11a8:	e8 58 2a 00 00       	call   3c05 <exit>
    } else if((i >= 1 && i < N/2) && fd >= 0){
    11ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11b1:	7e 2c                	jle    11df <createdelete+0x23b>
    11b3:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    11b7:	7f 26                	jg     11df <createdelete+0x23b>
    11b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11bd:	78 20                	js     11df <createdelete+0x23b>
      printf(1, "oops createdelete %s did exist\n", name);
    11bf:	8d 45 cc             	lea    -0x34(%ebp),%eax
    11c2:	89 44 24 08          	mov    %eax,0x8(%esp)
    11c6:	c7 44 24 04 f0 46 00 	movl   $0x46f0,0x4(%esp)
    11cd:	00 
    11ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11d5:	e8 b3 2b 00 00       	call   3d8d <printf>
      exit();
    11da:	e8 26 2a 00 00       	call   3c05 <exit>
    }
    if(fd >= 0)
    11df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11e3:	78 0b                	js     11f0 <createdelete+0x24c>
      close(fd);
    11e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    11e8:	89 04 24             	mov    %eax,(%esp)
    11eb:	e8 3d 2a 00 00       	call   3c2d <close>
  for(i = 0; i < N; i++){
    11f0:	ff 45 f4             	incl   -0xc(%ebp)
    11f3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    11f7:	0f 8e c3 fe ff ff    	jle    10c0 <createdelete+0x11c>
  }

  for(i = 0; i < N; i++){
    11fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1204:	eb 2a                	jmp    1230 <createdelete+0x28c>
    name[0] = 'p';
    1206:	c6 45 cc 70          	movb   $0x70,-0x34(%ebp)
    name[1] = '0' + i;
    120a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120d:	83 c0 30             	add    $0x30,%eax
    1210:	88 45 cd             	mov    %al,-0x33(%ebp)
    unlink(name);
    1213:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1216:	89 04 24             	mov    %eax,(%esp)
    1219:	e8 37 2a 00 00       	call   3c55 <unlink>
    name[0] = 'c';
    121e:	c6 45 cc 63          	movb   $0x63,-0x34(%ebp)
    unlink(name);
    1222:	8d 45 cc             	lea    -0x34(%ebp),%eax
    1225:	89 04 24             	mov    %eax,(%esp)
    1228:	e8 28 2a 00 00       	call   3c55 <unlink>
  for(i = 0; i < N; i++){
    122d:	ff 45 f4             	incl   -0xc(%ebp)
    1230:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1234:	7e d0                	jle    1206 <createdelete+0x262>
  }

  printf(1, "createdelete ok\n");
    1236:	c7 44 24 04 10 47 00 	movl   $0x4710,0x4(%esp)
    123d:	00 
    123e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1245:	e8 43 2b 00 00       	call   3d8d <printf>
}
    124a:	c9                   	leave  
    124b:	c3                   	ret    

0000124c <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    124c:	55                   	push   %ebp
    124d:	89 e5                	mov    %esp,%ebp
    124f:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    1252:	c7 44 24 04 21 47 00 	movl   $0x4721,0x4(%esp)
    1259:	00 
    125a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1261:	e8 27 2b 00 00       	call   3d8d <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1266:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    126d:	00 
    126e:	c7 04 24 32 47 00 00 	movl   $0x4732,(%esp)
    1275:	e8 cb 29 00 00       	call   3c45 <open>
    127a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    127d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1281:	79 19                	jns    129c <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    1283:	c7 44 24 04 3d 47 00 	movl   $0x473d,0x4(%esp)
    128a:	00 
    128b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1292:	e8 f6 2a 00 00       	call   3d8d <printf>
    exit();
    1297:	e8 69 29 00 00       	call   3c05 <exit>
  }
  write(fd, "hello", 5);
    129c:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    12a3:	00 
    12a4:	c7 44 24 04 57 47 00 	movl   $0x4757,0x4(%esp)
    12ab:	00 
    12ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12af:	89 04 24             	mov    %eax,(%esp)
    12b2:	e8 6e 29 00 00       	call   3c25 <write>
  close(fd);
    12b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ba:	89 04 24             	mov    %eax,(%esp)
    12bd:	e8 6b 29 00 00       	call   3c2d <close>

  fd = open("unlinkread", O_RDWR);
    12c2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    12c9:	00 
    12ca:	c7 04 24 32 47 00 00 	movl   $0x4732,(%esp)
    12d1:	e8 6f 29 00 00       	call   3c45 <open>
    12d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    12d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12dd:	79 19                	jns    12f8 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    12df:	c7 44 24 04 5d 47 00 	movl   $0x475d,0x4(%esp)
    12e6:	00 
    12e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12ee:	e8 9a 2a 00 00       	call   3d8d <printf>
    exit();
    12f3:	e8 0d 29 00 00       	call   3c05 <exit>
  }
  if(unlink("unlinkread") != 0){
    12f8:	c7 04 24 32 47 00 00 	movl   $0x4732,(%esp)
    12ff:	e8 51 29 00 00       	call   3c55 <unlink>
    1304:	85 c0                	test   %eax,%eax
    1306:	74 19                	je     1321 <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    1308:	c7 44 24 04 75 47 00 	movl   $0x4775,0x4(%esp)
    130f:	00 
    1310:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1317:	e8 71 2a 00 00       	call   3d8d <printf>
    exit();
    131c:	e8 e4 28 00 00       	call   3c05 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1321:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1328:	00 
    1329:	c7 04 24 32 47 00 00 	movl   $0x4732,(%esp)
    1330:	e8 10 29 00 00       	call   3c45 <open>
    1335:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    1338:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    133f:	00 
    1340:	c7 44 24 04 8f 47 00 	movl   $0x478f,0x4(%esp)
    1347:	00 
    1348:	8b 45 f0             	mov    -0x10(%ebp),%eax
    134b:	89 04 24             	mov    %eax,(%esp)
    134e:	e8 d2 28 00 00       	call   3c25 <write>
  close(fd1);
    1353:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1356:	89 04 24             	mov    %eax,(%esp)
    1359:	e8 cf 28 00 00       	call   3c2d <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    135e:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1365:	00 
    1366:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    136d:	00 
    136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1371:	89 04 24             	mov    %eax,(%esp)
    1374:	e8 a4 28 00 00       	call   3c1d <read>
    1379:	83 f8 05             	cmp    $0x5,%eax
    137c:	74 19                	je     1397 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    137e:	c7 44 24 04 93 47 00 	movl   $0x4793,0x4(%esp)
    1385:	00 
    1386:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    138d:	e8 fb 29 00 00       	call   3d8d <printf>
    exit();
    1392:	e8 6e 28 00 00       	call   3c05 <exit>
  }
  if(buf[0] != 'h'){
    1397:	a0 a0 86 00 00       	mov    0x86a0,%al
    139c:	3c 68                	cmp    $0x68,%al
    139e:	74 19                	je     13b9 <unlinkread+0x16d>
    printf(1, "unlinkread wrong data\n");
    13a0:	c7 44 24 04 aa 47 00 	movl   $0x47aa,0x4(%esp)
    13a7:	00 
    13a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13af:	e8 d9 29 00 00       	call   3d8d <printf>
    exit();
    13b4:	e8 4c 28 00 00       	call   3c05 <exit>
  }
  if(write(fd, buf, 10) != 10){
    13b9:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    13c0:	00 
    13c1:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    13c8:	00 
    13c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13cc:	89 04 24             	mov    %eax,(%esp)
    13cf:	e8 51 28 00 00       	call   3c25 <write>
    13d4:	83 f8 0a             	cmp    $0xa,%eax
    13d7:	74 19                	je     13f2 <unlinkread+0x1a6>
    printf(1, "unlinkread write failed\n");
    13d9:	c7 44 24 04 c1 47 00 	movl   $0x47c1,0x4(%esp)
    13e0:	00 
    13e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    13e8:	e8 a0 29 00 00       	call   3d8d <printf>
    exit();
    13ed:	e8 13 28 00 00       	call   3c05 <exit>
  }
  close(fd);
    13f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f5:	89 04 24             	mov    %eax,(%esp)
    13f8:	e8 30 28 00 00       	call   3c2d <close>
  unlink("unlinkread");
    13fd:	c7 04 24 32 47 00 00 	movl   $0x4732,(%esp)
    1404:	e8 4c 28 00 00       	call   3c55 <unlink>
  printf(1, "unlinkread ok\n");
    1409:	c7 44 24 04 da 47 00 	movl   $0x47da,0x4(%esp)
    1410:	00 
    1411:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1418:	e8 70 29 00 00       	call   3d8d <printf>
}
    141d:	c9                   	leave  
    141e:	c3                   	ret    

0000141f <linktest>:

void
linktest(void)
{
    141f:	55                   	push   %ebp
    1420:	89 e5                	mov    %esp,%ebp
    1422:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    1425:	c7 44 24 04 e9 47 00 	movl   $0x47e9,0x4(%esp)
    142c:	00 
    142d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1434:	e8 54 29 00 00       	call   3d8d <printf>

  unlink("lf1");
    1439:	c7 04 24 f3 47 00 00 	movl   $0x47f3,(%esp)
    1440:	e8 10 28 00 00       	call   3c55 <unlink>
  unlink("lf2");
    1445:	c7 04 24 f7 47 00 00 	movl   $0x47f7,(%esp)
    144c:	e8 04 28 00 00       	call   3c55 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    1451:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1458:	00 
    1459:	c7 04 24 f3 47 00 00 	movl   $0x47f3,(%esp)
    1460:	e8 e0 27 00 00       	call   3c45 <open>
    1465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    146c:	79 19                	jns    1487 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    146e:	c7 44 24 04 fb 47 00 	movl   $0x47fb,0x4(%esp)
    1475:	00 
    1476:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    147d:	e8 0b 29 00 00       	call   3d8d <printf>
    exit();
    1482:	e8 7e 27 00 00       	call   3c05 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1487:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    148e:	00 
    148f:	c7 44 24 04 57 47 00 	movl   $0x4757,0x4(%esp)
    1496:	00 
    1497:	8b 45 f4             	mov    -0xc(%ebp),%eax
    149a:	89 04 24             	mov    %eax,(%esp)
    149d:	e8 83 27 00 00       	call   3c25 <write>
    14a2:	83 f8 05             	cmp    $0x5,%eax
    14a5:	74 19                	je     14c0 <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    14a7:	c7 44 24 04 0e 48 00 	movl   $0x480e,0x4(%esp)
    14ae:	00 
    14af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14b6:	e8 d2 28 00 00       	call   3d8d <printf>
    exit();
    14bb:	e8 45 27 00 00       	call   3c05 <exit>
  }
  close(fd);
    14c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c3:	89 04 24             	mov    %eax,(%esp)
    14c6:	e8 62 27 00 00       	call   3c2d <close>

  if(link("lf1", "lf2") < 0){
    14cb:	c7 44 24 04 f7 47 00 	movl   $0x47f7,0x4(%esp)
    14d2:	00 
    14d3:	c7 04 24 f3 47 00 00 	movl   $0x47f3,(%esp)
    14da:	e8 86 27 00 00       	call   3c65 <link>
    14df:	85 c0                	test   %eax,%eax
    14e1:	79 19                	jns    14fc <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    14e3:	c7 44 24 04 20 48 00 	movl   $0x4820,0x4(%esp)
    14ea:	00 
    14eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14f2:	e8 96 28 00 00       	call   3d8d <printf>
    exit();
    14f7:	e8 09 27 00 00       	call   3c05 <exit>
  }
  unlink("lf1");
    14fc:	c7 04 24 f3 47 00 00 	movl   $0x47f3,(%esp)
    1503:	e8 4d 27 00 00       	call   3c55 <unlink>

  if(open("lf1", 0) >= 0){
    1508:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    150f:	00 
    1510:	c7 04 24 f3 47 00 00 	movl   $0x47f3,(%esp)
    1517:	e8 29 27 00 00       	call   3c45 <open>
    151c:	85 c0                	test   %eax,%eax
    151e:	78 19                	js     1539 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    1520:	c7 44 24 04 38 48 00 	movl   $0x4838,0x4(%esp)
    1527:	00 
    1528:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    152f:	e8 59 28 00 00       	call   3d8d <printf>
    exit();
    1534:	e8 cc 26 00 00       	call   3c05 <exit>
  }

  fd = open("lf2", 0);
    1539:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1540:	00 
    1541:	c7 04 24 f7 47 00 00 	movl   $0x47f7,(%esp)
    1548:	e8 f8 26 00 00       	call   3c45 <open>
    154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1554:	79 19                	jns    156f <linktest+0x150>
    printf(1, "open lf2 failed\n");
    1556:	c7 44 24 04 5d 48 00 	movl   $0x485d,0x4(%esp)
    155d:	00 
    155e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1565:	e8 23 28 00 00       	call   3d8d <printf>
    exit();
    156a:	e8 96 26 00 00       	call   3c05 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    156f:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1576:	00 
    1577:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    157e:	00 
    157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1582:	89 04 24             	mov    %eax,(%esp)
    1585:	e8 93 26 00 00       	call   3c1d <read>
    158a:	83 f8 05             	cmp    $0x5,%eax
    158d:	74 19                	je     15a8 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    158f:	c7 44 24 04 6e 48 00 	movl   $0x486e,0x4(%esp)
    1596:	00 
    1597:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    159e:	e8 ea 27 00 00       	call   3d8d <printf>
    exit();
    15a3:	e8 5d 26 00 00       	call   3c05 <exit>
  }
  close(fd);
    15a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ab:	89 04 24             	mov    %eax,(%esp)
    15ae:	e8 7a 26 00 00       	call   3c2d <close>

  if(link("lf2", "lf2") >= 0){
    15b3:	c7 44 24 04 f7 47 00 	movl   $0x47f7,0x4(%esp)
    15ba:	00 
    15bb:	c7 04 24 f7 47 00 00 	movl   $0x47f7,(%esp)
    15c2:	e8 9e 26 00 00       	call   3c65 <link>
    15c7:	85 c0                	test   %eax,%eax
    15c9:	78 19                	js     15e4 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15cb:	c7 44 24 04 7f 48 00 	movl   $0x487f,0x4(%esp)
    15d2:	00 
    15d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15da:	e8 ae 27 00 00       	call   3d8d <printf>
    exit();
    15df:	e8 21 26 00 00       	call   3c05 <exit>
  }

  unlink("lf2");
    15e4:	c7 04 24 f7 47 00 00 	movl   $0x47f7,(%esp)
    15eb:	e8 65 26 00 00       	call   3c55 <unlink>
  if(link("lf2", "lf1") >= 0){
    15f0:	c7 44 24 04 f3 47 00 	movl   $0x47f3,0x4(%esp)
    15f7:	00 
    15f8:	c7 04 24 f7 47 00 00 	movl   $0x47f7,(%esp)
    15ff:	e8 61 26 00 00       	call   3c65 <link>
    1604:	85 c0                	test   %eax,%eax
    1606:	78 19                	js     1621 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    1608:	c7 44 24 04 a0 48 00 	movl   $0x48a0,0x4(%esp)
    160f:	00 
    1610:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1617:	e8 71 27 00 00       	call   3d8d <printf>
    exit();
    161c:	e8 e4 25 00 00       	call   3c05 <exit>
  }

  if(link(".", "lf1") >= 0){
    1621:	c7 44 24 04 f3 47 00 	movl   $0x47f3,0x4(%esp)
    1628:	00 
    1629:	c7 04 24 c3 48 00 00 	movl   $0x48c3,(%esp)
    1630:	e8 30 26 00 00       	call   3c65 <link>
    1635:	85 c0                	test   %eax,%eax
    1637:	78 19                	js     1652 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    1639:	c7 44 24 04 c5 48 00 	movl   $0x48c5,0x4(%esp)
    1640:	00 
    1641:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1648:	e8 40 27 00 00       	call   3d8d <printf>
    exit();
    164d:	e8 b3 25 00 00       	call   3c05 <exit>
  }

  printf(1, "linktest ok\n");
    1652:	c7 44 24 04 e1 48 00 	movl   $0x48e1,0x4(%esp)
    1659:	00 
    165a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1661:	e8 27 27 00 00       	call   3d8d <printf>
}
    1666:	c9                   	leave  
    1667:	c3                   	ret    

00001668 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1668:	55                   	push   %ebp
    1669:	89 e5                	mov    %esp,%ebp
    166b:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    166e:	c7 44 24 04 ee 48 00 	movl   $0x48ee,0x4(%esp)
    1675:	00 
    1676:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    167d:	e8 0b 27 00 00       	call   3d8d <printf>
  file[0] = 'C';
    1682:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1686:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    168a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1691:	e9 d0 00 00 00       	jmp    1766 <concreate+0xfe>
    file[1] = '0' + i;
    1696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1699:	83 c0 30             	add    $0x30,%eax
    169c:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    169f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16a2:	89 04 24             	mov    %eax,(%esp)
    16a5:	e8 ab 25 00 00       	call   3c55 <unlink>
    pid = fork();
    16aa:	e8 4e 25 00 00       	call   3bfd <fork>
    16af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    16b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16b6:	74 27                	je     16df <concreate+0x77>
    16b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16bb:	b9 03 00 00 00       	mov    $0x3,%ecx
    16c0:	99                   	cltd   
    16c1:	f7 f9                	idiv   %ecx
    16c3:	89 d0                	mov    %edx,%eax
    16c5:	83 f8 01             	cmp    $0x1,%eax
    16c8:	75 15                	jne    16df <concreate+0x77>
      link("C0", file);
    16ca:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16cd:	89 44 24 04          	mov    %eax,0x4(%esp)
    16d1:	c7 04 24 fe 48 00 00 	movl   $0x48fe,(%esp)
    16d8:	e8 88 25 00 00       	call   3c65 <link>
    16dd:	eb 74                	jmp    1753 <concreate+0xeb>
    } else if(pid == 0 && (i % 5) == 1){
    16df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16e3:	75 27                	jne    170c <concreate+0xa4>
    16e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    16e8:	b9 05 00 00 00       	mov    $0x5,%ecx
    16ed:	99                   	cltd   
    16ee:	f7 f9                	idiv   %ecx
    16f0:	89 d0                	mov    %edx,%eax
    16f2:	83 f8 01             	cmp    $0x1,%eax
    16f5:	75 15                	jne    170c <concreate+0xa4>
      link("C0", file);
    16f7:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    16fe:	c7 04 24 fe 48 00 00 	movl   $0x48fe,(%esp)
    1705:	e8 5b 25 00 00       	call   3c65 <link>
    170a:	eb 47                	jmp    1753 <concreate+0xeb>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    170c:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1713:	00 
    1714:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1717:	89 04 24             	mov    %eax,(%esp)
    171a:	e8 26 25 00 00       	call   3c45 <open>
    171f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    1722:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1726:	79 20                	jns    1748 <concreate+0xe0>
        printf(1, "concreate create %s failed\n", file);
    1728:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    172b:	89 44 24 08          	mov    %eax,0x8(%esp)
    172f:	c7 44 24 04 01 49 00 	movl   $0x4901,0x4(%esp)
    1736:	00 
    1737:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    173e:	e8 4a 26 00 00       	call   3d8d <printf>
        exit();
    1743:	e8 bd 24 00 00       	call   3c05 <exit>
      }
      close(fd);
    1748:	8b 45 e8             	mov    -0x18(%ebp),%eax
    174b:	89 04 24             	mov    %eax,(%esp)
    174e:	e8 da 24 00 00       	call   3c2d <close>
    }
    if(pid == 0)
    1753:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1757:	75 05                	jne    175e <concreate+0xf6>
      exit();
    1759:	e8 a7 24 00 00       	call   3c05 <exit>
    else
      wait();
    175e:	e8 aa 24 00 00       	call   3c0d <wait>
  for(i = 0; i < 40; i++){
    1763:	ff 45 f4             	incl   -0xc(%ebp)
    1766:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    176a:	0f 8e 26 ff ff ff    	jle    1696 <concreate+0x2e>
  }

  memset(fa, 0, sizeof(fa));
    1770:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1777:	00 
    1778:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    177f:	00 
    1780:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1783:	89 04 24             	mov    %eax,(%esp)
    1786:	e8 e5 22 00 00       	call   3a70 <memset>
  fd = open(".", 0);
    178b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1792:	00 
    1793:	c7 04 24 c3 48 00 00 	movl   $0x48c3,(%esp)
    179a:	e8 a6 24 00 00       	call   3c45 <open>
    179f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    17a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    17a9:	e9 9d 00 00 00       	jmp    184b <concreate+0x1e3>
    if(de.inum == 0)
    17ae:	8b 45 ac             	mov    -0x54(%ebp),%eax
    17b1:	66 85 c0             	test   %ax,%ax
    17b4:	0f 84 90 00 00 00    	je     184a <concreate+0x1e2>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    17ba:	8a 45 ae             	mov    -0x52(%ebp),%al
    17bd:	3c 43                	cmp    $0x43,%al
    17bf:	0f 85 86 00 00 00    	jne    184b <concreate+0x1e3>
    17c5:	8a 45 b0             	mov    -0x50(%ebp),%al
    17c8:	84 c0                	test   %al,%al
    17ca:	75 7f                	jne    184b <concreate+0x1e3>
      i = de.name[1] - '0';
    17cc:	8a 45 af             	mov    -0x51(%ebp),%al
    17cf:	0f be c0             	movsbl %al,%eax
    17d2:	83 e8 30             	sub    $0x30,%eax
    17d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    17d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17dc:	78 08                	js     17e6 <concreate+0x17e>
    17de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17e1:	83 f8 27             	cmp    $0x27,%eax
    17e4:	76 23                	jbe    1809 <concreate+0x1a1>
        printf(1, "concreate weird file %s\n", de.name);
    17e6:	8d 45 ac             	lea    -0x54(%ebp),%eax
    17e9:	83 c0 02             	add    $0x2,%eax
    17ec:	89 44 24 08          	mov    %eax,0x8(%esp)
    17f0:	c7 44 24 04 1d 49 00 	movl   $0x491d,0x4(%esp)
    17f7:	00 
    17f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17ff:	e8 89 25 00 00       	call   3d8d <printf>
        exit();
    1804:	e8 fc 23 00 00       	call   3c05 <exit>
      }
      if(fa[i]){
    1809:	8d 55 bd             	lea    -0x43(%ebp),%edx
    180c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    180f:	01 d0                	add    %edx,%eax
    1811:	8a 00                	mov    (%eax),%al
    1813:	84 c0                	test   %al,%al
    1815:	74 23                	je     183a <concreate+0x1d2>
        printf(1, "concreate duplicate file %s\n", de.name);
    1817:	8d 45 ac             	lea    -0x54(%ebp),%eax
    181a:	83 c0 02             	add    $0x2,%eax
    181d:	89 44 24 08          	mov    %eax,0x8(%esp)
    1821:	c7 44 24 04 36 49 00 	movl   $0x4936,0x4(%esp)
    1828:	00 
    1829:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1830:	e8 58 25 00 00       	call   3d8d <printf>
        exit();
    1835:	e8 cb 23 00 00       	call   3c05 <exit>
      }
      fa[i] = 1;
    183a:	8d 55 bd             	lea    -0x43(%ebp),%edx
    183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1840:	01 d0                	add    %edx,%eax
    1842:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1845:	ff 45 f0             	incl   -0x10(%ebp)
    1848:	eb 01                	jmp    184b <concreate+0x1e3>
      continue;
    184a:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    184b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1852:	00 
    1853:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1856:	89 44 24 04          	mov    %eax,0x4(%esp)
    185a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    185d:	89 04 24             	mov    %eax,(%esp)
    1860:	e8 b8 23 00 00       	call   3c1d <read>
    1865:	85 c0                	test   %eax,%eax
    1867:	0f 8f 41 ff ff ff    	jg     17ae <concreate+0x146>
    }
  }
  close(fd);
    186d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1870:	89 04 24             	mov    %eax,(%esp)
    1873:	e8 b5 23 00 00       	call   3c2d <close>

  if(n != 40){
    1878:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    187c:	74 19                	je     1897 <concreate+0x22f>
    printf(1, "concreate not enough files in directory listing\n");
    187e:	c7 44 24 04 54 49 00 	movl   $0x4954,0x4(%esp)
    1885:	00 
    1886:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    188d:	e8 fb 24 00 00       	call   3d8d <printf>
    exit();
    1892:	e8 6e 23 00 00       	call   3c05 <exit>
  }

  for(i = 0; i < 40; i++){
    1897:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    189e:	e9 0c 01 00 00       	jmp    19af <concreate+0x347>
    file[1] = '0' + i;
    18a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a6:	83 c0 30             	add    $0x30,%eax
    18a9:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    18ac:	e8 4c 23 00 00       	call   3bfd <fork>
    18b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    18b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18b8:	79 19                	jns    18d3 <concreate+0x26b>
      printf(1, "fork failed\n");
    18ba:	c7 44 24 04 41 45 00 	movl   $0x4541,0x4(%esp)
    18c1:	00 
    18c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18c9:	e8 bf 24 00 00       	call   3d8d <printf>
      exit();
    18ce:	e8 32 23 00 00       	call   3c05 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    18d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d6:	b9 03 00 00 00       	mov    $0x3,%ecx
    18db:	99                   	cltd   
    18dc:	f7 f9                	idiv   %ecx
    18de:	89 d0                	mov    %edx,%eax
    18e0:	85 c0                	test   %eax,%eax
    18e2:	75 06                	jne    18ea <concreate+0x282>
    18e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18e8:	74 18                	je     1902 <concreate+0x29a>
       ((i % 3) == 1 && pid != 0)){
    18ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18ed:	b9 03 00 00 00       	mov    $0x3,%ecx
    18f2:	99                   	cltd   
    18f3:	f7 f9                	idiv   %ecx
    18f5:	89 d0                	mov    %edx,%eax
    if(((i % 3) == 0 && pid == 0) ||
    18f7:	83 f8 01             	cmp    $0x1,%eax
    18fa:	75 74                	jne    1970 <concreate+0x308>
       ((i % 3) == 1 && pid != 0)){
    18fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1900:	74 6e                	je     1970 <concreate+0x308>
      close(open(file, 0));
    1902:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1909:	00 
    190a:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    190d:	89 04 24             	mov    %eax,(%esp)
    1910:	e8 30 23 00 00       	call   3c45 <open>
    1915:	89 04 24             	mov    %eax,(%esp)
    1918:	e8 10 23 00 00       	call   3c2d <close>
      close(open(file, 0));
    191d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1924:	00 
    1925:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1928:	89 04 24             	mov    %eax,(%esp)
    192b:	e8 15 23 00 00       	call   3c45 <open>
    1930:	89 04 24             	mov    %eax,(%esp)
    1933:	e8 f5 22 00 00       	call   3c2d <close>
      close(open(file, 0));
    1938:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    193f:	00 
    1940:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1943:	89 04 24             	mov    %eax,(%esp)
    1946:	e8 fa 22 00 00       	call   3c45 <open>
    194b:	89 04 24             	mov    %eax,(%esp)
    194e:	e8 da 22 00 00       	call   3c2d <close>
      close(open(file, 0));
    1953:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    195a:	00 
    195b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195e:	89 04 24             	mov    %eax,(%esp)
    1961:	e8 df 22 00 00       	call   3c45 <open>
    1966:	89 04 24             	mov    %eax,(%esp)
    1969:	e8 bf 22 00 00       	call   3c2d <close>
    196e:	eb 2c                	jmp    199c <concreate+0x334>
    } else {
      unlink(file);
    1970:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1973:	89 04 24             	mov    %eax,(%esp)
    1976:	e8 da 22 00 00       	call   3c55 <unlink>
      unlink(file);
    197b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    197e:	89 04 24             	mov    %eax,(%esp)
    1981:	e8 cf 22 00 00       	call   3c55 <unlink>
      unlink(file);
    1986:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1989:	89 04 24             	mov    %eax,(%esp)
    198c:	e8 c4 22 00 00       	call   3c55 <unlink>
      unlink(file);
    1991:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1994:	89 04 24             	mov    %eax,(%esp)
    1997:	e8 b9 22 00 00       	call   3c55 <unlink>
    }
    if(pid == 0)
    199c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19a0:	75 05                	jne    19a7 <concreate+0x33f>
      exit();
    19a2:	e8 5e 22 00 00       	call   3c05 <exit>
    else
      wait();
    19a7:	e8 61 22 00 00       	call   3c0d <wait>
  for(i = 0; i < 40; i++){
    19ac:	ff 45 f4             	incl   -0xc(%ebp)
    19af:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    19b3:	0f 8e ea fe ff ff    	jle    18a3 <concreate+0x23b>
  }

  printf(1, "concreate ok\n");
    19b9:	c7 44 24 04 85 49 00 	movl   $0x4985,0x4(%esp)
    19c0:	00 
    19c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19c8:	e8 c0 23 00 00       	call   3d8d <printf>
}
    19cd:	c9                   	leave  
    19ce:	c3                   	ret    

000019cf <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    19cf:	55                   	push   %ebp
    19d0:	89 e5                	mov    %esp,%ebp
    19d2:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    19d5:	c7 44 24 04 93 49 00 	movl   $0x4993,0x4(%esp)
    19dc:	00 
    19dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19e4:	e8 a4 23 00 00       	call   3d8d <printf>

  unlink("x");
    19e9:	c7 04 24 fa 44 00 00 	movl   $0x44fa,(%esp)
    19f0:	e8 60 22 00 00       	call   3c55 <unlink>
  pid = fork();
    19f5:	e8 03 22 00 00       	call   3bfd <fork>
    19fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    19fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a01:	79 19                	jns    1a1c <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1a03:	c7 44 24 04 41 45 00 	movl   $0x4541,0x4(%esp)
    1a0a:	00 
    1a0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a12:	e8 76 23 00 00       	call   3d8d <printf>
    exit();
    1a17:	e8 e9 21 00 00       	call   3c05 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1a1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1a20:	74 07                	je     1a29 <linkunlink+0x5a>
    1a22:	b8 01 00 00 00       	mov    $0x1,%eax
    1a27:	eb 05                	jmp    1a2e <linkunlink+0x5f>
    1a29:	b8 61 00 00 00       	mov    $0x61,%eax
    1a2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1a31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1a38:	e9 a5 00 00 00       	jmp    1ae2 <linkunlink+0x113>
    x = x * 1103515245 + 12345;
    1a3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1a40:	89 ca                	mov    %ecx,%edx
    1a42:	89 d0                	mov    %edx,%eax
    1a44:	c1 e0 09             	shl    $0x9,%eax
    1a47:	89 c2                	mov    %eax,%edx
    1a49:	29 ca                	sub    %ecx,%edx
    1a4b:	c1 e2 02             	shl    $0x2,%edx
    1a4e:	01 ca                	add    %ecx,%edx
    1a50:	89 d0                	mov    %edx,%eax
    1a52:	c1 e0 09             	shl    $0x9,%eax
    1a55:	29 d0                	sub    %edx,%eax
    1a57:	d1 e0                	shl    %eax
    1a59:	01 c8                	add    %ecx,%eax
    1a5b:	89 c2                	mov    %eax,%edx
    1a5d:	c1 e2 05             	shl    $0x5,%edx
    1a60:	01 d0                	add    %edx,%eax
    1a62:	c1 e0 02             	shl    $0x2,%eax
    1a65:	29 c8                	sub    %ecx,%eax
    1a67:	c1 e0 02             	shl    $0x2,%eax
    1a6a:	01 c8                	add    %ecx,%eax
    1a6c:	05 39 30 00 00       	add    $0x3039,%eax
    1a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a77:	b9 03 00 00 00       	mov    $0x3,%ecx
    1a7c:	ba 00 00 00 00       	mov    $0x0,%edx
    1a81:	f7 f1                	div    %ecx
    1a83:	89 d0                	mov    %edx,%eax
    1a85:	85 c0                	test   %eax,%eax
    1a87:	75 1e                	jne    1aa7 <linkunlink+0xd8>
      close(open("x", O_RDWR | O_CREATE));
    1a89:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1a90:	00 
    1a91:	c7 04 24 fa 44 00 00 	movl   $0x44fa,(%esp)
    1a98:	e8 a8 21 00 00       	call   3c45 <open>
    1a9d:	89 04 24             	mov    %eax,(%esp)
    1aa0:	e8 88 21 00 00       	call   3c2d <close>
    1aa5:	eb 38                	jmp    1adf <linkunlink+0x110>
    } else if((x % 3) == 1){
    1aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aaa:	b9 03 00 00 00       	mov    $0x3,%ecx
    1aaf:	ba 00 00 00 00       	mov    $0x0,%edx
    1ab4:	f7 f1                	div    %ecx
    1ab6:	89 d0                	mov    %edx,%eax
    1ab8:	83 f8 01             	cmp    $0x1,%eax
    1abb:	75 16                	jne    1ad3 <linkunlink+0x104>
      link("cat", "x");
    1abd:	c7 44 24 04 fa 44 00 	movl   $0x44fa,0x4(%esp)
    1ac4:	00 
    1ac5:	c7 04 24 a4 49 00 00 	movl   $0x49a4,(%esp)
    1acc:	e8 94 21 00 00       	call   3c65 <link>
    1ad1:	eb 0c                	jmp    1adf <linkunlink+0x110>
    } else {
      unlink("x");
    1ad3:	c7 04 24 fa 44 00 00 	movl   $0x44fa,(%esp)
    1ada:	e8 76 21 00 00       	call   3c55 <unlink>
  for(i = 0; i < 100; i++){
    1adf:	ff 45 f4             	incl   -0xc(%ebp)
    1ae2:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1ae6:	0f 8e 51 ff ff ff    	jle    1a3d <linkunlink+0x6e>
    }
  }

  if(pid)
    1aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1af0:	74 1b                	je     1b0d <linkunlink+0x13e>
    wait();
    1af2:	e8 16 21 00 00       	call   3c0d <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1af7:	c7 44 24 04 a8 49 00 	movl   $0x49a8,0x4(%esp)
    1afe:	00 
    1aff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b06:	e8 82 22 00 00       	call   3d8d <printf>
    1b0b:	eb 05                	jmp    1b12 <linkunlink+0x143>
    exit();
    1b0d:	e8 f3 20 00 00       	call   3c05 <exit>
}
    1b12:	c9                   	leave  
    1b13:	c3                   	ret    

00001b14 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1b14:	55                   	push   %ebp
    1b15:	89 e5                	mov    %esp,%ebp
    1b17:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1b1a:	c7 44 24 04 b7 49 00 	movl   $0x49b7,0x4(%esp)
    1b21:	00 
    1b22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b29:	e8 5f 22 00 00       	call   3d8d <printf>
  unlink("bd");
    1b2e:	c7 04 24 c4 49 00 00 	movl   $0x49c4,(%esp)
    1b35:	e8 1b 21 00 00       	call   3c55 <unlink>

  fd = open("bd", O_CREATE);
    1b3a:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1b41:	00 
    1b42:	c7 04 24 c4 49 00 00 	movl   $0x49c4,(%esp)
    1b49:	e8 f7 20 00 00       	call   3c45 <open>
    1b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1b55:	79 19                	jns    1b70 <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1b57:	c7 44 24 04 c7 49 00 	movl   $0x49c7,0x4(%esp)
    1b5e:	00 
    1b5f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b66:	e8 22 22 00 00       	call   3d8d <printf>
    exit();
    1b6b:	e8 95 20 00 00       	call   3c05 <exit>
  }
  close(fd);
    1b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b73:	89 04 24             	mov    %eax,(%esp)
    1b76:	e8 b2 20 00 00       	call   3c2d <close>

  for(i = 0; i < 500; i++){
    1b7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b82:	eb 65                	jmp    1be9 <bigdir+0xd5>
    name[0] = 'x';
    1b84:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b8b:	85 c0                	test   %eax,%eax
    1b8d:	79 03                	jns    1b92 <bigdir+0x7e>
    1b8f:	83 c0 3f             	add    $0x3f,%eax
    1b92:	c1 f8 06             	sar    $0x6,%eax
    1b95:	83 c0 30             	add    $0x30,%eax
    1b98:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b9e:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1ba3:	85 c0                	test   %eax,%eax
    1ba5:	79 05                	jns    1bac <bigdir+0x98>
    1ba7:	48                   	dec    %eax
    1ba8:	83 c8 c0             	or     $0xffffffc0,%eax
    1bab:	40                   	inc    %eax
    1bac:	83 c0 30             	add    $0x30,%eax
    1baf:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1bb2:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1bb6:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
    1bbd:	c7 04 24 c4 49 00 00 	movl   $0x49c4,(%esp)
    1bc4:	e8 9c 20 00 00       	call   3c65 <link>
    1bc9:	85 c0                	test   %eax,%eax
    1bcb:	74 19                	je     1be6 <bigdir+0xd2>
      printf(1, "bigdir link failed\n");
    1bcd:	c7 44 24 04 dd 49 00 	movl   $0x49dd,0x4(%esp)
    1bd4:	00 
    1bd5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1bdc:	e8 ac 21 00 00       	call   3d8d <printf>
      exit();
    1be1:	e8 1f 20 00 00       	call   3c05 <exit>
  for(i = 0; i < 500; i++){
    1be6:	ff 45 f4             	incl   -0xc(%ebp)
    1be9:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1bf0:	7e 92                	jle    1b84 <bigdir+0x70>
    }
  }

  unlink("bd");
    1bf2:	c7 04 24 c4 49 00 00 	movl   $0x49c4,(%esp)
    1bf9:	e8 57 20 00 00       	call   3c55 <unlink>
  for(i = 0; i < 500; i++){
    1bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1c05:	eb 5d                	jmp    1c64 <bigdir+0x150>
    name[0] = 'x';
    1c07:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c0e:	85 c0                	test   %eax,%eax
    1c10:	79 03                	jns    1c15 <bigdir+0x101>
    1c12:	83 c0 3f             	add    $0x3f,%eax
    1c15:	c1 f8 06             	sar    $0x6,%eax
    1c18:	83 c0 30             	add    $0x30,%eax
    1c1b:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c21:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1c26:	85 c0                	test   %eax,%eax
    1c28:	79 05                	jns    1c2f <bigdir+0x11b>
    1c2a:	48                   	dec    %eax
    1c2b:	83 c8 c0             	or     $0xffffffc0,%eax
    1c2e:	40                   	inc    %eax
    1c2f:	83 c0 30             	add    $0x30,%eax
    1c32:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1c35:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1c39:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1c3c:	89 04 24             	mov    %eax,(%esp)
    1c3f:	e8 11 20 00 00       	call   3c55 <unlink>
    1c44:	85 c0                	test   %eax,%eax
    1c46:	74 19                	je     1c61 <bigdir+0x14d>
      printf(1, "bigdir unlink failed");
    1c48:	c7 44 24 04 f1 49 00 	movl   $0x49f1,0x4(%esp)
    1c4f:	00 
    1c50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c57:	e8 31 21 00 00       	call   3d8d <printf>
      exit();
    1c5c:	e8 a4 1f 00 00       	call   3c05 <exit>
  for(i = 0; i < 500; i++){
    1c61:	ff 45 f4             	incl   -0xc(%ebp)
    1c64:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1c6b:	7e 9a                	jle    1c07 <bigdir+0xf3>
    }
  }

  printf(1, "bigdir ok\n");
    1c6d:	c7 44 24 04 06 4a 00 	movl   $0x4a06,0x4(%esp)
    1c74:	00 
    1c75:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c7c:	e8 0c 21 00 00       	call   3d8d <printf>
}
    1c81:	c9                   	leave  
    1c82:	c3                   	ret    

00001c83 <subdir>:

void
subdir(void)
{
    1c83:	55                   	push   %ebp
    1c84:	89 e5                	mov    %esp,%ebp
    1c86:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1c89:	c7 44 24 04 11 4a 00 	movl   $0x4a11,0x4(%esp)
    1c90:	00 
    1c91:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c98:	e8 f0 20 00 00       	call   3d8d <printf>

  unlink("ff");
    1c9d:	c7 04 24 1e 4a 00 00 	movl   $0x4a1e,(%esp)
    1ca4:	e8 ac 1f 00 00       	call   3c55 <unlink>
  if(mkdir("dd") != 0){
    1ca9:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    1cb0:	e8 b8 1f 00 00       	call   3c6d <mkdir>
    1cb5:	85 c0                	test   %eax,%eax
    1cb7:	74 19                	je     1cd2 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1cb9:	c7 44 24 04 24 4a 00 	movl   $0x4a24,0x4(%esp)
    1cc0:	00 
    1cc1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cc8:	e8 c0 20 00 00       	call   3d8d <printf>
    exit();
    1ccd:	e8 33 1f 00 00       	call   3c05 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1cd2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1cd9:	00 
    1cda:	c7 04 24 3c 4a 00 00 	movl   $0x4a3c,(%esp)
    1ce1:	e8 5f 1f 00 00       	call   3c45 <open>
    1ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1ce9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ced:	79 19                	jns    1d08 <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1cef:	c7 44 24 04 42 4a 00 	movl   $0x4a42,0x4(%esp)
    1cf6:	00 
    1cf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1cfe:	e8 8a 20 00 00       	call   3d8d <printf>
    exit();
    1d03:	e8 fd 1e 00 00       	call   3c05 <exit>
  }
  write(fd, "ff", 2);
    1d08:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1d0f:	00 
    1d10:	c7 44 24 04 1e 4a 00 	movl   $0x4a1e,0x4(%esp)
    1d17:	00 
    1d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d1b:	89 04 24             	mov    %eax,(%esp)
    1d1e:	e8 02 1f 00 00       	call   3c25 <write>
  close(fd);
    1d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1d26:	89 04 24             	mov    %eax,(%esp)
    1d29:	e8 ff 1e 00 00       	call   3c2d <close>
  
  if(unlink("dd") >= 0){
    1d2e:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    1d35:	e8 1b 1f 00 00       	call   3c55 <unlink>
    1d3a:	85 c0                	test   %eax,%eax
    1d3c:	78 19                	js     1d57 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1d3e:	c7 44 24 04 58 4a 00 	movl   $0x4a58,0x4(%esp)
    1d45:	00 
    1d46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d4d:	e8 3b 20 00 00       	call   3d8d <printf>
    exit();
    1d52:	e8 ae 1e 00 00       	call   3c05 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1d57:	c7 04 24 7e 4a 00 00 	movl   $0x4a7e,(%esp)
    1d5e:	e8 0a 1f 00 00       	call   3c6d <mkdir>
    1d63:	85 c0                	test   %eax,%eax
    1d65:	74 19                	je     1d80 <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    1d67:	c7 44 24 04 85 4a 00 	movl   $0x4a85,0x4(%esp)
    1d6e:	00 
    1d6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d76:	e8 12 20 00 00       	call   3d8d <printf>
    exit();
    1d7b:	e8 85 1e 00 00       	call   3c05 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1d80:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d87:	00 
    1d88:	c7 04 24 a0 4a 00 00 	movl   $0x4aa0,(%esp)
    1d8f:	e8 b1 1e 00 00       	call   3c45 <open>
    1d94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1d97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1d9b:	79 19                	jns    1db6 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    1d9d:	c7 44 24 04 a9 4a 00 	movl   $0x4aa9,0x4(%esp)
    1da4:	00 
    1da5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1dac:	e8 dc 1f 00 00       	call   3d8d <printf>
    exit();
    1db1:	e8 4f 1e 00 00       	call   3c05 <exit>
  }
  write(fd, "FF", 2);
    1db6:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1dbd:	00 
    1dbe:	c7 44 24 04 c1 4a 00 	movl   $0x4ac1,0x4(%esp)
    1dc5:	00 
    1dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dc9:	89 04 24             	mov    %eax,(%esp)
    1dcc:	e8 54 1e 00 00       	call   3c25 <write>
  close(fd);
    1dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1dd4:	89 04 24             	mov    %eax,(%esp)
    1dd7:	e8 51 1e 00 00       	call   3c2d <close>

  fd = open("dd/dd/../ff", 0);
    1ddc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1de3:	00 
    1de4:	c7 04 24 c4 4a 00 00 	movl   $0x4ac4,(%esp)
    1deb:	e8 55 1e 00 00       	call   3c45 <open>
    1df0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1df3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1df7:	79 19                	jns    1e12 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    1df9:	c7 44 24 04 d0 4a 00 	movl   $0x4ad0,0x4(%esp)
    1e00:	00 
    1e01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e08:	e8 80 1f 00 00       	call   3d8d <printf>
    exit();
    1e0d:	e8 f3 1d 00 00       	call   3c05 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    1e12:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1e19:	00 
    1e1a:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    1e21:	00 
    1e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e25:	89 04 24             	mov    %eax,(%esp)
    1e28:	e8 f0 1d 00 00       	call   3c1d <read>
    1e2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    1e30:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    1e34:	75 09                	jne    1e3f <subdir+0x1bc>
    1e36:	a0 a0 86 00 00       	mov    0x86a0,%al
    1e3b:	3c 66                	cmp    $0x66,%al
    1e3d:	74 19                	je     1e58 <subdir+0x1d5>
    printf(1, "dd/dd/../ff wrong content\n");
    1e3f:	c7 44 24 04 e9 4a 00 	movl   $0x4ae9,0x4(%esp)
    1e46:	00 
    1e47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e4e:	e8 3a 1f 00 00       	call   3d8d <printf>
    exit();
    1e53:	e8 ad 1d 00 00       	call   3c05 <exit>
  }
  close(fd);
    1e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e5b:	89 04 24             	mov    %eax,(%esp)
    1e5e:	e8 ca 1d 00 00       	call   3c2d <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e63:	c7 44 24 04 04 4b 00 	movl   $0x4b04,0x4(%esp)
    1e6a:	00 
    1e6b:	c7 04 24 a0 4a 00 00 	movl   $0x4aa0,(%esp)
    1e72:	e8 ee 1d 00 00       	call   3c65 <link>
    1e77:	85 c0                	test   %eax,%eax
    1e79:	74 19                	je     1e94 <subdir+0x211>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    1e7b:	c7 44 24 04 10 4b 00 	movl   $0x4b10,0x4(%esp)
    1e82:	00 
    1e83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e8a:	e8 fe 1e 00 00       	call   3d8d <printf>
    exit();
    1e8f:	e8 71 1d 00 00       	call   3c05 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    1e94:	c7 04 24 a0 4a 00 00 	movl   $0x4aa0,(%esp)
    1e9b:	e8 b5 1d 00 00       	call   3c55 <unlink>
    1ea0:	85 c0                	test   %eax,%eax
    1ea2:	74 19                	je     1ebd <subdir+0x23a>
    printf(1, "unlink dd/dd/ff failed\n");
    1ea4:	c7 44 24 04 31 4b 00 	movl   $0x4b31,0x4(%esp)
    1eab:	00 
    1eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1eb3:	e8 d5 1e 00 00       	call   3d8d <printf>
    exit();
    1eb8:	e8 48 1d 00 00       	call   3c05 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ebd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1ec4:	00 
    1ec5:	c7 04 24 a0 4a 00 00 	movl   $0x4aa0,(%esp)
    1ecc:	e8 74 1d 00 00       	call   3c45 <open>
    1ed1:	85 c0                	test   %eax,%eax
    1ed3:	78 19                	js     1eee <subdir+0x26b>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    1ed5:	c7 44 24 04 4c 4b 00 	movl   $0x4b4c,0x4(%esp)
    1edc:	00 
    1edd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ee4:	e8 a4 1e 00 00       	call   3d8d <printf>
    exit();
    1ee9:	e8 17 1d 00 00       	call   3c05 <exit>
  }

  if(chdir("dd") != 0){
    1eee:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    1ef5:	e8 7b 1d 00 00       	call   3c75 <chdir>
    1efa:	85 c0                	test   %eax,%eax
    1efc:	74 19                	je     1f17 <subdir+0x294>
    printf(1, "chdir dd failed\n");
    1efe:	c7 44 24 04 70 4b 00 	movl   $0x4b70,0x4(%esp)
    1f05:	00 
    1f06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f0d:	e8 7b 1e 00 00       	call   3d8d <printf>
    exit();
    1f12:	e8 ee 1c 00 00       	call   3c05 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    1f17:	c7 04 24 81 4b 00 00 	movl   $0x4b81,(%esp)
    1f1e:	e8 52 1d 00 00       	call   3c75 <chdir>
    1f23:	85 c0                	test   %eax,%eax
    1f25:	74 19                	je     1f40 <subdir+0x2bd>
    printf(1, "chdir dd/../../dd failed\n");
    1f27:	c7 44 24 04 8d 4b 00 	movl   $0x4b8d,0x4(%esp)
    1f2e:	00 
    1f2f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f36:	e8 52 1e 00 00       	call   3d8d <printf>
    exit();
    1f3b:	e8 c5 1c 00 00       	call   3c05 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    1f40:	c7 04 24 a7 4b 00 00 	movl   $0x4ba7,(%esp)
    1f47:	e8 29 1d 00 00       	call   3c75 <chdir>
    1f4c:	85 c0                	test   %eax,%eax
    1f4e:	74 19                	je     1f69 <subdir+0x2e6>
    printf(1, "chdir dd/../../dd failed\n");
    1f50:	c7 44 24 04 8d 4b 00 	movl   $0x4b8d,0x4(%esp)
    1f57:	00 
    1f58:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f5f:	e8 29 1e 00 00       	call   3d8d <printf>
    exit();
    1f64:	e8 9c 1c 00 00       	call   3c05 <exit>
  }
  if(chdir("./..") != 0){
    1f69:	c7 04 24 b6 4b 00 00 	movl   $0x4bb6,(%esp)
    1f70:	e8 00 1d 00 00       	call   3c75 <chdir>
    1f75:	85 c0                	test   %eax,%eax
    1f77:	74 19                	je     1f92 <subdir+0x30f>
    printf(1, "chdir ./.. failed\n");
    1f79:	c7 44 24 04 bb 4b 00 	movl   $0x4bbb,0x4(%esp)
    1f80:	00 
    1f81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f88:	e8 00 1e 00 00       	call   3d8d <printf>
    exit();
    1f8d:	e8 73 1c 00 00       	call   3c05 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    1f92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1f99:	00 
    1f9a:	c7 04 24 04 4b 00 00 	movl   $0x4b04,(%esp)
    1fa1:	e8 9f 1c 00 00       	call   3c45 <open>
    1fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1fad:	79 19                	jns    1fc8 <subdir+0x345>
    printf(1, "open dd/dd/ffff failed\n");
    1faf:	c7 44 24 04 ce 4b 00 	movl   $0x4bce,0x4(%esp)
    1fb6:	00 
    1fb7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fbe:	e8 ca 1d 00 00       	call   3d8d <printf>
    exit();
    1fc3:	e8 3d 1c 00 00       	call   3c05 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1fc8:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1fcf:	00 
    1fd0:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    1fd7:	00 
    1fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fdb:	89 04 24             	mov    %eax,(%esp)
    1fde:	e8 3a 1c 00 00       	call   3c1d <read>
    1fe3:	83 f8 02             	cmp    $0x2,%eax
    1fe6:	74 19                	je     2001 <subdir+0x37e>
    printf(1, "read dd/dd/ffff wrong len\n");
    1fe8:	c7 44 24 04 e6 4b 00 	movl   $0x4be6,0x4(%esp)
    1fef:	00 
    1ff0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ff7:	e8 91 1d 00 00       	call   3d8d <printf>
    exit();
    1ffc:	e8 04 1c 00 00       	call   3c05 <exit>
  }
  close(fd);
    2001:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2004:	89 04 24             	mov    %eax,(%esp)
    2007:	e8 21 1c 00 00       	call   3c2d <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    200c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2013:	00 
    2014:	c7 04 24 a0 4a 00 00 	movl   $0x4aa0,(%esp)
    201b:	e8 25 1c 00 00       	call   3c45 <open>
    2020:	85 c0                	test   %eax,%eax
    2022:	78 19                	js     203d <subdir+0x3ba>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2024:	c7 44 24 04 04 4c 00 	movl   $0x4c04,0x4(%esp)
    202b:	00 
    202c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2033:	e8 55 1d 00 00       	call   3d8d <printf>
    exit();
    2038:	e8 c8 1b 00 00       	call   3c05 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    203d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2044:	00 
    2045:	c7 04 24 29 4c 00 00 	movl   $0x4c29,(%esp)
    204c:	e8 f4 1b 00 00       	call   3c45 <open>
    2051:	85 c0                	test   %eax,%eax
    2053:	78 19                	js     206e <subdir+0x3eb>
    printf(1, "create dd/ff/ff succeeded!\n");
    2055:	c7 44 24 04 32 4c 00 	movl   $0x4c32,0x4(%esp)
    205c:	00 
    205d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2064:	e8 24 1d 00 00       	call   3d8d <printf>
    exit();
    2069:	e8 97 1b 00 00       	call   3c05 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    206e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2075:	00 
    2076:	c7 04 24 4e 4c 00 00 	movl   $0x4c4e,(%esp)
    207d:	e8 c3 1b 00 00       	call   3c45 <open>
    2082:	85 c0                	test   %eax,%eax
    2084:	78 19                	js     209f <subdir+0x41c>
    printf(1, "create dd/xx/ff succeeded!\n");
    2086:	c7 44 24 04 57 4c 00 	movl   $0x4c57,0x4(%esp)
    208d:	00 
    208e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2095:	e8 f3 1c 00 00       	call   3d8d <printf>
    exit();
    209a:	e8 66 1b 00 00       	call   3c05 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    209f:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    20a6:	00 
    20a7:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    20ae:	e8 92 1b 00 00       	call   3c45 <open>
    20b3:	85 c0                	test   %eax,%eax
    20b5:	78 19                	js     20d0 <subdir+0x44d>
    printf(1, "create dd succeeded!\n");
    20b7:	c7 44 24 04 73 4c 00 	movl   $0x4c73,0x4(%esp)
    20be:	00 
    20bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20c6:	e8 c2 1c 00 00       	call   3d8d <printf>
    exit();
    20cb:	e8 35 1b 00 00       	call   3c05 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    20d0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    20d7:	00 
    20d8:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    20df:	e8 61 1b 00 00       	call   3c45 <open>
    20e4:	85 c0                	test   %eax,%eax
    20e6:	78 19                	js     2101 <subdir+0x47e>
    printf(1, "open dd rdwr succeeded!\n");
    20e8:	c7 44 24 04 89 4c 00 	movl   $0x4c89,0x4(%esp)
    20ef:	00 
    20f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20f7:	e8 91 1c 00 00       	call   3d8d <printf>
    exit();
    20fc:	e8 04 1b 00 00       	call   3c05 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    2101:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2108:	00 
    2109:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    2110:	e8 30 1b 00 00       	call   3c45 <open>
    2115:	85 c0                	test   %eax,%eax
    2117:	78 19                	js     2132 <subdir+0x4af>
    printf(1, "open dd wronly succeeded!\n");
    2119:	c7 44 24 04 a2 4c 00 	movl   $0x4ca2,0x4(%esp)
    2120:	00 
    2121:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2128:	e8 60 1c 00 00       	call   3d8d <printf>
    exit();
    212d:	e8 d3 1a 00 00       	call   3c05 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2132:	c7 44 24 04 bd 4c 00 	movl   $0x4cbd,0x4(%esp)
    2139:	00 
    213a:	c7 04 24 29 4c 00 00 	movl   $0x4c29,(%esp)
    2141:	e8 1f 1b 00 00       	call   3c65 <link>
    2146:	85 c0                	test   %eax,%eax
    2148:	75 19                	jne    2163 <subdir+0x4e0>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    214a:	c7 44 24 04 c8 4c 00 	movl   $0x4cc8,0x4(%esp)
    2151:	00 
    2152:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2159:	e8 2f 1c 00 00       	call   3d8d <printf>
    exit();
    215e:	e8 a2 1a 00 00       	call   3c05 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2163:	c7 44 24 04 bd 4c 00 	movl   $0x4cbd,0x4(%esp)
    216a:	00 
    216b:	c7 04 24 4e 4c 00 00 	movl   $0x4c4e,(%esp)
    2172:	e8 ee 1a 00 00       	call   3c65 <link>
    2177:	85 c0                	test   %eax,%eax
    2179:	75 19                	jne    2194 <subdir+0x511>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    217b:	c7 44 24 04 ec 4c 00 	movl   $0x4cec,0x4(%esp)
    2182:	00 
    2183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    218a:	e8 fe 1b 00 00       	call   3d8d <printf>
    exit();
    218f:	e8 71 1a 00 00       	call   3c05 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2194:	c7 44 24 04 04 4b 00 	movl   $0x4b04,0x4(%esp)
    219b:	00 
    219c:	c7 04 24 3c 4a 00 00 	movl   $0x4a3c,(%esp)
    21a3:	e8 bd 1a 00 00       	call   3c65 <link>
    21a8:	85 c0                	test   %eax,%eax
    21aa:	75 19                	jne    21c5 <subdir+0x542>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    21ac:	c7 44 24 04 10 4d 00 	movl   $0x4d10,0x4(%esp)
    21b3:	00 
    21b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21bb:	e8 cd 1b 00 00       	call   3d8d <printf>
    exit();
    21c0:	e8 40 1a 00 00       	call   3c05 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    21c5:	c7 04 24 29 4c 00 00 	movl   $0x4c29,(%esp)
    21cc:	e8 9c 1a 00 00       	call   3c6d <mkdir>
    21d1:	85 c0                	test   %eax,%eax
    21d3:	75 19                	jne    21ee <subdir+0x56b>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    21d5:	c7 44 24 04 32 4d 00 	movl   $0x4d32,0x4(%esp)
    21dc:	00 
    21dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21e4:	e8 a4 1b 00 00       	call   3d8d <printf>
    exit();
    21e9:	e8 17 1a 00 00       	call   3c05 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    21ee:	c7 04 24 4e 4c 00 00 	movl   $0x4c4e,(%esp)
    21f5:	e8 73 1a 00 00       	call   3c6d <mkdir>
    21fa:	85 c0                	test   %eax,%eax
    21fc:	75 19                	jne    2217 <subdir+0x594>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    21fe:	c7 44 24 04 4d 4d 00 	movl   $0x4d4d,0x4(%esp)
    2205:	00 
    2206:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    220d:	e8 7b 1b 00 00       	call   3d8d <printf>
    exit();
    2212:	e8 ee 19 00 00       	call   3c05 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    2217:	c7 04 24 04 4b 00 00 	movl   $0x4b04,(%esp)
    221e:	e8 4a 1a 00 00       	call   3c6d <mkdir>
    2223:	85 c0                	test   %eax,%eax
    2225:	75 19                	jne    2240 <subdir+0x5bd>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2227:	c7 44 24 04 68 4d 00 	movl   $0x4d68,0x4(%esp)
    222e:	00 
    222f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2236:	e8 52 1b 00 00       	call   3d8d <printf>
    exit();
    223b:	e8 c5 19 00 00       	call   3c05 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    2240:	c7 04 24 4e 4c 00 00 	movl   $0x4c4e,(%esp)
    2247:	e8 09 1a 00 00       	call   3c55 <unlink>
    224c:	85 c0                	test   %eax,%eax
    224e:	75 19                	jne    2269 <subdir+0x5e6>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2250:	c7 44 24 04 85 4d 00 	movl   $0x4d85,0x4(%esp)
    2257:	00 
    2258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    225f:	e8 29 1b 00 00       	call   3d8d <printf>
    exit();
    2264:	e8 9c 19 00 00       	call   3c05 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    2269:	c7 04 24 29 4c 00 00 	movl   $0x4c29,(%esp)
    2270:	e8 e0 19 00 00       	call   3c55 <unlink>
    2275:	85 c0                	test   %eax,%eax
    2277:	75 19                	jne    2292 <subdir+0x60f>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2279:	c7 44 24 04 a1 4d 00 	movl   $0x4da1,0x4(%esp)
    2280:	00 
    2281:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2288:	e8 00 1b 00 00       	call   3d8d <printf>
    exit();
    228d:	e8 73 19 00 00       	call   3c05 <exit>
  }
  if(chdir("dd/ff") == 0){
    2292:	c7 04 24 3c 4a 00 00 	movl   $0x4a3c,(%esp)
    2299:	e8 d7 19 00 00       	call   3c75 <chdir>
    229e:	85 c0                	test   %eax,%eax
    22a0:	75 19                	jne    22bb <subdir+0x638>
    printf(1, "chdir dd/ff succeeded!\n");
    22a2:	c7 44 24 04 bd 4d 00 	movl   $0x4dbd,0x4(%esp)
    22a9:	00 
    22aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22b1:	e8 d7 1a 00 00       	call   3d8d <printf>
    exit();
    22b6:	e8 4a 19 00 00       	call   3c05 <exit>
  }
  if(chdir("dd/xx") == 0){
    22bb:	c7 04 24 d5 4d 00 00 	movl   $0x4dd5,(%esp)
    22c2:	e8 ae 19 00 00       	call   3c75 <chdir>
    22c7:	85 c0                	test   %eax,%eax
    22c9:	75 19                	jne    22e4 <subdir+0x661>
    printf(1, "chdir dd/xx succeeded!\n");
    22cb:	c7 44 24 04 db 4d 00 	movl   $0x4ddb,0x4(%esp)
    22d2:	00 
    22d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22da:	e8 ae 1a 00 00       	call   3d8d <printf>
    exit();
    22df:	e8 21 19 00 00       	call   3c05 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    22e4:	c7 04 24 04 4b 00 00 	movl   $0x4b04,(%esp)
    22eb:	e8 65 19 00 00       	call   3c55 <unlink>
    22f0:	85 c0                	test   %eax,%eax
    22f2:	74 19                	je     230d <subdir+0x68a>
    printf(1, "unlink dd/dd/ff failed\n");
    22f4:	c7 44 24 04 31 4b 00 	movl   $0x4b31,0x4(%esp)
    22fb:	00 
    22fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2303:	e8 85 1a 00 00       	call   3d8d <printf>
    exit();
    2308:	e8 f8 18 00 00       	call   3c05 <exit>
  }
  if(unlink("dd/ff") != 0){
    230d:	c7 04 24 3c 4a 00 00 	movl   $0x4a3c,(%esp)
    2314:	e8 3c 19 00 00       	call   3c55 <unlink>
    2319:	85 c0                	test   %eax,%eax
    231b:	74 19                	je     2336 <subdir+0x6b3>
    printf(1, "unlink dd/ff failed\n");
    231d:	c7 44 24 04 f3 4d 00 	movl   $0x4df3,0x4(%esp)
    2324:	00 
    2325:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    232c:	e8 5c 1a 00 00       	call   3d8d <printf>
    exit();
    2331:	e8 cf 18 00 00       	call   3c05 <exit>
  }
  if(unlink("dd") == 0){
    2336:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    233d:	e8 13 19 00 00       	call   3c55 <unlink>
    2342:	85 c0                	test   %eax,%eax
    2344:	75 19                	jne    235f <subdir+0x6dc>
    printf(1, "unlink non-empty dd succeeded!\n");
    2346:	c7 44 24 04 08 4e 00 	movl   $0x4e08,0x4(%esp)
    234d:	00 
    234e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2355:	e8 33 1a 00 00       	call   3d8d <printf>
    exit();
    235a:	e8 a6 18 00 00       	call   3c05 <exit>
  }
  if(unlink("dd/dd") < 0){
    235f:	c7 04 24 28 4e 00 00 	movl   $0x4e28,(%esp)
    2366:	e8 ea 18 00 00       	call   3c55 <unlink>
    236b:	85 c0                	test   %eax,%eax
    236d:	79 19                	jns    2388 <subdir+0x705>
    printf(1, "unlink dd/dd failed\n");
    236f:	c7 44 24 04 2e 4e 00 	movl   $0x4e2e,0x4(%esp)
    2376:	00 
    2377:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    237e:	e8 0a 1a 00 00       	call   3d8d <printf>
    exit();
    2383:	e8 7d 18 00 00       	call   3c05 <exit>
  }
  if(unlink("dd") < 0){
    2388:	c7 04 24 21 4a 00 00 	movl   $0x4a21,(%esp)
    238f:	e8 c1 18 00 00       	call   3c55 <unlink>
    2394:	85 c0                	test   %eax,%eax
    2396:	79 19                	jns    23b1 <subdir+0x72e>
    printf(1, "unlink dd failed\n");
    2398:	c7 44 24 04 43 4e 00 	movl   $0x4e43,0x4(%esp)
    239f:	00 
    23a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23a7:	e8 e1 19 00 00       	call   3d8d <printf>
    exit();
    23ac:	e8 54 18 00 00       	call   3c05 <exit>
  }

  printf(1, "subdir ok\n");
    23b1:	c7 44 24 04 55 4e 00 	movl   $0x4e55,0x4(%esp)
    23b8:	00 
    23b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23c0:	e8 c8 19 00 00       	call   3d8d <printf>
}
    23c5:	c9                   	leave  
    23c6:	c3                   	ret    

000023c7 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    23c7:	55                   	push   %ebp
    23c8:	89 e5                	mov    %esp,%ebp
    23ca:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    23cd:	c7 44 24 04 60 4e 00 	movl   $0x4e60,0x4(%esp)
    23d4:	00 
    23d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23dc:	e8 ac 19 00 00       	call   3d8d <printf>

  unlink("bigwrite");
    23e1:	c7 04 24 6f 4e 00 00 	movl   $0x4e6f,(%esp)
    23e8:	e8 68 18 00 00       	call   3c55 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    23ed:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    23f4:	e9 b2 00 00 00       	jmp    24ab <bigwrite+0xe4>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    23f9:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2400:	00 
    2401:	c7 04 24 6f 4e 00 00 	movl   $0x4e6f,(%esp)
    2408:	e8 38 18 00 00       	call   3c45 <open>
    240d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    2410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2414:	79 19                	jns    242f <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    2416:	c7 44 24 04 78 4e 00 	movl   $0x4e78,0x4(%esp)
    241d:	00 
    241e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2425:	e8 63 19 00 00       	call   3d8d <printf>
      exit();
    242a:	e8 d6 17 00 00       	call   3c05 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    242f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2436:	eb 4f                	jmp    2487 <bigwrite+0xc0>
      int cc = write(fd, buf, sz);
    2438:	8b 45 f4             	mov    -0xc(%ebp),%eax
    243b:	89 44 24 08          	mov    %eax,0x8(%esp)
    243f:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    2446:	00 
    2447:	8b 45 ec             	mov    -0x14(%ebp),%eax
    244a:	89 04 24             	mov    %eax,(%esp)
    244d:	e8 d3 17 00 00       	call   3c25 <write>
    2452:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    2455:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2458:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    245b:	74 27                	je     2484 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    245d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2460:	89 44 24 0c          	mov    %eax,0xc(%esp)
    2464:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2467:	89 44 24 08          	mov    %eax,0x8(%esp)
    246b:	c7 44 24 04 90 4e 00 	movl   $0x4e90,0x4(%esp)
    2472:	00 
    2473:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    247a:	e8 0e 19 00 00       	call   3d8d <printf>
        exit();
    247f:	e8 81 17 00 00       	call   3c05 <exit>
    for(i = 0; i < 2; i++){
    2484:	ff 45 f0             	incl   -0x10(%ebp)
    2487:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    248b:	7e ab                	jle    2438 <bigwrite+0x71>
      }
    }
    close(fd);
    248d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2490:	89 04 24             	mov    %eax,(%esp)
    2493:	e8 95 17 00 00       	call   3c2d <close>
    unlink("bigwrite");
    2498:	c7 04 24 6f 4e 00 00 	movl   $0x4e6f,(%esp)
    249f:	e8 b1 17 00 00       	call   3c55 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    24a4:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    24ab:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    24b2:	0f 8e 41 ff ff ff    	jle    23f9 <bigwrite+0x32>
  }

  printf(1, "bigwrite ok\n");
    24b8:	c7 44 24 04 a2 4e 00 	movl   $0x4ea2,0x4(%esp)
    24bf:	00 
    24c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24c7:	e8 c1 18 00 00       	call   3d8d <printf>
}
    24cc:	c9                   	leave  
    24cd:	c3                   	ret    

000024ce <bigfile>:

void
bigfile(void)
{
    24ce:	55                   	push   %ebp
    24cf:	89 e5                	mov    %esp,%ebp
    24d1:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    24d4:	c7 44 24 04 af 4e 00 	movl   $0x4eaf,0x4(%esp)
    24db:	00 
    24dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24e3:	e8 a5 18 00 00       	call   3d8d <printf>

  unlink("bigfile");
    24e8:	c7 04 24 bd 4e 00 00 	movl   $0x4ebd,(%esp)
    24ef:	e8 61 17 00 00       	call   3c55 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    24f4:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    24fb:	00 
    24fc:	c7 04 24 bd 4e 00 00 	movl   $0x4ebd,(%esp)
    2503:	e8 3d 17 00 00       	call   3c45 <open>
    2508:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    250b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    250f:	79 19                	jns    252a <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    2511:	c7 44 24 04 c5 4e 00 	movl   $0x4ec5,0x4(%esp)
    2518:	00 
    2519:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2520:	e8 68 18 00 00       	call   3d8d <printf>
    exit();
    2525:	e8 db 16 00 00       	call   3c05 <exit>
  }
  for(i = 0; i < 20; i++){
    252a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2531:	eb 59                	jmp    258c <bigfile+0xbe>
    memset(buf, i, 600);
    2533:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    253a:	00 
    253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    253e:	89 44 24 04          	mov    %eax,0x4(%esp)
    2542:	c7 04 24 a0 86 00 00 	movl   $0x86a0,(%esp)
    2549:	e8 22 15 00 00       	call   3a70 <memset>
    if(write(fd, buf, 600) != 600){
    254e:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    2555:	00 
    2556:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    255d:	00 
    255e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2561:	89 04 24             	mov    %eax,(%esp)
    2564:	e8 bc 16 00 00       	call   3c25 <write>
    2569:	3d 58 02 00 00       	cmp    $0x258,%eax
    256e:	74 19                	je     2589 <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    2570:	c7 44 24 04 db 4e 00 	movl   $0x4edb,0x4(%esp)
    2577:	00 
    2578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    257f:	e8 09 18 00 00       	call   3d8d <printf>
      exit();
    2584:	e8 7c 16 00 00       	call   3c05 <exit>
  for(i = 0; i < 20; i++){
    2589:	ff 45 f4             	incl   -0xc(%ebp)
    258c:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    2590:	7e a1                	jle    2533 <bigfile+0x65>
    }
  }
  close(fd);
    2592:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2595:	89 04 24             	mov    %eax,(%esp)
    2598:	e8 90 16 00 00       	call   3c2d <close>

  fd = open("bigfile", 0);
    259d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    25a4:	00 
    25a5:	c7 04 24 bd 4e 00 00 	movl   $0x4ebd,(%esp)
    25ac:	e8 94 16 00 00       	call   3c45 <open>
    25b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    25b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    25b8:	79 19                	jns    25d3 <bigfile+0x105>
    printf(1, "cannot open bigfile\n");
    25ba:	c7 44 24 04 f1 4e 00 	movl   $0x4ef1,0x4(%esp)
    25c1:	00 
    25c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25c9:	e8 bf 17 00 00       	call   3d8d <printf>
    exit();
    25ce:	e8 32 16 00 00       	call   3c05 <exit>
  }
  total = 0;
    25d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    25da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    25e1:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    25e8:	00 
    25e9:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    25f0:	00 
    25f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    25f4:	89 04 24             	mov    %eax,(%esp)
    25f7:	e8 21 16 00 00       	call   3c1d <read>
    25fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    25ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2603:	79 19                	jns    261e <bigfile+0x150>
      printf(1, "read bigfile failed\n");
    2605:	c7 44 24 04 06 4f 00 	movl   $0x4f06,0x4(%esp)
    260c:	00 
    260d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2614:	e8 74 17 00 00       	call   3d8d <printf>
      exit();
    2619:	e8 e7 15 00 00       	call   3c05 <exit>
    }
    if(cc == 0)
    261e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2622:	74 79                	je     269d <bigfile+0x1cf>
      break;
    if(cc != 300){
    2624:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    262b:	74 19                	je     2646 <bigfile+0x178>
      printf(1, "short read bigfile\n");
    262d:	c7 44 24 04 1b 4f 00 	movl   $0x4f1b,0x4(%esp)
    2634:	00 
    2635:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    263c:	e8 4c 17 00 00       	call   3d8d <printf>
      exit();
    2641:	e8 bf 15 00 00       	call   3c05 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2646:	a0 a0 86 00 00       	mov    0x86a0,%al
    264b:	0f be d0             	movsbl %al,%edx
    264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2651:	89 c1                	mov    %eax,%ecx
    2653:	c1 e9 1f             	shr    $0x1f,%ecx
    2656:	01 c8                	add    %ecx,%eax
    2658:	d1 f8                	sar    %eax
    265a:	39 c2                	cmp    %eax,%edx
    265c:	75 18                	jne    2676 <bigfile+0x1a8>
    265e:	a0 cb 87 00 00       	mov    0x87cb,%al
    2663:	0f be d0             	movsbl %al,%edx
    2666:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2669:	89 c1                	mov    %eax,%ecx
    266b:	c1 e9 1f             	shr    $0x1f,%ecx
    266e:	01 c8                	add    %ecx,%eax
    2670:	d1 f8                	sar    %eax
    2672:	39 c2                	cmp    %eax,%edx
    2674:	74 19                	je     268f <bigfile+0x1c1>
      printf(1, "read bigfile wrong data\n");
    2676:	c7 44 24 04 2f 4f 00 	movl   $0x4f2f,0x4(%esp)
    267d:	00 
    267e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2685:	e8 03 17 00 00       	call   3d8d <printf>
      exit();
    268a:	e8 76 15 00 00       	call   3c05 <exit>
    }
    total += cc;
    268f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2692:	01 45 f0             	add    %eax,-0x10(%ebp)
  for(i = 0; ; i++){
    2695:	ff 45 f4             	incl   -0xc(%ebp)
  }
    2698:	e9 44 ff ff ff       	jmp    25e1 <bigfile+0x113>
      break;
    269d:	90                   	nop
  close(fd);
    269e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    26a1:	89 04 24             	mov    %eax,(%esp)
    26a4:	e8 84 15 00 00       	call   3c2d <close>
  if(total != 20*600){
    26a9:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    26b0:	74 19                	je     26cb <bigfile+0x1fd>
    printf(1, "read bigfile wrong total\n");
    26b2:	c7 44 24 04 48 4f 00 	movl   $0x4f48,0x4(%esp)
    26b9:	00 
    26ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26c1:	e8 c7 16 00 00       	call   3d8d <printf>
    exit();
    26c6:	e8 3a 15 00 00       	call   3c05 <exit>
  }
  unlink("bigfile");
    26cb:	c7 04 24 bd 4e 00 00 	movl   $0x4ebd,(%esp)
    26d2:	e8 7e 15 00 00       	call   3c55 <unlink>

  printf(1, "bigfile test ok\n");
    26d7:	c7 44 24 04 62 4f 00 	movl   $0x4f62,0x4(%esp)
    26de:	00 
    26df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26e6:	e8 a2 16 00 00       	call   3d8d <printf>
}
    26eb:	c9                   	leave  
    26ec:	c3                   	ret    

000026ed <fourteen>:

void
fourteen(void)
{
    26ed:	55                   	push   %ebp
    26ee:	89 e5                	mov    %esp,%ebp
    26f0:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    26f3:	c7 44 24 04 73 4f 00 	movl   $0x4f73,0x4(%esp)
    26fa:	00 
    26fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2702:	e8 86 16 00 00       	call   3d8d <printf>

  if(mkdir("12345678901234") != 0){
    2707:	c7 04 24 82 4f 00 00 	movl   $0x4f82,(%esp)
    270e:	e8 5a 15 00 00       	call   3c6d <mkdir>
    2713:	85 c0                	test   %eax,%eax
    2715:	74 19                	je     2730 <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    2717:	c7 44 24 04 91 4f 00 	movl   $0x4f91,0x4(%esp)
    271e:	00 
    271f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2726:	e8 62 16 00 00       	call   3d8d <printf>
    exit();
    272b:	e8 d5 14 00 00       	call   3c05 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    2730:	c7 04 24 b0 4f 00 00 	movl   $0x4fb0,(%esp)
    2737:	e8 31 15 00 00       	call   3c6d <mkdir>
    273c:	85 c0                	test   %eax,%eax
    273e:	74 19                	je     2759 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2740:	c7 44 24 04 d0 4f 00 	movl   $0x4fd0,0x4(%esp)
    2747:	00 
    2748:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    274f:	e8 39 16 00 00       	call   3d8d <printf>
    exit();
    2754:	e8 ac 14 00 00       	call   3c05 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2759:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2760:	00 
    2761:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
    2768:	e8 d8 14 00 00       	call   3c45 <open>
    276d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2770:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2774:	79 19                	jns    278f <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2776:	c7 44 24 04 30 50 00 	movl   $0x5030,0x4(%esp)
    277d:	00 
    277e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2785:	e8 03 16 00 00       	call   3d8d <printf>
    exit();
    278a:	e8 76 14 00 00       	call   3c05 <exit>
  }
  close(fd);
    278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2792:	89 04 24             	mov    %eax,(%esp)
    2795:	e8 93 14 00 00       	call   3c2d <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    279a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    27a1:	00 
    27a2:	c7 04 24 70 50 00 00 	movl   $0x5070,(%esp)
    27a9:	e8 97 14 00 00       	call   3c45 <open>
    27ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    27b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    27b5:	79 19                	jns    27d0 <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    27b7:	c7 44 24 04 a0 50 00 	movl   $0x50a0,0x4(%esp)
    27be:	00 
    27bf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27c6:	e8 c2 15 00 00       	call   3d8d <printf>
    exit();
    27cb:	e8 35 14 00 00       	call   3c05 <exit>
  }
  close(fd);
    27d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    27d3:	89 04 24             	mov    %eax,(%esp)
    27d6:	e8 52 14 00 00       	call   3c2d <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    27db:	c7 04 24 da 50 00 00 	movl   $0x50da,(%esp)
    27e2:	e8 86 14 00 00       	call   3c6d <mkdir>
    27e7:	85 c0                	test   %eax,%eax
    27e9:	75 19                	jne    2804 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    27eb:	c7 44 24 04 f8 50 00 	movl   $0x50f8,0x4(%esp)
    27f2:	00 
    27f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27fa:	e8 8e 15 00 00       	call   3d8d <printf>
    exit();
    27ff:	e8 01 14 00 00       	call   3c05 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2804:	c7 04 24 28 51 00 00 	movl   $0x5128,(%esp)
    280b:	e8 5d 14 00 00       	call   3c6d <mkdir>
    2810:	85 c0                	test   %eax,%eax
    2812:	75 19                	jne    282d <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2814:	c7 44 24 04 48 51 00 	movl   $0x5148,0x4(%esp)
    281b:	00 
    281c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2823:	e8 65 15 00 00       	call   3d8d <printf>
    exit();
    2828:	e8 d8 13 00 00       	call   3c05 <exit>
  }

  printf(1, "fourteen ok\n");
    282d:	c7 44 24 04 79 51 00 	movl   $0x5179,0x4(%esp)
    2834:	00 
    2835:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    283c:	e8 4c 15 00 00       	call   3d8d <printf>
}
    2841:	c9                   	leave  
    2842:	c3                   	ret    

00002843 <rmdot>:

void
rmdot(void)
{
    2843:	55                   	push   %ebp
    2844:	89 e5                	mov    %esp,%ebp
    2846:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2849:	c7 44 24 04 86 51 00 	movl   $0x5186,0x4(%esp)
    2850:	00 
    2851:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2858:	e8 30 15 00 00       	call   3d8d <printf>
  if(mkdir("dots") != 0){
    285d:	c7 04 24 92 51 00 00 	movl   $0x5192,(%esp)
    2864:	e8 04 14 00 00       	call   3c6d <mkdir>
    2869:	85 c0                	test   %eax,%eax
    286b:	74 19                	je     2886 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    286d:	c7 44 24 04 97 51 00 	movl   $0x5197,0x4(%esp)
    2874:	00 
    2875:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    287c:	e8 0c 15 00 00       	call   3d8d <printf>
    exit();
    2881:	e8 7f 13 00 00       	call   3c05 <exit>
  }
  if(chdir("dots") != 0){
    2886:	c7 04 24 92 51 00 00 	movl   $0x5192,(%esp)
    288d:	e8 e3 13 00 00       	call   3c75 <chdir>
    2892:	85 c0                	test   %eax,%eax
    2894:	74 19                	je     28af <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2896:	c7 44 24 04 aa 51 00 	movl   $0x51aa,0x4(%esp)
    289d:	00 
    289e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28a5:	e8 e3 14 00 00       	call   3d8d <printf>
    exit();
    28aa:	e8 56 13 00 00       	call   3c05 <exit>
  }
  if(unlink(".") == 0){
    28af:	c7 04 24 c3 48 00 00 	movl   $0x48c3,(%esp)
    28b6:	e8 9a 13 00 00       	call   3c55 <unlink>
    28bb:	85 c0                	test   %eax,%eax
    28bd:	75 19                	jne    28d8 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    28bf:	c7 44 24 04 bd 51 00 	movl   $0x51bd,0x4(%esp)
    28c6:	00 
    28c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28ce:	e8 ba 14 00 00       	call   3d8d <printf>
    exit();
    28d3:	e8 2d 13 00 00       	call   3c05 <exit>
  }
  if(unlink("..") == 0){
    28d8:	c7 04 24 50 44 00 00 	movl   $0x4450,(%esp)
    28df:	e8 71 13 00 00       	call   3c55 <unlink>
    28e4:	85 c0                	test   %eax,%eax
    28e6:	75 19                	jne    2901 <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    28e8:	c7 44 24 04 cb 51 00 	movl   $0x51cb,0x4(%esp)
    28ef:	00 
    28f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28f7:	e8 91 14 00 00       	call   3d8d <printf>
    exit();
    28fc:	e8 04 13 00 00       	call   3c05 <exit>
  }
  if(chdir("/") != 0){
    2901:	c7 04 24 da 51 00 00 	movl   $0x51da,(%esp)
    2908:	e8 68 13 00 00       	call   3c75 <chdir>
    290d:	85 c0                	test   %eax,%eax
    290f:	74 19                	je     292a <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2911:	c7 44 24 04 dc 51 00 	movl   $0x51dc,0x4(%esp)
    2918:	00 
    2919:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2920:	e8 68 14 00 00       	call   3d8d <printf>
    exit();
    2925:	e8 db 12 00 00       	call   3c05 <exit>
  }
  if(unlink("dots/.") == 0){
    292a:	c7 04 24 ec 51 00 00 	movl   $0x51ec,(%esp)
    2931:	e8 1f 13 00 00       	call   3c55 <unlink>
    2936:	85 c0                	test   %eax,%eax
    2938:	75 19                	jne    2953 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    293a:	c7 44 24 04 f3 51 00 	movl   $0x51f3,0x4(%esp)
    2941:	00 
    2942:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2949:	e8 3f 14 00 00       	call   3d8d <printf>
    exit();
    294e:	e8 b2 12 00 00       	call   3c05 <exit>
  }
  if(unlink("dots/..") == 0){
    2953:	c7 04 24 0a 52 00 00 	movl   $0x520a,(%esp)
    295a:	e8 f6 12 00 00       	call   3c55 <unlink>
    295f:	85 c0                	test   %eax,%eax
    2961:	75 19                	jne    297c <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2963:	c7 44 24 04 12 52 00 	movl   $0x5212,0x4(%esp)
    296a:	00 
    296b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2972:	e8 16 14 00 00       	call   3d8d <printf>
    exit();
    2977:	e8 89 12 00 00       	call   3c05 <exit>
  }
  if(unlink("dots") != 0){
    297c:	c7 04 24 92 51 00 00 	movl   $0x5192,(%esp)
    2983:	e8 cd 12 00 00       	call   3c55 <unlink>
    2988:	85 c0                	test   %eax,%eax
    298a:	74 19                	je     29a5 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    298c:	c7 44 24 04 2a 52 00 	movl   $0x522a,0x4(%esp)
    2993:	00 
    2994:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    299b:	e8 ed 13 00 00       	call   3d8d <printf>
    exit();
    29a0:	e8 60 12 00 00       	call   3c05 <exit>
  }
  printf(1, "rmdot ok\n");
    29a5:	c7 44 24 04 3f 52 00 	movl   $0x523f,0x4(%esp)
    29ac:	00 
    29ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b4:	e8 d4 13 00 00       	call   3d8d <printf>
}
    29b9:	c9                   	leave  
    29ba:	c3                   	ret    

000029bb <dirfile>:

void
dirfile(void)
{
    29bb:	55                   	push   %ebp
    29bc:	89 e5                	mov    %esp,%ebp
    29be:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    29c1:	c7 44 24 04 49 52 00 	movl   $0x5249,0x4(%esp)
    29c8:	00 
    29c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29d0:	e8 b8 13 00 00       	call   3d8d <printf>

  fd = open("dirfile", O_CREATE);
    29d5:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    29dc:	00 
    29dd:	c7 04 24 56 52 00 00 	movl   $0x5256,(%esp)
    29e4:	e8 5c 12 00 00       	call   3c45 <open>
    29e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    29ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    29f0:	79 19                	jns    2a0b <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    29f2:	c7 44 24 04 5e 52 00 	movl   $0x525e,0x4(%esp)
    29f9:	00 
    29fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a01:	e8 87 13 00 00       	call   3d8d <printf>
    exit();
    2a06:	e8 fa 11 00 00       	call   3c05 <exit>
  }
  close(fd);
    2a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a0e:	89 04 24             	mov    %eax,(%esp)
    2a11:	e8 17 12 00 00       	call   3c2d <close>
  if(chdir("dirfile") == 0){
    2a16:	c7 04 24 56 52 00 00 	movl   $0x5256,(%esp)
    2a1d:	e8 53 12 00 00       	call   3c75 <chdir>
    2a22:	85 c0                	test   %eax,%eax
    2a24:	75 19                	jne    2a3f <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2a26:	c7 44 24 04 75 52 00 	movl   $0x5275,0x4(%esp)
    2a2d:	00 
    2a2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a35:	e8 53 13 00 00       	call   3d8d <printf>
    exit();
    2a3a:	e8 c6 11 00 00       	call   3c05 <exit>
  }
  fd = open("dirfile/xx", 0);
    2a3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a46:	00 
    2a47:	c7 04 24 8f 52 00 00 	movl   $0x528f,(%esp)
    2a4e:	e8 f2 11 00 00       	call   3c45 <open>
    2a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a5a:	78 19                	js     2a75 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2a5c:	c7 44 24 04 9a 52 00 	movl   $0x529a,0x4(%esp)
    2a63:	00 
    2a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a6b:	e8 1d 13 00 00       	call   3d8d <printf>
    exit();
    2a70:	e8 90 11 00 00       	call   3c05 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2a75:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2a7c:	00 
    2a7d:	c7 04 24 8f 52 00 00 	movl   $0x528f,(%esp)
    2a84:	e8 bc 11 00 00       	call   3c45 <open>
    2a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2a8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a90:	78 19                	js     2aab <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2a92:	c7 44 24 04 9a 52 00 	movl   $0x529a,0x4(%esp)
    2a99:	00 
    2a9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aa1:	e8 e7 12 00 00       	call   3d8d <printf>
    exit();
    2aa6:	e8 5a 11 00 00       	call   3c05 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2aab:	c7 04 24 8f 52 00 00 	movl   $0x528f,(%esp)
    2ab2:	e8 b6 11 00 00       	call   3c6d <mkdir>
    2ab7:	85 c0                	test   %eax,%eax
    2ab9:	75 19                	jne    2ad4 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2abb:	c7 44 24 04 b8 52 00 	movl   $0x52b8,0x4(%esp)
    2ac2:	00 
    2ac3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aca:	e8 be 12 00 00       	call   3d8d <printf>
    exit();
    2acf:	e8 31 11 00 00       	call   3c05 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2ad4:	c7 04 24 8f 52 00 00 	movl   $0x528f,(%esp)
    2adb:	e8 75 11 00 00       	call   3c55 <unlink>
    2ae0:	85 c0                	test   %eax,%eax
    2ae2:	75 19                	jne    2afd <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2ae4:	c7 44 24 04 d5 52 00 	movl   $0x52d5,0x4(%esp)
    2aeb:	00 
    2aec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2af3:	e8 95 12 00 00       	call   3d8d <printf>
    exit();
    2af8:	e8 08 11 00 00       	call   3c05 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2afd:	c7 44 24 04 8f 52 00 	movl   $0x528f,0x4(%esp)
    2b04:	00 
    2b05:	c7 04 24 f3 52 00 00 	movl   $0x52f3,(%esp)
    2b0c:	e8 54 11 00 00       	call   3c65 <link>
    2b11:	85 c0                	test   %eax,%eax
    2b13:	75 19                	jne    2b2e <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b15:	c7 44 24 04 fc 52 00 	movl   $0x52fc,0x4(%esp)
    2b1c:	00 
    2b1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b24:	e8 64 12 00 00       	call   3d8d <printf>
    exit();
    2b29:	e8 d7 10 00 00       	call   3c05 <exit>
  }
  if(unlink("dirfile") != 0){
    2b2e:	c7 04 24 56 52 00 00 	movl   $0x5256,(%esp)
    2b35:	e8 1b 11 00 00       	call   3c55 <unlink>
    2b3a:	85 c0                	test   %eax,%eax
    2b3c:	74 19                	je     2b57 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2b3e:	c7 44 24 04 1b 53 00 	movl   $0x531b,0x4(%esp)
    2b45:	00 
    2b46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b4d:	e8 3b 12 00 00       	call   3d8d <printf>
    exit();
    2b52:	e8 ae 10 00 00       	call   3c05 <exit>
  }

  fd = open(".", O_RDWR);
    2b57:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2b5e:	00 
    2b5f:	c7 04 24 c3 48 00 00 	movl   $0x48c3,(%esp)
    2b66:	e8 da 10 00 00       	call   3c45 <open>
    2b6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2b72:	78 19                	js     2b8d <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2b74:	c7 44 24 04 34 53 00 	movl   $0x5334,0x4(%esp)
    2b7b:	00 
    2b7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b83:	e8 05 12 00 00       	call   3d8d <printf>
    exit();
    2b88:	e8 78 10 00 00       	call   3c05 <exit>
  }
  fd = open(".", 0);
    2b8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2b94:	00 
    2b95:	c7 04 24 c3 48 00 00 	movl   $0x48c3,(%esp)
    2b9c:	e8 a4 10 00 00       	call   3c45 <open>
    2ba1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2ba4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2bab:	00 
    2bac:	c7 44 24 04 fa 44 00 	movl   $0x44fa,0x4(%esp)
    2bb3:	00 
    2bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2bb7:	89 04 24             	mov    %eax,(%esp)
    2bba:	e8 66 10 00 00       	call   3c25 <write>
    2bbf:	85 c0                	test   %eax,%eax
    2bc1:	7e 19                	jle    2bdc <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2bc3:	c7 44 24 04 53 53 00 	movl   $0x5353,0x4(%esp)
    2bca:	00 
    2bcb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bd2:	e8 b6 11 00 00       	call   3d8d <printf>
    exit();
    2bd7:	e8 29 10 00 00       	call   3c05 <exit>
  }
  close(fd);
    2bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2bdf:	89 04 24             	mov    %eax,(%esp)
    2be2:	e8 46 10 00 00       	call   3c2d <close>

  printf(1, "dir vs file OK\n");
    2be7:	c7 44 24 04 67 53 00 	movl   $0x5367,0x4(%esp)
    2bee:	00 
    2bef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bf6:	e8 92 11 00 00       	call   3d8d <printf>
}
    2bfb:	c9                   	leave  
    2bfc:	c3                   	ret    

00002bfd <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2bfd:	55                   	push   %ebp
    2bfe:	89 e5                	mov    %esp,%ebp
    2c00:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2c03:	c7 44 24 04 77 53 00 	movl   $0x5377,0x4(%esp)
    2c0a:	00 
    2c0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c12:	e8 76 11 00 00       	call   3d8d <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2c1e:	e9 d1 00 00 00       	jmp    2cf4 <iref+0xf7>
    if(mkdir("irefd") != 0){
    2c23:	c7 04 24 88 53 00 00 	movl   $0x5388,(%esp)
    2c2a:	e8 3e 10 00 00       	call   3c6d <mkdir>
    2c2f:	85 c0                	test   %eax,%eax
    2c31:	74 19                	je     2c4c <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2c33:	c7 44 24 04 8e 53 00 	movl   $0x538e,0x4(%esp)
    2c3a:	00 
    2c3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c42:	e8 46 11 00 00       	call   3d8d <printf>
      exit();
    2c47:	e8 b9 0f 00 00       	call   3c05 <exit>
    }
    if(chdir("irefd") != 0){
    2c4c:	c7 04 24 88 53 00 00 	movl   $0x5388,(%esp)
    2c53:	e8 1d 10 00 00       	call   3c75 <chdir>
    2c58:	85 c0                	test   %eax,%eax
    2c5a:	74 19                	je     2c75 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2c5c:	c7 44 24 04 a2 53 00 	movl   $0x53a2,0x4(%esp)
    2c63:	00 
    2c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c6b:	e8 1d 11 00 00       	call   3d8d <printf>
      exit();
    2c70:	e8 90 0f 00 00       	call   3c05 <exit>
    }

    mkdir("");
    2c75:	c7 04 24 b6 53 00 00 	movl   $0x53b6,(%esp)
    2c7c:	e8 ec 0f 00 00       	call   3c6d <mkdir>
    link("README", "");
    2c81:	c7 44 24 04 b6 53 00 	movl   $0x53b6,0x4(%esp)
    2c88:	00 
    2c89:	c7 04 24 f3 52 00 00 	movl   $0x52f3,(%esp)
    2c90:	e8 d0 0f 00 00       	call   3c65 <link>
    fd = open("", O_CREATE);
    2c95:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2c9c:	00 
    2c9d:	c7 04 24 b6 53 00 00 	movl   $0x53b6,(%esp)
    2ca4:	e8 9c 0f 00 00       	call   3c45 <open>
    2ca9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2cac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2cb0:	78 0b                	js     2cbd <iref+0xc0>
      close(fd);
    2cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2cb5:	89 04 24             	mov    %eax,(%esp)
    2cb8:	e8 70 0f 00 00       	call   3c2d <close>
    fd = open("xx", O_CREATE);
    2cbd:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2cc4:	00 
    2cc5:	c7 04 24 b7 53 00 00 	movl   $0x53b7,(%esp)
    2ccc:	e8 74 0f 00 00       	call   3c45 <open>
    2cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2cd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2cd8:	78 0b                	js     2ce5 <iref+0xe8>
      close(fd);
    2cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2cdd:	89 04 24             	mov    %eax,(%esp)
    2ce0:	e8 48 0f 00 00       	call   3c2d <close>
    unlink("xx");
    2ce5:	c7 04 24 b7 53 00 00 	movl   $0x53b7,(%esp)
    2cec:	e8 64 0f 00 00       	call   3c55 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2cf1:	ff 45 f4             	incl   -0xc(%ebp)
    2cf4:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2cf8:	0f 8e 25 ff ff ff    	jle    2c23 <iref+0x26>
  }

  chdir("/");
    2cfe:	c7 04 24 da 51 00 00 	movl   $0x51da,(%esp)
    2d05:	e8 6b 0f 00 00       	call   3c75 <chdir>
  printf(1, "empty file name OK\n");
    2d0a:	c7 44 24 04 ba 53 00 	movl   $0x53ba,0x4(%esp)
    2d11:	00 
    2d12:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d19:	e8 6f 10 00 00       	call   3d8d <printf>
}
    2d1e:	c9                   	leave  
    2d1f:	c3                   	ret    

00002d20 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2d20:	55                   	push   %ebp
    2d21:	89 e5                	mov    %esp,%ebp
    2d23:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    2d26:	c7 44 24 04 ce 53 00 	movl   $0x53ce,0x4(%esp)
    2d2d:	00 
    2d2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d35:	e8 53 10 00 00       	call   3d8d <printf>

  for(n=0; n<1000; n++){
    2d3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2d41:	eb 1c                	jmp    2d5f <forktest+0x3f>
    pid = fork();
    2d43:	e8 b5 0e 00 00       	call   3bfd <fork>
    2d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2d4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d4f:	78 19                	js     2d6a <forktest+0x4a>
      break;
    if(pid == 0)
    2d51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2d55:	75 05                	jne    2d5c <forktest+0x3c>
      exit();
    2d57:	e8 a9 0e 00 00       	call   3c05 <exit>
  for(n=0; n<1000; n++){
    2d5c:	ff 45 f4             	incl   -0xc(%ebp)
    2d5f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2d66:	7e db                	jle    2d43 <forktest+0x23>
    2d68:	eb 01                	jmp    2d6b <forktest+0x4b>
      break;
    2d6a:	90                   	nop
  }
  
  if(n == 1000){
    2d6b:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    2d72:	75 3e                	jne    2db2 <forktest+0x92>
    printf(1, "fork claimed to work 1000 times!\n");
    2d74:	c7 44 24 04 dc 53 00 	movl   $0x53dc,0x4(%esp)
    2d7b:	00 
    2d7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d83:	e8 05 10 00 00       	call   3d8d <printf>
    exit();
    2d88:	e8 78 0e 00 00       	call   3c05 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    2d8d:	e8 7b 0e 00 00       	call   3c0d <wait>
    2d92:	85 c0                	test   %eax,%eax
    2d94:	79 19                	jns    2daf <forktest+0x8f>
      printf(1, "wait stopped early\n");
    2d96:	c7 44 24 04 fe 53 00 	movl   $0x53fe,0x4(%esp)
    2d9d:	00 
    2d9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2da5:	e8 e3 0f 00 00       	call   3d8d <printf>
      exit();
    2daa:	e8 56 0e 00 00       	call   3c05 <exit>
  for(; n > 0; n--){
    2daf:	ff 4d f4             	decl   -0xc(%ebp)
    2db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2db6:	7f d5                	jg     2d8d <forktest+0x6d>
    }
  }
  
  if(wait() != -1){
    2db8:	e8 50 0e 00 00       	call   3c0d <wait>
    2dbd:	83 f8 ff             	cmp    $0xffffffff,%eax
    2dc0:	74 19                	je     2ddb <forktest+0xbb>
    printf(1, "wait got too many\n");
    2dc2:	c7 44 24 04 12 54 00 	movl   $0x5412,0x4(%esp)
    2dc9:	00 
    2dca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dd1:	e8 b7 0f 00 00       	call   3d8d <printf>
    exit();
    2dd6:	e8 2a 0e 00 00       	call   3c05 <exit>
  }
  
  printf(1, "fork test OK\n");
    2ddb:	c7 44 24 04 25 54 00 	movl   $0x5425,0x4(%esp)
    2de2:	00 
    2de3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dea:	e8 9e 0f 00 00       	call   3d8d <printf>
}
    2def:	c9                   	leave  
    2df0:	c3                   	ret    

00002df1 <sbrktest>:

void
sbrktest(void)
{
    2df1:	55                   	push   %ebp
    2df2:	89 e5                	mov    %esp,%ebp
    2df4:	53                   	push   %ebx
    2df5:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2dfb:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2e00:	c7 44 24 04 33 54 00 	movl   $0x5433,0x4(%esp)
    2e07:	00 
    2e08:	89 04 24             	mov    %eax,(%esp)
    2e0b:	e8 7d 0f 00 00       	call   3d8d <printf>
  oldbrk = sbrk(0);
    2e10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e17:	e8 71 0e 00 00       	call   3c8d <sbrk>
    2e1c:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    2e1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e26:	e8 62 0e 00 00       	call   3c8d <sbrk>
    2e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    2e2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    2e35:	eb 56                	jmp    2e8d <sbrktest+0x9c>
    b = sbrk(1);
    2e37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e3e:	e8 4a 0e 00 00       	call   3c8d <sbrk>
    2e43:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    2e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2e4c:	74 2f                	je     2e7d <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2e4e:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2e53:	8b 55 e8             	mov    -0x18(%ebp),%edx
    2e56:	89 54 24 10          	mov    %edx,0x10(%esp)
    2e5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2e5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
    2e61:	8b 55 f0             	mov    -0x10(%ebp),%edx
    2e64:	89 54 24 08          	mov    %edx,0x8(%esp)
    2e68:	c7 44 24 04 3e 54 00 	movl   $0x543e,0x4(%esp)
    2e6f:	00 
    2e70:	89 04 24             	mov    %eax,(%esp)
    2e73:	e8 15 0f 00 00       	call   3d8d <printf>
      exit();
    2e78:	e8 88 0d 00 00       	call   3c05 <exit>
    }
    *b = 1;
    2e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e80:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2e83:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2e86:	40                   	inc    %eax
    2e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < 5000; i++){ 
    2e8a:	ff 45 f0             	incl   -0x10(%ebp)
    2e8d:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    2e94:	7e a1                	jle    2e37 <sbrktest+0x46>
  }
  pid = fork();
    2e96:	e8 62 0d 00 00       	call   3bfd <fork>
    2e9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    2e9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2ea2:	79 1a                	jns    2ebe <sbrktest+0xcd>
    printf(stdout, "sbrk test fork failed\n");
    2ea4:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2ea9:	c7 44 24 04 59 54 00 	movl   $0x5459,0x4(%esp)
    2eb0:	00 
    2eb1:	89 04 24             	mov    %eax,(%esp)
    2eb4:	e8 d4 0e 00 00       	call   3d8d <printf>
    exit();
    2eb9:	e8 47 0d 00 00       	call   3c05 <exit>
  }
  c = sbrk(1);
    2ebe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ec5:	e8 c3 0d 00 00       	call   3c8d <sbrk>
    2eca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    2ecd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ed4:	e8 b4 0d 00 00       	call   3c8d <sbrk>
    2ed9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    2edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2edf:	40                   	inc    %eax
    2ee0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2ee3:	74 1a                	je     2eff <sbrktest+0x10e>
    printf(stdout, "sbrk test failed post-fork\n");
    2ee5:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2eea:	c7 44 24 04 70 54 00 	movl   $0x5470,0x4(%esp)
    2ef1:	00 
    2ef2:	89 04 24             	mov    %eax,(%esp)
    2ef5:	e8 93 0e 00 00       	call   3d8d <printf>
    exit();
    2efa:	e8 06 0d 00 00       	call   3c05 <exit>
  }
  if(pid == 0)
    2eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    2f03:	75 05                	jne    2f0a <sbrktest+0x119>
    exit();
    2f05:	e8 fb 0c 00 00       	call   3c05 <exit>
  wait();
    2f0a:	e8 fe 0c 00 00       	call   3c0d <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2f0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f16:	e8 72 0d 00 00       	call   3c8d <sbrk>
    2f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    2f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2f21:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f26:	89 d1                	mov    %edx,%ecx
    2f28:	29 c1                	sub    %eax,%ecx
    2f2a:	89 c8                	mov    %ecx,%eax
    2f2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    2f2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
    2f32:	89 04 24             	mov    %eax,(%esp)
    2f35:	e8 53 0d 00 00       	call   3c8d <sbrk>
    2f3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    2f3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
    2f40:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    2f43:	74 1a                	je     2f5f <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2f45:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2f4a:	c7 44 24 04 8c 54 00 	movl   $0x548c,0x4(%esp)
    2f51:	00 
    2f52:	89 04 24             	mov    %eax,(%esp)
    2f55:	e8 33 0e 00 00       	call   3d8d <printf>
    exit();
    2f5a:	e8 a6 0c 00 00       	call   3c05 <exit>
  }
  lastaddr = (char*) (BIG-1);
    2f5f:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    2f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    2f69:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    2f6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2f73:	e8 15 0d 00 00       	call   3c8d <sbrk>
    2f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    2f7b:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2f82:	e8 06 0d 00 00       	call   3c8d <sbrk>
    2f87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    2f8a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    2f8e:	75 1a                	jne    2faa <sbrktest+0x1b9>
    printf(stdout, "sbrk could not deallocate\n");
    2f90:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2f95:	c7 44 24 04 ca 54 00 	movl   $0x54ca,0x4(%esp)
    2f9c:	00 
    2f9d:	89 04 24             	mov    %eax,(%esp)
    2fa0:	e8 e8 0d 00 00       	call   3d8d <printf>
    exit();
    2fa5:	e8 5b 0c 00 00       	call   3c05 <exit>
  }
  c = sbrk(0);
    2faa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2fb1:	e8 d7 0c 00 00       	call   3c8d <sbrk>
    2fb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    2fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2fbc:	2d 00 10 00 00       	sub    $0x1000,%eax
    2fc1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    2fc4:	74 28                	je     2fee <sbrktest+0x1fd>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2fc6:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    2fcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
    2fce:	89 54 24 0c          	mov    %edx,0xc(%esp)
    2fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
    2fd5:	89 54 24 08          	mov    %edx,0x8(%esp)
    2fd9:	c7 44 24 04 e8 54 00 	movl   $0x54e8,0x4(%esp)
    2fe0:	00 
    2fe1:	89 04 24             	mov    %eax,(%esp)
    2fe4:	e8 a4 0d 00 00       	call   3d8d <printf>
    exit();
    2fe9:	e8 17 0c 00 00       	call   3c05 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2fee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2ff5:	e8 93 0c 00 00       	call   3c8d <sbrk>
    2ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    2ffd:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3004:	e8 84 0c 00 00       	call   3c8d <sbrk>
    3009:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    300c:	8b 45 e0             	mov    -0x20(%ebp),%eax
    300f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    3012:	75 19                	jne    302d <sbrktest+0x23c>
    3014:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    301b:	e8 6d 0c 00 00       	call   3c8d <sbrk>
    3020:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3023:	81 c2 00 10 00 00    	add    $0x1000,%edx
    3029:	39 d0                	cmp    %edx,%eax
    302b:	74 28                	je     3055 <sbrktest+0x264>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    302d:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3032:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3035:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3039:	8b 55 f4             	mov    -0xc(%ebp),%edx
    303c:	89 54 24 08          	mov    %edx,0x8(%esp)
    3040:	c7 44 24 04 20 55 00 	movl   $0x5520,0x4(%esp)
    3047:	00 
    3048:	89 04 24             	mov    %eax,(%esp)
    304b:	e8 3d 0d 00 00       	call   3d8d <printf>
    exit();
    3050:	e8 b0 0b 00 00       	call   3c05 <exit>
  }
  if(*lastaddr == 99){
    3055:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3058:	8a 00                	mov    (%eax),%al
    305a:	3c 63                	cmp    $0x63,%al
    305c:	75 1a                	jne    3078 <sbrktest+0x287>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    305e:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3063:	c7 44 24 04 48 55 00 	movl   $0x5548,0x4(%esp)
    306a:	00 
    306b:	89 04 24             	mov    %eax,(%esp)
    306e:	e8 1a 0d 00 00       	call   3d8d <printf>
    exit();
    3073:	e8 8d 0b 00 00       	call   3c05 <exit>
  }

  a = sbrk(0);
    3078:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    307f:	e8 09 0c 00 00       	call   3c8d <sbrk>
    3084:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3087:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    308a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3091:	e8 f7 0b 00 00       	call   3c8d <sbrk>
    3096:	89 da                	mov    %ebx,%edx
    3098:	29 c2                	sub    %eax,%edx
    309a:	89 d0                	mov    %edx,%eax
    309c:	89 04 24             	mov    %eax,(%esp)
    309f:	e8 e9 0b 00 00       	call   3c8d <sbrk>
    30a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    30a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
    30aa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    30ad:	74 28                	je     30d7 <sbrktest+0x2e6>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    30af:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    30b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
    30b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
    30bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
    30be:	89 54 24 08          	mov    %edx,0x8(%esp)
    30c2:	c7 44 24 04 78 55 00 	movl   $0x5578,0x4(%esp)
    30c9:	00 
    30ca:	89 04 24             	mov    %eax,(%esp)
    30cd:	e8 bb 0c 00 00       	call   3d8d <printf>
    exit();
    30d2:	e8 2e 0b 00 00       	call   3c05 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    30d7:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    30de:	eb 7a                	jmp    315a <sbrktest+0x369>
    ppid = getpid();
    30e0:	e8 a0 0b 00 00       	call   3c85 <getpid>
    30e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    30e8:	e8 10 0b 00 00       	call   3bfd <fork>
    30ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    30f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    30f4:	79 1a                	jns    3110 <sbrktest+0x31f>
      printf(stdout, "fork failed\n");
    30f6:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    30fb:	c7 44 24 04 41 45 00 	movl   $0x4541,0x4(%esp)
    3102:	00 
    3103:	89 04 24             	mov    %eax,(%esp)
    3106:	e8 82 0c 00 00       	call   3d8d <printf>
      exit();
    310b:	e8 f5 0a 00 00       	call   3c05 <exit>
    }
    if(pid == 0){
    3110:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3114:	75 38                	jne    314e <sbrktest+0x35d>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3116:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3119:	8a 00                	mov    (%eax),%al
    311b:	0f be d0             	movsbl %al,%edx
    311e:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3123:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3127:	8b 55 f4             	mov    -0xc(%ebp),%edx
    312a:	89 54 24 08          	mov    %edx,0x8(%esp)
    312e:	c7 44 24 04 99 55 00 	movl   $0x5599,0x4(%esp)
    3135:	00 
    3136:	89 04 24             	mov    %eax,(%esp)
    3139:	e8 4f 0c 00 00       	call   3d8d <printf>
      kill(ppid);
    313e:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3141:	89 04 24             	mov    %eax,(%esp)
    3144:	e8 ec 0a 00 00       	call   3c35 <kill>
      exit();
    3149:	e8 b7 0a 00 00       	call   3c05 <exit>
    }
    wait();
    314e:	e8 ba 0a 00 00       	call   3c0d <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3153:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    315a:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    3161:	0f 86 79 ff ff ff    	jbe    30e0 <sbrktest+0x2ef>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    3167:	8d 45 c8             	lea    -0x38(%ebp),%eax
    316a:	89 04 24             	mov    %eax,(%esp)
    316d:	e8 a3 0a 00 00       	call   3c15 <pipe>
    3172:	85 c0                	test   %eax,%eax
    3174:	74 19                	je     318f <sbrktest+0x39e>
    printf(1, "pipe() failed\n");
    3176:	c7 44 24 04 95 44 00 	movl   $0x4495,0x4(%esp)
    317d:	00 
    317e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3185:	e8 03 0c 00 00       	call   3d8d <printf>
    exit();
    318a:	e8 76 0a 00 00       	call   3c05 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    318f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3196:	e9 88 00 00 00       	jmp    3223 <sbrktest+0x432>
    if((pids[i] = fork()) == 0){
    319b:	e8 5d 0a 00 00       	call   3bfd <fork>
    31a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
    31a3:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    31a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    31aa:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    31ae:	85 c0                	test   %eax,%eax
    31b0:	75 48                	jne    31fa <sbrktest+0x409>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    31b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31b9:	e8 cf 0a 00 00       	call   3c8d <sbrk>
    31be:	ba 00 00 40 06       	mov    $0x6400000,%edx
    31c3:	89 d1                	mov    %edx,%ecx
    31c5:	29 c1                	sub    %eax,%ecx
    31c7:	89 c8                	mov    %ecx,%eax
    31c9:	89 04 24             	mov    %eax,(%esp)
    31cc:	e8 bc 0a 00 00       	call   3c8d <sbrk>
      write(fds[1], "x", 1);
    31d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
    31d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    31db:	00 
    31dc:	c7 44 24 04 fa 44 00 	movl   $0x44fa,0x4(%esp)
    31e3:	00 
    31e4:	89 04 24             	mov    %eax,(%esp)
    31e7:	e8 39 0a 00 00       	call   3c25 <write>
      // sit around until killed
      for(;;) sleep(1000);
    31ec:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    31f3:	e8 9d 0a 00 00       	call   3c95 <sleep>
    31f8:	eb f2                	jmp    31ec <sbrktest+0x3fb>
    }
    if(pids[i] != -1)
    31fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    31fd:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    3201:	83 f8 ff             	cmp    $0xffffffff,%eax
    3204:	74 1a                	je     3220 <sbrktest+0x42f>
      read(fds[0], &scratch, 1);
    3206:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3209:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3210:	00 
    3211:	8d 55 9f             	lea    -0x61(%ebp),%edx
    3214:	89 54 24 04          	mov    %edx,0x4(%esp)
    3218:	89 04 24             	mov    %eax,(%esp)
    321b:	e8 fd 09 00 00       	call   3c1d <read>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3220:	ff 45 f0             	incl   -0x10(%ebp)
    3223:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3226:	83 f8 09             	cmp    $0x9,%eax
    3229:	0f 86 6c ff ff ff    	jbe    319b <sbrktest+0x3aa>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    322f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3236:	e8 52 0a 00 00       	call   3c8d <sbrk>
    323b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    323e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3245:	eb 26                	jmp    326d <sbrktest+0x47c>
    if(pids[i] == -1)
    3247:	8b 45 f0             	mov    -0x10(%ebp),%eax
    324a:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    324e:	83 f8 ff             	cmp    $0xffffffff,%eax
    3251:	74 16                	je     3269 <sbrktest+0x478>
      continue;
    kill(pids[i]);
    3253:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3256:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    325a:	89 04 24             	mov    %eax,(%esp)
    325d:	e8 d3 09 00 00       	call   3c35 <kill>
    wait();
    3262:	e8 a6 09 00 00       	call   3c0d <wait>
    3267:	eb 01                	jmp    326a <sbrktest+0x479>
      continue;
    3269:	90                   	nop
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    326a:	ff 45 f0             	incl   -0x10(%ebp)
    326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3270:	83 f8 09             	cmp    $0x9,%eax
    3273:	76 d2                	jbe    3247 <sbrktest+0x456>
  }
  if(c == (char*)0xffffffff){
    3275:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3279:	75 1a                	jne    3295 <sbrktest+0x4a4>
    printf(stdout, "failed sbrk leaked memory\n");
    327b:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3280:	c7 44 24 04 b2 55 00 	movl   $0x55b2,0x4(%esp)
    3287:	00 
    3288:	89 04 24             	mov    %eax,(%esp)
    328b:	e8 fd 0a 00 00       	call   3d8d <printf>
    exit();
    3290:	e8 70 09 00 00       	call   3c05 <exit>
  }

  if(sbrk(0) > oldbrk)
    3295:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    329c:	e8 ec 09 00 00       	call   3c8d <sbrk>
    32a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    32a4:	76 1d                	jbe    32c3 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    32a6:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    32a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32b0:	e8 d8 09 00 00       	call   3c8d <sbrk>
    32b5:	89 da                	mov    %ebx,%edx
    32b7:	29 c2                	sub    %eax,%edx
    32b9:	89 d0                	mov    %edx,%eax
    32bb:	89 04 24             	mov    %eax,(%esp)
    32be:	e8 ca 09 00 00       	call   3c8d <sbrk>

  printf(stdout, "sbrk test OK\n");
    32c3:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    32c8:	c7 44 24 04 cd 55 00 	movl   $0x55cd,0x4(%esp)
    32cf:	00 
    32d0:	89 04 24             	mov    %eax,(%esp)
    32d3:	e8 b5 0a 00 00       	call   3d8d <printf>
}
    32d8:	81 c4 84 00 00 00    	add    $0x84,%esp
    32de:	5b                   	pop    %ebx
    32df:	5d                   	pop    %ebp
    32e0:	c3                   	ret    

000032e1 <validateint>:

void
validateint(int *p)
{
    32e1:	55                   	push   %ebp
    32e2:	89 e5                	mov    %esp,%ebp
    32e4:	56                   	push   %esi
    32e5:	53                   	push   %ebx
    32e6:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    32e9:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    32f0:	8b 55 08             	mov    0x8(%ebp),%edx
    32f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    32f6:	89 d1                	mov    %edx,%ecx
    32f8:	89 e3                	mov    %esp,%ebx
    32fa:	89 cc                	mov    %ecx,%esp
    32fc:	cd 40                	int    $0x40
    32fe:	89 dc                	mov    %ebx,%esp
    3300:	89 c6                	mov    %eax,%esi
    3302:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3305:	83 c4 14             	add    $0x14,%esp
    3308:	5b                   	pop    %ebx
    3309:	5e                   	pop    %esi
    330a:	5d                   	pop    %ebp
    330b:	c3                   	ret    

0000330c <validatetest>:

void
validatetest(void)
{
    330c:	55                   	push   %ebp
    330d:	89 e5                	mov    %esp,%ebp
    330f:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    3312:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3317:	c7 44 24 04 db 55 00 	movl   $0x55db,0x4(%esp)
    331e:	00 
    331f:	89 04 24             	mov    %eax,(%esp)
    3322:	e8 66 0a 00 00       	call   3d8d <printf>
  hi = 1100*1024;
    3327:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    332e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3335:	eb 7f                	jmp    33b6 <validatetest+0xaa>
    if((pid = fork()) == 0){
    3337:	e8 c1 08 00 00       	call   3bfd <fork>
    333c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    333f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3343:	75 10                	jne    3355 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    3345:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3348:	89 04 24             	mov    %eax,(%esp)
    334b:	e8 91 ff ff ff       	call   32e1 <validateint>
      exit();
    3350:	e8 b0 08 00 00       	call   3c05 <exit>
    }
    sleep(0);
    3355:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    335c:	e8 34 09 00 00       	call   3c95 <sleep>
    sleep(0);
    3361:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3368:	e8 28 09 00 00       	call   3c95 <sleep>
    kill(pid);
    336d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3370:	89 04 24             	mov    %eax,(%esp)
    3373:	e8 bd 08 00 00       	call   3c35 <kill>
    wait();
    3378:	e8 90 08 00 00       	call   3c0d <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3380:	89 44 24 04          	mov    %eax,0x4(%esp)
    3384:	c7 04 24 ea 55 00 00 	movl   $0x55ea,(%esp)
    338b:	e8 d5 08 00 00       	call   3c65 <link>
    3390:	83 f8 ff             	cmp    $0xffffffff,%eax
    3393:	74 1a                	je     33af <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    3395:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    339a:	c7 44 24 04 f5 55 00 	movl   $0x55f5,0x4(%esp)
    33a1:	00 
    33a2:	89 04 24             	mov    %eax,(%esp)
    33a5:	e8 e3 09 00 00       	call   3d8d <printf>
      exit();
    33aa:	e8 56 08 00 00       	call   3c05 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    33af:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    33b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    33b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    33bc:	0f 83 75 ff ff ff    	jae    3337 <validatetest+0x2b>
    }
  }

  printf(stdout, "validate ok\n");
    33c2:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    33c7:	c7 44 24 04 0e 56 00 	movl   $0x560e,0x4(%esp)
    33ce:	00 
    33cf:	89 04 24             	mov    %eax,(%esp)
    33d2:	e8 b6 09 00 00       	call   3d8d <printf>
}
    33d7:	c9                   	leave  
    33d8:	c3                   	ret    

000033d9 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    33d9:	55                   	push   %ebp
    33da:	89 e5                	mov    %esp,%ebp
    33dc:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    33df:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    33e4:	c7 44 24 04 1b 56 00 	movl   $0x561b,0x4(%esp)
    33eb:	00 
    33ec:	89 04 24             	mov    %eax,(%esp)
    33ef:	e8 99 09 00 00       	call   3d8d <printf>
  for(i = 0; i < sizeof(uninit); i++){
    33f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    33fb:	eb 2b                	jmp    3428 <bsstest+0x4f>
    if(uninit[i] != '\0'){
    33fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3400:	05 80 5f 00 00       	add    $0x5f80,%eax
    3405:	8a 00                	mov    (%eax),%al
    3407:	84 c0                	test   %al,%al
    3409:	74 1a                	je     3425 <bsstest+0x4c>
      printf(stdout, "bss test failed\n");
    340b:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3410:	c7 44 24 04 25 56 00 	movl   $0x5625,0x4(%esp)
    3417:	00 
    3418:	89 04 24             	mov    %eax,(%esp)
    341b:	e8 6d 09 00 00       	call   3d8d <printf>
      exit();
    3420:	e8 e0 07 00 00       	call   3c05 <exit>
  for(i = 0; i < sizeof(uninit); i++){
    3425:	ff 45 f4             	incl   -0xc(%ebp)
    3428:	8b 45 f4             	mov    -0xc(%ebp),%eax
    342b:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    3430:	76 cb                	jbe    33fd <bsstest+0x24>
    }
  }
  printf(stdout, "bss test ok\n");
    3432:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3437:	c7 44 24 04 36 56 00 	movl   $0x5636,0x4(%esp)
    343e:	00 
    343f:	89 04 24             	mov    %eax,(%esp)
    3442:	e8 46 09 00 00       	call   3d8d <printf>
}
    3447:	c9                   	leave  
    3448:	c3                   	ret    

00003449 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    3449:	55                   	push   %ebp
    344a:	89 e5                	mov    %esp,%ebp
    344c:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    344f:	c7 04 24 43 56 00 00 	movl   $0x5643,(%esp)
    3456:	e8 fa 07 00 00       	call   3c55 <unlink>
  pid = fork();
    345b:	e8 9d 07 00 00       	call   3bfd <fork>
    3460:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    3463:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3467:	0f 85 8f 00 00 00    	jne    34fc <bigargtest+0xb3>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    346d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3474:	eb 11                	jmp    3487 <bigargtest+0x3e>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3476:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3479:	c7 04 85 e0 5e 00 00 	movl   $0x5650,0x5ee0(,%eax,4)
    3480:	50 56 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3484:	ff 45 f4             	incl   -0xc(%ebp)
    3487:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    348b:	7e e9                	jle    3476 <bigargtest+0x2d>
    args[MAXARG-1] = 0;
    348d:	c7 05 5c 5f 00 00 00 	movl   $0x0,0x5f5c
    3494:	00 00 00 
    printf(stdout, "bigarg test\n");
    3497:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    349c:	c7 44 24 04 2d 57 00 	movl   $0x572d,0x4(%esp)
    34a3:	00 
    34a4:	89 04 24             	mov    %eax,(%esp)
    34a7:	e8 e1 08 00 00       	call   3d8d <printf>
    exec("echo", args);
    34ac:	c7 44 24 04 e0 5e 00 	movl   $0x5ee0,0x4(%esp)
    34b3:	00 
    34b4:	c7 04 24 54 41 00 00 	movl   $0x4154,(%esp)
    34bb:	e8 7d 07 00 00       	call   3c3d <exec>
    printf(stdout, "bigarg test ok\n");
    34c0:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    34c5:	c7 44 24 04 3a 57 00 	movl   $0x573a,0x4(%esp)
    34cc:	00 
    34cd:	89 04 24             	mov    %eax,(%esp)
    34d0:	e8 b8 08 00 00       	call   3d8d <printf>
    fd = open("bigarg-ok", O_CREATE);
    34d5:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    34dc:	00 
    34dd:	c7 04 24 43 56 00 00 	movl   $0x5643,(%esp)
    34e4:	e8 5c 07 00 00       	call   3c45 <open>
    34e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    34ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
    34ef:	89 04 24             	mov    %eax,(%esp)
    34f2:	e8 36 07 00 00       	call   3c2d <close>
    exit();
    34f7:	e8 09 07 00 00       	call   3c05 <exit>
  } else if(pid < 0){
    34fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3500:	79 1a                	jns    351c <bigargtest+0xd3>
    printf(stdout, "bigargtest: fork failed\n");
    3502:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3507:	c7 44 24 04 4a 57 00 	movl   $0x574a,0x4(%esp)
    350e:	00 
    350f:	89 04 24             	mov    %eax,(%esp)
    3512:	e8 76 08 00 00       	call   3d8d <printf>
    exit();
    3517:	e8 e9 06 00 00       	call   3c05 <exit>
  }
  wait();
    351c:	e8 ec 06 00 00       	call   3c0d <wait>
  fd = open("bigarg-ok", 0);
    3521:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3528:	00 
    3529:	c7 04 24 43 56 00 00 	movl   $0x5643,(%esp)
    3530:	e8 10 07 00 00       	call   3c45 <open>
    3535:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    3538:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    353c:	79 1a                	jns    3558 <bigargtest+0x10f>
    printf(stdout, "bigarg test failed!\n");
    353e:	a1 a8 5e 00 00       	mov    0x5ea8,%eax
    3543:	c7 44 24 04 63 57 00 	movl   $0x5763,0x4(%esp)
    354a:	00 
    354b:	89 04 24             	mov    %eax,(%esp)
    354e:	e8 3a 08 00 00       	call   3d8d <printf>
    exit();
    3553:	e8 ad 06 00 00       	call   3c05 <exit>
  }
  close(fd);
    3558:	8b 45 ec             	mov    -0x14(%ebp),%eax
    355b:	89 04 24             	mov    %eax,(%esp)
    355e:	e8 ca 06 00 00       	call   3c2d <close>
  unlink("bigarg-ok");
    3563:	c7 04 24 43 56 00 00 	movl   $0x5643,(%esp)
    356a:	e8 e6 06 00 00       	call   3c55 <unlink>
}
    356f:	c9                   	leave  
    3570:	c3                   	ret    

00003571 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3571:	55                   	push   %ebp
    3572:	89 e5                	mov    %esp,%ebp
    3574:	53                   	push   %ebx
    3575:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    3578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    357f:	c7 44 24 04 78 57 00 	movl   $0x5778,0x4(%esp)
    3586:	00 
    3587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    358e:	e8 fa 07 00 00       	call   3d8d <printf>

  for(nfiles = 0; ; nfiles++){
    3593:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    359a:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    359e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    35a1:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    35a6:	f7 e9                	imul   %ecx
    35a8:	c1 fa 06             	sar    $0x6,%edx
    35ab:	89 c8                	mov    %ecx,%eax
    35ad:	c1 f8 1f             	sar    $0x1f,%eax
    35b0:	89 d1                	mov    %edx,%ecx
    35b2:	29 c1                	sub    %eax,%ecx
    35b4:	89 c8                	mov    %ecx,%eax
    35b6:	83 c0 30             	add    $0x30,%eax
    35b9:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    35bc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    35bf:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    35c4:	f7 eb                	imul   %ebx
    35c6:	c1 fa 06             	sar    $0x6,%edx
    35c9:	89 d8                	mov    %ebx,%eax
    35cb:	c1 f8 1f             	sar    $0x1f,%eax
    35ce:	89 d1                	mov    %edx,%ecx
    35d0:	29 c1                	sub    %eax,%ecx
    35d2:	89 c8                	mov    %ecx,%eax
    35d4:	c1 e0 02             	shl    $0x2,%eax
    35d7:	01 c8                	add    %ecx,%eax
    35d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    35e0:	01 d0                	add    %edx,%eax
    35e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    35e9:	01 d0                	add    %edx,%eax
    35eb:	c1 e0 03             	shl    $0x3,%eax
    35ee:	89 d9                	mov    %ebx,%ecx
    35f0:	29 c1                	sub    %eax,%ecx
    35f2:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    35f7:	f7 e9                	imul   %ecx
    35f9:	c1 fa 05             	sar    $0x5,%edx
    35fc:	89 c8                	mov    %ecx,%eax
    35fe:	c1 f8 1f             	sar    $0x1f,%eax
    3601:	89 d1                	mov    %edx,%ecx
    3603:	29 c1                	sub    %eax,%ecx
    3605:	89 c8                	mov    %ecx,%eax
    3607:	83 c0 30             	add    $0x30,%eax
    360a:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    360d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3610:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3615:	f7 eb                	imul   %ebx
    3617:	c1 fa 05             	sar    $0x5,%edx
    361a:	89 d8                	mov    %ebx,%eax
    361c:	c1 f8 1f             	sar    $0x1f,%eax
    361f:	89 d1                	mov    %edx,%ecx
    3621:	29 c1                	sub    %eax,%ecx
    3623:	89 c8                	mov    %ecx,%eax
    3625:	c1 e0 02             	shl    $0x2,%eax
    3628:	01 c8                	add    %ecx,%eax
    362a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3631:	01 d0                	add    %edx,%eax
    3633:	c1 e0 02             	shl    $0x2,%eax
    3636:	89 d9                	mov    %ebx,%ecx
    3638:	29 c1                	sub    %eax,%ecx
    363a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    363f:	89 c8                	mov    %ecx,%eax
    3641:	f7 ea                	imul   %edx
    3643:	c1 fa 02             	sar    $0x2,%edx
    3646:	89 c8                	mov    %ecx,%eax
    3648:	c1 f8 1f             	sar    $0x1f,%eax
    364b:	89 d1                	mov    %edx,%ecx
    364d:	29 c1                	sub    %eax,%ecx
    364f:	89 c8                	mov    %ecx,%eax
    3651:	83 c0 30             	add    $0x30,%eax
    3654:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3657:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    365a:	ba 67 66 66 66       	mov    $0x66666667,%edx
    365f:	89 c8                	mov    %ecx,%eax
    3661:	f7 ea                	imul   %edx
    3663:	c1 fa 02             	sar    $0x2,%edx
    3666:	89 c8                	mov    %ecx,%eax
    3668:	c1 f8 1f             	sar    $0x1f,%eax
    366b:	29 c2                	sub    %eax,%edx
    366d:	89 d0                	mov    %edx,%eax
    366f:	c1 e0 02             	shl    $0x2,%eax
    3672:	01 d0                	add    %edx,%eax
    3674:	d1 e0                	shl    %eax
    3676:	89 ca                	mov    %ecx,%edx
    3678:	29 c2                	sub    %eax,%edx
    367a:	88 d0                	mov    %dl,%al
    367c:	83 c0 30             	add    $0x30,%eax
    367f:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3682:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3686:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3689:	89 44 24 08          	mov    %eax,0x8(%esp)
    368d:	c7 44 24 04 85 57 00 	movl   $0x5785,0x4(%esp)
    3694:	00 
    3695:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    369c:	e8 ec 06 00 00       	call   3d8d <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    36a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    36a8:	00 
    36a9:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36ac:	89 04 24             	mov    %eax,(%esp)
    36af:	e8 91 05 00 00       	call   3c45 <open>
    36b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    36b7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    36bb:	79 20                	jns    36dd <fsfull+0x16c>
      printf(1, "open %s failed\n", name);
    36bd:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    36c0:	89 44 24 08          	mov    %eax,0x8(%esp)
    36c4:	c7 44 24 04 91 57 00 	movl   $0x5791,0x4(%esp)
    36cb:	00 
    36cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    36d3:	e8 b5 06 00 00       	call   3d8d <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    36d8:	e9 6c 01 00 00       	jmp    3849 <fsfull+0x2d8>
    int total = 0;
    36dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
      int cc = write(fd, buf, 512);
    36e4:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    36eb:	00 
    36ec:	c7 44 24 04 a0 86 00 	movl   $0x86a0,0x4(%esp)
    36f3:	00 
    36f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    36f7:	89 04 24             	mov    %eax,(%esp)
    36fa:	e8 26 05 00 00       	call   3c25 <write>
    36ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3702:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3709:	7e 0b                	jle    3716 <fsfull+0x1a5>
      total += cc;
    370b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    370e:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    3711:	ff 45 f0             	incl   -0x10(%ebp)
    }
    3714:	eb ce                	jmp    36e4 <fsfull+0x173>
        break;
    3716:	90                   	nop
    printf(1, "wrote %d bytes\n", total);
    3717:	8b 45 ec             	mov    -0x14(%ebp),%eax
    371a:	89 44 24 08          	mov    %eax,0x8(%esp)
    371e:	c7 44 24 04 a1 57 00 	movl   $0x57a1,0x4(%esp)
    3725:	00 
    3726:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    372d:	e8 5b 06 00 00       	call   3d8d <printf>
    close(fd);
    3732:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3735:	89 04 24             	mov    %eax,(%esp)
    3738:	e8 f0 04 00 00       	call   3c2d <close>
    if(total == 0)
    373d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3741:	0f 84 02 01 00 00    	je     3849 <fsfull+0x2d8>
  for(nfiles = 0; ; nfiles++){
    3747:	ff 45 f4             	incl   -0xc(%ebp)
  }
    374a:	e9 4b fe ff ff       	jmp    359a <fsfull+0x29>
    char name[64];
    name[0] = 'f';
    374f:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    3753:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3756:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    375b:	f7 e9                	imul   %ecx
    375d:	c1 fa 06             	sar    $0x6,%edx
    3760:	89 c8                	mov    %ecx,%eax
    3762:	c1 f8 1f             	sar    $0x1f,%eax
    3765:	89 d1                	mov    %edx,%ecx
    3767:	29 c1                	sub    %eax,%ecx
    3769:	89 c8                	mov    %ecx,%eax
    376b:	83 c0 30             	add    $0x30,%eax
    376e:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3771:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3774:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3779:	f7 eb                	imul   %ebx
    377b:	c1 fa 06             	sar    $0x6,%edx
    377e:	89 d8                	mov    %ebx,%eax
    3780:	c1 f8 1f             	sar    $0x1f,%eax
    3783:	89 d1                	mov    %edx,%ecx
    3785:	29 c1                	sub    %eax,%ecx
    3787:	89 c8                	mov    %ecx,%eax
    3789:	c1 e0 02             	shl    $0x2,%eax
    378c:	01 c8                	add    %ecx,%eax
    378e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3795:	01 d0                	add    %edx,%eax
    3797:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    379e:	01 d0                	add    %edx,%eax
    37a0:	c1 e0 03             	shl    $0x3,%eax
    37a3:	89 d9                	mov    %ebx,%ecx
    37a5:	29 c1                	sub    %eax,%ecx
    37a7:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    37ac:	f7 e9                	imul   %ecx
    37ae:	c1 fa 05             	sar    $0x5,%edx
    37b1:	89 c8                	mov    %ecx,%eax
    37b3:	c1 f8 1f             	sar    $0x1f,%eax
    37b6:	89 d1                	mov    %edx,%ecx
    37b8:	29 c1                	sub    %eax,%ecx
    37ba:	89 c8                	mov    %ecx,%eax
    37bc:	83 c0 30             	add    $0x30,%eax
    37bf:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    37c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    37c5:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    37ca:	f7 eb                	imul   %ebx
    37cc:	c1 fa 05             	sar    $0x5,%edx
    37cf:	89 d8                	mov    %ebx,%eax
    37d1:	c1 f8 1f             	sar    $0x1f,%eax
    37d4:	89 d1                	mov    %edx,%ecx
    37d6:	29 c1                	sub    %eax,%ecx
    37d8:	89 c8                	mov    %ecx,%eax
    37da:	c1 e0 02             	shl    $0x2,%eax
    37dd:	01 c8                	add    %ecx,%eax
    37df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    37e6:	01 d0                	add    %edx,%eax
    37e8:	c1 e0 02             	shl    $0x2,%eax
    37eb:	89 d9                	mov    %ebx,%ecx
    37ed:	29 c1                	sub    %eax,%ecx
    37ef:	ba 67 66 66 66       	mov    $0x66666667,%edx
    37f4:	89 c8                	mov    %ecx,%eax
    37f6:	f7 ea                	imul   %edx
    37f8:	c1 fa 02             	sar    $0x2,%edx
    37fb:	89 c8                	mov    %ecx,%eax
    37fd:	c1 f8 1f             	sar    $0x1f,%eax
    3800:	89 d1                	mov    %edx,%ecx
    3802:	29 c1                	sub    %eax,%ecx
    3804:	89 c8                	mov    %ecx,%eax
    3806:	83 c0 30             	add    $0x30,%eax
    3809:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    380c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    380f:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3814:	89 c8                	mov    %ecx,%eax
    3816:	f7 ea                	imul   %edx
    3818:	c1 fa 02             	sar    $0x2,%edx
    381b:	89 c8                	mov    %ecx,%eax
    381d:	c1 f8 1f             	sar    $0x1f,%eax
    3820:	29 c2                	sub    %eax,%edx
    3822:	89 d0                	mov    %edx,%eax
    3824:	c1 e0 02             	shl    $0x2,%eax
    3827:	01 d0                	add    %edx,%eax
    3829:	d1 e0                	shl    %eax
    382b:	89 ca                	mov    %ecx,%edx
    382d:	29 c2                	sub    %eax,%edx
    382f:	88 d0                	mov    %dl,%al
    3831:	83 c0 30             	add    $0x30,%eax
    3834:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3837:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    383b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    383e:	89 04 24             	mov    %eax,(%esp)
    3841:	e8 0f 04 00 00       	call   3c55 <unlink>
    nfiles--;
    3846:	ff 4d f4             	decl   -0xc(%ebp)
  while(nfiles >= 0){
    3849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    384d:	0f 89 fc fe ff ff    	jns    374f <fsfull+0x1de>
  }

  printf(1, "fsfull test finished\n");
    3853:	c7 44 24 04 b1 57 00 	movl   $0x57b1,0x4(%esp)
    385a:	00 
    385b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3862:	e8 26 05 00 00       	call   3d8d <printf>
}
    3867:	83 c4 74             	add    $0x74,%esp
    386a:	5b                   	pop    %ebx
    386b:	5d                   	pop    %ebp
    386c:	c3                   	ret    

0000386d <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    386d:	55                   	push   %ebp
    386e:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3870:	8b 15 ac 5e 00 00    	mov    0x5eac,%edx
    3876:	89 d0                	mov    %edx,%eax
    3878:	d1 e0                	shl    %eax
    387a:	01 d0                	add    %edx,%eax
    387c:	c1 e0 02             	shl    $0x2,%eax
    387f:	01 d0                	add    %edx,%eax
    3881:	c1 e0 08             	shl    $0x8,%eax
    3884:	01 d0                	add    %edx,%eax
    3886:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    388d:	01 c8                	add    %ecx,%eax
    388f:	c1 e0 02             	shl    $0x2,%eax
    3892:	01 d0                	add    %edx,%eax
    3894:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    389b:	01 d0                	add    %edx,%eax
    389d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    38a4:	01 d0                	add    %edx,%eax
    38a6:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    38ab:	a3 ac 5e 00 00       	mov    %eax,0x5eac
  return randstate;
    38b0:	a1 ac 5e 00 00       	mov    0x5eac,%eax
}
    38b5:	5d                   	pop    %ebp
    38b6:	c3                   	ret    

000038b7 <main>:

int
main(int argc, char *argv[])
{
    38b7:	55                   	push   %ebp
    38b8:	89 e5                	mov    %esp,%ebp
    38ba:	83 e4 f0             	and    $0xfffffff0,%esp
    38bd:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    38c0:	c7 44 24 04 c7 57 00 	movl   $0x57c7,0x4(%esp)
    38c7:	00 
    38c8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38cf:	e8 b9 04 00 00       	call   3d8d <printf>

  if(open("usertests.ran", 0) >= 0){
    38d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    38db:	00 
    38dc:	c7 04 24 db 57 00 00 	movl   $0x57db,(%esp)
    38e3:	e8 5d 03 00 00       	call   3c45 <open>
    38e8:	85 c0                	test   %eax,%eax
    38ea:	78 19                	js     3905 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    38ec:	c7 44 24 04 ec 57 00 	movl   $0x57ec,0x4(%esp)
    38f3:	00 
    38f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    38fb:	e8 8d 04 00 00       	call   3d8d <printf>
    exit();
    3900:	e8 00 03 00 00       	call   3c05 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3905:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    390c:	00 
    390d:	c7 04 24 db 57 00 00 	movl   $0x57db,(%esp)
    3914:	e8 2c 03 00 00       	call   3c45 <open>
    3919:	89 04 24             	mov    %eax,(%esp)
    391c:	e8 0c 03 00 00       	call   3c2d <close>

  bigargtest();
    3921:	e8 23 fb ff ff       	call   3449 <bigargtest>
  bigwrite();
    3926:	e8 9c ea ff ff       	call   23c7 <bigwrite>
  bigargtest();
    392b:	e8 19 fb ff ff       	call   3449 <bigargtest>
  bsstest();
    3930:	e8 a4 fa ff ff       	call   33d9 <bsstest>
  sbrktest();
    3935:	e8 b7 f4 ff ff       	call   2df1 <sbrktest>
  validatetest();
    393a:	e8 cd f9 ff ff       	call   330c <validatetest>

  opentest();
    393f:	e8 bc c6 ff ff       	call   0 <opentest>
  writetest();
    3944:	e8 62 c7 ff ff       	call   ab <writetest>
  writetest1();
    3949:	e8 71 c9 ff ff       	call   2bf <writetest1>
  createtest();
    394e:	e8 73 cb ff ff       	call   4c6 <createtest>

  mem();
    3953:	e8 0b d1 ff ff       	call   a63 <mem>
  pipe1();
    3958:	e8 48 cd ff ff       	call   6a5 <pipe1>
  preempt();
    395d:	e8 2b cf ff ff       	call   88d <preempt>
  exitwait();
    3962:	e8 7f d0 ff ff       	call   9e6 <exitwait>

  rmdot();
    3967:	e8 d7 ee ff ff       	call   2843 <rmdot>
  fourteen();
    396c:	e8 7c ed ff ff       	call   26ed <fourteen>
  bigfile();
    3971:	e8 58 eb ff ff       	call   24ce <bigfile>
  subdir();
    3976:	e8 08 e3 ff ff       	call   1c83 <subdir>
  concreate();
    397b:	e8 e8 dc ff ff       	call   1668 <concreate>
  linkunlink();
    3980:	e8 4a e0 ff ff       	call   19cf <linkunlink>
  linktest();
    3985:	e8 95 da ff ff       	call   141f <linktest>
  unlinkread();
    398a:	e8 bd d8 ff ff       	call   124c <unlinkread>
  createdelete();
    398f:	e8 10 d6 ff ff       	call   fa4 <createdelete>
  twofiles();
    3994:	e8 a7 d3 ff ff       	call   d40 <twofiles>
  sharedfd();
    3999:	e8 aa d1 ff ff       	call   b48 <sharedfd>
  dirfile();
    399e:	e8 18 f0 ff ff       	call   29bb <dirfile>
  iref();
    39a3:	e8 55 f2 ff ff       	call   2bfd <iref>
  forktest();
    39a8:	e8 73 f3 ff ff       	call   2d20 <forktest>
  bigdir(); // slow
    39ad:	e8 62 e1 ff ff       	call   1b14 <bigdir>

  exectest();
    39b2:	e8 9f cc ff ff       	call   656 <exectest>

  exit();
    39b7:	e8 49 02 00 00       	call   3c05 <exit>

000039bc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    39bc:	55                   	push   %ebp
    39bd:	89 e5                	mov    %esp,%ebp
    39bf:	57                   	push   %edi
    39c0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    39c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
    39c4:	8b 55 10             	mov    0x10(%ebp),%edx
    39c7:	8b 45 0c             	mov    0xc(%ebp),%eax
    39ca:	89 cb                	mov    %ecx,%ebx
    39cc:	89 df                	mov    %ebx,%edi
    39ce:	89 d1                	mov    %edx,%ecx
    39d0:	fc                   	cld    
    39d1:	f3 aa                	rep stos %al,%es:(%edi)
    39d3:	89 ca                	mov    %ecx,%edx
    39d5:	89 fb                	mov    %edi,%ebx
    39d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
    39da:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    39dd:	5b                   	pop    %ebx
    39de:	5f                   	pop    %edi
    39df:	5d                   	pop    %ebp
    39e0:	c3                   	ret    

000039e1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    39e1:	55                   	push   %ebp
    39e2:	89 e5                	mov    %esp,%ebp
    39e4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    39e7:	8b 45 08             	mov    0x8(%ebp),%eax
    39ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    39ed:	90                   	nop
    39ee:	8b 45 0c             	mov    0xc(%ebp),%eax
    39f1:	8a 10                	mov    (%eax),%dl
    39f3:	8b 45 08             	mov    0x8(%ebp),%eax
    39f6:	88 10                	mov    %dl,(%eax)
    39f8:	8b 45 08             	mov    0x8(%ebp),%eax
    39fb:	8a 00                	mov    (%eax),%al
    39fd:	84 c0                	test   %al,%al
    39ff:	0f 95 c0             	setne  %al
    3a02:	ff 45 08             	incl   0x8(%ebp)
    3a05:	ff 45 0c             	incl   0xc(%ebp)
    3a08:	84 c0                	test   %al,%al
    3a0a:	75 e2                	jne    39ee <strcpy+0xd>
    ;
  return os;
    3a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a0f:	c9                   	leave  
    3a10:	c3                   	ret    

00003a11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3a11:	55                   	push   %ebp
    3a12:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3a14:	eb 06                	jmp    3a1c <strcmp+0xb>
    p++, q++;
    3a16:	ff 45 08             	incl   0x8(%ebp)
    3a19:	ff 45 0c             	incl   0xc(%ebp)
  while(*p && *p == *q)
    3a1c:	8b 45 08             	mov    0x8(%ebp),%eax
    3a1f:	8a 00                	mov    (%eax),%al
    3a21:	84 c0                	test   %al,%al
    3a23:	74 0e                	je     3a33 <strcmp+0x22>
    3a25:	8b 45 08             	mov    0x8(%ebp),%eax
    3a28:	8a 10                	mov    (%eax),%dl
    3a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a2d:	8a 00                	mov    (%eax),%al
    3a2f:	38 c2                	cmp    %al,%dl
    3a31:	74 e3                	je     3a16 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
    3a33:	8b 45 08             	mov    0x8(%ebp),%eax
    3a36:	8a 00                	mov    (%eax),%al
    3a38:	0f b6 d0             	movzbl %al,%edx
    3a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a3e:	8a 00                	mov    (%eax),%al
    3a40:	0f b6 c0             	movzbl %al,%eax
    3a43:	89 d1                	mov    %edx,%ecx
    3a45:	29 c1                	sub    %eax,%ecx
    3a47:	89 c8                	mov    %ecx,%eax
}
    3a49:	5d                   	pop    %ebp
    3a4a:	c3                   	ret    

00003a4b <strlen>:

uint
strlen(char *s)
{
    3a4b:	55                   	push   %ebp
    3a4c:	89 e5                	mov    %esp,%ebp
    3a4e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3a51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3a58:	eb 03                	jmp    3a5d <strlen+0x12>
    3a5a:	ff 45 fc             	incl   -0x4(%ebp)
    3a5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3a60:	8b 45 08             	mov    0x8(%ebp),%eax
    3a63:	01 d0                	add    %edx,%eax
    3a65:	8a 00                	mov    (%eax),%al
    3a67:	84 c0                	test   %al,%al
    3a69:	75 ef                	jne    3a5a <strlen+0xf>
    ;
  return n;
    3a6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3a6e:	c9                   	leave  
    3a6f:	c3                   	ret    

00003a70 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3a70:	55                   	push   %ebp
    3a71:	89 e5                	mov    %esp,%ebp
    3a73:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3a76:	8b 45 10             	mov    0x10(%ebp),%eax
    3a79:	89 44 24 08          	mov    %eax,0x8(%esp)
    3a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a80:	89 44 24 04          	mov    %eax,0x4(%esp)
    3a84:	8b 45 08             	mov    0x8(%ebp),%eax
    3a87:	89 04 24             	mov    %eax,(%esp)
    3a8a:	e8 2d ff ff ff       	call   39bc <stosb>
  return dst;
    3a8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3a92:	c9                   	leave  
    3a93:	c3                   	ret    

00003a94 <strchr>:

char*
strchr(const char *s, char c)
{
    3a94:	55                   	push   %ebp
    3a95:	89 e5                	mov    %esp,%ebp
    3a97:	83 ec 04             	sub    $0x4,%esp
    3a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3a9d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3aa0:	eb 12                	jmp    3ab4 <strchr+0x20>
    if(*s == c)
    3aa2:	8b 45 08             	mov    0x8(%ebp),%eax
    3aa5:	8a 00                	mov    (%eax),%al
    3aa7:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3aaa:	75 05                	jne    3ab1 <strchr+0x1d>
      return (char*)s;
    3aac:	8b 45 08             	mov    0x8(%ebp),%eax
    3aaf:	eb 11                	jmp    3ac2 <strchr+0x2e>
  for(; *s; s++)
    3ab1:	ff 45 08             	incl   0x8(%ebp)
    3ab4:	8b 45 08             	mov    0x8(%ebp),%eax
    3ab7:	8a 00                	mov    (%eax),%al
    3ab9:	84 c0                	test   %al,%al
    3abb:	75 e5                	jne    3aa2 <strchr+0xe>
  return 0;
    3abd:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ac2:	c9                   	leave  
    3ac3:	c3                   	ret    

00003ac4 <gets>:

char*
gets(char *buf, int max)
{
    3ac4:	55                   	push   %ebp
    3ac5:	89 e5                	mov    %esp,%ebp
    3ac7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3aca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3ad1:	eb 42                	jmp    3b15 <gets+0x51>
    cc = read(0, &c, 1);
    3ad3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3ada:	00 
    3adb:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3ade:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ae2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3ae9:	e8 2f 01 00 00       	call   3c1d <read>
    3aee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3af1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3af5:	7e 29                	jle    3b20 <gets+0x5c>
      break;
    buf[i++] = c;
    3af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3afa:	8b 45 08             	mov    0x8(%ebp),%eax
    3afd:	01 c2                	add    %eax,%edx
    3aff:	8a 45 ef             	mov    -0x11(%ebp),%al
    3b02:	88 02                	mov    %al,(%edx)
    3b04:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    3b07:	8a 45 ef             	mov    -0x11(%ebp),%al
    3b0a:	3c 0a                	cmp    $0xa,%al
    3b0c:	74 13                	je     3b21 <gets+0x5d>
    3b0e:	8a 45 ef             	mov    -0x11(%ebp),%al
    3b11:	3c 0d                	cmp    $0xd,%al
    3b13:	74 0c                	je     3b21 <gets+0x5d>
  for(i=0; i+1 < max; ){
    3b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b18:	40                   	inc    %eax
    3b19:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3b1c:	7c b5                	jl     3ad3 <gets+0xf>
    3b1e:	eb 01                	jmp    3b21 <gets+0x5d>
      break;
    3b20:	90                   	nop
      break;
  }
  buf[i] = '\0';
    3b21:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3b24:	8b 45 08             	mov    0x8(%ebp),%eax
    3b27:	01 d0                	add    %edx,%eax
    3b29:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3b2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3b2f:	c9                   	leave  
    3b30:	c3                   	ret    

00003b31 <stat>:

int
stat(char *n, struct stat *st)
{
    3b31:	55                   	push   %ebp
    3b32:	89 e5                	mov    %esp,%ebp
    3b34:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3b37:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b3e:	00 
    3b3f:	8b 45 08             	mov    0x8(%ebp),%eax
    3b42:	89 04 24             	mov    %eax,(%esp)
    3b45:	e8 fb 00 00 00       	call   3c45 <open>
    3b4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3b4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3b51:	79 07                	jns    3b5a <stat+0x29>
    return -1;
    3b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3b58:	eb 23                	jmp    3b7d <stat+0x4c>
  r = fstat(fd, st);
    3b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
    3b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b64:	89 04 24             	mov    %eax,(%esp)
    3b67:	e8 f1 00 00 00       	call   3c5d <fstat>
    3b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3b72:	89 04 24             	mov    %eax,(%esp)
    3b75:	e8 b3 00 00 00       	call   3c2d <close>
  return r;
    3b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3b7d:	c9                   	leave  
    3b7e:	c3                   	ret    

00003b7f <atoi>:

int
atoi(const char *s)
{
    3b7f:	55                   	push   %ebp
    3b80:	89 e5                	mov    %esp,%ebp
    3b82:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3b85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3b8c:	eb 21                	jmp    3baf <atoi+0x30>
    n = n*10 + *s++ - '0';
    3b8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3b91:	89 d0                	mov    %edx,%eax
    3b93:	c1 e0 02             	shl    $0x2,%eax
    3b96:	01 d0                	add    %edx,%eax
    3b98:	d1 e0                	shl    %eax
    3b9a:	89 c2                	mov    %eax,%edx
    3b9c:	8b 45 08             	mov    0x8(%ebp),%eax
    3b9f:	8a 00                	mov    (%eax),%al
    3ba1:	0f be c0             	movsbl %al,%eax
    3ba4:	01 d0                	add    %edx,%eax
    3ba6:	83 e8 30             	sub    $0x30,%eax
    3ba9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3bac:	ff 45 08             	incl   0x8(%ebp)
  while('0' <= *s && *s <= '9')
    3baf:	8b 45 08             	mov    0x8(%ebp),%eax
    3bb2:	8a 00                	mov    (%eax),%al
    3bb4:	3c 2f                	cmp    $0x2f,%al
    3bb6:	7e 09                	jle    3bc1 <atoi+0x42>
    3bb8:	8b 45 08             	mov    0x8(%ebp),%eax
    3bbb:	8a 00                	mov    (%eax),%al
    3bbd:	3c 39                	cmp    $0x39,%al
    3bbf:	7e cd                	jle    3b8e <atoi+0xf>
  return n;
    3bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3bc4:	c9                   	leave  
    3bc5:	c3                   	ret    

00003bc6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3bc6:	55                   	push   %ebp
    3bc7:	89 e5                	mov    %esp,%ebp
    3bc9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3bcc:	8b 45 08             	mov    0x8(%ebp),%eax
    3bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3bd2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3bd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3bd8:	eb 10                	jmp    3bea <memmove+0x24>
    *dst++ = *src++;
    3bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3bdd:	8a 10                	mov    (%eax),%dl
    3bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3be2:	88 10                	mov    %dl,(%eax)
    3be4:	ff 45 fc             	incl   -0x4(%ebp)
    3be7:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0)
    3bea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3bee:	0f 9f c0             	setg   %al
    3bf1:	ff 4d 10             	decl   0x10(%ebp)
    3bf4:	84 c0                	test   %al,%al
    3bf6:	75 e2                	jne    3bda <memmove+0x14>
  return vdst;
    3bf8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3bfb:	c9                   	leave  
    3bfc:	c3                   	ret    

00003bfd <fork>:
    3bfd:	b8 01 00 00 00       	mov    $0x1,%eax
    3c02:	cd 40                	int    $0x40
    3c04:	c3                   	ret    

00003c05 <exit>:
    3c05:	b8 02 00 00 00       	mov    $0x2,%eax
    3c0a:	cd 40                	int    $0x40
    3c0c:	c3                   	ret    

00003c0d <wait>:
    3c0d:	b8 03 00 00 00       	mov    $0x3,%eax
    3c12:	cd 40                	int    $0x40
    3c14:	c3                   	ret    

00003c15 <pipe>:
    3c15:	b8 04 00 00 00       	mov    $0x4,%eax
    3c1a:	cd 40                	int    $0x40
    3c1c:	c3                   	ret    

00003c1d <read>:
    3c1d:	b8 05 00 00 00       	mov    $0x5,%eax
    3c22:	cd 40                	int    $0x40
    3c24:	c3                   	ret    

00003c25 <write>:
    3c25:	b8 10 00 00 00       	mov    $0x10,%eax
    3c2a:	cd 40                	int    $0x40
    3c2c:	c3                   	ret    

00003c2d <close>:
    3c2d:	b8 15 00 00 00       	mov    $0x15,%eax
    3c32:	cd 40                	int    $0x40
    3c34:	c3                   	ret    

00003c35 <kill>:
    3c35:	b8 06 00 00 00       	mov    $0x6,%eax
    3c3a:	cd 40                	int    $0x40
    3c3c:	c3                   	ret    

00003c3d <exec>:
    3c3d:	b8 07 00 00 00       	mov    $0x7,%eax
    3c42:	cd 40                	int    $0x40
    3c44:	c3                   	ret    

00003c45 <open>:
    3c45:	b8 0f 00 00 00       	mov    $0xf,%eax
    3c4a:	cd 40                	int    $0x40
    3c4c:	c3                   	ret    

00003c4d <mknod>:
    3c4d:	b8 11 00 00 00       	mov    $0x11,%eax
    3c52:	cd 40                	int    $0x40
    3c54:	c3                   	ret    

00003c55 <unlink>:
    3c55:	b8 12 00 00 00       	mov    $0x12,%eax
    3c5a:	cd 40                	int    $0x40
    3c5c:	c3                   	ret    

00003c5d <fstat>:
    3c5d:	b8 08 00 00 00       	mov    $0x8,%eax
    3c62:	cd 40                	int    $0x40
    3c64:	c3                   	ret    

00003c65 <link>:
    3c65:	b8 13 00 00 00       	mov    $0x13,%eax
    3c6a:	cd 40                	int    $0x40
    3c6c:	c3                   	ret    

00003c6d <mkdir>:
    3c6d:	b8 14 00 00 00       	mov    $0x14,%eax
    3c72:	cd 40                	int    $0x40
    3c74:	c3                   	ret    

00003c75 <chdir>:
    3c75:	b8 09 00 00 00       	mov    $0x9,%eax
    3c7a:	cd 40                	int    $0x40
    3c7c:	c3                   	ret    

00003c7d <dup>:
    3c7d:	b8 0a 00 00 00       	mov    $0xa,%eax
    3c82:	cd 40                	int    $0x40
    3c84:	c3                   	ret    

00003c85 <getpid>:
    3c85:	b8 0b 00 00 00       	mov    $0xb,%eax
    3c8a:	cd 40                	int    $0x40
    3c8c:	c3                   	ret    

00003c8d <sbrk>:
    3c8d:	b8 0c 00 00 00       	mov    $0xc,%eax
    3c92:	cd 40                	int    $0x40
    3c94:	c3                   	ret    

00003c95 <sleep>:
    3c95:	b8 0d 00 00 00       	mov    $0xd,%eax
    3c9a:	cd 40                	int    $0x40
    3c9c:	c3                   	ret    

00003c9d <uptime>:
    3c9d:	b8 0e 00 00 00       	mov    $0xe,%eax
    3ca2:	cd 40                	int    $0x40
    3ca4:	c3                   	ret    

00003ca5 <lseek>:
    3ca5:	b8 16 00 00 00       	mov    $0x16,%eax
    3caa:	cd 40                	int    $0x40
    3cac:	c3                   	ret    

00003cad <isatty>:
    3cad:	b8 17 00 00 00       	mov    $0x17,%eax
    3cb2:	cd 40                	int    $0x40
    3cb4:	c3                   	ret    

00003cb5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3cb5:	55                   	push   %ebp
    3cb6:	89 e5                	mov    %esp,%ebp
    3cb8:	83 ec 28             	sub    $0x28,%esp
    3cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cbe:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3cc1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3cc8:	00 
    3cc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
    3cd0:	8b 45 08             	mov    0x8(%ebp),%eax
    3cd3:	89 04 24             	mov    %eax,(%esp)
    3cd6:	e8 4a ff ff ff       	call   3c25 <write>
}
    3cdb:	c9                   	leave  
    3cdc:	c3                   	ret    

00003cdd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3cdd:	55                   	push   %ebp
    3cde:	89 e5                	mov    %esp,%ebp
    3ce0:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3ce3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3cea:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3cee:	74 17                	je     3d07 <printint+0x2a>
    3cf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3cf4:	79 11                	jns    3d07 <printint+0x2a>
    neg = 1;
    3cf6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d00:	f7 d8                	neg    %eax
    3d02:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d05:	eb 06                	jmp    3d0d <printint+0x30>
  } else {
    x = xx;
    3d07:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3d0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3d14:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d1a:	ba 00 00 00 00       	mov    $0x0,%edx
    3d1f:	f7 f1                	div    %ecx
    3d21:	89 d0                	mov    %edx,%eax
    3d23:	8a 80 b0 5e 00 00    	mov    0x5eb0(%eax),%al
    3d29:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    3d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3d2f:	01 ca                	add    %ecx,%edx
    3d31:	88 02                	mov    %al,(%edx)
    3d33:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    3d36:	8b 55 10             	mov    0x10(%ebp),%edx
    3d39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    3d3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3d3f:	ba 00 00 00 00       	mov    $0x0,%edx
    3d44:	f7 75 d4             	divl   -0x2c(%ebp)
    3d47:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3d4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3d4e:	75 c4                	jne    3d14 <printint+0x37>
  if(neg)
    3d50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d54:	74 2c                	je     3d82 <printint+0xa5>
    buf[i++] = '-';
    3d56:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d5c:	01 d0                	add    %edx,%eax
    3d5e:	c6 00 2d             	movb   $0x2d,(%eax)
    3d61:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    3d64:	eb 1c                	jmp    3d82 <printint+0xa5>
    putc(fd, buf[i]);
    3d66:	8d 55 dc             	lea    -0x24(%ebp),%edx
    3d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3d6c:	01 d0                	add    %edx,%eax
    3d6e:	8a 00                	mov    (%eax),%al
    3d70:	0f be c0             	movsbl %al,%eax
    3d73:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d77:	8b 45 08             	mov    0x8(%ebp),%eax
    3d7a:	89 04 24             	mov    %eax,(%esp)
    3d7d:	e8 33 ff ff ff       	call   3cb5 <putc>
  while(--i >= 0)
    3d82:	ff 4d f4             	decl   -0xc(%ebp)
    3d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3d89:	79 db                	jns    3d66 <printint+0x89>
}
    3d8b:	c9                   	leave  
    3d8c:	c3                   	ret    

00003d8d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    3d8d:	55                   	push   %ebp
    3d8e:	89 e5                	mov    %esp,%ebp
    3d90:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    3d93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    3d9a:	8d 45 0c             	lea    0xc(%ebp),%eax
    3d9d:	83 c0 04             	add    $0x4,%eax
    3da0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    3da3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3daa:	e9 78 01 00 00       	jmp    3f27 <printf+0x19a>
    c = fmt[i] & 0xff;
    3daf:	8b 55 0c             	mov    0xc(%ebp),%edx
    3db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3db5:	01 d0                	add    %edx,%eax
    3db7:	8a 00                	mov    (%eax),%al
    3db9:	0f be c0             	movsbl %al,%eax
    3dbc:	25 ff 00 00 00       	and    $0xff,%eax
    3dc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    3dc4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    3dc8:	75 2c                	jne    3df6 <printf+0x69>
      if(c == '%'){
    3dca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3dce:	75 0c                	jne    3ddc <printf+0x4f>
        state = '%';
    3dd0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    3dd7:	e9 48 01 00 00       	jmp    3f24 <printf+0x197>
      } else {
        putc(fd, c);
    3ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3ddf:	0f be c0             	movsbl %al,%eax
    3de2:	89 44 24 04          	mov    %eax,0x4(%esp)
    3de6:	8b 45 08             	mov    0x8(%ebp),%eax
    3de9:	89 04 24             	mov    %eax,(%esp)
    3dec:	e8 c4 fe ff ff       	call   3cb5 <putc>
    3df1:	e9 2e 01 00 00       	jmp    3f24 <printf+0x197>
      }
    } else if(state == '%'){
    3df6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    3dfa:	0f 85 24 01 00 00    	jne    3f24 <printf+0x197>
      if(c == 'd'){
    3e00:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    3e04:	75 2d                	jne    3e33 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    3e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e09:	8b 00                	mov    (%eax),%eax
    3e0b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    3e12:	00 
    3e13:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    3e1a:	00 
    3e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e1f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e22:	89 04 24             	mov    %eax,(%esp)
    3e25:	e8 b3 fe ff ff       	call   3cdd <printint>
        ap++;
    3e2a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e2e:	e9 ea 00 00 00       	jmp    3f1d <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    3e33:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    3e37:	74 06                	je     3e3f <printf+0xb2>
    3e39:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    3e3d:	75 2d                	jne    3e6c <printf+0xdf>
        printint(fd, *ap, 16, 0);
    3e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e42:	8b 00                	mov    (%eax),%eax
    3e44:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    3e4b:	00 
    3e4c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    3e53:	00 
    3e54:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e58:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5b:	89 04 24             	mov    %eax,(%esp)
    3e5e:	e8 7a fe ff ff       	call   3cdd <printint>
        ap++;
    3e63:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3e67:	e9 b1 00 00 00       	jmp    3f1d <printf+0x190>
      } else if(c == 's'){
    3e6c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    3e70:	75 43                	jne    3eb5 <printf+0x128>
        s = (char*)*ap;
    3e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3e75:	8b 00                	mov    (%eax),%eax
    3e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    3e7a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    3e7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3e82:	75 25                	jne    3ea9 <printf+0x11c>
          s = "(null)";
    3e84:	c7 45 f4 16 58 00 00 	movl   $0x5816,-0xc(%ebp)
        while(*s != 0){
    3e8b:	eb 1c                	jmp    3ea9 <printf+0x11c>
          putc(fd, *s);
    3e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e90:	8a 00                	mov    (%eax),%al
    3e92:	0f be c0             	movsbl %al,%eax
    3e95:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e99:	8b 45 08             	mov    0x8(%ebp),%eax
    3e9c:	89 04 24             	mov    %eax,(%esp)
    3e9f:	e8 11 fe ff ff       	call   3cb5 <putc>
          s++;
    3ea4:	ff 45 f4             	incl   -0xc(%ebp)
    3ea7:	eb 01                	jmp    3eaa <printf+0x11d>
        while(*s != 0){
    3ea9:	90                   	nop
    3eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3ead:	8a 00                	mov    (%eax),%al
    3eaf:	84 c0                	test   %al,%al
    3eb1:	75 da                	jne    3e8d <printf+0x100>
    3eb3:	eb 68                	jmp    3f1d <printf+0x190>
        }
      } else if(c == 'c'){
    3eb5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    3eb9:	75 1d                	jne    3ed8 <printf+0x14b>
        putc(fd, *ap);
    3ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3ebe:	8b 00                	mov    (%eax),%eax
    3ec0:	0f be c0             	movsbl %al,%eax
    3ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ec7:	8b 45 08             	mov    0x8(%ebp),%eax
    3eca:	89 04 24             	mov    %eax,(%esp)
    3ecd:	e8 e3 fd ff ff       	call   3cb5 <putc>
        ap++;
    3ed2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    3ed6:	eb 45                	jmp    3f1d <printf+0x190>
      } else if(c == '%'){
    3ed8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    3edc:	75 17                	jne    3ef5 <printf+0x168>
        putc(fd, c);
    3ede:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3ee1:	0f be c0             	movsbl %al,%eax
    3ee4:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ee8:	8b 45 08             	mov    0x8(%ebp),%eax
    3eeb:	89 04 24             	mov    %eax,(%esp)
    3eee:	e8 c2 fd ff ff       	call   3cb5 <putc>
    3ef3:	eb 28                	jmp    3f1d <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    3ef5:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    3efc:	00 
    3efd:	8b 45 08             	mov    0x8(%ebp),%eax
    3f00:	89 04 24             	mov    %eax,(%esp)
    3f03:	e8 ad fd ff ff       	call   3cb5 <putc>
        putc(fd, c);
    3f08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3f0b:	0f be c0             	movsbl %al,%eax
    3f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3f12:	8b 45 08             	mov    0x8(%ebp),%eax
    3f15:	89 04 24             	mov    %eax,(%esp)
    3f18:	e8 98 fd ff ff       	call   3cb5 <putc>
      }
      state = 0;
    3f1d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
    3f24:	ff 45 f0             	incl   -0x10(%ebp)
    3f27:	8b 55 0c             	mov    0xc(%ebp),%edx
    3f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3f2d:	01 d0                	add    %edx,%eax
    3f2f:	8a 00                	mov    (%eax),%al
    3f31:	84 c0                	test   %al,%al
    3f33:	0f 85 76 fe ff ff    	jne    3daf <printf+0x22>
    }
  }
}
    3f39:	c9                   	leave  
    3f3a:	c3                   	ret    

00003f3b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3f3b:	55                   	push   %ebp
    3f3c:	89 e5                	mov    %esp,%ebp
    3f3e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3f41:	8b 45 08             	mov    0x8(%ebp),%eax
    3f44:	83 e8 08             	sub    $0x8,%eax
    3f47:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3f4a:	a1 68 5f 00 00       	mov    0x5f68,%eax
    3f4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f52:	eb 24                	jmp    3f78 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f57:	8b 00                	mov    (%eax),%eax
    3f59:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f5c:	77 12                	ja     3f70 <free+0x35>
    3f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f61:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f64:	77 24                	ja     3f8a <free+0x4f>
    3f66:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f69:	8b 00                	mov    (%eax),%eax
    3f6b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3f6e:	77 1a                	ja     3f8a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3f70:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f73:	8b 00                	mov    (%eax),%eax
    3f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3f78:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f7b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    3f7e:	76 d4                	jbe    3f54 <free+0x19>
    3f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f83:	8b 00                	mov    (%eax),%eax
    3f85:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3f88:	76 ca                	jbe    3f54 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3f8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f8d:	8b 40 04             	mov    0x4(%eax),%eax
    3f90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    3f97:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3f9a:	01 c2                	add    %eax,%edx
    3f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3f9f:	8b 00                	mov    (%eax),%eax
    3fa1:	39 c2                	cmp    %eax,%edx
    3fa3:	75 24                	jne    3fc9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    3fa5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fa8:	8b 50 04             	mov    0x4(%eax),%edx
    3fab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fae:	8b 00                	mov    (%eax),%eax
    3fb0:	8b 40 04             	mov    0x4(%eax),%eax
    3fb3:	01 c2                	add    %eax,%edx
    3fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fb8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    3fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fbe:	8b 00                	mov    (%eax),%eax
    3fc0:	8b 10                	mov    (%eax),%edx
    3fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fc5:	89 10                	mov    %edx,(%eax)
    3fc7:	eb 0a                	jmp    3fd3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    3fc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fcc:	8b 10                	mov    (%eax),%edx
    3fce:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3fd1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    3fd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fd6:	8b 40 04             	mov    0x4(%eax),%eax
    3fd9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    3fe0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fe3:	01 d0                	add    %edx,%eax
    3fe5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    3fe8:	75 20                	jne    400a <free+0xcf>
    p->s.size += bp->s.size;
    3fea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3fed:	8b 50 04             	mov    0x4(%eax),%edx
    3ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3ff3:	8b 40 04             	mov    0x4(%eax),%eax
    3ff6:	01 c2                	add    %eax,%edx
    3ff8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3ffb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3ffe:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4001:	8b 10                	mov    (%eax),%edx
    4003:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4006:	89 10                	mov    %edx,(%eax)
    4008:	eb 08                	jmp    4012 <free+0xd7>
  } else
    p->s.ptr = bp;
    400a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    400d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    4010:	89 10                	mov    %edx,(%eax)
  freep = p;
    4012:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4015:	a3 68 5f 00 00       	mov    %eax,0x5f68
}
    401a:	c9                   	leave  
    401b:	c3                   	ret    

0000401c <morecore>:

static Header*
morecore(uint nu)
{
    401c:	55                   	push   %ebp
    401d:	89 e5                	mov    %esp,%ebp
    401f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    4022:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4029:	77 07                	ja     4032 <morecore+0x16>
    nu = 4096;
    402b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    4032:	8b 45 08             	mov    0x8(%ebp),%eax
    4035:	c1 e0 03             	shl    $0x3,%eax
    4038:	89 04 24             	mov    %eax,(%esp)
    403b:	e8 4d fc ff ff       	call   3c8d <sbrk>
    4040:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4043:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4047:	75 07                	jne    4050 <morecore+0x34>
    return 0;
    4049:	b8 00 00 00 00       	mov    $0x0,%eax
    404e:	eb 22                	jmp    4072 <morecore+0x56>
  hp = (Header*)p;
    4050:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4056:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4059:	8b 55 08             	mov    0x8(%ebp),%edx
    405c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    405f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4062:	83 c0 08             	add    $0x8,%eax
    4065:	89 04 24             	mov    %eax,(%esp)
    4068:	e8 ce fe ff ff       	call   3f3b <free>
  return freep;
    406d:	a1 68 5f 00 00       	mov    0x5f68,%eax
}
    4072:	c9                   	leave  
    4073:	c3                   	ret    

00004074 <malloc>:

void*
malloc(uint nbytes)
{
    4074:	55                   	push   %ebp
    4075:	89 e5                	mov    %esp,%ebp
    4077:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    407a:	8b 45 08             	mov    0x8(%ebp),%eax
    407d:	83 c0 07             	add    $0x7,%eax
    4080:	c1 e8 03             	shr    $0x3,%eax
    4083:	40                   	inc    %eax
    4084:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4087:	a1 68 5f 00 00       	mov    0x5f68,%eax
    408c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    408f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4093:	75 23                	jne    40b8 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    4095:	c7 45 f0 60 5f 00 00 	movl   $0x5f60,-0x10(%ebp)
    409c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    409f:	a3 68 5f 00 00       	mov    %eax,0x5f68
    40a4:	a1 68 5f 00 00       	mov    0x5f68,%eax
    40a9:	a3 60 5f 00 00       	mov    %eax,0x5f60
    base.s.size = 0;
    40ae:	c7 05 64 5f 00 00 00 	movl   $0x0,0x5f64
    40b5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    40b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40bb:	8b 00                	mov    (%eax),%eax
    40bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    40c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40c3:	8b 40 04             	mov    0x4(%eax),%eax
    40c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    40c9:	72 4d                	jb     4118 <malloc+0xa4>
      if(p->s.size == nunits)
    40cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40ce:	8b 40 04             	mov    0x4(%eax),%eax
    40d1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    40d4:	75 0c                	jne    40e2 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    40d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40d9:	8b 10                	mov    (%eax),%edx
    40db:	8b 45 f0             	mov    -0x10(%ebp),%eax
    40de:	89 10                	mov    %edx,(%eax)
    40e0:	eb 26                	jmp    4108 <malloc+0x94>
      else {
        p->s.size -= nunits;
    40e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40e5:	8b 40 04             	mov    0x4(%eax),%eax
    40e8:	89 c2                	mov    %eax,%edx
    40ea:	2b 55 ec             	sub    -0x14(%ebp),%edx
    40ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40f0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    40f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    40f6:	8b 40 04             	mov    0x4(%eax),%eax
    40f9:	c1 e0 03             	shl    $0x3,%eax
    40fc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    40ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4102:	8b 55 ec             	mov    -0x14(%ebp),%edx
    4105:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    4108:	8b 45 f0             	mov    -0x10(%ebp),%eax
    410b:	a3 68 5f 00 00       	mov    %eax,0x5f68
      return (void*)(p + 1);
    4110:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4113:	83 c0 08             	add    $0x8,%eax
    4116:	eb 38                	jmp    4150 <malloc+0xdc>
    }
    if(p == freep)
    4118:	a1 68 5f 00 00       	mov    0x5f68,%eax
    411d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    4120:	75 1b                	jne    413d <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    4122:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4125:	89 04 24             	mov    %eax,(%esp)
    4128:	e8 ef fe ff ff       	call   401c <morecore>
    412d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    4130:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4134:	75 07                	jne    413d <malloc+0xc9>
        return 0;
    4136:	b8 00 00 00 00       	mov    $0x0,%eax
    413b:	eb 13                	jmp    4150 <malloc+0xdc>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    413d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4140:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4143:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4146:	8b 00                	mov    (%eax),%eax
    4148:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
    414b:	e9 70 ff ff ff       	jmp    40c0 <malloc+0x4c>
}
    4150:	c9                   	leave  
    4151:	c3                   	ret    
