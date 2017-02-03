
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
8010001a:	0f 22 d8             	mov    %eax,%cr3
8010001d:	0f 20 c0             	mov    %cr0,%eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
80100025:	0f 22 c0             	mov    %eax,%cr0
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp
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
8010003a:	c7 44 24 04 3c 84 10 	movl   $0x8010843c,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 d4 4c 00 00       	call   80104d22 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 b0 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb0
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 b4 db 10 80 a4 	movl   $0x8010dba4,0x8010dbb4
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
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
801000b6:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000bd:	e8 81 4c 00 00       	call   80104d43 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
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
801000fd:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100104:	e8 9c 4c 00 00       	call   80104da5 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 c6 10 	movl   $0x8010c680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 f9 48 00 00       	call   80104a1d <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 b0 db 10 80       	mov    0x8010dbb0,%eax
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
80100175:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017c:	e8 24 4c 00 00       	call   80104da5 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 a4 db 10 80 	cmpl   $0x8010dba4,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 43 84 10 80 	movl   $0x80108443,(%esp)
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
801001ef:	c7 04 24 54 84 10 80 	movl   $0x80108454,(%esp)
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
80100229:	c7 04 24 5b 84 10 80 	movl   $0x8010845b,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010023c:	e8 02 4b 00 00       	call   80104d43 <acquire>

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
8010025f:	8b 15 b4 db 10 80    	mov    0x8010dbb4,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c a4 db 10 80 	movl   $0x8010dba4,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 b4 db 10 80       	mov    0x8010dbb4,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 b4 db 10 80       	mov    %eax,0x8010dbb4

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
8010029d:	e8 83 48 00 00       	call   80104b25 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002a9:	e8 f7 4a 00 00       	call   80104da5 <release>
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
8010033e:	8a 80 04 90 10 80    	mov    -0x7fef6ffc(%eax),%al
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
801003a7:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003bc:	e8 82 49 00 00       	call   80104d43 <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 62 84 10 80 	movl   $0x80108462,(%esp)
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
801004ad:	c7 45 ec 6b 84 10 80 	movl   $0x8010846b,-0x14(%ebp)
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
80100528:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010052f:	e8 71 48 00 00       	call   80104da5 <release>
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
80100541:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 72 84 10 80 	movl   $0x80108472,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 81 84 10 80 	movl   $0x80108481,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 65 48 00 00       	call   80104df4 <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 83 84 10 80 	movl   $0x80108483,(%esp)
801005aa:	e8 f2 fd ff ff       	call   801003a1 <cprintf>
  for(i=0; i<10; i++)
801005af:	ff 45 f4             	incl   -0xc(%ebp)
801005b2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005b6:	7e e0                	jle    80100598 <panic+0x62>
  panicked = 1; // freeze other CPU
801005b8:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
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
80100650:	a1 00 90 10 80       	mov    0x80109000,%eax
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
80100676:	a1 00 90 10 80       	mov    0x80109000,%eax
8010067b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100681:	a1 00 90 10 80       	mov    0x80109000,%eax
80100686:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
8010068d:	00 
8010068e:	89 54 24 04          	mov    %edx,0x4(%esp)
80100692:	89 04 24             	mov    %eax,(%esp)
80100695:	e8 c7 49 00 00       	call   80105061 <memmove>
    pos -= 80;
8010069a:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010069e:	b8 80 07 00 00       	mov    $0x780,%eax
801006a3:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006a6:	d1 e0                	shl    %eax
801006a8:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006ae:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006b1:	d1 e1                	shl    %ecx
801006b3:	01 ca                	add    %ecx,%edx
801006b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801006b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006c0:	00 
801006c1:	89 14 24             	mov    %edx,(%esp)
801006c4:	e8 cc 48 00 00       	call   80104f95 <memset>
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
80100720:	a1 00 90 10 80       	mov    0x80109000,%eax
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
80100739:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
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
80100759:	e8 55 63 00 00       	call   80106ab3 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 49 63 00 00       	call   80106ab3 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 3d 63 00 00       	call   80106ab3 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 30 63 00 00       	call   80106ab3 <uartputc>
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
80100796:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
8010079d:	e8 a1 45 00 00       	call   80104d43 <acquire>
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
801007ca:	e8 05 44 00 00       	call   80104bd4 <procdump>
      break;
801007cf:	e9 08 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007d4:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801007d9:	48                   	dec    %eax
801007da:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(BACKSPACE);
801007df:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801007e6:	e8 48 ff ff ff       	call   80100733 <consputc>
801007eb:	eb 01                	jmp    801007ee <consoleintr+0x5e>
      while(input.e != input.w &&
801007ed:	90                   	nop
801007ee:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
801007f4:	a1 78 de 10 80       	mov    0x8010de78,%eax
801007f9:	39 c2                	cmp    %eax,%edx
801007fb:	0f 84 d4 00 00 00    	je     801008d5 <consoleintr+0x145>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100801:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100806:	48                   	dec    %eax
80100807:	83 e0 7f             	and    $0x7f,%eax
8010080a:	8a 80 f4 dd 10 80    	mov    -0x7fef220c(%eax),%al
      while(input.e != input.w &&
80100810:	3c 0a                	cmp    $0xa,%al
80100812:	75 c0                	jne    801007d4 <consoleintr+0x44>
      }
      break;
80100814:	e9 bc 00 00 00       	jmp    801008d5 <consoleintr+0x145>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100819:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
8010081f:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 ac 00 00 00    	je     801008d8 <consoleintr+0x148>
        input.e--;
8010082c:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100831:	48                   	dec    %eax
80100832:	a3 7c de 10 80       	mov    %eax,0x8010de7c
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
80100852:	8b 15 7c de 10 80    	mov    0x8010de7c,%edx
80100858:	a1 74 de 10 80       	mov    0x8010de74,%eax
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
8010087b:	a1 7c de 10 80       	mov    0x8010de7c,%eax
80100880:	89 c1                	mov    %eax,%ecx
80100882:	83 e1 7f             	and    $0x7f,%ecx
80100885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100888:	88 91 f4 dd 10 80    	mov    %dl,-0x7fef220c(%ecx)
8010088e:	40                   	inc    %eax
8010088f:	a3 7c de 10 80       	mov    %eax,0x8010de7c
        consputc(c);
80100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100897:	89 04 24             	mov    %eax,(%esp)
8010089a:	e8 94 fe ff ff       	call   80100733 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010089f:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008a3:	74 18                	je     801008bd <consoleintr+0x12d>
801008a5:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008a9:	74 12                	je     801008bd <consoleintr+0x12d>
801008ab:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008b0:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
801008b6:	83 ea 80             	sub    $0xffffff80,%edx
801008b9:	39 d0                	cmp    %edx,%eax
801008bb:	75 1e                	jne    801008db <consoleintr+0x14b>
          input.w = input.e;
801008bd:	a1 7c de 10 80       	mov    0x8010de7c,%eax
801008c2:	a3 78 de 10 80       	mov    %eax,0x8010de78
          wakeup(&input.r);
801008c7:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
801008ce:	e8 52 42 00 00       	call   80104b25 <wakeup>
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
801008ee:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
801008f5:	e8 ab 44 00 00       	call   80104da5 <release>
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
80100913:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
8010091a:	e8 24 44 00 00       	call   80104d43 <acquire>
  while(n > 0){
8010091f:	e9 a1 00 00 00       	jmp    801009c5 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010092a:	8b 40 24             	mov    0x24(%eax),%eax
8010092d:	85 c0                	test   %eax,%eax
8010092f:	74 21                	je     80100952 <consoleread+0x56>
        release(&input.lock);
80100931:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100938:	e8 68 44 00 00       	call   80104da5 <release>
        ilock(ip);
8010093d:	8b 45 08             	mov    0x8(%ebp),%eax
80100940:	89 04 24             	mov    %eax,(%esp)
80100943:	e8 fd 0e 00 00       	call   80101845 <ilock>
        return -1;
80100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010094d:	e9 a2 00 00 00       	jmp    801009f4 <consoleread+0xf8>
      }
      sleep(&input.r, &input.lock);
80100952:	c7 44 24 04 c0 dd 10 	movl   $0x8010ddc0,0x4(%esp)
80100959:	80 
8010095a:	c7 04 24 74 de 10 80 	movl   $0x8010de74,(%esp)
80100961:	e8 b7 40 00 00       	call   80104a1d <sleep>
80100966:	eb 01                	jmp    80100969 <consoleread+0x6d>
    while(input.r == input.w){
80100968:	90                   	nop
80100969:	8b 15 74 de 10 80    	mov    0x8010de74,%edx
8010096f:	a1 78 de 10 80       	mov    0x8010de78,%eax
80100974:	39 c2                	cmp    %eax,%edx
80100976:	74 ac                	je     80100924 <consoleread+0x28>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100978:	a1 74 de 10 80       	mov    0x8010de74,%eax
8010097d:	89 c2                	mov    %eax,%edx
8010097f:	83 e2 7f             	and    $0x7f,%edx
80100982:	8a 92 f4 dd 10 80    	mov    -0x7fef220c(%edx),%dl
80100988:	0f be d2             	movsbl %dl,%edx
8010098b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010098e:	40                   	inc    %eax
8010098f:	a3 74 de 10 80       	mov    %eax,0x8010de74
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
801009a2:	a1 74 de 10 80       	mov    0x8010de74,%eax
801009a7:	48                   	dec    %eax
801009a8:	a3 74 de 10 80       	mov    %eax,0x8010de74
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
801009d1:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
801009d8:	e8 c8 43 00 00       	call   80104da5 <release>
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
80100a07:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a0e:	e8 30 43 00 00       	call   80104d43 <acquire>
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
80100a41:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a48:	e8 58 43 00 00       	call   80104da5 <release>
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
80100a63:	c7 44 24 04 87 84 10 	movl   $0x80108487,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a72:	e8 ab 42 00 00       	call   80104d22 <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 8f 84 10 	movl   $0x8010848f,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 c0 dd 10 80 	movl   $0x8010ddc0,(%esp)
80100a86:	e8 97 42 00 00       	call   80104d22 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100a8b:	c7 05 2c e8 10 80 f6 	movl   $0x801009f6,0x8010e82c
80100a92:	09 10 80 
  devsw[CONSOLE].read = consoleread;
80100a95:	c7 05 28 e8 10 80 fc 	movl   $0x801008fc,0x8010e828
80100a9c:	08 10 80 
  cons.locking = 1;
80100a9f:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
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
80100b43:	e8 8f 70 00 00       	call   80107bd7 <setupkvm>
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
80100bdc:	e8 bc 73 00 00       	call   80107f9d <allocuvm>
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
80100c19:	e8 90 72 00 00       	call   80107eae <loaduvm>
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
80100c82:	e8 16 73 00 00       	call   80107f9d <allocuvm>
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
80100ca6:	e8 21 75 00 00       	call   801081cc <clearpteu>
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
80100cdb:	e8 10 45 00 00       	call   801051f0 <strlen>
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
80100d03:	e8 e8 44 00 00       	call   801051f0 <strlen>
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
80100d31:	e8 5b 76 00 00       	call   80108391 <copyout>
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
80100dd4:	e8 b8 75 00 00       	call   80108391 <copyout>
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
80100e26:	e8 7c 43 00 00       	call   801051a7 <safestrcpy>

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
80100e78:	e8 4b 6e 00 00       	call   80107cc8 <switchuvm>
  freevm(oldpgdir);
80100e7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e80:	89 04 24             	mov    %eax,(%esp)
80100e83:	e8 ab 72 00 00       	call   80108133 <freevm>
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
80100eba:	e8 74 72 00 00       	call   80108133 <freevm>
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
80100edd:	c7 44 24 04 95 84 10 	movl   $0x80108495,0x4(%esp)
80100ee4:	80 
80100ee5:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100eec:	e8 31 3e 00 00       	call   80104d22 <initlock>
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
80100ef9:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f00:	e8 3e 3e 00 00       	call   80104d43 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f05:	c7 45 f4 b4 de 10 80 	movl   $0x8010deb4,-0xc(%ebp)
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
80100f22:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f29:	e8 77 3e 00 00       	call   80104da5 <release>
      return f;
80100f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f31:	eb 1e                	jmp    80100f51 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f33:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f37:	81 7d f4 14 e8 10 80 	cmpl   $0x8010e814,-0xc(%ebp)
80100f3e:	72 ce                	jb     80100f0e <filealloc+0x1b>
    }
  }
  release(&ftable.lock);
80100f40:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f47:	e8 59 3e 00 00       	call   80104da5 <release>
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
80100f59:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f60:	e8 de 3d 00 00       	call   80104d43 <acquire>
  if(f->ref < 1)
80100f65:	8b 45 08             	mov    0x8(%ebp),%eax
80100f68:	8b 40 04             	mov    0x4(%eax),%eax
80100f6b:	85 c0                	test   %eax,%eax
80100f6d:	7f 0c                	jg     80100f7b <filedup+0x28>
    panic("filedup");
80100f6f:	c7 04 24 9c 84 10 80 	movl   $0x8010849c,(%esp)
80100f76:	e8 bb f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	8d 50 01             	lea    0x1(%eax),%edx
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100f8a:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100f91:	e8 0f 3e 00 00       	call   80104da5 <release>
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
80100fa4:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fab:	e8 93 3d 00 00       	call   80104d43 <acquire>
  if(f->ref < 1)
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	7f 0c                	jg     80100fc6 <fileclose+0x2b>
    panic("fileclose");
80100fba:	c7 04 24 a4 84 10 80 	movl   $0x801084a4,(%esp)
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
80100fdf:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
80100fe6:	e8 ba 3d 00 00       	call   80104da5 <release>
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
80101015:	c7 04 24 80 de 10 80 	movl   $0x8010de80,(%esp)
8010101c:	e8 84 3d 00 00       	call   80104da5 <release>
  
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
80101161:	c7 04 24 ae 84 10 80 	movl   $0x801084ae,(%esp)
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
8010126c:	c7 04 24 b7 84 10 80 	movl   $0x801084b7,(%esp)
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
801012a1:	c7 04 24 c7 84 10 80 	movl   $0x801084c7,(%esp)
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
801012e7:	e8 75 3d 00 00       	call   80105061 <memmove>
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
8010132d:	e8 63 3c 00 00       	call   80104f95 <memset>
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
80101495:	c7 04 24 d1 84 10 80 	movl   $0x801084d1,(%esp)
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
80101538:	c7 04 24 e7 84 10 80 	movl   $0x801084e7,(%esp)
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
8010158d:	c7 44 24 04 fa 84 10 	movl   $0x801084fa,0x4(%esp)
80101594:	80 
80101595:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010159c:	e8 81 37 00 00       	call   80104d22 <initlock>
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
80101626:	e8 6a 39 00 00       	call   80104f95 <memset>
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
8010167d:	c7 04 24 01 85 10 80 	movl   $0x80108501,(%esp)
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
80101724:	e8 38 39 00 00       	call   80105061 <memmove>
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
80101747:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010174e:	e8 f0 35 00 00       	call   80104d43 <acquire>

  // Is the inode already cached?
  empty = 0;
80101753:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010175a:	c7 45 f4 b4 e8 10 80 	movl   $0x8010e8b4,-0xc(%ebp)
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
80101791:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101798:	e8 08 36 00 00       	call   80104da5 <release>
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
801017bc:	81 7d f4 54 f8 10 80 	cmpl   $0x8010f854,-0xc(%ebp)
801017c3:	72 9e                	jb     80101763 <iget+0x22>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017c9:	75 0c                	jne    801017d7 <iget+0x96>
    panic("iget: no inodes");
801017cb:	c7 04 24 13 85 10 80 	movl   $0x80108513,(%esp)
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
80101802:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101809:	e8 97 35 00 00       	call   80104da5 <release>

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
80101819:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101820:	e8 1e 35 00 00       	call   80104d43 <acquire>
  ip->ref++;
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 08             	mov    0x8(%eax),%eax
8010182b:	8d 50 01             	lea    0x1(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101834:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010183b:	e8 65 35 00 00       	call   80104da5 <release>
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
8010185b:	c7 04 24 23 85 10 80 	movl   $0x80108523,(%esp)
80101862:	e8 cf ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101867:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
8010186e:	e8 d0 34 00 00       	call   80104d43 <acquire>
  while(ip->flags & I_BUSY)
80101873:	eb 13                	jmp    80101888 <ilock+0x43>
    sleep(ip, &icache.lock);
80101875:	c7 44 24 04 80 e8 10 	movl   $0x8010e880,0x4(%esp)
8010187c:	80 
8010187d:	8b 45 08             	mov    0x8(%ebp),%eax
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 95 31 00 00       	call   80104a1d <sleep>
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
801018a6:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801018ad:	e8 f3 34 00 00       	call   80104da5 <release>

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
80101956:	e8 06 37 00 00       	call   80105061 <memmove>
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
80101982:	c7 04 24 29 85 10 80 	movl   $0x80108529,(%esp)
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
801019b3:	c7 04 24 38 85 10 80 	movl   $0x80108538,(%esp)
801019ba:	e8 77 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019bf:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801019c6:	e8 78 33 00 00       	call   80104d43 <acquire>
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
801019e2:	e8 3e 31 00 00       	call   80104b25 <wakeup>
  release(&icache.lock);
801019e7:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
801019ee:	e8 b2 33 00 00       	call   80104da5 <release>
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
801019fb:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a02:	e8 3c 33 00 00       	call   80104d43 <acquire>
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
80101a40:	c7 04 24 40 85 10 80 	movl   $0x80108540,(%esp)
80101a47:	e8 ea ea ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a52:	89 c2                	mov    %eax,%edx
80101a54:	83 ca 01             	or     $0x1,%edx
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a5d:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a64:	e8 3c 33 00 00       	call   80104da5 <release>
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
80101a88:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101a8f:	e8 af 32 00 00       	call   80104d43 <acquire>
    ip->flags = 0;
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 04 24             	mov    %eax,(%esp)
80101aa4:	e8 7c 30 00 00       	call   80104b25 <wakeup>
  }
  ip->ref--;
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 40 08             	mov    0x8(%eax),%eax
80101aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ab8:	c7 04 24 80 e8 10 80 	movl   $0x8010e880,(%esp)
80101abf:	e8 e1 32 00 00       	call   80104da5 <release>
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
80101bdf:	c7 04 24 4a 85 10 80 	movl   $0x8010854a,(%esp)
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
80101d7f:	8b 04 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%eax
80101d86:	85 c0                	test   %eax,%eax
80101d88:	75 0a                	jne    80101d94 <readi+0x48>
      return -1;
80101d8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d8f:	e9 1b 01 00 00       	jmp    80101eaf <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d9b:	98                   	cwtl   
80101d9c:	8b 04 c5 20 e8 10 80 	mov    -0x7fef17e0(,%eax,8),%eax
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
80101e7e:	e8 de 31 00 00       	call   80105061 <memmove>
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
80101ee4:	8b 04 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%eax
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	75 0a                	jne    80101ef9 <writei+0x48>
      return -1;
80101eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef4:	e9 46 01 00 00       	jmp    8010203f <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f00:	98                   	cwtl   
80101f01:	8b 04 c5 24 e8 10 80 	mov    -0x7fef17dc(,%eax,8),%eax
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
80101fde:	e8 7e 30 00 00       	call   80105061 <memmove>
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
8010205c:	e8 9c 30 00 00       	call   801050fd <strncmp>
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
80102075:	c7 04 24 5d 85 10 80 	movl   $0x8010855d,(%esp)
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
801020b3:	c7 04 24 6f 85 10 80 	movl   $0x8010856f,(%esp)
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
80102195:	c7 04 24 6f 85 10 80 	movl   $0x8010856f,(%esp)
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
801021da:	e8 6e 2f 00 00       	call   8010514d <strncpy>
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
8010220c:	c7 04 24 7c 85 10 80 	movl   $0x8010857c,(%esp)
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
8010228d:	e8 cf 2d 00 00       	call   80105061 <memmove>
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
801022a8:	e8 b4 2d 00 00       	call   80105061 <memmove>
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
801024fb:	c7 44 24 04 84 85 10 	movl   $0x80108584,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010250a:	e8 13 28 00 00       	call   80104d22 <initlock>
  picenable(IRQ_IDE);
8010250f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102516:	e8 86 15 00 00       	call   80103aa1 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010251b:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
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
8010256a:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
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
801025a4:	c7 04 24 88 85 10 80 	movl   $0x80108588,(%esp)
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
801026c3:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801026ca:	e8 74 26 00 00       	call   80104d43 <acquire>
  if((b = idequeue) == 0){
801026cf:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026db:	75 11                	jne    801026ee <ideintr+0x31>
    release(&idelock);
801026dd:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801026e4:	e8 bc 26 00 00       	call   80104da5 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026e9:	e9 90 00 00 00       	jmp    8010277e <ideintr+0xc1>
  }
  idequeue = b->qnext;
801026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f1:	8b 40 14             	mov    0x14(%eax),%eax
801026f4:	a3 54 b6 10 80       	mov    %eax,0x8010b654

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
80102757:	e8 c9 23 00 00       	call   80104b25 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010275c:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102761:	85 c0                	test   %eax,%eax
80102763:	74 0d                	je     80102772 <ideintr+0xb5>
    idestart(idequeue);
80102765:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010276a:	89 04 24             	mov    %eax,(%esp)
8010276d:	e8 26 fe ff ff       	call   80102598 <idestart>

  release(&idelock);
80102772:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102779:	e8 27 26 00 00       	call   80104da5 <release>
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
80102792:	c7 04 24 91 85 10 80 	movl   $0x80108591,(%esp)
80102799:	e8 98 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	8b 00                	mov    (%eax),%eax
801027a3:	83 e0 06             	and    $0x6,%eax
801027a6:	83 f8 02             	cmp    $0x2,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x37>
    panic("iderw: nothing to do");
801027ab:	c7 04 24 a5 85 10 80 	movl   $0x801085a5,(%esp)
801027b2:	e8 7f dd ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
801027b7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ba:	8b 40 04             	mov    0x4(%eax),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	74 15                	je     801027d6 <iderw+0x56>
801027c1:	a1 58 b6 10 80       	mov    0x8010b658,%eax
801027c6:	85 c0                	test   %eax,%eax
801027c8:	75 0c                	jne    801027d6 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027ca:	c7 04 24 ba 85 10 80 	movl   $0x801085ba,(%esp)
801027d1:	e8 60 dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027d6:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027dd:	e8 61 25 00 00       	call   80104d43 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027e2:	8b 45 08             	mov    0x8(%ebp),%eax
801027e5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ec:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
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
80102811:	a1 54 b6 10 80       	mov    0x8010b654,%eax
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
80102828:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
8010282f:	80 
80102830:	8b 45 08             	mov    0x8(%ebp),%eax
80102833:	89 04 24             	mov    %eax,(%esp)
80102836:	e8 e2 21 00 00       	call   80104a1d <sleep>
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
8010284b:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102852:	e8 4e 25 00 00       	call   80104da5 <release>
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
8010285c:	a1 54 f8 10 80       	mov    0x8010f854,%eax
80102861:	8b 55 08             	mov    0x8(%ebp),%edx
80102864:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102866:	a1 54 f8 10 80       	mov    0x8010f854,%eax
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
80102873:	a1 54 f8 10 80       	mov    0x8010f854,%eax
80102878:	8b 55 08             	mov    0x8(%ebp),%edx
8010287b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010287d:	a1 54 f8 10 80       	mov    0x8010f854,%eax
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
80102890:	a1 24 f9 10 80       	mov    0x8010f924,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	0f 84 9a 00 00 00    	je     80102937 <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010289d:	c7 05 54 f8 10 80 00 	movl   $0xfec00000,0x8010f854
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
801028d0:	a0 20 f9 10 80       	mov    0x8010f920,%al
801028d5:	0f b6 c0             	movzbl %al,%eax
801028d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028db:	74 0c                	je     801028e9 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028dd:	c7 04 24 d8 85 10 80 	movl   $0x801085d8,(%esp)
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
80102940:	a1 24 f9 10 80       	mov    0x8010f924,%eax
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
80102996:	c7 44 24 04 0a 86 10 	movl   $0x8010860a,0x4(%esp)
8010299d:	80 
8010299e:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
801029a5:	e8 78 23 00 00       	call   80104d22 <initlock>
  kmem.use_lock = 0;
801029aa:	c7 05 94 f8 10 80 00 	movl   $0x0,0x8010f894
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
801029e0:	c7 05 94 f8 10 80 01 	movl   $0x1,0x8010f894
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
80102a37:	81 7d 08 3c 2a 11 80 	cmpl   $0x80112a3c,0x8(%ebp)
80102a3e:	72 12                	jb     80102a52 <kfree+0x2d>
80102a40:	8b 45 08             	mov    0x8(%ebp),%eax
80102a43:	89 04 24             	mov    %eax,(%esp)
80102a46:	e8 38 ff ff ff       	call   80102983 <v2p>
80102a4b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a50:	76 0c                	jbe    80102a5e <kfree+0x39>
    panic("kfree");
80102a52:	c7 04 24 0f 86 10 80 	movl   $0x8010860f,(%esp)
80102a59:	e8 d8 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a65:	00 
80102a66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a6d:	00 
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 1c 25 00 00       	call   80104f95 <memset>

  if(kmem.use_lock)
80102a79:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102a7e:	85 c0                	test   %eax,%eax
80102a80:	74 0c                	je     80102a8e <kfree+0x69>
    acquire(&kmem.lock);
80102a82:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102a89:	e8 b5 22 00 00       	call   80104d43 <acquire>
  r = (struct run*)v;
80102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102a94:	8b 15 98 f8 10 80    	mov    0x8010f898,%edx
80102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9d:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa2:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102aa7:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102aac:	85 c0                	test   %eax,%eax
80102aae:	74 0c                	je     80102abc <kfree+0x97>
    release(&kmem.lock);
80102ab0:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102ab7:	e8 e9 22 00 00       	call   80104da5 <release>
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
80102ac4:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102ac9:	85 c0                	test   %eax,%eax
80102acb:	74 0c                	je     80102ad9 <kalloc+0x1b>
    acquire(&kmem.lock);
80102acd:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102ad4:	e8 6a 22 00 00       	call   80104d43 <acquire>
  r = kmem.freelist;
80102ad9:	a1 98 f8 10 80       	mov    0x8010f898,%eax
80102ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ae5:	74 0a                	je     80102af1 <kalloc+0x33>
    kmem.freelist = r->next;
80102ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aea:	8b 00                	mov    (%eax),%eax
80102aec:	a3 98 f8 10 80       	mov    %eax,0x8010f898
  if(kmem.use_lock)
80102af1:	a1 94 f8 10 80       	mov    0x8010f894,%eax
80102af6:	85 c0                	test   %eax,%eax
80102af8:	74 0c                	je     80102b06 <kalloc+0x48>
    release(&kmem.lock);
80102afa:	c7 04 24 60 f8 10 80 	movl   $0x8010f860,(%esp)
80102b01:	e8 9f 22 00 00       	call   80104da5 <release>
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
80102b7a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102b7f:	83 c8 40             	or     $0x40,%eax
80102b82:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
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
80102b9d:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
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
80102bba:	05 20 90 10 80       	add    $0x80109020,%eax
80102bbf:	8a 00                	mov    (%eax),%al
80102bc1:	83 c8 40             	or     $0x40,%eax
80102bc4:	0f b6 c0             	movzbl %al,%eax
80102bc7:	f7 d0                	not    %eax
80102bc9:	89 c2                	mov    %eax,%edx
80102bcb:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bd0:	21 d0                	and    %edx,%eax
80102bd2:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102bd7:	b8 00 00 00 00       	mov    $0x0,%eax
80102bdc:	e9 9f 00 00 00       	jmp    80102c80 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102be1:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102be6:	83 e0 40             	and    $0x40,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	74 14                	je     80102c01 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bed:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102bf4:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102bf9:	83 e0 bf             	and    $0xffffffbf,%eax
80102bfc:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c04:	05 20 90 10 80       	add    $0x80109020,%eax
80102c09:	8a 00                	mov    (%eax),%al
80102c0b:	0f b6 d0             	movzbl %al,%edx
80102c0e:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c13:	09 d0                	or     %edx,%eax
80102c15:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c1d:	05 20 91 10 80       	add    $0x80109120,%eax
80102c22:	8a 00                	mov    (%eax),%al
80102c24:	0f b6 d0             	movzbl %al,%edx
80102c27:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c2c:	31 d0                	xor    %edx,%eax
80102c2e:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c33:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c38:	83 e0 03             	and    $0x3,%eax
80102c3b:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c45:	01 d0                	add    %edx,%eax
80102c47:	8a 00                	mov    (%eax),%al
80102c49:	0f b6 c0             	movzbl %al,%eax
80102c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c4f:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
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
80102cca:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102ccf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd2:	c1 e2 02             	shl    $0x2,%edx
80102cd5:	01 c2                	add    %eax,%edx
80102cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cda:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102cdc:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
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
80102cee:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
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
80102d73:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
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
80102e17:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
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
80102e59:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80102e5e:	85 c0                	test   %eax,%eax
80102e60:	0f 94 c2             	sete   %dl
80102e63:	40                   	inc    %eax
80102e64:	a3 60 b6 10 80       	mov    %eax,0x8010b660
80102e69:	84 d2                	test   %dl,%dl
80102e6b:	74 13                	je     80102e80 <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e6d:	8b 45 04             	mov    0x4(%ebp),%eax
80102e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e74:	c7 04 24 18 86 10 80 	movl   $0x80108618,(%esp)
80102e7b:	e8 21 d5 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e80:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
80102e85:	85 c0                	test   %eax,%eax
80102e87:	74 0f                	je     80102e98 <cpunum+0x53>
    return lapic[ID]>>24;
80102e89:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
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
80102ea5:	a1 9c f8 10 80       	mov    0x8010f89c,%eax
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
80102fcb:	c7 44 24 04 44 86 10 	movl   $0x80108644,0x4(%esp)
80102fd2:	80 
80102fd3:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80102fda:	e8 43 1d 00 00       	call   80104d22 <initlock>
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
80102ffe:	a3 d4 f8 10 80       	mov    %eax,0x8010f8d4
  log.size = sb.nlog;
80103003:	8b 45 94             	mov    -0x6c(%ebp),%eax
80103006:	a3 d8 f8 10 80       	mov    %eax,0x8010f8d8
  log.dev = ROOTDEV;
8010300b:	c7 05 e0 f8 10 80 01 	movl   $0x1,0x8010f8e0
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
8010302e:	8b 15 d4 f8 10 80    	mov    0x8010f8d4,%edx
80103034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103037:	01 d0                	add    %edx,%eax
80103039:	40                   	inc    %eax
8010303a:	89 c2                	mov    %eax,%edx
8010303c:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
80103041:	89 54 24 04          	mov    %edx,0x4(%esp)
80103045:	89 04 24             	mov    %eax,(%esp)
80103048:	e8 59 d1 ff ff       	call   801001a6 <bread>
8010304d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103053:	83 c0 10             	add    $0x10,%eax
80103056:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
8010305d:	89 c2                	mov    %eax,%edx
8010305f:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
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
8010308e:	e8 ce 1f 00 00       	call   80105061 <memmove>
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
801030b7:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
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
801030cd:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
801030d2:	89 c2                	mov    %eax,%edx
801030d4:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
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
801030f6:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
  for (i = 0; i < log.lh.n; i++) {
801030fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103102:	eb 1a                	jmp    8010311e <read_head+0x57>
    log.lh.sector[i] = lh->sector[i];
80103104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103107:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010310a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010310e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103111:	83 c2 10             	add    $0x10,%edx
80103114:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010311b:	ff 45 f4             	incl   -0xc(%ebp)
8010311e:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
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
8010313b:	a1 d4 f8 10 80       	mov    0x8010f8d4,%eax
80103140:	89 c2                	mov    %eax,%edx
80103142:	a1 e0 f8 10 80       	mov    0x8010f8e0,%eax
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
8010315f:	8b 15 e4 f8 10 80    	mov    0x8010f8e4,%edx
80103165:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103168:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010316a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103171:	eb 1a                	jmp    8010318d <write_head+0x58>
    hb->sector[i] = log.lh.sector[i];
80103173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103176:	83 c0 10             	add    $0x10,%eax
80103179:	8b 0c 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%ecx
80103180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103183:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103186:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010318a:	ff 45 f4             	incl   -0xc(%ebp)
8010318d:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
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
801031bf:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
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
801031d6:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801031dd:	e8 61 1b 00 00       	call   80104d43 <acquire>
  while (log.busy) {
801031e2:	eb 14                	jmp    801031f8 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e4:	c7 44 24 04 a0 f8 10 	movl   $0x8010f8a0,0x4(%esp)
801031eb:	80 
801031ec:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
801031f3:	e8 25 18 00 00       	call   80104a1d <sleep>
  while (log.busy) {
801031f8:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
801031fd:	85 c0                	test   %eax,%eax
801031ff:	75 e3                	jne    801031e4 <begin_trans+0x14>
  }
  log.busy = 1;
80103201:	c7 05 dc f8 10 80 01 	movl   $0x1,0x8010f8dc
80103208:	00 00 00 
  release(&log.lock);
8010320b:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103212:	e8 8e 1b 00 00       	call   80104da5 <release>
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
8010321f:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103224:	85 c0                	test   %eax,%eax
80103226:	7e 19                	jle    80103241 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103228:	e8 08 ff ff ff       	call   80103135 <write_head>
    install_trans(); // Now install writes to home locations
8010322d:	e8 ea fd ff ff       	call   8010301c <install_trans>
    log.lh.n = 0; 
80103232:	c7 05 e4 f8 10 80 00 	movl   $0x0,0x8010f8e4
80103239:	00 00 00 
    write_head();    // Erase the transaction from the log
8010323c:	e8 f4 fe ff ff       	call   80103135 <write_head>
  }
  
  acquire(&log.lock);
80103241:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
80103248:	e8 f6 1a 00 00       	call   80104d43 <acquire>
  log.busy = 0;
8010324d:	c7 05 dc f8 10 80 00 	movl   $0x0,0x8010f8dc
80103254:	00 00 00 
  wakeup(&log);
80103257:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010325e:	e8 c2 18 00 00       	call   80104b25 <wakeup>
  release(&log.lock);
80103263:	c7 04 24 a0 f8 10 80 	movl   $0x8010f8a0,(%esp)
8010326a:	e8 36 1b 00 00       	call   80104da5 <release>
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
80103277:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
8010327c:	83 f8 09             	cmp    $0x9,%eax
8010327f:	7f 10                	jg     80103291 <log_write+0x20>
80103281:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103286:	8b 15 d8 f8 10 80    	mov    0x8010f8d8,%edx
8010328c:	4a                   	dec    %edx
8010328d:	39 d0                	cmp    %edx,%eax
8010328f:	7c 0c                	jl     8010329d <log_write+0x2c>
    panic("too big a transaction");
80103291:	c7 04 24 48 86 10 80 	movl   $0x80108648,(%esp)
80103298:	e8 99 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010329d:	a1 dc f8 10 80       	mov    0x8010f8dc,%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	75 0c                	jne    801032b2 <log_write+0x41>
    panic("write outside of trans");
801032a6:	c7 04 24 5e 86 10 80 	movl   $0x8010865e,(%esp)
801032ad:	e8 84 d2 ff ff       	call   80100536 <panic>

  for (i = 0; i < log.lh.n; i++) {
801032b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032b9:	eb 1c                	jmp    801032d7 <log_write+0x66>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032be:	83 c0 10             	add    $0x10,%eax
801032c1:	8b 04 85 a8 f8 10 80 	mov    -0x7fef0758(,%eax,4),%eax
801032c8:	89 c2                	mov    %eax,%edx
801032ca:	8b 45 08             	mov    0x8(%ebp),%eax
801032cd:	8b 40 08             	mov    0x8(%eax),%eax
801032d0:	39 c2                	cmp    %eax,%edx
801032d2:	74 0f                	je     801032e3 <log_write+0x72>
  for (i = 0; i < log.lh.n; i++) {
801032d4:	ff 45 f4             	incl   -0xc(%ebp)
801032d7:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
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
801032f0:	89 04 95 a8 f8 10 80 	mov    %eax,-0x7fef0758(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801032f7:	8b 15 d4 f8 10 80    	mov    0x8010f8d4,%edx
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
80103335:	e8 27 1d 00 00       	call   80105061 <memmove>
  bwrite(lbuf);
8010333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333d:	89 04 24             	mov    %eax,(%esp)
80103340:	e8 98 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103345:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103348:	89 04 24             	mov    %eax,(%esp)
8010334b:	e8 c7 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103350:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
80103355:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103358:	75 0b                	jne    80103365 <log_write+0xf4>
    log.lh.n++;
8010335a:	a1 e4 f8 10 80       	mov    0x8010f8e4,%eax
8010335f:	40                   	inc    %eax
80103360:	a3 e4 f8 10 80       	mov    %eax,0x8010f8e4
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
801033c6:	c7 04 24 3c 2a 11 80 	movl   $0x80112a3c,(%esp)
801033cd:	e8 be f5 ff ff       	call   80102990 <kinit1>
  kvmalloc();      // kernel page table
801033d2:	e8 bd 48 00 00       	call   80107c94 <kvmalloc>
  mpinit();        // collect info about this machine
801033d7:	e8 93 04 00 00       	call   8010386f <mpinit>
  lapicinit();
801033dc:	e8 07 f9 ff ff       	call   80102ce8 <lapicinit>
  seginit();       // set up segments
801033e1:	e8 6a 42 00 00       	call   80107650 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033ec:	8a 00                	mov    (%eax),%al
801033ee:	0f b6 c0             	movzbl %al,%eax
801033f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f5:	c7 04 24 75 86 10 80 	movl   $0x80108675,(%esp)
801033fc:	e8 a0 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103401:	e8 cf 06 00 00       	call   80103ad5 <picinit>
  ioapicinit();    // another interrupt controller
80103406:	e8 7f f4 ff ff       	call   8010288a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010340b:	e8 4d d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103410:	e8 90 35 00 00       	call   801069a5 <uartinit>
  pinit();         // process table
80103415:	e8 87 0d 00 00       	call   801041a1 <pinit>
  tvinit();        // trap vectors
8010341a:	e8 39 31 00 00       	call   80106558 <tvinit>
  binit();         // buffer cache
8010341f:	e8 10 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103424:	e8 ae da ff ff       	call   80100ed7 <fileinit>
  iinit();         // inode cache
80103429:	e8 59 e1 ff ff       	call   80101587 <iinit>
  ideinit();       // disk
8010342e:	e8 c2 f0 ff ff       	call   801024f5 <ideinit>
  if(!ismp)
80103433:	a1 24 f9 10 80       	mov    0x8010f924,%eax
80103438:	85 c0                	test   %eax,%eax
8010343a:	75 05                	jne    80103441 <main+0x8c>
    timerinit();   // uniprocessor timer
8010343c:	e8 5f 30 00 00       	call   801064a0 <timerinit>
  startothers();   // start other processors
80103441:	e8 7e 00 00 00       	call   801034c4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103446:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010344d:	8e 
8010344e:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103455:	e8 6e f5 ff ff       	call   801029c8 <kinit2>
  userinit();      // first user process
8010345a:	e8 6b 0e 00 00       	call   801042ca <userinit>
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
8010346a:	e8 3c 48 00 00       	call   80107cab <switchkvm>
  seginit();
8010346f:	e8 dc 41 00 00       	call   80107650 <seginit>
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
80103493:	c7 04 24 8c 86 10 80 	movl   $0x8010868c,(%esp)
8010349a:	e8 02 cf ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
8010349f:	e8 11 32 00 00       	call   801066b5 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034aa:	05 a8 00 00 00       	add    $0xa8,%eax
801034af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034b6:	00 
801034b7:	89 04 24             	mov    %eax,(%esp)
801034ba:	e8 d1 fe ff ff       	call   80103390 <xchg>
  scheduler();     // start running processes
801034bf:	e8 5f 13 00 00       	call   80104823 <scheduler>

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
801034e3:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
801034ea:	80 
801034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ee:	89 04 24             	mov    %eax,(%esp)
801034f1:	e8 6b 1b 00 00       	call   80105061 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801034f6:	c7 45 f4 40 f9 10 80 	movl   $0x8010f940,-0xc(%ebp)
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
80103517:	05 40 f9 10 80       	add    $0x8010f940,%eax
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
8010354c:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
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
80103591:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103596:	89 c2                	mov    %eax,%edx
80103598:	89 d0                	mov    %edx,%eax
8010359a:	d1 e0                	shl    %eax
8010359c:	01 d0                	add    %edx,%eax
8010359e:	c1 e0 04             	shl    $0x4,%eax
801035a1:	29 d0                	sub    %edx,%eax
801035a3:	c1 e0 02             	shl    $0x2,%eax
801035a6:	05 40 f9 10 80       	add    $0x8010f940,%eax
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
8010360e:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80103613:	89 c2                	mov    %eax,%edx
80103615:	b8 40 f9 10 80       	mov    $0x8010f940,%eax
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
801036c9:	c7 44 24 04 a0 86 10 	movl   $0x801086a0,0x4(%esp)
801036d0:	80 
801036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d4:	89 04 24             	mov    %eax,(%esp)
801036d7:	e8 30 19 00 00       	call   8010500c <memcmp>
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
80103806:	c7 44 24 04 a5 86 10 	movl   $0x801086a5,0x4(%esp)
8010380d:	80 
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	89 04 24             	mov    %eax,(%esp)
80103814:	e8 f3 17 00 00       	call   8010500c <memcmp>
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
80103875:	c7 05 64 b6 10 80 40 	movl   $0x8010f940,0x8010b664
8010387c:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
8010387f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103882:	89 04 24             	mov    %eax,(%esp)
80103885:	e8 3b ff ff ff       	call   801037c5 <mpconfig>
8010388a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010388d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103891:	0f 84 a4 01 00 00    	je     80103a3b <mpinit+0x1cc>
    return;
  ismp = 1;
80103897:	c7 05 24 f9 10 80 01 	movl   $0x1,0x8010f924
8010389e:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a4:	8b 40 24             	mov    0x24(%eax),%eax
801038a7:	a3 9c f8 10 80       	mov    %eax,0x8010f89c
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
801038dc:	8b 04 85 e8 86 10 80 	mov    -0x7fef7918(,%eax,4),%eax
801038e3:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038ee:	8a 40 01             	mov    0x1(%eax),%al
801038f1:	0f b6 d0             	movzbl %al,%edx
801038f4:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
801038f9:	39 c2                	cmp    %eax,%edx
801038fb:	74 2c                	je     80103929 <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103900:	8a 40 01             	mov    0x1(%eax),%al
80103903:	0f b6 d0             	movzbl %al,%edx
80103906:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010390b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010390f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103913:	c7 04 24 aa 86 10 80 	movl   $0x801086aa,(%esp)
8010391a:	e8 82 ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
8010391f:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
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
80103939:	8b 15 20 ff 10 80    	mov    0x8010ff20,%edx
8010393f:	89 d0                	mov    %edx,%eax
80103941:	d1 e0                	shl    %eax
80103943:	01 d0                	add    %edx,%eax
80103945:	c1 e0 04             	shl    $0x4,%eax
80103948:	29 d0                	sub    %edx,%eax
8010394a:	c1 e0 02             	shl    $0x2,%eax
8010394d:	05 40 f9 10 80       	add    $0x8010f940,%eax
80103952:	a3 64 b6 10 80       	mov    %eax,0x8010b664
      cpus[ncpu].id = ncpu;
80103957:	8b 15 20 ff 10 80    	mov    0x8010ff20,%edx
8010395d:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
80103962:	88 c1                	mov    %al,%cl
80103964:	89 d0                	mov    %edx,%eax
80103966:	d1 e0                	shl    %eax
80103968:	01 d0                	add    %edx,%eax
8010396a:	c1 e0 04             	shl    $0x4,%eax
8010396d:	29 d0                	sub    %edx,%eax
8010396f:	c1 e0 02             	shl    $0x2,%eax
80103972:	05 40 f9 10 80       	add    $0x8010f940,%eax
80103977:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103979:	a1 20 ff 10 80       	mov    0x8010ff20,%eax
8010397e:	40                   	inc    %eax
8010397f:	a3 20 ff 10 80       	mov    %eax,0x8010ff20
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
80103996:	a2 20 f9 10 80       	mov    %al,0x8010f920
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
801039b3:	c7 04 24 c8 86 10 80 	movl   $0x801086c8,(%esp)
801039ba:	e8 e2 c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039bf:	c7 05 24 f9 10 80 00 	movl   $0x0,0x8010f924
801039c6:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039cf:	0f 82 f6 fe ff ff    	jb     801038cb <mpinit+0x5c>
    }
  }
  if(!ismp){
801039d5:	a1 24 f9 10 80       	mov    0x8010f924,%eax
801039da:	85 c0                	test   %eax,%eax
801039dc:	75 1d                	jne    801039fb <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039de:	c7 05 20 ff 10 80 01 	movl   $0x1,0x8010ff20
801039e5:	00 00 00 
    lapic = 0;
801039e8:	c7 05 9c f8 10 80 00 	movl   $0x0,0x8010f89c
801039ef:	00 00 00 
    ioapicid = 0;
801039f2:	c6 05 20 f9 10 80 00 	movb   $0x0,0x8010f920
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
80103a69:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
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
80103abc:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
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
80103bf3:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
80103bf9:	66 83 f8 ff          	cmp    $0xffff,%ax
80103bfd:	74 11                	je     80103c10 <picinit+0x13b>
    picsetmask(irqmask);
80103bff:	66 a1 00 b0 10 80    	mov    0x8010b000,%ax
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
80103ca9:	c7 44 24 04 fc 86 10 	movl   $0x801086fc,0x4(%esp)
80103cb0:	80 
80103cb1:	89 04 24             	mov    %eax,(%esp)
80103cb4:	e8 69 10 00 00       	call   80104d22 <initlock>
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
80103d61:	e8 dd 0f 00 00       	call   80104d43 <acquire>
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
80103d84:	e8 9c 0d 00 00       	call   80104b25 <wakeup>
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
80103da3:	e8 7d 0d 00 00       	call   80104b25 <wakeup>
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
80103dc8:	e8 d8 0f 00 00       	call   80104da5 <release>
    kfree((char*)p);
80103dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd0:	89 04 24             	mov    %eax,(%esp)
80103dd3:	e8 4d ec ff ff       	call   80102a25 <kfree>
80103dd8:	eb 0b                	jmp    80103de5 <pipeclose+0x90>
  } else
    release(&p->lock);
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	89 04 24             	mov    %eax,(%esp)
80103de0:	e8 c0 0f 00 00       	call   80104da5 <release>
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
80103df4:	e8 4a 0f 00 00       	call   80104d43 <acquire>
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
80103e25:	e8 7b 0f 00 00       	call   80104da5 <release>
        return -1;
80103e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2f:	e9 9d 00 00 00       	jmp    80103ed1 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e34:	8b 45 08             	mov    0x8(%ebp),%eax
80103e37:	05 34 02 00 00       	add    $0x234,%eax
80103e3c:	89 04 24             	mov    %eax,(%esp)
80103e3f:	e8 e1 0c 00 00       	call   80104b25 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e44:	8b 45 08             	mov    0x8(%ebp),%eax
80103e47:	8b 55 08             	mov    0x8(%ebp),%edx
80103e4a:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e54:	89 14 24             	mov    %edx,(%esp)
80103e57:	e8 c1 0b 00 00       	call   80104a1d <sleep>
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
80103ebe:	e8 62 0c 00 00       	call   80104b25 <wakeup>
  release(&p->lock);
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec6:	89 04 24             	mov    %eax,(%esp)
80103ec9:	e8 d7 0e 00 00       	call   80104da5 <release>
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
80103ee4:	e8 5a 0e 00 00       	call   80104d43 <acquire>
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
80103efe:	e8 a2 0e 00 00       	call   80104da5 <release>
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
80103f20:	e8 f8 0a 00 00       	call   80104a1d <sleep>
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
80103faf:	e8 71 0b 00 00       	call   80104b25 <wakeup>
  release(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 04 24             	mov    %eax,(%esp)
80103fba:	e8 e6 0d 00 00       	call   80104da5 <release>
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

80103fe3 <enqueue>:

static void wakeup1(void *chan);

void
enqueue(struct proc *p) // New: Added in proyect 2
{
80103fe3:	55                   	push   %ebp
80103fe4:	89 e5                	mov    %esp,%ebp
80103fe6:	83 ec 28             	sub    $0x28,%esp
  struct proc *prev;
  if(p->priority>=0 && p->priority<MLF_LEVELS){
80103fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fec:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80103ff2:	85 c0                	test   %eax,%eax
80103ff4:	0f 88 b8 00 00 00    	js     801040b2 <enqueue+0xcf>
80103ffa:	8b 45 08             	mov    0x8(%ebp),%eax
80103ffd:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104003:	83 f8 03             	cmp    $0x3,%eax
80104006:	0f 8f a6 00 00 00    	jg     801040b2 <enqueue+0xcf>
    //if priority level is empty (there is no proc)
    if(ptable.mlf[p->priority].first == 0){
8010400c:	8b 45 08             	mov    0x8(%ebp),%eax
8010400f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104015:	05 46 04 00 00       	add    $0x446,%eax
8010401a:	8b 04 c5 44 ff 10 80 	mov    -0x7fef00bc(,%eax,8),%eax
80104021:	85 c0                	test   %eax,%eax
80104023:	75 41                	jne    80104066 <enqueue+0x83>
      ptable.mlf[p->priority].first=p; //set first
80104025:	8b 45 08             	mov    0x8(%ebp),%eax
80104028:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010402e:	8d 90 46 04 00 00    	lea    0x446(%eax),%edx
80104034:	8b 45 08             	mov    0x8(%ebp),%eax
80104037:	89 04 d5 44 ff 10 80 	mov    %eax,-0x7fef00bc(,%edx,8)
      ptable.mlf[p->priority].last=p; //set last
8010403e:	8b 45 08             	mov    0x8(%ebp),%eax
80104041:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104047:	8d 90 46 04 00 00    	lea    0x446(%eax),%edx
8010404d:	8b 45 08             	mov    0x8(%ebp),%eax
80104050:	89 04 d5 48 ff 10 80 	mov    %eax,-0x7fef00b8(,%edx,8)
      p->next=0;  //set next in "null"
80104057:	8b 45 08             	mov    0x8(%ebp),%eax
8010405a:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104061:	00 00 00 
    if(ptable.mlf[p->priority].first == 0){
80104064:	eb 58                	jmp    801040be <enqueue+0xdb>
    }else{
      prev=ptable.mlf[p->priority].last;//get previous last
80104066:	8b 45 08             	mov    0x8(%ebp),%eax
80104069:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010406f:	05 46 04 00 00       	add    $0x446,%eax
80104074:	8b 04 c5 48 ff 10 80 	mov    -0x7fef00b8(,%eax,8),%eax
8010407b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      prev->next=p; //set new proc as next of previous last
8010407e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104081:	8b 55 08             	mov    0x8(%ebp),%edx
80104084:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
      ptable.mlf[p->priority].last=p; //refresh last
8010408a:	8b 45 08             	mov    0x8(%ebp),%eax
8010408d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104093:	8d 90 46 04 00 00    	lea    0x446(%eax),%edx
80104099:	8b 45 08             	mov    0x8(%ebp),%eax
8010409c:	89 04 d5 48 ff 10 80 	mov    %eax,-0x7fef00b8(,%edx,8)
      p->next=0;
801040a3:	8b 45 08             	mov    0x8(%ebp),%eax
801040a6:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
801040ad:	00 00 00 
    if(ptable.mlf[p->priority].first == 0){
801040b0:	eb 0c                	jmp    801040be <enqueue+0xdb>
    }
  }else{
    cprintf("ERROR ENQUEUE\n");
801040b2:	c7 04 24 01 87 10 80 	movl   $0x80108701,(%esp)
801040b9:	e8 e3 c2 ff ff       	call   801003a1 <cprintf>
  }
}
801040be:	c9                   	leave  
801040bf:	c3                   	ret    

801040c0 <dequeue>:

struct proc *
dequeue(int priority) // New: Added in proyect 2
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	83 ec 10             	sub    $0x10,%esp
  struct proc *res; // result pointer
  // save first proc of the list
  res=ptable.mlf[priority].first;
801040c6:	8b 45 08             	mov    0x8(%ebp),%eax
801040c9:	05 46 04 00 00       	add    $0x446,%eax
801040ce:	8b 04 c5 44 ff 10 80 	mov    -0x7fef00bc(,%eax,8),%eax
801040d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  // when a proc is dequeued, refresh first element of the priority level
  ptable.mlf[priority].first=ptable.mlf[priority].first->next;
801040d8:	8b 45 08             	mov    0x8(%ebp),%eax
801040db:	05 46 04 00 00       	add    $0x446,%eax
801040e0:	8b 04 c5 44 ff 10 80 	mov    -0x7fef00bc(,%eax,8),%eax
801040e7:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801040ed:	8b 55 08             	mov    0x8(%ebp),%edx
801040f0:	81 c2 46 04 00 00    	add    $0x446,%edx
801040f6:	89 04 d5 44 ff 10 80 	mov    %eax,-0x7fef00bc(,%edx,8)
  res->next=0;
801040fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104100:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104107:	00 00 00 
  return res;
8010410a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010410d:	c9                   	leave  
8010410e:	c3                   	ret    

8010410f <isempty>:

int
isempty(int priority) // New: Added in proyect 2
{
8010410f:	55                   	push   %ebp
80104110:	89 e5                	mov    %esp,%ebp
  if(ptable.mlf[priority].first!=0){
80104112:	8b 45 08             	mov    0x8(%ebp),%eax
80104115:	05 46 04 00 00       	add    $0x446,%eax
8010411a:	8b 04 c5 44 ff 10 80 	mov    -0x7fef00bc(,%eax,8),%eax
80104121:	85 c0                	test   %eax,%eax
80104123:	74 07                	je     8010412c <isempty+0x1d>
    return 0;
80104125:	b8 00 00 00 00       	mov    $0x0,%eax
8010412a:	eb 05                	jmp    80104131 <isempty+0x22>
  }
  return 1;
8010412c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104131:	5d                   	pop    %ebp
80104132:	c3                   	ret    

80104133 <makerunnable>:

void
makerunnable(struct proc *p, int priority) // New: Added in proyect 2
// level can be: 0, 1, -1
{
80104133:	55                   	push   %ebp
80104134:	89 e5                	mov    %esp,%ebp
80104136:	83 ec 18             	sub    $0x18,%esp
  if (priority==1 && p->priority<SIZEMLF-1)
80104139:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
8010413d:	75 23                	jne    80104162 <makerunnable+0x2f>
8010413f:	8b 45 08             	mov    0x8(%ebp),%eax
80104142:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104148:	83 f8 02             	cmp    $0x2,%eax
8010414b:	7f 15                	jg     80104162 <makerunnable+0x2f>
  {
    p->priority++;
8010414d:	8b 45 08             	mov    0x8(%ebp),%eax
80104150:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104156:	8d 50 01             	lea    0x1(%eax),%edx
80104159:	8b 45 08             	mov    0x8(%ebp),%eax
8010415c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  if (priority==-1 && p->priority>0)
80104162:	83 7d 0c ff          	cmpl   $0xffffffff,0xc(%ebp)
80104166:	75 22                	jne    8010418a <makerunnable+0x57>
80104168:	8b 45 08             	mov    0x8(%ebp),%eax
8010416b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104171:	85 c0                	test   %eax,%eax
80104173:	7e 15                	jle    8010418a <makerunnable+0x57>
  {
    p->priority--;
80104175:	8b 45 08             	mov    0x8(%ebp),%eax
80104178:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010417e:	8d 50 ff             	lea    -0x1(%eax),%edx
80104181:	8b 45 08             	mov    0x8(%ebp),%eax
80104184:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  p->state = RUNNABLE;
8010418a:	8b 45 08             	mov    0x8(%ebp),%eax
8010418d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  enqueue(p);
80104194:	8b 45 08             	mov    0x8(%ebp),%eax
80104197:	89 04 24             	mov    %eax,(%esp)
8010419a:	e8 44 fe ff ff       	call   80103fe3 <enqueue>
}
8010419f:	c9                   	leave  
801041a0:	c3                   	ret    

801041a1 <pinit>:

void
pinit(void)
{
801041a1:	55                   	push   %ebp
801041a2:	89 e5                	mov    %esp,%ebp
801041a4:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801041a7:	c7 44 24 04 10 87 10 	movl   $0x80108710,0x4(%esp)
801041ae:	80 
801041af:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801041b6:	e8 67 0b 00 00       	call   80104d22 <initlock>
}
801041bb:	c9                   	leave  
801041bc:	c3                   	ret    

801041bd <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801041bd:	55                   	push   %ebp
801041be:	89 e5                	mov    %esp,%ebp
801041c0:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801041c3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801041ca:	e8 74 0b 00 00       	call   80104d43 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041cf:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
801041d6:	eb 11                	jmp    801041e9 <allocproc+0x2c>
    if(p->state == UNUSED)
801041d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041db:	8b 40 0c             	mov    0xc(%eax),%eax
801041de:	85 c0                	test   %eax,%eax
801041e0:	74 26                	je     80104208 <allocproc+0x4b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e2:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801041e9:	81 7d f4 74 21 11 80 	cmpl   $0x80112174,-0xc(%ebp)
801041f0:	72 e6                	jb     801041d8 <allocproc+0x1b>
      goto found;
  release(&ptable.lock);
801041f2:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801041f9:	e8 a7 0b 00 00       	call   80104da5 <release>
  return 0;
801041fe:	b8 00 00 00 00       	mov    $0x0,%eax
80104203:	e9 c0 00 00 00       	jmp    801042c8 <allocproc+0x10b>
      goto found;
80104208:	90                   	nop

found:
  p->state = EMBRYO;
80104209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420c:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104213:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104218:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010421b:	89 42 10             	mov    %eax,0x10(%edx)
8010421e:	40                   	inc    %eax
8010421f:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
80104224:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010422b:	e8 75 0b 00 00       	call   80104da5 <release>

  p->priority=0; // New: Added in proyect 2: set priority in zero 
80104230:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104233:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010423a:	00 00 00 

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010423d:	e8 7c e8 ff ff       	call   80102abe <kalloc>
80104242:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104245:	89 42 08             	mov    %eax,0x8(%edx)
80104248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010424b:	8b 40 08             	mov    0x8(%eax),%eax
8010424e:	85 c0                	test   %eax,%eax
80104250:	75 11                	jne    80104263 <allocproc+0xa6>
    p->state = UNUSED;
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010425c:	b8 00 00 00 00       	mov    $0x0,%eax
80104261:	eb 65                	jmp    801042c8 <allocproc+0x10b>
  }
  sp = p->kstack + KSTACKSIZE;
80104263:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104266:	8b 40 08             	mov    0x8(%eax),%eax
80104269:	05 00 10 00 00       	add    $0x1000,%eax
8010426e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104271:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104275:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104278:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010427b:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010427e:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104282:	ba 10 65 10 80       	mov    $0x80106510,%edx
80104287:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010428a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010428c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104290:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104293:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104296:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010429f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801042a6:	00 
801042a7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801042ae:	00 
801042af:	89 04 24             	mov    %eax,(%esp)
801042b2:	e8 de 0c 00 00       	call   80104f95 <memset>
  p->context->eip = (uint)forkret;
801042b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ba:	8b 40 1c             	mov    0x1c(%eax),%eax
801042bd:	ba f1 49 10 80       	mov    $0x801049f1,%edx
801042c2:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801042c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801042c8:	c9                   	leave  
801042c9:	c3                   	ret    

801042ca <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801042ca:	55                   	push   %ebp
801042cb:	89 e5                	mov    %esp,%ebp
801042cd:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
801042d0:	e8 e8 fe ff ff       	call   801041bd <allocproc>
801042d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
801042d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042db:	a3 68 b6 10 80       	mov    %eax,0x8010b668
  if((p->pgdir = setupkvm()) == 0)
801042e0:	e8 f2 38 00 00       	call   80107bd7 <setupkvm>
801042e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042e8:	89 42 04             	mov    %eax,0x4(%edx)
801042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ee:	8b 40 04             	mov    0x4(%eax),%eax
801042f1:	85 c0                	test   %eax,%eax
801042f3:	75 0c                	jne    80104301 <userinit+0x37>
    panic("userinit: out of memory?");
801042f5:	c7 04 24 17 87 10 80 	movl   $0x80108717,(%esp)
801042fc:	e8 35 c2 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104301:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104309:	8b 40 04             	mov    0x4(%eax),%eax
8010430c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104310:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
80104317:	80 
80104318:	89 04 24             	mov    %eax,(%esp)
8010431b:	e8 03 3b 00 00       	call   80107e23 <inituvm>
  p->sz = PGSIZE;
80104320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104323:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104329:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432c:	8b 40 18             	mov    0x18(%eax),%eax
8010432f:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104336:	00 
80104337:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010433e:	00 
8010433f:	89 04 24             	mov    %eax,(%esp)
80104342:	e8 4e 0c 00 00       	call   80104f95 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434a:	8b 40 18             	mov    0x18(%eax),%eax
8010434d:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104353:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104356:	8b 40 18             	mov    0x18(%eax),%eax
80104359:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104362:	8b 50 18             	mov    0x18(%eax),%edx
80104365:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104368:	8b 40 18             	mov    0x18(%eax),%eax
8010436b:	8b 40 2c             	mov    0x2c(%eax),%eax
8010436e:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
80104372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104375:	8b 50 18             	mov    0x18(%eax),%edx
80104378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437b:	8b 40 18             	mov    0x18(%eax),%eax
8010437e:	8b 40 2c             	mov    0x2c(%eax),%eax
80104381:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
80104385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104388:	8b 40 18             	mov    0x18(%eax),%eax
8010438b:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104395:	8b 40 18             	mov    0x18(%eax),%eax
80104398:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010439f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a2:	8b 40 18             	mov    0x18(%eax),%eax
801043a5:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801043ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043af:	83 c0 6c             	add    $0x6c,%eax
801043b2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043b9:	00 
801043ba:	c7 44 24 04 30 87 10 	movl   $0x80108730,0x4(%esp)
801043c1:	80 
801043c2:	89 04 24             	mov    %eax,(%esp)
801043c5:	e8 dd 0d 00 00       	call   801051a7 <safestrcpy>
  p->cwd = namei("/");
801043ca:	c7 04 24 39 87 10 80 	movl   $0x80108739,(%esp)
801043d1:	e8 09 e0 ff ff       	call   801023df <namei>
801043d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043d9:	89 42 68             	mov    %eax,0x68(%edx)

  // p->state = RUNNABLE;
  makerunnable(p,0); // New: Added in proyect 2: enqueue proc
801043dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801043e3:	00 
801043e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e7:	89 04 24             	mov    %eax,(%esp)
801043ea:	e8 44 fd ff ff       	call   80104133 <makerunnable>

}
801043ef:	c9                   	leave  
801043f0:	c3                   	ret    

801043f1 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801043f1:	55                   	push   %ebp
801043f2:	89 e5                	mov    %esp,%ebp
801043f4:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801043f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043fd:	8b 00                	mov    (%eax),%eax
801043ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104402:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104406:	7e 34                	jle    8010443c <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104408:	8b 55 08             	mov    0x8(%ebp),%edx
8010440b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440e:	01 c2                	add    %eax,%edx
80104410:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104416:	8b 40 04             	mov    0x4(%eax),%eax
80104419:	89 54 24 08          	mov    %edx,0x8(%esp)
8010441d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104420:	89 54 24 04          	mov    %edx,0x4(%esp)
80104424:	89 04 24             	mov    %eax,(%esp)
80104427:	e8 71 3b 00 00       	call   80107f9d <allocuvm>
8010442c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010442f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104433:	75 41                	jne    80104476 <growproc+0x85>
      return -1;
80104435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443a:	eb 58                	jmp    80104494 <growproc+0xa3>
  } else if(n < 0){
8010443c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104440:	79 34                	jns    80104476 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104442:	8b 55 08             	mov    0x8(%ebp),%edx
80104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104448:	01 c2                	add    %eax,%edx
8010444a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104450:	8b 40 04             	mov    0x4(%eax),%eax
80104453:	89 54 24 08          	mov    %edx,0x8(%esp)
80104457:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010445a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010445e:	89 04 24             	mov    %eax,(%esp)
80104461:	e8 11 3c 00 00       	call   80108077 <deallocuvm>
80104466:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010446d:	75 07                	jne    80104476 <growproc+0x85>
      return -1;
8010446f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104474:	eb 1e                	jmp    80104494 <growproc+0xa3>
  }
  proc->sz = sz;
80104476:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010447c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447f:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104481:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104487:	89 04 24             	mov    %eax,(%esp)
8010448a:	e8 39 38 00 00       	call   80107cc8 <switchuvm>
  return 0;
8010448f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104494:	c9                   	leave  
80104495:	c3                   	ret    

80104496 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104496:	55                   	push   %ebp
80104497:	89 e5                	mov    %esp,%ebp
80104499:	57                   	push   %edi
8010449a:	56                   	push   %esi
8010449b:	53                   	push   %ebx
8010449c:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010449f:	e8 19 fd ff ff       	call   801041bd <allocproc>
801044a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
801044a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801044ab:	75 0a                	jne    801044b7 <fork+0x21>
    return -1;
801044ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b2:	e9 38 01 00 00       	jmp    801045ef <fork+0x159>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801044b7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044bd:	8b 10                	mov    (%eax),%edx
801044bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044c5:	8b 40 04             	mov    0x4(%eax),%eax
801044c8:	89 54 24 04          	mov    %edx,0x4(%esp)
801044cc:	89 04 24             	mov    %eax,(%esp)
801044cf:	e8 3e 3d 00 00       	call   80108212 <copyuvm>
801044d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801044d7:	89 42 04             	mov    %eax,0x4(%edx)
801044da:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044dd:	8b 40 04             	mov    0x4(%eax),%eax
801044e0:	85 c0                	test   %eax,%eax
801044e2:	75 22                	jne    80104506 <fork+0x70>
    kfree(np->kstack);
801044e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044e7:	8b 40 08             	mov    0x8(%eax),%eax
801044ea:	89 04 24             	mov    %eax,(%esp)
801044ed:	e8 33 e5 ff ff       	call   80102a25 <kfree>
    // np->kstack = 0;
    np->state = UNUSED;
801044f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044f5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801044fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104501:	e9 e9 00 00 00       	jmp    801045ef <fork+0x159>
  }
  np->sz = proc->sz;
80104506:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010450c:	8b 10                	mov    (%eax),%edx
8010450e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104511:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104513:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010451a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010451d:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104520:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104523:	8b 50 18             	mov    0x18(%eax),%edx
80104526:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010452c:	8b 40 18             	mov    0x18(%eax),%eax
8010452f:	89 c3                	mov    %eax,%ebx
80104531:	b8 13 00 00 00       	mov    $0x13,%eax
80104536:	89 d7                	mov    %edx,%edi
80104538:	89 de                	mov    %ebx,%esi
8010453a:	89 c1                	mov    %eax,%ecx
8010453c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
8010453e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104541:	8b 40 18             	mov    0x18(%eax),%eax
80104544:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
8010454b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104552:	eb 3c                	jmp    80104590 <fork+0xfa>
    if(proc->ofile[i])
80104554:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010455a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010455d:	83 c2 08             	add    $0x8,%edx
80104560:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104564:	85 c0                	test   %eax,%eax
80104566:	74 25                	je     8010458d <fork+0xf7>
      np->ofile[i] = filedup(proc->ofile[i]);
80104568:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010456e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104571:	83 c2 08             	add    $0x8,%edx
80104574:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104578:	89 04 24             	mov    %eax,(%esp)
8010457b:	e8 d3 c9 ff ff       	call   80100f53 <filedup>
80104580:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104583:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104586:	83 c1 08             	add    $0x8,%ecx
80104589:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
8010458d:	ff 45 e4             	incl   -0x1c(%ebp)
80104590:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104594:	7e be                	jle    80104554 <fork+0xbe>
  np->cwd = idup(proc->cwd);
80104596:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010459c:	8b 40 68             	mov    0x68(%eax),%eax
8010459f:	89 04 24             	mov    %eax,(%esp)
801045a2:	e8 6c d2 ff ff       	call   80101813 <idup>
801045a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
801045aa:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801045ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045b0:	8b 40 10             	mov    0x10(%eax),%eax
801045b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  // np->state = RUNNABLE;
  makerunnable(np,0); // New: Added in proyect 2: every process enqueued is RUNNABLE
801045b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801045bd:	00 
801045be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c1:	89 04 24             	mov    %eax,(%esp)
801045c4:	e8 6a fb ff ff       	call   80104133 <makerunnable>
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801045c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045cf:	8d 50 6c             	lea    0x6c(%eax),%edx
801045d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045d5:	83 c0 6c             	add    $0x6c,%eax
801045d8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801045df:	00 
801045e0:	89 54 24 04          	mov    %edx,0x4(%esp)
801045e4:	89 04 24             	mov    %eax,(%esp)
801045e7:	e8 bb 0b 00 00       	call   801051a7 <safestrcpy>
  return pid;
801045ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801045ef:	83 c4 2c             	add    $0x2c,%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5f                   	pop    %edi
801045f5:	5d                   	pop    %ebp
801045f6:	c3                   	ret    

801045f7 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
801045f7:	55                   	push   %ebp
801045f8:	89 e5                	mov    %esp,%ebp
801045fa:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
801045fd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104604:	a1 68 b6 10 80       	mov    0x8010b668,%eax
80104609:	39 c2                	cmp    %eax,%edx
8010460b:	75 0c                	jne    80104619 <exit+0x22>
    panic("init exiting");
8010460d:	c7 04 24 3b 87 10 80 	movl   $0x8010873b,(%esp)
80104614:	e8 1d bf ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104619:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104620:	eb 43                	jmp    80104665 <exit+0x6e>
    if(proc->ofile[fd]){
80104622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104628:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010462b:	83 c2 08             	add    $0x8,%edx
8010462e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104632:	85 c0                	test   %eax,%eax
80104634:	74 2c                	je     80104662 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104636:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010463c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010463f:	83 c2 08             	add    $0x8,%edx
80104642:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104646:	89 04 24             	mov    %eax,(%esp)
80104649:	e8 4d c9 ff ff       	call   80100f9b <fileclose>
      proc->ofile[fd] = 0;
8010464e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104654:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104657:	83 c2 08             	add    $0x8,%edx
8010465a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104661:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104662:	ff 45 f0             	incl   -0x10(%ebp)
80104665:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104669:	7e b7                	jle    80104622 <exit+0x2b>
    }
  }

  iput(proc->cwd);
8010466b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104671:	8b 40 68             	mov    0x68(%eax),%eax
80104674:	89 04 24             	mov    %eax,(%esp)
80104677:	e8 79 d3 ff ff       	call   801019f5 <iput>
  proc->cwd = 0;
8010467c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104682:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104689:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104690:	e8 ae 06 00 00       	call   80104d43 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104695:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469b:	8b 40 14             	mov    0x14(%eax),%eax
8010469e:	89 04 24             	mov    %eax,(%esp)
801046a1:	e8 35 04 00 00       	call   80104adb <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a6:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
801046ad:	eb 3b                	jmp    801046ea <exit+0xf3>
    if(p->parent == proc){
801046af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b2:	8b 50 14             	mov    0x14(%eax),%edx
801046b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046bb:	39 c2                	cmp    %eax,%edx
801046bd:	75 24                	jne    801046e3 <exit+0xec>
      p->parent = initproc;
801046bf:	8b 15 68 b6 10 80    	mov    0x8010b668,%edx
801046c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c8:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ce:	8b 40 0c             	mov    0xc(%eax),%eax
801046d1:	83 f8 05             	cmp    $0x5,%eax
801046d4:	75 0d                	jne    801046e3 <exit+0xec>
        wakeup1(initproc);
801046d6:	a1 68 b6 10 80       	mov    0x8010b668,%eax
801046db:	89 04 24             	mov    %eax,(%esp)
801046de:	e8 f8 03 00 00       	call   80104adb <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046e3:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801046ea:	81 7d f4 74 21 11 80 	cmpl   $0x80112174,-0xc(%ebp)
801046f1:	72 bc                	jb     801046af <exit+0xb8>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
801046f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046f9:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104700:	e8 db 01 00 00       	call   801048e0 <sched>
  panic("zombie exit");
80104705:	c7 04 24 48 87 10 80 	movl   $0x80108748,(%esp)
8010470c:	e8 25 be ff ff       	call   80100536 <panic>

80104711 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104711:	55                   	push   %ebp
80104712:	89 e5                	mov    %esp,%ebp
80104714:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104717:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010471e:	e8 20 06 00 00       	call   80104d43 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104723:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010472a:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104731:	e9 9d 00 00 00       	jmp    801047d3 <wait+0xc2>
      if(p->parent != proc)
80104736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104739:	8b 50 14             	mov    0x14(%eax),%edx
8010473c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104742:	39 c2                	cmp    %eax,%edx
80104744:	0f 85 81 00 00 00    	jne    801047cb <wait+0xba>
        continue;
      havekids = 1;
8010474a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104754:	8b 40 0c             	mov    0xc(%eax),%eax
80104757:	83 f8 05             	cmp    $0x5,%eax
8010475a:	75 70                	jne    801047cc <wait+0xbb>
        // Found one.
        pid = p->pid;
8010475c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010475f:	8b 40 10             	mov    0x10(%eax),%eax
80104762:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104768:	8b 40 08             	mov    0x8(%eax),%eax
8010476b:	89 04 24             	mov    %eax,(%esp)
8010476e:	e8 b2 e2 ff ff       	call   80102a25 <kfree>
        p->kstack = 0;
80104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104776:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010477d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104780:	8b 40 04             	mov    0x4(%eax),%eax
80104783:	89 04 24             	mov    %eax,(%esp)
80104786:	e8 a8 39 00 00       	call   80108133 <freevm>
        p->state = UNUSED;
8010478b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104798:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
8010479f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a2:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801047a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ac:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801047b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b3:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801047ba:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801047c1:	e8 df 05 00 00       	call   80104da5 <release>
        return pid;
801047c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047c9:	eb 56                	jmp    80104821 <wait+0x110>
        continue;
801047cb:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047cc:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
801047d3:	81 7d f4 74 21 11 80 	cmpl   $0x80112174,-0xc(%ebp)
801047da:	0f 82 56 ff ff ff    	jb     80104736 <wait+0x25>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801047e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047e4:	74 0d                	je     801047f3 <wait+0xe2>
801047e6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047ec:	8b 40 24             	mov    0x24(%eax),%eax
801047ef:	85 c0                	test   %eax,%eax
801047f1:	74 13                	je     80104806 <wait+0xf5>
      release(&ptable.lock);
801047f3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801047fa:	e8 a6 05 00 00       	call   80104da5 <release>
      return -1;
801047ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104804:	eb 1b                	jmp    80104821 <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104806:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480c:	c7 44 24 04 40 ff 10 	movl   $0x8010ff40,0x4(%esp)
80104813:	80 
80104814:	89 04 24             	mov    %eax,(%esp)
80104817:	e8 01 02 00 00       	call   80104a1d <sleep>
  }
8010481c:	e9 02 ff ff ff       	jmp    80104723 <wait+0x12>
}
80104821:	c9                   	leave  
80104822:	c3                   	ret    

80104823 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104823:	55                   	push   %ebp
80104824:	89 e5                	mov    %esp,%ebp
80104826:	83 ec 28             	sub    $0x28,%esp
  int i; // New: Added in project 2
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104829:	e8 af f7 ff ff       	call   80103fdd <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010482e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104835:	e8 09 05 00 00       	call   80104d43 <acquire>
    // for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    //   if(p->state != RUNNABLE)
    //     continue; // continue, move pointer

    // Set pointer p in zero (null)
    p=0;
8010483a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    // Loop over MLF table looking for process to run.
    for(i=0; i<MLF_LEVELS; i++){
80104841:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104848:	eb 22                	jmp    8010486c <scheduler+0x49>
      if(!isempty(i)){
8010484a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010484d:	89 04 24             	mov    %eax,(%esp)
80104850:	e8 ba f8 ff ff       	call   8010410f <isempty>
80104855:	85 c0                	test   %eax,%eax
80104857:	75 10                	jne    80104869 <scheduler+0x46>
        // New - when a proc state changes to RUNNING it must be dequeued
        p=dequeue(i);
80104859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485c:	89 04 24             	mov    %eax,(%esp)
8010485f:	e8 5c f8 ff ff       	call   801040c0 <dequeue>
80104864:	89 45 f0             	mov    %eax,-0x10(%ebp)
        break;
80104867:	eb 09                	jmp    80104872 <scheduler+0x4f>
    for(i=0; i<MLF_LEVELS; i++){
80104869:	ff 45 f4             	incl   -0xc(%ebp)
8010486c:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80104870:	7e d8                	jle    8010484a <scheduler+0x27>
      }
    }

    // If pointer not null (RUNNABLE proccess found)
    if (p) {
80104872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104876:	74 57                	je     801048cf <scheduler+0xac>
      proc = p;
80104878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010487b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      // proc = p; 
      // proc = p; // p->state == RUNNABLE
      switchuvm(p);
80104881:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104884:	89 04 24             	mov    %eax,(%esp)
80104887:	e8 3c 34 00 00       	call   80107cc8 <switchuvm>
      p->state = RUNNING;
8010488c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010488f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->ticksProc = 0;  // New - when a proccess takes control, set ticksCounter on zero
80104896:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104899:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
      //cprintf("proccess %s takes control of the CPU...\n",p->name);
      swtch(&cpu->scheduler, proc->context);
801048a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048a6:	8b 40 1c             	mov    0x1c(%eax),%eax
801048a9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801048b0:	83 c2 04             	add    $0x4,%edx
801048b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801048b7:	89 14 24             	mov    %edx,(%esp)
801048ba:	e8 56 09 00 00       	call   80105215 <swtch>
      switchkvm();
801048bf:	e8 e7 33 00 00       	call   80107cab <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801048c4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801048cb:	00 00 00 00 
    }
    release(&ptable.lock);
801048cf:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801048d6:	e8 ca 04 00 00       	call   80104da5 <release>

  }
801048db:	e9 49 ff ff ff       	jmp    80104829 <scheduler+0x6>

801048e0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801048e6:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801048ed:	e8 79 05 00 00       	call   80104e6b <holding>
801048f2:	85 c0                	test   %eax,%eax
801048f4:	75 0c                	jne    80104902 <sched+0x22>
    panic("sched ptable.lock");
801048f6:	c7 04 24 54 87 10 80 	movl   $0x80108754,(%esp)
801048fd:	e8 34 bc ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
80104902:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104908:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010490e:	83 f8 01             	cmp    $0x1,%eax
80104911:	74 0c                	je     8010491f <sched+0x3f>
    panic("sched locks");
80104913:	c7 04 24 66 87 10 80 	movl   $0x80108766,(%esp)
8010491a:	e8 17 bc ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
8010491f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104925:	8b 40 0c             	mov    0xc(%eax),%eax
80104928:	83 f8 04             	cmp    $0x4,%eax
8010492b:	75 0c                	jne    80104939 <sched+0x59>
    panic("sched running");
8010492d:	c7 04 24 72 87 10 80 	movl   $0x80108772,(%esp)
80104934:	e8 fd bb ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80104939:	e8 8a f6 ff ff       	call   80103fc8 <readeflags>
8010493e:	25 00 02 00 00       	and    $0x200,%eax
80104943:	85 c0                	test   %eax,%eax
80104945:	74 0c                	je     80104953 <sched+0x73>
    panic("sched interruptible");
80104947:	c7 04 24 80 87 10 80 	movl   $0x80108780,(%esp)
8010494e:	e8 e3 bb ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104953:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104959:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010495f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104962:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104968:	8b 40 04             	mov    0x4(%eax),%eax
8010496b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104972:	83 c2 1c             	add    $0x1c,%edx
80104975:	89 44 24 04          	mov    %eax,0x4(%esp)
80104979:	89 14 24             	mov    %edx,(%esp)
8010497c:	e8 94 08 00 00       	call   80105215 <swtch>
  cpu->intena = intena;
80104981:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104987:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010498a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104990:	c9                   	leave  
80104991:	c3                   	ret    

80104992 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104992:	55                   	push   %ebp
80104993:	89 e5                	mov    %esp,%ebp
80104995:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104998:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
8010499f:	e8 9f 03 00 00       	call   80104d43 <acquire>
  // proc->state = RUNNABLE;
  // sched();
  if(proc->priority<3){ 
801049a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049aa:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801049b0:	83 f8 02             	cmp    $0x2,%eax
801049b3:	7f 13                	jg     801049c8 <yield+0x36>
    proc->priority++;
801049b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049bb:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801049c1:	42                   	inc    %edx
801049c2:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  makerunnable(proc,1); // New: Added in proyect 2: enqueue proc
801049c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801049d5:	00 
801049d6:	89 04 24             	mov    %eax,(%esp)
801049d9:	e8 55 f7 ff ff       	call   80104133 <makerunnable>
  sched(); 
801049de:	e8 fd fe ff ff       	call   801048e0 <sched>
  release(&ptable.lock);
801049e3:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801049ea:	e8 b6 03 00 00       	call   80104da5 <release>
}
801049ef:	c9                   	leave  
801049f0:	c3                   	ret    

801049f1 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801049f1:	55                   	push   %ebp
801049f2:	89 e5                	mov    %esp,%ebp
801049f4:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801049f7:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
801049fe:	e8 a2 03 00 00       	call   80104da5 <release>

  if (first) {
80104a03:	a1 20 b0 10 80       	mov    0x8010b020,%eax
80104a08:	85 c0                	test   %eax,%eax
80104a0a:	74 0f                	je     80104a1b <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104a0c:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
80104a13:	00 00 00 
    initlog();
80104a16:	e8 a7 e5 ff ff       	call   80102fc2 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104a1b:	c9                   	leave  
80104a1c:	c3                   	ret    

80104a1d <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104a1d:	55                   	push   %ebp
80104a1e:	89 e5                	mov    %esp,%ebp
80104a20:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104a23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a29:	85 c0                	test   %eax,%eax
80104a2b:	75 0c                	jne    80104a39 <sleep+0x1c>
    panic("sleep");
80104a2d:	c7 04 24 94 87 10 80 	movl   $0x80108794,(%esp)
80104a34:	e8 fd ba ff ff       	call   80100536 <panic>

  if(lk == 0)
80104a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a3d:	75 0c                	jne    80104a4b <sleep+0x2e>
    panic("sleep without lk");
80104a3f:	c7 04 24 9a 87 10 80 	movl   $0x8010879a,(%esp)
80104a46:	e8 eb ba ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104a4b:	81 7d 0c 40 ff 10 80 	cmpl   $0x8010ff40,0xc(%ebp)
80104a52:	74 17                	je     80104a6b <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104a54:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104a5b:	e8 e3 02 00 00       	call   80104d43 <acquire>
    release(lk);
80104a60:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a63:	89 04 24             	mov    %eax,(%esp)
80104a66:	e8 3a 03 00 00       	call   80104da5 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104a6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a71:	8b 55 08             	mov    0x8(%ebp),%edx
80104a74:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104a77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7d:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  // New -  when a proc goes to SLEEPING state, increase priority
  if(proc->priority > 0){ // New: Added in proyect 2
80104a84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8a:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104a90:	85 c0                	test   %eax,%eax
80104a92:	7e 13                	jle    80104aa7 <sleep+0x8a>
    proc->priority--;
80104a94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9a:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104aa0:	4a                   	dec    %edx
80104aa1:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
  sched();
80104aa7:	e8 34 fe ff ff       	call   801048e0 <sched>

  // Tidy up.
  proc->chan = 0;
80104aac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ab2:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104ab9:	81 7d 0c 40 ff 10 80 	cmpl   $0x8010ff40,0xc(%ebp)
80104ac0:	74 17                	je     80104ad9 <sleep+0xbc>
    release(&ptable.lock);
80104ac2:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ac9:	e8 d7 02 00 00       	call   80104da5 <release>
    acquire(lk);
80104ace:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ad1:	89 04 24             	mov    %eax,(%esp)
80104ad4:	e8 6a 02 00 00       	call   80104d43 <acquire>
  }
}
80104ad9:	c9                   	leave  
80104ada:	c3                   	ret    

80104adb <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104adb:	55                   	push   %ebp
80104adc:	89 e5                	mov    %esp,%ebp
80104ade:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ae1:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104ae8:	eb 30                	jmp    80104b1a <wakeup1+0x3f>
    // if(p->state == SLEEPING && p->chan == chan)
    //   p->state = RUNNABLE;
    if(p->state == SLEEPING && p->chan == chan){ // Added in project 2
80104aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aed:	8b 40 0c             	mov    0xc(%eax),%eax
80104af0:	83 f8 02             	cmp    $0x2,%eax
80104af3:	75 1e                	jne    80104b13 <wakeup1+0x38>
80104af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af8:	8b 40 20             	mov    0x20(%eax),%eax
80104afb:	3b 45 08             	cmp    0x8(%ebp),%eax
80104afe:	75 13                	jne    80104b13 <wakeup1+0x38>
      // New - enqueue proc
      makerunnable(p,-1);
80104b00:	c7 44 24 04 ff ff ff 	movl   $0xffffffff,0x4(%esp)
80104b07:	ff 
80104b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0b:	89 04 24             	mov    %eax,(%esp)
80104b0e:	e8 20 f6 ff ff       	call   80104133 <makerunnable>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b13:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104b1a:	81 7d f4 74 21 11 80 	cmpl   $0x80112174,-0xc(%ebp)
80104b21:	72 c7                	jb     80104aea <wakeup1+0xf>
    }
}
80104b23:	c9                   	leave  
80104b24:	c3                   	ret    

80104b25 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b25:	55                   	push   %ebp
80104b26:	89 e5                	mov    %esp,%ebp
80104b28:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104b2b:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b32:	e8 0c 02 00 00       	call   80104d43 <acquire>
  wakeup1(chan);
80104b37:	8b 45 08             	mov    0x8(%ebp),%eax
80104b3a:	89 04 24             	mov    %eax,(%esp)
80104b3d:	e8 99 ff ff ff       	call   80104adb <wakeup1>
  release(&ptable.lock);
80104b42:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b49:	e8 57 02 00 00       	call   80104da5 <release>
}
80104b4e:	c9                   	leave  
80104b4f:	c3                   	ret    

80104b50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104b56:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104b5d:	e8 e1 01 00 00       	call   80104d43 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b62:	c7 45 f4 74 ff 10 80 	movl   $0x8010ff74,-0xc(%ebp)
80104b69:	eb 4d                	jmp    80104bb8 <kill+0x68>
    if(p->pid == pid){
80104b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6e:	8b 40 10             	mov    0x10(%eax),%eax
80104b71:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b74:	75 3b                	jne    80104bb1 <kill+0x61>
      p->killed = 1;
80104b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b79:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      // if(p->state == SLEEPING)
      //   p->state = RUNNABLE;
      if(p->state == SLEEPING){ // Added in proyect 2
80104b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b83:	8b 40 0c             	mov    0xc(%eax),%eax
80104b86:	83 f8 02             	cmp    $0x2,%eax
80104b89:	75 13                	jne    80104b9e <kill+0x4e>
        // New - enqueue proc
        makerunnable(p,0);
80104b8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104b92:	00 
80104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b96:	89 04 24             	mov    %eax,(%esp)
80104b99:	e8 95 f5 ff ff       	call   80104133 <makerunnable>
      }
      release(&ptable.lock);
80104b9e:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104ba5:	e8 fb 01 00 00       	call   80104da5 <release>
      return 0;
80104baa:	b8 00 00 00 00       	mov    $0x0,%eax
80104baf:	eb 21                	jmp    80104bd2 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb1:	81 45 f4 88 00 00 00 	addl   $0x88,-0xc(%ebp)
80104bb8:	81 7d f4 74 21 11 80 	cmpl   $0x80112174,-0xc(%ebp)
80104bbf:	72 aa                	jb     80104b6b <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104bc1:	c7 04 24 40 ff 10 80 	movl   $0x8010ff40,(%esp)
80104bc8:	e8 d8 01 00 00       	call   80104da5 <release>
  return -1;
80104bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bd2:	c9                   	leave  
80104bd3:	c3                   	ret    

80104bd4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	83 ec 68             	sub    $0x68,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bda:	c7 45 f0 74 ff 10 80 	movl   $0x8010ff74,-0x10(%ebp)
80104be1:	e9 e7 00 00 00       	jmp    80104ccd <procdump+0xf9>
    if(p->state == UNUSED)
80104be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104be9:	8b 40 0c             	mov    0xc(%eax),%eax
80104bec:	85 c0                	test   %eax,%eax
80104bee:	0f 84 d1 00 00 00    	je     80104cc5 <procdump+0xf1>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf7:	8b 40 0c             	mov    0xc(%eax),%eax
80104bfa:	83 f8 05             	cmp    $0x5,%eax
80104bfd:	77 23                	ja     80104c22 <procdump+0x4e>
80104bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c02:	8b 40 0c             	mov    0xc(%eax),%eax
80104c05:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	74 12                	je     80104c22 <procdump+0x4e>
      state = states[p->state];
80104c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c13:	8b 40 0c             	mov    0xc(%eax),%eax
80104c16:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104c1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c20:	eb 07                	jmp    80104c29 <procdump+0x55>
    else
      state = "???";
80104c22:	c7 45 ec ab 87 10 80 	movl   $0x801087ab,-0x14(%ebp)
    // cprintf("%d %s %s", p->pid, state, p->name);
    cprintf("%d %s %s %d", p->pid, state, p->name, p->priority);
80104c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2c:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c35:	8d 48 6c             	lea    0x6c(%eax),%ecx
80104c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c3b:	8b 40 10             	mov    0x10(%eax),%eax
80104c3e:	89 54 24 10          	mov    %edx,0x10(%esp)
80104c42:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80104c46:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104c49:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c51:	c7 04 24 af 87 10 80 	movl   $0x801087af,(%esp)
80104c58:	e8 44 b7 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104c5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c60:	8b 40 0c             	mov    0xc(%eax),%eax
80104c63:	83 f8 02             	cmp    $0x2,%eax
80104c66:	75 4f                	jne    80104cb7 <procdump+0xe3>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c6b:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c6e:	8b 40 0c             	mov    0xc(%eax),%eax
80104c71:	83 c0 08             	add    $0x8,%eax
80104c74:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104c77:	89 54 24 04          	mov    %edx,0x4(%esp)
80104c7b:	89 04 24             	mov    %eax,(%esp)
80104c7e:	e8 71 01 00 00       	call   80104df4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104c8a:	eb 1a                	jmp    80104ca6 <procdump+0xd2>
        cprintf(" %p", pc[i]);
80104c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8f:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104c93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c97:	c7 04 24 bb 87 10 80 	movl   $0x801087bb,(%esp)
80104c9e:	e8 fe b6 ff ff       	call   801003a1 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ca3:	ff 45 f4             	incl   -0xc(%ebp)
80104ca6:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104caa:	7f 0b                	jg     80104cb7 <procdump+0xe3>
80104cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104caf:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104cb3:	85 c0                	test   %eax,%eax
80104cb5:	75 d5                	jne    80104c8c <procdump+0xb8>
    }
    cprintf("\n");
80104cb7:	c7 04 24 bf 87 10 80 	movl   $0x801087bf,(%esp)
80104cbe:	e8 de b6 ff ff       	call   801003a1 <cprintf>
80104cc3:	eb 01                	jmp    80104cc6 <procdump+0xf2>
      continue;
80104cc5:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cc6:	81 45 f0 88 00 00 00 	addl   $0x88,-0x10(%ebp)
80104ccd:	81 7d f0 74 21 11 80 	cmpl   $0x80112174,-0x10(%ebp)
80104cd4:	0f 82 0c ff ff ff    	jb     80104be6 <procdump+0x12>
  }
}
80104cda:	c9                   	leave  
80104cdb:	c3                   	ret    

80104cdc <readeflags>:
{
80104cdc:	55                   	push   %ebp
80104cdd:	89 e5                	mov    %esp,%ebp
80104cdf:	53                   	push   %ebx
80104ce0:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ce3:	9c                   	pushf  
80104ce4:	5b                   	pop    %ebx
80104ce5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104ce8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104ceb:	83 c4 10             	add    $0x10,%esp
80104cee:	5b                   	pop    %ebx
80104cef:	5d                   	pop    %ebp
80104cf0:	c3                   	ret    

80104cf1 <cli>:
{
80104cf1:	55                   	push   %ebp
80104cf2:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104cf4:	fa                   	cli    
}
80104cf5:	5d                   	pop    %ebp
80104cf6:	c3                   	ret    

80104cf7 <sti>:
{
80104cf7:	55                   	push   %ebp
80104cf8:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104cfa:	fb                   	sti    
}
80104cfb:	5d                   	pop    %ebp
80104cfc:	c3                   	ret    

80104cfd <xchg>:
{
80104cfd:	55                   	push   %ebp
80104cfe:	89 e5                	mov    %esp,%ebp
80104d00:	53                   	push   %ebx
80104d01:	83 ec 10             	sub    $0x10,%esp
               "+m" (*addr), "=a" (result) :
80104d04:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80104d07:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
80104d0d:	89 c3                	mov    %eax,%ebx
80104d0f:	89 d8                	mov    %ebx,%eax
80104d11:	f0 87 02             	lock xchg %eax,(%edx)
80104d14:	89 c3                	mov    %eax,%ebx
80104d16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return result;
80104d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104d1c:	83 c4 10             	add    $0x10,%esp
80104d1f:	5b                   	pop    %ebx
80104d20:	5d                   	pop    %ebp
80104d21:	c3                   	ret    

80104d22 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d22:	55                   	push   %ebp
80104d23:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104d25:	8b 45 08             	mov    0x8(%ebp),%eax
80104d28:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d2b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d31:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104d37:	8b 45 08             	mov    0x8(%ebp),%eax
80104d3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    

80104d43 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104d43:	55                   	push   %ebp
80104d44:	89 e5                	mov    %esp,%ebp
80104d46:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d49:	e8 47 01 00 00       	call   80104e95 <pushcli>
  if(holding(lk))
80104d4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d51:	89 04 24             	mov    %eax,(%esp)
80104d54:	e8 12 01 00 00       	call   80104e6b <holding>
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	74 0c                	je     80104d69 <acquire+0x26>
    panic("acquire");
80104d5d:	c7 04 24 eb 87 10 80 	movl   $0x801087eb,(%esp)
80104d64:	e8 cd b7 ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104d69:	90                   	nop
80104d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104d74:	00 
80104d75:	89 04 24             	mov    %eax,(%esp)
80104d78:	e8 80 ff ff ff       	call   80104cfd <xchg>
80104d7d:	85 c0                	test   %eax,%eax
80104d7f:	75 e9                	jne    80104d6a <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104d81:	8b 45 08             	mov    0x8(%ebp),%eax
80104d84:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104d8b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104d8e:	8b 45 08             	mov    0x8(%ebp),%eax
80104d91:	83 c0 0c             	add    $0xc,%eax
80104d94:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d98:	8d 45 08             	lea    0x8(%ebp),%eax
80104d9b:	89 04 24             	mov    %eax,(%esp)
80104d9e:	e8 51 00 00 00       	call   80104df4 <getcallerpcs>
}
80104da3:	c9                   	leave  
80104da4:	c3                   	ret    

80104da5 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104da5:	55                   	push   %ebp
80104da6:	89 e5                	mov    %esp,%ebp
80104da8:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104dab:	8b 45 08             	mov    0x8(%ebp),%eax
80104dae:	89 04 24             	mov    %eax,(%esp)
80104db1:	e8 b5 00 00 00       	call   80104e6b <holding>
80104db6:	85 c0                	test   %eax,%eax
80104db8:	75 0c                	jne    80104dc6 <release+0x21>
    panic("release");
80104dba:	c7 04 24 f3 87 10 80 	movl   $0x801087f3,(%esp)
80104dc1:	e8 70 b7 ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
80104dc6:	8b 45 08             	mov    0x8(%ebp),%eax
80104dc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104dd0:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104dda:	8b 45 08             	mov    0x8(%ebp),%eax
80104ddd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104de4:	00 
80104de5:	89 04 24             	mov    %eax,(%esp)
80104de8:	e8 10 ff ff ff       	call   80104cfd <xchg>

  popcli();
80104ded:	e8 e9 00 00 00       	call   80104edb <popcli>
}
80104df2:	c9                   	leave  
80104df3:	c3                   	ret    

80104df4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104dfa:	8b 45 08             	mov    0x8(%ebp),%eax
80104dfd:	83 e8 08             	sub    $0x8,%eax
80104e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104e03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104e0a:	eb 37                	jmp    80104e43 <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104e0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104e10:	74 51                	je     80104e63 <getcallerpcs+0x6f>
80104e12:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104e19:	76 48                	jbe    80104e63 <getcallerpcs+0x6f>
80104e1b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104e1f:	74 42                	je     80104e63 <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104e21:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e2e:	01 c2                	add    %eax,%edx
80104e30:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e33:	8b 40 04             	mov    0x4(%eax),%eax
80104e36:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104e38:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e3b:	8b 00                	mov    (%eax),%eax
80104e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104e40:	ff 45 f8             	incl   -0x8(%ebp)
80104e43:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104e47:	7e c3                	jle    80104e0c <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104e49:	eb 18                	jmp    80104e63 <getcallerpcs+0x6f>
    pcs[i] = 0;
80104e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104e55:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e58:	01 d0                	add    %edx,%eax
80104e5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e60:	ff 45 f8             	incl   -0x8(%ebp)
80104e63:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104e67:	7e e2                	jle    80104e4b <getcallerpcs+0x57>
}
80104e69:	c9                   	leave  
80104e6a:	c3                   	ret    

80104e6b <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104e6b:	55                   	push   %ebp
80104e6c:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104e6e:	8b 45 08             	mov    0x8(%ebp),%eax
80104e71:	8b 00                	mov    (%eax),%eax
80104e73:	85 c0                	test   %eax,%eax
80104e75:	74 17                	je     80104e8e <holding+0x23>
80104e77:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7a:	8b 50 08             	mov    0x8(%eax),%edx
80104e7d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e83:	39 c2                	cmp    %eax,%edx
80104e85:	75 07                	jne    80104e8e <holding+0x23>
80104e87:	b8 01 00 00 00       	mov    $0x1,%eax
80104e8c:	eb 05                	jmp    80104e93 <holding+0x28>
80104e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e93:	5d                   	pop    %ebp
80104e94:	c3                   	ret    

80104e95 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104e95:	55                   	push   %ebp
80104e96:	89 e5                	mov    %esp,%ebp
80104e98:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104e9b:	e8 3c fe ff ff       	call   80104cdc <readeflags>
80104ea0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104ea3:	e8 49 fe ff ff       	call   80104cf1 <cli>
  if(cpu->ncli++ == 0)
80104ea8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104eae:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104eb4:	85 d2                	test   %edx,%edx
80104eb6:	0f 94 c1             	sete   %cl
80104eb9:	42                   	inc    %edx
80104eba:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104ec0:	84 c9                	test   %cl,%cl
80104ec2:	74 15                	je     80104ed9 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80104ec4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104eca:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104ecd:	81 e2 00 02 00 00    	and    $0x200,%edx
80104ed3:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104ed9:	c9                   	leave  
80104eda:	c3                   	ret    

80104edb <popcli>:

void
popcli(void)
{
80104edb:	55                   	push   %ebp
80104edc:	89 e5                	mov    %esp,%ebp
80104ede:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104ee1:	e8 f6 fd ff ff       	call   80104cdc <readeflags>
80104ee6:	25 00 02 00 00       	and    $0x200,%eax
80104eeb:	85 c0                	test   %eax,%eax
80104eed:	74 0c                	je     80104efb <popcli+0x20>
    panic("popcli - interruptible");
80104eef:	c7 04 24 fb 87 10 80 	movl   $0x801087fb,(%esp)
80104ef6:	e8 3b b6 ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80104efb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f01:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104f07:	4a                   	dec    %edx
80104f08:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104f0e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f14:	85 c0                	test   %eax,%eax
80104f16:	79 0c                	jns    80104f24 <popcli+0x49>
    panic("popcli");
80104f18:	c7 04 24 12 88 10 80 	movl   $0x80108812,(%esp)
80104f1f:	e8 12 b6 ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104f24:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f2a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104f30:	85 c0                	test   %eax,%eax
80104f32:	75 15                	jne    80104f49 <popcli+0x6e>
80104f34:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104f3a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104f40:	85 c0                	test   %eax,%eax
80104f42:	74 05                	je     80104f49 <popcli+0x6e>
    sti();
80104f44:	e8 ae fd ff ff       	call   80104cf7 <sti>
}
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    

80104f4b <stosb>:
{
80104f4b:	55                   	push   %ebp
80104f4c:	89 e5                	mov    %esp,%ebp
80104f4e:	57                   	push   %edi
80104f4f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104f50:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f53:	8b 55 10             	mov    0x10(%ebp),%edx
80104f56:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f59:	89 cb                	mov    %ecx,%ebx
80104f5b:	89 df                	mov    %ebx,%edi
80104f5d:	89 d1                	mov    %edx,%ecx
80104f5f:	fc                   	cld    
80104f60:	f3 aa                	rep stos %al,%es:(%edi)
80104f62:	89 ca                	mov    %ecx,%edx
80104f64:	89 fb                	mov    %edi,%ebx
80104f66:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104f69:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104f6c:	5b                   	pop    %ebx
80104f6d:	5f                   	pop    %edi
80104f6e:	5d                   	pop    %ebp
80104f6f:	c3                   	ret    

80104f70 <stosl>:
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	57                   	push   %edi
80104f74:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104f75:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f78:	8b 55 10             	mov    0x10(%ebp),%edx
80104f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f7e:	89 cb                	mov    %ecx,%ebx
80104f80:	89 df                	mov    %ebx,%edi
80104f82:	89 d1                	mov    %edx,%ecx
80104f84:	fc                   	cld    
80104f85:	f3 ab                	rep stos %eax,%es:(%edi)
80104f87:	89 ca                	mov    %ecx,%edx
80104f89:	89 fb                	mov    %edi,%ebx
80104f8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104f8e:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104f91:	5b                   	pop    %ebx
80104f92:	5f                   	pop    %edi
80104f93:	5d                   	pop    %ebp
80104f94:	c3                   	ret    

80104f95 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f95:	55                   	push   %ebp
80104f96:	89 e5                	mov    %esp,%ebp
80104f98:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f9e:	83 e0 03             	and    $0x3,%eax
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	75 49                	jne    80104fee <memset+0x59>
80104fa5:	8b 45 10             	mov    0x10(%ebp),%eax
80104fa8:	83 e0 03             	and    $0x3,%eax
80104fab:	85 c0                	test   %eax,%eax
80104fad:	75 3f                	jne    80104fee <memset+0x59>
    c &= 0xFF;
80104faf:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fb6:	8b 45 10             	mov    0x10(%ebp),%eax
80104fb9:	c1 e8 02             	shr    $0x2,%eax
80104fbc:	89 c2                	mov    %eax,%edx
80104fbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fc1:	89 c1                	mov    %eax,%ecx
80104fc3:	c1 e1 18             	shl    $0x18,%ecx
80104fc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fc9:	c1 e0 10             	shl    $0x10,%eax
80104fcc:	09 c1                	or     %eax,%ecx
80104fce:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fd1:	c1 e0 08             	shl    $0x8,%eax
80104fd4:	09 c8                	or     %ecx,%eax
80104fd6:	0b 45 0c             	or     0xc(%ebp),%eax
80104fd9:	89 54 24 08          	mov    %edx,0x8(%esp)
80104fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fe1:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe4:	89 04 24             	mov    %eax,(%esp)
80104fe7:	e8 84 ff ff ff       	call   80104f70 <stosl>
80104fec:	eb 19                	jmp    80105007 <memset+0x72>
  } else
    stosb(dst, c, n);
80104fee:	8b 45 10             	mov    0x10(%ebp),%eax
80104ff1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ff5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ff8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80104fff:	89 04 24             	mov    %eax,(%esp)
80105002:	e8 44 ff ff ff       	call   80104f4b <stosb>
  return dst;
80105007:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010500a:	c9                   	leave  
8010500b:	c3                   	ret    

8010500c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010500c:	55                   	push   %ebp
8010500d:	89 e5                	mov    %esp,%ebp
8010500f:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105012:	8b 45 08             	mov    0x8(%ebp),%eax
80105015:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105018:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010501e:	eb 2c                	jmp    8010504c <memcmp+0x40>
    if(*s1 != *s2)
80105020:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105023:	8a 10                	mov    (%eax),%dl
80105025:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105028:	8a 00                	mov    (%eax),%al
8010502a:	38 c2                	cmp    %al,%dl
8010502c:	74 18                	je     80105046 <memcmp+0x3a>
      return *s1 - *s2;
8010502e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105031:	8a 00                	mov    (%eax),%al
80105033:	0f b6 d0             	movzbl %al,%edx
80105036:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105039:	8a 00                	mov    (%eax),%al
8010503b:	0f b6 c0             	movzbl %al,%eax
8010503e:	89 d1                	mov    %edx,%ecx
80105040:	29 c1                	sub    %eax,%ecx
80105042:	89 c8                	mov    %ecx,%eax
80105044:	eb 19                	jmp    8010505f <memcmp+0x53>
    s1++, s2++;
80105046:	ff 45 fc             	incl   -0x4(%ebp)
80105049:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0){
8010504c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105050:	0f 95 c0             	setne  %al
80105053:	ff 4d 10             	decl   0x10(%ebp)
80105056:	84 c0                	test   %al,%al
80105058:	75 c6                	jne    80105020 <memcmp+0x14>
  }

  return 0;
8010505a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010505f:	c9                   	leave  
80105060:	c3                   	ret    

80105061 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105061:	55                   	push   %ebp
80105062:	89 e5                	mov    %esp,%ebp
80105064:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105067:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010506d:	8b 45 08             	mov    0x8(%ebp),%eax
80105070:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105073:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105076:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105079:	73 4d                	jae    801050c8 <memmove+0x67>
8010507b:	8b 45 10             	mov    0x10(%ebp),%eax
8010507e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105081:	01 d0                	add    %edx,%eax
80105083:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105086:	76 40                	jbe    801050c8 <memmove+0x67>
    s += n;
80105088:	8b 45 10             	mov    0x10(%ebp),%eax
8010508b:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010508e:	8b 45 10             	mov    0x10(%ebp),%eax
80105091:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105094:	eb 10                	jmp    801050a6 <memmove+0x45>
      *--d = *--s;
80105096:	ff 4d f8             	decl   -0x8(%ebp)
80105099:	ff 4d fc             	decl   -0x4(%ebp)
8010509c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010509f:	8a 10                	mov    (%eax),%dl
801050a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050a4:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801050a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050aa:	0f 95 c0             	setne  %al
801050ad:	ff 4d 10             	decl   0x10(%ebp)
801050b0:	84 c0                	test   %al,%al
801050b2:	75 e2                	jne    80105096 <memmove+0x35>
  if(s < d && s + n > d){
801050b4:	eb 21                	jmp    801050d7 <memmove+0x76>
  } else
    while(n-- > 0)
      *d++ = *s++;
801050b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b9:	8a 10                	mov    (%eax),%dl
801050bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801050be:	88 10                	mov    %dl,(%eax)
801050c0:	ff 45 f8             	incl   -0x8(%ebp)
801050c3:	ff 45 fc             	incl   -0x4(%ebp)
801050c6:	eb 01                	jmp    801050c9 <memmove+0x68>
    while(n-- > 0)
801050c8:	90                   	nop
801050c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801050cd:	0f 95 c0             	setne  %al
801050d0:	ff 4d 10             	decl   0x10(%ebp)
801050d3:	84 c0                	test   %al,%al
801050d5:	75 df                	jne    801050b6 <memmove+0x55>

  return dst;
801050d7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    

801050dc <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801050dc:	55                   	push   %ebp
801050dd:	89 e5                	mov    %esp,%ebp
801050df:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
801050e2:	8b 45 10             	mov    0x10(%ebp),%eax
801050e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801050e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801050ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f0:	8b 45 08             	mov    0x8(%ebp),%eax
801050f3:	89 04 24             	mov    %eax,(%esp)
801050f6:	e8 66 ff ff ff       	call   80105061 <memmove>
}
801050fb:	c9                   	leave  
801050fc:	c3                   	ret    

801050fd <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801050fd:	55                   	push   %ebp
801050fe:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105100:	eb 09                	jmp    8010510b <strncmp+0xe>
    n--, p++, q++;
80105102:	ff 4d 10             	decl   0x10(%ebp)
80105105:	ff 45 08             	incl   0x8(%ebp)
80105108:	ff 45 0c             	incl   0xc(%ebp)
  while(n > 0 && *p && *p == *q)
8010510b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010510f:	74 17                	je     80105128 <strncmp+0x2b>
80105111:	8b 45 08             	mov    0x8(%ebp),%eax
80105114:	8a 00                	mov    (%eax),%al
80105116:	84 c0                	test   %al,%al
80105118:	74 0e                	je     80105128 <strncmp+0x2b>
8010511a:	8b 45 08             	mov    0x8(%ebp),%eax
8010511d:	8a 10                	mov    (%eax),%dl
8010511f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105122:	8a 00                	mov    (%eax),%al
80105124:	38 c2                	cmp    %al,%dl
80105126:	74 da                	je     80105102 <strncmp+0x5>
  if(n == 0)
80105128:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010512c:	75 07                	jne    80105135 <strncmp+0x38>
    return 0;
8010512e:	b8 00 00 00 00       	mov    $0x0,%eax
80105133:	eb 16                	jmp    8010514b <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80105135:	8b 45 08             	mov    0x8(%ebp),%eax
80105138:	8a 00                	mov    (%eax),%al
8010513a:	0f b6 d0             	movzbl %al,%edx
8010513d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105140:	8a 00                	mov    (%eax),%al
80105142:	0f b6 c0             	movzbl %al,%eax
80105145:	89 d1                	mov    %edx,%ecx
80105147:	29 c1                	sub    %eax,%ecx
80105149:	89 c8                	mov    %ecx,%eax
}
8010514b:	5d                   	pop    %ebp
8010514c:	c3                   	ret    

8010514d <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010514d:	55                   	push   %ebp
8010514e:	89 e5                	mov    %esp,%ebp
80105150:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105153:	8b 45 08             	mov    0x8(%ebp),%eax
80105156:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105159:	90                   	nop
8010515a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010515e:	0f 9f c0             	setg   %al
80105161:	ff 4d 10             	decl   0x10(%ebp)
80105164:	84 c0                	test   %al,%al
80105166:	74 2b                	je     80105193 <strncpy+0x46>
80105168:	8b 45 0c             	mov    0xc(%ebp),%eax
8010516b:	8a 10                	mov    (%eax),%dl
8010516d:	8b 45 08             	mov    0x8(%ebp),%eax
80105170:	88 10                	mov    %dl,(%eax)
80105172:	8b 45 08             	mov    0x8(%ebp),%eax
80105175:	8a 00                	mov    (%eax),%al
80105177:	84 c0                	test   %al,%al
80105179:	0f 95 c0             	setne  %al
8010517c:	ff 45 08             	incl   0x8(%ebp)
8010517f:	ff 45 0c             	incl   0xc(%ebp)
80105182:	84 c0                	test   %al,%al
80105184:	75 d4                	jne    8010515a <strncpy+0xd>
    ;
  while(n-- > 0)
80105186:	eb 0b                	jmp    80105193 <strncpy+0x46>
    *s++ = 0;
80105188:	8b 45 08             	mov    0x8(%ebp),%eax
8010518b:	c6 00 00             	movb   $0x0,(%eax)
8010518e:	ff 45 08             	incl   0x8(%ebp)
80105191:	eb 01                	jmp    80105194 <strncpy+0x47>
  while(n-- > 0)
80105193:	90                   	nop
80105194:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105198:	0f 9f c0             	setg   %al
8010519b:	ff 4d 10             	decl   0x10(%ebp)
8010519e:	84 c0                	test   %al,%al
801051a0:	75 e6                	jne    80105188 <strncpy+0x3b>
  return os;
801051a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    

801051a7 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801051a7:	55                   	push   %ebp
801051a8:	89 e5                	mov    %esp,%ebp
801051aa:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801051ad:	8b 45 08             	mov    0x8(%ebp),%eax
801051b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801051b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051b7:	7f 05                	jg     801051be <safestrcpy+0x17>
    return os;
801051b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051bc:	eb 30                	jmp    801051ee <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
801051be:	ff 4d 10             	decl   0x10(%ebp)
801051c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801051c5:	7e 1e                	jle    801051e5 <safestrcpy+0x3e>
801051c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ca:	8a 10                	mov    (%eax),%dl
801051cc:	8b 45 08             	mov    0x8(%ebp),%eax
801051cf:	88 10                	mov    %dl,(%eax)
801051d1:	8b 45 08             	mov    0x8(%ebp),%eax
801051d4:	8a 00                	mov    (%eax),%al
801051d6:	84 c0                	test   %al,%al
801051d8:	0f 95 c0             	setne  %al
801051db:	ff 45 08             	incl   0x8(%ebp)
801051de:	ff 45 0c             	incl   0xc(%ebp)
801051e1:	84 c0                	test   %al,%al
801051e3:	75 d9                	jne    801051be <safestrcpy+0x17>
    ;
  *s = 0;
801051e5:	8b 45 08             	mov    0x8(%ebp),%eax
801051e8:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801051eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801051ee:	c9                   	leave  
801051ef:	c3                   	ret    

801051f0 <strlen>:

int
strlen(const char *s)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801051f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801051fd:	eb 03                	jmp    80105202 <strlen+0x12>
801051ff:	ff 45 fc             	incl   -0x4(%ebp)
80105202:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105205:	8b 45 08             	mov    0x8(%ebp),%eax
80105208:	01 d0                	add    %edx,%eax
8010520a:	8a 00                	mov    (%eax),%al
8010520c:	84 c0                	test   %al,%al
8010520e:	75 ef                	jne    801051ff <strlen+0xf>
    ;
  return n;
80105210:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105213:	c9                   	leave  
80105214:	c3                   	ret    

80105215 <swtch>:
80105215:	8b 44 24 04          	mov    0x4(%esp),%eax
80105219:	8b 54 24 08          	mov    0x8(%esp),%edx
8010521d:	55                   	push   %ebp
8010521e:	53                   	push   %ebx
8010521f:	56                   	push   %esi
80105220:	57                   	push   %edi
80105221:	89 20                	mov    %esp,(%eax)
80105223:	89 d4                	mov    %edx,%esp
80105225:	5f                   	pop    %edi
80105226:	5e                   	pop    %esi
80105227:	5b                   	pop    %ebx
80105228:	5d                   	pop    %ebp
80105229:	c3                   	ret    

8010522a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010522a:	55                   	push   %ebp
8010522b:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
8010522d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105233:	8b 00                	mov    (%eax),%eax
80105235:	3b 45 08             	cmp    0x8(%ebp),%eax
80105238:	76 12                	jbe    8010524c <fetchint+0x22>
8010523a:	8b 45 08             	mov    0x8(%ebp),%eax
8010523d:	8d 50 04             	lea    0x4(%eax),%edx
80105240:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105246:	8b 00                	mov    (%eax),%eax
80105248:	39 c2                	cmp    %eax,%edx
8010524a:	76 07                	jbe    80105253 <fetchint+0x29>
    return -1;
8010524c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105251:	eb 0f                	jmp    80105262 <fetchint+0x38>
  *ip = *(int*)(addr);
80105253:	8b 45 08             	mov    0x8(%ebp),%eax
80105256:	8b 10                	mov    (%eax),%edx
80105258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525b:	89 10                	mov    %edx,(%eax)
  return 0;
8010525d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105262:	5d                   	pop    %ebp
80105263:	c3                   	ret    

80105264 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
8010526a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105270:	8b 00                	mov    (%eax),%eax
80105272:	3b 45 08             	cmp    0x8(%ebp),%eax
80105275:	77 07                	ja     8010527e <fetchstr+0x1a>
    return -1;
80105277:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010527c:	eb 46                	jmp    801052c4 <fetchstr+0x60>
  *pp = (char*)addr;
8010527e:	8b 55 08             	mov    0x8(%ebp),%edx
80105281:	8b 45 0c             	mov    0xc(%ebp),%eax
80105284:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105286:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528c:	8b 00                	mov    (%eax),%eax
8010528e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105291:	8b 45 0c             	mov    0xc(%ebp),%eax
80105294:	8b 00                	mov    (%eax),%eax
80105296:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105299:	eb 1c                	jmp    801052b7 <fetchstr+0x53>
    if(*s == 0)
8010529b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010529e:	8a 00                	mov    (%eax),%al
801052a0:	84 c0                	test   %al,%al
801052a2:	75 10                	jne    801052b4 <fetchstr+0x50>
      return s - *pp;
801052a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052aa:	8b 00                	mov    (%eax),%eax
801052ac:	89 d1                	mov    %edx,%ecx
801052ae:	29 c1                	sub    %eax,%ecx
801052b0:	89 c8                	mov    %ecx,%eax
801052b2:	eb 10                	jmp    801052c4 <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
801052b4:	ff 45 fc             	incl   -0x4(%ebp)
801052b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052bd:	72 dc                	jb     8010529b <fetchstr+0x37>
  return -1;
801052bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052c4:	c9                   	leave  
801052c5:	c3                   	ret    

801052c6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801052c6:	55                   	push   %ebp
801052c7:	89 e5                	mov    %esp,%ebp
801052c9:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801052cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d2:	8b 40 18             	mov    0x18(%eax),%eax
801052d5:	8b 50 44             	mov    0x44(%eax),%edx
801052d8:	8b 45 08             	mov    0x8(%ebp),%eax
801052db:	c1 e0 02             	shl    $0x2,%eax
801052de:	01 d0                	add    %edx,%eax
801052e0:	8d 50 04             	lea    0x4(%eax),%edx
801052e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ea:	89 14 24             	mov    %edx,(%esp)
801052ed:	e8 38 ff ff ff       	call   8010522a <fetchint>
}
801052f2:	c9                   	leave  
801052f3:	c3                   	ret    

801052f4 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
801052fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
801052fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105301:	8b 45 08             	mov    0x8(%ebp),%eax
80105304:	89 04 24             	mov    %eax,(%esp)
80105307:	e8 ba ff ff ff       	call   801052c6 <argint>
8010530c:	85 c0                	test   %eax,%eax
8010530e:	79 07                	jns    80105317 <argptr+0x23>
    return -1;
80105310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105315:	eb 3d                	jmp    80105354 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105317:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010531a:	89 c2                	mov    %eax,%edx
8010531c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105322:	8b 00                	mov    (%eax),%eax
80105324:	39 c2                	cmp    %eax,%edx
80105326:	73 16                	jae    8010533e <argptr+0x4a>
80105328:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010532b:	89 c2                	mov    %eax,%edx
8010532d:	8b 45 10             	mov    0x10(%ebp),%eax
80105330:	01 c2                	add    %eax,%edx
80105332:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105338:	8b 00                	mov    (%eax),%eax
8010533a:	39 c2                	cmp    %eax,%edx
8010533c:	76 07                	jbe    80105345 <argptr+0x51>
    return -1;
8010533e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105343:	eb 0f                	jmp    80105354 <argptr+0x60>
  *pp = (char*)i;
80105345:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105348:	89 c2                	mov    %eax,%edx
8010534a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010534d:	89 10                	mov    %edx,(%eax)
  return 0;
8010534f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105354:	c9                   	leave  
80105355:	c3                   	ret    

80105356 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105356:	55                   	push   %ebp
80105357:	89 e5                	mov    %esp,%ebp
80105359:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010535c:	8d 45 fc             	lea    -0x4(%ebp),%eax
8010535f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105363:	8b 45 08             	mov    0x8(%ebp),%eax
80105366:	89 04 24             	mov    %eax,(%esp)
80105369:	e8 58 ff ff ff       	call   801052c6 <argint>
8010536e:	85 c0                	test   %eax,%eax
80105370:	79 07                	jns    80105379 <argstr+0x23>
    return -1;
80105372:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105377:	eb 12                	jmp    8010538b <argstr+0x35>
  return fetchstr(addr, pp);
80105379:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010537c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010537f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105383:	89 04 24             	mov    %eax,(%esp)
80105386:	e8 d9 fe ff ff       	call   80105264 <fetchstr>
}
8010538b:	c9                   	leave  
8010538c:	c3                   	ret    

8010538d <syscall>:
[SYS_set_priority] sys_set_priority, // New
};

void
syscall(void)
{
8010538d:	55                   	push   %ebp
8010538e:	89 e5                	mov    %esp,%ebp
80105390:	53                   	push   %ebx
80105391:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105394:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010539a:	8b 40 18             	mov    0x18(%eax),%eax
8010539d:	8b 40 1c             	mov    0x1c(%eax),%eax
801053a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801053a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053a7:	7e 30                	jle    801053d9 <syscall+0x4c>
801053a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053ac:	83 f8 19             	cmp    $0x19,%eax
801053af:	77 28                	ja     801053d9 <syscall+0x4c>
801053b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b4:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801053bb:	85 c0                	test   %eax,%eax
801053bd:	74 1a                	je     801053d9 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
801053bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053c5:	8b 58 18             	mov    0x18(%eax),%ebx
801053c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cb:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
801053d2:	ff d0                	call   *%eax
801053d4:	89 43 1c             	mov    %eax,0x1c(%ebx)
801053d7:	eb 3d                	jmp    80105416 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
801053d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053df:	8d 48 6c             	lea    0x6c(%eax),%ecx
801053e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
801053e8:	8b 40 10             	mov    0x10(%eax),%eax
801053eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
801053f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801053fa:	c7 04 24 19 88 10 80 	movl   $0x80108819,(%esp)
80105401:	e8 9b af ff ff       	call   801003a1 <cprintf>
    proc->tf->eax = -1;
80105406:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010540c:	8b 40 18             	mov    0x18(%eax),%eax
8010540f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105416:	83 c4 24             	add    $0x24,%esp
80105419:	5b                   	pop    %ebx
8010541a:	5d                   	pop    %ebp
8010541b:	c3                   	ret    

8010541c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010541c:	55                   	push   %ebp
8010541d:	89 e5                	mov    %esp,%ebp
8010541f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105422:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105425:	89 44 24 04          	mov    %eax,0x4(%esp)
80105429:	8b 45 08             	mov    0x8(%ebp),%eax
8010542c:	89 04 24             	mov    %eax,(%esp)
8010542f:	e8 92 fe ff ff       	call   801052c6 <argint>
80105434:	85 c0                	test   %eax,%eax
80105436:	79 07                	jns    8010543f <argfd+0x23>
    return -1;
80105438:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543d:	eb 50                	jmp    8010548f <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
8010543f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105442:	85 c0                	test   %eax,%eax
80105444:	78 21                	js     80105467 <argfd+0x4b>
80105446:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105449:	83 f8 0f             	cmp    $0xf,%eax
8010544c:	7f 19                	jg     80105467 <argfd+0x4b>
8010544e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105454:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105457:	83 c2 08             	add    $0x8,%edx
8010545a:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010545e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105461:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105465:	75 07                	jne    8010546e <argfd+0x52>
    return -1;
80105467:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546c:	eb 21                	jmp    8010548f <argfd+0x73>
  if(pfd)
8010546e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105472:	74 08                	je     8010547c <argfd+0x60>
    *pfd = fd;
80105474:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105477:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547a:	89 10                	mov    %edx,(%eax)
  if(pf)
8010547c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105480:	74 08                	je     8010548a <argfd+0x6e>
    *pf = f;
80105482:	8b 45 10             	mov    0x10(%ebp),%eax
80105485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105488:	89 10                	mov    %edx,(%eax)
  return 0;
8010548a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010548f:	c9                   	leave  
80105490:	c3                   	ret    

80105491 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105491:	55                   	push   %ebp
80105492:	89 e5                	mov    %esp,%ebp
80105494:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105497:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010549e:	eb 2f                	jmp    801054cf <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
801054a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054a9:	83 c2 08             	add    $0x8,%edx
801054ac:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801054b0:	85 c0                	test   %eax,%eax
801054b2:	75 18                	jne    801054cc <fdalloc+0x3b>
      proc->ofile[fd] = f;
801054b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
801054bd:	8d 4a 08             	lea    0x8(%edx),%ecx
801054c0:	8b 55 08             	mov    0x8(%ebp),%edx
801054c3:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801054c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054ca:	eb 0e                	jmp    801054da <fdalloc+0x49>
  for(fd = 0; fd < NOFILE; fd++){
801054cc:	ff 45 fc             	incl   -0x4(%ebp)
801054cf:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801054d3:	7e cb                	jle    801054a0 <fdalloc+0xf>
    }
  }
  return -1;
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054da:	c9                   	leave  
801054db:	c3                   	ret    

801054dc <sys_dup>:

int
sys_dup(void)
{
801054dc:	55                   	push   %ebp
801054dd:	89 e5                	mov    %esp,%ebp
801054df:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801054e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054e5:	89 44 24 08          	mov    %eax,0x8(%esp)
801054e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801054f0:	00 
801054f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054f8:	e8 1f ff ff ff       	call   8010541c <argfd>
801054fd:	85 c0                	test   %eax,%eax
801054ff:	79 07                	jns    80105508 <sys_dup+0x2c>
    return -1;
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105506:	eb 29                	jmp    80105531 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105508:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010550b:	89 04 24             	mov    %eax,(%esp)
8010550e:	e8 7e ff ff ff       	call   80105491 <fdalloc>
80105513:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010551a:	79 07                	jns    80105523 <sys_dup+0x47>
    return -1;
8010551c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105521:	eb 0e                	jmp    80105531 <sys_dup+0x55>
  filedup(f);
80105523:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105526:	89 04 24             	mov    %eax,(%esp)
80105529:	e8 25 ba ff ff       	call   80100f53 <filedup>
  return fd;
8010552e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105531:	c9                   	leave  
80105532:	c3                   	ret    

80105533 <sys_read>:

int
sys_read(void)
{
80105533:	55                   	push   %ebp
80105534:	89 e5                	mov    %esp,%ebp
80105536:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105539:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105540:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105547:	00 
80105548:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010554f:	e8 c8 fe ff ff       	call   8010541c <argfd>
80105554:	85 c0                	test   %eax,%eax
80105556:	78 35                	js     8010558d <sys_read+0x5a>
80105558:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010555b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010555f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105566:	e8 5b fd ff ff       	call   801052c6 <argint>
8010556b:	85 c0                	test   %eax,%eax
8010556d:	78 1e                	js     8010558d <sys_read+0x5a>
8010556f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105572:	89 44 24 08          	mov    %eax,0x8(%esp)
80105576:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105579:	89 44 24 04          	mov    %eax,0x4(%esp)
8010557d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105584:	e8 6b fd ff ff       	call   801052f4 <argptr>
80105589:	85 c0                	test   %eax,%eax
8010558b:	79 07                	jns    80105594 <sys_read+0x61>
    return -1;
8010558d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105592:	eb 19                	jmp    801055ad <sys_read+0x7a>
  return fileread(f, p, n);
80105594:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105597:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010559a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010559d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801055a5:	89 04 24             	mov    %eax,(%esp)
801055a8:	e8 07 bb ff ff       	call   801010b4 <fileread>
}
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    

801055af <sys_write>:

int
sys_write(void)
{
801055af:	55                   	push   %ebp
801055b0:	89 e5                	mov    %esp,%ebp
801055b2:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801055b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055b8:	89 44 24 08          	mov    %eax,0x8(%esp)
801055bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055c3:	00 
801055c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055cb:	e8 4c fe ff ff       	call   8010541c <argfd>
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 35                	js     80105609 <sys_write+0x5a>
801055d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801055db:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801055e2:	e8 df fc ff ff       	call   801052c6 <argint>
801055e7:	85 c0                	test   %eax,%eax
801055e9:	78 1e                	js     80105609 <sys_write+0x5a>
801055eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ee:	89 44 24 08          	mov    %eax,0x8(%esp)
801055f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801055f5:	89 44 24 04          	mov    %eax,0x4(%esp)
801055f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105600:	e8 ef fc ff ff       	call   801052f4 <argptr>
80105605:	85 c0                	test   %eax,%eax
80105607:	79 07                	jns    80105610 <sys_write+0x61>
    return -1;
80105609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010560e:	eb 19                	jmp    80105629 <sys_write+0x7a>
  return filewrite(f, p, n);
80105610:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105613:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105619:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010561d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105621:	89 04 24             	mov    %eax,(%esp)
80105624:	e8 46 bb ff ff       	call   8010116f <filewrite>
}
80105629:	c9                   	leave  
8010562a:	c3                   	ret    

8010562b <sys_isatty>:

// Minimalish implementation of isatty for xv6. Maybe it will even work, but 
// hopefully it will be sufficient for now.
int sys_isatty(void) {
8010562b:	55                   	push   %ebp
8010562c:	89 e5                	mov    %esp,%ebp
8010562e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  argfd(0, &fd, &f);
80105631:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105634:	89 44 24 08          	mov    %eax,0x8(%esp)
80105638:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010563b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010563f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105646:	e8 d1 fd ff ff       	call   8010541c <argfd>
  if (f->type == FD_INODE) {
8010564b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010564e:	8b 00                	mov    (%eax),%eax
80105650:	83 f8 02             	cmp    $0x2,%eax
80105653:	75 20                	jne    80105675 <sys_isatty+0x4a>
    /* This is bad and wrong, but currently works. Either when more 
     * sophisticated terminal handling comes, or more devices, or both, this
     * will need to distinguish different device types. Still, it's a start. */
    if (f->ip != 0 && f->ip->type == T_DEV)
80105655:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105658:	8b 40 10             	mov    0x10(%eax),%eax
8010565b:	85 c0                	test   %eax,%eax
8010565d:	74 16                	je     80105675 <sys_isatty+0x4a>
8010565f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105662:	8b 40 10             	mov    0x10(%eax),%eax
80105665:	8b 40 10             	mov    0x10(%eax),%eax
80105668:	66 83 f8 03          	cmp    $0x3,%ax
8010566c:	75 07                	jne    80105675 <sys_isatty+0x4a>
      return 1;
8010566e:	b8 01 00 00 00       	mov    $0x1,%eax
80105673:	eb 05                	jmp    8010567a <sys_isatty+0x4f>
  }
  return 0;
80105675:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    

8010567c <sys_lseek>:

// lseek derived from https://github.com/hxp/xv6, written by Joel Heikkila

int sys_lseek(void) {
8010567c:	55                   	push   %ebp
8010567d:	89 e5                	mov    %esp,%ebp
8010567f:	83 ec 48             	sub    $0x48,%esp
	int zerosize, i;
	char *zeroed, *z;

	struct file *f;

	argfd(0, &fd, &f);
80105682:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105685:	89 44 24 08          	mov    %eax,0x8(%esp)
80105689:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010568c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105697:	e8 80 fd ff ff       	call   8010541c <argfd>
	argint(1, &offset);
8010569c:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010569f:	89 44 24 04          	mov    %eax,0x4(%esp)
801056a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801056aa:	e8 17 fc ff ff       	call   801052c6 <argint>
	argint(2, &base);
801056af:	8d 45 d8             	lea    -0x28(%ebp),%eax
801056b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801056bd:	e8 04 fc ff ff       	call   801052c6 <argint>

	if( base == SEEK_SET) {
801056c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056c5:	85 c0                	test   %eax,%eax
801056c7:	75 06                	jne    801056cf <sys_lseek+0x53>
		newoff = offset;
801056c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	if (base == SEEK_CUR)
801056cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056d2:	83 f8 01             	cmp    $0x1,%eax
801056d5:	75 0e                	jne    801056e5 <sys_lseek+0x69>
		newoff = f->off + offset;
801056d7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801056da:	8b 50 14             	mov    0x14(%eax),%edx
801056dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e0:	01 d0                	add    %edx,%eax
801056e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (base == SEEK_END)
801056e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
801056e8:	83 f8 02             	cmp    $0x2,%eax
801056eb:	75 11                	jne    801056fe <sys_lseek+0x82>
		newoff = f->ip->size + offset;
801056ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801056f0:	8b 40 10             	mov    0x10(%eax),%eax
801056f3:	8b 50 18             	mov    0x18(%eax),%edx
801056f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056f9:	01 d0                	add    %edx,%eax
801056fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (newoff < f->ip->size)
801056fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105701:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105704:	8b 40 10             	mov    0x10(%eax),%eax
80105707:	8b 40 18             	mov    0x18(%eax),%eax
8010570a:	39 c2                	cmp    %eax,%edx
8010570c:	73 0a                	jae    80105718 <sys_lseek+0x9c>
		return -1;
8010570e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105713:	e9 92 00 00 00       	jmp    801057aa <sys_lseek+0x12e>

	if (newoff > f->ip->size){
80105718:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010571b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010571e:	8b 40 10             	mov    0x10(%eax),%eax
80105721:	8b 40 18             	mov    0x18(%eax),%eax
80105724:	39 c2                	cmp    %eax,%edx
80105726:	76 74                	jbe    8010579c <sys_lseek+0x120>
		zerosize = newoff - f->ip->size;
80105728:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010572b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010572e:	8b 40 10             	mov    0x10(%eax),%eax
80105731:	8b 40 18             	mov    0x18(%eax),%eax
80105734:	89 d1                	mov    %edx,%ecx
80105736:	29 c1                	sub    %eax,%ecx
80105738:	89 c8                	mov    %ecx,%eax
8010573a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		zeroed = kalloc();
8010573d:	e8 7c d3 ff ff       	call   80102abe <kalloc>
80105742:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = zeroed;
80105745:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105748:	89 45 e8             	mov    %eax,-0x18(%ebp)
		for (i = 0; i < 4096; i++)
8010574b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105752:	eb 0c                	jmp    80105760 <sys_lseek+0xe4>
			*z++ = 0;
80105754:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105757:	c6 00 00             	movb   $0x0,(%eax)
8010575a:	ff 45 e8             	incl   -0x18(%ebp)
		for (i = 0; i < 4096; i++)
8010575d:	ff 45 ec             	incl   -0x14(%ebp)
80105760:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
80105767:	7e eb                	jle    80105754 <sys_lseek+0xd8>
		while (zerosize > 0){
80105769:	eb 20                	jmp    8010578b <sys_lseek+0x10f>
			filewrite(f, zeroed, zerosize);
8010576b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010576e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105771:	89 54 24 08          	mov    %edx,0x8(%esp)
80105775:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105778:	89 54 24 04          	mov    %edx,0x4(%esp)
8010577c:	89 04 24             	mov    %eax,(%esp)
8010577f:	e8 eb b9 ff ff       	call   8010116f <filewrite>
			zerosize -= 4096;
80105784:	81 6d f0 00 10 00 00 	subl   $0x1000,-0x10(%ebp)
		while (zerosize > 0){
8010578b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010578f:	7f da                	jg     8010576b <sys_lseek+0xef>
		}
		kfree(zeroed);
80105791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105794:	89 04 24             	mov    %eax,(%esp)
80105797:	e8 89 d2 ff ff       	call   80102a25 <kfree>
	}

	f->off = newoff;
8010579c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010579f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a2:	89 50 14             	mov    %edx,0x14(%eax)
	return 0;
801057a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    

801057ac <sys_close>:

int
sys_close(void)
{
801057ac:	55                   	push   %ebp
801057ad:	89 e5                	mov    %esp,%ebp
801057af:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801057b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801057b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057c7:	e8 50 fc ff ff       	call   8010541c <argfd>
801057cc:	85 c0                	test   %eax,%eax
801057ce:	79 07                	jns    801057d7 <sys_close+0x2b>
    return -1;
801057d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057d5:	eb 24                	jmp    801057fb <sys_close+0x4f>
  proc->ofile[fd] = 0;
801057d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057e0:	83 c2 08             	add    $0x8,%edx
801057e3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801057ea:	00 
  fileclose(f);
801057eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ee:	89 04 24             	mov    %eax,(%esp)
801057f1:	e8 a5 b7 ff ff       	call   80100f9b <fileclose>
  return 0;
801057f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057fb:	c9                   	leave  
801057fc:	c3                   	ret    

801057fd <sys_fstat>:

int
sys_fstat(void)
{
801057fd:	55                   	push   %ebp
801057fe:	89 e5                	mov    %esp,%ebp
80105800:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105803:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105806:	89 44 24 08          	mov    %eax,0x8(%esp)
8010580a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105811:	00 
80105812:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105819:	e8 fe fb ff ff       	call   8010541c <argfd>
8010581e:	85 c0                	test   %eax,%eax
80105820:	78 1f                	js     80105841 <sys_fstat+0x44>
80105822:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105829:	00 
8010582a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010582d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105831:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105838:	e8 b7 fa ff ff       	call   801052f4 <argptr>
8010583d:	85 c0                	test   %eax,%eax
8010583f:	79 07                	jns    80105848 <sys_fstat+0x4b>
    return -1;
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105846:	eb 12                	jmp    8010585a <sys_fstat+0x5d>
  return filestat(f, st);
80105848:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010584b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105852:	89 04 24             	mov    %eax,(%esp)
80105855:	e8 0b b8 ff ff       	call   80101065 <filestat>
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    

8010585c <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010585c:	55                   	push   %ebp
8010585d:	89 e5                	mov    %esp,%ebp
8010585f:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105862:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105865:	89 44 24 04          	mov    %eax,0x4(%esp)
80105869:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105870:	e8 e1 fa ff ff       	call   80105356 <argstr>
80105875:	85 c0                	test   %eax,%eax
80105877:	78 17                	js     80105890 <sys_link+0x34>
80105879:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010587c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105880:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105887:	e8 ca fa ff ff       	call   80105356 <argstr>
8010588c:	85 c0                	test   %eax,%eax
8010588e:	79 0a                	jns    8010589a <sys_link+0x3e>
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105895:	e9 37 01 00 00       	jmp    801059d1 <sys_link+0x175>
  if((ip = namei(old)) == 0)
8010589a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010589d:	89 04 24             	mov    %eax,(%esp)
801058a0:	e8 3a cb ff ff       	call   801023df <namei>
801058a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058ac:	75 0a                	jne    801058b8 <sys_link+0x5c>
    return -1;
801058ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b3:	e9 19 01 00 00       	jmp    801059d1 <sys_link+0x175>

  begin_trans();
801058b8:	e8 13 d9 ff ff       	call   801031d0 <begin_trans>

  ilock(ip);
801058bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c0:	89 04 24             	mov    %eax,(%esp)
801058c3:	e8 7d bf ff ff       	call   80101845 <ilock>
  if(ip->type == T_DIR){
801058c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058cb:	8b 40 10             	mov    0x10(%eax),%eax
801058ce:	66 83 f8 01          	cmp    $0x1,%ax
801058d2:	75 1a                	jne    801058ee <sys_link+0x92>
    iunlockput(ip);
801058d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058d7:	89 04 24             	mov    %eax,(%esp)
801058da:	e8 e7 c1 ff ff       	call   80101ac6 <iunlockput>
    commit_trans();
801058df:	e8 35 d9 ff ff       	call   80103219 <commit_trans>
    return -1;
801058e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058e9:	e9 e3 00 00 00       	jmp    801059d1 <sys_link+0x175>
  }

  ip->nlink++;
801058ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f1:	66 8b 40 16          	mov    0x16(%eax),%ax
801058f5:	40                   	inc    %eax
801058f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801058f9:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801058fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105900:	89 04 24             	mov    %eax,(%esp)
80105903:	e8 83 bd ff ff       	call   8010168b <iupdate>
  iunlock(ip);
80105908:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590b:	89 04 24             	mov    %eax,(%esp)
8010590e:	e8 7d c0 ff ff       	call   80101990 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105913:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105916:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105919:	89 54 24 04          	mov    %edx,0x4(%esp)
8010591d:	89 04 24             	mov    %eax,(%esp)
80105920:	e8 dc ca ff ff       	call   80102401 <nameiparent>
80105925:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105928:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010592c:	74 68                	je     80105996 <sys_link+0x13a>
    goto bad;
  ilock(dp);
8010592e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105931:	89 04 24             	mov    %eax,(%esp)
80105934:	e8 0c bf ff ff       	call   80101845 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105939:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010593c:	8b 10                	mov    (%eax),%edx
8010593e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105941:	8b 00                	mov    (%eax),%eax
80105943:	39 c2                	cmp    %eax,%edx
80105945:	75 20                	jne    80105967 <sys_link+0x10b>
80105947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010594a:	8b 40 04             	mov    0x4(%eax),%eax
8010594d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105951:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105954:	89 44 24 04          	mov    %eax,0x4(%esp)
80105958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595b:	89 04 24             	mov    %eax,(%esp)
8010595e:	e8 c5 c7 ff ff       	call   80102128 <dirlink>
80105963:	85 c0                	test   %eax,%eax
80105965:	79 0d                	jns    80105974 <sys_link+0x118>
    iunlockput(dp);
80105967:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010596a:	89 04 24             	mov    %eax,(%esp)
8010596d:	e8 54 c1 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
80105972:	eb 23                	jmp    80105997 <sys_link+0x13b>
  }
  iunlockput(dp);
80105974:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105977:	89 04 24             	mov    %eax,(%esp)
8010597a:	e8 47 c1 ff ff       	call   80101ac6 <iunlockput>
  iput(ip);
8010597f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105982:	89 04 24             	mov    %eax,(%esp)
80105985:	e8 6b c0 ff ff       	call   801019f5 <iput>

  commit_trans();
8010598a:	e8 8a d8 ff ff       	call   80103219 <commit_trans>

  return 0;
8010598f:	b8 00 00 00 00       	mov    $0x0,%eax
80105994:	eb 3b                	jmp    801059d1 <sys_link+0x175>
    goto bad;
80105996:	90                   	nop

bad:
  ilock(ip);
80105997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010599a:	89 04 24             	mov    %eax,(%esp)
8010599d:	e8 a3 be ff ff       	call   80101845 <ilock>
  ip->nlink--;
801059a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059a5:	66 8b 40 16          	mov    0x16(%eax),%ax
801059a9:	48                   	dec    %eax
801059aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ad:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
801059b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b4:	89 04 24             	mov    %eax,(%esp)
801059b7:	e8 cf bc ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
801059bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bf:	89 04 24             	mov    %eax,(%esp)
801059c2:	e8 ff c0 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
801059c7:	e8 4d d8 ff ff       	call   80103219 <commit_trans>
  return -1;
801059cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059d1:	c9                   	leave  
801059d2:	c3                   	ret    

801059d3 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801059d3:	55                   	push   %ebp
801059d4:	89 e5                	mov    %esp,%ebp
801059d6:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059d9:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801059e0:	eb 4a                	jmp    80105a2c <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801059e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e5:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801059ec:	00 
801059ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801059f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801059f8:	8b 45 08             	mov    0x8(%ebp),%eax
801059fb:	89 04 24             	mov    %eax,(%esp)
801059fe:	e8 49 c3 ff ff       	call   80101d4c <readi>
80105a03:	83 f8 10             	cmp    $0x10,%eax
80105a06:	74 0c                	je     80105a14 <isdirempty+0x41>
      panic("isdirempty: readi");
80105a08:	c7 04 24 35 88 10 80 	movl   $0x80108835,(%esp)
80105a0f:	e8 22 ab ff ff       	call   80100536 <panic>
    if(de.inum != 0)
80105a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105a17:	66 85 c0             	test   %ax,%ax
80105a1a:	74 07                	je     80105a23 <isdirempty+0x50>
      return 0;
80105a1c:	b8 00 00 00 00       	mov    $0x0,%eax
80105a21:	eb 1b                	jmp    80105a3e <isdirempty+0x6b>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	83 c0 10             	add    $0x10,%eax
80105a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80105a32:	8b 40 18             	mov    0x18(%eax),%eax
80105a35:	39 c2                	cmp    %eax,%edx
80105a37:	72 a9                	jb     801059e2 <isdirempty+0xf>
  }
  return 1;
80105a39:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105a3e:	c9                   	leave  
80105a3f:	c3                   	ret    

80105a40 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105a46:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105a49:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a4d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a54:	e8 fd f8 ff ff       	call   80105356 <argstr>
80105a59:	85 c0                	test   %eax,%eax
80105a5b:	79 0a                	jns    80105a67 <sys_unlink+0x27>
    return -1;
80105a5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a62:	e9 a4 01 00 00       	jmp    80105c0b <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
80105a67:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105a6a:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105a6d:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a71:	89 04 24             	mov    %eax,(%esp)
80105a74:	e8 88 c9 ff ff       	call   80102401 <nameiparent>
80105a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a80:	75 0a                	jne    80105a8c <sys_unlink+0x4c>
    return -1;
80105a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a87:	e9 7f 01 00 00       	jmp    80105c0b <sys_unlink+0x1cb>

  begin_trans();
80105a8c:	e8 3f d7 ff ff       	call   801031d0 <begin_trans>

  ilock(dp);
80105a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a94:	89 04 24             	mov    %eax,(%esp)
80105a97:	e8 a9 bd ff ff       	call   80101845 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105a9c:	c7 44 24 04 47 88 10 	movl   $0x80108847,0x4(%esp)
80105aa3:	80 
80105aa4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105aa7:	89 04 24             	mov    %eax,(%esp)
80105aaa:	e8 92 c5 ff ff       	call   80102041 <namecmp>
80105aaf:	85 c0                	test   %eax,%eax
80105ab1:	0f 84 3f 01 00 00    	je     80105bf6 <sys_unlink+0x1b6>
80105ab7:	c7 44 24 04 49 88 10 	movl   $0x80108849,0x4(%esp)
80105abe:	80 
80105abf:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ac2:	89 04 24             	mov    %eax,(%esp)
80105ac5:	e8 77 c5 ff ff       	call   80102041 <namecmp>
80105aca:	85 c0                	test   %eax,%eax
80105acc:	0f 84 24 01 00 00    	je     80105bf6 <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ad2:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ad5:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ad9:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae3:	89 04 24             	mov    %eax,(%esp)
80105ae6:	e8 78 c5 ff ff       	call   80102063 <dirlookup>
80105aeb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105aee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105af2:	0f 84 fd 00 00 00    	je     80105bf5 <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80105af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afb:	89 04 24             	mov    %eax,(%esp)
80105afe:	e8 42 bd ff ff       	call   80101845 <ilock>

  if(ip->nlink < 1)
80105b03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b06:	66 8b 40 16          	mov    0x16(%eax),%ax
80105b0a:	66 85 c0             	test   %ax,%ax
80105b0d:	7f 0c                	jg     80105b1b <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105b0f:	c7 04 24 4c 88 10 80 	movl   $0x8010884c,(%esp)
80105b16:	e8 1b aa ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1e:	8b 40 10             	mov    0x10(%eax),%eax
80105b21:	66 83 f8 01          	cmp    $0x1,%ax
80105b25:	75 1f                	jne    80105b46 <sys_unlink+0x106>
80105b27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2a:	89 04 24             	mov    %eax,(%esp)
80105b2d:	e8 a1 fe ff ff       	call   801059d3 <isdirempty>
80105b32:	85 c0                	test   %eax,%eax
80105b34:	75 10                	jne    80105b46 <sys_unlink+0x106>
    iunlockput(ip);
80105b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b39:	89 04 24             	mov    %eax,(%esp)
80105b3c:	e8 85 bf ff ff       	call   80101ac6 <iunlockput>
    goto bad;
80105b41:	e9 b0 00 00 00       	jmp    80105bf6 <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
80105b46:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105b4d:	00 
80105b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105b55:	00 
80105b56:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b59:	89 04 24             	mov    %eax,(%esp)
80105b5c:	e8 34 f4 ff ff       	call   80104f95 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b61:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105b64:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b6b:	00 
80105b6c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b70:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105b73:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7a:	89 04 24             	mov    %eax,(%esp)
80105b7d:	e8 2f c3 ff ff       	call   80101eb1 <writei>
80105b82:	83 f8 10             	cmp    $0x10,%eax
80105b85:	74 0c                	je     80105b93 <sys_unlink+0x153>
    panic("unlink: writei");
80105b87:	c7 04 24 5e 88 10 80 	movl   $0x8010885e,(%esp)
80105b8e:	e8 a3 a9 ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
80105b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b96:	8b 40 10             	mov    0x10(%eax),%eax
80105b99:	66 83 f8 01          	cmp    $0x1,%ax
80105b9d:	75 1a                	jne    80105bb9 <sys_unlink+0x179>
    dp->nlink--;
80105b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba2:	66 8b 40 16          	mov    0x16(%eax),%ax
80105ba6:	48                   	dec    %eax
80105ba7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105baa:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb1:	89 04 24             	mov    %eax,(%esp)
80105bb4:	e8 d2 ba ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
80105bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bbc:	89 04 24             	mov    %eax,(%esp)
80105bbf:	e8 02 bf ff ff       	call   80101ac6 <iunlockput>

  ip->nlink--;
80105bc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc7:	66 8b 40 16          	mov    0x16(%eax),%ax
80105bcb:	48                   	dec    %eax
80105bcc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105bcf:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd6:	89 04 24             	mov    %eax,(%esp)
80105bd9:	e8 ad ba ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80105bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be1:	89 04 24             	mov    %eax,(%esp)
80105be4:	e8 dd be ff ff       	call   80101ac6 <iunlockput>

  commit_trans();
80105be9:	e8 2b d6 ff ff       	call   80103219 <commit_trans>

  return 0;
80105bee:	b8 00 00 00 00       	mov    $0x0,%eax
80105bf3:	eb 16                	jmp    80105c0b <sys_unlink+0x1cb>
    goto bad;
80105bf5:	90                   	nop

bad:
  iunlockput(dp);
80105bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf9:	89 04 24             	mov    %eax,(%esp)
80105bfc:	e8 c5 be ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80105c01:	e8 13 d6 ff ff       	call   80103219 <commit_trans>
  return -1;
80105c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c0b:	c9                   	leave  
80105c0c:	c3                   	ret    

80105c0d <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105c0d:	55                   	push   %ebp
80105c0e:	89 e5                	mov    %esp,%ebp
80105c10:	83 ec 48             	sub    $0x48,%esp
80105c13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c16:	8b 55 10             	mov    0x10(%ebp),%edx
80105c19:	8b 45 14             	mov    0x14(%ebp),%eax
80105c1c:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105c20:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105c24:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c28:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
80105c32:	89 04 24             	mov    %eax,(%esp)
80105c35:	e8 c7 c7 ff ff       	call   80102401 <nameiparent>
80105c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c41:	75 0a                	jne    80105c4d <create+0x40>
    return 0;
80105c43:	b8 00 00 00 00       	mov    $0x0,%eax
80105c48:	e9 79 01 00 00       	jmp    80105dc6 <create+0x1b9>
  ilock(dp);
80105c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c50:	89 04 24             	mov    %eax,(%esp)
80105c53:	e8 ed bb ff ff       	call   80101845 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c5b:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c5f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105c62:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c69:	89 04 24             	mov    %eax,(%esp)
80105c6c:	e8 f2 c3 ff ff       	call   80102063 <dirlookup>
80105c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c78:	74 46                	je     80105cc0 <create+0xb3>
    iunlockput(dp);
80105c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7d:	89 04 24             	mov    %eax,(%esp)
80105c80:	e8 41 be ff ff       	call   80101ac6 <iunlockput>
    ilock(ip);
80105c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c88:	89 04 24             	mov    %eax,(%esp)
80105c8b:	e8 b5 bb ff ff       	call   80101845 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105c90:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105c95:	75 14                	jne    80105cab <create+0x9e>
80105c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9a:	8b 40 10             	mov    0x10(%eax),%eax
80105c9d:	66 83 f8 02          	cmp    $0x2,%ax
80105ca1:	75 08                	jne    80105cab <create+0x9e>
      return ip;
80105ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca6:	e9 1b 01 00 00       	jmp    80105dc6 <create+0x1b9>
    iunlockput(ip);
80105cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cae:	89 04 24             	mov    %eax,(%esp)
80105cb1:	e8 10 be ff ff       	call   80101ac6 <iunlockput>
    return 0;
80105cb6:	b8 00 00 00 00       	mov    $0x0,%eax
80105cbb:	e9 06 01 00 00       	jmp    80105dc6 <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105cc0:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc7:	8b 00                	mov    (%eax),%eax
80105cc9:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ccd:	89 04 24             	mov    %eax,(%esp)
80105cd0:	e8 ce b8 ff ff       	call   801015a3 <ialloc>
80105cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cdc:	75 0c                	jne    80105cea <create+0xdd>
    panic("create: ialloc");
80105cde:	c7 04 24 6d 88 10 80 	movl   $0x8010886d,(%esp)
80105ce5:	e8 4c a8 ff ff       	call   80100536 <panic>

  ilock(ip);
80105cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ced:	89 04 24             	mov    %eax,(%esp)
80105cf0:	e8 50 bb ff ff       	call   80101845 <ilock>
  ip->major = major;
80105cf5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cf8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105cfb:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105cff:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d02:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105d05:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d15:	89 04 24             	mov    %eax,(%esp)
80105d18:	e8 6e b9 ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105d1d:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d22:	75 68                	jne    80105d8c <create+0x17f>
    dp->nlink++;  // for ".."
80105d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d27:	66 8b 40 16          	mov    0x16(%eax),%ax
80105d2b:	40                   	inc    %eax
80105d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d2f:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d36:	89 04 24             	mov    %eax,(%esp)
80105d39:	e8 4d b9 ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d41:	8b 40 04             	mov    0x4(%eax),%eax
80105d44:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d48:	c7 44 24 04 47 88 10 	movl   $0x80108847,0x4(%esp)
80105d4f:	80 
80105d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d53:	89 04 24             	mov    %eax,(%esp)
80105d56:	e8 cd c3 ff ff       	call   80102128 <dirlink>
80105d5b:	85 c0                	test   %eax,%eax
80105d5d:	78 21                	js     80105d80 <create+0x173>
80105d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d62:	8b 40 04             	mov    0x4(%eax),%eax
80105d65:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d69:	c7 44 24 04 49 88 10 	movl   $0x80108849,0x4(%esp)
80105d70:	80 
80105d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d74:	89 04 24             	mov    %eax,(%esp)
80105d77:	e8 ac c3 ff ff       	call   80102128 <dirlink>
80105d7c:	85 c0                	test   %eax,%eax
80105d7e:	79 0c                	jns    80105d8c <create+0x17f>
      panic("create dots");
80105d80:	c7 04 24 7c 88 10 80 	movl   $0x8010887c,(%esp)
80105d87:	e8 aa a7 ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8f:	8b 40 04             	mov    0x4(%eax),%eax
80105d92:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d96:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d99:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da0:	89 04 24             	mov    %eax,(%esp)
80105da3:	e8 80 c3 ff ff       	call   80102128 <dirlink>
80105da8:	85 c0                	test   %eax,%eax
80105daa:	79 0c                	jns    80105db8 <create+0x1ab>
    panic("create: dirlink");
80105dac:	c7 04 24 88 88 10 80 	movl   $0x80108888,(%esp)
80105db3:	e8 7e a7 ff ff       	call   80100536 <panic>

  iunlockput(dp);
80105db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dbb:	89 04 24             	mov    %eax,(%esp)
80105dbe:	e8 03 bd ff ff       	call   80101ac6 <iunlockput>

  return ip;
80105dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105dc6:	c9                   	leave  
80105dc7:	c3                   	ret    

80105dc8 <sys_open>:

int
sys_open(void)
{
80105dc8:	55                   	push   %ebp
80105dc9:	89 e5                	mov    %esp,%ebp
80105dcb:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105dce:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105ddc:	e8 75 f5 ff ff       	call   80105356 <argstr>
80105de1:	85 c0                	test   %eax,%eax
80105de3:	78 17                	js     80105dfc <sys_open+0x34>
80105de5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105de8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105df3:	e8 ce f4 ff ff       	call   801052c6 <argint>
80105df8:	85 c0                	test   %eax,%eax
80105dfa:	79 0a                	jns    80105e06 <sys_open+0x3e>
    return -1;
80105dfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e01:	e9 47 01 00 00       	jmp    80105f4d <sys_open+0x185>
  if(omode & O_CREATE){
80105e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e09:	25 00 02 00 00       	and    $0x200,%eax
80105e0e:	85 c0                	test   %eax,%eax
80105e10:	74 40                	je     80105e52 <sys_open+0x8a>
    begin_trans();
80105e12:	e8 b9 d3 ff ff       	call   801031d0 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e1a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105e21:	00 
80105e22:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105e29:	00 
80105e2a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105e31:	00 
80105e32:	89 04 24             	mov    %eax,(%esp)
80105e35:	e8 d3 fd ff ff       	call   80105c0d <create>
80105e3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105e3d:	e8 d7 d3 ff ff       	call   80103219 <commit_trans>
    if(ip == 0)
80105e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e46:	75 5b                	jne    80105ea3 <sys_open+0xdb>
      return -1;
80105e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4d:	e9 fb 00 00 00       	jmp    80105f4d <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
80105e52:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105e55:	89 04 24             	mov    %eax,(%esp)
80105e58:	e8 82 c5 ff ff       	call   801023df <namei>
80105e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e64:	75 0a                	jne    80105e70 <sys_open+0xa8>
      return -1;
80105e66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e6b:	e9 dd 00 00 00       	jmp    80105f4d <sys_open+0x185>
    ilock(ip);
80105e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e73:	89 04 24             	mov    %eax,(%esp)
80105e76:	e8 ca b9 ff ff       	call   80101845 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7e:	8b 40 10             	mov    0x10(%eax),%eax
80105e81:	66 83 f8 01          	cmp    $0x1,%ax
80105e85:	75 1c                	jne    80105ea3 <sys_open+0xdb>
80105e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e8a:	85 c0                	test   %eax,%eax
80105e8c:	74 15                	je     80105ea3 <sys_open+0xdb>
      iunlockput(ip);
80105e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e91:	89 04 24             	mov    %eax,(%esp)
80105e94:	e8 2d bc ff ff       	call   80101ac6 <iunlockput>
      return -1;
80105e99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9e:	e9 aa 00 00 00       	jmp    80105f4d <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ea3:	e8 4b b0 ff ff       	call   80100ef3 <filealloc>
80105ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105eab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105eaf:	74 14                	je     80105ec5 <sys_open+0xfd>
80105eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb4:	89 04 24             	mov    %eax,(%esp)
80105eb7:	e8 d5 f5 ff ff       	call   80105491 <fdalloc>
80105ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105ebf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105ec3:	79 23                	jns    80105ee8 <sys_open+0x120>
    if(f)
80105ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ec9:	74 0b                	je     80105ed6 <sys_open+0x10e>
      fileclose(f);
80105ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ece:	89 04 24             	mov    %eax,(%esp)
80105ed1:	e8 c5 b0 ff ff       	call   80100f9b <fileclose>
    iunlockput(ip);
80105ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed9:	89 04 24             	mov    %eax,(%esp)
80105edc:	e8 e5 bb ff ff       	call   80101ac6 <iunlockput>
    return -1;
80105ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ee6:	eb 65                	jmp    80105f4d <sys_open+0x185>
  }
  iunlock(ip);
80105ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eeb:	89 04 24             	mov    %eax,(%esp)
80105eee:	e8 9d ba ff ff       	call   80101990 <iunlock>

  f->type = FD_INODE;
80105ef3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f02:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f08:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f12:	83 e0 01             	and    $0x1,%eax
80105f15:	85 c0                	test   %eax,%eax
80105f17:	0f 94 c0             	sete   %al
80105f1a:	88 c2                	mov    %al,%dl
80105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1f:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f25:	83 e0 01             	and    $0x1,%eax
80105f28:	85 c0                	test   %eax,%eax
80105f2a:	75 0a                	jne    80105f36 <sys_open+0x16e>
80105f2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f2f:	83 e0 02             	and    $0x2,%eax
80105f32:	85 c0                	test   %eax,%eax
80105f34:	74 07                	je     80105f3d <sys_open+0x175>
80105f36:	b8 01 00 00 00       	mov    $0x1,%eax
80105f3b:	eb 05                	jmp    80105f42 <sys_open+0x17a>
80105f3d:	b8 00 00 00 00       	mov    $0x0,%eax
80105f42:	88 c2                	mov    %al,%dl
80105f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f47:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105f4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105f4d:	c9                   	leave  
80105f4e:	c3                   	ret    

80105f4f <sys_mkdir>:

int
sys_mkdir(void)
{
80105f4f:	55                   	push   %ebp
80105f50:	89 e5                	mov    %esp,%ebp
80105f52:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105f55:	e8 76 d2 ff ff       	call   801031d0 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105f5a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f68:	e8 e9 f3 ff ff       	call   80105356 <argstr>
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	78 2c                	js     80105f9d <sys_mkdir+0x4e>
80105f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f7b:	00 
80105f7c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f83:	00 
80105f84:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105f8b:	00 
80105f8c:	89 04 24             	mov    %eax,(%esp)
80105f8f:	e8 79 fc ff ff       	call   80105c0d <create>
80105f94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f9b:	75 0c                	jne    80105fa9 <sys_mkdir+0x5a>
    commit_trans();
80105f9d:	e8 77 d2 ff ff       	call   80103219 <commit_trans>
    return -1;
80105fa2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa7:	eb 15                	jmp    80105fbe <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fac:	89 04 24             	mov    %eax,(%esp)
80105faf:	e8 12 bb ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80105fb4:	e8 60 d2 ff ff       	call   80103219 <commit_trans>
  return 0;
80105fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fbe:	c9                   	leave  
80105fbf:	c3                   	ret    

80105fc0 <sys_mknod>:

int
sys_mknod(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105fc6:	e8 05 d2 ff ff       	call   801031d0 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105fcb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105fce:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fd9:	e8 78 f3 ff ff       	call   80105356 <argstr>
80105fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fe5:	78 5e                	js     80106045 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105fe7:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fea:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105ff5:	e8 cc f2 ff ff       	call   801052c6 <argint>
  if((len=argstr(0, &path)) < 0 ||
80105ffa:	85 c0                	test   %eax,%eax
80105ffc:	78 47                	js     80106045 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
80105ffe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106001:	89 44 24 04          	mov    %eax,0x4(%esp)
80106005:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010600c:	e8 b5 f2 ff ff       	call   801052c6 <argint>
     argint(1, &major) < 0 ||
80106011:	85 c0                	test   %eax,%eax
80106013:	78 30                	js     80106045 <sys_mknod+0x85>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106015:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106018:	0f bf c8             	movswl %ax,%ecx
8010601b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010601e:	0f bf d0             	movswl %ax,%edx
80106021:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80106024:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106028:	89 54 24 08          	mov    %edx,0x8(%esp)
8010602c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106033:	00 
80106034:	89 04 24             	mov    %eax,(%esp)
80106037:	e8 d1 fb ff ff       	call   80105c0d <create>
8010603c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010603f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106043:	75 0c                	jne    80106051 <sys_mknod+0x91>
    commit_trans();
80106045:	e8 cf d1 ff ff       	call   80103219 <commit_trans>
    return -1;
8010604a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604f:	eb 15                	jmp    80106066 <sys_mknod+0xa6>
  }
  iunlockput(ip);
80106051:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106054:	89 04 24             	mov    %eax,(%esp)
80106057:	e8 6a ba ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010605c:	e8 b8 d1 ff ff       	call   80103219 <commit_trans>
  return 0;
80106061:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106066:	c9                   	leave  
80106067:	c3                   	ret    

80106068 <sys_chdir>:

int
sys_chdir(void)
{
80106068:	55                   	push   %ebp
80106069:	89 e5                	mov    %esp,%ebp
8010606b:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
8010606e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106071:	89 44 24 04          	mov    %eax,0x4(%esp)
80106075:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010607c:	e8 d5 f2 ff ff       	call   80105356 <argstr>
80106081:	85 c0                	test   %eax,%eax
80106083:	78 14                	js     80106099 <sys_chdir+0x31>
80106085:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106088:	89 04 24             	mov    %eax,(%esp)
8010608b:	e8 4f c3 ff ff       	call   801023df <namei>
80106090:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106093:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106097:	75 07                	jne    801060a0 <sys_chdir+0x38>
    return -1;
80106099:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010609e:	eb 56                	jmp    801060f6 <sys_chdir+0x8e>
  ilock(ip);
801060a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a3:	89 04 24             	mov    %eax,(%esp)
801060a6:	e8 9a b7 ff ff       	call   80101845 <ilock>
  if(ip->type != T_DIR){
801060ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ae:	8b 40 10             	mov    0x10(%eax),%eax
801060b1:	66 83 f8 01          	cmp    $0x1,%ax
801060b5:	74 12                	je     801060c9 <sys_chdir+0x61>
    iunlockput(ip);
801060b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ba:	89 04 24             	mov    %eax,(%esp)
801060bd:	e8 04 ba ff ff       	call   80101ac6 <iunlockput>
    return -1;
801060c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060c7:	eb 2d                	jmp    801060f6 <sys_chdir+0x8e>
  }
  iunlock(ip);
801060c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060cc:	89 04 24             	mov    %eax,(%esp)
801060cf:	e8 bc b8 ff ff       	call   80101990 <iunlock>
  iput(proc->cwd);
801060d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060da:	8b 40 68             	mov    0x68(%eax),%eax
801060dd:	89 04 24             	mov    %eax,(%esp)
801060e0:	e8 10 b9 ff ff       	call   801019f5 <iput>
  proc->cwd = ip;
801060e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060ee:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801060f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060f6:	c9                   	leave  
801060f7:	c3                   	ret    

801060f8 <sys_exec>:

int
sys_exec(void)
{
801060f8:	55                   	push   %ebp
801060f9:	89 e5                	mov    %esp,%ebp
801060fb:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106101:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106104:	89 44 24 04          	mov    %eax,0x4(%esp)
80106108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010610f:	e8 42 f2 ff ff       	call   80105356 <argstr>
80106114:	85 c0                	test   %eax,%eax
80106116:	78 1a                	js     80106132 <sys_exec+0x3a>
80106118:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010611e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106122:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106129:	e8 98 f1 ff ff       	call   801052c6 <argint>
8010612e:	85 c0                	test   %eax,%eax
80106130:	79 0a                	jns    8010613c <sys_exec+0x44>
    return -1;
80106132:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106137:	e9 c7 00 00 00       	jmp    80106203 <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
8010613c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106143:	00 
80106144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010614b:	00 
8010614c:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106152:	89 04 24             	mov    %eax,(%esp)
80106155:	e8 3b ee ff ff       	call   80104f95 <memset>
  for(i=0;; i++){
8010615a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106161:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106164:	83 f8 1f             	cmp    $0x1f,%eax
80106167:	76 0a                	jbe    80106173 <sys_exec+0x7b>
      return -1;
80106169:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616e:	e9 90 00 00 00       	jmp    80106203 <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106176:	c1 e0 02             	shl    $0x2,%eax
80106179:	89 c2                	mov    %eax,%edx
8010617b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106181:	01 c2                	add    %eax,%edx
80106183:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106189:	89 44 24 04          	mov    %eax,0x4(%esp)
8010618d:	89 14 24             	mov    %edx,(%esp)
80106190:	e8 95 f0 ff ff       	call   8010522a <fetchint>
80106195:	85 c0                	test   %eax,%eax
80106197:	79 07                	jns    801061a0 <sys_exec+0xa8>
      return -1;
80106199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619e:	eb 63                	jmp    80106203 <sys_exec+0x10b>
    if(uarg == 0){
801061a0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801061a6:	85 c0                	test   %eax,%eax
801061a8:	75 26                	jne    801061d0 <sys_exec+0xd8>
      argv[i] = 0;
801061aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ad:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801061b4:	00 00 00 00 
      break;
801061b8:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801061b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061bc:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801061c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801061c6:	89 04 24             	mov    %eax,(%esp)
801061c9:	e8 fd a8 ff ff       	call   80100acb <exec>
801061ce:	eb 33                	jmp    80106203 <sys_exec+0x10b>
    if(fetchstr(uarg, &argv[i]) < 0)
801061d0:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801061d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801061d9:	c1 e2 02             	shl    $0x2,%edx
801061dc:	01 c2                	add    %eax,%edx
801061de:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801061e4:	89 54 24 04          	mov    %edx,0x4(%esp)
801061e8:	89 04 24             	mov    %eax,(%esp)
801061eb:	e8 74 f0 ff ff       	call   80105264 <fetchstr>
801061f0:	85 c0                	test   %eax,%eax
801061f2:	79 07                	jns    801061fb <sys_exec+0x103>
      return -1;
801061f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061f9:	eb 08                	jmp    80106203 <sys_exec+0x10b>
  for(i=0;; i++){
801061fb:	ff 45 f4             	incl   -0xc(%ebp)
  }
801061fe:	e9 5e ff ff ff       	jmp    80106161 <sys_exec+0x69>
}
80106203:	c9                   	leave  
80106204:	c3                   	ret    

80106205 <sys_pipe>:

int
sys_pipe(void)
{
80106205:	55                   	push   %ebp
80106206:	89 e5                	mov    %esp,%ebp
80106208:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010620b:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106212:	00 
80106213:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106216:	89 44 24 04          	mov    %eax,0x4(%esp)
8010621a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106221:	e8 ce f0 ff ff       	call   801052f4 <argptr>
80106226:	85 c0                	test   %eax,%eax
80106228:	79 0a                	jns    80106234 <sys_pipe+0x2f>
    return -1;
8010622a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010622f:	e9 9b 00 00 00       	jmp    801062cf <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80106234:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106237:	89 44 24 04          	mov    %eax,0x4(%esp)
8010623b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010623e:	89 04 24             	mov    %eax,(%esp)
80106241:	e8 cc d9 ff ff       	call   80103c12 <pipealloc>
80106246:	85 c0                	test   %eax,%eax
80106248:	79 07                	jns    80106251 <sys_pipe+0x4c>
    return -1;
8010624a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624f:	eb 7e                	jmp    801062cf <sys_pipe+0xca>
  fd0 = -1;
80106251:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106258:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010625b:	89 04 24             	mov    %eax,(%esp)
8010625e:	e8 2e f2 ff ff       	call   80105491 <fdalloc>
80106263:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106266:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010626a:	78 14                	js     80106280 <sys_pipe+0x7b>
8010626c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010626f:	89 04 24             	mov    %eax,(%esp)
80106272:	e8 1a f2 ff ff       	call   80105491 <fdalloc>
80106277:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010627a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010627e:	79 37                	jns    801062b7 <sys_pipe+0xb2>
    if(fd0 >= 0)
80106280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106284:	78 14                	js     8010629a <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106286:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010628c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010628f:	83 c2 08             	add    $0x8,%edx
80106292:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106299:	00 
    fileclose(rf);
8010629a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010629d:	89 04 24             	mov    %eax,(%esp)
801062a0:	e8 f6 ac ff ff       	call   80100f9b <fileclose>
    fileclose(wf);
801062a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062a8:	89 04 24             	mov    %eax,(%esp)
801062ab:	e8 eb ac ff ff       	call   80100f9b <fileclose>
    return -1;
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b5:	eb 18                	jmp    801062cf <sys_pipe+0xca>
  }
  fd[0] = fd0;
801062b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062bd:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801062bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062c2:	8d 50 04             	lea    0x4(%eax),%edx
801062c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c8:	89 02                	mov    %eax,(%edx)
  return 0;
801062ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062cf:	c9                   	leave  
801062d0:	c3                   	ret    

801062d1 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801062d1:	55                   	push   %ebp
801062d2:	89 e5                	mov    %esp,%ebp
801062d4:	83 ec 08             	sub    $0x8,%esp
  return fork();
801062d7:	e8 ba e1 ff ff       	call   80104496 <fork>
}
801062dc:	c9                   	leave  
801062dd:	c3                   	ret    

801062de <sys_exit>:

int
sys_exit(void)
{
801062de:	55                   	push   %ebp
801062df:	89 e5                	mov    %esp,%ebp
801062e1:	83 ec 08             	sub    $0x8,%esp
  exit();
801062e4:	e8 0e e3 ff ff       	call   801045f7 <exit>
  return 0;  // not reached
801062e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062ee:	c9                   	leave  
801062ef:	c3                   	ret    

801062f0 <sys_wait>:

int
sys_wait(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 08             	sub    $0x8,%esp
  return wait();
801062f6:	e8 16 e4 ff ff       	call   80104711 <wait>
}
801062fb:	c9                   	leave  
801062fc:	c3                   	ret    

801062fd <sys_kill>:

int
sys_kill(void)
{
801062fd:	55                   	push   %ebp
801062fe:	89 e5                	mov    %esp,%ebp
80106300:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106303:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106306:	89 44 24 04          	mov    %eax,0x4(%esp)
8010630a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106311:	e8 b0 ef ff ff       	call   801052c6 <argint>
80106316:	85 c0                	test   %eax,%eax
80106318:	79 07                	jns    80106321 <sys_kill+0x24>
    return -1;
8010631a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010631f:	eb 0b                	jmp    8010632c <sys_kill+0x2f>
  return kill(pid);
80106321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106324:	89 04 24             	mov    %eax,(%esp)
80106327:	e8 24 e8 ff ff       	call   80104b50 <kill>
}
8010632c:	c9                   	leave  
8010632d:	c3                   	ret    

8010632e <sys_getpid>:

int
sys_getpid(void)
{
8010632e:	55                   	push   %ebp
8010632f:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106331:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106337:	8b 40 10             	mov    0x10(%eax),%eax
}
8010633a:	5d                   	pop    %ebp
8010633b:	c3                   	ret    

8010633c <sys_sbrk>:

int
sys_sbrk(void)
{
8010633c:	55                   	push   %ebp
8010633d:	89 e5                	mov    %esp,%ebp
8010633f:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106342:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106345:	89 44 24 04          	mov    %eax,0x4(%esp)
80106349:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106350:	e8 71 ef ff ff       	call   801052c6 <argint>
80106355:	85 c0                	test   %eax,%eax
80106357:	79 07                	jns    80106360 <sys_sbrk+0x24>
    return -1;
80106359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010635e:	eb 24                	jmp    80106384 <sys_sbrk+0x48>
  addr = proc->sz;
80106360:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106366:	8b 00                	mov    (%eax),%eax
80106368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010636b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010636e:	89 04 24             	mov    %eax,(%esp)
80106371:	e8 7b e0 ff ff       	call   801043f1 <growproc>
80106376:	85 c0                	test   %eax,%eax
80106378:	79 07                	jns    80106381 <sys_sbrk+0x45>
    return -1;
8010637a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010637f:	eb 03                	jmp    80106384 <sys_sbrk+0x48>
  return addr;
80106381:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106384:	c9                   	leave  
80106385:	c3                   	ret    

80106386 <sys_sleep>:

int
sys_sleep(void)
{
80106386:	55                   	push   %ebp
80106387:	89 e5                	mov    %esp,%ebp
80106389:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
8010638c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010638f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106393:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010639a:	e8 27 ef ff ff       	call   801052c6 <argint>
8010639f:	85 c0                	test   %eax,%eax
801063a1:	79 07                	jns    801063aa <sys_sleep+0x24>
    return -1;
801063a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a8:	eb 6c                	jmp    80106416 <sys_sleep+0x90>
  acquire(&tickslock);
801063aa:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
801063b1:	e8 8d e9 ff ff       	call   80104d43 <acquire>
  ticks0 = ticks;
801063b6:	a1 e0 29 11 80       	mov    0x801129e0,%eax
801063bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801063be:	eb 34                	jmp    801063f4 <sys_sleep+0x6e>
    if(proc->killed){
801063c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063c6:	8b 40 24             	mov    0x24(%eax),%eax
801063c9:	85 c0                	test   %eax,%eax
801063cb:	74 13                	je     801063e0 <sys_sleep+0x5a>
      release(&tickslock);
801063cd:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
801063d4:	e8 cc e9 ff ff       	call   80104da5 <release>
      return -1;
801063d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063de:	eb 36                	jmp    80106416 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
801063e0:	c7 44 24 04 a0 21 11 	movl   $0x801121a0,0x4(%esp)
801063e7:	80 
801063e8:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
801063ef:	e8 29 e6 ff ff       	call   80104a1d <sleep>
  while(ticks - ticks0 < n){
801063f4:	a1 e0 29 11 80       	mov    0x801129e0,%eax
801063f9:	89 c2                	mov    %eax,%edx
801063fb:	2b 55 f4             	sub    -0xc(%ebp),%edx
801063fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106401:	39 c2                	cmp    %eax,%edx
80106403:	72 bb                	jb     801063c0 <sys_sleep+0x3a>
  }
  release(&tickslock);
80106405:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
8010640c:	e8 94 e9 ff ff       	call   80104da5 <release>
  return 0;
80106411:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106416:	c9                   	leave  
80106417:	c3                   	ret    

80106418 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106418:	55                   	push   %ebp
80106419:	89 e5                	mov    %esp,%ebp
8010641b:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
8010641e:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
80106425:	e8 19 e9 ff ff       	call   80104d43 <acquire>
  xticks = ticks;
8010642a:	a1 e0 29 11 80       	mov    0x801129e0,%eax
8010642f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106432:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
80106439:	e8 67 e9 ff ff       	call   80104da5 <release>
  return xticks;
8010643e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106441:	c9                   	leave  
80106442:	c3                   	ret    

80106443 <sys_procstat>:

// New: Add in proyect 1: implementation of system call procstat
int
sys_procstat(void){             
80106443:	55                   	push   %ebp
80106444:	89 e5                	mov    %esp,%ebp
80106446:	83 ec 08             	sub    $0x8,%esp
  procdump(); // Print a process listing to console.
80106449:	e8 86 e7 ff ff       	call   80104bd4 <procdump>
  return 0; 
8010644e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106453:	c9                   	leave  
80106454:	c3                   	ret    

80106455 <sys_set_priority>:

// New: Add in proyect 2: implementation of syscall set_priority
int
sys_set_priority(void){
80106455:	55                   	push   %ebp
80106456:	89 e5                	mov    %esp,%ebp
80106458:	83 ec 28             	sub    $0x28,%esp
  int pr;
  argint(0, &pr);
8010645b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010645e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106462:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106469:	e8 58 ee ff ff       	call   801052c6 <argint>
  proc->priority=pr;
8010646e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106474:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106477:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
8010647d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106482:	c9                   	leave  
80106483:	c3                   	ret    

80106484 <outb>:
{
80106484:	55                   	push   %ebp
80106485:	89 e5                	mov    %esp,%ebp
80106487:	83 ec 08             	sub    $0x8,%esp
8010648a:	8b 45 08             	mov    0x8(%ebp),%eax
8010648d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106490:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106494:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106497:	8a 45 f8             	mov    -0x8(%ebp),%al
8010649a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010649d:	ee                   	out    %al,(%dx)
}
8010649e:	c9                   	leave  
8010649f:	c3                   	ret    

801064a0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801064a6:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801064ad:	00 
801064ae:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801064b5:	e8 ca ff ff ff       	call   80106484 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801064ba:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801064c1:	00 
801064c2:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801064c9:	e8 b6 ff ff ff       	call   80106484 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801064ce:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801064d5:	00 
801064d6:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801064dd:	e8 a2 ff ff ff       	call   80106484 <outb>
  picenable(IRQ_TIMER);
801064e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064e9:	e8 b3 d5 ff ff       	call   80103aa1 <picenable>
}
801064ee:	c9                   	leave  
801064ef:	c3                   	ret    

801064f0 <alltraps>:
801064f0:	1e                   	push   %ds
801064f1:	06                   	push   %es
801064f2:	0f a0                	push   %fs
801064f4:	0f a8                	push   %gs
801064f6:	60                   	pusha  
801064f7:	66 b8 10 00          	mov    $0x10,%ax
801064fb:	8e d8                	mov    %eax,%ds
801064fd:	8e c0                	mov    %eax,%es
801064ff:	66 b8 18 00          	mov    $0x18,%ax
80106503:	8e e0                	mov    %eax,%fs
80106505:	8e e8                	mov    %eax,%gs
80106507:	54                   	push   %esp
80106508:	e8 c4 01 00 00       	call   801066d1 <trap>
8010650d:	83 c4 04             	add    $0x4,%esp

80106510 <trapret>:
80106510:	61                   	popa   
80106511:	0f a9                	pop    %gs
80106513:	0f a1                	pop    %fs
80106515:	07                   	pop    %es
80106516:	1f                   	pop    %ds
80106517:	83 c4 08             	add    $0x8,%esp
8010651a:	cf                   	iret   

8010651b <lidt>:
{
8010651b:	55                   	push   %ebp
8010651c:	89 e5                	mov    %esp,%ebp
8010651e:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106521:	8b 45 0c             	mov    0xc(%ebp),%eax
80106524:	48                   	dec    %eax
80106525:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106529:	8b 45 08             	mov    0x8(%ebp),%eax
8010652c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106530:	8b 45 08             	mov    0x8(%ebp),%eax
80106533:	c1 e8 10             	shr    $0x10,%eax
80106536:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010653a:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010653d:	0f 01 18             	lidtl  (%eax)
}
80106540:	c9                   	leave  
80106541:	c3                   	ret    

80106542 <rcr2>:

static inline uint
rcr2(void)
{
80106542:	55                   	push   %ebp
80106543:	89 e5                	mov    %esp,%ebp
80106545:	53                   	push   %ebx
80106546:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106549:	0f 20 d3             	mov    %cr2,%ebx
8010654c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
8010654f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106552:	83 c4 10             	add    $0x10,%esp
80106555:	5b                   	pop    %ebx
80106556:	5d                   	pop    %ebp
80106557:	c3                   	ret    

80106558 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106558:	55                   	push   %ebp
80106559:	89 e5                	mov    %esp,%ebp
8010655b:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010655e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106565:	e9 b8 00 00 00       	jmp    80106622 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010656a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656d:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
80106574:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106577:	66 89 04 d5 e0 21 11 	mov    %ax,-0x7feede20(,%edx,8)
8010657e:	80 
8010657f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106582:	66 c7 04 c5 e2 21 11 	movw   $0x8,-0x7feede1e(,%eax,8)
80106589:	80 08 00 
8010658c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658f:	8a 14 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%dl
80106596:	83 e2 e0             	and    $0xffffffe0,%edx
80106599:	88 14 c5 e4 21 11 80 	mov    %dl,-0x7feede1c(,%eax,8)
801065a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a3:	8a 14 c5 e4 21 11 80 	mov    -0x7feede1c(,%eax,8),%dl
801065aa:	83 e2 1f             	and    $0x1f,%edx
801065ad:	88 14 c5 e4 21 11 80 	mov    %dl,-0x7feede1c(,%eax,8)
801065b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b7:	8a 14 c5 e5 21 11 80 	mov    -0x7feede1b(,%eax,8),%dl
801065be:	83 e2 f0             	and    $0xfffffff0,%edx
801065c1:	83 ca 0e             	or     $0xe,%edx
801065c4:	88 14 c5 e5 21 11 80 	mov    %dl,-0x7feede1b(,%eax,8)
801065cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ce:	8a 14 c5 e5 21 11 80 	mov    -0x7feede1b(,%eax,8),%dl
801065d5:	83 e2 ef             	and    $0xffffffef,%edx
801065d8:	88 14 c5 e5 21 11 80 	mov    %dl,-0x7feede1b(,%eax,8)
801065df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e2:	8a 14 c5 e5 21 11 80 	mov    -0x7feede1b(,%eax,8),%dl
801065e9:	83 e2 9f             	and    $0xffffff9f,%edx
801065ec:	88 14 c5 e5 21 11 80 	mov    %dl,-0x7feede1b(,%eax,8)
801065f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065f6:	8a 14 c5 e5 21 11 80 	mov    -0x7feede1b(,%eax,8),%dl
801065fd:	83 ca 80             	or     $0xffffff80,%edx
80106600:	88 14 c5 e5 21 11 80 	mov    %dl,-0x7feede1b(,%eax,8)
80106607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660a:	8b 04 85 a8 b0 10 80 	mov    -0x7fef4f58(,%eax,4),%eax
80106611:	c1 e8 10             	shr    $0x10,%eax
80106614:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106617:	66 89 04 d5 e6 21 11 	mov    %ax,-0x7feede1a(,%edx,8)
8010661e:	80 
  for(i = 0; i < 256; i++)
8010661f:	ff 45 f4             	incl   -0xc(%ebp)
80106622:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106629:	0f 8e 3b ff ff ff    	jle    8010656a <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010662f:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
80106634:	66 a3 e0 23 11 80    	mov    %ax,0x801123e0
8010663a:	66 c7 05 e2 23 11 80 	movw   $0x8,0x801123e2
80106641:	08 00 
80106643:	a0 e4 23 11 80       	mov    0x801123e4,%al
80106648:	83 e0 e0             	and    $0xffffffe0,%eax
8010664b:	a2 e4 23 11 80       	mov    %al,0x801123e4
80106650:	a0 e4 23 11 80       	mov    0x801123e4,%al
80106655:	83 e0 1f             	and    $0x1f,%eax
80106658:	a2 e4 23 11 80       	mov    %al,0x801123e4
8010665d:	a0 e5 23 11 80       	mov    0x801123e5,%al
80106662:	83 c8 0f             	or     $0xf,%eax
80106665:	a2 e5 23 11 80       	mov    %al,0x801123e5
8010666a:	a0 e5 23 11 80       	mov    0x801123e5,%al
8010666f:	83 e0 ef             	and    $0xffffffef,%eax
80106672:	a2 e5 23 11 80       	mov    %al,0x801123e5
80106677:	a0 e5 23 11 80       	mov    0x801123e5,%al
8010667c:	83 c8 60             	or     $0x60,%eax
8010667f:	a2 e5 23 11 80       	mov    %al,0x801123e5
80106684:	a0 e5 23 11 80       	mov    0x801123e5,%al
80106689:	83 c8 80             	or     $0xffffff80,%eax
8010668c:	a2 e5 23 11 80       	mov    %al,0x801123e5
80106691:	a1 a8 b1 10 80       	mov    0x8010b1a8,%eax
80106696:	c1 e8 10             	shr    $0x10,%eax
80106699:	66 a3 e6 23 11 80    	mov    %ax,0x801123e6
  
  initlock(&tickslock, "time");
8010669f:	c7 44 24 04 98 88 10 	movl   $0x80108898,0x4(%esp)
801066a6:	80 
801066a7:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
801066ae:	e8 6f e6 ff ff       	call   80104d22 <initlock>
}
801066b3:	c9                   	leave  
801066b4:	c3                   	ret    

801066b5 <idtinit>:

void
idtinit(void)
{
801066b5:	55                   	push   %ebp
801066b6:	89 e5                	mov    %esp,%ebp
801066b8:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801066bb:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801066c2:	00 
801066c3:	c7 04 24 e0 21 11 80 	movl   $0x801121e0,(%esp)
801066ca:	e8 4c fe ff ff       	call   8010651b <lidt>
}
801066cf:	c9                   	leave  
801066d0:	c3                   	ret    

801066d1 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801066d1:	55                   	push   %ebp
801066d2:	89 e5                	mov    %esp,%ebp
801066d4:	57                   	push   %edi
801066d5:	56                   	push   %esi
801066d6:	53                   	push   %ebx
801066d7:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801066da:	8b 45 08             	mov    0x8(%ebp),%eax
801066dd:	8b 40 30             	mov    0x30(%eax),%eax
801066e0:	83 f8 40             	cmp    $0x40,%eax
801066e3:	75 3e                	jne    80106723 <trap+0x52>
    if(proc->killed)
801066e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066eb:	8b 40 24             	mov    0x24(%eax),%eax
801066ee:	85 c0                	test   %eax,%eax
801066f0:	74 05                	je     801066f7 <trap+0x26>
      exit();
801066f2:	e8 00 df ff ff       	call   801045f7 <exit>
    proc->tf = tf;
801066f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066fd:	8b 55 08             	mov    0x8(%ebp),%edx
80106700:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106703:	e8 85 ec ff ff       	call   8010538d <syscall>
    if(proc->killed)
80106708:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010670e:	8b 40 24             	mov    0x24(%eax),%eax
80106711:	85 c0                	test   %eax,%eax
80106713:	0f 84 3f 02 00 00    	je     80106958 <trap+0x287>
      exit();
80106719:	e8 d9 de ff ff       	call   801045f7 <exit>
    return;
8010671e:	e9 35 02 00 00       	jmp    80106958 <trap+0x287>
  }

  switch(tf->trapno){
80106723:	8b 45 08             	mov    0x8(%ebp),%eax
80106726:	8b 40 30             	mov    0x30(%eax),%eax
80106729:	83 e8 20             	sub    $0x20,%eax
8010672c:	83 f8 1f             	cmp    $0x1f,%eax
8010672f:	0f 87 b7 00 00 00    	ja     801067ec <trap+0x11b>
80106735:	8b 04 85 40 89 10 80 	mov    -0x7fef76c0(,%eax,4),%eax
8010673c:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
8010673e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106744:	8a 00                	mov    (%eax),%al
80106746:	84 c0                	test   %al,%al
80106748:	75 2f                	jne    80106779 <trap+0xa8>
      acquire(&tickslock);
8010674a:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
80106751:	e8 ed e5 ff ff       	call   80104d43 <acquire>
      ticks++;
80106756:	a1 e0 29 11 80       	mov    0x801129e0,%eax
8010675b:	40                   	inc    %eax
8010675c:	a3 e0 29 11 80       	mov    %eax,0x801129e0
      wakeup(&ticks);
80106761:	c7 04 24 e0 29 11 80 	movl   $0x801129e0,(%esp)
80106768:	e8 b8 e3 ff ff       	call   80104b25 <wakeup>
      release(&tickslock);
8010676d:	c7 04 24 a0 21 11 80 	movl   $0x801121a0,(%esp)
80106774:	e8 2c e6 ff ff       	call   80104da5 <release>
    }
    lapiceoi();
80106779:	e8 21 c7 ff ff       	call   80102e9f <lapiceoi>
    break;
8010677e:	e9 3c 01 00 00       	jmp    801068bf <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106783:	e8 35 bf ff ff       	call   801026bd <ideintr>
    lapiceoi();
80106788:	e8 12 c7 ff ff       	call   80102e9f <lapiceoi>
    break;
8010678d:	e9 2d 01 00 00       	jmp    801068bf <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106792:	e8 eb c4 ff ff       	call   80102c82 <kbdintr>
    lapiceoi();
80106797:	e8 03 c7 ff ff       	call   80102e9f <lapiceoi>
    break;
8010679c:	e9 1e 01 00 00       	jmp    801068bf <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801067a1:	e8 af 03 00 00       	call   80106b55 <uartintr>
    lapiceoi();
801067a6:	e8 f4 c6 ff ff       	call   80102e9f <lapiceoi>
    break;
801067ab:	e9 0f 01 00 00       	jmp    801068bf <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801067b0:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067b3:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801067b6:	8b 45 08             	mov    0x8(%ebp),%eax
801067b9:	8b 40 3c             	mov    0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067bc:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801067bf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801067c5:	8a 00                	mov    (%eax),%al
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067c7:	0f b6 c0             	movzbl %al,%eax
801067ca:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801067ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801067d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801067d6:	c7 04 24 a0 88 10 80 	movl   $0x801088a0,(%esp)
801067dd:	e8 bf 9b ff ff       	call   801003a1 <cprintf>
    lapiceoi();
801067e2:	e8 b8 c6 ff ff       	call   80102e9f <lapiceoi>
    break;
801067e7:	e9 d3 00 00 00       	jmp    801068bf <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801067ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067f2:	85 c0                	test   %eax,%eax
801067f4:	74 10                	je     80106806 <trap+0x135>
801067f6:	8b 45 08             	mov    0x8(%ebp),%eax
801067f9:	8b 40 3c             	mov    0x3c(%eax),%eax
801067fc:	0f b7 c0             	movzwl %ax,%eax
801067ff:	83 e0 03             	and    $0x3,%eax
80106802:	85 c0                	test   %eax,%eax
80106804:	75 45                	jne    8010684b <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106806:	e8 37 fd ff ff       	call   80106542 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
8010680b:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010680e:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106811:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106818:	8a 12                	mov    (%edx),%dl
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010681a:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010681d:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106820:	8b 52 30             	mov    0x30(%edx),%edx
80106823:	89 44 24 10          	mov    %eax,0x10(%esp)
80106827:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010682b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010682f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106833:	c7 04 24 c4 88 10 80 	movl   $0x801088c4,(%esp)
8010683a:	e8 62 9b ff ff       	call   801003a1 <cprintf>
      panic("trap");
8010683f:	c7 04 24 f6 88 10 80 	movl   $0x801088f6,(%esp)
80106846:	e8 eb 9c ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010684b:	e8 f2 fc ff ff       	call   80106542 <rcr2>
80106850:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106852:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106855:	8b 78 38             	mov    0x38(%eax),%edi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106858:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010685e:	8a 00                	mov    (%eax),%al
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106860:	0f b6 f0             	movzbl %al,%esi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106863:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106866:	8b 58 34             	mov    0x34(%eax),%ebx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106869:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010686c:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010686f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106875:	83 c0 6c             	add    $0x6c,%eax
80106878:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010687b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106881:	8b 40 10             	mov    0x10(%eax),%eax
80106884:	89 54 24 1c          	mov    %edx,0x1c(%esp)
80106888:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010688c:	89 74 24 14          	mov    %esi,0x14(%esp)
80106890:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106894:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106898:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010689b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010689f:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a3:	c7 04 24 fc 88 10 80 	movl   $0x801088fc,(%esp)
801068aa:	e8 f2 9a ff ff       	call   801003a1 <cprintf>
            rcr2());
    proc->killed = 1;
801068af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068b5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801068bc:	eb 01                	jmp    801068bf <trap+0x1ee>
    break;
801068be:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801068bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068c5:	85 c0                	test   %eax,%eax
801068c7:	74 23                	je     801068ec <trap+0x21b>
801068c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068cf:	8b 40 24             	mov    0x24(%eax),%eax
801068d2:	85 c0                	test   %eax,%eax
801068d4:	74 16                	je     801068ec <trap+0x21b>
801068d6:	8b 45 08             	mov    0x8(%ebp),%eax
801068d9:	8b 40 3c             	mov    0x3c(%eax),%eax
801068dc:	0f b7 c0             	movzwl %ax,%eax
801068df:	83 e0 03             	and    $0x3,%eax
801068e2:	83 f8 03             	cmp    $0x3,%eax
801068e5:	75 05                	jne    801068ec <trap+0x21b>
    exit();
801068e7:	e8 0b dd ff ff       	call   801045f7 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER && ++(proc->ticksProc) == QUANTUM) {
801068ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068f2:	85 c0                	test   %eax,%eax
801068f4:	74 33                	je     80106929 <trap+0x258>
801068f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801068fc:	8b 40 0c             	mov    0xc(%eax),%eax
801068ff:	83 f8 04             	cmp    $0x4,%eax
80106902:	75 25                	jne    80106929 <trap+0x258>
80106904:	8b 45 08             	mov    0x8(%ebp),%eax
80106907:	8b 40 30             	mov    0x30(%eax),%eax
8010690a:	83 f8 20             	cmp    $0x20,%eax
8010690d:	75 1a                	jne    80106929 <trap+0x258>
8010690f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106915:	8b 50 7c             	mov    0x7c(%eax),%edx
80106918:	42                   	inc    %edx
80106919:	89 50 7c             	mov    %edx,0x7c(%eax)
8010691c:	8b 40 7c             	mov    0x7c(%eax),%eax
8010691f:	83 f8 06             	cmp    $0x6,%eax
80106922:	75 05                	jne    80106929 <trap+0x258>
      // del proyecto 0
      // cprintf("tamaño del quantum: %d\n", QUANTUM);
      // cprintf("cantidad de ticks del proceso: %d\n", proc->ticksProc);
      // cprintf("nombre del proceso: %s\n", proc->name);
      // cprintf("abandone cpu\n");
      yield();
80106924:	e8 69 e0 ff ff       	call   80104992 <yield>
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106929:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010692f:	85 c0                	test   %eax,%eax
80106931:	74 26                	je     80106959 <trap+0x288>
80106933:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106939:	8b 40 24             	mov    0x24(%eax),%eax
8010693c:	85 c0                	test   %eax,%eax
8010693e:	74 19                	je     80106959 <trap+0x288>
80106940:	8b 45 08             	mov    0x8(%ebp),%eax
80106943:	8b 40 3c             	mov    0x3c(%eax),%eax
80106946:	0f b7 c0             	movzwl %ax,%eax
80106949:	83 e0 03             	and    $0x3,%eax
8010694c:	83 f8 03             	cmp    $0x3,%eax
8010694f:	75 08                	jne    80106959 <trap+0x288>
    exit();
80106951:	e8 a1 dc ff ff       	call   801045f7 <exit>
80106956:	eb 01                	jmp    80106959 <trap+0x288>
    return;
80106958:	90                   	nop
}
80106959:	83 c4 3c             	add    $0x3c,%esp
8010695c:	5b                   	pop    %ebx
8010695d:	5e                   	pop    %esi
8010695e:	5f                   	pop    %edi
8010695f:	5d                   	pop    %ebp
80106960:	c3                   	ret    

80106961 <inb>:
{
80106961:	55                   	push   %ebp
80106962:	89 e5                	mov    %esp,%ebp
80106964:	53                   	push   %ebx
80106965:	83 ec 14             	sub    $0x14,%esp
80106968:	8b 45 08             	mov    0x8(%ebp),%eax
8010696b:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010696f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106972:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106976:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
8010697a:	ec                   	in     (%dx),%al
8010697b:	88 c3                	mov    %al,%bl
8010697d:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106980:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80106983:	83 c4 14             	add    $0x14,%esp
80106986:	5b                   	pop    %ebx
80106987:	5d                   	pop    %ebp
80106988:	c3                   	ret    

80106989 <outb>:
{
80106989:	55                   	push   %ebp
8010698a:	89 e5                	mov    %esp,%ebp
8010698c:	83 ec 08             	sub    $0x8,%esp
8010698f:	8b 45 08             	mov    0x8(%ebp),%eax
80106992:	8b 55 0c             	mov    0xc(%ebp),%edx
80106995:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106999:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010699c:	8a 45 f8             	mov    -0x8(%ebp),%al
8010699f:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069a2:	ee                   	out    %al,(%dx)
}
801069a3:	c9                   	leave  
801069a4:	c3                   	ret    

801069a5 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801069a5:	55                   	push   %ebp
801069a6:	89 e5                	mov    %esp,%ebp
801069a8:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801069ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069b2:	00 
801069b3:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801069ba:	e8 ca ff ff ff       	call   80106989 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801069bf:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801069c6:	00 
801069c7:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801069ce:	e8 b6 ff ff ff       	call   80106989 <outb>
  outb(COM1+0, 115200/9600);
801069d3:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801069da:	00 
801069db:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801069e2:	e8 a2 ff ff ff       	call   80106989 <outb>
  outb(COM1+1, 0);
801069e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069ee:	00 
801069ef:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801069f6:	e8 8e ff ff ff       	call   80106989 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801069fb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106a02:	00 
80106a03:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106a0a:	e8 7a ff ff ff       	call   80106989 <outb>
  outb(COM1+4, 0);
80106a0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a16:	00 
80106a17:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106a1e:	e8 66 ff ff ff       	call   80106989 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106a23:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106a2a:	00 
80106a2b:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106a32:	e8 52 ff ff ff       	call   80106989 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106a37:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106a3e:	e8 1e ff ff ff       	call   80106961 <inb>
80106a43:	3c ff                	cmp    $0xff,%al
80106a45:	74 69                	je     80106ab0 <uartinit+0x10b>
    return;
  uart = 1;
80106a47:	c7 05 6c b6 10 80 01 	movl   $0x1,0x8010b66c
80106a4e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106a51:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106a58:	e8 04 ff ff ff       	call   80106961 <inb>
  inb(COM1+0);
80106a5d:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106a64:	e8 f8 fe ff ff       	call   80106961 <inb>
  picenable(IRQ_COM1);
80106a69:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106a70:	e8 2c d0 ff ff       	call   80103aa1 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106a75:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106a7c:	00 
80106a7d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106a84:	e8 b1 be ff ff       	call   8010293a <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106a89:	c7 45 f4 c0 89 10 80 	movl   $0x801089c0,-0xc(%ebp)
80106a90:	eb 13                	jmp    80106aa5 <uartinit+0x100>
    uartputc(*p);
80106a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a95:	8a 00                	mov    (%eax),%al
80106a97:	0f be c0             	movsbl %al,%eax
80106a9a:	89 04 24             	mov    %eax,(%esp)
80106a9d:	e8 11 00 00 00       	call   80106ab3 <uartputc>
  for(p="xv6...\n"; *p; p++)
80106aa2:	ff 45 f4             	incl   -0xc(%ebp)
80106aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106aa8:	8a 00                	mov    (%eax),%al
80106aaa:	84 c0                	test   %al,%al
80106aac:	75 e4                	jne    80106a92 <uartinit+0xed>
80106aae:	eb 01                	jmp    80106ab1 <uartinit+0x10c>
    return;
80106ab0:	90                   	nop
}
80106ab1:	c9                   	leave  
80106ab2:	c3                   	ret    

80106ab3 <uartputc>:

void
uartputc(int c)
{
80106ab3:	55                   	push   %ebp
80106ab4:	89 e5                	mov    %esp,%ebp
80106ab6:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106ab9:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106abe:	85 c0                	test   %eax,%eax
80106ac0:	74 4c                	je     80106b0e <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106ac9:	eb 0f                	jmp    80106ada <uartputc+0x27>
    microdelay(10);
80106acb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106ad2:	e8 ed c3 ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ad7:	ff 45 f4             	incl   -0xc(%ebp)
80106ada:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106ade:	7f 16                	jg     80106af6 <uartputc+0x43>
80106ae0:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ae7:	e8 75 fe ff ff       	call   80106961 <inb>
80106aec:	0f b6 c0             	movzbl %al,%eax
80106aef:	83 e0 20             	and    $0x20,%eax
80106af2:	85 c0                	test   %eax,%eax
80106af4:	74 d5                	je     80106acb <uartputc+0x18>
  outb(COM1+0, c);
80106af6:	8b 45 08             	mov    0x8(%ebp),%eax
80106af9:	0f b6 c0             	movzbl %al,%eax
80106afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b00:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b07:	e8 7d fe ff ff       	call   80106989 <outb>
80106b0c:	eb 01                	jmp    80106b0f <uartputc+0x5c>
    return;
80106b0e:	90                   	nop
}
80106b0f:	c9                   	leave  
80106b10:	c3                   	ret    

80106b11 <uartgetc>:

static int
uartgetc(void)
{
80106b11:	55                   	push   %ebp
80106b12:	89 e5                	mov    %esp,%ebp
80106b14:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106b17:	a1 6c b6 10 80       	mov    0x8010b66c,%eax
80106b1c:	85 c0                	test   %eax,%eax
80106b1e:	75 07                	jne    80106b27 <uartgetc+0x16>
    return -1;
80106b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b25:	eb 2c                	jmp    80106b53 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106b27:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b2e:	e8 2e fe ff ff       	call   80106961 <inb>
80106b33:	0f b6 c0             	movzbl %al,%eax
80106b36:	83 e0 01             	and    $0x1,%eax
80106b39:	85 c0                	test   %eax,%eax
80106b3b:	75 07                	jne    80106b44 <uartgetc+0x33>
    return -1;
80106b3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b42:	eb 0f                	jmp    80106b53 <uartgetc+0x42>
  return inb(COM1+0);
80106b44:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b4b:	e8 11 fe ff ff       	call   80106961 <inb>
80106b50:	0f b6 c0             	movzbl %al,%eax
}
80106b53:	c9                   	leave  
80106b54:	c3                   	ret    

80106b55 <uartintr>:

void
uartintr(void)
{
80106b55:	55                   	push   %ebp
80106b56:	89 e5                	mov    %esp,%ebp
80106b58:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106b5b:	c7 04 24 11 6b 10 80 	movl   $0x80106b11,(%esp)
80106b62:	e8 29 9c ff ff       	call   80100790 <consoleintr>
}
80106b67:	c9                   	leave  
80106b68:	c3                   	ret    

80106b69 <vector0>:
80106b69:	6a 00                	push   $0x0
80106b6b:	6a 00                	push   $0x0
80106b6d:	e9 7e f9 ff ff       	jmp    801064f0 <alltraps>

80106b72 <vector1>:
80106b72:	6a 00                	push   $0x0
80106b74:	6a 01                	push   $0x1
80106b76:	e9 75 f9 ff ff       	jmp    801064f0 <alltraps>

80106b7b <vector2>:
80106b7b:	6a 00                	push   $0x0
80106b7d:	6a 02                	push   $0x2
80106b7f:	e9 6c f9 ff ff       	jmp    801064f0 <alltraps>

80106b84 <vector3>:
80106b84:	6a 00                	push   $0x0
80106b86:	6a 03                	push   $0x3
80106b88:	e9 63 f9 ff ff       	jmp    801064f0 <alltraps>

80106b8d <vector4>:
80106b8d:	6a 00                	push   $0x0
80106b8f:	6a 04                	push   $0x4
80106b91:	e9 5a f9 ff ff       	jmp    801064f0 <alltraps>

80106b96 <vector5>:
80106b96:	6a 00                	push   $0x0
80106b98:	6a 05                	push   $0x5
80106b9a:	e9 51 f9 ff ff       	jmp    801064f0 <alltraps>

80106b9f <vector6>:
80106b9f:	6a 00                	push   $0x0
80106ba1:	6a 06                	push   $0x6
80106ba3:	e9 48 f9 ff ff       	jmp    801064f0 <alltraps>

80106ba8 <vector7>:
80106ba8:	6a 00                	push   $0x0
80106baa:	6a 07                	push   $0x7
80106bac:	e9 3f f9 ff ff       	jmp    801064f0 <alltraps>

80106bb1 <vector8>:
80106bb1:	6a 08                	push   $0x8
80106bb3:	e9 38 f9 ff ff       	jmp    801064f0 <alltraps>

80106bb8 <vector9>:
80106bb8:	6a 00                	push   $0x0
80106bba:	6a 09                	push   $0x9
80106bbc:	e9 2f f9 ff ff       	jmp    801064f0 <alltraps>

80106bc1 <vector10>:
80106bc1:	6a 0a                	push   $0xa
80106bc3:	e9 28 f9 ff ff       	jmp    801064f0 <alltraps>

80106bc8 <vector11>:
80106bc8:	6a 0b                	push   $0xb
80106bca:	e9 21 f9 ff ff       	jmp    801064f0 <alltraps>

80106bcf <vector12>:
80106bcf:	6a 0c                	push   $0xc
80106bd1:	e9 1a f9 ff ff       	jmp    801064f0 <alltraps>

80106bd6 <vector13>:
80106bd6:	6a 0d                	push   $0xd
80106bd8:	e9 13 f9 ff ff       	jmp    801064f0 <alltraps>

80106bdd <vector14>:
80106bdd:	6a 0e                	push   $0xe
80106bdf:	e9 0c f9 ff ff       	jmp    801064f0 <alltraps>

80106be4 <vector15>:
80106be4:	6a 00                	push   $0x0
80106be6:	6a 0f                	push   $0xf
80106be8:	e9 03 f9 ff ff       	jmp    801064f0 <alltraps>

80106bed <vector16>:
80106bed:	6a 00                	push   $0x0
80106bef:	6a 10                	push   $0x10
80106bf1:	e9 fa f8 ff ff       	jmp    801064f0 <alltraps>

80106bf6 <vector17>:
80106bf6:	6a 11                	push   $0x11
80106bf8:	e9 f3 f8 ff ff       	jmp    801064f0 <alltraps>

80106bfd <vector18>:
80106bfd:	6a 00                	push   $0x0
80106bff:	6a 12                	push   $0x12
80106c01:	e9 ea f8 ff ff       	jmp    801064f0 <alltraps>

80106c06 <vector19>:
80106c06:	6a 00                	push   $0x0
80106c08:	6a 13                	push   $0x13
80106c0a:	e9 e1 f8 ff ff       	jmp    801064f0 <alltraps>

80106c0f <vector20>:
80106c0f:	6a 00                	push   $0x0
80106c11:	6a 14                	push   $0x14
80106c13:	e9 d8 f8 ff ff       	jmp    801064f0 <alltraps>

80106c18 <vector21>:
80106c18:	6a 00                	push   $0x0
80106c1a:	6a 15                	push   $0x15
80106c1c:	e9 cf f8 ff ff       	jmp    801064f0 <alltraps>

80106c21 <vector22>:
80106c21:	6a 00                	push   $0x0
80106c23:	6a 16                	push   $0x16
80106c25:	e9 c6 f8 ff ff       	jmp    801064f0 <alltraps>

80106c2a <vector23>:
80106c2a:	6a 00                	push   $0x0
80106c2c:	6a 17                	push   $0x17
80106c2e:	e9 bd f8 ff ff       	jmp    801064f0 <alltraps>

80106c33 <vector24>:
80106c33:	6a 00                	push   $0x0
80106c35:	6a 18                	push   $0x18
80106c37:	e9 b4 f8 ff ff       	jmp    801064f0 <alltraps>

80106c3c <vector25>:
80106c3c:	6a 00                	push   $0x0
80106c3e:	6a 19                	push   $0x19
80106c40:	e9 ab f8 ff ff       	jmp    801064f0 <alltraps>

80106c45 <vector26>:
80106c45:	6a 00                	push   $0x0
80106c47:	6a 1a                	push   $0x1a
80106c49:	e9 a2 f8 ff ff       	jmp    801064f0 <alltraps>

80106c4e <vector27>:
80106c4e:	6a 00                	push   $0x0
80106c50:	6a 1b                	push   $0x1b
80106c52:	e9 99 f8 ff ff       	jmp    801064f0 <alltraps>

80106c57 <vector28>:
80106c57:	6a 00                	push   $0x0
80106c59:	6a 1c                	push   $0x1c
80106c5b:	e9 90 f8 ff ff       	jmp    801064f0 <alltraps>

80106c60 <vector29>:
80106c60:	6a 00                	push   $0x0
80106c62:	6a 1d                	push   $0x1d
80106c64:	e9 87 f8 ff ff       	jmp    801064f0 <alltraps>

80106c69 <vector30>:
80106c69:	6a 00                	push   $0x0
80106c6b:	6a 1e                	push   $0x1e
80106c6d:	e9 7e f8 ff ff       	jmp    801064f0 <alltraps>

80106c72 <vector31>:
80106c72:	6a 00                	push   $0x0
80106c74:	6a 1f                	push   $0x1f
80106c76:	e9 75 f8 ff ff       	jmp    801064f0 <alltraps>

80106c7b <vector32>:
80106c7b:	6a 00                	push   $0x0
80106c7d:	6a 20                	push   $0x20
80106c7f:	e9 6c f8 ff ff       	jmp    801064f0 <alltraps>

80106c84 <vector33>:
80106c84:	6a 00                	push   $0x0
80106c86:	6a 21                	push   $0x21
80106c88:	e9 63 f8 ff ff       	jmp    801064f0 <alltraps>

80106c8d <vector34>:
80106c8d:	6a 00                	push   $0x0
80106c8f:	6a 22                	push   $0x22
80106c91:	e9 5a f8 ff ff       	jmp    801064f0 <alltraps>

80106c96 <vector35>:
80106c96:	6a 00                	push   $0x0
80106c98:	6a 23                	push   $0x23
80106c9a:	e9 51 f8 ff ff       	jmp    801064f0 <alltraps>

80106c9f <vector36>:
80106c9f:	6a 00                	push   $0x0
80106ca1:	6a 24                	push   $0x24
80106ca3:	e9 48 f8 ff ff       	jmp    801064f0 <alltraps>

80106ca8 <vector37>:
80106ca8:	6a 00                	push   $0x0
80106caa:	6a 25                	push   $0x25
80106cac:	e9 3f f8 ff ff       	jmp    801064f0 <alltraps>

80106cb1 <vector38>:
80106cb1:	6a 00                	push   $0x0
80106cb3:	6a 26                	push   $0x26
80106cb5:	e9 36 f8 ff ff       	jmp    801064f0 <alltraps>

80106cba <vector39>:
80106cba:	6a 00                	push   $0x0
80106cbc:	6a 27                	push   $0x27
80106cbe:	e9 2d f8 ff ff       	jmp    801064f0 <alltraps>

80106cc3 <vector40>:
80106cc3:	6a 00                	push   $0x0
80106cc5:	6a 28                	push   $0x28
80106cc7:	e9 24 f8 ff ff       	jmp    801064f0 <alltraps>

80106ccc <vector41>:
80106ccc:	6a 00                	push   $0x0
80106cce:	6a 29                	push   $0x29
80106cd0:	e9 1b f8 ff ff       	jmp    801064f0 <alltraps>

80106cd5 <vector42>:
80106cd5:	6a 00                	push   $0x0
80106cd7:	6a 2a                	push   $0x2a
80106cd9:	e9 12 f8 ff ff       	jmp    801064f0 <alltraps>

80106cde <vector43>:
80106cde:	6a 00                	push   $0x0
80106ce0:	6a 2b                	push   $0x2b
80106ce2:	e9 09 f8 ff ff       	jmp    801064f0 <alltraps>

80106ce7 <vector44>:
80106ce7:	6a 00                	push   $0x0
80106ce9:	6a 2c                	push   $0x2c
80106ceb:	e9 00 f8 ff ff       	jmp    801064f0 <alltraps>

80106cf0 <vector45>:
80106cf0:	6a 00                	push   $0x0
80106cf2:	6a 2d                	push   $0x2d
80106cf4:	e9 f7 f7 ff ff       	jmp    801064f0 <alltraps>

80106cf9 <vector46>:
80106cf9:	6a 00                	push   $0x0
80106cfb:	6a 2e                	push   $0x2e
80106cfd:	e9 ee f7 ff ff       	jmp    801064f0 <alltraps>

80106d02 <vector47>:
80106d02:	6a 00                	push   $0x0
80106d04:	6a 2f                	push   $0x2f
80106d06:	e9 e5 f7 ff ff       	jmp    801064f0 <alltraps>

80106d0b <vector48>:
80106d0b:	6a 00                	push   $0x0
80106d0d:	6a 30                	push   $0x30
80106d0f:	e9 dc f7 ff ff       	jmp    801064f0 <alltraps>

80106d14 <vector49>:
80106d14:	6a 00                	push   $0x0
80106d16:	6a 31                	push   $0x31
80106d18:	e9 d3 f7 ff ff       	jmp    801064f0 <alltraps>

80106d1d <vector50>:
80106d1d:	6a 00                	push   $0x0
80106d1f:	6a 32                	push   $0x32
80106d21:	e9 ca f7 ff ff       	jmp    801064f0 <alltraps>

80106d26 <vector51>:
80106d26:	6a 00                	push   $0x0
80106d28:	6a 33                	push   $0x33
80106d2a:	e9 c1 f7 ff ff       	jmp    801064f0 <alltraps>

80106d2f <vector52>:
80106d2f:	6a 00                	push   $0x0
80106d31:	6a 34                	push   $0x34
80106d33:	e9 b8 f7 ff ff       	jmp    801064f0 <alltraps>

80106d38 <vector53>:
80106d38:	6a 00                	push   $0x0
80106d3a:	6a 35                	push   $0x35
80106d3c:	e9 af f7 ff ff       	jmp    801064f0 <alltraps>

80106d41 <vector54>:
80106d41:	6a 00                	push   $0x0
80106d43:	6a 36                	push   $0x36
80106d45:	e9 a6 f7 ff ff       	jmp    801064f0 <alltraps>

80106d4a <vector55>:
80106d4a:	6a 00                	push   $0x0
80106d4c:	6a 37                	push   $0x37
80106d4e:	e9 9d f7 ff ff       	jmp    801064f0 <alltraps>

80106d53 <vector56>:
80106d53:	6a 00                	push   $0x0
80106d55:	6a 38                	push   $0x38
80106d57:	e9 94 f7 ff ff       	jmp    801064f0 <alltraps>

80106d5c <vector57>:
80106d5c:	6a 00                	push   $0x0
80106d5e:	6a 39                	push   $0x39
80106d60:	e9 8b f7 ff ff       	jmp    801064f0 <alltraps>

80106d65 <vector58>:
80106d65:	6a 00                	push   $0x0
80106d67:	6a 3a                	push   $0x3a
80106d69:	e9 82 f7 ff ff       	jmp    801064f0 <alltraps>

80106d6e <vector59>:
80106d6e:	6a 00                	push   $0x0
80106d70:	6a 3b                	push   $0x3b
80106d72:	e9 79 f7 ff ff       	jmp    801064f0 <alltraps>

80106d77 <vector60>:
80106d77:	6a 00                	push   $0x0
80106d79:	6a 3c                	push   $0x3c
80106d7b:	e9 70 f7 ff ff       	jmp    801064f0 <alltraps>

80106d80 <vector61>:
80106d80:	6a 00                	push   $0x0
80106d82:	6a 3d                	push   $0x3d
80106d84:	e9 67 f7 ff ff       	jmp    801064f0 <alltraps>

80106d89 <vector62>:
80106d89:	6a 00                	push   $0x0
80106d8b:	6a 3e                	push   $0x3e
80106d8d:	e9 5e f7 ff ff       	jmp    801064f0 <alltraps>

80106d92 <vector63>:
80106d92:	6a 00                	push   $0x0
80106d94:	6a 3f                	push   $0x3f
80106d96:	e9 55 f7 ff ff       	jmp    801064f0 <alltraps>

80106d9b <vector64>:
80106d9b:	6a 00                	push   $0x0
80106d9d:	6a 40                	push   $0x40
80106d9f:	e9 4c f7 ff ff       	jmp    801064f0 <alltraps>

80106da4 <vector65>:
80106da4:	6a 00                	push   $0x0
80106da6:	6a 41                	push   $0x41
80106da8:	e9 43 f7 ff ff       	jmp    801064f0 <alltraps>

80106dad <vector66>:
80106dad:	6a 00                	push   $0x0
80106daf:	6a 42                	push   $0x42
80106db1:	e9 3a f7 ff ff       	jmp    801064f0 <alltraps>

80106db6 <vector67>:
80106db6:	6a 00                	push   $0x0
80106db8:	6a 43                	push   $0x43
80106dba:	e9 31 f7 ff ff       	jmp    801064f0 <alltraps>

80106dbf <vector68>:
80106dbf:	6a 00                	push   $0x0
80106dc1:	6a 44                	push   $0x44
80106dc3:	e9 28 f7 ff ff       	jmp    801064f0 <alltraps>

80106dc8 <vector69>:
80106dc8:	6a 00                	push   $0x0
80106dca:	6a 45                	push   $0x45
80106dcc:	e9 1f f7 ff ff       	jmp    801064f0 <alltraps>

80106dd1 <vector70>:
80106dd1:	6a 00                	push   $0x0
80106dd3:	6a 46                	push   $0x46
80106dd5:	e9 16 f7 ff ff       	jmp    801064f0 <alltraps>

80106dda <vector71>:
80106dda:	6a 00                	push   $0x0
80106ddc:	6a 47                	push   $0x47
80106dde:	e9 0d f7 ff ff       	jmp    801064f0 <alltraps>

80106de3 <vector72>:
80106de3:	6a 00                	push   $0x0
80106de5:	6a 48                	push   $0x48
80106de7:	e9 04 f7 ff ff       	jmp    801064f0 <alltraps>

80106dec <vector73>:
80106dec:	6a 00                	push   $0x0
80106dee:	6a 49                	push   $0x49
80106df0:	e9 fb f6 ff ff       	jmp    801064f0 <alltraps>

80106df5 <vector74>:
80106df5:	6a 00                	push   $0x0
80106df7:	6a 4a                	push   $0x4a
80106df9:	e9 f2 f6 ff ff       	jmp    801064f0 <alltraps>

80106dfe <vector75>:
80106dfe:	6a 00                	push   $0x0
80106e00:	6a 4b                	push   $0x4b
80106e02:	e9 e9 f6 ff ff       	jmp    801064f0 <alltraps>

80106e07 <vector76>:
80106e07:	6a 00                	push   $0x0
80106e09:	6a 4c                	push   $0x4c
80106e0b:	e9 e0 f6 ff ff       	jmp    801064f0 <alltraps>

80106e10 <vector77>:
80106e10:	6a 00                	push   $0x0
80106e12:	6a 4d                	push   $0x4d
80106e14:	e9 d7 f6 ff ff       	jmp    801064f0 <alltraps>

80106e19 <vector78>:
80106e19:	6a 00                	push   $0x0
80106e1b:	6a 4e                	push   $0x4e
80106e1d:	e9 ce f6 ff ff       	jmp    801064f0 <alltraps>

80106e22 <vector79>:
80106e22:	6a 00                	push   $0x0
80106e24:	6a 4f                	push   $0x4f
80106e26:	e9 c5 f6 ff ff       	jmp    801064f0 <alltraps>

80106e2b <vector80>:
80106e2b:	6a 00                	push   $0x0
80106e2d:	6a 50                	push   $0x50
80106e2f:	e9 bc f6 ff ff       	jmp    801064f0 <alltraps>

80106e34 <vector81>:
80106e34:	6a 00                	push   $0x0
80106e36:	6a 51                	push   $0x51
80106e38:	e9 b3 f6 ff ff       	jmp    801064f0 <alltraps>

80106e3d <vector82>:
80106e3d:	6a 00                	push   $0x0
80106e3f:	6a 52                	push   $0x52
80106e41:	e9 aa f6 ff ff       	jmp    801064f0 <alltraps>

80106e46 <vector83>:
80106e46:	6a 00                	push   $0x0
80106e48:	6a 53                	push   $0x53
80106e4a:	e9 a1 f6 ff ff       	jmp    801064f0 <alltraps>

80106e4f <vector84>:
80106e4f:	6a 00                	push   $0x0
80106e51:	6a 54                	push   $0x54
80106e53:	e9 98 f6 ff ff       	jmp    801064f0 <alltraps>

80106e58 <vector85>:
80106e58:	6a 00                	push   $0x0
80106e5a:	6a 55                	push   $0x55
80106e5c:	e9 8f f6 ff ff       	jmp    801064f0 <alltraps>

80106e61 <vector86>:
80106e61:	6a 00                	push   $0x0
80106e63:	6a 56                	push   $0x56
80106e65:	e9 86 f6 ff ff       	jmp    801064f0 <alltraps>

80106e6a <vector87>:
80106e6a:	6a 00                	push   $0x0
80106e6c:	6a 57                	push   $0x57
80106e6e:	e9 7d f6 ff ff       	jmp    801064f0 <alltraps>

80106e73 <vector88>:
80106e73:	6a 00                	push   $0x0
80106e75:	6a 58                	push   $0x58
80106e77:	e9 74 f6 ff ff       	jmp    801064f0 <alltraps>

80106e7c <vector89>:
80106e7c:	6a 00                	push   $0x0
80106e7e:	6a 59                	push   $0x59
80106e80:	e9 6b f6 ff ff       	jmp    801064f0 <alltraps>

80106e85 <vector90>:
80106e85:	6a 00                	push   $0x0
80106e87:	6a 5a                	push   $0x5a
80106e89:	e9 62 f6 ff ff       	jmp    801064f0 <alltraps>

80106e8e <vector91>:
80106e8e:	6a 00                	push   $0x0
80106e90:	6a 5b                	push   $0x5b
80106e92:	e9 59 f6 ff ff       	jmp    801064f0 <alltraps>

80106e97 <vector92>:
80106e97:	6a 00                	push   $0x0
80106e99:	6a 5c                	push   $0x5c
80106e9b:	e9 50 f6 ff ff       	jmp    801064f0 <alltraps>

80106ea0 <vector93>:
80106ea0:	6a 00                	push   $0x0
80106ea2:	6a 5d                	push   $0x5d
80106ea4:	e9 47 f6 ff ff       	jmp    801064f0 <alltraps>

80106ea9 <vector94>:
80106ea9:	6a 00                	push   $0x0
80106eab:	6a 5e                	push   $0x5e
80106ead:	e9 3e f6 ff ff       	jmp    801064f0 <alltraps>

80106eb2 <vector95>:
80106eb2:	6a 00                	push   $0x0
80106eb4:	6a 5f                	push   $0x5f
80106eb6:	e9 35 f6 ff ff       	jmp    801064f0 <alltraps>

80106ebb <vector96>:
80106ebb:	6a 00                	push   $0x0
80106ebd:	6a 60                	push   $0x60
80106ebf:	e9 2c f6 ff ff       	jmp    801064f0 <alltraps>

80106ec4 <vector97>:
80106ec4:	6a 00                	push   $0x0
80106ec6:	6a 61                	push   $0x61
80106ec8:	e9 23 f6 ff ff       	jmp    801064f0 <alltraps>

80106ecd <vector98>:
80106ecd:	6a 00                	push   $0x0
80106ecf:	6a 62                	push   $0x62
80106ed1:	e9 1a f6 ff ff       	jmp    801064f0 <alltraps>

80106ed6 <vector99>:
80106ed6:	6a 00                	push   $0x0
80106ed8:	6a 63                	push   $0x63
80106eda:	e9 11 f6 ff ff       	jmp    801064f0 <alltraps>

80106edf <vector100>:
80106edf:	6a 00                	push   $0x0
80106ee1:	6a 64                	push   $0x64
80106ee3:	e9 08 f6 ff ff       	jmp    801064f0 <alltraps>

80106ee8 <vector101>:
80106ee8:	6a 00                	push   $0x0
80106eea:	6a 65                	push   $0x65
80106eec:	e9 ff f5 ff ff       	jmp    801064f0 <alltraps>

80106ef1 <vector102>:
80106ef1:	6a 00                	push   $0x0
80106ef3:	6a 66                	push   $0x66
80106ef5:	e9 f6 f5 ff ff       	jmp    801064f0 <alltraps>

80106efa <vector103>:
80106efa:	6a 00                	push   $0x0
80106efc:	6a 67                	push   $0x67
80106efe:	e9 ed f5 ff ff       	jmp    801064f0 <alltraps>

80106f03 <vector104>:
80106f03:	6a 00                	push   $0x0
80106f05:	6a 68                	push   $0x68
80106f07:	e9 e4 f5 ff ff       	jmp    801064f0 <alltraps>

80106f0c <vector105>:
80106f0c:	6a 00                	push   $0x0
80106f0e:	6a 69                	push   $0x69
80106f10:	e9 db f5 ff ff       	jmp    801064f0 <alltraps>

80106f15 <vector106>:
80106f15:	6a 00                	push   $0x0
80106f17:	6a 6a                	push   $0x6a
80106f19:	e9 d2 f5 ff ff       	jmp    801064f0 <alltraps>

80106f1e <vector107>:
80106f1e:	6a 00                	push   $0x0
80106f20:	6a 6b                	push   $0x6b
80106f22:	e9 c9 f5 ff ff       	jmp    801064f0 <alltraps>

80106f27 <vector108>:
80106f27:	6a 00                	push   $0x0
80106f29:	6a 6c                	push   $0x6c
80106f2b:	e9 c0 f5 ff ff       	jmp    801064f0 <alltraps>

80106f30 <vector109>:
80106f30:	6a 00                	push   $0x0
80106f32:	6a 6d                	push   $0x6d
80106f34:	e9 b7 f5 ff ff       	jmp    801064f0 <alltraps>

80106f39 <vector110>:
80106f39:	6a 00                	push   $0x0
80106f3b:	6a 6e                	push   $0x6e
80106f3d:	e9 ae f5 ff ff       	jmp    801064f0 <alltraps>

80106f42 <vector111>:
80106f42:	6a 00                	push   $0x0
80106f44:	6a 6f                	push   $0x6f
80106f46:	e9 a5 f5 ff ff       	jmp    801064f0 <alltraps>

80106f4b <vector112>:
80106f4b:	6a 00                	push   $0x0
80106f4d:	6a 70                	push   $0x70
80106f4f:	e9 9c f5 ff ff       	jmp    801064f0 <alltraps>

80106f54 <vector113>:
80106f54:	6a 00                	push   $0x0
80106f56:	6a 71                	push   $0x71
80106f58:	e9 93 f5 ff ff       	jmp    801064f0 <alltraps>

80106f5d <vector114>:
80106f5d:	6a 00                	push   $0x0
80106f5f:	6a 72                	push   $0x72
80106f61:	e9 8a f5 ff ff       	jmp    801064f0 <alltraps>

80106f66 <vector115>:
80106f66:	6a 00                	push   $0x0
80106f68:	6a 73                	push   $0x73
80106f6a:	e9 81 f5 ff ff       	jmp    801064f0 <alltraps>

80106f6f <vector116>:
80106f6f:	6a 00                	push   $0x0
80106f71:	6a 74                	push   $0x74
80106f73:	e9 78 f5 ff ff       	jmp    801064f0 <alltraps>

80106f78 <vector117>:
80106f78:	6a 00                	push   $0x0
80106f7a:	6a 75                	push   $0x75
80106f7c:	e9 6f f5 ff ff       	jmp    801064f0 <alltraps>

80106f81 <vector118>:
80106f81:	6a 00                	push   $0x0
80106f83:	6a 76                	push   $0x76
80106f85:	e9 66 f5 ff ff       	jmp    801064f0 <alltraps>

80106f8a <vector119>:
80106f8a:	6a 00                	push   $0x0
80106f8c:	6a 77                	push   $0x77
80106f8e:	e9 5d f5 ff ff       	jmp    801064f0 <alltraps>

80106f93 <vector120>:
80106f93:	6a 00                	push   $0x0
80106f95:	6a 78                	push   $0x78
80106f97:	e9 54 f5 ff ff       	jmp    801064f0 <alltraps>

80106f9c <vector121>:
80106f9c:	6a 00                	push   $0x0
80106f9e:	6a 79                	push   $0x79
80106fa0:	e9 4b f5 ff ff       	jmp    801064f0 <alltraps>

80106fa5 <vector122>:
80106fa5:	6a 00                	push   $0x0
80106fa7:	6a 7a                	push   $0x7a
80106fa9:	e9 42 f5 ff ff       	jmp    801064f0 <alltraps>

80106fae <vector123>:
80106fae:	6a 00                	push   $0x0
80106fb0:	6a 7b                	push   $0x7b
80106fb2:	e9 39 f5 ff ff       	jmp    801064f0 <alltraps>

80106fb7 <vector124>:
80106fb7:	6a 00                	push   $0x0
80106fb9:	6a 7c                	push   $0x7c
80106fbb:	e9 30 f5 ff ff       	jmp    801064f0 <alltraps>

80106fc0 <vector125>:
80106fc0:	6a 00                	push   $0x0
80106fc2:	6a 7d                	push   $0x7d
80106fc4:	e9 27 f5 ff ff       	jmp    801064f0 <alltraps>

80106fc9 <vector126>:
80106fc9:	6a 00                	push   $0x0
80106fcb:	6a 7e                	push   $0x7e
80106fcd:	e9 1e f5 ff ff       	jmp    801064f0 <alltraps>

80106fd2 <vector127>:
80106fd2:	6a 00                	push   $0x0
80106fd4:	6a 7f                	push   $0x7f
80106fd6:	e9 15 f5 ff ff       	jmp    801064f0 <alltraps>

80106fdb <vector128>:
80106fdb:	6a 00                	push   $0x0
80106fdd:	68 80 00 00 00       	push   $0x80
80106fe2:	e9 09 f5 ff ff       	jmp    801064f0 <alltraps>

80106fe7 <vector129>:
80106fe7:	6a 00                	push   $0x0
80106fe9:	68 81 00 00 00       	push   $0x81
80106fee:	e9 fd f4 ff ff       	jmp    801064f0 <alltraps>

80106ff3 <vector130>:
80106ff3:	6a 00                	push   $0x0
80106ff5:	68 82 00 00 00       	push   $0x82
80106ffa:	e9 f1 f4 ff ff       	jmp    801064f0 <alltraps>

80106fff <vector131>:
80106fff:	6a 00                	push   $0x0
80107001:	68 83 00 00 00       	push   $0x83
80107006:	e9 e5 f4 ff ff       	jmp    801064f0 <alltraps>

8010700b <vector132>:
8010700b:	6a 00                	push   $0x0
8010700d:	68 84 00 00 00       	push   $0x84
80107012:	e9 d9 f4 ff ff       	jmp    801064f0 <alltraps>

80107017 <vector133>:
80107017:	6a 00                	push   $0x0
80107019:	68 85 00 00 00       	push   $0x85
8010701e:	e9 cd f4 ff ff       	jmp    801064f0 <alltraps>

80107023 <vector134>:
80107023:	6a 00                	push   $0x0
80107025:	68 86 00 00 00       	push   $0x86
8010702a:	e9 c1 f4 ff ff       	jmp    801064f0 <alltraps>

8010702f <vector135>:
8010702f:	6a 00                	push   $0x0
80107031:	68 87 00 00 00       	push   $0x87
80107036:	e9 b5 f4 ff ff       	jmp    801064f0 <alltraps>

8010703b <vector136>:
8010703b:	6a 00                	push   $0x0
8010703d:	68 88 00 00 00       	push   $0x88
80107042:	e9 a9 f4 ff ff       	jmp    801064f0 <alltraps>

80107047 <vector137>:
80107047:	6a 00                	push   $0x0
80107049:	68 89 00 00 00       	push   $0x89
8010704e:	e9 9d f4 ff ff       	jmp    801064f0 <alltraps>

80107053 <vector138>:
80107053:	6a 00                	push   $0x0
80107055:	68 8a 00 00 00       	push   $0x8a
8010705a:	e9 91 f4 ff ff       	jmp    801064f0 <alltraps>

8010705f <vector139>:
8010705f:	6a 00                	push   $0x0
80107061:	68 8b 00 00 00       	push   $0x8b
80107066:	e9 85 f4 ff ff       	jmp    801064f0 <alltraps>

8010706b <vector140>:
8010706b:	6a 00                	push   $0x0
8010706d:	68 8c 00 00 00       	push   $0x8c
80107072:	e9 79 f4 ff ff       	jmp    801064f0 <alltraps>

80107077 <vector141>:
80107077:	6a 00                	push   $0x0
80107079:	68 8d 00 00 00       	push   $0x8d
8010707e:	e9 6d f4 ff ff       	jmp    801064f0 <alltraps>

80107083 <vector142>:
80107083:	6a 00                	push   $0x0
80107085:	68 8e 00 00 00       	push   $0x8e
8010708a:	e9 61 f4 ff ff       	jmp    801064f0 <alltraps>

8010708f <vector143>:
8010708f:	6a 00                	push   $0x0
80107091:	68 8f 00 00 00       	push   $0x8f
80107096:	e9 55 f4 ff ff       	jmp    801064f0 <alltraps>

8010709b <vector144>:
8010709b:	6a 00                	push   $0x0
8010709d:	68 90 00 00 00       	push   $0x90
801070a2:	e9 49 f4 ff ff       	jmp    801064f0 <alltraps>

801070a7 <vector145>:
801070a7:	6a 00                	push   $0x0
801070a9:	68 91 00 00 00       	push   $0x91
801070ae:	e9 3d f4 ff ff       	jmp    801064f0 <alltraps>

801070b3 <vector146>:
801070b3:	6a 00                	push   $0x0
801070b5:	68 92 00 00 00       	push   $0x92
801070ba:	e9 31 f4 ff ff       	jmp    801064f0 <alltraps>

801070bf <vector147>:
801070bf:	6a 00                	push   $0x0
801070c1:	68 93 00 00 00       	push   $0x93
801070c6:	e9 25 f4 ff ff       	jmp    801064f0 <alltraps>

801070cb <vector148>:
801070cb:	6a 00                	push   $0x0
801070cd:	68 94 00 00 00       	push   $0x94
801070d2:	e9 19 f4 ff ff       	jmp    801064f0 <alltraps>

801070d7 <vector149>:
801070d7:	6a 00                	push   $0x0
801070d9:	68 95 00 00 00       	push   $0x95
801070de:	e9 0d f4 ff ff       	jmp    801064f0 <alltraps>

801070e3 <vector150>:
801070e3:	6a 00                	push   $0x0
801070e5:	68 96 00 00 00       	push   $0x96
801070ea:	e9 01 f4 ff ff       	jmp    801064f0 <alltraps>

801070ef <vector151>:
801070ef:	6a 00                	push   $0x0
801070f1:	68 97 00 00 00       	push   $0x97
801070f6:	e9 f5 f3 ff ff       	jmp    801064f0 <alltraps>

801070fb <vector152>:
801070fb:	6a 00                	push   $0x0
801070fd:	68 98 00 00 00       	push   $0x98
80107102:	e9 e9 f3 ff ff       	jmp    801064f0 <alltraps>

80107107 <vector153>:
80107107:	6a 00                	push   $0x0
80107109:	68 99 00 00 00       	push   $0x99
8010710e:	e9 dd f3 ff ff       	jmp    801064f0 <alltraps>

80107113 <vector154>:
80107113:	6a 00                	push   $0x0
80107115:	68 9a 00 00 00       	push   $0x9a
8010711a:	e9 d1 f3 ff ff       	jmp    801064f0 <alltraps>

8010711f <vector155>:
8010711f:	6a 00                	push   $0x0
80107121:	68 9b 00 00 00       	push   $0x9b
80107126:	e9 c5 f3 ff ff       	jmp    801064f0 <alltraps>

8010712b <vector156>:
8010712b:	6a 00                	push   $0x0
8010712d:	68 9c 00 00 00       	push   $0x9c
80107132:	e9 b9 f3 ff ff       	jmp    801064f0 <alltraps>

80107137 <vector157>:
80107137:	6a 00                	push   $0x0
80107139:	68 9d 00 00 00       	push   $0x9d
8010713e:	e9 ad f3 ff ff       	jmp    801064f0 <alltraps>

80107143 <vector158>:
80107143:	6a 00                	push   $0x0
80107145:	68 9e 00 00 00       	push   $0x9e
8010714a:	e9 a1 f3 ff ff       	jmp    801064f0 <alltraps>

8010714f <vector159>:
8010714f:	6a 00                	push   $0x0
80107151:	68 9f 00 00 00       	push   $0x9f
80107156:	e9 95 f3 ff ff       	jmp    801064f0 <alltraps>

8010715b <vector160>:
8010715b:	6a 00                	push   $0x0
8010715d:	68 a0 00 00 00       	push   $0xa0
80107162:	e9 89 f3 ff ff       	jmp    801064f0 <alltraps>

80107167 <vector161>:
80107167:	6a 00                	push   $0x0
80107169:	68 a1 00 00 00       	push   $0xa1
8010716e:	e9 7d f3 ff ff       	jmp    801064f0 <alltraps>

80107173 <vector162>:
80107173:	6a 00                	push   $0x0
80107175:	68 a2 00 00 00       	push   $0xa2
8010717a:	e9 71 f3 ff ff       	jmp    801064f0 <alltraps>

8010717f <vector163>:
8010717f:	6a 00                	push   $0x0
80107181:	68 a3 00 00 00       	push   $0xa3
80107186:	e9 65 f3 ff ff       	jmp    801064f0 <alltraps>

8010718b <vector164>:
8010718b:	6a 00                	push   $0x0
8010718d:	68 a4 00 00 00       	push   $0xa4
80107192:	e9 59 f3 ff ff       	jmp    801064f0 <alltraps>

80107197 <vector165>:
80107197:	6a 00                	push   $0x0
80107199:	68 a5 00 00 00       	push   $0xa5
8010719e:	e9 4d f3 ff ff       	jmp    801064f0 <alltraps>

801071a3 <vector166>:
801071a3:	6a 00                	push   $0x0
801071a5:	68 a6 00 00 00       	push   $0xa6
801071aa:	e9 41 f3 ff ff       	jmp    801064f0 <alltraps>

801071af <vector167>:
801071af:	6a 00                	push   $0x0
801071b1:	68 a7 00 00 00       	push   $0xa7
801071b6:	e9 35 f3 ff ff       	jmp    801064f0 <alltraps>

801071bb <vector168>:
801071bb:	6a 00                	push   $0x0
801071bd:	68 a8 00 00 00       	push   $0xa8
801071c2:	e9 29 f3 ff ff       	jmp    801064f0 <alltraps>

801071c7 <vector169>:
801071c7:	6a 00                	push   $0x0
801071c9:	68 a9 00 00 00       	push   $0xa9
801071ce:	e9 1d f3 ff ff       	jmp    801064f0 <alltraps>

801071d3 <vector170>:
801071d3:	6a 00                	push   $0x0
801071d5:	68 aa 00 00 00       	push   $0xaa
801071da:	e9 11 f3 ff ff       	jmp    801064f0 <alltraps>

801071df <vector171>:
801071df:	6a 00                	push   $0x0
801071e1:	68 ab 00 00 00       	push   $0xab
801071e6:	e9 05 f3 ff ff       	jmp    801064f0 <alltraps>

801071eb <vector172>:
801071eb:	6a 00                	push   $0x0
801071ed:	68 ac 00 00 00       	push   $0xac
801071f2:	e9 f9 f2 ff ff       	jmp    801064f0 <alltraps>

801071f7 <vector173>:
801071f7:	6a 00                	push   $0x0
801071f9:	68 ad 00 00 00       	push   $0xad
801071fe:	e9 ed f2 ff ff       	jmp    801064f0 <alltraps>

80107203 <vector174>:
80107203:	6a 00                	push   $0x0
80107205:	68 ae 00 00 00       	push   $0xae
8010720a:	e9 e1 f2 ff ff       	jmp    801064f0 <alltraps>

8010720f <vector175>:
8010720f:	6a 00                	push   $0x0
80107211:	68 af 00 00 00       	push   $0xaf
80107216:	e9 d5 f2 ff ff       	jmp    801064f0 <alltraps>

8010721b <vector176>:
8010721b:	6a 00                	push   $0x0
8010721d:	68 b0 00 00 00       	push   $0xb0
80107222:	e9 c9 f2 ff ff       	jmp    801064f0 <alltraps>

80107227 <vector177>:
80107227:	6a 00                	push   $0x0
80107229:	68 b1 00 00 00       	push   $0xb1
8010722e:	e9 bd f2 ff ff       	jmp    801064f0 <alltraps>

80107233 <vector178>:
80107233:	6a 00                	push   $0x0
80107235:	68 b2 00 00 00       	push   $0xb2
8010723a:	e9 b1 f2 ff ff       	jmp    801064f0 <alltraps>

8010723f <vector179>:
8010723f:	6a 00                	push   $0x0
80107241:	68 b3 00 00 00       	push   $0xb3
80107246:	e9 a5 f2 ff ff       	jmp    801064f0 <alltraps>

8010724b <vector180>:
8010724b:	6a 00                	push   $0x0
8010724d:	68 b4 00 00 00       	push   $0xb4
80107252:	e9 99 f2 ff ff       	jmp    801064f0 <alltraps>

80107257 <vector181>:
80107257:	6a 00                	push   $0x0
80107259:	68 b5 00 00 00       	push   $0xb5
8010725e:	e9 8d f2 ff ff       	jmp    801064f0 <alltraps>

80107263 <vector182>:
80107263:	6a 00                	push   $0x0
80107265:	68 b6 00 00 00       	push   $0xb6
8010726a:	e9 81 f2 ff ff       	jmp    801064f0 <alltraps>

8010726f <vector183>:
8010726f:	6a 00                	push   $0x0
80107271:	68 b7 00 00 00       	push   $0xb7
80107276:	e9 75 f2 ff ff       	jmp    801064f0 <alltraps>

8010727b <vector184>:
8010727b:	6a 00                	push   $0x0
8010727d:	68 b8 00 00 00       	push   $0xb8
80107282:	e9 69 f2 ff ff       	jmp    801064f0 <alltraps>

80107287 <vector185>:
80107287:	6a 00                	push   $0x0
80107289:	68 b9 00 00 00       	push   $0xb9
8010728e:	e9 5d f2 ff ff       	jmp    801064f0 <alltraps>

80107293 <vector186>:
80107293:	6a 00                	push   $0x0
80107295:	68 ba 00 00 00       	push   $0xba
8010729a:	e9 51 f2 ff ff       	jmp    801064f0 <alltraps>

8010729f <vector187>:
8010729f:	6a 00                	push   $0x0
801072a1:	68 bb 00 00 00       	push   $0xbb
801072a6:	e9 45 f2 ff ff       	jmp    801064f0 <alltraps>

801072ab <vector188>:
801072ab:	6a 00                	push   $0x0
801072ad:	68 bc 00 00 00       	push   $0xbc
801072b2:	e9 39 f2 ff ff       	jmp    801064f0 <alltraps>

801072b7 <vector189>:
801072b7:	6a 00                	push   $0x0
801072b9:	68 bd 00 00 00       	push   $0xbd
801072be:	e9 2d f2 ff ff       	jmp    801064f0 <alltraps>

801072c3 <vector190>:
801072c3:	6a 00                	push   $0x0
801072c5:	68 be 00 00 00       	push   $0xbe
801072ca:	e9 21 f2 ff ff       	jmp    801064f0 <alltraps>

801072cf <vector191>:
801072cf:	6a 00                	push   $0x0
801072d1:	68 bf 00 00 00       	push   $0xbf
801072d6:	e9 15 f2 ff ff       	jmp    801064f0 <alltraps>

801072db <vector192>:
801072db:	6a 00                	push   $0x0
801072dd:	68 c0 00 00 00       	push   $0xc0
801072e2:	e9 09 f2 ff ff       	jmp    801064f0 <alltraps>

801072e7 <vector193>:
801072e7:	6a 00                	push   $0x0
801072e9:	68 c1 00 00 00       	push   $0xc1
801072ee:	e9 fd f1 ff ff       	jmp    801064f0 <alltraps>

801072f3 <vector194>:
801072f3:	6a 00                	push   $0x0
801072f5:	68 c2 00 00 00       	push   $0xc2
801072fa:	e9 f1 f1 ff ff       	jmp    801064f0 <alltraps>

801072ff <vector195>:
801072ff:	6a 00                	push   $0x0
80107301:	68 c3 00 00 00       	push   $0xc3
80107306:	e9 e5 f1 ff ff       	jmp    801064f0 <alltraps>

8010730b <vector196>:
8010730b:	6a 00                	push   $0x0
8010730d:	68 c4 00 00 00       	push   $0xc4
80107312:	e9 d9 f1 ff ff       	jmp    801064f0 <alltraps>

80107317 <vector197>:
80107317:	6a 00                	push   $0x0
80107319:	68 c5 00 00 00       	push   $0xc5
8010731e:	e9 cd f1 ff ff       	jmp    801064f0 <alltraps>

80107323 <vector198>:
80107323:	6a 00                	push   $0x0
80107325:	68 c6 00 00 00       	push   $0xc6
8010732a:	e9 c1 f1 ff ff       	jmp    801064f0 <alltraps>

8010732f <vector199>:
8010732f:	6a 00                	push   $0x0
80107331:	68 c7 00 00 00       	push   $0xc7
80107336:	e9 b5 f1 ff ff       	jmp    801064f0 <alltraps>

8010733b <vector200>:
8010733b:	6a 00                	push   $0x0
8010733d:	68 c8 00 00 00       	push   $0xc8
80107342:	e9 a9 f1 ff ff       	jmp    801064f0 <alltraps>

80107347 <vector201>:
80107347:	6a 00                	push   $0x0
80107349:	68 c9 00 00 00       	push   $0xc9
8010734e:	e9 9d f1 ff ff       	jmp    801064f0 <alltraps>

80107353 <vector202>:
80107353:	6a 00                	push   $0x0
80107355:	68 ca 00 00 00       	push   $0xca
8010735a:	e9 91 f1 ff ff       	jmp    801064f0 <alltraps>

8010735f <vector203>:
8010735f:	6a 00                	push   $0x0
80107361:	68 cb 00 00 00       	push   $0xcb
80107366:	e9 85 f1 ff ff       	jmp    801064f0 <alltraps>

8010736b <vector204>:
8010736b:	6a 00                	push   $0x0
8010736d:	68 cc 00 00 00       	push   $0xcc
80107372:	e9 79 f1 ff ff       	jmp    801064f0 <alltraps>

80107377 <vector205>:
80107377:	6a 00                	push   $0x0
80107379:	68 cd 00 00 00       	push   $0xcd
8010737e:	e9 6d f1 ff ff       	jmp    801064f0 <alltraps>

80107383 <vector206>:
80107383:	6a 00                	push   $0x0
80107385:	68 ce 00 00 00       	push   $0xce
8010738a:	e9 61 f1 ff ff       	jmp    801064f0 <alltraps>

8010738f <vector207>:
8010738f:	6a 00                	push   $0x0
80107391:	68 cf 00 00 00       	push   $0xcf
80107396:	e9 55 f1 ff ff       	jmp    801064f0 <alltraps>

8010739b <vector208>:
8010739b:	6a 00                	push   $0x0
8010739d:	68 d0 00 00 00       	push   $0xd0
801073a2:	e9 49 f1 ff ff       	jmp    801064f0 <alltraps>

801073a7 <vector209>:
801073a7:	6a 00                	push   $0x0
801073a9:	68 d1 00 00 00       	push   $0xd1
801073ae:	e9 3d f1 ff ff       	jmp    801064f0 <alltraps>

801073b3 <vector210>:
801073b3:	6a 00                	push   $0x0
801073b5:	68 d2 00 00 00       	push   $0xd2
801073ba:	e9 31 f1 ff ff       	jmp    801064f0 <alltraps>

801073bf <vector211>:
801073bf:	6a 00                	push   $0x0
801073c1:	68 d3 00 00 00       	push   $0xd3
801073c6:	e9 25 f1 ff ff       	jmp    801064f0 <alltraps>

801073cb <vector212>:
801073cb:	6a 00                	push   $0x0
801073cd:	68 d4 00 00 00       	push   $0xd4
801073d2:	e9 19 f1 ff ff       	jmp    801064f0 <alltraps>

801073d7 <vector213>:
801073d7:	6a 00                	push   $0x0
801073d9:	68 d5 00 00 00       	push   $0xd5
801073de:	e9 0d f1 ff ff       	jmp    801064f0 <alltraps>

801073e3 <vector214>:
801073e3:	6a 00                	push   $0x0
801073e5:	68 d6 00 00 00       	push   $0xd6
801073ea:	e9 01 f1 ff ff       	jmp    801064f0 <alltraps>

801073ef <vector215>:
801073ef:	6a 00                	push   $0x0
801073f1:	68 d7 00 00 00       	push   $0xd7
801073f6:	e9 f5 f0 ff ff       	jmp    801064f0 <alltraps>

801073fb <vector216>:
801073fb:	6a 00                	push   $0x0
801073fd:	68 d8 00 00 00       	push   $0xd8
80107402:	e9 e9 f0 ff ff       	jmp    801064f0 <alltraps>

80107407 <vector217>:
80107407:	6a 00                	push   $0x0
80107409:	68 d9 00 00 00       	push   $0xd9
8010740e:	e9 dd f0 ff ff       	jmp    801064f0 <alltraps>

80107413 <vector218>:
80107413:	6a 00                	push   $0x0
80107415:	68 da 00 00 00       	push   $0xda
8010741a:	e9 d1 f0 ff ff       	jmp    801064f0 <alltraps>

8010741f <vector219>:
8010741f:	6a 00                	push   $0x0
80107421:	68 db 00 00 00       	push   $0xdb
80107426:	e9 c5 f0 ff ff       	jmp    801064f0 <alltraps>

8010742b <vector220>:
8010742b:	6a 00                	push   $0x0
8010742d:	68 dc 00 00 00       	push   $0xdc
80107432:	e9 b9 f0 ff ff       	jmp    801064f0 <alltraps>

80107437 <vector221>:
80107437:	6a 00                	push   $0x0
80107439:	68 dd 00 00 00       	push   $0xdd
8010743e:	e9 ad f0 ff ff       	jmp    801064f0 <alltraps>

80107443 <vector222>:
80107443:	6a 00                	push   $0x0
80107445:	68 de 00 00 00       	push   $0xde
8010744a:	e9 a1 f0 ff ff       	jmp    801064f0 <alltraps>

8010744f <vector223>:
8010744f:	6a 00                	push   $0x0
80107451:	68 df 00 00 00       	push   $0xdf
80107456:	e9 95 f0 ff ff       	jmp    801064f0 <alltraps>

8010745b <vector224>:
8010745b:	6a 00                	push   $0x0
8010745d:	68 e0 00 00 00       	push   $0xe0
80107462:	e9 89 f0 ff ff       	jmp    801064f0 <alltraps>

80107467 <vector225>:
80107467:	6a 00                	push   $0x0
80107469:	68 e1 00 00 00       	push   $0xe1
8010746e:	e9 7d f0 ff ff       	jmp    801064f0 <alltraps>

80107473 <vector226>:
80107473:	6a 00                	push   $0x0
80107475:	68 e2 00 00 00       	push   $0xe2
8010747a:	e9 71 f0 ff ff       	jmp    801064f0 <alltraps>

8010747f <vector227>:
8010747f:	6a 00                	push   $0x0
80107481:	68 e3 00 00 00       	push   $0xe3
80107486:	e9 65 f0 ff ff       	jmp    801064f0 <alltraps>

8010748b <vector228>:
8010748b:	6a 00                	push   $0x0
8010748d:	68 e4 00 00 00       	push   $0xe4
80107492:	e9 59 f0 ff ff       	jmp    801064f0 <alltraps>

80107497 <vector229>:
80107497:	6a 00                	push   $0x0
80107499:	68 e5 00 00 00       	push   $0xe5
8010749e:	e9 4d f0 ff ff       	jmp    801064f0 <alltraps>

801074a3 <vector230>:
801074a3:	6a 00                	push   $0x0
801074a5:	68 e6 00 00 00       	push   $0xe6
801074aa:	e9 41 f0 ff ff       	jmp    801064f0 <alltraps>

801074af <vector231>:
801074af:	6a 00                	push   $0x0
801074b1:	68 e7 00 00 00       	push   $0xe7
801074b6:	e9 35 f0 ff ff       	jmp    801064f0 <alltraps>

801074bb <vector232>:
801074bb:	6a 00                	push   $0x0
801074bd:	68 e8 00 00 00       	push   $0xe8
801074c2:	e9 29 f0 ff ff       	jmp    801064f0 <alltraps>

801074c7 <vector233>:
801074c7:	6a 00                	push   $0x0
801074c9:	68 e9 00 00 00       	push   $0xe9
801074ce:	e9 1d f0 ff ff       	jmp    801064f0 <alltraps>

801074d3 <vector234>:
801074d3:	6a 00                	push   $0x0
801074d5:	68 ea 00 00 00       	push   $0xea
801074da:	e9 11 f0 ff ff       	jmp    801064f0 <alltraps>

801074df <vector235>:
801074df:	6a 00                	push   $0x0
801074e1:	68 eb 00 00 00       	push   $0xeb
801074e6:	e9 05 f0 ff ff       	jmp    801064f0 <alltraps>

801074eb <vector236>:
801074eb:	6a 00                	push   $0x0
801074ed:	68 ec 00 00 00       	push   $0xec
801074f2:	e9 f9 ef ff ff       	jmp    801064f0 <alltraps>

801074f7 <vector237>:
801074f7:	6a 00                	push   $0x0
801074f9:	68 ed 00 00 00       	push   $0xed
801074fe:	e9 ed ef ff ff       	jmp    801064f0 <alltraps>

80107503 <vector238>:
80107503:	6a 00                	push   $0x0
80107505:	68 ee 00 00 00       	push   $0xee
8010750a:	e9 e1 ef ff ff       	jmp    801064f0 <alltraps>

8010750f <vector239>:
8010750f:	6a 00                	push   $0x0
80107511:	68 ef 00 00 00       	push   $0xef
80107516:	e9 d5 ef ff ff       	jmp    801064f0 <alltraps>

8010751b <vector240>:
8010751b:	6a 00                	push   $0x0
8010751d:	68 f0 00 00 00       	push   $0xf0
80107522:	e9 c9 ef ff ff       	jmp    801064f0 <alltraps>

80107527 <vector241>:
80107527:	6a 00                	push   $0x0
80107529:	68 f1 00 00 00       	push   $0xf1
8010752e:	e9 bd ef ff ff       	jmp    801064f0 <alltraps>

80107533 <vector242>:
80107533:	6a 00                	push   $0x0
80107535:	68 f2 00 00 00       	push   $0xf2
8010753a:	e9 b1 ef ff ff       	jmp    801064f0 <alltraps>

8010753f <vector243>:
8010753f:	6a 00                	push   $0x0
80107541:	68 f3 00 00 00       	push   $0xf3
80107546:	e9 a5 ef ff ff       	jmp    801064f0 <alltraps>

8010754b <vector244>:
8010754b:	6a 00                	push   $0x0
8010754d:	68 f4 00 00 00       	push   $0xf4
80107552:	e9 99 ef ff ff       	jmp    801064f0 <alltraps>

80107557 <vector245>:
80107557:	6a 00                	push   $0x0
80107559:	68 f5 00 00 00       	push   $0xf5
8010755e:	e9 8d ef ff ff       	jmp    801064f0 <alltraps>

80107563 <vector246>:
80107563:	6a 00                	push   $0x0
80107565:	68 f6 00 00 00       	push   $0xf6
8010756a:	e9 81 ef ff ff       	jmp    801064f0 <alltraps>

8010756f <vector247>:
8010756f:	6a 00                	push   $0x0
80107571:	68 f7 00 00 00       	push   $0xf7
80107576:	e9 75 ef ff ff       	jmp    801064f0 <alltraps>

8010757b <vector248>:
8010757b:	6a 00                	push   $0x0
8010757d:	68 f8 00 00 00       	push   $0xf8
80107582:	e9 69 ef ff ff       	jmp    801064f0 <alltraps>

80107587 <vector249>:
80107587:	6a 00                	push   $0x0
80107589:	68 f9 00 00 00       	push   $0xf9
8010758e:	e9 5d ef ff ff       	jmp    801064f0 <alltraps>

80107593 <vector250>:
80107593:	6a 00                	push   $0x0
80107595:	68 fa 00 00 00       	push   $0xfa
8010759a:	e9 51 ef ff ff       	jmp    801064f0 <alltraps>

8010759f <vector251>:
8010759f:	6a 00                	push   $0x0
801075a1:	68 fb 00 00 00       	push   $0xfb
801075a6:	e9 45 ef ff ff       	jmp    801064f0 <alltraps>

801075ab <vector252>:
801075ab:	6a 00                	push   $0x0
801075ad:	68 fc 00 00 00       	push   $0xfc
801075b2:	e9 39 ef ff ff       	jmp    801064f0 <alltraps>

801075b7 <vector253>:
801075b7:	6a 00                	push   $0x0
801075b9:	68 fd 00 00 00       	push   $0xfd
801075be:	e9 2d ef ff ff       	jmp    801064f0 <alltraps>

801075c3 <vector254>:
801075c3:	6a 00                	push   $0x0
801075c5:	68 fe 00 00 00       	push   $0xfe
801075ca:	e9 21 ef ff ff       	jmp    801064f0 <alltraps>

801075cf <vector255>:
801075cf:	6a 00                	push   $0x0
801075d1:	68 ff 00 00 00       	push   $0xff
801075d6:	e9 15 ef ff ff       	jmp    801064f0 <alltraps>

801075db <lgdt>:
{
801075db:	55                   	push   %ebp
801075dc:	89 e5                	mov    %esp,%ebp
801075de:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801075e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e4:	48                   	dec    %eax
801075e5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801075e9:	8b 45 08             	mov    0x8(%ebp),%eax
801075ec:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801075f0:	8b 45 08             	mov    0x8(%ebp),%eax
801075f3:	c1 e8 10             	shr    $0x10,%eax
801075f6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801075fa:	8d 45 fa             	lea    -0x6(%ebp),%eax
801075fd:	0f 01 10             	lgdtl  (%eax)
}
80107600:	c9                   	leave  
80107601:	c3                   	ret    

80107602 <ltr>:
{
80107602:	55                   	push   %ebp
80107603:	89 e5                	mov    %esp,%ebp
80107605:	83 ec 04             	sub    $0x4,%esp
80107608:	8b 45 08             	mov    0x8(%ebp),%eax
8010760b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010760f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107612:	0f 00 d8             	ltr    %ax
}
80107615:	c9                   	leave  
80107616:	c3                   	ret    

80107617 <loadgs>:
{
80107617:	55                   	push   %ebp
80107618:	89 e5                	mov    %esp,%ebp
8010761a:	83 ec 04             	sub    $0x4,%esp
8010761d:	8b 45 08             	mov    0x8(%ebp),%eax
80107620:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107624:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107627:	8e e8                	mov    %eax,%gs
}
80107629:	c9                   	leave  
8010762a:	c3                   	ret    

8010762b <lcr3>:

static inline void
lcr3(uint val) 
{
8010762b:	55                   	push   %ebp
8010762c:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010762e:	8b 45 08             	mov    0x8(%ebp),%eax
80107631:	0f 22 d8             	mov    %eax,%cr3
}
80107634:	5d                   	pop    %ebp
80107635:	c3                   	ret    

80107636 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107636:	55                   	push   %ebp
80107637:	89 e5                	mov    %esp,%ebp
80107639:	8b 45 08             	mov    0x8(%ebp),%eax
8010763c:	05 00 00 00 80       	add    $0x80000000,%eax
80107641:	5d                   	pop    %ebp
80107642:	c3                   	ret    

80107643 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107643:	55                   	push   %ebp
80107644:	89 e5                	mov    %esp,%ebp
80107646:	8b 45 08             	mov    0x8(%ebp),%eax
80107649:	05 00 00 00 80       	add    $0x80000000,%eax
8010764e:	5d                   	pop    %ebp
8010764f:	c3                   	ret    

80107650 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	53                   	push   %ebx
80107654:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107657:	e8 e9 b7 ff ff       	call   80102e45 <cpunum>
8010765c:	89 c2                	mov    %eax,%edx
8010765e:	89 d0                	mov    %edx,%eax
80107660:	d1 e0                	shl    %eax
80107662:	01 d0                	add    %edx,%eax
80107664:	c1 e0 04             	shl    $0x4,%eax
80107667:	29 d0                	sub    %edx,%eax
80107669:	c1 e0 02             	shl    $0x2,%eax
8010766c:	05 40 f9 10 80       	add    $0x8010f940,%eax
80107671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107674:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107677:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010767d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107680:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107689:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010768d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107690:	8a 50 7d             	mov    0x7d(%eax),%dl
80107693:	83 e2 f0             	and    $0xfffffff0,%edx
80107696:	83 ca 0a             	or     $0xa,%edx
80107699:	88 50 7d             	mov    %dl,0x7d(%eax)
8010769c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010769f:	8a 50 7d             	mov    0x7d(%eax),%dl
801076a2:	83 ca 10             	or     $0x10,%edx
801076a5:	88 50 7d             	mov    %dl,0x7d(%eax)
801076a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ab:	8a 50 7d             	mov    0x7d(%eax),%dl
801076ae:	83 e2 9f             	and    $0xffffff9f,%edx
801076b1:	88 50 7d             	mov    %dl,0x7d(%eax)
801076b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b7:	8a 50 7d             	mov    0x7d(%eax),%dl
801076ba:	83 ca 80             	or     $0xffffff80,%edx
801076bd:	88 50 7d             	mov    %dl,0x7d(%eax)
801076c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c3:	8a 50 7e             	mov    0x7e(%eax),%dl
801076c6:	83 ca 0f             	or     $0xf,%edx
801076c9:	88 50 7e             	mov    %dl,0x7e(%eax)
801076cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076cf:	8a 50 7e             	mov    0x7e(%eax),%dl
801076d2:	83 e2 ef             	and    $0xffffffef,%edx
801076d5:	88 50 7e             	mov    %dl,0x7e(%eax)
801076d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076db:	8a 50 7e             	mov    0x7e(%eax),%dl
801076de:	83 e2 df             	and    $0xffffffdf,%edx
801076e1:	88 50 7e             	mov    %dl,0x7e(%eax)
801076e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e7:	8a 50 7e             	mov    0x7e(%eax),%dl
801076ea:	83 ca 40             	or     $0x40,%edx
801076ed:	88 50 7e             	mov    %dl,0x7e(%eax)
801076f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f3:	8a 50 7e             	mov    0x7e(%eax),%dl
801076f6:	83 ca 80             	or     $0xffffff80,%edx
801076f9:	88 50 7e             	mov    %dl,0x7e(%eax)
801076fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ff:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107706:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010770d:	ff ff 
8010770f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107712:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107719:	00 00 
8010771b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107728:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010772e:	83 e2 f0             	and    $0xfffffff0,%edx
80107731:	83 ca 02             	or     $0x2,%edx
80107734:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010773a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010773d:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107743:	83 ca 10             	or     $0x10,%edx
80107746:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010774c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774f:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107755:	83 e2 9f             	and    $0xffffff9f,%edx
80107758:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010775e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107761:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
80107767:	83 ca 80             	or     $0xffffff80,%edx
8010776a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107773:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107779:	83 ca 0f             	or     $0xf,%edx
8010777c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107785:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010778b:	83 e2 ef             	and    $0xffffffef,%edx
8010778e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107797:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010779d:	83 e2 df             	and    $0xffffffdf,%edx
801077a0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a9:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801077af:	83 ca 40             	or     $0x40,%edx
801077b2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bb:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
801077c1:	83 ca 80             	or     $0xffffff80,%edx
801077c4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801077ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cd:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801077d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d7:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801077de:	ff ff 
801077e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801077ea:	00 00 
801077ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ef:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801077f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f9:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801077ff:	83 e2 f0             	and    $0xfffffff0,%edx
80107802:	83 ca 0a             	or     $0xa,%edx
80107805:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010780b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780e:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107814:	83 ca 10             	or     $0x10,%edx
80107817:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010781d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107820:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107826:	83 ca 60             	or     $0x60,%edx
80107829:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010782f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107832:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
80107838:	83 ca 80             	or     $0xffffff80,%edx
8010783b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107844:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010784a:	83 ca 0f             	or     $0xf,%edx
8010784d:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107856:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010785c:	83 e2 ef             	and    $0xffffffef,%edx
8010785f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107868:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
8010786e:	83 e2 df             	and    $0xffffffdf,%edx
80107871:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787a:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107880:	83 ca 40             	or     $0x40,%edx
80107883:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107889:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788c:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107892:	83 ca 80             	or     $0xffffff80,%edx
80107895:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010789b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a8:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801078af:	ff ff 
801078b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b4:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801078bb:	00 00 
801078bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c0:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801078c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ca:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801078d0:	83 e2 f0             	and    $0xfffffff0,%edx
801078d3:	83 ca 02             	or     $0x2,%edx
801078d6:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801078dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078df:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801078e5:	83 ca 10             	or     $0x10,%edx
801078e8:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801078ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f1:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801078f7:	83 ca 60             	or     $0x60,%edx
801078fa:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107903:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107909:	83 ca 80             	or     $0xffffff80,%edx
8010790c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107912:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107915:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010791b:	83 ca 0f             	or     $0xf,%edx
8010791e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107927:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010792d:	83 e2 ef             	and    $0xffffffef,%edx
80107930:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107939:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
8010793f:	83 e2 df             	and    $0xffffffdf,%edx
80107942:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107948:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794b:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107951:	83 ca 40             	or     $0x40,%edx
80107954:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010795a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795d:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107963:	83 ca 80             	or     $0xffffff80,%edx
80107966:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010796c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796f:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107979:	05 b4 00 00 00       	add    $0xb4,%eax
8010797e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107981:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107987:	c1 ea 10             	shr    $0x10,%edx
8010798a:	88 d1                	mov    %dl,%cl
8010798c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010798f:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107995:	c1 ea 18             	shr    $0x18,%edx
80107998:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010799b:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
801079a2:	00 00 
801079a4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801079a7:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
801079ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b1:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801079b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ba:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801079c0:	83 e1 f0             	and    $0xfffffff0,%ecx
801079c3:	83 c9 02             	or     $0x2,%ecx
801079c6:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cf:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801079d5:	83 c9 10             	or     $0x10,%ecx
801079d8:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e1:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801079e7:	83 e1 9f             	and    $0xffffff9f,%ecx
801079ea:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801079f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f3:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
801079f9:	83 c9 80             	or     $0xffffff80,%ecx
801079fc:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a05:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107a0b:	83 e1 f0             	and    $0xfffffff0,%ecx
80107a0e:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a17:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107a1d:	83 e1 ef             	and    $0xffffffef,%ecx
80107a20:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a29:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107a2f:	83 e1 df             	and    $0xffffffdf,%ecx
80107a32:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3b:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107a41:	83 c9 40             	or     $0x40,%ecx
80107a44:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a4d:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
80107a53:	83 c9 80             	or     $0xffffff80,%ecx
80107a56:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5f:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a68:	83 c0 70             	add    $0x70,%eax
80107a6b:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107a72:	00 
80107a73:	89 04 24             	mov    %eax,(%esp)
80107a76:	e8 60 fb ff ff       	call   801075db <lgdt>
  loadgs(SEG_KCPU << 3);
80107a7b:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107a82:	e8 90 fb ff ff       	call   80107617 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8a:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107a90:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107a97:	00 00 00 00 
}
80107a9b:	83 c4 24             	add    $0x24,%esp
80107a9e:	5b                   	pop    %ebx
80107a9f:	5d                   	pop    %ebp
80107aa0:	c3                   	ret    

80107aa1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107aa1:	55                   	push   %ebp
80107aa2:	89 e5                	mov    %esp,%ebp
80107aa4:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aaa:	c1 e8 16             	shr    $0x16,%eax
80107aad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80107ab7:	01 d0                	add    %edx,%eax
80107ab9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107abc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107abf:	8b 00                	mov    (%eax),%eax
80107ac1:	83 e0 01             	and    $0x1,%eax
80107ac4:	85 c0                	test   %eax,%eax
80107ac6:	74 17                	je     80107adf <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107acb:	8b 00                	mov    (%eax),%eax
80107acd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ad2:	89 04 24             	mov    %eax,(%esp)
80107ad5:	e8 69 fb ff ff       	call   80107643 <p2v>
80107ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107add:	eb 4b                	jmp    80107b2a <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107adf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107ae3:	74 0e                	je     80107af3 <walkpgdir+0x52>
80107ae5:	e8 d4 af ff ff       	call   80102abe <kalloc>
80107aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107af1:	75 07                	jne    80107afa <walkpgdir+0x59>
      return 0;
80107af3:	b8 00 00 00 00       	mov    $0x0,%eax
80107af8:	eb 47                	jmp    80107b41 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107afa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b01:	00 
80107b02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b09:	00 
80107b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0d:	89 04 24             	mov    %eax,(%esp)
80107b10:	e8 80 d4 ff ff       	call   80104f95 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b18:	89 04 24             	mov    %eax,(%esp)
80107b1b:	e8 16 fb ff ff       	call   80107636 <v2p>
80107b20:	89 c2                	mov    %eax,%edx
80107b22:	83 ca 07             	or     $0x7,%edx
80107b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b28:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b2d:	c1 e8 0c             	shr    $0xc,%eax
80107b30:	25 ff 03 00 00       	and    $0x3ff,%eax
80107b35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3f:	01 d0                	add    %edx,%eax
}
80107b41:	c9                   	leave  
80107b42:	c3                   	ret    

80107b43 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107b43:	55                   	push   %ebp
80107b44:	89 e5                	mov    %esp,%ebp
80107b46:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107b49:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107b54:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b57:	8b 45 10             	mov    0x10(%ebp),%eax
80107b5a:	01 d0                	add    %edx,%eax
80107b5c:	48                   	dec    %eax
80107b5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107b65:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107b6c:	00 
80107b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80107b74:	8b 45 08             	mov    0x8(%ebp),%eax
80107b77:	89 04 24             	mov    %eax,(%esp)
80107b7a:	e8 22 ff ff ff       	call   80107aa1 <walkpgdir>
80107b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107b82:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107b86:	75 07                	jne    80107b8f <mappages+0x4c>
      return -1;
80107b88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b8d:	eb 46                	jmp    80107bd5 <mappages+0x92>
    if(*pte & PTE_P)
80107b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107b92:	8b 00                	mov    (%eax),%eax
80107b94:	83 e0 01             	and    $0x1,%eax
80107b97:	85 c0                	test   %eax,%eax
80107b99:	74 0c                	je     80107ba7 <mappages+0x64>
      panic("remap");
80107b9b:	c7 04 24 c8 89 10 80 	movl   $0x801089c8,(%esp)
80107ba2:	e8 8f 89 ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
80107ba7:	8b 45 18             	mov    0x18(%ebp),%eax
80107baa:	0b 45 14             	or     0x14(%ebp),%eax
80107bad:	89 c2                	mov    %eax,%edx
80107baf:	83 ca 01             	or     $0x1,%edx
80107bb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107bb5:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107bbd:	74 10                	je     80107bcf <mappages+0x8c>
      break;
    a += PGSIZE;
80107bbf:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107bc6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107bcd:	eb 96                	jmp    80107b65 <mappages+0x22>
      break;
80107bcf:	90                   	nop
  return 0;
80107bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107bd5:	c9                   	leave  
80107bd6:	c3                   	ret    

80107bd7 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107bd7:	55                   	push   %ebp
80107bd8:	89 e5                	mov    %esp,%ebp
80107bda:	53                   	push   %ebx
80107bdb:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107bde:	e8 db ae ff ff       	call   80102abe <kalloc>
80107be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107bea:	75 0a                	jne    80107bf6 <setupkvm+0x1f>
    return 0;
80107bec:	b8 00 00 00 00       	mov    $0x0,%eax
80107bf1:	e9 98 00 00 00       	jmp    80107c8e <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107bf6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107bfd:	00 
80107bfe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c05:	00 
80107c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c09:	89 04 24             	mov    %eax,(%esp)
80107c0c:	e8 84 d3 ff ff       	call   80104f95 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107c11:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107c18:	e8 26 fa ff ff       	call   80107643 <p2v>
80107c1d:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107c22:	76 0c                	jbe    80107c30 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107c24:	c7 04 24 ce 89 10 80 	movl   $0x801089ce,(%esp)
80107c2b:	e8 06 89 ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c30:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107c37:	eb 49                	jmp    80107c82 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107c3c:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107c42:	8b 50 04             	mov    0x4(%eax),%edx
80107c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c48:	8b 58 08             	mov    0x8(%eax),%ebx
80107c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c4e:	8b 40 04             	mov    0x4(%eax),%eax
80107c51:	29 c3                	sub    %eax,%ebx
80107c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c56:	8b 00                	mov    (%eax),%eax
80107c58:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107c5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107c60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107c64:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c6b:	89 04 24             	mov    %eax,(%esp)
80107c6e:	e8 d0 fe ff ff       	call   80107b43 <mappages>
80107c73:	85 c0                	test   %eax,%eax
80107c75:	79 07                	jns    80107c7e <setupkvm+0xa7>
      return 0;
80107c77:	b8 00 00 00 00       	mov    $0x0,%eax
80107c7c:	eb 10                	jmp    80107c8e <setupkvm+0xb7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c7e:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107c82:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107c89:	72 ae                	jb     80107c39 <setupkvm+0x62>
  return pgdir;
80107c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107c8e:	83 c4 34             	add    $0x34,%esp
80107c91:	5b                   	pop    %ebx
80107c92:	5d                   	pop    %ebp
80107c93:	c3                   	ret    

80107c94 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107c94:	55                   	push   %ebp
80107c95:	89 e5                	mov    %esp,%ebp
80107c97:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107c9a:	e8 38 ff ff ff       	call   80107bd7 <setupkvm>
80107c9f:	a3 38 2a 11 80       	mov    %eax,0x80112a38
  switchkvm();
80107ca4:	e8 02 00 00 00       	call   80107cab <switchkvm>
}
80107ca9:	c9                   	leave  
80107caa:	c3                   	ret    

80107cab <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107cab:	55                   	push   %ebp
80107cac:	89 e5                	mov    %esp,%ebp
80107cae:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107cb1:	a1 38 2a 11 80       	mov    0x80112a38,%eax
80107cb6:	89 04 24             	mov    %eax,(%esp)
80107cb9:	e8 78 f9 ff ff       	call   80107636 <v2p>
80107cbe:	89 04 24             	mov    %eax,(%esp)
80107cc1:	e8 65 f9 ff ff       	call   8010762b <lcr3>
}
80107cc6:	c9                   	leave  
80107cc7:	c3                   	ret    

80107cc8 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107cc8:	55                   	push   %ebp
80107cc9:	89 e5                	mov    %esp,%ebp
80107ccb:	53                   	push   %ebx
80107ccc:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107ccf:	e8 c1 d1 ff ff       	call   80104e95 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107cd4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107cda:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107ce1:	83 c2 08             	add    $0x8,%edx
80107ce4:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107ceb:	83 c1 08             	add    $0x8,%ecx
80107cee:	c1 e9 10             	shr    $0x10,%ecx
80107cf1:	88 cb                	mov    %cl,%bl
80107cf3:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107cfa:	83 c1 08             	add    $0x8,%ecx
80107cfd:	c1 e9 18             	shr    $0x18,%ecx
80107d00:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107d07:	67 00 
80107d09:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107d10:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107d16:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107d1c:	83 e2 f0             	and    $0xfffffff0,%edx
80107d1f:	83 ca 09             	or     $0x9,%edx
80107d22:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d28:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107d2e:	83 ca 10             	or     $0x10,%edx
80107d31:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d37:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107d3d:	83 e2 9f             	and    $0xffffff9f,%edx
80107d40:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d46:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107d4c:	83 ca 80             	or     $0xffffff80,%edx
80107d4f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107d55:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107d5b:	83 e2 f0             	and    $0xfffffff0,%edx
80107d5e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107d64:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107d6a:	83 e2 ef             	and    $0xffffffef,%edx
80107d6d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107d73:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107d79:	83 e2 df             	and    $0xffffffdf,%edx
80107d7c:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107d82:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107d88:	83 ca 40             	or     $0x40,%edx
80107d8b:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107d91:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107d97:	83 e2 7f             	and    $0x7f,%edx
80107d9a:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107da0:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107da6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dac:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107db2:	83 e2 ef             	and    $0xffffffef,%edx
80107db5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107dbb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dc1:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107dc7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107dcd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107dd4:	8b 52 08             	mov    0x8(%edx),%edx
80107dd7:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107ddd:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107de0:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107de7:	e8 16 f8 ff ff       	call   80107602 <ltr>
  if(p->pgdir == 0)
80107dec:	8b 45 08             	mov    0x8(%ebp),%eax
80107def:	8b 40 04             	mov    0x4(%eax),%eax
80107df2:	85 c0                	test   %eax,%eax
80107df4:	75 0c                	jne    80107e02 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80107df6:	c7 04 24 df 89 10 80 	movl   $0x801089df,(%esp)
80107dfd:	e8 34 87 ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107e02:	8b 45 08             	mov    0x8(%ebp),%eax
80107e05:	8b 40 04             	mov    0x4(%eax),%eax
80107e08:	89 04 24             	mov    %eax,(%esp)
80107e0b:	e8 26 f8 ff ff       	call   80107636 <v2p>
80107e10:	89 04 24             	mov    %eax,(%esp)
80107e13:	e8 13 f8 ff ff       	call   8010762b <lcr3>
  popcli();
80107e18:	e8 be d0 ff ff       	call   80104edb <popcli>
}
80107e1d:	83 c4 14             	add    $0x14,%esp
80107e20:	5b                   	pop    %ebx
80107e21:	5d                   	pop    %ebp
80107e22:	c3                   	ret    

80107e23 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107e23:	55                   	push   %ebp
80107e24:	89 e5                	mov    %esp,%ebp
80107e26:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107e29:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107e30:	76 0c                	jbe    80107e3e <inituvm+0x1b>
    panic("inituvm: more than a page");
80107e32:	c7 04 24 f3 89 10 80 	movl   $0x801089f3,(%esp)
80107e39:	e8 f8 86 ff ff       	call   80100536 <panic>
  mem = kalloc();
80107e3e:	e8 7b ac ff ff       	call   80102abe <kalloc>
80107e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107e46:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e4d:	00 
80107e4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e55:	00 
80107e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e59:	89 04 24             	mov    %eax,(%esp)
80107e5c:	e8 34 d1 ff ff       	call   80104f95 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e64:	89 04 24             	mov    %eax,(%esp)
80107e67:	e8 ca f7 ff ff       	call   80107636 <v2p>
80107e6c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107e73:	00 
80107e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107e78:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107e7f:	00 
80107e80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107e87:	00 
80107e88:	8b 45 08             	mov    0x8(%ebp),%eax
80107e8b:	89 04 24             	mov    %eax,(%esp)
80107e8e:	e8 b0 fc ff ff       	call   80107b43 <mappages>
  memmove(mem, init, sz);
80107e93:	8b 45 10             	mov    0x10(%ebp),%eax
80107e96:	89 44 24 08          	mov    %eax,0x8(%esp)
80107e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	89 04 24             	mov    %eax,(%esp)
80107ea7:	e8 b5 d1 ff ff       	call   80105061 <memmove>
}
80107eac:	c9                   	leave  
80107ead:	c3                   	ret    

80107eae <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107eae:	55                   	push   %ebp
80107eaf:	89 e5                	mov    %esp,%ebp
80107eb1:	53                   	push   %ebx
80107eb2:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80107eb8:	25 ff 0f 00 00       	and    $0xfff,%eax
80107ebd:	85 c0                	test   %eax,%eax
80107ebf:	74 0c                	je     80107ecd <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107ec1:	c7 04 24 10 8a 10 80 	movl   $0x80108a10,(%esp)
80107ec8:	e8 69 86 ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107ecd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107ed4:	e9 ad 00 00 00       	jmp    80107f86 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107edc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107edf:	01 d0                	add    %edx,%eax
80107ee1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ee8:	00 
80107ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
80107eed:	8b 45 08             	mov    0x8(%ebp),%eax
80107ef0:	89 04 24             	mov    %eax,(%esp)
80107ef3:	e8 a9 fb ff ff       	call   80107aa1 <walkpgdir>
80107ef8:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107efb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107eff:	75 0c                	jne    80107f0d <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107f01:	c7 04 24 33 8a 10 80 	movl   $0x80108a33,(%esp)
80107f08:	e8 29 86 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80107f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107f10:	8b 00                	mov    (%eax),%eax
80107f12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f17:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1d:	8b 55 18             	mov    0x18(%ebp),%edx
80107f20:	89 d1                	mov    %edx,%ecx
80107f22:	29 c1                	sub    %eax,%ecx
80107f24:	89 c8                	mov    %ecx,%eax
80107f26:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107f2b:	77 11                	ja     80107f3e <loaduvm+0x90>
      n = sz - i;
80107f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f30:	8b 55 18             	mov    0x18(%ebp),%edx
80107f33:	89 d1                	mov    %edx,%ecx
80107f35:	29 c1                	sub    %eax,%ecx
80107f37:	89 c8                	mov    %ecx,%eax
80107f39:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107f3c:	eb 07                	jmp    80107f45 <loaduvm+0x97>
    else
      n = PGSIZE;
80107f3e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f48:	8b 55 14             	mov    0x14(%ebp),%edx
80107f4b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107f4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107f51:	89 04 24             	mov    %eax,(%esp)
80107f54:	e8 ea f6 ff ff       	call   80107643 <p2v>
80107f59:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f5c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107f60:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107f64:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f68:	8b 45 10             	mov    0x10(%ebp),%eax
80107f6b:	89 04 24             	mov    %eax,(%esp)
80107f6e:	e8 d9 9d ff ff       	call   80101d4c <readi>
80107f73:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107f76:	74 07                	je     80107f7f <loaduvm+0xd1>
      return -1;
80107f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f7d:	eb 18                	jmp    80107f97 <loaduvm+0xe9>
  for(i = 0; i < sz; i += PGSIZE){
80107f7f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f89:	3b 45 18             	cmp    0x18(%ebp),%eax
80107f8c:	0f 82 47 ff ff ff    	jb     80107ed9 <loaduvm+0x2b>
  }
  return 0;
80107f92:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f97:	83 c4 24             	add    $0x24,%esp
80107f9a:	5b                   	pop    %ebx
80107f9b:	5d                   	pop    %ebp
80107f9c:	c3                   	ret    

80107f9d <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107f9d:	55                   	push   %ebp
80107f9e:	89 e5                	mov    %esp,%ebp
80107fa0:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107fa3:	8b 45 10             	mov    0x10(%ebp),%eax
80107fa6:	85 c0                	test   %eax,%eax
80107fa8:	79 0a                	jns    80107fb4 <allocuvm+0x17>
    return 0;
80107faa:	b8 00 00 00 00       	mov    $0x0,%eax
80107faf:	e9 c1 00 00 00       	jmp    80108075 <allocuvm+0xd8>
  if(newsz < oldsz)
80107fb4:	8b 45 10             	mov    0x10(%ebp),%eax
80107fb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107fba:	73 08                	jae    80107fc4 <allocuvm+0x27>
    return oldsz;
80107fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fbf:	e9 b1 00 00 00       	jmp    80108075 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fc7:	05 ff 0f 00 00       	add    $0xfff,%eax
80107fcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107fd4:	e9 8d 00 00 00       	jmp    80108066 <allocuvm+0xc9>
    mem = kalloc();
80107fd9:	e8 e0 aa ff ff       	call   80102abe <kalloc>
80107fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107fe1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fe5:	75 2c                	jne    80108013 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107fe7:	c7 04 24 51 8a 10 80 	movl   $0x80108a51,(%esp)
80107fee:	e8 ae 83 ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ff6:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ffa:	8b 45 10             	mov    0x10(%ebp),%eax
80107ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
80108001:	8b 45 08             	mov    0x8(%ebp),%eax
80108004:	89 04 24             	mov    %eax,(%esp)
80108007:	e8 6b 00 00 00       	call   80108077 <deallocuvm>
      return 0;
8010800c:	b8 00 00 00 00       	mov    $0x0,%eax
80108011:	eb 62                	jmp    80108075 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108013:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010801a:	00 
8010801b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108022:	00 
80108023:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108026:	89 04 24             	mov    %eax,(%esp)
80108029:	e8 67 cf ff ff       	call   80104f95 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010802e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108031:	89 04 24             	mov    %eax,(%esp)
80108034:	e8 fd f5 ff ff       	call   80107636 <v2p>
80108039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010803c:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108043:	00 
80108044:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108048:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010804f:	00 
80108050:	89 54 24 04          	mov    %edx,0x4(%esp)
80108054:	8b 45 08             	mov    0x8(%ebp),%eax
80108057:	89 04 24             	mov    %eax,(%esp)
8010805a:	e8 e4 fa ff ff       	call   80107b43 <mappages>
  for(; a < newsz; a += PGSIZE){
8010805f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108069:	3b 45 10             	cmp    0x10(%ebp),%eax
8010806c:	0f 82 67 ff ff ff    	jb     80107fd9 <allocuvm+0x3c>
  }
  return newsz;
80108072:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108075:	c9                   	leave  
80108076:	c3                   	ret    

80108077 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108077:	55                   	push   %ebp
80108078:	89 e5                	mov    %esp,%ebp
8010807a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010807d:	8b 45 10             	mov    0x10(%ebp),%eax
80108080:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108083:	72 08                	jb     8010808d <deallocuvm+0x16>
    return oldsz;
80108085:	8b 45 0c             	mov    0xc(%ebp),%eax
80108088:	e9 a4 00 00 00       	jmp    80108131 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
8010808d:	8b 45 10             	mov    0x10(%ebp),%eax
80108090:	05 ff 0f 00 00       	add    $0xfff,%eax
80108095:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010809a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010809d:	e9 80 00 00 00       	jmp    80108122 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801080a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080ac:	00 
801080ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801080b1:	8b 45 08             	mov    0x8(%ebp),%eax
801080b4:	89 04 24             	mov    %eax,(%esp)
801080b7:	e8 e5 f9 ff ff       	call   80107aa1 <walkpgdir>
801080bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801080bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801080c3:	75 09                	jne    801080ce <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801080c5:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801080cc:	eb 4d                	jmp    8010811b <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801080ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080d1:	8b 00                	mov    (%eax),%eax
801080d3:	83 e0 01             	and    $0x1,%eax
801080d6:	85 c0                	test   %eax,%eax
801080d8:	74 41                	je     8010811b <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801080da:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080dd:	8b 00                	mov    (%eax),%eax
801080df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801080e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801080e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801080eb:	75 0c                	jne    801080f9 <deallocuvm+0x82>
        panic("kfree");
801080ed:	c7 04 24 69 8a 10 80 	movl   $0x80108a69,(%esp)
801080f4:	e8 3d 84 ff ff       	call   80100536 <panic>
      char *v = p2v(pa);
801080f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801080fc:	89 04 24             	mov    %eax,(%esp)
801080ff:	e8 3f f5 ff ff       	call   80107643 <p2v>
80108104:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108107:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010810a:	89 04 24             	mov    %eax,(%esp)
8010810d:	e8 13 a9 ff ff       	call   80102a25 <kfree>
      *pte = 0;
80108112:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108115:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
8010811b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108122:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108125:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108128:	0f 82 74 ff ff ff    	jb     801080a2 <deallocuvm+0x2b>
    }
  }
  return newsz;
8010812e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108131:	c9                   	leave  
80108132:	c3                   	ret    

80108133 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108133:	55                   	push   %ebp
80108134:	89 e5                	mov    %esp,%ebp
80108136:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108139:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010813d:	75 0c                	jne    8010814b <freevm+0x18>
    panic("freevm: no pgdir");
8010813f:	c7 04 24 6f 8a 10 80 	movl   $0x80108a6f,(%esp)
80108146:	e8 eb 83 ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010814b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108152:	00 
80108153:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010815a:	80 
8010815b:	8b 45 08             	mov    0x8(%ebp),%eax
8010815e:	89 04 24             	mov    %eax,(%esp)
80108161:	e8 11 ff ff ff       	call   80108077 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108166:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010816d:	eb 47                	jmp    801081b6 <freevm+0x83>
    if(pgdir[i] & PTE_P){
8010816f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108172:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108179:	8b 45 08             	mov    0x8(%ebp),%eax
8010817c:	01 d0                	add    %edx,%eax
8010817e:	8b 00                	mov    (%eax),%eax
80108180:	83 e0 01             	and    $0x1,%eax
80108183:	85 c0                	test   %eax,%eax
80108185:	74 2c                	je     801081b3 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108187:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108191:	8b 45 08             	mov    0x8(%ebp),%eax
80108194:	01 d0                	add    %edx,%eax
80108196:	8b 00                	mov    (%eax),%eax
80108198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010819d:	89 04 24             	mov    %eax,(%esp)
801081a0:	e8 9e f4 ff ff       	call   80107643 <p2v>
801081a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801081a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ab:	89 04 24             	mov    %eax,(%esp)
801081ae:	e8 72 a8 ff ff       	call   80102a25 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801081b3:	ff 45 f4             	incl   -0xc(%ebp)
801081b6:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801081bd:	76 b0                	jbe    8010816f <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
801081bf:	8b 45 08             	mov    0x8(%ebp),%eax
801081c2:	89 04 24             	mov    %eax,(%esp)
801081c5:	e8 5b a8 ff ff       	call   80102a25 <kfree>
}
801081ca:	c9                   	leave  
801081cb:	c3                   	ret    

801081cc <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801081cc:	55                   	push   %ebp
801081cd:	89 e5                	mov    %esp,%ebp
801081cf:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081d2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081d9:	00 
801081da:	8b 45 0c             	mov    0xc(%ebp),%eax
801081dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801081e1:	8b 45 08             	mov    0x8(%ebp),%eax
801081e4:	89 04 24             	mov    %eax,(%esp)
801081e7:	e8 b5 f8 ff ff       	call   80107aa1 <walkpgdir>
801081ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801081ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801081f3:	75 0c                	jne    80108201 <clearpteu+0x35>
    panic("clearpteu");
801081f5:	c7 04 24 80 8a 10 80 	movl   $0x80108a80,(%esp)
801081fc:	e8 35 83 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80108201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108204:	8b 00                	mov    (%eax),%eax
80108206:	89 c2                	mov    %eax,%edx
80108208:	83 e2 fb             	and    $0xfffffffb,%edx
8010820b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010820e:	89 10                	mov    %edx,(%eax)
}
80108210:	c9                   	leave  
80108211:	c3                   	ret    

80108212 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108212:	55                   	push   %ebp
80108213:	89 e5                	mov    %esp,%ebp
80108215:	53                   	push   %ebx
80108216:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108219:	e8 b9 f9 ff ff       	call   80107bd7 <setupkvm>
8010821e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108225:	75 0a                	jne    80108231 <copyuvm+0x1f>
    return 0;
80108227:	b8 00 00 00 00       	mov    $0x0,%eax
8010822c:	e9 fd 00 00 00       	jmp    8010832e <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108231:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108238:	e9 cc 00 00 00       	jmp    80108309 <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010823d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108240:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108247:	00 
80108248:	89 44 24 04          	mov    %eax,0x4(%esp)
8010824c:	8b 45 08             	mov    0x8(%ebp),%eax
8010824f:	89 04 24             	mov    %eax,(%esp)
80108252:	e8 4a f8 ff ff       	call   80107aa1 <walkpgdir>
80108257:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010825a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010825e:	75 0c                	jne    8010826c <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108260:	c7 04 24 8a 8a 10 80 	movl   $0x80108a8a,(%esp)
80108267:	e8 ca 82 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
8010826c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010826f:	8b 00                	mov    (%eax),%eax
80108271:	83 e0 01             	and    $0x1,%eax
80108274:	85 c0                	test   %eax,%eax
80108276:	75 0c                	jne    80108284 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108278:	c7 04 24 a4 8a 10 80 	movl   $0x80108aa4,(%esp)
8010827f:	e8 b2 82 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108284:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108287:	8b 00                	mov    (%eax),%eax
80108289:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010828e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108291:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108294:	8b 00                	mov    (%eax),%eax
80108296:	25 ff 0f 00 00       	and    $0xfff,%eax
8010829b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010829e:	e8 1b a8 ff ff       	call   80102abe <kalloc>
801082a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801082a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801082aa:	74 6e                	je     8010831a <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801082ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801082af:	89 04 24             	mov    %eax,(%esp)
801082b2:	e8 8c f3 ff ff       	call   80107643 <p2v>
801082b7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082be:	00 
801082bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801082c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082c6:	89 04 24             	mov    %eax,(%esp)
801082c9:	e8 93 cd ff ff       	call   80105061 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801082ce:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801082d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082d4:	89 04 24             	mov    %eax,(%esp)
801082d7:	e8 5a f3 ff ff       	call   80107636 <v2p>
801082dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082df:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801082e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
801082e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801082ee:	00 
801082ef:	89 54 24 04          	mov    %edx,0x4(%esp)
801082f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082f6:	89 04 24             	mov    %eax,(%esp)
801082f9:	e8 45 f8 ff ff       	call   80107b43 <mappages>
801082fe:	85 c0                	test   %eax,%eax
80108300:	78 1b                	js     8010831d <copyuvm+0x10b>
  for(i = 0; i < sz; i += PGSIZE){
80108302:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010830f:	0f 82 28 ff ff ff    	jb     8010823d <copyuvm+0x2b>
      goto bad;
  }
  return d;
80108315:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108318:	eb 14                	jmp    8010832e <copyuvm+0x11c>
      goto bad;
8010831a:	90                   	nop
8010831b:	eb 01                	jmp    8010831e <copyuvm+0x10c>
      goto bad;
8010831d:	90                   	nop

bad:
  freevm(d);
8010831e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108321:	89 04 24             	mov    %eax,(%esp)
80108324:	e8 0a fe ff ff       	call   80108133 <freevm>
  return 0;
80108329:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010832e:	83 c4 44             	add    $0x44,%esp
80108331:	5b                   	pop    %ebx
80108332:	5d                   	pop    %ebp
80108333:	c3                   	ret    

80108334 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108334:	55                   	push   %ebp
80108335:	89 e5                	mov    %esp,%ebp
80108337:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010833a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108341:	00 
80108342:	8b 45 0c             	mov    0xc(%ebp),%eax
80108345:	89 44 24 04          	mov    %eax,0x4(%esp)
80108349:	8b 45 08             	mov    0x8(%ebp),%eax
8010834c:	89 04 24             	mov    %eax,(%esp)
8010834f:	e8 4d f7 ff ff       	call   80107aa1 <walkpgdir>
80108354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108357:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835a:	8b 00                	mov    (%eax),%eax
8010835c:	83 e0 01             	and    $0x1,%eax
8010835f:	85 c0                	test   %eax,%eax
80108361:	75 07                	jne    8010836a <uva2ka+0x36>
    return 0;
80108363:	b8 00 00 00 00       	mov    $0x0,%eax
80108368:	eb 25                	jmp    8010838f <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010836a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010836d:	8b 00                	mov    (%eax),%eax
8010836f:	83 e0 04             	and    $0x4,%eax
80108372:	85 c0                	test   %eax,%eax
80108374:	75 07                	jne    8010837d <uva2ka+0x49>
    return 0;
80108376:	b8 00 00 00 00       	mov    $0x0,%eax
8010837b:	eb 12                	jmp    8010838f <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
8010837d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108380:	8b 00                	mov    (%eax),%eax
80108382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108387:	89 04 24             	mov    %eax,(%esp)
8010838a:	e8 b4 f2 ff ff       	call   80107643 <p2v>
}
8010838f:	c9                   	leave  
80108390:	c3                   	ret    

80108391 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108391:	55                   	push   %ebp
80108392:	89 e5                	mov    %esp,%ebp
80108394:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108397:	8b 45 10             	mov    0x10(%ebp),%eax
8010839a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010839d:	e9 89 00 00 00       	jmp    8010842b <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
801083a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801083a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801083ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801083b4:	8b 45 08             	mov    0x8(%ebp),%eax
801083b7:	89 04 24             	mov    %eax,(%esp)
801083ba:	e8 75 ff ff ff       	call   80108334 <uva2ka>
801083bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801083c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801083c6:	75 07                	jne    801083cf <copyout+0x3e>
      return -1;
801083c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083cd:	eb 6b                	jmp    8010843a <copyout+0xa9>
    n = PGSIZE - (va - va0);
801083cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801083d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801083d5:	89 d1                	mov    %edx,%ecx
801083d7:	29 c1                	sub    %eax,%ecx
801083d9:	89 c8                	mov    %ecx,%eax
801083db:	05 00 10 00 00       	add    $0x1000,%eax
801083e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801083e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e6:	3b 45 14             	cmp    0x14(%ebp),%eax
801083e9:	76 06                	jbe    801083f1 <copyout+0x60>
      n = len;
801083eb:	8b 45 14             	mov    0x14(%ebp),%eax
801083ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801083f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801083f7:	29 c2                	sub    %eax,%edx
801083f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083fc:	01 c2                	add    %eax,%edx
801083fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108401:	89 44 24 08          	mov    %eax,0x8(%esp)
80108405:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108408:	89 44 24 04          	mov    %eax,0x4(%esp)
8010840c:	89 14 24             	mov    %edx,(%esp)
8010840f:	e8 4d cc ff ff       	call   80105061 <memmove>
    len -= n;
80108414:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108417:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010841a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010841d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108420:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108423:	05 00 10 00 00       	add    $0x1000,%eax
80108428:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
8010842b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010842f:	0f 85 6d ff ff ff    	jne    801083a2 <copyout+0x11>
  }
  return 0;
80108435:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010843a:	c9                   	leave  
8010843b:	c3                   	ret    
