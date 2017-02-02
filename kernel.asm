
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
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp
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
8010003a:	c7 44 24 04 e0 81 10 	movl   $0x801081e0,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 5c 4a 00 00       	call   80104aaa <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
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
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 09 4a 00 00       	call   80104acb <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
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
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 24 4a 00 00       	call   80104b2d <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 cc 46 00 00       	call   801047f0 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
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
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 ac 49 00 00       	call   80104b2d <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 e7 81 10 80 	movl   $0x801081e7,(%esp)
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
801001ef:	c7 04 24 f8 81 10 80 	movl   $0x801081f8,(%esp)
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
80100229:	c7 04 24 ff 81 10 80 	movl   $0x801081ff,(%esp)
80100230:	e8 01 03 00 00       	call   80100536 <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 8a 48 00 00       	call   80104acb <acquire>

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
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

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
8010029d:	e8 27 46 00 00       	call   801048c9 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 7f 48 00 00       	call   80104b2d <release>
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
801003a7:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bc:	e8 0a 47 00 00       	call   80104acb <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 06 82 10 80 	movl   $0x80108206,(%esp)
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
801004ad:	c7 45 ec 0f 82 10 80 	movl   $0x8010820f,-0x14(%ebp)
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
80100528:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010052f:	e8 f9 45 00 00       	call   80104b2d <release>
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
80100541:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
80100548:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100551:	8a 00                	mov    (%eax),%al
80100553:	0f b6 c0             	movzbl %al,%eax
80100556:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055a:	c7 04 24 16 82 10 80 	movl   $0x80108216,(%esp)
80100561:	e8 3b fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
80100566:	8b 45 08             	mov    0x8(%ebp),%eax
80100569:	89 04 24             	mov    %eax,(%esp)
8010056c:	e8 30 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100571:	c7 04 24 25 82 10 80 	movl   $0x80108225,(%esp)
80100578:	e8 24 fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
8010057d:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100580:	89 44 24 04          	mov    %eax,0x4(%esp)
80100584:	8d 45 08             	lea    0x8(%ebp),%eax
80100587:	89 04 24             	mov    %eax,(%esp)
8010058a:	e8 ed 45 00 00       	call   80104b7c <getcallerpcs>
  for(i=0; i<10; i++)
8010058f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100596:	eb 1a                	jmp    801005b2 <panic+0x7c>
    cprintf(" %p", pcs[i]);
80100598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010059b:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
8010059f:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a3:	c7 04 24 27 82 10 80 	movl   $0x80108227,(%esp)
801005aa:	e8 f2 fd ff ff       	call   801003a1 <cprintf>
  for(i=0; i<10; i++)
801005af:	ff 45 f4             	incl   -0xc(%ebp)
801005b2:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005b6:	7e e0                	jle    80100598 <panic+0x62>
  panicked = 1; // freeze other CPU
801005b8:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
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
80100695:	e8 4f 47 00 00       	call   80104de9 <memmove>
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
801006c4:	e8 54 46 00 00       	call   80104d1d <memset>
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
80100739:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
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
80100759:	e8 f8 60 00 00       	call   80106856 <uartputc>
8010075e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100765:	e8 ec 60 00 00       	call   80106856 <uartputc>
8010076a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100771:	e8 e0 60 00 00       	call   80106856 <uartputc>
80100776:	eb 0b                	jmp    80100783 <consputc+0x50>
  } else
    uartputc(c);
80100778:	8b 45 08             	mov    0x8(%ebp),%eax
8010077b:	89 04 24             	mov    %eax,(%esp)
8010077e:	e8 d3 60 00 00       	call   80106856 <uartputc>
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
80100796:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010079d:	e8 29 43 00 00       	call   80104acb <acquire>
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
801007ca:	e8 9d 41 00 00       	call   8010496c <procdump>
      break;
801007cf:	e9 08 01 00 00       	jmp    801008dc <consoleintr+0x14c>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007d4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007d9:	48                   	dec    %eax
801007da:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
801007df:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801007e6:	e8 48 ff ff ff       	call   80100733 <consputc>
801007eb:	eb 01                	jmp    801007ee <consoleintr+0x5e>
      while(input.e != input.w &&
801007ed:	90                   	nop
801007ee:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
801007f4:	a1 58 de 10 80       	mov    0x8010de58,%eax
801007f9:	39 c2                	cmp    %eax,%edx
801007fb:	0f 84 d4 00 00 00    	je     801008d5 <consoleintr+0x145>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100801:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100806:	48                   	dec    %eax
80100807:	83 e0 7f             	and    $0x7f,%eax
8010080a:	8a 80 d4 dd 10 80    	mov    -0x7fef222c(%eax),%al
      while(input.e != input.w &&
80100810:	3c 0a                	cmp    $0xa,%al
80100812:	75 c0                	jne    801007d4 <consoleintr+0x44>
      }
      break;
80100814:	e9 bc 00 00 00       	jmp    801008d5 <consoleintr+0x145>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100819:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010081f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100824:	39 c2                	cmp    %eax,%edx
80100826:	0f 84 ac 00 00 00    	je     801008d8 <consoleintr+0x148>
        input.e--;
8010082c:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100831:	48                   	dec    %eax
80100832:	a3 5c de 10 80       	mov    %eax,0x8010de5c
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
80100852:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100858:	a1 54 de 10 80       	mov    0x8010de54,%eax
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
8010087b:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100880:	89 c1                	mov    %eax,%ecx
80100882:	83 e1 7f             	and    $0x7f,%ecx
80100885:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100888:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
8010088e:	40                   	inc    %eax
8010088f:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
80100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100897:	89 04 24             	mov    %eax,(%esp)
8010089a:	e8 94 fe ff ff       	call   80100733 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010089f:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008a3:	74 18                	je     801008bd <consoleintr+0x12d>
801008a5:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008a9:	74 12                	je     801008bd <consoleintr+0x12d>
801008ab:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008b0:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008b6:	83 ea 80             	sub    $0xffffff80,%edx
801008b9:	39 d0                	cmp    %edx,%eax
801008bb:	75 1e                	jne    801008db <consoleintr+0x14b>
          input.w = input.e;
801008bd:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008c2:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008c7:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008ce:	e8 f6 3f 00 00       	call   801048c9 <wakeup>
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
801008ee:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801008f5:	e8 33 42 00 00       	call   80104b2d <release>
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
80100913:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010091a:	e8 ac 41 00 00       	call   80104acb <acquire>
  while(n > 0){
8010091f:	e9 a1 00 00 00       	jmp    801009c5 <consoleread+0xc9>
    while(input.r == input.w){
      if(proc->killed){
80100924:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010092a:	8b 40 24             	mov    0x24(%eax),%eax
8010092d:	85 c0                	test   %eax,%eax
8010092f:	74 21                	je     80100952 <consoleread+0x56>
        release(&input.lock);
80100931:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100938:	e8 f0 41 00 00       	call   80104b2d <release>
        ilock(ip);
8010093d:	8b 45 08             	mov    0x8(%ebp),%eax
80100940:	89 04 24             	mov    %eax,(%esp)
80100943:	e8 fd 0e 00 00       	call   80101845 <ilock>
        return -1;
80100948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010094d:	e9 a2 00 00 00       	jmp    801009f4 <consoleread+0xf8>
      }
      sleep(&input.r, &input.lock);
80100952:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
80100959:	80 
8010095a:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
80100961:	e8 8a 3e 00 00       	call   801047f0 <sleep>
80100966:	eb 01                	jmp    80100969 <consoleread+0x6d>
    while(input.r == input.w){
80100968:	90                   	nop
80100969:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
8010096f:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100974:	39 c2                	cmp    %eax,%edx
80100976:	74 ac                	je     80100924 <consoleread+0x28>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100978:	a1 54 de 10 80       	mov    0x8010de54,%eax
8010097d:	89 c2                	mov    %eax,%edx
8010097f:	83 e2 7f             	and    $0x7f,%edx
80100982:	8a 92 d4 dd 10 80    	mov    -0x7fef222c(%edx),%dl
80100988:	0f be d2             	movsbl %dl,%edx
8010098b:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010098e:	40                   	inc    %eax
8010098f:	a3 54 de 10 80       	mov    %eax,0x8010de54
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
801009a2:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009a7:	48                   	dec    %eax
801009a8:	a3 54 de 10 80       	mov    %eax,0x8010de54
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
801009d1:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801009d8:	e8 50 41 00 00       	call   80104b2d <release>
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
80100a07:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a0e:	e8 b8 40 00 00       	call   80104acb <acquire>
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
80100a41:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a48:	e8 e0 40 00 00       	call   80104b2d <release>
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
80100a63:	c7 44 24 04 2b 82 10 	movl   $0x8010822b,0x4(%esp)
80100a6a:	80 
80100a6b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a72:	e8 33 40 00 00       	call   80104aaa <initlock>
  initlock(&input.lock, "input");
80100a77:	c7 44 24 04 33 82 10 	movl   $0x80108233,0x4(%esp)
80100a7e:	80 
80100a7f:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a86:	e8 1f 40 00 00       	call   80104aaa <initlock>

  devsw[CONSOLE].write = consolewrite;
80100a8b:	c7 05 0c e8 10 80 f6 	movl   $0x801009f6,0x8010e80c
80100a92:	09 10 80 
  devsw[CONSOLE].read = consoleread;
80100a95:	c7 05 08 e8 10 80 fc 	movl   $0x801008fc,0x8010e808
80100a9c:	08 10 80 
  cons.locking = 1;
80100a9f:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
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
80100b43:	e8 32 6e 00 00       	call   8010797a <setupkvm>
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
80100bdc:	e8 5f 71 00 00       	call   80107d40 <allocuvm>
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
80100c19:	e8 33 70 00 00       	call   80107c51 <loaduvm>
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
80100c82:	e8 b9 70 00 00       	call   80107d40 <allocuvm>
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
80100ca6:	e8 c4 72 00 00       	call   80107f6f <clearpteu>
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
80100cdb:	e8 98 42 00 00       	call   80104f78 <strlen>
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
80100d03:	e8 70 42 00 00       	call   80104f78 <strlen>
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
80100d31:	e8 fe 73 00 00       	call   80108134 <copyout>
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
80100dd4:	e8 5b 73 00 00       	call   80108134 <copyout>
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
80100e26:	e8 04 41 00 00       	call   80104f2f <safestrcpy>

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
80100e78:	e8 ee 6b 00 00       	call   80107a6b <switchuvm>
  freevm(oldpgdir);
80100e7d:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100e80:	89 04 24             	mov    %eax,(%esp)
80100e83:	e8 4e 70 00 00       	call   80107ed6 <freevm>
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
80100eba:	e8 17 70 00 00       	call   80107ed6 <freevm>
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
80100edd:	c7 44 24 04 39 82 10 	movl   $0x80108239,0x4(%esp)
80100ee4:	80 
80100ee5:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100eec:	e8 b9 3b 00 00       	call   80104aaa <initlock>
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
80100ef9:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f00:	e8 c6 3b 00 00       	call   80104acb <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f05:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
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
80100f22:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f29:	e8 ff 3b 00 00       	call   80104b2d <release>
      return f;
80100f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f31:	eb 1e                	jmp    80100f51 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f33:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f37:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f3e:	72 ce                	jb     80100f0e <filealloc+0x1b>
    }
  }
  release(&ftable.lock);
80100f40:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f47:	e8 e1 3b 00 00       	call   80104b2d <release>
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
80100f59:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f60:	e8 66 3b 00 00       	call   80104acb <acquire>
  if(f->ref < 1)
80100f65:	8b 45 08             	mov    0x8(%ebp),%eax
80100f68:	8b 40 04             	mov    0x4(%eax),%eax
80100f6b:	85 c0                	test   %eax,%eax
80100f6d:	7f 0c                	jg     80100f7b <filedup+0x28>
    panic("filedup");
80100f6f:	c7 04 24 40 82 10 80 	movl   $0x80108240,(%esp)
80100f76:	e8 bb f5 ff ff       	call   80100536 <panic>
  f->ref++;
80100f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	8d 50 01             	lea    0x1(%eax),%edx
80100f84:	8b 45 08             	mov    0x8(%ebp),%eax
80100f87:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100f8a:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f91:	e8 97 3b 00 00       	call   80104b2d <release>
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
80100fa4:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fab:	e8 1b 3b 00 00       	call   80104acb <acquire>
  if(f->ref < 1)
80100fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb3:	8b 40 04             	mov    0x4(%eax),%eax
80100fb6:	85 c0                	test   %eax,%eax
80100fb8:	7f 0c                	jg     80100fc6 <fileclose+0x2b>
    panic("fileclose");
80100fba:	c7 04 24 48 82 10 80 	movl   $0x80108248,(%esp)
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
80100fdf:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fe6:	e8 42 3b 00 00       	call   80104b2d <release>
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
80101015:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
8010101c:	e8 0c 3b 00 00       	call   80104b2d <release>
  
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
80101161:	c7 04 24 52 82 10 80 	movl   $0x80108252,(%esp)
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
8010126c:	c7 04 24 5b 82 10 80 	movl   $0x8010825b,(%esp)
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
801012a1:	c7 04 24 6b 82 10 80 	movl   $0x8010826b,(%esp)
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
801012e7:	e8 fd 3a 00 00       	call   80104de9 <memmove>
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
8010132d:	e8 eb 39 00 00       	call   80104d1d <memset>
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
80101495:	c7 04 24 75 82 10 80 	movl   $0x80108275,(%esp)
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
80101538:	c7 04 24 8b 82 10 80 	movl   $0x8010828b,(%esp)
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
8010158d:	c7 44 24 04 9e 82 10 	movl   $0x8010829e,0x4(%esp)
80101594:	80 
80101595:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010159c:	e8 09 35 00 00       	call   80104aaa <initlock>
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
80101626:	e8 f2 36 00 00       	call   80104d1d <memset>
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
8010167d:	c7 04 24 a5 82 10 80 	movl   $0x801082a5,(%esp)
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
80101724:	e8 c0 36 00 00       	call   80104de9 <memmove>
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
80101747:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010174e:	e8 78 33 00 00       	call   80104acb <acquire>

  // Is the inode already cached?
  empty = 0;
80101753:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010175a:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
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
80101791:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101798:	e8 90 33 00 00       	call   80104b2d <release>
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
801017bc:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
801017c3:	72 9e                	jb     80101763 <iget+0x22>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017c9:	75 0c                	jne    801017d7 <iget+0x96>
    panic("iget: no inodes");
801017cb:	c7 04 24 b7 82 10 80 	movl   $0x801082b7,(%esp)
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
80101802:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101809:	e8 1f 33 00 00       	call   80104b2d <release>

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
80101819:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101820:	e8 a6 32 00 00       	call   80104acb <acquire>
  ip->ref++;
80101825:	8b 45 08             	mov    0x8(%ebp),%eax
80101828:	8b 40 08             	mov    0x8(%eax),%eax
8010182b:	8d 50 01             	lea    0x1(%eax),%edx
8010182e:	8b 45 08             	mov    0x8(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101834:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010183b:	e8 ed 32 00 00       	call   80104b2d <release>
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
8010185b:	c7 04 24 c7 82 10 80 	movl   $0x801082c7,(%esp)
80101862:	e8 cf ec ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
80101867:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010186e:	e8 58 32 00 00       	call   80104acb <acquire>
  while(ip->flags & I_BUSY)
80101873:	eb 13                	jmp    80101888 <ilock+0x43>
    sleep(ip, &icache.lock);
80101875:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
8010187c:	80 
8010187d:	8b 45 08             	mov    0x8(%ebp),%eax
80101880:	89 04 24             	mov    %eax,(%esp)
80101883:	e8 68 2f 00 00       	call   801047f0 <sleep>
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
801018a6:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018ad:	e8 7b 32 00 00       	call   80104b2d <release>

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
80101956:	e8 8e 34 00 00       	call   80104de9 <memmove>
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
80101982:	c7 04 24 cd 82 10 80 	movl   $0x801082cd,(%esp)
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
801019b3:	c7 04 24 dc 82 10 80 	movl   $0x801082dc,(%esp)
801019ba:	e8 77 eb ff ff       	call   80100536 <panic>

  acquire(&icache.lock);
801019bf:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019c6:	e8 00 31 00 00       	call   80104acb <acquire>
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
801019e2:	e8 e2 2e 00 00       	call   801048c9 <wakeup>
  release(&icache.lock);
801019e7:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019ee:	e8 3a 31 00 00       	call   80104b2d <release>
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
801019fb:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a02:	e8 c4 30 00 00       	call   80104acb <acquire>
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
80101a40:	c7 04 24 e4 82 10 80 	movl   $0x801082e4,(%esp)
80101a47:	e8 ea ea ff ff       	call   80100536 <panic>
    ip->flags |= I_BUSY;
80101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a4f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a52:	89 c2                	mov    %eax,%edx
80101a54:	83 ca 01             	or     $0x1,%edx
80101a57:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5a:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a5d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a64:	e8 c4 30 00 00       	call   80104b2d <release>
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
80101a88:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a8f:	e8 37 30 00 00       	call   80104acb <acquire>
    ip->flags = 0;
80101a94:	8b 45 08             	mov    0x8(%ebp),%eax
80101a97:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	89 04 24             	mov    %eax,(%esp)
80101aa4:	e8 20 2e 00 00       	call   801048c9 <wakeup>
  }
  ip->ref--;
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 40 08             	mov    0x8(%eax),%eax
80101aaf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ab2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ab8:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101abf:	e8 69 30 00 00       	call   80104b2d <release>
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
80101bdf:	c7 04 24 ee 82 10 80 	movl   $0x801082ee,(%esp)
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
80101d7f:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101d86:	85 c0                	test   %eax,%eax
80101d88:	75 0a                	jne    80101d94 <readi+0x48>
      return -1;
80101d8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d8f:	e9 1b 01 00 00       	jmp    80101eaf <readi+0x163>
    return devsw[ip->major].read(ip, dst, n);
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	66 8b 40 12          	mov    0x12(%eax),%ax
80101d9b:	98                   	cwtl   
80101d9c:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
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
80101e7e:	e8 66 2f 00 00       	call   80104de9 <memmove>
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
80101ee4:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101eeb:	85 c0                	test   %eax,%eax
80101eed:	75 0a                	jne    80101ef9 <writei+0x48>
      return -1;
80101eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef4:	e9 46 01 00 00       	jmp    8010203f <writei+0x18e>
    return devsw[ip->major].write(ip, src, n);
80101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
80101efc:	66 8b 40 12          	mov    0x12(%eax),%ax
80101f00:	98                   	cwtl   
80101f01:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
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
80101fde:	e8 06 2e 00 00       	call   80104de9 <memmove>
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
8010205c:	e8 24 2e 00 00       	call   80104e85 <strncmp>
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
80102075:	c7 04 24 01 83 10 80 	movl   $0x80108301,(%esp)
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
801020b3:	c7 04 24 13 83 10 80 	movl   $0x80108313,(%esp)
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
80102195:	c7 04 24 13 83 10 80 	movl   $0x80108313,(%esp)
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
801021da:	e8 f6 2c 00 00       	call   80104ed5 <strncpy>
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
8010220c:	c7 04 24 20 83 10 80 	movl   $0x80108320,(%esp)
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
8010228d:	e8 57 2b 00 00       	call   80104de9 <memmove>
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
801022a8:	e8 3c 2b 00 00       	call   80104de9 <memmove>
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
801024fb:	c7 44 24 04 28 83 10 	movl   $0x80108328,0x4(%esp)
80102502:	80 
80102503:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010250a:	e8 9b 25 00 00       	call   80104aaa <initlock>
  picenable(IRQ_IDE);
8010250f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102516:	e8 86 15 00 00       	call   80103aa1 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010251b:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
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
8010256a:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
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
801025a4:	c7 04 24 2c 83 10 80 	movl   $0x8010832c,(%esp)
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
801026c3:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026ca:	e8 fc 23 00 00       	call   80104acb <acquire>
  if((b = idequeue) == 0){
801026cf:	a1 34 b6 10 80       	mov    0x8010b634,%eax
801026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801026db:	75 11                	jne    801026ee <ideintr+0x31>
    release(&idelock);
801026dd:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026e4:	e8 44 24 00 00       	call   80104b2d <release>
    // cprintf("spurious IDE interrupt\n");
    return;
801026e9:	e9 90 00 00 00       	jmp    8010277e <ideintr+0xc1>
  }
  idequeue = b->qnext;
801026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026f1:	8b 40 14             	mov    0x14(%eax),%eax
801026f4:	a3 34 b6 10 80       	mov    %eax,0x8010b634

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
80102757:	e8 6d 21 00 00       	call   801048c9 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
8010275c:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102761:	85 c0                	test   %eax,%eax
80102763:	74 0d                	je     80102772 <ideintr+0xb5>
    idestart(idequeue);
80102765:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010276a:	89 04 24             	mov    %eax,(%esp)
8010276d:	e8 26 fe ff ff       	call   80102598 <idestart>

  release(&idelock);
80102772:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102779:	e8 af 23 00 00       	call   80104b2d <release>
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
80102792:	c7 04 24 35 83 10 80 	movl   $0x80108335,(%esp)
80102799:	e8 98 dd ff ff       	call   80100536 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010279e:	8b 45 08             	mov    0x8(%ebp),%eax
801027a1:	8b 00                	mov    (%eax),%eax
801027a3:	83 e0 06             	and    $0x6,%eax
801027a6:	83 f8 02             	cmp    $0x2,%eax
801027a9:	75 0c                	jne    801027b7 <iderw+0x37>
    panic("iderw: nothing to do");
801027ab:	c7 04 24 49 83 10 80 	movl   $0x80108349,(%esp)
801027b2:	e8 7f dd ff ff       	call   80100536 <panic>
  if(b->dev != 0 && !havedisk1)
801027b7:	8b 45 08             	mov    0x8(%ebp),%eax
801027ba:	8b 40 04             	mov    0x4(%eax),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	74 15                	je     801027d6 <iderw+0x56>
801027c1:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027c6:	85 c0                	test   %eax,%eax
801027c8:	75 0c                	jne    801027d6 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027ca:	c7 04 24 5e 83 10 80 	movl   $0x8010835e,(%esp)
801027d1:	e8 60 dd ff ff       	call   80100536 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801027d6:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027dd:	e8 e9 22 00 00       	call   80104acb <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801027e2:	8b 45 08             	mov    0x8(%ebp),%eax
801027e5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ec:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
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
80102811:	a1 34 b6 10 80       	mov    0x8010b634,%eax
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
80102828:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
8010282f:	80 
80102830:	8b 45 08             	mov    0x8(%ebp),%eax
80102833:	89 04 24             	mov    %eax,(%esp)
80102836:	e8 b5 1f 00 00       	call   801047f0 <sleep>
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
8010284b:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102852:	e8 d6 22 00 00       	call   80104b2d <release>
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
8010285c:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102861:	8b 55 08             	mov    0x8(%ebp),%edx
80102864:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102866:	a1 34 f8 10 80       	mov    0x8010f834,%eax
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
80102873:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102878:	8b 55 08             	mov    0x8(%ebp),%edx
8010287b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010287d:	a1 34 f8 10 80       	mov    0x8010f834,%eax
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
80102890:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102895:	85 c0                	test   %eax,%eax
80102897:	0f 84 9a 00 00 00    	je     80102937 <ioapicinit+0xad>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
8010289d:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
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
801028d0:	a0 00 f9 10 80       	mov    0x8010f900,%al
801028d5:	0f b6 c0             	movzbl %al,%eax
801028d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801028db:	74 0c                	je     801028e9 <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801028dd:	c7 04 24 7c 83 10 80 	movl   $0x8010837c,(%esp)
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
80102940:	a1 04 f9 10 80       	mov    0x8010f904,%eax
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
80102996:	c7 44 24 04 ae 83 10 	movl   $0x801083ae,0x4(%esp)
8010299d:	80 
8010299e:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029a5:	e8 00 21 00 00       	call   80104aaa <initlock>
  kmem.use_lock = 0;
801029aa:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
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
801029e0:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
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
80102a37:	81 7d 08 fc 27 11 80 	cmpl   $0x801127fc,0x8(%ebp)
80102a3e:	72 12                	jb     80102a52 <kfree+0x2d>
80102a40:	8b 45 08             	mov    0x8(%ebp),%eax
80102a43:	89 04 24             	mov    %eax,(%esp)
80102a46:	e8 38 ff ff ff       	call   80102983 <v2p>
80102a4b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a50:	76 0c                	jbe    80102a5e <kfree+0x39>
    panic("kfree");
80102a52:	c7 04 24 b3 83 10 80 	movl   $0x801083b3,(%esp)
80102a59:	e8 d8 da ff ff       	call   80100536 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102a65:	00 
80102a66:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102a6d:	00 
80102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a71:	89 04 24             	mov    %eax,(%esp)
80102a74:	e8 a4 22 00 00       	call   80104d1d <memset>

  if(kmem.use_lock)
80102a79:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102a7e:	85 c0                	test   %eax,%eax
80102a80:	74 0c                	je     80102a8e <kfree+0x69>
    acquire(&kmem.lock);
80102a82:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102a89:	e8 3d 20 00 00       	call   80104acb <acquire>
  r = (struct run*)v;
80102a8e:	8b 45 08             	mov    0x8(%ebp),%eax
80102a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102a94:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a9d:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa2:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102aa7:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102aac:	85 c0                	test   %eax,%eax
80102aae:	74 0c                	je     80102abc <kfree+0x97>
    release(&kmem.lock);
80102ab0:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ab7:	e8 71 20 00 00       	call   80104b2d <release>
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
80102ac4:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102ac9:	85 c0                	test   %eax,%eax
80102acb:	74 0c                	je     80102ad9 <kalloc+0x1b>
    acquire(&kmem.lock);
80102acd:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102ad4:	e8 f2 1f 00 00       	call   80104acb <acquire>
  r = kmem.freelist;
80102ad9:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102ade:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102ae1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102ae5:	74 0a                	je     80102af1 <kalloc+0x33>
    kmem.freelist = r->next;
80102ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aea:	8b 00                	mov    (%eax),%eax
80102aec:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102af1:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102af6:	85 c0                	test   %eax,%eax
80102af8:	74 0c                	je     80102b06 <kalloc+0x48>
    release(&kmem.lock);
80102afa:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b01:	e8 27 20 00 00       	call   80104b2d <release>
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
80102b7a:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102b7f:	83 c8 40             	or     $0x40,%eax
80102b82:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
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
80102b9d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
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
80102bcb:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bd0:	21 d0                	and    %edx,%eax
80102bd2:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bd7:	b8 00 00 00 00       	mov    $0x0,%eax
80102bdc:	e9 9f 00 00 00       	jmp    80102c80 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102be1:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102be6:	83 e0 40             	and    $0x40,%eax
80102be9:	85 c0                	test   %eax,%eax
80102beb:	74 14                	je     80102c01 <kbdgetc+0xce>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bed:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102bf4:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bf9:	83 e0 bf             	and    $0xffffffbf,%eax
80102bfc:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c04:	05 20 90 10 80       	add    $0x80109020,%eax
80102c09:	8a 00                	mov    (%eax),%al
80102c0b:	0f b6 d0             	movzbl %al,%edx
80102c0e:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c13:	09 d0                	or     %edx,%eax
80102c15:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c1d:	05 20 91 10 80       	add    $0x80109120,%eax
80102c22:	8a 00                	mov    (%eax),%al
80102c24:	0f b6 d0             	movzbl %al,%edx
80102c27:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c2c:	31 d0                	xor    %edx,%eax
80102c2e:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c33:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c38:	83 e0 03             	and    $0x3,%eax
80102c3b:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c45:	01 d0                	add    %edx,%eax
80102c47:	8a 00                	mov    (%eax),%al
80102c49:	0f b6 c0             	movzbl %al,%eax
80102c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c4f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
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
80102cca:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ccf:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd2:	c1 e2 02             	shl    $0x2,%edx
80102cd5:	01 c2                	add    %eax,%edx
80102cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80102cda:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102cdc:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
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
80102cee:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
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
80102d73:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
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
80102e17:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
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
80102e59:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102e5e:	85 c0                	test   %eax,%eax
80102e60:	0f 94 c2             	sete   %dl
80102e63:	40                   	inc    %eax
80102e64:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102e69:	84 d2                	test   %dl,%dl
80102e6b:	74 13                	je     80102e80 <cpunum+0x3b>
      cprintf("cpu called from %x with interrupts enabled\n",
80102e6d:	8b 45 04             	mov    0x4(%ebp),%eax
80102e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80102e74:	c7 04 24 bc 83 10 80 	movl   $0x801083bc,(%esp)
80102e7b:	e8 21 d5 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102e80:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e85:	85 c0                	test   %eax,%eax
80102e87:	74 0f                	je     80102e98 <cpunum+0x53>
    return lapic[ID]>>24;
80102e89:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
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
80102ea5:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
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
80102fcb:	c7 44 24 04 e8 83 10 	movl   $0x801083e8,0x4(%esp)
80102fd2:	80 
80102fd3:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80102fda:	e8 cb 1a 00 00       	call   80104aaa <initlock>
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
80102ffe:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
80103003:	8b 45 94             	mov    -0x6c(%ebp),%eax
80103006:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
8010300b:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
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
8010302e:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
80103034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103037:	01 d0                	add    %edx,%eax
80103039:	40                   	inc    %eax
8010303a:	89 c2                	mov    %eax,%edx
8010303c:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103041:	89 54 24 04          	mov    %edx,0x4(%esp)
80103045:	89 04 24             	mov    %eax,(%esp)
80103048:	e8 59 d1 ff ff       	call   801001a6 <bread>
8010304d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
80103050:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103053:	83 c0 10             	add    $0x10,%eax
80103056:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
8010305d:	89 c2                	mov    %eax,%edx
8010305f:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
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
8010308e:	e8 56 1d 00 00       	call   80104de9 <memmove>
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
801030b7:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
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
801030cd:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
801030d2:	89 c2                	mov    %eax,%edx
801030d4:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
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
801030f6:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
801030fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103102:	eb 1a                	jmp    8010311e <read_head+0x57>
    log.lh.sector[i] = lh->sector[i];
80103104:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103107:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010310a:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010310e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103111:	83 c2 10             	add    $0x10,%edx
80103114:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010311b:	ff 45 f4             	incl   -0xc(%ebp)
8010311e:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
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
8010313b:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
80103140:	89 c2                	mov    %eax,%edx
80103142:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
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
8010315f:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
80103165:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103168:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010316a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103171:	eb 1a                	jmp    8010318d <write_head+0x58>
    hb->sector[i] = log.lh.sector[i];
80103173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103176:	83 c0 10             	add    $0x10,%eax
80103179:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
80103180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103183:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103186:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010318a:	ff 45 f4             	incl   -0xc(%ebp)
8010318d:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
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
801031bf:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
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
801031d6:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031dd:	e8 e9 18 00 00       	call   80104acb <acquire>
  while (log.busy) {
801031e2:	eb 14                	jmp    801031f8 <begin_trans+0x28>
    sleep(&log, &log.lock);
801031e4:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
801031eb:	80 
801031ec:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801031f3:	e8 f8 15 00 00       	call   801047f0 <sleep>
  while (log.busy) {
801031f8:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801031fd:	85 c0                	test   %eax,%eax
801031ff:	75 e3                	jne    801031e4 <begin_trans+0x14>
  }
  log.busy = 1;
80103201:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103208:	00 00 00 
  release(&log.lock);
8010320b:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103212:	e8 16 19 00 00       	call   80104b2d <release>
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
8010321f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103224:	85 c0                	test   %eax,%eax
80103226:	7e 19                	jle    80103241 <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103228:	e8 08 ff ff ff       	call   80103135 <write_head>
    install_trans(); // Now install writes to home locations
8010322d:	e8 ea fd ff ff       	call   8010301c <install_trans>
    log.lh.n = 0; 
80103232:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103239:	00 00 00 
    write_head();    // Erase the transaction from the log
8010323c:	e8 f4 fe ff ff       	call   80103135 <write_head>
  }
  
  acquire(&log.lock);
80103241:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103248:	e8 7e 18 00 00       	call   80104acb <acquire>
  log.busy = 0;
8010324d:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
80103254:	00 00 00 
  wakeup(&log);
80103257:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010325e:	e8 66 16 00 00       	call   801048c9 <wakeup>
  release(&log.lock);
80103263:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010326a:	e8 be 18 00 00       	call   80104b2d <release>
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
80103277:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010327c:	83 f8 09             	cmp    $0x9,%eax
8010327f:	7f 10                	jg     80103291 <log_write+0x20>
80103281:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103286:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
8010328c:	4a                   	dec    %edx
8010328d:	39 d0                	cmp    %edx,%eax
8010328f:	7c 0c                	jl     8010329d <log_write+0x2c>
    panic("too big a transaction");
80103291:	c7 04 24 ec 83 10 80 	movl   $0x801083ec,(%esp)
80103298:	e8 99 d2 ff ff       	call   80100536 <panic>
  if (!log.busy)
8010329d:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032a2:	85 c0                	test   %eax,%eax
801032a4:	75 0c                	jne    801032b2 <log_write+0x41>
    panic("write outside of trans");
801032a6:	c7 04 24 02 84 10 80 	movl   $0x80108402,(%esp)
801032ad:	e8 84 d2 ff ff       	call   80100536 <panic>

  for (i = 0; i < log.lh.n; i++) {
801032b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032b9:	eb 1c                	jmp    801032d7 <log_write+0x66>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
801032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032be:	83 c0 10             	add    $0x10,%eax
801032c1:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801032c8:	89 c2                	mov    %eax,%edx
801032ca:	8b 45 08             	mov    0x8(%ebp),%eax
801032cd:	8b 40 08             	mov    0x8(%eax),%eax
801032d0:	39 c2                	cmp    %eax,%edx
801032d2:	74 0f                	je     801032e3 <log_write+0x72>
  for (i = 0; i < log.lh.n; i++) {
801032d4:	ff 45 f4             	incl   -0xc(%ebp)
801032d7:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
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
801032f0:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
801032f7:	8b 15 b4 f8 10 80    	mov    0x8010f8b4,%edx
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
80103335:	e8 af 1a 00 00       	call   80104de9 <memmove>
  bwrite(lbuf);
8010333a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010333d:	89 04 24             	mov    %eax,(%esp)
80103340:	e8 98 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103345:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103348:	89 04 24             	mov    %eax,(%esp)
8010334b:	e8 c7 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
80103350:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103355:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103358:	75 0b                	jne    80103365 <log_write+0xf4>
    log.lh.n++;
8010335a:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010335f:	40                   	inc    %eax
80103360:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
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
801033c6:	c7 04 24 fc 27 11 80 	movl   $0x801127fc,(%esp)
801033cd:	e8 be f5 ff ff       	call   80102990 <kinit1>
  kvmalloc();      // kernel page table
801033d2:	e8 60 46 00 00       	call   80107a37 <kvmalloc>
  mpinit();        // collect info about this machine
801033d7:	e8 93 04 00 00       	call   8010386f <mpinit>
  lapicinit();
801033dc:	e8 07 f9 ff ff       	call   80102ce8 <lapicinit>
  seginit();       // set up segments
801033e1:	e8 0d 40 00 00       	call   801073f3 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801033e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801033ec:	8a 00                	mov    (%eax),%al
801033ee:	0f b6 c0             	movzbl %al,%eax
801033f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801033f5:	c7 04 24 19 84 10 80 	movl   $0x80108419,(%esp)
801033fc:	e8 a0 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
80103401:	e8 cf 06 00 00       	call   80103ad5 <picinit>
  ioapicinit();    // another interrupt controller
80103406:	e8 7f f4 ff ff       	call   8010288a <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010340b:	e8 4d d6 ff ff       	call   80100a5d <consoleinit>
  uartinit();      // serial port
80103410:	e8 33 33 00 00       	call   80106748 <uartinit>
  pinit();         // process table
80103415:	e8 c9 0b 00 00       	call   80103fe3 <pinit>
  tvinit();        // trap vectors
8010341a:	e8 80 2e 00 00       	call   8010629f <tvinit>
  binit();         // buffer cache
8010341f:	e8 10 cc ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103424:	e8 ae da ff ff       	call   80100ed7 <fileinit>
  iinit();         // inode cache
80103429:	e8 59 e1 ff ff       	call   80101587 <iinit>
  ideinit();       // disk
8010342e:	e8 c2 f0 ff ff       	call   801024f5 <ideinit>
  if(!ismp)
80103433:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103438:	85 c0                	test   %eax,%eax
8010343a:	75 05                	jne    80103441 <main+0x8c>
    timerinit();   // uniprocessor timer
8010343c:	e8 a6 2d 00 00       	call   801061e7 <timerinit>
  startothers();   // start other processors
80103441:	e8 7e 00 00 00       	call   801034c4 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103446:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
8010344d:	8e 
8010344e:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80103455:	e8 6e f5 ff ff       	call   801029c8 <kinit2>
  userinit();      // first user process
8010345a:	e8 9d 0c 00 00       	call   801040fc <userinit>
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
8010346a:	e8 df 45 00 00       	call   80107a4e <switchkvm>
  seginit();
8010346f:	e8 7f 3f 00 00       	call   801073f3 <seginit>
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
80103493:	c7 04 24 30 84 10 80 	movl   $0x80108430,(%esp)
8010349a:	e8 02 cf ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
8010349f:	e8 58 2f 00 00       	call   801063fc <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801034a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034aa:	05 a8 00 00 00       	add    $0xa8,%eax
801034af:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801034b6:	00 
801034b7:	89 04 24             	mov    %eax,(%esp)
801034ba:	e8 d1 fe ff ff       	call   80103390 <xchg>
  scheduler();     // start running processes
801034bf:	e8 79 11 00 00       	call   8010463d <scheduler>

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
801034e3:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
801034ea:	80 
801034eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034ee:	89 04 24             	mov    %eax,(%esp)
801034f1:	e8 f3 18 00 00       	call   80104de9 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801034f6:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
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
80103517:	05 20 f9 10 80       	add    $0x8010f920,%eax
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
80103591:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103596:	89 c2                	mov    %eax,%edx
80103598:	89 d0                	mov    %edx,%eax
8010359a:	d1 e0                	shl    %eax
8010359c:	01 d0                	add    %edx,%eax
8010359e:	c1 e0 04             	shl    $0x4,%eax
801035a1:	29 d0                	sub    %edx,%eax
801035a3:	c1 e0 02             	shl    $0x2,%eax
801035a6:	05 20 f9 10 80       	add    $0x8010f920,%eax
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
8010360e:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103613:	89 c2                	mov    %eax,%edx
80103615:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
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
801036c9:	c7 44 24 04 44 84 10 	movl   $0x80108444,0x4(%esp)
801036d0:	80 
801036d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d4:	89 04 24             	mov    %eax,(%esp)
801036d7:	e8 b8 16 00 00       	call   80104d94 <memcmp>
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
80103806:	c7 44 24 04 49 84 10 	movl   $0x80108449,0x4(%esp)
8010380d:	80 
8010380e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103811:	89 04 24             	mov    %eax,(%esp)
80103814:	e8 7b 15 00 00       	call   80104d94 <memcmp>
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
80103875:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
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
80103897:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
8010389e:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a4:	8b 40 24             	mov    0x24(%eax),%eax
801038a7:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
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
801038dc:	8b 04 85 8c 84 10 80 	mov    -0x7fef7b74(,%eax,4),%eax
801038e3:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801038e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801038eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
801038ee:	8a 40 01             	mov    0x1(%eax),%al
801038f1:	0f b6 d0             	movzbl %al,%edx
801038f4:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801038f9:	39 c2                	cmp    %eax,%edx
801038fb:	74 2c                	je     80103929 <mpinit+0xba>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801038fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103900:	8a 40 01             	mov    0x1(%eax),%al
80103903:	0f b6 d0             	movzbl %al,%edx
80103906:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010390b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010390f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103913:	c7 04 24 4e 84 10 80 	movl   $0x8010844e,(%esp)
8010391a:	e8 82 ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
8010391f:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
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
80103939:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
8010393f:	89 d0                	mov    %edx,%eax
80103941:	d1 e0                	shl    %eax
80103943:	01 d0                	add    %edx,%eax
80103945:	c1 e0 04             	shl    $0x4,%eax
80103948:	29 d0                	sub    %edx,%eax
8010394a:	c1 e0 02             	shl    $0x2,%eax
8010394d:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103952:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103957:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
8010395d:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103962:	88 c1                	mov    %al,%cl
80103964:	89 d0                	mov    %edx,%eax
80103966:	d1 e0                	shl    %eax
80103968:	01 d0                	add    %edx,%eax
8010396a:	c1 e0 04             	shl    $0x4,%eax
8010396d:	29 d0                	sub    %edx,%eax
8010396f:	c1 e0 02             	shl    $0x2,%eax
80103972:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103977:	88 08                	mov    %cl,(%eax)
      ncpu++;
80103979:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010397e:	40                   	inc    %eax
8010397f:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
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
80103996:	a2 00 f9 10 80       	mov    %al,0x8010f900
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
801039b3:	c7 04 24 6c 84 10 80 	movl   $0x8010846c,(%esp)
801039ba:	e8 e2 c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039bf:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801039c6:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039cf:	0f 82 f6 fe ff ff    	jb     801038cb <mpinit+0x5c>
    }
  }
  if(!ismp){
801039d5:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801039da:	85 c0                	test   %eax,%eax
801039dc:	75 1d                	jne    801039fb <mpinit+0x18c>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039de:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
801039e5:	00 00 00 
    lapic = 0;
801039e8:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
801039ef:	00 00 00 
    ioapicid = 0;
801039f2:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
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
80103ca9:	c7 44 24 04 a0 84 10 	movl   $0x801084a0,0x4(%esp)
80103cb0:	80 
80103cb1:	89 04 24             	mov    %eax,(%esp)
80103cb4:	e8 f1 0d 00 00       	call   80104aaa <initlock>
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
80103d61:	e8 65 0d 00 00       	call   80104acb <acquire>
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
80103d84:	e8 40 0b 00 00       	call   801048c9 <wakeup>
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
80103da3:	e8 21 0b 00 00       	call   801048c9 <wakeup>
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
80103dc8:	e8 60 0d 00 00       	call   80104b2d <release>
    kfree((char*)p);
80103dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd0:	89 04 24             	mov    %eax,(%esp)
80103dd3:	e8 4d ec ff ff       	call   80102a25 <kfree>
80103dd8:	eb 0b                	jmp    80103de5 <pipeclose+0x90>
  } else
    release(&p->lock);
80103dda:	8b 45 08             	mov    0x8(%ebp),%eax
80103ddd:	89 04 24             	mov    %eax,(%esp)
80103de0:	e8 48 0d 00 00       	call   80104b2d <release>
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
80103df4:	e8 d2 0c 00 00       	call   80104acb <acquire>
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
80103e25:	e8 03 0d 00 00       	call   80104b2d <release>
        return -1;
80103e2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e2f:	e9 9d 00 00 00       	jmp    80103ed1 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e34:	8b 45 08             	mov    0x8(%ebp),%eax
80103e37:	05 34 02 00 00       	add    $0x234,%eax
80103e3c:	89 04 24             	mov    %eax,(%esp)
80103e3f:	e8 85 0a 00 00       	call   801048c9 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e44:	8b 45 08             	mov    0x8(%ebp),%eax
80103e47:	8b 55 08             	mov    0x8(%ebp),%edx
80103e4a:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e54:	89 14 24             	mov    %edx,(%esp)
80103e57:	e8 94 09 00 00       	call   801047f0 <sleep>
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
80103ebe:	e8 06 0a 00 00       	call   801048c9 <wakeup>
  release(&p->lock);
80103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec6:	89 04 24             	mov    %eax,(%esp)
80103ec9:	e8 5f 0c 00 00       	call   80104b2d <release>
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
80103ee4:	e8 e2 0b 00 00       	call   80104acb <acquire>
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
80103efe:	e8 2a 0c 00 00       	call   80104b2d <release>
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
80103f20:	e8 cb 08 00 00       	call   801047f0 <sleep>
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
80103faf:	e8 15 09 00 00       	call   801048c9 <wakeup>
  release(&p->lock);
80103fb4:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb7:	89 04 24             	mov    %eax,(%esp)
80103fba:	e8 6e 0b 00 00       	call   80104b2d <release>
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
80103fe9:	c7 44 24 04 a5 84 10 	movl   $0x801084a5,0x4(%esp)
80103ff0:	80 
80103ff1:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80103ff8:	e8 ad 0a 00 00       	call   80104aaa <initlock>
}
80103ffd:	c9                   	leave  
80103ffe:	c3                   	ret    

80103fff <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fff:	55                   	push   %ebp
80104000:	89 e5                	mov    %esp,%ebp
80104002:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104005:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010400c:	e8 ba 0a 00 00       	call   80104acb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104011:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104018:	eb 0e                	jmp    80104028 <allocproc+0x29>
    if(p->state == UNUSED)
8010401a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010401d:	8b 40 0c             	mov    0xc(%eax),%eax
80104020:	85 c0                	test   %eax,%eax
80104022:	74 23                	je     80104047 <allocproc+0x48>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104024:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104028:	81 7d f4 54 1f 11 80 	cmpl   $0x80111f54,-0xc(%ebp)
8010402f:	72 e9                	jb     8010401a <allocproc+0x1b>
      goto found;
  release(&ptable.lock);
80104031:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104038:	e8 f0 0a 00 00       	call   80104b2d <release>
  return 0;
8010403d:	b8 00 00 00 00       	mov    $0x0,%eax
80104042:	e9 b3 00 00 00       	jmp    801040fa <allocproc+0xfb>
      goto found;
80104047:	90                   	nop

found:
  p->state = EMBRYO;
80104048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010404b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104052:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104057:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010405a:	89 42 10             	mov    %eax,0x10(%edx)
8010405d:	40                   	inc    %eax
8010405e:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
80104063:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010406a:	e8 be 0a 00 00       	call   80104b2d <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010406f:	e8 4a ea ff ff       	call   80102abe <kalloc>
80104074:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104077:	89 42 08             	mov    %eax,0x8(%edx)
8010407a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010407d:	8b 40 08             	mov    0x8(%eax),%eax
80104080:	85 c0                	test   %eax,%eax
80104082:	75 11                	jne    80104095 <allocproc+0x96>
    p->state = UNUSED;
80104084:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104087:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010408e:	b8 00 00 00 00       	mov    $0x0,%eax
80104093:	eb 65                	jmp    801040fa <allocproc+0xfb>
  }
  sp = p->kstack + KSTACKSIZE;
80104095:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104098:	8b 40 08             	mov    0x8(%eax),%eax
8010409b:	05 00 10 00 00       	add    $0x1000,%eax
801040a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040a3:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801040a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040ad:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801040b0:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801040b4:	ba 57 62 10 80       	mov    $0x80106257,%edx
801040b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040bc:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801040be:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801040c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040c8:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ce:	8b 40 1c             	mov    0x1c(%eax),%eax
801040d1:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801040d8:	00 
801040d9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801040e0:	00 
801040e1:	89 04 24             	mov    %eax,(%esp)
801040e4:	e8 34 0c 00 00       	call   80104d1d <memset>
  p->context->eip = (uint)forkret;
801040e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040ec:	8b 40 1c             	mov    0x1c(%eax),%eax
801040ef:	ba c4 47 10 80       	mov    $0x801047c4,%edx
801040f4:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801040f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801040fa:	c9                   	leave  
801040fb:	c3                   	ret    

801040fc <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801040fc:	55                   	push   %ebp
801040fd:	89 e5                	mov    %esp,%ebp
801040ff:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104102:	e8 f8 fe ff ff       	call   80103fff <allocproc>
80104107:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010410a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410d:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm()) == 0)
80104112:	e8 63 38 00 00       	call   8010797a <setupkvm>
80104117:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010411a:	89 42 04             	mov    %eax,0x4(%edx)
8010411d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104120:	8b 40 04             	mov    0x4(%eax),%eax
80104123:	85 c0                	test   %eax,%eax
80104125:	75 0c                	jne    80104133 <userinit+0x37>
    panic("userinit: out of memory?");
80104127:	c7 04 24 ac 84 10 80 	movl   $0x801084ac,(%esp)
8010412e:	e8 03 c4 ff ff       	call   80100536 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104133:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104138:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413b:	8b 40 04             	mov    0x4(%eax),%eax
8010413e:	89 54 24 08          	mov    %edx,0x8(%esp)
80104142:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
80104149:	80 
8010414a:	89 04 24             	mov    %eax,(%esp)
8010414d:	e8 74 3a 00 00       	call   80107bc6 <inituvm>
  p->sz = PGSIZE;
80104152:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104155:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010415b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010415e:	8b 40 18             	mov    0x18(%eax),%eax
80104161:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80104168:	00 
80104169:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104170:	00 
80104171:	89 04 24             	mov    %eax,(%esp)
80104174:	e8 a4 0b 00 00       	call   80104d1d <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010417c:	8b 40 18             	mov    0x18(%eax),%eax
8010417f:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104185:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104188:	8b 40 18             	mov    0x18(%eax),%eax
8010418b:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104194:	8b 50 18             	mov    0x18(%eax),%edx
80104197:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010419a:	8b 40 18             	mov    0x18(%eax),%eax
8010419d:	8b 40 2c             	mov    0x2c(%eax),%eax
801041a0:	66 89 42 28          	mov    %ax,0x28(%edx)
  p->tf->ss = p->tf->ds;
801041a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a7:	8b 50 18             	mov    0x18(%eax),%edx
801041aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ad:	8b 40 18             	mov    0x18(%eax),%eax
801041b0:	8b 40 2c             	mov    0x2c(%eax),%eax
801041b3:	66 89 42 48          	mov    %ax,0x48(%edx)
  p->tf->eflags = FL_IF;
801041b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041ba:	8b 40 18             	mov    0x18(%eax),%eax
801041bd:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c7:	8b 40 18             	mov    0x18(%eax),%eax
801041ca:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801041d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041d4:	8b 40 18             	mov    0x18(%eax),%eax
801041d7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801041de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e1:	83 c0 6c             	add    $0x6c,%eax
801041e4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801041eb:	00 
801041ec:	c7 44 24 04 c5 84 10 	movl   $0x801084c5,0x4(%esp)
801041f3:	80 
801041f4:	89 04 24             	mov    %eax,(%esp)
801041f7:	e8 33 0d 00 00       	call   80104f2f <safestrcpy>
  p->cwd = namei("/");
801041fc:	c7 04 24 ce 84 10 80 	movl   $0x801084ce,(%esp)
80104203:	e8 d7 e1 ff ff       	call   801023df <namei>
80104208:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010420b:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
8010420e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104211:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104218:	c9                   	leave  
80104219:	c3                   	ret    

8010421a <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010421a:	55                   	push   %ebp
8010421b:	89 e5                	mov    %esp,%ebp
8010421d:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104220:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104226:	8b 00                	mov    (%eax),%eax
80104228:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010422b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010422f:	7e 34                	jle    80104265 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104231:	8b 55 08             	mov    0x8(%ebp),%edx
80104234:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104237:	01 c2                	add    %eax,%edx
80104239:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010423f:	8b 40 04             	mov    0x4(%eax),%eax
80104242:	89 54 24 08          	mov    %edx,0x8(%esp)
80104246:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104249:	89 54 24 04          	mov    %edx,0x4(%esp)
8010424d:	89 04 24             	mov    %eax,(%esp)
80104250:	e8 eb 3a 00 00       	call   80107d40 <allocuvm>
80104255:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104258:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010425c:	75 41                	jne    8010429f <growproc+0x85>
      return -1;
8010425e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104263:	eb 58                	jmp    801042bd <growproc+0xa3>
  } else if(n < 0){
80104265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104269:	79 34                	jns    8010429f <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010426b:	8b 55 08             	mov    0x8(%ebp),%edx
8010426e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104271:	01 c2                	add    %eax,%edx
80104273:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104279:	8b 40 04             	mov    0x4(%eax),%eax
8010427c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104280:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104283:	89 54 24 04          	mov    %edx,0x4(%esp)
80104287:	89 04 24             	mov    %eax,(%esp)
8010428a:	e8 8b 3b 00 00       	call   80107e1a <deallocuvm>
8010428f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104296:	75 07                	jne    8010429f <growproc+0x85>
      return -1;
80104298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010429d:	eb 1e                	jmp    801042bd <growproc+0xa3>
  }
  proc->sz = sz;
8010429f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042a8:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801042aa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042b0:	89 04 24             	mov    %eax,(%esp)
801042b3:	e8 b3 37 00 00       	call   80107a6b <switchuvm>
  return 0;
801042b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042bd:	c9                   	leave  
801042be:	c3                   	ret    

801042bf <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801042bf:	55                   	push   %ebp
801042c0:	89 e5                	mov    %esp,%ebp
801042c2:	57                   	push   %edi
801042c3:	56                   	push   %esi
801042c4:	53                   	push   %ebx
801042c5:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801042c8:	e8 32 fd ff ff       	call   80103fff <allocproc>
801042cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801042d0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801042d4:	75 0a                	jne    801042e0 <fork+0x21>
    return -1;
801042d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042db:	e9 2f 01 00 00       	jmp    8010440f <fork+0x150>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801042e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e6:	8b 10                	mov    (%eax),%edx
801042e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ee:	8b 40 04             	mov    0x4(%eax),%eax
801042f1:	89 54 24 04          	mov    %edx,0x4(%esp)
801042f5:	89 04 24             	mov    %eax,(%esp)
801042f8:	e8 b8 3c 00 00       	call   80107fb5 <copyuvm>
801042fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104300:	89 42 04             	mov    %eax,0x4(%edx)
80104303:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104306:	8b 40 04             	mov    0x4(%eax),%eax
80104309:	85 c0                	test   %eax,%eax
8010430b:	75 22                	jne    8010432f <fork+0x70>
    kfree(np->kstack);
8010430d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104310:	8b 40 08             	mov    0x8(%eax),%eax
80104313:	89 04 24             	mov    %eax,(%esp)
80104316:	e8 0a e7 ff ff       	call   80102a25 <kfree>
    // np->kstack = 0;
    np->state = UNUSED;
8010431b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010431e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104325:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010432a:	e9 e0 00 00 00       	jmp    8010440f <fork+0x150>
  }
  np->sz = proc->sz;
8010432f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104335:	8b 10                	mov    (%eax),%edx
80104337:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010433a:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010433c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104343:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104346:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104349:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010434c:	8b 50 18             	mov    0x18(%eax),%edx
8010434f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104355:	8b 40 18             	mov    0x18(%eax),%eax
80104358:	89 c3                	mov    %eax,%ebx
8010435a:	b8 13 00 00 00       	mov    $0x13,%eax
8010435f:	89 d7                	mov    %edx,%edi
80104361:	89 de                	mov    %ebx,%esi
80104363:	89 c1                	mov    %eax,%ecx
80104365:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104367:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010436a:	8b 40 18             	mov    0x18(%eax),%eax
8010436d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104374:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010437b:	eb 3c                	jmp    801043b9 <fork+0xfa>
    if(proc->ofile[i])
8010437d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104383:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104386:	83 c2 08             	add    $0x8,%edx
80104389:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010438d:	85 c0                	test   %eax,%eax
8010438f:	74 25                	je     801043b6 <fork+0xf7>
      np->ofile[i] = filedup(proc->ofile[i]);
80104391:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104397:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010439a:	83 c2 08             	add    $0x8,%edx
8010439d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043a1:	89 04 24             	mov    %eax,(%esp)
801043a4:	e8 aa cb ff ff       	call   80100f53 <filedup>
801043a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043ac:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043af:	83 c1 08             	add    $0x8,%ecx
801043b2:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801043b6:	ff 45 e4             	incl   -0x1c(%ebp)
801043b9:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801043bd:	7e be                	jle    8010437d <fork+0xbe>
  np->cwd = idup(proc->cwd);
801043bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c5:	8b 40 68             	mov    0x68(%eax),%eax
801043c8:	89 04 24             	mov    %eax,(%esp)
801043cb:	e8 43 d4 ff ff       	call   80101813 <idup>
801043d0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043d3:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
801043d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043d9:	8b 40 10             	mov    0x10(%eax),%eax
801043dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
801043df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043e2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
801043e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043ef:	8d 50 6c             	lea    0x6c(%eax),%edx
801043f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043f5:	83 c0 6c             	add    $0x6c,%eax
801043f8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801043ff:	00 
80104400:	89 54 24 04          	mov    %edx,0x4(%esp)
80104404:	89 04 24             	mov    %eax,(%esp)
80104407:	e8 23 0b 00 00       	call   80104f2f <safestrcpy>
  return pid;
8010440c:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
8010440f:	83 c4 2c             	add    $0x2c,%esp
80104412:	5b                   	pop    %ebx
80104413:	5e                   	pop    %esi
80104414:	5f                   	pop    %edi
80104415:	5d                   	pop    %ebp
80104416:	c3                   	ret    

80104417 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104417:	55                   	push   %ebp
80104418:	89 e5                	mov    %esp,%ebp
8010441a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010441d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104424:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104429:	39 c2                	cmp    %eax,%edx
8010442b:	75 0c                	jne    80104439 <exit+0x22>
    panic("init exiting");
8010442d:	c7 04 24 d0 84 10 80 	movl   $0x801084d0,(%esp)
80104434:	e8 fd c0 ff ff       	call   80100536 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104439:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104440:	eb 43                	jmp    80104485 <exit+0x6e>
    if(proc->ofile[fd]){
80104442:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104448:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010444b:	83 c2 08             	add    $0x8,%edx
8010444e:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104452:	85 c0                	test   %eax,%eax
80104454:	74 2c                	je     80104482 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104456:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010445c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010445f:	83 c2 08             	add    $0x8,%edx
80104462:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104466:	89 04 24             	mov    %eax,(%esp)
80104469:	e8 2d cb ff ff       	call   80100f9b <fileclose>
      proc->ofile[fd] = 0;
8010446e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104474:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104477:	83 c2 08             	add    $0x8,%edx
8010447a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104481:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104482:	ff 45 f0             	incl   -0x10(%ebp)
80104485:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104489:	7e b7                	jle    80104442 <exit+0x2b>
    }
  }

  iput(proc->cwd);
8010448b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104491:	8b 40 68             	mov    0x68(%eax),%eax
80104494:	89 04 24             	mov    %eax,(%esp)
80104497:	e8 59 d5 ff ff       	call   801019f5 <iput>
  proc->cwd = 0;
8010449c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044a2:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801044a9:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801044b0:	e8 16 06 00 00       	call   80104acb <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801044b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044bb:	8b 40 14             	mov    0x14(%eax),%eax
801044be:	89 04 24             	mov    %eax,(%esp)
801044c1:	e8 c5 03 00 00       	call   8010488b <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044c6:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801044cd:	eb 38                	jmp    80104507 <exit+0xf0>
    if(p->parent == proc){
801044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044d2:	8b 50 14             	mov    0x14(%eax),%edx
801044d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044db:	39 c2                	cmp    %eax,%edx
801044dd:	75 24                	jne    80104503 <exit+0xec>
      p->parent = initproc;
801044df:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
801044e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e8:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801044eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044ee:	8b 40 0c             	mov    0xc(%eax),%eax
801044f1:	83 f8 05             	cmp    $0x5,%eax
801044f4:	75 0d                	jne    80104503 <exit+0xec>
        wakeup1(initproc);
801044f6:	a1 48 b6 10 80       	mov    0x8010b648,%eax
801044fb:	89 04 24             	mov    %eax,(%esp)
801044fe:	e8 88 03 00 00       	call   8010488b <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104503:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104507:	81 7d f4 54 1f 11 80 	cmpl   $0x80111f54,-0xc(%ebp)
8010450e:	72 bf                	jb     801044cf <exit+0xb8>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104510:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104516:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010451d:	e8 be 01 00 00       	call   801046e0 <sched>
  panic("zombie exit");
80104522:	c7 04 24 dd 84 10 80 	movl   $0x801084dd,(%esp)
80104529:	e8 08 c0 ff ff       	call   80100536 <panic>

8010452e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010452e:	55                   	push   %ebp
8010452f:	89 e5                	mov    %esp,%ebp
80104531:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104534:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010453b:	e8 8b 05 00 00       	call   80104acb <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104540:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104547:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010454e:	e9 9a 00 00 00       	jmp    801045ed <wait+0xbf>
      if(p->parent != proc)
80104553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104556:	8b 50 14             	mov    0x14(%eax),%edx
80104559:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010455f:	39 c2                	cmp    %eax,%edx
80104561:	0f 85 81 00 00 00    	jne    801045e8 <wait+0xba>
        continue;
      havekids = 1;
80104567:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
8010456e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104571:	8b 40 0c             	mov    0xc(%eax),%eax
80104574:	83 f8 05             	cmp    $0x5,%eax
80104577:	75 70                	jne    801045e9 <wait+0xbb>
        // Found one.
        pid = p->pid;
80104579:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010457c:	8b 40 10             	mov    0x10(%eax),%eax
8010457f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104582:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104585:	8b 40 08             	mov    0x8(%eax),%eax
80104588:	89 04 24             	mov    %eax,(%esp)
8010458b:	e8 95 e4 ff ff       	call   80102a25 <kfree>
        p->kstack = 0;
80104590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104593:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010459a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010459d:	8b 40 04             	mov    0x4(%eax),%eax
801045a0:	89 04 24             	mov    %eax,(%esp)
801045a3:	e8 2e 39 00 00       	call   80107ed6 <freevm>
        p->state = UNUSED;
801045a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
801045b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b5:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801045bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045bf:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801045c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c9:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801045cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d0:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
801045d7:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045de:	e8 4a 05 00 00       	call   80104b2d <release>
        return pid;
801045e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801045e6:	eb 53                	jmp    8010463b <wait+0x10d>
        continue;
801045e8:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045e9:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801045ed:	81 7d f4 54 1f 11 80 	cmpl   $0x80111f54,-0xc(%ebp)
801045f4:	0f 82 59 ff ff ff    	jb     80104553 <wait+0x25>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801045fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801045fe:	74 0d                	je     8010460d <wait+0xdf>
80104600:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104606:	8b 40 24             	mov    0x24(%eax),%eax
80104609:	85 c0                	test   %eax,%eax
8010460b:	74 13                	je     80104620 <wait+0xf2>
      release(&ptable.lock);
8010460d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104614:	e8 14 05 00 00       	call   80104b2d <release>
      return -1;
80104619:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010461e:	eb 1b                	jmp    8010463b <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104620:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104626:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
8010462d:	80 
8010462e:	89 04 24             	mov    %eax,(%esp)
80104631:	e8 ba 01 00 00       	call   801047f0 <sleep>
  }
80104636:	e9 05 ff ff ff       	jmp    80104540 <wait+0x12>
}
8010463b:	c9                   	leave  
8010463c:	c3                   	ret    

8010463d <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010463d:	55                   	push   %ebp
8010463e:	89 e5                	mov    %esp,%ebp
80104640:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104643:	e8 95 f9 ff ff       	call   80103fdd <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104648:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010464f:	e8 77 04 00 00       	call   80104acb <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104654:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010465b:	eb 69                	jmp    801046c6 <scheduler+0x89>
      if(p->state != RUNNABLE)
8010465d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104660:	8b 40 0c             	mov    0xc(%eax),%eax
80104663:	83 f8 03             	cmp    $0x3,%eax
80104666:	75 59                	jne    801046c1 <scheduler+0x84>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      // proc = p; 
      proc = p; // p->state == RUNNABLE
80104668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010466b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104671:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104674:	89 04 24             	mov    %eax,(%esp)
80104677:	e8 ef 33 00 00       	call   80107a6b <switchuvm>
      p->state = RUNNING;
8010467c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010467f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      p->ticksProc = 0;  // New - when a proccess takes control, set ticksCounter on zero
80104686:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104689:	c7 40 7c 00 00 00 00 	movl   $0x0,0x7c(%eax)
      //cprintf("proccess %s takes control of the CPU...\n",p->name);
      swtch(&cpu->scheduler, proc->context);
80104690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104696:	8b 40 1c             	mov    0x1c(%eax),%eax
80104699:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801046a0:	83 c2 04             	add    $0x4,%edx
801046a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801046a7:	89 14 24             	mov    %edx,(%esp)
801046aa:	e8 ee 08 00 00       	call   80104f9d <swtch>
      switchkvm();
801046af:	e8 9a 33 00 00       	call   80107a4e <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801046b4:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801046bb:	00 00 00 00 
801046bf:	eb 01                	jmp    801046c2 <scheduler+0x85>
        continue;
801046c1:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046c2:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
801046c6:	81 7d f4 54 1f 11 80 	cmpl   $0x80111f54,-0xc(%ebp)
801046cd:	72 8e                	jb     8010465d <scheduler+0x20>
    }
    release(&ptable.lock);
801046cf:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046d6:	e8 52 04 00 00       	call   80104b2d <release>

  }
801046db:	e9 63 ff ff ff       	jmp    80104643 <scheduler+0x6>

801046e0 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801046e6:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801046ed:	e8 01 05 00 00       	call   80104bf3 <holding>
801046f2:	85 c0                	test   %eax,%eax
801046f4:	75 0c                	jne    80104702 <sched+0x22>
    panic("sched ptable.lock");
801046f6:	c7 04 24 e9 84 10 80 	movl   $0x801084e9,(%esp)
801046fd:	e8 34 be ff ff       	call   80100536 <panic>
  if(cpu->ncli != 1)
80104702:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104708:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010470e:	83 f8 01             	cmp    $0x1,%eax
80104711:	74 0c                	je     8010471f <sched+0x3f>
    panic("sched locks");
80104713:	c7 04 24 fb 84 10 80 	movl   $0x801084fb,(%esp)
8010471a:	e8 17 be ff ff       	call   80100536 <panic>
  if(proc->state == RUNNING)
8010471f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104725:	8b 40 0c             	mov    0xc(%eax),%eax
80104728:	83 f8 04             	cmp    $0x4,%eax
8010472b:	75 0c                	jne    80104739 <sched+0x59>
    panic("sched running");
8010472d:	c7 04 24 07 85 10 80 	movl   $0x80108507,(%esp)
80104734:	e8 fd bd ff ff       	call   80100536 <panic>
  if(readeflags()&FL_IF)
80104739:	e8 8a f8 ff ff       	call   80103fc8 <readeflags>
8010473e:	25 00 02 00 00       	and    $0x200,%eax
80104743:	85 c0                	test   %eax,%eax
80104745:	74 0c                	je     80104753 <sched+0x73>
    panic("sched interruptible");
80104747:	c7 04 24 15 85 10 80 	movl   $0x80108515,(%esp)
8010474e:	e8 e3 bd ff ff       	call   80100536 <panic>
  intena = cpu->intena;
80104753:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104759:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010475f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104762:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104768:	8b 40 04             	mov    0x4(%eax),%eax
8010476b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104772:	83 c2 1c             	add    $0x1c,%edx
80104775:	89 44 24 04          	mov    %eax,0x4(%esp)
80104779:	89 14 24             	mov    %edx,(%esp)
8010477c:	e8 1c 08 00 00       	call   80104f9d <swtch>
  cpu->intena = intena;
80104781:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104787:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010478a:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104790:	c9                   	leave  
80104791:	c3                   	ret    

80104792 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104792:	55                   	push   %ebp
80104793:	89 e5                	mov    %esp,%ebp
80104795:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104798:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010479f:	e8 27 03 00 00       	call   80104acb <acquire>
  proc->state = RUNNABLE;
801047a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047aa:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801047b1:	e8 2a ff ff ff       	call   801046e0 <sched>
  release(&ptable.lock);
801047b6:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047bd:	e8 6b 03 00 00       	call   80104b2d <release>
}
801047c2:	c9                   	leave  
801047c3:	c3                   	ret    

801047c4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801047c4:	55                   	push   %ebp
801047c5:	89 e5                	mov    %esp,%ebp
801047c7:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801047ca:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047d1:	e8 57 03 00 00       	call   80104b2d <release>

  if (first) {
801047d6:	a1 20 b0 10 80       	mov    0x8010b020,%eax
801047db:	85 c0                	test   %eax,%eax
801047dd:	74 0f                	je     801047ee <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801047df:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
801047e6:	00 00 00 
    initlog();
801047e9:	e8 d4 e7 ff ff       	call   80102fc2 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801047ee:	c9                   	leave  
801047ef:	c3                   	ret    

801047f0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801047f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047fc:	85 c0                	test   %eax,%eax
801047fe:	75 0c                	jne    8010480c <sleep+0x1c>
    panic("sleep");
80104800:	c7 04 24 29 85 10 80 	movl   $0x80108529,(%esp)
80104807:	e8 2a bd ff ff       	call   80100536 <panic>

  if(lk == 0)
8010480c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104810:	75 0c                	jne    8010481e <sleep+0x2e>
    panic("sleep without lk");
80104812:	c7 04 24 2f 85 10 80 	movl   $0x8010852f,(%esp)
80104819:	e8 18 bd ff ff       	call   80100536 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010481e:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104825:	74 17                	je     8010483e <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104827:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010482e:	e8 98 02 00 00       	call   80104acb <acquire>
    release(lk);
80104833:	8b 45 0c             	mov    0xc(%ebp),%eax
80104836:	89 04 24             	mov    %eax,(%esp)
80104839:	e8 ef 02 00 00       	call   80104b2d <release>
  }

  // Go to sleep.
  proc->chan = chan;
8010483e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104844:	8b 55 08             	mov    0x8(%ebp),%edx
80104847:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
8010484a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104850:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104857:	e8 84 fe ff ff       	call   801046e0 <sched>

  // Tidy up.
  proc->chan = 0;
8010485c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104862:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104869:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104870:	74 17                	je     80104889 <sleep+0x99>
    release(&ptable.lock);
80104872:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104879:	e8 af 02 00 00       	call   80104b2d <release>
    acquire(lk);
8010487e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104881:	89 04 24             	mov    %eax,(%esp)
80104884:	e8 42 02 00 00       	call   80104acb <acquire>
  }
}
80104889:	c9                   	leave  
8010488a:	c3                   	ret    

8010488b <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
8010488b:	55                   	push   %ebp
8010488c:	89 e5                	mov    %esp,%ebp
8010488e:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104891:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
80104898:	eb 24                	jmp    801048be <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
8010489a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010489d:	8b 40 0c             	mov    0xc(%eax),%eax
801048a0:	83 f8 02             	cmp    $0x2,%eax
801048a3:	75 15                	jne    801048ba <wakeup1+0x2f>
801048a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048a8:	8b 40 20             	mov    0x20(%eax),%eax
801048ab:	3b 45 08             	cmp    0x8(%ebp),%eax
801048ae:	75 0a                	jne    801048ba <wakeup1+0x2f>
      p->state = RUNNABLE;
801048b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801048b3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048ba:	83 6d fc 80          	subl   $0xffffff80,-0x4(%ebp)
801048be:	81 7d fc 54 1f 11 80 	cmpl   $0x80111f54,-0x4(%ebp)
801048c5:	72 d3                	jb     8010489a <wakeup1+0xf>
}
801048c7:	c9                   	leave  
801048c8:	c3                   	ret    

801048c9 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801048c9:	55                   	push   %ebp
801048ca:	89 e5                	mov    %esp,%ebp
801048cc:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801048cf:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048d6:	e8 f0 01 00 00       	call   80104acb <acquire>
  wakeup1(chan);
801048db:	8b 45 08             	mov    0x8(%ebp),%eax
801048de:	89 04 24             	mov    %eax,(%esp)
801048e1:	e8 a5 ff ff ff       	call   8010488b <wakeup1>
  release(&ptable.lock);
801048e6:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048ed:	e8 3b 02 00 00       	call   80104b2d <release>
}
801048f2:	c9                   	leave  
801048f3:	c3                   	ret    

801048f4 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
801048fa:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104901:	e8 c5 01 00 00       	call   80104acb <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104906:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010490d:	eb 41                	jmp    80104950 <kill+0x5c>
    if(p->pid == pid){
8010490f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104912:	8b 40 10             	mov    0x10(%eax),%eax
80104915:	3b 45 08             	cmp    0x8(%ebp),%eax
80104918:	75 32                	jne    8010494c <kill+0x58>
      p->killed = 1;
8010491a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104927:	8b 40 0c             	mov    0xc(%eax),%eax
8010492a:	83 f8 02             	cmp    $0x2,%eax
8010492d:	75 0a                	jne    80104939 <kill+0x45>
        p->state = RUNNABLE;
8010492f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104932:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104939:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104940:	e8 e8 01 00 00       	call   80104b2d <release>
      return 0;
80104945:	b8 00 00 00 00       	mov    $0x0,%eax
8010494a:	eb 1e                	jmp    8010496a <kill+0x76>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010494c:	83 6d f4 80          	subl   $0xffffff80,-0xc(%ebp)
80104950:	81 7d f4 54 1f 11 80 	cmpl   $0x80111f54,-0xc(%ebp)
80104957:	72 b6                	jb     8010490f <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104959:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104960:	e8 c8 01 00 00       	call   80104b2d <release>
  return -1;
80104965:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010496a:	c9                   	leave  
8010496b:	c3                   	ret    

8010496c <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
8010496c:	55                   	push   %ebp
8010496d:	89 e5                	mov    %esp,%ebp
8010496f:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104972:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104979:	e9 d7 00 00 00       	jmp    80104a55 <procdump+0xe9>
    if(p->state == UNUSED)
8010497e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104981:	8b 40 0c             	mov    0xc(%eax),%eax
80104984:	85 c0                	test   %eax,%eax
80104986:	0f 84 c4 00 00 00    	je     80104a50 <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010498c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010498f:	8b 40 0c             	mov    0xc(%eax),%eax
80104992:	83 f8 05             	cmp    $0x5,%eax
80104995:	77 23                	ja     801049ba <procdump+0x4e>
80104997:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010499a:	8b 40 0c             	mov    0xc(%eax),%eax
8010499d:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
801049a4:	85 c0                	test   %eax,%eax
801049a6:	74 12                	je     801049ba <procdump+0x4e>
      state = states[p->state];
801049a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ab:	8b 40 0c             	mov    0xc(%eax),%eax
801049ae:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
801049b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801049b8:	eb 07                	jmp    801049c1 <procdump+0x55>
    else
      state = "???";
801049ba:	c7 45 ec 40 85 10 80 	movl   $0x80108540,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
801049c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049c4:	8d 50 6c             	lea    0x6c(%eax),%edx
801049c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049ca:	8b 40 10             	mov    0x10(%eax),%eax
801049cd:	89 54 24 0c          	mov    %edx,0xc(%esp)
801049d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
801049d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801049d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801049dc:	c7 04 24 44 85 10 80 	movl   $0x80108544,(%esp)
801049e3:	e8 b9 b9 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
801049e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049eb:	8b 40 0c             	mov    0xc(%eax),%eax
801049ee:	83 f8 02             	cmp    $0x2,%eax
801049f1:	75 4f                	jne    80104a42 <procdump+0xd6>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801049f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049f6:	8b 40 1c             	mov    0x1c(%eax),%eax
801049f9:	8b 40 0c             	mov    0xc(%eax),%eax
801049fc:	83 c0 08             	add    $0x8,%eax
801049ff:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104a02:	89 54 24 04          	mov    %edx,0x4(%esp)
80104a06:	89 04 24             	mov    %eax,(%esp)
80104a09:	e8 6e 01 00 00       	call   80104b7c <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104a15:	eb 1a                	jmp    80104a31 <procdump+0xc5>
        cprintf(" %p", pc[i]);
80104a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a22:	c7 04 24 4d 85 10 80 	movl   $0x8010854d,(%esp)
80104a29:	e8 73 b9 ff ff       	call   801003a1 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104a2e:	ff 45 f4             	incl   -0xc(%ebp)
80104a31:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104a35:	7f 0b                	jg     80104a42 <procdump+0xd6>
80104a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104a3e:	85 c0                	test   %eax,%eax
80104a40:	75 d5                	jne    80104a17 <procdump+0xab>
    }
    cprintf("\n");
80104a42:	c7 04 24 51 85 10 80 	movl   $0x80108551,(%esp)
80104a49:	e8 53 b9 ff ff       	call   801003a1 <cprintf>
80104a4e:	eb 01                	jmp    80104a51 <procdump+0xe5>
      continue;
80104a50:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a51:	83 6d f0 80          	subl   $0xffffff80,-0x10(%ebp)
80104a55:	81 7d f0 54 1f 11 80 	cmpl   $0x80111f54,-0x10(%ebp)
80104a5c:	0f 82 1c ff ff ff    	jb     8010497e <procdump+0x12>
  }
}
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    

80104a64 <readeflags>:
{
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	53                   	push   %ebx
80104a68:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104a6b:	9c                   	pushf  
80104a6c:	5b                   	pop    %ebx
80104a6d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104a70:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104a73:	83 c4 10             	add    $0x10,%esp
80104a76:	5b                   	pop    %ebx
80104a77:	5d                   	pop    %ebp
80104a78:	c3                   	ret    

80104a79 <cli>:
{
80104a79:	55                   	push   %ebp
80104a7a:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104a7c:	fa                   	cli    
}
80104a7d:	5d                   	pop    %ebp
80104a7e:	c3                   	ret    

80104a7f <sti>:
{
80104a7f:	55                   	push   %ebp
80104a80:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104a82:	fb                   	sti    
}
80104a83:	5d                   	pop    %ebp
80104a84:	c3                   	ret    

80104a85 <xchg>:
{
80104a85:	55                   	push   %ebp
80104a86:	89 e5                	mov    %esp,%ebp
80104a88:	53                   	push   %ebx
80104a89:	83 ec 10             	sub    $0x10,%esp
               "+m" (*addr), "=a" (result) :
80104a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80104a8f:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104a92:	8b 4d 08             	mov    0x8(%ebp),%ecx
  asm volatile("lock; xchgl %0, %1" :
80104a95:	89 c3                	mov    %eax,%ebx
80104a97:	89 d8                	mov    %ebx,%eax
80104a99:	f0 87 02             	lock xchg %eax,(%edx)
80104a9c:	89 c3                	mov    %eax,%ebx
80104a9e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return result;
80104aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104aa4:	83 c4 10             	add    $0x10,%esp
80104aa7:	5b                   	pop    %ebx
80104aa8:	5d                   	pop    %ebp
80104aa9:	c3                   	ret    

80104aaa <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104aaa:	55                   	push   %ebp
80104aab:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104aad:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ab3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104ab6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104abf:	8b 45 08             	mov    0x8(%ebp),%eax
80104ac2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ac9:	5d                   	pop    %ebp
80104aca:	c3                   	ret    

80104acb <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104acb:	55                   	push   %ebp
80104acc:	89 e5                	mov    %esp,%ebp
80104ace:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104ad1:	e8 47 01 00 00       	call   80104c1d <pushcli>
  if(holding(lk))
80104ad6:	8b 45 08             	mov    0x8(%ebp),%eax
80104ad9:	89 04 24             	mov    %eax,(%esp)
80104adc:	e8 12 01 00 00       	call   80104bf3 <holding>
80104ae1:	85 c0                	test   %eax,%eax
80104ae3:	74 0c                	je     80104af1 <acquire+0x26>
    panic("acquire");
80104ae5:	c7 04 24 7d 85 10 80 	movl   $0x8010857d,(%esp)
80104aec:	e8 45 ba ff ff       	call   80100536 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104af1:	90                   	nop
80104af2:	8b 45 08             	mov    0x8(%ebp),%eax
80104af5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104afc:	00 
80104afd:	89 04 24             	mov    %eax,(%esp)
80104b00:	e8 80 ff ff ff       	call   80104a85 <xchg>
80104b05:	85 c0                	test   %eax,%eax
80104b07:	75 e9                	jne    80104af2 <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104b09:	8b 45 08             	mov    0x8(%ebp),%eax
80104b0c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104b13:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104b16:	8b 45 08             	mov    0x8(%ebp),%eax
80104b19:	83 c0 0c             	add    $0xc,%eax
80104b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b20:	8d 45 08             	lea    0x8(%ebp),%eax
80104b23:	89 04 24             	mov    %eax,(%esp)
80104b26:	e8 51 00 00 00       	call   80104b7c <getcallerpcs>
}
80104b2b:	c9                   	leave  
80104b2c:	c3                   	ret    

80104b2d <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104b2d:	55                   	push   %ebp
80104b2e:	89 e5                	mov    %esp,%ebp
80104b30:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104b33:	8b 45 08             	mov    0x8(%ebp),%eax
80104b36:	89 04 24             	mov    %eax,(%esp)
80104b39:	e8 b5 00 00 00       	call   80104bf3 <holding>
80104b3e:	85 c0                	test   %eax,%eax
80104b40:	75 0c                	jne    80104b4e <release+0x21>
    panic("release");
80104b42:	c7 04 24 85 85 10 80 	movl   $0x80108585,(%esp)
80104b49:	e8 e8 b9 ff ff       	call   80100536 <panic>

  lk->pcs[0] = 0;
80104b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104b51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104b58:	8b 45 08             	mov    0x8(%ebp),%eax
80104b5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80104b62:	8b 45 08             	mov    0x8(%ebp),%eax
80104b65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104b6c:	00 
80104b6d:	89 04 24             	mov    %eax,(%esp)
80104b70:	e8 10 ff ff ff       	call   80104a85 <xchg>

  popcli();
80104b75:	e8 e9 00 00 00       	call   80104c63 <popcli>
}
80104b7a:	c9                   	leave  
80104b7b:	c3                   	ret    

80104b7c <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104b7c:	55                   	push   %ebp
80104b7d:	89 e5                	mov    %esp,%ebp
80104b7f:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80104b82:	8b 45 08             	mov    0x8(%ebp),%eax
80104b85:	83 e8 08             	sub    $0x8,%eax
80104b88:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104b8b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80104b92:	eb 37                	jmp    80104bcb <getcallerpcs+0x4f>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104b94:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80104b98:	74 51                	je     80104beb <getcallerpcs+0x6f>
80104b9a:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80104ba1:	76 48                	jbe    80104beb <getcallerpcs+0x6f>
80104ba3:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80104ba7:	74 42                	je     80104beb <getcallerpcs+0x6f>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ba9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bb6:	01 c2                	add    %eax,%edx
80104bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bbb:	8b 40 04             	mov    0x4(%eax),%eax
80104bbe:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80104bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104bc3:	8b 00                	mov    (%eax),%eax
80104bc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80104bc8:	ff 45 f8             	incl   -0x8(%ebp)
80104bcb:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104bcf:	7e c3                	jle    80104b94 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80104bd1:	eb 18                	jmp    80104beb <getcallerpcs+0x6f>
    pcs[i] = 0;
80104bd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104bd6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80104bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
80104be0:	01 d0                	add    %edx,%eax
80104be2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104be8:	ff 45 f8             	incl   -0x8(%ebp)
80104beb:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80104bef:	7e e2                	jle    80104bd3 <getcallerpcs+0x57>
}
80104bf1:	c9                   	leave  
80104bf2:	c3                   	ret    

80104bf3 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104bf3:	55                   	push   %ebp
80104bf4:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80104bf6:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf9:	8b 00                	mov    (%eax),%eax
80104bfb:	85 c0                	test   %eax,%eax
80104bfd:	74 17                	je     80104c16 <holding+0x23>
80104bff:	8b 45 08             	mov    0x8(%ebp),%eax
80104c02:	8b 50 08             	mov    0x8(%eax),%edx
80104c05:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c0b:	39 c2                	cmp    %eax,%edx
80104c0d:	75 07                	jne    80104c16 <holding+0x23>
80104c0f:	b8 01 00 00 00       	mov    $0x1,%eax
80104c14:	eb 05                	jmp    80104c1b <holding+0x28>
80104c16:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c1b:	5d                   	pop    %ebp
80104c1c:	c3                   	ret    

80104c1d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c1d:	55                   	push   %ebp
80104c1e:	89 e5                	mov    %esp,%ebp
80104c20:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80104c23:	e8 3c fe ff ff       	call   80104a64 <readeflags>
80104c28:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80104c2b:	e8 49 fe ff ff       	call   80104a79 <cli>
  if(cpu->ncli++ == 0)
80104c30:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c36:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104c3c:	85 d2                	test   %edx,%edx
80104c3e:	0f 94 c1             	sete   %cl
80104c41:	42                   	inc    %edx
80104c42:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104c48:	84 c9                	test   %cl,%cl
80104c4a:	74 15                	je     80104c61 <pushcli+0x44>
    cpu->intena = eflags & FL_IF;
80104c4c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c52:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104c55:	81 e2 00 02 00 00    	and    $0x200,%edx
80104c5b:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104c61:	c9                   	leave  
80104c62:	c3                   	ret    

80104c63 <popcli>:

void
popcli(void)
{
80104c63:	55                   	push   %ebp
80104c64:	89 e5                	mov    %esp,%ebp
80104c66:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80104c69:	e8 f6 fd ff ff       	call   80104a64 <readeflags>
80104c6e:	25 00 02 00 00       	and    $0x200,%eax
80104c73:	85 c0                	test   %eax,%eax
80104c75:	74 0c                	je     80104c83 <popcli+0x20>
    panic("popcli - interruptible");
80104c77:	c7 04 24 8d 85 10 80 	movl   $0x8010858d,(%esp)
80104c7e:	e8 b3 b8 ff ff       	call   80100536 <panic>
  if(--cpu->ncli < 0)
80104c83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104c89:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80104c8f:	4a                   	dec    %edx
80104c90:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80104c96:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104c9c:	85 c0                	test   %eax,%eax
80104c9e:	79 0c                	jns    80104cac <popcli+0x49>
    panic("popcli");
80104ca0:	c7 04 24 a4 85 10 80 	movl   $0x801085a4,(%esp)
80104ca7:	e8 8a b8 ff ff       	call   80100536 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80104cac:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cb2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104cb8:	85 c0                	test   %eax,%eax
80104cba:	75 15                	jne    80104cd1 <popcli+0x6e>
80104cbc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cc2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104cc8:	85 c0                	test   %eax,%eax
80104cca:	74 05                	je     80104cd1 <popcli+0x6e>
    sti();
80104ccc:	e8 ae fd ff ff       	call   80104a7f <sti>
}
80104cd1:	c9                   	leave  
80104cd2:	c3                   	ret    

80104cd3 <stosb>:
{
80104cd3:	55                   	push   %ebp
80104cd4:	89 e5                	mov    %esp,%ebp
80104cd6:	57                   	push   %edi
80104cd7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80104cd8:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cdb:	8b 55 10             	mov    0x10(%ebp),%edx
80104cde:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ce1:	89 cb                	mov    %ecx,%ebx
80104ce3:	89 df                	mov    %ebx,%edi
80104ce5:	89 d1                	mov    %edx,%ecx
80104ce7:	fc                   	cld    
80104ce8:	f3 aa                	rep stos %al,%es:(%edi)
80104cea:	89 ca                	mov    %ecx,%edx
80104cec:	89 fb                	mov    %edi,%ebx
80104cee:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104cf1:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104cf4:	5b                   	pop    %ebx
80104cf5:	5f                   	pop    %edi
80104cf6:	5d                   	pop    %ebp
80104cf7:	c3                   	ret    

80104cf8 <stosl>:
{
80104cf8:	55                   	push   %ebp
80104cf9:	89 e5                	mov    %esp,%ebp
80104cfb:	57                   	push   %edi
80104cfc:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80104cfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d00:	8b 55 10             	mov    0x10(%ebp),%edx
80104d03:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d06:	89 cb                	mov    %ecx,%ebx
80104d08:	89 df                	mov    %ebx,%edi
80104d0a:	89 d1                	mov    %edx,%ecx
80104d0c:	fc                   	cld    
80104d0d:	f3 ab                	rep stos %eax,%es:(%edi)
80104d0f:	89 ca                	mov    %ecx,%edx
80104d11:	89 fb                	mov    %edi,%ebx
80104d13:	89 5d 08             	mov    %ebx,0x8(%ebp)
80104d16:	89 55 10             	mov    %edx,0x10(%ebp)
}
80104d19:	5b                   	pop    %ebx
80104d1a:	5f                   	pop    %edi
80104d1b:	5d                   	pop    %ebp
80104d1c:	c3                   	ret    

80104d1d <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d1d:	55                   	push   %ebp
80104d1e:	89 e5                	mov    %esp,%ebp
80104d20:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
80104d23:	8b 45 08             	mov    0x8(%ebp),%eax
80104d26:	83 e0 03             	and    $0x3,%eax
80104d29:	85 c0                	test   %eax,%eax
80104d2b:	75 49                	jne    80104d76 <memset+0x59>
80104d2d:	8b 45 10             	mov    0x10(%ebp),%eax
80104d30:	83 e0 03             	and    $0x3,%eax
80104d33:	85 c0                	test   %eax,%eax
80104d35:	75 3f                	jne    80104d76 <memset+0x59>
    c &= 0xFF;
80104d37:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d3e:	8b 45 10             	mov    0x10(%ebp),%eax
80104d41:	c1 e8 02             	shr    $0x2,%eax
80104d44:	89 c2                	mov    %eax,%edx
80104d46:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d49:	89 c1                	mov    %eax,%ecx
80104d4b:	c1 e1 18             	shl    $0x18,%ecx
80104d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d51:	c1 e0 10             	shl    $0x10,%eax
80104d54:	09 c1                	or     %eax,%ecx
80104d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d59:	c1 e0 08             	shl    $0x8,%eax
80104d5c:	09 c8                	or     %ecx,%eax
80104d5e:	0b 45 0c             	or     0xc(%ebp),%eax
80104d61:	89 54 24 08          	mov    %edx,0x8(%esp)
80104d65:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d69:	8b 45 08             	mov    0x8(%ebp),%eax
80104d6c:	89 04 24             	mov    %eax,(%esp)
80104d6f:	e8 84 ff ff ff       	call   80104cf8 <stosl>
80104d74:	eb 19                	jmp    80104d8f <memset+0x72>
  } else
    stosb(dst, c, n);
80104d76:	8b 45 10             	mov    0x10(%ebp),%eax
80104d79:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d80:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d84:	8b 45 08             	mov    0x8(%ebp),%eax
80104d87:	89 04 24             	mov    %eax,(%esp)
80104d8a:	e8 44 ff ff ff       	call   80104cd3 <stosb>
  return dst;
80104d8f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    

80104d94 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d94:	55                   	push   %ebp
80104d95:	89 e5                	mov    %esp,%ebp
80104d97:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80104d9a:	8b 45 08             	mov    0x8(%ebp),%eax
80104d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80104da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104da3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80104da6:	eb 2c                	jmp    80104dd4 <memcmp+0x40>
    if(*s1 != *s2)
80104da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dab:	8a 10                	mov    (%eax),%dl
80104dad:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104db0:	8a 00                	mov    (%eax),%al
80104db2:	38 c2                	cmp    %al,%dl
80104db4:	74 18                	je     80104dce <memcmp+0x3a>
      return *s1 - *s2;
80104db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104db9:	8a 00                	mov    (%eax),%al
80104dbb:	0f b6 d0             	movzbl %al,%edx
80104dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104dc1:	8a 00                	mov    (%eax),%al
80104dc3:	0f b6 c0             	movzbl %al,%eax
80104dc6:	89 d1                	mov    %edx,%ecx
80104dc8:	29 c1                	sub    %eax,%ecx
80104dca:	89 c8                	mov    %ecx,%eax
80104dcc:	eb 19                	jmp    80104de7 <memcmp+0x53>
    s1++, s2++;
80104dce:	ff 45 fc             	incl   -0x4(%ebp)
80104dd1:	ff 45 f8             	incl   -0x8(%ebp)
  while(n-- > 0){
80104dd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104dd8:	0f 95 c0             	setne  %al
80104ddb:	ff 4d 10             	decl   0x10(%ebp)
80104dde:	84 c0                	test   %al,%al
80104de0:	75 c6                	jne    80104da8 <memcmp+0x14>
  }

  return 0;
80104de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104de7:	c9                   	leave  
80104de8:	c3                   	ret    

80104de9 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104de9:	55                   	push   %ebp
80104dea:	89 e5                	mov    %esp,%ebp
80104dec:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80104def:	8b 45 0c             	mov    0xc(%ebp),%eax
80104df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80104df5:	8b 45 08             	mov    0x8(%ebp),%eax
80104df8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80104dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104dfe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e01:	73 4d                	jae    80104e50 <memmove+0x67>
80104e03:	8b 45 10             	mov    0x10(%ebp),%eax
80104e06:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104e09:	01 d0                	add    %edx,%eax
80104e0b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80104e0e:	76 40                	jbe    80104e50 <memmove+0x67>
    s += n;
80104e10:	8b 45 10             	mov    0x10(%ebp),%eax
80104e13:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80104e16:	8b 45 10             	mov    0x10(%ebp),%eax
80104e19:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80104e1c:	eb 10                	jmp    80104e2e <memmove+0x45>
      *--d = *--s;
80104e1e:	ff 4d f8             	decl   -0x8(%ebp)
80104e21:	ff 4d fc             	decl   -0x4(%ebp)
80104e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e27:	8a 10                	mov    (%eax),%dl
80104e29:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e2c:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80104e2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e32:	0f 95 c0             	setne  %al
80104e35:	ff 4d 10             	decl   0x10(%ebp)
80104e38:	84 c0                	test   %al,%al
80104e3a:	75 e2                	jne    80104e1e <memmove+0x35>
  if(s < d && s + n > d){
80104e3c:	eb 21                	jmp    80104e5f <memmove+0x76>
  } else
    while(n-- > 0)
      *d++ = *s++;
80104e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e41:	8a 10                	mov    (%eax),%dl
80104e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
80104e46:	88 10                	mov    %dl,(%eax)
80104e48:	ff 45 f8             	incl   -0x8(%ebp)
80104e4b:	ff 45 fc             	incl   -0x4(%ebp)
80104e4e:	eb 01                	jmp    80104e51 <memmove+0x68>
    while(n-- > 0)
80104e50:	90                   	nop
80104e51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e55:	0f 95 c0             	setne  %al
80104e58:	ff 4d 10             	decl   0x10(%ebp)
80104e5b:	84 c0                	test   %al,%al
80104e5d:	75 df                	jne    80104e3e <memmove+0x55>

  return dst;
80104e5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104e62:	c9                   	leave  
80104e63:	c3                   	ret    

80104e64 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e64:	55                   	push   %ebp
80104e65:	89 e5                	mov    %esp,%ebp
80104e67:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80104e6a:	8b 45 10             	mov    0x10(%ebp),%eax
80104e6d:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e71:	8b 45 0c             	mov    0xc(%ebp),%eax
80104e74:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e78:	8b 45 08             	mov    0x8(%ebp),%eax
80104e7b:	89 04 24             	mov    %eax,(%esp)
80104e7e:	e8 66 ff ff ff       	call   80104de9 <memmove>
}
80104e83:	c9                   	leave  
80104e84:	c3                   	ret    

80104e85 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e85:	55                   	push   %ebp
80104e86:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80104e88:	eb 09                	jmp    80104e93 <strncmp+0xe>
    n--, p++, q++;
80104e8a:	ff 4d 10             	decl   0x10(%ebp)
80104e8d:	ff 45 08             	incl   0x8(%ebp)
80104e90:	ff 45 0c             	incl   0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80104e93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104e97:	74 17                	je     80104eb0 <strncmp+0x2b>
80104e99:	8b 45 08             	mov    0x8(%ebp),%eax
80104e9c:	8a 00                	mov    (%eax),%al
80104e9e:	84 c0                	test   %al,%al
80104ea0:	74 0e                	je     80104eb0 <strncmp+0x2b>
80104ea2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea5:	8a 10                	mov    (%eax),%dl
80104ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104eaa:	8a 00                	mov    (%eax),%al
80104eac:	38 c2                	cmp    %al,%dl
80104eae:	74 da                	je     80104e8a <strncmp+0x5>
  if(n == 0)
80104eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104eb4:	75 07                	jne    80104ebd <strncmp+0x38>
    return 0;
80104eb6:	b8 00 00 00 00       	mov    $0x0,%eax
80104ebb:	eb 16                	jmp    80104ed3 <strncmp+0x4e>
  return (uchar)*p - (uchar)*q;
80104ebd:	8b 45 08             	mov    0x8(%ebp),%eax
80104ec0:	8a 00                	mov    (%eax),%al
80104ec2:	0f b6 d0             	movzbl %al,%edx
80104ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ec8:	8a 00                	mov    (%eax),%al
80104eca:	0f b6 c0             	movzbl %al,%eax
80104ecd:	89 d1                	mov    %edx,%ecx
80104ecf:	29 c1                	sub    %eax,%ecx
80104ed1:	89 c8                	mov    %ecx,%eax
}
80104ed3:	5d                   	pop    %ebp
80104ed4:	c3                   	ret    

80104ed5 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ed5:	55                   	push   %ebp
80104ed6:	89 e5                	mov    %esp,%ebp
80104ed8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104edb:	8b 45 08             	mov    0x8(%ebp),%eax
80104ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80104ee1:	90                   	nop
80104ee2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104ee6:	0f 9f c0             	setg   %al
80104ee9:	ff 4d 10             	decl   0x10(%ebp)
80104eec:	84 c0                	test   %al,%al
80104eee:	74 2b                	je     80104f1b <strncpy+0x46>
80104ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ef3:	8a 10                	mov    (%eax),%dl
80104ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef8:	88 10                	mov    %dl,(%eax)
80104efa:	8b 45 08             	mov    0x8(%ebp),%eax
80104efd:	8a 00                	mov    (%eax),%al
80104eff:	84 c0                	test   %al,%al
80104f01:	0f 95 c0             	setne  %al
80104f04:	ff 45 08             	incl   0x8(%ebp)
80104f07:	ff 45 0c             	incl   0xc(%ebp)
80104f0a:	84 c0                	test   %al,%al
80104f0c:	75 d4                	jne    80104ee2 <strncpy+0xd>
    ;
  while(n-- > 0)
80104f0e:	eb 0b                	jmp    80104f1b <strncpy+0x46>
    *s++ = 0;
80104f10:	8b 45 08             	mov    0x8(%ebp),%eax
80104f13:	c6 00 00             	movb   $0x0,(%eax)
80104f16:	ff 45 08             	incl   0x8(%ebp)
80104f19:	eb 01                	jmp    80104f1c <strncpy+0x47>
  while(n-- > 0)
80104f1b:	90                   	nop
80104f1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f20:	0f 9f c0             	setg   %al
80104f23:	ff 4d 10             	decl   0x10(%ebp)
80104f26:	84 c0                	test   %al,%al
80104f28:	75 e6                	jne    80104f10 <strncpy+0x3b>
  return os;
80104f2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f2d:	c9                   	leave  
80104f2e:	c3                   	ret    

80104f2f <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f2f:	55                   	push   %ebp
80104f30:	89 e5                	mov    %esp,%ebp
80104f32:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80104f35:	8b 45 08             	mov    0x8(%ebp),%eax
80104f38:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80104f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f3f:	7f 05                	jg     80104f46 <safestrcpy+0x17>
    return os;
80104f41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104f44:	eb 30                	jmp    80104f76 <safestrcpy+0x47>
  while(--n > 0 && (*s++ = *t++) != 0)
80104f46:	ff 4d 10             	decl   0x10(%ebp)
80104f49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104f4d:	7e 1e                	jle    80104f6d <safestrcpy+0x3e>
80104f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f52:	8a 10                	mov    (%eax),%dl
80104f54:	8b 45 08             	mov    0x8(%ebp),%eax
80104f57:	88 10                	mov    %dl,(%eax)
80104f59:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5c:	8a 00                	mov    (%eax),%al
80104f5e:	84 c0                	test   %al,%al
80104f60:	0f 95 c0             	setne  %al
80104f63:	ff 45 08             	incl   0x8(%ebp)
80104f66:	ff 45 0c             	incl   0xc(%ebp)
80104f69:	84 c0                	test   %al,%al
80104f6b:	75 d9                	jne    80104f46 <safestrcpy+0x17>
    ;
  *s = 0;
80104f6d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f70:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80104f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f76:	c9                   	leave  
80104f77:	c3                   	ret    

80104f78 <strlen>:

int
strlen(const char *s)
{
80104f78:	55                   	push   %ebp
80104f79:	89 e5                	mov    %esp,%ebp
80104f7b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80104f7e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104f85:	eb 03                	jmp    80104f8a <strlen+0x12>
80104f87:	ff 45 fc             	incl   -0x4(%ebp)
80104f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80104f90:	01 d0                	add    %edx,%eax
80104f92:	8a 00                	mov    (%eax),%al
80104f94:	84 c0                	test   %al,%al
80104f96:	75 ef                	jne    80104f87 <strlen+0xf>
    ;
  return n;
80104f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104f9b:	c9                   	leave  
80104f9c:	c3                   	ret    

80104f9d <swtch>:
80104f9d:	8b 44 24 04          	mov    0x4(%esp),%eax
80104fa1:	8b 54 24 08          	mov    0x8(%esp),%edx
80104fa5:	55                   	push   %ebp
80104fa6:	53                   	push   %ebx
80104fa7:	56                   	push   %esi
80104fa8:	57                   	push   %edi
80104fa9:	89 20                	mov    %esp,(%eax)
80104fab:	89 d4                	mov    %edx,%esp
80104fad:	5f                   	pop    %edi
80104fae:	5e                   	pop    %esi
80104faf:	5b                   	pop    %ebx
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    

80104fb2 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104fb2:	55                   	push   %ebp
80104fb3:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104fb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fbb:	8b 00                	mov    (%eax),%eax
80104fbd:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fc0:	76 12                	jbe    80104fd4 <fetchint+0x22>
80104fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc5:	8d 50 04             	lea    0x4(%eax),%edx
80104fc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fce:	8b 00                	mov    (%eax),%eax
80104fd0:	39 c2                	cmp    %eax,%edx
80104fd2:	76 07                	jbe    80104fdb <fetchint+0x29>
    return -1;
80104fd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd9:	eb 0f                	jmp    80104fea <fetchint+0x38>
  *ip = *(int*)(addr);
80104fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80104fde:	8b 10                	mov    (%eax),%edx
80104fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fe3:	89 10                	mov    %edx,(%eax)
  return 0;
80104fe5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104fea:	5d                   	pop    %ebp
80104feb:	c3                   	ret    

80104fec <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fec:	55                   	push   %ebp
80104fed:	89 e5                	mov    %esp,%ebp
80104fef:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80104ff2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ff8:	8b 00                	mov    (%eax),%eax
80104ffa:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ffd:	77 07                	ja     80105006 <fetchstr+0x1a>
    return -1;
80104fff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105004:	eb 46                	jmp    8010504c <fetchstr+0x60>
  *pp = (char*)addr;
80105006:	8b 55 08             	mov    0x8(%ebp),%edx
80105009:	8b 45 0c             	mov    0xc(%ebp),%eax
8010500c:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
8010500e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105014:	8b 00                	mov    (%eax),%eax
80105016:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501c:	8b 00                	mov    (%eax),%eax
8010501e:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105021:	eb 1c                	jmp    8010503f <fetchstr+0x53>
    if(*s == 0)
80105023:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105026:	8a 00                	mov    (%eax),%al
80105028:	84 c0                	test   %al,%al
8010502a:	75 10                	jne    8010503c <fetchstr+0x50>
      return s - *pp;
8010502c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010502f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105032:	8b 00                	mov    (%eax),%eax
80105034:	89 d1                	mov    %edx,%ecx
80105036:	29 c1                	sub    %eax,%ecx
80105038:	89 c8                	mov    %ecx,%eax
8010503a:	eb 10                	jmp    8010504c <fetchstr+0x60>
  for(s = *pp; s < ep; s++)
8010503c:	ff 45 fc             	incl   -0x4(%ebp)
8010503f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105042:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105045:	72 dc                	jb     80105023 <fetchstr+0x37>
  return -1;
80105047:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010504c:	c9                   	leave  
8010504d:	c3                   	ret    

8010504e <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
8010504e:	55                   	push   %ebp
8010504f:	89 e5                	mov    %esp,%ebp
80105051:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105054:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010505a:	8b 40 18             	mov    0x18(%eax),%eax
8010505d:	8b 50 44             	mov    0x44(%eax),%edx
80105060:	8b 45 08             	mov    0x8(%ebp),%eax
80105063:	c1 e0 02             	shl    $0x2,%eax
80105066:	01 d0                	add    %edx,%eax
80105068:	8d 50 04             	lea    0x4(%eax),%edx
8010506b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010506e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105072:	89 14 24             	mov    %edx,(%esp)
80105075:	e8 38 ff ff ff       	call   80104fb2 <fetchint>
}
8010507a:	c9                   	leave  
8010507b:	c3                   	ret    

8010507c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010507c:	55                   	push   %ebp
8010507d:	89 e5                	mov    %esp,%ebp
8010507f:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105082:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105085:	89 44 24 04          	mov    %eax,0x4(%esp)
80105089:	8b 45 08             	mov    0x8(%ebp),%eax
8010508c:	89 04 24             	mov    %eax,(%esp)
8010508f:	e8 ba ff ff ff       	call   8010504e <argint>
80105094:	85 c0                	test   %eax,%eax
80105096:	79 07                	jns    8010509f <argptr+0x23>
    return -1;
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb 3d                	jmp    801050dc <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010509f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050a2:	89 c2                	mov    %eax,%edx
801050a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050aa:	8b 00                	mov    (%eax),%eax
801050ac:	39 c2                	cmp    %eax,%edx
801050ae:	73 16                	jae    801050c6 <argptr+0x4a>
801050b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050b3:	89 c2                	mov    %eax,%edx
801050b5:	8b 45 10             	mov    0x10(%ebp),%eax
801050b8:	01 c2                	add    %eax,%edx
801050ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c0:	8b 00                	mov    (%eax),%eax
801050c2:	39 c2                	cmp    %eax,%edx
801050c4:	76 07                	jbe    801050cd <argptr+0x51>
    return -1;
801050c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cb:	eb 0f                	jmp    801050dc <argptr+0x60>
  *pp = (char*)i;
801050cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801050d0:	89 c2                	mov    %eax,%edx
801050d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801050d5:	89 10                	mov    %edx,(%eax)
  return 0;
801050d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050dc:	c9                   	leave  
801050dd:	c3                   	ret    

801050de <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050de:	55                   	push   %ebp
801050df:	89 e5                	mov    %esp,%ebp
801050e1:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050e4:	8d 45 fc             	lea    -0x4(%ebp),%eax
801050e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801050eb:	8b 45 08             	mov    0x8(%ebp),%eax
801050ee:	89 04 24             	mov    %eax,(%esp)
801050f1:	e8 58 ff ff ff       	call   8010504e <argint>
801050f6:	85 c0                	test   %eax,%eax
801050f8:	79 07                	jns    80105101 <argstr+0x23>
    return -1;
801050fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ff:	eb 12                	jmp    80105113 <argstr+0x35>
  return fetchstr(addr, pp);
80105101:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105104:	8b 55 0c             	mov    0xc(%ebp),%edx
80105107:	89 54 24 04          	mov    %edx,0x4(%esp)
8010510b:	89 04 24             	mov    %eax,(%esp)
8010510e:	e8 d9 fe ff ff       	call   80104fec <fetchstr>
}
80105113:	c9                   	leave  
80105114:	c3                   	ret    

80105115 <syscall>:
[SYS_isatty]  sys_isatty,
};

void
syscall(void)
{
80105115:	55                   	push   %ebp
80105116:	89 e5                	mov    %esp,%ebp
80105118:	53                   	push   %ebx
80105119:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010511c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105122:	8b 40 18             	mov    0x18(%eax),%eax
80105125:	8b 40 1c             	mov    0x1c(%eax),%eax
80105128:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010512b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010512f:	7e 30                	jle    80105161 <syscall+0x4c>
80105131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105134:	83 f8 17             	cmp    $0x17,%eax
80105137:	77 28                	ja     80105161 <syscall+0x4c>
80105139:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010513c:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105143:	85 c0                	test   %eax,%eax
80105145:	74 1a                	je     80105161 <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105147:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514d:	8b 58 18             	mov    0x18(%eax),%ebx
80105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105153:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010515a:	ff d0                	call   *%eax
8010515c:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010515f:	eb 3d                	jmp    8010519e <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105161:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105167:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010516a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105170:	8b 40 10             	mov    0x10(%eax),%eax
80105173:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105176:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010517a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010517e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105182:	c7 04 24 ab 85 10 80 	movl   $0x801085ab,(%esp)
80105189:	e8 13 b2 ff ff       	call   801003a1 <cprintf>
    proc->tf->eax = -1;
8010518e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105194:	8b 40 18             	mov    0x18(%eax),%eax
80105197:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010519e:	83 c4 24             	add    $0x24,%esp
801051a1:	5b                   	pop    %ebx
801051a2:	5d                   	pop    %ebp
801051a3:	c3                   	ret    

801051a4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801051aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b1:	8b 45 08             	mov    0x8(%ebp),%eax
801051b4:	89 04 24             	mov    %eax,(%esp)
801051b7:	e8 92 fe ff ff       	call   8010504e <argint>
801051bc:	85 c0                	test   %eax,%eax
801051be:	79 07                	jns    801051c7 <argfd+0x23>
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb 50                	jmp    80105217 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801051c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ca:	85 c0                	test   %eax,%eax
801051cc:	78 21                	js     801051ef <argfd+0x4b>
801051ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051d1:	83 f8 0f             	cmp    $0xf,%eax
801051d4:	7f 19                	jg     801051ef <argfd+0x4b>
801051d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051df:	83 c2 08             	add    $0x8,%edx
801051e2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801051e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801051e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051ed:	75 07                	jne    801051f6 <argfd+0x52>
    return -1;
801051ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f4:	eb 21                	jmp    80105217 <argfd+0x73>
  if(pfd)
801051f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801051fa:	74 08                	je     80105204 <argfd+0x60>
    *pfd = fd;
801051fc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801051ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105202:	89 10                	mov    %edx,(%eax)
  if(pf)
80105204:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105208:	74 08                	je     80105212 <argfd+0x6e>
    *pf = f;
8010520a:	8b 45 10             	mov    0x10(%ebp),%eax
8010520d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105210:	89 10                	mov    %edx,(%eax)
  return 0;
80105212:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105217:	c9                   	leave  
80105218:	c3                   	ret    

80105219 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105219:	55                   	push   %ebp
8010521a:	89 e5                	mov    %esp,%ebp
8010521c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010521f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105226:	eb 2f                	jmp    80105257 <fdalloc+0x3e>
    if(proc->ofile[fd] == 0){
80105228:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105231:	83 c2 08             	add    $0x8,%edx
80105234:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105238:	85 c0                	test   %eax,%eax
8010523a:	75 18                	jne    80105254 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010523c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105242:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105245:	8d 4a 08             	lea    0x8(%edx),%ecx
80105248:	8b 55 08             	mov    0x8(%ebp),%edx
8010524b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010524f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105252:	eb 0e                	jmp    80105262 <fdalloc+0x49>
  for(fd = 0; fd < NOFILE; fd++){
80105254:	ff 45 fc             	incl   -0x4(%ebp)
80105257:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010525b:	7e cb                	jle    80105228 <fdalloc+0xf>
    }
  }
  return -1;
8010525d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105262:	c9                   	leave  
80105263:	c3                   	ret    

80105264 <sys_dup>:

int
sys_dup(void)
{
80105264:	55                   	push   %ebp
80105265:	89 e5                	mov    %esp,%ebp
80105267:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010526a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010526d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105271:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105278:	00 
80105279:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105280:	e8 1f ff ff ff       	call   801051a4 <argfd>
80105285:	85 c0                	test   %eax,%eax
80105287:	79 07                	jns    80105290 <sys_dup+0x2c>
    return -1;
80105289:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010528e:	eb 29                	jmp    801052b9 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105290:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105293:	89 04 24             	mov    %eax,(%esp)
80105296:	e8 7e ff ff ff       	call   80105219 <fdalloc>
8010529b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010529e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052a2:	79 07                	jns    801052ab <sys_dup+0x47>
    return -1;
801052a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a9:	eb 0e                	jmp    801052b9 <sys_dup+0x55>
  filedup(f);
801052ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ae:	89 04 24             	mov    %eax,(%esp)
801052b1:	e8 9d bc ff ff       	call   80100f53 <filedup>
  return fd;
801052b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801052b9:	c9                   	leave  
801052ba:	c3                   	ret    

801052bb <sys_read>:

int
sys_read(void)
{
801052bb:	55                   	push   %ebp
801052bc:	89 e5                	mov    %esp,%ebp
801052be:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801052c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801052c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801052cf:	00 
801052d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052d7:	e8 c8 fe ff ff       	call   801051a4 <argfd>
801052dc:	85 c0                	test   %eax,%eax
801052de:	78 35                	js     80105315 <sys_read+0x5a>
801052e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801052ee:	e8 5b fd ff ff       	call   8010504e <argint>
801052f3:	85 c0                	test   %eax,%eax
801052f5:	78 1e                	js     80105315 <sys_read+0x5a>
801052f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052fa:	89 44 24 08          	mov    %eax,0x8(%esp)
801052fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105301:	89 44 24 04          	mov    %eax,0x4(%esp)
80105305:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010530c:	e8 6b fd ff ff       	call   8010507c <argptr>
80105311:	85 c0                	test   %eax,%eax
80105313:	79 07                	jns    8010531c <sys_read+0x61>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb 19                	jmp    80105335 <sys_read+0x7a>
  return fileread(f, p, n);
8010531c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010531f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105325:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105329:	89 54 24 04          	mov    %edx,0x4(%esp)
8010532d:	89 04 24             	mov    %eax,(%esp)
80105330:	e8 7f bd ff ff       	call   801010b4 <fileread>
}
80105335:	c9                   	leave  
80105336:	c3                   	ret    

80105337 <sys_write>:

int
sys_write(void)
{
80105337:	55                   	push   %ebp
80105338:	89 e5                	mov    %esp,%ebp
8010533a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010533d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105340:	89 44 24 08          	mov    %eax,0x8(%esp)
80105344:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010534b:	00 
8010534c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105353:	e8 4c fe ff ff       	call   801051a4 <argfd>
80105358:	85 c0                	test   %eax,%eax
8010535a:	78 35                	js     80105391 <sys_write+0x5a>
8010535c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010535f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105363:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010536a:	e8 df fc ff ff       	call   8010504e <argint>
8010536f:	85 c0                	test   %eax,%eax
80105371:	78 1e                	js     80105391 <sys_write+0x5a>
80105373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105376:	89 44 24 08          	mov    %eax,0x8(%esp)
8010537a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010537d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105388:	e8 ef fc ff ff       	call   8010507c <argptr>
8010538d:	85 c0                	test   %eax,%eax
8010538f:	79 07                	jns    80105398 <sys_write+0x61>
    return -1;
80105391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105396:	eb 19                	jmp    801053b1 <sys_write+0x7a>
  return filewrite(f, p, n);
80105398:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010539b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010539e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053a1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801053a5:	89 54 24 04          	mov    %edx,0x4(%esp)
801053a9:	89 04 24             	mov    %eax,(%esp)
801053ac:	e8 be bd ff ff       	call   8010116f <filewrite>
}
801053b1:	c9                   	leave  
801053b2:	c3                   	ret    

801053b3 <sys_isatty>:

// Minimalish implementation of isatty for xv6. Maybe it will even work, but 
// hopefully it will be sufficient for now.
int sys_isatty(void) {
801053b3:	55                   	push   %ebp
801053b4:	89 e5                	mov    %esp,%ebp
801053b6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  argfd(0, &fd, &f);
801053b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801053c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801053c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053ce:	e8 d1 fd ff ff       	call   801051a4 <argfd>
  if (f->type == FD_INODE) {
801053d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d6:	8b 00                	mov    (%eax),%eax
801053d8:	83 f8 02             	cmp    $0x2,%eax
801053db:	75 20                	jne    801053fd <sys_isatty+0x4a>
    /* This is bad and wrong, but currently works. Either when more 
     * sophisticated terminal handling comes, or more devices, or both, this
     * will need to distinguish different device types. Still, it's a start. */
    if (f->ip != 0 && f->ip->type == T_DEV)
801053dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053e0:	8b 40 10             	mov    0x10(%eax),%eax
801053e3:	85 c0                	test   %eax,%eax
801053e5:	74 16                	je     801053fd <sys_isatty+0x4a>
801053e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053ea:	8b 40 10             	mov    0x10(%eax),%eax
801053ed:	8b 40 10             	mov    0x10(%eax),%eax
801053f0:	66 83 f8 03          	cmp    $0x3,%ax
801053f4:	75 07                	jne    801053fd <sys_isatty+0x4a>
      return 1;
801053f6:	b8 01 00 00 00       	mov    $0x1,%eax
801053fb:	eb 05                	jmp    80105402 <sys_isatty+0x4f>
  }
  return 0;
801053fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105402:	c9                   	leave  
80105403:	c3                   	ret    

80105404 <sys_lseek>:

// lseek derived from https://github.com/hxp/xv6, written by Joel Heikkila

int sys_lseek(void) {
80105404:	55                   	push   %ebp
80105405:	89 e5                	mov    %esp,%ebp
80105407:	83 ec 48             	sub    $0x48,%esp
	int zerosize, i;
	char *zeroed, *z;

	struct file *f;

	argfd(0, &fd, &f);
8010540a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
8010540d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105411:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105414:	89 44 24 04          	mov    %eax,0x4(%esp)
80105418:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010541f:	e8 80 fd ff ff       	call   801051a4 <argfd>
	argint(1, &offset);
80105424:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105427:	89 44 24 04          	mov    %eax,0x4(%esp)
8010542b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105432:	e8 17 fc ff ff       	call   8010504e <argint>
	argint(2, &base);
80105437:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010543a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010543e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105445:	e8 04 fc ff ff       	call   8010504e <argint>

	if( base == SEEK_SET) {
8010544a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010544d:	85 c0                	test   %eax,%eax
8010544f:	75 06                	jne    80105457 <sys_lseek+0x53>
		newoff = offset;
80105451:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105454:	89 45 f4             	mov    %eax,-0xc(%ebp)
	}

	if (base == SEEK_CUR)
80105457:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010545a:	83 f8 01             	cmp    $0x1,%eax
8010545d:	75 0e                	jne    8010546d <sys_lseek+0x69>
		newoff = f->off + offset;
8010545f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105462:	8b 50 14             	mov    0x14(%eax),%edx
80105465:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105468:	01 d0                	add    %edx,%eax
8010546a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if (base == SEEK_END)
8010546d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105470:	83 f8 02             	cmp    $0x2,%eax
80105473:	75 11                	jne    80105486 <sys_lseek+0x82>
		newoff = f->ip->size + offset;
80105475:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105478:	8b 40 10             	mov    0x10(%eax),%eax
8010547b:	8b 50 18             	mov    0x18(%eax),%edx
8010547e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105481:	01 d0                	add    %edx,%eax
80105483:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (newoff < f->ip->size)
80105486:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105489:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010548c:	8b 40 10             	mov    0x10(%eax),%eax
8010548f:	8b 40 18             	mov    0x18(%eax),%eax
80105492:	39 c2                	cmp    %eax,%edx
80105494:	73 0a                	jae    801054a0 <sys_lseek+0x9c>
		return -1;
80105496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549b:	e9 92 00 00 00       	jmp    80105532 <sys_lseek+0x12e>

	if (newoff > f->ip->size){
801054a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801054a6:	8b 40 10             	mov    0x10(%eax),%eax
801054a9:	8b 40 18             	mov    0x18(%eax),%eax
801054ac:	39 c2                	cmp    %eax,%edx
801054ae:	76 74                	jbe    80105524 <sys_lseek+0x120>
		zerosize = newoff - f->ip->size;
801054b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801054b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801054b6:	8b 40 10             	mov    0x10(%eax),%eax
801054b9:	8b 40 18             	mov    0x18(%eax),%eax
801054bc:	89 d1                	mov    %edx,%ecx
801054be:	29 c1                	sub    %eax,%ecx
801054c0:	89 c8                	mov    %ecx,%eax
801054c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		zeroed = kalloc();
801054c5:	e8 f4 d5 ff ff       	call   80102abe <kalloc>
801054ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		z = zeroed;
801054cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801054d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		for (i = 0; i < 4096; i++)
801054d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801054da:	eb 0c                	jmp    801054e8 <sys_lseek+0xe4>
			*z++ = 0;
801054dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801054df:	c6 00 00             	movb   $0x0,(%eax)
801054e2:	ff 45 e8             	incl   -0x18(%ebp)
		for (i = 0; i < 4096; i++)
801054e5:	ff 45 ec             	incl   -0x14(%ebp)
801054e8:	81 7d ec ff 0f 00 00 	cmpl   $0xfff,-0x14(%ebp)
801054ef:	7e eb                	jle    801054dc <sys_lseek+0xd8>
		while (zerosize > 0){
801054f1:	eb 20                	jmp    80105513 <sys_lseek+0x10f>
			filewrite(f, zeroed, zerosize);
801054f3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801054f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801054f9:	89 54 24 08          	mov    %edx,0x8(%esp)
801054fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105500:	89 54 24 04          	mov    %edx,0x4(%esp)
80105504:	89 04 24             	mov    %eax,(%esp)
80105507:	e8 63 bc ff ff       	call   8010116f <filewrite>
			zerosize -= 4096;
8010550c:	81 6d f0 00 10 00 00 	subl   $0x1000,-0x10(%ebp)
		while (zerosize > 0){
80105513:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105517:	7f da                	jg     801054f3 <sys_lseek+0xef>
		}
		kfree(zeroed);
80105519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010551c:	89 04 24             	mov    %eax,(%esp)
8010551f:	e8 01 d5 ff ff       	call   80102a25 <kfree>
	}

	f->off = newoff;
80105524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105527:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010552a:	89 50 14             	mov    %edx,0x14(%eax)
	return 0;
8010552d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105532:	c9                   	leave  
80105533:	c3                   	ret    

80105534 <sys_close>:

int
sys_close(void)
{
80105534:	55                   	push   %ebp
80105535:	89 e5                	mov    %esp,%ebp
80105537:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010553a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010553d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105541:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105544:	89 44 24 04          	mov    %eax,0x4(%esp)
80105548:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010554f:	e8 50 fc ff ff       	call   801051a4 <argfd>
80105554:	85 c0                	test   %eax,%eax
80105556:	79 07                	jns    8010555f <sys_close+0x2b>
    return -1;
80105558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555d:	eb 24                	jmp    80105583 <sys_close+0x4f>
  proc->ofile[fd] = 0;
8010555f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105565:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105568:	83 c2 08             	add    $0x8,%edx
8010556b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105572:	00 
  fileclose(f);
80105573:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105576:	89 04 24             	mov    %eax,(%esp)
80105579:	e8 1d ba ff ff       	call   80100f9b <fileclose>
  return 0;
8010557e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105583:	c9                   	leave  
80105584:	c3                   	ret    

80105585 <sys_fstat>:

int
sys_fstat(void)
{
80105585:	55                   	push   %ebp
80105586:	89 e5                	mov    %esp,%ebp
80105588:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010558b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010558e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105592:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105599:	00 
8010559a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055a1:	e8 fe fb ff ff       	call   801051a4 <argfd>
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 1f                	js     801055c9 <sys_fstat+0x44>
801055aa:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801055b1:	00 
801055b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801055b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055c0:	e8 b7 fa ff ff       	call   8010507c <argptr>
801055c5:	85 c0                	test   %eax,%eax
801055c7:	79 07                	jns    801055d0 <sys_fstat+0x4b>
    return -1;
801055c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ce:	eb 12                	jmp    801055e2 <sys_fstat+0x5d>
  return filestat(f, st);
801055d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801055d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801055da:	89 04 24             	mov    %eax,(%esp)
801055dd:	e8 83 ba ff ff       	call   80101065 <filestat>
}
801055e2:	c9                   	leave  
801055e3:	c3                   	ret    

801055e4 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801055e4:	55                   	push   %ebp
801055e5:	89 e5                	mov    %esp,%ebp
801055e7:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801055ea:	8d 45 d8             	lea    -0x28(%ebp),%eax
801055ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801055f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055f8:	e8 e1 fa ff ff       	call   801050de <argstr>
801055fd:	85 c0                	test   %eax,%eax
801055ff:	78 17                	js     80105618 <sys_link+0x34>
80105601:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105604:	89 44 24 04          	mov    %eax,0x4(%esp)
80105608:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010560f:	e8 ca fa ff ff       	call   801050de <argstr>
80105614:	85 c0                	test   %eax,%eax
80105616:	79 0a                	jns    80105622 <sys_link+0x3e>
    return -1;
80105618:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010561d:	e9 37 01 00 00       	jmp    80105759 <sys_link+0x175>
  if((ip = namei(old)) == 0)
80105622:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105625:	89 04 24             	mov    %eax,(%esp)
80105628:	e8 b2 cd ff ff       	call   801023df <namei>
8010562d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105634:	75 0a                	jne    80105640 <sys_link+0x5c>
    return -1;
80105636:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563b:	e9 19 01 00 00       	jmp    80105759 <sys_link+0x175>

  begin_trans();
80105640:	e8 8b db ff ff       	call   801031d0 <begin_trans>

  ilock(ip);
80105645:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105648:	89 04 24             	mov    %eax,(%esp)
8010564b:	e8 f5 c1 ff ff       	call   80101845 <ilock>
  if(ip->type == T_DIR){
80105650:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105653:	8b 40 10             	mov    0x10(%eax),%eax
80105656:	66 83 f8 01          	cmp    $0x1,%ax
8010565a:	75 1a                	jne    80105676 <sys_link+0x92>
    iunlockput(ip);
8010565c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565f:	89 04 24             	mov    %eax,(%esp)
80105662:	e8 5f c4 ff ff       	call   80101ac6 <iunlockput>
    commit_trans();
80105667:	e8 ad db ff ff       	call   80103219 <commit_trans>
    return -1;
8010566c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105671:	e9 e3 00 00 00       	jmp    80105759 <sys_link+0x175>
  }

  ip->nlink++;
80105676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105679:	66 8b 40 16          	mov    0x16(%eax),%ax
8010567d:	40                   	inc    %eax
8010567e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105681:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105685:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105688:	89 04 24             	mov    %eax,(%esp)
8010568b:	e8 fb bf ff ff       	call   8010168b <iupdate>
  iunlock(ip);
80105690:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105693:	89 04 24             	mov    %eax,(%esp)
80105696:	e8 f5 c2 ff ff       	call   80101990 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
8010569b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010569e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801056a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801056a5:	89 04 24             	mov    %eax,(%esp)
801056a8:	e8 54 cd ff ff       	call   80102401 <nameiparent>
801056ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
801056b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056b4:	74 68                	je     8010571e <sys_link+0x13a>
    goto bad;
  ilock(dp);
801056b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056b9:	89 04 24             	mov    %eax,(%esp)
801056bc:	e8 84 c1 ff ff       	call   80101845 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056c4:	8b 10                	mov    (%eax),%edx
801056c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c9:	8b 00                	mov    (%eax),%eax
801056cb:	39 c2                	cmp    %eax,%edx
801056cd:	75 20                	jne    801056ef <sys_link+0x10b>
801056cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d2:	8b 40 04             	mov    0x4(%eax),%eax
801056d5:	89 44 24 08          	mov    %eax,0x8(%esp)
801056d9:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801056dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801056e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056e3:	89 04 24             	mov    %eax,(%esp)
801056e6:	e8 3d ca ff ff       	call   80102128 <dirlink>
801056eb:	85 c0                	test   %eax,%eax
801056ed:	79 0d                	jns    801056fc <sys_link+0x118>
    iunlockput(dp);
801056ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f2:	89 04 24             	mov    %eax,(%esp)
801056f5:	e8 cc c3 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
801056fa:	eb 23                	jmp    8010571f <sys_link+0x13b>
  }
  iunlockput(dp);
801056fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ff:	89 04 24             	mov    %eax,(%esp)
80105702:	e8 bf c3 ff ff       	call   80101ac6 <iunlockput>
  iput(ip);
80105707:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570a:	89 04 24             	mov    %eax,(%esp)
8010570d:	e8 e3 c2 ff ff       	call   801019f5 <iput>

  commit_trans();
80105712:	e8 02 db ff ff       	call   80103219 <commit_trans>

  return 0;
80105717:	b8 00 00 00 00       	mov    $0x0,%eax
8010571c:	eb 3b                	jmp    80105759 <sys_link+0x175>
    goto bad;
8010571e:	90                   	nop

bad:
  ilock(ip);
8010571f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105722:	89 04 24             	mov    %eax,(%esp)
80105725:	e8 1b c1 ff ff       	call   80101845 <ilock>
  ip->nlink--;
8010572a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572d:	66 8b 40 16          	mov    0x16(%eax),%ax
80105731:	48                   	dec    %eax
80105732:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105735:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
80105739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573c:	89 04 24             	mov    %eax,(%esp)
8010573f:	e8 47 bf ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80105744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105747:	89 04 24             	mov    %eax,(%esp)
8010574a:	e8 77 c3 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
8010574f:	e8 c5 da ff ff       	call   80103219 <commit_trans>
  return -1;
80105754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105759:	c9                   	leave  
8010575a:	c3                   	ret    

8010575b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010575b:	55                   	push   %ebp
8010575c:	89 e5                	mov    %esp,%ebp
8010575e:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105761:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105768:	eb 4a                	jmp    801057b4 <isdirempty+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010576a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010576d:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105774:	00 
80105775:	89 44 24 08          	mov    %eax,0x8(%esp)
80105779:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010577c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105780:	8b 45 08             	mov    0x8(%ebp),%eax
80105783:	89 04 24             	mov    %eax,(%esp)
80105786:	e8 c1 c5 ff ff       	call   80101d4c <readi>
8010578b:	83 f8 10             	cmp    $0x10,%eax
8010578e:	74 0c                	je     8010579c <isdirempty+0x41>
      panic("isdirempty: readi");
80105790:	c7 04 24 c7 85 10 80 	movl   $0x801085c7,(%esp)
80105797:	e8 9a ad ff ff       	call   80100536 <panic>
    if(de.inum != 0)
8010579c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010579f:	66 85 c0             	test   %ax,%ax
801057a2:	74 07                	je     801057ab <isdirempty+0x50>
      return 0;
801057a4:	b8 00 00 00 00       	mov    $0x0,%eax
801057a9:	eb 1b                	jmp    801057c6 <isdirempty+0x6b>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ae:	83 c0 10             	add    $0x10,%eax
801057b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057b7:	8b 45 08             	mov    0x8(%ebp),%eax
801057ba:	8b 40 18             	mov    0x18(%eax),%eax
801057bd:	39 c2                	cmp    %eax,%edx
801057bf:	72 a9                	jb     8010576a <isdirempty+0xf>
  }
  return 1;
801057c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057c6:	c9                   	leave  
801057c7:	c3                   	ret    

801057c8 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801057c8:	55                   	push   %ebp
801057c9:	89 e5                	mov    %esp,%ebp
801057cb:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801057ce:	8d 45 cc             	lea    -0x34(%ebp),%eax
801057d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057dc:	e8 fd f8 ff ff       	call   801050de <argstr>
801057e1:	85 c0                	test   %eax,%eax
801057e3:	79 0a                	jns    801057ef <sys_unlink+0x27>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ea:	e9 a4 01 00 00       	jmp    80105993 <sys_unlink+0x1cb>
  if((dp = nameiparent(path, name)) == 0)
801057ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
801057f2:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801057f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801057f9:	89 04 24             	mov    %eax,(%esp)
801057fc:	e8 00 cc ff ff       	call   80102401 <nameiparent>
80105801:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105808:	75 0a                	jne    80105814 <sys_unlink+0x4c>
    return -1;
8010580a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010580f:	e9 7f 01 00 00       	jmp    80105993 <sys_unlink+0x1cb>

  begin_trans();
80105814:	e8 b7 d9 ff ff       	call   801031d0 <begin_trans>

  ilock(dp);
80105819:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010581c:	89 04 24             	mov    %eax,(%esp)
8010581f:	e8 21 c0 ff ff       	call   80101845 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105824:	c7 44 24 04 d9 85 10 	movl   $0x801085d9,0x4(%esp)
8010582b:	80 
8010582c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010582f:	89 04 24             	mov    %eax,(%esp)
80105832:	e8 0a c8 ff ff       	call   80102041 <namecmp>
80105837:	85 c0                	test   %eax,%eax
80105839:	0f 84 3f 01 00 00    	je     8010597e <sys_unlink+0x1b6>
8010583f:	c7 44 24 04 db 85 10 	movl   $0x801085db,0x4(%esp)
80105846:	80 
80105847:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010584a:	89 04 24             	mov    %eax,(%esp)
8010584d:	e8 ef c7 ff ff       	call   80102041 <namecmp>
80105852:	85 c0                	test   %eax,%eax
80105854:	0f 84 24 01 00 00    	je     8010597e <sys_unlink+0x1b6>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010585a:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010585d:	89 44 24 08          	mov    %eax,0x8(%esp)
80105861:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105864:	89 44 24 04          	mov    %eax,0x4(%esp)
80105868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010586b:	89 04 24             	mov    %eax,(%esp)
8010586e:	e8 f0 c7 ff ff       	call   80102063 <dirlookup>
80105873:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105876:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010587a:	0f 84 fd 00 00 00    	je     8010597d <sys_unlink+0x1b5>
    goto bad;
  ilock(ip);
80105880:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105883:	89 04 24             	mov    %eax,(%esp)
80105886:	e8 ba bf ff ff       	call   80101845 <ilock>

  if(ip->nlink < 1)
8010588b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010588e:	66 8b 40 16          	mov    0x16(%eax),%ax
80105892:	66 85 c0             	test   %ax,%ax
80105895:	7f 0c                	jg     801058a3 <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105897:	c7 04 24 de 85 10 80 	movl   $0x801085de,(%esp)
8010589e:	e8 93 ac ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058a6:	8b 40 10             	mov    0x10(%eax),%eax
801058a9:	66 83 f8 01          	cmp    $0x1,%ax
801058ad:	75 1f                	jne    801058ce <sys_unlink+0x106>
801058af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b2:	89 04 24             	mov    %eax,(%esp)
801058b5:	e8 a1 fe ff ff       	call   8010575b <isdirempty>
801058ba:	85 c0                	test   %eax,%eax
801058bc:	75 10                	jne    801058ce <sys_unlink+0x106>
    iunlockput(ip);
801058be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058c1:	89 04 24             	mov    %eax,(%esp)
801058c4:	e8 fd c1 ff ff       	call   80101ac6 <iunlockput>
    goto bad;
801058c9:	e9 b0 00 00 00       	jmp    8010597e <sys_unlink+0x1b6>
  }

  memset(&de, 0, sizeof(de));
801058ce:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801058d5:	00 
801058d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058dd:	00 
801058de:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058e1:	89 04 24             	mov    %eax,(%esp)
801058e4:	e8 34 f4 ff ff       	call   80104d1d <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
801058ec:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801058f3:	00 
801058f4:	89 44 24 08          	mov    %eax,0x8(%esp)
801058f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801058fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105902:	89 04 24             	mov    %eax,(%esp)
80105905:	e8 a7 c5 ff ff       	call   80101eb1 <writei>
8010590a:	83 f8 10             	cmp    $0x10,%eax
8010590d:	74 0c                	je     8010591b <sys_unlink+0x153>
    panic("unlink: writei");
8010590f:	c7 04 24 f0 85 10 80 	movl   $0x801085f0,(%esp)
80105916:	e8 1b ac ff ff       	call   80100536 <panic>
  if(ip->type == T_DIR){
8010591b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591e:	8b 40 10             	mov    0x10(%eax),%eax
80105921:	66 83 f8 01          	cmp    $0x1,%ax
80105925:	75 1a                	jne    80105941 <sys_unlink+0x179>
    dp->nlink--;
80105927:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010592a:	66 8b 40 16          	mov    0x16(%eax),%ax
8010592e:	48                   	dec    %eax
8010592f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105932:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105936:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105939:	89 04 24             	mov    %eax,(%esp)
8010593c:	e8 4a bd ff ff       	call   8010168b <iupdate>
  }
  iunlockput(dp);
80105941:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105944:	89 04 24             	mov    %eax,(%esp)
80105947:	e8 7a c1 ff ff       	call   80101ac6 <iunlockput>

  ip->nlink--;
8010594c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010594f:	66 8b 40 16          	mov    0x16(%eax),%ax
80105953:	48                   	dec    %eax
80105954:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105957:	66 89 42 16          	mov    %ax,0x16(%edx)
  iupdate(ip);
8010595b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010595e:	89 04 24             	mov    %eax,(%esp)
80105961:	e8 25 bd ff ff       	call   8010168b <iupdate>
  iunlockput(ip);
80105966:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105969:	89 04 24             	mov    %eax,(%esp)
8010596c:	e8 55 c1 ff ff       	call   80101ac6 <iunlockput>

  commit_trans();
80105971:	e8 a3 d8 ff ff       	call   80103219 <commit_trans>

  return 0;
80105976:	b8 00 00 00 00       	mov    $0x0,%eax
8010597b:	eb 16                	jmp    80105993 <sys_unlink+0x1cb>
    goto bad;
8010597d:	90                   	nop

bad:
  iunlockput(dp);
8010597e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105981:	89 04 24             	mov    %eax,(%esp)
80105984:	e8 3d c1 ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80105989:	e8 8b d8 ff ff       	call   80103219 <commit_trans>
  return -1;
8010598e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105993:	c9                   	leave  
80105994:	c3                   	ret    

80105995 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105995:	55                   	push   %ebp
80105996:	89 e5                	mov    %esp,%ebp
80105998:	83 ec 48             	sub    $0x48,%esp
8010599b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010599e:	8b 55 10             	mov    0x10(%ebp),%edx
801059a1:	8b 45 14             	mov    0x14(%ebp),%eax
801059a4:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801059a8:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801059ac:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801059b0:	8d 45 de             	lea    -0x22(%ebp),%eax
801059b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ba:	89 04 24             	mov    %eax,(%esp)
801059bd:	e8 3f ca ff ff       	call   80102401 <nameiparent>
801059c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059c9:	75 0a                	jne    801059d5 <create+0x40>
    return 0;
801059cb:	b8 00 00 00 00       	mov    $0x0,%eax
801059d0:	e9 79 01 00 00       	jmp    80105b4e <create+0x1b9>
  ilock(dp);
801059d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d8:	89 04 24             	mov    %eax,(%esp)
801059db:	e8 65 be ff ff       	call   80101845 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801059e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
801059e3:	89 44 24 08          	mov    %eax,0x8(%esp)
801059e7:	8d 45 de             	lea    -0x22(%ebp),%eax
801059ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f1:	89 04 24             	mov    %eax,(%esp)
801059f4:	e8 6a c6 ff ff       	call   80102063 <dirlookup>
801059f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801059fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a00:	74 46                	je     80105a48 <create+0xb3>
    iunlockput(dp);
80105a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a05:	89 04 24             	mov    %eax,(%esp)
80105a08:	e8 b9 c0 ff ff       	call   80101ac6 <iunlockput>
    ilock(ip);
80105a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a10:	89 04 24             	mov    %eax,(%esp)
80105a13:	e8 2d be ff ff       	call   80101845 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105a18:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105a1d:	75 14                	jne    80105a33 <create+0x9e>
80105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a22:	8b 40 10             	mov    0x10(%eax),%eax
80105a25:	66 83 f8 02          	cmp    $0x2,%ax
80105a29:	75 08                	jne    80105a33 <create+0x9e>
      return ip;
80105a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2e:	e9 1b 01 00 00       	jmp    80105b4e <create+0x1b9>
    iunlockput(ip);
80105a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a36:	89 04 24             	mov    %eax,(%esp)
80105a39:	e8 88 c0 ff ff       	call   80101ac6 <iunlockput>
    return 0;
80105a3e:	b8 00 00 00 00       	mov    $0x0,%eax
80105a43:	e9 06 01 00 00       	jmp    80105b4e <create+0x1b9>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105a48:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a4f:	8b 00                	mov    (%eax),%eax
80105a51:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a55:	89 04 24             	mov    %eax,(%esp)
80105a58:	e8 46 bb ff ff       	call   801015a3 <ialloc>
80105a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a64:	75 0c                	jne    80105a72 <create+0xdd>
    panic("create: ialloc");
80105a66:	c7 04 24 ff 85 10 80 	movl   $0x801085ff,(%esp)
80105a6d:	e8 c4 aa ff ff       	call   80100536 <panic>

  ilock(ip);
80105a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a75:	89 04 24             	mov    %eax,(%esp)
80105a78:	e8 c8 bd ff ff       	call   80101845 <ilock>
  ip->major = major;
80105a7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a80:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105a83:	66 89 42 12          	mov    %ax,0x12(%edx)
  ip->minor = minor;
80105a87:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a8a:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105a8d:	66 89 42 14          	mov    %ax,0x14(%edx)
  ip->nlink = 1;
80105a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a94:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9d:	89 04 24             	mov    %eax,(%esp)
80105aa0:	e8 e6 bb ff ff       	call   8010168b <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105aa5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105aaa:	75 68                	jne    80105b14 <create+0x17f>
    dp->nlink++;  // for ".."
80105aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aaf:	66 8b 40 16          	mov    0x16(%eax),%ax
80105ab3:	40                   	inc    %eax
80105ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ab7:	66 89 42 16          	mov    %ax,0x16(%edx)
    iupdate(dp);
80105abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abe:	89 04 24             	mov    %eax,(%esp)
80105ac1:	e8 c5 bb ff ff       	call   8010168b <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ac9:	8b 40 04             	mov    0x4(%eax),%eax
80105acc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ad0:	c7 44 24 04 d9 85 10 	movl   $0x801085d9,0x4(%esp)
80105ad7:	80 
80105ad8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105adb:	89 04 24             	mov    %eax,(%esp)
80105ade:	e8 45 c6 ff ff       	call   80102128 <dirlink>
80105ae3:	85 c0                	test   %eax,%eax
80105ae5:	78 21                	js     80105b08 <create+0x173>
80105ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aea:	8b 40 04             	mov    0x4(%eax),%eax
80105aed:	89 44 24 08          	mov    %eax,0x8(%esp)
80105af1:	c7 44 24 04 db 85 10 	movl   $0x801085db,0x4(%esp)
80105af8:	80 
80105af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afc:	89 04 24             	mov    %eax,(%esp)
80105aff:	e8 24 c6 ff ff       	call   80102128 <dirlink>
80105b04:	85 c0                	test   %eax,%eax
80105b06:	79 0c                	jns    80105b14 <create+0x17f>
      panic("create dots");
80105b08:	c7 04 24 0e 86 10 80 	movl   $0x8010860e,(%esp)
80105b0f:	e8 22 aa ff ff       	call   80100536 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b17:	8b 40 04             	mov    0x4(%eax),%eax
80105b1a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b1e:	8d 45 de             	lea    -0x22(%ebp),%eax
80105b21:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b28:	89 04 24             	mov    %eax,(%esp)
80105b2b:	e8 f8 c5 ff ff       	call   80102128 <dirlink>
80105b30:	85 c0                	test   %eax,%eax
80105b32:	79 0c                	jns    80105b40 <create+0x1ab>
    panic("create: dirlink");
80105b34:	c7 04 24 1a 86 10 80 	movl   $0x8010861a,(%esp)
80105b3b:	e8 f6 a9 ff ff       	call   80100536 <panic>

  iunlockput(dp);
80105b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b43:	89 04 24             	mov    %eax,(%esp)
80105b46:	e8 7b bf ff ff       	call   80101ac6 <iunlockput>

  return ip;
80105b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105b4e:	c9                   	leave  
80105b4f:	c3                   	ret    

80105b50 <sys_open>:

int
sys_open(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b56:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105b59:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b64:	e8 75 f5 ff ff       	call   801050de <argstr>
80105b69:	85 c0                	test   %eax,%eax
80105b6b:	78 17                	js     80105b84 <sys_open+0x34>
80105b6d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b70:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105b7b:	e8 ce f4 ff ff       	call   8010504e <argint>
80105b80:	85 c0                	test   %eax,%eax
80105b82:	79 0a                	jns    80105b8e <sys_open+0x3e>
    return -1;
80105b84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b89:	e9 47 01 00 00       	jmp    80105cd5 <sys_open+0x185>
  if(omode & O_CREATE){
80105b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105b91:	25 00 02 00 00       	and    $0x200,%eax
80105b96:	85 c0                	test   %eax,%eax
80105b98:	74 40                	je     80105bda <sys_open+0x8a>
    begin_trans();
80105b9a:	e8 31 d6 ff ff       	call   801031d0 <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105b9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ba2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105ba9:	00 
80105baa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105bb1:	00 
80105bb2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105bb9:	00 
80105bba:	89 04 24             	mov    %eax,(%esp)
80105bbd:	e8 d3 fd ff ff       	call   80105995 <create>
80105bc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105bc5:	e8 4f d6 ff ff       	call   80103219 <commit_trans>
    if(ip == 0)
80105bca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bce:	75 5b                	jne    80105c2b <sys_open+0xdb>
      return -1;
80105bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bd5:	e9 fb 00 00 00       	jmp    80105cd5 <sys_open+0x185>
  } else {
    if((ip = namei(path)) == 0)
80105bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105bdd:	89 04 24             	mov    %eax,(%esp)
80105be0:	e8 fa c7 ff ff       	call   801023df <namei>
80105be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bec:	75 0a                	jne    80105bf8 <sys_open+0xa8>
      return -1;
80105bee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bf3:	e9 dd 00 00 00       	jmp    80105cd5 <sys_open+0x185>
    ilock(ip);
80105bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bfb:	89 04 24             	mov    %eax,(%esp)
80105bfe:	e8 42 bc ff ff       	call   80101845 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c06:	8b 40 10             	mov    0x10(%eax),%eax
80105c09:	66 83 f8 01          	cmp    $0x1,%ax
80105c0d:	75 1c                	jne    80105c2b <sys_open+0xdb>
80105c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c12:	85 c0                	test   %eax,%eax
80105c14:	74 15                	je     80105c2b <sys_open+0xdb>
      iunlockput(ip);
80105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c19:	89 04 24             	mov    %eax,(%esp)
80105c1c:	e8 a5 be ff ff       	call   80101ac6 <iunlockput>
      return -1;
80105c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c26:	e9 aa 00 00 00       	jmp    80105cd5 <sys_open+0x185>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105c2b:	e8 c3 b2 ff ff       	call   80100ef3 <filealloc>
80105c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c37:	74 14                	je     80105c4d <sys_open+0xfd>
80105c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c3c:	89 04 24             	mov    %eax,(%esp)
80105c3f:	e8 d5 f5 ff ff       	call   80105219 <fdalloc>
80105c44:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c47:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105c4b:	79 23                	jns    80105c70 <sys_open+0x120>
    if(f)
80105c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c51:	74 0b                	je     80105c5e <sys_open+0x10e>
      fileclose(f);
80105c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c56:	89 04 24             	mov    %eax,(%esp)
80105c59:	e8 3d b3 ff ff       	call   80100f9b <fileclose>
    iunlockput(ip);
80105c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c61:	89 04 24             	mov    %eax,(%esp)
80105c64:	e8 5d be ff ff       	call   80101ac6 <iunlockput>
    return -1;
80105c69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c6e:	eb 65                	jmp    80105cd5 <sys_open+0x185>
  }
  iunlock(ip);
80105c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c73:	89 04 24             	mov    %eax,(%esp)
80105c76:	e8 15 bd ff ff       	call   80101990 <iunlock>

  f->type = FD_INODE;
80105c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7e:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80105c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c8a:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80105c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c90:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80105c97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105c9a:	83 e0 01             	and    $0x1,%eax
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	0f 94 c0             	sete   %al
80105ca2:	88 c2                	mov    %al,%dl
80105ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca7:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cad:	83 e0 01             	and    $0x1,%eax
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	75 0a                	jne    80105cbe <sys_open+0x16e>
80105cb4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105cb7:	83 e0 02             	and    $0x2,%eax
80105cba:	85 c0                	test   %eax,%eax
80105cbc:	74 07                	je     80105cc5 <sys_open+0x175>
80105cbe:	b8 01 00 00 00       	mov    $0x1,%eax
80105cc3:	eb 05                	jmp    80105cca <sys_open+0x17a>
80105cc5:	b8 00 00 00 00       	mov    $0x0,%eax
80105cca:	88 c2                	mov    %al,%dl
80105ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccf:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80105cd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80105cd5:	c9                   	leave  
80105cd6:	c3                   	ret    

80105cd7 <sys_mkdir>:

int
sys_mkdir(void)
{
80105cd7:	55                   	push   %ebp
80105cd8:	89 e5                	mov    %esp,%ebp
80105cda:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80105cdd:	e8 ee d4 ff ff       	call   801031d0 <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105ce2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cf0:	e8 e9 f3 ff ff       	call   801050de <argstr>
80105cf5:	85 c0                	test   %eax,%eax
80105cf7:	78 2c                	js     80105d25 <sys_mkdir+0x4e>
80105cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105d03:	00 
80105d04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105d0b:	00 
80105d0c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105d13:	00 
80105d14:	89 04 24             	mov    %eax,(%esp)
80105d17:	e8 79 fc ff ff       	call   80105995 <create>
80105d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d23:	75 0c                	jne    80105d31 <sys_mkdir+0x5a>
    commit_trans();
80105d25:	e8 ef d4 ff ff       	call   80103219 <commit_trans>
    return -1;
80105d2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d2f:	eb 15                	jmp    80105d46 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
80105d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d34:	89 04 24             	mov    %eax,(%esp)
80105d37:	e8 8a bd ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80105d3c:	e8 d8 d4 ff ff       	call   80103219 <commit_trans>
  return 0;
80105d41:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d46:	c9                   	leave  
80105d47:	c3                   	ret    

80105d48 <sys_mknod>:

int
sys_mknod(void)
{
80105d48:	55                   	push   %ebp
80105d49:	89 e5                	mov    %esp,%ebp
80105d4b:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80105d4e:	e8 7d d4 ff ff       	call   801031d0 <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80105d53:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d56:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d61:	e8 78 f3 ff ff       	call   801050de <argstr>
80105d66:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d6d:	78 5e                	js     80105dcd <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80105d6f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105d72:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d76:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d7d:	e8 cc f2 ff ff       	call   8010504e <argint>
  if((len=argstr(0, &path)) < 0 ||
80105d82:	85 c0                	test   %eax,%eax
80105d84:	78 47                	js     80105dcd <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
80105d86:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105d89:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d8d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d94:	e8 b5 f2 ff ff       	call   8010504e <argint>
     argint(1, &major) < 0 ||
80105d99:	85 c0                	test   %eax,%eax
80105d9b:	78 30                	js     80105dcd <sys_mknod+0x85>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105da0:	0f bf c8             	movswl %ax,%ecx
80105da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105da6:	0f bf d0             	movswl %ax,%edx
80105da9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80105dac:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80105db0:	89 54 24 08          	mov    %edx,0x8(%esp)
80105db4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80105dbb:	00 
80105dbc:	89 04 24             	mov    %eax,(%esp)
80105dbf:	e8 d1 fb ff ff       	call   80105995 <create>
80105dc4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dc7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105dcb:	75 0c                	jne    80105dd9 <sys_mknod+0x91>
    commit_trans();
80105dcd:	e8 47 d4 ff ff       	call   80103219 <commit_trans>
    return -1;
80105dd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd7:	eb 15                	jmp    80105dee <sys_mknod+0xa6>
  }
  iunlockput(ip);
80105dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddc:	89 04 24             	mov    %eax,(%esp)
80105ddf:	e8 e2 bc ff ff       	call   80101ac6 <iunlockput>
  commit_trans();
80105de4:	e8 30 d4 ff ff       	call   80103219 <commit_trans>
  return 0;
80105de9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105dee:	c9                   	leave  
80105def:	c3                   	ret    

80105df0 <sys_chdir>:

int
sys_chdir(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80105df6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dfd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e04:	e8 d5 f2 ff ff       	call   801050de <argstr>
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	78 14                	js     80105e21 <sys_chdir+0x31>
80105e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e10:	89 04 24             	mov    %eax,(%esp)
80105e13:	e8 c7 c5 ff ff       	call   801023df <namei>
80105e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e1f:	75 07                	jne    80105e28 <sys_chdir+0x38>
    return -1;
80105e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e26:	eb 56                	jmp    80105e7e <sys_chdir+0x8e>
  ilock(ip);
80105e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e2b:	89 04 24             	mov    %eax,(%esp)
80105e2e:	e8 12 ba ff ff       	call   80101845 <ilock>
  if(ip->type != T_DIR){
80105e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e36:	8b 40 10             	mov    0x10(%eax),%eax
80105e39:	66 83 f8 01          	cmp    $0x1,%ax
80105e3d:	74 12                	je     80105e51 <sys_chdir+0x61>
    iunlockput(ip);
80105e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e42:	89 04 24             	mov    %eax,(%esp)
80105e45:	e8 7c bc ff ff       	call   80101ac6 <iunlockput>
    return -1;
80105e4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e4f:	eb 2d                	jmp    80105e7e <sys_chdir+0x8e>
  }
  iunlock(ip);
80105e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e54:	89 04 24             	mov    %eax,(%esp)
80105e57:	e8 34 bb ff ff       	call   80101990 <iunlock>
  iput(proc->cwd);
80105e5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e62:	8b 40 68             	mov    0x68(%eax),%eax
80105e65:	89 04 24             	mov    %eax,(%esp)
80105e68:	e8 88 bb ff ff       	call   801019f5 <iput>
  proc->cwd = ip;
80105e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e76:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80105e79:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e7e:	c9                   	leave  
80105e7f:	c3                   	ret    

80105e80 <sys_exec>:

int
sys_exec(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e89:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e97:	e8 42 f2 ff ff       	call   801050de <argstr>
80105e9c:	85 c0                	test   %eax,%eax
80105e9e:	78 1a                	js     80105eba <sys_exec+0x3a>
80105ea0:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80105ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105eb1:	e8 98 f1 ff ff       	call   8010504e <argint>
80105eb6:	85 c0                	test   %eax,%eax
80105eb8:	79 0a                	jns    80105ec4 <sys_exec+0x44>
    return -1;
80105eba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebf:	e9 c7 00 00 00       	jmp    80105f8b <sys_exec+0x10b>
  }
  memset(argv, 0, sizeof(argv));
80105ec4:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105ecb:	00 
80105ecc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105ed3:	00 
80105ed4:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105eda:	89 04 24             	mov    %eax,(%esp)
80105edd:	e8 3b ee ff ff       	call   80104d1d <memset>
  for(i=0;; i++){
80105ee2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80105ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105eec:	83 f8 1f             	cmp    $0x1f,%eax
80105eef:	76 0a                	jbe    80105efb <sys_exec+0x7b>
      return -1;
80105ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ef6:	e9 90 00 00 00       	jmp    80105f8b <sys_exec+0x10b>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105efe:	c1 e0 02             	shl    $0x2,%eax
80105f01:	89 c2                	mov    %eax,%edx
80105f03:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80105f09:	01 c2                	add    %eax,%edx
80105f0b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105f11:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f15:	89 14 24             	mov    %edx,(%esp)
80105f18:	e8 95 f0 ff ff       	call   80104fb2 <fetchint>
80105f1d:	85 c0                	test   %eax,%eax
80105f1f:	79 07                	jns    80105f28 <sys_exec+0xa8>
      return -1;
80105f21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f26:	eb 63                	jmp    80105f8b <sys_exec+0x10b>
    if(uarg == 0){
80105f28:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105f2e:	85 c0                	test   %eax,%eax
80105f30:	75 26                	jne    80105f58 <sys_exec+0xd8>
      argv[i] = 0;
80105f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f35:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80105f3c:	00 00 00 00 
      break;
80105f40:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f44:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80105f4a:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f4e:	89 04 24             	mov    %eax,(%esp)
80105f51:	e8 75 ab ff ff       	call   80100acb <exec>
80105f56:	eb 33                	jmp    80105f8b <sys_exec+0x10b>
    if(fetchstr(uarg, &argv[i]) < 0)
80105f58:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80105f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f61:	c1 e2 02             	shl    $0x2,%edx
80105f64:	01 c2                	add    %eax,%edx
80105f66:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80105f6c:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f70:	89 04 24             	mov    %eax,(%esp)
80105f73:	e8 74 f0 ff ff       	call   80104fec <fetchstr>
80105f78:	85 c0                	test   %eax,%eax
80105f7a:	79 07                	jns    80105f83 <sys_exec+0x103>
      return -1;
80105f7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f81:	eb 08                	jmp    80105f8b <sys_exec+0x10b>
  for(i=0;; i++){
80105f83:	ff 45 f4             	incl   -0xc(%ebp)
  }
80105f86:	e9 5e ff ff ff       	jmp    80105ee9 <sys_exec+0x69>
}
80105f8b:	c9                   	leave  
80105f8c:	c3                   	ret    

80105f8d <sys_pipe>:

int
sys_pipe(void)
{
80105f8d:	55                   	push   %ebp
80105f8e:	89 e5                	mov    %esp,%ebp
80105f90:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f93:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105f9a:	00 
80105f9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fa9:	e8 ce f0 ff ff       	call   8010507c <argptr>
80105fae:	85 c0                	test   %eax,%eax
80105fb0:	79 0a                	jns    80105fbc <sys_pipe+0x2f>
    return -1;
80105fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fb7:	e9 9b 00 00 00       	jmp    80106057 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
80105fbc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fc3:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fc6:	89 04 24             	mov    %eax,(%esp)
80105fc9:	e8 44 dc ff ff       	call   80103c12 <pipealloc>
80105fce:	85 c0                	test   %eax,%eax
80105fd0:	79 07                	jns    80105fd9 <sys_pipe+0x4c>
    return -1;
80105fd2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd7:	eb 7e                	jmp    80106057 <sys_pipe+0xca>
  fd0 = -1;
80105fd9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105fe3:	89 04 24             	mov    %eax,(%esp)
80105fe6:	e8 2e f2 ff ff       	call   80105219 <fdalloc>
80105feb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ff2:	78 14                	js     80106008 <sys_pipe+0x7b>
80105ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105ff7:	89 04 24             	mov    %eax,(%esp)
80105ffa:	e8 1a f2 ff ff       	call   80105219 <fdalloc>
80105fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106002:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106006:	79 37                	jns    8010603f <sys_pipe+0xb2>
    if(fd0 >= 0)
80106008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010600c:	78 14                	js     80106022 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
8010600e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106014:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106017:	83 c2 08             	add    $0x8,%edx
8010601a:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106021:	00 
    fileclose(rf);
80106022:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106025:	89 04 24             	mov    %eax,(%esp)
80106028:	e8 6e af ff ff       	call   80100f9b <fileclose>
    fileclose(wf);
8010602d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106030:	89 04 24             	mov    %eax,(%esp)
80106033:	e8 63 af ff ff       	call   80100f9b <fileclose>
    return -1;
80106038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010603d:	eb 18                	jmp    80106057 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010603f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106042:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106045:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106047:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010604a:	8d 50 04             	lea    0x4(%eax),%edx
8010604d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106050:	89 02                	mov    %eax,(%edx)
  return 0;
80106052:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106057:	c9                   	leave  
80106058:	c3                   	ret    

80106059 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106059:	55                   	push   %ebp
8010605a:	89 e5                	mov    %esp,%ebp
8010605c:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010605f:	e8 5b e2 ff ff       	call   801042bf <fork>
}
80106064:	c9                   	leave  
80106065:	c3                   	ret    

80106066 <sys_exit>:

int
sys_exit(void)
{
80106066:	55                   	push   %ebp
80106067:	89 e5                	mov    %esp,%ebp
80106069:	83 ec 08             	sub    $0x8,%esp
  exit();
8010606c:	e8 a6 e3 ff ff       	call   80104417 <exit>
  return 0;  // not reached
80106071:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106076:	c9                   	leave  
80106077:	c3                   	ret    

80106078 <sys_wait>:

int
sys_wait(void)
{
80106078:	55                   	push   %ebp
80106079:	89 e5                	mov    %esp,%ebp
8010607b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010607e:	e8 ab e4 ff ff       	call   8010452e <wait>
}
80106083:	c9                   	leave  
80106084:	c3                   	ret    

80106085 <sys_kill>:

int
sys_kill(void)
{
80106085:	55                   	push   %ebp
80106086:	89 e5                	mov    %esp,%ebp
80106088:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010608b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010608e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106092:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106099:	e8 b0 ef ff ff       	call   8010504e <argint>
8010609e:	85 c0                	test   %eax,%eax
801060a0:	79 07                	jns    801060a9 <sys_kill+0x24>
    return -1;
801060a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060a7:	eb 0b                	jmp    801060b4 <sys_kill+0x2f>
  return kill(pid);
801060a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060ac:	89 04 24             	mov    %eax,(%esp)
801060af:	e8 40 e8 ff ff       	call   801048f4 <kill>
}
801060b4:	c9                   	leave  
801060b5:	c3                   	ret    

801060b6 <sys_getpid>:

int
sys_getpid(void)
{
801060b6:	55                   	push   %ebp
801060b7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801060b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060bf:	8b 40 10             	mov    0x10(%eax),%eax
}
801060c2:	5d                   	pop    %ebp
801060c3:	c3                   	ret    

801060c4 <sys_sbrk>:

int
sys_sbrk(void)
{
801060c4:	55                   	push   %ebp
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801060ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801060d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060d8:	e8 71 ef ff ff       	call   8010504e <argint>
801060dd:	85 c0                	test   %eax,%eax
801060df:	79 07                	jns    801060e8 <sys_sbrk+0x24>
    return -1;
801060e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e6:	eb 24                	jmp    8010610c <sys_sbrk+0x48>
  addr = proc->sz;
801060e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801060ee:	8b 00                	mov    (%eax),%eax
801060f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801060f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f6:	89 04 24             	mov    %eax,(%esp)
801060f9:	e8 1c e1 ff ff       	call   8010421a <growproc>
801060fe:	85 c0                	test   %eax,%eax
80106100:	79 07                	jns    80106109 <sys_sbrk+0x45>
    return -1;
80106102:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106107:	eb 03                	jmp    8010610c <sys_sbrk+0x48>
  return addr;
80106109:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010610c:	c9                   	leave  
8010610d:	c3                   	ret    

8010610e <sys_sleep>:

int
sys_sleep(void)
{
8010610e:	55                   	push   %ebp
8010610f:	89 e5                	mov    %esp,%ebp
80106111:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106114:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106117:	89 44 24 04          	mov    %eax,0x4(%esp)
8010611b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106122:	e8 27 ef ff ff       	call   8010504e <argint>
80106127:	85 c0                	test   %eax,%eax
80106129:	79 07                	jns    80106132 <sys_sleep+0x24>
    return -1;
8010612b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106130:	eb 6c                	jmp    8010619e <sys_sleep+0x90>
  acquire(&tickslock);
80106132:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80106139:	e8 8d e9 ff ff       	call   80104acb <acquire>
  ticks0 = ticks;
8010613e:	a1 a0 27 11 80       	mov    0x801127a0,%eax
80106143:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106146:	eb 34                	jmp    8010617c <sys_sleep+0x6e>
    if(proc->killed){
80106148:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010614e:	8b 40 24             	mov    0x24(%eax),%eax
80106151:	85 c0                	test   %eax,%eax
80106153:	74 13                	je     80106168 <sys_sleep+0x5a>
      release(&tickslock);
80106155:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
8010615c:	e8 cc e9 ff ff       	call   80104b2d <release>
      return -1;
80106161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106166:	eb 36                	jmp    8010619e <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106168:	c7 44 24 04 60 1f 11 	movl   $0x80111f60,0x4(%esp)
8010616f:	80 
80106170:	c7 04 24 a0 27 11 80 	movl   $0x801127a0,(%esp)
80106177:	e8 74 e6 ff ff       	call   801047f0 <sleep>
  while(ticks - ticks0 < n){
8010617c:	a1 a0 27 11 80       	mov    0x801127a0,%eax
80106181:	89 c2                	mov    %eax,%edx
80106183:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106189:	39 c2                	cmp    %eax,%edx
8010618b:	72 bb                	jb     80106148 <sys_sleep+0x3a>
  }
  release(&tickslock);
8010618d:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80106194:	e8 94 e9 ff ff       	call   80104b2d <release>
  return 0;
80106199:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010619e:	c9                   	leave  
8010619f:	c3                   	ret    

801061a0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
801061a6:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801061ad:	e8 19 e9 ff ff       	call   80104acb <acquire>
  xticks = ticks;
801061b2:	a1 a0 27 11 80       	mov    0x801127a0,%eax
801061b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
801061ba:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801061c1:	e8 67 e9 ff ff       	call   80104b2d <release>
  return xticks;
801061c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061c9:	c9                   	leave  
801061ca:	c3                   	ret    

801061cb <outb>:
{
801061cb:	55                   	push   %ebp
801061cc:	89 e5                	mov    %esp,%ebp
801061ce:	83 ec 08             	sub    $0x8,%esp
801061d1:	8b 45 08             	mov    0x8(%ebp),%eax
801061d4:	8b 55 0c             	mov    0xc(%ebp),%edx
801061d7:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801061db:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801061de:	8a 45 f8             	mov    -0x8(%ebp),%al
801061e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801061e4:	ee                   	out    %al,(%dx)
}
801061e5:	c9                   	leave  
801061e6:	c3                   	ret    

801061e7 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801061e7:	55                   	push   %ebp
801061e8:	89 e5                	mov    %esp,%ebp
801061ea:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801061ed:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801061f4:	00 
801061f5:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801061fc:	e8 ca ff ff ff       	call   801061cb <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106201:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106208:	00 
80106209:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106210:	e8 b6 ff ff ff       	call   801061cb <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106215:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
8010621c:	00 
8010621d:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106224:	e8 a2 ff ff ff       	call   801061cb <outb>
  picenable(IRQ_TIMER);
80106229:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106230:	e8 6c d8 ff ff       	call   80103aa1 <picenable>
}
80106235:	c9                   	leave  
80106236:	c3                   	ret    

80106237 <alltraps>:
80106237:	1e                   	push   %ds
80106238:	06                   	push   %es
80106239:	0f a0                	push   %fs
8010623b:	0f a8                	push   %gs
8010623d:	60                   	pusha  
8010623e:	66 b8 10 00          	mov    $0x10,%ax
80106242:	8e d8                	mov    %eax,%ds
80106244:	8e c0                	mov    %eax,%es
80106246:	66 b8 18 00          	mov    $0x18,%ax
8010624a:	8e e0                	mov    %eax,%fs
8010624c:	8e e8                	mov    %eax,%gs
8010624e:	54                   	push   %esp
8010624f:	e8 c4 01 00 00       	call   80106418 <trap>
80106254:	83 c4 04             	add    $0x4,%esp

80106257 <trapret>:
80106257:	61                   	popa   
80106258:	0f a9                	pop    %gs
8010625a:	0f a1                	pop    %fs
8010625c:	07                   	pop    %es
8010625d:	1f                   	pop    %ds
8010625e:	83 c4 08             	add    $0x8,%esp
80106261:	cf                   	iret   

80106262 <lidt>:
{
80106262:	55                   	push   %ebp
80106263:	89 e5                	mov    %esp,%ebp
80106265:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106268:	8b 45 0c             	mov    0xc(%ebp),%eax
8010626b:	48                   	dec    %eax
8010626c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106270:	8b 45 08             	mov    0x8(%ebp),%eax
80106273:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106277:	8b 45 08             	mov    0x8(%ebp),%eax
8010627a:	c1 e8 10             	shr    $0x10,%eax
8010627d:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106281:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106284:	0f 01 18             	lidtl  (%eax)
}
80106287:	c9                   	leave  
80106288:	c3                   	ret    

80106289 <rcr2>:

static inline uint
rcr2(void)
{
80106289:	55                   	push   %ebp
8010628a:	89 e5                	mov    %esp,%ebp
8010628c:	53                   	push   %ebx
8010628d:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106290:	0f 20 d3             	mov    %cr2,%ebx
80106293:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106296:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106299:	83 c4 10             	add    $0x10,%esp
8010629c:	5b                   	pop    %ebx
8010629d:	5d                   	pop    %ebp
8010629e:	c3                   	ret    

8010629f <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010629f:	55                   	push   %ebp
801062a0:	89 e5                	mov    %esp,%ebp
801062a2:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
801062a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801062ac:	e9 b8 00 00 00       	jmp    80106369 <tvinit+0xca>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801062b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b4:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
801062bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801062be:	66 89 04 d5 a0 1f 11 	mov    %ax,-0x7feee060(,%edx,8)
801062c5:	80 
801062c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c9:	66 c7 04 c5 a2 1f 11 	movw   $0x8,-0x7feee05e(,%eax,8)
801062d0:	80 08 00 
801062d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d6:	8a 14 c5 a4 1f 11 80 	mov    -0x7feee05c(,%eax,8),%dl
801062dd:	83 e2 e0             	and    $0xffffffe0,%edx
801062e0:	88 14 c5 a4 1f 11 80 	mov    %dl,-0x7feee05c(,%eax,8)
801062e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ea:	8a 14 c5 a4 1f 11 80 	mov    -0x7feee05c(,%eax,8),%dl
801062f1:	83 e2 1f             	and    $0x1f,%edx
801062f4:	88 14 c5 a4 1f 11 80 	mov    %dl,-0x7feee05c(,%eax,8)
801062fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062fe:	8a 14 c5 a5 1f 11 80 	mov    -0x7feee05b(,%eax,8),%dl
80106305:	83 e2 f0             	and    $0xfffffff0,%edx
80106308:	83 ca 0e             	or     $0xe,%edx
8010630b:	88 14 c5 a5 1f 11 80 	mov    %dl,-0x7feee05b(,%eax,8)
80106312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106315:	8a 14 c5 a5 1f 11 80 	mov    -0x7feee05b(,%eax,8),%dl
8010631c:	83 e2 ef             	and    $0xffffffef,%edx
8010631f:	88 14 c5 a5 1f 11 80 	mov    %dl,-0x7feee05b(,%eax,8)
80106326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106329:	8a 14 c5 a5 1f 11 80 	mov    -0x7feee05b(,%eax,8),%dl
80106330:	83 e2 9f             	and    $0xffffff9f,%edx
80106333:	88 14 c5 a5 1f 11 80 	mov    %dl,-0x7feee05b(,%eax,8)
8010633a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010633d:	8a 14 c5 a5 1f 11 80 	mov    -0x7feee05b(,%eax,8),%dl
80106344:	83 ca 80             	or     $0xffffff80,%edx
80106347:	88 14 c5 a5 1f 11 80 	mov    %dl,-0x7feee05b(,%eax,8)
8010634e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106351:	8b 04 85 a0 b0 10 80 	mov    -0x7fef4f60(,%eax,4),%eax
80106358:	c1 e8 10             	shr    $0x10,%eax
8010635b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010635e:	66 89 04 d5 a6 1f 11 	mov    %ax,-0x7feee05a(,%edx,8)
80106365:	80 
  for(i = 0; i < 256; i++)
80106366:	ff 45 f4             	incl   -0xc(%ebp)
80106369:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106370:	0f 8e 3b ff ff ff    	jle    801062b1 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106376:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
8010637b:	66 a3 a0 21 11 80    	mov    %ax,0x801121a0
80106381:	66 c7 05 a2 21 11 80 	movw   $0x8,0x801121a2
80106388:	08 00 
8010638a:	a0 a4 21 11 80       	mov    0x801121a4,%al
8010638f:	83 e0 e0             	and    $0xffffffe0,%eax
80106392:	a2 a4 21 11 80       	mov    %al,0x801121a4
80106397:	a0 a4 21 11 80       	mov    0x801121a4,%al
8010639c:	83 e0 1f             	and    $0x1f,%eax
8010639f:	a2 a4 21 11 80       	mov    %al,0x801121a4
801063a4:	a0 a5 21 11 80       	mov    0x801121a5,%al
801063a9:	83 c8 0f             	or     $0xf,%eax
801063ac:	a2 a5 21 11 80       	mov    %al,0x801121a5
801063b1:	a0 a5 21 11 80       	mov    0x801121a5,%al
801063b6:	83 e0 ef             	and    $0xffffffef,%eax
801063b9:	a2 a5 21 11 80       	mov    %al,0x801121a5
801063be:	a0 a5 21 11 80       	mov    0x801121a5,%al
801063c3:	83 c8 60             	or     $0x60,%eax
801063c6:	a2 a5 21 11 80       	mov    %al,0x801121a5
801063cb:	a0 a5 21 11 80       	mov    0x801121a5,%al
801063d0:	83 c8 80             	or     $0xffffff80,%eax
801063d3:	a2 a5 21 11 80       	mov    %al,0x801121a5
801063d8:	a1 a0 b1 10 80       	mov    0x8010b1a0,%eax
801063dd:	c1 e8 10             	shr    $0x10,%eax
801063e0:	66 a3 a6 21 11 80    	mov    %ax,0x801121a6
  
  initlock(&tickslock, "time");
801063e6:	c7 44 24 04 2c 86 10 	movl   $0x8010862c,0x4(%esp)
801063ed:	80 
801063ee:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801063f5:	e8 b0 e6 ff ff       	call   80104aaa <initlock>
}
801063fa:	c9                   	leave  
801063fb:	c3                   	ret    

801063fc <idtinit>:

void
idtinit(void)
{
801063fc:	55                   	push   %ebp
801063fd:	89 e5                	mov    %esp,%ebp
801063ff:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106402:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106409:	00 
8010640a:	c7 04 24 a0 1f 11 80 	movl   $0x80111fa0,(%esp)
80106411:	e8 4c fe ff ff       	call   80106262 <lidt>
}
80106416:	c9                   	leave  
80106417:	c3                   	ret    

80106418 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106418:	55                   	push   %ebp
80106419:	89 e5                	mov    %esp,%ebp
8010641b:	57                   	push   %edi
8010641c:	56                   	push   %esi
8010641d:	53                   	push   %ebx
8010641e:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106421:	8b 45 08             	mov    0x8(%ebp),%eax
80106424:	8b 40 30             	mov    0x30(%eax),%eax
80106427:	83 f8 40             	cmp    $0x40,%eax
8010642a:	75 3e                	jne    8010646a <trap+0x52>
    if(proc->killed)
8010642c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106432:	8b 40 24             	mov    0x24(%eax),%eax
80106435:	85 c0                	test   %eax,%eax
80106437:	74 05                	je     8010643e <trap+0x26>
      exit();
80106439:	e8 d9 df ff ff       	call   80104417 <exit>
    proc->tf = tf;
8010643e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106444:	8b 55 08             	mov    0x8(%ebp),%edx
80106447:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010644a:	e8 c6 ec ff ff       	call   80105115 <syscall>
    if(proc->killed)
8010644f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106455:	8b 40 24             	mov    0x24(%eax),%eax
80106458:	85 c0                	test   %eax,%eax
8010645a:	0f 84 9b 02 00 00    	je     801066fb <trap+0x2e3>
      exit();
80106460:	e8 b2 df ff ff       	call   80104417 <exit>
    return;
80106465:	e9 91 02 00 00       	jmp    801066fb <trap+0x2e3>
  }

  switch(tf->trapno){
8010646a:	8b 45 08             	mov    0x8(%ebp),%eax
8010646d:	8b 40 30             	mov    0x30(%eax),%eax
80106470:	83 e8 20             	sub    $0x20,%eax
80106473:	83 f8 1f             	cmp    $0x1f,%eax
80106476:	0f 87 b7 00 00 00    	ja     80106533 <trap+0x11b>
8010647c:	8b 04 85 38 87 10 80 	mov    -0x7fef78c8(,%eax,4),%eax
80106483:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106485:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010648b:	8a 00                	mov    (%eax),%al
8010648d:	84 c0                	test   %al,%al
8010648f:	75 2f                	jne    801064c0 <trap+0xa8>
      acquire(&tickslock);
80106491:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
80106498:	e8 2e e6 ff ff       	call   80104acb <acquire>
      ticks++;
8010649d:	a1 a0 27 11 80       	mov    0x801127a0,%eax
801064a2:	40                   	inc    %eax
801064a3:	a3 a0 27 11 80       	mov    %eax,0x801127a0
      wakeup(&ticks);
801064a8:	c7 04 24 a0 27 11 80 	movl   $0x801127a0,(%esp)
801064af:	e8 15 e4 ff ff       	call   801048c9 <wakeup>
      release(&tickslock);
801064b4:	c7 04 24 60 1f 11 80 	movl   $0x80111f60,(%esp)
801064bb:	e8 6d e6 ff ff       	call   80104b2d <release>
    }
    lapiceoi();
801064c0:	e8 da c9 ff ff       	call   80102e9f <lapiceoi>
    break;
801064c5:	e9 3c 01 00 00       	jmp    80106606 <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801064ca:	e8 ee c1 ff ff       	call   801026bd <ideintr>
    lapiceoi();
801064cf:	e8 cb c9 ff ff       	call   80102e9f <lapiceoi>
    break;
801064d4:	e9 2d 01 00 00       	jmp    80106606 <trap+0x1ee>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801064d9:	e8 a4 c7 ff ff       	call   80102c82 <kbdintr>
    lapiceoi();
801064de:	e8 bc c9 ff ff       	call   80102e9f <lapiceoi>
    break;
801064e3:	e9 1e 01 00 00       	jmp    80106606 <trap+0x1ee>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801064e8:	e8 0b 04 00 00       	call   801068f8 <uartintr>
    lapiceoi();
801064ed:	e8 ad c9 ff ff       	call   80102e9f <lapiceoi>
    break;
801064f2:	e9 0f 01 00 00       	jmp    80106606 <trap+0x1ee>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801064f7:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064fa:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801064fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106500:	8b 40 3c             	mov    0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106503:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80106506:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010650c:	8a 00                	mov    (%eax),%al
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010650e:	0f b6 c0             	movzbl %al,%eax
80106511:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106515:	89 54 24 08          	mov    %edx,0x8(%esp)
80106519:	89 44 24 04          	mov    %eax,0x4(%esp)
8010651d:	c7 04 24 34 86 10 80 	movl   $0x80108634,(%esp)
80106524:	e8 78 9e ff ff       	call   801003a1 <cprintf>
    lapiceoi();
80106529:	e8 71 c9 ff ff       	call   80102e9f <lapiceoi>
    break;
8010652e:	e9 d3 00 00 00       	jmp    80106606 <trap+0x1ee>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80106533:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106539:	85 c0                	test   %eax,%eax
8010653b:	74 10                	je     8010654d <trap+0x135>
8010653d:	8b 45 08             	mov    0x8(%ebp),%eax
80106540:	8b 40 3c             	mov    0x3c(%eax),%eax
80106543:	0f b7 c0             	movzwl %ax,%eax
80106546:	83 e0 03             	and    $0x3,%eax
80106549:	85 c0                	test   %eax,%eax
8010654b:	75 45                	jne    80106592 <trap+0x17a>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010654d:	e8 37 fd ff ff       	call   80106289 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
80106552:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106555:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106558:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010655f:	8a 12                	mov    (%edx),%dl
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106561:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106564:	8b 55 08             	mov    0x8(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106567:	8b 52 30             	mov    0x30(%edx),%edx
8010656a:	89 44 24 10          	mov    %eax,0x10(%esp)
8010656e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106572:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106576:	89 54 24 04          	mov    %edx,0x4(%esp)
8010657a:	c7 04 24 58 86 10 80 	movl   $0x80108658,(%esp)
80106581:	e8 1b 9e ff ff       	call   801003a1 <cprintf>
      panic("trap");
80106586:	c7 04 24 8a 86 10 80 	movl   $0x8010868a,(%esp)
8010658d:	e8 a4 9f ff ff       	call   80100536 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106592:	e8 f2 fc ff ff       	call   80106289 <rcr2>
80106597:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106599:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010659c:	8b 78 38             	mov    0x38(%eax),%edi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010659f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801065a5:	8a 00                	mov    (%eax),%al
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065a7:	0f b6 f0             	movzbl %al,%esi
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801065aa:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065ad:	8b 58 34             	mov    0x34(%eax),%ebx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801065b0:	8b 45 08             	mov    0x8(%ebp),%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065b3:	8b 48 30             	mov    0x30(%eax),%ecx
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801065b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065bc:	83 c0 6c             	add    $0x6c,%eax
801065bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801065c8:	8b 40 10             	mov    0x10(%eax),%eax
801065cb:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801065cf:	89 7c 24 18          	mov    %edi,0x18(%esp)
801065d3:	89 74 24 14          	mov    %esi,0x14(%esp)
801065d7:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801065db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801065df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801065e2:	89 54 24 08          	mov    %edx,0x8(%esp)
801065e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801065ea:	c7 04 24 90 86 10 80 	movl   $0x80108690,(%esp)
801065f1:	e8 ab 9d ff ff       	call   801003a1 <cprintf>
            rcr2());
    proc->killed = 1;
801065f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801065fc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106603:	eb 01                	jmp    80106606 <trap+0x1ee>
    break;
80106605:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106606:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010660c:	85 c0                	test   %eax,%eax
8010660e:	74 23                	je     80106633 <trap+0x21b>
80106610:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106616:	8b 40 24             	mov    0x24(%eax),%eax
80106619:	85 c0                	test   %eax,%eax
8010661b:	74 16                	je     80106633 <trap+0x21b>
8010661d:	8b 45 08             	mov    0x8(%ebp),%eax
80106620:	8b 40 3c             	mov    0x3c(%eax),%eax
80106623:	0f b7 c0             	movzwl %ax,%eax
80106626:	83 e0 03             	and    $0x3,%eax
80106629:	83 f8 03             	cmp    $0x3,%eax
8010662c:	75 05                	jne    80106633 <trap+0x21b>
    exit();
8010662e:	e8 e4 dd ff ff       	call   80104417 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER){
80106633:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106639:	85 c0                	test   %eax,%eax
8010663b:	0f 84 8b 00 00 00    	je     801066cc <trap+0x2b4>
80106641:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106647:	8b 40 0c             	mov    0xc(%eax),%eax
8010664a:	83 f8 04             	cmp    $0x4,%eax
8010664d:	75 7d                	jne    801066cc <trap+0x2b4>
8010664f:	8b 45 08             	mov    0x8(%ebp),%eax
80106652:	8b 40 30             	mov    0x30(%eax),%eax
80106655:	83 f8 20             	cmp    $0x20,%eax
80106658:	75 72                	jne    801066cc <trap+0x2b4>
    proc->ticksProc++;
8010665a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106660:	8b 50 7c             	mov    0x7c(%eax),%edx
80106663:	42                   	inc    %edx
80106664:	89 50 7c             	mov    %edx,0x7c(%eax)
    if(proc->ticksProc == QUANTUM) {
80106667:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010666d:	8b 40 7c             	mov    0x7c(%eax),%eax
80106670:	83 f8 06             	cmp    $0x6,%eax
80106673:	75 57                	jne    801066cc <trap+0x2b4>
      cprintf("tamaño del quantum: %d\n", QUANTUM);
80106675:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
8010667c:	00 
8010667d:	c7 04 24 d3 86 10 80 	movl   $0x801086d3,(%esp)
80106684:	e8 18 9d ff ff       	call   801003a1 <cprintf>
      cprintf("cantidad de ticks del proceso: %d\n", proc->ticksProc);
80106689:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010668f:	8b 40 7c             	mov    0x7c(%eax),%eax
80106692:	89 44 24 04          	mov    %eax,0x4(%esp)
80106696:	c7 04 24 ec 86 10 80 	movl   $0x801086ec,(%esp)
8010669d:	e8 ff 9c ff ff       	call   801003a1 <cprintf>
      cprintf("nombre del proceso: %s\n", proc->name);
801066a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066a8:	83 c0 6c             	add    $0x6c,%eax
801066ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801066af:	c7 04 24 0f 87 10 80 	movl   $0x8010870f,(%esp)
801066b6:	e8 e6 9c ff ff       	call   801003a1 <cprintf>
      cprintf("abandone cpu\n");
801066bb:	c7 04 24 27 87 10 80 	movl   $0x80108727,(%esp)
801066c2:	e8 da 9c ff ff       	call   801003a1 <cprintf>
      yield();
801066c7:	e8 c6 e0 ff ff       	call   80104792 <yield>
    }
  }

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801066cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066d2:	85 c0                	test   %eax,%eax
801066d4:	74 26                	je     801066fc <trap+0x2e4>
801066d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066dc:	8b 40 24             	mov    0x24(%eax),%eax
801066df:	85 c0                	test   %eax,%eax
801066e1:	74 19                	je     801066fc <trap+0x2e4>
801066e3:	8b 45 08             	mov    0x8(%ebp),%eax
801066e6:	8b 40 3c             	mov    0x3c(%eax),%eax
801066e9:	0f b7 c0             	movzwl %ax,%eax
801066ec:	83 e0 03             	and    $0x3,%eax
801066ef:	83 f8 03             	cmp    $0x3,%eax
801066f2:	75 08                	jne    801066fc <trap+0x2e4>
    exit();
801066f4:	e8 1e dd ff ff       	call   80104417 <exit>
801066f9:	eb 01                	jmp    801066fc <trap+0x2e4>
    return;
801066fb:	90                   	nop
}
801066fc:	83 c4 3c             	add    $0x3c,%esp
801066ff:	5b                   	pop    %ebx
80106700:	5e                   	pop    %esi
80106701:	5f                   	pop    %edi
80106702:	5d                   	pop    %ebp
80106703:	c3                   	ret    

80106704 <inb>:
{
80106704:	55                   	push   %ebp
80106705:	89 e5                	mov    %esp,%ebp
80106707:	53                   	push   %ebx
80106708:	83 ec 14             	sub    $0x14,%esp
8010670b:	8b 45 08             	mov    0x8(%ebp),%eax
8010670e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106712:	8b 55 e8             	mov    -0x18(%ebp),%edx
80106715:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106719:	66 8b 55 ea          	mov    -0x16(%ebp),%dx
8010671d:	ec                   	in     (%dx),%al
8010671e:	88 c3                	mov    %al,%bl
80106720:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106723:	8a 45 fb             	mov    -0x5(%ebp),%al
}
80106726:	83 c4 14             	add    $0x14,%esp
80106729:	5b                   	pop    %ebx
8010672a:	5d                   	pop    %ebp
8010672b:	c3                   	ret    

8010672c <outb>:
{
8010672c:	55                   	push   %ebp
8010672d:	89 e5                	mov    %esp,%ebp
8010672f:	83 ec 08             	sub    $0x8,%esp
80106732:	8b 45 08             	mov    0x8(%ebp),%eax
80106735:	8b 55 0c             	mov    0xc(%ebp),%edx
80106738:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
8010673c:	88 55 f8             	mov    %dl,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010673f:	8a 45 f8             	mov    -0x8(%ebp),%al
80106742:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106745:	ee                   	out    %al,(%dx)
}
80106746:	c9                   	leave  
80106747:	c3                   	ret    

80106748 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106748:	55                   	push   %ebp
80106749:	89 e5                	mov    %esp,%ebp
8010674b:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
8010674e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106755:	00 
80106756:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
8010675d:	e8 ca ff ff ff       	call   8010672c <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106762:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106769:	00 
8010676a:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106771:	e8 b6 ff ff ff       	call   8010672c <outb>
  outb(COM1+0, 115200/9600);
80106776:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
8010677d:	00 
8010677e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106785:	e8 a2 ff ff ff       	call   8010672c <outb>
  outb(COM1+1, 0);
8010678a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106791:	00 
80106792:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106799:	e8 8e ff ff ff       	call   8010672c <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010679e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801067a5:	00 
801067a6:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801067ad:	e8 7a ff ff ff       	call   8010672c <outb>
  outb(COM1+4, 0);
801067b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067b9:	00 
801067ba:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
801067c1:	e8 66 ff ff ff       	call   8010672c <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801067c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801067cd:	00 
801067ce:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801067d5:	e8 52 ff ff ff       	call   8010672c <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801067da:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801067e1:	e8 1e ff ff ff       	call   80106704 <inb>
801067e6:	3c ff                	cmp    $0xff,%al
801067e8:	74 69                	je     80106853 <uartinit+0x10b>
    return;
  uart = 1;
801067ea:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
801067f1:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801067f4:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801067fb:	e8 04 ff ff ff       	call   80106704 <inb>
  inb(COM1+0);
80106800:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106807:	e8 f8 fe ff ff       	call   80106704 <inb>
  picenable(IRQ_COM1);
8010680c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106813:	e8 89 d2 ff ff       	call   80103aa1 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106818:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010681f:	00 
80106820:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106827:	e8 0e c1 ff ff       	call   8010293a <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010682c:	c7 45 f4 b8 87 10 80 	movl   $0x801087b8,-0xc(%ebp)
80106833:	eb 13                	jmp    80106848 <uartinit+0x100>
    uartputc(*p);
80106835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106838:	8a 00                	mov    (%eax),%al
8010683a:	0f be c0             	movsbl %al,%eax
8010683d:	89 04 24             	mov    %eax,(%esp)
80106840:	e8 11 00 00 00       	call   80106856 <uartputc>
  for(p="xv6...\n"; *p; p++)
80106845:	ff 45 f4             	incl   -0xc(%ebp)
80106848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684b:	8a 00                	mov    (%eax),%al
8010684d:	84 c0                	test   %al,%al
8010684f:	75 e4                	jne    80106835 <uartinit+0xed>
80106851:	eb 01                	jmp    80106854 <uartinit+0x10c>
    return;
80106853:	90                   	nop
}
80106854:	c9                   	leave  
80106855:	c3                   	ret    

80106856 <uartputc>:

void
uartputc(int c)
{
80106856:	55                   	push   %ebp
80106857:	89 e5                	mov    %esp,%ebp
80106859:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
8010685c:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106861:	85 c0                	test   %eax,%eax
80106863:	74 4c                	je     801068b1 <uartputc+0x5b>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106865:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010686c:	eb 0f                	jmp    8010687d <uartputc+0x27>
    microdelay(10);
8010686e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106875:	e8 4a c6 ff ff       	call   80102ec4 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010687a:	ff 45 f4             	incl   -0xc(%ebp)
8010687d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106881:	7f 16                	jg     80106899 <uartputc+0x43>
80106883:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010688a:	e8 75 fe ff ff       	call   80106704 <inb>
8010688f:	0f b6 c0             	movzbl %al,%eax
80106892:	83 e0 20             	and    $0x20,%eax
80106895:	85 c0                	test   %eax,%eax
80106897:	74 d5                	je     8010686e <uartputc+0x18>
  outb(COM1+0, c);
80106899:	8b 45 08             	mov    0x8(%ebp),%eax
8010689c:	0f b6 c0             	movzbl %al,%eax
8010689f:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a3:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068aa:	e8 7d fe ff ff       	call   8010672c <outb>
801068af:	eb 01                	jmp    801068b2 <uartputc+0x5c>
    return;
801068b1:	90                   	nop
}
801068b2:	c9                   	leave  
801068b3:	c3                   	ret    

801068b4 <uartgetc>:

static int
uartgetc(void)
{
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
801068ba:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
801068bf:	85 c0                	test   %eax,%eax
801068c1:	75 07                	jne    801068ca <uartgetc+0x16>
    return -1;
801068c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068c8:	eb 2c                	jmp    801068f6 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
801068ca:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801068d1:	e8 2e fe ff ff       	call   80106704 <inb>
801068d6:	0f b6 c0             	movzbl %al,%eax
801068d9:	83 e0 01             	and    $0x1,%eax
801068dc:	85 c0                	test   %eax,%eax
801068de:	75 07                	jne    801068e7 <uartgetc+0x33>
    return -1;
801068e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e5:	eb 0f                	jmp    801068f6 <uartgetc+0x42>
  return inb(COM1+0);
801068e7:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801068ee:	e8 11 fe ff ff       	call   80106704 <inb>
801068f3:	0f b6 c0             	movzbl %al,%eax
}
801068f6:	c9                   	leave  
801068f7:	c3                   	ret    

801068f8 <uartintr>:

void
uartintr(void)
{
801068f8:	55                   	push   %ebp
801068f9:	89 e5                	mov    %esp,%ebp
801068fb:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801068fe:	c7 04 24 b4 68 10 80 	movl   $0x801068b4,(%esp)
80106905:	e8 86 9e ff ff       	call   80100790 <consoleintr>
}
8010690a:	c9                   	leave  
8010690b:	c3                   	ret    

8010690c <vector0>:
8010690c:	6a 00                	push   $0x0
8010690e:	6a 00                	push   $0x0
80106910:	e9 22 f9 ff ff       	jmp    80106237 <alltraps>

80106915 <vector1>:
80106915:	6a 00                	push   $0x0
80106917:	6a 01                	push   $0x1
80106919:	e9 19 f9 ff ff       	jmp    80106237 <alltraps>

8010691e <vector2>:
8010691e:	6a 00                	push   $0x0
80106920:	6a 02                	push   $0x2
80106922:	e9 10 f9 ff ff       	jmp    80106237 <alltraps>

80106927 <vector3>:
80106927:	6a 00                	push   $0x0
80106929:	6a 03                	push   $0x3
8010692b:	e9 07 f9 ff ff       	jmp    80106237 <alltraps>

80106930 <vector4>:
80106930:	6a 00                	push   $0x0
80106932:	6a 04                	push   $0x4
80106934:	e9 fe f8 ff ff       	jmp    80106237 <alltraps>

80106939 <vector5>:
80106939:	6a 00                	push   $0x0
8010693b:	6a 05                	push   $0x5
8010693d:	e9 f5 f8 ff ff       	jmp    80106237 <alltraps>

80106942 <vector6>:
80106942:	6a 00                	push   $0x0
80106944:	6a 06                	push   $0x6
80106946:	e9 ec f8 ff ff       	jmp    80106237 <alltraps>

8010694b <vector7>:
8010694b:	6a 00                	push   $0x0
8010694d:	6a 07                	push   $0x7
8010694f:	e9 e3 f8 ff ff       	jmp    80106237 <alltraps>

80106954 <vector8>:
80106954:	6a 08                	push   $0x8
80106956:	e9 dc f8 ff ff       	jmp    80106237 <alltraps>

8010695b <vector9>:
8010695b:	6a 00                	push   $0x0
8010695d:	6a 09                	push   $0x9
8010695f:	e9 d3 f8 ff ff       	jmp    80106237 <alltraps>

80106964 <vector10>:
80106964:	6a 0a                	push   $0xa
80106966:	e9 cc f8 ff ff       	jmp    80106237 <alltraps>

8010696b <vector11>:
8010696b:	6a 0b                	push   $0xb
8010696d:	e9 c5 f8 ff ff       	jmp    80106237 <alltraps>

80106972 <vector12>:
80106972:	6a 0c                	push   $0xc
80106974:	e9 be f8 ff ff       	jmp    80106237 <alltraps>

80106979 <vector13>:
80106979:	6a 0d                	push   $0xd
8010697b:	e9 b7 f8 ff ff       	jmp    80106237 <alltraps>

80106980 <vector14>:
80106980:	6a 0e                	push   $0xe
80106982:	e9 b0 f8 ff ff       	jmp    80106237 <alltraps>

80106987 <vector15>:
80106987:	6a 00                	push   $0x0
80106989:	6a 0f                	push   $0xf
8010698b:	e9 a7 f8 ff ff       	jmp    80106237 <alltraps>

80106990 <vector16>:
80106990:	6a 00                	push   $0x0
80106992:	6a 10                	push   $0x10
80106994:	e9 9e f8 ff ff       	jmp    80106237 <alltraps>

80106999 <vector17>:
80106999:	6a 11                	push   $0x11
8010699b:	e9 97 f8 ff ff       	jmp    80106237 <alltraps>

801069a0 <vector18>:
801069a0:	6a 00                	push   $0x0
801069a2:	6a 12                	push   $0x12
801069a4:	e9 8e f8 ff ff       	jmp    80106237 <alltraps>

801069a9 <vector19>:
801069a9:	6a 00                	push   $0x0
801069ab:	6a 13                	push   $0x13
801069ad:	e9 85 f8 ff ff       	jmp    80106237 <alltraps>

801069b2 <vector20>:
801069b2:	6a 00                	push   $0x0
801069b4:	6a 14                	push   $0x14
801069b6:	e9 7c f8 ff ff       	jmp    80106237 <alltraps>

801069bb <vector21>:
801069bb:	6a 00                	push   $0x0
801069bd:	6a 15                	push   $0x15
801069bf:	e9 73 f8 ff ff       	jmp    80106237 <alltraps>

801069c4 <vector22>:
801069c4:	6a 00                	push   $0x0
801069c6:	6a 16                	push   $0x16
801069c8:	e9 6a f8 ff ff       	jmp    80106237 <alltraps>

801069cd <vector23>:
801069cd:	6a 00                	push   $0x0
801069cf:	6a 17                	push   $0x17
801069d1:	e9 61 f8 ff ff       	jmp    80106237 <alltraps>

801069d6 <vector24>:
801069d6:	6a 00                	push   $0x0
801069d8:	6a 18                	push   $0x18
801069da:	e9 58 f8 ff ff       	jmp    80106237 <alltraps>

801069df <vector25>:
801069df:	6a 00                	push   $0x0
801069e1:	6a 19                	push   $0x19
801069e3:	e9 4f f8 ff ff       	jmp    80106237 <alltraps>

801069e8 <vector26>:
801069e8:	6a 00                	push   $0x0
801069ea:	6a 1a                	push   $0x1a
801069ec:	e9 46 f8 ff ff       	jmp    80106237 <alltraps>

801069f1 <vector27>:
801069f1:	6a 00                	push   $0x0
801069f3:	6a 1b                	push   $0x1b
801069f5:	e9 3d f8 ff ff       	jmp    80106237 <alltraps>

801069fa <vector28>:
801069fa:	6a 00                	push   $0x0
801069fc:	6a 1c                	push   $0x1c
801069fe:	e9 34 f8 ff ff       	jmp    80106237 <alltraps>

80106a03 <vector29>:
80106a03:	6a 00                	push   $0x0
80106a05:	6a 1d                	push   $0x1d
80106a07:	e9 2b f8 ff ff       	jmp    80106237 <alltraps>

80106a0c <vector30>:
80106a0c:	6a 00                	push   $0x0
80106a0e:	6a 1e                	push   $0x1e
80106a10:	e9 22 f8 ff ff       	jmp    80106237 <alltraps>

80106a15 <vector31>:
80106a15:	6a 00                	push   $0x0
80106a17:	6a 1f                	push   $0x1f
80106a19:	e9 19 f8 ff ff       	jmp    80106237 <alltraps>

80106a1e <vector32>:
80106a1e:	6a 00                	push   $0x0
80106a20:	6a 20                	push   $0x20
80106a22:	e9 10 f8 ff ff       	jmp    80106237 <alltraps>

80106a27 <vector33>:
80106a27:	6a 00                	push   $0x0
80106a29:	6a 21                	push   $0x21
80106a2b:	e9 07 f8 ff ff       	jmp    80106237 <alltraps>

80106a30 <vector34>:
80106a30:	6a 00                	push   $0x0
80106a32:	6a 22                	push   $0x22
80106a34:	e9 fe f7 ff ff       	jmp    80106237 <alltraps>

80106a39 <vector35>:
80106a39:	6a 00                	push   $0x0
80106a3b:	6a 23                	push   $0x23
80106a3d:	e9 f5 f7 ff ff       	jmp    80106237 <alltraps>

80106a42 <vector36>:
80106a42:	6a 00                	push   $0x0
80106a44:	6a 24                	push   $0x24
80106a46:	e9 ec f7 ff ff       	jmp    80106237 <alltraps>

80106a4b <vector37>:
80106a4b:	6a 00                	push   $0x0
80106a4d:	6a 25                	push   $0x25
80106a4f:	e9 e3 f7 ff ff       	jmp    80106237 <alltraps>

80106a54 <vector38>:
80106a54:	6a 00                	push   $0x0
80106a56:	6a 26                	push   $0x26
80106a58:	e9 da f7 ff ff       	jmp    80106237 <alltraps>

80106a5d <vector39>:
80106a5d:	6a 00                	push   $0x0
80106a5f:	6a 27                	push   $0x27
80106a61:	e9 d1 f7 ff ff       	jmp    80106237 <alltraps>

80106a66 <vector40>:
80106a66:	6a 00                	push   $0x0
80106a68:	6a 28                	push   $0x28
80106a6a:	e9 c8 f7 ff ff       	jmp    80106237 <alltraps>

80106a6f <vector41>:
80106a6f:	6a 00                	push   $0x0
80106a71:	6a 29                	push   $0x29
80106a73:	e9 bf f7 ff ff       	jmp    80106237 <alltraps>

80106a78 <vector42>:
80106a78:	6a 00                	push   $0x0
80106a7a:	6a 2a                	push   $0x2a
80106a7c:	e9 b6 f7 ff ff       	jmp    80106237 <alltraps>

80106a81 <vector43>:
80106a81:	6a 00                	push   $0x0
80106a83:	6a 2b                	push   $0x2b
80106a85:	e9 ad f7 ff ff       	jmp    80106237 <alltraps>

80106a8a <vector44>:
80106a8a:	6a 00                	push   $0x0
80106a8c:	6a 2c                	push   $0x2c
80106a8e:	e9 a4 f7 ff ff       	jmp    80106237 <alltraps>

80106a93 <vector45>:
80106a93:	6a 00                	push   $0x0
80106a95:	6a 2d                	push   $0x2d
80106a97:	e9 9b f7 ff ff       	jmp    80106237 <alltraps>

80106a9c <vector46>:
80106a9c:	6a 00                	push   $0x0
80106a9e:	6a 2e                	push   $0x2e
80106aa0:	e9 92 f7 ff ff       	jmp    80106237 <alltraps>

80106aa5 <vector47>:
80106aa5:	6a 00                	push   $0x0
80106aa7:	6a 2f                	push   $0x2f
80106aa9:	e9 89 f7 ff ff       	jmp    80106237 <alltraps>

80106aae <vector48>:
80106aae:	6a 00                	push   $0x0
80106ab0:	6a 30                	push   $0x30
80106ab2:	e9 80 f7 ff ff       	jmp    80106237 <alltraps>

80106ab7 <vector49>:
80106ab7:	6a 00                	push   $0x0
80106ab9:	6a 31                	push   $0x31
80106abb:	e9 77 f7 ff ff       	jmp    80106237 <alltraps>

80106ac0 <vector50>:
80106ac0:	6a 00                	push   $0x0
80106ac2:	6a 32                	push   $0x32
80106ac4:	e9 6e f7 ff ff       	jmp    80106237 <alltraps>

80106ac9 <vector51>:
80106ac9:	6a 00                	push   $0x0
80106acb:	6a 33                	push   $0x33
80106acd:	e9 65 f7 ff ff       	jmp    80106237 <alltraps>

80106ad2 <vector52>:
80106ad2:	6a 00                	push   $0x0
80106ad4:	6a 34                	push   $0x34
80106ad6:	e9 5c f7 ff ff       	jmp    80106237 <alltraps>

80106adb <vector53>:
80106adb:	6a 00                	push   $0x0
80106add:	6a 35                	push   $0x35
80106adf:	e9 53 f7 ff ff       	jmp    80106237 <alltraps>

80106ae4 <vector54>:
80106ae4:	6a 00                	push   $0x0
80106ae6:	6a 36                	push   $0x36
80106ae8:	e9 4a f7 ff ff       	jmp    80106237 <alltraps>

80106aed <vector55>:
80106aed:	6a 00                	push   $0x0
80106aef:	6a 37                	push   $0x37
80106af1:	e9 41 f7 ff ff       	jmp    80106237 <alltraps>

80106af6 <vector56>:
80106af6:	6a 00                	push   $0x0
80106af8:	6a 38                	push   $0x38
80106afa:	e9 38 f7 ff ff       	jmp    80106237 <alltraps>

80106aff <vector57>:
80106aff:	6a 00                	push   $0x0
80106b01:	6a 39                	push   $0x39
80106b03:	e9 2f f7 ff ff       	jmp    80106237 <alltraps>

80106b08 <vector58>:
80106b08:	6a 00                	push   $0x0
80106b0a:	6a 3a                	push   $0x3a
80106b0c:	e9 26 f7 ff ff       	jmp    80106237 <alltraps>

80106b11 <vector59>:
80106b11:	6a 00                	push   $0x0
80106b13:	6a 3b                	push   $0x3b
80106b15:	e9 1d f7 ff ff       	jmp    80106237 <alltraps>

80106b1a <vector60>:
80106b1a:	6a 00                	push   $0x0
80106b1c:	6a 3c                	push   $0x3c
80106b1e:	e9 14 f7 ff ff       	jmp    80106237 <alltraps>

80106b23 <vector61>:
80106b23:	6a 00                	push   $0x0
80106b25:	6a 3d                	push   $0x3d
80106b27:	e9 0b f7 ff ff       	jmp    80106237 <alltraps>

80106b2c <vector62>:
80106b2c:	6a 00                	push   $0x0
80106b2e:	6a 3e                	push   $0x3e
80106b30:	e9 02 f7 ff ff       	jmp    80106237 <alltraps>

80106b35 <vector63>:
80106b35:	6a 00                	push   $0x0
80106b37:	6a 3f                	push   $0x3f
80106b39:	e9 f9 f6 ff ff       	jmp    80106237 <alltraps>

80106b3e <vector64>:
80106b3e:	6a 00                	push   $0x0
80106b40:	6a 40                	push   $0x40
80106b42:	e9 f0 f6 ff ff       	jmp    80106237 <alltraps>

80106b47 <vector65>:
80106b47:	6a 00                	push   $0x0
80106b49:	6a 41                	push   $0x41
80106b4b:	e9 e7 f6 ff ff       	jmp    80106237 <alltraps>

80106b50 <vector66>:
80106b50:	6a 00                	push   $0x0
80106b52:	6a 42                	push   $0x42
80106b54:	e9 de f6 ff ff       	jmp    80106237 <alltraps>

80106b59 <vector67>:
80106b59:	6a 00                	push   $0x0
80106b5b:	6a 43                	push   $0x43
80106b5d:	e9 d5 f6 ff ff       	jmp    80106237 <alltraps>

80106b62 <vector68>:
80106b62:	6a 00                	push   $0x0
80106b64:	6a 44                	push   $0x44
80106b66:	e9 cc f6 ff ff       	jmp    80106237 <alltraps>

80106b6b <vector69>:
80106b6b:	6a 00                	push   $0x0
80106b6d:	6a 45                	push   $0x45
80106b6f:	e9 c3 f6 ff ff       	jmp    80106237 <alltraps>

80106b74 <vector70>:
80106b74:	6a 00                	push   $0x0
80106b76:	6a 46                	push   $0x46
80106b78:	e9 ba f6 ff ff       	jmp    80106237 <alltraps>

80106b7d <vector71>:
80106b7d:	6a 00                	push   $0x0
80106b7f:	6a 47                	push   $0x47
80106b81:	e9 b1 f6 ff ff       	jmp    80106237 <alltraps>

80106b86 <vector72>:
80106b86:	6a 00                	push   $0x0
80106b88:	6a 48                	push   $0x48
80106b8a:	e9 a8 f6 ff ff       	jmp    80106237 <alltraps>

80106b8f <vector73>:
80106b8f:	6a 00                	push   $0x0
80106b91:	6a 49                	push   $0x49
80106b93:	e9 9f f6 ff ff       	jmp    80106237 <alltraps>

80106b98 <vector74>:
80106b98:	6a 00                	push   $0x0
80106b9a:	6a 4a                	push   $0x4a
80106b9c:	e9 96 f6 ff ff       	jmp    80106237 <alltraps>

80106ba1 <vector75>:
80106ba1:	6a 00                	push   $0x0
80106ba3:	6a 4b                	push   $0x4b
80106ba5:	e9 8d f6 ff ff       	jmp    80106237 <alltraps>

80106baa <vector76>:
80106baa:	6a 00                	push   $0x0
80106bac:	6a 4c                	push   $0x4c
80106bae:	e9 84 f6 ff ff       	jmp    80106237 <alltraps>

80106bb3 <vector77>:
80106bb3:	6a 00                	push   $0x0
80106bb5:	6a 4d                	push   $0x4d
80106bb7:	e9 7b f6 ff ff       	jmp    80106237 <alltraps>

80106bbc <vector78>:
80106bbc:	6a 00                	push   $0x0
80106bbe:	6a 4e                	push   $0x4e
80106bc0:	e9 72 f6 ff ff       	jmp    80106237 <alltraps>

80106bc5 <vector79>:
80106bc5:	6a 00                	push   $0x0
80106bc7:	6a 4f                	push   $0x4f
80106bc9:	e9 69 f6 ff ff       	jmp    80106237 <alltraps>

80106bce <vector80>:
80106bce:	6a 00                	push   $0x0
80106bd0:	6a 50                	push   $0x50
80106bd2:	e9 60 f6 ff ff       	jmp    80106237 <alltraps>

80106bd7 <vector81>:
80106bd7:	6a 00                	push   $0x0
80106bd9:	6a 51                	push   $0x51
80106bdb:	e9 57 f6 ff ff       	jmp    80106237 <alltraps>

80106be0 <vector82>:
80106be0:	6a 00                	push   $0x0
80106be2:	6a 52                	push   $0x52
80106be4:	e9 4e f6 ff ff       	jmp    80106237 <alltraps>

80106be9 <vector83>:
80106be9:	6a 00                	push   $0x0
80106beb:	6a 53                	push   $0x53
80106bed:	e9 45 f6 ff ff       	jmp    80106237 <alltraps>

80106bf2 <vector84>:
80106bf2:	6a 00                	push   $0x0
80106bf4:	6a 54                	push   $0x54
80106bf6:	e9 3c f6 ff ff       	jmp    80106237 <alltraps>

80106bfb <vector85>:
80106bfb:	6a 00                	push   $0x0
80106bfd:	6a 55                	push   $0x55
80106bff:	e9 33 f6 ff ff       	jmp    80106237 <alltraps>

80106c04 <vector86>:
80106c04:	6a 00                	push   $0x0
80106c06:	6a 56                	push   $0x56
80106c08:	e9 2a f6 ff ff       	jmp    80106237 <alltraps>

80106c0d <vector87>:
80106c0d:	6a 00                	push   $0x0
80106c0f:	6a 57                	push   $0x57
80106c11:	e9 21 f6 ff ff       	jmp    80106237 <alltraps>

80106c16 <vector88>:
80106c16:	6a 00                	push   $0x0
80106c18:	6a 58                	push   $0x58
80106c1a:	e9 18 f6 ff ff       	jmp    80106237 <alltraps>

80106c1f <vector89>:
80106c1f:	6a 00                	push   $0x0
80106c21:	6a 59                	push   $0x59
80106c23:	e9 0f f6 ff ff       	jmp    80106237 <alltraps>

80106c28 <vector90>:
80106c28:	6a 00                	push   $0x0
80106c2a:	6a 5a                	push   $0x5a
80106c2c:	e9 06 f6 ff ff       	jmp    80106237 <alltraps>

80106c31 <vector91>:
80106c31:	6a 00                	push   $0x0
80106c33:	6a 5b                	push   $0x5b
80106c35:	e9 fd f5 ff ff       	jmp    80106237 <alltraps>

80106c3a <vector92>:
80106c3a:	6a 00                	push   $0x0
80106c3c:	6a 5c                	push   $0x5c
80106c3e:	e9 f4 f5 ff ff       	jmp    80106237 <alltraps>

80106c43 <vector93>:
80106c43:	6a 00                	push   $0x0
80106c45:	6a 5d                	push   $0x5d
80106c47:	e9 eb f5 ff ff       	jmp    80106237 <alltraps>

80106c4c <vector94>:
80106c4c:	6a 00                	push   $0x0
80106c4e:	6a 5e                	push   $0x5e
80106c50:	e9 e2 f5 ff ff       	jmp    80106237 <alltraps>

80106c55 <vector95>:
80106c55:	6a 00                	push   $0x0
80106c57:	6a 5f                	push   $0x5f
80106c59:	e9 d9 f5 ff ff       	jmp    80106237 <alltraps>

80106c5e <vector96>:
80106c5e:	6a 00                	push   $0x0
80106c60:	6a 60                	push   $0x60
80106c62:	e9 d0 f5 ff ff       	jmp    80106237 <alltraps>

80106c67 <vector97>:
80106c67:	6a 00                	push   $0x0
80106c69:	6a 61                	push   $0x61
80106c6b:	e9 c7 f5 ff ff       	jmp    80106237 <alltraps>

80106c70 <vector98>:
80106c70:	6a 00                	push   $0x0
80106c72:	6a 62                	push   $0x62
80106c74:	e9 be f5 ff ff       	jmp    80106237 <alltraps>

80106c79 <vector99>:
80106c79:	6a 00                	push   $0x0
80106c7b:	6a 63                	push   $0x63
80106c7d:	e9 b5 f5 ff ff       	jmp    80106237 <alltraps>

80106c82 <vector100>:
80106c82:	6a 00                	push   $0x0
80106c84:	6a 64                	push   $0x64
80106c86:	e9 ac f5 ff ff       	jmp    80106237 <alltraps>

80106c8b <vector101>:
80106c8b:	6a 00                	push   $0x0
80106c8d:	6a 65                	push   $0x65
80106c8f:	e9 a3 f5 ff ff       	jmp    80106237 <alltraps>

80106c94 <vector102>:
80106c94:	6a 00                	push   $0x0
80106c96:	6a 66                	push   $0x66
80106c98:	e9 9a f5 ff ff       	jmp    80106237 <alltraps>

80106c9d <vector103>:
80106c9d:	6a 00                	push   $0x0
80106c9f:	6a 67                	push   $0x67
80106ca1:	e9 91 f5 ff ff       	jmp    80106237 <alltraps>

80106ca6 <vector104>:
80106ca6:	6a 00                	push   $0x0
80106ca8:	6a 68                	push   $0x68
80106caa:	e9 88 f5 ff ff       	jmp    80106237 <alltraps>

80106caf <vector105>:
80106caf:	6a 00                	push   $0x0
80106cb1:	6a 69                	push   $0x69
80106cb3:	e9 7f f5 ff ff       	jmp    80106237 <alltraps>

80106cb8 <vector106>:
80106cb8:	6a 00                	push   $0x0
80106cba:	6a 6a                	push   $0x6a
80106cbc:	e9 76 f5 ff ff       	jmp    80106237 <alltraps>

80106cc1 <vector107>:
80106cc1:	6a 00                	push   $0x0
80106cc3:	6a 6b                	push   $0x6b
80106cc5:	e9 6d f5 ff ff       	jmp    80106237 <alltraps>

80106cca <vector108>:
80106cca:	6a 00                	push   $0x0
80106ccc:	6a 6c                	push   $0x6c
80106cce:	e9 64 f5 ff ff       	jmp    80106237 <alltraps>

80106cd3 <vector109>:
80106cd3:	6a 00                	push   $0x0
80106cd5:	6a 6d                	push   $0x6d
80106cd7:	e9 5b f5 ff ff       	jmp    80106237 <alltraps>

80106cdc <vector110>:
80106cdc:	6a 00                	push   $0x0
80106cde:	6a 6e                	push   $0x6e
80106ce0:	e9 52 f5 ff ff       	jmp    80106237 <alltraps>

80106ce5 <vector111>:
80106ce5:	6a 00                	push   $0x0
80106ce7:	6a 6f                	push   $0x6f
80106ce9:	e9 49 f5 ff ff       	jmp    80106237 <alltraps>

80106cee <vector112>:
80106cee:	6a 00                	push   $0x0
80106cf0:	6a 70                	push   $0x70
80106cf2:	e9 40 f5 ff ff       	jmp    80106237 <alltraps>

80106cf7 <vector113>:
80106cf7:	6a 00                	push   $0x0
80106cf9:	6a 71                	push   $0x71
80106cfb:	e9 37 f5 ff ff       	jmp    80106237 <alltraps>

80106d00 <vector114>:
80106d00:	6a 00                	push   $0x0
80106d02:	6a 72                	push   $0x72
80106d04:	e9 2e f5 ff ff       	jmp    80106237 <alltraps>

80106d09 <vector115>:
80106d09:	6a 00                	push   $0x0
80106d0b:	6a 73                	push   $0x73
80106d0d:	e9 25 f5 ff ff       	jmp    80106237 <alltraps>

80106d12 <vector116>:
80106d12:	6a 00                	push   $0x0
80106d14:	6a 74                	push   $0x74
80106d16:	e9 1c f5 ff ff       	jmp    80106237 <alltraps>

80106d1b <vector117>:
80106d1b:	6a 00                	push   $0x0
80106d1d:	6a 75                	push   $0x75
80106d1f:	e9 13 f5 ff ff       	jmp    80106237 <alltraps>

80106d24 <vector118>:
80106d24:	6a 00                	push   $0x0
80106d26:	6a 76                	push   $0x76
80106d28:	e9 0a f5 ff ff       	jmp    80106237 <alltraps>

80106d2d <vector119>:
80106d2d:	6a 00                	push   $0x0
80106d2f:	6a 77                	push   $0x77
80106d31:	e9 01 f5 ff ff       	jmp    80106237 <alltraps>

80106d36 <vector120>:
80106d36:	6a 00                	push   $0x0
80106d38:	6a 78                	push   $0x78
80106d3a:	e9 f8 f4 ff ff       	jmp    80106237 <alltraps>

80106d3f <vector121>:
80106d3f:	6a 00                	push   $0x0
80106d41:	6a 79                	push   $0x79
80106d43:	e9 ef f4 ff ff       	jmp    80106237 <alltraps>

80106d48 <vector122>:
80106d48:	6a 00                	push   $0x0
80106d4a:	6a 7a                	push   $0x7a
80106d4c:	e9 e6 f4 ff ff       	jmp    80106237 <alltraps>

80106d51 <vector123>:
80106d51:	6a 00                	push   $0x0
80106d53:	6a 7b                	push   $0x7b
80106d55:	e9 dd f4 ff ff       	jmp    80106237 <alltraps>

80106d5a <vector124>:
80106d5a:	6a 00                	push   $0x0
80106d5c:	6a 7c                	push   $0x7c
80106d5e:	e9 d4 f4 ff ff       	jmp    80106237 <alltraps>

80106d63 <vector125>:
80106d63:	6a 00                	push   $0x0
80106d65:	6a 7d                	push   $0x7d
80106d67:	e9 cb f4 ff ff       	jmp    80106237 <alltraps>

80106d6c <vector126>:
80106d6c:	6a 00                	push   $0x0
80106d6e:	6a 7e                	push   $0x7e
80106d70:	e9 c2 f4 ff ff       	jmp    80106237 <alltraps>

80106d75 <vector127>:
80106d75:	6a 00                	push   $0x0
80106d77:	6a 7f                	push   $0x7f
80106d79:	e9 b9 f4 ff ff       	jmp    80106237 <alltraps>

80106d7e <vector128>:
80106d7e:	6a 00                	push   $0x0
80106d80:	68 80 00 00 00       	push   $0x80
80106d85:	e9 ad f4 ff ff       	jmp    80106237 <alltraps>

80106d8a <vector129>:
80106d8a:	6a 00                	push   $0x0
80106d8c:	68 81 00 00 00       	push   $0x81
80106d91:	e9 a1 f4 ff ff       	jmp    80106237 <alltraps>

80106d96 <vector130>:
80106d96:	6a 00                	push   $0x0
80106d98:	68 82 00 00 00       	push   $0x82
80106d9d:	e9 95 f4 ff ff       	jmp    80106237 <alltraps>

80106da2 <vector131>:
80106da2:	6a 00                	push   $0x0
80106da4:	68 83 00 00 00       	push   $0x83
80106da9:	e9 89 f4 ff ff       	jmp    80106237 <alltraps>

80106dae <vector132>:
80106dae:	6a 00                	push   $0x0
80106db0:	68 84 00 00 00       	push   $0x84
80106db5:	e9 7d f4 ff ff       	jmp    80106237 <alltraps>

80106dba <vector133>:
80106dba:	6a 00                	push   $0x0
80106dbc:	68 85 00 00 00       	push   $0x85
80106dc1:	e9 71 f4 ff ff       	jmp    80106237 <alltraps>

80106dc6 <vector134>:
80106dc6:	6a 00                	push   $0x0
80106dc8:	68 86 00 00 00       	push   $0x86
80106dcd:	e9 65 f4 ff ff       	jmp    80106237 <alltraps>

80106dd2 <vector135>:
80106dd2:	6a 00                	push   $0x0
80106dd4:	68 87 00 00 00       	push   $0x87
80106dd9:	e9 59 f4 ff ff       	jmp    80106237 <alltraps>

80106dde <vector136>:
80106dde:	6a 00                	push   $0x0
80106de0:	68 88 00 00 00       	push   $0x88
80106de5:	e9 4d f4 ff ff       	jmp    80106237 <alltraps>

80106dea <vector137>:
80106dea:	6a 00                	push   $0x0
80106dec:	68 89 00 00 00       	push   $0x89
80106df1:	e9 41 f4 ff ff       	jmp    80106237 <alltraps>

80106df6 <vector138>:
80106df6:	6a 00                	push   $0x0
80106df8:	68 8a 00 00 00       	push   $0x8a
80106dfd:	e9 35 f4 ff ff       	jmp    80106237 <alltraps>

80106e02 <vector139>:
80106e02:	6a 00                	push   $0x0
80106e04:	68 8b 00 00 00       	push   $0x8b
80106e09:	e9 29 f4 ff ff       	jmp    80106237 <alltraps>

80106e0e <vector140>:
80106e0e:	6a 00                	push   $0x0
80106e10:	68 8c 00 00 00       	push   $0x8c
80106e15:	e9 1d f4 ff ff       	jmp    80106237 <alltraps>

80106e1a <vector141>:
80106e1a:	6a 00                	push   $0x0
80106e1c:	68 8d 00 00 00       	push   $0x8d
80106e21:	e9 11 f4 ff ff       	jmp    80106237 <alltraps>

80106e26 <vector142>:
80106e26:	6a 00                	push   $0x0
80106e28:	68 8e 00 00 00       	push   $0x8e
80106e2d:	e9 05 f4 ff ff       	jmp    80106237 <alltraps>

80106e32 <vector143>:
80106e32:	6a 00                	push   $0x0
80106e34:	68 8f 00 00 00       	push   $0x8f
80106e39:	e9 f9 f3 ff ff       	jmp    80106237 <alltraps>

80106e3e <vector144>:
80106e3e:	6a 00                	push   $0x0
80106e40:	68 90 00 00 00       	push   $0x90
80106e45:	e9 ed f3 ff ff       	jmp    80106237 <alltraps>

80106e4a <vector145>:
80106e4a:	6a 00                	push   $0x0
80106e4c:	68 91 00 00 00       	push   $0x91
80106e51:	e9 e1 f3 ff ff       	jmp    80106237 <alltraps>

80106e56 <vector146>:
80106e56:	6a 00                	push   $0x0
80106e58:	68 92 00 00 00       	push   $0x92
80106e5d:	e9 d5 f3 ff ff       	jmp    80106237 <alltraps>

80106e62 <vector147>:
80106e62:	6a 00                	push   $0x0
80106e64:	68 93 00 00 00       	push   $0x93
80106e69:	e9 c9 f3 ff ff       	jmp    80106237 <alltraps>

80106e6e <vector148>:
80106e6e:	6a 00                	push   $0x0
80106e70:	68 94 00 00 00       	push   $0x94
80106e75:	e9 bd f3 ff ff       	jmp    80106237 <alltraps>

80106e7a <vector149>:
80106e7a:	6a 00                	push   $0x0
80106e7c:	68 95 00 00 00       	push   $0x95
80106e81:	e9 b1 f3 ff ff       	jmp    80106237 <alltraps>

80106e86 <vector150>:
80106e86:	6a 00                	push   $0x0
80106e88:	68 96 00 00 00       	push   $0x96
80106e8d:	e9 a5 f3 ff ff       	jmp    80106237 <alltraps>

80106e92 <vector151>:
80106e92:	6a 00                	push   $0x0
80106e94:	68 97 00 00 00       	push   $0x97
80106e99:	e9 99 f3 ff ff       	jmp    80106237 <alltraps>

80106e9e <vector152>:
80106e9e:	6a 00                	push   $0x0
80106ea0:	68 98 00 00 00       	push   $0x98
80106ea5:	e9 8d f3 ff ff       	jmp    80106237 <alltraps>

80106eaa <vector153>:
80106eaa:	6a 00                	push   $0x0
80106eac:	68 99 00 00 00       	push   $0x99
80106eb1:	e9 81 f3 ff ff       	jmp    80106237 <alltraps>

80106eb6 <vector154>:
80106eb6:	6a 00                	push   $0x0
80106eb8:	68 9a 00 00 00       	push   $0x9a
80106ebd:	e9 75 f3 ff ff       	jmp    80106237 <alltraps>

80106ec2 <vector155>:
80106ec2:	6a 00                	push   $0x0
80106ec4:	68 9b 00 00 00       	push   $0x9b
80106ec9:	e9 69 f3 ff ff       	jmp    80106237 <alltraps>

80106ece <vector156>:
80106ece:	6a 00                	push   $0x0
80106ed0:	68 9c 00 00 00       	push   $0x9c
80106ed5:	e9 5d f3 ff ff       	jmp    80106237 <alltraps>

80106eda <vector157>:
80106eda:	6a 00                	push   $0x0
80106edc:	68 9d 00 00 00       	push   $0x9d
80106ee1:	e9 51 f3 ff ff       	jmp    80106237 <alltraps>

80106ee6 <vector158>:
80106ee6:	6a 00                	push   $0x0
80106ee8:	68 9e 00 00 00       	push   $0x9e
80106eed:	e9 45 f3 ff ff       	jmp    80106237 <alltraps>

80106ef2 <vector159>:
80106ef2:	6a 00                	push   $0x0
80106ef4:	68 9f 00 00 00       	push   $0x9f
80106ef9:	e9 39 f3 ff ff       	jmp    80106237 <alltraps>

80106efe <vector160>:
80106efe:	6a 00                	push   $0x0
80106f00:	68 a0 00 00 00       	push   $0xa0
80106f05:	e9 2d f3 ff ff       	jmp    80106237 <alltraps>

80106f0a <vector161>:
80106f0a:	6a 00                	push   $0x0
80106f0c:	68 a1 00 00 00       	push   $0xa1
80106f11:	e9 21 f3 ff ff       	jmp    80106237 <alltraps>

80106f16 <vector162>:
80106f16:	6a 00                	push   $0x0
80106f18:	68 a2 00 00 00       	push   $0xa2
80106f1d:	e9 15 f3 ff ff       	jmp    80106237 <alltraps>

80106f22 <vector163>:
80106f22:	6a 00                	push   $0x0
80106f24:	68 a3 00 00 00       	push   $0xa3
80106f29:	e9 09 f3 ff ff       	jmp    80106237 <alltraps>

80106f2e <vector164>:
80106f2e:	6a 00                	push   $0x0
80106f30:	68 a4 00 00 00       	push   $0xa4
80106f35:	e9 fd f2 ff ff       	jmp    80106237 <alltraps>

80106f3a <vector165>:
80106f3a:	6a 00                	push   $0x0
80106f3c:	68 a5 00 00 00       	push   $0xa5
80106f41:	e9 f1 f2 ff ff       	jmp    80106237 <alltraps>

80106f46 <vector166>:
80106f46:	6a 00                	push   $0x0
80106f48:	68 a6 00 00 00       	push   $0xa6
80106f4d:	e9 e5 f2 ff ff       	jmp    80106237 <alltraps>

80106f52 <vector167>:
80106f52:	6a 00                	push   $0x0
80106f54:	68 a7 00 00 00       	push   $0xa7
80106f59:	e9 d9 f2 ff ff       	jmp    80106237 <alltraps>

80106f5e <vector168>:
80106f5e:	6a 00                	push   $0x0
80106f60:	68 a8 00 00 00       	push   $0xa8
80106f65:	e9 cd f2 ff ff       	jmp    80106237 <alltraps>

80106f6a <vector169>:
80106f6a:	6a 00                	push   $0x0
80106f6c:	68 a9 00 00 00       	push   $0xa9
80106f71:	e9 c1 f2 ff ff       	jmp    80106237 <alltraps>

80106f76 <vector170>:
80106f76:	6a 00                	push   $0x0
80106f78:	68 aa 00 00 00       	push   $0xaa
80106f7d:	e9 b5 f2 ff ff       	jmp    80106237 <alltraps>

80106f82 <vector171>:
80106f82:	6a 00                	push   $0x0
80106f84:	68 ab 00 00 00       	push   $0xab
80106f89:	e9 a9 f2 ff ff       	jmp    80106237 <alltraps>

80106f8e <vector172>:
80106f8e:	6a 00                	push   $0x0
80106f90:	68 ac 00 00 00       	push   $0xac
80106f95:	e9 9d f2 ff ff       	jmp    80106237 <alltraps>

80106f9a <vector173>:
80106f9a:	6a 00                	push   $0x0
80106f9c:	68 ad 00 00 00       	push   $0xad
80106fa1:	e9 91 f2 ff ff       	jmp    80106237 <alltraps>

80106fa6 <vector174>:
80106fa6:	6a 00                	push   $0x0
80106fa8:	68 ae 00 00 00       	push   $0xae
80106fad:	e9 85 f2 ff ff       	jmp    80106237 <alltraps>

80106fb2 <vector175>:
80106fb2:	6a 00                	push   $0x0
80106fb4:	68 af 00 00 00       	push   $0xaf
80106fb9:	e9 79 f2 ff ff       	jmp    80106237 <alltraps>

80106fbe <vector176>:
80106fbe:	6a 00                	push   $0x0
80106fc0:	68 b0 00 00 00       	push   $0xb0
80106fc5:	e9 6d f2 ff ff       	jmp    80106237 <alltraps>

80106fca <vector177>:
80106fca:	6a 00                	push   $0x0
80106fcc:	68 b1 00 00 00       	push   $0xb1
80106fd1:	e9 61 f2 ff ff       	jmp    80106237 <alltraps>

80106fd6 <vector178>:
80106fd6:	6a 00                	push   $0x0
80106fd8:	68 b2 00 00 00       	push   $0xb2
80106fdd:	e9 55 f2 ff ff       	jmp    80106237 <alltraps>

80106fe2 <vector179>:
80106fe2:	6a 00                	push   $0x0
80106fe4:	68 b3 00 00 00       	push   $0xb3
80106fe9:	e9 49 f2 ff ff       	jmp    80106237 <alltraps>

80106fee <vector180>:
80106fee:	6a 00                	push   $0x0
80106ff0:	68 b4 00 00 00       	push   $0xb4
80106ff5:	e9 3d f2 ff ff       	jmp    80106237 <alltraps>

80106ffa <vector181>:
80106ffa:	6a 00                	push   $0x0
80106ffc:	68 b5 00 00 00       	push   $0xb5
80107001:	e9 31 f2 ff ff       	jmp    80106237 <alltraps>

80107006 <vector182>:
80107006:	6a 00                	push   $0x0
80107008:	68 b6 00 00 00       	push   $0xb6
8010700d:	e9 25 f2 ff ff       	jmp    80106237 <alltraps>

80107012 <vector183>:
80107012:	6a 00                	push   $0x0
80107014:	68 b7 00 00 00       	push   $0xb7
80107019:	e9 19 f2 ff ff       	jmp    80106237 <alltraps>

8010701e <vector184>:
8010701e:	6a 00                	push   $0x0
80107020:	68 b8 00 00 00       	push   $0xb8
80107025:	e9 0d f2 ff ff       	jmp    80106237 <alltraps>

8010702a <vector185>:
8010702a:	6a 00                	push   $0x0
8010702c:	68 b9 00 00 00       	push   $0xb9
80107031:	e9 01 f2 ff ff       	jmp    80106237 <alltraps>

80107036 <vector186>:
80107036:	6a 00                	push   $0x0
80107038:	68 ba 00 00 00       	push   $0xba
8010703d:	e9 f5 f1 ff ff       	jmp    80106237 <alltraps>

80107042 <vector187>:
80107042:	6a 00                	push   $0x0
80107044:	68 bb 00 00 00       	push   $0xbb
80107049:	e9 e9 f1 ff ff       	jmp    80106237 <alltraps>

8010704e <vector188>:
8010704e:	6a 00                	push   $0x0
80107050:	68 bc 00 00 00       	push   $0xbc
80107055:	e9 dd f1 ff ff       	jmp    80106237 <alltraps>

8010705a <vector189>:
8010705a:	6a 00                	push   $0x0
8010705c:	68 bd 00 00 00       	push   $0xbd
80107061:	e9 d1 f1 ff ff       	jmp    80106237 <alltraps>

80107066 <vector190>:
80107066:	6a 00                	push   $0x0
80107068:	68 be 00 00 00       	push   $0xbe
8010706d:	e9 c5 f1 ff ff       	jmp    80106237 <alltraps>

80107072 <vector191>:
80107072:	6a 00                	push   $0x0
80107074:	68 bf 00 00 00       	push   $0xbf
80107079:	e9 b9 f1 ff ff       	jmp    80106237 <alltraps>

8010707e <vector192>:
8010707e:	6a 00                	push   $0x0
80107080:	68 c0 00 00 00       	push   $0xc0
80107085:	e9 ad f1 ff ff       	jmp    80106237 <alltraps>

8010708a <vector193>:
8010708a:	6a 00                	push   $0x0
8010708c:	68 c1 00 00 00       	push   $0xc1
80107091:	e9 a1 f1 ff ff       	jmp    80106237 <alltraps>

80107096 <vector194>:
80107096:	6a 00                	push   $0x0
80107098:	68 c2 00 00 00       	push   $0xc2
8010709d:	e9 95 f1 ff ff       	jmp    80106237 <alltraps>

801070a2 <vector195>:
801070a2:	6a 00                	push   $0x0
801070a4:	68 c3 00 00 00       	push   $0xc3
801070a9:	e9 89 f1 ff ff       	jmp    80106237 <alltraps>

801070ae <vector196>:
801070ae:	6a 00                	push   $0x0
801070b0:	68 c4 00 00 00       	push   $0xc4
801070b5:	e9 7d f1 ff ff       	jmp    80106237 <alltraps>

801070ba <vector197>:
801070ba:	6a 00                	push   $0x0
801070bc:	68 c5 00 00 00       	push   $0xc5
801070c1:	e9 71 f1 ff ff       	jmp    80106237 <alltraps>

801070c6 <vector198>:
801070c6:	6a 00                	push   $0x0
801070c8:	68 c6 00 00 00       	push   $0xc6
801070cd:	e9 65 f1 ff ff       	jmp    80106237 <alltraps>

801070d2 <vector199>:
801070d2:	6a 00                	push   $0x0
801070d4:	68 c7 00 00 00       	push   $0xc7
801070d9:	e9 59 f1 ff ff       	jmp    80106237 <alltraps>

801070de <vector200>:
801070de:	6a 00                	push   $0x0
801070e0:	68 c8 00 00 00       	push   $0xc8
801070e5:	e9 4d f1 ff ff       	jmp    80106237 <alltraps>

801070ea <vector201>:
801070ea:	6a 00                	push   $0x0
801070ec:	68 c9 00 00 00       	push   $0xc9
801070f1:	e9 41 f1 ff ff       	jmp    80106237 <alltraps>

801070f6 <vector202>:
801070f6:	6a 00                	push   $0x0
801070f8:	68 ca 00 00 00       	push   $0xca
801070fd:	e9 35 f1 ff ff       	jmp    80106237 <alltraps>

80107102 <vector203>:
80107102:	6a 00                	push   $0x0
80107104:	68 cb 00 00 00       	push   $0xcb
80107109:	e9 29 f1 ff ff       	jmp    80106237 <alltraps>

8010710e <vector204>:
8010710e:	6a 00                	push   $0x0
80107110:	68 cc 00 00 00       	push   $0xcc
80107115:	e9 1d f1 ff ff       	jmp    80106237 <alltraps>

8010711a <vector205>:
8010711a:	6a 00                	push   $0x0
8010711c:	68 cd 00 00 00       	push   $0xcd
80107121:	e9 11 f1 ff ff       	jmp    80106237 <alltraps>

80107126 <vector206>:
80107126:	6a 00                	push   $0x0
80107128:	68 ce 00 00 00       	push   $0xce
8010712d:	e9 05 f1 ff ff       	jmp    80106237 <alltraps>

80107132 <vector207>:
80107132:	6a 00                	push   $0x0
80107134:	68 cf 00 00 00       	push   $0xcf
80107139:	e9 f9 f0 ff ff       	jmp    80106237 <alltraps>

8010713e <vector208>:
8010713e:	6a 00                	push   $0x0
80107140:	68 d0 00 00 00       	push   $0xd0
80107145:	e9 ed f0 ff ff       	jmp    80106237 <alltraps>

8010714a <vector209>:
8010714a:	6a 00                	push   $0x0
8010714c:	68 d1 00 00 00       	push   $0xd1
80107151:	e9 e1 f0 ff ff       	jmp    80106237 <alltraps>

80107156 <vector210>:
80107156:	6a 00                	push   $0x0
80107158:	68 d2 00 00 00       	push   $0xd2
8010715d:	e9 d5 f0 ff ff       	jmp    80106237 <alltraps>

80107162 <vector211>:
80107162:	6a 00                	push   $0x0
80107164:	68 d3 00 00 00       	push   $0xd3
80107169:	e9 c9 f0 ff ff       	jmp    80106237 <alltraps>

8010716e <vector212>:
8010716e:	6a 00                	push   $0x0
80107170:	68 d4 00 00 00       	push   $0xd4
80107175:	e9 bd f0 ff ff       	jmp    80106237 <alltraps>

8010717a <vector213>:
8010717a:	6a 00                	push   $0x0
8010717c:	68 d5 00 00 00       	push   $0xd5
80107181:	e9 b1 f0 ff ff       	jmp    80106237 <alltraps>

80107186 <vector214>:
80107186:	6a 00                	push   $0x0
80107188:	68 d6 00 00 00       	push   $0xd6
8010718d:	e9 a5 f0 ff ff       	jmp    80106237 <alltraps>

80107192 <vector215>:
80107192:	6a 00                	push   $0x0
80107194:	68 d7 00 00 00       	push   $0xd7
80107199:	e9 99 f0 ff ff       	jmp    80106237 <alltraps>

8010719e <vector216>:
8010719e:	6a 00                	push   $0x0
801071a0:	68 d8 00 00 00       	push   $0xd8
801071a5:	e9 8d f0 ff ff       	jmp    80106237 <alltraps>

801071aa <vector217>:
801071aa:	6a 00                	push   $0x0
801071ac:	68 d9 00 00 00       	push   $0xd9
801071b1:	e9 81 f0 ff ff       	jmp    80106237 <alltraps>

801071b6 <vector218>:
801071b6:	6a 00                	push   $0x0
801071b8:	68 da 00 00 00       	push   $0xda
801071bd:	e9 75 f0 ff ff       	jmp    80106237 <alltraps>

801071c2 <vector219>:
801071c2:	6a 00                	push   $0x0
801071c4:	68 db 00 00 00       	push   $0xdb
801071c9:	e9 69 f0 ff ff       	jmp    80106237 <alltraps>

801071ce <vector220>:
801071ce:	6a 00                	push   $0x0
801071d0:	68 dc 00 00 00       	push   $0xdc
801071d5:	e9 5d f0 ff ff       	jmp    80106237 <alltraps>

801071da <vector221>:
801071da:	6a 00                	push   $0x0
801071dc:	68 dd 00 00 00       	push   $0xdd
801071e1:	e9 51 f0 ff ff       	jmp    80106237 <alltraps>

801071e6 <vector222>:
801071e6:	6a 00                	push   $0x0
801071e8:	68 de 00 00 00       	push   $0xde
801071ed:	e9 45 f0 ff ff       	jmp    80106237 <alltraps>

801071f2 <vector223>:
801071f2:	6a 00                	push   $0x0
801071f4:	68 df 00 00 00       	push   $0xdf
801071f9:	e9 39 f0 ff ff       	jmp    80106237 <alltraps>

801071fe <vector224>:
801071fe:	6a 00                	push   $0x0
80107200:	68 e0 00 00 00       	push   $0xe0
80107205:	e9 2d f0 ff ff       	jmp    80106237 <alltraps>

8010720a <vector225>:
8010720a:	6a 00                	push   $0x0
8010720c:	68 e1 00 00 00       	push   $0xe1
80107211:	e9 21 f0 ff ff       	jmp    80106237 <alltraps>

80107216 <vector226>:
80107216:	6a 00                	push   $0x0
80107218:	68 e2 00 00 00       	push   $0xe2
8010721d:	e9 15 f0 ff ff       	jmp    80106237 <alltraps>

80107222 <vector227>:
80107222:	6a 00                	push   $0x0
80107224:	68 e3 00 00 00       	push   $0xe3
80107229:	e9 09 f0 ff ff       	jmp    80106237 <alltraps>

8010722e <vector228>:
8010722e:	6a 00                	push   $0x0
80107230:	68 e4 00 00 00       	push   $0xe4
80107235:	e9 fd ef ff ff       	jmp    80106237 <alltraps>

8010723a <vector229>:
8010723a:	6a 00                	push   $0x0
8010723c:	68 e5 00 00 00       	push   $0xe5
80107241:	e9 f1 ef ff ff       	jmp    80106237 <alltraps>

80107246 <vector230>:
80107246:	6a 00                	push   $0x0
80107248:	68 e6 00 00 00       	push   $0xe6
8010724d:	e9 e5 ef ff ff       	jmp    80106237 <alltraps>

80107252 <vector231>:
80107252:	6a 00                	push   $0x0
80107254:	68 e7 00 00 00       	push   $0xe7
80107259:	e9 d9 ef ff ff       	jmp    80106237 <alltraps>

8010725e <vector232>:
8010725e:	6a 00                	push   $0x0
80107260:	68 e8 00 00 00       	push   $0xe8
80107265:	e9 cd ef ff ff       	jmp    80106237 <alltraps>

8010726a <vector233>:
8010726a:	6a 00                	push   $0x0
8010726c:	68 e9 00 00 00       	push   $0xe9
80107271:	e9 c1 ef ff ff       	jmp    80106237 <alltraps>

80107276 <vector234>:
80107276:	6a 00                	push   $0x0
80107278:	68 ea 00 00 00       	push   $0xea
8010727d:	e9 b5 ef ff ff       	jmp    80106237 <alltraps>

80107282 <vector235>:
80107282:	6a 00                	push   $0x0
80107284:	68 eb 00 00 00       	push   $0xeb
80107289:	e9 a9 ef ff ff       	jmp    80106237 <alltraps>

8010728e <vector236>:
8010728e:	6a 00                	push   $0x0
80107290:	68 ec 00 00 00       	push   $0xec
80107295:	e9 9d ef ff ff       	jmp    80106237 <alltraps>

8010729a <vector237>:
8010729a:	6a 00                	push   $0x0
8010729c:	68 ed 00 00 00       	push   $0xed
801072a1:	e9 91 ef ff ff       	jmp    80106237 <alltraps>

801072a6 <vector238>:
801072a6:	6a 00                	push   $0x0
801072a8:	68 ee 00 00 00       	push   $0xee
801072ad:	e9 85 ef ff ff       	jmp    80106237 <alltraps>

801072b2 <vector239>:
801072b2:	6a 00                	push   $0x0
801072b4:	68 ef 00 00 00       	push   $0xef
801072b9:	e9 79 ef ff ff       	jmp    80106237 <alltraps>

801072be <vector240>:
801072be:	6a 00                	push   $0x0
801072c0:	68 f0 00 00 00       	push   $0xf0
801072c5:	e9 6d ef ff ff       	jmp    80106237 <alltraps>

801072ca <vector241>:
801072ca:	6a 00                	push   $0x0
801072cc:	68 f1 00 00 00       	push   $0xf1
801072d1:	e9 61 ef ff ff       	jmp    80106237 <alltraps>

801072d6 <vector242>:
801072d6:	6a 00                	push   $0x0
801072d8:	68 f2 00 00 00       	push   $0xf2
801072dd:	e9 55 ef ff ff       	jmp    80106237 <alltraps>

801072e2 <vector243>:
801072e2:	6a 00                	push   $0x0
801072e4:	68 f3 00 00 00       	push   $0xf3
801072e9:	e9 49 ef ff ff       	jmp    80106237 <alltraps>

801072ee <vector244>:
801072ee:	6a 00                	push   $0x0
801072f0:	68 f4 00 00 00       	push   $0xf4
801072f5:	e9 3d ef ff ff       	jmp    80106237 <alltraps>

801072fa <vector245>:
801072fa:	6a 00                	push   $0x0
801072fc:	68 f5 00 00 00       	push   $0xf5
80107301:	e9 31 ef ff ff       	jmp    80106237 <alltraps>

80107306 <vector246>:
80107306:	6a 00                	push   $0x0
80107308:	68 f6 00 00 00       	push   $0xf6
8010730d:	e9 25 ef ff ff       	jmp    80106237 <alltraps>

80107312 <vector247>:
80107312:	6a 00                	push   $0x0
80107314:	68 f7 00 00 00       	push   $0xf7
80107319:	e9 19 ef ff ff       	jmp    80106237 <alltraps>

8010731e <vector248>:
8010731e:	6a 00                	push   $0x0
80107320:	68 f8 00 00 00       	push   $0xf8
80107325:	e9 0d ef ff ff       	jmp    80106237 <alltraps>

8010732a <vector249>:
8010732a:	6a 00                	push   $0x0
8010732c:	68 f9 00 00 00       	push   $0xf9
80107331:	e9 01 ef ff ff       	jmp    80106237 <alltraps>

80107336 <vector250>:
80107336:	6a 00                	push   $0x0
80107338:	68 fa 00 00 00       	push   $0xfa
8010733d:	e9 f5 ee ff ff       	jmp    80106237 <alltraps>

80107342 <vector251>:
80107342:	6a 00                	push   $0x0
80107344:	68 fb 00 00 00       	push   $0xfb
80107349:	e9 e9 ee ff ff       	jmp    80106237 <alltraps>

8010734e <vector252>:
8010734e:	6a 00                	push   $0x0
80107350:	68 fc 00 00 00       	push   $0xfc
80107355:	e9 dd ee ff ff       	jmp    80106237 <alltraps>

8010735a <vector253>:
8010735a:	6a 00                	push   $0x0
8010735c:	68 fd 00 00 00       	push   $0xfd
80107361:	e9 d1 ee ff ff       	jmp    80106237 <alltraps>

80107366 <vector254>:
80107366:	6a 00                	push   $0x0
80107368:	68 fe 00 00 00       	push   $0xfe
8010736d:	e9 c5 ee ff ff       	jmp    80106237 <alltraps>

80107372 <vector255>:
80107372:	6a 00                	push   $0x0
80107374:	68 ff 00 00 00       	push   $0xff
80107379:	e9 b9 ee ff ff       	jmp    80106237 <alltraps>

8010737e <lgdt>:
{
8010737e:	55                   	push   %ebp
8010737f:	89 e5                	mov    %esp,%ebp
80107381:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107384:	8b 45 0c             	mov    0xc(%ebp),%eax
80107387:	48                   	dec    %eax
80107388:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010738c:	8b 45 08             	mov    0x8(%ebp),%eax
8010738f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107393:	8b 45 08             	mov    0x8(%ebp),%eax
80107396:	c1 e8 10             	shr    $0x10,%eax
80107399:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010739d:	8d 45 fa             	lea    -0x6(%ebp),%eax
801073a0:	0f 01 10             	lgdtl  (%eax)
}
801073a3:	c9                   	leave  
801073a4:	c3                   	ret    

801073a5 <ltr>:
{
801073a5:	55                   	push   %ebp
801073a6:	89 e5                	mov    %esp,%ebp
801073a8:	83 ec 04             	sub    $0x4,%esp
801073ab:	8b 45 08             	mov    0x8(%ebp),%eax
801073ae:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801073b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801073b5:	0f 00 d8             	ltr    %ax
}
801073b8:	c9                   	leave  
801073b9:	c3                   	ret    

801073ba <loadgs>:
{
801073ba:	55                   	push   %ebp
801073bb:	89 e5                	mov    %esp,%ebp
801073bd:	83 ec 04             	sub    $0x4,%esp
801073c0:	8b 45 08             	mov    0x8(%ebp),%eax
801073c3:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801073c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801073ca:	8e e8                	mov    %eax,%gs
}
801073cc:	c9                   	leave  
801073cd:	c3                   	ret    

801073ce <lcr3>:

static inline void
lcr3(uint val) 
{
801073ce:	55                   	push   %ebp
801073cf:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073d1:	8b 45 08             	mov    0x8(%ebp),%eax
801073d4:	0f 22 d8             	mov    %eax,%cr3
}
801073d7:	5d                   	pop    %ebp
801073d8:	c3                   	ret    

801073d9 <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801073d9:	55                   	push   %ebp
801073da:	89 e5                	mov    %esp,%ebp
801073dc:	8b 45 08             	mov    0x8(%ebp),%eax
801073df:	05 00 00 00 80       	add    $0x80000000,%eax
801073e4:	5d                   	pop    %ebp
801073e5:	c3                   	ret    

801073e6 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801073e6:	55                   	push   %ebp
801073e7:	89 e5                	mov    %esp,%ebp
801073e9:	8b 45 08             	mov    0x8(%ebp),%eax
801073ec:	05 00 00 00 80       	add    $0x80000000,%eax
801073f1:	5d                   	pop    %ebp
801073f2:	c3                   	ret    

801073f3 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801073f3:	55                   	push   %ebp
801073f4:	89 e5                	mov    %esp,%ebp
801073f6:	53                   	push   %ebx
801073f7:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801073fa:	e8 46 ba ff ff       	call   80102e45 <cpunum>
801073ff:	89 c2                	mov    %eax,%edx
80107401:	89 d0                	mov    %edx,%eax
80107403:	d1 e0                	shl    %eax
80107405:	01 d0                	add    %edx,%eax
80107407:	c1 e0 04             	shl    $0x4,%eax
8010740a:	29 d0                	sub    %edx,%eax
8010740c:	c1 e0 02             	shl    $0x2,%eax
8010740f:	05 20 f9 10 80       	add    $0x8010f920,%eax
80107414:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741a:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107423:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742c:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107433:	8a 50 7d             	mov    0x7d(%eax),%dl
80107436:	83 e2 f0             	and    $0xfffffff0,%edx
80107439:	83 ca 0a             	or     $0xa,%edx
8010743c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010743f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107442:	8a 50 7d             	mov    0x7d(%eax),%dl
80107445:	83 ca 10             	or     $0x10,%edx
80107448:	88 50 7d             	mov    %dl,0x7d(%eax)
8010744b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010744e:	8a 50 7d             	mov    0x7d(%eax),%dl
80107451:	83 e2 9f             	and    $0xffffff9f,%edx
80107454:	88 50 7d             	mov    %dl,0x7d(%eax)
80107457:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010745a:	8a 50 7d             	mov    0x7d(%eax),%dl
8010745d:	83 ca 80             	or     $0xffffff80,%edx
80107460:	88 50 7d             	mov    %dl,0x7d(%eax)
80107463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107466:	8a 50 7e             	mov    0x7e(%eax),%dl
80107469:	83 ca 0f             	or     $0xf,%edx
8010746c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010746f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107472:	8a 50 7e             	mov    0x7e(%eax),%dl
80107475:	83 e2 ef             	and    $0xffffffef,%edx
80107478:	88 50 7e             	mov    %dl,0x7e(%eax)
8010747b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010747e:	8a 50 7e             	mov    0x7e(%eax),%dl
80107481:	83 e2 df             	and    $0xffffffdf,%edx
80107484:	88 50 7e             	mov    %dl,0x7e(%eax)
80107487:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010748a:	8a 50 7e             	mov    0x7e(%eax),%dl
8010748d:	83 ca 40             	or     $0x40,%edx
80107490:	88 50 7e             	mov    %dl,0x7e(%eax)
80107493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107496:	8a 50 7e             	mov    0x7e(%eax),%dl
80107499:	83 ca 80             	or     $0xffffff80,%edx
8010749c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010749f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a2:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801074a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074a9:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801074b0:	ff ff 
801074b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074b5:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801074bc:	00 00 
801074be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c1:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801074c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074cb:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801074d1:	83 e2 f0             	and    $0xfffffff0,%edx
801074d4:	83 ca 02             	or     $0x2,%edx
801074d7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074e0:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801074e6:	83 ca 10             	or     $0x10,%edx
801074e9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801074ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074f2:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
801074f8:	83 e2 9f             	and    $0xffffff9f,%edx
801074fb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107501:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107504:	8a 90 85 00 00 00    	mov    0x85(%eax),%dl
8010750a:	83 ca 80             	or     $0xffffff80,%edx
8010750d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107516:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010751c:	83 ca 0f             	or     $0xf,%edx
8010751f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107525:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107528:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
8010752e:	83 e2 ef             	and    $0xffffffef,%edx
80107531:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753a:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107540:	83 e2 df             	and    $0xffffffdf,%edx
80107543:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107549:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754c:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107552:	83 ca 40             	or     $0x40,%edx
80107555:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010755b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010755e:	8a 90 86 00 00 00    	mov    0x86(%eax),%dl
80107564:	83 ca 80             	or     $0xffffff80,%edx
80107567:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010756d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107570:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107577:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010757a:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107581:	ff ff 
80107583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107586:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010758d:	00 00 
8010758f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107592:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107599:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759c:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801075a2:	83 e2 f0             	and    $0xfffffff0,%edx
801075a5:	83 ca 0a             	or     $0xa,%edx
801075a8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075b1:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801075b7:	83 ca 10             	or     $0x10,%edx
801075ba:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075c3:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801075c9:	83 ca 60             	or     $0x60,%edx
801075cc:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d5:	8a 90 95 00 00 00    	mov    0x95(%eax),%dl
801075db:	83 ca 80             	or     $0xffffff80,%edx
801075de:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801075e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e7:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801075ed:	83 ca 0f             	or     $0xf,%edx
801075f0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801075f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075f9:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
801075ff:	83 e2 ef             	and    $0xffffffef,%edx
80107602:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107608:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760b:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107611:	83 e2 df             	and    $0xffffffdf,%edx
80107614:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010761a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761d:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107623:	83 ca 40             	or     $0x40,%edx
80107626:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010762c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010762f:	8a 90 96 00 00 00    	mov    0x96(%eax),%dl
80107635:	83 ca 80             	or     $0xffffff80,%edx
80107638:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010763e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107641:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764b:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107652:	ff ff 
80107654:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107657:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010765e:	00 00 
80107660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107663:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010766a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010766d:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107673:	83 e2 f0             	and    $0xfffffff0,%edx
80107676:	83 ca 02             	or     $0x2,%edx
80107679:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010767f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107682:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80107688:	83 ca 10             	or     $0x10,%edx
8010768b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107694:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
8010769a:	83 ca 60             	or     $0x60,%edx
8010769d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076a6:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
801076ac:	83 ca 80             	or     $0xffffff80,%edx
801076af:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801076b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b8:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801076be:	83 ca 0f             	or     $0xf,%edx
801076c1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ca:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801076d0:	83 e2 ef             	and    $0xffffffef,%edx
801076d3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076dc:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801076e2:	83 e2 df             	and    $0xffffffdf,%edx
801076e5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
801076f4:	83 ca 40             	or     $0x40,%edx
801076f7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801076fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107700:	8a 90 9e 00 00 00    	mov    0x9e(%eax),%dl
80107706:	83 ca 80             	or     $0xffffff80,%edx
80107709:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010770f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107712:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107719:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771c:	05 b4 00 00 00       	add    $0xb4,%eax
80107721:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107724:	81 c2 b4 00 00 00    	add    $0xb4,%edx
8010772a:	c1 ea 10             	shr    $0x10,%edx
8010772d:	88 d1                	mov    %dl,%cl
8010772f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107732:	81 c2 b4 00 00 00    	add    $0xb4,%edx
80107738:	c1 ea 18             	shr    $0x18,%edx
8010773b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010773e:	66 c7 83 88 00 00 00 	movw   $0x0,0x88(%ebx)
80107745:	00 00 
80107747:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010774a:	66 89 83 8a 00 00 00 	mov    %ax,0x8a(%ebx)
80107751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107754:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
8010775a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010775d:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107763:	83 e1 f0             	and    $0xfffffff0,%ecx
80107766:	83 c9 02             	or     $0x2,%ecx
80107769:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
8010776f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107772:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
80107778:	83 c9 10             	or     $0x10,%ecx
8010777b:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107784:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010778a:	83 e1 9f             	and    $0xffffff9f,%ecx
8010778d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107796:	8a 88 8d 00 00 00    	mov    0x8d(%eax),%cl
8010779c:	83 c9 80             	or     $0xffffff80,%ecx
8010779f:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801077a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077a8:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801077ae:	83 e1 f0             	and    $0xfffffff0,%ecx
801077b1:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ba:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801077c0:	83 e1 ef             	and    $0xffffffef,%ecx
801077c3:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077cc:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801077d2:	83 e1 df             	and    $0xffffffdf,%ecx
801077d5:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077de:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801077e4:	83 c9 40             	or     $0x40,%ecx
801077e7:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f0:	8a 88 8e 00 00 00    	mov    0x8e(%eax),%cl
801077f6:	83 c9 80             	or     $0xffffff80,%ecx
801077f9:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
801077ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107802:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780b:	83 c0 70             	add    $0x70,%eax
8010780e:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107815:	00 
80107816:	89 04 24             	mov    %eax,(%esp)
80107819:	e8 60 fb ff ff       	call   8010737e <lgdt>
  loadgs(SEG_KCPU << 3);
8010781e:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107825:	e8 90 fb ff ff       	call   801073ba <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010782a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107833:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010783a:	00 00 00 00 
}
8010783e:	83 c4 24             	add    $0x24,%esp
80107841:	5b                   	pop    %ebx
80107842:	5d                   	pop    %ebp
80107843:	c3                   	ret    

80107844 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010784a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010784d:	c1 e8 16             	shr    $0x16,%eax
80107850:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107857:	8b 45 08             	mov    0x8(%ebp),%eax
8010785a:	01 d0                	add    %edx,%eax
8010785c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010785f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107862:	8b 00                	mov    (%eax),%eax
80107864:	83 e0 01             	and    $0x1,%eax
80107867:	85 c0                	test   %eax,%eax
80107869:	74 17                	je     80107882 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010786b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010786e:	8b 00                	mov    (%eax),%eax
80107870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107875:	89 04 24             	mov    %eax,(%esp)
80107878:	e8 69 fb ff ff       	call   801073e6 <p2v>
8010787d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107880:	eb 4b                	jmp    801078cd <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107882:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107886:	74 0e                	je     80107896 <walkpgdir+0x52>
80107888:	e8 31 b2 ff ff       	call   80102abe <kalloc>
8010788d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107894:	75 07                	jne    8010789d <walkpgdir+0x59>
      return 0;
80107896:	b8 00 00 00 00       	mov    $0x0,%eax
8010789b:	eb 47                	jmp    801078e4 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010789d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801078a4:	00 
801078a5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801078ac:	00 
801078ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b0:	89 04 24             	mov    %eax,(%esp)
801078b3:	e8 65 d4 ff ff       	call   80104d1d <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801078b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078bb:	89 04 24             	mov    %eax,(%esp)
801078be:	e8 16 fb ff ff       	call   801073d9 <v2p>
801078c3:	89 c2                	mov    %eax,%edx
801078c5:	83 ca 07             	or     $0x7,%edx
801078c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078cb:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801078cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801078d0:	c1 e8 0c             	shr    $0xc,%eax
801078d3:	25 ff 03 00 00       	and    $0x3ff,%eax
801078d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801078df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e2:	01 d0                	add    %edx,%eax
}
801078e4:	c9                   	leave  
801078e5:	c3                   	ret    

801078e6 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801078e6:	55                   	push   %ebp
801078e7:	89 e5                	mov    %esp,%ebp
801078e9:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801078ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801078f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801078f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801078fa:	8b 45 10             	mov    0x10(%ebp),%eax
801078fd:	01 d0                	add    %edx,%eax
801078ff:	48                   	dec    %eax
80107900:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107908:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010790f:	00 
80107910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107913:	89 44 24 04          	mov    %eax,0x4(%esp)
80107917:	8b 45 08             	mov    0x8(%ebp),%eax
8010791a:	89 04 24             	mov    %eax,(%esp)
8010791d:	e8 22 ff ff ff       	call   80107844 <walkpgdir>
80107922:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107925:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107929:	75 07                	jne    80107932 <mappages+0x4c>
      return -1;
8010792b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107930:	eb 46                	jmp    80107978 <mappages+0x92>
    if(*pte & PTE_P)
80107932:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107935:	8b 00                	mov    (%eax),%eax
80107937:	83 e0 01             	and    $0x1,%eax
8010793a:	85 c0                	test   %eax,%eax
8010793c:	74 0c                	je     8010794a <mappages+0x64>
      panic("remap");
8010793e:	c7 04 24 c0 87 10 80 	movl   $0x801087c0,(%esp)
80107945:	e8 ec 8b ff ff       	call   80100536 <panic>
    *pte = pa | perm | PTE_P;
8010794a:	8b 45 18             	mov    0x18(%ebp),%eax
8010794d:	0b 45 14             	or     0x14(%ebp),%eax
80107950:	89 c2                	mov    %eax,%edx
80107952:	83 ca 01             	or     $0x1,%edx
80107955:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107958:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010795a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010795d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107960:	74 10                	je     80107972 <mappages+0x8c>
      break;
    a += PGSIZE;
80107962:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107969:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107970:	eb 96                	jmp    80107908 <mappages+0x22>
      break;
80107972:	90                   	nop
  return 0;
80107973:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107978:	c9                   	leave  
80107979:	c3                   	ret    

8010797a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010797a:	55                   	push   %ebp
8010797b:	89 e5                	mov    %esp,%ebp
8010797d:	53                   	push   %ebx
8010797e:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107981:	e8 38 b1 ff ff       	call   80102abe <kalloc>
80107986:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107989:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010798d:	75 0a                	jne    80107999 <setupkvm+0x1f>
    return 0;
8010798f:	b8 00 00 00 00       	mov    $0x0,%eax
80107994:	e9 98 00 00 00       	jmp    80107a31 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107999:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801079a0:	00 
801079a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801079a8:	00 
801079a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ac:	89 04 24             	mov    %eax,(%esp)
801079af:	e8 69 d3 ff ff       	call   80104d1d <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801079b4:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
801079bb:	e8 26 fa ff ff       	call   801073e6 <p2v>
801079c0:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801079c5:	76 0c                	jbe    801079d3 <setupkvm+0x59>
    panic("PHYSTOP too high");
801079c7:	c7 04 24 c6 87 10 80 	movl   $0x801087c6,(%esp)
801079ce:	e8 63 8b ff ff       	call   80100536 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801079d3:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
801079da:	eb 49                	jmp    80107a25 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
801079dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801079df:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801079e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801079e5:	8b 50 04             	mov    0x4(%eax),%edx
801079e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079eb:	8b 58 08             	mov    0x8(%eax),%ebx
801079ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f1:	8b 40 04             	mov    0x4(%eax),%eax
801079f4:	29 c3                	sub    %eax,%ebx
801079f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f9:	8b 00                	mov    (%eax),%eax
801079fb:	89 4c 24 10          	mov    %ecx,0x10(%esp)
801079ff:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107a03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107a07:	89 44 24 04          	mov    %eax,0x4(%esp)
80107a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a0e:	89 04 24             	mov    %eax,(%esp)
80107a11:	e8 d0 fe ff ff       	call   801078e6 <mappages>
80107a16:	85 c0                	test   %eax,%eax
80107a18:	79 07                	jns    80107a21 <setupkvm+0xa7>
      return 0;
80107a1a:	b8 00 00 00 00       	mov    $0x0,%eax
80107a1f:	eb 10                	jmp    80107a31 <setupkvm+0xb7>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107a21:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107a25:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107a2c:	72 ae                	jb     801079dc <setupkvm+0x62>
  return pgdir;
80107a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107a31:	83 c4 34             	add    $0x34,%esp
80107a34:	5b                   	pop    %ebx
80107a35:	5d                   	pop    %ebp
80107a36:	c3                   	ret    

80107a37 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107a37:	55                   	push   %ebp
80107a38:	89 e5                	mov    %esp,%ebp
80107a3a:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107a3d:	e8 38 ff ff ff       	call   8010797a <setupkvm>
80107a42:	a3 f8 27 11 80       	mov    %eax,0x801127f8
  switchkvm();
80107a47:	e8 02 00 00 00       	call   80107a4e <switchkvm>
}
80107a4c:	c9                   	leave  
80107a4d:	c3                   	ret    

80107a4e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107a4e:	55                   	push   %ebp
80107a4f:	89 e5                	mov    %esp,%ebp
80107a51:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107a54:	a1 f8 27 11 80       	mov    0x801127f8,%eax
80107a59:	89 04 24             	mov    %eax,(%esp)
80107a5c:	e8 78 f9 ff ff       	call   801073d9 <v2p>
80107a61:	89 04 24             	mov    %eax,(%esp)
80107a64:	e8 65 f9 ff ff       	call   801073ce <lcr3>
}
80107a69:	c9                   	leave  
80107a6a:	c3                   	ret    

80107a6b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107a6b:	55                   	push   %ebp
80107a6c:	89 e5                	mov    %esp,%ebp
80107a6e:	53                   	push   %ebx
80107a6f:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107a72:	e8 a6 d1 ff ff       	call   80104c1d <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107a77:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107a7d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107a84:	83 c2 08             	add    $0x8,%edx
80107a87:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107a8e:	83 c1 08             	add    $0x8,%ecx
80107a91:	c1 e9 10             	shr    $0x10,%ecx
80107a94:	88 cb                	mov    %cl,%bl
80107a96:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80107a9d:	83 c1 08             	add    $0x8,%ecx
80107aa0:	c1 e9 18             	shr    $0x18,%ecx
80107aa3:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107aaa:	67 00 
80107aac:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80107ab3:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80107ab9:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107abf:	83 e2 f0             	and    $0xfffffff0,%edx
80107ac2:	83 ca 09             	or     $0x9,%edx
80107ac5:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107acb:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107ad1:	83 ca 10             	or     $0x10,%edx
80107ad4:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ada:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107ae0:	83 e2 9f             	and    $0xffffff9f,%edx
80107ae3:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107ae9:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107aef:	83 ca 80             	or     $0xffffff80,%edx
80107af2:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80107af8:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107afe:	83 e2 f0             	and    $0xfffffff0,%edx
80107b01:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b07:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b0d:	83 e2 ef             	and    $0xffffffef,%edx
80107b10:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b16:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b1c:	83 e2 df             	and    $0xffffffdf,%edx
80107b1f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b25:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b2b:	83 ca 40             	or     $0x40,%edx
80107b2e:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b34:	8a 90 a6 00 00 00    	mov    0xa6(%eax),%dl
80107b3a:	83 e2 7f             	and    $0x7f,%edx
80107b3d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80107b43:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107b49:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b4f:	8a 90 a5 00 00 00    	mov    0xa5(%eax),%dl
80107b55:	83 e2 ef             	and    $0xffffffef,%edx
80107b58:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107b5e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b64:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107b6a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b70:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107b77:	8b 52 08             	mov    0x8(%edx),%edx
80107b7a:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107b80:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107b83:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107b8a:	e8 16 f8 ff ff       	call   801073a5 <ltr>
  if(p->pgdir == 0)
80107b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b92:	8b 40 04             	mov    0x4(%eax),%eax
80107b95:	85 c0                	test   %eax,%eax
80107b97:	75 0c                	jne    80107ba5 <switchuvm+0x13a>
    panic("switchuvm: no pgdir");
80107b99:	c7 04 24 d7 87 10 80 	movl   $0x801087d7,(%esp)
80107ba0:	e8 91 89 ff ff       	call   80100536 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107ba5:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba8:	8b 40 04             	mov    0x4(%eax),%eax
80107bab:	89 04 24             	mov    %eax,(%esp)
80107bae:	e8 26 f8 ff ff       	call   801073d9 <v2p>
80107bb3:	89 04 24             	mov    %eax,(%esp)
80107bb6:	e8 13 f8 ff ff       	call   801073ce <lcr3>
  popcli();
80107bbb:	e8 a3 d0 ff ff       	call   80104c63 <popcli>
}
80107bc0:	83 c4 14             	add    $0x14,%esp
80107bc3:	5b                   	pop    %ebx
80107bc4:	5d                   	pop    %ebp
80107bc5:	c3                   	ret    

80107bc6 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107bc6:	55                   	push   %ebp
80107bc7:	89 e5                	mov    %esp,%ebp
80107bc9:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107bcc:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107bd3:	76 0c                	jbe    80107be1 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107bd5:	c7 04 24 eb 87 10 80 	movl   $0x801087eb,(%esp)
80107bdc:	e8 55 89 ff ff       	call   80100536 <panic>
  mem = kalloc();
80107be1:	e8 d8 ae ff ff       	call   80102abe <kalloc>
80107be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107be9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107bf0:	00 
80107bf1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107bf8:	00 
80107bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bfc:	89 04 24             	mov    %eax,(%esp)
80107bff:	e8 19 d1 ff ff       	call   80104d1d <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c07:	89 04 24             	mov    %eax,(%esp)
80107c0a:	e8 ca f7 ff ff       	call   801073d9 <v2p>
80107c0f:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107c16:	00 
80107c17:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107c1b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c22:	00 
80107c23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c2a:	00 
80107c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80107c2e:	89 04 24             	mov    %eax,(%esp)
80107c31:	e8 b0 fc ff ff       	call   801078e6 <mappages>
  memmove(mem, init, sz);
80107c36:	8b 45 10             	mov    0x10(%ebp),%eax
80107c39:	89 44 24 08          	mov    %eax,0x8(%esp)
80107c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c40:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c47:	89 04 24             	mov    %eax,(%esp)
80107c4a:	e8 9a d1 ff ff       	call   80104de9 <memmove>
}
80107c4f:	c9                   	leave  
80107c50:	c3                   	ret    

80107c51 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107c51:	55                   	push   %ebp
80107c52:	89 e5                	mov    %esp,%ebp
80107c54:	53                   	push   %ebx
80107c55:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c5b:	25 ff 0f 00 00       	and    $0xfff,%eax
80107c60:	85 c0                	test   %eax,%eax
80107c62:	74 0c                	je     80107c70 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80107c64:	c7 04 24 08 88 10 80 	movl   $0x80108808,(%esp)
80107c6b:	e8 c6 88 ff ff       	call   80100536 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107c70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107c77:	e9 ad 00 00 00       	jmp    80107d29 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107c82:	01 d0                	add    %edx,%eax
80107c84:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107c8b:	00 
80107c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c90:	8b 45 08             	mov    0x8(%ebp),%eax
80107c93:	89 04 24             	mov    %eax,(%esp)
80107c96:	e8 a9 fb ff ff       	call   80107844 <walkpgdir>
80107c9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c9e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ca2:	75 0c                	jne    80107cb0 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80107ca4:	c7 04 24 2b 88 10 80 	movl   $0x8010882b,(%esp)
80107cab:	e8 86 88 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80107cb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107cb3:	8b 00                	mov    (%eax),%eax
80107cb5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cba:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc0:	8b 55 18             	mov    0x18(%ebp),%edx
80107cc3:	89 d1                	mov    %edx,%ecx
80107cc5:	29 c1                	sub    %eax,%ecx
80107cc7:	89 c8                	mov    %ecx,%eax
80107cc9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107cce:	77 11                	ja     80107ce1 <loaduvm+0x90>
      n = sz - i;
80107cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd3:	8b 55 18             	mov    0x18(%ebp),%edx
80107cd6:	89 d1                	mov    %edx,%ecx
80107cd8:	29 c1                	sub    %eax,%ecx
80107cda:	89 c8                	mov    %ecx,%eax
80107cdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107cdf:	eb 07                	jmp    80107ce8 <loaduvm+0x97>
    else
      n = PGSIZE;
80107ce1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ceb:	8b 55 14             	mov    0x14(%ebp),%edx
80107cee:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80107cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cf4:	89 04 24             	mov    %eax,(%esp)
80107cf7:	e8 ea f6 ff ff       	call   801073e6 <p2v>
80107cfc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107cff:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107d03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107d07:	89 44 24 04          	mov    %eax,0x4(%esp)
80107d0b:	8b 45 10             	mov    0x10(%ebp),%eax
80107d0e:	89 04 24             	mov    %eax,(%esp)
80107d11:	e8 36 a0 ff ff       	call   80101d4c <readi>
80107d16:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d19:	74 07                	je     80107d22 <loaduvm+0xd1>
      return -1;
80107d1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d20:	eb 18                	jmp    80107d3a <loaduvm+0xe9>
  for(i = 0; i < sz; i += PGSIZE){
80107d22:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d2c:	3b 45 18             	cmp    0x18(%ebp),%eax
80107d2f:	0f 82 47 ff ff ff    	jb     80107c7c <loaduvm+0x2b>
  }
  return 0;
80107d35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d3a:	83 c4 24             	add    $0x24,%esp
80107d3d:	5b                   	pop    %ebx
80107d3e:	5d                   	pop    %ebp
80107d3f:	c3                   	ret    

80107d40 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107d40:	55                   	push   %ebp
80107d41:	89 e5                	mov    %esp,%ebp
80107d43:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80107d46:	8b 45 10             	mov    0x10(%ebp),%eax
80107d49:	85 c0                	test   %eax,%eax
80107d4b:	79 0a                	jns    80107d57 <allocuvm+0x17>
    return 0;
80107d4d:	b8 00 00 00 00       	mov    $0x0,%eax
80107d52:	e9 c1 00 00 00       	jmp    80107e18 <allocuvm+0xd8>
  if(newsz < oldsz)
80107d57:	8b 45 10             	mov    0x10(%ebp),%eax
80107d5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107d5d:	73 08                	jae    80107d67 <allocuvm+0x27>
    return oldsz;
80107d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d62:	e9 b1 00 00 00       	jmp    80107e18 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80107d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d6a:	05 ff 0f 00 00       	add    $0xfff,%eax
80107d6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80107d77:	e9 8d 00 00 00       	jmp    80107e09 <allocuvm+0xc9>
    mem = kalloc();
80107d7c:	e8 3d ad ff ff       	call   80102abe <kalloc>
80107d81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80107d84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d88:	75 2c                	jne    80107db6 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80107d8a:	c7 04 24 49 88 10 80 	movl   $0x80108849,(%esp)
80107d91:	e8 0b 86 ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107d96:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d99:	89 44 24 08          	mov    %eax,0x8(%esp)
80107d9d:	8b 45 10             	mov    0x10(%ebp),%eax
80107da0:	89 44 24 04          	mov    %eax,0x4(%esp)
80107da4:	8b 45 08             	mov    0x8(%ebp),%eax
80107da7:	89 04 24             	mov    %eax,(%esp)
80107daa:	e8 6b 00 00 00       	call   80107e1a <deallocuvm>
      return 0;
80107daf:	b8 00 00 00 00       	mov    $0x0,%eax
80107db4:	eb 62                	jmp    80107e18 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80107db6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107dbd:	00 
80107dbe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107dc5:	00 
80107dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dc9:	89 04 24             	mov    %eax,(%esp)
80107dcc:	e8 4c cf ff ff       	call   80104d1d <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107dd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dd4:	89 04 24             	mov    %eax,(%esp)
80107dd7:	e8 fd f5 ff ff       	call   801073d9 <v2p>
80107ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ddf:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107de6:	00 
80107de7:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107deb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107df2:	00 
80107df3:	89 54 24 04          	mov    %edx,0x4(%esp)
80107df7:	8b 45 08             	mov    0x8(%ebp),%eax
80107dfa:	89 04 24             	mov    %eax,(%esp)
80107dfd:	e8 e4 fa ff ff       	call   801078e6 <mappages>
  for(; a < newsz; a += PGSIZE){
80107e02:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e0c:	3b 45 10             	cmp    0x10(%ebp),%eax
80107e0f:	0f 82 67 ff ff ff    	jb     80107d7c <allocuvm+0x3c>
  }
  return newsz;
80107e15:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107e18:	c9                   	leave  
80107e19:	c3                   	ret    

80107e1a <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107e1a:	55                   	push   %ebp
80107e1b:	89 e5                	mov    %esp,%ebp
80107e1d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80107e20:	8b 45 10             	mov    0x10(%ebp),%eax
80107e23:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107e26:	72 08                	jb     80107e30 <deallocuvm+0x16>
    return oldsz;
80107e28:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e2b:	e9 a4 00 00 00       	jmp    80107ed4 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
80107e30:	8b 45 10             	mov    0x10(%ebp),%eax
80107e33:	05 ff 0f 00 00       	add    $0xfff,%eax
80107e38:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107e40:	e9 80 00 00 00       	jmp    80107ec5 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107e4f:	00 
80107e50:	89 44 24 04          	mov    %eax,0x4(%esp)
80107e54:	8b 45 08             	mov    0x8(%ebp),%eax
80107e57:	89 04 24             	mov    %eax,(%esp)
80107e5a:	e8 e5 f9 ff ff       	call   80107844 <walkpgdir>
80107e5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80107e62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107e66:	75 09                	jne    80107e71 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80107e68:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80107e6f:	eb 4d                	jmp    80107ebe <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80107e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e74:	8b 00                	mov    (%eax),%eax
80107e76:	83 e0 01             	and    $0x1,%eax
80107e79:	85 c0                	test   %eax,%eax
80107e7b:	74 41                	je     80107ebe <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
80107e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e80:	8b 00                	mov    (%eax),%eax
80107e82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80107e8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107e8e:	75 0c                	jne    80107e9c <deallocuvm+0x82>
        panic("kfree");
80107e90:	c7 04 24 61 88 10 80 	movl   $0x80108861,(%esp)
80107e97:	e8 9a 86 ff ff       	call   80100536 <panic>
      char *v = p2v(pa);
80107e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107e9f:	89 04 24             	mov    %eax,(%esp)
80107ea2:	e8 3f f5 ff ff       	call   801073e6 <p2v>
80107ea7:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80107eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ead:	89 04 24             	mov    %eax,(%esp)
80107eb0:	e8 70 ab ff ff       	call   80102a25 <kfree>
      *pte = 0;
80107eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80107ebe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80107ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80107ecb:	0f 82 74 ff ff ff    	jb     80107e45 <deallocuvm+0x2b>
    }
  }
  return newsz;
80107ed1:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107ed4:	c9                   	leave  
80107ed5:	c3                   	ret    

80107ed6 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ed6:	55                   	push   %ebp
80107ed7:	89 e5                	mov    %esp,%ebp
80107ed9:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80107edc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107ee0:	75 0c                	jne    80107eee <freevm+0x18>
    panic("freevm: no pgdir");
80107ee2:	c7 04 24 67 88 10 80 	movl   $0x80108867,(%esp)
80107ee9:	e8 48 86 ff ff       	call   80100536 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80107eee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107ef5:	00 
80107ef6:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80107efd:	80 
80107efe:	8b 45 08             	mov    0x8(%ebp),%eax
80107f01:	89 04 24             	mov    %eax,(%esp)
80107f04:	e8 11 ff ff ff       	call   80107e1a <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80107f09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f10:	eb 47                	jmp    80107f59 <freevm+0x83>
    if(pgdir[i] & PTE_P){
80107f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f1f:	01 d0                	add    %edx,%eax
80107f21:	8b 00                	mov    (%eax),%eax
80107f23:	83 e0 01             	and    $0x1,%eax
80107f26:	85 c0                	test   %eax,%eax
80107f28:	74 2c                	je     80107f56 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80107f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f34:	8b 45 08             	mov    0x8(%ebp),%eax
80107f37:	01 d0                	add    %edx,%eax
80107f39:	8b 00                	mov    (%eax),%eax
80107f3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f40:	89 04 24             	mov    %eax,(%esp)
80107f43:	e8 9e f4 ff ff       	call   801073e6 <p2v>
80107f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80107f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f4e:	89 04 24             	mov    %eax,(%esp)
80107f51:	e8 cf aa ff ff       	call   80102a25 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80107f56:	ff 45 f4             	incl   -0xc(%ebp)
80107f59:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80107f60:	76 b0                	jbe    80107f12 <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
80107f62:	8b 45 08             	mov    0x8(%ebp),%eax
80107f65:	89 04 24             	mov    %eax,(%esp)
80107f68:	e8 b8 aa ff ff       	call   80102a25 <kfree>
}
80107f6d:	c9                   	leave  
80107f6e:	c3                   	ret    

80107f6f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107f6f:	55                   	push   %ebp
80107f70:	89 e5                	mov    %esp,%ebp
80107f72:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107f75:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f7c:	00 
80107f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f80:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f84:	8b 45 08             	mov    0x8(%ebp),%eax
80107f87:	89 04 24             	mov    %eax,(%esp)
80107f8a:	e8 b5 f8 ff ff       	call   80107844 <walkpgdir>
80107f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80107f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f96:	75 0c                	jne    80107fa4 <clearpteu+0x35>
    panic("clearpteu");
80107f98:	c7 04 24 78 88 10 80 	movl   $0x80108878,(%esp)
80107f9f:	e8 92 85 ff ff       	call   80100536 <panic>
  *pte &= ~PTE_U;
80107fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa7:	8b 00                	mov    (%eax),%eax
80107fa9:	89 c2                	mov    %eax,%edx
80107fab:	83 e2 fb             	and    $0xfffffffb,%edx
80107fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb1:	89 10                	mov    %edx,(%eax)
}
80107fb3:	c9                   	leave  
80107fb4:	c3                   	ret    

80107fb5 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107fb5:	55                   	push   %ebp
80107fb6:	89 e5                	mov    %esp,%ebp
80107fb8:	53                   	push   %ebx
80107fb9:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107fbc:	e8 b9 f9 ff ff       	call   8010797a <setupkvm>
80107fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107fc8:	75 0a                	jne    80107fd4 <copyuvm+0x1f>
    return 0;
80107fca:	b8 00 00 00 00       	mov    $0x0,%eax
80107fcf:	e9 fd 00 00 00       	jmp    801080d1 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80107fd4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107fdb:	e9 cc 00 00 00       	jmp    801080ac <copyuvm+0xf7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107fea:	00 
80107feb:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fef:	8b 45 08             	mov    0x8(%ebp),%eax
80107ff2:	89 04 24             	mov    %eax,(%esp)
80107ff5:	e8 4a f8 ff ff       	call   80107844 <walkpgdir>
80107ffa:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ffd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108001:	75 0c                	jne    8010800f <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108003:	c7 04 24 82 88 10 80 	movl   $0x80108882,(%esp)
8010800a:	e8 27 85 ff ff       	call   80100536 <panic>
    if(!(*pte & PTE_P))
8010800f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108012:	8b 00                	mov    (%eax),%eax
80108014:	83 e0 01             	and    $0x1,%eax
80108017:	85 c0                	test   %eax,%eax
80108019:	75 0c                	jne    80108027 <copyuvm+0x72>
      panic("copyuvm: page not present");
8010801b:	c7 04 24 9c 88 10 80 	movl   $0x8010889c,(%esp)
80108022:	e8 0f 85 ff ff       	call   80100536 <panic>
    pa = PTE_ADDR(*pte);
80108027:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010802a:	8b 00                	mov    (%eax),%eax
8010802c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108031:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108034:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108037:	8b 00                	mov    (%eax),%eax
80108039:	25 ff 0f 00 00       	and    $0xfff,%eax
8010803e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108041:	e8 78 aa ff ff       	call   80102abe <kalloc>
80108046:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108049:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010804d:	74 6e                	je     801080bd <copyuvm+0x108>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010804f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108052:	89 04 24             	mov    %eax,(%esp)
80108055:	e8 8c f3 ff ff       	call   801073e6 <p2v>
8010805a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108061:	00 
80108062:	89 44 24 04          	mov    %eax,0x4(%esp)
80108066:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108069:	89 04 24             	mov    %eax,(%esp)
8010806c:	e8 78 cd ff ff       	call   80104de9 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108071:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108074:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108077:	89 04 24             	mov    %eax,(%esp)
8010807a:	e8 5a f3 ff ff       	call   801073d9 <v2p>
8010807f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108082:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108086:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010808a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108091:	00 
80108092:	89 54 24 04          	mov    %edx,0x4(%esp)
80108096:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108099:	89 04 24             	mov    %eax,(%esp)
8010809c:	e8 45 f8 ff ff       	call   801078e6 <mappages>
801080a1:	85 c0                	test   %eax,%eax
801080a3:	78 1b                	js     801080c0 <copyuvm+0x10b>
  for(i = 0; i < sz; i += PGSIZE){
801080a5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080af:	3b 45 0c             	cmp    0xc(%ebp),%eax
801080b2:	0f 82 28 ff ff ff    	jb     80107fe0 <copyuvm+0x2b>
      goto bad;
  }
  return d;
801080b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080bb:	eb 14                	jmp    801080d1 <copyuvm+0x11c>
      goto bad;
801080bd:	90                   	nop
801080be:	eb 01                	jmp    801080c1 <copyuvm+0x10c>
      goto bad;
801080c0:	90                   	nop

bad:
  freevm(d);
801080c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080c4:	89 04 24             	mov    %eax,(%esp)
801080c7:	e8 0a fe ff ff       	call   80107ed6 <freevm>
  return 0;
801080cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080d1:	83 c4 44             	add    $0x44,%esp
801080d4:	5b                   	pop    %ebx
801080d5:	5d                   	pop    %ebp
801080d6:	c3                   	ret    

801080d7 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801080d7:	55                   	push   %ebp
801080d8:	89 e5                	mov    %esp,%ebp
801080da:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801080e4:	00 
801080e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801080e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801080ec:	8b 45 08             	mov    0x8(%ebp),%eax
801080ef:	89 04 24             	mov    %eax,(%esp)
801080f2:	e8 4d f7 ff ff       	call   80107844 <walkpgdir>
801080f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
801080fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080fd:	8b 00                	mov    (%eax),%eax
801080ff:	83 e0 01             	and    $0x1,%eax
80108102:	85 c0                	test   %eax,%eax
80108104:	75 07                	jne    8010810d <uva2ka+0x36>
    return 0;
80108106:	b8 00 00 00 00       	mov    $0x0,%eax
8010810b:	eb 25                	jmp    80108132 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
8010810d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108110:	8b 00                	mov    (%eax),%eax
80108112:	83 e0 04             	and    $0x4,%eax
80108115:	85 c0                	test   %eax,%eax
80108117:	75 07                	jne    80108120 <uva2ka+0x49>
    return 0;
80108119:	b8 00 00 00 00       	mov    $0x0,%eax
8010811e:	eb 12                	jmp    80108132 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108120:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108123:	8b 00                	mov    (%eax),%eax
80108125:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010812a:	89 04 24             	mov    %eax,(%esp)
8010812d:	e8 b4 f2 ff ff       	call   801073e6 <p2v>
}
80108132:	c9                   	leave  
80108133:	c3                   	ret    

80108134 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108134:	55                   	push   %ebp
80108135:	89 e5                	mov    %esp,%ebp
80108137:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010813a:	8b 45 10             	mov    0x10(%ebp),%eax
8010813d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108140:	e9 89 00 00 00       	jmp    801081ce <copyout+0x9a>
    va0 = (uint)PGROUNDDOWN(va);
80108145:	8b 45 0c             	mov    0xc(%ebp),%eax
80108148:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010814d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108150:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108153:	89 44 24 04          	mov    %eax,0x4(%esp)
80108157:	8b 45 08             	mov    0x8(%ebp),%eax
8010815a:	89 04 24             	mov    %eax,(%esp)
8010815d:	e8 75 ff ff ff       	call   801080d7 <uva2ka>
80108162:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108165:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108169:	75 07                	jne    80108172 <copyout+0x3e>
      return -1;
8010816b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108170:	eb 6b                	jmp    801081dd <copyout+0xa9>
    n = PGSIZE - (va - va0);
80108172:	8b 45 0c             	mov    0xc(%ebp),%eax
80108175:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108178:	89 d1                	mov    %edx,%ecx
8010817a:	29 c1                	sub    %eax,%ecx
8010817c:	89 c8                	mov    %ecx,%eax
8010817e:	05 00 10 00 00       	add    $0x1000,%eax
80108183:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108186:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108189:	3b 45 14             	cmp    0x14(%ebp),%eax
8010818c:	76 06                	jbe    80108194 <copyout+0x60>
      n = len;
8010818e:	8b 45 14             	mov    0x14(%ebp),%eax
80108191:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108194:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108197:	8b 55 0c             	mov    0xc(%ebp),%edx
8010819a:	29 c2                	sub    %eax,%edx
8010819c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010819f:	01 c2                	add    %eax,%edx
801081a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081a4:	89 44 24 08          	mov    %eax,0x8(%esp)
801081a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801081af:	89 14 24             	mov    %edx,(%esp)
801081b2:	e8 32 cc ff ff       	call   80104de9 <memmove>
    len -= n;
801081b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081ba:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801081bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081c0:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801081c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081c6:	05 00 10 00 00       	add    $0x1000,%eax
801081cb:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801081ce:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801081d2:	0f 85 6d ff ff ff    	jne    80108145 <copyout+0x11>
  }
  return 0;
801081d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081dd:	c9                   	leave  
801081de:	c3                   	ret    
