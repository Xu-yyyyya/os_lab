
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 90 11 00       	mov    $0x119000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 90 11 c0       	mov    %eax,0xc0119000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 18             	sub    $0x18,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	83 ec 04             	sub    $0x4,%esp
c0100049:	50                   	push   %eax
c010004a:	6a 00                	push   $0x0
c010004c:	68 00 b0 11 c0       	push   $0xc011b000
c0100051:	e8 b6 58 00 00       	call   c010590c <memset>
c0100056:	83 c4 10             	add    $0x10,%esp

    cons_init();                // init the console
c0100059:	e8 83 15 00 00       	call   c01015e1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005e:	c7 45 f4 a0 5a 10 c0 	movl   $0xc0105aa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100065:	83 ec 08             	sub    $0x8,%esp
c0100068:	ff 75 f4             	push   -0xc(%ebp)
c010006b:	68 bc 5a 10 c0       	push   $0xc0105abc
c0100070:	e8 bc 02 00 00       	call   c0100331 <cprintf>
c0100075:	83 c4 10             	add    $0x10,%esp

    print_kerninfo();
c0100078:	e8 b2 07 00 00       	call   c010082f <print_kerninfo>

    grade_backtrace();
c010007d:	e8 74 00 00 00       	call   c01000f6 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100082:	e8 a8 40 00 00       	call   c010412f <pmm_init>

    pic_init();                 // init interrupt controller
c0100087:	e8 d9 16 00 00       	call   c0101765 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008c:	e8 5b 18 00 00       	call   c01018ec <idt_init>

    clock_init();               // init clock interrupt
c0100091:	e8 ce 0c 00 00       	call   c0100d64 <clock_init>
    intr_enable();              // enable irq interrupt
c0100096:	e8 32 16 00 00       	call   c01016cd <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009b:	eb fe                	jmp    c010009b <kern_init+0x65>

c010009d <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009d:	55                   	push   %ebp
c010009e:	89 e5                	mov    %esp,%ebp
c01000a0:	83 ec 08             	sub    $0x8,%esp
    mon_backtrace(0, NULL, NULL);
c01000a3:	83 ec 04             	sub    $0x4,%esp
c01000a6:	6a 00                	push   $0x0
c01000a8:	6a 00                	push   $0x0
c01000aa:	6a 00                	push   $0x0
c01000ac:	e8 cd 0b 00 00       	call   c0100c7e <mon_backtrace>
c01000b1:	83 c4 10             	add    $0x10,%esp
}
c01000b4:	90                   	nop
c01000b5:	c9                   	leave  
c01000b6:	c3                   	ret    

c01000b7 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000b7:	55                   	push   %ebp
c01000b8:	89 e5                	mov    %esp,%ebp
c01000ba:	53                   	push   %ebx
c01000bb:	83 ec 04             	sub    $0x4,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000be:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000c1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000c4:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ca:	51                   	push   %ecx
c01000cb:	52                   	push   %edx
c01000cc:	53                   	push   %ebx
c01000cd:	50                   	push   %eax
c01000ce:	e8 ca ff ff ff       	call   c010009d <grade_backtrace2>
c01000d3:	83 c4 10             	add    $0x10,%esp
}
c01000d6:	90                   	nop
c01000d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000da:	c9                   	leave  
c01000db:	c3                   	ret    

c01000dc <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000dc:	55                   	push   %ebp
c01000dd:	89 e5                	mov    %esp,%ebp
c01000df:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace1(arg0, arg2);
c01000e2:	83 ec 08             	sub    $0x8,%esp
c01000e5:	ff 75 10             	push   0x10(%ebp)
c01000e8:	ff 75 08             	push   0x8(%ebp)
c01000eb:	e8 c7 ff ff ff       	call   c01000b7 <grade_backtrace1>
c01000f0:	83 c4 10             	add    $0x10,%esp
}
c01000f3:	90                   	nop
c01000f4:	c9                   	leave  
c01000f5:	c3                   	ret    

c01000f6 <grade_backtrace>:

void
grade_backtrace(void) {
c01000f6:	55                   	push   %ebp
c01000f7:	89 e5                	mov    %esp,%ebp
c01000f9:	83 ec 08             	sub    $0x8,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c01000fc:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100101:	83 ec 04             	sub    $0x4,%esp
c0100104:	68 00 00 ff ff       	push   $0xffff0000
c0100109:	50                   	push   %eax
c010010a:	6a 00                	push   $0x0
c010010c:	e8 cb ff ff ff       	call   c01000dc <grade_backtrace0>
c0100111:	83 c4 10             	add    $0x10,%esp
}
c0100114:	90                   	nop
c0100115:	c9                   	leave  
c0100116:	c3                   	ret    

c0100117 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010011d:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100120:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100123:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100126:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100129:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010012d:	0f b7 c0             	movzwl %ax,%eax
c0100130:	83 e0 03             	and    $0x3,%eax
c0100133:	89 c2                	mov    %eax,%edx
c0100135:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010013a:	83 ec 04             	sub    $0x4,%esp
c010013d:	52                   	push   %edx
c010013e:	50                   	push   %eax
c010013f:	68 c1 5a 10 c0       	push   $0xc0105ac1
c0100144:	e8 e8 01 00 00       	call   c0100331 <cprintf>
c0100149:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  cs = %x\n", round, reg1);
c010014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100150:	0f b7 d0             	movzwl %ax,%edx
c0100153:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100158:	83 ec 04             	sub    $0x4,%esp
c010015b:	52                   	push   %edx
c010015c:	50                   	push   %eax
c010015d:	68 cf 5a 10 c0       	push   $0xc0105acf
c0100162:	e8 ca 01 00 00       	call   c0100331 <cprintf>
c0100167:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ds = %x\n", round, reg2);
c010016a:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010016e:	0f b7 d0             	movzwl %ax,%edx
c0100171:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100176:	83 ec 04             	sub    $0x4,%esp
c0100179:	52                   	push   %edx
c010017a:	50                   	push   %eax
c010017b:	68 dd 5a 10 c0       	push   $0xc0105add
c0100180:	e8 ac 01 00 00       	call   c0100331 <cprintf>
c0100185:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  es = %x\n", round, reg3);
c0100188:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c010018c:	0f b7 d0             	movzwl %ax,%edx
c010018f:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c0100194:	83 ec 04             	sub    $0x4,%esp
c0100197:	52                   	push   %edx
c0100198:	50                   	push   %eax
c0100199:	68 eb 5a 10 c0       	push   $0xc0105aeb
c010019e:	e8 8e 01 00 00       	call   c0100331 <cprintf>
c01001a3:	83 c4 10             	add    $0x10,%esp
    cprintf("%d:  ss = %x\n", round, reg4);
c01001a6:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001aa:	0f b7 d0             	movzwl %ax,%edx
c01001ad:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001b2:	83 ec 04             	sub    $0x4,%esp
c01001b5:	52                   	push   %edx
c01001b6:	50                   	push   %eax
c01001b7:	68 f9 5a 10 c0       	push   $0xc0105af9
c01001bc:	e8 70 01 00 00       	call   c0100331 <cprintf>
c01001c1:	83 c4 10             	add    $0x10,%esp
    round ++;
c01001c4:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001c9:	83 c0 01             	add    $0x1,%eax
c01001cc:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
}
c01001d1:	90                   	nop
c01001d2:	c9                   	leave  
c01001d3:	c3                   	ret    

c01001d4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001d4:	55                   	push   %ebp
c01001d5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001d7:	90                   	nop
c01001d8:	5d                   	pop    %ebp
c01001d9:	c3                   	ret    

c01001da <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001da:	55                   	push   %ebp
c01001db:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001dd:	90                   	nop
c01001de:	5d                   	pop    %ebp
c01001df:	c3                   	ret    

c01001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001e0:	55                   	push   %ebp
c01001e1:	89 e5                	mov    %esp,%ebp
c01001e3:	83 ec 08             	sub    $0x8,%esp
    lab1_print_cur_status();
c01001e6:	e8 2c ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c01001eb:	83 ec 0c             	sub    $0xc,%esp
c01001ee:	68 08 5b 10 c0       	push   $0xc0105b08
c01001f3:	e8 39 01 00 00       	call   c0100331 <cprintf>
c01001f8:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_user();
c01001fb:	e8 d4 ff ff ff       	call   c01001d4 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100200:	e8 12 ff ff ff       	call   c0100117 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100205:	83 ec 0c             	sub    $0xc,%esp
c0100208:	68 28 5b 10 c0       	push   $0xc0105b28
c010020d:	e8 1f 01 00 00       	call   c0100331 <cprintf>
c0100212:	83 c4 10             	add    $0x10,%esp
    lab1_switch_to_kernel();
c0100215:	e8 c0 ff ff ff       	call   c01001da <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010021a:	e8 f8 fe ff ff       	call   c0100117 <lab1_print_cur_status>
}
c010021f:	90                   	nop
c0100220:	c9                   	leave  
c0100221:	c3                   	ret    

c0100222 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100222:	55                   	push   %ebp
c0100223:	89 e5                	mov    %esp,%ebp
c0100225:	83 ec 18             	sub    $0x18,%esp
    if (prompt != NULL) {
c0100228:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010022c:	74 13                	je     c0100241 <readline+0x1f>
        cprintf("%s", prompt);
c010022e:	83 ec 08             	sub    $0x8,%esp
c0100231:	ff 75 08             	push   0x8(%ebp)
c0100234:	68 47 5b 10 c0       	push   $0xc0105b47
c0100239:	e8 f3 00 00 00       	call   c0100331 <cprintf>
c010023e:	83 c4 10             	add    $0x10,%esp
    }
    int i = 0, c;
c0100241:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100248:	e8 6f 01 00 00       	call   c01003bc <getchar>
c010024d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100254:	79 0a                	jns    c0100260 <readline+0x3e>
            return NULL;
c0100256:	b8 00 00 00 00       	mov    $0x0,%eax
c010025b:	e9 82 00 00 00       	jmp    c01002e2 <readline+0xc0>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100260:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100264:	7e 2b                	jle    c0100291 <readline+0x6f>
c0100266:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010026d:	7f 22                	jg     c0100291 <readline+0x6f>
            cputchar(c);
c010026f:	83 ec 0c             	sub    $0xc,%esp
c0100272:	ff 75 f0             	push   -0x10(%ebp)
c0100275:	e8 dd 00 00 00       	call   c0100357 <cputchar>
c010027a:	83 c4 10             	add    $0x10,%esp
            buf[i ++] = c;
c010027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100280:	8d 50 01             	lea    0x1(%eax),%edx
c0100283:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100286:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100289:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
c010028f:	eb 4c                	jmp    c01002dd <readline+0xbb>
        }
        else if (c == '\b' && i > 0) {
c0100291:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c0100295:	75 1a                	jne    c01002b1 <readline+0x8f>
c0100297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010029b:	7e 14                	jle    c01002b1 <readline+0x8f>
            cputchar(c);
c010029d:	83 ec 0c             	sub    $0xc,%esp
c01002a0:	ff 75 f0             	push   -0x10(%ebp)
c01002a3:	e8 af 00 00 00       	call   c0100357 <cputchar>
c01002a8:	83 c4 10             	add    $0x10,%esp
            i --;
c01002ab:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002af:	eb 2c                	jmp    c01002dd <readline+0xbb>
        }
        else if (c == '\n' || c == '\r') {
c01002b1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002b5:	74 06                	je     c01002bd <readline+0x9b>
c01002b7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002bb:	75 8b                	jne    c0100248 <readline+0x26>
            cputchar(c);
c01002bd:	83 ec 0c             	sub    $0xc,%esp
c01002c0:	ff 75 f0             	push   -0x10(%ebp)
c01002c3:	e8 8f 00 00 00       	call   c0100357 <cputchar>
c01002c8:	83 c4 10             	add    $0x10,%esp
            buf[i] = '\0';
c01002cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ce:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002d3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002d6:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
c01002db:	eb 05                	jmp    c01002e2 <readline+0xc0>
        c = getchar();
c01002dd:	e9 66 ff ff ff       	jmp    c0100248 <readline+0x26>
        }
    }
}
c01002e2:	c9                   	leave  
c01002e3:	c3                   	ret    

c01002e4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e4:	55                   	push   %ebp
c01002e5:	89 e5                	mov    %esp,%ebp
c01002e7:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c01002ea:	83 ec 0c             	sub    $0xc,%esp
c01002ed:	ff 75 08             	push   0x8(%ebp)
c01002f0:	e8 1d 13 00 00       	call   c0101612 <cons_putc>
c01002f5:	83 c4 10             	add    $0x10,%esp
    (*cnt) ++;
c01002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fb:	8b 00                	mov    (%eax),%eax
c01002fd:	8d 50 01             	lea    0x1(%eax),%edx
c0100300:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100303:	89 10                	mov    %edx,(%eax)
}
c0100305:	90                   	nop
c0100306:	c9                   	leave  
c0100307:	c3                   	ret    

c0100308 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100308:	55                   	push   %ebp
c0100309:	89 e5                	mov    %esp,%ebp
c010030b:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c010030e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100315:	ff 75 0c             	push   0xc(%ebp)
c0100318:	ff 75 08             	push   0x8(%ebp)
c010031b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010031e:	50                   	push   %eax
c010031f:	68 e4 02 10 c0       	push   $0xc01002e4
c0100324:	e8 53 4e 00 00       	call   c010517c <vprintfmt>
c0100329:	83 c4 10             	add    $0x10,%esp
    return cnt;
c010032c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010032f:	c9                   	leave  
c0100330:	c3                   	ret    

c0100331 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100331:	55                   	push   %ebp
c0100332:	89 e5                	mov    %esp,%ebp
c0100334:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100337:	8d 45 0c             	lea    0xc(%ebp),%eax
c010033a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010033d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100340:	83 ec 08             	sub    $0x8,%esp
c0100343:	50                   	push   %eax
c0100344:	ff 75 08             	push   0x8(%ebp)
c0100347:	e8 bc ff ff ff       	call   c0100308 <vcprintf>
c010034c:	83 c4 10             	add    $0x10,%esp
c010034f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100355:	c9                   	leave  
c0100356:	c3                   	ret    

c0100357 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100357:	55                   	push   %ebp
c0100358:	89 e5                	mov    %esp,%ebp
c010035a:	83 ec 08             	sub    $0x8,%esp
    cons_putc(c);
c010035d:	83 ec 0c             	sub    $0xc,%esp
c0100360:	ff 75 08             	push   0x8(%ebp)
c0100363:	e8 aa 12 00 00       	call   c0101612 <cons_putc>
c0100368:	83 c4 10             	add    $0x10,%esp
}
c010036b:	90                   	nop
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    int cnt = 0;
c0100374:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010037b:	eb 14                	jmp    c0100391 <cputs+0x23>
        cputch(c, &cnt);
c010037d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100381:	83 ec 08             	sub    $0x8,%esp
c0100384:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100387:	52                   	push   %edx
c0100388:	50                   	push   %eax
c0100389:	e8 56 ff ff ff       	call   c01002e4 <cputch>
c010038e:	83 c4 10             	add    $0x10,%esp
    while ((c = *str ++) != '\0') {
c0100391:	8b 45 08             	mov    0x8(%ebp),%eax
c0100394:	8d 50 01             	lea    0x1(%eax),%edx
c0100397:	89 55 08             	mov    %edx,0x8(%ebp)
c010039a:	0f b6 00             	movzbl (%eax),%eax
c010039d:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a0:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003a4:	75 d7                	jne    c010037d <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003a6:	83 ec 08             	sub    $0x8,%esp
c01003a9:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ac:	50                   	push   %eax
c01003ad:	6a 0a                	push   $0xa
c01003af:	e8 30 ff ff ff       	call   c01002e4 <cputch>
c01003b4:	83 c4 10             	add    $0x10,%esp
    return cnt;
c01003b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ba:	c9                   	leave  
c01003bb:	c3                   	ret    

c01003bc <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003bc:	55                   	push   %ebp
c01003bd:	89 e5                	mov    %esp,%ebp
c01003bf:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003c2:	90                   	nop
c01003c3:	e8 93 12 00 00       	call   c010165b <cons_getc>
c01003c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003cf:	74 f2                	je     c01003c3 <getchar+0x7>
        /* do nothing */;
    return c;
c01003d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003d4:	c9                   	leave  
c01003d5:	c3                   	ret    

c01003d6 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003d6:	55                   	push   %ebp
c01003d7:	89 e5                	mov    %esp,%ebp
c01003d9:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003df:	8b 00                	mov    (%eax),%eax
c01003e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01003e7:	8b 00                	mov    (%eax),%eax
c01003e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003f3:	e9 d2 00 00 00       	jmp    c01004ca <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01003fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01003fe:	01 d0                	add    %edx,%eax
c0100400:	89 c2                	mov    %eax,%edx
c0100402:	c1 ea 1f             	shr    $0x1f,%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	d1 f8                	sar    %eax
c0100409:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010040c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010040f:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100412:	eb 04                	jmp    c0100418 <stab_binsearch+0x42>
            m --;
c0100414:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100418:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010041b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010041e:	7c 1f                	jl     c010043f <stab_binsearch+0x69>
c0100420:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100423:	89 d0                	mov    %edx,%eax
c0100425:	01 c0                	add    %eax,%eax
c0100427:	01 d0                	add    %edx,%eax
c0100429:	c1 e0 02             	shl    $0x2,%eax
c010042c:	89 c2                	mov    %eax,%edx
c010042e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100431:	01 d0                	add    %edx,%eax
c0100433:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100437:	0f b6 c0             	movzbl %al,%eax
c010043a:	39 45 14             	cmp    %eax,0x14(%ebp)
c010043d:	75 d5                	jne    c0100414 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010043f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100442:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100445:	7d 0b                	jge    c0100452 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100447:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010044a:	83 c0 01             	add    $0x1,%eax
c010044d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100450:	eb 78                	jmp    c01004ca <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100452:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010045c:	89 d0                	mov    %edx,%eax
c010045e:	01 c0                	add    %eax,%eax
c0100460:	01 d0                	add    %edx,%eax
c0100462:	c1 e0 02             	shl    $0x2,%eax
c0100465:	89 c2                	mov    %eax,%edx
c0100467:	8b 45 08             	mov    0x8(%ebp),%eax
c010046a:	01 d0                	add    %edx,%eax
c010046c:	8b 40 08             	mov    0x8(%eax),%eax
c010046f:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100472:	76 13                	jbe    c0100487 <stab_binsearch+0xb1>
            *region_left = m;
c0100474:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010047c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010047f:	83 c0 01             	add    $0x1,%eax
c0100482:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100485:	eb 43                	jmp    c01004ca <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100487:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048a:	89 d0                	mov    %edx,%eax
c010048c:	01 c0                	add    %eax,%eax
c010048e:	01 d0                	add    %edx,%eax
c0100490:	c1 e0 02             	shl    $0x2,%eax
c0100493:	89 c2                	mov    %eax,%edx
c0100495:	8b 45 08             	mov    0x8(%ebp),%eax
c0100498:	01 d0                	add    %edx,%eax
c010049a:	8b 40 08             	mov    0x8(%eax),%eax
c010049d:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004a0:	73 16                	jae    c01004b8 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004a5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ab:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b0:	83 e8 01             	sub    $0x1,%eax
c01004b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004b6:	eb 12                	jmp    c01004ca <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004be:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004c6:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01004ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d0:	0f 8e 22 ff ff ff    	jle    c01003f8 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004da:	75 0f                	jne    c01004eb <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004df:	8b 00                	mov    (%eax),%eax
c01004e1:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01004e7:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01004e9:	eb 3f                	jmp    c010052a <stab_binsearch+0x154>
        l = *region_right;
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	8b 00                	mov    (%eax),%eax
c01004f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004f3:	eb 04                	jmp    c01004f9 <stab_binsearch+0x123>
c01004f5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01004f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fc:	8b 00                	mov    (%eax),%eax
c01004fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100501:	7e 1f                	jle    c0100522 <stab_binsearch+0x14c>
c0100503:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100506:	89 d0                	mov    %edx,%eax
c0100508:	01 c0                	add    %eax,%eax
c010050a:	01 d0                	add    %edx,%eax
c010050c:	c1 e0 02             	shl    $0x2,%eax
c010050f:	89 c2                	mov    %eax,%edx
c0100511:	8b 45 08             	mov    0x8(%ebp),%eax
c0100514:	01 d0                	add    %edx,%eax
c0100516:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010051a:	0f b6 c0             	movzbl %al,%eax
c010051d:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100520:	75 d3                	jne    c01004f5 <stab_binsearch+0x11f>
        *region_left = l;
c0100522:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 10                	mov    %edx,(%eax)
}
c010052a:	90                   	nop
c010052b:	c9                   	leave  
c010052c:	c3                   	ret    

c010052d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010052d:	55                   	push   %ebp
c010052e:	89 e5                	mov    %esp,%ebp
c0100530:	83 ec 38             	sub    $0x38,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100533:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100536:	c7 00 4c 5b 10 c0    	movl   $0xc0105b4c,(%eax)
    info->eip_line = 0;
c010053c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100549:	c7 40 08 4c 5b 10 c0 	movl   $0xc0105b4c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010055a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055d:	8b 55 08             	mov    0x8(%ebp),%edx
c0100560:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010056d:	c7 45 f4 e0 6d 10 c0 	movl   $0xc0106de0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100574:	c7 45 f0 88 25 11 c0 	movl   $0xc0112588,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010057b:	c7 45 ec 89 25 11 c0 	movl   $0xc0112589,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100582:	c7 45 e8 21 5b 11 c0 	movl   $0xc0115b21,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100589:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010058c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010058f:	76 0d                	jbe    c010059e <debuginfo_eip+0x71>
c0100591:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100594:	83 e8 01             	sub    $0x1,%eax
c0100597:	0f b6 00             	movzbl (%eax),%eax
c010059a:	84 c0                	test   %al,%al
c010059c:	74 0a                	je     c01005a8 <debuginfo_eip+0x7b>
        return -1;
c010059e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a3:	e9 85 02 00 00       	jmp    c010082d <debuginfo_eip+0x300>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005b2:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005b5:	c1 f8 02             	sar    $0x2,%eax
c01005b8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005be:	83 e8 01             	sub    $0x1,%eax
c01005c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005c4:	ff 75 08             	push   0x8(%ebp)
c01005c7:	6a 64                	push   $0x64
c01005c9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005cc:	50                   	push   %eax
c01005cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005d0:	50                   	push   %eax
c01005d1:	ff 75 f4             	push   -0xc(%ebp)
c01005d4:	e8 fd fd ff ff       	call   c01003d6 <stab_binsearch>
c01005d9:	83 c4 14             	add    $0x14,%esp
    if (lfile == 0)
c01005dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005df:	85 c0                	test   %eax,%eax
c01005e1:	75 0a                	jne    c01005ed <debuginfo_eip+0xc0>
        return -1;
c01005e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005e8:	e9 40 02 00 00       	jmp    c010082d <debuginfo_eip+0x300>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01005f9:	ff 75 08             	push   0x8(%ebp)
c01005fc:	6a 24                	push   $0x24
c01005fe:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100601:	50                   	push   %eax
c0100602:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100605:	50                   	push   %eax
c0100606:	ff 75 f4             	push   -0xc(%ebp)
c0100609:	e8 c8 fd ff ff       	call   c01003d6 <stab_binsearch>
c010060e:	83 c4 14             	add    $0x14,%esp

    if (lfun <= rfun) {
c0100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100617:	39 c2                	cmp    %eax,%edx
c0100619:	7f 78                	jg     c0100693 <debuginfo_eip+0x166>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010061e:	89 c2                	mov    %eax,%edx
c0100620:	89 d0                	mov    %edx,%eax
c0100622:	01 c0                	add    %eax,%eax
c0100624:	01 d0                	add    %edx,%eax
c0100626:	c1 e0 02             	shl    $0x2,%eax
c0100629:	89 c2                	mov    %eax,%edx
c010062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010062e:	01 d0                	add    %edx,%eax
c0100630:	8b 10                	mov    (%eax),%edx
c0100632:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100635:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100638:	39 c2                	cmp    %eax,%edx
c010063a:	73 22                	jae    c010065e <debuginfo_eip+0x131>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010063c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010063f:	89 c2                	mov    %eax,%edx
c0100641:	89 d0                	mov    %edx,%eax
c0100643:	01 c0                	add    %eax,%eax
c0100645:	01 d0                	add    %edx,%eax
c0100647:	c1 e0 02             	shl    $0x2,%eax
c010064a:	89 c2                	mov    %eax,%edx
c010064c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064f:	01 d0                	add    %edx,%eax
c0100651:	8b 10                	mov    (%eax),%edx
c0100653:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100656:	01 c2                	add    %eax,%edx
c0100658:	8b 45 0c             	mov    0xc(%ebp),%eax
c010065b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010065e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100661:	89 c2                	mov    %eax,%edx
c0100663:	89 d0                	mov    %edx,%eax
c0100665:	01 c0                	add    %eax,%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	c1 e0 02             	shl    $0x2,%eax
c010066c:	89 c2                	mov    %eax,%edx
c010066e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100671:	01 d0                	add    %edx,%eax
c0100673:	8b 50 08             	mov    0x8(%eax),%edx
c0100676:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100679:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010067c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010067f:	8b 40 10             	mov    0x10(%eax),%eax
c0100682:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100685:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100688:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010068b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010068e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0100691:	eb 15                	jmp    c01006a8 <debuginfo_eip+0x17b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100696:	8b 55 08             	mov    0x8(%ebp),%edx
c0100699:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c010069c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010069f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006a5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ab:	8b 40 08             	mov    0x8(%eax),%eax
c01006ae:	83 ec 08             	sub    $0x8,%esp
c01006b1:	6a 3a                	push   $0x3a
c01006b3:	50                   	push   %eax
c01006b4:	e8 c7 50 00 00       	call   c0105780 <strfind>
c01006b9:	83 c4 10             	add    $0x10,%esp
c01006bc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01006bf:	8b 4a 08             	mov    0x8(%edx),%ecx
c01006c2:	29 c8                	sub    %ecx,%eax
c01006c4:	89 c2                	mov    %eax,%edx
c01006c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006cc:	83 ec 0c             	sub    $0xc,%esp
c01006cf:	ff 75 08             	push   0x8(%ebp)
c01006d2:	6a 44                	push   $0x44
c01006d4:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01006d7:	50                   	push   %eax
c01006d8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01006db:	50                   	push   %eax
c01006dc:	ff 75 f4             	push   -0xc(%ebp)
c01006df:	e8 f2 fc ff ff       	call   c01003d6 <stab_binsearch>
c01006e4:	83 c4 20             	add    $0x20,%esp
    if (lline <= rline) {
c01006e7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01006ea:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01006ed:	39 c2                	cmp    %eax,%edx
c01006ef:	7f 24                	jg     c0100715 <debuginfo_eip+0x1e8>
        info->eip_line = stabs[rline].n_desc;
c01006f1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01006f4:	89 c2                	mov    %eax,%edx
c01006f6:	89 d0                	mov    %edx,%eax
c01006f8:	01 c0                	add    %eax,%eax
c01006fa:	01 d0                	add    %edx,%eax
c01006fc:	c1 e0 02             	shl    $0x2,%eax
c01006ff:	89 c2                	mov    %eax,%edx
c0100701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100704:	01 d0                	add    %edx,%eax
c0100706:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010070a:	0f b7 d0             	movzwl %ax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100713:	eb 13                	jmp    c0100728 <debuginfo_eip+0x1fb>
        return -1;
c0100715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010071a:	e9 0e 01 00 00       	jmp    c010082d <debuginfo_eip+0x300>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100722:	83 e8 01             	sub    $0x1,%eax
c0100725:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100728:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010072b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010072e:	39 c2                	cmp    %eax,%edx
c0100730:	7c 56                	jl     c0100788 <debuginfo_eip+0x25b>
           && stabs[lline].n_type != N_SOL
c0100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100735:	89 c2                	mov    %eax,%edx
c0100737:	89 d0                	mov    %edx,%eax
c0100739:	01 c0                	add    %eax,%eax
c010073b:	01 d0                	add    %edx,%eax
c010073d:	c1 e0 02             	shl    $0x2,%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100745:	01 d0                	add    %edx,%eax
c0100747:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010074b:	3c 84                	cmp    $0x84,%al
c010074d:	74 39                	je     c0100788 <debuginfo_eip+0x25b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010074f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100752:	89 c2                	mov    %eax,%edx
c0100754:	89 d0                	mov    %edx,%eax
c0100756:	01 c0                	add    %eax,%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	c1 e0 02             	shl    $0x2,%eax
c010075d:	89 c2                	mov    %eax,%edx
c010075f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100762:	01 d0                	add    %edx,%eax
c0100764:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100768:	3c 64                	cmp    $0x64,%al
c010076a:	75 b3                	jne    c010071f <debuginfo_eip+0x1f2>
c010076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076f:	89 c2                	mov    %eax,%edx
c0100771:	89 d0                	mov    %edx,%eax
c0100773:	01 c0                	add    %eax,%eax
c0100775:	01 d0                	add    %edx,%eax
c0100777:	c1 e0 02             	shl    $0x2,%eax
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010077f:	01 d0                	add    %edx,%eax
c0100781:	8b 40 08             	mov    0x8(%eax),%eax
c0100784:	85 c0                	test   %eax,%eax
c0100786:	74 97                	je     c010071f <debuginfo_eip+0x1f2>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100788:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010078b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010078e:	39 c2                	cmp    %eax,%edx
c0100790:	7c 42                	jl     c01007d4 <debuginfo_eip+0x2a7>
c0100792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100795:	89 c2                	mov    %eax,%edx
c0100797:	89 d0                	mov    %edx,%eax
c0100799:	01 c0                	add    %eax,%eax
c010079b:	01 d0                	add    %edx,%eax
c010079d:	c1 e0 02             	shl    $0x2,%eax
c01007a0:	89 c2                	mov    %eax,%edx
c01007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007a5:	01 d0                	add    %edx,%eax
c01007a7:	8b 10                	mov    (%eax),%edx
c01007a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007af:	39 c2                	cmp    %eax,%edx
c01007b1:	73 21                	jae    c01007d4 <debuginfo_eip+0x2a7>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b6:	89 c2                	mov    %eax,%edx
c01007b8:	89 d0                	mov    %edx,%eax
c01007ba:	01 c0                	add    %eax,%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	c1 e0 02             	shl    $0x2,%eax
c01007c1:	89 c2                	mov    %eax,%edx
c01007c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c6:	01 d0                	add    %edx,%eax
c01007c8:	8b 10                	mov    (%eax),%edx
c01007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007cd:	01 c2                	add    %eax,%edx
c01007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d2:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01007d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01007d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7d 4a                	jge    c0100828 <debuginfo_eip+0x2fb>
        for (lline = lfun + 1;
c01007de:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007e1:	83 c0 01             	add    $0x1,%eax
c01007e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01007e7:	eb 18                	jmp    c0100801 <debuginfo_eip+0x2d4>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01007e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ec:	8b 40 14             	mov    0x14(%eax),%eax
c01007ef:	8d 50 01             	lea    0x1(%eax),%edx
c01007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f5:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c01007f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007fb:	83 c0 01             	add    $0x1,%eax
c01007fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100801:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100804:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	7d 1d                	jge    c0100828 <debuginfo_eip+0x2fb>
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100824:	3c a0                	cmp    $0xa0,%al
c0100826:	74 c1                	je     c01007e9 <debuginfo_eip+0x2bc>
        }
    }
    return 0;
c0100828:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010082d:	c9                   	leave  
c010082e:	c3                   	ret    

c010082f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010082f:	55                   	push   %ebp
c0100830:	89 e5                	mov    %esp,%ebp
c0100832:	83 ec 08             	sub    $0x8,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100835:	83 ec 0c             	sub    $0xc,%esp
c0100838:	68 56 5b 10 c0       	push   $0xc0105b56
c010083d:	e8 ef fa ff ff       	call   c0100331 <cprintf>
c0100842:	83 c4 10             	add    $0x10,%esp
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100845:	83 ec 08             	sub    $0x8,%esp
c0100848:	68 36 00 10 c0       	push   $0xc0100036
c010084d:	68 6f 5b 10 c0       	push   $0xc0105b6f
c0100852:	e8 da fa ff ff       	call   c0100331 <cprintf>
c0100857:	83 c4 10             	add    $0x10,%esp
    cprintf("  etext  0x%08x (phys)\n", etext);
c010085a:	83 ec 08             	sub    $0x8,%esp
c010085d:	68 94 5a 10 c0       	push   $0xc0105a94
c0100862:	68 87 5b 10 c0       	push   $0xc0105b87
c0100867:	e8 c5 fa ff ff       	call   c0100331 <cprintf>
c010086c:	83 c4 10             	add    $0x10,%esp
    cprintf("  edata  0x%08x (phys)\n", edata);
c010086f:	83 ec 08             	sub    $0x8,%esp
c0100872:	68 00 b0 11 c0       	push   $0xc011b000
c0100877:	68 9f 5b 10 c0       	push   $0xc0105b9f
c010087c:	e8 b0 fa ff ff       	call   c0100331 <cprintf>
c0100881:	83 c4 10             	add    $0x10,%esp
    cprintf("  end    0x%08x (phys)\n", end);
c0100884:	83 ec 08             	sub    $0x8,%esp
c0100887:	68 2c bf 11 c0       	push   $0xc011bf2c
c010088c:	68 b7 5b 10 c0       	push   $0xc0105bb7
c0100891:	e8 9b fa ff ff       	call   c0100331 <cprintf>
c0100896:	83 c4 10             	add    $0x10,%esp
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c0100899:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c010089e:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008a3:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008a8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ae:	85 c0                	test   %eax,%eax
c01008b0:	0f 48 c2             	cmovs  %edx,%eax
c01008b3:	c1 f8 0a             	sar    $0xa,%eax
c01008b6:	83 ec 08             	sub    $0x8,%esp
c01008b9:	50                   	push   %eax
c01008ba:	68 d0 5b 10 c0       	push   $0xc0105bd0
c01008bf:	e8 6d fa ff ff       	call   c0100331 <cprintf>
c01008c4:	83 c4 10             	add    $0x10,%esp
}
c01008c7:	90                   	nop
c01008c8:	c9                   	leave  
c01008c9:	c3                   	ret    

c01008ca <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008ca:	55                   	push   %ebp
c01008cb:	89 e5                	mov    %esp,%ebp
c01008cd:	81 ec 28 01 00 00    	sub    $0x128,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01008d3:	83 ec 08             	sub    $0x8,%esp
c01008d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01008d9:	50                   	push   %eax
c01008da:	ff 75 08             	push   0x8(%ebp)
c01008dd:	e8 4b fc ff ff       	call   c010052d <debuginfo_eip>
c01008e2:	83 c4 10             	add    $0x10,%esp
c01008e5:	85 c0                	test   %eax,%eax
c01008e7:	74 15                	je     c01008fe <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01008e9:	83 ec 08             	sub    $0x8,%esp
c01008ec:	ff 75 08             	push   0x8(%ebp)
c01008ef:	68 fa 5b 10 c0       	push   $0xc0105bfa
c01008f4:	e8 38 fa ff ff       	call   c0100331 <cprintf>
c01008f9:	83 c4 10             	add    $0x10,%esp
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c01008fc:	eb 65                	jmp    c0100963 <print_debuginfo+0x99>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c01008fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100905:	eb 1c                	jmp    c0100923 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100907:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010090a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010090d:	01 d0                	add    %edx,%eax
c010090f:	0f b6 00             	movzbl (%eax),%eax
c0100912:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100918:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010091b:	01 ca                	add    %ecx,%edx
c010091d:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010091f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100923:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100926:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100929:	7c dc                	jl     c0100907 <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010092b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100931:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100934:	01 d0                	add    %edx,%eax
c0100936:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100939:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	29 d0                	sub    %edx,%eax
c0100941:	89 c1                	mov    %eax,%ecx
c0100943:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100946:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100949:	83 ec 0c             	sub    $0xc,%esp
c010094c:	51                   	push   %ecx
c010094d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100953:	51                   	push   %ecx
c0100954:	52                   	push   %edx
c0100955:	50                   	push   %eax
c0100956:	68 16 5c 10 c0       	push   $0xc0105c16
c010095b:	e8 d1 f9 ff ff       	call   c0100331 <cprintf>
c0100960:	83 c4 20             	add    $0x20,%esp
}
c0100963:	90                   	nop
c0100964:	c9                   	leave  
c0100965:	c3                   	ret    

c0100966 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100966:	55                   	push   %ebp
c0100967:	89 e5                	mov    %esp,%ebp
c0100969:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c010096c:	8b 45 04             	mov    0x4(%ebp),%eax
c010096f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100972:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100975:	c9                   	leave  
c0100976:	c3                   	ret    

c0100977 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100977:	55                   	push   %ebp
c0100978:	89 e5                	mov    %esp,%ebp
c010097a:	83 ec 28             	sub    $0x28,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c010097d:	89 e8                	mov    %ebp,%eax
c010097f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100982:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c0100985:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100988:	e8 d9 ff ff ff       	call   c0100966 <read_eip>
c010098d:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100990:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100997:	e9 8d 00 00 00       	jmp    c0100a29 <print_stackframe+0xb2>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c010099c:	83 ec 04             	sub    $0x4,%esp
c010099f:	ff 75 f0             	push   -0x10(%ebp)
c01009a2:	ff 75 f4             	push   -0xc(%ebp)
c01009a5:	68 28 5c 10 c0       	push   $0xc0105c28
c01009aa:	e8 82 f9 ff ff       	call   c0100331 <cprintf>
c01009af:	83 c4 10             	add    $0x10,%esp
        uint32_t *args = (uint32_t *)ebp + 2;
c01009b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009b5:	83 c0 08             	add    $0x8,%eax
c01009b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c01009bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01009c2:	eb 26                	jmp    c01009ea <print_stackframe+0x73>
            cprintf("0x%08x ", args[j]);
c01009c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01009ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01009d1:	01 d0                	add    %edx,%eax
c01009d3:	8b 00                	mov    (%eax),%eax
c01009d5:	83 ec 08             	sub    $0x8,%esp
c01009d8:	50                   	push   %eax
c01009d9:	68 44 5c 10 c0       	push   $0xc0105c44
c01009de:	e8 4e f9 ff ff       	call   c0100331 <cprintf>
c01009e3:	83 c4 10             	add    $0x10,%esp
        for (j = 0; j < 4; j ++) {
c01009e6:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c01009ea:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c01009ee:	7e d4                	jle    c01009c4 <print_stackframe+0x4d>
        }
        cprintf("\n");
c01009f0:	83 ec 0c             	sub    $0xc,%esp
c01009f3:	68 4c 5c 10 c0       	push   $0xc0105c4c
c01009f8:	e8 34 f9 ff ff       	call   c0100331 <cprintf>
c01009fd:	83 c4 10             	add    $0x10,%esp
        print_debuginfo(eip - 1);
c0100a00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a03:	83 e8 01             	sub    $0x1,%eax
c0100a06:	83 ec 0c             	sub    $0xc,%esp
c0100a09:	50                   	push   %eax
c0100a0a:	e8 bb fe ff ff       	call   c01008ca <print_debuginfo>
c0100a0f:	83 c4 10             	add    $0x10,%esp
        eip = ((uint32_t *)ebp)[1];
c0100a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a15:	83 c0 04             	add    $0x4,%eax
c0100a18:	8b 00                	mov    (%eax),%eax
c0100a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a20:	8b 00                	mov    (%eax),%eax
c0100a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a25:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a2d:	74 0a                	je     c0100a39 <print_stackframe+0xc2>
c0100a2f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a33:	0f 8e 63 ff ff ff    	jle    c010099c <print_stackframe+0x25>
    }
}
c0100a39:	90                   	nop
c0100a3a:	c9                   	leave  
c0100a3b:	c3                   	ret    

c0100a3c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a3c:	55                   	push   %ebp
c0100a3d:	89 e5                	mov    %esp,%ebp
c0100a3f:	83 ec 18             	sub    $0x18,%esp
    int argc = 0;
c0100a42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a49:	eb 0c                	jmp    c0100a57 <parse+0x1b>
            *buf ++ = '\0';
c0100a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a4e:	8d 50 01             	lea    0x1(%eax),%edx
c0100a51:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a54:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a5a:	0f b6 00             	movzbl (%eax),%eax
c0100a5d:	84 c0                	test   %al,%al
c0100a5f:	74 1e                	je     c0100a7f <parse+0x43>
c0100a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a64:	0f b6 00             	movzbl (%eax),%eax
c0100a67:	0f be c0             	movsbl %al,%eax
c0100a6a:	83 ec 08             	sub    $0x8,%esp
c0100a6d:	50                   	push   %eax
c0100a6e:	68 d0 5c 10 c0       	push   $0xc0105cd0
c0100a73:	e8 d5 4c 00 00       	call   c010574d <strchr>
c0100a78:	83 c4 10             	add    $0x10,%esp
c0100a7b:	85 c0                	test   %eax,%eax
c0100a7d:	75 cc                	jne    c0100a4b <parse+0xf>
        }
        if (*buf == '\0') {
c0100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a82:	0f b6 00             	movzbl (%eax),%eax
c0100a85:	84 c0                	test   %al,%al
c0100a87:	74 65                	je     c0100aee <parse+0xb2>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a89:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a8d:	75 12                	jne    c0100aa1 <parse+0x65>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a8f:	83 ec 08             	sub    $0x8,%esp
c0100a92:	6a 10                	push   $0x10
c0100a94:	68 d5 5c 10 c0       	push   $0xc0105cd5
c0100a99:	e8 93 f8 ff ff       	call   c0100331 <cprintf>
c0100a9e:	83 c4 10             	add    $0x10,%esp
        }
        argv[argc ++] = buf;
c0100aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aa4:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aaa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ab4:	01 c2                	add    %eax,%edx
c0100ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100abb:	eb 04                	jmp    c0100ac1 <parse+0x85>
            buf ++;
c0100abd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac4:	0f b6 00             	movzbl (%eax),%eax
c0100ac7:	84 c0                	test   %al,%al
c0100ac9:	74 8c                	je     c0100a57 <parse+0x1b>
c0100acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ace:	0f b6 00             	movzbl (%eax),%eax
c0100ad1:	0f be c0             	movsbl %al,%eax
c0100ad4:	83 ec 08             	sub    $0x8,%esp
c0100ad7:	50                   	push   %eax
c0100ad8:	68 d0 5c 10 c0       	push   $0xc0105cd0
c0100add:	e8 6b 4c 00 00       	call   c010574d <strchr>
c0100ae2:	83 c4 10             	add    $0x10,%esp
c0100ae5:	85 c0                	test   %eax,%eax
c0100ae7:	74 d4                	je     c0100abd <parse+0x81>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ae9:	e9 69 ff ff ff       	jmp    c0100a57 <parse+0x1b>
            break;
c0100aee:	90                   	nop
        }
    }
    return argc;
c0100aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100af2:	c9                   	leave  
c0100af3:	c3                   	ret    

c0100af4 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100af4:	55                   	push   %ebp
c0100af5:	89 e5                	mov    %esp,%ebp
c0100af7:	83 ec 58             	sub    $0x58,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100afa:	83 ec 08             	sub    $0x8,%esp
c0100afd:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b00:	50                   	push   %eax
c0100b01:	ff 75 08             	push   0x8(%ebp)
c0100b04:	e8 33 ff ff ff       	call   c0100a3c <parse>
c0100b09:	83 c4 10             	add    $0x10,%esp
c0100b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b13:	75 0a                	jne    c0100b1f <runcmd+0x2b>
        return 0;
c0100b15:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b1a:	e9 83 00 00 00       	jmp    c0100ba2 <runcmd+0xae>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b26:	eb 59                	jmp    c0100b81 <runcmd+0x8d>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b28:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100b2b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100b2e:	89 c8                	mov    %ecx,%eax
c0100b30:	01 c0                	add    %eax,%eax
c0100b32:	01 c8                	add    %ecx,%eax
c0100b34:	c1 e0 02             	shl    $0x2,%eax
c0100b37:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100b3c:	8b 00                	mov    (%eax),%eax
c0100b3e:	83 ec 08             	sub    $0x8,%esp
c0100b41:	52                   	push   %edx
c0100b42:	50                   	push   %eax
c0100b43:	e8 66 4b 00 00       	call   c01056ae <strcmp>
c0100b48:	83 c4 10             	add    $0x10,%esp
c0100b4b:	85 c0                	test   %eax,%eax
c0100b4d:	75 2e                	jne    c0100b7d <runcmd+0x89>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b52:	89 d0                	mov    %edx,%eax
c0100b54:	01 c0                	add    %eax,%eax
c0100b56:	01 d0                	add    %edx,%eax
c0100b58:	c1 e0 02             	shl    $0x2,%eax
c0100b5b:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100b60:	8b 10                	mov    (%eax),%edx
c0100b62:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b65:	83 c0 04             	add    $0x4,%eax
c0100b68:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100b6b:	83 e9 01             	sub    $0x1,%ecx
c0100b6e:	83 ec 04             	sub    $0x4,%esp
c0100b71:	ff 75 0c             	push   0xc(%ebp)
c0100b74:	50                   	push   %eax
c0100b75:	51                   	push   %ecx
c0100b76:	ff d2                	call   *%edx
c0100b78:	83 c4 10             	add    $0x10,%esp
c0100b7b:	eb 25                	jmp    c0100ba2 <runcmd+0xae>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b7d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b84:	83 f8 02             	cmp    $0x2,%eax
c0100b87:	76 9f                	jbe    c0100b28 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b89:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b8c:	83 ec 08             	sub    $0x8,%esp
c0100b8f:	50                   	push   %eax
c0100b90:	68 f3 5c 10 c0       	push   $0xc0105cf3
c0100b95:	e8 97 f7 ff ff       	call   c0100331 <cprintf>
c0100b9a:	83 c4 10             	add    $0x10,%esp
    return 0;
c0100b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ba2:	c9                   	leave  
c0100ba3:	c3                   	ret    

c0100ba4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100ba4:	55                   	push   %ebp
c0100ba5:	89 e5                	mov    %esp,%ebp
c0100ba7:	83 ec 18             	sub    $0x18,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100baa:	83 ec 0c             	sub    $0xc,%esp
c0100bad:	68 0c 5d 10 c0       	push   $0xc0105d0c
c0100bb2:	e8 7a f7 ff ff       	call   c0100331 <cprintf>
c0100bb7:	83 c4 10             	add    $0x10,%esp
    cprintf("Type 'help' for a list of commands.\n");
c0100bba:	83 ec 0c             	sub    $0xc,%esp
c0100bbd:	68 34 5d 10 c0       	push   $0xc0105d34
c0100bc2:	e8 6a f7 ff ff       	call   c0100331 <cprintf>
c0100bc7:	83 c4 10             	add    $0x10,%esp

    if (tf != NULL) {
c0100bca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bce:	74 0e                	je     c0100bde <kmonitor+0x3a>
        print_trapframe(tf);
c0100bd0:	83 ec 0c             	sub    $0xc,%esp
c0100bd3:	ff 75 08             	push   0x8(%ebp)
c0100bd6:	e8 4c 0e 00 00       	call   c0101a27 <print_trapframe>
c0100bdb:	83 c4 10             	add    $0x10,%esp
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100bde:	83 ec 0c             	sub    $0xc,%esp
c0100be1:	68 59 5d 10 c0       	push   $0xc0105d59
c0100be6:	e8 37 f6 ff ff       	call   c0100222 <readline>
c0100beb:	83 c4 10             	add    $0x10,%esp
c0100bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100bf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100bf5:	74 e7                	je     c0100bde <kmonitor+0x3a>
            if (runcmd(buf, tf) < 0) {
c0100bf7:	83 ec 08             	sub    $0x8,%esp
c0100bfa:	ff 75 08             	push   0x8(%ebp)
c0100bfd:	ff 75 f4             	push   -0xc(%ebp)
c0100c00:	e8 ef fe ff ff       	call   c0100af4 <runcmd>
c0100c05:	83 c4 10             	add    $0x10,%esp
c0100c08:	85 c0                	test   %eax,%eax
c0100c0a:	78 02                	js     c0100c0e <kmonitor+0x6a>
        if ((buf = readline("K> ")) != NULL) {
c0100c0c:	eb d0                	jmp    c0100bde <kmonitor+0x3a>
                break;
c0100c0e:	90                   	nop
            }
        }
    }
}
c0100c0f:	90                   	nop
c0100c10:	c9                   	leave  
c0100c11:	c3                   	ret    

c0100c12 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c12:	55                   	push   %ebp
c0100c13:	89 e5                	mov    %esp,%ebp
c0100c15:	83 ec 18             	sub    $0x18,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c1f:	eb 3c                	jmp    c0100c5d <mon_help+0x4b>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c24:	89 d0                	mov    %edx,%eax
c0100c26:	01 c0                	add    %eax,%eax
c0100c28:	01 d0                	add    %edx,%eax
c0100c2a:	c1 e0 02             	shl    $0x2,%eax
c0100c2d:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100c32:	8b 10                	mov    (%eax),%edx
c0100c34:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100c37:	89 c8                	mov    %ecx,%eax
c0100c39:	01 c0                	add    %eax,%eax
c0100c3b:	01 c8                	add    %ecx,%eax
c0100c3d:	c1 e0 02             	shl    $0x2,%eax
c0100c40:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100c45:	8b 00                	mov    (%eax),%eax
c0100c47:	83 ec 04             	sub    $0x4,%esp
c0100c4a:	52                   	push   %edx
c0100c4b:	50                   	push   %eax
c0100c4c:	68 5d 5d 10 c0       	push   $0xc0105d5d
c0100c51:	e8 db f6 ff ff       	call   c0100331 <cprintf>
c0100c56:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c60:	83 f8 02             	cmp    $0x2,%eax
c0100c63:	76 bc                	jbe    c0100c21 <mon_help+0xf>
    }
    return 0;
c0100c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c6a:	c9                   	leave  
c0100c6b:	c3                   	ret    

c0100c6c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c6c:	55                   	push   %ebp
c0100c6d:	89 e5                	mov    %esp,%ebp
c0100c6f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c72:	e8 b8 fb ff ff       	call   c010082f <print_kerninfo>
    return 0;
c0100c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c7c:	c9                   	leave  
c0100c7d:	c3                   	ret    

c0100c7e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c7e:	55                   	push   %ebp
c0100c7f:	89 e5                	mov    %esp,%ebp
c0100c81:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c84:	e8 ee fc ff ff       	call   c0100977 <print_stackframe>
    return 0;
c0100c89:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c8e:	c9                   	leave  
c0100c8f:	c3                   	ret    

c0100c90 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c90:	55                   	push   %ebp
c0100c91:	89 e5                	mov    %esp,%ebp
c0100c93:	83 ec 18             	sub    $0x18,%esp
    if (is_panic) {
c0100c96:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100c9b:	85 c0                	test   %eax,%eax
c0100c9d:	75 5f                	jne    c0100cfe <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
c0100c9f:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100ca6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ca9:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100caf:	83 ec 04             	sub    $0x4,%esp
c0100cb2:	ff 75 0c             	push   0xc(%ebp)
c0100cb5:	ff 75 08             	push   0x8(%ebp)
c0100cb8:	68 66 5d 10 c0       	push   $0xc0105d66
c0100cbd:	e8 6f f6 ff ff       	call   c0100331 <cprintf>
c0100cc2:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc8:	83 ec 08             	sub    $0x8,%esp
c0100ccb:	50                   	push   %eax
c0100ccc:	ff 75 10             	push   0x10(%ebp)
c0100ccf:	e8 34 f6 ff ff       	call   c0100308 <vcprintf>
c0100cd4:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100cd7:	83 ec 0c             	sub    $0xc,%esp
c0100cda:	68 82 5d 10 c0       	push   $0xc0105d82
c0100cdf:	e8 4d f6 ff ff       	call   c0100331 <cprintf>
c0100ce4:	83 c4 10             	add    $0x10,%esp
    
    cprintf("stack trackback:\n");
c0100ce7:	83 ec 0c             	sub    $0xc,%esp
c0100cea:	68 84 5d 10 c0       	push   $0xc0105d84
c0100cef:	e8 3d f6 ff ff       	call   c0100331 <cprintf>
c0100cf4:	83 c4 10             	add    $0x10,%esp
    print_stackframe();
c0100cf7:	e8 7b fc ff ff       	call   c0100977 <print_stackframe>
c0100cfc:	eb 01                	jmp    c0100cff <__panic+0x6f>
        goto panic_dead;
c0100cfe:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100cff:	e8 d1 09 00 00       	call   c01016d5 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d04:	83 ec 0c             	sub    $0xc,%esp
c0100d07:	6a 00                	push   $0x0
c0100d09:	e8 96 fe ff ff       	call   c0100ba4 <kmonitor>
c0100d0e:	83 c4 10             	add    $0x10,%esp
c0100d11:	eb f1                	jmp    c0100d04 <__panic+0x74>

c0100d13 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d13:	55                   	push   %ebp
c0100d14:	89 e5                	mov    %esp,%ebp
c0100d16:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d19:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d1f:	83 ec 04             	sub    $0x4,%esp
c0100d22:	ff 75 0c             	push   0xc(%ebp)
c0100d25:	ff 75 08             	push   0x8(%ebp)
c0100d28:	68 96 5d 10 c0       	push   $0xc0105d96
c0100d2d:	e8 ff f5 ff ff       	call   c0100331 <cprintf>
c0100d32:	83 c4 10             	add    $0x10,%esp
    vcprintf(fmt, ap);
c0100d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d38:	83 ec 08             	sub    $0x8,%esp
c0100d3b:	50                   	push   %eax
c0100d3c:	ff 75 10             	push   0x10(%ebp)
c0100d3f:	e8 c4 f5 ff ff       	call   c0100308 <vcprintf>
c0100d44:	83 c4 10             	add    $0x10,%esp
    cprintf("\n");
c0100d47:	83 ec 0c             	sub    $0xc,%esp
c0100d4a:	68 82 5d 10 c0       	push   $0xc0105d82
c0100d4f:	e8 dd f5 ff ff       	call   c0100331 <cprintf>
c0100d54:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0100d57:	90                   	nop
c0100d58:	c9                   	leave  
c0100d59:	c3                   	ret    

c0100d5a <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d5a:	55                   	push   %ebp
c0100d5b:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d5d:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100d62:	5d                   	pop    %ebp
c0100d63:	c3                   	ret    

c0100d64 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d64:	55                   	push   %ebp
c0100d65:	89 e5                	mov    %esp,%ebp
c0100d67:	83 ec 18             	sub    $0x18,%esp
c0100d6a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d70:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d74:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d78:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d7c:	ee                   	out    %al,(%dx)
}
c0100d7d:	90                   	nop
c0100d7e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d84:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d88:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d8c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d90:	ee                   	out    %al,(%dx)
}
c0100d91:	90                   	nop
c0100d92:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100d98:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d9c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da4:	ee                   	out    %al,(%dx)
}
c0100da5:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100da6:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db0:	83 ec 0c             	sub    $0xc,%esp
c0100db3:	68 b4 5d 10 c0       	push   $0xc0105db4
c0100db8:	e8 74 f5 ff ff       	call   c0100331 <cprintf>
c0100dbd:	83 c4 10             	add    $0x10,%esp
    pic_enable(IRQ_TIMER);
c0100dc0:	83 ec 0c             	sub    $0xc,%esp
c0100dc3:	6a 00                	push   $0x0
c0100dc5:	e8 6e 09 00 00       	call   c0101738 <pic_enable>
c0100dca:	83 c4 10             	add    $0x10,%esp
}
c0100dcd:	90                   	nop
c0100dce:	c9                   	leave  
c0100dcf:	c3                   	ret    

c0100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd0:	55                   	push   %ebp
c0100dd1:	89 e5                	mov    %esp,%ebp
c0100dd3:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd6:	9c                   	pushf  
c0100dd7:	58                   	pop    %eax
c0100dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dde:	25 00 02 00 00       	and    $0x200,%eax
c0100de3:	85 c0                	test   %eax,%eax
c0100de5:	74 0c                	je     c0100df3 <__intr_save+0x23>
        intr_disable();
c0100de7:	e8 e9 08 00 00       	call   c01016d5 <intr_disable>
        return 1;
c0100dec:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df1:	eb 05                	jmp    c0100df8 <__intr_save+0x28>
    }
    return 0;
c0100df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df8:	c9                   	leave  
c0100df9:	c3                   	ret    

c0100dfa <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dfa:	55                   	push   %ebp
c0100dfb:	89 e5                	mov    %esp,%ebp
c0100dfd:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e04:	74 05                	je     c0100e0b <__intr_restore+0x11>
        intr_enable();
c0100e06:	e8 c2 08 00 00       	call   c01016cd <intr_enable>
    }
}
c0100e0b:	90                   	nop
c0100e0c:	c9                   	leave  
c0100e0d:	c3                   	ret    

c0100e0e <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e0e:	55                   	push   %ebp
c0100e0f:	89 e5                	mov    %esp,%ebp
c0100e11:	83 ec 10             	sub    $0x10,%esp
c0100e14:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e1e:	89 c2                	mov    %eax,%edx
c0100e20:	ec                   	in     (%dx),%al
c0100e21:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e24:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e2a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e2e:	89 c2                	mov    %eax,%edx
c0100e30:	ec                   	in     (%dx),%al
c0100e31:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e34:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e3e:	89 c2                	mov    %eax,%edx
c0100e40:	ec                   	in     (%dx),%al
c0100e41:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e44:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e4a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e4e:	89 c2                	mov    %eax,%edx
c0100e50:	ec                   	in     (%dx),%al
c0100e51:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e54:	90                   	nop
c0100e55:	c9                   	leave  
c0100e56:	c3                   	ret    

c0100e57 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e57:	55                   	push   %ebp
c0100e58:	89 e5                	mov    %esp,%ebp
c0100e5a:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e5d:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e67:	0f b7 00             	movzwl (%eax),%eax
c0100e6a:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e71:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e76:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e79:	0f b7 00             	movzwl (%eax),%eax
c0100e7c:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e80:	74 12                	je     c0100e94 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e82:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e89:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100e90:	b4 03 
c0100e92:	eb 13                	jmp    c0100ea7 <cga_init+0x50>
    } else {
        *cp = was;
c0100e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e97:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e9b:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e9e:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100ea5:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ea7:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100eae:	0f b7 c0             	movzwl %ax,%eax
c0100eb1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100eb5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ebd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
}
c0100ec2:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100ec3:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100eca:	83 c0 01             	add    $0x1,%eax
c0100ecd:	0f b7 c0             	movzwl %ax,%eax
c0100ed0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ed4:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100ed8:	89 c2                	mov    %eax,%edx
c0100eda:	ec                   	in     (%dx),%al
c0100edb:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100ede:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ee2:	0f b6 c0             	movzbl %al,%eax
c0100ee5:	c1 e0 08             	shl    $0x8,%eax
c0100ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100eeb:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100ef2:	0f b7 c0             	movzwl %ax,%eax
c0100ef5:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ef9:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efd:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f01:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f05:	ee                   	out    %al,(%dx)
}
c0100f06:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100f07:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100f0e:	83 c0 01             	add    $0x1,%eax
c0100f11:	0f b7 c0             	movzwl %ax,%eax
c0100f14:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f18:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f1c:	89 c2                	mov    %eax,%edx
c0100f1e:	ec                   	in     (%dx),%al
c0100f1f:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f22:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f26:	0f b6 c0             	movzbl %al,%eax
c0100f29:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2f:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f37:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100f3d:	90                   	nop
c0100f3e:	c9                   	leave  
c0100f3f:	c3                   	ret    

c0100f40 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f40:	55                   	push   %ebp
c0100f41:	89 e5                	mov    %esp,%ebp
c0100f43:	83 ec 38             	sub    $0x38,%esp
c0100f46:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f4c:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f50:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f54:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f58:	ee                   	out    %al,(%dx)
}
c0100f59:	90                   	nop
c0100f5a:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f60:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f64:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f68:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f6c:	ee                   	out    %al,(%dx)
}
c0100f6d:	90                   	nop
c0100f6e:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f74:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f78:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f7c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f80:	ee                   	out    %al,(%dx)
}
c0100f81:	90                   	nop
c0100f82:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f88:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f90:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f94:	ee                   	out    %al,(%dx)
}
c0100f95:	90                   	nop
c0100f96:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100f9c:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fa0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fa4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fa8:	ee                   	out    %al,(%dx)
}
c0100fa9:	90                   	nop
c0100faa:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100fb0:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fb4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbc:	ee                   	out    %al,(%dx)
}
c0100fbd:	90                   	nop
c0100fbe:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc4:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fcc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fd0:	ee                   	out    %al,(%dx)
}
c0100fd1:	90                   	nop
c0100fd2:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd8:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fdc:	89 c2                	mov    %eax,%edx
c0100fde:	ec                   	in     (%dx),%al
c0100fdf:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fe2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fe6:	3c ff                	cmp    $0xff,%al
c0100fe8:	0f 95 c0             	setne  %al
c0100feb:	0f b6 c0             	movzbl %al,%eax
c0100fee:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c0100ff3:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ffd:	89 c2                	mov    %eax,%edx
c0100fff:	ec                   	in     (%dx),%al
c0101000:	88 45 f1             	mov    %al,-0xf(%ebp)
c0101003:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101009:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010100d:	89 c2                	mov    %eax,%edx
c010100f:	ec                   	in     (%dx),%al
c0101010:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101013:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101018:	85 c0                	test   %eax,%eax
c010101a:	74 0d                	je     c0101029 <serial_init+0xe9>
        pic_enable(IRQ_COM1);
c010101c:	83 ec 0c             	sub    $0xc,%esp
c010101f:	6a 04                	push   $0x4
c0101021:	e8 12 07 00 00       	call   c0101738 <pic_enable>
c0101026:	83 c4 10             	add    $0x10,%esp
    }
}
c0101029:	90                   	nop
c010102a:	c9                   	leave  
c010102b:	c3                   	ret    

c010102c <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010102c:	55                   	push   %ebp
c010102d:	89 e5                	mov    %esp,%ebp
c010102f:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101032:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101039:	eb 09                	jmp    c0101044 <lpt_putc_sub+0x18>
        delay();
c010103b:	e8 ce fd ff ff       	call   c0100e0e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101040:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101044:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010104a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010104e:	89 c2                	mov    %eax,%edx
c0101050:	ec                   	in     (%dx),%al
c0101051:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101054:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101058:	84 c0                	test   %al,%al
c010105a:	78 09                	js     c0101065 <lpt_putc_sub+0x39>
c010105c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101063:	7e d6                	jle    c010103b <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101065:	8b 45 08             	mov    0x8(%ebp),%eax
c0101068:	0f b6 c0             	movzbl %al,%eax
c010106b:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101071:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101074:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101078:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010107c:	ee                   	out    %al,(%dx)
}
c010107d:	90                   	nop
c010107e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101084:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101088:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010108c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101090:	ee                   	out    %al,(%dx)
}
c0101091:	90                   	nop
c0101092:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c0101098:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010109c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a4:	ee                   	out    %al,(%dx)
}
c01010a5:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010a6:	90                   	nop
c01010a7:	c9                   	leave  
c01010a8:	c3                   	ret    

c01010a9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010a9:	55                   	push   %ebp
c01010aa:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c01010ac:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b0:	74 0d                	je     c01010bf <lpt_putc+0x16>
        lpt_putc_sub(c);
c01010b2:	ff 75 08             	push   0x8(%ebp)
c01010b5:	e8 72 ff ff ff       	call   c010102c <lpt_putc_sub>
c01010ba:	83 c4 04             	add    $0x4,%esp
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010bd:	eb 1e                	jmp    c01010dd <lpt_putc+0x34>
        lpt_putc_sub('\b');
c01010bf:	6a 08                	push   $0x8
c01010c1:	e8 66 ff ff ff       	call   c010102c <lpt_putc_sub>
c01010c6:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub(' ');
c01010c9:	6a 20                	push   $0x20
c01010cb:	e8 5c ff ff ff       	call   c010102c <lpt_putc_sub>
c01010d0:	83 c4 04             	add    $0x4,%esp
        lpt_putc_sub('\b');
c01010d3:	6a 08                	push   $0x8
c01010d5:	e8 52 ff ff ff       	call   c010102c <lpt_putc_sub>
c01010da:	83 c4 04             	add    $0x4,%esp
}
c01010dd:	90                   	nop
c01010de:	c9                   	leave  
c01010df:	c3                   	ret    

c01010e0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010e0:	55                   	push   %ebp
c01010e1:	89 e5                	mov    %esp,%ebp
c01010e3:	53                   	push   %ebx
c01010e4:	83 ec 24             	sub    $0x24,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ea:	b0 00                	mov    $0x0,%al
c01010ec:	85 c0                	test   %eax,%eax
c01010ee:	75 07                	jne    c01010f7 <cga_putc+0x17>
        c |= 0x0700;
c01010f0:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fa:	0f b6 c0             	movzbl %al,%eax
c01010fd:	83 f8 0d             	cmp    $0xd,%eax
c0101100:	74 6b                	je     c010116d <cga_putc+0x8d>
c0101102:	83 f8 0d             	cmp    $0xd,%eax
c0101105:	0f 8f 9c 00 00 00    	jg     c01011a7 <cga_putc+0xc7>
c010110b:	83 f8 08             	cmp    $0x8,%eax
c010110e:	74 0a                	je     c010111a <cga_putc+0x3a>
c0101110:	83 f8 0a             	cmp    $0xa,%eax
c0101113:	74 48                	je     c010115d <cga_putc+0x7d>
c0101115:	e9 8d 00 00 00       	jmp    c01011a7 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c010111a:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101121:	66 85 c0             	test   %ax,%ax
c0101124:	0f 84 a3 00 00 00    	je     c01011cd <cga_putc+0xed>
            crt_pos --;
c010112a:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101131:	83 e8 01             	sub    $0x1,%eax
c0101134:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113a:	8b 45 08             	mov    0x8(%ebp),%eax
c010113d:	b0 00                	mov    $0x0,%al
c010113f:	83 c8 20             	or     $0x20,%eax
c0101142:	89 c2                	mov    %eax,%edx
c0101144:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c010114a:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101151:	0f b7 c0             	movzwl %ax,%eax
c0101154:	01 c0                	add    %eax,%eax
c0101156:	01 c8                	add    %ecx,%eax
c0101158:	66 89 10             	mov    %dx,(%eax)
        }
        break;
c010115b:	eb 70                	jmp    c01011cd <cga_putc+0xed>
    case '\n':
        crt_pos += CRT_COLS;
c010115d:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101164:	83 c0 50             	add    $0x50,%eax
c0101167:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010116d:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c0101174:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c010117b:	0f b7 c1             	movzwl %cx,%eax
c010117e:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101184:	c1 e8 10             	shr    $0x10,%eax
c0101187:	89 c2                	mov    %eax,%edx
c0101189:	66 c1 ea 06          	shr    $0x6,%dx
c010118d:	89 d0                	mov    %edx,%eax
c010118f:	c1 e0 02             	shl    $0x2,%eax
c0101192:	01 d0                	add    %edx,%eax
c0101194:	c1 e0 04             	shl    $0x4,%eax
c0101197:	29 c1                	sub    %eax,%ecx
c0101199:	89 ca                	mov    %ecx,%edx
c010119b:	89 d8                	mov    %ebx,%eax
c010119d:	29 d0                	sub    %edx,%eax
c010119f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c01011a5:	eb 27                	jmp    c01011ce <cga_putc+0xee>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a7:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01011ad:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011b4:	8d 50 01             	lea    0x1(%eax),%edx
c01011b7:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c01011be:	0f b7 c0             	movzwl %ax,%eax
c01011c1:	01 c0                	add    %eax,%eax
c01011c3:	01 c8                	add    %ecx,%eax
c01011c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01011c8:	66 89 10             	mov    %dx,(%eax)
        break;
c01011cb:	eb 01                	jmp    c01011ce <cga_putc+0xee>
        break;
c01011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ce:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011d5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d9:	76 5a                	jbe    c0101235 <cga_putc+0x155>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011db:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c01011e0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e6:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c01011eb:	83 ec 04             	sub    $0x4,%esp
c01011ee:	68 00 0f 00 00       	push   $0xf00
c01011f3:	52                   	push   %edx
c01011f4:	50                   	push   %eax
c01011f5:	e8 50 47 00 00       	call   c010594a <memmove>
c01011fa:	83 c4 10             	add    $0x10,%esp
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fd:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101204:	eb 16                	jmp    c010121c <cga_putc+0x13c>
            crt_buf[i] = 0x0700 | ' ';
c0101206:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c010120c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010120f:	01 c0                	add    %eax,%eax
c0101211:	01 d0                	add    %edx,%eax
c0101213:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101218:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101223:	7e e1                	jle    c0101206 <cga_putc+0x126>
        }
        crt_pos -= CRT_COLS;
c0101225:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010122c:	83 e8 50             	sub    $0x50,%eax
c010122f:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101235:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c010123c:	0f b7 c0             	movzwl %ax,%eax
c010123f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101243:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101247:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010124b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010124f:	ee                   	out    %al,(%dx)
}
c0101250:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101251:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101258:	66 c1 e8 08          	shr    $0x8,%ax
c010125c:	0f b6 c0             	movzbl %al,%eax
c010125f:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c0101266:	83 c2 01             	add    $0x1,%edx
c0101269:	0f b7 d2             	movzwl %dx,%edx
c010126c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101270:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101273:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101277:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
}
c010127c:	90                   	nop
    outb(addr_6845, 15);
c010127d:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0101284:	0f b7 c0             	movzwl %ax,%eax
c0101287:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c010128b:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010128f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101293:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101297:	ee                   	out    %al,(%dx)
}
c0101298:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101299:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01012a0:	0f b6 c0             	movzbl %al,%eax
c01012a3:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c01012aa:	83 c2 01             	add    $0x1,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012b4:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012b7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012bb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
}
c01012c0:	90                   	nop
}
c01012c1:	90                   	nop
c01012c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01012c5:	c9                   	leave  
c01012c6:	c3                   	ret    

c01012c7 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c7:	55                   	push   %ebp
c01012c8:	89 e5                	mov    %esp,%ebp
c01012ca:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d4:	eb 09                	jmp    c01012df <serial_putc_sub+0x18>
        delay();
c01012d6:	e8 33 fb ff ff       	call   c0100e0e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012df:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e9:	89 c2                	mov    %eax,%edx
c01012eb:	ec                   	in     (%dx),%al
c01012ec:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ef:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f3:	0f b6 c0             	movzbl %al,%eax
c01012f6:	83 e0 20             	and    $0x20,%eax
c01012f9:	85 c0                	test   %eax,%eax
c01012fb:	75 09                	jne    c0101306 <serial_putc_sub+0x3f>
c01012fd:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101304:	7e d0                	jle    c01012d6 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101306:	8b 45 08             	mov    0x8(%ebp),%eax
c0101309:	0f b6 c0             	movzbl %al,%eax
c010130c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101312:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101315:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101319:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131d:	ee                   	out    %al,(%dx)
}
c010131e:	90                   	nop
}
c010131f:	90                   	nop
c0101320:	c9                   	leave  
c0101321:	c3                   	ret    

c0101322 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101322:	55                   	push   %ebp
c0101323:	89 e5                	mov    %esp,%ebp
    if (c != '\b') {
c0101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101329:	74 0d                	je     c0101338 <serial_putc+0x16>
        serial_putc_sub(c);
c010132b:	ff 75 08             	push   0x8(%ebp)
c010132e:	e8 94 ff ff ff       	call   c01012c7 <serial_putc_sub>
c0101333:	83 c4 04             	add    $0x4,%esp
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101336:	eb 1e                	jmp    c0101356 <serial_putc+0x34>
        serial_putc_sub('\b');
c0101338:	6a 08                	push   $0x8
c010133a:	e8 88 ff ff ff       	call   c01012c7 <serial_putc_sub>
c010133f:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub(' ');
c0101342:	6a 20                	push   $0x20
c0101344:	e8 7e ff ff ff       	call   c01012c7 <serial_putc_sub>
c0101349:	83 c4 04             	add    $0x4,%esp
        serial_putc_sub('\b');
c010134c:	6a 08                	push   $0x8
c010134e:	e8 74 ff ff ff       	call   c01012c7 <serial_putc_sub>
c0101353:	83 c4 04             	add    $0x4,%esp
}
c0101356:	90                   	nop
c0101357:	c9                   	leave  
c0101358:	c3                   	ret    

c0101359 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101359:	55                   	push   %ebp
c010135a:	89 e5                	mov    %esp,%ebp
c010135c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135f:	eb 33                	jmp    c0101394 <cons_intr+0x3b>
        if (c != 0) {
c0101361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101365:	74 2d                	je     c0101394 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101367:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c010136c:	8d 50 01             	lea    0x1(%eax),%edx
c010136f:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c0101375:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101378:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137e:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101383:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101388:	75 0a                	jne    c0101394 <cons_intr+0x3b>
                cons.wpos = 0;
c010138a:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c0101391:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101394:	8b 45 08             	mov    0x8(%ebp),%eax
c0101397:	ff d0                	call   *%eax
c0101399:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a0:	75 bf                	jne    c0101361 <cons_intr+0x8>
            }
        }
    }
}
c01013a2:	90                   	nop
c01013a3:	90                   	nop
c01013a4:	c9                   	leave  
c01013a5:	c3                   	ret    

c01013a6 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a6:	55                   	push   %ebp
c01013a7:	89 e5                	mov    %esp,%ebp
c01013a9:	83 ec 10             	sub    $0x10,%esp
c01013ac:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b6:	89 c2                	mov    %eax,%edx
c01013b8:	ec                   	in     (%dx),%al
c01013b9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c0:	0f b6 c0             	movzbl %al,%eax
c01013c3:	83 e0 01             	and    $0x1,%eax
c01013c6:	85 c0                	test   %eax,%eax
c01013c8:	75 07                	jne    c01013d1 <serial_proc_data+0x2b>
        return -1;
c01013ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cf:	eb 2a                	jmp    c01013fb <serial_proc_data+0x55>
c01013d1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013db:	89 c2                	mov    %eax,%edx
c01013dd:	ec                   	in     (%dx),%al
c01013de:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e5:	0f b6 c0             	movzbl %al,%eax
c01013e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013eb:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ef:	75 07                	jne    c01013f8 <serial_proc_data+0x52>
        c = '\b';
c01013f1:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fb:	c9                   	leave  
c01013fc:	c3                   	ret    

c01013fd <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013fd:	55                   	push   %ebp
c01013fe:	89 e5                	mov    %esp,%ebp
c0101400:	83 ec 08             	sub    $0x8,%esp
    if (serial_exists) {
c0101403:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0101408:	85 c0                	test   %eax,%eax
c010140a:	74 10                	je     c010141c <serial_intr+0x1f>
        cons_intr(serial_proc_data);
c010140c:	83 ec 0c             	sub    $0xc,%esp
c010140f:	68 a6 13 10 c0       	push   $0xc01013a6
c0101414:	e8 40 ff ff ff       	call   c0101359 <cons_intr>
c0101419:	83 c4 10             	add    $0x10,%esp
    }
}
c010141c:	90                   	nop
c010141d:	c9                   	leave  
c010141e:	c3                   	ret    

c010141f <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141f:	55                   	push   %ebp
c0101420:	89 e5                	mov    %esp,%ebp
c0101422:	83 ec 28             	sub    $0x28,%esp
c0101425:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142b:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142f:	89 c2                	mov    %eax,%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101435:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101439:	0f b6 c0             	movzbl %al,%eax
c010143c:	83 e0 01             	and    $0x1,%eax
c010143f:	85 c0                	test   %eax,%eax
c0101441:	75 0a                	jne    c010144d <kbd_proc_data+0x2e>
        return -1;
c0101443:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101448:	e9 5e 01 00 00       	jmp    c01015ab <kbd_proc_data+0x18c>
c010144d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101453:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101457:	89 c2                	mov    %eax,%edx
c0101459:	ec                   	in     (%dx),%al
c010145a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101461:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101464:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101468:	75 17                	jne    c0101481 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010146a:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010146f:	83 c8 40             	or     $0x40,%eax
c0101472:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101477:	b8 00 00 00 00       	mov    $0x0,%eax
c010147c:	e9 2a 01 00 00       	jmp    c01015ab <kbd_proc_data+0x18c>
    } else if (data & 0x80) {
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	84 c0                	test   %al,%al
c0101487:	79 47                	jns    c01014d0 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101489:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010148e:	83 e0 40             	and    $0x40,%eax
c0101491:	85 c0                	test   %eax,%eax
c0101493:	75 09                	jne    c010149e <kbd_proc_data+0x7f>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	83 e0 7f             	and    $0x7f,%eax
c010149c:	eb 04                	jmp    c01014a2 <kbd_proc_data+0x83>
c010149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a2:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a9:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c01014b0:	83 c8 40             	or     $0x40,%eax
c01014b3:	0f b6 c0             	movzbl %al,%eax
c01014b6:	f7 d0                	not    %eax
c01014b8:	89 c2                	mov    %eax,%edx
c01014ba:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014bf:	21 d0                	and    %edx,%eax
c01014c1:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c01014c6:	b8 00 00 00 00       	mov    $0x0,%eax
c01014cb:	e9 db 00 00 00       	jmp    c01015ab <kbd_proc_data+0x18c>
    } else if (shift & E0ESC) {
c01014d0:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014d5:	83 e0 40             	and    $0x40,%eax
c01014d8:	85 c0                	test   %eax,%eax
c01014da:	74 11                	je     c01014ed <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014dc:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e0:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014e5:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e8:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c01014ed:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f1:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c01014f8:	0f b6 d0             	movzbl %al,%edx
c01014fb:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101500:	09 d0                	or     %edx,%eax
c0101502:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c0101507:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010150b:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c0101512:	0f b6 d0             	movzbl %al,%edx
c0101515:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010151a:	31 d0                	xor    %edx,%eax
c010151c:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101521:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101526:	83 e0 03             	and    $0x3,%eax
c0101529:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	01 d0                	add    %edx,%eax
c0101536:	0f b6 00             	movzbl (%eax),%eax
c0101539:	0f b6 c0             	movzbl %al,%eax
c010153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153f:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101544:	83 e0 08             	and    $0x8,%eax
c0101547:	85 c0                	test   %eax,%eax
c0101549:	74 22                	je     c010156d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010154b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154f:	7e 0c                	jle    c010155d <kbd_proc_data+0x13e>
c0101551:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101555:	7f 06                	jg     c010155d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101557:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010155b:	eb 10                	jmp    c010156d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101561:	7e 0a                	jle    c010156d <kbd_proc_data+0x14e>
c0101563:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101567:	7f 04                	jg     c010156d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101569:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156d:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101572:	f7 d0                	not    %eax
c0101574:	83 e0 06             	and    $0x6,%eax
c0101577:	85 c0                	test   %eax,%eax
c0101579:	75 2d                	jne    c01015a8 <kbd_proc_data+0x189>
c010157b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101582:	75 24                	jne    c01015a8 <kbd_proc_data+0x189>
        cprintf("Rebooting!\n");
c0101584:	83 ec 0c             	sub    $0xc,%esp
c0101587:	68 cf 5d 10 c0       	push   $0xc0105dcf
c010158c:	e8 a0 ed ff ff       	call   c0100331 <cprintf>
c0101591:	83 c4 10             	add    $0x10,%esp
c0101594:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010159e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a2:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a6:	ee                   	out    %al,(%dx)
}
c01015a7:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ab:	c9                   	leave  
c01015ac:	c3                   	ret    

c01015ad <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ad:	55                   	push   %ebp
c01015ae:	89 e5                	mov    %esp,%ebp
c01015b0:	83 ec 08             	sub    $0x8,%esp
    cons_intr(kbd_proc_data);
c01015b3:	83 ec 0c             	sub    $0xc,%esp
c01015b6:	68 1f 14 10 c0       	push   $0xc010141f
c01015bb:	e8 99 fd ff ff       	call   c0101359 <cons_intr>
c01015c0:	83 c4 10             	add    $0x10,%esp
}
c01015c3:	90                   	nop
c01015c4:	c9                   	leave  
c01015c5:	c3                   	ret    

c01015c6 <kbd_init>:

static void
kbd_init(void) {
c01015c6:	55                   	push   %ebp
c01015c7:	89 e5                	mov    %esp,%ebp
c01015c9:	83 ec 08             	sub    $0x8,%esp
    // drain the kbd buffer
    kbd_intr();
c01015cc:	e8 dc ff ff ff       	call   c01015ad <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d1:	83 ec 0c             	sub    $0xc,%esp
c01015d4:	6a 01                	push   $0x1
c01015d6:	e8 5d 01 00 00       	call   c0101738 <pic_enable>
c01015db:	83 c4 10             	add    $0x10,%esp
}
c01015de:	90                   	nop
c01015df:	c9                   	leave  
c01015e0:	c3                   	ret    

c01015e1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e1:	55                   	push   %ebp
c01015e2:	89 e5                	mov    %esp,%ebp
c01015e4:	83 ec 08             	sub    $0x8,%esp
    cga_init();
c01015e7:	e8 6b f8 ff ff       	call   c0100e57 <cga_init>
    serial_init();
c01015ec:	e8 4f f9 ff ff       	call   c0100f40 <serial_init>
    kbd_init();
c01015f1:	e8 d0 ff ff ff       	call   c01015c6 <kbd_init>
    if (!serial_exists) {
c01015f6:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c01015fb:	85 c0                	test   %eax,%eax
c01015fd:	75 10                	jne    c010160f <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
c01015ff:	83 ec 0c             	sub    $0xc,%esp
c0101602:	68 db 5d 10 c0       	push   $0xc0105ddb
c0101607:	e8 25 ed ff ff       	call   c0100331 <cprintf>
c010160c:	83 c4 10             	add    $0x10,%esp
    }
}
c010160f:	90                   	nop
c0101610:	c9                   	leave  
c0101611:	c3                   	ret    

c0101612 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101612:	55                   	push   %ebp
c0101613:	89 e5                	mov    %esp,%ebp
c0101615:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101618:	e8 b3 f7 ff ff       	call   c0100dd0 <__intr_save>
c010161d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101620:	83 ec 0c             	sub    $0xc,%esp
c0101623:	ff 75 08             	push   0x8(%ebp)
c0101626:	e8 7e fa ff ff       	call   c01010a9 <lpt_putc>
c010162b:	83 c4 10             	add    $0x10,%esp
        cga_putc(c);
c010162e:	83 ec 0c             	sub    $0xc,%esp
c0101631:	ff 75 08             	push   0x8(%ebp)
c0101634:	e8 a7 fa ff ff       	call   c01010e0 <cga_putc>
c0101639:	83 c4 10             	add    $0x10,%esp
        serial_putc(c);
c010163c:	83 ec 0c             	sub    $0xc,%esp
c010163f:	ff 75 08             	push   0x8(%ebp)
c0101642:	e8 db fc ff ff       	call   c0101322 <serial_putc>
c0101647:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c010164a:	83 ec 0c             	sub    $0xc,%esp
c010164d:	ff 75 f4             	push   -0xc(%ebp)
c0101650:	e8 a5 f7 ff ff       	call   c0100dfa <__intr_restore>
c0101655:	83 c4 10             	add    $0x10,%esp
}
c0101658:	90                   	nop
c0101659:	c9                   	leave  
c010165a:	c3                   	ret    

c010165b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010165b:	55                   	push   %ebp
c010165c:	89 e5                	mov    %esp,%ebp
c010165e:	83 ec 18             	sub    $0x18,%esp
    int c = 0;
c0101661:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101668:	e8 63 f7 ff ff       	call   c0100dd0 <__intr_save>
c010166d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101670:	e8 88 fd ff ff       	call   c01013fd <serial_intr>
        kbd_intr();
c0101675:	e8 33 ff ff ff       	call   c01015ad <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167a:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c0101680:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101685:	39 c2                	cmp    %eax,%edx
c0101687:	74 31                	je     c01016ba <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101689:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c010168e:	8d 50 01             	lea    0x1(%eax),%edx
c0101691:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c0101697:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c010169e:	0f b6 c0             	movzbl %al,%eax
c01016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a4:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c01016a9:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016ae:	75 0a                	jne    c01016ba <cons_getc+0x5f>
                cons.rpos = 0;
c01016b0:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c01016b7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016ba:	83 ec 0c             	sub    $0xc,%esp
c01016bd:	ff 75 f0             	push   -0x10(%ebp)
c01016c0:	e8 35 f7 ff ff       	call   c0100dfa <__intr_restore>
c01016c5:	83 c4 10             	add    $0x10,%esp
    return c;
c01016c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016cb:	c9                   	leave  
c01016cc:	c3                   	ret    

c01016cd <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016cd:	55                   	push   %ebp
c01016ce:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c01016d0:	fb                   	sti    
}
c01016d1:	90                   	nop
    sti();
}
c01016d2:	90                   	nop
c01016d3:	5d                   	pop    %ebp
c01016d4:	c3                   	ret    

c01016d5 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016d5:	55                   	push   %ebp
c01016d6:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c01016d8:	fa                   	cli    
}
c01016d9:	90                   	nop
    cli();
}
c01016da:	90                   	nop
c01016db:	5d                   	pop    %ebp
c01016dc:	c3                   	ret    

c01016dd <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016dd:	55                   	push   %ebp
c01016de:	89 e5                	mov    %esp,%ebp
c01016e0:	83 ec 14             	sub    $0x14,%esp
c01016e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016e6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ee:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c01016f4:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c01016f9:	85 c0                	test   %eax,%eax
c01016fb:	74 38                	je     c0101735 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c01016fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101701:	0f b6 c0             	movzbl %al,%eax
c0101704:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c010170a:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010170d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101711:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101715:	ee                   	out    %al,(%dx)
}
c0101716:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c0101717:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010171b:	66 c1 e8 08          	shr    $0x8,%ax
c010171f:	0f b6 c0             	movzbl %al,%eax
c0101722:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c0101728:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010172b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010172f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101733:	ee                   	out    %al,(%dx)
}
c0101734:	90                   	nop
    }
}
c0101735:	90                   	nop
c0101736:	c9                   	leave  
c0101737:	c3                   	ret    

c0101738 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101738:	55                   	push   %ebp
c0101739:	89 e5                	mov    %esp,%ebp
    pic_setmask(irq_mask & ~(1 << irq));
c010173b:	8b 45 08             	mov    0x8(%ebp),%eax
c010173e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101743:	89 c1                	mov    %eax,%ecx
c0101745:	d3 e2                	shl    %cl,%edx
c0101747:	89 d0                	mov    %edx,%eax
c0101749:	f7 d0                	not    %eax
c010174b:	89 c2                	mov    %eax,%edx
c010174d:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101754:	21 d0                	and    %edx,%eax
c0101756:	0f b7 c0             	movzwl %ax,%eax
c0101759:	50                   	push   %eax
c010175a:	e8 7e ff ff ff       	call   c01016dd <pic_setmask>
c010175f:	83 c4 04             	add    $0x4,%esp
}
c0101762:	90                   	nop
c0101763:	c9                   	leave  
c0101764:	c3                   	ret    

c0101765 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101765:	55                   	push   %ebp
c0101766:	89 e5                	mov    %esp,%ebp
c0101768:	83 ec 40             	sub    $0x40,%esp
    did_init = 1;
c010176b:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c0101772:	00 00 00 
c0101775:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010177b:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010177f:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101783:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101787:	ee                   	out    %al,(%dx)
}
c0101788:	90                   	nop
c0101789:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010178f:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101793:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101797:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010179b:	ee                   	out    %al,(%dx)
}
c010179c:	90                   	nop
c010179d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01017a3:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01017ab:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01017af:	ee                   	out    %al,(%dx)
}
c01017b0:	90                   	nop
c01017b1:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c01017b7:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017bb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017bf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017c3:	ee                   	out    %al,(%dx)
}
c01017c4:	90                   	nop
c01017c5:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c01017cb:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017cf:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017d3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017d7:	ee                   	out    %al,(%dx)
}
c01017d8:	90                   	nop
c01017d9:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017df:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e3:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017e7:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017eb:	ee                   	out    %al,(%dx)
}
c01017ec:	90                   	nop
c01017ed:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017f3:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017f7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017fb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
}
c0101800:	90                   	nop
c0101801:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c0101807:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010180b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010180f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101813:	ee                   	out    %al,(%dx)
}
c0101814:	90                   	nop
c0101815:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c010181b:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010181f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101823:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101827:	ee                   	out    %al,(%dx)
}
c0101828:	90                   	nop
c0101829:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c010182f:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101833:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101837:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
}
c010183c:	90                   	nop
c010183d:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101843:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101847:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010184b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010184f:	ee                   	out    %al,(%dx)
}
c0101850:	90                   	nop
c0101851:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101857:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010185b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010185f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101863:	ee                   	out    %al,(%dx)
}
c0101864:	90                   	nop
c0101865:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010186b:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010186f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101873:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101877:	ee                   	out    %al,(%dx)
}
c0101878:	90                   	nop
c0101879:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010187f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101883:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101887:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010188b:	ee                   	out    %al,(%dx)
}
c010188c:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010188d:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101894:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101898:	74 13                	je     c01018ad <pic_init+0x148>
        pic_setmask(irq_mask);
c010189a:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c01018a1:	0f b7 c0             	movzwl %ax,%eax
c01018a4:	50                   	push   %eax
c01018a5:	e8 33 fe ff ff       	call   c01016dd <pic_setmask>
c01018aa:	83 c4 04             	add    $0x4,%esp
    }
}
c01018ad:	90                   	nop
c01018ae:	c9                   	leave  
c01018af:	c3                   	ret    

c01018b0 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01018b0:	55                   	push   %ebp
c01018b1:	89 e5                	mov    %esp,%ebp
c01018b3:	83 ec 08             	sub    $0x8,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018b6:	83 ec 08             	sub    $0x8,%esp
c01018b9:	6a 64                	push   $0x64
c01018bb:	68 00 5e 10 c0       	push   $0xc0105e00
c01018c0:	e8 6c ea ff ff       	call   c0100331 <cprintf>
c01018c5:	83 c4 10             	add    $0x10,%esp
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018c8:	83 ec 0c             	sub    $0xc,%esp
c01018cb:	68 0a 5e 10 c0       	push   $0xc0105e0a
c01018d0:	e8 5c ea ff ff       	call   c0100331 <cprintf>
c01018d5:	83 c4 10             	add    $0x10,%esp
    panic("EOT: kernel seems ok.");
c01018d8:	83 ec 04             	sub    $0x4,%esp
c01018db:	68 18 5e 10 c0       	push   $0xc0105e18
c01018e0:	6a 12                	push   $0x12
c01018e2:	68 2e 5e 10 c0       	push   $0xc0105e2e
c01018e7:	e8 a4 f3 ff ff       	call   c0100c90 <__panic>

c01018ec <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018ec:	55                   	push   %ebp
c01018ed:	89 e5                	mov    %esp,%ebp
c01018ef:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018f9:	e9 c3 00 00 00       	jmp    c01019c1 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101901:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c0101908:	89 c2                	mov    %eax,%edx
c010190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190d:	66 89 14 c5 80 b6 11 	mov    %dx,-0x3fee4980(,%eax,8)
c0101914:	c0 
c0101915:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101918:	66 c7 04 c5 82 b6 11 	movw   $0x8,-0x3fee497e(,%eax,8)
c010191f:	c0 08 00 
c0101922:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101925:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c010192c:	c0 
c010192d:	83 e2 e0             	and    $0xffffffe0,%edx
c0101930:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c0101937:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193a:	0f b6 14 c5 84 b6 11 	movzbl -0x3fee497c(,%eax,8),%edx
c0101941:	c0 
c0101942:	83 e2 1f             	and    $0x1f,%edx
c0101945:	88 14 c5 84 b6 11 c0 	mov    %dl,-0x3fee497c(,%eax,8)
c010194c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194f:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101956:	c0 
c0101957:	83 e2 f0             	and    $0xfffffff0,%edx
c010195a:	83 ca 0e             	or     $0xe,%edx
c010195d:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101964:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101967:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c010196e:	c0 
c010196f:	83 e2 ef             	and    $0xffffffef,%edx
c0101972:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c0101979:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197c:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101983:	c0 
c0101984:	83 e2 9f             	and    $0xffffff9f,%edx
c0101987:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c010198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101991:	0f b6 14 c5 85 b6 11 	movzbl -0x3fee497b(,%eax,8),%edx
c0101998:	c0 
c0101999:	83 ca 80             	or     $0xffffff80,%edx
c010199c:	88 14 c5 85 b6 11 c0 	mov    %dl,-0x3fee497b(,%eax,8)
c01019a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a6:	8b 04 85 e0 85 11 c0 	mov    -0x3fee7a20(,%eax,4),%eax
c01019ad:	c1 e8 10             	shr    $0x10,%eax
c01019b0:	89 c2                	mov    %eax,%edx
c01019b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b5:	66 89 14 c5 86 b6 11 	mov    %dx,-0x3fee497a(,%eax,8)
c01019bc:	c0 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c4:	3d ff 00 00 00       	cmp    $0xff,%eax
c01019c9:	0f 86 2f ff ff ff    	jbe    c01018fe <idt_init+0x12>
c01019cf:	c7 45 f8 60 85 11 c0 	movl   $0xc0118560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019d9:	0f 01 18             	lidtl  (%eax)
}
c01019dc:	90                   	nop
    }
    lidt(&idt_pd);
}
c01019dd:	90                   	nop
c01019de:	c9                   	leave  
c01019df:	c3                   	ret    

c01019e0 <trapname>:

static const char *
trapname(int trapno) {
c01019e0:	55                   	push   %ebp
c01019e1:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e6:	83 f8 13             	cmp    $0x13,%eax
c01019e9:	77 0c                	ja     c01019f7 <trapname+0x17>
        return excnames[trapno];
c01019eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ee:	8b 04 85 80 61 10 c0 	mov    -0x3fef9e80(,%eax,4),%eax
c01019f5:	eb 18                	jmp    c0101a0f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019f7:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019fb:	7e 0d                	jle    c0101a0a <trapname+0x2a>
c01019fd:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a01:	7f 07                	jg     c0101a0a <trapname+0x2a>
        return "Hardware Interrupt";
c0101a03:	b8 3f 5e 10 c0       	mov    $0xc0105e3f,%eax
c0101a08:	eb 05                	jmp    c0101a0f <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a0a:	b8 52 5e 10 c0       	mov    $0xc0105e52,%eax
}
c0101a0f:	5d                   	pop    %ebp
c0101a10:	c3                   	ret    

c0101a11 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a11:	55                   	push   %ebp
c0101a12:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a17:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a1b:	66 83 f8 08          	cmp    $0x8,%ax
c0101a1f:	0f 94 c0             	sete   %al
c0101a22:	0f b6 c0             	movzbl %al,%eax
}
c0101a25:	5d                   	pop    %ebp
c0101a26:	c3                   	ret    

c0101a27 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a27:	55                   	push   %ebp
c0101a28:	89 e5                	mov    %esp,%ebp
c0101a2a:	83 ec 18             	sub    $0x18,%esp
    cprintf("trapframe at %p\n", tf);
c0101a2d:	83 ec 08             	sub    $0x8,%esp
c0101a30:	ff 75 08             	push   0x8(%ebp)
c0101a33:	68 93 5e 10 c0       	push   $0xc0105e93
c0101a38:	e8 f4 e8 ff ff       	call   c0100331 <cprintf>
c0101a3d:	83 c4 10             	add    $0x10,%esp
    print_regs(&tf->tf_regs);
c0101a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a43:	83 ec 0c             	sub    $0xc,%esp
c0101a46:	50                   	push   %eax
c0101a47:	e8 b4 01 00 00       	call   c0101c00 <print_regs>
c0101a4c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a52:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a56:	0f b7 c0             	movzwl %ax,%eax
c0101a59:	83 ec 08             	sub    $0x8,%esp
c0101a5c:	50                   	push   %eax
c0101a5d:	68 a4 5e 10 c0       	push   $0xc0105ea4
c0101a62:	e8 ca e8 ff ff       	call   c0100331 <cprintf>
c0101a67:	83 c4 10             	add    $0x10,%esp
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a71:	0f b7 c0             	movzwl %ax,%eax
c0101a74:	83 ec 08             	sub    $0x8,%esp
c0101a77:	50                   	push   %eax
c0101a78:	68 b7 5e 10 c0       	push   $0xc0105eb7
c0101a7d:	e8 af e8 ff ff       	call   c0100331 <cprintf>
c0101a82:	83 c4 10             	add    $0x10,%esp
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a88:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a8c:	0f b7 c0             	movzwl %ax,%eax
c0101a8f:	83 ec 08             	sub    $0x8,%esp
c0101a92:	50                   	push   %eax
c0101a93:	68 ca 5e 10 c0       	push   $0xc0105eca
c0101a98:	e8 94 e8 ff ff       	call   c0100331 <cprintf>
c0101a9d:	83 c4 10             	add    $0x10,%esp
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa3:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101aa7:	0f b7 c0             	movzwl %ax,%eax
c0101aaa:	83 ec 08             	sub    $0x8,%esp
c0101aad:	50                   	push   %eax
c0101aae:	68 dd 5e 10 c0       	push   $0xc0105edd
c0101ab3:	e8 79 e8 ff ff       	call   c0100331 <cprintf>
c0101ab8:	83 c4 10             	add    $0x10,%esp
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101abe:	8b 40 30             	mov    0x30(%eax),%eax
c0101ac1:	83 ec 0c             	sub    $0xc,%esp
c0101ac4:	50                   	push   %eax
c0101ac5:	e8 16 ff ff ff       	call   c01019e0 <trapname>
c0101aca:	83 c4 10             	add    $0x10,%esp
c0101acd:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ad0:	8b 52 30             	mov    0x30(%edx),%edx
c0101ad3:	83 ec 04             	sub    $0x4,%esp
c0101ad6:	50                   	push   %eax
c0101ad7:	52                   	push   %edx
c0101ad8:	68 f0 5e 10 c0       	push   $0xc0105ef0
c0101add:	e8 4f e8 ff ff       	call   c0100331 <cprintf>
c0101ae2:	83 c4 10             	add    $0x10,%esp
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae8:	8b 40 34             	mov    0x34(%eax),%eax
c0101aeb:	83 ec 08             	sub    $0x8,%esp
c0101aee:	50                   	push   %eax
c0101aef:	68 02 5f 10 c0       	push   $0xc0105f02
c0101af4:	e8 38 e8 ff ff       	call   c0100331 <cprintf>
c0101af9:	83 c4 10             	add    $0x10,%esp
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aff:	8b 40 38             	mov    0x38(%eax),%eax
c0101b02:	83 ec 08             	sub    $0x8,%esp
c0101b05:	50                   	push   %eax
c0101b06:	68 11 5f 10 c0       	push   $0xc0105f11
c0101b0b:	e8 21 e8 ff ff       	call   c0100331 <cprintf>
c0101b10:	83 c4 10             	add    $0x10,%esp
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b16:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b1a:	0f b7 c0             	movzwl %ax,%eax
c0101b1d:	83 ec 08             	sub    $0x8,%esp
c0101b20:	50                   	push   %eax
c0101b21:	68 20 5f 10 c0       	push   $0xc0105f20
c0101b26:	e8 06 e8 ff ff       	call   c0100331 <cprintf>
c0101b2b:	83 c4 10             	add    $0x10,%esp
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b31:	8b 40 40             	mov    0x40(%eax),%eax
c0101b34:	83 ec 08             	sub    $0x8,%esp
c0101b37:	50                   	push   %eax
c0101b38:	68 33 5f 10 c0       	push   $0xc0105f33
c0101b3d:	e8 ef e7 ff ff       	call   c0100331 <cprintf>
c0101b42:	83 c4 10             	add    $0x10,%esp

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b4c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b53:	eb 3f                	jmp    c0101b94 <print_trapframe+0x16d>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b58:	8b 50 40             	mov    0x40(%eax),%edx
c0101b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b5e:	21 d0                	and    %edx,%eax
c0101b60:	85 c0                	test   %eax,%eax
c0101b62:	74 29                	je     c0101b8d <print_trapframe+0x166>
c0101b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b67:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101b6e:	85 c0                	test   %eax,%eax
c0101b70:	74 1b                	je     c0101b8d <print_trapframe+0x166>
            cprintf("%s,", IA32flags[i]);
c0101b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b75:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101b7c:	83 ec 08             	sub    $0x8,%esp
c0101b7f:	50                   	push   %eax
c0101b80:	68 42 5f 10 c0       	push   $0xc0105f42
c0101b85:	e8 a7 e7 ff ff       	call   c0100331 <cprintf>
c0101b8a:	83 c4 10             	add    $0x10,%esp
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b8d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b91:	d1 65 f0             	shll   -0x10(%ebp)
c0101b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b97:	83 f8 17             	cmp    $0x17,%eax
c0101b9a:	76 b9                	jbe    c0101b55 <print_trapframe+0x12e>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9f:	8b 40 40             	mov    0x40(%eax),%eax
c0101ba2:	c1 e8 0c             	shr    $0xc,%eax
c0101ba5:	83 e0 03             	and    $0x3,%eax
c0101ba8:	83 ec 08             	sub    $0x8,%esp
c0101bab:	50                   	push   %eax
c0101bac:	68 46 5f 10 c0       	push   $0xc0105f46
c0101bb1:	e8 7b e7 ff ff       	call   c0100331 <cprintf>
c0101bb6:	83 c4 10             	add    $0x10,%esp

    if (!trap_in_kernel(tf)) {
c0101bb9:	83 ec 0c             	sub    $0xc,%esp
c0101bbc:	ff 75 08             	push   0x8(%ebp)
c0101bbf:	e8 4d fe ff ff       	call   c0101a11 <trap_in_kernel>
c0101bc4:	83 c4 10             	add    $0x10,%esp
c0101bc7:	85 c0                	test   %eax,%eax
c0101bc9:	75 32                	jne    c0101bfd <print_trapframe+0x1d6>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	8b 40 44             	mov    0x44(%eax),%eax
c0101bd1:	83 ec 08             	sub    $0x8,%esp
c0101bd4:	50                   	push   %eax
c0101bd5:	68 4f 5f 10 c0       	push   $0xc0105f4f
c0101bda:	e8 52 e7 ff ff       	call   c0100331 <cprintf>
c0101bdf:	83 c4 10             	add    $0x10,%esp
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101be2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101be9:	0f b7 c0             	movzwl %ax,%eax
c0101bec:	83 ec 08             	sub    $0x8,%esp
c0101bef:	50                   	push   %eax
c0101bf0:	68 5e 5f 10 c0       	push   $0xc0105f5e
c0101bf5:	e8 37 e7 ff ff       	call   c0100331 <cprintf>
c0101bfa:	83 c4 10             	add    $0x10,%esp
    }
}
c0101bfd:	90                   	nop
c0101bfe:	c9                   	leave  
c0101bff:	c3                   	ret    

c0101c00 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c00:	55                   	push   %ebp
c0101c01:	89 e5                	mov    %esp,%ebp
c0101c03:	83 ec 08             	sub    $0x8,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c09:	8b 00                	mov    (%eax),%eax
c0101c0b:	83 ec 08             	sub    $0x8,%esp
c0101c0e:	50                   	push   %eax
c0101c0f:	68 71 5f 10 c0       	push   $0xc0105f71
c0101c14:	e8 18 e7 ff ff       	call   c0100331 <cprintf>
c0101c19:	83 c4 10             	add    $0x10,%esp
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1f:	8b 40 04             	mov    0x4(%eax),%eax
c0101c22:	83 ec 08             	sub    $0x8,%esp
c0101c25:	50                   	push   %eax
c0101c26:	68 80 5f 10 c0       	push   $0xc0105f80
c0101c2b:	e8 01 e7 ff ff       	call   c0100331 <cprintf>
c0101c30:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c36:	8b 40 08             	mov    0x8(%eax),%eax
c0101c39:	83 ec 08             	sub    $0x8,%esp
c0101c3c:	50                   	push   %eax
c0101c3d:	68 8f 5f 10 c0       	push   $0xc0105f8f
c0101c42:	e8 ea e6 ff ff       	call   c0100331 <cprintf>
c0101c47:	83 c4 10             	add    $0x10,%esp
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c50:	83 ec 08             	sub    $0x8,%esp
c0101c53:	50                   	push   %eax
c0101c54:	68 9e 5f 10 c0       	push   $0xc0105f9e
c0101c59:	e8 d3 e6 ff ff       	call   c0100331 <cprintf>
c0101c5e:	83 c4 10             	add    $0x10,%esp
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c64:	8b 40 10             	mov    0x10(%eax),%eax
c0101c67:	83 ec 08             	sub    $0x8,%esp
c0101c6a:	50                   	push   %eax
c0101c6b:	68 ad 5f 10 c0       	push   $0xc0105fad
c0101c70:	e8 bc e6 ff ff       	call   c0100331 <cprintf>
c0101c75:	83 c4 10             	add    $0x10,%esp
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c7b:	8b 40 14             	mov    0x14(%eax),%eax
c0101c7e:	83 ec 08             	sub    $0x8,%esp
c0101c81:	50                   	push   %eax
c0101c82:	68 bc 5f 10 c0       	push   $0xc0105fbc
c0101c87:	e8 a5 e6 ff ff       	call   c0100331 <cprintf>
c0101c8c:	83 c4 10             	add    $0x10,%esp
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c92:	8b 40 18             	mov    0x18(%eax),%eax
c0101c95:	83 ec 08             	sub    $0x8,%esp
c0101c98:	50                   	push   %eax
c0101c99:	68 cb 5f 10 c0       	push   $0xc0105fcb
c0101c9e:	e8 8e e6 ff ff       	call   c0100331 <cprintf>
c0101ca3:	83 c4 10             	add    $0x10,%esp
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101ca6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cac:	83 ec 08             	sub    $0x8,%esp
c0101caf:	50                   	push   %eax
c0101cb0:	68 da 5f 10 c0       	push   $0xc0105fda
c0101cb5:	e8 77 e6 ff ff       	call   c0100331 <cprintf>
c0101cba:	83 c4 10             	add    $0x10,%esp
}
c0101cbd:	90                   	nop
c0101cbe:	c9                   	leave  
c0101cbf:	c3                   	ret    

c0101cc0 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cc0:	55                   	push   %ebp
c0101cc1:	89 e5                	mov    %esp,%ebp
c0101cc3:	83 ec 18             	sub    $0x18,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc9:	8b 40 30             	mov    0x30(%eax),%eax
c0101ccc:	83 f8 79             	cmp    $0x79,%eax
c0101ccf:	0f 87 d1 00 00 00    	ja     c0101da6 <trap_dispatch+0xe6>
c0101cd5:	83 f8 78             	cmp    $0x78,%eax
c0101cd8:	0f 83 b1 00 00 00    	jae    c0101d8f <trap_dispatch+0xcf>
c0101cde:	83 f8 2f             	cmp    $0x2f,%eax
c0101ce1:	0f 87 bf 00 00 00    	ja     c0101da6 <trap_dispatch+0xe6>
c0101ce7:	83 f8 2e             	cmp    $0x2e,%eax
c0101cea:	0f 83 ec 00 00 00    	jae    c0101ddc <trap_dispatch+0x11c>
c0101cf0:	83 f8 24             	cmp    $0x24,%eax
c0101cf3:	74 52                	je     c0101d47 <trap_dispatch+0x87>
c0101cf5:	83 f8 24             	cmp    $0x24,%eax
c0101cf8:	0f 87 a8 00 00 00    	ja     c0101da6 <trap_dispatch+0xe6>
c0101cfe:	83 f8 20             	cmp    $0x20,%eax
c0101d01:	74 0a                	je     c0101d0d <trap_dispatch+0x4d>
c0101d03:	83 f8 21             	cmp    $0x21,%eax
c0101d06:	74 63                	je     c0101d6b <trap_dispatch+0xab>
c0101d08:	e9 99 00 00 00       	jmp    c0101da6 <trap_dispatch+0xe6>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d0d:	a1 24 b4 11 c0       	mov    0xc011b424,%eax
c0101d12:	83 c0 01             	add    $0x1,%eax
c0101d15:	a3 24 b4 11 c0       	mov    %eax,0xc011b424
        if (ticks % TICK_NUM == 0) {
c0101d1a:	8b 0d 24 b4 11 c0    	mov    0xc011b424,%ecx
c0101d20:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d25:	89 c8                	mov    %ecx,%eax
c0101d27:	f7 e2                	mul    %edx
c0101d29:	89 d0                	mov    %edx,%eax
c0101d2b:	c1 e8 05             	shr    $0x5,%eax
c0101d2e:	6b d0 64             	imul   $0x64,%eax,%edx
c0101d31:	89 c8                	mov    %ecx,%eax
c0101d33:	29 d0                	sub    %edx,%eax
c0101d35:	85 c0                	test   %eax,%eax
c0101d37:	0f 85 a2 00 00 00    	jne    c0101ddf <trap_dispatch+0x11f>
            print_ticks();
c0101d3d:	e8 6e fb ff ff       	call   c01018b0 <print_ticks>
        }
        break;
c0101d42:	e9 98 00 00 00       	jmp    c0101ddf <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d47:	e8 0f f9 ff ff       	call   c010165b <cons_getc>
c0101d4c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d4f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d53:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d57:	83 ec 04             	sub    $0x4,%esp
c0101d5a:	52                   	push   %edx
c0101d5b:	50                   	push   %eax
c0101d5c:	68 e9 5f 10 c0       	push   $0xc0105fe9
c0101d61:	e8 cb e5 ff ff       	call   c0100331 <cprintf>
c0101d66:	83 c4 10             	add    $0x10,%esp
        break;
c0101d69:	eb 75                	jmp    c0101de0 <trap_dispatch+0x120>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d6b:	e8 eb f8 ff ff       	call   c010165b <cons_getc>
c0101d70:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d73:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d77:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d7b:	83 ec 04             	sub    $0x4,%esp
c0101d7e:	52                   	push   %edx
c0101d7f:	50                   	push   %eax
c0101d80:	68 fb 5f 10 c0       	push   $0xc0105ffb
c0101d85:	e8 a7 e5 ff ff       	call   c0100331 <cprintf>
c0101d8a:	83 c4 10             	add    $0x10,%esp
        break;
c0101d8d:	eb 51                	jmp    c0101de0 <trap_dispatch+0x120>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d8f:	83 ec 04             	sub    $0x4,%esp
c0101d92:	68 0a 60 10 c0       	push   $0xc010600a
c0101d97:	68 ac 00 00 00       	push   $0xac
c0101d9c:	68 2e 5e 10 c0       	push   $0xc0105e2e
c0101da1:	e8 ea ee ff ff       	call   c0100c90 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dad:	0f b7 c0             	movzwl %ax,%eax
c0101db0:	83 e0 03             	and    $0x3,%eax
c0101db3:	85 c0                	test   %eax,%eax
c0101db5:	75 29                	jne    c0101de0 <trap_dispatch+0x120>
            print_trapframe(tf);
c0101db7:	83 ec 0c             	sub    $0xc,%esp
c0101dba:	ff 75 08             	push   0x8(%ebp)
c0101dbd:	e8 65 fc ff ff       	call   c0101a27 <print_trapframe>
c0101dc2:	83 c4 10             	add    $0x10,%esp
            panic("unexpected trap in kernel.\n");
c0101dc5:	83 ec 04             	sub    $0x4,%esp
c0101dc8:	68 1a 60 10 c0       	push   $0xc010601a
c0101dcd:	68 b6 00 00 00       	push   $0xb6
c0101dd2:	68 2e 5e 10 c0       	push   $0xc0105e2e
c0101dd7:	e8 b4 ee ff ff       	call   c0100c90 <__panic>
        break;
c0101ddc:	90                   	nop
c0101ddd:	eb 01                	jmp    c0101de0 <trap_dispatch+0x120>
        break;
c0101ddf:	90                   	nop
        }
    }
}
c0101de0:	90                   	nop
c0101de1:	c9                   	leave  
c0101de2:	c3                   	ret    

c0101de3 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101de3:	55                   	push   %ebp
c0101de4:	89 e5                	mov    %esp,%ebp
c0101de6:	83 ec 08             	sub    $0x8,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101de9:	83 ec 0c             	sub    $0xc,%esp
c0101dec:	ff 75 08             	push   0x8(%ebp)
c0101def:	e8 cc fe ff ff       	call   c0101cc0 <trap_dispatch>
c0101df4:	83 c4 10             	add    $0x10,%esp
}
c0101df7:	90                   	nop
c0101df8:	c9                   	leave  
c0101df9:	c3                   	ret    

c0101dfa <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101dfa:	1e                   	push   %ds
    pushl %es
c0101dfb:	06                   	push   %es
    pushl %fs
c0101dfc:	0f a0                	push   %fs
    pushl %gs
c0101dfe:	0f a8                	push   %gs
    pushal
c0101e00:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e01:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e06:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e08:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e0a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e0b:	e8 d3 ff ff ff       	call   c0101de3 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e10:	5c                   	pop    %esp

c0101e11 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e11:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e12:	0f a9                	pop    %gs
    popl %fs
c0101e14:	0f a1                	pop    %fs
    popl %es
c0101e16:	07                   	pop    %es
    popl %ds
c0101e17:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e18:	83 c4 08             	add    $0x8,%esp
    iret
c0101e1b:	cf                   	iret   

c0101e1c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e1c:	6a 00                	push   $0x0
  pushl $0
c0101e1e:	6a 00                	push   $0x0
  jmp __alltraps
c0101e20:	e9 d5 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e25 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e25:	6a 00                	push   $0x0
  pushl $1
c0101e27:	6a 01                	push   $0x1
  jmp __alltraps
c0101e29:	e9 cc ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e2e <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e2e:	6a 00                	push   $0x0
  pushl $2
c0101e30:	6a 02                	push   $0x2
  jmp __alltraps
c0101e32:	e9 c3 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e37 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e37:	6a 00                	push   $0x0
  pushl $3
c0101e39:	6a 03                	push   $0x3
  jmp __alltraps
c0101e3b:	e9 ba ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e40 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e40:	6a 00                	push   $0x0
  pushl $4
c0101e42:	6a 04                	push   $0x4
  jmp __alltraps
c0101e44:	e9 b1 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e49 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e49:	6a 00                	push   $0x0
  pushl $5
c0101e4b:	6a 05                	push   $0x5
  jmp __alltraps
c0101e4d:	e9 a8 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e52 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e52:	6a 00                	push   $0x0
  pushl $6
c0101e54:	6a 06                	push   $0x6
  jmp __alltraps
c0101e56:	e9 9f ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e5b <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e5b:	6a 00                	push   $0x0
  pushl $7
c0101e5d:	6a 07                	push   $0x7
  jmp __alltraps
c0101e5f:	e9 96 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e64 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e64:	6a 08                	push   $0x8
  jmp __alltraps
c0101e66:	e9 8f ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e6b <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e6b:	6a 09                	push   $0x9
  jmp __alltraps
c0101e6d:	e9 88 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e72 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e72:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e74:	e9 81 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e79 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e79:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e7b:	e9 7a ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e80 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e80:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e82:	e9 73 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e87 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e87:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e89:	e9 6c ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e8e <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e8e:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e90:	e9 65 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e95 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e95:	6a 00                	push   $0x0
  pushl $15
c0101e97:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e99:	e9 5c ff ff ff       	jmp    c0101dfa <__alltraps>

c0101e9e <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e9e:	6a 00                	push   $0x0
  pushl $16
c0101ea0:	6a 10                	push   $0x10
  jmp __alltraps
c0101ea2:	e9 53 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ea7 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ea7:	6a 11                	push   $0x11
  jmp __alltraps
c0101ea9:	e9 4c ff ff ff       	jmp    c0101dfa <__alltraps>

c0101eae <vector18>:
.globl vector18
vector18:
  pushl $0
c0101eae:	6a 00                	push   $0x0
  pushl $18
c0101eb0:	6a 12                	push   $0x12
  jmp __alltraps
c0101eb2:	e9 43 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101eb7 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101eb7:	6a 00                	push   $0x0
  pushl $19
c0101eb9:	6a 13                	push   $0x13
  jmp __alltraps
c0101ebb:	e9 3a ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ec0 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ec0:	6a 00                	push   $0x0
  pushl $20
c0101ec2:	6a 14                	push   $0x14
  jmp __alltraps
c0101ec4:	e9 31 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ec9 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ec9:	6a 00                	push   $0x0
  pushl $21
c0101ecb:	6a 15                	push   $0x15
  jmp __alltraps
c0101ecd:	e9 28 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ed2 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ed2:	6a 00                	push   $0x0
  pushl $22
c0101ed4:	6a 16                	push   $0x16
  jmp __alltraps
c0101ed6:	e9 1f ff ff ff       	jmp    c0101dfa <__alltraps>

c0101edb <vector23>:
.globl vector23
vector23:
  pushl $0
c0101edb:	6a 00                	push   $0x0
  pushl $23
c0101edd:	6a 17                	push   $0x17
  jmp __alltraps
c0101edf:	e9 16 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ee4 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ee4:	6a 00                	push   $0x0
  pushl $24
c0101ee6:	6a 18                	push   $0x18
  jmp __alltraps
c0101ee8:	e9 0d ff ff ff       	jmp    c0101dfa <__alltraps>

c0101eed <vector25>:
.globl vector25
vector25:
  pushl $0
c0101eed:	6a 00                	push   $0x0
  pushl $25
c0101eef:	6a 19                	push   $0x19
  jmp __alltraps
c0101ef1:	e9 04 ff ff ff       	jmp    c0101dfa <__alltraps>

c0101ef6 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101ef6:	6a 00                	push   $0x0
  pushl $26
c0101ef8:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101efa:	e9 fb fe ff ff       	jmp    c0101dfa <__alltraps>

c0101eff <vector27>:
.globl vector27
vector27:
  pushl $0
c0101eff:	6a 00                	push   $0x0
  pushl $27
c0101f01:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f03:	e9 f2 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f08 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f08:	6a 00                	push   $0x0
  pushl $28
c0101f0a:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f0c:	e9 e9 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f11 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f11:	6a 00                	push   $0x0
  pushl $29
c0101f13:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f15:	e9 e0 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f1a <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f1a:	6a 00                	push   $0x0
  pushl $30
c0101f1c:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f1e:	e9 d7 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f23 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f23:	6a 00                	push   $0x0
  pushl $31
c0101f25:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f27:	e9 ce fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f2c <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f2c:	6a 00                	push   $0x0
  pushl $32
c0101f2e:	6a 20                	push   $0x20
  jmp __alltraps
c0101f30:	e9 c5 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f35 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f35:	6a 00                	push   $0x0
  pushl $33
c0101f37:	6a 21                	push   $0x21
  jmp __alltraps
c0101f39:	e9 bc fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f3e <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f3e:	6a 00                	push   $0x0
  pushl $34
c0101f40:	6a 22                	push   $0x22
  jmp __alltraps
c0101f42:	e9 b3 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f47 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f47:	6a 00                	push   $0x0
  pushl $35
c0101f49:	6a 23                	push   $0x23
  jmp __alltraps
c0101f4b:	e9 aa fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f50 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f50:	6a 00                	push   $0x0
  pushl $36
c0101f52:	6a 24                	push   $0x24
  jmp __alltraps
c0101f54:	e9 a1 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f59 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f59:	6a 00                	push   $0x0
  pushl $37
c0101f5b:	6a 25                	push   $0x25
  jmp __alltraps
c0101f5d:	e9 98 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f62 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f62:	6a 00                	push   $0x0
  pushl $38
c0101f64:	6a 26                	push   $0x26
  jmp __alltraps
c0101f66:	e9 8f fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f6b <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f6b:	6a 00                	push   $0x0
  pushl $39
c0101f6d:	6a 27                	push   $0x27
  jmp __alltraps
c0101f6f:	e9 86 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f74 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f74:	6a 00                	push   $0x0
  pushl $40
c0101f76:	6a 28                	push   $0x28
  jmp __alltraps
c0101f78:	e9 7d fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f7d <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f7d:	6a 00                	push   $0x0
  pushl $41
c0101f7f:	6a 29                	push   $0x29
  jmp __alltraps
c0101f81:	e9 74 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f86 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f86:	6a 00                	push   $0x0
  pushl $42
c0101f88:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f8a:	e9 6b fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f8f <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f8f:	6a 00                	push   $0x0
  pushl $43
c0101f91:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f93:	e9 62 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101f98 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f98:	6a 00                	push   $0x0
  pushl $44
c0101f9a:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f9c:	e9 59 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fa1 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fa1:	6a 00                	push   $0x0
  pushl $45
c0101fa3:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fa5:	e9 50 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101faa <vector46>:
.globl vector46
vector46:
  pushl $0
c0101faa:	6a 00                	push   $0x0
  pushl $46
c0101fac:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fae:	e9 47 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fb3 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fb3:	6a 00                	push   $0x0
  pushl $47
c0101fb5:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fb7:	e9 3e fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fbc <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fbc:	6a 00                	push   $0x0
  pushl $48
c0101fbe:	6a 30                	push   $0x30
  jmp __alltraps
c0101fc0:	e9 35 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fc5 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fc5:	6a 00                	push   $0x0
  pushl $49
c0101fc7:	6a 31                	push   $0x31
  jmp __alltraps
c0101fc9:	e9 2c fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fce <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fce:	6a 00                	push   $0x0
  pushl $50
c0101fd0:	6a 32                	push   $0x32
  jmp __alltraps
c0101fd2:	e9 23 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fd7 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fd7:	6a 00                	push   $0x0
  pushl $51
c0101fd9:	6a 33                	push   $0x33
  jmp __alltraps
c0101fdb:	e9 1a fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fe0 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fe0:	6a 00                	push   $0x0
  pushl $52
c0101fe2:	6a 34                	push   $0x34
  jmp __alltraps
c0101fe4:	e9 11 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101fe9 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101fe9:	6a 00                	push   $0x0
  pushl $53
c0101feb:	6a 35                	push   $0x35
  jmp __alltraps
c0101fed:	e9 08 fe ff ff       	jmp    c0101dfa <__alltraps>

c0101ff2 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101ff2:	6a 00                	push   $0x0
  pushl $54
c0101ff4:	6a 36                	push   $0x36
  jmp __alltraps
c0101ff6:	e9 ff fd ff ff       	jmp    c0101dfa <__alltraps>

c0101ffb <vector55>:
.globl vector55
vector55:
  pushl $0
c0101ffb:	6a 00                	push   $0x0
  pushl $55
c0101ffd:	6a 37                	push   $0x37
  jmp __alltraps
c0101fff:	e9 f6 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102004 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102004:	6a 00                	push   $0x0
  pushl $56
c0102006:	6a 38                	push   $0x38
  jmp __alltraps
c0102008:	e9 ed fd ff ff       	jmp    c0101dfa <__alltraps>

c010200d <vector57>:
.globl vector57
vector57:
  pushl $0
c010200d:	6a 00                	push   $0x0
  pushl $57
c010200f:	6a 39                	push   $0x39
  jmp __alltraps
c0102011:	e9 e4 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102016 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102016:	6a 00                	push   $0x0
  pushl $58
c0102018:	6a 3a                	push   $0x3a
  jmp __alltraps
c010201a:	e9 db fd ff ff       	jmp    c0101dfa <__alltraps>

c010201f <vector59>:
.globl vector59
vector59:
  pushl $0
c010201f:	6a 00                	push   $0x0
  pushl $59
c0102021:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102023:	e9 d2 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102028 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102028:	6a 00                	push   $0x0
  pushl $60
c010202a:	6a 3c                	push   $0x3c
  jmp __alltraps
c010202c:	e9 c9 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102031 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102031:	6a 00                	push   $0x0
  pushl $61
c0102033:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102035:	e9 c0 fd ff ff       	jmp    c0101dfa <__alltraps>

c010203a <vector62>:
.globl vector62
vector62:
  pushl $0
c010203a:	6a 00                	push   $0x0
  pushl $62
c010203c:	6a 3e                	push   $0x3e
  jmp __alltraps
c010203e:	e9 b7 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102043 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102043:	6a 00                	push   $0x0
  pushl $63
c0102045:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102047:	e9 ae fd ff ff       	jmp    c0101dfa <__alltraps>

c010204c <vector64>:
.globl vector64
vector64:
  pushl $0
c010204c:	6a 00                	push   $0x0
  pushl $64
c010204e:	6a 40                	push   $0x40
  jmp __alltraps
c0102050:	e9 a5 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102055 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102055:	6a 00                	push   $0x0
  pushl $65
c0102057:	6a 41                	push   $0x41
  jmp __alltraps
c0102059:	e9 9c fd ff ff       	jmp    c0101dfa <__alltraps>

c010205e <vector66>:
.globl vector66
vector66:
  pushl $0
c010205e:	6a 00                	push   $0x0
  pushl $66
c0102060:	6a 42                	push   $0x42
  jmp __alltraps
c0102062:	e9 93 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102067 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102067:	6a 00                	push   $0x0
  pushl $67
c0102069:	6a 43                	push   $0x43
  jmp __alltraps
c010206b:	e9 8a fd ff ff       	jmp    c0101dfa <__alltraps>

c0102070 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102070:	6a 00                	push   $0x0
  pushl $68
c0102072:	6a 44                	push   $0x44
  jmp __alltraps
c0102074:	e9 81 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102079 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102079:	6a 00                	push   $0x0
  pushl $69
c010207b:	6a 45                	push   $0x45
  jmp __alltraps
c010207d:	e9 78 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102082 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102082:	6a 00                	push   $0x0
  pushl $70
c0102084:	6a 46                	push   $0x46
  jmp __alltraps
c0102086:	e9 6f fd ff ff       	jmp    c0101dfa <__alltraps>

c010208b <vector71>:
.globl vector71
vector71:
  pushl $0
c010208b:	6a 00                	push   $0x0
  pushl $71
c010208d:	6a 47                	push   $0x47
  jmp __alltraps
c010208f:	e9 66 fd ff ff       	jmp    c0101dfa <__alltraps>

c0102094 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102094:	6a 00                	push   $0x0
  pushl $72
c0102096:	6a 48                	push   $0x48
  jmp __alltraps
c0102098:	e9 5d fd ff ff       	jmp    c0101dfa <__alltraps>

c010209d <vector73>:
.globl vector73
vector73:
  pushl $0
c010209d:	6a 00                	push   $0x0
  pushl $73
c010209f:	6a 49                	push   $0x49
  jmp __alltraps
c01020a1:	e9 54 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020a6 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020a6:	6a 00                	push   $0x0
  pushl $74
c01020a8:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020aa:	e9 4b fd ff ff       	jmp    c0101dfa <__alltraps>

c01020af <vector75>:
.globl vector75
vector75:
  pushl $0
c01020af:	6a 00                	push   $0x0
  pushl $75
c01020b1:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020b3:	e9 42 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020b8 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020b8:	6a 00                	push   $0x0
  pushl $76
c01020ba:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020bc:	e9 39 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020c1 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020c1:	6a 00                	push   $0x0
  pushl $77
c01020c3:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020c5:	e9 30 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020ca <vector78>:
.globl vector78
vector78:
  pushl $0
c01020ca:	6a 00                	push   $0x0
  pushl $78
c01020cc:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020ce:	e9 27 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020d3 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020d3:	6a 00                	push   $0x0
  pushl $79
c01020d5:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020d7:	e9 1e fd ff ff       	jmp    c0101dfa <__alltraps>

c01020dc <vector80>:
.globl vector80
vector80:
  pushl $0
c01020dc:	6a 00                	push   $0x0
  pushl $80
c01020de:	6a 50                	push   $0x50
  jmp __alltraps
c01020e0:	e9 15 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020e5 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020e5:	6a 00                	push   $0x0
  pushl $81
c01020e7:	6a 51                	push   $0x51
  jmp __alltraps
c01020e9:	e9 0c fd ff ff       	jmp    c0101dfa <__alltraps>

c01020ee <vector82>:
.globl vector82
vector82:
  pushl $0
c01020ee:	6a 00                	push   $0x0
  pushl $82
c01020f0:	6a 52                	push   $0x52
  jmp __alltraps
c01020f2:	e9 03 fd ff ff       	jmp    c0101dfa <__alltraps>

c01020f7 <vector83>:
.globl vector83
vector83:
  pushl $0
c01020f7:	6a 00                	push   $0x0
  pushl $83
c01020f9:	6a 53                	push   $0x53
  jmp __alltraps
c01020fb:	e9 fa fc ff ff       	jmp    c0101dfa <__alltraps>

c0102100 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102100:	6a 00                	push   $0x0
  pushl $84
c0102102:	6a 54                	push   $0x54
  jmp __alltraps
c0102104:	e9 f1 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102109 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102109:	6a 00                	push   $0x0
  pushl $85
c010210b:	6a 55                	push   $0x55
  jmp __alltraps
c010210d:	e9 e8 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102112 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102112:	6a 00                	push   $0x0
  pushl $86
c0102114:	6a 56                	push   $0x56
  jmp __alltraps
c0102116:	e9 df fc ff ff       	jmp    c0101dfa <__alltraps>

c010211b <vector87>:
.globl vector87
vector87:
  pushl $0
c010211b:	6a 00                	push   $0x0
  pushl $87
c010211d:	6a 57                	push   $0x57
  jmp __alltraps
c010211f:	e9 d6 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102124 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102124:	6a 00                	push   $0x0
  pushl $88
c0102126:	6a 58                	push   $0x58
  jmp __alltraps
c0102128:	e9 cd fc ff ff       	jmp    c0101dfa <__alltraps>

c010212d <vector89>:
.globl vector89
vector89:
  pushl $0
c010212d:	6a 00                	push   $0x0
  pushl $89
c010212f:	6a 59                	push   $0x59
  jmp __alltraps
c0102131:	e9 c4 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102136 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102136:	6a 00                	push   $0x0
  pushl $90
c0102138:	6a 5a                	push   $0x5a
  jmp __alltraps
c010213a:	e9 bb fc ff ff       	jmp    c0101dfa <__alltraps>

c010213f <vector91>:
.globl vector91
vector91:
  pushl $0
c010213f:	6a 00                	push   $0x0
  pushl $91
c0102141:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102143:	e9 b2 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102148 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102148:	6a 00                	push   $0x0
  pushl $92
c010214a:	6a 5c                	push   $0x5c
  jmp __alltraps
c010214c:	e9 a9 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102151 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102151:	6a 00                	push   $0x0
  pushl $93
c0102153:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102155:	e9 a0 fc ff ff       	jmp    c0101dfa <__alltraps>

c010215a <vector94>:
.globl vector94
vector94:
  pushl $0
c010215a:	6a 00                	push   $0x0
  pushl $94
c010215c:	6a 5e                	push   $0x5e
  jmp __alltraps
c010215e:	e9 97 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102163 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102163:	6a 00                	push   $0x0
  pushl $95
c0102165:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102167:	e9 8e fc ff ff       	jmp    c0101dfa <__alltraps>

c010216c <vector96>:
.globl vector96
vector96:
  pushl $0
c010216c:	6a 00                	push   $0x0
  pushl $96
c010216e:	6a 60                	push   $0x60
  jmp __alltraps
c0102170:	e9 85 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102175 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102175:	6a 00                	push   $0x0
  pushl $97
c0102177:	6a 61                	push   $0x61
  jmp __alltraps
c0102179:	e9 7c fc ff ff       	jmp    c0101dfa <__alltraps>

c010217e <vector98>:
.globl vector98
vector98:
  pushl $0
c010217e:	6a 00                	push   $0x0
  pushl $98
c0102180:	6a 62                	push   $0x62
  jmp __alltraps
c0102182:	e9 73 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102187 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102187:	6a 00                	push   $0x0
  pushl $99
c0102189:	6a 63                	push   $0x63
  jmp __alltraps
c010218b:	e9 6a fc ff ff       	jmp    c0101dfa <__alltraps>

c0102190 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102190:	6a 00                	push   $0x0
  pushl $100
c0102192:	6a 64                	push   $0x64
  jmp __alltraps
c0102194:	e9 61 fc ff ff       	jmp    c0101dfa <__alltraps>

c0102199 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102199:	6a 00                	push   $0x0
  pushl $101
c010219b:	6a 65                	push   $0x65
  jmp __alltraps
c010219d:	e9 58 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021a2 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021a2:	6a 00                	push   $0x0
  pushl $102
c01021a4:	6a 66                	push   $0x66
  jmp __alltraps
c01021a6:	e9 4f fc ff ff       	jmp    c0101dfa <__alltraps>

c01021ab <vector103>:
.globl vector103
vector103:
  pushl $0
c01021ab:	6a 00                	push   $0x0
  pushl $103
c01021ad:	6a 67                	push   $0x67
  jmp __alltraps
c01021af:	e9 46 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021b4 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021b4:	6a 00                	push   $0x0
  pushl $104
c01021b6:	6a 68                	push   $0x68
  jmp __alltraps
c01021b8:	e9 3d fc ff ff       	jmp    c0101dfa <__alltraps>

c01021bd <vector105>:
.globl vector105
vector105:
  pushl $0
c01021bd:	6a 00                	push   $0x0
  pushl $105
c01021bf:	6a 69                	push   $0x69
  jmp __alltraps
c01021c1:	e9 34 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021c6 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021c6:	6a 00                	push   $0x0
  pushl $106
c01021c8:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021ca:	e9 2b fc ff ff       	jmp    c0101dfa <__alltraps>

c01021cf <vector107>:
.globl vector107
vector107:
  pushl $0
c01021cf:	6a 00                	push   $0x0
  pushl $107
c01021d1:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021d3:	e9 22 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021d8 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021d8:	6a 00                	push   $0x0
  pushl $108
c01021da:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021dc:	e9 19 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021e1 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021e1:	6a 00                	push   $0x0
  pushl $109
c01021e3:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021e5:	e9 10 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021ea <vector110>:
.globl vector110
vector110:
  pushl $0
c01021ea:	6a 00                	push   $0x0
  pushl $110
c01021ec:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021ee:	e9 07 fc ff ff       	jmp    c0101dfa <__alltraps>

c01021f3 <vector111>:
.globl vector111
vector111:
  pushl $0
c01021f3:	6a 00                	push   $0x0
  pushl $111
c01021f5:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021f7:	e9 fe fb ff ff       	jmp    c0101dfa <__alltraps>

c01021fc <vector112>:
.globl vector112
vector112:
  pushl $0
c01021fc:	6a 00                	push   $0x0
  pushl $112
c01021fe:	6a 70                	push   $0x70
  jmp __alltraps
c0102200:	e9 f5 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102205 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102205:	6a 00                	push   $0x0
  pushl $113
c0102207:	6a 71                	push   $0x71
  jmp __alltraps
c0102209:	e9 ec fb ff ff       	jmp    c0101dfa <__alltraps>

c010220e <vector114>:
.globl vector114
vector114:
  pushl $0
c010220e:	6a 00                	push   $0x0
  pushl $114
c0102210:	6a 72                	push   $0x72
  jmp __alltraps
c0102212:	e9 e3 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102217 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102217:	6a 00                	push   $0x0
  pushl $115
c0102219:	6a 73                	push   $0x73
  jmp __alltraps
c010221b:	e9 da fb ff ff       	jmp    c0101dfa <__alltraps>

c0102220 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102220:	6a 00                	push   $0x0
  pushl $116
c0102222:	6a 74                	push   $0x74
  jmp __alltraps
c0102224:	e9 d1 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102229 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102229:	6a 00                	push   $0x0
  pushl $117
c010222b:	6a 75                	push   $0x75
  jmp __alltraps
c010222d:	e9 c8 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102232 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102232:	6a 00                	push   $0x0
  pushl $118
c0102234:	6a 76                	push   $0x76
  jmp __alltraps
c0102236:	e9 bf fb ff ff       	jmp    c0101dfa <__alltraps>

c010223b <vector119>:
.globl vector119
vector119:
  pushl $0
c010223b:	6a 00                	push   $0x0
  pushl $119
c010223d:	6a 77                	push   $0x77
  jmp __alltraps
c010223f:	e9 b6 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102244 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102244:	6a 00                	push   $0x0
  pushl $120
c0102246:	6a 78                	push   $0x78
  jmp __alltraps
c0102248:	e9 ad fb ff ff       	jmp    c0101dfa <__alltraps>

c010224d <vector121>:
.globl vector121
vector121:
  pushl $0
c010224d:	6a 00                	push   $0x0
  pushl $121
c010224f:	6a 79                	push   $0x79
  jmp __alltraps
c0102251:	e9 a4 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102256 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102256:	6a 00                	push   $0x0
  pushl $122
c0102258:	6a 7a                	push   $0x7a
  jmp __alltraps
c010225a:	e9 9b fb ff ff       	jmp    c0101dfa <__alltraps>

c010225f <vector123>:
.globl vector123
vector123:
  pushl $0
c010225f:	6a 00                	push   $0x0
  pushl $123
c0102261:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102263:	e9 92 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102268 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102268:	6a 00                	push   $0x0
  pushl $124
c010226a:	6a 7c                	push   $0x7c
  jmp __alltraps
c010226c:	e9 89 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102271 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102271:	6a 00                	push   $0x0
  pushl $125
c0102273:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102275:	e9 80 fb ff ff       	jmp    c0101dfa <__alltraps>

c010227a <vector126>:
.globl vector126
vector126:
  pushl $0
c010227a:	6a 00                	push   $0x0
  pushl $126
c010227c:	6a 7e                	push   $0x7e
  jmp __alltraps
c010227e:	e9 77 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102283 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102283:	6a 00                	push   $0x0
  pushl $127
c0102285:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102287:	e9 6e fb ff ff       	jmp    c0101dfa <__alltraps>

c010228c <vector128>:
.globl vector128
vector128:
  pushl $0
c010228c:	6a 00                	push   $0x0
  pushl $128
c010228e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102293:	e9 62 fb ff ff       	jmp    c0101dfa <__alltraps>

c0102298 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $129
c010229a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c010229f:	e9 56 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022a4 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022a4:	6a 00                	push   $0x0
  pushl $130
c01022a6:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022ab:	e9 4a fb ff ff       	jmp    c0101dfa <__alltraps>

c01022b0 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022b0:	6a 00                	push   $0x0
  pushl $131
c01022b2:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022b7:	e9 3e fb ff ff       	jmp    c0101dfa <__alltraps>

c01022bc <vector132>:
.globl vector132
vector132:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $132
c01022be:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022c3:	e9 32 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022c8 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022c8:	6a 00                	push   $0x0
  pushl $133
c01022ca:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022cf:	e9 26 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022d4 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022d4:	6a 00                	push   $0x0
  pushl $134
c01022d6:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022db:	e9 1a fb ff ff       	jmp    c0101dfa <__alltraps>

c01022e0 <vector135>:
.globl vector135
vector135:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $135
c01022e2:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022e7:	e9 0e fb ff ff       	jmp    c0101dfa <__alltraps>

c01022ec <vector136>:
.globl vector136
vector136:
  pushl $0
c01022ec:	6a 00                	push   $0x0
  pushl $136
c01022ee:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022f3:	e9 02 fb ff ff       	jmp    c0101dfa <__alltraps>

c01022f8 <vector137>:
.globl vector137
vector137:
  pushl $0
c01022f8:	6a 00                	push   $0x0
  pushl $137
c01022fa:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022ff:	e9 f6 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102304 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $138
c0102306:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010230b:	e9 ea fa ff ff       	jmp    c0101dfa <__alltraps>

c0102310 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102310:	6a 00                	push   $0x0
  pushl $139
c0102312:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102317:	e9 de fa ff ff       	jmp    c0101dfa <__alltraps>

c010231c <vector140>:
.globl vector140
vector140:
  pushl $0
c010231c:	6a 00                	push   $0x0
  pushl $140
c010231e:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102323:	e9 d2 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102328 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $141
c010232a:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010232f:	e9 c6 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102334 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102334:	6a 00                	push   $0x0
  pushl $142
c0102336:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010233b:	e9 ba fa ff ff       	jmp    c0101dfa <__alltraps>

c0102340 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102340:	6a 00                	push   $0x0
  pushl $143
c0102342:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102347:	e9 ae fa ff ff       	jmp    c0101dfa <__alltraps>

c010234c <vector144>:
.globl vector144
vector144:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $144
c010234e:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102353:	e9 a2 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102358 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102358:	6a 00                	push   $0x0
  pushl $145
c010235a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010235f:	e9 96 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102364 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102364:	6a 00                	push   $0x0
  pushl $146
c0102366:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010236b:	e9 8a fa ff ff       	jmp    c0101dfa <__alltraps>

c0102370 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $147
c0102372:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102377:	e9 7e fa ff ff       	jmp    c0101dfa <__alltraps>

c010237c <vector148>:
.globl vector148
vector148:
  pushl $0
c010237c:	6a 00                	push   $0x0
  pushl $148
c010237e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102383:	e9 72 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102388 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102388:	6a 00                	push   $0x0
  pushl $149
c010238a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c010238f:	e9 66 fa ff ff       	jmp    c0101dfa <__alltraps>

c0102394 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $150
c0102396:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010239b:	e9 5a fa ff ff       	jmp    c0101dfa <__alltraps>

c01023a0 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023a0:	6a 00                	push   $0x0
  pushl $151
c01023a2:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023a7:	e9 4e fa ff ff       	jmp    c0101dfa <__alltraps>

c01023ac <vector152>:
.globl vector152
vector152:
  pushl $0
c01023ac:	6a 00                	push   $0x0
  pushl $152
c01023ae:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023b3:	e9 42 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023b8 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $153
c01023ba:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023bf:	e9 36 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023c4 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023c4:	6a 00                	push   $0x0
  pushl $154
c01023c6:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023cb:	e9 2a fa ff ff       	jmp    c0101dfa <__alltraps>

c01023d0 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023d0:	6a 00                	push   $0x0
  pushl $155
c01023d2:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023d7:	e9 1e fa ff ff       	jmp    c0101dfa <__alltraps>

c01023dc <vector156>:
.globl vector156
vector156:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $156
c01023de:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023e3:	e9 12 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023e8 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023e8:	6a 00                	push   $0x0
  pushl $157
c01023ea:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023ef:	e9 06 fa ff ff       	jmp    c0101dfa <__alltraps>

c01023f4 <vector158>:
.globl vector158
vector158:
  pushl $0
c01023f4:	6a 00                	push   $0x0
  pushl $158
c01023f6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01023fb:	e9 fa f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102400 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $159
c0102402:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102407:	e9 ee f9 ff ff       	jmp    c0101dfa <__alltraps>

c010240c <vector160>:
.globl vector160
vector160:
  pushl $0
c010240c:	6a 00                	push   $0x0
  pushl $160
c010240e:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102413:	e9 e2 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102418 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102418:	6a 00                	push   $0x0
  pushl $161
c010241a:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010241f:	e9 d6 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102424 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $162
c0102426:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010242b:	e9 ca f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102430 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102430:	6a 00                	push   $0x0
  pushl $163
c0102432:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102437:	e9 be f9 ff ff       	jmp    c0101dfa <__alltraps>

c010243c <vector164>:
.globl vector164
vector164:
  pushl $0
c010243c:	6a 00                	push   $0x0
  pushl $164
c010243e:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102443:	e9 b2 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102448 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $165
c010244a:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010244f:	e9 a6 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102454 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102454:	6a 00                	push   $0x0
  pushl $166
c0102456:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010245b:	e9 9a f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102460 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102460:	6a 00                	push   $0x0
  pushl $167
c0102462:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102467:	e9 8e f9 ff ff       	jmp    c0101dfa <__alltraps>

c010246c <vector168>:
.globl vector168
vector168:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $168
c010246e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102473:	e9 82 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102478 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102478:	6a 00                	push   $0x0
  pushl $169
c010247a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c010247f:	e9 76 f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102484 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102484:	6a 00                	push   $0x0
  pushl $170
c0102486:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010248b:	e9 6a f9 ff ff       	jmp    c0101dfa <__alltraps>

c0102490 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $171
c0102492:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102497:	e9 5e f9 ff ff       	jmp    c0101dfa <__alltraps>

c010249c <vector172>:
.globl vector172
vector172:
  pushl $0
c010249c:	6a 00                	push   $0x0
  pushl $172
c010249e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024a3:	e9 52 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024a8 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024a8:	6a 00                	push   $0x0
  pushl $173
c01024aa:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024af:	e9 46 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024b4 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $174
c01024b6:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024bb:	e9 3a f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024c0 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024c0:	6a 00                	push   $0x0
  pushl $175
c01024c2:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024c7:	e9 2e f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024cc <vector176>:
.globl vector176
vector176:
  pushl $0
c01024cc:	6a 00                	push   $0x0
  pushl $176
c01024ce:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024d3:	e9 22 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024d8 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $177
c01024da:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024df:	e9 16 f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024e4 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024e4:	6a 00                	push   $0x0
  pushl $178
c01024e6:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024eb:	e9 0a f9 ff ff       	jmp    c0101dfa <__alltraps>

c01024f0 <vector179>:
.globl vector179
vector179:
  pushl $0
c01024f0:	6a 00                	push   $0x0
  pushl $179
c01024f2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024f7:	e9 fe f8 ff ff       	jmp    c0101dfa <__alltraps>

c01024fc <vector180>:
.globl vector180
vector180:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $180
c01024fe:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102503:	e9 f2 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102508 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102508:	6a 00                	push   $0x0
  pushl $181
c010250a:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010250f:	e9 e6 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102514 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102514:	6a 00                	push   $0x0
  pushl $182
c0102516:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010251b:	e9 da f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102520 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $183
c0102522:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102527:	e9 ce f8 ff ff       	jmp    c0101dfa <__alltraps>

c010252c <vector184>:
.globl vector184
vector184:
  pushl $0
c010252c:	6a 00                	push   $0x0
  pushl $184
c010252e:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102533:	e9 c2 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102538 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102538:	6a 00                	push   $0x0
  pushl $185
c010253a:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010253f:	e9 b6 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102544 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102544:	6a 00                	push   $0x0
  pushl $186
c0102546:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010254b:	e9 aa f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102550 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102550:	6a 00                	push   $0x0
  pushl $187
c0102552:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102557:	e9 9e f8 ff ff       	jmp    c0101dfa <__alltraps>

c010255c <vector188>:
.globl vector188
vector188:
  pushl $0
c010255c:	6a 00                	push   $0x0
  pushl $188
c010255e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102563:	e9 92 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102568 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102568:	6a 00                	push   $0x0
  pushl $189
c010256a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010256f:	e9 86 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102574 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102574:	6a 00                	push   $0x0
  pushl $190
c0102576:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010257b:	e9 7a f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102580 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102580:	6a 00                	push   $0x0
  pushl $191
c0102582:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102587:	e9 6e f8 ff ff       	jmp    c0101dfa <__alltraps>

c010258c <vector192>:
.globl vector192
vector192:
  pushl $0
c010258c:	6a 00                	push   $0x0
  pushl $192
c010258e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102593:	e9 62 f8 ff ff       	jmp    c0101dfa <__alltraps>

c0102598 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102598:	6a 00                	push   $0x0
  pushl $193
c010259a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c010259f:	e9 56 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025a4 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025a4:	6a 00                	push   $0x0
  pushl $194
c01025a6:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025ab:	e9 4a f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025b0 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025b0:	6a 00                	push   $0x0
  pushl $195
c01025b2:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025b7:	e9 3e f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025bc <vector196>:
.globl vector196
vector196:
  pushl $0
c01025bc:	6a 00                	push   $0x0
  pushl $196
c01025be:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025c3:	e9 32 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025c8 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025c8:	6a 00                	push   $0x0
  pushl $197
c01025ca:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025cf:	e9 26 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025d4 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025d4:	6a 00                	push   $0x0
  pushl $198
c01025d6:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025db:	e9 1a f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025e0 <vector199>:
.globl vector199
vector199:
  pushl $0
c01025e0:	6a 00                	push   $0x0
  pushl $199
c01025e2:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025e7:	e9 0e f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025ec <vector200>:
.globl vector200
vector200:
  pushl $0
c01025ec:	6a 00                	push   $0x0
  pushl $200
c01025ee:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025f3:	e9 02 f8 ff ff       	jmp    c0101dfa <__alltraps>

c01025f8 <vector201>:
.globl vector201
vector201:
  pushl $0
c01025f8:	6a 00                	push   $0x0
  pushl $201
c01025fa:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025ff:	e9 f6 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102604 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102604:	6a 00                	push   $0x0
  pushl $202
c0102606:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010260b:	e9 ea f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102610 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102610:	6a 00                	push   $0x0
  pushl $203
c0102612:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102617:	e9 de f7 ff ff       	jmp    c0101dfa <__alltraps>

c010261c <vector204>:
.globl vector204
vector204:
  pushl $0
c010261c:	6a 00                	push   $0x0
  pushl $204
c010261e:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102623:	e9 d2 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102628 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102628:	6a 00                	push   $0x0
  pushl $205
c010262a:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010262f:	e9 c6 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102634 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102634:	6a 00                	push   $0x0
  pushl $206
c0102636:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010263b:	e9 ba f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102640 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102640:	6a 00                	push   $0x0
  pushl $207
c0102642:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102647:	e9 ae f7 ff ff       	jmp    c0101dfa <__alltraps>

c010264c <vector208>:
.globl vector208
vector208:
  pushl $0
c010264c:	6a 00                	push   $0x0
  pushl $208
c010264e:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102653:	e9 a2 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102658 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102658:	6a 00                	push   $0x0
  pushl $209
c010265a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010265f:	e9 96 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102664 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102664:	6a 00                	push   $0x0
  pushl $210
c0102666:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010266b:	e9 8a f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102670 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102670:	6a 00                	push   $0x0
  pushl $211
c0102672:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102677:	e9 7e f7 ff ff       	jmp    c0101dfa <__alltraps>

c010267c <vector212>:
.globl vector212
vector212:
  pushl $0
c010267c:	6a 00                	push   $0x0
  pushl $212
c010267e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102683:	e9 72 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102688 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102688:	6a 00                	push   $0x0
  pushl $213
c010268a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c010268f:	e9 66 f7 ff ff       	jmp    c0101dfa <__alltraps>

c0102694 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102694:	6a 00                	push   $0x0
  pushl $214
c0102696:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010269b:	e9 5a f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026a0 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026a0:	6a 00                	push   $0x0
  pushl $215
c01026a2:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026a7:	e9 4e f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026ac <vector216>:
.globl vector216
vector216:
  pushl $0
c01026ac:	6a 00                	push   $0x0
  pushl $216
c01026ae:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026b3:	e9 42 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026b8 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026b8:	6a 00                	push   $0x0
  pushl $217
c01026ba:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026bf:	e9 36 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026c4 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026c4:	6a 00                	push   $0x0
  pushl $218
c01026c6:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026cb:	e9 2a f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026d0 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026d0:	6a 00                	push   $0x0
  pushl $219
c01026d2:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026d7:	e9 1e f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026dc <vector220>:
.globl vector220
vector220:
  pushl $0
c01026dc:	6a 00                	push   $0x0
  pushl $220
c01026de:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026e3:	e9 12 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026e8 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026e8:	6a 00                	push   $0x0
  pushl $221
c01026ea:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026ef:	e9 06 f7 ff ff       	jmp    c0101dfa <__alltraps>

c01026f4 <vector222>:
.globl vector222
vector222:
  pushl $0
c01026f4:	6a 00                	push   $0x0
  pushl $222
c01026f6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01026fb:	e9 fa f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102700 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102700:	6a 00                	push   $0x0
  pushl $223
c0102702:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102707:	e9 ee f6 ff ff       	jmp    c0101dfa <__alltraps>

c010270c <vector224>:
.globl vector224
vector224:
  pushl $0
c010270c:	6a 00                	push   $0x0
  pushl $224
c010270e:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102713:	e9 e2 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102718 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102718:	6a 00                	push   $0x0
  pushl $225
c010271a:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010271f:	e9 d6 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102724 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102724:	6a 00                	push   $0x0
  pushl $226
c0102726:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010272b:	e9 ca f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102730 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102730:	6a 00                	push   $0x0
  pushl $227
c0102732:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102737:	e9 be f6 ff ff       	jmp    c0101dfa <__alltraps>

c010273c <vector228>:
.globl vector228
vector228:
  pushl $0
c010273c:	6a 00                	push   $0x0
  pushl $228
c010273e:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102743:	e9 b2 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102748 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102748:	6a 00                	push   $0x0
  pushl $229
c010274a:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010274f:	e9 a6 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102754 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102754:	6a 00                	push   $0x0
  pushl $230
c0102756:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010275b:	e9 9a f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102760 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102760:	6a 00                	push   $0x0
  pushl $231
c0102762:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102767:	e9 8e f6 ff ff       	jmp    c0101dfa <__alltraps>

c010276c <vector232>:
.globl vector232
vector232:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $232
c010276e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102773:	e9 82 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102778 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102778:	6a 00                	push   $0x0
  pushl $233
c010277a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c010277f:	e9 76 f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102784 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102784:	6a 00                	push   $0x0
  pushl $234
c0102786:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010278b:	e9 6a f6 ff ff       	jmp    c0101dfa <__alltraps>

c0102790 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $235
c0102792:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102797:	e9 5e f6 ff ff       	jmp    c0101dfa <__alltraps>

c010279c <vector236>:
.globl vector236
vector236:
  pushl $0
c010279c:	6a 00                	push   $0x0
  pushl $236
c010279e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027a3:	e9 52 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027a8 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027a8:	6a 00                	push   $0x0
  pushl $237
c01027aa:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027af:	e9 46 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027b4 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027b4:	6a 00                	push   $0x0
  pushl $238
c01027b6:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027bb:	e9 3a f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027c0 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027c0:	6a 00                	push   $0x0
  pushl $239
c01027c2:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027c7:	e9 2e f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027cc <vector240>:
.globl vector240
vector240:
  pushl $0
c01027cc:	6a 00                	push   $0x0
  pushl $240
c01027ce:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027d3:	e9 22 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027d8 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027d8:	6a 00                	push   $0x0
  pushl $241
c01027da:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027df:	e9 16 f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027e4 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027e4:	6a 00                	push   $0x0
  pushl $242
c01027e6:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027eb:	e9 0a f6 ff ff       	jmp    c0101dfa <__alltraps>

c01027f0 <vector243>:
.globl vector243
vector243:
  pushl $0
c01027f0:	6a 00                	push   $0x0
  pushl $243
c01027f2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027f7:	e9 fe f5 ff ff       	jmp    c0101dfa <__alltraps>

c01027fc <vector244>:
.globl vector244
vector244:
  pushl $0
c01027fc:	6a 00                	push   $0x0
  pushl $244
c01027fe:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102803:	e9 f2 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102808 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102808:	6a 00                	push   $0x0
  pushl $245
c010280a:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010280f:	e9 e6 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102814 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102814:	6a 00                	push   $0x0
  pushl $246
c0102816:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010281b:	e9 da f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102820 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102820:	6a 00                	push   $0x0
  pushl $247
c0102822:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102827:	e9 ce f5 ff ff       	jmp    c0101dfa <__alltraps>

c010282c <vector248>:
.globl vector248
vector248:
  pushl $0
c010282c:	6a 00                	push   $0x0
  pushl $248
c010282e:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102833:	e9 c2 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102838 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $249
c010283a:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010283f:	e9 b6 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102844 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102844:	6a 00                	push   $0x0
  pushl $250
c0102846:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010284b:	e9 aa f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102850 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102850:	6a 00                	push   $0x0
  pushl $251
c0102852:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102857:	e9 9e f5 ff ff       	jmp    c0101dfa <__alltraps>

c010285c <vector252>:
.globl vector252
vector252:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $252
c010285e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102863:	e9 92 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102868 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102868:	6a 00                	push   $0x0
  pushl $253
c010286a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010286f:	e9 86 f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102874 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102874:	6a 00                	push   $0x0
  pushl $254
c0102876:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010287b:	e9 7a f5 ff ff       	jmp    c0101dfa <__alltraps>

c0102880 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $255
c0102882:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102887:	e9 6e f5 ff ff       	jmp    c0101dfa <__alltraps>

c010288c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010288c:	55                   	push   %ebp
c010288d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010288f:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c0102895:	8b 45 08             	mov    0x8(%ebp),%eax
c0102898:	29 d0                	sub    %edx,%eax
c010289a:	c1 f8 02             	sar    $0x2,%eax
c010289d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028a3:	5d                   	pop    %ebp
c01028a4:	c3                   	ret    

c01028a5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028a5:	55                   	push   %ebp
c01028a6:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01028a8:	ff 75 08             	push   0x8(%ebp)
c01028ab:	e8 dc ff ff ff       	call   c010288c <page2ppn>
c01028b0:	83 c4 04             	add    $0x4,%esp
c01028b3:	c1 e0 0c             	shl    $0xc,%eax
}
c01028b6:	c9                   	leave  
c01028b7:	c3                   	ret    

c01028b8 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028b8:	55                   	push   %ebp
c01028b9:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01028be:	8b 00                	mov    (%eax),%eax
}
c01028c0:	5d                   	pop    %ebp
c01028c1:	c3                   	ret    

c01028c2 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028c2:	55                   	push   %ebp
c01028c3:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028cb:	89 10                	mov    %edx,(%eax)
}
c01028cd:	90                   	nop
c01028ce:	5d                   	pop    %ebp
c01028cf:	c3                   	ret    

c01028d0 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028d0:	55                   	push   %ebp
c01028d1:	89 e5                	mov    %esp,%ebp
c01028d3:	83 ec 10             	sub    $0x10,%esp
c01028d6:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028e3:	89 50 04             	mov    %edx,0x4(%eax)
c01028e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028e9:	8b 50 04             	mov    0x4(%eax),%edx
c01028ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ef:	89 10                	mov    %edx,(%eax)
}
c01028f1:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c01028f2:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01028f9:	00 00 00 
}
c01028fc:	90                   	nop
c01028fd:	c9                   	leave  
c01028fe:	c3                   	ret    

c01028ff <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028ff:	55                   	push   %ebp
c0102900:	89 e5                	mov    %esp,%ebp
c0102902:	83 ec 38             	sub    $0x38,%esp
    assert(n > 0);
c0102905:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102909:	75 16                	jne    c0102921 <default_init_memmap+0x22>
c010290b:	68 d0 61 10 c0       	push   $0xc01061d0
c0102910:	68 d6 61 10 c0       	push   $0xc01061d6
c0102915:	6a 6d                	push   $0x6d
c0102917:	68 eb 61 10 c0       	push   $0xc01061eb
c010291c:	e8 6f e3 ff ff       	call   c0100c90 <__panic>
    struct Page *p = base;
c0102921:	8b 45 08             	mov    0x8(%ebp),%eax
c0102924:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102927:	eb 6c                	jmp    c0102995 <default_init_memmap+0x96>
        assert(PageReserved(p));
c0102929:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010292c:	83 c0 04             	add    $0x4,%eax
c010292f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102936:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102939:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010293c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010293f:	0f a3 10             	bt     %edx,(%eax)
c0102942:	19 c0                	sbb    %eax,%eax
c0102944:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102947:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010294b:	0f 95 c0             	setne  %al
c010294e:	0f b6 c0             	movzbl %al,%eax
c0102951:	85 c0                	test   %eax,%eax
c0102953:	75 16                	jne    c010296b <default_init_memmap+0x6c>
c0102955:	68 01 62 10 c0       	push   $0xc0106201
c010295a:	68 d6 61 10 c0       	push   $0xc01061d6
c010295f:	6a 70                	push   $0x70
c0102961:	68 eb 61 10 c0       	push   $0xc01061eb
c0102966:	e8 25 e3 ff ff       	call   c0100c90 <__panic>
        p->flags = p->property = 0;
c010296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102975:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102978:	8b 50 08             	mov    0x8(%eax),%edx
c010297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010297e:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102981:	83 ec 08             	sub    $0x8,%esp
c0102984:	6a 00                	push   $0x0
c0102986:	ff 75 f4             	push   -0xc(%ebp)
c0102989:	e8 34 ff ff ff       	call   c01028c2 <set_page_ref>
c010298e:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0102991:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102995:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102998:	89 d0                	mov    %edx,%eax
c010299a:	c1 e0 02             	shl    $0x2,%eax
c010299d:	01 d0                	add    %edx,%eax
c010299f:	c1 e0 02             	shl    $0x2,%eax
c01029a2:	89 c2                	mov    %eax,%edx
c01029a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01029a7:	01 d0                	add    %edx,%eax
c01029a9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01029ac:	0f 85 77 ff ff ff    	jne    c0102929 <default_init_memmap+0x2a>
    }
    base->property = n;
c01029b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01029b5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029b8:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01029bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029be:	83 c0 04             	add    $0x4,%eax
c01029c1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01029c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029ce:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029d1:	0f ab 10             	bts    %edx,(%eax)
}
c01029d4:	90                   	nop
    nr_free += n;
c01029d5:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c01029db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029de:	01 d0                	add    %edx,%eax
c01029e0:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add_before(&free_list, &(base->page_link));
c01029e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e8:	83 c0 0c             	add    $0xc,%eax
c01029eb:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c01029f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01029f8:	8b 00                	mov    (%eax),%eax
c01029fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01029fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102a00:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a09:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a0f:	89 10                	mov    %edx,(%eax)
c0102a11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a14:	8b 10                	mov    (%eax),%edx
c0102a16:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a19:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a1f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a22:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a28:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a2b:	89 10                	mov    %edx,(%eax)
}
c0102a2d:	90                   	nop
}
c0102a2e:	90                   	nop
}
c0102a2f:	90                   	nop
c0102a30:	c9                   	leave  
c0102a31:	c3                   	ret    

c0102a32 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a32:	55                   	push   %ebp
c0102a33:	89 e5                	mov    %esp,%ebp
c0102a35:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102a38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a3c:	75 16                	jne    c0102a54 <default_alloc_pages+0x22>
c0102a3e:	68 d0 61 10 c0       	push   $0xc01061d0
c0102a43:	68 d6 61 10 c0       	push   $0xc01061d6
c0102a48:	6a 7c                	push   $0x7c
c0102a4a:	68 eb 61 10 c0       	push   $0xc01061eb
c0102a4f:	e8 3c e2 ff ff       	call   c0100c90 <__panic>
    if (n > nr_free) {
c0102a54:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102a59:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a5c:	76 0a                	jbe    c0102a68 <default_alloc_pages+0x36>
        return NULL;
c0102a5e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a63:	e9 43 01 00 00       	jmp    c0102bab <default_alloc_pages+0x179>
    }
    struct Page *page = NULL;
c0102a68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102a6f:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
c0102a76:	eb 1c                	jmp    c0102a94 <default_alloc_pages+0x62>
        struct Page *p = le2page(le, page_link);
c0102a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a7b:	83 e8 0c             	sub    $0xc,%eax
c0102a7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a84:	8b 40 08             	mov    0x8(%eax),%eax
c0102a87:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102a8a:	77 08                	ja     c0102a94 <default_alloc_pages+0x62>
            page = p;
c0102a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102a92:	eb 18                	jmp    c0102aac <default_alloc_pages+0x7a>
c0102a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102a9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a9d:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102aa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102aa3:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102aaa:	75 cc                	jne    c0102a78 <default_alloc_pages+0x46>
        }
    }
    if (page != NULL) {
c0102aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ab0:	0f 84 f2 00 00 00    	je     c0102ba8 <default_alloc_pages+0x176>
        if (page->property > n) {
c0102ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab9:	8b 40 08             	mov    0x8(%eax),%eax
c0102abc:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102abf:	0f 83 8f 00 00 00    	jae    c0102b54 <default_alloc_pages+0x122>
            struct Page *p = page + n;
c0102ac5:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ac8:	89 d0                	mov    %edx,%eax
c0102aca:	c1 e0 02             	shl    $0x2,%eax
c0102acd:	01 d0                	add    %edx,%eax
c0102acf:	c1 e0 02             	shl    $0x2,%eax
c0102ad2:	89 c2                	mov    %eax,%edx
c0102ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ad7:	01 d0                	add    %edx,%eax
c0102ad9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102adf:	8b 40 08             	mov    0x8(%eax),%eax
c0102ae2:	2b 45 08             	sub    0x8(%ebp),%eax
c0102ae5:	89 c2                	mov    %eax,%edx
c0102ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102aea:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102af0:	83 c0 04             	add    $0x4,%eax
c0102af3:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
c0102afa:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102afd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b00:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b03:	0f ab 10             	bts    %edx,(%eax)
}
c0102b06:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
c0102b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b0a:	83 c0 0c             	add    $0xc,%eax
c0102b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102b10:	83 c2 0c             	add    $0xc,%edx
c0102b13:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0102b16:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b1c:	8b 40 04             	mov    0x4(%eax),%eax
c0102b1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b22:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102b25:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102b2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
c0102b2e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b31:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b34:	89 10                	mov    %edx,(%eax)
c0102b36:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b39:	8b 10                	mov    (%eax),%edx
c0102b3b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b3e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b41:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b44:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b47:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102b50:	89 10                	mov    %edx,(%eax)
}
c0102b52:	90                   	nop
}
c0102b53:	90                   	nop
        }
        list_del(&(page->page_link));
c0102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b57:	83 c0 0c             	add    $0xc,%eax
c0102b5a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102b5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b60:	8b 40 04             	mov    0x4(%eax),%eax
c0102b63:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b66:	8b 12                	mov    (%edx),%edx
c0102b68:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102b6b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b71:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b74:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b77:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b7a:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b7d:	89 10                	mov    %edx,(%eax)
}
c0102b7f:	90                   	nop
}
c0102b80:	90                   	nop
        nr_free -= n;
c0102b81:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102b86:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b89:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b91:	83 c0 04             	add    $0x4,%eax
c0102b94:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102b9b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b9e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ba1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ba4:	0f b3 10             	btr    %edx,(%eax)
}
c0102ba7:	90                   	nop
    }
    return page;
c0102ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bab:	c9                   	leave  
c0102bac:	c3                   	ret    

c0102bad <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bad:	55                   	push   %ebp
c0102bae:	89 e5                	mov    %esp,%ebp
c0102bb0:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0102bb6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bba:	75 19                	jne    c0102bd5 <default_free_pages+0x28>
c0102bbc:	68 d0 61 10 c0       	push   $0xc01061d0
c0102bc1:	68 d6 61 10 c0       	push   $0xc01061d6
c0102bc6:	68 9a 00 00 00       	push   $0x9a
c0102bcb:	68 eb 61 10 c0       	push   $0xc01061eb
c0102bd0:	e8 bb e0 ff ff       	call   c0100c90 <__panic>
    struct Page *p = base;
c0102bd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102bdb:	e9 8f 00 00 00       	jmp    c0102c6f <default_free_pages+0xc2>
        assert(!PageReserved(p) && !PageProperty(p));
c0102be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be3:	83 c0 04             	add    $0x4,%eax
c0102be6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102bed:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bf3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102bf6:	0f a3 10             	bt     %edx,(%eax)
c0102bf9:	19 c0                	sbb    %eax,%eax
c0102bfb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102bfe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c02:	0f 95 c0             	setne  %al
c0102c05:	0f b6 c0             	movzbl %al,%eax
c0102c08:	85 c0                	test   %eax,%eax
c0102c0a:	75 2c                	jne    c0102c38 <default_free_pages+0x8b>
c0102c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c0f:	83 c0 04             	add    $0x4,%eax
c0102c12:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c19:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c22:	0f a3 10             	bt     %edx,(%eax)
c0102c25:	19 c0                	sbb    %eax,%eax
c0102c27:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c2e:	0f 95 c0             	setne  %al
c0102c31:	0f b6 c0             	movzbl %al,%eax
c0102c34:	85 c0                	test   %eax,%eax
c0102c36:	74 19                	je     c0102c51 <default_free_pages+0xa4>
c0102c38:	68 14 62 10 c0       	push   $0xc0106214
c0102c3d:	68 d6 61 10 c0       	push   $0xc01061d6
c0102c42:	68 9d 00 00 00       	push   $0x9d
c0102c47:	68 eb 61 10 c0       	push   $0xc01061eb
c0102c4c:	e8 3f e0 ff ff       	call   c0100c90 <__panic>
        p->flags = 0;
c0102c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c5b:	83 ec 08             	sub    $0x8,%esp
c0102c5e:	6a 00                	push   $0x0
c0102c60:	ff 75 f4             	push   -0xc(%ebp)
c0102c63:	e8 5a fc ff ff       	call   c01028c2 <set_page_ref>
c0102c68:	83 c4 10             	add    $0x10,%esp
    for (; p != base + n; p ++) {
c0102c6b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c6f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c72:	89 d0                	mov    %edx,%eax
c0102c74:	c1 e0 02             	shl    $0x2,%eax
c0102c77:	01 d0                	add    %edx,%eax
c0102c79:	c1 e0 02             	shl    $0x2,%eax
c0102c7c:	89 c2                	mov    %eax,%edx
c0102c7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c81:	01 d0                	add    %edx,%eax
c0102c83:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102c86:	0f 85 54 ff ff ff    	jne    c0102be0 <default_free_pages+0x33>
    }
    base->property = n;
c0102c8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c8f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c92:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c98:	83 c0 04             	add    $0x4,%eax
c0102c9b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102ca2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ca5:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ca8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cab:	0f ab 10             	bts    %edx,(%eax)
}
c0102cae:	90                   	nop
c0102caf:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102cb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102cb9:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102cbf:	e9 0e 01 00 00       	jmp    c0102dd2 <default_free_pages+0x225>
        p = le2page(le, page_link);
c0102cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cc7:	83 e8 0c             	sub    $0xc,%eax
c0102cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cd0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102cd3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102cd6:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c0102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdf:	8b 50 08             	mov    0x8(%eax),%edx
c0102ce2:	89 d0                	mov    %edx,%eax
c0102ce4:	c1 e0 02             	shl    $0x2,%eax
c0102ce7:	01 d0                	add    %edx,%eax
c0102ce9:	c1 e0 02             	shl    $0x2,%eax
c0102cec:	89 c2                	mov    %eax,%edx
c0102cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf1:	01 d0                	add    %edx,%eax
c0102cf3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102cf6:	75 5d                	jne    c0102d55 <default_free_pages+0x1a8>
            base->property += p->property;
c0102cf8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cfb:	8b 50 08             	mov    0x8(%eax),%edx
c0102cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d01:	8b 40 08             	mov    0x8(%eax),%eax
c0102d04:	01 c2                	add    %eax,%edx
c0102d06:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d09:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0f:	83 c0 04             	add    $0x4,%eax
c0102d12:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102d19:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d1c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d1f:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d22:	0f b3 10             	btr    %edx,(%eax)
}
c0102d25:	90                   	nop
            list_del(&(p->page_link));
c0102d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d29:	83 c0 0c             	add    $0xc,%eax
c0102d2c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102d2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d32:	8b 40 04             	mov    0x4(%eax),%eax
c0102d35:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d38:	8b 12                	mov    (%edx),%edx
c0102d3a:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102d3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102d40:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d43:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d46:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d49:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d4c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d4f:	89 10                	mov    %edx,(%eax)
}
c0102d51:	90                   	nop
}
c0102d52:	90                   	nop
c0102d53:	eb 7d                	jmp    c0102dd2 <default_free_pages+0x225>
        }
        else if (p + p->property == base) {
c0102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d58:	8b 50 08             	mov    0x8(%eax),%edx
c0102d5b:	89 d0                	mov    %edx,%eax
c0102d5d:	c1 e0 02             	shl    $0x2,%eax
c0102d60:	01 d0                	add    %edx,%eax
c0102d62:	c1 e0 02             	shl    $0x2,%eax
c0102d65:	89 c2                	mov    %eax,%edx
c0102d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d6a:	01 d0                	add    %edx,%eax
c0102d6c:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102d6f:	75 61                	jne    c0102dd2 <default_free_pages+0x225>
            p->property += base->property;
c0102d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d74:	8b 50 08             	mov    0x8(%eax),%edx
c0102d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7a:	8b 40 08             	mov    0x8(%eax),%eax
c0102d7d:	01 c2                	add    %eax,%edx
c0102d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d82:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102d85:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d88:	83 c0 04             	add    $0x4,%eax
c0102d8b:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102d92:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d95:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d98:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102d9b:	0f b3 10             	btr    %edx,(%eax)
}
c0102d9e:	90                   	nop
            base = p;
c0102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da2:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da8:	83 c0 0c             	add    $0xc,%eax
c0102dab:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102dae:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102db1:	8b 40 04             	mov    0x4(%eax),%eax
c0102db4:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102db7:	8b 12                	mov    (%edx),%edx
c0102db9:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102dbc:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102dbf:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102dc2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102dc5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102dc8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102dcb:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102dce:	89 10                	mov    %edx,(%eax)
}
c0102dd0:	90                   	nop
}
c0102dd1:	90                   	nop
    while (le != &free_list) {
c0102dd2:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102dd9:	0f 85 e5 fe ff ff    	jne    c0102cc4 <default_free_pages+0x117>
        }
    }
    nr_free += n;
c0102ddf:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102de5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102de8:	01 d0                	add    %edx,%eax
c0102dea:	a3 88 be 11 c0       	mov    %eax,0xc011be88
c0102def:	c7 45 9c 80 be 11 c0 	movl   $0xc011be80,-0x64(%ebp)
    return listelm->next;
c0102df6:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102df9:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
c0102dfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102dff:	eb 69                	jmp    c0102e6a <default_free_pages+0x2bd>
        p = le2page(le, page_link);
c0102e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e04:	83 e8 0c             	sub    $0xc,%eax
c0102e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c0102e0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e0d:	8b 50 08             	mov    0x8(%eax),%edx
c0102e10:	89 d0                	mov    %edx,%eax
c0102e12:	c1 e0 02             	shl    $0x2,%eax
c0102e15:	01 d0                	add    %edx,%eax
c0102e17:	c1 e0 02             	shl    $0x2,%eax
c0102e1a:	89 c2                	mov    %eax,%edx
c0102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1f:	01 d0                	add    %edx,%eax
c0102e21:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e24:	72 35                	jb     c0102e5b <default_free_pages+0x2ae>
            assert(base + base->property != p);
c0102e26:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e29:	8b 50 08             	mov    0x8(%eax),%edx
c0102e2c:	89 d0                	mov    %edx,%eax
c0102e2e:	c1 e0 02             	shl    $0x2,%eax
c0102e31:	01 d0                	add    %edx,%eax
c0102e33:	c1 e0 02             	shl    $0x2,%eax
c0102e36:	89 c2                	mov    %eax,%edx
c0102e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e3b:	01 d0                	add    %edx,%eax
c0102e3d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102e40:	75 33                	jne    c0102e75 <default_free_pages+0x2c8>
c0102e42:	68 39 62 10 c0       	push   $0xc0106239
c0102e47:	68 d6 61 10 c0       	push   $0xc01061d6
c0102e4c:	68 b9 00 00 00       	push   $0xb9
c0102e51:	68 eb 61 10 c0       	push   $0xc01061eb
c0102e56:	e8 35 de ff ff       	call   c0100c90 <__panic>
c0102e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e5e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e61:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e64:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
c0102e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102e6a:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102e71:	75 8e                	jne    c0102e01 <default_free_pages+0x254>
c0102e73:	eb 01                	jmp    c0102e76 <default_free_pages+0x2c9>
            break;
c0102e75:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
c0102e76:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e79:	8d 50 0c             	lea    0xc(%eax),%edx
c0102e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e7f:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e82:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
c0102e85:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e88:	8b 00                	mov    (%eax),%eax
c0102e8a:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e8d:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e90:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102e93:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e96:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102e99:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e9c:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e9f:	89 10                	mov    %edx,(%eax)
c0102ea1:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102ea4:	8b 10                	mov    (%eax),%edx
c0102ea6:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102ea9:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102eac:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102eaf:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102eb2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102eb5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102eb8:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102ebb:	89 10                	mov    %edx,(%eax)
}
c0102ebd:	90                   	nop
}
c0102ebe:	90                   	nop
}
c0102ebf:	90                   	nop
c0102ec0:	c9                   	leave  
c0102ec1:	c3                   	ret    

c0102ec2 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102ec2:	55                   	push   %ebp
c0102ec3:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ec5:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0102eca:	5d                   	pop    %ebp
c0102ecb:	c3                   	ret    

c0102ecc <basic_check>:

static void
basic_check(void) {
c0102ecc:	55                   	push   %ebp
c0102ecd:	89 e5                	mov    %esp,%ebp
c0102ecf:	83 ec 38             	sub    $0x38,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102ed2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102edc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ee2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102ee5:	83 ec 0c             	sub    $0xc,%esp
c0102ee8:	6a 01                	push   $0x1
c0102eea:	e8 d5 0c 00 00       	call   c0103bc4 <alloc_pages>
c0102eef:	83 c4 10             	add    $0x10,%esp
c0102ef2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ef5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ef9:	75 19                	jne    c0102f14 <basic_check+0x48>
c0102efb:	68 54 62 10 c0       	push   $0xc0106254
c0102f00:	68 d6 61 10 c0       	push   $0xc01061d6
c0102f05:	68 ca 00 00 00       	push   $0xca
c0102f0a:	68 eb 61 10 c0       	push   $0xc01061eb
c0102f0f:	e8 7c dd ff ff       	call   c0100c90 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f14:	83 ec 0c             	sub    $0xc,%esp
c0102f17:	6a 01                	push   $0x1
c0102f19:	e8 a6 0c 00 00       	call   c0103bc4 <alloc_pages>
c0102f1e:	83 c4 10             	add    $0x10,%esp
c0102f21:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f28:	75 19                	jne    c0102f43 <basic_check+0x77>
c0102f2a:	68 70 62 10 c0       	push   $0xc0106270
c0102f2f:	68 d6 61 10 c0       	push   $0xc01061d6
c0102f34:	68 cb 00 00 00       	push   $0xcb
c0102f39:	68 eb 61 10 c0       	push   $0xc01061eb
c0102f3e:	e8 4d dd ff ff       	call   c0100c90 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f43:	83 ec 0c             	sub    $0xc,%esp
c0102f46:	6a 01                	push   $0x1
c0102f48:	e8 77 0c 00 00       	call   c0103bc4 <alloc_pages>
c0102f4d:	83 c4 10             	add    $0x10,%esp
c0102f50:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f57:	75 19                	jne    c0102f72 <basic_check+0xa6>
c0102f59:	68 8c 62 10 c0       	push   $0xc010628c
c0102f5e:	68 d6 61 10 c0       	push   $0xc01061d6
c0102f63:	68 cc 00 00 00       	push   $0xcc
c0102f68:	68 eb 61 10 c0       	push   $0xc01061eb
c0102f6d:	e8 1e dd ff ff       	call   c0100c90 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f78:	74 10                	je     c0102f8a <basic_check+0xbe>
c0102f7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f7d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f80:	74 08                	je     c0102f8a <basic_check+0xbe>
c0102f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f85:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f88:	75 19                	jne    c0102fa3 <basic_check+0xd7>
c0102f8a:	68 a8 62 10 c0       	push   $0xc01062a8
c0102f8f:	68 d6 61 10 c0       	push   $0xc01061d6
c0102f94:	68 ce 00 00 00       	push   $0xce
c0102f99:	68 eb 61 10 c0       	push   $0xc01061eb
c0102f9e:	e8 ed dc ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102fa3:	83 ec 0c             	sub    $0xc,%esp
c0102fa6:	ff 75 ec             	push   -0x14(%ebp)
c0102fa9:	e8 0a f9 ff ff       	call   c01028b8 <page_ref>
c0102fae:	83 c4 10             	add    $0x10,%esp
c0102fb1:	85 c0                	test   %eax,%eax
c0102fb3:	75 24                	jne    c0102fd9 <basic_check+0x10d>
c0102fb5:	83 ec 0c             	sub    $0xc,%esp
c0102fb8:	ff 75 f0             	push   -0x10(%ebp)
c0102fbb:	e8 f8 f8 ff ff       	call   c01028b8 <page_ref>
c0102fc0:	83 c4 10             	add    $0x10,%esp
c0102fc3:	85 c0                	test   %eax,%eax
c0102fc5:	75 12                	jne    c0102fd9 <basic_check+0x10d>
c0102fc7:	83 ec 0c             	sub    $0xc,%esp
c0102fca:	ff 75 f4             	push   -0xc(%ebp)
c0102fcd:	e8 e6 f8 ff ff       	call   c01028b8 <page_ref>
c0102fd2:	83 c4 10             	add    $0x10,%esp
c0102fd5:	85 c0                	test   %eax,%eax
c0102fd7:	74 19                	je     c0102ff2 <basic_check+0x126>
c0102fd9:	68 cc 62 10 c0       	push   $0xc01062cc
c0102fde:	68 d6 61 10 c0       	push   $0xc01061d6
c0102fe3:	68 cf 00 00 00       	push   $0xcf
c0102fe8:	68 eb 61 10 c0       	push   $0xc01061eb
c0102fed:	e8 9e dc ff ff       	call   c0100c90 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102ff2:	83 ec 0c             	sub    $0xc,%esp
c0102ff5:	ff 75 ec             	push   -0x14(%ebp)
c0102ff8:	e8 a8 f8 ff ff       	call   c01028a5 <page2pa>
c0102ffd:	83 c4 10             	add    $0x10,%esp
c0103000:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103006:	c1 e2 0c             	shl    $0xc,%edx
c0103009:	39 d0                	cmp    %edx,%eax
c010300b:	72 19                	jb     c0103026 <basic_check+0x15a>
c010300d:	68 08 63 10 c0       	push   $0xc0106308
c0103012:	68 d6 61 10 c0       	push   $0xc01061d6
c0103017:	68 d1 00 00 00       	push   $0xd1
c010301c:	68 eb 61 10 c0       	push   $0xc01061eb
c0103021:	e8 6a dc ff ff       	call   c0100c90 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103026:	83 ec 0c             	sub    $0xc,%esp
c0103029:	ff 75 f0             	push   -0x10(%ebp)
c010302c:	e8 74 f8 ff ff       	call   c01028a5 <page2pa>
c0103031:	83 c4 10             	add    $0x10,%esp
c0103034:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c010303a:	c1 e2 0c             	shl    $0xc,%edx
c010303d:	39 d0                	cmp    %edx,%eax
c010303f:	72 19                	jb     c010305a <basic_check+0x18e>
c0103041:	68 25 63 10 c0       	push   $0xc0106325
c0103046:	68 d6 61 10 c0       	push   $0xc01061d6
c010304b:	68 d2 00 00 00       	push   $0xd2
c0103050:	68 eb 61 10 c0       	push   $0xc01061eb
c0103055:	e8 36 dc ff ff       	call   c0100c90 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010305a:	83 ec 0c             	sub    $0xc,%esp
c010305d:	ff 75 f4             	push   -0xc(%ebp)
c0103060:	e8 40 f8 ff ff       	call   c01028a5 <page2pa>
c0103065:	83 c4 10             	add    $0x10,%esp
c0103068:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c010306e:	c1 e2 0c             	shl    $0xc,%edx
c0103071:	39 d0                	cmp    %edx,%eax
c0103073:	72 19                	jb     c010308e <basic_check+0x1c2>
c0103075:	68 42 63 10 c0       	push   $0xc0106342
c010307a:	68 d6 61 10 c0       	push   $0xc01061d6
c010307f:	68 d3 00 00 00       	push   $0xd3
c0103084:	68 eb 61 10 c0       	push   $0xc01061eb
c0103089:	e8 02 dc ff ff       	call   c0100c90 <__panic>

    list_entry_t free_list_store = free_list;
c010308e:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103093:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103099:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010309c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010309f:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c01030a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01030ac:	89 50 04             	mov    %edx,0x4(%eax)
c01030af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030b2:	8b 50 04             	mov    0x4(%eax),%edx
c01030b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030b8:	89 10                	mov    %edx,(%eax)
}
c01030ba:	90                   	nop
c01030bb:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c01030c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030c5:	8b 40 04             	mov    0x4(%eax),%eax
c01030c8:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c01030cb:	0f 94 c0             	sete   %al
c01030ce:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030d1:	85 c0                	test   %eax,%eax
c01030d3:	75 19                	jne    c01030ee <basic_check+0x222>
c01030d5:	68 5f 63 10 c0       	push   $0xc010635f
c01030da:	68 d6 61 10 c0       	push   $0xc01061d6
c01030df:	68 d7 00 00 00       	push   $0xd7
c01030e4:	68 eb 61 10 c0       	push   $0xc01061eb
c01030e9:	e8 a2 db ff ff       	call   c0100c90 <__panic>

    unsigned int nr_free_store = nr_free;
c01030ee:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01030f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030f6:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c01030fd:	00 00 00 

    assert(alloc_page() == NULL);
c0103100:	83 ec 0c             	sub    $0xc,%esp
c0103103:	6a 01                	push   $0x1
c0103105:	e8 ba 0a 00 00       	call   c0103bc4 <alloc_pages>
c010310a:	83 c4 10             	add    $0x10,%esp
c010310d:	85 c0                	test   %eax,%eax
c010310f:	74 19                	je     c010312a <basic_check+0x25e>
c0103111:	68 76 63 10 c0       	push   $0xc0106376
c0103116:	68 d6 61 10 c0       	push   $0xc01061d6
c010311b:	68 dc 00 00 00       	push   $0xdc
c0103120:	68 eb 61 10 c0       	push   $0xc01061eb
c0103125:	e8 66 db ff ff       	call   c0100c90 <__panic>

    free_page(p0);
c010312a:	83 ec 08             	sub    $0x8,%esp
c010312d:	6a 01                	push   $0x1
c010312f:	ff 75 ec             	push   -0x14(%ebp)
c0103132:	e8 cb 0a 00 00       	call   c0103c02 <free_pages>
c0103137:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010313a:	83 ec 08             	sub    $0x8,%esp
c010313d:	6a 01                	push   $0x1
c010313f:	ff 75 f0             	push   -0x10(%ebp)
c0103142:	e8 bb 0a 00 00       	call   c0103c02 <free_pages>
c0103147:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010314a:	83 ec 08             	sub    $0x8,%esp
c010314d:	6a 01                	push   $0x1
c010314f:	ff 75 f4             	push   -0xc(%ebp)
c0103152:	e8 ab 0a 00 00       	call   c0103c02 <free_pages>
c0103157:	83 c4 10             	add    $0x10,%esp
    assert(nr_free == 3);
c010315a:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c010315f:	83 f8 03             	cmp    $0x3,%eax
c0103162:	74 19                	je     c010317d <basic_check+0x2b1>
c0103164:	68 8b 63 10 c0       	push   $0xc010638b
c0103169:	68 d6 61 10 c0       	push   $0xc01061d6
c010316e:	68 e1 00 00 00       	push   $0xe1
c0103173:	68 eb 61 10 c0       	push   $0xc01061eb
c0103178:	e8 13 db ff ff       	call   c0100c90 <__panic>

    assert((p0 = alloc_page()) != NULL);
c010317d:	83 ec 0c             	sub    $0xc,%esp
c0103180:	6a 01                	push   $0x1
c0103182:	e8 3d 0a 00 00       	call   c0103bc4 <alloc_pages>
c0103187:	83 c4 10             	add    $0x10,%esp
c010318a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010318d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103191:	75 19                	jne    c01031ac <basic_check+0x2e0>
c0103193:	68 54 62 10 c0       	push   $0xc0106254
c0103198:	68 d6 61 10 c0       	push   $0xc01061d6
c010319d:	68 e3 00 00 00       	push   $0xe3
c01031a2:	68 eb 61 10 c0       	push   $0xc01061eb
c01031a7:	e8 e4 da ff ff       	call   c0100c90 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031ac:	83 ec 0c             	sub    $0xc,%esp
c01031af:	6a 01                	push   $0x1
c01031b1:	e8 0e 0a 00 00       	call   c0103bc4 <alloc_pages>
c01031b6:	83 c4 10             	add    $0x10,%esp
c01031b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031c0:	75 19                	jne    c01031db <basic_check+0x30f>
c01031c2:	68 70 62 10 c0       	push   $0xc0106270
c01031c7:	68 d6 61 10 c0       	push   $0xc01061d6
c01031cc:	68 e4 00 00 00       	push   $0xe4
c01031d1:	68 eb 61 10 c0       	push   $0xc01061eb
c01031d6:	e8 b5 da ff ff       	call   c0100c90 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031db:	83 ec 0c             	sub    $0xc,%esp
c01031de:	6a 01                	push   $0x1
c01031e0:	e8 df 09 00 00       	call   c0103bc4 <alloc_pages>
c01031e5:	83 c4 10             	add    $0x10,%esp
c01031e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031ef:	75 19                	jne    c010320a <basic_check+0x33e>
c01031f1:	68 8c 62 10 c0       	push   $0xc010628c
c01031f6:	68 d6 61 10 c0       	push   $0xc01061d6
c01031fb:	68 e5 00 00 00       	push   $0xe5
c0103200:	68 eb 61 10 c0       	push   $0xc01061eb
c0103205:	e8 86 da ff ff       	call   c0100c90 <__panic>

    assert(alloc_page() == NULL);
c010320a:	83 ec 0c             	sub    $0xc,%esp
c010320d:	6a 01                	push   $0x1
c010320f:	e8 b0 09 00 00       	call   c0103bc4 <alloc_pages>
c0103214:	83 c4 10             	add    $0x10,%esp
c0103217:	85 c0                	test   %eax,%eax
c0103219:	74 19                	je     c0103234 <basic_check+0x368>
c010321b:	68 76 63 10 c0       	push   $0xc0106376
c0103220:	68 d6 61 10 c0       	push   $0xc01061d6
c0103225:	68 e7 00 00 00       	push   $0xe7
c010322a:	68 eb 61 10 c0       	push   $0xc01061eb
c010322f:	e8 5c da ff ff       	call   c0100c90 <__panic>

    free_page(p0);
c0103234:	83 ec 08             	sub    $0x8,%esp
c0103237:	6a 01                	push   $0x1
c0103239:	ff 75 ec             	push   -0x14(%ebp)
c010323c:	e8 c1 09 00 00       	call   c0103c02 <free_pages>
c0103241:	83 c4 10             	add    $0x10,%esp
c0103244:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c010324b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010324e:	8b 40 04             	mov    0x4(%eax),%eax
c0103251:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103254:	0f 94 c0             	sete   %al
c0103257:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010325a:	85 c0                	test   %eax,%eax
c010325c:	74 19                	je     c0103277 <basic_check+0x3ab>
c010325e:	68 98 63 10 c0       	push   $0xc0106398
c0103263:	68 d6 61 10 c0       	push   $0xc01061d6
c0103268:	68 ea 00 00 00       	push   $0xea
c010326d:	68 eb 61 10 c0       	push   $0xc01061eb
c0103272:	e8 19 da ff ff       	call   c0100c90 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103277:	83 ec 0c             	sub    $0xc,%esp
c010327a:	6a 01                	push   $0x1
c010327c:	e8 43 09 00 00       	call   c0103bc4 <alloc_pages>
c0103281:	83 c4 10             	add    $0x10,%esp
c0103284:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103287:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010328a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010328d:	74 19                	je     c01032a8 <basic_check+0x3dc>
c010328f:	68 b0 63 10 c0       	push   $0xc01063b0
c0103294:	68 d6 61 10 c0       	push   $0xc01061d6
c0103299:	68 ed 00 00 00       	push   $0xed
c010329e:	68 eb 61 10 c0       	push   $0xc01061eb
c01032a3:	e8 e8 d9 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c01032a8:	83 ec 0c             	sub    $0xc,%esp
c01032ab:	6a 01                	push   $0x1
c01032ad:	e8 12 09 00 00       	call   c0103bc4 <alloc_pages>
c01032b2:	83 c4 10             	add    $0x10,%esp
c01032b5:	85 c0                	test   %eax,%eax
c01032b7:	74 19                	je     c01032d2 <basic_check+0x406>
c01032b9:	68 76 63 10 c0       	push   $0xc0106376
c01032be:	68 d6 61 10 c0       	push   $0xc01061d6
c01032c3:	68 ee 00 00 00       	push   $0xee
c01032c8:	68 eb 61 10 c0       	push   $0xc01061eb
c01032cd:	e8 be d9 ff ff       	call   c0100c90 <__panic>

    assert(nr_free == 0);
c01032d2:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01032d7:	85 c0                	test   %eax,%eax
c01032d9:	74 19                	je     c01032f4 <basic_check+0x428>
c01032db:	68 c9 63 10 c0       	push   $0xc01063c9
c01032e0:	68 d6 61 10 c0       	push   $0xc01061d6
c01032e5:	68 f0 00 00 00       	push   $0xf0
c01032ea:	68 eb 61 10 c0       	push   $0xc01061eb
c01032ef:	e8 9c d9 ff ff       	call   c0100c90 <__panic>
    free_list = free_list_store;
c01032f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01032f7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01032fa:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01032ff:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c0103305:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103308:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c010330d:	83 ec 08             	sub    $0x8,%esp
c0103310:	6a 01                	push   $0x1
c0103312:	ff 75 e4             	push   -0x1c(%ebp)
c0103315:	e8 e8 08 00 00       	call   c0103c02 <free_pages>
c010331a:	83 c4 10             	add    $0x10,%esp
    free_page(p1);
c010331d:	83 ec 08             	sub    $0x8,%esp
c0103320:	6a 01                	push   $0x1
c0103322:	ff 75 f0             	push   -0x10(%ebp)
c0103325:	e8 d8 08 00 00       	call   c0103c02 <free_pages>
c010332a:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c010332d:	83 ec 08             	sub    $0x8,%esp
c0103330:	6a 01                	push   $0x1
c0103332:	ff 75 f4             	push   -0xc(%ebp)
c0103335:	e8 c8 08 00 00       	call   c0103c02 <free_pages>
c010333a:	83 c4 10             	add    $0x10,%esp
}
c010333d:	90                   	nop
c010333e:	c9                   	leave  
c010333f:	c3                   	ret    

c0103340 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103340:	55                   	push   %ebp
c0103341:	89 e5                	mov    %esp,%ebp
c0103343:	81 ec 88 00 00 00    	sub    $0x88,%esp
    int count = 0, total = 0;
c0103349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103350:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103357:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010335e:	eb 60                	jmp    c01033c0 <default_check+0x80>
        struct Page *p = le2page(le, page_link);
c0103360:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103363:	83 e8 0c             	sub    $0xc,%eax
c0103366:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103369:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010336c:	83 c0 04             	add    $0x4,%eax
c010336f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103376:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103379:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010337c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010337f:	0f a3 10             	bt     %edx,(%eax)
c0103382:	19 c0                	sbb    %eax,%eax
c0103384:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103387:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010338b:	0f 95 c0             	setne  %al
c010338e:	0f b6 c0             	movzbl %al,%eax
c0103391:	85 c0                	test   %eax,%eax
c0103393:	75 19                	jne    c01033ae <default_check+0x6e>
c0103395:	68 d6 63 10 c0       	push   $0xc01063d6
c010339a:	68 d6 61 10 c0       	push   $0xc01061d6
c010339f:	68 01 01 00 00       	push   $0x101
c01033a4:	68 eb 61 10 c0       	push   $0xc01061eb
c01033a9:	e8 e2 d8 ff ff       	call   c0100c90 <__panic>
        count ++, total += p->property;
c01033ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01033b5:	8b 50 08             	mov    0x8(%eax),%edx
c01033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033bb:	01 d0                	add    %edx,%eax
c01033bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033c3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01033c6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033c9:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01033cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033cf:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c01033d6:	75 88                	jne    c0103360 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01033d8:	e8 5a 08 00 00       	call   c0103c37 <nr_free_pages>
c01033dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01033e0:	39 d0                	cmp    %edx,%eax
c01033e2:	74 19                	je     c01033fd <default_check+0xbd>
c01033e4:	68 e6 63 10 c0       	push   $0xc01063e6
c01033e9:	68 d6 61 10 c0       	push   $0xc01061d6
c01033ee:	68 04 01 00 00       	push   $0x104
c01033f3:	68 eb 61 10 c0       	push   $0xc01061eb
c01033f8:	e8 93 d8 ff ff       	call   c0100c90 <__panic>

    basic_check();
c01033fd:	e8 ca fa ff ff       	call   c0102ecc <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103402:	83 ec 0c             	sub    $0xc,%esp
c0103405:	6a 05                	push   $0x5
c0103407:	e8 b8 07 00 00       	call   c0103bc4 <alloc_pages>
c010340c:	83 c4 10             	add    $0x10,%esp
c010340f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103412:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103416:	75 19                	jne    c0103431 <default_check+0xf1>
c0103418:	68 ff 63 10 c0       	push   $0xc01063ff
c010341d:	68 d6 61 10 c0       	push   $0xc01061d6
c0103422:	68 09 01 00 00       	push   $0x109
c0103427:	68 eb 61 10 c0       	push   $0xc01061eb
c010342c:	e8 5f d8 ff ff       	call   c0100c90 <__panic>
    assert(!PageProperty(p0));
c0103431:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103434:	83 c0 04             	add    $0x4,%eax
c0103437:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010343e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103441:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103444:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103447:	0f a3 10             	bt     %edx,(%eax)
c010344a:	19 c0                	sbb    %eax,%eax
c010344c:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010344f:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103453:	0f 95 c0             	setne  %al
c0103456:	0f b6 c0             	movzbl %al,%eax
c0103459:	85 c0                	test   %eax,%eax
c010345b:	74 19                	je     c0103476 <default_check+0x136>
c010345d:	68 0a 64 10 c0       	push   $0xc010640a
c0103462:	68 d6 61 10 c0       	push   $0xc01061d6
c0103467:	68 0a 01 00 00       	push   $0x10a
c010346c:	68 eb 61 10 c0       	push   $0xc01061eb
c0103471:	e8 1a d8 ff ff       	call   c0100c90 <__panic>

    list_entry_t free_list_store = free_list;
c0103476:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c010347b:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103481:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103484:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103487:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c010348e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103491:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103494:	89 50 04             	mov    %edx,0x4(%eax)
c0103497:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010349a:	8b 50 04             	mov    0x4(%eax),%edx
c010349d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034a0:	89 10                	mov    %edx,(%eax)
}
c01034a2:	90                   	nop
c01034a3:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c01034aa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034ad:	8b 40 04             	mov    0x4(%eax),%eax
c01034b0:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01034b3:	0f 94 c0             	sete   %al
c01034b6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01034b9:	85 c0                	test   %eax,%eax
c01034bb:	75 19                	jne    c01034d6 <default_check+0x196>
c01034bd:	68 5f 63 10 c0       	push   $0xc010635f
c01034c2:	68 d6 61 10 c0       	push   $0xc01061d6
c01034c7:	68 0e 01 00 00       	push   $0x10e
c01034cc:	68 eb 61 10 c0       	push   $0xc01061eb
c01034d1:	e8 ba d7 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c01034d6:	83 ec 0c             	sub    $0xc,%esp
c01034d9:	6a 01                	push   $0x1
c01034db:	e8 e4 06 00 00       	call   c0103bc4 <alloc_pages>
c01034e0:	83 c4 10             	add    $0x10,%esp
c01034e3:	85 c0                	test   %eax,%eax
c01034e5:	74 19                	je     c0103500 <default_check+0x1c0>
c01034e7:	68 76 63 10 c0       	push   $0xc0106376
c01034ec:	68 d6 61 10 c0       	push   $0xc01061d6
c01034f1:	68 0f 01 00 00       	push   $0x10f
c01034f6:	68 eb 61 10 c0       	push   $0xc01061eb
c01034fb:	e8 90 d7 ff ff       	call   c0100c90 <__panic>

    unsigned int nr_free_store = nr_free;
c0103500:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103508:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c010350f:	00 00 00 

    free_pages(p0 + 2, 3);
c0103512:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103515:	83 c0 28             	add    $0x28,%eax
c0103518:	83 ec 08             	sub    $0x8,%esp
c010351b:	6a 03                	push   $0x3
c010351d:	50                   	push   %eax
c010351e:	e8 df 06 00 00       	call   c0103c02 <free_pages>
c0103523:	83 c4 10             	add    $0x10,%esp
    assert(alloc_pages(4) == NULL);
c0103526:	83 ec 0c             	sub    $0xc,%esp
c0103529:	6a 04                	push   $0x4
c010352b:	e8 94 06 00 00       	call   c0103bc4 <alloc_pages>
c0103530:	83 c4 10             	add    $0x10,%esp
c0103533:	85 c0                	test   %eax,%eax
c0103535:	74 19                	je     c0103550 <default_check+0x210>
c0103537:	68 1c 64 10 c0       	push   $0xc010641c
c010353c:	68 d6 61 10 c0       	push   $0xc01061d6
c0103541:	68 15 01 00 00       	push   $0x115
c0103546:	68 eb 61 10 c0       	push   $0xc01061eb
c010354b:	e8 40 d7 ff ff       	call   c0100c90 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103550:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103553:	83 c0 28             	add    $0x28,%eax
c0103556:	83 c0 04             	add    $0x4,%eax
c0103559:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103560:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103563:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103566:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103569:	0f a3 10             	bt     %edx,(%eax)
c010356c:	19 c0                	sbb    %eax,%eax
c010356e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103571:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103575:	0f 95 c0             	setne  %al
c0103578:	0f b6 c0             	movzbl %al,%eax
c010357b:	85 c0                	test   %eax,%eax
c010357d:	74 0e                	je     c010358d <default_check+0x24d>
c010357f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103582:	83 c0 28             	add    $0x28,%eax
c0103585:	8b 40 08             	mov    0x8(%eax),%eax
c0103588:	83 f8 03             	cmp    $0x3,%eax
c010358b:	74 19                	je     c01035a6 <default_check+0x266>
c010358d:	68 34 64 10 c0       	push   $0xc0106434
c0103592:	68 d6 61 10 c0       	push   $0xc01061d6
c0103597:	68 16 01 00 00       	push   $0x116
c010359c:	68 eb 61 10 c0       	push   $0xc01061eb
c01035a1:	e8 ea d6 ff ff       	call   c0100c90 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01035a6:	83 ec 0c             	sub    $0xc,%esp
c01035a9:	6a 03                	push   $0x3
c01035ab:	e8 14 06 00 00       	call   c0103bc4 <alloc_pages>
c01035b0:	83 c4 10             	add    $0x10,%esp
c01035b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01035ba:	75 19                	jne    c01035d5 <default_check+0x295>
c01035bc:	68 60 64 10 c0       	push   $0xc0106460
c01035c1:	68 d6 61 10 c0       	push   $0xc01061d6
c01035c6:	68 17 01 00 00       	push   $0x117
c01035cb:	68 eb 61 10 c0       	push   $0xc01061eb
c01035d0:	e8 bb d6 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c01035d5:	83 ec 0c             	sub    $0xc,%esp
c01035d8:	6a 01                	push   $0x1
c01035da:	e8 e5 05 00 00       	call   c0103bc4 <alloc_pages>
c01035df:	83 c4 10             	add    $0x10,%esp
c01035e2:	85 c0                	test   %eax,%eax
c01035e4:	74 19                	je     c01035ff <default_check+0x2bf>
c01035e6:	68 76 63 10 c0       	push   $0xc0106376
c01035eb:	68 d6 61 10 c0       	push   $0xc01061d6
c01035f0:	68 18 01 00 00       	push   $0x118
c01035f5:	68 eb 61 10 c0       	push   $0xc01061eb
c01035fa:	e8 91 d6 ff ff       	call   c0100c90 <__panic>
    assert(p0 + 2 == p1);
c01035ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103602:	83 c0 28             	add    $0x28,%eax
c0103605:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103608:	74 19                	je     c0103623 <default_check+0x2e3>
c010360a:	68 7e 64 10 c0       	push   $0xc010647e
c010360f:	68 d6 61 10 c0       	push   $0xc01061d6
c0103614:	68 19 01 00 00       	push   $0x119
c0103619:	68 eb 61 10 c0       	push   $0xc01061eb
c010361e:	e8 6d d6 ff ff       	call   c0100c90 <__panic>

    p2 = p0 + 1;
c0103623:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103626:	83 c0 14             	add    $0x14,%eax
c0103629:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c010362c:	83 ec 08             	sub    $0x8,%esp
c010362f:	6a 01                	push   $0x1
c0103631:	ff 75 e8             	push   -0x18(%ebp)
c0103634:	e8 c9 05 00 00       	call   c0103c02 <free_pages>
c0103639:	83 c4 10             	add    $0x10,%esp
    free_pages(p1, 3);
c010363c:	83 ec 08             	sub    $0x8,%esp
c010363f:	6a 03                	push   $0x3
c0103641:	ff 75 e0             	push   -0x20(%ebp)
c0103644:	e8 b9 05 00 00       	call   c0103c02 <free_pages>
c0103649:	83 c4 10             	add    $0x10,%esp
    assert(PageProperty(p0) && p0->property == 1);
c010364c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010364f:	83 c0 04             	add    $0x4,%eax
c0103652:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103659:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010365c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010365f:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103662:	0f a3 10             	bt     %edx,(%eax)
c0103665:	19 c0                	sbb    %eax,%eax
c0103667:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010366a:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010366e:	0f 95 c0             	setne  %al
c0103671:	0f b6 c0             	movzbl %al,%eax
c0103674:	85 c0                	test   %eax,%eax
c0103676:	74 0b                	je     c0103683 <default_check+0x343>
c0103678:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010367b:	8b 40 08             	mov    0x8(%eax),%eax
c010367e:	83 f8 01             	cmp    $0x1,%eax
c0103681:	74 19                	je     c010369c <default_check+0x35c>
c0103683:	68 8c 64 10 c0       	push   $0xc010648c
c0103688:	68 d6 61 10 c0       	push   $0xc01061d6
c010368d:	68 1e 01 00 00       	push   $0x11e
c0103692:	68 eb 61 10 c0       	push   $0xc01061eb
c0103697:	e8 f4 d5 ff ff       	call   c0100c90 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010369c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010369f:	83 c0 04             	add    $0x4,%eax
c01036a2:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01036a9:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036ac:	8b 45 90             	mov    -0x70(%ebp),%eax
c01036af:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01036b2:	0f a3 10             	bt     %edx,(%eax)
c01036b5:	19 c0                	sbb    %eax,%eax
c01036b7:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01036ba:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01036be:	0f 95 c0             	setne  %al
c01036c1:	0f b6 c0             	movzbl %al,%eax
c01036c4:	85 c0                	test   %eax,%eax
c01036c6:	74 0b                	je     c01036d3 <default_check+0x393>
c01036c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036cb:	8b 40 08             	mov    0x8(%eax),%eax
c01036ce:	83 f8 03             	cmp    $0x3,%eax
c01036d1:	74 19                	je     c01036ec <default_check+0x3ac>
c01036d3:	68 b4 64 10 c0       	push   $0xc01064b4
c01036d8:	68 d6 61 10 c0       	push   $0xc01061d6
c01036dd:	68 1f 01 00 00       	push   $0x11f
c01036e2:	68 eb 61 10 c0       	push   $0xc01061eb
c01036e7:	e8 a4 d5 ff ff       	call   c0100c90 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01036ec:	83 ec 0c             	sub    $0xc,%esp
c01036ef:	6a 01                	push   $0x1
c01036f1:	e8 ce 04 00 00       	call   c0103bc4 <alloc_pages>
c01036f6:	83 c4 10             	add    $0x10,%esp
c01036f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01036fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036ff:	83 e8 14             	sub    $0x14,%eax
c0103702:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103705:	74 19                	je     c0103720 <default_check+0x3e0>
c0103707:	68 da 64 10 c0       	push   $0xc01064da
c010370c:	68 d6 61 10 c0       	push   $0xc01061d6
c0103711:	68 21 01 00 00       	push   $0x121
c0103716:	68 eb 61 10 c0       	push   $0xc01061eb
c010371b:	e8 70 d5 ff ff       	call   c0100c90 <__panic>
    free_page(p0);
c0103720:	83 ec 08             	sub    $0x8,%esp
c0103723:	6a 01                	push   $0x1
c0103725:	ff 75 e8             	push   -0x18(%ebp)
c0103728:	e8 d5 04 00 00       	call   c0103c02 <free_pages>
c010372d:	83 c4 10             	add    $0x10,%esp
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103730:	83 ec 0c             	sub    $0xc,%esp
c0103733:	6a 02                	push   $0x2
c0103735:	e8 8a 04 00 00       	call   c0103bc4 <alloc_pages>
c010373a:	83 c4 10             	add    $0x10,%esp
c010373d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103740:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103743:	83 c0 14             	add    $0x14,%eax
c0103746:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103749:	74 19                	je     c0103764 <default_check+0x424>
c010374b:	68 f8 64 10 c0       	push   $0xc01064f8
c0103750:	68 d6 61 10 c0       	push   $0xc01061d6
c0103755:	68 23 01 00 00       	push   $0x123
c010375a:	68 eb 61 10 c0       	push   $0xc01061eb
c010375f:	e8 2c d5 ff ff       	call   c0100c90 <__panic>

    free_pages(p0, 2);
c0103764:	83 ec 08             	sub    $0x8,%esp
c0103767:	6a 02                	push   $0x2
c0103769:	ff 75 e8             	push   -0x18(%ebp)
c010376c:	e8 91 04 00 00       	call   c0103c02 <free_pages>
c0103771:	83 c4 10             	add    $0x10,%esp
    free_page(p2);
c0103774:	83 ec 08             	sub    $0x8,%esp
c0103777:	6a 01                	push   $0x1
c0103779:	ff 75 dc             	push   -0x24(%ebp)
c010377c:	e8 81 04 00 00       	call   c0103c02 <free_pages>
c0103781:	83 c4 10             	add    $0x10,%esp

    assert((p0 = alloc_pages(5)) != NULL);
c0103784:	83 ec 0c             	sub    $0xc,%esp
c0103787:	6a 05                	push   $0x5
c0103789:	e8 36 04 00 00       	call   c0103bc4 <alloc_pages>
c010378e:	83 c4 10             	add    $0x10,%esp
c0103791:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103794:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103798:	75 19                	jne    c01037b3 <default_check+0x473>
c010379a:	68 18 65 10 c0       	push   $0xc0106518
c010379f:	68 d6 61 10 c0       	push   $0xc01061d6
c01037a4:	68 28 01 00 00       	push   $0x128
c01037a9:	68 eb 61 10 c0       	push   $0xc01061eb
c01037ae:	e8 dd d4 ff ff       	call   c0100c90 <__panic>
    assert(alloc_page() == NULL);
c01037b3:	83 ec 0c             	sub    $0xc,%esp
c01037b6:	6a 01                	push   $0x1
c01037b8:	e8 07 04 00 00       	call   c0103bc4 <alloc_pages>
c01037bd:	83 c4 10             	add    $0x10,%esp
c01037c0:	85 c0                	test   %eax,%eax
c01037c2:	74 19                	je     c01037dd <default_check+0x49d>
c01037c4:	68 76 63 10 c0       	push   $0xc0106376
c01037c9:	68 d6 61 10 c0       	push   $0xc01061d6
c01037ce:	68 29 01 00 00       	push   $0x129
c01037d3:	68 eb 61 10 c0       	push   $0xc01061eb
c01037d8:	e8 b3 d4 ff ff       	call   c0100c90 <__panic>

    assert(nr_free == 0);
c01037dd:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01037e2:	85 c0                	test   %eax,%eax
c01037e4:	74 19                	je     c01037ff <default_check+0x4bf>
c01037e6:	68 c9 63 10 c0       	push   $0xc01063c9
c01037eb:	68 d6 61 10 c0       	push   $0xc01061d6
c01037f0:	68 2b 01 00 00       	push   $0x12b
c01037f5:	68 eb 61 10 c0       	push   $0xc01061eb
c01037fa:	e8 91 d4 ff ff       	call   c0100c90 <__panic>
    nr_free = nr_free_store;
c01037ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103802:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c0103807:	8b 45 80             	mov    -0x80(%ebp),%eax
c010380a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010380d:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c0103812:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c0103818:	83 ec 08             	sub    $0x8,%esp
c010381b:	6a 05                	push   $0x5
c010381d:	ff 75 e8             	push   -0x18(%ebp)
c0103820:	e8 dd 03 00 00       	call   c0103c02 <free_pages>
c0103825:	83 c4 10             	add    $0x10,%esp

    le = &free_list;
c0103828:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010382f:	eb 1d                	jmp    c010384e <default_check+0x50e>
        struct Page *p = le2page(le, page_link);
c0103831:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103834:	83 e8 0c             	sub    $0xc,%eax
c0103837:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c010383a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010383e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103841:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103844:	8b 48 08             	mov    0x8(%eax),%ecx
c0103847:	89 d0                	mov    %edx,%eax
c0103849:	29 c8                	sub    %ecx,%eax
c010384b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010384e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103851:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0103854:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103857:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010385a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010385d:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c0103864:	75 cb                	jne    c0103831 <default_check+0x4f1>
    }
    assert(count == 0);
c0103866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010386a:	74 19                	je     c0103885 <default_check+0x545>
c010386c:	68 36 65 10 c0       	push   $0xc0106536
c0103871:	68 d6 61 10 c0       	push   $0xc01061d6
c0103876:	68 36 01 00 00       	push   $0x136
c010387b:	68 eb 61 10 c0       	push   $0xc01061eb
c0103880:	e8 0b d4 ff ff       	call   c0100c90 <__panic>
    assert(total == 0);
c0103885:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103889:	74 19                	je     c01038a4 <default_check+0x564>
c010388b:	68 41 65 10 c0       	push   $0xc0106541
c0103890:	68 d6 61 10 c0       	push   $0xc01061d6
c0103895:	68 37 01 00 00       	push   $0x137
c010389a:	68 eb 61 10 c0       	push   $0xc01061eb
c010389f:	e8 ec d3 ff ff       	call   c0100c90 <__panic>
}
c01038a4:	90                   	nop
c01038a5:	c9                   	leave  
c01038a6:	c3                   	ret    

c01038a7 <page2ppn>:
page2ppn(struct Page *page) {
c01038a7:	55                   	push   %ebp
c01038a8:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01038aa:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c01038b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01038b3:	29 d0                	sub    %edx,%eax
c01038b5:	c1 f8 02             	sar    $0x2,%eax
c01038b8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01038be:	5d                   	pop    %ebp
c01038bf:	c3                   	ret    

c01038c0 <page2pa>:
page2pa(struct Page *page) {
c01038c0:	55                   	push   %ebp
c01038c1:	89 e5                	mov    %esp,%ebp
    return page2ppn(page) << PGSHIFT;
c01038c3:	ff 75 08             	push   0x8(%ebp)
c01038c6:	e8 dc ff ff ff       	call   c01038a7 <page2ppn>
c01038cb:	83 c4 04             	add    $0x4,%esp
c01038ce:	c1 e0 0c             	shl    $0xc,%eax
}
c01038d1:	c9                   	leave  
c01038d2:	c3                   	ret    

c01038d3 <pa2page>:
pa2page(uintptr_t pa) {
c01038d3:	55                   	push   %ebp
c01038d4:	89 e5                	mov    %esp,%ebp
c01038d6:	83 ec 08             	sub    $0x8,%esp
    if (PPN(pa) >= npage) {
c01038d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01038dc:	c1 e8 0c             	shr    $0xc,%eax
c01038df:	89 c2                	mov    %eax,%edx
c01038e1:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01038e6:	39 c2                	cmp    %eax,%edx
c01038e8:	72 14                	jb     c01038fe <pa2page+0x2b>
        panic("pa2page called with invalid pa");
c01038ea:	83 ec 04             	sub    $0x4,%esp
c01038ed:	68 7c 65 10 c0       	push   $0xc010657c
c01038f2:	6a 5a                	push   $0x5a
c01038f4:	68 9b 65 10 c0       	push   $0xc010659b
c01038f9:	e8 92 d3 ff ff       	call   c0100c90 <__panic>
    return &pages[PPN(pa)];
c01038fe:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103904:	8b 45 08             	mov    0x8(%ebp),%eax
c0103907:	c1 e8 0c             	shr    $0xc,%eax
c010390a:	89 c2                	mov    %eax,%edx
c010390c:	89 d0                	mov    %edx,%eax
c010390e:	c1 e0 02             	shl    $0x2,%eax
c0103911:	01 d0                	add    %edx,%eax
c0103913:	c1 e0 02             	shl    $0x2,%eax
c0103916:	01 c8                	add    %ecx,%eax
}
c0103918:	c9                   	leave  
c0103919:	c3                   	ret    

c010391a <page2kva>:
page2kva(struct Page *page) {
c010391a:	55                   	push   %ebp
c010391b:	89 e5                	mov    %esp,%ebp
c010391d:	83 ec 18             	sub    $0x18,%esp
    return KADDR(page2pa(page));
c0103920:	ff 75 08             	push   0x8(%ebp)
c0103923:	e8 98 ff ff ff       	call   c01038c0 <page2pa>
c0103928:	83 c4 04             	add    $0x4,%esp
c010392b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010392e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103931:	c1 e8 0c             	shr    $0xc,%eax
c0103934:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103937:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010393c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010393f:	72 14                	jb     c0103955 <page2kva+0x3b>
c0103941:	ff 75 f4             	push   -0xc(%ebp)
c0103944:	68 ac 65 10 c0       	push   $0xc01065ac
c0103949:	6a 61                	push   $0x61
c010394b:	68 9b 65 10 c0       	push   $0xc010659b
c0103950:	e8 3b d3 ff ff       	call   c0100c90 <__panic>
c0103955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103958:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010395d:	c9                   	leave  
c010395e:	c3                   	ret    

c010395f <pte2page>:
pte2page(pte_t pte) {
c010395f:	55                   	push   %ebp
c0103960:	89 e5                	mov    %esp,%ebp
c0103962:	83 ec 08             	sub    $0x8,%esp
    if (!(pte & PTE_P)) {
c0103965:	8b 45 08             	mov    0x8(%ebp),%eax
c0103968:	83 e0 01             	and    $0x1,%eax
c010396b:	85 c0                	test   %eax,%eax
c010396d:	75 14                	jne    c0103983 <pte2page+0x24>
        panic("pte2page called with invalid pte");
c010396f:	83 ec 04             	sub    $0x4,%esp
c0103972:	68 d0 65 10 c0       	push   $0xc01065d0
c0103977:	6a 6c                	push   $0x6c
c0103979:	68 9b 65 10 c0       	push   $0xc010659b
c010397e:	e8 0d d3 ff ff       	call   c0100c90 <__panic>
    return pa2page(PTE_ADDR(pte));
c0103983:	8b 45 08             	mov    0x8(%ebp),%eax
c0103986:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010398b:	83 ec 0c             	sub    $0xc,%esp
c010398e:	50                   	push   %eax
c010398f:	e8 3f ff ff ff       	call   c01038d3 <pa2page>
c0103994:	83 c4 10             	add    $0x10,%esp
}
c0103997:	c9                   	leave  
c0103998:	c3                   	ret    

c0103999 <pde2page>:
pde2page(pde_t pde) {
c0103999:	55                   	push   %ebp
c010399a:	89 e5                	mov    %esp,%ebp
c010399c:	83 ec 08             	sub    $0x8,%esp
    return pa2page(PDE_ADDR(pde));
c010399f:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039a7:	83 ec 0c             	sub    $0xc,%esp
c01039aa:	50                   	push   %eax
c01039ab:	e8 23 ff ff ff       	call   c01038d3 <pa2page>
c01039b0:	83 c4 10             	add    $0x10,%esp
}
c01039b3:	c9                   	leave  
c01039b4:	c3                   	ret    

c01039b5 <page_ref>:
page_ref(struct Page *page) {
c01039b5:	55                   	push   %ebp
c01039b6:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01039b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bb:	8b 00                	mov    (%eax),%eax
}
c01039bd:	5d                   	pop    %ebp
c01039be:	c3                   	ret    

c01039bf <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01039bf:	55                   	push   %ebp
c01039c0:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01039c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01039c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01039c8:	89 10                	mov    %edx,(%eax)
}
c01039ca:	90                   	nop
c01039cb:	5d                   	pop    %ebp
c01039cc:	c3                   	ret    

c01039cd <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01039cd:	55                   	push   %ebp
c01039ce:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01039d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d3:	8b 00                	mov    (%eax),%eax
c01039d5:	8d 50 01             	lea    0x1(%eax),%edx
c01039d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01039db:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e0:	8b 00                	mov    (%eax),%eax
}
c01039e2:	5d                   	pop    %ebp
c01039e3:	c3                   	ret    

c01039e4 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01039e4:	55                   	push   %ebp
c01039e5:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01039e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039ea:	8b 00                	mov    (%eax),%eax
c01039ec:	8d 50 ff             	lea    -0x1(%eax),%edx
c01039ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f2:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01039f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f7:	8b 00                	mov    (%eax),%eax
}
c01039f9:	5d                   	pop    %ebp
c01039fa:	c3                   	ret    

c01039fb <__intr_save>:
__intr_save(void) {
c01039fb:	55                   	push   %ebp
c01039fc:	89 e5                	mov    %esp,%ebp
c01039fe:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103a01:	9c                   	pushf  
c0103a02:	58                   	pop    %eax
c0103a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103a09:	25 00 02 00 00       	and    $0x200,%eax
c0103a0e:	85 c0                	test   %eax,%eax
c0103a10:	74 0c                	je     c0103a1e <__intr_save+0x23>
        intr_disable();
c0103a12:	e8 be dc ff ff       	call   c01016d5 <intr_disable>
        return 1;
c0103a17:	b8 01 00 00 00       	mov    $0x1,%eax
c0103a1c:	eb 05                	jmp    c0103a23 <__intr_save+0x28>
    return 0;
c0103a1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a23:	c9                   	leave  
c0103a24:	c3                   	ret    

c0103a25 <__intr_restore>:
__intr_restore(bool flag) {
c0103a25:	55                   	push   %ebp
c0103a26:	89 e5                	mov    %esp,%ebp
c0103a28:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a2f:	74 05                	je     c0103a36 <__intr_restore+0x11>
        intr_enable();
c0103a31:	e8 97 dc ff ff       	call   c01016cd <intr_enable>
}
c0103a36:	90                   	nop
c0103a37:	c9                   	leave  
c0103a38:	c3                   	ret    

c0103a39 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a39:	55                   	push   %ebp
c0103a3a:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3f:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103a42:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a47:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103a49:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a4e:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103a50:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a55:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103a57:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a5c:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103a5e:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a63:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103a65:	ea 6c 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103a6c
}
c0103a6c:	90                   	nop
c0103a6d:	5d                   	pop    %ebp
c0103a6e:	c3                   	ret    

c0103a6f <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103a6f:	55                   	push   %ebp
c0103a70:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a75:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103a7a:	90                   	nop
c0103a7b:	5d                   	pop    %ebp
c0103a7c:	c3                   	ret    

c0103a7d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103a7d:	55                   	push   %ebp
c0103a7e:	89 e5                	mov    %esp,%ebp
c0103a80:	83 ec 10             	sub    $0x10,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103a83:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103a88:	50                   	push   %eax
c0103a89:	e8 e1 ff ff ff       	call   c0103a6f <load_esp0>
c0103a8e:	83 c4 04             	add    $0x4,%esp
    ts.ts_ss0 = KERNEL_DS;
c0103a91:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103a98:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103a9a:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103aa1:	68 00 
c0103aa3:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103aa8:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103aae:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103ab3:	c1 e8 10             	shr    $0x10,%eax
c0103ab6:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103abb:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ac2:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ac5:	83 c8 09             	or     $0x9,%eax
c0103ac8:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103acd:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ad4:	83 e0 ef             	and    $0xffffffef,%eax
c0103ad7:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103adc:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ae3:	83 e0 9f             	and    $0xffffff9f,%eax
c0103ae6:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103aeb:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103af2:	83 c8 80             	or     $0xffffff80,%eax
c0103af5:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103afa:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b01:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b04:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b09:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b10:	83 e0 ef             	and    $0xffffffef,%eax
c0103b13:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b18:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b1f:	83 e0 df             	and    $0xffffffdf,%eax
c0103b22:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b27:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b2e:	83 c8 40             	or     $0x40,%eax
c0103b31:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b36:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b3d:	83 e0 7f             	and    $0x7f,%eax
c0103b40:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b45:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103b4a:	c1 e8 18             	shr    $0x18,%eax
c0103b4d:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103b52:	68 30 8a 11 c0       	push   $0xc0118a30
c0103b57:	e8 dd fe ff ff       	call   c0103a39 <lgdt>
c0103b5c:	83 c4 04             	add    $0x4,%esp
c0103b5f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103b65:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103b69:	0f 00 d8             	ltr    %ax
}
c0103b6c:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103b6d:	90                   	nop
c0103b6e:	c9                   	leave  
c0103b6f:	c3                   	ret    

c0103b70 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103b70:	55                   	push   %ebp
c0103b71:	89 e5                	mov    %esp,%ebp
c0103b73:	83 ec 08             	sub    $0x8,%esp
    pmm_manager = &default_pmm_manager;
c0103b76:	c7 05 ac be 11 c0 60 	movl   $0xc0106560,0xc011beac
c0103b7d:	65 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103b80:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103b85:	8b 00                	mov    (%eax),%eax
c0103b87:	83 ec 08             	sub    $0x8,%esp
c0103b8a:	50                   	push   %eax
c0103b8b:	68 fc 65 10 c0       	push   $0xc01065fc
c0103b90:	e8 9c c7 ff ff       	call   c0100331 <cprintf>
c0103b95:	83 c4 10             	add    $0x10,%esp
    pmm_manager->init();
c0103b98:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103b9d:	8b 40 04             	mov    0x4(%eax),%eax
c0103ba0:	ff d0                	call   *%eax
}
c0103ba2:	90                   	nop
c0103ba3:	c9                   	leave  
c0103ba4:	c3                   	ret    

c0103ba5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ba5:	55                   	push   %ebp
c0103ba6:	89 e5                	mov    %esp,%ebp
c0103ba8:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->init_memmap(base, n);
c0103bab:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103bb0:	8b 40 08             	mov    0x8(%eax),%eax
c0103bb3:	83 ec 08             	sub    $0x8,%esp
c0103bb6:	ff 75 0c             	push   0xc(%ebp)
c0103bb9:	ff 75 08             	push   0x8(%ebp)
c0103bbc:	ff d0                	call   *%eax
c0103bbe:	83 c4 10             	add    $0x10,%esp
}
c0103bc1:	90                   	nop
c0103bc2:	c9                   	leave  
c0103bc3:	c3                   	ret    

c0103bc4 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103bc4:	55                   	push   %ebp
c0103bc5:	89 e5                	mov    %esp,%ebp
c0103bc7:	83 ec 18             	sub    $0x18,%esp
    struct Page *page=NULL;
c0103bca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bd1:	e8 25 fe ff ff       	call   c01039fb <__intr_save>
c0103bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103bd9:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103bde:	8b 40 0c             	mov    0xc(%eax),%eax
c0103be1:	83 ec 0c             	sub    $0xc,%esp
c0103be4:	ff 75 08             	push   0x8(%ebp)
c0103be7:	ff d0                	call   *%eax
c0103be9:	83 c4 10             	add    $0x10,%esp
c0103bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103bef:	83 ec 0c             	sub    $0xc,%esp
c0103bf2:	ff 75 f0             	push   -0x10(%ebp)
c0103bf5:	e8 2b fe ff ff       	call   c0103a25 <__intr_restore>
c0103bfa:	83 c4 10             	add    $0x10,%esp
    return page;
c0103bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103c00:	c9                   	leave  
c0103c01:	c3                   	ret    

c0103c02 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103c02:	55                   	push   %ebp
c0103c03:	89 e5                	mov    %esp,%ebp
c0103c05:	83 ec 18             	sub    $0x18,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c08:	e8 ee fd ff ff       	call   c01039fb <__intr_save>
c0103c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103c10:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103c15:	8b 40 10             	mov    0x10(%eax),%eax
c0103c18:	83 ec 08             	sub    $0x8,%esp
c0103c1b:	ff 75 0c             	push   0xc(%ebp)
c0103c1e:	ff 75 08             	push   0x8(%ebp)
c0103c21:	ff d0                	call   *%eax
c0103c23:	83 c4 10             	add    $0x10,%esp
    }
    local_intr_restore(intr_flag);
c0103c26:	83 ec 0c             	sub    $0xc,%esp
c0103c29:	ff 75 f4             	push   -0xc(%ebp)
c0103c2c:	e8 f4 fd ff ff       	call   c0103a25 <__intr_restore>
c0103c31:	83 c4 10             	add    $0x10,%esp
}
c0103c34:	90                   	nop
c0103c35:	c9                   	leave  
c0103c36:	c3                   	ret    

c0103c37 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103c37:	55                   	push   %ebp
c0103c38:	89 e5                	mov    %esp,%ebp
c0103c3a:	83 ec 18             	sub    $0x18,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c3d:	e8 b9 fd ff ff       	call   c01039fb <__intr_save>
c0103c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103c45:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103c4a:	8b 40 14             	mov    0x14(%eax),%eax
c0103c4d:	ff d0                	call   *%eax
c0103c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c52:	83 ec 0c             	sub    $0xc,%esp
c0103c55:	ff 75 f4             	push   -0xc(%ebp)
c0103c58:	e8 c8 fd ff ff       	call   c0103a25 <__intr_restore>
c0103c5d:	83 c4 10             	add    $0x10,%esp
    return ret;
c0103c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103c63:	c9                   	leave  
c0103c64:	c3                   	ret    

c0103c65 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103c65:	55                   	push   %ebp
c0103c66:	89 e5                	mov    %esp,%ebp
c0103c68:	57                   	push   %edi
c0103c69:	56                   	push   %esi
c0103c6a:	53                   	push   %ebx
c0103c6b:	83 ec 7c             	sub    $0x7c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103c6e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103c75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103c7c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103c83:	83 ec 0c             	sub    $0xc,%esp
c0103c86:	68 13 66 10 c0       	push   $0xc0106613
c0103c8b:	e8 a1 c6 ff ff       	call   c0100331 <cprintf>
c0103c90:	83 c4 10             	add    $0x10,%esp
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103c93:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103c9a:	e9 f4 00 00 00       	jmp    c0103d93 <page_init+0x12e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103c9f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ca2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ca5:	89 d0                	mov    %edx,%eax
c0103ca7:	c1 e0 02             	shl    $0x2,%eax
c0103caa:	01 d0                	add    %edx,%eax
c0103cac:	c1 e0 02             	shl    $0x2,%eax
c0103caf:	01 c8                	add    %ecx,%eax
c0103cb1:	8b 50 08             	mov    0x8(%eax),%edx
c0103cb4:	8b 40 04             	mov    0x4(%eax),%eax
c0103cb7:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103cba:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103cbd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cc3:	89 d0                	mov    %edx,%eax
c0103cc5:	c1 e0 02             	shl    $0x2,%eax
c0103cc8:	01 d0                	add    %edx,%eax
c0103cca:	c1 e0 02             	shl    $0x2,%eax
c0103ccd:	01 c8                	add    %ecx,%eax
c0103ccf:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103cd2:	8b 58 10             	mov    0x10(%eax),%ebx
c0103cd5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103cd8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103cdb:	01 c8                	add    %ecx,%eax
c0103cdd:	11 da                	adc    %ebx,%edx
c0103cdf:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103ce2:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103ce5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ce8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ceb:	89 d0                	mov    %edx,%eax
c0103ced:	c1 e0 02             	shl    $0x2,%eax
c0103cf0:	01 d0                	add    %edx,%eax
c0103cf2:	c1 e0 02             	shl    $0x2,%eax
c0103cf5:	01 c8                	add    %ecx,%eax
c0103cf7:	83 c0 14             	add    $0x14,%eax
c0103cfa:	8b 00                	mov    (%eax),%eax
c0103cfc:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103cff:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103d02:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103d05:	83 c0 ff             	add    $0xffffffff,%eax
c0103d08:	83 d2 ff             	adc    $0xffffffff,%edx
c0103d0b:	89 c1                	mov    %eax,%ecx
c0103d0d:	89 d3                	mov    %edx,%ebx
c0103d0f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103d12:	89 55 80             	mov    %edx,-0x80(%ebp)
c0103d15:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d18:	89 d0                	mov    %edx,%eax
c0103d1a:	c1 e0 02             	shl    $0x2,%eax
c0103d1d:	01 d0                	add    %edx,%eax
c0103d1f:	c1 e0 02             	shl    $0x2,%eax
c0103d22:	03 45 80             	add    -0x80(%ebp),%eax
c0103d25:	8b 50 10             	mov    0x10(%eax),%edx
c0103d28:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d2b:	ff 75 84             	push   -0x7c(%ebp)
c0103d2e:	53                   	push   %ebx
c0103d2f:	51                   	push   %ecx
c0103d30:	ff 75 a4             	push   -0x5c(%ebp)
c0103d33:	ff 75 a0             	push   -0x60(%ebp)
c0103d36:	52                   	push   %edx
c0103d37:	50                   	push   %eax
c0103d38:	68 20 66 10 c0       	push   $0xc0106620
c0103d3d:	e8 ef c5 ff ff       	call   c0100331 <cprintf>
c0103d42:	83 c4 20             	add    $0x20,%esp
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103d45:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d48:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d4b:	89 d0                	mov    %edx,%eax
c0103d4d:	c1 e0 02             	shl    $0x2,%eax
c0103d50:	01 d0                	add    %edx,%eax
c0103d52:	c1 e0 02             	shl    $0x2,%eax
c0103d55:	01 c8                	add    %ecx,%eax
c0103d57:	83 c0 14             	add    $0x14,%eax
c0103d5a:	8b 00                	mov    (%eax),%eax
c0103d5c:	83 f8 01             	cmp    $0x1,%eax
c0103d5f:	75 2e                	jne    c0103d8f <page_init+0x12a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103d61:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103d67:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103d6a:	89 d0                	mov    %edx,%eax
c0103d6c:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0103d6f:	73 1e                	jae    c0103d8f <page_init+0x12a>
c0103d71:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103d76:	b8 00 00 00 00       	mov    $0x0,%eax
c0103d7b:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0103d7e:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0103d81:	72 0c                	jb     c0103d8f <page_init+0x12a>
                maxpa = end;
c0103d83:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103d86:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103d89:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103d8c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d8f:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103d93:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d96:	8b 00                	mov    (%eax),%eax
c0103d98:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d9b:	0f 8c fe fe ff ff    	jl     c0103c9f <page_init+0x3a>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103da1:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103da6:	b8 00 00 00 00       	mov    $0x0,%eax
c0103dab:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103dae:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103db1:	73 0e                	jae    c0103dc1 <page_init+0x15c>
        maxpa = KMEMSIZE;
c0103db3:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103dba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dc4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103dc7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103dcb:	c1 ea 0c             	shr    $0xc,%edx
c0103dce:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103dd3:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0103dda:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0103ddf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103de2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103de5:	01 d0                	add    %edx,%eax
c0103de7:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103dea:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ded:	ba 00 00 00 00       	mov    $0x0,%edx
c0103df2:	f7 75 c0             	divl   -0x40(%ebp)
c0103df5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103df8:	29 d0                	sub    %edx,%eax
c0103dfa:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c0103dff:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e06:	eb 30                	jmp    c0103e38 <page_init+0x1d3>
        SetPageReserved(pages + i);
c0103e08:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103e0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e11:	89 d0                	mov    %edx,%eax
c0103e13:	c1 e0 02             	shl    $0x2,%eax
c0103e16:	01 d0                	add    %edx,%eax
c0103e18:	c1 e0 02             	shl    $0x2,%eax
c0103e1b:	01 c8                	add    %ecx,%eax
c0103e1d:	83 c0 04             	add    $0x4,%eax
c0103e20:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103e27:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103e2a:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103e2d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103e30:	0f ab 10             	bts    %edx,(%eax)
}
c0103e33:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0103e34:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e38:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e3b:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103e40:	39 c2                	cmp    %eax,%edx
c0103e42:	72 c4                	jb     c0103e08 <page_init+0x1a3>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103e44:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103e4a:	89 d0                	mov    %edx,%eax
c0103e4c:	c1 e0 02             	shl    $0x2,%eax
c0103e4f:	01 d0                	add    %edx,%eax
c0103e51:	c1 e0 02             	shl    $0x2,%eax
c0103e54:	89 c2                	mov    %eax,%edx
c0103e56:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c0103e5b:	01 d0                	add    %edx,%eax
c0103e5d:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e60:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103e67:	77 17                	ja     c0103e80 <page_init+0x21b>
c0103e69:	ff 75 b8             	push   -0x48(%ebp)
c0103e6c:	68 50 66 10 c0       	push   $0xc0106650
c0103e71:	68 dc 00 00 00       	push   $0xdc
c0103e76:	68 74 66 10 c0       	push   $0xc0106674
c0103e7b:	e8 10 ce ff ff       	call   c0100c90 <__panic>
c0103e80:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e83:	05 00 00 00 40       	add    $0x40000000,%eax
c0103e88:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103e8b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e92:	e9 53 01 00 00       	jmp    c0103fea <page_init+0x385>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e97:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e9a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e9d:	89 d0                	mov    %edx,%eax
c0103e9f:	c1 e0 02             	shl    $0x2,%eax
c0103ea2:	01 d0                	add    %edx,%eax
c0103ea4:	c1 e0 02             	shl    $0x2,%eax
c0103ea7:	01 c8                	add    %ecx,%eax
c0103ea9:	8b 50 08             	mov    0x8(%eax),%edx
c0103eac:	8b 40 04             	mov    0x4(%eax),%eax
c0103eaf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103eb2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103eb5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ebb:	89 d0                	mov    %edx,%eax
c0103ebd:	c1 e0 02             	shl    $0x2,%eax
c0103ec0:	01 d0                	add    %edx,%eax
c0103ec2:	c1 e0 02             	shl    $0x2,%eax
c0103ec5:	01 c8                	add    %ecx,%eax
c0103ec7:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103eca:	8b 58 10             	mov    0x10(%eax),%ebx
c0103ecd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ed0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ed3:	01 c8                	add    %ecx,%eax
c0103ed5:	11 da                	adc    %ebx,%edx
c0103ed7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103eda:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103edd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ee0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee3:	89 d0                	mov    %edx,%eax
c0103ee5:	c1 e0 02             	shl    $0x2,%eax
c0103ee8:	01 d0                	add    %edx,%eax
c0103eea:	c1 e0 02             	shl    $0x2,%eax
c0103eed:	01 c8                	add    %ecx,%eax
c0103eef:	83 c0 14             	add    $0x14,%eax
c0103ef2:	8b 00                	mov    (%eax),%eax
c0103ef4:	83 f8 01             	cmp    $0x1,%eax
c0103ef7:	0f 85 e9 00 00 00    	jne    c0103fe6 <page_init+0x381>
            if (begin < freemem) {
c0103efd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f00:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f05:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103f08:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103f0b:	19 d1                	sbb    %edx,%ecx
c0103f0d:	73 0d                	jae    c0103f1c <page_init+0x2b7>
                begin = freemem;
c0103f0f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f12:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f15:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103f1c:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103f21:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f26:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103f29:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f2c:	73 0e                	jae    c0103f3c <page_init+0x2d7>
                end = KMEMSIZE;
c0103f2e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103f35:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103f3c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f42:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f45:	89 d0                	mov    %edx,%eax
c0103f47:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f4a:	0f 83 96 00 00 00    	jae    c0103fe6 <page_init+0x381>
                begin = ROUNDUP(begin, PGSIZE);
c0103f50:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103f57:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f5a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f5d:	01 d0                	add    %edx,%eax
c0103f5f:	83 e8 01             	sub    $0x1,%eax
c0103f62:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103f65:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f68:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f6d:	f7 75 b0             	divl   -0x50(%ebp)
c0103f70:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f73:	29 d0                	sub    %edx,%eax
c0103f75:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f7a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f7d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103f80:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103f83:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f86:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f89:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f8e:	89 c3                	mov    %eax,%ebx
c0103f90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0103f96:	89 de                	mov    %ebx,%esi
c0103f98:	89 d0                	mov    %edx,%eax
c0103f9a:	83 e0 00             	and    $0x0,%eax
c0103f9d:	89 c7                	mov    %eax,%edi
c0103f9f:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0103fa2:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0103fa5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fa8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fab:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103fae:	89 d0                	mov    %edx,%eax
c0103fb0:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103fb3:	73 31                	jae    c0103fe6 <page_init+0x381>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103fb5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103fb8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103fbb:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0103fbe:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0103fc1:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103fc5:	c1 ea 0c             	shr    $0xc,%edx
c0103fc8:	89 c3                	mov    %eax,%ebx
c0103fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fcd:	83 ec 0c             	sub    $0xc,%esp
c0103fd0:	50                   	push   %eax
c0103fd1:	e8 fd f8 ff ff       	call   c01038d3 <pa2page>
c0103fd6:	83 c4 10             	add    $0x10,%esp
c0103fd9:	83 ec 08             	sub    $0x8,%esp
c0103fdc:	53                   	push   %ebx
c0103fdd:	50                   	push   %eax
c0103fde:	e8 c2 fb ff ff       	call   c0103ba5 <init_memmap>
c0103fe3:	83 c4 10             	add    $0x10,%esp
    for (i = 0; i < memmap->nr_map; i ++) {
c0103fe6:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fea:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103fed:	8b 00                	mov    (%eax),%eax
c0103fef:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103ff2:	0f 8c 9f fe ff ff    	jl     c0103e97 <page_init+0x232>
                }
            }
        }
    }
}
c0103ff8:	90                   	nop
c0103ff9:	90                   	nop
c0103ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0103ffd:	5b                   	pop    %ebx
c0103ffe:	5e                   	pop    %esi
c0103fff:	5f                   	pop    %edi
c0104000:	5d                   	pop    %ebp
c0104001:	c3                   	ret    

c0104002 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104002:	55                   	push   %ebp
c0104003:	89 e5                	mov    %esp,%ebp
c0104005:	83 ec 28             	sub    $0x28,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104008:	8b 45 0c             	mov    0xc(%ebp),%eax
c010400b:	33 45 14             	xor    0x14(%ebp),%eax
c010400e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104013:	85 c0                	test   %eax,%eax
c0104015:	74 19                	je     c0104030 <boot_map_segment+0x2e>
c0104017:	68 82 66 10 c0       	push   $0xc0106682
c010401c:	68 99 66 10 c0       	push   $0xc0106699
c0104021:	68 fa 00 00 00       	push   $0xfa
c0104026:	68 74 66 10 c0       	push   $0xc0106674
c010402b:	e8 60 cc ff ff       	call   c0100c90 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104030:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104037:	8b 45 0c             	mov    0xc(%ebp),%eax
c010403a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010403f:	89 c2                	mov    %eax,%edx
c0104041:	8b 45 10             	mov    0x10(%ebp),%eax
c0104044:	01 c2                	add    %eax,%edx
c0104046:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104049:	01 d0                	add    %edx,%eax
c010404b:	83 e8 01             	sub    $0x1,%eax
c010404e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104051:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104054:	ba 00 00 00 00       	mov    $0x0,%edx
c0104059:	f7 75 f0             	divl   -0x10(%ebp)
c010405c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010405f:	29 d0                	sub    %edx,%eax
c0104061:	c1 e8 0c             	shr    $0xc,%eax
c0104064:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104067:	8b 45 0c             	mov    0xc(%ebp),%eax
c010406a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010406d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104070:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104075:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104078:	8b 45 14             	mov    0x14(%ebp),%eax
c010407b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010407e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104081:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104086:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104089:	eb 57                	jmp    c01040e2 <boot_map_segment+0xe0>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010408b:	83 ec 04             	sub    $0x4,%esp
c010408e:	6a 01                	push   $0x1
c0104090:	ff 75 0c             	push   0xc(%ebp)
c0104093:	ff 75 08             	push   0x8(%ebp)
c0104096:	e8 54 01 00 00       	call   c01041ef <get_pte>
c010409b:	83 c4 10             	add    $0x10,%esp
c010409e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01040a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01040a5:	75 19                	jne    c01040c0 <boot_map_segment+0xbe>
c01040a7:	68 ae 66 10 c0       	push   $0xc01066ae
c01040ac:	68 99 66 10 c0       	push   $0xc0106699
c01040b1:	68 00 01 00 00       	push   $0x100
c01040b6:	68 74 66 10 c0       	push   $0xc0106674
c01040bb:	e8 d0 cb ff ff       	call   c0100c90 <__panic>
        *ptep = pa | PTE_P | perm;
c01040c0:	8b 45 14             	mov    0x14(%ebp),%eax
c01040c3:	0b 45 18             	or     0x18(%ebp),%eax
c01040c6:	83 c8 01             	or     $0x1,%eax
c01040c9:	89 c2                	mov    %eax,%edx
c01040cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040ce:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01040d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01040d4:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01040db:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01040e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01040e6:	75 a3                	jne    c010408b <boot_map_segment+0x89>
    }
}
c01040e8:	90                   	nop
c01040e9:	90                   	nop
c01040ea:	c9                   	leave  
c01040eb:	c3                   	ret    

c01040ec <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01040ec:	55                   	push   %ebp
c01040ed:	89 e5                	mov    %esp,%ebp
c01040ef:	83 ec 18             	sub    $0x18,%esp
    struct Page *p = alloc_page();
c01040f2:	83 ec 0c             	sub    $0xc,%esp
c01040f5:	6a 01                	push   $0x1
c01040f7:	e8 c8 fa ff ff       	call   c0103bc4 <alloc_pages>
c01040fc:	83 c4 10             	add    $0x10,%esp
c01040ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104106:	75 17                	jne    c010411f <boot_alloc_page+0x33>
        panic("boot_alloc_page failed.\n");
c0104108:	83 ec 04             	sub    $0x4,%esp
c010410b:	68 bb 66 10 c0       	push   $0xc01066bb
c0104110:	68 0c 01 00 00       	push   $0x10c
c0104115:	68 74 66 10 c0       	push   $0xc0106674
c010411a:	e8 71 cb ff ff       	call   c0100c90 <__panic>
    }
    return page2kva(p);
c010411f:	83 ec 0c             	sub    $0xc,%esp
c0104122:	ff 75 f4             	push   -0xc(%ebp)
c0104125:	e8 f0 f7 ff ff       	call   c010391a <page2kva>
c010412a:	83 c4 10             	add    $0x10,%esp
}
c010412d:	c9                   	leave  
c010412e:	c3                   	ret    

c010412f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010412f:	55                   	push   %ebp
c0104130:	89 e5                	mov    %esp,%ebp
c0104132:	83 ec 18             	sub    $0x18,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104135:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010413a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010413d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104144:	77 17                	ja     c010415d <pmm_init+0x2e>
c0104146:	ff 75 f4             	push   -0xc(%ebp)
c0104149:	68 50 66 10 c0       	push   $0xc0106650
c010414e:	68 16 01 00 00       	push   $0x116
c0104153:	68 74 66 10 c0       	push   $0xc0106674
c0104158:	e8 33 cb ff ff       	call   c0100c90 <__panic>
c010415d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104160:	05 00 00 00 40       	add    $0x40000000,%eax
c0104165:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010416a:	e8 01 fa ff ff       	call   c0103b70 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010416f:	e8 f1 fa ff ff       	call   c0103c65 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104174:	e8 91 03 00 00       	call   c010450a <check_alloc_page>

    check_pgdir();
c0104179:	e8 af 03 00 00       	call   c010452d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010417e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104183:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104186:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010418d:	77 17                	ja     c01041a6 <pmm_init+0x77>
c010418f:	ff 75 f0             	push   -0x10(%ebp)
c0104192:	68 50 66 10 c0       	push   $0xc0106650
c0104197:	68 2c 01 00 00       	push   $0x12c
c010419c:	68 74 66 10 c0       	push   $0xc0106674
c01041a1:	e8 ea ca ff ff       	call   c0100c90 <__panic>
c01041a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041a9:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01041af:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01041b4:	05 ac 0f 00 00       	add    $0xfac,%eax
c01041b9:	83 ca 03             	or     $0x3,%edx
c01041bc:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01041be:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01041c3:	83 ec 0c             	sub    $0xc,%esp
c01041c6:	6a 02                	push   $0x2
c01041c8:	6a 00                	push   $0x0
c01041ca:	68 00 00 00 38       	push   $0x38000000
c01041cf:	68 00 00 00 c0       	push   $0xc0000000
c01041d4:	50                   	push   %eax
c01041d5:	e8 28 fe ff ff       	call   c0104002 <boot_map_segment>
c01041da:	83 c4 20             	add    $0x20,%esp

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01041dd:	e8 9b f8 ff ff       	call   c0103a7d <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01041e2:	e8 ac 08 00 00       	call   c0104a93 <check_boot_pgdir>

    print_pgdir();
c01041e7:	e8 a2 0c 00 00       	call   c0104e8e <print_pgdir>

}
c01041ec:	90                   	nop
c01041ed:	c9                   	leave  
c01041ee:	c3                   	ret    

c01041ef <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01041ef:	55                   	push   %ebp
c01041f0:	89 e5                	mov    %esp,%ebp
c01041f2:	83 ec 28             	sub    $0x28,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01041f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041f8:	c1 e8 16             	shr    $0x16,%eax
c01041fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104202:	8b 45 08             	mov    0x8(%ebp),%eax
c0104205:	01 d0                	add    %edx,%eax
c0104207:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c010420a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010420d:	8b 00                	mov    (%eax),%eax
c010420f:	83 e0 01             	and    $0x1,%eax
c0104212:	85 c0                	test   %eax,%eax
c0104214:	0f 85 9f 00 00 00    	jne    c01042b9 <get_pte+0xca>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c010421a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010421e:	74 16                	je     c0104236 <get_pte+0x47>
c0104220:	83 ec 0c             	sub    $0xc,%esp
c0104223:	6a 01                	push   $0x1
c0104225:	e8 9a f9 ff ff       	call   c0103bc4 <alloc_pages>
c010422a:	83 c4 10             	add    $0x10,%esp
c010422d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104230:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104234:	75 0a                	jne    c0104240 <get_pte+0x51>
            return NULL;
c0104236:	b8 00 00 00 00       	mov    $0x0,%eax
c010423b:	e9 ca 00 00 00       	jmp    c010430a <get_pte+0x11b>
        }
        set_page_ref(page, 1);
c0104240:	83 ec 08             	sub    $0x8,%esp
c0104243:	6a 01                	push   $0x1
c0104245:	ff 75 f0             	push   -0x10(%ebp)
c0104248:	e8 72 f7 ff ff       	call   c01039bf <set_page_ref>
c010424d:	83 c4 10             	add    $0x10,%esp
        uintptr_t pa = page2pa(page);
c0104250:	83 ec 0c             	sub    $0xc,%esp
c0104253:	ff 75 f0             	push   -0x10(%ebp)
c0104256:	e8 65 f6 ff ff       	call   c01038c0 <page2pa>
c010425b:	83 c4 10             	add    $0x10,%esp
c010425e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104261:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104264:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104267:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010426a:	c1 e8 0c             	shr    $0xc,%eax
c010426d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104270:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104275:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104278:	72 17                	jb     c0104291 <get_pte+0xa2>
c010427a:	ff 75 e8             	push   -0x18(%ebp)
c010427d:	68 ac 65 10 c0       	push   $0xc01065ac
c0104282:	68 72 01 00 00       	push   $0x172
c0104287:	68 74 66 10 c0       	push   $0xc0106674
c010428c:	e8 ff c9 ff ff       	call   c0100c90 <__panic>
c0104291:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104294:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104299:	83 ec 04             	sub    $0x4,%esp
c010429c:	68 00 10 00 00       	push   $0x1000
c01042a1:	6a 00                	push   $0x0
c01042a3:	50                   	push   %eax
c01042a4:	e8 63 16 00 00       	call   c010590c <memset>
c01042a9:	83 c4 10             	add    $0x10,%esp
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c01042ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042af:	83 c8 07             	or     $0x7,%eax
c01042b2:	89 c2                	mov    %eax,%edx
c01042b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042b7:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01042b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042bc:	8b 00                	mov    (%eax),%eax
c01042be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01042c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042c9:	c1 e8 0c             	shr    $0xc,%eax
c01042cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01042cf:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01042d4:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01042d7:	72 17                	jb     c01042f0 <get_pte+0x101>
c01042d9:	ff 75 e0             	push   -0x20(%ebp)
c01042dc:	68 ac 65 10 c0       	push   $0xc01065ac
c01042e1:	68 75 01 00 00       	push   $0x175
c01042e6:	68 74 66 10 c0       	push   $0xc0106674
c01042eb:	e8 a0 c9 ff ff       	call   c0100c90 <__panic>
c01042f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042f3:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01042f8:	89 c2                	mov    %eax,%edx
c01042fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042fd:	c1 e8 0c             	shr    $0xc,%eax
c0104300:	25 ff 03 00 00       	and    $0x3ff,%eax
c0104305:	c1 e0 02             	shl    $0x2,%eax
c0104308:	01 d0                	add    %edx,%eax
}
c010430a:	c9                   	leave  
c010430b:	c3                   	ret    

c010430c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010430c:	55                   	push   %ebp
c010430d:	89 e5                	mov    %esp,%ebp
c010430f:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104312:	83 ec 04             	sub    $0x4,%esp
c0104315:	6a 00                	push   $0x0
c0104317:	ff 75 0c             	push   0xc(%ebp)
c010431a:	ff 75 08             	push   0x8(%ebp)
c010431d:	e8 cd fe ff ff       	call   c01041ef <get_pte>
c0104322:	83 c4 10             	add    $0x10,%esp
c0104325:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104328:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010432c:	74 08                	je     c0104336 <get_page+0x2a>
        *ptep_store = ptep;
c010432e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104331:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104334:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010433a:	74 1f                	je     c010435b <get_page+0x4f>
c010433c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433f:	8b 00                	mov    (%eax),%eax
c0104341:	83 e0 01             	and    $0x1,%eax
c0104344:	85 c0                	test   %eax,%eax
c0104346:	74 13                	je     c010435b <get_page+0x4f>
        return pte2page(*ptep);
c0104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434b:	8b 00                	mov    (%eax),%eax
c010434d:	83 ec 0c             	sub    $0xc,%esp
c0104350:	50                   	push   %eax
c0104351:	e8 09 f6 ff ff       	call   c010395f <pte2page>
c0104356:	83 c4 10             	add    $0x10,%esp
c0104359:	eb 05                	jmp    c0104360 <get_page+0x54>
    }
    return NULL;
c010435b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104360:	c9                   	leave  
c0104361:	c3                   	ret    

c0104362 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104362:	55                   	push   %ebp
c0104363:	89 e5                	mov    %esp,%ebp
c0104365:	83 ec 18             	sub    $0x18,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104368:	8b 45 10             	mov    0x10(%ebp),%eax
c010436b:	8b 00                	mov    (%eax),%eax
c010436d:	83 e0 01             	and    $0x1,%eax
c0104370:	85 c0                	test   %eax,%eax
c0104372:	74 50                	je     c01043c4 <page_remove_pte+0x62>
        struct Page *page = pte2page(*ptep);
c0104374:	8b 45 10             	mov    0x10(%ebp),%eax
c0104377:	8b 00                	mov    (%eax),%eax
c0104379:	83 ec 0c             	sub    $0xc,%esp
c010437c:	50                   	push   %eax
c010437d:	e8 dd f5 ff ff       	call   c010395f <pte2page>
c0104382:	83 c4 10             	add    $0x10,%esp
c0104385:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104388:	83 ec 0c             	sub    $0xc,%esp
c010438b:	ff 75 f4             	push   -0xc(%ebp)
c010438e:	e8 51 f6 ff ff       	call   c01039e4 <page_ref_dec>
c0104393:	83 c4 10             	add    $0x10,%esp
c0104396:	85 c0                	test   %eax,%eax
c0104398:	75 10                	jne    c01043aa <page_remove_pte+0x48>
            free_page(page);
c010439a:	83 ec 08             	sub    $0x8,%esp
c010439d:	6a 01                	push   $0x1
c010439f:	ff 75 f4             	push   -0xc(%ebp)
c01043a2:	e8 5b f8 ff ff       	call   c0103c02 <free_pages>
c01043a7:	83 c4 10             	add    $0x10,%esp
        }
        *ptep = 0;
c01043aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01043ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01043b3:	83 ec 08             	sub    $0x8,%esp
c01043b6:	ff 75 0c             	push   0xc(%ebp)
c01043b9:	ff 75 08             	push   0x8(%ebp)
c01043bc:	e8 f8 00 00 00       	call   c01044b9 <tlb_invalidate>
c01043c1:	83 c4 10             	add    $0x10,%esp
    }
}
c01043c4:	90                   	nop
c01043c5:	c9                   	leave  
c01043c6:	c3                   	ret    

c01043c7 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01043c7:	55                   	push   %ebp
c01043c8:	89 e5                	mov    %esp,%ebp
c01043ca:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01043cd:	83 ec 04             	sub    $0x4,%esp
c01043d0:	6a 00                	push   $0x0
c01043d2:	ff 75 0c             	push   0xc(%ebp)
c01043d5:	ff 75 08             	push   0x8(%ebp)
c01043d8:	e8 12 fe ff ff       	call   c01041ef <get_pte>
c01043dd:	83 c4 10             	add    $0x10,%esp
c01043e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01043e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043e7:	74 14                	je     c01043fd <page_remove+0x36>
        page_remove_pte(pgdir, la, ptep);
c01043e9:	83 ec 04             	sub    $0x4,%esp
c01043ec:	ff 75 f4             	push   -0xc(%ebp)
c01043ef:	ff 75 0c             	push   0xc(%ebp)
c01043f2:	ff 75 08             	push   0x8(%ebp)
c01043f5:	e8 68 ff ff ff       	call   c0104362 <page_remove_pte>
c01043fa:	83 c4 10             	add    $0x10,%esp
    }
}
c01043fd:	90                   	nop
c01043fe:	c9                   	leave  
c01043ff:	c3                   	ret    

c0104400 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104400:	55                   	push   %ebp
c0104401:	89 e5                	mov    %esp,%ebp
c0104403:	83 ec 18             	sub    $0x18,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104406:	83 ec 04             	sub    $0x4,%esp
c0104409:	6a 01                	push   $0x1
c010440b:	ff 75 10             	push   0x10(%ebp)
c010440e:	ff 75 08             	push   0x8(%ebp)
c0104411:	e8 d9 fd ff ff       	call   c01041ef <get_pte>
c0104416:	83 c4 10             	add    $0x10,%esp
c0104419:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010441c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104420:	75 0a                	jne    c010442c <page_insert+0x2c>
        return -E_NO_MEM;
c0104422:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104427:	e9 8b 00 00 00       	jmp    c01044b7 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010442c:	83 ec 0c             	sub    $0xc,%esp
c010442f:	ff 75 0c             	push   0xc(%ebp)
c0104432:	e8 96 f5 ff ff       	call   c01039cd <page_ref_inc>
c0104437:	83 c4 10             	add    $0x10,%esp
    if (*ptep & PTE_P) {
c010443a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010443d:	8b 00                	mov    (%eax),%eax
c010443f:	83 e0 01             	and    $0x1,%eax
c0104442:	85 c0                	test   %eax,%eax
c0104444:	74 40                	je     c0104486 <page_insert+0x86>
        struct Page *p = pte2page(*ptep);
c0104446:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104449:	8b 00                	mov    (%eax),%eax
c010444b:	83 ec 0c             	sub    $0xc,%esp
c010444e:	50                   	push   %eax
c010444f:	e8 0b f5 ff ff       	call   c010395f <pte2page>
c0104454:	83 c4 10             	add    $0x10,%esp
c0104457:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010445a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010445d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104460:	75 10                	jne    c0104472 <page_insert+0x72>
            page_ref_dec(page);
c0104462:	83 ec 0c             	sub    $0xc,%esp
c0104465:	ff 75 0c             	push   0xc(%ebp)
c0104468:	e8 77 f5 ff ff       	call   c01039e4 <page_ref_dec>
c010446d:	83 c4 10             	add    $0x10,%esp
c0104470:	eb 14                	jmp    c0104486 <page_insert+0x86>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104472:	83 ec 04             	sub    $0x4,%esp
c0104475:	ff 75 f4             	push   -0xc(%ebp)
c0104478:	ff 75 10             	push   0x10(%ebp)
c010447b:	ff 75 08             	push   0x8(%ebp)
c010447e:	e8 df fe ff ff       	call   c0104362 <page_remove_pte>
c0104483:	83 c4 10             	add    $0x10,%esp
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104486:	83 ec 0c             	sub    $0xc,%esp
c0104489:	ff 75 0c             	push   0xc(%ebp)
c010448c:	e8 2f f4 ff ff       	call   c01038c0 <page2pa>
c0104491:	83 c4 10             	add    $0x10,%esp
c0104494:	0b 45 14             	or     0x14(%ebp),%eax
c0104497:	83 c8 01             	or     $0x1,%eax
c010449a:	89 c2                	mov    %eax,%edx
c010449c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010449f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01044a1:	83 ec 08             	sub    $0x8,%esp
c01044a4:	ff 75 10             	push   0x10(%ebp)
c01044a7:	ff 75 08             	push   0x8(%ebp)
c01044aa:	e8 0a 00 00 00       	call   c01044b9 <tlb_invalidate>
c01044af:	83 c4 10             	add    $0x10,%esp
    return 0;
c01044b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044b7:	c9                   	leave  
c01044b8:	c3                   	ret    

c01044b9 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01044b9:	55                   	push   %ebp
c01044ba:	89 e5                	mov    %esp,%ebp
c01044bc:	83 ec 18             	sub    $0x18,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01044bf:	0f 20 d8             	mov    %cr3,%eax
c01044c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01044c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01044c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01044cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044ce:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01044d5:	77 17                	ja     c01044ee <tlb_invalidate+0x35>
c01044d7:	ff 75 f4             	push   -0xc(%ebp)
c01044da:	68 50 66 10 c0       	push   $0xc0106650
c01044df:	68 d7 01 00 00       	push   $0x1d7
c01044e4:	68 74 66 10 c0       	push   $0xc0106674
c01044e9:	e8 a2 c7 ff ff       	call   c0100c90 <__panic>
c01044ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f1:	05 00 00 00 40       	add    $0x40000000,%eax
c01044f6:	39 d0                	cmp    %edx,%eax
c01044f8:	75 0d                	jne    c0104507 <tlb_invalidate+0x4e>
        invlpg((void *)la);
c01044fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104500:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104503:	0f 01 38             	invlpg (%eax)
}
c0104506:	90                   	nop
    }
}
c0104507:	90                   	nop
c0104508:	c9                   	leave  
c0104509:	c3                   	ret    

c010450a <check_alloc_page>:

static void
check_alloc_page(void) {
c010450a:	55                   	push   %ebp
c010450b:	89 e5                	mov    %esp,%ebp
c010450d:	83 ec 08             	sub    $0x8,%esp
    pmm_manager->check();
c0104510:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0104515:	8b 40 18             	mov    0x18(%eax),%eax
c0104518:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010451a:	83 ec 0c             	sub    $0xc,%esp
c010451d:	68 d4 66 10 c0       	push   $0xc01066d4
c0104522:	e8 0a be ff ff       	call   c0100331 <cprintf>
c0104527:	83 c4 10             	add    $0x10,%esp
}
c010452a:	90                   	nop
c010452b:	c9                   	leave  
c010452c:	c3                   	ret    

c010452d <check_pgdir>:

static void
check_pgdir(void) {
c010452d:	55                   	push   %ebp
c010452e:	89 e5                	mov    %esp,%ebp
c0104530:	83 ec 28             	sub    $0x28,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104533:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104538:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010453d:	76 19                	jbe    c0104558 <check_pgdir+0x2b>
c010453f:	68 f3 66 10 c0       	push   $0xc01066f3
c0104544:	68 99 66 10 c0       	push   $0xc0106699
c0104549:	68 e4 01 00 00       	push   $0x1e4
c010454e:	68 74 66 10 c0       	push   $0xc0106674
c0104553:	e8 38 c7 ff ff       	call   c0100c90 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104558:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010455d:	85 c0                	test   %eax,%eax
c010455f:	74 0e                	je     c010456f <check_pgdir+0x42>
c0104561:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104566:	25 ff 0f 00 00       	and    $0xfff,%eax
c010456b:	85 c0                	test   %eax,%eax
c010456d:	74 19                	je     c0104588 <check_pgdir+0x5b>
c010456f:	68 10 67 10 c0       	push   $0xc0106710
c0104574:	68 99 66 10 c0       	push   $0xc0106699
c0104579:	68 e5 01 00 00       	push   $0x1e5
c010457e:	68 74 66 10 c0       	push   $0xc0106674
c0104583:	e8 08 c7 ff ff       	call   c0100c90 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104588:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010458d:	83 ec 04             	sub    $0x4,%esp
c0104590:	6a 00                	push   $0x0
c0104592:	6a 00                	push   $0x0
c0104594:	50                   	push   %eax
c0104595:	e8 72 fd ff ff       	call   c010430c <get_page>
c010459a:	83 c4 10             	add    $0x10,%esp
c010459d:	85 c0                	test   %eax,%eax
c010459f:	74 19                	je     c01045ba <check_pgdir+0x8d>
c01045a1:	68 48 67 10 c0       	push   $0xc0106748
c01045a6:	68 99 66 10 c0       	push   $0xc0106699
c01045ab:	68 e6 01 00 00       	push   $0x1e6
c01045b0:	68 74 66 10 c0       	push   $0xc0106674
c01045b5:	e8 d6 c6 ff ff       	call   c0100c90 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01045ba:	83 ec 0c             	sub    $0xc,%esp
c01045bd:	6a 01                	push   $0x1
c01045bf:	e8 00 f6 ff ff       	call   c0103bc4 <alloc_pages>
c01045c4:	83 c4 10             	add    $0x10,%esp
c01045c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01045ca:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01045cf:	6a 00                	push   $0x0
c01045d1:	6a 00                	push   $0x0
c01045d3:	ff 75 f4             	push   -0xc(%ebp)
c01045d6:	50                   	push   %eax
c01045d7:	e8 24 fe ff ff       	call   c0104400 <page_insert>
c01045dc:	83 c4 10             	add    $0x10,%esp
c01045df:	85 c0                	test   %eax,%eax
c01045e1:	74 19                	je     c01045fc <check_pgdir+0xcf>
c01045e3:	68 70 67 10 c0       	push   $0xc0106770
c01045e8:	68 99 66 10 c0       	push   $0xc0106699
c01045ed:	68 ea 01 00 00       	push   $0x1ea
c01045f2:	68 74 66 10 c0       	push   $0xc0106674
c01045f7:	e8 94 c6 ff ff       	call   c0100c90 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01045fc:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104601:	83 ec 04             	sub    $0x4,%esp
c0104604:	6a 00                	push   $0x0
c0104606:	6a 00                	push   $0x0
c0104608:	50                   	push   %eax
c0104609:	e8 e1 fb ff ff       	call   c01041ef <get_pte>
c010460e:	83 c4 10             	add    $0x10,%esp
c0104611:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104614:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104618:	75 19                	jne    c0104633 <check_pgdir+0x106>
c010461a:	68 9c 67 10 c0       	push   $0xc010679c
c010461f:	68 99 66 10 c0       	push   $0xc0106699
c0104624:	68 ed 01 00 00       	push   $0x1ed
c0104629:	68 74 66 10 c0       	push   $0xc0106674
c010462e:	e8 5d c6 ff ff       	call   c0100c90 <__panic>
    assert(pte2page(*ptep) == p1);
c0104633:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104636:	8b 00                	mov    (%eax),%eax
c0104638:	83 ec 0c             	sub    $0xc,%esp
c010463b:	50                   	push   %eax
c010463c:	e8 1e f3 ff ff       	call   c010395f <pte2page>
c0104641:	83 c4 10             	add    $0x10,%esp
c0104644:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104647:	74 19                	je     c0104662 <check_pgdir+0x135>
c0104649:	68 c9 67 10 c0       	push   $0xc01067c9
c010464e:	68 99 66 10 c0       	push   $0xc0106699
c0104653:	68 ee 01 00 00       	push   $0x1ee
c0104658:	68 74 66 10 c0       	push   $0xc0106674
c010465d:	e8 2e c6 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p1) == 1);
c0104662:	83 ec 0c             	sub    $0xc,%esp
c0104665:	ff 75 f4             	push   -0xc(%ebp)
c0104668:	e8 48 f3 ff ff       	call   c01039b5 <page_ref>
c010466d:	83 c4 10             	add    $0x10,%esp
c0104670:	83 f8 01             	cmp    $0x1,%eax
c0104673:	74 19                	je     c010468e <check_pgdir+0x161>
c0104675:	68 df 67 10 c0       	push   $0xc01067df
c010467a:	68 99 66 10 c0       	push   $0xc0106699
c010467f:	68 ef 01 00 00       	push   $0x1ef
c0104684:	68 74 66 10 c0       	push   $0xc0106674
c0104689:	e8 02 c6 ff ff       	call   c0100c90 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010468e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104693:	8b 00                	mov    (%eax),%eax
c0104695:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010469a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010469d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046a0:	c1 e8 0c             	shr    $0xc,%eax
c01046a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01046a6:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01046ab:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01046ae:	72 17                	jb     c01046c7 <check_pgdir+0x19a>
c01046b0:	ff 75 ec             	push   -0x14(%ebp)
c01046b3:	68 ac 65 10 c0       	push   $0xc01065ac
c01046b8:	68 f1 01 00 00       	push   $0x1f1
c01046bd:	68 74 66 10 c0       	push   $0xc0106674
c01046c2:	e8 c9 c5 ff ff       	call   c0100c90 <__panic>
c01046c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046ca:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01046cf:	83 c0 04             	add    $0x4,%eax
c01046d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01046d5:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01046da:	83 ec 04             	sub    $0x4,%esp
c01046dd:	6a 00                	push   $0x0
c01046df:	68 00 10 00 00       	push   $0x1000
c01046e4:	50                   	push   %eax
c01046e5:	e8 05 fb ff ff       	call   c01041ef <get_pte>
c01046ea:	83 c4 10             	add    $0x10,%esp
c01046ed:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01046f0:	74 19                	je     c010470b <check_pgdir+0x1de>
c01046f2:	68 f4 67 10 c0       	push   $0xc01067f4
c01046f7:	68 99 66 10 c0       	push   $0xc0106699
c01046fc:	68 f2 01 00 00       	push   $0x1f2
c0104701:	68 74 66 10 c0       	push   $0xc0106674
c0104706:	e8 85 c5 ff ff       	call   c0100c90 <__panic>

    p2 = alloc_page();
c010470b:	83 ec 0c             	sub    $0xc,%esp
c010470e:	6a 01                	push   $0x1
c0104710:	e8 af f4 ff ff       	call   c0103bc4 <alloc_pages>
c0104715:	83 c4 10             	add    $0x10,%esp
c0104718:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010471b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104720:	6a 06                	push   $0x6
c0104722:	68 00 10 00 00       	push   $0x1000
c0104727:	ff 75 e4             	push   -0x1c(%ebp)
c010472a:	50                   	push   %eax
c010472b:	e8 d0 fc ff ff       	call   c0104400 <page_insert>
c0104730:	83 c4 10             	add    $0x10,%esp
c0104733:	85 c0                	test   %eax,%eax
c0104735:	74 19                	je     c0104750 <check_pgdir+0x223>
c0104737:	68 1c 68 10 c0       	push   $0xc010681c
c010473c:	68 99 66 10 c0       	push   $0xc0106699
c0104741:	68 f5 01 00 00       	push   $0x1f5
c0104746:	68 74 66 10 c0       	push   $0xc0106674
c010474b:	e8 40 c5 ff ff       	call   c0100c90 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104750:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104755:	83 ec 04             	sub    $0x4,%esp
c0104758:	6a 00                	push   $0x0
c010475a:	68 00 10 00 00       	push   $0x1000
c010475f:	50                   	push   %eax
c0104760:	e8 8a fa ff ff       	call   c01041ef <get_pte>
c0104765:	83 c4 10             	add    $0x10,%esp
c0104768:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010476b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010476f:	75 19                	jne    c010478a <check_pgdir+0x25d>
c0104771:	68 54 68 10 c0       	push   $0xc0106854
c0104776:	68 99 66 10 c0       	push   $0xc0106699
c010477b:	68 f6 01 00 00       	push   $0x1f6
c0104780:	68 74 66 10 c0       	push   $0xc0106674
c0104785:	e8 06 c5 ff ff       	call   c0100c90 <__panic>
    assert(*ptep & PTE_U);
c010478a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010478d:	8b 00                	mov    (%eax),%eax
c010478f:	83 e0 04             	and    $0x4,%eax
c0104792:	85 c0                	test   %eax,%eax
c0104794:	75 19                	jne    c01047af <check_pgdir+0x282>
c0104796:	68 84 68 10 c0       	push   $0xc0106884
c010479b:	68 99 66 10 c0       	push   $0xc0106699
c01047a0:	68 f7 01 00 00       	push   $0x1f7
c01047a5:	68 74 66 10 c0       	push   $0xc0106674
c01047aa:	e8 e1 c4 ff ff       	call   c0100c90 <__panic>
    assert(*ptep & PTE_W);
c01047af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047b2:	8b 00                	mov    (%eax),%eax
c01047b4:	83 e0 02             	and    $0x2,%eax
c01047b7:	85 c0                	test   %eax,%eax
c01047b9:	75 19                	jne    c01047d4 <check_pgdir+0x2a7>
c01047bb:	68 92 68 10 c0       	push   $0xc0106892
c01047c0:	68 99 66 10 c0       	push   $0xc0106699
c01047c5:	68 f8 01 00 00       	push   $0x1f8
c01047ca:	68 74 66 10 c0       	push   $0xc0106674
c01047cf:	e8 bc c4 ff ff       	call   c0100c90 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01047d4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01047d9:	8b 00                	mov    (%eax),%eax
c01047db:	83 e0 04             	and    $0x4,%eax
c01047de:	85 c0                	test   %eax,%eax
c01047e0:	75 19                	jne    c01047fb <check_pgdir+0x2ce>
c01047e2:	68 a0 68 10 c0       	push   $0xc01068a0
c01047e7:	68 99 66 10 c0       	push   $0xc0106699
c01047ec:	68 f9 01 00 00       	push   $0x1f9
c01047f1:	68 74 66 10 c0       	push   $0xc0106674
c01047f6:	e8 95 c4 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 1);
c01047fb:	83 ec 0c             	sub    $0xc,%esp
c01047fe:	ff 75 e4             	push   -0x1c(%ebp)
c0104801:	e8 af f1 ff ff       	call   c01039b5 <page_ref>
c0104806:	83 c4 10             	add    $0x10,%esp
c0104809:	83 f8 01             	cmp    $0x1,%eax
c010480c:	74 19                	je     c0104827 <check_pgdir+0x2fa>
c010480e:	68 b6 68 10 c0       	push   $0xc01068b6
c0104813:	68 99 66 10 c0       	push   $0xc0106699
c0104818:	68 fa 01 00 00       	push   $0x1fa
c010481d:	68 74 66 10 c0       	push   $0xc0106674
c0104822:	e8 69 c4 ff ff       	call   c0100c90 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104827:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010482c:	6a 00                	push   $0x0
c010482e:	68 00 10 00 00       	push   $0x1000
c0104833:	ff 75 f4             	push   -0xc(%ebp)
c0104836:	50                   	push   %eax
c0104837:	e8 c4 fb ff ff       	call   c0104400 <page_insert>
c010483c:	83 c4 10             	add    $0x10,%esp
c010483f:	85 c0                	test   %eax,%eax
c0104841:	74 19                	je     c010485c <check_pgdir+0x32f>
c0104843:	68 c8 68 10 c0       	push   $0xc01068c8
c0104848:	68 99 66 10 c0       	push   $0xc0106699
c010484d:	68 fc 01 00 00       	push   $0x1fc
c0104852:	68 74 66 10 c0       	push   $0xc0106674
c0104857:	e8 34 c4 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p1) == 2);
c010485c:	83 ec 0c             	sub    $0xc,%esp
c010485f:	ff 75 f4             	push   -0xc(%ebp)
c0104862:	e8 4e f1 ff ff       	call   c01039b5 <page_ref>
c0104867:	83 c4 10             	add    $0x10,%esp
c010486a:	83 f8 02             	cmp    $0x2,%eax
c010486d:	74 19                	je     c0104888 <check_pgdir+0x35b>
c010486f:	68 f4 68 10 c0       	push   $0xc01068f4
c0104874:	68 99 66 10 c0       	push   $0xc0106699
c0104879:	68 fd 01 00 00       	push   $0x1fd
c010487e:	68 74 66 10 c0       	push   $0xc0106674
c0104883:	e8 08 c4 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 0);
c0104888:	83 ec 0c             	sub    $0xc,%esp
c010488b:	ff 75 e4             	push   -0x1c(%ebp)
c010488e:	e8 22 f1 ff ff       	call   c01039b5 <page_ref>
c0104893:	83 c4 10             	add    $0x10,%esp
c0104896:	85 c0                	test   %eax,%eax
c0104898:	74 19                	je     c01048b3 <check_pgdir+0x386>
c010489a:	68 06 69 10 c0       	push   $0xc0106906
c010489f:	68 99 66 10 c0       	push   $0xc0106699
c01048a4:	68 fe 01 00 00       	push   $0x1fe
c01048a9:	68 74 66 10 c0       	push   $0xc0106674
c01048ae:	e8 dd c3 ff ff       	call   c0100c90 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01048b3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048b8:	83 ec 04             	sub    $0x4,%esp
c01048bb:	6a 00                	push   $0x0
c01048bd:	68 00 10 00 00       	push   $0x1000
c01048c2:	50                   	push   %eax
c01048c3:	e8 27 f9 ff ff       	call   c01041ef <get_pte>
c01048c8:	83 c4 10             	add    $0x10,%esp
c01048cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048d2:	75 19                	jne    c01048ed <check_pgdir+0x3c0>
c01048d4:	68 54 68 10 c0       	push   $0xc0106854
c01048d9:	68 99 66 10 c0       	push   $0xc0106699
c01048de:	68 ff 01 00 00       	push   $0x1ff
c01048e3:	68 74 66 10 c0       	push   $0xc0106674
c01048e8:	e8 a3 c3 ff ff       	call   c0100c90 <__panic>
    assert(pte2page(*ptep) == p1);
c01048ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f0:	8b 00                	mov    (%eax),%eax
c01048f2:	83 ec 0c             	sub    $0xc,%esp
c01048f5:	50                   	push   %eax
c01048f6:	e8 64 f0 ff ff       	call   c010395f <pte2page>
c01048fb:	83 c4 10             	add    $0x10,%esp
c01048fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0104901:	74 19                	je     c010491c <check_pgdir+0x3ef>
c0104903:	68 c9 67 10 c0       	push   $0xc01067c9
c0104908:	68 99 66 10 c0       	push   $0xc0106699
c010490d:	68 00 02 00 00       	push   $0x200
c0104912:	68 74 66 10 c0       	push   $0xc0106674
c0104917:	e8 74 c3 ff ff       	call   c0100c90 <__panic>
    assert((*ptep & PTE_U) == 0);
c010491c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010491f:	8b 00                	mov    (%eax),%eax
c0104921:	83 e0 04             	and    $0x4,%eax
c0104924:	85 c0                	test   %eax,%eax
c0104926:	74 19                	je     c0104941 <check_pgdir+0x414>
c0104928:	68 18 69 10 c0       	push   $0xc0106918
c010492d:	68 99 66 10 c0       	push   $0xc0106699
c0104932:	68 01 02 00 00       	push   $0x201
c0104937:	68 74 66 10 c0       	push   $0xc0106674
c010493c:	e8 4f c3 ff ff       	call   c0100c90 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104941:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104946:	83 ec 08             	sub    $0x8,%esp
c0104949:	6a 00                	push   $0x0
c010494b:	50                   	push   %eax
c010494c:	e8 76 fa ff ff       	call   c01043c7 <page_remove>
c0104951:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 1);
c0104954:	83 ec 0c             	sub    $0xc,%esp
c0104957:	ff 75 f4             	push   -0xc(%ebp)
c010495a:	e8 56 f0 ff ff       	call   c01039b5 <page_ref>
c010495f:	83 c4 10             	add    $0x10,%esp
c0104962:	83 f8 01             	cmp    $0x1,%eax
c0104965:	74 19                	je     c0104980 <check_pgdir+0x453>
c0104967:	68 df 67 10 c0       	push   $0xc01067df
c010496c:	68 99 66 10 c0       	push   $0xc0106699
c0104971:	68 04 02 00 00       	push   $0x204
c0104976:	68 74 66 10 c0       	push   $0xc0106674
c010497b:	e8 10 c3 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 0);
c0104980:	83 ec 0c             	sub    $0xc,%esp
c0104983:	ff 75 e4             	push   -0x1c(%ebp)
c0104986:	e8 2a f0 ff ff       	call   c01039b5 <page_ref>
c010498b:	83 c4 10             	add    $0x10,%esp
c010498e:	85 c0                	test   %eax,%eax
c0104990:	74 19                	je     c01049ab <check_pgdir+0x47e>
c0104992:	68 06 69 10 c0       	push   $0xc0106906
c0104997:	68 99 66 10 c0       	push   $0xc0106699
c010499c:	68 05 02 00 00       	push   $0x205
c01049a1:	68 74 66 10 c0       	push   $0xc0106674
c01049a6:	e8 e5 c2 ff ff       	call   c0100c90 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01049ab:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01049b0:	83 ec 08             	sub    $0x8,%esp
c01049b3:	68 00 10 00 00       	push   $0x1000
c01049b8:	50                   	push   %eax
c01049b9:	e8 09 fa ff ff       	call   c01043c7 <page_remove>
c01049be:	83 c4 10             	add    $0x10,%esp
    assert(page_ref(p1) == 0);
c01049c1:	83 ec 0c             	sub    $0xc,%esp
c01049c4:	ff 75 f4             	push   -0xc(%ebp)
c01049c7:	e8 e9 ef ff ff       	call   c01039b5 <page_ref>
c01049cc:	83 c4 10             	add    $0x10,%esp
c01049cf:	85 c0                	test   %eax,%eax
c01049d1:	74 19                	je     c01049ec <check_pgdir+0x4bf>
c01049d3:	68 2d 69 10 c0       	push   $0xc010692d
c01049d8:	68 99 66 10 c0       	push   $0xc0106699
c01049dd:	68 08 02 00 00       	push   $0x208
c01049e2:	68 74 66 10 c0       	push   $0xc0106674
c01049e7:	e8 a4 c2 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p2) == 0);
c01049ec:	83 ec 0c             	sub    $0xc,%esp
c01049ef:	ff 75 e4             	push   -0x1c(%ebp)
c01049f2:	e8 be ef ff ff       	call   c01039b5 <page_ref>
c01049f7:	83 c4 10             	add    $0x10,%esp
c01049fa:	85 c0                	test   %eax,%eax
c01049fc:	74 19                	je     c0104a17 <check_pgdir+0x4ea>
c01049fe:	68 06 69 10 c0       	push   $0xc0106906
c0104a03:	68 99 66 10 c0       	push   $0xc0106699
c0104a08:	68 09 02 00 00       	push   $0x209
c0104a0d:	68 74 66 10 c0       	push   $0xc0106674
c0104a12:	e8 79 c2 ff ff       	call   c0100c90 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104a17:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a1c:	8b 00                	mov    (%eax),%eax
c0104a1e:	83 ec 0c             	sub    $0xc,%esp
c0104a21:	50                   	push   %eax
c0104a22:	e8 72 ef ff ff       	call   c0103999 <pde2page>
c0104a27:	83 c4 10             	add    $0x10,%esp
c0104a2a:	83 ec 0c             	sub    $0xc,%esp
c0104a2d:	50                   	push   %eax
c0104a2e:	e8 82 ef ff ff       	call   c01039b5 <page_ref>
c0104a33:	83 c4 10             	add    $0x10,%esp
c0104a36:	83 f8 01             	cmp    $0x1,%eax
c0104a39:	74 19                	je     c0104a54 <check_pgdir+0x527>
c0104a3b:	68 40 69 10 c0       	push   $0xc0106940
c0104a40:	68 99 66 10 c0       	push   $0xc0106699
c0104a45:	68 0b 02 00 00       	push   $0x20b
c0104a4a:	68 74 66 10 c0       	push   $0xc0106674
c0104a4f:	e8 3c c2 ff ff       	call   c0100c90 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104a54:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a59:	8b 00                	mov    (%eax),%eax
c0104a5b:	83 ec 0c             	sub    $0xc,%esp
c0104a5e:	50                   	push   %eax
c0104a5f:	e8 35 ef ff ff       	call   c0103999 <pde2page>
c0104a64:	83 c4 10             	add    $0x10,%esp
c0104a67:	83 ec 08             	sub    $0x8,%esp
c0104a6a:	6a 01                	push   $0x1
c0104a6c:	50                   	push   %eax
c0104a6d:	e8 90 f1 ff ff       	call   c0103c02 <free_pages>
c0104a72:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104a75:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104a80:	83 ec 0c             	sub    $0xc,%esp
c0104a83:	68 67 69 10 c0       	push   $0xc0106967
c0104a88:	e8 a4 b8 ff ff       	call   c0100331 <cprintf>
c0104a8d:	83 c4 10             	add    $0x10,%esp
}
c0104a90:	90                   	nop
c0104a91:	c9                   	leave  
c0104a92:	c3                   	ret    

c0104a93 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104a93:	55                   	push   %ebp
c0104a94:	89 e5                	mov    %esp,%ebp
c0104a96:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104a99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104aa0:	e9 a3 00 00 00       	jmp    c0104b48 <check_boot_pgdir+0xb5>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104aab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104aae:	c1 e8 0c             	shr    $0xc,%eax
c0104ab1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ab4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104ab9:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104abc:	72 17                	jb     c0104ad5 <check_boot_pgdir+0x42>
c0104abe:	ff 75 e4             	push   -0x1c(%ebp)
c0104ac1:	68 ac 65 10 c0       	push   $0xc01065ac
c0104ac6:	68 17 02 00 00       	push   $0x217
c0104acb:	68 74 66 10 c0       	push   $0xc0106674
c0104ad0:	e8 bb c1 ff ff       	call   c0100c90 <__panic>
c0104ad5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ad8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104add:	89 c2                	mov    %eax,%edx
c0104adf:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104ae4:	83 ec 04             	sub    $0x4,%esp
c0104ae7:	6a 00                	push   $0x0
c0104ae9:	52                   	push   %edx
c0104aea:	50                   	push   %eax
c0104aeb:	e8 ff f6 ff ff       	call   c01041ef <get_pte>
c0104af0:	83 c4 10             	add    $0x10,%esp
c0104af3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104af6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104afa:	75 19                	jne    c0104b15 <check_boot_pgdir+0x82>
c0104afc:	68 84 69 10 c0       	push   $0xc0106984
c0104b01:	68 99 66 10 c0       	push   $0xc0106699
c0104b06:	68 17 02 00 00       	push   $0x217
c0104b0b:	68 74 66 10 c0       	push   $0xc0106674
c0104b10:	e8 7b c1 ff ff       	call   c0100c90 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104b15:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104b18:	8b 00                	mov    (%eax),%eax
c0104b1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b1f:	89 c2                	mov    %eax,%edx
c0104b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b24:	39 c2                	cmp    %eax,%edx
c0104b26:	74 19                	je     c0104b41 <check_boot_pgdir+0xae>
c0104b28:	68 c1 69 10 c0       	push   $0xc01069c1
c0104b2d:	68 99 66 10 c0       	push   $0xc0106699
c0104b32:	68 18 02 00 00       	push   $0x218
c0104b37:	68 74 66 10 c0       	push   $0xc0106674
c0104b3c:	e8 4f c1 ff ff       	call   c0100c90 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104b41:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b4b:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104b50:	39 c2                	cmp    %eax,%edx
c0104b52:	0f 82 4d ff ff ff    	jb     c0104aa5 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104b58:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b5d:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104b62:	8b 00                	mov    (%eax),%eax
c0104b64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b69:	89 c2                	mov    %eax,%edx
c0104b6b:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b73:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104b7a:	77 17                	ja     c0104b93 <check_boot_pgdir+0x100>
c0104b7c:	ff 75 f0             	push   -0x10(%ebp)
c0104b7f:	68 50 66 10 c0       	push   $0xc0106650
c0104b84:	68 1b 02 00 00       	push   $0x21b
c0104b89:	68 74 66 10 c0       	push   $0xc0106674
c0104b8e:	e8 fd c0 ff ff       	call   c0100c90 <__panic>
c0104b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b96:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b9b:	39 d0                	cmp    %edx,%eax
c0104b9d:	74 19                	je     c0104bb8 <check_boot_pgdir+0x125>
c0104b9f:	68 d8 69 10 c0       	push   $0xc01069d8
c0104ba4:	68 99 66 10 c0       	push   $0xc0106699
c0104ba9:	68 1b 02 00 00       	push   $0x21b
c0104bae:	68 74 66 10 c0       	push   $0xc0106674
c0104bb3:	e8 d8 c0 ff ff       	call   c0100c90 <__panic>

    assert(boot_pgdir[0] == 0);
c0104bb8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bbd:	8b 00                	mov    (%eax),%eax
c0104bbf:	85 c0                	test   %eax,%eax
c0104bc1:	74 19                	je     c0104bdc <check_boot_pgdir+0x149>
c0104bc3:	68 0c 6a 10 c0       	push   $0xc0106a0c
c0104bc8:	68 99 66 10 c0       	push   $0xc0106699
c0104bcd:	68 1d 02 00 00       	push   $0x21d
c0104bd2:	68 74 66 10 c0       	push   $0xc0106674
c0104bd7:	e8 b4 c0 ff ff       	call   c0100c90 <__panic>

    struct Page *p;
    p = alloc_page();
c0104bdc:	83 ec 0c             	sub    $0xc,%esp
c0104bdf:	6a 01                	push   $0x1
c0104be1:	e8 de ef ff ff       	call   c0103bc4 <alloc_pages>
c0104be6:	83 c4 10             	add    $0x10,%esp
c0104be9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104bec:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bf1:	6a 02                	push   $0x2
c0104bf3:	68 00 01 00 00       	push   $0x100
c0104bf8:	ff 75 ec             	push   -0x14(%ebp)
c0104bfb:	50                   	push   %eax
c0104bfc:	e8 ff f7 ff ff       	call   c0104400 <page_insert>
c0104c01:	83 c4 10             	add    $0x10,%esp
c0104c04:	85 c0                	test   %eax,%eax
c0104c06:	74 19                	je     c0104c21 <check_boot_pgdir+0x18e>
c0104c08:	68 20 6a 10 c0       	push   $0xc0106a20
c0104c0d:	68 99 66 10 c0       	push   $0xc0106699
c0104c12:	68 21 02 00 00       	push   $0x221
c0104c17:	68 74 66 10 c0       	push   $0xc0106674
c0104c1c:	e8 6f c0 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p) == 1);
c0104c21:	83 ec 0c             	sub    $0xc,%esp
c0104c24:	ff 75 ec             	push   -0x14(%ebp)
c0104c27:	e8 89 ed ff ff       	call   c01039b5 <page_ref>
c0104c2c:	83 c4 10             	add    $0x10,%esp
c0104c2f:	83 f8 01             	cmp    $0x1,%eax
c0104c32:	74 19                	je     c0104c4d <check_boot_pgdir+0x1ba>
c0104c34:	68 4e 6a 10 c0       	push   $0xc0106a4e
c0104c39:	68 99 66 10 c0       	push   $0xc0106699
c0104c3e:	68 22 02 00 00       	push   $0x222
c0104c43:	68 74 66 10 c0       	push   $0xc0106674
c0104c48:	e8 43 c0 ff ff       	call   c0100c90 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104c4d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c52:	6a 02                	push   $0x2
c0104c54:	68 00 11 00 00       	push   $0x1100
c0104c59:	ff 75 ec             	push   -0x14(%ebp)
c0104c5c:	50                   	push   %eax
c0104c5d:	e8 9e f7 ff ff       	call   c0104400 <page_insert>
c0104c62:	83 c4 10             	add    $0x10,%esp
c0104c65:	85 c0                	test   %eax,%eax
c0104c67:	74 19                	je     c0104c82 <check_boot_pgdir+0x1ef>
c0104c69:	68 60 6a 10 c0       	push   $0xc0106a60
c0104c6e:	68 99 66 10 c0       	push   $0xc0106699
c0104c73:	68 23 02 00 00       	push   $0x223
c0104c78:	68 74 66 10 c0       	push   $0xc0106674
c0104c7d:	e8 0e c0 ff ff       	call   c0100c90 <__panic>
    assert(page_ref(p) == 2);
c0104c82:	83 ec 0c             	sub    $0xc,%esp
c0104c85:	ff 75 ec             	push   -0x14(%ebp)
c0104c88:	e8 28 ed ff ff       	call   c01039b5 <page_ref>
c0104c8d:	83 c4 10             	add    $0x10,%esp
c0104c90:	83 f8 02             	cmp    $0x2,%eax
c0104c93:	74 19                	je     c0104cae <check_boot_pgdir+0x21b>
c0104c95:	68 97 6a 10 c0       	push   $0xc0106a97
c0104c9a:	68 99 66 10 c0       	push   $0xc0106699
c0104c9f:	68 24 02 00 00       	push   $0x224
c0104ca4:	68 74 66 10 c0       	push   $0xc0106674
c0104ca9:	e8 e2 bf ff ff       	call   c0100c90 <__panic>

    const char *str = "ucore: Hello world!!";
c0104cae:	c7 45 e8 a8 6a 10 c0 	movl   $0xc0106aa8,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104cb5:	83 ec 08             	sub    $0x8,%esp
c0104cb8:	ff 75 e8             	push   -0x18(%ebp)
c0104cbb:	68 00 01 00 00       	push   $0x100
c0104cc0:	e8 70 09 00 00       	call   c0105635 <strcpy>
c0104cc5:	83 c4 10             	add    $0x10,%esp
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104cc8:	83 ec 08             	sub    $0x8,%esp
c0104ccb:	68 00 11 00 00       	push   $0x1100
c0104cd0:	68 00 01 00 00       	push   $0x100
c0104cd5:	e8 d4 09 00 00       	call   c01056ae <strcmp>
c0104cda:	83 c4 10             	add    $0x10,%esp
c0104cdd:	85 c0                	test   %eax,%eax
c0104cdf:	74 19                	je     c0104cfa <check_boot_pgdir+0x267>
c0104ce1:	68 c0 6a 10 c0       	push   $0xc0106ac0
c0104ce6:	68 99 66 10 c0       	push   $0xc0106699
c0104ceb:	68 28 02 00 00       	push   $0x228
c0104cf0:	68 74 66 10 c0       	push   $0xc0106674
c0104cf5:	e8 96 bf ff ff       	call   c0100c90 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104cfa:	83 ec 0c             	sub    $0xc,%esp
c0104cfd:	ff 75 ec             	push   -0x14(%ebp)
c0104d00:	e8 15 ec ff ff       	call   c010391a <page2kva>
c0104d05:	83 c4 10             	add    $0x10,%esp
c0104d08:	05 00 01 00 00       	add    $0x100,%eax
c0104d0d:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104d10:	83 ec 0c             	sub    $0xc,%esp
c0104d13:	68 00 01 00 00       	push   $0x100
c0104d18:	e8 c0 08 00 00       	call   c01055dd <strlen>
c0104d1d:	83 c4 10             	add    $0x10,%esp
c0104d20:	85 c0                	test   %eax,%eax
c0104d22:	74 19                	je     c0104d3d <check_boot_pgdir+0x2aa>
c0104d24:	68 f8 6a 10 c0       	push   $0xc0106af8
c0104d29:	68 99 66 10 c0       	push   $0xc0106699
c0104d2e:	68 2b 02 00 00       	push   $0x22b
c0104d33:	68 74 66 10 c0       	push   $0xc0106674
c0104d38:	e8 53 bf ff ff       	call   c0100c90 <__panic>

    free_page(p);
c0104d3d:	83 ec 08             	sub    $0x8,%esp
c0104d40:	6a 01                	push   $0x1
c0104d42:	ff 75 ec             	push   -0x14(%ebp)
c0104d45:	e8 b8 ee ff ff       	call   c0103c02 <free_pages>
c0104d4a:	83 c4 10             	add    $0x10,%esp
    free_page(pde2page(boot_pgdir[0]));
c0104d4d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d52:	8b 00                	mov    (%eax),%eax
c0104d54:	83 ec 0c             	sub    $0xc,%esp
c0104d57:	50                   	push   %eax
c0104d58:	e8 3c ec ff ff       	call   c0103999 <pde2page>
c0104d5d:	83 c4 10             	add    $0x10,%esp
c0104d60:	83 ec 08             	sub    $0x8,%esp
c0104d63:	6a 01                	push   $0x1
c0104d65:	50                   	push   %eax
c0104d66:	e8 97 ee ff ff       	call   c0103c02 <free_pages>
c0104d6b:	83 c4 10             	add    $0x10,%esp
    boot_pgdir[0] = 0;
c0104d6e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104d79:	83 ec 0c             	sub    $0xc,%esp
c0104d7c:	68 1c 6b 10 c0       	push   $0xc0106b1c
c0104d81:	e8 ab b5 ff ff       	call   c0100331 <cprintf>
c0104d86:	83 c4 10             	add    $0x10,%esp
}
c0104d89:	90                   	nop
c0104d8a:	c9                   	leave  
c0104d8b:	c3                   	ret    

c0104d8c <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104d8c:	55                   	push   %ebp
c0104d8d:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104d8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d92:	83 e0 04             	and    $0x4,%eax
c0104d95:	85 c0                	test   %eax,%eax
c0104d97:	74 07                	je     c0104da0 <perm2str+0x14>
c0104d99:	b8 75 00 00 00       	mov    $0x75,%eax
c0104d9e:	eb 05                	jmp    c0104da5 <perm2str+0x19>
c0104da0:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104da5:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0104daa:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104db1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104db4:	83 e0 02             	and    $0x2,%eax
c0104db7:	85 c0                	test   %eax,%eax
c0104db9:	74 07                	je     c0104dc2 <perm2str+0x36>
c0104dbb:	b8 77 00 00 00       	mov    $0x77,%eax
c0104dc0:	eb 05                	jmp    c0104dc7 <perm2str+0x3b>
c0104dc2:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104dc7:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0104dcc:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c0104dd3:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c0104dd8:	5d                   	pop    %ebp
c0104dd9:	c3                   	ret    

c0104dda <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104dda:	55                   	push   %ebp
c0104ddb:	89 e5                	mov    %esp,%ebp
c0104ddd:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104de0:	8b 45 10             	mov    0x10(%ebp),%eax
c0104de3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104de6:	72 0e                	jb     c0104df6 <get_pgtable_items+0x1c>
        return 0;
c0104de8:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ded:	e9 9a 00 00 00       	jmp    c0104e8c <get_pgtable_items+0xb2>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104df2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104df6:	8b 45 10             	mov    0x10(%ebp),%eax
c0104df9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104dfc:	73 18                	jae    c0104e16 <get_pgtable_items+0x3c>
c0104dfe:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e08:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e0b:	01 d0                	add    %edx,%eax
c0104e0d:	8b 00                	mov    (%eax),%eax
c0104e0f:	83 e0 01             	and    $0x1,%eax
c0104e12:	85 c0                	test   %eax,%eax
c0104e14:	74 dc                	je     c0104df2 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104e16:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e19:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e1c:	73 69                	jae    c0104e87 <get_pgtable_items+0xad>
        if (left_store != NULL) {
c0104e1e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104e22:	74 08                	je     c0104e2c <get_pgtable_items+0x52>
            *left_store = start;
c0104e24:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e27:	8b 55 10             	mov    0x10(%ebp),%edx
c0104e2a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104e2c:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e2f:	8d 50 01             	lea    0x1(%eax),%edx
c0104e32:	89 55 10             	mov    %edx,0x10(%ebp)
c0104e35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e3c:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e3f:	01 d0                	add    %edx,%eax
c0104e41:	8b 00                	mov    (%eax),%eax
c0104e43:	83 e0 07             	and    $0x7,%eax
c0104e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104e49:	eb 04                	jmp    c0104e4f <get_pgtable_items+0x75>
            start ++;
c0104e4b:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104e4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e52:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e55:	73 1d                	jae    c0104e74 <get_pgtable_items+0x9a>
c0104e57:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e5a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e61:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e64:	01 d0                	add    %edx,%eax
c0104e66:	8b 00                	mov    (%eax),%eax
c0104e68:	83 e0 07             	and    $0x7,%eax
c0104e6b:	89 c2                	mov    %eax,%edx
c0104e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104e70:	39 c2                	cmp    %eax,%edx
c0104e72:	74 d7                	je     c0104e4b <get_pgtable_items+0x71>
        }
        if (right_store != NULL) {
c0104e74:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104e78:	74 08                	je     c0104e82 <get_pgtable_items+0xa8>
            *right_store = start;
c0104e7a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104e7d:	8b 55 10             	mov    0x10(%ebp),%edx
c0104e80:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104e85:	eb 05                	jmp    c0104e8c <get_pgtable_items+0xb2>
    }
    return 0;
c0104e87:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104e8c:	c9                   	leave  
c0104e8d:	c3                   	ret    

c0104e8e <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104e8e:	55                   	push   %ebp
c0104e8f:	89 e5                	mov    %esp,%ebp
c0104e91:	57                   	push   %edi
c0104e92:	56                   	push   %esi
c0104e93:	53                   	push   %ebx
c0104e94:	83 ec 2c             	sub    $0x2c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104e97:	83 ec 0c             	sub    $0xc,%esp
c0104e9a:	68 3c 6b 10 c0       	push   $0xc0106b3c
c0104e9f:	e8 8d b4 ff ff       	call   c0100331 <cprintf>
c0104ea4:	83 c4 10             	add    $0x10,%esp
    size_t left, right = 0, perm;
c0104ea7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104eae:	e9 d9 00 00 00       	jmp    c0104f8c <print_pgdir+0xfe>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104eb6:	83 ec 0c             	sub    $0xc,%esp
c0104eb9:	50                   	push   %eax
c0104eba:	e8 cd fe ff ff       	call   c0104d8c <perm2str>
c0104ebf:	83 c4 10             	add    $0x10,%esp
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104ec2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ec5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104ec8:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104eca:	89 d6                	mov    %edx,%esi
c0104ecc:	c1 e6 16             	shl    $0x16,%esi
c0104ecf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ed2:	89 d3                	mov    %edx,%ebx
c0104ed4:	c1 e3 16             	shl    $0x16,%ebx
c0104ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104eda:	89 d1                	mov    %edx,%ecx
c0104edc:	c1 e1 16             	shl    $0x16,%ecx
c0104edf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ee2:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0104ee5:	29 fa                	sub    %edi,%edx
c0104ee7:	83 ec 08             	sub    $0x8,%esp
c0104eea:	50                   	push   %eax
c0104eeb:	56                   	push   %esi
c0104eec:	53                   	push   %ebx
c0104eed:	51                   	push   %ecx
c0104eee:	52                   	push   %edx
c0104eef:	68 6d 6b 10 c0       	push   $0xc0106b6d
c0104ef4:	e8 38 b4 ff ff       	call   c0100331 <cprintf>
c0104ef9:	83 c4 20             	add    $0x20,%esp
        size_t l, r = left * NPTEENTRY;
c0104efc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104eff:	c1 e0 0a             	shl    $0xa,%eax
c0104f02:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104f05:	eb 49                	jmp    c0104f50 <print_pgdir+0xc2>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104f07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f0a:	83 ec 0c             	sub    $0xc,%esp
c0104f0d:	50                   	push   %eax
c0104f0e:	e8 79 fe ff ff       	call   c0104d8c <perm2str>
c0104f13:	83 c4 10             	add    $0x10,%esp
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104f16:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f19:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0104f1c:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104f1e:	89 d6                	mov    %edx,%esi
c0104f20:	c1 e6 0c             	shl    $0xc,%esi
c0104f23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f26:	89 d3                	mov    %edx,%ebx
c0104f28:	c1 e3 0c             	shl    $0xc,%ebx
c0104f2b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f2e:	89 d1                	mov    %edx,%ecx
c0104f30:	c1 e1 0c             	shl    $0xc,%ecx
c0104f33:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f36:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0104f39:	29 fa                	sub    %edi,%edx
c0104f3b:	83 ec 08             	sub    $0x8,%esp
c0104f3e:	50                   	push   %eax
c0104f3f:	56                   	push   %esi
c0104f40:	53                   	push   %ebx
c0104f41:	51                   	push   %ecx
c0104f42:	52                   	push   %edx
c0104f43:	68 8c 6b 10 c0       	push   $0xc0106b8c
c0104f48:	e8 e4 b3 ff ff       	call   c0100331 <cprintf>
c0104f4d:	83 c4 20             	add    $0x20,%esp
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104f50:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104f55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104f58:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f5b:	89 d3                	mov    %edx,%ebx
c0104f5d:	c1 e3 0a             	shl    $0xa,%ebx
c0104f60:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f63:	89 d1                	mov    %edx,%ecx
c0104f65:	c1 e1 0a             	shl    $0xa,%ecx
c0104f68:	83 ec 08             	sub    $0x8,%esp
c0104f6b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c0104f6e:	52                   	push   %edx
c0104f6f:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0104f72:	52                   	push   %edx
c0104f73:	56                   	push   %esi
c0104f74:	50                   	push   %eax
c0104f75:	53                   	push   %ebx
c0104f76:	51                   	push   %ecx
c0104f77:	e8 5e fe ff ff       	call   c0104dda <get_pgtable_items>
c0104f7c:	83 c4 20             	add    $0x20,%esp
c0104f7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f86:	0f 85 7b ff ff ff    	jne    c0104f07 <print_pgdir+0x79>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104f8c:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c0104f91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f94:	83 ec 08             	sub    $0x8,%esp
c0104f97:	8d 55 dc             	lea    -0x24(%ebp),%edx
c0104f9a:	52                   	push   %edx
c0104f9b:	8d 55 e0             	lea    -0x20(%ebp),%edx
c0104f9e:	52                   	push   %edx
c0104f9f:	51                   	push   %ecx
c0104fa0:	50                   	push   %eax
c0104fa1:	68 00 04 00 00       	push   $0x400
c0104fa6:	6a 00                	push   $0x0
c0104fa8:	e8 2d fe ff ff       	call   c0104dda <get_pgtable_items>
c0104fad:	83 c4 20             	add    $0x20,%esp
c0104fb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104fb3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104fb7:	0f 85 f6 fe ff ff    	jne    c0104eb3 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104fbd:	83 ec 0c             	sub    $0xc,%esp
c0104fc0:	68 b0 6b 10 c0       	push   $0xc0106bb0
c0104fc5:	e8 67 b3 ff ff       	call   c0100331 <cprintf>
c0104fca:	83 c4 10             	add    $0x10,%esp
}
c0104fcd:	90                   	nop
c0104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
c0104fd1:	5b                   	pop    %ebx
c0104fd2:	5e                   	pop    %esi
c0104fd3:	5f                   	pop    %edi
c0104fd4:	5d                   	pop    %ebp
c0104fd5:	c3                   	ret    

c0104fd6 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0104fd6:	55                   	push   %ebp
c0104fd7:	89 e5                	mov    %esp,%ebp
c0104fd9:	83 ec 38             	sub    $0x38,%esp
c0104fdc:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fdf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104fe2:	8b 45 14             	mov    0x14(%ebp),%eax
c0104fe5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0104fe8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104feb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104fee:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ff1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0104ff4:	8b 45 18             	mov    0x18(%ebp),%eax
c0104ff7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ffd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105000:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105003:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105006:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105009:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010500c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105010:	74 1c                	je     c010502e <printnum+0x58>
c0105012:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105015:	ba 00 00 00 00       	mov    $0x0,%edx
c010501a:	f7 75 e4             	divl   -0x1c(%ebp)
c010501d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105020:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105023:	ba 00 00 00 00       	mov    $0x0,%edx
c0105028:	f7 75 e4             	divl   -0x1c(%ebp)
c010502b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010502e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105031:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105034:	f7 75 e4             	divl   -0x1c(%ebp)
c0105037:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010503a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010503d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105040:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105043:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105046:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105049:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010504c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010504f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105052:	ba 00 00 00 00       	mov    $0x0,%edx
c0105057:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010505a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c010505d:	19 d1                	sbb    %edx,%ecx
c010505f:	72 37                	jb     c0105098 <printnum+0xc2>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105061:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105064:	83 e8 01             	sub    $0x1,%eax
c0105067:	83 ec 04             	sub    $0x4,%esp
c010506a:	ff 75 20             	push   0x20(%ebp)
c010506d:	50                   	push   %eax
c010506e:	ff 75 18             	push   0x18(%ebp)
c0105071:	ff 75 ec             	push   -0x14(%ebp)
c0105074:	ff 75 e8             	push   -0x18(%ebp)
c0105077:	ff 75 0c             	push   0xc(%ebp)
c010507a:	ff 75 08             	push   0x8(%ebp)
c010507d:	e8 54 ff ff ff       	call   c0104fd6 <printnum>
c0105082:	83 c4 20             	add    $0x20,%esp
c0105085:	eb 1b                	jmp    c01050a2 <printnum+0xcc>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105087:	83 ec 08             	sub    $0x8,%esp
c010508a:	ff 75 0c             	push   0xc(%ebp)
c010508d:	ff 75 20             	push   0x20(%ebp)
c0105090:	8b 45 08             	mov    0x8(%ebp),%eax
c0105093:	ff d0                	call   *%eax
c0105095:	83 c4 10             	add    $0x10,%esp
        while (-- width > 0)
c0105098:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010509c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01050a0:	7f e5                	jg     c0105087 <printnum+0xb1>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01050a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01050a5:	05 64 6c 10 c0       	add    $0xc0106c64,%eax
c01050aa:	0f b6 00             	movzbl (%eax),%eax
c01050ad:	0f be c0             	movsbl %al,%eax
c01050b0:	83 ec 08             	sub    $0x8,%esp
c01050b3:	ff 75 0c             	push   0xc(%ebp)
c01050b6:	50                   	push   %eax
c01050b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ba:	ff d0                	call   *%eax
c01050bc:	83 c4 10             	add    $0x10,%esp
}
c01050bf:	90                   	nop
c01050c0:	c9                   	leave  
c01050c1:	c3                   	ret    

c01050c2 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01050c2:	55                   	push   %ebp
c01050c3:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01050c5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01050c9:	7e 14                	jle    c01050df <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01050cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050ce:	8b 00                	mov    (%eax),%eax
c01050d0:	8d 48 08             	lea    0x8(%eax),%ecx
c01050d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01050d6:	89 0a                	mov    %ecx,(%edx)
c01050d8:	8b 50 04             	mov    0x4(%eax),%edx
c01050db:	8b 00                	mov    (%eax),%eax
c01050dd:	eb 30                	jmp    c010510f <getuint+0x4d>
    }
    else if (lflag) {
c01050df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01050e3:	74 16                	je     c01050fb <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01050e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01050e8:	8b 00                	mov    (%eax),%eax
c01050ea:	8d 48 04             	lea    0x4(%eax),%ecx
c01050ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01050f0:	89 0a                	mov    %ecx,(%edx)
c01050f2:	8b 00                	mov    (%eax),%eax
c01050f4:	ba 00 00 00 00       	mov    $0x0,%edx
c01050f9:	eb 14                	jmp    c010510f <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01050fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050fe:	8b 00                	mov    (%eax),%eax
c0105100:	8d 48 04             	lea    0x4(%eax),%ecx
c0105103:	8b 55 08             	mov    0x8(%ebp),%edx
c0105106:	89 0a                	mov    %ecx,(%edx)
c0105108:	8b 00                	mov    (%eax),%eax
c010510a:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010510f:	5d                   	pop    %ebp
c0105110:	c3                   	ret    

c0105111 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105111:	55                   	push   %ebp
c0105112:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105114:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105118:	7e 14                	jle    c010512e <getint+0x1d>
        return va_arg(*ap, long long);
c010511a:	8b 45 08             	mov    0x8(%ebp),%eax
c010511d:	8b 00                	mov    (%eax),%eax
c010511f:	8d 48 08             	lea    0x8(%eax),%ecx
c0105122:	8b 55 08             	mov    0x8(%ebp),%edx
c0105125:	89 0a                	mov    %ecx,(%edx)
c0105127:	8b 50 04             	mov    0x4(%eax),%edx
c010512a:	8b 00                	mov    (%eax),%eax
c010512c:	eb 28                	jmp    c0105156 <getint+0x45>
    }
    else if (lflag) {
c010512e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105132:	74 12                	je     c0105146 <getint+0x35>
        return va_arg(*ap, long);
c0105134:	8b 45 08             	mov    0x8(%ebp),%eax
c0105137:	8b 00                	mov    (%eax),%eax
c0105139:	8d 48 04             	lea    0x4(%eax),%ecx
c010513c:	8b 55 08             	mov    0x8(%ebp),%edx
c010513f:	89 0a                	mov    %ecx,(%edx)
c0105141:	8b 00                	mov    (%eax),%eax
c0105143:	99                   	cltd   
c0105144:	eb 10                	jmp    c0105156 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105146:	8b 45 08             	mov    0x8(%ebp),%eax
c0105149:	8b 00                	mov    (%eax),%eax
c010514b:	8d 48 04             	lea    0x4(%eax),%ecx
c010514e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105151:	89 0a                	mov    %ecx,(%edx)
c0105153:	8b 00                	mov    (%eax),%eax
c0105155:	99                   	cltd   
    }
}
c0105156:	5d                   	pop    %ebp
c0105157:	c3                   	ret    

c0105158 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105158:	55                   	push   %ebp
c0105159:	89 e5                	mov    %esp,%ebp
c010515b:	83 ec 18             	sub    $0x18,%esp
    va_list ap;

    va_start(ap, fmt);
c010515e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105161:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105164:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105167:	50                   	push   %eax
c0105168:	ff 75 10             	push   0x10(%ebp)
c010516b:	ff 75 0c             	push   0xc(%ebp)
c010516e:	ff 75 08             	push   0x8(%ebp)
c0105171:	e8 06 00 00 00       	call   c010517c <vprintfmt>
c0105176:	83 c4 10             	add    $0x10,%esp
    va_end(ap);
}
c0105179:	90                   	nop
c010517a:	c9                   	leave  
c010517b:	c3                   	ret    

c010517c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010517c:	55                   	push   %ebp
c010517d:	89 e5                	mov    %esp,%ebp
c010517f:	56                   	push   %esi
c0105180:	53                   	push   %ebx
c0105181:	83 ec 20             	sub    $0x20,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105184:	eb 17                	jmp    c010519d <vprintfmt+0x21>
            if (ch == '\0') {
c0105186:	85 db                	test   %ebx,%ebx
c0105188:	0f 84 8e 03 00 00    	je     c010551c <vprintfmt+0x3a0>
                return;
            }
            putch(ch, putdat);
c010518e:	83 ec 08             	sub    $0x8,%esp
c0105191:	ff 75 0c             	push   0xc(%ebp)
c0105194:	53                   	push   %ebx
c0105195:	8b 45 08             	mov    0x8(%ebp),%eax
c0105198:	ff d0                	call   *%eax
c010519a:	83 c4 10             	add    $0x10,%esp
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010519d:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a0:	8d 50 01             	lea    0x1(%eax),%edx
c01051a3:	89 55 10             	mov    %edx,0x10(%ebp)
c01051a6:	0f b6 00             	movzbl (%eax),%eax
c01051a9:	0f b6 d8             	movzbl %al,%ebx
c01051ac:	83 fb 25             	cmp    $0x25,%ebx
c01051af:	75 d5                	jne    c0105186 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01051b1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01051b5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01051bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01051c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01051c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051cc:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01051cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01051d2:	8d 50 01             	lea    0x1(%eax),%edx
c01051d5:	89 55 10             	mov    %edx,0x10(%ebp)
c01051d8:	0f b6 00             	movzbl (%eax),%eax
c01051db:	0f b6 d8             	movzbl %al,%ebx
c01051de:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01051e1:	83 f8 55             	cmp    $0x55,%eax
c01051e4:	0f 87 05 03 00 00    	ja     c01054ef <vprintfmt+0x373>
c01051ea:	8b 04 85 88 6c 10 c0 	mov    -0x3fef9378(,%eax,4),%eax
c01051f1:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01051f3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01051f7:	eb d6                	jmp    c01051cf <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01051f9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01051fd:	eb d0                	jmp    c01051cf <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01051ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105206:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105209:	89 d0                	mov    %edx,%eax
c010520b:	c1 e0 02             	shl    $0x2,%eax
c010520e:	01 d0                	add    %edx,%eax
c0105210:	01 c0                	add    %eax,%eax
c0105212:	01 d8                	add    %ebx,%eax
c0105214:	83 e8 30             	sub    $0x30,%eax
c0105217:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010521a:	8b 45 10             	mov    0x10(%ebp),%eax
c010521d:	0f b6 00             	movzbl (%eax),%eax
c0105220:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105223:	83 fb 2f             	cmp    $0x2f,%ebx
c0105226:	7e 39                	jle    c0105261 <vprintfmt+0xe5>
c0105228:	83 fb 39             	cmp    $0x39,%ebx
c010522b:	7f 34                	jg     c0105261 <vprintfmt+0xe5>
            for (precision = 0; ; ++ fmt) {
c010522d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105231:	eb d3                	jmp    c0105206 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105233:	8b 45 14             	mov    0x14(%ebp),%eax
c0105236:	8d 50 04             	lea    0x4(%eax),%edx
c0105239:	89 55 14             	mov    %edx,0x14(%ebp)
c010523c:	8b 00                	mov    (%eax),%eax
c010523e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105241:	eb 1f                	jmp    c0105262 <vprintfmt+0xe6>

        case '.':
            if (width < 0)
c0105243:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105247:	79 86                	jns    c01051cf <vprintfmt+0x53>
                width = 0;
c0105249:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105250:	e9 7a ff ff ff       	jmp    c01051cf <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105255:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010525c:	e9 6e ff ff ff       	jmp    c01051cf <vprintfmt+0x53>
            goto process_precision;
c0105261:	90                   	nop

        process_precision:
            if (width < 0)
c0105262:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105266:	0f 89 63 ff ff ff    	jns    c01051cf <vprintfmt+0x53>
                width = precision, precision = -1;
c010526c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010526f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105272:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105279:	e9 51 ff ff ff       	jmp    c01051cf <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010527e:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105282:	e9 48 ff ff ff       	jmp    c01051cf <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105287:	8b 45 14             	mov    0x14(%ebp),%eax
c010528a:	8d 50 04             	lea    0x4(%eax),%edx
c010528d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105290:	8b 00                	mov    (%eax),%eax
c0105292:	83 ec 08             	sub    $0x8,%esp
c0105295:	ff 75 0c             	push   0xc(%ebp)
c0105298:	50                   	push   %eax
c0105299:	8b 45 08             	mov    0x8(%ebp),%eax
c010529c:	ff d0                	call   *%eax
c010529e:	83 c4 10             	add    $0x10,%esp
            break;
c01052a1:	e9 71 02 00 00       	jmp    c0105517 <vprintfmt+0x39b>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01052a6:	8b 45 14             	mov    0x14(%ebp),%eax
c01052a9:	8d 50 04             	lea    0x4(%eax),%edx
c01052ac:	89 55 14             	mov    %edx,0x14(%ebp)
c01052af:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01052b1:	85 db                	test   %ebx,%ebx
c01052b3:	79 02                	jns    c01052b7 <vprintfmt+0x13b>
                err = -err;
c01052b5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01052b7:	83 fb 06             	cmp    $0x6,%ebx
c01052ba:	7f 0b                	jg     c01052c7 <vprintfmt+0x14b>
c01052bc:	8b 34 9d 48 6c 10 c0 	mov    -0x3fef93b8(,%ebx,4),%esi
c01052c3:	85 f6                	test   %esi,%esi
c01052c5:	75 19                	jne    c01052e0 <vprintfmt+0x164>
                printfmt(putch, putdat, "error %d", err);
c01052c7:	53                   	push   %ebx
c01052c8:	68 75 6c 10 c0       	push   $0xc0106c75
c01052cd:	ff 75 0c             	push   0xc(%ebp)
c01052d0:	ff 75 08             	push   0x8(%ebp)
c01052d3:	e8 80 fe ff ff       	call   c0105158 <printfmt>
c01052d8:	83 c4 10             	add    $0x10,%esp
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01052db:	e9 37 02 00 00       	jmp    c0105517 <vprintfmt+0x39b>
                printfmt(putch, putdat, "%s", p);
c01052e0:	56                   	push   %esi
c01052e1:	68 7e 6c 10 c0       	push   $0xc0106c7e
c01052e6:	ff 75 0c             	push   0xc(%ebp)
c01052e9:	ff 75 08             	push   0x8(%ebp)
c01052ec:	e8 67 fe ff ff       	call   c0105158 <printfmt>
c01052f1:	83 c4 10             	add    $0x10,%esp
            break;
c01052f4:	e9 1e 02 00 00       	jmp    c0105517 <vprintfmt+0x39b>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01052f9:	8b 45 14             	mov    0x14(%ebp),%eax
c01052fc:	8d 50 04             	lea    0x4(%eax),%edx
c01052ff:	89 55 14             	mov    %edx,0x14(%ebp)
c0105302:	8b 30                	mov    (%eax),%esi
c0105304:	85 f6                	test   %esi,%esi
c0105306:	75 05                	jne    c010530d <vprintfmt+0x191>
                p = "(null)";
c0105308:	be 81 6c 10 c0       	mov    $0xc0106c81,%esi
            }
            if (width > 0 && padc != '-') {
c010530d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105311:	7e 76                	jle    c0105389 <vprintfmt+0x20d>
c0105313:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105317:	74 70                	je     c0105389 <vprintfmt+0x20d>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010531c:	83 ec 08             	sub    $0x8,%esp
c010531f:	50                   	push   %eax
c0105320:	56                   	push   %esi
c0105321:	e8 df 02 00 00       	call   c0105605 <strnlen>
c0105326:	83 c4 10             	add    $0x10,%esp
c0105329:	89 c2                	mov    %eax,%edx
c010532b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010532e:	29 d0                	sub    %edx,%eax
c0105330:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105333:	eb 17                	jmp    c010534c <vprintfmt+0x1d0>
                    putch(padc, putdat);
c0105335:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105339:	83 ec 08             	sub    $0x8,%esp
c010533c:	ff 75 0c             	push   0xc(%ebp)
c010533f:	50                   	push   %eax
c0105340:	8b 45 08             	mov    0x8(%ebp),%eax
c0105343:	ff d0                	call   *%eax
c0105345:	83 c4 10             	add    $0x10,%esp
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105348:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010534c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105350:	7f e3                	jg     c0105335 <vprintfmt+0x1b9>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105352:	eb 35                	jmp    c0105389 <vprintfmt+0x20d>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105354:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105358:	74 1c                	je     c0105376 <vprintfmt+0x1fa>
c010535a:	83 fb 1f             	cmp    $0x1f,%ebx
c010535d:	7e 05                	jle    c0105364 <vprintfmt+0x1e8>
c010535f:	83 fb 7e             	cmp    $0x7e,%ebx
c0105362:	7e 12                	jle    c0105376 <vprintfmt+0x1fa>
                    putch('?', putdat);
c0105364:	83 ec 08             	sub    $0x8,%esp
c0105367:	ff 75 0c             	push   0xc(%ebp)
c010536a:	6a 3f                	push   $0x3f
c010536c:	8b 45 08             	mov    0x8(%ebp),%eax
c010536f:	ff d0                	call   *%eax
c0105371:	83 c4 10             	add    $0x10,%esp
c0105374:	eb 0f                	jmp    c0105385 <vprintfmt+0x209>
                }
                else {
                    putch(ch, putdat);
c0105376:	83 ec 08             	sub    $0x8,%esp
c0105379:	ff 75 0c             	push   0xc(%ebp)
c010537c:	53                   	push   %ebx
c010537d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105380:	ff d0                	call   *%eax
c0105382:	83 c4 10             	add    $0x10,%esp
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105385:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105389:	89 f0                	mov    %esi,%eax
c010538b:	8d 70 01             	lea    0x1(%eax),%esi
c010538e:	0f b6 00             	movzbl (%eax),%eax
c0105391:	0f be d8             	movsbl %al,%ebx
c0105394:	85 db                	test   %ebx,%ebx
c0105396:	74 26                	je     c01053be <vprintfmt+0x242>
c0105398:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010539c:	78 b6                	js     c0105354 <vprintfmt+0x1d8>
c010539e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01053a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053a6:	79 ac                	jns    c0105354 <vprintfmt+0x1d8>
                }
            }
            for (; width > 0; width --) {
c01053a8:	eb 14                	jmp    c01053be <vprintfmt+0x242>
                putch(' ', putdat);
c01053aa:	83 ec 08             	sub    $0x8,%esp
c01053ad:	ff 75 0c             	push   0xc(%ebp)
c01053b0:	6a 20                	push   $0x20
c01053b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b5:	ff d0                	call   *%eax
c01053b7:	83 c4 10             	add    $0x10,%esp
            for (; width > 0; width --) {
c01053ba:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01053be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01053c2:	7f e6                	jg     c01053aa <vprintfmt+0x22e>
            }
            break;
c01053c4:	e9 4e 01 00 00       	jmp    c0105517 <vprintfmt+0x39b>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01053c9:	83 ec 08             	sub    $0x8,%esp
c01053cc:	ff 75 e0             	push   -0x20(%ebp)
c01053cf:	8d 45 14             	lea    0x14(%ebp),%eax
c01053d2:	50                   	push   %eax
c01053d3:	e8 39 fd ff ff       	call   c0105111 <getint>
c01053d8:	83 c4 10             	add    $0x10,%esp
c01053db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053de:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01053e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053e7:	85 d2                	test   %edx,%edx
c01053e9:	79 23                	jns    c010540e <vprintfmt+0x292>
                putch('-', putdat);
c01053eb:	83 ec 08             	sub    $0x8,%esp
c01053ee:	ff 75 0c             	push   0xc(%ebp)
c01053f1:	6a 2d                	push   $0x2d
c01053f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f6:	ff d0                	call   *%eax
c01053f8:	83 c4 10             	add    $0x10,%esp
                num = -(long long)num;
c01053fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105401:	f7 d8                	neg    %eax
c0105403:	83 d2 00             	adc    $0x0,%edx
c0105406:	f7 da                	neg    %edx
c0105408:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010540b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010540e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105415:	e9 9f 00 00 00       	jmp    c01054b9 <vprintfmt+0x33d>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010541a:	83 ec 08             	sub    $0x8,%esp
c010541d:	ff 75 e0             	push   -0x20(%ebp)
c0105420:	8d 45 14             	lea    0x14(%ebp),%eax
c0105423:	50                   	push   %eax
c0105424:	e8 99 fc ff ff       	call   c01050c2 <getuint>
c0105429:	83 c4 10             	add    $0x10,%esp
c010542c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010542f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105432:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105439:	eb 7e                	jmp    c01054b9 <vprintfmt+0x33d>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010543b:	83 ec 08             	sub    $0x8,%esp
c010543e:	ff 75 e0             	push   -0x20(%ebp)
c0105441:	8d 45 14             	lea    0x14(%ebp),%eax
c0105444:	50                   	push   %eax
c0105445:	e8 78 fc ff ff       	call   c01050c2 <getuint>
c010544a:	83 c4 10             	add    $0x10,%esp
c010544d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105450:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105453:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010545a:	eb 5d                	jmp    c01054b9 <vprintfmt+0x33d>

        // pointer
        case 'p':
            putch('0', putdat);
c010545c:	83 ec 08             	sub    $0x8,%esp
c010545f:	ff 75 0c             	push   0xc(%ebp)
c0105462:	6a 30                	push   $0x30
c0105464:	8b 45 08             	mov    0x8(%ebp),%eax
c0105467:	ff d0                	call   *%eax
c0105469:	83 c4 10             	add    $0x10,%esp
            putch('x', putdat);
c010546c:	83 ec 08             	sub    $0x8,%esp
c010546f:	ff 75 0c             	push   0xc(%ebp)
c0105472:	6a 78                	push   $0x78
c0105474:	8b 45 08             	mov    0x8(%ebp),%eax
c0105477:	ff d0                	call   *%eax
c0105479:	83 c4 10             	add    $0x10,%esp
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010547c:	8b 45 14             	mov    0x14(%ebp),%eax
c010547f:	8d 50 04             	lea    0x4(%eax),%edx
c0105482:	89 55 14             	mov    %edx,0x14(%ebp)
c0105485:	8b 00                	mov    (%eax),%eax
c0105487:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010548a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105491:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105498:	eb 1f                	jmp    c01054b9 <vprintfmt+0x33d>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010549a:	83 ec 08             	sub    $0x8,%esp
c010549d:	ff 75 e0             	push   -0x20(%ebp)
c01054a0:	8d 45 14             	lea    0x14(%ebp),%eax
c01054a3:	50                   	push   %eax
c01054a4:	e8 19 fc ff ff       	call   c01050c2 <getuint>
c01054a9:	83 c4 10             	add    $0x10,%esp
c01054ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054af:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01054b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01054b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01054bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01054c0:	83 ec 04             	sub    $0x4,%esp
c01054c3:	52                   	push   %edx
c01054c4:	ff 75 e8             	push   -0x18(%ebp)
c01054c7:	50                   	push   %eax
c01054c8:	ff 75 f4             	push   -0xc(%ebp)
c01054cb:	ff 75 f0             	push   -0x10(%ebp)
c01054ce:	ff 75 0c             	push   0xc(%ebp)
c01054d1:	ff 75 08             	push   0x8(%ebp)
c01054d4:	e8 fd fa ff ff       	call   c0104fd6 <printnum>
c01054d9:	83 c4 20             	add    $0x20,%esp
            break;
c01054dc:	eb 39                	jmp    c0105517 <vprintfmt+0x39b>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01054de:	83 ec 08             	sub    $0x8,%esp
c01054e1:	ff 75 0c             	push   0xc(%ebp)
c01054e4:	53                   	push   %ebx
c01054e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e8:	ff d0                	call   *%eax
c01054ea:	83 c4 10             	add    $0x10,%esp
            break;
c01054ed:	eb 28                	jmp    c0105517 <vprintfmt+0x39b>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01054ef:	83 ec 08             	sub    $0x8,%esp
c01054f2:	ff 75 0c             	push   0xc(%ebp)
c01054f5:	6a 25                	push   $0x25
c01054f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01054fa:	ff d0                	call   *%eax
c01054fc:	83 c4 10             	add    $0x10,%esp
            for (fmt --; fmt[-1] != '%'; fmt --)
c01054ff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105503:	eb 04                	jmp    c0105509 <vprintfmt+0x38d>
c0105505:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105509:	8b 45 10             	mov    0x10(%ebp),%eax
c010550c:	83 e8 01             	sub    $0x1,%eax
c010550f:	0f b6 00             	movzbl (%eax),%eax
c0105512:	3c 25                	cmp    $0x25,%al
c0105514:	75 ef                	jne    c0105505 <vprintfmt+0x389>
                /* do nothing */;
            break;
c0105516:	90                   	nop
    while (1) {
c0105517:	e9 68 fc ff ff       	jmp    c0105184 <vprintfmt+0x8>
                return;
c010551c:	90                   	nop
        }
    }
}
c010551d:	8d 65 f8             	lea    -0x8(%ebp),%esp
c0105520:	5b                   	pop    %ebx
c0105521:	5e                   	pop    %esi
c0105522:	5d                   	pop    %ebp
c0105523:	c3                   	ret    

c0105524 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105524:	55                   	push   %ebp
c0105525:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105527:	8b 45 0c             	mov    0xc(%ebp),%eax
c010552a:	8b 40 08             	mov    0x8(%eax),%eax
c010552d:	8d 50 01             	lea    0x1(%eax),%edx
c0105530:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105533:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105536:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105539:	8b 10                	mov    (%eax),%edx
c010553b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010553e:	8b 40 04             	mov    0x4(%eax),%eax
c0105541:	39 c2                	cmp    %eax,%edx
c0105543:	73 12                	jae    c0105557 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105548:	8b 00                	mov    (%eax),%eax
c010554a:	8d 48 01             	lea    0x1(%eax),%ecx
c010554d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105550:	89 0a                	mov    %ecx,(%edx)
c0105552:	8b 55 08             	mov    0x8(%ebp),%edx
c0105555:	88 10                	mov    %dl,(%eax)
    }
}
c0105557:	90                   	nop
c0105558:	5d                   	pop    %ebp
c0105559:	c3                   	ret    

c010555a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010555a:	55                   	push   %ebp
c010555b:	89 e5                	mov    %esp,%ebp
c010555d:	83 ec 18             	sub    $0x18,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105560:	8d 45 14             	lea    0x14(%ebp),%eax
c0105563:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105566:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105569:	50                   	push   %eax
c010556a:	ff 75 10             	push   0x10(%ebp)
c010556d:	ff 75 0c             	push   0xc(%ebp)
c0105570:	ff 75 08             	push   0x8(%ebp)
c0105573:	e8 0b 00 00 00       	call   c0105583 <vsnprintf>
c0105578:	83 c4 10             	add    $0x10,%esp
c010557b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010557e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105581:	c9                   	leave  
c0105582:	c3                   	ret    

c0105583 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105583:	55                   	push   %ebp
c0105584:	89 e5                	mov    %esp,%ebp
c0105586:	83 ec 18             	sub    $0x18,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105589:	8b 45 08             	mov    0x8(%ebp),%eax
c010558c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010558f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105592:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105595:	8b 45 08             	mov    0x8(%ebp),%eax
c0105598:	01 d0                	add    %edx,%eax
c010559a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010559d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01055a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01055a8:	74 0a                	je     c01055b4 <vsnprintf+0x31>
c01055aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01055ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055b0:	39 c2                	cmp    %eax,%edx
c01055b2:	76 07                	jbe    c01055bb <vsnprintf+0x38>
        return -E_INVAL;
c01055b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01055b9:	eb 20                	jmp    c01055db <vsnprintf+0x58>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01055bb:	ff 75 14             	push   0x14(%ebp)
c01055be:	ff 75 10             	push   0x10(%ebp)
c01055c1:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01055c4:	50                   	push   %eax
c01055c5:	68 24 55 10 c0       	push   $0xc0105524
c01055ca:	e8 ad fb ff ff       	call   c010517c <vprintfmt>
c01055cf:	83 c4 10             	add    $0x10,%esp
    // null terminate the buffer
    *b.buf = '\0';
c01055d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01055d5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01055d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01055db:	c9                   	leave  
c01055dc:	c3                   	ret    

c01055dd <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01055dd:	55                   	push   %ebp
c01055de:	89 e5                	mov    %esp,%ebp
c01055e0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01055e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055ea:	eb 04                	jmp    c01055f0 <strlen+0x13>
        cnt ++;
c01055ec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f3:	8d 50 01             	lea    0x1(%eax),%edx
c01055f6:	89 55 08             	mov    %edx,0x8(%ebp)
c01055f9:	0f b6 00             	movzbl (%eax),%eax
c01055fc:	84 c0                	test   %al,%al
c01055fe:	75 ec                	jne    c01055ec <strlen+0xf>
    }
    return cnt;
c0105600:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105603:	c9                   	leave  
c0105604:	c3                   	ret    

c0105605 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105605:	55                   	push   %ebp
c0105606:	89 e5                	mov    %esp,%ebp
c0105608:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010560b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105612:	eb 04                	jmp    c0105618 <strnlen+0x13>
        cnt ++;
c0105614:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105618:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010561b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010561e:	73 10                	jae    c0105630 <strnlen+0x2b>
c0105620:	8b 45 08             	mov    0x8(%ebp),%eax
c0105623:	8d 50 01             	lea    0x1(%eax),%edx
c0105626:	89 55 08             	mov    %edx,0x8(%ebp)
c0105629:	0f b6 00             	movzbl (%eax),%eax
c010562c:	84 c0                	test   %al,%al
c010562e:	75 e4                	jne    c0105614 <strnlen+0xf>
    }
    return cnt;
c0105630:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105633:	c9                   	leave  
c0105634:	c3                   	ret    

c0105635 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105635:	55                   	push   %ebp
c0105636:	89 e5                	mov    %esp,%ebp
c0105638:	57                   	push   %edi
c0105639:	56                   	push   %esi
c010563a:	83 ec 20             	sub    $0x20,%esp
c010563d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105640:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105643:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105646:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105649:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010564c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010564f:	89 d1                	mov    %edx,%ecx
c0105651:	89 c2                	mov    %eax,%edx
c0105653:	89 ce                	mov    %ecx,%esi
c0105655:	89 d7                	mov    %edx,%edi
c0105657:	ac                   	lods   %ds:(%esi),%al
c0105658:	aa                   	stos   %al,%es:(%edi)
c0105659:	84 c0                	test   %al,%al
c010565b:	75 fa                	jne    c0105657 <strcpy+0x22>
c010565d:	89 fa                	mov    %edi,%edx
c010565f:	89 f1                	mov    %esi,%ecx
c0105661:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105664:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010566a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010566d:	83 c4 20             	add    $0x20,%esp
c0105670:	5e                   	pop    %esi
c0105671:	5f                   	pop    %edi
c0105672:	5d                   	pop    %ebp
c0105673:	c3                   	ret    

c0105674 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105674:	55                   	push   %ebp
c0105675:	89 e5                	mov    %esp,%ebp
c0105677:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010567a:	8b 45 08             	mov    0x8(%ebp),%eax
c010567d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105680:	eb 21                	jmp    c01056a3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105682:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105685:	0f b6 10             	movzbl (%eax),%edx
c0105688:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010568b:	88 10                	mov    %dl,(%eax)
c010568d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105690:	0f b6 00             	movzbl (%eax),%eax
c0105693:	84 c0                	test   %al,%al
c0105695:	74 04                	je     c010569b <strncpy+0x27>
            src ++;
c0105697:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010569b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010569f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c01056a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056a7:	75 d9                	jne    c0105682 <strncpy+0xe>
    }
    return dst;
c01056a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01056ac:	c9                   	leave  
c01056ad:	c3                   	ret    

c01056ae <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01056ae:	55                   	push   %ebp
c01056af:	89 e5                	mov    %esp,%ebp
c01056b1:	57                   	push   %edi
c01056b2:	56                   	push   %esi
c01056b3:	83 ec 20             	sub    $0x20,%esp
c01056b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01056bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01056c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056c8:	89 d1                	mov    %edx,%ecx
c01056ca:	89 c2                	mov    %eax,%edx
c01056cc:	89 ce                	mov    %ecx,%esi
c01056ce:	89 d7                	mov    %edx,%edi
c01056d0:	ac                   	lods   %ds:(%esi),%al
c01056d1:	ae                   	scas   %es:(%edi),%al
c01056d2:	75 08                	jne    c01056dc <strcmp+0x2e>
c01056d4:	84 c0                	test   %al,%al
c01056d6:	75 f8                	jne    c01056d0 <strcmp+0x22>
c01056d8:	31 c0                	xor    %eax,%eax
c01056da:	eb 04                	jmp    c01056e0 <strcmp+0x32>
c01056dc:	19 c0                	sbb    %eax,%eax
c01056de:	0c 01                	or     $0x1,%al
c01056e0:	89 fa                	mov    %edi,%edx
c01056e2:	89 f1                	mov    %esi,%ecx
c01056e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01056e7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01056ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01056ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01056f0:	83 c4 20             	add    $0x20,%esp
c01056f3:	5e                   	pop    %esi
c01056f4:	5f                   	pop    %edi
c01056f5:	5d                   	pop    %ebp
c01056f6:	c3                   	ret    

c01056f7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01056f7:	55                   	push   %ebp
c01056f8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056fa:	eb 0c                	jmp    c0105708 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01056fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105700:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105704:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105708:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010570c:	74 1a                	je     c0105728 <strncmp+0x31>
c010570e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105711:	0f b6 00             	movzbl (%eax),%eax
c0105714:	84 c0                	test   %al,%al
c0105716:	74 10                	je     c0105728 <strncmp+0x31>
c0105718:	8b 45 08             	mov    0x8(%ebp),%eax
c010571b:	0f b6 10             	movzbl (%eax),%edx
c010571e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105721:	0f b6 00             	movzbl (%eax),%eax
c0105724:	38 c2                	cmp    %al,%dl
c0105726:	74 d4                	je     c01056fc <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010572c:	74 18                	je     c0105746 <strncmp+0x4f>
c010572e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105731:	0f b6 00             	movzbl (%eax),%eax
c0105734:	0f b6 d0             	movzbl %al,%edx
c0105737:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573a:	0f b6 00             	movzbl (%eax),%eax
c010573d:	0f b6 c8             	movzbl %al,%ecx
c0105740:	89 d0                	mov    %edx,%eax
c0105742:	29 c8                	sub    %ecx,%eax
c0105744:	eb 05                	jmp    c010574b <strncmp+0x54>
c0105746:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010574b:	5d                   	pop    %ebp
c010574c:	c3                   	ret    

c010574d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010574d:	55                   	push   %ebp
c010574e:	89 e5                	mov    %esp,%ebp
c0105750:	83 ec 04             	sub    $0x4,%esp
c0105753:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105756:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105759:	eb 14                	jmp    c010576f <strchr+0x22>
        if (*s == c) {
c010575b:	8b 45 08             	mov    0x8(%ebp),%eax
c010575e:	0f b6 00             	movzbl (%eax),%eax
c0105761:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105764:	75 05                	jne    c010576b <strchr+0x1e>
            return (char *)s;
c0105766:	8b 45 08             	mov    0x8(%ebp),%eax
c0105769:	eb 13                	jmp    c010577e <strchr+0x31>
        }
        s ++;
c010576b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010576f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105772:	0f b6 00             	movzbl (%eax),%eax
c0105775:	84 c0                	test   %al,%al
c0105777:	75 e2                	jne    c010575b <strchr+0xe>
    }
    return NULL;
c0105779:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010577e:	c9                   	leave  
c010577f:	c3                   	ret    

c0105780 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105780:	55                   	push   %ebp
c0105781:	89 e5                	mov    %esp,%ebp
c0105783:	83 ec 04             	sub    $0x4,%esp
c0105786:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105789:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010578c:	eb 0f                	jmp    c010579d <strfind+0x1d>
        if (*s == c) {
c010578e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105791:	0f b6 00             	movzbl (%eax),%eax
c0105794:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105797:	74 10                	je     c01057a9 <strfind+0x29>
            break;
        }
        s ++;
c0105799:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c010579d:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a0:	0f b6 00             	movzbl (%eax),%eax
c01057a3:	84 c0                	test   %al,%al
c01057a5:	75 e7                	jne    c010578e <strfind+0xe>
c01057a7:	eb 01                	jmp    c01057aa <strfind+0x2a>
            break;
c01057a9:	90                   	nop
    }
    return (char *)s;
c01057aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01057ad:	c9                   	leave  
c01057ae:	c3                   	ret    

c01057af <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01057af:	55                   	push   %ebp
c01057b0:	89 e5                	mov    %esp,%ebp
c01057b2:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01057b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01057bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01057c3:	eb 04                	jmp    c01057c9 <strtol+0x1a>
        s ++;
c01057c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01057c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cc:	0f b6 00             	movzbl (%eax),%eax
c01057cf:	3c 20                	cmp    $0x20,%al
c01057d1:	74 f2                	je     c01057c5 <strtol+0x16>
c01057d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d6:	0f b6 00             	movzbl (%eax),%eax
c01057d9:	3c 09                	cmp    $0x9,%al
c01057db:	74 e8                	je     c01057c5 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01057dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e0:	0f b6 00             	movzbl (%eax),%eax
c01057e3:	3c 2b                	cmp    $0x2b,%al
c01057e5:	75 06                	jne    c01057ed <strtol+0x3e>
        s ++;
c01057e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057eb:	eb 15                	jmp    c0105802 <strtol+0x53>
    }
    else if (*s == '-') {
c01057ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f0:	0f b6 00             	movzbl (%eax),%eax
c01057f3:	3c 2d                	cmp    $0x2d,%al
c01057f5:	75 0b                	jne    c0105802 <strtol+0x53>
        s ++, neg = 1;
c01057f7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057fb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105802:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105806:	74 06                	je     c010580e <strtol+0x5f>
c0105808:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010580c:	75 24                	jne    c0105832 <strtol+0x83>
c010580e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105811:	0f b6 00             	movzbl (%eax),%eax
c0105814:	3c 30                	cmp    $0x30,%al
c0105816:	75 1a                	jne    c0105832 <strtol+0x83>
c0105818:	8b 45 08             	mov    0x8(%ebp),%eax
c010581b:	83 c0 01             	add    $0x1,%eax
c010581e:	0f b6 00             	movzbl (%eax),%eax
c0105821:	3c 78                	cmp    $0x78,%al
c0105823:	75 0d                	jne    c0105832 <strtol+0x83>
        s += 2, base = 16;
c0105825:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105829:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105830:	eb 2a                	jmp    c010585c <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105832:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105836:	75 17                	jne    c010584f <strtol+0xa0>
c0105838:	8b 45 08             	mov    0x8(%ebp),%eax
c010583b:	0f b6 00             	movzbl (%eax),%eax
c010583e:	3c 30                	cmp    $0x30,%al
c0105840:	75 0d                	jne    c010584f <strtol+0xa0>
        s ++, base = 8;
c0105842:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105846:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010584d:	eb 0d                	jmp    c010585c <strtol+0xad>
    }
    else if (base == 0) {
c010584f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105853:	75 07                	jne    c010585c <strtol+0xad>
        base = 10;
c0105855:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010585c:	8b 45 08             	mov    0x8(%ebp),%eax
c010585f:	0f b6 00             	movzbl (%eax),%eax
c0105862:	3c 2f                	cmp    $0x2f,%al
c0105864:	7e 1b                	jle    c0105881 <strtol+0xd2>
c0105866:	8b 45 08             	mov    0x8(%ebp),%eax
c0105869:	0f b6 00             	movzbl (%eax),%eax
c010586c:	3c 39                	cmp    $0x39,%al
c010586e:	7f 11                	jg     c0105881 <strtol+0xd2>
            dig = *s - '0';
c0105870:	8b 45 08             	mov    0x8(%ebp),%eax
c0105873:	0f b6 00             	movzbl (%eax),%eax
c0105876:	0f be c0             	movsbl %al,%eax
c0105879:	83 e8 30             	sub    $0x30,%eax
c010587c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010587f:	eb 48                	jmp    c01058c9 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105881:	8b 45 08             	mov    0x8(%ebp),%eax
c0105884:	0f b6 00             	movzbl (%eax),%eax
c0105887:	3c 60                	cmp    $0x60,%al
c0105889:	7e 1b                	jle    c01058a6 <strtol+0xf7>
c010588b:	8b 45 08             	mov    0x8(%ebp),%eax
c010588e:	0f b6 00             	movzbl (%eax),%eax
c0105891:	3c 7a                	cmp    $0x7a,%al
c0105893:	7f 11                	jg     c01058a6 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105895:	8b 45 08             	mov    0x8(%ebp),%eax
c0105898:	0f b6 00             	movzbl (%eax),%eax
c010589b:	0f be c0             	movsbl %al,%eax
c010589e:	83 e8 57             	sub    $0x57,%eax
c01058a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058a4:	eb 23                	jmp    c01058c9 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01058a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058a9:	0f b6 00             	movzbl (%eax),%eax
c01058ac:	3c 40                	cmp    $0x40,%al
c01058ae:	7e 3c                	jle    c01058ec <strtol+0x13d>
c01058b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b3:	0f b6 00             	movzbl (%eax),%eax
c01058b6:	3c 5a                	cmp    $0x5a,%al
c01058b8:	7f 32                	jg     c01058ec <strtol+0x13d>
            dig = *s - 'A' + 10;
c01058ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01058bd:	0f b6 00             	movzbl (%eax),%eax
c01058c0:	0f be c0             	movsbl %al,%eax
c01058c3:	83 e8 37             	sub    $0x37,%eax
c01058c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01058c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058cc:	3b 45 10             	cmp    0x10(%ebp),%eax
c01058cf:	7d 1a                	jge    c01058eb <strtol+0x13c>
            break;
        }
        s ++, val = (val * base) + dig;
c01058d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058d8:	0f af 45 10          	imul   0x10(%ebp),%eax
c01058dc:	89 c2                	mov    %eax,%edx
c01058de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058e1:	01 d0                	add    %edx,%eax
c01058e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01058e6:	e9 71 ff ff ff       	jmp    c010585c <strtol+0xad>
            break;
c01058eb:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01058ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058f0:	74 08                	je     c01058fa <strtol+0x14b>
        *endptr = (char *) s;
c01058f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01058f8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01058fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01058fe:	74 07                	je     c0105907 <strtol+0x158>
c0105900:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105903:	f7 d8                	neg    %eax
c0105905:	eb 03                	jmp    c010590a <strtol+0x15b>
c0105907:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010590a:	c9                   	leave  
c010590b:	c3                   	ret    

c010590c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010590c:	55                   	push   %ebp
c010590d:	89 e5                	mov    %esp,%ebp
c010590f:	57                   	push   %edi
c0105910:	83 ec 24             	sub    $0x24,%esp
c0105913:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105916:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105919:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c010591d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105920:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105923:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105926:	8b 45 10             	mov    0x10(%ebp),%eax
c0105929:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010592c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010592f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105933:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105936:	89 d7                	mov    %edx,%edi
c0105938:	f3 aa                	rep stos %al,%es:(%edi)
c010593a:	89 fa                	mov    %edi,%edx
c010593c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010593f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105942:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105945:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105948:	c9                   	leave  
c0105949:	c3                   	ret    

c010594a <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010594a:	55                   	push   %ebp
c010594b:	89 e5                	mov    %esp,%ebp
c010594d:	57                   	push   %edi
c010594e:	56                   	push   %esi
c010594f:	53                   	push   %ebx
c0105950:	83 ec 30             	sub    $0x30,%esp
c0105953:	8b 45 08             	mov    0x8(%ebp),%eax
c0105956:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105959:	8b 45 0c             	mov    0xc(%ebp),%eax
c010595c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010595f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105962:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105965:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105968:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010596b:	73 42                	jae    c01059af <memmove+0x65>
c010596d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105970:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105973:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105976:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105979:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010597c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010597f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105982:	c1 e8 02             	shr    $0x2,%eax
c0105985:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105987:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010598a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010598d:	89 d7                	mov    %edx,%edi
c010598f:	89 c6                	mov    %eax,%esi
c0105991:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105993:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105996:	83 e1 03             	and    $0x3,%ecx
c0105999:	74 02                	je     c010599d <memmove+0x53>
c010599b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010599d:	89 f0                	mov    %esi,%eax
c010599f:	89 fa                	mov    %edi,%edx
c01059a1:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01059a4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01059a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01059aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c01059ad:	eb 36                	jmp    c01059e5 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01059af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059b2:	8d 50 ff             	lea    -0x1(%eax),%edx
c01059b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059b8:	01 c2                	add    %eax,%edx
c01059ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059bd:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01059c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059c3:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01059c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01059c9:	89 c1                	mov    %eax,%ecx
c01059cb:	89 d8                	mov    %ebx,%eax
c01059cd:	89 d6                	mov    %edx,%esi
c01059cf:	89 c7                	mov    %eax,%edi
c01059d1:	fd                   	std    
c01059d2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059d4:	fc                   	cld    
c01059d5:	89 f8                	mov    %edi,%eax
c01059d7:	89 f2                	mov    %esi,%edx
c01059d9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01059dc:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01059df:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01059e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01059e5:	83 c4 30             	add    $0x30,%esp
c01059e8:	5b                   	pop    %ebx
c01059e9:	5e                   	pop    %esi
c01059ea:	5f                   	pop    %edi
c01059eb:	5d                   	pop    %ebp
c01059ec:	c3                   	ret    

c01059ed <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01059ed:	55                   	push   %ebp
c01059ee:	89 e5                	mov    %esp,%ebp
c01059f0:	57                   	push   %edi
c01059f1:	56                   	push   %esi
c01059f2:	83 ec 20             	sub    $0x20,%esp
c01059f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a01:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a04:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a0a:	c1 e8 02             	shr    $0x2,%eax
c0105a0d:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105a0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a15:	89 d7                	mov    %edx,%edi
c0105a17:	89 c6                	mov    %eax,%esi
c0105a19:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a1b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105a1e:	83 e1 03             	and    $0x3,%ecx
c0105a21:	74 02                	je     c0105a25 <memcpy+0x38>
c0105a23:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105a25:	89 f0                	mov    %esi,%eax
c0105a27:	89 fa                	mov    %edi,%edx
c0105a29:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a2c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105a2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105a35:	83 c4 20             	add    $0x20,%esp
c0105a38:	5e                   	pop    %esi
c0105a39:	5f                   	pop    %edi
c0105a3a:	5d                   	pop    %ebp
c0105a3b:	c3                   	ret    

c0105a3c <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105a3c:	55                   	push   %ebp
c0105a3d:	89 e5                	mov    %esp,%ebp
c0105a3f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a45:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105a48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105a4e:	eb 30                	jmp    c0105a80 <memcmp+0x44>
        if (*s1 != *s2) {
c0105a50:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a53:	0f b6 10             	movzbl (%eax),%edx
c0105a56:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a59:	0f b6 00             	movzbl (%eax),%eax
c0105a5c:	38 c2                	cmp    %al,%dl
c0105a5e:	74 18                	je     c0105a78 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a63:	0f b6 00             	movzbl (%eax),%eax
c0105a66:	0f b6 d0             	movzbl %al,%edx
c0105a69:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a6c:	0f b6 00             	movzbl (%eax),%eax
c0105a6f:	0f b6 c8             	movzbl %al,%ecx
c0105a72:	89 d0                	mov    %edx,%eax
c0105a74:	29 c8                	sub    %ecx,%eax
c0105a76:	eb 1a                	jmp    c0105a92 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105a78:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a7c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105a80:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a83:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a86:	89 55 10             	mov    %edx,0x10(%ebp)
c0105a89:	85 c0                	test   %eax,%eax
c0105a8b:	75 c3                	jne    c0105a50 <memcmp+0x14>
    }
    return 0;
c0105a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a92:	c9                   	leave  
c0105a93:	c3                   	ret    
