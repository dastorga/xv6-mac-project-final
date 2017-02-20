
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
8010003a:	c7 44 24 04 3c 8e 10 	movl   $0x80108e3c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100049:	e8 24 55 00 00       	call   80105572 <initlock>

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
801000bd:	e8 d1 54 00 00       	call   80105593 <acquire>

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
80100104:	e8 ec 54 00 00       	call   801055f5 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 a0 d6 10 	movl   $0x8010d6a0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 a7 49 00 00       	call   80104acb <sleep>
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
8010017c:	e8 74 54 00 00       	call   801055f5 <release>
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
80100198:	c7 04 24 43 8e 10 80 	movl   $0x80108e43,(%esp)
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
801001ef:	c7 04 24 54 8e 10 80 	movl   $0x80108e54,(%esp)
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
80100229:	c7 04 24 5b 8e 10 80 	movl   $0x80108e5b,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010023c:	e8 52 53 00 00       	call   80105593 <acquire>

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
8010029d:	e8 31 49 00 00       	call   80104bd3 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801002a9:	e8 47 53 00 00       	call   801055f5 <release>
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
801003bc:	e8 d2 51 00 00       	call   80105593 <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 62 8e 10 80 	movl   $0x80108e62,(%esp)
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
801004ad:	c7 45 ec 6b 8e 10 80 	movl   $0x80108e6b,-0x14(%ebp)
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
8010052f:	e8 c1 50 00 00       	call   801055f5 <release>
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
8010055a:	c7 04 24 72 8e 10 80 	movl   $0x80108e72,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 81 8e 10 80 	movl   $0x80108e81,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 b5 50 00 00       	call   80105644 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 83 8e 10 80 	movl   $0x80108e83,(%esp)
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
80100695:	e8 17 52 00 00       	call   801058b1 <memmove>
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
801006c4:	e8 1c 51 00 00       	call   801057e5 <memset>
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
80100759:	e8 87 6c 00 00       	call   801073e5 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 7b 6c 00 00       	call   801073e5 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 6f 6c 00 00       	call   801073e5 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 62 6c 00 00       	call   801073e5 <uartputc>
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
8010079d:	e8 f1 4d 00 00       	call   80105593 <acquire>
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
801007ca:	e8 b3 44 00 00       	call   80104c82 <procdump>
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
801008ce:	e8 00 43 00 00       	call   80104bd3 <wakeup>
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
801008f5:	e8 fb 4c 00 00       	call   801055f5 <release>
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
8010091a:	e8 74 4c 00 00       	call   80105593 <acquire>
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
80100938:	e8 b8 4c 00 00       	call   801055f5 <release>
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
80100961:	e8 65 41 00 00       	call   80104acb <sleep>
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
801009d8:	e8 18 4c 00 00       	call   801055f5 <release>
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
80100a0e:	e8 80 4b 00 00       	call   80105593 <acquire>
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
80100a48:	e8 a8 4b 00 00       	call   801055f5 <release>
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
80100a63:	c7 44 24 04 87 8e 10 	movl   $0x80108e87,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100a72:	e8 fb 4a 00 00       	call   80105572 <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 8f 8e 10 	movl   $0x80108e8f,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
80100a86:	e8 e7 4a 00 00       	call   80105572 <initlock>

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
80100b43:	e8 c1 79 00 00       	call   80108509 <setupkvm>
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
80100bdc:	e8 ee 7c 00 00       	call   801088cf <allocuvm>
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
80100c19:	e8 c2 7b 00 00       	call   801087e0 <loaduvm>
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
80100c82:	e8 48 7c 00 00       	call   801088cf <allocuvm>
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
80100ca6:	e8 6e 7e 00 00       	call   80108b19 <clearpteu>
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
80100cdb:	e8 60 4d 00 00       	call   80105a40 <strlen>
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
80100d03:	e8 38 4d 00 00       	call   80105a40 <strlen>
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
80100d31:	e8 ee 7f 00 00       	call   80108d24 <copyout>
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
80100dd4:	e8 4b 7f 00 00       	call   80108d24 <copyout>
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
80100e26:	e8 cc 4b 00 00       	call   801059f7 <safestrcpy>

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
80100e78:	e8 7d 77 00 00       	call   801085fa <switchuvm>
  freevm(oldpgdir);
80100e7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e80:	89 04 24             	mov    %eax,(%esp)
80100e83:	e8 f8 7b 00 00       	call   80108a80 <freevm>
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
80100eba:	e8 c1 7b 00 00       	call   80108a80 <freevm>
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
80100edd:	c7 44 24 04 95 8e 10 	movl   $0x80108e95,0x4(%esp)
80100ee4:	80 
80100ee5:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100eec:	e8 81 46 00 00       	call   80105572 <initlock>
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
80100f00:	e8 8e 46 00 00       	call   80105593 <acquire>
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
80100f29:	e8 c7 46 00 00       	call   801055f5 <release>
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
80100f47:	e8 a9 46 00 00       	call   801055f5 <release>
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
80100f60:	e8 2e 46 00 00       	call   80105593 <acquire>
  if(f->ref < 1)
80100f65:	8b 45 08             	mov    0x8(%ebp),%eax
80100f68:	8b 40 04             	mov    0x4(%eax),%eax
80100f6b:	85 c0                	test   %eax,%eax
80100f6d:	7f 0c                	jg     80100f7b <filedup+0x28>
    panic("filedup");
80100f6f:	c7 04 24 9c 8e 10 80 	movl   $0x80108e9c,(%esp)
80100f76:	e8 bb f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	8d 50 01             	lea    0x1(%eax),%edx
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100f8a:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f91:	e8 5f 46 00 00       	call   801055f5 <release>
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
80100fab:	e8 e3 45 00 00       	call   80105593 <acquire>
  if(f->ref < 1)
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	7f 0c                	jg     80100fc6 <fileclose+0x2b>
    panic("fileclose");
80100fba:	c7 04 24 a4 8e 10 80 	movl   $0x80108ea4,(%esp)
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
80100fe6:	e8 0a 46 00 00       	call   801055f5 <release>
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
8010101c:	e8 d4 45 00 00       	call   801055f5 <release>
  
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
80101161:	c7 04 24 ae 8e 10 80 	movl   $0x80108eae,(%esp)
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
8010126c:	c7 04 24 b7 8e 10 80 	movl   $0x80108eb7,(%esp)
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
801012a1:	c7 04 24 c7 8e 10 80 	movl   $0x80108ec7,(%esp)
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
801012e7:	e8 c5 45 00 00       	call   801058b1 <memmove>
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
8010132d:	e8 b3 44 00 00       	call   801057e5 <memset>
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
80101495:	c7 04 24 d1 8e 10 80 	movl   $0x80108ed1,(%esp)
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
80101538:	c7 04 24 e7 8e 10 80 	movl   $0x80108ee7,(%esp)
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
8010158d:	c7 44 24 04 fa 8e 10 	movl   $0x80108efa,0x4(%esp)
80101594:	80 
80101595:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010159c:	e8 d1 3f 00 00       	call   80105572 <initlock>
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
80101626:	e8 ba 41 00 00       	call   801057e5 <memset>
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
8010167d:	c7 04 24 01 8f 10 80 	movl   $0x80108f01,(%esp)
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
80101724:	e8 88 41 00 00       	call   801058b1 <memmove>
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
8010174e:	e8 40 3e 00 00       	call   80105593 <acquire>

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
80101798:	e8 58 3e 00 00       	call   801055f5 <release>
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
801017cb:	c7 04 24 13 8f 10 80 	movl   $0x80108f13,(%esp)
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
80101809:	e8 e7 3d 00 00       	call   801055f5 <release>

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
80101820:	e8 6e 3d 00 00       	call   80105593 <acquire>
  ip->ref++;
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 08             	mov    0x8(%eax),%eax
8010182b:	8d 50 01             	lea    0x1(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101834:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010183b:	e8 b5 3d 00 00       	call   801055f5 <release>
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
8010185b:	c7 04 24 23 8f 10 80 	movl   $0x80108f23,(%esp)
80101862:	e8 cf ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101867:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010186e:	e8 20 3d 00 00       	call   80105593 <acquire>
  while(ip->flags & I_BUSY)
80101873:	eb 13                	jmp    80101888 <ilock+0x43>
    sleep(ip, &icache.lock);
80101875:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
8010187c:	80 
8010187d:	8b 45 08             	mov    0x8(%ebp),%eax
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 43 32 00 00       	call   80104acb <sleep>
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
801018ad:	e8 43 3d 00 00       	call   801055f5 <release>

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
80101956:	e8 56 3f 00 00       	call   801058b1 <memmove>
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
80101982:	c7 04 24 29 8f 10 80 	movl   $0x80108f29,(%esp)
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
801019b3:	c7 04 24 38 8f 10 80 	movl   $0x80108f38,(%esp)
801019ba:	e8 77 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019bf:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019c6:	e8 c8 3b 00 00       	call   80105593 <acquire>
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
801019e2:	e8 ec 31 00 00       	call   80104bd3 <wakeup>
  release(&icache.lock);
801019e7:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019ee:	e8 02 3c 00 00       	call   801055f5 <release>
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
80101a02:	e8 8c 3b 00 00       	call   80105593 <acquire>
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
80101a40:	c7 04 24 40 8f 10 80 	movl   $0x80108f40,(%esp)
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
80101a64:	e8 8c 3b 00 00       	call   801055f5 <release>
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
80101a8f:	e8 ff 3a 00 00       	call   80105593 <acquire>
    ip->flags = 0;
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 04 24             	mov    %eax,(%esp)
80101aa4:	e8 2a 31 00 00       	call   80104bd3 <wakeup>
  }
  ip->ref--;
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 40 08             	mov    0x8(%eax),%eax
80101aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ab8:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101abf:	e8 31 3b 00 00       	call   801055f5 <release>
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
80101bdf:	c7 04 24 4a 8f 10 80 	movl   $0x80108f4a,(%esp)
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
80101e7e:	e8 2e 3a 00 00       	call   801058b1 <memmove>
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
80101fde:	e8 ce 38 00 00       	call   801058b1 <memmove>
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
8010205c:	e8 ec 38 00 00       	call   8010594d <strncmp>
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
80102075:	c7 04 24 5d 8f 10 80 	movl   $0x80108f5d,(%esp)
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
801020b3:	c7 04 24 6f 8f 10 80 	movl   $0x80108f6f,(%esp)
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
80102195:	c7 04 24 6f 8f 10 80 	movl   $0x80108f6f,(%esp)
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
801021da:	e8 be 37 00 00       	call   8010599d <strncpy>
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
8010220c:	c7 04 24 7c 8f 10 80 	movl   $0x80108f7c,(%esp)
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
8010228d:	e8 1f 36 00 00       	call   801058b1 <memmove>
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
801022a8:	e8 04 36 00 00       	call   801058b1 <memmove>
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
801024fb:	c7 44 24 04 84 8f 10 	movl   $0x80108f84,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010250a:	e8 63 30 00 00       	call   80105572 <initlock>
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
801025a4:	c7 04 24 88 8f 10 80 	movl   $0x80108f88,(%esp)
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
801026ca:	e8 c4 2e 00 00       	call   80105593 <acquire>
  if((b = idequeue) == 0){
801026cf:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026db:	75 11                	jne    801026ee <ideintr+0x31>
    release(&idelock);
801026dd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801026e4:	e8 0c 2f 00 00       	call   801055f5 <release>
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
80102757:	e8 77 24 00 00       	call   80104bd3 <wakeup>
  
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
80102779:	e8 77 2e 00 00       	call   801055f5 <release>
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
80102792:	c7 04 24 91 8f 10 80 	movl   $0x80108f91,(%esp)
80102799:	e8 98 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	8b 00                	mov    (%eax),%eax
801027a3:	83 e0 06             	and    $0x6,%eax
801027a6:	83 f8 02             	cmp    $0x2,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x37>
    panic("iderw: nothing to do");
801027ab:	c7 04 24 a5 8f 10 80 	movl   $0x80108fa5,(%esp)
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
801027ca:	c7 04 24 ba 8f 10 80 	movl   $0x80108fba,(%esp)
801027d1:	e8 60 dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027d6:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801027dd:	e8 b1 2d 00 00       	call   80105593 <acquire>

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
80102836:	e8 90 22 00 00       	call   80104acb <sleep>
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
80102852:	e8 9e 2d 00 00       	call   801055f5 <release>
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
801028dd:	c7 04 24 d8 8f 10 80 	movl   $0x80108fd8,(%esp)
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
80102996:	c7 44 24 04 0a 90 10 	movl   $0x8010900a,0x4(%esp)
8010299d:	80 
8010299e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
801029a5:	e8 c8 2b 00 00       	call   80105572 <initlock>
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
80102a52:	c7 04 24 0f 90 10 80 	movl   $0x8010900f,(%esp)
80102a59:	e8 d8 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a65:	00 
80102a66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a6d:	00 
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 6c 2d 00 00       	call   801057e5 <memset>

  if(kmem.use_lock)
80102a79:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102a7e:	85 c0                	test   %eax,%eax
80102a80:	74 0c                	je     80102a8e <kfree+0x69>
    acquire(&kmem.lock);
80102a82:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102a89:	e8 05 2b 00 00       	call   80105593 <acquire>
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
80102ab7:	e8 39 2b 00 00       	call   801055f5 <release>
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
80102ad4:	e8 ba 2a 00 00       	call   80105593 <acquire>
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
80102b01:	e8 ef 2a 00 00       	call   801055f5 <release>
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
80102e74:	c7 04 24 18 90 10 80 	movl   $0x80109018,(%esp)
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
80102fcb:	c7 44 24 04 44 90 10 	movl   $0x80109044,0x4(%esp)
80102fd2:	80 
80102fd3:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80102fda:	e8 93 25 00 00       	call   80105572 <initlock>
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
8010308e:	e8 1e 28 00 00       	call   801058b1 <memmove>
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
801031dd:	e8 b1 23 00 00       	call   80105593 <acquire>
  while (log.busy) {
801031e2:	eb 14                	jmp    801031f8 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e4:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
801031eb:	80 
801031ec:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801031f3:	e8 d3 18 00 00       	call   80104acb <sleep>
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
80103212:	e8 de 23 00 00       	call   801055f5 <release>
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
80103248:	e8 46 23 00 00       	call   80105593 <acquire>
  log.busy = 0;
8010324d:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
80103254:	00 00 00 
  wakeup(&log);
80103257:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010325e:	e8 70 19 00 00       	call   80104bd3 <wakeup>
  release(&log.lock);
80103263:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010326a:	e8 86 23 00 00       	call   801055f5 <release>
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
80103291:	c7 04 24 48 90 10 80 	movl   $0x80109048,(%esp)
80103298:	e8 99 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010329d:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	75 0c                	jne    801032b2 <log_write+0x41>
    panic("write outside of trans");
801032a6:	c7 04 24 5e 90 10 80 	movl   $0x8010905e,(%esp)
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
80103335:	e8 77 25 00 00       	call   801058b1 <memmove>
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
801033d2:	e8 ef 51 00 00       	call   801085c6 <kvmalloc>
  mpinit();        // collect info about this machine
801033d7:	e8 93 04 00 00       	call   8010386f <mpinit>
  lapicinit();
801033dc:	e8 07 f9 ff ff       	call   80102ce8 <lapicinit>
  seginit();       // set up segments
801033e1:	e8 9c 4b 00 00       	call   80107f82 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033ec:	8a 00                	mov    (%eax),%al
801033ee:	0f b6 c0             	movzbl %al,%eax
801033f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f5:	c7 04 24 75 90 10 80 	movl   $0x80109075,(%esp)
801033fc:	e8 a0 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103401:	e8 cf 06 00 00       	call   80103ad5 <picinit>
  ioapicinit();    // another interrupt controller
80103406:	e8 7f f4 ff ff       	call   8010288a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010340b:	e8 4d d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103410:	e8 c2 3e 00 00       	call   801072d7 <uartinit>
  pinit();         // process table
80103415:	e8 c9 0b 00 00       	call   80103fe3 <pinit>
  tvinit();        // trap vectors
8010341a:	e8 6b 3a 00 00       	call   80106e8a <tvinit>
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
8010343c:	e8 91 39 00 00       	call   80106dd2 <timerinit>
  startothers();   // start other processors
80103441:	e8 7e 00 00 00       	call   801034c4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103446:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010344d:	8e 
8010344e:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103455:	e8 6e f5 ff ff       	call   801029c8 <kinit2>
  userinit();      // first user process
8010345a:	e8 70 0e 00 00       	call   801042cf <userinit>
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
8010346a:	e8 6e 51 00 00       	call   801085dd <switchkvm>
  seginit();
8010346f:	e8 0e 4b 00 00       	call   80107f82 <seginit>
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
80103493:	c7 04 24 8c 90 10 80 	movl   $0x8010908c,(%esp)
8010349a:	e8 02 cf ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
8010349f:	e8 43 3b 00 00       	call   80106fe7 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034aa:	05 a8 00 00 00       	add    $0xa8,%eax
801034af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034b6:	00 
801034b7:	89 04 24             	mov    %eax,(%esp)
801034ba:	e8 d1 fe ff ff       	call   80103390 <xchg>
  scheduler();     // start running processes
801034bf:	e8 0d 14 00 00       	call   801048d1 <scheduler>

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
801034f1:	e8 bb 23 00 00       	call   801058b1 <memmove>

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
801036c9:	c7 44 24 04 a0 90 10 	movl   $0x801090a0,0x4(%esp)
801036d0:	80 
801036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d4:	89 04 24             	mov    %eax,(%esp)
801036d7:	e8 80 21 00 00       	call   8010585c <memcmp>
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
80103806:	c7 44 24 04 a5 90 10 	movl   $0x801090a5,0x4(%esp)
8010380d:	80 
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	89 04 24             	mov    %eax,(%esp)
80103814:	e8 43 20 00 00       	call   8010585c <memcmp>
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
801038dc:	8b 04 85 e8 90 10 80 	mov    -0x7fef6f18(,%eax,4),%eax
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
80103913:	c7 04 24 aa 90 10 80 	movl   $0x801090aa,(%esp)
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
801039b3:	c7 04 24 c8 90 10 80 	movl   $0x801090c8,(%esp)
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
80103ca9:	c7 44 24 04 fc 90 10 	movl   $0x801090fc,0x4(%esp)
80103cb0:	80 
80103cb1:	89 04 24             	mov    %eax,(%esp)
80103cb4:	e8 b9 18 00 00       	call   80105572 <initlock>
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
80103d61:	e8 2d 18 00 00       	call   80105593 <acquire>
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
80103d84:	e8 4a 0e 00 00       	call   80104bd3 <wakeup>
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
80103da3:	e8 2b 0e 00 00       	call   80104bd3 <wakeup>
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
80103dc8:	e8 28 18 00 00       	call   801055f5 <release>
    kfree((char*)p);
80103dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd0:	89 04 24             	mov    %eax,(%esp)
80103dd3:	e8 4d ec ff ff       	call   80102a25 <kfree>
80103dd8:	eb 0b                	jmp    80103de5 <pipeclose+0x90>
  } else
    release(&p->lock);
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	89 04 24             	mov    %eax,(%esp)
80103de0:	e8 10 18 00 00       	call   801055f5 <release>
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
80103df4:	e8 9a 17 00 00       	call   80105593 <acquire>
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
80103e25:	e8 cb 17 00 00       	call   801055f5 <release>
        return -1;
80103e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2f:	e9 9d 00 00 00       	jmp    80103ed1 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e34:	8b 45 08             	mov    0x8(%ebp),%eax
80103e37:	05 34 02 00 00       	add    $0x234,%eax
80103e3c:	89 04 24             	mov    %eax,(%esp)
80103e3f:	e8 8f 0d 00 00       	call   80104bd3 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e44:	8b 45 08             	mov    0x8(%ebp),%eax
80103e47:	8b 55 08             	mov    0x8(%ebp),%edx
80103e4a:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e54:	89 14 24             	mov    %edx,(%esp)
80103e57:	e8 6f 0c 00 00       	call   80104acb <sleep>
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
80103ebe:	e8 10 0d 00 00       	call   80104bd3 <wakeup>
  release(&p->lock);
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec6:	89 04 24             	mov    %eax,(%esp)
80103ec9:	e8 27 17 00 00       	call   801055f5 <release>
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
80103ee4:	e8 aa 16 00 00       	call   80105593 <acquire>
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
80103efe:	e8 f2 16 00 00       	call   801055f5 <release>
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
80103f20:	e8 a6 0b 00 00       	call   80104acb <sleep>
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
80103faf:	e8 1f 0c 00 00       	call   80104bd3 <wakeup>
  release(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 04 24             	mov    %eax,(%esp)
80103fba:	e8 36 16 00 00       	call   801055f5 <release>
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
80103fe9:	c7 44 24 04 01 91 10 	movl   $0x80109101,0x4(%esp)
80103ff0:	80 
80103ff1:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80103ff8:	e8 75 15 00 00       	call   80105572 <initlock>
  shm_init(); // New: Add in project final: inicializo shmtable.sharedmemory[i].refcount = -1
80103ffd:	e8 e3 10 00 00       	call   801050e5 <shm_init>
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
801040d3:	c7 04 24 08 91 10 80 	movl   $0x80109108,(%esp)
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

void
makerunnable(struct proc *p, int priority) // New: Added in proyect 2
// level can be: 0, 1, -1
{
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	83 ec 18             	sub    $0x18,%esp
  if (priority==1 && p->priority<SIZEMLF-1)
8010415a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
8010415e:	75 23                	jne    80104183 <makerunnable+0x2f>
80104160:	8b 45 08             	mov    0x8(%ebp),%eax
80104163:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104169:	83 f8 02             	cmp    $0x2,%eax
8010416c:	7f 15                	jg     80104183 <makerunnable+0x2f>
  {
    p->priority++;
8010416e:	8b 45 08             	mov    0x8(%ebp),%eax
80104171:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104177:	8d 50 01             	lea    0x1(%eax),%edx
8010417a:	8b 45 08             	mov    0x8(%ebp),%eax
8010417d:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  if (priority==-1 && p->priority>0)
80104183:	83 7d 0c ff          	cmpl   $0xffffffff,0xc(%ebp)
80104187:	75 22                	jne    801041ab <makerunnable+0x57>
80104189:	8b 45 08             	mov    0x8(%ebp),%eax
8010418c:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104192:	85 c0                	test   %eax,%eax
80104194:	7e 15                	jle    801041ab <makerunnable+0x57>
  {
    p->priority--;
80104196:	8b 45 08             	mov    0x8(%ebp),%eax
80104199:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010419f:	8d 50 ff             	lea    -0x1(%eax),%edx
801041a2:	8b 45 08             	mov    0x8(%ebp),%eax
801041a5:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  p->state = RUNNABLE;
801041ab:	8b 45 08             	mov    0x8(%ebp),%eax
801041ae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(p);
801041b5:	8b 45 08             	mov    0x8(%ebp),%eax
801041b8:	89 04 24             	mov    %eax,(%esp)
801041bb:	e8 44 fe ff ff       	call   80104004 <enqueue>
}
801041c0:	c9                   	leave  
801041c1:	c3                   	ret    

801041c2 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801041c2:	55                   	push   %ebp
801041c3:	89 e5                	mov    %esp,%ebp
801041c5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801041c8:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801041cf:	e8 bf 13 00 00       	call   80105593 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d4:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801041db:	eb 11                	jmp    801041ee <allocproc+0x2c>
    if(p->state == UNUSED)
801041dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e0:	8b 40 0c             	mov    0xc(%eax),%eax
801041e3:	85 c0                	test   %eax,%eax
801041e5:	74 26                	je     8010420d <allocproc+0x4b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e7:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
801041ee:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
801041f5:	72 e6                	jb     801041dd <allocproc+0x1b>
      goto found;
  release(&ptable.lock);
801041f7:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801041fe:	e8 f2 13 00 00       	call   801055f5 <release>
  return 0;
80104203:	b8 00 00 00 00       	mov    $0x0,%eax
80104208:	e9 c0 00 00 00       	jmp    801042cd <allocproc+0x10b>
      goto found;
8010420d:	90                   	nop

found:
  p->state = EMBRYO;
8010420e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104211:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104218:	a1 04 c0 10 80       	mov    0x8010c004,%eax
8010421d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104220:	89 42 10             	mov    %eax,0x10(%edx)
80104223:	40                   	inc    %eax
80104224:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
80104229:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104230:	e8 c0 13 00 00       	call   801055f5 <release>

  p->priority=0; // New: Added in proyect 2: set priority in zero 
80104235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104238:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010423f:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104242:	e8 77 e8 ff ff       	call   80102abe <kalloc>
80104247:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010424a:	89 42 08             	mov    %eax,0x8(%edx)
8010424d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104250:	8b 40 08             	mov    0x8(%eax),%eax
80104253:	85 c0                	test   %eax,%eax
80104255:	75 11                	jne    80104268 <allocproc+0xa6>
    p->state = UNUSED;
80104257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104261:	b8 00 00 00 00       	mov    $0x0,%eax
80104266:	eb 65                	jmp    801042cd <allocproc+0x10b>
  }
  sp = p->kstack + KSTACKSIZE;
80104268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010426b:	8b 40 08             	mov    0x8(%eax),%eax
8010426e:	05 00 10 00 00       	add    $0x1000,%eax
80104273:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104276:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
8010427a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104280:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104283:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104287:	ba 42 6e 10 80       	mov    $0x80106e42,%edx
8010428c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010428f:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104291:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104295:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104298:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010429b:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010429e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042a1:	8b 40 1c             	mov    0x1c(%eax),%eax
801042a4:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801042ab:	00 
801042ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042b3:	00 
801042b4:	89 04 24             	mov    %eax,(%esp)
801042b7:	e8 29 15 00 00       	call   801057e5 <memset>
  p->context->eip = (uint)forkret;
801042bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801042c2:	ba 9f 4a 10 80       	mov    $0x80104a9f,%edx
801042c7:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801042ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042cd:	c9                   	leave  
801042ce:	c3                   	ret    

801042cf <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801042cf:	55                   	push   %ebp
801042d0:	89 e5                	mov    %esp,%ebp
801042d2:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801042d5:	e8 e8 fe ff ff       	call   801041c2 <allocproc>
801042da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801042dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e0:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
801042e5:	e8 1f 42 00 00       	call   80108509 <setupkvm>
801042ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042ed:	89 42 04             	mov    %eax,0x4(%edx)
801042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f3:	8b 40 04             	mov    0x4(%eax),%eax
801042f6:	85 c0                	test   %eax,%eax
801042f8:	75 0c                	jne    80104306 <userinit+0x37>
    panic("userinit: out of memory?");
801042fa:	c7 04 24 17 91 10 80 	movl   $0x80109117,(%esp)
80104301:	e8 30 c2 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104306:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010430b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430e:	8b 40 04             	mov    0x4(%eax),%eax
80104311:	89 54 24 08          	mov    %edx,0x8(%esp)
80104315:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
8010431c:	80 
8010431d:	89 04 24             	mov    %eax,(%esp)
80104320:	e8 30 44 00 00       	call   80108755 <inituvm>
  p->sz = PGSIZE;
80104325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104328:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010432e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104331:	8b 40 18             	mov    0x18(%eax),%eax
80104334:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010433b:	00 
8010433c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104343:	00 
80104344:	89 04 24             	mov    %eax,(%esp)
80104347:	e8 99 14 00 00       	call   801057e5 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010434c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434f:	8b 40 18             	mov    0x18(%eax),%eax
80104352:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010435b:	8b 40 18             	mov    0x18(%eax),%eax
8010435e:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104367:	8b 50 18             	mov    0x18(%eax),%edx
8010436a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436d:	8b 40 18             	mov    0x18(%eax),%eax
80104370:	8b 40 2c             	mov    0x2c(%eax),%eax
80104373:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
80104377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437a:	8b 50 18             	mov    0x18(%eax),%edx
8010437d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104380:	8b 40 18             	mov    0x18(%eax),%eax
80104383:	8b 40 2c             	mov    0x2c(%eax),%eax
80104386:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
8010438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438d:	8b 40 18             	mov    0x18(%eax),%eax
80104390:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439a:	8b 40 18             	mov    0x18(%eax),%eax
8010439d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a7:	8b 40 18             	mov    0x18(%eax),%eax
801043aa:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801043b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043b4:	83 c0 6c             	add    $0x6c,%eax
801043b7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043be:	00 
801043bf:	c7 44 24 04 30 91 10 	movl   $0x80109130,0x4(%esp)
801043c6:	80 
801043c7:	89 04 24             	mov    %eax,(%esp)
801043ca:	e8 28 16 00 00       	call   801059f7 <safestrcpy>
  p->cwd = namei("/");
801043cf:	c7 04 24 39 91 10 80 	movl   $0x80109139,(%esp)
801043d6:	e8 04 e0 ff ff       	call   801023df <namei>
801043db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043de:	89 42 68             	mov    %eax,0x68(%edx)

  // p->state = RUNNABLE;
  makerunnable(p,0); // New: Added in proyect 2: enqueue proc
801043e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043e8:	00 
801043e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ec:	89 04 24             	mov    %eax,(%esp)
801043ef:	e8 60 fd ff ff       	call   80104154 <makerunnable>

}
801043f4:	c9                   	leave  
801043f5:	c3                   	ret    

801043f6 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801043f6:	55                   	push   %ebp
801043f7:	89 e5                	mov    %esp,%ebp
801043f9:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801043fc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104402:	8b 00                	mov    (%eax),%eax
80104404:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104407:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010440b:	7e 34                	jle    80104441 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010440d:	8b 55 08             	mov    0x8(%ebp),%edx
80104410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104413:	01 c2                	add    %eax,%edx
80104415:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010441b:	8b 40 04             	mov    0x4(%eax),%eax
8010441e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104422:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104425:	89 54 24 04          	mov    %edx,0x4(%esp)
80104429:	89 04 24             	mov    %eax,(%esp)
8010442c:	e8 9e 44 00 00       	call   801088cf <allocuvm>
80104431:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104438:	75 41                	jne    8010447b <growproc+0x85>
      return -1;
8010443a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443f:	eb 58                	jmp    80104499 <growproc+0xa3>
  } else if(n < 0){
80104441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104445:	79 34                	jns    8010447b <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104447:	8b 55 08             	mov    0x8(%ebp),%edx
8010444a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444d:	01 c2                	add    %eax,%edx
8010444f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104455:	8b 40 04             	mov    0x4(%eax),%eax
80104458:	89 54 24 08          	mov    %edx,0x8(%esp)
8010445c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010445f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104463:	89 04 24             	mov    %eax,(%esp)
80104466:	e8 3e 45 00 00       	call   801089a9 <deallocuvm>
8010446b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010446e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104472:	75 07                	jne    8010447b <growproc+0x85>
      return -1;
80104474:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104479:	eb 1e                	jmp    80104499 <growproc+0xa3>
  }
  proc->sz = sz;
8010447b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104481:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104484:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104486:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010448c:	89 04 24             	mov    %eax,(%esp)
8010448f:	e8 66 41 00 00       	call   801085fa <switchuvm>
  return 0;
80104494:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104499:	c9                   	leave  
8010449a:	c3                   	ret    

8010449b <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
8010449b:	55                   	push   %ebp
8010449c:	89 e5                	mov    %esp,%ebp
8010449e:	57                   	push   %edi
8010449f:	56                   	push   %esi
801044a0:	53                   	push   %ebx
801044a1:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801044a4:	e8 19 fd ff ff       	call   801041c2 <allocproc>
801044a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801044ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801044b0:	75 0a                	jne    801044bc <fork+0x21>
    return -1;
801044b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b7:	e9 5b 01 00 00       	jmp    80104617 <fork+0x17c>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801044bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c2:	8b 10                	mov    (%eax),%edx
801044c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044ca:	8b 40 04             	mov    0x4(%eax),%eax
801044cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801044d1:	89 04 24             	mov    %eax,(%esp)
801044d4:	e8 86 46 00 00       	call   80108b5f <copyuvm>
801044d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044dc:	89 42 04             	mov    %eax,0x4(%edx)
801044df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044e2:	8b 40 04             	mov    0x4(%eax),%eax
801044e5:	85 c0                	test   %eax,%eax
801044e7:	75 22                	jne    8010450b <fork+0x70>
    kfree(np->kstack);
801044e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044ec:	8b 40 08             	mov    0x8(%eax),%eax
801044ef:	89 04 24             	mov    %eax,(%esp)
801044f2:	e8 2e e5 ff ff       	call   80102a25 <kfree>
    // np->kstack = 0;
    np->state = UNUSED;
801044f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104506:	e9 0c 01 00 00       	jmp    80104617 <fork+0x17c>
  }
  np->sz = proc->sz;
8010450b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104511:	8b 10                	mov    (%eax),%edx
80104513:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104516:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104518:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010451f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104522:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104525:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104528:	8b 50 18             	mov    0x18(%eax),%edx
8010452b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104531:	8b 40 18             	mov    0x18(%eax),%eax
80104534:	89 c3                	mov    %eax,%ebx
80104536:	b8 13 00 00 00       	mov    $0x13,%eax
8010453b:	89 d7                	mov    %edx,%edi
8010453d:	89 de                	mov    %ebx,%esi
8010453f:	89 c1                	mov    %eax,%ecx
80104541:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104543:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104546:	8b 40 18             	mov    0x18(%eax),%eax
80104549:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104550:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104557:	eb 3c                	jmp    80104595 <fork+0xfa>
    if(proc->ofile[i])
80104559:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010455f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104562:	83 c2 08             	add    $0x8,%edx
80104565:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104569:	85 c0                	test   %eax,%eax
8010456b:	74 25                	je     80104592 <fork+0xf7>
      np->ofile[i] = filedup(proc->ofile[i]);
8010456d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104573:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104576:	83 c2 08             	add    $0x8,%edx
80104579:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010457d:	89 04 24             	mov    %eax,(%esp)
80104580:	e8 ce c9 ff ff       	call   80100f53 <filedup>
80104585:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104588:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010458b:	83 c1 08             	add    $0x8,%ecx
8010458e:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
80104592:	ff 45 e4             	incl   -0x1c(%ebp)
80104595:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104599:	7e be                	jle    80104559 <fork+0xbe>
  np->cwd = idup(proc->cwd);
8010459b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045a1:	8b 40 68             	mov    0x68(%eax),%eax
801045a4:	89 04 24             	mov    %eax,(%esp)
801045a7:	e8 67 d2 ff ff       	call   80101813 <idup>
801045ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045af:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801045b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045b5:	8b 40 10             	mov    0x10(%eax),%eax
801045b8:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Init array of sharedmem
  for (i = 0; i < MAXSHMPROC; i++){
801045bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801045c2:	eb 14                	jmp    801045d8 <fork+0x13d>
    np->shmref[i] = 0;
801045c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801045ca:	83 c2 24             	add    $0x24,%edx
801045cd:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801045d4:	00 
  for (i = 0; i < MAXSHMPROC; i++){
801045d5:	ff 45 e4             	incl   -0x1c(%ebp)
801045d8:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
801045dc:	7e e6                	jle    801045c4 <fork+0x129>
  }

  // np->state = RUNNABLE;
  makerunnable(np,0); // New: Added in proyect 2: every process enqueued is RUNNABLE
801045de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045e5:	00 
801045e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045e9:	89 04 24             	mov    %eax,(%esp)
801045ec:	e8 63 fb ff ff       	call   80104154 <makerunnable>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801045f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045f7:	8d 50 6c             	lea    0x6c(%eax),%edx
801045fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045fd:	83 c0 6c             	add    $0x6c,%eax
80104600:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104607:	00 
80104608:	89 54 24 04          	mov    %edx,0x4(%esp)
8010460c:	89 04 24             	mov    %eax,(%esp)
8010460f:	e8 e3 13 00 00       	call   801059f7 <safestrcpy>
  return pid;
80104614:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104617:	83 c4 2c             	add    $0x2c,%esp
8010461a:	5b                   	pop    %ebx
8010461b:	5e                   	pop    %esi
8010461c:	5f                   	pop    %edi
8010461d:	5d                   	pop    %ebp
8010461e:	c3                   	ret    

8010461f <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010461f:	55                   	push   %ebp
80104620:	89 e5                	mov    %esp,%ebp
80104622:	53                   	push   %ebx
80104623:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int fd, sd, i;

  if(proc == initproc)
80104626:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010462d:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104632:	39 c2                	cmp    %eax,%edx
80104634:	75 0c                	jne    80104642 <exit+0x23>
    panic("init exiting");
80104636:	c7 04 24 3b 91 10 80 	movl   $0x8010913b,(%esp)
8010463d:	e8 f4 be ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104642:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104649:	eb 43                	jmp    8010468e <exit+0x6f>
    if(proc->ofile[fd]){
8010464b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104651:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104654:	83 c2 08             	add    $0x8,%edx
80104657:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010465b:	85 c0                	test   %eax,%eax
8010465d:	74 2c                	je     8010468b <exit+0x6c>
      fileclose(proc->ofile[fd]);
8010465f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104665:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104668:	83 c2 08             	add    $0x8,%edx
8010466b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010466f:	89 04 24             	mov    %eax,(%esp)
80104672:	e8 24 c9 ff ff       	call   80100f9b <fileclose>
      proc->ofile[fd] = 0;
80104677:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010467d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104680:	83 c2 08             	add    $0x8,%edx
80104683:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010468a:	00 
  for(fd = 0; fd < NOFILE; fd++){
8010468b:	ff 45 f0             	incl   -0x10(%ebp)
8010468e:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104692:	7e b7                	jle    8010464b <exit+0x2c>
    }
  }

  //Delete all semaphores
  for(sd = 0; sd < MAXSEMPROC; sd++){
80104694:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010469b:	eb 3f                	jmp    801046dc <exit+0xbd>
    if(proc->procsem[sd]){
8010469d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
801046a6:	83 c2 20             	add    $0x20,%edx
801046a9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046ad:	85 c0                	test   %eax,%eax
801046af:	74 28                	je     801046d9 <exit+0xba>
      semfree(proc->procsem[sd] - getstable());
801046b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801046ba:	83 c2 20             	add    $0x20,%edx
801046bd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801046c1:	89 c3                	mov    %eax,%ebx
801046c3:	e8 01 07 00 00       	call   80104dc9 <getstable>
801046c8:	89 da                	mov    %ebx,%edx
801046ca:	29 c2                	sub    %eax,%edx
801046cc:	89 d0                	mov    %edx,%eax
801046ce:	c1 f8 03             	sar    $0x3,%eax
801046d1:	89 04 24             	mov    %eax,(%esp)
801046d4:	e8 57 08 00 00       	call   80104f30 <semfree>
  for(sd = 0; sd < MAXSEMPROC; sd++){
801046d9:	ff 45 ec             	incl   -0x14(%ebp)
801046dc:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
801046e0:	7e bb                	jle    8010469d <exit+0x7e>
    }
  }

  proc->shmemquantity = 0;
801046e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e8:	c7 80 a8 00 00 00 00 	movl   $0x0,0xa8(%eax)
801046ef:	00 00 00 

  begin_trans(); //add hoy dario, no estoy seguro // begin_op en linux creo
801046f2:	e8 d9 ea ff ff       	call   801031d0 <begin_trans>
  iput(proc->cwd);
801046f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fd:	8b 40 68             	mov    0x68(%eax),%eax
80104700:	89 04 24             	mov    %eax,(%esp)
80104703:	e8 ed d2 ff ff       	call   801019f5 <iput>
  commit_trans(); //add hoy dario, no estoy seguro
80104708:	e8 0c eb ff ff       	call   80103219 <commit_trans>
  proc->cwd = 0;
8010470d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104713:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  // Free shared memory
  for(i = 0; i < MAXSHMPROC; i++){
8010471a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104721:	eb 0e                	jmp    80104731 <exit+0x112>
    if (proc->shmref[i] != 0){}
      shm_close(i);
80104723:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104726:	89 04 24             	mov    %eax,(%esp)
80104729:	e8 c4 0a 00 00       	call   801051f2 <shm_close>
  for(i = 0; i < MAXSHMPROC; i++){
8010472e:	ff 45 e8             	incl   -0x18(%ebp)
80104731:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
80104735:	7e ec                	jle    80104723 <exit+0x104>
  }

  acquire(&ptable.lock);
80104737:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
8010473e:	e8 50 0e 00 00       	call   80105593 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104743:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104749:	8b 40 14             	mov    0x14(%eax),%eax
8010474c:	89 04 24             	mov    %eax,(%esp)
8010474f:	e8 35 04 00 00       	call   80104b89 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104754:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
8010475b:	eb 3b                	jmp    80104798 <exit+0x179>
    if(p->parent == proc){
8010475d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104760:	8b 50 14             	mov    0x14(%eax),%edx
80104763:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104769:	39 c2                	cmp    %eax,%edx
8010476b:	75 24                	jne    80104791 <exit+0x172>
      p->parent = initproc;
8010476d:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
80104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104776:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477c:	8b 40 0c             	mov    0xc(%eax),%eax
8010477f:	83 f8 05             	cmp    $0x5,%eax
80104782:	75 0d                	jne    80104791 <exit+0x172>
        wakeup1(initproc);
80104784:	a1 88 c6 10 80       	mov    0x8010c688,%eax
80104789:	89 04 24             	mov    %eax,(%esp)
8010478c:	e8 f8 03 00 00       	call   80104b89 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104791:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104798:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
8010479f:	72 bc                	jb     8010475d <exit+0x13e>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801047a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a7:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801047ae:	e8 db 01 00 00       	call   8010498e <sched>
  panic("zombie exit");
801047b3:	c7 04 24 48 91 10 80 	movl   $0x80109148,(%esp)
801047ba:	e8 77 bd ff ff       	call   80100536 <panic>

801047bf <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801047bf:	55                   	push   %ebp
801047c0:	89 e5                	mov    %esp,%ebp
801047c2:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801047c5:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801047cc:	e8 c2 0d 00 00       	call   80105593 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801047d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047d8:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801047df:	e9 9d 00 00 00       	jmp    80104881 <wait+0xc2>
      if(p->parent != proc)
801047e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e7:	8b 50 14             	mov    0x14(%eax),%edx
801047ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f0:	39 c2                	cmp    %eax,%edx
801047f2:	0f 85 81 00 00 00    	jne    80104879 <wait+0xba>
        continue;
      havekids = 1;
801047f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801047ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104802:	8b 40 0c             	mov    0xc(%eax),%eax
80104805:	83 f8 05             	cmp    $0x5,%eax
80104808:	75 70                	jne    8010487a <wait+0xbb>
        // Found one.
        pid = p->pid;
8010480a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480d:	8b 40 10             	mov    0x10(%eax),%eax
80104810:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104816:	8b 40 08             	mov    0x8(%eax),%eax
80104819:	89 04 24             	mov    %eax,(%esp)
8010481c:	e8 04 e2 ff ff       	call   80102a25 <kfree>
        p->kstack = 0;
80104821:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104824:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010482b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482e:	8b 40 04             	mov    0x4(%eax),%eax
80104831:	89 04 24             	mov    %eax,(%esp)
80104834:	e8 47 42 00 00       	call   80108a80 <freevm>
        p->state = UNUSED;
80104839:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104846:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010484d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104850:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485a:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104861:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104868:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
8010486f:	e8 81 0d 00 00       	call   801055f5 <release>
        return pid;
80104874:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104877:	eb 56                	jmp    801048cf <wait+0x110>
        continue;
80104879:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487a:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104881:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104888:	0f 82 56 ff ff ff    	jb     801047e4 <wait+0x25>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010488e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104892:	74 0d                	je     801048a1 <wait+0xe2>
80104894:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010489a:	8b 40 24             	mov    0x24(%eax),%eax
8010489d:	85 c0                	test   %eax,%eax
8010489f:	74 13                	je     801048b4 <wait+0xf5>
      release(&ptable.lock);
801048a1:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048a8:	e8 48 0d 00 00       	call   801055f5 <release>
      return -1;
801048ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048b2:	eb 1b                	jmp    801048cf <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801048b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ba:	c7 44 24 04 00 10 11 	movl   $0x80111000,0x4(%esp)
801048c1:	80 
801048c2:	89 04 24             	mov    %eax,(%esp)
801048c5:	e8 01 02 00 00       	call   80104acb <sleep>
  }
801048ca:	e9 02 ff ff ff       	jmp    801047d1 <wait+0x12>
}
801048cf:	c9                   	leave  
801048d0:	c3                   	ret    

801048d1 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801048d1:	55                   	push   %ebp
801048d2:	89 e5                	mov    %esp,%ebp
801048d4:	83 ec 28             	sub    $0x28,%esp
  int i; // New: Added in project 2
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801048d7:	e8 01 f7 ff ff       	call   80103fdd <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048dc:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048e3:	e8 ab 0c 00 00       	call   80105593 <acquire>
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue; // continue, move pointer

    // Set pointer p in zero (null)
    p=0;
801048e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    // Loop over MLF table looking for process to run.
    for(i=0; i<MLF_LEVELS; i++){
801048ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801048f6:	eb 22                	jmp    8010491a <scheduler+0x49>
      if(!isempty(i)){
801048f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048fb:	89 04 24             	mov    %eax,(%esp)
801048fe:	e8 2d f8 ff ff       	call   80104130 <isempty>
80104903:	85 c0                	test   %eax,%eax
80104905:	75 10                	jne    80104917 <scheduler+0x46>
        // New - when a proc state changes to RUNNING it must be dequeued
        p=dequeue(i);
80104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010490a:	89 04 24             	mov    %eax,(%esp)
8010490d:	e8 cf f7 ff ff       	call   801040e1 <dequeue>
80104912:	89 45 f0             	mov    %eax,-0x10(%ebp)
        break;
80104915:	eb 09                	jmp    80104920 <scheduler+0x4f>
    for(i=0; i<MLF_LEVELS; i++){
80104917:	ff 45 f4             	incl   -0xc(%ebp)
8010491a:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
8010491e:	7e d8                	jle    801048f8 <scheduler+0x27>
      }
    }

    // If pointer not null (RUNNABLE proccess found)
    if (p) {
80104920:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104924:	74 57                	je     8010497d <scheduler+0xac>
      proc = p;
80104926:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104929:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      // proc = p; // p->state == RUNNABLE
      
      switchuvm(p); 
8010492f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104932:	89 04 24             	mov    %eax,(%esp)
80104935:	e8 c0 3c 00 00       	call   801085fa <switchuvm>
      p->state = RUNNING;
8010493a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010493d:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->ticksProc = 0;  // New - when a proccess takes control, set ticksCounter on zero
80104944:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104947:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
      //cprintf("proccess %s takes control of the CPU...\n",p->name);
      swtch(&cpu->scheduler, proc->context);
8010494e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104954:	8b 40 1c             	mov    0x1c(%eax),%eax
80104957:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010495e:	83 c2 04             	add    $0x4,%edx
80104961:	89 44 24 04          	mov    %eax,0x4(%esp)
80104965:	89 14 24             	mov    %edx,(%esp)
80104968:	e8 f8 10 00 00       	call   80105a65 <swtch>
      switchkvm();
8010496d:	e8 6b 3c 00 00       	call   801085dd <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104972:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104979:	00 00 00 00 
    }
    release(&ptable.lock);
8010497d:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104984:	e8 6c 0c 00 00       	call   801055f5 <release>

  }
80104989:	e9 49 ff ff ff       	jmp    801048d7 <scheduler+0x6>

8010498e <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
8010498e:	55                   	push   %ebp
8010498f:	89 e5                	mov    %esp,%ebp
80104991:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104994:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
8010499b:	e8 1b 0d 00 00       	call   801056bb <holding>
801049a0:	85 c0                	test   %eax,%eax
801049a2:	75 0c                	jne    801049b0 <sched+0x22>
    panic("sched ptable.lock");
801049a4:	c7 04 24 54 91 10 80 	movl   $0x80109154,(%esp)
801049ab:	e8 86 bb ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
801049b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049b6:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801049bc:	83 f8 01             	cmp    $0x1,%eax
801049bf:	74 0c                	je     801049cd <sched+0x3f>
    panic("sched locks");
801049c1:	c7 04 24 66 91 10 80 	movl   $0x80109166,(%esp)
801049c8:	e8 69 bb ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
801049cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049d3:	8b 40 0c             	mov    0xc(%eax),%eax
801049d6:	83 f8 04             	cmp    $0x4,%eax
801049d9:	75 0c                	jne    801049e7 <sched+0x59>
    panic("sched running");
801049db:	c7 04 24 72 91 10 80 	movl   $0x80109172,(%esp)
801049e2:	e8 4f bb ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
801049e7:	e8 dc f5 ff ff       	call   80103fc8 <readeflags>
801049ec:	25 00 02 00 00       	and    $0x200,%eax
801049f1:	85 c0                	test   %eax,%eax
801049f3:	74 0c                	je     80104a01 <sched+0x73>
    panic("sched interruptible");
801049f5:	c7 04 24 80 91 10 80 	movl   $0x80109180,(%esp)
801049fc:	e8 35 bb ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104a01:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a07:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104a10:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a16:	8b 40 04             	mov    0x4(%eax),%eax
80104a19:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a20:	83 c2 1c             	add    $0x1c,%edx
80104a23:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a27:	89 14 24             	mov    %edx,(%esp)
80104a2a:	e8 36 10 00 00       	call   80105a65 <swtch>
  cpu->intena = intena;
80104a2f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a35:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a38:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104a3e:	c9                   	leave  
80104a3f:	c3                   	ret    

80104a40 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a46:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104a4d:	e8 41 0b 00 00       	call   80105593 <acquire>
  // proc->state = RUNNABLE;
  // sched();
  if(proc->priority<3){ 
80104a52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a58:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a5e:	83 f8 02             	cmp    $0x2,%eax
80104a61:	7f 13                	jg     80104a76 <yield+0x36>
    proc->priority++;
80104a63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a69:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a6f:	42                   	inc    %edx
80104a70:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  makerunnable(proc,1); // New: Added in proyect 2: enqueue proc
80104a76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104a83:	00 
80104a84:	89 04 24             	mov    %eax,(%esp)
80104a87:	e8 c8 f6 ff ff       	call   80104154 <makerunnable>
  sched(); 
80104a8c:	e8 fd fe ff ff       	call   8010498e <sched>
  release(&ptable.lock);
80104a91:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104a98:	e8 58 0b 00 00       	call   801055f5 <release>
}
80104a9d:	c9                   	leave  
80104a9e:	c3                   	ret    

80104a9f <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104a9f:	55                   	push   %ebp
80104aa0:	89 e5                	mov    %esp,%ebp
80104aa2:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104aa5:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104aac:	e8 44 0b 00 00       	call   801055f5 <release>

  if (first) {
80104ab1:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104ab6:	85 c0                	test   %eax,%eax
80104ab8:	74 0f                	je     80104ac9 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104aba:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104ac1:	00 00 00 
    initlog();
80104ac4:	e8 f9 e4 ff ff       	call   80102fc2 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104ac9:	c9                   	leave  
80104aca:	c3                   	ret    

80104acb <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104acb:	55                   	push   %ebp
80104acc:	89 e5                	mov    %esp,%ebp
80104ace:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104ad1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	75 0c                	jne    80104ae7 <sleep+0x1c>
    panic("sleep");
80104adb:	c7 04 24 94 91 10 80 	movl   $0x80109194,(%esp)
80104ae2:	e8 4f ba ff ff       	call   80100536 <panic>

  if(lk == 0)
80104ae7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104aeb:	75 0c                	jne    80104af9 <sleep+0x2e>
    panic("sleep without lk");
80104aed:	c7 04 24 9a 91 10 80 	movl   $0x8010919a,(%esp)
80104af4:	e8 3d ba ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104af9:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b00:	74 17                	je     80104b19 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b02:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b09:	e8 85 0a 00 00       	call   80105593 <acquire>
    release(lk);
80104b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b11:	89 04 24             	mov    %eax,(%esp)
80104b14:	e8 dc 0a 00 00       	call   801055f5 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104b19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b1f:	8b 55 08             	mov    0x8(%ebp),%edx
80104b22:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING; 
80104b25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  // New -  when a proc goes to SLEEPING state, increase priority
  if(proc->priority > 0){ // New: Added in proyect 2
80104b32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b38:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b3e:	85 c0                	test   %eax,%eax
80104b40:	7e 13                	jle    80104b55 <sleep+0x8a>
    proc->priority--;
80104b42:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b48:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b4e:	4a                   	dec    %edx
80104b4f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  sched();
80104b55:	e8 34 fe ff ff       	call   8010498e <sched>

  // Tidy up.
  proc->chan = 0;
80104b5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b60:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104b67:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b6e:	74 17                	je     80104b87 <sleep+0xbc>
    release(&ptable.lock);
80104b70:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b77:	e8 79 0a 00 00       	call   801055f5 <release>
    acquire(lk);
80104b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b7f:	89 04 24             	mov    %eax,(%esp)
80104b82:	e8 0c 0a 00 00       	call   80105593 <acquire>
  }
}
80104b87:	c9                   	leave  
80104b88:	c3                   	ret    

80104b89 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104b89:	55                   	push   %ebp
80104b8a:	89 e5                	mov    %esp,%ebp
80104b8c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b8f:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104b96:	eb 30                	jmp    80104bc8 <wakeup1+0x3f>
    // if(p->state == SLEEPING && p->chan == chan)
    //   p->state = RUNNABLE;
    if(p->state == SLEEPING && p->chan == chan){ // Added in project 2
80104b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9b:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9e:	83 f8 02             	cmp    $0x2,%eax
80104ba1:	75 1e                	jne    80104bc1 <wakeup1+0x38>
80104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba6:	8b 40 20             	mov    0x20(%eax),%eax
80104ba9:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bac:	75 13                	jne    80104bc1 <wakeup1+0x38>
      // New - enqueue proc
      makerunnable(p,-1);
80104bae:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
80104bb5:	ff 
80104bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb9:	89 04 24             	mov    %eax,(%esp)
80104bbc:	e8 93 f5 ff ff       	call   80104154 <makerunnable>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bc1:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104bc8:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104bcf:	72 c7                	jb     80104b98 <wakeup1+0xf>
    }
}
80104bd1:	c9                   	leave  
80104bd2:	c3                   	ret    

80104bd3 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104bd3:	55                   	push   %ebp
80104bd4:	89 e5                	mov    %esp,%ebp
80104bd6:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104bd9:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104be0:	e8 ae 09 00 00       	call   80105593 <acquire>
  wakeup1(chan);
80104be5:	8b 45 08             	mov    0x8(%ebp),%eax
80104be8:	89 04 24             	mov    %eax,(%esp)
80104beb:	e8 99 ff ff ff       	call   80104b89 <wakeup1>
  release(&ptable.lock);
80104bf0:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104bf7:	e8 f9 09 00 00       	call   801055f5 <release>
}
80104bfc:	c9                   	leave  
80104bfd:	c3                   	ret    

80104bfe <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104bfe:	55                   	push   %ebp
80104bff:	89 e5                	mov    %esp,%ebp
80104c01:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c04:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c0b:	e8 83 09 00 00       	call   80105593 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c10:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104c17:	eb 4d                	jmp    80104c66 <kill+0x68>
    if(p->pid == pid){
80104c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1c:	8b 40 10             	mov    0x10(%eax),%eax
80104c1f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c22:	75 3b                	jne    80104c5f <kill+0x61>
      p->killed = 1;
80104c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c27:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      // if(p->state == SLEEPING)
      //   p->state = RUNNABLE;
      if(p->state == SLEEPING){ // Added in proyect 2
80104c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c31:	8b 40 0c             	mov    0xc(%eax),%eax
80104c34:	83 f8 02             	cmp    $0x2,%eax
80104c37:	75 13                	jne    80104c4c <kill+0x4e>
        // New - enqueue proc
        makerunnable(p,0);
80104c39:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c40:	00 
80104c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c44:	89 04 24             	mov    %eax,(%esp)
80104c47:	e8 08 f5 ff ff       	call   80104154 <makerunnable>
      }
      release(&ptable.lock);
80104c4c:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c53:	e8 9d 09 00 00       	call   801055f5 <release>
      return 0;
80104c58:	b8 00 00 00 00       	mov    $0x0,%eax
80104c5d:	eb 21                	jmp    80104c80 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c5f:	81 45 f4 ac 00 00 00 	addl   $0xac,-0xc(%ebp)
80104c66:	81 7d f4 34 3b 11 80 	cmpl   $0x80113b34,-0xc(%ebp)
80104c6d:	72 aa                	jb     80104c19 <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104c6f:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c76:	e8 7a 09 00 00       	call   801055f5 <release>
  return -1;
80104c7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c80:	c9                   	leave  
80104c81:	c3                   	ret    

80104c82 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c82:	55                   	push   %ebp
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	83 ec 68             	sub    $0x68,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c88:	c7 45 f0 34 10 11 80 	movl   $0x80111034,-0x10(%ebp)
80104c8f:	e9 e7 00 00 00       	jmp    80104d7b <procdump+0xf9>
    if(p->state == UNUSED)
80104c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c97:	8b 40 0c             	mov    0xc(%eax),%eax
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	0f 84 d1 00 00 00    	je     80104d73 <procdump+0xf1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ca5:	8b 40 0c             	mov    0xc(%eax),%eax
80104ca8:	83 f8 05             	cmp    $0x5,%eax
80104cab:	77 23                	ja     80104cd0 <procdump+0x4e>
80104cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb0:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb3:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104cba:	85 c0                	test   %eax,%eax
80104cbc:	74 12                	je     80104cd0 <procdump+0x4e>
      state = states[p->state];
80104cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cc1:	8b 40 0c             	mov    0xc(%eax),%eax
80104cc4:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104ccb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104cce:	eb 07                	jmp    80104cd7 <procdump+0x55>
    else
      state = "???";
80104cd0:	c7 45 ec ab 91 10 80 	movl   $0x801091ab,-0x14(%ebp)
    // cprintf("%d %s %s", p->pid, state, p->name);
    cprintf("%d %s %s %d", p->pid, state, p->name, p->priority);
80104cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cda:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ce3:	8d 48 6c             	lea    0x6c(%eax),%ecx
80104ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ce9:	8b 40 10             	mov    0x10(%eax),%eax
80104cec:	89 54 24 10          	mov    %edx,0x10(%esp)
80104cf0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80104cf4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104cf7:	89 54 24 08          	mov    %edx,0x8(%esp)
80104cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cff:	c7 04 24 af 91 10 80 	movl   $0x801091af,(%esp)
80104d06:	e8 96 b6 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d0e:	8b 40 0c             	mov    0xc(%eax),%eax
80104d11:	83 f8 02             	cmp    $0x2,%eax
80104d14:	75 4f                	jne    80104d65 <procdump+0xe3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d19:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d1c:	8b 40 0c             	mov    0xc(%eax),%eax
80104d1f:	83 c0 08             	add    $0x8,%eax
80104d22:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d25:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d29:	89 04 24             	mov    %eax,(%esp)
80104d2c:	e8 13 09 00 00       	call   80105644 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d31:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d38:	eb 1a                	jmp    80104d54 <procdump+0xd2>
        cprintf(" %p", pc[i]);
80104d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d41:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d45:	c7 04 24 bb 91 10 80 	movl   $0x801091bb,(%esp)
80104d4c:	e8 50 b6 ff ff       	call   801003a1 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d51:	ff 45 f4             	incl   -0xc(%ebp)
80104d54:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104d58:	7f 0b                	jg     80104d65 <procdump+0xe3>
80104d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d61:	85 c0                	test   %eax,%eax
80104d63:	75 d5                	jne    80104d3a <procdump+0xb8>
    }
    cprintf("\n");
80104d65:	c7 04 24 bf 91 10 80 	movl   $0x801091bf,(%esp)
80104d6c:	e8 30 b6 ff ff       	call   801003a1 <cprintf>
80104d71:	eb 01                	jmp    80104d74 <procdump+0xf2>
      continue;
80104d73:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d74:	81 45 f0 ac 00 00 00 	addl   $0xac,-0x10(%ebp)
80104d7b:	81 7d f0 34 3b 11 80 	cmpl   $0x80113b34,-0x10(%ebp)
80104d82:	0f 82 0c ff ff ff    	jb     80104c94 <procdump+0x12>
  }
}
80104d88:	c9                   	leave  
80104d89:	c3                   	ret    

80104d8a <checkprocsem>:
	struct sem sem[MAXSEM]; // atrib. (value,refcount) (MAXSEM = 16)
} stable;

// proc->procsem es la lista de semaforos por proceso
// MAXSEMPROC = 4 es la cantidad maxima de semaforos por proceso
struct sem** checkprocsem(){
80104d8a:	55                   	push   %ebp
80104d8b:	89 e5                	mov    %esp,%ebp
80104d8d:	83 ec 10             	sub    $0x10,%esp
	struct sem **r;
	// a "r" le asigno el arreglo de la list of semaphores del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104d90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d96:	05 88 00 00 00       	add    $0x88,%eax
80104d9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104d9e:	eb 12                	jmp    80104db2 <checkprocsem+0x28>
		if (*r == 0)
80104da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104da3:	8b 00                	mov    (%eax),%eax
80104da5:	85 c0                	test   %eax,%eax
80104da7:	75 05                	jne    80104dae <checkprocsem+0x24>
			return r;
80104da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dac:	eb 19                	jmp    80104dc7 <checkprocsem+0x3d>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104dae:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
80104db2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db8:	05 98 00 00 00       	add    $0x98,%eax
80104dbd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104dc0:	77 de                	ja     80104da0 <checkprocsem+0x16>
	}
	return 0;
80104dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dc7:	c9                   	leave  
80104dc8:	c3                   	ret    

80104dc9 <getstable>:

struct sem* getstable(){
80104dc9:	55                   	push   %ebp
80104dca:	89 e5                	mov    %esp,%ebp
	return stable.sem;
80104dcc:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
}
80104dd1:	5d                   	pop    %ebp
80104dd2:	c3                   	ret    

80104dd3 <semget>:

// crea u obtiene un descriptor de un semaforo existente
int semget(int sem_id, int init_value){
80104dd3:	55                   	push   %ebp
80104dd4:	89 e5                	mov    %esp,%ebp
80104dd6:	83 ec 28             	sub    $0x28,%esp
	struct sem *t;
	struct sem *s;
	struct sem **r;
	static int first_time = 1;

	if (first_time) {
80104dd9:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80104dde:	85 c0                	test   %eax,%eax
80104de0:	74 1e                	je     80104e00 <semget+0x2d>
		initlock(&stable.lock, "stable"); // begin the mutual exclusion
80104de2:	c7 44 24 04 eb 91 10 	movl   $0x801091eb,0x4(%esp)
80104de9:	80 
80104dea:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104df1:	e8 7c 07 00 00       	call   80105572 <initlock>
		first_time = 0;
80104df6:	c7 05 24 c0 10 80 00 	movl   $0x0,0x8010c024
80104dfd:	00 00 00 
	}

	acquire(&stable.lock);
80104e00:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e07:	e8 87 07 00 00       	call   80105593 <acquire>
	if (sem_id == -1) { // se desea crear un semaforo nuevo
80104e0c:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
80104e10:	0f 85 9d 00 00 00    	jne    80104eb3 <semget+0xe0>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e16:	c7 45 f4 94 3b 11 80 	movl   $0x80113b94,-0xc(%ebp)
80104e1d:	eb 3b                	jmp    80104e5a <semget+0x87>
		if (t->refcount == 0){
80104e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e22:	8b 40 04             	mov    0x4(%eax),%eax
80104e25:	85 c0                	test   %eax,%eax
80104e27:	75 2d                	jne    80104e56 <semget+0x83>
			s = t;
80104e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (*(r = checkprocsem()) == 0)
80104e2f:	e8 56 ff ff ff       	call   80104d8a <checkprocsem>
80104e34:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e3a:	8b 00                	mov    (%eax),%eax
80104e3c:	85 c0                	test   %eax,%eax
80104e3e:	74 39                	je     80104e79 <semget+0xa6>
				goto found;
			release(&stable.lock);
80104e40:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e47:	e8 a9 07 00 00       	call   801055f5 <release>
			return -2; // el proceso ya obtuvo el numero maximo d semaforos
80104e4c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104e51:	e9 d8 00 00 00       	jmp    80104f2e <semget+0x15b>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e56:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80104e5a:	81 7d f4 14 3c 11 80 	cmpl   $0x80113c14,-0xc(%ebp)
80104e61:	72 bc                	jb     80104e1f <semget+0x4c>
		}
		release(&stable.lock);
80104e63:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e6a:	e8 86 07 00 00       	call   801055f5 <release>
		return -3; // no ahi mas semaforos disponibles en el sistema
80104e6f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80104e74:	e9 b5 00 00 00       	jmp    80104f2e <semget+0x15b>
				goto found;
80104e79:	90                   	nop

		found:
		s->value = init_value;
80104e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e80:	89 10                	mov    %edx,(%eax)
		s->refcount=1;
80104e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e85:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
		*r = s;
80104e8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e92:	89 10                	mov    %edx,(%eax)
		// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i));
		// 	} else
		// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i) - stable.sem);
		// }

		release(&stable.lock);
80104e94:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104e9b:	e8 55 07 00 00       	call   801055f5 <release>
		return s - stable.sem;	
80104ea0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ea3:	b8 94 3b 11 80       	mov    $0x80113b94,%eax
80104ea8:	89 d1                	mov    %edx,%ecx
80104eaa:	29 c1                	sub    %eax,%ecx
80104eac:	89 c8                	mov    %ecx,%eax
80104eae:	c1 f8 03             	sar    $0x3,%eax
80104eb1:	eb 7b                	jmp    80104f2e <semget+0x15b>

	} else { // en caso de que NO se desea crear un semaforo nuevo
		s = stable.sem + sem_id;
80104eb3:	8b 45 08             	mov    0x8(%ebp),%eax
80104eb6:	83 c0 06             	add    $0x6,%eax
80104eb9:	c1 e0 03             	shl    $0x3,%eax
80104ebc:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104ec1:	83 c0 04             	add    $0x4,%eax
80104ec4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (s->refcount == 0){
80104ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eca:	8b 40 04             	mov    0x4(%eax),%eax
80104ecd:	85 c0                	test   %eax,%eax
80104ecf:	75 13                	jne    80104ee4 <semget+0x111>
			release(&stable.lock);
80104ed1:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104ed8:	e8 18 07 00 00       	call   801055f5 <release>
			return -1; // el semaforo con ese "sem_id" no esta en uso 
80104edd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee2:	eb 4a                	jmp    80104f2e <semget+0x15b>
		}else if (*(r = checkprocsem()) == 0){
80104ee4:	e8 a1 fe ff ff       	call   80104d8a <checkprocsem>
80104ee9:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104eec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eef:	8b 00                	mov    (%eax),%eax
80104ef1:	85 c0                	test   %eax,%eax
80104ef3:	75 28                	jne    80104f1d <semget+0x14a>
			*r = s;
80104ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ef8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104efb:	89 10                	mov    %edx,(%eax)
			s->refcount++;
80104efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f00:	8b 40 04             	mov    0x4(%eax),%eax
80104f03:	8d 50 01             	lea    0x1(%eax),%edx
80104f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f09:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80104f0c:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104f13:	e8 dd 06 00 00       	call   801055f5 <release>
			return sem_id;
80104f18:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1b:	eb 11                	jmp    80104f2e <semget+0x15b>
		}	else {
			release(&stable.lock);
80104f1d:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104f24:	e8 cc 06 00 00       	call   801055f5 <release>
			return -2; // el proceso ya obtuvo el maximo de semaforos
80104f29:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax

		}
	}
}
80104f2e:	c9                   	leave  
80104f2f:	c3                   	ret    

80104f30 <semfree>:

// libera el semaforo.
// como parametro toma un descriptor.
int semfree(int sem_id){
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;
	struct sem **r;

	s = stable.sem + sem_id;
80104f36:	8b 45 08             	mov    0x8(%ebp),%eax
80104f39:	83 c0 06             	add    $0x6,%eax
80104f3c:	c1 e0 03             	shl    $0x3,%eax
80104f3f:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104f44:	83 c0 04             	add    $0x4,%eax
80104f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (s->refcount == 0) // si no tiene ninguna referencia, entonces no esta en uso,	
80104f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f4d:	8b 40 04             	mov    0x4(%eax),%eax
80104f50:	85 c0                	test   %eax,%eax
80104f52:	75 07                	jne    80104f5b <semfree+0x2b>
		return -1;		 //  y no es posible liberarlo, se produce un ERROR! 
80104f54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f59:	eb 6a                	jmp    80104fc5 <semfree+0x95>

	// recorro todos los semaforos del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104f5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f61:	05 88 00 00 00       	add    $0x88,%eax
80104f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f69:	eb 45                	jmp    80104fb0 <semfree+0x80>
		if (*r == s) {
80104f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6e:	8b 00                	mov    (%eax),%eax
80104f70:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104f73:	75 37                	jne    80104fac <semfree+0x7c>
			*r = 0;
80104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f78:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			acquire(&stable.lock);
80104f7e:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104f85:	e8 09 06 00 00       	call   80105593 <acquire>
			s->refcount--; // disminuyo el contador, debido a q es un semaforo q se va.
80104f8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f8d:	8b 40 04             	mov    0x4(%eax),%eax
80104f90:	8d 50 ff             	lea    -0x1(%eax),%edx
80104f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f96:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80104f99:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fa0:	e8 50 06 00 00       	call   801055f5 <release>
			return 0;
80104fa5:	b8 00 00 00 00       	mov    $0x0,%eax
80104faa:	eb 19                	jmp    80104fc5 <semfree+0x95>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104fac:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
80104fb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fb6:	05 98 00 00 00       	add    $0x98,%eax
80104fbb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104fbe:	77 ab                	ja     80104f6b <semfree+0x3b>
		}
	}
	return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc5:	c9                   	leave  
80104fc6:	c3                   	ret    

80104fc7 <semdown>:

// decrementa una unidad el valor del semaforo.
int semdown(int sem_id){
80104fc7:	55                   	push   %ebp
80104fc8:	89 e5                	mov    %esp,%ebp
80104fca:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;

	s = stable.sem + sem_id;
80104fcd:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd0:	83 c0 06             	add    $0x6,%eax
80104fd3:	c1 e0 03             	shl    $0x3,%eax
80104fd6:	05 60 3b 11 80       	add    $0x80113b60,%eax
80104fdb:	83 c0 04             	add    $0x4,%eax
80104fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
80104fe1:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104fe8:	e8 a6 05 00 00       	call   80105593 <acquire>
	if (s->refcount <= 0) {
80104fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff0:	8b 40 04             	mov    0x4(%eax),%eax
80104ff3:	85 c0                	test   %eax,%eax
80104ff5:	7f 28                	jg     8010501f <semdown+0x58>
		release(&stable.lock);
80104ff7:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80104ffe:	e8 f2 05 00 00       	call   801055f5 <release>
		// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error!!
80105003:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105008:	eb 3d                	jmp    80105047 <semdown+0x80>
	}
	while (s->value == 0)
	sleep(s, &stable.lock); 
8010500a:	c7 44 24 04 60 3b 11 	movl   $0x80113b60,0x4(%esp)
80105011:	80 
80105012:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105015:	89 04 24             	mov    %eax,(%esp)
80105018:	e8 ae fa ff ff       	call   80104acb <sleep>
8010501d:	eb 01                	jmp    80105020 <semdown+0x59>
	while (s->value == 0)
8010501f:	90                   	nop
80105020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105023:	8b 00                	mov    (%eax),%eax
80105025:	85 c0                	test   %eax,%eax
80105027:	74 e1                	je     8010500a <semdown+0x43>

	s->value--;
80105029:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502c:	8b 00                	mov    (%eax),%eax
8010502e:	8d 50 ff             	lea    -0x1(%eax),%edx
80105031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105034:	89 10                	mov    %edx,(%eax)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	release(&stable.lock);
80105036:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
8010503d:	e8 b3 05 00 00       	call   801055f5 <release>
	return 0;
80105042:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105047:	c9                   	leave  
80105048:	c3                   	ret    

80105049 <semup>:

// incrementa una unidad el valor del semaforo
int semup(int sem_id){
80105049:	55                   	push   %ebp
8010504a:	89 e5                	mov    %esp,%ebp
8010504c:	83 ec 28             	sub    $0x28,%esp
struct sem *s;

	s = stable.sem + sem_id;
8010504f:	8b 45 08             	mov    0x8(%ebp),%eax
80105052:	83 c0 06             	add    $0x6,%eax
80105055:	c1 e0 03             	shl    $0x3,%eax
80105058:	05 60 3b 11 80       	add    $0x80113b60,%eax
8010505d:	83 c0 04             	add    $0x4,%eax
80105060:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
80105063:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
8010506a:	e8 24 05 00 00       	call   80105593 <acquire>
	if (s->refcount <= 0) {
8010506f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105072:	8b 40 04             	mov    0x4(%eax),%eax
80105075:	85 c0                	test   %eax,%eax
80105077:	7f 13                	jg     8010508c <semup+0x43>
		release(&stable.lock);
80105079:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
80105080:	e8 70 05 00 00       	call   801055f5 <release>
		// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error, por que no ahi referencias en este semaforo.
80105085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010508a:	eb 4a                	jmp    801050d6 <semup+0x8d>
	}
	if (s->value >= 0) {
8010508c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010508f:	8b 00                	mov    (%eax),%eax
80105091:	85 c0                	test   %eax,%eax
80105093:	78 3c                	js     801050d1 <semup+0x88>
		if (s->value == 0){
80105095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105098:	8b 00                	mov    (%eax),%eax
8010509a:	85 c0                	test   %eax,%eax
8010509c:	75 1a                	jne    801050b8 <semup+0x6f>
			s->value++;
8010509e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a1:	8b 00                	mov    (%eax),%eax
801050a3:	8d 50 01             	lea    0x1(%eax),%edx
801050a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a9:	89 10                	mov    %edx,(%eax)
			wakeup(s); // despierto
801050ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ae:	89 04 24             	mov    %eax,(%esp)
801050b1:	e8 1d fb ff ff       	call   80104bd3 <wakeup>
801050b6:	eb 0d                	jmp    801050c5 <semup+0x7c>
		}else
			s->value++;
801050b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bb:	8b 00                	mov    (%eax),%eax
801050bd:	8d 50 01             	lea    0x1(%eax),%edx
801050c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050c3:	89 10                	mov    %edx,(%eax)
			release(&stable.lock);
801050c5:	c7 04 24 60 3b 11 80 	movl   $0x80113b60,(%esp)
801050cc:	e8 24 05 00 00       	call   801055f5 <release>
			// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	}
	return 0;
801050d1:	b8 00 00 00 00       	mov    $0x0,%eax
801050d6:	c9                   	leave  
801050d7:	c3                   	ret    

801050d8 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801050d8:	55                   	push   %ebp
801050d9:	89 e5                	mov    %esp,%ebp
801050db:	8b 45 08             	mov    0x8(%ebp),%eax
801050de:	05 00 00 00 80       	add    $0x80000000,%eax
801050e3:	5d                   	pop    %ebp
801050e4:	c3                   	ret    

801050e5 <shm_init>:
//   unsigned short quantity; //quantity of actives espaces of shared memory
// } shmtable;

int
shm_init()
{
801050e5:	55                   	push   %ebp
801050e6:	89 e5                	mov    %esp,%ebp
801050e8:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&shmtable.lock, "shmtable");
801050eb:	c7 44 24 04 f2 91 10 	movl   $0x801091f2,0x4(%esp)
801050f2:	80 
801050f3:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801050fa:	e8 73 04 00 00       	call   80105572 <initlock>
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
801050ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105106:	eb 11                	jmp    80105119 <shm_init+0x34>
    shmtable.sharedmemory[i].refcount = -1; // inician todos los espacios con su contador de referencia en -1.
80105108:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010510b:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
80105112:	ff ff ff ff 
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
80105116:	ff 45 f4             	incl   -0xc(%ebp)
80105119:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
8010511d:	7e e9                	jle    80105108 <shm_init+0x23>
  }
  return 0;
8010511f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105124:	c9                   	leave  
80105125:	c3                   	ret    

80105126 <shm_create>:

//Creates a shared memory block.
int
shm_create()
{ 
80105126:	55                   	push   %ebp
80105127:	89 e5                	mov    %esp,%ebp
80105129:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);
8010512c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105133:	e8 5b 04 00 00       	call   80105593 <acquire>
  if ( shmtable.quantity == MAXSHM ){ // si la cantidad de espacios activos en sharedmemory es igual a 12
80105138:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
8010513d:	66 83 f8 0c          	cmp    $0xc,%ax
80105141:	75 16                	jne    80105159 <shm_create+0x33>
    release(&shmtable.lock);         // es la logitud maxima del array sharedmemory, entonces:
80105143:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010514a:	e8 a6 04 00 00       	call   801055f5 <release>
    return -1;                      // no ahi mas espacios de memoria compartida, se fueron los 12 espacios que habia.
8010514f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105154:	e9 97 00 00 00       	jmp    801051f0 <shm_create+0xca>
  }
  int i = 0;
80105159:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
80105160:	eb 77                	jmp    801051d9 <shm_create+0xb3>
    if (shmtable.sharedmemory[i].refcount == -1){ // si es -1, esta desocupado el espacio.
80105162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105165:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
8010516c:	83 f8 ff             	cmp    $0xffffffff,%eax
8010516f:	75 65                	jne    801051d6 <shm_create+0xb0>
      shmtable.sharedmemory[i].addr = kalloc(); // El "kalloc" asigna una pagina de 4096 bytes de memoria fisica,
80105171:	e8 48 d9 ff ff       	call   80102abe <kalloc>
80105176:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105179:	89 04 d5 60 0f 11 80 	mov    %eax,-0x7feef0a0(,%edx,8)
                                                // si todo sale bien, me retorna como resultado un puntero (direccion), 
                                                // a esta direccion la almaceno en "sharedmemory.addr".
                                                // Si el kalloc no pudo asignar la memoria me devuelve como resultado 0.
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE); 
80105180:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105183:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
8010518a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105191:	00 
80105192:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105199:	00 
8010519a:	89 04 24             	mov    %eax,(%esp)
8010519d:	e8 43 06 00 00       	call   801057e5 <memset>
      shmtable.sharedmemory[i].refcount++; // Incremento el refcount en una unidad, estaba en -1, ahora en 0, inicialmente.
801051a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a5:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801051ac:	8d 50 01             	lea    0x1(%eax),%edx
801051af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051b2:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
      shmtable.quantity++; // se tomo un espacio del arreglo 
801051b9:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
801051be:	40                   	inc    %eax
801051bf:	66 a3 f4 0f 11 80    	mov    %ax,0x80110ff4
      release(&shmtable.lock);
801051c5:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801051cc:	e8 24 04 00 00       	call   801055f5 <release>
      return i; // retorno el indice (key) del arreglo en donde se encuentra el espacio de memoria compartida.
801051d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d4:	eb 1a                	jmp    801051f0 <shm_create+0xca>
    } else
      ++i;
801051d6:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
801051d9:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
801051dd:	7e 83                	jle    80105162 <shm_create+0x3c>
  }
  release(&shmtable.lock);
801051df:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801051e6:	e8 0a 04 00 00       	call   801055f5 <release>
  //return -2 si proc->sharedmemory == MAXSHMPROC; // Consultar?: el proceso ya alcanzo el maximo de recursos posibles.
  return -1; // no ahi mas recursos disponbles en el sistema.
801051eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f0:	c9                   	leave  
801051f1:	c3                   	ret    

801051f2 <shm_close>:

//Frees the memory block previously obtained.
int
shm_close(int key)
{
801051f2:	55                   	push   %ebp
801051f3:	89 e5                	mov    %esp,%ebp
801051f5:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);  
801051f8:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801051ff:	e8 8f 03 00 00       	call   80105593 <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == -1){
80105204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105208:	78 15                	js     8010521f <shm_close+0x2d>
8010520a:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
8010520e:	7f 0f                	jg     8010521f <shm_close+0x2d>
80105210:	8b 45 08             	mov    0x8(%ebp),%eax
80105213:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
8010521a:	83 f8 ff             	cmp    $0xffffffff,%eax
8010521d:	75 16                	jne    80105235 <shm_close+0x43>
    release(&shmtable.lock);
8010521f:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105226:	e8 ca 03 00 00       	call   801055f5 <release>
    return -1; // key invalidad por que no esta dentro de los indices (0 - 12), o en ese espacio esta vacio (refcount = -1)
8010522b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105230:	e9 8d 00 00 00       	jmp    801052c2 <shm_close+0xd0>
  }
  int i = 0;
80105235:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
8010523c:	eb 03                	jmp    80105241 <shm_close+0x4f>
    i++; // avanzo al proximo
8010523e:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
80105241:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80105245:	7f 1e                	jg     80105265 <shm_close+0x73>
80105247:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105250:	83 c2 24             	add    $0x24,%edx
80105253:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80105257:	8b 45 08             	mov    0x8(%ebp),%eax
8010525a:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
80105261:	39 c2                	cmp    %eax,%edx
80105263:	75 d9                	jne    8010523e <shm_close+0x4c>
  }
  if (i == MAXSHMPROC){ 
80105265:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80105269:	75 13                	jne    8010527e <shm_close+0x8c>
    release(&shmtable.lock);
8010526b:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105272:	e8 7e 03 00 00       	call   801055f5 <release>
    return -1; // se alcazo a recorrer todos los espacios de memoria compartida del proceso.
80105277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527c:	eb 44                	jmp    801052c2 <shm_close+0xd0>
  }  
  shmtable.sharedmemory[key].refcount--; // encontre la direccion, luego decremento refcount.
8010527e:	8b 45 08             	mov    0x8(%ebp),%eax
80105281:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105288:	8d 50 ff             	lea    -0x1(%eax),%edx
8010528b:	8b 45 08             	mov    0x8(%ebp),%eax
8010528e:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
  if (shmtable.sharedmemory[key].refcount == 0){ 
80105295:	8b 45 08             	mov    0x8(%ebp),%eax
80105298:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
8010529f:	85 c0                	test   %eax,%eax
801052a1:	75 0e                	jne    801052b1 <shm_close+0xbf>
    shmtable.sharedmemory[key].refcount = -1; // reinicio el espacio en el arreglo, como solo quedo uno, lo reinicio.
801052a3:	8b 45 08             	mov    0x8(%ebp),%eax
801052a6:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
801052ad:	ff ff ff ff 
  }
  release(&shmtable.lock);
801052b1:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052b8:	e8 38 03 00 00       	call   801055f5 <release>
  return 0;  // todo en orden
801052bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052c2:	c9                   	leave  
801052c3:	c3                   	ret    

801052c4 <shm_get>:

//Obtains the address of the memory block associated with key.
int
shm_get(int key, char** addr)
{
801052c4:	55                   	push   %ebp
801052c5:	89 e5                	mov    %esp,%ebp
801052c7:	83 ec 38             	sub    $0x38,%esp
  int j;
  acquire(&shmtable.lock);
801052ca:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052d1:	e8 bd 02 00 00       	call   80105593 <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == MAXSHMPROC ){ 
801052d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801052da:	78 15                	js     801052f1 <shm_get+0x2d>
801052dc:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
801052e0:	7f 0f                	jg     801052f1 <shm_get+0x2d>
801052e2:	8b 45 08             	mov    0x8(%ebp),%eax
801052e5:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801052ec:	83 f8 04             	cmp    $0x4,%eax
801052ef:	75 16                	jne    80105307 <shm_get+0x43>
    release(&shmtable.lock);                 
801052f1:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052f8:	e8 f8 02 00 00       	call   801055f5 <release>
    return -1; // key invalida, debido a que esta fuera de los indices la key.
801052fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105302:	e9 24 01 00 00       	jmp    8010542b <shm_get+0x167>
  }  
  int i = 0;
80105307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
8010530e:	eb 03                	jmp    80105313 <shm_get+0x4f>
    i++;
80105310:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
80105313:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80105317:	7f 14                	jg     8010532d <shm_get+0x69>
80105319:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010531f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105322:	83 c2 24             	add    $0x24,%edx
80105325:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105329:	85 c0                	test   %eax,%eax
8010532b:	75 e3                	jne    80105310 <shm_get+0x4c>
  }
  if (i == MAXSHMPROC ){ // si agoto los 4 espacios que posee el proceso disponible, entonces..
8010532d:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80105331:	75 16                	jne    80105349 <shm_get+0x85>
    release(&shmtable.lock); 
80105333:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010533a:	e8 b6 02 00 00       	call   801055f5 <release>
    return -1; // no ahi mas recursos disponibles (esp. de memoria compartida) por este proceso.
8010533f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105344:	e9 e2 00 00 00       	jmp    8010542b <shm_get+0x167>
  } else {  
            
    j = mappages(proc->pgdir, (void *)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
80105349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534c:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
80105353:	89 04 24             	mov    %eax,(%esp)
80105356:	e8 7d fd ff ff       	call   801050d8 <v2p>
8010535b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105362:	8b 12                	mov    (%edx),%edx
80105364:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010536a:	89 d1                	mov    %edx,%ecx
8010536c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105373:	8b 52 04             	mov    0x4(%edx),%edx
80105376:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010537d:	00 
8010537e:	89 44 24 0c          	mov    %eax,0xc(%esp)
80105382:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105389:	00 
8010538a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010538e:	89 14 24             	mov    %edx,(%esp)
80105391:	e8 df 30 00 00       	call   80108475 <mappages>
80105396:	89 45 f0             	mov    %eax,-0x10(%ebp)
            // Llena entradas de la tabla de paginas, mapeo de direcciones virtuales segun direc. fisicas

            // PTE_U: controla que el proceso de usuario pueda utilizar la pagina, si no solo el kernel puede usar la pagina.
            // PTE_W: controla si las instrucciones se les permite escribir en la pagina.

    if (j==-1) { cprintf("mappages error \n"); }
80105399:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
8010539d:	75 0c                	jne    801053ab <shm_get+0xe7>
8010539f:	c7 04 24 fb 91 10 80 	movl   $0x801091fb,(%esp)
801053a6:	e8 f6 af ff ff       	call   801003a1 <cprintf>

    proc->shmref[i] = shmtable.sharedmemory[key].addr; // la guardo en shmref[i]
801053ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b1:	8b 55 08             	mov    0x8(%ebp),%edx
801053b4:	8b 14 d5 60 0f 11 80 	mov    -0x7feef0a0(,%edx,8),%edx
801053bb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801053be:	83 c1 24             	add    $0x24,%ecx
801053c1:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
    shmtable.sharedmemory[key].refcount++; 
801053c5:	8b 45 08             	mov    0x8(%ebp),%eax
801053c8:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801053cf:	8d 50 01             	lea    0x1(%eax),%edx
801053d2:	8b 45 08             	mov    0x8(%ebp),%eax
801053d5:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
    *addr = (char *)PGROUNDDOWN(proc->sz); // guardo la direccion en *addr, de la pagina que se encuentra por debajo de proc->sz
801053dc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053e2:	8b 00                	mov    (%eax),%eax
801053e4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801053e9:	89 c2                	mov    %eax,%edx
801053eb:	8b 45 0c             	mov    0xc(%ebp),%eax
801053ee:	89 10                	mov    %edx,(%eax)
    proc->shmemquantity++; // aumento la cantidad de espacio de memoria compartida por el proceso
801053f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f6:	8b 90 a8 00 00 00    	mov    0xa8(%eax),%edx
801053fc:	42                   	inc    %edx
801053fd:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
    proc->sz = proc->sz + PGSIZE; // actualizo el tamaño de la memoria del proceso, debido a que ya se realizo el mapeo
80105403:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105409:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105410:	8b 12                	mov    (%edx),%edx
80105412:	81 c2 00 10 00 00    	add    $0x1000,%edx
80105418:	89 10                	mov    %edx,(%eax)
    release(&shmtable.lock);
8010541a:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105421:	e8 cf 01 00 00       	call   801055f5 <release>
    return 0; // todo salio bien.
80105426:	b8 00 00 00 00       	mov    $0x0,%eax
  }   
}
8010542b:	c9                   	leave  
8010542c:	c3                   	ret    

8010542d <get_shm_table>:

//Obtains the array from type sharedmemory
struct sharedmemory* get_shm_table(){
8010542d:	55                   	push   %ebp
8010542e:	89 e5                	mov    %esp,%ebp
  return shmtable.sharedmemory; // como resultado, mi arreglo principal sharedmemory 
80105430:	b8 60 0f 11 80       	mov    $0x80110f60,%eax
}
80105435:	5d                   	pop    %ebp
80105436:	c3                   	ret    

80105437 <sys_shm_create>:
// esta la termine definiendo en Makefile!!!!!!!! recordar

//Creates a shared memory block.
int
sys_shm_create(void)
{
80105437:	55                   	push   %ebp
80105438:	89 e5                	mov    %esp,%ebp
8010543a:	83 ec 28             	sub    $0x28,%esp
  int size;
  if(argint(0, &size) < 0 && (size > 0) )
8010543d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105440:	89 44 24 04          	mov    %eax,0x4(%esp)
80105444:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010544b:	e8 c6 06 00 00       	call   80105b16 <argint>
80105450:	85 c0                	test   %eax,%eax
80105452:	79 0e                	jns    80105462 <sys_shm_create+0x2b>
80105454:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105457:	85 c0                	test   %eax,%eax
80105459:	7e 07                	jle    80105462 <sys_shm_create+0x2b>
    return -1;
8010545b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105460:	eb 0b                	jmp    8010546d <sys_shm_create+0x36>
  int k = shm_create();
80105462:	e8 bf fc ff ff       	call   80105126 <shm_create>
80105467:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return k;
8010546a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    

8010546f <sys_shm_get>:

//Obtains the address of the memory block associated with key.
int
sys_shm_get(void)
{
8010546f:	55                   	push   %ebp
80105470:	89 e5                	mov    %esp,%ebp
80105472:	83 ec 28             	sub    $0x28,%esp
  int k;
  int mem = 0;  
80105475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (proc->shmemquantity >= MAXSHMPROC)
8010547c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105482:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105488:	83 f8 03             	cmp    $0x3,%eax
8010548b:	7e 07                	jle    80105494 <sys_shm_get+0x25>
    return -1;
8010548d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105492:	eb 55                	jmp    801054e9 <sys_shm_get+0x7a>
  if(argint(0, &k) < 0)
80105494:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105497:	89 44 24 04          	mov    %eax,0x4(%esp)
8010549b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a2:	e8 6f 06 00 00       	call   80105b16 <argint>
801054a7:	85 c0                	test   %eax,%eax
801054a9:	79 07                	jns    801054b2 <sys_shm_get+0x43>
    return -1;
801054ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b0:	eb 37                	jmp    801054e9 <sys_shm_get+0x7a>
  argint(1,&mem); 
801054b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054c0:	e8 51 06 00 00       	call   80105b16 <argint>
  if (!shm_get(k,(char**)mem)){ 
801054c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054c8:	89 c2                	mov    %eax,%edx
801054ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054cd:	89 54 24 04          	mov    %edx,0x4(%esp)
801054d1:	89 04 24             	mov    %eax,(%esp)
801054d4:	e8 eb fd ff ff       	call   801052c4 <shm_get>
801054d9:	85 c0                	test   %eax,%eax
801054db:	75 07                	jne    801054e4 <sys_shm_get+0x75>
    return 0;
801054dd:	b8 00 00 00 00       	mov    $0x0,%eax
801054e2:	eb 05                	jmp    801054e9 <sys_shm_get+0x7a>
  }
  return -1;
801054e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054e9:	c9                   	leave  
801054ea:	c3                   	ret    

801054eb <sys_shm_close>:

//Frees the memory block previously obtained.
int
sys_shm_close(void)
{
801054eb:	55                   	push   %ebp
801054ec:	89 e5                	mov    %esp,%ebp
801054ee:	83 ec 28             	sub    $0x28,%esp
  int k;
  if(argint(0, &k) < 0)
801054f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801054f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054ff:	e8 12 06 00 00       	call   80105b16 <argint>
80105504:	85 c0                	test   %eax,%eax
80105506:	79 07                	jns    8010550f <sys_shm_close+0x24>
    return -1;
80105508:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550d:	eb 1b                	jmp    8010552a <sys_shm_close+0x3f>
  if (!shm_close(k)){    
8010550f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105512:	89 04 24             	mov    %eax,(%esp)
80105515:	e8 d8 fc ff ff       	call   801051f2 <shm_close>
8010551a:	85 c0                	test   %eax,%eax
8010551c:	75 07                	jne    80105525 <sys_shm_close+0x3a>
    return 0;
8010551e:	b8 00 00 00 00       	mov    $0x0,%eax
80105523:	eb 05                	jmp    8010552a <sys_shm_close+0x3f>
  }
  return -1;
80105525:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552a:	c9                   	leave  
8010552b:	c3                   	ret    

8010552c <readeflags>:
{
8010552c:	55                   	push   %ebp
8010552d:	89 e5                	mov    %esp,%ebp
8010552f:	53                   	push   %ebx
80105530:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105533:	9c                   	pushf  
80105534:	5b                   	pop    %ebx
80105535:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80105538:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010553b:	83 c4 10             	add    $0x10,%esp
8010553e:	5b                   	pop    %ebx
8010553f:	5d                   	pop    %ebp
80105540:	c3                   	ret    

80105541 <cli>:
{
80105541:	55                   	push   %ebp
80105542:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105544:	fa                   	cli    
}
80105545:	5d                   	pop    %ebp
80105546:	c3                   	ret    

80105547 <sti>:
{
80105547:	55                   	push   %ebp
80105548:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010554a:	fb                   	sti    
}
8010554b:	5d                   	pop    %ebp
8010554c:	c3                   	ret    

8010554d <xchg>:
{
8010554d:	55                   	push   %ebp
8010554e:	89 e5                	mov    %esp,%ebp
80105550:	53                   	push   %ebx
80105551:	83 ec 10             	sub    $0x10,%esp
               "+m" (*addr), "=a" (result) :
80105554:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80105557:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
8010555a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
8010555d:	89 c3                	mov    %eax,%ebx
8010555f:	89 d8                	mov    %ebx,%eax
80105561:	f0 87 02             	lock xchg %eax,(%edx)
80105564:	89 c3                	mov    %eax,%ebx
80105566:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return result;
80105569:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010556c:	83 c4 10             	add    $0x10,%esp
8010556f:	5b                   	pop    %ebx
80105570:	5d                   	pop    %ebp
80105571:	c3                   	ret    

80105572 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105572:	55                   	push   %ebp
80105573:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80105575:	8b 45 08             	mov    0x8(%ebp),%eax
80105578:	8b 55 0c             	mov    0xc(%ebp),%edx
8010557b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010557e:	8b 45 08             	mov    0x8(%ebp),%eax
80105581:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105587:	8b 45 08             	mov    0x8(%ebp),%eax
8010558a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105591:	5d                   	pop    %ebp
80105592:	c3                   	ret    

80105593 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80105593:	55                   	push   %ebp
80105594:	89 e5                	mov    %esp,%ebp
80105596:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105599:	e8 47 01 00 00       	call   801056e5 <pushcli>
  if(holding(lk))
8010559e:	8b 45 08             	mov    0x8(%ebp),%eax
801055a1:	89 04 24             	mov    %eax,(%esp)
801055a4:	e8 12 01 00 00       	call   801056bb <holding>
801055a9:	85 c0                	test   %eax,%eax
801055ab:	74 0c                	je     801055b9 <acquire+0x26>
    panic("acquire");
801055ad:	c7 04 24 0c 92 10 80 	movl   $0x8010920c,(%esp)
801055b4:	e8 7d af ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801055b9:	90                   	nop
801055ba:	8b 45 08             	mov    0x8(%ebp),%eax
801055bd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801055c4:	00 
801055c5:	89 04 24             	mov    %eax,(%esp)
801055c8:	e8 80 ff ff ff       	call   8010554d <xchg>
801055cd:	85 c0                	test   %eax,%eax
801055cf:	75 e9                	jne    801055ba <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801055d1:	8b 45 08             	mov    0x8(%ebp),%eax
801055d4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801055db:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801055de:	8b 45 08             	mov    0x8(%ebp),%eax
801055e1:	83 c0 0c             	add    $0xc,%eax
801055e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801055e8:	8d 45 08             	lea    0x8(%ebp),%eax
801055eb:	89 04 24             	mov    %eax,(%esp)
801055ee:	e8 51 00 00 00       	call   80105644 <getcallerpcs>
}
801055f3:	c9                   	leave  
801055f4:	c3                   	ret    

801055f5 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801055f5:	55                   	push   %ebp
801055f6:	89 e5                	mov    %esp,%ebp
801055f8:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801055fb:	8b 45 08             	mov    0x8(%ebp),%eax
801055fe:	89 04 24             	mov    %eax,(%esp)
80105601:	e8 b5 00 00 00       	call   801056bb <holding>
80105606:	85 c0                	test   %eax,%eax
80105608:	75 0c                	jne    80105616 <release+0x21>
    panic("release");
8010560a:	c7 04 24 14 92 10 80 	movl   $0x80109214,(%esp)
80105611:	e8 20 af ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
80105616:	8b 45 08             	mov    0x8(%ebp),%eax
80105619:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105620:	8b 45 08             	mov    0x8(%ebp),%eax
80105623:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010562a:	8b 45 08             	mov    0x8(%ebp),%eax
8010562d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105634:	00 
80105635:	89 04 24             	mov    %eax,(%esp)
80105638:	e8 10 ff ff ff       	call   8010554d <xchg>

  popcli();
8010563d:	e8 e9 00 00 00       	call   8010572b <popcli>
}
80105642:	c9                   	leave  
80105643:	c3                   	ret    

80105644 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105644:	55                   	push   %ebp
80105645:	89 e5                	mov    %esp,%ebp
80105647:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010564a:	8b 45 08             	mov    0x8(%ebp),%eax
8010564d:	83 e8 08             	sub    $0x8,%eax
80105650:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010565a:	eb 37                	jmp    80105693 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010565c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105660:	74 51                	je     801056b3 <getcallerpcs+0x6f>
80105662:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105669:	76 48                	jbe    801056b3 <getcallerpcs+0x6f>
8010566b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010566f:	74 42                	je     801056b3 <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105671:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105674:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010567b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010567e:	01 c2                	add    %eax,%edx
80105680:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105683:	8b 40 04             	mov    0x4(%eax),%eax
80105686:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105688:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010568b:	8b 00                	mov    (%eax),%eax
8010568d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105690:	ff 45 f8             	incl   -0x8(%ebp)
80105693:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105697:	7e c3                	jle    8010565c <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105699:	eb 18                	jmp    801056b3 <getcallerpcs+0x6f>
    pcs[i] = 0;
8010569b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010569e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801056a8:	01 d0                	add    %edx,%eax
801056aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056b0:	ff 45 f8             	incl   -0x8(%ebp)
801056b3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056b7:	7e e2                	jle    8010569b <getcallerpcs+0x57>
}
801056b9:	c9                   	leave  
801056ba:	c3                   	ret    

801056bb <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801056bb:	55                   	push   %ebp
801056bc:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801056be:	8b 45 08             	mov    0x8(%ebp),%eax
801056c1:	8b 00                	mov    (%eax),%eax
801056c3:	85 c0                	test   %eax,%eax
801056c5:	74 17                	je     801056de <holding+0x23>
801056c7:	8b 45 08             	mov    0x8(%ebp),%eax
801056ca:	8b 50 08             	mov    0x8(%eax),%edx
801056cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056d3:	39 c2                	cmp    %eax,%edx
801056d5:	75 07                	jne    801056de <holding+0x23>
801056d7:	b8 01 00 00 00       	mov    $0x1,%eax
801056dc:	eb 05                	jmp    801056e3 <holding+0x28>
801056de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056e3:	5d                   	pop    %ebp
801056e4:	c3                   	ret    

801056e5 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801056e5:	55                   	push   %ebp
801056e6:	89 e5                	mov    %esp,%ebp
801056e8:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801056eb:	e8 3c fe ff ff       	call   8010552c <readeflags>
801056f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801056f3:	e8 49 fe ff ff       	call   80105541 <cli>
  if(cpu->ncli++ == 0)
801056f8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056fe:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105704:	85 d2                	test   %edx,%edx
80105706:	0f 94 c1             	sete   %cl
80105709:	42                   	inc    %edx
8010570a:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105710:	84 c9                	test   %cl,%cl
80105712:	74 15                	je     80105729 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80105714:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010571a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010571d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105723:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105729:	c9                   	leave  
8010572a:	c3                   	ret    

8010572b <popcli>:

void
popcli(void)
{
8010572b:	55                   	push   %ebp
8010572c:	89 e5                	mov    %esp,%ebp
8010572e:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105731:	e8 f6 fd ff ff       	call   8010552c <readeflags>
80105736:	25 00 02 00 00       	and    $0x200,%eax
8010573b:	85 c0                	test   %eax,%eax
8010573d:	74 0c                	je     8010574b <popcli+0x20>
    panic("popcli - interruptible");
8010573f:	c7 04 24 1c 92 10 80 	movl   $0x8010921c,(%esp)
80105746:	e8 eb ad ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
8010574b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105751:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105757:	4a                   	dec    %edx
80105758:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010575e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105764:	85 c0                	test   %eax,%eax
80105766:	79 0c                	jns    80105774 <popcli+0x49>
    panic("popcli");
80105768:	c7 04 24 33 92 10 80 	movl   $0x80109233,(%esp)
8010576f:	e8 c2 ad ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105774:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010577a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105780:	85 c0                	test   %eax,%eax
80105782:	75 15                	jne    80105799 <popcli+0x6e>
80105784:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010578a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105790:	85 c0                	test   %eax,%eax
80105792:	74 05                	je     80105799 <popcli+0x6e>
    sti();
80105794:	e8 ae fd ff ff       	call   80105547 <sti>
}
80105799:	c9                   	leave  
8010579a:	c3                   	ret    

8010579b <stosb>:
{
8010579b:	55                   	push   %ebp
8010579c:	89 e5                	mov    %esp,%ebp
8010579e:	57                   	push   %edi
8010579f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057a3:	8b 55 10             	mov    0x10(%ebp),%edx
801057a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801057a9:	89 cb                	mov    %ecx,%ebx
801057ab:	89 df                	mov    %ebx,%edi
801057ad:	89 d1                	mov    %edx,%ecx
801057af:	fc                   	cld    
801057b0:	f3 aa                	rep stos %al,%es:(%edi)
801057b2:	89 ca                	mov    %ecx,%edx
801057b4:	89 fb                	mov    %edi,%ebx
801057b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057b9:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057bc:	5b                   	pop    %ebx
801057bd:	5f                   	pop    %edi
801057be:	5d                   	pop    %ebp
801057bf:	c3                   	ret    

801057c0 <stosl>:
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801057c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057c8:	8b 55 10             	mov    0x10(%ebp),%edx
801057cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ce:	89 cb                	mov    %ecx,%ebx
801057d0:	89 df                	mov    %ebx,%edi
801057d2:	89 d1                	mov    %edx,%ecx
801057d4:	fc                   	cld    
801057d5:	f3 ab                	rep stos %eax,%es:(%edi)
801057d7:	89 ca                	mov    %ecx,%edx
801057d9:	89 fb                	mov    %edi,%ebx
801057db:	89 5d 08             	mov    %ebx,0x8(%ebp)
801057de:	89 55 10             	mov    %edx,0x10(%ebp)
}
801057e1:	5b                   	pop    %ebx
801057e2:	5f                   	pop    %edi
801057e3:	5d                   	pop    %ebp
801057e4:	c3                   	ret    

801057e5 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801057e5:	55                   	push   %ebp
801057e6:	89 e5                	mov    %esp,%ebp
801057e8:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801057eb:	8b 45 08             	mov    0x8(%ebp),%eax
801057ee:	83 e0 03             	and    $0x3,%eax
801057f1:	85 c0                	test   %eax,%eax
801057f3:	75 49                	jne    8010583e <memset+0x59>
801057f5:	8b 45 10             	mov    0x10(%ebp),%eax
801057f8:	83 e0 03             	and    $0x3,%eax
801057fb:	85 c0                	test   %eax,%eax
801057fd:	75 3f                	jne    8010583e <memset+0x59>
    c &= 0xFF;
801057ff:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105806:	8b 45 10             	mov    0x10(%ebp),%eax
80105809:	c1 e8 02             	shr    $0x2,%eax
8010580c:	89 c2                	mov    %eax,%edx
8010580e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105811:	89 c1                	mov    %eax,%ecx
80105813:	c1 e1 18             	shl    $0x18,%ecx
80105816:	8b 45 0c             	mov    0xc(%ebp),%eax
80105819:	c1 e0 10             	shl    $0x10,%eax
8010581c:	09 c1                	or     %eax,%ecx
8010581e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105821:	c1 e0 08             	shl    $0x8,%eax
80105824:	09 c8                	or     %ecx,%eax
80105826:	0b 45 0c             	or     0xc(%ebp),%eax
80105829:	89 54 24 08          	mov    %edx,0x8(%esp)
8010582d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105831:	8b 45 08             	mov    0x8(%ebp),%eax
80105834:	89 04 24             	mov    %eax,(%esp)
80105837:	e8 84 ff ff ff       	call   801057c0 <stosl>
8010583c:	eb 19                	jmp    80105857 <memset+0x72>
  } else
    stosb(dst, c, n);
8010583e:	8b 45 10             	mov    0x10(%ebp),%eax
80105841:	89 44 24 08          	mov    %eax,0x8(%esp)
80105845:	8b 45 0c             	mov    0xc(%ebp),%eax
80105848:	89 44 24 04          	mov    %eax,0x4(%esp)
8010584c:	8b 45 08             	mov    0x8(%ebp),%eax
8010584f:	89 04 24             	mov    %eax,(%esp)
80105852:	e8 44 ff ff ff       	call   8010579b <stosb>
  return dst;
80105857:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    

8010585c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010585c:	55                   	push   %ebp
8010585d:	89 e5                	mov    %esp,%ebp
8010585f:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105862:	8b 45 08             	mov    0x8(%ebp),%eax
80105865:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010586b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010586e:	eb 2c                	jmp    8010589c <memcmp+0x40>
    if(*s1 != *s2)
80105870:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105873:	8a 10                	mov    (%eax),%dl
80105875:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105878:	8a 00                	mov    (%eax),%al
8010587a:	38 c2                	cmp    %al,%dl
8010587c:	74 18                	je     80105896 <memcmp+0x3a>
      return *s1 - *s2;
8010587e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105881:	8a 00                	mov    (%eax),%al
80105883:	0f b6 d0             	movzbl %al,%edx
80105886:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105889:	8a 00                	mov    (%eax),%al
8010588b:	0f b6 c0             	movzbl %al,%eax
8010588e:	89 d1                	mov    %edx,%ecx
80105890:	29 c1                	sub    %eax,%ecx
80105892:	89 c8                	mov    %ecx,%eax
80105894:	eb 19                	jmp    801058af <memcmp+0x53>
    s1++, s2++;
80105896:	ff 45 fc             	incl   -0x4(%ebp)
80105899:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0){
8010589c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058a0:	0f 95 c0             	setne  %al
801058a3:	ff 4d 10             	decl   0x10(%ebp)
801058a6:	84 c0                	test   %al,%al
801058a8:	75 c6                	jne    80105870 <memcmp+0x14>
  }

  return 0;
801058aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058af:	c9                   	leave  
801058b0:	c3                   	ret    

801058b1 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058b1:	55                   	push   %ebp
801058b2:	89 e5                	mov    %esp,%ebp
801058b4:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801058b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801058ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801058bd:	8b 45 08             	mov    0x8(%ebp),%eax
801058c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801058c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058c9:	73 4d                	jae    80105918 <memmove+0x67>
801058cb:	8b 45 10             	mov    0x10(%ebp),%eax
801058ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
801058d1:	01 d0                	add    %edx,%eax
801058d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801058d6:	76 40                	jbe    80105918 <memmove+0x67>
    s += n;
801058d8:	8b 45 10             	mov    0x10(%ebp),%eax
801058db:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801058de:	8b 45 10             	mov    0x10(%ebp),%eax
801058e1:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801058e4:	eb 10                	jmp    801058f6 <memmove+0x45>
      *--d = *--s;
801058e6:	ff 4d f8             	decl   -0x8(%ebp)
801058e9:	ff 4d fc             	decl   -0x4(%ebp)
801058ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ef:	8a 10                	mov    (%eax),%dl
801058f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058f4:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801058f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058fa:	0f 95 c0             	setne  %al
801058fd:	ff 4d 10             	decl   0x10(%ebp)
80105900:	84 c0                	test   %al,%al
80105902:	75 e2                	jne    801058e6 <memmove+0x35>
  if(s < d && s + n > d){
80105904:	eb 21                	jmp    80105927 <memmove+0x76>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105906:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105909:	8a 10                	mov    (%eax),%dl
8010590b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010590e:	88 10                	mov    %dl,(%eax)
80105910:	ff 45 f8             	incl   -0x8(%ebp)
80105913:	ff 45 fc             	incl   -0x4(%ebp)
80105916:	eb 01                	jmp    80105919 <memmove+0x68>
    while(n-- > 0)
80105918:	90                   	nop
80105919:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010591d:	0f 95 c0             	setne  %al
80105920:	ff 4d 10             	decl   0x10(%ebp)
80105923:	84 c0                	test   %al,%al
80105925:	75 df                	jne    80105906 <memmove+0x55>

  return dst;
80105927:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010592a:	c9                   	leave  
8010592b:	c3                   	ret    

8010592c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010592c:	55                   	push   %ebp
8010592d:	89 e5                	mov    %esp,%ebp
8010592f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105932:	8b 45 10             	mov    0x10(%ebp),%eax
80105935:	89 44 24 08          	mov    %eax,0x8(%esp)
80105939:	8b 45 0c             	mov    0xc(%ebp),%eax
8010593c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105940:	8b 45 08             	mov    0x8(%ebp),%eax
80105943:	89 04 24             	mov    %eax,(%esp)
80105946:	e8 66 ff ff ff       	call   801058b1 <memmove>
}
8010594b:	c9                   	leave  
8010594c:	c3                   	ret    

8010594d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010594d:	55                   	push   %ebp
8010594e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105950:	eb 09                	jmp    8010595b <strncmp+0xe>
    n--, p++, q++;
80105952:	ff 4d 10             	decl   0x10(%ebp)
80105955:	ff 45 08             	incl   0x8(%ebp)
80105958:	ff 45 0c             	incl   0xc(%ebp)
  while(n > 0 && *p && *p == *q)
8010595b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010595f:	74 17                	je     80105978 <strncmp+0x2b>
80105961:	8b 45 08             	mov    0x8(%ebp),%eax
80105964:	8a 00                	mov    (%eax),%al
80105966:	84 c0                	test   %al,%al
80105968:	74 0e                	je     80105978 <strncmp+0x2b>
8010596a:	8b 45 08             	mov    0x8(%ebp),%eax
8010596d:	8a 10                	mov    (%eax),%dl
8010596f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105972:	8a 00                	mov    (%eax),%al
80105974:	38 c2                	cmp    %al,%dl
80105976:	74 da                	je     80105952 <strncmp+0x5>
  if(n == 0)
80105978:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010597c:	75 07                	jne    80105985 <strncmp+0x38>
    return 0;
8010597e:	b8 00 00 00 00       	mov    $0x0,%eax
80105983:	eb 16                	jmp    8010599b <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80105985:	8b 45 08             	mov    0x8(%ebp),%eax
80105988:	8a 00                	mov    (%eax),%al
8010598a:	0f b6 d0             	movzbl %al,%edx
8010598d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105990:	8a 00                	mov    (%eax),%al
80105992:	0f b6 c0             	movzbl %al,%eax
80105995:	89 d1                	mov    %edx,%ecx
80105997:	29 c1                	sub    %eax,%ecx
80105999:	89 c8                	mov    %ecx,%eax
}
8010599b:	5d                   	pop    %ebp
8010599c:	c3                   	ret    

8010599d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010599d:	55                   	push   %ebp
8010599e:	89 e5                	mov    %esp,%ebp
801059a0:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059a3:	8b 45 08             	mov    0x8(%ebp),%eax
801059a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059a9:	90                   	nop
801059aa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059ae:	0f 9f c0             	setg   %al
801059b1:	ff 4d 10             	decl   0x10(%ebp)
801059b4:	84 c0                	test   %al,%al
801059b6:	74 2b                	je     801059e3 <strncpy+0x46>
801059b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801059bb:	8a 10                	mov    (%eax),%dl
801059bd:	8b 45 08             	mov    0x8(%ebp),%eax
801059c0:	88 10                	mov    %dl,(%eax)
801059c2:	8b 45 08             	mov    0x8(%ebp),%eax
801059c5:	8a 00                	mov    (%eax),%al
801059c7:	84 c0                	test   %al,%al
801059c9:	0f 95 c0             	setne  %al
801059cc:	ff 45 08             	incl   0x8(%ebp)
801059cf:	ff 45 0c             	incl   0xc(%ebp)
801059d2:	84 c0                	test   %al,%al
801059d4:	75 d4                	jne    801059aa <strncpy+0xd>
    ;
  while(n-- > 0)
801059d6:	eb 0b                	jmp    801059e3 <strncpy+0x46>
    *s++ = 0;
801059d8:	8b 45 08             	mov    0x8(%ebp),%eax
801059db:	c6 00 00             	movb   $0x0,(%eax)
801059de:	ff 45 08             	incl   0x8(%ebp)
801059e1:	eb 01                	jmp    801059e4 <strncpy+0x47>
  while(n-- > 0)
801059e3:	90                   	nop
801059e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059e8:	0f 9f c0             	setg   %al
801059eb:	ff 4d 10             	decl   0x10(%ebp)
801059ee:	84 c0                	test   %al,%al
801059f0:	75 e6                	jne    801059d8 <strncpy+0x3b>
  return os;
801059f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059f5:	c9                   	leave  
801059f6:	c3                   	ret    

801059f7 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801059f7:	55                   	push   %ebp
801059f8:	89 e5                	mov    %esp,%ebp
801059fa:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105a00:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a07:	7f 05                	jg     80105a0e <safestrcpy+0x17>
    return os;
80105a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a0c:	eb 30                	jmp    80105a3e <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a0e:	ff 4d 10             	decl   0x10(%ebp)
80105a11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a15:	7e 1e                	jle    80105a35 <safestrcpy+0x3e>
80105a17:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a1a:	8a 10                	mov    (%eax),%dl
80105a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80105a1f:	88 10                	mov    %dl,(%eax)
80105a21:	8b 45 08             	mov    0x8(%ebp),%eax
80105a24:	8a 00                	mov    (%eax),%al
80105a26:	84 c0                	test   %al,%al
80105a28:	0f 95 c0             	setne  %al
80105a2b:	ff 45 08             	incl   0x8(%ebp)
80105a2e:	ff 45 0c             	incl   0xc(%ebp)
80105a31:	84 c0                	test   %al,%al
80105a33:	75 d9                	jne    80105a0e <safestrcpy+0x17>
    ;
  *s = 0;
80105a35:	8b 45 08             	mov    0x8(%ebp),%eax
80105a38:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    

80105a40 <strlen>:

int
strlen(const char *s)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a46:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a4d:	eb 03                	jmp    80105a52 <strlen+0x12>
80105a4f:	ff 45 fc             	incl   -0x4(%ebp)
80105a52:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a55:	8b 45 08             	mov    0x8(%ebp),%eax
80105a58:	01 d0                	add    %edx,%eax
80105a5a:	8a 00                	mov    (%eax),%al
80105a5c:	84 c0                	test   %al,%al
80105a5e:	75 ef                	jne    80105a4f <strlen+0xf>
    ;
  return n;
80105a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a63:	c9                   	leave  
80105a64:	c3                   	ret    

80105a65 <swtch>:
80105a65:	8b 44 24 04          	mov    0x4(%esp),%eax
80105a69:	8b 54 24 08          	mov    0x8(%esp),%edx
80105a6d:	55                   	push   %ebp
80105a6e:	53                   	push   %ebx
80105a6f:	56                   	push   %esi
80105a70:	57                   	push   %edi
80105a71:	89 20                	mov    %esp,(%eax)
80105a73:	89 d4                	mov    %edx,%esp
80105a75:	5f                   	pop    %edi
80105a76:	5e                   	pop    %esi
80105a77:	5b                   	pop    %ebx
80105a78:	5d                   	pop    %ebp
80105a79:	c3                   	ret    

80105a7a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105a7a:	55                   	push   %ebp
80105a7b:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105a7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a83:	8b 00                	mov    (%eax),%eax
80105a85:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a88:	76 12                	jbe    80105a9c <fetchint+0x22>
80105a8a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a8d:	8d 50 04             	lea    0x4(%eax),%edx
80105a90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a96:	8b 00                	mov    (%eax),%eax
80105a98:	39 c2                	cmp    %eax,%edx
80105a9a:	76 07                	jbe    80105aa3 <fetchint+0x29>
    return -1;
80105a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aa1:	eb 0f                	jmp    80105ab2 <fetchint+0x38>
  *ip = *(int*)(addr);
80105aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa6:	8b 10                	mov    (%eax),%edx
80105aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aab:	89 10                	mov    %edx,(%eax)
  return 0;
80105aad:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ab2:	5d                   	pop    %ebp
80105ab3:	c3                   	ret    

80105ab4 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105aba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ac0:	8b 00                	mov    (%eax),%eax
80105ac2:	3b 45 08             	cmp    0x8(%ebp),%eax
80105ac5:	77 07                	ja     80105ace <fetchstr+0x1a>
    return -1;
80105ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acc:	eb 46                	jmp    80105b14 <fetchstr+0x60>
  *pp = (char*)addr;
80105ace:	8b 55 08             	mov    0x8(%ebp),%edx
80105ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ad4:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105ad6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105adc:	8b 00                	mov    (%eax),%eax
80105ade:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ae4:	8b 00                	mov    (%eax),%eax
80105ae6:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105ae9:	eb 1c                	jmp    80105b07 <fetchstr+0x53>
    if(*s == 0)
80105aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aee:	8a 00                	mov    (%eax),%al
80105af0:	84 c0                	test   %al,%al
80105af2:	75 10                	jne    80105b04 <fetchstr+0x50>
      return s - *pp;
80105af4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105af7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105afa:	8b 00                	mov    (%eax),%eax
80105afc:	89 d1                	mov    %edx,%ecx
80105afe:	29 c1                	sub    %eax,%ecx
80105b00:	89 c8                	mov    %ecx,%eax
80105b02:	eb 10                	jmp    80105b14 <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
80105b04:	ff 45 fc             	incl   -0x4(%ebp)
80105b07:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b0d:	72 dc                	jb     80105aeb <fetchstr+0x37>
  return -1;
80105b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b14:	c9                   	leave  
80105b15:	c3                   	ret    

80105b16 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b16:	55                   	push   %ebp
80105b17:	89 e5                	mov    %esp,%ebp
80105b19:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105b1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b22:	8b 40 18             	mov    0x18(%eax),%eax
80105b25:	8b 50 44             	mov    0x44(%eax),%edx
80105b28:	8b 45 08             	mov    0x8(%ebp),%eax
80105b2b:	c1 e0 02             	shl    $0x2,%eax
80105b2e:	01 d0                	add    %edx,%eax
80105b30:	8d 50 04             	lea    0x4(%eax),%edx
80105b33:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b36:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b3a:	89 14 24             	mov    %edx,(%esp)
80105b3d:	e8 38 ff ff ff       	call   80105a7a <fetchint>
}
80105b42:	c9                   	leave  
80105b43:	c3                   	ret    

80105b44 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105b4a:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b51:	8b 45 08             	mov    0x8(%ebp),%eax
80105b54:	89 04 24             	mov    %eax,(%esp)
80105b57:	e8 ba ff ff ff       	call   80105b16 <argint>
80105b5c:	85 c0                	test   %eax,%eax
80105b5e:	79 07                	jns    80105b67 <argptr+0x23>
    return -1;
80105b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b65:	eb 3d                	jmp    80105ba4 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105b67:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b6a:	89 c2                	mov    %eax,%edx
80105b6c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b72:	8b 00                	mov    (%eax),%eax
80105b74:	39 c2                	cmp    %eax,%edx
80105b76:	73 16                	jae    80105b8e <argptr+0x4a>
80105b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b7b:	89 c2                	mov    %eax,%edx
80105b7d:	8b 45 10             	mov    0x10(%ebp),%eax
80105b80:	01 c2                	add    %eax,%edx
80105b82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b88:	8b 00                	mov    (%eax),%eax
80105b8a:	39 c2                	cmp    %eax,%edx
80105b8c:	76 07                	jbe    80105b95 <argptr+0x51>
    return -1;
80105b8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b93:	eb 0f                	jmp    80105ba4 <argptr+0x60>
  *pp = (char*)i;
80105b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b98:	89 c2                	mov    %eax,%edx
80105b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b9d:	89 10                	mov    %edx,(%eax)
  return 0;
80105b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ba4:	c9                   	leave  
80105ba5:	c3                   	ret    

80105ba6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105ba6:	55                   	push   %ebp
80105ba7:	89 e5                	mov    %esp,%ebp
80105ba9:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bac:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105baf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bb3:	8b 45 08             	mov    0x8(%ebp),%eax
80105bb6:	89 04 24             	mov    %eax,(%esp)
80105bb9:	e8 58 ff ff ff       	call   80105b16 <argint>
80105bbe:	85 c0                	test   %eax,%eax
80105bc0:	79 07                	jns    80105bc9 <argstr+0x23>
    return -1;
80105bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bc7:	eb 12                	jmp    80105bdb <argstr+0x35>
  return fetchstr(addr, pp);
80105bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bcf:	89 54 24 04          	mov    %edx,0x4(%esp)
80105bd3:	89 04 24             	mov    %eax,(%esp)
80105bd6:	e8 d9 fe ff ff       	call   80105ab4 <fetchstr>
}
80105bdb:	c9                   	leave  
80105bdc:	c3                   	ret    

80105bdd <syscall>:
[SYS_shm_get] sys_shm_get, // New: Add in project final
};

void
syscall(void)
{
80105bdd:	55                   	push   %ebp
80105bde:	89 e5                	mov    %esp,%ebp
80105be0:	53                   	push   %ebx
80105be1:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105be4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bea:	8b 40 18             	mov    0x18(%eax),%eax
80105bed:	8b 40 1c             	mov    0x1c(%eax),%eax
80105bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bf7:	7e 30                	jle    80105c29 <syscall+0x4c>
80105bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfc:	83 f8 20             	cmp    $0x20,%eax
80105bff:	77 28                	ja     80105c29 <syscall+0x4c>
80105c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c04:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c0b:	85 c0                	test   %eax,%eax
80105c0d:	74 1a                	je     80105c29 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105c0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c15:	8b 58 18             	mov    0x18(%eax),%ebx
80105c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1b:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c22:	ff d0                	call   *%eax
80105c24:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105c27:	eb 3d                	jmp    80105c66 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105c29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c2f:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105c32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105c38:	8b 40 10             	mov    0x10(%eax),%eax
80105c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c3e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105c42:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c46:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c4a:	c7 04 24 3a 92 10 80 	movl   $0x8010923a,(%esp)
80105c51:	e8 4b a7 ff ff       	call   801003a1 <cprintf>
    proc->tf->eax = -1;
80105c56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c5c:	8b 40 18             	mov    0x18(%eax),%eax
80105c5f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105c66:	83 c4 24             	add    $0x24,%esp
80105c69:	5b                   	pop    %ebx
80105c6a:	5d                   	pop    %ebp
80105c6b:	c3                   	ret    

80105c6c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105c6c:	55                   	push   %ebp
80105c6d:	89 e5                	mov    %esp,%ebp
80105c6f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105c72:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c75:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c79:	8b 45 08             	mov    0x8(%ebp),%eax
80105c7c:	89 04 24             	mov    %eax,(%esp)
80105c7f:	e8 92 fe ff ff       	call   80105b16 <argint>
80105c84:	85 c0                	test   %eax,%eax
80105c86:	79 07                	jns    80105c8f <argfd+0x23>
    return -1;
80105c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8d:	eb 50                	jmp    80105cdf <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c92:	85 c0                	test   %eax,%eax
80105c94:	78 21                	js     80105cb7 <argfd+0x4b>
80105c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c99:	83 f8 0f             	cmp    $0xf,%eax
80105c9c:	7f 19                	jg     80105cb7 <argfd+0x4b>
80105c9e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105ca7:	83 c2 08             	add    $0x8,%edx
80105caa:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cb5:	75 07                	jne    80105cbe <argfd+0x52>
    return -1;
80105cb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cbc:	eb 21                	jmp    80105cdf <argfd+0x73>
  if(pfd)
80105cbe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105cc2:	74 08                	je     80105ccc <argfd+0x60>
    *pfd = fd;
80105cc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cca:	89 10                	mov    %edx,(%eax)
  if(pf)
80105ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105cd0:	74 08                	je     80105cda <argfd+0x6e>
    *pf = f;
80105cd2:	8b 45 10             	mov    0x10(%ebp),%eax
80105cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cd8:	89 10                	mov    %edx,(%eax)
  return 0;
80105cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cdf:	c9                   	leave  
80105ce0:	c3                   	ret    

80105ce1 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105ce1:	55                   	push   %ebp
80105ce2:	89 e5                	mov    %esp,%ebp
80105ce4:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105cee:	eb 2f                	jmp    80105d1f <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105cf0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105cf6:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105cf9:	83 c2 08             	add    $0x8,%edx
80105cfc:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d00:	85 c0                	test   %eax,%eax
80105d02:	75 18                	jne    80105d1c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105d04:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d0a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d0d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d10:	8b 55 08             	mov    0x8(%ebp),%edx
80105d13:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d17:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d1a:	eb 0e                	jmp    80105d2a <fdalloc+0x49>
  for(fd = 0; fd < NOFILE; fd++){
80105d1c:	ff 45 fc             	incl   -0x4(%ebp)
80105d1f:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105d23:	7e cb                	jle    80105cf0 <fdalloc+0xf>
    }
  }
  return -1;
80105d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d2a:	c9                   	leave  
80105d2b:	c3                   	ret    

80105d2c <sys_dup>:

int
sys_dup(void)
{
80105d2c:	55                   	push   %ebp
80105d2d:	89 e5                	mov    %esp,%ebp
80105d2f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105d32:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d35:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d39:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d40:	00 
80105d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d48:	e8 1f ff ff ff       	call   80105c6c <argfd>
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	79 07                	jns    80105d58 <sys_dup+0x2c>
    return -1;
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	eb 29                	jmp    80105d81 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d5b:	89 04 24             	mov    %eax,(%esp)
80105d5e:	e8 7e ff ff ff       	call   80105ce1 <fdalloc>
80105d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d6a:	79 07                	jns    80105d73 <sys_dup+0x47>
    return -1;
80105d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d71:	eb 0e                	jmp    80105d81 <sys_dup+0x55>
  filedup(f);
80105d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d76:	89 04 24             	mov    %eax,(%esp)
80105d79:	e8 d5 b1 ff ff       	call   80100f53 <filedup>
  return fd;
80105d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105d81:	c9                   	leave  
80105d82:	c3                   	ret    

80105d83 <sys_read>:

int
sys_read(void)
{
80105d83:	55                   	push   %ebp
80105d84:	89 e5                	mov    %esp,%ebp
80105d86:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d97:	00 
80105d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d9f:	e8 c8 fe ff ff       	call   80105c6c <argfd>
80105da4:	85 c0                	test   %eax,%eax
80105da6:	78 35                	js     80105ddd <sys_read+0x5a>
80105da8:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105dab:	89 44 24 04          	mov    %eax,0x4(%esp)
80105daf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105db6:	e8 5b fd ff ff       	call   80105b16 <argint>
80105dbb:	85 c0                	test   %eax,%eax
80105dbd:	78 1e                	js     80105ddd <sys_read+0x5a>
80105dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dc6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105dc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dcd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dd4:	e8 6b fd ff ff       	call   80105b44 <argptr>
80105dd9:	85 c0                	test   %eax,%eax
80105ddb:	79 07                	jns    80105de4 <sys_read+0x61>
    return -1;
80105ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105de2:	eb 19                	jmp    80105dfd <sys_read+0x7a>
  return fileread(f, p, n);
80105de4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105de7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ded:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105df1:	89 54 24 04          	mov    %edx,0x4(%esp)
80105df5:	89 04 24             	mov    %eax,(%esp)
80105df8:	e8 b7 b2 ff ff       	call   801010b4 <fileread>
}
80105dfd:	c9                   	leave  
80105dfe:	c3                   	ret    

80105dff <sys_write>:

int
sys_write(void)
{
80105dff:	55                   	push   %ebp
80105e00:	89 e5                	mov    %esp,%ebp
80105e02:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e05:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e08:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e13:	00 
80105e14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e1b:	e8 4c fe ff ff       	call   80105c6c <argfd>
80105e20:	85 c0                	test   %eax,%eax
80105e22:	78 35                	js     80105e59 <sys_write+0x5a>
80105e24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e27:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e32:	e8 df fc ff ff       	call   80105b16 <argint>
80105e37:	85 c0                	test   %eax,%eax
80105e39:	78 1e                	js     80105e59 <sys_write+0x5a>
80105e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e42:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e45:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e50:	e8 ef fc ff ff       	call   80105b44 <argptr>
80105e55:	85 c0                	test   %eax,%eax
80105e57:	79 07                	jns    80105e60 <sys_write+0x61>
    return -1;
80105e59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e5e:	eb 19                	jmp    80105e79 <sys_write+0x7a>
  return filewrite(f, p, n);
80105e60:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e63:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e69:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105e6d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e71:	89 04 24             	mov    %eax,(%esp)
80105e74:	e8 f6 b2 ff ff       	call   8010116f <filewrite>
}
80105e79:	c9                   	leave  
80105e7a:	c3                   	ret    

80105e7b <sys_isatty>:

// Minimalish implementation of isatty for xv6. Maybe it will even work, but 
// hopefully it will be sufficient for now.
int sys_isatty(void) {
80105e7b:	55                   	push   %ebp
80105e7c:	89 e5                	mov    %esp,%ebp
80105e7e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  argfd(0, &fd, &f);
80105e81:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e84:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e96:	e8 d1 fd ff ff       	call   80105c6c <argfd>
  if (f->type == FD_INODE) {
80105e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e9e:	8b 00                	mov    (%eax),%eax
80105ea0:	83 f8 02             	cmp    $0x2,%eax
80105ea3:	75 20                	jne    80105ec5 <sys_isatty+0x4a>
    /* This is bad and wrong, but currently works. Either when more 
     * sophisticated terminal handling comes, or more devices, or both, this
     * will need to distinguish different device types. Still, it's a start. */
    if (f->ip != 0 && f->ip->type == T_DEV)
80105ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea8:	8b 40 10             	mov    0x10(%eax),%eax
80105eab:	85 c0                	test   %eax,%eax
80105ead:	74 16                	je     80105ec5 <sys_isatty+0x4a>
80105eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb2:	8b 40 10             	mov    0x10(%eax),%eax
80105eb5:	8b 40 10             	mov    0x10(%eax),%eax
80105eb8:	66 83 f8 03          	cmp    $0x3,%ax
80105ebc:	75 07                	jne    80105ec5 <sys_isatty+0x4a>
      return 1;
80105ebe:	b8 01 00 00 00       	mov    $0x1,%eax
80105ec3:	eb 05                	jmp    80105eca <sys_isatty+0x4f>
  }
  return 0;
80105ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105eca:	c9                   	leave  
80105ecb:	c3                   	ret    

80105ecc <sys_lseek>:

// lseek derived from https://github.com/hxp/xv6, written by Joel Heikkila

int sys_lseek(void) {
80105ecc:	55                   	push   %ebp
80105ecd:	89 e5                	mov    %esp,%ebp
80105ecf:	83 ec 48             	sub    $0x48,%esp
	int zerosize, i;
	char *zeroed, *z;

	struct file *f;

	argfd(0, &fd, &f);
80105ed2:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105ed5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105edc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ee0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ee7:	e8 80 fd ff ff       	call   80105c6c <argfd>
	argint(1, &offset);
80105eec:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105eef:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ef3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105efa:	e8 17 fc ff ff       	call   80105b16 <argint>
	argint(2, &base);
80105eff:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f02:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f06:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f0d:	e8 04 fc ff ff       	call   80105b16 <argint>

	if( base == SEEK_SET) {
80105f12:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f15:	85 c0                	test   %eax,%eax
80105f17:	75 06                	jne    80105f1f <sys_lseek+0x53>
		newoff = offset;
80105f19:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	if (base == SEEK_CUR)
80105f1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f22:	83 f8 01             	cmp    $0x1,%eax
80105f25:	75 0e                	jne    80105f35 <sys_lseek+0x69>
		newoff = f->off + offset;
80105f27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f2a:	8b 50 14             	mov    0x14(%eax),%edx
80105f2d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f30:	01 d0                	add    %edx,%eax
80105f32:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (base == SEEK_END)
80105f35:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f38:	83 f8 02             	cmp    $0x2,%eax
80105f3b:	75 11                	jne    80105f4e <sys_lseek+0x82>
		newoff = f->ip->size + offset;
80105f3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f40:	8b 40 10             	mov    0x10(%eax),%eax
80105f43:	8b 50 18             	mov    0x18(%eax),%edx
80105f46:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f49:	01 d0                	add    %edx,%eax
80105f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (newoff < f->ip->size)
80105f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f54:	8b 40 10             	mov    0x10(%eax),%eax
80105f57:	8b 40 18             	mov    0x18(%eax),%eax
80105f5a:	39 c2                	cmp    %eax,%edx
80105f5c:	73 0a                	jae    80105f68 <sys_lseek+0x9c>
		return -1;
80105f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f63:	e9 92 00 00 00       	jmp    80105ffa <sys_lseek+0x12e>

	if (newoff > f->ip->size){
80105f68:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f6b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f6e:	8b 40 10             	mov    0x10(%eax),%eax
80105f71:	8b 40 18             	mov    0x18(%eax),%eax
80105f74:	39 c2                	cmp    %eax,%edx
80105f76:	76 74                	jbe    80105fec <sys_lseek+0x120>
		zerosize = newoff - f->ip->size;
80105f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f7e:	8b 40 10             	mov    0x10(%eax),%eax
80105f81:	8b 40 18             	mov    0x18(%eax),%eax
80105f84:	89 d1                	mov    %edx,%ecx
80105f86:	29 c1                	sub    %eax,%ecx
80105f88:	89 c8                	mov    %ecx,%eax
80105f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		zeroed = kalloc();
80105f8d:	e8 2c cb ff ff       	call   80102abe <kalloc>
80105f92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = zeroed;
80105f95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f98:	89 45 e8             	mov    %eax,-0x18(%ebp)
		for (i = 0; i < 4096; i++)
80105f9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105fa2:	eb 0c                	jmp    80105fb0 <sys_lseek+0xe4>
			*z++ = 0;
80105fa4:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fa7:	c6 00 00             	movb   $0x0,(%eax)
80105faa:	ff 45 e8             	incl   -0x18(%ebp)
		for (i = 0; i < 4096; i++)
80105fad:	ff 45 ec             	incl   -0x14(%ebp)
80105fb0:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80105fb7:	7e eb                	jle    80105fa4 <sys_lseek+0xd8>
		while (zerosize > 0){
80105fb9:	eb 20                	jmp    80105fdb <sys_lseek+0x10f>
			filewrite(f, zeroed, zerosize);
80105fbb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105fbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105fc1:	89 54 24 08          	mov    %edx,0x8(%esp)
80105fc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105fc8:	89 54 24 04          	mov    %edx,0x4(%esp)
80105fcc:	89 04 24             	mov    %eax,(%esp)
80105fcf:	e8 9b b1 ff ff       	call   8010116f <filewrite>
			zerosize -= 4096;
80105fd4:	81 6d f0 00 10 00 00 	subl   $0x1000,-0x10(%ebp)
		while (zerosize > 0){
80105fdb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fdf:	7f da                	jg     80105fbb <sys_lseek+0xef>
		}
		kfree(zeroed);
80105fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe4:	89 04 24             	mov    %eax,(%esp)
80105fe7:	e8 39 ca ff ff       	call   80102a25 <kfree>
	}

	f->off = newoff;
80105fec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105fef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ff2:	89 50 14             	mov    %edx,0x14(%eax)
	return 0;
80105ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ffa:	c9                   	leave  
80105ffb:	c3                   	ret    

80105ffc <sys_close>:

int
sys_close(void)
{
80105ffc:	55                   	push   %ebp
80105ffd:	89 e5                	mov    %esp,%ebp
80105fff:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80106002:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106005:	89 44 24 08          	mov    %eax,0x8(%esp)
80106009:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106010:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106017:	e8 50 fc ff ff       	call   80105c6c <argfd>
8010601c:	85 c0                	test   %eax,%eax
8010601e:	79 07                	jns    80106027 <sys_close+0x2b>
    return -1;
80106020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106025:	eb 24                	jmp    8010604b <sys_close+0x4f>
  proc->ofile[fd] = 0;
80106027:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010602d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106030:	83 c2 08             	add    $0x8,%edx
80106033:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010603a:	00 
  fileclose(f);
8010603b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603e:	89 04 24             	mov    %eax,(%esp)
80106041:	e8 55 af ff ff       	call   80100f9b <fileclose>
  return 0;
80106046:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010604b:	c9                   	leave  
8010604c:	c3                   	ret    

8010604d <sys_fstat>:

int
sys_fstat(void)
{
8010604d:	55                   	push   %ebp
8010604e:	89 e5                	mov    %esp,%ebp
80106050:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106053:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106056:	89 44 24 08          	mov    %eax,0x8(%esp)
8010605a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106061:	00 
80106062:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106069:	e8 fe fb ff ff       	call   80105c6c <argfd>
8010606e:	85 c0                	test   %eax,%eax
80106070:	78 1f                	js     80106091 <sys_fstat+0x44>
80106072:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80106079:	00 
8010607a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010607d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106081:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106088:	e8 b7 fa ff ff       	call   80105b44 <argptr>
8010608d:	85 c0                	test   %eax,%eax
8010608f:	79 07                	jns    80106098 <sys_fstat+0x4b>
    return -1;
80106091:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106096:	eb 12                	jmp    801060aa <sys_fstat+0x5d>
  return filestat(f, st);
80106098:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010609b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010609e:	89 54 24 04          	mov    %edx,0x4(%esp)
801060a2:	89 04 24             	mov    %eax,(%esp)
801060a5:	e8 bb af ff ff       	call   80101065 <filestat>
}
801060aa:	c9                   	leave  
801060ab:	c3                   	ret    

801060ac <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801060ac:	55                   	push   %ebp
801060ad:	89 e5                	mov    %esp,%ebp
801060af:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801060b2:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801060b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060c0:	e8 e1 fa ff ff       	call   80105ba6 <argstr>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	78 17                	js     801060e0 <sys_link+0x34>
801060c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
801060cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060d7:	e8 ca fa ff ff       	call   80105ba6 <argstr>
801060dc:	85 c0                	test   %eax,%eax
801060de:	79 0a                	jns    801060ea <sys_link+0x3e>
    return -1;
801060e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e5:	e9 37 01 00 00       	jmp    80106221 <sys_link+0x175>
  if((ip = namei(old)) == 0)
801060ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
801060ed:	89 04 24             	mov    %eax,(%esp)
801060f0:	e8 ea c2 ff ff       	call   801023df <namei>
801060f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060fc:	75 0a                	jne    80106108 <sys_link+0x5c>
    return -1;
801060fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106103:	e9 19 01 00 00       	jmp    80106221 <sys_link+0x175>

  begin_trans();
80106108:	e8 c3 d0 ff ff       	call   801031d0 <begin_trans>

  ilock(ip);
8010610d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106110:	89 04 24             	mov    %eax,(%esp)
80106113:	e8 2d b7 ff ff       	call   80101845 <ilock>
  if(ip->type == T_DIR){
80106118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611b:	8b 40 10             	mov    0x10(%eax),%eax
8010611e:	66 83 f8 01          	cmp    $0x1,%ax
80106122:	75 1a                	jne    8010613e <sys_link+0x92>
    iunlockput(ip);
80106124:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106127:	89 04 24             	mov    %eax,(%esp)
8010612a:	e8 97 b9 ff ff       	call   80101ac6 <iunlockput>
    commit_trans();
8010612f:	e8 e5 d0 ff ff       	call   80103219 <commit_trans>
    return -1;
80106134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106139:	e9 e3 00 00 00       	jmp    80106221 <sys_link+0x175>
  }

  ip->nlink++;
8010613e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106141:	66 8b 40 16          	mov    0x16(%eax),%ax
80106145:	40                   	inc    %eax
80106146:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106149:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010614d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106150:	89 04 24             	mov    %eax,(%esp)
80106153:	e8 33 b5 ff ff       	call   8010168b <iupdate>
  iunlock(ip);
80106158:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010615b:	89 04 24             	mov    %eax,(%esp)
8010615e:	e8 2d b8 ff ff       	call   80101990 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80106163:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106166:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106169:	89 54 24 04          	mov    %edx,0x4(%esp)
8010616d:	89 04 24             	mov    %eax,(%esp)
80106170:	e8 8c c2 ff ff       	call   80102401 <nameiparent>
80106175:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010617c:	74 68                	je     801061e6 <sys_link+0x13a>
    goto bad;
  ilock(dp);
8010617e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106181:	89 04 24             	mov    %eax,(%esp)
80106184:	e8 bc b6 ff ff       	call   80101845 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106189:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618c:	8b 10                	mov    (%eax),%edx
8010618e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106191:	8b 00                	mov    (%eax),%eax
80106193:	39 c2                	cmp    %eax,%edx
80106195:	75 20                	jne    801061b7 <sys_link+0x10b>
80106197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619a:	8b 40 04             	mov    0x4(%eax),%eax
8010619d:	89 44 24 08          	mov    %eax,0x8(%esp)
801061a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801061a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ab:	89 04 24             	mov    %eax,(%esp)
801061ae:	e8 75 bf ff ff       	call   80102128 <dirlink>
801061b3:	85 c0                	test   %eax,%eax
801061b5:	79 0d                	jns    801061c4 <sys_link+0x118>
    iunlockput(dp);
801061b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ba:	89 04 24             	mov    %eax,(%esp)
801061bd:	e8 04 b9 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
801061c2:	eb 23                	jmp    801061e7 <sys_link+0x13b>
  }
  iunlockput(dp);
801061c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c7:	89 04 24             	mov    %eax,(%esp)
801061ca:	e8 f7 b8 ff ff       	call   80101ac6 <iunlockput>
  iput(ip);
801061cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d2:	89 04 24             	mov    %eax,(%esp)
801061d5:	e8 1b b8 ff ff       	call   801019f5 <iput>

  commit_trans();
801061da:	e8 3a d0 ff ff       	call   80103219 <commit_trans>

  return 0;
801061df:	b8 00 00 00 00       	mov    $0x0,%eax
801061e4:	eb 3b                	jmp    80106221 <sys_link+0x175>
    goto bad;
801061e6:	90                   	nop

bad:
  ilock(ip);
801061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ea:	89 04 24             	mov    %eax,(%esp)
801061ed:	e8 53 b6 ff ff       	call   80101845 <ilock>
  ip->nlink--;
801061f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f5:	66 8b 40 16          	mov    0x16(%eax),%ax
801061f9:	48                   	dec    %eax
801061fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061fd:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80106201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106204:	89 04 24             	mov    %eax,(%esp)
80106207:	e8 7f b4 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
8010620c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620f:	89 04 24             	mov    %eax,(%esp)
80106212:	e8 af b8 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80106217:	e8 fd cf ff ff       	call   80103219 <commit_trans>
  return -1;
8010621c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106221:	c9                   	leave  
80106222:	c3                   	ret    

80106223 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106223:	55                   	push   %ebp
80106224:	89 e5                	mov    %esp,%ebp
80106226:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106229:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106230:	eb 4a                	jmp    8010627c <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106235:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010623c:	00 
8010623d:	89 44 24 08          	mov    %eax,0x8(%esp)
80106241:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106244:	89 44 24 04          	mov    %eax,0x4(%esp)
80106248:	8b 45 08             	mov    0x8(%ebp),%eax
8010624b:	89 04 24             	mov    %eax,(%esp)
8010624e:	e8 f9 ba ff ff       	call   80101d4c <readi>
80106253:	83 f8 10             	cmp    $0x10,%eax
80106256:	74 0c                	je     80106264 <isdirempty+0x41>
      panic("isdirempty: readi");
80106258:	c7 04 24 56 92 10 80 	movl   $0x80109256,(%esp)
8010625f:	e8 d2 a2 ff ff       	call   80100536 <panic>
    if(de.inum != 0)
80106264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106267:	66 85 c0             	test   %ax,%ax
8010626a:	74 07                	je     80106273 <isdirempty+0x50>
      return 0;
8010626c:	b8 00 00 00 00       	mov    $0x0,%eax
80106271:	eb 1b                	jmp    8010628e <isdirempty+0x6b>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106273:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106276:	83 c0 10             	add    $0x10,%eax
80106279:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010627c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010627f:	8b 45 08             	mov    0x8(%ebp),%eax
80106282:	8b 40 18             	mov    0x18(%eax),%eax
80106285:	39 c2                	cmp    %eax,%edx
80106287:	72 a9                	jb     80106232 <isdirempty+0xf>
  }
  return 1;
80106289:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010628e:	c9                   	leave  
8010628f:	c3                   	ret    

80106290 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106296:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062a4:	e8 fd f8 ff ff       	call   80105ba6 <argstr>
801062a9:	85 c0                	test   %eax,%eax
801062ab:	79 0a                	jns    801062b7 <sys_unlink+0x27>
    return -1;
801062ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b2:	e9 a4 01 00 00       	jmp    8010645b <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
801062b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
801062ba:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801062bd:	89 54 24 04          	mov    %edx,0x4(%esp)
801062c1:	89 04 24             	mov    %eax,(%esp)
801062c4:	e8 38 c1 ff ff       	call   80102401 <nameiparent>
801062c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062d0:	75 0a                	jne    801062dc <sys_unlink+0x4c>
    return -1;
801062d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062d7:	e9 7f 01 00 00       	jmp    8010645b <sys_unlink+0x1cb>

  begin_trans();
801062dc:	e8 ef ce ff ff       	call   801031d0 <begin_trans>

  ilock(dp);
801062e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062e4:	89 04 24             	mov    %eax,(%esp)
801062e7:	e8 59 b5 ff ff       	call   80101845 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801062ec:	c7 44 24 04 68 92 10 	movl   $0x80109268,0x4(%esp)
801062f3:	80 
801062f4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801062f7:	89 04 24             	mov    %eax,(%esp)
801062fa:	e8 42 bd ff ff       	call   80102041 <namecmp>
801062ff:	85 c0                	test   %eax,%eax
80106301:	0f 84 3f 01 00 00    	je     80106446 <sys_unlink+0x1b6>
80106307:	c7 44 24 04 6a 92 10 	movl   $0x8010926a,0x4(%esp)
8010630e:	80 
8010630f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106312:	89 04 24             	mov    %eax,(%esp)
80106315:	e8 27 bd ff ff       	call   80102041 <namecmp>
8010631a:	85 c0                	test   %eax,%eax
8010631c:	0f 84 24 01 00 00    	je     80106446 <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106322:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106325:	89 44 24 08          	mov    %eax,0x8(%esp)
80106329:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010632c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106333:	89 04 24             	mov    %eax,(%esp)
80106336:	e8 28 bd ff ff       	call   80102063 <dirlookup>
8010633b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010633e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106342:	0f 84 fd 00 00 00    	je     80106445 <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80106348:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010634b:	89 04 24             	mov    %eax,(%esp)
8010634e:	e8 f2 b4 ff ff       	call   80101845 <ilock>

  if(ip->nlink < 1)
80106353:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106356:	66 8b 40 16          	mov    0x16(%eax),%ax
8010635a:	66 85 c0             	test   %ax,%ax
8010635d:	7f 0c                	jg     8010636b <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
8010635f:	c7 04 24 6d 92 10 80 	movl   $0x8010926d,(%esp)
80106366:	e8 cb a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010636b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636e:	8b 40 10             	mov    0x10(%eax),%eax
80106371:	66 83 f8 01          	cmp    $0x1,%ax
80106375:	75 1f                	jne    80106396 <sys_unlink+0x106>
80106377:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010637a:	89 04 24             	mov    %eax,(%esp)
8010637d:	e8 a1 fe ff ff       	call   80106223 <isdirempty>
80106382:	85 c0                	test   %eax,%eax
80106384:	75 10                	jne    80106396 <sys_unlink+0x106>
    iunlockput(ip);
80106386:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106389:	89 04 24             	mov    %eax,(%esp)
8010638c:	e8 35 b7 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
80106391:	e9 b0 00 00 00       	jmp    80106446 <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
80106396:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010639d:	00 
8010639e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063a5:	00 
801063a6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063a9:	89 04 24             	mov    %eax,(%esp)
801063ac:	e8 34 f4 ff ff       	call   801057e5 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063b4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801063bb:	00 
801063bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801063c0:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ca:	89 04 24             	mov    %eax,(%esp)
801063cd:	e8 df ba ff ff       	call   80101eb1 <writei>
801063d2:	83 f8 10             	cmp    $0x10,%eax
801063d5:	74 0c                	je     801063e3 <sys_unlink+0x153>
    panic("unlink: writei");
801063d7:	c7 04 24 7f 92 10 80 	movl   $0x8010927f,(%esp)
801063de:	e8 53 a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
801063e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e6:	8b 40 10             	mov    0x10(%eax),%eax
801063e9:	66 83 f8 01          	cmp    $0x1,%ax
801063ed:	75 1a                	jne    80106409 <sys_unlink+0x179>
    dp->nlink--;
801063ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f2:	66 8b 40 16          	mov    0x16(%eax),%ax
801063f6:	48                   	dec    %eax
801063f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063fa:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
801063fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106401:	89 04 24             	mov    %eax,(%esp)
80106404:	e8 82 b2 ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
80106409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640c:	89 04 24             	mov    %eax,(%esp)
8010640f:	e8 b2 b6 ff ff       	call   80101ac6 <iunlockput>

  ip->nlink--;
80106414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106417:	66 8b 40 16          	mov    0x16(%eax),%ax
8010641b:	48                   	dec    %eax
8010641c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010641f:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80106423:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106426:	89 04 24             	mov    %eax,(%esp)
80106429:	e8 5d b2 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
8010642e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106431:	89 04 24             	mov    %eax,(%esp)
80106434:	e8 8d b6 ff ff       	call   80101ac6 <iunlockput>

  commit_trans();
80106439:	e8 db cd ff ff       	call   80103219 <commit_trans>

  return 0;
8010643e:	b8 00 00 00 00       	mov    $0x0,%eax
80106443:	eb 16                	jmp    8010645b <sys_unlink+0x1cb>
    goto bad;
80106445:	90                   	nop

bad:
  iunlockput(dp);
80106446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106449:	89 04 24             	mov    %eax,(%esp)
8010644c:	e8 75 b6 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80106451:	e8 c3 cd ff ff       	call   80103219 <commit_trans>
  return -1;
80106456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010645b:	c9                   	leave  
8010645c:	c3                   	ret    

8010645d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010645d:	55                   	push   %ebp
8010645e:	89 e5                	mov    %esp,%ebp
80106460:	83 ec 48             	sub    $0x48,%esp
80106463:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106466:	8b 55 10             	mov    0x10(%ebp),%edx
80106469:	8b 45 14             	mov    0x14(%ebp),%eax
8010646c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106470:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106474:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106478:	8d 45 de             	lea    -0x22(%ebp),%eax
8010647b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010647f:	8b 45 08             	mov    0x8(%ebp),%eax
80106482:	89 04 24             	mov    %eax,(%esp)
80106485:	e8 77 bf ff ff       	call   80102401 <nameiparent>
8010648a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010648d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106491:	75 0a                	jne    8010649d <create+0x40>
    return 0;
80106493:	b8 00 00 00 00       	mov    $0x0,%eax
80106498:	e9 79 01 00 00       	jmp    80106616 <create+0x1b9>
  ilock(dp);
8010649d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064a0:	89 04 24             	mov    %eax,(%esp)
801064a3:	e8 9d b3 ff ff       	call   80101845 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801064a8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801064af:	8d 45 de             	lea    -0x22(%ebp),%eax
801064b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801064b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b9:	89 04 24             	mov    %eax,(%esp)
801064bc:	e8 a2 bb ff ff       	call   80102063 <dirlookup>
801064c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064c8:	74 46                	je     80106510 <create+0xb3>
    iunlockput(dp);
801064ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064cd:	89 04 24             	mov    %eax,(%esp)
801064d0:	e8 f1 b5 ff ff       	call   80101ac6 <iunlockput>
    ilock(ip);
801064d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d8:	89 04 24             	mov    %eax,(%esp)
801064db:	e8 65 b3 ff ff       	call   80101845 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801064e0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801064e5:	75 14                	jne    801064fb <create+0x9e>
801064e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ea:	8b 40 10             	mov    0x10(%eax),%eax
801064ed:	66 83 f8 02          	cmp    $0x2,%ax
801064f1:	75 08                	jne    801064fb <create+0x9e>
      return ip;
801064f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064f6:	e9 1b 01 00 00       	jmp    80106616 <create+0x1b9>
    iunlockput(ip);
801064fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fe:	89 04 24             	mov    %eax,(%esp)
80106501:	e8 c0 b5 ff ff       	call   80101ac6 <iunlockput>
    return 0;
80106506:	b8 00 00 00 00       	mov    $0x0,%eax
8010650b:	e9 06 01 00 00       	jmp    80106616 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106510:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106514:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106517:	8b 00                	mov    (%eax),%eax
80106519:	89 54 24 04          	mov    %edx,0x4(%esp)
8010651d:	89 04 24             	mov    %eax,(%esp)
80106520:	e8 7e b0 ff ff       	call   801015a3 <ialloc>
80106525:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106528:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010652c:	75 0c                	jne    8010653a <create+0xdd>
    panic("create: ialloc");
8010652e:	c7 04 24 8e 92 10 80 	movl   $0x8010928e,(%esp)
80106535:	e8 fc 9f ff ff       	call   80100536 <panic>

  ilock(ip);
8010653a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010653d:	89 04 24             	mov    %eax,(%esp)
80106540:	e8 00 b3 ff ff       	call   80101845 <ilock>
  ip->major = major;
80106545:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106548:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010654b:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
8010654f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106552:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106555:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80106559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010655c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106562:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106565:	89 04 24             	mov    %eax,(%esp)
80106568:	e8 1e b1 ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010656d:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106572:	75 68                	jne    801065dc <create+0x17f>
    dp->nlink++;  // for ".."
80106574:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106577:	66 8b 40 16          	mov    0x16(%eax),%ax
8010657b:	40                   	inc    %eax
8010657c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010657f:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80106583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106586:	89 04 24             	mov    %eax,(%esp)
80106589:	e8 fd b0 ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010658e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106591:	8b 40 04             	mov    0x4(%eax),%eax
80106594:	89 44 24 08          	mov    %eax,0x8(%esp)
80106598:	c7 44 24 04 68 92 10 	movl   $0x80109268,0x4(%esp)
8010659f:	80 
801065a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a3:	89 04 24             	mov    %eax,(%esp)
801065a6:	e8 7d bb ff ff       	call   80102128 <dirlink>
801065ab:	85 c0                	test   %eax,%eax
801065ad:	78 21                	js     801065d0 <create+0x173>
801065af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b2:	8b 40 04             	mov    0x4(%eax),%eax
801065b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801065b9:	c7 44 24 04 6a 92 10 	movl   $0x8010926a,0x4(%esp)
801065c0:	80 
801065c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065c4:	89 04 24             	mov    %eax,(%esp)
801065c7:	e8 5c bb ff ff       	call   80102128 <dirlink>
801065cc:	85 c0                	test   %eax,%eax
801065ce:	79 0c                	jns    801065dc <create+0x17f>
      panic("create dots");
801065d0:	c7 04 24 9d 92 10 80 	movl   $0x8010929d,(%esp)
801065d7:	e8 5a 9f ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801065dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065df:	8b 40 04             	mov    0x4(%eax),%eax
801065e2:	89 44 24 08          	mov    %eax,0x8(%esp)
801065e6:	8d 45 de             	lea    -0x22(%ebp),%eax
801065e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801065ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f0:	89 04 24             	mov    %eax,(%esp)
801065f3:	e8 30 bb ff ff       	call   80102128 <dirlink>
801065f8:	85 c0                	test   %eax,%eax
801065fa:	79 0c                	jns    80106608 <create+0x1ab>
    panic("create: dirlink");
801065fc:	c7 04 24 a9 92 10 80 	movl   $0x801092a9,(%esp)
80106603:	e8 2e 9f ff ff       	call   80100536 <panic>

  iunlockput(dp);
80106608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660b:	89 04 24             	mov    %eax,(%esp)
8010660e:	e8 b3 b4 ff ff       	call   80101ac6 <iunlockput>

  return ip;
80106613:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106616:	c9                   	leave  
80106617:	c3                   	ret    

80106618 <sys_open>:

int
sys_open(void)
{
80106618:	55                   	push   %ebp
80106619:	89 e5                	mov    %esp,%ebp
8010661b:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010661e:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106621:	89 44 24 04          	mov    %eax,0x4(%esp)
80106625:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010662c:	e8 75 f5 ff ff       	call   80105ba6 <argstr>
80106631:	85 c0                	test   %eax,%eax
80106633:	78 17                	js     8010664c <sys_open+0x34>
80106635:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106638:	89 44 24 04          	mov    %eax,0x4(%esp)
8010663c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106643:	e8 ce f4 ff ff       	call   80105b16 <argint>
80106648:	85 c0                	test   %eax,%eax
8010664a:	79 0a                	jns    80106656 <sys_open+0x3e>
    return -1;
8010664c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106651:	e9 47 01 00 00       	jmp    8010679d <sys_open+0x185>
  if(omode & O_CREATE){
80106656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106659:	25 00 02 00 00       	and    $0x200,%eax
8010665e:	85 c0                	test   %eax,%eax
80106660:	74 40                	je     801066a2 <sys_open+0x8a>
    begin_trans();
80106662:	e8 69 cb ff ff       	call   801031d0 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80106667:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010666a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106671:	00 
80106672:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106679:	00 
8010667a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106681:	00 
80106682:	89 04 24             	mov    %eax,(%esp)
80106685:	e8 d3 fd ff ff       	call   8010645d <create>
8010668a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
8010668d:	e8 87 cb ff ff       	call   80103219 <commit_trans>
    if(ip == 0)
80106692:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106696:	75 5b                	jne    801066f3 <sys_open+0xdb>
      return -1;
80106698:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669d:	e9 fb 00 00 00       	jmp    8010679d <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
801066a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066a5:	89 04 24             	mov    %eax,(%esp)
801066a8:	e8 32 bd ff ff       	call   801023df <namei>
801066ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066b4:	75 0a                	jne    801066c0 <sys_open+0xa8>
      return -1;
801066b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066bb:	e9 dd 00 00 00       	jmp    8010679d <sys_open+0x185>
    ilock(ip);
801066c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c3:	89 04 24             	mov    %eax,(%esp)
801066c6:	e8 7a b1 ff ff       	call   80101845 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801066cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ce:	8b 40 10             	mov    0x10(%eax),%eax
801066d1:	66 83 f8 01          	cmp    $0x1,%ax
801066d5:	75 1c                	jne    801066f3 <sys_open+0xdb>
801066d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066da:	85 c0                	test   %eax,%eax
801066dc:	74 15                	je     801066f3 <sys_open+0xdb>
      iunlockput(ip);
801066de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e1:	89 04 24             	mov    %eax,(%esp)
801066e4:	e8 dd b3 ff ff       	call   80101ac6 <iunlockput>
      return -1;
801066e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066ee:	e9 aa 00 00 00       	jmp    8010679d <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801066f3:	e8 fb a7 ff ff       	call   80100ef3 <filealloc>
801066f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066ff:	74 14                	je     80106715 <sys_open+0xfd>
80106701:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106704:	89 04 24             	mov    %eax,(%esp)
80106707:	e8 d5 f5 ff ff       	call   80105ce1 <fdalloc>
8010670c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010670f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106713:	79 23                	jns    80106738 <sys_open+0x120>
    if(f)
80106715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106719:	74 0b                	je     80106726 <sys_open+0x10e>
      fileclose(f);
8010671b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010671e:	89 04 24             	mov    %eax,(%esp)
80106721:	e8 75 a8 ff ff       	call   80100f9b <fileclose>
    iunlockput(ip);
80106726:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106729:	89 04 24             	mov    %eax,(%esp)
8010672c:	e8 95 b3 ff ff       	call   80101ac6 <iunlockput>
    return -1;
80106731:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106736:	eb 65                	jmp    8010679d <sys_open+0x185>
  }
  iunlock(ip);
80106738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673b:	89 04 24             	mov    %eax,(%esp)
8010673e:	e8 4d b2 ff ff       	call   80101990 <iunlock>

  f->type = FD_INODE;
80106743:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106746:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010674c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010674f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106752:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106758:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010675f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106762:	83 e0 01             	and    $0x1,%eax
80106765:	85 c0                	test   %eax,%eax
80106767:	0f 94 c0             	sete   %al
8010676a:	88 c2                	mov    %al,%dl
8010676c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010676f:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106775:	83 e0 01             	and    $0x1,%eax
80106778:	85 c0                	test   %eax,%eax
8010677a:	75 0a                	jne    80106786 <sys_open+0x16e>
8010677c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010677f:	83 e0 02             	and    $0x2,%eax
80106782:	85 c0                	test   %eax,%eax
80106784:	74 07                	je     8010678d <sys_open+0x175>
80106786:	b8 01 00 00 00       	mov    $0x1,%eax
8010678b:	eb 05                	jmp    80106792 <sys_open+0x17a>
8010678d:	b8 00 00 00 00       	mov    $0x0,%eax
80106792:	88 c2                	mov    %al,%dl
80106794:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106797:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010679a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010679d:	c9                   	leave  
8010679e:	c3                   	ret    

8010679f <sys_mkdir>:

int
sys_mkdir(void)
{
8010679f:	55                   	push   %ebp
801067a0:	89 e5                	mov    %esp,%ebp
801067a2:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801067a5:	e8 26 ca ff ff       	call   801031d0 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801067aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801067b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067b8:	e8 e9 f3 ff ff       	call   80105ba6 <argstr>
801067bd:	85 c0                	test   %eax,%eax
801067bf:	78 2c                	js     801067ed <sys_mkdir+0x4e>
801067c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801067cb:	00 
801067cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801067d3:	00 
801067d4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801067db:	00 
801067dc:	89 04 24             	mov    %eax,(%esp)
801067df:	e8 79 fc ff ff       	call   8010645d <create>
801067e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801067e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067eb:	75 0c                	jne    801067f9 <sys_mkdir+0x5a>
    commit_trans();
801067ed:	e8 27 ca ff ff       	call   80103219 <commit_trans>
    return -1;
801067f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f7:	eb 15                	jmp    8010680e <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801067f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067fc:	89 04 24             	mov    %eax,(%esp)
801067ff:	e8 c2 b2 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80106804:	e8 10 ca ff ff       	call   80103219 <commit_trans>
  return 0;
80106809:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010680e:	c9                   	leave  
8010680f:	c3                   	ret    

80106810 <sys_mknod>:

int
sys_mknod(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106816:	e8 b5 c9 ff ff       	call   801031d0 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
8010681b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010681e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106822:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106829:	e8 78 f3 ff ff       	call   80105ba6 <argstr>
8010682e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106835:	78 5e                	js     80106895 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106837:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010683a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010683e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106845:	e8 cc f2 ff ff       	call   80105b16 <argint>
  if((len=argstr(0, &path)) < 0 ||
8010684a:	85 c0                	test   %eax,%eax
8010684c:	78 47                	js     80106895 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
8010684e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106851:	89 44 24 04          	mov    %eax,0x4(%esp)
80106855:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010685c:	e8 b5 f2 ff ff       	call   80105b16 <argint>
     argint(1, &major) < 0 ||
80106861:	85 c0                	test   %eax,%eax
80106863:	78 30                	js     80106895 <sys_mknod+0x85>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106868:	0f bf c8             	movswl %ax,%ecx
8010686b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010686e:	0f bf d0             	movswl %ax,%edx
80106871:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80106874:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106878:	89 54 24 08          	mov    %edx,0x8(%esp)
8010687c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106883:	00 
80106884:	89 04 24             	mov    %eax,(%esp)
80106887:	e8 d1 fb ff ff       	call   8010645d <create>
8010688c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010688f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106893:	75 0c                	jne    801068a1 <sys_mknod+0x91>
    commit_trans();
80106895:	e8 7f c9 ff ff       	call   80103219 <commit_trans>
    return -1;
8010689a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010689f:	eb 15                	jmp    801068b6 <sys_mknod+0xa6>
  }
  iunlockput(ip);
801068a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068a4:	89 04 24             	mov    %eax,(%esp)
801068a7:	e8 1a b2 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
801068ac:	e8 68 c9 ff ff       	call   80103219 <commit_trans>
  return 0;
801068b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068b6:	c9                   	leave  
801068b7:	c3                   	ret    

801068b8 <sys_chdir>:

int
sys_chdir(void)
{
801068b8:	55                   	push   %ebp
801068b9:	89 e5                	mov    %esp,%ebp
801068bb:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801068be:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801068c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068cc:	e8 d5 f2 ff ff       	call   80105ba6 <argstr>
801068d1:	85 c0                	test   %eax,%eax
801068d3:	78 14                	js     801068e9 <sys_chdir+0x31>
801068d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068d8:	89 04 24             	mov    %eax,(%esp)
801068db:	e8 ff ba ff ff       	call   801023df <namei>
801068e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068e7:	75 07                	jne    801068f0 <sys_chdir+0x38>
    return -1;
801068e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068ee:	eb 56                	jmp    80106946 <sys_chdir+0x8e>
  ilock(ip);
801068f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f3:	89 04 24             	mov    %eax,(%esp)
801068f6:	e8 4a af ff ff       	call   80101845 <ilock>
  if(ip->type != T_DIR){
801068fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068fe:	8b 40 10             	mov    0x10(%eax),%eax
80106901:	66 83 f8 01          	cmp    $0x1,%ax
80106905:	74 12                	je     80106919 <sys_chdir+0x61>
    iunlockput(ip);
80106907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010690a:	89 04 24             	mov    %eax,(%esp)
8010690d:	e8 b4 b1 ff ff       	call   80101ac6 <iunlockput>
    return -1;
80106912:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106917:	eb 2d                	jmp    80106946 <sys_chdir+0x8e>
  }
  iunlock(ip);
80106919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010691c:	89 04 24             	mov    %eax,(%esp)
8010691f:	e8 6c b0 ff ff       	call   80101990 <iunlock>
  iput(proc->cwd);
80106924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010692a:	8b 40 68             	mov    0x68(%eax),%eax
8010692d:	89 04 24             	mov    %eax,(%esp)
80106930:	e8 c0 b0 ff ff       	call   801019f5 <iput>
  proc->cwd = ip;
80106935:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010693b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010693e:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106941:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106946:	c9                   	leave  
80106947:	c3                   	ret    

80106948 <sys_exec>:

int
sys_exec(void)
{
80106948:	55                   	push   %ebp
80106949:	89 e5                	mov    %esp,%ebp
8010694b:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106951:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106954:	89 44 24 04          	mov    %eax,0x4(%esp)
80106958:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010695f:	e8 42 f2 ff ff       	call   80105ba6 <argstr>
80106964:	85 c0                	test   %eax,%eax
80106966:	78 1a                	js     80106982 <sys_exec+0x3a>
80106968:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010696e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106979:	e8 98 f1 ff ff       	call   80105b16 <argint>
8010697e:	85 c0                	test   %eax,%eax
80106980:	79 0a                	jns    8010698c <sys_exec+0x44>
    return -1;
80106982:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106987:	e9 c7 00 00 00       	jmp    80106a53 <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
8010698c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106993:	00 
80106994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010699b:	00 
8010699c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069a2:	89 04 24             	mov    %eax,(%esp)
801069a5:	e8 3b ee ff ff       	call   801057e5 <memset>
  for(i=0;; i++){
801069aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801069b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069b4:	83 f8 1f             	cmp    $0x1f,%eax
801069b7:	76 0a                	jbe    801069c3 <sys_exec+0x7b>
      return -1;
801069b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069be:	e9 90 00 00 00       	jmp    80106a53 <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801069c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c6:	c1 e0 02             	shl    $0x2,%eax
801069c9:	89 c2                	mov    %eax,%edx
801069cb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801069d1:	01 c2                	add    %eax,%edx
801069d3:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801069d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801069dd:	89 14 24             	mov    %edx,(%esp)
801069e0:	e8 95 f0 ff ff       	call   80105a7a <fetchint>
801069e5:	85 c0                	test   %eax,%eax
801069e7:	79 07                	jns    801069f0 <sys_exec+0xa8>
      return -1;
801069e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069ee:	eb 63                	jmp    80106a53 <sys_exec+0x10b>
    if(uarg == 0){
801069f0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801069f6:	85 c0                	test   %eax,%eax
801069f8:	75 26                	jne    80106a20 <sys_exec+0xd8>
      argv[i] = 0;
801069fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069fd:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106a04:	00 00 00 00 
      break;
80106a08:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a0c:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106a12:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a16:	89 04 24             	mov    %eax,(%esp)
80106a19:	e8 ad a0 ff ff       	call   80100acb <exec>
80106a1e:	eb 33                	jmp    80106a53 <sys_exec+0x10b>
    if(fetchstr(uarg, &argv[i]) < 0)
80106a20:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a26:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a29:	c1 e2 02             	shl    $0x2,%edx
80106a2c:	01 c2                	add    %eax,%edx
80106a2e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a34:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a38:	89 04 24             	mov    %eax,(%esp)
80106a3b:	e8 74 f0 ff ff       	call   80105ab4 <fetchstr>
80106a40:	85 c0                	test   %eax,%eax
80106a42:	79 07                	jns    80106a4b <sys_exec+0x103>
      return -1;
80106a44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a49:	eb 08                	jmp    80106a53 <sys_exec+0x10b>
  for(i=0;; i++){
80106a4b:	ff 45 f4             	incl   -0xc(%ebp)
  }
80106a4e:	e9 5e ff ff ff       	jmp    801069b1 <sys_exec+0x69>
}
80106a53:	c9                   	leave  
80106a54:	c3                   	ret    

80106a55 <sys_pipe>:

int
sys_pipe(void)
{
80106a55:	55                   	push   %ebp
80106a56:	89 e5                	mov    %esp,%ebp
80106a58:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106a5b:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106a62:	00 
80106a63:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a66:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a71:	e8 ce f0 ff ff       	call   80105b44 <argptr>
80106a76:	85 c0                	test   %eax,%eax
80106a78:	79 0a                	jns    80106a84 <sys_pipe+0x2f>
    return -1;
80106a7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a7f:	e9 9b 00 00 00       	jmp    80106b1f <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106a84:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a8b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106a8e:	89 04 24             	mov    %eax,(%esp)
80106a91:	e8 7c d1 ff ff       	call   80103c12 <pipealloc>
80106a96:	85 c0                	test   %eax,%eax
80106a98:	79 07                	jns    80106aa1 <sys_pipe+0x4c>
    return -1;
80106a9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a9f:	eb 7e                	jmp    80106b1f <sys_pipe+0xca>
  fd0 = -1;
80106aa1:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106aab:	89 04 24             	mov    %eax,(%esp)
80106aae:	e8 2e f2 ff ff       	call   80105ce1 <fdalloc>
80106ab3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ab6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106aba:	78 14                	js     80106ad0 <sys_pipe+0x7b>
80106abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106abf:	89 04 24             	mov    %eax,(%esp)
80106ac2:	e8 1a f2 ff ff       	call   80105ce1 <fdalloc>
80106ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106aca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ace:	79 37                	jns    80106b07 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ad4:	78 14                	js     80106aea <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106ad6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106adf:	83 c2 08             	add    $0x8,%edx
80106ae2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106ae9:	00 
    fileclose(rf);
80106aea:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106aed:	89 04 24             	mov    %eax,(%esp)
80106af0:	e8 a6 a4 ff ff       	call   80100f9b <fileclose>
    fileclose(wf);
80106af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106af8:	89 04 24             	mov    %eax,(%esp)
80106afb:	e8 9b a4 ff ff       	call   80100f9b <fileclose>
    return -1;
80106b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b05:	eb 18                	jmp    80106b1f <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b0d:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b12:	8d 50 04             	lea    0x4(%eax),%edx
80106b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b18:	89 02                	mov    %eax,(%edx)
  return 0;
80106b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b1f:	c9                   	leave  
80106b20:	c3                   	ret    

80106b21 <sys_fork>:
#include "proc.h"
#include "semaphore.h"

int
sys_fork(void)
{
80106b21:	55                   	push   %ebp
80106b22:	89 e5                	mov    %esp,%ebp
80106b24:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106b27:	e8 6f d9 ff ff       	call   8010449b <fork>
}
80106b2c:	c9                   	leave  
80106b2d:	c3                   	ret    

80106b2e <sys_exit>:

int
sys_exit(void)
{
80106b2e:	55                   	push   %ebp
80106b2f:	89 e5                	mov    %esp,%ebp
80106b31:	83 ec 08             	sub    $0x8,%esp
  exit();
80106b34:	e8 e6 da ff ff       	call   8010461f <exit>
  return 0;  // not reached
80106b39:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b3e:	c9                   	leave  
80106b3f:	c3                   	ret    

80106b40 <sys_wait>:

int
sys_wait(void)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106b46:	e8 74 dc ff ff       	call   801047bf <wait>
}
80106b4b:	c9                   	leave  
80106b4c:	c3                   	ret    

80106b4d <sys_kill>:

int
sys_kill(void)
{
80106b4d:	55                   	push   %ebp
80106b4e:	89 e5                	mov    %esp,%ebp
80106b50:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b53:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b56:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b61:	e8 b0 ef ff ff       	call   80105b16 <argint>
80106b66:	85 c0                	test   %eax,%eax
80106b68:	79 07                	jns    80106b71 <sys_kill+0x24>
    return -1;
80106b6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b6f:	eb 0b                	jmp    80106b7c <sys_kill+0x2f>
  return kill(pid);
80106b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b74:	89 04 24             	mov    %eax,(%esp)
80106b77:	e8 82 e0 ff ff       	call   80104bfe <kill>
}
80106b7c:	c9                   	leave  
80106b7d:	c3                   	ret    

80106b7e <sys_getpid>:

int
sys_getpid(void)
{
80106b7e:	55                   	push   %ebp
80106b7f:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b81:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b87:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b8a:	5d                   	pop    %ebp
80106b8b:	c3                   	ret    

80106b8c <sys_sbrk>:

int
sys_sbrk(void)
{
80106b8c:	55                   	push   %ebp
80106b8d:	89 e5                	mov    %esp,%ebp
80106b8f:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b92:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b95:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ba0:	e8 71 ef ff ff       	call   80105b16 <argint>
80106ba5:	85 c0                	test   %eax,%eax
80106ba7:	79 07                	jns    80106bb0 <sys_sbrk+0x24>
    return -1;
80106ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bae:	eb 24                	jmp    80106bd4 <sys_sbrk+0x48>
  addr = proc->sz;
80106bb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bb6:	8b 00                	mov    (%eax),%eax
80106bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106bbe:	89 04 24             	mov    %eax,(%esp)
80106bc1:	e8 30 d8 ff ff       	call   801043f6 <growproc>
80106bc6:	85 c0                	test   %eax,%eax
80106bc8:	79 07                	jns    80106bd1 <sys_sbrk+0x45>
    return -1;
80106bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bcf:	eb 03                	jmp    80106bd4 <sys_sbrk+0x48>
  return addr;
80106bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106bd4:	c9                   	leave  
80106bd5:	c3                   	ret    

80106bd6 <sys_sleep>:

int
sys_sleep(void)
{
80106bd6:	55                   	push   %ebp
80106bd7:	89 e5                	mov    %esp,%ebp
80106bd9:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106bdc:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
80106be3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106bea:	e8 27 ef ff ff       	call   80105b16 <argint>
80106bef:	85 c0                	test   %eax,%eax
80106bf1:	79 07                	jns    80106bfa <sys_sleep+0x24>
    return -1;
80106bf3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf8:	eb 6c                	jmp    80106c66 <sys_sleep+0x90>
  acquire(&tickslock);
80106bfa:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c01:	e8 8d e9 ff ff       	call   80105593 <acquire>
  ticks0 = ticks;
80106c06:	a1 60 44 11 80       	mov    0x80114460,%eax
80106c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106c0e:	eb 34                	jmp    80106c44 <sys_sleep+0x6e>
    if(proc->killed){
80106c10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c16:	8b 40 24             	mov    0x24(%eax),%eax
80106c19:	85 c0                	test   %eax,%eax
80106c1b:	74 13                	je     80106c30 <sys_sleep+0x5a>
      release(&tickslock);
80106c1d:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c24:	e8 cc e9 ff ff       	call   801055f5 <release>
      return -1;
80106c29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c2e:	eb 36                	jmp    80106c66 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106c30:	c7 44 24 04 20 3c 11 	movl   $0x80113c20,0x4(%esp)
80106c37:	80 
80106c38:	c7 04 24 60 44 11 80 	movl   $0x80114460,(%esp)
80106c3f:	e8 87 de ff ff       	call   80104acb <sleep>
  while(ticks - ticks0 < n){
80106c44:	a1 60 44 11 80       	mov    0x80114460,%eax
80106c49:	89 c2                	mov    %eax,%edx
80106c4b:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c51:	39 c2                	cmp    %eax,%edx
80106c53:	72 bb                	jb     80106c10 <sys_sleep+0x3a>
  }
  release(&tickslock);
80106c55:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c5c:	e8 94 e9 ff ff       	call   801055f5 <release>
  return 0;
80106c61:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c66:	c9                   	leave  
80106c67:	c3                   	ret    

80106c68 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c68:	55                   	push   %ebp
80106c69:	89 e5                	mov    %esp,%ebp
80106c6b:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c6e:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c75:	e8 19 e9 ff ff       	call   80105593 <acquire>
  xticks = ticks;
80106c7a:	a1 60 44 11 80       	mov    0x80114460,%eax
80106c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c82:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106c89:	e8 67 e9 ff ff       	call   801055f5 <release>
  return xticks;
80106c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c91:	c9                   	leave  
80106c92:	c3                   	ret    

80106c93 <sys_procstat>:

// New: Add in proyect 1: implementation of system call procstat
int
sys_procstat(void){             
80106c93:	55                   	push   %ebp
80106c94:	89 e5                	mov    %esp,%ebp
80106c96:	83 ec 08             	sub    $0x8,%esp
  procdump(); // Print a process listing to console.
80106c99:	e8 e4 df ff ff       	call   80104c82 <procdump>
  return 0; 
80106c9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ca3:	c9                   	leave  
80106ca4:	c3                   	ret    

80106ca5 <sys_set_priority>:

// New: Add in project 2: implementation of syscall set_priority
int
sys_set_priority(void){
80106ca5:	55                   	push   %ebp
80106ca6:	89 e5                	mov    %esp,%ebp
80106ca8:	83 ec 28             	sub    $0x28,%esp
  int pr;
  argint(0, &pr);
80106cab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cb9:	e8 58 ee ff ff       	call   80105b16 <argint>
  proc->priority=pr;
80106cbe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106cc7:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106ccd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cd2:	c9                   	leave  
80106cd3:	c3                   	ret    

80106cd4 <sys_semget>:

// New: Add in project final - (semaphore)
int
sys_semget(void)
{
80106cd4:	55                   	push   %ebp
80106cd5:	89 e5                	mov    %esp,%ebp
80106cd7:	83 ec 28             	sub    $0x28,%esp
  int semid, init_value;
  if( argint(1, &init_value) < 0 || argint(0, &semid) < 0)
80106cda:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ce1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ce8:	e8 29 ee ff ff       	call   80105b16 <argint>
80106ced:	85 c0                	test   %eax,%eax
80106cef:	78 17                	js     80106d08 <sys_semget+0x34>
80106cf1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cff:	e8 12 ee ff ff       	call   80105b16 <argint>
80106d04:	85 c0                	test   %eax,%eax
80106d06:	79 07                	jns    80106d0f <sys_semget+0x3b>
    return -1;
80106d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d0d:	eb 12                	jmp    80106d21 <sys_semget+0x4d>
  return semget(semid,init_value);
80106d0f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d15:	89 54 24 04          	mov    %edx,0x4(%esp)
80106d19:	89 04 24             	mov    %eax,(%esp)
80106d1c:	e8 b2 e0 ff ff       	call   80104dd3 <semget>
}
80106d21:	c9                   	leave  
80106d22:	c3                   	ret    

80106d23 <sys_semfree>:

// New: Add in project final - (semaphore)
int 
sys_semfree(void)
{
80106d23:	55                   	push   %ebp
80106d24:	89 e5                	mov    %esp,%ebp
80106d26:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106d29:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d37:	e8 da ed ff ff       	call   80105b16 <argint>
80106d3c:	85 c0                	test   %eax,%eax
80106d3e:	79 07                	jns    80106d47 <sys_semfree+0x24>
    return -1;
80106d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d45:	eb 0b                	jmp    80106d52 <sys_semfree+0x2f>
  return semfree(semid);
80106d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d4a:	89 04 24             	mov    %eax,(%esp)
80106d4d:	e8 de e1 ff ff       	call   80104f30 <semfree>
}
80106d52:	c9                   	leave  
80106d53:	c3                   	ret    

80106d54 <sys_semdown>:

// New: Add in project final - (semaphore)
int 
sys_semdown(void)
{
80106d54:	55                   	push   %ebp
80106d55:	89 e5                	mov    %esp,%ebp
80106d57:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106d5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d68:	e8 a9 ed ff ff       	call   80105b16 <argint>
80106d6d:	85 c0                	test   %eax,%eax
80106d6f:	79 07                	jns    80106d78 <sys_semdown+0x24>
    return -1;
80106d71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d76:	eb 0b                	jmp    80106d83 <sys_semdown+0x2f>
  return semdown(semid);
80106d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d7b:	89 04 24             	mov    %eax,(%esp)
80106d7e:	e8 44 e2 ff ff       	call   80104fc7 <semdown>
}
80106d83:	c9                   	leave  
80106d84:	c3                   	ret    

80106d85 <sys_semup>:

// New: Add in project final - (semaphore)
int 
sys_semup(void)
{
80106d85:	55                   	push   %ebp
80106d86:	89 e5                	mov    %esp,%ebp
80106d88:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106d8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d99:	e8 78 ed ff ff       	call   80105b16 <argint>
80106d9e:	85 c0                	test   %eax,%eax
80106da0:	79 07                	jns    80106da9 <sys_semup+0x24>
    return -1;
80106da2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106da7:	eb 0b                	jmp    80106db4 <sys_semup+0x2f>
  return semup(semid);
80106da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dac:	89 04 24             	mov    %eax,(%esp)
80106daf:	e8 95 e2 ff ff       	call   80105049 <semup>
}
80106db4:	c9                   	leave  
80106db5:	c3                   	ret    

80106db6 <outb>:
{
80106db6:	55                   	push   %ebp
80106db7:	89 e5                	mov    %esp,%ebp
80106db9:	83 ec 08             	sub    $0x8,%esp
80106dbc:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dc2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106dc6:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106dc9:	8a 45 f8             	mov    -0x8(%ebp),%al
80106dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106dcf:	ee                   	out    %al,(%dx)
}
80106dd0:	c9                   	leave  
80106dd1:	c3                   	ret    

80106dd2 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106dd2:	55                   	push   %ebp
80106dd3:	89 e5                	mov    %esp,%ebp
80106dd5:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106dd8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106ddf:	00 
80106de0:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106de7:	e8 ca ff ff ff       	call   80106db6 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106dec:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106df3:	00 
80106df4:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106dfb:	e8 b6 ff ff ff       	call   80106db6 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106e00:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106e07:	00 
80106e08:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106e0f:	e8 a2 ff ff ff       	call   80106db6 <outb>
  picenable(IRQ_TIMER);
80106e14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e1b:	e8 81 cc ff ff       	call   80103aa1 <picenable>
}
80106e20:	c9                   	leave  
80106e21:	c3                   	ret    

80106e22 <alltraps>:
80106e22:	1e                   	push   %ds
80106e23:	06                   	push   %es
80106e24:	0f a0                	push   %fs
80106e26:	0f a8                	push   %gs
80106e28:	60                   	pusha  
80106e29:	66 b8 10 00          	mov    $0x10,%ax
80106e2d:	8e d8                	mov    %eax,%ds
80106e2f:	8e c0                	mov    %eax,%es
80106e31:	66 b8 18 00          	mov    $0x18,%ax
80106e35:	8e e0                	mov    %eax,%fs
80106e37:	8e e8                	mov    %eax,%gs
80106e39:	54                   	push   %esp
80106e3a:	e8 c4 01 00 00       	call   80107003 <trap>
80106e3f:	83 c4 04             	add    $0x4,%esp

80106e42 <trapret>:
80106e42:	61                   	popa   
80106e43:	0f a9                	pop    %gs
80106e45:	0f a1                	pop    %fs
80106e47:	07                   	pop    %es
80106e48:	1f                   	pop    %ds
80106e49:	83 c4 08             	add    $0x8,%esp
80106e4c:	cf                   	iret   

80106e4d <lidt>:
{
80106e4d:	55                   	push   %ebp
80106e4e:	89 e5                	mov    %esp,%ebp
80106e50:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106e53:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e56:	48                   	dec    %eax
80106e57:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e5e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106e62:	8b 45 08             	mov    0x8(%ebp),%eax
80106e65:	c1 e8 10             	shr    $0x10,%eax
80106e68:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106e6c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106e6f:	0f 01 18             	lidtl  (%eax)
}
80106e72:	c9                   	leave  
80106e73:	c3                   	ret    

80106e74 <rcr2>:

static inline uint
rcr2(void)
{
80106e74:	55                   	push   %ebp
80106e75:	89 e5                	mov    %esp,%ebp
80106e77:	53                   	push   %ebx
80106e78:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106e7b:	0f 20 d3             	mov    %cr2,%ebx
80106e7e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106e84:	83 c4 10             	add    $0x10,%esp
80106e87:	5b                   	pop    %ebx
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    

80106e8a <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106e8a:	55                   	push   %ebp
80106e8b:	89 e5                	mov    %esp,%ebp
80106e8d:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106e90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e97:	e9 b8 00 00 00       	jmp    80106f54 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e9f:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106ea6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ea9:	66 89 04 d5 60 3c 11 	mov    %ax,-0x7feec3a0(,%edx,8)
80106eb0:	80 
80106eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb4:	66 c7 04 c5 62 3c 11 	movw   $0x8,-0x7feec39e(,%eax,8)
80106ebb:	80 08 00 
80106ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec1:	8a 14 c5 64 3c 11 80 	mov    -0x7feec39c(,%eax,8),%dl
80106ec8:	83 e2 e0             	and    $0xffffffe0,%edx
80106ecb:	88 14 c5 64 3c 11 80 	mov    %dl,-0x7feec39c(,%eax,8)
80106ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ed5:	8a 14 c5 64 3c 11 80 	mov    -0x7feec39c(,%eax,8),%dl
80106edc:	83 e2 1f             	and    $0x1f,%edx
80106edf:	88 14 c5 64 3c 11 80 	mov    %dl,-0x7feec39c(,%eax,8)
80106ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee9:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106ef0:	83 e2 f0             	and    $0xfffffff0,%edx
80106ef3:	83 ca 0e             	or     $0xe,%edx
80106ef6:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f00:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f07:	83 e2 ef             	and    $0xffffffef,%edx
80106f0a:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f14:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f1b:	83 e2 9f             	and    $0xffffff9f,%edx
80106f1e:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f28:	8a 14 c5 65 3c 11 80 	mov    -0x7feec39b(,%eax,8),%dl
80106f2f:	83 ca 80             	or     $0xffffff80,%edx
80106f32:	88 14 c5 65 3c 11 80 	mov    %dl,-0x7feec39b(,%eax,8)
80106f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3c:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106f43:	c1 e8 10             	shr    $0x10,%eax
80106f46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f49:	66 89 04 d5 66 3c 11 	mov    %ax,-0x7feec39a(,%edx,8)
80106f50:	80 
  for(i = 0; i < 256; i++)
80106f51:	ff 45 f4             	incl   -0xc(%ebp)
80106f54:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106f5b:	0f 8e 3b ff ff ff    	jle    80106e9c <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f61:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80106f66:	66 a3 60 3e 11 80    	mov    %ax,0x80113e60
80106f6c:	66 c7 05 62 3e 11 80 	movw   $0x8,0x80113e62
80106f73:	08 00 
80106f75:	a0 64 3e 11 80       	mov    0x80113e64,%al
80106f7a:	83 e0 e0             	and    $0xffffffe0,%eax
80106f7d:	a2 64 3e 11 80       	mov    %al,0x80113e64
80106f82:	a0 64 3e 11 80       	mov    0x80113e64,%al
80106f87:	83 e0 1f             	and    $0x1f,%eax
80106f8a:	a2 64 3e 11 80       	mov    %al,0x80113e64
80106f8f:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106f94:	83 c8 0f             	or     $0xf,%eax
80106f97:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106f9c:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106fa1:	83 e0 ef             	and    $0xffffffef,%eax
80106fa4:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fa9:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106fae:	83 c8 60             	or     $0x60,%eax
80106fb1:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fb6:	a0 65 3e 11 80       	mov    0x80113e65,%al
80106fbb:	83 c8 80             	or     $0xffffff80,%eax
80106fbe:	a2 65 3e 11 80       	mov    %al,0x80113e65
80106fc3:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80106fc8:	c1 e8 10             	shr    $0x10,%eax
80106fcb:	66 a3 66 3e 11 80    	mov    %ax,0x80113e66
  
  initlock(&tickslock, "time");
80106fd1:	c7 44 24 04 bc 92 10 	movl   $0x801092bc,0x4(%esp)
80106fd8:	80 
80106fd9:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80106fe0:	e8 8d e5 ff ff       	call   80105572 <initlock>
}
80106fe5:	c9                   	leave  
80106fe6:	c3                   	ret    

80106fe7 <idtinit>:

void
idtinit(void)
{
80106fe7:	55                   	push   %ebp
80106fe8:	89 e5                	mov    %esp,%ebp
80106fea:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106fed:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106ff4:	00 
80106ff5:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80106ffc:	e8 4c fe ff ff       	call   80106e4d <lidt>
}
80107001:	c9                   	leave  
80107002:	c3                   	ret    

80107003 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107003:	55                   	push   %ebp
80107004:	89 e5                	mov    %esp,%ebp
80107006:	57                   	push   %edi
80107007:	56                   	push   %esi
80107008:	53                   	push   %ebx
80107009:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
8010700c:	8b 45 08             	mov    0x8(%ebp),%eax
8010700f:	8b 40 30             	mov    0x30(%eax),%eax
80107012:	83 f8 40             	cmp    $0x40,%eax
80107015:	75 3e                	jne    80107055 <trap+0x52>
    if(proc->killed)
80107017:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701d:	8b 40 24             	mov    0x24(%eax),%eax
80107020:	85 c0                	test   %eax,%eax
80107022:	74 05                	je     80107029 <trap+0x26>
      exit();
80107024:	e8 f6 d5 ff ff       	call   8010461f <exit>
    proc->tf = tf;
80107029:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010702f:	8b 55 08             	mov    0x8(%ebp),%edx
80107032:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107035:	e8 a3 eb ff ff       	call   80105bdd <syscall>
    if(proc->killed)
8010703a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107040:	8b 40 24             	mov    0x24(%eax),%eax
80107043:	85 c0                	test   %eax,%eax
80107045:	0f 84 3f 02 00 00    	je     8010728a <trap+0x287>
      exit();
8010704b:	e8 cf d5 ff ff       	call   8010461f <exit>
    return;
80107050:	e9 35 02 00 00       	jmp    8010728a <trap+0x287>
  }

  switch(tf->trapno){
80107055:	8b 45 08             	mov    0x8(%ebp),%eax
80107058:	8b 40 30             	mov    0x30(%eax),%eax
8010705b:	83 e8 20             	sub    $0x20,%eax
8010705e:	83 f8 1f             	cmp    $0x1f,%eax
80107061:	0f 87 b7 00 00 00    	ja     8010711e <trap+0x11b>
80107067:	8b 04 85 64 93 10 80 	mov    -0x7fef6c9c(,%eax,4),%eax
8010706e:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80107070:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107076:	8a 00                	mov    (%eax),%al
80107078:	84 c0                	test   %al,%al
8010707a:	75 2f                	jne    801070ab <trap+0xa8>
      acquire(&tickslock);
8010707c:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
80107083:	e8 0b e5 ff ff       	call   80105593 <acquire>
      ticks++;
80107088:	a1 60 44 11 80       	mov    0x80114460,%eax
8010708d:	40                   	inc    %eax
8010708e:	a3 60 44 11 80       	mov    %eax,0x80114460
      wakeup(&ticks);
80107093:	c7 04 24 60 44 11 80 	movl   $0x80114460,(%esp)
8010709a:	e8 34 db ff ff       	call   80104bd3 <wakeup>
      release(&tickslock);
8010709f:	c7 04 24 20 3c 11 80 	movl   $0x80113c20,(%esp)
801070a6:	e8 4a e5 ff ff       	call   801055f5 <release>
    }
    lapiceoi();
801070ab:	e8 ef bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070b0:	e9 3c 01 00 00       	jmp    801071f1 <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801070b5:	e8 03 b6 ff ff       	call   801026bd <ideintr>
    lapiceoi();
801070ba:	e8 e0 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070bf:	e9 2d 01 00 00       	jmp    801071f1 <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801070c4:	e8 b9 bb ff ff       	call   80102c82 <kbdintr>
    lapiceoi();
801070c9:	e8 d1 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070ce:	e9 1e 01 00 00       	jmp    801071f1 <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801070d3:	e8 af 03 00 00       	call   80107487 <uartintr>
    lapiceoi();
801070d8:	e8 c2 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070dd:	e9 0f 01 00 00       	jmp    801071f1 <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801070e2:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070e5:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801070e8:	8b 45 08             	mov    0x8(%ebp),%eax
801070eb:	8b 40 3c             	mov    0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070ee:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801070f1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070f7:	8a 00                	mov    (%eax),%al
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070f9:	0f b6 c0             	movzbl %al,%eax
801070fc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107100:	89 54 24 08          	mov    %edx,0x8(%esp)
80107104:	89 44 24 04          	mov    %eax,0x4(%esp)
80107108:	c7 04 24 c4 92 10 80 	movl   $0x801092c4,(%esp)
8010710f:	e8 8d 92 ff ff       	call   801003a1 <cprintf>
    lapiceoi();
80107114:	e8 86 bd ff ff       	call   80102e9f <lapiceoi>
    break;
80107119:	e9 d3 00 00 00       	jmp    801071f1 <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010711e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107124:	85 c0                	test   %eax,%eax
80107126:	74 10                	je     80107138 <trap+0x135>
80107128:	8b 45 08             	mov    0x8(%ebp),%eax
8010712b:	8b 40 3c             	mov    0x3c(%eax),%eax
8010712e:	0f b7 c0             	movzwl %ax,%eax
80107131:	83 e0 03             	and    $0x3,%eax
80107134:	85 c0                	test   %eax,%eax
80107136:	75 45                	jne    8010717d <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107138:	e8 37 fd ff ff       	call   80106e74 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
8010713d:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107140:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107143:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010714a:	8a 12                	mov    (%edx),%dl
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010714c:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010714f:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107152:	8b 52 30             	mov    0x30(%edx),%edx
80107155:	89 44 24 10          	mov    %eax,0x10(%esp)
80107159:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010715d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107161:	89 54 24 04          	mov    %edx,0x4(%esp)
80107165:	c7 04 24 e8 92 10 80 	movl   $0x801092e8,(%esp)
8010716c:	e8 30 92 ff ff       	call   801003a1 <cprintf>
      panic("trap");
80107171:	c7 04 24 1a 93 10 80 	movl   $0x8010931a,(%esp)
80107178:	e8 b9 93 ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010717d:	e8 f2 fc ff ff       	call   80106e74 <rcr2>
80107182:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107184:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107187:	8b 78 38             	mov    0x38(%eax),%edi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010718a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107190:	8a 00                	mov    (%eax),%al
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107192:	0f b6 f0             	movzbl %al,%esi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107195:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107198:	8b 58 34             	mov    0x34(%eax),%ebx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010719b:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010719e:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071a7:	83 c0 6c             	add    $0x6c,%eax
801071aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071b3:	8b 40 10             	mov    0x10(%eax),%eax
801071b6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801071ba:	89 7c 24 18          	mov    %edi,0x18(%esp)
801071be:	89 74 24 14          	mov    %esi,0x14(%esp)
801071c2:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801071c6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801071ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071cd:	89 54 24 08          	mov    %edx,0x8(%esp)
801071d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801071d5:	c7 04 24 20 93 10 80 	movl   $0x80109320,(%esp)
801071dc:	e8 c0 91 ff ff       	call   801003a1 <cprintf>
            rcr2());
    proc->killed = 1;
801071e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801071ee:	eb 01                	jmp    801071f1 <trap+0x1ee>
    break;
801071f0:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071f7:	85 c0                	test   %eax,%eax
801071f9:	74 23                	je     8010721e <trap+0x21b>
801071fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107201:	8b 40 24             	mov    0x24(%eax),%eax
80107204:	85 c0                	test   %eax,%eax
80107206:	74 16                	je     8010721e <trap+0x21b>
80107208:	8b 45 08             	mov    0x8(%ebp),%eax
8010720b:	8b 40 3c             	mov    0x3c(%eax),%eax
8010720e:	0f b7 c0             	movzwl %ax,%eax
80107211:	83 e0 03             	and    $0x3,%eax
80107214:	83 f8 03             	cmp    $0x3,%eax
80107217:	75 05                	jne    8010721e <trap+0x21b>
    exit();
80107219:	e8 01 d4 ff ff       	call   8010461f <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER && ++(proc->ticksProc) == QUANTUM) {
8010721e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107224:	85 c0                	test   %eax,%eax
80107226:	74 33                	je     8010725b <trap+0x258>
80107228:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010722e:	8b 40 0c             	mov    0xc(%eax),%eax
80107231:	83 f8 04             	cmp    $0x4,%eax
80107234:	75 25                	jne    8010725b <trap+0x258>
80107236:	8b 45 08             	mov    0x8(%ebp),%eax
80107239:	8b 40 30             	mov    0x30(%eax),%eax
8010723c:	83 f8 20             	cmp    $0x20,%eax
8010723f:	75 1a                	jne    8010725b <trap+0x258>
80107241:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107247:	8b 50 7c             	mov    0x7c(%eax),%edx
8010724a:	42                   	inc    %edx
8010724b:	89 50 7c             	mov    %edx,0x7c(%eax)
8010724e:	8b 40 7c             	mov    0x7c(%eax),%eax
80107251:	83 f8 06             	cmp    $0x6,%eax
80107254:	75 05                	jne    8010725b <trap+0x258>
      // del proyecto 0
      // cprintf("tamaño del quantum: %d\n", QUANTUM);
      // cprintf("cantidad de ticks del proceso: %d\n", proc->ticksProc);
      // cprintf("nombre del proceso: %s\n", proc->name);
      // cprintf("abandone cpu\n");
      yield();
80107256:	e8 e5 d7 ff ff       	call   80104a40 <yield>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010725b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107261:	85 c0                	test   %eax,%eax
80107263:	74 26                	je     8010728b <trap+0x288>
80107265:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010726b:	8b 40 24             	mov    0x24(%eax),%eax
8010726e:	85 c0                	test   %eax,%eax
80107270:	74 19                	je     8010728b <trap+0x288>
80107272:	8b 45 08             	mov    0x8(%ebp),%eax
80107275:	8b 40 3c             	mov    0x3c(%eax),%eax
80107278:	0f b7 c0             	movzwl %ax,%eax
8010727b:	83 e0 03             	and    $0x3,%eax
8010727e:	83 f8 03             	cmp    $0x3,%eax
80107281:	75 08                	jne    8010728b <trap+0x288>
    exit();
80107283:	e8 97 d3 ff ff       	call   8010461f <exit>
80107288:	eb 01                	jmp    8010728b <trap+0x288>
    return;
8010728a:	90                   	nop
}
8010728b:	83 c4 3c             	add    $0x3c,%esp
8010728e:	5b                   	pop    %ebx
8010728f:	5e                   	pop    %esi
80107290:	5f                   	pop    %edi
80107291:	5d                   	pop    %ebp
80107292:	c3                   	ret    

80107293 <inb>:
{
80107293:	55                   	push   %ebp
80107294:	89 e5                	mov    %esp,%ebp
80107296:	53                   	push   %ebx
80107297:	83 ec 14             	sub    $0x14,%esp
8010729a:	8b 45 08             	mov    0x8(%ebp),%eax
8010729d:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801072a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
801072a4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801072a8:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801072ac:	ec                   	in     (%dx),%al
801072ad:	88 c3                	mov    %al,%bl
801072af:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801072b2:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801072b5:	83 c4 14             	add    $0x14,%esp
801072b8:	5b                   	pop    %ebx
801072b9:	5d                   	pop    %ebp
801072ba:	c3                   	ret    

801072bb <outb>:
{
801072bb:	55                   	push   %ebp
801072bc:	89 e5                	mov    %esp,%ebp
801072be:	83 ec 08             	sub    $0x8,%esp
801072c1:	8b 45 08             	mov    0x8(%ebp),%eax
801072c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801072c7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801072cb:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801072ce:	8a 45 f8             	mov    -0x8(%ebp),%al
801072d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801072d4:	ee                   	out    %al,(%dx)
}
801072d5:	c9                   	leave  
801072d6:	c3                   	ret    

801072d7 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801072d7:	55                   	push   %ebp
801072d8:	89 e5                	mov    %esp,%ebp
801072da:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801072dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072e4:	00 
801072e5:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801072ec:	e8 ca ff ff ff       	call   801072bb <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801072f1:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801072f8:	00 
801072f9:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107300:	e8 b6 ff ff ff       	call   801072bb <outb>
  outb(COM1+0, 115200/9600);
80107305:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010730c:	00 
8010730d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107314:	e8 a2 ff ff ff       	call   801072bb <outb>
  outb(COM1+1, 0);
80107319:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107320:	00 
80107321:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107328:	e8 8e ff ff ff       	call   801072bb <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010732d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80107334:	00 
80107335:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
8010733c:	e8 7a ff ff ff       	call   801072bb <outb>
  outb(COM1+4, 0);
80107341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107348:	00 
80107349:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107350:	e8 66 ff ff ff       	call   801072bb <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107355:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010735c:	00 
8010735d:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107364:	e8 52 ff ff ff       	call   801072bb <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107369:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107370:	e8 1e ff ff ff       	call   80107293 <inb>
80107375:	3c ff                	cmp    $0xff,%al
80107377:	74 69                	je     801073e2 <uartinit+0x10b>
    return;
  uart = 1;
80107379:	c7 05 8c c6 10 80 01 	movl   $0x1,0x8010c68c
80107380:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107383:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010738a:	e8 04 ff ff ff       	call   80107293 <inb>
  inb(COM1+0);
8010738f:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107396:	e8 f8 fe ff ff       	call   80107293 <inb>
  picenable(IRQ_COM1);
8010739b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801073a2:	e8 fa c6 ff ff       	call   80103aa1 <picenable>
  ioapicenable(IRQ_COM1, 0);
801073a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073ae:	00 
801073af:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801073b6:	e8 7f b5 ff ff       	call   8010293a <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801073bb:	c7 45 f4 e4 93 10 80 	movl   $0x801093e4,-0xc(%ebp)
801073c2:	eb 13                	jmp    801073d7 <uartinit+0x100>
    uartputc(*p);
801073c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c7:	8a 00                	mov    (%eax),%al
801073c9:	0f be c0             	movsbl %al,%eax
801073cc:	89 04 24             	mov    %eax,(%esp)
801073cf:	e8 11 00 00 00       	call   801073e5 <uartputc>
  for(p="xv6...\n"; *p; p++)
801073d4:	ff 45 f4             	incl   -0xc(%ebp)
801073d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073da:	8a 00                	mov    (%eax),%al
801073dc:	84 c0                	test   %al,%al
801073de:	75 e4                	jne    801073c4 <uartinit+0xed>
801073e0:	eb 01                	jmp    801073e3 <uartinit+0x10c>
    return;
801073e2:	90                   	nop
}
801073e3:	c9                   	leave  
801073e4:	c3                   	ret    

801073e5 <uartputc>:

void
uartputc(int c)
{
801073e5:	55                   	push   %ebp
801073e6:	89 e5                	mov    %esp,%ebp
801073e8:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801073eb:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
801073f0:	85 c0                	test   %eax,%eax
801073f2:	74 4c                	je     80107440 <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801073fb:	eb 0f                	jmp    8010740c <uartputc+0x27>
    microdelay(10);
801073fd:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80107404:	e8 bb ba ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107409:	ff 45 f4             	incl   -0xc(%ebp)
8010740c:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107410:	7f 16                	jg     80107428 <uartputc+0x43>
80107412:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107419:	e8 75 fe ff ff       	call   80107293 <inb>
8010741e:	0f b6 c0             	movzbl %al,%eax
80107421:	83 e0 20             	and    $0x20,%eax
80107424:	85 c0                	test   %eax,%eax
80107426:	74 d5                	je     801073fd <uartputc+0x18>
  outb(COM1+0, c);
80107428:	8b 45 08             	mov    0x8(%ebp),%eax
8010742b:	0f b6 c0             	movzbl %al,%eax
8010742e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107432:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107439:	e8 7d fe ff ff       	call   801072bb <outb>
8010743e:	eb 01                	jmp    80107441 <uartputc+0x5c>
    return;
80107440:	90                   	nop
}
80107441:	c9                   	leave  
80107442:	c3                   	ret    

80107443 <uartgetc>:

static int
uartgetc(void)
{
80107443:	55                   	push   %ebp
80107444:	89 e5                	mov    %esp,%ebp
80107446:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107449:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
8010744e:	85 c0                	test   %eax,%eax
80107450:	75 07                	jne    80107459 <uartgetc+0x16>
    return -1;
80107452:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107457:	eb 2c                	jmp    80107485 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80107459:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107460:	e8 2e fe ff ff       	call   80107293 <inb>
80107465:	0f b6 c0             	movzbl %al,%eax
80107468:	83 e0 01             	and    $0x1,%eax
8010746b:	85 c0                	test   %eax,%eax
8010746d:	75 07                	jne    80107476 <uartgetc+0x33>
    return -1;
8010746f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107474:	eb 0f                	jmp    80107485 <uartgetc+0x42>
  return inb(COM1+0);
80107476:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010747d:	e8 11 fe ff ff       	call   80107293 <inb>
80107482:	0f b6 c0             	movzbl %al,%eax
}
80107485:	c9                   	leave  
80107486:	c3                   	ret    

80107487 <uartintr>:

void
uartintr(void)
{
80107487:	55                   	push   %ebp
80107488:	89 e5                	mov    %esp,%ebp
8010748a:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
8010748d:	c7 04 24 43 74 10 80 	movl   $0x80107443,(%esp)
80107494:	e8 f7 92 ff ff       	call   80100790 <consoleintr>
}
80107499:	c9                   	leave  
8010749a:	c3                   	ret    

8010749b <vector0>:
8010749b:	6a 00                	push   $0x0
8010749d:	6a 00                	push   $0x0
8010749f:	e9 7e f9 ff ff       	jmp    80106e22 <alltraps>

801074a4 <vector1>:
801074a4:	6a 00                	push   $0x0
801074a6:	6a 01                	push   $0x1
801074a8:	e9 75 f9 ff ff       	jmp    80106e22 <alltraps>

801074ad <vector2>:
801074ad:	6a 00                	push   $0x0
801074af:	6a 02                	push   $0x2
801074b1:	e9 6c f9 ff ff       	jmp    80106e22 <alltraps>

801074b6 <vector3>:
801074b6:	6a 00                	push   $0x0
801074b8:	6a 03                	push   $0x3
801074ba:	e9 63 f9 ff ff       	jmp    80106e22 <alltraps>

801074bf <vector4>:
801074bf:	6a 00                	push   $0x0
801074c1:	6a 04                	push   $0x4
801074c3:	e9 5a f9 ff ff       	jmp    80106e22 <alltraps>

801074c8 <vector5>:
801074c8:	6a 00                	push   $0x0
801074ca:	6a 05                	push   $0x5
801074cc:	e9 51 f9 ff ff       	jmp    80106e22 <alltraps>

801074d1 <vector6>:
801074d1:	6a 00                	push   $0x0
801074d3:	6a 06                	push   $0x6
801074d5:	e9 48 f9 ff ff       	jmp    80106e22 <alltraps>

801074da <vector7>:
801074da:	6a 00                	push   $0x0
801074dc:	6a 07                	push   $0x7
801074de:	e9 3f f9 ff ff       	jmp    80106e22 <alltraps>

801074e3 <vector8>:
801074e3:	6a 08                	push   $0x8
801074e5:	e9 38 f9 ff ff       	jmp    80106e22 <alltraps>

801074ea <vector9>:
801074ea:	6a 00                	push   $0x0
801074ec:	6a 09                	push   $0x9
801074ee:	e9 2f f9 ff ff       	jmp    80106e22 <alltraps>

801074f3 <vector10>:
801074f3:	6a 0a                	push   $0xa
801074f5:	e9 28 f9 ff ff       	jmp    80106e22 <alltraps>

801074fa <vector11>:
801074fa:	6a 0b                	push   $0xb
801074fc:	e9 21 f9 ff ff       	jmp    80106e22 <alltraps>

80107501 <vector12>:
80107501:	6a 0c                	push   $0xc
80107503:	e9 1a f9 ff ff       	jmp    80106e22 <alltraps>

80107508 <vector13>:
80107508:	6a 0d                	push   $0xd
8010750a:	e9 13 f9 ff ff       	jmp    80106e22 <alltraps>

8010750f <vector14>:
8010750f:	6a 0e                	push   $0xe
80107511:	e9 0c f9 ff ff       	jmp    80106e22 <alltraps>

80107516 <vector15>:
80107516:	6a 00                	push   $0x0
80107518:	6a 0f                	push   $0xf
8010751a:	e9 03 f9 ff ff       	jmp    80106e22 <alltraps>

8010751f <vector16>:
8010751f:	6a 00                	push   $0x0
80107521:	6a 10                	push   $0x10
80107523:	e9 fa f8 ff ff       	jmp    80106e22 <alltraps>

80107528 <vector17>:
80107528:	6a 11                	push   $0x11
8010752a:	e9 f3 f8 ff ff       	jmp    80106e22 <alltraps>

8010752f <vector18>:
8010752f:	6a 00                	push   $0x0
80107531:	6a 12                	push   $0x12
80107533:	e9 ea f8 ff ff       	jmp    80106e22 <alltraps>

80107538 <vector19>:
80107538:	6a 00                	push   $0x0
8010753a:	6a 13                	push   $0x13
8010753c:	e9 e1 f8 ff ff       	jmp    80106e22 <alltraps>

80107541 <vector20>:
80107541:	6a 00                	push   $0x0
80107543:	6a 14                	push   $0x14
80107545:	e9 d8 f8 ff ff       	jmp    80106e22 <alltraps>

8010754a <vector21>:
8010754a:	6a 00                	push   $0x0
8010754c:	6a 15                	push   $0x15
8010754e:	e9 cf f8 ff ff       	jmp    80106e22 <alltraps>

80107553 <vector22>:
80107553:	6a 00                	push   $0x0
80107555:	6a 16                	push   $0x16
80107557:	e9 c6 f8 ff ff       	jmp    80106e22 <alltraps>

8010755c <vector23>:
8010755c:	6a 00                	push   $0x0
8010755e:	6a 17                	push   $0x17
80107560:	e9 bd f8 ff ff       	jmp    80106e22 <alltraps>

80107565 <vector24>:
80107565:	6a 00                	push   $0x0
80107567:	6a 18                	push   $0x18
80107569:	e9 b4 f8 ff ff       	jmp    80106e22 <alltraps>

8010756e <vector25>:
8010756e:	6a 00                	push   $0x0
80107570:	6a 19                	push   $0x19
80107572:	e9 ab f8 ff ff       	jmp    80106e22 <alltraps>

80107577 <vector26>:
80107577:	6a 00                	push   $0x0
80107579:	6a 1a                	push   $0x1a
8010757b:	e9 a2 f8 ff ff       	jmp    80106e22 <alltraps>

80107580 <vector27>:
80107580:	6a 00                	push   $0x0
80107582:	6a 1b                	push   $0x1b
80107584:	e9 99 f8 ff ff       	jmp    80106e22 <alltraps>

80107589 <vector28>:
80107589:	6a 00                	push   $0x0
8010758b:	6a 1c                	push   $0x1c
8010758d:	e9 90 f8 ff ff       	jmp    80106e22 <alltraps>

80107592 <vector29>:
80107592:	6a 00                	push   $0x0
80107594:	6a 1d                	push   $0x1d
80107596:	e9 87 f8 ff ff       	jmp    80106e22 <alltraps>

8010759b <vector30>:
8010759b:	6a 00                	push   $0x0
8010759d:	6a 1e                	push   $0x1e
8010759f:	e9 7e f8 ff ff       	jmp    80106e22 <alltraps>

801075a4 <vector31>:
801075a4:	6a 00                	push   $0x0
801075a6:	6a 1f                	push   $0x1f
801075a8:	e9 75 f8 ff ff       	jmp    80106e22 <alltraps>

801075ad <vector32>:
801075ad:	6a 00                	push   $0x0
801075af:	6a 20                	push   $0x20
801075b1:	e9 6c f8 ff ff       	jmp    80106e22 <alltraps>

801075b6 <vector33>:
801075b6:	6a 00                	push   $0x0
801075b8:	6a 21                	push   $0x21
801075ba:	e9 63 f8 ff ff       	jmp    80106e22 <alltraps>

801075bf <vector34>:
801075bf:	6a 00                	push   $0x0
801075c1:	6a 22                	push   $0x22
801075c3:	e9 5a f8 ff ff       	jmp    80106e22 <alltraps>

801075c8 <vector35>:
801075c8:	6a 00                	push   $0x0
801075ca:	6a 23                	push   $0x23
801075cc:	e9 51 f8 ff ff       	jmp    80106e22 <alltraps>

801075d1 <vector36>:
801075d1:	6a 00                	push   $0x0
801075d3:	6a 24                	push   $0x24
801075d5:	e9 48 f8 ff ff       	jmp    80106e22 <alltraps>

801075da <vector37>:
801075da:	6a 00                	push   $0x0
801075dc:	6a 25                	push   $0x25
801075de:	e9 3f f8 ff ff       	jmp    80106e22 <alltraps>

801075e3 <vector38>:
801075e3:	6a 00                	push   $0x0
801075e5:	6a 26                	push   $0x26
801075e7:	e9 36 f8 ff ff       	jmp    80106e22 <alltraps>

801075ec <vector39>:
801075ec:	6a 00                	push   $0x0
801075ee:	6a 27                	push   $0x27
801075f0:	e9 2d f8 ff ff       	jmp    80106e22 <alltraps>

801075f5 <vector40>:
801075f5:	6a 00                	push   $0x0
801075f7:	6a 28                	push   $0x28
801075f9:	e9 24 f8 ff ff       	jmp    80106e22 <alltraps>

801075fe <vector41>:
801075fe:	6a 00                	push   $0x0
80107600:	6a 29                	push   $0x29
80107602:	e9 1b f8 ff ff       	jmp    80106e22 <alltraps>

80107607 <vector42>:
80107607:	6a 00                	push   $0x0
80107609:	6a 2a                	push   $0x2a
8010760b:	e9 12 f8 ff ff       	jmp    80106e22 <alltraps>

80107610 <vector43>:
80107610:	6a 00                	push   $0x0
80107612:	6a 2b                	push   $0x2b
80107614:	e9 09 f8 ff ff       	jmp    80106e22 <alltraps>

80107619 <vector44>:
80107619:	6a 00                	push   $0x0
8010761b:	6a 2c                	push   $0x2c
8010761d:	e9 00 f8 ff ff       	jmp    80106e22 <alltraps>

80107622 <vector45>:
80107622:	6a 00                	push   $0x0
80107624:	6a 2d                	push   $0x2d
80107626:	e9 f7 f7 ff ff       	jmp    80106e22 <alltraps>

8010762b <vector46>:
8010762b:	6a 00                	push   $0x0
8010762d:	6a 2e                	push   $0x2e
8010762f:	e9 ee f7 ff ff       	jmp    80106e22 <alltraps>

80107634 <vector47>:
80107634:	6a 00                	push   $0x0
80107636:	6a 2f                	push   $0x2f
80107638:	e9 e5 f7 ff ff       	jmp    80106e22 <alltraps>

8010763d <vector48>:
8010763d:	6a 00                	push   $0x0
8010763f:	6a 30                	push   $0x30
80107641:	e9 dc f7 ff ff       	jmp    80106e22 <alltraps>

80107646 <vector49>:
80107646:	6a 00                	push   $0x0
80107648:	6a 31                	push   $0x31
8010764a:	e9 d3 f7 ff ff       	jmp    80106e22 <alltraps>

8010764f <vector50>:
8010764f:	6a 00                	push   $0x0
80107651:	6a 32                	push   $0x32
80107653:	e9 ca f7 ff ff       	jmp    80106e22 <alltraps>

80107658 <vector51>:
80107658:	6a 00                	push   $0x0
8010765a:	6a 33                	push   $0x33
8010765c:	e9 c1 f7 ff ff       	jmp    80106e22 <alltraps>

80107661 <vector52>:
80107661:	6a 00                	push   $0x0
80107663:	6a 34                	push   $0x34
80107665:	e9 b8 f7 ff ff       	jmp    80106e22 <alltraps>

8010766a <vector53>:
8010766a:	6a 00                	push   $0x0
8010766c:	6a 35                	push   $0x35
8010766e:	e9 af f7 ff ff       	jmp    80106e22 <alltraps>

80107673 <vector54>:
80107673:	6a 00                	push   $0x0
80107675:	6a 36                	push   $0x36
80107677:	e9 a6 f7 ff ff       	jmp    80106e22 <alltraps>

8010767c <vector55>:
8010767c:	6a 00                	push   $0x0
8010767e:	6a 37                	push   $0x37
80107680:	e9 9d f7 ff ff       	jmp    80106e22 <alltraps>

80107685 <vector56>:
80107685:	6a 00                	push   $0x0
80107687:	6a 38                	push   $0x38
80107689:	e9 94 f7 ff ff       	jmp    80106e22 <alltraps>

8010768e <vector57>:
8010768e:	6a 00                	push   $0x0
80107690:	6a 39                	push   $0x39
80107692:	e9 8b f7 ff ff       	jmp    80106e22 <alltraps>

80107697 <vector58>:
80107697:	6a 00                	push   $0x0
80107699:	6a 3a                	push   $0x3a
8010769b:	e9 82 f7 ff ff       	jmp    80106e22 <alltraps>

801076a0 <vector59>:
801076a0:	6a 00                	push   $0x0
801076a2:	6a 3b                	push   $0x3b
801076a4:	e9 79 f7 ff ff       	jmp    80106e22 <alltraps>

801076a9 <vector60>:
801076a9:	6a 00                	push   $0x0
801076ab:	6a 3c                	push   $0x3c
801076ad:	e9 70 f7 ff ff       	jmp    80106e22 <alltraps>

801076b2 <vector61>:
801076b2:	6a 00                	push   $0x0
801076b4:	6a 3d                	push   $0x3d
801076b6:	e9 67 f7 ff ff       	jmp    80106e22 <alltraps>

801076bb <vector62>:
801076bb:	6a 00                	push   $0x0
801076bd:	6a 3e                	push   $0x3e
801076bf:	e9 5e f7 ff ff       	jmp    80106e22 <alltraps>

801076c4 <vector63>:
801076c4:	6a 00                	push   $0x0
801076c6:	6a 3f                	push   $0x3f
801076c8:	e9 55 f7 ff ff       	jmp    80106e22 <alltraps>

801076cd <vector64>:
801076cd:	6a 00                	push   $0x0
801076cf:	6a 40                	push   $0x40
801076d1:	e9 4c f7 ff ff       	jmp    80106e22 <alltraps>

801076d6 <vector65>:
801076d6:	6a 00                	push   $0x0
801076d8:	6a 41                	push   $0x41
801076da:	e9 43 f7 ff ff       	jmp    80106e22 <alltraps>

801076df <vector66>:
801076df:	6a 00                	push   $0x0
801076e1:	6a 42                	push   $0x42
801076e3:	e9 3a f7 ff ff       	jmp    80106e22 <alltraps>

801076e8 <vector67>:
801076e8:	6a 00                	push   $0x0
801076ea:	6a 43                	push   $0x43
801076ec:	e9 31 f7 ff ff       	jmp    80106e22 <alltraps>

801076f1 <vector68>:
801076f1:	6a 00                	push   $0x0
801076f3:	6a 44                	push   $0x44
801076f5:	e9 28 f7 ff ff       	jmp    80106e22 <alltraps>

801076fa <vector69>:
801076fa:	6a 00                	push   $0x0
801076fc:	6a 45                	push   $0x45
801076fe:	e9 1f f7 ff ff       	jmp    80106e22 <alltraps>

80107703 <vector70>:
80107703:	6a 00                	push   $0x0
80107705:	6a 46                	push   $0x46
80107707:	e9 16 f7 ff ff       	jmp    80106e22 <alltraps>

8010770c <vector71>:
8010770c:	6a 00                	push   $0x0
8010770e:	6a 47                	push   $0x47
80107710:	e9 0d f7 ff ff       	jmp    80106e22 <alltraps>

80107715 <vector72>:
80107715:	6a 00                	push   $0x0
80107717:	6a 48                	push   $0x48
80107719:	e9 04 f7 ff ff       	jmp    80106e22 <alltraps>

8010771e <vector73>:
8010771e:	6a 00                	push   $0x0
80107720:	6a 49                	push   $0x49
80107722:	e9 fb f6 ff ff       	jmp    80106e22 <alltraps>

80107727 <vector74>:
80107727:	6a 00                	push   $0x0
80107729:	6a 4a                	push   $0x4a
8010772b:	e9 f2 f6 ff ff       	jmp    80106e22 <alltraps>

80107730 <vector75>:
80107730:	6a 00                	push   $0x0
80107732:	6a 4b                	push   $0x4b
80107734:	e9 e9 f6 ff ff       	jmp    80106e22 <alltraps>

80107739 <vector76>:
80107739:	6a 00                	push   $0x0
8010773b:	6a 4c                	push   $0x4c
8010773d:	e9 e0 f6 ff ff       	jmp    80106e22 <alltraps>

80107742 <vector77>:
80107742:	6a 00                	push   $0x0
80107744:	6a 4d                	push   $0x4d
80107746:	e9 d7 f6 ff ff       	jmp    80106e22 <alltraps>

8010774b <vector78>:
8010774b:	6a 00                	push   $0x0
8010774d:	6a 4e                	push   $0x4e
8010774f:	e9 ce f6 ff ff       	jmp    80106e22 <alltraps>

80107754 <vector79>:
80107754:	6a 00                	push   $0x0
80107756:	6a 4f                	push   $0x4f
80107758:	e9 c5 f6 ff ff       	jmp    80106e22 <alltraps>

8010775d <vector80>:
8010775d:	6a 00                	push   $0x0
8010775f:	6a 50                	push   $0x50
80107761:	e9 bc f6 ff ff       	jmp    80106e22 <alltraps>

80107766 <vector81>:
80107766:	6a 00                	push   $0x0
80107768:	6a 51                	push   $0x51
8010776a:	e9 b3 f6 ff ff       	jmp    80106e22 <alltraps>

8010776f <vector82>:
8010776f:	6a 00                	push   $0x0
80107771:	6a 52                	push   $0x52
80107773:	e9 aa f6 ff ff       	jmp    80106e22 <alltraps>

80107778 <vector83>:
80107778:	6a 00                	push   $0x0
8010777a:	6a 53                	push   $0x53
8010777c:	e9 a1 f6 ff ff       	jmp    80106e22 <alltraps>

80107781 <vector84>:
80107781:	6a 00                	push   $0x0
80107783:	6a 54                	push   $0x54
80107785:	e9 98 f6 ff ff       	jmp    80106e22 <alltraps>

8010778a <vector85>:
8010778a:	6a 00                	push   $0x0
8010778c:	6a 55                	push   $0x55
8010778e:	e9 8f f6 ff ff       	jmp    80106e22 <alltraps>

80107793 <vector86>:
80107793:	6a 00                	push   $0x0
80107795:	6a 56                	push   $0x56
80107797:	e9 86 f6 ff ff       	jmp    80106e22 <alltraps>

8010779c <vector87>:
8010779c:	6a 00                	push   $0x0
8010779e:	6a 57                	push   $0x57
801077a0:	e9 7d f6 ff ff       	jmp    80106e22 <alltraps>

801077a5 <vector88>:
801077a5:	6a 00                	push   $0x0
801077a7:	6a 58                	push   $0x58
801077a9:	e9 74 f6 ff ff       	jmp    80106e22 <alltraps>

801077ae <vector89>:
801077ae:	6a 00                	push   $0x0
801077b0:	6a 59                	push   $0x59
801077b2:	e9 6b f6 ff ff       	jmp    80106e22 <alltraps>

801077b7 <vector90>:
801077b7:	6a 00                	push   $0x0
801077b9:	6a 5a                	push   $0x5a
801077bb:	e9 62 f6 ff ff       	jmp    80106e22 <alltraps>

801077c0 <vector91>:
801077c0:	6a 00                	push   $0x0
801077c2:	6a 5b                	push   $0x5b
801077c4:	e9 59 f6 ff ff       	jmp    80106e22 <alltraps>

801077c9 <vector92>:
801077c9:	6a 00                	push   $0x0
801077cb:	6a 5c                	push   $0x5c
801077cd:	e9 50 f6 ff ff       	jmp    80106e22 <alltraps>

801077d2 <vector93>:
801077d2:	6a 00                	push   $0x0
801077d4:	6a 5d                	push   $0x5d
801077d6:	e9 47 f6 ff ff       	jmp    80106e22 <alltraps>

801077db <vector94>:
801077db:	6a 00                	push   $0x0
801077dd:	6a 5e                	push   $0x5e
801077df:	e9 3e f6 ff ff       	jmp    80106e22 <alltraps>

801077e4 <vector95>:
801077e4:	6a 00                	push   $0x0
801077e6:	6a 5f                	push   $0x5f
801077e8:	e9 35 f6 ff ff       	jmp    80106e22 <alltraps>

801077ed <vector96>:
801077ed:	6a 00                	push   $0x0
801077ef:	6a 60                	push   $0x60
801077f1:	e9 2c f6 ff ff       	jmp    80106e22 <alltraps>

801077f6 <vector97>:
801077f6:	6a 00                	push   $0x0
801077f8:	6a 61                	push   $0x61
801077fa:	e9 23 f6 ff ff       	jmp    80106e22 <alltraps>

801077ff <vector98>:
801077ff:	6a 00                	push   $0x0
80107801:	6a 62                	push   $0x62
80107803:	e9 1a f6 ff ff       	jmp    80106e22 <alltraps>

80107808 <vector99>:
80107808:	6a 00                	push   $0x0
8010780a:	6a 63                	push   $0x63
8010780c:	e9 11 f6 ff ff       	jmp    80106e22 <alltraps>

80107811 <vector100>:
80107811:	6a 00                	push   $0x0
80107813:	6a 64                	push   $0x64
80107815:	e9 08 f6 ff ff       	jmp    80106e22 <alltraps>

8010781a <vector101>:
8010781a:	6a 00                	push   $0x0
8010781c:	6a 65                	push   $0x65
8010781e:	e9 ff f5 ff ff       	jmp    80106e22 <alltraps>

80107823 <vector102>:
80107823:	6a 00                	push   $0x0
80107825:	6a 66                	push   $0x66
80107827:	e9 f6 f5 ff ff       	jmp    80106e22 <alltraps>

8010782c <vector103>:
8010782c:	6a 00                	push   $0x0
8010782e:	6a 67                	push   $0x67
80107830:	e9 ed f5 ff ff       	jmp    80106e22 <alltraps>

80107835 <vector104>:
80107835:	6a 00                	push   $0x0
80107837:	6a 68                	push   $0x68
80107839:	e9 e4 f5 ff ff       	jmp    80106e22 <alltraps>

8010783e <vector105>:
8010783e:	6a 00                	push   $0x0
80107840:	6a 69                	push   $0x69
80107842:	e9 db f5 ff ff       	jmp    80106e22 <alltraps>

80107847 <vector106>:
80107847:	6a 00                	push   $0x0
80107849:	6a 6a                	push   $0x6a
8010784b:	e9 d2 f5 ff ff       	jmp    80106e22 <alltraps>

80107850 <vector107>:
80107850:	6a 00                	push   $0x0
80107852:	6a 6b                	push   $0x6b
80107854:	e9 c9 f5 ff ff       	jmp    80106e22 <alltraps>

80107859 <vector108>:
80107859:	6a 00                	push   $0x0
8010785b:	6a 6c                	push   $0x6c
8010785d:	e9 c0 f5 ff ff       	jmp    80106e22 <alltraps>

80107862 <vector109>:
80107862:	6a 00                	push   $0x0
80107864:	6a 6d                	push   $0x6d
80107866:	e9 b7 f5 ff ff       	jmp    80106e22 <alltraps>

8010786b <vector110>:
8010786b:	6a 00                	push   $0x0
8010786d:	6a 6e                	push   $0x6e
8010786f:	e9 ae f5 ff ff       	jmp    80106e22 <alltraps>

80107874 <vector111>:
80107874:	6a 00                	push   $0x0
80107876:	6a 6f                	push   $0x6f
80107878:	e9 a5 f5 ff ff       	jmp    80106e22 <alltraps>

8010787d <vector112>:
8010787d:	6a 00                	push   $0x0
8010787f:	6a 70                	push   $0x70
80107881:	e9 9c f5 ff ff       	jmp    80106e22 <alltraps>

80107886 <vector113>:
80107886:	6a 00                	push   $0x0
80107888:	6a 71                	push   $0x71
8010788a:	e9 93 f5 ff ff       	jmp    80106e22 <alltraps>

8010788f <vector114>:
8010788f:	6a 00                	push   $0x0
80107891:	6a 72                	push   $0x72
80107893:	e9 8a f5 ff ff       	jmp    80106e22 <alltraps>

80107898 <vector115>:
80107898:	6a 00                	push   $0x0
8010789a:	6a 73                	push   $0x73
8010789c:	e9 81 f5 ff ff       	jmp    80106e22 <alltraps>

801078a1 <vector116>:
801078a1:	6a 00                	push   $0x0
801078a3:	6a 74                	push   $0x74
801078a5:	e9 78 f5 ff ff       	jmp    80106e22 <alltraps>

801078aa <vector117>:
801078aa:	6a 00                	push   $0x0
801078ac:	6a 75                	push   $0x75
801078ae:	e9 6f f5 ff ff       	jmp    80106e22 <alltraps>

801078b3 <vector118>:
801078b3:	6a 00                	push   $0x0
801078b5:	6a 76                	push   $0x76
801078b7:	e9 66 f5 ff ff       	jmp    80106e22 <alltraps>

801078bc <vector119>:
801078bc:	6a 00                	push   $0x0
801078be:	6a 77                	push   $0x77
801078c0:	e9 5d f5 ff ff       	jmp    80106e22 <alltraps>

801078c5 <vector120>:
801078c5:	6a 00                	push   $0x0
801078c7:	6a 78                	push   $0x78
801078c9:	e9 54 f5 ff ff       	jmp    80106e22 <alltraps>

801078ce <vector121>:
801078ce:	6a 00                	push   $0x0
801078d0:	6a 79                	push   $0x79
801078d2:	e9 4b f5 ff ff       	jmp    80106e22 <alltraps>

801078d7 <vector122>:
801078d7:	6a 00                	push   $0x0
801078d9:	6a 7a                	push   $0x7a
801078db:	e9 42 f5 ff ff       	jmp    80106e22 <alltraps>

801078e0 <vector123>:
801078e0:	6a 00                	push   $0x0
801078e2:	6a 7b                	push   $0x7b
801078e4:	e9 39 f5 ff ff       	jmp    80106e22 <alltraps>

801078e9 <vector124>:
801078e9:	6a 00                	push   $0x0
801078eb:	6a 7c                	push   $0x7c
801078ed:	e9 30 f5 ff ff       	jmp    80106e22 <alltraps>

801078f2 <vector125>:
801078f2:	6a 00                	push   $0x0
801078f4:	6a 7d                	push   $0x7d
801078f6:	e9 27 f5 ff ff       	jmp    80106e22 <alltraps>

801078fb <vector126>:
801078fb:	6a 00                	push   $0x0
801078fd:	6a 7e                	push   $0x7e
801078ff:	e9 1e f5 ff ff       	jmp    80106e22 <alltraps>

80107904 <vector127>:
80107904:	6a 00                	push   $0x0
80107906:	6a 7f                	push   $0x7f
80107908:	e9 15 f5 ff ff       	jmp    80106e22 <alltraps>

8010790d <vector128>:
8010790d:	6a 00                	push   $0x0
8010790f:	68 80 00 00 00       	push   $0x80
80107914:	e9 09 f5 ff ff       	jmp    80106e22 <alltraps>

80107919 <vector129>:
80107919:	6a 00                	push   $0x0
8010791b:	68 81 00 00 00       	push   $0x81
80107920:	e9 fd f4 ff ff       	jmp    80106e22 <alltraps>

80107925 <vector130>:
80107925:	6a 00                	push   $0x0
80107927:	68 82 00 00 00       	push   $0x82
8010792c:	e9 f1 f4 ff ff       	jmp    80106e22 <alltraps>

80107931 <vector131>:
80107931:	6a 00                	push   $0x0
80107933:	68 83 00 00 00       	push   $0x83
80107938:	e9 e5 f4 ff ff       	jmp    80106e22 <alltraps>

8010793d <vector132>:
8010793d:	6a 00                	push   $0x0
8010793f:	68 84 00 00 00       	push   $0x84
80107944:	e9 d9 f4 ff ff       	jmp    80106e22 <alltraps>

80107949 <vector133>:
80107949:	6a 00                	push   $0x0
8010794b:	68 85 00 00 00       	push   $0x85
80107950:	e9 cd f4 ff ff       	jmp    80106e22 <alltraps>

80107955 <vector134>:
80107955:	6a 00                	push   $0x0
80107957:	68 86 00 00 00       	push   $0x86
8010795c:	e9 c1 f4 ff ff       	jmp    80106e22 <alltraps>

80107961 <vector135>:
80107961:	6a 00                	push   $0x0
80107963:	68 87 00 00 00       	push   $0x87
80107968:	e9 b5 f4 ff ff       	jmp    80106e22 <alltraps>

8010796d <vector136>:
8010796d:	6a 00                	push   $0x0
8010796f:	68 88 00 00 00       	push   $0x88
80107974:	e9 a9 f4 ff ff       	jmp    80106e22 <alltraps>

80107979 <vector137>:
80107979:	6a 00                	push   $0x0
8010797b:	68 89 00 00 00       	push   $0x89
80107980:	e9 9d f4 ff ff       	jmp    80106e22 <alltraps>

80107985 <vector138>:
80107985:	6a 00                	push   $0x0
80107987:	68 8a 00 00 00       	push   $0x8a
8010798c:	e9 91 f4 ff ff       	jmp    80106e22 <alltraps>

80107991 <vector139>:
80107991:	6a 00                	push   $0x0
80107993:	68 8b 00 00 00       	push   $0x8b
80107998:	e9 85 f4 ff ff       	jmp    80106e22 <alltraps>

8010799d <vector140>:
8010799d:	6a 00                	push   $0x0
8010799f:	68 8c 00 00 00       	push   $0x8c
801079a4:	e9 79 f4 ff ff       	jmp    80106e22 <alltraps>

801079a9 <vector141>:
801079a9:	6a 00                	push   $0x0
801079ab:	68 8d 00 00 00       	push   $0x8d
801079b0:	e9 6d f4 ff ff       	jmp    80106e22 <alltraps>

801079b5 <vector142>:
801079b5:	6a 00                	push   $0x0
801079b7:	68 8e 00 00 00       	push   $0x8e
801079bc:	e9 61 f4 ff ff       	jmp    80106e22 <alltraps>

801079c1 <vector143>:
801079c1:	6a 00                	push   $0x0
801079c3:	68 8f 00 00 00       	push   $0x8f
801079c8:	e9 55 f4 ff ff       	jmp    80106e22 <alltraps>

801079cd <vector144>:
801079cd:	6a 00                	push   $0x0
801079cf:	68 90 00 00 00       	push   $0x90
801079d4:	e9 49 f4 ff ff       	jmp    80106e22 <alltraps>

801079d9 <vector145>:
801079d9:	6a 00                	push   $0x0
801079db:	68 91 00 00 00       	push   $0x91
801079e0:	e9 3d f4 ff ff       	jmp    80106e22 <alltraps>

801079e5 <vector146>:
801079e5:	6a 00                	push   $0x0
801079e7:	68 92 00 00 00       	push   $0x92
801079ec:	e9 31 f4 ff ff       	jmp    80106e22 <alltraps>

801079f1 <vector147>:
801079f1:	6a 00                	push   $0x0
801079f3:	68 93 00 00 00       	push   $0x93
801079f8:	e9 25 f4 ff ff       	jmp    80106e22 <alltraps>

801079fd <vector148>:
801079fd:	6a 00                	push   $0x0
801079ff:	68 94 00 00 00       	push   $0x94
80107a04:	e9 19 f4 ff ff       	jmp    80106e22 <alltraps>

80107a09 <vector149>:
80107a09:	6a 00                	push   $0x0
80107a0b:	68 95 00 00 00       	push   $0x95
80107a10:	e9 0d f4 ff ff       	jmp    80106e22 <alltraps>

80107a15 <vector150>:
80107a15:	6a 00                	push   $0x0
80107a17:	68 96 00 00 00       	push   $0x96
80107a1c:	e9 01 f4 ff ff       	jmp    80106e22 <alltraps>

80107a21 <vector151>:
80107a21:	6a 00                	push   $0x0
80107a23:	68 97 00 00 00       	push   $0x97
80107a28:	e9 f5 f3 ff ff       	jmp    80106e22 <alltraps>

80107a2d <vector152>:
80107a2d:	6a 00                	push   $0x0
80107a2f:	68 98 00 00 00       	push   $0x98
80107a34:	e9 e9 f3 ff ff       	jmp    80106e22 <alltraps>

80107a39 <vector153>:
80107a39:	6a 00                	push   $0x0
80107a3b:	68 99 00 00 00       	push   $0x99
80107a40:	e9 dd f3 ff ff       	jmp    80106e22 <alltraps>

80107a45 <vector154>:
80107a45:	6a 00                	push   $0x0
80107a47:	68 9a 00 00 00       	push   $0x9a
80107a4c:	e9 d1 f3 ff ff       	jmp    80106e22 <alltraps>

80107a51 <vector155>:
80107a51:	6a 00                	push   $0x0
80107a53:	68 9b 00 00 00       	push   $0x9b
80107a58:	e9 c5 f3 ff ff       	jmp    80106e22 <alltraps>

80107a5d <vector156>:
80107a5d:	6a 00                	push   $0x0
80107a5f:	68 9c 00 00 00       	push   $0x9c
80107a64:	e9 b9 f3 ff ff       	jmp    80106e22 <alltraps>

80107a69 <vector157>:
80107a69:	6a 00                	push   $0x0
80107a6b:	68 9d 00 00 00       	push   $0x9d
80107a70:	e9 ad f3 ff ff       	jmp    80106e22 <alltraps>

80107a75 <vector158>:
80107a75:	6a 00                	push   $0x0
80107a77:	68 9e 00 00 00       	push   $0x9e
80107a7c:	e9 a1 f3 ff ff       	jmp    80106e22 <alltraps>

80107a81 <vector159>:
80107a81:	6a 00                	push   $0x0
80107a83:	68 9f 00 00 00       	push   $0x9f
80107a88:	e9 95 f3 ff ff       	jmp    80106e22 <alltraps>

80107a8d <vector160>:
80107a8d:	6a 00                	push   $0x0
80107a8f:	68 a0 00 00 00       	push   $0xa0
80107a94:	e9 89 f3 ff ff       	jmp    80106e22 <alltraps>

80107a99 <vector161>:
80107a99:	6a 00                	push   $0x0
80107a9b:	68 a1 00 00 00       	push   $0xa1
80107aa0:	e9 7d f3 ff ff       	jmp    80106e22 <alltraps>

80107aa5 <vector162>:
80107aa5:	6a 00                	push   $0x0
80107aa7:	68 a2 00 00 00       	push   $0xa2
80107aac:	e9 71 f3 ff ff       	jmp    80106e22 <alltraps>

80107ab1 <vector163>:
80107ab1:	6a 00                	push   $0x0
80107ab3:	68 a3 00 00 00       	push   $0xa3
80107ab8:	e9 65 f3 ff ff       	jmp    80106e22 <alltraps>

80107abd <vector164>:
80107abd:	6a 00                	push   $0x0
80107abf:	68 a4 00 00 00       	push   $0xa4
80107ac4:	e9 59 f3 ff ff       	jmp    80106e22 <alltraps>

80107ac9 <vector165>:
80107ac9:	6a 00                	push   $0x0
80107acb:	68 a5 00 00 00       	push   $0xa5
80107ad0:	e9 4d f3 ff ff       	jmp    80106e22 <alltraps>

80107ad5 <vector166>:
80107ad5:	6a 00                	push   $0x0
80107ad7:	68 a6 00 00 00       	push   $0xa6
80107adc:	e9 41 f3 ff ff       	jmp    80106e22 <alltraps>

80107ae1 <vector167>:
80107ae1:	6a 00                	push   $0x0
80107ae3:	68 a7 00 00 00       	push   $0xa7
80107ae8:	e9 35 f3 ff ff       	jmp    80106e22 <alltraps>

80107aed <vector168>:
80107aed:	6a 00                	push   $0x0
80107aef:	68 a8 00 00 00       	push   $0xa8
80107af4:	e9 29 f3 ff ff       	jmp    80106e22 <alltraps>

80107af9 <vector169>:
80107af9:	6a 00                	push   $0x0
80107afb:	68 a9 00 00 00       	push   $0xa9
80107b00:	e9 1d f3 ff ff       	jmp    80106e22 <alltraps>

80107b05 <vector170>:
80107b05:	6a 00                	push   $0x0
80107b07:	68 aa 00 00 00       	push   $0xaa
80107b0c:	e9 11 f3 ff ff       	jmp    80106e22 <alltraps>

80107b11 <vector171>:
80107b11:	6a 00                	push   $0x0
80107b13:	68 ab 00 00 00       	push   $0xab
80107b18:	e9 05 f3 ff ff       	jmp    80106e22 <alltraps>

80107b1d <vector172>:
80107b1d:	6a 00                	push   $0x0
80107b1f:	68 ac 00 00 00       	push   $0xac
80107b24:	e9 f9 f2 ff ff       	jmp    80106e22 <alltraps>

80107b29 <vector173>:
80107b29:	6a 00                	push   $0x0
80107b2b:	68 ad 00 00 00       	push   $0xad
80107b30:	e9 ed f2 ff ff       	jmp    80106e22 <alltraps>

80107b35 <vector174>:
80107b35:	6a 00                	push   $0x0
80107b37:	68 ae 00 00 00       	push   $0xae
80107b3c:	e9 e1 f2 ff ff       	jmp    80106e22 <alltraps>

80107b41 <vector175>:
80107b41:	6a 00                	push   $0x0
80107b43:	68 af 00 00 00       	push   $0xaf
80107b48:	e9 d5 f2 ff ff       	jmp    80106e22 <alltraps>

80107b4d <vector176>:
80107b4d:	6a 00                	push   $0x0
80107b4f:	68 b0 00 00 00       	push   $0xb0
80107b54:	e9 c9 f2 ff ff       	jmp    80106e22 <alltraps>

80107b59 <vector177>:
80107b59:	6a 00                	push   $0x0
80107b5b:	68 b1 00 00 00       	push   $0xb1
80107b60:	e9 bd f2 ff ff       	jmp    80106e22 <alltraps>

80107b65 <vector178>:
80107b65:	6a 00                	push   $0x0
80107b67:	68 b2 00 00 00       	push   $0xb2
80107b6c:	e9 b1 f2 ff ff       	jmp    80106e22 <alltraps>

80107b71 <vector179>:
80107b71:	6a 00                	push   $0x0
80107b73:	68 b3 00 00 00       	push   $0xb3
80107b78:	e9 a5 f2 ff ff       	jmp    80106e22 <alltraps>

80107b7d <vector180>:
80107b7d:	6a 00                	push   $0x0
80107b7f:	68 b4 00 00 00       	push   $0xb4
80107b84:	e9 99 f2 ff ff       	jmp    80106e22 <alltraps>

80107b89 <vector181>:
80107b89:	6a 00                	push   $0x0
80107b8b:	68 b5 00 00 00       	push   $0xb5
80107b90:	e9 8d f2 ff ff       	jmp    80106e22 <alltraps>

80107b95 <vector182>:
80107b95:	6a 00                	push   $0x0
80107b97:	68 b6 00 00 00       	push   $0xb6
80107b9c:	e9 81 f2 ff ff       	jmp    80106e22 <alltraps>

80107ba1 <vector183>:
80107ba1:	6a 00                	push   $0x0
80107ba3:	68 b7 00 00 00       	push   $0xb7
80107ba8:	e9 75 f2 ff ff       	jmp    80106e22 <alltraps>

80107bad <vector184>:
80107bad:	6a 00                	push   $0x0
80107baf:	68 b8 00 00 00       	push   $0xb8
80107bb4:	e9 69 f2 ff ff       	jmp    80106e22 <alltraps>

80107bb9 <vector185>:
80107bb9:	6a 00                	push   $0x0
80107bbb:	68 b9 00 00 00       	push   $0xb9
80107bc0:	e9 5d f2 ff ff       	jmp    80106e22 <alltraps>

80107bc5 <vector186>:
80107bc5:	6a 00                	push   $0x0
80107bc7:	68 ba 00 00 00       	push   $0xba
80107bcc:	e9 51 f2 ff ff       	jmp    80106e22 <alltraps>

80107bd1 <vector187>:
80107bd1:	6a 00                	push   $0x0
80107bd3:	68 bb 00 00 00       	push   $0xbb
80107bd8:	e9 45 f2 ff ff       	jmp    80106e22 <alltraps>

80107bdd <vector188>:
80107bdd:	6a 00                	push   $0x0
80107bdf:	68 bc 00 00 00       	push   $0xbc
80107be4:	e9 39 f2 ff ff       	jmp    80106e22 <alltraps>

80107be9 <vector189>:
80107be9:	6a 00                	push   $0x0
80107beb:	68 bd 00 00 00       	push   $0xbd
80107bf0:	e9 2d f2 ff ff       	jmp    80106e22 <alltraps>

80107bf5 <vector190>:
80107bf5:	6a 00                	push   $0x0
80107bf7:	68 be 00 00 00       	push   $0xbe
80107bfc:	e9 21 f2 ff ff       	jmp    80106e22 <alltraps>

80107c01 <vector191>:
80107c01:	6a 00                	push   $0x0
80107c03:	68 bf 00 00 00       	push   $0xbf
80107c08:	e9 15 f2 ff ff       	jmp    80106e22 <alltraps>

80107c0d <vector192>:
80107c0d:	6a 00                	push   $0x0
80107c0f:	68 c0 00 00 00       	push   $0xc0
80107c14:	e9 09 f2 ff ff       	jmp    80106e22 <alltraps>

80107c19 <vector193>:
80107c19:	6a 00                	push   $0x0
80107c1b:	68 c1 00 00 00       	push   $0xc1
80107c20:	e9 fd f1 ff ff       	jmp    80106e22 <alltraps>

80107c25 <vector194>:
80107c25:	6a 00                	push   $0x0
80107c27:	68 c2 00 00 00       	push   $0xc2
80107c2c:	e9 f1 f1 ff ff       	jmp    80106e22 <alltraps>

80107c31 <vector195>:
80107c31:	6a 00                	push   $0x0
80107c33:	68 c3 00 00 00       	push   $0xc3
80107c38:	e9 e5 f1 ff ff       	jmp    80106e22 <alltraps>

80107c3d <vector196>:
80107c3d:	6a 00                	push   $0x0
80107c3f:	68 c4 00 00 00       	push   $0xc4
80107c44:	e9 d9 f1 ff ff       	jmp    80106e22 <alltraps>

80107c49 <vector197>:
80107c49:	6a 00                	push   $0x0
80107c4b:	68 c5 00 00 00       	push   $0xc5
80107c50:	e9 cd f1 ff ff       	jmp    80106e22 <alltraps>

80107c55 <vector198>:
80107c55:	6a 00                	push   $0x0
80107c57:	68 c6 00 00 00       	push   $0xc6
80107c5c:	e9 c1 f1 ff ff       	jmp    80106e22 <alltraps>

80107c61 <vector199>:
80107c61:	6a 00                	push   $0x0
80107c63:	68 c7 00 00 00       	push   $0xc7
80107c68:	e9 b5 f1 ff ff       	jmp    80106e22 <alltraps>

80107c6d <vector200>:
80107c6d:	6a 00                	push   $0x0
80107c6f:	68 c8 00 00 00       	push   $0xc8
80107c74:	e9 a9 f1 ff ff       	jmp    80106e22 <alltraps>

80107c79 <vector201>:
80107c79:	6a 00                	push   $0x0
80107c7b:	68 c9 00 00 00       	push   $0xc9
80107c80:	e9 9d f1 ff ff       	jmp    80106e22 <alltraps>

80107c85 <vector202>:
80107c85:	6a 00                	push   $0x0
80107c87:	68 ca 00 00 00       	push   $0xca
80107c8c:	e9 91 f1 ff ff       	jmp    80106e22 <alltraps>

80107c91 <vector203>:
80107c91:	6a 00                	push   $0x0
80107c93:	68 cb 00 00 00       	push   $0xcb
80107c98:	e9 85 f1 ff ff       	jmp    80106e22 <alltraps>

80107c9d <vector204>:
80107c9d:	6a 00                	push   $0x0
80107c9f:	68 cc 00 00 00       	push   $0xcc
80107ca4:	e9 79 f1 ff ff       	jmp    80106e22 <alltraps>

80107ca9 <vector205>:
80107ca9:	6a 00                	push   $0x0
80107cab:	68 cd 00 00 00       	push   $0xcd
80107cb0:	e9 6d f1 ff ff       	jmp    80106e22 <alltraps>

80107cb5 <vector206>:
80107cb5:	6a 00                	push   $0x0
80107cb7:	68 ce 00 00 00       	push   $0xce
80107cbc:	e9 61 f1 ff ff       	jmp    80106e22 <alltraps>

80107cc1 <vector207>:
80107cc1:	6a 00                	push   $0x0
80107cc3:	68 cf 00 00 00       	push   $0xcf
80107cc8:	e9 55 f1 ff ff       	jmp    80106e22 <alltraps>

80107ccd <vector208>:
80107ccd:	6a 00                	push   $0x0
80107ccf:	68 d0 00 00 00       	push   $0xd0
80107cd4:	e9 49 f1 ff ff       	jmp    80106e22 <alltraps>

80107cd9 <vector209>:
80107cd9:	6a 00                	push   $0x0
80107cdb:	68 d1 00 00 00       	push   $0xd1
80107ce0:	e9 3d f1 ff ff       	jmp    80106e22 <alltraps>

80107ce5 <vector210>:
80107ce5:	6a 00                	push   $0x0
80107ce7:	68 d2 00 00 00       	push   $0xd2
80107cec:	e9 31 f1 ff ff       	jmp    80106e22 <alltraps>

80107cf1 <vector211>:
80107cf1:	6a 00                	push   $0x0
80107cf3:	68 d3 00 00 00       	push   $0xd3
80107cf8:	e9 25 f1 ff ff       	jmp    80106e22 <alltraps>

80107cfd <vector212>:
80107cfd:	6a 00                	push   $0x0
80107cff:	68 d4 00 00 00       	push   $0xd4
80107d04:	e9 19 f1 ff ff       	jmp    80106e22 <alltraps>

80107d09 <vector213>:
80107d09:	6a 00                	push   $0x0
80107d0b:	68 d5 00 00 00       	push   $0xd5
80107d10:	e9 0d f1 ff ff       	jmp    80106e22 <alltraps>

80107d15 <vector214>:
80107d15:	6a 00                	push   $0x0
80107d17:	68 d6 00 00 00       	push   $0xd6
80107d1c:	e9 01 f1 ff ff       	jmp    80106e22 <alltraps>

80107d21 <vector215>:
80107d21:	6a 00                	push   $0x0
80107d23:	68 d7 00 00 00       	push   $0xd7
80107d28:	e9 f5 f0 ff ff       	jmp    80106e22 <alltraps>

80107d2d <vector216>:
80107d2d:	6a 00                	push   $0x0
80107d2f:	68 d8 00 00 00       	push   $0xd8
80107d34:	e9 e9 f0 ff ff       	jmp    80106e22 <alltraps>

80107d39 <vector217>:
80107d39:	6a 00                	push   $0x0
80107d3b:	68 d9 00 00 00       	push   $0xd9
80107d40:	e9 dd f0 ff ff       	jmp    80106e22 <alltraps>

80107d45 <vector218>:
80107d45:	6a 00                	push   $0x0
80107d47:	68 da 00 00 00       	push   $0xda
80107d4c:	e9 d1 f0 ff ff       	jmp    80106e22 <alltraps>

80107d51 <vector219>:
80107d51:	6a 00                	push   $0x0
80107d53:	68 db 00 00 00       	push   $0xdb
80107d58:	e9 c5 f0 ff ff       	jmp    80106e22 <alltraps>

80107d5d <vector220>:
80107d5d:	6a 00                	push   $0x0
80107d5f:	68 dc 00 00 00       	push   $0xdc
80107d64:	e9 b9 f0 ff ff       	jmp    80106e22 <alltraps>

80107d69 <vector221>:
80107d69:	6a 00                	push   $0x0
80107d6b:	68 dd 00 00 00       	push   $0xdd
80107d70:	e9 ad f0 ff ff       	jmp    80106e22 <alltraps>

80107d75 <vector222>:
80107d75:	6a 00                	push   $0x0
80107d77:	68 de 00 00 00       	push   $0xde
80107d7c:	e9 a1 f0 ff ff       	jmp    80106e22 <alltraps>

80107d81 <vector223>:
80107d81:	6a 00                	push   $0x0
80107d83:	68 df 00 00 00       	push   $0xdf
80107d88:	e9 95 f0 ff ff       	jmp    80106e22 <alltraps>

80107d8d <vector224>:
80107d8d:	6a 00                	push   $0x0
80107d8f:	68 e0 00 00 00       	push   $0xe0
80107d94:	e9 89 f0 ff ff       	jmp    80106e22 <alltraps>

80107d99 <vector225>:
80107d99:	6a 00                	push   $0x0
80107d9b:	68 e1 00 00 00       	push   $0xe1
80107da0:	e9 7d f0 ff ff       	jmp    80106e22 <alltraps>

80107da5 <vector226>:
80107da5:	6a 00                	push   $0x0
80107da7:	68 e2 00 00 00       	push   $0xe2
80107dac:	e9 71 f0 ff ff       	jmp    80106e22 <alltraps>

80107db1 <vector227>:
80107db1:	6a 00                	push   $0x0
80107db3:	68 e3 00 00 00       	push   $0xe3
80107db8:	e9 65 f0 ff ff       	jmp    80106e22 <alltraps>

80107dbd <vector228>:
80107dbd:	6a 00                	push   $0x0
80107dbf:	68 e4 00 00 00       	push   $0xe4
80107dc4:	e9 59 f0 ff ff       	jmp    80106e22 <alltraps>

80107dc9 <vector229>:
80107dc9:	6a 00                	push   $0x0
80107dcb:	68 e5 00 00 00       	push   $0xe5
80107dd0:	e9 4d f0 ff ff       	jmp    80106e22 <alltraps>

80107dd5 <vector230>:
80107dd5:	6a 00                	push   $0x0
80107dd7:	68 e6 00 00 00       	push   $0xe6
80107ddc:	e9 41 f0 ff ff       	jmp    80106e22 <alltraps>

80107de1 <vector231>:
80107de1:	6a 00                	push   $0x0
80107de3:	68 e7 00 00 00       	push   $0xe7
80107de8:	e9 35 f0 ff ff       	jmp    80106e22 <alltraps>

80107ded <vector232>:
80107ded:	6a 00                	push   $0x0
80107def:	68 e8 00 00 00       	push   $0xe8
80107df4:	e9 29 f0 ff ff       	jmp    80106e22 <alltraps>

80107df9 <vector233>:
80107df9:	6a 00                	push   $0x0
80107dfb:	68 e9 00 00 00       	push   $0xe9
80107e00:	e9 1d f0 ff ff       	jmp    80106e22 <alltraps>

80107e05 <vector234>:
80107e05:	6a 00                	push   $0x0
80107e07:	68 ea 00 00 00       	push   $0xea
80107e0c:	e9 11 f0 ff ff       	jmp    80106e22 <alltraps>

80107e11 <vector235>:
80107e11:	6a 00                	push   $0x0
80107e13:	68 eb 00 00 00       	push   $0xeb
80107e18:	e9 05 f0 ff ff       	jmp    80106e22 <alltraps>

80107e1d <vector236>:
80107e1d:	6a 00                	push   $0x0
80107e1f:	68 ec 00 00 00       	push   $0xec
80107e24:	e9 f9 ef ff ff       	jmp    80106e22 <alltraps>

80107e29 <vector237>:
80107e29:	6a 00                	push   $0x0
80107e2b:	68 ed 00 00 00       	push   $0xed
80107e30:	e9 ed ef ff ff       	jmp    80106e22 <alltraps>

80107e35 <vector238>:
80107e35:	6a 00                	push   $0x0
80107e37:	68 ee 00 00 00       	push   $0xee
80107e3c:	e9 e1 ef ff ff       	jmp    80106e22 <alltraps>

80107e41 <vector239>:
80107e41:	6a 00                	push   $0x0
80107e43:	68 ef 00 00 00       	push   $0xef
80107e48:	e9 d5 ef ff ff       	jmp    80106e22 <alltraps>

80107e4d <vector240>:
80107e4d:	6a 00                	push   $0x0
80107e4f:	68 f0 00 00 00       	push   $0xf0
80107e54:	e9 c9 ef ff ff       	jmp    80106e22 <alltraps>

80107e59 <vector241>:
80107e59:	6a 00                	push   $0x0
80107e5b:	68 f1 00 00 00       	push   $0xf1
80107e60:	e9 bd ef ff ff       	jmp    80106e22 <alltraps>

80107e65 <vector242>:
80107e65:	6a 00                	push   $0x0
80107e67:	68 f2 00 00 00       	push   $0xf2
80107e6c:	e9 b1 ef ff ff       	jmp    80106e22 <alltraps>

80107e71 <vector243>:
80107e71:	6a 00                	push   $0x0
80107e73:	68 f3 00 00 00       	push   $0xf3
80107e78:	e9 a5 ef ff ff       	jmp    80106e22 <alltraps>

80107e7d <vector244>:
80107e7d:	6a 00                	push   $0x0
80107e7f:	68 f4 00 00 00       	push   $0xf4
80107e84:	e9 99 ef ff ff       	jmp    80106e22 <alltraps>

80107e89 <vector245>:
80107e89:	6a 00                	push   $0x0
80107e8b:	68 f5 00 00 00       	push   $0xf5
80107e90:	e9 8d ef ff ff       	jmp    80106e22 <alltraps>

80107e95 <vector246>:
80107e95:	6a 00                	push   $0x0
80107e97:	68 f6 00 00 00       	push   $0xf6
80107e9c:	e9 81 ef ff ff       	jmp    80106e22 <alltraps>

80107ea1 <vector247>:
80107ea1:	6a 00                	push   $0x0
80107ea3:	68 f7 00 00 00       	push   $0xf7
80107ea8:	e9 75 ef ff ff       	jmp    80106e22 <alltraps>

80107ead <vector248>:
80107ead:	6a 00                	push   $0x0
80107eaf:	68 f8 00 00 00       	push   $0xf8
80107eb4:	e9 69 ef ff ff       	jmp    80106e22 <alltraps>

80107eb9 <vector249>:
80107eb9:	6a 00                	push   $0x0
80107ebb:	68 f9 00 00 00       	push   $0xf9
80107ec0:	e9 5d ef ff ff       	jmp    80106e22 <alltraps>

80107ec5 <vector250>:
80107ec5:	6a 00                	push   $0x0
80107ec7:	68 fa 00 00 00       	push   $0xfa
80107ecc:	e9 51 ef ff ff       	jmp    80106e22 <alltraps>

80107ed1 <vector251>:
80107ed1:	6a 00                	push   $0x0
80107ed3:	68 fb 00 00 00       	push   $0xfb
80107ed8:	e9 45 ef ff ff       	jmp    80106e22 <alltraps>

80107edd <vector252>:
80107edd:	6a 00                	push   $0x0
80107edf:	68 fc 00 00 00       	push   $0xfc
80107ee4:	e9 39 ef ff ff       	jmp    80106e22 <alltraps>

80107ee9 <vector253>:
80107ee9:	6a 00                	push   $0x0
80107eeb:	68 fd 00 00 00       	push   $0xfd
80107ef0:	e9 2d ef ff ff       	jmp    80106e22 <alltraps>

80107ef5 <vector254>:
80107ef5:	6a 00                	push   $0x0
80107ef7:	68 fe 00 00 00       	push   $0xfe
80107efc:	e9 21 ef ff ff       	jmp    80106e22 <alltraps>

80107f01 <vector255>:
80107f01:	6a 00                	push   $0x0
80107f03:	68 ff 00 00 00       	push   $0xff
80107f08:	e9 15 ef ff ff       	jmp    80106e22 <alltraps>

80107f0d <lgdt>:
{
80107f0d:	55                   	push   %ebp
80107f0e:	89 e5                	mov    %esp,%ebp
80107f10:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107f13:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f16:	48                   	dec    %eax
80107f17:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f1b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f22:	8b 45 08             	mov    0x8(%ebp),%eax
80107f25:	c1 e8 10             	shr    $0x10,%eax
80107f28:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107f2c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f2f:	0f 01 10             	lgdtl  (%eax)
}
80107f32:	c9                   	leave  
80107f33:	c3                   	ret    

80107f34 <ltr>:
{
80107f34:	55                   	push   %ebp
80107f35:	89 e5                	mov    %esp,%ebp
80107f37:	83 ec 04             	sub    $0x4,%esp
80107f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f3d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f44:	0f 00 d8             	ltr    %ax
}
80107f47:	c9                   	leave  
80107f48:	c3                   	ret    

80107f49 <loadgs>:
{
80107f49:	55                   	push   %ebp
80107f4a:	89 e5                	mov    %esp,%ebp
80107f4c:	83 ec 04             	sub    $0x4,%esp
80107f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80107f52:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f59:	8e e8                	mov    %eax,%gs
}
80107f5b:	c9                   	leave  
80107f5c:	c3                   	ret    

80107f5d <lcr3>:

static inline void
lcr3(uint val) 
{
80107f5d:	55                   	push   %ebp
80107f5e:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f60:	8b 45 08             	mov    0x8(%ebp),%eax
80107f63:	0f 22 d8             	mov    %eax,%cr3
}
80107f66:	5d                   	pop    %ebp
80107f67:	c3                   	ret    

80107f68 <v2p>:
80107f68:	55                   	push   %ebp
80107f69:	89 e5                	mov    %esp,%ebp
80107f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f6e:	05 00 00 00 80       	add    $0x80000000,%eax
80107f73:	5d                   	pop    %ebp
80107f74:	c3                   	ret    

80107f75 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f75:	55                   	push   %ebp
80107f76:	89 e5                	mov    %esp,%ebp
80107f78:	8b 45 08             	mov    0x8(%ebp),%eax
80107f7b:	05 00 00 00 80       	add    $0x80000000,%eax
80107f80:	5d                   	pop    %ebp
80107f81:	c3                   	ret    

80107f82 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f82:	55                   	push   %ebp
80107f83:	89 e5                	mov    %esp,%ebp
80107f85:	53                   	push   %ebx
80107f86:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107f89:	e8 b7 ae ff ff       	call   80102e45 <cpunum>
80107f8e:	89 c2                	mov    %eax,%edx
80107f90:	89 d0                	mov    %edx,%eax
80107f92:	d1 e0                	shl    %eax
80107f94:	01 d0                	add    %edx,%eax
80107f96:	c1 e0 04             	shl    $0x4,%eax
80107f99:	29 d0                	sub    %edx,%eax
80107f9b:	c1 e0 02             	shl    $0x2,%eax
80107f9e:	05 60 09 11 80       	add    $0x80110960,%eax
80107fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa9:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbb:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc2:	8a 50 7d             	mov    0x7d(%eax),%dl
80107fc5:	83 e2 f0             	and    $0xfffffff0,%edx
80107fc8:	83 ca 0a             	or     $0xa,%edx
80107fcb:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd1:	8a 50 7d             	mov    0x7d(%eax),%dl
80107fd4:	83 ca 10             	or     $0x10,%edx
80107fd7:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fdd:	8a 50 7d             	mov    0x7d(%eax),%dl
80107fe0:	83 e2 9f             	and    $0xffffff9f,%edx
80107fe3:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe9:	8a 50 7d             	mov    0x7d(%eax),%dl
80107fec:	83 ca 80             	or     $0xffffff80,%edx
80107fef:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff5:	8a 50 7e             	mov    0x7e(%eax),%dl
80107ff8:	83 ca 0f             	or     $0xf,%edx
80107ffb:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108001:	8a 50 7e             	mov    0x7e(%eax),%dl
80108004:	83 e2 ef             	and    $0xffffffef,%edx
80108007:	88 50 7e             	mov    %dl,0x7e(%eax)
8010800a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800d:	8a 50 7e             	mov    0x7e(%eax),%dl
80108010:	83 e2 df             	and    $0xffffffdf,%edx
80108013:	88 50 7e             	mov    %dl,0x7e(%eax)
80108016:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108019:	8a 50 7e             	mov    0x7e(%eax),%dl
8010801c:	83 ca 40             	or     $0x40,%edx
8010801f:	88 50 7e             	mov    %dl,0x7e(%eax)
80108022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108025:	8a 50 7e             	mov    0x7e(%eax),%dl
80108028:	83 ca 80             	or     $0xffffff80,%edx
8010802b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010802e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108031:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108035:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108038:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010803f:	ff ff 
80108041:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108044:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010804b:	00 00 
8010804d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108050:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805a:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108060:	83 e2 f0             	and    $0xfffffff0,%edx
80108063:	83 ca 02             	or     $0x2,%edx
80108066:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010806c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806f:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108075:	83 ca 10             	or     $0x10,%edx
80108078:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108081:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108087:	83 e2 9f             	and    $0xffffff9f,%edx
8010808a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108090:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108093:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80108099:	83 ca 80             	or     $0xffffff80,%edx
8010809c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a5:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080ab:	83 ca 0f             	or     $0xf,%edx
801080ae:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b7:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080bd:	83 e2 ef             	and    $0xffffffef,%edx
801080c0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c9:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080cf:	83 e2 df             	and    $0xffffffdf,%edx
801080d2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080db:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080e1:	83 ca 40             	or     $0x40,%edx
801080e4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ed:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080f3:	83 ca 80             	or     $0xffffff80,%edx
801080f6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ff:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108109:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108110:	ff ff 
80108112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108115:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010811c:	00 00 
8010811e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108121:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108128:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812b:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108131:	83 e2 f0             	and    $0xfffffff0,%edx
80108134:	83 ca 0a             	or     $0xa,%edx
80108137:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010813d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108140:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108146:	83 ca 10             	or     $0x10,%edx
80108149:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010814f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108152:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80108158:	83 ca 60             	or     $0x60,%edx
8010815b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108164:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010816a:	83 ca 80             	or     $0xffffff80,%edx
8010816d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108176:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010817c:	83 ca 0f             	or     $0xf,%edx
8010817f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108188:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010818e:	83 e2 ef             	and    $0xffffffef,%edx
80108191:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819a:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081a0:	83 e2 df             	and    $0xffffffdf,%edx
801081a3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ac:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081b2:	83 ca 40             	or     $0x40,%edx
801081b5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081be:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081c4:	83 ca 80             	or     $0xffffff80,%edx
801081c7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d0:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801081d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081da:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801081e1:	ff ff 
801081e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e6:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801081ed:	00 00 
801081ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f2:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801081f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081fc:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108202:	83 e2 f0             	and    $0xfffffff0,%edx
80108205:	83 ca 02             	or     $0x2,%edx
80108208:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010820e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108211:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108217:	83 ca 10             	or     $0x10,%edx
8010821a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108223:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108229:	83 ca 60             	or     $0x60,%edx
8010822c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108232:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108235:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010823b:	83 ca 80             	or     $0xffffff80,%edx
8010823e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108247:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010824d:	83 ca 0f             	or     $0xf,%edx
80108250:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108256:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108259:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010825f:	83 e2 ef             	and    $0xffffffef,%edx
80108262:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108268:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826b:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108271:	83 e2 df             	and    $0xffffffdf,%edx
80108274:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010827a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827d:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108283:	83 ca 40             	or     $0x40,%edx
80108286:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010828c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828f:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108295:	83 ca 80             	or     $0xffffff80,%edx
80108298:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010829e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a1:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801082a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ab:	05 b4 00 00 00       	add    $0xb4,%eax
801082b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082b3:	81 c2 b4 00 00 00    	add    $0xb4,%edx
801082b9:	c1 ea 10             	shr    $0x10,%edx
801082bc:	88 d1                	mov    %dl,%cl
801082be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082c1:	81 c2 b4 00 00 00    	add    $0xb4,%edx
801082c7:	c1 ea 18             	shr    $0x18,%edx
801082ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801082cd:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
801082d4:	00 00 
801082d6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801082d9:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
801082e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e3:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801082e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ec:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801082f2:	83 e1 f0             	and    $0xfffffff0,%ecx
801082f5:	83 c9 02             	or     $0x2,%ecx
801082f8:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108301:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108307:	83 c9 10             	or     $0x10,%ecx
8010830a:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108310:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108313:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108319:	83 e1 9f             	and    $0xffffff9f,%ecx
8010831c:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108325:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010832b:	83 c9 80             	or     $0xffffff80,%ecx
8010832e:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108337:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010833d:	83 e1 f0             	and    $0xfffffff0,%ecx
80108340:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108346:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108349:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
8010834f:	83 e1 ef             	and    $0xffffffef,%ecx
80108352:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108361:	83 e1 df             	and    $0xffffffdf,%ecx
80108364:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010836a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836d:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108373:	83 c9 40             	or     $0x40,%ecx
80108376:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010837c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837f:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108385:	83 c9 80             	or     $0xffffff80,%ecx
80108388:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010838e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108391:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010839a:	83 c0 70             	add    $0x70,%eax
8010839d:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801083a4:	00 
801083a5:	89 04 24             	mov    %eax,(%esp)
801083a8:	e8 60 fb ff ff       	call   80107f0d <lgdt>
  loadgs(SEG_KCPU << 3);
801083ad:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801083b4:	e8 90 fb ff ff       	call   80107f49 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
801083b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083bc:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801083c2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801083c9:	00 00 00 00 
}
801083cd:	83 c4 24             	add    $0x24,%esp
801083d0:	5b                   	pop    %ebx
801083d1:	5d                   	pop    %ebp
801083d2:	c3                   	ret    

801083d3 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083d3:	55                   	push   %ebp
801083d4:	89 e5                	mov    %esp,%ebp
801083d6:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801083dc:	c1 e8 16             	shr    $0x16,%eax
801083df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083e6:	8b 45 08             	mov    0x8(%ebp),%eax
801083e9:	01 d0                	add    %edx,%eax
801083eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801083ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083f1:	8b 00                	mov    (%eax),%eax
801083f3:	83 e0 01             	and    $0x1,%eax
801083f6:	85 c0                	test   %eax,%eax
801083f8:	74 17                	je     80108411 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801083fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083fd:	8b 00                	mov    (%eax),%eax
801083ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108404:	89 04 24             	mov    %eax,(%esp)
80108407:	e8 69 fb ff ff       	call   80107f75 <p2v>
8010840c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010840f:	eb 4b                	jmp    8010845c <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0) // kalloc es 0 cuando no puede asignar la memoria.
80108411:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108415:	74 0e                	je     80108425 <walkpgdir+0x52>
80108417:	e8 a2 a6 ff ff       	call   80102abe <kalloc>
8010841c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010841f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108423:	75 07                	jne    8010842c <walkpgdir+0x59>
      return 0;
80108425:	b8 00 00 00 00       	mov    $0x0,%eax
8010842a:	eb 47                	jmp    80108473 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010842c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108433:	00 
80108434:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010843b:	00 
8010843c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843f:	89 04 24             	mov    %eax,(%esp)
80108442:	e8 9e d3 ff ff       	call   801057e5 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844a:	89 04 24             	mov    %eax,(%esp)
8010844d:	e8 16 fb ff ff       	call   80107f68 <v2p>
80108452:	89 c2                	mov    %eax,%edx
80108454:	83 ca 07             	or     $0x7,%edx
80108457:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010845a:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)]; // PTX (va) me retorna un index de la tabla de pagina, que luego aplicando, &pgtab[..] me retorna su direccion. 
8010845c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010845f:	c1 e8 0c             	shr    $0xc,%eax
80108462:	25 ff 03 00 00       	and    $0x3ff,%eax
80108467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010846e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108471:	01 d0                	add    %edx,%eax
}                         // por lo tanto , la direccion del index, de la tabla de paginas.
80108473:	c9                   	leave  
80108474:	c3                   	ret    

80108475 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned.
// retornaba "static int" lo cambie por int, si no me saltaba error
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108475:	55                   	push   %ebp
80108476:	89 e5                	mov    %esp,%ebp
80108478:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010847b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010847e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108486:	8b 55 0c             	mov    0xc(%ebp),%edx
80108489:	8b 45 10             	mov    0x10(%ebp),%eax
8010848c:	01 d0                	add    %edx,%eax
8010848e:	48                   	dec    %eax
8010848f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108494:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0) // walkpgdir: create any required page table pages, osea
80108497:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010849e:	00 
8010849f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801084a6:	8b 45 08             	mov    0x8(%ebp),%eax
801084a9:	89 04 24             	mov    %eax,(%esp)
801084ac:	e8 22 ff ff ff       	call   801083d3 <walkpgdir>
801084b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084b8:	75 07                	jne    801084c1 <mappages+0x4c>
                                            // crea cualquier pagina requerida para la tabla de paginas.
                                            // retorna la direccion de donde fue creada en la tabla pgdir.
      return -1; // no fue posible mapear, debido a que el walkpgdir no pudo asignar la memoria o alloc no es 1
801084ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084bf:	eb 46                	jmp    80108507 <mappages+0x92>
    if(*pte & PTE_P)
801084c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084c4:	8b 00                	mov    (%eax),%eax
801084c6:	83 e0 01             	and    $0x1,%eax
801084c9:	85 c0                	test   %eax,%eax
801084cb:	74 0c                	je     801084d9 <mappages+0x64>
      panic("remap");
801084cd:	c7 04 24 ec 93 10 80 	movl   $0x801093ec,(%esp)
801084d4:	e8 5d 80 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
801084d9:	8b 45 18             	mov    0x18(%ebp),%eax
801084dc:	0b 45 14             	or     0x14(%ebp),%eax
801084df:	89 c2                	mov    %eax,%edx
801084e1:	83 ca 01             	or     $0x1,%edx
801084e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084e7:	89 10                	mov    %edx,(%eax)
    if(a == last)
801084e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084ef:	74 10                	je     80108501 <mappages+0x8c>
      break;
    a += PGSIZE;
801084f1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801084f8:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801084ff:	eb 96                	jmp    80108497 <mappages+0x22>
      break;
80108501:	90                   	nop
  return 0;
80108502:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108507:	c9                   	leave  
80108508:	c3                   	ret    

80108509 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108509:	55                   	push   %ebp
8010850a:	89 e5                	mov    %esp,%ebp
8010850c:	53                   	push   %ebx
8010850d:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108510:	e8 a9 a5 ff ff       	call   80102abe <kalloc>
80108515:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010851c:	75 0a                	jne    80108528 <setupkvm+0x1f>
    return 0;
8010851e:	b8 00 00 00 00       	mov    $0x0,%eax
80108523:	e9 98 00 00 00       	jmp    801085c0 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108528:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010852f:	00 
80108530:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108537:	00 
80108538:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010853b:	89 04 24             	mov    %eax,(%esp)
8010853e:	e8 a2 d2 ff ff       	call   801057e5 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108543:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
8010854a:	e8 26 fa ff ff       	call   80107f75 <p2v>
8010854f:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108554:	76 0c                	jbe    80108562 <setupkvm+0x59>
    panic("PHYSTOP too high");
80108556:	c7 04 24 f2 93 10 80 	movl   $0x801093f2,(%esp)
8010855d:	e8 d4 7f ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108562:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
80108569:	eb 49                	jmp    801085b4 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
8010856b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010856e:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108571:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108574:	8b 50 04             	mov    0x4(%eax),%edx
80108577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010857a:	8b 58 08             	mov    0x8(%eax),%ebx
8010857d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108580:	8b 40 04             	mov    0x4(%eax),%eax
80108583:	29 c3                	sub    %eax,%ebx
80108585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108588:	8b 00                	mov    (%eax),%eax
8010858a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
8010858e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108592:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108596:	89 44 24 04          	mov    %eax,0x4(%esp)
8010859a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010859d:	89 04 24             	mov    %eax,(%esp)
801085a0:	e8 d0 fe ff ff       	call   80108475 <mappages>
801085a5:	85 c0                	test   %eax,%eax
801085a7:	79 07                	jns    801085b0 <setupkvm+0xa7>
      return 0;
801085a9:	b8 00 00 00 00       	mov    $0x0,%eax
801085ae:	eb 10                	jmp    801085c0 <setupkvm+0xb7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085b0:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801085b4:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
801085bb:	72 ae                	jb     8010856b <setupkvm+0x62>
  return pgdir;
801085bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801085c0:	83 c4 34             	add    $0x34,%esp
801085c3:	5b                   	pop    %ebx
801085c4:	5d                   	pop    %ebp
801085c5:	c3                   	ret    

801085c6 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801085c6:	55                   	push   %ebp
801085c7:	89 e5                	mov    %esp,%ebp
801085c9:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801085cc:	e8 38 ff ff ff       	call   80108509 <setupkvm>
801085d1:	a3 b8 44 11 80       	mov    %eax,0x801144b8
  switchkvm();
801085d6:	e8 02 00 00 00       	call   801085dd <switchkvm>
}
801085db:	c9                   	leave  
801085dc:	c3                   	ret    

801085dd <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801085dd:	55                   	push   %ebp
801085de:	89 e5                	mov    %esp,%ebp
801085e0:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801085e3:	a1 b8 44 11 80       	mov    0x801144b8,%eax
801085e8:	89 04 24             	mov    %eax,(%esp)
801085eb:	e8 78 f9 ff ff       	call   80107f68 <v2p>
801085f0:	89 04 24             	mov    %eax,(%esp)
801085f3:	e8 65 f9 ff ff       	call   80107f5d <lcr3>
}
801085f8:	c9                   	leave  
801085f9:	c3                   	ret    

801085fa <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801085fa:	55                   	push   %ebp
801085fb:	89 e5                	mov    %esp,%ebp
801085fd:	53                   	push   %ebx
801085fe:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80108601:	e8 df d0 ff ff       	call   801056e5 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80108606:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010860c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108613:	83 c2 08             	add    $0x8,%edx
80108616:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
8010861d:	83 c1 08             	add    $0x8,%ecx
80108620:	c1 e9 10             	shr    $0x10,%ecx
80108623:	88 cb                	mov    %cl,%bl
80108625:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
8010862c:	83 c1 08             	add    $0x8,%ecx
8010862f:	c1 e9 18             	shr    $0x18,%ecx
80108632:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108639:	67 00 
8010863b:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80108642:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108648:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010864e:	83 e2 f0             	and    $0xfffffff0,%edx
80108651:	83 ca 09             	or     $0x9,%edx
80108654:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
8010865a:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108660:	83 ca 10             	or     $0x10,%edx
80108663:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108669:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010866f:	83 e2 9f             	and    $0xffffff9f,%edx
80108672:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108678:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010867e:	83 ca 80             	or     $0xffffff80,%edx
80108681:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108687:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010868d:	83 e2 f0             	and    $0xfffffff0,%edx
80108690:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108696:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
8010869c:	83 e2 ef             	and    $0xffffffef,%edx
8010869f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086a5:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086ab:	83 e2 df             	and    $0xffffffdf,%edx
801086ae:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086b4:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086ba:	83 ca 40             	or     $0x40,%edx
801086bd:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086c3:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086c9:	83 e2 7f             	and    $0x7f,%edx
801086cc:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086d2:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801086d8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086de:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801086e4:	83 e2 ef             	and    $0xffffffef,%edx
801086e7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801086ed:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086f3:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801086f9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086ff:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80108706:	8b 52 08             	mov    0x8(%edx),%edx
80108709:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010870f:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108712:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108719:	e8 16 f8 ff ff       	call   80107f34 <ltr>
  if(p->pgdir == 0)
8010871e:	8b 45 08             	mov    0x8(%ebp),%eax
80108721:	8b 40 04             	mov    0x4(%eax),%eax
80108724:	85 c0                	test   %eax,%eax
80108726:	75 0c                	jne    80108734 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80108728:	c7 04 24 03 94 10 80 	movl   $0x80109403,(%esp)
8010872f:	e8 02 7e ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108734:	8b 45 08             	mov    0x8(%ebp),%eax
80108737:	8b 40 04             	mov    0x4(%eax),%eax
8010873a:	89 04 24             	mov    %eax,(%esp)
8010873d:	e8 26 f8 ff ff       	call   80107f68 <v2p>
80108742:	89 04 24             	mov    %eax,(%esp)
80108745:	e8 13 f8 ff ff       	call   80107f5d <lcr3>
  popcli();
8010874a:	e8 dc cf ff ff       	call   8010572b <popcli>
}
8010874f:	83 c4 14             	add    $0x14,%esp
80108752:	5b                   	pop    %ebx
80108753:	5d                   	pop    %ebp
80108754:	c3                   	ret    

80108755 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108755:	55                   	push   %ebp
80108756:	89 e5                	mov    %esp,%ebp
80108758:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010875b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108762:	76 0c                	jbe    80108770 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108764:	c7 04 24 17 94 10 80 	movl   $0x80109417,(%esp)
8010876b:	e8 c6 7d ff ff       	call   80100536 <panic>
  mem = kalloc();
80108770:	e8 49 a3 ff ff       	call   80102abe <kalloc>
80108775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80108778:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010877f:	00 
80108780:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108787:	00 
80108788:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010878b:	89 04 24             	mov    %eax,(%esp)
8010878e:	e8 52 d0 ff ff       	call   801057e5 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108796:	89 04 24             	mov    %eax,(%esp)
80108799:	e8 ca f7 ff ff       	call   80107f68 <v2p>
8010879e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801087a5:	00 
801087a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801087aa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087b1:	00 
801087b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801087b9:	00 
801087ba:	8b 45 08             	mov    0x8(%ebp),%eax
801087bd:	89 04 24             	mov    %eax,(%esp)
801087c0:	e8 b0 fc ff ff       	call   80108475 <mappages>
  memmove(mem, init, sz);
801087c5:	8b 45 10             	mov    0x10(%ebp),%eax
801087c8:	89 44 24 08          	mov    %eax,0x8(%esp)
801087cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801087cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801087d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d6:	89 04 24             	mov    %eax,(%esp)
801087d9:	e8 d3 d0 ff ff       	call   801058b1 <memmove>
}
801087de:	c9                   	leave  
801087df:	c3                   	ret    

801087e0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801087e0:	55                   	push   %ebp
801087e1:	89 e5                	mov    %esp,%ebp
801087e3:	53                   	push   %ebx
801087e4:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801087e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801087ea:	25 ff 0f 00 00       	and    $0xfff,%eax
801087ef:	85 c0                	test   %eax,%eax
801087f1:	74 0c                	je     801087ff <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801087f3:	c7 04 24 34 94 10 80 	movl   $0x80109434,(%esp)
801087fa:	e8 37 7d ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801087ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108806:	e9 ad 00 00 00       	jmp    801088b8 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010880b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010880e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108811:	01 d0                	add    %edx,%eax
80108813:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010881a:	00 
8010881b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010881f:	8b 45 08             	mov    0x8(%ebp),%eax
80108822:	89 04 24             	mov    %eax,(%esp)
80108825:	e8 a9 fb ff ff       	call   801083d3 <walkpgdir>
8010882a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010882d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108831:	75 0c                	jne    8010883f <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108833:	c7 04 24 57 94 10 80 	movl   $0x80109457,(%esp)
8010883a:	e8 f7 7c ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
8010883f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108842:	8b 00                	mov    (%eax),%eax
80108844:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108849:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010884c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010884f:	8b 55 18             	mov    0x18(%ebp),%edx
80108852:	89 d1                	mov    %edx,%ecx
80108854:	29 c1                	sub    %eax,%ecx
80108856:	89 c8                	mov    %ecx,%eax
80108858:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010885d:	77 11                	ja     80108870 <loaduvm+0x90>
      n = sz - i;
8010885f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108862:	8b 55 18             	mov    0x18(%ebp),%edx
80108865:	89 d1                	mov    %edx,%ecx
80108867:	29 c1                	sub    %eax,%ecx
80108869:	89 c8                	mov    %ecx,%eax
8010886b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010886e:	eb 07                	jmp    80108877 <loaduvm+0x97>
    else
      n = PGSIZE;
80108870:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010887a:	8b 55 14             	mov    0x14(%ebp),%edx
8010887d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108880:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108883:	89 04 24             	mov    %eax,(%esp)
80108886:	e8 ea f6 ff ff       	call   80107f75 <p2v>
8010888b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010888e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108892:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108896:	89 44 24 04          	mov    %eax,0x4(%esp)
8010889a:	8b 45 10             	mov    0x10(%ebp),%eax
8010889d:	89 04 24             	mov    %eax,(%esp)
801088a0:	e8 a7 94 ff ff       	call   80101d4c <readi>
801088a5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801088a8:	74 07                	je     801088b1 <loaduvm+0xd1>
      return -1;
801088aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088af:	eb 18                	jmp    801088c9 <loaduvm+0xe9>
  for(i = 0; i < sz; i += PGSIZE){
801088b1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088bb:	3b 45 18             	cmp    0x18(%ebp),%eax
801088be:	0f 82 47 ff ff ff    	jb     8010880b <loaduvm+0x2b>
  }
  return 0;
801088c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088c9:	83 c4 24             	add    $0x24,%esp
801088cc:	5b                   	pop    %ebx
801088cd:	5d                   	pop    %ebp
801088ce:	c3                   	ret    

801088cf <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801088cf:	55                   	push   %ebp
801088d0:	89 e5                	mov    %esp,%ebp
801088d2:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801088d5:	8b 45 10             	mov    0x10(%ebp),%eax
801088d8:	85 c0                	test   %eax,%eax
801088da:	79 0a                	jns    801088e6 <allocuvm+0x17>
    return 0;
801088dc:	b8 00 00 00 00       	mov    $0x0,%eax
801088e1:	e9 c1 00 00 00       	jmp    801089a7 <allocuvm+0xd8>
  if(newsz < oldsz)
801088e6:	8b 45 10             	mov    0x10(%ebp),%eax
801088e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088ec:	73 08                	jae    801088f6 <allocuvm+0x27>
    return oldsz;
801088ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801088f1:	e9 b1 00 00 00       	jmp    801089a7 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801088f6:	8b 45 0c             	mov    0xc(%ebp),%eax
801088f9:	05 ff 0f 00 00       	add    $0xfff,%eax
801088fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108903:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108906:	e9 8d 00 00 00       	jmp    80108998 <allocuvm+0xc9>
    mem = kalloc();
8010890b:	e8 ae a1 ff ff       	call   80102abe <kalloc>
80108910:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108917:	75 2c                	jne    80108945 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108919:	c7 04 24 75 94 10 80 	movl   $0x80109475,(%esp)
80108920:	e8 7c 7a ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108925:	8b 45 0c             	mov    0xc(%ebp),%eax
80108928:	89 44 24 08          	mov    %eax,0x8(%esp)
8010892c:	8b 45 10             	mov    0x10(%ebp),%eax
8010892f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108933:	8b 45 08             	mov    0x8(%ebp),%eax
80108936:	89 04 24             	mov    %eax,(%esp)
80108939:	e8 6b 00 00 00       	call   801089a9 <deallocuvm>
      return 0;
8010893e:	b8 00 00 00 00       	mov    $0x0,%eax
80108943:	eb 62                	jmp    801089a7 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108945:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010894c:	00 
8010894d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108954:	00 
80108955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108958:	89 04 24             	mov    %eax,(%esp)
8010895b:	e8 85 ce ff ff       	call   801057e5 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108963:	89 04 24             	mov    %eax,(%esp)
80108966:	e8 fd f5 ff ff       	call   80107f68 <v2p>
8010896b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010896e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108975:	00 
80108976:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010897a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108981:	00 
80108982:	89 54 24 04          	mov    %edx,0x4(%esp)
80108986:	8b 45 08             	mov    0x8(%ebp),%eax
80108989:	89 04 24             	mov    %eax,(%esp)
8010898c:	e8 e4 fa ff ff       	call   80108475 <mappages>
  for(; a < newsz; a += PGSIZE){
80108991:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108998:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010899b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010899e:	0f 82 67 ff ff ff    	jb     8010890b <allocuvm+0x3c>
  }
  return newsz;
801089a4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089a7:	c9                   	leave  
801089a8:	c3                   	ret    

801089a9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801089a9:	55                   	push   %ebp
801089aa:	89 e5                	mov    %esp,%ebp
801089ac:	83 ec 38             	sub    $0x38,%esp
  pte_t *pte;
  uint a, pa;
  int save_this = 1; // New: Add in project final 
801089af:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  if(newsz >= oldsz)
801089b6:	8b 45 10             	mov    0x10(%ebp),%eax
801089b9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089bc:	72 08                	jb     801089c6 <deallocuvm+0x1d>
    return oldsz;
801089be:	8b 45 0c             	mov    0xc(%ebp),%eax
801089c1:	e9 b8 00 00 00       	jmp    80108a7e <deallocuvm+0xd5>

  //pte_s
  a = PGROUNDUP(newsz);
801089c6:	8b 45 10             	mov    0x10(%ebp),%eax
801089c9:	05 ff 0f 00 00       	add    $0xfff,%eax
801089ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801089d6:	e9 94 00 00 00       	jmp    80108a6f <deallocuvm+0xc6>
    pte = walkpgdir(pgdir, (char*)a, 0);
801089db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089e5:	00 
801089e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801089ea:	8b 45 08             	mov    0x8(%ebp),%eax
801089ed:	89 04 24             	mov    %eax,(%esp)
801089f0:	e8 de f9 ff ff       	call   801083d3 <walkpgdir>
801089f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(!pte)
801089f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801089fc:	75 09                	jne    80108a07 <deallocuvm+0x5e>
      a += (NPTENTRIES - 1) * PGSIZE;
801089fe:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a05:	eb 61                	jmp    80108a68 <deallocuvm+0xbf>
    else if((*pte & PTE_P) != 0){
80108a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a0a:	8b 00                	mov    (%eax),%eax
80108a0c:	83 e0 01             	and    $0x1,%eax
80108a0f:	85 c0                	test   %eax,%eax
80108a11:	74 55                	je     80108a68 <deallocuvm+0xbf>
      pa = PTE_ADDR(*pte);
80108a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a16:	8b 00                	mov    (%eax),%eax
80108a18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      save_this = is_shared(pa); //New: Add in project final
80108a20:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a23:	89 04 24             	mov    %eax,(%esp)
80108a26:	e8 a4 03 00 00       	call   80108dcf <is_shared>
80108a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80108a2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a32:	75 0c                	jne    80108a40 <deallocuvm+0x97>
        panic("kfree");
80108a34:	c7 04 24 8d 94 10 80 	movl   $0x8010948d,(%esp)
80108a3b:	e8 f6 7a ff ff       	call   80100536 <panic>
      // char *v = p2v(pa);
      // kfree(v);
      // *pte = 0;
      if (!save_this){ // New: Add in project final, ahi uno solo, le aplico el kfree
80108a40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a44:	75 22                	jne    80108a68 <deallocuvm+0xbf>
        char *v = p2v(pa);
80108a46:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a49:	89 04 24             	mov    %eax,(%esp)
80108a4c:	e8 24 f5 ff ff       	call   80107f75 <p2v>
80108a51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(v);
80108a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a57:	89 04 24             	mov    %eax,(%esp)
80108a5a:	e8 c6 9f ff ff       	call   80102a25 <kfree>
        *pte = 0;
80108a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108a68:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a72:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a75:	0f 82 60 ff ff ff    	jb     801089db <deallocuvm+0x32>
      }
    }
  }
  return newsz;
80108a7b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a7e:	c9                   	leave  
80108a7f:	c3                   	ret    

80108a80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108a80:	55                   	push   %ebp
80108a81:	89 e5                	mov    %esp,%ebp
80108a83:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108a86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a8a:	75 0c                	jne    80108a98 <freevm+0x18>
    panic("freevm: no pgdir");
80108a8c:	c7 04 24 93 94 10 80 	movl   $0x80109493,(%esp)
80108a93:	e8 9e 7a ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a98:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a9f:	00 
80108aa0:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108aa7:	80 
80108aa8:	8b 45 08             	mov    0x8(%ebp),%eax
80108aab:	89 04 24             	mov    %eax,(%esp)
80108aae:	e8 f6 fe ff ff       	call   801089a9 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108ab3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108aba:	eb 47                	jmp    80108b03 <freevm+0x83>
    if(pgdir[i] & PTE_P){
80108abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ac6:	8b 45 08             	mov    0x8(%ebp),%eax
80108ac9:	01 d0                	add    %edx,%eax
80108acb:	8b 00                	mov    (%eax),%eax
80108acd:	83 e0 01             	and    $0x1,%eax
80108ad0:	85 c0                	test   %eax,%eax
80108ad2:	74 2c                	je     80108b00 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ad7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ade:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae1:	01 d0                	add    %edx,%eax
80108ae3:	8b 00                	mov    (%eax),%eax
80108ae5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108aea:	89 04 24             	mov    %eax,(%esp)
80108aed:	e8 83 f4 ff ff       	call   80107f75 <p2v>
80108af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108af8:	89 04 24             	mov    %eax,(%esp)
80108afb:	e8 25 9f ff ff       	call   80102a25 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108b00:	ff 45 f4             	incl   -0xc(%ebp)
80108b03:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b0a:	76 b0                	jbe    80108abc <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80108b0c:	8b 45 08             	mov    0x8(%ebp),%eax
80108b0f:	89 04 24             	mov    %eax,(%esp)
80108b12:	e8 0e 9f ff ff       	call   80102a25 <kfree>
}
80108b17:	c9                   	leave  
80108b18:	c3                   	ret    

80108b19 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b19:	55                   	push   %ebp
80108b1a:	89 e5                	mov    %esp,%ebp
80108b1c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b26:	00 
80108b27:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80108b31:	89 04 24             	mov    %eax,(%esp)
80108b34:	e8 9a f8 ff ff       	call   801083d3 <walkpgdir>
80108b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b40:	75 0c                	jne    80108b4e <clearpteu+0x35>
    panic("clearpteu");
80108b42:	c7 04 24 a4 94 10 80 	movl   $0x801094a4,(%esp)
80108b49:	e8 e8 79 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b51:	8b 00                	mov    (%eax),%eax
80108b53:	89 c2                	mov    %eax,%edx
80108b55:	83 e2 fb             	and    $0xfffffffb,%edx
80108b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b5b:	89 10                	mov    %edx,(%eax)
}
80108b5d:	c9                   	leave  
80108b5e:	c3                   	ret    

80108b5f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b5f:	55                   	push   %ebp
80108b60:	89 e5                	mov    %esp,%ebp
80108b62:	53                   	push   %ebx
80108b63:	83 ec 44             	sub    $0x44,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  int only_map; // New: Add in project final

  if((d = setupkvm()) == 0)
80108b66:	e8 9e f9 ff ff       	call   80108509 <setupkvm>
80108b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b72:	75 0a                	jne    80108b7e <copyuvm+0x1f>
    return 0;
80108b74:	b8 00 00 00 00       	mov    $0x0,%eax
80108b79:	e9 43 01 00 00       	jmp    80108cc1 <copyuvm+0x162>
  for(i = 0; i < sz; i += PGSIZE){
80108b7e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b85:	e9 12 01 00 00       	jmp    80108c9c <copyuvm+0x13d>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b94:	00 
80108b95:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b99:	8b 45 08             	mov    0x8(%ebp),%eax
80108b9c:	89 04 24             	mov    %eax,(%esp)
80108b9f:	e8 2f f8 ff ff       	call   801083d3 <walkpgdir>
80108ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108ba7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bab:	75 0c                	jne    80108bb9 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108bad:	c7 04 24 ae 94 10 80 	movl   $0x801094ae,(%esp)
80108bb4:	e8 7d 79 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
80108bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bbc:	8b 00                	mov    (%eax),%eax
80108bbe:	83 e0 01             	and    $0x1,%eax
80108bc1:	85 c0                	test   %eax,%eax
80108bc3:	75 0c                	jne    80108bd1 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108bc5:	c7 04 24 c8 94 10 80 	movl   $0x801094c8,(%esp)
80108bcc:	e8 65 79 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bd4:	8b 00                	mov    (%eax),%eax
80108bd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108be1:	8b 00                	mov    (%eax),%eax
80108be3:	25 ff 0f 00 00       	and    $0xfff,%eax
80108be8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    only_map = is_shared(pa); // New: Add in project final
80108beb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108bee:	89 04 24             	mov    %eax,(%esp)
80108bf1:	e8 d9 01 00 00       	call   80108dcf <is_shared>
80108bf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!only_map) { 
80108bf9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108bfd:	75 6a                	jne    80108c69 <copyuvm+0x10a>
      if((mem = kalloc()) == 0) // el kalloc no pudo asignar la memoria
80108bff:	e8 ba 9e ff ff       	call   80102abe <kalloc>
80108c04:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108c07:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80108c0b:	0f 84 9c 00 00 00    	je     80108cad <copyuvm+0x14e>
        goto bad;
      memmove(mem, (char*)p2v(pa), PGSIZE);
80108c11:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c14:	89 04 24             	mov    %eax,(%esp)
80108c17:	e8 59 f3 ff ff       	call   80107f75 <p2v>
80108c1c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c23:	00 
80108c24:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c2b:	89 04 24             	mov    %eax,(%esp)
80108c2e:	e8 7e cc ff ff       	call   801058b1 <memmove>
      if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c33:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c36:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c39:	89 04 24             	mov    %eax,(%esp)
80108c3c:	e8 27 f3 ff ff       	call   80107f68 <v2p>
80108c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108c44:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108c48:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c4c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c53:	00 
80108c54:	89 54 24 04          	mov    %edx,0x4(%esp)
80108c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c5b:	89 04 24             	mov    %eax,(%esp)
80108c5e:	e8 12 f8 ff ff       	call   80108475 <mappages>
80108c63:	85 c0                	test   %eax,%eax
80108c65:	79 2e                	jns    80108c95 <copyuvm+0x136>
        goto bad;
80108c67:	eb 48                	jmp    80108cb1 <copyuvm+0x152>
    } else {
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80108c69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c6f:	89 54 24 10          	mov    %edx,0x10(%esp)
80108c73:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108c76:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108c7a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c81:	00 
80108c82:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c89:	89 04 24             	mov    %eax,(%esp)
80108c8c:	e8 e4 f7 ff ff       	call   80108475 <mappages>
80108c91:	85 c0                	test   %eax,%eax
80108c93:	78 1b                	js     80108cb0 <copyuvm+0x151>
  for(i = 0; i < sz; i += PGSIZE){
80108c95:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ca2:	0f 82 e2 fe ff ff    	jb     80108b8a <copyuvm+0x2b>
        goto bad;
     }
  }
  return d;
80108ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cab:	eb 14                	jmp    80108cc1 <copyuvm+0x162>
        goto bad;
80108cad:	90                   	nop
80108cae:	eb 01                	jmp    80108cb1 <copyuvm+0x152>
        goto bad;
80108cb0:	90                   	nop

bad:
  freevm(d);
80108cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cb4:	89 04 24             	mov    %eax,(%esp)
80108cb7:	e8 c4 fd ff ff       	call   80108a80 <freevm>
  return 0;
80108cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108cc1:	83 c4 44             	add    $0x44,%esp
80108cc4:	5b                   	pop    %ebx
80108cc5:	5d                   	pop    %ebp
80108cc6:	c3                   	ret    

80108cc7 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108cc7:	55                   	push   %ebp
80108cc8:	89 e5                	mov    %esp,%ebp
80108cca:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108ccd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108cd4:	00 
80108cd5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cdc:	8b 45 08             	mov    0x8(%ebp),%eax
80108cdf:	89 04 24             	mov    %eax,(%esp)
80108ce2:	e8 ec f6 ff ff       	call   801083d3 <walkpgdir>
80108ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ced:	8b 00                	mov    (%eax),%eax
80108cef:	83 e0 01             	and    $0x1,%eax
80108cf2:	85 c0                	test   %eax,%eax
80108cf4:	75 07                	jne    80108cfd <uva2ka+0x36>
    return 0;
80108cf6:	b8 00 00 00 00       	mov    $0x0,%eax
80108cfb:	eb 25                	jmp    80108d22 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d00:	8b 00                	mov    (%eax),%eax
80108d02:	83 e0 04             	and    $0x4,%eax
80108d05:	85 c0                	test   %eax,%eax
80108d07:	75 07                	jne    80108d10 <uva2ka+0x49>
    return 0;
80108d09:	b8 00 00 00 00       	mov    $0x0,%eax
80108d0e:	eb 12                	jmp    80108d22 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d13:	8b 00                	mov    (%eax),%eax
80108d15:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d1a:	89 04 24             	mov    %eax,(%esp)
80108d1d:	e8 53 f2 ff ff       	call   80107f75 <p2v>
}
80108d22:	c9                   	leave  
80108d23:	c3                   	ret    

80108d24 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d24:	55                   	push   %ebp
80108d25:	89 e5                	mov    %esp,%ebp
80108d27:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d2a:	8b 45 10             	mov    0x10(%ebp),%eax
80108d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d30:	e9 89 00 00 00       	jmp    80108dbe <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108d35:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d43:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d47:	8b 45 08             	mov    0x8(%ebp),%eax
80108d4a:	89 04 24             	mov    %eax,(%esp)
80108d4d:	e8 75 ff ff ff       	call   80108cc7 <uva2ka>
80108d52:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d55:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108d59:	75 07                	jne    80108d62 <copyout+0x3e>
      return -1;
80108d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108d60:	eb 6b                	jmp    80108dcd <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108d62:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d65:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108d68:	89 d1                	mov    %edx,%ecx
80108d6a:	29 c1                	sub    %eax,%ecx
80108d6c:	89 c8                	mov    %ecx,%eax
80108d6e:	05 00 10 00 00       	add    $0x1000,%eax
80108d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d79:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d7c:	76 06                	jbe    80108d84 <copyout+0x60>
      n = len;
80108d7e:	8b 45 14             	mov    0x14(%ebp),%eax
80108d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d87:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d8a:	29 c2                	sub    %eax,%edx
80108d8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d8f:	01 c2                	add    %eax,%edx
80108d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d94:	89 44 24 08          	mov    %eax,0x8(%esp)
80108d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d9f:	89 14 24             	mov    %edx,(%esp)
80108da2:	e8 0a cb ff ff       	call   801058b1 <memmove>
    len -= n;
80108da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108daa:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108db0:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108db6:	05 00 10 00 00       	add    $0x1000,%eax
80108dbb:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108dbe:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108dc2:	0f 85 6d ff ff ff    	jne    80108d35 <copyout+0x11>
  }
  return 0;
80108dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108dcd:	c9                   	leave  
80108dce:	c3                   	ret    

80108dcf <is_shared>:
// struct sharedmemory* get_shm_table(){
//   return shmtable.sharedmemory; // obtengo array sharedmemory de tipo sharedmemory
// }

int
is_shared(uint pa){
80108dcf:	55                   	push   %ebp
80108dd0:	89 e5                	mov    %esp,%ebp
80108dd2:	83 ec 28             	sub    $0x28,%esp
  int j;
  struct sharedmemory* shared_array = get_shm_table(); 
80108dd5:	e8 53 c6 ff ff       	call   8010542d <get_shm_table>
80108dda:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int shared = 0;
80108ddd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108de4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108deb:	eb 42                	jmp    80108e2f <is_shared+0x60>
    if (p2v(pa) == shared_array[j].addr && shared_array[j].refcount > 0){ // refcount tiene a 2 entonces 
80108ded:	8b 45 08             	mov    0x8(%ebp),%eax
80108df0:	89 04 24             	mov    %eax,(%esp)
80108df3:	e8 7d f1 ff ff       	call   80107f75 <p2v>
80108df8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108dfb:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80108e02:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108e05:	01 ca                	add    %ecx,%edx
80108e07:	8b 12                	mov    (%edx),%edx
80108e09:	39 d0                	cmp    %edx,%eax
80108e0b:	75 1f                	jne    80108e2c <is_shared+0x5d>
80108e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e10:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e1a:	01 d0                	add    %edx,%eax
80108e1c:	8b 40 04             	mov    0x4(%eax),%eax
80108e1f:	85 c0                	test   %eax,%eax
80108e21:	7e 09                	jle    80108e2c <is_shared+0x5d>
      shared = j+1;
80108e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e26:	40                   	inc    %eax
80108e27:	89 45 f0             	mov    %eax,-0x10(%ebp)
      break;
80108e2a:	eb 09                	jmp    80108e35 <is_shared+0x66>
  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108e2c:	ff 45 f4             	incl   -0xc(%ebp)
80108e2f:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80108e33:	7e b8                	jle    80108ded <is_shared+0x1e>
    }
  }
  return shared; // ahi uno solo
80108e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108e38:	c9                   	leave  
80108e39:	c3                   	ret    
