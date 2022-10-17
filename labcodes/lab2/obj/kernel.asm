
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
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0100041:	2d 00 b0 11 c0       	sub    $0xc011b000,%eax
c0100046:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100051:	00 
c0100052:	c7 04 24 00 b0 11 c0 	movl   $0xc011b000,(%esp)
c0100059:	e8 2e 5a 00 00       	call   c0105a8c <memset>

    cons_init();                // init the console
c010005e:	e8 32 15 00 00       	call   c0101595 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100063:	c7 45 f4 20 5c 10 c0 	movl   $0xc0105c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010006d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100071:	c7 04 24 3c 5c 10 c0 	movl   $0xc0105c3c,(%esp)
c0100078:	e8 d9 02 00 00       	call   c0100356 <cprintf>

    print_kerninfo();
c010007d:	e8 f7 07 00 00       	call   c0100879 <print_kerninfo>

    grade_backtrace();
c0100082:	e8 90 00 00 00       	call   c0100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100087:	e8 0a 41 00 00       	call   c0104196 <pmm_init>

    pic_init();                 // init interrupt controller
c010008c:	e8 85 16 00 00       	call   c0101716 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100091:	e8 e9 17 00 00       	call   c010187f <idt_init>

    clock_init();               // init clock interrupt
c0100096:	e8 59 0c 00 00       	call   c0100cf4 <clock_init>
    intr_enable();              // enable irq interrupt
c010009b:	e8 d4 15 00 00       	call   c0101674 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a0:	eb fe                	jmp    c01000a0 <kern_init+0x6a>

c01000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a2:	55                   	push   %ebp
c01000a3:	89 e5                	mov    %esp,%ebp
c01000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000af:	00 
c01000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b7:	00 
c01000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bf:	e8 4b 0b 00 00       	call   c0100c0f <mon_backtrace>
}
c01000c4:	90                   	nop
c01000c5:	89 ec                	mov    %ebp,%esp
c01000c7:	5d                   	pop    %ebp
c01000c8:	c3                   	ret    

c01000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c9:	55                   	push   %ebp
c01000ca:	89 e5                	mov    %esp,%ebp
c01000cc:	83 ec 18             	sub    $0x18,%esp
c01000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b0 ff ff ff       	call   c01000a2 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c01000f6:	89 ec                	mov    %ebp,%esp
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 b7 ff ff ff       	call   c01000c9 <grade_backtrace1>
}
c0100112:	90                   	nop
c0100113:	89 ec                	mov    %ebp,%esp
c0100115:	5d                   	pop    %ebp
c0100116:	c3                   	ret    

c0100117 <grade_backtrace>:

void
grade_backtrace(void) {
c0100117:	55                   	push   %ebp
c0100118:	89 e5                	mov    %esp,%ebp
c010011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011d:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c0100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100129:	ff 
c010012a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100135:	e8 c0 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c010013a:	90                   	nop
c010013b:	89 ec                	mov    %ebp,%esp
c010013d:	5d                   	pop    %ebp
c010013e:	c3                   	ret    

c010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013f:	55                   	push   %ebp
c0100140:	89 e5                	mov    %esp,%ebp
c0100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100155:	83 e0 03             	and    $0x3,%eax
c0100158:	89 c2                	mov    %eax,%edx
c010015a:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010015f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100167:	c7 04 24 41 5c 10 c0 	movl   $0xc0105c41,(%esp)
c010016e:	e8 e3 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100177:	89 c2                	mov    %eax,%edx
c0100179:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010017e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100182:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100186:	c7 04 24 4f 5c 10 c0 	movl   $0xc0105c4f,(%esp)
c010018d:	e8 c4 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100196:	89 c2                	mov    %eax,%edx
c0100198:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c010019d:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a5:	c7 04 24 5d 5c 10 c0 	movl   $0xc0105c5d,(%esp)
c01001ac:	e8 a5 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b5:	89 c2                	mov    %eax,%edx
c01001b7:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 6b 5c 10 c0 	movl   $0xc0105c6b,(%esp)
c01001cb:	e8 86 01 00 00       	call   c0100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	89 c2                	mov    %eax,%edx
c01001d6:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001db:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e3:	c7 04 24 79 5c 10 c0 	movl   $0xc0105c79,(%esp)
c01001ea:	e8 67 01 00 00       	call   c0100356 <cprintf>
    round ++;
c01001ef:	a1 00 b0 11 c0       	mov    0xc011b000,%eax
c01001f4:	40                   	inc    %eax
c01001f5:	a3 00 b0 11 c0       	mov    %eax,0xc011b000
}
c01001fa:	90                   	nop
c01001fb:	89 ec                	mov    %ebp,%esp
c01001fd:	5d                   	pop    %ebp
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	90                   	nop
c0100203:	5d                   	pop    %ebp
c0100204:	c3                   	ret    

c0100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100205:	55                   	push   %ebp
c0100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100208:	90                   	nop
c0100209:	5d                   	pop    %ebp
c010020a:	c3                   	ret    

c010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
c010020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100211:	e8 29 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100216:	c7 04 24 88 5c 10 c0 	movl   $0xc0105c88,(%esp)
c010021d:	e8 34 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_user();
c0100222:	e8 d8 ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100227:	e8 13 ff ff ff       	call   c010013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022c:	c7 04 24 a8 5c 10 c0 	movl   $0xc0105ca8,(%esp)
c0100233:	e8 1e 01 00 00       	call   c0100356 <cprintf>
    lab1_switch_to_kernel();
c0100238:	e8 c8 ff ff ff       	call   c0100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023d:	e8 fd fe ff ff       	call   c010013f <lab1_print_cur_status>
}
c0100242:	90                   	nop
c0100243:	89 ec                	mov    %ebp,%esp
c0100245:	5d                   	pop    %ebp
c0100246:	c3                   	ret    

c0100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100247:	55                   	push   %ebp
c0100248:	89 e5                	mov    %esp,%ebp
c010024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100251:	74 13                	je     c0100266 <readline+0x1f>
        cprintf("%s", prompt);
c0100253:	8b 45 08             	mov    0x8(%ebp),%eax
c0100256:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025a:	c7 04 24 c7 5c 10 c0 	movl   $0xc0105cc7,(%esp)
c0100261:	e8 f0 00 00 00       	call   c0100356 <cprintf>
    }
    int i = 0, c;
c0100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010026d:	e8 73 01 00 00       	call   c01003e5 <getchar>
c0100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100279:	79 07                	jns    c0100282 <readline+0x3b>
            return NULL;
c010027b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100280:	eb 78                	jmp    c01002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100286:	7e 28                	jle    c01002b0 <readline+0x69>
c0100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028f:	7f 1f                	jg     c01002b0 <readline+0x69>
            cputchar(c);
c0100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100294:	89 04 24             	mov    %eax,(%esp)
c0100297:	e8 e2 00 00 00       	call   c010037e <cputchar>
            buf[i ++] = c;
c010029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029f:	8d 50 01             	lea    0x1(%eax),%edx
c01002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a8:	88 90 20 b0 11 c0    	mov    %dl,-0x3fee4fe0(%eax)
c01002ae:	eb 45                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c01002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b4:	75 16                	jne    c01002cc <readline+0x85>
c01002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ba:	7e 10                	jle    c01002cc <readline+0x85>
            cputchar(c);
c01002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002bf:	89 04 24             	mov    %eax,(%esp)
c01002c2:	e8 b7 00 00 00       	call   c010037e <cputchar>
            i --;
c01002c7:	ff 4d f4             	decl   -0xc(%ebp)
c01002ca:	eb 29                	jmp    c01002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d0:	74 06                	je     c01002d8 <readline+0x91>
c01002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d6:	75 95                	jne    c010026d <readline+0x26>
            cputchar(c);
c01002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002db:	89 04 24             	mov    %eax,(%esp)
c01002de:	e8 9b 00 00 00       	call   c010037e <cputchar>
            buf[i] = '\0';
c01002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e6:	05 20 b0 11 c0       	add    $0xc011b020,%eax
c01002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ee:	b8 20 b0 11 c0       	mov    $0xc011b020,%eax
c01002f3:	eb 05                	jmp    c01002fa <readline+0xb3>
        c = getchar();
c01002f5:	e9 73 ff ff ff       	jmp    c010026d <readline+0x26>
        }
    }
}
c01002fa:	89 ec                	mov    %ebp,%esp
c01002fc:	5d                   	pop    %ebp
c01002fd:	c3                   	ret    

c01002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002fe:	55                   	push   %ebp
c01002ff:	89 e5                	mov    %esp,%ebp
c0100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100304:	8b 45 08             	mov    0x8(%ebp),%eax
c0100307:	89 04 24             	mov    %eax,(%esp)
c010030a:	e8 b5 12 00 00       	call   c01015c4 <cons_putc>
    (*cnt) ++;
c010030f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100312:	8b 00                	mov    (%eax),%eax
c0100314:	8d 50 01             	lea    0x1(%eax),%edx
c0100317:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031a:	89 10                	mov    %edx,(%eax)
}
c010031c:	90                   	nop
c010031d:	89 ec                	mov    %ebp,%esp
c010031f:	5d                   	pop    %ebp
c0100320:	c3                   	ret    

c0100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100321:	55                   	push   %ebp
c0100322:	89 e5                	mov    %esp,%ebp
c0100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100335:	8b 45 08             	mov    0x8(%ebp),%eax
c0100338:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100343:	c7 04 24 fe 02 10 c0 	movl   $0xc01002fe,(%esp)
c010034a:	e8 68 4f 00 00       	call   c01052b7 <vprintfmt>
    return cnt;
c010034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100352:	89 ec                	mov    %ebp,%esp
c0100354:	5d                   	pop    %ebp
c0100355:	c3                   	ret    

c0100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100356:	55                   	push   %ebp
c0100357:	89 e5                	mov    %esp,%ebp
c0100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035c:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100365:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100369:	8b 45 08             	mov    0x8(%ebp),%eax
c010036c:	89 04 24             	mov    %eax,(%esp)
c010036f:	e8 ad ff ff ff       	call   c0100321 <vcprintf>
c0100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037a:	89 ec                	mov    %ebp,%esp
c010037c:	5d                   	pop    %ebp
c010037d:	c3                   	ret    

c010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037e:	55                   	push   %ebp
c010037f:	89 e5                	mov    %esp,%ebp
c0100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100384:	8b 45 08             	mov    0x8(%ebp),%eax
c0100387:	89 04 24             	mov    %eax,(%esp)
c010038a:	e8 35 12 00 00       	call   c01015c4 <cons_putc>
}
c010038f:	90                   	nop
c0100390:	89 ec                	mov    %ebp,%esp
c0100392:	5d                   	pop    %ebp
c0100393:	c3                   	ret    

c0100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100394:	55                   	push   %ebp
c0100395:	89 e5                	mov    %esp,%ebp
c0100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003a1:	eb 13                	jmp    c01003b6 <cputs+0x22>
        cputch(c, &cnt);
c01003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003ae:	89 04 24             	mov    %eax,(%esp)
c01003b1:	e8 48 ff ff ff       	call   c01002fe <cputch>
    while ((c = *str ++) != '\0') {
c01003b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b9:	8d 50 01             	lea    0x1(%eax),%edx
c01003bc:	89 55 08             	mov    %edx,0x8(%ebp)
c01003bf:	0f b6 00             	movzbl (%eax),%eax
c01003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c9:	75 d8                	jne    c01003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
c01003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d9:	e8 20 ff ff ff       	call   c01002fe <cputch>
    return cnt;
c01003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003e1:	89 ec                	mov    %ebp,%esp
c01003e3:	5d                   	pop    %ebp
c01003e4:	c3                   	ret    

c01003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003e5:	55                   	push   %ebp
c01003e6:	89 e5                	mov    %esp,%ebp
c01003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003eb:	90                   	nop
c01003ec:	e8 12 12 00 00       	call   c0101603 <cons_getc>
c01003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f8:	74 f2                	je     c01003ec <getchar+0x7>
        /* do nothing */;
    return c;
c01003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003fd:	89 ec                	mov    %ebp,%esp
c01003ff:	5d                   	pop    %ebp
c0100400:	c3                   	ret    

c0100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100401:	55                   	push   %ebp
c0100402:	89 e5                	mov    %esp,%ebp
c0100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100407:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040a:	8b 00                	mov    (%eax),%eax
c010040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010040f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100412:	8b 00                	mov    (%eax),%eax
c0100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010041e:	e9 ca 00 00 00       	jmp    c01004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c0100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100429:	01 d0                	add    %edx,%eax
c010042b:	89 c2                	mov    %eax,%edx
c010042d:	c1 ea 1f             	shr    $0x1f,%edx
c0100430:	01 d0                	add    %edx,%eax
c0100432:	d1 f8                	sar    %eax
c0100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043d:	eb 03                	jmp    c0100442 <stab_binsearch+0x41>
            m --;
c010043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100448:	7c 1f                	jl     c0100469 <stab_binsearch+0x68>
c010044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010044d:	89 d0                	mov    %edx,%eax
c010044f:	01 c0                	add    %eax,%eax
c0100451:	01 d0                	add    %edx,%eax
c0100453:	c1 e0 02             	shl    $0x2,%eax
c0100456:	89 c2                	mov    %eax,%edx
c0100458:	8b 45 08             	mov    0x8(%ebp),%eax
c010045b:	01 d0                	add    %edx,%eax
c010045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100461:	0f b6 c0             	movzbl %al,%eax
c0100464:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100467:	75 d6                	jne    c010043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010046f:	7d 09                	jge    c010047a <stab_binsearch+0x79>
            l = true_m + 1;
c0100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100474:	40                   	inc    %eax
c0100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100478:	eb 73                	jmp    c01004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c010047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100484:	89 d0                	mov    %edx,%eax
c0100486:	01 c0                	add    %eax,%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	c1 e0 02             	shl    $0x2,%eax
c010048d:	89 c2                	mov    %eax,%edx
c010048f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100492:	01 d0                	add    %edx,%eax
c0100494:	8b 40 08             	mov    0x8(%eax),%eax
c0100497:	39 45 18             	cmp    %eax,0x18(%ebp)
c010049a:	76 11                	jbe    c01004ad <stab_binsearch+0xac>
            *region_left = m;
c010049c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a7:	40                   	inc    %eax
c01004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004ab:	eb 40                	jmp    c01004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c01004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b0:	89 d0                	mov    %edx,%eax
c01004b2:	01 c0                	add    %eax,%eax
c01004b4:	01 d0                	add    %edx,%eax
c01004b6:	c1 e0 02             	shl    $0x2,%eax
c01004b9:	89 c2                	mov    %eax,%edx
c01004bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01004be:	01 d0                	add    %edx,%eax
c01004c0:	8b 40 08             	mov    0x8(%eax),%eax
c01004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
c01004c6:	73 14                	jae    c01004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
c01004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	48                   	dec    %eax
c01004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004da:	eb 11                	jmp    c01004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e2:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f3:	0f 8e 2a ff ff ff    	jle    c0100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004fd:	75 0f                	jne    c010050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100502:	8b 00                	mov    (%eax),%eax
c0100504:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100507:	8b 45 10             	mov    0x10(%ebp),%eax
c010050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c010050c:	eb 3e                	jmp    c010054c <stab_binsearch+0x14b>
        l = *region_right;
c010050e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100511:	8b 00                	mov    (%eax),%eax
c0100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100516:	eb 03                	jmp    c010051b <stab_binsearch+0x11a>
c0100518:	ff 4d fc             	decl   -0x4(%ebp)
c010051b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051e:	8b 00                	mov    (%eax),%eax
c0100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c0100523:	7e 1f                	jle    c0100544 <stab_binsearch+0x143>
c0100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100528:	89 d0                	mov    %edx,%eax
c010052a:	01 c0                	add    %eax,%eax
c010052c:	01 d0                	add    %edx,%eax
c010052e:	c1 e0 02             	shl    $0x2,%eax
c0100531:	89 c2                	mov    %eax,%edx
c0100533:	8b 45 08             	mov    0x8(%ebp),%eax
c0100536:	01 d0                	add    %edx,%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	39 45 14             	cmp    %eax,0x14(%ebp)
c0100542:	75 d4                	jne    c0100518 <stab_binsearch+0x117>
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
}
c010054c:	90                   	nop
c010054d:	89 ec                	mov    %ebp,%esp
c010054f:	5d                   	pop    %ebp
c0100550:	c3                   	ret    

c0100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100551:	55                   	push   %ebp
c0100552:	89 e5                	mov    %esp,%ebp
c0100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100557:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055a:	c7 00 cc 5c 10 c0    	movl   $0xc0105ccc,(%eax)
    info->eip_line = 0;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 08 cc 5c 10 c0 	movl   $0xc0105ccc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100581:	8b 55 08             	mov    0x8(%ebp),%edx
c0100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100587:	8b 45 0c             	mov    0xc(%ebp),%eax
c010058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100591:	c7 45 f4 38 6f 10 c0 	movl   $0xc0106f38,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100598:	c7 45 f0 e0 20 11 c0 	movl   $0xc01120e0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059f:	c7 45 ec e1 20 11 c0 	movl   $0xc01120e1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a6:	c7 45 e8 2d 56 11 c0 	movl   $0xc011562d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b3:	76 0b                	jbe    c01005c0 <debuginfo_eip+0x6f>
c01005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b8:	48                   	dec    %eax
c01005b9:	0f b6 00             	movzbl (%eax),%eax
c01005bc:	84 c0                	test   %al,%al
c01005be:	74 0a                	je     c01005ca <debuginfo_eip+0x79>
        return -1;
c01005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c5:	e9 ab 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
c01005d7:	c1 f8 02             	sar    $0x2,%eax
c01005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e0:	48                   	dec    %eax
c01005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f2:	00 
c01005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100604:	89 04 24             	mov    %eax,(%esp)
c0100607:	e8 f5 fd ff ff       	call   c0100401 <stab_binsearch>
    if (lfile == 0)
c010060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060f:	85 c0                	test   %eax,%eax
c0100611:	75 0a                	jne    c010061d <debuginfo_eip+0xcc>
        return -1;
c0100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100618:	e9 58 02 00 00       	jmp    c0100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100629:	8b 45 08             	mov    0x8(%ebp),%eax
c010062c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100637:	00 
c0100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100649:	89 04 24             	mov    %eax,(%esp)
c010064c:	e8 b0 fd ff ff       	call   c0100401 <stab_binsearch>

    if (lfun <= rfun) {
c0100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100657:	39 c2                	cmp    %eax,%edx
c0100659:	7f 78                	jg     c01006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	89 d0                	mov    %edx,%eax
c0100662:	01 c0                	add    %eax,%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	c1 e0 02             	shl    $0x2,%eax
c0100669:	89 c2                	mov    %eax,%edx
c010066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066e:	01 d0                	add    %edx,%eax
c0100670:	8b 10                	mov    (%eax),%edx
c0100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
c0100678:	39 c2                	cmp    %eax,%edx
c010067a:	73 22                	jae    c010069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067f:	89 c2                	mov    %eax,%edx
c0100681:	89 d0                	mov    %edx,%eax
c0100683:	01 c0                	add    %eax,%eax
c0100685:	01 d0                	add    %edx,%eax
c0100687:	c1 e0 02             	shl    $0x2,%eax
c010068a:	89 c2                	mov    %eax,%edx
c010068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068f:	01 d0                	add    %edx,%eax
c0100691:	8b 10                	mov    (%eax),%edx
c0100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100696:	01 c2                	add    %eax,%edx
c0100698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a1:	89 c2                	mov    %eax,%edx
c01006a3:	89 d0                	mov    %edx,%eax
c01006a5:	01 c0                	add    %eax,%eax
c01006a7:	01 d0                	add    %edx,%eax
c01006a9:	c1 e0 02             	shl    $0x2,%eax
c01006ac:	89 c2                	mov    %eax,%edx
c01006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b1:	01 d0                	add    %edx,%eax
c01006b3:	8b 50 08             	mov    0x8(%eax),%edx
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bf:	8b 40 10             	mov    0x10(%eax),%eax
c01006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d1:	eb 15                	jmp    c01006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006eb:	8b 40 08             	mov    0x8(%eax),%eax
c01006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f5:	00 
c01006f6:	89 04 24             	mov    %eax,(%esp)
c01006f9:	e8 06 52 00 00       	call   c0105904 <strfind>
c01006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100701:	8b 4a 08             	mov    0x8(%edx),%ecx
c0100704:	29 c8                	sub    %ecx,%eax
c0100706:	89 c2                	mov    %eax,%edx
c0100708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100711:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071c:	00 
c010071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100720:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100727:	89 44 24 04          	mov    %eax,0x4(%esp)
c010072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072e:	89 04 24             	mov    %eax,(%esp)
c0100731:	e8 cb fc ff ff       	call   c0100401 <stab_binsearch>
    if (lline <= rline) {
c0100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073c:	39 c2                	cmp    %eax,%edx
c010073e:	7f 23                	jg     c0100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
c0100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100743:	89 c2                	mov    %eax,%edx
c0100745:	89 d0                	mov    %edx,%eax
c0100747:	01 c0                	add    %eax,%eax
c0100749:	01 d0                	add    %edx,%eax
c010074b:	c1 e0 02             	shl    $0x2,%eax
c010074e:	89 c2                	mov    %eax,%edx
c0100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100753:	01 d0                	add    %edx,%eax
c0100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100759:	89 c2                	mov    %eax,%edx
c010075b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100761:	eb 11                	jmp    c0100774 <debuginfo_eip+0x223>
        return -1;
c0100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100768:	e9 08 01 00 00       	jmp    c0100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100770:	48                   	dec    %eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b5                	jne    c010076d <debuginfo_eip+0x21c>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 99                	je     c010076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 42                	jl     c0100820 <debuginfo_eip+0x2cf>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
c01007fb:	39 c2                	cmp    %eax,%edx
c01007fd:	73 21                	jae    c0100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	89 d0                	mov    %edx,%eax
c0100806:	01 c0                	add    %eax,%eax
c0100808:	01 d0                	add    %edx,%eax
c010080a:	c1 e0 02             	shl    $0x2,%eax
c010080d:	89 c2                	mov    %eax,%edx
c010080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100812:	01 d0                	add    %edx,%eax
c0100814:	8b 10                	mov    (%eax),%edx
c0100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100819:	01 c2                	add    %eax,%edx
c010081b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100826:	39 c2                	cmp    %eax,%edx
c0100828:	7d 46                	jge    c0100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
c010082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082d:	40                   	inc    %eax
c010082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100831:	eb 16                	jmp    c0100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	8b 40 14             	mov    0x14(%eax),%eax
c0100839:	8d 50 01             	lea    0x1(%eax),%edx
c010083c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100845:	40                   	inc    %eax
c0100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010084f:	39 c2                	cmp    %eax,%edx
c0100851:	7d 1d                	jge    c0100870 <debuginfo_eip+0x31f>
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c a0                	cmp    $0xa0,%al
c010086e:	74 c3                	je     c0100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
c0100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100875:	89 ec                	mov    %ebp,%esp
c0100877:	5d                   	pop    %ebp
c0100878:	c3                   	ret    

c0100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100879:	55                   	push   %ebp
c010087a:	89 e5                	mov    %esp,%ebp
c010087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010087f:	c7 04 24 d6 5c 10 c0 	movl   $0xc0105cd6,(%esp)
c0100886:	e8 cb fa ff ff       	call   c0100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088b:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100892:	c0 
c0100893:	c7 04 24 ef 5c 10 c0 	movl   $0xc0105cef,(%esp)
c010089a:	e8 b7 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010089f:	c7 44 24 04 18 5c 10 	movl   $0xc0105c18,0x4(%esp)
c01008a6:	c0 
c01008a7:	c7 04 24 07 5d 10 c0 	movl   $0xc0105d07,(%esp)
c01008ae:	e8 a3 fa ff ff       	call   c0100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b3:	c7 44 24 04 00 b0 11 	movl   $0xc011b000,0x4(%esp)
c01008ba:	c0 
c01008bb:	c7 04 24 1f 5d 10 c0 	movl   $0xc0105d1f,(%esp)
c01008c2:	e8 8f fa ff ff       	call   c0100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008c7:	c7 44 24 04 2c bf 11 	movl   $0xc011bf2c,0x4(%esp)
c01008ce:	c0 
c01008cf:	c7 04 24 37 5d 10 c0 	movl   $0xc0105d37,(%esp)
c01008d6:	e8 7b fa ff ff       	call   c0100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008db:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c01008e0:	2d 36 00 10 c0       	sub    $0xc0100036,%eax
c01008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
c01008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f0:	85 c0                	test   %eax,%eax
c01008f2:	0f 48 c2             	cmovs  %edx,%eax
c01008f5:	c1 f8 0a             	sar    $0xa,%eax
c01008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fc:	c7 04 24 50 5d 10 c0 	movl   $0xc0105d50,(%esp)
c0100903:	e8 4e fa ff ff       	call   c0100356 <cprintf>
}
c0100908:	90                   	nop
c0100909:	89 ec                	mov    %ebp,%esp
c010090b:	5d                   	pop    %ebp
c010090c:	c3                   	ret    

c010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010090d:	55                   	push   %ebp
c010090e:	89 e5                	mov    %esp,%ebp
c0100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010091d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100920:	89 04 24             	mov    %eax,(%esp)
c0100923:	e8 29 fc ff ff       	call   c0100551 <debuginfo_eip>
c0100928:	85 c0                	test   %eax,%eax
c010092a:	74 15                	je     c0100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010092c:	8b 45 08             	mov    0x8(%ebp),%eax
c010092f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100933:	c7 04 24 7a 5d 10 c0 	movl   $0xc0105d7a,(%esp)
c010093a:	e8 17 fa ff ff       	call   c0100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c010093f:	eb 6c                	jmp    c01009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100948:	eb 1b                	jmp    c0100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c010094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100950:	01 d0                	add    %edx,%eax
c0100952:	0f b6 10             	movzbl (%eax),%edx
c0100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010095e:	01 c8                	add    %ecx,%eax
c0100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100962:	ff 45 f4             	incl   -0xc(%ebp)
c0100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010096b:	7c dd                	jl     c010094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
c010096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100976:	01 d0                	add    %edx,%eax
c0100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c010097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010097e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100981:	29 d0                	sub    %edx,%eax
c0100983:	89 c1                	mov    %eax,%ecx
c0100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100999:	89 54 24 08          	mov    %edx,0x8(%esp)
c010099d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a1:	c7 04 24 96 5d 10 c0 	movl   $0xc0105d96,(%esp)
c01009a8:	e8 a9 f9 ff ff       	call   c0100356 <cprintf>
}
c01009ad:	90                   	nop
c01009ae:	89 ec                	mov    %ebp,%esp
c01009b0:	5d                   	pop    %ebp
c01009b1:	c3                   	ret    

c01009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b2:	55                   	push   %ebp
c01009b3:	89 e5                	mov    %esp,%ebp
c01009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009b8:	8b 45 04             	mov    0x4(%ebp),%eax
c01009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c1:	89 ec                	mov    %ebp,%esp
c01009c3:	5d                   	pop    %ebp
c01009c4:	c3                   	ret    

c01009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c5:	55                   	push   %ebp
c01009c6:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c01009c8:	90                   	nop
c01009c9:	5d                   	pop    %ebp
c01009ca:	c3                   	ret    

c01009cb <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c01009cb:	55                   	push   %ebp
c01009cc:	89 e5                	mov    %esp,%ebp
c01009ce:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c01009d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009d8:	eb 0c                	jmp    c01009e6 <parse+0x1b>
            *buf ++ = '\0';
c01009da:	8b 45 08             	mov    0x8(%ebp),%eax
c01009dd:	8d 50 01             	lea    0x1(%eax),%edx
c01009e0:	89 55 08             	mov    %edx,0x8(%ebp)
c01009e3:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e9:	0f b6 00             	movzbl (%eax),%eax
c01009ec:	84 c0                	test   %al,%al
c01009ee:	74 1d                	je     c0100a0d <parse+0x42>
c01009f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f3:	0f b6 00             	movzbl (%eax),%eax
c01009f6:	0f be c0             	movsbl %al,%eax
c01009f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fd:	c7 04 24 28 5e 10 c0 	movl   $0xc0105e28,(%esp)
c0100a04:	e8 c7 4e 00 00       	call   c01058d0 <strchr>
c0100a09:	85 c0                	test   %eax,%eax
c0100a0b:	75 cd                	jne    c01009da <parse+0xf>
        }
        if (*buf == '\0') {
c0100a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a10:	0f b6 00             	movzbl (%eax),%eax
c0100a13:	84 c0                	test   %al,%al
c0100a15:	74 65                	je     c0100a7c <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a17:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a1b:	75 14                	jne    c0100a31 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a1d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100a24:	00 
c0100a25:	c7 04 24 2d 5e 10 c0 	movl   $0xc0105e2d,(%esp)
c0100a2c:	e8 25 f9 ff ff       	call   c0100356 <cprintf>
        }
        argv[argc ++] = buf;
c0100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a34:	8d 50 01             	lea    0x1(%eax),%edx
c0100a37:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100a3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a41:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a44:	01 c2                	add    %eax,%edx
c0100a46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a49:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a4b:	eb 03                	jmp    c0100a50 <parse+0x85>
            buf ++;
c0100a4d:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a53:	0f b6 00             	movzbl (%eax),%eax
c0100a56:	84 c0                	test   %al,%al
c0100a58:	74 8c                	je     c01009e6 <parse+0x1b>
c0100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a5d:	0f b6 00             	movzbl (%eax),%eax
c0100a60:	0f be c0             	movsbl %al,%eax
c0100a63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a67:	c7 04 24 28 5e 10 c0 	movl   $0xc0105e28,(%esp)
c0100a6e:	e8 5d 4e 00 00       	call   c01058d0 <strchr>
c0100a73:	85 c0                	test   %eax,%eax
c0100a75:	74 d6                	je     c0100a4d <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a77:	e9 6a ff ff ff       	jmp    c01009e6 <parse+0x1b>
            break;
c0100a7c:	90                   	nop
        }
    }
    return argc;
c0100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100a80:	89 ec                	mov    %ebp,%esp
c0100a82:	5d                   	pop    %ebp
c0100a83:	c3                   	ret    

c0100a84 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100a84:	55                   	push   %ebp
c0100a85:	89 e5                	mov    %esp,%ebp
c0100a87:	83 ec 68             	sub    $0x68,%esp
c0100a8a:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100a8d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100a90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	89 04 24             	mov    %eax,(%esp)
c0100a9a:	e8 2c ff ff ff       	call   c01009cb <parse>
c0100a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100aa6:	75 0a                	jne    c0100ab2 <runcmd+0x2e>
        return 0;
c0100aa8:	b8 00 00 00 00       	mov    $0x0,%eax
c0100aad:	e9 83 00 00 00       	jmp    c0100b35 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100ab9:	eb 5a                	jmp    c0100b15 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100abb:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0100abe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100ac1:	89 c8                	mov    %ecx,%eax
c0100ac3:	01 c0                	add    %eax,%eax
c0100ac5:	01 c8                	add    %ecx,%eax
c0100ac7:	c1 e0 02             	shl    $0x2,%eax
c0100aca:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100acf:	8b 00                	mov    (%eax),%eax
c0100ad1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100ad5:	89 04 24             	mov    %eax,(%esp)
c0100ad8:	e8 57 4d 00 00       	call   c0105834 <strcmp>
c0100add:	85 c0                	test   %eax,%eax
c0100adf:	75 31                	jne    c0100b12 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ae4:	89 d0                	mov    %edx,%eax
c0100ae6:	01 c0                	add    %eax,%eax
c0100ae8:	01 d0                	add    %edx,%eax
c0100aea:	c1 e0 02             	shl    $0x2,%eax
c0100aed:	05 08 80 11 c0       	add    $0xc0118008,%eax
c0100af2:	8b 10                	mov    (%eax),%edx
c0100af4:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100af7:	83 c0 04             	add    $0x4,%eax
c0100afa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100afd:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100b07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0b:	89 1c 24             	mov    %ebx,(%esp)
c0100b0e:	ff d2                	call   *%edx
c0100b10:	eb 23                	jmp    c0100b35 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b12:	ff 45 f4             	incl   -0xc(%ebp)
c0100b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b18:	83 f8 02             	cmp    $0x2,%eax
c0100b1b:	76 9e                	jbe    c0100abb <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b24:	c7 04 24 4b 5e 10 c0 	movl   $0xc0105e4b,(%esp)
c0100b2b:	e8 26 f8 ff ff       	call   c0100356 <cprintf>
    return 0;
c0100b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0100b38:	89 ec                	mov    %ebp,%esp
c0100b3a:	5d                   	pop    %ebp
c0100b3b:	c3                   	ret    

c0100b3c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100b3c:	55                   	push   %ebp
c0100b3d:	89 e5                	mov    %esp,%ebp
c0100b3f:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100b42:	c7 04 24 64 5e 10 c0 	movl   $0xc0105e64,(%esp)
c0100b49:	e8 08 f8 ff ff       	call   c0100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100b4e:	c7 04 24 8c 5e 10 c0 	movl   $0xc0105e8c,(%esp)
c0100b55:	e8 fc f7 ff ff       	call   c0100356 <cprintf>

    if (tf != NULL) {
c0100b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100b5e:	74 0b                	je     c0100b6b <kmonitor+0x2f>
        print_trapframe(tf);
c0100b60:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b63:	89 04 24             	mov    %eax,(%esp)
c0100b66:	e8 60 0d 00 00       	call   c01018cb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100b6b:	c7 04 24 b1 5e 10 c0 	movl   $0xc0105eb1,(%esp)
c0100b72:	e8 d0 f6 ff ff       	call   c0100247 <readline>
c0100b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b7e:	74 eb                	je     c0100b6b <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b8a:	89 04 24             	mov    %eax,(%esp)
c0100b8d:	e8 f2 fe ff ff       	call   c0100a84 <runcmd>
c0100b92:	85 c0                	test   %eax,%eax
c0100b94:	78 02                	js     c0100b98 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100b96:	eb d3                	jmp    c0100b6b <kmonitor+0x2f>
                break;
c0100b98:	90                   	nop
            }
        }
    }
}
c0100b99:	90                   	nop
c0100b9a:	89 ec                	mov    %ebp,%esp
c0100b9c:	5d                   	pop    %ebp
c0100b9d:	c3                   	ret    

c0100b9e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100b9e:	55                   	push   %ebp
c0100b9f:	89 e5                	mov    %esp,%ebp
c0100ba1:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ba4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100bab:	eb 3d                	jmp    c0100bea <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bb0:	89 d0                	mov    %edx,%eax
c0100bb2:	01 c0                	add    %eax,%eax
c0100bb4:	01 d0                	add    %edx,%eax
c0100bb6:	c1 e0 02             	shl    $0x2,%eax
c0100bb9:	05 04 80 11 c0       	add    $0xc0118004,%eax
c0100bbe:	8b 10                	mov    (%eax),%edx
c0100bc0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
c0100bc3:	89 c8                	mov    %ecx,%eax
c0100bc5:	01 c0                	add    %eax,%eax
c0100bc7:	01 c8                	add    %ecx,%eax
c0100bc9:	c1 e0 02             	shl    $0x2,%eax
c0100bcc:	05 00 80 11 c0       	add    $0xc0118000,%eax
c0100bd1:	8b 00                	mov    (%eax),%eax
c0100bd3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bdb:	c7 04 24 b5 5e 10 c0 	movl   $0xc0105eb5,(%esp)
c0100be2:	e8 6f f7 ff ff       	call   c0100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100be7:	ff 45 f4             	incl   -0xc(%ebp)
c0100bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bed:	83 f8 02             	cmp    $0x2,%eax
c0100bf0:	76 bb                	jbe    c0100bad <mon_help+0xf>
    }
    return 0;
c0100bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf7:	89 ec                	mov    %ebp,%esp
c0100bf9:	5d                   	pop    %ebp
c0100bfa:	c3                   	ret    

c0100bfb <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100bfb:	55                   	push   %ebp
c0100bfc:	89 e5                	mov    %esp,%ebp
c0100bfe:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c01:	e8 73 fc ff ff       	call   c0100879 <print_kerninfo>
    return 0;
c0100c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c0b:	89 ec                	mov    %ebp,%esp
c0100c0d:	5d                   	pop    %ebp
c0100c0e:	c3                   	ret    

c0100c0f <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c0f:	55                   	push   %ebp
c0100c10:	89 e5                	mov    %esp,%ebp
c0100c12:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c15:	e8 ab fd ff ff       	call   c01009c5 <print_stackframe>
    return 0;
c0100c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c1f:	89 ec                	mov    %ebp,%esp
c0100c21:	5d                   	pop    %ebp
c0100c22:	c3                   	ret    

c0100c23 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c23:	55                   	push   %ebp
c0100c24:	89 e5                	mov    %esp,%ebp
c0100c26:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100c29:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
c0100c2e:	85 c0                	test   %eax,%eax
c0100c30:	75 5b                	jne    c0100c8d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c0100c32:	c7 05 20 b4 11 c0 01 	movl   $0x1,0xc011b420
c0100c39:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100c3c:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c45:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c49:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c50:	c7 04 24 be 5e 10 c0 	movl   $0xc0105ebe,(%esp)
c0100c57:	e8 fa f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c63:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c66:	89 04 24             	mov    %eax,(%esp)
c0100c69:	e8 b3 f6 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100c6e:	c7 04 24 da 5e 10 c0 	movl   $0xc0105eda,(%esp)
c0100c75:	e8 dc f6 ff ff       	call   c0100356 <cprintf>
    
    cprintf("stack trackback:\n");
c0100c7a:	c7 04 24 dc 5e 10 c0 	movl   $0xc0105edc,(%esp)
c0100c81:	e8 d0 f6 ff ff       	call   c0100356 <cprintf>
    print_stackframe();
c0100c86:	e8 3a fd ff ff       	call   c01009c5 <print_stackframe>
c0100c8b:	eb 01                	jmp    c0100c8e <__panic+0x6b>
        goto panic_dead;
c0100c8d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100c8e:	e8 e9 09 00 00       	call   c010167c <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100c93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100c9a:	e8 9d fe ff ff       	call   c0100b3c <kmonitor>
c0100c9f:	eb f2                	jmp    c0100c93 <__panic+0x70>

c0100ca1 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100ca1:	55                   	push   %ebp
c0100ca2:	89 e5                	mov    %esp,%ebp
c0100ca4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100ca7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cbb:	c7 04 24 ee 5e 10 c0 	movl   $0xc0105eee,(%esp)
c0100cc2:	e8 8f f6 ff ff       	call   c0100356 <cprintf>
    vcprintf(fmt, ap);
c0100cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cce:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cd1:	89 04 24             	mov    %eax,(%esp)
c0100cd4:	e8 48 f6 ff ff       	call   c0100321 <vcprintf>
    cprintf("\n");
c0100cd9:	c7 04 24 da 5e 10 c0 	movl   $0xc0105eda,(%esp)
c0100ce0:	e8 71 f6 ff ff       	call   c0100356 <cprintf>
    va_end(ap);
}
c0100ce5:	90                   	nop
c0100ce6:	89 ec                	mov    %ebp,%esp
c0100ce8:	5d                   	pop    %ebp
c0100ce9:	c3                   	ret    

c0100cea <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100cea:	55                   	push   %ebp
c0100ceb:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100ced:	a1 20 b4 11 c0       	mov    0xc011b420,%eax
}
c0100cf2:	5d                   	pop    %ebp
c0100cf3:	c3                   	ret    

c0100cf4 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100cf4:	55                   	push   %ebp
c0100cf5:	89 e5                	mov    %esp,%ebp
c0100cf7:	83 ec 28             	sub    $0x28,%esp
c0100cfa:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d00:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d04:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d08:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d0c:	ee                   	out    %al,(%dx)
}
c0100d0d:	90                   	nop
c0100d0e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d14:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d18:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d1c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d20:	ee                   	out    %al,(%dx)
}
c0100d21:	90                   	nop
c0100d22:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100d28:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d2c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d30:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d34:	ee                   	out    %al,(%dx)
}
c0100d35:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d36:	c7 05 24 b4 11 c0 00 	movl   $0x0,0xc011b424
c0100d3d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d40:	c7 04 24 0c 5f 10 c0 	movl   $0xc0105f0c,(%esp)
c0100d47:	e8 0a f6 ff ff       	call   c0100356 <cprintf>
    pic_enable(IRQ_TIMER);
c0100d4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d53:	e8 89 09 00 00       	call   c01016e1 <pic_enable>
}
c0100d58:	90                   	nop
c0100d59:	89 ec                	mov    %ebp,%esp
c0100d5b:	5d                   	pop    %ebp
c0100d5c:	c3                   	ret    

c0100d5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d5d:	55                   	push   %ebp
c0100d5e:	89 e5                	mov    %esp,%ebp
c0100d60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d63:	9c                   	pushf  
c0100d64:	58                   	pop    %eax
c0100d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d6b:	25 00 02 00 00       	and    $0x200,%eax
c0100d70:	85 c0                	test   %eax,%eax
c0100d72:	74 0c                	je     c0100d80 <__intr_save+0x23>
        intr_disable();
c0100d74:	e8 03 09 00 00       	call   c010167c <intr_disable>
        return 1;
c0100d79:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d7e:	eb 05                	jmp    c0100d85 <__intr_save+0x28>
    }
    return 0;
c0100d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d85:	89 ec                	mov    %ebp,%esp
c0100d87:	5d                   	pop    %ebp
c0100d88:	c3                   	ret    

c0100d89 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d89:	55                   	push   %ebp
c0100d8a:	89 e5                	mov    %esp,%ebp
c0100d8c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d93:	74 05                	je     c0100d9a <__intr_restore+0x11>
        intr_enable();
c0100d95:	e8 da 08 00 00       	call   c0101674 <intr_enable>
    }
}
c0100d9a:	90                   	nop
c0100d9b:	89 ec                	mov    %ebp,%esp
c0100d9d:	5d                   	pop    %ebp
c0100d9e:	c3                   	ret    

c0100d9f <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d9f:	55                   	push   %ebp
c0100da0:	89 e5                	mov    %esp,%ebp
c0100da2:	83 ec 10             	sub    $0x10,%esp
c0100da5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100dab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100daf:	89 c2                	mov    %eax,%edx
c0100db1:	ec                   	in     (%dx),%al
c0100db2:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100db5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100dbb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100dbf:	89 c2                	mov    %eax,%edx
c0100dc1:	ec                   	in     (%dx),%al
c0100dc2:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100dc5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100dcb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100dcf:	89 c2                	mov    %eax,%edx
c0100dd1:	ec                   	in     (%dx),%al
c0100dd2:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100dd5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100ddb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100ddf:	89 c2                	mov    %eax,%edx
c0100de1:	ec                   	in     (%dx),%al
c0100de2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100de5:	90                   	nop
c0100de6:	89 ec                	mov    %ebp,%esp
c0100de8:	5d                   	pop    %ebp
c0100de9:	c3                   	ret    

c0100dea <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100dea:	55                   	push   %ebp
c0100deb:	89 e5                	mov    %esp,%ebp
c0100ded:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100df0:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dfa:	0f b7 00             	movzwl (%eax),%eax
c0100dfd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e04:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e0c:	0f b7 00             	movzwl (%eax),%eax
c0100e0f:	0f b7 c0             	movzwl %ax,%eax
c0100e12:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100e17:	74 12                	je     c0100e2b <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e19:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e20:	66 c7 05 46 b4 11 c0 	movw   $0x3b4,0xc011b446
c0100e27:	b4 03 
c0100e29:	eb 13                	jmp    c0100e3e <cga_init+0x54>
    } else {
        *cp = was;
c0100e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e2e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e32:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e35:	66 c7 05 46 b4 11 c0 	movw   $0x3d4,0xc011b446
c0100e3c:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e3e:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100e45:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100e49:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e4d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100e51:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100e55:	ee                   	out    %al,(%dx)
}
c0100e56:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
c0100e57:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100e5e:	40                   	inc    %eax
c0100e5f:	0f b7 c0             	movzwl %ax,%eax
c0100e62:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e66:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100e6a:	89 c2                	mov    %eax,%edx
c0100e6c:	ec                   	in     (%dx),%al
c0100e6d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100e70:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100e74:	0f b6 c0             	movzbl %al,%eax
c0100e77:	c1 e0 08             	shl    $0x8,%eax
c0100e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e7d:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100e84:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100e88:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e94:	ee                   	out    %al,(%dx)
}
c0100e95:	90                   	nop
    pos |= inb(addr_6845 + 1);
c0100e96:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0100e9d:	40                   	inc    %eax
c0100e9e:	0f b7 c0             	movzwl %ax,%eax
c0100ea1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ea5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ea9:	89 c2                	mov    %eax,%edx
c0100eab:	ec                   	in     (%dx),%al
c0100eac:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100eaf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb3:	0f b6 c0             	movzbl %al,%eax
c0100eb6:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ebc:	a3 40 b4 11 c0       	mov    %eax,0xc011b440
    crt_pos = pos;
c0100ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ec4:	0f b7 c0             	movzwl %ax,%eax
c0100ec7:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
}
c0100ecd:	90                   	nop
c0100ece:	89 ec                	mov    %ebp,%esp
c0100ed0:	5d                   	pop    %ebp
c0100ed1:	c3                   	ret    

c0100ed2 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100ed2:	55                   	push   %ebp
c0100ed3:	89 e5                	mov    %esp,%ebp
c0100ed5:	83 ec 48             	sub    $0x48,%esp
c0100ed8:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100ede:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100ee6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100eea:	ee                   	out    %al,(%dx)
}
c0100eeb:	90                   	nop
c0100eec:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100ef2:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100efa:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100efe:	ee                   	out    %al,(%dx)
}
c0100eff:	90                   	nop
c0100f00:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f06:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f0e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f12:	ee                   	out    %al,(%dx)
}
c0100f13:	90                   	nop
c0100f14:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f1a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f22:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f26:	ee                   	out    %al,(%dx)
}
c0100f27:	90                   	nop
c0100f28:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100f2e:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f32:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f36:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f3a:	ee                   	out    %al,(%dx)
}
c0100f3b:	90                   	nop
c0100f3c:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100f42:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f46:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f4e:	ee                   	out    %al,(%dx)
}
c0100f4f:	90                   	nop
c0100f50:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f56:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f5a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f5e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f62:	ee                   	out    %al,(%dx)
}
c0100f63:	90                   	nop
c0100f64:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f6a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f6e:	89 c2                	mov    %eax,%edx
c0100f70:	ec                   	in     (%dx),%al
c0100f71:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f74:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f78:	3c ff                	cmp    $0xff,%al
c0100f7a:	0f 95 c0             	setne  %al
c0100f7d:	0f b6 c0             	movzbl %al,%eax
c0100f80:	a3 48 b4 11 c0       	mov    %eax,0xc011b448
c0100f85:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f8b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f8f:	89 c2                	mov    %eax,%edx
c0100f91:	ec                   	in     (%dx),%al
c0100f92:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100f95:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0100f9b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100f9f:	89 c2                	mov    %eax,%edx
c0100fa1:	ec                   	in     (%dx),%al
c0100fa2:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100fa5:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c0100faa:	85 c0                	test   %eax,%eax
c0100fac:	74 0c                	je     c0100fba <serial_init+0xe8>
        pic_enable(IRQ_COM1);
c0100fae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100fb5:	e8 27 07 00 00       	call   c01016e1 <pic_enable>
    }
}
c0100fba:	90                   	nop
c0100fbb:	89 ec                	mov    %ebp,%esp
c0100fbd:	5d                   	pop    %ebp
c0100fbe:	c3                   	ret    

c0100fbf <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100fbf:	55                   	push   %ebp
c0100fc0:	89 e5                	mov    %esp,%ebp
c0100fc2:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100fcc:	eb 08                	jmp    c0100fd6 <lpt_putc_sub+0x17>
        delay();
c0100fce:	e8 cc fd ff ff       	call   c0100d9f <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100fd3:	ff 45 fc             	incl   -0x4(%ebp)
c0100fd6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100fdc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100fe0:	89 c2                	mov    %eax,%edx
c0100fe2:	ec                   	in     (%dx),%al
c0100fe3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100fe6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100fea:	84 c0                	test   %al,%al
c0100fec:	78 09                	js     c0100ff7 <lpt_putc_sub+0x38>
c0100fee:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100ff5:	7e d7                	jle    c0100fce <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ffa:	0f b6 c0             	movzbl %al,%eax
c0100ffd:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101003:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101006:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010100a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010100e:	ee                   	out    %al,(%dx)
}
c010100f:	90                   	nop
c0101010:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101016:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010101a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010101e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101022:	ee                   	out    %al,(%dx)
}
c0101023:	90                   	nop
c0101024:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010102a:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010102e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101032:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101036:	ee                   	out    %al,(%dx)
}
c0101037:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101038:	90                   	nop
c0101039:	89 ec                	mov    %ebp,%esp
c010103b:	5d                   	pop    %ebp
c010103c:	c3                   	ret    

c010103d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010103d:	55                   	push   %ebp
c010103e:	89 e5                	mov    %esp,%ebp
c0101040:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101043:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101047:	74 0d                	je     c0101056 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101049:	8b 45 08             	mov    0x8(%ebp),%eax
c010104c:	89 04 24             	mov    %eax,(%esp)
c010104f:	e8 6b ff ff ff       	call   c0100fbf <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c0101054:	eb 24                	jmp    c010107a <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c0101056:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010105d:	e8 5d ff ff ff       	call   c0100fbf <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101062:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101069:	e8 51 ff ff ff       	call   c0100fbf <lpt_putc_sub>
        lpt_putc_sub('\b');
c010106e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101075:	e8 45 ff ff ff       	call   c0100fbf <lpt_putc_sub>
}
c010107a:	90                   	nop
c010107b:	89 ec                	mov    %ebp,%esp
c010107d:	5d                   	pop    %ebp
c010107e:	c3                   	ret    

c010107f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010107f:	55                   	push   %ebp
c0101080:	89 e5                	mov    %esp,%ebp
c0101082:	83 ec 38             	sub    $0x38,%esp
c0101085:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
c0101088:	8b 45 08             	mov    0x8(%ebp),%eax
c010108b:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101090:	85 c0                	test   %eax,%eax
c0101092:	75 07                	jne    c010109b <cga_putc+0x1c>
        c |= 0x0700;
c0101094:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010109b:	8b 45 08             	mov    0x8(%ebp),%eax
c010109e:	0f b6 c0             	movzbl %al,%eax
c01010a1:	83 f8 0d             	cmp    $0xd,%eax
c01010a4:	74 72                	je     c0101118 <cga_putc+0x99>
c01010a6:	83 f8 0d             	cmp    $0xd,%eax
c01010a9:	0f 8f a3 00 00 00    	jg     c0101152 <cga_putc+0xd3>
c01010af:	83 f8 08             	cmp    $0x8,%eax
c01010b2:	74 0a                	je     c01010be <cga_putc+0x3f>
c01010b4:	83 f8 0a             	cmp    $0xa,%eax
c01010b7:	74 4c                	je     c0101105 <cga_putc+0x86>
c01010b9:	e9 94 00 00 00       	jmp    c0101152 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
c01010be:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01010c5:	85 c0                	test   %eax,%eax
c01010c7:	0f 84 af 00 00 00    	je     c010117c <cga_putc+0xfd>
            crt_pos --;
c01010cd:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01010d4:	48                   	dec    %eax
c01010d5:	0f b7 c0             	movzwl %ax,%eax
c01010d8:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01010de:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e1:	98                   	cwtl   
c01010e2:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01010e7:	98                   	cwtl   
c01010e8:	83 c8 20             	or     $0x20,%eax
c01010eb:	98                   	cwtl   
c01010ec:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c01010f2:	0f b7 15 44 b4 11 c0 	movzwl 0xc011b444,%edx
c01010f9:	01 d2                	add    %edx,%edx
c01010fb:	01 ca                	add    %ecx,%edx
c01010fd:	0f b7 c0             	movzwl %ax,%eax
c0101100:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101103:	eb 77                	jmp    c010117c <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
c0101105:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010110c:	83 c0 50             	add    $0x50,%eax
c010110f:	0f b7 c0             	movzwl %ax,%eax
c0101112:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101118:	0f b7 1d 44 b4 11 c0 	movzwl 0xc011b444,%ebx
c010111f:	0f b7 0d 44 b4 11 c0 	movzwl 0xc011b444,%ecx
c0101126:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010112b:	89 c8                	mov    %ecx,%eax
c010112d:	f7 e2                	mul    %edx
c010112f:	c1 ea 06             	shr    $0x6,%edx
c0101132:	89 d0                	mov    %edx,%eax
c0101134:	c1 e0 02             	shl    $0x2,%eax
c0101137:	01 d0                	add    %edx,%eax
c0101139:	c1 e0 04             	shl    $0x4,%eax
c010113c:	29 c1                	sub    %eax,%ecx
c010113e:	89 ca                	mov    %ecx,%edx
c0101140:	0f b7 d2             	movzwl %dx,%edx
c0101143:	89 d8                	mov    %ebx,%eax
c0101145:	29 d0                	sub    %edx,%eax
c0101147:	0f b7 c0             	movzwl %ax,%eax
c010114a:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
        break;
c0101150:	eb 2b                	jmp    c010117d <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101152:	8b 0d 40 b4 11 c0    	mov    0xc011b440,%ecx
c0101158:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010115f:	8d 50 01             	lea    0x1(%eax),%edx
c0101162:	0f b7 d2             	movzwl %dx,%edx
c0101165:	66 89 15 44 b4 11 c0 	mov    %dx,0xc011b444
c010116c:	01 c0                	add    %eax,%eax
c010116e:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101171:	8b 45 08             	mov    0x8(%ebp),%eax
c0101174:	0f b7 c0             	movzwl %ax,%eax
c0101177:	66 89 02             	mov    %ax,(%edx)
        break;
c010117a:	eb 01                	jmp    c010117d <cga_putc+0xfe>
        break;
c010117c:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010117d:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101184:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c0101189:	76 5e                	jbe    c01011e9 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010118b:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c0101190:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101196:	a1 40 b4 11 c0       	mov    0xc011b440,%eax
c010119b:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011a2:	00 
c01011a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011a7:	89 04 24             	mov    %eax,(%esp)
c01011aa:	e8 1f 49 00 00       	call   c0105ace <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011af:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011b6:	eb 15                	jmp    c01011cd <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
c01011b8:	8b 15 40 b4 11 c0    	mov    0xc011b440,%edx
c01011be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01011c1:	01 c0                	add    %eax,%eax
c01011c3:	01 d0                	add    %edx,%eax
c01011c5:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011ca:	ff 45 f4             	incl   -0xc(%ebp)
c01011cd:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c01011d4:	7e e2                	jle    c01011b8 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
c01011d6:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c01011dd:	83 e8 50             	sub    $0x50,%eax
c01011e0:	0f b7 c0             	movzwl %ax,%eax
c01011e3:	66 a3 44 b4 11 c0    	mov    %ax,0xc011b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01011e9:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c01011f0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c01011f4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01011f8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01011fc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101200:	ee                   	out    %al,(%dx)
}
c0101201:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
c0101202:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c0101209:	c1 e8 08             	shr    $0x8,%eax
c010120c:	0f b7 c0             	movzwl %ax,%eax
c010120f:	0f b6 c0             	movzbl %al,%eax
c0101212:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c0101219:	42                   	inc    %edx
c010121a:	0f b7 d2             	movzwl %dx,%edx
c010121d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101221:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101224:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101228:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010122c:	ee                   	out    %al,(%dx)
}
c010122d:	90                   	nop
    outb(addr_6845, 15);
c010122e:	0f b7 05 46 b4 11 c0 	movzwl 0xc011b446,%eax
c0101235:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101239:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010123d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101241:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101245:	ee                   	out    %al,(%dx)
}
c0101246:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
c0101247:	0f b7 05 44 b4 11 c0 	movzwl 0xc011b444,%eax
c010124e:	0f b6 c0             	movzbl %al,%eax
c0101251:	0f b7 15 46 b4 11 c0 	movzwl 0xc011b446,%edx
c0101258:	42                   	inc    %edx
c0101259:	0f b7 d2             	movzwl %dx,%edx
c010125c:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c0101260:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101263:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101267:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010126b:	ee                   	out    %al,(%dx)
}
c010126c:	90                   	nop
}
c010126d:	90                   	nop
c010126e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
c0101271:	89 ec                	mov    %ebp,%esp
c0101273:	5d                   	pop    %ebp
c0101274:	c3                   	ret    

c0101275 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101275:	55                   	push   %ebp
c0101276:	89 e5                	mov    %esp,%ebp
c0101278:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101282:	eb 08                	jmp    c010128c <serial_putc_sub+0x17>
        delay();
c0101284:	e8 16 fb ff ff       	call   c0100d9f <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101289:	ff 45 fc             	incl   -0x4(%ebp)
c010128c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101292:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101296:	89 c2                	mov    %eax,%edx
c0101298:	ec                   	in     (%dx),%al
c0101299:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010129c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012a0:	0f b6 c0             	movzbl %al,%eax
c01012a3:	83 e0 20             	and    $0x20,%eax
c01012a6:	85 c0                	test   %eax,%eax
c01012a8:	75 09                	jne    c01012b3 <serial_putc_sub+0x3e>
c01012aa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012b1:	7e d1                	jle    c0101284 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c01012b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b6:	0f b6 c0             	movzbl %al,%eax
c01012b9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01012bf:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01012c6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01012ca:	ee                   	out    %al,(%dx)
}
c01012cb:	90                   	nop
}
c01012cc:	90                   	nop
c01012cd:	89 ec                	mov    %ebp,%esp
c01012cf:	5d                   	pop    %ebp
c01012d0:	c3                   	ret    

c01012d1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012d1:	55                   	push   %ebp
c01012d2:	89 e5                	mov    %esp,%ebp
c01012d4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01012d7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01012db:	74 0d                	je     c01012ea <serial_putc+0x19>
        serial_putc_sub(c);
c01012dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e0:	89 04 24             	mov    %eax,(%esp)
c01012e3:	e8 8d ff ff ff       	call   c0101275 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c01012e8:	eb 24                	jmp    c010130e <serial_putc+0x3d>
        serial_putc_sub('\b');
c01012ea:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01012f1:	e8 7f ff ff ff       	call   c0101275 <serial_putc_sub>
        serial_putc_sub(' ');
c01012f6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01012fd:	e8 73 ff ff ff       	call   c0101275 <serial_putc_sub>
        serial_putc_sub('\b');
c0101302:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101309:	e8 67 ff ff ff       	call   c0101275 <serial_putc_sub>
}
c010130e:	90                   	nop
c010130f:	89 ec                	mov    %ebp,%esp
c0101311:	5d                   	pop    %ebp
c0101312:	c3                   	ret    

c0101313 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101313:	55                   	push   %ebp
c0101314:	89 e5                	mov    %esp,%ebp
c0101316:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101319:	eb 33                	jmp    c010134e <cons_intr+0x3b>
        if (c != 0) {
c010131b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010131f:	74 2d                	je     c010134e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101321:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c0101326:	8d 50 01             	lea    0x1(%eax),%edx
c0101329:	89 15 64 b6 11 c0    	mov    %edx,0xc011b664
c010132f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101332:	88 90 60 b4 11 c0    	mov    %dl,-0x3fee4ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101338:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c010133d:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101342:	75 0a                	jne    c010134e <cons_intr+0x3b>
                cons.wpos = 0;
c0101344:	c7 05 64 b6 11 c0 00 	movl   $0x0,0xc011b664
c010134b:	00 00 00 
    while ((c = (*proc)()) != -1) {
c010134e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101351:	ff d0                	call   *%eax
c0101353:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101356:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010135a:	75 bf                	jne    c010131b <cons_intr+0x8>
            }
        }
    }
}
c010135c:	90                   	nop
c010135d:	90                   	nop
c010135e:	89 ec                	mov    %ebp,%esp
c0101360:	5d                   	pop    %ebp
c0101361:	c3                   	ret    

c0101362 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101362:	55                   	push   %ebp
c0101363:	89 e5                	mov    %esp,%ebp
c0101365:	83 ec 10             	sub    $0x10,%esp
c0101368:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010136e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101372:	89 c2                	mov    %eax,%edx
c0101374:	ec                   	in     (%dx),%al
c0101375:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101378:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010137c:	0f b6 c0             	movzbl %al,%eax
c010137f:	83 e0 01             	and    $0x1,%eax
c0101382:	85 c0                	test   %eax,%eax
c0101384:	75 07                	jne    c010138d <serial_proc_data+0x2b>
        return -1;
c0101386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010138b:	eb 2a                	jmp    c01013b7 <serial_proc_data+0x55>
c010138d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101393:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101397:	89 c2                	mov    %eax,%edx
c0101399:	ec                   	in     (%dx),%al
c010139a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c010139d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013a1:	0f b6 c0             	movzbl %al,%eax
c01013a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013a7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ab:	75 07                	jne    c01013b4 <serial_proc_data+0x52>
        c = '\b';
c01013ad:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013b7:	89 ec                	mov    %ebp,%esp
c01013b9:	5d                   	pop    %ebp
c01013ba:	c3                   	ret    

c01013bb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013bb:	55                   	push   %ebp
c01013bc:	89 e5                	mov    %esp,%ebp
c01013be:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013c1:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c01013c6:	85 c0                	test   %eax,%eax
c01013c8:	74 0c                	je     c01013d6 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c01013ca:	c7 04 24 62 13 10 c0 	movl   $0xc0101362,(%esp)
c01013d1:	e8 3d ff ff ff       	call   c0101313 <cons_intr>
    }
}
c01013d6:	90                   	nop
c01013d7:	89 ec                	mov    %ebp,%esp
c01013d9:	5d                   	pop    %ebp
c01013da:	c3                   	ret    

c01013db <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013db:	55                   	push   %ebp
c01013dc:	89 e5                	mov    %esp,%ebp
c01013de:	83 ec 38             	sub    $0x38,%esp
c01013e1:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01013ea:	89 c2                	mov    %eax,%edx
c01013ec:	ec                   	in     (%dx),%al
c01013ed:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c01013f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01013f4:	0f b6 c0             	movzbl %al,%eax
c01013f7:	83 e0 01             	and    $0x1,%eax
c01013fa:	85 c0                	test   %eax,%eax
c01013fc:	75 0a                	jne    c0101408 <kbd_proc_data+0x2d>
        return -1;
c01013fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101403:	e9 56 01 00 00       	jmp    c010155e <kbd_proc_data+0x183>
c0101408:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101411:	89 c2                	mov    %eax,%edx
c0101413:	ec                   	in     (%dx),%al
c0101414:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101417:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010141b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010141e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101422:	75 17                	jne    c010143b <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101424:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101429:	83 c8 40             	or     $0x40,%eax
c010142c:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c0101431:	b8 00 00 00 00       	mov    $0x0,%eax
c0101436:	e9 23 01 00 00       	jmp    c010155e <kbd_proc_data+0x183>
    } else if (data & 0x80) {
c010143b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010143f:	84 c0                	test   %al,%al
c0101441:	79 45                	jns    c0101488 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101443:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101448:	83 e0 40             	and    $0x40,%eax
c010144b:	85 c0                	test   %eax,%eax
c010144d:	75 08                	jne    c0101457 <kbd_proc_data+0x7c>
c010144f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101453:	24 7f                	and    $0x7f,%al
c0101455:	eb 04                	jmp    c010145b <kbd_proc_data+0x80>
c0101457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010145b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010145e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101462:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c0101469:	0c 40                	or     $0x40,%al
c010146b:	0f b6 c0             	movzbl %al,%eax
c010146e:	f7 d0                	not    %eax
c0101470:	89 c2                	mov    %eax,%edx
c0101472:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c0101477:	21 d0                	and    %edx,%eax
c0101479:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
        return 0;
c010147e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101483:	e9 d6 00 00 00       	jmp    c010155e <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
c0101488:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010148d:	83 e0 40             	and    $0x40,%eax
c0101490:	85 c0                	test   %eax,%eax
c0101492:	74 11                	je     c01014a5 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101494:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101498:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010149d:	83 e0 bf             	and    $0xffffffbf,%eax
c01014a0:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    }

    shift |= shiftcode[data];
c01014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a9:	0f b6 80 40 80 11 c0 	movzbl -0x3fee7fc0(%eax),%eax
c01014b0:	0f b6 d0             	movzbl %al,%edx
c01014b3:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014b8:	09 d0                	or     %edx,%eax
c01014ba:	a3 68 b6 11 c0       	mov    %eax,0xc011b668
    shift ^= togglecode[data];
c01014bf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c3:	0f b6 80 40 81 11 c0 	movzbl -0x3fee7ec0(%eax),%eax
c01014ca:	0f b6 d0             	movzbl %al,%edx
c01014cd:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014d2:	31 d0                	xor    %edx,%eax
c01014d4:	a3 68 b6 11 c0       	mov    %eax,0xc011b668

    c = charcode[shift & (CTL | SHIFT)][data];
c01014d9:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014de:	83 e0 03             	and    $0x3,%eax
c01014e1:	8b 14 85 40 85 11 c0 	mov    -0x3fee7ac0(,%eax,4),%edx
c01014e8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ec:	01 d0                	add    %edx,%eax
c01014ee:	0f b6 00             	movzbl (%eax),%eax
c01014f1:	0f b6 c0             	movzbl %al,%eax
c01014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01014f7:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c01014fc:	83 e0 08             	and    $0x8,%eax
c01014ff:	85 c0                	test   %eax,%eax
c0101501:	74 22                	je     c0101525 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101503:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101507:	7e 0c                	jle    c0101515 <kbd_proc_data+0x13a>
c0101509:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010150d:	7f 06                	jg     c0101515 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c010150f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101513:	eb 10                	jmp    c0101525 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101515:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101519:	7e 0a                	jle    c0101525 <kbd_proc_data+0x14a>
c010151b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010151f:	7f 04                	jg     c0101525 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101521:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101525:	a1 68 b6 11 c0       	mov    0xc011b668,%eax
c010152a:	f7 d0                	not    %eax
c010152c:	83 e0 06             	and    $0x6,%eax
c010152f:	85 c0                	test   %eax,%eax
c0101531:	75 28                	jne    c010155b <kbd_proc_data+0x180>
c0101533:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010153a:	75 1f                	jne    c010155b <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
c010153c:	c7 04 24 27 5f 10 c0 	movl   $0xc0105f27,(%esp)
c0101543:	e8 0e ee ff ff       	call   c0100356 <cprintf>
c0101548:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010154e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101552:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101556:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101559:	ee                   	out    %al,(%dx)
}
c010155a:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010155e:	89 ec                	mov    %ebp,%esp
c0101560:	5d                   	pop    %ebp
c0101561:	c3                   	ret    

c0101562 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101562:	55                   	push   %ebp
c0101563:	89 e5                	mov    %esp,%ebp
c0101565:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101568:	c7 04 24 db 13 10 c0 	movl   $0xc01013db,(%esp)
c010156f:	e8 9f fd ff ff       	call   c0101313 <cons_intr>
}
c0101574:	90                   	nop
c0101575:	89 ec                	mov    %ebp,%esp
c0101577:	5d                   	pop    %ebp
c0101578:	c3                   	ret    

c0101579 <kbd_init>:

static void
kbd_init(void) {
c0101579:	55                   	push   %ebp
c010157a:	89 e5                	mov    %esp,%ebp
c010157c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010157f:	e8 de ff ff ff       	call   c0101562 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101584:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010158b:	e8 51 01 00 00       	call   c01016e1 <pic_enable>
}
c0101590:	90                   	nop
c0101591:	89 ec                	mov    %ebp,%esp
c0101593:	5d                   	pop    %ebp
c0101594:	c3                   	ret    

c0101595 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101595:	55                   	push   %ebp
c0101596:	89 e5                	mov    %esp,%ebp
c0101598:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c010159b:	e8 4a f8 ff ff       	call   c0100dea <cga_init>
    serial_init();
c01015a0:	e8 2d f9 ff ff       	call   c0100ed2 <serial_init>
    kbd_init();
c01015a5:	e8 cf ff ff ff       	call   c0101579 <kbd_init>
    if (!serial_exists) {
c01015aa:	a1 48 b4 11 c0       	mov    0xc011b448,%eax
c01015af:	85 c0                	test   %eax,%eax
c01015b1:	75 0c                	jne    c01015bf <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015b3:	c7 04 24 33 5f 10 c0 	movl   $0xc0105f33,(%esp)
c01015ba:	e8 97 ed ff ff       	call   c0100356 <cprintf>
    }
}
c01015bf:	90                   	nop
c01015c0:	89 ec                	mov    %ebp,%esp
c01015c2:	5d                   	pop    %ebp
c01015c3:	c3                   	ret    

c01015c4 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015c4:	55                   	push   %ebp
c01015c5:	89 e5                	mov    %esp,%ebp
c01015c7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015ca:	e8 8e f7 ff ff       	call   c0100d5d <__intr_save>
c01015cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01015d5:	89 04 24             	mov    %eax,(%esp)
c01015d8:	e8 60 fa ff ff       	call   c010103d <lpt_putc>
        cga_putc(c);
c01015dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01015e0:	89 04 24             	mov    %eax,(%esp)
c01015e3:	e8 97 fa ff ff       	call   c010107f <cga_putc>
        serial_putc(c);
c01015e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01015eb:	89 04 24             	mov    %eax,(%esp)
c01015ee:	e8 de fc ff ff       	call   c01012d1 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01015f6:	89 04 24             	mov    %eax,(%esp)
c01015f9:	e8 8b f7 ff ff       	call   c0100d89 <__intr_restore>
}
c01015fe:	90                   	nop
c01015ff:	89 ec                	mov    %ebp,%esp
c0101601:	5d                   	pop    %ebp
c0101602:	c3                   	ret    

c0101603 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101603:	55                   	push   %ebp
c0101604:	89 e5                	mov    %esp,%ebp
c0101606:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101610:	e8 48 f7 ff ff       	call   c0100d5d <__intr_save>
c0101615:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101618:	e8 9e fd ff ff       	call   c01013bb <serial_intr>
        kbd_intr();
c010161d:	e8 40 ff ff ff       	call   c0101562 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101622:	8b 15 60 b6 11 c0    	mov    0xc011b660,%edx
c0101628:	a1 64 b6 11 c0       	mov    0xc011b664,%eax
c010162d:	39 c2                	cmp    %eax,%edx
c010162f:	74 31                	je     c0101662 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101631:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101636:	8d 50 01             	lea    0x1(%eax),%edx
c0101639:	89 15 60 b6 11 c0    	mov    %edx,0xc011b660
c010163f:	0f b6 80 60 b4 11 c0 	movzbl -0x3fee4ba0(%eax),%eax
c0101646:	0f b6 c0             	movzbl %al,%eax
c0101649:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010164c:	a1 60 b6 11 c0       	mov    0xc011b660,%eax
c0101651:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101656:	75 0a                	jne    c0101662 <cons_getc+0x5f>
                cons.rpos = 0;
c0101658:	c7 05 60 b6 11 c0 00 	movl   $0x0,0xc011b660
c010165f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101662:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101665:	89 04 24             	mov    %eax,(%esp)
c0101668:	e8 1c f7 ff ff       	call   c0100d89 <__intr_restore>
    return c;
c010166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101670:	89 ec                	mov    %ebp,%esp
c0101672:	5d                   	pop    %ebp
c0101673:	c3                   	ret    

c0101674 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101674:	55                   	push   %ebp
c0101675:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c0101677:	fb                   	sti    
}
c0101678:	90                   	nop
    sti();
}
c0101679:	90                   	nop
c010167a:	5d                   	pop    %ebp
c010167b:	c3                   	ret    

c010167c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010167c:	55                   	push   %ebp
c010167d:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c010167f:	fa                   	cli    
}
c0101680:	90                   	nop
    cli();
}
c0101681:	90                   	nop
c0101682:	5d                   	pop    %ebp
c0101683:	c3                   	ret    

c0101684 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101684:	55                   	push   %ebp
c0101685:	89 e5                	mov    %esp,%ebp
c0101687:	83 ec 14             	sub    $0x14,%esp
c010168a:	8b 45 08             	mov    0x8(%ebp),%eax
c010168d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101691:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101694:	66 a3 50 85 11 c0    	mov    %ax,0xc0118550
    if (did_init) {
c010169a:	a1 6c b6 11 c0       	mov    0xc011b66c,%eax
c010169f:	85 c0                	test   %eax,%eax
c01016a1:	74 39                	je     c01016dc <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
c01016a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016a6:	0f b6 c0             	movzbl %al,%eax
c01016a9:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016af:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016b2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016b6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016ba:	ee                   	out    %al,(%dx)
}
c01016bb:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	c1 e8 08             	shr    $0x8,%eax
c01016c3:	0f b7 c0             	movzwl %ax,%eax
c01016c6:	0f b6 c0             	movzbl %al,%eax
c01016c9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01016cf:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016d2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016d6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016da:	ee                   	out    %al,(%dx)
}
c01016db:	90                   	nop
    }
}
c01016dc:	90                   	nop
c01016dd:	89 ec                	mov    %ebp,%esp
c01016df:	5d                   	pop    %ebp
c01016e0:	c3                   	ret    

c01016e1 <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016e1:	55                   	push   %ebp
c01016e2:	89 e5                	mov    %esp,%ebp
c01016e4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01016e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01016ea:	ba 01 00 00 00       	mov    $0x1,%edx
c01016ef:	88 c1                	mov    %al,%cl
c01016f1:	d3 e2                	shl    %cl,%edx
c01016f3:	89 d0                	mov    %edx,%eax
c01016f5:	98                   	cwtl   
c01016f6:	f7 d0                	not    %eax
c01016f8:	0f bf d0             	movswl %ax,%edx
c01016fb:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101702:	98                   	cwtl   
c0101703:	21 d0                	and    %edx,%eax
c0101705:	98                   	cwtl   
c0101706:	0f b7 c0             	movzwl %ax,%eax
c0101709:	89 04 24             	mov    %eax,(%esp)
c010170c:	e8 73 ff ff ff       	call   c0101684 <pic_setmask>
}
c0101711:	90                   	nop
c0101712:	89 ec                	mov    %ebp,%esp
c0101714:	5d                   	pop    %ebp
c0101715:	c3                   	ret    

c0101716 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101716:	55                   	push   %ebp
c0101717:	89 e5                	mov    %esp,%ebp
c0101719:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010171c:	c7 05 6c b6 11 c0 01 	movl   $0x1,0xc011b66c
c0101723:	00 00 00 
c0101726:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c010172c:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101730:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101734:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101738:	ee                   	out    %al,(%dx)
}
c0101739:	90                   	nop
c010173a:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c0101740:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101744:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101748:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010174c:	ee                   	out    %al,(%dx)
}
c010174d:	90                   	nop
c010174e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101754:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101758:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010175c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101760:	ee                   	out    %al,(%dx)
}
c0101761:	90                   	nop
c0101762:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101768:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010176c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101770:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101774:	ee                   	out    %al,(%dx)
}
c0101775:	90                   	nop
c0101776:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c010177c:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101780:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101784:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101788:	ee                   	out    %al,(%dx)
}
c0101789:	90                   	nop
c010178a:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c0101790:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101794:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101798:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010179c:	ee                   	out    %al,(%dx)
}
c010179d:	90                   	nop
c010179e:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017a4:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017a8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017ac:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017b0:	ee                   	out    %al,(%dx)
}
c01017b1:	90                   	nop
c01017b2:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017b8:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017bc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c4:	ee                   	out    %al,(%dx)
}
c01017c5:	90                   	nop
c01017c6:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01017cc:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017d0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017d4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017d8:	ee                   	out    %al,(%dx)
}
c01017d9:	90                   	nop
c01017da:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017e0:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017e4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ec:	ee                   	out    %al,(%dx)
}
c01017ed:	90                   	nop
c01017ee:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c01017f4:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01017f8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017fc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101800:	ee                   	out    %al,(%dx)
}
c0101801:	90                   	nop
c0101802:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101808:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010180c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101810:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101814:	ee                   	out    %al,(%dx)
}
c0101815:	90                   	nop
c0101816:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010181c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101820:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101824:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
}
c0101829:	90                   	nop
c010182a:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c0101830:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101834:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101838:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010183c:	ee                   	out    %al,(%dx)
}
c010183d:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010183e:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101845:	3d ff ff 00 00       	cmp    $0xffff,%eax
c010184a:	74 0f                	je     c010185b <pic_init+0x145>
        pic_setmask(irq_mask);
c010184c:	0f b7 05 50 85 11 c0 	movzwl 0xc0118550,%eax
c0101853:	89 04 24             	mov    %eax,(%esp)
c0101856:	e8 29 fe ff ff       	call   c0101684 <pic_setmask>
    }
}
c010185b:	90                   	nop
c010185c:	89 ec                	mov    %ebp,%esp
c010185e:	5d                   	pop    %ebp
c010185f:	c3                   	ret    

c0101860 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101860:	55                   	push   %ebp
c0101861:	89 e5                	mov    %esp,%ebp
c0101863:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101866:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010186d:	00 
c010186e:	c7 04 24 60 5f 10 c0 	movl   $0xc0105f60,(%esp)
c0101875:	e8 dc ea ff ff       	call   c0100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010187a:	90                   	nop
c010187b:	89 ec                	mov    %ebp,%esp
c010187d:	5d                   	pop    %ebp
c010187e:	c3                   	ret    

c010187f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010187f:	55                   	push   %ebp
c0101880:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c0101882:	90                   	nop
c0101883:	5d                   	pop    %ebp
c0101884:	c3                   	ret    

c0101885 <trapname>:

static const char *
trapname(int trapno) {
c0101885:	55                   	push   %ebp
c0101886:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101888:	8b 45 08             	mov    0x8(%ebp),%eax
c010188b:	83 f8 13             	cmp    $0x13,%eax
c010188e:	77 0c                	ja     c010189c <trapname+0x17>
        return excnames[trapno];
c0101890:	8b 45 08             	mov    0x8(%ebp),%eax
c0101893:	8b 04 85 c0 62 10 c0 	mov    -0x3fef9d40(,%eax,4),%eax
c010189a:	eb 18                	jmp    c01018b4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010189c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01018a0:	7e 0d                	jle    c01018af <trapname+0x2a>
c01018a2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01018a6:	7f 07                	jg     c01018af <trapname+0x2a>
        return "Hardware Interrupt";
c01018a8:	b8 6a 5f 10 c0       	mov    $0xc0105f6a,%eax
c01018ad:	eb 05                	jmp    c01018b4 <trapname+0x2f>
    }
    return "(unknown trap)";
c01018af:	b8 7d 5f 10 c0       	mov    $0xc0105f7d,%eax
}
c01018b4:	5d                   	pop    %ebp
c01018b5:	c3                   	ret    

c01018b6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01018b6:	55                   	push   %ebp
c01018b7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01018b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01018bc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01018c0:	83 f8 08             	cmp    $0x8,%eax
c01018c3:	0f 94 c0             	sete   %al
c01018c6:	0f b6 c0             	movzbl %al,%eax
}
c01018c9:	5d                   	pop    %ebp
c01018ca:	c3                   	ret    

c01018cb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01018cb:	55                   	push   %ebp
c01018cc:	89 e5                	mov    %esp,%ebp
c01018ce:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01018d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01018d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018d8:	c7 04 24 be 5f 10 c0 	movl   $0xc0105fbe,(%esp)
c01018df:	e8 72 ea ff ff       	call   c0100356 <cprintf>
    print_regs(&tf->tf_regs);
c01018e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01018e7:	89 04 24             	mov    %eax,(%esp)
c01018ea:	e8 8f 01 00 00       	call   c0101a7e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01018ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01018f2:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018fa:	c7 04 24 cf 5f 10 c0 	movl   $0xc0105fcf,(%esp)
c0101901:	e8 50 ea ff ff       	call   c0100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101906:	8b 45 08             	mov    0x8(%ebp),%eax
c0101909:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010190d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101911:	c7 04 24 e2 5f 10 c0 	movl   $0xc0105fe2,(%esp)
c0101918:	e8 39 ea ff ff       	call   c0100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010191d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101920:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101924:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101928:	c7 04 24 f5 5f 10 c0 	movl   $0xc0105ff5,(%esp)
c010192f:	e8 22 ea ff ff       	call   c0100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101934:	8b 45 08             	mov    0x8(%ebp),%eax
c0101937:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010193b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010193f:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c0101946:	e8 0b ea ff ff       	call   c0100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010194b:	8b 45 08             	mov    0x8(%ebp),%eax
c010194e:	8b 40 30             	mov    0x30(%eax),%eax
c0101951:	89 04 24             	mov    %eax,(%esp)
c0101954:	e8 2c ff ff ff       	call   c0101885 <trapname>
c0101959:	8b 55 08             	mov    0x8(%ebp),%edx
c010195c:	8b 52 30             	mov    0x30(%edx),%edx
c010195f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101963:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101967:	c7 04 24 1b 60 10 c0 	movl   $0xc010601b,(%esp)
c010196e:	e8 e3 e9 ff ff       	call   c0100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101973:	8b 45 08             	mov    0x8(%ebp),%eax
c0101976:	8b 40 34             	mov    0x34(%eax),%eax
c0101979:	89 44 24 04          	mov    %eax,0x4(%esp)
c010197d:	c7 04 24 2d 60 10 c0 	movl   $0xc010602d,(%esp)
c0101984:	e8 cd e9 ff ff       	call   c0100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101989:	8b 45 08             	mov    0x8(%ebp),%eax
c010198c:	8b 40 38             	mov    0x38(%eax),%eax
c010198f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101993:	c7 04 24 3c 60 10 c0 	movl   $0xc010603c,(%esp)
c010199a:	e8 b7 e9 ff ff       	call   c0100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c010199f:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019aa:	c7 04 24 4b 60 10 c0 	movl   $0xc010604b,(%esp)
c01019b1:	e8 a0 e9 ff ff       	call   c0100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01019b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b9:	8b 40 40             	mov    0x40(%eax),%eax
c01019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019c0:	c7 04 24 5e 60 10 c0 	movl   $0xc010605e,(%esp)
c01019c7:	e8 8a e9 ff ff       	call   c0100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01019cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01019d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01019da:	eb 3d                	jmp    c0101a19 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01019dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01019df:	8b 50 40             	mov    0x40(%eax),%edx
c01019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01019e5:	21 d0                	and    %edx,%eax
c01019e7:	85 c0                	test   %eax,%eax
c01019e9:	74 28                	je     c0101a13 <print_trapframe+0x148>
c01019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019ee:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c01019f5:	85 c0                	test   %eax,%eax
c01019f7:	74 1a                	je     c0101a13 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
c01019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01019fc:	8b 04 85 80 85 11 c0 	mov    -0x3fee7a80(,%eax,4),%eax
c0101a03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a07:	c7 04 24 6d 60 10 c0 	movl   $0xc010606d,(%esp)
c0101a0e:	e8 43 e9 ff ff       	call   c0100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101a13:	ff 45 f4             	incl   -0xc(%ebp)
c0101a16:	d1 65 f0             	shll   -0x10(%ebp)
c0101a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101a1c:	83 f8 17             	cmp    $0x17,%eax
c0101a1f:	76 bb                	jbe    c01019dc <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101a21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a24:	8b 40 40             	mov    0x40(%eax),%eax
c0101a27:	c1 e8 0c             	shr    $0xc,%eax
c0101a2a:	83 e0 03             	and    $0x3,%eax
c0101a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a31:	c7 04 24 71 60 10 c0 	movl   $0xc0106071,(%esp)
c0101a38:	e8 19 e9 ff ff       	call   c0100356 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a40:	89 04 24             	mov    %eax,(%esp)
c0101a43:	e8 6e fe ff ff       	call   c01018b6 <trap_in_kernel>
c0101a48:	85 c0                	test   %eax,%eax
c0101a4a:	75 2d                	jne    c0101a79 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4f:	8b 40 44             	mov    0x44(%eax),%eax
c0101a52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a56:	c7 04 24 7a 60 10 c0 	movl   $0xc010607a,(%esp)
c0101a5d:	e8 f4 e8 ff ff       	call   c0100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101a62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a65:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101a69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a6d:	c7 04 24 89 60 10 c0 	movl   $0xc0106089,(%esp)
c0101a74:	e8 dd e8 ff ff       	call   c0100356 <cprintf>
    }
}
c0101a79:	90                   	nop
c0101a7a:	89 ec                	mov    %ebp,%esp
c0101a7c:	5d                   	pop    %ebp
c0101a7d:	c3                   	ret    

c0101a7e <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101a7e:	55                   	push   %ebp
c0101a7f:	89 e5                	mov    %esp,%ebp
c0101a81:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101a84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a87:	8b 00                	mov    (%eax),%eax
c0101a89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a8d:	c7 04 24 9c 60 10 c0 	movl   $0xc010609c,(%esp)
c0101a94:	e8 bd e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9c:	8b 40 04             	mov    0x4(%eax),%eax
c0101a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa3:	c7 04 24 ab 60 10 c0 	movl   $0xc01060ab,(%esp)
c0101aaa:	e8 a7 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab2:	8b 40 08             	mov    0x8(%eax),%eax
c0101ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab9:	c7 04 24 ba 60 10 c0 	movl   $0xc01060ba,(%esp)
c0101ac0:	e8 91 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac8:	8b 40 0c             	mov    0xc(%eax),%eax
c0101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101acf:	c7 04 24 c9 60 10 c0 	movl   $0xc01060c9,(%esp)
c0101ad6:	e8 7b e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ade:	8b 40 10             	mov    0x10(%eax),%eax
c0101ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae5:	c7 04 24 d8 60 10 c0 	movl   $0xc01060d8,(%esp)
c0101aec:	e8 65 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af4:	8b 40 14             	mov    0x14(%eax),%eax
c0101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101afb:	c7 04 24 e7 60 10 c0 	movl   $0xc01060e7,(%esp)
c0101b02:	e8 4f e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0a:	8b 40 18             	mov    0x18(%eax),%eax
c0101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b11:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
c0101b18:	e8 39 e8 ff ff       	call   c0100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b20:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b27:	c7 04 24 05 61 10 c0 	movl   $0xc0106105,(%esp)
c0101b2e:	e8 23 e8 ff ff       	call   c0100356 <cprintf>
}
c0101b33:	90                   	nop
c0101b34:	89 ec                	mov    %ebp,%esp
c0101b36:	5d                   	pop    %ebp
c0101b37:	c3                   	ret    

c0101b38 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101b38:	55                   	push   %ebp
c0101b39:	89 e5                	mov    %esp,%ebp
c0101b3b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b41:	8b 40 30             	mov    0x30(%eax),%eax
c0101b44:	83 f8 79             	cmp    $0x79,%eax
c0101b47:	0f 87 99 00 00 00    	ja     c0101be6 <trap_dispatch+0xae>
c0101b4d:	83 f8 78             	cmp    $0x78,%eax
c0101b50:	73 78                	jae    c0101bca <trap_dispatch+0x92>
c0101b52:	83 f8 2f             	cmp    $0x2f,%eax
c0101b55:	0f 87 8b 00 00 00    	ja     c0101be6 <trap_dispatch+0xae>
c0101b5b:	83 f8 2e             	cmp    $0x2e,%eax
c0101b5e:	0f 83 b7 00 00 00    	jae    c0101c1b <trap_dispatch+0xe3>
c0101b64:	83 f8 24             	cmp    $0x24,%eax
c0101b67:	74 15                	je     c0101b7e <trap_dispatch+0x46>
c0101b69:	83 f8 24             	cmp    $0x24,%eax
c0101b6c:	77 78                	ja     c0101be6 <trap_dispatch+0xae>
c0101b6e:	83 f8 20             	cmp    $0x20,%eax
c0101b71:	0f 84 a7 00 00 00    	je     c0101c1e <trap_dispatch+0xe6>
c0101b77:	83 f8 21             	cmp    $0x21,%eax
c0101b7a:	74 28                	je     c0101ba4 <trap_dispatch+0x6c>
c0101b7c:	eb 68                	jmp    c0101be6 <trap_dispatch+0xae>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101b7e:	e8 80 fa ff ff       	call   c0101603 <cons_getc>
c0101b83:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101b86:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101b8a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101b8e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b96:	c7 04 24 14 61 10 c0 	movl   $0xc0106114,(%esp)
c0101b9d:	e8 b4 e7 ff ff       	call   c0100356 <cprintf>
        break;
c0101ba2:	eb 7b                	jmp    c0101c1f <trap_dispatch+0xe7>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101ba4:	e8 5a fa ff ff       	call   c0101603 <cons_getc>
c0101ba9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101bac:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101bb0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101bb4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbc:	c7 04 24 26 61 10 c0 	movl   $0xc0106126,(%esp)
c0101bc3:	e8 8e e7 ff ff       	call   c0100356 <cprintf>
        break;
c0101bc8:	eb 55                	jmp    c0101c1f <trap_dispatch+0xe7>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101bca:	c7 44 24 08 35 61 10 	movl   $0xc0106135,0x8(%esp)
c0101bd1:	c0 
c0101bd2:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c0101bd9:	00 
c0101bda:	c7 04 24 45 61 10 c0 	movl   $0xc0106145,(%esp)
c0101be1:	e8 3d f0 ff ff       	call   c0100c23 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101be6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bed:	83 e0 03             	and    $0x3,%eax
c0101bf0:	85 c0                	test   %eax,%eax
c0101bf2:	75 2b                	jne    c0101c1f <trap_dispatch+0xe7>
            print_trapframe(tf);
c0101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf7:	89 04 24             	mov    %eax,(%esp)
c0101bfa:	e8 cc fc ff ff       	call   c01018cb <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101bff:	c7 44 24 08 56 61 10 	movl   $0xc0106156,0x8(%esp)
c0101c06:	c0 
c0101c07:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101c0e:	00 
c0101c0f:	c7 04 24 45 61 10 c0 	movl   $0xc0106145,(%esp)
c0101c16:	e8 08 f0 ff ff       	call   c0100c23 <__panic>
        break;
c0101c1b:	90                   	nop
c0101c1c:	eb 01                	jmp    c0101c1f <trap_dispatch+0xe7>
        break;
c0101c1e:	90                   	nop
        }
    }
}
c0101c1f:	90                   	nop
c0101c20:	89 ec                	mov    %ebp,%esp
c0101c22:	5d                   	pop    %ebp
c0101c23:	c3                   	ret    

c0101c24 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101c24:	55                   	push   %ebp
c0101c25:	89 e5                	mov    %esp,%ebp
c0101c27:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2d:	89 04 24             	mov    %eax,(%esp)
c0101c30:	e8 03 ff ff ff       	call   c0101b38 <trap_dispatch>
}
c0101c35:	90                   	nop
c0101c36:	89 ec                	mov    %ebp,%esp
c0101c38:	5d                   	pop    %ebp
c0101c39:	c3                   	ret    

c0101c3a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101c3a:	1e                   	push   %ds
    pushl %es
c0101c3b:	06                   	push   %es
    pushl %fs
c0101c3c:	0f a0                	push   %fs
    pushl %gs
c0101c3e:	0f a8                	push   %gs
    pushal
c0101c40:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101c41:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101c46:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101c48:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101c4a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101c4b:	e8 d4 ff ff ff       	call   c0101c24 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101c50:	5c                   	pop    %esp

c0101c51 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101c51:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101c52:	0f a9                	pop    %gs
    popl %fs
c0101c54:	0f a1                	pop    %fs
    popl %es
c0101c56:	07                   	pop    %es
    popl %ds
c0101c57:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101c58:	83 c4 08             	add    $0x8,%esp
    iret
c0101c5b:	cf                   	iret   

c0101c5c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101c5c:	6a 00                	push   $0x0
  pushl $0
c0101c5e:	6a 00                	push   $0x0
  jmp __alltraps
c0101c60:	e9 d5 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c65 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101c65:	6a 00                	push   $0x0
  pushl $1
c0101c67:	6a 01                	push   $0x1
  jmp __alltraps
c0101c69:	e9 cc ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c6e <vector2>:
.globl vector2
vector2:
  pushl $0
c0101c6e:	6a 00                	push   $0x0
  pushl $2
c0101c70:	6a 02                	push   $0x2
  jmp __alltraps
c0101c72:	e9 c3 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c77 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101c77:	6a 00                	push   $0x0
  pushl $3
c0101c79:	6a 03                	push   $0x3
  jmp __alltraps
c0101c7b:	e9 ba ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c80 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101c80:	6a 00                	push   $0x0
  pushl $4
c0101c82:	6a 04                	push   $0x4
  jmp __alltraps
c0101c84:	e9 b1 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c89 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101c89:	6a 00                	push   $0x0
  pushl $5
c0101c8b:	6a 05                	push   $0x5
  jmp __alltraps
c0101c8d:	e9 a8 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c92 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101c92:	6a 00                	push   $0x0
  pushl $6
c0101c94:	6a 06                	push   $0x6
  jmp __alltraps
c0101c96:	e9 9f ff ff ff       	jmp    c0101c3a <__alltraps>

c0101c9b <vector7>:
.globl vector7
vector7:
  pushl $0
c0101c9b:	6a 00                	push   $0x0
  pushl $7
c0101c9d:	6a 07                	push   $0x7
  jmp __alltraps
c0101c9f:	e9 96 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101ca4 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101ca4:	6a 08                	push   $0x8
  jmp __alltraps
c0101ca6:	e9 8f ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cab <vector9>:
.globl vector9
vector9:
  pushl $0
c0101cab:	6a 00                	push   $0x0
  pushl $9
c0101cad:	6a 09                	push   $0x9
  jmp __alltraps
c0101caf:	e9 86 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cb4 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101cb4:	6a 0a                	push   $0xa
  jmp __alltraps
c0101cb6:	e9 7f ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cbb <vector11>:
.globl vector11
vector11:
  pushl $11
c0101cbb:	6a 0b                	push   $0xb
  jmp __alltraps
c0101cbd:	e9 78 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cc2 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101cc2:	6a 0c                	push   $0xc
  jmp __alltraps
c0101cc4:	e9 71 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cc9 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101cc9:	6a 0d                	push   $0xd
  jmp __alltraps
c0101ccb:	e9 6a ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cd0 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101cd0:	6a 0e                	push   $0xe
  jmp __alltraps
c0101cd2:	e9 63 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cd7 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101cd7:	6a 00                	push   $0x0
  pushl $15
c0101cd9:	6a 0f                	push   $0xf
  jmp __alltraps
c0101cdb:	e9 5a ff ff ff       	jmp    c0101c3a <__alltraps>

c0101ce0 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ce0:	6a 00                	push   $0x0
  pushl $16
c0101ce2:	6a 10                	push   $0x10
  jmp __alltraps
c0101ce4:	e9 51 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101ce9 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101ce9:	6a 11                	push   $0x11
  jmp __alltraps
c0101ceb:	e9 4a ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cf0 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101cf0:	6a 00                	push   $0x0
  pushl $18
c0101cf2:	6a 12                	push   $0x12
  jmp __alltraps
c0101cf4:	e9 41 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101cf9 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101cf9:	6a 00                	push   $0x0
  pushl $19
c0101cfb:	6a 13                	push   $0x13
  jmp __alltraps
c0101cfd:	e9 38 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d02 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101d02:	6a 00                	push   $0x0
  pushl $20
c0101d04:	6a 14                	push   $0x14
  jmp __alltraps
c0101d06:	e9 2f ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d0b <vector21>:
.globl vector21
vector21:
  pushl $0
c0101d0b:	6a 00                	push   $0x0
  pushl $21
c0101d0d:	6a 15                	push   $0x15
  jmp __alltraps
c0101d0f:	e9 26 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d14 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101d14:	6a 00                	push   $0x0
  pushl $22
c0101d16:	6a 16                	push   $0x16
  jmp __alltraps
c0101d18:	e9 1d ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d1d <vector23>:
.globl vector23
vector23:
  pushl $0
c0101d1d:	6a 00                	push   $0x0
  pushl $23
c0101d1f:	6a 17                	push   $0x17
  jmp __alltraps
c0101d21:	e9 14 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d26 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101d26:	6a 00                	push   $0x0
  pushl $24
c0101d28:	6a 18                	push   $0x18
  jmp __alltraps
c0101d2a:	e9 0b ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d2f <vector25>:
.globl vector25
vector25:
  pushl $0
c0101d2f:	6a 00                	push   $0x0
  pushl $25
c0101d31:	6a 19                	push   $0x19
  jmp __alltraps
c0101d33:	e9 02 ff ff ff       	jmp    c0101c3a <__alltraps>

c0101d38 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101d38:	6a 00                	push   $0x0
  pushl $26
c0101d3a:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101d3c:	e9 f9 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d41 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101d41:	6a 00                	push   $0x0
  pushl $27
c0101d43:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101d45:	e9 f0 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d4a <vector28>:
.globl vector28
vector28:
  pushl $0
c0101d4a:	6a 00                	push   $0x0
  pushl $28
c0101d4c:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101d4e:	e9 e7 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d53 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101d53:	6a 00                	push   $0x0
  pushl $29
c0101d55:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101d57:	e9 de fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d5c <vector30>:
.globl vector30
vector30:
  pushl $0
c0101d5c:	6a 00                	push   $0x0
  pushl $30
c0101d5e:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101d60:	e9 d5 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d65 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101d65:	6a 00                	push   $0x0
  pushl $31
c0101d67:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101d69:	e9 cc fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d6e <vector32>:
.globl vector32
vector32:
  pushl $0
c0101d6e:	6a 00                	push   $0x0
  pushl $32
c0101d70:	6a 20                	push   $0x20
  jmp __alltraps
c0101d72:	e9 c3 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d77 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101d77:	6a 00                	push   $0x0
  pushl $33
c0101d79:	6a 21                	push   $0x21
  jmp __alltraps
c0101d7b:	e9 ba fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d80 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101d80:	6a 00                	push   $0x0
  pushl $34
c0101d82:	6a 22                	push   $0x22
  jmp __alltraps
c0101d84:	e9 b1 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d89 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101d89:	6a 00                	push   $0x0
  pushl $35
c0101d8b:	6a 23                	push   $0x23
  jmp __alltraps
c0101d8d:	e9 a8 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d92 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101d92:	6a 00                	push   $0x0
  pushl $36
c0101d94:	6a 24                	push   $0x24
  jmp __alltraps
c0101d96:	e9 9f fe ff ff       	jmp    c0101c3a <__alltraps>

c0101d9b <vector37>:
.globl vector37
vector37:
  pushl $0
c0101d9b:	6a 00                	push   $0x0
  pushl $37
c0101d9d:	6a 25                	push   $0x25
  jmp __alltraps
c0101d9f:	e9 96 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101da4 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101da4:	6a 00                	push   $0x0
  pushl $38
c0101da6:	6a 26                	push   $0x26
  jmp __alltraps
c0101da8:	e9 8d fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dad <vector39>:
.globl vector39
vector39:
  pushl $0
c0101dad:	6a 00                	push   $0x0
  pushl $39
c0101daf:	6a 27                	push   $0x27
  jmp __alltraps
c0101db1:	e9 84 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101db6 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101db6:	6a 00                	push   $0x0
  pushl $40
c0101db8:	6a 28                	push   $0x28
  jmp __alltraps
c0101dba:	e9 7b fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dbf <vector41>:
.globl vector41
vector41:
  pushl $0
c0101dbf:	6a 00                	push   $0x0
  pushl $41
c0101dc1:	6a 29                	push   $0x29
  jmp __alltraps
c0101dc3:	e9 72 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dc8 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101dc8:	6a 00                	push   $0x0
  pushl $42
c0101dca:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101dcc:	e9 69 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dd1 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101dd1:	6a 00                	push   $0x0
  pushl $43
c0101dd3:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101dd5:	e9 60 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dda <vector44>:
.globl vector44
vector44:
  pushl $0
c0101dda:	6a 00                	push   $0x0
  pushl $44
c0101ddc:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101dde:	e9 57 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101de3 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101de3:	6a 00                	push   $0x0
  pushl $45
c0101de5:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101de7:	e9 4e fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dec <vector46>:
.globl vector46
vector46:
  pushl $0
c0101dec:	6a 00                	push   $0x0
  pushl $46
c0101dee:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101df0:	e9 45 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101df5 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101df5:	6a 00                	push   $0x0
  pushl $47
c0101df7:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101df9:	e9 3c fe ff ff       	jmp    c0101c3a <__alltraps>

c0101dfe <vector48>:
.globl vector48
vector48:
  pushl $0
c0101dfe:	6a 00                	push   $0x0
  pushl $48
c0101e00:	6a 30                	push   $0x30
  jmp __alltraps
c0101e02:	e9 33 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101e07 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101e07:	6a 00                	push   $0x0
  pushl $49
c0101e09:	6a 31                	push   $0x31
  jmp __alltraps
c0101e0b:	e9 2a fe ff ff       	jmp    c0101c3a <__alltraps>

c0101e10 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101e10:	6a 00                	push   $0x0
  pushl $50
c0101e12:	6a 32                	push   $0x32
  jmp __alltraps
c0101e14:	e9 21 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101e19 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101e19:	6a 00                	push   $0x0
  pushl $51
c0101e1b:	6a 33                	push   $0x33
  jmp __alltraps
c0101e1d:	e9 18 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101e22 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101e22:	6a 00                	push   $0x0
  pushl $52
c0101e24:	6a 34                	push   $0x34
  jmp __alltraps
c0101e26:	e9 0f fe ff ff       	jmp    c0101c3a <__alltraps>

c0101e2b <vector53>:
.globl vector53
vector53:
  pushl $0
c0101e2b:	6a 00                	push   $0x0
  pushl $53
c0101e2d:	6a 35                	push   $0x35
  jmp __alltraps
c0101e2f:	e9 06 fe ff ff       	jmp    c0101c3a <__alltraps>

c0101e34 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101e34:	6a 00                	push   $0x0
  pushl $54
c0101e36:	6a 36                	push   $0x36
  jmp __alltraps
c0101e38:	e9 fd fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e3d <vector55>:
.globl vector55
vector55:
  pushl $0
c0101e3d:	6a 00                	push   $0x0
  pushl $55
c0101e3f:	6a 37                	push   $0x37
  jmp __alltraps
c0101e41:	e9 f4 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e46 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101e46:	6a 00                	push   $0x0
  pushl $56
c0101e48:	6a 38                	push   $0x38
  jmp __alltraps
c0101e4a:	e9 eb fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e4f <vector57>:
.globl vector57
vector57:
  pushl $0
c0101e4f:	6a 00                	push   $0x0
  pushl $57
c0101e51:	6a 39                	push   $0x39
  jmp __alltraps
c0101e53:	e9 e2 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e58 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101e58:	6a 00                	push   $0x0
  pushl $58
c0101e5a:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101e5c:	e9 d9 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e61 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101e61:	6a 00                	push   $0x0
  pushl $59
c0101e63:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101e65:	e9 d0 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e6a <vector60>:
.globl vector60
vector60:
  pushl $0
c0101e6a:	6a 00                	push   $0x0
  pushl $60
c0101e6c:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101e6e:	e9 c7 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e73 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101e73:	6a 00                	push   $0x0
  pushl $61
c0101e75:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101e77:	e9 be fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e7c <vector62>:
.globl vector62
vector62:
  pushl $0
c0101e7c:	6a 00                	push   $0x0
  pushl $62
c0101e7e:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101e80:	e9 b5 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e85 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101e85:	6a 00                	push   $0x0
  pushl $63
c0101e87:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101e89:	e9 ac fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e8e <vector64>:
.globl vector64
vector64:
  pushl $0
c0101e8e:	6a 00                	push   $0x0
  pushl $64
c0101e90:	6a 40                	push   $0x40
  jmp __alltraps
c0101e92:	e9 a3 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101e97 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101e97:	6a 00                	push   $0x0
  pushl $65
c0101e99:	6a 41                	push   $0x41
  jmp __alltraps
c0101e9b:	e9 9a fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ea0 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101ea0:	6a 00                	push   $0x0
  pushl $66
c0101ea2:	6a 42                	push   $0x42
  jmp __alltraps
c0101ea4:	e9 91 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ea9 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101ea9:	6a 00                	push   $0x0
  pushl $67
c0101eab:	6a 43                	push   $0x43
  jmp __alltraps
c0101ead:	e9 88 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101eb2 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101eb2:	6a 00                	push   $0x0
  pushl $68
c0101eb4:	6a 44                	push   $0x44
  jmp __alltraps
c0101eb6:	e9 7f fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ebb <vector69>:
.globl vector69
vector69:
  pushl $0
c0101ebb:	6a 00                	push   $0x0
  pushl $69
c0101ebd:	6a 45                	push   $0x45
  jmp __alltraps
c0101ebf:	e9 76 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ec4 <vector70>:
.globl vector70
vector70:
  pushl $0
c0101ec4:	6a 00                	push   $0x0
  pushl $70
c0101ec6:	6a 46                	push   $0x46
  jmp __alltraps
c0101ec8:	e9 6d fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ecd <vector71>:
.globl vector71
vector71:
  pushl $0
c0101ecd:	6a 00                	push   $0x0
  pushl $71
c0101ecf:	6a 47                	push   $0x47
  jmp __alltraps
c0101ed1:	e9 64 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ed6 <vector72>:
.globl vector72
vector72:
  pushl $0
c0101ed6:	6a 00                	push   $0x0
  pushl $72
c0101ed8:	6a 48                	push   $0x48
  jmp __alltraps
c0101eda:	e9 5b fd ff ff       	jmp    c0101c3a <__alltraps>

c0101edf <vector73>:
.globl vector73
vector73:
  pushl $0
c0101edf:	6a 00                	push   $0x0
  pushl $73
c0101ee1:	6a 49                	push   $0x49
  jmp __alltraps
c0101ee3:	e9 52 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ee8 <vector74>:
.globl vector74
vector74:
  pushl $0
c0101ee8:	6a 00                	push   $0x0
  pushl $74
c0101eea:	6a 4a                	push   $0x4a
  jmp __alltraps
c0101eec:	e9 49 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101ef1 <vector75>:
.globl vector75
vector75:
  pushl $0
c0101ef1:	6a 00                	push   $0x0
  pushl $75
c0101ef3:	6a 4b                	push   $0x4b
  jmp __alltraps
c0101ef5:	e9 40 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101efa <vector76>:
.globl vector76
vector76:
  pushl $0
c0101efa:	6a 00                	push   $0x0
  pushl $76
c0101efc:	6a 4c                	push   $0x4c
  jmp __alltraps
c0101efe:	e9 37 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f03 <vector77>:
.globl vector77
vector77:
  pushl $0
c0101f03:	6a 00                	push   $0x0
  pushl $77
c0101f05:	6a 4d                	push   $0x4d
  jmp __alltraps
c0101f07:	e9 2e fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f0c <vector78>:
.globl vector78
vector78:
  pushl $0
c0101f0c:	6a 00                	push   $0x0
  pushl $78
c0101f0e:	6a 4e                	push   $0x4e
  jmp __alltraps
c0101f10:	e9 25 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f15 <vector79>:
.globl vector79
vector79:
  pushl $0
c0101f15:	6a 00                	push   $0x0
  pushl $79
c0101f17:	6a 4f                	push   $0x4f
  jmp __alltraps
c0101f19:	e9 1c fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f1e <vector80>:
.globl vector80
vector80:
  pushl $0
c0101f1e:	6a 00                	push   $0x0
  pushl $80
c0101f20:	6a 50                	push   $0x50
  jmp __alltraps
c0101f22:	e9 13 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f27 <vector81>:
.globl vector81
vector81:
  pushl $0
c0101f27:	6a 00                	push   $0x0
  pushl $81
c0101f29:	6a 51                	push   $0x51
  jmp __alltraps
c0101f2b:	e9 0a fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f30 <vector82>:
.globl vector82
vector82:
  pushl $0
c0101f30:	6a 00                	push   $0x0
  pushl $82
c0101f32:	6a 52                	push   $0x52
  jmp __alltraps
c0101f34:	e9 01 fd ff ff       	jmp    c0101c3a <__alltraps>

c0101f39 <vector83>:
.globl vector83
vector83:
  pushl $0
c0101f39:	6a 00                	push   $0x0
  pushl $83
c0101f3b:	6a 53                	push   $0x53
  jmp __alltraps
c0101f3d:	e9 f8 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f42 <vector84>:
.globl vector84
vector84:
  pushl $0
c0101f42:	6a 00                	push   $0x0
  pushl $84
c0101f44:	6a 54                	push   $0x54
  jmp __alltraps
c0101f46:	e9 ef fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f4b <vector85>:
.globl vector85
vector85:
  pushl $0
c0101f4b:	6a 00                	push   $0x0
  pushl $85
c0101f4d:	6a 55                	push   $0x55
  jmp __alltraps
c0101f4f:	e9 e6 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f54 <vector86>:
.globl vector86
vector86:
  pushl $0
c0101f54:	6a 00                	push   $0x0
  pushl $86
c0101f56:	6a 56                	push   $0x56
  jmp __alltraps
c0101f58:	e9 dd fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f5d <vector87>:
.globl vector87
vector87:
  pushl $0
c0101f5d:	6a 00                	push   $0x0
  pushl $87
c0101f5f:	6a 57                	push   $0x57
  jmp __alltraps
c0101f61:	e9 d4 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f66 <vector88>:
.globl vector88
vector88:
  pushl $0
c0101f66:	6a 00                	push   $0x0
  pushl $88
c0101f68:	6a 58                	push   $0x58
  jmp __alltraps
c0101f6a:	e9 cb fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f6f <vector89>:
.globl vector89
vector89:
  pushl $0
c0101f6f:	6a 00                	push   $0x0
  pushl $89
c0101f71:	6a 59                	push   $0x59
  jmp __alltraps
c0101f73:	e9 c2 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f78 <vector90>:
.globl vector90
vector90:
  pushl $0
c0101f78:	6a 00                	push   $0x0
  pushl $90
c0101f7a:	6a 5a                	push   $0x5a
  jmp __alltraps
c0101f7c:	e9 b9 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f81 <vector91>:
.globl vector91
vector91:
  pushl $0
c0101f81:	6a 00                	push   $0x0
  pushl $91
c0101f83:	6a 5b                	push   $0x5b
  jmp __alltraps
c0101f85:	e9 b0 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f8a <vector92>:
.globl vector92
vector92:
  pushl $0
c0101f8a:	6a 00                	push   $0x0
  pushl $92
c0101f8c:	6a 5c                	push   $0x5c
  jmp __alltraps
c0101f8e:	e9 a7 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f93 <vector93>:
.globl vector93
vector93:
  pushl $0
c0101f93:	6a 00                	push   $0x0
  pushl $93
c0101f95:	6a 5d                	push   $0x5d
  jmp __alltraps
c0101f97:	e9 9e fc ff ff       	jmp    c0101c3a <__alltraps>

c0101f9c <vector94>:
.globl vector94
vector94:
  pushl $0
c0101f9c:	6a 00                	push   $0x0
  pushl $94
c0101f9e:	6a 5e                	push   $0x5e
  jmp __alltraps
c0101fa0:	e9 95 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fa5 <vector95>:
.globl vector95
vector95:
  pushl $0
c0101fa5:	6a 00                	push   $0x0
  pushl $95
c0101fa7:	6a 5f                	push   $0x5f
  jmp __alltraps
c0101fa9:	e9 8c fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fae <vector96>:
.globl vector96
vector96:
  pushl $0
c0101fae:	6a 00                	push   $0x0
  pushl $96
c0101fb0:	6a 60                	push   $0x60
  jmp __alltraps
c0101fb2:	e9 83 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fb7 <vector97>:
.globl vector97
vector97:
  pushl $0
c0101fb7:	6a 00                	push   $0x0
  pushl $97
c0101fb9:	6a 61                	push   $0x61
  jmp __alltraps
c0101fbb:	e9 7a fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fc0 <vector98>:
.globl vector98
vector98:
  pushl $0
c0101fc0:	6a 00                	push   $0x0
  pushl $98
c0101fc2:	6a 62                	push   $0x62
  jmp __alltraps
c0101fc4:	e9 71 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fc9 <vector99>:
.globl vector99
vector99:
  pushl $0
c0101fc9:	6a 00                	push   $0x0
  pushl $99
c0101fcb:	6a 63                	push   $0x63
  jmp __alltraps
c0101fcd:	e9 68 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fd2 <vector100>:
.globl vector100
vector100:
  pushl $0
c0101fd2:	6a 00                	push   $0x0
  pushl $100
c0101fd4:	6a 64                	push   $0x64
  jmp __alltraps
c0101fd6:	e9 5f fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fdb <vector101>:
.globl vector101
vector101:
  pushl $0
c0101fdb:	6a 00                	push   $0x0
  pushl $101
c0101fdd:	6a 65                	push   $0x65
  jmp __alltraps
c0101fdf:	e9 56 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fe4 <vector102>:
.globl vector102
vector102:
  pushl $0
c0101fe4:	6a 00                	push   $0x0
  pushl $102
c0101fe6:	6a 66                	push   $0x66
  jmp __alltraps
c0101fe8:	e9 4d fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fed <vector103>:
.globl vector103
vector103:
  pushl $0
c0101fed:	6a 00                	push   $0x0
  pushl $103
c0101fef:	6a 67                	push   $0x67
  jmp __alltraps
c0101ff1:	e9 44 fc ff ff       	jmp    c0101c3a <__alltraps>

c0101ff6 <vector104>:
.globl vector104
vector104:
  pushl $0
c0101ff6:	6a 00                	push   $0x0
  pushl $104
c0101ff8:	6a 68                	push   $0x68
  jmp __alltraps
c0101ffa:	e9 3b fc ff ff       	jmp    c0101c3a <__alltraps>

c0101fff <vector105>:
.globl vector105
vector105:
  pushl $0
c0101fff:	6a 00                	push   $0x0
  pushl $105
c0102001:	6a 69                	push   $0x69
  jmp __alltraps
c0102003:	e9 32 fc ff ff       	jmp    c0101c3a <__alltraps>

c0102008 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102008:	6a 00                	push   $0x0
  pushl $106
c010200a:	6a 6a                	push   $0x6a
  jmp __alltraps
c010200c:	e9 29 fc ff ff       	jmp    c0101c3a <__alltraps>

c0102011 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102011:	6a 00                	push   $0x0
  pushl $107
c0102013:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102015:	e9 20 fc ff ff       	jmp    c0101c3a <__alltraps>

c010201a <vector108>:
.globl vector108
vector108:
  pushl $0
c010201a:	6a 00                	push   $0x0
  pushl $108
c010201c:	6a 6c                	push   $0x6c
  jmp __alltraps
c010201e:	e9 17 fc ff ff       	jmp    c0101c3a <__alltraps>

c0102023 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102023:	6a 00                	push   $0x0
  pushl $109
c0102025:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102027:	e9 0e fc ff ff       	jmp    c0101c3a <__alltraps>

c010202c <vector110>:
.globl vector110
vector110:
  pushl $0
c010202c:	6a 00                	push   $0x0
  pushl $110
c010202e:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102030:	e9 05 fc ff ff       	jmp    c0101c3a <__alltraps>

c0102035 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $111
c0102037:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102039:	e9 fc fb ff ff       	jmp    c0101c3a <__alltraps>

c010203e <vector112>:
.globl vector112
vector112:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $112
c0102040:	6a 70                	push   $0x70
  jmp __alltraps
c0102042:	e9 f3 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102047 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $113
c0102049:	6a 71                	push   $0x71
  jmp __alltraps
c010204b:	e9 ea fb ff ff       	jmp    c0101c3a <__alltraps>

c0102050 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $114
c0102052:	6a 72                	push   $0x72
  jmp __alltraps
c0102054:	e9 e1 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102059 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $115
c010205b:	6a 73                	push   $0x73
  jmp __alltraps
c010205d:	e9 d8 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102062 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $116
c0102064:	6a 74                	push   $0x74
  jmp __alltraps
c0102066:	e9 cf fb ff ff       	jmp    c0101c3a <__alltraps>

c010206b <vector117>:
.globl vector117
vector117:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $117
c010206d:	6a 75                	push   $0x75
  jmp __alltraps
c010206f:	e9 c6 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102074 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $118
c0102076:	6a 76                	push   $0x76
  jmp __alltraps
c0102078:	e9 bd fb ff ff       	jmp    c0101c3a <__alltraps>

c010207d <vector119>:
.globl vector119
vector119:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $119
c010207f:	6a 77                	push   $0x77
  jmp __alltraps
c0102081:	e9 b4 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102086 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $120
c0102088:	6a 78                	push   $0x78
  jmp __alltraps
c010208a:	e9 ab fb ff ff       	jmp    c0101c3a <__alltraps>

c010208f <vector121>:
.globl vector121
vector121:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $121
c0102091:	6a 79                	push   $0x79
  jmp __alltraps
c0102093:	e9 a2 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102098 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $122
c010209a:	6a 7a                	push   $0x7a
  jmp __alltraps
c010209c:	e9 99 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020a1 <vector123>:
.globl vector123
vector123:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $123
c01020a3:	6a 7b                	push   $0x7b
  jmp __alltraps
c01020a5:	e9 90 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020aa <vector124>:
.globl vector124
vector124:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $124
c01020ac:	6a 7c                	push   $0x7c
  jmp __alltraps
c01020ae:	e9 87 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020b3 <vector125>:
.globl vector125
vector125:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $125
c01020b5:	6a 7d                	push   $0x7d
  jmp __alltraps
c01020b7:	e9 7e fb ff ff       	jmp    c0101c3a <__alltraps>

c01020bc <vector126>:
.globl vector126
vector126:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $126
c01020be:	6a 7e                	push   $0x7e
  jmp __alltraps
c01020c0:	e9 75 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020c5 <vector127>:
.globl vector127
vector127:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $127
c01020c7:	6a 7f                	push   $0x7f
  jmp __alltraps
c01020c9:	e9 6c fb ff ff       	jmp    c0101c3a <__alltraps>

c01020ce <vector128>:
.globl vector128
vector128:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $128
c01020d0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01020d5:	e9 60 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020da <vector129>:
.globl vector129
vector129:
  pushl $0
c01020da:	6a 00                	push   $0x0
  pushl $129
c01020dc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01020e1:	e9 54 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020e6 <vector130>:
.globl vector130
vector130:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $130
c01020e8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01020ed:	e9 48 fb ff ff       	jmp    c0101c3a <__alltraps>

c01020f2 <vector131>:
.globl vector131
vector131:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $131
c01020f4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01020f9:	e9 3c fb ff ff       	jmp    c0101c3a <__alltraps>

c01020fe <vector132>:
.globl vector132
vector132:
  pushl $0
c01020fe:	6a 00                	push   $0x0
  pushl $132
c0102100:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102105:	e9 30 fb ff ff       	jmp    c0101c3a <__alltraps>

c010210a <vector133>:
.globl vector133
vector133:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $133
c010210c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102111:	e9 24 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102116 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $134
c0102118:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010211d:	e9 18 fb ff ff       	jmp    c0101c3a <__alltraps>

c0102122 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102122:	6a 00                	push   $0x0
  pushl $135
c0102124:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102129:	e9 0c fb ff ff       	jmp    c0101c3a <__alltraps>

c010212e <vector136>:
.globl vector136
vector136:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $136
c0102130:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102135:	e9 00 fb ff ff       	jmp    c0101c3a <__alltraps>

c010213a <vector137>:
.globl vector137
vector137:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $137
c010213c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102141:	e9 f4 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102146 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102146:	6a 00                	push   $0x0
  pushl $138
c0102148:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010214d:	e9 e8 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102152 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $139
c0102154:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102159:	e9 dc fa ff ff       	jmp    c0101c3a <__alltraps>

c010215e <vector140>:
.globl vector140
vector140:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $140
c0102160:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102165:	e9 d0 fa ff ff       	jmp    c0101c3a <__alltraps>

c010216a <vector141>:
.globl vector141
vector141:
  pushl $0
c010216a:	6a 00                	push   $0x0
  pushl $141
c010216c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102171:	e9 c4 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102176 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $142
c0102178:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010217d:	e9 b8 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102182 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $143
c0102184:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102189:	e9 ac fa ff ff       	jmp    c0101c3a <__alltraps>

c010218e <vector144>:
.globl vector144
vector144:
  pushl $0
c010218e:	6a 00                	push   $0x0
  pushl $144
c0102190:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102195:	e9 a0 fa ff ff       	jmp    c0101c3a <__alltraps>

c010219a <vector145>:
.globl vector145
vector145:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $145
c010219c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01021a1:	e9 94 fa ff ff       	jmp    c0101c3a <__alltraps>

c01021a6 <vector146>:
.globl vector146
vector146:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $146
c01021a8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01021ad:	e9 88 fa ff ff       	jmp    c0101c3a <__alltraps>

c01021b2 <vector147>:
.globl vector147
vector147:
  pushl $0
c01021b2:	6a 00                	push   $0x0
  pushl $147
c01021b4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01021b9:	e9 7c fa ff ff       	jmp    c0101c3a <__alltraps>

c01021be <vector148>:
.globl vector148
vector148:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $148
c01021c0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01021c5:	e9 70 fa ff ff       	jmp    c0101c3a <__alltraps>

c01021ca <vector149>:
.globl vector149
vector149:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $149
c01021cc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01021d1:	e9 64 fa ff ff       	jmp    c0101c3a <__alltraps>

c01021d6 <vector150>:
.globl vector150
vector150:
  pushl $0
c01021d6:	6a 00                	push   $0x0
  pushl $150
c01021d8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01021dd:	e9 58 fa ff ff       	jmp    c0101c3a <__alltraps>

c01021e2 <vector151>:
.globl vector151
vector151:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $151
c01021e4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01021e9:	e9 4c fa ff ff       	jmp    c0101c3a <__alltraps>

c01021ee <vector152>:
.globl vector152
vector152:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $152
c01021f0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01021f5:	e9 40 fa ff ff       	jmp    c0101c3a <__alltraps>

c01021fa <vector153>:
.globl vector153
vector153:
  pushl $0
c01021fa:	6a 00                	push   $0x0
  pushl $153
c01021fc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102201:	e9 34 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102206 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $154
c0102208:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010220d:	e9 28 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102212 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $155
c0102214:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102219:	e9 1c fa ff ff       	jmp    c0101c3a <__alltraps>

c010221e <vector156>:
.globl vector156
vector156:
  pushl $0
c010221e:	6a 00                	push   $0x0
  pushl $156
c0102220:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102225:	e9 10 fa ff ff       	jmp    c0101c3a <__alltraps>

c010222a <vector157>:
.globl vector157
vector157:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $157
c010222c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102231:	e9 04 fa ff ff       	jmp    c0101c3a <__alltraps>

c0102236 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102236:	6a 00                	push   $0x0
  pushl $158
c0102238:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010223d:	e9 f8 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102242 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102242:	6a 00                	push   $0x0
  pushl $159
c0102244:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102249:	e9 ec f9 ff ff       	jmp    c0101c3a <__alltraps>

c010224e <vector160>:
.globl vector160
vector160:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $160
c0102250:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102255:	e9 e0 f9 ff ff       	jmp    c0101c3a <__alltraps>

c010225a <vector161>:
.globl vector161
vector161:
  pushl $0
c010225a:	6a 00                	push   $0x0
  pushl $161
c010225c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102261:	e9 d4 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102266 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102266:	6a 00                	push   $0x0
  pushl $162
c0102268:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010226d:	e9 c8 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102272 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $163
c0102274:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102279:	e9 bc f9 ff ff       	jmp    c0101c3a <__alltraps>

c010227e <vector164>:
.globl vector164
vector164:
  pushl $0
c010227e:	6a 00                	push   $0x0
  pushl $164
c0102280:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102285:	e9 b0 f9 ff ff       	jmp    c0101c3a <__alltraps>

c010228a <vector165>:
.globl vector165
vector165:
  pushl $0
c010228a:	6a 00                	push   $0x0
  pushl $165
c010228c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102291:	e9 a4 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102296 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $166
c0102298:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010229d:	e9 98 f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022a2 <vector167>:
.globl vector167
vector167:
  pushl $0
c01022a2:	6a 00                	push   $0x0
  pushl $167
c01022a4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01022a9:	e9 8c f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022ae <vector168>:
.globl vector168
vector168:
  pushl $0
c01022ae:	6a 00                	push   $0x0
  pushl $168
c01022b0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01022b5:	e9 80 f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022ba <vector169>:
.globl vector169
vector169:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $169
c01022bc:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01022c1:	e9 74 f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022c6 <vector170>:
.globl vector170
vector170:
  pushl $0
c01022c6:	6a 00                	push   $0x0
  pushl $170
c01022c8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01022cd:	e9 68 f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022d2 <vector171>:
.globl vector171
vector171:
  pushl $0
c01022d2:	6a 00                	push   $0x0
  pushl $171
c01022d4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01022d9:	e9 5c f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022de <vector172>:
.globl vector172
vector172:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $172
c01022e0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01022e5:	e9 50 f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022ea <vector173>:
.globl vector173
vector173:
  pushl $0
c01022ea:	6a 00                	push   $0x0
  pushl $173
c01022ec:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01022f1:	e9 44 f9 ff ff       	jmp    c0101c3a <__alltraps>

c01022f6 <vector174>:
.globl vector174
vector174:
  pushl $0
c01022f6:	6a 00                	push   $0x0
  pushl $174
c01022f8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01022fd:	e9 38 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102302 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $175
c0102304:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102309:	e9 2c f9 ff ff       	jmp    c0101c3a <__alltraps>

c010230e <vector176>:
.globl vector176
vector176:
  pushl $0
c010230e:	6a 00                	push   $0x0
  pushl $176
c0102310:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102315:	e9 20 f9 ff ff       	jmp    c0101c3a <__alltraps>

c010231a <vector177>:
.globl vector177
vector177:
  pushl $0
c010231a:	6a 00                	push   $0x0
  pushl $177
c010231c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102321:	e9 14 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102326 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $178
c0102328:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010232d:	e9 08 f9 ff ff       	jmp    c0101c3a <__alltraps>

c0102332 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102332:	6a 00                	push   $0x0
  pushl $179
c0102334:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102339:	e9 fc f8 ff ff       	jmp    c0101c3a <__alltraps>

c010233e <vector180>:
.globl vector180
vector180:
  pushl $0
c010233e:	6a 00                	push   $0x0
  pushl $180
c0102340:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102345:	e9 f0 f8 ff ff       	jmp    c0101c3a <__alltraps>

c010234a <vector181>:
.globl vector181
vector181:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $181
c010234c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102351:	e9 e4 f8 ff ff       	jmp    c0101c3a <__alltraps>

c0102356 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102356:	6a 00                	push   $0x0
  pushl $182
c0102358:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010235d:	e9 d8 f8 ff ff       	jmp    c0101c3a <__alltraps>

c0102362 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102362:	6a 00                	push   $0x0
  pushl $183
c0102364:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102369:	e9 cc f8 ff ff       	jmp    c0101c3a <__alltraps>

c010236e <vector184>:
.globl vector184
vector184:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $184
c0102370:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102375:	e9 c0 f8 ff ff       	jmp    c0101c3a <__alltraps>

c010237a <vector185>:
.globl vector185
vector185:
  pushl $0
c010237a:	6a 00                	push   $0x0
  pushl $185
c010237c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102381:	e9 b4 f8 ff ff       	jmp    c0101c3a <__alltraps>

c0102386 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102386:	6a 00                	push   $0x0
  pushl $186
c0102388:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010238d:	e9 a8 f8 ff ff       	jmp    c0101c3a <__alltraps>

c0102392 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $187
c0102394:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102399:	e9 9c f8 ff ff       	jmp    c0101c3a <__alltraps>

c010239e <vector188>:
.globl vector188
vector188:
  pushl $0
c010239e:	6a 00                	push   $0x0
  pushl $188
c01023a0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01023a5:	e9 90 f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023aa <vector189>:
.globl vector189
vector189:
  pushl $0
c01023aa:	6a 00                	push   $0x0
  pushl $189
c01023ac:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01023b1:	e9 84 f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023b6 <vector190>:
.globl vector190
vector190:
  pushl $0
c01023b6:	6a 00                	push   $0x0
  pushl $190
c01023b8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01023bd:	e9 78 f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023c2 <vector191>:
.globl vector191
vector191:
  pushl $0
c01023c2:	6a 00                	push   $0x0
  pushl $191
c01023c4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01023c9:	e9 6c f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023ce <vector192>:
.globl vector192
vector192:
  pushl $0
c01023ce:	6a 00                	push   $0x0
  pushl $192
c01023d0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01023d5:	e9 60 f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023da <vector193>:
.globl vector193
vector193:
  pushl $0
c01023da:	6a 00                	push   $0x0
  pushl $193
c01023dc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01023e1:	e9 54 f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023e6 <vector194>:
.globl vector194
vector194:
  pushl $0
c01023e6:	6a 00                	push   $0x0
  pushl $194
c01023e8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01023ed:	e9 48 f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023f2 <vector195>:
.globl vector195
vector195:
  pushl $0
c01023f2:	6a 00                	push   $0x0
  pushl $195
c01023f4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01023f9:	e9 3c f8 ff ff       	jmp    c0101c3a <__alltraps>

c01023fe <vector196>:
.globl vector196
vector196:
  pushl $0
c01023fe:	6a 00                	push   $0x0
  pushl $196
c0102400:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102405:	e9 30 f8 ff ff       	jmp    c0101c3a <__alltraps>

c010240a <vector197>:
.globl vector197
vector197:
  pushl $0
c010240a:	6a 00                	push   $0x0
  pushl $197
c010240c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102411:	e9 24 f8 ff ff       	jmp    c0101c3a <__alltraps>

c0102416 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102416:	6a 00                	push   $0x0
  pushl $198
c0102418:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010241d:	e9 18 f8 ff ff       	jmp    c0101c3a <__alltraps>

c0102422 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102422:	6a 00                	push   $0x0
  pushl $199
c0102424:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102429:	e9 0c f8 ff ff       	jmp    c0101c3a <__alltraps>

c010242e <vector200>:
.globl vector200
vector200:
  pushl $0
c010242e:	6a 00                	push   $0x0
  pushl $200
c0102430:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102435:	e9 00 f8 ff ff       	jmp    c0101c3a <__alltraps>

c010243a <vector201>:
.globl vector201
vector201:
  pushl $0
c010243a:	6a 00                	push   $0x0
  pushl $201
c010243c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102441:	e9 f4 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102446 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102446:	6a 00                	push   $0x0
  pushl $202
c0102448:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010244d:	e9 e8 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102452 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102452:	6a 00                	push   $0x0
  pushl $203
c0102454:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102459:	e9 dc f7 ff ff       	jmp    c0101c3a <__alltraps>

c010245e <vector204>:
.globl vector204
vector204:
  pushl $0
c010245e:	6a 00                	push   $0x0
  pushl $204
c0102460:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102465:	e9 d0 f7 ff ff       	jmp    c0101c3a <__alltraps>

c010246a <vector205>:
.globl vector205
vector205:
  pushl $0
c010246a:	6a 00                	push   $0x0
  pushl $205
c010246c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102471:	e9 c4 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102476 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102476:	6a 00                	push   $0x0
  pushl $206
c0102478:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010247d:	e9 b8 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102482 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102482:	6a 00                	push   $0x0
  pushl $207
c0102484:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102489:	e9 ac f7 ff ff       	jmp    c0101c3a <__alltraps>

c010248e <vector208>:
.globl vector208
vector208:
  pushl $0
c010248e:	6a 00                	push   $0x0
  pushl $208
c0102490:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102495:	e9 a0 f7 ff ff       	jmp    c0101c3a <__alltraps>

c010249a <vector209>:
.globl vector209
vector209:
  pushl $0
c010249a:	6a 00                	push   $0x0
  pushl $209
c010249c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01024a1:	e9 94 f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024a6 <vector210>:
.globl vector210
vector210:
  pushl $0
c01024a6:	6a 00                	push   $0x0
  pushl $210
c01024a8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01024ad:	e9 88 f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024b2 <vector211>:
.globl vector211
vector211:
  pushl $0
c01024b2:	6a 00                	push   $0x0
  pushl $211
c01024b4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01024b9:	e9 7c f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024be <vector212>:
.globl vector212
vector212:
  pushl $0
c01024be:	6a 00                	push   $0x0
  pushl $212
c01024c0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01024c5:	e9 70 f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024ca <vector213>:
.globl vector213
vector213:
  pushl $0
c01024ca:	6a 00                	push   $0x0
  pushl $213
c01024cc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01024d1:	e9 64 f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024d6 <vector214>:
.globl vector214
vector214:
  pushl $0
c01024d6:	6a 00                	push   $0x0
  pushl $214
c01024d8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01024dd:	e9 58 f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024e2 <vector215>:
.globl vector215
vector215:
  pushl $0
c01024e2:	6a 00                	push   $0x0
  pushl $215
c01024e4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01024e9:	e9 4c f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024ee <vector216>:
.globl vector216
vector216:
  pushl $0
c01024ee:	6a 00                	push   $0x0
  pushl $216
c01024f0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01024f5:	e9 40 f7 ff ff       	jmp    c0101c3a <__alltraps>

c01024fa <vector217>:
.globl vector217
vector217:
  pushl $0
c01024fa:	6a 00                	push   $0x0
  pushl $217
c01024fc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102501:	e9 34 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102506 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102506:	6a 00                	push   $0x0
  pushl $218
c0102508:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010250d:	e9 28 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102512 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102512:	6a 00                	push   $0x0
  pushl $219
c0102514:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102519:	e9 1c f7 ff ff       	jmp    c0101c3a <__alltraps>

c010251e <vector220>:
.globl vector220
vector220:
  pushl $0
c010251e:	6a 00                	push   $0x0
  pushl $220
c0102520:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102525:	e9 10 f7 ff ff       	jmp    c0101c3a <__alltraps>

c010252a <vector221>:
.globl vector221
vector221:
  pushl $0
c010252a:	6a 00                	push   $0x0
  pushl $221
c010252c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102531:	e9 04 f7 ff ff       	jmp    c0101c3a <__alltraps>

c0102536 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102536:	6a 00                	push   $0x0
  pushl $222
c0102538:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010253d:	e9 f8 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102542 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102542:	6a 00                	push   $0x0
  pushl $223
c0102544:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102549:	e9 ec f6 ff ff       	jmp    c0101c3a <__alltraps>

c010254e <vector224>:
.globl vector224
vector224:
  pushl $0
c010254e:	6a 00                	push   $0x0
  pushl $224
c0102550:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102555:	e9 e0 f6 ff ff       	jmp    c0101c3a <__alltraps>

c010255a <vector225>:
.globl vector225
vector225:
  pushl $0
c010255a:	6a 00                	push   $0x0
  pushl $225
c010255c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102561:	e9 d4 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102566 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102566:	6a 00                	push   $0x0
  pushl $226
c0102568:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010256d:	e9 c8 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102572 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102572:	6a 00                	push   $0x0
  pushl $227
c0102574:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0102579:	e9 bc f6 ff ff       	jmp    c0101c3a <__alltraps>

c010257e <vector228>:
.globl vector228
vector228:
  pushl $0
c010257e:	6a 00                	push   $0x0
  pushl $228
c0102580:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102585:	e9 b0 f6 ff ff       	jmp    c0101c3a <__alltraps>

c010258a <vector229>:
.globl vector229
vector229:
  pushl $0
c010258a:	6a 00                	push   $0x0
  pushl $229
c010258c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102591:	e9 a4 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102596 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102596:	6a 00                	push   $0x0
  pushl $230
c0102598:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010259d:	e9 98 f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025a2 <vector231>:
.globl vector231
vector231:
  pushl $0
c01025a2:	6a 00                	push   $0x0
  pushl $231
c01025a4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01025a9:	e9 8c f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025ae <vector232>:
.globl vector232
vector232:
  pushl $0
c01025ae:	6a 00                	push   $0x0
  pushl $232
c01025b0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01025b5:	e9 80 f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025ba <vector233>:
.globl vector233
vector233:
  pushl $0
c01025ba:	6a 00                	push   $0x0
  pushl $233
c01025bc:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01025c1:	e9 74 f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025c6 <vector234>:
.globl vector234
vector234:
  pushl $0
c01025c6:	6a 00                	push   $0x0
  pushl $234
c01025c8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01025cd:	e9 68 f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025d2 <vector235>:
.globl vector235
vector235:
  pushl $0
c01025d2:	6a 00                	push   $0x0
  pushl $235
c01025d4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01025d9:	e9 5c f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025de <vector236>:
.globl vector236
vector236:
  pushl $0
c01025de:	6a 00                	push   $0x0
  pushl $236
c01025e0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01025e5:	e9 50 f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025ea <vector237>:
.globl vector237
vector237:
  pushl $0
c01025ea:	6a 00                	push   $0x0
  pushl $237
c01025ec:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01025f1:	e9 44 f6 ff ff       	jmp    c0101c3a <__alltraps>

c01025f6 <vector238>:
.globl vector238
vector238:
  pushl $0
c01025f6:	6a 00                	push   $0x0
  pushl $238
c01025f8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01025fd:	e9 38 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102602 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102602:	6a 00                	push   $0x0
  pushl $239
c0102604:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102609:	e9 2c f6 ff ff       	jmp    c0101c3a <__alltraps>

c010260e <vector240>:
.globl vector240
vector240:
  pushl $0
c010260e:	6a 00                	push   $0x0
  pushl $240
c0102610:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102615:	e9 20 f6 ff ff       	jmp    c0101c3a <__alltraps>

c010261a <vector241>:
.globl vector241
vector241:
  pushl $0
c010261a:	6a 00                	push   $0x0
  pushl $241
c010261c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102621:	e9 14 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102626 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102626:	6a 00                	push   $0x0
  pushl $242
c0102628:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010262d:	e9 08 f6 ff ff       	jmp    c0101c3a <__alltraps>

c0102632 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102632:	6a 00                	push   $0x0
  pushl $243
c0102634:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102639:	e9 fc f5 ff ff       	jmp    c0101c3a <__alltraps>

c010263e <vector244>:
.globl vector244
vector244:
  pushl $0
c010263e:	6a 00                	push   $0x0
  pushl $244
c0102640:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102645:	e9 f0 f5 ff ff       	jmp    c0101c3a <__alltraps>

c010264a <vector245>:
.globl vector245
vector245:
  pushl $0
c010264a:	6a 00                	push   $0x0
  pushl $245
c010264c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102651:	e9 e4 f5 ff ff       	jmp    c0101c3a <__alltraps>

c0102656 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102656:	6a 00                	push   $0x0
  pushl $246
c0102658:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010265d:	e9 d8 f5 ff ff       	jmp    c0101c3a <__alltraps>

c0102662 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102662:	6a 00                	push   $0x0
  pushl $247
c0102664:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102669:	e9 cc f5 ff ff       	jmp    c0101c3a <__alltraps>

c010266e <vector248>:
.globl vector248
vector248:
  pushl $0
c010266e:	6a 00                	push   $0x0
  pushl $248
c0102670:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102675:	e9 c0 f5 ff ff       	jmp    c0101c3a <__alltraps>

c010267a <vector249>:
.globl vector249
vector249:
  pushl $0
c010267a:	6a 00                	push   $0x0
  pushl $249
c010267c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102681:	e9 b4 f5 ff ff       	jmp    c0101c3a <__alltraps>

c0102686 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102686:	6a 00                	push   $0x0
  pushl $250
c0102688:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010268d:	e9 a8 f5 ff ff       	jmp    c0101c3a <__alltraps>

c0102692 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102692:	6a 00                	push   $0x0
  pushl $251
c0102694:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102699:	e9 9c f5 ff ff       	jmp    c0101c3a <__alltraps>

c010269e <vector252>:
.globl vector252
vector252:
  pushl $0
c010269e:	6a 00                	push   $0x0
  pushl $252
c01026a0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01026a5:	e9 90 f5 ff ff       	jmp    c0101c3a <__alltraps>

c01026aa <vector253>:
.globl vector253
vector253:
  pushl $0
c01026aa:	6a 00                	push   $0x0
  pushl $253
c01026ac:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01026b1:	e9 84 f5 ff ff       	jmp    c0101c3a <__alltraps>

c01026b6 <vector254>:
.globl vector254
vector254:
  pushl $0
c01026b6:	6a 00                	push   $0x0
  pushl $254
c01026b8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01026bd:	e9 78 f5 ff ff       	jmp    c0101c3a <__alltraps>

c01026c2 <vector255>:
.globl vector255
vector255:
  pushl $0
c01026c2:	6a 00                	push   $0x0
  pushl $255
c01026c4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01026c9:	e9 6c f5 ff ff       	jmp    c0101c3a <__alltraps>

c01026ce <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01026ce:	55                   	push   %ebp
c01026cf:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01026d1:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c01026d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01026da:	29 d0                	sub    %edx,%eax
c01026dc:	c1 f8 02             	sar    $0x2,%eax
c01026df:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01026e5:	5d                   	pop    %ebp
c01026e6:	c3                   	ret    

c01026e7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01026e7:	55                   	push   %ebp
c01026e8:	89 e5                	mov    %esp,%ebp
c01026ea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01026ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f0:	89 04 24             	mov    %eax,(%esp)
c01026f3:	e8 d6 ff ff ff       	call   c01026ce <page2ppn>
c01026f8:	c1 e0 0c             	shl    $0xc,%eax
}
c01026fb:	89 ec                	mov    %ebp,%esp
c01026fd:	5d                   	pop    %ebp
c01026fe:	c3                   	ret    

c01026ff <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01026ff:	55                   	push   %ebp
c0102700:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102702:	8b 45 08             	mov    0x8(%ebp),%eax
c0102705:	8b 00                	mov    (%eax),%eax
}
c0102707:	5d                   	pop    %ebp
c0102708:	c3                   	ret    

c0102709 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102709:	55                   	push   %ebp
c010270a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010270c:	8b 45 08             	mov    0x8(%ebp),%eax
c010270f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102712:	89 10                	mov    %edx,(%eax)
}
c0102714:	90                   	nop
c0102715:	5d                   	pop    %ebp
c0102716:	c3                   	ret    

c0102717 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102717:	55                   	push   %ebp
c0102718:	89 e5                	mov    %esp,%ebp
c010271a:	83 ec 10             	sub    $0x10,%esp
c010271d:	c7 45 fc 80 be 11 c0 	movl   $0xc011be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102724:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102727:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010272a:	89 50 04             	mov    %edx,0x4(%eax)
c010272d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102730:	8b 50 04             	mov    0x4(%eax),%edx
c0102733:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102736:	89 10                	mov    %edx,(%eax)
}
c0102738:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
c0102739:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102740:	00 00 00 
}
c0102743:	90                   	nop
c0102744:	89 ec                	mov    %ebp,%esp
c0102746:	5d                   	pop    %ebp
c0102747:	c3                   	ret    

c0102748 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102748:	55                   	push   %ebp
c0102749:	89 e5                	mov    %esp,%ebp
c010274b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010274e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102752:	75 24                	jne    c0102778 <default_init_memmap+0x30>
c0102754:	c7 44 24 0c 10 63 10 	movl   $0xc0106310,0xc(%esp)
c010275b:	c0 
c010275c:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102763:	c0 
c0102764:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c010276b:	00 
c010276c:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102773:	e8 ab e4 ff ff       	call   c0100c23 <__panic>
    struct Page *p = base;
c0102778:	8b 45 08             	mov    0x8(%ebp),%eax
c010277b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010277e:	eb 7d                	jmp    c01027fd <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102783:	83 c0 04             	add    $0x4,%eax
c0102786:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010278d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102790:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102793:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102796:	0f a3 10             	bt     %edx,(%eax)
c0102799:	19 c0                	sbb    %eax,%eax
c010279b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010279e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01027a2:	0f 95 c0             	setne  %al
c01027a5:	0f b6 c0             	movzbl %al,%eax
c01027a8:	85 c0                	test   %eax,%eax
c01027aa:	75 24                	jne    c01027d0 <default_init_memmap+0x88>
c01027ac:	c7 44 24 0c 41 63 10 	movl   $0xc0106341,0xc(%esp)
c01027b3:	c0 
c01027b4:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01027bb:	c0 
c01027bc:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c01027c3:	00 
c01027c4:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01027cb:	e8 53 e4 ff ff       	call   c0100c23 <__panic>
        p->flags = p->property = 0;
c01027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027dd:	8b 50 08             	mov    0x8(%eax),%edx
c01027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027e3:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01027e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01027ed:	00 
c01027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01027f1:	89 04 24             	mov    %eax,(%esp)
c01027f4:	e8 10 ff ff ff       	call   c0102709 <set_page_ref>
    for (; p != base + n; p ++) {
c01027f9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01027fd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102800:	89 d0                	mov    %edx,%eax
c0102802:	c1 e0 02             	shl    $0x2,%eax
c0102805:	01 d0                	add    %edx,%eax
c0102807:	c1 e0 02             	shl    $0x2,%eax
c010280a:	89 c2                	mov    %eax,%edx
c010280c:	8b 45 08             	mov    0x8(%ebp),%eax
c010280f:	01 d0                	add    %edx,%eax
c0102811:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102814:	0f 85 66 ff ff ff    	jne    c0102780 <default_init_memmap+0x38>
    }
    base->property = n;
c010281a:	8b 45 08             	mov    0x8(%ebp),%eax
c010281d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102820:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102823:	8b 45 08             	mov    0x8(%ebp),%eax
c0102826:	83 c0 04             	add    $0x4,%eax
c0102829:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102830:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102833:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102836:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102839:	0f ab 10             	bts    %edx,(%eax)
}
c010283c:	90                   	nop
    nr_free += n;
c010283d:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102843:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102846:	01 d0                	add    %edx,%eax
c0102848:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add(&free_list, &(base->page_link));
c010284d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102850:	83 c0 0c             	add    $0xc,%eax
c0102853:	c7 45 e4 80 be 11 c0 	movl   $0xc011be80,-0x1c(%ebp)
c010285a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010285d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102860:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102863:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102866:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102869:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010286c:	8b 40 04             	mov    0x4(%eax),%eax
c010286f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102872:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102875:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102878:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010287b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010287e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102881:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102884:	89 10                	mov    %edx,(%eax)
c0102886:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102889:	8b 10                	mov    (%eax),%edx
c010288b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010288e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102894:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102897:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010289a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010289d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01028a0:	89 10                	mov    %edx,(%eax)
}
c01028a2:	90                   	nop
}
c01028a3:	90                   	nop
}
c01028a4:	90                   	nop
}
c01028a5:	90                   	nop
c01028a6:	89 ec                	mov    %ebp,%esp
c01028a8:	5d                   	pop    %ebp
c01028a9:	c3                   	ret    

c01028aa <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01028aa:	55                   	push   %ebp
c01028ab:	89 e5                	mov    %esp,%ebp
c01028ad:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01028b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01028b4:	75 24                	jne    c01028da <default_alloc_pages+0x30>
c01028b6:	c7 44 24 0c 10 63 10 	movl   $0xc0106310,0xc(%esp)
c01028bd:	c0 
c01028be:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01028c5:	c0 
c01028c6:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c01028cd:	00 
c01028ce:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01028d5:	e8 49 e3 ff ff       	call   c0100c23 <__panic>
    if (n > nr_free) {
c01028da:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01028df:	39 45 08             	cmp    %eax,0x8(%ebp)
c01028e2:	76 0a                	jbe    c01028ee <default_alloc_pages+0x44>
        return NULL;
c01028e4:	b8 00 00 00 00       	mov    $0x0,%eax
c01028e9:	e9 34 01 00 00       	jmp    c0102a22 <default_alloc_pages+0x178>
    }
    struct Page *page = NULL;
c01028ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01028f5:	c7 45 f0 80 be 11 c0 	movl   $0xc011be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01028fc:	eb 1c                	jmp    c010291a <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01028fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102901:	83 e8 0c             	sub    $0xc,%eax
c0102904:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102907:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010290a:	8b 40 08             	mov    0x8(%eax),%eax
c010290d:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102910:	77 08                	ja     c010291a <default_alloc_pages+0x70>
            page = p;
c0102912:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102915:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102918:	eb 18                	jmp    c0102932 <default_alloc_pages+0x88>
c010291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010291d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0102920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102923:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0102926:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102929:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102930:	75 cc                	jne    c01028fe <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0102932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102936:	0f 84 e3 00 00 00    	je     c0102a1f <default_alloc_pages+0x175>
        list_del(&(page->page_link));
c010293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293f:	83 c0 0c             	add    $0xc,%eax
c0102942:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102945:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102948:	8b 40 04             	mov    0x4(%eax),%eax
c010294b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010294e:	8b 12                	mov    (%edx),%edx
c0102950:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102953:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102956:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102959:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010295c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010295f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102962:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102965:	89 10                	mov    %edx,(%eax)
}
c0102967:	90                   	nop
}
c0102968:	90                   	nop
        if (page->property > n) {
c0102969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010296c:	8b 40 08             	mov    0x8(%eax),%eax
c010296f:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102972:	0f 83 80 00 00 00    	jae    c01029f8 <default_alloc_pages+0x14e>
            struct Page *p = page + n;
c0102978:	8b 55 08             	mov    0x8(%ebp),%edx
c010297b:	89 d0                	mov    %edx,%eax
c010297d:	c1 e0 02             	shl    $0x2,%eax
c0102980:	01 d0                	add    %edx,%eax
c0102982:	c1 e0 02             	shl    $0x2,%eax
c0102985:	89 c2                	mov    %eax,%edx
c0102987:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010298a:	01 d0                	add    %edx,%eax
c010298c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102992:	8b 40 08             	mov    0x8(%eax),%eax
c0102995:	2b 45 08             	sub    0x8(%ebp),%eax
c0102998:	89 c2                	mov    %eax,%edx
c010299a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010299d:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c01029a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029a3:	83 c0 0c             	add    $0xc,%eax
c01029a6:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
c01029ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01029b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c01029bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01029bf:	8b 40 04             	mov    0x4(%eax),%eax
c01029c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01029c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c01029c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029cb:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01029ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c01029d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01029d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01029d7:	89 10                	mov    %edx,(%eax)
c01029d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01029dc:	8b 10                	mov    (%eax),%edx
c01029de:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01029e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01029e7:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01029ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01029f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01029f3:	89 10                	mov    %edx,(%eax)
}
c01029f5:	90                   	nop
}
c01029f6:	90                   	nop
}
c01029f7:	90                   	nop
    }
        nr_free -= n;
c01029f8:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01029fd:	2b 45 08             	sub    0x8(%ebp),%eax
c0102a00:	a3 88 be 11 c0       	mov    %eax,0xc011be88
        ClearPageProperty(page);
c0102a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a08:	83 c0 04             	add    $0x4,%eax
c0102a0b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102a12:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a15:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102a18:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102a1b:	0f b3 10             	btr    %edx,(%eax)
}
c0102a1e:	90                   	nop
    }
    return page;
c0102a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102a22:	89 ec                	mov    %ebp,%esp
c0102a24:	5d                   	pop    %ebp
c0102a25:	c3                   	ret    

c0102a26 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102a26:	55                   	push   %ebp
c0102a27:	89 e5                	mov    %esp,%ebp
c0102a29:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102a2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102a33:	75 24                	jne    c0102a59 <default_free_pages+0x33>
c0102a35:	c7 44 24 0c 10 63 10 	movl   $0xc0106310,0xc(%esp)
c0102a3c:	c0 
c0102a3d:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102a44:	c0 
c0102a45:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102a4c:	00 
c0102a4d:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102a54:	e8 ca e1 ff ff       	call   c0100c23 <__panic>
    struct Page *p = base;
c0102a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102a5f:	e9 9d 00 00 00       	jmp    c0102b01 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a67:	83 c0 04             	add    $0x4,%eax
c0102a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102a71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102a74:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102a77:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102a7a:	0f a3 10             	bt     %edx,(%eax)
c0102a7d:	19 c0                	sbb    %eax,%eax
c0102a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102a82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102a86:	0f 95 c0             	setne  %al
c0102a89:	0f b6 c0             	movzbl %al,%eax
c0102a8c:	85 c0                	test   %eax,%eax
c0102a8e:	75 2c                	jne    c0102abc <default_free_pages+0x96>
c0102a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a93:	83 c0 04             	add    $0x4,%eax
c0102a96:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102a9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102aa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102aa6:	0f a3 10             	bt     %edx,(%eax)
c0102aa9:	19 c0                	sbb    %eax,%eax
c0102aab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102aae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102ab2:	0f 95 c0             	setne  %al
c0102ab5:	0f b6 c0             	movzbl %al,%eax
c0102ab8:	85 c0                	test   %eax,%eax
c0102aba:	74 24                	je     c0102ae0 <default_free_pages+0xba>
c0102abc:	c7 44 24 0c 54 63 10 	movl   $0xc0106354,0xc(%esp)
c0102ac3:	c0 
c0102ac4:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102acb:	c0 
c0102acc:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102ad3:	00 
c0102ad4:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102adb:	e8 43 e1 ff ff       	call   c0100c23 <__panic>
        p->flags = 0;
c0102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ae3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102aea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102af1:	00 
c0102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af5:	89 04 24             	mov    %eax,(%esp)
c0102af8:	e8 0c fc ff ff       	call   c0102709 <set_page_ref>
    for (; p != base + n; p ++) {
c0102afd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102b01:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b04:	89 d0                	mov    %edx,%eax
c0102b06:	c1 e0 02             	shl    $0x2,%eax
c0102b09:	01 d0                	add    %edx,%eax
c0102b0b:	c1 e0 02             	shl    $0x2,%eax
c0102b0e:	89 c2                	mov    %eax,%edx
c0102b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b13:	01 d0                	add    %edx,%eax
c0102b15:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102b18:	0f 85 46 ff ff ff    	jne    c0102a64 <default_free_pages+0x3e>
    }
    base->property = n;
c0102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b21:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b24:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102b27:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b2a:	83 c0 04             	add    $0x4,%eax
c0102b2d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102b34:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b37:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b3a:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b3d:	0f ab 10             	bts    %edx,(%eax)
}
c0102b40:	90                   	nop
c0102b41:	c7 45 d4 80 be 11 c0 	movl   $0xc011be80,-0x2c(%ebp)
    return listelm->next;
c0102b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b4b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102b51:	e9 0e 01 00 00       	jmp    c0102c64 <default_free_pages+0x23e>
        p = le2page(le, page_link);
c0102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b59:	83 e8 0c             	sub    $0xc,%eax
c0102b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b62:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102b65:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b68:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b71:	8b 50 08             	mov    0x8(%eax),%edx
c0102b74:	89 d0                	mov    %edx,%eax
c0102b76:	c1 e0 02             	shl    $0x2,%eax
c0102b79:	01 d0                	add    %edx,%eax
c0102b7b:	c1 e0 02             	shl    $0x2,%eax
c0102b7e:	89 c2                	mov    %eax,%edx
c0102b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b83:	01 d0                	add    %edx,%eax
c0102b85:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0102b88:	75 5d                	jne    c0102be7 <default_free_pages+0x1c1>
            base->property += p->property;
c0102b8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b8d:	8b 50 08             	mov    0x8(%eax),%edx
c0102b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b93:	8b 40 08             	mov    0x8(%eax),%eax
c0102b96:	01 c2                	add    %eax,%edx
c0102b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b9b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba1:	83 c0 04             	add    $0x4,%eax
c0102ba4:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102bab:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bb1:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bb4:	0f b3 10             	btr    %edx,(%eax)
}
c0102bb7:	90                   	nop
            list_del(&(p->page_link));
c0102bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bbb:	83 c0 0c             	add    $0xc,%eax
c0102bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102bc1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bc4:	8b 40 04             	mov    0x4(%eax),%eax
c0102bc7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102bca:	8b 12                	mov    (%edx),%edx
c0102bcc:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102bcf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0102bd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102bd5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102bd8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102bdb:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102bde:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102be1:	89 10                	mov    %edx,(%eax)
}
c0102be3:	90                   	nop
}
c0102be4:	90                   	nop
c0102be5:	eb 7d                	jmp    c0102c64 <default_free_pages+0x23e>
        }
        else if (p + p->property == base) {
c0102be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bea:	8b 50 08             	mov    0x8(%eax),%edx
c0102bed:	89 d0                	mov    %edx,%eax
c0102bef:	c1 e0 02             	shl    $0x2,%eax
c0102bf2:	01 d0                	add    %edx,%eax
c0102bf4:	c1 e0 02             	shl    $0x2,%eax
c0102bf7:	89 c2                	mov    %eax,%edx
c0102bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bfc:	01 d0                	add    %edx,%eax
c0102bfe:	39 45 08             	cmp    %eax,0x8(%ebp)
c0102c01:	75 61                	jne    c0102c64 <default_free_pages+0x23e>
            p->property += base->property;
c0102c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c06:	8b 50 08             	mov    0x8(%eax),%edx
c0102c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c0c:	8b 40 08             	mov    0x8(%eax),%eax
c0102c0f:	01 c2                	add    %eax,%edx
c0102c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c14:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102c17:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c1a:	83 c0 04             	add    $0x4,%eax
c0102c1d:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0102c24:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c27:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102c2a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102c2d:	0f b3 10             	btr    %edx,(%eax)
}
c0102c30:	90                   	nop
            base = p;
c0102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c34:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c3a:	83 c0 0c             	add    $0xc,%eax
c0102c3d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0102c40:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c43:	8b 40 04             	mov    0x4(%eax),%eax
c0102c46:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102c49:	8b 12                	mov    (%edx),%edx
c0102c4b:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102c4e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0102c51:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102c54:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102c57:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102c5a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102c5d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102c60:	89 10                	mov    %edx,(%eax)
}
c0102c62:	90                   	nop
}
c0102c63:	90                   	nop
    while (le != &free_list) {
c0102c64:	81 7d f0 80 be 11 c0 	cmpl   $0xc011be80,-0x10(%ebp)
c0102c6b:	0f 85 e5 fe ff ff    	jne    c0102b56 <default_free_pages+0x130>
        }
    }
    nr_free += n;
c0102c71:	8b 15 88 be 11 c0    	mov    0xc011be88,%edx
c0102c77:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102c7a:	01 d0                	add    %edx,%eax
c0102c7c:	a3 88 be 11 c0       	mov    %eax,0xc011be88
    list_add(&free_list, &(base->page_link));
c0102c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c84:	83 c0 0c             	add    $0xc,%eax
c0102c87:	c7 45 9c 80 be 11 c0 	movl   $0xc011be80,-0x64(%ebp)
c0102c8e:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102c91:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102c94:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102c97:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102c9a:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
c0102c9d:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102ca0:	8b 40 04             	mov    0x4(%eax),%eax
c0102ca3:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102ca6:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102ca9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102cac:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102caf:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
c0102cb2:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102cb5:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102cb8:	89 10                	mov    %edx,(%eax)
c0102cba:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102cbd:	8b 10                	mov    (%eax),%edx
c0102cbf:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102cc2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cc5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102cc8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102ccb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cce:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102cd1:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102cd4:	89 10                	mov    %edx,(%eax)
}
c0102cd6:	90                   	nop
}
c0102cd7:	90                   	nop
}
c0102cd8:	90                   	nop
}
c0102cd9:	90                   	nop
c0102cda:	89 ec                	mov    %ebp,%esp
c0102cdc:	5d                   	pop    %ebp
c0102cdd:	c3                   	ret    

c0102cde <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102cde:	55                   	push   %ebp
c0102cdf:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102ce1:	a1 88 be 11 c0       	mov    0xc011be88,%eax
}
c0102ce6:	5d                   	pop    %ebp
c0102ce7:	c3                   	ret    

c0102ce8 <basic_check>:

static void
basic_check(void) {
c0102ce8:	55                   	push   %ebp
c0102ce9:	89 e5                	mov    %esp,%ebp
c0102ceb:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102d01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d08:	e8 df 0e 00 00       	call   c0103bec <alloc_pages>
c0102d0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102d10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102d14:	75 24                	jne    c0102d3a <basic_check+0x52>
c0102d16:	c7 44 24 0c 79 63 10 	movl   $0xc0106379,0xc(%esp)
c0102d1d:	c0 
c0102d1e:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102d25:	c0 
c0102d26:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0102d2d:	00 
c0102d2e:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102d35:	e8 e9 de ff ff       	call   c0100c23 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102d3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d41:	e8 a6 0e 00 00       	call   c0103bec <alloc_pages>
c0102d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102d4d:	75 24                	jne    c0102d73 <basic_check+0x8b>
c0102d4f:	c7 44 24 0c 95 63 10 	movl   $0xc0106395,0xc(%esp)
c0102d56:	c0 
c0102d57:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102d5e:	c0 
c0102d5f:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0102d66:	00 
c0102d67:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102d6e:	e8 b0 de ff ff       	call   c0100c23 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102d73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d7a:	e8 6d 0e 00 00       	call   c0103bec <alloc_pages>
c0102d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102d86:	75 24                	jne    c0102dac <basic_check+0xc4>
c0102d88:	c7 44 24 0c b1 63 10 	movl   $0xc01063b1,0xc(%esp)
c0102d8f:	c0 
c0102d90:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102d97:	c0 
c0102d98:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0102d9f:	00 
c0102da0:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102da7:	e8 77 de ff ff       	call   c0100c23 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102daf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102db2:	74 10                	je     c0102dc4 <basic_check+0xdc>
c0102db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102db7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102dba:	74 08                	je     c0102dc4 <basic_check+0xdc>
c0102dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dbf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102dc2:	75 24                	jne    c0102de8 <basic_check+0x100>
c0102dc4:	c7 44 24 0c d0 63 10 	movl   $0xc01063d0,0xc(%esp)
c0102dcb:	c0 
c0102dcc:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102dd3:	c0 
c0102dd4:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0102ddb:	00 
c0102ddc:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102de3:	e8 3b de ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102deb:	89 04 24             	mov    %eax,(%esp)
c0102dee:	e8 0c f9 ff ff       	call   c01026ff <page_ref>
c0102df3:	85 c0                	test   %eax,%eax
c0102df5:	75 1e                	jne    c0102e15 <basic_check+0x12d>
c0102df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dfa:	89 04 24             	mov    %eax,(%esp)
c0102dfd:	e8 fd f8 ff ff       	call   c01026ff <page_ref>
c0102e02:	85 c0                	test   %eax,%eax
c0102e04:	75 0f                	jne    c0102e15 <basic_check+0x12d>
c0102e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e09:	89 04 24             	mov    %eax,(%esp)
c0102e0c:	e8 ee f8 ff ff       	call   c01026ff <page_ref>
c0102e11:	85 c0                	test   %eax,%eax
c0102e13:	74 24                	je     c0102e39 <basic_check+0x151>
c0102e15:	c7 44 24 0c f4 63 10 	movl   $0xc01063f4,0xc(%esp)
c0102e1c:	c0 
c0102e1d:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102e24:	c0 
c0102e25:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0102e2c:	00 
c0102e2d:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102e34:	e8 ea dd ff ff       	call   c0100c23 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e3c:	89 04 24             	mov    %eax,(%esp)
c0102e3f:	e8 a3 f8 ff ff       	call   c01026e7 <page2pa>
c0102e44:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0102e4a:	c1 e2 0c             	shl    $0xc,%edx
c0102e4d:	39 d0                	cmp    %edx,%eax
c0102e4f:	72 24                	jb     c0102e75 <basic_check+0x18d>
c0102e51:	c7 44 24 0c 30 64 10 	movl   $0xc0106430,0xc(%esp)
c0102e58:	c0 
c0102e59:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102e60:	c0 
c0102e61:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0102e68:	00 
c0102e69:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102e70:	e8 ae dd ff ff       	call   c0100c23 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e78:	89 04 24             	mov    %eax,(%esp)
c0102e7b:	e8 67 f8 ff ff       	call   c01026e7 <page2pa>
c0102e80:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0102e86:	c1 e2 0c             	shl    $0xc,%edx
c0102e89:	39 d0                	cmp    %edx,%eax
c0102e8b:	72 24                	jb     c0102eb1 <basic_check+0x1c9>
c0102e8d:	c7 44 24 0c 4d 64 10 	movl   $0xc010644d,0xc(%esp)
c0102e94:	c0 
c0102e95:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102e9c:	c0 
c0102e9d:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0102ea4:	00 
c0102ea5:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102eac:	e8 72 dd ff ff       	call   c0100c23 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb4:	89 04 24             	mov    %eax,(%esp)
c0102eb7:	e8 2b f8 ff ff       	call   c01026e7 <page2pa>
c0102ebc:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0102ec2:	c1 e2 0c             	shl    $0xc,%edx
c0102ec5:	39 d0                	cmp    %edx,%eax
c0102ec7:	72 24                	jb     c0102eed <basic_check+0x205>
c0102ec9:	c7 44 24 0c 6a 64 10 	movl   $0xc010646a,0xc(%esp)
c0102ed0:	c0 
c0102ed1:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102ed8:	c0 
c0102ed9:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0102ee0:	00 
c0102ee1:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102ee8:	e8 36 dd ff ff       	call   c0100c23 <__panic>

    list_entry_t free_list_store = free_list;
c0102eed:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0102ef2:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0102ef8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102efb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102efe:	c7 45 dc 80 be 11 c0 	movl   $0xc011be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0102f05:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f0b:	89 50 04             	mov    %edx,0x4(%eax)
c0102f0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f11:	8b 50 04             	mov    0x4(%eax),%edx
c0102f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f17:	89 10                	mov    %edx,(%eax)
}
c0102f19:	90                   	nop
c0102f1a:	c7 45 e0 80 be 11 c0 	movl   $0xc011be80,-0x20(%ebp)
    return list->next == list;
c0102f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f24:	8b 40 04             	mov    0x4(%eax),%eax
c0102f27:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0102f2a:	0f 94 c0             	sete   %al
c0102f2d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102f30:	85 c0                	test   %eax,%eax
c0102f32:	75 24                	jne    c0102f58 <basic_check+0x270>
c0102f34:	c7 44 24 0c 87 64 10 	movl   $0xc0106487,0xc(%esp)
c0102f3b:	c0 
c0102f3c:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102f43:	c0 
c0102f44:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102f4b:	00 
c0102f4c:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102f53:	e8 cb dc ff ff       	call   c0100c23 <__panic>

    unsigned int nr_free_store = nr_free;
c0102f58:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102f60:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c0102f67:	00 00 00 

    assert(alloc_page() == NULL);
c0102f6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f71:	e8 76 0c 00 00       	call   c0103bec <alloc_pages>
c0102f76:	85 c0                	test   %eax,%eax
c0102f78:	74 24                	je     c0102f9e <basic_check+0x2b6>
c0102f7a:	c7 44 24 0c 9e 64 10 	movl   $0xc010649e,0xc(%esp)
c0102f81:	c0 
c0102f82:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102f89:	c0 
c0102f8a:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0102f91:	00 
c0102f92:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0102f99:	e8 85 dc ff ff       	call   c0100c23 <__panic>

    free_page(p0);
c0102f9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102fa5:	00 
c0102fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fa9:	89 04 24             	mov    %eax,(%esp)
c0102fac:	e8 75 0c 00 00       	call   c0103c26 <free_pages>
    free_page(p1);
c0102fb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102fb8:	00 
c0102fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fbc:	89 04 24             	mov    %eax,(%esp)
c0102fbf:	e8 62 0c 00 00       	call   c0103c26 <free_pages>
    free_page(p2);
c0102fc4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102fcb:	00 
c0102fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fcf:	89 04 24             	mov    %eax,(%esp)
c0102fd2:	e8 4f 0c 00 00       	call   c0103c26 <free_pages>
    assert(nr_free == 3);
c0102fd7:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0102fdc:	83 f8 03             	cmp    $0x3,%eax
c0102fdf:	74 24                	je     c0103005 <basic_check+0x31d>
c0102fe1:	c7 44 24 0c b3 64 10 	movl   $0xc01064b3,0xc(%esp)
c0102fe8:	c0 
c0102fe9:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0102ff0:	c0 
c0102ff1:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0102ff8:	00 
c0102ff9:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103000:	e8 1e dc ff ff       	call   c0100c23 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103005:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010300c:	e8 db 0b 00 00       	call   c0103bec <alloc_pages>
c0103011:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103014:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103018:	75 24                	jne    c010303e <basic_check+0x356>
c010301a:	c7 44 24 0c 79 63 10 	movl   $0xc0106379,0xc(%esp)
c0103021:	c0 
c0103022:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103029:	c0 
c010302a:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0103031:	00 
c0103032:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103039:	e8 e5 db ff ff       	call   c0100c23 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010303e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103045:	e8 a2 0b 00 00       	call   c0103bec <alloc_pages>
c010304a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010304d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103051:	75 24                	jne    c0103077 <basic_check+0x38f>
c0103053:	c7 44 24 0c 95 63 10 	movl   $0xc0106395,0xc(%esp)
c010305a:	c0 
c010305b:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103062:	c0 
c0103063:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c010306a:	00 
c010306b:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103072:	e8 ac db ff ff       	call   c0100c23 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103077:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010307e:	e8 69 0b 00 00       	call   c0103bec <alloc_pages>
c0103083:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010308a:	75 24                	jne    c01030b0 <basic_check+0x3c8>
c010308c:	c7 44 24 0c b1 63 10 	movl   $0xc01063b1,0xc(%esp)
c0103093:	c0 
c0103094:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010309b:	c0 
c010309c:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01030a3:	00 
c01030a4:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01030ab:	e8 73 db ff ff       	call   c0100c23 <__panic>

    assert(alloc_page() == NULL);
c01030b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030b7:	e8 30 0b 00 00       	call   c0103bec <alloc_pages>
c01030bc:	85 c0                	test   %eax,%eax
c01030be:	74 24                	je     c01030e4 <basic_check+0x3fc>
c01030c0:	c7 44 24 0c 9e 64 10 	movl   $0xc010649e,0xc(%esp)
c01030c7:	c0 
c01030c8:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01030cf:	c0 
c01030d0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c01030d7:	00 
c01030d8:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01030df:	e8 3f db ff ff       	call   c0100c23 <__panic>

    free_page(p0);
c01030e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030eb:	00 
c01030ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030ef:	89 04 24             	mov    %eax,(%esp)
c01030f2:	e8 2f 0b 00 00       	call   c0103c26 <free_pages>
c01030f7:	c7 45 d8 80 be 11 c0 	movl   $0xc011be80,-0x28(%ebp)
c01030fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103101:	8b 40 04             	mov    0x4(%eax),%eax
c0103104:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103107:	0f 94 c0             	sete   %al
c010310a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010310d:	85 c0                	test   %eax,%eax
c010310f:	74 24                	je     c0103135 <basic_check+0x44d>
c0103111:	c7 44 24 0c c0 64 10 	movl   $0xc01064c0,0xc(%esp)
c0103118:	c0 
c0103119:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103120:	c0 
c0103121:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0103128:	00 
c0103129:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103130:	e8 ee da ff ff       	call   c0100c23 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103135:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010313c:	e8 ab 0a 00 00       	call   c0103bec <alloc_pages>
c0103141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103147:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010314a:	74 24                	je     c0103170 <basic_check+0x488>
c010314c:	c7 44 24 0c d8 64 10 	movl   $0xc01064d8,0xc(%esp)
c0103153:	c0 
c0103154:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010315b:	c0 
c010315c:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103163:	00 
c0103164:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c010316b:	e8 b3 da ff ff       	call   c0100c23 <__panic>
    assert(alloc_page() == NULL);
c0103170:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103177:	e8 70 0a 00 00       	call   c0103bec <alloc_pages>
c010317c:	85 c0                	test   %eax,%eax
c010317e:	74 24                	je     c01031a4 <basic_check+0x4bc>
c0103180:	c7 44 24 0c 9e 64 10 	movl   $0xc010649e,0xc(%esp)
c0103187:	c0 
c0103188:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010318f:	c0 
c0103190:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103197:	00 
c0103198:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c010319f:	e8 7f da ff ff       	call   c0100c23 <__panic>

    assert(nr_free == 0);
c01031a4:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c01031a9:	85 c0                	test   %eax,%eax
c01031ab:	74 24                	je     c01031d1 <basic_check+0x4e9>
c01031ad:	c7 44 24 0c f1 64 10 	movl   $0xc01064f1,0xc(%esp)
c01031b4:	c0 
c01031b5:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01031bc:	c0 
c01031bd:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c01031c4:	00 
c01031c5:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01031cc:	e8 52 da ff ff       	call   c0100c23 <__panic>
    free_list = free_list_store;
c01031d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01031d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01031d7:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01031dc:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    nr_free = nr_free_store;
c01031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031e5:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_page(p);
c01031ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01031f1:	00 
c01031f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031f5:	89 04 24             	mov    %eax,(%esp)
c01031f8:	e8 29 0a 00 00       	call   c0103c26 <free_pages>
    free_page(p1);
c01031fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103204:	00 
c0103205:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103208:	89 04 24             	mov    %eax,(%esp)
c010320b:	e8 16 0a 00 00       	call   c0103c26 <free_pages>
    free_page(p2);
c0103210:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103217:	00 
c0103218:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010321b:	89 04 24             	mov    %eax,(%esp)
c010321e:	e8 03 0a 00 00       	call   c0103c26 <free_pages>
}
c0103223:	90                   	nop
c0103224:	89 ec                	mov    %ebp,%esp
c0103226:	5d                   	pop    %ebp
c0103227:	c3                   	ret    

c0103228 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103228:	55                   	push   %ebp
c0103229:	89 e5                	mov    %esp,%ebp
c010322b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0103231:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103238:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010323f:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103246:	eb 6a                	jmp    c01032b2 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0103248:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010324b:	83 e8 0c             	sub    $0xc,%eax
c010324e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0103251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103254:	83 c0 04             	add    $0x4,%eax
c0103257:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010325e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103261:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103264:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103267:	0f a3 10             	bt     %edx,(%eax)
c010326a:	19 c0                	sbb    %eax,%eax
c010326c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010326f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103273:	0f 95 c0             	setne  %al
c0103276:	0f b6 c0             	movzbl %al,%eax
c0103279:	85 c0                	test   %eax,%eax
c010327b:	75 24                	jne    c01032a1 <default_check+0x79>
c010327d:	c7 44 24 0c fe 64 10 	movl   $0xc01064fe,0xc(%esp)
c0103284:	c0 
c0103285:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010328c:	c0 
c010328d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103294:	00 
c0103295:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c010329c:	e8 82 d9 ff ff       	call   c0100c23 <__panic>
        count ++, total += p->property;
c01032a1:	ff 45 f4             	incl   -0xc(%ebp)
c01032a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01032a7:	8b 50 08             	mov    0x8(%eax),%edx
c01032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032ad:	01 d0                	add    %edx,%eax
c01032af:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01032b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c01032b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01032bb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c01032be:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01032c1:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c01032c8:	0f 85 7a ff ff ff    	jne    c0103248 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c01032ce:	e8 88 09 00 00       	call   c0103c5b <nr_free_pages>
c01032d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032d6:	39 d0                	cmp    %edx,%eax
c01032d8:	74 24                	je     c01032fe <default_check+0xd6>
c01032da:	c7 44 24 0c 0e 65 10 	movl   $0xc010650e,0xc(%esp)
c01032e1:	c0 
c01032e2:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01032e9:	c0 
c01032ea:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01032f1:	00 
c01032f2:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01032f9:	e8 25 d9 ff ff       	call   c0100c23 <__panic>

    basic_check();
c01032fe:	e8 e5 f9 ff ff       	call   c0102ce8 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103303:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010330a:	e8 dd 08 00 00       	call   c0103bec <alloc_pages>
c010330f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0103312:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103316:	75 24                	jne    c010333c <default_check+0x114>
c0103318:	c7 44 24 0c 27 65 10 	movl   $0xc0106527,0xc(%esp)
c010331f:	c0 
c0103320:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103327:	c0 
c0103328:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c010332f:	00 
c0103330:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103337:	e8 e7 d8 ff ff       	call   c0100c23 <__panic>
    assert(!PageProperty(p0));
c010333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010333f:	83 c0 04             	add    $0x4,%eax
c0103342:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103349:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010334c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010334f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103352:	0f a3 10             	bt     %edx,(%eax)
c0103355:	19 c0                	sbb    %eax,%eax
c0103357:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010335a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010335e:	0f 95 c0             	setne  %al
c0103361:	0f b6 c0             	movzbl %al,%eax
c0103364:	85 c0                	test   %eax,%eax
c0103366:	74 24                	je     c010338c <default_check+0x164>
c0103368:	c7 44 24 0c 32 65 10 	movl   $0xc0106532,0xc(%esp)
c010336f:	c0 
c0103370:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103377:	c0 
c0103378:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c010337f:	00 
c0103380:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103387:	e8 97 d8 ff ff       	call   c0100c23 <__panic>

    list_entry_t free_list_store = free_list;
c010338c:	a1 80 be 11 c0       	mov    0xc011be80,%eax
c0103391:	8b 15 84 be 11 c0    	mov    0xc011be84,%edx
c0103397:	89 45 80             	mov    %eax,-0x80(%ebp)
c010339a:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010339d:	c7 45 b0 80 be 11 c0 	movl   $0xc011be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
c01033a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01033a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
c01033aa:	89 50 04             	mov    %edx,0x4(%eax)
c01033ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01033b0:	8b 50 04             	mov    0x4(%eax),%edx
c01033b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01033b6:	89 10                	mov    %edx,(%eax)
}
c01033b8:	90                   	nop
c01033b9:	c7 45 b4 80 be 11 c0 	movl   $0xc011be80,-0x4c(%ebp)
    return list->next == list;
c01033c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01033c3:	8b 40 04             	mov    0x4(%eax),%eax
c01033c6:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c01033c9:	0f 94 c0             	sete   %al
c01033cc:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01033cf:	85 c0                	test   %eax,%eax
c01033d1:	75 24                	jne    c01033f7 <default_check+0x1cf>
c01033d3:	c7 44 24 0c 87 64 10 	movl   $0xc0106487,0xc(%esp)
c01033da:	c0 
c01033db:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01033e2:	c0 
c01033e3:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01033ea:	00 
c01033eb:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01033f2:	e8 2c d8 ff ff       	call   c0100c23 <__panic>
    assert(alloc_page() == NULL);
c01033f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033fe:	e8 e9 07 00 00       	call   c0103bec <alloc_pages>
c0103403:	85 c0                	test   %eax,%eax
c0103405:	74 24                	je     c010342b <default_check+0x203>
c0103407:	c7 44 24 0c 9e 64 10 	movl   $0xc010649e,0xc(%esp)
c010340e:	c0 
c010340f:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103416:	c0 
c0103417:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010341e:	00 
c010341f:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103426:	e8 f8 d7 ff ff       	call   c0100c23 <__panic>

    unsigned int nr_free_store = nr_free;
c010342b:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0103433:	c7 05 88 be 11 c0 00 	movl   $0x0,0xc011be88
c010343a:	00 00 00 

    free_pages(p0 + 2, 3);
c010343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103440:	83 c0 28             	add    $0x28,%eax
c0103443:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010344a:	00 
c010344b:	89 04 24             	mov    %eax,(%esp)
c010344e:	e8 d3 07 00 00       	call   c0103c26 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103453:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010345a:	e8 8d 07 00 00       	call   c0103bec <alloc_pages>
c010345f:	85 c0                	test   %eax,%eax
c0103461:	74 24                	je     c0103487 <default_check+0x25f>
c0103463:	c7 44 24 0c 44 65 10 	movl   $0xc0106544,0xc(%esp)
c010346a:	c0 
c010346b:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103472:	c0 
c0103473:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c010347a:	00 
c010347b:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103482:	e8 9c d7 ff ff       	call   c0100c23 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103487:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010348a:	83 c0 28             	add    $0x28,%eax
c010348d:	83 c0 04             	add    $0x4,%eax
c0103490:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103497:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010349a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010349d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01034a0:	0f a3 10             	bt     %edx,(%eax)
c01034a3:	19 c0                	sbb    %eax,%eax
c01034a5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01034a8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01034ac:	0f 95 c0             	setne  %al
c01034af:	0f b6 c0             	movzbl %al,%eax
c01034b2:	85 c0                	test   %eax,%eax
c01034b4:	74 0e                	je     c01034c4 <default_check+0x29c>
c01034b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034b9:	83 c0 28             	add    $0x28,%eax
c01034bc:	8b 40 08             	mov    0x8(%eax),%eax
c01034bf:	83 f8 03             	cmp    $0x3,%eax
c01034c2:	74 24                	je     c01034e8 <default_check+0x2c0>
c01034c4:	c7 44 24 0c 5c 65 10 	movl   $0xc010655c,0xc(%esp)
c01034cb:	c0 
c01034cc:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01034d3:	c0 
c01034d4:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01034db:	00 
c01034dc:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01034e3:	e8 3b d7 ff ff       	call   c0100c23 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01034e8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01034ef:	e8 f8 06 00 00       	call   c0103bec <alloc_pages>
c01034f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01034f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01034fb:	75 24                	jne    c0103521 <default_check+0x2f9>
c01034fd:	c7 44 24 0c 88 65 10 	movl   $0xc0106588,0xc(%esp)
c0103504:	c0 
c0103505:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010350c:	c0 
c010350d:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0103514:	00 
c0103515:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c010351c:	e8 02 d7 ff ff       	call   c0100c23 <__panic>
    assert(alloc_page() == NULL);
c0103521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103528:	e8 bf 06 00 00       	call   c0103bec <alloc_pages>
c010352d:	85 c0                	test   %eax,%eax
c010352f:	74 24                	je     c0103555 <default_check+0x32d>
c0103531:	c7 44 24 0c 9e 64 10 	movl   $0xc010649e,0xc(%esp)
c0103538:	c0 
c0103539:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103540:	c0 
c0103541:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0103548:	00 
c0103549:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103550:	e8 ce d6 ff ff       	call   c0100c23 <__panic>
    assert(p0 + 2 == p1);
c0103555:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103558:	83 c0 28             	add    $0x28,%eax
c010355b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010355e:	74 24                	je     c0103584 <default_check+0x35c>
c0103560:	c7 44 24 0c a6 65 10 	movl   $0xc01065a6,0xc(%esp)
c0103567:	c0 
c0103568:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010356f:	c0 
c0103570:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0103577:	00 
c0103578:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c010357f:	e8 9f d6 ff ff       	call   c0100c23 <__panic>

    p2 = p0 + 1;
c0103584:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103587:	83 c0 14             	add    $0x14,%eax
c010358a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c010358d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103594:	00 
c0103595:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103598:	89 04 24             	mov    %eax,(%esp)
c010359b:	e8 86 06 00 00       	call   c0103c26 <free_pages>
    free_pages(p1, 3);
c01035a0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035a7:	00 
c01035a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035ab:	89 04 24             	mov    %eax,(%esp)
c01035ae:	e8 73 06 00 00       	call   c0103c26 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035b6:	83 c0 04             	add    $0x4,%eax
c01035b9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01035c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01035c6:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01035c9:	0f a3 10             	bt     %edx,(%eax)
c01035cc:	19 c0                	sbb    %eax,%eax
c01035ce:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01035d1:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01035d5:	0f 95 c0             	setne  %al
c01035d8:	0f b6 c0             	movzbl %al,%eax
c01035db:	85 c0                	test   %eax,%eax
c01035dd:	74 0b                	je     c01035ea <default_check+0x3c2>
c01035df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035e2:	8b 40 08             	mov    0x8(%eax),%eax
c01035e5:	83 f8 01             	cmp    $0x1,%eax
c01035e8:	74 24                	je     c010360e <default_check+0x3e6>
c01035ea:	c7 44 24 0c b4 65 10 	movl   $0xc01065b4,0xc(%esp)
c01035f1:	c0 
c01035f2:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01035f9:	c0 
c01035fa:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103601:	00 
c0103602:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103609:	e8 15 d6 ff ff       	call   c0100c23 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010360e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103611:	83 c0 04             	add    $0x4,%eax
c0103614:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010361b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010361e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103621:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103624:	0f a3 10             	bt     %edx,(%eax)
c0103627:	19 c0                	sbb    %eax,%eax
c0103629:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010362c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103630:	0f 95 c0             	setne  %al
c0103633:	0f b6 c0             	movzbl %al,%eax
c0103636:	85 c0                	test   %eax,%eax
c0103638:	74 0b                	je     c0103645 <default_check+0x41d>
c010363a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010363d:	8b 40 08             	mov    0x8(%eax),%eax
c0103640:	83 f8 03             	cmp    $0x3,%eax
c0103643:	74 24                	je     c0103669 <default_check+0x441>
c0103645:	c7 44 24 0c dc 65 10 	movl   $0xc01065dc,0xc(%esp)
c010364c:	c0 
c010364d:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103654:	c0 
c0103655:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c010365c:	00 
c010365d:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103664:	e8 ba d5 ff ff       	call   c0100c23 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103669:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103670:	e8 77 05 00 00       	call   c0103bec <alloc_pages>
c0103675:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103678:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010367b:	83 e8 14             	sub    $0x14,%eax
c010367e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103681:	74 24                	je     c01036a7 <default_check+0x47f>
c0103683:	c7 44 24 0c 02 66 10 	movl   $0xc0106602,0xc(%esp)
c010368a:	c0 
c010368b:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103692:	c0 
c0103693:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c010369a:	00 
c010369b:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01036a2:	e8 7c d5 ff ff       	call   c0100c23 <__panic>
    free_page(p0);
c01036a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036ae:	00 
c01036af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036b2:	89 04 24             	mov    %eax,(%esp)
c01036b5:	e8 6c 05 00 00       	call   c0103c26 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01036ba:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01036c1:	e8 26 05 00 00       	call   c0103bec <alloc_pages>
c01036c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01036c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036cc:	83 c0 14             	add    $0x14,%eax
c01036cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01036d2:	74 24                	je     c01036f8 <default_check+0x4d0>
c01036d4:	c7 44 24 0c 20 66 10 	movl   $0xc0106620,0xc(%esp)
c01036db:	c0 
c01036dc:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01036e3:	c0 
c01036e4:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c01036eb:	00 
c01036ec:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01036f3:	e8 2b d5 ff ff       	call   c0100c23 <__panic>

    free_pages(p0, 2);
c01036f8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01036ff:	00 
c0103700:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103703:	89 04 24             	mov    %eax,(%esp)
c0103706:	e8 1b 05 00 00       	call   c0103c26 <free_pages>
    free_page(p2);
c010370b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103712:	00 
c0103713:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103716:	89 04 24             	mov    %eax,(%esp)
c0103719:	e8 08 05 00 00       	call   c0103c26 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010371e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103725:	e8 c2 04 00 00       	call   c0103bec <alloc_pages>
c010372a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010372d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103731:	75 24                	jne    c0103757 <default_check+0x52f>
c0103733:	c7 44 24 0c 40 66 10 	movl   $0xc0106640,0xc(%esp)
c010373a:	c0 
c010373b:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103742:	c0 
c0103743:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c010374a:	00 
c010374b:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103752:	e8 cc d4 ff ff       	call   c0100c23 <__panic>
    assert(alloc_page() == NULL);
c0103757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010375e:	e8 89 04 00 00       	call   c0103bec <alloc_pages>
c0103763:	85 c0                	test   %eax,%eax
c0103765:	74 24                	je     c010378b <default_check+0x563>
c0103767:	c7 44 24 0c 9e 64 10 	movl   $0xc010649e,0xc(%esp)
c010376e:	c0 
c010376f:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103776:	c0 
c0103777:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c010377e:	00 
c010377f:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103786:	e8 98 d4 ff ff       	call   c0100c23 <__panic>

    assert(nr_free == 0);
c010378b:	a1 88 be 11 c0       	mov    0xc011be88,%eax
c0103790:	85 c0                	test   %eax,%eax
c0103792:	74 24                	je     c01037b8 <default_check+0x590>
c0103794:	c7 44 24 0c f1 64 10 	movl   $0xc01064f1,0xc(%esp)
c010379b:	c0 
c010379c:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c01037a3:	c0 
c01037a4:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01037ab:	00 
c01037ac:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01037b3:	e8 6b d4 ff ff       	call   c0100c23 <__panic>
    nr_free = nr_free_store;
c01037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037bb:	a3 88 be 11 c0       	mov    %eax,0xc011be88

    free_list = free_list_store;
c01037c0:	8b 45 80             	mov    -0x80(%ebp),%eax
c01037c3:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01037c6:	a3 80 be 11 c0       	mov    %eax,0xc011be80
c01037cb:	89 15 84 be 11 c0    	mov    %edx,0xc011be84
    free_pages(p0, 5);
c01037d1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01037d8:	00 
c01037d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01037dc:	89 04 24             	mov    %eax,(%esp)
c01037df:	e8 42 04 00 00       	call   c0103c26 <free_pages>

    le = &free_list;
c01037e4:	c7 45 ec 80 be 11 c0 	movl   $0xc011be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01037eb:	eb 5a                	jmp    c0103847 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
c01037ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037f0:	8b 40 04             	mov    0x4(%eax),%eax
c01037f3:	8b 00                	mov    (%eax),%eax
c01037f5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01037f8:	75 0d                	jne    c0103807 <default_check+0x5df>
c01037fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037fd:	8b 00                	mov    (%eax),%eax
c01037ff:	8b 40 04             	mov    0x4(%eax),%eax
c0103802:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103805:	74 24                	je     c010382b <default_check+0x603>
c0103807:	c7 44 24 0c 60 66 10 	movl   $0xc0106660,0xc(%esp)
c010380e:	c0 
c010380f:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103816:	c0 
c0103817:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c010381e:	00 
c010381f:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103826:	e8 f8 d3 ff ff       	call   c0100c23 <__panic>
        struct Page *p = le2page(le, page_link);
c010382b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010382e:	83 e8 0c             	sub    $0xc,%eax
c0103831:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0103834:	ff 4d f4             	decl   -0xc(%ebp)
c0103837:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010383a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010383d:	8b 48 08             	mov    0x8(%eax),%ecx
c0103840:	89 d0                	mov    %edx,%eax
c0103842:	29 c8                	sub    %ecx,%eax
c0103844:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103847:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010384a:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c010384d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103850:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0103853:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103856:	81 7d ec 80 be 11 c0 	cmpl   $0xc011be80,-0x14(%ebp)
c010385d:	75 8e                	jne    c01037ed <default_check+0x5c5>
    }
    assert(count == 0);
c010385f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103863:	74 24                	je     c0103889 <default_check+0x661>
c0103865:	c7 44 24 0c 8d 66 10 	movl   $0xc010668d,0xc(%esp)
c010386c:	c0 
c010386d:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c0103874:	c0 
c0103875:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c010387c:	00 
c010387d:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c0103884:	e8 9a d3 ff ff       	call   c0100c23 <__panic>
    assert(total == 0);
c0103889:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010388d:	74 24                	je     c01038b3 <default_check+0x68b>
c010388f:	c7 44 24 0c 98 66 10 	movl   $0xc0106698,0xc(%esp)
c0103896:	c0 
c0103897:	c7 44 24 08 16 63 10 	movl   $0xc0106316,0x8(%esp)
c010389e:	c0 
c010389f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01038a6:	00 
c01038a7:	c7 04 24 2b 63 10 c0 	movl   $0xc010632b,(%esp)
c01038ae:	e8 70 d3 ff ff       	call   c0100c23 <__panic>
}
c01038b3:	90                   	nop
c01038b4:	89 ec                	mov    %ebp,%esp
c01038b6:	5d                   	pop    %ebp
c01038b7:	c3                   	ret    

c01038b8 <page2ppn>:
page2ppn(struct Page *page) {
c01038b8:	55                   	push   %ebp
c01038b9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01038bb:	8b 15 a0 be 11 c0    	mov    0xc011bea0,%edx
c01038c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c4:	29 d0                	sub    %edx,%eax
c01038c6:	c1 f8 02             	sar    $0x2,%eax
c01038c9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01038cf:	5d                   	pop    %ebp
c01038d0:	c3                   	ret    

c01038d1 <page2pa>:
page2pa(struct Page *page) {
c01038d1:	55                   	push   %ebp
c01038d2:	89 e5                	mov    %esp,%ebp
c01038d4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01038d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01038da:	89 04 24             	mov    %eax,(%esp)
c01038dd:	e8 d6 ff ff ff       	call   c01038b8 <page2ppn>
c01038e2:	c1 e0 0c             	shl    $0xc,%eax
}
c01038e5:	89 ec                	mov    %ebp,%esp
c01038e7:	5d                   	pop    %ebp
c01038e8:	c3                   	ret    

c01038e9 <pa2page>:
pa2page(uintptr_t pa) {
c01038e9:	55                   	push   %ebp
c01038ea:	89 e5                	mov    %esp,%ebp
c01038ec:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01038ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01038f2:	c1 e8 0c             	shr    $0xc,%eax
c01038f5:	89 c2                	mov    %eax,%edx
c01038f7:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c01038fc:	39 c2                	cmp    %eax,%edx
c01038fe:	72 1c                	jb     c010391c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103900:	c7 44 24 08 d4 66 10 	movl   $0xc01066d4,0x8(%esp)
c0103907:	c0 
c0103908:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010390f:	00 
c0103910:	c7 04 24 f3 66 10 c0 	movl   $0xc01066f3,(%esp)
c0103917:	e8 07 d3 ff ff       	call   c0100c23 <__panic>
    return &pages[PPN(pa)];
c010391c:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103922:	8b 45 08             	mov    0x8(%ebp),%eax
c0103925:	c1 e8 0c             	shr    $0xc,%eax
c0103928:	89 c2                	mov    %eax,%edx
c010392a:	89 d0                	mov    %edx,%eax
c010392c:	c1 e0 02             	shl    $0x2,%eax
c010392f:	01 d0                	add    %edx,%eax
c0103931:	c1 e0 02             	shl    $0x2,%eax
c0103934:	01 c8                	add    %ecx,%eax
}
c0103936:	89 ec                	mov    %ebp,%esp
c0103938:	5d                   	pop    %ebp
c0103939:	c3                   	ret    

c010393a <page2kva>:
page2kva(struct Page *page) {
c010393a:	55                   	push   %ebp
c010393b:	89 e5                	mov    %esp,%ebp
c010393d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103940:	8b 45 08             	mov    0x8(%ebp),%eax
c0103943:	89 04 24             	mov    %eax,(%esp)
c0103946:	e8 86 ff ff ff       	call   c01038d1 <page2pa>
c010394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103951:	c1 e8 0c             	shr    $0xc,%eax
c0103954:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103957:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c010395c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010395f:	72 23                	jb     c0103984 <page2kva+0x4a>
c0103961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103964:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103968:	c7 44 24 08 04 67 10 	movl   $0xc0106704,0x8(%esp)
c010396f:	c0 
c0103970:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103977:	00 
c0103978:	c7 04 24 f3 66 10 c0 	movl   $0xc01066f3,(%esp)
c010397f:	e8 9f d2 ff ff       	call   c0100c23 <__panic>
c0103984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103987:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010398c:	89 ec                	mov    %ebp,%esp
c010398e:	5d                   	pop    %ebp
c010398f:	c3                   	ret    

c0103990 <pte2page>:
pte2page(pte_t pte) {
c0103990:	55                   	push   %ebp
c0103991:	89 e5                	mov    %esp,%ebp
c0103993:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103996:	8b 45 08             	mov    0x8(%ebp),%eax
c0103999:	83 e0 01             	and    $0x1,%eax
c010399c:	85 c0                	test   %eax,%eax
c010399e:	75 1c                	jne    c01039bc <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01039a0:	c7 44 24 08 28 67 10 	movl   $0xc0106728,0x8(%esp)
c01039a7:	c0 
c01039a8:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01039af:	00 
c01039b0:	c7 04 24 f3 66 10 c0 	movl   $0xc01066f3,(%esp)
c01039b7:	e8 67 d2 ff ff       	call   c0100c23 <__panic>
    return pa2page(PTE_ADDR(pte));
c01039bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01039bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039c4:	89 04 24             	mov    %eax,(%esp)
c01039c7:	e8 1d ff ff ff       	call   c01038e9 <pa2page>
}
c01039cc:	89 ec                	mov    %ebp,%esp
c01039ce:	5d                   	pop    %ebp
c01039cf:	c3                   	ret    

c01039d0 <pde2page>:
pde2page(pde_t pde) {
c01039d0:	55                   	push   %ebp
c01039d1:	89 e5                	mov    %esp,%ebp
c01039d3:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01039d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01039d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01039de:	89 04 24             	mov    %eax,(%esp)
c01039e1:	e8 03 ff ff ff       	call   c01038e9 <pa2page>
}
c01039e6:	89 ec                	mov    %ebp,%esp
c01039e8:	5d                   	pop    %ebp
c01039e9:	c3                   	ret    

c01039ea <page_ref>:
page_ref(struct Page *page) {
c01039ea:	55                   	push   %ebp
c01039eb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01039ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01039f0:	8b 00                	mov    (%eax),%eax
}
c01039f2:	5d                   	pop    %ebp
c01039f3:	c3                   	ret    

c01039f4 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01039f4:	55                   	push   %ebp
c01039f5:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01039f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01039fa:	8b 00                	mov    (%eax),%eax
c01039fc:	8d 50 01             	lea    0x1(%eax),%edx
c01039ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a02:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a07:	8b 00                	mov    (%eax),%eax
}
c0103a09:	5d                   	pop    %ebp
c0103a0a:	c3                   	ret    

c0103a0b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103a0b:	55                   	push   %ebp
c0103a0c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a11:	8b 00                	mov    (%eax),%eax
c0103a13:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a19:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a1e:	8b 00                	mov    (%eax),%eax
}
c0103a20:	5d                   	pop    %ebp
c0103a21:	c3                   	ret    

c0103a22 <__intr_save>:
__intr_save(void) {
c0103a22:	55                   	push   %ebp
c0103a23:	89 e5                	mov    %esp,%ebp
c0103a25:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103a28:	9c                   	pushf  
c0103a29:	58                   	pop    %eax
c0103a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103a30:	25 00 02 00 00       	and    $0x200,%eax
c0103a35:	85 c0                	test   %eax,%eax
c0103a37:	74 0c                	je     c0103a45 <__intr_save+0x23>
        intr_disable();
c0103a39:	e8 3e dc ff ff       	call   c010167c <intr_disable>
        return 1;
c0103a3e:	b8 01 00 00 00       	mov    $0x1,%eax
c0103a43:	eb 05                	jmp    c0103a4a <__intr_save+0x28>
    return 0;
c0103a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a4a:	89 ec                	mov    %ebp,%esp
c0103a4c:	5d                   	pop    %ebp
c0103a4d:	c3                   	ret    

c0103a4e <__intr_restore>:
__intr_restore(bool flag) {
c0103a4e:	55                   	push   %ebp
c0103a4f:	89 e5                	mov    %esp,%ebp
c0103a51:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a58:	74 05                	je     c0103a5f <__intr_restore+0x11>
        intr_enable();
c0103a5a:	e8 15 dc ff ff       	call   c0101674 <intr_enable>
}
c0103a5f:	90                   	nop
c0103a60:	89 ec                	mov    %ebp,%esp
c0103a62:	5d                   	pop    %ebp
c0103a63:	c3                   	ret    

c0103a64 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a64:	55                   	push   %ebp
c0103a65:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a67:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103a6d:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a72:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103a74:	b8 23 00 00 00       	mov    $0x23,%eax
c0103a79:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103a7b:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a80:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103a82:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a87:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103a89:	b8 10 00 00 00       	mov    $0x10,%eax
c0103a8e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103a90:	ea 97 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103a97
}
c0103a97:	90                   	nop
c0103a98:	5d                   	pop    %ebp
c0103a99:	c3                   	ret    

c0103a9a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103a9a:	55                   	push   %ebp
c0103a9b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103a9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa0:	a3 c4 be 11 c0       	mov    %eax,0xc011bec4
}
c0103aa5:	90                   	nop
c0103aa6:	5d                   	pop    %ebp
c0103aa7:	c3                   	ret    

c0103aa8 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103aa8:	55                   	push   %ebp
c0103aa9:	89 e5                	mov    %esp,%ebp
c0103aab:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103aae:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103ab3:	89 04 24             	mov    %eax,(%esp)
c0103ab6:	e8 df ff ff ff       	call   c0103a9a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103abb:	66 c7 05 c8 be 11 c0 	movw   $0x10,0xc011bec8
c0103ac2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103ac4:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103acb:	68 00 
c0103acd:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103ad2:	0f b7 c0             	movzwl %ax,%eax
c0103ad5:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103adb:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103ae0:	c1 e8 10             	shr    $0x10,%eax
c0103ae3:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103ae8:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103aef:	24 f0                	and    $0xf0,%al
c0103af1:	0c 09                	or     $0x9,%al
c0103af3:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103af8:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103aff:	24 ef                	and    $0xef,%al
c0103b01:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103b06:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103b0d:	24 9f                	and    $0x9f,%al
c0103b0f:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103b14:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103b1b:	0c 80                	or     $0x80,%al
c0103b1d:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103b22:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b29:	24 f0                	and    $0xf0,%al
c0103b2b:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b30:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b37:	24 ef                	and    $0xef,%al
c0103b39:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b3e:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b45:	24 df                	and    $0xdf,%al
c0103b47:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b4c:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b53:	0c 40                	or     $0x40,%al
c0103b55:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b5a:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103b61:	24 7f                	and    $0x7f,%al
c0103b63:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103b68:	b8 c0 be 11 c0       	mov    $0xc011bec0,%eax
c0103b6d:	c1 e8 18             	shr    $0x18,%eax
c0103b70:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103b75:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103b7c:	e8 e3 fe ff ff       	call   c0103a64 <lgdt>
c0103b81:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103b87:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103b8b:	0f 00 d8             	ltr    %ax
}
c0103b8e:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
c0103b8f:	90                   	nop
c0103b90:	89 ec                	mov    %ebp,%esp
c0103b92:	5d                   	pop    %ebp
c0103b93:	c3                   	ret    

c0103b94 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103b94:	55                   	push   %ebp
c0103b95:	89 e5                	mov    %esp,%ebp
c0103b97:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103b9a:	c7 05 ac be 11 c0 b8 	movl   $0xc01066b8,0xc011beac
c0103ba1:	66 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ba4:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103ba9:	8b 00                	mov    (%eax),%eax
c0103bab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103baf:	c7 04 24 54 67 10 c0 	movl   $0xc0106754,(%esp)
c0103bb6:	e8 9b c7 ff ff       	call   c0100356 <cprintf>
    pmm_manager->init();
c0103bbb:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103bc0:	8b 40 04             	mov    0x4(%eax),%eax
c0103bc3:	ff d0                	call   *%eax
}
c0103bc5:	90                   	nop
c0103bc6:	89 ec                	mov    %ebp,%esp
c0103bc8:	5d                   	pop    %ebp
c0103bc9:	c3                   	ret    

c0103bca <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103bca:	55                   	push   %ebp
c0103bcb:	89 e5                	mov    %esp,%ebp
c0103bcd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103bd0:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103bd5:	8b 40 08             	mov    0x8(%eax),%eax
c0103bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103bdb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103bdf:	8b 55 08             	mov    0x8(%ebp),%edx
c0103be2:	89 14 24             	mov    %edx,(%esp)
c0103be5:	ff d0                	call   *%eax
}
c0103be7:	90                   	nop
c0103be8:	89 ec                	mov    %ebp,%esp
c0103bea:	5d                   	pop    %ebp
c0103beb:	c3                   	ret    

c0103bec <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103bec:	55                   	push   %ebp
c0103bed:	89 e5                	mov    %esp,%ebp
c0103bef:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103bf9:	e8 24 fe ff ff       	call   c0103a22 <__intr_save>
c0103bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103c01:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103c06:	8b 40 0c             	mov    0xc(%eax),%eax
c0103c09:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c0c:	89 14 24             	mov    %edx,(%esp)
c0103c0f:	ff d0                	call   *%eax
c0103c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c17:	89 04 24             	mov    %eax,(%esp)
c0103c1a:	e8 2f fe ff ff       	call   c0103a4e <__intr_restore>
    return page;
c0103c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103c22:	89 ec                	mov    %ebp,%esp
c0103c24:	5d                   	pop    %ebp
c0103c25:	c3                   	ret    

c0103c26 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103c26:	55                   	push   %ebp
c0103c27:	89 e5                	mov    %esp,%ebp
c0103c29:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c2c:	e8 f1 fd ff ff       	call   c0103a22 <__intr_save>
c0103c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103c34:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103c39:	8b 40 10             	mov    0x10(%eax),%eax
c0103c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c3f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c43:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c46:	89 14 24             	mov    %edx,(%esp)
c0103c49:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c4e:	89 04 24             	mov    %eax,(%esp)
c0103c51:	e8 f8 fd ff ff       	call   c0103a4e <__intr_restore>
}
c0103c56:	90                   	nop
c0103c57:	89 ec                	mov    %ebp,%esp
c0103c59:	5d                   	pop    %ebp
c0103c5a:	c3                   	ret    

c0103c5b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103c5b:	55                   	push   %ebp
c0103c5c:	89 e5                	mov    %esp,%ebp
c0103c5e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c61:	e8 bc fd ff ff       	call   c0103a22 <__intr_save>
c0103c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103c69:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0103c6e:	8b 40 14             	mov    0x14(%eax),%eax
c0103c71:	ff d0                	call   *%eax
c0103c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c79:	89 04 24             	mov    %eax,(%esp)
c0103c7c:	e8 cd fd ff ff       	call   c0103a4e <__intr_restore>
    return ret;
c0103c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103c84:	89 ec                	mov    %ebp,%esp
c0103c86:	5d                   	pop    %ebp
c0103c87:	c3                   	ret    

c0103c88 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103c88:	55                   	push   %ebp
c0103c89:	89 e5                	mov    %esp,%ebp
c0103c8b:	57                   	push   %edi
c0103c8c:	56                   	push   %esi
c0103c8d:	53                   	push   %ebx
c0103c8e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103c94:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103c9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103ca2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103ca9:	c7 04 24 6b 67 10 c0 	movl   $0xc010676b,(%esp)
c0103cb0:	e8 a1 c6 ff ff       	call   c0100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103cb5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103cbc:	e9 0c 01 00 00       	jmp    c0103dcd <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103cc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cc7:	89 d0                	mov    %edx,%eax
c0103cc9:	c1 e0 02             	shl    $0x2,%eax
c0103ccc:	01 d0                	add    %edx,%eax
c0103cce:	c1 e0 02             	shl    $0x2,%eax
c0103cd1:	01 c8                	add    %ecx,%eax
c0103cd3:	8b 50 08             	mov    0x8(%eax),%edx
c0103cd6:	8b 40 04             	mov    0x4(%eax),%eax
c0103cd9:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0103cdc:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0103cdf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ce2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ce5:	89 d0                	mov    %edx,%eax
c0103ce7:	c1 e0 02             	shl    $0x2,%eax
c0103cea:	01 d0                	add    %edx,%eax
c0103cec:	c1 e0 02             	shl    $0x2,%eax
c0103cef:	01 c8                	add    %ecx,%eax
c0103cf1:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103cf4:	8b 58 10             	mov    0x10(%eax),%ebx
c0103cf7:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103cfa:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103cfd:	01 c8                	add    %ecx,%eax
c0103cff:	11 da                	adc    %ebx,%edx
c0103d01:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103d04:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103d07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d0d:	89 d0                	mov    %edx,%eax
c0103d0f:	c1 e0 02             	shl    $0x2,%eax
c0103d12:	01 d0                	add    %edx,%eax
c0103d14:	c1 e0 02             	shl    $0x2,%eax
c0103d17:	01 c8                	add    %ecx,%eax
c0103d19:	83 c0 14             	add    $0x14,%eax
c0103d1c:	8b 00                	mov    (%eax),%eax
c0103d1e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103d24:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103d27:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103d2a:	83 c0 ff             	add    $0xffffffff,%eax
c0103d2d:	83 d2 ff             	adc    $0xffffffff,%edx
c0103d30:	89 c6                	mov    %eax,%esi
c0103d32:	89 d7                	mov    %edx,%edi
c0103d34:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d37:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d3a:	89 d0                	mov    %edx,%eax
c0103d3c:	c1 e0 02             	shl    $0x2,%eax
c0103d3f:	01 d0                	add    %edx,%eax
c0103d41:	c1 e0 02             	shl    $0x2,%eax
c0103d44:	01 c8                	add    %ecx,%eax
c0103d46:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d49:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d4c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103d52:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103d56:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103d5a:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103d5e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103d61:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103d64:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d68:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103d6c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103d70:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103d74:	c7 04 24 78 67 10 c0 	movl   $0xc0106778,(%esp)
c0103d7b:	e8 d6 c5 ff ff       	call   c0100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103d80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d83:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d86:	89 d0                	mov    %edx,%eax
c0103d88:	c1 e0 02             	shl    $0x2,%eax
c0103d8b:	01 d0                	add    %edx,%eax
c0103d8d:	c1 e0 02             	shl    $0x2,%eax
c0103d90:	01 c8                	add    %ecx,%eax
c0103d92:	83 c0 14             	add    $0x14,%eax
c0103d95:	8b 00                	mov    (%eax),%eax
c0103d97:	83 f8 01             	cmp    $0x1,%eax
c0103d9a:	75 2e                	jne    c0103dca <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
c0103d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103da2:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0103da5:	89 d0                	mov    %edx,%eax
c0103da7:	1b 45 9c             	sbb    -0x64(%ebp),%eax
c0103daa:	73 1e                	jae    c0103dca <page_init+0x142>
c0103dac:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
c0103db1:	b8 00 00 00 00       	mov    $0x0,%eax
c0103db6:	3b 55 a0             	cmp    -0x60(%ebp),%edx
c0103db9:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
c0103dbc:	72 0c                	jb     c0103dca <page_init+0x142>
                maxpa = end;
c0103dbe:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103dc1:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0103dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103dc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dca:	ff 45 dc             	incl   -0x24(%ebp)
c0103dcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103dd0:	8b 00                	mov    (%eax),%eax
c0103dd2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103dd5:	0f 8c e6 fe ff ff    	jl     c0103cc1 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103ddb:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103de0:	b8 00 00 00 00       	mov    $0x0,%eax
c0103de5:	3b 55 e0             	cmp    -0x20(%ebp),%edx
c0103de8:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
c0103deb:	73 0e                	jae    c0103dfb <page_init+0x173>
        maxpa = KMEMSIZE;
c0103ded:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103df4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e01:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103e05:	c1 ea 0c             	shr    $0xc,%edx
c0103e08:	a3 a4 be 11 c0       	mov    %eax,0xc011bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103e0d:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0103e14:	b8 2c bf 11 c0       	mov    $0xc011bf2c,%eax
c0103e19:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103e1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0103e1f:	01 d0                	add    %edx,%eax
c0103e21:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103e24:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e27:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e2c:	f7 75 c0             	divl   -0x40(%ebp)
c0103e2f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103e32:	29 d0                	sub    %edx,%eax
c0103e34:	a3 a0 be 11 c0       	mov    %eax,0xc011bea0

    for (i = 0; i < npage; i ++) {
c0103e39:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e40:	eb 2f                	jmp    c0103e71 <page_init+0x1e9>
        SetPageReserved(pages + i);
c0103e42:	8b 0d a0 be 11 c0    	mov    0xc011bea0,%ecx
c0103e48:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e4b:	89 d0                	mov    %edx,%eax
c0103e4d:	c1 e0 02             	shl    $0x2,%eax
c0103e50:	01 d0                	add    %edx,%eax
c0103e52:	c1 e0 02             	shl    $0x2,%eax
c0103e55:	01 c8                	add    %ecx,%eax
c0103e57:	83 c0 04             	add    $0x4,%eax
c0103e5a:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0103e61:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103e64:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103e67:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103e6a:	0f ab 10             	bts    %edx,(%eax)
}
c0103e6d:	90                   	nop
    for (i = 0; i < npage; i ++) {
c0103e6e:	ff 45 dc             	incl   -0x24(%ebp)
c0103e71:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e74:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0103e79:	39 c2                	cmp    %eax,%edx
c0103e7b:	72 c5                	jb     c0103e42 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103e7d:	8b 15 a4 be 11 c0    	mov    0xc011bea4,%edx
c0103e83:	89 d0                	mov    %edx,%eax
c0103e85:	c1 e0 02             	shl    $0x2,%eax
c0103e88:	01 d0                	add    %edx,%eax
c0103e8a:	c1 e0 02             	shl    $0x2,%eax
c0103e8d:	89 c2                	mov    %eax,%edx
c0103e8f:	a1 a0 be 11 c0       	mov    0xc011bea0,%eax
c0103e94:	01 d0                	add    %edx,%eax
c0103e96:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e99:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0103ea0:	77 23                	ja     c0103ec5 <page_init+0x23d>
c0103ea2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ea5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ea9:	c7 44 24 08 a8 67 10 	movl   $0xc01067a8,0x8(%esp)
c0103eb0:	c0 
c0103eb1:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103eb8:	00 
c0103eb9:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0103ec0:	e8 5e cd ff ff       	call   c0100c23 <__panic>
c0103ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ec8:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ecd:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103ed0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ed7:	e9 53 01 00 00       	jmp    c010402f <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103edc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103edf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ee2:	89 d0                	mov    %edx,%eax
c0103ee4:	c1 e0 02             	shl    $0x2,%eax
c0103ee7:	01 d0                	add    %edx,%eax
c0103ee9:	c1 e0 02             	shl    $0x2,%eax
c0103eec:	01 c8                	add    %ecx,%eax
c0103eee:	8b 50 08             	mov    0x8(%eax),%edx
c0103ef1:	8b 40 04             	mov    0x4(%eax),%eax
c0103ef4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ef7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103efa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103efd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f00:	89 d0                	mov    %edx,%eax
c0103f02:	c1 e0 02             	shl    $0x2,%eax
c0103f05:	01 d0                	add    %edx,%eax
c0103f07:	c1 e0 02             	shl    $0x2,%eax
c0103f0a:	01 c8                	add    %ecx,%eax
c0103f0c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f0f:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f12:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f15:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f18:	01 c8                	add    %ecx,%eax
c0103f1a:	11 da                	adc    %ebx,%edx
c0103f1c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103f1f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103f22:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f25:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f28:	89 d0                	mov    %edx,%eax
c0103f2a:	c1 e0 02             	shl    $0x2,%eax
c0103f2d:	01 d0                	add    %edx,%eax
c0103f2f:	c1 e0 02             	shl    $0x2,%eax
c0103f32:	01 c8                	add    %ecx,%eax
c0103f34:	83 c0 14             	add    $0x14,%eax
c0103f37:	8b 00                	mov    (%eax),%eax
c0103f39:	83 f8 01             	cmp    $0x1,%eax
c0103f3c:	0f 85 ea 00 00 00    	jne    c010402c <page_init+0x3a4>
            if (begin < freemem) {
c0103f42:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f45:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f4a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0103f4d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0103f50:	19 d1                	sbb    %edx,%ecx
c0103f52:	73 0d                	jae    c0103f61 <page_init+0x2d9>
                begin = freemem;
c0103f54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f57:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f5a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103f61:	ba 00 00 00 38       	mov    $0x38000000,%edx
c0103f66:	b8 00 00 00 00       	mov    $0x0,%eax
c0103f6b:	3b 55 c8             	cmp    -0x38(%ebp),%edx
c0103f6e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f71:	73 0e                	jae    c0103f81 <page_init+0x2f9>
                end = KMEMSIZE;
c0103f73:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103f7a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103f81:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f87:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103f8a:	89 d0                	mov    %edx,%eax
c0103f8c:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103f8f:	0f 83 97 00 00 00    	jae    c010402c <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
c0103f95:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0103f9c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103f9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103fa2:	01 d0                	add    %edx,%eax
c0103fa4:	48                   	dec    %eax
c0103fa5:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103fa8:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103fab:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fb0:	f7 75 b0             	divl   -0x50(%ebp)
c0103fb3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103fb6:	29 d0                	sub    %edx,%eax
c0103fb8:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fbd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fc0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103fc3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103fc6:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103fc9:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fcc:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fd1:	89 c7                	mov    %eax,%edi
c0103fd3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0103fd9:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0103fdc:	89 d0                	mov    %edx,%eax
c0103fde:	83 e0 00             	and    $0x0,%eax
c0103fe1:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103fe4:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103fe7:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103fea:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103fed:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0103ff0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ff3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ff6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103ff9:	89 d0                	mov    %edx,%eax
c0103ffb:	1b 45 cc             	sbb    -0x34(%ebp),%eax
c0103ffe:	73 2c                	jae    c010402c <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104000:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104003:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104006:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0104009:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c010400c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104010:	c1 ea 0c             	shr    $0xc,%edx
c0104013:	89 c3                	mov    %eax,%ebx
c0104015:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104018:	89 04 24             	mov    %eax,(%esp)
c010401b:	e8 c9 f8 ff ff       	call   c01038e9 <pa2page>
c0104020:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104024:	89 04 24             	mov    %eax,(%esp)
c0104027:	e8 9e fb ff ff       	call   c0103bca <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010402c:	ff 45 dc             	incl   -0x24(%ebp)
c010402f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104032:	8b 00                	mov    (%eax),%eax
c0104034:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104037:	0f 8c 9f fe ff ff    	jl     c0103edc <page_init+0x254>
                }
            }
        }
    }
}
c010403d:	90                   	nop
c010403e:	90                   	nop
c010403f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104045:	5b                   	pop    %ebx
c0104046:	5e                   	pop    %esi
c0104047:	5f                   	pop    %edi
c0104048:	5d                   	pop    %ebp
c0104049:	c3                   	ret    

c010404a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010404a:	55                   	push   %ebp
c010404b:	89 e5                	mov    %esp,%ebp
c010404d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104050:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104053:	33 45 14             	xor    0x14(%ebp),%eax
c0104056:	25 ff 0f 00 00       	and    $0xfff,%eax
c010405b:	85 c0                	test   %eax,%eax
c010405d:	74 24                	je     c0104083 <boot_map_segment+0x39>
c010405f:	c7 44 24 0c da 67 10 	movl   $0xc01067da,0xc(%esp)
c0104066:	c0 
c0104067:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010406e:	c0 
c010406f:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104076:	00 
c0104077:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010407e:	e8 a0 cb ff ff       	call   c0100c23 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104083:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010408d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104092:	89 c2                	mov    %eax,%edx
c0104094:	8b 45 10             	mov    0x10(%ebp),%eax
c0104097:	01 c2                	add    %eax,%edx
c0104099:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010409c:	01 d0                	add    %edx,%eax
c010409e:	48                   	dec    %eax
c010409f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01040a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040a5:	ba 00 00 00 00       	mov    $0x0,%edx
c01040aa:	f7 75 f0             	divl   -0x10(%ebp)
c01040ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040b0:	29 d0                	sub    %edx,%eax
c01040b2:	c1 e8 0c             	shr    $0xc,%eax
c01040b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01040b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01040be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01040c6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01040c9:	8b 45 14             	mov    0x14(%ebp),%eax
c01040cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01040d7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01040da:	eb 68                	jmp    c0104144 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01040dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01040e3:	00 
c01040e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01040e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01040eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01040ee:	89 04 24             	mov    %eax,(%esp)
c01040f1:	e8 88 01 00 00       	call   c010427e <get_pte>
c01040f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01040f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01040fd:	75 24                	jne    c0104123 <boot_map_segment+0xd9>
c01040ff:	c7 44 24 0c 06 68 10 	movl   $0xc0106806,0xc(%esp)
c0104106:	c0 
c0104107:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010410e:	c0 
c010410f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104116:	00 
c0104117:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010411e:	e8 00 cb ff ff       	call   c0100c23 <__panic>
        *ptep = pa | PTE_P | perm;
c0104123:	8b 45 14             	mov    0x14(%ebp),%eax
c0104126:	0b 45 18             	or     0x18(%ebp),%eax
c0104129:	83 c8 01             	or     $0x1,%eax
c010412c:	89 c2                	mov    %eax,%edx
c010412e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104131:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104133:	ff 4d f4             	decl   -0xc(%ebp)
c0104136:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010413d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104148:	75 92                	jne    c01040dc <boot_map_segment+0x92>
    }
}
c010414a:	90                   	nop
c010414b:	90                   	nop
c010414c:	89 ec                	mov    %ebp,%esp
c010414e:	5d                   	pop    %ebp
c010414f:	c3                   	ret    

c0104150 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104150:	55                   	push   %ebp
c0104151:	89 e5                	mov    %esp,%ebp
c0104153:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104156:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010415d:	e8 8a fa ff ff       	call   c0103bec <alloc_pages>
c0104162:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104169:	75 1c                	jne    c0104187 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010416b:	c7 44 24 08 13 68 10 	movl   $0xc0106813,0x8(%esp)
c0104172:	c0 
c0104173:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010417a:	00 
c010417b:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104182:	e8 9c ca ff ff       	call   c0100c23 <__panic>
    }
    return page2kva(p);
c0104187:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010418a:	89 04 24             	mov    %eax,(%esp)
c010418d:	e8 a8 f7 ff ff       	call   c010393a <page2kva>
}
c0104192:	89 ec                	mov    %ebp,%esp
c0104194:	5d                   	pop    %ebp
c0104195:	c3                   	ret    

c0104196 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104196:	55                   	push   %ebp
c0104197:	89 e5                	mov    %esp,%ebp
c0104199:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010419c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01041a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01041a4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01041ab:	77 23                	ja     c01041d0 <pmm_init+0x3a>
c01041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01041b4:	c7 44 24 08 a8 67 10 	movl   $0xc01067a8,0x8(%esp)
c01041bb:	c0 
c01041bc:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01041c3:	00 
c01041c4:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01041cb:	e8 53 ca ff ff       	call   c0100c23 <__panic>
c01041d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01041d3:	05 00 00 00 40       	add    $0x40000000,%eax
c01041d8:	a3 a8 be 11 c0       	mov    %eax,0xc011bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01041dd:	e8 b2 f9 ff ff       	call   c0103b94 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01041e2:	e8 a1 fa ff ff       	call   c0103c88 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01041e7:	e8 5a 02 00 00       	call   c0104446 <check_alloc_page>

    check_pgdir();
c01041ec:	e8 76 02 00 00       	call   c0104467 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01041f1:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01041f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01041f9:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104200:	77 23                	ja     c0104225 <pmm_init+0x8f>
c0104202:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104205:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104209:	c7 44 24 08 a8 67 10 	movl   $0xc01067a8,0x8(%esp)
c0104210:	c0 
c0104211:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104218:	00 
c0104219:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104220:	e8 fe c9 ff ff       	call   c0100c23 <__panic>
c0104225:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104228:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c010422e:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104233:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104238:	83 ca 03             	or     $0x3,%edx
c010423b:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010423d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104242:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104249:	00 
c010424a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104251:	00 
c0104252:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104259:	38 
c010425a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104261:	c0 
c0104262:	89 04 24             	mov    %eax,(%esp)
c0104265:	e8 e0 fd ff ff       	call   c010404a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010426a:	e8 39 f8 ff ff       	call   c0103aa8 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010426f:	e8 91 08 00 00       	call   c0104b05 <check_boot_pgdir>

    print_pgdir();
c0104274:	e8 0e 0d 00 00       	call   c0104f87 <print_pgdir>

}
c0104279:	90                   	nop
c010427a:	89 ec                	mov    %ebp,%esp
c010427c:	5d                   	pop    %ebp
c010427d:	c3                   	ret    

c010427e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010427e:	55                   	push   %ebp
c010427f:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0104281:	90                   	nop
c0104282:	5d                   	pop    %ebp
c0104283:	c3                   	ret    

c0104284 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104284:	55                   	push   %ebp
c0104285:	89 e5                	mov    %esp,%ebp
c0104287:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010428a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104291:	00 
c0104292:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104295:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104299:	8b 45 08             	mov    0x8(%ebp),%eax
c010429c:	89 04 24             	mov    %eax,(%esp)
c010429f:	e8 da ff ff ff       	call   c010427e <get_pte>
c01042a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01042a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01042ab:	74 08                	je     c01042b5 <get_page+0x31>
        *ptep_store = ptep;
c01042ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01042b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01042b3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01042b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042b9:	74 1b                	je     c01042d6 <get_page+0x52>
c01042bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042be:	8b 00                	mov    (%eax),%eax
c01042c0:	83 e0 01             	and    $0x1,%eax
c01042c3:	85 c0                	test   %eax,%eax
c01042c5:	74 0f                	je     c01042d6 <get_page+0x52>
        return pte2page(*ptep);
c01042c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042ca:	8b 00                	mov    (%eax),%eax
c01042cc:	89 04 24             	mov    %eax,(%esp)
c01042cf:	e8 bc f6 ff ff       	call   c0103990 <pte2page>
c01042d4:	eb 05                	jmp    c01042db <get_page+0x57>
    }
    return NULL;
c01042d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01042db:	89 ec                	mov    %ebp,%esp
c01042dd:	5d                   	pop    %ebp
c01042de:	c3                   	ret    

c01042df <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01042df:	55                   	push   %ebp
c01042e0:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01042e2:	90                   	nop
c01042e3:	5d                   	pop    %ebp
c01042e4:	c3                   	ret    

c01042e5 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01042e5:	55                   	push   %ebp
c01042e6:	89 e5                	mov    %esp,%ebp
c01042e8:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01042eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01042f2:	00 
c01042f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01042fd:	89 04 24             	mov    %eax,(%esp)
c0104300:	e8 79 ff ff ff       	call   c010427e <get_pte>
c0104305:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104308:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010430c:	74 19                	je     c0104327 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010430e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104311:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104315:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104318:	89 44 24 04          	mov    %eax,0x4(%esp)
c010431c:	8b 45 08             	mov    0x8(%ebp),%eax
c010431f:	89 04 24             	mov    %eax,(%esp)
c0104322:	e8 b8 ff ff ff       	call   c01042df <page_remove_pte>
    }
}
c0104327:	90                   	nop
c0104328:	89 ec                	mov    %ebp,%esp
c010432a:	5d                   	pop    %ebp
c010432b:	c3                   	ret    

c010432c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010432c:	55                   	push   %ebp
c010432d:	89 e5                	mov    %esp,%ebp
c010432f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104332:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104339:	00 
c010433a:	8b 45 10             	mov    0x10(%ebp),%eax
c010433d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104341:	8b 45 08             	mov    0x8(%ebp),%eax
c0104344:	89 04 24             	mov    %eax,(%esp)
c0104347:	e8 32 ff ff ff       	call   c010427e <get_pte>
c010434c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010434f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104353:	75 0a                	jne    c010435f <page_insert+0x33>
        return -E_NO_MEM;
c0104355:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010435a:	e9 84 00 00 00       	jmp    c01043e3 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010435f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104362:	89 04 24             	mov    %eax,(%esp)
c0104365:	e8 8a f6 ff ff       	call   c01039f4 <page_ref_inc>
    if (*ptep & PTE_P) {
c010436a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010436d:	8b 00                	mov    (%eax),%eax
c010436f:	83 e0 01             	and    $0x1,%eax
c0104372:	85 c0                	test   %eax,%eax
c0104374:	74 3e                	je     c01043b4 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104376:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104379:	8b 00                	mov    (%eax),%eax
c010437b:	89 04 24             	mov    %eax,(%esp)
c010437e:	e8 0d f6 ff ff       	call   c0103990 <pte2page>
c0104383:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104386:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104389:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010438c:	75 0d                	jne    c010439b <page_insert+0x6f>
            page_ref_dec(page);
c010438e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104391:	89 04 24             	mov    %eax,(%esp)
c0104394:	e8 72 f6 ff ff       	call   c0103a0b <page_ref_dec>
c0104399:	eb 19                	jmp    c01043b4 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010439b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439e:	89 44 24 08          	mov    %eax,0x8(%esp)
c01043a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01043a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01043ac:	89 04 24             	mov    %eax,(%esp)
c01043af:	e8 2b ff ff ff       	call   c01042df <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01043b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043b7:	89 04 24             	mov    %eax,(%esp)
c01043ba:	e8 12 f5 ff ff       	call   c01038d1 <page2pa>
c01043bf:	0b 45 14             	or     0x14(%ebp),%eax
c01043c2:	83 c8 01             	or     $0x1,%eax
c01043c5:	89 c2                	mov    %eax,%edx
c01043c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043ca:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01043cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01043cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01043d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d6:	89 04 24             	mov    %eax,(%esp)
c01043d9:	e8 09 00 00 00       	call   c01043e7 <tlb_invalidate>
    return 0;
c01043de:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01043e3:	89 ec                	mov    %ebp,%esp
c01043e5:	5d                   	pop    %ebp
c01043e6:	c3                   	ret    

c01043e7 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01043e7:	55                   	push   %ebp
c01043e8:	89 e5                	mov    %esp,%ebp
c01043ea:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01043ed:	0f 20 d8             	mov    %cr3,%eax
c01043f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01043f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c01043f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043fc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104403:	77 23                	ja     c0104428 <tlb_invalidate+0x41>
c0104405:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104408:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010440c:	c7 44 24 08 a8 67 10 	movl   $0xc01067a8,0x8(%esp)
c0104413:	c0 
c0104414:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c010441b:	00 
c010441c:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104423:	e8 fb c7 ff ff       	call   c0100c23 <__panic>
c0104428:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010442b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104430:	39 d0                	cmp    %edx,%eax
c0104432:	75 0d                	jne    c0104441 <tlb_invalidate+0x5a>
        invlpg((void *)la);
c0104434:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104437:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010443a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010443d:	0f 01 38             	invlpg (%eax)
}
c0104440:	90                   	nop
    }
}
c0104441:	90                   	nop
c0104442:	89 ec                	mov    %ebp,%esp
c0104444:	5d                   	pop    %ebp
c0104445:	c3                   	ret    

c0104446 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104446:	55                   	push   %ebp
c0104447:	89 e5                	mov    %esp,%ebp
c0104449:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010444c:	a1 ac be 11 c0       	mov    0xc011beac,%eax
c0104451:	8b 40 18             	mov    0x18(%eax),%eax
c0104454:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104456:	c7 04 24 2c 68 10 c0 	movl   $0xc010682c,(%esp)
c010445d:	e8 f4 be ff ff       	call   c0100356 <cprintf>
}
c0104462:	90                   	nop
c0104463:	89 ec                	mov    %ebp,%esp
c0104465:	5d                   	pop    %ebp
c0104466:	c3                   	ret    

c0104467 <check_pgdir>:

static void
check_pgdir(void) {
c0104467:	55                   	push   %ebp
c0104468:	89 e5                	mov    %esp,%ebp
c010446a:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010446d:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104472:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104477:	76 24                	jbe    c010449d <check_pgdir+0x36>
c0104479:	c7 44 24 0c 4b 68 10 	movl   $0xc010684b,0xc(%esp)
c0104480:	c0 
c0104481:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104488:	c0 
c0104489:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c0104490:	00 
c0104491:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104498:	e8 86 c7 ff ff       	call   c0100c23 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010449d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044a2:	85 c0                	test   %eax,%eax
c01044a4:	74 0e                	je     c01044b4 <check_pgdir+0x4d>
c01044a6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044ab:	25 ff 0f 00 00       	and    $0xfff,%eax
c01044b0:	85 c0                	test   %eax,%eax
c01044b2:	74 24                	je     c01044d8 <check_pgdir+0x71>
c01044b4:	c7 44 24 0c 68 68 10 	movl   $0xc0106868,0xc(%esp)
c01044bb:	c0 
c01044bc:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01044c3:	c0 
c01044c4:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c01044cb:	00 
c01044cc:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01044d3:	e8 4b c7 ff ff       	call   c0100c23 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01044d8:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01044dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044e4:	00 
c01044e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044ec:	00 
c01044ed:	89 04 24             	mov    %eax,(%esp)
c01044f0:	e8 8f fd ff ff       	call   c0104284 <get_page>
c01044f5:	85 c0                	test   %eax,%eax
c01044f7:	74 24                	je     c010451d <check_pgdir+0xb6>
c01044f9:	c7 44 24 0c a0 68 10 	movl   $0xc01068a0,0xc(%esp)
c0104500:	c0 
c0104501:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104508:	c0 
c0104509:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c0104510:	00 
c0104511:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104518:	e8 06 c7 ff ff       	call   c0100c23 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010451d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104524:	e8 c3 f6 ff ff       	call   c0103bec <alloc_pages>
c0104529:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010452c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104531:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104538:	00 
c0104539:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104540:	00 
c0104541:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104544:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104548:	89 04 24             	mov    %eax,(%esp)
c010454b:	e8 dc fd ff ff       	call   c010432c <page_insert>
c0104550:	85 c0                	test   %eax,%eax
c0104552:	74 24                	je     c0104578 <check_pgdir+0x111>
c0104554:	c7 44 24 0c c8 68 10 	movl   $0xc01068c8,0xc(%esp)
c010455b:	c0 
c010455c:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104563:	c0 
c0104564:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c010456b:	00 
c010456c:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104573:	e8 ab c6 ff ff       	call   c0100c23 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104578:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c010457d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104584:	00 
c0104585:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010458c:	00 
c010458d:	89 04 24             	mov    %eax,(%esp)
c0104590:	e8 e9 fc ff ff       	call   c010427e <get_pte>
c0104595:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104598:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010459c:	75 24                	jne    c01045c2 <check_pgdir+0x15b>
c010459e:	c7 44 24 0c f4 68 10 	movl   $0xc01068f4,0xc(%esp)
c01045a5:	c0 
c01045a6:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01045ad:	c0 
c01045ae:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c01045b5:	00 
c01045b6:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01045bd:	e8 61 c6 ff ff       	call   c0100c23 <__panic>
    assert(pte2page(*ptep) == p1);
c01045c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045c5:	8b 00                	mov    (%eax),%eax
c01045c7:	89 04 24             	mov    %eax,(%esp)
c01045ca:	e8 c1 f3 ff ff       	call   c0103990 <pte2page>
c01045cf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01045d2:	74 24                	je     c01045f8 <check_pgdir+0x191>
c01045d4:	c7 44 24 0c 21 69 10 	movl   $0xc0106921,0xc(%esp)
c01045db:	c0 
c01045dc:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01045e3:	c0 
c01045e4:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c01045eb:	00 
c01045ec:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01045f3:	e8 2b c6 ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p1) == 1);
c01045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045fb:	89 04 24             	mov    %eax,(%esp)
c01045fe:	e8 e7 f3 ff ff       	call   c01039ea <page_ref>
c0104603:	83 f8 01             	cmp    $0x1,%eax
c0104606:	74 24                	je     c010462c <check_pgdir+0x1c5>
c0104608:	c7 44 24 0c 37 69 10 	movl   $0xc0106937,0xc(%esp)
c010460f:	c0 
c0104610:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104617:	c0 
c0104618:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c010461f:	00 
c0104620:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104627:	e8 f7 c5 ff ff       	call   c0100c23 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010462c:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104631:	8b 00                	mov    (%eax),%eax
c0104633:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104638:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010463b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010463e:	c1 e8 0c             	shr    $0xc,%eax
c0104641:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104644:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104649:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010464c:	72 23                	jb     c0104671 <check_pgdir+0x20a>
c010464e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104651:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104655:	c7 44 24 08 04 67 10 	movl   $0xc0106704,0x8(%esp)
c010465c:	c0 
c010465d:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0104664:	00 
c0104665:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010466c:	e8 b2 c5 ff ff       	call   c0100c23 <__panic>
c0104671:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104674:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104679:	83 c0 04             	add    $0x4,%eax
c010467c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010467f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104684:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010468b:	00 
c010468c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104693:	00 
c0104694:	89 04 24             	mov    %eax,(%esp)
c0104697:	e8 e2 fb ff ff       	call   c010427e <get_pte>
c010469c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010469f:	74 24                	je     c01046c5 <check_pgdir+0x25e>
c01046a1:	c7 44 24 0c 4c 69 10 	movl   $0xc010694c,0xc(%esp)
c01046a8:	c0 
c01046a9:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01046b0:	c0 
c01046b1:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c01046b8:	00 
c01046b9:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01046c0:	e8 5e c5 ff ff       	call   c0100c23 <__panic>

    p2 = alloc_page();
c01046c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046cc:	e8 1b f5 ff ff       	call   c0103bec <alloc_pages>
c01046d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01046d4:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01046d9:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01046e0:	00 
c01046e1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01046e8:	00 
c01046e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01046ec:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046f0:	89 04 24             	mov    %eax,(%esp)
c01046f3:	e8 34 fc ff ff       	call   c010432c <page_insert>
c01046f8:	85 c0                	test   %eax,%eax
c01046fa:	74 24                	je     c0104720 <check_pgdir+0x2b9>
c01046fc:	c7 44 24 0c 74 69 10 	movl   $0xc0106974,0xc(%esp)
c0104703:	c0 
c0104704:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010470b:	c0 
c010470c:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0104713:	00 
c0104714:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010471b:	e8 03 c5 ff ff       	call   c0100c23 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104720:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104725:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010472c:	00 
c010472d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104734:	00 
c0104735:	89 04 24             	mov    %eax,(%esp)
c0104738:	e8 41 fb ff ff       	call   c010427e <get_pte>
c010473d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104744:	75 24                	jne    c010476a <check_pgdir+0x303>
c0104746:	c7 44 24 0c ac 69 10 	movl   $0xc01069ac,0xc(%esp)
c010474d:	c0 
c010474e:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104755:	c0 
c0104756:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c010475d:	00 
c010475e:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104765:	e8 b9 c4 ff ff       	call   c0100c23 <__panic>
    assert(*ptep & PTE_U);
c010476a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010476d:	8b 00                	mov    (%eax),%eax
c010476f:	83 e0 04             	and    $0x4,%eax
c0104772:	85 c0                	test   %eax,%eax
c0104774:	75 24                	jne    c010479a <check_pgdir+0x333>
c0104776:	c7 44 24 0c dc 69 10 	movl   $0xc01069dc,0xc(%esp)
c010477d:	c0 
c010477e:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104785:	c0 
c0104786:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c010478d:	00 
c010478e:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104795:	e8 89 c4 ff ff       	call   c0100c23 <__panic>
    assert(*ptep & PTE_W);
c010479a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010479d:	8b 00                	mov    (%eax),%eax
c010479f:	83 e0 02             	and    $0x2,%eax
c01047a2:	85 c0                	test   %eax,%eax
c01047a4:	75 24                	jne    c01047ca <check_pgdir+0x363>
c01047a6:	c7 44 24 0c ea 69 10 	movl   $0xc01069ea,0xc(%esp)
c01047ad:	c0 
c01047ae:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01047b5:	c0 
c01047b6:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01047bd:	00 
c01047be:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01047c5:	e8 59 c4 ff ff       	call   c0100c23 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01047ca:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01047cf:	8b 00                	mov    (%eax),%eax
c01047d1:	83 e0 04             	and    $0x4,%eax
c01047d4:	85 c0                	test   %eax,%eax
c01047d6:	75 24                	jne    c01047fc <check_pgdir+0x395>
c01047d8:	c7 44 24 0c f8 69 10 	movl   $0xc01069f8,0xc(%esp)
c01047df:	c0 
c01047e0:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01047e7:	c0 
c01047e8:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01047ef:	00 
c01047f0:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01047f7:	e8 27 c4 ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p2) == 1);
c01047fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01047ff:	89 04 24             	mov    %eax,(%esp)
c0104802:	e8 e3 f1 ff ff       	call   c01039ea <page_ref>
c0104807:	83 f8 01             	cmp    $0x1,%eax
c010480a:	74 24                	je     c0104830 <check_pgdir+0x3c9>
c010480c:	c7 44 24 0c 0e 6a 10 	movl   $0xc0106a0e,0xc(%esp)
c0104813:	c0 
c0104814:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010481b:	c0 
c010481c:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104823:	00 
c0104824:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010482b:	e8 f3 c3 ff ff       	call   c0100c23 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104830:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104835:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010483c:	00 
c010483d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104844:	00 
c0104845:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104848:	89 54 24 04          	mov    %edx,0x4(%esp)
c010484c:	89 04 24             	mov    %eax,(%esp)
c010484f:	e8 d8 fa ff ff       	call   c010432c <page_insert>
c0104854:	85 c0                	test   %eax,%eax
c0104856:	74 24                	je     c010487c <check_pgdir+0x415>
c0104858:	c7 44 24 0c 20 6a 10 	movl   $0xc0106a20,0xc(%esp)
c010485f:	c0 
c0104860:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104867:	c0 
c0104868:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c010486f:	00 
c0104870:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104877:	e8 a7 c3 ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p1) == 2);
c010487c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487f:	89 04 24             	mov    %eax,(%esp)
c0104882:	e8 63 f1 ff ff       	call   c01039ea <page_ref>
c0104887:	83 f8 02             	cmp    $0x2,%eax
c010488a:	74 24                	je     c01048b0 <check_pgdir+0x449>
c010488c:	c7 44 24 0c 4c 6a 10 	movl   $0xc0106a4c,0xc(%esp)
c0104893:	c0 
c0104894:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010489b:	c0 
c010489c:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c01048a3:	00 
c01048a4:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01048ab:	e8 73 c3 ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p2) == 0);
c01048b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01048b3:	89 04 24             	mov    %eax,(%esp)
c01048b6:	e8 2f f1 ff ff       	call   c01039ea <page_ref>
c01048bb:	85 c0                	test   %eax,%eax
c01048bd:	74 24                	je     c01048e3 <check_pgdir+0x47c>
c01048bf:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c01048c6:	c0 
c01048c7:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01048ce:	c0 
c01048cf:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c01048d6:	00 
c01048d7:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01048de:	e8 40 c3 ff ff       	call   c0100c23 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01048e3:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c01048e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048ef:	00 
c01048f0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048f7:	00 
c01048f8:	89 04 24             	mov    %eax,(%esp)
c01048fb:	e8 7e f9 ff ff       	call   c010427e <get_pte>
c0104900:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104907:	75 24                	jne    c010492d <check_pgdir+0x4c6>
c0104909:	c7 44 24 0c ac 69 10 	movl   $0xc01069ac,0xc(%esp)
c0104910:	c0 
c0104911:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104918:	c0 
c0104919:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104920:	00 
c0104921:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104928:	e8 f6 c2 ff ff       	call   c0100c23 <__panic>
    assert(pte2page(*ptep) == p1);
c010492d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104930:	8b 00                	mov    (%eax),%eax
c0104932:	89 04 24             	mov    %eax,(%esp)
c0104935:	e8 56 f0 ff ff       	call   c0103990 <pte2page>
c010493a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010493d:	74 24                	je     c0104963 <check_pgdir+0x4fc>
c010493f:	c7 44 24 0c 21 69 10 	movl   $0xc0106921,0xc(%esp)
c0104946:	c0 
c0104947:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010494e:	c0 
c010494f:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104956:	00 
c0104957:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010495e:	e8 c0 c2 ff ff       	call   c0100c23 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104963:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104966:	8b 00                	mov    (%eax),%eax
c0104968:	83 e0 04             	and    $0x4,%eax
c010496b:	85 c0                	test   %eax,%eax
c010496d:	74 24                	je     c0104993 <check_pgdir+0x52c>
c010496f:	c7 44 24 0c 70 6a 10 	movl   $0xc0106a70,0xc(%esp)
c0104976:	c0 
c0104977:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c010497e:	c0 
c010497f:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104986:	00 
c0104987:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c010498e:	e8 90 c2 ff ff       	call   c0100c23 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104993:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104998:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010499f:	00 
c01049a0:	89 04 24             	mov    %eax,(%esp)
c01049a3:	e8 3d f9 ff ff       	call   c01042e5 <page_remove>
    assert(page_ref(p1) == 1);
c01049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ab:	89 04 24             	mov    %eax,(%esp)
c01049ae:	e8 37 f0 ff ff       	call   c01039ea <page_ref>
c01049b3:	83 f8 01             	cmp    $0x1,%eax
c01049b6:	74 24                	je     c01049dc <check_pgdir+0x575>
c01049b8:	c7 44 24 0c 37 69 10 	movl   $0xc0106937,0xc(%esp)
c01049bf:	c0 
c01049c0:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01049c7:	c0 
c01049c8:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c01049cf:	00 
c01049d0:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c01049d7:	e8 47 c2 ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p2) == 0);
c01049dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049df:	89 04 24             	mov    %eax,(%esp)
c01049e2:	e8 03 f0 ff ff       	call   c01039ea <page_ref>
c01049e7:	85 c0                	test   %eax,%eax
c01049e9:	74 24                	je     c0104a0f <check_pgdir+0x5a8>
c01049eb:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c01049f2:	c0 
c01049f3:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c01049fa:	c0 
c01049fb:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104a02:	00 
c0104a03:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104a0a:	e8 14 c2 ff ff       	call   c0100c23 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104a0f:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a14:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a1b:	00 
c0104a1c:	89 04 24             	mov    %eax,(%esp)
c0104a1f:	e8 c1 f8 ff ff       	call   c01042e5 <page_remove>
    assert(page_ref(p1) == 0);
c0104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a27:	89 04 24             	mov    %eax,(%esp)
c0104a2a:	e8 bb ef ff ff       	call   c01039ea <page_ref>
c0104a2f:	85 c0                	test   %eax,%eax
c0104a31:	74 24                	je     c0104a57 <check_pgdir+0x5f0>
c0104a33:	c7 44 24 0c 85 6a 10 	movl   $0xc0106a85,0xc(%esp)
c0104a3a:	c0 
c0104a3b:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104a42:	c0 
c0104a43:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104a4a:	00 
c0104a4b:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104a52:	e8 cc c1 ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p2) == 0);
c0104a57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a5a:	89 04 24             	mov    %eax,(%esp)
c0104a5d:	e8 88 ef ff ff       	call   c01039ea <page_ref>
c0104a62:	85 c0                	test   %eax,%eax
c0104a64:	74 24                	je     c0104a8a <check_pgdir+0x623>
c0104a66:	c7 44 24 0c 5e 6a 10 	movl   $0xc0106a5e,0xc(%esp)
c0104a6d:	c0 
c0104a6e:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104a75:	c0 
c0104a76:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104a7d:	00 
c0104a7e:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104a85:	e8 99 c1 ff ff       	call   c0100c23 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104a8a:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104a8f:	8b 00                	mov    (%eax),%eax
c0104a91:	89 04 24             	mov    %eax,(%esp)
c0104a94:	e8 37 ef ff ff       	call   c01039d0 <pde2page>
c0104a99:	89 04 24             	mov    %eax,(%esp)
c0104a9c:	e8 49 ef ff ff       	call   c01039ea <page_ref>
c0104aa1:	83 f8 01             	cmp    $0x1,%eax
c0104aa4:	74 24                	je     c0104aca <check_pgdir+0x663>
c0104aa6:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c0104aad:	c0 
c0104aae:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104ab5:	c0 
c0104ab6:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104abd:	00 
c0104abe:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104ac5:	e8 59 c1 ff ff       	call   c0100c23 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104aca:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104acf:	8b 00                	mov    (%eax),%eax
c0104ad1:	89 04 24             	mov    %eax,(%esp)
c0104ad4:	e8 f7 ee ff ff       	call   c01039d0 <pde2page>
c0104ad9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ae0:	00 
c0104ae1:	89 04 24             	mov    %eax,(%esp)
c0104ae4:	e8 3d f1 ff ff       	call   c0103c26 <free_pages>
    boot_pgdir[0] = 0;
c0104ae9:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104af4:	c7 04 24 bf 6a 10 c0 	movl   $0xc0106abf,(%esp)
c0104afb:	e8 56 b8 ff ff       	call   c0100356 <cprintf>
}
c0104b00:	90                   	nop
c0104b01:	89 ec                	mov    %ebp,%esp
c0104b03:	5d                   	pop    %ebp
c0104b04:	c3                   	ret    

c0104b05 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104b05:	55                   	push   %ebp
c0104b06:	89 e5                	mov    %esp,%ebp
c0104b08:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104b12:	e9 ca 00 00 00       	jmp    c0104be1 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b20:	c1 e8 0c             	shr    $0xc,%eax
c0104b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104b26:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104b2b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104b2e:	72 23                	jb     c0104b53 <check_boot_pgdir+0x4e>
c0104b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b37:	c7 44 24 08 04 67 10 	movl   $0xc0106704,0x8(%esp)
c0104b3e:	c0 
c0104b3f:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104b46:	00 
c0104b47:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104b4e:	e8 d0 c0 ff ff       	call   c0100c23 <__panic>
c0104b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b56:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b5b:	89 c2                	mov    %eax,%edx
c0104b5d:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104b62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b69:	00 
c0104b6a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b6e:	89 04 24             	mov    %eax,(%esp)
c0104b71:	e8 08 f7 ff ff       	call   c010427e <get_pte>
c0104b76:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104b79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104b7d:	75 24                	jne    c0104ba3 <check_boot_pgdir+0x9e>
c0104b7f:	c7 44 24 0c dc 6a 10 	movl   $0xc0106adc,0xc(%esp)
c0104b86:	c0 
c0104b87:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104b8e:	c0 
c0104b8f:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104b96:	00 
c0104b97:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104b9e:	e8 80 c0 ff ff       	call   c0100c23 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ba3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104ba6:	8b 00                	mov    (%eax),%eax
c0104ba8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bad:	89 c2                	mov    %eax,%edx
c0104baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bb2:	39 c2                	cmp    %eax,%edx
c0104bb4:	74 24                	je     c0104bda <check_boot_pgdir+0xd5>
c0104bb6:	c7 44 24 0c 19 6b 10 	movl   $0xc0106b19,0xc(%esp)
c0104bbd:	c0 
c0104bbe:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104bc5:	c0 
c0104bc6:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104bcd:	00 
c0104bce:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104bd5:	e8 49 c0 ff ff       	call   c0100c23 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0104bda:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104be4:	a1 a4 be 11 c0       	mov    0xc011bea4,%eax
c0104be9:	39 c2                	cmp    %eax,%edx
c0104beb:	0f 82 26 ff ff ff    	jb     c0104b17 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104bf1:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104bf6:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104bfb:	8b 00                	mov    (%eax),%eax
c0104bfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104c02:	89 c2                	mov    %eax,%edx
c0104c04:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c0c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104c13:	77 23                	ja     c0104c38 <check_boot_pgdir+0x133>
c0104c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c18:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c1c:	c7 44 24 08 a8 67 10 	movl   $0xc01067a8,0x8(%esp)
c0104c23:	c0 
c0104c24:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104c2b:	00 
c0104c2c:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104c33:	e8 eb bf ff ff       	call   c0100c23 <__panic>
c0104c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c3b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104c40:	39 d0                	cmp    %edx,%eax
c0104c42:	74 24                	je     c0104c68 <check_boot_pgdir+0x163>
c0104c44:	c7 44 24 0c 30 6b 10 	movl   $0xc0106b30,0xc(%esp)
c0104c4b:	c0 
c0104c4c:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104c53:	c0 
c0104c54:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104c5b:	00 
c0104c5c:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104c63:	e8 bb bf ff ff       	call   c0100c23 <__panic>

    assert(boot_pgdir[0] == 0);
c0104c68:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104c6d:	8b 00                	mov    (%eax),%eax
c0104c6f:	85 c0                	test   %eax,%eax
c0104c71:	74 24                	je     c0104c97 <check_boot_pgdir+0x192>
c0104c73:	c7 44 24 0c 64 6b 10 	movl   $0xc0106b64,0xc(%esp)
c0104c7a:	c0 
c0104c7b:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104c82:	c0 
c0104c83:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104c8a:	00 
c0104c8b:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104c92:	e8 8c bf ff ff       	call   c0100c23 <__panic>

    struct Page *p;
    p = alloc_page();
c0104c97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c9e:	e8 49 ef ff ff       	call   c0103bec <alloc_pages>
c0104ca3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104ca6:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104cab:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104cb2:	00 
c0104cb3:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104cba:	00 
c0104cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104cbe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cc2:	89 04 24             	mov    %eax,(%esp)
c0104cc5:	e8 62 f6 ff ff       	call   c010432c <page_insert>
c0104cca:	85 c0                	test   %eax,%eax
c0104ccc:	74 24                	je     c0104cf2 <check_boot_pgdir+0x1ed>
c0104cce:	c7 44 24 0c 78 6b 10 	movl   $0xc0106b78,0xc(%esp)
c0104cd5:	c0 
c0104cd6:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104cdd:	c0 
c0104cde:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ce5:	00 
c0104ce6:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104ced:	e8 31 bf ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p) == 1);
c0104cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cf5:	89 04 24             	mov    %eax,(%esp)
c0104cf8:	e8 ed ec ff ff       	call   c01039ea <page_ref>
c0104cfd:	83 f8 01             	cmp    $0x1,%eax
c0104d00:	74 24                	je     c0104d26 <check_boot_pgdir+0x221>
c0104d02:	c7 44 24 0c a6 6b 10 	movl   $0xc0106ba6,0xc(%esp)
c0104d09:	c0 
c0104d0a:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104d11:	c0 
c0104d12:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104d19:	00 
c0104d1a:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104d21:	e8 fd be ff ff       	call   c0100c23 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104d26:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104d2b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104d32:	00 
c0104d33:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104d3a:	00 
c0104d3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104d3e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d42:	89 04 24             	mov    %eax,(%esp)
c0104d45:	e8 e2 f5 ff ff       	call   c010432c <page_insert>
c0104d4a:	85 c0                	test   %eax,%eax
c0104d4c:	74 24                	je     c0104d72 <check_boot_pgdir+0x26d>
c0104d4e:	c7 44 24 0c b8 6b 10 	movl   $0xc0106bb8,0xc(%esp)
c0104d55:	c0 
c0104d56:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104d5d:	c0 
c0104d5e:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104d65:	00 
c0104d66:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104d6d:	e8 b1 be ff ff       	call   c0100c23 <__panic>
    assert(page_ref(p) == 2);
c0104d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d75:	89 04 24             	mov    %eax,(%esp)
c0104d78:	e8 6d ec ff ff       	call   c01039ea <page_ref>
c0104d7d:	83 f8 02             	cmp    $0x2,%eax
c0104d80:	74 24                	je     c0104da6 <check_boot_pgdir+0x2a1>
c0104d82:	c7 44 24 0c ef 6b 10 	movl   $0xc0106bef,0xc(%esp)
c0104d89:	c0 
c0104d8a:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104d91:	c0 
c0104d92:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104d99:	00 
c0104d9a:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104da1:	e8 7d be ff ff       	call   c0100c23 <__panic>

    const char *str = "ucore: Hello world!!";
c0104da6:	c7 45 e8 00 6c 10 c0 	movl   $0xc0106c00,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0104dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104db0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104db4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104dbb:	e8 fc 09 00 00       	call   c01057bc <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104dc0:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104dc7:	00 
c0104dc8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104dcf:	e8 60 0a 00 00       	call   c0105834 <strcmp>
c0104dd4:	85 c0                	test   %eax,%eax
c0104dd6:	74 24                	je     c0104dfc <check_boot_pgdir+0x2f7>
c0104dd8:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c0104ddf:	c0 
c0104de0:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104de7:	c0 
c0104de8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104def:	00 
c0104df0:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104df7:	e8 27 be ff ff       	call   c0100c23 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104dff:	89 04 24             	mov    %eax,(%esp)
c0104e02:	e8 33 eb ff ff       	call   c010393a <page2kva>
c0104e07:	05 00 01 00 00       	add    $0x100,%eax
c0104e0c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104e0f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104e16:	e8 47 09 00 00       	call   c0105762 <strlen>
c0104e1b:	85 c0                	test   %eax,%eax
c0104e1d:	74 24                	je     c0104e43 <check_boot_pgdir+0x33e>
c0104e1f:	c7 44 24 0c 50 6c 10 	movl   $0xc0106c50,0xc(%esp)
c0104e26:	c0 
c0104e27:	c7 44 24 08 f1 67 10 	movl   $0xc01067f1,0x8(%esp)
c0104e2e:	c0 
c0104e2f:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104e36:	00 
c0104e37:	c7 04 24 cc 67 10 c0 	movl   $0xc01067cc,(%esp)
c0104e3e:	e8 e0 bd ff ff       	call   c0100c23 <__panic>

    free_page(p);
c0104e43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e4a:	00 
c0104e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e4e:	89 04 24             	mov    %eax,(%esp)
c0104e51:	e8 d0 ed ff ff       	call   c0103c26 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104e56:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e5b:	8b 00                	mov    (%eax),%eax
c0104e5d:	89 04 24             	mov    %eax,(%esp)
c0104e60:	e8 6b eb ff ff       	call   c01039d0 <pde2page>
c0104e65:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e6c:	00 
c0104e6d:	89 04 24             	mov    %eax,(%esp)
c0104e70:	e8 b1 ed ff ff       	call   c0103c26 <free_pages>
    boot_pgdir[0] = 0;
c0104e75:	a1 e0 89 11 c0       	mov    0xc01189e0,%eax
c0104e7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104e80:	c7 04 24 74 6c 10 c0 	movl   $0xc0106c74,(%esp)
c0104e87:	e8 ca b4 ff ff       	call   c0100356 <cprintf>
}
c0104e8c:	90                   	nop
c0104e8d:	89 ec                	mov    %ebp,%esp
c0104e8f:	5d                   	pop    %ebp
c0104e90:	c3                   	ret    

c0104e91 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104e91:	55                   	push   %ebp
c0104e92:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104e94:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e97:	83 e0 04             	and    $0x4,%eax
c0104e9a:	85 c0                	test   %eax,%eax
c0104e9c:	74 04                	je     c0104ea2 <perm2str+0x11>
c0104e9e:	b0 75                	mov    $0x75,%al
c0104ea0:	eb 02                	jmp    c0104ea4 <perm2str+0x13>
c0104ea2:	b0 2d                	mov    $0x2d,%al
c0104ea4:	a2 28 bf 11 c0       	mov    %al,0xc011bf28
    str[1] = 'r';
c0104ea9:	c6 05 29 bf 11 c0 72 	movb   $0x72,0xc011bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104eb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eb3:	83 e0 02             	and    $0x2,%eax
c0104eb6:	85 c0                	test   %eax,%eax
c0104eb8:	74 04                	je     c0104ebe <perm2str+0x2d>
c0104eba:	b0 77                	mov    $0x77,%al
c0104ebc:	eb 02                	jmp    c0104ec0 <perm2str+0x2f>
c0104ebe:	b0 2d                	mov    $0x2d,%al
c0104ec0:	a2 2a bf 11 c0       	mov    %al,0xc011bf2a
    str[3] = '\0';
c0104ec5:	c6 05 2b bf 11 c0 00 	movb   $0x0,0xc011bf2b
    return str;
c0104ecc:	b8 28 bf 11 c0       	mov    $0xc011bf28,%eax
}
c0104ed1:	5d                   	pop    %ebp
c0104ed2:	c3                   	ret    

c0104ed3 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104ed3:	55                   	push   %ebp
c0104ed4:	89 e5                	mov    %esp,%ebp
c0104ed6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104ed9:	8b 45 10             	mov    0x10(%ebp),%eax
c0104edc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104edf:	72 0d                	jb     c0104eee <get_pgtable_items+0x1b>
        return 0;
c0104ee1:	b8 00 00 00 00       	mov    $0x0,%eax
c0104ee6:	e9 98 00 00 00       	jmp    c0104f83 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104eeb:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104eee:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ef1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104ef4:	73 18                	jae    c0104f0e <get_pgtable_items+0x3b>
c0104ef6:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ef9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104f00:	8b 45 14             	mov    0x14(%ebp),%eax
c0104f03:	01 d0                	add    %edx,%eax
c0104f05:	8b 00                	mov    (%eax),%eax
c0104f07:	83 e0 01             	and    $0x1,%eax
c0104f0a:	85 c0                	test   %eax,%eax
c0104f0c:	74 dd                	je     c0104eeb <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104f0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f11:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104f14:	73 68                	jae    c0104f7e <get_pgtable_items+0xab>
        if (left_store != NULL) {
c0104f16:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104f1a:	74 08                	je     c0104f24 <get_pgtable_items+0x51>
            *left_store = start;
c0104f1c:	8b 45 18             	mov    0x18(%ebp),%eax
c0104f1f:	8b 55 10             	mov    0x10(%ebp),%edx
c0104f22:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104f24:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f27:	8d 50 01             	lea    0x1(%eax),%edx
c0104f2a:	89 55 10             	mov    %edx,0x10(%ebp)
c0104f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104f34:	8b 45 14             	mov    0x14(%ebp),%eax
c0104f37:	01 d0                	add    %edx,%eax
c0104f39:	8b 00                	mov    (%eax),%eax
c0104f3b:	83 e0 07             	and    $0x7,%eax
c0104f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104f41:	eb 03                	jmp    c0104f46 <get_pgtable_items+0x73>
            start ++;
c0104f43:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104f46:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f49:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104f4c:	73 1d                	jae    c0104f6b <get_pgtable_items+0x98>
c0104f4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104f58:	8b 45 14             	mov    0x14(%ebp),%eax
c0104f5b:	01 d0                	add    %edx,%eax
c0104f5d:	8b 00                	mov    (%eax),%eax
c0104f5f:	83 e0 07             	and    $0x7,%eax
c0104f62:	89 c2                	mov    %eax,%edx
c0104f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104f67:	39 c2                	cmp    %eax,%edx
c0104f69:	74 d8                	je     c0104f43 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c0104f6b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104f6f:	74 08                	je     c0104f79 <get_pgtable_items+0xa6>
            *right_store = start;
c0104f71:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104f74:	8b 55 10             	mov    0x10(%ebp),%edx
c0104f77:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104f7c:	eb 05                	jmp    c0104f83 <get_pgtable_items+0xb0>
    }
    return 0;
c0104f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f83:	89 ec                	mov    %ebp,%esp
c0104f85:	5d                   	pop    %ebp
c0104f86:	c3                   	ret    

c0104f87 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104f87:	55                   	push   %ebp
c0104f88:	89 e5                	mov    %esp,%ebp
c0104f8a:	57                   	push   %edi
c0104f8b:	56                   	push   %esi
c0104f8c:	53                   	push   %ebx
c0104f8d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104f90:	c7 04 24 94 6c 10 c0 	movl   $0xc0106c94,(%esp)
c0104f97:	e8 ba b3 ff ff       	call   c0100356 <cprintf>
    size_t left, right = 0, perm;
c0104f9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104fa3:	e9 f2 00 00 00       	jmp    c010509a <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fab:	89 04 24             	mov    %eax,(%esp)
c0104fae:	e8 de fe ff ff       	call   c0104e91 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fb6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104fb9:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104fbb:	89 d6                	mov    %edx,%esi
c0104fbd:	c1 e6 16             	shl    $0x16,%esi
c0104fc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fc3:	89 d3                	mov    %edx,%ebx
c0104fc5:	c1 e3 16             	shl    $0x16,%ebx
c0104fc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fcb:	89 d1                	mov    %edx,%ecx
c0104fcd:	c1 e1 16             	shl    $0x16,%ecx
c0104fd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fd3:	8b 7d e0             	mov    -0x20(%ebp),%edi
c0104fd6:	29 fa                	sub    %edi,%edx
c0104fd8:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104fdc:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104fe0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104fe4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104fe8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fec:	c7 04 24 c5 6c 10 c0 	movl   $0xc0106cc5,(%esp)
c0104ff3:	e8 5e b3 ff ff       	call   c0100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ffb:	c1 e0 0a             	shl    $0xa,%eax
c0104ffe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105001:	eb 50                	jmp    c0105053 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105006:	89 04 24             	mov    %eax,(%esp)
c0105009:	e8 83 fe ff ff       	call   c0104e91 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010500e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105011:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0105014:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105016:	89 d6                	mov    %edx,%esi
c0105018:	c1 e6 0c             	shl    $0xc,%esi
c010501b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010501e:	89 d3                	mov    %edx,%ebx
c0105020:	c1 e3 0c             	shl    $0xc,%ebx
c0105023:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105026:	89 d1                	mov    %edx,%ecx
c0105028:	c1 e1 0c             	shl    $0xc,%ecx
c010502b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010502e:	8b 7d d8             	mov    -0x28(%ebp),%edi
c0105031:	29 fa                	sub    %edi,%edx
c0105033:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105037:	89 74 24 10          	mov    %esi,0x10(%esp)
c010503b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010503f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105043:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105047:	c7 04 24 e4 6c 10 c0 	movl   $0xc0106ce4,(%esp)
c010504e:	e8 03 b3 ff ff       	call   c0100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105053:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0105058:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010505b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010505e:	89 d3                	mov    %edx,%ebx
c0105060:	c1 e3 0a             	shl    $0xa,%ebx
c0105063:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105066:	89 d1                	mov    %edx,%ecx
c0105068:	c1 e1 0a             	shl    $0xa,%ecx
c010506b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c010506e:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105072:	8d 55 d8             	lea    -0x28(%ebp),%edx
c0105075:	89 54 24 10          	mov    %edx,0x10(%esp)
c0105079:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010507d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105081:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0105085:	89 0c 24             	mov    %ecx,(%esp)
c0105088:	e8 46 fe ff ff       	call   c0104ed3 <get_pgtable_items>
c010508d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105090:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105094:	0f 85 69 ff ff ff    	jne    c0105003 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010509a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c010509f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050a2:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01050a5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01050a9:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01050ac:	89 54 24 10          	mov    %edx,0x10(%esp)
c01050b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01050b4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050b8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01050bf:	00 
c01050c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01050c7:	e8 07 fe ff ff       	call   c0104ed3 <get_pgtable_items>
c01050cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01050cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01050d3:	0f 85 cf fe ff ff    	jne    c0104fa8 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01050d9:	c7 04 24 08 6d 10 c0 	movl   $0xc0106d08,(%esp)
c01050e0:	e8 71 b2 ff ff       	call   c0100356 <cprintf>
}
c01050e5:	90                   	nop
c01050e6:	83 c4 4c             	add    $0x4c,%esp
c01050e9:	5b                   	pop    %ebx
c01050ea:	5e                   	pop    %esi
c01050eb:	5f                   	pop    %edi
c01050ec:	5d                   	pop    %ebp
c01050ed:	c3                   	ret    

c01050ee <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01050ee:	55                   	push   %ebp
c01050ef:	89 e5                	mov    %esp,%ebp
c01050f1:	83 ec 58             	sub    $0x58,%esp
c01050f4:	8b 45 10             	mov    0x10(%ebp),%eax
c01050f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01050fa:	8b 45 14             	mov    0x14(%ebp),%eax
c01050fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105100:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105103:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105106:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105109:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010510c:	8b 45 18             	mov    0x18(%ebp),%eax
c010510f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105112:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105115:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105118:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010511b:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010511e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105121:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105128:	74 1c                	je     c0105146 <printnum+0x58>
c010512a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010512d:	ba 00 00 00 00       	mov    $0x0,%edx
c0105132:	f7 75 e4             	divl   -0x1c(%ebp)
c0105135:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105138:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010513b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105140:	f7 75 e4             	divl   -0x1c(%ebp)
c0105143:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105146:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105149:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010514c:	f7 75 e4             	divl   -0x1c(%ebp)
c010514f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105152:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105155:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105158:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010515b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010515e:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105161:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105164:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105167:	8b 45 18             	mov    0x18(%ebp),%eax
c010516a:	ba 00 00 00 00       	mov    $0x0,%edx
c010516f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105172:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105175:	19 d1                	sbb    %edx,%ecx
c0105177:	72 4c                	jb     c01051c5 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105179:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010517c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010517f:	8b 45 20             	mov    0x20(%ebp),%eax
c0105182:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105186:	89 54 24 14          	mov    %edx,0x14(%esp)
c010518a:	8b 45 18             	mov    0x18(%ebp),%eax
c010518d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105191:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105194:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105197:	89 44 24 08          	mov    %eax,0x8(%esp)
c010519b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010519f:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a9:	89 04 24             	mov    %eax,(%esp)
c01051ac:	e8 3d ff ff ff       	call   c01050ee <printnum>
c01051b1:	eb 1b                	jmp    c01051ce <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01051b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051ba:	8b 45 20             	mov    0x20(%ebp),%eax
c01051bd:	89 04 24             	mov    %eax,(%esp)
c01051c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c3:	ff d0                	call   *%eax
        while (-- width > 0)
c01051c5:	ff 4d 1c             	decl   0x1c(%ebp)
c01051c8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01051cc:	7f e5                	jg     c01051b3 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01051ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01051d1:	05 bc 6d 10 c0       	add    $0xc0106dbc,%eax
c01051d6:	0f b6 00             	movzbl (%eax),%eax
c01051d9:	0f be c0             	movsbl %al,%eax
c01051dc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01051df:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051e3:	89 04 24             	mov    %eax,(%esp)
c01051e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01051e9:	ff d0                	call   *%eax
}
c01051eb:	90                   	nop
c01051ec:	89 ec                	mov    %ebp,%esp
c01051ee:	5d                   	pop    %ebp
c01051ef:	c3                   	ret    

c01051f0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01051f0:	55                   	push   %ebp
c01051f1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01051f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01051f7:	7e 14                	jle    c010520d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01051f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fc:	8b 00                	mov    (%eax),%eax
c01051fe:	8d 48 08             	lea    0x8(%eax),%ecx
c0105201:	8b 55 08             	mov    0x8(%ebp),%edx
c0105204:	89 0a                	mov    %ecx,(%edx)
c0105206:	8b 50 04             	mov    0x4(%eax),%edx
c0105209:	8b 00                	mov    (%eax),%eax
c010520b:	eb 30                	jmp    c010523d <getuint+0x4d>
    }
    else if (lflag) {
c010520d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105211:	74 16                	je     c0105229 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105213:	8b 45 08             	mov    0x8(%ebp),%eax
c0105216:	8b 00                	mov    (%eax),%eax
c0105218:	8d 48 04             	lea    0x4(%eax),%ecx
c010521b:	8b 55 08             	mov    0x8(%ebp),%edx
c010521e:	89 0a                	mov    %ecx,(%edx)
c0105220:	8b 00                	mov    (%eax),%eax
c0105222:	ba 00 00 00 00       	mov    $0x0,%edx
c0105227:	eb 14                	jmp    c010523d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105229:	8b 45 08             	mov    0x8(%ebp),%eax
c010522c:	8b 00                	mov    (%eax),%eax
c010522e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105231:	8b 55 08             	mov    0x8(%ebp),%edx
c0105234:	89 0a                	mov    %ecx,(%edx)
c0105236:	8b 00                	mov    (%eax),%eax
c0105238:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010523d:	5d                   	pop    %ebp
c010523e:	c3                   	ret    

c010523f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010523f:	55                   	push   %ebp
c0105240:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105242:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105246:	7e 14                	jle    c010525c <getint+0x1d>
        return va_arg(*ap, long long);
c0105248:	8b 45 08             	mov    0x8(%ebp),%eax
c010524b:	8b 00                	mov    (%eax),%eax
c010524d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105250:	8b 55 08             	mov    0x8(%ebp),%edx
c0105253:	89 0a                	mov    %ecx,(%edx)
c0105255:	8b 50 04             	mov    0x4(%eax),%edx
c0105258:	8b 00                	mov    (%eax),%eax
c010525a:	eb 28                	jmp    c0105284 <getint+0x45>
    }
    else if (lflag) {
c010525c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105260:	74 12                	je     c0105274 <getint+0x35>
        return va_arg(*ap, long);
c0105262:	8b 45 08             	mov    0x8(%ebp),%eax
c0105265:	8b 00                	mov    (%eax),%eax
c0105267:	8d 48 04             	lea    0x4(%eax),%ecx
c010526a:	8b 55 08             	mov    0x8(%ebp),%edx
c010526d:	89 0a                	mov    %ecx,(%edx)
c010526f:	8b 00                	mov    (%eax),%eax
c0105271:	99                   	cltd   
c0105272:	eb 10                	jmp    c0105284 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105274:	8b 45 08             	mov    0x8(%ebp),%eax
c0105277:	8b 00                	mov    (%eax),%eax
c0105279:	8d 48 04             	lea    0x4(%eax),%ecx
c010527c:	8b 55 08             	mov    0x8(%ebp),%edx
c010527f:	89 0a                	mov    %ecx,(%edx)
c0105281:	8b 00                	mov    (%eax),%eax
c0105283:	99                   	cltd   
    }
}
c0105284:	5d                   	pop    %ebp
c0105285:	c3                   	ret    

c0105286 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105286:	55                   	push   %ebp
c0105287:	89 e5                	mov    %esp,%ebp
c0105289:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010528c:	8d 45 14             	lea    0x14(%ebp),%eax
c010528f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105292:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105295:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105299:	8b 45 10             	mov    0x10(%ebp),%eax
c010529c:	89 44 24 08          	mov    %eax,0x8(%esp)
c01052a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01052aa:	89 04 24             	mov    %eax,(%esp)
c01052ad:	e8 05 00 00 00       	call   c01052b7 <vprintfmt>
    va_end(ap);
}
c01052b2:	90                   	nop
c01052b3:	89 ec                	mov    %ebp,%esp
c01052b5:	5d                   	pop    %ebp
c01052b6:	c3                   	ret    

c01052b7 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01052b7:	55                   	push   %ebp
c01052b8:	89 e5                	mov    %esp,%ebp
c01052ba:	56                   	push   %esi
c01052bb:	53                   	push   %ebx
c01052bc:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01052bf:	eb 17                	jmp    c01052d8 <vprintfmt+0x21>
            if (ch == '\0') {
c01052c1:	85 db                	test   %ebx,%ebx
c01052c3:	0f 84 bf 03 00 00    	je     c0105688 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c01052c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052d0:	89 1c 24             	mov    %ebx,(%esp)
c01052d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01052d6:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01052d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01052db:	8d 50 01             	lea    0x1(%eax),%edx
c01052de:	89 55 10             	mov    %edx,0x10(%ebp)
c01052e1:	0f b6 00             	movzbl (%eax),%eax
c01052e4:	0f b6 d8             	movzbl %al,%ebx
c01052e7:	83 fb 25             	cmp    $0x25,%ebx
c01052ea:	75 d5                	jne    c01052c1 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c01052ec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01052f0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01052f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01052fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105304:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105307:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010530a:	8b 45 10             	mov    0x10(%ebp),%eax
c010530d:	8d 50 01             	lea    0x1(%eax),%edx
c0105310:	89 55 10             	mov    %edx,0x10(%ebp)
c0105313:	0f b6 00             	movzbl (%eax),%eax
c0105316:	0f b6 d8             	movzbl %al,%ebx
c0105319:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010531c:	83 f8 55             	cmp    $0x55,%eax
c010531f:	0f 87 37 03 00 00    	ja     c010565c <vprintfmt+0x3a5>
c0105325:	8b 04 85 e0 6d 10 c0 	mov    -0x3fef9220(,%eax,4),%eax
c010532c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010532e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105332:	eb d6                	jmp    c010530a <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105334:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105338:	eb d0                	jmp    c010530a <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010533a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105341:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105344:	89 d0                	mov    %edx,%eax
c0105346:	c1 e0 02             	shl    $0x2,%eax
c0105349:	01 d0                	add    %edx,%eax
c010534b:	01 c0                	add    %eax,%eax
c010534d:	01 d8                	add    %ebx,%eax
c010534f:	83 e8 30             	sub    $0x30,%eax
c0105352:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105355:	8b 45 10             	mov    0x10(%ebp),%eax
c0105358:	0f b6 00             	movzbl (%eax),%eax
c010535b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010535e:	83 fb 2f             	cmp    $0x2f,%ebx
c0105361:	7e 38                	jle    c010539b <vprintfmt+0xe4>
c0105363:	83 fb 39             	cmp    $0x39,%ebx
c0105366:	7f 33                	jg     c010539b <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105368:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c010536b:	eb d4                	jmp    c0105341 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010536d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105370:	8d 50 04             	lea    0x4(%eax),%edx
c0105373:	89 55 14             	mov    %edx,0x14(%ebp)
c0105376:	8b 00                	mov    (%eax),%eax
c0105378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010537b:	eb 1f                	jmp    c010539c <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c010537d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105381:	79 87                	jns    c010530a <vprintfmt+0x53>
                width = 0;
c0105383:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010538a:	e9 7b ff ff ff       	jmp    c010530a <vprintfmt+0x53>

        case '#':
            altflag = 1;
c010538f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105396:	e9 6f ff ff ff       	jmp    c010530a <vprintfmt+0x53>
            goto process_precision;
c010539b:	90                   	nop

        process_precision:
            if (width < 0)
c010539c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01053a0:	0f 89 64 ff ff ff    	jns    c010530a <vprintfmt+0x53>
                width = precision, precision = -1;
c01053a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01053b3:	e9 52 ff ff ff       	jmp    c010530a <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01053b8:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c01053bb:	e9 4a ff ff ff       	jmp    c010530a <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01053c0:	8b 45 14             	mov    0x14(%ebp),%eax
c01053c3:	8d 50 04             	lea    0x4(%eax),%edx
c01053c6:	89 55 14             	mov    %edx,0x14(%ebp)
c01053c9:	8b 00                	mov    (%eax),%eax
c01053cb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053ce:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053d2:	89 04 24             	mov    %eax,(%esp)
c01053d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d8:	ff d0                	call   *%eax
            break;
c01053da:	e9 a4 02 00 00       	jmp    c0105683 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01053df:	8b 45 14             	mov    0x14(%ebp),%eax
c01053e2:	8d 50 04             	lea    0x4(%eax),%edx
c01053e5:	89 55 14             	mov    %edx,0x14(%ebp)
c01053e8:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01053ea:	85 db                	test   %ebx,%ebx
c01053ec:	79 02                	jns    c01053f0 <vprintfmt+0x139>
                err = -err;
c01053ee:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01053f0:	83 fb 06             	cmp    $0x6,%ebx
c01053f3:	7f 0b                	jg     c0105400 <vprintfmt+0x149>
c01053f5:	8b 34 9d a0 6d 10 c0 	mov    -0x3fef9260(,%ebx,4),%esi
c01053fc:	85 f6                	test   %esi,%esi
c01053fe:	75 23                	jne    c0105423 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105400:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105404:	c7 44 24 08 cd 6d 10 	movl   $0xc0106dcd,0x8(%esp)
c010540b:	c0 
c010540c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010540f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105413:	8b 45 08             	mov    0x8(%ebp),%eax
c0105416:	89 04 24             	mov    %eax,(%esp)
c0105419:	e8 68 fe ff ff       	call   c0105286 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010541e:	e9 60 02 00 00       	jmp    c0105683 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105423:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105427:	c7 44 24 08 d6 6d 10 	movl   $0xc0106dd6,0x8(%esp)
c010542e:	c0 
c010542f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105432:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105436:	8b 45 08             	mov    0x8(%ebp),%eax
c0105439:	89 04 24             	mov    %eax,(%esp)
c010543c:	e8 45 fe ff ff       	call   c0105286 <printfmt>
            break;
c0105441:	e9 3d 02 00 00       	jmp    c0105683 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105446:	8b 45 14             	mov    0x14(%ebp),%eax
c0105449:	8d 50 04             	lea    0x4(%eax),%edx
c010544c:	89 55 14             	mov    %edx,0x14(%ebp)
c010544f:	8b 30                	mov    (%eax),%esi
c0105451:	85 f6                	test   %esi,%esi
c0105453:	75 05                	jne    c010545a <vprintfmt+0x1a3>
                p = "(null)";
c0105455:	be d9 6d 10 c0       	mov    $0xc0106dd9,%esi
            }
            if (width > 0 && padc != '-') {
c010545a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010545e:	7e 76                	jle    c01054d6 <vprintfmt+0x21f>
c0105460:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105464:	74 70                	je     c01054d6 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105469:	89 44 24 04          	mov    %eax,0x4(%esp)
c010546d:	89 34 24             	mov    %esi,(%esp)
c0105470:	e8 16 03 00 00       	call   c010578b <strnlen>
c0105475:	89 c2                	mov    %eax,%edx
c0105477:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010547a:	29 d0                	sub    %edx,%eax
c010547c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010547f:	eb 16                	jmp    c0105497 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0105481:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105485:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105488:	89 54 24 04          	mov    %edx,0x4(%esp)
c010548c:	89 04 24             	mov    %eax,(%esp)
c010548f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105492:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105494:	ff 4d e8             	decl   -0x18(%ebp)
c0105497:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010549b:	7f e4                	jg     c0105481 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010549d:	eb 37                	jmp    c01054d6 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c010549f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01054a3:	74 1f                	je     c01054c4 <vprintfmt+0x20d>
c01054a5:	83 fb 1f             	cmp    $0x1f,%ebx
c01054a8:	7e 05                	jle    c01054af <vprintfmt+0x1f8>
c01054aa:	83 fb 7e             	cmp    $0x7e,%ebx
c01054ad:	7e 15                	jle    c01054c4 <vprintfmt+0x20d>
                    putch('?', putdat);
c01054af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054b6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01054bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01054c0:	ff d0                	call   *%eax
c01054c2:	eb 0f                	jmp    c01054d3 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c01054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054cb:	89 1c 24             	mov    %ebx,(%esp)
c01054ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01054d1:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01054d3:	ff 4d e8             	decl   -0x18(%ebp)
c01054d6:	89 f0                	mov    %esi,%eax
c01054d8:	8d 70 01             	lea    0x1(%eax),%esi
c01054db:	0f b6 00             	movzbl (%eax),%eax
c01054de:	0f be d8             	movsbl %al,%ebx
c01054e1:	85 db                	test   %ebx,%ebx
c01054e3:	74 27                	je     c010550c <vprintfmt+0x255>
c01054e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054e9:	78 b4                	js     c010549f <vprintfmt+0x1e8>
c01054eb:	ff 4d e4             	decl   -0x1c(%ebp)
c01054ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01054f2:	79 ab                	jns    c010549f <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c01054f4:	eb 16                	jmp    c010550c <vprintfmt+0x255>
                putch(' ', putdat);
c01054f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054fd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105504:	8b 45 08             	mov    0x8(%ebp),%eax
c0105507:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105509:	ff 4d e8             	decl   -0x18(%ebp)
c010550c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105510:	7f e4                	jg     c01054f6 <vprintfmt+0x23f>
            }
            break;
c0105512:	e9 6c 01 00 00       	jmp    c0105683 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105517:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010551a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010551e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105521:	89 04 24             	mov    %eax,(%esp)
c0105524:	e8 16 fd ff ff       	call   c010523f <getint>
c0105529:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010552c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010552f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105532:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105535:	85 d2                	test   %edx,%edx
c0105537:	79 26                	jns    c010555f <vprintfmt+0x2a8>
                putch('-', putdat);
c0105539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010553c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105540:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105547:	8b 45 08             	mov    0x8(%ebp),%eax
c010554a:	ff d0                	call   *%eax
                num = -(long long)num;
c010554c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010554f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105552:	f7 d8                	neg    %eax
c0105554:	83 d2 00             	adc    $0x0,%edx
c0105557:	f7 da                	neg    %edx
c0105559:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010555c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010555f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105566:	e9 a8 00 00 00       	jmp    c0105613 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010556b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010556e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105572:	8d 45 14             	lea    0x14(%ebp),%eax
c0105575:	89 04 24             	mov    %eax,(%esp)
c0105578:	e8 73 fc ff ff       	call   c01051f0 <getuint>
c010557d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105580:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105583:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010558a:	e9 84 00 00 00       	jmp    c0105613 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010558f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105592:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105596:	8d 45 14             	lea    0x14(%ebp),%eax
c0105599:	89 04 24             	mov    %eax,(%esp)
c010559c:	e8 4f fc ff ff       	call   c01051f0 <getuint>
c01055a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01055a7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01055ae:	eb 63                	jmp    c0105613 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c01055b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055b7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01055be:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c1:	ff d0                	call   *%eax
            putch('x', putdat);
c01055c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055ca:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01055d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d4:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01055d6:	8b 45 14             	mov    0x14(%ebp),%eax
c01055d9:	8d 50 04             	lea    0x4(%eax),%edx
c01055dc:	89 55 14             	mov    %edx,0x14(%ebp)
c01055df:	8b 00                	mov    (%eax),%eax
c01055e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01055e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01055eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01055f2:	eb 1f                	jmp    c0105613 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01055f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055fb:	8d 45 14             	lea    0x14(%ebp),%eax
c01055fe:	89 04 24             	mov    %eax,(%esp)
c0105601:	e8 ea fb ff ff       	call   c01051f0 <getuint>
c0105606:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105609:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010560c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105613:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105617:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010561a:	89 54 24 18          	mov    %edx,0x18(%esp)
c010561e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105621:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105629:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010562c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010562f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105633:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105637:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010563e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105641:	89 04 24             	mov    %eax,(%esp)
c0105644:	e8 a5 fa ff ff       	call   c01050ee <printnum>
            break;
c0105649:	eb 38                	jmp    c0105683 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010564b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010564e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105652:	89 1c 24             	mov    %ebx,(%esp)
c0105655:	8b 45 08             	mov    0x8(%ebp),%eax
c0105658:	ff d0                	call   *%eax
            break;
c010565a:	eb 27                	jmp    c0105683 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010565c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010565f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105663:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010566a:	8b 45 08             	mov    0x8(%ebp),%eax
c010566d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010566f:	ff 4d 10             	decl   0x10(%ebp)
c0105672:	eb 03                	jmp    c0105677 <vprintfmt+0x3c0>
c0105674:	ff 4d 10             	decl   0x10(%ebp)
c0105677:	8b 45 10             	mov    0x10(%ebp),%eax
c010567a:	48                   	dec    %eax
c010567b:	0f b6 00             	movzbl (%eax),%eax
c010567e:	3c 25                	cmp    $0x25,%al
c0105680:	75 f2                	jne    c0105674 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105682:	90                   	nop
    while (1) {
c0105683:	e9 37 fc ff ff       	jmp    c01052bf <vprintfmt+0x8>
                return;
c0105688:	90                   	nop
        }
    }
}
c0105689:	83 c4 40             	add    $0x40,%esp
c010568c:	5b                   	pop    %ebx
c010568d:	5e                   	pop    %esi
c010568e:	5d                   	pop    %ebp
c010568f:	c3                   	ret    

c0105690 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105690:	55                   	push   %ebp
c0105691:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105693:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105696:	8b 40 08             	mov    0x8(%eax),%eax
c0105699:	8d 50 01             	lea    0x1(%eax),%edx
c010569c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010569f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01056a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a5:	8b 10                	mov    (%eax),%edx
c01056a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056aa:	8b 40 04             	mov    0x4(%eax),%eax
c01056ad:	39 c2                	cmp    %eax,%edx
c01056af:	73 12                	jae    c01056c3 <sprintputch+0x33>
        *b->buf ++ = ch;
c01056b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b4:	8b 00                	mov    (%eax),%eax
c01056b6:	8d 48 01             	lea    0x1(%eax),%ecx
c01056b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056bc:	89 0a                	mov    %ecx,(%edx)
c01056be:	8b 55 08             	mov    0x8(%ebp),%edx
c01056c1:	88 10                	mov    %dl,(%eax)
    }
}
c01056c3:	90                   	nop
c01056c4:	5d                   	pop    %ebp
c01056c5:	c3                   	ret    

c01056c6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01056c6:	55                   	push   %ebp
c01056c7:	89 e5                	mov    %esp,%ebp
c01056c9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01056cc:	8d 45 14             	lea    0x14(%ebp),%eax
c01056cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01056d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01056dc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ea:	89 04 24             	mov    %eax,(%esp)
c01056ed:	e8 0a 00 00 00       	call   c01056fc <vsnprintf>
c01056f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01056f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01056f8:	89 ec                	mov    %ebp,%esp
c01056fa:	5d                   	pop    %ebp
c01056fb:	c3                   	ret    

c01056fc <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01056fc:	55                   	push   %ebp
c01056fd:	89 e5                	mov    %esp,%ebp
c01056ff:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105702:	8b 45 08             	mov    0x8(%ebp),%eax
c0105705:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105708:	8b 45 0c             	mov    0xc(%ebp),%eax
c010570b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010570e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105711:	01 d0                	add    %edx,%eax
c0105713:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010571d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105721:	74 0a                	je     c010572d <vsnprintf+0x31>
c0105723:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105726:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105729:	39 c2                	cmp    %eax,%edx
c010572b:	76 07                	jbe    c0105734 <vsnprintf+0x38>
        return -E_INVAL;
c010572d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105732:	eb 2a                	jmp    c010575e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105734:	8b 45 14             	mov    0x14(%ebp),%eax
c0105737:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010573b:	8b 45 10             	mov    0x10(%ebp),%eax
c010573e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105742:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105745:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105749:	c7 04 24 90 56 10 c0 	movl   $0xc0105690,(%esp)
c0105750:	e8 62 fb ff ff       	call   c01052b7 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105755:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105758:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010575b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010575e:	89 ec                	mov    %ebp,%esp
c0105760:	5d                   	pop    %ebp
c0105761:	c3                   	ret    

c0105762 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105762:	55                   	push   %ebp
c0105763:	89 e5                	mov    %esp,%ebp
c0105765:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010576f:	eb 03                	jmp    c0105774 <strlen+0x12>
        cnt ++;
c0105771:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c0105774:	8b 45 08             	mov    0x8(%ebp),%eax
c0105777:	8d 50 01             	lea    0x1(%eax),%edx
c010577a:	89 55 08             	mov    %edx,0x8(%ebp)
c010577d:	0f b6 00             	movzbl (%eax),%eax
c0105780:	84 c0                	test   %al,%al
c0105782:	75 ed                	jne    c0105771 <strlen+0xf>
    }
    return cnt;
c0105784:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105787:	89 ec                	mov    %ebp,%esp
c0105789:	5d                   	pop    %ebp
c010578a:	c3                   	ret    

c010578b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010578b:	55                   	push   %ebp
c010578c:	89 e5                	mov    %esp,%ebp
c010578e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105791:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105798:	eb 03                	jmp    c010579d <strnlen+0x12>
        cnt ++;
c010579a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010579d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01057a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01057a3:	73 10                	jae    c01057b5 <strnlen+0x2a>
c01057a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a8:	8d 50 01             	lea    0x1(%eax),%edx
c01057ab:	89 55 08             	mov    %edx,0x8(%ebp)
c01057ae:	0f b6 00             	movzbl (%eax),%eax
c01057b1:	84 c0                	test   %al,%al
c01057b3:	75 e5                	jne    c010579a <strnlen+0xf>
    }
    return cnt;
c01057b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01057b8:	89 ec                	mov    %ebp,%esp
c01057ba:	5d                   	pop    %ebp
c01057bb:	c3                   	ret    

c01057bc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01057bc:	55                   	push   %ebp
c01057bd:	89 e5                	mov    %esp,%ebp
c01057bf:	57                   	push   %edi
c01057c0:	56                   	push   %esi
c01057c1:	83 ec 20             	sub    $0x20,%esp
c01057c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01057d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01057d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057d6:	89 d1                	mov    %edx,%ecx
c01057d8:	89 c2                	mov    %eax,%edx
c01057da:	89 ce                	mov    %ecx,%esi
c01057dc:	89 d7                	mov    %edx,%edi
c01057de:	ac                   	lods   %ds:(%esi),%al
c01057df:	aa                   	stos   %al,%es:(%edi)
c01057e0:	84 c0                	test   %al,%al
c01057e2:	75 fa                	jne    c01057de <strcpy+0x22>
c01057e4:	89 fa                	mov    %edi,%edx
c01057e6:	89 f1                	mov    %esi,%ecx
c01057e8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01057eb:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01057ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01057f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01057f4:	83 c4 20             	add    $0x20,%esp
c01057f7:	5e                   	pop    %esi
c01057f8:	5f                   	pop    %edi
c01057f9:	5d                   	pop    %ebp
c01057fa:	c3                   	ret    

c01057fb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01057fb:	55                   	push   %ebp
c01057fc:	89 e5                	mov    %esp,%ebp
c01057fe:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105801:	8b 45 08             	mov    0x8(%ebp),%eax
c0105804:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105807:	eb 1e                	jmp    c0105827 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105809:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580c:	0f b6 10             	movzbl (%eax),%edx
c010580f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105812:	88 10                	mov    %dl,(%eax)
c0105814:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105817:	0f b6 00             	movzbl (%eax),%eax
c010581a:	84 c0                	test   %al,%al
c010581c:	74 03                	je     c0105821 <strncpy+0x26>
            src ++;
c010581e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c0105821:	ff 45 fc             	incl   -0x4(%ebp)
c0105824:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c0105827:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010582b:	75 dc                	jne    c0105809 <strncpy+0xe>
    }
    return dst;
c010582d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105830:	89 ec                	mov    %ebp,%esp
c0105832:	5d                   	pop    %ebp
c0105833:	c3                   	ret    

c0105834 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105834:	55                   	push   %ebp
c0105835:	89 e5                	mov    %esp,%ebp
c0105837:	57                   	push   %edi
c0105838:	56                   	push   %esi
c0105839:	83 ec 20             	sub    $0x20,%esp
c010583c:	8b 45 08             	mov    0x8(%ebp),%eax
c010583f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105845:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105848:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010584b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010584e:	89 d1                	mov    %edx,%ecx
c0105850:	89 c2                	mov    %eax,%edx
c0105852:	89 ce                	mov    %ecx,%esi
c0105854:	89 d7                	mov    %edx,%edi
c0105856:	ac                   	lods   %ds:(%esi),%al
c0105857:	ae                   	scas   %es:(%edi),%al
c0105858:	75 08                	jne    c0105862 <strcmp+0x2e>
c010585a:	84 c0                	test   %al,%al
c010585c:	75 f8                	jne    c0105856 <strcmp+0x22>
c010585e:	31 c0                	xor    %eax,%eax
c0105860:	eb 04                	jmp    c0105866 <strcmp+0x32>
c0105862:	19 c0                	sbb    %eax,%eax
c0105864:	0c 01                	or     $0x1,%al
c0105866:	89 fa                	mov    %edi,%edx
c0105868:	89 f1                	mov    %esi,%ecx
c010586a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010586d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105870:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c0105873:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105876:	83 c4 20             	add    $0x20,%esp
c0105879:	5e                   	pop    %esi
c010587a:	5f                   	pop    %edi
c010587b:	5d                   	pop    %ebp
c010587c:	c3                   	ret    

c010587d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010587d:	55                   	push   %ebp
c010587e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105880:	eb 09                	jmp    c010588b <strncmp+0xe>
        n --, s1 ++, s2 ++;
c0105882:	ff 4d 10             	decl   0x10(%ebp)
c0105885:	ff 45 08             	incl   0x8(%ebp)
c0105888:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010588b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010588f:	74 1a                	je     c01058ab <strncmp+0x2e>
c0105891:	8b 45 08             	mov    0x8(%ebp),%eax
c0105894:	0f b6 00             	movzbl (%eax),%eax
c0105897:	84 c0                	test   %al,%al
c0105899:	74 10                	je     c01058ab <strncmp+0x2e>
c010589b:	8b 45 08             	mov    0x8(%ebp),%eax
c010589e:	0f b6 10             	movzbl (%eax),%edx
c01058a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a4:	0f b6 00             	movzbl (%eax),%eax
c01058a7:	38 c2                	cmp    %al,%dl
c01058a9:	74 d7                	je     c0105882 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01058ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058af:	74 18                	je     c01058c9 <strncmp+0x4c>
c01058b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058b4:	0f b6 00             	movzbl (%eax),%eax
c01058b7:	0f b6 d0             	movzbl %al,%edx
c01058ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058bd:	0f b6 00             	movzbl (%eax),%eax
c01058c0:	0f b6 c8             	movzbl %al,%ecx
c01058c3:	89 d0                	mov    %edx,%eax
c01058c5:	29 c8                	sub    %ecx,%eax
c01058c7:	eb 05                	jmp    c01058ce <strncmp+0x51>
c01058c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01058ce:	5d                   	pop    %ebp
c01058cf:	c3                   	ret    

c01058d0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c01058d0:	55                   	push   %ebp
c01058d1:	89 e5                	mov    %esp,%ebp
c01058d3:	83 ec 04             	sub    $0x4,%esp
c01058d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058d9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01058dc:	eb 13                	jmp    c01058f1 <strchr+0x21>
        if (*s == c) {
c01058de:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e1:	0f b6 00             	movzbl (%eax),%eax
c01058e4:	38 45 fc             	cmp    %al,-0x4(%ebp)
c01058e7:	75 05                	jne    c01058ee <strchr+0x1e>
            return (char *)s;
c01058e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ec:	eb 12                	jmp    c0105900 <strchr+0x30>
        }
        s ++;
c01058ee:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c01058f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f4:	0f b6 00             	movzbl (%eax),%eax
c01058f7:	84 c0                	test   %al,%al
c01058f9:	75 e3                	jne    c01058de <strchr+0xe>
    }
    return NULL;
c01058fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105900:	89 ec                	mov    %ebp,%esp
c0105902:	5d                   	pop    %ebp
c0105903:	c3                   	ret    

c0105904 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105904:	55                   	push   %ebp
c0105905:	89 e5                	mov    %esp,%ebp
c0105907:	83 ec 04             	sub    $0x4,%esp
c010590a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010590d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105910:	eb 0e                	jmp    c0105920 <strfind+0x1c>
        if (*s == c) {
c0105912:	8b 45 08             	mov    0x8(%ebp),%eax
c0105915:	0f b6 00             	movzbl (%eax),%eax
c0105918:	38 45 fc             	cmp    %al,-0x4(%ebp)
c010591b:	74 0f                	je     c010592c <strfind+0x28>
            break;
        }
        s ++;
c010591d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c0105920:	8b 45 08             	mov    0x8(%ebp),%eax
c0105923:	0f b6 00             	movzbl (%eax),%eax
c0105926:	84 c0                	test   %al,%al
c0105928:	75 e8                	jne    c0105912 <strfind+0xe>
c010592a:	eb 01                	jmp    c010592d <strfind+0x29>
            break;
c010592c:	90                   	nop
    }
    return (char *)s;
c010592d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105930:	89 ec                	mov    %ebp,%esp
c0105932:	5d                   	pop    %ebp
c0105933:	c3                   	ret    

c0105934 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105934:	55                   	push   %ebp
c0105935:	89 e5                	mov    %esp,%ebp
c0105937:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010593a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105941:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105948:	eb 03                	jmp    c010594d <strtol+0x19>
        s ++;
c010594a:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c010594d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105950:	0f b6 00             	movzbl (%eax),%eax
c0105953:	3c 20                	cmp    $0x20,%al
c0105955:	74 f3                	je     c010594a <strtol+0x16>
c0105957:	8b 45 08             	mov    0x8(%ebp),%eax
c010595a:	0f b6 00             	movzbl (%eax),%eax
c010595d:	3c 09                	cmp    $0x9,%al
c010595f:	74 e9                	je     c010594a <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105961:	8b 45 08             	mov    0x8(%ebp),%eax
c0105964:	0f b6 00             	movzbl (%eax),%eax
c0105967:	3c 2b                	cmp    $0x2b,%al
c0105969:	75 05                	jne    c0105970 <strtol+0x3c>
        s ++;
c010596b:	ff 45 08             	incl   0x8(%ebp)
c010596e:	eb 14                	jmp    c0105984 <strtol+0x50>
    }
    else if (*s == '-') {
c0105970:	8b 45 08             	mov    0x8(%ebp),%eax
c0105973:	0f b6 00             	movzbl (%eax),%eax
c0105976:	3c 2d                	cmp    $0x2d,%al
c0105978:	75 0a                	jne    c0105984 <strtol+0x50>
        s ++, neg = 1;
c010597a:	ff 45 08             	incl   0x8(%ebp)
c010597d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105984:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105988:	74 06                	je     c0105990 <strtol+0x5c>
c010598a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010598e:	75 22                	jne    c01059b2 <strtol+0x7e>
c0105990:	8b 45 08             	mov    0x8(%ebp),%eax
c0105993:	0f b6 00             	movzbl (%eax),%eax
c0105996:	3c 30                	cmp    $0x30,%al
c0105998:	75 18                	jne    c01059b2 <strtol+0x7e>
c010599a:	8b 45 08             	mov    0x8(%ebp),%eax
c010599d:	40                   	inc    %eax
c010599e:	0f b6 00             	movzbl (%eax),%eax
c01059a1:	3c 78                	cmp    $0x78,%al
c01059a3:	75 0d                	jne    c01059b2 <strtol+0x7e>
        s += 2, base = 16;
c01059a5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01059a9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01059b0:	eb 29                	jmp    c01059db <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c01059b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059b6:	75 16                	jne    c01059ce <strtol+0x9a>
c01059b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bb:	0f b6 00             	movzbl (%eax),%eax
c01059be:	3c 30                	cmp    $0x30,%al
c01059c0:	75 0c                	jne    c01059ce <strtol+0x9a>
        s ++, base = 8;
c01059c2:	ff 45 08             	incl   0x8(%ebp)
c01059c5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c01059cc:	eb 0d                	jmp    c01059db <strtol+0xa7>
    }
    else if (base == 0) {
c01059ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059d2:	75 07                	jne    c01059db <strtol+0xa7>
        base = 10;
c01059d4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c01059db:	8b 45 08             	mov    0x8(%ebp),%eax
c01059de:	0f b6 00             	movzbl (%eax),%eax
c01059e1:	3c 2f                	cmp    $0x2f,%al
c01059e3:	7e 1b                	jle    c0105a00 <strtol+0xcc>
c01059e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e8:	0f b6 00             	movzbl (%eax),%eax
c01059eb:	3c 39                	cmp    $0x39,%al
c01059ed:	7f 11                	jg     c0105a00 <strtol+0xcc>
            dig = *s - '0';
c01059ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f2:	0f b6 00             	movzbl (%eax),%eax
c01059f5:	0f be c0             	movsbl %al,%eax
c01059f8:	83 e8 30             	sub    $0x30,%eax
c01059fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059fe:	eb 48                	jmp    c0105a48 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105a00:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a03:	0f b6 00             	movzbl (%eax),%eax
c0105a06:	3c 60                	cmp    $0x60,%al
c0105a08:	7e 1b                	jle    c0105a25 <strtol+0xf1>
c0105a0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0d:	0f b6 00             	movzbl (%eax),%eax
c0105a10:	3c 7a                	cmp    $0x7a,%al
c0105a12:	7f 11                	jg     c0105a25 <strtol+0xf1>
            dig = *s - 'a' + 10;
c0105a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a17:	0f b6 00             	movzbl (%eax),%eax
c0105a1a:	0f be c0             	movsbl %al,%eax
c0105a1d:	83 e8 57             	sub    $0x57,%eax
c0105a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a23:	eb 23                	jmp    c0105a48 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105a25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a28:	0f b6 00             	movzbl (%eax),%eax
c0105a2b:	3c 40                	cmp    $0x40,%al
c0105a2d:	7e 3b                	jle    c0105a6a <strtol+0x136>
c0105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a32:	0f b6 00             	movzbl (%eax),%eax
c0105a35:	3c 5a                	cmp    $0x5a,%al
c0105a37:	7f 31                	jg     c0105a6a <strtol+0x136>
            dig = *s - 'A' + 10;
c0105a39:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a3c:	0f b6 00             	movzbl (%eax),%eax
c0105a3f:	0f be c0             	movsbl %al,%eax
c0105a42:	83 e8 37             	sub    $0x37,%eax
c0105a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a4b:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105a4e:	7d 19                	jge    c0105a69 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c0105a50:	ff 45 08             	incl   0x8(%ebp)
c0105a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a56:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105a5a:	89 c2                	mov    %eax,%edx
c0105a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a5f:	01 d0                	add    %edx,%eax
c0105a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c0105a64:	e9 72 ff ff ff       	jmp    c01059db <strtol+0xa7>
            break;
c0105a69:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c0105a6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a6e:	74 08                	je     c0105a78 <strtol+0x144>
        *endptr = (char *) s;
c0105a70:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a73:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a76:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105a78:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105a7c:	74 07                	je     c0105a85 <strtol+0x151>
c0105a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a81:	f7 d8                	neg    %eax
c0105a83:	eb 03                	jmp    c0105a88 <strtol+0x154>
c0105a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105a88:	89 ec                	mov    %ebp,%esp
c0105a8a:	5d                   	pop    %ebp
c0105a8b:	c3                   	ret    

c0105a8c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105a8c:	55                   	push   %ebp
c0105a8d:	89 e5                	mov    %esp,%ebp
c0105a8f:	83 ec 28             	sub    $0x28,%esp
c0105a92:	89 7d fc             	mov    %edi,-0x4(%ebp)
c0105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a98:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105a9b:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
c0105a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0105aa5:	88 55 f7             	mov    %dl,-0x9(%ebp)
c0105aa8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105aae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105ab1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105ab5:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105ab8:	89 d7                	mov    %edx,%edi
c0105aba:	f3 aa                	rep stos %al,%es:(%edi)
c0105abc:	89 fa                	mov    %edi,%edx
c0105abe:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ac1:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105ac4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105ac7:	8b 7d fc             	mov    -0x4(%ebp),%edi
c0105aca:	89 ec                	mov    %ebp,%esp
c0105acc:	5d                   	pop    %ebp
c0105acd:	c3                   	ret    

c0105ace <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105ace:	55                   	push   %ebp
c0105acf:	89 e5                	mov    %esp,%ebp
c0105ad1:	57                   	push   %edi
c0105ad2:	56                   	push   %esi
c0105ad3:	53                   	push   %ebx
c0105ad4:	83 ec 30             	sub    $0x30,%esp
c0105ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105add:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ae3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105aef:	73 42                	jae    c0105b33 <memmove+0x65>
c0105af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105afa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b00:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105b03:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105b06:	c1 e8 02             	shr    $0x2,%eax
c0105b09:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105b0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b11:	89 d7                	mov    %edx,%edi
c0105b13:	89 c6                	mov    %eax,%esi
c0105b15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105b17:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105b1a:	83 e1 03             	and    $0x3,%ecx
c0105b1d:	74 02                	je     c0105b21 <memmove+0x53>
c0105b1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105b21:	89 f0                	mov    %esi,%eax
c0105b23:	89 fa                	mov    %edi,%edx
c0105b25:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105b28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105b2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c0105b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
c0105b31:	eb 36                	jmp    c0105b69 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b36:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b3c:	01 c2                	add    %eax,%edx
c0105b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b41:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b47:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c0105b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105b4d:	89 c1                	mov    %eax,%ecx
c0105b4f:	89 d8                	mov    %ebx,%eax
c0105b51:	89 d6                	mov    %edx,%esi
c0105b53:	89 c7                	mov    %eax,%edi
c0105b55:	fd                   	std    
c0105b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105b58:	fc                   	cld    
c0105b59:	89 f8                	mov    %edi,%eax
c0105b5b:	89 f2                	mov    %esi,%edx
c0105b5d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105b60:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105b63:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105b69:	83 c4 30             	add    $0x30,%esp
c0105b6c:	5b                   	pop    %ebx
c0105b6d:	5e                   	pop    %esi
c0105b6e:	5f                   	pop    %edi
c0105b6f:	5d                   	pop    %ebp
c0105b70:	c3                   	ret    

c0105b71 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105b71:	55                   	push   %ebp
c0105b72:	89 e5                	mov    %esp,%ebp
c0105b74:	57                   	push   %edi
c0105b75:	56                   	push   %esi
c0105b76:	83 ec 20             	sub    $0x20,%esp
c0105b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b85:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b8e:	c1 e8 02             	shr    $0x2,%eax
c0105b91:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b99:	89 d7                	mov    %edx,%edi
c0105b9b:	89 c6                	mov    %eax,%esi
c0105b9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105b9f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105ba2:	83 e1 03             	and    $0x3,%ecx
c0105ba5:	74 02                	je     c0105ba9 <memcpy+0x38>
c0105ba7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ba9:	89 f0                	mov    %esi,%eax
c0105bab:	89 fa                	mov    %edi,%edx
c0105bad:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bb0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105bb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c0105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105bb9:	83 c4 20             	add    $0x20,%esp
c0105bbc:	5e                   	pop    %esi
c0105bbd:	5f                   	pop    %edi
c0105bbe:	5d                   	pop    %ebp
c0105bbf:	c3                   	ret    

c0105bc0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105bc0:	55                   	push   %ebp
c0105bc1:	89 e5                	mov    %esp,%ebp
c0105bc3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105bd2:	eb 2e                	jmp    c0105c02 <memcmp+0x42>
        if (*s1 != *s2) {
c0105bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105bd7:	0f b6 10             	movzbl (%eax),%edx
c0105bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bdd:	0f b6 00             	movzbl (%eax),%eax
c0105be0:	38 c2                	cmp    %al,%dl
c0105be2:	74 18                	je     c0105bfc <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105be7:	0f b6 00             	movzbl (%eax),%eax
c0105bea:	0f b6 d0             	movzbl %al,%edx
c0105bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bf0:	0f b6 00             	movzbl (%eax),%eax
c0105bf3:	0f b6 c8             	movzbl %al,%ecx
c0105bf6:	89 d0                	mov    %edx,%eax
c0105bf8:	29 c8                	sub    %ecx,%eax
c0105bfa:	eb 18                	jmp    c0105c14 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105bfc:	ff 45 fc             	incl   -0x4(%ebp)
c0105bff:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105c02:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c05:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c08:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c0b:	85 c0                	test   %eax,%eax
c0105c0d:	75 c5                	jne    c0105bd4 <memcmp+0x14>
    }
    return 0;
c0105c0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c14:	89 ec                	mov    %ebp,%esp
c0105c16:	5d                   	pop    %ebp
c0105c17:	c3                   	ret    
