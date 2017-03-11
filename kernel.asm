
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
8010003a:	c7 44 24 04 84 8e 10 	movl   $0x80108e84,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
80100049:	e8 6d 55 00 00       	call   801055bb <initlock>

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
801000bd:	e8 1a 55 00 00       	call   801055dc <acquire>

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
80100104:	e8 35 55 00 00       	call   8010563e <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 a0 d6 10 	movl   $0x8010d6a0,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 ca 49 00 00       	call   80104aee <sleep>
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
8010017c:	e8 bd 54 00 00       	call   8010563e <release>
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
80100198:	c7 04 24 8b 8e 10 80 	movl   $0x80108e8b,(%esp)
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
801001ef:	c7 04 24 9c 8e 10 80 	movl   $0x80108e9c,(%esp)
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
80100229:	c7 04 24 a3 8e 10 80 	movl   $0x80108ea3,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
8010023c:	e8 9b 53 00 00       	call   801055dc <acquire>

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
8010029d:	e8 54 49 00 00       	call   80104bf6 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 a0 d6 10 80 	movl   $0x8010d6a0,(%esp)
801002a9:	e8 90 53 00 00       	call   8010563e <release>
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
801003bc:	e8 1b 52 00 00       	call   801055dc <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 aa 8e 10 80 	movl   $0x80108eaa,(%esp)
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
801004ad:	c7 45 ec b3 8e 10 80 	movl   $0x80108eb3,-0x14(%ebp)
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
8010052f:	e8 0a 51 00 00       	call   8010563e <release>
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
8010055a:	c7 04 24 ba 8e 10 80 	movl   $0x80108eba,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 c9 8e 10 80 	movl   $0x80108ec9,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 fe 50 00 00       	call   8010568d <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 cb 8e 10 80 	movl   $0x80108ecb,(%esp)
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
80100695:	e8 60 52 00 00       	call   801058fa <memmove>
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
801006c4:	e8 65 51 00 00       	call   8010582e <memset>
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
80100759:	e8 d0 6c 00 00       	call   8010742e <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 c4 6c 00 00       	call   8010742e <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 b8 6c 00 00       	call   8010742e <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 ab 6c 00 00       	call   8010742e <uartputc>
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
8010079d:	e8 3a 4e 00 00       	call   801055dc <acquire>
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
801007ca:	e8 d6 44 00 00       	call   80104ca5 <procdump>
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
801008ce:	e8 23 43 00 00       	call   80104bf6 <wakeup>
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
801008f5:	e8 44 4d 00 00       	call   8010563e <release>
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
8010091a:	e8 bd 4c 00 00       	call   801055dc <acquire>
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
80100938:	e8 01 4d 00 00       	call   8010563e <release>
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
80100961:	e8 88 41 00 00       	call   80104aee <sleep>
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
801009d8:	e8 61 4c 00 00       	call   8010563e <release>
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
80100a0e:	e8 c9 4b 00 00       	call   801055dc <acquire>
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
80100a48:	e8 f1 4b 00 00       	call   8010563e <release>
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
80100a63:	c7 44 24 04 cf 8e 10 	movl   $0x80108ecf,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
80100a72:	e8 44 4b 00 00       	call   801055bb <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 d7 8e 10 	movl   $0x80108ed7,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 e0 ed 10 80 	movl   $0x8010ede0,(%esp)
80100a86:	e8 30 4b 00 00       	call   801055bb <initlock>

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
80100b43:	e8 0a 7a 00 00       	call   80108552 <setupkvm>
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
80100bdc:	e8 37 7d 00 00       	call   80108918 <allocuvm>
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
80100c19:	e8 0b 7c 00 00       	call   80108829 <loaduvm>
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
80100c82:	e8 91 7c 00 00       	call   80108918 <allocuvm>
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
80100ca6:	e8 b7 7e 00 00       	call   80108b62 <clearpteu>
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
80100cdb:	e8 a9 4d 00 00       	call   80105a89 <strlen>
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
80100d03:	e8 81 4d 00 00       	call   80105a89 <strlen>
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
80100d31:	e8 37 80 00 00       	call   80108d6d <copyout>
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
80100dd4:	e8 94 7f 00 00       	call   80108d6d <copyout>
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
80100e26:	e8 15 4c 00 00       	call   80105a40 <safestrcpy>

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
80100e78:	e8 c6 77 00 00       	call   80108643 <switchuvm>
  freevm(oldpgdir);
80100e7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e80:	89 04 24             	mov    %eax,(%esp)
80100e83:	e8 41 7c 00 00       	call   80108ac9 <freevm>
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
80100eba:	e8 0a 7c 00 00       	call   80108ac9 <freevm>
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
80100edd:	c7 44 24 04 dd 8e 10 	movl   $0x80108edd,0x4(%esp)
80100ee4:	80 
80100ee5:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100eec:	e8 ca 46 00 00       	call   801055bb <initlock>
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
80100f00:	e8 d7 46 00 00       	call   801055dc <acquire>
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
80100f29:	e8 10 47 00 00       	call   8010563e <release>
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
80100f47:	e8 f2 46 00 00       	call   8010563e <release>
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
80100f60:	e8 77 46 00 00       	call   801055dc <acquire>
  if(f->ref < 1)
80100f65:	8b 45 08             	mov    0x8(%ebp),%eax
80100f68:	8b 40 04             	mov    0x4(%eax),%eax
80100f6b:	85 c0                	test   %eax,%eax
80100f6d:	7f 0c                	jg     80100f7b <filedup+0x28>
    panic("filedup");
80100f6f:	c7 04 24 e4 8e 10 80 	movl   $0x80108ee4,(%esp)
80100f76:	e8 bb f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	8d 50 01             	lea    0x1(%eax),%edx
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100f8a:	c7 04 24 a0 ee 10 80 	movl   $0x8010eea0,(%esp)
80100f91:	e8 a8 46 00 00       	call   8010563e <release>
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
80100fab:	e8 2c 46 00 00       	call   801055dc <acquire>
  if(f->ref < 1)
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	7f 0c                	jg     80100fc6 <fileclose+0x2b>
    panic("fileclose");
80100fba:	c7 04 24 ec 8e 10 80 	movl   $0x80108eec,(%esp)
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
80100fe6:	e8 53 46 00 00       	call   8010563e <release>
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
8010101c:	e8 1d 46 00 00       	call   8010563e <release>
  
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
80101161:	c7 04 24 f6 8e 10 80 	movl   $0x80108ef6,(%esp)
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
8010126c:	c7 04 24 ff 8e 10 80 	movl   $0x80108eff,(%esp)
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
801012a1:	c7 04 24 0f 8f 10 80 	movl   $0x80108f0f,(%esp)
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
801012e7:	e8 0e 46 00 00       	call   801058fa <memmove>
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
8010132d:	e8 fc 44 00 00       	call   8010582e <memset>
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
80101495:	c7 04 24 19 8f 10 80 	movl   $0x80108f19,(%esp)
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
80101538:	c7 04 24 2f 8f 10 80 	movl   $0x80108f2f,(%esp)
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
8010158d:	c7 44 24 04 42 8f 10 	movl   $0x80108f42,0x4(%esp)
80101594:	80 
80101595:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010159c:	e8 1a 40 00 00       	call   801055bb <initlock>
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
80101626:	e8 03 42 00 00       	call   8010582e <memset>
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
8010167d:	c7 04 24 49 8f 10 80 	movl   $0x80108f49,(%esp)
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
80101724:	e8 d1 41 00 00       	call   801058fa <memmove>
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
8010174e:	e8 89 3e 00 00       	call   801055dc <acquire>

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
80101798:	e8 a1 3e 00 00       	call   8010563e <release>
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
801017cb:	c7 04 24 5b 8f 10 80 	movl   $0x80108f5b,(%esp)
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
80101809:	e8 30 3e 00 00       	call   8010563e <release>

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
80101820:	e8 b7 3d 00 00       	call   801055dc <acquire>
  ip->ref++;
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 08             	mov    0x8(%eax),%eax
8010182b:	8d 50 01             	lea    0x1(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101834:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010183b:	e8 fe 3d 00 00       	call   8010563e <release>
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
8010185b:	c7 04 24 6b 8f 10 80 	movl   $0x80108f6b,(%esp)
80101862:	e8 cf ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101867:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010186e:	e8 69 3d 00 00       	call   801055dc <acquire>
  while(ip->flags & I_BUSY)
80101873:	eb 13                	jmp    80101888 <ilock+0x43>
    sleep(ip, &icache.lock);
80101875:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
8010187c:	80 
8010187d:	8b 45 08             	mov    0x8(%ebp),%eax
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 66 32 00 00       	call   80104aee <sleep>
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
801018ad:	e8 8c 3d 00 00       	call   8010563e <release>

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
80101956:	e8 9f 3f 00 00       	call   801058fa <memmove>
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
80101982:	c7 04 24 71 8f 10 80 	movl   $0x80108f71,(%esp)
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
801019b3:	c7 04 24 80 8f 10 80 	movl   $0x80108f80,(%esp)
801019ba:	e8 77 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019bf:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019c6:	e8 11 3c 00 00       	call   801055dc <acquire>
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
801019e2:	e8 0f 32 00 00       	call   80104bf6 <wakeup>
  release(&icache.lock);
801019e7:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801019ee:	e8 4b 3c 00 00       	call   8010563e <release>
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
80101a02:	e8 d5 3b 00 00       	call   801055dc <acquire>
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
80101a40:	c7 04 24 88 8f 10 80 	movl   $0x80108f88,(%esp)
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
80101a64:	e8 d5 3b 00 00       	call   8010563e <release>
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
80101a8f:	e8 48 3b 00 00       	call   801055dc <acquire>
    ip->flags = 0;
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 04 24             	mov    %eax,(%esp)
80101aa4:	e8 4d 31 00 00       	call   80104bf6 <wakeup>
  }
  ip->ref--;
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 40 08             	mov    0x8(%eax),%eax
80101aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ab8:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80101abf:	e8 7a 3b 00 00       	call   8010563e <release>
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
80101bdf:	c7 04 24 92 8f 10 80 	movl   $0x80108f92,(%esp)
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
80101e7e:	e8 77 3a 00 00       	call   801058fa <memmove>
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
80101fde:	e8 17 39 00 00       	call   801058fa <memmove>
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
8010205c:	e8 35 39 00 00       	call   80105996 <strncmp>
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
80102075:	c7 04 24 a5 8f 10 80 	movl   $0x80108fa5,(%esp)
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
801020b3:	c7 04 24 b7 8f 10 80 	movl   $0x80108fb7,(%esp)
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
80102195:	c7 04 24 b7 8f 10 80 	movl   $0x80108fb7,(%esp)
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
801021da:	e8 07 38 00 00       	call   801059e6 <strncpy>
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
8010220c:	c7 04 24 c4 8f 10 80 	movl   $0x80108fc4,(%esp)
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
8010228d:	e8 68 36 00 00       	call   801058fa <memmove>
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
801022a8:	e8 4d 36 00 00       	call   801058fa <memmove>
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
801024fb:	c7 44 24 04 cc 8f 10 	movl   $0x80108fcc,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
8010250a:	e8 ac 30 00 00       	call   801055bb <initlock>
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
801025a4:	c7 04 24 d0 8f 10 80 	movl   $0x80108fd0,(%esp)
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
801026ca:	e8 0d 2f 00 00       	call   801055dc <acquire>
  if((b = idequeue) == 0){
801026cf:	a1 74 c6 10 80       	mov    0x8010c674,%eax
801026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026db:	75 11                	jne    801026ee <ideintr+0x31>
    release(&idelock);
801026dd:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801026e4:	e8 55 2f 00 00       	call   8010563e <release>
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
80102757:	e8 9a 24 00 00       	call   80104bf6 <wakeup>
  
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
80102779:	e8 c0 2e 00 00       	call   8010563e <release>
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
80102792:	c7 04 24 d9 8f 10 80 	movl   $0x80108fd9,(%esp)
80102799:	e8 98 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	8b 00                	mov    (%eax),%eax
801027a3:	83 e0 06             	and    $0x6,%eax
801027a6:	83 f8 02             	cmp    $0x2,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x37>
    panic("iderw: nothing to do");
801027ab:	c7 04 24 ed 8f 10 80 	movl   $0x80108fed,(%esp)
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
801027ca:	c7 04 24 02 90 10 80 	movl   $0x80109002,(%esp)
801027d1:	e8 60 dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027d6:	c7 04 24 40 c6 10 80 	movl   $0x8010c640,(%esp)
801027dd:	e8 fa 2d 00 00       	call   801055dc <acquire>

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
80102836:	e8 b3 22 00 00       	call   80104aee <sleep>
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
80102852:	e8 e7 2d 00 00       	call   8010563e <release>
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
801028dd:	c7 04 24 20 90 10 80 	movl   $0x80109020,(%esp)
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
80102996:	c7 44 24 04 52 90 10 	movl   $0x80109052,0x4(%esp)
8010299d:	80 
8010299e:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
801029a5:	e8 11 2c 00 00       	call   801055bb <initlock>
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
80102a37:	81 7d 08 bc 45 11 80 	cmpl   $0x801145bc,0x8(%ebp)
80102a3e:	72 12                	jb     80102a52 <kfree+0x2d>
80102a40:	8b 45 08             	mov    0x8(%ebp),%eax
80102a43:	89 04 24             	mov    %eax,(%esp)
80102a46:	e8 38 ff ff ff       	call   80102983 <v2p>
80102a4b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a50:	76 0c                	jbe    80102a5e <kfree+0x39>
    panic("kfree");
80102a52:	c7 04 24 57 90 10 80 	movl   $0x80109057,(%esp)
80102a59:	e8 d8 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a65:	00 
80102a66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a6d:	00 
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 b5 2d 00 00       	call   8010582e <memset>

  if(kmem.use_lock)
80102a79:	a1 b4 08 11 80       	mov    0x801108b4,%eax
80102a7e:	85 c0                	test   %eax,%eax
80102a80:	74 0c                	je     80102a8e <kfree+0x69>
    acquire(&kmem.lock);
80102a82:	c7 04 24 80 08 11 80 	movl   $0x80110880,(%esp)
80102a89:	e8 4e 2b 00 00       	call   801055dc <acquire>
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
80102ab7:	e8 82 2b 00 00       	call   8010563e <release>
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
80102ad4:	e8 03 2b 00 00       	call   801055dc <acquire>
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
80102b01:	e8 38 2b 00 00       	call   8010563e <release>
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
80102e74:	c7 04 24 60 90 10 80 	movl   $0x80109060,(%esp)
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
80102fcb:	c7 44 24 04 8c 90 10 	movl   $0x8010908c,0x4(%esp)
80102fd2:	80 
80102fd3:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
80102fda:	e8 dc 25 00 00       	call   801055bb <initlock>
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
8010308e:	e8 67 28 00 00       	call   801058fa <memmove>
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
801031dd:	e8 fa 23 00 00       	call   801055dc <acquire>
  while (log.busy) {
801031e2:	eb 14                	jmp    801031f8 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e4:	c7 44 24 04 c0 08 11 	movl   $0x801108c0,0x4(%esp)
801031eb:	80 
801031ec:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
801031f3:	e8 f6 18 00 00       	call   80104aee <sleep>
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
80103212:	e8 27 24 00 00       	call   8010563e <release>
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
80103248:	e8 8f 23 00 00       	call   801055dc <acquire>
  log.busy = 0;
8010324d:	c7 05 fc 08 11 80 00 	movl   $0x0,0x801108fc
80103254:	00 00 00 
  wakeup(&log);
80103257:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010325e:	e8 93 19 00 00       	call   80104bf6 <wakeup>
  release(&log.lock);
80103263:	c7 04 24 c0 08 11 80 	movl   $0x801108c0,(%esp)
8010326a:	e8 cf 23 00 00       	call   8010563e <release>
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
80103291:	c7 04 24 90 90 10 80 	movl   $0x80109090,(%esp)
80103298:	e8 99 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010329d:	a1 fc 08 11 80       	mov    0x801108fc,%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	75 0c                	jne    801032b2 <log_write+0x41>
    panic("write outside of trans");
801032a6:	c7 04 24 a6 90 10 80 	movl   $0x801090a6,(%esp)
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
80103335:	e8 c0 25 00 00       	call   801058fa <memmove>
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
801033c6:	c7 04 24 bc 45 11 80 	movl   $0x801145bc,(%esp)
801033cd:	e8 be f5 ff ff       	call   80102990 <kinit1>
  kvmalloc();      // kernel page table
801033d2:	e8 38 52 00 00       	call   8010860f <kvmalloc>
  mpinit();        // collect info about this machine
801033d7:	e8 93 04 00 00       	call   8010386f <mpinit>
  lapicinit();
801033dc:	e8 07 f9 ff ff       	call   80102ce8 <lapicinit>
  seginit();       // set up segments
801033e1:	e8 e5 4b 00 00       	call   80107fcb <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033ec:	8a 00                	mov    (%eax),%al
801033ee:	0f b6 c0             	movzbl %al,%eax
801033f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f5:	c7 04 24 bd 90 10 80 	movl   $0x801090bd,(%esp)
801033fc:	e8 a0 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103401:	e8 cf 06 00 00       	call   80103ad5 <picinit>
  ioapicinit();    // another interrupt controller
80103406:	e8 7f f4 ff ff       	call   8010288a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010340b:	e8 4d d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103410:	e8 0b 3f 00 00       	call   80107320 <uartinit>
  pinit();         // process table
80103415:	e8 c9 0b 00 00       	call   80103fe3 <pinit>
  tvinit();        // trap vectors
8010341a:	e8 b4 3a 00 00       	call   80106ed3 <tvinit>
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
8010343c:	e8 da 39 00 00       	call   80106e1b <timerinit>
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
8010346a:	e8 b7 51 00 00       	call   80108626 <switchkvm>
  seginit();
8010346f:	e8 57 4b 00 00       	call   80107fcb <seginit>
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
80103493:	c7 04 24 d4 90 10 80 	movl   $0x801090d4,(%esp)
8010349a:	e8 02 cf ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
8010349f:	e8 8c 3b 00 00       	call   80107030 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034aa:	05 a8 00 00 00       	add    $0xa8,%eax
801034af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034b6:	00 
801034b7:	89 04 24             	mov    %eax,(%esp)
801034ba:	e8 d1 fe ff ff       	call   80103390 <xchg>
  scheduler();     // start running processes
801034bf:	e8 30 14 00 00       	call   801048f4 <scheduler>

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
801034f1:	e8 04 24 00 00       	call   801058fa <memmove>

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
801036c9:	c7 44 24 04 e8 90 10 	movl   $0x801090e8,0x4(%esp)
801036d0:	80 
801036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d4:	89 04 24             	mov    %eax,(%esp)
801036d7:	e8 c9 21 00 00       	call   801058a5 <memcmp>
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
80103806:	c7 44 24 04 ed 90 10 	movl   $0x801090ed,0x4(%esp)
8010380d:	80 
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	89 04 24             	mov    %eax,(%esp)
80103814:	e8 8c 20 00 00       	call   801058a5 <memcmp>
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
801038dc:	8b 04 85 30 91 10 80 	mov    -0x7fef6ed0(,%eax,4),%eax
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
80103913:	c7 04 24 f2 90 10 80 	movl   $0x801090f2,(%esp)
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
801039b3:	c7 04 24 10 91 10 80 	movl   $0x80109110,(%esp)
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
80103ca9:	c7 44 24 04 44 91 10 	movl   $0x80109144,0x4(%esp)
80103cb0:	80 
80103cb1:	89 04 24             	mov    %eax,(%esp)
80103cb4:	e8 02 19 00 00       	call   801055bb <initlock>
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
80103d61:	e8 76 18 00 00       	call   801055dc <acquire>
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
80103d84:	e8 6d 0e 00 00       	call   80104bf6 <wakeup>
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
80103da3:	e8 4e 0e 00 00       	call   80104bf6 <wakeup>
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
80103dc8:	e8 71 18 00 00       	call   8010563e <release>
    kfree((char*)p);
80103dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd0:	89 04 24             	mov    %eax,(%esp)
80103dd3:	e8 4d ec ff ff       	call   80102a25 <kfree>
80103dd8:	eb 0b                	jmp    80103de5 <pipeclose+0x90>
  } else
    release(&p->lock);
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	89 04 24             	mov    %eax,(%esp)
80103de0:	e8 59 18 00 00       	call   8010563e <release>
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
80103df4:	e8 e3 17 00 00       	call   801055dc <acquire>
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
80103e25:	e8 14 18 00 00       	call   8010563e <release>
        return -1;
80103e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2f:	e9 9d 00 00 00       	jmp    80103ed1 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e34:	8b 45 08             	mov    0x8(%ebp),%eax
80103e37:	05 34 02 00 00       	add    $0x234,%eax
80103e3c:	89 04 24             	mov    %eax,(%esp)
80103e3f:	e8 b2 0d 00 00       	call   80104bf6 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e44:	8b 45 08             	mov    0x8(%ebp),%eax
80103e47:	8b 55 08             	mov    0x8(%ebp),%edx
80103e4a:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e54:	89 14 24             	mov    %edx,(%esp)
80103e57:	e8 92 0c 00 00       	call   80104aee <sleep>
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
80103ebe:	e8 33 0d 00 00       	call   80104bf6 <wakeup>
  release(&p->lock);
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec6:	89 04 24             	mov    %eax,(%esp)
80103ec9:	e8 70 17 00 00       	call   8010563e <release>
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
80103ee4:	e8 f3 16 00 00       	call   801055dc <acquire>
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
80103efe:	e8 3b 17 00 00       	call   8010563e <release>
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
80103f20:	e8 c9 0b 00 00       	call   80104aee <sleep>
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
80103faf:	e8 42 0c 00 00       	call   80104bf6 <wakeup>
  release(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 04 24             	mov    %eax,(%esp)
80103fba:	e8 7f 16 00 00       	call   8010563e <release>
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
80103fe9:	c7 44 24 04 49 91 10 	movl   $0x80109149,0x4(%esp)
80103ff0:	80 
80103ff1:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80103ff8:	e8 be 15 00 00       	call   801055bb <initlock>
  shm_init(); // New: Add in project final: inicializo shmtable.sharedmemory[i].refcount = -1
80103ffd:	e8 2c 11 00 00       	call   8010512e <shm_init>
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
80104036:	05 86 05 00 00       	add    $0x586,%eax
8010403b:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104042:	85 c0                	test   %eax,%eax
80104044:	75 41                	jne    80104087 <enqueue+0x83>
      ptable.mlf[p->priority].first=p; //set first
80104046:	8b 45 08             	mov    0x8(%ebp),%eax
80104049:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010404f:	8d 90 86 05 00 00    	lea    0x586(%eax),%edx
80104055:	8b 45 08             	mov    0x8(%ebp),%eax
80104058:	89 04 d5 04 10 11 80 	mov    %eax,-0x7feeeffc(,%edx,8)
      ptable.mlf[p->priority].last=p; //set last
8010405f:	8b 45 08             	mov    0x8(%ebp),%eax
80104062:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104068:	8d 90 86 05 00 00    	lea    0x586(%eax),%edx
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
80104090:	05 86 05 00 00       	add    $0x586,%eax
80104095:	8b 04 c5 08 10 11 80 	mov    -0x7feeeff8(,%eax,8),%eax
8010409c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      prev->next=p; //set new proc as next of previous last
8010409f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a2:	8b 55 08             	mov    0x8(%ebp),%edx
801040a5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
      ptable.mlf[p->priority].last=p; //refresh last
801040ab:	8b 45 08             	mov    0x8(%ebp),%eax
801040ae:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801040b4:	8d 90 86 05 00 00    	lea    0x586(%eax),%edx
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
801040d3:	c7 04 24 50 91 10 80 	movl   $0x80109150,(%esp)
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
801040ea:	05 86 05 00 00       	add    $0x586,%eax
801040ef:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
801040f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  // when a proc is dequeued, refresh first element of the priority level
  ptable.mlf[priority].first=ptable.mlf[priority].first->next;
801040f9:	8b 45 08             	mov    0x8(%ebp),%eax
801040fc:	05 86 05 00 00       	add    $0x586,%eax
80104101:	8b 04 c5 04 10 11 80 	mov    -0x7feeeffc(,%eax,8),%eax
80104108:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
8010410e:	8b 55 08             	mov    0x8(%ebp),%edx
80104111:	81 c2 86 05 00 00    	add    $0x586,%edx
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
80104136:	05 86 05 00 00       	add    $0x586,%eax
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
801041e2:	e8 f5 13 00 00       	call   801055dc <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e7:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
801041ee:	eb 11                	jmp    80104201 <allocproc+0x2c>
    if(p->state == UNUSED)
801041f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f3:	8b 40 0c             	mov    0xc(%eax),%eax
801041f6:	85 c0                	test   %eax,%eax
801041f8:	74 26                	je     80104220 <allocproc+0x4b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fa:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80104201:	81 7d f4 34 3c 11 80 	cmpl   $0x80113c34,-0xc(%ebp)
80104208:	72 e6                	jb     801041f0 <allocproc+0x1b>
      goto found;
  release(&ptable.lock);
8010420a:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104211:	e8 28 14 00 00       	call   8010563e <release>
  return 0;
80104216:	b8 00 00 00 00       	mov    $0x0,%eax
8010421b:	e9 c0 00 00 00       	jmp    801042e0 <allocproc+0x10b>
      goto found;
80104220:	90                   	nop

found:
  p->state = EMBRYO;
80104221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104224:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++; // le asigna 1 y luego aumenta la variable "nextpid"
8010422b:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104230:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104233:	89 42 10             	mov    %eax,0x10(%edx)
80104236:	40                   	inc    %eax
80104237:	a3 04 c0 10 80       	mov    %eax,0x8010c004
  release(&ptable.lock);
8010423c:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104243:	e8 f6 13 00 00       	call   8010563e <release>

  p->priority=0; // New: Added in proyect 2: set priority in zero 
80104248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104252:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){ // si me retorna cero, pues no pudo ser alojada
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
8010429a:	ba 8b 6e 10 80       	mov    $0x80106e8b,%edx
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
801042ca:	e8 5f 15 00 00       	call   8010582e <memset>
  p->context->eip = (uint)forkret;
801042cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042d2:	8b 40 1c             	mov    0x1c(%eax),%eax
801042d5:	ba c2 4a 10 80       	mov    $0x80104ac2,%edx
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
  extern char _binary_initcode_start[], _binary_initcode_size[]; // codigo de inicio y su longitud
  
  p = allocproc(); // en p, me queda un proceso en estado EMBRYO
801042e8:	e8 e8 fe ff ff       	call   801041d5 <allocproc>
801042ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f3:	a3 88 c6 10 80       	mov    %eax,0x8010c688
  if((p->pgdir = setupkvm()) == 0)
801042f8:	e8 55 42 00 00       	call   80108552 <setupkvm>
801042fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104300:	89 42 04             	mov    %eax,0x4(%edx)
80104303:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104306:	8b 40 04             	mov    0x4(%eax),%eax
80104309:	85 c0                	test   %eax,%eax
8010430b:	75 0c                	jne    80104319 <userinit+0x37>
    panic("userinit: out of memory?"); // no ahi memoria
8010430d:	c7 04 24 5f 91 10 80 	movl   $0x8010915f,(%esp)
80104314:	e8 1d c2 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size); //carga el _binary_initcode_start desde la direccion 0 hasta p->pgdir 
80104319:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010431e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104321:	8b 40 04             	mov    0x4(%eax),%eax
80104324:	89 54 24 08          	mov    %edx,0x8(%esp)
80104328:	c7 44 24 04 20 c5 10 	movl   $0x8010c520,0x4(%esp)
8010432f:	80 
80104330:	89 04 24             	mov    %eax,(%esp)
80104333:	e8 66 44 00 00       	call   8010879e <inituvm>
  p->sz = PGSIZE; // actaliza el sz de la tabla, por que ya mapeo el primer espacio
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
8010435a:	e8 cf 14 00 00       	call   8010582e <memset>
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

  safestrcpy(p->name, "initcode", sizeof(p->name)); // guardar el nombre del programa para el debugging.
801043c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c7:	83 c0 6c             	add    $0x6c,%eax
801043ca:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043d1:	00 
801043d2:	c7 44 24 04 78 91 10 	movl   $0x80109178,0x4(%esp)
801043d9:	80 
801043da:	89 04 24             	mov    %eax,(%esp)
801043dd:	e8 5e 16 00 00       	call   80105a40 <safestrcpy>
  p->cwd = namei("/");
801043e2:	c7 04 24 81 91 10 80 	movl   $0x80109181,(%esp)
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
growproc(int n) // incrementa la memoria del proceso corriente "n" bytes.
{
80104409:	55                   	push   %ebp
8010440a:	89 e5                	mov    %esp,%ebp
8010440c:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz; // guardo en sz la memoria actual del proceso
8010440f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104415:	8b 00                	mov    (%eax),%eax
80104417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){ // si el n es positivo y mayor a cero, es por que se quiere agrandar la memoria.
8010441a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010441e:	7e 34                	jle    80104454 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0) // allocuvm, me retorna el numero tamaño de memoria del proceso si todo salio bien
80104420:	8b 55 08             	mov    0x8(%ebp),%edx
80104423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104426:	01 c2                	add    %eax,%edx
80104428:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010442e:	8b 40 04             	mov    0x4(%eax),%eax
80104431:	89 54 24 08          	mov    %edx,0x8(%esp)
80104435:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104438:	89 54 24 04          	mov    %edx,0x4(%esp)
8010443c:	89 04 24             	mov    %eax,(%esp)
8010443f:	e8 d4 44 00 00       	call   80108918 <allocuvm>
80104444:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010444b:	75 41                	jne    8010448e <growproc+0x85>
      return -1; // error                             // el allocuvm va hacer crecer el tamaño de la memoria delproceso
8010444d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104452:	eb 58                	jmp    801044ac <growproc+0xa3>
  } else if(n < 0){ // si el n es nagativo, es por que se quiere achicar la memoria del proceso corriente.
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
80104479:	e8 74 45 00 00       	call   801089f2 <deallocuvm>
8010447e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104485:	75 07                	jne    8010448e <growproc+0x85>
      return -1; // error                      
80104487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010448c:	eb 1e                	jmp    801044ac <growproc+0xa3>
  }
  proc->sz = sz; // recien aqui actualizo el tamaño de la memoria del proceso corriente
8010448e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104494:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104497:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104499:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449f:	89 04 24             	mov    %eax,(%esp)
801044a2:	e8 9c 41 00 00       	call   80108643 <switchuvm>
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
801044e7:	e8 bc 46 00 00       	call   80108ba8 <copyuvm>
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
801045e0:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
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
80104622:	e8 19 14 00 00       	call   80105a40 <safestrcpy>
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
80104649:	c7 04 24 83 91 10 80 	movl   $0x80109183,(%esp)
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
801046d6:	e8 11 07 00 00       	call   80104dec <getstable>
801046db:	89 da                	mov    %ebx,%edx
801046dd:	29 c2                	sub    %eax,%edx
801046df:	89 d0                	mov    %edx,%eax
801046e1:	c1 f8 03             	sar    $0x3,%eax
801046e4:	89 04 24             	mov    %eax,(%esp)
801046e7:	e8 7a 08 00 00       	call   80104f66 <semfree>
  for(sd = 0; sd < MAXSEMPROC; sd++){
801046ec:	ff 45 ec             	incl   -0x14(%ebp)
801046ef:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
801046f3:	7e bb                	jle    801046b0 <exit+0x7e>
    }
  }

  proc->shmemquantity = 0;
801046f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046fb:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104702:	00 00 00 
  proc->semquantity = 0;
80104705:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010470b:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80104712:	00 00 00 

  begin_trans(); //add hoy dario, no estoy seguro // begin_op en linux creo
80104715:	e8 b6 ea ff ff       	call   801031d0 <begin_trans>
  iput(proc->cwd);
8010471a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104720:	8b 40 68             	mov    0x68(%eax),%eax
80104723:	89 04 24             	mov    %eax,(%esp)
80104726:	e8 ca d2 ff ff       	call   801019f5 <iput>
  commit_trans(); //add hoy dario, no estoy seguro
8010472b:	e8 e9 ea ff ff       	call   80103219 <commit_trans>
  proc->cwd = 0;
80104730:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104736:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  // Free shared memory
  for(i = 0; i < MAXSHMPROC; i++){
8010473d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104744:	eb 0e                	jmp    80104754 <exit+0x122>
    if (proc->shmref[i] != 0){}
      shm_close(i);
80104746:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104749:	89 04 24             	mov    %eax,(%esp)
8010474c:	e8 ea 0a 00 00       	call   8010523b <shm_close>
  for(i = 0; i < MAXSHMPROC; i++){
80104751:	ff 45 e8             	incl   -0x18(%ebp)
80104754:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
80104758:	7e ec                	jle    80104746 <exit+0x114>
  }

  acquire(&ptable.lock);
8010475a:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104761:	e8 76 0e 00 00       	call   801055dc <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104766:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010476c:	8b 40 14             	mov    0x14(%eax),%eax
8010476f:	89 04 24             	mov    %eax,(%esp)
80104772:	e8 35 04 00 00       	call   80104bac <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104777:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
8010477e:	eb 3b                	jmp    801047bb <exit+0x189>
    if(p->parent == proc){
80104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104783:	8b 50 14             	mov    0x14(%eax),%edx
80104786:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478c:	39 c2                	cmp    %eax,%edx
8010478e:	75 24                	jne    801047b4 <exit+0x182>
      p->parent = initproc;
80104790:	8b 15 88 c6 10 80    	mov    0x8010c688,%edx
80104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104799:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
8010479c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479f:	8b 40 0c             	mov    0xc(%eax),%eax
801047a2:	83 f8 05             	cmp    $0x5,%eax
801047a5:	75 0d                	jne    801047b4 <exit+0x182>
        wakeup1(initproc);
801047a7:	a1 88 c6 10 80       	mov    0x8010c688,%eax
801047ac:	89 04 24             	mov    %eax,(%esp)
801047af:	e8 f8 03 00 00       	call   80104bac <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b4:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801047bb:	81 7d f4 34 3c 11 80 	cmpl   $0x80113c34,-0xc(%ebp)
801047c2:	72 bc                	jb     80104780 <exit+0x14e>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801047c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ca:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
801047d1:	e8 db 01 00 00       	call   801049b1 <sched>
  panic("zombie exit");
801047d6:	c7 04 24 90 91 10 80 	movl   $0x80109190,(%esp)
801047dd:	e8 54 bd ff ff       	call   80100536 <panic>

801047e2 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
801047e2:	55                   	push   %ebp
801047e3:	89 e5                	mov    %esp,%ebp
801047e5:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801047e8:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801047ef:	e8 e8 0d 00 00       	call   801055dc <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801047f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047fb:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104802:	e9 9d 00 00 00       	jmp    801048a4 <wait+0xc2>
      if(p->parent != proc)
80104807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480a:	8b 50 14             	mov    0x14(%eax),%edx
8010480d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104813:	39 c2                	cmp    %eax,%edx
80104815:	0f 85 81 00 00 00    	jne    8010489c <wait+0xba>
        continue;
      havekids = 1;
8010481b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104825:	8b 40 0c             	mov    0xc(%eax),%eax
80104828:	83 f8 05             	cmp    $0x5,%eax
8010482b:	75 70                	jne    8010489d <wait+0xbb>
        // Found one.
        pid = p->pid;
8010482d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104830:	8b 40 10             	mov    0x10(%eax),%eax
80104833:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104839:	8b 40 08             	mov    0x8(%eax),%eax
8010483c:	89 04 24             	mov    %eax,(%esp)
8010483f:	e8 e1 e1 ff ff       	call   80102a25 <kfree>
        p->kstack = 0;
80104844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104847:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010484e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104851:	8b 40 04             	mov    0x4(%eax),%eax
80104854:	89 04 24             	mov    %eax,(%esp)
80104857:	e8 6d 42 00 00       	call   80108ac9 <freevm>
        p->state = UNUSED;
8010485c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104869:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104873:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010487a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010487d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104884:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
8010488b:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104892:	e8 a7 0d 00 00       	call   8010563e <release>
        return pid;
80104897:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010489a:	eb 56                	jmp    801048f2 <wait+0x110>
        continue;
8010489c:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010489d:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
801048a4:	81 7d f4 34 3c 11 80 	cmpl   $0x80113c34,-0xc(%ebp)
801048ab:	0f 82 56 ff ff ff    	jb     80104807 <wait+0x25>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801048b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801048b5:	74 0d                	je     801048c4 <wait+0xe2>
801048b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048bd:	8b 40 24             	mov    0x24(%eax),%eax
801048c0:	85 c0                	test   %eax,%eax
801048c2:	74 13                	je     801048d7 <wait+0xf5>
      release(&ptable.lock);
801048c4:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801048cb:	e8 6e 0d 00 00       	call   8010563e <release>
      return -1;
801048d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048d5:	eb 1b                	jmp    801048f2 <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801048d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048dd:	c7 44 24 04 00 10 11 	movl   $0x80111000,0x4(%esp)
801048e4:	80 
801048e5:	89 04 24             	mov    %eax,(%esp)
801048e8:	e8 01 02 00 00       	call   80104aee <sleep>
  }
801048ed:	e9 02 ff ff ff       	jmp    801047f4 <wait+0x12>
}
801048f2:	c9                   	leave  
801048f3:	c3                   	ret    

801048f4 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	83 ec 28             	sub    $0x28,%esp
  int i; // New: Added in project 2
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
801048fa:	e8 de f6 ff ff       	call   80103fdd <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801048ff:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104906:	e8 d1 0c 00 00       	call   801055dc <acquire>
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue; // continue, move pointer

    // Set pointer p in zero (null)
    p=0;
8010490b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    // Loop over MLF table looking for process to run.
    for(i=0; i<MLF_LEVELS; i++){
80104912:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104919:	eb 22                	jmp    8010493d <scheduler+0x49>
      if(!isempty(i)){
8010491b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491e:	89 04 24             	mov    %eax,(%esp)
80104921:	e8 0a f8 ff ff       	call   80104130 <isempty>
80104926:	85 c0                	test   %eax,%eax
80104928:	75 10                	jne    8010493a <scheduler+0x46>
        // New - when a proc state changes to RUNNING it must be dequeued
        p=dequeue(i);
8010492a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010492d:	89 04 24             	mov    %eax,(%esp)
80104930:	e8 ac f7 ff ff       	call   801040e1 <dequeue>
80104935:	89 45 f0             	mov    %eax,-0x10(%ebp)
        break;
80104938:	eb 09                	jmp    80104943 <scheduler+0x4f>
    for(i=0; i<MLF_LEVELS; i++){
8010493a:	ff 45 f4             	incl   -0xc(%ebp)
8010493d:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104941:	7e d8                	jle    8010491b <scheduler+0x27>
      }
    }

    // If pointer not null (RUNNABLE proccess found)
    if (p) {
80104943:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104947:	74 57                	je     801049a0 <scheduler+0xac>
      proc = p; //(ahora, el proceso actual en esta cpu).
80104949:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010494c:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      // proc = p; // p->state == RUNNABLE
      
      switchuvm(p); // Switch TSS and h/w page table to correspond to process p.
80104952:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104955:	89 04 24             	mov    %eax,(%esp)
80104958:	e8 e6 3c 00 00       	call   80108643 <switchuvm>
      p->state = RUNNING;
8010495d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104960:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->ticksProc = 0;  // New - when a proccess takes control, set ticksCounter on zero
80104967:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010496a:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
      // cprintf("proccess %s takes control of the CPU...\n",p->name);
      swtch(&cpu->scheduler, proc->context);
80104971:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104977:	8b 40 1c             	mov    0x1c(%eax),%eax
8010497a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104981:	83 c2 04             	add    $0x4,%edx
80104984:	89 44 24 04          	mov    %eax,0x4(%esp)
80104988:	89 14 24             	mov    %edx,(%esp)
8010498b:	e8 1e 11 00 00       	call   80105aae <swtch>
      switchkvm(); // Switch h/w page table register to the kernel-only page table,
80104990:	e8 91 3c 00 00       	call   80108626 <switchkvm>
                  // for when no process is running.

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104995:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010499c:	00 00 00 00 
    }
    release(&ptable.lock);
801049a0:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801049a7:	e8 92 0c 00 00       	call   8010563e <release>

  }
801049ac:	e9 49 ff ff ff       	jmp    801048fa <scheduler+0x6>

801049b1 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801049b1:	55                   	push   %ebp
801049b2:	89 e5                	mov    %esp,%ebp
801049b4:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801049b7:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
801049be:	e8 41 0d 00 00       	call   80105704 <holding>
801049c3:	85 c0                	test   %eax,%eax
801049c5:	75 0c                	jne    801049d3 <sched+0x22>
    panic("sched ptable.lock");
801049c7:	c7 04 24 9c 91 10 80 	movl   $0x8010919c,(%esp)
801049ce:	e8 63 bb ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
801049d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801049d9:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801049df:	83 f8 01             	cmp    $0x1,%eax
801049e2:	74 0c                	je     801049f0 <sched+0x3f>
    panic("sched locks");
801049e4:	c7 04 24 ae 91 10 80 	movl   $0x801091ae,(%esp)
801049eb:	e8 46 bb ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
801049f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f6:	8b 40 0c             	mov    0xc(%eax),%eax
801049f9:	83 f8 04             	cmp    $0x4,%eax
801049fc:	75 0c                	jne    80104a0a <sched+0x59>
    panic("sched running");
801049fe:	c7 04 24 ba 91 10 80 	movl   $0x801091ba,(%esp)
80104a05:	e8 2c bb ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80104a0a:	e8 b9 f5 ff ff       	call   80103fc8 <readeflags>
80104a0f:	25 00 02 00 00       	and    $0x200,%eax
80104a14:	85 c0                	test   %eax,%eax
80104a16:	74 0c                	je     80104a24 <sched+0x73>
    panic("sched interruptible");
80104a18:	c7 04 24 c8 91 10 80 	movl   $0x801091c8,(%esp)
80104a1f:	e8 12 bb ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104a24:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a2a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104a33:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a39:	8b 40 04             	mov    0x4(%eax),%eax
80104a3c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a43:	83 c2 1c             	add    $0x1c,%edx
80104a46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a4a:	89 14 24             	mov    %edx,(%esp)
80104a4d:	e8 5c 10 00 00       	call   80105aae <swtch>
  cpu->intena = intena;
80104a52:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104a58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a5b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104a61:	c9                   	leave  
80104a62:	c3                   	ret    

80104a63 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104a63:	55                   	push   %ebp
80104a64:	89 e5                	mov    %esp,%ebp
80104a66:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a69:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104a70:	e8 67 0b 00 00       	call   801055dc <acquire>
  // proc->state = RUNNABLE;
  // sched();
  if(proc->priority<3){ 
80104a75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a81:	83 f8 02             	cmp    $0x2,%eax
80104a84:	7f 13                	jg     80104a99 <yield+0x36>
    proc->priority++;
80104a86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8c:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104a92:	42                   	inc    %edx
80104a93:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  makerunnable(proc,1); // New: Added in proyect 2: enqueue proc
80104a99:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104aa6:	00 
80104aa7:	89 04 24             	mov    %eax,(%esp)
80104aaa:	e8 a5 f6 ff ff       	call   80104154 <makerunnable>
  sched(); 
80104aaf:	e8 fd fe ff ff       	call   801049b1 <sched>
  release(&ptable.lock);
80104ab4:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104abb:	e8 7e 0b 00 00       	call   8010563e <release>
}
80104ac0:	c9                   	leave  
80104ac1:	c3                   	ret    

80104ac2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ac2:	55                   	push   %ebp
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ac8:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104acf:	e8 6a 0b 00 00       	call   8010563e <release>

  if (first) {
80104ad4:	a1 20 c0 10 80       	mov    0x8010c020,%eax
80104ad9:	85 c0                	test   %eax,%eax
80104adb:	74 0f                	je     80104aec <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104add:	c7 05 20 c0 10 80 00 	movl   $0x0,0x8010c020
80104ae4:	00 00 00 
    initlog();
80104ae7:	e8 d6 e4 ff ff       	call   80102fc2 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104aec:	c9                   	leave  
80104aed:	c3                   	ret    

80104aee <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104aee:	55                   	push   %ebp
80104aef:	89 e5                	mov    %esp,%ebp
80104af1:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104af4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104afa:	85 c0                	test   %eax,%eax
80104afc:	75 0c                	jne    80104b0a <sleep+0x1c>
    panic("sleep");
80104afe:	c7 04 24 dc 91 10 80 	movl   $0x801091dc,(%esp)
80104b05:	e8 2c ba ff ff       	call   80100536 <panic>

  if(lk == 0)
80104b0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b0e:	75 0c                	jne    80104b1c <sleep+0x2e>
    panic("sleep without lk");
80104b10:	c7 04 24 e2 91 10 80 	movl   $0x801091e2,(%esp)
80104b17:	e8 1a ba ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b1c:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b23:	74 17                	je     80104b3c <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b25:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b2c:	e8 ab 0a 00 00       	call   801055dc <acquire>
    release(lk);
80104b31:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b34:	89 04 24             	mov    %eax,(%esp)
80104b37:	e8 02 0b 00 00       	call   8010563e <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104b3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b42:	8b 55 08             	mov    0x8(%ebp),%edx
80104b45:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING; 
80104b48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4e:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  // New -  when a proc goes to SLEEPING state, increase priority
  if(proc->priority > 0){ // New: Added in proyect 2
80104b55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104b61:	85 c0                	test   %eax,%eax
80104b63:	7e 13                	jle    80104b78 <sleep+0x8a>
    proc->priority--;
80104b65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b6b:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b71:	4a                   	dec    %edx
80104b72:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  sched();
80104b78:	e8 34 fe ff ff       	call   801049b1 <sched>

  // Tidy up.
  proc->chan = 0; // If non-zero, sleeping on chan
80104b7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b83:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104b8a:	81 7d 0c 00 10 11 80 	cmpl   $0x80111000,0xc(%ebp)
80104b91:	74 17                	je     80104baa <sleep+0xbc>
    release(&ptable.lock);
80104b93:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104b9a:	e8 9f 0a 00 00       	call   8010563e <release>
    acquire(lk);
80104b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ba2:	89 04 24             	mov    %eax,(%esp)
80104ba5:	e8 32 0a 00 00       	call   801055dc <acquire>
  }
}
80104baa:	c9                   	leave  
80104bab:	c3                   	ret    

80104bac <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104bac:	55                   	push   %ebp
80104bad:	89 e5                	mov    %esp,%ebp
80104baf:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bb2:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104bb9:	eb 30                	jmp    80104beb <wakeup1+0x3f>
    // if(p->state == SLEEPING && p->chan == chan)
    //   p->state = RUNNABLE;
    if(p->state == SLEEPING && p->chan == chan){ // Added in project 2
80104bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbe:	8b 40 0c             	mov    0xc(%eax),%eax
80104bc1:	83 f8 02             	cmp    $0x2,%eax
80104bc4:	75 1e                	jne    80104be4 <wakeup1+0x38>
80104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc9:	8b 40 20             	mov    0x20(%eax),%eax
80104bcc:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bcf:	75 13                	jne    80104be4 <wakeup1+0x38>
      // New - enqueue proc
      makerunnable(p,-1);
80104bd1:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
80104bd8:	ff 
80104bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdc:	89 04 24             	mov    %eax,(%esp)
80104bdf:	e8 70 f5 ff ff       	call   80104154 <makerunnable>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104be4:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80104beb:	81 7d f4 34 3c 11 80 	cmpl   $0x80113c34,-0xc(%ebp)
80104bf2:	72 c7                	jb     80104bbb <wakeup1+0xf>
    }
}
80104bf4:	c9                   	leave  
80104bf5:	c3                   	ret    

80104bf6 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104bf6:	55                   	push   %ebp
80104bf7:	89 e5                	mov    %esp,%ebp
80104bf9:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104bfc:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c03:	e8 d4 09 00 00       	call   801055dc <acquire>
  wakeup1(chan);
80104c08:	8b 45 08             	mov    0x8(%ebp),%eax
80104c0b:	89 04 24             	mov    %eax,(%esp)
80104c0e:	e8 99 ff ff ff       	call   80104bac <wakeup1>
  release(&ptable.lock);
80104c13:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c1a:	e8 1f 0a 00 00       	call   8010563e <release>
}
80104c1f:	c9                   	leave  
80104c20:	c3                   	ret    

80104c21 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104c21:	55                   	push   %ebp
80104c22:	89 e5                	mov    %esp,%ebp
80104c24:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104c27:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c2e:	e8 a9 09 00 00       	call   801055dc <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c33:	c7 45 f4 34 10 11 80 	movl   $0x80111034,-0xc(%ebp)
80104c3a:	eb 4d                	jmp    80104c89 <kill+0x68>
    if(p->pid == pid){
80104c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3f:	8b 40 10             	mov    0x10(%eax),%eax
80104c42:	3b 45 08             	cmp    0x8(%ebp),%eax
80104c45:	75 3b                	jne    80104c82 <kill+0x61>
      p->killed = 1; // killed: If non-zero, have been killed
80104c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c4a:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      // if(p->state == SLEEPING)
      //   p->state = RUNNABLE;
      if(p->state == SLEEPING){ // Added in proyect 2
80104c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c54:	8b 40 0c             	mov    0xc(%eax),%eax
80104c57:	83 f8 02             	cmp    $0x2,%eax
80104c5a:	75 13                	jne    80104c6f <kill+0x4e>
        // New - enqueue proc
        makerunnable(p,0);
80104c5c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104c63:	00 
80104c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c67:	89 04 24             	mov    %eax,(%esp)
80104c6a:	e8 e5 f4 ff ff       	call   80104154 <makerunnable>
      }
      release(&ptable.lock);
80104c6f:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c76:	e8 c3 09 00 00       	call   8010563e <release>
      return 0;
80104c7b:	b8 00 00 00 00       	mov    $0x0,%eax
80104c80:	eb 21                	jmp    80104ca3 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c82:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80104c89:	81 7d f4 34 3c 11 80 	cmpl   $0x80113c34,-0xc(%ebp)
80104c90:	72 aa                	jb     80104c3c <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104c92:	c7 04 24 00 10 11 80 	movl   $0x80111000,(%esp)
80104c99:	e8 a0 09 00 00       	call   8010563e <release>
  return -1;
80104c9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ca3:	c9                   	leave  
80104ca4:	c3                   	ret    

80104ca5 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104ca5:	55                   	push   %ebp
80104ca6:	89 e5                	mov    %esp,%ebp
80104ca8:	83 ec 68             	sub    $0x68,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cab:	c7 45 f0 34 10 11 80 	movl   $0x80111034,-0x10(%ebp)
80104cb2:	e9 e7 00 00 00       	jmp    80104d9e <procdump+0xf9>
    if(p->state == UNUSED)
80104cb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cba:	8b 40 0c             	mov    0xc(%eax),%eax
80104cbd:	85 c0                	test   %eax,%eax
80104cbf:	0f 84 d1 00 00 00    	je     80104d96 <procdump+0xf1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cc8:	8b 40 0c             	mov    0xc(%eax),%eax
80104ccb:	83 f8 05             	cmp    $0x5,%eax
80104cce:	77 23                	ja     80104cf3 <procdump+0x4e>
80104cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cd3:	8b 40 0c             	mov    0xc(%eax),%eax
80104cd6:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104cdd:	85 c0                	test   %eax,%eax
80104cdf:	74 12                	je     80104cf3 <procdump+0x4e>
      state = states[p->state];
80104ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ce4:	8b 40 0c             	mov    0xc(%eax),%eax
80104ce7:	8b 04 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%eax
80104cee:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104cf1:	eb 07                	jmp    80104cfa <procdump+0x55>
    else
      state = "???";
80104cf3:	c7 45 ec f3 91 10 80 	movl   $0x801091f3,-0x14(%ebp)
    // cprintf("%d %s %s", p->pid, state, p->name);
    cprintf("%d %s %s %d", p->pid, state, p->name, p->priority);
80104cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cfd:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d06:	8d 48 6c             	lea    0x6c(%eax),%ecx
80104d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d0c:	8b 40 10             	mov    0x10(%eax),%eax
80104d0f:	89 54 24 10          	mov    %edx,0x10(%esp)
80104d13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80104d17:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104d1a:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d22:	c7 04 24 f7 91 10 80 	movl   $0x801091f7,(%esp)
80104d29:	e8 73 b6 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d31:	8b 40 0c             	mov    0xc(%eax),%eax
80104d34:	83 f8 02             	cmp    $0x2,%eax
80104d37:	75 4f                	jne    80104d88 <procdump+0xe3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d3c:	8b 40 1c             	mov    0x1c(%eax),%eax
80104d3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104d42:	83 c0 08             	add    $0x8,%eax
80104d45:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104d48:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d4c:	89 04 24             	mov    %eax,(%esp)
80104d4f:	e8 39 09 00 00       	call   8010568d <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104d5b:	eb 1a                	jmp    80104d77 <procdump+0xd2>
        cprintf(" %p", pc[i]);
80104d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d60:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d64:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d68:	c7 04 24 03 92 10 80 	movl   $0x80109203,(%esp)
80104d6f:	e8 2d b6 ff ff       	call   801003a1 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d74:	ff 45 f4             	incl   -0xc(%ebp)
80104d77:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104d7b:	7f 0b                	jg     80104d88 <procdump+0xe3>
80104d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d80:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104d84:	85 c0                	test   %eax,%eax
80104d86:	75 d5                	jne    80104d5d <procdump+0xb8>
    }
    cprintf("\n");
80104d88:	c7 04 24 07 92 10 80 	movl   $0x80109207,(%esp)
80104d8f:	e8 0d b6 ff ff       	call   801003a1 <cprintf>
80104d94:	eb 01                	jmp    80104d97 <procdump+0xf2>
      continue;
80104d96:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d97:	81 45 f0 b0 00 00 00 	addl   $0xb0,-0x10(%ebp)
80104d9e:	81 7d f0 34 3c 11 80 	cmpl   $0x80113c34,-0x10(%ebp)
80104da5:	0f 82 0c ff ff ff    	jb     80104cb7 <procdump+0x12>
  }
}
80104dab:	c9                   	leave  
80104dac:	c3                   	ret    

80104dad <checkprocsem>:
	struct sem sem[MAXSEM]; // atrib. (value,refcount) (MAXSEM = 16)
} stable;

// proc->procsem es la lista de semaforos por proceso
// MAXSEMPROC = 4 es la cantidad maxima de semaforos por proceso
struct sem** checkprocsem(){
80104dad:	55                   	push   %ebp
80104dae:	89 e5                	mov    %esp,%ebp
80104db0:	83 ec 10             	sub    $0x10,%esp
	struct sem **r;
	// a "r" le asigno el arreglo de la list of semaphores del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104db3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db9:	05 88 00 00 00       	add    $0x88,%eax
80104dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
80104dc1:	eb 12                	jmp    80104dd5 <checkprocsem+0x28>
		if (*r == 0)
80104dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dc6:	8b 00                	mov    (%eax),%eax
80104dc8:	85 c0                	test   %eax,%eax
80104dca:	75 05                	jne    80104dd1 <checkprocsem+0x24>
			return r;
80104dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dcf:	eb 19                	jmp    80104dea <checkprocsem+0x3d>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104dd1:	83 45 fc 04          	addl   $0x4,-0x4(%ebp)
80104dd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ddb:	05 98 00 00 00       	add    $0x98,%eax
80104de0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
80104de3:	77 de                	ja     80104dc3 <checkprocsem+0x16>
	}
	return 0;
80104de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104dea:	c9                   	leave  
80104deb:	c3                   	ret    

80104dec <getstable>:

struct sem* getstable(){
80104dec:	55                   	push   %ebp
80104ded:	89 e5                	mov    %esp,%ebp
	return stable.sem;
80104def:	b8 94 3c 11 80       	mov    $0x80113c94,%eax
}
80104df4:	5d                   	pop    %ebp
80104df5:	c3                   	ret    

80104df6 <semget>:

// crea u obtiene un descriptor de un semaforo existente
int semget(int sem_id, int init_value){
80104df6:	55                   	push   %ebp
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	83 ec 28             	sub    $0x28,%esp
	struct sem *t;
	struct sem *s;
	struct sem **r;
	static int first_time = 1;

	if (first_time) {
80104dfc:	a1 24 c0 10 80       	mov    0x8010c024,%eax
80104e01:	85 c0                	test   %eax,%eax
80104e03:	74 1e                	je     80104e23 <semget+0x2d>
		initlock(&stable.lock, "stable"); // begin the mutual exclusion
80104e05:	c7 44 24 04 35 92 10 	movl   $0x80109235,0x4(%esp)
80104e0c:	80 
80104e0d:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104e14:	e8 a2 07 00 00       	call   801055bb <initlock>
		first_time = 0;
80104e19:	c7 05 24 c0 10 80 00 	movl   $0x0,0x8010c024
80104e20:	00 00 00 
	}

	acquire(&stable.lock);
80104e23:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104e2a:	e8 ad 07 00 00       	call   801055dc <acquire>
	if (sem_id == -1) { // se desea CREAR un semaforo nuevo
80104e2f:	83 7d 08 ff          	cmpl   $0xffffffff,0x8(%ebp)
80104e33:	0f 85 b0 00 00 00    	jne    80104ee9 <semget+0xf3>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e39:	c7 45 f4 94 3c 11 80 	movl   $0x80113c94,-0xc(%ebp)
80104e40:	eb 3b                	jmp    80104e7d <semget+0x87>
		if (t->refcount == 0){
80104e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e45:	8b 40 04             	mov    0x4(%eax),%eax
80104e48:	85 c0                	test   %eax,%eax
80104e4a:	75 2d                	jne    80104e79 <semget+0x83>
			s = t;
80104e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (*(r = checkprocsem()) == 0)
80104e52:	e8 56 ff ff ff       	call   80104dad <checkprocsem>
80104e57:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104e5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e5d:	8b 00                	mov    (%eax),%eax
80104e5f:	85 c0                	test   %eax,%eax
80104e61:	74 39                	je     80104e9c <semget+0xa6>
				goto found; // encontro
			release(&stable.lock);
80104e63:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104e6a:	e8 cf 07 00 00       	call   8010563e <release>
			return -2; // el proceso ya obtuvo el numero maximo de semaforos
80104e6f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104e74:	e9 eb 00 00 00       	jmp    80104f64 <semget+0x16e>
		for (t = stable.sem; t < stable.sem + MAXSEM; t++)
80104e79:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
80104e7d:	81 7d f4 14 3d 11 80 	cmpl   $0x80113d14,-0xc(%ebp)
80104e84:	72 bc                	jb     80104e42 <semget+0x4c>
		}
		release(&stable.lock);
80104e86:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104e8d:	e8 ac 07 00 00       	call   8010563e <release>
		return -3; // no ahi mas semaforos disponibles en el sistema
80104e92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80104e97:	e9 c8 00 00 00       	jmp    80104f64 <semget+0x16e>
				goto found; // encontro
80104e9c:	90                   	nop

		found:
		s->value = init_value;
80104e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ea3:	89 10                	mov    %edx,(%eax)
		s->refcount=1;
80104ea5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ea8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
		proc->semquantity++; // new
80104eaf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb5:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80104ebb:	42                   	inc    %edx
80104ebc:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
		*r = s;
80104ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104ec5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ec8:	89 10                	mov    %edx,(%eax)
		// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i));
		// 	} else
		// 		cprintf("SEMGET>> proc_sem_id = %d\n", *(proc->procsem + i) - stable.sem);
		// }

		release(&stable.lock);
80104eca:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104ed1:	e8 68 07 00 00       	call   8010563e <release>
		// cprintf("cantidad de semaforos del proceso hasta aca --->%d\n", proc->semquantity);
		return s - stable.sem;	// retorna el semaforo
80104ed6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ed9:	b8 94 3c 11 80       	mov    $0x80113c94,%eax
80104ede:	89 d1                	mov    %edx,%ecx
80104ee0:	29 c1                	sub    %eax,%ecx
80104ee2:	89 c8                	mov    %ecx,%eax
80104ee4:	c1 f8 03             	sar    $0x3,%eax
80104ee7:	eb 7b                	jmp    80104f64 <semget+0x16e>

	} else { // en caso de que NO se desea crear un semaforo nuevo
		s = stable.sem + sem_id;
80104ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80104eec:	83 c0 06             	add    $0x6,%eax
80104eef:	c1 e0 03             	shl    $0x3,%eax
80104ef2:	05 60 3c 11 80       	add    $0x80113c60,%eax
80104ef7:	83 c0 04             	add    $0x4,%eax
80104efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (s->refcount == 0){
80104efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f00:	8b 40 04             	mov    0x4(%eax),%eax
80104f03:	85 c0                	test   %eax,%eax
80104f05:	75 13                	jne    80104f1a <semget+0x124>
			release(&stable.lock);
80104f07:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104f0e:	e8 2b 07 00 00       	call   8010563e <release>
			return -1; // el semaforo con ese "sem_id" no esta en uso 
80104f13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f18:	eb 4a                	jmp    80104f64 <semget+0x16e>
		}else if (*(r = checkprocsem()) == 0){
80104f1a:	e8 8e fe ff ff       	call   80104dad <checkprocsem>
80104f1f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f25:	8b 00                	mov    (%eax),%eax
80104f27:	85 c0                	test   %eax,%eax
80104f29:	75 28                	jne    80104f53 <semget+0x15d>
			*r = s;
80104f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f31:	89 10                	mov    %edx,(%eax)
			s->refcount++; //aumento referencia
80104f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f36:	8b 40 04             	mov    0x4(%eax),%eax
80104f39:	8d 50 01             	lea    0x1(%eax),%edx
80104f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f3f:	89 50 04             	mov    %edx,0x4(%eax)
			release(&stable.lock);
80104f42:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104f49:	e8 f0 06 00 00       	call   8010563e <release>
			return sem_id; // retorno identificador del semaforo
80104f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f51:	eb 11                	jmp    80104f64 <semget+0x16e>
		}	else {
			release(&stable.lock);
80104f53:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104f5a:	e8 df 06 00 00       	call   8010563e <release>
			return -2; // el proceso ya obtuvo el maximo de semaforos
80104f5f:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		}
	}
}
80104f64:	c9                   	leave  
80104f65:	c3                   	ret    

80104f66 <semfree>:

// libera el semaforo.
// como parametro toma un descriptor.
int semfree(int sem_id){
80104f66:	55                   	push   %ebp
80104f67:	89 e5                	mov    %esp,%ebp
80104f69:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;
	struct sem **r;

	s = stable.sem + sem_id;
80104f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6f:	83 c0 06             	add    $0x6,%eax
80104f72:	c1 e0 03             	shl    $0x3,%eax
80104f75:	05 60 3c 11 80       	add    $0x80113c60,%eax
80104f7a:	83 c0 04             	add    $0x4,%eax
80104f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (s->refcount == 0) // si no tiene ninguna referencia, entonces no esta en uso,	
80104f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f83:	8b 40 04             	mov    0x4(%eax),%eax
80104f86:	85 c0                	test   %eax,%eax
80104f88:	75 07                	jne    80104f91 <semfree+0x2b>
		return -1;		 //  y no es posible liberarlo, se produce un ERROR! 
80104f8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8f:	eb 7d                	jmp    8010500e <semfree+0xa8>

	// recorro todos los semaforos del proceso
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104f91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f97:	05 88 00 00 00       	add    $0x88,%eax
80104f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f9f:	eb 58                	jmp    80104ff9 <semfree+0x93>
		if (*r == s) {
80104fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa4:	8b 00                	mov    (%eax),%eax
80104fa6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104fa9:	75 4a                	jne    80104ff5 <semfree+0x8f>
			*r = 0;
80104fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			acquire(&stable.lock);
80104fb4:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104fbb:	e8 1c 06 00 00       	call   801055dc <acquire>
			s->refcount--; // disminuyo el contador, debido a q es un semaforo q se va.
80104fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc3:	8b 40 04             	mov    0x4(%eax),%eax
80104fc6:	8d 50 ff             	lea    -0x1(%eax),%edx
80104fc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fcc:	89 50 04             	mov    %edx,0x4(%eax)
			proc->semquantity--; // new
80104fcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd5:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80104fdb:	4a                   	dec    %edx
80104fdc:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
			release(&stable.lock);
80104fe2:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80104fe9:	e8 50 06 00 00       	call   8010563e <release>
			return 0;
80104fee:	b8 00 00 00 00       	mov    $0x0,%eax
80104ff3:	eb 19                	jmp    8010500e <semfree+0xa8>
	for (r = proc->procsem; r < proc->procsem + MAXSEMPROC; r++) {
80104ff5:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
80104ff9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fff:	05 98 00 00 00       	add    $0x98,%eax
80105004:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105007:	77 98                	ja     80104fa1 <semfree+0x3b>
		}
	}
	return -1;
80105009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010500e:	c9                   	leave  
8010500f:	c3                   	ret    

80105010 <semdown>:

// decrementa una unidad el valor del semaforo.
int semdown(int sem_id){
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	83 ec 28             	sub    $0x28,%esp
	struct sem *s;

	s = stable.sem + sem_id;
80105016:	8b 45 08             	mov    0x8(%ebp),%eax
80105019:	83 c0 06             	add    $0x6,%eax
8010501c:	c1 e0 03             	shl    $0x3,%eax
8010501f:	05 60 3c 11 80       	add    $0x80113c60,%eax
80105024:	83 c0 04             	add    $0x4,%eax
80105027:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
8010502a:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105031:	e8 a6 05 00 00       	call   801055dc <acquire>
	if (s->refcount <= 0) {
80105036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105039:	8b 40 04             	mov    0x4(%eax),%eax
8010503c:	85 c0                	test   %eax,%eax
8010503e:	7f 28                	jg     80105068 <semdown+0x58>
		release(&stable.lock);
80105040:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105047:	e8 f2 05 00 00       	call   8010563e <release>
		// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error!!
8010504c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105051:	eb 3d                	jmp    80105090 <semdown+0x80>
	}
	while (s->value == 0)
		sleep(s, &stable.lock); 
80105053:	c7 44 24 04 60 3c 11 	movl   $0x80113c60,0x4(%esp)
8010505a:	80 
8010505b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505e:	89 04 24             	mov    %eax,(%esp)
80105061:	e8 88 fa ff ff       	call   80104aee <sleep>
80105066:	eb 01                	jmp    80105069 <semdown+0x59>
	while (s->value == 0)
80105068:	90                   	nop
80105069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506c:	8b 00                	mov    (%eax),%eax
8010506e:	85 c0                	test   %eax,%eax
80105070:	74 e1                	je     80105053 <semdown+0x43>
	
	s->value--;
80105072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105075:	8b 00                	mov    (%eax),%eax
80105077:	8d 50 ff             	lea    -0x1(%eax),%edx
8010507a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507d:	89 10                	mov    %edx,(%eax)
	// cprintf("SEMDOWN>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	release(&stable.lock);
8010507f:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105086:	e8 b3 05 00 00       	call   8010563e <release>
	return 0;
8010508b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105090:	c9                   	leave  
80105091:	c3                   	ret    

80105092 <semup>:

// incrementa una unidad el valor del semaforo
int semup(int sem_id){
80105092:	55                   	push   %ebp
80105093:	89 e5                	mov    %esp,%ebp
80105095:	83 ec 28             	sub    $0x28,%esp
struct sem *s;

	s = stable.sem + sem_id;
80105098:	8b 45 08             	mov    0x8(%ebp),%eax
8010509b:	83 c0 06             	add    $0x6,%eax
8010509e:	c1 e0 03             	shl    $0x3,%eax
801050a1:	05 60 3c 11 80       	add    $0x80113c60,%eax
801050a6:	83 c0 04             	add    $0x4,%eax
801050a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	acquire(&stable.lock);
801050ac:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
801050b3:	e8 24 05 00 00       	call   801055dc <acquire>
	if (s->refcount <= 0) {
801050b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bb:	8b 40 04             	mov    0x4(%eax),%eax
801050be:	85 c0                	test   %eax,%eax
801050c0:	7f 13                	jg     801050d5 <semup+0x43>
		release(&stable.lock);
801050c2:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
801050c9:	e8 70 05 00 00       	call   8010563e <release>
		// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
		return -1; // error, por que no ahi referencias en este semaforo.
801050ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d3:	eb 4a                	jmp    8010511f <semup+0x8d>
	}
	if (s->value >= 0) {
801050d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d8:	8b 00                	mov    (%eax),%eax
801050da:	85 c0                	test   %eax,%eax
801050dc:	78 3c                	js     8010511a <semup+0x88>
		if (s->value == 0){
801050de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e1:	8b 00                	mov    (%eax),%eax
801050e3:	85 c0                	test   %eax,%eax
801050e5:	75 1a                	jne    80105101 <semup+0x6f>
			s->value++;
801050e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ea:	8b 00                	mov    (%eax),%eax
801050ec:	8d 50 01             	lea    0x1(%eax),%edx
801050ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f2:	89 10                	mov    %edx,(%eax)
			wakeup(s); // despierto
801050f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f7:	89 04 24             	mov    %eax,(%esp)
801050fa:	e8 f7 fa ff ff       	call   80104bf6 <wakeup>
801050ff:	eb 0d                	jmp    8010510e <semup+0x7c>
		}else
			s->value++;
80105101:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105104:	8b 00                	mov    (%eax),%eax
80105106:	8d 50 01             	lea    0x1(%eax),%edx
80105109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010510c:	89 10                	mov    %edx,(%eax)
			release(&stable.lock);
8010510e:	c7 04 24 60 3c 11 80 	movl   $0x80113c60,(%esp)
80105115:	e8 24 05 00 00       	call   8010563e <release>
			// cprintf("SEMUP>> sem_id = %d, semaforo %d, valor = %d, refcount = %d\n", sem_id, s, s->value, s->refcount);
	}
	return 0;
8010511a:	b8 00 00 00 00       	mov    $0x0,%eax
8010511f:	c9                   	leave  
80105120:	c3                   	ret    

80105121 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80105121:	55                   	push   %ebp
80105122:	89 e5                	mov    %esp,%ebp
80105124:	8b 45 08             	mov    0x8(%ebp),%eax
80105127:	05 00 00 00 80       	add    $0x80000000,%eax
8010512c:	5d                   	pop    %ebp
8010512d:	c3                   	ret    

8010512e <shm_init>:
//   unsigned short quantity; //quantity of actives espaces of shared memory
// } shmtable;

int
shm_init()
{
8010512e:	55                   	push   %ebp
8010512f:	89 e5                	mov    %esp,%ebp
80105131:	83 ec 28             	sub    $0x28,%esp
  int i;
  initlock(&shmtable.lock, "shmtable");
80105134:	c7 44 24 04 3c 92 10 	movl   $0x8010923c,0x4(%esp)
8010513b:	80 
8010513c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105143:	e8 73 04 00 00       	call   801055bb <initlock>
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
80105148:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010514f:	eb 11                	jmp    80105162 <shm_init+0x34>
    shmtable.sharedmemory[i].refcount = -1; // inician todos los espacios con su contador de referencia en -1.
80105151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105154:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
8010515b:	ff ff ff ff 
  for(i = 0; i<MAXSHM; i++){ //recorro el arreglo hasta los MAXSHM=12 espacios de memoria compartida del sistema.
8010515f:	ff 45 f4             	incl   -0xc(%ebp)
80105162:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80105166:	7e e9                	jle    80105151 <shm_init+0x23>
  }
  return 0;
80105168:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010516d:	c9                   	leave  
8010516e:	c3                   	ret    

8010516f <shm_create>:

//Creates a shared memory block.
int
shm_create()
{ 
8010516f:	55                   	push   %ebp
80105170:	89 e5                	mov    %esp,%ebp
80105172:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);
80105175:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010517c:	e8 5b 04 00 00       	call   801055dc <acquire>
  if ( shmtable.quantity == MAXSHM ){ // si la cantidad de espacios activos en sharedmemory es igual a 12
80105181:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
80105186:	66 83 f8 0c          	cmp    $0xc,%ax
8010518a:	75 16                	jne    801051a2 <shm_create+0x33>
    release(&shmtable.lock);         // es la logitud maxima del array sharedmemory, entonces:
8010518c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105193:	e8 a6 04 00 00       	call   8010563e <release>
    return -1;                      // no ahi mas espacios de memoria compartida, se fueron los 12 espacios que habia.
80105198:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010519d:	e9 97 00 00 00       	jmp    80105239 <shm_create+0xca>
  }
  int i = 0;
801051a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
801051a9:	eb 77                	jmp    80105222 <shm_create+0xb3>
    if (shmtable.sharedmemory[i].refcount == -1){ // si es -1, esta desocupado el espacio.
801051ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ae:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801051b5:	83 f8 ff             	cmp    $0xffffffff,%eax
801051b8:	75 65                	jne    8010521f <shm_create+0xb0>
      shmtable.sharedmemory[i].addr = kalloc(); // El "kalloc" asigna una pagina de 4096 bytes de memoria fisica,
801051ba:	e8 ff d8 ff ff       	call   80102abe <kalloc>
801051bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051c2:	89 04 d5 60 0f 11 80 	mov    %eax,-0x7feef0a0(,%edx,8)
                                                // si todo sale bien, me retorna como resultado un puntero (direccion), 
                                                // a esta direccion la almaceno en "sharedmemory.addr".
                                                // Si el kalloc no pudo asignar la memoria me devuelve como resultado 0.
      memset(shmtable.sharedmemory[i].addr, 0, PGSIZE); 
801051c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051cc:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
801051d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801051da:	00 
801051db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051e2:	00 
801051e3:	89 04 24             	mov    %eax,(%esp)
801051e6:	e8 43 06 00 00       	call   8010582e <memset>
      shmtable.sharedmemory[i].refcount++; // Incremento el refcount en una unidad, estaba en -1, ahora en 0, inicialmente.
801051eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ee:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801051f5:	8d 50 01             	lea    0x1(%eax),%edx
801051f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051fb:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
      shmtable.quantity++; // se tomo un espacio del arreglo 
80105202:	a1 f4 0f 11 80       	mov    0x80110ff4,%eax
80105207:	40                   	inc    %eax
80105208:	66 a3 f4 0f 11 80    	mov    %ax,0x80110ff4
      release(&shmtable.lock);
8010520e:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105215:	e8 24 04 00 00       	call   8010563e <release>
      return i; // retorno el indice (key) del arreglo en donde se encuentra el espacio de memoria compartida.
8010521a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010521d:	eb 1a                	jmp    80105239 <shm_create+0xca>
    } else
      ++i;
8010521f:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHM){ // busco el primer espacio desocupado
80105222:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80105226:	7e 83                	jle    801051ab <shm_create+0x3c>
  }
  release(&shmtable.lock);
80105228:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010522f:	e8 0a 04 00 00       	call   8010563e <release>
  //return -2 si proc->sharedmemory == MAXSHMPROC; // Consultar?: el proceso ya alcanzo el maximo de recursos posibles.
  return -1; // no ahi mas recursos disponbles en el sistema.
80105234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105239:	c9                   	leave  
8010523a:	c3                   	ret    

8010523b <shm_close>:

//Frees the memory block previously obtained.
int
shm_close(int key)
{
8010523b:	55                   	push   %ebp
8010523c:	89 e5                	mov    %esp,%ebp
8010523e:	83 ec 28             	sub    $0x28,%esp
  acquire(&shmtable.lock);  
80105241:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105248:	e8 8f 03 00 00       	call   801055dc <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == -1){
8010524d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105251:	78 15                	js     80105268 <shm_close+0x2d>
80105253:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
80105257:	7f 0f                	jg     80105268 <shm_close+0x2d>
80105259:	8b 45 08             	mov    0x8(%ebp),%eax
8010525c:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105263:	83 f8 ff             	cmp    $0xffffffff,%eax
80105266:	75 16                	jne    8010527e <shm_close+0x43>
    release(&shmtable.lock);
80105268:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010526f:	e8 ca 03 00 00       	call   8010563e <release>
    return -1; // key invalidad por que no esta dentro de los indices (0 - 12), o en ese espacio esta vacio (refcount = -1)
80105274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105279:	e9 8d 00 00 00       	jmp    8010530b <shm_close+0xd0>
  }
  int i = 0;
8010527e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
80105285:	eb 03                	jmp    8010528a <shm_close+0x4f>
    i++; // avanzo al proximo
80105287:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && (proc->shmref[i] != shmtable.sharedmemory[key].addr)){ // para poder buscar donde se encuentra
8010528a:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
8010528e:	7f 1e                	jg     801052ae <shm_close+0x73>
80105290:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105296:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105299:	83 c2 24             	add    $0x24,%edx
8010529c:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
801052a0:	8b 45 08             	mov    0x8(%ebp),%eax
801052a3:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
801052aa:	39 c2                	cmp    %eax,%edx
801052ac:	75 d9                	jne    80105287 <shm_close+0x4c>
  }
  if (i == MAXSHMPROC){ 
801052ae:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801052b2:	75 13                	jne    801052c7 <shm_close+0x8c>
    release(&shmtable.lock);
801052b4:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
801052bb:	e8 7e 03 00 00       	call   8010563e <release>
    return -1; // se alcazo a recorrer todos los espacios de memoria compartida del proceso.
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052c5:	eb 44                	jmp    8010530b <shm_close+0xd0>
  }  
  shmtable.sharedmemory[key].refcount--; // encontre la direccion, luego decremento refcount.
801052c7:	8b 45 08             	mov    0x8(%ebp),%eax
801052ca:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801052d1:	8d 50 ff             	lea    -0x1(%eax),%edx
801052d4:	8b 45 08             	mov    0x8(%ebp),%eax
801052d7:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
  if (shmtable.sharedmemory[key].refcount == 0){ 
801052de:	8b 45 08             	mov    0x8(%ebp),%eax
801052e1:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
801052e8:	85 c0                	test   %eax,%eax
801052ea:	75 0e                	jne    801052fa <shm_close+0xbf>
    shmtable.sharedmemory[key].refcount = -1; // reinicio el espacio en el arreglo, como solo quedo uno, lo reinicio.
801052ec:	8b 45 08             	mov    0x8(%ebp),%eax
801052ef:	c7 04 c5 64 0f 11 80 	movl   $0xffffffff,-0x7feef09c(,%eax,8)
801052f6:	ff ff ff ff 
  }
  release(&shmtable.lock);
801052fa:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105301:	e8 38 03 00 00       	call   8010563e <release>
  return 0;  // todo en orden
80105306:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010530b:	c9                   	leave  
8010530c:	c3                   	ret    

8010530d <shm_get>:

//Obtains the address of the memory block associated with key.
int
shm_get(int key, char** addr)
{
8010530d:	55                   	push   %ebp
8010530e:	89 e5                	mov    %esp,%ebp
80105310:	83 ec 38             	sub    $0x38,%esp
  int j;
  acquire(&shmtable.lock);
80105313:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010531a:	e8 bd 02 00 00       	call   801055dc <acquire>
  if ( key < 0 || key > MAXSHM || shmtable.sharedmemory[key].refcount == MAXSHMPROC ){ 
8010531f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105323:	78 15                	js     8010533a <shm_get+0x2d>
80105325:	83 7d 08 0c          	cmpl   $0xc,0x8(%ebp)
80105329:	7f 0f                	jg     8010533a <shm_get+0x2d>
8010532b:	8b 45 08             	mov    0x8(%ebp),%eax
8010532e:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105335:	83 f8 04             	cmp    $0x4,%eax
80105338:	75 16                	jne    80105350 <shm_get+0x43>
    release(&shmtable.lock);                 
8010533a:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105341:	e8 f8 02 00 00       	call   8010563e <release>
    return -1; // key invalida, debido a que esta fuera de los indices la key.
80105346:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010534b:	e9 24 01 00 00       	jmp    80105474 <shm_get+0x167>
  }  
  int i = 0;
80105350:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
80105357:	eb 03                	jmp    8010535c <shm_get+0x4f>
    i++;
80105359:	ff 45 f4             	incl   -0xc(%ebp)
  while (i<MAXSHMPROC && proc->shmref[i] != 0 ){ // existe una referencia
8010535c:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80105360:	7f 14                	jg     80105376 <shm_get+0x69>
80105362:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105368:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010536b:	83 c2 24             	add    $0x24,%edx
8010536e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80105372:	85 c0                	test   %eax,%eax
80105374:	75 e3                	jne    80105359 <shm_get+0x4c>
  }
  if (i == MAXSHMPROC ){ // si agoto los 4 espacios que posee el proceso disponible, entonces..
80105376:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010537a:	75 16                	jne    80105392 <shm_get+0x85>
    release(&shmtable.lock); 
8010537c:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
80105383:	e8 b6 02 00 00       	call   8010563e <release>
    return -1; // no ahi mas recursos disponibles (esp. de memoria compartida) por este proceso.
80105388:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538d:	e9 e2 00 00 00       	jmp    80105474 <shm_get+0x167>
  } else {  
            
    j = mappages(proc->pgdir, (void *)PGROUNDDOWN(proc->sz), PGSIZE, v2p(shmtable.sharedmemory[i].addr), PTE_W|PTE_U);
80105392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105395:	8b 04 c5 60 0f 11 80 	mov    -0x7feef0a0(,%eax,8),%eax
8010539c:	89 04 24             	mov    %eax,(%esp)
8010539f:	e8 7d fd ff ff       	call   80105121 <v2p>
801053a4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053ab:	8b 12                	mov    (%edx),%edx
801053ad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801053b3:	89 d1                	mov    %edx,%ecx
801053b5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053bc:	8b 52 04             	mov    0x4(%edx),%edx
801053bf:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801053c6:	00 
801053c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
801053cb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801053d2:	00 
801053d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801053d7:	89 14 24             	mov    %edx,(%esp)
801053da:	e8 df 30 00 00       	call   801084be <mappages>
801053df:	89 45 f0             	mov    %eax,-0x10(%ebp)
            // Llena entradas de la tabla de paginas, mapeo de direcciones virtuales segun direc. fisicas

            // PTE_U: controla que el proceso de usuario pueda utilizar la pagina, si no solo el kernel puede usar la pagina.
            // PTE_W: controla si las instrucciones se les permite escribir en la pagina.

    if (j==-1) { cprintf("mappages error \n"); }
801053e2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
801053e6:	75 0c                	jne    801053f4 <shm_get+0xe7>
801053e8:	c7 04 24 45 92 10 80 	movl   $0x80109245,(%esp)
801053ef:	e8 ad af ff ff       	call   801003a1 <cprintf>

    proc->shmref[i] = shmtable.sharedmemory[key].addr; // la guardo en shmref[i]
801053f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053fa:	8b 55 08             	mov    0x8(%ebp),%edx
801053fd:	8b 14 d5 60 0f 11 80 	mov    -0x7feef0a0(,%edx,8),%edx
80105404:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105407:	83 c1 24             	add    $0x24,%ecx
8010540a:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    shmtable.sharedmemory[key].refcount++; 
8010540e:	8b 45 08             	mov    0x8(%ebp),%eax
80105411:	8b 04 c5 64 0f 11 80 	mov    -0x7feef09c(,%eax,8),%eax
80105418:	8d 50 01             	lea    0x1(%eax),%edx
8010541b:	8b 45 08             	mov    0x8(%ebp),%eax
8010541e:	89 14 c5 64 0f 11 80 	mov    %edx,-0x7feef09c(,%eax,8)
    *addr = (char *)PGROUNDDOWN(proc->sz); // guardo la direccion en *addr, de la pagina que se encuentra por debajo de proc->sz
80105425:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010542b:	8b 00                	mov    (%eax),%eax
8010542d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105432:	89 c2                	mov    %eax,%edx
80105434:	8b 45 0c             	mov    0xc(%ebp),%eax
80105437:	89 10                	mov    %edx,(%eax)
    proc->shmemquantity++; // aumento la cantidad de espacio de memoria compartida por el proceso
80105439:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010543f:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105445:	42                   	inc    %edx
80105446:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
    proc->sz = proc->sz + PGSIZE; // actualizo el tamaño de la memoria del proceso, debido a que ya se realizo el mapeo
8010544c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105452:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105459:	8b 12                	mov    (%edx),%edx
8010545b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80105461:	89 10                	mov    %edx,(%eax)
    release(&shmtable.lock);
80105463:	c7 04 24 c0 0f 11 80 	movl   $0x80110fc0,(%esp)
8010546a:	e8 cf 01 00 00       	call   8010563e <release>
    return 0; // todo salio bien.
8010546f:	b8 00 00 00 00       	mov    $0x0,%eax
  }   
}
80105474:	c9                   	leave  
80105475:	c3                   	ret    

80105476 <get_shm_table>:

//Obtains the array from type sharedmemory
struct sharedmemory* get_shm_table(){
80105476:	55                   	push   %ebp
80105477:	89 e5                	mov    %esp,%ebp
  return shmtable.sharedmemory; // como resultado, mi arreglo principal sharedmemory 
80105479:	b8 60 0f 11 80       	mov    $0x80110f60,%eax
}
8010547e:	5d                   	pop    %ebp
8010547f:	c3                   	ret    

80105480 <sys_shm_create>:
// esta la termine definiendo en Makefile!!!!!!!! recordar

//Creates a shared memory block.
int
sys_shm_create(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 28             	sub    $0x28,%esp
  int size;
  if(argint(0, &size) < 0 && (size > 0) )
80105486:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105489:	89 44 24 04          	mov    %eax,0x4(%esp)
8010548d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105494:	e8 c6 06 00 00       	call   80105b5f <argint>
80105499:	85 c0                	test   %eax,%eax
8010549b:	79 0e                	jns    801054ab <sys_shm_create+0x2b>
8010549d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801054a0:	85 c0                	test   %eax,%eax
801054a2:	7e 07                	jle    801054ab <sys_shm_create+0x2b>
    return -1;
801054a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a9:	eb 0b                	jmp    801054b6 <sys_shm_create+0x36>
  int k = shm_create();
801054ab:	e8 bf fc ff ff       	call   8010516f <shm_create>
801054b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return k;
801054b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801054b6:	c9                   	leave  
801054b7:	c3                   	ret    

801054b8 <sys_shm_get>:

//Obtains the address of the memory block associated with key.
int
sys_shm_get(void)
{
801054b8:	55                   	push   %ebp
801054b9:	89 e5                	mov    %esp,%ebp
801054bb:	83 ec 28             	sub    $0x28,%esp
  int k;
  int mem = 0;  
801054be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (proc->shmemquantity >= MAXSHMPROC)
801054c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054cb:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801054d1:	83 f8 03             	cmp    $0x3,%eax
801054d4:	7e 07                	jle    801054dd <sys_shm_get+0x25>
    return -1;
801054d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054db:	eb 55                	jmp    80105532 <sys_shm_get+0x7a>
  if(argint(0, &k) < 0)
801054dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801054e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054eb:	e8 6f 06 00 00       	call   80105b5f <argint>
801054f0:	85 c0                	test   %eax,%eax
801054f2:	79 07                	jns    801054fb <sys_shm_get+0x43>
    return -1;
801054f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054f9:	eb 37                	jmp    80105532 <sys_shm_get+0x7a>
  argint(1,&mem); 
801054fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105502:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105509:	e8 51 06 00 00       	call   80105b5f <argint>
  if (!shm_get(k,(char**)mem)){ 
8010550e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105511:	89 c2                	mov    %eax,%edx
80105513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105516:	89 54 24 04          	mov    %edx,0x4(%esp)
8010551a:	89 04 24             	mov    %eax,(%esp)
8010551d:	e8 eb fd ff ff       	call   8010530d <shm_get>
80105522:	85 c0                	test   %eax,%eax
80105524:	75 07                	jne    8010552d <sys_shm_get+0x75>
    return 0;
80105526:	b8 00 00 00 00       	mov    $0x0,%eax
8010552b:	eb 05                	jmp    80105532 <sys_shm_get+0x7a>
  }
  return -1;
8010552d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105532:	c9                   	leave  
80105533:	c3                   	ret    

80105534 <sys_shm_close>:

//Frees the memory block previously obtained.
int
sys_shm_close(void)
{
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	83 ec 28             	sub    $0x28,%esp
  int k;
  if(argint(0, &k) < 0)
8010553a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105541:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105548:	e8 12 06 00 00       	call   80105b5f <argint>
8010554d:	85 c0                	test   %eax,%eax
8010554f:	79 07                	jns    80105558 <sys_shm_close+0x24>
    return -1;
80105551:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105556:	eb 1b                	jmp    80105573 <sys_shm_close+0x3f>
  if (!shm_close(k)){    
80105558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010555b:	89 04 24             	mov    %eax,(%esp)
8010555e:	e8 d8 fc ff ff       	call   8010523b <shm_close>
80105563:	85 c0                	test   %eax,%eax
80105565:	75 07                	jne    8010556e <sys_shm_close+0x3a>
    return 0;
80105567:	b8 00 00 00 00       	mov    $0x0,%eax
8010556c:	eb 05                	jmp    80105573 <sys_shm_close+0x3f>
  }
  return -1;
8010556e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105573:	c9                   	leave  
80105574:	c3                   	ret    

80105575 <readeflags>:
{
80105575:	55                   	push   %ebp
80105576:	89 e5                	mov    %esp,%ebp
80105578:	53                   	push   %ebx
80105579:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010557c:	9c                   	pushf  
8010557d:	5b                   	pop    %ebx
8010557e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80105581:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80105584:	83 c4 10             	add    $0x10,%esp
80105587:	5b                   	pop    %ebx
80105588:	5d                   	pop    %ebp
80105589:	c3                   	ret    

8010558a <cli>:
{
8010558a:	55                   	push   %ebp
8010558b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010558d:	fa                   	cli    
}
8010558e:	5d                   	pop    %ebp
8010558f:	c3                   	ret    

80105590 <sti>:
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80105593:	fb                   	sti    
}
80105594:	5d                   	pop    %ebp
80105595:	c3                   	ret    

80105596 <xchg>:
{
80105596:	55                   	push   %ebp
80105597:	89 e5                	mov    %esp,%ebp
80105599:	53                   	push   %ebx
8010559a:	83 ec 10             	sub    $0x10,%esp
               "+m" (*addr), "=a" (result) :
8010559d:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
801055a0:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801055a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
801055a6:	89 c3                	mov    %eax,%ebx
801055a8:	89 d8                	mov    %ebx,%eax
801055aa:	f0 87 02             	lock xchg %eax,(%edx)
801055ad:	89 c3                	mov    %eax,%ebx
801055af:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return result;
801055b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801055b5:	83 c4 10             	add    $0x10,%esp
801055b8:	5b                   	pop    %ebx
801055b9:	5d                   	pop    %ebp
801055ba:	c3                   	ret    

801055bb <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801055bb:	55                   	push   %ebp
801055bc:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801055be:	8b 45 08             	mov    0x8(%ebp),%eax
801055c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801055c4:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801055c7:	8b 45 08             	mov    0x8(%ebp),%eax
801055ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801055d0:	8b 45 08             	mov    0x8(%ebp),%eax
801055d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801055da:	5d                   	pop    %ebp
801055db:	c3                   	ret    

801055dc <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801055dc:	55                   	push   %ebp
801055dd:	89 e5                	mov    %esp,%ebp
801055df:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801055e2:	e8 47 01 00 00       	call   8010572e <pushcli>
  if(holding(lk))
801055e7:	8b 45 08             	mov    0x8(%ebp),%eax
801055ea:	89 04 24             	mov    %eax,(%esp)
801055ed:	e8 12 01 00 00       	call   80105704 <holding>
801055f2:	85 c0                	test   %eax,%eax
801055f4:	74 0c                	je     80105602 <acquire+0x26>
    panic("acquire");
801055f6:	c7 04 24 56 92 10 80 	movl   $0x80109256,(%esp)
801055fd:	e8 34 af ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105602:	90                   	nop
80105603:	8b 45 08             	mov    0x8(%ebp),%eax
80105606:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010560d:	00 
8010560e:	89 04 24             	mov    %eax,(%esp)
80105611:	e8 80 ff ff ff       	call   80105596 <xchg>
80105616:	85 c0                	test   %eax,%eax
80105618:	75 e9                	jne    80105603 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010561a:	8b 45 08             	mov    0x8(%ebp),%eax
8010561d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105624:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105627:	8b 45 08             	mov    0x8(%ebp),%eax
8010562a:	83 c0 0c             	add    $0xc,%eax
8010562d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105631:	8d 45 08             	lea    0x8(%ebp),%eax
80105634:	89 04 24             	mov    %eax,(%esp)
80105637:	e8 51 00 00 00       	call   8010568d <getcallerpcs>
}
8010563c:	c9                   	leave  
8010563d:	c3                   	ret    

8010563e <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
8010563e:	55                   	push   %ebp
8010563f:	89 e5                	mov    %esp,%ebp
80105641:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80105644:	8b 45 08             	mov    0x8(%ebp),%eax
80105647:	89 04 24             	mov    %eax,(%esp)
8010564a:	e8 b5 00 00 00       	call   80105704 <holding>
8010564f:	85 c0                	test   %eax,%eax
80105651:	75 0c                	jne    8010565f <release+0x21>
    panic("release");
80105653:	c7 04 24 5e 92 10 80 	movl   $0x8010925e,(%esp)
8010565a:	e8 d7 ae ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
8010565f:	8b 45 08             	mov    0x8(%ebp),%eax
80105662:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105669:	8b 45 08             	mov    0x8(%ebp),%eax
8010566c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80105673:	8b 45 08             	mov    0x8(%ebp),%eax
80105676:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010567d:	00 
8010567e:	89 04 24             	mov    %eax,(%esp)
80105681:	e8 10 ff ff ff       	call   80105596 <xchg>

  popcli();
80105686:	e8 e9 00 00 00       	call   80105774 <popcli>
}
8010568b:	c9                   	leave  
8010568c:	c3                   	ret    

8010568d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010568d:	55                   	push   %ebp
8010568e:	89 e5                	mov    %esp,%ebp
80105690:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105693:	8b 45 08             	mov    0x8(%ebp),%eax
80105696:	83 e8 08             	sub    $0x8,%eax
80105699:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010569c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801056a3:	eb 37                	jmp    801056dc <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801056a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801056a9:	74 51                	je     801056fc <getcallerpcs+0x6f>
801056ab:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801056b2:	76 48                	jbe    801056fc <getcallerpcs+0x6f>
801056b4:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801056b8:	74 42                	je     801056fc <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
801056ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c7:	01 c2                	add    %eax,%edx
801056c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056cc:	8b 40 04             	mov    0x4(%eax),%eax
801056cf:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801056d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056d4:	8b 00                	mov    (%eax),%eax
801056d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801056d9:	ff 45 f8             	incl   -0x8(%ebp)
801056dc:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801056e0:	7e c3                	jle    801056a5 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801056e2:	eb 18                	jmp    801056fc <getcallerpcs+0x6f>
    pcs[i] = 0;
801056e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
801056e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801056ee:	8b 45 0c             	mov    0xc(%ebp),%eax
801056f1:	01 d0                	add    %edx,%eax
801056f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801056f9:	ff 45 f8             	incl   -0x8(%ebp)
801056fc:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105700:	7e e2                	jle    801056e4 <getcallerpcs+0x57>
}
80105702:	c9                   	leave  
80105703:	c3                   	ret    

80105704 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105707:	8b 45 08             	mov    0x8(%ebp),%eax
8010570a:	8b 00                	mov    (%eax),%eax
8010570c:	85 c0                	test   %eax,%eax
8010570e:	74 17                	je     80105727 <holding+0x23>
80105710:	8b 45 08             	mov    0x8(%ebp),%eax
80105713:	8b 50 08             	mov    0x8(%eax),%edx
80105716:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010571c:	39 c2                	cmp    %eax,%edx
8010571e:	75 07                	jne    80105727 <holding+0x23>
80105720:	b8 01 00 00 00       	mov    $0x1,%eax
80105725:	eb 05                	jmp    8010572c <holding+0x28>
80105727:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010572c:	5d                   	pop    %ebp
8010572d:	c3                   	ret    

8010572e <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010572e:	55                   	push   %ebp
8010572f:	89 e5                	mov    %esp,%ebp
80105731:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80105734:	e8 3c fe ff ff       	call   80105575 <readeflags>
80105739:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
8010573c:	e8 49 fe ff ff       	call   8010558a <cli>
  if(cpu->ncli++ == 0)
80105741:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105747:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010574d:	85 d2                	test   %edx,%edx
8010574f:	0f 94 c1             	sete   %cl
80105752:	42                   	inc    %edx
80105753:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80105759:	84 c9                	test   %cl,%cl
8010575b:	74 15                	je     80105772 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
8010575d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105763:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105766:	81 e2 00 02 00 00    	and    $0x200,%edx
8010576c:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105772:	c9                   	leave  
80105773:	c3                   	ret    

80105774 <popcli>:

void
popcli(void)
{
80105774:	55                   	push   %ebp
80105775:	89 e5                	mov    %esp,%ebp
80105777:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010577a:	e8 f6 fd ff ff       	call   80105575 <readeflags>
8010577f:	25 00 02 00 00       	and    $0x200,%eax
80105784:	85 c0                	test   %eax,%eax
80105786:	74 0c                	je     80105794 <popcli+0x20>
    panic("popcli - interruptible");
80105788:	c7 04 24 66 92 10 80 	movl   $0x80109266,(%esp)
8010578f:	e8 a2 ad ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80105794:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010579a:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801057a0:	4a                   	dec    %edx
801057a1:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801057a7:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801057ad:	85 c0                	test   %eax,%eax
801057af:	79 0c                	jns    801057bd <popcli+0x49>
    panic("popcli");
801057b1:	c7 04 24 7d 92 10 80 	movl   $0x8010927d,(%esp)
801057b8:	e8 79 ad ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
801057bd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057c3:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801057c9:	85 c0                	test   %eax,%eax
801057cb:	75 15                	jne    801057e2 <popcli+0x6e>
801057cd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801057d3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801057d9:	85 c0                	test   %eax,%eax
801057db:	74 05                	je     801057e2 <popcli+0x6e>
    sti();
801057dd:	e8 ae fd ff ff       	call   80105590 <sti>
}
801057e2:	c9                   	leave  
801057e3:	c3                   	ret    

801057e4 <stosb>:
{
801057e4:	55                   	push   %ebp
801057e5:	89 e5                	mov    %esp,%ebp
801057e7:	57                   	push   %edi
801057e8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801057e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801057ec:	8b 55 10             	mov    0x10(%ebp),%edx
801057ef:	8b 45 0c             	mov    0xc(%ebp),%eax
801057f2:	89 cb                	mov    %ecx,%ebx
801057f4:	89 df                	mov    %ebx,%edi
801057f6:	89 d1                	mov    %edx,%ecx
801057f8:	fc                   	cld    
801057f9:	f3 aa                	rep stos %al,%es:(%edi)
801057fb:	89 ca                	mov    %ecx,%edx
801057fd:	89 fb                	mov    %edi,%ebx
801057ff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105802:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105805:	5b                   	pop    %ebx
80105806:	5f                   	pop    %edi
80105807:	5d                   	pop    %ebp
80105808:	c3                   	ret    

80105809 <stosl>:
{
80105809:	55                   	push   %ebp
8010580a:	89 e5                	mov    %esp,%ebp
8010580c:	57                   	push   %edi
8010580d:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010580e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105811:	8b 55 10             	mov    0x10(%ebp),%edx
80105814:	8b 45 0c             	mov    0xc(%ebp),%eax
80105817:	89 cb                	mov    %ecx,%ebx
80105819:	89 df                	mov    %ebx,%edi
8010581b:	89 d1                	mov    %edx,%ecx
8010581d:	fc                   	cld    
8010581e:	f3 ab                	rep stos %eax,%es:(%edi)
80105820:	89 ca                	mov    %ecx,%edx
80105822:	89 fb                	mov    %edi,%ebx
80105824:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105827:	89 55 10             	mov    %edx,0x10(%ebp)
}
8010582a:	5b                   	pop    %ebx
8010582b:	5f                   	pop    %edi
8010582c:	5d                   	pop    %ebp
8010582d:	c3                   	ret    

8010582e <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010582e:	55                   	push   %ebp
8010582f:	89 e5                	mov    %esp,%ebp
80105831:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80105834:	8b 45 08             	mov    0x8(%ebp),%eax
80105837:	83 e0 03             	and    $0x3,%eax
8010583a:	85 c0                	test   %eax,%eax
8010583c:	75 49                	jne    80105887 <memset+0x59>
8010583e:	8b 45 10             	mov    0x10(%ebp),%eax
80105841:	83 e0 03             	and    $0x3,%eax
80105844:	85 c0                	test   %eax,%eax
80105846:	75 3f                	jne    80105887 <memset+0x59>
    c &= 0xFF;
80105848:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010584f:	8b 45 10             	mov    0x10(%ebp),%eax
80105852:	c1 e8 02             	shr    $0x2,%eax
80105855:	89 c2                	mov    %eax,%edx
80105857:	8b 45 0c             	mov    0xc(%ebp),%eax
8010585a:	89 c1                	mov    %eax,%ecx
8010585c:	c1 e1 18             	shl    $0x18,%ecx
8010585f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105862:	c1 e0 10             	shl    $0x10,%eax
80105865:	09 c1                	or     %eax,%ecx
80105867:	8b 45 0c             	mov    0xc(%ebp),%eax
8010586a:	c1 e0 08             	shl    $0x8,%eax
8010586d:	09 c8                	or     %ecx,%eax
8010586f:	0b 45 0c             	or     0xc(%ebp),%eax
80105872:	89 54 24 08          	mov    %edx,0x8(%esp)
80105876:	89 44 24 04          	mov    %eax,0x4(%esp)
8010587a:	8b 45 08             	mov    0x8(%ebp),%eax
8010587d:	89 04 24             	mov    %eax,(%esp)
80105880:	e8 84 ff ff ff       	call   80105809 <stosl>
80105885:	eb 19                	jmp    801058a0 <memset+0x72>
  } else
    stosb(dst, c, n);
80105887:	8b 45 10             	mov    0x10(%ebp),%eax
8010588a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010588e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105891:	89 44 24 04          	mov    %eax,0x4(%esp)
80105895:	8b 45 08             	mov    0x8(%ebp),%eax
80105898:	89 04 24             	mov    %eax,(%esp)
8010589b:	e8 44 ff ff ff       	call   801057e4 <stosb>
  return dst;
801058a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
801058a3:	c9                   	leave  
801058a4:	c3                   	ret    

801058a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801058a5:	55                   	push   %ebp
801058a6:	89 e5                	mov    %esp,%ebp
801058a8:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801058ab:	8b 45 08             	mov    0x8(%ebp),%eax
801058ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801058b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801058b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801058b7:	eb 2c                	jmp    801058e5 <memcmp+0x40>
    if(*s1 != *s2)
801058b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058bc:	8a 10                	mov    (%eax),%dl
801058be:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058c1:	8a 00                	mov    (%eax),%al
801058c3:	38 c2                	cmp    %al,%dl
801058c5:	74 18                	je     801058df <memcmp+0x3a>
      return *s1 - *s2;
801058c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801058ca:	8a 00                	mov    (%eax),%al
801058cc:	0f b6 d0             	movzbl %al,%edx
801058cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
801058d2:	8a 00                	mov    (%eax),%al
801058d4:	0f b6 c0             	movzbl %al,%eax
801058d7:	89 d1                	mov    %edx,%ecx
801058d9:	29 c1                	sub    %eax,%ecx
801058db:	89 c8                	mov    %ecx,%eax
801058dd:	eb 19                	jmp    801058f8 <memcmp+0x53>
    s1++, s2++;
801058df:	ff 45 fc             	incl   -0x4(%ebp)
801058e2:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0){
801058e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058e9:	0f 95 c0             	setne  %al
801058ec:	ff 4d 10             	decl   0x10(%ebp)
801058ef:	84 c0                	test   %al,%al
801058f1:	75 c6                	jne    801058b9 <memcmp+0x14>
  }

  return 0;
801058f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801058f8:	c9                   	leave  
801058f9:	c3                   	ret    

801058fa <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801058fa:	55                   	push   %ebp
801058fb:	89 e5                	mov    %esp,%ebp
801058fd:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105900:	8b 45 0c             	mov    0xc(%ebp),%eax
80105903:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105906:	8b 45 08             	mov    0x8(%ebp),%eax
80105909:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
8010590c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010590f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105912:	73 4d                	jae    80105961 <memmove+0x67>
80105914:	8b 45 10             	mov    0x10(%ebp),%eax
80105917:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010591a:	01 d0                	add    %edx,%eax
8010591c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010591f:	76 40                	jbe    80105961 <memmove+0x67>
    s += n;
80105921:	8b 45 10             	mov    0x10(%ebp),%eax
80105924:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105927:	8b 45 10             	mov    0x10(%ebp),%eax
8010592a:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010592d:	eb 10                	jmp    8010593f <memmove+0x45>
      *--d = *--s;
8010592f:	ff 4d f8             	decl   -0x8(%ebp)
80105932:	ff 4d fc             	decl   -0x4(%ebp)
80105935:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105938:	8a 10                	mov    (%eax),%dl
8010593a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010593d:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010593f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105943:	0f 95 c0             	setne  %al
80105946:	ff 4d 10             	decl   0x10(%ebp)
80105949:	84 c0                	test   %al,%al
8010594b:	75 e2                	jne    8010592f <memmove+0x35>
  if(s < d && s + n > d){
8010594d:	eb 21                	jmp    80105970 <memmove+0x76>
  } else
    while(n-- > 0)
      *d++ = *s++;
8010594f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105952:	8a 10                	mov    (%eax),%dl
80105954:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105957:	88 10                	mov    %dl,(%eax)
80105959:	ff 45 f8             	incl   -0x8(%ebp)
8010595c:	ff 45 fc             	incl   -0x4(%ebp)
8010595f:	eb 01                	jmp    80105962 <memmove+0x68>
    while(n-- > 0)
80105961:	90                   	nop
80105962:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105966:	0f 95 c0             	setne  %al
80105969:	ff 4d 10             	decl   0x10(%ebp)
8010596c:	84 c0                	test   %al,%al
8010596e:	75 df                	jne    8010594f <memmove+0x55>

  return dst;
80105970:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105973:	c9                   	leave  
80105974:	c3                   	ret    

80105975 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105975:	55                   	push   %ebp
80105976:	89 e5                	mov    %esp,%ebp
80105978:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010597b:	8b 45 10             	mov    0x10(%ebp),%eax
8010597e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105982:	8b 45 0c             	mov    0xc(%ebp),%eax
80105985:	89 44 24 04          	mov    %eax,0x4(%esp)
80105989:	8b 45 08             	mov    0x8(%ebp),%eax
8010598c:	89 04 24             	mov    %eax,(%esp)
8010598f:	e8 66 ff ff ff       	call   801058fa <memmove>
}
80105994:	c9                   	leave  
80105995:	c3                   	ret    

80105996 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105996:	55                   	push   %ebp
80105997:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105999:	eb 09                	jmp    801059a4 <strncmp+0xe>
    n--, p++, q++;
8010599b:	ff 4d 10             	decl   0x10(%ebp)
8010599e:	ff 45 08             	incl   0x8(%ebp)
801059a1:	ff 45 0c             	incl   0xc(%ebp)
  while(n > 0 && *p && *p == *q)
801059a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059a8:	74 17                	je     801059c1 <strncmp+0x2b>
801059aa:	8b 45 08             	mov    0x8(%ebp),%eax
801059ad:	8a 00                	mov    (%eax),%al
801059af:	84 c0                	test   %al,%al
801059b1:	74 0e                	je     801059c1 <strncmp+0x2b>
801059b3:	8b 45 08             	mov    0x8(%ebp),%eax
801059b6:	8a 10                	mov    (%eax),%dl
801059b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801059bb:	8a 00                	mov    (%eax),%al
801059bd:	38 c2                	cmp    %al,%dl
801059bf:	74 da                	je     8010599b <strncmp+0x5>
  if(n == 0)
801059c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059c5:	75 07                	jne    801059ce <strncmp+0x38>
    return 0;
801059c7:	b8 00 00 00 00       	mov    $0x0,%eax
801059cc:	eb 16                	jmp    801059e4 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
801059ce:	8b 45 08             	mov    0x8(%ebp),%eax
801059d1:	8a 00                	mov    (%eax),%al
801059d3:	0f b6 d0             	movzbl %al,%edx
801059d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801059d9:	8a 00                	mov    (%eax),%al
801059db:	0f b6 c0             	movzbl %al,%eax
801059de:	89 d1                	mov    %edx,%ecx
801059e0:	29 c1                	sub    %eax,%ecx
801059e2:	89 c8                	mov    %ecx,%eax
}
801059e4:	5d                   	pop    %ebp
801059e5:	c3                   	ret    

801059e6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801059e6:	55                   	push   %ebp
801059e7:	89 e5                	mov    %esp,%ebp
801059e9:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801059ec:	8b 45 08             	mov    0x8(%ebp),%eax
801059ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801059f2:	90                   	nop
801059f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801059f7:	0f 9f c0             	setg   %al
801059fa:	ff 4d 10             	decl   0x10(%ebp)
801059fd:	84 c0                	test   %al,%al
801059ff:	74 2b                	je     80105a2c <strncpy+0x46>
80105a01:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a04:	8a 10                	mov    (%eax),%dl
80105a06:	8b 45 08             	mov    0x8(%ebp),%eax
80105a09:	88 10                	mov    %dl,(%eax)
80105a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a0e:	8a 00                	mov    (%eax),%al
80105a10:	84 c0                	test   %al,%al
80105a12:	0f 95 c0             	setne  %al
80105a15:	ff 45 08             	incl   0x8(%ebp)
80105a18:	ff 45 0c             	incl   0xc(%ebp)
80105a1b:	84 c0                	test   %al,%al
80105a1d:	75 d4                	jne    801059f3 <strncpy+0xd>
    ;
  while(n-- > 0)
80105a1f:	eb 0b                	jmp    80105a2c <strncpy+0x46>
    *s++ = 0;
80105a21:	8b 45 08             	mov    0x8(%ebp),%eax
80105a24:	c6 00 00             	movb   $0x0,(%eax)
80105a27:	ff 45 08             	incl   0x8(%ebp)
80105a2a:	eb 01                	jmp    80105a2d <strncpy+0x47>
  while(n-- > 0)
80105a2c:	90                   	nop
80105a2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a31:	0f 9f c0             	setg   %al
80105a34:	ff 4d 10             	decl   0x10(%ebp)
80105a37:	84 c0                	test   %al,%al
80105a39:	75 e6                	jne    80105a21 <strncpy+0x3b>
  return os;
80105a3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    

80105a40 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105a46:	8b 45 08             	mov    0x8(%ebp),%eax
80105a49:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105a4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a50:	7f 05                	jg     80105a57 <safestrcpy+0x17>
    return os;
80105a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a55:	eb 30                	jmp    80105a87 <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80105a57:	ff 4d 10             	decl   0x10(%ebp)
80105a5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105a5e:	7e 1e                	jle    80105a7e <safestrcpy+0x3e>
80105a60:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a63:	8a 10                	mov    (%eax),%dl
80105a65:	8b 45 08             	mov    0x8(%ebp),%eax
80105a68:	88 10                	mov    %dl,(%eax)
80105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6d:	8a 00                	mov    (%eax),%al
80105a6f:	84 c0                	test   %al,%al
80105a71:	0f 95 c0             	setne  %al
80105a74:	ff 45 08             	incl   0x8(%ebp)
80105a77:	ff 45 0c             	incl   0xc(%ebp)
80105a7a:	84 c0                	test   %al,%al
80105a7c:	75 d9                	jne    80105a57 <safestrcpy+0x17>
    ;
  *s = 0;
80105a7e:	8b 45 08             	mov    0x8(%ebp),%eax
80105a81:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105a87:	c9                   	leave  
80105a88:	c3                   	ret    

80105a89 <strlen>:

int
strlen(const char *s)
{
80105a89:	55                   	push   %ebp
80105a8a:	89 e5                	mov    %esp,%ebp
80105a8c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105a8f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105a96:	eb 03                	jmp    80105a9b <strlen+0x12>
80105a98:	ff 45 fc             	incl   -0x4(%ebp)
80105a9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa1:	01 d0                	add    %edx,%eax
80105aa3:	8a 00                	mov    (%eax),%al
80105aa5:	84 c0                	test   %al,%al
80105aa7:	75 ef                	jne    80105a98 <strlen+0xf>
    ;
  return n;
80105aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105aac:	c9                   	leave  
80105aad:	c3                   	ret    

80105aae <swtch>:
80105aae:	8b 44 24 04          	mov    0x4(%esp),%eax
80105ab2:	8b 54 24 08          	mov    0x8(%esp),%edx
80105ab6:	55                   	push   %ebp
80105ab7:	53                   	push   %ebx
80105ab8:	56                   	push   %esi
80105ab9:	57                   	push   %edi
80105aba:	89 20                	mov    %esp,(%eax)
80105abc:	89 d4                	mov    %edx,%esp
80105abe:	5f                   	pop    %edi
80105abf:	5e                   	pop    %esi
80105ac0:	5b                   	pop    %ebx
80105ac1:	5d                   	pop    %ebp
80105ac2:	c3                   	ret    

80105ac3 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105ac3:	55                   	push   %ebp
80105ac4:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80105ac6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105acc:	8b 00                	mov    (%eax),%eax
80105ace:	3b 45 08             	cmp    0x8(%ebp),%eax
80105ad1:	76 12                	jbe    80105ae5 <fetchint+0x22>
80105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad6:	8d 50 04             	lea    0x4(%eax),%edx
80105ad9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105adf:	8b 00                	mov    (%eax),%eax
80105ae1:	39 c2                	cmp    %eax,%edx
80105ae3:	76 07                	jbe    80105aec <fetchint+0x29>
    return -1;
80105ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aea:	eb 0f                	jmp    80105afb <fetchint+0x38>
  *ip = *(int*)(addr);
80105aec:	8b 45 08             	mov    0x8(%ebp),%eax
80105aef:	8b 10                	mov    (%eax),%edx
80105af1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105af4:	89 10                	mov    %edx,(%eax)
  return 0;
80105af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105afb:	5d                   	pop    %ebp
80105afc:	c3                   	ret    

80105afd <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105afd:	55                   	push   %ebp
80105afe:	89 e5                	mov    %esp,%ebp
80105b00:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105b03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b09:	8b 00                	mov    (%eax),%eax
80105b0b:	3b 45 08             	cmp    0x8(%ebp),%eax
80105b0e:	77 07                	ja     80105b17 <fetchstr+0x1a>
    return -1;
80105b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b15:	eb 46                	jmp    80105b5d <fetchstr+0x60>
  *pp = (char*)addr;
80105b17:	8b 55 08             	mov    0x8(%ebp),%edx
80105b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b1d:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105b1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b25:	8b 00                	mov    (%eax),%eax
80105b27:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b2d:	8b 00                	mov    (%eax),%eax
80105b2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105b32:	eb 1c                	jmp    80105b50 <fetchstr+0x53>
    if(*s == 0)
80105b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b37:	8a 00                	mov    (%eax),%al
80105b39:	84 c0                	test   %al,%al
80105b3b:	75 10                	jne    80105b4d <fetchstr+0x50>
      return s - *pp;
80105b3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105b40:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b43:	8b 00                	mov    (%eax),%eax
80105b45:	89 d1                	mov    %edx,%ecx
80105b47:	29 c1                	sub    %eax,%ecx
80105b49:	89 c8                	mov    %ecx,%eax
80105b4b:	eb 10                	jmp    80105b5d <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
80105b4d:	ff 45 fc             	incl   -0x4(%ebp)
80105b50:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105b56:	72 dc                	jb     80105b34 <fetchstr+0x37>
  return -1;
80105b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b5d:	c9                   	leave  
80105b5e:	c3                   	ret    

80105b5f <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105b5f:	55                   	push   %ebp
80105b60:	89 e5                	mov    %esp,%ebp
80105b62:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105b65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b6b:	8b 40 18             	mov    0x18(%eax),%eax
80105b6e:	8b 50 44             	mov    0x44(%eax),%edx
80105b71:	8b 45 08             	mov    0x8(%ebp),%eax
80105b74:	c1 e0 02             	shl    $0x2,%eax
80105b77:	01 d0                	add    %edx,%eax
80105b79:	8d 50 04             	lea    0x4(%eax),%edx
80105b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b83:	89 14 24             	mov    %edx,(%esp)
80105b86:	e8 38 ff ff ff       	call   80105ac3 <fetchint>
}
80105b8b:	c9                   	leave  
80105b8c:	c3                   	ret    

80105b8d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105b8d:	55                   	push   %ebp
80105b8e:	89 e5                	mov    %esp,%ebp
80105b90:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105b93:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b9a:	8b 45 08             	mov    0x8(%ebp),%eax
80105b9d:	89 04 24             	mov    %eax,(%esp)
80105ba0:	e8 ba ff ff ff       	call   80105b5f <argint>
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	79 07                	jns    80105bb0 <argptr+0x23>
    return -1;
80105ba9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bae:	eb 3d                	jmp    80105bed <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bb3:	89 c2                	mov    %eax,%edx
80105bb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbb:	8b 00                	mov    (%eax),%eax
80105bbd:	39 c2                	cmp    %eax,%edx
80105bbf:	73 16                	jae    80105bd7 <argptr+0x4a>
80105bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105bc4:	89 c2                	mov    %eax,%edx
80105bc6:	8b 45 10             	mov    0x10(%ebp),%eax
80105bc9:	01 c2                	add    %eax,%edx
80105bcb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bd1:	8b 00                	mov    (%eax),%eax
80105bd3:	39 c2                	cmp    %eax,%edx
80105bd5:	76 07                	jbe    80105bde <argptr+0x51>
    return -1;
80105bd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bdc:	eb 0f                	jmp    80105bed <argptr+0x60>
  *pp = (char*)i;
80105bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105be1:	89 c2                	mov    %eax,%edx
80105be3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105be6:	89 10                	mov    %edx,(%eax)
  return 0;
80105be8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105bed:	c9                   	leave  
80105bee:	c3                   	ret    

80105bef <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105bef:	55                   	push   %ebp
80105bf0:	89 e5                	mov    %esp,%ebp
80105bf2:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105bf5:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80105bff:	89 04 24             	mov    %eax,(%esp)
80105c02:	e8 58 ff ff ff       	call   80105b5f <argint>
80105c07:	85 c0                	test   %eax,%eax
80105c09:	79 07                	jns    80105c12 <argstr+0x23>
    return -1;
80105c0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c10:	eb 12                	jmp    80105c24 <argstr+0x35>
  return fetchstr(addr, pp);
80105c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c15:	8b 55 0c             	mov    0xc(%ebp),%edx
80105c18:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c1c:	89 04 24             	mov    %eax,(%esp)
80105c1f:	e8 d9 fe ff ff       	call   80105afd <fetchstr>
}
80105c24:	c9                   	leave  
80105c25:	c3                   	ret    

80105c26 <syscall>:
[SYS_shm_get] sys_shm_get, // New: Add in project final
};

void
syscall(void)
{
80105c26:	55                   	push   %ebp
80105c27:	89 e5                	mov    %esp,%ebp
80105c29:	53                   	push   %ebx
80105c2a:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105c2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c33:	8b 40 18             	mov    0x18(%eax),%eax
80105c36:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105c3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c40:	7e 30                	jle    80105c72 <syscall+0x4c>
80105c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c45:	83 f8 20             	cmp    $0x20,%eax
80105c48:	77 28                	ja     80105c72 <syscall+0x4c>
80105c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c4d:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c54:	85 c0                	test   %eax,%eax
80105c56:	74 1a                	je     80105c72 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105c58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c5e:	8b 58 18             	mov    0x18(%eax),%ebx
80105c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c64:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105c6b:	ff d0                	call   *%eax
80105c6d:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105c70:	eb 3d                	jmp    80105caf <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105c72:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c78:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105c7b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105c81:	8b 40 10             	mov    0x10(%eax),%eax
80105c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c87:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105c8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c93:	c7 04 24 84 92 10 80 	movl   $0x80109284,(%esp)
80105c9a:	e8 02 a7 ff ff       	call   801003a1 <cprintf>
    proc->tf->eax = -1;
80105c9f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ca5:	8b 40 18             	mov    0x18(%eax),%eax
80105ca8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105caf:	83 c4 24             	add    $0x24,%esp
80105cb2:	5b                   	pop    %ebx
80105cb3:	5d                   	pop    %ebp
80105cb4:	c3                   	ret    

80105cb5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105cb5:	55                   	push   %ebp
80105cb6:	89 e5                	mov    %esp,%ebp
80105cb8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105cbb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80105cc5:	89 04 24             	mov    %eax,(%esp)
80105cc8:	e8 92 fe ff ff       	call   80105b5f <argint>
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	79 07                	jns    80105cd8 <argfd+0x23>
    return -1;
80105cd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd6:	eb 50                	jmp    80105d28 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cdb:	85 c0                	test   %eax,%eax
80105cdd:	78 21                	js     80105d00 <argfd+0x4b>
80105cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ce2:	83 f8 0f             	cmp    $0xf,%eax
80105ce5:	7f 19                	jg     80105d00 <argfd+0x4b>
80105ce7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ced:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cf0:	83 c2 08             	add    $0x8,%edx
80105cf3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cfe:	75 07                	jne    80105d07 <argfd+0x52>
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d05:	eb 21                	jmp    80105d28 <argfd+0x73>
  if(pfd)
80105d07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d0b:	74 08                	je     80105d15 <argfd+0x60>
    *pfd = fd;
80105d0d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d10:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d13:	89 10                	mov    %edx,(%eax)
  if(pf)
80105d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105d19:	74 08                	je     80105d23 <argfd+0x6e>
    *pf = f;
80105d1b:	8b 45 10             	mov    0x10(%ebp),%eax
80105d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d21:	89 10                	mov    %edx,(%eax)
  return 0;
80105d23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d28:	c9                   	leave  
80105d29:	c3                   	ret    

80105d2a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105d2a:	55                   	push   %ebp
80105d2b:	89 e5                	mov    %esp,%ebp
80105d2d:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105d37:	eb 2f                	jmp    80105d68 <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105d39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d42:	83 c2 08             	add    $0x8,%edx
80105d45:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105d49:	85 c0                	test   %eax,%eax
80105d4b:	75 18                	jne    80105d65 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105d4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105d53:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105d56:	8d 4a 08             	lea    0x8(%edx),%ecx
80105d59:	8b 55 08             	mov    0x8(%ebp),%edx
80105d5c:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105d63:	eb 0e                	jmp    80105d73 <fdalloc+0x49>
  for(fd = 0; fd < NOFILE; fd++){
80105d65:	ff 45 fc             	incl   -0x4(%ebp)
80105d68:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105d6c:	7e cb                	jle    80105d39 <fdalloc+0xf>
    }
  }
  return -1;
80105d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d73:	c9                   	leave  
80105d74:	c3                   	ret    

80105d75 <sys_dup>:

int
sys_dup(void)
{
80105d75:	55                   	push   %ebp
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105d7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d82:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d89:	00 
80105d8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d91:	e8 1f ff ff ff       	call   80105cb5 <argfd>
80105d96:	85 c0                	test   %eax,%eax
80105d98:	79 07                	jns    80105da1 <sys_dup+0x2c>
    return -1;
80105d9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d9f:	eb 29                	jmp    80105dca <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da4:	89 04 24             	mov    %eax,(%esp)
80105da7:	e8 7e ff ff ff       	call   80105d2a <fdalloc>
80105dac:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105db3:	79 07                	jns    80105dbc <sys_dup+0x47>
    return -1;
80105db5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dba:	eb 0e                	jmp    80105dca <sys_dup+0x55>
  filedup(f);
80105dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbf:	89 04 24             	mov    %eax,(%esp)
80105dc2:	e8 8c b1 ff ff       	call   80100f53 <filedup>
  return fd;
80105dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105dca:	c9                   	leave  
80105dcb:	c3                   	ret    

80105dcc <sys_read>:

int
sys_read(void)
{
80105dcc:	55                   	push   %ebp
80105dcd:	89 e5                	mov    %esp,%ebp
80105dcf:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dd5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dd9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105de0:	00 
80105de1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105de8:	e8 c8 fe ff ff       	call   80105cb5 <argfd>
80105ded:	85 c0                	test   %eax,%eax
80105def:	78 35                	js     80105e26 <sys_read+0x5a>
80105df1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105df8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105dff:	e8 5b fd ff ff       	call   80105b5f <argint>
80105e04:	85 c0                	test   %eax,%eax
80105e06:	78 1e                	js     80105e26 <sys_read+0x5a>
80105e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e0f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e12:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e1d:	e8 6b fd ff ff       	call   80105b8d <argptr>
80105e22:	85 c0                	test   %eax,%eax
80105e24:	79 07                	jns    80105e2d <sys_read+0x61>
    return -1;
80105e26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e2b:	eb 19                	jmp    80105e46 <sys_read+0x7a>
  return fileread(f, p, n);
80105e2d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105e30:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105e3a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e3e:	89 04 24             	mov    %eax,(%esp)
80105e41:	e8 6e b2 ff ff       	call   801010b4 <fileread>
}
80105e46:	c9                   	leave  
80105e47:	c3                   	ret    

80105e48 <sys_write>:

int
sys_write(void)
{
80105e48:	55                   	push   %ebp
80105e49:	89 e5                	mov    %esp,%ebp
80105e4b:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105e4e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e51:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e55:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e5c:	00 
80105e5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e64:	e8 4c fe ff ff       	call   80105cb5 <argfd>
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	78 35                	js     80105ea2 <sys_write+0x5a>
80105e6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e74:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105e7b:	e8 df fc ff ff       	call   80105b5f <argint>
80105e80:	85 c0                	test   %eax,%eax
80105e82:	78 1e                	js     80105ea2 <sys_write+0x5a>
80105e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e87:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e92:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e99:	e8 ef fc ff ff       	call   80105b8d <argptr>
80105e9e:	85 c0                	test   %eax,%eax
80105ea0:	79 07                	jns    80105ea9 <sys_write+0x61>
    return -1;
80105ea2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ea7:	eb 19                	jmp    80105ec2 <sys_write+0x7a>
  return filewrite(f, p, n);
80105ea9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105eac:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eb2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105eb6:	89 54 24 04          	mov    %edx,0x4(%esp)
80105eba:	89 04 24             	mov    %eax,(%esp)
80105ebd:	e8 ad b2 ff ff       	call   8010116f <filewrite>
}
80105ec2:	c9                   	leave  
80105ec3:	c3                   	ret    

80105ec4 <sys_isatty>:

// Minimalish implementation of isatty for xv6. Maybe it will even work, but 
// hopefully it will be sufficient for now.
int sys_isatty(void) {
80105ec4:	55                   	push   %ebp
80105ec5:	89 e5                	mov    %esp,%ebp
80105ec7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  argfd(0, &fd, &f);
80105eca:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ecd:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ed8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105edf:	e8 d1 fd ff ff       	call   80105cb5 <argfd>
  if (f->type == FD_INODE) {
80105ee4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee7:	8b 00                	mov    (%eax),%eax
80105ee9:	83 f8 02             	cmp    $0x2,%eax
80105eec:	75 20                	jne    80105f0e <sys_isatty+0x4a>
    /* This is bad and wrong, but currently works. Either when more 
     * sophisticated terminal handling comes, or more devices, or both, this
     * will need to distinguish different device types. Still, it's a start. */
    if (f->ip != 0 && f->ip->type == T_DEV)
80105eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef1:	8b 40 10             	mov    0x10(%eax),%eax
80105ef4:	85 c0                	test   %eax,%eax
80105ef6:	74 16                	je     80105f0e <sys_isatty+0x4a>
80105ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105efb:	8b 40 10             	mov    0x10(%eax),%eax
80105efe:	8b 40 10             	mov    0x10(%eax),%eax
80105f01:	66 83 f8 03          	cmp    $0x3,%ax
80105f05:	75 07                	jne    80105f0e <sys_isatty+0x4a>
      return 1;
80105f07:	b8 01 00 00 00       	mov    $0x1,%eax
80105f0c:	eb 05                	jmp    80105f13 <sys_isatty+0x4f>
  }
  return 0;
80105f0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105f13:	c9                   	leave  
80105f14:	c3                   	ret    

80105f15 <sys_lseek>:

// lseek derived from https://github.com/hxp/xv6, written by Joel Heikkila

int sys_lseek(void) {
80105f15:	55                   	push   %ebp
80105f16:	89 e5                	mov    %esp,%ebp
80105f18:	83 ec 48             	sub    $0x48,%esp
	int zerosize, i;
	char *zeroed, *z;

	struct file *f;

	argfd(0, &fd, &f);
80105f1b:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105f1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f22:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f25:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f30:	e8 80 fd ff ff       	call   80105cb5 <argfd>
	argint(1, &offset);
80105f35:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105f38:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f3c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f43:	e8 17 fc ff ff       	call   80105b5f <argint>
	argint(2, &base);
80105f48:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f4f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105f56:	e8 04 fc ff ff       	call   80105b5f <argint>

	if( base == SEEK_SET) {
80105f5b:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f5e:	85 c0                	test   %eax,%eax
80105f60:	75 06                	jne    80105f68 <sys_lseek+0x53>
		newoff = offset;
80105f62:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	if (base == SEEK_CUR)
80105f68:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f6b:	83 f8 01             	cmp    $0x1,%eax
80105f6e:	75 0e                	jne    80105f7e <sys_lseek+0x69>
		newoff = f->off + offset;
80105f70:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f73:	8b 50 14             	mov    0x14(%eax),%edx
80105f76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f79:	01 d0                	add    %edx,%eax
80105f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (base == SEEK_END)
80105f7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105f81:	83 f8 02             	cmp    $0x2,%eax
80105f84:	75 11                	jne    80105f97 <sys_lseek+0x82>
		newoff = f->ip->size + offset;
80105f86:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f89:	8b 40 10             	mov    0x10(%eax),%eax
80105f8c:	8b 50 18             	mov    0x18(%eax),%edx
80105f8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f92:	01 d0                	add    %edx,%eax
80105f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (newoff < f->ip->size)
80105f97:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f9a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105f9d:	8b 40 10             	mov    0x10(%eax),%eax
80105fa0:	8b 40 18             	mov    0x18(%eax),%eax
80105fa3:	39 c2                	cmp    %eax,%edx
80105fa5:	73 0a                	jae    80105fb1 <sys_lseek+0x9c>
		return -1;
80105fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fac:	e9 92 00 00 00       	jmp    80106043 <sys_lseek+0x12e>

	if (newoff > f->ip->size){
80105fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105fb7:	8b 40 10             	mov    0x10(%eax),%eax
80105fba:	8b 40 18             	mov    0x18(%eax),%eax
80105fbd:	39 c2                	cmp    %eax,%edx
80105fbf:	76 74                	jbe    80106035 <sys_lseek+0x120>
		zerosize = newoff - f->ip->size;
80105fc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105fc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105fc7:	8b 40 10             	mov    0x10(%eax),%eax
80105fca:	8b 40 18             	mov    0x18(%eax),%eax
80105fcd:	89 d1                	mov    %edx,%ecx
80105fcf:	29 c1                	sub    %eax,%ecx
80105fd1:	89 c8                	mov    %ecx,%eax
80105fd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		zeroed = kalloc();
80105fd6:	e8 e3 ca ff ff       	call   80102abe <kalloc>
80105fdb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = zeroed;
80105fde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fe1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		for (i = 0; i < 4096; i++)
80105fe4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105feb:	eb 0c                	jmp    80105ff9 <sys_lseek+0xe4>
			*z++ = 0;
80105fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ff0:	c6 00 00             	movb   $0x0,(%eax)
80105ff3:	ff 45 e8             	incl   -0x18(%ebp)
		for (i = 0; i < 4096; i++)
80105ff6:	ff 45 ec             	incl   -0x14(%ebp)
80105ff9:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80106000:	7e eb                	jle    80105fed <sys_lseek+0xd8>
		while (zerosize > 0){
80106002:	eb 20                	jmp    80106024 <sys_lseek+0x10f>
			filewrite(f, zeroed, zerosize);
80106004:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106007:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010600a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010600e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106011:	89 54 24 04          	mov    %edx,0x4(%esp)
80106015:	89 04 24             	mov    %eax,(%esp)
80106018:	e8 52 b1 ff ff       	call   8010116f <filewrite>
			zerosize -= 4096;
8010601d:	81 6d f0 00 10 00 00 	subl   $0x1000,-0x10(%ebp)
		while (zerosize > 0){
80106024:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106028:	7f da                	jg     80106004 <sys_lseek+0xef>
		}
		kfree(zeroed);
8010602a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010602d:	89 04 24             	mov    %eax,(%esp)
80106030:	e8 f0 c9 ff ff       	call   80102a25 <kfree>
	}

	f->off = newoff;
80106035:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106038:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010603b:	89 50 14             	mov    %edx,0x14(%eax)
	return 0;
8010603e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106043:	c9                   	leave  
80106044:	c3                   	ret    

80106045 <sys_close>:

int
sys_close(void)
{
80106045:	55                   	push   %ebp
80106046:	89 e5                	mov    %esp,%ebp
80106048:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010604b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010604e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106052:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106055:	89 44 24 04          	mov    %eax,0x4(%esp)
80106059:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106060:	e8 50 fc ff ff       	call   80105cb5 <argfd>
80106065:	85 c0                	test   %eax,%eax
80106067:	79 07                	jns    80106070 <sys_close+0x2b>
    return -1;
80106069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010606e:	eb 24                	jmp    80106094 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80106070:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106076:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106079:	83 c2 08             	add    $0x8,%edx
8010607c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106083:	00 
  fileclose(f);
80106084:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106087:	89 04 24             	mov    %eax,(%esp)
8010608a:	e8 0c af ff ff       	call   80100f9b <fileclose>
  return 0;
8010608f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106094:	c9                   	leave  
80106095:	c3                   	ret    

80106096 <sys_fstat>:

int
sys_fstat(void)
{
80106096:	55                   	push   %ebp
80106097:	89 e5                	mov    %esp,%ebp
80106099:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010609c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010609f:	89 44 24 08          	mov    %eax,0x8(%esp)
801060a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801060aa:	00 
801060ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060b2:	e8 fe fb ff ff       	call   80105cb5 <argfd>
801060b7:	85 c0                	test   %eax,%eax
801060b9:	78 1f                	js     801060da <sys_fstat+0x44>
801060bb:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801060c2:	00 
801060c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801060ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801060d1:	e8 b7 fa ff ff       	call   80105b8d <argptr>
801060d6:	85 c0                	test   %eax,%eax
801060d8:	79 07                	jns    801060e1 <sys_fstat+0x4b>
    return -1;
801060da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060df:	eb 12                	jmp    801060f3 <sys_fstat+0x5d>
  return filestat(f, st);
801060e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801060e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801060eb:	89 04 24             	mov    %eax,(%esp)
801060ee:	e8 72 af ff ff       	call   80101065 <filestat>
}
801060f3:	c9                   	leave  
801060f4:	c3                   	ret    

801060f5 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801060f5:	55                   	push   %ebp
801060f6:	89 e5                	mov    %esp,%ebp
801060f8:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801060fb:	8d 45 d8             	lea    -0x28(%ebp),%eax
801060fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80106102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106109:	e8 e1 fa ff ff       	call   80105bef <argstr>
8010610e:	85 c0                	test   %eax,%eax
80106110:	78 17                	js     80106129 <sys_link+0x34>
80106112:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106115:	89 44 24 04          	mov    %eax,0x4(%esp)
80106119:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106120:	e8 ca fa ff ff       	call   80105bef <argstr>
80106125:	85 c0                	test   %eax,%eax
80106127:	79 0a                	jns    80106133 <sys_link+0x3e>
    return -1;
80106129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612e:	e9 37 01 00 00       	jmp    8010626a <sys_link+0x175>
  if((ip = namei(old)) == 0)
80106133:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106136:	89 04 24             	mov    %eax,(%esp)
80106139:	e8 a1 c2 ff ff       	call   801023df <namei>
8010613e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106141:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106145:	75 0a                	jne    80106151 <sys_link+0x5c>
    return -1;
80106147:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010614c:	e9 19 01 00 00       	jmp    8010626a <sys_link+0x175>

  begin_trans();
80106151:	e8 7a d0 ff ff       	call   801031d0 <begin_trans>

  ilock(ip);
80106156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106159:	89 04 24             	mov    %eax,(%esp)
8010615c:	e8 e4 b6 ff ff       	call   80101845 <ilock>
  if(ip->type == T_DIR){
80106161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106164:	8b 40 10             	mov    0x10(%eax),%eax
80106167:	66 83 f8 01          	cmp    $0x1,%ax
8010616b:	75 1a                	jne    80106187 <sys_link+0x92>
    iunlockput(ip);
8010616d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106170:	89 04 24             	mov    %eax,(%esp)
80106173:	e8 4e b9 ff ff       	call   80101ac6 <iunlockput>
    commit_trans();
80106178:	e8 9c d0 ff ff       	call   80103219 <commit_trans>
    return -1;
8010617d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106182:	e9 e3 00 00 00       	jmp    8010626a <sys_link+0x175>
  }

  ip->nlink++;
80106187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618a:	66 8b 40 16          	mov    0x16(%eax),%ax
8010618e:	40                   	inc    %eax
8010618f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106192:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80106196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106199:	89 04 24             	mov    %eax,(%esp)
8010619c:	e8 ea b4 ff ff       	call   8010168b <iupdate>
  iunlock(ip);
801061a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a4:	89 04 24             	mov    %eax,(%esp)
801061a7:	e8 e4 b7 ff ff       	call   80101990 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
801061ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
801061af:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801061b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801061b6:	89 04 24             	mov    %eax,(%esp)
801061b9:	e8 43 c2 ff ff       	call   80102401 <nameiparent>
801061be:	89 45 f0             	mov    %eax,-0x10(%ebp)
801061c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801061c5:	74 68                	je     8010622f <sys_link+0x13a>
    goto bad;
  ilock(dp);
801061c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ca:	89 04 24             	mov    %eax,(%esp)
801061cd:	e8 73 b6 ff ff       	call   80101845 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801061d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061d5:	8b 10                	mov    (%eax),%edx
801061d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061da:	8b 00                	mov    (%eax),%eax
801061dc:	39 c2                	cmp    %eax,%edx
801061de:	75 20                	jne    80106200 <sys_link+0x10b>
801061e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e3:	8b 40 04             	mov    0x4(%eax),%eax
801061e6:	89 44 24 08          	mov    %eax,0x8(%esp)
801061ea:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801061ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061f4:	89 04 24             	mov    %eax,(%esp)
801061f7:	e8 2c bf ff ff       	call   80102128 <dirlink>
801061fc:	85 c0                	test   %eax,%eax
801061fe:	79 0d                	jns    8010620d <sys_link+0x118>
    iunlockput(dp);
80106200:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106203:	89 04 24             	mov    %eax,(%esp)
80106206:	e8 bb b8 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
8010620b:	eb 23                	jmp    80106230 <sys_link+0x13b>
  }
  iunlockput(dp);
8010620d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106210:	89 04 24             	mov    %eax,(%esp)
80106213:	e8 ae b8 ff ff       	call   80101ac6 <iunlockput>
  iput(ip);
80106218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010621b:	89 04 24             	mov    %eax,(%esp)
8010621e:	e8 d2 b7 ff ff       	call   801019f5 <iput>

  commit_trans();
80106223:	e8 f1 cf ff ff       	call   80103219 <commit_trans>

  return 0;
80106228:	b8 00 00 00 00       	mov    $0x0,%eax
8010622d:	eb 3b                	jmp    8010626a <sys_link+0x175>
    goto bad;
8010622f:	90                   	nop

bad:
  ilock(ip);
80106230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106233:	89 04 24             	mov    %eax,(%esp)
80106236:	e8 0a b6 ff ff       	call   80101845 <ilock>
  ip->nlink--;
8010623b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010623e:	66 8b 40 16          	mov    0x16(%eax),%ax
80106242:	48                   	dec    %eax
80106243:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106246:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010624a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010624d:	89 04 24             	mov    %eax,(%esp)
80106250:	e8 36 b4 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80106255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106258:	89 04 24             	mov    %eax,(%esp)
8010625b:	e8 66 b8 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80106260:	e8 b4 cf ff ff       	call   80103219 <commit_trans>
  return -1;
80106265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010626a:	c9                   	leave  
8010626b:	c3                   	ret    

8010626c <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010626c:	55                   	push   %ebp
8010626d:	89 e5                	mov    %esp,%ebp
8010626f:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106272:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106279:	eb 4a                	jmp    801062c5 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010627b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010627e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106285:	00 
80106286:	89 44 24 08          	mov    %eax,0x8(%esp)
8010628a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010628d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106291:	8b 45 08             	mov    0x8(%ebp),%eax
80106294:	89 04 24             	mov    %eax,(%esp)
80106297:	e8 b0 ba ff ff       	call   80101d4c <readi>
8010629c:	83 f8 10             	cmp    $0x10,%eax
8010629f:	74 0c                	je     801062ad <isdirempty+0x41>
      panic("isdirempty: readi");
801062a1:	c7 04 24 a0 92 10 80 	movl   $0x801092a0,(%esp)
801062a8:	e8 89 a2 ff ff       	call   80100536 <panic>
    if(de.inum != 0)
801062ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062b0:	66 85 c0             	test   %ax,%ax
801062b3:	74 07                	je     801062bc <isdirempty+0x50>
      return 0;
801062b5:	b8 00 00 00 00       	mov    $0x0,%eax
801062ba:	eb 1b                	jmp    801062d7 <isdirempty+0x6b>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801062bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062bf:	83 c0 10             	add    $0x10,%eax
801062c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062c8:	8b 45 08             	mov    0x8(%ebp),%eax
801062cb:	8b 40 18             	mov    0x18(%eax),%eax
801062ce:	39 c2                	cmp    %eax,%edx
801062d0:	72 a9                	jb     8010627b <isdirempty+0xf>
  }
  return 1;
801062d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
801062d7:	c9                   	leave  
801062d8:	c3                   	ret    

801062d9 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801062d9:	55                   	push   %ebp
801062da:	89 e5                	mov    %esp,%ebp
801062dc:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801062df:	8d 45 cc             	lea    -0x34(%ebp),%eax
801062e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801062e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062ed:	e8 fd f8 ff ff       	call   80105bef <argstr>
801062f2:	85 c0                	test   %eax,%eax
801062f4:	79 0a                	jns    80106300 <sys_unlink+0x27>
    return -1;
801062f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fb:	e9 a4 01 00 00       	jmp    801064a4 <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
80106300:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106303:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106306:	89 54 24 04          	mov    %edx,0x4(%esp)
8010630a:	89 04 24             	mov    %eax,(%esp)
8010630d:	e8 ef c0 ff ff       	call   80102401 <nameiparent>
80106312:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106319:	75 0a                	jne    80106325 <sys_unlink+0x4c>
    return -1;
8010631b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106320:	e9 7f 01 00 00       	jmp    801064a4 <sys_unlink+0x1cb>

  begin_trans();
80106325:	e8 a6 ce ff ff       	call   801031d0 <begin_trans>

  ilock(dp);
8010632a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010632d:	89 04 24             	mov    %eax,(%esp)
80106330:	e8 10 b5 ff ff       	call   80101845 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106335:	c7 44 24 04 b2 92 10 	movl   $0x801092b2,0x4(%esp)
8010633c:	80 
8010633d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106340:	89 04 24             	mov    %eax,(%esp)
80106343:	e8 f9 bc ff ff       	call   80102041 <namecmp>
80106348:	85 c0                	test   %eax,%eax
8010634a:	0f 84 3f 01 00 00    	je     8010648f <sys_unlink+0x1b6>
80106350:	c7 44 24 04 b4 92 10 	movl   $0x801092b4,0x4(%esp)
80106357:	80 
80106358:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010635b:	89 04 24             	mov    %eax,(%esp)
8010635e:	e8 de bc ff ff       	call   80102041 <namecmp>
80106363:	85 c0                	test   %eax,%eax
80106365:	0f 84 24 01 00 00    	je     8010648f <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010636b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010636e:	89 44 24 08          	mov    %eax,0x8(%esp)
80106372:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106375:	89 44 24 04          	mov    %eax,0x4(%esp)
80106379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637c:	89 04 24             	mov    %eax,(%esp)
8010637f:	e8 df bc ff ff       	call   80102063 <dirlookup>
80106384:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106387:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010638b:	0f 84 fd 00 00 00    	je     8010648e <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80106391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106394:	89 04 24             	mov    %eax,(%esp)
80106397:	e8 a9 b4 ff ff       	call   80101845 <ilock>

  if(ip->nlink < 1)
8010639c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010639f:	66 8b 40 16          	mov    0x16(%eax),%ax
801063a3:	66 85 c0             	test   %ax,%ax
801063a6:	7f 0c                	jg     801063b4 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
801063a8:	c7 04 24 b7 92 10 80 	movl   $0x801092b7,(%esp)
801063af:	e8 82 a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801063b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b7:	8b 40 10             	mov    0x10(%eax),%eax
801063ba:	66 83 f8 01          	cmp    $0x1,%ax
801063be:	75 1f                	jne    801063df <sys_unlink+0x106>
801063c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c3:	89 04 24             	mov    %eax,(%esp)
801063c6:	e8 a1 fe ff ff       	call   8010626c <isdirempty>
801063cb:	85 c0                	test   %eax,%eax
801063cd:	75 10                	jne    801063df <sys_unlink+0x106>
    iunlockput(ip);
801063cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d2:	89 04 24             	mov    %eax,(%esp)
801063d5:	e8 ec b6 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
801063da:	e9 b0 00 00 00       	jmp    8010648f <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
801063df:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801063e6:	00 
801063e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801063ee:	00 
801063ef:	8d 45 e0             	lea    -0x20(%ebp),%eax
801063f2:	89 04 24             	mov    %eax,(%esp)
801063f5:	e8 34 f4 ff ff       	call   8010582e <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801063fa:	8b 45 c8             	mov    -0x38(%ebp),%eax
801063fd:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80106404:	00 
80106405:	89 44 24 08          	mov    %eax,0x8(%esp)
80106409:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010640c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106413:	89 04 24             	mov    %eax,(%esp)
80106416:	e8 96 ba ff ff       	call   80101eb1 <writei>
8010641b:	83 f8 10             	cmp    $0x10,%eax
8010641e:	74 0c                	je     8010642c <sys_unlink+0x153>
    panic("unlink: writei");
80106420:	c7 04 24 c9 92 10 80 	movl   $0x801092c9,(%esp)
80106427:	e8 0a a1 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
8010642c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010642f:	8b 40 10             	mov    0x10(%eax),%eax
80106432:	66 83 f8 01          	cmp    $0x1,%ax
80106436:	75 1a                	jne    80106452 <sys_unlink+0x179>
    dp->nlink--;
80106438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010643b:	66 8b 40 16          	mov    0x16(%eax),%ax
8010643f:	48                   	dec    %eax
80106440:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106443:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80106447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644a:	89 04 24             	mov    %eax,(%esp)
8010644d:	e8 39 b2 ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
80106452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106455:	89 04 24             	mov    %eax,(%esp)
80106458:	e8 69 b6 ff ff       	call   80101ac6 <iunlockput>

  ip->nlink--;
8010645d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106460:	66 8b 40 16          	mov    0x16(%eax),%ax
80106464:	48                   	dec    %eax
80106465:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106468:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010646c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010646f:	89 04 24             	mov    %eax,(%esp)
80106472:	e8 14 b2 ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80106477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010647a:	89 04 24             	mov    %eax,(%esp)
8010647d:	e8 44 b6 ff ff       	call   80101ac6 <iunlockput>

  commit_trans();
80106482:	e8 92 cd ff ff       	call   80103219 <commit_trans>

  return 0;
80106487:	b8 00 00 00 00       	mov    $0x0,%eax
8010648c:	eb 16                	jmp    801064a4 <sys_unlink+0x1cb>
    goto bad;
8010648e:	90                   	nop

bad:
  iunlockput(dp);
8010648f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106492:	89 04 24             	mov    %eax,(%esp)
80106495:	e8 2c b6 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010649a:	e8 7a cd ff ff       	call   80103219 <commit_trans>
  return -1;
8010649f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064a4:	c9                   	leave  
801064a5:	c3                   	ret    

801064a6 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801064a6:	55                   	push   %ebp
801064a7:	89 e5                	mov    %esp,%ebp
801064a9:	83 ec 48             	sub    $0x48,%esp
801064ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801064af:	8b 55 10             	mov    0x10(%ebp),%edx
801064b2:	8b 45 14             	mov    0x14(%ebp),%eax
801064b5:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801064b9:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801064bd:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801064c1:	8d 45 de             	lea    -0x22(%ebp),%eax
801064c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801064c8:	8b 45 08             	mov    0x8(%ebp),%eax
801064cb:	89 04 24             	mov    %eax,(%esp)
801064ce:	e8 2e bf ff ff       	call   80102401 <nameiparent>
801064d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064da:	75 0a                	jne    801064e6 <create+0x40>
    return 0;
801064dc:	b8 00 00 00 00       	mov    $0x0,%eax
801064e1:	e9 79 01 00 00       	jmp    8010665f <create+0x1b9>
  ilock(dp);
801064e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e9:	89 04 24             	mov    %eax,(%esp)
801064ec:	e8 54 b3 ff ff       	call   80101845 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801064f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
801064f4:	89 44 24 08          	mov    %eax,0x8(%esp)
801064f8:	8d 45 de             	lea    -0x22(%ebp),%eax
801064fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106502:	89 04 24             	mov    %eax,(%esp)
80106505:	e8 59 bb ff ff       	call   80102063 <dirlookup>
8010650a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010650d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106511:	74 46                	je     80106559 <create+0xb3>
    iunlockput(dp);
80106513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106516:	89 04 24             	mov    %eax,(%esp)
80106519:	e8 a8 b5 ff ff       	call   80101ac6 <iunlockput>
    ilock(ip);
8010651e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106521:	89 04 24             	mov    %eax,(%esp)
80106524:	e8 1c b3 ff ff       	call   80101845 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80106529:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010652e:	75 14                	jne    80106544 <create+0x9e>
80106530:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106533:	8b 40 10             	mov    0x10(%eax),%eax
80106536:	66 83 f8 02          	cmp    $0x2,%ax
8010653a:	75 08                	jne    80106544 <create+0x9e>
      return ip;
8010653c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010653f:	e9 1b 01 00 00       	jmp    8010665f <create+0x1b9>
    iunlockput(ip);
80106544:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106547:	89 04 24             	mov    %eax,(%esp)
8010654a:	e8 77 b5 ff ff       	call   80101ac6 <iunlockput>
    return 0;
8010654f:	b8 00 00 00 00       	mov    $0x0,%eax
80106554:	e9 06 01 00 00       	jmp    8010665f <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106559:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010655d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106560:	8b 00                	mov    (%eax),%eax
80106562:	89 54 24 04          	mov    %edx,0x4(%esp)
80106566:	89 04 24             	mov    %eax,(%esp)
80106569:	e8 35 b0 ff ff       	call   801015a3 <ialloc>
8010656e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106571:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106575:	75 0c                	jne    80106583 <create+0xdd>
    panic("create: ialloc");
80106577:	c7 04 24 d8 92 10 80 	movl   $0x801092d8,(%esp)
8010657e:	e8 b3 9f ff ff       	call   80100536 <panic>

  ilock(ip);
80106583:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106586:	89 04 24             	mov    %eax,(%esp)
80106589:	e8 b7 b2 ff ff       	call   80101845 <ilock>
  ip->major = major;
8010658e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106591:	8b 45 d0             	mov    -0x30(%ebp),%eax
80106594:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80106598:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010659b:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010659e:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
801065a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a5:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801065ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ae:	89 04 24             	mov    %eax,(%esp)
801065b1:	e8 d5 b0 ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801065b6:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801065bb:	75 68                	jne    80106625 <create+0x17f>
    dp->nlink++;  // for ".."
801065bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c0:	66 8b 40 16          	mov    0x16(%eax),%ax
801065c4:	40                   	inc    %eax
801065c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801065c8:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
801065cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065cf:	89 04 24             	mov    %eax,(%esp)
801065d2:	e8 b4 b0 ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801065d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065da:	8b 40 04             	mov    0x4(%eax),%eax
801065dd:	89 44 24 08          	mov    %eax,0x8(%esp)
801065e1:	c7 44 24 04 b2 92 10 	movl   $0x801092b2,0x4(%esp)
801065e8:	80 
801065e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065ec:	89 04 24             	mov    %eax,(%esp)
801065ef:	e8 34 bb ff ff       	call   80102128 <dirlink>
801065f4:	85 c0                	test   %eax,%eax
801065f6:	78 21                	js     80106619 <create+0x173>
801065f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fb:	8b 40 04             	mov    0x4(%eax),%eax
801065fe:	89 44 24 08          	mov    %eax,0x8(%esp)
80106602:	c7 44 24 04 b4 92 10 	movl   $0x801092b4,0x4(%esp)
80106609:	80 
8010660a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010660d:	89 04 24             	mov    %eax,(%esp)
80106610:	e8 13 bb ff ff       	call   80102128 <dirlink>
80106615:	85 c0                	test   %eax,%eax
80106617:	79 0c                	jns    80106625 <create+0x17f>
      panic("create dots");
80106619:	c7 04 24 e7 92 10 80 	movl   $0x801092e7,(%esp)
80106620:	e8 11 9f ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80106625:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106628:	8b 40 04             	mov    0x4(%eax),%eax
8010662b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010662f:	8d 45 de             	lea    -0x22(%ebp),%eax
80106632:	89 44 24 04          	mov    %eax,0x4(%esp)
80106636:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106639:	89 04 24             	mov    %eax,(%esp)
8010663c:	e8 e7 ba ff ff       	call   80102128 <dirlink>
80106641:	85 c0                	test   %eax,%eax
80106643:	79 0c                	jns    80106651 <create+0x1ab>
    panic("create: dirlink");
80106645:	c7 04 24 f3 92 10 80 	movl   $0x801092f3,(%esp)
8010664c:	e8 e5 9e ff ff       	call   80100536 <panic>

  iunlockput(dp);
80106651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106654:	89 04 24             	mov    %eax,(%esp)
80106657:	e8 6a b4 ff ff       	call   80101ac6 <iunlockput>

  return ip;
8010665c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010665f:	c9                   	leave  
80106660:	c3                   	ret    

80106661 <sys_open>:

int
sys_open(void)
{
80106661:	55                   	push   %ebp
80106662:	89 e5                	mov    %esp,%ebp
80106664:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80106667:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010666a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010666e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106675:	e8 75 f5 ff ff       	call   80105bef <argstr>
8010667a:	85 c0                	test   %eax,%eax
8010667c:	78 17                	js     80106695 <sys_open+0x34>
8010667e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106681:	89 44 24 04          	mov    %eax,0x4(%esp)
80106685:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010668c:	e8 ce f4 ff ff       	call   80105b5f <argint>
80106691:	85 c0                	test   %eax,%eax
80106693:	79 0a                	jns    8010669f <sys_open+0x3e>
    return -1;
80106695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010669a:	e9 47 01 00 00       	jmp    801067e6 <sys_open+0x185>
  if(omode & O_CREATE){
8010669f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066a2:	25 00 02 00 00       	and    $0x200,%eax
801066a7:	85 c0                	test   %eax,%eax
801066a9:	74 40                	je     801066eb <sys_open+0x8a>
    begin_trans();
801066ab:	e8 20 cb ff ff       	call   801031d0 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
801066b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801066ba:	00 
801066bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801066c2:	00 
801066c3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
801066ca:	00 
801066cb:	89 04 24             	mov    %eax,(%esp)
801066ce:	e8 d3 fd ff ff       	call   801064a6 <create>
801066d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
801066d6:	e8 3e cb ff ff       	call   80103219 <commit_trans>
    if(ip == 0)
801066db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066df:	75 5b                	jne    8010673c <sys_open+0xdb>
      return -1;
801066e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e6:	e9 fb 00 00 00       	jmp    801067e6 <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
801066eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801066ee:	89 04 24             	mov    %eax,(%esp)
801066f1:	e8 e9 bc ff ff       	call   801023df <namei>
801066f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801066f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066fd:	75 0a                	jne    80106709 <sys_open+0xa8>
      return -1;
801066ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106704:	e9 dd 00 00 00       	jmp    801067e6 <sys_open+0x185>
    ilock(ip);
80106709:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670c:	89 04 24             	mov    %eax,(%esp)
8010670f:	e8 31 b1 ff ff       	call   80101845 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80106714:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106717:	8b 40 10             	mov    0x10(%eax),%eax
8010671a:	66 83 f8 01          	cmp    $0x1,%ax
8010671e:	75 1c                	jne    8010673c <sys_open+0xdb>
80106720:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106723:	85 c0                	test   %eax,%eax
80106725:	74 15                	je     8010673c <sys_open+0xdb>
      iunlockput(ip);
80106727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672a:	89 04 24             	mov    %eax,(%esp)
8010672d:	e8 94 b3 ff ff       	call   80101ac6 <iunlockput>
      return -1;
80106732:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106737:	e9 aa 00 00 00       	jmp    801067e6 <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010673c:	e8 b2 a7 ff ff       	call   80100ef3 <filealloc>
80106741:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106744:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106748:	74 14                	je     8010675e <sys_open+0xfd>
8010674a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010674d:	89 04 24             	mov    %eax,(%esp)
80106750:	e8 d5 f5 ff ff       	call   80105d2a <fdalloc>
80106755:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106758:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010675c:	79 23                	jns    80106781 <sys_open+0x120>
    if(f)
8010675e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106762:	74 0b                	je     8010676f <sys_open+0x10e>
      fileclose(f);
80106764:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106767:	89 04 24             	mov    %eax,(%esp)
8010676a:	e8 2c a8 ff ff       	call   80100f9b <fileclose>
    iunlockput(ip);
8010676f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106772:	89 04 24             	mov    %eax,(%esp)
80106775:	e8 4c b3 ff ff       	call   80101ac6 <iunlockput>
    return -1;
8010677a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010677f:	eb 65                	jmp    801067e6 <sys_open+0x185>
  }
  iunlock(ip);
80106781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106784:	89 04 24             	mov    %eax,(%esp)
80106787:	e8 04 b2 ff ff       	call   80101990 <iunlock>

  f->type = FD_INODE;
8010678c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010678f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106795:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106798:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010679b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010679e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067a1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801067a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067ab:	83 e0 01             	and    $0x1,%eax
801067ae:	85 c0                	test   %eax,%eax
801067b0:	0f 94 c0             	sete   %al
801067b3:	88 c2                	mov    %al,%dl
801067b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067b8:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801067bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067be:	83 e0 01             	and    $0x1,%eax
801067c1:	85 c0                	test   %eax,%eax
801067c3:	75 0a                	jne    801067cf <sys_open+0x16e>
801067c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067c8:	83 e0 02             	and    $0x2,%eax
801067cb:	85 c0                	test   %eax,%eax
801067cd:	74 07                	je     801067d6 <sys_open+0x175>
801067cf:	b8 01 00 00 00       	mov    $0x1,%eax
801067d4:	eb 05                	jmp    801067db <sys_open+0x17a>
801067d6:	b8 00 00 00 00       	mov    $0x0,%eax
801067db:	88 c2                	mov    %al,%dl
801067dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067e0:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801067e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801067e6:	c9                   	leave  
801067e7:	c3                   	ret    

801067e8 <sys_mkdir>:

int
sys_mkdir(void)
{
801067e8:	55                   	push   %ebp
801067e9:	89 e5                	mov    %esp,%ebp
801067eb:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
801067ee:	e8 dd c9 ff ff       	call   801031d0 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801067f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801067f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801067fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106801:	e8 e9 f3 ff ff       	call   80105bef <argstr>
80106806:	85 c0                	test   %eax,%eax
80106808:	78 2c                	js     80106836 <sys_mkdir+0x4e>
8010680a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010680d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106814:	00 
80106815:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010681c:	00 
8010681d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106824:	00 
80106825:	89 04 24             	mov    %eax,(%esp)
80106828:	e8 79 fc ff ff       	call   801064a6 <create>
8010682d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106830:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106834:	75 0c                	jne    80106842 <sys_mkdir+0x5a>
    commit_trans();
80106836:	e8 de c9 ff ff       	call   80103219 <commit_trans>
    return -1;
8010683b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106840:	eb 15                	jmp    80106857 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80106842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106845:	89 04 24             	mov    %eax,(%esp)
80106848:	e8 79 b2 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010684d:	e8 c7 c9 ff ff       	call   80103219 <commit_trans>
  return 0;
80106852:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106857:	c9                   	leave  
80106858:	c3                   	ret    

80106859 <sys_mknod>:

int
sys_mknod(void)
{
80106859:	55                   	push   %ebp
8010685a:	89 e5                	mov    %esp,%ebp
8010685c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
8010685f:	e8 6c c9 ff ff       	call   801031d0 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106864:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106867:	89 44 24 04          	mov    %eax,0x4(%esp)
8010686b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106872:	e8 78 f3 ff ff       	call   80105bef <argstr>
80106877:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010687a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010687e:	78 5e                	js     801068de <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106880:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106883:	89 44 24 04          	mov    %eax,0x4(%esp)
80106887:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010688e:	e8 cc f2 ff ff       	call   80105b5f <argint>
  if((len=argstr(0, &path)) < 0 ||
80106893:	85 c0                	test   %eax,%eax
80106895:	78 47                	js     801068de <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
80106897:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010689a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010689e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801068a5:	e8 b5 f2 ff ff       	call   80105b5f <argint>
     argint(1, &major) < 0 ||
801068aa:	85 c0                	test   %eax,%eax
801068ac:	78 30                	js     801068de <sys_mknod+0x85>
     (ip = create(path, T_DEV, major, minor)) == 0){
801068ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068b1:	0f bf c8             	movswl %ax,%ecx
801068b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068b7:	0f bf d0             	movswl %ax,%edx
801068ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
801068bd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801068c1:	89 54 24 08          	mov    %edx,0x8(%esp)
801068c5:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801068cc:	00 
801068cd:	89 04 24             	mov    %eax,(%esp)
801068d0:	e8 d1 fb ff ff       	call   801064a6 <create>
801068d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801068d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801068dc:	75 0c                	jne    801068ea <sys_mknod+0x91>
    commit_trans();
801068de:	e8 36 c9 ff ff       	call   80103219 <commit_trans>
    return -1;
801068e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e8:	eb 15                	jmp    801068ff <sys_mknod+0xa6>
  }
  iunlockput(ip);
801068ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068ed:	89 04 24             	mov    %eax,(%esp)
801068f0:	e8 d1 b1 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
801068f5:	e8 1f c9 ff ff       	call   80103219 <commit_trans>
  return 0;
801068fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801068ff:	c9                   	leave  
80106900:	c3                   	ret    

80106901 <sys_chdir>:

int
sys_chdir(void)
{
80106901:	55                   	push   %ebp
80106902:	89 e5                	mov    %esp,%ebp
80106904:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80106907:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010690a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106915:	e8 d5 f2 ff ff       	call   80105bef <argstr>
8010691a:	85 c0                	test   %eax,%eax
8010691c:	78 14                	js     80106932 <sys_chdir+0x31>
8010691e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106921:	89 04 24             	mov    %eax,(%esp)
80106924:	e8 b6 ba ff ff       	call   801023df <namei>
80106929:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010692c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106930:	75 07                	jne    80106939 <sys_chdir+0x38>
    return -1;
80106932:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106937:	eb 56                	jmp    8010698f <sys_chdir+0x8e>
  ilock(ip);
80106939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010693c:	89 04 24             	mov    %eax,(%esp)
8010693f:	e8 01 af ff ff       	call   80101845 <ilock>
  if(ip->type != T_DIR){
80106944:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106947:	8b 40 10             	mov    0x10(%eax),%eax
8010694a:	66 83 f8 01          	cmp    $0x1,%ax
8010694e:	74 12                	je     80106962 <sys_chdir+0x61>
    iunlockput(ip);
80106950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106953:	89 04 24             	mov    %eax,(%esp)
80106956:	e8 6b b1 ff ff       	call   80101ac6 <iunlockput>
    return -1;
8010695b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106960:	eb 2d                	jmp    8010698f <sys_chdir+0x8e>
  }
  iunlock(ip);
80106962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106965:	89 04 24             	mov    %eax,(%esp)
80106968:	e8 23 b0 ff ff       	call   80101990 <iunlock>
  iput(proc->cwd);
8010696d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106973:	8b 40 68             	mov    0x68(%eax),%eax
80106976:	89 04 24             	mov    %eax,(%esp)
80106979:	e8 77 b0 ff ff       	call   801019f5 <iput>
  proc->cwd = ip;
8010697e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106984:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106987:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010698a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010698f:	c9                   	leave  
80106990:	c3                   	ret    

80106991 <sys_exec>:

int
sys_exec(void)
{
80106991:	55                   	push   %ebp
80106992:	89 e5                	mov    %esp,%ebp
80106994:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010699a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010699d:	89 44 24 04          	mov    %eax,0x4(%esp)
801069a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069a8:	e8 42 f2 ff ff       	call   80105bef <argstr>
801069ad:	85 c0                	test   %eax,%eax
801069af:	78 1a                	js     801069cb <sys_exec+0x3a>
801069b1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801069b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801069bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801069c2:	e8 98 f1 ff ff       	call   80105b5f <argint>
801069c7:	85 c0                	test   %eax,%eax
801069c9:	79 0a                	jns    801069d5 <sys_exec+0x44>
    return -1;
801069cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d0:	e9 c7 00 00 00       	jmp    80106a9c <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
801069d5:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801069dc:	00 
801069dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069e4:	00 
801069e5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801069eb:	89 04 24             	mov    %eax,(%esp)
801069ee:	e8 3b ee ff ff       	call   8010582e <memset>
  for(i=0;; i++){
801069f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801069fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069fd:	83 f8 1f             	cmp    $0x1f,%eax
80106a00:	76 0a                	jbe    80106a0c <sys_exec+0x7b>
      return -1;
80106a02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a07:	e9 90 00 00 00       	jmp    80106a9c <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a0f:	c1 e0 02             	shl    $0x2,%eax
80106a12:	89 c2                	mov    %eax,%edx
80106a14:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106a1a:	01 c2                	add    %eax,%edx
80106a1c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106a22:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a26:	89 14 24             	mov    %edx,(%esp)
80106a29:	e8 95 f0 ff ff       	call   80105ac3 <fetchint>
80106a2e:	85 c0                	test   %eax,%eax
80106a30:	79 07                	jns    80106a39 <sys_exec+0xa8>
      return -1;
80106a32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a37:	eb 63                	jmp    80106a9c <sys_exec+0x10b>
    if(uarg == 0){
80106a39:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a3f:	85 c0                	test   %eax,%eax
80106a41:	75 26                	jne    80106a69 <sys_exec+0xd8>
      argv[i] = 0;
80106a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a46:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80106a4d:	00 00 00 00 
      break;
80106a51:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a55:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80106a5b:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a5f:	89 04 24             	mov    %eax,(%esp)
80106a62:	e8 64 a0 ff ff       	call   80100acb <exec>
80106a67:	eb 33                	jmp    80106a9c <sys_exec+0x10b>
    if(fetchstr(uarg, &argv[i]) < 0)
80106a69:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106a6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a72:	c1 e2 02             	shl    $0x2,%edx
80106a75:	01 c2                	add    %eax,%edx
80106a77:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106a7d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a81:	89 04 24             	mov    %eax,(%esp)
80106a84:	e8 74 f0 ff ff       	call   80105afd <fetchstr>
80106a89:	85 c0                	test   %eax,%eax
80106a8b:	79 07                	jns    80106a94 <sys_exec+0x103>
      return -1;
80106a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a92:	eb 08                	jmp    80106a9c <sys_exec+0x10b>
  for(i=0;; i++){
80106a94:	ff 45 f4             	incl   -0xc(%ebp)
  }
80106a97:	e9 5e ff ff ff       	jmp    801069fa <sys_exec+0x69>
}
80106a9c:	c9                   	leave  
80106a9d:	c3                   	ret    

80106a9e <sys_pipe>:

int
sys_pipe(void)
{
80106a9e:	55                   	push   %ebp
80106a9f:	89 e5                	mov    %esp,%ebp
80106aa1:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106aa4:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106aab:	00 
80106aac:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ab3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106aba:	e8 ce f0 ff ff       	call   80105b8d <argptr>
80106abf:	85 c0                	test   %eax,%eax
80106ac1:	79 0a                	jns    80106acd <sys_pipe+0x2f>
    return -1;
80106ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ac8:	e9 9b 00 00 00       	jmp    80106b68 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106acd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ad4:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106ad7:	89 04 24             	mov    %eax,(%esp)
80106ada:	e8 33 d1 ff ff       	call   80103c12 <pipealloc>
80106adf:	85 c0                	test   %eax,%eax
80106ae1:	79 07                	jns    80106aea <sys_pipe+0x4c>
    return -1;
80106ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ae8:	eb 7e                	jmp    80106b68 <sys_pipe+0xca>
  fd0 = -1;
80106aea:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106af4:	89 04 24             	mov    %eax,(%esp)
80106af7:	e8 2e f2 ff ff       	call   80105d2a <fdalloc>
80106afc:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106aff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b03:	78 14                	js     80106b19 <sys_pipe+0x7b>
80106b05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b08:	89 04 24             	mov    %eax,(%esp)
80106b0b:	e8 1a f2 ff ff       	call   80105d2a <fdalloc>
80106b10:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b17:	79 37                	jns    80106b50 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106b1d:	78 14                	js     80106b33 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106b1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b28:	83 c2 08             	add    $0x8,%edx
80106b2b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106b32:	00 
    fileclose(rf);
80106b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106b36:	89 04 24             	mov    %eax,(%esp)
80106b39:	e8 5d a4 ff ff       	call   80100f9b <fileclose>
    fileclose(wf);
80106b3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b41:	89 04 24             	mov    %eax,(%esp)
80106b44:	e8 52 a4 ff ff       	call   80100f9b <fileclose>
    return -1;
80106b49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b4e:	eb 18                	jmp    80106b68 <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106b56:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106b5b:	8d 50 04             	lea    0x4(%eax),%edx
80106b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b61:	89 02                	mov    %eax,(%edx)
  return 0;
80106b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b68:	c9                   	leave  
80106b69:	c3                   	ret    

80106b6a <sys_fork>:
#include "proc.h"
#include "semaphore.h"

int
sys_fork(void)
{
80106b6a:	55                   	push   %ebp
80106b6b:	89 e5                	mov    %esp,%ebp
80106b6d:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106b70:	e8 39 d9 ff ff       	call   801044ae <fork>
}
80106b75:	c9                   	leave  
80106b76:	c3                   	ret    

80106b77 <sys_exit>:

int
sys_exit(void)
{
80106b77:	55                   	push   %ebp
80106b78:	89 e5                	mov    %esp,%ebp
80106b7a:	83 ec 08             	sub    $0x8,%esp
  exit();
80106b7d:	e8 b0 da ff ff       	call   80104632 <exit>
  return 0;  // not reached
80106b82:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b87:	c9                   	leave  
80106b88:	c3                   	ret    

80106b89 <sys_wait>:

int
sys_wait(void)
{
80106b89:	55                   	push   %ebp
80106b8a:	89 e5                	mov    %esp,%ebp
80106b8c:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106b8f:	e8 4e dc ff ff       	call   801047e2 <wait>
}
80106b94:	c9                   	leave  
80106b95:	c3                   	ret    

80106b96 <sys_kill>:

int
sys_kill(void)
{
80106b96:	55                   	push   %ebp
80106b97:	89 e5                	mov    %esp,%ebp
80106b99:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b9f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ba3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106baa:	e8 b0 ef ff ff       	call   80105b5f <argint>
80106baf:	85 c0                	test   %eax,%eax
80106bb1:	79 07                	jns    80106bba <sys_kill+0x24>
    return -1;
80106bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bb8:	eb 0b                	jmp    80106bc5 <sys_kill+0x2f>
  return kill(pid);
80106bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bbd:	89 04 24             	mov    %eax,(%esp)
80106bc0:	e8 5c e0 ff ff       	call   80104c21 <kill>
}
80106bc5:	c9                   	leave  
80106bc6:	c3                   	ret    

80106bc7 <sys_getpid>:

int
sys_getpid(void)
{
80106bc7:	55                   	push   %ebp
80106bc8:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106bca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bd0:	8b 40 10             	mov    0x10(%eax),%eax
}
80106bd3:	5d                   	pop    %ebp
80106bd4:	c3                   	ret    

80106bd5 <sys_sbrk>:

int
sys_sbrk(void)
{
80106bd5:	55                   	push   %ebp
80106bd6:	89 e5                	mov    %esp,%ebp
80106bd8:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106bdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106bde:	89 44 24 04          	mov    %eax,0x4(%esp)
80106be2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106be9:	e8 71 ef ff ff       	call   80105b5f <argint>
80106bee:	85 c0                	test   %eax,%eax
80106bf0:	79 07                	jns    80106bf9 <sys_sbrk+0x24>
    return -1;
80106bf2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bf7:	eb 24                	jmp    80106c1d <sys_sbrk+0x48>
  addr = proc->sz;
80106bf9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bff:	8b 00                	mov    (%eax),%eax
80106c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106c04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c07:	89 04 24             	mov    %eax,(%esp)
80106c0a:	e8 fa d7 ff ff       	call   80104409 <growproc>
80106c0f:	85 c0                	test   %eax,%eax
80106c11:	79 07                	jns    80106c1a <sys_sbrk+0x45>
    return -1;
80106c13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c18:	eb 03                	jmp    80106c1d <sys_sbrk+0x48>
  return addr;
80106c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c1d:	c9                   	leave  
80106c1e:	c3                   	ret    

80106c1f <sys_sleep>:

int
sys_sleep(void)
{
80106c1f:	55                   	push   %ebp
80106c20:	89 e5                	mov    %esp,%ebp
80106c22:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106c25:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106c28:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c33:	e8 27 ef ff ff       	call   80105b5f <argint>
80106c38:	85 c0                	test   %eax,%eax
80106c3a:	79 07                	jns    80106c43 <sys_sleep+0x24>
    return -1;
80106c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c41:	eb 6c                	jmp    80106caf <sys_sleep+0x90>
  acquire(&tickslock);
80106c43:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80106c4a:	e8 8d e9 ff ff       	call   801055dc <acquire>
  ticks0 = ticks;
80106c4f:	a1 60 45 11 80       	mov    0x80114560,%eax
80106c54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106c57:	eb 34                	jmp    80106c8d <sys_sleep+0x6e>
    if(proc->killed){
80106c59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106c5f:	8b 40 24             	mov    0x24(%eax),%eax
80106c62:	85 c0                	test   %eax,%eax
80106c64:	74 13                	je     80106c79 <sys_sleep+0x5a>
      release(&tickslock);
80106c66:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80106c6d:	e8 cc e9 ff ff       	call   8010563e <release>
      return -1;
80106c72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c77:	eb 36                	jmp    80106caf <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106c79:	c7 44 24 04 20 3d 11 	movl   $0x80113d20,0x4(%esp)
80106c80:	80 
80106c81:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
80106c88:	e8 61 de ff ff       	call   80104aee <sleep>
  while(ticks - ticks0 < n){
80106c8d:	a1 60 45 11 80       	mov    0x80114560,%eax
80106c92:	89 c2                	mov    %eax,%edx
80106c94:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c9a:	39 c2                	cmp    %eax,%edx
80106c9c:	72 bb                	jb     80106c59 <sys_sleep+0x3a>
  }
  release(&tickslock);
80106c9e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80106ca5:	e8 94 e9 ff ff       	call   8010563e <release>
  return 0;
80106caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106caf:	c9                   	leave  
80106cb0:	c3                   	ret    

80106cb1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106cb1:	55                   	push   %ebp
80106cb2:	89 e5                	mov    %esp,%ebp
80106cb4:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106cb7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80106cbe:	e8 19 e9 ff ff       	call   801055dc <acquire>
  xticks = ticks;
80106cc3:	a1 60 45 11 80       	mov    0x80114560,%eax
80106cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106ccb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80106cd2:	e8 67 e9 ff ff       	call   8010563e <release>
  return xticks;
80106cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106cda:	c9                   	leave  
80106cdb:	c3                   	ret    

80106cdc <sys_procstat>:

// New: Add in proyect 1: implementation of system call procstat
int
sys_procstat(void){             
80106cdc:	55                   	push   %ebp
80106cdd:	89 e5                	mov    %esp,%ebp
80106cdf:	83 ec 08             	sub    $0x8,%esp
  procdump(); // Print a process listing to console.
80106ce2:	e8 be df ff ff       	call   80104ca5 <procdump>
  return 0; 
80106ce7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106cec:	c9                   	leave  
80106ced:	c3                   	ret    

80106cee <sys_set_priority>:

// New: Add in project 2: implementation of syscall set_priority
int
sys_set_priority(void){
80106cee:	55                   	push   %ebp
80106cef:	89 e5                	mov    %esp,%ebp
80106cf1:	83 ec 28             	sub    $0x28,%esp
  int pr;
  argint(0, &pr);
80106cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cfb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d02:	e8 58 ee ff ff       	call   80105b5f <argint>
  proc->priority=pr;
80106d07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106d10:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80106d16:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d1b:	c9                   	leave  
80106d1c:	c3                   	ret    

80106d1d <sys_semget>:

// New: Add in project final - (semaphore)
int
sys_semget(void)
{
80106d1d:	55                   	push   %ebp
80106d1e:	89 e5                	mov    %esp,%ebp
80106d20:	83 ec 28             	sub    $0x28,%esp
  int semid, init_value;
  if( argint(1, &init_value) < 0 || argint(0, &semid) < 0)
80106d23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106d26:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106d31:	e8 29 ee ff ff       	call   80105b5f <argint>
80106d36:	85 c0                	test   %eax,%eax
80106d38:	78 17                	js     80106d51 <sys_semget+0x34>
80106d3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d48:	e8 12 ee ff ff       	call   80105b5f <argint>
80106d4d:	85 c0                	test   %eax,%eax
80106d4f:	79 07                	jns    80106d58 <sys_semget+0x3b>
    return -1;
80106d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d56:	eb 12                	jmp    80106d6a <sys_semget+0x4d>
  return semget(semid,init_value);
80106d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d5e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106d62:	89 04 24             	mov    %eax,(%esp)
80106d65:	e8 8c e0 ff ff       	call   80104df6 <semget>
}
80106d6a:	c9                   	leave  
80106d6b:	c3                   	ret    

80106d6c <sys_semfree>:

// New: Add in project final - (semaphore)
int 
sys_semfree(void)
{
80106d6c:	55                   	push   %ebp
80106d6d:	89 e5                	mov    %esp,%ebp
80106d6f:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106d72:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d75:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d79:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d80:	e8 da ed ff ff       	call   80105b5f <argint>
80106d85:	85 c0                	test   %eax,%eax
80106d87:	79 07                	jns    80106d90 <sys_semfree+0x24>
    return -1;
80106d89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d8e:	eb 0b                	jmp    80106d9b <sys_semfree+0x2f>
  return semfree(semid);
80106d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d93:	89 04 24             	mov    %eax,(%esp)
80106d96:	e8 cb e1 ff ff       	call   80104f66 <semfree>
}
80106d9b:	c9                   	leave  
80106d9c:	c3                   	ret    

80106d9d <sys_semdown>:

// New: Add in project final - (semaphore)
int 
sys_semdown(void)
{
80106d9d:	55                   	push   %ebp
80106d9e:	89 e5                	mov    %esp,%ebp
80106da0:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106da3:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106da6:	89 44 24 04          	mov    %eax,0x4(%esp)
80106daa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106db1:	e8 a9 ed ff ff       	call   80105b5f <argint>
80106db6:	85 c0                	test   %eax,%eax
80106db8:	79 07                	jns    80106dc1 <sys_semdown+0x24>
    return -1;
80106dba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dbf:	eb 0b                	jmp    80106dcc <sys_semdown+0x2f>
  return semdown(semid);
80106dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106dc4:	89 04 24             	mov    %eax,(%esp)
80106dc7:	e8 44 e2 ff ff       	call   80105010 <semdown>
}
80106dcc:	c9                   	leave  
80106dcd:	c3                   	ret    

80106dce <sys_semup>:

// New: Add in project final - (semaphore)
int 
sys_semup(void)
{
80106dce:	55                   	push   %ebp
80106dcf:	89 e5                	mov    %esp,%ebp
80106dd1:	83 ec 28             	sub    $0x28,%esp
  int semid;
  if(argint(0, &semid) < 0)
80106dd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106dd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ddb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106de2:	e8 78 ed ff ff       	call   80105b5f <argint>
80106de7:	85 c0                	test   %eax,%eax
80106de9:	79 07                	jns    80106df2 <sys_semup+0x24>
    return -1;
80106deb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106df0:	eb 0b                	jmp    80106dfd <sys_semup+0x2f>
  return semup(semid);
80106df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df5:	89 04 24             	mov    %eax,(%esp)
80106df8:	e8 95 e2 ff ff       	call   80105092 <semup>
}
80106dfd:	c9                   	leave  
80106dfe:	c3                   	ret    

80106dff <outb>:
{
80106dff:	55                   	push   %ebp
80106e00:	89 e5                	mov    %esp,%ebp
80106e02:	83 ec 08             	sub    $0x8,%esp
80106e05:	8b 45 08             	mov    0x8(%ebp),%eax
80106e08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e0b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106e0f:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106e12:	8a 45 f8             	mov    -0x8(%ebp),%al
80106e15:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e18:	ee                   	out    %al,(%dx)
}
80106e19:	c9                   	leave  
80106e1a:	c3                   	ret    

80106e1b <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106e1b:	55                   	push   %ebp
80106e1c:	89 e5                	mov    %esp,%ebp
80106e1e:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106e21:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106e28:	00 
80106e29:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106e30:	e8 ca ff ff ff       	call   80106dff <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106e35:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106e3c:	00 
80106e3d:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106e44:	e8 b6 ff ff ff       	call   80106dff <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106e49:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106e50:	00 
80106e51:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106e58:	e8 a2 ff ff ff       	call   80106dff <outb>
  picenable(IRQ_TIMER);
80106e5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106e64:	e8 38 cc ff ff       	call   80103aa1 <picenable>
}
80106e69:	c9                   	leave  
80106e6a:	c3                   	ret    

80106e6b <alltraps>:
80106e6b:	1e                   	push   %ds
80106e6c:	06                   	push   %es
80106e6d:	0f a0                	push   %fs
80106e6f:	0f a8                	push   %gs
80106e71:	60                   	pusha  
80106e72:	66 b8 10 00          	mov    $0x10,%ax
80106e76:	8e d8                	mov    %eax,%ds
80106e78:	8e c0                	mov    %eax,%es
80106e7a:	66 b8 18 00          	mov    $0x18,%ax
80106e7e:	8e e0                	mov    %eax,%fs
80106e80:	8e e8                	mov    %eax,%gs
80106e82:	54                   	push   %esp
80106e83:	e8 c4 01 00 00       	call   8010704c <trap>
80106e88:	83 c4 04             	add    $0x4,%esp

80106e8b <trapret>:
80106e8b:	61                   	popa   
80106e8c:	0f a9                	pop    %gs
80106e8e:	0f a1                	pop    %fs
80106e90:	07                   	pop    %es
80106e91:	1f                   	pop    %ds
80106e92:	83 c4 08             	add    $0x8,%esp
80106e95:	cf                   	iret   

80106e96 <lidt>:
{
80106e96:	55                   	push   %ebp
80106e97:	89 e5                	mov    %esp,%ebp
80106e99:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106e9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e9f:	48                   	dec    %eax
80106ea0:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106ea4:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106eab:	8b 45 08             	mov    0x8(%ebp),%eax
80106eae:	c1 e8 10             	shr    $0x10,%eax
80106eb1:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106eb5:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106eb8:	0f 01 18             	lidtl  (%eax)
}
80106ebb:	c9                   	leave  
80106ebc:	c3                   	ret    

80106ebd <rcr2>:

static inline uint
rcr2(void)
{
80106ebd:	55                   	push   %ebp
80106ebe:	89 e5                	mov    %esp,%ebp
80106ec0:	53                   	push   %ebx
80106ec1:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106ec4:	0f 20 d3             	mov    %cr2,%ebx
80106ec7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106eca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106ecd:	83 c4 10             	add    $0x10,%esp
80106ed0:	5b                   	pop    %ebx
80106ed1:	5d                   	pop    %ebp
80106ed2:	c3                   	ret    

80106ed3 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106ed3:	55                   	push   %ebp
80106ed4:	89 e5                	mov    %esp,%ebp
80106ed6:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106ed9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ee0:	e9 b8 00 00 00       	jmp    80106f9d <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee8:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106eef:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106ef2:	66 89 04 d5 60 3d 11 	mov    %ax,-0x7feec2a0(,%edx,8)
80106ef9:	80 
80106efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106efd:	66 c7 04 c5 62 3d 11 	movw   $0x8,-0x7feec29e(,%eax,8)
80106f04:	80 08 00 
80106f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f0a:	8a 14 c5 64 3d 11 80 	mov    -0x7feec29c(,%eax,8),%dl
80106f11:	83 e2 e0             	and    $0xffffffe0,%edx
80106f14:	88 14 c5 64 3d 11 80 	mov    %dl,-0x7feec29c(,%eax,8)
80106f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f1e:	8a 14 c5 64 3d 11 80 	mov    -0x7feec29c(,%eax,8),%dl
80106f25:	83 e2 1f             	and    $0x1f,%edx
80106f28:	88 14 c5 64 3d 11 80 	mov    %dl,-0x7feec29c(,%eax,8)
80106f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f32:	8a 14 c5 65 3d 11 80 	mov    -0x7feec29b(,%eax,8),%dl
80106f39:	83 e2 f0             	and    $0xfffffff0,%edx
80106f3c:	83 ca 0e             	or     $0xe,%edx
80106f3f:	88 14 c5 65 3d 11 80 	mov    %dl,-0x7feec29b(,%eax,8)
80106f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f49:	8a 14 c5 65 3d 11 80 	mov    -0x7feec29b(,%eax,8),%dl
80106f50:	83 e2 ef             	and    $0xffffffef,%edx
80106f53:	88 14 c5 65 3d 11 80 	mov    %dl,-0x7feec29b(,%eax,8)
80106f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f5d:	8a 14 c5 65 3d 11 80 	mov    -0x7feec29b(,%eax,8),%dl
80106f64:	83 e2 9f             	and    $0xffffff9f,%edx
80106f67:	88 14 c5 65 3d 11 80 	mov    %dl,-0x7feec29b(,%eax,8)
80106f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f71:	8a 14 c5 65 3d 11 80 	mov    -0x7feec29b(,%eax,8),%dl
80106f78:	83 ca 80             	or     $0xffffff80,%edx
80106f7b:	88 14 c5 65 3d 11 80 	mov    %dl,-0x7feec29b(,%eax,8)
80106f82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f85:	8b 04 85 c4 c0 10 80 	mov    -0x7fef3f3c(,%eax,4),%eax
80106f8c:	c1 e8 10             	shr    $0x10,%eax
80106f8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f92:	66 89 04 d5 66 3d 11 	mov    %ax,-0x7feec29a(,%edx,8)
80106f99:	80 
  for(i = 0; i < 256; i++)
80106f9a:	ff 45 f4             	incl   -0xc(%ebp)
80106f9d:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106fa4:	0f 8e 3b ff ff ff    	jle    80106ee5 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106faa:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80106faf:	66 a3 60 3f 11 80    	mov    %ax,0x80113f60
80106fb5:	66 c7 05 62 3f 11 80 	movw   $0x8,0x80113f62
80106fbc:	08 00 
80106fbe:	a0 64 3f 11 80       	mov    0x80113f64,%al
80106fc3:	83 e0 e0             	and    $0xffffffe0,%eax
80106fc6:	a2 64 3f 11 80       	mov    %al,0x80113f64
80106fcb:	a0 64 3f 11 80       	mov    0x80113f64,%al
80106fd0:	83 e0 1f             	and    $0x1f,%eax
80106fd3:	a2 64 3f 11 80       	mov    %al,0x80113f64
80106fd8:	a0 65 3f 11 80       	mov    0x80113f65,%al
80106fdd:	83 c8 0f             	or     $0xf,%eax
80106fe0:	a2 65 3f 11 80       	mov    %al,0x80113f65
80106fe5:	a0 65 3f 11 80       	mov    0x80113f65,%al
80106fea:	83 e0 ef             	and    $0xffffffef,%eax
80106fed:	a2 65 3f 11 80       	mov    %al,0x80113f65
80106ff2:	a0 65 3f 11 80       	mov    0x80113f65,%al
80106ff7:	83 c8 60             	or     $0x60,%eax
80106ffa:	a2 65 3f 11 80       	mov    %al,0x80113f65
80106fff:	a0 65 3f 11 80       	mov    0x80113f65,%al
80107004:	83 c8 80             	or     $0xffffff80,%eax
80107007:	a2 65 3f 11 80       	mov    %al,0x80113f65
8010700c:	a1 c4 c1 10 80       	mov    0x8010c1c4,%eax
80107011:	c1 e8 10             	shr    $0x10,%eax
80107014:	66 a3 66 3f 11 80    	mov    %ax,0x80113f66
  
  initlock(&tickslock, "time");
8010701a:	c7 44 24 04 04 93 10 	movl   $0x80109304,0x4(%esp)
80107021:	80 
80107022:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80107029:	e8 8d e5 ff ff       	call   801055bb <initlock>
}
8010702e:	c9                   	leave  
8010702f:	c3                   	ret    

80107030 <idtinit>:

void
idtinit(void)
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80107036:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010703d:	00 
8010703e:	c7 04 24 60 3d 11 80 	movl   $0x80113d60,(%esp)
80107045:	e8 4c fe ff ff       	call   80106e96 <lidt>
}
8010704a:	c9                   	leave  
8010704b:	c3                   	ret    

8010704c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010704c:	55                   	push   %ebp
8010704d:	89 e5                	mov    %esp,%ebp
8010704f:	57                   	push   %edi
80107050:	56                   	push   %esi
80107051:	53                   	push   %ebx
80107052:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80107055:	8b 45 08             	mov    0x8(%ebp),%eax
80107058:	8b 40 30             	mov    0x30(%eax),%eax
8010705b:	83 f8 40             	cmp    $0x40,%eax
8010705e:	75 3e                	jne    8010709e <trap+0x52>
    if(proc->killed)
80107060:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107066:	8b 40 24             	mov    0x24(%eax),%eax
80107069:	85 c0                	test   %eax,%eax
8010706b:	74 05                	je     80107072 <trap+0x26>
      exit();
8010706d:	e8 c0 d5 ff ff       	call   80104632 <exit>
    proc->tf = tf;
80107072:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107078:	8b 55 08             	mov    0x8(%ebp),%edx
8010707b:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010707e:	e8 a3 eb ff ff       	call   80105c26 <syscall>
    if(proc->killed)
80107083:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107089:	8b 40 24             	mov    0x24(%eax),%eax
8010708c:	85 c0                	test   %eax,%eax
8010708e:	0f 84 3f 02 00 00    	je     801072d3 <trap+0x287>
      exit();
80107094:	e8 99 d5 ff ff       	call   80104632 <exit>
    return;
80107099:	e9 35 02 00 00       	jmp    801072d3 <trap+0x287>
  }

  switch(tf->trapno){
8010709e:	8b 45 08             	mov    0x8(%ebp),%eax
801070a1:	8b 40 30             	mov    0x30(%eax),%eax
801070a4:	83 e8 20             	sub    $0x20,%eax
801070a7:	83 f8 1f             	cmp    $0x1f,%eax
801070aa:	0f 87 b7 00 00 00    	ja     80107167 <trap+0x11b>
801070b0:	8b 04 85 ac 93 10 80 	mov    -0x7fef6c54(,%eax,4),%eax
801070b7:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
801070b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070bf:	8a 00                	mov    (%eax),%al
801070c1:	84 c0                	test   %al,%al
801070c3:	75 2f                	jne    801070f4 <trap+0xa8>
      acquire(&tickslock);
801070c5:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801070cc:	e8 0b e5 ff ff       	call   801055dc <acquire>
      ticks++;
801070d1:	a1 60 45 11 80       	mov    0x80114560,%eax
801070d6:	40                   	inc    %eax
801070d7:	a3 60 45 11 80       	mov    %eax,0x80114560
      wakeup(&ticks);
801070dc:	c7 04 24 60 45 11 80 	movl   $0x80114560,(%esp)
801070e3:	e8 0e db ff ff       	call   80104bf6 <wakeup>
      release(&tickslock);
801070e8:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801070ef:	e8 4a e5 ff ff       	call   8010563e <release>
    }
    lapiceoi();
801070f4:	e8 a6 bd ff ff       	call   80102e9f <lapiceoi>
    break;
801070f9:	e9 3c 01 00 00       	jmp    8010723a <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801070fe:	e8 ba b5 ff ff       	call   801026bd <ideintr>
    lapiceoi();
80107103:	e8 97 bd ff ff       	call   80102e9f <lapiceoi>
    break;
80107108:	e9 2d 01 00 00       	jmp    8010723a <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
8010710d:	e8 70 bb ff ff       	call   80102c82 <kbdintr>
    lapiceoi();
80107112:	e8 88 bd ff ff       	call   80102e9f <lapiceoi>
    break;
80107117:	e9 1e 01 00 00       	jmp    8010723a <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010711c:	e8 af 03 00 00       	call   801074d0 <uartintr>
    lapiceoi();
80107121:	e8 79 bd ff ff       	call   80102e9f <lapiceoi>
    break;
80107126:	e9 0f 01 00 00       	jmp    8010723a <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
8010712b:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010712e:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107131:	8b 45 08             	mov    0x8(%ebp),%eax
80107134:	8b 40 3c             	mov    0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107137:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010713a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107140:	8a 00                	mov    (%eax),%al
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107142:	0f b6 c0             	movzbl %al,%eax
80107145:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107149:	89 54 24 08          	mov    %edx,0x8(%esp)
8010714d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107151:	c7 04 24 0c 93 10 80 	movl   $0x8010930c,(%esp)
80107158:	e8 44 92 ff ff       	call   801003a1 <cprintf>
    lapiceoi();
8010715d:	e8 3d bd ff ff       	call   80102e9f <lapiceoi>
    break;
80107162:	e9 d3 00 00 00       	jmp    8010723a <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107167:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010716d:	85 c0                	test   %eax,%eax
8010716f:	74 10                	je     80107181 <trap+0x135>
80107171:	8b 45 08             	mov    0x8(%ebp),%eax
80107174:	8b 40 3c             	mov    0x3c(%eax),%eax
80107177:	0f b7 c0             	movzwl %ax,%eax
8010717a:	83 e0 03             	and    $0x3,%eax
8010717d:	85 c0                	test   %eax,%eax
8010717f:	75 45                	jne    801071c6 <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107181:	e8 37 fd ff ff       	call   80106ebd <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80107186:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107189:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010718c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107193:	8a 12                	mov    (%edx),%dl
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107195:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107198:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010719b:	8b 52 30             	mov    0x30(%edx),%edx
8010719e:	89 44 24 10          	mov    %eax,0x10(%esp)
801071a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801071a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801071aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801071ae:	c7 04 24 30 93 10 80 	movl   $0x80109330,(%esp)
801071b5:	e8 e7 91 ff ff       	call   801003a1 <cprintf>
      panic("trap");
801071ba:	c7 04 24 62 93 10 80 	movl   $0x80109362,(%esp)
801071c1:	e8 70 93 ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071c6:	e8 f2 fc ff ff       	call   80106ebd <rcr2>
801071cb:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071cd:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071d0:	8b 78 38             	mov    0x38(%eax),%edi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801071d9:	8a 00                	mov    (%eax),%al
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071db:	0f b6 f0             	movzbl %al,%esi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071de:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071e1:	8b 58 34             	mov    0x34(%eax),%ebx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071e4:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071e7:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801071ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071f0:	83 c0 6c             	add    $0x6c,%eax
801071f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801071fc:	8b 40 10             	mov    0x10(%eax),%eax
801071ff:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80107203:	89 7c 24 18          	mov    %edi,0x18(%esp)
80107207:	89 74 24 14          	mov    %esi,0x14(%esp)
8010720b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010720f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80107213:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107216:	89 54 24 08          	mov    %edx,0x8(%esp)
8010721a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010721e:	c7 04 24 68 93 10 80 	movl   $0x80109368,(%esp)
80107225:	e8 77 91 ff ff       	call   801003a1 <cprintf>
            rcr2());
    proc->killed = 1;
8010722a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107230:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107237:	eb 01                	jmp    8010723a <trap+0x1ee>
    break;
80107239:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010723a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107240:	85 c0                	test   %eax,%eax
80107242:	74 23                	je     80107267 <trap+0x21b>
80107244:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010724a:	8b 40 24             	mov    0x24(%eax),%eax
8010724d:	85 c0                	test   %eax,%eax
8010724f:	74 16                	je     80107267 <trap+0x21b>
80107251:	8b 45 08             	mov    0x8(%ebp),%eax
80107254:	8b 40 3c             	mov    0x3c(%eax),%eax
80107257:	0f b7 c0             	movzwl %ax,%eax
8010725a:	83 e0 03             	and    $0x3,%eax
8010725d:	83 f8 03             	cmp    $0x3,%eax
80107260:	75 05                	jne    80107267 <trap+0x21b>
    exit();
80107262:	e8 cb d3 ff ff       	call   80104632 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER && ++(proc->ticksProc) == QUANTUM) {
80107267:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010726d:	85 c0                	test   %eax,%eax
8010726f:	74 33                	je     801072a4 <trap+0x258>
80107271:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107277:	8b 40 0c             	mov    0xc(%eax),%eax
8010727a:	83 f8 04             	cmp    $0x4,%eax
8010727d:	75 25                	jne    801072a4 <trap+0x258>
8010727f:	8b 45 08             	mov    0x8(%ebp),%eax
80107282:	8b 40 30             	mov    0x30(%eax),%eax
80107285:	83 f8 20             	cmp    $0x20,%eax
80107288:	75 1a                	jne    801072a4 <trap+0x258>
8010728a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107290:	8b 50 7c             	mov    0x7c(%eax),%edx
80107293:	42                   	inc    %edx
80107294:	89 50 7c             	mov    %edx,0x7c(%eax)
80107297:	8b 40 7c             	mov    0x7c(%eax),%eax
8010729a:	83 f8 06             	cmp    $0x6,%eax
8010729d:	75 05                	jne    801072a4 <trap+0x258>
      // New: Added in proyect 0
      // cprintf("tamaño del quantum: %d\n", QUANTUM);
      // cprintf("cantidad de ticks del proceso: %d\n", proc->ticksProc);
      // cprintf("nombre del proceso: %s\n", proc->name);
      // cprintf("abandone cpu\n");
      yield();
8010729f:	e8 bf d7 ff ff       	call   80104a63 <yield>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801072a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072aa:	85 c0                	test   %eax,%eax
801072ac:	74 26                	je     801072d4 <trap+0x288>
801072ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801072b4:	8b 40 24             	mov    0x24(%eax),%eax
801072b7:	85 c0                	test   %eax,%eax
801072b9:	74 19                	je     801072d4 <trap+0x288>
801072bb:	8b 45 08             	mov    0x8(%ebp),%eax
801072be:	8b 40 3c             	mov    0x3c(%eax),%eax
801072c1:	0f b7 c0             	movzwl %ax,%eax
801072c4:	83 e0 03             	and    $0x3,%eax
801072c7:	83 f8 03             	cmp    $0x3,%eax
801072ca:	75 08                	jne    801072d4 <trap+0x288>
    exit();
801072cc:	e8 61 d3 ff ff       	call   80104632 <exit>
801072d1:	eb 01                	jmp    801072d4 <trap+0x288>
    return;
801072d3:	90                   	nop
}
801072d4:	83 c4 3c             	add    $0x3c,%esp
801072d7:	5b                   	pop    %ebx
801072d8:	5e                   	pop    %esi
801072d9:	5f                   	pop    %edi
801072da:	5d                   	pop    %ebp
801072db:	c3                   	ret    

801072dc <inb>:
{
801072dc:	55                   	push   %ebp
801072dd:	89 e5                	mov    %esp,%ebp
801072df:	53                   	push   %ebx
801072e0:	83 ec 14             	sub    $0x14,%esp
801072e3:	8b 45 08             	mov    0x8(%ebp),%eax
801072e6:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801072ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
801072ed:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801072f1:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
801072f5:	ec                   	in     (%dx),%al
801072f6:	88 c3                	mov    %al,%bl
801072f8:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801072fb:	8a 45 fb             	mov    -0x5(%ebp),%al
}
801072fe:	83 c4 14             	add    $0x14,%esp
80107301:	5b                   	pop    %ebx
80107302:	5d                   	pop    %ebp
80107303:	c3                   	ret    

80107304 <outb>:
{
80107304:	55                   	push   %ebp
80107305:	89 e5                	mov    %esp,%ebp
80107307:	83 ec 08             	sub    $0x8,%esp
8010730a:	8b 45 08             	mov    0x8(%ebp),%eax
8010730d:	8b 55 0c             	mov    0xc(%ebp),%edx
80107310:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80107314:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107317:	8a 45 f8             	mov    -0x8(%ebp),%al
8010731a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010731d:	ee                   	out    %al,(%dx)
}
8010731e:	c9                   	leave  
8010731f:	c3                   	ret    

80107320 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107326:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010732d:	00 
8010732e:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107335:	e8 ca ff ff ff       	call   80107304 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010733a:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80107341:	00 
80107342:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107349:	e8 b6 ff ff ff       	call   80107304 <outb>
  outb(COM1+0, 115200/9600);
8010734e:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80107355:	00 
80107356:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
8010735d:	e8 a2 ff ff ff       	call   80107304 <outb>
  outb(COM1+1, 0);
80107362:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107369:	00 
8010736a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80107371:	e8 8e ff ff ff       	call   80107304 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107376:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010737d:	00 
8010737e:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80107385:	e8 7a ff ff ff       	call   80107304 <outb>
  outb(COM1+4, 0);
8010738a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107391:	00 
80107392:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107399:	e8 66 ff ff ff       	call   80107304 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010739e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801073a5:	00 
801073a6:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801073ad:	e8 52 ff ff ff       	call   80107304 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801073b2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073b9:	e8 1e ff ff ff       	call   801072dc <inb>
801073be:	3c ff                	cmp    $0xff,%al
801073c0:	74 69                	je     8010742b <uartinit+0x10b>
    return;
  uart = 1;
801073c2:	c7 05 8c c6 10 80 01 	movl   $0x1,0x8010c68c
801073c9:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801073cc:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801073d3:	e8 04 ff ff ff       	call   801072dc <inb>
  inb(COM1+0);
801073d8:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073df:	e8 f8 fe ff ff       	call   801072dc <inb>
  picenable(IRQ_COM1);
801073e4:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801073eb:	e8 b1 c6 ff ff       	call   80103aa1 <picenable>
  ioapicenable(IRQ_COM1, 0);
801073f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801073f7:	00 
801073f8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801073ff:	e8 36 b5 ff ff       	call   8010293a <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107404:	c7 45 f4 2c 94 10 80 	movl   $0x8010942c,-0xc(%ebp)
8010740b:	eb 13                	jmp    80107420 <uartinit+0x100>
    uartputc(*p);
8010740d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107410:	8a 00                	mov    (%eax),%al
80107412:	0f be c0             	movsbl %al,%eax
80107415:	89 04 24             	mov    %eax,(%esp)
80107418:	e8 11 00 00 00       	call   8010742e <uartputc>
  for(p="xv6...\n"; *p; p++)
8010741d:	ff 45 f4             	incl   -0xc(%ebp)
80107420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107423:	8a 00                	mov    (%eax),%al
80107425:	84 c0                	test   %al,%al
80107427:	75 e4                	jne    8010740d <uartinit+0xed>
80107429:	eb 01                	jmp    8010742c <uartinit+0x10c>
    return;
8010742b:	90                   	nop
}
8010742c:	c9                   	leave  
8010742d:	c3                   	ret    

8010742e <uartputc>:

void
uartputc(int c)
{
8010742e:	55                   	push   %ebp
8010742f:	89 e5                	mov    %esp,%ebp
80107431:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80107434:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
80107439:	85 c0                	test   %eax,%eax
8010743b:	74 4c                	je     80107489 <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010743d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107444:	eb 0f                	jmp    80107455 <uartputc+0x27>
    microdelay(10);
80107446:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010744d:	e8 72 ba ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107452:	ff 45 f4             	incl   -0xc(%ebp)
80107455:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107459:	7f 16                	jg     80107471 <uartputc+0x43>
8010745b:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107462:	e8 75 fe ff ff       	call   801072dc <inb>
80107467:	0f b6 c0             	movzbl %al,%eax
8010746a:	83 e0 20             	and    $0x20,%eax
8010746d:	85 c0                	test   %eax,%eax
8010746f:	74 d5                	je     80107446 <uartputc+0x18>
  outb(COM1+0, c);
80107471:	8b 45 08             	mov    0x8(%ebp),%eax
80107474:	0f b6 c0             	movzbl %al,%eax
80107477:	89 44 24 04          	mov    %eax,0x4(%esp)
8010747b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107482:	e8 7d fe ff ff       	call   80107304 <outb>
80107487:	eb 01                	jmp    8010748a <uartputc+0x5c>
    return;
80107489:	90                   	nop
}
8010748a:	c9                   	leave  
8010748b:	c3                   	ret    

8010748c <uartgetc>:

static int
uartgetc(void)
{
8010748c:	55                   	push   %ebp
8010748d:	89 e5                	mov    %esp,%ebp
8010748f:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107492:	a1 8c c6 10 80       	mov    0x8010c68c,%eax
80107497:	85 c0                	test   %eax,%eax
80107499:	75 07                	jne    801074a2 <uartgetc+0x16>
    return -1;
8010749b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074a0:	eb 2c                	jmp    801074ce <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801074a2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801074a9:	e8 2e fe ff ff       	call   801072dc <inb>
801074ae:	0f b6 c0             	movzbl %al,%eax
801074b1:	83 e0 01             	and    $0x1,%eax
801074b4:	85 c0                	test   %eax,%eax
801074b6:	75 07                	jne    801074bf <uartgetc+0x33>
    return -1;
801074b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074bd:	eb 0f                	jmp    801074ce <uartgetc+0x42>
  return inb(COM1+0);
801074bf:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801074c6:	e8 11 fe ff ff       	call   801072dc <inb>
801074cb:	0f b6 c0             	movzbl %al,%eax
}
801074ce:	c9                   	leave  
801074cf:	c3                   	ret    

801074d0 <uartintr>:

void
uartintr(void)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801074d6:	c7 04 24 8c 74 10 80 	movl   $0x8010748c,(%esp)
801074dd:	e8 ae 92 ff ff       	call   80100790 <consoleintr>
}
801074e2:	c9                   	leave  
801074e3:	c3                   	ret    

801074e4 <vector0>:
801074e4:	6a 00                	push   $0x0
801074e6:	6a 00                	push   $0x0
801074e8:	e9 7e f9 ff ff       	jmp    80106e6b <alltraps>

801074ed <vector1>:
801074ed:	6a 00                	push   $0x0
801074ef:	6a 01                	push   $0x1
801074f1:	e9 75 f9 ff ff       	jmp    80106e6b <alltraps>

801074f6 <vector2>:
801074f6:	6a 00                	push   $0x0
801074f8:	6a 02                	push   $0x2
801074fa:	e9 6c f9 ff ff       	jmp    80106e6b <alltraps>

801074ff <vector3>:
801074ff:	6a 00                	push   $0x0
80107501:	6a 03                	push   $0x3
80107503:	e9 63 f9 ff ff       	jmp    80106e6b <alltraps>

80107508 <vector4>:
80107508:	6a 00                	push   $0x0
8010750a:	6a 04                	push   $0x4
8010750c:	e9 5a f9 ff ff       	jmp    80106e6b <alltraps>

80107511 <vector5>:
80107511:	6a 00                	push   $0x0
80107513:	6a 05                	push   $0x5
80107515:	e9 51 f9 ff ff       	jmp    80106e6b <alltraps>

8010751a <vector6>:
8010751a:	6a 00                	push   $0x0
8010751c:	6a 06                	push   $0x6
8010751e:	e9 48 f9 ff ff       	jmp    80106e6b <alltraps>

80107523 <vector7>:
80107523:	6a 00                	push   $0x0
80107525:	6a 07                	push   $0x7
80107527:	e9 3f f9 ff ff       	jmp    80106e6b <alltraps>

8010752c <vector8>:
8010752c:	6a 08                	push   $0x8
8010752e:	e9 38 f9 ff ff       	jmp    80106e6b <alltraps>

80107533 <vector9>:
80107533:	6a 00                	push   $0x0
80107535:	6a 09                	push   $0x9
80107537:	e9 2f f9 ff ff       	jmp    80106e6b <alltraps>

8010753c <vector10>:
8010753c:	6a 0a                	push   $0xa
8010753e:	e9 28 f9 ff ff       	jmp    80106e6b <alltraps>

80107543 <vector11>:
80107543:	6a 0b                	push   $0xb
80107545:	e9 21 f9 ff ff       	jmp    80106e6b <alltraps>

8010754a <vector12>:
8010754a:	6a 0c                	push   $0xc
8010754c:	e9 1a f9 ff ff       	jmp    80106e6b <alltraps>

80107551 <vector13>:
80107551:	6a 0d                	push   $0xd
80107553:	e9 13 f9 ff ff       	jmp    80106e6b <alltraps>

80107558 <vector14>:
80107558:	6a 0e                	push   $0xe
8010755a:	e9 0c f9 ff ff       	jmp    80106e6b <alltraps>

8010755f <vector15>:
8010755f:	6a 00                	push   $0x0
80107561:	6a 0f                	push   $0xf
80107563:	e9 03 f9 ff ff       	jmp    80106e6b <alltraps>

80107568 <vector16>:
80107568:	6a 00                	push   $0x0
8010756a:	6a 10                	push   $0x10
8010756c:	e9 fa f8 ff ff       	jmp    80106e6b <alltraps>

80107571 <vector17>:
80107571:	6a 11                	push   $0x11
80107573:	e9 f3 f8 ff ff       	jmp    80106e6b <alltraps>

80107578 <vector18>:
80107578:	6a 00                	push   $0x0
8010757a:	6a 12                	push   $0x12
8010757c:	e9 ea f8 ff ff       	jmp    80106e6b <alltraps>

80107581 <vector19>:
80107581:	6a 00                	push   $0x0
80107583:	6a 13                	push   $0x13
80107585:	e9 e1 f8 ff ff       	jmp    80106e6b <alltraps>

8010758a <vector20>:
8010758a:	6a 00                	push   $0x0
8010758c:	6a 14                	push   $0x14
8010758e:	e9 d8 f8 ff ff       	jmp    80106e6b <alltraps>

80107593 <vector21>:
80107593:	6a 00                	push   $0x0
80107595:	6a 15                	push   $0x15
80107597:	e9 cf f8 ff ff       	jmp    80106e6b <alltraps>

8010759c <vector22>:
8010759c:	6a 00                	push   $0x0
8010759e:	6a 16                	push   $0x16
801075a0:	e9 c6 f8 ff ff       	jmp    80106e6b <alltraps>

801075a5 <vector23>:
801075a5:	6a 00                	push   $0x0
801075a7:	6a 17                	push   $0x17
801075a9:	e9 bd f8 ff ff       	jmp    80106e6b <alltraps>

801075ae <vector24>:
801075ae:	6a 00                	push   $0x0
801075b0:	6a 18                	push   $0x18
801075b2:	e9 b4 f8 ff ff       	jmp    80106e6b <alltraps>

801075b7 <vector25>:
801075b7:	6a 00                	push   $0x0
801075b9:	6a 19                	push   $0x19
801075bb:	e9 ab f8 ff ff       	jmp    80106e6b <alltraps>

801075c0 <vector26>:
801075c0:	6a 00                	push   $0x0
801075c2:	6a 1a                	push   $0x1a
801075c4:	e9 a2 f8 ff ff       	jmp    80106e6b <alltraps>

801075c9 <vector27>:
801075c9:	6a 00                	push   $0x0
801075cb:	6a 1b                	push   $0x1b
801075cd:	e9 99 f8 ff ff       	jmp    80106e6b <alltraps>

801075d2 <vector28>:
801075d2:	6a 00                	push   $0x0
801075d4:	6a 1c                	push   $0x1c
801075d6:	e9 90 f8 ff ff       	jmp    80106e6b <alltraps>

801075db <vector29>:
801075db:	6a 00                	push   $0x0
801075dd:	6a 1d                	push   $0x1d
801075df:	e9 87 f8 ff ff       	jmp    80106e6b <alltraps>

801075e4 <vector30>:
801075e4:	6a 00                	push   $0x0
801075e6:	6a 1e                	push   $0x1e
801075e8:	e9 7e f8 ff ff       	jmp    80106e6b <alltraps>

801075ed <vector31>:
801075ed:	6a 00                	push   $0x0
801075ef:	6a 1f                	push   $0x1f
801075f1:	e9 75 f8 ff ff       	jmp    80106e6b <alltraps>

801075f6 <vector32>:
801075f6:	6a 00                	push   $0x0
801075f8:	6a 20                	push   $0x20
801075fa:	e9 6c f8 ff ff       	jmp    80106e6b <alltraps>

801075ff <vector33>:
801075ff:	6a 00                	push   $0x0
80107601:	6a 21                	push   $0x21
80107603:	e9 63 f8 ff ff       	jmp    80106e6b <alltraps>

80107608 <vector34>:
80107608:	6a 00                	push   $0x0
8010760a:	6a 22                	push   $0x22
8010760c:	e9 5a f8 ff ff       	jmp    80106e6b <alltraps>

80107611 <vector35>:
80107611:	6a 00                	push   $0x0
80107613:	6a 23                	push   $0x23
80107615:	e9 51 f8 ff ff       	jmp    80106e6b <alltraps>

8010761a <vector36>:
8010761a:	6a 00                	push   $0x0
8010761c:	6a 24                	push   $0x24
8010761e:	e9 48 f8 ff ff       	jmp    80106e6b <alltraps>

80107623 <vector37>:
80107623:	6a 00                	push   $0x0
80107625:	6a 25                	push   $0x25
80107627:	e9 3f f8 ff ff       	jmp    80106e6b <alltraps>

8010762c <vector38>:
8010762c:	6a 00                	push   $0x0
8010762e:	6a 26                	push   $0x26
80107630:	e9 36 f8 ff ff       	jmp    80106e6b <alltraps>

80107635 <vector39>:
80107635:	6a 00                	push   $0x0
80107637:	6a 27                	push   $0x27
80107639:	e9 2d f8 ff ff       	jmp    80106e6b <alltraps>

8010763e <vector40>:
8010763e:	6a 00                	push   $0x0
80107640:	6a 28                	push   $0x28
80107642:	e9 24 f8 ff ff       	jmp    80106e6b <alltraps>

80107647 <vector41>:
80107647:	6a 00                	push   $0x0
80107649:	6a 29                	push   $0x29
8010764b:	e9 1b f8 ff ff       	jmp    80106e6b <alltraps>

80107650 <vector42>:
80107650:	6a 00                	push   $0x0
80107652:	6a 2a                	push   $0x2a
80107654:	e9 12 f8 ff ff       	jmp    80106e6b <alltraps>

80107659 <vector43>:
80107659:	6a 00                	push   $0x0
8010765b:	6a 2b                	push   $0x2b
8010765d:	e9 09 f8 ff ff       	jmp    80106e6b <alltraps>

80107662 <vector44>:
80107662:	6a 00                	push   $0x0
80107664:	6a 2c                	push   $0x2c
80107666:	e9 00 f8 ff ff       	jmp    80106e6b <alltraps>

8010766b <vector45>:
8010766b:	6a 00                	push   $0x0
8010766d:	6a 2d                	push   $0x2d
8010766f:	e9 f7 f7 ff ff       	jmp    80106e6b <alltraps>

80107674 <vector46>:
80107674:	6a 00                	push   $0x0
80107676:	6a 2e                	push   $0x2e
80107678:	e9 ee f7 ff ff       	jmp    80106e6b <alltraps>

8010767d <vector47>:
8010767d:	6a 00                	push   $0x0
8010767f:	6a 2f                	push   $0x2f
80107681:	e9 e5 f7 ff ff       	jmp    80106e6b <alltraps>

80107686 <vector48>:
80107686:	6a 00                	push   $0x0
80107688:	6a 30                	push   $0x30
8010768a:	e9 dc f7 ff ff       	jmp    80106e6b <alltraps>

8010768f <vector49>:
8010768f:	6a 00                	push   $0x0
80107691:	6a 31                	push   $0x31
80107693:	e9 d3 f7 ff ff       	jmp    80106e6b <alltraps>

80107698 <vector50>:
80107698:	6a 00                	push   $0x0
8010769a:	6a 32                	push   $0x32
8010769c:	e9 ca f7 ff ff       	jmp    80106e6b <alltraps>

801076a1 <vector51>:
801076a1:	6a 00                	push   $0x0
801076a3:	6a 33                	push   $0x33
801076a5:	e9 c1 f7 ff ff       	jmp    80106e6b <alltraps>

801076aa <vector52>:
801076aa:	6a 00                	push   $0x0
801076ac:	6a 34                	push   $0x34
801076ae:	e9 b8 f7 ff ff       	jmp    80106e6b <alltraps>

801076b3 <vector53>:
801076b3:	6a 00                	push   $0x0
801076b5:	6a 35                	push   $0x35
801076b7:	e9 af f7 ff ff       	jmp    80106e6b <alltraps>

801076bc <vector54>:
801076bc:	6a 00                	push   $0x0
801076be:	6a 36                	push   $0x36
801076c0:	e9 a6 f7 ff ff       	jmp    80106e6b <alltraps>

801076c5 <vector55>:
801076c5:	6a 00                	push   $0x0
801076c7:	6a 37                	push   $0x37
801076c9:	e9 9d f7 ff ff       	jmp    80106e6b <alltraps>

801076ce <vector56>:
801076ce:	6a 00                	push   $0x0
801076d0:	6a 38                	push   $0x38
801076d2:	e9 94 f7 ff ff       	jmp    80106e6b <alltraps>

801076d7 <vector57>:
801076d7:	6a 00                	push   $0x0
801076d9:	6a 39                	push   $0x39
801076db:	e9 8b f7 ff ff       	jmp    80106e6b <alltraps>

801076e0 <vector58>:
801076e0:	6a 00                	push   $0x0
801076e2:	6a 3a                	push   $0x3a
801076e4:	e9 82 f7 ff ff       	jmp    80106e6b <alltraps>

801076e9 <vector59>:
801076e9:	6a 00                	push   $0x0
801076eb:	6a 3b                	push   $0x3b
801076ed:	e9 79 f7 ff ff       	jmp    80106e6b <alltraps>

801076f2 <vector60>:
801076f2:	6a 00                	push   $0x0
801076f4:	6a 3c                	push   $0x3c
801076f6:	e9 70 f7 ff ff       	jmp    80106e6b <alltraps>

801076fb <vector61>:
801076fb:	6a 00                	push   $0x0
801076fd:	6a 3d                	push   $0x3d
801076ff:	e9 67 f7 ff ff       	jmp    80106e6b <alltraps>

80107704 <vector62>:
80107704:	6a 00                	push   $0x0
80107706:	6a 3e                	push   $0x3e
80107708:	e9 5e f7 ff ff       	jmp    80106e6b <alltraps>

8010770d <vector63>:
8010770d:	6a 00                	push   $0x0
8010770f:	6a 3f                	push   $0x3f
80107711:	e9 55 f7 ff ff       	jmp    80106e6b <alltraps>

80107716 <vector64>:
80107716:	6a 00                	push   $0x0
80107718:	6a 40                	push   $0x40
8010771a:	e9 4c f7 ff ff       	jmp    80106e6b <alltraps>

8010771f <vector65>:
8010771f:	6a 00                	push   $0x0
80107721:	6a 41                	push   $0x41
80107723:	e9 43 f7 ff ff       	jmp    80106e6b <alltraps>

80107728 <vector66>:
80107728:	6a 00                	push   $0x0
8010772a:	6a 42                	push   $0x42
8010772c:	e9 3a f7 ff ff       	jmp    80106e6b <alltraps>

80107731 <vector67>:
80107731:	6a 00                	push   $0x0
80107733:	6a 43                	push   $0x43
80107735:	e9 31 f7 ff ff       	jmp    80106e6b <alltraps>

8010773a <vector68>:
8010773a:	6a 00                	push   $0x0
8010773c:	6a 44                	push   $0x44
8010773e:	e9 28 f7 ff ff       	jmp    80106e6b <alltraps>

80107743 <vector69>:
80107743:	6a 00                	push   $0x0
80107745:	6a 45                	push   $0x45
80107747:	e9 1f f7 ff ff       	jmp    80106e6b <alltraps>

8010774c <vector70>:
8010774c:	6a 00                	push   $0x0
8010774e:	6a 46                	push   $0x46
80107750:	e9 16 f7 ff ff       	jmp    80106e6b <alltraps>

80107755 <vector71>:
80107755:	6a 00                	push   $0x0
80107757:	6a 47                	push   $0x47
80107759:	e9 0d f7 ff ff       	jmp    80106e6b <alltraps>

8010775e <vector72>:
8010775e:	6a 00                	push   $0x0
80107760:	6a 48                	push   $0x48
80107762:	e9 04 f7 ff ff       	jmp    80106e6b <alltraps>

80107767 <vector73>:
80107767:	6a 00                	push   $0x0
80107769:	6a 49                	push   $0x49
8010776b:	e9 fb f6 ff ff       	jmp    80106e6b <alltraps>

80107770 <vector74>:
80107770:	6a 00                	push   $0x0
80107772:	6a 4a                	push   $0x4a
80107774:	e9 f2 f6 ff ff       	jmp    80106e6b <alltraps>

80107779 <vector75>:
80107779:	6a 00                	push   $0x0
8010777b:	6a 4b                	push   $0x4b
8010777d:	e9 e9 f6 ff ff       	jmp    80106e6b <alltraps>

80107782 <vector76>:
80107782:	6a 00                	push   $0x0
80107784:	6a 4c                	push   $0x4c
80107786:	e9 e0 f6 ff ff       	jmp    80106e6b <alltraps>

8010778b <vector77>:
8010778b:	6a 00                	push   $0x0
8010778d:	6a 4d                	push   $0x4d
8010778f:	e9 d7 f6 ff ff       	jmp    80106e6b <alltraps>

80107794 <vector78>:
80107794:	6a 00                	push   $0x0
80107796:	6a 4e                	push   $0x4e
80107798:	e9 ce f6 ff ff       	jmp    80106e6b <alltraps>

8010779d <vector79>:
8010779d:	6a 00                	push   $0x0
8010779f:	6a 4f                	push   $0x4f
801077a1:	e9 c5 f6 ff ff       	jmp    80106e6b <alltraps>

801077a6 <vector80>:
801077a6:	6a 00                	push   $0x0
801077a8:	6a 50                	push   $0x50
801077aa:	e9 bc f6 ff ff       	jmp    80106e6b <alltraps>

801077af <vector81>:
801077af:	6a 00                	push   $0x0
801077b1:	6a 51                	push   $0x51
801077b3:	e9 b3 f6 ff ff       	jmp    80106e6b <alltraps>

801077b8 <vector82>:
801077b8:	6a 00                	push   $0x0
801077ba:	6a 52                	push   $0x52
801077bc:	e9 aa f6 ff ff       	jmp    80106e6b <alltraps>

801077c1 <vector83>:
801077c1:	6a 00                	push   $0x0
801077c3:	6a 53                	push   $0x53
801077c5:	e9 a1 f6 ff ff       	jmp    80106e6b <alltraps>

801077ca <vector84>:
801077ca:	6a 00                	push   $0x0
801077cc:	6a 54                	push   $0x54
801077ce:	e9 98 f6 ff ff       	jmp    80106e6b <alltraps>

801077d3 <vector85>:
801077d3:	6a 00                	push   $0x0
801077d5:	6a 55                	push   $0x55
801077d7:	e9 8f f6 ff ff       	jmp    80106e6b <alltraps>

801077dc <vector86>:
801077dc:	6a 00                	push   $0x0
801077de:	6a 56                	push   $0x56
801077e0:	e9 86 f6 ff ff       	jmp    80106e6b <alltraps>

801077e5 <vector87>:
801077e5:	6a 00                	push   $0x0
801077e7:	6a 57                	push   $0x57
801077e9:	e9 7d f6 ff ff       	jmp    80106e6b <alltraps>

801077ee <vector88>:
801077ee:	6a 00                	push   $0x0
801077f0:	6a 58                	push   $0x58
801077f2:	e9 74 f6 ff ff       	jmp    80106e6b <alltraps>

801077f7 <vector89>:
801077f7:	6a 00                	push   $0x0
801077f9:	6a 59                	push   $0x59
801077fb:	e9 6b f6 ff ff       	jmp    80106e6b <alltraps>

80107800 <vector90>:
80107800:	6a 00                	push   $0x0
80107802:	6a 5a                	push   $0x5a
80107804:	e9 62 f6 ff ff       	jmp    80106e6b <alltraps>

80107809 <vector91>:
80107809:	6a 00                	push   $0x0
8010780b:	6a 5b                	push   $0x5b
8010780d:	e9 59 f6 ff ff       	jmp    80106e6b <alltraps>

80107812 <vector92>:
80107812:	6a 00                	push   $0x0
80107814:	6a 5c                	push   $0x5c
80107816:	e9 50 f6 ff ff       	jmp    80106e6b <alltraps>

8010781b <vector93>:
8010781b:	6a 00                	push   $0x0
8010781d:	6a 5d                	push   $0x5d
8010781f:	e9 47 f6 ff ff       	jmp    80106e6b <alltraps>

80107824 <vector94>:
80107824:	6a 00                	push   $0x0
80107826:	6a 5e                	push   $0x5e
80107828:	e9 3e f6 ff ff       	jmp    80106e6b <alltraps>

8010782d <vector95>:
8010782d:	6a 00                	push   $0x0
8010782f:	6a 5f                	push   $0x5f
80107831:	e9 35 f6 ff ff       	jmp    80106e6b <alltraps>

80107836 <vector96>:
80107836:	6a 00                	push   $0x0
80107838:	6a 60                	push   $0x60
8010783a:	e9 2c f6 ff ff       	jmp    80106e6b <alltraps>

8010783f <vector97>:
8010783f:	6a 00                	push   $0x0
80107841:	6a 61                	push   $0x61
80107843:	e9 23 f6 ff ff       	jmp    80106e6b <alltraps>

80107848 <vector98>:
80107848:	6a 00                	push   $0x0
8010784a:	6a 62                	push   $0x62
8010784c:	e9 1a f6 ff ff       	jmp    80106e6b <alltraps>

80107851 <vector99>:
80107851:	6a 00                	push   $0x0
80107853:	6a 63                	push   $0x63
80107855:	e9 11 f6 ff ff       	jmp    80106e6b <alltraps>

8010785a <vector100>:
8010785a:	6a 00                	push   $0x0
8010785c:	6a 64                	push   $0x64
8010785e:	e9 08 f6 ff ff       	jmp    80106e6b <alltraps>

80107863 <vector101>:
80107863:	6a 00                	push   $0x0
80107865:	6a 65                	push   $0x65
80107867:	e9 ff f5 ff ff       	jmp    80106e6b <alltraps>

8010786c <vector102>:
8010786c:	6a 00                	push   $0x0
8010786e:	6a 66                	push   $0x66
80107870:	e9 f6 f5 ff ff       	jmp    80106e6b <alltraps>

80107875 <vector103>:
80107875:	6a 00                	push   $0x0
80107877:	6a 67                	push   $0x67
80107879:	e9 ed f5 ff ff       	jmp    80106e6b <alltraps>

8010787e <vector104>:
8010787e:	6a 00                	push   $0x0
80107880:	6a 68                	push   $0x68
80107882:	e9 e4 f5 ff ff       	jmp    80106e6b <alltraps>

80107887 <vector105>:
80107887:	6a 00                	push   $0x0
80107889:	6a 69                	push   $0x69
8010788b:	e9 db f5 ff ff       	jmp    80106e6b <alltraps>

80107890 <vector106>:
80107890:	6a 00                	push   $0x0
80107892:	6a 6a                	push   $0x6a
80107894:	e9 d2 f5 ff ff       	jmp    80106e6b <alltraps>

80107899 <vector107>:
80107899:	6a 00                	push   $0x0
8010789b:	6a 6b                	push   $0x6b
8010789d:	e9 c9 f5 ff ff       	jmp    80106e6b <alltraps>

801078a2 <vector108>:
801078a2:	6a 00                	push   $0x0
801078a4:	6a 6c                	push   $0x6c
801078a6:	e9 c0 f5 ff ff       	jmp    80106e6b <alltraps>

801078ab <vector109>:
801078ab:	6a 00                	push   $0x0
801078ad:	6a 6d                	push   $0x6d
801078af:	e9 b7 f5 ff ff       	jmp    80106e6b <alltraps>

801078b4 <vector110>:
801078b4:	6a 00                	push   $0x0
801078b6:	6a 6e                	push   $0x6e
801078b8:	e9 ae f5 ff ff       	jmp    80106e6b <alltraps>

801078bd <vector111>:
801078bd:	6a 00                	push   $0x0
801078bf:	6a 6f                	push   $0x6f
801078c1:	e9 a5 f5 ff ff       	jmp    80106e6b <alltraps>

801078c6 <vector112>:
801078c6:	6a 00                	push   $0x0
801078c8:	6a 70                	push   $0x70
801078ca:	e9 9c f5 ff ff       	jmp    80106e6b <alltraps>

801078cf <vector113>:
801078cf:	6a 00                	push   $0x0
801078d1:	6a 71                	push   $0x71
801078d3:	e9 93 f5 ff ff       	jmp    80106e6b <alltraps>

801078d8 <vector114>:
801078d8:	6a 00                	push   $0x0
801078da:	6a 72                	push   $0x72
801078dc:	e9 8a f5 ff ff       	jmp    80106e6b <alltraps>

801078e1 <vector115>:
801078e1:	6a 00                	push   $0x0
801078e3:	6a 73                	push   $0x73
801078e5:	e9 81 f5 ff ff       	jmp    80106e6b <alltraps>

801078ea <vector116>:
801078ea:	6a 00                	push   $0x0
801078ec:	6a 74                	push   $0x74
801078ee:	e9 78 f5 ff ff       	jmp    80106e6b <alltraps>

801078f3 <vector117>:
801078f3:	6a 00                	push   $0x0
801078f5:	6a 75                	push   $0x75
801078f7:	e9 6f f5 ff ff       	jmp    80106e6b <alltraps>

801078fc <vector118>:
801078fc:	6a 00                	push   $0x0
801078fe:	6a 76                	push   $0x76
80107900:	e9 66 f5 ff ff       	jmp    80106e6b <alltraps>

80107905 <vector119>:
80107905:	6a 00                	push   $0x0
80107907:	6a 77                	push   $0x77
80107909:	e9 5d f5 ff ff       	jmp    80106e6b <alltraps>

8010790e <vector120>:
8010790e:	6a 00                	push   $0x0
80107910:	6a 78                	push   $0x78
80107912:	e9 54 f5 ff ff       	jmp    80106e6b <alltraps>

80107917 <vector121>:
80107917:	6a 00                	push   $0x0
80107919:	6a 79                	push   $0x79
8010791b:	e9 4b f5 ff ff       	jmp    80106e6b <alltraps>

80107920 <vector122>:
80107920:	6a 00                	push   $0x0
80107922:	6a 7a                	push   $0x7a
80107924:	e9 42 f5 ff ff       	jmp    80106e6b <alltraps>

80107929 <vector123>:
80107929:	6a 00                	push   $0x0
8010792b:	6a 7b                	push   $0x7b
8010792d:	e9 39 f5 ff ff       	jmp    80106e6b <alltraps>

80107932 <vector124>:
80107932:	6a 00                	push   $0x0
80107934:	6a 7c                	push   $0x7c
80107936:	e9 30 f5 ff ff       	jmp    80106e6b <alltraps>

8010793b <vector125>:
8010793b:	6a 00                	push   $0x0
8010793d:	6a 7d                	push   $0x7d
8010793f:	e9 27 f5 ff ff       	jmp    80106e6b <alltraps>

80107944 <vector126>:
80107944:	6a 00                	push   $0x0
80107946:	6a 7e                	push   $0x7e
80107948:	e9 1e f5 ff ff       	jmp    80106e6b <alltraps>

8010794d <vector127>:
8010794d:	6a 00                	push   $0x0
8010794f:	6a 7f                	push   $0x7f
80107951:	e9 15 f5 ff ff       	jmp    80106e6b <alltraps>

80107956 <vector128>:
80107956:	6a 00                	push   $0x0
80107958:	68 80 00 00 00       	push   $0x80
8010795d:	e9 09 f5 ff ff       	jmp    80106e6b <alltraps>

80107962 <vector129>:
80107962:	6a 00                	push   $0x0
80107964:	68 81 00 00 00       	push   $0x81
80107969:	e9 fd f4 ff ff       	jmp    80106e6b <alltraps>

8010796e <vector130>:
8010796e:	6a 00                	push   $0x0
80107970:	68 82 00 00 00       	push   $0x82
80107975:	e9 f1 f4 ff ff       	jmp    80106e6b <alltraps>

8010797a <vector131>:
8010797a:	6a 00                	push   $0x0
8010797c:	68 83 00 00 00       	push   $0x83
80107981:	e9 e5 f4 ff ff       	jmp    80106e6b <alltraps>

80107986 <vector132>:
80107986:	6a 00                	push   $0x0
80107988:	68 84 00 00 00       	push   $0x84
8010798d:	e9 d9 f4 ff ff       	jmp    80106e6b <alltraps>

80107992 <vector133>:
80107992:	6a 00                	push   $0x0
80107994:	68 85 00 00 00       	push   $0x85
80107999:	e9 cd f4 ff ff       	jmp    80106e6b <alltraps>

8010799e <vector134>:
8010799e:	6a 00                	push   $0x0
801079a0:	68 86 00 00 00       	push   $0x86
801079a5:	e9 c1 f4 ff ff       	jmp    80106e6b <alltraps>

801079aa <vector135>:
801079aa:	6a 00                	push   $0x0
801079ac:	68 87 00 00 00       	push   $0x87
801079b1:	e9 b5 f4 ff ff       	jmp    80106e6b <alltraps>

801079b6 <vector136>:
801079b6:	6a 00                	push   $0x0
801079b8:	68 88 00 00 00       	push   $0x88
801079bd:	e9 a9 f4 ff ff       	jmp    80106e6b <alltraps>

801079c2 <vector137>:
801079c2:	6a 00                	push   $0x0
801079c4:	68 89 00 00 00       	push   $0x89
801079c9:	e9 9d f4 ff ff       	jmp    80106e6b <alltraps>

801079ce <vector138>:
801079ce:	6a 00                	push   $0x0
801079d0:	68 8a 00 00 00       	push   $0x8a
801079d5:	e9 91 f4 ff ff       	jmp    80106e6b <alltraps>

801079da <vector139>:
801079da:	6a 00                	push   $0x0
801079dc:	68 8b 00 00 00       	push   $0x8b
801079e1:	e9 85 f4 ff ff       	jmp    80106e6b <alltraps>

801079e6 <vector140>:
801079e6:	6a 00                	push   $0x0
801079e8:	68 8c 00 00 00       	push   $0x8c
801079ed:	e9 79 f4 ff ff       	jmp    80106e6b <alltraps>

801079f2 <vector141>:
801079f2:	6a 00                	push   $0x0
801079f4:	68 8d 00 00 00       	push   $0x8d
801079f9:	e9 6d f4 ff ff       	jmp    80106e6b <alltraps>

801079fe <vector142>:
801079fe:	6a 00                	push   $0x0
80107a00:	68 8e 00 00 00       	push   $0x8e
80107a05:	e9 61 f4 ff ff       	jmp    80106e6b <alltraps>

80107a0a <vector143>:
80107a0a:	6a 00                	push   $0x0
80107a0c:	68 8f 00 00 00       	push   $0x8f
80107a11:	e9 55 f4 ff ff       	jmp    80106e6b <alltraps>

80107a16 <vector144>:
80107a16:	6a 00                	push   $0x0
80107a18:	68 90 00 00 00       	push   $0x90
80107a1d:	e9 49 f4 ff ff       	jmp    80106e6b <alltraps>

80107a22 <vector145>:
80107a22:	6a 00                	push   $0x0
80107a24:	68 91 00 00 00       	push   $0x91
80107a29:	e9 3d f4 ff ff       	jmp    80106e6b <alltraps>

80107a2e <vector146>:
80107a2e:	6a 00                	push   $0x0
80107a30:	68 92 00 00 00       	push   $0x92
80107a35:	e9 31 f4 ff ff       	jmp    80106e6b <alltraps>

80107a3a <vector147>:
80107a3a:	6a 00                	push   $0x0
80107a3c:	68 93 00 00 00       	push   $0x93
80107a41:	e9 25 f4 ff ff       	jmp    80106e6b <alltraps>

80107a46 <vector148>:
80107a46:	6a 00                	push   $0x0
80107a48:	68 94 00 00 00       	push   $0x94
80107a4d:	e9 19 f4 ff ff       	jmp    80106e6b <alltraps>

80107a52 <vector149>:
80107a52:	6a 00                	push   $0x0
80107a54:	68 95 00 00 00       	push   $0x95
80107a59:	e9 0d f4 ff ff       	jmp    80106e6b <alltraps>

80107a5e <vector150>:
80107a5e:	6a 00                	push   $0x0
80107a60:	68 96 00 00 00       	push   $0x96
80107a65:	e9 01 f4 ff ff       	jmp    80106e6b <alltraps>

80107a6a <vector151>:
80107a6a:	6a 00                	push   $0x0
80107a6c:	68 97 00 00 00       	push   $0x97
80107a71:	e9 f5 f3 ff ff       	jmp    80106e6b <alltraps>

80107a76 <vector152>:
80107a76:	6a 00                	push   $0x0
80107a78:	68 98 00 00 00       	push   $0x98
80107a7d:	e9 e9 f3 ff ff       	jmp    80106e6b <alltraps>

80107a82 <vector153>:
80107a82:	6a 00                	push   $0x0
80107a84:	68 99 00 00 00       	push   $0x99
80107a89:	e9 dd f3 ff ff       	jmp    80106e6b <alltraps>

80107a8e <vector154>:
80107a8e:	6a 00                	push   $0x0
80107a90:	68 9a 00 00 00       	push   $0x9a
80107a95:	e9 d1 f3 ff ff       	jmp    80106e6b <alltraps>

80107a9a <vector155>:
80107a9a:	6a 00                	push   $0x0
80107a9c:	68 9b 00 00 00       	push   $0x9b
80107aa1:	e9 c5 f3 ff ff       	jmp    80106e6b <alltraps>

80107aa6 <vector156>:
80107aa6:	6a 00                	push   $0x0
80107aa8:	68 9c 00 00 00       	push   $0x9c
80107aad:	e9 b9 f3 ff ff       	jmp    80106e6b <alltraps>

80107ab2 <vector157>:
80107ab2:	6a 00                	push   $0x0
80107ab4:	68 9d 00 00 00       	push   $0x9d
80107ab9:	e9 ad f3 ff ff       	jmp    80106e6b <alltraps>

80107abe <vector158>:
80107abe:	6a 00                	push   $0x0
80107ac0:	68 9e 00 00 00       	push   $0x9e
80107ac5:	e9 a1 f3 ff ff       	jmp    80106e6b <alltraps>

80107aca <vector159>:
80107aca:	6a 00                	push   $0x0
80107acc:	68 9f 00 00 00       	push   $0x9f
80107ad1:	e9 95 f3 ff ff       	jmp    80106e6b <alltraps>

80107ad6 <vector160>:
80107ad6:	6a 00                	push   $0x0
80107ad8:	68 a0 00 00 00       	push   $0xa0
80107add:	e9 89 f3 ff ff       	jmp    80106e6b <alltraps>

80107ae2 <vector161>:
80107ae2:	6a 00                	push   $0x0
80107ae4:	68 a1 00 00 00       	push   $0xa1
80107ae9:	e9 7d f3 ff ff       	jmp    80106e6b <alltraps>

80107aee <vector162>:
80107aee:	6a 00                	push   $0x0
80107af0:	68 a2 00 00 00       	push   $0xa2
80107af5:	e9 71 f3 ff ff       	jmp    80106e6b <alltraps>

80107afa <vector163>:
80107afa:	6a 00                	push   $0x0
80107afc:	68 a3 00 00 00       	push   $0xa3
80107b01:	e9 65 f3 ff ff       	jmp    80106e6b <alltraps>

80107b06 <vector164>:
80107b06:	6a 00                	push   $0x0
80107b08:	68 a4 00 00 00       	push   $0xa4
80107b0d:	e9 59 f3 ff ff       	jmp    80106e6b <alltraps>

80107b12 <vector165>:
80107b12:	6a 00                	push   $0x0
80107b14:	68 a5 00 00 00       	push   $0xa5
80107b19:	e9 4d f3 ff ff       	jmp    80106e6b <alltraps>

80107b1e <vector166>:
80107b1e:	6a 00                	push   $0x0
80107b20:	68 a6 00 00 00       	push   $0xa6
80107b25:	e9 41 f3 ff ff       	jmp    80106e6b <alltraps>

80107b2a <vector167>:
80107b2a:	6a 00                	push   $0x0
80107b2c:	68 a7 00 00 00       	push   $0xa7
80107b31:	e9 35 f3 ff ff       	jmp    80106e6b <alltraps>

80107b36 <vector168>:
80107b36:	6a 00                	push   $0x0
80107b38:	68 a8 00 00 00       	push   $0xa8
80107b3d:	e9 29 f3 ff ff       	jmp    80106e6b <alltraps>

80107b42 <vector169>:
80107b42:	6a 00                	push   $0x0
80107b44:	68 a9 00 00 00       	push   $0xa9
80107b49:	e9 1d f3 ff ff       	jmp    80106e6b <alltraps>

80107b4e <vector170>:
80107b4e:	6a 00                	push   $0x0
80107b50:	68 aa 00 00 00       	push   $0xaa
80107b55:	e9 11 f3 ff ff       	jmp    80106e6b <alltraps>

80107b5a <vector171>:
80107b5a:	6a 00                	push   $0x0
80107b5c:	68 ab 00 00 00       	push   $0xab
80107b61:	e9 05 f3 ff ff       	jmp    80106e6b <alltraps>

80107b66 <vector172>:
80107b66:	6a 00                	push   $0x0
80107b68:	68 ac 00 00 00       	push   $0xac
80107b6d:	e9 f9 f2 ff ff       	jmp    80106e6b <alltraps>

80107b72 <vector173>:
80107b72:	6a 00                	push   $0x0
80107b74:	68 ad 00 00 00       	push   $0xad
80107b79:	e9 ed f2 ff ff       	jmp    80106e6b <alltraps>

80107b7e <vector174>:
80107b7e:	6a 00                	push   $0x0
80107b80:	68 ae 00 00 00       	push   $0xae
80107b85:	e9 e1 f2 ff ff       	jmp    80106e6b <alltraps>

80107b8a <vector175>:
80107b8a:	6a 00                	push   $0x0
80107b8c:	68 af 00 00 00       	push   $0xaf
80107b91:	e9 d5 f2 ff ff       	jmp    80106e6b <alltraps>

80107b96 <vector176>:
80107b96:	6a 00                	push   $0x0
80107b98:	68 b0 00 00 00       	push   $0xb0
80107b9d:	e9 c9 f2 ff ff       	jmp    80106e6b <alltraps>

80107ba2 <vector177>:
80107ba2:	6a 00                	push   $0x0
80107ba4:	68 b1 00 00 00       	push   $0xb1
80107ba9:	e9 bd f2 ff ff       	jmp    80106e6b <alltraps>

80107bae <vector178>:
80107bae:	6a 00                	push   $0x0
80107bb0:	68 b2 00 00 00       	push   $0xb2
80107bb5:	e9 b1 f2 ff ff       	jmp    80106e6b <alltraps>

80107bba <vector179>:
80107bba:	6a 00                	push   $0x0
80107bbc:	68 b3 00 00 00       	push   $0xb3
80107bc1:	e9 a5 f2 ff ff       	jmp    80106e6b <alltraps>

80107bc6 <vector180>:
80107bc6:	6a 00                	push   $0x0
80107bc8:	68 b4 00 00 00       	push   $0xb4
80107bcd:	e9 99 f2 ff ff       	jmp    80106e6b <alltraps>

80107bd2 <vector181>:
80107bd2:	6a 00                	push   $0x0
80107bd4:	68 b5 00 00 00       	push   $0xb5
80107bd9:	e9 8d f2 ff ff       	jmp    80106e6b <alltraps>

80107bde <vector182>:
80107bde:	6a 00                	push   $0x0
80107be0:	68 b6 00 00 00       	push   $0xb6
80107be5:	e9 81 f2 ff ff       	jmp    80106e6b <alltraps>

80107bea <vector183>:
80107bea:	6a 00                	push   $0x0
80107bec:	68 b7 00 00 00       	push   $0xb7
80107bf1:	e9 75 f2 ff ff       	jmp    80106e6b <alltraps>

80107bf6 <vector184>:
80107bf6:	6a 00                	push   $0x0
80107bf8:	68 b8 00 00 00       	push   $0xb8
80107bfd:	e9 69 f2 ff ff       	jmp    80106e6b <alltraps>

80107c02 <vector185>:
80107c02:	6a 00                	push   $0x0
80107c04:	68 b9 00 00 00       	push   $0xb9
80107c09:	e9 5d f2 ff ff       	jmp    80106e6b <alltraps>

80107c0e <vector186>:
80107c0e:	6a 00                	push   $0x0
80107c10:	68 ba 00 00 00       	push   $0xba
80107c15:	e9 51 f2 ff ff       	jmp    80106e6b <alltraps>

80107c1a <vector187>:
80107c1a:	6a 00                	push   $0x0
80107c1c:	68 bb 00 00 00       	push   $0xbb
80107c21:	e9 45 f2 ff ff       	jmp    80106e6b <alltraps>

80107c26 <vector188>:
80107c26:	6a 00                	push   $0x0
80107c28:	68 bc 00 00 00       	push   $0xbc
80107c2d:	e9 39 f2 ff ff       	jmp    80106e6b <alltraps>

80107c32 <vector189>:
80107c32:	6a 00                	push   $0x0
80107c34:	68 bd 00 00 00       	push   $0xbd
80107c39:	e9 2d f2 ff ff       	jmp    80106e6b <alltraps>

80107c3e <vector190>:
80107c3e:	6a 00                	push   $0x0
80107c40:	68 be 00 00 00       	push   $0xbe
80107c45:	e9 21 f2 ff ff       	jmp    80106e6b <alltraps>

80107c4a <vector191>:
80107c4a:	6a 00                	push   $0x0
80107c4c:	68 bf 00 00 00       	push   $0xbf
80107c51:	e9 15 f2 ff ff       	jmp    80106e6b <alltraps>

80107c56 <vector192>:
80107c56:	6a 00                	push   $0x0
80107c58:	68 c0 00 00 00       	push   $0xc0
80107c5d:	e9 09 f2 ff ff       	jmp    80106e6b <alltraps>

80107c62 <vector193>:
80107c62:	6a 00                	push   $0x0
80107c64:	68 c1 00 00 00       	push   $0xc1
80107c69:	e9 fd f1 ff ff       	jmp    80106e6b <alltraps>

80107c6e <vector194>:
80107c6e:	6a 00                	push   $0x0
80107c70:	68 c2 00 00 00       	push   $0xc2
80107c75:	e9 f1 f1 ff ff       	jmp    80106e6b <alltraps>

80107c7a <vector195>:
80107c7a:	6a 00                	push   $0x0
80107c7c:	68 c3 00 00 00       	push   $0xc3
80107c81:	e9 e5 f1 ff ff       	jmp    80106e6b <alltraps>

80107c86 <vector196>:
80107c86:	6a 00                	push   $0x0
80107c88:	68 c4 00 00 00       	push   $0xc4
80107c8d:	e9 d9 f1 ff ff       	jmp    80106e6b <alltraps>

80107c92 <vector197>:
80107c92:	6a 00                	push   $0x0
80107c94:	68 c5 00 00 00       	push   $0xc5
80107c99:	e9 cd f1 ff ff       	jmp    80106e6b <alltraps>

80107c9e <vector198>:
80107c9e:	6a 00                	push   $0x0
80107ca0:	68 c6 00 00 00       	push   $0xc6
80107ca5:	e9 c1 f1 ff ff       	jmp    80106e6b <alltraps>

80107caa <vector199>:
80107caa:	6a 00                	push   $0x0
80107cac:	68 c7 00 00 00       	push   $0xc7
80107cb1:	e9 b5 f1 ff ff       	jmp    80106e6b <alltraps>

80107cb6 <vector200>:
80107cb6:	6a 00                	push   $0x0
80107cb8:	68 c8 00 00 00       	push   $0xc8
80107cbd:	e9 a9 f1 ff ff       	jmp    80106e6b <alltraps>

80107cc2 <vector201>:
80107cc2:	6a 00                	push   $0x0
80107cc4:	68 c9 00 00 00       	push   $0xc9
80107cc9:	e9 9d f1 ff ff       	jmp    80106e6b <alltraps>

80107cce <vector202>:
80107cce:	6a 00                	push   $0x0
80107cd0:	68 ca 00 00 00       	push   $0xca
80107cd5:	e9 91 f1 ff ff       	jmp    80106e6b <alltraps>

80107cda <vector203>:
80107cda:	6a 00                	push   $0x0
80107cdc:	68 cb 00 00 00       	push   $0xcb
80107ce1:	e9 85 f1 ff ff       	jmp    80106e6b <alltraps>

80107ce6 <vector204>:
80107ce6:	6a 00                	push   $0x0
80107ce8:	68 cc 00 00 00       	push   $0xcc
80107ced:	e9 79 f1 ff ff       	jmp    80106e6b <alltraps>

80107cf2 <vector205>:
80107cf2:	6a 00                	push   $0x0
80107cf4:	68 cd 00 00 00       	push   $0xcd
80107cf9:	e9 6d f1 ff ff       	jmp    80106e6b <alltraps>

80107cfe <vector206>:
80107cfe:	6a 00                	push   $0x0
80107d00:	68 ce 00 00 00       	push   $0xce
80107d05:	e9 61 f1 ff ff       	jmp    80106e6b <alltraps>

80107d0a <vector207>:
80107d0a:	6a 00                	push   $0x0
80107d0c:	68 cf 00 00 00       	push   $0xcf
80107d11:	e9 55 f1 ff ff       	jmp    80106e6b <alltraps>

80107d16 <vector208>:
80107d16:	6a 00                	push   $0x0
80107d18:	68 d0 00 00 00       	push   $0xd0
80107d1d:	e9 49 f1 ff ff       	jmp    80106e6b <alltraps>

80107d22 <vector209>:
80107d22:	6a 00                	push   $0x0
80107d24:	68 d1 00 00 00       	push   $0xd1
80107d29:	e9 3d f1 ff ff       	jmp    80106e6b <alltraps>

80107d2e <vector210>:
80107d2e:	6a 00                	push   $0x0
80107d30:	68 d2 00 00 00       	push   $0xd2
80107d35:	e9 31 f1 ff ff       	jmp    80106e6b <alltraps>

80107d3a <vector211>:
80107d3a:	6a 00                	push   $0x0
80107d3c:	68 d3 00 00 00       	push   $0xd3
80107d41:	e9 25 f1 ff ff       	jmp    80106e6b <alltraps>

80107d46 <vector212>:
80107d46:	6a 00                	push   $0x0
80107d48:	68 d4 00 00 00       	push   $0xd4
80107d4d:	e9 19 f1 ff ff       	jmp    80106e6b <alltraps>

80107d52 <vector213>:
80107d52:	6a 00                	push   $0x0
80107d54:	68 d5 00 00 00       	push   $0xd5
80107d59:	e9 0d f1 ff ff       	jmp    80106e6b <alltraps>

80107d5e <vector214>:
80107d5e:	6a 00                	push   $0x0
80107d60:	68 d6 00 00 00       	push   $0xd6
80107d65:	e9 01 f1 ff ff       	jmp    80106e6b <alltraps>

80107d6a <vector215>:
80107d6a:	6a 00                	push   $0x0
80107d6c:	68 d7 00 00 00       	push   $0xd7
80107d71:	e9 f5 f0 ff ff       	jmp    80106e6b <alltraps>

80107d76 <vector216>:
80107d76:	6a 00                	push   $0x0
80107d78:	68 d8 00 00 00       	push   $0xd8
80107d7d:	e9 e9 f0 ff ff       	jmp    80106e6b <alltraps>

80107d82 <vector217>:
80107d82:	6a 00                	push   $0x0
80107d84:	68 d9 00 00 00       	push   $0xd9
80107d89:	e9 dd f0 ff ff       	jmp    80106e6b <alltraps>

80107d8e <vector218>:
80107d8e:	6a 00                	push   $0x0
80107d90:	68 da 00 00 00       	push   $0xda
80107d95:	e9 d1 f0 ff ff       	jmp    80106e6b <alltraps>

80107d9a <vector219>:
80107d9a:	6a 00                	push   $0x0
80107d9c:	68 db 00 00 00       	push   $0xdb
80107da1:	e9 c5 f0 ff ff       	jmp    80106e6b <alltraps>

80107da6 <vector220>:
80107da6:	6a 00                	push   $0x0
80107da8:	68 dc 00 00 00       	push   $0xdc
80107dad:	e9 b9 f0 ff ff       	jmp    80106e6b <alltraps>

80107db2 <vector221>:
80107db2:	6a 00                	push   $0x0
80107db4:	68 dd 00 00 00       	push   $0xdd
80107db9:	e9 ad f0 ff ff       	jmp    80106e6b <alltraps>

80107dbe <vector222>:
80107dbe:	6a 00                	push   $0x0
80107dc0:	68 de 00 00 00       	push   $0xde
80107dc5:	e9 a1 f0 ff ff       	jmp    80106e6b <alltraps>

80107dca <vector223>:
80107dca:	6a 00                	push   $0x0
80107dcc:	68 df 00 00 00       	push   $0xdf
80107dd1:	e9 95 f0 ff ff       	jmp    80106e6b <alltraps>

80107dd6 <vector224>:
80107dd6:	6a 00                	push   $0x0
80107dd8:	68 e0 00 00 00       	push   $0xe0
80107ddd:	e9 89 f0 ff ff       	jmp    80106e6b <alltraps>

80107de2 <vector225>:
80107de2:	6a 00                	push   $0x0
80107de4:	68 e1 00 00 00       	push   $0xe1
80107de9:	e9 7d f0 ff ff       	jmp    80106e6b <alltraps>

80107dee <vector226>:
80107dee:	6a 00                	push   $0x0
80107df0:	68 e2 00 00 00       	push   $0xe2
80107df5:	e9 71 f0 ff ff       	jmp    80106e6b <alltraps>

80107dfa <vector227>:
80107dfa:	6a 00                	push   $0x0
80107dfc:	68 e3 00 00 00       	push   $0xe3
80107e01:	e9 65 f0 ff ff       	jmp    80106e6b <alltraps>

80107e06 <vector228>:
80107e06:	6a 00                	push   $0x0
80107e08:	68 e4 00 00 00       	push   $0xe4
80107e0d:	e9 59 f0 ff ff       	jmp    80106e6b <alltraps>

80107e12 <vector229>:
80107e12:	6a 00                	push   $0x0
80107e14:	68 e5 00 00 00       	push   $0xe5
80107e19:	e9 4d f0 ff ff       	jmp    80106e6b <alltraps>

80107e1e <vector230>:
80107e1e:	6a 00                	push   $0x0
80107e20:	68 e6 00 00 00       	push   $0xe6
80107e25:	e9 41 f0 ff ff       	jmp    80106e6b <alltraps>

80107e2a <vector231>:
80107e2a:	6a 00                	push   $0x0
80107e2c:	68 e7 00 00 00       	push   $0xe7
80107e31:	e9 35 f0 ff ff       	jmp    80106e6b <alltraps>

80107e36 <vector232>:
80107e36:	6a 00                	push   $0x0
80107e38:	68 e8 00 00 00       	push   $0xe8
80107e3d:	e9 29 f0 ff ff       	jmp    80106e6b <alltraps>

80107e42 <vector233>:
80107e42:	6a 00                	push   $0x0
80107e44:	68 e9 00 00 00       	push   $0xe9
80107e49:	e9 1d f0 ff ff       	jmp    80106e6b <alltraps>

80107e4e <vector234>:
80107e4e:	6a 00                	push   $0x0
80107e50:	68 ea 00 00 00       	push   $0xea
80107e55:	e9 11 f0 ff ff       	jmp    80106e6b <alltraps>

80107e5a <vector235>:
80107e5a:	6a 00                	push   $0x0
80107e5c:	68 eb 00 00 00       	push   $0xeb
80107e61:	e9 05 f0 ff ff       	jmp    80106e6b <alltraps>

80107e66 <vector236>:
80107e66:	6a 00                	push   $0x0
80107e68:	68 ec 00 00 00       	push   $0xec
80107e6d:	e9 f9 ef ff ff       	jmp    80106e6b <alltraps>

80107e72 <vector237>:
80107e72:	6a 00                	push   $0x0
80107e74:	68 ed 00 00 00       	push   $0xed
80107e79:	e9 ed ef ff ff       	jmp    80106e6b <alltraps>

80107e7e <vector238>:
80107e7e:	6a 00                	push   $0x0
80107e80:	68 ee 00 00 00       	push   $0xee
80107e85:	e9 e1 ef ff ff       	jmp    80106e6b <alltraps>

80107e8a <vector239>:
80107e8a:	6a 00                	push   $0x0
80107e8c:	68 ef 00 00 00       	push   $0xef
80107e91:	e9 d5 ef ff ff       	jmp    80106e6b <alltraps>

80107e96 <vector240>:
80107e96:	6a 00                	push   $0x0
80107e98:	68 f0 00 00 00       	push   $0xf0
80107e9d:	e9 c9 ef ff ff       	jmp    80106e6b <alltraps>

80107ea2 <vector241>:
80107ea2:	6a 00                	push   $0x0
80107ea4:	68 f1 00 00 00       	push   $0xf1
80107ea9:	e9 bd ef ff ff       	jmp    80106e6b <alltraps>

80107eae <vector242>:
80107eae:	6a 00                	push   $0x0
80107eb0:	68 f2 00 00 00       	push   $0xf2
80107eb5:	e9 b1 ef ff ff       	jmp    80106e6b <alltraps>

80107eba <vector243>:
80107eba:	6a 00                	push   $0x0
80107ebc:	68 f3 00 00 00       	push   $0xf3
80107ec1:	e9 a5 ef ff ff       	jmp    80106e6b <alltraps>

80107ec6 <vector244>:
80107ec6:	6a 00                	push   $0x0
80107ec8:	68 f4 00 00 00       	push   $0xf4
80107ecd:	e9 99 ef ff ff       	jmp    80106e6b <alltraps>

80107ed2 <vector245>:
80107ed2:	6a 00                	push   $0x0
80107ed4:	68 f5 00 00 00       	push   $0xf5
80107ed9:	e9 8d ef ff ff       	jmp    80106e6b <alltraps>

80107ede <vector246>:
80107ede:	6a 00                	push   $0x0
80107ee0:	68 f6 00 00 00       	push   $0xf6
80107ee5:	e9 81 ef ff ff       	jmp    80106e6b <alltraps>

80107eea <vector247>:
80107eea:	6a 00                	push   $0x0
80107eec:	68 f7 00 00 00       	push   $0xf7
80107ef1:	e9 75 ef ff ff       	jmp    80106e6b <alltraps>

80107ef6 <vector248>:
80107ef6:	6a 00                	push   $0x0
80107ef8:	68 f8 00 00 00       	push   $0xf8
80107efd:	e9 69 ef ff ff       	jmp    80106e6b <alltraps>

80107f02 <vector249>:
80107f02:	6a 00                	push   $0x0
80107f04:	68 f9 00 00 00       	push   $0xf9
80107f09:	e9 5d ef ff ff       	jmp    80106e6b <alltraps>

80107f0e <vector250>:
80107f0e:	6a 00                	push   $0x0
80107f10:	68 fa 00 00 00       	push   $0xfa
80107f15:	e9 51 ef ff ff       	jmp    80106e6b <alltraps>

80107f1a <vector251>:
80107f1a:	6a 00                	push   $0x0
80107f1c:	68 fb 00 00 00       	push   $0xfb
80107f21:	e9 45 ef ff ff       	jmp    80106e6b <alltraps>

80107f26 <vector252>:
80107f26:	6a 00                	push   $0x0
80107f28:	68 fc 00 00 00       	push   $0xfc
80107f2d:	e9 39 ef ff ff       	jmp    80106e6b <alltraps>

80107f32 <vector253>:
80107f32:	6a 00                	push   $0x0
80107f34:	68 fd 00 00 00       	push   $0xfd
80107f39:	e9 2d ef ff ff       	jmp    80106e6b <alltraps>

80107f3e <vector254>:
80107f3e:	6a 00                	push   $0x0
80107f40:	68 fe 00 00 00       	push   $0xfe
80107f45:	e9 21 ef ff ff       	jmp    80106e6b <alltraps>

80107f4a <vector255>:
80107f4a:	6a 00                	push   $0x0
80107f4c:	68 ff 00 00 00       	push   $0xff
80107f51:	e9 15 ef ff ff       	jmp    80106e6b <alltraps>

80107f56 <lgdt>:
{
80107f56:	55                   	push   %ebp
80107f57:	89 e5                	mov    %esp,%ebp
80107f59:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f5f:	48                   	dec    %eax
80107f60:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107f64:	8b 45 08             	mov    0x8(%ebp),%eax
80107f67:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f6e:	c1 e8 10             	shr    $0x10,%eax
80107f71:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80107f75:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107f78:	0f 01 10             	lgdtl  (%eax)
}
80107f7b:	c9                   	leave  
80107f7c:	c3                   	ret    

80107f7d <ltr>:
{
80107f7d:	55                   	push   %ebp
80107f7e:	89 e5                	mov    %esp,%ebp
80107f80:	83 ec 04             	sub    $0x4,%esp
80107f83:	8b 45 08             	mov    0x8(%ebp),%eax
80107f86:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107f8d:	0f 00 d8             	ltr    %ax
}
80107f90:	c9                   	leave  
80107f91:	c3                   	ret    

80107f92 <loadgs>:
{
80107f92:	55                   	push   %ebp
80107f93:	89 e5                	mov    %esp,%ebp
80107f95:	83 ec 04             	sub    $0x4,%esp
80107f98:	8b 45 08             	mov    0x8(%ebp),%eax
80107f9b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107fa2:	8e e8                	mov    %eax,%gs
}
80107fa4:	c9                   	leave  
80107fa5:	c3                   	ret    

80107fa6 <lcr3>:

static inline void
lcr3(uint val) 
{
80107fa6:	55                   	push   %ebp
80107fa7:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80107fac:	0f 22 d8             	mov    %eax,%cr3
}
80107faf:	5d                   	pop    %ebp
80107fb0:	c3                   	ret    

80107fb1 <v2p>:
80107fb1:	55                   	push   %ebp
80107fb2:	89 e5                	mov    %esp,%ebp
80107fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb7:	05 00 00 00 80       	add    $0x80000000,%eax
80107fbc:	5d                   	pop    %ebp
80107fbd:	c3                   	ret    

80107fbe <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107fbe:	55                   	push   %ebp
80107fbf:	89 e5                	mov    %esp,%ebp
80107fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80107fc4:	05 00 00 00 80       	add    $0x80000000,%eax
80107fc9:	5d                   	pop    %ebp
80107fca:	c3                   	ret    

80107fcb <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107fcb:	55                   	push   %ebp
80107fcc:	89 e5                	mov    %esp,%ebp
80107fce:	53                   	push   %ebx
80107fcf:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107fd2:	e8 6e ae ff ff       	call   80102e45 <cpunum>
80107fd7:	89 c2                	mov    %eax,%edx
80107fd9:	89 d0                	mov    %edx,%eax
80107fdb:	d1 e0                	shl    %eax
80107fdd:	01 d0                	add    %edx,%eax
80107fdf:	c1 e0 04             	shl    $0x4,%eax
80107fe2:	29 d0                	sub    %edx,%eax
80107fe4:	c1 e0 02             	shl    $0x2,%eax
80107fe7:	05 60 09 11 80       	add    $0x80110960,%eax
80107fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ffb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108001:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108004:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108008:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800b:	8a 50 7d             	mov    0x7d(%eax),%dl
8010800e:	83 e2 f0             	and    $0xfffffff0,%edx
80108011:	83 ca 0a             	or     $0xa,%edx
80108014:	88 50 7d             	mov    %dl,0x7d(%eax)
80108017:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801a:	8a 50 7d             	mov    0x7d(%eax),%dl
8010801d:	83 ca 10             	or     $0x10,%edx
80108020:	88 50 7d             	mov    %dl,0x7d(%eax)
80108023:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108026:	8a 50 7d             	mov    0x7d(%eax),%dl
80108029:	83 e2 9f             	and    $0xffffff9f,%edx
8010802c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010802f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108032:	8a 50 7d             	mov    0x7d(%eax),%dl
80108035:	83 ca 80             	or     $0xffffff80,%edx
80108038:	88 50 7d             	mov    %dl,0x7d(%eax)
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	8a 50 7e             	mov    0x7e(%eax),%dl
80108041:	83 ca 0f             	or     $0xf,%edx
80108044:	88 50 7e             	mov    %dl,0x7e(%eax)
80108047:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804a:	8a 50 7e             	mov    0x7e(%eax),%dl
8010804d:	83 e2 ef             	and    $0xffffffef,%edx
80108050:	88 50 7e             	mov    %dl,0x7e(%eax)
80108053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108056:	8a 50 7e             	mov    0x7e(%eax),%dl
80108059:	83 e2 df             	and    $0xffffffdf,%edx
8010805c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010805f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108062:	8a 50 7e             	mov    0x7e(%eax),%dl
80108065:	83 ca 40             	or     $0x40,%edx
80108068:	88 50 7e             	mov    %dl,0x7e(%eax)
8010806b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010806e:	8a 50 7e             	mov    0x7e(%eax),%dl
80108071:	83 ca 80             	or     $0xffffff80,%edx
80108074:	88 50 7e             	mov    %dl,0x7e(%eax)
80108077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807a:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010807e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108081:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108088:	ff ff 
8010808a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808d:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108094:	00 00 
80108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108099:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801080a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a3:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080a9:	83 e2 f0             	and    $0xfffffff0,%edx
801080ac:	83 ca 02             	or     $0x2,%edx
801080af:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b8:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080be:	83 ca 10             	or     $0x10,%edx
801080c1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ca:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080d0:	83 e2 9f             	and    $0xffffff9f,%edx
801080d3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dc:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801080e2:	83 ca 80             	or     $0xffffff80,%edx
801080e5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801080eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ee:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801080f4:	83 ca 0f             	or     $0xf,%edx
801080f7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108100:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108106:	83 e2 ef             	and    $0xffffffef,%edx
80108109:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010810f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108112:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80108118:	83 e2 df             	and    $0xffffffdf,%edx
8010811b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108121:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108124:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010812a:	83 ca 40             	or     $0x40,%edx
8010812d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108133:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108136:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010813c:	83 ca 80             	or     $0xffffff80,%edx
8010813f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108148:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010814f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108152:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108159:	ff ff 
8010815b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815e:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108165:	00 00 
80108167:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816a:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108171:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108174:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010817a:	83 e2 f0             	and    $0xfffffff0,%edx
8010817d:	83 ca 0a             	or     $0xa,%edx
80108180:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108189:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
8010818f:	83 ca 10             	or     $0x10,%edx
80108192:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010819b:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801081a1:	83 ca 60             	or     $0x60,%edx
801081a4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ad:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801081b3:	83 ca 80             	or     $0xffffff80,%edx
801081b6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801081bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bf:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081c5:	83 ca 0f             	or     $0xf,%edx
801081c8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081d1:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081d7:	83 e2 ef             	and    $0xffffffef,%edx
801081da:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e3:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081e9:	83 e2 df             	and    $0xffffffdf,%edx
801081ec:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801081fb:	83 ca 40             	or     $0x40,%edx
801081fe:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108207:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010820d:	83 ca 80             	or     $0xffffff80,%edx
80108210:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108216:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108219:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108223:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010822a:	ff ff 
8010822c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822f:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108236:	00 00 
80108238:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010823b:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108245:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010824b:	83 e2 f0             	and    $0xfffffff0,%edx
8010824e:	83 ca 02             	or     $0x2,%edx
80108251:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825a:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108260:	83 ca 10             	or     $0x10,%edx
80108263:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108269:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010826c:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108272:	83 ca 60             	or     $0x60,%edx
80108275:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010827b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827e:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80108284:	83 ca 80             	or     $0xffffff80,%edx
80108287:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010828d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108290:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80108296:	83 ca 0f             	or     $0xf,%edx
80108299:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010829f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a2:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801082a8:	83 e2 ef             	and    $0xffffffef,%edx
801082ab:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b4:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801082ba:	83 e2 df             	and    $0xffffffdf,%edx
801082bd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c6:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801082cc:	83 ca 40             	or     $0x40,%edx
801082cf:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d8:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801082de:	83 ca 80             	or     $0xffffff80,%edx
801082e1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801082e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ea:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801082f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f4:	05 b4 00 00 00       	add    $0xb4,%eax
801082f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082fc:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80108302:	c1 ea 10             	shr    $0x10,%edx
80108305:	88 d1                	mov    %dl,%cl
80108307:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010830a:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80108310:	c1 ea 18             	shr    $0x18,%edx
80108313:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80108316:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
8010831d:	00 00 
8010831f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80108322:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80108329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010832c:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80108332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108335:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010833b:	83 e1 f0             	and    $0xfffffff0,%ecx
8010833e:	83 c9 02             	or     $0x2,%ecx
80108341:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834a:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108350:	83 c9 10             	or     $0x10,%ecx
80108353:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835c:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108362:	83 e1 9f             	and    $0xffffff9f,%ecx
80108365:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010836b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836e:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80108374:	83 c9 80             	or     $0xffffff80,%ecx
80108377:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010837d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108380:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108386:	83 e1 f0             	and    $0xfffffff0,%ecx
80108389:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010838f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108392:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80108398:	83 e1 ef             	and    $0xffffffef,%ecx
8010839b:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a4:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801083aa:	83 e1 df             	and    $0xffffffdf,%ecx
801083ad:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b6:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801083bc:	83 c9 40             	or     $0x40,%ecx
801083bf:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083c8:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801083ce:	83 c9 80             	or     $0xffffff80,%ecx
801083d1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801083d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083da:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801083e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e3:	83 c0 70             	add    $0x70,%eax
801083e6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
801083ed:	00 
801083ee:	89 04 24             	mov    %eax,(%esp)
801083f1:	e8 60 fb ff ff       	call   80107f56 <lgdt>
  loadgs(SEG_KCPU << 3);
801083f6:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
801083fd:	e8 90 fb ff ff       	call   80107f92 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80108402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108405:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
8010840b:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108412:	00 00 00 00 
}
80108416:	83 c4 24             	add    $0x24,%esp
80108419:	5b                   	pop    %ebx
8010841a:	5d                   	pop    %ebp
8010841b:	c3                   	ret    

8010841c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010841c:	55                   	push   %ebp
8010841d:	89 e5                	mov    %esp,%ebp
8010841f:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108422:	8b 45 0c             	mov    0xc(%ebp),%eax
80108425:	c1 e8 16             	shr    $0x16,%eax
80108428:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010842f:	8b 45 08             	mov    0x8(%ebp),%eax
80108432:	01 d0                	add    %edx,%eax
80108434:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108437:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010843a:	8b 00                	mov    (%eax),%eax
8010843c:	83 e0 01             	and    $0x1,%eax
8010843f:	85 c0                	test   %eax,%eax
80108441:	74 17                	je     8010845a <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108446:	8b 00                	mov    (%eax),%eax
80108448:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010844d:	89 04 24             	mov    %eax,(%esp)
80108450:	e8 69 fb ff ff       	call   80107fbe <p2v>
80108455:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108458:	eb 4b                	jmp    801084a5 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0) // kalloc es 0 cuando no puede asignar la memoria.
8010845a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010845e:	74 0e                	je     8010846e <walkpgdir+0x52>
80108460:	e8 59 a6 ff ff       	call   80102abe <kalloc>
80108465:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010846c:	75 07                	jne    80108475 <walkpgdir+0x59>
      return 0;
8010846e:	b8 00 00 00 00       	mov    $0x0,%eax
80108473:	eb 47                	jmp    801084bc <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108475:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010847c:	00 
8010847d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108484:	00 
80108485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108488:	89 04 24             	mov    %eax,(%esp)
8010848b:	e8 9e d3 ff ff       	call   8010582e <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108490:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108493:	89 04 24             	mov    %eax,(%esp)
80108496:	e8 16 fb ff ff       	call   80107fb1 <v2p>
8010849b:	89 c2                	mov    %eax,%edx
8010849d:	83 ca 07             	or     $0x7,%edx
801084a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084a3:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)]; // PTX (va) me retorna un index de la tabla de pagina, que luego aplicando, &pgtab[..] me retorna su direccion. 
801084a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801084a8:	c1 e8 0c             	shr    $0xc,%eax
801084ab:	25 ff 03 00 00       	and    $0x3ff,%eax
801084b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801084b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084ba:	01 d0                	add    %edx,%eax
}                         // por lo tanto , la direccion del index, de la tabla de paginas.
801084bc:	c9                   	leave  
801084bd:	c3                   	ret    

801084be <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned.
// retornaba "static int" lo cambie por int, si no me saltaba error
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801084be:	55                   	push   %ebp
801084bf:	89 e5                	mov    %esp,%ebp
801084c1:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801084c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801084c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801084cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801084d2:	8b 45 10             	mov    0x10(%ebp),%eax
801084d5:	01 d0                	add    %edx,%eax
801084d7:	48                   	dec    %eax
801084d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0) // walkpgdir: create any required page table pages, osea
801084e0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
801084e7:	00 
801084e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801084ef:	8b 45 08             	mov    0x8(%ebp),%eax
801084f2:	89 04 24             	mov    %eax,(%esp)
801084f5:	e8 22 ff ff ff       	call   8010841c <walkpgdir>
801084fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
801084fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108501:	75 07                	jne    8010850a <mappages+0x4c>
                                            // crea cualquier pagina requerida para la tabla de paginas.
                                            // retorna la direccion de donde fue creada en la tabla pgdir.
      return -1; // no fue posible mapear, debido a que el walkpgdir no pudo asignar la memoria o alloc no es 1
80108503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108508:	eb 46                	jmp    80108550 <mappages+0x92>
    if(*pte & PTE_P)
8010850a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010850d:	8b 00                	mov    (%eax),%eax
8010850f:	83 e0 01             	and    $0x1,%eax
80108512:	85 c0                	test   %eax,%eax
80108514:	74 0c                	je     80108522 <mappages+0x64>
      panic("remap");
80108516:	c7 04 24 34 94 10 80 	movl   $0x80109434,(%esp)
8010851d:	e8 14 80 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
80108522:	8b 45 18             	mov    0x18(%ebp),%eax
80108525:	0b 45 14             	or     0x14(%ebp),%eax
80108528:	89 c2                	mov    %eax,%edx
8010852a:	83 ca 01             	or     $0x1,%edx
8010852d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108530:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108535:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108538:	74 10                	je     8010854a <mappages+0x8c>
      break;
    a += PGSIZE;
8010853a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108541:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108548:	eb 96                	jmp    801084e0 <mappages+0x22>
      break;
8010854a:	90                   	nop
  return 0;
8010854b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108550:	c9                   	leave  
80108551:	c3                   	ret    

80108552 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108552:	55                   	push   %ebp
80108553:	89 e5                	mov    %esp,%ebp
80108555:	53                   	push   %ebx
80108556:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108559:	e8 60 a5 ff ff       	call   80102abe <kalloc>
8010855e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108561:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108565:	75 0a                	jne    80108571 <setupkvm+0x1f>
    return 0;
80108567:	b8 00 00 00 00       	mov    $0x0,%eax
8010856c:	e9 98 00 00 00       	jmp    80108609 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108571:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108578:	00 
80108579:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108580:	00 
80108581:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108584:	89 04 24             	mov    %eax,(%esp)
80108587:	e8 a2 d2 ff ff       	call   8010582e <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010858c:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108593:	e8 26 fa ff ff       	call   80107fbe <p2v>
80108598:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010859d:	76 0c                	jbe    801085ab <setupkvm+0x59>
    panic("PHYSTOP too high");
8010859f:	c7 04 24 3a 94 10 80 	movl   $0x8010943a,(%esp)
801085a6:	e8 8b 7f ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085ab:	c7 45 f4 e0 c4 10 80 	movl   $0x8010c4e0,-0xc(%ebp)
801085b2:	eb 49                	jmp    801085fd <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
801085b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085b7:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801085ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801085bd:	8b 50 04             	mov    0x4(%eax),%edx
801085c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c3:	8b 58 08             	mov    0x8(%eax),%ebx
801085c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c9:	8b 40 04             	mov    0x4(%eax),%eax
801085cc:	29 c3                	sub    %eax,%ebx
801085ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d1:	8b 00                	mov    (%eax),%eax
801085d3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801085d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
801085db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801085df:	89 44 24 04          	mov    %eax,0x4(%esp)
801085e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801085e6:	89 04 24             	mov    %eax,(%esp)
801085e9:	e8 d0 fe ff ff       	call   801084be <mappages>
801085ee:	85 c0                	test   %eax,%eax
801085f0:	79 07                	jns    801085f9 <setupkvm+0xa7>
      return 0;
801085f2:	b8 00 00 00 00       	mov    $0x0,%eax
801085f7:	eb 10                	jmp    80108609 <setupkvm+0xb7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801085f9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801085fd:	81 7d f4 20 c5 10 80 	cmpl   $0x8010c520,-0xc(%ebp)
80108604:	72 ae                	jb     801085b4 <setupkvm+0x62>
  return pgdir;
80108606:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108609:	83 c4 34             	add    $0x34,%esp
8010860c:	5b                   	pop    %ebx
8010860d:	5d                   	pop    %ebp
8010860e:	c3                   	ret    

8010860f <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010860f:	55                   	push   %ebp
80108610:	89 e5                	mov    %esp,%ebp
80108612:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108615:	e8 38 ff ff ff       	call   80108552 <setupkvm>
8010861a:	a3 b8 45 11 80       	mov    %eax,0x801145b8
  switchkvm();
8010861f:	e8 02 00 00 00       	call   80108626 <switchkvm>
}
80108624:	c9                   	leave  
80108625:	c3                   	ret    

80108626 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80108626:	55                   	push   %ebp
80108627:	89 e5                	mov    %esp,%ebp
80108629:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010862c:	a1 b8 45 11 80       	mov    0x801145b8,%eax
80108631:	89 04 24             	mov    %eax,(%esp)
80108634:	e8 78 f9 ff ff       	call   80107fb1 <v2p>
80108639:	89 04 24             	mov    %eax,(%esp)
8010863c:	e8 65 f9 ff ff       	call   80107fa6 <lcr3>
}
80108641:	c9                   	leave  
80108642:	c3                   	ret    

80108643 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80108643:	55                   	push   %ebp
80108644:	89 e5                	mov    %esp,%ebp
80108646:	53                   	push   %ebx
80108647:	83 ec 14             	sub    $0x14,%esp
  pushcli();
8010864a:	e8 df d0 ff ff       	call   8010572e <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010864f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108655:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010865c:	83 c2 08             	add    $0x8,%edx
8010865f:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80108666:	83 c1 08             	add    $0x8,%ecx
80108669:	c1 e9 10             	shr    $0x10,%ecx
8010866c:	88 cb                	mov    %cl,%bl
8010866e:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80108675:	83 c1 08             	add    $0x8,%ecx
80108678:	c1 e9 18             	shr    $0x18,%ecx
8010867b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108682:	67 00 
80108684:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
8010868b:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108691:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80108697:	83 e2 f0             	and    $0xfffffff0,%edx
8010869a:	83 ca 09             	or     $0x9,%edx
8010869d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086a3:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801086a9:	83 ca 10             	or     $0x10,%edx
801086ac:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086b2:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801086b8:	83 e2 9f             	and    $0xffffff9f,%edx
801086bb:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086c1:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
801086c7:	83 ca 80             	or     $0xffffff80,%edx
801086ca:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801086d0:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086d6:	83 e2 f0             	and    $0xfffffff0,%edx
801086d9:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086df:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086e5:	83 e2 ef             	and    $0xffffffef,%edx
801086e8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086ee:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
801086f4:	83 e2 df             	and    $0xffffffdf,%edx
801086f7:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801086fd:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108703:	83 ca 40             	or     $0x40,%edx
80108706:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010870c:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80108712:	83 e2 7f             	and    $0x7f,%edx
80108715:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010871b:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80108721:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108727:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
8010872d:	83 e2 ef             	and    $0xffffffef,%edx
80108730:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80108736:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010873c:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80108742:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108748:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010874f:	8b 52 08             	mov    0x8(%edx),%edx
80108752:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108758:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010875b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80108762:	e8 16 f8 ff ff       	call   80107f7d <ltr>
  if(p->pgdir == 0)
80108767:	8b 45 08             	mov    0x8(%ebp),%eax
8010876a:	8b 40 04             	mov    0x4(%eax),%eax
8010876d:	85 c0                	test   %eax,%eax
8010876f:	75 0c                	jne    8010877d <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80108771:	c7 04 24 4b 94 10 80 	movl   $0x8010944b,(%esp)
80108778:	e8 b9 7d ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010877d:	8b 45 08             	mov    0x8(%ebp),%eax
80108780:	8b 40 04             	mov    0x4(%eax),%eax
80108783:	89 04 24             	mov    %eax,(%esp)
80108786:	e8 26 f8 ff ff       	call   80107fb1 <v2p>
8010878b:	89 04 24             	mov    %eax,(%esp)
8010878e:	e8 13 f8 ff ff       	call   80107fa6 <lcr3>
  popcli();
80108793:	e8 dc cf ff ff       	call   80105774 <popcli>
}
80108798:	83 c4 14             	add    $0x14,%esp
8010879b:	5b                   	pop    %ebx
8010879c:	5d                   	pop    %ebp
8010879d:	c3                   	ret    

8010879e <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
8010879e:	55                   	push   %ebp
8010879f:	89 e5                	mov    %esp,%ebp
801087a1:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801087a4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801087ab:	76 0c                	jbe    801087b9 <inituvm+0x1b>
    panic("inituvm: more than a page"); // (int)_binary_initcode_size, no puede ser mas grade que una pagina
801087ad:	c7 04 24 5f 94 10 80 	movl   $0x8010945f,(%esp)
801087b4:	e8 7d 7d ff ff       	call   80100536 <panic>
  mem = kalloc(); // mem es una direccion virtual, de donde se encuentra alojada la memoria fisica creada por el kalloc()
801087b9:	e8 00 a3 ff ff       	call   80102abe <kalloc>
801087be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE); // se va usar, la seteo con 0
801087c1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087c8:	00 
801087c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801087d0:	00 
801087d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087d4:	89 04 24             	mov    %eax,(%esp)
801087d7:	e8 52 d0 ff ff       	call   8010582e <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801087dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087df:	89 04 24             	mov    %eax,(%esp)
801087e2:	e8 ca f7 ff ff       	call   80107fb1 <v2p>
801087e7:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801087ee:	00 
801087ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
801087f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087fa:	00 
801087fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108802:	00 
80108803:	8b 45 08             	mov    0x8(%ebp),%eax
80108806:	89 04 24             	mov    %eax,(%esp)
80108809:	e8 b0 fc ff ff       	call   801084be <mappages>
  memmove(mem, init, sz);
8010880e:	8b 45 10             	mov    0x10(%ebp),%eax
80108811:	89 44 24 08          	mov    %eax,0x8(%esp)
80108815:	8b 45 0c             	mov    0xc(%ebp),%eax
80108818:	89 44 24 04          	mov    %eax,0x4(%esp)
8010881c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010881f:	89 04 24             	mov    %eax,(%esp)
80108822:	e8 d3 d0 ff ff       	call   801058fa <memmove>
}
80108827:	c9                   	leave  
80108828:	c3                   	ret    

80108829 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108829:	55                   	push   %ebp
8010882a:	89 e5                	mov    %esp,%ebp
8010882c:	53                   	push   %ebx
8010882d:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108830:	8b 45 0c             	mov    0xc(%ebp),%eax
80108833:	25 ff 0f 00 00       	and    $0xfff,%eax
80108838:	85 c0                	test   %eax,%eax
8010883a:	74 0c                	je     80108848 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
8010883c:	c7 04 24 7c 94 10 80 	movl   $0x8010947c,(%esp)
80108843:	e8 ee 7c ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80108848:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010884f:	e9 ad 00 00 00       	jmp    80108901 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80108854:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108857:	8b 55 0c             	mov    0xc(%ebp),%edx
8010885a:	01 d0                	add    %edx,%eax
8010885c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108863:	00 
80108864:	89 44 24 04          	mov    %eax,0x4(%esp)
80108868:	8b 45 08             	mov    0x8(%ebp),%eax
8010886b:	89 04 24             	mov    %eax,(%esp)
8010886e:	e8 a9 fb ff ff       	call   8010841c <walkpgdir>
80108873:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010887a:	75 0c                	jne    80108888 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
8010887c:	c7 04 24 9f 94 10 80 	movl   $0x8010949f,(%esp)
80108883:	e8 ae 7c ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108888:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010888b:	8b 00                	mov    (%eax),%eax
8010888d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108892:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108898:	8b 55 18             	mov    0x18(%ebp),%edx
8010889b:	89 d1                	mov    %edx,%ecx
8010889d:	29 c1                	sub    %eax,%ecx
8010889f:	89 c8                	mov    %ecx,%eax
801088a1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801088a6:	77 11                	ja     801088b9 <loaduvm+0x90>
      n = sz - i;
801088a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ab:	8b 55 18             	mov    0x18(%ebp),%edx
801088ae:	89 d1                	mov    %edx,%ecx
801088b0:	29 c1                	sub    %eax,%ecx
801088b2:	89 c8                	mov    %ecx,%eax
801088b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801088b7:	eb 07                	jmp    801088c0 <loaduvm+0x97>
    else
      n = PGSIZE;
801088b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801088c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088c3:	8b 55 14             	mov    0x14(%ebp),%edx
801088c6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801088c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801088cc:	89 04 24             	mov    %eax,(%esp)
801088cf:	e8 ea f6 ff ff       	call   80107fbe <p2v>
801088d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801088d7:	89 54 24 0c          	mov    %edx,0xc(%esp)
801088db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801088df:	89 44 24 04          	mov    %eax,0x4(%esp)
801088e3:	8b 45 10             	mov    0x10(%ebp),%eax
801088e6:	89 04 24             	mov    %eax,(%esp)
801088e9:	e8 5e 94 ff ff       	call   80101d4c <readi>
801088ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801088f1:	74 07                	je     801088fa <loaduvm+0xd1>
      return -1;
801088f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801088f8:	eb 18                	jmp    80108912 <loaduvm+0xe9>
  for(i = 0; i < sz; i += PGSIZE){
801088fa:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108904:	3b 45 18             	cmp    0x18(%ebp),%eax
80108907:	0f 82 47 ff ff ff    	jb     80108854 <loaduvm+0x2b>
  }
  return 0;
8010890d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108912:	83 c4 24             	add    $0x24,%esp
80108915:	5b                   	pop    %ebx
80108916:	5d                   	pop    %ebp
80108917:	c3                   	ret    

80108918 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108918:	55                   	push   %ebp
80108919:	89 e5                	mov    %esp,%ebp
8010891b:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010891e:	8b 45 10             	mov    0x10(%ebp),%eax
80108921:	85 c0                	test   %eax,%eax
80108923:	79 0a                	jns    8010892f <allocuvm+0x17>
    return 0; // error
80108925:	b8 00 00 00 00       	mov    $0x0,%eax
8010892a:	e9 c1 00 00 00       	jmp    801089f0 <allocuvm+0xd8>
  if(newsz < oldsz)
8010892f:	8b 45 10             	mov    0x10(%ebp),%eax
80108932:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108935:	73 08                	jae    8010893f <allocuvm+0x27>
    return oldsz;
80108937:	8b 45 0c             	mov    0xc(%ebp),%eax
8010893a:	e9 b1 00 00 00       	jmp    801089f0 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
8010893f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108942:	05 ff 0f 00 00       	add    $0xfff,%eax
80108947:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010894c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010894f:	e9 8d 00 00 00       	jmp    801089e1 <allocuvm+0xc9>
    mem = kalloc();
80108954:	e8 65 a1 ff ff       	call   80102abe <kalloc>
80108959:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010895c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108960:	75 2c                	jne    8010898e <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108962:	c7 04 24 bd 94 10 80 	movl   $0x801094bd,(%esp)
80108969:	e8 33 7a ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010896e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108971:	89 44 24 08          	mov    %eax,0x8(%esp)
80108975:	8b 45 10             	mov    0x10(%ebp),%eax
80108978:	89 44 24 04          	mov    %eax,0x4(%esp)
8010897c:	8b 45 08             	mov    0x8(%ebp),%eax
8010897f:	89 04 24             	mov    %eax,(%esp)
80108982:	e8 6b 00 00 00       	call   801089f2 <deallocuvm>
      return 0;
80108987:	b8 00 00 00 00       	mov    $0x0,%eax
8010898c:	eb 62                	jmp    801089f0 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE); // seteo el espacio con 0
8010898e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108995:	00 
80108996:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010899d:	00 
8010899e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089a1:	89 04 24             	mov    %eax,(%esp)
801089a4:	e8 85 ce ff ff       	call   8010582e <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801089a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ac:	89 04 24             	mov    %eax,(%esp)
801089af:	e8 fd f5 ff ff       	call   80107fb1 <v2p>
801089b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801089b7:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801089be:	00 
801089bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
801089c3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801089ca:	00 
801089cb:	89 54 24 04          	mov    %edx,0x4(%esp)
801089cf:	8b 45 08             	mov    0x8(%ebp),%eax
801089d2:	89 04 24             	mov    %eax,(%esp)
801089d5:	e8 e4 fa ff ff       	call   801084be <mappages>
  for(; a < newsz; a += PGSIZE){
801089da:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801089e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089e4:	3b 45 10             	cmp    0x10(%ebp),%eax
801089e7:	0f 82 67 ff ff ff    	jb     80108954 <allocuvm+0x3c>
  }
  return newsz;
801089ed:	8b 45 10             	mov    0x10(%ebp),%eax
}
801089f0:	c9                   	leave  
801089f1:	c3                   	ret    

801089f2 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801089f2:	55                   	push   %ebp
801089f3:	89 e5                	mov    %esp,%ebp
801089f5:	83 ec 38             	sub    $0x38,%esp
  pte_t *pte;
  uint a, pa;
  int save_this = 1; // New: Add in project final 
801089f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

  if(newsz >= oldsz)
801089ff:	8b 45 10             	mov    0x10(%ebp),%eax
80108a02:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a05:	72 08                	jb     80108a0f <deallocuvm+0x1d>
    return oldsz;
80108a07:	8b 45 0c             	mov    0xc(%ebp),%eax
80108a0a:	e9 b8 00 00 00       	jmp    80108ac7 <deallocuvm+0xd5>

  //pte_s
  a = PGROUNDUP(newsz);
80108a0f:	8b 45 10             	mov    0x10(%ebp),%eax
80108a12:	05 ff 0f 00 00       	add    $0xfff,%eax
80108a17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108a1f:	e9 94 00 00 00       	jmp    80108ab8 <deallocuvm+0xc6>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a2e:	00 
80108a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108a33:	8b 45 08             	mov    0x8(%ebp),%eax
80108a36:	89 04 24             	mov    %eax,(%esp)
80108a39:	e8 de f9 ff ff       	call   8010841c <walkpgdir>
80108a3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(!pte)
80108a41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a45:	75 09                	jne    80108a50 <deallocuvm+0x5e>
      a += (NPTENTRIES - 1) * PGSIZE;
80108a47:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80108a4e:	eb 61                	jmp    80108ab1 <deallocuvm+0xbf>
    else if((*pte & PTE_P) != 0){
80108a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a53:	8b 00                	mov    (%eax),%eax
80108a55:	83 e0 01             	and    $0x1,%eax
80108a58:	85 c0                	test   %eax,%eax
80108a5a:	74 55                	je     80108ab1 <deallocuvm+0xbf>
      pa = PTE_ADDR(*pte);
80108a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a5f:	8b 00                	mov    (%eax),%eax
80108a61:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a66:	89 45 e8             	mov    %eax,-0x18(%ebp)
      save_this = is_shared(pa); //New: Add in project final
80108a69:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a6c:	89 04 24             	mov    %eax,(%esp)
80108a6f:	e8 a4 03 00 00       	call   80108e18 <is_shared>
80108a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(pa == 0)
80108a77:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108a7b:	75 0c                	jne    80108a89 <deallocuvm+0x97>
        panic("kfree");
80108a7d:	c7 04 24 d5 94 10 80 	movl   $0x801094d5,(%esp)
80108a84:	e8 ad 7a ff ff       	call   80100536 <panic>
      // char *v = p2v(pa);
      // kfree(v);
      // *pte = 0;
      if (!save_this){ // New: Add in project final, ahi uno solo, le aplico el kfree
80108a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108a8d:	75 22                	jne    80108ab1 <deallocuvm+0xbf>
        char *v = p2v(pa);
80108a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a92:	89 04 24             	mov    %eax,(%esp)
80108a95:	e8 24 f5 ff ff       	call   80107fbe <p2v>
80108a9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        kfree(v);
80108a9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108aa0:	89 04 24             	mov    %eax,(%esp)
80108aa3:	e8 7d 9f ff ff       	call   80102a25 <kfree>
        *pte = 0;
80108aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108ab1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108abb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108abe:	0f 82 60 ff ff ff    	jb     80108a24 <deallocuvm+0x32>
      }
    }
  }
  return newsz;
80108ac4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108ac7:	c9                   	leave  
80108ac8:	c3                   	ret    

80108ac9 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108ac9:	55                   	push   %ebp
80108aca:	89 e5                	mov    %esp,%ebp
80108acc:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108acf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108ad3:	75 0c                	jne    80108ae1 <freevm+0x18>
    panic("freevm: no pgdir");
80108ad5:	c7 04 24 db 94 10 80 	movl   $0x801094db,(%esp)
80108adc:	e8 55 7a ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108ae1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108ae8:	00 
80108ae9:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108af0:	80 
80108af1:	8b 45 08             	mov    0x8(%ebp),%eax
80108af4:	89 04 24             	mov    %eax,(%esp)
80108af7:	e8 f6 fe ff ff       	call   801089f2 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108afc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b03:	eb 47                	jmp    80108b4c <freevm+0x83>
    if(pgdir[i] & PTE_P){
80108b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b0f:	8b 45 08             	mov    0x8(%ebp),%eax
80108b12:	01 d0                	add    %edx,%eax
80108b14:	8b 00                	mov    (%eax),%eax
80108b16:	83 e0 01             	and    $0x1,%eax
80108b19:	85 c0                	test   %eax,%eax
80108b1b:	74 2c                	je     80108b49 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108b27:	8b 45 08             	mov    0x8(%ebp),%eax
80108b2a:	01 d0                	add    %edx,%eax
80108b2c:	8b 00                	mov    (%eax),%eax
80108b2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108b33:	89 04 24             	mov    %eax,(%esp)
80108b36:	e8 83 f4 ff ff       	call   80107fbe <p2v>
80108b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108b41:	89 04 24             	mov    %eax,(%esp)
80108b44:	e8 dc 9e ff ff       	call   80102a25 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108b49:	ff 45 f4             	incl   -0xc(%ebp)
80108b4c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108b53:	76 b0                	jbe    80108b05 <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80108b55:	8b 45 08             	mov    0x8(%ebp),%eax
80108b58:	89 04 24             	mov    %eax,(%esp)
80108b5b:	e8 c5 9e ff ff       	call   80102a25 <kfree>
}
80108b60:	c9                   	leave  
80108b61:	c3                   	ret    

80108b62 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108b62:	55                   	push   %ebp
80108b63:	89 e5                	mov    %esp,%ebp
80108b65:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108b68:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b6f:	00 
80108b70:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b73:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b77:	8b 45 08             	mov    0x8(%ebp),%eax
80108b7a:	89 04 24             	mov    %eax,(%esp)
80108b7d:	e8 9a f8 ff ff       	call   8010841c <walkpgdir>
80108b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b89:	75 0c                	jne    80108b97 <clearpteu+0x35>
    panic("clearpteu");
80108b8b:	c7 04 24 ec 94 10 80 	movl   $0x801094ec,(%esp)
80108b92:	e8 9f 79 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9a:	8b 00                	mov    (%eax),%eax
80108b9c:	89 c2                	mov    %eax,%edx
80108b9e:	83 e2 fb             	and    $0xfffffffb,%edx
80108ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba4:	89 10                	mov    %edx,(%eax)
}
80108ba6:	c9                   	leave  
80108ba7:	c3                   	ret    

80108ba8 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108ba8:	55                   	push   %ebp
80108ba9:	89 e5                	mov    %esp,%ebp
80108bab:	53                   	push   %ebx
80108bac:	83 ec 44             	sub    $0x44,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  int only_map; // New: Add in project final

  if((d = setupkvm()) == 0)
80108baf:	e8 9e f9 ff ff       	call   80108552 <setupkvm>
80108bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108bb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108bbb:	75 0a                	jne    80108bc7 <copyuvm+0x1f>
    return 0;
80108bbd:	b8 00 00 00 00       	mov    $0x0,%eax
80108bc2:	e9 43 01 00 00       	jmp    80108d0a <copyuvm+0x162>
  for(i = 0; i < sz; i += PGSIZE){ // voy copiando cda uno de las entradas, pero las q esten compartidas las mapeo, no las clono
80108bc7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108bce:	e9 12 01 00 00       	jmp    80108ce5 <copyuvm+0x13d>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108bdd:	00 
80108bde:	89 44 24 04          	mov    %eax,0x4(%esp)
80108be2:	8b 45 08             	mov    0x8(%ebp),%eax
80108be5:	89 04 24             	mov    %eax,(%esp)
80108be8:	e8 2f f8 ff ff       	call   8010841c <walkpgdir>
80108bed:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108bf0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108bf4:	75 0c                	jne    80108c02 <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108bf6:	c7 04 24 f6 94 10 80 	movl   $0x801094f6,(%esp)
80108bfd:	e8 34 79 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
80108c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c05:	8b 00                	mov    (%eax),%eax
80108c07:	83 e0 01             	and    $0x1,%eax
80108c0a:	85 c0                	test   %eax,%eax
80108c0c:	75 0c                	jne    80108c1a <copyuvm+0x72>
      panic("copyuvm: page not present");
80108c0e:	c7 04 24 10 95 10 80 	movl   $0x80109510,(%esp)
80108c15:	e8 1c 79 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte); // guardo en pa la dir. fisica
80108c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c1d:	8b 00                	mov    (%eax),%eax
80108c1f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108c24:	89 45 e8             	mov    %eax,-0x18(%ebp)
                          // en *pte tengo una entrada en la tabla de paginas pgdir
    flags = PTE_FLAGS(*pte);
80108c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108c2a:	8b 00                	mov    (%eax),%eax
80108c2c:	25 ff 0f 00 00       	and    $0xfff,%eax
80108c31:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    only_map = is_shared(pa); // New: Add in project final
80108c34:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c37:	89 04 24             	mov    %eax,(%esp)
80108c3a:	e8 d9 01 00 00       	call   80108e18 <is_shared>
80108c3f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!only_map) { 
80108c42:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108c46:	75 6a                	jne    80108cb2 <copyuvm+0x10a>
      if((mem = kalloc()) == 0) // el kalloc no pudo asignar la memoria
80108c48:	e8 71 9e ff ff       	call   80102abe <kalloc>
80108c4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80108c50:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80108c54:	0f 84 9c 00 00 00    	je     80108cf6 <copyuvm+0x14e>
        goto bad;
      memmove(mem, (char*)p2v(pa), PGSIZE);
80108c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108c5d:	89 04 24             	mov    %eax,(%esp)
80108c60:	e8 59 f3 ff ff       	call   80107fbe <p2v>
80108c65:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c6c:	00 
80108c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c71:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c74:	89 04 24             	mov    %eax,(%esp)
80108c77:	e8 7e cc ff ff       	call   801058fa <memmove>
      if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108c7c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108c7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c82:	89 04 24             	mov    %eax,(%esp)
80108c85:	e8 27 f3 ff ff       	call   80107fb1 <v2p>
80108c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108c8d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108c91:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c95:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c9c:	00 
80108c9d:	89 54 24 04          	mov    %edx,0x4(%esp)
80108ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ca4:	89 04 24             	mov    %eax,(%esp)
80108ca7:	e8 12 f8 ff ff       	call   801084be <mappages>
80108cac:	85 c0                	test   %eax,%eax
80108cae:	79 2e                	jns    80108cde <copyuvm+0x136>
        goto bad;
80108cb0:	eb 48                	jmp    80108cfa <copyuvm+0x152>
    } else {
      if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80108cb2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cb8:	89 54 24 10          	mov    %edx,0x10(%esp)
80108cbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
80108cbf:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108cc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108cca:	00 
80108ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
80108ccf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cd2:	89 04 24             	mov    %eax,(%esp)
80108cd5:	e8 e4 f7 ff ff       	call   801084be <mappages>
80108cda:	85 c0                	test   %eax,%eax
80108cdc:	78 1b                	js     80108cf9 <copyuvm+0x151>
  for(i = 0; i < sz; i += PGSIZE){ // voy copiando cda uno de las entradas, pero las q esten compartidas las mapeo, no las clono
80108cde:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108ceb:	0f 82 e2 fe ff ff    	jb     80108bd3 <copyuvm+0x2b>
        goto bad;
     }
  }
  return d;
80108cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cf4:	eb 14                	jmp    80108d0a <copyuvm+0x162>
        goto bad;
80108cf6:	90                   	nop
80108cf7:	eb 01                	jmp    80108cfa <copyuvm+0x152>
        goto bad;
80108cf9:	90                   	nop

bad:
  freevm(d);
80108cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108cfd:	89 04 24             	mov    %eax,(%esp)
80108d00:	e8 c4 fd ff ff       	call   80108ac9 <freevm>
  return 0;
80108d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d0a:	83 c4 44             	add    $0x44,%esp
80108d0d:	5b                   	pop    %ebx
80108d0e:	5d                   	pop    %ebp
80108d0f:	c3                   	ret    

80108d10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108d10:	55                   	push   %ebp
80108d11:	89 e5                	mov    %esp,%ebp
80108d13:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108d16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108d1d:	00 
80108d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d21:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d25:	8b 45 08             	mov    0x8(%ebp),%eax
80108d28:	89 04 24             	mov    %eax,(%esp)
80108d2b:	e8 ec f6 ff ff       	call   8010841c <walkpgdir>
80108d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d36:	8b 00                	mov    (%eax),%eax
80108d38:	83 e0 01             	and    $0x1,%eax
80108d3b:	85 c0                	test   %eax,%eax
80108d3d:	75 07                	jne    80108d46 <uva2ka+0x36>
    return 0;
80108d3f:	b8 00 00 00 00       	mov    $0x0,%eax
80108d44:	eb 25                	jmp    80108d6b <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d49:	8b 00                	mov    (%eax),%eax
80108d4b:	83 e0 04             	and    $0x4,%eax
80108d4e:	85 c0                	test   %eax,%eax
80108d50:	75 07                	jne    80108d59 <uva2ka+0x49>
    return 0;
80108d52:	b8 00 00 00 00       	mov    $0x0,%eax
80108d57:	eb 12                	jmp    80108d6b <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5c:	8b 00                	mov    (%eax),%eax
80108d5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d63:	89 04 24             	mov    %eax,(%esp)
80108d66:	e8 53 f2 ff ff       	call   80107fbe <p2v>
}
80108d6b:	c9                   	leave  
80108d6c:	c3                   	ret    

80108d6d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108d6d:	55                   	push   %ebp
80108d6e:	89 e5                	mov    %esp,%ebp
80108d70:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108d73:	8b 45 10             	mov    0x10(%ebp),%eax
80108d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108d79:	e9 89 00 00 00       	jmp    80108e07 <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108d81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108d86:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108d89:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d90:	8b 45 08             	mov    0x8(%ebp),%eax
80108d93:	89 04 24             	mov    %eax,(%esp)
80108d96:	e8 75 ff ff ff       	call   80108d10 <uva2ka>
80108d9b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108d9e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108da2:	75 07                	jne    80108dab <copyout+0x3e>
      return -1;
80108da4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108da9:	eb 6b                	jmp    80108e16 <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108dab:	8b 45 0c             	mov    0xc(%ebp),%eax
80108dae:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108db1:	89 d1                	mov    %edx,%ecx
80108db3:	29 c1                	sub    %eax,%ecx
80108db5:	89 c8                	mov    %ecx,%eax
80108db7:	05 00 10 00 00       	add    $0x1000,%eax
80108dbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108dc2:	3b 45 14             	cmp    0x14(%ebp),%eax
80108dc5:	76 06                	jbe    80108dcd <copyout+0x60>
      n = len;
80108dc7:	8b 45 14             	mov    0x14(%ebp),%eax
80108dca:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
80108dd3:	29 c2                	sub    %eax,%edx
80108dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108dd8:	01 c2                	add    %eax,%edx
80108dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108ddd:	89 44 24 08          	mov    %eax,0x8(%esp)
80108de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108de4:	89 44 24 04          	mov    %eax,0x4(%esp)
80108de8:	89 14 24             	mov    %edx,(%esp)
80108deb:	e8 0a cb ff ff       	call   801058fa <memmove>
    len -= n;
80108df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108df3:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108df9:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108dff:	05 00 10 00 00       	add    $0x1000,%eax
80108e04:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108e07:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108e0b:	0f 85 6d ff ff ff    	jne    80108d7e <copyout+0x11>
  }
  return 0;
80108e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108e16:	c9                   	leave  
80108e17:	c3                   	ret    

80108e18 <is_shared>:
// struct sharedmemory* get_shm_table(){
//   return shmtable.sharedmemory; // obtengo array sharedmemory de tipo sharedmemory
// }

int
is_shared(uint pa){
80108e18:	55                   	push   %ebp
80108e19:	89 e5                	mov    %esp,%ebp
80108e1b:	83 ec 28             	sub    $0x28,%esp
  int j;
  struct sharedmemory* shared_array = get_shm_table(); 
80108e1e:	e8 53 c6 ff ff       	call   80105476 <get_shm_table>
80108e23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int shared = 0;
80108e26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108e2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108e34:	eb 42                	jmp    80108e78 <is_shared+0x60>
    if (p2v(pa) == shared_array[j].addr && shared_array[j].refcount > 0){ // refcount tiene a 2 entonces 
80108e36:	8b 45 08             	mov    0x8(%ebp),%eax
80108e39:	89 04 24             	mov    %eax,(%esp)
80108e3c:	e8 7d f1 ff ff       	call   80107fbe <p2v>
80108e41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108e44:	8d 0c d5 00 00 00 00 	lea    0x0(,%edx,8),%ecx
80108e4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108e4e:	01 ca                	add    %ecx,%edx
80108e50:	8b 12                	mov    (%edx),%edx
80108e52:	39 d0                	cmp    %edx,%eax
80108e54:	75 1f                	jne    80108e75 <is_shared+0x5d>
80108e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e59:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
80108e60:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108e63:	01 d0                	add    %edx,%eax
80108e65:	8b 40 04             	mov    0x4(%eax),%eax
80108e68:	85 c0                	test   %eax,%eax
80108e6a:	7e 09                	jle    80108e75 <is_shared+0x5d>
      shared = j+1;
80108e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e6f:	40                   	inc    %eax
80108e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
      break;
80108e73:	eb 09                	jmp    80108e7e <is_shared+0x66>
  for(j=0; j<MAXSHM; j++){ // recorro mi arreglo sharedmemory
80108e75:	ff 45 f4             	incl   -0xc(%ebp)
80108e78:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80108e7c:	7e b8                	jle    80108e36 <is_shared+0x1e>
    }
  }
  return shared; // ahi uno solo
80108e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108e81:	c9                   	leave  
80108e82:	c3                   	ret    
