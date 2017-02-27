
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
8010003a:	c7 44 24 04 58 8e 10 	movl   $0x80108e58,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100049:	e8 3f 55 00 00       	call   8010558d <initlock>

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
801000bd:	e8 ec 54 00 00       	call   801055ae <acquire>

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
80100104:	e8 07 55 00 00       	call   80105610 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 a0 d6 10 	movl   $0x8010d6a0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 c2 49 00 00       	call   80104ae6 <sleep>
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
8010017c:	e8 8f 54 00 00       	call   80105610 <release>
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
80100198:	c7 04 24 5f 8e 10 80 	movl   $0x80108e5f,(%esp)
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
801001ef:	c7 04 24 70 8e 10 80 	movl   $0x80108e70,(%esp)
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
80100229:	c7 04 24 77 8e 10 80 	movl   $0x80108e77,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010023c:	e8 6d 53 00 00       	call   801055ae <acquire>

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
8010029d:	e8 4c 49 00 00       	call   80104bee <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801002a9:	e8 62 53 00 00       	call   80105610 <release>
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
801003bc:	e8 ed 51 00 00       	call   801055ae <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 7e 8e 10 80 	movl   $0x80108e7e,(%esp)
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
801004ad:	c7 45 ec 87 8e 10 80 	movl   $0x80108e87,-0x14(%ebp)
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
8010052f:	e8 dc 50 00 00       	call   80105610 <release>
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
8010055a:	c7 04 24 8e 8e 10 80 	movl   $0x80108e8e,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 9d 8e 10 80 	movl   $0x80108e9d,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 d0 50 00 00       	call   8010565f <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 9f 8e 10 80 	movl   $0x80108e9f,(%esp)
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
80100695:	e8 32 52 00 00       	call   801058cc <memmove>
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
801006c4:	e8 37 51 00 00       	call   80105800 <memset>
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
80100759:	e8 a2 6c 00 00       	call   80107400 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 96 6c 00 00       	call   80107400 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 8a 6c 00 00       	call   80107400 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 7d 6c 00 00       	call   80107400 <uartputc>
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
8010079d:	e8 0c 4e 00 00       	call   801055ae <acquire>
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
801007ca:	e8 ce 44 00 00       	call   80104c9d <procdump>
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
801008ce:	e8 1b 43 00 00       	call   80104bee <wakeup>
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
801008f5:	e8 16 4d 00 00       	call   80105610 <release>
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
8010091a:	e8 8f 4c 00 00       	call   801055ae <acquire>
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
80100938:	e8 d3 4c 00 00       	call   80105610 <release>
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
80100961:	e8 80 41 00 00       	call   80104ae6 <sleep>
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
801009d8:	e8 33 4c 00 00       	call   80105610 <release>
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
80100a0e:	e8 9b 4b 00 00       	call   801055ae <acquire>
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
80100a48:	e8 c3 4b 00 00       	call   80105610 <release>
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
80100a63:	c7 44 24 04 a3 8e 10 	movl   $0x80108ea3,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100a72:	e8 16 4b 00 00       	call   8010558d <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 ab 8e 10 	movl   $0x80108eab,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
80100a86:	e8 02 4b 00 00       	call   8010558d <initlock>

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
80100ab0:	e8 07 30 00 00       	call   80103abc <picenable>
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
80100b43:	e8 dc 79 00 00       	call   80108524 <setupkvm>
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
80100bdc:	e8 09 7d 00 00       	call   801088ea <allocuvm>
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
80100c19:	e8 dd 7b 00 00       	call   801087fb <loaduvm>
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
80100c82:	e8 63 7c 00 00       	call   801088ea <allocuvm>
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
80100ca6:	e8 89 7e 00 00       	call   80108b34 <clearpteu>
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
80100cdb:	e8 7b 4d 00 00       	call   80105a5b <strlen>
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
80100d03:	e8 53 4d 00 00       	call   80105a5b <strlen>
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
80100d31:	e8 09 80 00 00       	call   80108d3f <copyout>
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
80100dd4:	e8 66 7f 00 00       	call   80108d3f <copyout>
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
80100e26:	e8 e7 4b 00 00       	call   80105a12 <safestrcpy>

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
80100e78:	e8 98 77 00 00       	call   80108615 <switchuvm>
  freevm(oldpgdir);
80100e7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e80:	89 04 24             	mov    %eax,(%esp)
80100e83:	e8 13 7c 00 00       	call   80108a9b <freevm>
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
80100eba:	e8 dc 7b 00 00       	call   80108a9b <freevm>
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
80100edd:	c7 44 24 04 b1 8e 10 	movl   $0x80108eb1,0x4(%esp)
80100ee4:	80 
80100ee5:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100eec:	e8 9c 46 00 00       	call   8010558d <initlock>
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
80100f00:	e8 a9 46 00 00       	call   801055ae <acquire>
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
80100f29:	e8 e2 46 00 00       	call   80105610 <release>
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
80100f47:	e8 c4 46 00 00       	call   80105610 <release>
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
80100f60:	e8 49 46 00 00       	call   801055ae <acquire>
  if(f->ref < 1)
80100f65:	8b 45 08             	mov    0x8(%ebp),%eax
80100f68:	8b 40 04             	mov    0x4(%eax),%eax
80100f6b:	85 c0                	test   %eax,%eax
80100f6d:	7f 0c                	jg     80100f7b <filedup+0x28>
    panic("filedup");
80100f6f:	c7 04 24 b8 8e 10 80 	movl   $0x80108eb8,(%esp)
80100f76:	e8 bb f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	8d 50 01             	lea    0x1(%eax),%edx
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100f8a:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f91:	e8 7a 46 00 00       	call   80105610 <release>
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
80100fab:	e8 fe 45 00 00       	call   801055ae <acquire>
  if(f->ref < 1)
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	7f 0c                	jg     80100fc6 <fileclose+0x2b>
    panic("fileclose");
80100fba:	c7 04 24 c0 8e 10 80 	movl   $0x80108ec0,(%esp)
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
80100fe6:	e8 25 46 00 00       	call   80105610 <release>
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
8010101c:	e8 ef 45 00 00       	call   80105610 <release>
  
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
80101039:	e8 32 2d 00 00       	call   80103d70 <pipeclose>
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
801010ef:	e8 fe 2d 00 00       	call   80103ef2 <piperead>
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
80101161:	c7 04 24 ca 8e 10 80 	movl   $0x80108eca,(%esp)
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
801011ab:	e8 52 2c 00 00       	call   80103e02 <pipewrite>
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
8010126c:	c7 04 24 d3 8e 10 80 	movl   $0x80108ed3,(%esp)
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
801012a1:	c7 04 24 e3 8e 10 80 	movl   $0x80108ee3,(%esp)
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
801012e7:	e8 e0 45 00 00       	call   801058cc <memmove>
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
8010132d:	e8 ce 44 00 00       	call   80105800 <memset>
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
80101495:	c7 04 24 ed 8e 10 80 	movl   $0x80108eed,(%esp)
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
80101538:	c7 04 24 03 8f 10 80 	movl   $0x80108f03,(%esp)
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
8010158d:	c7 44 24 04 16 8f 10 	movl   $0x80108f16,0x4(%esp)
80101594:	80 
80101595:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010159c:	e8 ec 3f 00 00       	call   8010558d <initlock>
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
80101626:	e8 d5 41 00 00       	call   80105800 <memset>
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
8010167d:	c7 04 24 1d 8f 10 80 	movl   $0x80108f1d,(%esp)
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
80101724:	e8 a3 41 00 00       	call   801058cc <memmove>
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
8010174e:	e8 5b 3e 00 00       	call   801055ae <acquire>

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
80101798:	e8 73 3e 00 00       	call   80105610 <release>
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
801017cb:	c7 04 24 2f 8f 10 80 	movl   $0x80108f2f,(%esp)
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
80101809:	e8 02 3e 00 00       	call   80105610 <release>

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
80101820:	e8 89 3d 00 00       	call   801055ae <acquire>
  ip->ref++;
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 08             	mov    0x8(%eax),%eax
8010182b:	8d 50 01             	lea    0x1(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101834:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010183b:	e8 d0 3d 00 00       	call   80105610 <release>
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
8010185b:	c7 04 24 3f 8f 10 80 	movl   $0x80108f3f,(%esp)
80101862:	e8 cf ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101867:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010186e:	e8 3b 3d 00 00       	call   801055ae <acquire>
  while(ip->flags & I_BUSY)
80101873:	eb 13                	jmp    80101888 <ilock+0x43>
    sleep(ip, &icache.lock);
80101875:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
8010187c:	80 
8010187d:	8b 45 08             	mov    0x8(%ebp),%eax
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 5e 32 00 00       	call   80104ae6 <sleep>
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
801018ad:	e8 5e 3d 00 00       	call   80105610 <release>

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
80101956:	e8 71 3f 00 00       	call   801058cc <memmove>
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
80101982:	c7 04 24 45 8f 10 80 	movl   $0x80108f45,(%esp)
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
801019b3:	c7 04 24 54 8f 10 80 	movl   $0x80108f54,(%esp)
801019ba:	e8 77 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019bf:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019c6:	e8 e3 3b 00 00       	call   801055ae <acquire>
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
801019e2:	e8 07 32 00 00       	call   80104bee <wakeup>
  release(&icache.lock);
801019e7:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019ee:	e8 1d 3c 00 00       	call   80105610 <release>
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
80101a02:	e8 a7 3b 00 00       	call   801055ae <acquire>
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
80101a40:	c7 04 24 5c 8f 10 80 	movl   $0x80108f5c,(%esp)
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
80101a64:	e8 a7 3b 00 00       	call   80105610 <release>
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
80101a8f:	e8 1a 3b 00 00       	call   801055ae <acquire>
    ip->flags = 0;
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 04 24             	mov    %eax,(%esp)
80101aa4:	e8 45 31 00 00       	call   80104bee <wakeup>
  }
  ip->ref--;
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 40 08             	mov    0x8(%eax),%eax
80101aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ab8:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101abf:	e8 4c 3b 00 00       	call   80105610 <release>
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
80101bdf:	c7 04 24 66 8f 10 80 	movl   $0x80108f66,(%esp)
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
80101e7e:	e8 49 3a 00 00       	call   801058cc <memmove>
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
80101fde:	e8 e9 38 00 00       	call   801058cc <memmove>
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
8010205c:	e8 07 39 00 00       	call   80105968 <strncmp>
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
80102075:	c7 04 24 79 8f 10 80 	movl   $0x80108f79,(%esp)
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
801020b3:	c7 04 24 8b 8f 10 80 	movl   $0x80108f8b,(%esp)
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
80102195:	c7 04 24 8b 8f 10 80 	movl   $0x80108f8b,(%esp)
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
801021da:	e8 d9 37 00 00       	call   801059b8 <strncpy>
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
8010220c:	c7 04 24 98 8f 10 80 	movl   $0x80108f98,(%esp)
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
8010228d:	e8 3a 36 00 00       	call   801058cc <memmove>
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
801022a8:	e8 1f 36 00 00       	call   801058cc <memmove>
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
801024fb:	c7 44 24 04 a0 8f 10 	movl   $0x80108fa0,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010250a:	e8 7e 30 00 00       	call   8010558d <initlock>
  picenable(IRQ_IDE);
8010250f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102516:	e8 a1 15 00 00       	call   80103abc <picenable>
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
801025a4:	c7 04 24 a4 8f 10 80 	movl   $0x80108fa4,(%esp)
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
801026ca:	e8 df 2e 00 00       	call   801055ae <acquire>
  if((b = idequeue) == 0){
801026cf:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026db:	75 11                	jne    801026ee <ideintr+0x31>
    release(&idelock);
801026dd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801026e4:	e8 27 2f 00 00       	call   80105610 <release>
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
80102757:	e8 92 24 00 00       	call   80104bee <wakeup>
  
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
80102779:	e8 92 2e 00 00       	call   80105610 <release>
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
80102792:	c7 04 24 ad 8f 10 80 	movl   $0x80108fad,(%esp)
80102799:	e8 98 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	8b 00                	mov    (%eax),%eax
801027a3:	83 e0 06             	and    $0x6,%eax
801027a6:	83 f8 02             	cmp    $0x2,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x37>
    panic("iderw: nothing to do");
801027ab:	c7 04 24 c1 8f 10 80 	movl   $0x80108fc1,(%esp)
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
801027ca:	c7 04 24 d6 8f 10 80 	movl   $0x80108fd6,(%esp)
801027d1:	e8 60 dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027d6:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801027dd:	e8 cc 2d 00 00       	call   801055ae <acquire>

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
80102836:	e8 ab 22 00 00       	call   80104ae6 <sleep>
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
80102852:	e8 b9 2d 00 00       	call   80105610 <release>
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
801028dd:	c7 04 24 f4 8f 10 80 	movl   $0x80108ff4,(%esp)
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
80102996:	c7 44 24 04 26 90 10 	movl   $0x80109026,0x4(%esp)
8010299d:	80 
8010299e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
801029a5:	e8 e3 2b 00 00       	call   8010558d <initlock>
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
80102a52:	c7 04 24 2b 90 10 80 	movl   $0x8010902b,(%esp)
80102a59:	e8 d8 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a65:	00 
80102a66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a6d:	00 
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 87 2d 00 00       	call   80105800 <memset>

  if(kmem.use_lock)
80102a79:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102a7e:	85 c0                	test   %eax,%eax
80102a80:	74 0c                	je     80102a8e <kfree+0x69>
    acquire(&kmem.lock);
80102a82:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102a89:	e8 20 2b 00 00       	call   801055ae <acquire>
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
80102ab7:	e8 54 2b 00 00       	call   80105610 <release>
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
80102ad4:	e8 d5 2a 00 00       	call   801055ae <acquire>
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
80102b01:	e8 0a 2b 00 00       	call   80105610 <release>
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
80102e74:	c7 04 24 34 90 10 80 	movl   $0x80109034,(%esp)
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
80102fcb:	c7 44 24 04 60 90 10 	movl   $0x80109060,0x4(%esp)
80102fd2:	80 
80102fd3:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80102fda:	e8 ae 25 00 00       	call   8010558d <initlock>
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
8010308e:	e8 39 28 00 00       	call   801058cc <memmove>
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
801031dd:	e8 cc 23 00 00       	call   801055ae <acquire>
  while (log.busy) {
801031e2:	eb 14                	jmp    801031f8 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e4:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
801031eb:	80 
801031ec:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801031f3:	e8 ee 18 00 00       	call   80104ae6 <sleep>
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
80103212:	e8 f9 23 00 00       	call   80105610 <release>
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
80103248:	e8 61 23 00 00       	call   801055ae <acquire>
  log.busy = 0;
8010324d:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
80103254:	00 00 00 
  wakeup(&log);
80103257:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010325e:	e8 8b 19 00 00       	call   80104bee <wakeup>
  release(&log.lock);
80103263:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010326a:	e8 a1 23 00 00       	call   80105610 <release>
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
80103291:	c7 04 24 64 90 10 80 	movl   $0x80109064,(%esp)
80103298:	e8 99 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010329d:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	75 0c                	jne    801032b2 <log_write+0x41>
    panic("write outside of trans");
801032a6:	c7 04 24 7a 90 10 80 	movl   $0x8010907a,(%esp)
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
80103335:	e8 92 25 00 00       	call   801058cc <memmove>
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
801033d2:	e8 0a 52 00 00       	call   801085e1 <kvmalloc>
  mpinit();        // collect info about this machine
801033d7:	e8 ae 04 00 00       	call   8010388a <mpinit>
  lapicinit();
801033dc:	e8 07 f9 ff ff       	call   80102ce8 <lapicinit>
  seginit();       // set up segments
801033e1:	e8 b7 4b 00 00       	call   80107f9d <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033ec:	8a 00                	mov    (%eax),%al
801033ee:	0f b6 c0             	movzbl %al,%eax
801033f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f5:	c7 04 24 91 90 10 80 	movl   $0x80109091,(%esp)
801033fc:	e8 a0 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103401:	e8 ea 06 00 00       	call   80103af0 <picinit>
  ioapicinit();    // another interrupt controller
80103406:	e8 7f f4 ff ff       	call   8010288a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010340b:	e8 4d d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103410:	e8 dd 3e 00 00       	call   801072f2 <uartinit>
  pinit();         // process table
80103415:	e8 e4 0b 00 00       	call   80103ffe <pinit>
  tvinit();        // trap vectors
8010341a:	e8 86 3a 00 00       	call   80106ea5 <tvinit>
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
8010343c:	e8 ac 39 00 00       	call   80106ded <timerinit>
  startothers();   // start other processors
80103441:	e8 99 00 00 00       	call   801034df <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103446:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010344d:	8e 
8010344e:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103455:	e8 6e f5 ff ff       	call   801029c8 <kinit2>
  userinit();      // first user process
8010345a:	e8 8b 0e 00 00       	call   801042ea <userinit>
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
8010346a:	e8 89 51 00 00       	call   801085f8 <switchkvm>
  seginit();
8010346f:	e8 29 4b 00 00       	call   80107f9d <seginit>
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
80103493:	c7 04 24 a8 90 10 80 	movl   $0x801090a8,(%esp)
8010349a:	e8 02 cf ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
8010349f:	e8 5e 3b 00 00       	call   80107002 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034aa:	05 a8 00 00 00       	add    $0xa8,%eax
801034af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034b6:	00 
801034b7:	89 04 24             	mov    %eax,(%esp)
801034ba:	e8 d1 fe ff ff       	call   80103390 <xchg>
  
  cprintf("cpu%d: starting\n", cpu->id);
801034bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034c5:	8a 00                	mov    (%eax),%al
801034c7:	0f b6 c0             	movzbl %al,%eax
801034ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801034ce:	c7 04 24 a8 90 10 80 	movl   $0x801090a8,(%esp)
801034d5:	e8 c7 ce ff ff       	call   801003a1 <cprintf>
  scheduler();     // start running processes
801034da:	e8 0d 14 00 00       	call   801048ec <scheduler>

801034df <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801034df:	55                   	push   %ebp
801034e0:	89 e5                	mov    %esp,%ebp
801034e2:	53                   	push   %ebx
801034e3:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801034e6:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
801034ed:	e8 91 fe ff ff       	call   80103383 <p2v>
801034f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801034f5:	b8 8a 00 00 00       	mov    $0x8a,%eax
801034fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801034fe:	c7 44 24 04 4c c5 10 	movl   $0x8010c54c,0x4(%esp)
80103505:	80 
80103506:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103509:	89 04 24             	mov    %eax,(%esp)
8010350c:	e8 bb 23 00 00       	call   801058cc <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103511:	c7 45 f4 60 09 11 80 	movl   $0x80110960,-0xc(%ebp)
80103518:	e9 8f 00 00 00       	jmp    801035ac <startothers+0xcd>
    if(c == cpus+cpunum())  // We've started already.
8010351d:	e8 23 f9 ff ff       	call   80102e45 <cpunum>
80103522:	89 c2                	mov    %eax,%edx
80103524:	89 d0                	mov    %edx,%eax
80103526:	d1 e0                	shl    %eax
80103528:	01 d0                	add    %edx,%eax
8010352a:	c1 e0 04             	shl    $0x4,%eax
8010352d:	29 d0                	sub    %edx,%eax
8010352f:	c1 e0 02             	shl    $0x2,%eax
80103532:	05 60 09 11 80       	add    $0x80110960,%eax
80103537:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010353a:	74 68                	je     801035a4 <startothers+0xc5>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010353c:	e8 7d f5 ff ff       	call   80102abe <kalloc>
80103541:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103544:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103547:	83 e8 04             	sub    $0x4,%eax
8010354a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010354d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103553:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103555:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103558:	83 e8 08             	sub    $0x8,%eax
8010355b:	c7 00 64 34 10 80    	movl   $0x80103464,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103561:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103564:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103567:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
8010356e:	e8 03 fe ff ff       	call   80103376 <v2p>
80103573:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103575:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103578:	89 04 24             	mov    %eax,(%esp)
8010357b:	e8 f6 fd ff ff       	call   80103376 <v2p>
80103580:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103583:	8a 12                	mov    (%edx),%dl
80103585:	0f b6 d2             	movzbl %dl,%edx
80103588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010358c:	89 14 24             	mov    %edx,(%esp)
8010358f:	e8 35 f9 ff ff       	call   80102ec9 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103594:	90                   	nop
80103595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103598:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010359e:	85 c0                	test   %eax,%eax
801035a0:	74 f3                	je     80103595 <startothers+0xb6>
801035a2:	eb 01                	jmp    801035a5 <startothers+0xc6>
      continue;
801035a4:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
801035a5:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035ac:	a1 40 0f 11 80       	mov    0x80110f40,%eax
801035b1:	89 c2                	mov    %eax,%edx
801035b3:	89 d0                	mov    %edx,%eax
801035b5:	d1 e0                	shl    %eax
801035b7:	01 d0                	add    %edx,%eax
801035b9:	c1 e0 04             	shl    $0x4,%eax
801035bc:	29 d0                	sub    %edx,%eax
801035be:	c1 e0 02             	shl    $0x2,%eax
801035c1:	05 60 09 11 80       	add    $0x80110960,%eax
801035c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035c9:	0f 87 4e ff ff ff    	ja     8010351d <startothers+0x3e>
      ;
  }
}
801035cf:	83 c4 24             	add    $0x24,%esp
801035d2:	5b                   	pop    %ebx
801035d3:	5d                   	pop    %ebp
801035d4:	c3                   	ret    

801035d5 <p2v>:
801035d5:	55                   	push   %ebp
801035d6:	89 e5                	mov    %esp,%ebp
801035d8:	8b 45 08             	mov    0x8(%ebp),%eax
801035db:	05 00 00 00 80       	add    $0x80000000,%eax
801035e0:	5d                   	pop    %ebp
801035e1:	c3                   	ret    

801035e2 <inb>:
{
801035e2:	55                   	push   %ebp
801035e3:	89 e5                	mov    %esp,%ebp
801035e5:	53                   	push   %ebx
801035e6:	83 ec 14             	sub    $0x14,%esp
801035e9:	8b 45 08             	mov    0x8(%ebp),%eax
801035ec:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
801035f3:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801035f7:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801035fb:	ec                   	in     (%dx),%al
801035fc:	88 c3                	mov    %al,%bl
801035fe:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103601:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80103604:	83 c4 14             	add    $0x14,%esp
80103607:	5b                   	pop    %ebx
80103608:	5d                   	pop    %ebp
80103609:	c3                   	ret    

8010360a <outb>:
{
8010360a:	55                   	push   %ebp
8010360b:	89 e5                	mov    %esp,%ebp
8010360d:	83 ec 08             	sub    $0x8,%esp
80103610:	8b 45 08             	mov    0x8(%ebp),%eax
80103613:	8b 55 0c             	mov    0xc(%ebp),%edx
80103616:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010361a:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010361d:	8a 45 f8             	mov    -0x8(%ebp),%al
80103620:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103623:	ee                   	out    %al,(%dx)
}
80103624:	c9                   	leave  
80103625:	c3                   	ret    

80103626 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103626:	55                   	push   %ebp
80103627:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103629:	a1 84 c6 10 80       	mov    0x8010c684,%eax
8010362e:	89 c2                	mov    %eax,%edx
80103630:	b8 60 09 11 80       	mov    $0x80110960,%eax
80103635:	89 d1                	mov    %edx,%ecx
80103637:	29 c1                	sub    %eax,%ecx
80103639:	89 c8                	mov    %ecx,%eax
8010363b:	89 c2                	mov    %eax,%edx
8010363d:	c1 fa 02             	sar    $0x2,%edx
80103640:	89 d0                	mov    %edx,%eax
80103642:	c1 e0 03             	shl    $0x3,%eax
80103645:	01 d0                	add    %edx,%eax
80103647:	c1 e0 03             	shl    $0x3,%eax
8010364a:	01 d0                	add    %edx,%eax
8010364c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80103653:	01 c8                	add    %ecx,%eax
80103655:	c1 e0 03             	shl    $0x3,%eax
80103658:	01 d0                	add    %edx,%eax
8010365a:	c1 e0 03             	shl    $0x3,%eax
8010365d:	29 d0                	sub    %edx,%eax
8010365f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
80103666:	01 c8                	add    %ecx,%eax
80103668:	c1 e0 02             	shl    $0x2,%eax
8010366b:	01 d0                	add    %edx,%eax
8010366d:	c1 e0 03             	shl    $0x3,%eax
80103670:	29 d0                	sub    %edx,%eax
80103672:	89 c1                	mov    %eax,%ecx
80103674:	c1 e1 07             	shl    $0x7,%ecx
80103677:	01 c8                	add    %ecx,%eax
80103679:	d1 e0                	shl    %eax
8010367b:	01 d0                	add    %edx,%eax
}
8010367d:	5d                   	pop    %ebp
8010367e:	c3                   	ret    

8010367f <sum>:

static uchar
sum(uchar *addr, int len)
{
8010367f:	55                   	push   %ebp
80103680:	89 e5                	mov    %esp,%ebp
80103682:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010368c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103693:	eb 13                	jmp    801036a8 <sum+0x29>
    sum += addr[i];
80103695:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103698:	8b 45 08             	mov    0x8(%ebp),%eax
8010369b:	01 d0                	add    %edx,%eax
8010369d:	8a 00                	mov    (%eax),%al
8010369f:	0f b6 c0             	movzbl %al,%eax
801036a2:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
801036a5:	ff 45 fc             	incl   -0x4(%ebp)
801036a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036ae:	7c e5                	jl     80103695 <sum+0x16>
  return sum;
801036b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801036b3:	c9                   	leave  
801036b4:	c3                   	ret    

801036b5 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036b5:	55                   	push   %ebp
801036b6:	89 e5                	mov    %esp,%ebp
801036b8:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036bb:	8b 45 08             	mov    0x8(%ebp),%eax
801036be:	89 04 24             	mov    %eax,(%esp)
801036c1:	e8 0f ff ff ff       	call   801035d5 <p2v>
801036c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801036c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801036cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036cf:	01 d0                	add    %edx,%eax
801036d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801036da:	eb 3f                	jmp    8010371b <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036dc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036e3:	00 
801036e4:	c7 44 24 04 bc 90 10 	movl   $0x801090bc,0x4(%esp)
801036eb:	80 
801036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ef:	89 04 24             	mov    %eax,(%esp)
801036f2:	e8 80 21 00 00       	call   80105877 <memcmp>
801036f7:	85 c0                	test   %eax,%eax
801036f9:	75 1c                	jne    80103717 <mpsearch1+0x62>
801036fb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103702:	00 
80103703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103706:	89 04 24             	mov    %eax,(%esp)
80103709:	e8 71 ff ff ff       	call   8010367f <sum>
8010370e:	84 c0                	test   %al,%al
80103710:	75 05                	jne    80103717 <mpsearch1+0x62>
      return (struct mp*)p;
80103712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103715:	eb 11                	jmp    80103728 <mpsearch1+0x73>
  for(p = addr; p < e; p += sizeof(struct mp))
80103717:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010371e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103721:	72 b9                	jb     801036dc <mpsearch1+0x27>
  return 0;
80103723:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103728:	c9                   	leave  
80103729:	c3                   	ret    

8010372a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010372a:	55                   	push   %ebp
8010372b:	89 e5                	mov    %esp,%ebp
8010372d:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103730:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373a:	83 c0 0f             	add    $0xf,%eax
8010373d:	8a 00                	mov    (%eax),%al
8010373f:	0f b6 c0             	movzbl %al,%eax
80103742:	89 c2                	mov    %eax,%edx
80103744:	c1 e2 08             	shl    $0x8,%edx
80103747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374a:	83 c0 0e             	add    $0xe,%eax
8010374d:	8a 00                	mov    (%eax),%al
8010374f:	0f b6 c0             	movzbl %al,%eax
80103752:	09 d0                	or     %edx,%eax
80103754:	c1 e0 04             	shl    $0x4,%eax
80103757:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010375a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010375e:	74 21                	je     80103781 <mpsearch+0x57>
    if((mp = mpsearch1(p, 1024)))
80103760:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103767:	00 
80103768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376b:	89 04 24             	mov    %eax,(%esp)
8010376e:	e8 42 ff ff ff       	call   801036b5 <mpsearch1>
80103773:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103776:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010377a:	74 4e                	je     801037ca <mpsearch+0xa0>
      return mp;
8010377c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010377f:	eb 5d                	jmp    801037de <mpsearch+0xb4>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103784:	83 c0 14             	add    $0x14,%eax
80103787:	8a 00                	mov    (%eax),%al
80103789:	0f b6 c0             	movzbl %al,%eax
8010378c:	89 c2                	mov    %eax,%edx
8010378e:	c1 e2 08             	shl    $0x8,%edx
80103791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103794:	83 c0 13             	add    $0x13,%eax
80103797:	8a 00                	mov    (%eax),%al
80103799:	0f b6 c0             	movzbl %al,%eax
8010379c:	09 d0                	or     %edx,%eax
8010379e:	c1 e0 0a             	shl    $0xa,%eax
801037a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037a7:	2d 00 04 00 00       	sub    $0x400,%eax
801037ac:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037b3:	00 
801037b4:	89 04 24             	mov    %eax,(%esp)
801037b7:	e8 f9 fe ff ff       	call   801036b5 <mpsearch1>
801037bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037c3:	74 05                	je     801037ca <mpsearch+0xa0>
      return mp;
801037c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037c8:	eb 14                	jmp    801037de <mpsearch+0xb4>
  }
  return mpsearch1(0xF0000, 0x10000);
801037ca:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037d1:	00 
801037d2:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037d9:	e8 d7 fe ff ff       	call   801036b5 <mpsearch1>
}
801037de:	c9                   	leave  
801037df:	c3                   	ret    

801037e0 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037e6:	e8 3f ff ff ff       	call   8010372a <mpsearch>
801037eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037f2:	74 0a                	je     801037fe <mpconfig+0x1e>
801037f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037f7:	8b 40 04             	mov    0x4(%eax),%eax
801037fa:	85 c0                	test   %eax,%eax
801037fc:	75 0a                	jne    80103808 <mpconfig+0x28>
    return 0;
801037fe:	b8 00 00 00 00       	mov    $0x0,%eax
80103803:	e9 80 00 00 00       	jmp    80103888 <mpconfig+0xa8>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380b:	8b 40 04             	mov    0x4(%eax),%eax
8010380e:	89 04 24             	mov    %eax,(%esp)
80103811:	e8 bf fd ff ff       	call   801035d5 <p2v>
80103816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103819:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103820:	00 
80103821:	c7 44 24 04 c1 90 10 	movl   $0x801090c1,0x4(%esp)
80103828:	80 
80103829:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010382c:	89 04 24             	mov    %eax,(%esp)
8010382f:	e8 43 20 00 00       	call   80105877 <memcmp>
80103834:	85 c0                	test   %eax,%eax
80103836:	74 07                	je     8010383f <mpconfig+0x5f>
    return 0;
80103838:	b8 00 00 00 00       	mov    $0x0,%eax
8010383d:	eb 49                	jmp    80103888 <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
8010383f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103842:	8a 40 06             	mov    0x6(%eax),%al
80103845:	3c 01                	cmp    $0x1,%al
80103847:	74 11                	je     8010385a <mpconfig+0x7a>
80103849:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010384c:	8a 40 06             	mov    0x6(%eax),%al
8010384f:	3c 04                	cmp    $0x4,%al
80103851:	74 07                	je     8010385a <mpconfig+0x7a>
    return 0;
80103853:	b8 00 00 00 00       	mov    $0x0,%eax
80103858:	eb 2e                	jmp    80103888 <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
8010385a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010385d:	8b 40 04             	mov    0x4(%eax),%eax
80103860:	0f b7 c0             	movzwl %ax,%eax
80103863:	89 44 24 04          	mov    %eax,0x4(%esp)
80103867:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010386a:	89 04 24             	mov    %eax,(%esp)
8010386d:	e8 0d fe ff ff       	call   8010367f <sum>
80103872:	84 c0                	test   %al,%al
80103874:	74 07                	je     8010387d <mpconfig+0x9d>
    return 0;
80103876:	b8 00 00 00 00       	mov    $0x0,%eax
8010387b:	eb 0b                	jmp    80103888 <mpconfig+0xa8>
  *pmp = mp;
8010387d:	8b 45 08             	mov    0x8(%ebp),%eax
80103880:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103883:	89 10                	mov    %edx,(%eax)
  return conf;
80103885:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103888:	c9                   	leave  
80103889:	c3                   	ret    

8010388a <mpinit>:

void
mpinit(void)
{
8010388a:	55                   	push   %ebp
8010388b:	89 e5                	mov    %esp,%ebp
8010388d:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103890:	c7 05 84 c6 10 80 60 	movl   $0x80110960,0x8010c684
80103897:	09 11 80 
  if((conf = mpconfig(&mp)) == 0)
8010389a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010389d:	89 04 24             	mov    %eax,(%esp)
801038a0:	e8 3b ff ff ff       	call   801037e0 <mpconfig>
801038a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801038a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801038ac:	0f 84 a4 01 00 00    	je     80103a56 <mpinit+0x1cc>
    return;
  ismp = 1;
801038b2:	c7 05 44 09 11 80 01 	movl   $0x1,0x80110944
801038b9:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038bf:	8b 40 24             	mov    0x24(%eax),%eax
801038c2:	a3 bc 08 11 80       	mov    %eax,0x801108bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038ca:	83 c0 2c             	add    $0x2c,%eax
801038cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d3:	8b 40 04             	mov    0x4(%eax),%eax
801038d6:	0f b7 d0             	movzwl %ax,%edx
801038d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038dc:	01 d0                	add    %edx,%eax
801038de:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038e1:	e9 fe 00 00 00       	jmp    801039e4 <mpinit+0x15a>
    switch(*p){
801038e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e9:	8a 00                	mov    (%eax),%al
801038eb:	0f b6 c0             	movzbl %al,%eax
801038ee:	83 f8 04             	cmp    $0x4,%eax
801038f1:	0f 87 cb 00 00 00    	ja     801039c2 <mpinit+0x138>
801038f7:	8b 04 85 04 91 10 80 	mov    -0x7fef6efc(,%eax,4),%eax
801038fe:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103903:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103906:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103909:	8a 40 01             	mov    0x1(%eax),%al
8010390c:	0f b6 d0             	movzbl %al,%edx
8010390f:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103914:	39 c2                	cmp    %eax,%edx
80103916:	74 2c                	je     80103944 <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103918:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010391b:	8a 40 01             	mov    0x1(%eax),%al
8010391e:	0f b6 d0             	movzbl %al,%edx
80103921:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103926:	89 54 24 08          	mov    %edx,0x8(%esp)
8010392a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010392e:	c7 04 24 c6 90 10 80 	movl   $0x801090c6,(%esp)
80103935:	e8 67 ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
8010393a:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
80103941:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103944:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103947:	8a 40 03             	mov    0x3(%eax),%al
8010394a:	0f b6 c0             	movzbl %al,%eax
8010394d:	83 e0 02             	and    $0x2,%eax
80103950:	85 c0                	test   %eax,%eax
80103952:	74 1e                	je     80103972 <mpinit+0xe8>
        bcpu = &cpus[ncpu];
80103954:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
8010395a:	89 d0                	mov    %edx,%eax
8010395c:	d1 e0                	shl    %eax
8010395e:	01 d0                	add    %edx,%eax
80103960:	c1 e0 04             	shl    $0x4,%eax
80103963:	29 d0                	sub    %edx,%eax
80103965:	c1 e0 02             	shl    $0x2,%eax
80103968:	05 60 09 11 80       	add    $0x80110960,%eax
8010396d:	a3 84 c6 10 80       	mov    %eax,0x8010c684
      cpus[ncpu].id = ncpu;
80103972:	8b 15 40 0f 11 80    	mov    0x80110f40,%edx
80103978:	a1 40 0f 11 80       	mov    0x80110f40,%eax
8010397d:	88 c1                	mov    %al,%cl
8010397f:	89 d0                	mov    %edx,%eax
80103981:	d1 e0                	shl    %eax
80103983:	01 d0                	add    %edx,%eax
80103985:	c1 e0 04             	shl    $0x4,%eax
80103988:	29 d0                	sub    %edx,%eax
8010398a:	c1 e0 02             	shl    $0x2,%eax
8010398d:	05 60 09 11 80       	add    $0x80110960,%eax
80103992:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103994:	a1 40 0f 11 80       	mov    0x80110f40,%eax
80103999:	40                   	inc    %eax
8010399a:	a3 40 0f 11 80       	mov    %eax,0x80110f40
      p += sizeof(struct mpproc);
8010399f:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
801039a3:	eb 3f                	jmp    801039e4 <mpinit+0x15a>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
801039a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801039ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039ae:	8a 40 01             	mov    0x1(%eax),%al
801039b1:	a2 40 09 11 80       	mov    %al,0x80110940
      p += sizeof(struct mpioapic);
801039b6:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039ba:	eb 28                	jmp    801039e4 <mpinit+0x15a>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039bc:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039c0:	eb 22                	jmp    801039e4 <mpinit+0x15a>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c5:	8a 00                	mov    (%eax),%al
801039c7:	0f b6 c0             	movzbl %al,%eax
801039ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ce:	c7 04 24 e4 90 10 80 	movl   $0x801090e4,(%esp)
801039d5:	e8 c7 c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039da:	c7 05 44 09 11 80 00 	movl   $0x0,0x80110944
801039e1:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039ea:	0f 82 f6 fe ff ff    	jb     801038e6 <mpinit+0x5c>
    }
  }
  if(!ismp){
801039f0:	a1 44 09 11 80       	mov    0x80110944,%eax
801039f5:	85 c0                	test   %eax,%eax
801039f7:	75 1d                	jne    80103a16 <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039f9:	c7 05 40 0f 11 80 01 	movl   $0x1,0x80110f40
80103a00:	00 00 00 
    lapic = 0;
80103a03:	c7 05 bc 08 11 80 00 	movl   $0x0,0x801108bc
80103a0a:	00 00 00 
    ioapicid = 0;
80103a0d:	c6 05 40 09 11 80 00 	movb   $0x0,0x80110940
80103a14:	eb 40                	jmp    80103a56 <mpinit+0x1cc>
    return;
  }

  if(mp->imcrp){
80103a16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a19:	8a 40 0c             	mov    0xc(%eax),%al
80103a1c:	84 c0                	test   %al,%al
80103a1e:	74 36                	je     80103a56 <mpinit+0x1cc>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a20:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a27:	00 
80103a28:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a2f:	e8 d6 fb ff ff       	call   8010360a <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a34:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a3b:	e8 a2 fb ff ff       	call   801035e2 <inb>
80103a40:	83 c8 01             	or     $0x1,%eax
80103a43:	0f b6 c0             	movzbl %al,%eax
80103a46:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a4a:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a51:	e8 b4 fb ff ff       	call   8010360a <outb>
  }
}
80103a56:	c9                   	leave  
80103a57:	c3                   	ret    

80103a58 <outb>:
{
80103a58:	55                   	push   %ebp
80103a59:	89 e5                	mov    %esp,%ebp
80103a5b:	83 ec 08             	sub    $0x8,%esp
80103a5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103a61:	8b 55 0c             	mov    0xc(%ebp),%edx
80103a64:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103a68:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a6b:	8a 45 f8             	mov    -0x8(%ebp),%al
80103a6e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103a71:	ee                   	out    %al,(%dx)
}
80103a72:	c9                   	leave  
80103a73:	c3                   	ret    

80103a74 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	83 ec 0c             	sub    $0xc,%esp
80103a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a84:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103a8d:	0f b6 c0             	movzbl %al,%eax
80103a90:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a94:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a9b:	e8 b8 ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103aa0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103aa3:	66 c1 e8 08          	shr    $0x8,%ax
80103aa7:	0f b6 c0             	movzbl %al,%eax
80103aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
80103aae:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ab5:	e8 9e ff ff ff       	call   80103a58 <outb>
}
80103aba:	c9                   	leave  
80103abb:	c3                   	ret    

80103abc <picenable>:

void
picenable(int irq)
{
80103abc:	55                   	push   %ebp
80103abd:	89 e5                	mov    %esp,%ebp
80103abf:	53                   	push   %ebx
80103ac0:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ac6:	ba 01 00 00 00       	mov    $0x1,%edx
80103acb:	89 d3                	mov    %edx,%ebx
80103acd:	88 c1                	mov    %al,%cl
80103acf:	d3 e3                	shl    %cl,%ebx
80103ad1:	89 d8                	mov    %ebx,%eax
80103ad3:	89 c2                	mov    %eax,%edx
80103ad5:	f7 d2                	not    %edx
80103ad7:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103add:	21 d0                	and    %edx,%eax
80103adf:	0f b7 c0             	movzwl %ax,%eax
80103ae2:	89 04 24             	mov    %eax,(%esp)
80103ae5:	e8 8a ff ff ff       	call   80103a74 <picsetmask>
}
80103aea:	83 c4 04             	add    $0x4,%esp
80103aed:	5b                   	pop    %ebx
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    

80103af0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103af6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103afd:	00 
80103afe:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b05:	e8 4e ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b0a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b11:	00 
80103b12:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b19:	e8 3a ff ff ff       	call   80103a58 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b1e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b25:	00 
80103b26:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b2d:	e8 26 ff ff ff       	call   80103a58 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b32:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b39:	00 
80103b3a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b41:	e8 12 ff ff ff       	call   80103a58 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b46:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b4d:	00 
80103b4e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b55:	e8 fe fe ff ff       	call   80103a58 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b5a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b61:	00 
80103b62:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b69:	e8 ea fe ff ff       	call   80103a58 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b6e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b75:	00 
80103b76:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b7d:	e8 d6 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b82:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b89:	00 
80103b8a:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b91:	e8 c2 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b96:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103b9d:	00 
80103b9e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ba5:	e8 ae fe ff ff       	call   80103a58 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103baa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bb1:	00 
80103bb2:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bb9:	e8 9a fe ff ff       	call   80103a58 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bbe:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bc5:	00 
80103bc6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bcd:	e8 86 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bd2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bd9:	00 
80103bda:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103be1:	e8 72 fe ff ff       	call   80103a58 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103be6:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bed:	00 
80103bee:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bf5:	e8 5e fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103bfa:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c01:	00 
80103c02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c09:	e8 4a fe ff ff       	call   80103a58 <outb>

  if(irqmask != 0xFFFF)
80103c0e:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103c14:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c18:	74 11                	je     80103c2b <picinit+0x13b>
    picsetmask(irqmask);
80103c1a:	66 a1 00 c0 10 80    	mov    0x8010c000,%ax
80103c20:	0f b7 c0             	movzwl %ax,%eax
80103c23:	89 04 24             	mov    %eax,(%esp)
80103c26:	e8 49 fe ff ff       	call   80103a74 <picsetmask>
}
80103c2b:	c9                   	leave  
80103c2c:	c3                   	ret    

80103c2d <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c2d:	55                   	push   %ebp
80103c2e:	89 e5                	mov    %esp,%ebp
80103c30:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c43:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c46:	8b 10                	mov    (%eax),%edx
80103c48:	8b 45 08             	mov    0x8(%ebp),%eax
80103c4b:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c4d:	e8 a1 d2 ff ff       	call   80100ef3 <filealloc>
80103c52:	8b 55 08             	mov    0x8(%ebp),%edx
80103c55:	89 02                	mov    %eax,(%edx)
80103c57:	8b 45 08             	mov    0x8(%ebp),%eax
80103c5a:	8b 00                	mov    (%eax),%eax
80103c5c:	85 c0                	test   %eax,%eax
80103c5e:	0f 84 c8 00 00 00    	je     80103d2c <pipealloc+0xff>
80103c64:	e8 8a d2 ff ff       	call   80100ef3 <filealloc>
80103c69:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c6c:	89 02                	mov    %eax,(%edx)
80103c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c71:	8b 00                	mov    (%eax),%eax
80103c73:	85 c0                	test   %eax,%eax
80103c75:	0f 84 b1 00 00 00    	je     80103d2c <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c7b:	e8 3e ee ff ff       	call   80102abe <kalloc>
80103c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c87:	0f 84 9e 00 00 00    	je     80103d2b <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c90:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c97:	00 00 00 
  p->writeopen = 1;
80103c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ca4:	00 00 00 
  p->nwrite = 0;
80103ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103caa:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cb1:	00 00 00 
  p->nread = 0;
80103cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb7:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cbe:	00 00 00 
  initlock(&p->lock, "pipe");
80103cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc4:	c7 44 24 04 18 91 10 	movl   $0x80109118,0x4(%esp)
80103ccb:	80 
80103ccc:	89 04 24             	mov    %eax,(%esp)
80103ccf:	e8 b9 18 00 00       	call   8010558d <initlock>
  (*f0)->type = FD_PIPE;
80103cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103cd7:	8b 00                	mov    (%eax),%eax
80103cd9:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce2:	8b 00                	mov    (%eax),%eax
80103ce4:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103ce8:	8b 45 08             	mov    0x8(%ebp),%eax
80103ceb:	8b 00                	mov    (%eax),%eax
80103ced:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cf1:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf4:	8b 00                	mov    (%eax),%eax
80103cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103cf9:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cff:	8b 00                	mov    (%eax),%eax
80103d01:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d0a:	8b 00                	mov    (%eax),%eax
80103d0c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d10:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d13:	8b 00                	mov    (%eax),%eax
80103d15:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d19:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1c:	8b 00                	mov    (%eax),%eax
80103d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d21:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d24:	b8 00 00 00 00       	mov    $0x0,%eax
80103d29:	eb 43                	jmp    80103d6e <pipealloc+0x141>
    goto bad;
80103d2b:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
80103d2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d30:	74 0b                	je     80103d3d <pipealloc+0x110>
    kfree((char*)p);
80103d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d35:	89 04 24             	mov    %eax,(%esp)
80103d38:	e8 e8 ec ff ff       	call   80102a25 <kfree>
  if(*f0)
80103d3d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d40:	8b 00                	mov    (%eax),%eax
80103d42:	85 c0                	test   %eax,%eax
80103d44:	74 0d                	je     80103d53 <pipealloc+0x126>
    fileclose(*f0);
80103d46:	8b 45 08             	mov    0x8(%ebp),%eax
80103d49:	8b 00                	mov    (%eax),%eax
80103d4b:	89 04 24             	mov    %eax,(%esp)
80103d4e:	e8 48 d2 ff ff       	call   80100f9b <fileclose>
  if(*f1)
80103d53:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d56:	8b 00                	mov    (%eax),%eax
80103d58:	85 c0                	test   %eax,%eax
80103d5a:	74 0d                	je     80103d69 <pipealloc+0x13c>
    fileclose(*f1);
80103d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d5f:	8b 00                	mov    (%eax),%eax
80103d61:	89 04 24             	mov    %eax,(%esp)
80103d64:	e8 32 d2 ff ff       	call   80100f9b <fileclose>
  return -1;
80103d69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    

80103d70 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d76:	8b 45 08             	mov    0x8(%ebp),%eax
80103d79:	89 04 24             	mov    %eax,(%esp)
80103d7c:	e8 2d 18 00 00       	call   801055ae <acquire>
  if(writable){
80103d81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d85:	74 1f                	je     80103da6 <pipeclose+0x36>
    p->writeopen = 0;
80103d87:	8b 45 08             	mov    0x8(%ebp),%eax
80103d8a:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d91:	00 00 00 
    wakeup(&p->nread);
80103d94:	8b 45 08             	mov    0x8(%ebp),%eax
80103d97:	05 34 02 00 00       	add    $0x234,%eax
80103d9c:	89 04 24             	mov    %eax,(%esp)
80103d9f:	e8 4a 0e 00 00       	call   80104bee <wakeup>
80103da4:	eb 1d                	jmp    80103dc3 <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103da6:	8b 45 08             	mov    0x8(%ebp),%eax
80103da9:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103db0:	00 00 00 
    wakeup(&p->nwrite);
80103db3:	8b 45 08             	mov    0x8(%ebp),%eax
80103db6:	05 38 02 00 00       	add    $0x238,%eax
80103dbb:	89 04 24             	mov    %eax,(%esp)
80103dbe:	e8 2b 0e 00 00       	call   80104bee <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc6:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dcc:	85 c0                	test   %eax,%eax
80103dce:	75 25                	jne    80103df5 <pipeclose+0x85>
80103dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd3:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103dd9:	85 c0                	test   %eax,%eax
80103ddb:	75 18                	jne    80103df5 <pipeclose+0x85>
    release(&p->lock);
80103ddd:	8b 45 08             	mov    0x8(%ebp),%eax
80103de0:	89 04 24             	mov    %eax,(%esp)
80103de3:	e8 28 18 00 00       	call   80105610 <release>
    kfree((char*)p);
80103de8:	8b 45 08             	mov    0x8(%ebp),%eax
80103deb:	89 04 24             	mov    %eax,(%esp)
80103dee:	e8 32 ec ff ff       	call   80102a25 <kfree>
80103df3:	eb 0b                	jmp    80103e00 <pipeclose+0x90>
  } else
    release(&p->lock);
80103df5:	8b 45 08             	mov    0x8(%ebp),%eax
80103df8:	89 04 24             	mov    %eax,(%esp)
80103dfb:	e8 10 18 00 00       	call   80105610 <release>
}
80103e00:	c9                   	leave  
80103e01:	c3                   	ret    

80103e02 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e02:	55                   	push   %ebp
80103e03:	89 e5                	mov    %esp,%ebp
80103e05:	53                   	push   %ebx
80103e06:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e09:	8b 45 08             	mov    0x8(%ebp),%eax
80103e0c:	89 04 24             	mov    %eax,(%esp)
80103e0f:	e8 9a 17 00 00       	call   801055ae <acquire>
  for(i = 0; i < n; i++){
80103e14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e1b:	e9 a6 00 00 00       	jmp    80103ec6 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e20:	8b 45 08             	mov    0x8(%ebp),%eax
80103e23:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e29:	85 c0                	test   %eax,%eax
80103e2b:	74 0d                	je     80103e3a <pipewrite+0x38>
80103e2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e33:	8b 40 24             	mov    0x24(%eax),%eax
80103e36:	85 c0                	test   %eax,%eax
80103e38:	74 15                	je     80103e4f <pipewrite+0x4d>
        release(&p->lock);
80103e3a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e3d:	89 04 24             	mov    %eax,(%esp)
80103e40:	e8 cb 17 00 00       	call   80105610 <release>
        return -1;
80103e45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e4a:	e9 9d 00 00 00       	jmp    80103eec <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e4f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e52:	05 34 02 00 00       	add    $0x234,%eax
80103e57:	89 04 24             	mov    %eax,(%esp)
80103e5a:	e8 8f 0d 00 00       	call   80104bee <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e5f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e62:	8b 55 08             	mov    0x8(%ebp),%edx
80103e65:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e6f:	89 14 24             	mov    %edx,(%esp)
80103e72:	e8 6f 0c 00 00       	call   80104ae6 <sleep>
80103e77:	eb 01                	jmp    80103e7a <pipewrite+0x78>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e79:	90                   	nop
80103e7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7d:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e83:	8b 45 08             	mov    0x8(%ebp),%eax
80103e86:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e8c:	05 00 02 00 00       	add    $0x200,%eax
80103e91:	39 c2                	cmp    %eax,%edx
80103e93:	74 8b                	je     80103e20 <pipewrite+0x1e>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e95:	8b 45 08             	mov    0x8(%ebp),%eax
80103e98:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103e9e:	89 c3                	mov    %eax,%ebx
80103ea0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103ea6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80103ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
80103eac:	01 ca                	add    %ecx,%edx
80103eae:	8a 0a                	mov    (%edx),%cl
80103eb0:	8b 55 08             	mov    0x8(%ebp),%edx
80103eb3:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103eb7:	8d 50 01             	lea    0x1(%eax),%edx
80103eba:	8b 45 08             	mov    0x8(%ebp),%eax
80103ebd:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
  for(i = 0; i < n; i++){
80103ec3:	ff 45 f4             	incl   -0xc(%ebp)
80103ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec9:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ecc:	7c ab                	jl     80103e79 <pipewrite+0x77>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ece:	8b 45 08             	mov    0x8(%ebp),%eax
80103ed1:	05 34 02 00 00       	add    $0x234,%eax
80103ed6:	89 04 24             	mov    %eax,(%esp)
80103ed9:	e8 10 0d 00 00       	call   80104bee <wakeup>
  release(&p->lock);
80103ede:	8b 45 08             	mov    0x8(%ebp),%eax
80103ee1:	89 04 24             	mov    %eax,(%esp)
80103ee4:	e8 27 17 00 00       	call   80105610 <release>
  return n;
80103ee9:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103eec:	83 c4 24             	add    $0x24,%esp
80103eef:	5b                   	pop    %ebx
80103ef0:	5d                   	pop    %ebp
80103ef1:	c3                   	ret    

80103ef2 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ef2:	55                   	push   %ebp
80103ef3:	89 e5                	mov    %esp,%ebp
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80103efc:	89 04 24             	mov    %eax,(%esp)
80103eff:	e8 aa 16 00 00       	call   801055ae <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f04:	eb 3a                	jmp    80103f40 <piperead+0x4e>
    if(proc->killed){
80103f06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f0c:	8b 40 24             	mov    0x24(%eax),%eax
80103f0f:	85 c0                	test   %eax,%eax
80103f11:	74 15                	je     80103f28 <piperead+0x36>
      release(&p->lock);
80103f13:	8b 45 08             	mov    0x8(%ebp),%eax
80103f16:	89 04 24             	mov    %eax,(%esp)
80103f19:	e8 f2 16 00 00       	call   80105610 <release>
      return -1;
80103f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f23:	e9 b5 00 00 00       	jmp    80103fdd <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f28:	8b 45 08             	mov    0x8(%ebp),%eax
80103f2b:	8b 55 08             	mov    0x8(%ebp),%edx
80103f2e:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f34:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f38:	89 14 24             	mov    %edx,(%esp)
80103f3b:	e8 a6 0b 00 00       	call   80104ae6 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f40:	8b 45 08             	mov    0x8(%ebp),%eax
80103f43:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f49:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f52:	39 c2                	cmp    %eax,%edx
80103f54:	75 0d                	jne    80103f63 <piperead+0x71>
80103f56:	8b 45 08             	mov    0x8(%ebp),%eax
80103f59:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f5f:	85 c0                	test   %eax,%eax
80103f61:	75 a3                	jne    80103f06 <piperead+0x14>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f6a:	eb 48                	jmp    80103fb4 <piperead+0xc2>
    if(p->nread == p->nwrite)
80103f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6f:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f7e:	39 c2                	cmp    %eax,%edx
80103f80:	74 3c                	je     80103fbe <piperead+0xcc>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f82:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f85:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f88:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8e:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f94:	89 c3                	mov    %eax,%ebx
80103f96:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103f9c:	8b 55 08             	mov    0x8(%ebp),%edx
80103f9f:	8a 54 1a 34          	mov    0x34(%edx,%ebx,1),%dl
80103fa3:	88 11                	mov    %dl,(%ecx)
80103fa5:	8d 50 01             	lea    0x1(%eax),%edx
80103fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fab:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fb1:	ff 45 f4             	incl   -0xc(%ebp)
80103fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb7:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fba:	7c b0                	jl     80103f6c <piperead+0x7a>
80103fbc:	eb 01                	jmp    80103fbf <piperead+0xcd>
      break;
80103fbe:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fbf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fc2:	05 38 02 00 00       	add    $0x238,%eax
80103fc7:	89 04 24             	mov    %eax,(%esp)
80103fca:	e8 1f 0c 00 00       	call   80104bee <wakeup>
  release(&p->lock);
80103fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fd2:	89 04 24             	mov    %eax,(%esp)
80103fd5:	e8 36 16 00 00       	call   80105610 <release>
  return i;
80103fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fdd:	83 c4 24             	add    $0x24,%esp
80103fe0:	5b                   	pop    %ebx
80103fe1:	5d                   	pop    %ebp
80103fe2:	c3                   	ret    

80103fe3 <readeflags>:
{
80103fe3:	55                   	push   %ebp
80103fe4:	89 e5                	mov    %esp,%ebp
80103fe6:	53                   	push   %ebx
80103fe7:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fea:	9c                   	pushf  
80103feb:	5b                   	pop    %ebx
80103fec:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80103fef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103ff2:	83 c4 10             	add    $0x10,%esp
80103ff5:	5b                   	pop    %ebx
80103ff6:	5d                   	pop    %ebp
80103ff7:	c3                   	ret    

80103ff8 <sti>:
{
80103ff8:	55                   	push   %ebp
80103ff9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80103ffb:	fb                   	sti    
}
80103ffc:	5d                   	pop    %ebp
80103ffd:	c3                   	ret    

80103ffe <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103ffe:	55                   	push   %ebp
80103fff:	89 e5                	mov    %esp,%ebp
80104001:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104004:	c7 44 24 04 1d 91 10 	movl   $0x8010911d,0x4(%esp)
8010400b:	80 
8010400c:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104013:	e8 75 15 00 00       	call   8010558d <initlock>
  shm_init(); // New: Add in project final: inicializo shmtable.sharedmemory[i].refcount = -1
80104018:	e8 e3 10 00 00       	call   80105100 <shm_init>
}
8010401d:	c9                   	leave  
8010401e:	c3                   	ret    

8010401f <enqueue>:

void
enqueue(struct proc *p) // New: Added in proyect 2
{
8010401f:	55                   	push   %ebp
80104020:	89 e5                	mov    %esp,%ebp
80104022:	83 ec 28             	sub    $0x28,%esp
  struct proc *prev;
  if(p->priority>=0 && p->priority<MLF_LEVELS){
80104025:	8b 45 08             	mov    0x8(%ebp),%eax
80104028:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010402e:	85 c0                	test   %eax,%eax
80104030:	0f 88 b8 00 00 00    	js     801040ee <enqueue+0xcf>
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010403f:	83 f8 03             	cmp    $0x3,%eax
80104042:	0f 8f a6 00 00 00    	jg     801040ee <enqueue+0xcf>
    //if priority level is empty (there is no proc)
    if(ptable.mlf[p->priority].first == 0){
80104048:	8b 45 08             	mov    0x8(%ebp),%eax
8010404b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104051:	05 66 05 00 00       	add    $0x566,%eax
80104056:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
8010405d:	85 c0                	test   %eax,%eax
8010405f:	75 41                	jne    801040a2 <enqueue+0x83>
      ptable.mlf[p->priority].first=p; //set first
80104061:	8b 45 08             	mov    0x8(%ebp),%eax
80104064:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010406a:	8d 90 66 05 00 00    	lea    0x566(%eax),%edx
80104070:	8b 45 08             	mov    0x8(%ebp),%eax
80104073:	89 04 d5 04 10 11 80 	mov    %eax,-0x7feeeffc(,%edx,8)
      ptable.mlf[p->priority].last=p; //set last
8010407a:	8b 45 08             	mov    0x8(%ebp),%eax
8010407d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104083:	8d 90 66 05 00 00    	lea    0x566(%eax),%edx
80104089:	8b 45 08             	mov    0x8(%ebp),%eax
8010408c:	89 04 d5 08 10 11 80 	mov    %eax,-0x7feeeff8(,%edx,8)
      p->next=0;  //set next in "null"
80104093:	8b 45 08             	mov    0x8(%ebp),%eax
80104096:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010409d:	00 00 00 
    if(ptable.mlf[p->priority].first == 0){
801040a0:	eb 58                	jmp    801040fa <enqueue+0xdb>
    }else{
      prev=ptable.mlf[p->priority].last;//get previous last
801040a2:	8b 45 08             	mov    0x8(%ebp),%eax
801040a5:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801040ab:	05 66 05 00 00       	add    $0x566,%eax
801040b0:	8b 04 c5 08 10 11 80 	mov    -0x7feeeff8(,%eax,8),%eax
801040b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      prev->next=p; //set new proc as next of previous last
801040ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bd:	8b 55 08             	mov    0x8(%ebp),%edx
801040c0:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
      ptable.mlf[p->priority].last=p; //refresh last
801040c6:	8b 45 08             	mov    0x8(%ebp),%eax
801040c9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801040cf:	8d 90 66 05 00 00    	lea    0x566(%eax),%edx
801040d5:	8b 45 08             	mov    0x8(%ebp),%eax
801040d8:	89 04 d5 08 10 11 80 	mov    %eax,-0x7feeeff8(,%edx,8)
      p->next=0;
801040df:	8b 45 08             	mov    0x8(%ebp),%eax
801040e2:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801040e9:	00 00 00 
    if(ptable.mlf[p->priority].first == 0){
801040ec:	eb 0c                	jmp    801040fa <enqueue+0xdb>
    }
  }else{
    cprintf("ERROR ENQUEUE\n");
801040ee:	c7 04 24 24 91 10 80 	movl   $0x80109124,(%esp)
801040f5:	e8 a7 c2 ff ff       	call   801003a1 <cprintf>
  }
}
801040fa:	c9                   	leave  
801040fb:	c3                   	ret    

801040fc <dequeue>:

struct proc *
dequeue(int priority) // New: Added in proyect 2
{
801040fc:	55                   	push   %ebp
801040fd:	89 e5                	mov    %esp,%ebp
801040ff:	83 ec 10             	sub    $0x10,%esp
  struct proc *res; // result pointer
  // save first proc of the list
  res=ptable.mlf[priority].first;
80104102:	8b 45 08             	mov    0x8(%ebp),%eax
80104105:	05 66 05 00 00       	add    $0x566,%eax
8010410a:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104111:	89 45 fc             	mov    %eax,-0x4(%ebp)
  // when a proc is dequeued, refresh first element of the priority level
  ptable.mlf[priority].first=ptable.mlf[priority].first->next;
80104114:	8b 45 08             	mov    0x8(%ebp),%eax
80104117:	05 66 05 00 00       	add    $0x566,%eax
8010411c:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104123:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104129:	8b 55 08             	mov    0x8(%ebp),%edx
8010412c:	81 c2 66 05 00 00    	add    $0x566,%edx
80104132:	89 04 d5 04 10 11 80 	mov    %eax,-0x7feeeffc(,%edx,8)
  res->next=0;
80104139:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010413c:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104143:	00 00 00 
  return res;
80104146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104149:	c9                   	leave  
8010414a:	c3                   	ret    

8010414b <isempty>:

int
isempty(int priority) // New: Added in proyect 2
{
8010414b:	55                   	push   %ebp
8010414c:	89 e5                	mov    %esp,%ebp
  if(ptable.mlf[priority].first!=0){
8010414e:	8b 45 08             	mov    0x8(%ebp),%eax
80104151:	05 66 05 00 00       	add    $0x566,%eax
80104156:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
8010415d:	85 c0                	test   %eax,%eax
8010415f:	74 07                	je     80104168 <isempty+0x1d>
    return 0;
80104161:	b8 00 00 00 00       	mov    $0x0,%eax
80104166:	eb 05                	jmp    8010416d <isempty+0x22>
  }
  return 1;
80104168:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010416d:	5d                   	pop    %ebp
8010416e:	c3                   	ret    

8010416f <makerunnable>:

void
makerunnable(struct proc *p, int priority) // New: Added in proyect 2
// level can be: 0, 1, -1
{
8010416f:	55                   	push   %ebp
80104170:	89 e5                	mov    %esp,%ebp
80104172:	83 ec 18             	sub    $0x18,%esp
  if (priority==1 && p->priority<SIZEMLF-1)
80104175:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
80104179:	75 23                	jne    8010419e <makerunnable+0x2f>
8010417b:	8b 45 08             	mov    0x8(%ebp),%eax
8010417e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104184:	83 f8 02             	cmp    $0x2,%eax
80104187:	7f 15                	jg     8010419e <makerunnable+0x2f>
  {
    p->priority++;
80104189:	8b 45 08             	mov    0x8(%ebp),%eax
8010418c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104192:	8d 50 01             	lea    0x1(%eax),%edx
80104195:	8b 45 08             	mov    0x8(%ebp),%eax
80104198:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  if (priority==-1 && p->priority>0)
8010419e:	83 7d 0c ff          	cmpl   $0xffffffff,0xc(%ebp)
801041a2:	75 22                	jne    801041c6 <makerunnable+0x57>
801041a4:	8b 45 08             	mov    0x8(%ebp),%eax
801041a7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041ad:	85 c0                	test   %eax,%eax
801041af:	7e 15                	jle    801041c6 <makerunnable+0x57>
  {
    p->priority--;
801041b1:	8b 45 08             	mov    0x8(%ebp),%eax
801041b4:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801041ba:	8d 50 ff             	lea    -0x1(%eax),%edx
801041bd:	8b 45 08             	mov    0x8(%ebp),%eax
801041c0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  p->state = RUNNABLE;
801041c6:	8b 45 08             	mov    0x8(%ebp),%eax
801041c9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(p);
801041d0:	8b 45 08             	mov    0x8(%ebp),%eax
801041d3:	89 04 24             	mov    %eax,(%esp)
801041d6:	e8 44 fe ff ff       	call   8010401f <enqueue>
}
801041db:	c9                   	leave  
801041dc:	c3                   	ret    

801041dd <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801041dd:	55                   	push   %ebp
801041de:	89 e5                	mov    %esp,%ebp
801041e0:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801041e3:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801041ea:	e8 bf 13 00 00       	call   801055ae <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ef:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801041f6:	eb 11                	jmp    80104209 <allocproc+0x2c>
    if(p->state == UNUSED)
801041f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fb:	8b 40 0c             	mov    0xc(%eax),%eax
801041fe:	85 c0                	test   %eax,%eax
80104200:	74 26                	je     80104228 <allocproc+0x4b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104202:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104209:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104210:	72 e6                	jb     801041f8 <allocproc+0x1b>
      goto found;
  release(&ptable.lock);
80104212:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104219:	e8 f2 13 00 00       	call   80105610 <release>
  return 0;
8010421e:	b8 00 00 00 00       	mov    $0x0,%eax
80104223:	e9 c0 00 00 00       	jmp    801042e8 <allocproc+0x10b>
      goto found;
80104228:	90                   	nop

found:
  p->state = EMBRYO;
80104229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010422c:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104233:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104238:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010423b:	89 42 10             	mov    %eax,0x10(%edx)
8010423e:	40                   	inc    %eax
8010423f:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
80104244:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
8010424b:	e8 c0 13 00 00       	call   80105610 <release>

  p->priority=0; // New: Added in proyect 2: set priority in zero 
80104250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104253:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010425a:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010425d:	e8 5c e8 ff ff       	call   80102abe <kalloc>
80104262:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104265:	89 42 08             	mov    %eax,0x8(%edx)
80104268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426b:	8b 40 08             	mov    0x8(%eax),%eax
8010426e:	85 c0                	test   %eax,%eax
80104270:	75 11                	jne    80104283 <allocproc+0xa6>
    p->state = UNUSED;
80104272:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104275:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010427c:	b8 00 00 00 00       	mov    $0x0,%eax
80104281:	eb 65                	jmp    801042e8 <allocproc+0x10b>
  }
  sp = p->kstack + KSTACKSIZE;
80104283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104286:	8b 40 08             	mov    0x8(%eax),%eax
80104289:	05 00 10 00 00       	add    $0x1000,%eax
8010428e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104291:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104298:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010429b:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010429e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801042a2:	ba 5d 6e 10 80       	mov    $0x80106e5d,%edx
801042a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801042aa:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801042ac:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801042b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801042b6:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bc:	8b 40 1c             	mov    0x1c(%eax),%eax
801042bf:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801042c6:	00 
801042c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042ce:	00 
801042cf:	89 04 24             	mov    %eax,(%esp)
801042d2:	e8 29 15 00 00       	call   80105800 <memset>
  p->context->eip = (uint)forkret;
801042d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042da:	8b 40 1c             	mov    0x1c(%eax),%eax
801042dd:	ba ba 4a 10 80       	mov    $0x80104aba,%edx
801042e2:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801042e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042e8:	c9                   	leave  
801042e9:	c3                   	ret    

801042ea <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801042ea:	55                   	push   %ebp
801042eb:	89 e5                	mov    %esp,%ebp
801042ed:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801042f0:	e8 e8 fe ff ff       	call   801041dd <allocproc>
801042f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801042f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042fb:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
80104300:	e8 1f 42 00 00       	call   80108524 <setupkvm>
80104305:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104308:	89 42 04             	mov    %eax,0x4(%edx)
8010430b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430e:	8b 40 04             	mov    0x4(%eax),%eax
80104311:	85 c0                	test   %eax,%eax
80104313:	75 0c                	jne    80104321 <userinit+0x37>
    panic("userinit: out of memory?");
80104315:	c7 04 24 33 91 10 80 	movl   $0x80109133,(%esp)
8010431c:	e8 15 c2 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104321:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104329:	8b 40 04             	mov    0x4(%eax),%eax
8010432c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104330:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
80104337:	80 
80104338:	89 04 24             	mov    %eax,(%esp)
8010433b:	e8 30 44 00 00       	call   80108770 <inituvm>
  p->sz = PGSIZE;
80104340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104343:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	8b 40 18             	mov    0x18(%eax),%eax
8010434f:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104356:	00 
80104357:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010435e:	00 
8010435f:	89 04 24             	mov    %eax,(%esp)
80104362:	e8 99 14 00 00       	call   80105800 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436a:	8b 40 18             	mov    0x18(%eax),%eax
8010436d:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104376:	8b 40 18             	mov    0x18(%eax),%eax
80104379:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010437f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104382:	8b 50 18             	mov    0x18(%eax),%edx
80104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104388:	8b 40 18             	mov    0x18(%eax),%eax
8010438b:	8b 40 2c             	mov    0x2c(%eax),%eax
8010438e:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
80104392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104395:	8b 50 18             	mov    0x18(%eax),%edx
80104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439b:	8b 40 18             	mov    0x18(%eax),%eax
8010439e:	8b 40 2c             	mov    0x2c(%eax),%eax
801043a1:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801043a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a8:	8b 40 18             	mov    0x18(%eax),%eax
801043ab:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801043b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b5:	8b 40 18             	mov    0x18(%eax),%eax
801043b8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c2:	8b 40 18             	mov    0x18(%eax),%eax
801043c5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043cf:	83 c0 6c             	add    $0x6c,%eax
801043d2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043d9:	00 
801043da:	c7 44 24 04 4c 91 10 	movl   $0x8010914c,0x4(%esp)
801043e1:	80 
801043e2:	89 04 24             	mov    %eax,(%esp)
801043e5:	e8 28 16 00 00       	call   80105a12 <safestrcpy>
  p->cwd = namei("/");
801043ea:	c7 04 24 55 91 10 80 	movl   $0x80109155,(%esp)
801043f1:	e8 e9 df ff ff       	call   801023df <namei>
801043f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043f9:	89 42 68             	mov    %eax,0x68(%edx)

  // p->state = RUNNABLE;
  makerunnable(p,0); // New: Added in proyect 2: enqueue proc
801043fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104403:	00 
80104404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104407:	89 04 24             	mov    %eax,(%esp)
8010440a:	e8 60 fd ff ff       	call   8010416f <makerunnable>

}
8010440f:	c9                   	leave  
80104410:	c3                   	ret    

80104411 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104411:	55                   	push   %ebp
80104412:	89 e5                	mov    %esp,%ebp
80104414:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104417:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010441d:	8b 00                	mov    (%eax),%eax
8010441f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104426:	7e 34                	jle    8010445c <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104428:	8b 55 08             	mov    0x8(%ebp),%edx
8010442b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010442e:	01 c2                	add    %eax,%edx
80104430:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104436:	8b 40 04             	mov    0x4(%eax),%eax
80104439:	89 54 24 08          	mov    %edx,0x8(%esp)
8010443d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104440:	89 54 24 04          	mov    %edx,0x4(%esp)
80104444:	89 04 24             	mov    %eax,(%esp)
80104447:	e8 9e 44 00 00       	call   801088ea <allocuvm>
8010444c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010444f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104453:	75 41                	jne    80104496 <growproc+0x85>
      return -1;
80104455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445a:	eb 58                	jmp    801044b4 <growproc+0xa3>
  } else if(n < 0){
8010445c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104460:	79 34                	jns    80104496 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104462:	8b 55 08             	mov    0x8(%ebp),%edx
80104465:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104468:	01 c2                	add    %eax,%edx
8010446a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104470:	8b 40 04             	mov    0x4(%eax),%eax
80104473:	89 54 24 08          	mov    %edx,0x8(%esp)
80104477:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010447e:	89 04 24             	mov    %eax,(%esp)
80104481:	e8 3e 45 00 00       	call   801089c4 <deallocuvm>
80104486:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010448d:	75 07                	jne    80104496 <growproc+0x85>
      return -1;
8010448f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104494:	eb 1e                	jmp    801044b4 <growproc+0xa3>
  }
  proc->sz = sz;
80104496:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010449f:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801044a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044a7:	89 04 24             	mov    %eax,(%esp)
801044aa:	e8 66 41 00 00       	call   80108615 <switchuvm>
  return 0;
801044af:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044b4:	c9                   	leave  
801044b5:	c3                   	ret    

801044b6 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801044b6:	55                   	push   %ebp
801044b7:	89 e5                	mov    %esp,%ebp
801044b9:	57                   	push   %edi
801044ba:	56                   	push   %esi
801044bb:	53                   	push   %ebx
801044bc:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801044bf:	e8 19 fd ff ff       	call   801041dd <allocproc>
801044c4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801044c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801044cb:	75 0a                	jne    801044d7 <fork+0x21>
    return -1;
801044cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044d2:	e9 5b 01 00 00       	jmp    80104632 <fork+0x17c>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801044d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044dd:	8b 10                	mov    (%eax),%edx
801044df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e5:	8b 40 04             	mov    0x4(%eax),%eax
801044e8:	89 54 24 04          	mov    %edx,0x4(%esp)
801044ec:	89 04 24             	mov    %eax,(%esp)
801044ef:	e8 86 46 00 00       	call   80108b7a <copyuvm>
801044f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044f7:	89 42 04             	mov    %eax,0x4(%edx)
801044fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044fd:	8b 40 04             	mov    0x4(%eax),%eax
80104500:	85 c0                	test   %eax,%eax
80104502:	75 22                	jne    80104526 <fork+0x70>
    kfree(np->kstack);
80104504:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104507:	8b 40 08             	mov    0x8(%eax),%eax
8010450a:	89 04 24             	mov    %eax,(%esp)
8010450d:	e8 13 e5 ff ff       	call   80102a25 <kfree>
    // np->kstack = 0;
    np->state = UNUSED;
80104512:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104515:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010451c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104521:	e9 0c 01 00 00       	jmp    80104632 <fork+0x17c>
  }
  np->sz = proc->sz;
80104526:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010452c:	8b 10                	mov    (%eax),%edx
8010452e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104531:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104533:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010453a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010453d:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104540:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104543:	8b 50 18             	mov    0x18(%eax),%edx
80104546:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010454c:	8b 40 18             	mov    0x18(%eax),%eax
8010454f:	89 c3                	mov    %eax,%ebx
80104551:	b8 13 00 00 00       	mov    $0x13,%eax
80104556:	89 d7                	mov    %edx,%edi
80104558:	89 de                	mov    %ebx,%esi
8010455a:	89 c1                	mov    %eax,%ecx
8010455c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010455e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104561:	8b 40 18             	mov    0x18(%eax),%eax
80104564:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010456b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104572:	eb 3c                	jmp    801045b0 <fork+0xfa>
    if(proc->ofile[i])
80104574:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010457a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010457d:	83 c2 08             	add    $0x8,%edx
80104580:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104584:	85 c0                	test   %eax,%eax
80104586:	74 25                	je     801045ad <fork+0xf7>
      np->ofile[i] = filedup(proc->ofile[i]);
80104588:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010458e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104591:	83 c2 08             	add    $0x8,%edx
80104594:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104598:	89 04 24             	mov    %eax,(%esp)
8010459b:	e8 b3 c9 ff ff       	call   80100f53 <filedup>
801045a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045a3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801045a6:	83 c1 08             	add    $0x8,%ecx
801045a9:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801045ad:	ff 45 e4             	incl   -0x1c(%ebp)
801045b0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801045b4:	7e be                	jle    80104574 <fork+0xbe>
  np->cwd = idup(proc->cwd);
801045b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045bc:	8b 40 68             	mov    0x68(%eax),%eax
801045bf:	89 04 24             	mov    %eax,(%esp)
801045c2:	e8 4c d2 ff ff       	call   80101813 <idup>
801045c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045ca:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801045cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045d0:	8b 40 10             	mov    0x10(%eax),%eax
801045d3:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Init array of sharedmem
  for (i = 0; i < MAXSHMPROC; i++){
801045d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801045dd:	eb 14                	jmp    801045f3 <fork+0x13d>
    np->shmref[i] = 0;
801045df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045e5:	83 c2 24             	add    $0x24,%edx
801045e8:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045ef:	00 
  for (i = 0; i < MAXSHMPROC; i++){
801045f0:	ff 45 e4             	incl   -0x1c(%ebp)
801045f3:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
801045f7:	7e e6                	jle    801045df <fork+0x129>
  }

  // np->state = RUNNABLE;
  makerunnable(np,0); // New: Added in proyect 2: every process enqueued is RUNNABLE
801045f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104600:	00 
80104601:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104604:	89 04 24             	mov    %eax,(%esp)
80104607:	e8 63 fb ff ff       	call   8010416f <makerunnable>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010460c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104612:	8d 50 6c             	lea    0x6c(%eax),%edx
80104615:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104618:	83 c0 6c             	add    $0x6c,%eax
8010461b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104622:	00 
80104623:	89 54 24 04          	mov    %edx,0x4(%esp)
80104627:	89 04 24             	mov    %eax,(%esp)
8010462a:	e8 e3 13 00 00       	call   80105a12 <safestrcpy>
  return pid;
8010462f:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104632:	83 c4 2c             	add    $0x2c,%esp
80104635:	5b                   	pop    %ebx
80104636:	5e                   	pop    %esi
80104637:	5f                   	pop    %edi
80104638:	5d                   	pop    %ebp
80104639:	c3                   	ret    

8010463a <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010463a:	55                   	push   %ebp
8010463b:	89 e5                	mov    %esp,%ebp
8010463d:	53                   	push   %ebx
8010463e:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int fd, sd, i;

  if(proc == initproc)
80104641:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104648:	a1 88 c6 10 80       	mov    0x8010c688,%eax
8010464d:	39 c2                	cmp    %eax,%edx
8010464f:	75 0c                	jne    8010465d <exit+0x23>
    panic("init exiting");
80104651:	c7 04 24 57 91 10 80 	movl   $0x80109157,(%esp)
80104658:	e8 d9 be ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010465d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104664:	eb 43                	jmp    801046a9 <exit+0x6f>
    if(proc->ofile[fd]){
80104666:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010466c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010466f:	83 c2 08             	add    $0x8,%edx
80104672:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104676:	85 c0                	test   %eax,%eax
80104678:	74 2c                	je     801046a6 <exit+0x6c>
      fileclose(proc->ofile[fd]);
8010467a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104680:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104683:	83 c2 08             	add    $0x8,%edx
80104686:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010468a:	89 04 24             	mov    %eax,(%esp)
8010468d:	e8 09 c9 ff ff       	call   80100f9b <fileclose>
      proc->ofile[fd] = 0;
80104692:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104698:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010469b:	83 c2 08             	add    $0x8,%edx
8010469e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801046a5:	00 
  for(fd = 0; fd < NOFILE; fd++){
801046a6:	ff 45 f0             	incl   -0x10(%ebp)
801046a9:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801046ad:	7e b7                	jle    80104666 <exit+0x2c>
    }
  }

  //Delete all semaphores
  for(sd = 0; sd < MAXSEMPROC; sd++){
801046af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801046b6:	eb 3f                	jmp    801046f7 <exit+0xbd>
    if(proc->procsem[sd]){
801046b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046be:	8b 55 ec             	mov    -0x14(%ebp),%edx
801046c1:	83 c2 20             	add    $0x20,%edx
801046c4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c8:	85 c0                	test   %eax,%eax
801046ca:	74 28                	je     801046f4 <exit+0xba>
      semfree(proc->procsem[sd] - getstable());
801046cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801046d5:	83 c2 20             	add    $0x20,%edx
801046d8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046dc:	89 c3                	mov    %eax,%ebx
801046de:	e8 01 07 00 00       	call   80104de4 <getstable>
801046e3:	89 da                	mov    %ebx,%edx
801046e5:	29 c2                	sub    %eax,%edx
801046e7:	89 d0                	mov    %edx,%eax
801046e9:	c1 f8 03             	sar    $0x3,%eax
801046ec:	89 04 24             	mov    %eax,(%esp)
801046ef:	e8 57 08 00 00       	call   80104f4b <semfree>
  for(sd = 0; sd < MAXSEMPROC; sd++){
801046f4:	ff 45 ec             	incl   -0x14(%ebp)
801046f7:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
801046fb:	7e bb                	jle    801046b8 <exit+0x7e>
    }
  }

  proc->shmemquantity = 0;
801046fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104703:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
8010470a:	00 00 00 

  begin_trans(); //add hoy dario, no estoy seguro // begin_op en linux creo
8010470d:	e8 be ea ff ff       	call   801031d0 <begin_trans>
  iput(proc->cwd);
80104712:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104718:	8b 40 68             	mov    0x68(%eax),%eax
8010471b:	89 04 24             	mov    %eax,(%esp)
8010471e:	e8 d2 d2 ff ff       	call   801019f5 <iput>
  commit_trans(); //add hoy dario, no estoy seguro
80104723:	e8 f1 ea ff ff       	call   80103219 <commit_trans>
  proc->cwd = 0;
80104728:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010472e:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  // Free shared memory
  for(i = 0; i < MAXSHMPROC; i++){
80104735:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
8010473c:	eb 0e                	jmp    8010474c <exit+0x112>
    if (proc->shmref[i] != 0){}
      shm_close(i);
8010473e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104741:	89 04 24             	mov    %eax,(%esp)
80104744:	e8 c4 0a 00 00       	call   8010520d <shm_close>
  for(i = 0; i < MAXSHMPROC; i++){
80104749:	ff 45 e8             	incl   -0x18(%ebp)
8010474c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
80104750:	7e ec                	jle    8010473e <exit+0x104>
  }

  acquire(&ptable.lock);
80104752:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104759:	e8 50 0e 00 00       	call   801055ae <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010475e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104764:	8b 40 14             	mov    0x14(%eax),%eax
80104767:	89 04 24             	mov    %eax,(%esp)
8010476a:	e8 35 04 00 00       	call   80104ba4 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010476f:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104776:	eb 3b                	jmp    801047b3 <exit+0x179>
    if(p->parent == proc){
80104778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477b:	8b 50 14             	mov    0x14(%eax),%edx
8010477e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104784:	39 c2                	cmp    %eax,%edx
80104786:	75 24                	jne    801047ac <exit+0x172>
      p->parent = initproc;
80104788:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
8010478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104791:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104797:	8b 40 0c             	mov    0xc(%eax),%eax
8010479a:	83 f8 05             	cmp    $0x5,%eax
8010479d:	75 0d                	jne    801047ac <exit+0x172>
        wakeup1(initproc);
8010479f:	a1 88 c6 10 80       	mov    0x8010c688,%eax
801047a4:	89 04 24             	mov    %eax,(%esp)
801047a7:	e8 f8 03 00 00       	call   80104ba4 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047ac:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
801047b3:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
801047ba:	72 bc                	jb     80104778 <exit+0x13e>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801047bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c2:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801047c9:	e8 db 01 00 00       	call   801049a9 <sched>
  panic("zombie exit");
801047ce:	c7 04 24 64 91 10 80 	movl   $0x80109164,(%esp)
801047d5:	e8 5c bd ff ff       	call   80100536 <panic>

801047da <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801047da:	55                   	push   %ebp
801047db:	89 e5                	mov    %esp,%ebp
801047dd:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801047e0:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801047e7:	e8 c2 0d 00 00       	call   801055ae <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801047ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f3:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801047fa:	e9 9d 00 00 00       	jmp    8010489c <wait+0xc2>
      if(p->parent != proc)
801047ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104802:	8b 50 14             	mov    0x14(%eax),%edx
80104805:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480b:	39 c2                	cmp    %eax,%edx
8010480d:	0f 85 81 00 00 00    	jne    80104894 <wait+0xba>
        continue;
      havekids = 1;
80104813:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010481a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010481d:	8b 40 0c             	mov    0xc(%eax),%eax
80104820:	83 f8 05             	cmp    $0x5,%eax
80104823:	75 70                	jne    80104895 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104825:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104828:	8b 40 10             	mov    0x10(%eax),%eax
8010482b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010482e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104831:	8b 40 08             	mov    0x8(%eax),%eax
80104834:	89 04 24             	mov    %eax,(%esp)
80104837:	e8 e9 e1 ff ff       	call   80102a25 <kfree>
        p->kstack = 0;
8010483c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104846:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104849:	8b 40 04             	mov    0x4(%eax),%eax
8010484c:	89 04 24             	mov    %eax,(%esp)
8010484f:	e8 47 42 00 00       	call   80108a9b <freevm>
        p->state = UNUSED;
80104854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104857:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104861:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104875:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487c:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104883:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
8010488a:	e8 81 0d 00 00       	call   80105610 <release>
        return pid;
8010488f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104892:	eb 56                	jmp    801048ea <wait+0x110>
        continue;
80104894:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104895:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
8010489c:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
801048a3:	0f 82 56 ff ff ff    	jb     801047ff <wait+0x25>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801048a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801048ad:	74 0d                	je     801048bc <wait+0xe2>
801048af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b5:	8b 40 24             	mov    0x24(%eax),%eax
801048b8:	85 c0                	test   %eax,%eax
801048ba:	74 13                	je     801048cf <wait+0xf5>
      release(&ptable.lock);
801048bc:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048c3:	e8 48 0d 00 00       	call   80105610 <release>
      return -1;
801048c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048cd:	eb 1b                	jmp    801048ea <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801048cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d5:	c7 44 24 04 00 10 11 	movl   $0x80111000,0x4(%esp)
801048dc:	80 
801048dd:	89 04 24             	mov    %eax,(%esp)
801048e0:	e8 01 02 00 00       	call   80104ae6 <sleep>
  }
801048e5:	e9 02 ff ff ff       	jmp    801047ec <wait+0x12>
}
801048ea:	c9                   	leave  
801048eb:	c3                   	ret    

801048ec <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801048ec:	55                   	push   %ebp
801048ed:	89 e5                	mov    %esp,%ebp
801048ef:	83 ec 28             	sub    $0x28,%esp
  int i; // New: Added in project 2
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801048f2:	e8 01 f7 ff ff       	call   80103ff8 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048f7:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048fe:	e8 ab 0c 00 00       	call   801055ae <acquire>
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue; // continue, move pointer

    // Set pointer p in zero (null)
    p=0;
80104903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    // Loop over MLF table looking for process to run.
    for(i=0; i<MLF_LEVELS; i++){
8010490a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104911:	eb 22                	jmp    80104935 <scheduler+0x49>
      if(!isempty(i)){
80104913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104916:	89 04 24             	mov    %eax,(%esp)
80104919:	e8 2d f8 ff ff       	call   8010414b <isempty>
8010491e:	85 c0                	test   %eax,%eax
80104920:	75 10                	jne    80104932 <scheduler+0x46>
        // New - when a proc state changes to RUNNING it must be dequeued
        p=dequeue(i);
80104922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104925:	89 04 24             	mov    %eax,(%esp)
80104928:	e8 cf f7 ff ff       	call   801040fc <dequeue>
8010492d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        break;
80104930:	eb 09                	jmp    8010493b <scheduler+0x4f>
    for(i=0; i<MLF_LEVELS; i++){
80104932:	ff 45 f4             	incl   -0xc(%ebp)
80104935:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104939:	7e d8                	jle    80104913 <scheduler+0x27>
      }
    }

    // If pointer not null (RUNNABLE proccess found)
    if (p) {
8010493b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010493f:	74 57                	je     80104998 <scheduler+0xac>
      proc = p; //(ahora, el proceso actual en esta cpu).
80104941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104944:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      // proc = p; // p->state == RUNNABLE
      
      switchuvm(p); // Switch TSS and h/w page table to correspond to process p.
8010494a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010494d:	89 04 24             	mov    %eax,(%esp)
80104950:	e8 c0 3c 00 00       	call   80108615 <switchuvm>
      p->state = RUNNING;
80104955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104958:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->ticksProc = 0;  // New - when a proccess takes control, set ticksCounter on zero
8010495f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104962:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
      //cprintf("proccess %s takes control of the CPU...\n",p->name);
      swtch(&cpu->scheduler, proc->context);
80104969:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104972:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104979:	83 c2 04             	add    $0x4,%edx
8010497c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104980:	89 14 24             	mov    %edx,(%esp)
80104983:	e8 f8 10 00 00       	call   80105a80 <swtch>
      switchkvm();
80104988:	e8 6b 3c 00 00       	call   801085f8 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
8010498d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104994:	00 00 00 00 
    }
    release(&ptable.lock);
80104998:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
8010499f:	e8 6c 0c 00 00       	call   80105610 <release>

  }
801049a4:	e9 49 ff ff ff       	jmp    801048f2 <scheduler+0x6>

801049a9 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801049a9:	55                   	push   %ebp
801049aa:	89 e5                	mov    %esp,%ebp
801049ac:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801049af:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801049b6:	e8 1b 0d 00 00       	call   801056d6 <holding>
801049bb:	85 c0                	test   %eax,%eax
801049bd:	75 0c                	jne    801049cb <sched+0x22>
    panic("sched ptable.lock");
801049bf:	c7 04 24 70 91 10 80 	movl   $0x80109170,(%esp)
801049c6:	e8 6b bb ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
801049cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049d1:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801049d7:	83 f8 01             	cmp    $0x1,%eax
801049da:	74 0c                	je     801049e8 <sched+0x3f>
    panic("sched locks");
801049dc:	c7 04 24 82 91 10 80 	movl   $0x80109182,(%esp)
801049e3:	e8 4e bb ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
801049e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ee:	8b 40 0c             	mov    0xc(%eax),%eax
801049f1:	83 f8 04             	cmp    $0x4,%eax
801049f4:	75 0c                	jne    80104a02 <sched+0x59>
    panic("sched running");
801049f6:	c7 04 24 8e 91 10 80 	movl   $0x8010918e,(%esp)
801049fd:	e8 34 bb ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80104a02:	e8 dc f5 ff ff       	call   80103fe3 <readeflags>
80104a07:	25 00 02 00 00       	and    $0x200,%eax
80104a0c:	85 c0                	test   %eax,%eax
80104a0e:	74 0c                	je     80104a1c <sched+0x73>
    panic("sched interruptible");
80104a10:	c7 04 24 9c 91 10 80 	movl   $0x8010919c,(%esp)
80104a17:	e8 1a bb ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104a1c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a22:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104a28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104a2b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a31:	8b 40 04             	mov    0x4(%eax),%eax
80104a34:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a3b:	83 c2 1c             	add    $0x1c,%edx
80104a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a42:	89 14 24             	mov    %edx,(%esp)
80104a45:	e8 36 10 00 00       	call   80105a80 <swtch>
  cpu->intena = intena;
80104a4a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a53:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104a59:	c9                   	leave  
80104a5a:	c3                   	ret    

80104a5b <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104a5b:	55                   	push   %ebp
80104a5c:	89 e5                	mov    %esp,%ebp
80104a5e:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a61:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104a68:	e8 41 0b 00 00       	call   801055ae <acquire>
  // proc->state = RUNNABLE;
  // sched();
  if(proc->priority<3){ 
80104a6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a73:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a79:	83 f8 02             	cmp    $0x2,%eax
80104a7c:	7f 13                	jg     80104a91 <yield+0x36>
    proc->priority++;
80104a7e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a84:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a8a:	42                   	inc    %edx
80104a8b:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  makerunnable(proc,1); // New: Added in proyect 2: enqueue proc
80104a91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a97:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104a9e:	00 
80104a9f:	89 04 24             	mov    %eax,(%esp)
80104aa2:	e8 c8 f6 ff ff       	call   8010416f <makerunnable>
  sched(); 
80104aa7:	e8 fd fe ff ff       	call   801049a9 <sched>
  release(&ptable.lock);
80104aac:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104ab3:	e8 58 0b 00 00       	call   80105610 <release>
}
80104ab8:	c9                   	leave  
80104ab9:	c3                   	ret    

80104aba <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104aba:	55                   	push   %ebp
80104abb:	89 e5                	mov    %esp,%ebp
80104abd:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ac0:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104ac7:	e8 44 0b 00 00       	call   80105610 <release>

  if (first) {
80104acc:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104ad1:	85 c0                	test   %eax,%eax
80104ad3:	74 0f                	je     80104ae4 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104ad5:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104adc:	00 00 00 
    initlog();
80104adf:	e8 de e4 ff ff       	call   80102fc2 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104ae4:	c9                   	leave  
80104ae5:	c3                   	ret    

80104ae6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104ae6:	55                   	push   %ebp
80104ae7:	89 e5                	mov    %esp,%ebp
80104ae9:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104aec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104af2:	85 c0                	test   %eax,%eax
80104af4:	75 0c                	jne    80104b02 <sleep+0x1c>
    panic("sleep");
80104af6:	c7 04 24 b0 91 10 80 	movl   $0x801091b0,(%esp)
80104afd:	e8 34 ba ff ff       	call   80100536 <panic>

  if(lk == 0)
80104b02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b06:	75 0c                	jne    80104b14 <sleep+0x2e>
    panic("sleep without lk");
80104b08:	c7 04 24 b6 91 10 80 	movl   $0x801091b6,(%esp)
80104b0f:	e8 22 ba ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b14:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b1b:	74 17                	je     80104b34 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b1d:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b24:	e8 85 0a 00 00       	call   801055ae <acquire>
    release(lk);
80104b29:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b2c:	89 04 24             	mov    %eax,(%esp)
80104b2f:	e8 dc 0a 00 00       	call   80105610 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104b34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b3d:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING; 
80104b40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b46:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  // New -  when a proc goes to SLEEPING state, increase priority
  if(proc->priority > 0){ // New: Added in proyect 2
80104b4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b53:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b59:	85 c0                	test   %eax,%eax
80104b5b:	7e 13                	jle    80104b70 <sleep+0x8a>
    proc->priority--;
80104b5d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b63:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b69:	4a                   	dec    %edx
80104b6a:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  sched();
80104b70:	e8 34 fe ff ff       	call   801049a9 <sched>

  // Tidy up.
  proc->chan = 0;
80104b75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b7b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104b82:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b89:	74 17                	je     80104ba2 <sleep+0xbc>
    release(&ptable.lock);
80104b8b:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b92:	e8 79 0a 00 00       	call   80105610 <release>
    acquire(lk);
80104b97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9a:	89 04 24             	mov    %eax,(%esp)
80104b9d:	e8 0c 0a 00 00       	call   801055ae <acquire>
  }
}
80104ba2:	c9                   	leave  
80104ba3:	c3                   	ret    

80104ba4 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104ba4:	55                   	push   %ebp
80104ba5:	89 e5                	mov    %esp,%ebp
80104ba7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104baa:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104bb1:	eb 30                	jmp    80104be3 <wakeup1+0x3f>
    // if(p->state == SLEEPING && p->chan == chan)
    //   p->state = RUNNABLE;
    if(p->state == SLEEPING && p->chan == chan){ // Added in project 2
80104bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb6:	8b 40 0c             	mov    0xc(%eax),%eax
80104bb9:	83 f8 02             	cmp    $0x2,%eax
80104bbc:	75 1e                	jne    80104bdc <wakeup1+0x38>
80104bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc1:	8b 40 20             	mov    0x20(%eax),%eax
80104bc4:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bc7:	75 13                	jne    80104bdc <wakeup1+0x38>
      // New - enqueue proc
      makerunnable(p,-1);
80104bc9:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
80104bd0:	ff 
80104bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd4:	89 04 24             	mov    %eax,(%esp)
80104bd7:	e8 93 f5 ff ff       	call   8010416f <makerunnable>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bdc:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104be3:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104bea:	72 c7                	jb     80104bb3 <wakeup1+0xf>
    }
}
80104bec:	c9                   	leave  
80104bed:	c3                   	ret    

80104bee <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104bee:	55                   	push   %ebp
80104bef:	89 e5                	mov    %esp,%ebp
80104bf1:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104bf4:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104bfb:	e8 ae 09 00 00       	call   801055ae <acquire>
  wakeup1(chan);
80104c00:	8b 45 08             	mov    0x8(%ebp),%eax
80104c03:	89 04 24             	mov    %eax,(%esp)
80104c06:	e8 99 ff ff ff       	call   80104ba4 <wakeup1>
  release(&ptable.lock);
80104c0b:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c12:	e8 f9 09 00 00       	call   80105610 <release>
}
80104c17:	c9                   	leave  
80104c18:	c3                   	ret    

80104c19 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c19:	55                   	push   %ebp
80104c1a:	89 e5                	mov    %esp,%ebp
80104c1c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c1f:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c26:	e8 83 09 00 00       	call   801055ae <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c2b:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104c32:	eb 4d                	jmp    80104c81 <kill+0x68>
    if(p->pid == pid){
80104c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c37:	8b 40 10             	mov    0x10(%eax),%eax
80104c3a:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c3d:	75 3b                	jne    80104c7a <kill+0x61>
      p->killed = 1;
80104c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c42:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      // if(p->state == SLEEPING)
      //   p->state = RUNNABLE;
      if(p->state == SLEEPING){ // Added in proyect 2
80104c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c4c:	8b 40 0c             	mov    0xc(%eax),%eax
80104c4f:	83 f8 02             	cmp    $0x2,%eax
80104c52:	75 13                	jne    80104c67 <kill+0x4e>
        // New - enqueue proc
        makerunnable(p,0);
80104c54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c5b:	00 
80104c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c5f:	89 04 24             	mov    %eax,(%esp)
80104c62:	e8 08 f5 ff ff       	call   8010416f <makerunnable>
      }
      release(&ptable.lock);
80104c67:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c6e:	e8 9d 09 00 00       	call   80105610 <release>
      return 0;
80104c73:	b8 00 00 00 00       	mov    $0x0,%eax
80104c78:	eb 21                	jmp    80104c9b <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c7a:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104c81:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104c88:	72 aa                	jb     80104c34 <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104c8a:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c91:	e8 7a 09 00 00       	call   80105610 <release>
  return -1;
80104c96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c9b:	c9                   	leave  
80104c9c:	c3                   	ret    

80104c9d <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	83 ec 68             	sub    $0x68,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ca3:	c7 45 f0 34 10 11 80 	movl   $0x80111034,-0x10(%ebp)
80104caa:	e9 e7 00 00 00       	jmp    80104d96 <procdump+0xf9>
    if(p->state == UNUSED)
80104caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb2:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb5:	85 c0                	test   %eax,%eax
80104cb7:	0f 84 d1 00 00 00    	je     80104d8e <procdump+0xf1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cc0:	8b 40 0c             	mov    0xc(%eax),%eax
80104cc3:	83 f8 05             	cmp    $0x5,%eax
80104cc6:	77 23                	ja     80104ceb <procdump+0x4e>
80104cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ccb:	8b 40 0c             	mov    0xc(%eax),%eax
80104cce:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104cd5:	85 c0                	test   %eax,%eax
80104cd7:	74 12                	je     80104ceb <procdump+0x4e>
      state = states[p->state];
80104cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cdc:	8b 40 0c             	mov    0xc(%eax),%eax
80104cdf:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ce9:	eb 07                	jmp    80104cf2 <procdump+0x55>
    else
      state = "???";
80104ceb:	c7 45 ec c7 91 10 80 	movl   $0x801091c7,-0x14(%ebp)
    // cprintf("%d %s %s", p->pid, state, p->name);
    cprintf("%d %s %s %d", p->pid, state, p->name, p->priority);
80104cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cf5:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cfe:	8d 48 6c             	lea    0x6c(%eax),%ecx
80104d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d04:	8b 40 10             	mov    0x10(%eax),%eax
80104d07:	89 54 24 10          	mov    %edx,0x10(%esp)
80104d0b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80104d0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d12:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d16:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d1a:	c7 04 24 cb 91 10 80 	movl   $0x801091cb,(%esp)
80104d21:	e8 7b b6 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d29:	8b 40 0c             	mov    0xc(%eax),%eax
80104d2c:	83 f8 02             	cmp    $0x2,%eax
80104d2f:	75 4f                	jne    80104d80 <procdump+0xe3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d34:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d37:	8b 40 0c             	mov    0xc(%eax),%eax
80104d3a:	83 c0 08             	add    $0x8,%eax
80104d3d:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d40:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d44:	89 04 24             	mov    %eax,(%esp)
80104d47:	e8 13 09 00 00       	call   8010565f <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d53:	eb 1a                	jmp    80104d6f <procdump+0xd2>
        cprintf(" %p", pc[i]);
80104d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d58:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d60:	c7 04 24 d7 91 10 80 	movl   $0x801091d7,(%esp)
80104d67:	e8 35 b6 ff ff       	call   801003a1 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d6c:	ff 45 f4             	incl   -0xc(%ebp)
80104d6f:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104d73:	7f 0b                	jg     80104d80 <procdump+0xe3>
80104d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d78:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d7c:	85 c0                	test   %eax,%eax
80104d7e:	75 d5                	jne    80104d55 <procdump+0xb8>
    }
    cprintf("\n");
80104d80:	c7 04 24 db 91 10 80 	movl   $0x801091db,(%esp)
80104d87:	e8 15 b6 ff ff       	call   801003a1 <cprintf>
80104d8c:	eb 01                	jmp    80104d8f <procdump+0xf2>
      continue;
80104d8e:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d8f:	81 45 f0 ac 00 00 00 	addl   $0xac,-0x10(%ebp)
80104d96:	81 7d f0 34 3b 11 80 	cmpl   $0x80113b34,-0x10(%ebp)
80104d9d:	0f 82 0c ff ff ff    	jb     80104caf <procdump+0x12>
  }
}
80104da3:	c9                   	leave  
80104da4:	c3                   	ret    

80104da5 <checkprocsem>:
	struct sem sem[MAXSEM]; // atrib. (value,refcount) (MAXSEM = 16)
} stable;

// proc->procsem es la lista de semaforos por proceso
// MAXSEMPROC = 4 es la cantidad maxima de semaforos por proceso
struct sem** checkprocsem(){
80104da5:	55                   	push   %ebp
80104da6:	89 e5                	mov    %esp,%ebp
80104da8:	83 ec 10             	sub    $0x10,%esp
	struct sem **r;
	// a "r" le asigno el arreglo de la list of semaphores del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104dab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db1:	05 88 00 00 00       	add    $0x88,%eax
80104db6:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104db9:	eb 12                	jmp    80104dcd <checkprocsem+0x28>
		if (*r == 0)
80104dbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dbe:	8b 00                	mov    (%eax),%eax
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	75 05                	jne    80104dc9 <checkprocsem+0x24>
			return r;
80104dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dc7:	eb 19                	jmp    80104de2 <checkprocsem+0x3d>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104dc9:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
80104dcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dd3:	05 98 00 00 00       	add    $0x98,%eax
80104dd8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104ddb:	77 de                	ja     80104dbb <checkprocsem+0x16>
	}
	return 0;
80104ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104de2:	c9                   	leave  
80104de3:	c3                   	ret    

80104de4 <getstable>:

struct sem* getstable(){
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
	return stable.sem;
80104de7:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
}
80104dec:	5d                   	pop    %ebp
80104ded:	c3                   	ret    

80104dee <semget>:

// crea u obtiene un descriptor de un semaforo existente
int semget(int sem_id, int init_value){
80104dee:	55                   	push   %ebp
80104def:	89 e5                	mov    %esp,%ebp
80104df1:	83 ec 28             	sub    $0x28,%esp
	struct sem *t;
	struct sem *s;
	struct sem **r;
	static int first_time = 1;

	if (first_time) {
80104df4:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80104df9:	85 c0                	test   %eax,%eax
80104dfb:	74 1e                	je     80104e1b <semget+0x2d>
		initlock(&stable.lock, "stable"); // begin the mutual exclusion
80104dfd:	c7 44 24 04 07 92 10 	movl   $0x80109207,0x4(%esp)
80104e04:	80 
80104e05:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e0c:	e8 7c 07 00 00       	call   8010558d <initlock>
		first_time = 0;
80104e11:	c7 05 24 c0 10 80 00 	movl   $0x0,0x8010c024
80104e18:	00 00 00 
	}

	acquire(&stable.lock);
80104e1b:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e22:	e8 87 07 00 00       	call   801055ae <acquire>
	if (sem_id == -1) { // se desea CREAR un semaforo nuevo
80104e27:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
80104e2b:	0f 85 9d 00 00 00    	jne    80104ece <semget+0xe0>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e31:	c7 45 f4 94 3b 11 80 	movl   $0x80113b94,-0xc(%ebp)
80104e38:	eb 3b                	jmp    80104e75 <semget+0x87>
		if (t->refcount == 0){
80104e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3d:	8b 40 04             	mov    0x4(%eax),%eax
80104e40:	85 c0                	test   %eax,%eax
80104e42:	75 2d                	jne    80104e71 <semget+0x83>
			s = t;
80104e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (*(r = checkprocsem()) == 0)
80104e4a:	e8 56 ff ff ff       	call   80104da5 <checkprocsem>
80104e4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e52:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e55:	8b 00                	mov    (%eax),%eax
80104e57:	85 c0                	test   %eax,%eax
80104e59:	74 39                	je     80104e94 <semget+0xa6>
				goto found; // encontro
			release(&stable.lock);
80104e5b:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e62:	e8 a9 07 00 00       	call   80105610 <release>
			return -2; // el proceso ya obtuvo el numero maximo de semaforos
80104e67:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104e6c:	e9 d8 00 00 00       	jmp    80104f49 <semget+0x15b>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e71:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80104e75:	81 7d f4 14 3c 11 80 	cmpl   $0x80113c14,-0xc(%ebp)
80104e7c:	72 bc                	jb     80104e3a <semget+0x4c>
		}
		release(&stable.lock);
80104e7e:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e85:	e8 86 07 00 00       	call   80105610 <release>
		return -3; // no ahi mas semaforos disponibles en el sistema
80104e8a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80104e8f:	e9 b5 00 00 00       	jmp    80104f49 <semget+0x15b>
				goto found; // encontro
80104e94:	90                   	nop

		found:
		s->value = init_value;
80104e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e98:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e9b:	89 10                	mov    %edx,(%eax)
		s->refcount=1;
80104e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea0:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
		*r = s;
80104ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eaa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ead:	89 10                	mov    %edx,(%eax)
		// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i));
		// 	} else
		// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i) - stable.sem);
		// }

		release(&stable.lock);
80104eaf:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104eb6:	e8 55 07 00 00       	call   80105610 <release>
		return s - stable.sem;	
80104ebb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ebe:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
80104ec3:	89 d1                	mov    %edx,%ecx
80104ec5:	29 c1                	sub    %eax,%ecx
80104ec7:	89 c8                	mov    %ecx,%eax
80104ec9:	c1 f8 03             	sar    $0x3,%eax
80104ecc:	eb 7b                	jmp    80104f49 <semget+0x15b>

	} else { // en caso de que NO se desea crear un semaforo nuevo
		s = stable.sem + sem_id;
80104ece:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed1:	83 c0 06             	add    $0x6,%eax
80104ed4:	c1 e0 03             	shl    $0x3,%eax
80104ed7:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104edc:	83 c0 04             	add    $0x4,%eax
80104edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (s->refcount == 0){
80104ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ee5:	8b 40 04             	mov    0x4(%eax),%eax
80104ee8:	85 c0                	test   %eax,%eax
80104eea:	75 13                	jne    80104eff <semget+0x111>
			release(&stable.lock);
80104eec:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104ef3:	e8 18 07 00 00       	call   80105610 <release>
			return -1; // el semaforo con ese "sem_id" no esta en uso 
80104ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104efd:	eb 4a                	jmp    80104f49 <semget+0x15b>
		}else if (*(r = checkprocsem()) == 0){
80104eff:	e8 a1 fe ff ff       	call   80104da5 <checkprocsem>
80104f04:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f0a:	8b 00                	mov    (%eax),%eax
80104f0c:	85 c0                	test   %eax,%eax
80104f0e:	75 28                	jne    80104f38 <semget+0x14a>
			*r = s;
80104f10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f16:	89 10                	mov    %edx,(%eax)
			s->refcount++;
80104f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f1b:	8b 40 04             	mov    0x4(%eax),%eax
80104f1e:	8d 50 01             	lea    0x1(%eax),%edx
80104f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f24:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80104f27:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104f2e:	e8 dd 06 00 00       	call   80105610 <release>
			return sem_id;
80104f33:	8b 45 08             	mov    0x8(%ebp),%eax
80104f36:	eb 11                	jmp    80104f49 <semget+0x15b>
		}	else {
			release(&stable.lock);
80104f38:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104f3f:	e8 cc 06 00 00       	call   80105610 <release>
			return -2; // el proceso ya obtuvo el maximo de semaforos
80104f44:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

		}
	}
}
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    

80104f4b <semfree>:

// libera el semaforo.
// como parametro toma un descriptor.
int semfree(int sem_id){
80104f4b:	55                   	push   %ebp
80104f4c:	89 e5                	mov    %esp,%ebp
80104f4e:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;
	struct sem **r;

	s = stable.sem + sem_id;
80104f51:	8b 45 08             	mov    0x8(%ebp),%eax
80104f54:	83 c0 06             	add    $0x6,%eax
80104f57:	c1 e0 03             	shl    $0x3,%eax
80104f5a:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104f5f:	83 c0 04             	add    $0x4,%eax
80104f62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (s->refcount == 0) // si no tiene ninguna referencia, entonces no esta en uso,	
80104f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f68:	8b 40 04             	mov    0x4(%eax),%eax
80104f6b:	85 c0                	test   %eax,%eax
80104f6d:	75 07                	jne    80104f76 <semfree+0x2b>
		return -1;		 //  y no es posible liberarlo, se produce un ERROR! 
80104f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f74:	eb 6a                	jmp    80104fe0 <semfree+0x95>

	// recorro todos los semaforos del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104f76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f7c:	05 88 00 00 00       	add    $0x88,%eax
80104f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f84:	eb 45                	jmp    80104fcb <semfree+0x80>
		if (*r == s) {
80104f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f89:	8b 00                	mov    (%eax),%eax
80104f8b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104f8e:	75 37                	jne    80104fc7 <semfree+0x7c>
			*r = 0;
80104f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			acquire(&stable.lock);
80104f99:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fa0:	e8 09 06 00 00       	call   801055ae <acquire>
			s->refcount--; // disminuyo el contador, debido a q es un semaforo q se va.
80104fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa8:	8b 40 04             	mov    0x4(%eax),%eax
80104fab:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb1:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80104fb4:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fbb:	e8 50 06 00 00       	call   80105610 <release>
			return 0;
80104fc0:	b8 00 00 00 00       	mov    $0x0,%eax
80104fc5:	eb 19                	jmp    80104fe0 <semfree+0x95>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104fc7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
80104fcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd1:	05 98 00 00 00       	add    $0x98,%eax
80104fd6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104fd9:	77 ab                	ja     80104f86 <semfree+0x3b>
		}
	}
	return -1;
80104fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe0:	c9                   	leave  
80104fe1:	c3                   	ret    

80104fe2 <semdown>:

// decrementa una unidad el valor del semaforo.
int semdown(int sem_id){
80104fe2:	55                   	push   %ebp
80104fe3:	89 e5                	mov    %esp,%ebp
80104fe5:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;

	s = stable.sem + sem_id;
80104fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80104feb:	83 c0 06             	add    $0x6,%eax
80104fee:	c1 e0 03             	shl    $0x3,%eax
80104ff1:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104ff6:	83 c0 04             	add    $0x4,%eax
80104ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
80104ffc:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105003:	e8 a6 05 00 00       	call   801055ae <acquire>
	if (s->refcount <= 0) {
80105008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500b:	8b 40 04             	mov    0x4(%eax),%eax
8010500e:	85 c0                	test   %eax,%eax
80105010:	7f 28                	jg     8010503a <semdown+0x58>
		release(&stable.lock);
80105012:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105019:	e8 f2 05 00 00       	call   80105610 <release>
		// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error!!
8010501e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105023:	eb 3d                	jmp    80105062 <semdown+0x80>
	}
	while (s->value == 0)
	sleep(s, &stable.lock); 
80105025:	c7 44 24 04 60 3b 11 	movl   $0x80113b60,0x4(%esp)
8010502c:	80 
8010502d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105030:	89 04 24             	mov    %eax,(%esp)
80105033:	e8 ae fa ff ff       	call   80104ae6 <sleep>
80105038:	eb 01                	jmp    8010503b <semdown+0x59>
	while (s->value == 0)
8010503a:	90                   	nop
8010503b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010503e:	8b 00                	mov    (%eax),%eax
80105040:	85 c0                	test   %eax,%eax
80105042:	74 e1                	je     80105025 <semdown+0x43>

	s->value--;
80105044:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105047:	8b 00                	mov    (%eax),%eax
80105049:	8d 50 ff             	lea    -0x1(%eax),%edx
8010504c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504f:	89 10                	mov    %edx,(%eax)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	release(&stable.lock);
80105051:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105058:	e8 b3 05 00 00       	call   80105610 <release>
	return 0;
8010505d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105062:	c9                   	leave  
80105063:	c3                   	ret    

80105064 <semup>:

// incrementa una unidad el valor del semaforo
int semup(int sem_id){
80105064:	55                   	push   %ebp
80105065:	89 e5                	mov    %esp,%ebp
80105067:	83 ec 28             	sub    $0x28,%esp
struct sem *s;

	s = stable.sem + sem_id;
8010506a:	8b 45 08             	mov    0x8(%ebp),%eax
8010506d:	83 c0 06             	add    $0x6,%eax
80105070:	c1 e0 03             	shl    $0x3,%eax
80105073:	05 60 3b 11 80       	add    $0x80113b60,%eax
80105078:	83 c0 04             	add    $0x4,%eax
8010507b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
8010507e:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105085:	e8 24 05 00 00       	call   801055ae <acquire>
	if (s->refcount <= 0) {
8010508a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010508d:	8b 40 04             	mov    0x4(%eax),%eax
80105090:	85 c0                	test   %eax,%eax
80105092:	7f 13                	jg     801050a7 <semup+0x43>
		release(&stable.lock);
80105094:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
8010509b:	e8 70 05 00 00       	call   80105610 <release>
		// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error, por que no ahi referencias en este semaforo.
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb 4a                	jmp    801050f1 <semup+0x8d>
	}
	if (s->value >= 0) {
801050a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050aa:	8b 00                	mov    (%eax),%eax
801050ac:	85 c0                	test   %eax,%eax
801050ae:	78 3c                	js     801050ec <semup+0x88>
		if (s->value == 0){
801050b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b3:	8b 00                	mov    (%eax),%eax
801050b5:	85 c0                	test   %eax,%eax
801050b7:	75 1a                	jne    801050d3 <semup+0x6f>
			s->value++;
801050b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bc:	8b 00                	mov    (%eax),%eax
801050be:	8d 50 01             	lea    0x1(%eax),%edx
801050c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c4:	89 10                	mov    %edx,(%eax)
			wakeup(s); // despierto
801050c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c9:	89 04 24             	mov    %eax,(%esp)
801050cc:	e8 1d fb ff ff       	call   80104bee <wakeup>
801050d1:	eb 0d                	jmp    801050e0 <semup+0x7c>
		}else
			s->value++;
801050d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d6:	8b 00                	mov    (%eax),%eax
801050d8:	8d 50 01             	lea    0x1(%eax),%edx
801050db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050de:	89 10                	mov    %edx,(%eax)
			release(&stable.lock);
801050e0:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
801050e7:	e8 24 05 00 00       	call   80105610 <release>
			// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	}
	return 0;
801050ec:	b8 00 00 00 00       	mov    $0x0,%eax
801050f1:	c9                   	leave  
801050f2:	c3                   	ret    

801050f3 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801050f3:	55                   	push   %ebp
801050f4:	89 e5                	mov    %esp,%ebp
801050f6:	8b 45 08             	mov    0x8(%ebp),%eax
801050f9:	05 00 00 00 80       	add    $0x80000000,%eax
801050fe:	5d                   	pop    %ebp
801050ff:	c3                   	ret    

80105100 <shm_init>:
//   unsigned short quantity; //quantity of actives espaces of shared memory
// } shmtable;

int
shm_init()
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&shmtable.lock, "shmtable");
80105106:	c7 44 24 04 0e 92 10 	movl   $0x8010920e,0x4(%esp)
8010510d:	80 
8010510e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105115:	e8 73 04 00 00       	call   8010558d <initlock>
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
8010511a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105121:	eb 11                	jmp    80105134 <shm_init+0x34>
    shmtable.sharedmemory[i].refcount = -1; // inician todos los espacios con su contador de referencia en -1.
80105123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105126:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
8010512d:	ff ff ff ff 
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
80105131:	ff 45 f4             	incl   -0xc(%ebp)
80105134:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80105138:	7e e9                	jle    80105123 <shm_init+0x23>
  }
  return 0;
8010513a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010513f:	c9                   	leave  
80105140:	c3                   	ret    

80105141 <shm_create>:

//Creates a shared memory block.
int
shm_create()
{ 
80105141:	55                   	push   %ebp
80105142:	89 e5                	mov    %esp,%ebp
80105144:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);
80105147:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010514e:	e8 5b 04 00 00       	call   801055ae <acquire>
  if ( shmtable.quantity == MAXSHM ){ // si la cantidad de espacios activos en sharedmemory es igual a 12
80105153:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
80105158:	66 83 f8 0c          	cmp    $0xc,%ax
8010515c:	75 16                	jne    80105174 <shm_create+0x33>
    release(&shmtable.lock);         // es la logitud maxima del array sharedmemory, entonces:
8010515e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105165:	e8 a6 04 00 00       	call   80105610 <release>
    return -1;                      // no ahi mas espacios de memoria compartida, se fueron los 12 espacios que habia.
8010516a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516f:	e9 97 00 00 00       	jmp    8010520b <shm_create+0xca>
  }
  int i = 0;
80105174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
8010517b:	eb 77                	jmp    801051f4 <shm_create+0xb3>
    if (shmtable.sharedmemory[i].refcount == -1){ // si es -1, esta desocupado el espacio.
8010517d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105180:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105187:	83 f8 ff             	cmp    $0xffffffff,%eax
8010518a:	75 65                	jne    801051f1 <shm_create+0xb0>
      shmtable.sharedmemory[i].addr = kalloc(); // El "kalloc" asigna una pagina de 4096 bytes de memoria fisica,
8010518c:	e8 2d d9 ff ff       	call   80102abe <kalloc>
80105191:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105194:	89 04 d5 60 0f 11 80 	mov    %eax,-0x7feef0a0(,%edx,8)
                                                // si todo sale bien, me retorna como resultado un puntero (direccion), 
                                                // a esta direccion la almaceno en "sharedmemory.addr".
                                                // Si el kalloc no pudo asignar la memoria me devuelve como resultado 0.
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE); 
8010519b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519e:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
801051a5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801051ac:	00 
801051ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051b4:	00 
801051b5:	89 04 24             	mov    %eax,(%esp)
801051b8:	e8 43 06 00 00       	call   80105800 <memset>
      shmtable.sharedmemory[i].refcount++; // Incremento el refcount en una unidad, estaba en -1, ahora en 0, inicialmente.
801051bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051c0:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801051c7:	8d 50 01             	lea    0x1(%eax),%edx
801051ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cd:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
      shmtable.quantity++; // se tomo un espacio del arreglo 
801051d4:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
801051d9:	40                   	inc    %eax
801051da:	66 a3 f4 0f 11 80    	mov    %ax,0x80110ff4
      release(&shmtable.lock);
801051e0:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801051e7:	e8 24 04 00 00       	call   80105610 <release>
      return i; // retorno el indice (key) del arreglo en donde se encuentra el espacio de memoria compartida.
801051ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ef:	eb 1a                	jmp    8010520b <shm_create+0xca>
    } else
      ++i;
801051f1:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
801051f4:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
801051f8:	7e 83                	jle    8010517d <shm_create+0x3c>
  }
  release(&shmtable.lock);
801051fa:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105201:	e8 0a 04 00 00       	call   80105610 <release>
  //return -2 si proc->sharedmemory == MAXSHMPROC; // Consultar?: el proceso ya alcanzo el maximo de recursos posibles.
  return -1; // no ahi mas recursos disponbles en el sistema.
80105206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010520b:	c9                   	leave  
8010520c:	c3                   	ret    

8010520d <shm_close>:

//Frees the memory block previously obtained.
int
shm_close(int key)
{
8010520d:	55                   	push   %ebp
8010520e:	89 e5                	mov    %esp,%ebp
80105210:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);  
80105213:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010521a:	e8 8f 03 00 00       	call   801055ae <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == -1){
8010521f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105223:	78 15                	js     8010523a <shm_close+0x2d>
80105225:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
80105229:	7f 0f                	jg     8010523a <shm_close+0x2d>
8010522b:	8b 45 08             	mov    0x8(%ebp),%eax
8010522e:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105235:	83 f8 ff             	cmp    $0xffffffff,%eax
80105238:	75 16                	jne    80105250 <shm_close+0x43>
    release(&shmtable.lock);
8010523a:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105241:	e8 ca 03 00 00       	call   80105610 <release>
    return -1; // key invalidad por que no esta dentro de los indices (0 - 12), o en ese espacio esta vacio (refcount = -1)
80105246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010524b:	e9 8d 00 00 00       	jmp    801052dd <shm_close+0xd0>
  }
  int i = 0;
80105250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
80105257:	eb 03                	jmp    8010525c <shm_close+0x4f>
    i++; // avanzo al proximo
80105259:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
8010525c:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80105260:	7f 1e                	jg     80105280 <shm_close+0x73>
80105262:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105268:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010526b:	83 c2 24             	add    $0x24,%edx
8010526e:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80105272:	8b 45 08             	mov    0x8(%ebp),%eax
80105275:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
8010527c:	39 c2                	cmp    %eax,%edx
8010527e:	75 d9                	jne    80105259 <shm_close+0x4c>
  }
  if (i == MAXSHMPROC){ 
80105280:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80105284:	75 13                	jne    80105299 <shm_close+0x8c>
    release(&shmtable.lock);
80105286:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010528d:	e8 7e 03 00 00       	call   80105610 <release>
    return -1; // se alcazo a recorrer todos los espacios de memoria compartida del proceso.
80105292:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105297:	eb 44                	jmp    801052dd <shm_close+0xd0>
  }  
  shmtable.sharedmemory[key].refcount--; // encontre la direccion, luego decremento refcount.
80105299:	8b 45 08             	mov    0x8(%ebp),%eax
8010529c:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801052a3:	8d 50 ff             	lea    -0x1(%eax),%edx
801052a6:	8b 45 08             	mov    0x8(%ebp),%eax
801052a9:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
  if (shmtable.sharedmemory[key].refcount == 0){ 
801052b0:	8b 45 08             	mov    0x8(%ebp),%eax
801052b3:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801052ba:	85 c0                	test   %eax,%eax
801052bc:	75 0e                	jne    801052cc <shm_close+0xbf>
    shmtable.sharedmemory[key].refcount = -1; // reinicio el espacio en el arreglo, como solo quedo uno, lo reinicio.
801052be:	8b 45 08             	mov    0x8(%ebp),%eax
801052c1:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
801052c8:	ff ff ff ff 
  }
  release(&shmtable.lock);
801052cc:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052d3:	e8 38 03 00 00       	call   80105610 <release>
  return 0;  // todo en orden
801052d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052dd:	c9                   	leave  
801052de:	c3                   	ret    

801052df <shm_get>:

//Obtains the address of the memory block associated with key.
int
shm_get(int key, char** addr)
{
801052df:	55                   	push   %ebp
801052e0:	89 e5                	mov    %esp,%ebp
801052e2:	83 ec 38             	sub    $0x38,%esp
  int j;
  acquire(&shmtable.lock);
801052e5:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052ec:	e8 bd 02 00 00       	call   801055ae <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == MAXSHMPROC ){ 
801052f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801052f5:	78 15                	js     8010530c <shm_get+0x2d>
801052f7:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
801052fb:	7f 0f                	jg     8010530c <shm_get+0x2d>
801052fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105300:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105307:	83 f8 04             	cmp    $0x4,%eax
8010530a:	75 16                	jne    80105322 <shm_get+0x43>
    release(&shmtable.lock);                 
8010530c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105313:	e8 f8 02 00 00       	call   80105610 <release>
    return -1; // key invalida, debido a que esta fuera de los indices la key.
80105318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531d:	e9 24 01 00 00       	jmp    80105446 <shm_get+0x167>
  }  
  int i = 0;
80105322:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
80105329:	eb 03                	jmp    8010532e <shm_get+0x4f>
    i++;
8010532b:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
8010532e:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80105332:	7f 14                	jg     80105348 <shm_get+0x69>
80105334:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010533a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010533d:	83 c2 24             	add    $0x24,%edx
80105340:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105344:	85 c0                	test   %eax,%eax
80105346:	75 e3                	jne    8010532b <shm_get+0x4c>
  }
  if (i == MAXSHMPROC ){ // si agoto los 4 espacios que posee el proceso disponible, entonces..
80105348:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010534c:	75 16                	jne    80105364 <shm_get+0x85>
    release(&shmtable.lock); 
8010534e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105355:	e8 b6 02 00 00       	call   80105610 <release>
    return -1; // no ahi mas recursos disponibles (esp. de memoria compartida) por este proceso.
8010535a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535f:	e9 e2 00 00 00       	jmp    80105446 <shm_get+0x167>
  } else {  
            
    j = mappages(proc->pgdir, (void *)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
80105364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105367:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
8010536e:	89 04 24             	mov    %eax,(%esp)
80105371:	e8 7d fd ff ff       	call   801050f3 <v2p>
80105376:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010537d:	8b 12                	mov    (%edx),%edx
8010537f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105385:	89 d1                	mov    %edx,%ecx
80105387:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010538e:	8b 52 04             	mov    0x4(%edx),%edx
80105391:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80105398:	00 
80105399:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010539d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801053a4:	00 
801053a5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801053a9:	89 14 24             	mov    %edx,(%esp)
801053ac:	e8 df 30 00 00       	call   80108490 <mappages>
801053b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
            // Llena entradas de la tabla de paginas, mapeo de direcciones virtuales segun direc. fisicas

            // PTE_U: controla que el proceso de usuario pueda utilizar la pagina, si no solo el kernel puede usar la pagina.
            // PTE_W: controla si las instrucciones se les permite escribir en la pagina.

    if (j==-1) { cprintf("mappages error \n"); }
801053b4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801053b8:	75 0c                	jne    801053c6 <shm_get+0xe7>
801053ba:	c7 04 24 17 92 10 80 	movl   $0x80109217,(%esp)
801053c1:	e8 db af ff ff       	call   801003a1 <cprintf>

    proc->shmref[i] = shmtable.sharedmemory[key].addr; // la guardo en shmref[i]
801053c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053cc:	8b 55 08             	mov    0x8(%ebp),%edx
801053cf:	8b 14 d5 60 0f 11 80 	mov    -0x7feef0a0(,%edx,8),%edx
801053d6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801053d9:	83 c1 24             	add    $0x24,%ecx
801053dc:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
    shmtable.sharedmemory[key].refcount++; 
801053e0:	8b 45 08             	mov    0x8(%ebp),%eax
801053e3:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801053ea:	8d 50 01             	lea    0x1(%eax),%edx
801053ed:	8b 45 08             	mov    0x8(%ebp),%eax
801053f0:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
    *addr = (char *)PGROUNDDOWN(proc->sz); // guardo la direccion en *addr, de la pagina que se encuentra por debajo de proc->sz
801053f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053fd:	8b 00                	mov    (%eax),%eax
801053ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105404:	89 c2                	mov    %eax,%edx
80105406:	8b 45 0c             	mov    0xc(%ebp),%eax
80105409:	89 10                	mov    %edx,(%eax)
    proc->shmemquantity++; // aumento la cantidad de espacio de memoria compartida por el proceso
8010540b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105411:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
80105417:	42                   	inc    %edx
80105418:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
    proc->sz = proc->sz + PGSIZE; // actualizo el tamaño de la memoria del proceso, debido a que ya se realizo el mapeo
8010541e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105424:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010542b:	8b 12                	mov    (%edx),%edx
8010542d:	81 c2 00 10 00 00    	add    $0x1000,%edx
80105433:	89 10                	mov    %edx,(%eax)
    release(&shmtable.lock);
80105435:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010543c:	e8 cf 01 00 00       	call   80105610 <release>
    return 0; // todo salio bien.
80105441:	b8 00 00 00 00       	mov    $0x0,%eax
  }   
}
80105446:	c9                   	leave  
80105447:	c3                   	ret    

80105448 <get_shm_table>:

//Obtains the array from type sharedmemory
struct sharedmemory* get_shm_table(){
80105448:	55                   	push   %ebp
80105449:	89 e5                	mov    %esp,%ebp
  return shmtable.sharedmemory; // como resultado, mi arreglo principal sharedmemory 
8010544b:	b8 60 0f 11 80       	mov    $0x80110f60,%eax
}
80105450:	5d                   	pop    %ebp
80105451:	c3                   	ret    

80105452 <sys_shm_create>:
// esta la termine definiendo en Makefile!!!!!!!! recordar

//Creates a shared memory block.
int
sys_shm_create(void)
{
80105452:	55                   	push   %ebp
80105453:	89 e5                	mov    %esp,%ebp
80105455:	83 ec 28             	sub    $0x28,%esp
  int size;
  if(argint(0, &size) < 0 && (size > 0) )
80105458:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010545b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010545f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105466:	e8 c6 06 00 00       	call   80105b31 <argint>
8010546b:	85 c0                	test   %eax,%eax
8010546d:	79 0e                	jns    8010547d <sys_shm_create+0x2b>
8010546f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105472:	85 c0                	test   %eax,%eax
80105474:	7e 07                	jle    8010547d <sys_shm_create+0x2b>
    return -1;
80105476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010547b:	eb 0b                	jmp    80105488 <sys_shm_create+0x36>
  int k = shm_create();
8010547d:	e8 bf fc ff ff       	call   80105141 <shm_create>
80105482:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return k;
80105485:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105488:	c9                   	leave  
80105489:	c3                   	ret    

8010548a <sys_shm_get>:

//Obtains the address of the memory block associated with key.
int
sys_shm_get(void)
{
8010548a:	55                   	push   %ebp
8010548b:	89 e5                	mov    %esp,%ebp
8010548d:	83 ec 28             	sub    $0x28,%esp
  int k;
  int mem = 0;  
80105490:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (proc->shmemquantity >= MAXSHMPROC)
80105497:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010549d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801054a3:	83 f8 03             	cmp    $0x3,%eax
801054a6:	7e 07                	jle    801054af <sys_shm_get+0x25>
    return -1;
801054a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ad:	eb 55                	jmp    80105504 <sys_shm_get+0x7a>
  if(argint(0, &k) < 0)
801054af:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054bd:	e8 6f 06 00 00       	call   80105b31 <argint>
801054c2:	85 c0                	test   %eax,%eax
801054c4:	79 07                	jns    801054cd <sys_shm_get+0x43>
    return -1;
801054c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054cb:	eb 37                	jmp    80105504 <sys_shm_get+0x7a>
  argint(1,&mem); 
801054cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054db:	e8 51 06 00 00       	call   80105b31 <argint>
  if (!shm_get(k,(char**)mem)){ 
801054e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054e3:	89 c2                	mov    %eax,%edx
801054e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e8:	89 54 24 04          	mov    %edx,0x4(%esp)
801054ec:	89 04 24             	mov    %eax,(%esp)
801054ef:	e8 eb fd ff ff       	call   801052df <shm_get>
801054f4:	85 c0                	test   %eax,%eax
801054f6:	75 07                	jne    801054ff <sys_shm_get+0x75>
    return 0;
801054f8:	b8 00 00 00 00       	mov    $0x0,%eax
801054fd:	eb 05                	jmp    80105504 <sys_shm_get+0x7a>
  }
  return -1;
801054ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105504:	c9                   	leave  
80105505:	c3                   	ret    

80105506 <sys_shm_close>:

//Frees the memory block previously obtained.
int
sys_shm_close(void)
{
80105506:	55                   	push   %ebp
80105507:	89 e5                	mov    %esp,%ebp
80105509:	83 ec 28             	sub    $0x28,%esp
  int k;
  if(argint(0, &k) < 0)
8010550c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105513:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010551a:	e8 12 06 00 00       	call   80105b31 <argint>
8010551f:	85 c0                	test   %eax,%eax
80105521:	79 07                	jns    8010552a <sys_shm_close+0x24>
    return -1;
80105523:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105528:	eb 1b                	jmp    80105545 <sys_shm_close+0x3f>
  if (!shm_close(k)){    
8010552a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552d:	89 04 24             	mov    %eax,(%esp)
80105530:	e8 d8 fc ff ff       	call   8010520d <shm_close>
80105535:	85 c0                	test   %eax,%eax
80105537:	75 07                	jne    80105540 <sys_shm_close+0x3a>
    return 0;
80105539:	b8 00 00 00 00       	mov    $0x0,%eax
8010553e:	eb 05                	jmp    80105545 <sys_shm_close+0x3f>
  }
  return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105545:	c9                   	leave  
80105546:	c3                   	ret    

80105547 <readeflags>:
{
80105547:	55                   	push   %ebp
80105548:	89 e5                	mov    %esp,%ebp
8010554a:	53                   	push   %ebx
8010554b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010554e:	9c                   	pushf  
8010554f:	5b                   	pop    %ebx
80105550:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80105553:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105556:	83 c4 10             	add    $0x10,%esp
80105559:	5b                   	pop    %ebx
8010555a:	5d                   	pop    %ebp
8010555b:	c3                   	ret    

8010555c <cli>:
{
8010555c:	55                   	push   %ebp
8010555d:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010555f:	fa                   	cli    
}
80105560:	5d                   	pop    %ebp
80105561:	c3                   	ret    

80105562 <sti>:
{
80105562:	55                   	push   %ebp
80105563:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105565:	fb                   	sti    
}
80105566:	5d                   	pop    %ebp
80105567:	c3                   	ret    

80105568 <xchg>:
{
80105568:	55                   	push   %ebp
80105569:	89 e5                	mov    %esp,%ebp
8010556b:	53                   	push   %ebx
8010556c:	83 ec 10             	sub    $0x10,%esp
               "+m" (*addr), "=a" (result) :
8010556f:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80105572:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80105575:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
80105578:	89 c3                	mov    %eax,%ebx
8010557a:	89 d8                	mov    %ebx,%eax
8010557c:	f0 87 02             	lock xchg %eax,(%edx)
8010557f:	89 c3                	mov    %eax,%ebx
80105581:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return result;
80105584:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	5b                   	pop    %ebx
8010558b:	5d                   	pop    %ebp
8010558c:	c3                   	ret    

8010558d <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010558d:	55                   	push   %ebp
8010558e:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105590:	8b 45 08             	mov    0x8(%ebp),%eax
80105593:	8b 55 0c             	mov    0xc(%ebp),%edx
80105596:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105599:	8b 45 08             	mov    0x8(%ebp),%eax
8010559c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801055a2:	8b 45 08             	mov    0x8(%ebp),%eax
801055a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801055ac:	5d                   	pop    %ebp
801055ad:	c3                   	ret    

801055ae <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801055ae:	55                   	push   %ebp
801055af:	89 e5                	mov    %esp,%ebp
801055b1:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801055b4:	e8 47 01 00 00       	call   80105700 <pushcli>
  if(holding(lk))
801055b9:	8b 45 08             	mov    0x8(%ebp),%eax
801055bc:	89 04 24             	mov    %eax,(%esp)
801055bf:	e8 12 01 00 00       	call   801056d6 <holding>
801055c4:	85 c0                	test   %eax,%eax
801055c6:	74 0c                	je     801055d4 <acquire+0x26>
    panic("acquire");
801055c8:	c7 04 24 28 92 10 80 	movl   $0x80109228,(%esp)
801055cf:	e8 62 af ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801055d4:	90                   	nop
801055d5:	8b 45 08             	mov    0x8(%ebp),%eax
801055d8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801055df:	00 
801055e0:	89 04 24             	mov    %eax,(%esp)
801055e3:	e8 80 ff ff ff       	call   80105568 <xchg>
801055e8:	85 c0                	test   %eax,%eax
801055ea:	75 e9                	jne    801055d5 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801055ec:	8b 45 08             	mov    0x8(%ebp),%eax
801055ef:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055f6:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801055f9:	8b 45 08             	mov    0x8(%ebp),%eax
801055fc:	83 c0 0c             	add    $0xc,%eax
801055ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105603:	8d 45 08             	lea    0x8(%ebp),%eax
80105606:	89 04 24             	mov    %eax,(%esp)
80105609:	e8 51 00 00 00       	call   8010565f <getcallerpcs>
}
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105616:	8b 45 08             	mov    0x8(%ebp),%eax
80105619:	89 04 24             	mov    %eax,(%esp)
8010561c:	e8 b5 00 00 00       	call   801056d6 <holding>
80105621:	85 c0                	test   %eax,%eax
80105623:	75 0c                	jne    80105631 <release+0x21>
    panic("release");
80105625:	c7 04 24 30 92 10 80 	movl   $0x80109230,(%esp)
8010562c:	e8 05 af ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
80105631:	8b 45 08             	mov    0x8(%ebp),%eax
80105634:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010563b:	8b 45 08             	mov    0x8(%ebp),%eax
8010563e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105645:	8b 45 08             	mov    0x8(%ebp),%eax
80105648:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010564f:	00 
80105650:	89 04 24             	mov    %eax,(%esp)
80105653:	e8 10 ff ff ff       	call   80105568 <xchg>

  popcli();
80105658:	e8 e9 00 00 00       	call   80105746 <popcli>
}
8010565d:	c9                   	leave  
8010565e:	c3                   	ret    

8010565f <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010565f:	55                   	push   %ebp
80105660:	89 e5                	mov    %esp,%ebp
80105662:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105665:	8b 45 08             	mov    0x8(%ebp),%eax
80105668:	83 e8 08             	sub    $0x8,%eax
8010566b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010566e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105675:	eb 37                	jmp    801056ae <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105677:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010567b:	74 51                	je     801056ce <getcallerpcs+0x6f>
8010567d:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105684:	76 48                	jbe    801056ce <getcallerpcs+0x6f>
80105686:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010568a:	74 42                	je     801056ce <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010568c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010568f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105696:	8b 45 0c             	mov    0xc(%ebp),%eax
80105699:	01 c2                	add    %eax,%edx
8010569b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010569e:	8b 40 04             	mov    0x4(%eax),%eax
801056a1:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801056a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056a6:	8b 00                	mov    (%eax),%eax
801056a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801056ab:	ff 45 f8             	incl   -0x8(%ebp)
801056ae:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056b2:	7e c3                	jle    80105677 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801056b4:	eb 18                	jmp    801056ce <getcallerpcs+0x6f>
    pcs[i] = 0;
801056b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c3:	01 d0                	add    %edx,%eax
801056c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056cb:	ff 45 f8             	incl   -0x8(%ebp)
801056ce:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056d2:	7e e2                	jle    801056b6 <getcallerpcs+0x57>
}
801056d4:	c9                   	leave  
801056d5:	c3                   	ret    

801056d6 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056d6:	55                   	push   %ebp
801056d7:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801056d9:	8b 45 08             	mov    0x8(%ebp),%eax
801056dc:	8b 00                	mov    (%eax),%eax
801056de:	85 c0                	test   %eax,%eax
801056e0:	74 17                	je     801056f9 <holding+0x23>
801056e2:	8b 45 08             	mov    0x8(%ebp),%eax
801056e5:	8b 50 08             	mov    0x8(%eax),%edx
801056e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056ee:	39 c2                	cmp    %eax,%edx
801056f0:	75 07                	jne    801056f9 <holding+0x23>
801056f2:	b8 01 00 00 00       	mov    $0x1,%eax
801056f7:	eb 05                	jmp    801056fe <holding+0x28>
801056f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056fe:	5d                   	pop    %ebp
801056ff:	c3                   	ret    

80105700 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105706:	e8 3c fe ff ff       	call   80105547 <readeflags>
8010570b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010570e:	e8 49 fe ff ff       	call   8010555c <cli>
  if(cpu->ncli++ == 0)
80105713:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105719:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010571f:	85 d2                	test   %edx,%edx
80105721:	0f 94 c1             	sete   %cl
80105724:	42                   	inc    %edx
80105725:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010572b:	84 c9                	test   %cl,%cl
8010572d:	74 15                	je     80105744 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
8010572f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105735:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105738:	81 e2 00 02 00 00    	and    $0x200,%edx
8010573e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105744:	c9                   	leave  
80105745:	c3                   	ret    

80105746 <popcli>:

void
popcli(void)
{
80105746:	55                   	push   %ebp
80105747:	89 e5                	mov    %esp,%ebp
80105749:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010574c:	e8 f6 fd ff ff       	call   80105547 <readeflags>
80105751:	25 00 02 00 00       	and    $0x200,%eax
80105756:	85 c0                	test   %eax,%eax
80105758:	74 0c                	je     80105766 <popcli+0x20>
    panic("popcli - interruptible");
8010575a:	c7 04 24 38 92 10 80 	movl   $0x80109238,(%esp)
80105761:	e8 d0 ad ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80105766:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010576c:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105772:	4a                   	dec    %edx
80105773:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105779:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010577f:	85 c0                	test   %eax,%eax
80105781:	79 0c                	jns    8010578f <popcli+0x49>
    panic("popcli");
80105783:	c7 04 24 4f 92 10 80 	movl   $0x8010924f,(%esp)
8010578a:	e8 a7 ad ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010578f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105795:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010579b:	85 c0                	test   %eax,%eax
8010579d:	75 15                	jne    801057b4 <popcli+0x6e>
8010579f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057a5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801057ab:	85 c0                	test   %eax,%eax
801057ad:	74 05                	je     801057b4 <popcli+0x6e>
    sti();
801057af:	e8 ae fd ff ff       	call   80105562 <sti>
}
801057b4:	c9                   	leave  
801057b5:	c3                   	ret    

801057b6 <stosb>:
{
801057b6:	55                   	push   %ebp
801057b7:	89 e5                	mov    %esp,%ebp
801057b9:	57                   	push   %edi
801057ba:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057be:	8b 55 10             	mov    0x10(%ebp),%edx
801057c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801057c4:	89 cb                	mov    %ecx,%ebx
801057c6:	89 df                	mov    %ebx,%edi
801057c8:	89 d1                	mov    %edx,%ecx
801057ca:	fc                   	cld    
801057cb:	f3 aa                	rep stos %al,%es:(%edi)
801057cd:	89 ca                	mov    %ecx,%edx
801057cf:	89 fb                	mov    %edi,%ebx
801057d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057d4:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057d7:	5b                   	pop    %ebx
801057d8:	5f                   	pop    %edi
801057d9:	5d                   	pop    %ebp
801057da:	c3                   	ret    

801057db <stosl>:
{
801057db:	55                   	push   %ebp
801057dc:	89 e5                	mov    %esp,%ebp
801057de:	57                   	push   %edi
801057df:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057e3:	8b 55 10             	mov    0x10(%ebp),%edx
801057e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e9:	89 cb                	mov    %ecx,%ebx
801057eb:	89 df                	mov    %ebx,%edi
801057ed:	89 d1                	mov    %edx,%ecx
801057ef:	fc                   	cld    
801057f0:	f3 ab                	rep stos %eax,%es:(%edi)
801057f2:	89 ca                	mov    %ecx,%edx
801057f4:	89 fb                	mov    %edi,%ebx
801057f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057f9:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057fc:	5b                   	pop    %ebx
801057fd:	5f                   	pop    %edi
801057fe:	5d                   	pop    %ebp
801057ff:	c3                   	ret    

80105800 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105806:	8b 45 08             	mov    0x8(%ebp),%eax
80105809:	83 e0 03             	and    $0x3,%eax
8010580c:	85 c0                	test   %eax,%eax
8010580e:	75 49                	jne    80105859 <memset+0x59>
80105810:	8b 45 10             	mov    0x10(%ebp),%eax
80105813:	83 e0 03             	and    $0x3,%eax
80105816:	85 c0                	test   %eax,%eax
80105818:	75 3f                	jne    80105859 <memset+0x59>
    c &= 0xFF;
8010581a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105821:	8b 45 10             	mov    0x10(%ebp),%eax
80105824:	c1 e8 02             	shr    $0x2,%eax
80105827:	89 c2                	mov    %eax,%edx
80105829:	8b 45 0c             	mov    0xc(%ebp),%eax
8010582c:	89 c1                	mov    %eax,%ecx
8010582e:	c1 e1 18             	shl    $0x18,%ecx
80105831:	8b 45 0c             	mov    0xc(%ebp),%eax
80105834:	c1 e0 10             	shl    $0x10,%eax
80105837:	09 c1                	or     %eax,%ecx
80105839:	8b 45 0c             	mov    0xc(%ebp),%eax
8010583c:	c1 e0 08             	shl    $0x8,%eax
8010583f:	09 c8                	or     %ecx,%eax
80105841:	0b 45 0c             	or     0xc(%ebp),%eax
80105844:	89 54 24 08          	mov    %edx,0x8(%esp)
80105848:	89 44 24 04          	mov    %eax,0x4(%esp)
8010584c:	8b 45 08             	mov    0x8(%ebp),%eax
8010584f:	89 04 24             	mov    %eax,(%esp)
80105852:	e8 84 ff ff ff       	call   801057db <stosl>
80105857:	eb 19                	jmp    80105872 <memset+0x72>
  } else
    stosb(dst, c, n);
80105859:	8b 45 10             	mov    0x10(%ebp),%eax
8010585c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105860:	8b 45 0c             	mov    0xc(%ebp),%eax
80105863:	89 44 24 04          	mov    %eax,0x4(%esp)
80105867:	8b 45 08             	mov    0x8(%ebp),%eax
8010586a:	89 04 24             	mov    %eax,(%esp)
8010586d:	e8 44 ff ff ff       	call   801057b6 <stosb>
  return dst;
80105872:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    

80105877 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010587d:	8b 45 08             	mov    0x8(%ebp),%eax
80105880:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105883:	8b 45 0c             	mov    0xc(%ebp),%eax
80105886:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105889:	eb 2c                	jmp    801058b7 <memcmp+0x40>
    if(*s1 != *s2)
8010588b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010588e:	8a 10                	mov    (%eax),%dl
80105890:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105893:	8a 00                	mov    (%eax),%al
80105895:	38 c2                	cmp    %al,%dl
80105897:	74 18                	je     801058b1 <memcmp+0x3a>
      return *s1 - *s2;
80105899:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010589c:	8a 00                	mov    (%eax),%al
8010589e:	0f b6 d0             	movzbl %al,%edx
801058a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058a4:	8a 00                	mov    (%eax),%al
801058a6:	0f b6 c0             	movzbl %al,%eax
801058a9:	89 d1                	mov    %edx,%ecx
801058ab:	29 c1                	sub    %eax,%ecx
801058ad:	89 c8                	mov    %ecx,%eax
801058af:	eb 19                	jmp    801058ca <memcmp+0x53>
    s1++, s2++;
801058b1:	ff 45 fc             	incl   -0x4(%ebp)
801058b4:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0){
801058b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058bb:	0f 95 c0             	setne  %al
801058be:	ff 4d 10             	decl   0x10(%ebp)
801058c1:	84 c0                	test   %al,%al
801058c3:	75 c6                	jne    8010588b <memcmp+0x14>
  }

  return 0;
801058c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058ca:	c9                   	leave  
801058cb:	c3                   	ret    

801058cc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058cc:	55                   	push   %ebp
801058cd:	89 e5                	mov    %esp,%ebp
801058cf:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801058d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801058d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058d8:	8b 45 08             	mov    0x8(%ebp),%eax
801058db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058e4:	73 4d                	jae    80105933 <memmove+0x67>
801058e6:	8b 45 10             	mov    0x10(%ebp),%eax
801058e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058ec:	01 d0                	add    %edx,%eax
801058ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058f1:	76 40                	jbe    80105933 <memmove+0x67>
    s += n;
801058f3:	8b 45 10             	mov    0x10(%ebp),%eax
801058f6:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801058f9:	8b 45 10             	mov    0x10(%ebp),%eax
801058fc:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801058ff:	eb 10                	jmp    80105911 <memmove+0x45>
      *--d = *--s;
80105901:	ff 4d f8             	decl   -0x8(%ebp)
80105904:	ff 4d fc             	decl   -0x4(%ebp)
80105907:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010590a:	8a 10                	mov    (%eax),%dl
8010590c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010590f:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105911:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105915:	0f 95 c0             	setne  %al
80105918:	ff 4d 10             	decl   0x10(%ebp)
8010591b:	84 c0                	test   %al,%al
8010591d:	75 e2                	jne    80105901 <memmove+0x35>
  if(s < d && s + n > d){
8010591f:	eb 21                	jmp    80105942 <memmove+0x76>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105921:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105924:	8a 10                	mov    (%eax),%dl
80105926:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105929:	88 10                	mov    %dl,(%eax)
8010592b:	ff 45 f8             	incl   -0x8(%ebp)
8010592e:	ff 45 fc             	incl   -0x4(%ebp)
80105931:	eb 01                	jmp    80105934 <memmove+0x68>
    while(n-- > 0)
80105933:	90                   	nop
80105934:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105938:	0f 95 c0             	setne  %al
8010593b:	ff 4d 10             	decl   0x10(%ebp)
8010593e:	84 c0                	test   %al,%al
80105940:	75 df                	jne    80105921 <memmove+0x55>

  return dst;
80105942:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105945:	c9                   	leave  
80105946:	c3                   	ret    

80105947 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105947:	55                   	push   %ebp
80105948:	89 e5                	mov    %esp,%ebp
8010594a:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010594d:	8b 45 10             	mov    0x10(%ebp),%eax
80105950:	89 44 24 08          	mov    %eax,0x8(%esp)
80105954:	8b 45 0c             	mov    0xc(%ebp),%eax
80105957:	89 44 24 04          	mov    %eax,0x4(%esp)
8010595b:	8b 45 08             	mov    0x8(%ebp),%eax
8010595e:	89 04 24             	mov    %eax,(%esp)
80105961:	e8 66 ff ff ff       	call   801058cc <memmove>
}
80105966:	c9                   	leave  
80105967:	c3                   	ret    

80105968 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105968:	55                   	push   %ebp
80105969:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
8010596b:	eb 09                	jmp    80105976 <strncmp+0xe>
    n--, p++, q++;
8010596d:	ff 4d 10             	decl   0x10(%ebp)
80105970:	ff 45 08             	incl   0x8(%ebp)
80105973:	ff 45 0c             	incl   0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105976:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010597a:	74 17                	je     80105993 <strncmp+0x2b>
8010597c:	8b 45 08             	mov    0x8(%ebp),%eax
8010597f:	8a 00                	mov    (%eax),%al
80105981:	84 c0                	test   %al,%al
80105983:	74 0e                	je     80105993 <strncmp+0x2b>
80105985:	8b 45 08             	mov    0x8(%ebp),%eax
80105988:	8a 10                	mov    (%eax),%dl
8010598a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010598d:	8a 00                	mov    (%eax),%al
8010598f:	38 c2                	cmp    %al,%dl
80105991:	74 da                	je     8010596d <strncmp+0x5>
  if(n == 0)
80105993:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105997:	75 07                	jne    801059a0 <strncmp+0x38>
    return 0;
80105999:	b8 00 00 00 00       	mov    $0x0,%eax
8010599e:	eb 16                	jmp    801059b6 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
801059a0:	8b 45 08             	mov    0x8(%ebp),%eax
801059a3:	8a 00                	mov    (%eax),%al
801059a5:	0f b6 d0             	movzbl %al,%edx
801059a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801059ab:	8a 00                	mov    (%eax),%al
801059ad:	0f b6 c0             	movzbl %al,%eax
801059b0:	89 d1                	mov    %edx,%ecx
801059b2:	29 c1                	sub    %eax,%ecx
801059b4:	89 c8                	mov    %ecx,%eax
}
801059b6:	5d                   	pop    %ebp
801059b7:	c3                   	ret    

801059b8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059b8:	55                   	push   %ebp
801059b9:	89 e5                	mov    %esp,%ebp
801059bb:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059be:	8b 45 08             	mov    0x8(%ebp),%eax
801059c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059c4:	90                   	nop
801059c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059c9:	0f 9f c0             	setg   %al
801059cc:	ff 4d 10             	decl   0x10(%ebp)
801059cf:	84 c0                	test   %al,%al
801059d1:	74 2b                	je     801059fe <strncpy+0x46>
801059d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d6:	8a 10                	mov    (%eax),%dl
801059d8:	8b 45 08             	mov    0x8(%ebp),%eax
801059db:	88 10                	mov    %dl,(%eax)
801059dd:	8b 45 08             	mov    0x8(%ebp),%eax
801059e0:	8a 00                	mov    (%eax),%al
801059e2:	84 c0                	test   %al,%al
801059e4:	0f 95 c0             	setne  %al
801059e7:	ff 45 08             	incl   0x8(%ebp)
801059ea:	ff 45 0c             	incl   0xc(%ebp)
801059ed:	84 c0                	test   %al,%al
801059ef:	75 d4                	jne    801059c5 <strncpy+0xd>
    ;
  while(n-- > 0)
801059f1:	eb 0b                	jmp    801059fe <strncpy+0x46>
    *s++ = 0;
801059f3:	8b 45 08             	mov    0x8(%ebp),%eax
801059f6:	c6 00 00             	movb   $0x0,(%eax)
801059f9:	ff 45 08             	incl   0x8(%ebp)
801059fc:	eb 01                	jmp    801059ff <strncpy+0x47>
  while(n-- > 0)
801059fe:	90                   	nop
801059ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a03:	0f 9f c0             	setg   %al
80105a06:	ff 4d 10             	decl   0x10(%ebp)
80105a09:	84 c0                	test   %al,%al
80105a0b:	75 e6                	jne    801059f3 <strncpy+0x3b>
  return os;
80105a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a10:	c9                   	leave  
80105a11:	c3                   	ret    

80105a12 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a12:	55                   	push   %ebp
80105a13:	89 e5                	mov    %esp,%ebp
80105a15:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a18:	8b 45 08             	mov    0x8(%ebp),%eax
80105a1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a22:	7f 05                	jg     80105a29 <safestrcpy+0x17>
    return os;
80105a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a27:	eb 30                	jmp    80105a59 <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a29:	ff 4d 10             	decl   0x10(%ebp)
80105a2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a30:	7e 1e                	jle    80105a50 <safestrcpy+0x3e>
80105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a35:	8a 10                	mov    (%eax),%dl
80105a37:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3a:	88 10                	mov    %dl,(%eax)
80105a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80105a3f:	8a 00                	mov    (%eax),%al
80105a41:	84 c0                	test   %al,%al
80105a43:	0f 95 c0             	setne  %al
80105a46:	ff 45 08             	incl   0x8(%ebp)
80105a49:	ff 45 0c             	incl   0xc(%ebp)
80105a4c:	84 c0                	test   %al,%al
80105a4e:	75 d9                	jne    80105a29 <safestrcpy+0x17>
    ;
  *s = 0;
80105a50:	8b 45 08             	mov    0x8(%ebp),%eax
80105a53:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a59:	c9                   	leave  
80105a5a:	c3                   	ret    

80105a5b <strlen>:

int
strlen(const char *s)
{
80105a5b:	55                   	push   %ebp
80105a5c:	89 e5                	mov    %esp,%ebp
80105a5e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a68:	eb 03                	jmp    80105a6d <strlen+0x12>
80105a6a:	ff 45 fc             	incl   -0x4(%ebp)
80105a6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a70:	8b 45 08             	mov    0x8(%ebp),%eax
80105a73:	01 d0                	add    %edx,%eax
80105a75:	8a 00                	mov    (%eax),%al
80105a77:	84 c0                	test   %al,%al
80105a79:	75 ef                	jne    80105a6a <strlen+0xf>
    ;
  return n;
80105a7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a7e:	c9                   	leave  
80105a7f:	c3                   	ret    

80105a80 <swtch>:
80105a80:	8b 44 24 04          	mov    0x4(%esp),%eax
80105a84:	8b 54 24 08          	mov    0x8(%esp),%edx
80105a88:	55                   	push   %ebp
80105a89:	53                   	push   %ebx
80105a8a:	56                   	push   %esi
80105a8b:	57                   	push   %edi
80105a8c:	89 20                	mov    %esp,(%eax)
80105a8e:	89 d4                	mov    %edx,%esp
80105a90:	5f                   	pop    %edi
80105a91:	5e                   	pop    %esi
80105a92:	5b                   	pop    %ebx
80105a93:	5d                   	pop    %ebp
80105a94:	c3                   	ret    

80105a95 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a95:	55                   	push   %ebp
80105a96:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105a98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a9e:	8b 00                	mov    (%eax),%eax
80105aa0:	3b 45 08             	cmp    0x8(%ebp),%eax
80105aa3:	76 12                	jbe    80105ab7 <fetchint+0x22>
80105aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa8:	8d 50 04             	lea    0x4(%eax),%edx
80105aab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ab1:	8b 00                	mov    (%eax),%eax
80105ab3:	39 c2                	cmp    %eax,%edx
80105ab5:	76 07                	jbe    80105abe <fetchint+0x29>
    return -1;
80105ab7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105abc:	eb 0f                	jmp    80105acd <fetchint+0x38>
  *ip = *(int*)(addr);
80105abe:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac1:	8b 10                	mov    (%eax),%edx
80105ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ac6:	89 10                	mov    %edx,(%eax)
  return 0;
80105ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105acd:	5d                   	pop    %ebp
80105ace:	c3                   	ret    

80105acf <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105acf:	55                   	push   %ebp
80105ad0:	89 e5                	mov    %esp,%ebp
80105ad2:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105ad5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105adb:	8b 00                	mov    (%eax),%eax
80105add:	3b 45 08             	cmp    0x8(%ebp),%eax
80105ae0:	77 07                	ja     80105ae9 <fetchstr+0x1a>
    return -1;
80105ae2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae7:	eb 46                	jmp    80105b2f <fetchstr+0x60>
  *pp = (char*)addr;
80105ae9:	8b 55 08             	mov    0x8(%ebp),%edx
80105aec:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aef:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105af7:	8b 00                	mov    (%eax),%eax
80105af9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aff:	8b 00                	mov    (%eax),%eax
80105b01:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105b04:	eb 1c                	jmp    80105b22 <fetchstr+0x53>
    if(*s == 0)
80105b06:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b09:	8a 00                	mov    (%eax),%al
80105b0b:	84 c0                	test   %al,%al
80105b0d:	75 10                	jne    80105b1f <fetchstr+0x50>
      return s - *pp;
80105b0f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b12:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b15:	8b 00                	mov    (%eax),%eax
80105b17:	89 d1                	mov    %edx,%ecx
80105b19:	29 c1                	sub    %eax,%ecx
80105b1b:	89 c8                	mov    %ecx,%eax
80105b1d:	eb 10                	jmp    80105b2f <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
80105b1f:	ff 45 fc             	incl   -0x4(%ebp)
80105b22:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b25:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b28:	72 dc                	jb     80105b06 <fetchstr+0x37>
  return -1;
80105b2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b2f:	c9                   	leave  
80105b30:	c3                   	ret    

80105b31 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b31:	55                   	push   %ebp
80105b32:	89 e5                	mov    %esp,%ebp
80105b34:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105b37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b3d:	8b 40 18             	mov    0x18(%eax),%eax
80105b40:	8b 50 44             	mov    0x44(%eax),%edx
80105b43:	8b 45 08             	mov    0x8(%ebp),%eax
80105b46:	c1 e0 02             	shl    $0x2,%eax
80105b49:	01 d0                	add    %edx,%eax
80105b4b:	8d 50 04             	lea    0x4(%eax),%edx
80105b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b51:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b55:	89 14 24             	mov    %edx,(%esp)
80105b58:	e8 38 ff ff ff       	call   80105a95 <fetchint>
}
80105b5d:	c9                   	leave  
80105b5e:	c3                   	ret    

80105b5f <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b5f:	55                   	push   %ebp
80105b60:	89 e5                	mov    %esp,%ebp
80105b62:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105b65:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b68:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80105b6f:	89 04 24             	mov    %eax,(%esp)
80105b72:	e8 ba ff ff ff       	call   80105b31 <argint>
80105b77:	85 c0                	test   %eax,%eax
80105b79:	79 07                	jns    80105b82 <argptr+0x23>
    return -1;
80105b7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b80:	eb 3d                	jmp    80105bbf <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105b82:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b85:	89 c2                	mov    %eax,%edx
80105b87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b8d:	8b 00                	mov    (%eax),%eax
80105b8f:	39 c2                	cmp    %eax,%edx
80105b91:	73 16                	jae    80105ba9 <argptr+0x4a>
80105b93:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b96:	89 c2                	mov    %eax,%edx
80105b98:	8b 45 10             	mov    0x10(%ebp),%eax
80105b9b:	01 c2                	add    %eax,%edx
80105b9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ba3:	8b 00                	mov    (%eax),%eax
80105ba5:	39 c2                	cmp    %eax,%edx
80105ba7:	76 07                	jbe    80105bb0 <argptr+0x51>
    return -1;
80105ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bae:	eb 0f                	jmp    80105bbf <argptr+0x60>
  *pp = (char*)i;
80105bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bb3:	89 c2                	mov    %eax,%edx
80105bb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bb8:	89 10                	mov    %edx,(%eax)
  return 0;
80105bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bbf:	c9                   	leave  
80105bc0:	c3                   	ret    

80105bc1 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bc1:	55                   	push   %ebp
80105bc2:	89 e5                	mov    %esp,%ebp
80105bc4:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bc7:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105bca:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bce:	8b 45 08             	mov    0x8(%ebp),%eax
80105bd1:	89 04 24             	mov    %eax,(%esp)
80105bd4:	e8 58 ff ff ff       	call   80105b31 <argint>
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	79 07                	jns    80105be4 <argstr+0x23>
    return -1;
80105bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105be2:	eb 12                	jmp    80105bf6 <argstr+0x35>
  return fetchstr(addr, pp);
80105be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105be7:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bea:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bee:	89 04 24             	mov    %eax,(%esp)
80105bf1:	e8 d9 fe ff ff       	call   80105acf <fetchstr>
}
80105bf6:	c9                   	leave  
80105bf7:	c3                   	ret    

80105bf8 <syscall>:
[SYS_shm_get] sys_shm_get, // New: Add in project final
};

void
syscall(void)
{
80105bf8:	55                   	push   %ebp
80105bf9:	89 e5                	mov    %esp,%ebp
80105bfb:	53                   	push   %ebx
80105bfc:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105bff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c05:	8b 40 18             	mov    0x18(%eax),%eax
80105c08:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c12:	7e 30                	jle    80105c44 <syscall+0x4c>
80105c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c17:	83 f8 20             	cmp    $0x20,%eax
80105c1a:	77 28                	ja     80105c44 <syscall+0x4c>
80105c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1f:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c26:	85 c0                	test   %eax,%eax
80105c28:	74 1a                	je     80105c44 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105c2a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c30:	8b 58 18             	mov    0x18(%eax),%ebx
80105c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c36:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c3d:	ff d0                	call   *%eax
80105c3f:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105c42:	eb 3d                	jmp    80105c81 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105c44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c4a:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105c53:	8b 40 10             	mov    0x10(%eax),%eax
80105c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c59:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c61:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c65:	c7 04 24 56 92 10 80 	movl   $0x80109256,(%esp)
80105c6c:	e8 30 a7 ff ff       	call   801003a1 <cprintf>
    proc->tf->eax = -1;
80105c71:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c77:	8b 40 18             	mov    0x18(%eax),%eax
80105c7a:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105c81:	83 c4 24             	add    $0x24,%esp
80105c84:	5b                   	pop    %ebx
80105c85:	5d                   	pop    %ebp
80105c86:	c3                   	ret    

80105c87 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105c87:	55                   	push   %ebp
80105c88:	89 e5                	mov    %esp,%ebp
80105c8a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105c8d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c90:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c94:	8b 45 08             	mov    0x8(%ebp),%eax
80105c97:	89 04 24             	mov    %eax,(%esp)
80105c9a:	e8 92 fe ff ff       	call   80105b31 <argint>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	79 07                	jns    80105caa <argfd+0x23>
    return -1;
80105ca3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca8:	eb 50                	jmp    80105cfa <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cad:	85 c0                	test   %eax,%eax
80105caf:	78 21                	js     80105cd2 <argfd+0x4b>
80105cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb4:	83 f8 0f             	cmp    $0xf,%eax
80105cb7:	7f 19                	jg     80105cd2 <argfd+0x4b>
80105cb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cc2:	83 c2 08             	add    $0x8,%edx
80105cc5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ccc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cd0:	75 07                	jne    80105cd9 <argfd+0x52>
    return -1;
80105cd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd7:	eb 21                	jmp    80105cfa <argfd+0x73>
  if(pfd)
80105cd9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105cdd:	74 08                	je     80105ce7 <argfd+0x60>
    *pfd = fd;
80105cdf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ce5:	89 10                	mov    %edx,(%eax)
  if(pf)
80105ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105ceb:	74 08                	je     80105cf5 <argfd+0x6e>
    *pf = f;
80105ced:	8b 45 10             	mov    0x10(%ebp),%eax
80105cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cf3:	89 10                	mov    %edx,(%eax)
  return 0;
80105cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cfa:	c9                   	leave  
80105cfb:	c3                   	ret    

80105cfc <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105cfc:	55                   	push   %ebp
80105cfd:	89 e5                	mov    %esp,%ebp
80105cff:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d09:	eb 2f                	jmp    80105d3a <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105d0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d11:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d14:	83 c2 08             	add    $0x8,%edx
80105d17:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d1b:	85 c0                	test   %eax,%eax
80105d1d:	75 18                	jne    80105d37 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105d1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d25:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d28:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80105d2e:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d32:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d35:	eb 0e                	jmp    80105d45 <fdalloc+0x49>
  for(fd = 0; fd < NOFILE; fd++){
80105d37:	ff 45 fc             	incl   -0x4(%ebp)
80105d3a:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105d3e:	7e cb                	jle    80105d0b <fdalloc+0xf>
    }
  }
  return -1;
80105d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d45:	c9                   	leave  
80105d46:	c3                   	ret    

80105d47 <sys_dup>:

int
sys_dup(void)
{
80105d47:	55                   	push   %ebp
80105d48:	89 e5                	mov    %esp,%ebp
80105d4a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105d4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d50:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d5b:	00 
80105d5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d63:	e8 1f ff ff ff       	call   80105c87 <argfd>
80105d68:	85 c0                	test   %eax,%eax
80105d6a:	79 07                	jns    80105d73 <sys_dup+0x2c>
    return -1;
80105d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d71:	eb 29                	jmp    80105d9c <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d76:	89 04 24             	mov    %eax,(%esp)
80105d79:	e8 7e ff ff ff       	call   80105cfc <fdalloc>
80105d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d85:	79 07                	jns    80105d8e <sys_dup+0x47>
    return -1;
80105d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d8c:	eb 0e                	jmp    80105d9c <sys_dup+0x55>
  filedup(f);
80105d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d91:	89 04 24             	mov    %eax,(%esp)
80105d94:	e8 ba b1 ff ff       	call   80100f53 <filedup>
  return fd;
80105d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d9c:	c9                   	leave  
80105d9d:	c3                   	ret    

80105d9e <sys_read>:

int
sys_read(void)
{
80105d9e:	55                   	push   %ebp
80105d9f:	89 e5                	mov    %esp,%ebp
80105da1:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105da4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105da7:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105db2:	00 
80105db3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105dba:	e8 c8 fe ff ff       	call   80105c87 <argfd>
80105dbf:	85 c0                	test   %eax,%eax
80105dc1:	78 35                	js     80105df8 <sys_read+0x5a>
80105dc3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dca:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105dd1:	e8 5b fd ff ff       	call   80105b31 <argint>
80105dd6:	85 c0                	test   %eax,%eax
80105dd8:	78 1e                	js     80105df8 <sys_read+0x5a>
80105dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105de1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105de4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105de8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105def:	e8 6b fd ff ff       	call   80105b5f <argptr>
80105df4:	85 c0                	test   %eax,%eax
80105df6:	79 07                	jns    80105dff <sys_read+0x61>
    return -1;
80105df8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dfd:	eb 19                	jmp    80105e18 <sys_read+0x7a>
  return fileread(f, p, n);
80105dff:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e08:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105e0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e10:	89 04 24             	mov    %eax,(%esp)
80105e13:	e8 9c b2 ff ff       	call   801010b4 <fileread>
}
80105e18:	c9                   	leave  
80105e19:	c3                   	ret    

80105e1a <sys_write>:

int
sys_write(void)
{
80105e1a:	55                   	push   %ebp
80105e1b:	89 e5                	mov    %esp,%ebp
80105e1d:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e23:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e27:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e2e:	00 
80105e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e36:	e8 4c fe ff ff       	call   80105c87 <argfd>
80105e3b:	85 c0                	test   %eax,%eax
80105e3d:	78 35                	js     80105e74 <sys_write+0x5a>
80105e3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e42:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e46:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e4d:	e8 df fc ff ff       	call   80105b31 <argint>
80105e52:	85 c0                	test   %eax,%eax
80105e54:	78 1e                	js     80105e74 <sys_write+0x5a>
80105e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e59:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e5d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e60:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e6b:	e8 ef fc ff ff       	call   80105b5f <argptr>
80105e70:	85 c0                	test   %eax,%eax
80105e72:	79 07                	jns    80105e7b <sys_write+0x61>
    return -1;
80105e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e79:	eb 19                	jmp    80105e94 <sys_write+0x7a>
  return filewrite(f, p, n);
80105e7b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e84:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105e88:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e8c:	89 04 24             	mov    %eax,(%esp)
80105e8f:	e8 db b2 ff ff       	call   8010116f <filewrite>
}
80105e94:	c9                   	leave  
80105e95:	c3                   	ret    

80105e96 <sys_isatty>:

// Minimalish implementation of isatty for xv6. Maybe it will even work, but 
// hopefully it will be sufficient for now.
int sys_isatty(void) {
80105e96:	55                   	push   %ebp
80105e97:	89 e5                	mov    %esp,%ebp
80105e99:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  argfd(0, &fd, &f);
80105e9c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e9f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ea3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105eb1:	e8 d1 fd ff ff       	call   80105c87 <argfd>
  if (f->type == FD_INODE) {
80105eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb9:	8b 00                	mov    (%eax),%eax
80105ebb:	83 f8 02             	cmp    $0x2,%eax
80105ebe:	75 20                	jne    80105ee0 <sys_isatty+0x4a>
    /* This is bad and wrong, but currently works. Either when more 
     * sophisticated terminal handling comes, or more devices, or both, this
     * will need to distinguish different device types. Still, it's a start. */
    if (f->ip != 0 && f->ip->type == T_DEV)
80105ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec3:	8b 40 10             	mov    0x10(%eax),%eax
80105ec6:	85 c0                	test   %eax,%eax
80105ec8:	74 16                	je     80105ee0 <sys_isatty+0x4a>
80105eca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ecd:	8b 40 10             	mov    0x10(%eax),%eax
80105ed0:	8b 40 10             	mov    0x10(%eax),%eax
80105ed3:	66 83 f8 03          	cmp    $0x3,%ax
80105ed7:	75 07                	jne    80105ee0 <sys_isatty+0x4a>
      return 1;
80105ed9:	b8 01 00 00 00       	mov    $0x1,%eax
80105ede:	eb 05                	jmp    80105ee5 <sys_isatty+0x4f>
  }
  return 0;
80105ee0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ee5:	c9                   	leave  
80105ee6:	c3                   	ret    

80105ee7 <sys_lseek>:

// lseek derived from https://github.com/hxp/xv6, written by Joel Heikkila

int sys_lseek(void) {
80105ee7:	55                   	push   %ebp
80105ee8:	89 e5                	mov    %esp,%ebp
80105eea:	83 ec 48             	sub    $0x48,%esp
	int zerosize, i;
	char *zeroed, *z;

	struct file *f;

	argfd(0, &fd, &f);
80105eed:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105ef0:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ef4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80105efb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f02:	e8 80 fd ff ff       	call   80105c87 <argfd>
	argint(1, &offset);
80105f07:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f15:	e8 17 fc ff ff       	call   80105b31 <argint>
	argint(2, &base);
80105f1a:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f21:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f28:	e8 04 fc ff ff       	call   80105b31 <argint>

	if( base == SEEK_SET) {
80105f2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f30:	85 c0                	test   %eax,%eax
80105f32:	75 06                	jne    80105f3a <sys_lseek+0x53>
		newoff = offset;
80105f34:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	if (base == SEEK_CUR)
80105f3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f3d:	83 f8 01             	cmp    $0x1,%eax
80105f40:	75 0e                	jne    80105f50 <sys_lseek+0x69>
		newoff = f->off + offset;
80105f42:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f45:	8b 50 14             	mov    0x14(%eax),%edx
80105f48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f4b:	01 d0                	add    %edx,%eax
80105f4d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (base == SEEK_END)
80105f50:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f53:	83 f8 02             	cmp    $0x2,%eax
80105f56:	75 11                	jne    80105f69 <sys_lseek+0x82>
		newoff = f->ip->size + offset;
80105f58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f5b:	8b 40 10             	mov    0x10(%eax),%eax
80105f5e:	8b 50 18             	mov    0x18(%eax),%edx
80105f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f64:	01 d0                	add    %edx,%eax
80105f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (newoff < f->ip->size)
80105f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f6f:	8b 40 10             	mov    0x10(%eax),%eax
80105f72:	8b 40 18             	mov    0x18(%eax),%eax
80105f75:	39 c2                	cmp    %eax,%edx
80105f77:	73 0a                	jae    80105f83 <sys_lseek+0x9c>
		return -1;
80105f79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f7e:	e9 92 00 00 00       	jmp    80106015 <sys_lseek+0x12e>

	if (newoff > f->ip->size){
80105f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f89:	8b 40 10             	mov    0x10(%eax),%eax
80105f8c:	8b 40 18             	mov    0x18(%eax),%eax
80105f8f:	39 c2                	cmp    %eax,%edx
80105f91:	76 74                	jbe    80106007 <sys_lseek+0x120>
		zerosize = newoff - f->ip->size;
80105f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f96:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f99:	8b 40 10             	mov    0x10(%eax),%eax
80105f9c:	8b 40 18             	mov    0x18(%eax),%eax
80105f9f:	89 d1                	mov    %edx,%ecx
80105fa1:	29 c1                	sub    %eax,%ecx
80105fa3:	89 c8                	mov    %ecx,%eax
80105fa5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		zeroed = kalloc();
80105fa8:	e8 11 cb ff ff       	call   80102abe <kalloc>
80105fad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = zeroed;
80105fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		for (i = 0; i < 4096; i++)
80105fb6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105fbd:	eb 0c                	jmp    80105fcb <sys_lseek+0xe4>
			*z++ = 0;
80105fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fc2:	c6 00 00             	movb   $0x0,(%eax)
80105fc5:	ff 45 e8             	incl   -0x18(%ebp)
		for (i = 0; i < 4096; i++)
80105fc8:	ff 45 ec             	incl   -0x14(%ebp)
80105fcb:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80105fd2:	7e eb                	jle    80105fbf <sys_lseek+0xd8>
		while (zerosize > 0){
80105fd4:	eb 20                	jmp    80105ff6 <sys_lseek+0x10f>
			filewrite(f, zeroed, zerosize);
80105fd6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105fd9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fdc:	89 54 24 08          	mov    %edx,0x8(%esp)
80105fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105fe3:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fe7:	89 04 24             	mov    %eax,(%esp)
80105fea:	e8 80 b1 ff ff       	call   8010116f <filewrite>
			zerosize -= 4096;
80105fef:	81 6d f0 00 10 00 00 	subl   $0x1000,-0x10(%ebp)
		while (zerosize > 0){
80105ff6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ffa:	7f da                	jg     80105fd6 <sys_lseek+0xef>
		}
		kfree(zeroed);
80105ffc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fff:	89 04 24             	mov    %eax,(%esp)
80106002:	e8 1e ca ff ff       	call   80102a25 <kfree>
	}

	f->off = newoff;
80106007:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010600a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010600d:	89 50 14             	mov    %edx,0x14(%eax)
	return 0;
80106010:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106015:	c9                   	leave  
80106016:	c3                   	ret    

80106017 <sys_close>:

int
sys_close(void)
{
80106017:	55                   	push   %ebp
80106018:	89 e5                	mov    %esp,%ebp
8010601a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010601d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106020:	89 44 24 08          	mov    %eax,0x8(%esp)
80106024:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106027:	89 44 24 04          	mov    %eax,0x4(%esp)
8010602b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106032:	e8 50 fc ff ff       	call   80105c87 <argfd>
80106037:	85 c0                	test   %eax,%eax
80106039:	79 07                	jns    80106042 <sys_close+0x2b>
    return -1;
8010603b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106040:	eb 24                	jmp    80106066 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80106042:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106048:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010604b:	83 c2 08             	add    $0x8,%edx
8010604e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106055:	00 
  fileclose(f);
80106056:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106059:	89 04 24             	mov    %eax,(%esp)
8010605c:	e8 3a af ff ff       	call   80100f9b <fileclose>
  return 0;
80106061:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106066:	c9                   	leave  
80106067:	c3                   	ret    

80106068 <sys_fstat>:

int
sys_fstat(void)
{
80106068:	55                   	push   %ebp
80106069:	89 e5                	mov    %esp,%ebp
8010606b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010606e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106071:	89 44 24 08          	mov    %eax,0x8(%esp)
80106075:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010607c:	00 
8010607d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106084:	e8 fe fb ff ff       	call   80105c87 <argfd>
80106089:	85 c0                	test   %eax,%eax
8010608b:	78 1f                	js     801060ac <sys_fstat+0x44>
8010608d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106094:	00 
80106095:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106098:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060a3:	e8 b7 fa ff ff       	call   80105b5f <argptr>
801060a8:	85 c0                	test   %eax,%eax
801060aa:	79 07                	jns    801060b3 <sys_fstat+0x4b>
    return -1;
801060ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b1:	eb 12                	jmp    801060c5 <sys_fstat+0x5d>
  return filestat(f, st);
801060b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801060bd:	89 04 24             	mov    %eax,(%esp)
801060c0:	e8 a0 af ff ff       	call   80101065 <filestat>
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    

801060c7 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801060c7:	55                   	push   %ebp
801060c8:	89 e5                	mov    %esp,%ebp
801060ca:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801060cd:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060db:	e8 e1 fa ff ff       	call   80105bc1 <argstr>
801060e0:	85 c0                	test   %eax,%eax
801060e2:	78 17                	js     801060fb <sys_link+0x34>
801060e4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801060e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801060eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060f2:	e8 ca fa ff ff       	call   80105bc1 <argstr>
801060f7:	85 c0                	test   %eax,%eax
801060f9:	79 0a                	jns    80106105 <sys_link+0x3e>
    return -1;
801060fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106100:	e9 37 01 00 00       	jmp    8010623c <sys_link+0x175>
  if((ip = namei(old)) == 0)
80106105:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106108:	89 04 24             	mov    %eax,(%esp)
8010610b:	e8 cf c2 ff ff       	call   801023df <namei>
80106110:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106117:	75 0a                	jne    80106123 <sys_link+0x5c>
    return -1;
80106119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010611e:	e9 19 01 00 00       	jmp    8010623c <sys_link+0x175>

  begin_trans();
80106123:	e8 a8 d0 ff ff       	call   801031d0 <begin_trans>

  ilock(ip);
80106128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612b:	89 04 24             	mov    %eax,(%esp)
8010612e:	e8 12 b7 ff ff       	call   80101845 <ilock>
  if(ip->type == T_DIR){
80106133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106136:	8b 40 10             	mov    0x10(%eax),%eax
80106139:	66 83 f8 01          	cmp    $0x1,%ax
8010613d:	75 1a                	jne    80106159 <sys_link+0x92>
    iunlockput(ip);
8010613f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106142:	89 04 24             	mov    %eax,(%esp)
80106145:	e8 7c b9 ff ff       	call   80101ac6 <iunlockput>
    commit_trans();
8010614a:	e8 ca d0 ff ff       	call   80103219 <commit_trans>
    return -1;
8010614f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106154:	e9 e3 00 00 00       	jmp    8010623c <sys_link+0x175>
  }

  ip->nlink++;
80106159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010615c:	66 8b 40 16          	mov    0x16(%eax),%ax
80106160:	40                   	inc    %eax
80106161:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106164:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80106168:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010616b:	89 04 24             	mov    %eax,(%esp)
8010616e:	e8 18 b5 ff ff       	call   8010168b <iupdate>
  iunlock(ip);
80106173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106176:	89 04 24             	mov    %eax,(%esp)
80106179:	e8 12 b8 ff ff       	call   80101990 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
8010617e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106181:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106184:	89 54 24 04          	mov    %edx,0x4(%esp)
80106188:	89 04 24             	mov    %eax,(%esp)
8010618b:	e8 71 c2 ff ff       	call   80102401 <nameiparent>
80106190:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106197:	74 68                	je     80106201 <sys_link+0x13a>
    goto bad;
  ilock(dp);
80106199:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010619c:	89 04 24             	mov    %eax,(%esp)
8010619f:	e8 a1 b6 ff ff       	call   80101845 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061a7:	8b 10                	mov    (%eax),%edx
801061a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ac:	8b 00                	mov    (%eax),%eax
801061ae:	39 c2                	cmp    %eax,%edx
801061b0:	75 20                	jne    801061d2 <sys_link+0x10b>
801061b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b5:	8b 40 04             	mov    0x4(%eax),%eax
801061b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801061bc:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c6:	89 04 24             	mov    %eax,(%esp)
801061c9:	e8 5a bf ff ff       	call   80102128 <dirlink>
801061ce:	85 c0                	test   %eax,%eax
801061d0:	79 0d                	jns    801061df <sys_link+0x118>
    iunlockput(dp);
801061d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d5:	89 04 24             	mov    %eax,(%esp)
801061d8:	e8 e9 b8 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
801061dd:	eb 23                	jmp    80106202 <sys_link+0x13b>
  }
  iunlockput(dp);
801061df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061e2:	89 04 24             	mov    %eax,(%esp)
801061e5:	e8 dc b8 ff ff       	call   80101ac6 <iunlockput>
  iput(ip);
801061ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ed:	89 04 24             	mov    %eax,(%esp)
801061f0:	e8 00 b8 ff ff       	call   801019f5 <iput>

  commit_trans();
801061f5:	e8 1f d0 ff ff       	call   80103219 <commit_trans>

  return 0;
801061fa:	b8 00 00 00 00       	mov    $0x0,%eax
801061ff:	eb 3b                	jmp    8010623c <sys_link+0x175>
    goto bad;
80106201:	90                   	nop

bad:
  ilock(ip);
80106202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106205:	89 04 24             	mov    %eax,(%esp)
80106208:	e8 38 b6 ff ff       	call   80101845 <ilock>
  ip->nlink--;
8010620d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106210:	66 8b 40 16          	mov    0x16(%eax),%ax
80106214:	48                   	dec    %eax
80106215:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106218:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010621c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621f:	89 04 24             	mov    %eax,(%esp)
80106222:	e8 64 b4 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80106227:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010622a:	89 04 24             	mov    %eax,(%esp)
8010622d:	e8 94 b8 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80106232:	e8 e2 cf ff ff       	call   80103219 <commit_trans>
  return -1;
80106237:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010623c:	c9                   	leave  
8010623d:	c3                   	ret    

8010623e <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010623e:	55                   	push   %ebp
8010623f:	89 e5                	mov    %esp,%ebp
80106241:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106244:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010624b:	eb 4a                	jmp    80106297 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010624d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106250:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106257:	00 
80106258:	89 44 24 08          	mov    %eax,0x8(%esp)
8010625c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010625f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106263:	8b 45 08             	mov    0x8(%ebp),%eax
80106266:	89 04 24             	mov    %eax,(%esp)
80106269:	e8 de ba ff ff       	call   80101d4c <readi>
8010626e:	83 f8 10             	cmp    $0x10,%eax
80106271:	74 0c                	je     8010627f <isdirempty+0x41>
      panic("isdirempty: readi");
80106273:	c7 04 24 72 92 10 80 	movl   $0x80109272,(%esp)
8010627a:	e8 b7 a2 ff ff       	call   80100536 <panic>
    if(de.inum != 0)
8010627f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106282:	66 85 c0             	test   %ax,%ax
80106285:	74 07                	je     8010628e <isdirempty+0x50>
      return 0;
80106287:	b8 00 00 00 00       	mov    $0x0,%eax
8010628c:	eb 1b                	jmp    801062a9 <isdirempty+0x6b>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010628e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106291:	83 c0 10             	add    $0x10,%eax
80106294:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106297:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010629a:	8b 45 08             	mov    0x8(%ebp),%eax
8010629d:	8b 40 18             	mov    0x18(%eax),%eax
801062a0:	39 c2                	cmp    %eax,%edx
801062a2:	72 a9                	jb     8010624d <isdirempty+0xf>
  }
  return 1;
801062a4:	b8 01 00 00 00       	mov    $0x1,%eax
}
801062a9:	c9                   	leave  
801062aa:	c3                   	ret    

801062ab <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801062ab:	55                   	push   %ebp
801062ac:	89 e5                	mov    %esp,%ebp
801062ae:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801062b1:	8d 45 cc             	lea    -0x34(%ebp),%eax
801062b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801062b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062bf:	e8 fd f8 ff ff       	call   80105bc1 <argstr>
801062c4:	85 c0                	test   %eax,%eax
801062c6:	79 0a                	jns    801062d2 <sys_unlink+0x27>
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cd:	e9 a4 01 00 00       	jmp    80106476 <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
801062d2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801062d5:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801062d8:	89 54 24 04          	mov    %edx,0x4(%esp)
801062dc:	89 04 24             	mov    %eax,(%esp)
801062df:	e8 1d c1 ff ff       	call   80102401 <nameiparent>
801062e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062eb:	75 0a                	jne    801062f7 <sys_unlink+0x4c>
    return -1;
801062ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062f2:	e9 7f 01 00 00       	jmp    80106476 <sys_unlink+0x1cb>

  begin_trans();
801062f7:	e8 d4 ce ff ff       	call   801031d0 <begin_trans>

  ilock(dp);
801062fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ff:	89 04 24             	mov    %eax,(%esp)
80106302:	e8 3e b5 ff ff       	call   80101845 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106307:	c7 44 24 04 84 92 10 	movl   $0x80109284,0x4(%esp)
8010630e:	80 
8010630f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106312:	89 04 24             	mov    %eax,(%esp)
80106315:	e8 27 bd ff ff       	call   80102041 <namecmp>
8010631a:	85 c0                	test   %eax,%eax
8010631c:	0f 84 3f 01 00 00    	je     80106461 <sys_unlink+0x1b6>
80106322:	c7 44 24 04 86 92 10 	movl   $0x80109286,0x4(%esp)
80106329:	80 
8010632a:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010632d:	89 04 24             	mov    %eax,(%esp)
80106330:	e8 0c bd ff ff       	call   80102041 <namecmp>
80106335:	85 c0                	test   %eax,%eax
80106337:	0f 84 24 01 00 00    	je     80106461 <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010633d:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106340:	89 44 24 08          	mov    %eax,0x8(%esp)
80106344:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106347:	89 44 24 04          	mov    %eax,0x4(%esp)
8010634b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010634e:	89 04 24             	mov    %eax,(%esp)
80106351:	e8 0d bd ff ff       	call   80102063 <dirlookup>
80106356:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010635d:	0f 84 fd 00 00 00    	je     80106460 <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80106363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106366:	89 04 24             	mov    %eax,(%esp)
80106369:	e8 d7 b4 ff ff       	call   80101845 <ilock>

  if(ip->nlink < 1)
8010636e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106371:	66 8b 40 16          	mov    0x16(%eax),%ax
80106375:	66 85 c0             	test   %ax,%ax
80106378:	7f 0c                	jg     80106386 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
8010637a:	c7 04 24 89 92 10 80 	movl   $0x80109289,(%esp)
80106381:	e8 b0 a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106386:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106389:	8b 40 10             	mov    0x10(%eax),%eax
8010638c:	66 83 f8 01          	cmp    $0x1,%ax
80106390:	75 1f                	jne    801063b1 <sys_unlink+0x106>
80106392:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106395:	89 04 24             	mov    %eax,(%esp)
80106398:	e8 a1 fe ff ff       	call   8010623e <isdirempty>
8010639d:	85 c0                	test   %eax,%eax
8010639f:	75 10                	jne    801063b1 <sys_unlink+0x106>
    iunlockput(ip);
801063a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a4:	89 04 24             	mov    %eax,(%esp)
801063a7:	e8 1a b7 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
801063ac:	e9 b0 00 00 00       	jmp    80106461 <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
801063b1:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801063b8:	00 
801063b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063c0:	00 
801063c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063c4:	89 04 24             	mov    %eax,(%esp)
801063c7:	e8 34 f4 ff ff       	call   80105800 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063cf:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801063d6:	00 
801063d7:	89 44 24 08          	mov    %eax,0x8(%esp)
801063db:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063de:	89 44 24 04          	mov    %eax,0x4(%esp)
801063e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e5:	89 04 24             	mov    %eax,(%esp)
801063e8:	e8 c4 ba ff ff       	call   80101eb1 <writei>
801063ed:	83 f8 10             	cmp    $0x10,%eax
801063f0:	74 0c                	je     801063fe <sys_unlink+0x153>
    panic("unlink: writei");
801063f2:	c7 04 24 9b 92 10 80 	movl   $0x8010929b,(%esp)
801063f9:	e8 38 a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
801063fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106401:	8b 40 10             	mov    0x10(%eax),%eax
80106404:	66 83 f8 01          	cmp    $0x1,%ax
80106408:	75 1a                	jne    80106424 <sys_unlink+0x179>
    dp->nlink--;
8010640a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640d:	66 8b 40 16          	mov    0x16(%eax),%ax
80106411:	48                   	dec    %eax
80106412:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106415:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80106419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641c:	89 04 24             	mov    %eax,(%esp)
8010641f:	e8 67 b2 ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
80106424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106427:	89 04 24             	mov    %eax,(%esp)
8010642a:	e8 97 b6 ff ff       	call   80101ac6 <iunlockput>

  ip->nlink--;
8010642f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106432:	66 8b 40 16          	mov    0x16(%eax),%ax
80106436:	48                   	dec    %eax
80106437:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010643a:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010643e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106441:	89 04 24             	mov    %eax,(%esp)
80106444:	e8 42 b2 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80106449:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010644c:	89 04 24             	mov    %eax,(%esp)
8010644f:	e8 72 b6 ff ff       	call   80101ac6 <iunlockput>

  commit_trans();
80106454:	e8 c0 cd ff ff       	call   80103219 <commit_trans>

  return 0;
80106459:	b8 00 00 00 00       	mov    $0x0,%eax
8010645e:	eb 16                	jmp    80106476 <sys_unlink+0x1cb>
    goto bad;
80106460:	90                   	nop

bad:
  iunlockput(dp);
80106461:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106464:	89 04 24             	mov    %eax,(%esp)
80106467:	e8 5a b6 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010646c:	e8 a8 cd ff ff       	call   80103219 <commit_trans>
  return -1;
80106471:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106476:	c9                   	leave  
80106477:	c3                   	ret    

80106478 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106478:	55                   	push   %ebp
80106479:	89 e5                	mov    %esp,%ebp
8010647b:	83 ec 48             	sub    $0x48,%esp
8010647e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106481:	8b 55 10             	mov    0x10(%ebp),%edx
80106484:	8b 45 14             	mov    0x14(%ebp),%eax
80106487:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010648b:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010648f:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106493:	8d 45 de             	lea    -0x22(%ebp),%eax
80106496:	89 44 24 04          	mov    %eax,0x4(%esp)
8010649a:	8b 45 08             	mov    0x8(%ebp),%eax
8010649d:	89 04 24             	mov    %eax,(%esp)
801064a0:	e8 5c bf ff ff       	call   80102401 <nameiparent>
801064a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064ac:	75 0a                	jne    801064b8 <create+0x40>
    return 0;
801064ae:	b8 00 00 00 00       	mov    $0x0,%eax
801064b3:	e9 79 01 00 00       	jmp    80106631 <create+0x1b9>
  ilock(dp);
801064b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064bb:	89 04 24             	mov    %eax,(%esp)
801064be:	e8 82 b3 ff ff       	call   80101845 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801064c3:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801064ca:	8d 45 de             	lea    -0x22(%ebp),%eax
801064cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801064d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d4:	89 04 24             	mov    %eax,(%esp)
801064d7:	e8 87 bb ff ff       	call   80102063 <dirlookup>
801064dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064e3:	74 46                	je     8010652b <create+0xb3>
    iunlockput(dp);
801064e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e8:	89 04 24             	mov    %eax,(%esp)
801064eb:	e8 d6 b5 ff ff       	call   80101ac6 <iunlockput>
    ilock(ip);
801064f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f3:	89 04 24             	mov    %eax,(%esp)
801064f6:	e8 4a b3 ff ff       	call   80101845 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801064fb:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106500:	75 14                	jne    80106516 <create+0x9e>
80106502:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106505:	8b 40 10             	mov    0x10(%eax),%eax
80106508:	66 83 f8 02          	cmp    $0x2,%ax
8010650c:	75 08                	jne    80106516 <create+0x9e>
      return ip;
8010650e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106511:	e9 1b 01 00 00       	jmp    80106631 <create+0x1b9>
    iunlockput(ip);
80106516:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106519:	89 04 24             	mov    %eax,(%esp)
8010651c:	e8 a5 b5 ff ff       	call   80101ac6 <iunlockput>
    return 0;
80106521:	b8 00 00 00 00       	mov    $0x0,%eax
80106526:	e9 06 01 00 00       	jmp    80106631 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010652b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010652f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106532:	8b 00                	mov    (%eax),%eax
80106534:	89 54 24 04          	mov    %edx,0x4(%esp)
80106538:	89 04 24             	mov    %eax,(%esp)
8010653b:	e8 63 b0 ff ff       	call   801015a3 <ialloc>
80106540:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106543:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106547:	75 0c                	jne    80106555 <create+0xdd>
    panic("create: ialloc");
80106549:	c7 04 24 aa 92 10 80 	movl   $0x801092aa,(%esp)
80106550:	e8 e1 9f ff ff       	call   80100536 <panic>

  ilock(ip);
80106555:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106558:	89 04 24             	mov    %eax,(%esp)
8010655b:	e8 e5 b2 ff ff       	call   80101845 <ilock>
  ip->major = major;
80106560:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106563:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106566:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
8010656a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010656d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106570:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80106574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106577:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010657d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106580:	89 04 24             	mov    %eax,(%esp)
80106583:	e8 03 b1 ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80106588:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010658d:	75 68                	jne    801065f7 <create+0x17f>
    dp->nlink++;  // for ".."
8010658f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106592:	66 8b 40 16          	mov    0x16(%eax),%ax
80106596:	40                   	inc    %eax
80106597:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010659a:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
8010659e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a1:	89 04 24             	mov    %eax,(%esp)
801065a4:	e8 e2 b0 ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801065a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ac:	8b 40 04             	mov    0x4(%eax),%eax
801065af:	89 44 24 08          	mov    %eax,0x8(%esp)
801065b3:	c7 44 24 04 84 92 10 	movl   $0x80109284,0x4(%esp)
801065ba:	80 
801065bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065be:	89 04 24             	mov    %eax,(%esp)
801065c1:	e8 62 bb ff ff       	call   80102128 <dirlink>
801065c6:	85 c0                	test   %eax,%eax
801065c8:	78 21                	js     801065eb <create+0x173>
801065ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cd:	8b 40 04             	mov    0x4(%eax),%eax
801065d0:	89 44 24 08          	mov    %eax,0x8(%esp)
801065d4:	c7 44 24 04 86 92 10 	movl   $0x80109286,0x4(%esp)
801065db:	80 
801065dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065df:	89 04 24             	mov    %eax,(%esp)
801065e2:	e8 41 bb ff ff       	call   80102128 <dirlink>
801065e7:	85 c0                	test   %eax,%eax
801065e9:	79 0c                	jns    801065f7 <create+0x17f>
      panic("create dots");
801065eb:	c7 04 24 b9 92 10 80 	movl   $0x801092b9,(%esp)
801065f2:	e8 3f 9f ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801065f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065fa:	8b 40 04             	mov    0x4(%eax),%eax
801065fd:	89 44 24 08          	mov    %eax,0x8(%esp)
80106601:	8d 45 de             	lea    -0x22(%ebp),%eax
80106604:	89 44 24 04          	mov    %eax,0x4(%esp)
80106608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660b:	89 04 24             	mov    %eax,(%esp)
8010660e:	e8 15 bb ff ff       	call   80102128 <dirlink>
80106613:	85 c0                	test   %eax,%eax
80106615:	79 0c                	jns    80106623 <create+0x1ab>
    panic("create: dirlink");
80106617:	c7 04 24 c5 92 10 80 	movl   $0x801092c5,(%esp)
8010661e:	e8 13 9f ff ff       	call   80100536 <panic>

  iunlockput(dp);
80106623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106626:	89 04 24             	mov    %eax,(%esp)
80106629:	e8 98 b4 ff ff       	call   80101ac6 <iunlockput>

  return ip;
8010662e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106631:	c9                   	leave  
80106632:	c3                   	ret    

80106633 <sys_open>:

int
sys_open(void)
{
80106633:	55                   	push   %ebp
80106634:	89 e5                	mov    %esp,%ebp
80106636:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106639:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010663c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106640:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106647:	e8 75 f5 ff ff       	call   80105bc1 <argstr>
8010664c:	85 c0                	test   %eax,%eax
8010664e:	78 17                	js     80106667 <sys_open+0x34>
80106650:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106653:	89 44 24 04          	mov    %eax,0x4(%esp)
80106657:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010665e:	e8 ce f4 ff ff       	call   80105b31 <argint>
80106663:	85 c0                	test   %eax,%eax
80106665:	79 0a                	jns    80106671 <sys_open+0x3e>
    return -1;
80106667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666c:	e9 47 01 00 00       	jmp    801067b8 <sys_open+0x185>
  if(omode & O_CREATE){
80106671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106674:	25 00 02 00 00       	and    $0x200,%eax
80106679:	85 c0                	test   %eax,%eax
8010667b:	74 40                	je     801066bd <sys_open+0x8a>
    begin_trans();
8010667d:	e8 4e cb ff ff       	call   801031d0 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106682:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106685:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010668c:	00 
8010668d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106694:	00 
80106695:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010669c:	00 
8010669d:	89 04 24             	mov    %eax,(%esp)
801066a0:	e8 d3 fd ff ff       	call   80106478 <create>
801066a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
801066a8:	e8 6c cb ff ff       	call   80103219 <commit_trans>
    if(ip == 0)
801066ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066b1:	75 5b                	jne    8010670e <sys_open+0xdb>
      return -1;
801066b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066b8:	e9 fb 00 00 00       	jmp    801067b8 <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
801066bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066c0:	89 04 24             	mov    %eax,(%esp)
801066c3:	e8 17 bd ff ff       	call   801023df <namei>
801066c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066cf:	75 0a                	jne    801066db <sys_open+0xa8>
      return -1;
801066d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066d6:	e9 dd 00 00 00       	jmp    801067b8 <sys_open+0x185>
    ilock(ip);
801066db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066de:	89 04 24             	mov    %eax,(%esp)
801066e1:	e8 5f b1 ff ff       	call   80101845 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801066e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e9:	8b 40 10             	mov    0x10(%eax),%eax
801066ec:	66 83 f8 01          	cmp    $0x1,%ax
801066f0:	75 1c                	jne    8010670e <sys_open+0xdb>
801066f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066f5:	85 c0                	test   %eax,%eax
801066f7:	74 15                	je     8010670e <sys_open+0xdb>
      iunlockput(ip);
801066f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066fc:	89 04 24             	mov    %eax,(%esp)
801066ff:	e8 c2 b3 ff ff       	call   80101ac6 <iunlockput>
      return -1;
80106704:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106709:	e9 aa 00 00 00       	jmp    801067b8 <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010670e:	e8 e0 a7 ff ff       	call   80100ef3 <filealloc>
80106713:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106716:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010671a:	74 14                	je     80106730 <sys_open+0xfd>
8010671c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010671f:	89 04 24             	mov    %eax,(%esp)
80106722:	e8 d5 f5 ff ff       	call   80105cfc <fdalloc>
80106727:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010672a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010672e:	79 23                	jns    80106753 <sys_open+0x120>
    if(f)
80106730:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106734:	74 0b                	je     80106741 <sys_open+0x10e>
      fileclose(f);
80106736:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106739:	89 04 24             	mov    %eax,(%esp)
8010673c:	e8 5a a8 ff ff       	call   80100f9b <fileclose>
    iunlockput(ip);
80106741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106744:	89 04 24             	mov    %eax,(%esp)
80106747:	e8 7a b3 ff ff       	call   80101ac6 <iunlockput>
    return -1;
8010674c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106751:	eb 65                	jmp    801067b8 <sys_open+0x185>
  }
  iunlock(ip);
80106753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106756:	89 04 24             	mov    %eax,(%esp)
80106759:	e8 32 b2 ff ff       	call   80101990 <iunlock>

  f->type = FD_INODE;
8010675e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106761:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106767:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010676d:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106770:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106773:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010677a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010677d:	83 e0 01             	and    $0x1,%eax
80106780:	85 c0                	test   %eax,%eax
80106782:	0f 94 c0             	sete   %al
80106785:	88 c2                	mov    %al,%dl
80106787:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010678a:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010678d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106790:	83 e0 01             	and    $0x1,%eax
80106793:	85 c0                	test   %eax,%eax
80106795:	75 0a                	jne    801067a1 <sys_open+0x16e>
80106797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010679a:	83 e0 02             	and    $0x2,%eax
8010679d:	85 c0                	test   %eax,%eax
8010679f:	74 07                	je     801067a8 <sys_open+0x175>
801067a1:	b8 01 00 00 00       	mov    $0x1,%eax
801067a6:	eb 05                	jmp    801067ad <sys_open+0x17a>
801067a8:	b8 00 00 00 00       	mov    $0x0,%eax
801067ad:	88 c2                	mov    %al,%dl
801067af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067b2:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801067b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801067b8:	c9                   	leave  
801067b9:	c3                   	ret    

801067ba <sys_mkdir>:

int
sys_mkdir(void)
{
801067ba:	55                   	push   %ebp
801067bb:	89 e5                	mov    %esp,%ebp
801067bd:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801067c0:	e8 0b ca ff ff       	call   801031d0 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801067c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801067cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067d3:	e8 e9 f3 ff ff       	call   80105bc1 <argstr>
801067d8:	85 c0                	test   %eax,%eax
801067da:	78 2c                	js     80106808 <sys_mkdir+0x4e>
801067dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067df:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801067e6:	00 
801067e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801067ee:	00 
801067ef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801067f6:	00 
801067f7:	89 04 24             	mov    %eax,(%esp)
801067fa:	e8 79 fc ff ff       	call   80106478 <create>
801067ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106806:	75 0c                	jne    80106814 <sys_mkdir+0x5a>
    commit_trans();
80106808:	e8 0c ca ff ff       	call   80103219 <commit_trans>
    return -1;
8010680d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106812:	eb 15                	jmp    80106829 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106814:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106817:	89 04 24             	mov    %eax,(%esp)
8010681a:	e8 a7 b2 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010681f:	e8 f5 c9 ff ff       	call   80103219 <commit_trans>
  return 0;
80106824:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106829:	c9                   	leave  
8010682a:	c3                   	ret    

8010682b <sys_mknod>:

int
sys_mknod(void)
{
8010682b:	55                   	push   %ebp
8010682c:	89 e5                	mov    %esp,%ebp
8010682e:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106831:	e8 9a c9 ff ff       	call   801031d0 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106836:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106839:	89 44 24 04          	mov    %eax,0x4(%esp)
8010683d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106844:	e8 78 f3 ff ff       	call   80105bc1 <argstr>
80106849:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010684c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106850:	78 5e                	js     801068b0 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106852:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106855:	89 44 24 04          	mov    %eax,0x4(%esp)
80106859:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106860:	e8 cc f2 ff ff       	call   80105b31 <argint>
  if((len=argstr(0, &path)) < 0 ||
80106865:	85 c0                	test   %eax,%eax
80106867:	78 47                	js     801068b0 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
80106869:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010686c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106870:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106877:	e8 b5 f2 ff ff       	call   80105b31 <argint>
     argint(1, &major) < 0 ||
8010687c:	85 c0                	test   %eax,%eax
8010687e:	78 30                	js     801068b0 <sys_mknod+0x85>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106880:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106883:	0f bf c8             	movswl %ax,%ecx
80106886:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106889:	0f bf d0             	movswl %ax,%edx
8010688c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
8010688f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106893:	89 54 24 08          	mov    %edx,0x8(%esp)
80106897:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010689e:	00 
8010689f:	89 04 24             	mov    %eax,(%esp)
801068a2:	e8 d1 fb ff ff       	call   80106478 <create>
801068a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068ae:	75 0c                	jne    801068bc <sys_mknod+0x91>
    commit_trans();
801068b0:	e8 64 c9 ff ff       	call   80103219 <commit_trans>
    return -1;
801068b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ba:	eb 15                	jmp    801068d1 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801068bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068bf:	89 04 24             	mov    %eax,(%esp)
801068c2:	e8 ff b1 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
801068c7:	e8 4d c9 ff ff       	call   80103219 <commit_trans>
  return 0;
801068cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068d1:	c9                   	leave  
801068d2:	c3                   	ret    

801068d3 <sys_chdir>:

int
sys_chdir(void)
{
801068d3:	55                   	push   %ebp
801068d4:	89 e5                	mov    %esp,%ebp
801068d6:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801068d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801068e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068e7:	e8 d5 f2 ff ff       	call   80105bc1 <argstr>
801068ec:	85 c0                	test   %eax,%eax
801068ee:	78 14                	js     80106904 <sys_chdir+0x31>
801068f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068f3:	89 04 24             	mov    %eax,(%esp)
801068f6:	e8 e4 ba ff ff       	call   801023df <namei>
801068fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106902:	75 07                	jne    8010690b <sys_chdir+0x38>
    return -1;
80106904:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106909:	eb 56                	jmp    80106961 <sys_chdir+0x8e>
  ilock(ip);
8010690b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690e:	89 04 24             	mov    %eax,(%esp)
80106911:	e8 2f af ff ff       	call   80101845 <ilock>
  if(ip->type != T_DIR){
80106916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106919:	8b 40 10             	mov    0x10(%eax),%eax
8010691c:	66 83 f8 01          	cmp    $0x1,%ax
80106920:	74 12                	je     80106934 <sys_chdir+0x61>
    iunlockput(ip);
80106922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106925:	89 04 24             	mov    %eax,(%esp)
80106928:	e8 99 b1 ff ff       	call   80101ac6 <iunlockput>
    return -1;
8010692d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106932:	eb 2d                	jmp    80106961 <sys_chdir+0x8e>
  }
  iunlock(ip);
80106934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106937:	89 04 24             	mov    %eax,(%esp)
8010693a:	e8 51 b0 ff ff       	call   80101990 <iunlock>
  iput(proc->cwd);
8010693f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106945:	8b 40 68             	mov    0x68(%eax),%eax
80106948:	89 04 24             	mov    %eax,(%esp)
8010694b:	e8 a5 b0 ff ff       	call   801019f5 <iput>
  proc->cwd = ip;
80106950:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106956:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106959:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010695c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106961:	c9                   	leave  
80106962:	c3                   	ret    

80106963 <sys_exec>:

int
sys_exec(void)
{
80106963:	55                   	push   %ebp
80106964:	89 e5                	mov    %esp,%ebp
80106966:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010696c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010696f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106973:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010697a:	e8 42 f2 ff ff       	call   80105bc1 <argstr>
8010697f:	85 c0                	test   %eax,%eax
80106981:	78 1a                	js     8010699d <sys_exec+0x3a>
80106983:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106989:	89 44 24 04          	mov    %eax,0x4(%esp)
8010698d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106994:	e8 98 f1 ff ff       	call   80105b31 <argint>
80106999:	85 c0                	test   %eax,%eax
8010699b:	79 0a                	jns    801069a7 <sys_exec+0x44>
    return -1;
8010699d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069a2:	e9 c7 00 00 00       	jmp    80106a6e <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
801069a7:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801069ae:	00 
801069af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069b6:	00 
801069b7:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069bd:	89 04 24             	mov    %eax,(%esp)
801069c0:	e8 3b ee ff ff       	call   80105800 <memset>
  for(i=0;; i++){
801069c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801069cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069cf:	83 f8 1f             	cmp    $0x1f,%eax
801069d2:	76 0a                	jbe    801069de <sys_exec+0x7b>
      return -1;
801069d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d9:	e9 90 00 00 00       	jmp    80106a6e <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801069de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069e1:	c1 e0 02             	shl    $0x2,%eax
801069e4:	89 c2                	mov    %eax,%edx
801069e6:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801069ec:	01 c2                	add    %eax,%edx
801069ee:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801069f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801069f8:	89 14 24             	mov    %edx,(%esp)
801069fb:	e8 95 f0 ff ff       	call   80105a95 <fetchint>
80106a00:	85 c0                	test   %eax,%eax
80106a02:	79 07                	jns    80106a0b <sys_exec+0xa8>
      return -1;
80106a04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a09:	eb 63                	jmp    80106a6e <sys_exec+0x10b>
    if(uarg == 0){
80106a0b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a11:	85 c0                	test   %eax,%eax
80106a13:	75 26                	jne    80106a3b <sys_exec+0xd8>
      argv[i] = 0;
80106a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a18:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106a1f:	00 00 00 00 
      break;
80106a23:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a27:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106a2d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a31:	89 04 24             	mov    %eax,(%esp)
80106a34:	e8 92 a0 ff ff       	call   80100acb <exec>
80106a39:	eb 33                	jmp    80106a6e <sys_exec+0x10b>
    if(fetchstr(uarg, &argv[i]) < 0)
80106a3b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a44:	c1 e2 02             	shl    $0x2,%edx
80106a47:	01 c2                	add    %eax,%edx
80106a49:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a4f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a53:	89 04 24             	mov    %eax,(%esp)
80106a56:	e8 74 f0 ff ff       	call   80105acf <fetchstr>
80106a5b:	85 c0                	test   %eax,%eax
80106a5d:	79 07                	jns    80106a66 <sys_exec+0x103>
      return -1;
80106a5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a64:	eb 08                	jmp    80106a6e <sys_exec+0x10b>
  for(i=0;; i++){
80106a66:	ff 45 f4             	incl   -0xc(%ebp)
  }
80106a69:	e9 5e ff ff ff       	jmp    801069cc <sys_exec+0x69>
}
80106a6e:	c9                   	leave  
80106a6f:	c3                   	ret    

80106a70 <sys_pipe>:

int
sys_pipe(void)
{
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106a76:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106a7d:	00 
80106a7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a81:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a8c:	e8 ce f0 ff ff       	call   80105b5f <argptr>
80106a91:	85 c0                	test   %eax,%eax
80106a93:	79 0a                	jns    80106a9f <sys_pipe+0x2f>
    return -1;
80106a95:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9a:	e9 9b 00 00 00       	jmp    80106b3a <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106a9f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aa6:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106aa9:	89 04 24             	mov    %eax,(%esp)
80106aac:	e8 7c d1 ff ff       	call   80103c2d <pipealloc>
80106ab1:	85 c0                	test   %eax,%eax
80106ab3:	79 07                	jns    80106abc <sys_pipe+0x4c>
    return -1;
80106ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106aba:	eb 7e                	jmp    80106b3a <sys_pipe+0xca>
  fd0 = -1;
80106abc:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106ac6:	89 04 24             	mov    %eax,(%esp)
80106ac9:	e8 2e f2 ff ff       	call   80105cfc <fdalloc>
80106ace:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ad1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ad5:	78 14                	js     80106aeb <sys_pipe+0x7b>
80106ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ada:	89 04 24             	mov    %eax,(%esp)
80106add:	e8 1a f2 ff ff       	call   80105cfc <fdalloc>
80106ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ae5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ae9:	79 37                	jns    80106b22 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106aeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106aef:	78 14                	js     80106b05 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106af1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106af7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106afa:	83 c2 08             	add    $0x8,%edx
80106afd:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b04:	00 
    fileclose(rf);
80106b05:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b08:	89 04 24             	mov    %eax,(%esp)
80106b0b:	e8 8b a4 ff ff       	call   80100f9b <fileclose>
    fileclose(wf);
80106b10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b13:	89 04 24             	mov    %eax,(%esp)
80106b16:	e8 80 a4 ff ff       	call   80100f9b <fileclose>
    return -1;
80106b1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b20:	eb 18                	jmp    80106b3a <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b28:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b2d:	8d 50 04             	lea    0x4(%eax),%edx
80106b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b33:	89 02                	mov    %eax,(%edx)
  return 0;
80106b35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b3a:	c9                   	leave  
80106b3b:	c3                   	ret    

80106b3c <sys_fork>:
#include "proc.h"
#include "semaphore.h"

int
sys_fork(void)
{
80106b3c:	55                   	push   %ebp
80106b3d:	89 e5                	mov    %esp,%ebp
80106b3f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106b42:	e8 6f d9 ff ff       	call   801044b6 <fork>
}
80106b47:	c9                   	leave  
80106b48:	c3                   	ret    

80106b49 <sys_exit>:

int
sys_exit(void)
{
80106b49:	55                   	push   %ebp
80106b4a:	89 e5                	mov    %esp,%ebp
80106b4c:	83 ec 08             	sub    $0x8,%esp
  exit();
80106b4f:	e8 e6 da ff ff       	call   8010463a <exit>
  return 0;  // not reached
80106b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b59:	c9                   	leave  
80106b5a:	c3                   	ret    

80106b5b <sys_wait>:

int
sys_wait(void)
{
80106b5b:	55                   	push   %ebp
80106b5c:	89 e5                	mov    %esp,%ebp
80106b5e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106b61:	e8 74 dc ff ff       	call   801047da <wait>
}
80106b66:	c9                   	leave  
80106b67:	c3                   	ret    

80106b68 <sys_kill>:

int
sys_kill(void)
{
80106b68:	55                   	push   %ebp
80106b69:	89 e5                	mov    %esp,%ebp
80106b6b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b7c:	e8 b0 ef ff ff       	call   80105b31 <argint>
80106b81:	85 c0                	test   %eax,%eax
80106b83:	79 07                	jns    80106b8c <sys_kill+0x24>
    return -1;
80106b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b8a:	eb 0b                	jmp    80106b97 <sys_kill+0x2f>
  return kill(pid);
80106b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b8f:	89 04 24             	mov    %eax,(%esp)
80106b92:	e8 82 e0 ff ff       	call   80104c19 <kill>
}
80106b97:	c9                   	leave  
80106b98:	c3                   	ret    

80106b99 <sys_getpid>:

int
sys_getpid(void)
{
80106b99:	55                   	push   %ebp
80106b9a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ba2:	8b 40 10             	mov    0x10(%eax),%eax
}
80106ba5:	5d                   	pop    %ebp
80106ba6:	c3                   	ret    

80106ba7 <sys_sbrk>:

int
sys_sbrk(void)
{
80106ba7:	55                   	push   %ebp
80106ba8:	89 e5                	mov    %esp,%ebp
80106baa:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106bad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bb4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bbb:	e8 71 ef ff ff       	call   80105b31 <argint>
80106bc0:	85 c0                	test   %eax,%eax
80106bc2:	79 07                	jns    80106bcb <sys_sbrk+0x24>
    return -1;
80106bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bc9:	eb 24                	jmp    80106bef <sys_sbrk+0x48>
  addr = proc->sz;
80106bcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd1:	8b 00                	mov    (%eax),%eax
80106bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bd9:	89 04 24             	mov    %eax,(%esp)
80106bdc:	e8 30 d8 ff ff       	call   80104411 <growproc>
80106be1:	85 c0                	test   %eax,%eax
80106be3:	79 07                	jns    80106bec <sys_sbrk+0x45>
    return -1;
80106be5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bea:	eb 03                	jmp    80106bef <sys_sbrk+0x48>
  return addr;
80106bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106bef:	c9                   	leave  
80106bf0:	c3                   	ret    

80106bf1 <sys_sleep>:

int
sys_sleep(void)
{
80106bf1:	55                   	push   %ebp
80106bf2:	89 e5                	mov    %esp,%ebp
80106bf4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106bf7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c05:	e8 27 ef ff ff       	call   80105b31 <argint>
80106c0a:	85 c0                	test   %eax,%eax
80106c0c:	79 07                	jns    80106c15 <sys_sleep+0x24>
    return -1;
80106c0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c13:	eb 6c                	jmp    80106c81 <sys_sleep+0x90>
  acquire(&tickslock);
80106c15:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c1c:	e8 8d e9 ff ff       	call   801055ae <acquire>
  ticks0 = ticks;
80106c21:	a1 60 44 11 80       	mov    0x80114460,%eax
80106c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106c29:	eb 34                	jmp    80106c5f <sys_sleep+0x6e>
    if(proc->killed){
80106c2b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c31:	8b 40 24             	mov    0x24(%eax),%eax
80106c34:	85 c0                	test   %eax,%eax
80106c36:	74 13                	je     80106c4b <sys_sleep+0x5a>
      release(&tickslock);
80106c38:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c3f:	e8 cc e9 ff ff       	call   80105610 <release>
      return -1;
80106c44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c49:	eb 36                	jmp    80106c81 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106c4b:	c7 44 24 04 20 3c 11 	movl   $0x80113c20,0x4(%esp)
80106c52:	80 
80106c53:	c7 04 24 60 44 11 80 	movl   $0x80114460,(%esp)
80106c5a:	e8 87 de ff ff       	call   80104ae6 <sleep>
  while(ticks - ticks0 < n){
80106c5f:	a1 60 44 11 80       	mov    0x80114460,%eax
80106c64:	89 c2                	mov    %eax,%edx
80106c66:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c6c:	39 c2                	cmp    %eax,%edx
80106c6e:	72 bb                	jb     80106c2b <sys_sleep+0x3a>
  }
  release(&tickslock);
80106c70:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c77:	e8 94 e9 ff ff       	call   80105610 <release>
  return 0;
80106c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c81:	c9                   	leave  
80106c82:	c3                   	ret    

80106c83 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c83:	55                   	push   %ebp
80106c84:	89 e5                	mov    %esp,%ebp
80106c86:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c89:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c90:	e8 19 e9 ff ff       	call   801055ae <acquire>
  xticks = ticks;
80106c95:	a1 60 44 11 80       	mov    0x80114460,%eax
80106c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c9d:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106ca4:	e8 67 e9 ff ff       	call   80105610 <release>
  return xticks;
80106ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106cac:	c9                   	leave  
80106cad:	c3                   	ret    

80106cae <sys_procstat>:

// New: Add in proyect 1: implementation of system call procstat
int
sys_procstat(void){             
80106cae:	55                   	push   %ebp
80106caf:	89 e5                	mov    %esp,%ebp
80106cb1:	83 ec 08             	sub    $0x8,%esp
  procdump(); // Print a process listing to console.
80106cb4:	e8 e4 df ff ff       	call   80104c9d <procdump>
  return 0; 
80106cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cbe:	c9                   	leave  
80106cbf:	c3                   	ret    

80106cc0 <sys_set_priority>:

// New: Add in project 2: implementation of syscall set_priority
int
sys_set_priority(void){
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	83 ec 28             	sub    $0x28,%esp
  int pr;
  argint(0, &pr);
80106cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ccd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cd4:	e8 58 ee ff ff       	call   80105b31 <argint>
  proc->priority=pr;
80106cd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ce2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ced:	c9                   	leave  
80106cee:	c3                   	ret    

80106cef <sys_semget>:

// New: Add in project final - (semaphore)
int
sys_semget(void)
{
80106cef:	55                   	push   %ebp
80106cf0:	89 e5                	mov    %esp,%ebp
80106cf2:	83 ec 28             	sub    $0x28,%esp
  int semid, init_value;
  if( argint(1, &init_value) < 0 || argint(0, &semid) < 0)
80106cf5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cfc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106d03:	e8 29 ee ff ff       	call   80105b31 <argint>
80106d08:	85 c0                	test   %eax,%eax
80106d0a:	78 17                	js     80106d23 <sys_semget+0x34>
80106d0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d1a:	e8 12 ee ff ff       	call   80105b31 <argint>
80106d1f:	85 c0                	test   %eax,%eax
80106d21:	79 07                	jns    80106d2a <sys_semget+0x3b>
    return -1;
80106d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d28:	eb 12                	jmp    80106d3c <sys_semget+0x4d>
  return semget(semid,init_value);
80106d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d30:	89 54 24 04          	mov    %edx,0x4(%esp)
80106d34:	89 04 24             	mov    %eax,(%esp)
80106d37:	e8 b2 e0 ff ff       	call   80104dee <semget>
}
80106d3c:	c9                   	leave  
80106d3d:	c3                   	ret    

80106d3e <sys_semfree>:

// New: Add in project final - (semaphore)
int 
sys_semfree(void)
{
80106d3e:	55                   	push   %ebp
80106d3f:	89 e5                	mov    %esp,%ebp
80106d41:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106d44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d47:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d52:	e8 da ed ff ff       	call   80105b31 <argint>
80106d57:	85 c0                	test   %eax,%eax
80106d59:	79 07                	jns    80106d62 <sys_semfree+0x24>
    return -1;
80106d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d60:	eb 0b                	jmp    80106d6d <sys_semfree+0x2f>
  return semfree(semid);
80106d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d65:	89 04 24             	mov    %eax,(%esp)
80106d68:	e8 de e1 ff ff       	call   80104f4b <semfree>
}
80106d6d:	c9                   	leave  
80106d6e:	c3                   	ret    

80106d6f <sys_semdown>:

// New: Add in project final - (semaphore)
int 
sys_semdown(void)
{
80106d6f:	55                   	push   %ebp
80106d70:	89 e5                	mov    %esp,%ebp
80106d72:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106d75:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d78:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d83:	e8 a9 ed ff ff       	call   80105b31 <argint>
80106d88:	85 c0                	test   %eax,%eax
80106d8a:	79 07                	jns    80106d93 <sys_semdown+0x24>
    return -1;
80106d8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d91:	eb 0b                	jmp    80106d9e <sys_semdown+0x2f>
  return semdown(semid);
80106d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d96:	89 04 24             	mov    %eax,(%esp)
80106d99:	e8 44 e2 ff ff       	call   80104fe2 <semdown>
}
80106d9e:	c9                   	leave  
80106d9f:	c3                   	ret    

80106da0 <sys_semup>:

// New: Add in project final - (semaphore)
int 
sys_semup(void)
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106da9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106dad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106db4:	e8 78 ed ff ff       	call   80105b31 <argint>
80106db9:	85 c0                	test   %eax,%eax
80106dbb:	79 07                	jns    80106dc4 <sys_semup+0x24>
    return -1;
80106dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc2:	eb 0b                	jmp    80106dcf <sys_semup+0x2f>
  return semup(semid);
80106dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc7:	89 04 24             	mov    %eax,(%esp)
80106dca:	e8 95 e2 ff ff       	call   80105064 <semup>
}
80106dcf:	c9                   	leave  
80106dd0:	c3                   	ret    

80106dd1 <outb>:
{
80106dd1:	55                   	push   %ebp
80106dd2:	89 e5                	mov    %esp,%ebp
80106dd4:	83 ec 08             	sub    $0x8,%esp
80106dd7:	8b 45 08             	mov    0x8(%ebp),%eax
80106dda:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ddd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106de1:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106de4:	8a 45 f8             	mov    -0x8(%ebp),%al
80106de7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106dea:	ee                   	out    %al,(%dx)
}
80106deb:	c9                   	leave  
80106dec:	c3                   	ret    

80106ded <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106ded:	55                   	push   %ebp
80106dee:	89 e5                	mov    %esp,%ebp
80106df0:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106df3:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106dfa:	00 
80106dfb:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106e02:	e8 ca ff ff ff       	call   80106dd1 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106e07:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106e0e:	00 
80106e0f:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106e16:	e8 b6 ff ff ff       	call   80106dd1 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106e1b:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106e22:	00 
80106e23:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106e2a:	e8 a2 ff ff ff       	call   80106dd1 <outb>
  picenable(IRQ_TIMER);
80106e2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e36:	e8 81 cc ff ff       	call   80103abc <picenable>
}
80106e3b:	c9                   	leave  
80106e3c:	c3                   	ret    

80106e3d <alltraps>:
80106e3d:	1e                   	push   %ds
80106e3e:	06                   	push   %es
80106e3f:	0f a0                	push   %fs
80106e41:	0f a8                	push   %gs
80106e43:	60                   	pusha  
80106e44:	66 b8 10 00          	mov    $0x10,%ax
80106e48:	8e d8                	mov    %eax,%ds
80106e4a:	8e c0                	mov    %eax,%es
80106e4c:	66 b8 18 00          	mov    $0x18,%ax
80106e50:	8e e0                	mov    %eax,%fs
80106e52:	8e e8                	mov    %eax,%gs
80106e54:	54                   	push   %esp
80106e55:	e8 c4 01 00 00       	call   8010701e <trap>
80106e5a:	83 c4 04             	add    $0x4,%esp

80106e5d <trapret>:
80106e5d:	61                   	popa   
80106e5e:	0f a9                	pop    %gs
80106e60:	0f a1                	pop    %fs
80106e62:	07                   	pop    %es
80106e63:	1f                   	pop    %ds
80106e64:	83 c4 08             	add    $0x8,%esp
80106e67:	cf                   	iret   

80106e68 <lidt>:
{
80106e68:	55                   	push   %ebp
80106e69:	89 e5                	mov    %esp,%ebp
80106e6b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e71:	48                   	dec    %eax
80106e72:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106e76:	8b 45 08             	mov    0x8(%ebp),%eax
80106e79:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106e7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106e80:	c1 e8 10             	shr    $0x10,%eax
80106e83:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106e87:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106e8a:	0f 01 18             	lidtl  (%eax)
}
80106e8d:	c9                   	leave  
80106e8e:	c3                   	ret    

80106e8f <rcr2>:

static inline uint
rcr2(void)
{
80106e8f:	55                   	push   %ebp
80106e90:	89 e5                	mov    %esp,%ebp
80106e92:	53                   	push   %ebx
80106e93:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106e96:	0f 20 d3             	mov    %cr2,%ebx
80106e99:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106e9f:	83 c4 10             	add    $0x10,%esp
80106ea2:	5b                   	pop    %ebx
80106ea3:	5d                   	pop    %ebp
80106ea4:	c3                   	ret    

80106ea5 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ea5:	55                   	push   %ebp
80106ea6:	89 e5                	mov    %esp,%ebp
80106ea8:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106eb2:	e9 b8 00 00 00       	jmp    80106f6f <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eba:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ec4:	66 89 04 d5 60 3c 11 	mov    %ax,-0x7feec3a0(,%edx,8)
80106ecb:	80 
80106ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ecf:	66 c7 04 c5 62 3c 11 	movw   $0x8,-0x7feec39e(,%eax,8)
80106ed6:	80 08 00 
80106ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106edc:	8a 14 c5 64 3c 11 80 	mov    -0x7feec39c(,%eax,8),%dl
80106ee3:	83 e2 e0             	and    $0xffffffe0,%edx
80106ee6:	88 14 c5 64 3c 11 80 	mov    %dl,-0x7feec39c(,%eax,8)
80106eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef0:	8a 14 c5 64 3c 11 80 	mov    -0x7feec39c(,%eax,8),%dl
80106ef7:	83 e2 1f             	and    $0x1f,%edx
80106efa:	88 14 c5 64 3c 11 80 	mov    %dl,-0x7feec39c(,%eax,8)
80106f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f04:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f0b:	83 e2 f0             	and    $0xfffffff0,%edx
80106f0e:	83 ca 0e             	or     $0xe,%edx
80106f11:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f1b:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f22:	83 e2 ef             	and    $0xffffffef,%edx
80106f25:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f2f:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f36:	83 e2 9f             	and    $0xffffff9f,%edx
80106f39:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f43:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f4a:	83 ca 80             	or     $0xffffff80,%edx
80106f4d:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f57:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106f5e:	c1 e8 10             	shr    $0x10,%eax
80106f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f64:	66 89 04 d5 66 3c 11 	mov    %ax,-0x7feec39a(,%edx,8)
80106f6b:	80 
  for(i = 0; i < 256; i++)
80106f6c:	ff 45 f4             	incl   -0xc(%ebp)
80106f6f:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106f76:	0f 8e 3b ff ff ff    	jle    80106eb7 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f7c:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80106f81:	66 a3 60 3e 11 80    	mov    %ax,0x80113e60
80106f87:	66 c7 05 62 3e 11 80 	movw   $0x8,0x80113e62
80106f8e:	08 00 
80106f90:	a0 64 3e 11 80       	mov    0x80113e64,%al
80106f95:	83 e0 e0             	and    $0xffffffe0,%eax
80106f98:	a2 64 3e 11 80       	mov    %al,0x80113e64
80106f9d:	a0 64 3e 11 80       	mov    0x80113e64,%al
80106fa2:	83 e0 1f             	and    $0x1f,%eax
80106fa5:	a2 64 3e 11 80       	mov    %al,0x80113e64
80106faa:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106faf:	83 c8 0f             	or     $0xf,%eax
80106fb2:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fb7:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106fbc:	83 e0 ef             	and    $0xffffffef,%eax
80106fbf:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fc4:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106fc9:	83 c8 60             	or     $0x60,%eax
80106fcc:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fd1:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106fd6:	83 c8 80             	or     $0xffffff80,%eax
80106fd9:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fde:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80106fe3:	c1 e8 10             	shr    $0x10,%eax
80106fe6:	66 a3 66 3e 11 80    	mov    %ax,0x80113e66
  
  initlock(&tickslock, "time");
80106fec:	c7 44 24 04 d8 92 10 	movl   $0x801092d8,0x4(%esp)
80106ff3:	80 
80106ff4:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106ffb:	e8 8d e5 ff ff       	call   8010558d <initlock>
}
80107000:	c9                   	leave  
80107001:	c3                   	ret    

80107002 <idtinit>:

void
idtinit(void)
{
80107002:	55                   	push   %ebp
80107003:	89 e5                	mov    %esp,%ebp
80107005:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80107008:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010700f:	00 
80107010:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80107017:	e8 4c fe ff ff       	call   80106e68 <lidt>
}
8010701c:	c9                   	leave  
8010701d:	c3                   	ret    

8010701e <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010701e:	55                   	push   %ebp
8010701f:	89 e5                	mov    %esp,%ebp
80107021:	57                   	push   %edi
80107022:	56                   	push   %esi
80107023:	53                   	push   %ebx
80107024:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80107027:	8b 45 08             	mov    0x8(%ebp),%eax
8010702a:	8b 40 30             	mov    0x30(%eax),%eax
8010702d:	83 f8 40             	cmp    $0x40,%eax
80107030:	75 3e                	jne    80107070 <trap+0x52>
    if(proc->killed)
80107032:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107038:	8b 40 24             	mov    0x24(%eax),%eax
8010703b:	85 c0                	test   %eax,%eax
8010703d:	74 05                	je     80107044 <trap+0x26>
      exit();
8010703f:	e8 f6 d5 ff ff       	call   8010463a <exit>
    proc->tf = tf;
80107044:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010704a:	8b 55 08             	mov    0x8(%ebp),%edx
8010704d:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107050:	e8 a3 eb ff ff       	call   80105bf8 <syscall>
    if(proc->killed)
80107055:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010705b:	8b 40 24             	mov    0x24(%eax),%eax
8010705e:	85 c0                	test   %eax,%eax
80107060:	0f 84 3f 02 00 00    	je     801072a5 <trap+0x287>
      exit();
80107066:	e8 cf d5 ff ff       	call   8010463a <exit>
    return;
8010706b:	e9 35 02 00 00       	jmp    801072a5 <trap+0x287>
  }

  switch(tf->trapno){
80107070:	8b 45 08             	mov    0x8(%ebp),%eax
80107073:	8b 40 30             	mov    0x30(%eax),%eax
80107076:	83 e8 20             	sub    $0x20,%eax
80107079:	83 f8 1f             	cmp    $0x1f,%eax
8010707c:	0f 87 b7 00 00 00    	ja     80107139 <trap+0x11b>
80107082:	8b 04 85 80 93 10 80 	mov    -0x7fef6c80(,%eax,4),%eax
80107089:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010708b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107091:	8a 00                	mov    (%eax),%al
80107093:	84 c0                	test   %al,%al
80107095:	75 2f                	jne    801070c6 <trap+0xa8>
      acquire(&tickslock);
80107097:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
8010709e:	e8 0b e5 ff ff       	call   801055ae <acquire>
      ticks++;
801070a3:	a1 60 44 11 80       	mov    0x80114460,%eax
801070a8:	40                   	inc    %eax
801070a9:	a3 60 44 11 80       	mov    %eax,0x80114460
      wakeup(&ticks);
801070ae:	c7 04 24 60 44 11 80 	movl   $0x80114460,(%esp)
801070b5:	e8 34 db ff ff       	call   80104bee <wakeup>
      release(&tickslock);
801070ba:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
801070c1:	e8 4a e5 ff ff       	call   80105610 <release>
    }
    lapiceoi();
801070c6:	e8 d4 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070cb:	e9 3c 01 00 00       	jmp    8010720c <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801070d0:	e8 e8 b5 ff ff       	call   801026bd <ideintr>
    lapiceoi();
801070d5:	e8 c5 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070da:	e9 2d 01 00 00       	jmp    8010720c <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801070df:	e8 9e bb ff ff       	call   80102c82 <kbdintr>
    lapiceoi();
801070e4:	e8 b6 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070e9:	e9 1e 01 00 00       	jmp    8010720c <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801070ee:	e8 af 03 00 00       	call   801074a2 <uartintr>
    lapiceoi();
801070f3:	e8 a7 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070f8:	e9 0f 01 00 00       	jmp    8010720c <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801070fd:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107100:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107103:	8b 45 08             	mov    0x8(%ebp),%eax
80107106:	8b 40 3c             	mov    0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107109:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010710c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107112:	8a 00                	mov    (%eax),%al
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107114:	0f b6 c0             	movzbl %al,%eax
80107117:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010711b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010711f:	89 44 24 04          	mov    %eax,0x4(%esp)
80107123:	c7 04 24 e0 92 10 80 	movl   $0x801092e0,(%esp)
8010712a:	e8 72 92 ff ff       	call   801003a1 <cprintf>
    lapiceoi();
8010712f:	e8 6b bd ff ff       	call   80102e9f <lapiceoi>
    break;
80107134:	e9 d3 00 00 00       	jmp    8010720c <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107139:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010713f:	85 c0                	test   %eax,%eax
80107141:	74 10                	je     80107153 <trap+0x135>
80107143:	8b 45 08             	mov    0x8(%ebp),%eax
80107146:	8b 40 3c             	mov    0x3c(%eax),%eax
80107149:	0f b7 c0             	movzwl %ax,%eax
8010714c:	83 e0 03             	and    $0x3,%eax
8010714f:	85 c0                	test   %eax,%eax
80107151:	75 45                	jne    80107198 <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107153:	e8 37 fd ff ff       	call   80106e8f <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80107158:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010715b:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010715e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107165:	8a 12                	mov    (%edx),%dl
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107167:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010716a:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010716d:	8b 52 30             	mov    0x30(%edx),%edx
80107170:	89 44 24 10          	mov    %eax,0x10(%esp)
80107174:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80107178:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010717c:	89 54 24 04          	mov    %edx,0x4(%esp)
80107180:	c7 04 24 04 93 10 80 	movl   $0x80109304,(%esp)
80107187:	e8 15 92 ff ff       	call   801003a1 <cprintf>
      panic("trap");
8010718c:	c7 04 24 36 93 10 80 	movl   $0x80109336,(%esp)
80107193:	e8 9e 93 ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107198:	e8 f2 fc ff ff       	call   80106e8f <rcr2>
8010719d:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010719f:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071a2:	8b 78 38             	mov    0x38(%eax),%edi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071a5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071ab:	8a 00                	mov    (%eax),%al
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071ad:	0f b6 f0             	movzbl %al,%esi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071b0:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071b3:	8b 58 34             	mov    0x34(%eax),%ebx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071b6:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071b9:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071c2:	83 c0 6c             	add    $0x6c,%eax
801071c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071ce:	8b 40 10             	mov    0x10(%eax),%eax
801071d1:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801071d5:	89 7c 24 18          	mov    %edi,0x18(%esp)
801071d9:	89 74 24 14          	mov    %esi,0x14(%esp)
801071dd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801071e1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801071e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071e8:	89 54 24 08          	mov    %edx,0x8(%esp)
801071ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801071f0:	c7 04 24 3c 93 10 80 	movl   $0x8010933c,(%esp)
801071f7:	e8 a5 91 ff ff       	call   801003a1 <cprintf>
            rcr2());
    proc->killed = 1;
801071fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107202:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107209:	eb 01                	jmp    8010720c <trap+0x1ee>
    break;
8010720b:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010720c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107212:	85 c0                	test   %eax,%eax
80107214:	74 23                	je     80107239 <trap+0x21b>
80107216:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010721c:	8b 40 24             	mov    0x24(%eax),%eax
8010721f:	85 c0                	test   %eax,%eax
80107221:	74 16                	je     80107239 <trap+0x21b>
80107223:	8b 45 08             	mov    0x8(%ebp),%eax
80107226:	8b 40 3c             	mov    0x3c(%eax),%eax
80107229:	0f b7 c0             	movzwl %ax,%eax
8010722c:	83 e0 03             	and    $0x3,%eax
8010722f:	83 f8 03             	cmp    $0x3,%eax
80107232:	75 05                	jne    80107239 <trap+0x21b>
    exit();
80107234:	e8 01 d4 ff ff       	call   8010463a <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER && ++(proc->ticksProc) == QUANTUM) {
80107239:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010723f:	85 c0                	test   %eax,%eax
80107241:	74 33                	je     80107276 <trap+0x258>
80107243:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107249:	8b 40 0c             	mov    0xc(%eax),%eax
8010724c:	83 f8 04             	cmp    $0x4,%eax
8010724f:	75 25                	jne    80107276 <trap+0x258>
80107251:	8b 45 08             	mov    0x8(%ebp),%eax
80107254:	8b 40 30             	mov    0x30(%eax),%eax
80107257:	83 f8 20             	cmp    $0x20,%eax
8010725a:	75 1a                	jne    80107276 <trap+0x258>
8010725c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107262:	8b 50 7c             	mov    0x7c(%eax),%edx
80107265:	42                   	inc    %edx
80107266:	89 50 7c             	mov    %edx,0x7c(%eax)
80107269:	8b 40 7c             	mov    0x7c(%eax),%eax
8010726c:	83 f8 06             	cmp    $0x6,%eax
8010726f:	75 05                	jne    80107276 <trap+0x258>
      // del proyecto 0
      // cprintf("tamaño del quantum: %d\n", QUANTUM);
      // cprintf("cantidad de ticks del proceso: %d\n", proc->ticksProc);
      // cprintf("nombre del proceso: %s\n", proc->name);
      // cprintf("abandone cpu\n");
      yield();
80107271:	e8 e5 d7 ff ff       	call   80104a5b <yield>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107276:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010727c:	85 c0                	test   %eax,%eax
8010727e:	74 26                	je     801072a6 <trap+0x288>
80107280:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107286:	8b 40 24             	mov    0x24(%eax),%eax
80107289:	85 c0                	test   %eax,%eax
8010728b:	74 19                	je     801072a6 <trap+0x288>
8010728d:	8b 45 08             	mov    0x8(%ebp),%eax
80107290:	8b 40 3c             	mov    0x3c(%eax),%eax
80107293:	0f b7 c0             	movzwl %ax,%eax
80107296:	83 e0 03             	and    $0x3,%eax
80107299:	83 f8 03             	cmp    $0x3,%eax
8010729c:	75 08                	jne    801072a6 <trap+0x288>
    exit();
8010729e:	e8 97 d3 ff ff       	call   8010463a <exit>
801072a3:	eb 01                	jmp    801072a6 <trap+0x288>
    return;
801072a5:	90                   	nop
}
801072a6:	83 c4 3c             	add    $0x3c,%esp
801072a9:	5b                   	pop    %ebx
801072aa:	5e                   	pop    %esi
801072ab:	5f                   	pop    %edi
801072ac:	5d                   	pop    %ebp
801072ad:	c3                   	ret    

801072ae <inb>:
{
801072ae:	55                   	push   %ebp
801072af:	89 e5                	mov    %esp,%ebp
801072b1:	53                   	push   %ebx
801072b2:	83 ec 14             	sub    $0x14,%esp
801072b5:	8b 45 08             	mov    0x8(%ebp),%eax
801072b8:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801072bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
801072bf:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801072c3:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801072c7:	ec                   	in     (%dx),%al
801072c8:	88 c3                	mov    %al,%bl
801072ca:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801072cd:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801072d0:	83 c4 14             	add    $0x14,%esp
801072d3:	5b                   	pop    %ebx
801072d4:	5d                   	pop    %ebp
801072d5:	c3                   	ret    

801072d6 <outb>:
{
801072d6:	55                   	push   %ebp
801072d7:	89 e5                	mov    %esp,%ebp
801072d9:	83 ec 08             	sub    $0x8,%esp
801072dc:	8b 45 08             	mov    0x8(%ebp),%eax
801072df:	8b 55 0c             	mov    0xc(%ebp),%edx
801072e2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801072e6:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801072e9:	8a 45 f8             	mov    -0x8(%ebp),%al
801072ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
801072ef:	ee                   	out    %al,(%dx)
}
801072f0:	c9                   	leave  
801072f1:	c3                   	ret    

801072f2 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801072f2:	55                   	push   %ebp
801072f3:	89 e5                	mov    %esp,%ebp
801072f5:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801072f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072ff:	00 
80107300:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107307:	e8 ca ff ff ff       	call   801072d6 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010730c:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107313:	00 
80107314:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010731b:	e8 b6 ff ff ff       	call   801072d6 <outb>
  outb(COM1+0, 115200/9600);
80107320:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107327:	00 
80107328:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010732f:	e8 a2 ff ff ff       	call   801072d6 <outb>
  outb(COM1+1, 0);
80107334:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010733b:	00 
8010733c:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107343:	e8 8e ff ff ff       	call   801072d6 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107348:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010734f:	00 
80107350:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107357:	e8 7a ff ff ff       	call   801072d6 <outb>
  outb(COM1+4, 0);
8010735c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107363:	00 
80107364:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
8010736b:	e8 66 ff ff ff       	call   801072d6 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107370:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107377:	00 
80107378:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010737f:	e8 52 ff ff ff       	call   801072d6 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107384:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010738b:	e8 1e ff ff ff       	call   801072ae <inb>
80107390:	3c ff                	cmp    $0xff,%al
80107392:	74 69                	je     801073fd <uartinit+0x10b>
    return;
  uart = 1;
80107394:	c7 05 8c c6 10 80 01 	movl   $0x1,0x8010c68c
8010739b:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010739e:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801073a5:	e8 04 ff ff ff       	call   801072ae <inb>
  inb(COM1+0);
801073aa:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073b1:	e8 f8 fe ff ff       	call   801072ae <inb>
  picenable(IRQ_COM1);
801073b6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801073bd:	e8 fa c6 ff ff       	call   80103abc <picenable>
  ioapicenable(IRQ_COM1, 0);
801073c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073c9:	00 
801073ca:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801073d1:	e8 64 b5 ff ff       	call   8010293a <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801073d6:	c7 45 f4 00 94 10 80 	movl   $0x80109400,-0xc(%ebp)
801073dd:	eb 13                	jmp    801073f2 <uartinit+0x100>
    uartputc(*p);
801073df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e2:	8a 00                	mov    (%eax),%al
801073e4:	0f be c0             	movsbl %al,%eax
801073e7:	89 04 24             	mov    %eax,(%esp)
801073ea:	e8 11 00 00 00       	call   80107400 <uartputc>
  for(p="xv6...\n"; *p; p++)
801073ef:	ff 45 f4             	incl   -0xc(%ebp)
801073f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073f5:	8a 00                	mov    (%eax),%al
801073f7:	84 c0                	test   %al,%al
801073f9:	75 e4                	jne    801073df <uartinit+0xed>
801073fb:	eb 01                	jmp    801073fe <uartinit+0x10c>
    return;
801073fd:	90                   	nop
}
801073fe:	c9                   	leave  
801073ff:	c3                   	ret    

80107400 <uartputc>:

void
uartputc(int c)
{
80107400:	55                   	push   %ebp
80107401:	89 e5                	mov    %esp,%ebp
80107403:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107406:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
8010740b:	85 c0                	test   %eax,%eax
8010740d:	74 4c                	je     8010745b <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010740f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107416:	eb 0f                	jmp    80107427 <uartputc+0x27>
    microdelay(10);
80107418:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010741f:	e8 a0 ba ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107424:	ff 45 f4             	incl   -0xc(%ebp)
80107427:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010742b:	7f 16                	jg     80107443 <uartputc+0x43>
8010742d:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107434:	e8 75 fe ff ff       	call   801072ae <inb>
80107439:	0f b6 c0             	movzbl %al,%eax
8010743c:	83 e0 20             	and    $0x20,%eax
8010743f:	85 c0                	test   %eax,%eax
80107441:	74 d5                	je     80107418 <uartputc+0x18>
  outb(COM1+0, c);
80107443:	8b 45 08             	mov    0x8(%ebp),%eax
80107446:	0f b6 c0             	movzbl %al,%eax
80107449:	89 44 24 04          	mov    %eax,0x4(%esp)
8010744d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107454:	e8 7d fe ff ff       	call   801072d6 <outb>
80107459:	eb 01                	jmp    8010745c <uartputc+0x5c>
    return;
8010745b:	90                   	nop
}
8010745c:	c9                   	leave  
8010745d:	c3                   	ret    

8010745e <uartgetc>:

static int
uartgetc(void)
{
8010745e:	55                   	push   %ebp
8010745f:	89 e5                	mov    %esp,%ebp
80107461:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107464:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
80107469:	85 c0                	test   %eax,%eax
8010746b:	75 07                	jne    80107474 <uartgetc+0x16>
    return -1;
8010746d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107472:	eb 2c                	jmp    801074a0 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80107474:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010747b:	e8 2e fe ff ff       	call   801072ae <inb>
80107480:	0f b6 c0             	movzbl %al,%eax
80107483:	83 e0 01             	and    $0x1,%eax
80107486:	85 c0                	test   %eax,%eax
80107488:	75 07                	jne    80107491 <uartgetc+0x33>
    return -1;
8010748a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010748f:	eb 0f                	jmp    801074a0 <uartgetc+0x42>
  return inb(COM1+0);
80107491:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107498:	e8 11 fe ff ff       	call   801072ae <inb>
8010749d:	0f b6 c0             	movzbl %al,%eax
}
801074a0:	c9                   	leave  
801074a1:	c3                   	ret    

801074a2 <uartintr>:

void
uartintr(void)
{
801074a2:	55                   	push   %ebp
801074a3:	89 e5                	mov    %esp,%ebp
801074a5:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801074a8:	c7 04 24 5e 74 10 80 	movl   $0x8010745e,(%esp)
801074af:	e8 dc 92 ff ff       	call   80100790 <consoleintr>
}
801074b4:	c9                   	leave  
801074b5:	c3                   	ret    

801074b6 <vector0>:
801074b6:	6a 00                	push   $0x0
801074b8:	6a 00                	push   $0x0
801074ba:	e9 7e f9 ff ff       	jmp    80106e3d <alltraps>

801074bf <vector1>:
801074bf:	6a 00                	push   $0x0
801074c1:	6a 01                	push   $0x1
801074c3:	e9 75 f9 ff ff       	jmp    80106e3d <alltraps>

801074c8 <vector2>:
801074c8:	6a 00                	push   $0x0
801074ca:	6a 02                	push   $0x2
801074cc:	e9 6c f9 ff ff       	jmp    80106e3d <alltraps>

801074d1 <vector3>:
801074d1:	6a 00                	push   $0x0
801074d3:	6a 03                	push   $0x3
801074d5:	e9 63 f9 ff ff       	jmp    80106e3d <alltraps>

801074da <vector4>:
801074da:	6a 00                	push   $0x0
801074dc:	6a 04                	push   $0x4
801074de:	e9 5a f9 ff ff       	jmp    80106e3d <alltraps>

801074e3 <vector5>:
801074e3:	6a 00                	push   $0x0
801074e5:	6a 05                	push   $0x5
801074e7:	e9 51 f9 ff ff       	jmp    80106e3d <alltraps>

801074ec <vector6>:
801074ec:	6a 00                	push   $0x0
801074ee:	6a 06                	push   $0x6
801074f0:	e9 48 f9 ff ff       	jmp    80106e3d <alltraps>

801074f5 <vector7>:
801074f5:	6a 00                	push   $0x0
801074f7:	6a 07                	push   $0x7
801074f9:	e9 3f f9 ff ff       	jmp    80106e3d <alltraps>

801074fe <vector8>:
801074fe:	6a 08                	push   $0x8
80107500:	e9 38 f9 ff ff       	jmp    80106e3d <alltraps>

80107505 <vector9>:
80107505:	6a 00                	push   $0x0
80107507:	6a 09                	push   $0x9
80107509:	e9 2f f9 ff ff       	jmp    80106e3d <alltraps>

8010750e <vector10>:
8010750e:	6a 0a                	push   $0xa
80107510:	e9 28 f9 ff ff       	jmp    80106e3d <alltraps>

80107515 <vector11>:
80107515:	6a 0b                	push   $0xb
80107517:	e9 21 f9 ff ff       	jmp    80106e3d <alltraps>

8010751c <vector12>:
8010751c:	6a 0c                	push   $0xc
8010751e:	e9 1a f9 ff ff       	jmp    80106e3d <alltraps>

80107523 <vector13>:
80107523:	6a 0d                	push   $0xd
80107525:	e9 13 f9 ff ff       	jmp    80106e3d <alltraps>

8010752a <vector14>:
8010752a:	6a 0e                	push   $0xe
8010752c:	e9 0c f9 ff ff       	jmp    80106e3d <alltraps>

80107531 <vector15>:
80107531:	6a 00                	push   $0x0
80107533:	6a 0f                	push   $0xf
80107535:	e9 03 f9 ff ff       	jmp    80106e3d <alltraps>

8010753a <vector16>:
8010753a:	6a 00                	push   $0x0
8010753c:	6a 10                	push   $0x10
8010753e:	e9 fa f8 ff ff       	jmp    80106e3d <alltraps>

80107543 <vector17>:
80107543:	6a 11                	push   $0x11
80107545:	e9 f3 f8 ff ff       	jmp    80106e3d <alltraps>

8010754a <vector18>:
8010754a:	6a 00                	push   $0x0
8010754c:	6a 12                	push   $0x12
8010754e:	e9 ea f8 ff ff       	jmp    80106e3d <alltraps>

80107553 <vector19>:
80107553:	6a 00                	push   $0x0
80107555:	6a 13                	push   $0x13
80107557:	e9 e1 f8 ff ff       	jmp    80106e3d <alltraps>

8010755c <vector20>:
8010755c:	6a 00                	push   $0x0
8010755e:	6a 14                	push   $0x14
80107560:	e9 d8 f8 ff ff       	jmp    80106e3d <alltraps>

80107565 <vector21>:
80107565:	6a 00                	push   $0x0
80107567:	6a 15                	push   $0x15
80107569:	e9 cf f8 ff ff       	jmp    80106e3d <alltraps>

8010756e <vector22>:
8010756e:	6a 00                	push   $0x0
80107570:	6a 16                	push   $0x16
80107572:	e9 c6 f8 ff ff       	jmp    80106e3d <alltraps>

80107577 <vector23>:
80107577:	6a 00                	push   $0x0
80107579:	6a 17                	push   $0x17
8010757b:	e9 bd f8 ff ff       	jmp    80106e3d <alltraps>

80107580 <vector24>:
80107580:	6a 00                	push   $0x0
80107582:	6a 18                	push   $0x18
80107584:	e9 b4 f8 ff ff       	jmp    80106e3d <alltraps>

80107589 <vector25>:
80107589:	6a 00                	push   $0x0
8010758b:	6a 19                	push   $0x19
8010758d:	e9 ab f8 ff ff       	jmp    80106e3d <alltraps>

80107592 <vector26>:
80107592:	6a 00                	push   $0x0
80107594:	6a 1a                	push   $0x1a
80107596:	e9 a2 f8 ff ff       	jmp    80106e3d <alltraps>

8010759b <vector27>:
8010759b:	6a 00                	push   $0x0
8010759d:	6a 1b                	push   $0x1b
8010759f:	e9 99 f8 ff ff       	jmp    80106e3d <alltraps>

801075a4 <vector28>:
801075a4:	6a 00                	push   $0x0
801075a6:	6a 1c                	push   $0x1c
801075a8:	e9 90 f8 ff ff       	jmp    80106e3d <alltraps>

801075ad <vector29>:
801075ad:	6a 00                	push   $0x0
801075af:	6a 1d                	push   $0x1d
801075b1:	e9 87 f8 ff ff       	jmp    80106e3d <alltraps>

801075b6 <vector30>:
801075b6:	6a 00                	push   $0x0
801075b8:	6a 1e                	push   $0x1e
801075ba:	e9 7e f8 ff ff       	jmp    80106e3d <alltraps>

801075bf <vector31>:
801075bf:	6a 00                	push   $0x0
801075c1:	6a 1f                	push   $0x1f
801075c3:	e9 75 f8 ff ff       	jmp    80106e3d <alltraps>

801075c8 <vector32>:
801075c8:	6a 00                	push   $0x0
801075ca:	6a 20                	push   $0x20
801075cc:	e9 6c f8 ff ff       	jmp    80106e3d <alltraps>

801075d1 <vector33>:
801075d1:	6a 00                	push   $0x0
801075d3:	6a 21                	push   $0x21
801075d5:	e9 63 f8 ff ff       	jmp    80106e3d <alltraps>

801075da <vector34>:
801075da:	6a 00                	push   $0x0
801075dc:	6a 22                	push   $0x22
801075de:	e9 5a f8 ff ff       	jmp    80106e3d <alltraps>

801075e3 <vector35>:
801075e3:	6a 00                	push   $0x0
801075e5:	6a 23                	push   $0x23
801075e7:	e9 51 f8 ff ff       	jmp    80106e3d <alltraps>

801075ec <vector36>:
801075ec:	6a 00                	push   $0x0
801075ee:	6a 24                	push   $0x24
801075f0:	e9 48 f8 ff ff       	jmp    80106e3d <alltraps>

801075f5 <vector37>:
801075f5:	6a 00                	push   $0x0
801075f7:	6a 25                	push   $0x25
801075f9:	e9 3f f8 ff ff       	jmp    80106e3d <alltraps>

801075fe <vector38>:
801075fe:	6a 00                	push   $0x0
80107600:	6a 26                	push   $0x26
80107602:	e9 36 f8 ff ff       	jmp    80106e3d <alltraps>

80107607 <vector39>:
80107607:	6a 00                	push   $0x0
80107609:	6a 27                	push   $0x27
8010760b:	e9 2d f8 ff ff       	jmp    80106e3d <alltraps>

80107610 <vector40>:
80107610:	6a 00                	push   $0x0
80107612:	6a 28                	push   $0x28
80107614:	e9 24 f8 ff ff       	jmp    80106e3d <alltraps>

80107619 <vector41>:
80107619:	6a 00                	push   $0x0
8010761b:	6a 29                	push   $0x29
8010761d:	e9 1b f8 ff ff       	jmp    80106e3d <alltraps>

80107622 <vector42>:
80107622:	6a 00                	push   $0x0
80107624:	6a 2a                	push   $0x2a
80107626:	e9 12 f8 ff ff       	jmp    80106e3d <alltraps>

8010762b <vector43>:
8010762b:	6a 00                	push   $0x0
8010762d:	6a 2b                	push   $0x2b
8010762f:	e9 09 f8 ff ff       	jmp    80106e3d <alltraps>

80107634 <vector44>:
80107634:	6a 00                	push   $0x0
80107636:	6a 2c                	push   $0x2c
80107638:	e9 00 f8 ff ff       	jmp    80106e3d <alltraps>

8010763d <vector45>:
8010763d:	6a 00                	push   $0x0
8010763f:	6a 2d                	push   $0x2d
80107641:	e9 f7 f7 ff ff       	jmp    80106e3d <alltraps>

80107646 <vector46>:
80107646:	6a 00                	push   $0x0
80107648:	6a 2e                	push   $0x2e
8010764a:	e9 ee f7 ff ff       	jmp    80106e3d <alltraps>

8010764f <vector47>:
8010764f:	6a 00                	push   $0x0
80107651:	6a 2f                	push   $0x2f
80107653:	e9 e5 f7 ff ff       	jmp    80106e3d <alltraps>

80107658 <vector48>:
80107658:	6a 00                	push   $0x0
8010765a:	6a 30                	push   $0x30
8010765c:	e9 dc f7 ff ff       	jmp    80106e3d <alltraps>

80107661 <vector49>:
80107661:	6a 00                	push   $0x0
80107663:	6a 31                	push   $0x31
80107665:	e9 d3 f7 ff ff       	jmp    80106e3d <alltraps>

8010766a <vector50>:
8010766a:	6a 00                	push   $0x0
8010766c:	6a 32                	push   $0x32
8010766e:	e9 ca f7 ff ff       	jmp    80106e3d <alltraps>

80107673 <vector51>:
80107673:	6a 00                	push   $0x0
80107675:	6a 33                	push   $0x33
80107677:	e9 c1 f7 ff ff       	jmp    80106e3d <alltraps>

8010767c <vector52>:
8010767c:	6a 00                	push   $0x0
8010767e:	6a 34                	push   $0x34
80107680:	e9 b8 f7 ff ff       	jmp    80106e3d <alltraps>

80107685 <vector53>:
80107685:	6a 00                	push   $0x0
80107687:	6a 35                	push   $0x35
80107689:	e9 af f7 ff ff       	jmp    80106e3d <alltraps>

8010768e <vector54>:
8010768e:	6a 00                	push   $0x0
80107690:	6a 36                	push   $0x36
80107692:	e9 a6 f7 ff ff       	jmp    80106e3d <alltraps>

80107697 <vector55>:
80107697:	6a 00                	push   $0x0
80107699:	6a 37                	push   $0x37
8010769b:	e9 9d f7 ff ff       	jmp    80106e3d <alltraps>

801076a0 <vector56>:
801076a0:	6a 00                	push   $0x0
801076a2:	6a 38                	push   $0x38
801076a4:	e9 94 f7 ff ff       	jmp    80106e3d <alltraps>

801076a9 <vector57>:
801076a9:	6a 00                	push   $0x0
801076ab:	6a 39                	push   $0x39
801076ad:	e9 8b f7 ff ff       	jmp    80106e3d <alltraps>

801076b2 <vector58>:
801076b2:	6a 00                	push   $0x0
801076b4:	6a 3a                	push   $0x3a
801076b6:	e9 82 f7 ff ff       	jmp    80106e3d <alltraps>

801076bb <vector59>:
801076bb:	6a 00                	push   $0x0
801076bd:	6a 3b                	push   $0x3b
801076bf:	e9 79 f7 ff ff       	jmp    80106e3d <alltraps>

801076c4 <vector60>:
801076c4:	6a 00                	push   $0x0
801076c6:	6a 3c                	push   $0x3c
801076c8:	e9 70 f7 ff ff       	jmp    80106e3d <alltraps>

801076cd <vector61>:
801076cd:	6a 00                	push   $0x0
801076cf:	6a 3d                	push   $0x3d
801076d1:	e9 67 f7 ff ff       	jmp    80106e3d <alltraps>

801076d6 <vector62>:
801076d6:	6a 00                	push   $0x0
801076d8:	6a 3e                	push   $0x3e
801076da:	e9 5e f7 ff ff       	jmp    80106e3d <alltraps>

801076df <vector63>:
801076df:	6a 00                	push   $0x0
801076e1:	6a 3f                	push   $0x3f
801076e3:	e9 55 f7 ff ff       	jmp    80106e3d <alltraps>

801076e8 <vector64>:
801076e8:	6a 00                	push   $0x0
801076ea:	6a 40                	push   $0x40
801076ec:	e9 4c f7 ff ff       	jmp    80106e3d <alltraps>

801076f1 <vector65>:
801076f1:	6a 00                	push   $0x0
801076f3:	6a 41                	push   $0x41
801076f5:	e9 43 f7 ff ff       	jmp    80106e3d <alltraps>

801076fa <vector66>:
801076fa:	6a 00                	push   $0x0
801076fc:	6a 42                	push   $0x42
801076fe:	e9 3a f7 ff ff       	jmp    80106e3d <alltraps>

80107703 <vector67>:
80107703:	6a 00                	push   $0x0
80107705:	6a 43                	push   $0x43
80107707:	e9 31 f7 ff ff       	jmp    80106e3d <alltraps>

8010770c <vector68>:
8010770c:	6a 00                	push   $0x0
8010770e:	6a 44                	push   $0x44
80107710:	e9 28 f7 ff ff       	jmp    80106e3d <alltraps>

80107715 <vector69>:
80107715:	6a 00                	push   $0x0
80107717:	6a 45                	push   $0x45
80107719:	e9 1f f7 ff ff       	jmp    80106e3d <alltraps>

8010771e <vector70>:
8010771e:	6a 00                	push   $0x0
80107720:	6a 46                	push   $0x46
80107722:	e9 16 f7 ff ff       	jmp    80106e3d <alltraps>

80107727 <vector71>:
80107727:	6a 00                	push   $0x0
80107729:	6a 47                	push   $0x47
8010772b:	e9 0d f7 ff ff       	jmp    80106e3d <alltraps>

80107730 <vector72>:
80107730:	6a 00                	push   $0x0
80107732:	6a 48                	push   $0x48
80107734:	e9 04 f7 ff ff       	jmp    80106e3d <alltraps>

80107739 <vector73>:
80107739:	6a 00                	push   $0x0
8010773b:	6a 49                	push   $0x49
8010773d:	e9 fb f6 ff ff       	jmp    80106e3d <alltraps>

80107742 <vector74>:
80107742:	6a 00                	push   $0x0
80107744:	6a 4a                	push   $0x4a
80107746:	e9 f2 f6 ff ff       	jmp    80106e3d <alltraps>

8010774b <vector75>:
8010774b:	6a 00                	push   $0x0
8010774d:	6a 4b                	push   $0x4b
8010774f:	e9 e9 f6 ff ff       	jmp    80106e3d <alltraps>

80107754 <vector76>:
80107754:	6a 00                	push   $0x0
80107756:	6a 4c                	push   $0x4c
80107758:	e9 e0 f6 ff ff       	jmp    80106e3d <alltraps>

8010775d <vector77>:
8010775d:	6a 00                	push   $0x0
8010775f:	6a 4d                	push   $0x4d
80107761:	e9 d7 f6 ff ff       	jmp    80106e3d <alltraps>

80107766 <vector78>:
80107766:	6a 00                	push   $0x0
80107768:	6a 4e                	push   $0x4e
8010776a:	e9 ce f6 ff ff       	jmp    80106e3d <alltraps>

8010776f <vector79>:
8010776f:	6a 00                	push   $0x0
80107771:	6a 4f                	push   $0x4f
80107773:	e9 c5 f6 ff ff       	jmp    80106e3d <alltraps>

80107778 <vector80>:
80107778:	6a 00                	push   $0x0
8010777a:	6a 50                	push   $0x50
8010777c:	e9 bc f6 ff ff       	jmp    80106e3d <alltraps>

80107781 <vector81>:
80107781:	6a 00                	push   $0x0
80107783:	6a 51                	push   $0x51
80107785:	e9 b3 f6 ff ff       	jmp    80106e3d <alltraps>

8010778a <vector82>:
8010778a:	6a 00                	push   $0x0
8010778c:	6a 52                	push   $0x52
8010778e:	e9 aa f6 ff ff       	jmp    80106e3d <alltraps>

80107793 <vector83>:
80107793:	6a 00                	push   $0x0
80107795:	6a 53                	push   $0x53
80107797:	e9 a1 f6 ff ff       	jmp    80106e3d <alltraps>

8010779c <vector84>:
8010779c:	6a 00                	push   $0x0
8010779e:	6a 54                	push   $0x54
801077a0:	e9 98 f6 ff ff       	jmp    80106e3d <alltraps>

801077a5 <vector85>:
801077a5:	6a 00                	push   $0x0
801077a7:	6a 55                	push   $0x55
801077a9:	e9 8f f6 ff ff       	jmp    80106e3d <alltraps>

801077ae <vector86>:
801077ae:	6a 00                	push   $0x0
801077b0:	6a 56                	push   $0x56
801077b2:	e9 86 f6 ff ff       	jmp    80106e3d <alltraps>

801077b7 <vector87>:
801077b7:	6a 00                	push   $0x0
801077b9:	6a 57                	push   $0x57
801077bb:	e9 7d f6 ff ff       	jmp    80106e3d <alltraps>

801077c0 <vector88>:
801077c0:	6a 00                	push   $0x0
801077c2:	6a 58                	push   $0x58
801077c4:	e9 74 f6 ff ff       	jmp    80106e3d <alltraps>

801077c9 <vector89>:
801077c9:	6a 00                	push   $0x0
801077cb:	6a 59                	push   $0x59
801077cd:	e9 6b f6 ff ff       	jmp    80106e3d <alltraps>

801077d2 <vector90>:
801077d2:	6a 00                	push   $0x0
801077d4:	6a 5a                	push   $0x5a
801077d6:	e9 62 f6 ff ff       	jmp    80106e3d <alltraps>

801077db <vector91>:
801077db:	6a 00                	push   $0x0
801077dd:	6a 5b                	push   $0x5b
801077df:	e9 59 f6 ff ff       	jmp    80106e3d <alltraps>

801077e4 <vector92>:
801077e4:	6a 00                	push   $0x0
801077e6:	6a 5c                	push   $0x5c
801077e8:	e9 50 f6 ff ff       	jmp    80106e3d <alltraps>

801077ed <vector93>:
801077ed:	6a 00                	push   $0x0
801077ef:	6a 5d                	push   $0x5d
801077f1:	e9 47 f6 ff ff       	jmp    80106e3d <alltraps>

801077f6 <vector94>:
801077f6:	6a 00                	push   $0x0
801077f8:	6a 5e                	push   $0x5e
801077fa:	e9 3e f6 ff ff       	jmp    80106e3d <alltraps>

801077ff <vector95>:
801077ff:	6a 00                	push   $0x0
80107801:	6a 5f                	push   $0x5f
80107803:	e9 35 f6 ff ff       	jmp    80106e3d <alltraps>

80107808 <vector96>:
80107808:	6a 00                	push   $0x0
8010780a:	6a 60                	push   $0x60
8010780c:	e9 2c f6 ff ff       	jmp    80106e3d <alltraps>

80107811 <vector97>:
80107811:	6a 00                	push   $0x0
80107813:	6a 61                	push   $0x61
80107815:	e9 23 f6 ff ff       	jmp    80106e3d <alltraps>

8010781a <vector98>:
8010781a:	6a 00                	push   $0x0
8010781c:	6a 62                	push   $0x62
8010781e:	e9 1a f6 ff ff       	jmp    80106e3d <alltraps>

80107823 <vector99>:
80107823:	6a 00                	push   $0x0
80107825:	6a 63                	push   $0x63
80107827:	e9 11 f6 ff ff       	jmp    80106e3d <alltraps>

8010782c <vector100>:
8010782c:	6a 00                	push   $0x0
8010782e:	6a 64                	push   $0x64
80107830:	e9 08 f6 ff ff       	jmp    80106e3d <alltraps>

80107835 <vector101>:
80107835:	6a 00                	push   $0x0
80107837:	6a 65                	push   $0x65
80107839:	e9 ff f5 ff ff       	jmp    80106e3d <alltraps>

8010783e <vector102>:
8010783e:	6a 00                	push   $0x0
80107840:	6a 66                	push   $0x66
80107842:	e9 f6 f5 ff ff       	jmp    80106e3d <alltraps>

80107847 <vector103>:
80107847:	6a 00                	push   $0x0
80107849:	6a 67                	push   $0x67
8010784b:	e9 ed f5 ff ff       	jmp    80106e3d <alltraps>

80107850 <vector104>:
80107850:	6a 00                	push   $0x0
80107852:	6a 68                	push   $0x68
80107854:	e9 e4 f5 ff ff       	jmp    80106e3d <alltraps>

80107859 <vector105>:
80107859:	6a 00                	push   $0x0
8010785b:	6a 69                	push   $0x69
8010785d:	e9 db f5 ff ff       	jmp    80106e3d <alltraps>

80107862 <vector106>:
80107862:	6a 00                	push   $0x0
80107864:	6a 6a                	push   $0x6a
80107866:	e9 d2 f5 ff ff       	jmp    80106e3d <alltraps>

8010786b <vector107>:
8010786b:	6a 00                	push   $0x0
8010786d:	6a 6b                	push   $0x6b
8010786f:	e9 c9 f5 ff ff       	jmp    80106e3d <alltraps>

80107874 <vector108>:
80107874:	6a 00                	push   $0x0
80107876:	6a 6c                	push   $0x6c
80107878:	e9 c0 f5 ff ff       	jmp    80106e3d <alltraps>

8010787d <vector109>:
8010787d:	6a 00                	push   $0x0
8010787f:	6a 6d                	push   $0x6d
80107881:	e9 b7 f5 ff ff       	jmp    80106e3d <alltraps>

80107886 <vector110>:
80107886:	6a 00                	push   $0x0
80107888:	6a 6e                	push   $0x6e
8010788a:	e9 ae f5 ff ff       	jmp    80106e3d <alltraps>

8010788f <vector111>:
8010788f:	6a 00                	push   $0x0
80107891:	6a 6f                	push   $0x6f
80107893:	e9 a5 f5 ff ff       	jmp    80106e3d <alltraps>

80107898 <vector112>:
80107898:	6a 00                	push   $0x0
8010789a:	6a 70                	push   $0x70
8010789c:	e9 9c f5 ff ff       	jmp    80106e3d <alltraps>

801078a1 <vector113>:
801078a1:	6a 00                	push   $0x0
801078a3:	6a 71                	push   $0x71
801078a5:	e9 93 f5 ff ff       	jmp    80106e3d <alltraps>

801078aa <vector114>:
801078aa:	6a 00                	push   $0x0
801078ac:	6a 72                	push   $0x72
801078ae:	e9 8a f5 ff ff       	jmp    80106e3d <alltraps>

801078b3 <vector115>:
801078b3:	6a 00                	push   $0x0
801078b5:	6a 73                	push   $0x73
801078b7:	e9 81 f5 ff ff       	jmp    80106e3d <alltraps>

801078bc <vector116>:
801078bc:	6a 00                	push   $0x0
801078be:	6a 74                	push   $0x74
801078c0:	e9 78 f5 ff ff       	jmp    80106e3d <alltraps>

801078c5 <vector117>:
801078c5:	6a 00                	push   $0x0
801078c7:	6a 75                	push   $0x75
801078c9:	e9 6f f5 ff ff       	jmp    80106e3d <alltraps>

801078ce <vector118>:
801078ce:	6a 00                	push   $0x0
801078d0:	6a 76                	push   $0x76
801078d2:	e9 66 f5 ff ff       	jmp    80106e3d <alltraps>

801078d7 <vector119>:
801078d7:	6a 00                	push   $0x0
801078d9:	6a 77                	push   $0x77
801078db:	e9 5d f5 ff ff       	jmp    80106e3d <alltraps>

801078e0 <vector120>:
801078e0:	6a 00                	push   $0x0
801078e2:	6a 78                	push   $0x78
801078e4:	e9 54 f5 ff ff       	jmp    80106e3d <alltraps>

801078e9 <vector121>:
801078e9:	6a 00                	push   $0x0
801078eb:	6a 79                	push   $0x79
801078ed:	e9 4b f5 ff ff       	jmp    80106e3d <alltraps>

801078f2 <vector122>:
801078f2:	6a 00                	push   $0x0
801078f4:	6a 7a                	push   $0x7a
801078f6:	e9 42 f5 ff ff       	jmp    80106e3d <alltraps>

801078fb <vector123>:
801078fb:	6a 00                	push   $0x0
801078fd:	6a 7b                	push   $0x7b
801078ff:	e9 39 f5 ff ff       	jmp    80106e3d <alltraps>

80107904 <vector124>:
80107904:	6a 00                	push   $0x0
80107906:	6a 7c                	push   $0x7c
80107908:	e9 30 f5 ff ff       	jmp    80106e3d <alltraps>

8010790d <vector125>:
8010790d:	6a 00                	push   $0x0
8010790f:	6a 7d                	push   $0x7d
80107911:	e9 27 f5 ff ff       	jmp    80106e3d <alltraps>

80107916 <vector126>:
80107916:	6a 00                	push   $0x0
80107918:	6a 7e                	push   $0x7e
8010791a:	e9 1e f5 ff ff       	jmp    80106e3d <alltraps>

8010791f <vector127>:
8010791f:	6a 00                	push   $0x0
80107921:	6a 7f                	push   $0x7f
80107923:	e9 15 f5 ff ff       	jmp    80106e3d <alltraps>

80107928 <vector128>:
80107928:	6a 00                	push   $0x0
8010792a:	68 80 00 00 00       	push   $0x80
8010792f:	e9 09 f5 ff ff       	jmp    80106e3d <alltraps>

80107934 <vector129>:
80107934:	6a 00                	push   $0x0
80107936:	68 81 00 00 00       	push   $0x81
8010793b:	e9 fd f4 ff ff       	jmp    80106e3d <alltraps>

80107940 <vector130>:
80107940:	6a 00                	push   $0x0
80107942:	68 82 00 00 00       	push   $0x82
80107947:	e9 f1 f4 ff ff       	jmp    80106e3d <alltraps>

8010794c <vector131>:
8010794c:	6a 00                	push   $0x0
8010794e:	68 83 00 00 00       	push   $0x83
80107953:	e9 e5 f4 ff ff       	jmp    80106e3d <alltraps>

80107958 <vector132>:
80107958:	6a 00                	push   $0x0
8010795a:	68 84 00 00 00       	push   $0x84
8010795f:	e9 d9 f4 ff ff       	jmp    80106e3d <alltraps>

80107964 <vector133>:
80107964:	6a 00                	push   $0x0
80107966:	68 85 00 00 00       	push   $0x85
8010796b:	e9 cd f4 ff ff       	jmp    80106e3d <alltraps>

80107970 <vector134>:
80107970:	6a 00                	push   $0x0
80107972:	68 86 00 00 00       	push   $0x86
80107977:	e9 c1 f4 ff ff       	jmp    80106e3d <alltraps>

8010797c <vector135>:
8010797c:	6a 00                	push   $0x0
8010797e:	68 87 00 00 00       	push   $0x87
80107983:	e9 b5 f4 ff ff       	jmp    80106e3d <alltraps>

80107988 <vector136>:
80107988:	6a 00                	push   $0x0
8010798a:	68 88 00 00 00       	push   $0x88
8010798f:	e9 a9 f4 ff ff       	jmp    80106e3d <alltraps>

80107994 <vector137>:
80107994:	6a 00                	push   $0x0
80107996:	68 89 00 00 00       	push   $0x89
8010799b:	e9 9d f4 ff ff       	jmp    80106e3d <alltraps>

801079a0 <vector138>:
801079a0:	6a 00                	push   $0x0
801079a2:	68 8a 00 00 00       	push   $0x8a
801079a7:	e9 91 f4 ff ff       	jmp    80106e3d <alltraps>

801079ac <vector139>:
801079ac:	6a 00                	push   $0x0
801079ae:	68 8b 00 00 00       	push   $0x8b
801079b3:	e9 85 f4 ff ff       	jmp    80106e3d <alltraps>

801079b8 <vector140>:
801079b8:	6a 00                	push   $0x0
801079ba:	68 8c 00 00 00       	push   $0x8c
801079bf:	e9 79 f4 ff ff       	jmp    80106e3d <alltraps>

801079c4 <vector141>:
801079c4:	6a 00                	push   $0x0
801079c6:	68 8d 00 00 00       	push   $0x8d
801079cb:	e9 6d f4 ff ff       	jmp    80106e3d <alltraps>

801079d0 <vector142>:
801079d0:	6a 00                	push   $0x0
801079d2:	68 8e 00 00 00       	push   $0x8e
801079d7:	e9 61 f4 ff ff       	jmp    80106e3d <alltraps>

801079dc <vector143>:
801079dc:	6a 00                	push   $0x0
801079de:	68 8f 00 00 00       	push   $0x8f
801079e3:	e9 55 f4 ff ff       	jmp    80106e3d <alltraps>

801079e8 <vector144>:
801079e8:	6a 00                	push   $0x0
801079ea:	68 90 00 00 00       	push   $0x90
801079ef:	e9 49 f4 ff ff       	jmp    80106e3d <alltraps>

801079f4 <vector145>:
801079f4:	6a 00                	push   $0x0
801079f6:	68 91 00 00 00       	push   $0x91
801079fb:	e9 3d f4 ff ff       	jmp    80106e3d <alltraps>

80107a00 <vector146>:
80107a00:	6a 00                	push   $0x0
80107a02:	68 92 00 00 00       	push   $0x92
80107a07:	e9 31 f4 ff ff       	jmp    80106e3d <alltraps>

80107a0c <vector147>:
80107a0c:	6a 00                	push   $0x0
80107a0e:	68 93 00 00 00       	push   $0x93
80107a13:	e9 25 f4 ff ff       	jmp    80106e3d <alltraps>

80107a18 <vector148>:
80107a18:	6a 00                	push   $0x0
80107a1a:	68 94 00 00 00       	push   $0x94
80107a1f:	e9 19 f4 ff ff       	jmp    80106e3d <alltraps>

80107a24 <vector149>:
80107a24:	6a 00                	push   $0x0
80107a26:	68 95 00 00 00       	push   $0x95
80107a2b:	e9 0d f4 ff ff       	jmp    80106e3d <alltraps>

80107a30 <vector150>:
80107a30:	6a 00                	push   $0x0
80107a32:	68 96 00 00 00       	push   $0x96
80107a37:	e9 01 f4 ff ff       	jmp    80106e3d <alltraps>

80107a3c <vector151>:
80107a3c:	6a 00                	push   $0x0
80107a3e:	68 97 00 00 00       	push   $0x97
80107a43:	e9 f5 f3 ff ff       	jmp    80106e3d <alltraps>

80107a48 <vector152>:
80107a48:	6a 00                	push   $0x0
80107a4a:	68 98 00 00 00       	push   $0x98
80107a4f:	e9 e9 f3 ff ff       	jmp    80106e3d <alltraps>

80107a54 <vector153>:
80107a54:	6a 00                	push   $0x0
80107a56:	68 99 00 00 00       	push   $0x99
80107a5b:	e9 dd f3 ff ff       	jmp    80106e3d <alltraps>

80107a60 <vector154>:
80107a60:	6a 00                	push   $0x0
80107a62:	68 9a 00 00 00       	push   $0x9a
80107a67:	e9 d1 f3 ff ff       	jmp    80106e3d <alltraps>

80107a6c <vector155>:
80107a6c:	6a 00                	push   $0x0
80107a6e:	68 9b 00 00 00       	push   $0x9b
80107a73:	e9 c5 f3 ff ff       	jmp    80106e3d <alltraps>

80107a78 <vector156>:
80107a78:	6a 00                	push   $0x0
80107a7a:	68 9c 00 00 00       	push   $0x9c
80107a7f:	e9 b9 f3 ff ff       	jmp    80106e3d <alltraps>

80107a84 <vector157>:
80107a84:	6a 00                	push   $0x0
80107a86:	68 9d 00 00 00       	push   $0x9d
80107a8b:	e9 ad f3 ff ff       	jmp    80106e3d <alltraps>

80107a90 <vector158>:
80107a90:	6a 00                	push   $0x0
80107a92:	68 9e 00 00 00       	push   $0x9e
80107a97:	e9 a1 f3 ff ff       	jmp    80106e3d <alltraps>

80107a9c <vector159>:
80107a9c:	6a 00                	push   $0x0
80107a9e:	68 9f 00 00 00       	push   $0x9f
80107aa3:	e9 95 f3 ff ff       	jmp    80106e3d <alltraps>

80107aa8 <vector160>:
80107aa8:	6a 00                	push   $0x0
80107aaa:	68 a0 00 00 00       	push   $0xa0
80107aaf:	e9 89 f3 ff ff       	jmp    80106e3d <alltraps>

80107ab4 <vector161>:
80107ab4:	6a 00                	push   $0x0
80107ab6:	68 a1 00 00 00       	push   $0xa1
80107abb:	e9 7d f3 ff ff       	jmp    80106e3d <alltraps>

80107ac0 <vector162>:
80107ac0:	6a 00                	push   $0x0
80107ac2:	68 a2 00 00 00       	push   $0xa2
80107ac7:	e9 71 f3 ff ff       	jmp    80106e3d <alltraps>

80107acc <vector163>:
80107acc:	6a 00                	push   $0x0
80107ace:	68 a3 00 00 00       	push   $0xa3
80107ad3:	e9 65 f3 ff ff       	jmp    80106e3d <alltraps>

80107ad8 <vector164>:
80107ad8:	6a 00                	push   $0x0
80107ada:	68 a4 00 00 00       	push   $0xa4
80107adf:	e9 59 f3 ff ff       	jmp    80106e3d <alltraps>

80107ae4 <vector165>:
80107ae4:	6a 00                	push   $0x0
80107ae6:	68 a5 00 00 00       	push   $0xa5
80107aeb:	e9 4d f3 ff ff       	jmp    80106e3d <alltraps>

80107af0 <vector166>:
80107af0:	6a 00                	push   $0x0
80107af2:	68 a6 00 00 00       	push   $0xa6
80107af7:	e9 41 f3 ff ff       	jmp    80106e3d <alltraps>

80107afc <vector167>:
80107afc:	6a 00                	push   $0x0
80107afe:	68 a7 00 00 00       	push   $0xa7
80107b03:	e9 35 f3 ff ff       	jmp    80106e3d <alltraps>

80107b08 <vector168>:
80107b08:	6a 00                	push   $0x0
80107b0a:	68 a8 00 00 00       	push   $0xa8
80107b0f:	e9 29 f3 ff ff       	jmp    80106e3d <alltraps>

80107b14 <vector169>:
80107b14:	6a 00                	push   $0x0
80107b16:	68 a9 00 00 00       	push   $0xa9
80107b1b:	e9 1d f3 ff ff       	jmp    80106e3d <alltraps>

80107b20 <vector170>:
80107b20:	6a 00                	push   $0x0
80107b22:	68 aa 00 00 00       	push   $0xaa
80107b27:	e9 11 f3 ff ff       	jmp    80106e3d <alltraps>

80107b2c <vector171>:
80107b2c:	6a 00                	push   $0x0
80107b2e:	68 ab 00 00 00       	push   $0xab
80107b33:	e9 05 f3 ff ff       	jmp    80106e3d <alltraps>

80107b38 <vector172>:
80107b38:	6a 00                	push   $0x0
80107b3a:	68 ac 00 00 00       	push   $0xac
80107b3f:	e9 f9 f2 ff ff       	jmp    80106e3d <alltraps>

80107b44 <vector173>:
80107b44:	6a 00                	push   $0x0
80107b46:	68 ad 00 00 00       	push   $0xad
80107b4b:	e9 ed f2 ff ff       	jmp    80106e3d <alltraps>

80107b50 <vector174>:
80107b50:	6a 00                	push   $0x0
80107b52:	68 ae 00 00 00       	push   $0xae
80107b57:	e9 e1 f2 ff ff       	jmp    80106e3d <alltraps>

80107b5c <vector175>:
80107b5c:	6a 00                	push   $0x0
80107b5e:	68 af 00 00 00       	push   $0xaf
80107b63:	e9 d5 f2 ff ff       	jmp    80106e3d <alltraps>

80107b68 <vector176>:
80107b68:	6a 00                	push   $0x0
80107b6a:	68 b0 00 00 00       	push   $0xb0
80107b6f:	e9 c9 f2 ff ff       	jmp    80106e3d <alltraps>

80107b74 <vector177>:
80107b74:	6a 00                	push   $0x0
80107b76:	68 b1 00 00 00       	push   $0xb1
80107b7b:	e9 bd f2 ff ff       	jmp    80106e3d <alltraps>

80107b80 <vector178>:
80107b80:	6a 00                	push   $0x0
80107b82:	68 b2 00 00 00       	push   $0xb2
80107b87:	e9 b1 f2 ff ff       	jmp    80106e3d <alltraps>

80107b8c <vector179>:
80107b8c:	6a 00                	push   $0x0
80107b8e:	68 b3 00 00 00       	push   $0xb3
80107b93:	e9 a5 f2 ff ff       	jmp    80106e3d <alltraps>

80107b98 <vector180>:
80107b98:	6a 00                	push   $0x0
80107b9a:	68 b4 00 00 00       	push   $0xb4
80107b9f:	e9 99 f2 ff ff       	jmp    80106e3d <alltraps>

80107ba4 <vector181>:
80107ba4:	6a 00                	push   $0x0
80107ba6:	68 b5 00 00 00       	push   $0xb5
80107bab:	e9 8d f2 ff ff       	jmp    80106e3d <alltraps>

80107bb0 <vector182>:
80107bb0:	6a 00                	push   $0x0
80107bb2:	68 b6 00 00 00       	push   $0xb6
80107bb7:	e9 81 f2 ff ff       	jmp    80106e3d <alltraps>

80107bbc <vector183>:
80107bbc:	6a 00                	push   $0x0
80107bbe:	68 b7 00 00 00       	push   $0xb7
80107bc3:	e9 75 f2 ff ff       	jmp    80106e3d <alltraps>

80107bc8 <vector184>:
80107bc8:	6a 00                	push   $0x0
80107bca:	68 b8 00 00 00       	push   $0xb8
80107bcf:	e9 69 f2 ff ff       	jmp    80106e3d <alltraps>

80107bd4 <vector185>:
80107bd4:	6a 00                	push   $0x0
80107bd6:	68 b9 00 00 00       	push   $0xb9
80107bdb:	e9 5d f2 ff ff       	jmp    80106e3d <alltraps>

80107be0 <vector186>:
80107be0:	6a 00                	push   $0x0
80107be2:	68 ba 00 00 00       	push   $0xba
80107be7:	e9 51 f2 ff ff       	jmp    80106e3d <alltraps>

80107bec <vector187>:
80107bec:	6a 00                	push   $0x0
80107bee:	68 bb 00 00 00       	push   $0xbb
80107bf3:	e9 45 f2 ff ff       	jmp    80106e3d <alltraps>

80107bf8 <vector188>:
80107bf8:	6a 00                	push   $0x0
80107bfa:	68 bc 00 00 00       	push   $0xbc
80107bff:	e9 39 f2 ff ff       	jmp    80106e3d <alltraps>

80107c04 <vector189>:
80107c04:	6a 00                	push   $0x0
80107c06:	68 bd 00 00 00       	push   $0xbd
80107c0b:	e9 2d f2 ff ff       	jmp    80106e3d <alltraps>

80107c10 <vector190>:
80107c10:	6a 00                	push   $0x0
80107c12:	68 be 00 00 00       	push   $0xbe
80107c17:	e9 21 f2 ff ff       	jmp    80106e3d <alltraps>

80107c1c <vector191>:
80107c1c:	6a 00                	push   $0x0
80107c1e:	68 bf 00 00 00       	push   $0xbf
80107c23:	e9 15 f2 ff ff       	jmp    80106e3d <alltraps>

80107c28 <vector192>:
80107c28:	6a 00                	push   $0x0
80107c2a:	68 c0 00 00 00       	push   $0xc0
80107c2f:	e9 09 f2 ff ff       	jmp    80106e3d <alltraps>

80107c34 <vector193>:
80107c34:	6a 00                	push   $0x0
80107c36:	68 c1 00 00 00       	push   $0xc1
80107c3b:	e9 fd f1 ff ff       	jmp    80106e3d <alltraps>

80107c40 <vector194>:
80107c40:	6a 00                	push   $0x0
80107c42:	68 c2 00 00 00       	push   $0xc2
80107c47:	e9 f1 f1 ff ff       	jmp    80106e3d <alltraps>

80107c4c <vector195>:
80107c4c:	6a 00                	push   $0x0
80107c4e:	68 c3 00 00 00       	push   $0xc3
80107c53:	e9 e5 f1 ff ff       	jmp    80106e3d <alltraps>

80107c58 <vector196>:
80107c58:	6a 00                	push   $0x0
80107c5a:	68 c4 00 00 00       	push   $0xc4
80107c5f:	e9 d9 f1 ff ff       	jmp    80106e3d <alltraps>

80107c64 <vector197>:
80107c64:	6a 00                	push   $0x0
80107c66:	68 c5 00 00 00       	push   $0xc5
80107c6b:	e9 cd f1 ff ff       	jmp    80106e3d <alltraps>

80107c70 <vector198>:
80107c70:	6a 00                	push   $0x0
80107c72:	68 c6 00 00 00       	push   $0xc6
80107c77:	e9 c1 f1 ff ff       	jmp    80106e3d <alltraps>

80107c7c <vector199>:
80107c7c:	6a 00                	push   $0x0
80107c7e:	68 c7 00 00 00       	push   $0xc7
80107c83:	e9 b5 f1 ff ff       	jmp    80106e3d <alltraps>

80107c88 <vector200>:
80107c88:	6a 00                	push   $0x0
80107c8a:	68 c8 00 00 00       	push   $0xc8
80107c8f:	e9 a9 f1 ff ff       	jmp    80106e3d <alltraps>

80107c94 <vector201>:
80107c94:	6a 00                	push   $0x0
80107c96:	68 c9 00 00 00       	push   $0xc9
80107c9b:	e9 9d f1 ff ff       	jmp    80106e3d <alltraps>

80107ca0 <vector202>:
80107ca0:	6a 00                	push   $0x0
80107ca2:	68 ca 00 00 00       	push   $0xca
80107ca7:	e9 91 f1 ff ff       	jmp    80106e3d <alltraps>

80107cac <vector203>:
80107cac:	6a 00                	push   $0x0
80107cae:	68 cb 00 00 00       	push   $0xcb
80107cb3:	e9 85 f1 ff ff       	jmp    80106e3d <alltraps>

80107cb8 <vector204>:
80107cb8:	6a 00                	push   $0x0
80107cba:	68 cc 00 00 00       	push   $0xcc
80107cbf:	e9 79 f1 ff ff       	jmp    80106e3d <alltraps>

80107cc4 <vector205>:
80107cc4:	6a 00                	push   $0x0
80107cc6:	68 cd 00 00 00       	push   $0xcd
80107ccb:	e9 6d f1 ff ff       	jmp    80106e3d <alltraps>

80107cd0 <vector206>:
80107cd0:	6a 00                	push   $0x0
80107cd2:	68 ce 00 00 00       	push   $0xce
80107cd7:	e9 61 f1 ff ff       	jmp    80106e3d <alltraps>

80107cdc <vector207>:
80107cdc:	6a 00                	push   $0x0
80107cde:	68 cf 00 00 00       	push   $0xcf
80107ce3:	e9 55 f1 ff ff       	jmp    80106e3d <alltraps>

80107ce8 <vector208>:
80107ce8:	6a 00                	push   $0x0
80107cea:	68 d0 00 00 00       	push   $0xd0
80107cef:	e9 49 f1 ff ff       	jmp    80106e3d <alltraps>

80107cf4 <vector209>:
80107cf4:	6a 00                	push   $0x0
80107cf6:	68 d1 00 00 00       	push   $0xd1
80107cfb:	e9 3d f1 ff ff       	jmp    80106e3d <alltraps>

80107d00 <vector210>:
80107d00:	6a 00                	push   $0x0
80107d02:	68 d2 00 00 00       	push   $0xd2
80107d07:	e9 31 f1 ff ff       	jmp    80106e3d <alltraps>

80107d0c <vector211>:
80107d0c:	6a 00                	push   $0x0
80107d0e:	68 d3 00 00 00       	push   $0xd3
80107d13:	e9 25 f1 ff ff       	jmp    80106e3d <alltraps>

80107d18 <vector212>:
80107d18:	6a 00                	push   $0x0
80107d1a:	68 d4 00 00 00       	push   $0xd4
80107d1f:	e9 19 f1 ff ff       	jmp    80106e3d <alltraps>

80107d24 <vector213>:
80107d24:	6a 00                	push   $0x0
80107d26:	68 d5 00 00 00       	push   $0xd5
80107d2b:	e9 0d f1 ff ff       	jmp    80106e3d <alltraps>

80107d30 <vector214>:
80107d30:	6a 00                	push   $0x0
80107d32:	68 d6 00 00 00       	push   $0xd6
80107d37:	e9 01 f1 ff ff       	jmp    80106e3d <alltraps>

80107d3c <vector215>:
80107d3c:	6a 00                	push   $0x0
80107d3e:	68 d7 00 00 00       	push   $0xd7
80107d43:	e9 f5 f0 ff ff       	jmp    80106e3d <alltraps>

80107d48 <vector216>:
80107d48:	6a 00                	push   $0x0
80107d4a:	68 d8 00 00 00       	push   $0xd8
80107d4f:	e9 e9 f0 ff ff       	jmp    80106e3d <alltraps>

80107d54 <vector217>:
80107d54:	6a 00                	push   $0x0
80107d56:	68 d9 00 00 00       	push   $0xd9
80107d5b:	e9 dd f0 ff ff       	jmp    80106e3d <alltraps>

80107d60 <vector218>:
80107d60:	6a 00                	push   $0x0
80107d62:	68 da 00 00 00       	push   $0xda
80107d67:	e9 d1 f0 ff ff       	jmp    80106e3d <alltraps>

80107d6c <vector219>:
80107d6c:	6a 00                	push   $0x0
80107d6e:	68 db 00 00 00       	push   $0xdb
80107d73:	e9 c5 f0 ff ff       	jmp    80106e3d <alltraps>

80107d78 <vector220>:
80107d78:	6a 00                	push   $0x0
80107d7a:	68 dc 00 00 00       	push   $0xdc
80107d7f:	e9 b9 f0 ff ff       	jmp    80106e3d <alltraps>

80107d84 <vector221>:
80107d84:	6a 00                	push   $0x0
80107d86:	68 dd 00 00 00       	push   $0xdd
80107d8b:	e9 ad f0 ff ff       	jmp    80106e3d <alltraps>

80107d90 <vector222>:
80107d90:	6a 00                	push   $0x0
80107d92:	68 de 00 00 00       	push   $0xde
80107d97:	e9 a1 f0 ff ff       	jmp    80106e3d <alltraps>

80107d9c <vector223>:
80107d9c:	6a 00                	push   $0x0
80107d9e:	68 df 00 00 00       	push   $0xdf
80107da3:	e9 95 f0 ff ff       	jmp    80106e3d <alltraps>

80107da8 <vector224>:
80107da8:	6a 00                	push   $0x0
80107daa:	68 e0 00 00 00       	push   $0xe0
80107daf:	e9 89 f0 ff ff       	jmp    80106e3d <alltraps>

80107db4 <vector225>:
80107db4:	6a 00                	push   $0x0
80107db6:	68 e1 00 00 00       	push   $0xe1
80107dbb:	e9 7d f0 ff ff       	jmp    80106e3d <alltraps>

80107dc0 <vector226>:
80107dc0:	6a 00                	push   $0x0
80107dc2:	68 e2 00 00 00       	push   $0xe2
80107dc7:	e9 71 f0 ff ff       	jmp    80106e3d <alltraps>

80107dcc <vector227>:
80107dcc:	6a 00                	push   $0x0
80107dce:	68 e3 00 00 00       	push   $0xe3
80107dd3:	e9 65 f0 ff ff       	jmp    80106e3d <alltraps>

80107dd8 <vector228>:
80107dd8:	6a 00                	push   $0x0
80107dda:	68 e4 00 00 00       	push   $0xe4
80107ddf:	e9 59 f0 ff ff       	jmp    80106e3d <alltraps>

80107de4 <vector229>:
80107de4:	6a 00                	push   $0x0
80107de6:	68 e5 00 00 00       	push   $0xe5
80107deb:	e9 4d f0 ff ff       	jmp    80106e3d <alltraps>

80107df0 <vector230>:
80107df0:	6a 00                	push   $0x0
80107df2:	68 e6 00 00 00       	push   $0xe6
80107df7:	e9 41 f0 ff ff       	jmp    80106e3d <alltraps>

80107dfc <vector231>:
80107dfc:	6a 00                	push   $0x0
80107dfe:	68 e7 00 00 00       	push   $0xe7
80107e03:	e9 35 f0 ff ff       	jmp    80106e3d <alltraps>

80107e08 <vector232>:
80107e08:	6a 00                	push   $0x0
80107e0a:	68 e8 00 00 00       	push   $0xe8
80107e0f:	e9 29 f0 ff ff       	jmp    80106e3d <alltraps>

80107e14 <vector233>:
80107e14:	6a 00                	push   $0x0
80107e16:	68 e9 00 00 00       	push   $0xe9
80107e1b:	e9 1d f0 ff ff       	jmp    80106e3d <alltraps>

80107e20 <vector234>:
80107e20:	6a 00                	push   $0x0
80107e22:	68 ea 00 00 00       	push   $0xea
80107e27:	e9 11 f0 ff ff       	jmp    80106e3d <alltraps>

80107e2c <vector235>:
80107e2c:	6a 00                	push   $0x0
80107e2e:	68 eb 00 00 00       	push   $0xeb
80107e33:	e9 05 f0 ff ff       	jmp    80106e3d <alltraps>

80107e38 <vector236>:
80107e38:	6a 00                	push   $0x0
80107e3a:	68 ec 00 00 00       	push   $0xec
80107e3f:	e9 f9 ef ff ff       	jmp    80106e3d <alltraps>

80107e44 <vector237>:
80107e44:	6a 00                	push   $0x0
80107e46:	68 ed 00 00 00       	push   $0xed
80107e4b:	e9 ed ef ff ff       	jmp    80106e3d <alltraps>

80107e50 <vector238>:
80107e50:	6a 00                	push   $0x0
80107e52:	68 ee 00 00 00       	push   $0xee
80107e57:	e9 e1 ef ff ff       	jmp    80106e3d <alltraps>

80107e5c <vector239>:
80107e5c:	6a 00                	push   $0x0
80107e5e:	68 ef 00 00 00       	push   $0xef
80107e63:	e9 d5 ef ff ff       	jmp    80106e3d <alltraps>

80107e68 <vector240>:
80107e68:	6a 00                	push   $0x0
80107e6a:	68 f0 00 00 00       	push   $0xf0
80107e6f:	e9 c9 ef ff ff       	jmp    80106e3d <alltraps>

80107e74 <vector241>:
80107e74:	6a 00                	push   $0x0
80107e76:	68 f1 00 00 00       	push   $0xf1
80107e7b:	e9 bd ef ff ff       	jmp    80106e3d <alltraps>

80107e80 <vector242>:
80107e80:	6a 00                	push   $0x0
80107e82:	68 f2 00 00 00       	push   $0xf2
80107e87:	e9 b1 ef ff ff       	jmp    80106e3d <alltraps>

80107e8c <vector243>:
80107e8c:	6a 00                	push   $0x0
80107e8e:	68 f3 00 00 00       	push   $0xf3
80107e93:	e9 a5 ef ff ff       	jmp    80106e3d <alltraps>

80107e98 <vector244>:
80107e98:	6a 00                	push   $0x0
80107e9a:	68 f4 00 00 00       	push   $0xf4
80107e9f:	e9 99 ef ff ff       	jmp    80106e3d <alltraps>

80107ea4 <vector245>:
80107ea4:	6a 00                	push   $0x0
80107ea6:	68 f5 00 00 00       	push   $0xf5
80107eab:	e9 8d ef ff ff       	jmp    80106e3d <alltraps>

80107eb0 <vector246>:
80107eb0:	6a 00                	push   $0x0
80107eb2:	68 f6 00 00 00       	push   $0xf6
80107eb7:	e9 81 ef ff ff       	jmp    80106e3d <alltraps>

80107ebc <vector247>:
80107ebc:	6a 00                	push   $0x0
80107ebe:	68 f7 00 00 00       	push   $0xf7
80107ec3:	e9 75 ef ff ff       	jmp    80106e3d <alltraps>

80107ec8 <vector248>:
80107ec8:	6a 00                	push   $0x0
80107eca:	68 f8 00 00 00       	push   $0xf8
80107ecf:	e9 69 ef ff ff       	jmp    80106e3d <alltraps>

80107ed4 <vector249>:
80107ed4:	6a 00                	push   $0x0
80107ed6:	68 f9 00 00 00       	push   $0xf9
80107edb:	e9 5d ef ff ff       	jmp    80106e3d <alltraps>

80107ee0 <vector250>:
80107ee0:	6a 00                	push   $0x0
80107ee2:	68 fa 00 00 00       	push   $0xfa
80107ee7:	e9 51 ef ff ff       	jmp    80106e3d <alltraps>

80107eec <vector251>:
80107eec:	6a 00                	push   $0x0
80107eee:	68 fb 00 00 00       	push   $0xfb
80107ef3:	e9 45 ef ff ff       	jmp    80106e3d <alltraps>

80107ef8 <vector252>:
80107ef8:	6a 00                	push   $0x0
80107efa:	68 fc 00 00 00       	push   $0xfc
80107eff:	e9 39 ef ff ff       	jmp    80106e3d <alltraps>

80107f04 <vector253>:
80107f04:	6a 00                	push   $0x0
80107f06:	68 fd 00 00 00       	push   $0xfd
80107f0b:	e9 2d ef ff ff       	jmp    80106e3d <alltraps>

80107f10 <vector254>:
80107f10:	6a 00                	push   $0x0
80107f12:	68 fe 00 00 00       	push   $0xfe
80107f17:	e9 21 ef ff ff       	jmp    80106e3d <alltraps>

80107f1c <vector255>:
80107f1c:	6a 00                	push   $0x0
80107f1e:	68 ff 00 00 00       	push   $0xff
80107f23:	e9 15 ef ff ff       	jmp    80106e3d <alltraps>

80107f28 <lgdt>:
{
80107f28:	55                   	push   %ebp
80107f29:	89 e5                	mov    %esp,%ebp
80107f2b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f31:	48                   	dec    %eax
80107f32:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f36:	8b 45 08             	mov    0x8(%ebp),%eax
80107f39:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f40:	c1 e8 10             	shr    $0x10,%eax
80107f43:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107f47:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f4a:	0f 01 10             	lgdtl  (%eax)
}
80107f4d:	c9                   	leave  
80107f4e:	c3                   	ret    

80107f4f <ltr>:
{
80107f4f:	55                   	push   %ebp
80107f50:	89 e5                	mov    %esp,%ebp
80107f52:	83 ec 04             	sub    $0x4,%esp
80107f55:	8b 45 08             	mov    0x8(%ebp),%eax
80107f58:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107f5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f5f:	0f 00 d8             	ltr    %ax
}
80107f62:	c9                   	leave  
80107f63:	c3                   	ret    

80107f64 <loadgs>:
{
80107f64:	55                   	push   %ebp
80107f65:	89 e5                	mov    %esp,%ebp
80107f67:	83 ec 04             	sub    $0x4,%esp
80107f6a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f74:	8e e8                	mov    %eax,%gs
}
80107f76:	c9                   	leave  
80107f77:	c3                   	ret    

80107f78 <lcr3>:

static inline void
lcr3(uint val) 
{
80107f78:	55                   	push   %ebp
80107f79:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7e:	0f 22 d8             	mov    %eax,%cr3
}
80107f81:	5d                   	pop    %ebp
80107f82:	c3                   	ret    

80107f83 <v2p>:
80107f83:	55                   	push   %ebp
80107f84:	89 e5                	mov    %esp,%ebp
80107f86:	8b 45 08             	mov    0x8(%ebp),%eax
80107f89:	05 00 00 00 80       	add    $0x80000000,%eax
80107f8e:	5d                   	pop    %ebp
80107f8f:	c3                   	ret    

80107f90 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f90:	55                   	push   %ebp
80107f91:	89 e5                	mov    %esp,%ebp
80107f93:	8b 45 08             	mov    0x8(%ebp),%eax
80107f96:	05 00 00 00 80       	add    $0x80000000,%eax
80107f9b:	5d                   	pop    %ebp
80107f9c:	c3                   	ret    

80107f9d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f9d:	55                   	push   %ebp
80107f9e:	89 e5                	mov    %esp,%ebp
80107fa0:	53                   	push   %ebx
80107fa1:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107fa4:	e8 9c ae ff ff       	call   80102e45 <cpunum>
80107fa9:	89 c2                	mov    %eax,%edx
80107fab:	89 d0                	mov    %edx,%eax
80107fad:	d1 e0                	shl    %eax
80107faf:	01 d0                	add    %edx,%eax
80107fb1:	c1 e0 04             	shl    $0x4,%eax
80107fb4:	29 d0                	sub    %edx,%eax
80107fb6:	c1 e0 02             	shl    $0x2,%eax
80107fb9:	05 60 09 11 80       	add    $0x80110960,%eax
80107fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fcd:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd6:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdd:	8a 50 7d             	mov    0x7d(%eax),%dl
80107fe0:	83 e2 f0             	and    $0xfffffff0,%edx
80107fe3:	83 ca 0a             	or     $0xa,%edx
80107fe6:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fec:	8a 50 7d             	mov    0x7d(%eax),%dl
80107fef:	83 ca 10             	or     $0x10,%edx
80107ff2:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff8:	8a 50 7d             	mov    0x7d(%eax),%dl
80107ffb:	83 e2 9f             	and    $0xffffff9f,%edx
80107ffe:	88 50 7d             	mov    %dl,0x7d(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	8a 50 7d             	mov    0x7d(%eax),%dl
80108007:	83 ca 80             	or     $0xffffff80,%edx
8010800a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010800d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108010:	8a 50 7e             	mov    0x7e(%eax),%dl
80108013:	83 ca 0f             	or     $0xf,%edx
80108016:	88 50 7e             	mov    %dl,0x7e(%eax)
80108019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801c:	8a 50 7e             	mov    0x7e(%eax),%dl
8010801f:	83 e2 ef             	and    $0xffffffef,%edx
80108022:	88 50 7e             	mov    %dl,0x7e(%eax)
80108025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108028:	8a 50 7e             	mov    0x7e(%eax),%dl
8010802b:	83 e2 df             	and    $0xffffffdf,%edx
8010802e:	88 50 7e             	mov    %dl,0x7e(%eax)
80108031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108034:	8a 50 7e             	mov    0x7e(%eax),%dl
80108037:	83 ca 40             	or     $0x40,%edx
8010803a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010803d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108040:	8a 50 7e             	mov    0x7e(%eax),%dl
80108043:	83 ca 80             	or     $0xffffff80,%edx
80108046:	88 50 7e             	mov    %dl,0x7e(%eax)
80108049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108053:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010805a:	ff ff 
8010805c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108066:	00 00 
80108068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108075:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010807b:	83 e2 f0             	and    $0xfffffff0,%edx
8010807e:	83 ca 02             	or     $0x2,%edx
80108081:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808a:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108090:	83 ca 10             	or     $0x10,%edx
80108093:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108099:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010809c:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080a2:	83 e2 9f             	and    $0xffffff9f,%edx
801080a5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ae:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080b4:	83 ca 80             	or     $0xffffff80,%edx
801080b7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c0:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080c6:	83 ca 0f             	or     $0xf,%edx
801080c9:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d2:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080d8:	83 e2 ef             	and    $0xffffffef,%edx
801080db:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e4:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080ea:	83 e2 df             	and    $0xffffffdf,%edx
801080ed:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f6:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080fc:	83 ca 40             	or     $0x40,%edx
801080ff:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108108:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010810e:	83 ca 80             	or     $0xffffff80,%edx
80108111:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108124:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010812b:	ff ff 
8010812d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108130:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108137:	00 00 
80108139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010813c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108143:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108146:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010814c:	83 e2 f0             	and    $0xfffffff0,%edx
8010814f:	83 ca 0a             	or     $0xa,%edx
80108152:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815b:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108161:	83 ca 10             	or     $0x10,%edx
80108164:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010816a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816d:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108173:	83 ca 60             	or     $0x60,%edx
80108176:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010817c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817f:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108185:	83 ca 80             	or     $0xffffff80,%edx
80108188:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010818e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108191:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80108197:	83 ca 0f             	or     $0xf,%edx
8010819a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a3:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081a9:	83 e2 ef             	and    $0xffffffef,%edx
801081ac:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b5:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081bb:	83 e2 df             	and    $0xffffffdf,%edx
801081be:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c7:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081cd:	83 ca 40             	or     $0x40,%edx
801081d0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d9:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081df:	83 ca 80             	or     $0xffffff80,%edx
801081e2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081eb:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801081fc:	ff ff 
801081fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108201:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108208:	00 00 
8010820a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820d:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108217:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010821d:	83 e2 f0             	and    $0xfffffff0,%edx
80108220:	83 ca 02             	or     $0x2,%edx
80108223:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822c:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108232:	83 ca 10             	or     $0x10,%edx
80108235:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010823b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823e:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108244:	83 ca 60             	or     $0x60,%edx
80108247:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010824d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108250:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108256:	83 ca 80             	or     $0xffffff80,%edx
80108259:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010825f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108262:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108268:	83 ca 0f             	or     $0xf,%edx
8010826b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108274:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010827a:	83 e2 ef             	and    $0xffffffef,%edx
8010827d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108283:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108286:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010828c:	83 e2 df             	and    $0xffffffdf,%edx
8010828f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108298:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010829e:	83 ca 40             	or     $0x40,%edx
801082a1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082aa:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801082b0:	83 ca 80             	or     $0xffffff80,%edx
801082b3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082bc:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801082c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c6:	05 b4 00 00 00       	add    $0xb4,%eax
801082cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082ce:	81 c2 b4 00 00 00    	add    $0xb4,%edx
801082d4:	c1 ea 10             	shr    $0x10,%edx
801082d7:	88 d1                	mov    %dl,%cl
801082d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082dc:	81 c2 b4 00 00 00    	add    $0xb4,%edx
801082e2:	c1 ea 18             	shr    $0x18,%edx
801082e5:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801082e8:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
801082ef:	00 00 
801082f1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801082f4:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
801082fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082fe:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108307:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010830d:	83 e1 f0             	and    $0xfffffff0,%ecx
80108310:	83 c9 02             	or     $0x2,%ecx
80108313:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010831c:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108322:	83 c9 10             	or     $0x10,%ecx
80108325:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010832b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832e:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108334:	83 e1 9f             	and    $0xffffff9f,%ecx
80108337:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010833d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108340:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108346:	83 c9 80             	or     $0xffffff80,%ecx
80108349:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010834f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108352:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108358:	83 e1 f0             	and    $0xfffffff0,%ecx
8010835b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108364:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010836a:	83 e1 ef             	and    $0xffffffef,%ecx
8010836d:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108376:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010837c:	83 e1 df             	and    $0xffffffdf,%ecx
8010837f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108388:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010838e:	83 c9 40             	or     $0x40,%ecx
80108391:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839a:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801083a0:	83 c9 80             	or     $0xffffff80,%ecx
801083a3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083ac:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801083b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b5:	83 c0 70             	add    $0x70,%eax
801083b8:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801083bf:	00 
801083c0:	89 04 24             	mov    %eax,(%esp)
801083c3:	e8 60 fb ff ff       	call   80107f28 <lgdt>
  loadgs(SEG_KCPU << 3);
801083c8:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801083cf:	e8 90 fb ff ff       	call   80107f64 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801083d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d7:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801083dd:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801083e4:	00 00 00 00 
}
801083e8:	83 c4 24             	add    $0x24,%esp
801083eb:	5b                   	pop    %ebx
801083ec:	5d                   	pop    %ebp
801083ed:	c3                   	ret    

801083ee <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083ee:	55                   	push   %ebp
801083ef:	89 e5                	mov    %esp,%ebp
801083f1:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801083f7:	c1 e8 16             	shr    $0x16,%eax
801083fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108401:	8b 45 08             	mov    0x8(%ebp),%eax
80108404:	01 d0                	add    %edx,%eax
80108406:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108409:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010840c:	8b 00                	mov    (%eax),%eax
8010840e:	83 e0 01             	and    $0x1,%eax
80108411:	85 c0                	test   %eax,%eax
80108413:	74 17                	je     8010842c <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108415:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108418:	8b 00                	mov    (%eax),%eax
8010841a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010841f:	89 04 24             	mov    %eax,(%esp)
80108422:	e8 69 fb ff ff       	call   80107f90 <p2v>
80108427:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010842a:	eb 4b                	jmp    80108477 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0) // kalloc es 0 cuando no puede asignar la memoria.
8010842c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108430:	74 0e                	je     80108440 <walkpgdir+0x52>
80108432:	e8 87 a6 ff ff       	call   80102abe <kalloc>
80108437:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010843a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010843e:	75 07                	jne    80108447 <walkpgdir+0x59>
      return 0;
80108440:	b8 00 00 00 00       	mov    $0x0,%eax
80108445:	eb 47                	jmp    8010848e <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108447:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010844e:	00 
8010844f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108456:	00 
80108457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010845a:	89 04 24             	mov    %eax,(%esp)
8010845d:	e8 9e d3 ff ff       	call   80105800 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108465:	89 04 24             	mov    %eax,(%esp)
80108468:	e8 16 fb ff ff       	call   80107f83 <v2p>
8010846d:	89 c2                	mov    %eax,%edx
8010846f:	83 ca 07             	or     $0x7,%edx
80108472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108475:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)]; // PTX (va) me retorna un index de la tabla de pagina, que luego aplicando, &pgtab[..] me retorna su direccion. 
80108477:	8b 45 0c             	mov    0xc(%ebp),%eax
8010847a:	c1 e8 0c             	shr    $0xc,%eax
8010847d:	25 ff 03 00 00       	and    $0x3ff,%eax
80108482:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108489:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010848c:	01 d0                	add    %edx,%eax
}                         // por lo tanto , la direccion del index, de la tabla de paginas.
8010848e:	c9                   	leave  
8010848f:	c3                   	ret    

80108490 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned.
// retornaba "static int" lo cambie por int, si no me saltaba error
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108490:	55                   	push   %ebp
80108491:	89 e5                	mov    %esp,%ebp
80108493:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108496:	8b 45 0c             	mov    0xc(%ebp),%eax
80108499:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010849e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801084a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801084a4:	8b 45 10             	mov    0x10(%ebp),%eax
801084a7:	01 d0                	add    %edx,%eax
801084a9:	48                   	dec    %eax
801084aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0) // walkpgdir: create any required page table pages, osea
801084b2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801084b9:	00 
801084ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801084c1:	8b 45 08             	mov    0x8(%ebp),%eax
801084c4:	89 04 24             	mov    %eax,(%esp)
801084c7:	e8 22 ff ff ff       	call   801083ee <walkpgdir>
801084cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084d3:	75 07                	jne    801084dc <mappages+0x4c>
                                            // crea cualquier pagina requerida para la tabla de paginas.
                                            // retorna la direccion de donde fue creada en la tabla pgdir.
      return -1; // no fue posible mapear, debido a que el walkpgdir no pudo asignar la memoria o alloc no es 1
801084d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084da:	eb 46                	jmp    80108522 <mappages+0x92>
    if(*pte & PTE_P)
801084dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084df:	8b 00                	mov    (%eax),%eax
801084e1:	83 e0 01             	and    $0x1,%eax
801084e4:	85 c0                	test   %eax,%eax
801084e6:	74 0c                	je     801084f4 <mappages+0x64>
      panic("remap");
801084e8:	c7 04 24 08 94 10 80 	movl   $0x80109408,(%esp)
801084ef:	e8 42 80 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
801084f4:	8b 45 18             	mov    0x18(%ebp),%eax
801084f7:	0b 45 14             	or     0x14(%ebp),%eax
801084fa:	89 c2                	mov    %eax,%edx
801084fc:	83 ca 01             	or     $0x1,%edx
801084ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108502:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108507:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010850a:	74 10                	je     8010851c <mappages+0x8c>
      break;
    a += PGSIZE;
8010850c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108513:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010851a:	eb 96                	jmp    801084b2 <mappages+0x22>
      break;
8010851c:	90                   	nop
  return 0;
8010851d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108522:	c9                   	leave  
80108523:	c3                   	ret    

80108524 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108524:	55                   	push   %ebp
80108525:	89 e5                	mov    %esp,%ebp
80108527:	53                   	push   %ebx
80108528:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010852b:	e8 8e a5 ff ff       	call   80102abe <kalloc>
80108530:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108533:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108537:	75 0a                	jne    80108543 <setupkvm+0x1f>
    return 0;
80108539:	b8 00 00 00 00       	mov    $0x0,%eax
8010853e:	e9 98 00 00 00       	jmp    801085db <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108543:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010854a:	00 
8010854b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108552:	00 
80108553:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108556:	89 04 24             	mov    %eax,(%esp)
80108559:	e8 a2 d2 ff ff       	call   80105800 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010855e:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108565:	e8 26 fa ff ff       	call   80107f90 <p2v>
8010856a:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010856f:	76 0c                	jbe    8010857d <setupkvm+0x59>
    panic("PHYSTOP too high");
80108571:	c7 04 24 0e 94 10 80 	movl   $0x8010940e,(%esp)
80108578:	e8 b9 7f ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010857d:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
80108584:	eb 49                	jmp    801085cf <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80108586:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108589:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
8010858c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010858f:	8b 50 04             	mov    0x4(%eax),%edx
80108592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108595:	8b 58 08             	mov    0x8(%eax),%ebx
80108598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010859b:	8b 40 04             	mov    0x4(%eax),%eax
8010859e:	29 c3                	sub    %eax,%ebx
801085a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085a3:	8b 00                	mov    (%eax),%eax
801085a5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801085a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
801085ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801085b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801085b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085b8:	89 04 24             	mov    %eax,(%esp)
801085bb:	e8 d0 fe ff ff       	call   80108490 <mappages>
801085c0:	85 c0                	test   %eax,%eax
801085c2:	79 07                	jns    801085cb <setupkvm+0xa7>
      return 0;
801085c4:	b8 00 00 00 00       	mov    $0x0,%eax
801085c9:	eb 10                	jmp    801085db <setupkvm+0xb7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085cb:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801085cf:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
801085d6:	72 ae                	jb     80108586 <setupkvm+0x62>
  return pgdir;
801085d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801085db:	83 c4 34             	add    $0x34,%esp
801085de:	5b                   	pop    %ebx
801085df:	5d                   	pop    %ebp
801085e0:	c3                   	ret    

801085e1 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801085e1:	55                   	push   %ebp
801085e2:	89 e5                	mov    %esp,%ebp
801085e4:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801085e7:	e8 38 ff ff ff       	call   80108524 <setupkvm>
801085ec:	a3 b8 44 11 80       	mov    %eax,0x801144b8
  switchkvm();
801085f1:	e8 02 00 00 00       	call   801085f8 <switchkvm>
}
801085f6:	c9                   	leave  
801085f7:	c3                   	ret    

801085f8 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801085f8:	55                   	push   %ebp
801085f9:	89 e5                	mov    %esp,%ebp
801085fb:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801085fe:	a1 b8 44 11 80       	mov    0x801144b8,%eax
80108603:	89 04 24             	mov    %eax,(%esp)
80108606:	e8 78 f9 ff ff       	call   80107f83 <v2p>
8010860b:	89 04 24             	mov    %eax,(%esp)
8010860e:	e8 65 f9 ff ff       	call   80107f78 <lcr3>
}
80108613:	c9                   	leave  
80108614:	c3                   	ret    

80108615 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108615:	55                   	push   %ebp
80108616:	89 e5                	mov    %esp,%ebp
80108618:	53                   	push   %ebx
80108619:	83 ec 14             	sub    $0x14,%esp
  pushcli();
8010861c:	e8 df d0 ff ff       	call   80105700 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108621:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108627:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010862e:	83 c2 08             	add    $0x8,%edx
80108631:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80108638:	83 c1 08             	add    $0x8,%ecx
8010863b:	c1 e9 10             	shr    $0x10,%ecx
8010863e:	88 cb                	mov    %cl,%bl
80108640:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80108647:	83 c1 08             	add    $0x8,%ecx
8010864a:	c1 e9 18             	shr    $0x18,%ecx
8010864d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108654:	67 00 
80108656:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010865d:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108663:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108669:	83 e2 f0             	and    $0xfffffff0,%edx
8010866c:	83 ca 09             	or     $0x9,%edx
8010866f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108675:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010867b:	83 ca 10             	or     $0x10,%edx
8010867e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108684:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010868a:	83 e2 9f             	and    $0xffffff9f,%edx
8010868d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108693:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108699:	83 ca 80             	or     $0xffffff80,%edx
8010869c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086a2:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086a8:	83 e2 f0             	and    $0xfffffff0,%edx
801086ab:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086b1:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086b7:	83 e2 ef             	and    $0xffffffef,%edx
801086ba:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086c0:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086c6:	83 e2 df             	and    $0xffffffdf,%edx
801086c9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086cf:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086d5:	83 ca 40             	or     $0x40,%edx
801086d8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086de:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086e4:	83 e2 7f             	and    $0x7f,%edx
801086e7:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086ed:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801086f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086f9:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801086ff:	83 e2 ef             	and    $0xffffffef,%edx
80108702:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108708:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010870e:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108714:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010871a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108721:	8b 52 08             	mov    0x8(%edx),%edx
80108724:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010872a:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010872d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108734:	e8 16 f8 ff ff       	call   80107f4f <ltr>
  if(p->pgdir == 0)
80108739:	8b 45 08             	mov    0x8(%ebp),%eax
8010873c:	8b 40 04             	mov    0x4(%eax),%eax
8010873f:	85 c0                	test   %eax,%eax
80108741:	75 0c                	jne    8010874f <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80108743:	c7 04 24 1f 94 10 80 	movl   $0x8010941f,(%esp)
8010874a:	e8 e7 7d ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010874f:	8b 45 08             	mov    0x8(%ebp),%eax
80108752:	8b 40 04             	mov    0x4(%eax),%eax
80108755:	89 04 24             	mov    %eax,(%esp)
80108758:	e8 26 f8 ff ff       	call   80107f83 <v2p>
8010875d:	89 04 24             	mov    %eax,(%esp)
80108760:	e8 13 f8 ff ff       	call   80107f78 <lcr3>
  popcli();
80108765:	e8 dc cf ff ff       	call   80105746 <popcli>
}
8010876a:	83 c4 14             	add    $0x14,%esp
8010876d:	5b                   	pop    %ebx
8010876e:	5d                   	pop    %ebp
8010876f:	c3                   	ret    

80108770 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108770:	55                   	push   %ebp
80108771:	89 e5                	mov    %esp,%ebp
80108773:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80108776:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
8010877d:	76 0c                	jbe    8010878b <inituvm+0x1b>
    panic("inituvm: more than a page");
8010877f:	c7 04 24 33 94 10 80 	movl   $0x80109433,(%esp)
80108786:	e8 ab 7d ff ff       	call   80100536 <panic>
  mem = kalloc();
8010878b:	e8 2e a3 ff ff       	call   80102abe <kalloc>
80108790:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108793:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010879a:	00 
8010879b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801087a2:	00 
801087a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087a6:	89 04 24             	mov    %eax,(%esp)
801087a9:	e8 52 d0 ff ff       	call   80105800 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087b1:	89 04 24             	mov    %eax,(%esp)
801087b4:	e8 ca f7 ff ff       	call   80107f83 <v2p>
801087b9:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801087c0:	00 
801087c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
801087c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087cc:	00 
801087cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801087d4:	00 
801087d5:	8b 45 08             	mov    0x8(%ebp),%eax
801087d8:	89 04 24             	mov    %eax,(%esp)
801087db:	e8 b0 fc ff ff       	call   80108490 <mappages>
  memmove(mem, init, sz);
801087e0:	8b 45 10             	mov    0x10(%ebp),%eax
801087e3:	89 44 24 08          	mov    %eax,0x8(%esp)
801087e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801087ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801087ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087f1:	89 04 24             	mov    %eax,(%esp)
801087f4:	e8 d3 d0 ff ff       	call   801058cc <memmove>
}
801087f9:	c9                   	leave  
801087fa:	c3                   	ret    

801087fb <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801087fb:	55                   	push   %ebp
801087fc:	89 e5                	mov    %esp,%ebp
801087fe:	53                   	push   %ebx
801087ff:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108802:	8b 45 0c             	mov    0xc(%ebp),%eax
80108805:	25 ff 0f 00 00       	and    $0xfff,%eax
8010880a:	85 c0                	test   %eax,%eax
8010880c:	74 0c                	je     8010881a <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010880e:	c7 04 24 50 94 10 80 	movl   $0x80109450,(%esp)
80108815:	e8 1c 7d ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010881a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108821:	e9 ad 00 00 00       	jmp    801088d3 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108829:	8b 55 0c             	mov    0xc(%ebp),%edx
8010882c:	01 d0                	add    %edx,%eax
8010882e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108835:	00 
80108836:	89 44 24 04          	mov    %eax,0x4(%esp)
8010883a:	8b 45 08             	mov    0x8(%ebp),%eax
8010883d:	89 04 24             	mov    %eax,(%esp)
80108840:	e8 a9 fb ff ff       	call   801083ee <walkpgdir>
80108845:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108848:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010884c:	75 0c                	jne    8010885a <loaduvm+0x5f>
      panic("loaduvm: address should exist");
8010884e:	c7 04 24 73 94 10 80 	movl   $0x80109473,(%esp)
80108855:	e8 dc 7c ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
8010885a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010885d:	8b 00                	mov    (%eax),%eax
8010885f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108864:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010886a:	8b 55 18             	mov    0x18(%ebp),%edx
8010886d:	89 d1                	mov    %edx,%ecx
8010886f:	29 c1                	sub    %eax,%ecx
80108871:	89 c8                	mov    %ecx,%eax
80108873:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80108878:	77 11                	ja     8010888b <loaduvm+0x90>
      n = sz - i;
8010887a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010887d:	8b 55 18             	mov    0x18(%ebp),%edx
80108880:	89 d1                	mov    %edx,%ecx
80108882:	29 c1                	sub    %eax,%ecx
80108884:	89 c8                	mov    %ecx,%eax
80108886:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108889:	eb 07                	jmp    80108892 <loaduvm+0x97>
    else
      n = PGSIZE;
8010888b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108895:	8b 55 14             	mov    0x14(%ebp),%edx
80108898:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010889b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010889e:	89 04 24             	mov    %eax,(%esp)
801088a1:	e8 ea f6 ff ff       	call   80107f90 <p2v>
801088a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801088a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
801088ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801088b1:	89 44 24 04          	mov    %eax,0x4(%esp)
801088b5:	8b 45 10             	mov    0x10(%ebp),%eax
801088b8:	89 04 24             	mov    %eax,(%esp)
801088bb:	e8 8c 94 ff ff       	call   80101d4c <readi>
801088c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801088c3:	74 07                	je     801088cc <loaduvm+0xd1>
      return -1;
801088c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088ca:	eb 18                	jmp    801088e4 <loaduvm+0xe9>
  for(i = 0; i < sz; i += PGSIZE){
801088cc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088d6:	3b 45 18             	cmp    0x18(%ebp),%eax
801088d9:	0f 82 47 ff ff ff    	jb     80108826 <loaduvm+0x2b>
  }
  return 0;
801088df:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088e4:	83 c4 24             	add    $0x24,%esp
801088e7:	5b                   	pop    %ebx
801088e8:	5d                   	pop    %ebp
801088e9:	c3                   	ret    

801088ea <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801088ea:	55                   	push   %ebp
801088eb:	89 e5                	mov    %esp,%ebp
801088ed:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801088f0:	8b 45 10             	mov    0x10(%ebp),%eax
801088f3:	85 c0                	test   %eax,%eax
801088f5:	79 0a                	jns    80108901 <allocuvm+0x17>
    return 0;
801088f7:	b8 00 00 00 00       	mov    $0x0,%eax
801088fc:	e9 c1 00 00 00       	jmp    801089c2 <allocuvm+0xd8>
  if(newsz < oldsz)
80108901:	8b 45 10             	mov    0x10(%ebp),%eax
80108904:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108907:	73 08                	jae    80108911 <allocuvm+0x27>
    return oldsz;
80108909:	8b 45 0c             	mov    0xc(%ebp),%eax
8010890c:	e9 b1 00 00 00       	jmp    801089c2 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108911:	8b 45 0c             	mov    0xc(%ebp),%eax
80108914:	05 ff 0f 00 00       	add    $0xfff,%eax
80108919:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010891e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108921:	e9 8d 00 00 00       	jmp    801089b3 <allocuvm+0xc9>
    mem = kalloc();
80108926:	e8 93 a1 ff ff       	call   80102abe <kalloc>
8010892b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010892e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108932:	75 2c                	jne    80108960 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108934:	c7 04 24 91 94 10 80 	movl   $0x80109491,(%esp)
8010893b:	e8 61 7a ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108940:	8b 45 0c             	mov    0xc(%ebp),%eax
80108943:	89 44 24 08          	mov    %eax,0x8(%esp)
80108947:	8b 45 10             	mov    0x10(%ebp),%eax
8010894a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010894e:	8b 45 08             	mov    0x8(%ebp),%eax
80108951:	89 04 24             	mov    %eax,(%esp)
80108954:	e8 6b 00 00 00       	call   801089c4 <deallocuvm>
      return 0;
80108959:	b8 00 00 00 00       	mov    $0x0,%eax
8010895e:	eb 62                	jmp    801089c2 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108960:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108967:	00 
80108968:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010896f:	00 
80108970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108973:	89 04 24             	mov    %eax,(%esp)
80108976:	e8 85 ce ff ff       	call   80105800 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010897b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010897e:	89 04 24             	mov    %eax,(%esp)
80108981:	e8 fd f5 ff ff       	call   80107f83 <v2p>
80108986:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108989:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108990:	00 
80108991:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108995:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010899c:	00 
8010899d:	89 54 24 04          	mov    %edx,0x4(%esp)
801089a1:	8b 45 08             	mov    0x8(%ebp),%eax
801089a4:	89 04 24             	mov    %eax,(%esp)
801089a7:	e8 e4 fa ff ff       	call   80108490 <mappages>
  for(; a < newsz; a += PGSIZE){
801089ac:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089b6:	3b 45 10             	cmp    0x10(%ebp),%eax
801089b9:	0f 82 67 ff ff ff    	jb     80108926 <allocuvm+0x3c>
  }
  return newsz;
801089bf:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089c2:	c9                   	leave  
801089c3:	c3                   	ret    

801089c4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801089c4:	55                   	push   %ebp
801089c5:	89 e5                	mov    %esp,%ebp
801089c7:	83 ec 38             	sub    $0x38,%esp
  pte_t *pte;
  uint a, pa;
  int save_this = 1; // New: Add in project final 
801089ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  if(newsz >= oldsz)
801089d1:	8b 45 10             	mov    0x10(%ebp),%eax
801089d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089d7:	72 08                	jb     801089e1 <deallocuvm+0x1d>
    return oldsz;
801089d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801089dc:	e9 b8 00 00 00       	jmp    80108a99 <deallocuvm+0xd5>

  //pte_s
  a = PGROUNDUP(newsz);
801089e1:	8b 45 10             	mov    0x10(%ebp),%eax
801089e4:	05 ff 0f 00 00       	add    $0xfff,%eax
801089e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801089f1:	e9 94 00 00 00       	jmp    80108a8a <deallocuvm+0xc6>
    pte = walkpgdir(pgdir, (char*)a, 0);
801089f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a00:	00 
80108a01:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a05:	8b 45 08             	mov    0x8(%ebp),%eax
80108a08:	89 04 24             	mov    %eax,(%esp)
80108a0b:	e8 de f9 ff ff       	call   801083ee <walkpgdir>
80108a10:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(!pte)
80108a13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a17:	75 09                	jne    80108a22 <deallocuvm+0x5e>
      a += (NPTENTRIES - 1) * PGSIZE;
80108a19:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a20:	eb 61                	jmp    80108a83 <deallocuvm+0xbf>
    else if((*pte & PTE_P) != 0){
80108a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a25:	8b 00                	mov    (%eax),%eax
80108a27:	83 e0 01             	and    $0x1,%eax
80108a2a:	85 c0                	test   %eax,%eax
80108a2c:	74 55                	je     80108a83 <deallocuvm+0xbf>
      pa = PTE_ADDR(*pte);
80108a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a31:	8b 00                	mov    (%eax),%eax
80108a33:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a38:	89 45 e8             	mov    %eax,-0x18(%ebp)
      save_this = is_shared(pa); //New: Add in project final
80108a3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a3e:	89 04 24             	mov    %eax,(%esp)
80108a41:	e8 a4 03 00 00       	call   80108dea <is_shared>
80108a46:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80108a49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a4d:	75 0c                	jne    80108a5b <deallocuvm+0x97>
        panic("kfree");
80108a4f:	c7 04 24 a9 94 10 80 	movl   $0x801094a9,(%esp)
80108a56:	e8 db 7a ff ff       	call   80100536 <panic>
      // char *v = p2v(pa);
      // kfree(v);
      // *pte = 0;
      if (!save_this){ // New: Add in project final, ahi uno solo, le aplico el kfree
80108a5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a5f:	75 22                	jne    80108a83 <deallocuvm+0xbf>
        char *v = p2v(pa);
80108a61:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a64:	89 04 24             	mov    %eax,(%esp)
80108a67:	e8 24 f5 ff ff       	call   80107f90 <p2v>
80108a6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(v);
80108a6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a72:	89 04 24             	mov    %eax,(%esp)
80108a75:	e8 ab 9f ff ff       	call   80102a25 <kfree>
        *pte = 0;
80108a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108a83:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a90:	0f 82 60 ff ff ff    	jb     801089f6 <deallocuvm+0x32>
      }
    }
  }
  return newsz;
80108a96:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a99:	c9                   	leave  
80108a9a:	c3                   	ret    

80108a9b <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108a9b:	55                   	push   %ebp
80108a9c:	89 e5                	mov    %esp,%ebp
80108a9e:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108aa5:	75 0c                	jne    80108ab3 <freevm+0x18>
    panic("freevm: no pgdir");
80108aa7:	c7 04 24 af 94 10 80 	movl   $0x801094af,(%esp)
80108aae:	e8 83 7a ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108ab3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108aba:	00 
80108abb:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108ac2:	80 
80108ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80108ac6:	89 04 24             	mov    %eax,(%esp)
80108ac9:	e8 f6 fe ff ff       	call   801089c4 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108ace:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ad5:	eb 47                	jmp    80108b1e <freevm+0x83>
    if(pgdir[i] & PTE_P){
80108ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ada:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae4:	01 d0                	add    %edx,%eax
80108ae6:	8b 00                	mov    (%eax),%eax
80108ae8:	83 e0 01             	and    $0x1,%eax
80108aeb:	85 c0                	test   %eax,%eax
80108aed:	74 2c                	je     80108b1b <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108af9:	8b 45 08             	mov    0x8(%ebp),%eax
80108afc:	01 d0                	add    %edx,%eax
80108afe:	8b 00                	mov    (%eax),%eax
80108b00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b05:	89 04 24             	mov    %eax,(%esp)
80108b08:	e8 83 f4 ff ff       	call   80107f90 <p2v>
80108b0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b13:	89 04 24             	mov    %eax,(%esp)
80108b16:	e8 0a 9f ff ff       	call   80102a25 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108b1b:	ff 45 f4             	incl   -0xc(%ebp)
80108b1e:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b25:	76 b0                	jbe    80108ad7 <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80108b27:	8b 45 08             	mov    0x8(%ebp),%eax
80108b2a:	89 04 24             	mov    %eax,(%esp)
80108b2d:	e8 f3 9e ff ff       	call   80102a25 <kfree>
}
80108b32:	c9                   	leave  
80108b33:	c3                   	ret    

80108b34 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b34:	55                   	push   %ebp
80108b35:	89 e5                	mov    %esp,%ebp
80108b37:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b41:	00 
80108b42:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b45:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b49:	8b 45 08             	mov    0x8(%ebp),%eax
80108b4c:	89 04 24             	mov    %eax,(%esp)
80108b4f:	e8 9a f8 ff ff       	call   801083ee <walkpgdir>
80108b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b5b:	75 0c                	jne    80108b69 <clearpteu+0x35>
    panic("clearpteu");
80108b5d:	c7 04 24 c0 94 10 80 	movl   $0x801094c0,(%esp)
80108b64:	e8 cd 79 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b6c:	8b 00                	mov    (%eax),%eax
80108b6e:	89 c2                	mov    %eax,%edx
80108b70:	83 e2 fb             	and    $0xfffffffb,%edx
80108b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b76:	89 10                	mov    %edx,(%eax)
}
80108b78:	c9                   	leave  
80108b79:	c3                   	ret    

80108b7a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b7a:	55                   	push   %ebp
80108b7b:	89 e5                	mov    %esp,%ebp
80108b7d:	53                   	push   %ebx
80108b7e:	83 ec 44             	sub    $0x44,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  int only_map; // New: Add in project final

  if((d = setupkvm()) == 0)
80108b81:	e8 9e f9 ff ff       	call   80108524 <setupkvm>
80108b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b8d:	75 0a                	jne    80108b99 <copyuvm+0x1f>
    return 0;
80108b8f:	b8 00 00 00 00       	mov    $0x0,%eax
80108b94:	e9 43 01 00 00       	jmp    80108cdc <copyuvm+0x162>
  for(i = 0; i < sz; i += PGSIZE){
80108b99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108ba0:	e9 12 01 00 00       	jmp    80108cb7 <copyuvm+0x13d>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108baf:	00 
80108bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
80108bb4:	8b 45 08             	mov    0x8(%ebp),%eax
80108bb7:	89 04 24             	mov    %eax,(%esp)
80108bba:	e8 2f f8 ff ff       	call   801083ee <walkpgdir>
80108bbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bc2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bc6:	75 0c                	jne    80108bd4 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108bc8:	c7 04 24 ca 94 10 80 	movl   $0x801094ca,(%esp)
80108bcf:	e8 62 79 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
80108bd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bd7:	8b 00                	mov    (%eax),%eax
80108bd9:	83 e0 01             	and    $0x1,%eax
80108bdc:	85 c0                	test   %eax,%eax
80108bde:	75 0c                	jne    80108bec <copyuvm+0x72>
      panic("copyuvm: page not present");
80108be0:	c7 04 24 e4 94 10 80 	movl   $0x801094e4,(%esp)
80108be7:	e8 4a 79 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bef:	8b 00                	mov    (%eax),%eax
80108bf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bf6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108bf9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bfc:	8b 00                	mov    (%eax),%eax
80108bfe:	25 ff 0f 00 00       	and    $0xfff,%eax
80108c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    only_map = is_shared(pa); // New: Add in project final
80108c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c09:	89 04 24             	mov    %eax,(%esp)
80108c0c:	e8 d9 01 00 00       	call   80108dea <is_shared>
80108c11:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!only_map) { 
80108c14:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108c18:	75 6a                	jne    80108c84 <copyuvm+0x10a>
      if((mem = kalloc()) == 0) // el kalloc no pudo asignar la memoria
80108c1a:	e8 9f 9e ff ff       	call   80102abe <kalloc>
80108c1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80108c26:	0f 84 9c 00 00 00    	je     80108cc8 <copyuvm+0x14e>
        goto bad;
      memmove(mem, (char*)p2v(pa), PGSIZE);
80108c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c2f:	89 04 24             	mov    %eax,(%esp)
80108c32:	e8 59 f3 ff ff       	call   80107f90 <p2v>
80108c37:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c3e:	00 
80108c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c43:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c46:	89 04 24             	mov    %eax,(%esp)
80108c49:	e8 7e cc ff ff       	call   801058cc <memmove>
      if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c4e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c54:	89 04 24             	mov    %eax,(%esp)
80108c57:	e8 27 f3 ff ff       	call   80107f83 <v2p>
80108c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108c5f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c67:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c6e:	00 
80108c6f:	89 54 24 04          	mov    %edx,0x4(%esp)
80108c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c76:	89 04 24             	mov    %eax,(%esp)
80108c79:	e8 12 f8 ff ff       	call   80108490 <mappages>
80108c7e:	85 c0                	test   %eax,%eax
80108c80:	79 2e                	jns    80108cb0 <copyuvm+0x136>
        goto bad;
80108c82:	eb 48                	jmp    80108ccc <copyuvm+0x152>
    } else {
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80108c84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8a:	89 54 24 10          	mov    %edx,0x10(%esp)
80108c8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108c91:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108c95:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c9c:	00 
80108c9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ca4:	89 04 24             	mov    %eax,(%esp)
80108ca7:	e8 e4 f7 ff ff       	call   80108490 <mappages>
80108cac:	85 c0                	test   %eax,%eax
80108cae:	78 1b                	js     80108ccb <copyuvm+0x151>
  for(i = 0; i < sz; i += PGSIZE){
80108cb0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cba:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108cbd:	0f 82 e2 fe ff ff    	jb     80108ba5 <copyuvm+0x2b>
        goto bad;
     }
  }
  return d;
80108cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cc6:	eb 14                	jmp    80108cdc <copyuvm+0x162>
        goto bad;
80108cc8:	90                   	nop
80108cc9:	eb 01                	jmp    80108ccc <copyuvm+0x152>
        goto bad;
80108ccb:	90                   	nop

bad:
  freevm(d);
80108ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ccf:	89 04 24             	mov    %eax,(%esp)
80108cd2:	e8 c4 fd ff ff       	call   80108a9b <freevm>
  return 0;
80108cd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cdc:	83 c4 44             	add    $0x44,%esp
80108cdf:	5b                   	pop    %ebx
80108ce0:	5d                   	pop    %ebp
80108ce1:	c3                   	ret    

80108ce2 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108ce2:	55                   	push   %ebp
80108ce3:	89 e5                	mov    %esp,%ebp
80108ce5:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ce8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108cef:	00 
80108cf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cf7:	8b 45 08             	mov    0x8(%ebp),%eax
80108cfa:	89 04 24             	mov    %eax,(%esp)
80108cfd:	e8 ec f6 ff ff       	call   801083ee <walkpgdir>
80108d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d08:	8b 00                	mov    (%eax),%eax
80108d0a:	83 e0 01             	and    $0x1,%eax
80108d0d:	85 c0                	test   %eax,%eax
80108d0f:	75 07                	jne    80108d18 <uva2ka+0x36>
    return 0;
80108d11:	b8 00 00 00 00       	mov    $0x0,%eax
80108d16:	eb 25                	jmp    80108d3d <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d1b:	8b 00                	mov    (%eax),%eax
80108d1d:	83 e0 04             	and    $0x4,%eax
80108d20:	85 c0                	test   %eax,%eax
80108d22:	75 07                	jne    80108d2b <uva2ka+0x49>
    return 0;
80108d24:	b8 00 00 00 00       	mov    $0x0,%eax
80108d29:	eb 12                	jmp    80108d3d <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2e:	8b 00                	mov    (%eax),%eax
80108d30:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d35:	89 04 24             	mov    %eax,(%esp)
80108d38:	e8 53 f2 ff ff       	call   80107f90 <p2v>
}
80108d3d:	c9                   	leave  
80108d3e:	c3                   	ret    

80108d3f <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d3f:	55                   	push   %ebp
80108d40:	89 e5                	mov    %esp,%ebp
80108d42:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d45:	8b 45 10             	mov    0x10(%ebp),%eax
80108d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d4b:	e9 89 00 00 00       	jmp    80108dd9 <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108d50:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d58:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d62:	8b 45 08             	mov    0x8(%ebp),%eax
80108d65:	89 04 24             	mov    %eax,(%esp)
80108d68:	e8 75 ff ff ff       	call   80108ce2 <uva2ka>
80108d6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d74:	75 07                	jne    80108d7d <copyout+0x3e>
      return -1;
80108d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d7b:	eb 6b                	jmp    80108de8 <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d80:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108d83:	89 d1                	mov    %edx,%ecx
80108d85:	29 c1                	sub    %eax,%ecx
80108d87:	89 c8                	mov    %ecx,%eax
80108d89:	05 00 10 00 00       	add    $0x1000,%eax
80108d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d94:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d97:	76 06                	jbe    80108d9f <copyout+0x60>
      n = len;
80108d99:	8b 45 14             	mov    0x14(%ebp),%eax
80108d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108da2:	8b 55 0c             	mov    0xc(%ebp),%edx
80108da5:	29 c2                	sub    %eax,%edx
80108da7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108daa:	01 c2                	add    %eax,%edx
80108dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108daf:	89 44 24 08          	mov    %eax,0x8(%esp)
80108db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db6:	89 44 24 04          	mov    %eax,0x4(%esp)
80108dba:	89 14 24             	mov    %edx,(%esp)
80108dbd:	e8 0a cb ff ff       	call   801058cc <memmove>
    len -= n;
80108dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dc5:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dcb:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dd1:	05 00 10 00 00       	add    $0x1000,%eax
80108dd6:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108dd9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108ddd:	0f 85 6d ff ff ff    	jne    80108d50 <copyout+0x11>
  }
  return 0;
80108de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108de8:	c9                   	leave  
80108de9:	c3                   	ret    

80108dea <is_shared>:
// struct sharedmemory* get_shm_table(){
//   return shmtable.sharedmemory; // obtengo array sharedmemory de tipo sharedmemory
// }

int
is_shared(uint pa){
80108dea:	55                   	push   %ebp
80108deb:	89 e5                	mov    %esp,%ebp
80108ded:	83 ec 28             	sub    $0x28,%esp
  int j;
  struct sharedmemory* shared_array = get_shm_table(); 
80108df0:	e8 53 c6 ff ff       	call   80105448 <get_shm_table>
80108df5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int shared = 0;
80108df8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108dff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e06:	eb 42                	jmp    80108e4a <is_shared+0x60>
    if (p2v(pa) == shared_array[j].addr && shared_array[j].refcount > 0){ // refcount tiene a 2 entonces 
80108e08:	8b 45 08             	mov    0x8(%ebp),%eax
80108e0b:	89 04 24             	mov    %eax,(%esp)
80108e0e:	e8 7d f1 ff ff       	call   80107f90 <p2v>
80108e13:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108e16:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80108e1d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108e20:	01 ca                	add    %ecx,%edx
80108e22:	8b 12                	mov    (%edx),%edx
80108e24:	39 d0                	cmp    %edx,%eax
80108e26:	75 1f                	jne    80108e47 <is_shared+0x5d>
80108e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e2b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108e32:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e35:	01 d0                	add    %edx,%eax
80108e37:	8b 40 04             	mov    0x4(%eax),%eax
80108e3a:	85 c0                	test   %eax,%eax
80108e3c:	7e 09                	jle    80108e47 <is_shared+0x5d>
      shared = j+1;
80108e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e41:	40                   	inc    %eax
80108e42:	89 45 f0             	mov    %eax,-0x10(%ebp)
      break;
80108e45:	eb 09                	jmp    80108e50 <is_shared+0x66>
  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108e47:	ff 45 f4             	incl   -0xc(%ebp)
80108e4a:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80108e4e:	7e b8                	jle    80108e08 <is_shared+0x1e>
    }
  }
  return shared; // ahi uno solo
80108e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108e53:	c9                   	leave  
80108e54:	c3                   	ret    
