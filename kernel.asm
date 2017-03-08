
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:
8010000c:	0f 20 e0             	mov    %cr4,%eax
8010000f:	83 c8 10             	or     $0x10,%eax
80100012:	0f 22 e0             	mov    %eax,%cr4
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 90 d6 10 80       	mov    $0x8010d690,%esp
8010002d:	b8 b5 33 10 80       	mov    $0x801033b5,%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 08 8f 10 	movl   $0x80108f08,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100049:	e8 f1 55 00 00       	call   8010563f <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 d0 eb 10 80 c4 	movl   $0x8010ebc4,0x8010ebd0
80100055:	eb 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d4 eb 10 80 c4 	movl   $0x8010ebc4,0x8010ebd4
8010005f:	eb 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 d4 d6 10 80 	movl   $0x8010d6d4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 d4 eb 10 80    	mov    0x8010ebd4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c c4 eb 10 80 	movl   $0x8010ebc4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 d4 eb 10 80       	mov    0x8010ebd4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 d4 eb 10 80       	mov    %eax,0x8010ebd4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 c4 eb 10 80 	cmpl   $0x8010ebc4,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801000bd:	e8 9e 55 00 00       	call   80105660 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 d4 eb 10 80       	mov    0x8010ebd4,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100104:	e8 b9 55 00 00       	call   801056c2 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 a0 d6 10 	movl   $0x8010d6a0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 ba 49 00 00       	call   80104ade <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 c4 eb 10 80 	cmpl   $0x8010ebc4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 d0 eb 10 80       	mov    0x8010ebd0,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010017c:	e8 41 55 00 00       	call   801056c2 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 c4 eb 10 80 	cmpl   $0x8010ebc4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 0f 8f 10 80 	movl   $0x80108f0f,(%esp)
8010019f:	e8 92 03 00 00       	call   80100536 <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 a8 25 00 00       	call   80102780 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 20 8f 10 80 	movl   $0x80108f20,(%esp)
801001f6:	e8 3b 03 00 00       	call   80100536 <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 6b 25 00 00       	call   80102780 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 27 8f 10 80 	movl   $0x80108f27,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010023c:	e8 1f 54 00 00       	call   80105660 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 d4 eb 10 80    	mov    0x8010ebd4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c c4 eb 10 80 	movl   $0x8010ebc4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 d4 eb 10 80       	mov    0x8010ebd4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 d4 eb 10 80       	mov    %eax,0x8010ebd4

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 44 49 00 00       	call   80104be6 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801002a9:	e8 14 54 00 00       	call   801056c2 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	8b 55 e8             	mov    -0x18(%ebp),%edx
801002c1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c5:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801002c9:	ec                   	in     (%dx),%al
801002ca:	88 c3                	mov    %al,%bl
801002cc:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002cf:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801002d2:	83 c4 14             	add    $0x14,%esp
801002d5:	5b                   	pop    %ebx
801002d6:	5d                   	pop    %ebp
801002d7:	c3                   	ret    

801002d8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 08             	sub    $0x8,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
801002e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801002e8:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002eb:	8a 45 f8             	mov    -0x8(%ebp),%al
801002ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
801002f1:	ee                   	out    %al,(%dx)
}
801002f2:	c9                   	leave  
801002f3:	c3                   	ret    

801002f4 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f4:	55                   	push   %ebp
801002f5:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002f7:	fa                   	cli    
}
801002f8:	5d                   	pop    %ebp
801002f9:	c3                   	ret    

801002fa <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fa:	55                   	push   %ebp
801002fb:	89 e5                	mov    %esp,%ebp
801002fd:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100300:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100304:	74 1c                	je     80100322 <printint+0x28>
80100306:	8b 45 08             	mov    0x8(%ebp),%eax
80100309:	c1 e8 1f             	shr    $0x1f,%eax
8010030c:	0f b6 c0             	movzbl %al,%eax
8010030f:	89 45 10             	mov    %eax,0x10(%ebp)
80100312:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100316:	74 0a                	je     80100322 <printint+0x28>
    x = -xx;
80100318:	8b 45 08             	mov    0x8(%ebp),%eax
8010031b:	f7 d8                	neg    %eax
8010031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100320:	eb 06                	jmp    80100328 <printint+0x2e>
  else
    x = xx;
80100322:	8b 45 08             	mov    0x8(%ebp),%eax
80100325:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100328:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010032f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100332:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100335:	ba 00 00 00 00       	mov    $0x0,%edx
8010033a:	f7 f1                	div    %ecx
8010033c:	89 d0                	mov    %edx,%eax
8010033e:	8a 80 04 a0 10 80    	mov    -0x7fef5ffc(%eax),%al
80100344:	8d 4d e0             	lea    -0x20(%ebp),%ecx
80100347:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010034a:	01 ca                	add    %ecx,%edx
8010034c:	88 02                	mov    %al,(%edx)
8010034e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
80100351:	8b 55 0c             	mov    0xc(%ebp),%edx
80100354:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035a:	ba 00 00 00 00       	mov    $0x0,%edx
8010035f:	f7 75 d4             	divl   -0x2c(%ebp)
80100362:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100365:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100369:	75 c4                	jne    8010032f <printint+0x35>

  if(sign)
8010036b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010036f:	74 25                	je     80100396 <printint+0x9c>
    buf[i++] = '-';
80100371:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100377:	01 d0                	add    %edx,%eax
80100379:	c6 00 2d             	movb   $0x2d,(%eax)
8010037c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 15                	jmp    80100396 <printint+0x9c>
    consputc(buf[i]);
80100381:	8d 55 e0             	lea    -0x20(%ebp),%edx
80100384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100387:	01 d0                	add    %edx,%eax
80100389:	8a 00                	mov    (%eax),%al
8010038b:	0f be c0             	movsbl %al,%eax
8010038e:	89 04 24             	mov    %eax,(%esp)
80100391:	e8 9d 03 00 00       	call   80100733 <consputc>
  while(--i >= 0)
80100396:	ff 4d f4             	decl   -0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x87>
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 34 c6 10 80       	mov    0x8010c634,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
801003bc:	e8 9f 52 00 00       	call   80105660 <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 2e 8f 10 80 	movl   $0x80108f2e,(%esp)
801003cf:	e8 62 01 00 00       	call   80100536 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 1a 01 00 00       	jmp    80100500 <cprintf+0x15f>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 3c 03 00 00       	call   80100733 <consputc>
      continue;
801003f7:	e9 01 01 00 00       	jmp    801004fd <cprintf+0x15c>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	ff 45 f4             	incl   -0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	8a 00                	mov    (%eax),%al
80100409:	0f be c0             	movsbl %al,%eax
8010040c:	25 ff 00 00 00       	and    $0xff,%eax
80100411:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100414:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100418:	0f 84 03 01 00 00    	je     80100521 <cprintf+0x180>
      break;
    switch(c){
8010041e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100421:	83 f8 70             	cmp    $0x70,%eax
80100424:	74 4d                	je     80100473 <cprintf+0xd2>
80100426:	83 f8 70             	cmp    $0x70,%eax
80100429:	7f 13                	jg     8010043e <cprintf+0x9d>
8010042b:	83 f8 25             	cmp    $0x25,%eax
8010042e:	0f 84 a3 00 00 00    	je     801004d7 <cprintf+0x136>
80100434:	83 f8 64             	cmp    $0x64,%eax
80100437:	74 14                	je     8010044d <cprintf+0xac>
80100439:	e9 a7 00 00 00       	jmp    801004e5 <cprintf+0x144>
8010043e:	83 f8 73             	cmp    $0x73,%eax
80100441:	74 53                	je     80100496 <cprintf+0xf5>
80100443:	83 f8 78             	cmp    $0x78,%eax
80100446:	74 2b                	je     80100473 <cprintf+0xd2>
80100448:	e9 98 00 00 00       	jmp    801004e5 <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010044d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100450:	8b 00                	mov    (%eax),%eax
80100452:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100456:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045d:	00 
8010045e:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100465:	00 
80100466:	89 04 24             	mov    %eax,(%esp)
80100469:	e8 8c fe ff ff       	call   801002fa <printint>
      break;
8010046e:	e9 8a 00 00 00       	jmp    801004fd <cprintf+0x15c>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100473:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100476:	8b 00                	mov    (%eax),%eax
80100478:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100483:	00 
80100484:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048b:	00 
8010048c:	89 04 24             	mov    %eax,(%esp)
8010048f:	e8 66 fe ff ff       	call   801002fa <printint>
      break;
80100494:	eb 67                	jmp    801004fd <cprintf+0x15c>
    case 's':
      if((s = (char*)*argp++) == 0)
80100496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100499:	8b 00                	mov    (%eax),%eax
8010049b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010049e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a2:	0f 94 c0             	sete   %al
801004a5:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004a9:	84 c0                	test   %al,%al
801004ab:	74 1e                	je     801004cb <cprintf+0x12a>
        s = "(null)";
801004ad:	c7 45 ec 37 8f 10 80 	movl   $0x80108f37,-0x14(%ebp)
      for(; *s; s++)
801004b4:	eb 15                	jmp    801004cb <cprintf+0x12a>
        consputc(*s);
801004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004b9:	8a 00                	mov    (%eax),%al
801004bb:	0f be c0             	movsbl %al,%eax
801004be:	89 04 24             	mov    %eax,(%esp)
801004c1:	e8 6d 02 00 00       	call   80100733 <consputc>
      for(; *s; s++)
801004c6:	ff 45 ec             	incl   -0x14(%ebp)
801004c9:	eb 01                	jmp    801004cc <cprintf+0x12b>
801004cb:	90                   	nop
801004cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004cf:	8a 00                	mov    (%eax),%al
801004d1:	84 c0                	test   %al,%al
801004d3:	75 e1                	jne    801004b6 <cprintf+0x115>
      break;
801004d5:	eb 26                	jmp    801004fd <cprintf+0x15c>
    case '%':
      consputc('%');
801004d7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004de:	e8 50 02 00 00       	call   80100733 <consputc>
      break;
801004e3:	eb 18                	jmp    801004fd <cprintf+0x15c>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004e5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004ec:	e8 42 02 00 00       	call   80100733 <consputc>
      consputc(c);
801004f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f4:	89 04 24             	mov    %eax,(%esp)
801004f7:	e8 37 02 00 00       	call   80100733 <consputc>
      break;
801004fc:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801004fd:	ff 45 f4             	incl   -0xc(%ebp)
80100500:	8b 55 08             	mov    0x8(%ebp),%edx
80100503:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100506:	01 d0                	add    %edx,%eax
80100508:	8a 00                	mov    (%eax),%al
8010050a:	0f be c0             	movsbl %al,%eax
8010050d:	25 ff 00 00 00       	and    $0xff,%eax
80100512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100515:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100519:	0f 85 c7 fe ff ff    	jne    801003e6 <cprintf+0x45>
8010051f:	eb 01                	jmp    80100522 <cprintf+0x181>
      break;
80100521:	90                   	nop
    }
  }

  if(locking)
80100522:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100526:	74 0c                	je     80100534 <cprintf+0x193>
    release(&cons.lock);
80100528:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010052f:	e8 8e 51 00 00       	call   801056c2 <release>
}
80100534:	c9                   	leave  
80100535:	c3                   	ret    

80100536 <panic>:

void
panic(char *s)
{
80100536:	55                   	push   %ebp
80100537:	89 e5                	mov    %esp,%ebp
80100539:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
8010053c:	e8 b3 fd ff ff       	call   801002f4 <cli>
  cons.locking = 0;
80100541:	c7 05 34 c6 10 80 00 	movl   $0x0,0x8010c634
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 3e 8f 10 80 	movl   $0x80108f3e,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 4d 8f 10 80 	movl   $0x80108f4d,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 82 51 00 00       	call   80105711 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 4f 8f 10 80 	movl   $0x80108f4f,(%esp)
801005aa:	e8 f2 fd ff ff       	call   801003a1 <cprintf>
  for(i=0; i<10; i++)
801005af:	ff 45 f4             	incl   -0xc(%ebp)
801005b2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005b6:	7e e0                	jle    80100598 <panic+0x62>
  panicked = 1; // freeze other CPU
801005b8:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
801005bf:	00 00 00 
  for(;;)
    ;
801005c2:	eb fe                	jmp    801005c2 <panic+0x8c>

801005c4 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005c4:	55                   	push   %ebp
801005c5:	89 e5                	mov    %esp,%ebp
801005c7:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005ca:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d1:	00 
801005d2:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005d9:	e8 fa fc ff ff       	call   801002d8 <outb>
  pos = inb(CRTPORT+1) << 8;
801005de:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005e5:	e8 c6 fc ff ff       	call   801002b0 <inb>
801005ea:	0f b6 c0             	movzbl %al,%eax
801005ed:	c1 e0 08             	shl    $0x8,%eax
801005f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f3:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801005fa:	00 
801005fb:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100602:	e8 d1 fc ff ff       	call   801002d8 <outb>
  pos |= inb(CRTPORT+1);
80100607:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060e:	e8 9d fc ff ff       	call   801002b0 <inb>
80100613:	0f b6 c0             	movzbl %al,%eax
80100616:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100619:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
8010061d:	75 1d                	jne    8010063c <cgaputc+0x78>
    pos += 80 - pos%80;
8010061f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100622:	b9 50 00 00 00       	mov    $0x50,%ecx
80100627:	99                   	cltd   
80100628:	f7 f9                	idiv   %ecx
8010062a:	89 d0                	mov    %edx,%eax
8010062c:	ba 50 00 00 00       	mov    $0x50,%edx
80100631:	89 d1                	mov    %edx,%ecx
80100633:	29 c1                	sub    %eax,%ecx
80100635:	89 c8                	mov    %ecx,%eax
80100637:	01 45 f4             	add    %eax,-0xc(%ebp)
8010063a:	eb 31                	jmp    8010066d <cgaputc+0xa9>
  else if(c == BACKSPACE){
8010063c:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100643:	75 0b                	jne    80100650 <cgaputc+0x8c>
    if(pos > 0) --pos;
80100645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100649:	7e 22                	jle    8010066d <cgaputc+0xa9>
8010064b:	ff 4d f4             	decl   -0xc(%ebp)
8010064e:	eb 1d                	jmp    8010066d <cgaputc+0xa9>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100650:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100655:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100658:	d1 e2                	shl    %edx
8010065a:	01 c2                	add    %eax,%edx
8010065c:	8b 45 08             	mov    0x8(%ebp),%eax
8010065f:	25 ff 00 00 00       	and    $0xff,%eax
80100664:	80 cc 07             	or     $0x7,%ah
80100667:	66 89 02             	mov    %ax,(%edx)
8010066a:	ff 45 f4             	incl   -0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010066d:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100674:	7e 53                	jle    801006c9 <cgaputc+0x105>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100676:	a1 00 a0 10 80       	mov    0x8010a000,%eax
8010067b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100681:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100686:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
8010068d:	00 
8010068e:	89 54 24 04          	mov    %edx,0x4(%esp)
80100692:	89 04 24             	mov    %eax,(%esp)
80100695:	e8 e4 52 00 00       	call   8010597e <memmove>
    pos -= 80;
8010069a:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010069e:	b8 80 07 00 00       	mov    $0x780,%eax
801006a3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006a6:	d1 e0                	shl    %eax
801006a8:	8b 15 00 a0 10 80    	mov    0x8010a000,%edx
801006ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006b1:	d1 e1                	shl    %ecx
801006b3:	01 ca                	add    %ecx,%edx
801006b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801006b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006c0:	00 
801006c1:	89 14 24             	mov    %edx,(%esp)
801006c4:	e8 e9 51 00 00       	call   801058b2 <memset>
  }
  
  outb(CRTPORT, 14);
801006c9:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006d0:	00 
801006d1:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006d8:	e8 fb fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos>>8);
801006dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006e0:	c1 f8 08             	sar    $0x8,%eax
801006e3:	0f b6 c0             	movzbl %al,%eax
801006e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801006ea:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801006f1:	e8 e2 fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT, 15);
801006f6:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
801006fd:	00 
801006fe:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100705:	e8 ce fb ff ff       	call   801002d8 <outb>
  outb(CRTPORT+1, pos);
8010070a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010070d:	0f b6 c0             	movzbl %al,%eax
80100710:	89 44 24 04          	mov    %eax,0x4(%esp)
80100714:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010071b:	e8 b8 fb ff ff       	call   801002d8 <outb>
  crt[pos] = ' ' | 0x0700;
80100720:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100725:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100728:	d1 e2                	shl    %edx
8010072a:	01 d0                	add    %edx,%eax
8010072c:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
80100731:	c9                   	leave  
80100732:	c3                   	ret    

80100733 <consputc>:

void
consputc(int c)
{
80100733:	55                   	push   %ebp
80100734:	89 e5                	mov    %esp,%ebp
80100736:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100739:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
8010073e:	85 c0                	test   %eax,%eax
80100740:	74 07                	je     80100749 <consputc+0x16>
    cli();
80100742:	e8 ad fb ff ff       	call   801002f4 <cli>
    for(;;)
      ;
80100747:	eb fe                	jmp    80100747 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100749:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
80100750:	75 26                	jne    80100778 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100752:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100759:	e8 54 6d 00 00       	call   801074b2 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 48 6d 00 00       	call   801074b2 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 3c 6d 00 00       	call   801074b2 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 2f 6d 00 00       	call   801074b2 <uartputc>
  cgaputc(c);
80100783:	8b 45 08             	mov    0x8(%ebp),%eax
80100786:	89 04 24             	mov    %eax,(%esp)
80100789:	e8 36 fe ff ff       	call   801005c4 <cgaputc>
}
8010078e:	c9                   	leave  
8010078f:	c3                   	ret    

80100790 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
80100790:	55                   	push   %ebp
80100791:	89 e5                	mov    %esp,%ebp
80100793:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
80100796:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
8010079d:	e8 be 4e 00 00       	call   80105660 <acquire>
  while((c = getc()) >= 0){
801007a2:	e9 35 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    switch(c){
801007a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007aa:	83 f8 10             	cmp    $0x10,%eax
801007ad:	74 1b                	je     801007ca <consoleintr+0x3a>
801007af:	83 f8 10             	cmp    $0x10,%eax
801007b2:	7f 0a                	jg     801007be <consoleintr+0x2e>
801007b4:	83 f8 08             	cmp    $0x8,%eax
801007b7:	74 60                	je     80100819 <consoleintr+0x89>
801007b9:	e9 8a 00 00 00       	jmp    80100848 <consoleintr+0xb8>
801007be:	83 f8 15             	cmp    $0x15,%eax
801007c1:	74 2a                	je     801007ed <consoleintr+0x5d>
801007c3:	83 f8 7f             	cmp    $0x7f,%eax
801007c6:	74 51                	je     80100819 <consoleintr+0x89>
801007c8:	eb 7e                	jmp    80100848 <consoleintr+0xb8>
    case C('P'):  // Process listing.
      procdump();
801007ca:	e8 c6 44 00 00       	call   80104c95 <procdump>
      break;
801007cf:	e9 08 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007d4:	a1 9c ee 10 80       	mov    0x8010ee9c,%eax
801007d9:	48                   	dec    %eax
801007da:	a3 9c ee 10 80       	mov    %eax,0x8010ee9c
        consputc(BACKSPACE);
801007df:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801007e6:	e8 48 ff ff ff       	call   80100733 <consputc>
801007eb:	eb 01                	jmp    801007ee <consoleintr+0x5e>
      while(input.e != input.w &&
801007ed:	90                   	nop
801007ee:	8b 15 9c ee 10 80    	mov    0x8010ee9c,%edx
801007f4:	a1 98 ee 10 80       	mov    0x8010ee98,%eax
801007f9:	39 c2                	cmp    %eax,%edx
801007fb:	0f 84 d4 00 00 00    	je     801008d5 <consoleintr+0x145>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100801:	a1 9c ee 10 80       	mov    0x8010ee9c,%eax
80100806:	48                   	dec    %eax
80100807:	83 e0 7f             	and    $0x7f,%eax
8010080a:	8a 80 14 ee 10 80    	mov    -0x7fef11ec(%eax),%al
      while(input.e != input.w &&
80100810:	3c 0a                	cmp    $0xa,%al
80100812:	75 c0                	jne    801007d4 <consoleintr+0x44>
      }
      break;
80100814:	e9 bc 00 00 00       	jmp    801008d5 <consoleintr+0x145>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100819:	8b 15 9c ee 10 80    	mov    0x8010ee9c,%edx
8010081f:	a1 98 ee 10 80       	mov    0x8010ee98,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 ac 00 00 00    	je     801008d8 <consoleintr+0x148>
        input.e--;
8010082c:	a1 9c ee 10 80       	mov    0x8010ee9c,%eax
80100831:	48                   	dec    %eax
80100832:	a3 9c ee 10 80       	mov    %eax,0x8010ee9c
        consputc(BACKSPACE);
80100837:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010083e:	e8 f0 fe ff ff       	call   80100733 <consputc>
      }
      break;
80100843:	e9 90 00 00 00       	jmp    801008d8 <consoleintr+0x148>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100848:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010084c:	0f 84 89 00 00 00    	je     801008db <consoleintr+0x14b>
80100852:	8b 15 9c ee 10 80    	mov    0x8010ee9c,%edx
80100858:	a1 94 ee 10 80       	mov    0x8010ee94,%eax
8010085d:	89 d1                	mov    %edx,%ecx
8010085f:	29 c1                	sub    %eax,%ecx
80100861:	89 c8                	mov    %ecx,%eax
80100863:	83 f8 7f             	cmp    $0x7f,%eax
80100866:	77 73                	ja     801008db <consoleintr+0x14b>
        c = (c == '\r') ? '\n' : c;
80100868:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010086c:	74 05                	je     80100873 <consoleintr+0xe3>
8010086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100871:	eb 05                	jmp    80100878 <consoleintr+0xe8>
80100873:	b8 0a 00 00 00       	mov    $0xa,%eax
80100878:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010087b:	a1 9c ee 10 80       	mov    0x8010ee9c,%eax
80100880:	89 c1                	mov    %eax,%ecx
80100882:	83 e1 7f             	and    $0x7f,%ecx
80100885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100888:	88 91 14 ee 10 80    	mov    %dl,-0x7fef11ec(%ecx)
8010088e:	40                   	inc    %eax
8010088f:	a3 9c ee 10 80       	mov    %eax,0x8010ee9c
        consputc(c);
80100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100897:	89 04 24             	mov    %eax,(%esp)
8010089a:	e8 94 fe ff ff       	call   80100733 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010089f:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008a3:	74 18                	je     801008bd <consoleintr+0x12d>
801008a5:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008a9:	74 12                	je     801008bd <consoleintr+0x12d>
801008ab:	a1 9c ee 10 80       	mov    0x8010ee9c,%eax
801008b0:	8b 15 94 ee 10 80    	mov    0x8010ee94,%edx
801008b6:	83 ea 80             	sub    $0xffffff80,%edx
801008b9:	39 d0                	cmp    %edx,%eax
801008bb:	75 1e                	jne    801008db <consoleintr+0x14b>
          input.w = input.e;
801008bd:	a1 9c ee 10 80       	mov    0x8010ee9c,%eax
801008c2:	a3 98 ee 10 80       	mov    %eax,0x8010ee98
          wakeup(&input.r);
801008c7:	c7 04 24 94 ee 10 80 	movl   $0x8010ee94,(%esp)
801008ce:	e8 13 43 00 00       	call   80104be6 <wakeup>
        }
      }
      break;
801008d3:	eb 06                	jmp    801008db <consoleintr+0x14b>
      break;
801008d5:	90                   	nop
801008d6:	eb 04                	jmp    801008dc <consoleintr+0x14c>
      break;
801008d8:	90                   	nop
801008d9:	eb 01                	jmp    801008dc <consoleintr+0x14c>
      break;
801008db:	90                   	nop
  while((c = getc()) >= 0){
801008dc:	8b 45 08             	mov    0x8(%ebp),%eax
801008df:	ff d0                	call   *%eax
801008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801008e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801008e8:	0f 89 b9 fe ff ff    	jns    801007a7 <consoleintr+0x17>
    }
  }
  release(&input.lock);
801008ee:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
801008f5:	e8 c8 4d 00 00       	call   801056c2 <release>
}
801008fa:	c9                   	leave  
801008fb:	c3                   	ret    

801008fc <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801008fc:	55                   	push   %ebp
801008fd:	89 e5                	mov    %esp,%ebp
801008ff:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100902:	8b 45 08             	mov    0x8(%ebp),%eax
80100905:	89 04 24             	mov    %eax,(%esp)
80100908:	e8 83 10 00 00       	call   80101990 <iunlock>
  target = n;
8010090d:	8b 45 10             	mov    0x10(%ebp),%eax
80100910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100913:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
8010091a:	e8 41 4d 00 00       	call   80105660 <acquire>
  while(n > 0){
8010091f:	e9 a1 00 00 00       	jmp    801009c5 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010092a:	8b 40 24             	mov    0x24(%eax),%eax
8010092d:	85 c0                	test   %eax,%eax
8010092f:	74 21                	je     80100952 <consoleread+0x56>
        release(&input.lock);
80100931:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
80100938:	e8 85 4d 00 00       	call   801056c2 <release>
        ilock(ip);
8010093d:	8b 45 08             	mov    0x8(%ebp),%eax
80100940:	89 04 24             	mov    %eax,(%esp)
80100943:	e8 fd 0e 00 00       	call   80101845 <ilock>
        return -1;
80100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010094d:	e9 a2 00 00 00       	jmp    801009f4 <consoleread+0xf8>
      }
      sleep(&input.r, &input.lock);
80100952:	c7 44 24 04 e0 ed 10 	movl   $0x8010ede0,0x4(%esp)
80100959:	80 
8010095a:	c7 04 24 94 ee 10 80 	movl   $0x8010ee94,(%esp)
80100961:	e8 78 41 00 00       	call   80104ade <sleep>
80100966:	eb 01                	jmp    80100969 <consoleread+0x6d>
    while(input.r == input.w){
80100968:	90                   	nop
80100969:	8b 15 94 ee 10 80    	mov    0x8010ee94,%edx
8010096f:	a1 98 ee 10 80       	mov    0x8010ee98,%eax
80100974:	39 c2                	cmp    %eax,%edx
80100976:	74 ac                	je     80100924 <consoleread+0x28>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100978:	a1 94 ee 10 80       	mov    0x8010ee94,%eax
8010097d:	89 c2                	mov    %eax,%edx
8010097f:	83 e2 7f             	and    $0x7f,%edx
80100982:	8a 92 14 ee 10 80    	mov    -0x7fef11ec(%edx),%dl
80100988:	0f be d2             	movsbl %dl,%edx
8010098b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010098e:	40                   	inc    %eax
8010098f:	a3 94 ee 10 80       	mov    %eax,0x8010ee94
    if(c == C('D')){  // EOF
80100994:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100998:	75 15                	jne    801009af <consoleread+0xb3>
      if(n < target){
8010099a:	8b 45 10             	mov    0x10(%ebp),%eax
8010099d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009a0:	73 2b                	jae    801009cd <consoleread+0xd1>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009a2:	a1 94 ee 10 80       	mov    0x8010ee94,%eax
801009a7:	48                   	dec    %eax
801009a8:	a3 94 ee 10 80       	mov    %eax,0x8010ee94
      }
      break;
801009ad:	eb 1e                	jmp    801009cd <consoleread+0xd1>
    }
    *dst++ = c;
801009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009b2:	88 c2                	mov    %al,%dl
801009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801009b7:	88 10                	mov    %dl,(%eax)
801009b9:	ff 45 0c             	incl   0xc(%ebp)
    --n;
801009bc:	ff 4d 10             	decl   0x10(%ebp)
    if(c == '\n')
801009bf:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009c3:	74 0b                	je     801009d0 <consoleread+0xd4>
  while(n > 0){
801009c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009c9:	7f 9d                	jg     80100968 <consoleread+0x6c>
801009cb:	eb 04                	jmp    801009d1 <consoleread+0xd5>
      break;
801009cd:	90                   	nop
801009ce:	eb 01                	jmp    801009d1 <consoleread+0xd5>
      break;
801009d0:	90                   	nop
  }
  release(&input.lock);
801009d1:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
801009d8:	e8 e5 4c 00 00       	call   801056c2 <release>
  ilock(ip);
801009dd:	8b 45 08             	mov    0x8(%ebp),%eax
801009e0:	89 04 24             	mov    %eax,(%esp)
801009e3:	e8 5d 0e 00 00       	call   80101845 <ilock>

  return target - n;
801009e8:	8b 45 10             	mov    0x10(%ebp),%eax
801009eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801009ee:	89 d1                	mov    %edx,%ecx
801009f0:	29 c1                	sub    %eax,%ecx
801009f2:	89 c8                	mov    %ecx,%eax
}
801009f4:	c9                   	leave  
801009f5:	c3                   	ret    

801009f6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801009f6:	55                   	push   %ebp
801009f7:	89 e5                	mov    %esp,%ebp
801009f9:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
801009fc:	8b 45 08             	mov    0x8(%ebp),%eax
801009ff:	89 04 24             	mov    %eax,(%esp)
80100a02:	e8 89 0f 00 00       	call   80101990 <iunlock>
  acquire(&cons.lock);
80100a07:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100a0e:	e8 4d 4c 00 00       	call   80105660 <acquire>
  for(i = 0; i < n; i++)
80100a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a1a:	eb 1d                	jmp    80100a39 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a22:	01 d0                	add    %edx,%eax
80100a24:	8a 00                	mov    (%eax),%al
80100a26:	0f be c0             	movsbl %al,%eax
80100a29:	25 ff 00 00 00       	and    $0xff,%eax
80100a2e:	89 04 24             	mov    %eax,(%esp)
80100a31:	e8 fd fc ff ff       	call   80100733 <consputc>
  for(i = 0; i < n; i++)
80100a36:	ff 45 f4             	incl   -0xc(%ebp)
80100a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a3c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a3f:	7c db                	jl     80100a1c <consolewrite+0x26>
  release(&cons.lock);
80100a41:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100a48:	e8 75 4c 00 00       	call   801056c2 <release>
  ilock(ip);
80100a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a50:	89 04 24             	mov    %eax,(%esp)
80100a53:	e8 ed 0d 00 00       	call   80101845 <ilock>

  return n;
80100a58:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a5b:	c9                   	leave  
80100a5c:	c3                   	ret    

80100a5d <consoleinit>:

void
consoleinit(void)
{
80100a5d:	55                   	push   %ebp
80100a5e:	89 e5                	mov    %esp,%ebp
80100a60:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a63:	c7 44 24 04 53 8f 10 	movl   $0x80108f53,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100a72:	e8 c8 4b 00 00       	call   8010563f <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 5b 8f 10 	movl   $0x80108f5b,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
80100a86:	e8 b4 4b 00 00       	call   8010563f <initlock>

  devsw[CONSOLE].write = consolewrite;
80100a8b:	c7 05 4c f8 10 80 f6 	movl   $0x801009f6,0x8010f84c
80100a92:	09 10 80 
  devsw[CONSOLE].read = consoleread;
80100a95:	c7 05 48 f8 10 80 fc 	movl   $0x801008fc,0x8010f848
80100a9c:	08 10 80 
  cons.locking = 1;
80100a9f:	c7 05 34 c6 10 80 01 	movl   $0x1,0x8010c634
80100aa6:	00 00 00 

  picenable(IRQ_KBD);
80100aa9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ab0:	e8 ec 2f 00 00       	call   80103aa1 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ab5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100abc:	00 
80100abd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ac4:	e8 71 1e 00 00       	call   8010293a <ioapicenable>
}
80100ac9:	c9                   	leave  
80100aca:	c3                   	ret    

80100acb <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100acb:	55                   	push   %ebp
80100acc:	89 e5                	mov    %esp,%ebp
80100ace:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
80100ad7:	89 04 24             	mov    %eax,(%esp)
80100ada:	e8 00 19 00 00       	call   801023df <namei>
80100adf:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100ae2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ae6:	75 0a                	jne    80100af2 <exec+0x27>
    return -1;
80100ae8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100aed:	e9 e3 03 00 00       	jmp    80100ed5 <exec+0x40a>
  ilock(ip);
80100af2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100af5:	89 04 24             	mov    %eax,(%esp)
80100af8:	e8 48 0d 00 00       	call   80101845 <ilock>
  pgdir = 0;
80100afd:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b04:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b0b:	00 
80100b0c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b13:	00 
80100b14:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b21:	89 04 24             	mov    %eax,(%esp)
80100b24:	e8 23 12 00 00       	call   80101d4c <readi>
80100b29:	83 f8 33             	cmp    $0x33,%eax
80100b2c:	0f 86 5d 03 00 00    	jbe    80100e8f <exec+0x3c4>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b32:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b38:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b3d:	0f 85 4f 03 00 00    	jne    80100e92 <exec+0x3c7>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b43:	e8 8e 7a 00 00       	call   801085d6 <setupkvm>
80100b48:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b4b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b4f:	0f 84 40 03 00 00    	je     80100e95 <exec+0x3ca>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b55:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b63:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100b69:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100b6c:	e9 c4 00 00 00       	jmp    80100c35 <exec+0x16a>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100b74:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100b7b:	00 
80100b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b80:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100b86:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b8d:	89 04 24             	mov    %eax,(%esp)
80100b90:	e8 b7 11 00 00       	call   80101d4c <readi>
80100b95:	83 f8 20             	cmp    $0x20,%eax
80100b98:	0f 85 fa 02 00 00    	jne    80100e98 <exec+0x3cd>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b9e:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ba4:	83 f8 01             	cmp    $0x1,%eax
80100ba7:	75 7f                	jne    80100c28 <exec+0x15d>
      continue;
    if(ph.memsz < ph.filesz)
80100ba9:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100baf:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bb5:	39 c2                	cmp    %eax,%edx
80100bb7:	0f 82 de 02 00 00    	jb     80100e9b <exec+0x3d0>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bbd:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bc3:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100bc9:	01 d0                	add    %edx,%eax
80100bcb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100bd9:	89 04 24             	mov    %eax,(%esp)
80100bdc:	e8 bb 7d 00 00       	call   8010899c <allocuvm>
80100be1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100be4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100be8:	0f 84 b0 02 00 00    	je     80100e9e <exec+0x3d3>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100bee:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100bf4:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100bfa:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c00:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c04:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c08:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c0b:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c13:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c16:	89 04 24             	mov    %eax,(%esp)
80100c19:	e8 8f 7c 00 00       	call   801088ad <loaduvm>
80100c1e:	85 c0                	test   %eax,%eax
80100c20:	0f 88 7b 02 00 00    	js     80100ea1 <exec+0x3d6>
80100c26:	eb 01                	jmp    80100c29 <exec+0x15e>
      continue;
80100c28:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c29:	ff 45 ec             	incl   -0x14(%ebp)
80100c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c2f:	83 c0 20             	add    $0x20,%eax
80100c32:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c35:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
80100c3b:	0f b7 c0             	movzwl %ax,%eax
80100c3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c41:	0f 8f 2a ff ff ff    	jg     80100b71 <exec+0xa6>
      goto bad;
  }
  iunlockput(ip);
80100c47:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c4a:	89 04 24             	mov    %eax,(%esp)
80100c4d:	e8 74 0e 00 00       	call   80101ac6 <iunlockput>
  ip = 0;
80100c52:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c5c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100c66:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6c:	05 00 20 00 00       	add    $0x2000,%eax
80100c71:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c78:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c7f:	89 04 24             	mov    %eax,(%esp)
80100c82:	e8 15 7d 00 00       	call   8010899c <allocuvm>
80100c87:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c8a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c8e:	0f 84 10 02 00 00    	je     80100ea4 <exec+0x3d9>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c97:	2d 00 20 00 00       	sub    $0x2000,%eax
80100c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ca0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ca3:	89 04 24             	mov    %eax,(%esp)
80100ca6:	e8 3b 7f 00 00       	call   80108be6 <clearpteu>
  sp = sz;
80100cab:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cae:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cb8:	e9 94 00 00 00       	jmp    80100d51 <exec+0x286>
    if(argc >= MAXARG)
80100cbd:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cc1:	0f 87 e0 01 00 00    	ja     80100ea7 <exec+0x3dc>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd4:	01 d0                	add    %edx,%eax
80100cd6:	8b 00                	mov    (%eax),%eax
80100cd8:	89 04 24             	mov    %eax,(%esp)
80100cdb:	e8 2d 4e 00 00       	call   80105b0d <strlen>
80100ce0:	f7 d0                	not    %eax
80100ce2:	89 c2                	mov    %eax,%edx
80100ce4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ce7:	01 d0                	add    %edx,%eax
80100ce9:	83 e0 fc             	and    $0xfffffffc,%eax
80100cec:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100cf2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfc:	01 d0                	add    %edx,%eax
80100cfe:	8b 00                	mov    (%eax),%eax
80100d00:	89 04 24             	mov    %eax,(%esp)
80100d03:	e8 05 4e 00 00       	call   80105b0d <strlen>
80100d08:	40                   	inc    %eax
80100d09:	89 c2                	mov    %eax,%edx
80100d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d0e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d15:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d18:	01 c8                	add    %ecx,%eax
80100d1a:	8b 00                	mov    (%eax),%eax
80100d1c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d20:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d24:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d27:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d2e:	89 04 24             	mov    %eax,(%esp)
80100d31:	e8 bb 80 00 00       	call   80108df1 <copyout>
80100d36:	85 c0                	test   %eax,%eax
80100d38:	0f 88 6c 01 00 00    	js     80100eaa <exec+0x3df>
      goto bad;
    ustack[3+argc] = sp;
80100d3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d41:	8d 50 03             	lea    0x3(%eax),%edx
80100d44:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d47:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100d4e:	ff 45 e4             	incl   -0x1c(%ebp)
80100d51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d5e:	01 d0                	add    %edx,%eax
80100d60:	8b 00                	mov    (%eax),%eax
80100d62:	85 c0                	test   %eax,%eax
80100d64:	0f 85 53 ff ff ff    	jne    80100cbd <exec+0x1f2>
  }
  ustack[3+argc] = 0;
80100d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d6d:	83 c0 03             	add    $0x3,%eax
80100d70:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100d77:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d7b:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100d82:	ff ff ff 
  ustack[1] = argc;
80100d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d88:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d91:	40                   	inc    %eax
80100d92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d99:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d9c:	29 d0                	sub    %edx,%eax
80100d9e:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da7:	83 c0 04             	add    $0x4,%eax
80100daa:	c1 e0 02             	shl    $0x2,%eax
80100dad:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100db0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db3:	83 c0 04             	add    $0x4,%eax
80100db6:	c1 e0 02             	shl    $0x2,%eax
80100db9:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100dbd:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100dc3:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dc7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dca:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100dd1:	89 04 24             	mov    %eax,(%esp)
80100dd4:	e8 18 80 00 00       	call   80108df1 <copyout>
80100dd9:	85 c0                	test   %eax,%eax
80100ddb:	0f 88 cc 00 00 00    	js     80100ead <exec+0x3e2>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100de1:	8b 45 08             	mov    0x8(%ebp),%eax
80100de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100dea:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ded:	eb 13                	jmp    80100e02 <exec+0x337>
    if(*s == '/')
80100def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100df2:	8a 00                	mov    (%eax),%al
80100df4:	3c 2f                	cmp    $0x2f,%al
80100df6:	75 07                	jne    80100dff <exec+0x334>
      last = s+1;
80100df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100dfb:	40                   	inc    %eax
80100dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100dff:	ff 45 f4             	incl   -0xc(%ebp)
80100e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e05:	8a 00                	mov    (%eax),%al
80100e07:	84 c0                	test   %al,%al
80100e09:	75 e4                	jne    80100def <exec+0x324>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e11:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e14:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e1b:	00 
80100e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e23:	89 14 24             	mov    %edx,(%esp)
80100e26:	e8 99 4c 00 00       	call   80105ac4 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e31:	8b 40 04             	mov    0x4(%eax),%eax
80100e34:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e3d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e40:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e49:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e4c:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e54:	8b 40 18             	mov    0x18(%eax),%eax
80100e57:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e5d:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e60:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e66:	8b 40 18             	mov    0x18(%eax),%eax
80100e69:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e6c:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e75:	89 04 24             	mov    %eax,(%esp)
80100e78:	e8 4a 78 00 00       	call   801086c7 <switchuvm>
  freevm(oldpgdir);
80100e7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e80:	89 04 24             	mov    %eax,(%esp)
80100e83:	e8 c5 7c 00 00       	call   80108b4d <freevm>
  return 0;
80100e88:	b8 00 00 00 00       	mov    $0x0,%eax
80100e8d:	eb 46                	jmp    80100ed5 <exec+0x40a>
    goto bad;
80100e8f:	90                   	nop
80100e90:	eb 1c                	jmp    80100eae <exec+0x3e3>
    goto bad;
80100e92:	90                   	nop
80100e93:	eb 19                	jmp    80100eae <exec+0x3e3>
    goto bad;
80100e95:	90                   	nop
80100e96:	eb 16                	jmp    80100eae <exec+0x3e3>
      goto bad;
80100e98:	90                   	nop
80100e99:	eb 13                	jmp    80100eae <exec+0x3e3>
      goto bad;
80100e9b:	90                   	nop
80100e9c:	eb 10                	jmp    80100eae <exec+0x3e3>
      goto bad;
80100e9e:	90                   	nop
80100e9f:	eb 0d                	jmp    80100eae <exec+0x3e3>
      goto bad;
80100ea1:	90                   	nop
80100ea2:	eb 0a                	jmp    80100eae <exec+0x3e3>
    goto bad;
80100ea4:	90                   	nop
80100ea5:	eb 07                	jmp    80100eae <exec+0x3e3>
      goto bad;
80100ea7:	90                   	nop
80100ea8:	eb 04                	jmp    80100eae <exec+0x3e3>
      goto bad;
80100eaa:	90                   	nop
80100eab:	eb 01                	jmp    80100eae <exec+0x3e3>
    goto bad;
80100ead:	90                   	nop

 bad:
  if(pgdir)
80100eae:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100eb2:	74 0b                	je     80100ebf <exec+0x3f4>
    freevm(pgdir);
80100eb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100eb7:	89 04 24             	mov    %eax,(%esp)
80100eba:	e8 8e 7c 00 00       	call   80108b4d <freevm>
  if(ip)
80100ebf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100ec3:	74 0b                	je     80100ed0 <exec+0x405>
    iunlockput(ip);
80100ec5:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 f6 0b 00 00       	call   80101ac6 <iunlockput>
  return -1;
80100ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ed5:	c9                   	leave  
80100ed6:	c3                   	ret    

80100ed7 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ed7:	55                   	push   %ebp
80100ed8:	89 e5                	mov    %esp,%ebp
80100eda:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100edd:	c7 44 24 04 61 8f 10 	movl   $0x80108f61,0x4(%esp)
80100ee4:	80 
80100ee5:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100eec:	e8 4e 47 00 00       	call   8010563f <initlock>
}
80100ef1:	c9                   	leave  
80100ef2:	c3                   	ret    

80100ef3 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ef3:	55                   	push   %ebp
80100ef4:	89 e5                	mov    %esp,%ebp
80100ef6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100ef9:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f00:	e8 5b 47 00 00       	call   80105660 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f05:	c7 45 f4 d4 ee 10 80 	movl   $0x8010eed4,-0xc(%ebp)
80100f0c:	eb 29                	jmp    80100f37 <filealloc+0x44>
    if(f->ref == 0){
80100f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f11:	8b 40 04             	mov    0x4(%eax),%eax
80100f14:	85 c0                	test   %eax,%eax
80100f16:	75 1b                	jne    80100f33 <filealloc+0x40>
      f->ref = 1;
80100f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f1b:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f22:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f29:	e8 94 47 00 00       	call   801056c2 <release>
      return f;
80100f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f31:	eb 1e                	jmp    80100f51 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f33:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f37:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
80100f3e:	72 ce                	jb     80100f0e <filealloc+0x1b>
    }
  }
  release(&ftable.lock);
80100f40:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f47:	e8 76 47 00 00       	call   801056c2 <release>
  return 0;
80100f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f51:	c9                   	leave  
80100f52:	c3                   	ret    

80100f53 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f53:	55                   	push   %ebp
80100f54:	89 e5                	mov    %esp,%ebp
80100f56:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f59:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f60:	e8 fb 46 00 00       	call   80105660 <acquire>
  if(f->ref < 1)
80100f65:	8b 45 08             	mov    0x8(%ebp),%eax
80100f68:	8b 40 04             	mov    0x4(%eax),%eax
80100f6b:	85 c0                	test   %eax,%eax
80100f6d:	7f 0c                	jg     80100f7b <filedup+0x28>
    panic("filedup");
80100f6f:	c7 04 24 68 8f 10 80 	movl   $0x80108f68,(%esp)
80100f76:	e8 bb f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	8d 50 01             	lea    0x1(%eax),%edx
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100f8a:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f91:	e8 2c 47 00 00       	call   801056c2 <release>
  return f;
80100f96:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100f99:	c9                   	leave  
80100f9a:	c3                   	ret    

80100f9b <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f9b:	55                   	push   %ebp
80100f9c:	89 e5                	mov    %esp,%ebp
80100f9e:	57                   	push   %edi
80100f9f:	56                   	push   %esi
80100fa0:	53                   	push   %ebx
80100fa1:	83 ec 3c             	sub    $0x3c,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fa4:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fab:	e8 b0 46 00 00       	call   80105660 <acquire>
  if(f->ref < 1)
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	7f 0c                	jg     80100fc6 <fileclose+0x2b>
    panic("fileclose");
80100fba:	c7 04 24 70 8f 10 80 	movl   $0x80108f70,(%esp)
80100fc1:	e8 70 f5 ff ff       	call   80100536 <panic>
  if(--f->ref > 0){
80100fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fc9:	8b 40 04             	mov    0x4(%eax),%eax
80100fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
80100fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd2:	89 50 04             	mov    %edx,0x4(%eax)
80100fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd8:	8b 40 04             	mov    0x4(%eax),%eax
80100fdb:	85 c0                	test   %eax,%eax
80100fdd:	7e 0e                	jle    80100fed <fileclose+0x52>
    release(&ftable.lock);
80100fdf:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100fe6:	e8 d7 46 00 00       	call   801056c2 <release>
80100feb:	eb 70                	jmp    8010105d <fileclose+0xc2>
    return;
  }
  ff = *f;
80100fed:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff0:	8d 55 d0             	lea    -0x30(%ebp),%edx
80100ff3:	89 c3                	mov    %eax,%ebx
80100ff5:	b8 06 00 00 00       	mov    $0x6,%eax
80100ffa:	89 d7                	mov    %edx,%edi
80100ffc:	89 de                	mov    %ebx,%esi
80100ffe:	89 c1                	mov    %eax,%ecx
80101000:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80101002:	8b 45 08             	mov    0x8(%ebp),%eax
80101005:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010100c:	8b 45 08             	mov    0x8(%ebp),%eax
8010100f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101015:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
8010101c:	e8 a1 46 00 00       	call   801056c2 <release>
  
  if(ff.type == FD_PIPE)
80101021:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101024:	83 f8 01             	cmp    $0x1,%eax
80101027:	75 17                	jne    80101040 <fileclose+0xa5>
    pipeclose(ff.pipe, ff.writable);
80101029:	8a 45 d9             	mov    -0x27(%ebp),%al
8010102c:	0f be d0             	movsbl %al,%edx
8010102f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101032:	89 54 24 04          	mov    %edx,0x4(%esp)
80101036:	89 04 24             	mov    %eax,(%esp)
80101039:	e8 17 2d 00 00       	call   80103d55 <pipeclose>
8010103e:	eb 1d                	jmp    8010105d <fileclose+0xc2>
  else if(ff.type == FD_INODE){
80101040:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101043:	83 f8 02             	cmp    $0x2,%eax
80101046:	75 15                	jne    8010105d <fileclose+0xc2>
    begin_trans();
80101048:	e8 83 21 00 00       	call   801031d0 <begin_trans>
    iput(ff.ip);
8010104d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101050:	89 04 24             	mov    %eax,(%esp)
80101053:	e8 9d 09 00 00       	call   801019f5 <iput>
    commit_trans();
80101058:	e8 bc 21 00 00       	call   80103219 <commit_trans>
  }
}
8010105d:	83 c4 3c             	add    $0x3c,%esp
80101060:	5b                   	pop    %ebx
80101061:	5e                   	pop    %esi
80101062:	5f                   	pop    %edi
80101063:	5d                   	pop    %ebp
80101064:	c3                   	ret    

80101065 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101065:	55                   	push   %ebp
80101066:	89 e5                	mov    %esp,%ebp
80101068:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
8010106b:	8b 45 08             	mov    0x8(%ebp),%eax
8010106e:	8b 00                	mov    (%eax),%eax
80101070:	83 f8 02             	cmp    $0x2,%eax
80101073:	75 38                	jne    801010ad <filestat+0x48>
    ilock(f->ip);
80101075:	8b 45 08             	mov    0x8(%ebp),%eax
80101078:	8b 40 10             	mov    0x10(%eax),%eax
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 c2 07 00 00       	call   80101845 <ilock>
    stati(f->ip, st);
80101083:	8b 45 08             	mov    0x8(%ebp),%eax
80101086:	8b 40 10             	mov    0x10(%eax),%eax
80101089:	8b 55 0c             	mov    0xc(%ebp),%edx
8010108c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101090:	89 04 24             	mov    %eax,(%esp)
80101093:	e8 70 0c 00 00       	call   80101d08 <stati>
    iunlock(f->ip);
80101098:	8b 45 08             	mov    0x8(%ebp),%eax
8010109b:	8b 40 10             	mov    0x10(%eax),%eax
8010109e:	89 04 24             	mov    %eax,(%esp)
801010a1:	e8 ea 08 00 00       	call   80101990 <iunlock>
    return 0;
801010a6:	b8 00 00 00 00       	mov    $0x0,%eax
801010ab:	eb 05                	jmp    801010b2 <filestat+0x4d>
  }
  return -1;
801010ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b2:	c9                   	leave  
801010b3:	c3                   	ret    

801010b4 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010b4:	55                   	push   %ebp
801010b5:	89 e5                	mov    %esp,%ebp
801010b7:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	8a 40 08             	mov    0x8(%eax),%al
801010c0:	84 c0                	test   %al,%al
801010c2:	75 0a                	jne    801010ce <fileread+0x1a>
    return -1;
801010c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010c9:	e9 9f 00 00 00       	jmp    8010116d <fileread+0xb9>
  if(f->type == FD_PIPE)
801010ce:	8b 45 08             	mov    0x8(%ebp),%eax
801010d1:	8b 00                	mov    (%eax),%eax
801010d3:	83 f8 01             	cmp    $0x1,%eax
801010d6:	75 1e                	jne    801010f6 <fileread+0x42>
    return piperead(f->pipe, addr, n);
801010d8:	8b 45 08             	mov    0x8(%ebp),%eax
801010db:	8b 40 0c             	mov    0xc(%eax),%eax
801010de:	8b 55 10             	mov    0x10(%ebp),%edx
801010e1:	89 54 24 08          	mov    %edx,0x8(%esp)
801010e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801010e8:	89 54 24 04          	mov    %edx,0x4(%esp)
801010ec:	89 04 24             	mov    %eax,(%esp)
801010ef:	e8 e3 2d 00 00       	call   80103ed7 <piperead>
801010f4:	eb 77                	jmp    8010116d <fileread+0xb9>
  if(f->type == FD_INODE){
801010f6:	8b 45 08             	mov    0x8(%ebp),%eax
801010f9:	8b 00                	mov    (%eax),%eax
801010fb:	83 f8 02             	cmp    $0x2,%eax
801010fe:	75 61                	jne    80101161 <fileread+0xad>
    ilock(f->ip);
80101100:	8b 45 08             	mov    0x8(%ebp),%eax
80101103:	8b 40 10             	mov    0x10(%eax),%eax
80101106:	89 04 24             	mov    %eax,(%esp)
80101109:	e8 37 07 00 00       	call   80101845 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010110e:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101111:	8b 45 08             	mov    0x8(%ebp),%eax
80101114:	8b 50 14             	mov    0x14(%eax),%edx
80101117:	8b 45 08             	mov    0x8(%ebp),%eax
8010111a:	8b 40 10             	mov    0x10(%eax),%eax
8010111d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101121:	89 54 24 08          	mov    %edx,0x8(%esp)
80101125:	8b 55 0c             	mov    0xc(%ebp),%edx
80101128:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112c:	89 04 24             	mov    %eax,(%esp)
8010112f:	e8 18 0c 00 00       	call   80101d4c <readi>
80101134:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010113b:	7e 11                	jle    8010114e <fileread+0x9a>
      f->off += r;
8010113d:	8b 45 08             	mov    0x8(%ebp),%eax
80101140:	8b 50 14             	mov    0x14(%eax),%edx
80101143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101146:	01 c2                	add    %eax,%edx
80101148:	8b 45 08             	mov    0x8(%ebp),%eax
8010114b:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010114e:	8b 45 08             	mov    0x8(%ebp),%eax
80101151:	8b 40 10             	mov    0x10(%eax),%eax
80101154:	89 04 24             	mov    %eax,(%esp)
80101157:	e8 34 08 00 00       	call   80101990 <iunlock>
    return r;
8010115c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010115f:	eb 0c                	jmp    8010116d <fileread+0xb9>
  }
  panic("fileread");
80101161:	c7 04 24 7a 8f 10 80 	movl   $0x80108f7a,(%esp)
80101168:	e8 c9 f3 ff ff       	call   80100536 <panic>
}
8010116d:	c9                   	leave  
8010116e:	c3                   	ret    

8010116f <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010116f:	55                   	push   %ebp
80101170:	89 e5                	mov    %esp,%ebp
80101172:	53                   	push   %ebx
80101173:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101176:	8b 45 08             	mov    0x8(%ebp),%eax
80101179:	8a 40 09             	mov    0x9(%eax),%al
8010117c:	84 c0                	test   %al,%al
8010117e:	75 0a                	jne    8010118a <filewrite+0x1b>
    return -1;
80101180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101185:	e9 23 01 00 00       	jmp    801012ad <filewrite+0x13e>
  if(f->type == FD_PIPE)
8010118a:	8b 45 08             	mov    0x8(%ebp),%eax
8010118d:	8b 00                	mov    (%eax),%eax
8010118f:	83 f8 01             	cmp    $0x1,%eax
80101192:	75 21                	jne    801011b5 <filewrite+0x46>
    return pipewrite(f->pipe, addr, n);
80101194:	8b 45 08             	mov    0x8(%ebp),%eax
80101197:	8b 40 0c             	mov    0xc(%eax),%eax
8010119a:	8b 55 10             	mov    0x10(%ebp),%edx
8010119d:	89 54 24 08          	mov    %edx,0x8(%esp)
801011a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801011a4:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a8:	89 04 24             	mov    %eax,(%esp)
801011ab:	e8 37 2c 00 00       	call   80103de7 <pipewrite>
801011b0:	e9 f8 00 00 00       	jmp    801012ad <filewrite+0x13e>
  if(f->type == FD_INODE){
801011b5:	8b 45 08             	mov    0x8(%ebp),%eax
801011b8:	8b 00                	mov    (%eax),%eax
801011ba:	83 f8 02             	cmp    $0x2,%eax
801011bd:	0f 85 de 00 00 00    	jne    801012a1 <filewrite+0x132>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011c3:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
801011ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801011d1:	e9 a8 00 00 00       	jmp    8010127e <filewrite+0x10f>
      int n1 = n - i;
801011d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d9:	8b 55 10             	mov    0x10(%ebp),%edx
801011dc:	89 d1                	mov    %edx,%ecx
801011de:	29 c1                	sub    %eax,%ecx
801011e0:	89 c8                	mov    %ecx,%eax
801011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801011e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011e8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801011eb:	7e 06                	jle    801011f3 <filewrite+0x84>
        n1 = max;
801011ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011f0:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
801011f3:	e8 d8 1f 00 00       	call   801031d0 <begin_trans>
      ilock(f->ip);
801011f8:	8b 45 08             	mov    0x8(%ebp),%eax
801011fb:	8b 40 10             	mov    0x10(%eax),%eax
801011fe:	89 04 24             	mov    %eax,(%esp)
80101201:	e8 3f 06 00 00       	call   80101845 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101206:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101209:	8b 45 08             	mov    0x8(%ebp),%eax
8010120c:	8b 50 14             	mov    0x14(%eax),%edx
8010120f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101212:	8b 45 0c             	mov    0xc(%ebp),%eax
80101215:	01 c3                	add    %eax,%ebx
80101217:	8b 45 08             	mov    0x8(%ebp),%eax
8010121a:	8b 40 10             	mov    0x10(%eax),%eax
8010121d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101221:	89 54 24 08          	mov    %edx,0x8(%esp)
80101225:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101229:	89 04 24             	mov    %eax,(%esp)
8010122c:	e8 80 0c 00 00       	call   80101eb1 <writei>
80101231:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101234:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101238:	7e 11                	jle    8010124b <filewrite+0xdc>
        f->off += r;
8010123a:	8b 45 08             	mov    0x8(%ebp),%eax
8010123d:	8b 50 14             	mov    0x14(%eax),%edx
80101240:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101243:	01 c2                	add    %eax,%edx
80101245:	8b 45 08             	mov    0x8(%ebp),%eax
80101248:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
8010124b:	8b 45 08             	mov    0x8(%ebp),%eax
8010124e:	8b 40 10             	mov    0x10(%eax),%eax
80101251:	89 04 24             	mov    %eax,(%esp)
80101254:	e8 37 07 00 00       	call   80101990 <iunlock>
      commit_trans();
80101259:	e8 bb 1f 00 00       	call   80103219 <commit_trans>

      if(r < 0)
8010125e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101262:	78 28                	js     8010128c <filewrite+0x11d>
        break;
      if(r != n1)
80101264:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101267:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010126a:	74 0c                	je     80101278 <filewrite+0x109>
        panic("short filewrite");
8010126c:	c7 04 24 83 8f 10 80 	movl   $0x80108f83,(%esp)
80101273:	e8 be f2 ff ff       	call   80100536 <panic>
      i += r;
80101278:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010127b:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010127e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101281:	3b 45 10             	cmp    0x10(%ebp),%eax
80101284:	0f 8c 4c ff ff ff    	jl     801011d6 <filewrite+0x67>
8010128a:	eb 01                	jmp    8010128d <filewrite+0x11e>
        break;
8010128c:	90                   	nop
    }
    return i == n ? n : -1;
8010128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101290:	3b 45 10             	cmp    0x10(%ebp),%eax
80101293:	75 05                	jne    8010129a <filewrite+0x12b>
80101295:	8b 45 10             	mov    0x10(%ebp),%eax
80101298:	eb 05                	jmp    8010129f <filewrite+0x130>
8010129a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010129f:	eb 0c                	jmp    801012ad <filewrite+0x13e>
  }
  panic("filewrite");
801012a1:	c7 04 24 93 8f 10 80 	movl   $0x80108f93,(%esp)
801012a8:	e8 89 f2 ff ff       	call   80100536 <panic>
}
801012ad:	83 c4 24             	add    $0x24,%esp
801012b0:	5b                   	pop    %ebx
801012b1:	5d                   	pop    %ebp
801012b2:	c3                   	ret    

801012b3 <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012b3:	55                   	push   %ebp
801012b4:	89 e5                	mov    %esp,%ebp
801012b6:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012b9:	8b 45 08             	mov    0x8(%ebp),%eax
801012bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012c3:	00 
801012c4:	89 04 24             	mov    %eax,(%esp)
801012c7:	e8 da ee ff ff       	call   801001a6 <bread>
801012cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801012cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012d2:	83 c0 18             	add    $0x18,%eax
801012d5:	c7 44 24 08 70 00 00 	movl   $0x70,0x8(%esp)
801012dc:	00 
801012dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801012e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801012e4:	89 04 24             	mov    %eax,(%esp)
801012e7:	e8 92 46 00 00       	call   8010597e <memmove>
  brelse(bp);
801012ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012ef:	89 04 24             	mov    %eax,(%esp)
801012f2:	e8 20 ef ff ff       	call   80100217 <brelse>
}
801012f7:	c9                   	leave  
801012f8:	c3                   	ret    

801012f9 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801012f9:	55                   	push   %ebp
801012fa:	89 e5                	mov    %esp,%ebp
801012fc:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801012ff:	8b 55 0c             	mov    0xc(%ebp),%edx
80101302:	8b 45 08             	mov    0x8(%ebp),%eax
80101305:	89 54 24 04          	mov    %edx,0x4(%esp)
80101309:	89 04 24             	mov    %eax,(%esp)
8010130c:	e8 95 ee ff ff       	call   801001a6 <bread>
80101311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101317:	83 c0 18             	add    $0x18,%eax
8010131a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101321:	00 
80101322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101329:	00 
8010132a:	89 04 24             	mov    %eax,(%esp)
8010132d:	e8 80 45 00 00       	call   801058b2 <memset>
  log_write(bp);
80101332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101335:	89 04 24             	mov    %eax,(%esp)
80101338:	e8 34 1f 00 00       	call   80103271 <log_write>
  brelse(bp);
8010133d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101340:	89 04 24             	mov    %eax,(%esp)
80101343:	e8 cf ee ff ff       	call   80100217 <brelse>
}
80101348:	c9                   	leave  
80101349:	c3                   	ret    

8010134a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010134a:	55                   	push   %ebp
8010134b:	89 e5                	mov    %esp,%ebp
8010134d:	53                   	push   %ebx
8010134e:	81 ec 94 00 00 00    	sub    $0x94,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
80101354:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
8010135b:	8b 45 08             	mov    0x8(%ebp),%eax
8010135e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
80101364:	89 54 24 04          	mov    %edx,0x4(%esp)
80101368:	89 04 24             	mov    %eax,(%esp)
8010136b:	e8 43 ff ff ff       	call   801012b3 <readsb>
  for(b = 0; b < sb.size; b += BPB){
80101370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101377:	e9 08 01 00 00       	jmp    80101484 <balloc+0x13a>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
8010137c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137f:	85 c0                	test   %eax,%eax
80101381:	79 05                	jns    80101388 <balloc+0x3e>
80101383:	05 ff 0f 00 00       	add    $0xfff,%eax
80101388:	c1 f8 0c             	sar    $0xc,%eax
8010138b:	8b 55 80             	mov    -0x80(%ebp),%edx
8010138e:	c1 ea 02             	shr    $0x2,%edx
80101391:	01 d0                	add    %edx,%eax
80101393:	83 c0 03             	add    $0x3,%eax
80101396:	89 44 24 04          	mov    %eax,0x4(%esp)
8010139a:	8b 45 08             	mov    0x8(%ebp),%eax
8010139d:	89 04 24             	mov    %eax,(%esp)
801013a0:	e8 01 ee ff ff       	call   801001a6 <bread>
801013a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013af:	e9 9d 00 00 00       	jmp    80101451 <balloc+0x107>
      m = 1 << (bi % 8);
801013b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013b7:	25 07 00 00 80       	and    $0x80000007,%eax
801013bc:	85 c0                	test   %eax,%eax
801013be:	79 05                	jns    801013c5 <balloc+0x7b>
801013c0:	48                   	dec    %eax
801013c1:	83 c8 f8             	or     $0xfffffff8,%eax
801013c4:	40                   	inc    %eax
801013c5:	ba 01 00 00 00       	mov    $0x1,%edx
801013ca:	89 d3                	mov    %edx,%ebx
801013cc:	88 c1                	mov    %al,%cl
801013ce:	d3 e3                	shl    %cl,%ebx
801013d0:	89 d8                	mov    %ebx,%eax
801013d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013d8:	85 c0                	test   %eax,%eax
801013da:	79 03                	jns    801013df <balloc+0x95>
801013dc:	83 c0 07             	add    $0x7,%eax
801013df:	c1 f8 03             	sar    $0x3,%eax
801013e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801013e5:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
801013e9:	0f b6 c0             	movzbl %al,%eax
801013ec:	23 45 e8             	and    -0x18(%ebp),%eax
801013ef:	85 c0                	test   %eax,%eax
801013f1:	75 5b                	jne    8010144e <balloc+0x104>
        bp->data[bi/8] |= m;  // Mark block in use.
801013f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013f6:	85 c0                	test   %eax,%eax
801013f8:	79 03                	jns    801013fd <balloc+0xb3>
801013fa:	83 c0 07             	add    $0x7,%eax
801013fd:	c1 f8 03             	sar    $0x3,%eax
80101400:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101403:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101407:	88 d1                	mov    %dl,%cl
80101409:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010140c:	09 ca                	or     %ecx,%edx
8010140e:	88 d1                	mov    %dl,%cl
80101410:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101413:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101417:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010141a:	89 04 24             	mov    %eax,(%esp)
8010141d:	e8 4f 1e 00 00       	call   80103271 <log_write>
        brelse(bp);
80101422:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101425:	89 04 24             	mov    %eax,(%esp)
80101428:	e8 ea ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
8010142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101430:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101433:	01 c2                	add    %eax,%edx
80101435:	8b 45 08             	mov    0x8(%ebp),%eax
80101438:	89 54 24 04          	mov    %edx,0x4(%esp)
8010143c:	89 04 24             	mov    %eax,(%esp)
8010143f:	e8 b5 fe ff ff       	call   801012f9 <bzero>
        return b + bi;
80101444:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101447:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010144a:	01 d0                	add    %edx,%eax
8010144c:	eb 53                	jmp    801014a1 <balloc+0x157>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010144e:	ff 45 f0             	incl   -0x10(%ebp)
80101451:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101458:	7f 18                	jg     80101472 <balloc+0x128>
8010145a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010145d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101460:	01 d0                	add    %edx,%eax
80101462:	89 c2                	mov    %eax,%edx
80101464:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
8010146a:	39 c2                	cmp    %eax,%edx
8010146c:	0f 82 42 ff ff ff    	jb     801013b4 <balloc+0x6a>
      }
    }
    brelse(bp);
80101472:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101475:	89 04 24             	mov    %eax,(%esp)
80101478:	e8 9a ed ff ff       	call   80100217 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010147d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101484:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101487:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
8010148d:	39 c2                	cmp    %eax,%edx
8010148f:	0f 82 e7 fe ff ff    	jb     8010137c <balloc+0x32>
  }
  panic("balloc: out of blocks");
80101495:	c7 04 24 9d 8f 10 80 	movl   $0x80108f9d,(%esp)
8010149c:	e8 95 f0 ff ff       	call   80100536 <panic>
}
801014a1:	81 c4 94 00 00 00    	add    $0x94,%esp
801014a7:	5b                   	pop    %ebx
801014a8:	5d                   	pop    %ebp
801014a9:	c3                   	ret    

801014aa <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014aa:	55                   	push   %ebp
801014ab:	89 e5                	mov    %esp,%ebp
801014ad:	53                   	push   %ebx
801014ae:	81 ec 94 00 00 00    	sub    $0x94,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014b4:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
801014ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	89 04 24             	mov    %eax,(%esp)
801014c4:	e8 ea fd ff ff       	call   801012b3 <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801014cc:	89 c2                	mov    %eax,%edx
801014ce:	c1 ea 0c             	shr    $0xc,%edx
801014d1:	8b 45 84             	mov    -0x7c(%ebp),%eax
801014d4:	c1 e8 02             	shr    $0x2,%eax
801014d7:	01 d0                	add    %edx,%eax
801014d9:	8d 50 03             	lea    0x3(%eax),%edx
801014dc:	8b 45 08             	mov    0x8(%ebp),%eax
801014df:	89 54 24 04          	mov    %edx,0x4(%esp)
801014e3:	89 04 24             	mov    %eax,(%esp)
801014e6:	e8 bb ec ff ff       	call   801001a6 <bread>
801014eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801014ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f1:	25 ff 0f 00 00       	and    $0xfff,%eax
801014f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014fc:	25 07 00 00 80       	and    $0x80000007,%eax
80101501:	85 c0                	test   %eax,%eax
80101503:	79 05                	jns    8010150a <bfree+0x60>
80101505:	48                   	dec    %eax
80101506:	83 c8 f8             	or     $0xfffffff8,%eax
80101509:	40                   	inc    %eax
8010150a:	ba 01 00 00 00       	mov    $0x1,%edx
8010150f:	89 d3                	mov    %edx,%ebx
80101511:	88 c1                	mov    %al,%cl
80101513:	d3 e3                	shl    %cl,%ebx
80101515:	89 d8                	mov    %ebx,%eax
80101517:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
8010151a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151d:	85 c0                	test   %eax,%eax
8010151f:	79 03                	jns    80101524 <bfree+0x7a>
80101521:	83 c0 07             	add    $0x7,%eax
80101524:	c1 f8 03             	sar    $0x3,%eax
80101527:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010152a:	8a 44 02 18          	mov    0x18(%edx,%eax,1),%al
8010152e:	0f b6 c0             	movzbl %al,%eax
80101531:	23 45 ec             	and    -0x14(%ebp),%eax
80101534:	85 c0                	test   %eax,%eax
80101536:	75 0c                	jne    80101544 <bfree+0x9a>
    panic("freeing free block");
80101538:	c7 04 24 b3 8f 10 80 	movl   $0x80108fb3,(%esp)
8010153f:	e8 f2 ef ff ff       	call   80100536 <panic>
  bp->data[bi/8] &= ~m;
80101544:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101547:	85 c0                	test   %eax,%eax
80101549:	79 03                	jns    8010154e <bfree+0xa4>
8010154b:	83 c0 07             	add    $0x7,%eax
8010154e:	c1 f8 03             	sar    $0x3,%eax
80101551:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101554:	8a 54 02 18          	mov    0x18(%edx,%eax,1),%dl
80101558:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010155b:	f7 d1                	not    %ecx
8010155d:	21 ca                	and    %ecx,%edx
8010155f:	88 d1                	mov    %dl,%cl
80101561:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101564:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101568:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010156b:	89 04 24             	mov    %eax,(%esp)
8010156e:	e8 fe 1c 00 00       	call   80103271 <log_write>
  brelse(bp);
80101573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101576:	89 04 24             	mov    %eax,(%esp)
80101579:	e8 99 ec ff ff       	call   80100217 <brelse>
}
8010157e:	81 c4 94 00 00 00    	add    $0x94,%esp
80101584:	5b                   	pop    %ebx
80101585:	5d                   	pop    %ebp
80101586:	c3                   	ret    

80101587 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
80101587:	55                   	push   %ebp
80101588:	89 e5                	mov    %esp,%ebp
8010158a:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
8010158d:	c7 44 24 04 c6 8f 10 	movl   $0x80108fc6,0x4(%esp)
80101594:	80 
80101595:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010159c:	e8 9e 40 00 00       	call   8010563f <initlock>
}
801015a1:	c9                   	leave  
801015a2:	c3                   	ret    

801015a3 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015a3:	55                   	push   %ebp
801015a4:	89 e5                	mov    %esp,%ebp
801015a6:	81 ec a8 00 00 00    	sub    $0xa8,%esp
801015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801015af:	66 89 85 74 ff ff ff 	mov    %ax,-0x8c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015b6:	8b 45 08             	mov    0x8(%ebp),%eax
801015b9:	8d 95 7c ff ff ff    	lea    -0x84(%ebp),%edx
801015bf:	89 54 24 04          	mov    %edx,0x4(%esp)
801015c3:	89 04 24             	mov    %eax,(%esp)
801015c6:	e8 e8 fc ff ff       	call   801012b3 <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015d2:	e9 98 00 00 00       	jmp    8010166f <ialloc+0xcc>
    bp = bread(dev, IBLOCK(inum));
801015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015da:	c1 e8 02             	shr    $0x2,%eax
801015dd:	83 c0 02             	add    $0x2,%eax
801015e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801015e4:	8b 45 08             	mov    0x8(%ebp),%eax
801015e7:	89 04 24             	mov    %eax,(%esp)
801015ea:	e8 b7 eb ff ff       	call   801001a6 <bread>
801015ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015f5:	8d 50 18             	lea    0x18(%eax),%edx
801015f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fb:	83 e0 03             	and    $0x3,%eax
801015fe:	c1 e0 07             	shl    $0x7,%eax
80101601:	01 d0                	add    %edx,%eax
80101603:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101606:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101609:	8b 00                	mov    (%eax),%eax
8010160b:	66 85 c0             	test   %ax,%ax
8010160e:	75 51                	jne    80101661 <ialloc+0xbe>
      memset(dip, 0, sizeof(*dip));
80101610:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80101617:	00 
80101618:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010161f:	00 
80101620:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101623:	89 04 24             	mov    %eax,(%esp)
80101626:	e8 87 42 00 00       	call   801058b2 <memset>
      dip->type = type;
8010162b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010162e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
80101634:	66 89 02             	mov    %ax,(%edx)
      log_write(bp);   // mark it allocated on the disk
80101637:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010163a:	89 04 24             	mov    %eax,(%esp)
8010163d:	e8 2f 1c 00 00       	call   80103271 <log_write>
      brelse(bp);
80101642:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101645:	89 04 24             	mov    %eax,(%esp)
80101648:	e8 ca eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101650:	89 44 24 04          	mov    %eax,0x4(%esp)
80101654:	8b 45 08             	mov    0x8(%ebp),%eax
80101657:	89 04 24             	mov    %eax,(%esp)
8010165a:	e8 e2 00 00 00       	call   80101741 <iget>
8010165f:	eb 28                	jmp    80101689 <ialloc+0xe6>
    }
    brelse(bp);
80101661:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101664:	89 04 24             	mov    %eax,(%esp)
80101667:	e8 ab eb ff ff       	call   80100217 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	ff 45 f4             	incl   -0xc(%ebp)
8010166f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101672:	8b 45 84             	mov    -0x7c(%ebp),%eax
80101675:	39 c2                	cmp    %eax,%edx
80101677:	0f 82 5a ff ff ff    	jb     801015d7 <ialloc+0x34>
  }
  panic("ialloc: no inodes");
8010167d:	c7 04 24 cd 8f 10 80 	movl   $0x80108fcd,(%esp)
80101684:	e8 ad ee ff ff       	call   80100536 <panic>
}
80101689:	c9                   	leave  
8010168a:	c3                   	ret    

8010168b <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010168b:	55                   	push   %ebp
8010168c:	89 e5                	mov    %esp,%ebp
8010168e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
80101691:	8b 45 08             	mov    0x8(%ebp),%eax
80101694:	8b 40 04             	mov    0x4(%eax),%eax
80101697:	c1 e8 02             	shr    $0x2,%eax
8010169a:	8d 50 02             	lea    0x2(%eax),%edx
8010169d:	8b 45 08             	mov    0x8(%ebp),%eax
801016a0:	8b 00                	mov    (%eax),%eax
801016a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801016a6:	89 04 24             	mov    %eax,(%esp)
801016a9:	e8 f8 ea ff ff       	call   801001a6 <bread>
801016ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016b4:	8d 50 18             	lea    0x18(%eax),%edx
801016b7:	8b 45 08             	mov    0x8(%ebp),%eax
801016ba:	8b 40 04             	mov    0x4(%eax),%eax
801016bd:	83 e0 03             	and    $0x3,%eax
801016c0:	c1 e0 07             	shl    $0x7,%eax
801016c3:	01 d0                	add    %edx,%eax
801016c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016c8:	8b 45 08             	mov    0x8(%ebp),%eax
801016cb:	8b 40 10             	mov    0x10(%eax),%eax
801016ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016d1:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801016d4:	8b 45 08             	mov    0x8(%ebp),%eax
801016d7:	66 8b 40 12          	mov    0x12(%eax),%ax
801016db:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016de:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801016e2:	8b 45 08             	mov    0x8(%ebp),%eax
801016e5:	8b 40 14             	mov    0x14(%eax),%eax
801016e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016eb:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801016ef:	8b 45 08             	mov    0x8(%ebp),%eax
801016f2:	66 8b 40 16          	mov    0x16(%eax),%ax
801016f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801016f9:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801016fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101700:	8b 50 18             	mov    0x18(%eax),%edx
80101703:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101706:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101709:	8b 45 08             	mov    0x8(%ebp),%eax
8010170c:	8d 50 1c             	lea    0x1c(%eax),%edx
8010170f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101712:	83 c0 4c             	add    $0x4c,%eax
80101715:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010171c:	00 
8010171d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101721:	89 04 24             	mov    %eax,(%esp)
80101724:	e8 55 42 00 00       	call   8010597e <memmove>
  log_write(bp);
80101729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172c:	89 04 24             	mov    %eax,(%esp)
8010172f:	e8 3d 1b 00 00       	call   80103271 <log_write>
  brelse(bp);
80101734:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101737:	89 04 24             	mov    %eax,(%esp)
8010173a:	e8 d8 ea ff ff       	call   80100217 <brelse>
}
8010173f:	c9                   	leave  
80101740:	c3                   	ret    

80101741 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101741:	55                   	push   %ebp
80101742:	89 e5                	mov    %esp,%ebp
80101744:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101747:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010174e:	e8 0d 3f 00 00       	call   80105660 <acquire>

  // Is the inode already cached?
  empty = 0;
80101753:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010175a:	c7 45 f4 d4 f8 10 80 	movl   $0x8010f8d4,-0xc(%ebp)
80101761:	eb 59                	jmp    801017bc <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101766:	8b 40 08             	mov    0x8(%eax),%eax
80101769:	85 c0                	test   %eax,%eax
8010176b:	7e 35                	jle    801017a2 <iget+0x61>
8010176d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101770:	8b 00                	mov    (%eax),%eax
80101772:	3b 45 08             	cmp    0x8(%ebp),%eax
80101775:	75 2b                	jne    801017a2 <iget+0x61>
80101777:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177a:	8b 40 04             	mov    0x4(%eax),%eax
8010177d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101780:	75 20                	jne    801017a2 <iget+0x61>
      ip->ref++;
80101782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101785:	8b 40 08             	mov    0x8(%eax),%eax
80101788:	8d 50 01             	lea    0x1(%eax),%edx
8010178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010178e:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101791:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101798:	e8 25 3f 00 00       	call   801056c2 <release>
      return ip;
8010179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a0:	eb 6f                	jmp    80101811 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017a6:	75 10                	jne    801017b8 <iget+0x77>
801017a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ab:	8b 40 08             	mov    0x8(%eax),%eax
801017ae:	85 c0                	test   %eax,%eax
801017b0:	75 06                	jne    801017b8 <iget+0x77>
      empty = ip;
801017b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017b8:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017bc:	81 7d f4 74 08 11 80 	cmpl   $0x80110874,-0xc(%ebp)
801017c3:	72 9e                	jb     80101763 <iget+0x22>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017c9:	75 0c                	jne    801017d7 <iget+0x96>
    panic("iget: no inodes");
801017cb:	c7 04 24 df 8f 10 80 	movl   $0x80108fdf,(%esp)
801017d2:	e8 5f ed ff ff       	call   80100536 <panic>

  ip = empty;
801017d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801017dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e0:	8b 55 08             	mov    0x8(%ebp),%edx
801017e3:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801017e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801017eb:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801017ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101802:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101809:	e8 b4 3e 00 00       	call   801056c2 <release>

  return ip;
8010180e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101811:	c9                   	leave  
80101812:	c3                   	ret    

80101813 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101813:	55                   	push   %ebp
80101814:	89 e5                	mov    %esp,%ebp
80101816:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101819:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101820:	e8 3b 3e 00 00       	call   80105660 <acquire>
  ip->ref++;
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 08             	mov    0x8(%eax),%eax
8010182b:	8d 50 01             	lea    0x1(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101834:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010183b:	e8 82 3e 00 00       	call   801056c2 <release>
  return ip;
80101840:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101843:	c9                   	leave  
80101844:	c3                   	ret    

80101845 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101845:	55                   	push   %ebp
80101846:	89 e5                	mov    %esp,%ebp
80101848:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010184b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010184f:	74 0a                	je     8010185b <ilock+0x16>
80101851:	8b 45 08             	mov    0x8(%ebp),%eax
80101854:	8b 40 08             	mov    0x8(%eax),%eax
80101857:	85 c0                	test   %eax,%eax
80101859:	7f 0c                	jg     80101867 <ilock+0x22>
    panic("ilock");
8010185b:	c7 04 24 ef 8f 10 80 	movl   $0x80108fef,(%esp)
80101862:	e8 cf ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101867:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010186e:	e8 ed 3d 00 00       	call   80105660 <acquire>
  while(ip->flags & I_BUSY)
80101873:	eb 13                	jmp    80101888 <ilock+0x43>
    sleep(ip, &icache.lock);
80101875:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
8010187c:	80 
8010187d:	8b 45 08             	mov    0x8(%ebp),%eax
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 56 32 00 00       	call   80104ade <sleep>
  while(ip->flags & I_BUSY)
80101888:	8b 45 08             	mov    0x8(%ebp),%eax
8010188b:	8b 40 0c             	mov    0xc(%eax),%eax
8010188e:	83 e0 01             	and    $0x1,%eax
80101891:	85 c0                	test   %eax,%eax
80101893:	75 e0                	jne    80101875 <ilock+0x30>
  ip->flags |= I_BUSY;
80101895:	8b 45 08             	mov    0x8(%ebp),%eax
80101898:	8b 40 0c             	mov    0xc(%eax),%eax
8010189b:	89 c2                	mov    %eax,%edx
8010189d:	83 ca 01             	or     $0x1,%edx
801018a0:	8b 45 08             	mov    0x8(%ebp),%eax
801018a3:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018a6:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801018ad:	e8 10 3e 00 00       	call   801056c2 <release>

  if(!(ip->flags & I_VALID)){
801018b2:	8b 45 08             	mov    0x8(%ebp),%eax
801018b5:	8b 40 0c             	mov    0xc(%eax),%eax
801018b8:	83 e0 02             	and    $0x2,%eax
801018bb:	85 c0                	test   %eax,%eax
801018bd:	0f 85 cb 00 00 00    	jne    8010198e <ilock+0x149>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018c3:	8b 45 08             	mov    0x8(%ebp),%eax
801018c6:	8b 40 04             	mov    0x4(%eax),%eax
801018c9:	c1 e8 02             	shr    $0x2,%eax
801018cc:	8d 50 02             	lea    0x2(%eax),%edx
801018cf:	8b 45 08             	mov    0x8(%ebp),%eax
801018d2:	8b 00                	mov    (%eax),%eax
801018d4:	89 54 24 04          	mov    %edx,0x4(%esp)
801018d8:	89 04 24             	mov    %eax,(%esp)
801018db:	e8 c6 e8 ff ff       	call   801001a6 <bread>
801018e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e6:	8d 50 18             	lea    0x18(%eax),%edx
801018e9:	8b 45 08             	mov    0x8(%ebp),%eax
801018ec:	8b 40 04             	mov    0x4(%eax),%eax
801018ef:	83 e0 03             	and    $0x3,%eax
801018f2:	c1 e0 07             	shl    $0x7,%eax
801018f5:	01 d0                	add    %edx,%eax
801018f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801018fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018fd:	8b 00                	mov    (%eax),%eax
801018ff:	8b 55 08             	mov    0x8(%ebp),%edx
80101902:	66 89 42 10          	mov    %ax,0x10(%edx)
    ip->major = dip->major;
80101906:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101909:	66 8b 40 02          	mov    0x2(%eax),%ax
8010190d:	8b 55 08             	mov    0x8(%ebp),%edx
80101910:	66 89 42 12          	mov    %ax,0x12(%edx)
    ip->minor = dip->minor;
80101914:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101917:	8b 40 04             	mov    0x4(%eax),%eax
8010191a:	8b 55 08             	mov    0x8(%ebp),%edx
8010191d:	66 89 42 14          	mov    %ax,0x14(%edx)
    ip->nlink = dip->nlink;
80101921:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101924:	66 8b 40 06          	mov    0x6(%eax),%ax
80101928:	8b 55 08             	mov    0x8(%ebp),%edx
8010192b:	66 89 42 16          	mov    %ax,0x16(%edx)
    ip->size = dip->size;
8010192f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101932:	8b 50 08             	mov    0x8(%eax),%edx
80101935:	8b 45 08             	mov    0x8(%ebp),%eax
80101938:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010193b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193e:	8d 50 4c             	lea    0x4c(%eax),%edx
80101941:	8b 45 08             	mov    0x8(%ebp),%eax
80101944:	83 c0 1c             	add    $0x1c,%eax
80101947:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010194e:	00 
8010194f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101953:	89 04 24             	mov    %eax,(%esp)
80101956:	e8 23 40 00 00       	call   8010597e <memmove>
    brelse(bp);
8010195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010195e:	89 04 24             	mov    %eax,(%esp)
80101961:	e8 b1 e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	8b 40 0c             	mov    0xc(%eax),%eax
8010196c:	89 c2                	mov    %eax,%edx
8010196e:	83 ca 02             	or     $0x2,%edx
80101971:	8b 45 08             	mov    0x8(%ebp),%eax
80101974:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101977:	8b 45 08             	mov    0x8(%ebp),%eax
8010197a:	8b 40 10             	mov    0x10(%eax),%eax
8010197d:	66 85 c0             	test   %ax,%ax
80101980:	75 0c                	jne    8010198e <ilock+0x149>
      panic("ilock: no type");
80101982:	c7 04 24 f5 8f 10 80 	movl   $0x80108ff5,(%esp)
80101989:	e8 a8 eb ff ff       	call   80100536 <panic>
  }
}
8010198e:	c9                   	leave  
8010198f:	c3                   	ret    

80101990 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101996:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010199a:	74 17                	je     801019b3 <iunlock+0x23>
8010199c:	8b 45 08             	mov    0x8(%ebp),%eax
8010199f:	8b 40 0c             	mov    0xc(%eax),%eax
801019a2:	83 e0 01             	and    $0x1,%eax
801019a5:	85 c0                	test   %eax,%eax
801019a7:	74 0a                	je     801019b3 <iunlock+0x23>
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 40 08             	mov    0x8(%eax),%eax
801019af:	85 c0                	test   %eax,%eax
801019b1:	7f 0c                	jg     801019bf <iunlock+0x2f>
    panic("iunlock");
801019b3:	c7 04 24 04 90 10 80 	movl   $0x80109004,(%esp)
801019ba:	e8 77 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019bf:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019c6:	e8 95 3c 00 00       	call   80105660 <acquire>
  ip->flags &= ~I_BUSY;
801019cb:	8b 45 08             	mov    0x8(%ebp),%eax
801019ce:	8b 40 0c             	mov    0xc(%eax),%eax
801019d1:	89 c2                	mov    %eax,%edx
801019d3:	83 e2 fe             	and    $0xfffffffe,%edx
801019d6:	8b 45 08             	mov    0x8(%ebp),%eax
801019d9:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
801019dc:	8b 45 08             	mov    0x8(%ebp),%eax
801019df:	89 04 24             	mov    %eax,(%esp)
801019e2:	e8 ff 31 00 00       	call   80104be6 <wakeup>
  release(&icache.lock);
801019e7:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019ee:	e8 cf 3c 00 00       	call   801056c2 <release>
}
801019f3:	c9                   	leave  
801019f4:	c3                   	ret    

801019f5 <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
801019f5:	55                   	push   %ebp
801019f6:	89 e5                	mov    %esp,%ebp
801019f8:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
801019fb:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a02:	e8 59 3c 00 00       	call   80105660 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a07:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0a:	8b 40 08             	mov    0x8(%eax),%eax
80101a0d:	83 f8 01             	cmp    $0x1,%eax
80101a10:	0f 85 93 00 00 00    	jne    80101aa9 <iput+0xb4>
80101a16:	8b 45 08             	mov    0x8(%ebp),%eax
80101a19:	8b 40 0c             	mov    0xc(%eax),%eax
80101a1c:	83 e0 02             	and    $0x2,%eax
80101a1f:	85 c0                	test   %eax,%eax
80101a21:	0f 84 82 00 00 00    	je     80101aa9 <iput+0xb4>
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	66 8b 40 16          	mov    0x16(%eax),%ax
80101a2e:	66 85 c0             	test   %ax,%ax
80101a31:	75 76                	jne    80101aa9 <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a33:	8b 45 08             	mov    0x8(%ebp),%eax
80101a36:	8b 40 0c             	mov    0xc(%eax),%eax
80101a39:	83 e0 01             	and    $0x1,%eax
80101a3c:	85 c0                	test   %eax,%eax
80101a3e:	74 0c                	je     80101a4c <iput+0x57>
      panic("iput busy");
80101a40:	c7 04 24 0c 90 10 80 	movl   $0x8010900c,(%esp)
80101a47:	e8 ea ea ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a52:	89 c2                	mov    %eax,%edx
80101a54:	83 ca 01             	or     $0x1,%edx
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a5d:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a64:	e8 59 3c 00 00       	call   801056c2 <release>
    itrunc(ip);
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	89 04 24             	mov    %eax,(%esp)
80101a6f:	e8 7d 01 00 00       	call   80101bf1 <itrunc>
    ip->type = 0;
80101a74:	8b 45 08             	mov    0x8(%ebp),%eax
80101a77:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a80:	89 04 24             	mov    %eax,(%esp)
80101a83:	e8 03 fc ff ff       	call   8010168b <iupdate>
    acquire(&icache.lock);
80101a88:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101a8f:	e8 cc 3b 00 00       	call   80105660 <acquire>
    ip->flags = 0;
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 04 24             	mov    %eax,(%esp)
80101aa4:	e8 3d 31 00 00       	call   80104be6 <wakeup>
  }
  ip->ref--;
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 40 08             	mov    0x8(%eax),%eax
80101aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ab8:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101abf:	e8 fe 3b 00 00       	call   801056c2 <release>
}
80101ac4:	c9                   	leave  
80101ac5:	c3                   	ret    

80101ac6 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101ac6:	55                   	push   %ebp
80101ac7:	89 e5                	mov    %esp,%ebp
80101ac9:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	89 04 24             	mov    %eax,(%esp)
80101ad2:	e8 b9 fe ff ff       	call   80101990 <iunlock>
  iput(ip);
80101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
80101ada:	89 04 24             	mov    %eax,(%esp)
80101add:	e8 13 ff ff ff       	call   801019f5 <iput>
}
80101ae2:	c9                   	leave  
80101ae3:	c3                   	ret    

80101ae4 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101ae4:	55                   	push   %ebp
80101ae5:	89 e5                	mov    %esp,%ebp
80101ae7:	53                   	push   %ebx
80101ae8:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101aeb:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101aef:	77 3e                	ja     80101b2f <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101af1:	8b 45 08             	mov    0x8(%ebp),%eax
80101af4:	8b 55 0c             	mov    0xc(%ebp),%edx
80101af7:	83 c2 04             	add    $0x4,%edx
80101afa:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b05:	75 20                	jne    80101b27 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b07:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0a:	8b 00                	mov    (%eax),%eax
80101b0c:	89 04 24             	mov    %eax,(%esp)
80101b0f:	e8 36 f8 ff ff       	call   8010134a <balloc>
80101b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b17:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b1d:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b23:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b2a:	e9 bc 00 00 00       	jmp    80101beb <bmap+0x107>
  }
  bn -= NDIRECT;
80101b2f:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b33:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b37:	0f 87 a2 00 00 00    	ja     80101bdf <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b40:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b4a:	75 19                	jne    80101b65 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4f:	8b 00                	mov    (%eax),%eax
80101b51:	89 04 24             	mov    %eax,(%esp)
80101b54:	e8 f1 f7 ff ff       	call   8010134a <balloc>
80101b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b62:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	8b 00                	mov    (%eax),%eax
80101b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b6d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b71:	89 04 24             	mov    %eax,(%esp)
80101b74:	e8 2d e6 ff ff       	call   801001a6 <bread>
80101b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b7f:	83 c0 18             	add    $0x18,%eax
80101b82:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101b85:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b88:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101b92:	01 d0                	add    %edx,%eax
80101b94:	8b 00                	mov    (%eax),%eax
80101b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b9d:	75 30                	jne    80101bcf <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ba9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bac:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	8b 00                	mov    (%eax),%eax
80101bb4:	89 04 24             	mov    %eax,(%esp)
80101bb7:	e8 8e f7 ff ff       	call   8010134a <balloc>
80101bbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc2:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc7:	89 04 24             	mov    %eax,(%esp)
80101bca:	e8 a2 16 00 00       	call   80103271 <log_write>
    }
    brelse(bp);
80101bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd2:	89 04 24             	mov    %eax,(%esp)
80101bd5:	e8 3d e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bdd:	eb 0c                	jmp    80101beb <bmap+0x107>
  }

  panic("bmap: out of range");
80101bdf:	c7 04 24 16 90 10 80 	movl   $0x80109016,(%esp)
80101be6:	e8 4b e9 ff ff       	call   80100536 <panic>
}
80101beb:	83 c4 24             	add    $0x24,%esp
80101bee:	5b                   	pop    %ebx
80101bef:	5d                   	pop    %ebp
80101bf0:	c3                   	ret    

80101bf1 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101bf1:	55                   	push   %ebp
80101bf2:	89 e5                	mov    %esp,%ebp
80101bf4:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101bf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101bfe:	eb 43                	jmp    80101c43 <itrunc+0x52>
    if(ip->addrs[i]){
80101c00:	8b 45 08             	mov    0x8(%ebp),%eax
80101c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c06:	83 c2 04             	add    $0x4,%edx
80101c09:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c0d:	85 c0                	test   %eax,%eax
80101c0f:	74 2f                	je     80101c40 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c11:	8b 45 08             	mov    0x8(%ebp),%eax
80101c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c17:	83 c2 04             	add    $0x4,%edx
80101c1a:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c21:	8b 00                	mov    (%eax),%eax
80101c23:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c27:	89 04 24             	mov    %eax,(%esp)
80101c2a:	e8 7b f8 ff ff       	call   801014aa <bfree>
      ip->addrs[i] = 0;
80101c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c35:	83 c2 04             	add    $0x4,%edx
80101c38:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c3f:	00 
  for(i = 0; i < NDIRECT; i++){
80101c40:	ff 45 f4             	incl   -0xc(%ebp)
80101c43:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c47:	7e b7                	jle    80101c00 <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c4f:	85 c0                	test   %eax,%eax
80101c51:	0f 84 9a 00 00 00    	je     80101cf1 <itrunc+0x100>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c60:	8b 00                	mov    (%eax),%eax
80101c62:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c66:	89 04 24             	mov    %eax,(%esp)
80101c69:	e8 38 e5 ff ff       	call   801001a6 <bread>
80101c6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c71:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c74:	83 c0 18             	add    $0x18,%eax
80101c77:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c81:	eb 3a                	jmp    80101cbd <itrunc+0xcc>
      if(a[j])
80101c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101c90:	01 d0                	add    %edx,%eax
80101c92:	8b 00                	mov    (%eax),%eax
80101c94:	85 c0                	test   %eax,%eax
80101c96:	74 22                	je     80101cba <itrunc+0xc9>
        bfree(ip->dev, a[j]);
80101c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ca5:	01 d0                	add    %edx,%eax
80101ca7:	8b 10                	mov    (%eax),%edx
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 00                	mov    (%eax),%eax
80101cae:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cb2:	89 04 24             	mov    %eax,(%esp)
80101cb5:	e8 f0 f7 ff ff       	call   801014aa <bfree>
    for(j = 0; j < NINDIRECT; j++){
80101cba:	ff 45 f0             	incl   -0x10(%ebp)
80101cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cc0:	83 f8 7f             	cmp    $0x7f,%eax
80101cc3:	76 be                	jbe    80101c83 <itrunc+0x92>
    }
    brelse(bp);
80101cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc8:	89 04 24             	mov    %eax,(%esp)
80101ccb:	e8 47 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd3:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd9:	8b 00                	mov    (%eax),%eax
80101cdb:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cdf:	89 04 24             	mov    %eax,(%esp)
80101ce2:	e8 c3 f7 ff ff       	call   801014aa <bfree>
    ip->addrs[NDIRECT] = 0;
80101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cea:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf4:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101cfb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfe:	89 04 24             	mov    %eax,(%esp)
80101d01:	e8 85 f9 ff ff       	call   8010168b <iupdate>
}
80101d06:	c9                   	leave  
80101d07:	c3                   	ret    

80101d08 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d08:	55                   	push   %ebp
80101d09:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0e:	8b 00                	mov    (%eax),%eax
80101d10:	89 c2                	mov    %eax,%edx
80101d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d15:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d18:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1b:	8b 50 04             	mov    0x4(%eax),%edx
80101d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d21:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d24:	8b 45 08             	mov    0x8(%ebp),%eax
80101d27:	8b 40 10             	mov    0x10(%eax),%eax
80101d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d2d:	66 89 02             	mov    %ax,(%edx)
  st->nlink = ip->nlink;
80101d30:	8b 45 08             	mov    0x8(%ebp),%eax
80101d33:	66 8b 40 16          	mov    0x16(%eax),%ax
80101d37:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d3a:	66 89 42 0c          	mov    %ax,0xc(%edx)
  st->size = ip->size;
80101d3e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d41:	8b 50 18             	mov    0x18(%eax),%edx
80101d44:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d47:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d4a:	5d                   	pop    %ebp
80101d4b:	c3                   	ret    

80101d4c <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d4c:	55                   	push   %ebp
80101d4d:	89 e5                	mov    %esp,%ebp
80101d4f:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d52:	8b 45 08             	mov    0x8(%ebp),%eax
80101d55:	8b 40 10             	mov    0x10(%eax),%eax
80101d58:	66 83 f8 03          	cmp    $0x3,%ax
80101d5c:	75 60                	jne    80101dbe <readi+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d61:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d65:	66 85 c0             	test   %ax,%ax
80101d68:	78 20                	js     80101d8a <readi+0x3e>
80101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6d:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d71:	66 83 f8 09          	cmp    $0x9,%ax
80101d75:	7f 13                	jg     80101d8a <readi+0x3e>
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d7e:	98                   	cwtl   
80101d7f:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101d86:	85 c0                	test   %eax,%eax
80101d88:	75 0a                	jne    80101d94 <readi+0x48>
      return -1;
80101d8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d8f:	e9 1b 01 00 00       	jmp    80101eaf <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d9b:	98                   	cwtl   
80101d9c:	8b 04 c5 40 f8 10 80 	mov    -0x7fef07c0(,%eax,8),%eax
80101da3:	8b 55 14             	mov    0x14(%ebp),%edx
80101da6:	89 54 24 08          	mov    %edx,0x8(%esp)
80101daa:	8b 55 0c             	mov    0xc(%ebp),%edx
80101dad:	89 54 24 04          	mov    %edx,0x4(%esp)
80101db1:	8b 55 08             	mov    0x8(%ebp),%edx
80101db4:	89 14 24             	mov    %edx,(%esp)
80101db7:	ff d0                	call   *%eax
80101db9:	e9 f1 00 00 00       	jmp    80101eaf <readi+0x163>
  }

  if(off > ip->size || off + n < off)
80101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc1:	8b 40 18             	mov    0x18(%eax),%eax
80101dc4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dc7:	72 0d                	jb     80101dd6 <readi+0x8a>
80101dc9:	8b 45 14             	mov    0x14(%ebp),%eax
80101dcc:	8b 55 10             	mov    0x10(%ebp),%edx
80101dcf:	01 d0                	add    %edx,%eax
80101dd1:	3b 45 10             	cmp    0x10(%ebp),%eax
80101dd4:	73 0a                	jae    80101de0 <readi+0x94>
    return -1;
80101dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ddb:	e9 cf 00 00 00       	jmp    80101eaf <readi+0x163>
  if(off + n > ip->size)
80101de0:	8b 45 14             	mov    0x14(%ebp),%eax
80101de3:	8b 55 10             	mov    0x10(%ebp),%edx
80101de6:	01 c2                	add    %eax,%edx
80101de8:	8b 45 08             	mov    0x8(%ebp),%eax
80101deb:	8b 40 18             	mov    0x18(%eax),%eax
80101dee:	39 c2                	cmp    %eax,%edx
80101df0:	76 0c                	jbe    80101dfe <readi+0xb2>
    n = ip->size - off;
80101df2:	8b 45 08             	mov    0x8(%ebp),%eax
80101df5:	8b 40 18             	mov    0x18(%eax),%eax
80101df8:	2b 45 10             	sub    0x10(%ebp),%eax
80101dfb:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e05:	e9 96 00 00 00       	jmp    80101ea0 <readi+0x154>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e0a:	8b 45 10             	mov    0x10(%ebp),%eax
80101e0d:	c1 e8 09             	shr    $0x9,%eax
80101e10:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e14:	8b 45 08             	mov    0x8(%ebp),%eax
80101e17:	89 04 24             	mov    %eax,(%esp)
80101e1a:	e8 c5 fc ff ff       	call   80101ae4 <bmap>
80101e1f:	8b 55 08             	mov    0x8(%ebp),%edx
80101e22:	8b 12                	mov    (%edx),%edx
80101e24:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e28:	89 14 24             	mov    %edx,(%esp)
80101e2b:	e8 76 e3 ff ff       	call   801001a6 <bread>
80101e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e33:	8b 45 10             	mov    0x10(%ebp),%eax
80101e36:	89 c2                	mov    %eax,%edx
80101e38:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e3e:	b8 00 02 00 00       	mov    $0x200,%eax
80101e43:	89 c1                	mov    %eax,%ecx
80101e45:	29 d1                	sub    %edx,%ecx
80101e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e4a:	8b 55 14             	mov    0x14(%ebp),%edx
80101e4d:	29 c2                	sub    %eax,%edx
80101e4f:	89 c8                	mov    %ecx,%eax
80101e51:	39 d0                	cmp    %edx,%eax
80101e53:	76 02                	jbe    80101e57 <readi+0x10b>
80101e55:	89 d0                	mov    %edx,%eax
80101e57:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e5a:	8b 45 10             	mov    0x10(%ebp),%eax
80101e5d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e62:	8d 50 10             	lea    0x10(%eax),%edx
80101e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e68:	01 d0                	add    %edx,%eax
80101e6a:	8d 50 08             	lea    0x8(%eax),%edx
80101e6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e70:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e74:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e78:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e7b:	89 04 24             	mov    %eax,(%esp)
80101e7e:	e8 fb 3a 00 00       	call   8010597e <memmove>
    brelse(bp);
80101e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e86:	89 04 24             	mov    %eax,(%esp)
80101e89:	e8 89 e3 ff ff       	call   80100217 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e91:	01 45 f4             	add    %eax,-0xc(%ebp)
80101e94:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e97:	01 45 10             	add    %eax,0x10(%ebp)
80101e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e9d:	01 45 0c             	add    %eax,0xc(%ebp)
80101ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ea3:	3b 45 14             	cmp    0x14(%ebp),%eax
80101ea6:	0f 82 5e ff ff ff    	jb     80101e0a <readi+0xbe>
  }
  return n;
80101eac:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101eaf:	c9                   	leave  
80101eb0:	c3                   	ret    

80101eb1 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101eb1:	55                   	push   %ebp
80101eb2:	89 e5                	mov    %esp,%ebp
80101eb4:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101eb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101eba:	8b 40 10             	mov    0x10(%eax),%eax
80101ebd:	66 83 f8 03          	cmp    $0x3,%ax
80101ec1:	75 60                	jne    80101f23 <writei+0x72>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	66 8b 40 12          	mov    0x12(%eax),%ax
80101eca:	66 85 c0             	test   %ax,%ax
80101ecd:	78 20                	js     80101eef <writei+0x3e>
80101ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed2:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ed6:	66 83 f8 09          	cmp    $0x9,%ax
80101eda:	7f 13                	jg     80101eef <writei+0x3e>
80101edc:	8b 45 08             	mov    0x8(%ebp),%eax
80101edf:	66 8b 40 12          	mov    0x12(%eax),%ax
80101ee3:	98                   	cwtl   
80101ee4:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	75 0a                	jne    80101ef9 <writei+0x48>
      return -1;
80101eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef4:	e9 46 01 00 00       	jmp    8010203f <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f00:	98                   	cwtl   
80101f01:	8b 04 c5 44 f8 10 80 	mov    -0x7fef07bc(,%eax,8),%eax
80101f08:	8b 55 14             	mov    0x14(%ebp),%edx
80101f0b:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f12:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f16:	8b 55 08             	mov    0x8(%ebp),%edx
80101f19:	89 14 24             	mov    %edx,(%esp)
80101f1c:	ff d0                	call   *%eax
80101f1e:	e9 1c 01 00 00       	jmp    8010203f <writei+0x18e>
  }

  if(off > ip->size || off + n < off)
80101f23:	8b 45 08             	mov    0x8(%ebp),%eax
80101f26:	8b 40 18             	mov    0x18(%eax),%eax
80101f29:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f2c:	72 0d                	jb     80101f3b <writei+0x8a>
80101f2e:	8b 45 14             	mov    0x14(%ebp),%eax
80101f31:	8b 55 10             	mov    0x10(%ebp),%edx
80101f34:	01 d0                	add    %edx,%eax
80101f36:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f39:	73 0a                	jae    80101f45 <writei+0x94>
    return -1;
80101f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f40:	e9 fa 00 00 00       	jmp    8010203f <writei+0x18e>
  if(off + n > MAXFILE*BSIZE)
80101f45:	8b 45 14             	mov    0x14(%ebp),%eax
80101f48:	8b 55 10             	mov    0x10(%ebp),%edx
80101f4b:	01 d0                	add    %edx,%eax
80101f4d:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f52:	76 0a                	jbe    80101f5e <writei+0xad>
    return -1;
80101f54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f59:	e9 e1 00 00 00       	jmp    8010203f <writei+0x18e>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f65:	e9 a1 00 00 00       	jmp    8010200b <writei+0x15a>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f6a:	8b 45 10             	mov    0x10(%ebp),%eax
80101f6d:	c1 e8 09             	shr    $0x9,%eax
80101f70:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f74:	8b 45 08             	mov    0x8(%ebp),%eax
80101f77:	89 04 24             	mov    %eax,(%esp)
80101f7a:	e8 65 fb ff ff       	call   80101ae4 <bmap>
80101f7f:	8b 55 08             	mov    0x8(%ebp),%edx
80101f82:	8b 12                	mov    (%edx),%edx
80101f84:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f88:	89 14 24             	mov    %edx,(%esp)
80101f8b:	e8 16 e2 ff ff       	call   801001a6 <bread>
80101f90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101f93:	8b 45 10             	mov    0x10(%ebp),%eax
80101f96:	89 c2                	mov    %eax,%edx
80101f98:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101f9e:	b8 00 02 00 00       	mov    $0x200,%eax
80101fa3:	89 c1                	mov    %eax,%ecx
80101fa5:	29 d1                	sub    %edx,%ecx
80101fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101faa:	8b 55 14             	mov    0x14(%ebp),%edx
80101fad:	29 c2                	sub    %eax,%edx
80101faf:	89 c8                	mov    %ecx,%eax
80101fb1:	39 d0                	cmp    %edx,%eax
80101fb3:	76 02                	jbe    80101fb7 <writei+0x106>
80101fb5:	89 d0                	mov    %edx,%eax
80101fb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fba:	8b 45 10             	mov    0x10(%ebp),%eax
80101fbd:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fc2:	8d 50 10             	lea    0x10(%eax),%edx
80101fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc8:	01 d0                	add    %edx,%eax
80101fca:	8d 50 08             	lea    0x8(%eax),%edx
80101fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fd0:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fdb:	89 14 24             	mov    %edx,(%esp)
80101fde:	e8 9b 39 00 00       	call   8010597e <memmove>
    log_write(bp);
80101fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fe6:	89 04 24             	mov    %eax,(%esp)
80101fe9:	e8 83 12 00 00       	call   80103271 <log_write>
    brelse(bp);
80101fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff1:	89 04 24             	mov    %eax,(%esp)
80101ff4:	e8 1e e2 ff ff       	call   80100217 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ffc:	01 45 f4             	add    %eax,-0xc(%ebp)
80101fff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102002:	01 45 10             	add    %eax,0x10(%ebp)
80102005:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102008:	01 45 0c             	add    %eax,0xc(%ebp)
8010200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010200e:	3b 45 14             	cmp    0x14(%ebp),%eax
80102011:	0f 82 53 ff ff ff    	jb     80101f6a <writei+0xb9>
  }

  if(n > 0 && off > ip->size){
80102017:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010201b:	74 1f                	je     8010203c <writei+0x18b>
8010201d:	8b 45 08             	mov    0x8(%ebp),%eax
80102020:	8b 40 18             	mov    0x18(%eax),%eax
80102023:	3b 45 10             	cmp    0x10(%ebp),%eax
80102026:	73 14                	jae    8010203c <writei+0x18b>
    ip->size = off;
80102028:	8b 45 08             	mov    0x8(%ebp),%eax
8010202b:	8b 55 10             	mov    0x10(%ebp),%edx
8010202e:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102031:	8b 45 08             	mov    0x8(%ebp),%eax
80102034:	89 04 24             	mov    %eax,(%esp)
80102037:	e8 4f f6 ff ff       	call   8010168b <iupdate>
  }
  return n;
8010203c:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    

80102041 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102041:	55                   	push   %ebp
80102042:	89 e5                	mov    %esp,%ebp
80102044:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102047:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010204e:	00 
8010204f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102052:	89 44 24 04          	mov    %eax,0x4(%esp)
80102056:	8b 45 08             	mov    0x8(%ebp),%eax
80102059:	89 04 24             	mov    %eax,(%esp)
8010205c:	e8 b9 39 00 00       	call   80105a1a <strncmp>
}
80102061:	c9                   	leave  
80102062:	c3                   	ret    

80102063 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102063:	55                   	push   %ebp
80102064:	89 e5                	mov    %esp,%ebp
80102066:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102069:	8b 45 08             	mov    0x8(%ebp),%eax
8010206c:	8b 40 10             	mov    0x10(%eax),%eax
8010206f:	66 83 f8 01          	cmp    $0x1,%ax
80102073:	74 0c                	je     80102081 <dirlookup+0x1e>
    panic("dirlookup not DIR");
80102075:	c7 04 24 29 90 10 80 	movl   $0x80109029,(%esp)
8010207c:	e8 b5 e4 ff ff       	call   80100536 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102081:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102088:	e9 85 00 00 00       	jmp    80102112 <dirlookup+0xaf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010208d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102094:	00 
80102095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102098:	89 44 24 08          	mov    %eax,0x8(%esp)
8010209c:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010209f:	89 44 24 04          	mov    %eax,0x4(%esp)
801020a3:	8b 45 08             	mov    0x8(%ebp),%eax
801020a6:	89 04 24             	mov    %eax,(%esp)
801020a9:	e8 9e fc ff ff       	call   80101d4c <readi>
801020ae:	83 f8 10             	cmp    $0x10,%eax
801020b1:	74 0c                	je     801020bf <dirlookup+0x5c>
      panic("dirlink read");
801020b3:	c7 04 24 3b 90 10 80 	movl   $0x8010903b,(%esp)
801020ba:	e8 77 e4 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
801020bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020c2:	66 85 c0             	test   %ax,%ax
801020c5:	74 46                	je     8010210d <dirlookup+0xaa>
      continue;
    if(namecmp(name, de.name) == 0){
801020c7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020ca:	83 c0 02             	add    $0x2,%eax
801020cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801020d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d4:	89 04 24             	mov    %eax,(%esp)
801020d7:	e8 65 ff ff ff       	call   80102041 <namecmp>
801020dc:	85 c0                	test   %eax,%eax
801020de:	75 2e                	jne    8010210e <dirlookup+0xab>
      // entry matches path element
      if(poff)
801020e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801020e4:	74 08                	je     801020ee <dirlookup+0x8b>
        *poff = off;
801020e6:	8b 45 10             	mov    0x10(%ebp),%eax
801020e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801020ec:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
801020ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020f1:	0f b7 c0             	movzwl %ax,%eax
801020f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801020f7:	8b 45 08             	mov    0x8(%ebp),%eax
801020fa:	8b 00                	mov    (%eax),%eax
801020fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801020ff:	89 54 24 04          	mov    %edx,0x4(%esp)
80102103:	89 04 24             	mov    %eax,(%esp)
80102106:	e8 36 f6 ff ff       	call   80101741 <iget>
8010210b:	eb 19                	jmp    80102126 <dirlookup+0xc3>
      continue;
8010210d:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
8010210e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102112:	8b 45 08             	mov    0x8(%ebp),%eax
80102115:	8b 40 18             	mov    0x18(%eax),%eax
80102118:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010211b:	0f 87 6c ff ff ff    	ja     8010208d <dirlookup+0x2a>
    }
  }

  return 0;
80102121:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102126:	c9                   	leave  
80102127:	c3                   	ret    

80102128 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102128:	55                   	push   %ebp
80102129:	89 e5                	mov    %esp,%ebp
8010212b:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010212e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102135:	00 
80102136:	8b 45 0c             	mov    0xc(%ebp),%eax
80102139:	89 44 24 04          	mov    %eax,0x4(%esp)
8010213d:	8b 45 08             	mov    0x8(%ebp),%eax
80102140:	89 04 24             	mov    %eax,(%esp)
80102143:	e8 1b ff ff ff       	call   80102063 <dirlookup>
80102148:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010214b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010214f:	74 15                	je     80102166 <dirlink+0x3e>
    iput(ip);
80102151:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102154:	89 04 24             	mov    %eax,(%esp)
80102157:	e8 99 f8 ff ff       	call   801019f5 <iput>
    return -1;
8010215c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102161:	e9 b7 00 00 00       	jmp    8010221d <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102166:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010216d:	eb 43                	jmp    801021b2 <dirlink+0x8a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102172:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102179:	00 
8010217a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010217e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102181:	89 44 24 04          	mov    %eax,0x4(%esp)
80102185:	8b 45 08             	mov    0x8(%ebp),%eax
80102188:	89 04 24             	mov    %eax,(%esp)
8010218b:	e8 bc fb ff ff       	call   80101d4c <readi>
80102190:	83 f8 10             	cmp    $0x10,%eax
80102193:	74 0c                	je     801021a1 <dirlink+0x79>
      panic("dirlink read");
80102195:	c7 04 24 3b 90 10 80 	movl   $0x8010903b,(%esp)
8010219c:	e8 95 e3 ff ff       	call   80100536 <panic>
    if(de.inum == 0)
801021a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801021a4:	66 85 c0             	test   %ax,%ax
801021a7:	74 18                	je     801021c1 <dirlink+0x99>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ac:	83 c0 10             	add    $0x10,%eax
801021af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021b5:	8b 45 08             	mov    0x8(%ebp),%eax
801021b8:	8b 40 18             	mov    0x18(%eax),%eax
801021bb:	39 c2                	cmp    %eax,%edx
801021bd:	72 b0                	jb     8010216f <dirlink+0x47>
801021bf:	eb 01                	jmp    801021c2 <dirlink+0x9a>
      break;
801021c1:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801021c2:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021c9:	00 
801021ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801021cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801021d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021d4:	83 c0 02             	add    $0x2,%eax
801021d7:	89 04 24             	mov    %eax,(%esp)
801021da:	e8 8b 38 00 00       	call   80105a6a <strncpy>
  de.inum = inum;
801021df:	8b 45 10             	mov    0x10(%ebp),%eax
801021e2:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021e9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021f0:	00 
801021f1:	89 44 24 08          	mov    %eax,0x8(%esp)
801021f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801021fc:	8b 45 08             	mov    0x8(%ebp),%eax
801021ff:	89 04 24             	mov    %eax,(%esp)
80102202:	e8 aa fc ff ff       	call   80101eb1 <writei>
80102207:	83 f8 10             	cmp    $0x10,%eax
8010220a:	74 0c                	je     80102218 <dirlink+0xf0>
    panic("dirlink");
8010220c:	c7 04 24 48 90 10 80 	movl   $0x80109048,(%esp)
80102213:	e8 1e e3 ff ff       	call   80100536 <panic>
  
  return 0;
80102218:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010221d:	c9                   	leave  
8010221e:	c3                   	ret    

8010221f <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
8010221f:	55                   	push   %ebp
80102220:	89 e5                	mov    %esp,%ebp
80102222:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102225:	eb 03                	jmp    8010222a <skipelem+0xb>
    path++;
80102227:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
8010222a:	8b 45 08             	mov    0x8(%ebp),%eax
8010222d:	8a 00                	mov    (%eax),%al
8010222f:	3c 2f                	cmp    $0x2f,%al
80102231:	74 f4                	je     80102227 <skipelem+0x8>
  if(*path == 0)
80102233:	8b 45 08             	mov    0x8(%ebp),%eax
80102236:	8a 00                	mov    (%eax),%al
80102238:	84 c0                	test   %al,%al
8010223a:	75 0a                	jne    80102246 <skipelem+0x27>
    return 0;
8010223c:	b8 00 00 00 00       	mov    $0x0,%eax
80102241:	e9 83 00 00 00       	jmp    801022c9 <skipelem+0xaa>
  s = path;
80102246:	8b 45 08             	mov    0x8(%ebp),%eax
80102249:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
8010224c:	eb 03                	jmp    80102251 <skipelem+0x32>
    path++;
8010224e:	ff 45 08             	incl   0x8(%ebp)
  while(*path != '/' && *path != 0)
80102251:	8b 45 08             	mov    0x8(%ebp),%eax
80102254:	8a 00                	mov    (%eax),%al
80102256:	3c 2f                	cmp    $0x2f,%al
80102258:	74 09                	je     80102263 <skipelem+0x44>
8010225a:	8b 45 08             	mov    0x8(%ebp),%eax
8010225d:	8a 00                	mov    (%eax),%al
8010225f:	84 c0                	test   %al,%al
80102261:	75 eb                	jne    8010224e <skipelem+0x2f>
  len = path - s;
80102263:	8b 55 08             	mov    0x8(%ebp),%edx
80102266:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102269:	89 d1                	mov    %edx,%ecx
8010226b:	29 c1                	sub    %eax,%ecx
8010226d:	89 c8                	mov    %ecx,%eax
8010226f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102272:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
80102276:	7e 1c                	jle    80102294 <skipelem+0x75>
    memmove(name, s, DIRSIZ);
80102278:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010227f:	00 
80102280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102283:	89 44 24 04          	mov    %eax,0x4(%esp)
80102287:	8b 45 0c             	mov    0xc(%ebp),%eax
8010228a:	89 04 24             	mov    %eax,(%esp)
8010228d:	e8 ec 36 00 00       	call   8010597e <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102292:	eb 29                	jmp    801022bd <skipelem+0x9e>
    memmove(name, s, len);
80102294:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102297:	89 44 24 08          	mov    %eax,0x8(%esp)
8010229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010229e:	89 44 24 04          	mov    %eax,0x4(%esp)
801022a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801022a5:	89 04 24             	mov    %eax,(%esp)
801022a8:	e8 d1 36 00 00       	call   8010597e <memmove>
    name[len] = 0;
801022ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801022b3:	01 d0                	add    %edx,%eax
801022b5:	c6 00 00             	movb   $0x0,(%eax)
  while(*path == '/')
801022b8:	eb 03                	jmp    801022bd <skipelem+0x9e>
    path++;
801022ba:	ff 45 08             	incl   0x8(%ebp)
  while(*path == '/')
801022bd:	8b 45 08             	mov    0x8(%ebp),%eax
801022c0:	8a 00                	mov    (%eax),%al
801022c2:	3c 2f                	cmp    $0x2f,%al
801022c4:	74 f4                	je     801022ba <skipelem+0x9b>
  return path;
801022c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022c9:	c9                   	leave  
801022ca:	c3                   	ret    

801022cb <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022cb:	55                   	push   %ebp
801022cc:	89 e5                	mov    %esp,%ebp
801022ce:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022d1:	8b 45 08             	mov    0x8(%ebp),%eax
801022d4:	8a 00                	mov    (%eax),%al
801022d6:	3c 2f                	cmp    $0x2f,%al
801022d8:	75 1c                	jne    801022f6 <namex+0x2b>
    ip = iget(ROOTDEV, ROOTINO);
801022da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801022e1:	00 
801022e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801022e9:	e8 53 f4 ff ff       	call   80101741 <iget>
801022ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801022f1:	e9 ad 00 00 00       	jmp    801023a3 <namex+0xd8>
    ip = idup(proc->cwd);
801022f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801022fc:	8b 40 68             	mov    0x68(%eax),%eax
801022ff:	89 04 24             	mov    %eax,(%esp)
80102302:	e8 0c f5 ff ff       	call   80101813 <idup>
80102307:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
8010230a:	e9 94 00 00 00       	jmp    801023a3 <namex+0xd8>
    ilock(ip);
8010230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102312:	89 04 24             	mov    %eax,(%esp)
80102315:	e8 2b f5 ff ff       	call   80101845 <ilock>
    if(ip->type != T_DIR){
8010231a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010231d:	8b 40 10             	mov    0x10(%eax),%eax
80102320:	66 83 f8 01          	cmp    $0x1,%ax
80102324:	74 15                	je     8010233b <namex+0x70>
      iunlockput(ip);
80102326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102329:	89 04 24             	mov    %eax,(%esp)
8010232c:	e8 95 f7 ff ff       	call   80101ac6 <iunlockput>
      return 0;
80102331:	b8 00 00 00 00       	mov    $0x0,%eax
80102336:	e9 a2 00 00 00       	jmp    801023dd <namex+0x112>
    }
    if(nameiparent && *path == '\0'){
8010233b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010233f:	74 1c                	je     8010235d <namex+0x92>
80102341:	8b 45 08             	mov    0x8(%ebp),%eax
80102344:	8a 00                	mov    (%eax),%al
80102346:	84 c0                	test   %al,%al
80102348:	75 13                	jne    8010235d <namex+0x92>
      // Stop one level early.
      iunlock(ip);
8010234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234d:	89 04 24             	mov    %eax,(%esp)
80102350:	e8 3b f6 ff ff       	call   80101990 <iunlock>
      return ip;
80102355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102358:	e9 80 00 00 00       	jmp    801023dd <namex+0x112>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010235d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102364:	00 
80102365:	8b 45 10             	mov    0x10(%ebp),%eax
80102368:	89 44 24 04          	mov    %eax,0x4(%esp)
8010236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010236f:	89 04 24             	mov    %eax,(%esp)
80102372:	e8 ec fc ff ff       	call   80102063 <dirlookup>
80102377:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010237a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010237e:	75 12                	jne    80102392 <namex+0xc7>
      iunlockput(ip);
80102380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102383:	89 04 24             	mov    %eax,(%esp)
80102386:	e8 3b f7 ff ff       	call   80101ac6 <iunlockput>
      return 0;
8010238b:	b8 00 00 00 00       	mov    $0x0,%eax
80102390:	eb 4b                	jmp    801023dd <namex+0x112>
    }
    iunlockput(ip);
80102392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102395:	89 04 24             	mov    %eax,(%esp)
80102398:	e8 29 f7 ff ff       	call   80101ac6 <iunlockput>
    ip = next;
8010239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801023a3:	8b 45 10             	mov    0x10(%ebp),%eax
801023a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801023aa:	8b 45 08             	mov    0x8(%ebp),%eax
801023ad:	89 04 24             	mov    %eax,(%esp)
801023b0:	e8 6a fe ff ff       	call   8010221f <skipelem>
801023b5:	89 45 08             	mov    %eax,0x8(%ebp)
801023b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023bc:	0f 85 4d ff ff ff    	jne    8010230f <namex+0x44>
  }
  if(nameiparent){
801023c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023c6:	74 12                	je     801023da <namex+0x10f>
    iput(ip);
801023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023cb:	89 04 24             	mov    %eax,(%esp)
801023ce:	e8 22 f6 ff ff       	call   801019f5 <iput>
    return 0;
801023d3:	b8 00 00 00 00       	mov    $0x0,%eax
801023d8:	eb 03                	jmp    801023dd <namex+0x112>
  }
  return ip;
801023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801023dd:	c9                   	leave  
801023de:	c3                   	ret    

801023df <namei>:

struct inode*
namei(char *path)
{
801023df:	55                   	push   %ebp
801023e0:	89 e5                	mov    %esp,%ebp
801023e2:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801023e5:	8d 45 ea             	lea    -0x16(%ebp),%eax
801023e8:	89 44 24 08          	mov    %eax,0x8(%esp)
801023ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801023f3:	00 
801023f4:	8b 45 08             	mov    0x8(%ebp),%eax
801023f7:	89 04 24             	mov    %eax,(%esp)
801023fa:	e8 cc fe ff ff       	call   801022cb <namex>
}
801023ff:	c9                   	leave  
80102400:	c3                   	ret    

80102401 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102401:	55                   	push   %ebp
80102402:	89 e5                	mov    %esp,%ebp
80102404:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102407:	8b 45 0c             	mov    0xc(%ebp),%eax
8010240a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010240e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102415:	00 
80102416:	8b 45 08             	mov    0x8(%ebp),%eax
80102419:	89 04 24             	mov    %eax,(%esp)
8010241c:	e8 aa fe ff ff       	call   801022cb <namex>
}
80102421:	c9                   	leave  
80102422:	c3                   	ret    

80102423 <inb>:
{
80102423:	55                   	push   %ebp
80102424:	89 e5                	mov    %esp,%ebp
80102426:	53                   	push   %ebx
80102427:	83 ec 14             	sub    $0x14,%esp
8010242a:	8b 45 08             	mov    0x8(%ebp),%eax
8010242d:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102431:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102434:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102438:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
8010243c:	ec                   	in     (%dx),%al
8010243d:	88 c3                	mov    %al,%bl
8010243f:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102442:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102445:	83 c4 14             	add    $0x14,%esp
80102448:	5b                   	pop    %ebx
80102449:	5d                   	pop    %ebp
8010244a:	c3                   	ret    

8010244b <insl>:
{
8010244b:	55                   	push   %ebp
8010244c:	89 e5                	mov    %esp,%ebp
8010244e:	57                   	push   %edi
8010244f:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102450:	8b 55 08             	mov    0x8(%ebp),%edx
80102453:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102456:	8b 45 10             	mov    0x10(%ebp),%eax
80102459:	89 cb                	mov    %ecx,%ebx
8010245b:	89 df                	mov    %ebx,%edi
8010245d:	89 c1                	mov    %eax,%ecx
8010245f:	fc                   	cld    
80102460:	f3 6d                	rep insl (%dx),%es:(%edi)
80102462:	89 c8                	mov    %ecx,%eax
80102464:	89 fb                	mov    %edi,%ebx
80102466:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102469:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010246c:	5b                   	pop    %ebx
8010246d:	5f                   	pop    %edi
8010246e:	5d                   	pop    %ebp
8010246f:	c3                   	ret    

80102470 <outb>:
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	83 ec 08             	sub    $0x8,%esp
80102476:	8b 45 08             	mov    0x8(%ebp),%eax
80102479:	8b 55 0c             	mov    0xc(%ebp),%edx
8010247c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102480:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102483:	8a 45 f8             	mov    -0x8(%ebp),%al
80102486:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102489:	ee                   	out    %al,(%dx)
}
8010248a:	c9                   	leave  
8010248b:	c3                   	ret    

8010248c <outsl>:
{
8010248c:	55                   	push   %ebp
8010248d:	89 e5                	mov    %esp,%ebp
8010248f:	56                   	push   %esi
80102490:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102491:	8b 55 08             	mov    0x8(%ebp),%edx
80102494:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102497:	8b 45 10             	mov    0x10(%ebp),%eax
8010249a:	89 cb                	mov    %ecx,%ebx
8010249c:	89 de                	mov    %ebx,%esi
8010249e:	89 c1                	mov    %eax,%ecx
801024a0:	fc                   	cld    
801024a1:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024a3:	89 c8                	mov    %ecx,%eax
801024a5:	89 f3                	mov    %esi,%ebx
801024a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024aa:	89 45 10             	mov    %eax,0x10(%ebp)
}
801024ad:	5b                   	pop    %ebx
801024ae:	5e                   	pop    %esi
801024af:	5d                   	pop    %ebp
801024b0:	c3                   	ret    

801024b1 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024b1:	55                   	push   %ebp
801024b2:	89 e5                	mov    %esp,%ebp
801024b4:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024b7:	90                   	nop
801024b8:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024bf:	e8 5f ff ff ff       	call   80102423 <inb>
801024c4:	0f b6 c0             	movzbl %al,%eax
801024c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024cd:	25 c0 00 00 00       	and    $0xc0,%eax
801024d2:	83 f8 40             	cmp    $0x40,%eax
801024d5:	75 e1                	jne    801024b8 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801024db:	74 11                	je     801024ee <idewait+0x3d>
801024dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024e0:	83 e0 21             	and    $0x21,%eax
801024e3:	85 c0                	test   %eax,%eax
801024e5:	74 07                	je     801024ee <idewait+0x3d>
    return -1;
801024e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024ec:	eb 05                	jmp    801024f3 <idewait+0x42>
  return 0;
801024ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024f3:	c9                   	leave  
801024f4:	c3                   	ret    

801024f5 <ideinit>:

void
ideinit(void)
{
801024f5:	55                   	push   %ebp
801024f6:	89 e5                	mov    %esp,%ebp
801024f8:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801024fb:	c7 44 24 04 50 90 10 	movl   $0x80109050,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010250a:	e8 30 31 00 00       	call   8010563f <initlock>
  picenable(IRQ_IDE);
8010250f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102516:	e8 86 15 00 00       	call   80103aa1 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010251b:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80102520:	48                   	dec    %eax
80102521:	89 44 24 04          	mov    %eax,0x4(%esp)
80102525:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010252c:	e8 09 04 00 00       	call   8010293a <ioapicenable>
  idewait(0);
80102531:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102538:	e8 74 ff ff ff       	call   801024b1 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
8010253d:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102544:	00 
80102545:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010254c:	e8 1f ff ff ff       	call   80102470 <outb>
  for(i=0; i<1000; i++){
80102551:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102558:	eb 1f                	jmp    80102579 <ideinit+0x84>
    if(inb(0x1f7) != 0){
8010255a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102561:	e8 bd fe ff ff       	call   80102423 <inb>
80102566:	84 c0                	test   %al,%al
80102568:	74 0c                	je     80102576 <ideinit+0x81>
      havedisk1 = 1;
8010256a:	c7 05 78 c6 10 80 01 	movl   $0x1,0x8010c678
80102571:	00 00 00 
      break;
80102574:	eb 0c                	jmp    80102582 <ideinit+0x8d>
  for(i=0; i<1000; i++){
80102576:	ff 45 f4             	incl   -0xc(%ebp)
80102579:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102580:	7e d8                	jle    8010255a <ideinit+0x65>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102582:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
80102589:	00 
8010258a:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102591:	e8 da fe ff ff       	call   80102470 <outb>
}
80102596:	c9                   	leave  
80102597:	c3                   	ret    

80102598 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102598:	55                   	push   %ebp
80102599:	89 e5                	mov    %esp,%ebp
8010259b:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
8010259e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025a2:	75 0c                	jne    801025b0 <idestart+0x18>
    panic("idestart");
801025a4:	c7 04 24 54 90 10 80 	movl   $0x80109054,(%esp)
801025ab:	e8 86 df ff ff       	call   80100536 <panic>

  idewait(0);
801025b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025b7:	e8 f5 fe ff ff       	call   801024b1 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025c3:	00 
801025c4:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025cb:	e8 a0 fe ff ff       	call   80102470 <outb>
  outb(0x1f2, 1);  // number of sectors
801025d0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801025d7:	00 
801025d8:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801025df:	e8 8c fe ff ff       	call   80102470 <outb>
  outb(0x1f3, b->sector & 0xff);
801025e4:	8b 45 08             	mov    0x8(%ebp),%eax
801025e7:	8b 40 08             	mov    0x8(%eax),%eax
801025ea:	0f b6 c0             	movzbl %al,%eax
801025ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801025f1:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
801025f8:	e8 73 fe ff ff       	call   80102470 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
801025fd:	8b 45 08             	mov    0x8(%ebp),%eax
80102600:	8b 40 08             	mov    0x8(%eax),%eax
80102603:	c1 e8 08             	shr    $0x8,%eax
80102606:	0f b6 c0             	movzbl %al,%eax
80102609:	89 44 24 04          	mov    %eax,0x4(%esp)
8010260d:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102614:	e8 57 fe ff ff       	call   80102470 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102619:	8b 45 08             	mov    0x8(%ebp),%eax
8010261c:	8b 40 08             	mov    0x8(%eax),%eax
8010261f:	c1 e8 10             	shr    $0x10,%eax
80102622:	0f b6 c0             	movzbl %al,%eax
80102625:	89 44 24 04          	mov    %eax,0x4(%esp)
80102629:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102630:	e8 3b fe ff ff       	call   80102470 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
80102638:	8b 40 04             	mov    0x4(%eax),%eax
8010263b:	83 e0 01             	and    $0x1,%eax
8010263e:	88 c2                	mov    %al,%dl
80102640:	c1 e2 04             	shl    $0x4,%edx
80102643:	8b 45 08             	mov    0x8(%ebp),%eax
80102646:	8b 40 08             	mov    0x8(%eax),%eax
80102649:	c1 e8 18             	shr    $0x18,%eax
8010264c:	83 e0 0f             	and    $0xf,%eax
8010264f:	09 d0                	or     %edx,%eax
80102651:	83 c8 e0             	or     $0xffffffe0,%eax
80102654:	0f b6 c0             	movzbl %al,%eax
80102657:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265b:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102662:	e8 09 fe ff ff       	call   80102470 <outb>
  if(b->flags & B_DIRTY){
80102667:	8b 45 08             	mov    0x8(%ebp),%eax
8010266a:	8b 00                	mov    (%eax),%eax
8010266c:	83 e0 04             	and    $0x4,%eax
8010266f:	85 c0                	test   %eax,%eax
80102671:	74 34                	je     801026a7 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
80102673:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
8010267a:	00 
8010267b:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102682:	e8 e9 fd ff ff       	call   80102470 <outb>
    outsl(0x1f0, b->data, 512/4);
80102687:	8b 45 08             	mov    0x8(%ebp),%eax
8010268a:	83 c0 18             	add    $0x18,%eax
8010268d:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102694:	00 
80102695:	89 44 24 04          	mov    %eax,0x4(%esp)
80102699:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026a0:	e8 e7 fd ff ff       	call   8010248c <outsl>
801026a5:	eb 14                	jmp    801026bb <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026a7:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026ae:	00 
801026af:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b6:	e8 b5 fd ff ff       	call   80102470 <outb>
  }
}
801026bb:	c9                   	leave  
801026bc:	c3                   	ret    

801026bd <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026bd:	55                   	push   %ebp
801026be:	89 e5                	mov    %esp,%ebp
801026c0:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026c3:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801026ca:	e8 91 2f 00 00       	call   80105660 <acquire>
  if((b = idequeue) == 0){
801026cf:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026db:	75 11                	jne    801026ee <ideintr+0x31>
    release(&idelock);
801026dd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801026e4:	e8 d9 2f 00 00       	call   801056c2 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026e9:	e9 90 00 00 00       	jmp    8010277e <ideintr+0xc1>
  }
  idequeue = b->qnext;
801026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f1:	8b 40 14             	mov    0x14(%eax),%eax
801026f4:	a3 74 c6 10 80       	mov    %eax,0x8010c674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026fc:	8b 00                	mov    (%eax),%eax
801026fe:	83 e0 04             	and    $0x4,%eax
80102701:	85 c0                	test   %eax,%eax
80102703:	75 2e                	jne    80102733 <ideintr+0x76>
80102705:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010270c:	e8 a0 fd ff ff       	call   801024b1 <idewait>
80102711:	85 c0                	test   %eax,%eax
80102713:	78 1e                	js     80102733 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102715:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102718:	83 c0 18             	add    $0x18,%eax
8010271b:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102722:	00 
80102723:	89 44 24 04          	mov    %eax,0x4(%esp)
80102727:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
8010272e:	e8 18 fd ff ff       	call   8010244b <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102733:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102736:	8b 00                	mov    (%eax),%eax
80102738:	89 c2                	mov    %eax,%edx
8010273a:	83 ca 02             	or     $0x2,%edx
8010273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102740:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102745:	8b 00                	mov    (%eax),%eax
80102747:	89 c2                	mov    %eax,%edx
80102749:	83 e2 fb             	and    $0xfffffffb,%edx
8010274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274f:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102754:	89 04 24             	mov    %eax,(%esp)
80102757:	e8 8a 24 00 00       	call   80104be6 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010275c:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102761:	85 c0                	test   %eax,%eax
80102763:	74 0d                	je     80102772 <ideintr+0xb5>
    idestart(idequeue);
80102765:	a1 74 c6 10 80       	mov    0x8010c674,%eax
8010276a:	89 04 24             	mov    %eax,(%esp)
8010276d:	e8 26 fe ff ff       	call   80102598 <idestart>

  release(&idelock);
80102772:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102779:	e8 44 2f 00 00       	call   801056c2 <release>
}
8010277e:	c9                   	leave  
8010277f:	c3                   	ret    

80102780 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102780:	55                   	push   %ebp
80102781:	89 e5                	mov    %esp,%ebp
80102783:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102786:	8b 45 08             	mov    0x8(%ebp),%eax
80102789:	8b 00                	mov    (%eax),%eax
8010278b:	83 e0 01             	and    $0x1,%eax
8010278e:	85 c0                	test   %eax,%eax
80102790:	75 0c                	jne    8010279e <iderw+0x1e>
    panic("iderw: buf not busy");
80102792:	c7 04 24 5d 90 10 80 	movl   $0x8010905d,(%esp)
80102799:	e8 98 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	8b 00                	mov    (%eax),%eax
801027a3:	83 e0 06             	and    $0x6,%eax
801027a6:	83 f8 02             	cmp    $0x2,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x37>
    panic("iderw: nothing to do");
801027ab:	c7 04 24 71 90 10 80 	movl   $0x80109071,(%esp)
801027b2:	e8 7f dd ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
801027b7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ba:	8b 40 04             	mov    0x4(%eax),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	74 15                	je     801027d6 <iderw+0x56>
801027c1:	a1 78 c6 10 80       	mov    0x8010c678,%eax
801027c6:	85 c0                	test   %eax,%eax
801027c8:	75 0c                	jne    801027d6 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027ca:	c7 04 24 86 90 10 80 	movl   $0x80109086,(%esp)
801027d1:	e8 60 dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027d6:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801027dd:	e8 7e 2e 00 00       	call   80105660 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027e2:	8b 45 08             	mov    0x8(%ebp),%eax
801027e5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ec:	c7 45 f4 74 c6 10 80 	movl   $0x8010c674,-0xc(%ebp)
801027f3:	eb 0b                	jmp    80102800 <iderw+0x80>
801027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f8:	8b 00                	mov    (%eax),%eax
801027fa:	83 c0 14             	add    $0x14,%eax
801027fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102803:	8b 00                	mov    (%eax),%eax
80102805:	85 c0                	test   %eax,%eax
80102807:	75 ec                	jne    801027f5 <iderw+0x75>
    ;
  *pp = b;
80102809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010280c:	8b 55 08             	mov    0x8(%ebp),%edx
8010280f:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102811:	a1 74 c6 10 80       	mov    0x8010c674,%eax
80102816:	3b 45 08             	cmp    0x8(%ebp),%eax
80102819:	75 22                	jne    8010283d <iderw+0xbd>
    idestart(b);
8010281b:	8b 45 08             	mov    0x8(%ebp),%eax
8010281e:	89 04 24             	mov    %eax,(%esp)
80102821:	e8 72 fd ff ff       	call   80102598 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102826:	eb 15                	jmp    8010283d <iderw+0xbd>
    sleep(b, &idelock);
80102828:	c7 44 24 04 40 c6 10 	movl   $0x8010c640,0x4(%esp)
8010282f:	80 
80102830:	8b 45 08             	mov    0x8(%ebp),%eax
80102833:	89 04 24             	mov    %eax,(%esp)
80102836:	e8 a3 22 00 00       	call   80104ade <sleep>
8010283b:	eb 01                	jmp    8010283e <iderw+0xbe>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010283d:	90                   	nop
8010283e:	8b 45 08             	mov    0x8(%ebp),%eax
80102841:	8b 00                	mov    (%eax),%eax
80102843:	83 e0 06             	and    $0x6,%eax
80102846:	83 f8 02             	cmp    $0x2,%eax
80102849:	75 dd                	jne    80102828 <iderw+0xa8>
  }

  release(&idelock);
8010284b:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
80102852:	e8 6b 2e 00 00       	call   801056c2 <release>
}
80102857:	c9                   	leave  
80102858:	c3                   	ret    

80102859 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102859:	55                   	push   %ebp
8010285a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010285c:	a1 74 08 11 80       	mov    0x80110874,%eax
80102861:	8b 55 08             	mov    0x8(%ebp),%edx
80102864:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102866:	a1 74 08 11 80       	mov    0x80110874,%eax
8010286b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010286e:	5d                   	pop    %ebp
8010286f:	c3                   	ret    

80102870 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102873:	a1 74 08 11 80       	mov    0x80110874,%eax
80102878:	8b 55 08             	mov    0x8(%ebp),%edx
8010287b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010287d:	a1 74 08 11 80       	mov    0x80110874,%eax
80102882:	8b 55 0c             	mov    0xc(%ebp),%edx
80102885:	89 50 10             	mov    %edx,0x10(%eax)
}
80102888:	5d                   	pop    %ebp
80102889:	c3                   	ret    

8010288a <ioapicinit>:

void
ioapicinit(void)
{
8010288a:	55                   	push   %ebp
8010288b:	89 e5                	mov    %esp,%ebp
8010288d:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
80102890:	a1 44 09 11 80       	mov    0x80110944,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	0f 84 9a 00 00 00    	je     80102937 <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010289d:	c7 05 74 08 11 80 00 	movl   $0xfec00000,0x80110874
801028a4:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028ae:	e8 a6 ff ff ff       	call   80102859 <ioapicread>
801028b3:	c1 e8 10             	shr    $0x10,%eax
801028b6:	25 ff 00 00 00       	and    $0xff,%eax
801028bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028c5:	e8 8f ff ff ff       	call   80102859 <ioapicread>
801028ca:	c1 e8 18             	shr    $0x18,%eax
801028cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801028d0:	a0 40 09 11 80       	mov    0x80110940,%al
801028d5:	0f b6 c0             	movzbl %al,%eax
801028d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028db:	74 0c                	je     801028e9 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028dd:	c7 04 24 a4 90 10 80 	movl   $0x801090a4,(%esp)
801028e4:	e8 b8 da ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801028e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801028f0:	eb 3b                	jmp    8010292d <ioapicinit+0xa3>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028f5:	83 c0 20             	add    $0x20,%eax
801028f8:	0d 00 00 01 00       	or     $0x10000,%eax
801028fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102900:	83 c2 08             	add    $0x8,%edx
80102903:	d1 e2                	shl    %edx
80102905:	89 44 24 04          	mov    %eax,0x4(%esp)
80102909:	89 14 24             	mov    %edx,(%esp)
8010290c:	e8 5f ff ff ff       	call   80102870 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102914:	83 c0 08             	add    $0x8,%eax
80102917:	d1 e0                	shl    %eax
80102919:	40                   	inc    %eax
8010291a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102921:	00 
80102922:	89 04 24             	mov    %eax,(%esp)
80102925:	e8 46 ff ff ff       	call   80102870 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
8010292a:	ff 45 f4             	incl   -0xc(%ebp)
8010292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102930:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102933:	7e bd                	jle    801028f2 <ioapicinit+0x68>
80102935:	eb 01                	jmp    80102938 <ioapicinit+0xae>
    return;
80102937:	90                   	nop
  }
}
80102938:	c9                   	leave  
80102939:	c3                   	ret    

8010293a <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010293a:	55                   	push   %ebp
8010293b:	89 e5                	mov    %esp,%ebp
8010293d:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
80102940:	a1 44 09 11 80       	mov    0x80110944,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 37                	je     80102980 <ioapicenable+0x46>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102949:	8b 45 08             	mov    0x8(%ebp),%eax
8010294c:	83 c0 20             	add    $0x20,%eax
8010294f:	8b 55 08             	mov    0x8(%ebp),%edx
80102952:	83 c2 08             	add    $0x8,%edx
80102955:	d1 e2                	shl    %edx
80102957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010295b:	89 14 24             	mov    %edx,(%esp)
8010295e:	e8 0d ff ff ff       	call   80102870 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102963:	8b 45 0c             	mov    0xc(%ebp),%eax
80102966:	c1 e0 18             	shl    $0x18,%eax
80102969:	8b 55 08             	mov    0x8(%ebp),%edx
8010296c:	83 c2 08             	add    $0x8,%edx
8010296f:	d1 e2                	shl    %edx
80102971:	42                   	inc    %edx
80102972:	89 44 24 04          	mov    %eax,0x4(%esp)
80102976:	89 14 24             	mov    %edx,(%esp)
80102979:	e8 f2 fe ff ff       	call   80102870 <ioapicwrite>
8010297e:	eb 01                	jmp    80102981 <ioapicenable+0x47>
    return;
80102980:	90                   	nop
}
80102981:	c9                   	leave  
80102982:	c3                   	ret    

80102983 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102983:	55                   	push   %ebp
80102984:	89 e5                	mov    %esp,%ebp
80102986:	8b 45 08             	mov    0x8(%ebp),%eax
80102989:	05 00 00 00 80       	add    $0x80000000,%eax
8010298e:	5d                   	pop    %ebp
8010298f:	c3                   	ret    

80102990 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102996:	c7 44 24 04 d6 90 10 	movl   $0x801090d6,0x4(%esp)
8010299d:	80 
8010299e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
801029a5:	e8 95 2c 00 00       	call   8010563f <initlock>
  kmem.use_lock = 0;
801029aa:	c7 05 b4 08 11 80 00 	movl   $0x0,0x801108b4
801029b1:	00 00 00 
  freerange(vstart, vend);
801029b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801029b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029bb:	8b 45 08             	mov    0x8(%ebp),%eax
801029be:	89 04 24             	mov    %eax,(%esp)
801029c1:	e8 26 00 00 00       	call   801029ec <freerange>
}
801029c6:	c9                   	leave  
801029c7:	c3                   	ret    

801029c8 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801029c8:	55                   	push   %ebp
801029c9:	89 e5                	mov    %esp,%ebp
801029cb:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
801029ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801029d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d5:	8b 45 08             	mov    0x8(%ebp),%eax
801029d8:	89 04 24             	mov    %eax,(%esp)
801029db:	e8 0c 00 00 00       	call   801029ec <freerange>
  kmem.use_lock = 1;
801029e0:	c7 05 b4 08 11 80 01 	movl   $0x1,0x801108b4
801029e7:	00 00 00 
}
801029ea:	c9                   	leave  
801029eb:	c3                   	ret    

801029ec <freerange>:

void
freerange(void *vstart, void *vend)
{
801029ec:	55                   	push   %ebp
801029ed:	89 e5                	mov    %esp,%ebp
801029ef:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801029f2:	8b 45 08             	mov    0x8(%ebp),%eax
801029f5:	05 ff 0f 00 00       	add    $0xfff,%eax
801029fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a02:	eb 12                	jmp    80102a16 <freerange+0x2a>
    kfree(p);
80102a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a07:	89 04 24             	mov    %eax,(%esp)
80102a0a:	e8 16 00 00 00       	call   80102a25 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a0f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a19:	05 00 10 00 00       	add    $0x1000,%eax
80102a1e:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a21:	76 e1                	jbe    80102a04 <freerange+0x18>
}
80102a23:	c9                   	leave  
80102a24:	c3                   	ret    

80102a25 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a25:	55                   	push   %ebp
80102a26:	89 e5                	mov    %esp,%ebp
80102a28:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a2b:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2e:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a33:	85 c0                	test   %eax,%eax
80102a35:	75 1b                	jne    80102a52 <kfree+0x2d>
80102a37:	81 7d 08 bc 44 11 80 	cmpl   $0x801144bc,0x8(%ebp)
80102a3e:	72 12                	jb     80102a52 <kfree+0x2d>
80102a40:	8b 45 08             	mov    0x8(%ebp),%eax
80102a43:	89 04 24             	mov    %eax,(%esp)
80102a46:	e8 38 ff ff ff       	call   80102983 <v2p>
80102a4b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a50:	76 0c                	jbe    80102a5e <kfree+0x39>
    panic("kfree");
80102a52:	c7 04 24 db 90 10 80 	movl   $0x801090db,(%esp)
80102a59:	e8 d8 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a65:	00 
80102a66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a6d:	00 
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 39 2e 00 00       	call   801058b2 <memset>

  if(kmem.use_lock)
80102a79:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102a7e:	85 c0                	test   %eax,%eax
80102a80:	74 0c                	je     80102a8e <kfree+0x69>
    acquire(&kmem.lock);
80102a82:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102a89:	e8 d2 2b 00 00       	call   80105660 <acquire>
  r = (struct run*)v;
80102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102a94:	8b 15 b8 08 11 80    	mov    0x801108b8,%edx
80102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9d:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa2:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102aa7:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102aac:	85 c0                	test   %eax,%eax
80102aae:	74 0c                	je     80102abc <kfree+0x97>
    release(&kmem.lock);
80102ab0:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102ab7:	e8 06 2c 00 00       	call   801056c2 <release>
}
80102abc:	c9                   	leave  
80102abd:	c3                   	ret    

80102abe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102abe:	55                   	push   %ebp
80102abf:	89 e5                	mov    %esp,%ebp
80102ac1:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102ac4:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102ac9:	85 c0                	test   %eax,%eax
80102acb:	74 0c                	je     80102ad9 <kalloc+0x1b>
    acquire(&kmem.lock);
80102acd:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102ad4:	e8 87 2b 00 00       	call   80105660 <acquire>
  r = kmem.freelist;
80102ad9:	a1 b8 08 11 80       	mov    0x801108b8,%eax
80102ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ae5:	74 0a                	je     80102af1 <kalloc+0x33>
    kmem.freelist = r->next;
80102ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aea:	8b 00                	mov    (%eax),%eax
80102aec:	a3 b8 08 11 80       	mov    %eax,0x801108b8
  if(kmem.use_lock)
80102af1:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102af6:	85 c0                	test   %eax,%eax
80102af8:	74 0c                	je     80102b06 <kalloc+0x48>
    release(&kmem.lock);
80102afa:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102b01:	e8 bc 2b 00 00       	call   801056c2 <release>
  return (char*)r;
80102b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b09:	c9                   	leave  
80102b0a:	c3                   	ret    

80102b0b <inb>:
{
80102b0b:	55                   	push   %ebp
80102b0c:	89 e5                	mov    %esp,%ebp
80102b0e:	53                   	push   %ebx
80102b0f:	83 ec 14             	sub    $0x14,%esp
80102b12:	8b 45 08             	mov    0x8(%ebp),%eax
80102b15:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b19:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102b1c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102b20:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80102b24:	ec                   	in     (%dx),%al
80102b25:	88 c3                	mov    %al,%bl
80102b27:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102b2a:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80102b2d:	83 c4 14             	add    $0x14,%esp
80102b30:	5b                   	pop    %ebx
80102b31:	5d                   	pop    %ebp
80102b32:	c3                   	ret    

80102b33 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b33:	55                   	push   %ebp
80102b34:	89 e5                	mov    %esp,%ebp
80102b36:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b39:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b40:	e8 c6 ff ff ff       	call   80102b0b <inb>
80102b45:	0f b6 c0             	movzbl %al,%eax
80102b48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4e:	83 e0 01             	and    $0x1,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 0a                	jne    80102b5f <kbdgetc+0x2c>
    return -1;
80102b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b5a:	e9 21 01 00 00       	jmp    80102c80 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102b5f:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102b66:	e8 a0 ff ff ff       	call   80102b0b <inb>
80102b6b:	0f b6 c0             	movzbl %al,%eax
80102b6e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102b71:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102b78:	75 17                	jne    80102b91 <kbdgetc+0x5e>
    shift |= E0ESC;
80102b7a:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102b7f:	83 c8 40             	or     $0x40,%eax
80102b82:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102b87:	b8 00 00 00 00       	mov    $0x0,%eax
80102b8c:	e9 ef 00 00 00       	jmp    80102c80 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b94:	25 80 00 00 00       	and    $0x80,%eax
80102b99:	85 c0                	test   %eax,%eax
80102b9b:	74 44                	je     80102be1 <kbdgetc+0xae>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102b9d:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102ba2:	83 e0 40             	and    $0x40,%eax
80102ba5:	85 c0                	test   %eax,%eax
80102ba7:	75 08                	jne    80102bb1 <kbdgetc+0x7e>
80102ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bac:	83 e0 7f             	and    $0x7f,%eax
80102baf:	eb 03                	jmp    80102bb4 <kbdgetc+0x81>
80102bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bba:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102bbf:	8a 00                	mov    (%eax),%al
80102bc1:	83 c8 40             	or     $0x40,%eax
80102bc4:	0f b6 c0             	movzbl %al,%eax
80102bc7:	f7 d0                	not    %eax
80102bc9:	89 c2                	mov    %eax,%edx
80102bcb:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102bd0:	21 d0                	and    %edx,%eax
80102bd2:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
    return 0;
80102bd7:	b8 00 00 00 00       	mov    $0x0,%eax
80102bdc:	e9 9f 00 00 00       	jmp    80102c80 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102be1:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102be6:	83 e0 40             	and    $0x40,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	74 14                	je     80102c01 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bed:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102bf4:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102bf9:	83 e0 bf             	and    $0xffffffbf,%eax
80102bfc:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  }

  shift |= shiftcode[data];
80102c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c04:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c09:	8a 00                	mov    (%eax),%al
80102c0b:	0f b6 d0             	movzbl %al,%edx
80102c0e:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102c13:	09 d0                	or     %edx,%eax
80102c15:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  shift ^= togglecode[data];
80102c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c1d:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c22:	8a 00                	mov    (%eax),%al
80102c24:	0f b6 d0             	movzbl %al,%edx
80102c27:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102c2c:	31 d0                	xor    %edx,%eax
80102c2e:	a3 7c c6 10 80       	mov    %eax,0x8010c67c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c33:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102c38:	83 e0 03             	and    $0x3,%eax
80102c3b:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c45:	01 d0                	add    %edx,%eax
80102c47:	8a 00                	mov    (%eax),%al
80102c49:	0f b6 c0             	movzbl %al,%eax
80102c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c4f:	a1 7c c6 10 80       	mov    0x8010c67c,%eax
80102c54:	83 e0 08             	and    $0x8,%eax
80102c57:	85 c0                	test   %eax,%eax
80102c59:	74 22                	je     80102c7d <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102c5b:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102c5f:	76 0c                	jbe    80102c6d <kbdgetc+0x13a>
80102c61:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102c65:	77 06                	ja     80102c6d <kbdgetc+0x13a>
      c += 'A' - 'a';
80102c67:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102c6b:	eb 10                	jmp    80102c7d <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102c6d:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102c71:	76 0a                	jbe    80102c7d <kbdgetc+0x14a>
80102c73:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102c77:	77 04                	ja     80102c7d <kbdgetc+0x14a>
      c += 'a' - 'A';
80102c79:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102c7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102c80:	c9                   	leave  
80102c81:	c3                   	ret    

80102c82 <kbdintr>:

void
kbdintr(void)
{
80102c82:	55                   	push   %ebp
80102c83:	89 e5                	mov    %esp,%ebp
80102c85:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102c88:	c7 04 24 33 2b 10 80 	movl   $0x80102b33,(%esp)
80102c8f:	e8 fc da ff ff       	call   80100790 <consoleintr>
}
80102c94:	c9                   	leave  
80102c95:	c3                   	ret    

80102c96 <outb>:
{
80102c96:	55                   	push   %ebp
80102c97:	89 e5                	mov    %esp,%ebp
80102c99:	83 ec 08             	sub    $0x8,%esp
80102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80102c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102ca2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102ca6:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca9:	8a 45 f8             	mov    -0x8(%ebp),%al
80102cac:	8b 55 fc             	mov    -0x4(%ebp),%edx
80102caf:	ee                   	out    %al,(%dx)
}
80102cb0:	c9                   	leave  
80102cb1:	c3                   	ret    

80102cb2 <readeflags>:
{
80102cb2:	55                   	push   %ebp
80102cb3:	89 e5                	mov    %esp,%ebp
80102cb5:	53                   	push   %ebx
80102cb6:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102cb9:	9c                   	pushf  
80102cba:	5b                   	pop    %ebx
80102cbb:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102cbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cc1:	83 c4 10             	add    $0x10,%esp
80102cc4:	5b                   	pop    %ebx
80102cc5:	5d                   	pop    %ebp
80102cc6:	c3                   	ret    

80102cc7 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102cc7:	55                   	push   %ebp
80102cc8:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102cca:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ccf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd2:	c1 e2 02             	shl    $0x2,%edx
80102cd5:	01 c2                	add    %eax,%edx
80102cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cda:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102cdc:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102ce1:	83 c0 20             	add    $0x20,%eax
80102ce4:	8b 00                	mov    (%eax),%eax
}
80102ce6:	5d                   	pop    %ebp
80102ce7:	c3                   	ret    

80102ce8 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102ce8:	55                   	push   %ebp
80102ce9:	89 e5                	mov    %esp,%ebp
80102ceb:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102cee:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102cf3:	85 c0                	test   %eax,%eax
80102cf5:	0f 84 47 01 00 00    	je     80102e42 <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102cfb:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d02:	00 
80102d03:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d0a:	e8 b8 ff ff ff       	call   80102cc7 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d0f:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d16:	00 
80102d17:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d1e:	e8 a4 ff ff ff       	call   80102cc7 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d23:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d2a:	00 
80102d2b:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d32:	e8 90 ff ff ff       	call   80102cc7 <lapicw>
  lapicw(TICR, 10000000); 
80102d37:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d3e:	00 
80102d3f:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d46:	e8 7c ff ff ff       	call   80102cc7 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d4b:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d52:	00 
80102d53:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102d5a:	e8 68 ff ff ff       	call   80102cc7 <lapicw>
  lapicw(LINT1, MASKED);
80102d5f:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d66:	00 
80102d67:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102d6e:	e8 54 ff ff ff       	call   80102cc7 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102d73:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102d78:	83 c0 30             	add    $0x30,%eax
80102d7b:	8b 00                	mov    (%eax),%eax
80102d7d:	c1 e8 10             	shr    $0x10,%eax
80102d80:	25 ff 00 00 00       	and    $0xff,%eax
80102d85:	83 f8 03             	cmp    $0x3,%eax
80102d88:	76 14                	jbe    80102d9e <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102d8a:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d91:	00 
80102d92:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102d99:	e8 29 ff ff ff       	call   80102cc7 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102d9e:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102da5:	00 
80102da6:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102dad:	e8 15 ff ff ff       	call   80102cc7 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102db2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102db9:	00 
80102dba:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dc1:	e8 01 ff ff ff       	call   80102cc7 <lapicw>
  lapicw(ESR, 0);
80102dc6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102dcd:	00 
80102dce:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102dd5:	e8 ed fe ff ff       	call   80102cc7 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102dda:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102de1:	00 
80102de2:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102de9:	e8 d9 fe ff ff       	call   80102cc7 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102dee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102df5:	00 
80102df6:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102dfd:	e8 c5 fe ff ff       	call   80102cc7 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e02:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e09:	00 
80102e0a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e11:	e8 b1 fe ff ff       	call   80102cc7 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e16:	90                   	nop
80102e17:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e1c:	05 00 03 00 00       	add    $0x300,%eax
80102e21:	8b 00                	mov    (%eax),%eax
80102e23:	25 00 10 00 00       	and    $0x1000,%eax
80102e28:	85 c0                	test   %eax,%eax
80102e2a:	75 eb                	jne    80102e17 <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e2c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e33:	00 
80102e34:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e3b:	e8 87 fe ff ff       	call   80102cc7 <lapicw>
80102e40:	eb 01                	jmp    80102e43 <lapicinit+0x15b>
    return;
80102e42:	90                   	nop
}
80102e43:	c9                   	leave  
80102e44:	c3                   	ret    

80102e45 <cpunum>:

int
cpunum(void)
{
80102e45:	55                   	push   %ebp
80102e46:	89 e5                	mov    %esp,%ebp
80102e48:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e4b:	e8 62 fe ff ff       	call   80102cb2 <readeflags>
80102e50:	25 00 02 00 00       	and    $0x200,%eax
80102e55:	85 c0                	test   %eax,%eax
80102e57:	74 27                	je     80102e80 <cpunum+0x3b>
    static int n;
    if(n++ == 0)
80102e59:	a1 80 c6 10 80       	mov    0x8010c680,%eax
80102e5e:	85 c0                	test   %eax,%eax
80102e60:	0f 94 c2             	sete   %dl
80102e63:	40                   	inc    %eax
80102e64:	a3 80 c6 10 80       	mov    %eax,0x8010c680
80102e69:	84 d2                	test   %dl,%dl
80102e6b:	74 13                	je     80102e80 <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e6d:	8b 45 04             	mov    0x4(%ebp),%eax
80102e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e74:	c7 04 24 e4 90 10 80 	movl   $0x801090e4,(%esp)
80102e7b:	e8 21 d5 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e80:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e85:	85 c0                	test   %eax,%eax
80102e87:	74 0f                	je     80102e98 <cpunum+0x53>
    return lapic[ID]>>24;
80102e89:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102e8e:	83 c0 20             	add    $0x20,%eax
80102e91:	8b 00                	mov    (%eax),%eax
80102e93:	c1 e8 18             	shr    $0x18,%eax
80102e96:	eb 05                	jmp    80102e9d <cpunum+0x58>
  return 0;
80102e98:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102e9d:	c9                   	leave  
80102e9e:	c3                   	ret    

80102e9f <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102e9f:	55                   	push   %ebp
80102ea0:	89 e5                	mov    %esp,%ebp
80102ea2:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102ea5:	a1 bc 08 11 80       	mov    0x801108bc,%eax
80102eaa:	85 c0                	test   %eax,%eax
80102eac:	74 14                	je     80102ec2 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102eae:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eb5:	00 
80102eb6:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ebd:	e8 05 fe ff ff       	call   80102cc7 <lapicw>
}
80102ec2:	c9                   	leave  
80102ec3:	c3                   	ret    

80102ec4 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102ec4:	55                   	push   %ebp
80102ec5:	89 e5                	mov    %esp,%ebp
}
80102ec7:	5d                   	pop    %ebp
80102ec8:	c3                   	ret    

80102ec9 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102ec9:	55                   	push   %ebp
80102eca:	89 e5                	mov    %esp,%ebp
80102ecc:	83 ec 1c             	sub    $0x1c,%esp
80102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ed2:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102ed5:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102edc:	00 
80102edd:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102ee4:	e8 ad fd ff ff       	call   80102c96 <outb>
  outb(IO_RTC+1, 0x0A);
80102ee9:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102ef0:	00 
80102ef1:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102ef8:	e8 99 fd ff ff       	call   80102c96 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102efd:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f07:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f0f:	8d 50 02             	lea    0x2(%eax),%edx
80102f12:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f15:	c1 e8 04             	shr    $0x4,%eax
80102f18:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f1b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f1f:	c1 e0 18             	shl    $0x18,%eax
80102f22:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f26:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f2d:	e8 95 fd ff ff       	call   80102cc7 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f32:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f39:	00 
80102f3a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f41:	e8 81 fd ff ff       	call   80102cc7 <lapicw>
  microdelay(200);
80102f46:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f4d:	e8 72 ff ff ff       	call   80102ec4 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f52:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102f59:	00 
80102f5a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f61:	e8 61 fd ff ff       	call   80102cc7 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102f66:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102f6d:	e8 52 ff ff ff       	call   80102ec4 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102f72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102f79:	eb 3f                	jmp    80102fba <lapicstartap+0xf1>
    lapicw(ICRHI, apicid<<24);
80102f7b:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f7f:	c1 e0 18             	shl    $0x18,%eax
80102f82:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f86:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f8d:	e8 35 fd ff ff       	call   80102cc7 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102f92:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f95:	c1 e8 0c             	shr    $0xc,%eax
80102f98:	80 cc 06             	or     $0x6,%ah
80102f9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f9f:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fa6:	e8 1c fd ff ff       	call   80102cc7 <lapicw>
    microdelay(200);
80102fab:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fb2:	e8 0d ff ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 2; i++){
80102fb7:	ff 45 fc             	incl   -0x4(%ebp)
80102fba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80102fbe:	7e bb                	jle    80102f7b <lapicstartap+0xb2>
  }
}
80102fc0:	c9                   	leave  
80102fc1:	c3                   	ret    

80102fc2 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80102fc2:	55                   	push   %ebp
80102fc3:	89 e5                	mov    %esp,%ebp
80102fc5:	81 ec 88 00 00 00    	sub    $0x88,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102fcb:	c7 44 24 04 10 91 10 	movl   $0x80109110,0x4(%esp)
80102fd2:	80 
80102fd3:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80102fda:	e8 60 26 00 00       	call   8010563f <initlock>
  readsb(ROOTDEV, &sb);
80102fdf:	8d 45 88             	lea    -0x78(%ebp),%eax
80102fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102fed:	e8 c1 e2 ff ff       	call   801012b3 <readsb>
  log.start = sb.size - sb.nlog;
80102ff2:	8b 55 88             	mov    -0x78(%ebp),%edx
80102ff5:	8b 45 94             	mov    -0x6c(%ebp),%eax
80102ff8:	89 d1                	mov    %edx,%ecx
80102ffa:	29 c1                	sub    %eax,%ecx
80102ffc:	89 c8                	mov    %ecx,%eax
80102ffe:	a3 f4 08 11 80       	mov    %eax,0x801108f4
  log.size = sb.nlog;
80103003:	8b 45 94             	mov    -0x6c(%ebp),%eax
80103006:	a3 f8 08 11 80       	mov    %eax,0x801108f8
  log.dev = ROOTDEV;
8010300b:	c7 05 00 09 11 80 01 	movl   $0x1,0x80110900
80103012:	00 00 00 
  recover_from_log();
80103015:	e8 95 01 00 00       	call   801031af <recover_from_log>
}
8010301a:	c9                   	leave  
8010301b:	c3                   	ret    

8010301c <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010301c:	55                   	push   %ebp
8010301d:	89 e5                	mov    %esp,%ebp
8010301f:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103022:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103029:	e9 89 00 00 00       	jmp    801030b7 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010302e:	8b 15 f4 08 11 80    	mov    0x801108f4,%edx
80103034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103037:	01 d0                	add    %edx,%eax
80103039:	40                   	inc    %eax
8010303a:	89 c2                	mov    %eax,%edx
8010303c:	a1 00 09 11 80       	mov    0x80110900,%eax
80103041:	89 54 24 04          	mov    %edx,0x4(%esp)
80103045:	89 04 24             	mov    %eax,(%esp)
80103048:	e8 59 d1 ff ff       	call   801001a6 <bread>
8010304d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103053:	83 c0 10             	add    $0x10,%eax
80103056:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
8010305d:	89 c2                	mov    %eax,%edx
8010305f:	a1 00 09 11 80       	mov    0x80110900,%eax
80103064:	89 54 24 04          	mov    %edx,0x4(%esp)
80103068:	89 04 24             	mov    %eax,(%esp)
8010306b:	e8 36 d1 ff ff       	call   801001a6 <bread>
80103070:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103073:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103076:	8d 50 18             	lea    0x18(%eax),%edx
80103079:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010307c:	83 c0 18             	add    $0x18,%eax
8010307f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103086:	00 
80103087:	89 54 24 04          	mov    %edx,0x4(%esp)
8010308b:	89 04 24             	mov    %eax,(%esp)
8010308e:	e8 eb 28 00 00       	call   8010597e <memmove>
    bwrite(dbuf);  // write dst to disk
80103093:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103096:	89 04 24             	mov    %eax,(%esp)
80103099:	e8 3f d1 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
8010309e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030a1:	89 04 24             	mov    %eax,(%esp)
801030a4:	e8 6e d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030ac:	89 04 24             	mov    %eax,(%esp)
801030af:	e8 63 d1 ff ff       	call   80100217 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030b4:	ff 45 f4             	incl   -0xc(%ebp)
801030b7:	a1 04 09 11 80       	mov    0x80110904,%eax
801030bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801030bf:	0f 8f 69 ff ff ff    	jg     8010302e <install_trans+0x12>
  }
}
801030c5:	c9                   	leave  
801030c6:	c3                   	ret    

801030c7 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801030c7:	55                   	push   %ebp
801030c8:	89 e5                	mov    %esp,%ebp
801030ca:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801030cd:	a1 f4 08 11 80       	mov    0x801108f4,%eax
801030d2:	89 c2                	mov    %eax,%edx
801030d4:	a1 00 09 11 80       	mov    0x80110900,%eax
801030d9:	89 54 24 04          	mov    %edx,0x4(%esp)
801030dd:	89 04 24             	mov    %eax,(%esp)
801030e0:	e8 c1 d0 ff ff       	call   801001a6 <bread>
801030e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
801030e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030eb:	83 c0 18             	add    $0x18,%eax
801030ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801030f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030f4:	8b 00                	mov    (%eax),%eax
801030f6:	a3 04 09 11 80       	mov    %eax,0x80110904
  for (i = 0; i < log.lh.n; i++) {
801030fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103102:	eb 1a                	jmp    8010311e <read_head+0x57>
    log.lh.sector[i] = lh->sector[i];
80103104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103107:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010310a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010310e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103111:	83 c2 10             	add    $0x10,%edx
80103114:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010311b:	ff 45 f4             	incl   -0xc(%ebp)
8010311e:	a1 04 09 11 80       	mov    0x80110904,%eax
80103123:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103126:	7f dc                	jg     80103104 <read_head+0x3d>
  }
  brelse(buf);
80103128:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010312b:	89 04 24             	mov    %eax,(%esp)
8010312e:	e8 e4 d0 ff ff       	call   80100217 <brelse>
}
80103133:	c9                   	leave  
80103134:	c3                   	ret    

80103135 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103135:	55                   	push   %ebp
80103136:	89 e5                	mov    %esp,%ebp
80103138:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
8010313b:	a1 f4 08 11 80       	mov    0x801108f4,%eax
80103140:	89 c2                	mov    %eax,%edx
80103142:	a1 00 09 11 80       	mov    0x80110900,%eax
80103147:	89 54 24 04          	mov    %edx,0x4(%esp)
8010314b:	89 04 24             	mov    %eax,(%esp)
8010314e:	e8 53 d0 ff ff       	call   801001a6 <bread>
80103153:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
80103156:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103159:	83 c0 18             	add    $0x18,%eax
8010315c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
8010315f:	8b 15 04 09 11 80    	mov    0x80110904,%edx
80103165:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103168:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010316a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103171:	eb 1a                	jmp    8010318d <write_head+0x58>
    hb->sector[i] = log.lh.sector[i];
80103173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103176:	83 c0 10             	add    $0x10,%eax
80103179:	8b 0c 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%ecx
80103180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103183:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103186:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010318a:	ff 45 f4             	incl   -0xc(%ebp)
8010318d:	a1 04 09 11 80       	mov    0x80110904,%eax
80103192:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103195:	7f dc                	jg     80103173 <write_head+0x3e>
  }
  bwrite(buf);
80103197:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010319a:	89 04 24             	mov    %eax,(%esp)
8010319d:	e8 3b d0 ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a5:	89 04 24             	mov    %eax,(%esp)
801031a8:	e8 6a d0 ff ff       	call   80100217 <brelse>
}
801031ad:	c9                   	leave  
801031ae:	c3                   	ret    

801031af <recover_from_log>:

static void
recover_from_log(void)
{
801031af:	55                   	push   %ebp
801031b0:	89 e5                	mov    %esp,%ebp
801031b2:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801031b5:	e8 0d ff ff ff       	call   801030c7 <read_head>
  install_trans(); // if committed, copy from log to disk
801031ba:	e8 5d fe ff ff       	call   8010301c <install_trans>
  log.lh.n = 0;
801031bf:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
801031c6:	00 00 00 
  write_head(); // clear the log
801031c9:	e8 67 ff ff ff       	call   80103135 <write_head>
}
801031ce:	c9                   	leave  
801031cf:	c3                   	ret    

801031d0 <begin_trans>:

void
begin_trans(void)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
801031d6:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801031dd:	e8 7e 24 00 00       	call   80105660 <acquire>
  while (log.busy) {
801031e2:	eb 14                	jmp    801031f8 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e4:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
801031eb:	80 
801031ec:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801031f3:	e8 e6 18 00 00       	call   80104ade <sleep>
  while (log.busy) {
801031f8:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801031fd:	85 c0                	test   %eax,%eax
801031ff:	75 e3                	jne    801031e4 <begin_trans+0x14>
  }
  log.busy = 1;
80103201:	c7 05 fc 08 11 80 01 	movl   $0x1,0x801108fc
80103208:	00 00 00 
  release(&log.lock);
8010320b:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103212:	e8 ab 24 00 00       	call   801056c2 <release>
}
80103217:	c9                   	leave  
80103218:	c3                   	ret    

80103219 <commit_trans>:

void
commit_trans(void)
{
80103219:	55                   	push   %ebp
8010321a:	89 e5                	mov    %esp,%ebp
8010321c:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010321f:	a1 04 09 11 80       	mov    0x80110904,%eax
80103224:	85 c0                	test   %eax,%eax
80103226:	7e 19                	jle    80103241 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103228:	e8 08 ff ff ff       	call   80103135 <write_head>
    install_trans(); // Now install writes to home locations
8010322d:	e8 ea fd ff ff       	call   8010301c <install_trans>
    log.lh.n = 0; 
80103232:	c7 05 04 09 11 80 00 	movl   $0x0,0x80110904
80103239:	00 00 00 
    write_head();    // Erase the transaction from the log
8010323c:	e8 f4 fe ff ff       	call   80103135 <write_head>
  }
  
  acquire(&log.lock);
80103241:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80103248:	e8 13 24 00 00       	call   80105660 <acquire>
  log.busy = 0;
8010324d:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
80103254:	00 00 00 
  wakeup(&log);
80103257:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010325e:	e8 83 19 00 00       	call   80104be6 <wakeup>
  release(&log.lock);
80103263:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010326a:	e8 53 24 00 00       	call   801056c2 <release>
}
8010326f:	c9                   	leave  
80103270:	c3                   	ret    

80103271 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103271:	55                   	push   %ebp
80103272:	89 e5                	mov    %esp,%ebp
80103274:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103277:	a1 04 09 11 80       	mov    0x80110904,%eax
8010327c:	83 f8 09             	cmp    $0x9,%eax
8010327f:	7f 10                	jg     80103291 <log_write+0x20>
80103281:	a1 04 09 11 80       	mov    0x80110904,%eax
80103286:	8b 15 f8 08 11 80    	mov    0x801108f8,%edx
8010328c:	4a                   	dec    %edx
8010328d:	39 d0                	cmp    %edx,%eax
8010328f:	7c 0c                	jl     8010329d <log_write+0x2c>
    panic("too big a transaction");
80103291:	c7 04 24 14 91 10 80 	movl   $0x80109114,(%esp)
80103298:	e8 99 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010329d:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	75 0c                	jne    801032b2 <log_write+0x41>
    panic("write outside of trans");
801032a6:	c7 04 24 2a 91 10 80 	movl   $0x8010912a,(%esp)
801032ad:	e8 84 d2 ff ff       	call   80100536 <panic>

  for (i = 0; i < log.lh.n; i++) {
801032b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032b9:	eb 1c                	jmp    801032d7 <log_write+0x66>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032be:	83 c0 10             	add    $0x10,%eax
801032c1:	8b 04 85 c8 08 11 80 	mov    -0x7feef738(,%eax,4),%eax
801032c8:	89 c2                	mov    %eax,%edx
801032ca:	8b 45 08             	mov    0x8(%ebp),%eax
801032cd:	8b 40 08             	mov    0x8(%eax),%eax
801032d0:	39 c2                	cmp    %eax,%edx
801032d2:	74 0f                	je     801032e3 <log_write+0x72>
  for (i = 0; i < log.lh.n; i++) {
801032d4:	ff 45 f4             	incl   -0xc(%ebp)
801032d7:	a1 04 09 11 80       	mov    0x80110904,%eax
801032dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801032df:	7f da                	jg     801032bb <log_write+0x4a>
801032e1:	eb 01                	jmp    801032e4 <log_write+0x73>
      break;
801032e3:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
801032e4:	8b 45 08             	mov    0x8(%ebp),%eax
801032e7:	8b 40 08             	mov    0x8(%eax),%eax
801032ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801032ed:	83 c2 10             	add    $0x10,%edx
801032f0:	89 04 95 c8 08 11 80 	mov    %eax,-0x7feef738(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801032f7:	8b 15 f4 08 11 80    	mov    0x801108f4,%edx
801032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103300:	01 d0                	add    %edx,%eax
80103302:	40                   	inc    %eax
80103303:	89 c2                	mov    %eax,%edx
80103305:	8b 45 08             	mov    0x8(%ebp),%eax
80103308:	8b 40 04             	mov    0x4(%eax),%eax
8010330b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010330f:	89 04 24             	mov    %eax,(%esp)
80103312:	e8 8f ce ff ff       	call   801001a6 <bread>
80103317:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
8010331a:	8b 45 08             	mov    0x8(%ebp),%eax
8010331d:	8d 50 18             	lea    0x18(%eax),%edx
80103320:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103323:	83 c0 18             	add    $0x18,%eax
80103326:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010332d:	00 
8010332e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103332:	89 04 24             	mov    %eax,(%esp)
80103335:	e8 44 26 00 00       	call   8010597e <memmove>
  bwrite(lbuf);
8010333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333d:	89 04 24             	mov    %eax,(%esp)
80103340:	e8 98 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103345:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103348:	89 04 24             	mov    %eax,(%esp)
8010334b:	e8 c7 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103350:	a1 04 09 11 80       	mov    0x80110904,%eax
80103355:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103358:	75 0b                	jne    80103365 <log_write+0xf4>
    log.lh.n++;
8010335a:	a1 04 09 11 80       	mov    0x80110904,%eax
8010335f:	40                   	inc    %eax
80103360:	a3 04 09 11 80       	mov    %eax,0x80110904
  b->flags |= B_DIRTY; // XXX prevent eviction
80103365:	8b 45 08             	mov    0x8(%ebp),%eax
80103368:	8b 00                	mov    (%eax),%eax
8010336a:	89 c2                	mov    %eax,%edx
8010336c:	83 ca 04             	or     $0x4,%edx
8010336f:	8b 45 08             	mov    0x8(%ebp),%eax
80103372:	89 10                	mov    %edx,(%eax)
}
80103374:	c9                   	leave  
80103375:	c3                   	ret    

80103376 <v2p>:
80103376:	55                   	push   %ebp
80103377:	89 e5                	mov    %esp,%ebp
80103379:	8b 45 08             	mov    0x8(%ebp),%eax
8010337c:	05 00 00 00 80       	add    $0x80000000,%eax
80103381:	5d                   	pop    %ebp
80103382:	c3                   	ret    

80103383 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103383:	55                   	push   %ebp
80103384:	89 e5                	mov    %esp,%ebp
80103386:	8b 45 08             	mov    0x8(%ebp),%eax
80103389:	05 00 00 00 80       	add    $0x80000000,%eax
8010338e:	5d                   	pop    %ebp
8010338f:	c3                   	ret    

80103390 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	53                   	push   %ebx
80103394:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80103397:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
8010339a:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
8010339d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
801033a0:	89 c3                	mov    %eax,%ebx
801033a2:	89 d8                	mov    %ebx,%eax
801033a4:	f0 87 02             	lock xchg %eax,(%edx)
801033a7:	89 c3                	mov    %eax,%ebx
801033a9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "1" (newval) :
               "cc");
  return result;
801033ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801033af:	83 c4 10             	add    $0x10,%esp
801033b2:	5b                   	pop    %ebx
801033b3:	5d                   	pop    %ebp
801033b4:	c3                   	ret    

801033b5 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801033b5:	55                   	push   %ebp
801033b6:	89 e5                	mov    %esp,%ebp
801033b8:	83 e4 f0             	and    $0xfffffff0,%esp
801033bb:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801033be:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
801033c5:	80 
801033c6:	c7 04 24 bc 44 11 80 	movl   $0x801144bc,(%esp)
801033cd:	e8 be f5 ff ff       	call   80102990 <kinit1>
  kvmalloc();      // kernel page table
801033d2:	e8 bc 52 00 00       	call   80108693 <kvmalloc>
  mpinit();        // collect info about this machine
801033d7:	e8 93 04 00 00       	call   8010386f <mpinit>
  lapicinit();
801033dc:	e8 07 f9 ff ff       	call   80102ce8 <lapicinit>
  seginit();       // set up segments
801033e1:	e8 69 4c 00 00       	call   8010804f <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033ec:	8a 00                	mov    (%eax),%al
801033ee:	0f b6 c0             	movzbl %al,%eax
801033f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f5:	c7 04 24 41 91 10 80 	movl   $0x80109141,(%esp)
801033fc:	e8 a0 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103401:	e8 cf 06 00 00       	call   80103ad5 <picinit>
  ioapicinit();    // another interrupt controller
80103406:	e8 7f f4 ff ff       	call   8010288a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010340b:	e8 4d d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103410:	e8 8f 3f 00 00       	call   801073a4 <uartinit>
  pinit();         // process table
80103415:	e8 c9 0b 00 00       	call   80103fe3 <pinit>
  tvinit();        // trap vectors
8010341a:	e8 38 3b 00 00       	call   80106f57 <tvinit>
  binit();         // buffer cache
8010341f:	e8 10 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103424:	e8 ae da ff ff       	call   80100ed7 <fileinit>
  iinit();         // inode cache
80103429:	e8 59 e1 ff ff       	call   80101587 <iinit>
  ideinit();       // disk
8010342e:	e8 c2 f0 ff ff       	call   801024f5 <ideinit>
  if(!ismp)
80103433:	a1 44 09 11 80       	mov    0x80110944,%eax
80103438:	85 c0                	test   %eax,%eax
8010343a:	75 05                	jne    80103441 <main+0x8c>
    timerinit();   // uniprocessor timer
8010343c:	e8 5e 3a 00 00       	call   80106e9f <timerinit>
  startothers();   // start other processors
80103441:	e8 7e 00 00 00       	call   801034c4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103446:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010344d:	8e 
8010344e:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103455:	e8 6e f5 ff ff       	call   801029c8 <kinit2>
  userinit();      // first user process
8010345a:	e8 83 0e 00 00       	call   801042e2 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010345f:	e8 1a 00 00 00       	call   8010347e <mpmain>

80103464 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103464:	55                   	push   %ebp
80103465:	89 e5                	mov    %esp,%ebp
80103467:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
8010346a:	e8 3b 52 00 00       	call   801086aa <switchkvm>
  seginit();
8010346f:	e8 db 4b 00 00       	call   8010804f <seginit>
  lapicinit();
80103474:	e8 6f f8 ff ff       	call   80102ce8 <lapicinit>
  mpmain();
80103479:	e8 00 00 00 00       	call   8010347e <mpmain>

8010347e <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010347e:	55                   	push   %ebp
8010347f:	89 e5                	mov    %esp,%ebp
80103481:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103484:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010348a:	8a 00                	mov    (%eax),%al
8010348c:	0f b6 c0             	movzbl %al,%eax
8010348f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103493:	c7 04 24 58 91 10 80 	movl   $0x80109158,(%esp)
8010349a:	e8 02 cf ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
8010349f:	e8 10 3c 00 00       	call   801070b4 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034aa:	05 a8 00 00 00       	add    $0xa8,%eax
801034af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034b6:	00 
801034b7:	89 04 24             	mov    %eax,(%esp)
801034ba:	e8 d1 fe ff ff       	call   80103390 <xchg>
  scheduler();     // start running processes
801034bf:	e8 20 14 00 00       	call   801048e4 <scheduler>

801034c4 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034c4:	55                   	push   %ebp
801034c5:	89 e5                	mov    %esp,%ebp
801034c7:	53                   	push   %ebx
801034c8:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034cb:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801034d2:	e8 ac fe ff ff       	call   80103383 <p2v>
801034d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801034da:	b8 8a 00 00 00       	mov    $0x8a,%eax
801034df:	89 44 24 08          	mov    %eax,0x8(%esp)
801034e3:	c7 44 24 04 4c c5 10 	movl   $0x8010c54c,0x4(%esp)
801034ea:	80 
801034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ee:	89 04 24             	mov    %eax,(%esp)
801034f1:	e8 88 24 00 00       	call   8010597e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801034f6:	c7 45 f4 60 09 11 80 	movl   $0x80110960,-0xc(%ebp)
801034fd:	e9 8f 00 00 00       	jmp    80103591 <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
80103502:	e8 3e f9 ff ff       	call   80102e45 <cpunum>
80103507:	89 c2                	mov    %eax,%edx
80103509:	89 d0                	mov    %edx,%eax
8010350b:	d1 e0                	shl    %eax
8010350d:	01 d0                	add    %edx,%eax
8010350f:	c1 e0 04             	shl    $0x4,%eax
80103512:	29 d0                	sub    %edx,%eax
80103514:	c1 e0 02             	shl    $0x2,%eax
80103517:	05 60 09 11 80       	add    $0x80110960,%eax
8010351c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010351f:	74 68                	je     80103589 <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103521:	e8 98 f5 ff ff       	call   80102abe <kalloc>
80103526:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103529:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010352c:	83 e8 04             	sub    $0x4,%eax
8010352f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103532:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103538:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
8010353a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010353d:	83 e8 08             	sub    $0x8,%eax
80103540:	c7 00 64 34 10 80    	movl   $0x80103464,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103546:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103549:	8d 58 f4             	lea    -0xc(%eax),%ebx
8010354c:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
80103553:	e8 1e fe ff ff       	call   80103376 <v2p>
80103558:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
8010355a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010355d:	89 04 24             	mov    %eax,(%esp)
80103560:	e8 11 fe ff ff       	call   80103376 <v2p>
80103565:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103568:	8a 12                	mov    (%edx),%dl
8010356a:	0f b6 d2             	movzbl %dl,%edx
8010356d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103571:	89 14 24             	mov    %edx,(%esp)
80103574:	e8 50 f9 ff ff       	call   80102ec9 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103579:	90                   	nop
8010357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010357d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103583:	85 c0                	test   %eax,%eax
80103585:	74 f3                	je     8010357a <startothers+0xb6>
80103587:	eb 01                	jmp    8010358a <startothers+0xc6>
      continue;
80103589:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
8010358a:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103591:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103596:	89 c2                	mov    %eax,%edx
80103598:	89 d0                	mov    %edx,%eax
8010359a:	d1 e0                	shl    %eax
8010359c:	01 d0                	add    %edx,%eax
8010359e:	c1 e0 04             	shl    $0x4,%eax
801035a1:	29 d0                	sub    %edx,%eax
801035a3:	c1 e0 02             	shl    $0x2,%eax
801035a6:	05 60 09 11 80       	add    $0x80110960,%eax
801035ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ae:	0f 87 4e ff ff ff    	ja     80103502 <startothers+0x3e>
      ;
  }
}
801035b4:	83 c4 24             	add    $0x24,%esp
801035b7:	5b                   	pop    %ebx
801035b8:	5d                   	pop    %ebp
801035b9:	c3                   	ret    

801035ba <p2v>:
801035ba:	55                   	push   %ebp
801035bb:	89 e5                	mov    %esp,%ebp
801035bd:	8b 45 08             	mov    0x8(%ebp),%eax
801035c0:	05 00 00 00 80       	add    $0x80000000,%eax
801035c5:	5d                   	pop    %ebp
801035c6:	c3                   	ret    

801035c7 <inb>:
{
801035c7:	55                   	push   %ebp
801035c8:	89 e5                	mov    %esp,%ebp
801035ca:	53                   	push   %ebx
801035cb:	83 ec 14             	sub    $0x14,%esp
801035ce:	8b 45 08             	mov    0x8(%ebp),%eax
801035d1:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035d8:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801035dc:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801035e0:	ec                   	in     (%dx),%al
801035e1:	88 c3                	mov    %al,%bl
801035e3:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801035e6:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801035e9:	83 c4 14             	add    $0x14,%esp
801035ec:	5b                   	pop    %ebx
801035ed:	5d                   	pop    %ebp
801035ee:	c3                   	ret    

801035ef <outb>:
{
801035ef:	55                   	push   %ebp
801035f0:	89 e5                	mov    %esp,%ebp
801035f2:	83 ec 08             	sub    $0x8,%esp
801035f5:	8b 45 08             	mov    0x8(%ebp),%eax
801035f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801035fb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801035ff:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103602:	8a 45 f8             	mov    -0x8(%ebp),%al
80103605:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103608:	ee                   	out    %al,(%dx)
}
80103609:	c9                   	leave  
8010360a:	c3                   	ret    

8010360b <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010360b:	55                   	push   %ebp
8010360c:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
8010360e:	a1 84 c6 10 80       	mov    0x8010c684,%eax
80103613:	89 c2                	mov    %eax,%edx
80103615:	b8 60 09 11 80       	mov    $0x80110960,%eax
8010361a:	89 d1                	mov    %edx,%ecx
8010361c:	29 c1                	sub    %eax,%ecx
8010361e:	89 c8                	mov    %ecx,%eax
80103620:	89 c2                	mov    %eax,%edx
80103622:	c1 fa 02             	sar    $0x2,%edx
80103625:	89 d0                	mov    %edx,%eax
80103627:	c1 e0 03             	shl    $0x3,%eax
8010362a:	01 d0                	add    %edx,%eax
8010362c:	c1 e0 03             	shl    $0x3,%eax
8010362f:	01 d0                	add    %edx,%eax
80103631:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103638:	01 c8                	add    %ecx,%eax
8010363a:	c1 e0 03             	shl    $0x3,%eax
8010363d:	01 d0                	add    %edx,%eax
8010363f:	c1 e0 03             	shl    $0x3,%eax
80103642:	29 d0                	sub    %edx,%eax
80103644:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
8010364b:	01 c8                	add    %ecx,%eax
8010364d:	c1 e0 02             	shl    $0x2,%eax
80103650:	01 d0                	add    %edx,%eax
80103652:	c1 e0 03             	shl    $0x3,%eax
80103655:	29 d0                	sub    %edx,%eax
80103657:	89 c1                	mov    %eax,%ecx
80103659:	c1 e1 07             	shl    $0x7,%ecx
8010365c:	01 c8                	add    %ecx,%eax
8010365e:	d1 e0                	shl    %eax
80103660:	01 d0                	add    %edx,%eax
}
80103662:	5d                   	pop    %ebp
80103663:	c3                   	ret    

80103664 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103664:	55                   	push   %ebp
80103665:	89 e5                	mov    %esp,%ebp
80103667:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
8010366a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103671:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103678:	eb 13                	jmp    8010368d <sum+0x29>
    sum += addr[i];
8010367a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010367d:	8b 45 08             	mov    0x8(%ebp),%eax
80103680:	01 d0                	add    %edx,%eax
80103682:	8a 00                	mov    (%eax),%al
80103684:	0f b6 c0             	movzbl %al,%eax
80103687:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
8010368a:	ff 45 fc             	incl   -0x4(%ebp)
8010368d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103690:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103693:	7c e5                	jl     8010367a <sum+0x16>
  return sum;
80103695:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103698:	c9                   	leave  
80103699:	c3                   	ret    

8010369a <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010369a:	55                   	push   %ebp
8010369b:	89 e5                	mov    %esp,%ebp
8010369d:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036a0:	8b 45 08             	mov    0x8(%ebp),%eax
801036a3:	89 04 24             	mov    %eax,(%esp)
801036a6:	e8 0f ff ff ff       	call   801035ba <p2v>
801036ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801036ae:	8b 55 0c             	mov    0xc(%ebp),%edx
801036b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036b4:	01 d0                	add    %edx,%eax
801036b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801036bf:	eb 3f                	jmp    80103700 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036c1:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036c8:	00 
801036c9:	c7 44 24 04 6c 91 10 	movl   $0x8010916c,0x4(%esp)
801036d0:	80 
801036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d4:	89 04 24             	mov    %eax,(%esp)
801036d7:	e8 4d 22 00 00       	call   80105929 <memcmp>
801036dc:	85 c0                	test   %eax,%eax
801036de:	75 1c                	jne    801036fc <mpsearch1+0x62>
801036e0:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801036e7:	00 
801036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036eb:	89 04 24             	mov    %eax,(%esp)
801036ee:	e8 71 ff ff ff       	call   80103664 <sum>
801036f3:	84 c0                	test   %al,%al
801036f5:	75 05                	jne    801036fc <mpsearch1+0x62>
      return (struct mp*)p;
801036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036fa:	eb 11                	jmp    8010370d <mpsearch1+0x73>
  for(p = addr; p < e; p += sizeof(struct mp))
801036fc:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103700:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103703:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103706:	72 b9                	jb     801036c1 <mpsearch1+0x27>
  return 0;
80103708:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010370d:	c9                   	leave  
8010370e:	c3                   	ret    

8010370f <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010370f:	55                   	push   %ebp
80103710:	89 e5                	mov    %esp,%ebp
80103712:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103715:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010371f:	83 c0 0f             	add    $0xf,%eax
80103722:	8a 00                	mov    (%eax),%al
80103724:	0f b6 c0             	movzbl %al,%eax
80103727:	89 c2                	mov    %eax,%edx
80103729:	c1 e2 08             	shl    $0x8,%edx
8010372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010372f:	83 c0 0e             	add    $0xe,%eax
80103732:	8a 00                	mov    (%eax),%al
80103734:	0f b6 c0             	movzbl %al,%eax
80103737:	09 d0                	or     %edx,%eax
80103739:	c1 e0 04             	shl    $0x4,%eax
8010373c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010373f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103743:	74 21                	je     80103766 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103745:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
8010374c:	00 
8010374d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103750:	89 04 24             	mov    %eax,(%esp)
80103753:	e8 42 ff ff ff       	call   8010369a <mpsearch1>
80103758:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010375b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010375f:	74 4e                	je     801037af <mpsearch+0xa0>
      return mp;
80103761:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103764:	eb 5d                	jmp    801037c3 <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103769:	83 c0 14             	add    $0x14,%eax
8010376c:	8a 00                	mov    (%eax),%al
8010376e:	0f b6 c0             	movzbl %al,%eax
80103771:	89 c2                	mov    %eax,%edx
80103773:	c1 e2 08             	shl    $0x8,%edx
80103776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103779:	83 c0 13             	add    $0x13,%eax
8010377c:	8a 00                	mov    (%eax),%al
8010377e:	0f b6 c0             	movzbl %al,%eax
80103781:	09 d0                	or     %edx,%eax
80103783:	c1 e0 0a             	shl    $0xa,%eax
80103786:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103789:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010378c:	2d 00 04 00 00       	sub    $0x400,%eax
80103791:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103798:	00 
80103799:	89 04 24             	mov    %eax,(%esp)
8010379c:	e8 f9 fe ff ff       	call   8010369a <mpsearch1>
801037a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037a8:	74 05                	je     801037af <mpsearch+0xa0>
      return mp;
801037aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ad:	eb 14                	jmp    801037c3 <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
801037af:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037b6:	00 
801037b7:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037be:	e8 d7 fe ff ff       	call   8010369a <mpsearch1>
}
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    

801037c5 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037c5:	55                   	push   %ebp
801037c6:	89 e5                	mov    %esp,%ebp
801037c8:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037cb:	e8 3f ff ff ff       	call   8010370f <mpsearch>
801037d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037d7:	74 0a                	je     801037e3 <mpconfig+0x1e>
801037d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037dc:	8b 40 04             	mov    0x4(%eax),%eax
801037df:	85 c0                	test   %eax,%eax
801037e1:	75 0a                	jne    801037ed <mpconfig+0x28>
    return 0;
801037e3:	b8 00 00 00 00       	mov    $0x0,%eax
801037e8:	e9 80 00 00 00       	jmp    8010386d <mpconfig+0xa8>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801037ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f0:	8b 40 04             	mov    0x4(%eax),%eax
801037f3:	89 04 24             	mov    %eax,(%esp)
801037f6:	e8 bf fd ff ff       	call   801035ba <p2v>
801037fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801037fe:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103805:	00 
80103806:	c7 44 24 04 71 91 10 	movl   $0x80109171,0x4(%esp)
8010380d:	80 
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	89 04 24             	mov    %eax,(%esp)
80103814:	e8 10 21 00 00       	call   80105929 <memcmp>
80103819:	85 c0                	test   %eax,%eax
8010381b:	74 07                	je     80103824 <mpconfig+0x5f>
    return 0;
8010381d:	b8 00 00 00 00       	mov    $0x0,%eax
80103822:	eb 49                	jmp    8010386d <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103827:	8a 40 06             	mov    0x6(%eax),%al
8010382a:	3c 01                	cmp    $0x1,%al
8010382c:	74 11                	je     8010383f <mpconfig+0x7a>
8010382e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103831:	8a 40 06             	mov    0x6(%eax),%al
80103834:	3c 04                	cmp    $0x4,%al
80103836:	74 07                	je     8010383f <mpconfig+0x7a>
    return 0;
80103838:	b8 00 00 00 00       	mov    $0x0,%eax
8010383d:	eb 2e                	jmp    8010386d <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
8010383f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103842:	8b 40 04             	mov    0x4(%eax),%eax
80103845:	0f b7 c0             	movzwl %ax,%eax
80103848:	89 44 24 04          	mov    %eax,0x4(%esp)
8010384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010384f:	89 04 24             	mov    %eax,(%esp)
80103852:	e8 0d fe ff ff       	call   80103664 <sum>
80103857:	84 c0                	test   %al,%al
80103859:	74 07                	je     80103862 <mpconfig+0x9d>
    return 0;
8010385b:	b8 00 00 00 00       	mov    $0x0,%eax
80103860:	eb 0b                	jmp    8010386d <mpconfig+0xa8>
  *pmp = mp;
80103862:	8b 45 08             	mov    0x8(%ebp),%eax
80103865:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103868:	89 10                	mov    %edx,(%eax)
  return conf;
8010386a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010386d:	c9                   	leave  
8010386e:	c3                   	ret    

8010386f <mpinit>:

void
mpinit(void)
{
8010386f:	55                   	push   %ebp
80103870:	89 e5                	mov    %esp,%ebp
80103872:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103875:	c7 05 84 c6 10 80 60 	movl   $0x80110960,0x8010c684
8010387c:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
8010387f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103882:	89 04 24             	mov    %eax,(%esp)
80103885:	e8 3b ff ff ff       	call   801037c5 <mpconfig>
8010388a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010388d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103891:	0f 84 a4 01 00 00    	je     80103a3b <mpinit+0x1cc>
    return;
  ismp = 1;
80103897:	c7 05 44 09 11 80 01 	movl   $0x1,0x80110944
8010389e:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a4:	8b 40 24             	mov    0x24(%eax),%eax
801038a7:	a3 bc 08 11 80       	mov    %eax,0x801108bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038af:	83 c0 2c             	add    $0x2c,%eax
801038b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b8:	8b 40 04             	mov    0x4(%eax),%eax
801038bb:	0f b7 d0             	movzwl %ax,%edx
801038be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c1:	01 d0                	add    %edx,%eax
801038c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038c6:	e9 fe 00 00 00       	jmp    801039c9 <mpinit+0x15a>
    switch(*p){
801038cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ce:	8a 00                	mov    (%eax),%al
801038d0:	0f b6 c0             	movzbl %al,%eax
801038d3:	83 f8 04             	cmp    $0x4,%eax
801038d6:	0f 87 cb 00 00 00    	ja     801039a7 <mpinit+0x138>
801038dc:	8b 04 85 b4 91 10 80 	mov    -0x7fef6e4c(,%eax,4),%eax
801038e3:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038ee:	8a 40 01             	mov    0x1(%eax),%al
801038f1:	0f b6 d0             	movzbl %al,%edx
801038f4:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801038f9:	39 c2                	cmp    %eax,%edx
801038fb:	74 2c                	je     80103929 <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103900:	8a 40 01             	mov    0x1(%eax),%al
80103903:	0f b6 d0             	movzbl %al,%edx
80103906:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010390b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010390f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103913:	c7 04 24 76 91 10 80 	movl   $0x80109176,(%esp)
8010391a:	e8 82 ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
8010391f:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
80103926:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103929:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010392c:	8a 40 03             	mov    0x3(%eax),%al
8010392f:	0f b6 c0             	movzbl %al,%eax
80103932:	83 e0 02             	and    $0x2,%eax
80103935:	85 c0                	test   %eax,%eax
80103937:	74 1e                	je     80103957 <mpinit+0xe8>
        bcpu = &cpus[ncpu];
80103939:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
8010393f:	89 d0                	mov    %edx,%eax
80103941:	d1 e0                	shl    %eax
80103943:	01 d0                	add    %edx,%eax
80103945:	c1 e0 04             	shl    $0x4,%eax
80103948:	29 d0                	sub    %edx,%eax
8010394a:	c1 e0 02             	shl    $0x2,%eax
8010394d:	05 60 09 11 80       	add    $0x80110960,%eax
80103952:	a3 84 c6 10 80       	mov    %eax,0x8010c684
      cpus[ncpu].id = ncpu;
80103957:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
8010395d:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103962:	88 c1                	mov    %al,%cl
80103964:	89 d0                	mov    %edx,%eax
80103966:	d1 e0                	shl    %eax
80103968:	01 d0                	add    %edx,%eax
8010396a:	c1 e0 04             	shl    $0x4,%eax
8010396d:	29 d0                	sub    %edx,%eax
8010396f:	c1 e0 02             	shl    $0x2,%eax
80103972:	05 60 09 11 80       	add    $0x80110960,%eax
80103977:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103979:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010397e:	40                   	inc    %eax
8010397f:	a3 40 0f 11 80       	mov    %eax,0x80110f40
      p += sizeof(struct mpproc);
80103984:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103988:	eb 3f                	jmp    801039c9 <mpinit+0x15a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010398a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010398d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103993:	8a 40 01             	mov    0x1(%eax),%al
80103996:	a2 40 09 11 80       	mov    %al,0x80110940
      p += sizeof(struct mpioapic);
8010399b:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010399f:	eb 28                	jmp    801039c9 <mpinit+0x15a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039a1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039a5:	eb 22                	jmp    801039c9 <mpinit+0x15a>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039aa:	8a 00                	mov    (%eax),%al
801039ac:	0f b6 c0             	movzbl %al,%eax
801039af:	89 44 24 04          	mov    %eax,0x4(%esp)
801039b3:	c7 04 24 94 91 10 80 	movl   $0x80109194,(%esp)
801039ba:	e8 e2 c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039bf:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
801039c6:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039cf:	0f 82 f6 fe ff ff    	jb     801038cb <mpinit+0x5c>
    }
  }
  if(!ismp){
801039d5:	a1 44 09 11 80       	mov    0x80110944,%eax
801039da:	85 c0                	test   %eax,%eax
801039dc:	75 1d                	jne    801039fb <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039de:	c7 05 40 0f 11 80 01 	movl   $0x1,0x80110f40
801039e5:	00 00 00 
    lapic = 0;
801039e8:	c7 05 bc 08 11 80 00 	movl   $0x0,0x801108bc
801039ef:	00 00 00 
    ioapicid = 0;
801039f2:	c6 05 40 09 11 80 00 	movb   $0x0,0x80110940
801039f9:	eb 40                	jmp    80103a3b <mpinit+0x1cc>
    return;
  }

  if(mp->imcrp){
801039fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801039fe:	8a 40 0c             	mov    0xc(%eax),%al
80103a01:	84 c0                	test   %al,%al
80103a03:	74 36                	je     80103a3b <mpinit+0x1cc>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a05:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a0c:	00 
80103a0d:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a14:	e8 d6 fb ff ff       	call   801035ef <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a19:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a20:	e8 a2 fb ff ff       	call   801035c7 <inb>
80103a25:	83 c8 01             	or     $0x1,%eax
80103a28:	0f b6 c0             	movzbl %al,%eax
80103a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a2f:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a36:	e8 b4 fb ff ff       	call   801035ef <outb>
  }
}
80103a3b:	c9                   	leave  
80103a3c:	c3                   	ret    

80103a3d <outb>:
{
80103a3d:	55                   	push   %ebp
80103a3e:	89 e5                	mov    %esp,%ebp
80103a40:	83 ec 08             	sub    $0x8,%esp
80103a43:	8b 45 08             	mov    0x8(%ebp),%eax
80103a46:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a49:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103a4d:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a50:	8a 45 f8             	mov    -0x8(%ebp),%al
80103a53:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a56:	ee                   	out    %al,(%dx)
}
80103a57:	c9                   	leave  
80103a58:	c3                   	ret    

80103a59 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a59:	55                   	push   %ebp
80103a5a:	89 e5                	mov    %esp,%ebp
80103a5c:	83 ec 0c             	sub    $0xc,%esp
80103a5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103a62:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a66:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a69:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a72:	0f b6 c0             	movzbl %al,%eax
80103a75:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a79:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a80:	e8 b8 ff ff ff       	call   80103a3d <outb>
  outb(IO_PIC2+1, mask >> 8);
80103a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a88:	66 c1 e8 08          	shr    $0x8,%ax
80103a8c:	0f b6 c0             	movzbl %al,%eax
80103a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a93:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103a9a:	e8 9e ff ff ff       	call   80103a3d <outb>
}
80103a9f:	c9                   	leave  
80103aa0:	c3                   	ret    

80103aa1 <picenable>:

void
picenable(int irq)
{
80103aa1:	55                   	push   %ebp
80103aa2:	89 e5                	mov    %esp,%ebp
80103aa4:	53                   	push   %ebx
80103aa5:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80103aab:	ba 01 00 00 00       	mov    $0x1,%edx
80103ab0:	89 d3                	mov    %edx,%ebx
80103ab2:	88 c1                	mov    %al,%cl
80103ab4:	d3 e3                	shl    %cl,%ebx
80103ab6:	89 d8                	mov    %ebx,%eax
80103ab8:	89 c2                	mov    %eax,%edx
80103aba:	f7 d2                	not    %edx
80103abc:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103ac2:	21 d0                	and    %edx,%eax
80103ac4:	0f b7 c0             	movzwl %ax,%eax
80103ac7:	89 04 24             	mov    %eax,(%esp)
80103aca:	e8 8a ff ff ff       	call   80103a59 <picsetmask>
}
80103acf:	83 c4 04             	add    $0x4,%esp
80103ad2:	5b                   	pop    %ebx
80103ad3:	5d                   	pop    %ebp
80103ad4:	c3                   	ret    

80103ad5 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103ad5:	55                   	push   %ebp
80103ad6:	89 e5                	mov    %esp,%ebp
80103ad8:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103adb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103ae2:	00 
80103ae3:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103aea:	e8 4e ff ff ff       	call   80103a3d <outb>
  outb(IO_PIC2+1, 0xFF);
80103aef:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103af6:	00 
80103af7:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103afe:	e8 3a ff ff ff       	call   80103a3d <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b03:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b0a:	00 
80103b0b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b12:	e8 26 ff ff ff       	call   80103a3d <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b17:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b1e:	00 
80103b1f:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b26:	e8 12 ff ff ff       	call   80103a3d <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b2b:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b32:	00 
80103b33:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b3a:	e8 fe fe ff ff       	call   80103a3d <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b3f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b46:	00 
80103b47:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b4e:	e8 ea fe ff ff       	call   80103a3d <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b53:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b5a:	00 
80103b5b:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b62:	e8 d6 fe ff ff       	call   80103a3d <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b67:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b6e:	00 
80103b6f:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b76:	e8 c2 fe ff ff       	call   80103a3d <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b7b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b82:	00 
80103b83:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b8a:	e8 ae fe ff ff       	call   80103a3d <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103b8f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b96:	00 
80103b97:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b9e:	e8 9a fe ff ff       	call   80103a3d <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103ba3:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103baa:	00 
80103bab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bb2:	e8 86 fe ff ff       	call   80103a3d <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bb7:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bbe:	00 
80103bbf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bc6:	e8 72 fe ff ff       	call   80103a3d <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103bcb:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bd2:	00 
80103bd3:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bda:	e8 5e fe ff ff       	call   80103a3d <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bdf:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103be6:	00 
80103be7:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bee:	e8 4a fe ff ff       	call   80103a3d <outb>

  if(irqmask != 0xFFFF)
80103bf3:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103bf9:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bfd:	74 11                	je     80103c10 <picinit+0x13b>
    picsetmask(irqmask);
80103bff:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103c05:	0f b7 c0             	movzwl %ax,%eax
80103c08:	89 04 24             	mov    %eax,(%esp)
80103c0b:	e8 49 fe ff ff       	call   80103a59 <picsetmask>
}
80103c10:	c9                   	leave  
80103c11:	c3                   	ret    

80103c12 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c12:	55                   	push   %ebp
80103c13:	89 e5                	mov    %esp,%ebp
80103c15:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c28:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c2b:	8b 10                	mov    (%eax),%edx
80103c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80103c30:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c32:	e8 bc d2 ff ff       	call   80100ef3 <filealloc>
80103c37:	8b 55 08             	mov    0x8(%ebp),%edx
80103c3a:	89 02                	mov    %eax,(%edx)
80103c3c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c3f:	8b 00                	mov    (%eax),%eax
80103c41:	85 c0                	test   %eax,%eax
80103c43:	0f 84 c8 00 00 00    	je     80103d11 <pipealloc+0xff>
80103c49:	e8 a5 d2 ff ff       	call   80100ef3 <filealloc>
80103c4e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c51:	89 02                	mov    %eax,(%edx)
80103c53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c56:	8b 00                	mov    (%eax),%eax
80103c58:	85 c0                	test   %eax,%eax
80103c5a:	0f 84 b1 00 00 00    	je     80103d11 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c60:	e8 59 ee ff ff       	call   80102abe <kalloc>
80103c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c6c:	0f 84 9e 00 00 00    	je     80103d10 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c75:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c7c:	00 00 00 
  p->writeopen = 1;
80103c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c82:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c89:	00 00 00 
  p->nwrite = 0;
80103c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c96:	00 00 00 
  p->nread = 0;
80103c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9c:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ca3:	00 00 00 
  initlock(&p->lock, "pipe");
80103ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca9:	c7 44 24 04 c8 91 10 	movl   $0x801091c8,0x4(%esp)
80103cb0:	80 
80103cb1:	89 04 24             	mov    %eax,(%esp)
80103cb4:	e8 86 19 00 00       	call   8010563f <initlock>
  (*f0)->type = FD_PIPE;
80103cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80103cbc:	8b 00                	mov    (%eax),%eax
80103cbe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103cc7:	8b 00                	mov    (%eax),%eax
80103cc9:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd0:	8b 00                	mov    (%eax),%eax
80103cd2:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd9:	8b 00                	mov    (%eax),%eax
80103cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cde:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ce4:	8b 00                	mov    (%eax),%eax
80103ce6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cec:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cef:	8b 00                	mov    (%eax),%eax
80103cf1:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf8:	8b 00                	mov    (%eax),%eax
80103cfa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d01:	8b 00                	mov    (%eax),%eax
80103d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d06:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d09:	b8 00 00 00 00       	mov    $0x0,%eax
80103d0e:	eb 43                	jmp    80103d53 <pipealloc+0x141>
    goto bad;
80103d10:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103d11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d15:	74 0b                	je     80103d22 <pipealloc+0x110>
    kfree((char*)p);
80103d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1a:	89 04 24             	mov    %eax,(%esp)
80103d1d:	e8 03 ed ff ff       	call   80102a25 <kfree>
  if(*f0)
80103d22:	8b 45 08             	mov    0x8(%ebp),%eax
80103d25:	8b 00                	mov    (%eax),%eax
80103d27:	85 c0                	test   %eax,%eax
80103d29:	74 0d                	je     80103d38 <pipealloc+0x126>
    fileclose(*f0);
80103d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2e:	8b 00                	mov    (%eax),%eax
80103d30:	89 04 24             	mov    %eax,(%esp)
80103d33:	e8 63 d2 ff ff       	call   80100f9b <fileclose>
  if(*f1)
80103d38:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d3b:	8b 00                	mov    (%eax),%eax
80103d3d:	85 c0                	test   %eax,%eax
80103d3f:	74 0d                	je     80103d4e <pipealloc+0x13c>
    fileclose(*f1);
80103d41:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d44:	8b 00                	mov    (%eax),%eax
80103d46:	89 04 24             	mov    %eax,(%esp)
80103d49:	e8 4d d2 ff ff       	call   80100f9b <fileclose>
  return -1;
80103d4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d53:	c9                   	leave  
80103d54:	c3                   	ret    

80103d55 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d55:	55                   	push   %ebp
80103d56:	89 e5                	mov    %esp,%ebp
80103d58:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d5b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d5e:	89 04 24             	mov    %eax,(%esp)
80103d61:	e8 fa 18 00 00       	call   80105660 <acquire>
  if(writable){
80103d66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d6a:	74 1f                	je     80103d8b <pipeclose+0x36>
    p->writeopen = 0;
80103d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103d6f:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d76:	00 00 00 
    wakeup(&p->nread);
80103d79:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7c:	05 34 02 00 00       	add    $0x234,%eax
80103d81:	89 04 24             	mov    %eax,(%esp)
80103d84:	e8 5d 0e 00 00       	call   80104be6 <wakeup>
80103d89:	eb 1d                	jmp    80103da8 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8e:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103d95:	00 00 00 
    wakeup(&p->nwrite);
80103d98:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9b:	05 38 02 00 00       	add    $0x238,%eax
80103da0:	89 04 24             	mov    %eax,(%esp)
80103da3:	e8 3e 0e 00 00       	call   80104be6 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103da8:	8b 45 08             	mov    0x8(%ebp),%eax
80103dab:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103db1:	85 c0                	test   %eax,%eax
80103db3:	75 25                	jne    80103dda <pipeclose+0x85>
80103db5:	8b 45 08             	mov    0x8(%ebp),%eax
80103db8:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103dbe:	85 c0                	test   %eax,%eax
80103dc0:	75 18                	jne    80103dda <pipeclose+0x85>
    release(&p->lock);
80103dc2:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc5:	89 04 24             	mov    %eax,(%esp)
80103dc8:	e8 f5 18 00 00       	call   801056c2 <release>
    kfree((char*)p);
80103dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd0:	89 04 24             	mov    %eax,(%esp)
80103dd3:	e8 4d ec ff ff       	call   80102a25 <kfree>
80103dd8:	eb 0b                	jmp    80103de5 <pipeclose+0x90>
  } else
    release(&p->lock);
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	89 04 24             	mov    %eax,(%esp)
80103de0:	e8 dd 18 00 00       	call   801056c2 <release>
}
80103de5:	c9                   	leave  
80103de6:	c3                   	ret    

80103de7 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103de7:	55                   	push   %ebp
80103de8:	89 e5                	mov    %esp,%ebp
80103dea:	53                   	push   %ebx
80103deb:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103dee:	8b 45 08             	mov    0x8(%ebp),%eax
80103df1:	89 04 24             	mov    %eax,(%esp)
80103df4:	e8 67 18 00 00       	call   80105660 <acquire>
  for(i = 0; i < n; i++){
80103df9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e00:	e9 a6 00 00 00       	jmp    80103eab <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e05:	8b 45 08             	mov    0x8(%ebp),%eax
80103e08:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e0e:	85 c0                	test   %eax,%eax
80103e10:	74 0d                	je     80103e1f <pipewrite+0x38>
80103e12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e18:	8b 40 24             	mov    0x24(%eax),%eax
80103e1b:	85 c0                	test   %eax,%eax
80103e1d:	74 15                	je     80103e34 <pipewrite+0x4d>
        release(&p->lock);
80103e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e22:	89 04 24             	mov    %eax,(%esp)
80103e25:	e8 98 18 00 00       	call   801056c2 <release>
        return -1;
80103e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2f:	e9 9d 00 00 00       	jmp    80103ed1 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e34:	8b 45 08             	mov    0x8(%ebp),%eax
80103e37:	05 34 02 00 00       	add    $0x234,%eax
80103e3c:	89 04 24             	mov    %eax,(%esp)
80103e3f:	e8 a2 0d 00 00       	call   80104be6 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e44:	8b 45 08             	mov    0x8(%ebp),%eax
80103e47:	8b 55 08             	mov    0x8(%ebp),%edx
80103e4a:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e54:	89 14 24             	mov    %edx,(%esp)
80103e57:	e8 82 0c 00 00       	call   80104ade <sleep>
80103e5c:	eb 01                	jmp    80103e5f <pipewrite+0x78>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e5e:	90                   	nop
80103e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e62:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e68:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e71:	05 00 02 00 00       	add    $0x200,%eax
80103e76:	39 c2                	cmp    %eax,%edx
80103e78:	74 8b                	je     80103e05 <pipewrite+0x1e>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e83:	89 c3                	mov    %eax,%ebx
80103e85:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103e8b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103e8e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e91:	01 ca                	add    %ecx,%edx
80103e93:	8a 0a                	mov    (%edx),%cl
80103e95:	8b 55 08             	mov    0x8(%ebp),%edx
80103e98:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103e9c:	8d 50 01             	lea    0x1(%eax),%edx
80103e9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea2:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
  for(i = 0; i < n; i++){
80103ea8:	ff 45 f4             	incl   -0xc(%ebp)
80103eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eae:	3b 45 10             	cmp    0x10(%ebp),%eax
80103eb1:	7c ab                	jl     80103e5e <pipewrite+0x77>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb6:	05 34 02 00 00       	add    $0x234,%eax
80103ebb:	89 04 24             	mov    %eax,(%esp)
80103ebe:	e8 23 0d 00 00       	call   80104be6 <wakeup>
  release(&p->lock);
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec6:	89 04 24             	mov    %eax,(%esp)
80103ec9:	e8 f4 17 00 00       	call   801056c2 <release>
  return n;
80103ece:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103ed1:	83 c4 24             	add    $0x24,%esp
80103ed4:	5b                   	pop    %ebx
80103ed5:	5d                   	pop    %ebp
80103ed6:	c3                   	ret    

80103ed7 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ed7:	55                   	push   %ebp
80103ed8:	89 e5                	mov    %esp,%ebp
80103eda:	53                   	push   %ebx
80103edb:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103ede:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee1:	89 04 24             	mov    %eax,(%esp)
80103ee4:	e8 77 17 00 00       	call   80105660 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ee9:	eb 3a                	jmp    80103f25 <piperead+0x4e>
    if(proc->killed){
80103eeb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ef1:	8b 40 24             	mov    0x24(%eax),%eax
80103ef4:	85 c0                	test   %eax,%eax
80103ef6:	74 15                	je     80103f0d <piperead+0x36>
      release(&p->lock);
80103ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80103efb:	89 04 24             	mov    %eax,(%esp)
80103efe:	e8 bf 17 00 00       	call   801056c2 <release>
      return -1;
80103f03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f08:	e9 b5 00 00 00       	jmp    80103fc2 <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f10:	8b 55 08             	mov    0x8(%ebp),%edx
80103f13:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f19:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f1d:	89 14 24             	mov    %edx,(%esp)
80103f20:	e8 b9 0b 00 00       	call   80104ade <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f25:	8b 45 08             	mov    0x8(%ebp),%eax
80103f28:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f31:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f37:	39 c2                	cmp    %eax,%edx
80103f39:	75 0d                	jne    80103f48 <piperead+0x71>
80103f3b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f44:	85 c0                	test   %eax,%eax
80103f46:	75 a3                	jne    80103eeb <piperead+0x14>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f4f:	eb 48                	jmp    80103f99 <piperead+0xc2>
    if(p->nread == p->nwrite)
80103f51:	8b 45 08             	mov    0x8(%ebp),%eax
80103f54:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f63:	39 c2                	cmp    %eax,%edx
80103f65:	74 3c                	je     80103fa3 <piperead+0xcc>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103f70:	8b 45 08             	mov    0x8(%ebp),%eax
80103f73:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f79:	89 c3                	mov    %eax,%ebx
80103f7b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f81:	8b 55 08             	mov    0x8(%ebp),%edx
80103f84:	8a 54 1a 34          	mov    0x34(%edx,%ebx,1),%dl
80103f88:	88 11                	mov    %dl,(%ecx)
80103f8a:	8d 50 01             	lea    0x1(%eax),%edx
80103f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103f90:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f96:	ff 45 f4             	incl   -0xc(%ebp)
80103f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f9c:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f9f:	7c b0                	jl     80103f51 <piperead+0x7a>
80103fa1:	eb 01                	jmp    80103fa4 <piperead+0xcd>
      break;
80103fa3:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa7:	05 38 02 00 00       	add    $0x238,%eax
80103fac:	89 04 24             	mov    %eax,(%esp)
80103faf:	e8 32 0c 00 00       	call   80104be6 <wakeup>
  release(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 04 24             	mov    %eax,(%esp)
80103fba:	e8 03 17 00 00       	call   801056c2 <release>
  return i;
80103fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fc2:	83 c4 24             	add    $0x24,%esp
80103fc5:	5b                   	pop    %ebx
80103fc6:	5d                   	pop    %ebp
80103fc7:	c3                   	ret    

80103fc8 <readeflags>:
{
80103fc8:	55                   	push   %ebp
80103fc9:	89 e5                	mov    %esp,%ebp
80103fcb:	53                   	push   %ebx
80103fcc:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fcf:	9c                   	pushf  
80103fd0:	5b                   	pop    %ebx
80103fd1:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80103fd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	5b                   	pop    %ebx
80103fdb:	5d                   	pop    %ebp
80103fdc:	c3                   	ret    

80103fdd <sti>:
{
80103fdd:	55                   	push   %ebp
80103fde:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103fe0:	fb                   	sti    
}
80103fe1:	5d                   	pop    %ebp
80103fe2:	c3                   	ret    

80103fe3 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103fe3:	55                   	push   %ebp
80103fe4:	89 e5                	mov    %esp,%ebp
80103fe6:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103fe9:	c7 44 24 04 cd 91 10 	movl   $0x801091cd,0x4(%esp)
80103ff0:	80 
80103ff1:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80103ff8:	e8 42 16 00 00       	call   8010563f <initlock>
  shm_init(); // New: Add in project final: inicializo shmtable.sharedmemory[i].refcount = -1
80103ffd:	e8 b0 11 00 00       	call   801051b2 <shm_init>
}
80104002:	c9                   	leave  
80104003:	c3                   	ret    

80104004 <enqueue>:

void
enqueue(struct proc *p) // New: Added in proyect 2
{
80104004:	55                   	push   %ebp
80104005:	89 e5                	mov    %esp,%ebp
80104007:	83 ec 28             	sub    $0x28,%esp
  struct proc *prev;
  if(p->priority>=0 && p->priority<MLF_LEVELS){
8010400a:	8b 45 08             	mov    0x8(%ebp),%eax
8010400d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104013:	85 c0                	test   %eax,%eax
80104015:	0f 88 b8 00 00 00    	js     801040d3 <enqueue+0xcf>
8010401b:	8b 45 08             	mov    0x8(%ebp),%eax
8010401e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104024:	83 f8 03             	cmp    $0x3,%eax
80104027:	0f 8f a6 00 00 00    	jg     801040d3 <enqueue+0xcf>
    //if priority level is empty (there is no proc)
    if(ptable.mlf[p->priority].first == 0){
8010402d:	8b 45 08             	mov    0x8(%ebp),%eax
80104030:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104036:	05 66 05 00 00       	add    $0x566,%eax
8010403b:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104042:	85 c0                	test   %eax,%eax
80104044:	75 41                	jne    80104087 <enqueue+0x83>
      ptable.mlf[p->priority].first=p; //set first
80104046:	8b 45 08             	mov    0x8(%ebp),%eax
80104049:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010404f:	8d 90 66 05 00 00    	lea    0x566(%eax),%edx
80104055:	8b 45 08             	mov    0x8(%ebp),%eax
80104058:	89 04 d5 04 10 11 80 	mov    %eax,-0x7feeeffc(,%edx,8)
      ptable.mlf[p->priority].last=p; //set last
8010405f:	8b 45 08             	mov    0x8(%ebp),%eax
80104062:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104068:	8d 90 66 05 00 00    	lea    0x566(%eax),%edx
8010406e:	8b 45 08             	mov    0x8(%ebp),%eax
80104071:	89 04 d5 08 10 11 80 	mov    %eax,-0x7feeeff8(,%edx,8)
      p->next=0;  //set next in "null"
80104078:	8b 45 08             	mov    0x8(%ebp),%eax
8010407b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104082:	00 00 00 
    if(ptable.mlf[p->priority].first == 0){
80104085:	eb 58                	jmp    801040df <enqueue+0xdb>
    }else{
      prev=ptable.mlf[p->priority].last;//get previous last
80104087:	8b 45 08             	mov    0x8(%ebp),%eax
8010408a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104090:	05 66 05 00 00       	add    $0x566,%eax
80104095:	8b 04 c5 08 10 11 80 	mov    -0x7feeeff8(,%eax,8),%eax
8010409c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      prev->next=p; //set new proc as next of previous last
8010409f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a2:	8b 55 08             	mov    0x8(%ebp),%edx
801040a5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
      ptable.mlf[p->priority].last=p; //refresh last
801040ab:	8b 45 08             	mov    0x8(%ebp),%eax
801040ae:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801040b4:	8d 90 66 05 00 00    	lea    0x566(%eax),%edx
801040ba:	8b 45 08             	mov    0x8(%ebp),%eax
801040bd:	89 04 d5 08 10 11 80 	mov    %eax,-0x7feeeff8(,%edx,8)
      p->next=0;
801040c4:	8b 45 08             	mov    0x8(%ebp),%eax
801040c7:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801040ce:	00 00 00 
    if(ptable.mlf[p->priority].first == 0){
801040d1:	eb 0c                	jmp    801040df <enqueue+0xdb>
    }
  }else{
    cprintf("ERROR ENQUEUE\n");
801040d3:	c7 04 24 d4 91 10 80 	movl   $0x801091d4,(%esp)
801040da:	e8 c2 c2 ff ff       	call   801003a1 <cprintf>
  }
}
801040df:	c9                   	leave  
801040e0:	c3                   	ret    

801040e1 <dequeue>:

struct proc *
dequeue(int priority) // New: Added in proyect 2
{
801040e1:	55                   	push   %ebp
801040e2:	89 e5                	mov    %esp,%ebp
801040e4:	83 ec 10             	sub    $0x10,%esp
  struct proc *res; // result pointer
  // save first proc of the list
  res=ptable.mlf[priority].first;
801040e7:	8b 45 08             	mov    0x8(%ebp),%eax
801040ea:	05 66 05 00 00       	add    $0x566,%eax
801040ef:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
801040f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  // when a proc is dequeued, refresh first element of the priority level
  ptable.mlf[priority].first=ptable.mlf[priority].first->next;
801040f9:	8b 45 08             	mov    0x8(%ebp),%eax
801040fc:	05 66 05 00 00       	add    $0x566,%eax
80104101:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104108:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010410e:	8b 55 08             	mov    0x8(%ebp),%edx
80104111:	81 c2 66 05 00 00    	add    $0x566,%edx
80104117:	89 04 d5 04 10 11 80 	mov    %eax,-0x7feeeffc(,%edx,8)
  res->next=0;
8010411e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104121:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104128:	00 00 00 
  return res;
8010412b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010412e:	c9                   	leave  
8010412f:	c3                   	ret    

80104130 <isempty>:

// if priority level empty return zero, else return one
int
isempty(int priority) // New: Added in proyect 2
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
  if(ptable.mlf[priority].first!=0){
80104133:	8b 45 08             	mov    0x8(%ebp),%eax
80104136:	05 66 05 00 00       	add    $0x566,%eax
8010413b:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104142:	85 c0                	test   %eax,%eax
80104144:	74 07                	je     8010414d <isempty+0x1d>
    return 0; 
80104146:	b8 00 00 00 00       	mov    $0x0,%eax
8010414b:	eb 05                	jmp    80104152 <isempty+0x22>
  }
  return 1; 
8010414d:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104152:	5d                   	pop    %ebp
80104153:	c3                   	ret    

80104154 <makerunnable>:
// Upgrade process priority
// set state in RUNNABLE and enqueue process in array mlf.
void
makerunnable(struct proc *p, int priority) // New: Added in proyect 2
// priority can be: 0, 1, -1
{
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	83 ec 18             	sub    $0x18,%esp
  if (priority==0)
8010415a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010415e:	75 0d                	jne    8010416d <makerunnable+0x19>
  {
    p->priority = 0;
80104160:	8b 45 08             	mov    0x8(%ebp),%eax
80104163:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010416a:	00 00 00 
  }
  if (priority==1 && p->priority<SIZEMLF-1)
8010416d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
80104171:	75 23                	jne    80104196 <makerunnable+0x42>
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
80104176:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010417c:	83 f8 02             	cmp    $0x2,%eax
8010417f:	7f 15                	jg     80104196 <makerunnable+0x42>
  {
    p->priority++;
80104181:	8b 45 08             	mov    0x8(%ebp),%eax
80104184:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010418a:	8d 50 01             	lea    0x1(%eax),%edx
8010418d:	8b 45 08             	mov    0x8(%ebp),%eax
80104190:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  if (priority==-1 && p->priority>0)
80104196:	83 7d 0c ff          	cmpl   $0xffffffff,0xc(%ebp)
8010419a:	75 22                	jne    801041be <makerunnable+0x6a>
8010419c:	8b 45 08             	mov    0x8(%ebp),%eax
8010419f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041a5:	85 c0                	test   %eax,%eax
801041a7:	7e 15                	jle    801041be <makerunnable+0x6a>
  {
    p->priority--;
801041a9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ac:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041b2:	8d 50 ff             	lea    -0x1(%eax),%edx
801041b5:	8b 45 08             	mov    0x8(%ebp),%eax
801041b8:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  p->state = RUNNABLE; 
801041be:	8b 45 08             	mov    0x8(%ebp),%eax
801041c1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(p); 
801041c8:	8b 45 08             	mov    0x8(%ebp),%eax
801041cb:	89 04 24             	mov    %eax,(%esp)
801041ce:	e8 31 fe ff ff       	call   80104004 <enqueue>
}
801041d3:	c9                   	leave  
801041d4:	c3                   	ret    

801041d5 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801041d5:	55                   	push   %ebp
801041d6:	89 e5                	mov    %esp,%ebp
801041d8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801041db:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801041e2:	e8 79 14 00 00       	call   80105660 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e7:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801041ee:	eb 11                	jmp    80104201 <allocproc+0x2c>
    if(p->state == UNUSED)
801041f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f3:	8b 40 0c             	mov    0xc(%eax),%eax
801041f6:	85 c0                	test   %eax,%eax
801041f8:	74 26                	je     80104220 <allocproc+0x4b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fa:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104201:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104208:	72 e6                	jb     801041f0 <allocproc+0x1b>
      goto found;
  release(&ptable.lock);
8010420a:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104211:	e8 ac 14 00 00       	call   801056c2 <release>
  return 0;
80104216:	b8 00 00 00 00       	mov    $0x0,%eax
8010421b:	e9 c0 00 00 00       	jmp    801042e0 <allocproc+0x10b>
      goto found;
80104220:	90                   	nop

found:
  p->state = EMBRYO;
80104221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104224:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010422b:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104230:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104233:	89 42 10             	mov    %eax,0x10(%edx)
80104236:	40                   	inc    %eax
80104237:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
8010423c:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104243:	e8 7a 14 00 00       	call   801056c2 <release>

  p->priority=0; // New: Added in proyect 2: set priority in zero 
80104248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104252:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104255:	e8 64 e8 ff ff       	call   80102abe <kalloc>
8010425a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010425d:	89 42 08             	mov    %eax,0x8(%edx)
80104260:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104263:	8b 40 08             	mov    0x8(%eax),%eax
80104266:	85 c0                	test   %eax,%eax
80104268:	75 11                	jne    8010427b <allocproc+0xa6>
    p->state = UNUSED;
8010426a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104274:	b8 00 00 00 00       	mov    $0x0,%eax
80104279:	eb 65                	jmp    801042e0 <allocproc+0x10b>
  }
  sp = p->kstack + KSTACKSIZE;
8010427b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427e:	8b 40 08             	mov    0x8(%eax),%eax
80104281:	05 00 10 00 00       	add    $0x1000,%eax
80104286:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104289:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010428d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104290:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104293:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104296:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010429a:	ba 0f 6f 10 80       	mov    $0x80106f0f,%edx
8010429f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042a2:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801042a4:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801042a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042ae:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801042b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b4:	8b 40 1c             	mov    0x1c(%eax),%eax
801042b7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801042be:	00 
801042bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042c6:	00 
801042c7:	89 04 24             	mov    %eax,(%esp)
801042ca:	e8 e3 15 00 00       	call   801058b2 <memset>
  p->context->eip = (uint)forkret;
801042cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d2:	8b 40 1c             	mov    0x1c(%eax),%eax
801042d5:	ba b2 4a 10 80       	mov    $0x80104ab2,%edx
801042da:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801042dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042e0:	c9                   	leave  
801042e1:	c3                   	ret    

801042e2 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801042e2:	55                   	push   %ebp
801042e3:	89 e5                	mov    %esp,%ebp
801042e5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801042e8:	e8 e8 fe ff ff       	call   801041d5 <allocproc>
801042ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f3:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
801042f8:	e8 d9 42 00 00       	call   801085d6 <setupkvm>
801042fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104300:	89 42 04             	mov    %eax,0x4(%edx)
80104303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104306:	8b 40 04             	mov    0x4(%eax),%eax
80104309:	85 c0                	test   %eax,%eax
8010430b:	75 0c                	jne    80104319 <userinit+0x37>
    panic("userinit: out of memory?");
8010430d:	c7 04 24 e3 91 10 80 	movl   $0x801091e3,(%esp)
80104314:	e8 1d c2 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104319:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010431e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104321:	8b 40 04             	mov    0x4(%eax),%eax
80104324:	89 54 24 08          	mov    %edx,0x8(%esp)
80104328:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
8010432f:	80 
80104330:	89 04 24             	mov    %eax,(%esp)
80104333:	e8 ea 44 00 00       	call   80108822 <inituvm>
  p->sz = PGSIZE;
80104338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433b:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104344:	8b 40 18             	mov    0x18(%eax),%eax
80104347:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010434e:	00 
8010434f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104356:	00 
80104357:	89 04 24             	mov    %eax,(%esp)
8010435a:	e8 53 15 00 00       	call   801058b2 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104362:	8b 40 18             	mov    0x18(%eax),%eax
80104365:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010436b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436e:	8b 40 18             	mov    0x18(%eax),%eax
80104371:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437a:	8b 50 18             	mov    0x18(%eax),%edx
8010437d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104380:	8b 40 18             	mov    0x18(%eax),%eax
80104383:	8b 40 2c             	mov    0x2c(%eax),%eax
80104386:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
8010438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438d:	8b 50 18             	mov    0x18(%eax),%edx
80104390:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104393:	8b 40 18             	mov    0x18(%eax),%eax
80104396:	8b 40 2c             	mov    0x2c(%eax),%eax
80104399:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
8010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a0:	8b 40 18             	mov    0x18(%eax),%eax
801043a3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801043aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ad:	8b 40 18             	mov    0x18(%eax),%eax
801043b0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ba:	8b 40 18             	mov    0x18(%eax),%eax
801043bd:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801043c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c7:	83 c0 6c             	add    $0x6c,%eax
801043ca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043d1:	00 
801043d2:	c7 44 24 04 fc 91 10 	movl   $0x801091fc,0x4(%esp)
801043d9:	80 
801043da:	89 04 24             	mov    %eax,(%esp)
801043dd:	e8 e2 16 00 00       	call   80105ac4 <safestrcpy>
  p->cwd = namei("/");
801043e2:	c7 04 24 05 92 10 80 	movl   $0x80109205,(%esp)
801043e9:	e8 f1 df ff ff       	call   801023df <namei>
801043ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043f1:	89 42 68             	mov    %eax,0x68(%edx)

  // p->state = RUNNABLE;
  makerunnable(p,0); // New: Added in proyect 2: enqueue proc
801043f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043fb:	00 
801043fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ff:	89 04 24             	mov    %eax,(%esp)
80104402:	e8 4d fd ff ff       	call   80104154 <makerunnable>

}
80104407:	c9                   	leave  
80104408:	c3                   	ret    

80104409 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104409:	55                   	push   %ebp
8010440a:	89 e5                	mov    %esp,%ebp
8010440c:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
8010440f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104415:	8b 00                	mov    (%eax),%eax
80104417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010441a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010441e:	7e 34                	jle    80104454 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104420:	8b 55 08             	mov    0x8(%ebp),%edx
80104423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104426:	01 c2                	add    %eax,%edx
80104428:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442e:	8b 40 04             	mov    0x4(%eax),%eax
80104431:	89 54 24 08          	mov    %edx,0x8(%esp)
80104435:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104438:	89 54 24 04          	mov    %edx,0x4(%esp)
8010443c:	89 04 24             	mov    %eax,(%esp)
8010443f:	e8 58 45 00 00       	call   8010899c <allocuvm>
80104444:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010444b:	75 41                	jne    8010448e <growproc+0x85>
      return -1;
8010444d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104452:	eb 58                	jmp    801044ac <growproc+0xa3>
  } else if(n < 0){
80104454:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104458:	79 34                	jns    8010448e <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010445a:	8b 55 08             	mov    0x8(%ebp),%edx
8010445d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104460:	01 c2                	add    %eax,%edx
80104462:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104468:	8b 40 04             	mov    0x4(%eax),%eax
8010446b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010446f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104472:	89 54 24 04          	mov    %edx,0x4(%esp)
80104476:	89 04 24             	mov    %eax,(%esp)
80104479:	e8 f8 45 00 00       	call   80108a76 <deallocuvm>
8010447e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104485:	75 07                	jne    8010448e <growproc+0x85>
      return -1;
80104487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010448c:	eb 1e                	jmp    801044ac <growproc+0xa3>
  }
  proc->sz = sz;
8010448e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104494:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104497:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449f:	89 04 24             	mov    %eax,(%esp)
801044a2:	e8 20 42 00 00       	call   801086c7 <switchuvm>
  return 0;
801044a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044ac:	c9                   	leave  
801044ad:	c3                   	ret    

801044ae <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801044ae:	55                   	push   %ebp
801044af:	89 e5                	mov    %esp,%ebp
801044b1:	57                   	push   %edi
801044b2:	56                   	push   %esi
801044b3:	53                   	push   %ebx
801044b4:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801044b7:	e8 19 fd ff ff       	call   801041d5 <allocproc>
801044bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801044bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801044c3:	75 0a                	jne    801044cf <fork+0x21>
    return -1; // no encontro ningun UNUSED proc
801044c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ca:	e9 5b 01 00 00       	jmp    8010462a <fork+0x17c>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801044cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044d5:	8b 10                	mov    (%eax),%edx
801044d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044dd:	8b 40 04             	mov    0x4(%eax),%eax
801044e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801044e4:	89 04 24             	mov    %eax,(%esp)
801044e7:	e8 40 47 00 00       	call   80108c2c <copyuvm>
801044ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044ef:	89 42 04             	mov    %eax,0x4(%edx)
801044f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044f5:	8b 40 04             	mov    0x4(%eax),%eax
801044f8:	85 c0                	test   %eax,%eax
801044fa:	75 22                	jne    8010451e <fork+0x70>
    kfree(np->kstack); // por que dentro del allocproc hice:  Allocate kernel stack.
801044fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044ff:	8b 40 08             	mov    0x8(%eax),%eax
80104502:	89 04 24             	mov    %eax,(%esp)
80104505:	e8 1b e5 ff ff       	call   80102a25 <kfree>
    // np->kstack = 0;
    np->state = UNUSED;
8010450a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010450d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1; // error en la copia del estado
80104514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104519:	e9 0c 01 00 00       	jmp    8010462a <fork+0x17c>
  }
  np->sz = proc->sz;
8010451e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104524:	8b 10                	mov    (%eax),%edx
80104526:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104529:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010452b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104532:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104535:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104538:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010453b:	8b 50 18             	mov    0x18(%eax),%edx
8010453e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104544:	8b 40 18             	mov    0x18(%eax),%eax
80104547:	89 c3                	mov    %eax,%ebx
80104549:	b8 13 00 00 00       	mov    $0x13,%eax
8010454e:	89 d7                	mov    %edx,%edi
80104550:	89 de                	mov    %ebx,%esi
80104552:	89 c1                	mov    %eax,%ecx
80104554:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104556:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104559:	8b 40 18             	mov    0x18(%eax),%eax
8010455c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104563:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010456a:	eb 3c                	jmp    801045a8 <fork+0xfa>
    if(proc->ofile[i])
8010456c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104575:	83 c2 08             	add    $0x8,%edx
80104578:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010457c:	85 c0                	test   %eax,%eax
8010457e:	74 25                	je     801045a5 <fork+0xf7>
      np->ofile[i] = filedup(proc->ofile[i]);
80104580:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104586:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104589:	83 c2 08             	add    $0x8,%edx
8010458c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104590:	89 04 24             	mov    %eax,(%esp)
80104593:	e8 bb c9 ff ff       	call   80100f53 <filedup>
80104598:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010459b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010459e:	83 c1 08             	add    $0x8,%ecx
801045a1:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801045a5:	ff 45 e4             	incl   -0x1c(%ebp)
801045a8:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801045ac:	7e be                	jle    8010456c <fork+0xbe>
  np->cwd = idup(proc->cwd);
801045ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045b4:	8b 40 68             	mov    0x68(%eax),%eax
801045b7:	89 04 24             	mov    %eax,(%esp)
801045ba:	e8 54 d2 ff ff       	call   80101813 <idup>
801045bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045c2:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801045c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c8:	8b 40 10             	mov    0x10(%eax),%eax
801045cb:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Init array of sharedmem
  for (i = 0; i < MAXSHMPROC; i++){
801045ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801045d5:	eb 14                	jmp    801045eb <fork+0x13d>
    np->shmref[i] = 0;
801045d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045dd:	83 c2 24             	add    $0x24,%edx
801045e0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045e7:	00 
  for (i = 0; i < MAXSHMPROC; i++){
801045e8:	ff 45 e4             	incl   -0x1c(%ebp)
801045eb:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
801045ef:	7e e6                	jle    801045d7 <fork+0x129>
  }

  // np->state = RUNNABLE;
  makerunnable(np,0); // New: Added in proyect 2: every process enqueued is RUNNABLE.
801045f1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045f8:	00 
801045f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045fc:	89 04 24             	mov    %eax,(%esp)
801045ff:	e8 50 fb ff ff       	call   80104154 <makerunnable>
                      // en la creacion de un proceso, debemos darle la prioridad mas alta que es 0.
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104604:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010460a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010460d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104610:	83 c0 6c             	add    $0x6c,%eax
80104613:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010461a:	00 
8010461b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010461f:	89 04 24             	mov    %eax,(%esp)
80104622:	e8 9d 14 00 00       	call   80105ac4 <safestrcpy>
  return pid;
80104627:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010462a:	83 c4 2c             	add    $0x2c,%esp
8010462d:	5b                   	pop    %ebx
8010462e:	5e                   	pop    %esi
8010462f:	5f                   	pop    %edi
80104630:	5d                   	pop    %ebp
80104631:	c3                   	ret    

80104632 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104632:	55                   	push   %ebp
80104633:	89 e5                	mov    %esp,%ebp
80104635:	53                   	push   %ebx
80104636:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int fd, sd, i;

  if(proc == initproc)
80104639:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104640:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104645:	39 c2                	cmp    %eax,%edx
80104647:	75 0c                	jne    80104655 <exit+0x23>
    panic("init exiting");
80104649:	c7 04 24 07 92 10 80 	movl   $0x80109207,(%esp)
80104650:	e8 e1 be ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104655:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010465c:	eb 43                	jmp    801046a1 <exit+0x6f>
    if(proc->ofile[fd]){
8010465e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104664:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104667:	83 c2 08             	add    $0x8,%edx
8010466a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010466e:	85 c0                	test   %eax,%eax
80104670:	74 2c                	je     8010469e <exit+0x6c>
      fileclose(proc->ofile[fd]);
80104672:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104678:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010467b:	83 c2 08             	add    $0x8,%edx
8010467e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104682:	89 04 24             	mov    %eax,(%esp)
80104685:	e8 11 c9 ff ff       	call   80100f9b <fileclose>
      proc->ofile[fd] = 0;
8010468a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104690:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104693:	83 c2 08             	add    $0x8,%edx
80104696:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010469d:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010469e:	ff 45 f0             	incl   -0x10(%ebp)
801046a1:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801046a5:	7e b7                	jle    8010465e <exit+0x2c>
    }
  }

  //Delete all semaphores
  for(sd = 0; sd < MAXSEMPROC; sd++){
801046a7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801046ae:	eb 3f                	jmp    801046ef <exit+0xbd>
    if(proc->procsem[sd]){
801046b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801046b9:	83 c2 20             	add    $0x20,%edx
801046bc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c0:	85 c0                	test   %eax,%eax
801046c2:	74 28                	je     801046ec <exit+0xba>
      semfree(proc->procsem[sd] - getstable());
801046c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
801046cd:	83 c2 20             	add    $0x20,%edx
801046d0:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046d4:	89 c3                	mov    %eax,%ebx
801046d6:	e8 01 07 00 00       	call   80104ddc <getstable>
801046db:	89 da                	mov    %ebx,%edx
801046dd:	29 c2                	sub    %eax,%edx
801046df:	89 d0                	mov    %edx,%eax
801046e1:	c1 f8 03             	sar    $0x3,%eax
801046e4:	89 04 24             	mov    %eax,(%esp)
801046e7:	e8 11 09 00 00       	call   80104ffd <semfree>
  for(sd = 0; sd < MAXSEMPROC; sd++){
801046ec:	ff 45 ec             	incl   -0x14(%ebp)
801046ef:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
801046f3:	7e bb                	jle    801046b0 <exit+0x7e>
    }
  }

  proc->shmemquantity = 0;
801046f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fb:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
80104702:	00 00 00 

  begin_trans(); //add hoy dario, no estoy seguro // begin_op en linux creo
80104705:	e8 c6 ea ff ff       	call   801031d0 <begin_trans>
  iput(proc->cwd);
8010470a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104710:	8b 40 68             	mov    0x68(%eax),%eax
80104713:	89 04 24             	mov    %eax,(%esp)
80104716:	e8 da d2 ff ff       	call   801019f5 <iput>
  commit_trans(); //add hoy dario, no estoy seguro
8010471b:	e8 f9 ea ff ff       	call   80103219 <commit_trans>
  proc->cwd = 0;
80104720:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104726:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  // Free shared memory
  for(i = 0; i < MAXSHMPROC; i++){
8010472d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104734:	eb 0e                	jmp    80104744 <exit+0x112>
    if (proc->shmref[i] != 0){}
      shm_close(i);
80104736:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104739:	89 04 24             	mov    %eax,(%esp)
8010473c:	e8 7e 0b 00 00       	call   801052bf <shm_close>
  for(i = 0; i < MAXSHMPROC; i++){
80104741:	ff 45 e8             	incl   -0x18(%ebp)
80104744:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
80104748:	7e ec                	jle    80104736 <exit+0x104>
  }

  acquire(&ptable.lock);
8010474a:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104751:	e8 0a 0f 00 00       	call   80105660 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104756:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010475c:	8b 40 14             	mov    0x14(%eax),%eax
8010475f:	89 04 24             	mov    %eax,(%esp)
80104762:	e8 35 04 00 00       	call   80104b9c <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104767:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
8010476e:	eb 3b                	jmp    801047ab <exit+0x179>
    if(p->parent == proc){
80104770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104773:	8b 50 14             	mov    0x14(%eax),%edx
80104776:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010477c:	39 c2                	cmp    %eax,%edx
8010477e:	75 24                	jne    801047a4 <exit+0x172>
      p->parent = initproc;
80104780:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
80104786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104789:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010478c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478f:	8b 40 0c             	mov    0xc(%eax),%eax
80104792:	83 f8 05             	cmp    $0x5,%eax
80104795:	75 0d                	jne    801047a4 <exit+0x172>
        wakeup1(initproc);
80104797:	a1 88 c6 10 80       	mov    0x8010c688,%eax
8010479c:	89 04 24             	mov    %eax,(%esp)
8010479f:	e8 f8 03 00 00       	call   80104b9c <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047a4:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
801047ab:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
801047b2:	72 bc                	jb     80104770 <exit+0x13e>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801047b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ba:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801047c1:	e8 db 01 00 00       	call   801049a1 <sched>
  panic("zombie exit");
801047c6:	c7 04 24 14 92 10 80 	movl   $0x80109214,(%esp)
801047cd:	e8 64 bd ff ff       	call   80100536 <panic>

801047d2 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801047d2:	55                   	push   %ebp
801047d3:	89 e5                	mov    %esp,%ebp
801047d5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801047d8:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801047df:	e8 7c 0e 00 00       	call   80105660 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801047e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047eb:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801047f2:	e9 9d 00 00 00       	jmp    80104894 <wait+0xc2>
      if(p->parent != proc)
801047f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fa:	8b 50 14             	mov    0x14(%eax),%edx
801047fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104803:	39 c2                	cmp    %eax,%edx
80104805:	0f 85 81 00 00 00    	jne    8010488c <wait+0xba>
        continue;
      havekids = 1;
8010480b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104812:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104815:	8b 40 0c             	mov    0xc(%eax),%eax
80104818:	83 f8 05             	cmp    $0x5,%eax
8010481b:	75 70                	jne    8010488d <wait+0xbb>
        // Found one.
        pid = p->pid;
8010481d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104820:	8b 40 10             	mov    0x10(%eax),%eax
80104823:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104829:	8b 40 08             	mov    0x8(%eax),%eax
8010482c:	89 04 24             	mov    %eax,(%esp)
8010482f:	e8 f1 e1 ff ff       	call   80102a25 <kfree>
        p->kstack = 0;
80104834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104837:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010483e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104841:	8b 40 04             	mov    0x4(%eax),%eax
80104844:	89 04 24             	mov    %eax,(%esp)
80104847:	e8 01 43 00 00       	call   80108b4d <freevm>
        p->state = UNUSED;
8010484c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104859:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104863:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010486a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104871:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104874:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010487b:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104882:	e8 3b 0e 00 00       	call   801056c2 <release>
        return pid;
80104887:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010488a:	eb 56                	jmp    801048e2 <wait+0x110>
        continue;
8010488c:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488d:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104894:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
8010489b:	0f 82 56 ff ff ff    	jb     801047f7 <wait+0x25>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801048a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801048a5:	74 0d                	je     801048b4 <wait+0xe2>
801048a7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ad:	8b 40 24             	mov    0x24(%eax),%eax
801048b0:	85 c0                	test   %eax,%eax
801048b2:	74 13                	je     801048c7 <wait+0xf5>
      release(&ptable.lock);
801048b4:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048bb:	e8 02 0e 00 00       	call   801056c2 <release>
      return -1;
801048c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c5:	eb 1b                	jmp    801048e2 <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801048c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048cd:	c7 44 24 04 00 10 11 	movl   $0x80111000,0x4(%esp)
801048d4:	80 
801048d5:	89 04 24             	mov    %eax,(%esp)
801048d8:	e8 01 02 00 00       	call   80104ade <sleep>
  }
801048dd:	e9 02 ff ff ff       	jmp    801047e4 <wait+0x12>
}
801048e2:	c9                   	leave  
801048e3:	c3                   	ret    

801048e4 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801048e4:	55                   	push   %ebp
801048e5:	89 e5                	mov    %esp,%ebp
801048e7:	83 ec 28             	sub    $0x28,%esp
  int i; // New: Added in project 2
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801048ea:	e8 ee f6 ff ff       	call   80103fdd <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048ef:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048f6:	e8 65 0d 00 00       	call   80105660 <acquire>
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue; // continue, move pointer

    // Set pointer p in zero (null)
    p=0;
801048fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    // Loop over MLF table looking for process to run.
    for(i=0; i<MLF_LEVELS; i++){
80104902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104909:	eb 22                	jmp    8010492d <scheduler+0x49>
      if(!isempty(i)){
8010490b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490e:	89 04 24             	mov    %eax,(%esp)
80104911:	e8 1a f8 ff ff       	call   80104130 <isempty>
80104916:	85 c0                	test   %eax,%eax
80104918:	75 10                	jne    8010492a <scheduler+0x46>
        // New - when a proc state changes to RUNNING it must be dequeued
        p=dequeue(i);
8010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491d:	89 04 24             	mov    %eax,(%esp)
80104920:	e8 bc f7 ff ff       	call   801040e1 <dequeue>
80104925:	89 45 f0             	mov    %eax,-0x10(%ebp)
        break;
80104928:	eb 09                	jmp    80104933 <scheduler+0x4f>
    for(i=0; i<MLF_LEVELS; i++){
8010492a:	ff 45 f4             	incl   -0xc(%ebp)
8010492d:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104931:	7e d8                	jle    8010490b <scheduler+0x27>
      }
    }

    // If pointer not null (RUNNABLE proccess found)
    if (p) {
80104933:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104937:	74 57                	je     80104990 <scheduler+0xac>
      proc = p; //(ahora, el proceso actual en esta cpu).
80104939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010493c:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      // proc = p; // p->state == RUNNABLE
      
      switchuvm(p); // Switch TSS and h/w page table to correspond to process p.
80104942:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104945:	89 04 24             	mov    %eax,(%esp)
80104948:	e8 7a 3d 00 00       	call   801086c7 <switchuvm>
      p->state = RUNNING;
8010494d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104950:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->ticksProc = 0;  // New - when a proccess takes control, set ticksCounter on zero
80104957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010495a:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
      // cprintf("proccess %s takes control of the CPU...\n",p->name);
      swtch(&cpu->scheduler, proc->context);
80104961:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104967:	8b 40 1c             	mov    0x1c(%eax),%eax
8010496a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104971:	83 c2 04             	add    $0x4,%edx
80104974:	89 44 24 04          	mov    %eax,0x4(%esp)
80104978:	89 14 24             	mov    %edx,(%esp)
8010497b:	e8 b2 11 00 00       	call   80105b32 <swtch>
      switchkvm(); // Switch h/w page table register to the kernel-only page table,
80104980:	e8 25 3d 00 00       	call   801086aa <switchkvm>
                  // for when no process is running.

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104985:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010498c:	00 00 00 00 
    }
    release(&ptable.lock);
80104990:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104997:	e8 26 0d 00 00       	call   801056c2 <release>

  }
8010499c:	e9 49 ff ff ff       	jmp    801048ea <scheduler+0x6>

801049a1 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801049a1:	55                   	push   %ebp
801049a2:	89 e5                	mov    %esp,%ebp
801049a4:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801049a7:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801049ae:	e8 d5 0d 00 00       	call   80105788 <holding>
801049b3:	85 c0                	test   %eax,%eax
801049b5:	75 0c                	jne    801049c3 <sched+0x22>
    panic("sched ptable.lock");
801049b7:	c7 04 24 20 92 10 80 	movl   $0x80109220,(%esp)
801049be:	e8 73 bb ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
801049c3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049c9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801049cf:	83 f8 01             	cmp    $0x1,%eax
801049d2:	74 0c                	je     801049e0 <sched+0x3f>
    panic("sched locks");
801049d4:	c7 04 24 32 92 10 80 	movl   $0x80109232,(%esp)
801049db:	e8 56 bb ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
801049e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049e6:	8b 40 0c             	mov    0xc(%eax),%eax
801049e9:	83 f8 04             	cmp    $0x4,%eax
801049ec:	75 0c                	jne    801049fa <sched+0x59>
    panic("sched running");
801049ee:	c7 04 24 3e 92 10 80 	movl   $0x8010923e,(%esp)
801049f5:	e8 3c bb ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
801049fa:	e8 c9 f5 ff ff       	call   80103fc8 <readeflags>
801049ff:	25 00 02 00 00       	and    $0x200,%eax
80104a04:	85 c0                	test   %eax,%eax
80104a06:	74 0c                	je     80104a14 <sched+0x73>
    panic("sched interruptible");
80104a08:	c7 04 24 4c 92 10 80 	movl   $0x8010924c,(%esp)
80104a0f:	e8 22 bb ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104a14:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a1a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104a23:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a29:	8b 40 04             	mov    0x4(%eax),%eax
80104a2c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a33:	83 c2 1c             	add    $0x1c,%edx
80104a36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a3a:	89 14 24             	mov    %edx,(%esp)
80104a3d:	e8 f0 10 00 00       	call   80105b32 <swtch>
  cpu->intena = intena;
80104a42:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a4b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104a51:	c9                   	leave  
80104a52:	c3                   	ret    

80104a53 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104a53:	55                   	push   %ebp
80104a54:	89 e5                	mov    %esp,%ebp
80104a56:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a59:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104a60:	e8 fb 0b 00 00       	call   80105660 <acquire>
  // proc->state = RUNNABLE;
  // sched();
  if(proc->priority<3){ 
80104a65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a71:	83 f8 02             	cmp    $0x2,%eax
80104a74:	7f 13                	jg     80104a89 <yield+0x36>
    proc->priority++;
80104a76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7c:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a82:	42                   	inc    %edx
80104a83:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  makerunnable(proc,1); // New: Added in proyect 2: enqueue proc
80104a89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104a96:	00 
80104a97:	89 04 24             	mov    %eax,(%esp)
80104a9a:	e8 b5 f6 ff ff       	call   80104154 <makerunnable>
  sched(); 
80104a9f:	e8 fd fe ff ff       	call   801049a1 <sched>
  release(&ptable.lock);
80104aa4:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104aab:	e8 12 0c 00 00       	call   801056c2 <release>
}
80104ab0:	c9                   	leave  
80104ab1:	c3                   	ret    

80104ab2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ab2:	55                   	push   %ebp
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ab8:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104abf:	e8 fe 0b 00 00       	call   801056c2 <release>

  if (first) {
80104ac4:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104ac9:	85 c0                	test   %eax,%eax
80104acb:	74 0f                	je     80104adc <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104acd:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104ad4:	00 00 00 
    initlog();
80104ad7:	e8 e6 e4 ff ff       	call   80102fc2 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104adc:	c9                   	leave  
80104add:	c3                   	ret    

80104ade <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104ade:	55                   	push   %ebp
80104adf:	89 e5                	mov    %esp,%ebp
80104ae1:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104ae4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104aea:	85 c0                	test   %eax,%eax
80104aec:	75 0c                	jne    80104afa <sleep+0x1c>
    panic("sleep");
80104aee:	c7 04 24 60 92 10 80 	movl   $0x80109260,(%esp)
80104af5:	e8 3c ba ff ff       	call   80100536 <panic>

  if(lk == 0)
80104afa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104afe:	75 0c                	jne    80104b0c <sleep+0x2e>
    panic("sleep without lk");
80104b00:	c7 04 24 66 92 10 80 	movl   $0x80109266,(%esp)
80104b07:	e8 2a ba ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b0c:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b13:	74 17                	je     80104b2c <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b15:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b1c:	e8 3f 0b 00 00       	call   80105660 <acquire>
    release(lk);
80104b21:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b24:	89 04 24             	mov    %eax,(%esp)
80104b27:	e8 96 0b 00 00       	call   801056c2 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104b2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b32:	8b 55 08             	mov    0x8(%ebp),%edx
80104b35:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING; 
80104b38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3e:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  // New -  when a proc goes to SLEEPING state, increase priority
  if(proc->priority > 0){ // New: Added in proyect 2
80104b45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b51:	85 c0                	test   %eax,%eax
80104b53:	7e 13                	jle    80104b68 <sleep+0x8a>
    proc->priority--;
80104b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5b:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b61:	4a                   	dec    %edx
80104b62:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  sched();
80104b68:	e8 34 fe ff ff       	call   801049a1 <sched>

  // Tidy up.
  proc->chan = 0; // If non-zero, sleeping on chan
80104b6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b73:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104b7a:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b81:	74 17                	je     80104b9a <sleep+0xbc>
    release(&ptable.lock);
80104b83:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b8a:	e8 33 0b 00 00       	call   801056c2 <release>
    acquire(lk);
80104b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b92:	89 04 24             	mov    %eax,(%esp)
80104b95:	e8 c6 0a 00 00       	call   80105660 <acquire>
  }
}
80104b9a:	c9                   	leave  
80104b9b:	c3                   	ret    

80104b9c <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104b9c:	55                   	push   %ebp
80104b9d:	89 e5                	mov    %esp,%ebp
80104b9f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ba2:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104ba9:	eb 30                	jmp    80104bdb <wakeup1+0x3f>
    // if(p->state == SLEEPING && p->chan == chan)
    //   p->state = RUNNABLE;
    if(p->state == SLEEPING && p->chan == chan){ // Added in project 2
80104bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bae:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb1:	83 f8 02             	cmp    $0x2,%eax
80104bb4:	75 1e                	jne    80104bd4 <wakeup1+0x38>
80104bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb9:	8b 40 20             	mov    0x20(%eax),%eax
80104bbc:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bbf:	75 13                	jne    80104bd4 <wakeup1+0x38>
      // New - enqueue proc
      makerunnable(p,-1);
80104bc1:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
80104bc8:	ff 
80104bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bcc:	89 04 24             	mov    %eax,(%esp)
80104bcf:	e8 80 f5 ff ff       	call   80104154 <makerunnable>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bd4:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104bdb:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104be2:	72 c7                	jb     80104bab <wakeup1+0xf>
    }
}
80104be4:	c9                   	leave  
80104be5:	c3                   	ret    

80104be6 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104be6:	55                   	push   %ebp
80104be7:	89 e5                	mov    %esp,%ebp
80104be9:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104bec:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104bf3:	e8 68 0a 00 00       	call   80105660 <acquire>
  wakeup1(chan);
80104bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bfb:	89 04 24             	mov    %eax,(%esp)
80104bfe:	e8 99 ff ff ff       	call   80104b9c <wakeup1>
  release(&ptable.lock);
80104c03:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c0a:	e8 b3 0a 00 00       	call   801056c2 <release>
}
80104c0f:	c9                   	leave  
80104c10:	c3                   	ret    

80104c11 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c11:	55                   	push   %ebp
80104c12:	89 e5                	mov    %esp,%ebp
80104c14:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c17:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c1e:	e8 3d 0a 00 00       	call   80105660 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c23:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104c2a:	eb 4d                	jmp    80104c79 <kill+0x68>
    if(p->pid == pid){
80104c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2f:	8b 40 10             	mov    0x10(%eax),%eax
80104c32:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c35:	75 3b                	jne    80104c72 <kill+0x61>
      p->killed = 1; // killed: If non-zero, have been killed
80104c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      // if(p->state == SLEEPING)
      //   p->state = RUNNABLE;
      if(p->state == SLEEPING){ // Added in proyect 2
80104c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c44:	8b 40 0c             	mov    0xc(%eax),%eax
80104c47:	83 f8 02             	cmp    $0x2,%eax
80104c4a:	75 13                	jne    80104c5f <kill+0x4e>
        // New - enqueue proc
        makerunnable(p,0);
80104c4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c53:	00 
80104c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c57:	89 04 24             	mov    %eax,(%esp)
80104c5a:	e8 f5 f4 ff ff       	call   80104154 <makerunnable>
      }
      release(&ptable.lock);
80104c5f:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c66:	e8 57 0a 00 00       	call   801056c2 <release>
      return 0;
80104c6b:	b8 00 00 00 00       	mov    $0x0,%eax
80104c70:	eb 21                	jmp    80104c93 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c72:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104c79:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104c80:	72 aa                	jb     80104c2c <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104c82:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c89:	e8 34 0a 00 00       	call   801056c2 <release>
  return -1;
80104c8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c93:	c9                   	leave  
80104c94:	c3                   	ret    

80104c95 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c95:	55                   	push   %ebp
80104c96:	89 e5                	mov    %esp,%ebp
80104c98:	83 ec 68             	sub    $0x68,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c9b:	c7 45 f0 34 10 11 80 	movl   $0x80111034,-0x10(%ebp)
80104ca2:	e9 e7 00 00 00       	jmp    80104d8e <procdump+0xf9>
    if(p->state == UNUSED)
80104ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104caa:	8b 40 0c             	mov    0xc(%eax),%eax
80104cad:	85 c0                	test   %eax,%eax
80104caf:	0f 84 d1 00 00 00    	je     80104d86 <procdump+0xf1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb8:	8b 40 0c             	mov    0xc(%eax),%eax
80104cbb:	83 f8 05             	cmp    $0x5,%eax
80104cbe:	77 23                	ja     80104ce3 <procdump+0x4e>
80104cc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cc3:	8b 40 0c             	mov    0xc(%eax),%eax
80104cc6:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104ccd:	85 c0                	test   %eax,%eax
80104ccf:	74 12                	je     80104ce3 <procdump+0x4e>
      state = states[p->state];
80104cd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd4:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd7:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104cde:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ce1:	eb 07                	jmp    80104cea <procdump+0x55>
    else
      state = "???";
80104ce3:	c7 45 ec 77 92 10 80 	movl   $0x80109277,-0x14(%ebp)
    // cprintf("%d %s %s", p->pid, state, p->name);
    cprintf("%d %s %s %d", p->pid, state, p->name, p->priority);
80104cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ced:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cf6:	8d 48 6c             	lea    0x6c(%eax),%ecx
80104cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cfc:	8b 40 10             	mov    0x10(%eax),%eax
80104cff:	89 54 24 10          	mov    %edx,0x10(%esp)
80104d03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80104d07:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d0a:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d12:	c7 04 24 7b 92 10 80 	movl   $0x8010927b,(%esp)
80104d19:	e8 83 b6 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d21:	8b 40 0c             	mov    0xc(%eax),%eax
80104d24:	83 f8 02             	cmp    $0x2,%eax
80104d27:	75 4f                	jne    80104d78 <procdump+0xe3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d2c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d2f:	8b 40 0c             	mov    0xc(%eax),%eax
80104d32:	83 c0 08             	add    $0x8,%eax
80104d35:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d38:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d3c:	89 04 24             	mov    %eax,(%esp)
80104d3f:	e8 cd 09 00 00       	call   80105711 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d4b:	eb 1a                	jmp    80104d67 <procdump+0xd2>
        cprintf(" %p", pc[i]);
80104d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d50:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d54:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d58:	c7 04 24 87 92 10 80 	movl   $0x80109287,(%esp)
80104d5f:	e8 3d b6 ff ff       	call   801003a1 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d64:	ff 45 f4             	incl   -0xc(%ebp)
80104d67:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104d6b:	7f 0b                	jg     80104d78 <procdump+0xe3>
80104d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d70:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d74:	85 c0                	test   %eax,%eax
80104d76:	75 d5                	jne    80104d4d <procdump+0xb8>
    }
    cprintf("\n");
80104d78:	c7 04 24 8b 92 10 80 	movl   $0x8010928b,(%esp)
80104d7f:	e8 1d b6 ff ff       	call   801003a1 <cprintf>
80104d84:	eb 01                	jmp    80104d87 <procdump+0xf2>
      continue;
80104d86:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d87:	81 45 f0 ac 00 00 00 	addl   $0xac,-0x10(%ebp)
80104d8e:	81 7d f0 34 3b 11 80 	cmpl   $0x80113b34,-0x10(%ebp)
80104d95:	0f 82 0c ff ff ff    	jb     80104ca7 <procdump+0x12>
  }
}
80104d9b:	c9                   	leave  
80104d9c:	c3                   	ret    

80104d9d <checkprocsem>:
	struct sem sem[MAXSEM]; // atrib. (value,refcount) (MAXSEM = 16)
} stable;

// proc->procsem es la lista de semaforos por proceso
// MAXSEMPROC = 4 es la cantidad maxima de semaforos por proceso
struct sem** checkprocsem(){
80104d9d:	55                   	push   %ebp
80104d9e:	89 e5                	mov    %esp,%ebp
80104da0:	83 ec 10             	sub    $0x10,%esp
	struct sem **r;
	// a "r" le asigno el arreglo de la list of semaphores del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104da3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da9:	05 88 00 00 00       	add    $0x88,%eax
80104dae:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104db1:	eb 12                	jmp    80104dc5 <checkprocsem+0x28>
		if (*r == 0)
80104db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104db6:	8b 00                	mov    (%eax),%eax
80104db8:	85 c0                	test   %eax,%eax
80104dba:	75 05                	jne    80104dc1 <checkprocsem+0x24>
			return r;
80104dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dbf:	eb 19                	jmp    80104dda <checkprocsem+0x3d>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104dc1:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
80104dc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dcb:	05 98 00 00 00       	add    $0x98,%eax
80104dd0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104dd3:	77 de                	ja     80104db3 <checkprocsem+0x16>
	}
	return 0;
80104dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dda:	c9                   	leave  
80104ddb:	c3                   	ret    

80104ddc <getstable>:

struct sem* getstable(){
80104ddc:	55                   	push   %ebp
80104ddd:	89 e5                	mov    %esp,%ebp
	return stable.sem;
80104ddf:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
}
80104de4:	5d                   	pop    %ebp
80104de5:	c3                   	ret    

80104de6 <semget>:

// crea u obtiene un descriptor de un semaforo existente
int semget(int sem_id, int init_value){
80104de6:	55                   	push   %ebp
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	56                   	push   %esi
80104dea:	53                   	push   %ebx
80104deb:	83 ec 30             	sub    $0x30,%esp
	struct sem *t;
	struct sem *s;
	struct sem **r;
	static int first_time = 1;

	if (first_time) {
80104dee:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80104df3:	85 c0                	test   %eax,%eax
80104df5:	74 1e                	je     80104e15 <semget+0x2f>
		initlock(&stable.lock, "stable"); // begin the mutual exclusion
80104df7:	c7 44 24 04 bc 92 10 	movl   $0x801092bc,0x4(%esp)
80104dfe:	80 
80104dff:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e06:	e8 34 08 00 00       	call   8010563f <initlock>
		first_time = 0;
80104e0b:	c7 05 24 c0 10 80 00 	movl   $0x0,0x8010c024
80104e12:	00 00 00 
	}

	acquire(&stable.lock);
80104e15:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e1c:	e8 3f 08 00 00       	call   80105660 <acquire>
	if (sem_id == -1) { // se desea CREAR un semaforo nuevo
80104e21:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
80104e25:	0f 85 50 01 00 00    	jne    80104f7b <semget+0x195>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e2b:	c7 45 f0 94 3b 11 80 	movl   $0x80113b94,-0x10(%ebp)
80104e32:	eb 3b                	jmp    80104e6f <semget+0x89>
		if (t->refcount == 0){
80104e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e37:	8b 40 04             	mov    0x4(%eax),%eax
80104e3a:	85 c0                	test   %eax,%eax
80104e3c:	75 2d                	jne    80104e6b <semget+0x85>
			s = t;
80104e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e41:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (*(r = checkprocsem()) == 0)
80104e44:	e8 54 ff ff ff       	call   80104d9d <checkprocsem>
80104e49:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104e4f:	8b 00                	mov    (%eax),%eax
80104e51:	85 c0                	test   %eax,%eax
80104e53:	74 39                	je     80104e8e <semget+0xa8>
				goto found; // encontro
			release(&stable.lock);
80104e55:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e5c:	e8 61 08 00 00       	call   801056c2 <release>
			return -2; // el proceso ya obtuvo el numero maximo de semaforos
80104e61:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104e66:	e9 8b 01 00 00       	jmp    80104ff6 <semget+0x210>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e6b:	83 45 f0 08          	addl   $0x8,-0x10(%ebp)
80104e6f:	81 7d f0 14 3c 11 80 	cmpl   $0x80113c14,-0x10(%ebp)
80104e76:	72 bc                	jb     80104e34 <semget+0x4e>
		}
		release(&stable.lock);
80104e78:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e7f:	e8 3e 08 00 00       	call   801056c2 <release>
		return -3; // no ahi mas semaforos disponibles en el sistema
80104e84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80104e89:	e9 68 01 00 00       	jmp    80104ff6 <semget+0x210>
				goto found; // encontro
80104e8e:	90                   	nop

		found:
		s->value = init_value;
80104e8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e92:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e95:	89 10                	mov    %edx,(%eax)
		s->refcount=1;
80104e97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e9a:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
		*r = s;
80104ea1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104ea4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ea7:	89 10                	mov    %edx,(%eax)

		cprintf("SEMGET>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s - stable.sem, s->value, s->refcount);
80104ea9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eac:	8b 48 04             	mov    0x4(%eax),%ecx
80104eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eb2:	8b 10                	mov    (%eax),%edx
80104eb4:	8b 5d ec             	mov    -0x14(%ebp),%ebx
80104eb7:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
80104ebc:	89 de                	mov    %ebx,%esi
80104ebe:	29 c6                	sub    %eax,%esi
80104ec0:	89 f0                	mov    %esi,%eax
80104ec2:	c1 f8 03             	sar    $0x3,%eax
80104ec5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80104ec9:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104ecd:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ed1:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ed8:	c7 04 24 c4 92 10 80 	movl   $0x801092c4,(%esp)
80104edf:	e8 bd b4 ff ff       	call   801003a1 <cprintf>
		for (i = 0; i < MAXSEMPROC; i++) {
80104ee4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104eeb:	eb 69                	jmp    80104f56 <semget+0x170>
			if (*(proc->procsem + i) == 0) {
80104eed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ef6:	83 c2 20             	add    $0x20,%edx
80104ef9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104efd:	85 c0                	test   %eax,%eax
80104eff:	75 22                	jne    80104f23 <semget+0x13d>
				cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i));
80104f01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f07:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f0a:	83 c2 20             	add    $0x20,%edx
80104f0d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f11:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f15:	c7 04 24 02 93 10 80 	movl   $0x80109302,(%esp)
80104f1c:	e8 80 b4 ff ff       	call   801003a1 <cprintf>
80104f21:	eb 30                	jmp    80104f53 <semget+0x16d>
			} else
				cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i) - stable.sem);
80104f23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f2c:	83 c2 20             	add    $0x20,%edx
80104f2f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f33:	89 c2                	mov    %eax,%edx
80104f35:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
80104f3a:	89 d1                	mov    %edx,%ecx
80104f3c:	29 c1                	sub    %eax,%ecx
80104f3e:	89 c8                	mov    %ecx,%eax
80104f40:	c1 f8 03             	sar    $0x3,%eax
80104f43:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f47:	c7 04 24 02 93 10 80 	movl   $0x80109302,(%esp)
80104f4e:	e8 4e b4 ff ff       	call   801003a1 <cprintf>
		for (i = 0; i < MAXSEMPROC; i++) {
80104f53:	ff 45 f4             	incl   -0xc(%ebp)
80104f56:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104f5a:	7e 91                	jle    80104eed <semget+0x107>
		}

		release(&stable.lock);
80104f5c:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104f63:	e8 5a 07 00 00       	call   801056c2 <release>
		return s - stable.sem;	// retorna el semaforo
80104f68:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f6b:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
80104f70:	89 d6                	mov    %edx,%esi
80104f72:	29 c6                	sub    %eax,%esi
80104f74:	89 f0                	mov    %esi,%eax
80104f76:	c1 f8 03             	sar    $0x3,%eax
80104f79:	eb 7b                	jmp    80104ff6 <semget+0x210>

	} else { // en caso de que NO se desea crear un semaforo nuevo
		s = stable.sem + sem_id;
80104f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7e:	83 c0 06             	add    $0x6,%eax
80104f81:	c1 e0 03             	shl    $0x3,%eax
80104f84:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104f89:	83 c0 04             	add    $0x4,%eax
80104f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (s->refcount == 0){
80104f8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f92:	8b 40 04             	mov    0x4(%eax),%eax
80104f95:	85 c0                	test   %eax,%eax
80104f97:	75 13                	jne    80104fac <semget+0x1c6>
			release(&stable.lock);
80104f99:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fa0:	e8 1d 07 00 00       	call   801056c2 <release>
			return -1; // el semaforo con ese "sem_id" no esta en uso 
80104fa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104faa:	eb 4a                	jmp    80104ff6 <semget+0x210>
		}else if (*(r = checkprocsem()) == 0){
80104fac:	e8 ec fd ff ff       	call   80104d9d <checkprocsem>
80104fb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80104fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104fb7:	8b 00                	mov    (%eax),%eax
80104fb9:	85 c0                	test   %eax,%eax
80104fbb:	75 28                	jne    80104fe5 <semget+0x1ff>
			*r = s;
80104fbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104fc0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104fc3:	89 10                	mov    %edx,(%eax)
			s->refcount++;
80104fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fc8:	8b 40 04             	mov    0x4(%eax),%eax
80104fcb:	8d 50 01             	lea    0x1(%eax),%edx
80104fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fd1:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80104fd4:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fdb:	e8 e2 06 00 00       	call   801056c2 <release>
			return sem_id;
80104fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe3:	eb 11                	jmp    80104ff6 <semget+0x210>
		}	else {
			release(&stable.lock);
80104fe5:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fec:	e8 d1 06 00 00       	call   801056c2 <release>
			return -2; // el proceso ya obtuvo el maximo de semaforos
80104ff1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

		}
	}
}
80104ff6:	83 c4 30             	add    $0x30,%esp
80104ff9:	5b                   	pop    %ebx
80104ffa:	5e                   	pop    %esi
80104ffb:	5d                   	pop    %ebp
80104ffc:	c3                   	ret    

80104ffd <semfree>:

// libera el semaforo.
// como parametro toma un descriptor.
int semfree(int sem_id){
80104ffd:	55                   	push   %ebp
80104ffe:	89 e5                	mov    %esp,%ebp
80105000:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;
	struct sem **r;

	s = stable.sem + sem_id;
80105003:	8b 45 08             	mov    0x8(%ebp),%eax
80105006:	83 c0 06             	add    $0x6,%eax
80105009:	c1 e0 03             	shl    $0x3,%eax
8010500c:	05 60 3b 11 80       	add    $0x80113b60,%eax
80105011:	83 c0 04             	add    $0x4,%eax
80105014:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (s->refcount == 0) // si no tiene ninguna referencia, entonces no esta en uso,	
80105017:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010501a:	8b 40 04             	mov    0x4(%eax),%eax
8010501d:	85 c0                	test   %eax,%eax
8010501f:	75 07                	jne    80105028 <semfree+0x2b>
		return -1;		 //  y no es posible liberarlo, se produce un ERROR! 
80105021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105026:	eb 6a                	jmp    80105092 <semfree+0x95>

	// recorro todos los semaforos del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80105028:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010502e:	05 88 00 00 00       	add    $0x88,%eax
80105033:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105036:	eb 45                	jmp    8010507d <semfree+0x80>
		if (*r == s) {
80105038:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010503b:	8b 00                	mov    (%eax),%eax
8010503d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80105040:	75 37                	jne    80105079 <semfree+0x7c>
			*r = 0;
80105042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			acquire(&stable.lock);
8010504b:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105052:	e8 09 06 00 00       	call   80105660 <acquire>
			s->refcount--; // disminuyo el contador, debido a q es un semaforo q se va.
80105057:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010505a:	8b 40 04             	mov    0x4(%eax),%eax
8010505d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105060:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105063:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80105066:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
8010506d:	e8 50 06 00 00       	call   801056c2 <release>
			return 0;
80105072:	b8 00 00 00 00       	mov    $0x0,%eax
80105077:	eb 19                	jmp    80105092 <semfree+0x95>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80105079:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
8010507d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105083:	05 98 00 00 00       	add    $0x98,%eax
80105088:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010508b:	77 ab                	ja     80105038 <semfree+0x3b>
		}
	}
	return -1;
8010508d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105092:	c9                   	leave  
80105093:	c3                   	ret    

80105094 <semdown>:

// decrementa una unidad el valor del semaforo.
int semdown(int sem_id){
80105094:	55                   	push   %ebp
80105095:	89 e5                	mov    %esp,%ebp
80105097:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;

	s = stable.sem + sem_id;
8010509a:	8b 45 08             	mov    0x8(%ebp),%eax
8010509d:	83 c0 06             	add    $0x6,%eax
801050a0:	c1 e0 03             	shl    $0x3,%eax
801050a3:	05 60 3b 11 80       	add    $0x80113b60,%eax
801050a8:	83 c0 04             	add    $0x4,%eax
801050ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
801050ae:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
801050b5:	e8 a6 05 00 00       	call   80105660 <acquire>
	if (s->refcount <= 0) {
801050ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bd:	8b 40 04             	mov    0x4(%eax),%eax
801050c0:	85 c0                	test   %eax,%eax
801050c2:	7f 28                	jg     801050ec <semdown+0x58>
		release(&stable.lock);
801050c4:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
801050cb:	e8 f2 05 00 00       	call   801056c2 <release>
		// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error!!
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d5:	eb 3d                	jmp    80105114 <semdown+0x80>
	}
	while (s->value == 0)
		sleep(s, &stable.lock); 
801050d7:	c7 44 24 04 60 3b 11 	movl   $0x80113b60,0x4(%esp)
801050de:	80 
801050df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e2:	89 04 24             	mov    %eax,(%esp)
801050e5:	e8 f4 f9 ff ff       	call   80104ade <sleep>
801050ea:	eb 01                	jmp    801050ed <semdown+0x59>
	while (s->value == 0)
801050ec:	90                   	nop
801050ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f0:	8b 00                	mov    (%eax),%eax
801050f2:	85 c0                	test   %eax,%eax
801050f4:	74 e1                	je     801050d7 <semdown+0x43>

	s->value--;
801050f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f9:	8b 00                	mov    (%eax),%eax
801050fb:	8d 50 ff             	lea    -0x1(%eax),%edx
801050fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105101:	89 10                	mov    %edx,(%eax)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	release(&stable.lock);
80105103:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
8010510a:	e8 b3 05 00 00       	call   801056c2 <release>
	return 0;
8010510f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105114:	c9                   	leave  
80105115:	c3                   	ret    

80105116 <semup>:

// incrementa una unidad el valor del semaforo
int semup(int sem_id){
80105116:	55                   	push   %ebp
80105117:	89 e5                	mov    %esp,%ebp
80105119:	83 ec 28             	sub    $0x28,%esp
struct sem *s;

	s = stable.sem + sem_id;
8010511c:	8b 45 08             	mov    0x8(%ebp),%eax
8010511f:	83 c0 06             	add    $0x6,%eax
80105122:	c1 e0 03             	shl    $0x3,%eax
80105125:	05 60 3b 11 80       	add    $0x80113b60,%eax
8010512a:	83 c0 04             	add    $0x4,%eax
8010512d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
80105130:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105137:	e8 24 05 00 00       	call   80105660 <acquire>
	if (s->refcount <= 0) {
8010513c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513f:	8b 40 04             	mov    0x4(%eax),%eax
80105142:	85 c0                	test   %eax,%eax
80105144:	7f 13                	jg     80105159 <semup+0x43>
		release(&stable.lock);
80105146:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
8010514d:	e8 70 05 00 00       	call   801056c2 <release>
		// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error, por que no ahi referencias en este semaforo.
80105152:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105157:	eb 4a                	jmp    801051a3 <semup+0x8d>
	}
	if (s->value >= 0) {
80105159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515c:	8b 00                	mov    (%eax),%eax
8010515e:	85 c0                	test   %eax,%eax
80105160:	78 3c                	js     8010519e <semup+0x88>
		if (s->value == 0){
80105162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105165:	8b 00                	mov    (%eax),%eax
80105167:	85 c0                	test   %eax,%eax
80105169:	75 1a                	jne    80105185 <semup+0x6f>
			s->value++;
8010516b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516e:	8b 00                	mov    (%eax),%eax
80105170:	8d 50 01             	lea    0x1(%eax),%edx
80105173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105176:	89 10                	mov    %edx,(%eax)
			wakeup(s); // despierto
80105178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517b:	89 04 24             	mov    %eax,(%esp)
8010517e:	e8 63 fa ff ff       	call   80104be6 <wakeup>
80105183:	eb 0d                	jmp    80105192 <semup+0x7c>
		}else
			s->value++;
80105185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105188:	8b 00                	mov    (%eax),%eax
8010518a:	8d 50 01             	lea    0x1(%eax),%edx
8010518d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105190:	89 10                	mov    %edx,(%eax)
			release(&stable.lock);
80105192:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105199:	e8 24 05 00 00       	call   801056c2 <release>
			// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	}
	return 0;
8010519e:	b8 00 00 00 00       	mov    $0x0,%eax
801051a3:	c9                   	leave  
801051a4:	c3                   	ret    

801051a5 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801051a5:	55                   	push   %ebp
801051a6:	89 e5                	mov    %esp,%ebp
801051a8:	8b 45 08             	mov    0x8(%ebp),%eax
801051ab:	05 00 00 00 80       	add    $0x80000000,%eax
801051b0:	5d                   	pop    %ebp
801051b1:	c3                   	ret    

801051b2 <shm_init>:
//   unsigned short quantity; //quantity of actives espaces of shared memory
// } shmtable;

int
shm_init()
{
801051b2:	55                   	push   %ebp
801051b3:	89 e5                	mov    %esp,%ebp
801051b5:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&shmtable.lock, "shmtable");
801051b8:	c7 44 24 04 1d 93 10 	movl   $0x8010931d,0x4(%esp)
801051bf:	80 
801051c0:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801051c7:	e8 73 04 00 00       	call   8010563f <initlock>
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
801051cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801051d3:	eb 11                	jmp    801051e6 <shm_init+0x34>
    shmtable.sharedmemory[i].refcount = -1; // inician todos los espacios con su contador de referencia en -1.
801051d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d8:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
801051df:	ff ff ff ff 
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
801051e3:	ff 45 f4             	incl   -0xc(%ebp)
801051e6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
801051ea:	7e e9                	jle    801051d5 <shm_init+0x23>
  }
  return 0;
801051ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801051f1:	c9                   	leave  
801051f2:	c3                   	ret    

801051f3 <shm_create>:

//Creates a shared memory block.
int
shm_create()
{ 
801051f3:	55                   	push   %ebp
801051f4:	89 e5                	mov    %esp,%ebp
801051f6:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);
801051f9:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105200:	e8 5b 04 00 00       	call   80105660 <acquire>
  if ( shmtable.quantity == MAXSHM ){ // si la cantidad de espacios activos en sharedmemory es igual a 12
80105205:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
8010520a:	66 83 f8 0c          	cmp    $0xc,%ax
8010520e:	75 16                	jne    80105226 <shm_create+0x33>
    release(&shmtable.lock);         // es la logitud maxima del array sharedmemory, entonces:
80105210:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105217:	e8 a6 04 00 00       	call   801056c2 <release>
    return -1;                      // no ahi mas espacios de memoria compartida, se fueron los 12 espacios que habia.
8010521c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105221:	e9 97 00 00 00       	jmp    801052bd <shm_create+0xca>
  }
  int i = 0;
80105226:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
8010522d:	eb 77                	jmp    801052a6 <shm_create+0xb3>
    if (shmtable.sharedmemory[i].refcount == -1){ // si es -1, esta desocupado el espacio.
8010522f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105232:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105239:	83 f8 ff             	cmp    $0xffffffff,%eax
8010523c:	75 65                	jne    801052a3 <shm_create+0xb0>
      shmtable.sharedmemory[i].addr = kalloc(); // El "kalloc" asigna una pagina de 4096 bytes de memoria fisica,
8010523e:	e8 7b d8 ff ff       	call   80102abe <kalloc>
80105243:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105246:	89 04 d5 60 0f 11 80 	mov    %eax,-0x7feef0a0(,%edx,8)
                                                // si todo sale bien, me retorna como resultado un puntero (direccion), 
                                                // a esta direccion la almaceno en "sharedmemory.addr".
                                                // Si el kalloc no pudo asignar la memoria me devuelve como resultado 0.
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE); 
8010524d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105250:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
80105257:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010525e:	00 
8010525f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105266:	00 
80105267:	89 04 24             	mov    %eax,(%esp)
8010526a:	e8 43 06 00 00       	call   801058b2 <memset>
      shmtable.sharedmemory[i].refcount++; // Incremento el refcount en una unidad, estaba en -1, ahora en 0, inicialmente.
8010526f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105272:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105279:	8d 50 01             	lea    0x1(%eax),%edx
8010527c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010527f:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
      shmtable.quantity++; // se tomo un espacio del arreglo 
80105286:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
8010528b:	40                   	inc    %eax
8010528c:	66 a3 f4 0f 11 80    	mov    %ax,0x80110ff4
      release(&shmtable.lock);
80105292:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105299:	e8 24 04 00 00       	call   801056c2 <release>
      return i; // retorno el indice (key) del arreglo en donde se encuentra el espacio de memoria compartida.
8010529e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052a1:	eb 1a                	jmp    801052bd <shm_create+0xca>
    } else
      ++i;
801052a3:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
801052a6:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
801052aa:	7e 83                	jle    8010522f <shm_create+0x3c>
  }
  release(&shmtable.lock);
801052ac:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052b3:	e8 0a 04 00 00       	call   801056c2 <release>
  //return -2 si proc->sharedmemory == MAXSHMPROC; // Consultar?: el proceso ya alcanzo el maximo de recursos posibles.
  return -1; // no ahi mas recursos disponbles en el sistema.
801052b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052bd:	c9                   	leave  
801052be:	c3                   	ret    

801052bf <shm_close>:

//Frees the memory block previously obtained.
int
shm_close(int key)
{
801052bf:	55                   	push   %ebp
801052c0:	89 e5                	mov    %esp,%ebp
801052c2:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);  
801052c5:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052cc:	e8 8f 03 00 00       	call   80105660 <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == -1){
801052d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801052d5:	78 15                	js     801052ec <shm_close+0x2d>
801052d7:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
801052db:	7f 0f                	jg     801052ec <shm_close+0x2d>
801052dd:	8b 45 08             	mov    0x8(%ebp),%eax
801052e0:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801052e7:	83 f8 ff             	cmp    $0xffffffff,%eax
801052ea:	75 16                	jne    80105302 <shm_close+0x43>
    release(&shmtable.lock);
801052ec:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052f3:	e8 ca 03 00 00       	call   801056c2 <release>
    return -1; // key invalidad por que no esta dentro de los indices (0 - 12), o en ese espacio esta vacio (refcount = -1)
801052f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fd:	e9 8d 00 00 00       	jmp    8010538f <shm_close+0xd0>
  }
  int i = 0;
80105302:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
80105309:	eb 03                	jmp    8010530e <shm_close+0x4f>
    i++; // avanzo al proximo
8010530b:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
8010530e:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80105312:	7f 1e                	jg     80105332 <shm_close+0x73>
80105314:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010531a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010531d:	83 c2 24             	add    $0x24,%edx
80105320:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80105324:	8b 45 08             	mov    0x8(%ebp),%eax
80105327:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
8010532e:	39 c2                	cmp    %eax,%edx
80105330:	75 d9                	jne    8010530b <shm_close+0x4c>
  }
  if (i == MAXSHMPROC){ 
80105332:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80105336:	75 13                	jne    8010534b <shm_close+0x8c>
    release(&shmtable.lock);
80105338:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010533f:	e8 7e 03 00 00       	call   801056c2 <release>
    return -1; // se alcazo a recorrer todos los espacios de memoria compartida del proceso.
80105344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105349:	eb 44                	jmp    8010538f <shm_close+0xd0>
  }  
  shmtable.sharedmemory[key].refcount--; // encontre la direccion, luego decremento refcount.
8010534b:	8b 45 08             	mov    0x8(%ebp),%eax
8010534e:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105355:	8d 50 ff             	lea    -0x1(%eax),%edx
80105358:	8b 45 08             	mov    0x8(%ebp),%eax
8010535b:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
  if (shmtable.sharedmemory[key].refcount == 0){ 
80105362:	8b 45 08             	mov    0x8(%ebp),%eax
80105365:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
8010536c:	85 c0                	test   %eax,%eax
8010536e:	75 0e                	jne    8010537e <shm_close+0xbf>
    shmtable.sharedmemory[key].refcount = -1; // reinicio el espacio en el arreglo, como solo quedo uno, lo reinicio.
80105370:	8b 45 08             	mov    0x8(%ebp),%eax
80105373:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
8010537a:	ff ff ff ff 
  }
  release(&shmtable.lock);
8010537e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105385:	e8 38 03 00 00       	call   801056c2 <release>
  return 0;  // todo en orden
8010538a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010538f:	c9                   	leave  
80105390:	c3                   	ret    

80105391 <shm_get>:

//Obtains the address of the memory block associated with key.
int
shm_get(int key, char** addr)
{
80105391:	55                   	push   %ebp
80105392:	89 e5                	mov    %esp,%ebp
80105394:	83 ec 38             	sub    $0x38,%esp
  int j;
  acquire(&shmtable.lock);
80105397:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010539e:	e8 bd 02 00 00       	call   80105660 <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == MAXSHMPROC ){ 
801053a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801053a7:	78 15                	js     801053be <shm_get+0x2d>
801053a9:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
801053ad:	7f 0f                	jg     801053be <shm_get+0x2d>
801053af:	8b 45 08             	mov    0x8(%ebp),%eax
801053b2:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801053b9:	83 f8 04             	cmp    $0x4,%eax
801053bc:	75 16                	jne    801053d4 <shm_get+0x43>
    release(&shmtable.lock);                 
801053be:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801053c5:	e8 f8 02 00 00       	call   801056c2 <release>
    return -1; // key invalida, debido a que esta fuera de los indices la key.
801053ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053cf:	e9 24 01 00 00       	jmp    801054f8 <shm_get+0x167>
  }  
  int i = 0;
801053d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
801053db:	eb 03                	jmp    801053e0 <shm_get+0x4f>
    i++;
801053dd:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
801053e0:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
801053e4:	7f 14                	jg     801053fa <shm_get+0x69>
801053e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ef:	83 c2 24             	add    $0x24,%edx
801053f2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801053f6:	85 c0                	test   %eax,%eax
801053f8:	75 e3                	jne    801053dd <shm_get+0x4c>
  }
  if (i == MAXSHMPROC ){ // si agoto los 4 espacios que posee el proceso disponible, entonces..
801053fa:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801053fe:	75 16                	jne    80105416 <shm_get+0x85>
    release(&shmtable.lock); 
80105400:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105407:	e8 b6 02 00 00       	call   801056c2 <release>
    return -1; // no ahi mas recursos disponibles (esp. de memoria compartida) por este proceso.
8010540c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105411:	e9 e2 00 00 00       	jmp    801054f8 <shm_get+0x167>
  } else {  
            
    j = mappages(proc->pgdir, (void *)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
80105416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105419:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
80105420:	89 04 24             	mov    %eax,(%esp)
80105423:	e8 7d fd ff ff       	call   801051a5 <v2p>
80105428:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010542f:	8b 12                	mov    (%edx),%edx
80105431:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105437:	89 d1                	mov    %edx,%ecx
80105439:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105440:	8b 52 04             	mov    0x4(%edx),%edx
80105443:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010544a:	00 
8010544b:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010544f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105456:	00 
80105457:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010545b:	89 14 24             	mov    %edx,(%esp)
8010545e:	e8 df 30 00 00       	call   80108542 <mappages>
80105463:	89 45 f0             	mov    %eax,-0x10(%ebp)
            // Llena entradas de la tabla de paginas, mapeo de direcciones virtuales segun direc. fisicas

            // PTE_U: controla que el proceso de usuario pueda utilizar la pagina, si no solo el kernel puede usar la pagina.
            // PTE_W: controla si las instrucciones se les permite escribir en la pagina.

    if (j==-1) { cprintf("mappages error \n"); }
80105466:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
8010546a:	75 0c                	jne    80105478 <shm_get+0xe7>
8010546c:	c7 04 24 26 93 10 80 	movl   $0x80109326,(%esp)
80105473:	e8 29 af ff ff       	call   801003a1 <cprintf>

    proc->shmref[i] = shmtable.sharedmemory[key].addr; // la guardo en shmref[i]
80105478:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547e:	8b 55 08             	mov    0x8(%ebp),%edx
80105481:	8b 14 d5 60 0f 11 80 	mov    -0x7feef0a0(,%edx,8),%edx
80105488:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010548b:	83 c1 24             	add    $0x24,%ecx
8010548e:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
    shmtable.sharedmemory[key].refcount++; 
80105492:	8b 45 08             	mov    0x8(%ebp),%eax
80105495:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
8010549c:	8d 50 01             	lea    0x1(%eax),%edx
8010549f:	8b 45 08             	mov    0x8(%ebp),%eax
801054a2:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
    *addr = (char *)PGROUNDDOWN(proc->sz); // guardo la direccion en *addr, de la pagina que se encuentra por debajo de proc->sz
801054a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054af:	8b 00                	mov    (%eax),%eax
801054b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801054b6:	89 c2                	mov    %eax,%edx
801054b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bb:	89 10                	mov    %edx,(%eax)
    proc->shmemquantity++; // aumento la cantidad de espacio de memoria compartida por el proceso
801054bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c3:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
801054c9:	42                   	inc    %edx
801054ca:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
    proc->sz = proc->sz + PGSIZE; // actualizo el tamaño de la memoria del proceso, debido a que ya se realizo el mapeo
801054d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054dd:	8b 12                	mov    (%edx),%edx
801054df:	81 c2 00 10 00 00    	add    $0x1000,%edx
801054e5:	89 10                	mov    %edx,(%eax)
    release(&shmtable.lock);
801054e7:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801054ee:	e8 cf 01 00 00       	call   801056c2 <release>
    return 0; // todo salio bien.
801054f3:	b8 00 00 00 00       	mov    $0x0,%eax
  }   
}
801054f8:	c9                   	leave  
801054f9:	c3                   	ret    

801054fa <get_shm_table>:

//Obtains the array from type sharedmemory
struct sharedmemory* get_shm_table(){
801054fa:	55                   	push   %ebp
801054fb:	89 e5                	mov    %esp,%ebp
  return shmtable.sharedmemory; // como resultado, mi arreglo principal sharedmemory 
801054fd:	b8 60 0f 11 80       	mov    $0x80110f60,%eax
}
80105502:	5d                   	pop    %ebp
80105503:	c3                   	ret    

80105504 <sys_shm_create>:
// esta la termine definiendo en Makefile!!!!!!!! recordar

//Creates a shared memory block.
int
sys_shm_create(void)
{
80105504:	55                   	push   %ebp
80105505:	89 e5                	mov    %esp,%ebp
80105507:	83 ec 28             	sub    $0x28,%esp
  int size;
  if(argint(0, &size) < 0 && (size > 0) )
8010550a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010550d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105518:	e8 c6 06 00 00       	call   80105be3 <argint>
8010551d:	85 c0                	test   %eax,%eax
8010551f:	79 0e                	jns    8010552f <sys_shm_create+0x2b>
80105521:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105524:	85 c0                	test   %eax,%eax
80105526:	7e 07                	jle    8010552f <sys_shm_create+0x2b>
    return -1;
80105528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552d:	eb 0b                	jmp    8010553a <sys_shm_create+0x36>
  int k = shm_create();
8010552f:	e8 bf fc ff ff       	call   801051f3 <shm_create>
80105534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return k;
80105537:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010553a:	c9                   	leave  
8010553b:	c3                   	ret    

8010553c <sys_shm_get>:

//Obtains the address of the memory block associated with key.
int
sys_shm_get(void)
{
8010553c:	55                   	push   %ebp
8010553d:	89 e5                	mov    %esp,%ebp
8010553f:	83 ec 28             	sub    $0x28,%esp
  int k;
  int mem = 0;  
80105542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (proc->shmemquantity >= MAXSHMPROC)
80105549:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010554f:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105555:	83 f8 03             	cmp    $0x3,%eax
80105558:	7e 07                	jle    80105561 <sys_shm_get+0x25>
    return -1;
8010555a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555f:	eb 55                	jmp    801055b6 <sys_shm_get+0x7a>
  if(argint(0, &k) < 0)
80105561:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105564:	89 44 24 04          	mov    %eax,0x4(%esp)
80105568:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010556f:	e8 6f 06 00 00       	call   80105be3 <argint>
80105574:	85 c0                	test   %eax,%eax
80105576:	79 07                	jns    8010557f <sys_shm_get+0x43>
    return -1;
80105578:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557d:	eb 37                	jmp    801055b6 <sys_shm_get+0x7a>
  argint(1,&mem); 
8010557f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105582:	89 44 24 04          	mov    %eax,0x4(%esp)
80105586:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010558d:	e8 51 06 00 00       	call   80105be3 <argint>
  if (!shm_get(k,(char**)mem)){ 
80105592:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105595:	89 c2                	mov    %eax,%edx
80105597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010559e:	89 04 24             	mov    %eax,(%esp)
801055a1:	e8 eb fd ff ff       	call   80105391 <shm_get>
801055a6:	85 c0                	test   %eax,%eax
801055a8:	75 07                	jne    801055b1 <sys_shm_get+0x75>
    return 0;
801055aa:	b8 00 00 00 00       	mov    $0x0,%eax
801055af:	eb 05                	jmp    801055b6 <sys_shm_get+0x7a>
  }
  return -1;
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b6:	c9                   	leave  
801055b7:	c3                   	ret    

801055b8 <sys_shm_close>:

//Frees the memory block previously obtained.
int
sys_shm_close(void)
{
801055b8:	55                   	push   %ebp
801055b9:	89 e5                	mov    %esp,%ebp
801055bb:	83 ec 28             	sub    $0x28,%esp
  int k;
  if(argint(0, &k) < 0)
801055be:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801055c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055cc:	e8 12 06 00 00       	call   80105be3 <argint>
801055d1:	85 c0                	test   %eax,%eax
801055d3:	79 07                	jns    801055dc <sys_shm_close+0x24>
    return -1;
801055d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055da:	eb 1b                	jmp    801055f7 <sys_shm_close+0x3f>
  if (!shm_close(k)){    
801055dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055df:	89 04 24             	mov    %eax,(%esp)
801055e2:	e8 d8 fc ff ff       	call   801052bf <shm_close>
801055e7:	85 c0                	test   %eax,%eax
801055e9:	75 07                	jne    801055f2 <sys_shm_close+0x3a>
    return 0;
801055eb:	b8 00 00 00 00       	mov    $0x0,%eax
801055f0:	eb 05                	jmp    801055f7 <sys_shm_close+0x3f>
  }
  return -1;
801055f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f7:	c9                   	leave  
801055f8:	c3                   	ret    

801055f9 <readeflags>:
{
801055f9:	55                   	push   %ebp
801055fa:	89 e5                	mov    %esp,%ebp
801055fc:	53                   	push   %ebx
801055fd:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105600:	9c                   	pushf  
80105601:	5b                   	pop    %ebx
80105602:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80105605:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	5b                   	pop    %ebx
8010560c:	5d                   	pop    %ebp
8010560d:	c3                   	ret    

8010560e <cli>:
{
8010560e:	55                   	push   %ebp
8010560f:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105611:	fa                   	cli    
}
80105612:	5d                   	pop    %ebp
80105613:	c3                   	ret    

80105614 <sti>:
{
80105614:	55                   	push   %ebp
80105615:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105617:	fb                   	sti    
}
80105618:	5d                   	pop    %ebp
80105619:	c3                   	ret    

8010561a <xchg>:
{
8010561a:	55                   	push   %ebp
8010561b:	89 e5                	mov    %esp,%ebp
8010561d:	53                   	push   %ebx
8010561e:	83 ec 10             	sub    $0x10,%esp
               "+m" (*addr), "=a" (result) :
80105621:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80105624:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80105627:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
8010562a:	89 c3                	mov    %eax,%ebx
8010562c:	89 d8                	mov    %ebx,%eax
8010562e:	f0 87 02             	lock xchg %eax,(%edx)
80105631:	89 c3                	mov    %eax,%ebx
80105633:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return result;
80105636:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105639:	83 c4 10             	add    $0x10,%esp
8010563c:	5b                   	pop    %ebx
8010563d:	5d                   	pop    %ebp
8010563e:	c3                   	ret    

8010563f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010563f:	55                   	push   %ebp
80105640:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105642:	8b 45 08             	mov    0x8(%ebp),%eax
80105645:	8b 55 0c             	mov    0xc(%ebp),%edx
80105648:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010564b:	8b 45 08             	mov    0x8(%ebp),%eax
8010564e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105654:	8b 45 08             	mov    0x8(%ebp),%eax
80105657:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010565e:	5d                   	pop    %ebp
8010565f:	c3                   	ret    

80105660 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105666:	e8 47 01 00 00       	call   801057b2 <pushcli>
  if(holding(lk))
8010566b:	8b 45 08             	mov    0x8(%ebp),%eax
8010566e:	89 04 24             	mov    %eax,(%esp)
80105671:	e8 12 01 00 00       	call   80105788 <holding>
80105676:	85 c0                	test   %eax,%eax
80105678:	74 0c                	je     80105686 <acquire+0x26>
    panic("acquire");
8010567a:	c7 04 24 37 93 10 80 	movl   $0x80109337,(%esp)
80105681:	e8 b0 ae ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105686:	90                   	nop
80105687:	8b 45 08             	mov    0x8(%ebp),%eax
8010568a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105691:	00 
80105692:	89 04 24             	mov    %eax,(%esp)
80105695:	e8 80 ff ff ff       	call   8010561a <xchg>
8010569a:	85 c0                	test   %eax,%eax
8010569c:	75 e9                	jne    80105687 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010569e:	8b 45 08             	mov    0x8(%ebp),%eax
801056a1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801056a8:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801056ab:	8b 45 08             	mov    0x8(%ebp),%eax
801056ae:	83 c0 0c             	add    $0xc,%eax
801056b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b5:	8d 45 08             	lea    0x8(%ebp),%eax
801056b8:	89 04 24             	mov    %eax,(%esp)
801056bb:	e8 51 00 00 00       	call   80105711 <getcallerpcs>
}
801056c0:	c9                   	leave  
801056c1:	c3                   	ret    

801056c2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801056c2:	55                   	push   %ebp
801056c3:	89 e5                	mov    %esp,%ebp
801056c5:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801056c8:	8b 45 08             	mov    0x8(%ebp),%eax
801056cb:	89 04 24             	mov    %eax,(%esp)
801056ce:	e8 b5 00 00 00       	call   80105788 <holding>
801056d3:	85 c0                	test   %eax,%eax
801056d5:	75 0c                	jne    801056e3 <release+0x21>
    panic("release");
801056d7:	c7 04 24 3f 93 10 80 	movl   $0x8010933f,(%esp)
801056de:	e8 53 ae ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
801056e3:	8b 45 08             	mov    0x8(%ebp),%eax
801056e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801056ed:	8b 45 08             	mov    0x8(%ebp),%eax
801056f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801056f7:	8b 45 08             	mov    0x8(%ebp),%eax
801056fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105701:	00 
80105702:	89 04 24             	mov    %eax,(%esp)
80105705:	e8 10 ff ff ff       	call   8010561a <xchg>

  popcli();
8010570a:	e8 e9 00 00 00       	call   801057f8 <popcli>
}
8010570f:	c9                   	leave  
80105710:	c3                   	ret    

80105711 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105711:	55                   	push   %ebp
80105712:	89 e5                	mov    %esp,%ebp
80105714:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105717:	8b 45 08             	mov    0x8(%ebp),%eax
8010571a:	83 e8 08             	sub    $0x8,%eax
8010571d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105720:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105727:	eb 37                	jmp    80105760 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105729:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010572d:	74 51                	je     80105780 <getcallerpcs+0x6f>
8010572f:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105736:	76 48                	jbe    80105780 <getcallerpcs+0x6f>
80105738:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010573c:	74 42                	je     80105780 <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010573e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105741:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105748:	8b 45 0c             	mov    0xc(%ebp),%eax
8010574b:	01 c2                	add    %eax,%edx
8010574d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105750:	8b 40 04             	mov    0x4(%eax),%eax
80105753:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105755:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105758:	8b 00                	mov    (%eax),%eax
8010575a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010575d:	ff 45 f8             	incl   -0x8(%ebp)
80105760:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105764:	7e c3                	jle    80105729 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105766:	eb 18                	jmp    80105780 <getcallerpcs+0x6f>
    pcs[i] = 0;
80105768:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010576b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105772:	8b 45 0c             	mov    0xc(%ebp),%eax
80105775:	01 d0                	add    %edx,%eax
80105777:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010577d:	ff 45 f8             	incl   -0x8(%ebp)
80105780:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105784:	7e e2                	jle    80105768 <getcallerpcs+0x57>
}
80105786:	c9                   	leave  
80105787:	c3                   	ret    

80105788 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105788:	55                   	push   %ebp
80105789:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
8010578b:	8b 45 08             	mov    0x8(%ebp),%eax
8010578e:	8b 00                	mov    (%eax),%eax
80105790:	85 c0                	test   %eax,%eax
80105792:	74 17                	je     801057ab <holding+0x23>
80105794:	8b 45 08             	mov    0x8(%ebp),%eax
80105797:	8b 50 08             	mov    0x8(%eax),%edx
8010579a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057a0:	39 c2                	cmp    %eax,%edx
801057a2:	75 07                	jne    801057ab <holding+0x23>
801057a4:	b8 01 00 00 00       	mov    $0x1,%eax
801057a9:	eb 05                	jmp    801057b0 <holding+0x28>
801057ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057b0:	5d                   	pop    %ebp
801057b1:	c3                   	ret    

801057b2 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801057b2:	55                   	push   %ebp
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801057b8:	e8 3c fe ff ff       	call   801055f9 <readeflags>
801057bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801057c0:	e8 49 fe ff ff       	call   8010560e <cli>
  if(cpu->ncli++ == 0)
801057c5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057cb:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801057d1:	85 d2                	test   %edx,%edx
801057d3:	0f 94 c1             	sete   %cl
801057d6:	42                   	inc    %edx
801057d7:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801057dd:	84 c9                	test   %cl,%cl
801057df:	74 15                	je     801057f6 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
801057e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
801057ea:	81 e2 00 02 00 00    	and    $0x200,%edx
801057f0:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801057f6:	c9                   	leave  
801057f7:	c3                   	ret    

801057f8 <popcli>:

void
popcli(void)
{
801057f8:	55                   	push   %ebp
801057f9:	89 e5                	mov    %esp,%ebp
801057fb:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
801057fe:	e8 f6 fd ff ff       	call   801055f9 <readeflags>
80105803:	25 00 02 00 00       	and    $0x200,%eax
80105808:	85 c0                	test   %eax,%eax
8010580a:	74 0c                	je     80105818 <popcli+0x20>
    panic("popcli - interruptible");
8010580c:	c7 04 24 47 93 10 80 	movl   $0x80109347,(%esp)
80105813:	e8 1e ad ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80105818:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010581e:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105824:	4a                   	dec    %edx
80105825:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010582b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105831:	85 c0                	test   %eax,%eax
80105833:	79 0c                	jns    80105841 <popcli+0x49>
    panic("popcli");
80105835:	c7 04 24 5e 93 10 80 	movl   $0x8010935e,(%esp)
8010583c:	e8 f5 ac ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105841:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105847:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010584d:	85 c0                	test   %eax,%eax
8010584f:	75 15                	jne    80105866 <popcli+0x6e>
80105851:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105857:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010585d:	85 c0                	test   %eax,%eax
8010585f:	74 05                	je     80105866 <popcli+0x6e>
    sti();
80105861:	e8 ae fd ff ff       	call   80105614 <sti>
}
80105866:	c9                   	leave  
80105867:	c3                   	ret    

80105868 <stosb>:
{
80105868:	55                   	push   %ebp
80105869:	89 e5                	mov    %esp,%ebp
8010586b:	57                   	push   %edi
8010586c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010586d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105870:	8b 55 10             	mov    0x10(%ebp),%edx
80105873:	8b 45 0c             	mov    0xc(%ebp),%eax
80105876:	89 cb                	mov    %ecx,%ebx
80105878:	89 df                	mov    %ebx,%edi
8010587a:	89 d1                	mov    %edx,%ecx
8010587c:	fc                   	cld    
8010587d:	f3 aa                	rep stos %al,%es:(%edi)
8010587f:	89 ca                	mov    %ecx,%edx
80105881:	89 fb                	mov    %edi,%ebx
80105883:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105886:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105889:	5b                   	pop    %ebx
8010588a:	5f                   	pop    %edi
8010588b:	5d                   	pop    %ebp
8010588c:	c3                   	ret    

8010588d <stosl>:
{
8010588d:	55                   	push   %ebp
8010588e:	89 e5                	mov    %esp,%ebp
80105890:	57                   	push   %edi
80105891:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105892:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105895:	8b 55 10             	mov    0x10(%ebp),%edx
80105898:	8b 45 0c             	mov    0xc(%ebp),%eax
8010589b:	89 cb                	mov    %ecx,%ebx
8010589d:	89 df                	mov    %ebx,%edi
8010589f:	89 d1                	mov    %edx,%ecx
801058a1:	fc                   	cld    
801058a2:	f3 ab                	rep stos %eax,%es:(%edi)
801058a4:	89 ca                	mov    %ecx,%edx
801058a6:	89 fb                	mov    %edi,%ebx
801058a8:	89 5d 08             	mov    %ebx,0x8(%ebp)
801058ab:	89 55 10             	mov    %edx,0x10(%ebp)
}
801058ae:	5b                   	pop    %ebx
801058af:	5f                   	pop    %edi
801058b0:	5d                   	pop    %ebp
801058b1:	c3                   	ret    

801058b2 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801058b2:	55                   	push   %ebp
801058b3:	89 e5                	mov    %esp,%ebp
801058b5:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801058b8:	8b 45 08             	mov    0x8(%ebp),%eax
801058bb:	83 e0 03             	and    $0x3,%eax
801058be:	85 c0                	test   %eax,%eax
801058c0:	75 49                	jne    8010590b <memset+0x59>
801058c2:	8b 45 10             	mov    0x10(%ebp),%eax
801058c5:	83 e0 03             	and    $0x3,%eax
801058c8:	85 c0                	test   %eax,%eax
801058ca:	75 3f                	jne    8010590b <memset+0x59>
    c &= 0xFF;
801058cc:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801058d3:	8b 45 10             	mov    0x10(%ebp),%eax
801058d6:	c1 e8 02             	shr    $0x2,%eax
801058d9:	89 c2                	mov    %eax,%edx
801058db:	8b 45 0c             	mov    0xc(%ebp),%eax
801058de:	89 c1                	mov    %eax,%ecx
801058e0:	c1 e1 18             	shl    $0x18,%ecx
801058e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e6:	c1 e0 10             	shl    $0x10,%eax
801058e9:	09 c1                	or     %eax,%ecx
801058eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ee:	c1 e0 08             	shl    $0x8,%eax
801058f1:	09 c8                	or     %ecx,%eax
801058f3:	0b 45 0c             	or     0xc(%ebp),%eax
801058f6:	89 54 24 08          	mov    %edx,0x8(%esp)
801058fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801058fe:	8b 45 08             	mov    0x8(%ebp),%eax
80105901:	89 04 24             	mov    %eax,(%esp)
80105904:	e8 84 ff ff ff       	call   8010588d <stosl>
80105909:	eb 19                	jmp    80105924 <memset+0x72>
  } else
    stosb(dst, c, n);
8010590b:	8b 45 10             	mov    0x10(%ebp),%eax
8010590e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105912:	8b 45 0c             	mov    0xc(%ebp),%eax
80105915:	89 44 24 04          	mov    %eax,0x4(%esp)
80105919:	8b 45 08             	mov    0x8(%ebp),%eax
8010591c:	89 04 24             	mov    %eax,(%esp)
8010591f:	e8 44 ff ff ff       	call   80105868 <stosb>
  return dst;
80105924:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105927:	c9                   	leave  
80105928:	c3                   	ret    

80105929 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105929:	55                   	push   %ebp
8010592a:	89 e5                	mov    %esp,%ebp
8010592c:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010592f:	8b 45 08             	mov    0x8(%ebp),%eax
80105932:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105935:	8b 45 0c             	mov    0xc(%ebp),%eax
80105938:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010593b:	eb 2c                	jmp    80105969 <memcmp+0x40>
    if(*s1 != *s2)
8010593d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105940:	8a 10                	mov    (%eax),%dl
80105942:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105945:	8a 00                	mov    (%eax),%al
80105947:	38 c2                	cmp    %al,%dl
80105949:	74 18                	je     80105963 <memcmp+0x3a>
      return *s1 - *s2;
8010594b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010594e:	8a 00                	mov    (%eax),%al
80105950:	0f b6 d0             	movzbl %al,%edx
80105953:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105956:	8a 00                	mov    (%eax),%al
80105958:	0f b6 c0             	movzbl %al,%eax
8010595b:	89 d1                	mov    %edx,%ecx
8010595d:	29 c1                	sub    %eax,%ecx
8010595f:	89 c8                	mov    %ecx,%eax
80105961:	eb 19                	jmp    8010597c <memcmp+0x53>
    s1++, s2++;
80105963:	ff 45 fc             	incl   -0x4(%ebp)
80105966:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0){
80105969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010596d:	0f 95 c0             	setne  %al
80105970:	ff 4d 10             	decl   0x10(%ebp)
80105973:	84 c0                	test   %al,%al
80105975:	75 c6                	jne    8010593d <memcmp+0x14>
  }

  return 0;
80105977:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010597c:	c9                   	leave  
8010597d:	c3                   	ret    

8010597e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010597e:	55                   	push   %ebp
8010597f:	89 e5                	mov    %esp,%ebp
80105981:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105984:	8b 45 0c             	mov    0xc(%ebp),%eax
80105987:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010598a:	8b 45 08             	mov    0x8(%ebp),%eax
8010598d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105990:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105993:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105996:	73 4d                	jae    801059e5 <memmove+0x67>
80105998:	8b 45 10             	mov    0x10(%ebp),%eax
8010599b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010599e:	01 d0                	add    %edx,%eax
801059a0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801059a3:	76 40                	jbe    801059e5 <memmove+0x67>
    s += n;
801059a5:	8b 45 10             	mov    0x10(%ebp),%eax
801059a8:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801059ab:	8b 45 10             	mov    0x10(%ebp),%eax
801059ae:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801059b1:	eb 10                	jmp    801059c3 <memmove+0x45>
      *--d = *--s;
801059b3:	ff 4d f8             	decl   -0x8(%ebp)
801059b6:	ff 4d fc             	decl   -0x4(%ebp)
801059b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059bc:	8a 10                	mov    (%eax),%dl
801059be:	8b 45 f8             	mov    -0x8(%ebp),%eax
801059c1:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801059c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059c7:	0f 95 c0             	setne  %al
801059ca:	ff 4d 10             	decl   0x10(%ebp)
801059cd:	84 c0                	test   %al,%al
801059cf:	75 e2                	jne    801059b3 <memmove+0x35>
  if(s < d && s + n > d){
801059d1:	eb 21                	jmp    801059f4 <memmove+0x76>
  } else
    while(n-- > 0)
      *d++ = *s++;
801059d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801059d6:	8a 10                	mov    (%eax),%dl
801059d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801059db:	88 10                	mov    %dl,(%eax)
801059dd:	ff 45 f8             	incl   -0x8(%ebp)
801059e0:	ff 45 fc             	incl   -0x4(%ebp)
801059e3:	eb 01                	jmp    801059e6 <memmove+0x68>
    while(n-- > 0)
801059e5:	90                   	nop
801059e6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059ea:	0f 95 c0             	setne  %al
801059ed:	ff 4d 10             	decl   0x10(%ebp)
801059f0:	84 c0                	test   %al,%al
801059f2:	75 df                	jne    801059d3 <memmove+0x55>

  return dst;
801059f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801059f7:	c9                   	leave  
801059f8:	c3                   	ret    

801059f9 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801059f9:	55                   	push   %ebp
801059fa:	89 e5                	mov    %esp,%ebp
801059fc:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801059ff:	8b 45 10             	mov    0x10(%ebp),%eax
80105a02:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a06:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a09:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a10:	89 04 24             	mov    %eax,(%esp)
80105a13:	e8 66 ff ff ff       	call   8010597e <memmove>
}
80105a18:	c9                   	leave  
80105a19:	c3                   	ret    

80105a1a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105a1a:	55                   	push   %ebp
80105a1b:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105a1d:	eb 09                	jmp    80105a28 <strncmp+0xe>
    n--, p++, q++;
80105a1f:	ff 4d 10             	decl   0x10(%ebp)
80105a22:	ff 45 08             	incl   0x8(%ebp)
80105a25:	ff 45 0c             	incl   0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105a28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a2c:	74 17                	je     80105a45 <strncmp+0x2b>
80105a2e:	8b 45 08             	mov    0x8(%ebp),%eax
80105a31:	8a 00                	mov    (%eax),%al
80105a33:	84 c0                	test   %al,%al
80105a35:	74 0e                	je     80105a45 <strncmp+0x2b>
80105a37:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3a:	8a 10                	mov    (%eax),%dl
80105a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a3f:	8a 00                	mov    (%eax),%al
80105a41:	38 c2                	cmp    %al,%dl
80105a43:	74 da                	je     80105a1f <strncmp+0x5>
  if(n == 0)
80105a45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a49:	75 07                	jne    80105a52 <strncmp+0x38>
    return 0;
80105a4b:	b8 00 00 00 00       	mov    $0x0,%eax
80105a50:	eb 16                	jmp    80105a68 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80105a52:	8b 45 08             	mov    0x8(%ebp),%eax
80105a55:	8a 00                	mov    (%eax),%al
80105a57:	0f b6 d0             	movzbl %al,%edx
80105a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a5d:	8a 00                	mov    (%eax),%al
80105a5f:	0f b6 c0             	movzbl %al,%eax
80105a62:	89 d1                	mov    %edx,%ecx
80105a64:	29 c1                	sub    %eax,%ecx
80105a66:	89 c8                	mov    %ecx,%eax
}
80105a68:	5d                   	pop    %ebp
80105a69:	c3                   	ret    

80105a6a <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105a6a:	55                   	push   %ebp
80105a6b:	89 e5                	mov    %esp,%ebp
80105a6d:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a70:	8b 45 08             	mov    0x8(%ebp),%eax
80105a73:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105a76:	90                   	nop
80105a77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a7b:	0f 9f c0             	setg   %al
80105a7e:	ff 4d 10             	decl   0x10(%ebp)
80105a81:	84 c0                	test   %al,%al
80105a83:	74 2b                	je     80105ab0 <strncpy+0x46>
80105a85:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a88:	8a 10                	mov    (%eax),%dl
80105a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8d:	88 10                	mov    %dl,(%eax)
80105a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a92:	8a 00                	mov    (%eax),%al
80105a94:	84 c0                	test   %al,%al
80105a96:	0f 95 c0             	setne  %al
80105a99:	ff 45 08             	incl   0x8(%ebp)
80105a9c:	ff 45 0c             	incl   0xc(%ebp)
80105a9f:	84 c0                	test   %al,%al
80105aa1:	75 d4                	jne    80105a77 <strncpy+0xd>
    ;
  while(n-- > 0)
80105aa3:	eb 0b                	jmp    80105ab0 <strncpy+0x46>
    *s++ = 0;
80105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa8:	c6 00 00             	movb   $0x0,(%eax)
80105aab:	ff 45 08             	incl   0x8(%ebp)
80105aae:	eb 01                	jmp    80105ab1 <strncpy+0x47>
  while(n-- > 0)
80105ab0:	90                   	nop
80105ab1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ab5:	0f 9f c0             	setg   %al
80105ab8:	ff 4d 10             	decl   0x10(%ebp)
80105abb:	84 c0                	test   %al,%al
80105abd:	75 e6                	jne    80105aa5 <strncpy+0x3b>
  return os;
80105abf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ac2:	c9                   	leave  
80105ac3:	c3                   	ret    

80105ac4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105aca:	8b 45 08             	mov    0x8(%ebp),%eax
80105acd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ad4:	7f 05                	jg     80105adb <safestrcpy+0x17>
    return os;
80105ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105ad9:	eb 30                	jmp    80105b0b <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80105adb:	ff 4d 10             	decl   0x10(%ebp)
80105ade:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ae2:	7e 1e                	jle    80105b02 <safestrcpy+0x3e>
80105ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ae7:	8a 10                	mov    (%eax),%dl
80105ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80105aec:	88 10                	mov    %dl,(%eax)
80105aee:	8b 45 08             	mov    0x8(%ebp),%eax
80105af1:	8a 00                	mov    (%eax),%al
80105af3:	84 c0                	test   %al,%al
80105af5:	0f 95 c0             	setne  %al
80105af8:	ff 45 08             	incl   0x8(%ebp)
80105afb:	ff 45 0c             	incl   0xc(%ebp)
80105afe:	84 c0                	test   %al,%al
80105b00:	75 d9                	jne    80105adb <safestrcpy+0x17>
    ;
  *s = 0;
80105b02:	8b 45 08             	mov    0x8(%ebp),%eax
80105b05:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105b0b:	c9                   	leave  
80105b0c:	c3                   	ret    

80105b0d <strlen>:

int
strlen(const char *s)
{
80105b0d:	55                   	push   %ebp
80105b0e:	89 e5                	mov    %esp,%ebp
80105b10:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105b13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105b1a:	eb 03                	jmp    80105b1f <strlen+0x12>
80105b1c:	ff 45 fc             	incl   -0x4(%ebp)
80105b1f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b22:	8b 45 08             	mov    0x8(%ebp),%eax
80105b25:	01 d0                	add    %edx,%eax
80105b27:	8a 00                	mov    (%eax),%al
80105b29:	84 c0                	test   %al,%al
80105b2b:	75 ef                	jne    80105b1c <strlen+0xf>
    ;
  return n;
80105b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105b30:	c9                   	leave  
80105b31:	c3                   	ret    

80105b32 <swtch>:
80105b32:	8b 44 24 04          	mov    0x4(%esp),%eax
80105b36:	8b 54 24 08          	mov    0x8(%esp),%edx
80105b3a:	55                   	push   %ebp
80105b3b:	53                   	push   %ebx
80105b3c:	56                   	push   %esi
80105b3d:	57                   	push   %edi
80105b3e:	89 20                	mov    %esp,(%eax)
80105b40:	89 d4                	mov    %edx,%esp
80105b42:	5f                   	pop    %edi
80105b43:	5e                   	pop    %esi
80105b44:	5b                   	pop    %ebx
80105b45:	5d                   	pop    %ebp
80105b46:	c3                   	ret    

80105b47 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105b47:	55                   	push   %ebp
80105b48:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105b4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b50:	8b 00                	mov    (%eax),%eax
80105b52:	3b 45 08             	cmp    0x8(%ebp),%eax
80105b55:	76 12                	jbe    80105b69 <fetchint+0x22>
80105b57:	8b 45 08             	mov    0x8(%ebp),%eax
80105b5a:	8d 50 04             	lea    0x4(%eax),%edx
80105b5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b63:	8b 00                	mov    (%eax),%eax
80105b65:	39 c2                	cmp    %eax,%edx
80105b67:	76 07                	jbe    80105b70 <fetchint+0x29>
    return -1;
80105b69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6e:	eb 0f                	jmp    80105b7f <fetchint+0x38>
  *ip = *(int*)(addr);
80105b70:	8b 45 08             	mov    0x8(%ebp),%eax
80105b73:	8b 10                	mov    (%eax),%edx
80105b75:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b78:	89 10                	mov    %edx,(%eax)
  return 0;
80105b7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b7f:	5d                   	pop    %ebp
80105b80:	c3                   	ret    

80105b81 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105b81:	55                   	push   %ebp
80105b82:	89 e5                	mov    %esp,%ebp
80105b84:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105b87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b8d:	8b 00                	mov    (%eax),%eax
80105b8f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105b92:	77 07                	ja     80105b9b <fetchstr+0x1a>
    return -1;
80105b94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b99:	eb 46                	jmp    80105be1 <fetchstr+0x60>
  *pp = (char*)addr;
80105b9b:	8b 55 08             	mov    0x8(%ebp),%edx
80105b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ba1:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105ba3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ba9:	8b 00                	mov    (%eax),%eax
80105bab:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105bae:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bb1:	8b 00                	mov    (%eax),%eax
80105bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105bb6:	eb 1c                	jmp    80105bd4 <fetchstr+0x53>
    if(*s == 0)
80105bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bbb:	8a 00                	mov    (%eax),%al
80105bbd:	84 c0                	test   %al,%al
80105bbf:	75 10                	jne    80105bd1 <fetchstr+0x50>
      return s - *pp;
80105bc1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bc7:	8b 00                	mov    (%eax),%eax
80105bc9:	89 d1                	mov    %edx,%ecx
80105bcb:	29 c1                	sub    %eax,%ecx
80105bcd:	89 c8                	mov    %ecx,%eax
80105bcf:	eb 10                	jmp    80105be1 <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
80105bd1:	ff 45 fc             	incl   -0x4(%ebp)
80105bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bd7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105bda:	72 dc                	jb     80105bb8 <fetchstr+0x37>
  return -1;
80105bdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105be1:	c9                   	leave  
80105be2:	c3                   	ret    

80105be3 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105be3:	55                   	push   %ebp
80105be4:	89 e5                	mov    %esp,%ebp
80105be6:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105be9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bef:	8b 40 18             	mov    0x18(%eax),%eax
80105bf2:	8b 50 44             	mov    0x44(%eax),%edx
80105bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf8:	c1 e0 02             	shl    $0x2,%eax
80105bfb:	01 d0                	add    %edx,%eax
80105bfd:	8d 50 04             	lea    0x4(%eax),%edx
80105c00:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c03:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c07:	89 14 24             	mov    %edx,(%esp)
80105c0a:	e8 38 ff ff ff       	call   80105b47 <fetchint>
}
80105c0f:	c9                   	leave  
80105c10:	c3                   	ret    

80105c11 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105c11:	55                   	push   %ebp
80105c12:	89 e5                	mov    %esp,%ebp
80105c14:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105c17:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
80105c21:	89 04 24             	mov    %eax,(%esp)
80105c24:	e8 ba ff ff ff       	call   80105be3 <argint>
80105c29:	85 c0                	test   %eax,%eax
80105c2b:	79 07                	jns    80105c34 <argptr+0x23>
    return -1;
80105c2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c32:	eb 3d                	jmp    80105c71 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105c34:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c37:	89 c2                	mov    %eax,%edx
80105c39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c3f:	8b 00                	mov    (%eax),%eax
80105c41:	39 c2                	cmp    %eax,%edx
80105c43:	73 16                	jae    80105c5b <argptr+0x4a>
80105c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c48:	89 c2                	mov    %eax,%edx
80105c4a:	8b 45 10             	mov    0x10(%ebp),%eax
80105c4d:	01 c2                	add    %eax,%edx
80105c4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c55:	8b 00                	mov    (%eax),%eax
80105c57:	39 c2                	cmp    %eax,%edx
80105c59:	76 07                	jbe    80105c62 <argptr+0x51>
    return -1;
80105c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c60:	eb 0f                	jmp    80105c71 <argptr+0x60>
  *pp = (char*)i;
80105c62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c65:	89 c2                	mov    %eax,%edx
80105c67:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c6a:	89 10                	mov    %edx,(%eax)
  return 0;
80105c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c71:	c9                   	leave  
80105c72:	c3                   	ret    

80105c73 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105c73:	55                   	push   %ebp
80105c74:	89 e5                	mov    %esp,%ebp
80105c76:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105c79:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c80:	8b 45 08             	mov    0x8(%ebp),%eax
80105c83:	89 04 24             	mov    %eax,(%esp)
80105c86:	e8 58 ff ff ff       	call   80105be3 <argint>
80105c8b:	85 c0                	test   %eax,%eax
80105c8d:	79 07                	jns    80105c96 <argstr+0x23>
    return -1;
80105c8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c94:	eb 12                	jmp    80105ca8 <argstr+0x35>
  return fetchstr(addr, pp);
80105c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c99:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c9c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ca0:	89 04 24             	mov    %eax,(%esp)
80105ca3:	e8 d9 fe ff ff       	call   80105b81 <fetchstr>
}
80105ca8:	c9                   	leave  
80105ca9:	c3                   	ret    

80105caa <syscall>:
[SYS_shm_get] sys_shm_get, // New: Add in project final
};

void
syscall(void)
{
80105caa:	55                   	push   %ebp
80105cab:	89 e5                	mov    %esp,%ebp
80105cad:	53                   	push   %ebx
80105cae:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105cb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cb7:	8b 40 18             	mov    0x18(%eax),%eax
80105cba:	8b 40 1c             	mov    0x1c(%eax),%eax
80105cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105cc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cc4:	7e 30                	jle    80105cf6 <syscall+0x4c>
80105cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc9:	83 f8 20             	cmp    $0x20,%eax
80105ccc:	77 28                	ja     80105cf6 <syscall+0x4c>
80105cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd1:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105cd8:	85 c0                	test   %eax,%eax
80105cda:	74 1a                	je     80105cf6 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105cdc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ce2:	8b 58 18             	mov    0x18(%eax),%ebx
80105ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce8:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105cef:	ff d0                	call   *%eax
80105cf1:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105cf4:	eb 3d                	jmp    80105d33 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cfc:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105cff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105d05:	8b 40 10             	mov    0x10(%eax),%eax
80105d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d0b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105d0f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d13:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d17:	c7 04 24 65 93 10 80 	movl   $0x80109365,(%esp)
80105d1e:	e8 7e a6 ff ff       	call   801003a1 <cprintf>
    proc->tf->eax = -1;
80105d23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d29:	8b 40 18             	mov    0x18(%eax),%eax
80105d2c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105d33:	83 c4 24             	add    $0x24,%esp
80105d36:	5b                   	pop    %ebx
80105d37:	5d                   	pop    %ebp
80105d38:	c3                   	ret    

80105d39 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105d39:	55                   	push   %ebp
80105d3a:	89 e5                	mov    %esp,%ebp
80105d3c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105d3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d42:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d46:	8b 45 08             	mov    0x8(%ebp),%eax
80105d49:	89 04 24             	mov    %eax,(%esp)
80105d4c:	e8 92 fe ff ff       	call   80105be3 <argint>
80105d51:	85 c0                	test   %eax,%eax
80105d53:	79 07                	jns    80105d5c <argfd+0x23>
    return -1;
80105d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d5a:	eb 50                	jmp    80105dac <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5f:	85 c0                	test   %eax,%eax
80105d61:	78 21                	js     80105d84 <argfd+0x4b>
80105d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d66:	83 f8 0f             	cmp    $0xf,%eax
80105d69:	7f 19                	jg     80105d84 <argfd+0x4b>
80105d6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d71:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d74:	83 c2 08             	add    $0x8,%edx
80105d77:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d82:	75 07                	jne    80105d8b <argfd+0x52>
    return -1;
80105d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d89:	eb 21                	jmp    80105dac <argfd+0x73>
  if(pfd)
80105d8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d8f:	74 08                	je     80105d99 <argfd+0x60>
    *pfd = fd;
80105d91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d94:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d97:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d9d:	74 08                	je     80105da7 <argfd+0x6e>
    *pf = f;
80105d9f:	8b 45 10             	mov    0x10(%ebp),%eax
80105da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105da5:	89 10                	mov    %edx,(%eax)
  return 0;
80105da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dac:	c9                   	leave  
80105dad:	c3                   	ret    

80105dae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105dae:	55                   	push   %ebp
80105daf:	89 e5                	mov    %esp,%ebp
80105db1:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105db4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105dbb:	eb 2f                	jmp    80105dec <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105dbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105dc6:	83 c2 08             	add    $0x8,%edx
80105dc9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105dcd:	85 c0                	test   %eax,%eax
80105dcf:	75 18                	jne    80105de9 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105dd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105dd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105dda:	8d 4a 08             	lea    0x8(%edx),%ecx
80105ddd:	8b 55 08             	mov    0x8(%ebp),%edx
80105de0:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105de4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105de7:	eb 0e                	jmp    80105df7 <fdalloc+0x49>
  for(fd = 0; fd < NOFILE; fd++){
80105de9:	ff 45 fc             	incl   -0x4(%ebp)
80105dec:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105df0:	7e cb                	jle    80105dbd <fdalloc+0xf>
    }
  }
  return -1;
80105df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    

80105df9 <sys_dup>:

int
sys_dup(void)
{
80105df9:	55                   	push   %ebp
80105dfa:	89 e5                	mov    %esp,%ebp
80105dfc:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105dff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e02:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e06:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e0d:	00 
80105e0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e15:	e8 1f ff ff ff       	call   80105d39 <argfd>
80105e1a:	85 c0                	test   %eax,%eax
80105e1c:	79 07                	jns    80105e25 <sys_dup+0x2c>
    return -1;
80105e1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e23:	eb 29                	jmp    80105e4e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e28:	89 04 24             	mov    %eax,(%esp)
80105e2b:	e8 7e ff ff ff       	call   80105dae <fdalloc>
80105e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e37:	79 07                	jns    80105e40 <sys_dup+0x47>
    return -1;
80105e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e3e:	eb 0e                	jmp    80105e4e <sys_dup+0x55>
  filedup(f);
80105e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e43:	89 04 24             	mov    %eax,(%esp)
80105e46:	e8 08 b1 ff ff       	call   80100f53 <filedup>
  return fd;
80105e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e4e:	c9                   	leave  
80105e4f:	c3                   	ret    

80105e50 <sys_read>:

int
sys_read(void)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e59:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e64:	00 
80105e65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e6c:	e8 c8 fe ff ff       	call   80105d39 <argfd>
80105e71:	85 c0                	test   %eax,%eax
80105e73:	78 35                	js     80105eaa <sys_read+0x5a>
80105e75:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e78:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e7c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e83:	e8 5b fd ff ff       	call   80105be3 <argint>
80105e88:	85 c0                	test   %eax,%eax
80105e8a:	78 1e                	js     80105eaa <sys_read+0x5a>
80105e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e8f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e93:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e96:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ea1:	e8 6b fd ff ff       	call   80105c11 <argptr>
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	79 07                	jns    80105eb1 <sys_read+0x61>
    return -1;
80105eaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eaf:	eb 19                	jmp    80105eca <sys_read+0x7a>
  return fileread(f, p, n);
80105eb1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105eb4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105ebe:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ec2:	89 04 24             	mov    %eax,(%esp)
80105ec5:	e8 ea b1 ff ff       	call   801010b4 <fileread>
}
80105eca:	c9                   	leave  
80105ecb:	c3                   	ret    

80105ecc <sys_write>:

int
sys_write(void)
{
80105ecc:	55                   	push   %ebp
80105ecd:	89 e5                	mov    %esp,%ebp
80105ecf:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105ed2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ee0:	00 
80105ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ee8:	e8 4c fe ff ff       	call   80105d39 <argfd>
80105eed:	85 c0                	test   %eax,%eax
80105eef:	78 35                	js     80105f26 <sys_write+0x5a>
80105ef1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105eff:	e8 df fc ff ff       	call   80105be3 <argint>
80105f04:	85 c0                	test   %eax,%eax
80105f06:	78 1e                	js     80105f26 <sys_write+0x5a>
80105f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f12:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f1d:	e8 ef fc ff ff       	call   80105c11 <argptr>
80105f22:	85 c0                	test   %eax,%eax
80105f24:	79 07                	jns    80105f2d <sys_write+0x61>
    return -1;
80105f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f2b:	eb 19                	jmp    80105f46 <sys_write+0x7a>
  return filewrite(f, p, n);
80105f2d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105f30:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105f3a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f3e:	89 04 24             	mov    %eax,(%esp)
80105f41:	e8 29 b2 ff ff       	call   8010116f <filewrite>
}
80105f46:	c9                   	leave  
80105f47:	c3                   	ret    

80105f48 <sys_isatty>:

// Minimalish implementation of isatty for xv6. Maybe it will even work, but 
// hopefully it will be sufficient for now.
int sys_isatty(void) {
80105f48:	55                   	push   %ebp
80105f49:	89 e5                	mov    %esp,%ebp
80105f4b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  argfd(0, &fd, &f);
80105f4e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f51:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f58:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f63:	e8 d1 fd ff ff       	call   80105d39 <argfd>
  if (f->type == FD_INODE) {
80105f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6b:	8b 00                	mov    (%eax),%eax
80105f6d:	83 f8 02             	cmp    $0x2,%eax
80105f70:	75 20                	jne    80105f92 <sys_isatty+0x4a>
    /* This is bad and wrong, but currently works. Either when more 
     * sophisticated terminal handling comes, or more devices, or both, this
     * will need to distinguish different device types. Still, it's a start. */
    if (f->ip != 0 && f->ip->type == T_DEV)
80105f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f75:	8b 40 10             	mov    0x10(%eax),%eax
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	74 16                	je     80105f92 <sys_isatty+0x4a>
80105f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7f:	8b 40 10             	mov    0x10(%eax),%eax
80105f82:	8b 40 10             	mov    0x10(%eax),%eax
80105f85:	66 83 f8 03          	cmp    $0x3,%ax
80105f89:	75 07                	jne    80105f92 <sys_isatty+0x4a>
      return 1;
80105f8b:	b8 01 00 00 00       	mov    $0x1,%eax
80105f90:	eb 05                	jmp    80105f97 <sys_isatty+0x4f>
  }
  return 0;
80105f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f97:	c9                   	leave  
80105f98:	c3                   	ret    

80105f99 <sys_lseek>:

// lseek derived from https://github.com/hxp/xv6, written by Joel Heikkila

int sys_lseek(void) {
80105f99:	55                   	push   %ebp
80105f9a:	89 e5                	mov    %esp,%ebp
80105f9c:	83 ec 48             	sub    $0x48,%esp
	int zerosize, i;
	char *zeroed, *z;

	struct file *f;

	argfd(0, &fd, &f);
80105f9f:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105fa2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fa6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fb4:	e8 80 fd ff ff       	call   80105d39 <argfd>
	argint(1, &offset);
80105fb9:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105fbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fc0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fc7:	e8 17 fc ff ff       	call   80105be3 <argint>
	argint(2, &base);
80105fcc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fd3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105fda:	e8 04 fc ff ff       	call   80105be3 <argint>

	if( base == SEEK_SET) {
80105fdf:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fe2:	85 c0                	test   %eax,%eax
80105fe4:	75 06                	jne    80105fec <sys_lseek+0x53>
		newoff = offset;
80105fe6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	if (base == SEEK_CUR)
80105fec:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105fef:	83 f8 01             	cmp    $0x1,%eax
80105ff2:	75 0e                	jne    80106002 <sys_lseek+0x69>
		newoff = f->off + offset;
80105ff4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105ff7:	8b 50 14             	mov    0x14(%eax),%edx
80105ffa:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ffd:	01 d0                	add    %edx,%eax
80105fff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (base == SEEK_END)
80106002:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106005:	83 f8 02             	cmp    $0x2,%eax
80106008:	75 11                	jne    8010601b <sys_lseek+0x82>
		newoff = f->ip->size + offset;
8010600a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010600d:	8b 40 10             	mov    0x10(%eax),%eax
80106010:	8b 50 18             	mov    0x18(%eax),%edx
80106013:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106016:	01 d0                	add    %edx,%eax
80106018:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (newoff < f->ip->size)
8010601b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010601e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106021:	8b 40 10             	mov    0x10(%eax),%eax
80106024:	8b 40 18             	mov    0x18(%eax),%eax
80106027:	39 c2                	cmp    %eax,%edx
80106029:	73 0a                	jae    80106035 <sys_lseek+0x9c>
		return -1;
8010602b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106030:	e9 92 00 00 00       	jmp    801060c7 <sys_lseek+0x12e>

	if (newoff > f->ip->size){
80106035:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106038:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010603b:	8b 40 10             	mov    0x10(%eax),%eax
8010603e:	8b 40 18             	mov    0x18(%eax),%eax
80106041:	39 c2                	cmp    %eax,%edx
80106043:	76 74                	jbe    801060b9 <sys_lseek+0x120>
		zerosize = newoff - f->ip->size;
80106045:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106048:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010604b:	8b 40 10             	mov    0x10(%eax),%eax
8010604e:	8b 40 18             	mov    0x18(%eax),%eax
80106051:	89 d1                	mov    %edx,%ecx
80106053:	29 c1                	sub    %eax,%ecx
80106055:	89 c8                	mov    %ecx,%eax
80106057:	89 45 f0             	mov    %eax,-0x10(%ebp)
		zeroed = kalloc();
8010605a:	e8 5f ca ff ff       	call   80102abe <kalloc>
8010605f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = zeroed;
80106062:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106065:	89 45 e8             	mov    %eax,-0x18(%ebp)
		for (i = 0; i < 4096; i++)
80106068:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010606f:	eb 0c                	jmp    8010607d <sys_lseek+0xe4>
			*z++ = 0;
80106071:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106074:	c6 00 00             	movb   $0x0,(%eax)
80106077:	ff 45 e8             	incl   -0x18(%ebp)
		for (i = 0; i < 4096; i++)
8010607a:	ff 45 ec             	incl   -0x14(%ebp)
8010607d:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80106084:	7e eb                	jle    80106071 <sys_lseek+0xd8>
		while (zerosize > 0){
80106086:	eb 20                	jmp    801060a8 <sys_lseek+0x10f>
			filewrite(f, zeroed, zerosize);
80106088:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010608b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010608e:	89 54 24 08          	mov    %edx,0x8(%esp)
80106092:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106095:	89 54 24 04          	mov    %edx,0x4(%esp)
80106099:	89 04 24             	mov    %eax,(%esp)
8010609c:	e8 ce b0 ff ff       	call   8010116f <filewrite>
			zerosize -= 4096;
801060a1:	81 6d f0 00 10 00 00 	subl   $0x1000,-0x10(%ebp)
		while (zerosize > 0){
801060a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060ac:	7f da                	jg     80106088 <sys_lseek+0xef>
		}
		kfree(zeroed);
801060ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060b1:	89 04 24             	mov    %eax,(%esp)
801060b4:	e8 6c c9 ff ff       	call   80102a25 <kfree>
	}

	f->off = newoff;
801060b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801060bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060bf:	89 50 14             	mov    %edx,0x14(%eax)
	return 0;
801060c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060c7:	c9                   	leave  
801060c8:	c3                   	ret    

801060c9 <sys_close>:

int
sys_close(void)
{
801060c9:	55                   	push   %ebp
801060ca:	89 e5                	mov    %esp,%ebp
801060cc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801060cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060d2:	89 44 24 08          	mov    %eax,0x8(%esp)
801060d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801060dd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060e4:	e8 50 fc ff ff       	call   80105d39 <argfd>
801060e9:	85 c0                	test   %eax,%eax
801060eb:	79 07                	jns    801060f4 <sys_close+0x2b>
    return -1;
801060ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060f2:	eb 24                	jmp    80106118 <sys_close+0x4f>
  proc->ofile[fd] = 0;
801060f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060fd:	83 c2 08             	add    $0x8,%edx
80106100:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106107:	00 
  fileclose(f);
80106108:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010610b:	89 04 24             	mov    %eax,(%esp)
8010610e:	e8 88 ae ff ff       	call   80100f9b <fileclose>
  return 0;
80106113:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106118:	c9                   	leave  
80106119:	c3                   	ret    

8010611a <sys_fstat>:

int
sys_fstat(void)
{
8010611a:	55                   	push   %ebp
8010611b:	89 e5                	mov    %esp,%ebp
8010611d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106120:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106123:	89 44 24 08          	mov    %eax,0x8(%esp)
80106127:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010612e:	00 
8010612f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106136:	e8 fe fb ff ff       	call   80105d39 <argfd>
8010613b:	85 c0                	test   %eax,%eax
8010613d:	78 1f                	js     8010615e <sys_fstat+0x44>
8010613f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106146:	00 
80106147:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010614a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010614e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106155:	e8 b7 fa ff ff       	call   80105c11 <argptr>
8010615a:	85 c0                	test   %eax,%eax
8010615c:	79 07                	jns    80106165 <sys_fstat+0x4b>
    return -1;
8010615e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106163:	eb 12                	jmp    80106177 <sys_fstat+0x5d>
  return filestat(f, st);
80106165:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106168:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010616f:	89 04 24             	mov    %eax,(%esp)
80106172:	e8 ee ae ff ff       	call   80101065 <filestat>
}
80106177:	c9                   	leave  
80106178:	c3                   	ret    

80106179 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106179:	55                   	push   %ebp
8010617a:	89 e5                	mov    %esp,%ebp
8010617c:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010617f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106182:	89 44 24 04          	mov    %eax,0x4(%esp)
80106186:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010618d:	e8 e1 fa ff ff       	call   80105c73 <argstr>
80106192:	85 c0                	test   %eax,%eax
80106194:	78 17                	js     801061ad <sys_link+0x34>
80106196:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106199:	89 44 24 04          	mov    %eax,0x4(%esp)
8010619d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061a4:	e8 ca fa ff ff       	call   80105c73 <argstr>
801061a9:	85 c0                	test   %eax,%eax
801061ab:	79 0a                	jns    801061b7 <sys_link+0x3e>
    return -1;
801061ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b2:	e9 37 01 00 00       	jmp    801062ee <sys_link+0x175>
  if((ip = namei(old)) == 0)
801061b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801061ba:	89 04 24             	mov    %eax,(%esp)
801061bd:	e8 1d c2 ff ff       	call   801023df <namei>
801061c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061c9:	75 0a                	jne    801061d5 <sys_link+0x5c>
    return -1;
801061cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061d0:	e9 19 01 00 00       	jmp    801062ee <sys_link+0x175>

  begin_trans();
801061d5:	e8 f6 cf ff ff       	call   801031d0 <begin_trans>

  ilock(ip);
801061da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061dd:	89 04 24             	mov    %eax,(%esp)
801061e0:	e8 60 b6 ff ff       	call   80101845 <ilock>
  if(ip->type == T_DIR){
801061e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e8:	8b 40 10             	mov    0x10(%eax),%eax
801061eb:	66 83 f8 01          	cmp    $0x1,%ax
801061ef:	75 1a                	jne    8010620b <sys_link+0x92>
    iunlockput(ip);
801061f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f4:	89 04 24             	mov    %eax,(%esp)
801061f7:	e8 ca b8 ff ff       	call   80101ac6 <iunlockput>
    commit_trans();
801061fc:	e8 18 d0 ff ff       	call   80103219 <commit_trans>
    return -1;
80106201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106206:	e9 e3 00 00 00       	jmp    801062ee <sys_link+0x175>
  }

  ip->nlink++;
8010620b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620e:	66 8b 40 16          	mov    0x16(%eax),%ax
80106212:	40                   	inc    %eax
80106213:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106216:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010621a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621d:	89 04 24             	mov    %eax,(%esp)
80106220:	e8 66 b4 ff ff       	call   8010168b <iupdate>
  iunlock(ip);
80106225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106228:	89 04 24             	mov    %eax,(%esp)
8010622b:	e8 60 b7 ff ff       	call   80101990 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106230:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106233:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106236:	89 54 24 04          	mov    %edx,0x4(%esp)
8010623a:	89 04 24             	mov    %eax,(%esp)
8010623d:	e8 bf c1 ff ff       	call   80102401 <nameiparent>
80106242:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106245:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106249:	74 68                	je     801062b3 <sys_link+0x13a>
    goto bad;
  ilock(dp);
8010624b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624e:	89 04 24             	mov    %eax,(%esp)
80106251:	e8 ef b5 ff ff       	call   80101845 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106259:	8b 10                	mov    (%eax),%edx
8010625b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010625e:	8b 00                	mov    (%eax),%eax
80106260:	39 c2                	cmp    %eax,%edx
80106262:	75 20                	jne    80106284 <sys_link+0x10b>
80106264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106267:	8b 40 04             	mov    0x4(%eax),%eax
8010626a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010626e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106271:	89 44 24 04          	mov    %eax,0x4(%esp)
80106275:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106278:	89 04 24             	mov    %eax,(%esp)
8010627b:	e8 a8 be ff ff       	call   80102128 <dirlink>
80106280:	85 c0                	test   %eax,%eax
80106282:	79 0d                	jns    80106291 <sys_link+0x118>
    iunlockput(dp);
80106284:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106287:	89 04 24             	mov    %eax,(%esp)
8010628a:	e8 37 b8 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
8010628f:	eb 23                	jmp    801062b4 <sys_link+0x13b>
  }
  iunlockput(dp);
80106291:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106294:	89 04 24             	mov    %eax,(%esp)
80106297:	e8 2a b8 ff ff       	call   80101ac6 <iunlockput>
  iput(ip);
8010629c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010629f:	89 04 24             	mov    %eax,(%esp)
801062a2:	e8 4e b7 ff ff       	call   801019f5 <iput>

  commit_trans();
801062a7:	e8 6d cf ff ff       	call   80103219 <commit_trans>

  return 0;
801062ac:	b8 00 00 00 00       	mov    $0x0,%eax
801062b1:	eb 3b                	jmp    801062ee <sys_link+0x175>
    goto bad;
801062b3:	90                   	nop

bad:
  ilock(ip);
801062b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b7:	89 04 24             	mov    %eax,(%esp)
801062ba:	e8 86 b5 ff ff       	call   80101845 <ilock>
  ip->nlink--;
801062bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c2:	66 8b 40 16          	mov    0x16(%eax),%ax
801062c6:	48                   	dec    %eax
801062c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062ca:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801062ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d1:	89 04 24             	mov    %eax,(%esp)
801062d4:	e8 b2 b3 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
801062d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062dc:	89 04 24             	mov    %eax,(%esp)
801062df:	e8 e2 b7 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
801062e4:	e8 30 cf ff ff       	call   80103219 <commit_trans>
  return -1;
801062e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ee:	c9                   	leave  
801062ef:	c3                   	ret    

801062f0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801062f6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801062fd:	eb 4a                	jmp    80106349 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801062ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106302:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106309:	00 
8010630a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010630e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106311:	89 44 24 04          	mov    %eax,0x4(%esp)
80106315:	8b 45 08             	mov    0x8(%ebp),%eax
80106318:	89 04 24             	mov    %eax,(%esp)
8010631b:	e8 2c ba ff ff       	call   80101d4c <readi>
80106320:	83 f8 10             	cmp    $0x10,%eax
80106323:	74 0c                	je     80106331 <isdirempty+0x41>
      panic("isdirempty: readi");
80106325:	c7 04 24 81 93 10 80 	movl   $0x80109381,(%esp)
8010632c:	e8 05 a2 ff ff       	call   80100536 <panic>
    if(de.inum != 0)
80106331:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106334:	66 85 c0             	test   %ax,%ax
80106337:	74 07                	je     80106340 <isdirempty+0x50>
      return 0;
80106339:	b8 00 00 00 00       	mov    $0x0,%eax
8010633e:	eb 1b                	jmp    8010635b <isdirempty+0x6b>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106343:	83 c0 10             	add    $0x10,%eax
80106346:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106349:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010634c:	8b 45 08             	mov    0x8(%ebp),%eax
8010634f:	8b 40 18             	mov    0x18(%eax),%eax
80106352:	39 c2                	cmp    %eax,%edx
80106354:	72 a9                	jb     801062ff <isdirempty+0xf>
  }
  return 1;
80106356:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010635b:	c9                   	leave  
8010635c:	c3                   	ret    

8010635d <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010635d:	55                   	push   %ebp
8010635e:	89 e5                	mov    %esp,%ebp
80106360:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106363:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106366:	89 44 24 04          	mov    %eax,0x4(%esp)
8010636a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106371:	e8 fd f8 ff ff       	call   80105c73 <argstr>
80106376:	85 c0                	test   %eax,%eax
80106378:	79 0a                	jns    80106384 <sys_unlink+0x27>
    return -1;
8010637a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637f:	e9 a4 01 00 00       	jmp    80106528 <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
80106384:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106387:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010638a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010638e:	89 04 24             	mov    %eax,(%esp)
80106391:	e8 6b c0 ff ff       	call   80102401 <nameiparent>
80106396:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010639d:	75 0a                	jne    801063a9 <sys_unlink+0x4c>
    return -1;
8010639f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a4:	e9 7f 01 00 00       	jmp    80106528 <sys_unlink+0x1cb>

  begin_trans();
801063a9:	e8 22 ce ff ff       	call   801031d0 <begin_trans>

  ilock(dp);
801063ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b1:	89 04 24             	mov    %eax,(%esp)
801063b4:	e8 8c b4 ff ff       	call   80101845 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801063b9:	c7 44 24 04 93 93 10 	movl   $0x80109393,0x4(%esp)
801063c0:	80 
801063c1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801063c4:	89 04 24             	mov    %eax,(%esp)
801063c7:	e8 75 bc ff ff       	call   80102041 <namecmp>
801063cc:	85 c0                	test   %eax,%eax
801063ce:	0f 84 3f 01 00 00    	je     80106513 <sys_unlink+0x1b6>
801063d4:	c7 44 24 04 95 93 10 	movl   $0x80109395,0x4(%esp)
801063db:	80 
801063dc:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801063df:	89 04 24             	mov    %eax,(%esp)
801063e2:	e8 5a bc ff ff       	call   80102041 <namecmp>
801063e7:	85 c0                	test   %eax,%eax
801063e9:	0f 84 24 01 00 00    	je     80106513 <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801063ef:	8d 45 c8             	lea    -0x38(%ebp),%eax
801063f2:	89 44 24 08          	mov    %eax,0x8(%esp)
801063f6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801063f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801063fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106400:	89 04 24             	mov    %eax,(%esp)
80106403:	e8 5b bc ff ff       	call   80102063 <dirlookup>
80106408:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010640b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010640f:	0f 84 fd 00 00 00    	je     80106512 <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80106415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106418:	89 04 24             	mov    %eax,(%esp)
8010641b:	e8 25 b4 ff ff       	call   80101845 <ilock>

  if(ip->nlink < 1)
80106420:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106423:	66 8b 40 16          	mov    0x16(%eax),%ax
80106427:	66 85 c0             	test   %ax,%ax
8010642a:	7f 0c                	jg     80106438 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
8010642c:	c7 04 24 98 93 10 80 	movl   $0x80109398,(%esp)
80106433:	e8 fe a0 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106438:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010643b:	8b 40 10             	mov    0x10(%eax),%eax
8010643e:	66 83 f8 01          	cmp    $0x1,%ax
80106442:	75 1f                	jne    80106463 <sys_unlink+0x106>
80106444:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106447:	89 04 24             	mov    %eax,(%esp)
8010644a:	e8 a1 fe ff ff       	call   801062f0 <isdirempty>
8010644f:	85 c0                	test   %eax,%eax
80106451:	75 10                	jne    80106463 <sys_unlink+0x106>
    iunlockput(ip);
80106453:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106456:	89 04 24             	mov    %eax,(%esp)
80106459:	e8 68 b6 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
8010645e:	e9 b0 00 00 00       	jmp    80106513 <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
80106463:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010646a:	00 
8010646b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106472:	00 
80106473:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106476:	89 04 24             	mov    %eax,(%esp)
80106479:	e8 34 f4 ff ff       	call   801058b2 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010647e:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106481:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106488:	00 
80106489:	89 44 24 08          	mov    %eax,0x8(%esp)
8010648d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106490:	89 44 24 04          	mov    %eax,0x4(%esp)
80106494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106497:	89 04 24             	mov    %eax,(%esp)
8010649a:	e8 12 ba ff ff       	call   80101eb1 <writei>
8010649f:	83 f8 10             	cmp    $0x10,%eax
801064a2:	74 0c                	je     801064b0 <sys_unlink+0x153>
    panic("unlink: writei");
801064a4:	c7 04 24 aa 93 10 80 	movl   $0x801093aa,(%esp)
801064ab:	e8 86 a0 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
801064b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b3:	8b 40 10             	mov    0x10(%eax),%eax
801064b6:	66 83 f8 01          	cmp    $0x1,%ax
801064ba:	75 1a                	jne    801064d6 <sys_unlink+0x179>
    dp->nlink--;
801064bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064bf:	66 8b 40 16          	mov    0x16(%eax),%ax
801064c3:	48                   	dec    %eax
801064c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064c7:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
801064cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ce:	89 04 24             	mov    %eax,(%esp)
801064d1:	e8 b5 b1 ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
801064d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d9:	89 04 24             	mov    %eax,(%esp)
801064dc:	e8 e5 b5 ff ff       	call   80101ac6 <iunlockput>

  ip->nlink--;
801064e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064e4:	66 8b 40 16          	mov    0x16(%eax),%ax
801064e8:	48                   	dec    %eax
801064e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801064ec:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801064f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f3:	89 04 24             	mov    %eax,(%esp)
801064f6:	e8 90 b1 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
801064fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fe:	89 04 24             	mov    %eax,(%esp)
80106501:	e8 c0 b5 ff ff       	call   80101ac6 <iunlockput>

  commit_trans();
80106506:	e8 0e cd ff ff       	call   80103219 <commit_trans>

  return 0;
8010650b:	b8 00 00 00 00       	mov    $0x0,%eax
80106510:	eb 16                	jmp    80106528 <sys_unlink+0x1cb>
    goto bad;
80106512:	90                   	nop

bad:
  iunlockput(dp);
80106513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106516:	89 04 24             	mov    %eax,(%esp)
80106519:	e8 a8 b5 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010651e:	e8 f6 cc ff ff       	call   80103219 <commit_trans>
  return -1;
80106523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106528:	c9                   	leave  
80106529:	c3                   	ret    

8010652a <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010652a:	55                   	push   %ebp
8010652b:	89 e5                	mov    %esp,%ebp
8010652d:	83 ec 48             	sub    $0x48,%esp
80106530:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106533:	8b 55 10             	mov    0x10(%ebp),%edx
80106536:	8b 45 14             	mov    0x14(%ebp),%eax
80106539:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010653d:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106541:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106545:	8d 45 de             	lea    -0x22(%ebp),%eax
80106548:	89 44 24 04          	mov    %eax,0x4(%esp)
8010654c:	8b 45 08             	mov    0x8(%ebp),%eax
8010654f:	89 04 24             	mov    %eax,(%esp)
80106552:	e8 aa be ff ff       	call   80102401 <nameiparent>
80106557:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010655a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010655e:	75 0a                	jne    8010656a <create+0x40>
    return 0;
80106560:	b8 00 00 00 00       	mov    $0x0,%eax
80106565:	e9 79 01 00 00       	jmp    801066e3 <create+0x1b9>
  ilock(dp);
8010656a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656d:	89 04 24             	mov    %eax,(%esp)
80106570:	e8 d0 b2 ff ff       	call   80101845 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80106575:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106578:	89 44 24 08          	mov    %eax,0x8(%esp)
8010657c:	8d 45 de             	lea    -0x22(%ebp),%eax
8010657f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106586:	89 04 24             	mov    %eax,(%esp)
80106589:	e8 d5 ba ff ff       	call   80102063 <dirlookup>
8010658e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106595:	74 46                	je     801065dd <create+0xb3>
    iunlockput(dp);
80106597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010659a:	89 04 24             	mov    %eax,(%esp)
8010659d:	e8 24 b5 ff ff       	call   80101ac6 <iunlockput>
    ilock(ip);
801065a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a5:	89 04 24             	mov    %eax,(%esp)
801065a8:	e8 98 b2 ff ff       	call   80101845 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801065ad:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801065b2:	75 14                	jne    801065c8 <create+0x9e>
801065b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065b7:	8b 40 10             	mov    0x10(%eax),%eax
801065ba:	66 83 f8 02          	cmp    $0x2,%ax
801065be:	75 08                	jne    801065c8 <create+0x9e>
      return ip;
801065c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c3:	e9 1b 01 00 00       	jmp    801066e3 <create+0x1b9>
    iunlockput(ip);
801065c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065cb:	89 04 24             	mov    %eax,(%esp)
801065ce:	e8 f3 b4 ff ff       	call   80101ac6 <iunlockput>
    return 0;
801065d3:	b8 00 00 00 00       	mov    $0x0,%eax
801065d8:	e9 06 01 00 00       	jmp    801066e3 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801065dd:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801065e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e4:	8b 00                	mov    (%eax),%eax
801065e6:	89 54 24 04          	mov    %edx,0x4(%esp)
801065ea:	89 04 24             	mov    %eax,(%esp)
801065ed:	e8 b1 af ff ff       	call   801015a3 <ialloc>
801065f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801065f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801065f9:	75 0c                	jne    80106607 <create+0xdd>
    panic("create: ialloc");
801065fb:	c7 04 24 b9 93 10 80 	movl   $0x801093b9,(%esp)
80106602:	e8 2f 9f ff ff       	call   80100536 <panic>

  ilock(ip);
80106607:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010660a:	89 04 24             	mov    %eax,(%esp)
8010660d:	e8 33 b2 ff ff       	call   80101845 <ilock>
  ip->major = major;
80106612:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106615:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106618:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
8010661c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010661f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106622:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80106626:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106629:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010662f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106632:	89 04 24             	mov    %eax,(%esp)
80106635:	e8 51 b0 ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010663a:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010663f:	75 68                	jne    801066a9 <create+0x17f>
    dp->nlink++;  // for ".."
80106641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106644:	66 8b 40 16          	mov    0x16(%eax),%ax
80106648:	40                   	inc    %eax
80106649:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010664c:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80106650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106653:	89 04 24             	mov    %eax,(%esp)
80106656:	e8 30 b0 ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010665b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010665e:	8b 40 04             	mov    0x4(%eax),%eax
80106661:	89 44 24 08          	mov    %eax,0x8(%esp)
80106665:	c7 44 24 04 93 93 10 	movl   $0x80109393,0x4(%esp)
8010666c:	80 
8010666d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106670:	89 04 24             	mov    %eax,(%esp)
80106673:	e8 b0 ba ff ff       	call   80102128 <dirlink>
80106678:	85 c0                	test   %eax,%eax
8010667a:	78 21                	js     8010669d <create+0x173>
8010667c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667f:	8b 40 04             	mov    0x4(%eax),%eax
80106682:	89 44 24 08          	mov    %eax,0x8(%esp)
80106686:	c7 44 24 04 95 93 10 	movl   $0x80109395,0x4(%esp)
8010668d:	80 
8010668e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106691:	89 04 24             	mov    %eax,(%esp)
80106694:	e8 8f ba ff ff       	call   80102128 <dirlink>
80106699:	85 c0                	test   %eax,%eax
8010669b:	79 0c                	jns    801066a9 <create+0x17f>
      panic("create dots");
8010669d:	c7 04 24 c8 93 10 80 	movl   $0x801093c8,(%esp)
801066a4:	e8 8d 9e ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801066a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066ac:	8b 40 04             	mov    0x4(%eax),%eax
801066af:	89 44 24 08          	mov    %eax,0x8(%esp)
801066b3:	8d 45 de             	lea    -0x22(%ebp),%eax
801066b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801066ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066bd:	89 04 24             	mov    %eax,(%esp)
801066c0:	e8 63 ba ff ff       	call   80102128 <dirlink>
801066c5:	85 c0                	test   %eax,%eax
801066c7:	79 0c                	jns    801066d5 <create+0x1ab>
    panic("create: dirlink");
801066c9:	c7 04 24 d4 93 10 80 	movl   $0x801093d4,(%esp)
801066d0:	e8 61 9e ff ff       	call   80100536 <panic>

  iunlockput(dp);
801066d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d8:	89 04 24             	mov    %eax,(%esp)
801066db:	e8 e6 b3 ff ff       	call   80101ac6 <iunlockput>

  return ip;
801066e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801066e3:	c9                   	leave  
801066e4:	c3                   	ret    

801066e5 <sys_open>:

int
sys_open(void)
{
801066e5:	55                   	push   %ebp
801066e6:	89 e5                	mov    %esp,%ebp
801066e8:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801066eb:	8d 45 e8             	lea    -0x18(%ebp),%eax
801066ee:	89 44 24 04          	mov    %eax,0x4(%esp)
801066f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066f9:	e8 75 f5 ff ff       	call   80105c73 <argstr>
801066fe:	85 c0                	test   %eax,%eax
80106700:	78 17                	js     80106719 <sys_open+0x34>
80106702:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106705:	89 44 24 04          	mov    %eax,0x4(%esp)
80106709:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106710:	e8 ce f4 ff ff       	call   80105be3 <argint>
80106715:	85 c0                	test   %eax,%eax
80106717:	79 0a                	jns    80106723 <sys_open+0x3e>
    return -1;
80106719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671e:	e9 47 01 00 00       	jmp    8010686a <sys_open+0x185>
  if(omode & O_CREATE){
80106723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106726:	25 00 02 00 00       	and    $0x200,%eax
8010672b:	85 c0                	test   %eax,%eax
8010672d:	74 40                	je     8010676f <sys_open+0x8a>
    begin_trans();
8010672f:	e8 9c ca ff ff       	call   801031d0 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106734:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106737:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010673e:	00 
8010673f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106746:	00 
80106747:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010674e:	00 
8010674f:	89 04 24             	mov    %eax,(%esp)
80106752:	e8 d3 fd ff ff       	call   8010652a <create>
80106757:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
8010675a:	e8 ba ca ff ff       	call   80103219 <commit_trans>
    if(ip == 0)
8010675f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106763:	75 5b                	jne    801067c0 <sys_open+0xdb>
      return -1;
80106765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010676a:	e9 fb 00 00 00       	jmp    8010686a <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
8010676f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106772:	89 04 24             	mov    %eax,(%esp)
80106775:	e8 65 bc ff ff       	call   801023df <namei>
8010677a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010677d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106781:	75 0a                	jne    8010678d <sys_open+0xa8>
      return -1;
80106783:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106788:	e9 dd 00 00 00       	jmp    8010686a <sys_open+0x185>
    ilock(ip);
8010678d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106790:	89 04 24             	mov    %eax,(%esp)
80106793:	e8 ad b0 ff ff       	call   80101845 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679b:	8b 40 10             	mov    0x10(%eax),%eax
8010679e:	66 83 f8 01          	cmp    $0x1,%ax
801067a2:	75 1c                	jne    801067c0 <sys_open+0xdb>
801067a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067a7:	85 c0                	test   %eax,%eax
801067a9:	74 15                	je     801067c0 <sys_open+0xdb>
      iunlockput(ip);
801067ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ae:	89 04 24             	mov    %eax,(%esp)
801067b1:	e8 10 b3 ff ff       	call   80101ac6 <iunlockput>
      return -1;
801067b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067bb:	e9 aa 00 00 00       	jmp    8010686a <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801067c0:	e8 2e a7 ff ff       	call   80100ef3 <filealloc>
801067c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801067c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067cc:	74 14                	je     801067e2 <sys_open+0xfd>
801067ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067d1:	89 04 24             	mov    %eax,(%esp)
801067d4:	e8 d5 f5 ff ff       	call   80105dae <fdalloc>
801067d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801067dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801067e0:	79 23                	jns    80106805 <sys_open+0x120>
    if(f)
801067e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067e6:	74 0b                	je     801067f3 <sys_open+0x10e>
      fileclose(f);
801067e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067eb:	89 04 24             	mov    %eax,(%esp)
801067ee:	e8 a8 a7 ff ff       	call   80100f9b <fileclose>
    iunlockput(ip);
801067f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f6:	89 04 24             	mov    %eax,(%esp)
801067f9:	e8 c8 b2 ff ff       	call   80101ac6 <iunlockput>
    return -1;
801067fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106803:	eb 65                	jmp    8010686a <sys_open+0x185>
  }
  iunlock(ip);
80106805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106808:	89 04 24             	mov    %eax,(%esp)
8010680b:	e8 80 b1 ff ff       	call   80101990 <iunlock>

  f->type = FD_INODE;
80106810:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106813:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106819:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010681c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010681f:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106822:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106825:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010682c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010682f:	83 e0 01             	and    $0x1,%eax
80106832:	85 c0                	test   %eax,%eax
80106834:	0f 94 c0             	sete   %al
80106837:	88 c2                	mov    %al,%dl
80106839:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010683c:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010683f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106842:	83 e0 01             	and    $0x1,%eax
80106845:	85 c0                	test   %eax,%eax
80106847:	75 0a                	jne    80106853 <sys_open+0x16e>
80106849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010684c:	83 e0 02             	and    $0x2,%eax
8010684f:	85 c0                	test   %eax,%eax
80106851:	74 07                	je     8010685a <sys_open+0x175>
80106853:	b8 01 00 00 00       	mov    $0x1,%eax
80106858:	eb 05                	jmp    8010685f <sys_open+0x17a>
8010685a:	b8 00 00 00 00       	mov    $0x0,%eax
8010685f:	88 c2                	mov    %al,%dl
80106861:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106864:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106867:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010686a:	c9                   	leave  
8010686b:	c3                   	ret    

8010686c <sys_mkdir>:

int
sys_mkdir(void)
{
8010686c:	55                   	push   %ebp
8010686d:	89 e5                	mov    %esp,%ebp
8010686f:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106872:	e8 59 c9 ff ff       	call   801031d0 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106877:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010687a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010687e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106885:	e8 e9 f3 ff ff       	call   80105c73 <argstr>
8010688a:	85 c0                	test   %eax,%eax
8010688c:	78 2c                	js     801068ba <sys_mkdir+0x4e>
8010688e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106891:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106898:	00 
80106899:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801068a0:	00 
801068a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801068a8:	00 
801068a9:	89 04 24             	mov    %eax,(%esp)
801068ac:	e8 79 fc ff ff       	call   8010652a <create>
801068b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068b8:	75 0c                	jne    801068c6 <sys_mkdir+0x5a>
    commit_trans();
801068ba:	e8 5a c9 ff ff       	call   80103219 <commit_trans>
    return -1;
801068bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c4:	eb 15                	jmp    801068db <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801068c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c9:	89 04 24             	mov    %eax,(%esp)
801068cc:	e8 f5 b1 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
801068d1:	e8 43 c9 ff ff       	call   80103219 <commit_trans>
  return 0;
801068d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068db:	c9                   	leave  
801068dc:	c3                   	ret    

801068dd <sys_mknod>:

int
sys_mknod(void)
{
801068dd:	55                   	push   %ebp
801068de:	89 e5                	mov    %esp,%ebp
801068e0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
801068e3:	e8 e8 c8 ff ff       	call   801031d0 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
801068e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801068ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068f6:	e8 78 f3 ff ff       	call   80105c73 <argstr>
801068fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106902:	78 5e                	js     80106962 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106904:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106907:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106912:	e8 cc f2 ff ff       	call   80105be3 <argint>
  if((len=argstr(0, &path)) < 0 ||
80106917:	85 c0                	test   %eax,%eax
80106919:	78 47                	js     80106962 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
8010691b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010691e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106922:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106929:	e8 b5 f2 ff ff       	call   80105be3 <argint>
     argint(1, &major) < 0 ||
8010692e:	85 c0                	test   %eax,%eax
80106930:	78 30                	js     80106962 <sys_mknod+0x85>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106935:	0f bf c8             	movswl %ax,%ecx
80106938:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010693b:	0f bf d0             	movswl %ax,%edx
8010693e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80106941:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106945:	89 54 24 08          	mov    %edx,0x8(%esp)
80106949:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106950:	00 
80106951:	89 04 24             	mov    %eax,(%esp)
80106954:	e8 d1 fb ff ff       	call   8010652a <create>
80106959:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010695c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106960:	75 0c                	jne    8010696e <sys_mknod+0x91>
    commit_trans();
80106962:	e8 b2 c8 ff ff       	call   80103219 <commit_trans>
    return -1;
80106967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010696c:	eb 15                	jmp    80106983 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010696e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106971:	89 04 24             	mov    %eax,(%esp)
80106974:	e8 4d b1 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80106979:	e8 9b c8 ff ff       	call   80103219 <commit_trans>
  return 0;
8010697e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106983:	c9                   	leave  
80106984:	c3                   	ret    

80106985 <sys_chdir>:

int
sys_chdir(void)
{
80106985:	55                   	push   %ebp
80106986:	89 e5                	mov    %esp,%ebp
80106988:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010698b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010698e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106999:	e8 d5 f2 ff ff       	call   80105c73 <argstr>
8010699e:	85 c0                	test   %eax,%eax
801069a0:	78 14                	js     801069b6 <sys_chdir+0x31>
801069a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069a5:	89 04 24             	mov    %eax,(%esp)
801069a8:	e8 32 ba ff ff       	call   801023df <namei>
801069ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801069b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801069b4:	75 07                	jne    801069bd <sys_chdir+0x38>
    return -1;
801069b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069bb:	eb 56                	jmp    80106a13 <sys_chdir+0x8e>
  ilock(ip);
801069bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c0:	89 04 24             	mov    %eax,(%esp)
801069c3:	e8 7d ae ff ff       	call   80101845 <ilock>
  if(ip->type != T_DIR){
801069c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069cb:	8b 40 10             	mov    0x10(%eax),%eax
801069ce:	66 83 f8 01          	cmp    $0x1,%ax
801069d2:	74 12                	je     801069e6 <sys_chdir+0x61>
    iunlockput(ip);
801069d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069d7:	89 04 24             	mov    %eax,(%esp)
801069da:	e8 e7 b0 ff ff       	call   80101ac6 <iunlockput>
    return -1;
801069df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069e4:	eb 2d                	jmp    80106a13 <sys_chdir+0x8e>
  }
  iunlock(ip);
801069e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069e9:	89 04 24             	mov    %eax,(%esp)
801069ec:	e8 9f af ff ff       	call   80101990 <iunlock>
  iput(proc->cwd);
801069f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069f7:	8b 40 68             	mov    0x68(%eax),%eax
801069fa:	89 04 24             	mov    %eax,(%esp)
801069fd:	e8 f3 af ff ff       	call   801019f5 <iput>
  proc->cwd = ip;
80106a02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a08:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a0b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106a0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a13:	c9                   	leave  
80106a14:	c3                   	ret    

80106a15 <sys_exec>:

int
sys_exec(void)
{
80106a15:	55                   	push   %ebp
80106a16:	89 e5                	mov    %esp,%ebp
80106a18:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106a1e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a21:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a25:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a2c:	e8 42 f2 ff ff       	call   80105c73 <argstr>
80106a31:	85 c0                	test   %eax,%eax
80106a33:	78 1a                	js     80106a4f <sys_exec+0x3a>
80106a35:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a46:	e8 98 f1 ff ff       	call   80105be3 <argint>
80106a4b:	85 c0                	test   %eax,%eax
80106a4d:	79 0a                	jns    80106a59 <sys_exec+0x44>
    return -1;
80106a4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a54:	e9 c7 00 00 00       	jmp    80106b20 <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80106a59:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106a60:	00 
80106a61:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a68:	00 
80106a69:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a6f:	89 04 24             	mov    %eax,(%esp)
80106a72:	e8 3b ee ff ff       	call   801058b2 <memset>
  for(i=0;; i++){
80106a77:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a81:	83 f8 1f             	cmp    $0x1f,%eax
80106a84:	76 0a                	jbe    80106a90 <sys_exec+0x7b>
      return -1;
80106a86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a8b:	e9 90 00 00 00       	jmp    80106b20 <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a93:	c1 e0 02             	shl    $0x2,%eax
80106a96:	89 c2                	mov    %eax,%edx
80106a98:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106a9e:	01 c2                	add    %eax,%edx
80106aa0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aaa:	89 14 24             	mov    %edx,(%esp)
80106aad:	e8 95 f0 ff ff       	call   80105b47 <fetchint>
80106ab2:	85 c0                	test   %eax,%eax
80106ab4:	79 07                	jns    80106abd <sys_exec+0xa8>
      return -1;
80106ab6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106abb:	eb 63                	jmp    80106b20 <sys_exec+0x10b>
    if(uarg == 0){
80106abd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106ac3:	85 c0                	test   %eax,%eax
80106ac5:	75 26                	jne    80106aed <sys_exec+0xd8>
      argv[i] = 0;
80106ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aca:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106ad1:	00 00 00 00 
      break;
80106ad5:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ad9:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106adf:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ae3:	89 04 24             	mov    %eax,(%esp)
80106ae6:	e8 e0 9f ff ff       	call   80100acb <exec>
80106aeb:	eb 33                	jmp    80106b20 <sys_exec+0x10b>
    if(fetchstr(uarg, &argv[i]) < 0)
80106aed:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106af6:	c1 e2 02             	shl    $0x2,%edx
80106af9:	01 c2                	add    %eax,%edx
80106afb:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106b01:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b05:	89 04 24             	mov    %eax,(%esp)
80106b08:	e8 74 f0 ff ff       	call   80105b81 <fetchstr>
80106b0d:	85 c0                	test   %eax,%eax
80106b0f:	79 07                	jns    80106b18 <sys_exec+0x103>
      return -1;
80106b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b16:	eb 08                	jmp    80106b20 <sys_exec+0x10b>
  for(i=0;; i++){
80106b18:	ff 45 f4             	incl   -0xc(%ebp)
  }
80106b1b:	e9 5e ff ff ff       	jmp    80106a7e <sys_exec+0x69>
}
80106b20:	c9                   	leave  
80106b21:	c3                   	ret    

80106b22 <sys_pipe>:

int
sys_pipe(void)
{
80106b22:	55                   	push   %ebp
80106b23:	89 e5                	mov    %esp,%ebp
80106b25:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106b28:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106b2f:	00 
80106b30:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106b33:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b3e:	e8 ce f0 ff ff       	call   80105c11 <argptr>
80106b43:	85 c0                	test   %eax,%eax
80106b45:	79 0a                	jns    80106b51 <sys_pipe+0x2f>
    return -1;
80106b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b4c:	e9 9b 00 00 00       	jmp    80106bec <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106b51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106b54:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b58:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106b5b:	89 04 24             	mov    %eax,(%esp)
80106b5e:	e8 af d0 ff ff       	call   80103c12 <pipealloc>
80106b63:	85 c0                	test   %eax,%eax
80106b65:	79 07                	jns    80106b6e <sys_pipe+0x4c>
    return -1;
80106b67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b6c:	eb 7e                	jmp    80106bec <sys_pipe+0xca>
  fd0 = -1;
80106b6e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b78:	89 04 24             	mov    %eax,(%esp)
80106b7b:	e8 2e f2 ff ff       	call   80105dae <fdalloc>
80106b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106b83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b87:	78 14                	js     80106b9d <sys_pipe+0x7b>
80106b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b8c:	89 04 24             	mov    %eax,(%esp)
80106b8f:	e8 1a f2 ff ff       	call   80105dae <fdalloc>
80106b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b9b:	79 37                	jns    80106bd4 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ba1:	78 14                	js     80106bb7 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106ba3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bac:	83 c2 08             	add    $0x8,%edx
80106baf:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106bb6:	00 
    fileclose(rf);
80106bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106bba:	89 04 24             	mov    %eax,(%esp)
80106bbd:	e8 d9 a3 ff ff       	call   80100f9b <fileclose>
    fileclose(wf);
80106bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bc5:	89 04 24             	mov    %eax,(%esp)
80106bc8:	e8 ce a3 ff ff       	call   80100f9b <fileclose>
    return -1;
80106bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bd2:	eb 18                	jmp    80106bec <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106bd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106bda:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106bdf:	8d 50 04             	lea    0x4(%eax),%edx
80106be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106be5:	89 02                	mov    %eax,(%edx)
  return 0;
80106be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106bec:	c9                   	leave  
80106bed:	c3                   	ret    

80106bee <sys_fork>:
#include "proc.h"
#include "semaphore.h"

int
sys_fork(void)
{
80106bee:	55                   	push   %ebp
80106bef:	89 e5                	mov    %esp,%ebp
80106bf1:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106bf4:	e8 b5 d8 ff ff       	call   801044ae <fork>
}
80106bf9:	c9                   	leave  
80106bfa:	c3                   	ret    

80106bfb <sys_exit>:

int
sys_exit(void)
{
80106bfb:	55                   	push   %ebp
80106bfc:	89 e5                	mov    %esp,%ebp
80106bfe:	83 ec 08             	sub    $0x8,%esp
  exit();
80106c01:	e8 2c da ff ff       	call   80104632 <exit>
  return 0;  // not reached
80106c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c0b:	c9                   	leave  
80106c0c:	c3                   	ret    

80106c0d <sys_wait>:

int
sys_wait(void)
{
80106c0d:	55                   	push   %ebp
80106c0e:	89 e5                	mov    %esp,%ebp
80106c10:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106c13:	e8 ba db ff ff       	call   801047d2 <wait>
}
80106c18:	c9                   	leave  
80106c19:	c3                   	ret    

80106c1a <sys_kill>:

int
sys_kill(void)
{
80106c1a:	55                   	push   %ebp
80106c1b:	89 e5                	mov    %esp,%ebp
80106c1d:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106c20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c23:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c2e:	e8 b0 ef ff ff       	call   80105be3 <argint>
80106c33:	85 c0                	test   %eax,%eax
80106c35:	79 07                	jns    80106c3e <sys_kill+0x24>
    return -1;
80106c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c3c:	eb 0b                	jmp    80106c49 <sys_kill+0x2f>
  return kill(pid);
80106c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c41:	89 04 24             	mov    %eax,(%esp)
80106c44:	e8 c8 df ff ff       	call   80104c11 <kill>
}
80106c49:	c9                   	leave  
80106c4a:	c3                   	ret    

80106c4b <sys_getpid>:

int
sys_getpid(void)
{
80106c4b:	55                   	push   %ebp
80106c4c:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106c4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c54:	8b 40 10             	mov    0x10(%eax),%eax
}
80106c57:	5d                   	pop    %ebp
80106c58:	c3                   	ret    

80106c59 <sys_sbrk>:

int
sys_sbrk(void)
{
80106c59:	55                   	push   %ebp
80106c5a:	89 e5                	mov    %esp,%ebp
80106c5c:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106c5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c62:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c6d:	e8 71 ef ff ff       	call   80105be3 <argint>
80106c72:	85 c0                	test   %eax,%eax
80106c74:	79 07                	jns    80106c7d <sys_sbrk+0x24>
    return -1;
80106c76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c7b:	eb 24                	jmp    80106ca1 <sys_sbrk+0x48>
  addr = proc->sz;
80106c7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c83:	8b 00                	mov    (%eax),%eax
80106c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c8b:	89 04 24             	mov    %eax,(%esp)
80106c8e:	e8 76 d7 ff ff       	call   80104409 <growproc>
80106c93:	85 c0                	test   %eax,%eax
80106c95:	79 07                	jns    80106c9e <sys_sbrk+0x45>
    return -1;
80106c97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c9c:	eb 03                	jmp    80106ca1 <sys_sbrk+0x48>
  return addr;
80106c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106ca1:	c9                   	leave  
80106ca2:	c3                   	ret    

80106ca3 <sys_sleep>:

int
sys_sleep(void)
{
80106ca3:	55                   	push   %ebp
80106ca4:	89 e5                	mov    %esp,%ebp
80106ca6:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106ca9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cac:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cb7:	e8 27 ef ff ff       	call   80105be3 <argint>
80106cbc:	85 c0                	test   %eax,%eax
80106cbe:	79 07                	jns    80106cc7 <sys_sleep+0x24>
    return -1;
80106cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc5:	eb 6c                	jmp    80106d33 <sys_sleep+0x90>
  acquire(&tickslock);
80106cc7:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106cce:	e8 8d e9 ff ff       	call   80105660 <acquire>
  ticks0 = ticks;
80106cd3:	a1 60 44 11 80       	mov    0x80114460,%eax
80106cd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106cdb:	eb 34                	jmp    80106d11 <sys_sleep+0x6e>
    if(proc->killed){
80106cdd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ce3:	8b 40 24             	mov    0x24(%eax),%eax
80106ce6:	85 c0                	test   %eax,%eax
80106ce8:	74 13                	je     80106cfd <sys_sleep+0x5a>
      release(&tickslock);
80106cea:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106cf1:	e8 cc e9 ff ff       	call   801056c2 <release>
      return -1;
80106cf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cfb:	eb 36                	jmp    80106d33 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106cfd:	c7 44 24 04 20 3c 11 	movl   $0x80113c20,0x4(%esp)
80106d04:	80 
80106d05:	c7 04 24 60 44 11 80 	movl   $0x80114460,(%esp)
80106d0c:	e8 cd dd ff ff       	call   80104ade <sleep>
  while(ticks - ticks0 < n){
80106d11:	a1 60 44 11 80       	mov    0x80114460,%eax
80106d16:	89 c2                	mov    %eax,%edx
80106d18:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d1e:	39 c2                	cmp    %eax,%edx
80106d20:	72 bb                	jb     80106cdd <sys_sleep+0x3a>
  }
  release(&tickslock);
80106d22:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106d29:	e8 94 e9 ff ff       	call   801056c2 <release>
  return 0;
80106d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d33:	c9                   	leave  
80106d34:	c3                   	ret    

80106d35 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106d35:	55                   	push   %ebp
80106d36:	89 e5                	mov    %esp,%ebp
80106d38:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106d3b:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106d42:	e8 19 e9 ff ff       	call   80105660 <acquire>
  xticks = ticks;
80106d47:	a1 60 44 11 80       	mov    0x80114460,%eax
80106d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106d4f:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106d56:	e8 67 e9 ff ff       	call   801056c2 <release>
  return xticks;
80106d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106d5e:	c9                   	leave  
80106d5f:	c3                   	ret    

80106d60 <sys_procstat>:

// New: Add in proyect 1: implementation of system call procstat
int
sys_procstat(void){             
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	83 ec 08             	sub    $0x8,%esp
  procdump(); // Print a process listing to console.
80106d66:	e8 2a df ff ff       	call   80104c95 <procdump>
  return 0; 
80106d6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d70:	c9                   	leave  
80106d71:	c3                   	ret    

80106d72 <sys_set_priority>:

// New: Add in project 2: implementation of syscall set_priority
int
sys_set_priority(void){
80106d72:	55                   	push   %ebp
80106d73:	89 e5                	mov    %esp,%ebp
80106d75:	83 ec 28             	sub    $0x28,%esp
  int pr;
  argint(0, &pr);
80106d78:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d86:	e8 58 ee ff ff       	call   80105be3 <argint>
  proc->priority=pr;
80106d8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d94:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d9f:	c9                   	leave  
80106da0:	c3                   	ret    

80106da1 <sys_semget>:

// New: Add in project final - (semaphore)
int
sys_semget(void)
{
80106da1:	55                   	push   %ebp
80106da2:	89 e5                	mov    %esp,%ebp
80106da4:	83 ec 28             	sub    $0x28,%esp
  int semid, init_value;
  if( argint(1, &init_value) < 0 || argint(0, &semid) < 0)
80106da7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106daa:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106db5:	e8 29 ee ff ff       	call   80105be3 <argint>
80106dba:	85 c0                	test   %eax,%eax
80106dbc:	78 17                	js     80106dd5 <sys_semget+0x34>
80106dbe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106dcc:	e8 12 ee ff ff       	call   80105be3 <argint>
80106dd1:	85 c0                	test   %eax,%eax
80106dd3:	79 07                	jns    80106ddc <sys_semget+0x3b>
    return -1;
80106dd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dda:	eb 12                	jmp    80106dee <sys_semget+0x4d>
  return semget(semid,init_value);
80106ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106de2:	89 54 24 04          	mov    %edx,0x4(%esp)
80106de6:	89 04 24             	mov    %eax,(%esp)
80106de9:	e8 f8 df ff ff       	call   80104de6 <semget>
}
80106dee:	c9                   	leave  
80106def:	c3                   	ret    

80106df0 <sys_semfree>:

// New: Add in project final - (semaphore)
int 
sys_semfree(void)
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106df6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106df9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e04:	e8 da ed ff ff       	call   80105be3 <argint>
80106e09:	85 c0                	test   %eax,%eax
80106e0b:	79 07                	jns    80106e14 <sys_semfree+0x24>
    return -1;
80106e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e12:	eb 0b                	jmp    80106e1f <sys_semfree+0x2f>
  return semfree(semid);
80106e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e17:	89 04 24             	mov    %eax,(%esp)
80106e1a:	e8 de e1 ff ff       	call   80104ffd <semfree>
}
80106e1f:	c9                   	leave  
80106e20:	c3                   	ret    

80106e21 <sys_semdown>:

// New: Add in project final - (semaphore)
int 
sys_semdown(void)
{
80106e21:	55                   	push   %ebp
80106e22:	89 e5                	mov    %esp,%ebp
80106e24:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106e27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e35:	e8 a9 ed ff ff       	call   80105be3 <argint>
80106e3a:	85 c0                	test   %eax,%eax
80106e3c:	79 07                	jns    80106e45 <sys_semdown+0x24>
    return -1;
80106e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e43:	eb 0b                	jmp    80106e50 <sys_semdown+0x2f>
  return semdown(semid);
80106e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e48:	89 04 24             	mov    %eax,(%esp)
80106e4b:	e8 44 e2 ff ff       	call   80105094 <semdown>
}
80106e50:	c9                   	leave  
80106e51:	c3                   	ret    

80106e52 <sys_semup>:

// New: Add in project final - (semaphore)
int 
sys_semup(void)
{
80106e52:	55                   	push   %ebp
80106e53:	89 e5                	mov    %esp,%ebp
80106e55:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106e58:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106e5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e66:	e8 78 ed ff ff       	call   80105be3 <argint>
80106e6b:	85 c0                	test   %eax,%eax
80106e6d:	79 07                	jns    80106e76 <sys_semup+0x24>
    return -1;
80106e6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e74:	eb 0b                	jmp    80106e81 <sys_semup+0x2f>
  return semup(semid);
80106e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e79:	89 04 24             	mov    %eax,(%esp)
80106e7c:	e8 95 e2 ff ff       	call   80105116 <semup>
}
80106e81:	c9                   	leave  
80106e82:	c3                   	ret    

80106e83 <outb>:
{
80106e83:	55                   	push   %ebp
80106e84:	89 e5                	mov    %esp,%ebp
80106e86:	83 ec 08             	sub    $0x8,%esp
80106e89:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e8f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106e93:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e96:	8a 45 f8             	mov    -0x8(%ebp),%al
80106e99:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e9c:	ee                   	out    %al,(%dx)
}
80106e9d:	c9                   	leave  
80106e9e:	c3                   	ret    

80106e9f <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106e9f:	55                   	push   %ebp
80106ea0:	89 e5                	mov    %esp,%ebp
80106ea2:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106ea5:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106eac:	00 
80106ead:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106eb4:	e8 ca ff ff ff       	call   80106e83 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106eb9:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106ec0:	00 
80106ec1:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106ec8:	e8 b6 ff ff ff       	call   80106e83 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106ecd:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106ed4:	00 
80106ed5:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106edc:	e8 a2 ff ff ff       	call   80106e83 <outb>
  picenable(IRQ_TIMER);
80106ee1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ee8:	e8 b4 cb ff ff       	call   80103aa1 <picenable>
}
80106eed:	c9                   	leave  
80106eee:	c3                   	ret    

80106eef <alltraps>:
80106eef:	1e                   	push   %ds
80106ef0:	06                   	push   %es
80106ef1:	0f a0                	push   %fs
80106ef3:	0f a8                	push   %gs
80106ef5:	60                   	pusha  
80106ef6:	66 b8 10 00          	mov    $0x10,%ax
80106efa:	8e d8                	mov    %eax,%ds
80106efc:	8e c0                	mov    %eax,%es
80106efe:	66 b8 18 00          	mov    $0x18,%ax
80106f02:	8e e0                	mov    %eax,%fs
80106f04:	8e e8                	mov    %eax,%gs
80106f06:	54                   	push   %esp
80106f07:	e8 c4 01 00 00       	call   801070d0 <trap>
80106f0c:	83 c4 04             	add    $0x4,%esp

80106f0f <trapret>:
80106f0f:	61                   	popa   
80106f10:	0f a9                	pop    %gs
80106f12:	0f a1                	pop    %fs
80106f14:	07                   	pop    %es
80106f15:	1f                   	pop    %ds
80106f16:	83 c4 08             	add    $0x8,%esp
80106f19:	cf                   	iret   

80106f1a <lidt>:
{
80106f1a:	55                   	push   %ebp
80106f1b:	89 e5                	mov    %esp,%ebp
80106f1d:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106f20:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f23:	48                   	dec    %eax
80106f24:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106f28:	8b 45 08             	mov    0x8(%ebp),%eax
80106f2b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f32:	c1 e8 10             	shr    $0x10,%eax
80106f35:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106f39:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106f3c:	0f 01 18             	lidtl  (%eax)
}
80106f3f:	c9                   	leave  
80106f40:	c3                   	ret    

80106f41 <rcr2>:

static inline uint
rcr2(void)
{
80106f41:	55                   	push   %ebp
80106f42:	89 e5                	mov    %esp,%ebp
80106f44:	53                   	push   %ebx
80106f45:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106f48:	0f 20 d3             	mov    %cr2,%ebx
80106f4b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106f51:	83 c4 10             	add    $0x10,%esp
80106f54:	5b                   	pop    %ebx
80106f55:	5d                   	pop    %ebp
80106f56:	c3                   	ret    

80106f57 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106f57:	55                   	push   %ebp
80106f58:	89 e5                	mov    %esp,%ebp
80106f5a:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106f64:	e9 b8 00 00 00       	jmp    80107021 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106f69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f6c:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f76:	66 89 04 d5 60 3c 11 	mov    %ax,-0x7feec3a0(,%edx,8)
80106f7d:	80 
80106f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f81:	66 c7 04 c5 62 3c 11 	movw   $0x8,-0x7feec39e(,%eax,8)
80106f88:	80 08 00 
80106f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f8e:	8a 14 c5 64 3c 11 80 	mov    -0x7feec39c(,%eax,8),%dl
80106f95:	83 e2 e0             	and    $0xffffffe0,%edx
80106f98:	88 14 c5 64 3c 11 80 	mov    %dl,-0x7feec39c(,%eax,8)
80106f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fa2:	8a 14 c5 64 3c 11 80 	mov    -0x7feec39c(,%eax,8),%dl
80106fa9:	83 e2 1f             	and    $0x1f,%edx
80106fac:	88 14 c5 64 3c 11 80 	mov    %dl,-0x7feec39c(,%eax,8)
80106fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fb6:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106fbd:	83 e2 f0             	and    $0xfffffff0,%edx
80106fc0:	83 ca 0e             	or     $0xe,%edx
80106fc3:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fcd:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106fd4:	83 e2 ef             	and    $0xffffffef,%edx
80106fd7:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe1:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106fe8:	83 e2 9f             	and    $0xffffff9f,%edx
80106feb:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ff5:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106ffc:	83 ca 80             	or     $0xffffff80,%edx
80106fff:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80107006:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107009:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80107010:	c1 e8 10             	shr    $0x10,%eax
80107013:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107016:	66 89 04 d5 66 3c 11 	mov    %ax,-0x7feec39a(,%edx,8)
8010701d:	80 
  for(i = 0; i < 256; i++)
8010701e:	ff 45 f4             	incl   -0xc(%ebp)
80107021:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80107028:	0f 8e 3b ff ff ff    	jle    80106f69 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010702e:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80107033:	66 a3 60 3e 11 80    	mov    %ax,0x80113e60
80107039:	66 c7 05 62 3e 11 80 	movw   $0x8,0x80113e62
80107040:	08 00 
80107042:	a0 64 3e 11 80       	mov    0x80113e64,%al
80107047:	83 e0 e0             	and    $0xffffffe0,%eax
8010704a:	a2 64 3e 11 80       	mov    %al,0x80113e64
8010704f:	a0 64 3e 11 80       	mov    0x80113e64,%al
80107054:	83 e0 1f             	and    $0x1f,%eax
80107057:	a2 64 3e 11 80       	mov    %al,0x80113e64
8010705c:	a0 65 3e 11 80       	mov    0x80113e65,%al
80107061:	83 c8 0f             	or     $0xf,%eax
80107064:	a2 65 3e 11 80       	mov    %al,0x80113e65
80107069:	a0 65 3e 11 80       	mov    0x80113e65,%al
8010706e:	83 e0 ef             	and    $0xffffffef,%eax
80107071:	a2 65 3e 11 80       	mov    %al,0x80113e65
80107076:	a0 65 3e 11 80       	mov    0x80113e65,%al
8010707b:	83 c8 60             	or     $0x60,%eax
8010707e:	a2 65 3e 11 80       	mov    %al,0x80113e65
80107083:	a0 65 3e 11 80       	mov    0x80113e65,%al
80107088:	83 c8 80             	or     $0xffffff80,%eax
8010708b:	a2 65 3e 11 80       	mov    %al,0x80113e65
80107090:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80107095:	c1 e8 10             	shr    $0x10,%eax
80107098:	66 a3 66 3e 11 80    	mov    %ax,0x80113e66
  
  initlock(&tickslock, "time");
8010709e:	c7 44 24 04 e4 93 10 	movl   $0x801093e4,0x4(%esp)
801070a5:	80 
801070a6:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
801070ad:	e8 8d e5 ff ff       	call   8010563f <initlock>
}
801070b2:	c9                   	leave  
801070b3:	c3                   	ret    

801070b4 <idtinit>:

void
idtinit(void)
{
801070b4:	55                   	push   %ebp
801070b5:	89 e5                	mov    %esp,%ebp
801070b7:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801070ba:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801070c1:	00 
801070c2:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
801070c9:	e8 4c fe ff ff       	call   80106f1a <lidt>
}
801070ce:	c9                   	leave  
801070cf:	c3                   	ret    

801070d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801070d9:	8b 45 08             	mov    0x8(%ebp),%eax
801070dc:	8b 40 30             	mov    0x30(%eax),%eax
801070df:	83 f8 40             	cmp    $0x40,%eax
801070e2:	75 3e                	jne    80107122 <trap+0x52>
    if(proc->killed)
801070e4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070ea:	8b 40 24             	mov    0x24(%eax),%eax
801070ed:	85 c0                	test   %eax,%eax
801070ef:	74 05                	je     801070f6 <trap+0x26>
      exit();
801070f1:	e8 3c d5 ff ff       	call   80104632 <exit>
    proc->tf = tf;
801070f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070fc:	8b 55 08             	mov    0x8(%ebp),%edx
801070ff:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107102:	e8 a3 eb ff ff       	call   80105caa <syscall>
    if(proc->killed)
80107107:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010710d:	8b 40 24             	mov    0x24(%eax),%eax
80107110:	85 c0                	test   %eax,%eax
80107112:	0f 84 3f 02 00 00    	je     80107357 <trap+0x287>
      exit();
80107118:	e8 15 d5 ff ff       	call   80104632 <exit>
    return;
8010711d:	e9 35 02 00 00       	jmp    80107357 <trap+0x287>
  }

  switch(tf->trapno){
80107122:	8b 45 08             	mov    0x8(%ebp),%eax
80107125:	8b 40 30             	mov    0x30(%eax),%eax
80107128:	83 e8 20             	sub    $0x20,%eax
8010712b:	83 f8 1f             	cmp    $0x1f,%eax
8010712e:	0f 87 b7 00 00 00    	ja     801071eb <trap+0x11b>
80107134:	8b 04 85 8c 94 10 80 	mov    -0x7fef6b74(,%eax,4),%eax
8010713b:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010713d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107143:	8a 00                	mov    (%eax),%al
80107145:	84 c0                	test   %al,%al
80107147:	75 2f                	jne    80107178 <trap+0xa8>
      acquire(&tickslock);
80107149:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80107150:	e8 0b e5 ff ff       	call   80105660 <acquire>
      ticks++;
80107155:	a1 60 44 11 80       	mov    0x80114460,%eax
8010715a:	40                   	inc    %eax
8010715b:	a3 60 44 11 80       	mov    %eax,0x80114460
      wakeup(&ticks);
80107160:	c7 04 24 60 44 11 80 	movl   $0x80114460,(%esp)
80107167:	e8 7a da ff ff       	call   80104be6 <wakeup>
      release(&tickslock);
8010716c:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80107173:	e8 4a e5 ff ff       	call   801056c2 <release>
    }
    lapiceoi();
80107178:	e8 22 bd ff ff       	call   80102e9f <lapiceoi>
    break;
8010717d:	e9 3c 01 00 00       	jmp    801072be <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107182:	e8 36 b5 ff ff       	call   801026bd <ideintr>
    lapiceoi();
80107187:	e8 13 bd ff ff       	call   80102e9f <lapiceoi>
    break;
8010718c:	e9 2d 01 00 00       	jmp    801072be <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107191:	e8 ec ba ff ff       	call   80102c82 <kbdintr>
    lapiceoi();
80107196:	e8 04 bd ff ff       	call   80102e9f <lapiceoi>
    break;
8010719b:	e9 1e 01 00 00       	jmp    801072be <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801071a0:	e8 af 03 00 00       	call   80107554 <uartintr>
    lapiceoi();
801071a5:	e8 f5 bc ff ff       	call   80102e9f <lapiceoi>
    break;
801071aa:	e9 0f 01 00 00       	jmp    801072be <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801071af:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071b2:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801071b5:	8b 45 08             	mov    0x8(%ebp),%eax
801071b8:	8b 40 3c             	mov    0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071bb:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801071be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071c4:	8a 00                	mov    (%eax),%al
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801071c6:	0f b6 c0             	movzbl %al,%eax
801071c9:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801071cd:	89 54 24 08          	mov    %edx,0x8(%esp)
801071d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801071d5:	c7 04 24 ec 93 10 80 	movl   $0x801093ec,(%esp)
801071dc:	e8 c0 91 ff ff       	call   801003a1 <cprintf>
    lapiceoi();
801071e1:	e8 b9 bc ff ff       	call   80102e9f <lapiceoi>
    break;
801071e6:	e9 d3 00 00 00       	jmp    801072be <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801071eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071f1:	85 c0                	test   %eax,%eax
801071f3:	74 10                	je     80107205 <trap+0x135>
801071f5:	8b 45 08             	mov    0x8(%ebp),%eax
801071f8:	8b 40 3c             	mov    0x3c(%eax),%eax
801071fb:	0f b7 c0             	movzwl %ax,%eax
801071fe:	83 e0 03             	and    $0x3,%eax
80107201:	85 c0                	test   %eax,%eax
80107203:	75 45                	jne    8010724a <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107205:	e8 37 fd ff ff       	call   80106f41 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
8010720a:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010720d:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107210:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107217:	8a 12                	mov    (%edx),%dl
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107219:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010721c:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010721f:	8b 52 30             	mov    0x30(%edx),%edx
80107222:	89 44 24 10          	mov    %eax,0x10(%esp)
80107226:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010722a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010722e:	89 54 24 04          	mov    %edx,0x4(%esp)
80107232:	c7 04 24 10 94 10 80 	movl   $0x80109410,(%esp)
80107239:	e8 63 91 ff ff       	call   801003a1 <cprintf>
      panic("trap");
8010723e:	c7 04 24 42 94 10 80 	movl   $0x80109442,(%esp)
80107245:	e8 ec 92 ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010724a:	e8 f2 fc ff ff       	call   80106f41 <rcr2>
8010724f:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107251:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107254:	8b 78 38             	mov    0x38(%eax),%edi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107257:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010725d:	8a 00                	mov    (%eax),%al
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010725f:	0f b6 f0             	movzbl %al,%esi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107262:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107265:	8b 58 34             	mov    0x34(%eax),%ebx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107268:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010726b:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010726e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107274:	83 c0 6c             	add    $0x6c,%eax
80107277:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010727a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107280:	8b 40 10             	mov    0x10(%eax),%eax
80107283:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107287:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010728b:	89 74 24 14          	mov    %esi,0x14(%esp)
8010728f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107293:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010729a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010729e:	89 44 24 04          	mov    %eax,0x4(%esp)
801072a2:	c7 04 24 48 94 10 80 	movl   $0x80109448,(%esp)
801072a9:	e8 f3 90 ff ff       	call   801003a1 <cprintf>
            rcr2());
    proc->killed = 1;
801072ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072b4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801072bb:	eb 01                	jmp    801072be <trap+0x1ee>
    break;
801072bd:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801072be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072c4:	85 c0                	test   %eax,%eax
801072c6:	74 23                	je     801072eb <trap+0x21b>
801072c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072ce:	8b 40 24             	mov    0x24(%eax),%eax
801072d1:	85 c0                	test   %eax,%eax
801072d3:	74 16                	je     801072eb <trap+0x21b>
801072d5:	8b 45 08             	mov    0x8(%ebp),%eax
801072d8:	8b 40 3c             	mov    0x3c(%eax),%eax
801072db:	0f b7 c0             	movzwl %ax,%eax
801072de:	83 e0 03             	and    $0x3,%eax
801072e1:	83 f8 03             	cmp    $0x3,%eax
801072e4:	75 05                	jne    801072eb <trap+0x21b>
    exit();
801072e6:	e8 47 d3 ff ff       	call   80104632 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER && ++(proc->ticksProc) == QUANTUM) {
801072eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072f1:	85 c0                	test   %eax,%eax
801072f3:	74 33                	je     80107328 <trap+0x258>
801072f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072fb:	8b 40 0c             	mov    0xc(%eax),%eax
801072fe:	83 f8 04             	cmp    $0x4,%eax
80107301:	75 25                	jne    80107328 <trap+0x258>
80107303:	8b 45 08             	mov    0x8(%ebp),%eax
80107306:	8b 40 30             	mov    0x30(%eax),%eax
80107309:	83 f8 20             	cmp    $0x20,%eax
8010730c:	75 1a                	jne    80107328 <trap+0x258>
8010730e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107314:	8b 50 7c             	mov    0x7c(%eax),%edx
80107317:	42                   	inc    %edx
80107318:	89 50 7c             	mov    %edx,0x7c(%eax)
8010731b:	8b 40 7c             	mov    0x7c(%eax),%eax
8010731e:	83 f8 06             	cmp    $0x6,%eax
80107321:	75 05                	jne    80107328 <trap+0x258>
      // New: Added in proyect 0
      // cprintf("tamaño del quantum: %d\n", QUANTUM);
      // cprintf("cantidad de ticks del proceso: %d\n", proc->ticksProc);
      // cprintf("nombre del proceso: %s\n", proc->name);
      // cprintf("abandone cpu\n");
      yield();
80107323:	e8 2b d7 ff ff       	call   80104a53 <yield>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107328:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010732e:	85 c0                	test   %eax,%eax
80107330:	74 26                	je     80107358 <trap+0x288>
80107332:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107338:	8b 40 24             	mov    0x24(%eax),%eax
8010733b:	85 c0                	test   %eax,%eax
8010733d:	74 19                	je     80107358 <trap+0x288>
8010733f:	8b 45 08             	mov    0x8(%ebp),%eax
80107342:	8b 40 3c             	mov    0x3c(%eax),%eax
80107345:	0f b7 c0             	movzwl %ax,%eax
80107348:	83 e0 03             	and    $0x3,%eax
8010734b:	83 f8 03             	cmp    $0x3,%eax
8010734e:	75 08                	jne    80107358 <trap+0x288>
    exit();
80107350:	e8 dd d2 ff ff       	call   80104632 <exit>
80107355:	eb 01                	jmp    80107358 <trap+0x288>
    return;
80107357:	90                   	nop
}
80107358:	83 c4 3c             	add    $0x3c,%esp
8010735b:	5b                   	pop    %ebx
8010735c:	5e                   	pop    %esi
8010735d:	5f                   	pop    %edi
8010735e:	5d                   	pop    %ebp
8010735f:	c3                   	ret    

80107360 <inb>:
{
80107360:	55                   	push   %ebp
80107361:	89 e5                	mov    %esp,%ebp
80107363:	53                   	push   %ebx
80107364:	83 ec 14             	sub    $0x14,%esp
80107367:	8b 45 08             	mov    0x8(%ebp),%eax
8010736a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010736e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80107371:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80107375:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
80107379:	ec                   	in     (%dx),%al
8010737a:	88 c3                	mov    %al,%bl
8010737c:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
8010737f:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80107382:	83 c4 14             	add    $0x14,%esp
80107385:	5b                   	pop    %ebx
80107386:	5d                   	pop    %ebp
80107387:	c3                   	ret    

80107388 <outb>:
{
80107388:	55                   	push   %ebp
80107389:	89 e5                	mov    %esp,%ebp
8010738b:	83 ec 08             	sub    $0x8,%esp
8010738e:	8b 45 08             	mov    0x8(%ebp),%eax
80107391:	8b 55 0c             	mov    0xc(%ebp),%edx
80107394:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107398:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010739b:	8a 45 f8             	mov    -0x8(%ebp),%al
8010739e:	8b 55 fc             	mov    -0x4(%ebp),%edx
801073a1:	ee                   	out    %al,(%dx)
}
801073a2:	c9                   	leave  
801073a3:	c3                   	ret    

801073a4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801073aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073b1:	00 
801073b2:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801073b9:	e8 ca ff ff ff       	call   80107388 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801073be:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801073c5:	00 
801073c6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801073cd:	e8 b6 ff ff ff       	call   80107388 <outb>
  outb(COM1+0, 115200/9600);
801073d2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801073d9:	00 
801073da:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073e1:	e8 a2 ff ff ff       	call   80107388 <outb>
  outb(COM1+1, 0);
801073e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073ed:	00 
801073ee:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801073f5:	e8 8e ff ff ff       	call   80107388 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801073fa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107401:	00 
80107402:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107409:	e8 7a ff ff ff       	call   80107388 <outb>
  outb(COM1+4, 0);
8010740e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107415:	00 
80107416:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010741d:	e8 66 ff ff ff       	call   80107388 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107422:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107429:	00 
8010742a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107431:	e8 52 ff ff ff       	call   80107388 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107436:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010743d:	e8 1e ff ff ff       	call   80107360 <inb>
80107442:	3c ff                	cmp    $0xff,%al
80107444:	74 69                	je     801074af <uartinit+0x10b>
    return;
  uart = 1;
80107446:	c7 05 8c c6 10 80 01 	movl   $0x1,0x8010c68c
8010744d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107450:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107457:	e8 04 ff ff ff       	call   80107360 <inb>
  inb(COM1+0);
8010745c:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107463:	e8 f8 fe ff ff       	call   80107360 <inb>
  picenable(IRQ_COM1);
80107468:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010746f:	e8 2d c6 ff ff       	call   80103aa1 <picenable>
  ioapicenable(IRQ_COM1, 0);
80107474:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010747b:	00 
8010747c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107483:	e8 b2 b4 ff ff       	call   8010293a <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107488:	c7 45 f4 0c 95 10 80 	movl   $0x8010950c,-0xc(%ebp)
8010748f:	eb 13                	jmp    801074a4 <uartinit+0x100>
    uartputc(*p);
80107491:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107494:	8a 00                	mov    (%eax),%al
80107496:	0f be c0             	movsbl %al,%eax
80107499:	89 04 24             	mov    %eax,(%esp)
8010749c:	e8 11 00 00 00       	call   801074b2 <uartputc>
  for(p="xv6...\n"; *p; p++)
801074a1:	ff 45 f4             	incl   -0xc(%ebp)
801074a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a7:	8a 00                	mov    (%eax),%al
801074a9:	84 c0                	test   %al,%al
801074ab:	75 e4                	jne    80107491 <uartinit+0xed>
801074ad:	eb 01                	jmp    801074b0 <uartinit+0x10c>
    return;
801074af:	90                   	nop
}
801074b0:	c9                   	leave  
801074b1:	c3                   	ret    

801074b2 <uartputc>:

void
uartputc(int c)
{
801074b2:	55                   	push   %ebp
801074b3:	89 e5                	mov    %esp,%ebp
801074b5:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801074b8:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
801074bd:	85 c0                	test   %eax,%eax
801074bf:	74 4c                	je     8010750d <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801074c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801074c8:	eb 0f                	jmp    801074d9 <uartputc+0x27>
    microdelay(10);
801074ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801074d1:	e8 ee b9 ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801074d6:	ff 45 f4             	incl   -0xc(%ebp)
801074d9:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801074dd:	7f 16                	jg     801074f5 <uartputc+0x43>
801074df:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801074e6:	e8 75 fe ff ff       	call   80107360 <inb>
801074eb:	0f b6 c0             	movzbl %al,%eax
801074ee:	83 e0 20             	and    $0x20,%eax
801074f1:	85 c0                	test   %eax,%eax
801074f3:	74 d5                	je     801074ca <uartputc+0x18>
  outb(COM1+0, c);
801074f5:	8b 45 08             	mov    0x8(%ebp),%eax
801074f8:	0f b6 c0             	movzbl %al,%eax
801074fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801074ff:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107506:	e8 7d fe ff ff       	call   80107388 <outb>
8010750b:	eb 01                	jmp    8010750e <uartputc+0x5c>
    return;
8010750d:	90                   	nop
}
8010750e:	c9                   	leave  
8010750f:	c3                   	ret    

80107510 <uartgetc>:

static int
uartgetc(void)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107516:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
8010751b:	85 c0                	test   %eax,%eax
8010751d:	75 07                	jne    80107526 <uartgetc+0x16>
    return -1;
8010751f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107524:	eb 2c                	jmp    80107552 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80107526:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010752d:	e8 2e fe ff ff       	call   80107360 <inb>
80107532:	0f b6 c0             	movzbl %al,%eax
80107535:	83 e0 01             	and    $0x1,%eax
80107538:	85 c0                	test   %eax,%eax
8010753a:	75 07                	jne    80107543 <uartgetc+0x33>
    return -1;
8010753c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107541:	eb 0f                	jmp    80107552 <uartgetc+0x42>
  return inb(COM1+0);
80107543:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010754a:	e8 11 fe ff ff       	call   80107360 <inb>
8010754f:	0f b6 c0             	movzbl %al,%eax
}
80107552:	c9                   	leave  
80107553:	c3                   	ret    

80107554 <uartintr>:

void
uartintr(void)
{
80107554:	55                   	push   %ebp
80107555:	89 e5                	mov    %esp,%ebp
80107557:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010755a:	c7 04 24 10 75 10 80 	movl   $0x80107510,(%esp)
80107561:	e8 2a 92 ff ff       	call   80100790 <consoleintr>
}
80107566:	c9                   	leave  
80107567:	c3                   	ret    

80107568 <vector0>:
80107568:	6a 00                	push   $0x0
8010756a:	6a 00                	push   $0x0
8010756c:	e9 7e f9 ff ff       	jmp    80106eef <alltraps>

80107571 <vector1>:
80107571:	6a 00                	push   $0x0
80107573:	6a 01                	push   $0x1
80107575:	e9 75 f9 ff ff       	jmp    80106eef <alltraps>

8010757a <vector2>:
8010757a:	6a 00                	push   $0x0
8010757c:	6a 02                	push   $0x2
8010757e:	e9 6c f9 ff ff       	jmp    80106eef <alltraps>

80107583 <vector3>:
80107583:	6a 00                	push   $0x0
80107585:	6a 03                	push   $0x3
80107587:	e9 63 f9 ff ff       	jmp    80106eef <alltraps>

8010758c <vector4>:
8010758c:	6a 00                	push   $0x0
8010758e:	6a 04                	push   $0x4
80107590:	e9 5a f9 ff ff       	jmp    80106eef <alltraps>

80107595 <vector5>:
80107595:	6a 00                	push   $0x0
80107597:	6a 05                	push   $0x5
80107599:	e9 51 f9 ff ff       	jmp    80106eef <alltraps>

8010759e <vector6>:
8010759e:	6a 00                	push   $0x0
801075a0:	6a 06                	push   $0x6
801075a2:	e9 48 f9 ff ff       	jmp    80106eef <alltraps>

801075a7 <vector7>:
801075a7:	6a 00                	push   $0x0
801075a9:	6a 07                	push   $0x7
801075ab:	e9 3f f9 ff ff       	jmp    80106eef <alltraps>

801075b0 <vector8>:
801075b0:	6a 08                	push   $0x8
801075b2:	e9 38 f9 ff ff       	jmp    80106eef <alltraps>

801075b7 <vector9>:
801075b7:	6a 00                	push   $0x0
801075b9:	6a 09                	push   $0x9
801075bb:	e9 2f f9 ff ff       	jmp    80106eef <alltraps>

801075c0 <vector10>:
801075c0:	6a 0a                	push   $0xa
801075c2:	e9 28 f9 ff ff       	jmp    80106eef <alltraps>

801075c7 <vector11>:
801075c7:	6a 0b                	push   $0xb
801075c9:	e9 21 f9 ff ff       	jmp    80106eef <alltraps>

801075ce <vector12>:
801075ce:	6a 0c                	push   $0xc
801075d0:	e9 1a f9 ff ff       	jmp    80106eef <alltraps>

801075d5 <vector13>:
801075d5:	6a 0d                	push   $0xd
801075d7:	e9 13 f9 ff ff       	jmp    80106eef <alltraps>

801075dc <vector14>:
801075dc:	6a 0e                	push   $0xe
801075de:	e9 0c f9 ff ff       	jmp    80106eef <alltraps>

801075e3 <vector15>:
801075e3:	6a 00                	push   $0x0
801075e5:	6a 0f                	push   $0xf
801075e7:	e9 03 f9 ff ff       	jmp    80106eef <alltraps>

801075ec <vector16>:
801075ec:	6a 00                	push   $0x0
801075ee:	6a 10                	push   $0x10
801075f0:	e9 fa f8 ff ff       	jmp    80106eef <alltraps>

801075f5 <vector17>:
801075f5:	6a 11                	push   $0x11
801075f7:	e9 f3 f8 ff ff       	jmp    80106eef <alltraps>

801075fc <vector18>:
801075fc:	6a 00                	push   $0x0
801075fe:	6a 12                	push   $0x12
80107600:	e9 ea f8 ff ff       	jmp    80106eef <alltraps>

80107605 <vector19>:
80107605:	6a 00                	push   $0x0
80107607:	6a 13                	push   $0x13
80107609:	e9 e1 f8 ff ff       	jmp    80106eef <alltraps>

8010760e <vector20>:
8010760e:	6a 00                	push   $0x0
80107610:	6a 14                	push   $0x14
80107612:	e9 d8 f8 ff ff       	jmp    80106eef <alltraps>

80107617 <vector21>:
80107617:	6a 00                	push   $0x0
80107619:	6a 15                	push   $0x15
8010761b:	e9 cf f8 ff ff       	jmp    80106eef <alltraps>

80107620 <vector22>:
80107620:	6a 00                	push   $0x0
80107622:	6a 16                	push   $0x16
80107624:	e9 c6 f8 ff ff       	jmp    80106eef <alltraps>

80107629 <vector23>:
80107629:	6a 00                	push   $0x0
8010762b:	6a 17                	push   $0x17
8010762d:	e9 bd f8 ff ff       	jmp    80106eef <alltraps>

80107632 <vector24>:
80107632:	6a 00                	push   $0x0
80107634:	6a 18                	push   $0x18
80107636:	e9 b4 f8 ff ff       	jmp    80106eef <alltraps>

8010763b <vector25>:
8010763b:	6a 00                	push   $0x0
8010763d:	6a 19                	push   $0x19
8010763f:	e9 ab f8 ff ff       	jmp    80106eef <alltraps>

80107644 <vector26>:
80107644:	6a 00                	push   $0x0
80107646:	6a 1a                	push   $0x1a
80107648:	e9 a2 f8 ff ff       	jmp    80106eef <alltraps>

8010764d <vector27>:
8010764d:	6a 00                	push   $0x0
8010764f:	6a 1b                	push   $0x1b
80107651:	e9 99 f8 ff ff       	jmp    80106eef <alltraps>

80107656 <vector28>:
80107656:	6a 00                	push   $0x0
80107658:	6a 1c                	push   $0x1c
8010765a:	e9 90 f8 ff ff       	jmp    80106eef <alltraps>

8010765f <vector29>:
8010765f:	6a 00                	push   $0x0
80107661:	6a 1d                	push   $0x1d
80107663:	e9 87 f8 ff ff       	jmp    80106eef <alltraps>

80107668 <vector30>:
80107668:	6a 00                	push   $0x0
8010766a:	6a 1e                	push   $0x1e
8010766c:	e9 7e f8 ff ff       	jmp    80106eef <alltraps>

80107671 <vector31>:
80107671:	6a 00                	push   $0x0
80107673:	6a 1f                	push   $0x1f
80107675:	e9 75 f8 ff ff       	jmp    80106eef <alltraps>

8010767a <vector32>:
8010767a:	6a 00                	push   $0x0
8010767c:	6a 20                	push   $0x20
8010767e:	e9 6c f8 ff ff       	jmp    80106eef <alltraps>

80107683 <vector33>:
80107683:	6a 00                	push   $0x0
80107685:	6a 21                	push   $0x21
80107687:	e9 63 f8 ff ff       	jmp    80106eef <alltraps>

8010768c <vector34>:
8010768c:	6a 00                	push   $0x0
8010768e:	6a 22                	push   $0x22
80107690:	e9 5a f8 ff ff       	jmp    80106eef <alltraps>

80107695 <vector35>:
80107695:	6a 00                	push   $0x0
80107697:	6a 23                	push   $0x23
80107699:	e9 51 f8 ff ff       	jmp    80106eef <alltraps>

8010769e <vector36>:
8010769e:	6a 00                	push   $0x0
801076a0:	6a 24                	push   $0x24
801076a2:	e9 48 f8 ff ff       	jmp    80106eef <alltraps>

801076a7 <vector37>:
801076a7:	6a 00                	push   $0x0
801076a9:	6a 25                	push   $0x25
801076ab:	e9 3f f8 ff ff       	jmp    80106eef <alltraps>

801076b0 <vector38>:
801076b0:	6a 00                	push   $0x0
801076b2:	6a 26                	push   $0x26
801076b4:	e9 36 f8 ff ff       	jmp    80106eef <alltraps>

801076b9 <vector39>:
801076b9:	6a 00                	push   $0x0
801076bb:	6a 27                	push   $0x27
801076bd:	e9 2d f8 ff ff       	jmp    80106eef <alltraps>

801076c2 <vector40>:
801076c2:	6a 00                	push   $0x0
801076c4:	6a 28                	push   $0x28
801076c6:	e9 24 f8 ff ff       	jmp    80106eef <alltraps>

801076cb <vector41>:
801076cb:	6a 00                	push   $0x0
801076cd:	6a 29                	push   $0x29
801076cf:	e9 1b f8 ff ff       	jmp    80106eef <alltraps>

801076d4 <vector42>:
801076d4:	6a 00                	push   $0x0
801076d6:	6a 2a                	push   $0x2a
801076d8:	e9 12 f8 ff ff       	jmp    80106eef <alltraps>

801076dd <vector43>:
801076dd:	6a 00                	push   $0x0
801076df:	6a 2b                	push   $0x2b
801076e1:	e9 09 f8 ff ff       	jmp    80106eef <alltraps>

801076e6 <vector44>:
801076e6:	6a 00                	push   $0x0
801076e8:	6a 2c                	push   $0x2c
801076ea:	e9 00 f8 ff ff       	jmp    80106eef <alltraps>

801076ef <vector45>:
801076ef:	6a 00                	push   $0x0
801076f1:	6a 2d                	push   $0x2d
801076f3:	e9 f7 f7 ff ff       	jmp    80106eef <alltraps>

801076f8 <vector46>:
801076f8:	6a 00                	push   $0x0
801076fa:	6a 2e                	push   $0x2e
801076fc:	e9 ee f7 ff ff       	jmp    80106eef <alltraps>

80107701 <vector47>:
80107701:	6a 00                	push   $0x0
80107703:	6a 2f                	push   $0x2f
80107705:	e9 e5 f7 ff ff       	jmp    80106eef <alltraps>

8010770a <vector48>:
8010770a:	6a 00                	push   $0x0
8010770c:	6a 30                	push   $0x30
8010770e:	e9 dc f7 ff ff       	jmp    80106eef <alltraps>

80107713 <vector49>:
80107713:	6a 00                	push   $0x0
80107715:	6a 31                	push   $0x31
80107717:	e9 d3 f7 ff ff       	jmp    80106eef <alltraps>

8010771c <vector50>:
8010771c:	6a 00                	push   $0x0
8010771e:	6a 32                	push   $0x32
80107720:	e9 ca f7 ff ff       	jmp    80106eef <alltraps>

80107725 <vector51>:
80107725:	6a 00                	push   $0x0
80107727:	6a 33                	push   $0x33
80107729:	e9 c1 f7 ff ff       	jmp    80106eef <alltraps>

8010772e <vector52>:
8010772e:	6a 00                	push   $0x0
80107730:	6a 34                	push   $0x34
80107732:	e9 b8 f7 ff ff       	jmp    80106eef <alltraps>

80107737 <vector53>:
80107737:	6a 00                	push   $0x0
80107739:	6a 35                	push   $0x35
8010773b:	e9 af f7 ff ff       	jmp    80106eef <alltraps>

80107740 <vector54>:
80107740:	6a 00                	push   $0x0
80107742:	6a 36                	push   $0x36
80107744:	e9 a6 f7 ff ff       	jmp    80106eef <alltraps>

80107749 <vector55>:
80107749:	6a 00                	push   $0x0
8010774b:	6a 37                	push   $0x37
8010774d:	e9 9d f7 ff ff       	jmp    80106eef <alltraps>

80107752 <vector56>:
80107752:	6a 00                	push   $0x0
80107754:	6a 38                	push   $0x38
80107756:	e9 94 f7 ff ff       	jmp    80106eef <alltraps>

8010775b <vector57>:
8010775b:	6a 00                	push   $0x0
8010775d:	6a 39                	push   $0x39
8010775f:	e9 8b f7 ff ff       	jmp    80106eef <alltraps>

80107764 <vector58>:
80107764:	6a 00                	push   $0x0
80107766:	6a 3a                	push   $0x3a
80107768:	e9 82 f7 ff ff       	jmp    80106eef <alltraps>

8010776d <vector59>:
8010776d:	6a 00                	push   $0x0
8010776f:	6a 3b                	push   $0x3b
80107771:	e9 79 f7 ff ff       	jmp    80106eef <alltraps>

80107776 <vector60>:
80107776:	6a 00                	push   $0x0
80107778:	6a 3c                	push   $0x3c
8010777a:	e9 70 f7 ff ff       	jmp    80106eef <alltraps>

8010777f <vector61>:
8010777f:	6a 00                	push   $0x0
80107781:	6a 3d                	push   $0x3d
80107783:	e9 67 f7 ff ff       	jmp    80106eef <alltraps>

80107788 <vector62>:
80107788:	6a 00                	push   $0x0
8010778a:	6a 3e                	push   $0x3e
8010778c:	e9 5e f7 ff ff       	jmp    80106eef <alltraps>

80107791 <vector63>:
80107791:	6a 00                	push   $0x0
80107793:	6a 3f                	push   $0x3f
80107795:	e9 55 f7 ff ff       	jmp    80106eef <alltraps>

8010779a <vector64>:
8010779a:	6a 00                	push   $0x0
8010779c:	6a 40                	push   $0x40
8010779e:	e9 4c f7 ff ff       	jmp    80106eef <alltraps>

801077a3 <vector65>:
801077a3:	6a 00                	push   $0x0
801077a5:	6a 41                	push   $0x41
801077a7:	e9 43 f7 ff ff       	jmp    80106eef <alltraps>

801077ac <vector66>:
801077ac:	6a 00                	push   $0x0
801077ae:	6a 42                	push   $0x42
801077b0:	e9 3a f7 ff ff       	jmp    80106eef <alltraps>

801077b5 <vector67>:
801077b5:	6a 00                	push   $0x0
801077b7:	6a 43                	push   $0x43
801077b9:	e9 31 f7 ff ff       	jmp    80106eef <alltraps>

801077be <vector68>:
801077be:	6a 00                	push   $0x0
801077c0:	6a 44                	push   $0x44
801077c2:	e9 28 f7 ff ff       	jmp    80106eef <alltraps>

801077c7 <vector69>:
801077c7:	6a 00                	push   $0x0
801077c9:	6a 45                	push   $0x45
801077cb:	e9 1f f7 ff ff       	jmp    80106eef <alltraps>

801077d0 <vector70>:
801077d0:	6a 00                	push   $0x0
801077d2:	6a 46                	push   $0x46
801077d4:	e9 16 f7 ff ff       	jmp    80106eef <alltraps>

801077d9 <vector71>:
801077d9:	6a 00                	push   $0x0
801077db:	6a 47                	push   $0x47
801077dd:	e9 0d f7 ff ff       	jmp    80106eef <alltraps>

801077e2 <vector72>:
801077e2:	6a 00                	push   $0x0
801077e4:	6a 48                	push   $0x48
801077e6:	e9 04 f7 ff ff       	jmp    80106eef <alltraps>

801077eb <vector73>:
801077eb:	6a 00                	push   $0x0
801077ed:	6a 49                	push   $0x49
801077ef:	e9 fb f6 ff ff       	jmp    80106eef <alltraps>

801077f4 <vector74>:
801077f4:	6a 00                	push   $0x0
801077f6:	6a 4a                	push   $0x4a
801077f8:	e9 f2 f6 ff ff       	jmp    80106eef <alltraps>

801077fd <vector75>:
801077fd:	6a 00                	push   $0x0
801077ff:	6a 4b                	push   $0x4b
80107801:	e9 e9 f6 ff ff       	jmp    80106eef <alltraps>

80107806 <vector76>:
80107806:	6a 00                	push   $0x0
80107808:	6a 4c                	push   $0x4c
8010780a:	e9 e0 f6 ff ff       	jmp    80106eef <alltraps>

8010780f <vector77>:
8010780f:	6a 00                	push   $0x0
80107811:	6a 4d                	push   $0x4d
80107813:	e9 d7 f6 ff ff       	jmp    80106eef <alltraps>

80107818 <vector78>:
80107818:	6a 00                	push   $0x0
8010781a:	6a 4e                	push   $0x4e
8010781c:	e9 ce f6 ff ff       	jmp    80106eef <alltraps>

80107821 <vector79>:
80107821:	6a 00                	push   $0x0
80107823:	6a 4f                	push   $0x4f
80107825:	e9 c5 f6 ff ff       	jmp    80106eef <alltraps>

8010782a <vector80>:
8010782a:	6a 00                	push   $0x0
8010782c:	6a 50                	push   $0x50
8010782e:	e9 bc f6 ff ff       	jmp    80106eef <alltraps>

80107833 <vector81>:
80107833:	6a 00                	push   $0x0
80107835:	6a 51                	push   $0x51
80107837:	e9 b3 f6 ff ff       	jmp    80106eef <alltraps>

8010783c <vector82>:
8010783c:	6a 00                	push   $0x0
8010783e:	6a 52                	push   $0x52
80107840:	e9 aa f6 ff ff       	jmp    80106eef <alltraps>

80107845 <vector83>:
80107845:	6a 00                	push   $0x0
80107847:	6a 53                	push   $0x53
80107849:	e9 a1 f6 ff ff       	jmp    80106eef <alltraps>

8010784e <vector84>:
8010784e:	6a 00                	push   $0x0
80107850:	6a 54                	push   $0x54
80107852:	e9 98 f6 ff ff       	jmp    80106eef <alltraps>

80107857 <vector85>:
80107857:	6a 00                	push   $0x0
80107859:	6a 55                	push   $0x55
8010785b:	e9 8f f6 ff ff       	jmp    80106eef <alltraps>

80107860 <vector86>:
80107860:	6a 00                	push   $0x0
80107862:	6a 56                	push   $0x56
80107864:	e9 86 f6 ff ff       	jmp    80106eef <alltraps>

80107869 <vector87>:
80107869:	6a 00                	push   $0x0
8010786b:	6a 57                	push   $0x57
8010786d:	e9 7d f6 ff ff       	jmp    80106eef <alltraps>

80107872 <vector88>:
80107872:	6a 00                	push   $0x0
80107874:	6a 58                	push   $0x58
80107876:	e9 74 f6 ff ff       	jmp    80106eef <alltraps>

8010787b <vector89>:
8010787b:	6a 00                	push   $0x0
8010787d:	6a 59                	push   $0x59
8010787f:	e9 6b f6 ff ff       	jmp    80106eef <alltraps>

80107884 <vector90>:
80107884:	6a 00                	push   $0x0
80107886:	6a 5a                	push   $0x5a
80107888:	e9 62 f6 ff ff       	jmp    80106eef <alltraps>

8010788d <vector91>:
8010788d:	6a 00                	push   $0x0
8010788f:	6a 5b                	push   $0x5b
80107891:	e9 59 f6 ff ff       	jmp    80106eef <alltraps>

80107896 <vector92>:
80107896:	6a 00                	push   $0x0
80107898:	6a 5c                	push   $0x5c
8010789a:	e9 50 f6 ff ff       	jmp    80106eef <alltraps>

8010789f <vector93>:
8010789f:	6a 00                	push   $0x0
801078a1:	6a 5d                	push   $0x5d
801078a3:	e9 47 f6 ff ff       	jmp    80106eef <alltraps>

801078a8 <vector94>:
801078a8:	6a 00                	push   $0x0
801078aa:	6a 5e                	push   $0x5e
801078ac:	e9 3e f6 ff ff       	jmp    80106eef <alltraps>

801078b1 <vector95>:
801078b1:	6a 00                	push   $0x0
801078b3:	6a 5f                	push   $0x5f
801078b5:	e9 35 f6 ff ff       	jmp    80106eef <alltraps>

801078ba <vector96>:
801078ba:	6a 00                	push   $0x0
801078bc:	6a 60                	push   $0x60
801078be:	e9 2c f6 ff ff       	jmp    80106eef <alltraps>

801078c3 <vector97>:
801078c3:	6a 00                	push   $0x0
801078c5:	6a 61                	push   $0x61
801078c7:	e9 23 f6 ff ff       	jmp    80106eef <alltraps>

801078cc <vector98>:
801078cc:	6a 00                	push   $0x0
801078ce:	6a 62                	push   $0x62
801078d0:	e9 1a f6 ff ff       	jmp    80106eef <alltraps>

801078d5 <vector99>:
801078d5:	6a 00                	push   $0x0
801078d7:	6a 63                	push   $0x63
801078d9:	e9 11 f6 ff ff       	jmp    80106eef <alltraps>

801078de <vector100>:
801078de:	6a 00                	push   $0x0
801078e0:	6a 64                	push   $0x64
801078e2:	e9 08 f6 ff ff       	jmp    80106eef <alltraps>

801078e7 <vector101>:
801078e7:	6a 00                	push   $0x0
801078e9:	6a 65                	push   $0x65
801078eb:	e9 ff f5 ff ff       	jmp    80106eef <alltraps>

801078f0 <vector102>:
801078f0:	6a 00                	push   $0x0
801078f2:	6a 66                	push   $0x66
801078f4:	e9 f6 f5 ff ff       	jmp    80106eef <alltraps>

801078f9 <vector103>:
801078f9:	6a 00                	push   $0x0
801078fb:	6a 67                	push   $0x67
801078fd:	e9 ed f5 ff ff       	jmp    80106eef <alltraps>

80107902 <vector104>:
80107902:	6a 00                	push   $0x0
80107904:	6a 68                	push   $0x68
80107906:	e9 e4 f5 ff ff       	jmp    80106eef <alltraps>

8010790b <vector105>:
8010790b:	6a 00                	push   $0x0
8010790d:	6a 69                	push   $0x69
8010790f:	e9 db f5 ff ff       	jmp    80106eef <alltraps>

80107914 <vector106>:
80107914:	6a 00                	push   $0x0
80107916:	6a 6a                	push   $0x6a
80107918:	e9 d2 f5 ff ff       	jmp    80106eef <alltraps>

8010791d <vector107>:
8010791d:	6a 00                	push   $0x0
8010791f:	6a 6b                	push   $0x6b
80107921:	e9 c9 f5 ff ff       	jmp    80106eef <alltraps>

80107926 <vector108>:
80107926:	6a 00                	push   $0x0
80107928:	6a 6c                	push   $0x6c
8010792a:	e9 c0 f5 ff ff       	jmp    80106eef <alltraps>

8010792f <vector109>:
8010792f:	6a 00                	push   $0x0
80107931:	6a 6d                	push   $0x6d
80107933:	e9 b7 f5 ff ff       	jmp    80106eef <alltraps>

80107938 <vector110>:
80107938:	6a 00                	push   $0x0
8010793a:	6a 6e                	push   $0x6e
8010793c:	e9 ae f5 ff ff       	jmp    80106eef <alltraps>

80107941 <vector111>:
80107941:	6a 00                	push   $0x0
80107943:	6a 6f                	push   $0x6f
80107945:	e9 a5 f5 ff ff       	jmp    80106eef <alltraps>

8010794a <vector112>:
8010794a:	6a 00                	push   $0x0
8010794c:	6a 70                	push   $0x70
8010794e:	e9 9c f5 ff ff       	jmp    80106eef <alltraps>

80107953 <vector113>:
80107953:	6a 00                	push   $0x0
80107955:	6a 71                	push   $0x71
80107957:	e9 93 f5 ff ff       	jmp    80106eef <alltraps>

8010795c <vector114>:
8010795c:	6a 00                	push   $0x0
8010795e:	6a 72                	push   $0x72
80107960:	e9 8a f5 ff ff       	jmp    80106eef <alltraps>

80107965 <vector115>:
80107965:	6a 00                	push   $0x0
80107967:	6a 73                	push   $0x73
80107969:	e9 81 f5 ff ff       	jmp    80106eef <alltraps>

8010796e <vector116>:
8010796e:	6a 00                	push   $0x0
80107970:	6a 74                	push   $0x74
80107972:	e9 78 f5 ff ff       	jmp    80106eef <alltraps>

80107977 <vector117>:
80107977:	6a 00                	push   $0x0
80107979:	6a 75                	push   $0x75
8010797b:	e9 6f f5 ff ff       	jmp    80106eef <alltraps>

80107980 <vector118>:
80107980:	6a 00                	push   $0x0
80107982:	6a 76                	push   $0x76
80107984:	e9 66 f5 ff ff       	jmp    80106eef <alltraps>

80107989 <vector119>:
80107989:	6a 00                	push   $0x0
8010798b:	6a 77                	push   $0x77
8010798d:	e9 5d f5 ff ff       	jmp    80106eef <alltraps>

80107992 <vector120>:
80107992:	6a 00                	push   $0x0
80107994:	6a 78                	push   $0x78
80107996:	e9 54 f5 ff ff       	jmp    80106eef <alltraps>

8010799b <vector121>:
8010799b:	6a 00                	push   $0x0
8010799d:	6a 79                	push   $0x79
8010799f:	e9 4b f5 ff ff       	jmp    80106eef <alltraps>

801079a4 <vector122>:
801079a4:	6a 00                	push   $0x0
801079a6:	6a 7a                	push   $0x7a
801079a8:	e9 42 f5 ff ff       	jmp    80106eef <alltraps>

801079ad <vector123>:
801079ad:	6a 00                	push   $0x0
801079af:	6a 7b                	push   $0x7b
801079b1:	e9 39 f5 ff ff       	jmp    80106eef <alltraps>

801079b6 <vector124>:
801079b6:	6a 00                	push   $0x0
801079b8:	6a 7c                	push   $0x7c
801079ba:	e9 30 f5 ff ff       	jmp    80106eef <alltraps>

801079bf <vector125>:
801079bf:	6a 00                	push   $0x0
801079c1:	6a 7d                	push   $0x7d
801079c3:	e9 27 f5 ff ff       	jmp    80106eef <alltraps>

801079c8 <vector126>:
801079c8:	6a 00                	push   $0x0
801079ca:	6a 7e                	push   $0x7e
801079cc:	e9 1e f5 ff ff       	jmp    80106eef <alltraps>

801079d1 <vector127>:
801079d1:	6a 00                	push   $0x0
801079d3:	6a 7f                	push   $0x7f
801079d5:	e9 15 f5 ff ff       	jmp    80106eef <alltraps>

801079da <vector128>:
801079da:	6a 00                	push   $0x0
801079dc:	68 80 00 00 00       	push   $0x80
801079e1:	e9 09 f5 ff ff       	jmp    80106eef <alltraps>

801079e6 <vector129>:
801079e6:	6a 00                	push   $0x0
801079e8:	68 81 00 00 00       	push   $0x81
801079ed:	e9 fd f4 ff ff       	jmp    80106eef <alltraps>

801079f2 <vector130>:
801079f2:	6a 00                	push   $0x0
801079f4:	68 82 00 00 00       	push   $0x82
801079f9:	e9 f1 f4 ff ff       	jmp    80106eef <alltraps>

801079fe <vector131>:
801079fe:	6a 00                	push   $0x0
80107a00:	68 83 00 00 00       	push   $0x83
80107a05:	e9 e5 f4 ff ff       	jmp    80106eef <alltraps>

80107a0a <vector132>:
80107a0a:	6a 00                	push   $0x0
80107a0c:	68 84 00 00 00       	push   $0x84
80107a11:	e9 d9 f4 ff ff       	jmp    80106eef <alltraps>

80107a16 <vector133>:
80107a16:	6a 00                	push   $0x0
80107a18:	68 85 00 00 00       	push   $0x85
80107a1d:	e9 cd f4 ff ff       	jmp    80106eef <alltraps>

80107a22 <vector134>:
80107a22:	6a 00                	push   $0x0
80107a24:	68 86 00 00 00       	push   $0x86
80107a29:	e9 c1 f4 ff ff       	jmp    80106eef <alltraps>

80107a2e <vector135>:
80107a2e:	6a 00                	push   $0x0
80107a30:	68 87 00 00 00       	push   $0x87
80107a35:	e9 b5 f4 ff ff       	jmp    80106eef <alltraps>

80107a3a <vector136>:
80107a3a:	6a 00                	push   $0x0
80107a3c:	68 88 00 00 00       	push   $0x88
80107a41:	e9 a9 f4 ff ff       	jmp    80106eef <alltraps>

80107a46 <vector137>:
80107a46:	6a 00                	push   $0x0
80107a48:	68 89 00 00 00       	push   $0x89
80107a4d:	e9 9d f4 ff ff       	jmp    80106eef <alltraps>

80107a52 <vector138>:
80107a52:	6a 00                	push   $0x0
80107a54:	68 8a 00 00 00       	push   $0x8a
80107a59:	e9 91 f4 ff ff       	jmp    80106eef <alltraps>

80107a5e <vector139>:
80107a5e:	6a 00                	push   $0x0
80107a60:	68 8b 00 00 00       	push   $0x8b
80107a65:	e9 85 f4 ff ff       	jmp    80106eef <alltraps>

80107a6a <vector140>:
80107a6a:	6a 00                	push   $0x0
80107a6c:	68 8c 00 00 00       	push   $0x8c
80107a71:	e9 79 f4 ff ff       	jmp    80106eef <alltraps>

80107a76 <vector141>:
80107a76:	6a 00                	push   $0x0
80107a78:	68 8d 00 00 00       	push   $0x8d
80107a7d:	e9 6d f4 ff ff       	jmp    80106eef <alltraps>

80107a82 <vector142>:
80107a82:	6a 00                	push   $0x0
80107a84:	68 8e 00 00 00       	push   $0x8e
80107a89:	e9 61 f4 ff ff       	jmp    80106eef <alltraps>

80107a8e <vector143>:
80107a8e:	6a 00                	push   $0x0
80107a90:	68 8f 00 00 00       	push   $0x8f
80107a95:	e9 55 f4 ff ff       	jmp    80106eef <alltraps>

80107a9a <vector144>:
80107a9a:	6a 00                	push   $0x0
80107a9c:	68 90 00 00 00       	push   $0x90
80107aa1:	e9 49 f4 ff ff       	jmp    80106eef <alltraps>

80107aa6 <vector145>:
80107aa6:	6a 00                	push   $0x0
80107aa8:	68 91 00 00 00       	push   $0x91
80107aad:	e9 3d f4 ff ff       	jmp    80106eef <alltraps>

80107ab2 <vector146>:
80107ab2:	6a 00                	push   $0x0
80107ab4:	68 92 00 00 00       	push   $0x92
80107ab9:	e9 31 f4 ff ff       	jmp    80106eef <alltraps>

80107abe <vector147>:
80107abe:	6a 00                	push   $0x0
80107ac0:	68 93 00 00 00       	push   $0x93
80107ac5:	e9 25 f4 ff ff       	jmp    80106eef <alltraps>

80107aca <vector148>:
80107aca:	6a 00                	push   $0x0
80107acc:	68 94 00 00 00       	push   $0x94
80107ad1:	e9 19 f4 ff ff       	jmp    80106eef <alltraps>

80107ad6 <vector149>:
80107ad6:	6a 00                	push   $0x0
80107ad8:	68 95 00 00 00       	push   $0x95
80107add:	e9 0d f4 ff ff       	jmp    80106eef <alltraps>

80107ae2 <vector150>:
80107ae2:	6a 00                	push   $0x0
80107ae4:	68 96 00 00 00       	push   $0x96
80107ae9:	e9 01 f4 ff ff       	jmp    80106eef <alltraps>

80107aee <vector151>:
80107aee:	6a 00                	push   $0x0
80107af0:	68 97 00 00 00       	push   $0x97
80107af5:	e9 f5 f3 ff ff       	jmp    80106eef <alltraps>

80107afa <vector152>:
80107afa:	6a 00                	push   $0x0
80107afc:	68 98 00 00 00       	push   $0x98
80107b01:	e9 e9 f3 ff ff       	jmp    80106eef <alltraps>

80107b06 <vector153>:
80107b06:	6a 00                	push   $0x0
80107b08:	68 99 00 00 00       	push   $0x99
80107b0d:	e9 dd f3 ff ff       	jmp    80106eef <alltraps>

80107b12 <vector154>:
80107b12:	6a 00                	push   $0x0
80107b14:	68 9a 00 00 00       	push   $0x9a
80107b19:	e9 d1 f3 ff ff       	jmp    80106eef <alltraps>

80107b1e <vector155>:
80107b1e:	6a 00                	push   $0x0
80107b20:	68 9b 00 00 00       	push   $0x9b
80107b25:	e9 c5 f3 ff ff       	jmp    80106eef <alltraps>

80107b2a <vector156>:
80107b2a:	6a 00                	push   $0x0
80107b2c:	68 9c 00 00 00       	push   $0x9c
80107b31:	e9 b9 f3 ff ff       	jmp    80106eef <alltraps>

80107b36 <vector157>:
80107b36:	6a 00                	push   $0x0
80107b38:	68 9d 00 00 00       	push   $0x9d
80107b3d:	e9 ad f3 ff ff       	jmp    80106eef <alltraps>

80107b42 <vector158>:
80107b42:	6a 00                	push   $0x0
80107b44:	68 9e 00 00 00       	push   $0x9e
80107b49:	e9 a1 f3 ff ff       	jmp    80106eef <alltraps>

80107b4e <vector159>:
80107b4e:	6a 00                	push   $0x0
80107b50:	68 9f 00 00 00       	push   $0x9f
80107b55:	e9 95 f3 ff ff       	jmp    80106eef <alltraps>

80107b5a <vector160>:
80107b5a:	6a 00                	push   $0x0
80107b5c:	68 a0 00 00 00       	push   $0xa0
80107b61:	e9 89 f3 ff ff       	jmp    80106eef <alltraps>

80107b66 <vector161>:
80107b66:	6a 00                	push   $0x0
80107b68:	68 a1 00 00 00       	push   $0xa1
80107b6d:	e9 7d f3 ff ff       	jmp    80106eef <alltraps>

80107b72 <vector162>:
80107b72:	6a 00                	push   $0x0
80107b74:	68 a2 00 00 00       	push   $0xa2
80107b79:	e9 71 f3 ff ff       	jmp    80106eef <alltraps>

80107b7e <vector163>:
80107b7e:	6a 00                	push   $0x0
80107b80:	68 a3 00 00 00       	push   $0xa3
80107b85:	e9 65 f3 ff ff       	jmp    80106eef <alltraps>

80107b8a <vector164>:
80107b8a:	6a 00                	push   $0x0
80107b8c:	68 a4 00 00 00       	push   $0xa4
80107b91:	e9 59 f3 ff ff       	jmp    80106eef <alltraps>

80107b96 <vector165>:
80107b96:	6a 00                	push   $0x0
80107b98:	68 a5 00 00 00       	push   $0xa5
80107b9d:	e9 4d f3 ff ff       	jmp    80106eef <alltraps>

80107ba2 <vector166>:
80107ba2:	6a 00                	push   $0x0
80107ba4:	68 a6 00 00 00       	push   $0xa6
80107ba9:	e9 41 f3 ff ff       	jmp    80106eef <alltraps>

80107bae <vector167>:
80107bae:	6a 00                	push   $0x0
80107bb0:	68 a7 00 00 00       	push   $0xa7
80107bb5:	e9 35 f3 ff ff       	jmp    80106eef <alltraps>

80107bba <vector168>:
80107bba:	6a 00                	push   $0x0
80107bbc:	68 a8 00 00 00       	push   $0xa8
80107bc1:	e9 29 f3 ff ff       	jmp    80106eef <alltraps>

80107bc6 <vector169>:
80107bc6:	6a 00                	push   $0x0
80107bc8:	68 a9 00 00 00       	push   $0xa9
80107bcd:	e9 1d f3 ff ff       	jmp    80106eef <alltraps>

80107bd2 <vector170>:
80107bd2:	6a 00                	push   $0x0
80107bd4:	68 aa 00 00 00       	push   $0xaa
80107bd9:	e9 11 f3 ff ff       	jmp    80106eef <alltraps>

80107bde <vector171>:
80107bde:	6a 00                	push   $0x0
80107be0:	68 ab 00 00 00       	push   $0xab
80107be5:	e9 05 f3 ff ff       	jmp    80106eef <alltraps>

80107bea <vector172>:
80107bea:	6a 00                	push   $0x0
80107bec:	68 ac 00 00 00       	push   $0xac
80107bf1:	e9 f9 f2 ff ff       	jmp    80106eef <alltraps>

80107bf6 <vector173>:
80107bf6:	6a 00                	push   $0x0
80107bf8:	68 ad 00 00 00       	push   $0xad
80107bfd:	e9 ed f2 ff ff       	jmp    80106eef <alltraps>

80107c02 <vector174>:
80107c02:	6a 00                	push   $0x0
80107c04:	68 ae 00 00 00       	push   $0xae
80107c09:	e9 e1 f2 ff ff       	jmp    80106eef <alltraps>

80107c0e <vector175>:
80107c0e:	6a 00                	push   $0x0
80107c10:	68 af 00 00 00       	push   $0xaf
80107c15:	e9 d5 f2 ff ff       	jmp    80106eef <alltraps>

80107c1a <vector176>:
80107c1a:	6a 00                	push   $0x0
80107c1c:	68 b0 00 00 00       	push   $0xb0
80107c21:	e9 c9 f2 ff ff       	jmp    80106eef <alltraps>

80107c26 <vector177>:
80107c26:	6a 00                	push   $0x0
80107c28:	68 b1 00 00 00       	push   $0xb1
80107c2d:	e9 bd f2 ff ff       	jmp    80106eef <alltraps>

80107c32 <vector178>:
80107c32:	6a 00                	push   $0x0
80107c34:	68 b2 00 00 00       	push   $0xb2
80107c39:	e9 b1 f2 ff ff       	jmp    80106eef <alltraps>

80107c3e <vector179>:
80107c3e:	6a 00                	push   $0x0
80107c40:	68 b3 00 00 00       	push   $0xb3
80107c45:	e9 a5 f2 ff ff       	jmp    80106eef <alltraps>

80107c4a <vector180>:
80107c4a:	6a 00                	push   $0x0
80107c4c:	68 b4 00 00 00       	push   $0xb4
80107c51:	e9 99 f2 ff ff       	jmp    80106eef <alltraps>

80107c56 <vector181>:
80107c56:	6a 00                	push   $0x0
80107c58:	68 b5 00 00 00       	push   $0xb5
80107c5d:	e9 8d f2 ff ff       	jmp    80106eef <alltraps>

80107c62 <vector182>:
80107c62:	6a 00                	push   $0x0
80107c64:	68 b6 00 00 00       	push   $0xb6
80107c69:	e9 81 f2 ff ff       	jmp    80106eef <alltraps>

80107c6e <vector183>:
80107c6e:	6a 00                	push   $0x0
80107c70:	68 b7 00 00 00       	push   $0xb7
80107c75:	e9 75 f2 ff ff       	jmp    80106eef <alltraps>

80107c7a <vector184>:
80107c7a:	6a 00                	push   $0x0
80107c7c:	68 b8 00 00 00       	push   $0xb8
80107c81:	e9 69 f2 ff ff       	jmp    80106eef <alltraps>

80107c86 <vector185>:
80107c86:	6a 00                	push   $0x0
80107c88:	68 b9 00 00 00       	push   $0xb9
80107c8d:	e9 5d f2 ff ff       	jmp    80106eef <alltraps>

80107c92 <vector186>:
80107c92:	6a 00                	push   $0x0
80107c94:	68 ba 00 00 00       	push   $0xba
80107c99:	e9 51 f2 ff ff       	jmp    80106eef <alltraps>

80107c9e <vector187>:
80107c9e:	6a 00                	push   $0x0
80107ca0:	68 bb 00 00 00       	push   $0xbb
80107ca5:	e9 45 f2 ff ff       	jmp    80106eef <alltraps>

80107caa <vector188>:
80107caa:	6a 00                	push   $0x0
80107cac:	68 bc 00 00 00       	push   $0xbc
80107cb1:	e9 39 f2 ff ff       	jmp    80106eef <alltraps>

80107cb6 <vector189>:
80107cb6:	6a 00                	push   $0x0
80107cb8:	68 bd 00 00 00       	push   $0xbd
80107cbd:	e9 2d f2 ff ff       	jmp    80106eef <alltraps>

80107cc2 <vector190>:
80107cc2:	6a 00                	push   $0x0
80107cc4:	68 be 00 00 00       	push   $0xbe
80107cc9:	e9 21 f2 ff ff       	jmp    80106eef <alltraps>

80107cce <vector191>:
80107cce:	6a 00                	push   $0x0
80107cd0:	68 bf 00 00 00       	push   $0xbf
80107cd5:	e9 15 f2 ff ff       	jmp    80106eef <alltraps>

80107cda <vector192>:
80107cda:	6a 00                	push   $0x0
80107cdc:	68 c0 00 00 00       	push   $0xc0
80107ce1:	e9 09 f2 ff ff       	jmp    80106eef <alltraps>

80107ce6 <vector193>:
80107ce6:	6a 00                	push   $0x0
80107ce8:	68 c1 00 00 00       	push   $0xc1
80107ced:	e9 fd f1 ff ff       	jmp    80106eef <alltraps>

80107cf2 <vector194>:
80107cf2:	6a 00                	push   $0x0
80107cf4:	68 c2 00 00 00       	push   $0xc2
80107cf9:	e9 f1 f1 ff ff       	jmp    80106eef <alltraps>

80107cfe <vector195>:
80107cfe:	6a 00                	push   $0x0
80107d00:	68 c3 00 00 00       	push   $0xc3
80107d05:	e9 e5 f1 ff ff       	jmp    80106eef <alltraps>

80107d0a <vector196>:
80107d0a:	6a 00                	push   $0x0
80107d0c:	68 c4 00 00 00       	push   $0xc4
80107d11:	e9 d9 f1 ff ff       	jmp    80106eef <alltraps>

80107d16 <vector197>:
80107d16:	6a 00                	push   $0x0
80107d18:	68 c5 00 00 00       	push   $0xc5
80107d1d:	e9 cd f1 ff ff       	jmp    80106eef <alltraps>

80107d22 <vector198>:
80107d22:	6a 00                	push   $0x0
80107d24:	68 c6 00 00 00       	push   $0xc6
80107d29:	e9 c1 f1 ff ff       	jmp    80106eef <alltraps>

80107d2e <vector199>:
80107d2e:	6a 00                	push   $0x0
80107d30:	68 c7 00 00 00       	push   $0xc7
80107d35:	e9 b5 f1 ff ff       	jmp    80106eef <alltraps>

80107d3a <vector200>:
80107d3a:	6a 00                	push   $0x0
80107d3c:	68 c8 00 00 00       	push   $0xc8
80107d41:	e9 a9 f1 ff ff       	jmp    80106eef <alltraps>

80107d46 <vector201>:
80107d46:	6a 00                	push   $0x0
80107d48:	68 c9 00 00 00       	push   $0xc9
80107d4d:	e9 9d f1 ff ff       	jmp    80106eef <alltraps>

80107d52 <vector202>:
80107d52:	6a 00                	push   $0x0
80107d54:	68 ca 00 00 00       	push   $0xca
80107d59:	e9 91 f1 ff ff       	jmp    80106eef <alltraps>

80107d5e <vector203>:
80107d5e:	6a 00                	push   $0x0
80107d60:	68 cb 00 00 00       	push   $0xcb
80107d65:	e9 85 f1 ff ff       	jmp    80106eef <alltraps>

80107d6a <vector204>:
80107d6a:	6a 00                	push   $0x0
80107d6c:	68 cc 00 00 00       	push   $0xcc
80107d71:	e9 79 f1 ff ff       	jmp    80106eef <alltraps>

80107d76 <vector205>:
80107d76:	6a 00                	push   $0x0
80107d78:	68 cd 00 00 00       	push   $0xcd
80107d7d:	e9 6d f1 ff ff       	jmp    80106eef <alltraps>

80107d82 <vector206>:
80107d82:	6a 00                	push   $0x0
80107d84:	68 ce 00 00 00       	push   $0xce
80107d89:	e9 61 f1 ff ff       	jmp    80106eef <alltraps>

80107d8e <vector207>:
80107d8e:	6a 00                	push   $0x0
80107d90:	68 cf 00 00 00       	push   $0xcf
80107d95:	e9 55 f1 ff ff       	jmp    80106eef <alltraps>

80107d9a <vector208>:
80107d9a:	6a 00                	push   $0x0
80107d9c:	68 d0 00 00 00       	push   $0xd0
80107da1:	e9 49 f1 ff ff       	jmp    80106eef <alltraps>

80107da6 <vector209>:
80107da6:	6a 00                	push   $0x0
80107da8:	68 d1 00 00 00       	push   $0xd1
80107dad:	e9 3d f1 ff ff       	jmp    80106eef <alltraps>

80107db2 <vector210>:
80107db2:	6a 00                	push   $0x0
80107db4:	68 d2 00 00 00       	push   $0xd2
80107db9:	e9 31 f1 ff ff       	jmp    80106eef <alltraps>

80107dbe <vector211>:
80107dbe:	6a 00                	push   $0x0
80107dc0:	68 d3 00 00 00       	push   $0xd3
80107dc5:	e9 25 f1 ff ff       	jmp    80106eef <alltraps>

80107dca <vector212>:
80107dca:	6a 00                	push   $0x0
80107dcc:	68 d4 00 00 00       	push   $0xd4
80107dd1:	e9 19 f1 ff ff       	jmp    80106eef <alltraps>

80107dd6 <vector213>:
80107dd6:	6a 00                	push   $0x0
80107dd8:	68 d5 00 00 00       	push   $0xd5
80107ddd:	e9 0d f1 ff ff       	jmp    80106eef <alltraps>

80107de2 <vector214>:
80107de2:	6a 00                	push   $0x0
80107de4:	68 d6 00 00 00       	push   $0xd6
80107de9:	e9 01 f1 ff ff       	jmp    80106eef <alltraps>

80107dee <vector215>:
80107dee:	6a 00                	push   $0x0
80107df0:	68 d7 00 00 00       	push   $0xd7
80107df5:	e9 f5 f0 ff ff       	jmp    80106eef <alltraps>

80107dfa <vector216>:
80107dfa:	6a 00                	push   $0x0
80107dfc:	68 d8 00 00 00       	push   $0xd8
80107e01:	e9 e9 f0 ff ff       	jmp    80106eef <alltraps>

80107e06 <vector217>:
80107e06:	6a 00                	push   $0x0
80107e08:	68 d9 00 00 00       	push   $0xd9
80107e0d:	e9 dd f0 ff ff       	jmp    80106eef <alltraps>

80107e12 <vector218>:
80107e12:	6a 00                	push   $0x0
80107e14:	68 da 00 00 00       	push   $0xda
80107e19:	e9 d1 f0 ff ff       	jmp    80106eef <alltraps>

80107e1e <vector219>:
80107e1e:	6a 00                	push   $0x0
80107e20:	68 db 00 00 00       	push   $0xdb
80107e25:	e9 c5 f0 ff ff       	jmp    80106eef <alltraps>

80107e2a <vector220>:
80107e2a:	6a 00                	push   $0x0
80107e2c:	68 dc 00 00 00       	push   $0xdc
80107e31:	e9 b9 f0 ff ff       	jmp    80106eef <alltraps>

80107e36 <vector221>:
80107e36:	6a 00                	push   $0x0
80107e38:	68 dd 00 00 00       	push   $0xdd
80107e3d:	e9 ad f0 ff ff       	jmp    80106eef <alltraps>

80107e42 <vector222>:
80107e42:	6a 00                	push   $0x0
80107e44:	68 de 00 00 00       	push   $0xde
80107e49:	e9 a1 f0 ff ff       	jmp    80106eef <alltraps>

80107e4e <vector223>:
80107e4e:	6a 00                	push   $0x0
80107e50:	68 df 00 00 00       	push   $0xdf
80107e55:	e9 95 f0 ff ff       	jmp    80106eef <alltraps>

80107e5a <vector224>:
80107e5a:	6a 00                	push   $0x0
80107e5c:	68 e0 00 00 00       	push   $0xe0
80107e61:	e9 89 f0 ff ff       	jmp    80106eef <alltraps>

80107e66 <vector225>:
80107e66:	6a 00                	push   $0x0
80107e68:	68 e1 00 00 00       	push   $0xe1
80107e6d:	e9 7d f0 ff ff       	jmp    80106eef <alltraps>

80107e72 <vector226>:
80107e72:	6a 00                	push   $0x0
80107e74:	68 e2 00 00 00       	push   $0xe2
80107e79:	e9 71 f0 ff ff       	jmp    80106eef <alltraps>

80107e7e <vector227>:
80107e7e:	6a 00                	push   $0x0
80107e80:	68 e3 00 00 00       	push   $0xe3
80107e85:	e9 65 f0 ff ff       	jmp    80106eef <alltraps>

80107e8a <vector228>:
80107e8a:	6a 00                	push   $0x0
80107e8c:	68 e4 00 00 00       	push   $0xe4
80107e91:	e9 59 f0 ff ff       	jmp    80106eef <alltraps>

80107e96 <vector229>:
80107e96:	6a 00                	push   $0x0
80107e98:	68 e5 00 00 00       	push   $0xe5
80107e9d:	e9 4d f0 ff ff       	jmp    80106eef <alltraps>

80107ea2 <vector230>:
80107ea2:	6a 00                	push   $0x0
80107ea4:	68 e6 00 00 00       	push   $0xe6
80107ea9:	e9 41 f0 ff ff       	jmp    80106eef <alltraps>

80107eae <vector231>:
80107eae:	6a 00                	push   $0x0
80107eb0:	68 e7 00 00 00       	push   $0xe7
80107eb5:	e9 35 f0 ff ff       	jmp    80106eef <alltraps>

80107eba <vector232>:
80107eba:	6a 00                	push   $0x0
80107ebc:	68 e8 00 00 00       	push   $0xe8
80107ec1:	e9 29 f0 ff ff       	jmp    80106eef <alltraps>

80107ec6 <vector233>:
80107ec6:	6a 00                	push   $0x0
80107ec8:	68 e9 00 00 00       	push   $0xe9
80107ecd:	e9 1d f0 ff ff       	jmp    80106eef <alltraps>

80107ed2 <vector234>:
80107ed2:	6a 00                	push   $0x0
80107ed4:	68 ea 00 00 00       	push   $0xea
80107ed9:	e9 11 f0 ff ff       	jmp    80106eef <alltraps>

80107ede <vector235>:
80107ede:	6a 00                	push   $0x0
80107ee0:	68 eb 00 00 00       	push   $0xeb
80107ee5:	e9 05 f0 ff ff       	jmp    80106eef <alltraps>

80107eea <vector236>:
80107eea:	6a 00                	push   $0x0
80107eec:	68 ec 00 00 00       	push   $0xec
80107ef1:	e9 f9 ef ff ff       	jmp    80106eef <alltraps>

80107ef6 <vector237>:
80107ef6:	6a 00                	push   $0x0
80107ef8:	68 ed 00 00 00       	push   $0xed
80107efd:	e9 ed ef ff ff       	jmp    80106eef <alltraps>

80107f02 <vector238>:
80107f02:	6a 00                	push   $0x0
80107f04:	68 ee 00 00 00       	push   $0xee
80107f09:	e9 e1 ef ff ff       	jmp    80106eef <alltraps>

80107f0e <vector239>:
80107f0e:	6a 00                	push   $0x0
80107f10:	68 ef 00 00 00       	push   $0xef
80107f15:	e9 d5 ef ff ff       	jmp    80106eef <alltraps>

80107f1a <vector240>:
80107f1a:	6a 00                	push   $0x0
80107f1c:	68 f0 00 00 00       	push   $0xf0
80107f21:	e9 c9 ef ff ff       	jmp    80106eef <alltraps>

80107f26 <vector241>:
80107f26:	6a 00                	push   $0x0
80107f28:	68 f1 00 00 00       	push   $0xf1
80107f2d:	e9 bd ef ff ff       	jmp    80106eef <alltraps>

80107f32 <vector242>:
80107f32:	6a 00                	push   $0x0
80107f34:	68 f2 00 00 00       	push   $0xf2
80107f39:	e9 b1 ef ff ff       	jmp    80106eef <alltraps>

80107f3e <vector243>:
80107f3e:	6a 00                	push   $0x0
80107f40:	68 f3 00 00 00       	push   $0xf3
80107f45:	e9 a5 ef ff ff       	jmp    80106eef <alltraps>

80107f4a <vector244>:
80107f4a:	6a 00                	push   $0x0
80107f4c:	68 f4 00 00 00       	push   $0xf4
80107f51:	e9 99 ef ff ff       	jmp    80106eef <alltraps>

80107f56 <vector245>:
80107f56:	6a 00                	push   $0x0
80107f58:	68 f5 00 00 00       	push   $0xf5
80107f5d:	e9 8d ef ff ff       	jmp    80106eef <alltraps>

80107f62 <vector246>:
80107f62:	6a 00                	push   $0x0
80107f64:	68 f6 00 00 00       	push   $0xf6
80107f69:	e9 81 ef ff ff       	jmp    80106eef <alltraps>

80107f6e <vector247>:
80107f6e:	6a 00                	push   $0x0
80107f70:	68 f7 00 00 00       	push   $0xf7
80107f75:	e9 75 ef ff ff       	jmp    80106eef <alltraps>

80107f7a <vector248>:
80107f7a:	6a 00                	push   $0x0
80107f7c:	68 f8 00 00 00       	push   $0xf8
80107f81:	e9 69 ef ff ff       	jmp    80106eef <alltraps>

80107f86 <vector249>:
80107f86:	6a 00                	push   $0x0
80107f88:	68 f9 00 00 00       	push   $0xf9
80107f8d:	e9 5d ef ff ff       	jmp    80106eef <alltraps>

80107f92 <vector250>:
80107f92:	6a 00                	push   $0x0
80107f94:	68 fa 00 00 00       	push   $0xfa
80107f99:	e9 51 ef ff ff       	jmp    80106eef <alltraps>

80107f9e <vector251>:
80107f9e:	6a 00                	push   $0x0
80107fa0:	68 fb 00 00 00       	push   $0xfb
80107fa5:	e9 45 ef ff ff       	jmp    80106eef <alltraps>

80107faa <vector252>:
80107faa:	6a 00                	push   $0x0
80107fac:	68 fc 00 00 00       	push   $0xfc
80107fb1:	e9 39 ef ff ff       	jmp    80106eef <alltraps>

80107fb6 <vector253>:
80107fb6:	6a 00                	push   $0x0
80107fb8:	68 fd 00 00 00       	push   $0xfd
80107fbd:	e9 2d ef ff ff       	jmp    80106eef <alltraps>

80107fc2 <vector254>:
80107fc2:	6a 00                	push   $0x0
80107fc4:	68 fe 00 00 00       	push   $0xfe
80107fc9:	e9 21 ef ff ff       	jmp    80106eef <alltraps>

80107fce <vector255>:
80107fce:	6a 00                	push   $0x0
80107fd0:	68 ff 00 00 00       	push   $0xff
80107fd5:	e9 15 ef ff ff       	jmp    80106eef <alltraps>

80107fda <lgdt>:
{
80107fda:	55                   	push   %ebp
80107fdb:	89 e5                	mov    %esp,%ebp
80107fdd:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fe3:	48                   	dec    %eax
80107fe4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80107feb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107fef:	8b 45 08             	mov    0x8(%ebp),%eax
80107ff2:	c1 e8 10             	shr    $0x10,%eax
80107ff5:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107ff9:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107ffc:	0f 01 10             	lgdtl  (%eax)
}
80107fff:	c9                   	leave  
80108000:	c3                   	ret    

80108001 <ltr>:
{
80108001:	55                   	push   %ebp
80108002:	89 e5                	mov    %esp,%ebp
80108004:	83 ec 04             	sub    $0x4,%esp
80108007:	8b 45 08             	mov    0x8(%ebp),%eax
8010800a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010800e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108011:	0f 00 d8             	ltr    %ax
}
80108014:	c9                   	leave  
80108015:	c3                   	ret    

80108016 <loadgs>:
{
80108016:	55                   	push   %ebp
80108017:	89 e5                	mov    %esp,%ebp
80108019:	83 ec 04             	sub    $0x4,%esp
8010801c:	8b 45 08             	mov    0x8(%ebp),%eax
8010801f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80108023:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108026:	8e e8                	mov    %eax,%gs
}
80108028:	c9                   	leave  
80108029:	c3                   	ret    

8010802a <lcr3>:

static inline void
lcr3(uint val) 
{
8010802a:	55                   	push   %ebp
8010802b:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010802d:	8b 45 08             	mov    0x8(%ebp),%eax
80108030:	0f 22 d8             	mov    %eax,%cr3
}
80108033:	5d                   	pop    %ebp
80108034:	c3                   	ret    

80108035 <v2p>:
80108035:	55                   	push   %ebp
80108036:	89 e5                	mov    %esp,%ebp
80108038:	8b 45 08             	mov    0x8(%ebp),%eax
8010803b:	05 00 00 00 80       	add    $0x80000000,%eax
80108040:	5d                   	pop    %ebp
80108041:	c3                   	ret    

80108042 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108042:	55                   	push   %ebp
80108043:	89 e5                	mov    %esp,%ebp
80108045:	8b 45 08             	mov    0x8(%ebp),%eax
80108048:	05 00 00 00 80       	add    $0x80000000,%eax
8010804d:	5d                   	pop    %ebp
8010804e:	c3                   	ret    

8010804f <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010804f:	55                   	push   %ebp
80108050:	89 e5                	mov    %esp,%ebp
80108052:	53                   	push   %ebx
80108053:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108056:	e8 ea ad ff ff       	call   80102e45 <cpunum>
8010805b:	89 c2                	mov    %eax,%edx
8010805d:	89 d0                	mov    %edx,%eax
8010805f:	d1 e0                	shl    %eax
80108061:	01 d0                	add    %edx,%eax
80108063:	c1 e0 04             	shl    $0x4,%eax
80108066:	29 d0                	sub    %edx,%eax
80108068:	c1 e0 02             	shl    $0x2,%eax
8010806b:	05 60 09 11 80       	add    $0x80110960,%eax
80108070:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108076:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010807c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108085:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108088:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010808c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808f:	8a 50 7d             	mov    0x7d(%eax),%dl
80108092:	83 e2 f0             	and    $0xfffffff0,%edx
80108095:	83 ca 0a             	or     $0xa,%edx
80108098:	88 50 7d             	mov    %dl,0x7d(%eax)
8010809b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809e:	8a 50 7d             	mov    0x7d(%eax),%dl
801080a1:	83 ca 10             	or     $0x10,%edx
801080a4:	88 50 7d             	mov    %dl,0x7d(%eax)
801080a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080aa:	8a 50 7d             	mov    0x7d(%eax),%dl
801080ad:	83 e2 9f             	and    $0xffffff9f,%edx
801080b0:	88 50 7d             	mov    %dl,0x7d(%eax)
801080b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b6:	8a 50 7d             	mov    0x7d(%eax),%dl
801080b9:	83 ca 80             	or     $0xffffff80,%edx
801080bc:	88 50 7d             	mov    %dl,0x7d(%eax)
801080bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c2:	8a 50 7e             	mov    0x7e(%eax),%dl
801080c5:	83 ca 0f             	or     $0xf,%edx
801080c8:	88 50 7e             	mov    %dl,0x7e(%eax)
801080cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ce:	8a 50 7e             	mov    0x7e(%eax),%dl
801080d1:	83 e2 ef             	and    $0xffffffef,%edx
801080d4:	88 50 7e             	mov    %dl,0x7e(%eax)
801080d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080da:	8a 50 7e             	mov    0x7e(%eax),%dl
801080dd:	83 e2 df             	and    $0xffffffdf,%edx
801080e0:	88 50 7e             	mov    %dl,0x7e(%eax)
801080e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e6:	8a 50 7e             	mov    0x7e(%eax),%dl
801080e9:	83 ca 40             	or     $0x40,%edx
801080ec:	88 50 7e             	mov    %dl,0x7e(%eax)
801080ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f2:	8a 50 7e             	mov    0x7e(%eax),%dl
801080f5:	83 ca 80             	or     $0xffffff80,%edx
801080f8:	88 50 7e             	mov    %dl,0x7e(%eax)
801080fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fe:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108105:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010810c:	ff ff 
8010810e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108111:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108118:	00 00 
8010811a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811d:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108127:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010812d:	83 e2 f0             	and    $0xfffffff0,%edx
80108130:	83 ca 02             	or     $0x2,%edx
80108133:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813c:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108142:	83 ca 10             	or     $0x10,%edx
80108145:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010814b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010814e:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108154:	83 e2 9f             	and    $0xffffff9f,%edx
80108157:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010815d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108160:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108166:	83 ca 80             	or     $0xffffff80,%edx
80108169:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010816f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108172:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108178:	83 ca 0f             	or     $0xf,%edx
8010817b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108184:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010818a:	83 e2 ef             	and    $0xffffffef,%edx
8010818d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108196:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010819c:	83 e2 df             	and    $0xffffffdf,%edx
8010819f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801081a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a8:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801081ae:	83 ca 40             	or     $0x40,%edx
801081b1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801081b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ba:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801081c0:	83 ca 80             	or     $0xffffff80,%edx
801081c3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801081c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cc:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801081d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d6:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801081dd:	ff ff 
801081df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e2:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801081e9:	00 00 
801081eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ee:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801081f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f8:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801081fe:	83 e2 f0             	and    $0xfffffff0,%edx
80108201:	83 ca 0a             	or     $0xa,%edx
80108204:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010820a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820d:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108213:	83 ca 10             	or     $0x10,%edx
80108216:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010821c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821f:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108225:	83 ca 60             	or     $0x60,%edx
80108228:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010822e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108231:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108237:	83 ca 80             	or     $0xffffff80,%edx
8010823a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108243:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108249:	83 ca 0f             	or     $0xf,%edx
8010824c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108255:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010825b:	83 e2 ef             	and    $0xffffffef,%edx
8010825e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108267:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010826d:	83 e2 df             	and    $0xffffffdf,%edx
80108270:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108279:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010827f:	83 ca 40             	or     $0x40,%edx
80108282:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108288:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108291:	83 ca 80             	or     $0xffffff80,%edx
80108294:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010829a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801082a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a7:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801082ae:	ff ff 
801082b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b3:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801082ba:	00 00 
801082bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bf:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801082c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c9:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801082cf:	83 e2 f0             	and    $0xfffffff0,%edx
801082d2:	83 ca 02             	or     $0x2,%edx
801082d5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082de:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801082e4:	83 ca 10             	or     $0x10,%edx
801082e7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f0:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801082f6:	83 ca 60             	or     $0x60,%edx
801082f9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801082ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108302:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108308:	83 ca 80             	or     $0xffffff80,%edx
8010830b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108314:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010831a:	83 ca 0f             	or     $0xf,%edx
8010831d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108326:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010832c:	83 e2 ef             	and    $0xffffffef,%edx
8010832f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108338:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010833e:	83 e2 df             	and    $0xffffffdf,%edx
80108341:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834a:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108350:	83 ca 40             	or     $0x40,%edx
80108353:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835c:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108362:	83 ca 80             	or     $0xffffff80,%edx
80108365:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108378:	05 b4 00 00 00       	add    $0xb4,%eax
8010837d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108380:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80108386:	c1 ea 10             	shr    $0x10,%edx
80108389:	88 d1                	mov    %dl,%cl
8010838b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010838e:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80108394:	c1 ea 18             	shr    $0x18,%edx
80108397:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010839a:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
801083a1:	00 00 
801083a3:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801083a6:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
801083ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b0:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801083b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b9:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801083bf:	83 e1 f0             	and    $0xfffffff0,%ecx
801083c2:	83 c9 02             	or     $0x2,%ecx
801083c5:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801083cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ce:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801083d4:	83 c9 10             	or     $0x10,%ecx
801083d7:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801083dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e0:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801083e6:	83 e1 9f             	and    $0xffffff9f,%ecx
801083e9:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801083ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083f2:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801083f8:	83 c9 80             	or     $0xffffff80,%ecx
801083fb:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108401:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108404:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010840a:	83 e1 f0             	and    $0xfffffff0,%ecx
8010840d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108416:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010841c:	83 e1 ef             	and    $0xffffffef,%ecx
8010841f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108428:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010842e:	83 e1 df             	and    $0xffffffdf,%ecx
80108431:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843a:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108440:	83 c9 40             	or     $0x40,%ecx
80108443:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844c:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108452:	83 c9 80             	or     $0xffffff80,%ecx
80108455:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010845b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845e:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108467:	83 c0 70             	add    $0x70,%eax
8010846a:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108471:	00 
80108472:	89 04 24             	mov    %eax,(%esp)
80108475:	e8 60 fb ff ff       	call   80107fda <lgdt>
  loadgs(SEG_KCPU << 3);
8010847a:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108481:	e8 90 fb ff ff       	call   80108016 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108486:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108489:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010848f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108496:	00 00 00 00 
}
8010849a:	83 c4 24             	add    $0x24,%esp
8010849d:	5b                   	pop    %ebx
8010849e:	5d                   	pop    %ebp
8010849f:	c3                   	ret    

801084a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801084a0:	55                   	push   %ebp
801084a1:	89 e5                	mov    %esp,%ebp
801084a3:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801084a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a9:	c1 e8 16             	shr    $0x16,%eax
801084ac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801084b3:	8b 45 08             	mov    0x8(%ebp),%eax
801084b6:	01 d0                	add    %edx,%eax
801084b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801084bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084be:	8b 00                	mov    (%eax),%eax
801084c0:	83 e0 01             	and    $0x1,%eax
801084c3:	85 c0                	test   %eax,%eax
801084c5:	74 17                	je     801084de <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801084c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ca:	8b 00                	mov    (%eax),%eax
801084cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084d1:	89 04 24             	mov    %eax,(%esp)
801084d4:	e8 69 fb ff ff       	call   80108042 <p2v>
801084d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084dc:	eb 4b                	jmp    80108529 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0) // kalloc es 0 cuando no puede asignar la memoria.
801084de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801084e2:	74 0e                	je     801084f2 <walkpgdir+0x52>
801084e4:	e8 d5 a5 ff ff       	call   80102abe <kalloc>
801084e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801084ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801084f0:	75 07                	jne    801084f9 <walkpgdir+0x59>
      return 0;
801084f2:	b8 00 00 00 00       	mov    $0x0,%eax
801084f7:	eb 47                	jmp    80108540 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801084f9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108500:	00 
80108501:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108508:	00 
80108509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010850c:	89 04 24             	mov    %eax,(%esp)
8010850f:	e8 9e d3 ff ff       	call   801058b2 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108517:	89 04 24             	mov    %eax,(%esp)
8010851a:	e8 16 fb ff ff       	call   80108035 <v2p>
8010851f:	89 c2                	mov    %eax,%edx
80108521:	83 ca 07             	or     $0x7,%edx
80108524:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108527:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)]; // PTX (va) me retorna un index de la tabla de pagina, que luego aplicando, &pgtab[..] me retorna su direccion. 
80108529:	8b 45 0c             	mov    0xc(%ebp),%eax
8010852c:	c1 e8 0c             	shr    $0xc,%eax
8010852f:	25 ff 03 00 00       	and    $0x3ff,%eax
80108534:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010853b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010853e:	01 d0                	add    %edx,%eax
}                         // por lo tanto , la direccion del index, de la tabla de paginas.
80108540:	c9                   	leave  
80108541:	c3                   	ret    

80108542 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned.
// retornaba "static int" lo cambie por int, si no me saltaba error
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108542:	55                   	push   %ebp
80108543:	89 e5                	mov    %esp,%ebp
80108545:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108548:	8b 45 0c             	mov    0xc(%ebp),%eax
8010854b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108550:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108553:	8b 55 0c             	mov    0xc(%ebp),%edx
80108556:	8b 45 10             	mov    0x10(%ebp),%eax
80108559:	01 d0                	add    %edx,%eax
8010855b:	48                   	dec    %eax
8010855c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108561:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0) // walkpgdir: create any required page table pages, osea
80108564:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010856b:	00 
8010856c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010856f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108573:	8b 45 08             	mov    0x8(%ebp),%eax
80108576:	89 04 24             	mov    %eax,(%esp)
80108579:	e8 22 ff ff ff       	call   801084a0 <walkpgdir>
8010857e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108581:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108585:	75 07                	jne    8010858e <mappages+0x4c>
                                            // crea cualquier pagina requerida para la tabla de paginas.
                                            // retorna la direccion de donde fue creada en la tabla pgdir.
      return -1; // no fue posible mapear, debido a que el walkpgdir no pudo asignar la memoria o alloc no es 1
80108587:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010858c:	eb 46                	jmp    801085d4 <mappages+0x92>
    if(*pte & PTE_P)
8010858e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108591:	8b 00                	mov    (%eax),%eax
80108593:	83 e0 01             	and    $0x1,%eax
80108596:	85 c0                	test   %eax,%eax
80108598:	74 0c                	je     801085a6 <mappages+0x64>
      panic("remap");
8010859a:	c7 04 24 14 95 10 80 	movl   $0x80109514,(%esp)
801085a1:	e8 90 7f ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
801085a6:	8b 45 18             	mov    0x18(%ebp),%eax
801085a9:	0b 45 14             	or     0x14(%ebp),%eax
801085ac:	89 c2                	mov    %eax,%edx
801085ae:	83 ca 01             	or     $0x1,%edx
801085b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801085b4:	89 10                	mov    %edx,(%eax)
    if(a == last)
801085b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801085bc:	74 10                	je     801085ce <mappages+0x8c>
      break;
    a += PGSIZE;
801085be:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801085c5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801085cc:	eb 96                	jmp    80108564 <mappages+0x22>
      break;
801085ce:	90                   	nop
  return 0;
801085cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801085d4:	c9                   	leave  
801085d5:	c3                   	ret    

801085d6 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801085d6:	55                   	push   %ebp
801085d7:	89 e5                	mov    %esp,%ebp
801085d9:	53                   	push   %ebx
801085da:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801085dd:	e8 dc a4 ff ff       	call   80102abe <kalloc>
801085e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801085e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801085e9:	75 0a                	jne    801085f5 <setupkvm+0x1f>
    return 0;
801085eb:	b8 00 00 00 00       	mov    $0x0,%eax
801085f0:	e9 98 00 00 00       	jmp    8010868d <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
801085f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801085fc:	00 
801085fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108604:	00 
80108605:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108608:	89 04 24             	mov    %eax,(%esp)
8010860b:	e8 a2 d2 ff ff       	call   801058b2 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108610:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108617:	e8 26 fa ff ff       	call   80108042 <p2v>
8010861c:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108621:	76 0c                	jbe    8010862f <setupkvm+0x59>
    panic("PHYSTOP too high");
80108623:	c7 04 24 1a 95 10 80 	movl   $0x8010951a,(%esp)
8010862a:	e8 07 7f ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010862f:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
80108636:	eb 49                	jmp    80108681 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80108638:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010863b:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010863e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108641:	8b 50 04             	mov    0x4(%eax),%edx
80108644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108647:	8b 58 08             	mov    0x8(%eax),%ebx
8010864a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010864d:	8b 40 04             	mov    0x4(%eax),%eax
80108650:	29 c3                	sub    %eax,%ebx
80108652:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108655:	8b 00                	mov    (%eax),%eax
80108657:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010865b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010865f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108663:	89 44 24 04          	mov    %eax,0x4(%esp)
80108667:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010866a:	89 04 24             	mov    %eax,(%esp)
8010866d:	e8 d0 fe ff ff       	call   80108542 <mappages>
80108672:	85 c0                	test   %eax,%eax
80108674:	79 07                	jns    8010867d <setupkvm+0xa7>
      return 0;
80108676:	b8 00 00 00 00       	mov    $0x0,%eax
8010867b:	eb 10                	jmp    8010868d <setupkvm+0xb7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010867d:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80108681:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
80108688:	72 ae                	jb     80108638 <setupkvm+0x62>
  return pgdir;
8010868a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010868d:	83 c4 34             	add    $0x34,%esp
80108690:	5b                   	pop    %ebx
80108691:	5d                   	pop    %ebp
80108692:	c3                   	ret    

80108693 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80108693:	55                   	push   %ebp
80108694:	89 e5                	mov    %esp,%ebp
80108696:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108699:	e8 38 ff ff ff       	call   801085d6 <setupkvm>
8010869e:	a3 b8 44 11 80       	mov    %eax,0x801144b8
  switchkvm();
801086a3:	e8 02 00 00 00       	call   801086aa <switchkvm>
}
801086a8:	c9                   	leave  
801086a9:	c3                   	ret    

801086aa <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801086aa:	55                   	push   %ebp
801086ab:	89 e5                	mov    %esp,%ebp
801086ad:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801086b0:	a1 b8 44 11 80       	mov    0x801144b8,%eax
801086b5:	89 04 24             	mov    %eax,(%esp)
801086b8:	e8 78 f9 ff ff       	call   80108035 <v2p>
801086bd:	89 04 24             	mov    %eax,(%esp)
801086c0:	e8 65 f9 ff ff       	call   8010802a <lcr3>
}
801086c5:	c9                   	leave  
801086c6:	c3                   	ret    

801086c7 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801086c7:	55                   	push   %ebp
801086c8:	89 e5                	mov    %esp,%ebp
801086ca:	53                   	push   %ebx
801086cb:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801086ce:	e8 df d0 ff ff       	call   801057b2 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801086d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086d9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801086e0:	83 c2 08             	add    $0x8,%edx
801086e3:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801086ea:	83 c1 08             	add    $0x8,%ecx
801086ed:	c1 e9 10             	shr    $0x10,%ecx
801086f0:	88 cb                	mov    %cl,%bl
801086f2:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801086f9:	83 c1 08             	add    $0x8,%ecx
801086fc:	c1 e9 18             	shr    $0x18,%ecx
801086ff:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108706:	67 00 
80108708:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010870f:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108715:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010871b:	83 e2 f0             	and    $0xfffffff0,%edx
8010871e:	83 ca 09             	or     $0x9,%edx
80108721:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108727:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010872d:	83 ca 10             	or     $0x10,%edx
80108730:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108736:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010873c:	83 e2 9f             	and    $0xffffff9f,%edx
8010873f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108745:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010874b:	83 ca 80             	or     $0xffffff80,%edx
8010874e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108754:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010875a:	83 e2 f0             	and    $0xfffffff0,%edx
8010875d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108763:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108769:	83 e2 ef             	and    $0xffffffef,%edx
8010876c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108772:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108778:	83 e2 df             	and    $0xffffffdf,%edx
8010877b:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108781:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108787:	83 ca 40             	or     $0x40,%edx
8010878a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108790:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108796:	83 e2 7f             	and    $0x7f,%edx
80108799:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010879f:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801087a5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087ab:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801087b1:	83 e2 ef             	and    $0xffffffef,%edx
801087b4:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801087ba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087c0:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801087c6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801087cc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801087d3:	8b 52 08             	mov    0x8(%edx),%edx
801087d6:	81 c2 00 10 00 00    	add    $0x1000,%edx
801087dc:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801087df:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
801087e6:	e8 16 f8 ff ff       	call   80108001 <ltr>
  if(p->pgdir == 0)
801087eb:	8b 45 08             	mov    0x8(%ebp),%eax
801087ee:	8b 40 04             	mov    0x4(%eax),%eax
801087f1:	85 c0                	test   %eax,%eax
801087f3:	75 0c                	jne    80108801 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
801087f5:	c7 04 24 2b 95 10 80 	movl   $0x8010952b,(%esp)
801087fc:	e8 35 7d ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108801:	8b 45 08             	mov    0x8(%ebp),%eax
80108804:	8b 40 04             	mov    0x4(%eax),%eax
80108807:	89 04 24             	mov    %eax,(%esp)
8010880a:	e8 26 f8 ff ff       	call   80108035 <v2p>
8010880f:	89 04 24             	mov    %eax,(%esp)
80108812:	e8 13 f8 ff ff       	call   8010802a <lcr3>
  popcli();
80108817:	e8 dc cf ff ff       	call   801057f8 <popcli>
}
8010881c:	83 c4 14             	add    $0x14,%esp
8010881f:	5b                   	pop    %ebx
80108820:	5d                   	pop    %ebp
80108821:	c3                   	ret    

80108822 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108822:	55                   	push   %ebp
80108823:	89 e5                	mov    %esp,%ebp
80108825:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108828:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010882f:	76 0c                	jbe    8010883d <inituvm+0x1b>
    panic("inituvm: more than a page");
80108831:	c7 04 24 3f 95 10 80 	movl   $0x8010953f,(%esp)
80108838:	e8 f9 7c ff ff       	call   80100536 <panic>
  mem = kalloc();
8010883d:	e8 7c a2 ff ff       	call   80102abe <kalloc>
80108842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108845:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010884c:	00 
8010884d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108854:	00 
80108855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108858:	89 04 24             	mov    %eax,(%esp)
8010885b:	e8 52 d0 ff ff       	call   801058b2 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108860:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108863:	89 04 24             	mov    %eax,(%esp)
80108866:	e8 ca f7 ff ff       	call   80108035 <v2p>
8010886b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108872:	00 
80108873:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108877:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010887e:	00 
8010887f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108886:	00 
80108887:	8b 45 08             	mov    0x8(%ebp),%eax
8010888a:	89 04 24             	mov    %eax,(%esp)
8010888d:	e8 b0 fc ff ff       	call   80108542 <mappages>
  memmove(mem, init, sz);
80108892:	8b 45 10             	mov    0x10(%ebp),%eax
80108895:	89 44 24 08          	mov    %eax,0x8(%esp)
80108899:	8b 45 0c             	mov    0xc(%ebp),%eax
8010889c:	89 44 24 04          	mov    %eax,0x4(%esp)
801088a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088a3:	89 04 24             	mov    %eax,(%esp)
801088a6:	e8 d3 d0 ff ff       	call   8010597e <memmove>
}
801088ab:	c9                   	leave  
801088ac:	c3                   	ret    

801088ad <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801088ad:	55                   	push   %ebp
801088ae:	89 e5                	mov    %esp,%ebp
801088b0:	53                   	push   %ebx
801088b1:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801088b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801088b7:	25 ff 0f 00 00       	and    $0xfff,%eax
801088bc:	85 c0                	test   %eax,%eax
801088be:	74 0c                	je     801088cc <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801088c0:	c7 04 24 5c 95 10 80 	movl   $0x8010955c,(%esp)
801088c7:	e8 6a 7c ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801088cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801088d3:	e9 ad 00 00 00       	jmp    80108985 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801088d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088db:	8b 55 0c             	mov    0xc(%ebp),%edx
801088de:	01 d0                	add    %edx,%eax
801088e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801088e7:	00 
801088e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801088ec:	8b 45 08             	mov    0x8(%ebp),%eax
801088ef:	89 04 24             	mov    %eax,(%esp)
801088f2:	e8 a9 fb ff ff       	call   801084a0 <walkpgdir>
801088f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801088fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801088fe:	75 0c                	jne    8010890c <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108900:	c7 04 24 7f 95 10 80 	movl   $0x8010957f,(%esp)
80108907:	e8 2a 7c ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
8010890c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010890f:	8b 00                	mov    (%eax),%eax
80108911:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108916:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010891c:	8b 55 18             	mov    0x18(%ebp),%edx
8010891f:	89 d1                	mov    %edx,%ecx
80108921:	29 c1                	sub    %eax,%ecx
80108923:	89 c8                	mov    %ecx,%eax
80108925:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010892a:	77 11                	ja     8010893d <loaduvm+0x90>
      n = sz - i;
8010892c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010892f:	8b 55 18             	mov    0x18(%ebp),%edx
80108932:	89 d1                	mov    %edx,%ecx
80108934:	29 c1                	sub    %eax,%ecx
80108936:	89 c8                	mov    %ecx,%eax
80108938:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010893b:	eb 07                	jmp    80108944 <loaduvm+0x97>
    else
      n = PGSIZE;
8010893d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108947:	8b 55 14             	mov    0x14(%ebp),%edx
8010894a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010894d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108950:	89 04 24             	mov    %eax,(%esp)
80108953:	e8 ea f6 ff ff       	call   80108042 <p2v>
80108958:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010895b:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010895f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108963:	89 44 24 04          	mov    %eax,0x4(%esp)
80108967:	8b 45 10             	mov    0x10(%ebp),%eax
8010896a:	89 04 24             	mov    %eax,(%esp)
8010896d:	e8 da 93 ff ff       	call   80101d4c <readi>
80108972:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108975:	74 07                	je     8010897e <loaduvm+0xd1>
      return -1;
80108977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010897c:	eb 18                	jmp    80108996 <loaduvm+0xe9>
  for(i = 0; i < sz; i += PGSIZE){
8010897e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108985:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108988:	3b 45 18             	cmp    0x18(%ebp),%eax
8010898b:	0f 82 47 ff ff ff    	jb     801088d8 <loaduvm+0x2b>
  }
  return 0;
80108991:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108996:	83 c4 24             	add    $0x24,%esp
80108999:	5b                   	pop    %ebx
8010899a:	5d                   	pop    %ebp
8010899b:	c3                   	ret    

8010899c <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010899c:	55                   	push   %ebp
8010899d:	89 e5                	mov    %esp,%ebp
8010899f:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801089a2:	8b 45 10             	mov    0x10(%ebp),%eax
801089a5:	85 c0                	test   %eax,%eax
801089a7:	79 0a                	jns    801089b3 <allocuvm+0x17>
    return 0;
801089a9:	b8 00 00 00 00       	mov    $0x0,%eax
801089ae:	e9 c1 00 00 00       	jmp    80108a74 <allocuvm+0xd8>
  if(newsz < oldsz)
801089b3:	8b 45 10             	mov    0x10(%ebp),%eax
801089b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089b9:	73 08                	jae    801089c3 <allocuvm+0x27>
    return oldsz;
801089bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801089be:	e9 b1 00 00 00       	jmp    80108a74 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801089c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801089c6:	05 ff 0f 00 00       	add    $0xfff,%eax
801089cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801089d3:	e9 8d 00 00 00       	jmp    80108a65 <allocuvm+0xc9>
    mem = kalloc();
801089d8:	e8 e1 a0 ff ff       	call   80102abe <kalloc>
801089dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801089e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089e4:	75 2c                	jne    80108a12 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
801089e6:	c7 04 24 9d 95 10 80 	movl   $0x8010959d,(%esp)
801089ed:	e8 af 79 ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801089f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801089f5:	89 44 24 08          	mov    %eax,0x8(%esp)
801089f9:	8b 45 10             	mov    0x10(%ebp),%eax
801089fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a00:	8b 45 08             	mov    0x8(%ebp),%eax
80108a03:	89 04 24             	mov    %eax,(%esp)
80108a06:	e8 6b 00 00 00       	call   80108a76 <deallocuvm>
      return 0;
80108a0b:	b8 00 00 00 00       	mov    $0x0,%eax
80108a10:	eb 62                	jmp    80108a74 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108a12:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a19:	00 
80108a1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108a21:	00 
80108a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a25:	89 04 24             	mov    %eax,(%esp)
80108a28:	e8 85 ce ff ff       	call   801058b2 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a30:	89 04 24             	mov    %eax,(%esp)
80108a33:	e8 fd f5 ff ff       	call   80108035 <v2p>
80108a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108a3b:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108a42:	00 
80108a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108a47:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108a4e:	00 
80108a4f:	89 54 24 04          	mov    %edx,0x4(%esp)
80108a53:	8b 45 08             	mov    0x8(%ebp),%eax
80108a56:	89 04 24             	mov    %eax,(%esp)
80108a59:	e8 e4 fa ff ff       	call   80108542 <mappages>
  for(; a < newsz; a += PGSIZE){
80108a5e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a68:	3b 45 10             	cmp    0x10(%ebp),%eax
80108a6b:	0f 82 67 ff ff ff    	jb     801089d8 <allocuvm+0x3c>
  }
  return newsz;
80108a71:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a74:	c9                   	leave  
80108a75:	c3                   	ret    

80108a76 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108a76:	55                   	push   %ebp
80108a77:	89 e5                	mov    %esp,%ebp
80108a79:	83 ec 38             	sub    $0x38,%esp
  pte_t *pte;
  uint a, pa;
  int save_this = 1; // New: Add in project final 
80108a7c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  if(newsz >= oldsz)
80108a83:	8b 45 10             	mov    0x10(%ebp),%eax
80108a86:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a89:	72 08                	jb     80108a93 <deallocuvm+0x1d>
    return oldsz;
80108a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a8e:	e9 b8 00 00 00       	jmp    80108b4b <deallocuvm+0xd5>

  //pte_s
  a = PGROUNDUP(newsz);
80108a93:	8b 45 10             	mov    0x10(%ebp),%eax
80108a96:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108aa3:	e9 94 00 00 00       	jmp    80108b3c <deallocuvm+0xc6>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108ab2:	00 
80108ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80108aba:	89 04 24             	mov    %eax,(%esp)
80108abd:	e8 de f9 ff ff       	call   801084a0 <walkpgdir>
80108ac2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(!pte)
80108ac5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108ac9:	75 09                	jne    80108ad4 <deallocuvm+0x5e>
      a += (NPTENTRIES - 1) * PGSIZE;
80108acb:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108ad2:	eb 61                	jmp    80108b35 <deallocuvm+0xbf>
    else if((*pte & PTE_P) != 0){
80108ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ad7:	8b 00                	mov    (%eax),%eax
80108ad9:	83 e0 01             	and    $0x1,%eax
80108adc:	85 c0                	test   %eax,%eax
80108ade:	74 55                	je     80108b35 <deallocuvm+0xbf>
      pa = PTE_ADDR(*pte);
80108ae0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ae3:	8b 00                	mov    (%eax),%eax
80108ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aea:	89 45 e8             	mov    %eax,-0x18(%ebp)
      save_this = is_shared(pa); //New: Add in project final
80108aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108af0:	89 04 24             	mov    %eax,(%esp)
80108af3:	e8 a4 03 00 00       	call   80108e9c <is_shared>
80108af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80108afb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108aff:	75 0c                	jne    80108b0d <deallocuvm+0x97>
        panic("kfree");
80108b01:	c7 04 24 b5 95 10 80 	movl   $0x801095b5,(%esp)
80108b08:	e8 29 7a ff ff       	call   80100536 <panic>
      // char *v = p2v(pa);
      // kfree(v);
      // *pte = 0;
      if (!save_this){ // New: Add in project final, ahi uno solo, le aplico el kfree
80108b0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b11:	75 22                	jne    80108b35 <deallocuvm+0xbf>
        char *v = p2v(pa);
80108b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108b16:	89 04 24             	mov    %eax,(%esp)
80108b19:	e8 24 f5 ff ff       	call   80108042 <p2v>
80108b1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(v);
80108b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108b24:	89 04 24             	mov    %eax,(%esp)
80108b27:	e8 f9 9e ff ff       	call   80102a25 <kfree>
        *pte = 0;
80108b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108b35:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108b42:	0f 82 60 ff ff ff    	jb     80108aa8 <deallocuvm+0x32>
      }
    }
  }
  return newsz;
80108b48:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108b4b:	c9                   	leave  
80108b4c:	c3                   	ret    

80108b4d <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108b4d:	55                   	push   %ebp
80108b4e:	89 e5                	mov    %esp,%ebp
80108b50:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108b53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108b57:	75 0c                	jne    80108b65 <freevm+0x18>
    panic("freevm: no pgdir");
80108b59:	c7 04 24 bb 95 10 80 	movl   $0x801095bb,(%esp)
80108b60:	e8 d1 79 ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108b65:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b6c:	00 
80108b6d:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108b74:	80 
80108b75:	8b 45 08             	mov    0x8(%ebp),%eax
80108b78:	89 04 24             	mov    %eax,(%esp)
80108b7b:	e8 f6 fe ff ff       	call   80108a76 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b87:	eb 47                	jmp    80108bd0 <freevm+0x83>
    if(pgdir[i] & PTE_P){
80108b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b93:	8b 45 08             	mov    0x8(%ebp),%eax
80108b96:	01 d0                	add    %edx,%eax
80108b98:	8b 00                	mov    (%eax),%eax
80108b9a:	83 e0 01             	and    $0x1,%eax
80108b9d:	85 c0                	test   %eax,%eax
80108b9f:	74 2c                	je     80108bcd <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108bab:	8b 45 08             	mov    0x8(%ebp),%eax
80108bae:	01 d0                	add    %edx,%eax
80108bb0:	8b 00                	mov    (%eax),%eax
80108bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bb7:	89 04 24             	mov    %eax,(%esp)
80108bba:	e8 83 f4 ff ff       	call   80108042 <p2v>
80108bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108bc5:	89 04 24             	mov    %eax,(%esp)
80108bc8:	e8 58 9e ff ff       	call   80102a25 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108bcd:	ff 45 f4             	incl   -0xc(%ebp)
80108bd0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108bd7:	76 b0                	jbe    80108b89 <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80108bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80108bdc:	89 04 24             	mov    %eax,(%esp)
80108bdf:	e8 41 9e ff ff       	call   80102a25 <kfree>
}
80108be4:	c9                   	leave  
80108be5:	c3                   	ret    

80108be6 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108be6:	55                   	push   %ebp
80108be7:	89 e5                	mov    %esp,%ebp
80108be9:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108bec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108bf3:	00 
80108bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
80108bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bfb:	8b 45 08             	mov    0x8(%ebp),%eax
80108bfe:	89 04 24             	mov    %eax,(%esp)
80108c01:	e8 9a f8 ff ff       	call   801084a0 <walkpgdir>
80108c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108c09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108c0d:	75 0c                	jne    80108c1b <clearpteu+0x35>
    panic("clearpteu");
80108c0f:	c7 04 24 cc 95 10 80 	movl   $0x801095cc,(%esp)
80108c16:	e8 1b 79 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c1e:	8b 00                	mov    (%eax),%eax
80108c20:	89 c2                	mov    %eax,%edx
80108c22:	83 e2 fb             	and    $0xfffffffb,%edx
80108c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c28:	89 10                	mov    %edx,(%eax)
}
80108c2a:	c9                   	leave  
80108c2b:	c3                   	ret    

80108c2c <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108c2c:	55                   	push   %ebp
80108c2d:	89 e5                	mov    %esp,%ebp
80108c2f:	53                   	push   %ebx
80108c30:	83 ec 44             	sub    $0x44,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  int only_map; // New: Add in project final

  if((d = setupkvm()) == 0)
80108c33:	e8 9e f9 ff ff       	call   801085d6 <setupkvm>
80108c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108c3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108c3f:	75 0a                	jne    80108c4b <copyuvm+0x1f>
    return 0;
80108c41:	b8 00 00 00 00       	mov    $0x0,%eax
80108c46:	e9 43 01 00 00       	jmp    80108d8e <copyuvm+0x162>
  for(i = 0; i < sz; i += PGSIZE){ // voy copiando cda uno de las entradas, pero las q esten compartidas las mapeo, no las clono
80108c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108c52:	e9 12 01 00 00       	jmp    80108d69 <copyuvm+0x13d>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c5a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108c61:	00 
80108c62:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c66:	8b 45 08             	mov    0x8(%ebp),%eax
80108c69:	89 04 24             	mov    %eax,(%esp)
80108c6c:	e8 2f f8 ff ff       	call   801084a0 <walkpgdir>
80108c71:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108c74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108c78:	75 0c                	jne    80108c86 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108c7a:	c7 04 24 d6 95 10 80 	movl   $0x801095d6,(%esp)
80108c81:	e8 b0 78 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
80108c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c89:	8b 00                	mov    (%eax),%eax
80108c8b:	83 e0 01             	and    $0x1,%eax
80108c8e:	85 c0                	test   %eax,%eax
80108c90:	75 0c                	jne    80108c9e <copyuvm+0x72>
      panic("copyuvm: page not present");
80108c92:	c7 04 24 f0 95 10 80 	movl   $0x801095f0,(%esp)
80108c99:	e8 98 78 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte); // guardo en pa la dir. fisica
80108c9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ca1:	8b 00                	mov    (%eax),%eax
80108ca3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ca8:	89 45 e8             	mov    %eax,-0x18(%ebp)
                          // en *pte tengo una entrada en la tabla de paginas pgdir
    flags = PTE_FLAGS(*pte);
80108cab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cae:	8b 00                	mov    (%eax),%eax
80108cb0:	25 ff 0f 00 00       	and    $0xfff,%eax
80108cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    only_map = is_shared(pa); // New: Add in project final
80108cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108cbb:	89 04 24             	mov    %eax,(%esp)
80108cbe:	e8 d9 01 00 00       	call   80108e9c <is_shared>
80108cc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!only_map) { 
80108cc6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108cca:	75 6a                	jne    80108d36 <copyuvm+0x10a>
      if((mem = kalloc()) == 0) // el kalloc no pudo asignar la memoria
80108ccc:	e8 ed 9d ff ff       	call   80102abe <kalloc>
80108cd1:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108cd4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80108cd8:	0f 84 9c 00 00 00    	je     80108d7a <copyuvm+0x14e>
        goto bad;
      memmove(mem, (char*)p2v(pa), PGSIZE);
80108cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108ce1:	89 04 24             	mov    %eax,(%esp)
80108ce4:	e8 59 f3 ff ff       	call   80108042 <p2v>
80108ce9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108cf0:	00 
80108cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cf5:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108cf8:	89 04 24             	mov    %eax,(%esp)
80108cfb:	e8 7e cc ff ff       	call   8010597e <memmove>
      if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108d00:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108d03:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d06:	89 04 24             	mov    %eax,(%esp)
80108d09:	e8 27 f3 ff ff       	call   80108035 <v2p>
80108d0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108d11:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108d15:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108d19:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108d20:	00 
80108d21:	89 54 24 04          	mov    %edx,0x4(%esp)
80108d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d28:	89 04 24             	mov    %eax,(%esp)
80108d2b:	e8 12 f8 ff ff       	call   80108542 <mappages>
80108d30:	85 c0                	test   %eax,%eax
80108d32:	79 2e                	jns    80108d62 <copyuvm+0x136>
        goto bad;
80108d34:	eb 48                	jmp    80108d7e <copyuvm+0x152>
    } else {
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80108d36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d3c:	89 54 24 10          	mov    %edx,0x10(%esp)
80108d40:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108d43:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108d47:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108d4e:	00 
80108d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d56:	89 04 24             	mov    %eax,(%esp)
80108d59:	e8 e4 f7 ff ff       	call   80108542 <mappages>
80108d5e:	85 c0                	test   %eax,%eax
80108d60:	78 1b                	js     80108d7d <copyuvm+0x151>
  for(i = 0; i < sz; i += PGSIZE){ // voy copiando cda uno de las entradas, pero las q esten compartidas las mapeo, no las clono
80108d62:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d6c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108d6f:	0f 82 e2 fe ff ff    	jb     80108c57 <copyuvm+0x2b>
        goto bad;
     }
  }
  return d;
80108d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d78:	eb 14                	jmp    80108d8e <copyuvm+0x162>
        goto bad;
80108d7a:	90                   	nop
80108d7b:	eb 01                	jmp    80108d7e <copyuvm+0x152>
        goto bad;
80108d7d:	90                   	nop

bad:
  freevm(d);
80108d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d81:	89 04 24             	mov    %eax,(%esp)
80108d84:	e8 c4 fd ff ff       	call   80108b4d <freevm>
  return 0;
80108d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d8e:	83 c4 44             	add    $0x44,%esp
80108d91:	5b                   	pop    %ebx
80108d92:	5d                   	pop    %ebp
80108d93:	c3                   	ret    

80108d94 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108d94:	55                   	push   %ebp
80108d95:	89 e5                	mov    %esp,%ebp
80108d97:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108d9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108da1:	00 
80108da2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108da5:	89 44 24 04          	mov    %eax,0x4(%esp)
80108da9:	8b 45 08             	mov    0x8(%ebp),%eax
80108dac:	89 04 24             	mov    %eax,(%esp)
80108daf:	e8 ec f6 ff ff       	call   801084a0 <walkpgdir>
80108db4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dba:	8b 00                	mov    (%eax),%eax
80108dbc:	83 e0 01             	and    $0x1,%eax
80108dbf:	85 c0                	test   %eax,%eax
80108dc1:	75 07                	jne    80108dca <uva2ka+0x36>
    return 0;
80108dc3:	b8 00 00 00 00       	mov    $0x0,%eax
80108dc8:	eb 25                	jmp    80108def <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dcd:	8b 00                	mov    (%eax),%eax
80108dcf:	83 e0 04             	and    $0x4,%eax
80108dd2:	85 c0                	test   %eax,%eax
80108dd4:	75 07                	jne    80108ddd <uva2ka+0x49>
    return 0;
80108dd6:	b8 00 00 00 00       	mov    $0x0,%eax
80108ddb:	eb 12                	jmp    80108def <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de0:	8b 00                	mov    (%eax),%eax
80108de2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108de7:	89 04 24             	mov    %eax,(%esp)
80108dea:	e8 53 f2 ff ff       	call   80108042 <p2v>
}
80108def:	c9                   	leave  
80108df0:	c3                   	ret    

80108df1 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108df1:	55                   	push   %ebp
80108df2:	89 e5                	mov    %esp,%ebp
80108df4:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108df7:	8b 45 10             	mov    0x10(%ebp),%eax
80108dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108dfd:	e9 89 00 00 00       	jmp    80108e8b <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108e02:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108e0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e10:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e14:	8b 45 08             	mov    0x8(%ebp),%eax
80108e17:	89 04 24             	mov    %eax,(%esp)
80108e1a:	e8 75 ff ff ff       	call   80108d94 <uva2ka>
80108e1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108e22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108e26:	75 07                	jne    80108e2f <copyout+0x3e>
      return -1;
80108e28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108e2d:	eb 6b                	jmp    80108e9a <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108e2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e32:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108e35:	89 d1                	mov    %edx,%ecx
80108e37:	29 c1                	sub    %eax,%ecx
80108e39:	89 c8                	mov    %ecx,%eax
80108e3b:	05 00 10 00 00       	add    $0x1000,%eax
80108e40:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e46:	3b 45 14             	cmp    0x14(%ebp),%eax
80108e49:	76 06                	jbe    80108e51 <copyout+0x60>
      n = len;
80108e4b:	8b 45 14             	mov    0x14(%ebp),%eax
80108e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108e51:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e54:	8b 55 0c             	mov    0xc(%ebp),%edx
80108e57:	29 c2                	sub    %eax,%edx
80108e59:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108e5c:	01 c2                	add    %eax,%edx
80108e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e61:	89 44 24 08          	mov    %eax,0x8(%esp)
80108e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e68:	89 44 24 04          	mov    %eax,0x4(%esp)
80108e6c:	89 14 24             	mov    %edx,(%esp)
80108e6f:	e8 0a cb ff ff       	call   8010597e <memmove>
    len -= n;
80108e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e77:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108e7d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e83:	05 00 10 00 00       	add    $0x1000,%eax
80108e88:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108e8b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108e8f:	0f 85 6d ff ff ff    	jne    80108e02 <copyout+0x11>
  }
  return 0;
80108e95:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e9a:	c9                   	leave  
80108e9b:	c3                   	ret    

80108e9c <is_shared>:
// struct sharedmemory* get_shm_table(){
//   return shmtable.sharedmemory; // obtengo array sharedmemory de tipo sharedmemory
// }

int
is_shared(uint pa){
80108e9c:	55                   	push   %ebp
80108e9d:	89 e5                	mov    %esp,%ebp
80108e9f:	83 ec 28             	sub    $0x28,%esp
  int j;
  struct sharedmemory* shared_array = get_shm_table(); 
80108ea2:	e8 53 c6 ff ff       	call   801054fa <get_shm_table>
80108ea7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int shared = 0;
80108eaa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108eb8:	eb 42                	jmp    80108efc <is_shared+0x60>
    if (p2v(pa) == shared_array[j].addr && shared_array[j].refcount > 0){ // refcount tiene a 2 entonces 
80108eba:	8b 45 08             	mov    0x8(%ebp),%eax
80108ebd:	89 04 24             	mov    %eax,(%esp)
80108ec0:	e8 7d f1 ff ff       	call   80108042 <p2v>
80108ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108ec8:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80108ecf:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108ed2:	01 ca                	add    %ecx,%edx
80108ed4:	8b 12                	mov    (%edx),%edx
80108ed6:	39 d0                	cmp    %edx,%eax
80108ed8:	75 1f                	jne    80108ef9 <is_shared+0x5d>
80108eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108edd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108ee7:	01 d0                	add    %edx,%eax
80108ee9:	8b 40 04             	mov    0x4(%eax),%eax
80108eec:	85 c0                	test   %eax,%eax
80108eee:	7e 09                	jle    80108ef9 <is_shared+0x5d>
      shared = j+1;
80108ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ef3:	40                   	inc    %eax
80108ef4:	89 45 f0             	mov    %eax,-0x10(%ebp)
      break;
80108ef7:	eb 09                	jmp    80108f02 <is_shared+0x66>
  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108ef9:	ff 45 f4             	incl   -0xc(%ebp)
80108efc:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80108f00:	7e b8                	jle    80108eba <is_shared+0x1e>
    }
  }
  return shared; // ahi uno solo
80108f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108f05:	c9                   	leave  
80108f06:	c3                   	ret    
