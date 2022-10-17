
bin/kernel_nopage：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 90 11 40       	mov    $0x40119000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 90 11 00       	mov    %eax,0x119000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  100041:	2d 36 8a 11 00       	sub    $0x118a36,%eax
  100046:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100051:	00 
  100052:	c7 04 24 36 8a 11 00 	movl   $0x118a36,(%esp)
  100059:	e8 2e 5a 00 00       	call   105a8c <memset>

    cons_init();                // init the console
  10005e:	e8 32 15 00 00       	call   101595 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100063:	c7 45 f4 20 5c 10 00 	movl   $0x105c20,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10006d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100071:	c7 04 24 3c 5c 10 00 	movl   $0x105c3c,(%esp)
  100078:	e8 d9 02 00 00       	call   100356 <cprintf>

    print_kerninfo();
  10007d:	e8 f7 07 00 00       	call   100879 <print_kerninfo>

    grade_backtrace();
  100082:	e8 90 00 00 00       	call   100117 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100087:	e8 0a 41 00 00       	call   104196 <pmm_init>

    pic_init();                 // init interrupt controller
  10008c:	e8 85 16 00 00       	call   101716 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100091:	e8 e9 17 00 00       	call   10187f <idt_init>

    clock_init();               // init clock interrupt
  100096:	e8 59 0c 00 00       	call   100cf4 <clock_init>
    intr_enable();              // enable irq interrupt
  10009b:	e8 d4 15 00 00       	call   101674 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a0:	eb fe                	jmp    1000a0 <kern_init+0x6a>

001000a2 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000af:	00 
  1000b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b7:	00 
  1000b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bf:	e8 4b 0b 00 00       	call   100c0f <mon_backtrace>
}
  1000c4:	90                   	nop
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
  1000cf:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b0 ff ff ff       	call   1000a2 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000f6:	89 ec                	mov    %ebp,%esp
  1000f8:	5d                   	pop    %ebp
  1000f9:	c3                   	ret    

001000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000fa:	55                   	push   %ebp
  1000fb:	89 e5                	mov    %esp,%ebp
  1000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  100100:	8b 45 10             	mov    0x10(%ebp),%eax
  100103:	89 44 24 04          	mov    %eax,0x4(%esp)
  100107:	8b 45 08             	mov    0x8(%ebp),%eax
  10010a:	89 04 24             	mov    %eax,(%esp)
  10010d:	e8 b7 ff ff ff       	call   1000c9 <grade_backtrace1>
}
  100112:	90                   	nop
  100113:	89 ec                	mov    %ebp,%esp
  100115:	5d                   	pop    %ebp
  100116:	c3                   	ret    

00100117 <grade_backtrace>:

void
grade_backtrace(void) {
  100117:	55                   	push   %ebp
  100118:	89 e5                	mov    %esp,%ebp
  10011a:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011d:	b8 36 00 10 00       	mov    $0x100036,%eax
  100122:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100129:	ff 
  10012a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100135:	e8 c0 ff ff ff       	call   1000fa <grade_backtrace0>
}
  10013a:	90                   	nop
  10013b:	89 ec                	mov    %ebp,%esp
  10013d:	5d                   	pop    %ebp
  10013e:	c3                   	ret    

0010013f <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013f:	55                   	push   %ebp
  100140:	89 e5                	mov    %esp,%ebp
  100142:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100145:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100148:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10014b:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10014e:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	83 e0 03             	and    $0x3,%eax
  100158:	89 c2                	mov    %eax,%edx
  10015a:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10015f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100163:	89 44 24 04          	mov    %eax,0x4(%esp)
  100167:	c7 04 24 41 5c 10 00 	movl   $0x105c41,(%esp)
  10016e:	e8 e3 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100173:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100177:	89 c2                	mov    %eax,%edx
  100179:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10017e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100182:	89 44 24 04          	mov    %eax,0x4(%esp)
  100186:	c7 04 24 4f 5c 10 00 	movl   $0x105c4f,(%esp)
  10018d:	e8 c4 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100192:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100196:	89 c2                	mov    %eax,%edx
  100198:	a1 00 b0 11 00       	mov    0x11b000,%eax
  10019d:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a5:	c7 04 24 5d 5c 10 00 	movl   $0x105c5d,(%esp)
  1001ac:	e8 a5 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001b1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b5:	89 c2                	mov    %eax,%edx
  1001b7:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c4:	c7 04 24 6b 5c 10 00 	movl   $0x105c6b,(%esp)
  1001cb:	e8 86 01 00 00       	call   100356 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d4:	89 c2                	mov    %eax,%edx
  1001d6:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001db:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e3:	c7 04 24 79 5c 10 00 	movl   $0x105c79,(%esp)
  1001ea:	e8 67 01 00 00       	call   100356 <cprintf>
    round ++;
  1001ef:	a1 00 b0 11 00       	mov    0x11b000,%eax
  1001f4:	40                   	inc    %eax
  1001f5:	a3 00 b0 11 00       	mov    %eax,0x11b000
}
  1001fa:	90                   	nop
  1001fb:	89 ec                	mov    %ebp,%esp
  1001fd:	5d                   	pop    %ebp
  1001fe:	c3                   	ret    

001001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ff:	55                   	push   %ebp
  100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100202:	90                   	nop
  100203:	5d                   	pop    %ebp
  100204:	c3                   	ret    

00100205 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100205:	55                   	push   %ebp
  100206:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100208:	90                   	nop
  100209:	5d                   	pop    %ebp
  10020a:	c3                   	ret    

0010020b <lab1_switch_test>:

static void
lab1_switch_test(void) {
  10020b:	55                   	push   %ebp
  10020c:	89 e5                	mov    %esp,%ebp
  10020e:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100211:	e8 29 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100216:	c7 04 24 88 5c 10 00 	movl   $0x105c88,(%esp)
  10021d:	e8 34 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_user();
  100222:	e8 d8 ff ff ff       	call   1001ff <lab1_switch_to_user>
    lab1_print_cur_status();
  100227:	e8 13 ff ff ff       	call   10013f <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022c:	c7 04 24 a8 5c 10 00 	movl   $0x105ca8,(%esp)
  100233:	e8 1e 01 00 00       	call   100356 <cprintf>
    lab1_switch_to_kernel();
  100238:	e8 c8 ff ff ff       	call   100205 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023d:	e8 fd fe ff ff       	call   10013f <lab1_print_cur_status>
}
  100242:	90                   	nop
  100243:	89 ec                	mov    %ebp,%esp
  100245:	5d                   	pop    %ebp
  100246:	c3                   	ret    

00100247 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100247:	55                   	push   %ebp
  100248:	89 e5                	mov    %esp,%ebp
  10024a:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10024d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100251:	74 13                	je     100266 <readline+0x1f>
        cprintf("%s", prompt);
  100253:	8b 45 08             	mov    0x8(%ebp),%eax
  100256:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025a:	c7 04 24 c7 5c 10 00 	movl   $0x105cc7,(%esp)
  100261:	e8 f0 00 00 00       	call   100356 <cprintf>
    }
    int i = 0, c;
  100266:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10026d:	e8 73 01 00 00       	call   1003e5 <getchar>
  100272:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100275:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100279:	79 07                	jns    100282 <readline+0x3b>
            return NULL;
  10027b:	b8 00 00 00 00       	mov    $0x0,%eax
  100280:	eb 78                	jmp    1002fa <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100282:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100286:	7e 28                	jle    1002b0 <readline+0x69>
  100288:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10028f:	7f 1f                	jg     1002b0 <readline+0x69>
            cputchar(c);
  100291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100294:	89 04 24             	mov    %eax,(%esp)
  100297:	e8 e2 00 00 00       	call   10037e <cputchar>
            buf[i ++] = c;
  10029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10029f:	8d 50 01             	lea    0x1(%eax),%edx
  1002a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1002a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a8:	88 90 20 b0 11 00    	mov    %dl,0x11b020(%eax)
  1002ae:	eb 45                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  1002b0:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002b4:	75 16                	jne    1002cc <readline+0x85>
  1002b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ba:	7e 10                	jle    1002cc <readline+0x85>
            cputchar(c);
  1002bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002bf:	89 04 24             	mov    %eax,(%esp)
  1002c2:	e8 b7 00 00 00       	call   10037e <cputchar>
            i --;
  1002c7:	ff 4d f4             	decl   -0xc(%ebp)
  1002ca:	eb 29                	jmp    1002f5 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002cc:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002d0:	74 06                	je     1002d8 <readline+0x91>
  1002d2:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002d6:	75 95                	jne    10026d <readline+0x26>
            cputchar(c);
  1002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002db:	89 04 24             	mov    %eax,(%esp)
  1002de:	e8 9b 00 00 00       	call   10037e <cputchar>
            buf[i] = '\0';
  1002e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002e6:	05 20 b0 11 00       	add    $0x11b020,%eax
  1002eb:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002ee:	b8 20 b0 11 00       	mov    $0x11b020,%eax
  1002f3:	eb 05                	jmp    1002fa <readline+0xb3>
        c = getchar();
  1002f5:	e9 73 ff ff ff       	jmp    10026d <readline+0x26>
        }
    }
}
  1002fa:	89 ec                	mov    %ebp,%esp
  1002fc:	5d                   	pop    %ebp
  1002fd:	c3                   	ret    

001002fe <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002fe:	55                   	push   %ebp
  1002ff:	89 e5                	mov    %esp,%ebp
  100301:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100304:	8b 45 08             	mov    0x8(%ebp),%eax
  100307:	89 04 24             	mov    %eax,(%esp)
  10030a:	e8 b5 12 00 00       	call   1015c4 <cons_putc>
    (*cnt) ++;
  10030f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100312:	8b 00                	mov    (%eax),%eax
  100314:	8d 50 01             	lea    0x1(%eax),%edx
  100317:	8b 45 0c             	mov    0xc(%ebp),%eax
  10031a:	89 10                	mov    %edx,(%eax)
}
  10031c:	90                   	nop
  10031d:	89 ec                	mov    %ebp,%esp
  10031f:	5d                   	pop    %ebp
  100320:	c3                   	ret    

00100321 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100321:	55                   	push   %ebp
  100322:	89 e5                	mov    %esp,%ebp
  100324:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100327:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10032e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100331:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 44 24 08          	mov    %eax,0x8(%esp)
  10033c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	c7 04 24 fe 02 10 00 	movl   $0x1002fe,(%esp)
  10034a:	e8 68 4f 00 00       	call   1052b7 <vprintfmt>
    return cnt;
  10034f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100352:	89 ec                	mov    %ebp,%esp
  100354:	5d                   	pop    %ebp
  100355:	c3                   	ret    

00100356 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100356:	55                   	push   %ebp
  100357:	89 e5                	mov    %esp,%ebp
  100359:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10035c:	8d 45 0c             	lea    0xc(%ebp),%eax
  10035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100365:	89 44 24 04          	mov    %eax,0x4(%esp)
  100369:	8b 45 08             	mov    0x8(%ebp),%eax
  10036c:	89 04 24             	mov    %eax,(%esp)
  10036f:	e8 ad ff ff ff       	call   100321 <vcprintf>
  100374:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100377:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10037a:	89 ec                	mov    %ebp,%esp
  10037c:	5d                   	pop    %ebp
  10037d:	c3                   	ret    

0010037e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10037e:	55                   	push   %ebp
  10037f:	89 e5                	mov    %esp,%ebp
  100381:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100384:	8b 45 08             	mov    0x8(%ebp),%eax
  100387:	89 04 24             	mov    %eax,(%esp)
  10038a:	e8 35 12 00 00       	call   1015c4 <cons_putc>
}
  10038f:	90                   	nop
  100390:	89 ec                	mov    %ebp,%esp
  100392:	5d                   	pop    %ebp
  100393:	c3                   	ret    

00100394 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100394:	55                   	push   %ebp
  100395:	89 e5                	mov    %esp,%ebp
  100397:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10039a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1003a1:	eb 13                	jmp    1003b6 <cputs+0x22>
        cputch(c, &cnt);
  1003a3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1003a7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1003aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1003ae:	89 04 24             	mov    %eax,(%esp)
  1003b1:	e8 48 ff ff ff       	call   1002fe <cputch>
    while ((c = *str ++) != '\0') {
  1003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1003b9:	8d 50 01             	lea    0x1(%eax),%edx
  1003bc:	89 55 08             	mov    %edx,0x8(%ebp)
  1003bf:	0f b6 00             	movzbl (%eax),%eax
  1003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003c9:	75 d8                	jne    1003a3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003d2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003d9:	e8 20 ff ff ff       	call   1002fe <cputch>
    return cnt;
  1003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003e1:	89 ec                	mov    %ebp,%esp
  1003e3:	5d                   	pop    %ebp
  1003e4:	c3                   	ret    

001003e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003e5:	55                   	push   %ebp
  1003e6:	89 e5                	mov    %esp,%ebp
  1003e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003eb:	90                   	nop
  1003ec:	e8 12 12 00 00       	call   101603 <cons_getc>
  1003f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003f8:	74 f2                	je     1003ec <getchar+0x7>
        /* do nothing */;
    return c;
  1003fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003fd:	89 ec                	mov    %ebp,%esp
  1003ff:	5d                   	pop    %ebp
  100400:	c3                   	ret    

00100401 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100401:	55                   	push   %ebp
  100402:	89 e5                	mov    %esp,%ebp
  100404:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100407:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040a:	8b 00                	mov    (%eax),%eax
  10040c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10040f:	8b 45 10             	mov    0x10(%ebp),%eax
  100412:	8b 00                	mov    (%eax),%eax
  100414:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100417:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10041e:	e9 ca 00 00 00       	jmp    1004ed <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  100423:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100426:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100429:	01 d0                	add    %edx,%eax
  10042b:	89 c2                	mov    %eax,%edx
  10042d:	c1 ea 1f             	shr    $0x1f,%edx
  100430:	01 d0                	add    %edx,%eax
  100432:	d1 f8                	sar    %eax
  100434:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043a:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10043d:	eb 03                	jmp    100442 <stab_binsearch+0x41>
            m --;
  10043f:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100448:	7c 1f                	jl     100469 <stab_binsearch+0x68>
  10044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044d:	89 d0                	mov    %edx,%eax
  10044f:	01 c0                	add    %eax,%eax
  100451:	01 d0                	add    %edx,%eax
  100453:	c1 e0 02             	shl    $0x2,%eax
  100456:	89 c2                	mov    %eax,%edx
  100458:	8b 45 08             	mov    0x8(%ebp),%eax
  10045b:	01 d0                	add    %edx,%eax
  10045d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100461:	0f b6 c0             	movzbl %al,%eax
  100464:	39 45 14             	cmp    %eax,0x14(%ebp)
  100467:	75 d6                	jne    10043f <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10046c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10046f:	7d 09                	jge    10047a <stab_binsearch+0x79>
            l = true_m + 1;
  100471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100474:	40                   	inc    %eax
  100475:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100478:	eb 73                	jmp    1004ed <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10047a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100481:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100484:	89 d0                	mov    %edx,%eax
  100486:	01 c0                	add    %eax,%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	c1 e0 02             	shl    $0x2,%eax
  10048d:	89 c2                	mov    %eax,%edx
  10048f:	8b 45 08             	mov    0x8(%ebp),%eax
  100492:	01 d0                	add    %edx,%eax
  100494:	8b 40 08             	mov    0x8(%eax),%eax
  100497:	39 45 18             	cmp    %eax,0x18(%ebp)
  10049a:	76 11                	jbe    1004ad <stab_binsearch+0xac>
            *region_left = m;
  10049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a2:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1004a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004a7:	40                   	inc    %eax
  1004a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ab:	eb 40                	jmp    1004ed <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  1004ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004b0:	89 d0                	mov    %edx,%eax
  1004b2:	01 c0                	add    %eax,%eax
  1004b4:	01 d0                	add    %edx,%eax
  1004b6:	c1 e0 02             	shl    $0x2,%eax
  1004b9:	89 c2                	mov    %eax,%edx
  1004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004be:	01 d0                	add    %edx,%eax
  1004c0:	8b 40 08             	mov    0x8(%eax),%eax
  1004c3:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004c6:	73 14                	jae    1004dc <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	48                   	dec    %eax
  1004d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004da:	eb 11                	jmp    1004ed <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004e2:	89 10                	mov    %edx,(%eax)
            l = m;
  1004e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004ea:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004f3:	0f 8e 2a ff ff ff    	jle    100423 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004fd:	75 0f                	jne    10050e <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 00                	mov    (%eax),%eax
  100504:	8d 50 ff             	lea    -0x1(%eax),%edx
  100507:	8b 45 10             	mov    0x10(%ebp),%eax
  10050a:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10050c:	eb 3e                	jmp    10054c <stab_binsearch+0x14b>
        l = *region_right;
  10050e:	8b 45 10             	mov    0x10(%ebp),%eax
  100511:	8b 00                	mov    (%eax),%eax
  100513:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100516:	eb 03                	jmp    10051b <stab_binsearch+0x11a>
  100518:	ff 4d fc             	decl   -0x4(%ebp)
  10051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051e:	8b 00                	mov    (%eax),%eax
  100520:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100523:	7e 1f                	jle    100544 <stab_binsearch+0x143>
  100525:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100528:	89 d0                	mov    %edx,%eax
  10052a:	01 c0                	add    %eax,%eax
  10052c:	01 d0                	add    %edx,%eax
  10052e:	c1 e0 02             	shl    $0x2,%eax
  100531:	89 c2                	mov    %eax,%edx
  100533:	8b 45 08             	mov    0x8(%ebp),%eax
  100536:	01 d0                	add    %edx,%eax
  100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053c:	0f b6 c0             	movzbl %al,%eax
  10053f:	39 45 14             	cmp    %eax,0x14(%ebp)
  100542:	75 d4                	jne    100518 <stab_binsearch+0x117>
        *region_left = l;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10054a:	89 10                	mov    %edx,(%eax)
}
  10054c:	90                   	nop
  10054d:	89 ec                	mov    %ebp,%esp
  10054f:	5d                   	pop    %ebp
  100550:	c3                   	ret    

00100551 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100551:	55                   	push   %ebp
  100552:	89 e5                	mov    %esp,%ebp
  100554:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100557:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055a:	c7 00 cc 5c 10 00    	movl   $0x105ccc,(%eax)
    info->eip_line = 0;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10056a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056d:	c7 40 08 cc 5c 10 00 	movl   $0x105ccc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100574:	8b 45 0c             	mov    0xc(%ebp),%eax
  100577:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10057e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100581:	8b 55 08             	mov    0x8(%ebp),%edx
  100584:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100587:	8b 45 0c             	mov    0xc(%ebp),%eax
  10058a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100591:	c7 45 f4 38 6f 10 00 	movl   $0x106f38,-0xc(%ebp)
    stab_end = __STAB_END__;
  100598:	c7 45 f0 e0 20 11 00 	movl   $0x1120e0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10059f:	c7 45 ec e1 20 11 00 	movl   $0x1120e1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1005a6:	c7 45 e8 2d 56 11 00 	movl   $0x11562d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1005ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005b3:	76 0b                	jbe    1005c0 <debuginfo_eip+0x6f>
  1005b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005b8:	48                   	dec    %eax
  1005b9:	0f b6 00             	movzbl (%eax),%eax
  1005bc:	84 c0                	test   %al,%al
  1005be:	74 0a                	je     1005ca <debuginfo_eip+0x79>
        return -1;
  1005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005c5:	e9 ab 02 00 00       	jmp    100875 <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005d7:	c1 f8 02             	sar    $0x2,%eax
  1005da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005e0:	48                   	dec    %eax
  1005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005f2:	00 
  1005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100604:	89 04 24             	mov    %eax,(%esp)
  100607:	e8 f5 fd ff ff       	call   100401 <stab_binsearch>
    if (lfile == 0)
  10060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060f:	85 c0                	test   %eax,%eax
  100611:	75 0a                	jne    10061d <debuginfo_eip+0xcc>
        return -1;
  100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100618:	e9 58 02 00 00       	jmp    100875 <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100629:	8b 45 08             	mov    0x8(%ebp),%eax
  10062c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100637:	00 
  100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10063b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100642:	89 44 24 04          	mov    %eax,0x4(%esp)
  100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100649:	89 04 24             	mov    %eax,(%esp)
  10064c:	e8 b0 fd ff ff       	call   100401 <stab_binsearch>

    if (lfun <= rfun) {
  100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100657:	39 c2                	cmp    %eax,%edx
  100659:	7f 78                	jg     1006d3 <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	89 d0                	mov    %edx,%eax
  100662:	01 c0                	add    %eax,%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	c1 e0 02             	shl    $0x2,%eax
  100669:	89 c2                	mov    %eax,%edx
  10066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066e:	01 d0                	add    %edx,%eax
  100670:	8b 10                	mov    (%eax),%edx
  100672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100675:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100678:	39 c2                	cmp    %eax,%edx
  10067a:	73 22                	jae    10069e <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067f:	89 c2                	mov    %eax,%edx
  100681:	89 d0                	mov    %edx,%eax
  100683:	01 c0                	add    %eax,%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	c1 e0 02             	shl    $0x2,%eax
  10068a:	89 c2                	mov    %eax,%edx
  10068c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068f:	01 d0                	add    %edx,%eax
  100691:	8b 10                	mov    (%eax),%edx
  100693:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100696:	01 c2                	add    %eax,%edx
  100698:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10069e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a1:	89 c2                	mov    %eax,%edx
  1006a3:	89 d0                	mov    %edx,%eax
  1006a5:	01 c0                	add    %eax,%eax
  1006a7:	01 d0                	add    %edx,%eax
  1006a9:	c1 e0 02             	shl    $0x2,%eax
  1006ac:	89 c2                	mov    %eax,%edx
  1006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b1:	01 d0                	add    %edx,%eax
  1006b3:	8b 50 08             	mov    0x8(%eax),%edx
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 10             	mov    0x10(%eax),%eax
  1006c2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006d1:	eb 15                	jmp    1006e8 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006eb:	8b 40 08             	mov    0x8(%eax),%eax
  1006ee:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006f5:	00 
  1006f6:	89 04 24             	mov    %eax,(%esp)
  1006f9:	e8 06 52 00 00       	call   105904 <strfind>
  1006fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  100701:	8b 4a 08             	mov    0x8(%edx),%ecx
  100704:	29 c8                	sub    %ecx,%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10070b:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10070e:	8b 45 08             	mov    0x8(%ebp),%eax
  100711:	89 44 24 10          	mov    %eax,0x10(%esp)
  100715:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10071c:	00 
  10071d:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100720:	89 44 24 08          	mov    %eax,0x8(%esp)
  100724:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100727:	89 44 24 04          	mov    %eax,0x4(%esp)
  10072b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072e:	89 04 24             	mov    %eax,(%esp)
  100731:	e8 cb fc ff ff       	call   100401 <stab_binsearch>
    if (lline <= rline) {
  100736:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100739:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073c:	39 c2                	cmp    %eax,%edx
  10073e:	7f 23                	jg     100763 <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  100740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	89 d0                	mov    %edx,%eax
  100747:	01 c0                	add    %eax,%eax
  100749:	01 d0                	add    %edx,%eax
  10074b:	c1 e0 02             	shl    $0x2,%eax
  10074e:	89 c2                	mov    %eax,%edx
  100750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100759:	89 c2                	mov    %eax,%edx
  10075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100761:	eb 11                	jmp    100774 <debuginfo_eip+0x223>
        return -1;
  100763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100768:	e9 08 01 00 00       	jmp    100875 <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10076d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100770:	48                   	dec    %eax
  100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10077a:	39 c2                	cmp    %eax,%edx
  10077c:	7c 56                	jl     1007d4 <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  10077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100797:	3c 84                	cmp    $0x84,%al
  100799:	74 39                	je     1007d4 <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079e:	89 c2                	mov    %eax,%edx
  1007a0:	89 d0                	mov    %edx,%eax
  1007a2:	01 c0                	add    %eax,%eax
  1007a4:	01 d0                	add    %edx,%eax
  1007a6:	c1 e0 02             	shl    $0x2,%eax
  1007a9:	89 c2                	mov    %eax,%edx
  1007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b4:	3c 64                	cmp    $0x64,%al
  1007b6:	75 b5                	jne    10076d <debuginfo_eip+0x21c>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 40 08             	mov    0x8(%eax),%eax
  1007d0:	85 c0                	test   %eax,%eax
  1007d2:	74 99                	je     10076d <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	7c 42                	jl     100820 <debuginfo_eip+0x2cf>
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	89 c2                	mov    %eax,%edx
  1007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f1:	01 d0                	add    %edx,%eax
  1007f3:	8b 10                	mov    (%eax),%edx
  1007f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007f8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007fb:	39 c2                	cmp    %eax,%edx
  1007fd:	73 21                	jae    100820 <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	89 d0                	mov    %edx,%eax
  100806:	01 c0                	add    %eax,%eax
  100808:	01 d0                	add    %edx,%eax
  10080a:	c1 e0 02             	shl    $0x2,%eax
  10080d:	89 c2                	mov    %eax,%edx
  10080f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100812:	01 d0                	add    %edx,%eax
  100814:	8b 10                	mov    (%eax),%edx
  100816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100819:	01 c2                	add    %eax,%edx
  10081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081e:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100820:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100823:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100826:	39 c2                	cmp    %eax,%edx
  100828:	7d 46                	jge    100870 <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  10082a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082d:	40                   	inc    %eax
  10082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100831:	eb 16                	jmp    100849 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	8b 40 14             	mov    0x14(%eax),%eax
  100839:	8d 50 01             	lea    0x1(%eax),%edx
  10083c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100845:	40                   	inc    %eax
  100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7d 1d                	jge    100870 <debuginfo_eip+0x31f>
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c a0                	cmp    $0xa0,%al
  10086e:	74 c3                	je     100833 <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  100870:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100875:	89 ec                	mov    %ebp,%esp
  100877:	5d                   	pop    %ebp
  100878:	c3                   	ret    

00100879 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100879:	55                   	push   %ebp
  10087a:	89 e5                	mov    %esp,%ebp
  10087c:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10087f:	c7 04 24 d6 5c 10 00 	movl   $0x105cd6,(%esp)
  100886:	e8 cb fa ff ff       	call   100356 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088b:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100892:	00 
  100893:	c7 04 24 ef 5c 10 00 	movl   $0x105cef,(%esp)
  10089a:	e8 b7 fa ff ff       	call   100356 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10089f:	c7 44 24 04 18 5c 10 	movl   $0x105c18,0x4(%esp)
  1008a6:	00 
  1008a7:	c7 04 24 07 5d 10 00 	movl   $0x105d07,(%esp)
  1008ae:	e8 a3 fa ff ff       	call   100356 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b3:	c7 44 24 04 36 8a 11 	movl   $0x118a36,0x4(%esp)
  1008ba:	00 
  1008bb:	c7 04 24 1f 5d 10 00 	movl   $0x105d1f,(%esp)
  1008c2:	e8 8f fa ff ff       	call   100356 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008c7:	c7 44 24 04 2c bf 11 	movl   $0x11bf2c,0x4(%esp)
  1008ce:	00 
  1008cf:	c7 04 24 37 5d 10 00 	movl   $0x105d37,(%esp)
  1008d6:	e8 7b fa ff ff       	call   100356 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008db:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  1008e0:	2d 36 00 10 00       	sub    $0x100036,%eax
  1008e5:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008ea:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f0:	85 c0                	test   %eax,%eax
  1008f2:	0f 48 c2             	cmovs  %edx,%eax
  1008f5:	c1 f8 0a             	sar    $0xa,%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	c7 04 24 50 5d 10 00 	movl   $0x105d50,(%esp)
  100903:	e8 4e fa ff ff       	call   100356 <cprintf>
}
  100908:	90                   	nop
  100909:	89 ec                	mov    %ebp,%esp
  10090b:	5d                   	pop    %ebp
  10090c:	c3                   	ret    

0010090d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10090d:	55                   	push   %ebp
  10090e:	89 e5                	mov    %esp,%ebp
  100910:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100916:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10091d:	8b 45 08             	mov    0x8(%ebp),%eax
  100920:	89 04 24             	mov    %eax,(%esp)
  100923:	e8 29 fc ff ff       	call   100551 <debuginfo_eip>
  100928:	85 c0                	test   %eax,%eax
  10092a:	74 15                	je     100941 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10092c:	8b 45 08             	mov    0x8(%ebp),%eax
  10092f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100933:	c7 04 24 7a 5d 10 00 	movl   $0x105d7a,(%esp)
  10093a:	e8 17 fa ff ff       	call   100356 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  10093f:	eb 6c                	jmp    1009ad <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100948:	eb 1b                	jmp    100965 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  10094a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	0f b6 10             	movzbl (%eax),%edx
  100955:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10095e:	01 c8                	add    %ecx,%eax
  100960:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100962:	ff 45 f4             	incl   -0xc(%ebp)
  100965:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100968:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10096b:	7c dd                	jl     10094a <print_debuginfo+0x3d>
        fnname[j] = '\0';
  10096d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100976:	01 d0                	add    %edx,%eax
  100978:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  10097b:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10097e:	8b 45 08             	mov    0x8(%ebp),%eax
  100981:	29 d0                	sub    %edx,%eax
  100983:	89 c1                	mov    %eax,%ecx
  100985:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100988:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10098b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10098f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100995:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100999:	89 54 24 08          	mov    %edx,0x8(%esp)
  10099d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a1:	c7 04 24 96 5d 10 00 	movl   $0x105d96,(%esp)
  1009a8:	e8 a9 f9 ff ff       	call   100356 <cprintf>
}
  1009ad:	90                   	nop
  1009ae:	89 ec                	mov    %ebp,%esp
  1009b0:	5d                   	pop    %ebp
  1009b1:	c3                   	ret    

001009b2 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b2:	55                   	push   %ebp
  1009b3:	89 e5                	mov    %esp,%ebp
  1009b5:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009b8:	8b 45 04             	mov    0x4(%ebp),%eax
  1009bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c1:	89 ec                	mov    %ebp,%esp
  1009c3:	5d                   	pop    %ebp
  1009c4:	c3                   	ret    

001009c5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c5:	55                   	push   %ebp
  1009c6:	89 e5                	mov    %esp,%ebp
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  1009c8:	90                   	nop
  1009c9:	5d                   	pop    %ebp
  1009ca:	c3                   	ret    

001009cb <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  1009cb:	55                   	push   %ebp
  1009cc:	89 e5                	mov    %esp,%ebp
  1009ce:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  1009d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009d8:	eb 0c                	jmp    1009e6 <parse+0x1b>
            *buf ++ = '\0';
  1009da:	8b 45 08             	mov    0x8(%ebp),%eax
  1009dd:	8d 50 01             	lea    0x1(%eax),%edx
  1009e0:	89 55 08             	mov    %edx,0x8(%ebp)
  1009e3:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e9:	0f b6 00             	movzbl (%eax),%eax
  1009ec:	84 c0                	test   %al,%al
  1009ee:	74 1d                	je     100a0d <parse+0x42>
  1009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f3:	0f b6 00             	movzbl (%eax),%eax
  1009f6:	0f be c0             	movsbl %al,%eax
  1009f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fd:	c7 04 24 28 5e 10 00 	movl   $0x105e28,(%esp)
  100a04:	e8 c7 4e 00 00       	call   1058d0 <strchr>
  100a09:	85 c0                	test   %eax,%eax
  100a0b:	75 cd                	jne    1009da <parse+0xf>
        }
        if (*buf == '\0') {
  100a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a10:	0f b6 00             	movzbl (%eax),%eax
  100a13:	84 c0                	test   %al,%al
  100a15:	74 65                	je     100a7c <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a17:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a1b:	75 14                	jne    100a31 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a1d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a24:	00 
  100a25:	c7 04 24 2d 5e 10 00 	movl   $0x105e2d,(%esp)
  100a2c:	e8 25 f9 ff ff       	call   100356 <cprintf>
        }
        argv[argc ++] = buf;
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	8d 50 01             	lea    0x1(%eax),%edx
  100a37:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a44:	01 c2                	add    %eax,%edx
  100a46:	8b 45 08             	mov    0x8(%ebp),%eax
  100a49:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a4b:	eb 03                	jmp    100a50 <parse+0x85>
            buf ++;
  100a4d:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a50:	8b 45 08             	mov    0x8(%ebp),%eax
  100a53:	0f b6 00             	movzbl (%eax),%eax
  100a56:	84 c0                	test   %al,%al
  100a58:	74 8c                	je     1009e6 <parse+0x1b>
  100a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5d:	0f b6 00             	movzbl (%eax),%eax
  100a60:	0f be c0             	movsbl %al,%eax
  100a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a67:	c7 04 24 28 5e 10 00 	movl   $0x105e28,(%esp)
  100a6e:	e8 5d 4e 00 00       	call   1058d0 <strchr>
  100a73:	85 c0                	test   %eax,%eax
  100a75:	74 d6                	je     100a4d <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a77:	e9 6a ff ff ff       	jmp    1009e6 <parse+0x1b>
            break;
  100a7c:	90                   	nop
        }
    }
    return argc;
  100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100a80:	89 ec                	mov    %ebp,%esp
  100a82:	5d                   	pop    %ebp
  100a83:	c3                   	ret    

00100a84 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100a84:	55                   	push   %ebp
  100a85:	89 e5                	mov    %esp,%ebp
  100a87:	83 ec 68             	sub    $0x68,%esp
  100a8a:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100a8d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a90:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	89 04 24             	mov    %eax,(%esp)
  100a9a:	e8 2c ff ff ff       	call   1009cb <parse>
  100a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100aa2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100aa6:	75 0a                	jne    100ab2 <runcmd+0x2e>
        return 0;
  100aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  100aad:	e9 83 00 00 00       	jmp    100b35 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ab9:	eb 5a                	jmp    100b15 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100abb:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100abe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100ac1:	89 c8                	mov    %ecx,%eax
  100ac3:	01 c0                	add    %eax,%eax
  100ac5:	01 c8                	add    %ecx,%eax
  100ac7:	c1 e0 02             	shl    $0x2,%eax
  100aca:	05 00 80 11 00       	add    $0x118000,%eax
  100acf:	8b 00                	mov    (%eax),%eax
  100ad1:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ad5:	89 04 24             	mov    %eax,(%esp)
  100ad8:	e8 57 4d 00 00       	call   105834 <strcmp>
  100add:	85 c0                	test   %eax,%eax
  100adf:	75 31                	jne    100b12 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ae4:	89 d0                	mov    %edx,%eax
  100ae6:	01 c0                	add    %eax,%eax
  100ae8:	01 d0                	add    %edx,%eax
  100aea:	c1 e0 02             	shl    $0x2,%eax
  100aed:	05 08 80 11 00       	add    $0x118008,%eax
  100af2:	8b 10                	mov    (%eax),%edx
  100af4:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100af7:	83 c0 04             	add    $0x4,%eax
  100afa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100afd:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100b03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0b:	89 1c 24             	mov    %ebx,(%esp)
  100b0e:	ff d2                	call   *%edx
  100b10:	eb 23                	jmp    100b35 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100b12:	ff 45 f4             	incl   -0xc(%ebp)
  100b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b18:	83 f8 02             	cmp    $0x2,%eax
  100b1b:	76 9e                	jbe    100abb <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b1d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b24:	c7 04 24 4b 5e 10 00 	movl   $0x105e4b,(%esp)
  100b2b:	e8 26 f8 ff ff       	call   100356 <cprintf>
    return 0;
  100b30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100b38:	89 ec                	mov    %ebp,%esp
  100b3a:	5d                   	pop    %ebp
  100b3b:	c3                   	ret    

00100b3c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b3c:	55                   	push   %ebp
  100b3d:	89 e5                	mov    %esp,%ebp
  100b3f:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b42:	c7 04 24 64 5e 10 00 	movl   $0x105e64,(%esp)
  100b49:	e8 08 f8 ff ff       	call   100356 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100b4e:	c7 04 24 8c 5e 10 00 	movl   $0x105e8c,(%esp)
  100b55:	e8 fc f7 ff ff       	call   100356 <cprintf>

    if (tf != NULL) {
  100b5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b5e:	74 0b                	je     100b6b <kmonitor+0x2f>
        print_trapframe(tf);
  100b60:	8b 45 08             	mov    0x8(%ebp),%eax
  100b63:	89 04 24             	mov    %eax,(%esp)
  100b66:	e8 60 0d 00 00       	call   1018cb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b6b:	c7 04 24 b1 5e 10 00 	movl   $0x105eb1,(%esp)
  100b72:	e8 d0 f6 ff ff       	call   100247 <readline>
  100b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b7e:	74 eb                	je     100b6b <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100b80:	8b 45 08             	mov    0x8(%ebp),%eax
  100b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8a:	89 04 24             	mov    %eax,(%esp)
  100b8d:	e8 f2 fe ff ff       	call   100a84 <runcmd>
  100b92:	85 c0                	test   %eax,%eax
  100b94:	78 02                	js     100b98 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100b96:	eb d3                	jmp    100b6b <kmonitor+0x2f>
                break;
  100b98:	90                   	nop
            }
        }
    }
}
  100b99:	90                   	nop
  100b9a:	89 ec                	mov    %ebp,%esp
  100b9c:	5d                   	pop    %ebp
  100b9d:	c3                   	ret    

00100b9e <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b9e:	55                   	push   %ebp
  100b9f:	89 e5                	mov    %esp,%ebp
  100ba1:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bab:	eb 3d                	jmp    100bea <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bb0:	89 d0                	mov    %edx,%eax
  100bb2:	01 c0                	add    %eax,%eax
  100bb4:	01 d0                	add    %edx,%eax
  100bb6:	c1 e0 02             	shl    $0x2,%eax
  100bb9:	05 04 80 11 00       	add    $0x118004,%eax
  100bbe:	8b 10                	mov    (%eax),%edx
  100bc0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100bc3:	89 c8                	mov    %ecx,%eax
  100bc5:	01 c0                	add    %eax,%eax
  100bc7:	01 c8                	add    %ecx,%eax
  100bc9:	c1 e0 02             	shl    $0x2,%eax
  100bcc:	05 00 80 11 00       	add    $0x118000,%eax
  100bd1:	8b 00                	mov    (%eax),%eax
  100bd3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bdb:	c7 04 24 b5 5e 10 00 	movl   $0x105eb5,(%esp)
  100be2:	e8 6f f7 ff ff       	call   100356 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100be7:	ff 45 f4             	incl   -0xc(%ebp)
  100bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bed:	83 f8 02             	cmp    $0x2,%eax
  100bf0:	76 bb                	jbe    100bad <mon_help+0xf>
    }
    return 0;
  100bf2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bf7:	89 ec                	mov    %ebp,%esp
  100bf9:	5d                   	pop    %ebp
  100bfa:	c3                   	ret    

00100bfb <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100bfb:	55                   	push   %ebp
  100bfc:	89 e5                	mov    %esp,%ebp
  100bfe:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c01:	e8 73 fc ff ff       	call   100879 <print_kerninfo>
    return 0;
  100c06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c0b:	89 ec                	mov    %ebp,%esp
  100c0d:	5d                   	pop    %ebp
  100c0e:	c3                   	ret    

00100c0f <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c0f:	55                   	push   %ebp
  100c10:	89 e5                	mov    %esp,%ebp
  100c12:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c15:	e8 ab fd ff ff       	call   1009c5 <print_stackframe>
    return 0;
  100c1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c1f:	89 ec                	mov    %ebp,%esp
  100c21:	5d                   	pop    %ebp
  100c22:	c3                   	ret    

00100c23 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c23:	55                   	push   %ebp
  100c24:	89 e5                	mov    %esp,%ebp
  100c26:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c29:	a1 20 b4 11 00       	mov    0x11b420,%eax
  100c2e:	85 c0                	test   %eax,%eax
  100c30:	75 5b                	jne    100c8d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100c32:	c7 05 20 b4 11 00 01 	movl   $0x1,0x11b420
  100c39:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c3c:	8d 45 14             	lea    0x14(%ebp),%eax
  100c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c45:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c49:	8b 45 08             	mov    0x8(%ebp),%eax
  100c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c50:	c7 04 24 be 5e 10 00 	movl   $0x105ebe,(%esp)
  100c57:	e8 fa f6 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c63:	8b 45 10             	mov    0x10(%ebp),%eax
  100c66:	89 04 24             	mov    %eax,(%esp)
  100c69:	e8 b3 f6 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100c6e:	c7 04 24 da 5e 10 00 	movl   $0x105eda,(%esp)
  100c75:	e8 dc f6 ff ff       	call   100356 <cprintf>
    
    cprintf("stack trackback:\n");
  100c7a:	c7 04 24 dc 5e 10 00 	movl   $0x105edc,(%esp)
  100c81:	e8 d0 f6 ff ff       	call   100356 <cprintf>
    print_stackframe();
  100c86:	e8 3a fd ff ff       	call   1009c5 <print_stackframe>
  100c8b:	eb 01                	jmp    100c8e <__panic+0x6b>
        goto panic_dead;
  100c8d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100c8e:	e8 e9 09 00 00       	call   10167c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100c9a:	e8 9d fe ff ff       	call   100b3c <kmonitor>
  100c9f:	eb f2                	jmp    100c93 <__panic+0x70>

00100ca1 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ca1:	55                   	push   %ebp
  100ca2:	89 e5                	mov    %esp,%ebp
  100ca4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100ca7:	8d 45 14             	lea    0x14(%ebp),%eax
  100caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cb0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cbb:	c7 04 24 ee 5e 10 00 	movl   $0x105eee,(%esp)
  100cc2:	e8 8f f6 ff ff       	call   100356 <cprintf>
    vcprintf(fmt, ap);
  100cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cca:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cce:	8b 45 10             	mov    0x10(%ebp),%eax
  100cd1:	89 04 24             	mov    %eax,(%esp)
  100cd4:	e8 48 f6 ff ff       	call   100321 <vcprintf>
    cprintf("\n");
  100cd9:	c7 04 24 da 5e 10 00 	movl   $0x105eda,(%esp)
  100ce0:	e8 71 f6 ff ff       	call   100356 <cprintf>
    va_end(ap);
}
  100ce5:	90                   	nop
  100ce6:	89 ec                	mov    %ebp,%esp
  100ce8:	5d                   	pop    %ebp
  100ce9:	c3                   	ret    

00100cea <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100cea:	55                   	push   %ebp
  100ceb:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100ced:	a1 20 b4 11 00       	mov    0x11b420,%eax
}
  100cf2:	5d                   	pop    %ebp
  100cf3:	c3                   	ret    

00100cf4 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100cf4:	55                   	push   %ebp
  100cf5:	89 e5                	mov    %esp,%ebp
  100cf7:	83 ec 28             	sub    $0x28,%esp
  100cfa:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d00:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d04:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d08:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d0c:	ee                   	out    %al,(%dx)
}
  100d0d:	90                   	nop
  100d0e:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d14:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d18:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d1c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d20:	ee                   	out    %al,(%dx)
}
  100d21:	90                   	nop
  100d22:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d28:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d2c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d30:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d34:	ee                   	out    %al,(%dx)
}
  100d35:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d36:	c7 05 24 b4 11 00 00 	movl   $0x0,0x11b424
  100d3d:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d40:	c7 04 24 0c 5f 10 00 	movl   $0x105f0c,(%esp)
  100d47:	e8 0a f6 ff ff       	call   100356 <cprintf>
    pic_enable(IRQ_TIMER);
  100d4c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d53:	e8 89 09 00 00       	call   1016e1 <pic_enable>
}
  100d58:	90                   	nop
  100d59:	89 ec                	mov    %ebp,%esp
  100d5b:	5d                   	pop    %ebp
  100d5c:	c3                   	ret    

00100d5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100d5d:	55                   	push   %ebp
  100d5e:	89 e5                	mov    %esp,%ebp
  100d60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100d63:	9c                   	pushf  
  100d64:	58                   	pop    %eax
  100d65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100d6b:	25 00 02 00 00       	and    $0x200,%eax
  100d70:	85 c0                	test   %eax,%eax
  100d72:	74 0c                	je     100d80 <__intr_save+0x23>
        intr_disable();
  100d74:	e8 03 09 00 00       	call   10167c <intr_disable>
        return 1;
  100d79:	b8 01 00 00 00       	mov    $0x1,%eax
  100d7e:	eb 05                	jmp    100d85 <__intr_save+0x28>
    }
    return 0;
  100d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d85:	89 ec                	mov    %ebp,%esp
  100d87:	5d                   	pop    %ebp
  100d88:	c3                   	ret    

00100d89 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100d89:	55                   	push   %ebp
  100d8a:	89 e5                	mov    %esp,%ebp
  100d8c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100d8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d93:	74 05                	je     100d9a <__intr_restore+0x11>
        intr_enable();
  100d95:	e8 da 08 00 00       	call   101674 <intr_enable>
    }
}
  100d9a:	90                   	nop
  100d9b:	89 ec                	mov    %ebp,%esp
  100d9d:	5d                   	pop    %ebp
  100d9e:	c3                   	ret    

00100d9f <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d9f:	55                   	push   %ebp
  100da0:	89 e5                	mov    %esp,%ebp
  100da2:	83 ec 10             	sub    $0x10,%esp
  100da5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100dab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100daf:	89 c2                	mov    %eax,%edx
  100db1:	ec                   	in     (%dx),%al
  100db2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100db5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dbb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dbf:	89 c2                	mov    %eax,%edx
  100dc1:	ec                   	in     (%dx),%al
  100dc2:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dc5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dcb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dcf:	89 c2                	mov    %eax,%edx
  100dd1:	ec                   	in     (%dx),%al
  100dd2:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dd5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100ddb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ddf:	89 c2                	mov    %eax,%edx
  100de1:	ec                   	in     (%dx),%al
  100de2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100de5:	90                   	nop
  100de6:	89 ec                	mov    %ebp,%esp
  100de8:	5d                   	pop    %ebp
  100de9:	c3                   	ret    

00100dea <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100dea:	55                   	push   %ebp
  100deb:	89 e5                	mov    %esp,%ebp
  100ded:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100df0:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dfa:	0f b7 00             	movzwl (%eax),%eax
  100dfd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e04:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0c:	0f b7 00             	movzwl (%eax),%eax
  100e0f:	0f b7 c0             	movzwl %ax,%eax
  100e12:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e17:	74 12                	je     100e2b <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e19:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e20:	66 c7 05 46 b4 11 00 	movw   $0x3b4,0x11b446
  100e27:	b4 03 
  100e29:	eb 13                	jmp    100e3e <cga_init+0x54>
    } else {
        *cp = was;
  100e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e32:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e35:	66 c7 05 46 b4 11 00 	movw   $0x3d4,0x11b446
  100e3c:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e3e:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100e45:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e49:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e4d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e51:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e55:	ee                   	out    %al,(%dx)
}
  100e56:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100e57:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100e5e:	40                   	inc    %eax
  100e5f:	0f b7 c0             	movzwl %ax,%eax
  100e62:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e66:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e6a:	89 c2                	mov    %eax,%edx
  100e6c:	ec                   	in     (%dx),%al
  100e6d:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e70:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e74:	0f b6 c0             	movzbl %al,%eax
  100e77:	c1 e0 08             	shl    $0x8,%eax
  100e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e7d:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100e84:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e88:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e8c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e90:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e94:	ee                   	out    %al,(%dx)
}
  100e95:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100e96:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  100e9d:	40                   	inc    %eax
  100e9e:	0f b7 c0             	movzwl %ax,%eax
  100ea1:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ea5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ea9:	89 c2                	mov    %eax,%edx
  100eab:	ec                   	in     (%dx),%al
  100eac:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eaf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eb3:	0f b6 c0             	movzbl %al,%eax
  100eb6:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100eb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebc:	a3 40 b4 11 00       	mov    %eax,0x11b440
    crt_pos = pos;
  100ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ec4:	0f b7 c0             	movzwl %ax,%eax
  100ec7:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
}
  100ecd:	90                   	nop
  100ece:	89 ec                	mov    %ebp,%esp
  100ed0:	5d                   	pop    %ebp
  100ed1:	c3                   	ret    

00100ed2 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ed2:	55                   	push   %ebp
  100ed3:	89 e5                	mov    %esp,%ebp
  100ed5:	83 ec 48             	sub    $0x48,%esp
  100ed8:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ede:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ee6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100eea:	ee                   	out    %al,(%dx)
}
  100eeb:	90                   	nop
  100eec:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ef2:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef6:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100efa:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100efe:	ee                   	out    %al,(%dx)
}
  100eff:	90                   	nop
  100f00:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f06:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0a:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f0e:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f12:	ee                   	out    %al,(%dx)
}
  100f13:	90                   	nop
  100f14:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f1a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f1e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f22:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f26:	ee                   	out    %al,(%dx)
}
  100f27:	90                   	nop
  100f28:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f2e:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f32:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f36:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f3a:	ee                   	out    %al,(%dx)
}
  100f3b:	90                   	nop
  100f3c:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f42:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f46:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f4a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f4e:	ee                   	out    %al,(%dx)
}
  100f4f:	90                   	nop
  100f50:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f56:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f5a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f5e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f62:	ee                   	out    %al,(%dx)
}
  100f63:	90                   	nop
  100f64:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f6a:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f6e:	89 c2                	mov    %eax,%edx
  100f70:	ec                   	in     (%dx),%al
  100f71:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f74:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f78:	3c ff                	cmp    $0xff,%al
  100f7a:	0f 95 c0             	setne  %al
  100f7d:	0f b6 c0             	movzbl %al,%eax
  100f80:	a3 48 b4 11 00       	mov    %eax,0x11b448
  100f85:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f8b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f8f:	89 c2                	mov    %eax,%edx
  100f91:	ec                   	in     (%dx),%al
  100f92:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f95:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f9b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f9f:	89 c2                	mov    %eax,%edx
  100fa1:	ec                   	in     (%dx),%al
  100fa2:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fa5:	a1 48 b4 11 00       	mov    0x11b448,%eax
  100faa:	85 c0                	test   %eax,%eax
  100fac:	74 0c                	je     100fba <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  100fae:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fb5:	e8 27 07 00 00       	call   1016e1 <pic_enable>
    }
}
  100fba:	90                   	nop
  100fbb:	89 ec                	mov    %ebp,%esp
  100fbd:	5d                   	pop    %ebp
  100fbe:	c3                   	ret    

00100fbf <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fbf:	55                   	push   %ebp
  100fc0:	89 e5                	mov    %esp,%ebp
  100fc2:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fcc:	eb 08                	jmp    100fd6 <lpt_putc_sub+0x17>
        delay();
  100fce:	e8 cc fd ff ff       	call   100d9f <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd3:	ff 45 fc             	incl   -0x4(%ebp)
  100fd6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fdc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fe0:	89 c2                	mov    %eax,%edx
  100fe2:	ec                   	in     (%dx),%al
  100fe3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fe6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fea:	84 c0                	test   %al,%al
  100fec:	78 09                	js     100ff7 <lpt_putc_sub+0x38>
  100fee:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100ff5:	7e d7                	jle    100fce <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  100ffa:	0f b6 c0             	movzbl %al,%eax
  100ffd:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101003:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101006:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10100a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10100e:	ee                   	out    %al,(%dx)
}
  10100f:	90                   	nop
  101010:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101016:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10101a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10101e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101022:	ee                   	out    %al,(%dx)
}
  101023:	90                   	nop
  101024:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10102a:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10102e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101032:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101036:	ee                   	out    %al,(%dx)
}
  101037:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101038:	90                   	nop
  101039:	89 ec                	mov    %ebp,%esp
  10103b:	5d                   	pop    %ebp
  10103c:	c3                   	ret    

0010103d <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10103d:	55                   	push   %ebp
  10103e:	89 e5                	mov    %esp,%ebp
  101040:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101043:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101047:	74 0d                	je     101056 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101049:	8b 45 08             	mov    0x8(%ebp),%eax
  10104c:	89 04 24             	mov    %eax,(%esp)
  10104f:	e8 6b ff ff ff       	call   100fbf <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101054:	eb 24                	jmp    10107a <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  101056:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10105d:	e8 5d ff ff ff       	call   100fbf <lpt_putc_sub>
        lpt_putc_sub(' ');
  101062:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101069:	e8 51 ff ff ff       	call   100fbf <lpt_putc_sub>
        lpt_putc_sub('\b');
  10106e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101075:	e8 45 ff ff ff       	call   100fbf <lpt_putc_sub>
}
  10107a:	90                   	nop
  10107b:	89 ec                	mov    %ebp,%esp
  10107d:	5d                   	pop    %ebp
  10107e:	c3                   	ret    

0010107f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10107f:	55                   	push   %ebp
  101080:	89 e5                	mov    %esp,%ebp
  101082:	83 ec 38             	sub    $0x38,%esp
  101085:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  101088:	8b 45 08             	mov    0x8(%ebp),%eax
  10108b:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101090:	85 c0                	test   %eax,%eax
  101092:	75 07                	jne    10109b <cga_putc+0x1c>
        c |= 0x0700;
  101094:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10109b:	8b 45 08             	mov    0x8(%ebp),%eax
  10109e:	0f b6 c0             	movzbl %al,%eax
  1010a1:	83 f8 0d             	cmp    $0xd,%eax
  1010a4:	74 72                	je     101118 <cga_putc+0x99>
  1010a6:	83 f8 0d             	cmp    $0xd,%eax
  1010a9:	0f 8f a3 00 00 00    	jg     101152 <cga_putc+0xd3>
  1010af:	83 f8 08             	cmp    $0x8,%eax
  1010b2:	74 0a                	je     1010be <cga_putc+0x3f>
  1010b4:	83 f8 0a             	cmp    $0xa,%eax
  1010b7:	74 4c                	je     101105 <cga_putc+0x86>
  1010b9:	e9 94 00 00 00       	jmp    101152 <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  1010be:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1010c5:	85 c0                	test   %eax,%eax
  1010c7:	0f 84 af 00 00 00    	je     10117c <cga_putc+0xfd>
            crt_pos --;
  1010cd:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1010d4:	48                   	dec    %eax
  1010d5:	0f b7 c0             	movzwl %ax,%eax
  1010d8:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010de:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e1:	98                   	cwtl   
  1010e2:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010e7:	98                   	cwtl   
  1010e8:	83 c8 20             	or     $0x20,%eax
  1010eb:	98                   	cwtl   
  1010ec:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  1010f2:	0f b7 15 44 b4 11 00 	movzwl 0x11b444,%edx
  1010f9:	01 d2                	add    %edx,%edx
  1010fb:	01 ca                	add    %ecx,%edx
  1010fd:	0f b7 c0             	movzwl %ax,%eax
  101100:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101103:	eb 77                	jmp    10117c <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101105:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10110c:	83 c0 50             	add    $0x50,%eax
  10110f:	0f b7 c0             	movzwl %ax,%eax
  101112:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101118:	0f b7 1d 44 b4 11 00 	movzwl 0x11b444,%ebx
  10111f:	0f b7 0d 44 b4 11 00 	movzwl 0x11b444,%ecx
  101126:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10112b:	89 c8                	mov    %ecx,%eax
  10112d:	f7 e2                	mul    %edx
  10112f:	c1 ea 06             	shr    $0x6,%edx
  101132:	89 d0                	mov    %edx,%eax
  101134:	c1 e0 02             	shl    $0x2,%eax
  101137:	01 d0                	add    %edx,%eax
  101139:	c1 e0 04             	shl    $0x4,%eax
  10113c:	29 c1                	sub    %eax,%ecx
  10113e:	89 ca                	mov    %ecx,%edx
  101140:	0f b7 d2             	movzwl %dx,%edx
  101143:	89 d8                	mov    %ebx,%eax
  101145:	29 d0                	sub    %edx,%eax
  101147:	0f b7 c0             	movzwl %ax,%eax
  10114a:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
        break;
  101150:	eb 2b                	jmp    10117d <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101152:	8b 0d 40 b4 11 00    	mov    0x11b440,%ecx
  101158:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10115f:	8d 50 01             	lea    0x1(%eax),%edx
  101162:	0f b7 d2             	movzwl %dx,%edx
  101165:	66 89 15 44 b4 11 00 	mov    %dx,0x11b444
  10116c:	01 c0                	add    %eax,%eax
  10116e:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101171:	8b 45 08             	mov    0x8(%ebp),%eax
  101174:	0f b7 c0             	movzwl %ax,%eax
  101177:	66 89 02             	mov    %ax,(%edx)
        break;
  10117a:	eb 01                	jmp    10117d <cga_putc+0xfe>
        break;
  10117c:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10117d:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101184:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101189:	76 5e                	jbe    1011e9 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10118b:	a1 40 b4 11 00       	mov    0x11b440,%eax
  101190:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101196:	a1 40 b4 11 00       	mov    0x11b440,%eax
  10119b:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a2:	00 
  1011a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a7:	89 04 24             	mov    %eax,(%esp)
  1011aa:	e8 1f 49 00 00       	call   105ace <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011af:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011b6:	eb 15                	jmp    1011cd <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  1011b8:	8b 15 40 b4 11 00    	mov    0x11b440,%edx
  1011be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1011c1:	01 c0                	add    %eax,%eax
  1011c3:	01 d0                	add    %edx,%eax
  1011c5:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ca:	ff 45 f4             	incl   -0xc(%ebp)
  1011cd:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d4:	7e e2                	jle    1011b8 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  1011d6:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  1011dd:	83 e8 50             	sub    $0x50,%eax
  1011e0:	0f b7 c0             	movzwl %ax,%eax
  1011e3:	66 a3 44 b4 11 00    	mov    %ax,0x11b444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011e9:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  1011f0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011f4:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1011f8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011fc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101200:	ee                   	out    %al,(%dx)
}
  101201:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101202:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  101209:	c1 e8 08             	shr    $0x8,%eax
  10120c:	0f b7 c0             	movzwl %ax,%eax
  10120f:	0f b6 c0             	movzbl %al,%eax
  101212:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  101219:	42                   	inc    %edx
  10121a:	0f b7 d2             	movzwl %dx,%edx
  10121d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101221:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101224:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101228:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10122c:	ee                   	out    %al,(%dx)
}
  10122d:	90                   	nop
    outb(addr_6845, 15);
  10122e:	0f b7 05 46 b4 11 00 	movzwl 0x11b446,%eax
  101235:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101239:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10123d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101241:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101245:	ee                   	out    %al,(%dx)
}
  101246:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101247:	0f b7 05 44 b4 11 00 	movzwl 0x11b444,%eax
  10124e:	0f b6 c0             	movzbl %al,%eax
  101251:	0f b7 15 46 b4 11 00 	movzwl 0x11b446,%edx
  101258:	42                   	inc    %edx
  101259:	0f b7 d2             	movzwl %dx,%edx
  10125c:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101260:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101263:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101267:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10126b:	ee                   	out    %al,(%dx)
}
  10126c:	90                   	nop
}
  10126d:	90                   	nop
  10126e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101271:	89 ec                	mov    %ebp,%esp
  101273:	5d                   	pop    %ebp
  101274:	c3                   	ret    

00101275 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101275:	55                   	push   %ebp
  101276:	89 e5                	mov    %esp,%ebp
  101278:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101282:	eb 08                	jmp    10128c <serial_putc_sub+0x17>
        delay();
  101284:	e8 16 fb ff ff       	call   100d9f <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101289:	ff 45 fc             	incl   -0x4(%ebp)
  10128c:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101292:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101296:	89 c2                	mov    %eax,%edx
  101298:	ec                   	in     (%dx),%al
  101299:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10129c:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012a0:	0f b6 c0             	movzbl %al,%eax
  1012a3:	83 e0 20             	and    $0x20,%eax
  1012a6:	85 c0                	test   %eax,%eax
  1012a8:	75 09                	jne    1012b3 <serial_putc_sub+0x3e>
  1012aa:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b1:	7e d1                	jle    101284 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b6:	0f b6 c0             	movzbl %al,%eax
  1012b9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012bf:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012ca:	ee                   	out    %al,(%dx)
}
  1012cb:	90                   	nop
}
  1012cc:	90                   	nop
  1012cd:	89 ec                	mov    %ebp,%esp
  1012cf:	5d                   	pop    %ebp
  1012d0:	c3                   	ret    

001012d1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012d1:	55                   	push   %ebp
  1012d2:	89 e5                	mov    %esp,%ebp
  1012d4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012db:	74 0d                	je     1012ea <serial_putc+0x19>
        serial_putc_sub(c);
  1012dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e0:	89 04 24             	mov    %eax,(%esp)
  1012e3:	e8 8d ff ff ff       	call   101275 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012e8:	eb 24                	jmp    10130e <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012ea:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f1:	e8 7f ff ff ff       	call   101275 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012fd:	e8 73 ff ff ff       	call   101275 <serial_putc_sub>
        serial_putc_sub('\b');
  101302:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101309:	e8 67 ff ff ff       	call   101275 <serial_putc_sub>
}
  10130e:	90                   	nop
  10130f:	89 ec                	mov    %ebp,%esp
  101311:	5d                   	pop    %ebp
  101312:	c3                   	ret    

00101313 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101313:	55                   	push   %ebp
  101314:	89 e5                	mov    %esp,%ebp
  101316:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101319:	eb 33                	jmp    10134e <cons_intr+0x3b>
        if (c != 0) {
  10131b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10131f:	74 2d                	je     10134e <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101321:	a1 64 b6 11 00       	mov    0x11b664,%eax
  101326:	8d 50 01             	lea    0x1(%eax),%edx
  101329:	89 15 64 b6 11 00    	mov    %edx,0x11b664
  10132f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101332:	88 90 60 b4 11 00    	mov    %dl,0x11b460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101338:	a1 64 b6 11 00       	mov    0x11b664,%eax
  10133d:	3d 00 02 00 00       	cmp    $0x200,%eax
  101342:	75 0a                	jne    10134e <cons_intr+0x3b>
                cons.wpos = 0;
  101344:	c7 05 64 b6 11 00 00 	movl   $0x0,0x11b664
  10134b:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10134e:	8b 45 08             	mov    0x8(%ebp),%eax
  101351:	ff d0                	call   *%eax
  101353:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101356:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10135a:	75 bf                	jne    10131b <cons_intr+0x8>
            }
        }
    }
}
  10135c:	90                   	nop
  10135d:	90                   	nop
  10135e:	89 ec                	mov    %ebp,%esp
  101360:	5d                   	pop    %ebp
  101361:	c3                   	ret    

00101362 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101362:	55                   	push   %ebp
  101363:	89 e5                	mov    %esp,%ebp
  101365:	83 ec 10             	sub    $0x10,%esp
  101368:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10136e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101372:	89 c2                	mov    %eax,%edx
  101374:	ec                   	in     (%dx),%al
  101375:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101378:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10137c:	0f b6 c0             	movzbl %al,%eax
  10137f:	83 e0 01             	and    $0x1,%eax
  101382:	85 c0                	test   %eax,%eax
  101384:	75 07                	jne    10138d <serial_proc_data+0x2b>
        return -1;
  101386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10138b:	eb 2a                	jmp    1013b7 <serial_proc_data+0x55>
  10138d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101393:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101397:	89 c2                	mov    %eax,%edx
  101399:	ec                   	in     (%dx),%al
  10139a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10139d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013a1:	0f b6 c0             	movzbl %al,%eax
  1013a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013a7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ab:	75 07                	jne    1013b4 <serial_proc_data+0x52>
        c = '\b';
  1013ad:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013b7:	89 ec                	mov    %ebp,%esp
  1013b9:	5d                   	pop    %ebp
  1013ba:	c3                   	ret    

001013bb <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013bb:	55                   	push   %ebp
  1013bc:	89 e5                	mov    %esp,%ebp
  1013be:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013c1:	a1 48 b4 11 00       	mov    0x11b448,%eax
  1013c6:	85 c0                	test   %eax,%eax
  1013c8:	74 0c                	je     1013d6 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013ca:	c7 04 24 62 13 10 00 	movl   $0x101362,(%esp)
  1013d1:	e8 3d ff ff ff       	call   101313 <cons_intr>
    }
}
  1013d6:	90                   	nop
  1013d7:	89 ec                	mov    %ebp,%esp
  1013d9:	5d                   	pop    %ebp
  1013da:	c3                   	ret    

001013db <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013db:	55                   	push   %ebp
  1013dc:	89 e5                	mov    %esp,%ebp
  1013de:	83 ec 38             	sub    $0x38,%esp
  1013e1:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013ea:	89 c2                	mov    %eax,%edx
  1013ec:	ec                   	in     (%dx),%al
  1013ed:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013f0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013f4:	0f b6 c0             	movzbl %al,%eax
  1013f7:	83 e0 01             	and    $0x1,%eax
  1013fa:	85 c0                	test   %eax,%eax
  1013fc:	75 0a                	jne    101408 <kbd_proc_data+0x2d>
        return -1;
  1013fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101403:	e9 56 01 00 00       	jmp    10155e <kbd_proc_data+0x183>
  101408:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101411:	89 c2                	mov    %eax,%edx
  101413:	ec                   	in     (%dx),%al
  101414:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101417:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10141b:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10141e:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101422:	75 17                	jne    10143b <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101424:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101429:	83 c8 40             	or     $0x40,%eax
  10142c:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  101431:	b8 00 00 00 00       	mov    $0x0,%eax
  101436:	e9 23 01 00 00       	jmp    10155e <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  10143b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143f:	84 c0                	test   %al,%al
  101441:	79 45                	jns    101488 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101443:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101448:	83 e0 40             	and    $0x40,%eax
  10144b:	85 c0                	test   %eax,%eax
  10144d:	75 08                	jne    101457 <kbd_proc_data+0x7c>
  10144f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101453:	24 7f                	and    $0x7f,%al
  101455:	eb 04                	jmp    10145b <kbd_proc_data+0x80>
  101457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145b:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10145e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101462:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  101469:	0c 40                	or     $0x40,%al
  10146b:	0f b6 c0             	movzbl %al,%eax
  10146e:	f7 d0                	not    %eax
  101470:	89 c2                	mov    %eax,%edx
  101472:	a1 68 b6 11 00       	mov    0x11b668,%eax
  101477:	21 d0                	and    %edx,%eax
  101479:	a3 68 b6 11 00       	mov    %eax,0x11b668
        return 0;
  10147e:	b8 00 00 00 00       	mov    $0x0,%eax
  101483:	e9 d6 00 00 00       	jmp    10155e <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  101488:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10148d:	83 e0 40             	and    $0x40,%eax
  101490:	85 c0                	test   %eax,%eax
  101492:	74 11                	je     1014a5 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101494:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101498:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10149d:	83 e0 bf             	and    $0xffffffbf,%eax
  1014a0:	a3 68 b6 11 00       	mov    %eax,0x11b668
    }

    shift |= shiftcode[data];
  1014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a9:	0f b6 80 40 80 11 00 	movzbl 0x118040(%eax),%eax
  1014b0:	0f b6 d0             	movzbl %al,%edx
  1014b3:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014b8:	09 d0                	or     %edx,%eax
  1014ba:	a3 68 b6 11 00       	mov    %eax,0x11b668
    shift ^= togglecode[data];
  1014bf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c3:	0f b6 80 40 81 11 00 	movzbl 0x118140(%eax),%eax
  1014ca:	0f b6 d0             	movzbl %al,%edx
  1014cd:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014d2:	31 d0                	xor    %edx,%eax
  1014d4:	a3 68 b6 11 00       	mov    %eax,0x11b668

    c = charcode[shift & (CTL | SHIFT)][data];
  1014d9:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014de:	83 e0 03             	and    $0x3,%eax
  1014e1:	8b 14 85 40 85 11 00 	mov    0x118540(,%eax,4),%edx
  1014e8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ec:	01 d0                	add    %edx,%eax
  1014ee:	0f b6 00             	movzbl (%eax),%eax
  1014f1:	0f b6 c0             	movzbl %al,%eax
  1014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014f7:	a1 68 b6 11 00       	mov    0x11b668,%eax
  1014fc:	83 e0 08             	and    $0x8,%eax
  1014ff:	85 c0                	test   %eax,%eax
  101501:	74 22                	je     101525 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101503:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101507:	7e 0c                	jle    101515 <kbd_proc_data+0x13a>
  101509:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10150d:	7f 06                	jg     101515 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10150f:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101513:	eb 10                	jmp    101525 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101515:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101519:	7e 0a                	jle    101525 <kbd_proc_data+0x14a>
  10151b:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10151f:	7f 04                	jg     101525 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101521:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101525:	a1 68 b6 11 00       	mov    0x11b668,%eax
  10152a:	f7 d0                	not    %eax
  10152c:	83 e0 06             	and    $0x6,%eax
  10152f:	85 c0                	test   %eax,%eax
  101531:	75 28                	jne    10155b <kbd_proc_data+0x180>
  101533:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10153a:	75 1f                	jne    10155b <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  10153c:	c7 04 24 27 5f 10 00 	movl   $0x105f27,(%esp)
  101543:	e8 0e ee ff ff       	call   100356 <cprintf>
  101548:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10154e:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101552:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101556:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101559:	ee                   	out    %al,(%dx)
}
  10155a:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10155e:	89 ec                	mov    %ebp,%esp
  101560:	5d                   	pop    %ebp
  101561:	c3                   	ret    

00101562 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101562:	55                   	push   %ebp
  101563:	89 e5                	mov    %esp,%ebp
  101565:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101568:	c7 04 24 db 13 10 00 	movl   $0x1013db,(%esp)
  10156f:	e8 9f fd ff ff       	call   101313 <cons_intr>
}
  101574:	90                   	nop
  101575:	89 ec                	mov    %ebp,%esp
  101577:	5d                   	pop    %ebp
  101578:	c3                   	ret    

00101579 <kbd_init>:

static void
kbd_init(void) {
  101579:	55                   	push   %ebp
  10157a:	89 e5                	mov    %esp,%ebp
  10157c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10157f:	e8 de ff ff ff       	call   101562 <kbd_intr>
    pic_enable(IRQ_KBD);
  101584:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10158b:	e8 51 01 00 00       	call   1016e1 <pic_enable>
}
  101590:	90                   	nop
  101591:	89 ec                	mov    %ebp,%esp
  101593:	5d                   	pop    %ebp
  101594:	c3                   	ret    

00101595 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101595:	55                   	push   %ebp
  101596:	89 e5                	mov    %esp,%ebp
  101598:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10159b:	e8 4a f8 ff ff       	call   100dea <cga_init>
    serial_init();
  1015a0:	e8 2d f9 ff ff       	call   100ed2 <serial_init>
    kbd_init();
  1015a5:	e8 cf ff ff ff       	call   101579 <kbd_init>
    if (!serial_exists) {
  1015aa:	a1 48 b4 11 00       	mov    0x11b448,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	75 0c                	jne    1015bf <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015b3:	c7 04 24 33 5f 10 00 	movl   $0x105f33,(%esp)
  1015ba:	e8 97 ed ff ff       	call   100356 <cprintf>
    }
}
  1015bf:	90                   	nop
  1015c0:	89 ec                	mov    %ebp,%esp
  1015c2:	5d                   	pop    %ebp
  1015c3:	c3                   	ret    

001015c4 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015c4:	55                   	push   %ebp
  1015c5:	89 e5                	mov    %esp,%ebp
  1015c7:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015ca:	e8 8e f7 ff ff       	call   100d5d <__intr_save>
  1015cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d5:	89 04 24             	mov    %eax,(%esp)
  1015d8:	e8 60 fa ff ff       	call   10103d <lpt_putc>
        cga_putc(c);
  1015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1015e0:	89 04 24             	mov    %eax,(%esp)
  1015e3:	e8 97 fa ff ff       	call   10107f <cga_putc>
        serial_putc(c);
  1015e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015eb:	89 04 24             	mov    %eax,(%esp)
  1015ee:	e8 de fc ff ff       	call   1012d1 <serial_putc>
    }
    local_intr_restore(intr_flag);
  1015f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015f6:	89 04 24             	mov    %eax,(%esp)
  1015f9:	e8 8b f7 ff ff       	call   100d89 <__intr_restore>
}
  1015fe:	90                   	nop
  1015ff:	89 ec                	mov    %ebp,%esp
  101601:	5d                   	pop    %ebp
  101602:	c3                   	ret    

00101603 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101603:	55                   	push   %ebp
  101604:	89 e5                	mov    %esp,%ebp
  101606:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101609:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101610:	e8 48 f7 ff ff       	call   100d5d <__intr_save>
  101615:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101618:	e8 9e fd ff ff       	call   1013bb <serial_intr>
        kbd_intr();
  10161d:	e8 40 ff ff ff       	call   101562 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101622:	8b 15 60 b6 11 00    	mov    0x11b660,%edx
  101628:	a1 64 b6 11 00       	mov    0x11b664,%eax
  10162d:	39 c2                	cmp    %eax,%edx
  10162f:	74 31                	je     101662 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101631:	a1 60 b6 11 00       	mov    0x11b660,%eax
  101636:	8d 50 01             	lea    0x1(%eax),%edx
  101639:	89 15 60 b6 11 00    	mov    %edx,0x11b660
  10163f:	0f b6 80 60 b4 11 00 	movzbl 0x11b460(%eax),%eax
  101646:	0f b6 c0             	movzbl %al,%eax
  101649:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10164c:	a1 60 b6 11 00       	mov    0x11b660,%eax
  101651:	3d 00 02 00 00       	cmp    $0x200,%eax
  101656:	75 0a                	jne    101662 <cons_getc+0x5f>
                cons.rpos = 0;
  101658:	c7 05 60 b6 11 00 00 	movl   $0x0,0x11b660
  10165f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101665:	89 04 24             	mov    %eax,(%esp)
  101668:	e8 1c f7 ff ff       	call   100d89 <__intr_restore>
    return c;
  10166d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101670:	89 ec                	mov    %ebp,%esp
  101672:	5d                   	pop    %ebp
  101673:	c3                   	ret    

00101674 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101674:	55                   	push   %ebp
  101675:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101677:	fb                   	sti    
}
  101678:	90                   	nop
    sti();
}
  101679:	90                   	nop
  10167a:	5d                   	pop    %ebp
  10167b:	c3                   	ret    

0010167c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10167c:	55                   	push   %ebp
  10167d:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  10167f:	fa                   	cli    
}
  101680:	90                   	nop
    cli();
}
  101681:	90                   	nop
  101682:	5d                   	pop    %ebp
  101683:	c3                   	ret    

00101684 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101684:	55                   	push   %ebp
  101685:	89 e5                	mov    %esp,%ebp
  101687:	83 ec 14             	sub    $0x14,%esp
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101694:	66 a3 50 85 11 00    	mov    %ax,0x118550
    if (did_init) {
  10169a:	a1 6c b6 11 00       	mov    0x11b66c,%eax
  10169f:	85 c0                	test   %eax,%eax
  1016a1:	74 39                	je     1016dc <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016a6:	0f b6 c0             	movzbl %al,%eax
  1016a9:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016af:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016b2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016b6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016ba:	ee                   	out    %al,(%dx)
}
  1016bb:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	c1 e8 08             	shr    $0x8,%eax
  1016c3:	0f b7 c0             	movzwl %ax,%eax
  1016c6:	0f b6 c0             	movzbl %al,%eax
  1016c9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016cf:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016d2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016da:	ee                   	out    %al,(%dx)
}
  1016db:	90                   	nop
    }
}
  1016dc:	90                   	nop
  1016dd:	89 ec                	mov    %ebp,%esp
  1016df:	5d                   	pop    %ebp
  1016e0:	c3                   	ret    

001016e1 <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016e1:	55                   	push   %ebp
  1016e2:	89 e5                	mov    %esp,%ebp
  1016e4:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1016ea:	ba 01 00 00 00       	mov    $0x1,%edx
  1016ef:	88 c1                	mov    %al,%cl
  1016f1:	d3 e2                	shl    %cl,%edx
  1016f3:	89 d0                	mov    %edx,%eax
  1016f5:	98                   	cwtl   
  1016f6:	f7 d0                	not    %eax
  1016f8:	0f bf d0             	movswl %ax,%edx
  1016fb:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101702:	98                   	cwtl   
  101703:	21 d0                	and    %edx,%eax
  101705:	98                   	cwtl   
  101706:	0f b7 c0             	movzwl %ax,%eax
  101709:	89 04 24             	mov    %eax,(%esp)
  10170c:	e8 73 ff ff ff       	call   101684 <pic_setmask>
}
  101711:	90                   	nop
  101712:	89 ec                	mov    %ebp,%esp
  101714:	5d                   	pop    %ebp
  101715:	c3                   	ret    

00101716 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101716:	55                   	push   %ebp
  101717:	89 e5                	mov    %esp,%ebp
  101719:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10171c:	c7 05 6c b6 11 00 01 	movl   $0x1,0x11b66c
  101723:	00 00 00 
  101726:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  10172c:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101730:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101734:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101738:	ee                   	out    %al,(%dx)
}
  101739:	90                   	nop
  10173a:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101740:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101744:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101748:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10174c:	ee                   	out    %al,(%dx)
}
  10174d:	90                   	nop
  10174e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101754:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101758:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10175c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
}
  101761:	90                   	nop
  101762:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101768:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10176c:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101770:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101774:	ee                   	out    %al,(%dx)
}
  101775:	90                   	nop
  101776:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  10177c:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101780:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101784:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
}
  101789:	90                   	nop
  10178a:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101790:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101794:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101798:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10179c:	ee                   	out    %al,(%dx)
}
  10179d:	90                   	nop
  10179e:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017a4:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017a8:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017ac:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
}
  1017b1:	90                   	nop
  1017b2:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017b8:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017bc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c4:	ee                   	out    %al,(%dx)
}
  1017c5:	90                   	nop
  1017c6:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017cc:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017d0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017d4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017d8:	ee                   	out    %al,(%dx)
}
  1017d9:	90                   	nop
  1017da:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017e0:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017e8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
}
  1017ed:	90                   	nop
  1017ee:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  1017f4:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017f8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017fc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101800:	ee                   	out    %al,(%dx)
}
  101801:	90                   	nop
  101802:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101808:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10180c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101810:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101814:	ee                   	out    %al,(%dx)
}
  101815:	90                   	nop
  101816:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10181c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101820:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101824:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
}
  101829:	90                   	nop
  10182a:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101830:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101834:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101838:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10183c:	ee                   	out    %al,(%dx)
}
  10183d:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10183e:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101845:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10184a:	74 0f                	je     10185b <pic_init+0x145>
        pic_setmask(irq_mask);
  10184c:	0f b7 05 50 85 11 00 	movzwl 0x118550,%eax
  101853:	89 04 24             	mov    %eax,(%esp)
  101856:	e8 29 fe ff ff       	call   101684 <pic_setmask>
    }
}
  10185b:	90                   	nop
  10185c:	89 ec                	mov    %ebp,%esp
  10185e:	5d                   	pop    %ebp
  10185f:	c3                   	ret    

00101860 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101860:	55                   	push   %ebp
  101861:	89 e5                	mov    %esp,%ebp
  101863:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101866:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10186d:	00 
  10186e:	c7 04 24 60 5f 10 00 	movl   $0x105f60,(%esp)
  101875:	e8 dc ea ff ff       	call   100356 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10187a:	90                   	nop
  10187b:	89 ec                	mov    %ebp,%esp
  10187d:	5d                   	pop    %ebp
  10187e:	c3                   	ret    

0010187f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10187f:	55                   	push   %ebp
  101880:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101882:	90                   	nop
  101883:	5d                   	pop    %ebp
  101884:	c3                   	ret    

00101885 <trapname>:

static const char *
trapname(int trapno) {
  101885:	55                   	push   %ebp
  101886:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101888:	8b 45 08             	mov    0x8(%ebp),%eax
  10188b:	83 f8 13             	cmp    $0x13,%eax
  10188e:	77 0c                	ja     10189c <trapname+0x17>
        return excnames[trapno];
  101890:	8b 45 08             	mov    0x8(%ebp),%eax
  101893:	8b 04 85 c0 62 10 00 	mov    0x1062c0(,%eax,4),%eax
  10189a:	eb 18                	jmp    1018b4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10189c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1018a0:	7e 0d                	jle    1018af <trapname+0x2a>
  1018a2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1018a6:	7f 07                	jg     1018af <trapname+0x2a>
        return "Hardware Interrupt";
  1018a8:	b8 6a 5f 10 00       	mov    $0x105f6a,%eax
  1018ad:	eb 05                	jmp    1018b4 <trapname+0x2f>
    }
    return "(unknown trap)";
  1018af:	b8 7d 5f 10 00       	mov    $0x105f7d,%eax
}
  1018b4:	5d                   	pop    %ebp
  1018b5:	c3                   	ret    

001018b6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1018b6:	55                   	push   %ebp
  1018b7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1018bc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1018c0:	83 f8 08             	cmp    $0x8,%eax
  1018c3:	0f 94 c0             	sete   %al
  1018c6:	0f b6 c0             	movzbl %al,%eax
}
  1018c9:	5d                   	pop    %ebp
  1018ca:	c3                   	ret    

001018cb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1018cb:	55                   	push   %ebp
  1018cc:	89 e5                	mov    %esp,%ebp
  1018ce:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1018d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018d8:	c7 04 24 be 5f 10 00 	movl   $0x105fbe,(%esp)
  1018df:	e8 72 ea ff ff       	call   100356 <cprintf>
    print_regs(&tf->tf_regs);
  1018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1018e7:	89 04 24             	mov    %eax,(%esp)
  1018ea:	e8 8f 01 00 00       	call   101a7e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f2:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018fa:	c7 04 24 cf 5f 10 00 	movl   $0x105fcf,(%esp)
  101901:	e8 50 ea ff ff       	call   100356 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101906:	8b 45 08             	mov    0x8(%ebp),%eax
  101909:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  10190d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101911:	c7 04 24 e2 5f 10 00 	movl   $0x105fe2,(%esp)
  101918:	e8 39 ea ff ff       	call   100356 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  10191d:	8b 45 08             	mov    0x8(%ebp),%eax
  101920:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101924:	89 44 24 04          	mov    %eax,0x4(%esp)
  101928:	c7 04 24 f5 5f 10 00 	movl   $0x105ff5,(%esp)
  10192f:	e8 22 ea ff ff       	call   100356 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101934:	8b 45 08             	mov    0x8(%ebp),%eax
  101937:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  10193b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10193f:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  101946:	e8 0b ea ff ff       	call   100356 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  10194b:	8b 45 08             	mov    0x8(%ebp),%eax
  10194e:	8b 40 30             	mov    0x30(%eax),%eax
  101951:	89 04 24             	mov    %eax,(%esp)
  101954:	e8 2c ff ff ff       	call   101885 <trapname>
  101959:	8b 55 08             	mov    0x8(%ebp),%edx
  10195c:	8b 52 30             	mov    0x30(%edx),%edx
  10195f:	89 44 24 08          	mov    %eax,0x8(%esp)
  101963:	89 54 24 04          	mov    %edx,0x4(%esp)
  101967:	c7 04 24 1b 60 10 00 	movl   $0x10601b,(%esp)
  10196e:	e8 e3 e9 ff ff       	call   100356 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101973:	8b 45 08             	mov    0x8(%ebp),%eax
  101976:	8b 40 34             	mov    0x34(%eax),%eax
  101979:	89 44 24 04          	mov    %eax,0x4(%esp)
  10197d:	c7 04 24 2d 60 10 00 	movl   $0x10602d,(%esp)
  101984:	e8 cd e9 ff ff       	call   100356 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101989:	8b 45 08             	mov    0x8(%ebp),%eax
  10198c:	8b 40 38             	mov    0x38(%eax),%eax
  10198f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101993:	c7 04 24 3c 60 10 00 	movl   $0x10603c,(%esp)
  10199a:	e8 b7 e9 ff ff       	call   100356 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10199f:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019aa:	c7 04 24 4b 60 10 00 	movl   $0x10604b,(%esp)
  1019b1:	e8 a0 e9 ff ff       	call   100356 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  1019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b9:	8b 40 40             	mov    0x40(%eax),%eax
  1019bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019c0:	c7 04 24 5e 60 10 00 	movl   $0x10605e,(%esp)
  1019c7:	e8 8a e9 ff ff       	call   100356 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1019d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  1019da:	eb 3d                	jmp    101a19 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  1019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019df:	8b 50 40             	mov    0x40(%eax),%edx
  1019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1019e5:	21 d0                	and    %edx,%eax
  1019e7:	85 c0                	test   %eax,%eax
  1019e9:	74 28                	je     101a13 <print_trapframe+0x148>
  1019eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019ee:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  1019f5:	85 c0                	test   %eax,%eax
  1019f7:	74 1a                	je     101a13 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  1019f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019fc:	8b 04 85 80 85 11 00 	mov    0x118580(,%eax,4),%eax
  101a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a07:	c7 04 24 6d 60 10 00 	movl   $0x10606d,(%esp)
  101a0e:	e8 43 e9 ff ff       	call   100356 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101a13:	ff 45 f4             	incl   -0xc(%ebp)
  101a16:	d1 65 f0             	shll   -0x10(%ebp)
  101a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101a1c:	83 f8 17             	cmp    $0x17,%eax
  101a1f:	76 bb                	jbe    1019dc <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101a21:	8b 45 08             	mov    0x8(%ebp),%eax
  101a24:	8b 40 40             	mov    0x40(%eax),%eax
  101a27:	c1 e8 0c             	shr    $0xc,%eax
  101a2a:	83 e0 03             	and    $0x3,%eax
  101a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a31:	c7 04 24 71 60 10 00 	movl   $0x106071,(%esp)
  101a38:	e8 19 e9 ff ff       	call   100356 <cprintf>

    if (!trap_in_kernel(tf)) {
  101a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a40:	89 04 24             	mov    %eax,(%esp)
  101a43:	e8 6e fe ff ff       	call   1018b6 <trap_in_kernel>
  101a48:	85 c0                	test   %eax,%eax
  101a4a:	75 2d                	jne    101a79 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4f:	8b 40 44             	mov    0x44(%eax),%eax
  101a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a56:	c7 04 24 7a 60 10 00 	movl   $0x10607a,(%esp)
  101a5d:	e8 f4 e8 ff ff       	call   100356 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a62:	8b 45 08             	mov    0x8(%ebp),%eax
  101a65:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6d:	c7 04 24 89 60 10 00 	movl   $0x106089,(%esp)
  101a74:	e8 dd e8 ff ff       	call   100356 <cprintf>
    }
}
  101a79:	90                   	nop
  101a7a:	89 ec                	mov    %ebp,%esp
  101a7c:	5d                   	pop    %ebp
  101a7d:	c3                   	ret    

00101a7e <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a7e:	55                   	push   %ebp
  101a7f:	89 e5                	mov    %esp,%ebp
  101a81:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a84:	8b 45 08             	mov    0x8(%ebp),%eax
  101a87:	8b 00                	mov    (%eax),%eax
  101a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8d:	c7 04 24 9c 60 10 00 	movl   $0x10609c,(%esp)
  101a94:	e8 bd e8 ff ff       	call   100356 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	8b 40 04             	mov    0x4(%eax),%eax
  101a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa3:	c7 04 24 ab 60 10 00 	movl   $0x1060ab,(%esp)
  101aaa:	e8 a7 e8 ff ff       	call   100356 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab2:	8b 40 08             	mov    0x8(%eax),%eax
  101ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab9:	c7 04 24 ba 60 10 00 	movl   $0x1060ba,(%esp)
  101ac0:	e8 91 e8 ff ff       	call   100356 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac8:	8b 40 0c             	mov    0xc(%eax),%eax
  101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acf:	c7 04 24 c9 60 10 00 	movl   $0x1060c9,(%esp)
  101ad6:	e8 7b e8 ff ff       	call   100356 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101adb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ade:	8b 40 10             	mov    0x10(%eax),%eax
  101ae1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae5:	c7 04 24 d8 60 10 00 	movl   $0x1060d8,(%esp)
  101aec:	e8 65 e8 ff ff       	call   100356 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101af1:	8b 45 08             	mov    0x8(%ebp),%eax
  101af4:	8b 40 14             	mov    0x14(%eax),%eax
  101af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afb:	c7 04 24 e7 60 10 00 	movl   $0x1060e7,(%esp)
  101b02:	e8 4f e8 ff ff       	call   100356 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101b07:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0a:	8b 40 18             	mov    0x18(%eax),%eax
  101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b11:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
  101b18:	e8 39 e8 ff ff       	call   100356 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b20:	8b 40 1c             	mov    0x1c(%eax),%eax
  101b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b27:	c7 04 24 05 61 10 00 	movl   $0x106105,(%esp)
  101b2e:	e8 23 e8 ff ff       	call   100356 <cprintf>
}
  101b33:	90                   	nop
  101b34:	89 ec                	mov    %ebp,%esp
  101b36:	5d                   	pop    %ebp
  101b37:	c3                   	ret    

00101b38 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101b38:	55                   	push   %ebp
  101b39:	89 e5                	mov    %esp,%ebp
  101b3b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b41:	8b 40 30             	mov    0x30(%eax),%eax
  101b44:	83 f8 79             	cmp    $0x79,%eax
  101b47:	0f 87 99 00 00 00    	ja     101be6 <trap_dispatch+0xae>
  101b4d:	83 f8 78             	cmp    $0x78,%eax
  101b50:	73 78                	jae    101bca <trap_dispatch+0x92>
  101b52:	83 f8 2f             	cmp    $0x2f,%eax
  101b55:	0f 87 8b 00 00 00    	ja     101be6 <trap_dispatch+0xae>
  101b5b:	83 f8 2e             	cmp    $0x2e,%eax
  101b5e:	0f 83 b7 00 00 00    	jae    101c1b <trap_dispatch+0xe3>
  101b64:	83 f8 24             	cmp    $0x24,%eax
  101b67:	74 15                	je     101b7e <trap_dispatch+0x46>
  101b69:	83 f8 24             	cmp    $0x24,%eax
  101b6c:	77 78                	ja     101be6 <trap_dispatch+0xae>
  101b6e:	83 f8 20             	cmp    $0x20,%eax
  101b71:	0f 84 a7 00 00 00    	je     101c1e <trap_dispatch+0xe6>
  101b77:	83 f8 21             	cmp    $0x21,%eax
  101b7a:	74 28                	je     101ba4 <trap_dispatch+0x6c>
  101b7c:	eb 68                	jmp    101be6 <trap_dispatch+0xae>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b7e:	e8 80 fa ff ff       	call   101603 <cons_getc>
  101b83:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b86:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b8a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b96:	c7 04 24 14 61 10 00 	movl   $0x106114,(%esp)
  101b9d:	e8 b4 e7 ff ff       	call   100356 <cprintf>
        break;
  101ba2:	eb 7b                	jmp    101c1f <trap_dispatch+0xe7>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ba4:	e8 5a fa ff ff       	call   101603 <cons_getc>
  101ba9:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101bac:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101bb0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101bb4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 26 61 10 00 	movl   $0x106126,(%esp)
  101bc3:	e8 8e e7 ff ff       	call   100356 <cprintf>
        break;
  101bc8:	eb 55                	jmp    101c1f <trap_dispatch+0xe7>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101bca:	c7 44 24 08 35 61 10 	movl   $0x106135,0x8(%esp)
  101bd1:	00 
  101bd2:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101bd9:	00 
  101bda:	c7 04 24 45 61 10 00 	movl   $0x106145,(%esp)
  101be1:	e8 3d f0 ff ff       	call   100c23 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101be6:	8b 45 08             	mov    0x8(%ebp),%eax
  101be9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bed:	83 e0 03             	and    $0x3,%eax
  101bf0:	85 c0                	test   %eax,%eax
  101bf2:	75 2b                	jne    101c1f <trap_dispatch+0xe7>
            print_trapframe(tf);
  101bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf7:	89 04 24             	mov    %eax,(%esp)
  101bfa:	e8 cc fc ff ff       	call   1018cb <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101bff:	c7 44 24 08 56 61 10 	movl   $0x106156,0x8(%esp)
  101c06:	00 
  101c07:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101c0e:	00 
  101c0f:	c7 04 24 45 61 10 00 	movl   $0x106145,(%esp)
  101c16:	e8 08 f0 ff ff       	call   100c23 <__panic>
        break;
  101c1b:	90                   	nop
  101c1c:	eb 01                	jmp    101c1f <trap_dispatch+0xe7>
        break;
  101c1e:	90                   	nop
        }
    }
}
  101c1f:	90                   	nop
  101c20:	89 ec                	mov    %ebp,%esp
  101c22:	5d                   	pop    %ebp
  101c23:	c3                   	ret    

00101c24 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101c24:	55                   	push   %ebp
  101c25:	89 e5                	mov    %esp,%ebp
  101c27:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2d:	89 04 24             	mov    %eax,(%esp)
  101c30:	e8 03 ff ff ff       	call   101b38 <trap_dispatch>
}
  101c35:	90                   	nop
  101c36:	89 ec                	mov    %ebp,%esp
  101c38:	5d                   	pop    %ebp
  101c39:	c3                   	ret    

00101c3a <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101c3a:	1e                   	push   %ds
    pushl %es
  101c3b:	06                   	push   %es
    pushl %fs
  101c3c:	0f a0                	push   %fs
    pushl %gs
  101c3e:	0f a8                	push   %gs
    pushal
  101c40:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101c41:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101c46:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101c48:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101c4a:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101c4b:	e8 d4 ff ff ff       	call   101c24 <trap>

    # pop the pushed stack pointer
    popl %esp
  101c50:	5c                   	pop    %esp

00101c51 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101c51:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101c52:	0f a9                	pop    %gs
    popl %fs
  101c54:	0f a1                	pop    %fs
    popl %es
  101c56:	07                   	pop    %es
    popl %ds
  101c57:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101c58:	83 c4 08             	add    $0x8,%esp
    iret
  101c5b:	cf                   	iret   

00101c5c <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101c5c:	6a 00                	push   $0x0
  pushl $0
  101c5e:	6a 00                	push   $0x0
  jmp __alltraps
  101c60:	e9 d5 ff ff ff       	jmp    101c3a <__alltraps>

00101c65 <vector1>:
.globl vector1
vector1:
  pushl $0
  101c65:	6a 00                	push   $0x0
  pushl $1
  101c67:	6a 01                	push   $0x1
  jmp __alltraps
  101c69:	e9 cc ff ff ff       	jmp    101c3a <__alltraps>

00101c6e <vector2>:
.globl vector2
vector2:
  pushl $0
  101c6e:	6a 00                	push   $0x0
  pushl $2
  101c70:	6a 02                	push   $0x2
  jmp __alltraps
  101c72:	e9 c3 ff ff ff       	jmp    101c3a <__alltraps>

00101c77 <vector3>:
.globl vector3
vector3:
  pushl $0
  101c77:	6a 00                	push   $0x0
  pushl $3
  101c79:	6a 03                	push   $0x3
  jmp __alltraps
  101c7b:	e9 ba ff ff ff       	jmp    101c3a <__alltraps>

00101c80 <vector4>:
.globl vector4
vector4:
  pushl $0
  101c80:	6a 00                	push   $0x0
  pushl $4
  101c82:	6a 04                	push   $0x4
  jmp __alltraps
  101c84:	e9 b1 ff ff ff       	jmp    101c3a <__alltraps>

00101c89 <vector5>:
.globl vector5
vector5:
  pushl $0
  101c89:	6a 00                	push   $0x0
  pushl $5
  101c8b:	6a 05                	push   $0x5
  jmp __alltraps
  101c8d:	e9 a8 ff ff ff       	jmp    101c3a <__alltraps>

00101c92 <vector6>:
.globl vector6
vector6:
  pushl $0
  101c92:	6a 00                	push   $0x0
  pushl $6
  101c94:	6a 06                	push   $0x6
  jmp __alltraps
  101c96:	e9 9f ff ff ff       	jmp    101c3a <__alltraps>

00101c9b <vector7>:
.globl vector7
vector7:
  pushl $0
  101c9b:	6a 00                	push   $0x0
  pushl $7
  101c9d:	6a 07                	push   $0x7
  jmp __alltraps
  101c9f:	e9 96 ff ff ff       	jmp    101c3a <__alltraps>

00101ca4 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ca4:	6a 08                	push   $0x8
  jmp __alltraps
  101ca6:	e9 8f ff ff ff       	jmp    101c3a <__alltraps>

00101cab <vector9>:
.globl vector9
vector9:
  pushl $0
  101cab:	6a 00                	push   $0x0
  pushl $9
  101cad:	6a 09                	push   $0x9
  jmp __alltraps
  101caf:	e9 86 ff ff ff       	jmp    101c3a <__alltraps>

00101cb4 <vector10>:
.globl vector10
vector10:
  pushl $10
  101cb4:	6a 0a                	push   $0xa
  jmp __alltraps
  101cb6:	e9 7f ff ff ff       	jmp    101c3a <__alltraps>

00101cbb <vector11>:
.globl vector11
vector11:
  pushl $11
  101cbb:	6a 0b                	push   $0xb
  jmp __alltraps
  101cbd:	e9 78 ff ff ff       	jmp    101c3a <__alltraps>

00101cc2 <vector12>:
.globl vector12
vector12:
  pushl $12
  101cc2:	6a 0c                	push   $0xc
  jmp __alltraps
  101cc4:	e9 71 ff ff ff       	jmp    101c3a <__alltraps>

00101cc9 <vector13>:
.globl vector13
vector13:
  pushl $13
  101cc9:	6a 0d                	push   $0xd
  jmp __alltraps
  101ccb:	e9 6a ff ff ff       	jmp    101c3a <__alltraps>

00101cd0 <vector14>:
.globl vector14
vector14:
  pushl $14
  101cd0:	6a 0e                	push   $0xe
  jmp __alltraps
  101cd2:	e9 63 ff ff ff       	jmp    101c3a <__alltraps>

00101cd7 <vector15>:
.globl vector15
vector15:
  pushl $0
  101cd7:	6a 00                	push   $0x0
  pushl $15
  101cd9:	6a 0f                	push   $0xf
  jmp __alltraps
  101cdb:	e9 5a ff ff ff       	jmp    101c3a <__alltraps>

00101ce0 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ce0:	6a 00                	push   $0x0
  pushl $16
  101ce2:	6a 10                	push   $0x10
  jmp __alltraps
  101ce4:	e9 51 ff ff ff       	jmp    101c3a <__alltraps>

00101ce9 <vector17>:
.globl vector17
vector17:
  pushl $17
  101ce9:	6a 11                	push   $0x11
  jmp __alltraps
  101ceb:	e9 4a ff ff ff       	jmp    101c3a <__alltraps>

00101cf0 <vector18>:
.globl vector18
vector18:
  pushl $0
  101cf0:	6a 00                	push   $0x0
  pushl $18
  101cf2:	6a 12                	push   $0x12
  jmp __alltraps
  101cf4:	e9 41 ff ff ff       	jmp    101c3a <__alltraps>

00101cf9 <vector19>:
.globl vector19
vector19:
  pushl $0
  101cf9:	6a 00                	push   $0x0
  pushl $19
  101cfb:	6a 13                	push   $0x13
  jmp __alltraps
  101cfd:	e9 38 ff ff ff       	jmp    101c3a <__alltraps>

00101d02 <vector20>:
.globl vector20
vector20:
  pushl $0
  101d02:	6a 00                	push   $0x0
  pushl $20
  101d04:	6a 14                	push   $0x14
  jmp __alltraps
  101d06:	e9 2f ff ff ff       	jmp    101c3a <__alltraps>

00101d0b <vector21>:
.globl vector21
vector21:
  pushl $0
  101d0b:	6a 00                	push   $0x0
  pushl $21
  101d0d:	6a 15                	push   $0x15
  jmp __alltraps
  101d0f:	e9 26 ff ff ff       	jmp    101c3a <__alltraps>

00101d14 <vector22>:
.globl vector22
vector22:
  pushl $0
  101d14:	6a 00                	push   $0x0
  pushl $22
  101d16:	6a 16                	push   $0x16
  jmp __alltraps
  101d18:	e9 1d ff ff ff       	jmp    101c3a <__alltraps>

00101d1d <vector23>:
.globl vector23
vector23:
  pushl $0
  101d1d:	6a 00                	push   $0x0
  pushl $23
  101d1f:	6a 17                	push   $0x17
  jmp __alltraps
  101d21:	e9 14 ff ff ff       	jmp    101c3a <__alltraps>

00101d26 <vector24>:
.globl vector24
vector24:
  pushl $0
  101d26:	6a 00                	push   $0x0
  pushl $24
  101d28:	6a 18                	push   $0x18
  jmp __alltraps
  101d2a:	e9 0b ff ff ff       	jmp    101c3a <__alltraps>

00101d2f <vector25>:
.globl vector25
vector25:
  pushl $0
  101d2f:	6a 00                	push   $0x0
  pushl $25
  101d31:	6a 19                	push   $0x19
  jmp __alltraps
  101d33:	e9 02 ff ff ff       	jmp    101c3a <__alltraps>

00101d38 <vector26>:
.globl vector26
vector26:
  pushl $0
  101d38:	6a 00                	push   $0x0
  pushl $26
  101d3a:	6a 1a                	push   $0x1a
  jmp __alltraps
  101d3c:	e9 f9 fe ff ff       	jmp    101c3a <__alltraps>

00101d41 <vector27>:
.globl vector27
vector27:
  pushl $0
  101d41:	6a 00                	push   $0x0
  pushl $27
  101d43:	6a 1b                	push   $0x1b
  jmp __alltraps
  101d45:	e9 f0 fe ff ff       	jmp    101c3a <__alltraps>

00101d4a <vector28>:
.globl vector28
vector28:
  pushl $0
  101d4a:	6a 00                	push   $0x0
  pushl $28
  101d4c:	6a 1c                	push   $0x1c
  jmp __alltraps
  101d4e:	e9 e7 fe ff ff       	jmp    101c3a <__alltraps>

00101d53 <vector29>:
.globl vector29
vector29:
  pushl $0
  101d53:	6a 00                	push   $0x0
  pushl $29
  101d55:	6a 1d                	push   $0x1d
  jmp __alltraps
  101d57:	e9 de fe ff ff       	jmp    101c3a <__alltraps>

00101d5c <vector30>:
.globl vector30
vector30:
  pushl $0
  101d5c:	6a 00                	push   $0x0
  pushl $30
  101d5e:	6a 1e                	push   $0x1e
  jmp __alltraps
  101d60:	e9 d5 fe ff ff       	jmp    101c3a <__alltraps>

00101d65 <vector31>:
.globl vector31
vector31:
  pushl $0
  101d65:	6a 00                	push   $0x0
  pushl $31
  101d67:	6a 1f                	push   $0x1f
  jmp __alltraps
  101d69:	e9 cc fe ff ff       	jmp    101c3a <__alltraps>

00101d6e <vector32>:
.globl vector32
vector32:
  pushl $0
  101d6e:	6a 00                	push   $0x0
  pushl $32
  101d70:	6a 20                	push   $0x20
  jmp __alltraps
  101d72:	e9 c3 fe ff ff       	jmp    101c3a <__alltraps>

00101d77 <vector33>:
.globl vector33
vector33:
  pushl $0
  101d77:	6a 00                	push   $0x0
  pushl $33
  101d79:	6a 21                	push   $0x21
  jmp __alltraps
  101d7b:	e9 ba fe ff ff       	jmp    101c3a <__alltraps>

00101d80 <vector34>:
.globl vector34
vector34:
  pushl $0
  101d80:	6a 00                	push   $0x0
  pushl $34
  101d82:	6a 22                	push   $0x22
  jmp __alltraps
  101d84:	e9 b1 fe ff ff       	jmp    101c3a <__alltraps>

00101d89 <vector35>:
.globl vector35
vector35:
  pushl $0
  101d89:	6a 00                	push   $0x0
  pushl $35
  101d8b:	6a 23                	push   $0x23
  jmp __alltraps
  101d8d:	e9 a8 fe ff ff       	jmp    101c3a <__alltraps>

00101d92 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d92:	6a 00                	push   $0x0
  pushl $36
  101d94:	6a 24                	push   $0x24
  jmp __alltraps
  101d96:	e9 9f fe ff ff       	jmp    101c3a <__alltraps>

00101d9b <vector37>:
.globl vector37
vector37:
  pushl $0
  101d9b:	6a 00                	push   $0x0
  pushl $37
  101d9d:	6a 25                	push   $0x25
  jmp __alltraps
  101d9f:	e9 96 fe ff ff       	jmp    101c3a <__alltraps>

00101da4 <vector38>:
.globl vector38
vector38:
  pushl $0
  101da4:	6a 00                	push   $0x0
  pushl $38
  101da6:	6a 26                	push   $0x26
  jmp __alltraps
  101da8:	e9 8d fe ff ff       	jmp    101c3a <__alltraps>

00101dad <vector39>:
.globl vector39
vector39:
  pushl $0
  101dad:	6a 00                	push   $0x0
  pushl $39
  101daf:	6a 27                	push   $0x27
  jmp __alltraps
  101db1:	e9 84 fe ff ff       	jmp    101c3a <__alltraps>

00101db6 <vector40>:
.globl vector40
vector40:
  pushl $0
  101db6:	6a 00                	push   $0x0
  pushl $40
  101db8:	6a 28                	push   $0x28
  jmp __alltraps
  101dba:	e9 7b fe ff ff       	jmp    101c3a <__alltraps>

00101dbf <vector41>:
.globl vector41
vector41:
  pushl $0
  101dbf:	6a 00                	push   $0x0
  pushl $41
  101dc1:	6a 29                	push   $0x29
  jmp __alltraps
  101dc3:	e9 72 fe ff ff       	jmp    101c3a <__alltraps>

00101dc8 <vector42>:
.globl vector42
vector42:
  pushl $0
  101dc8:	6a 00                	push   $0x0
  pushl $42
  101dca:	6a 2a                	push   $0x2a
  jmp __alltraps
  101dcc:	e9 69 fe ff ff       	jmp    101c3a <__alltraps>

00101dd1 <vector43>:
.globl vector43
vector43:
  pushl $0
  101dd1:	6a 00                	push   $0x0
  pushl $43
  101dd3:	6a 2b                	push   $0x2b
  jmp __alltraps
  101dd5:	e9 60 fe ff ff       	jmp    101c3a <__alltraps>

00101dda <vector44>:
.globl vector44
vector44:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $44
  101ddc:	6a 2c                	push   $0x2c
  jmp __alltraps
  101dde:	e9 57 fe ff ff       	jmp    101c3a <__alltraps>

00101de3 <vector45>:
.globl vector45
vector45:
  pushl $0
  101de3:	6a 00                	push   $0x0
  pushl $45
  101de5:	6a 2d                	push   $0x2d
  jmp __alltraps
  101de7:	e9 4e fe ff ff       	jmp    101c3a <__alltraps>

00101dec <vector46>:
.globl vector46
vector46:
  pushl $0
  101dec:	6a 00                	push   $0x0
  pushl $46
  101dee:	6a 2e                	push   $0x2e
  jmp __alltraps
  101df0:	e9 45 fe ff ff       	jmp    101c3a <__alltraps>

00101df5 <vector47>:
.globl vector47
vector47:
  pushl $0
  101df5:	6a 00                	push   $0x0
  pushl $47
  101df7:	6a 2f                	push   $0x2f
  jmp __alltraps
  101df9:	e9 3c fe ff ff       	jmp    101c3a <__alltraps>

00101dfe <vector48>:
.globl vector48
vector48:
  pushl $0
  101dfe:	6a 00                	push   $0x0
  pushl $48
  101e00:	6a 30                	push   $0x30
  jmp __alltraps
  101e02:	e9 33 fe ff ff       	jmp    101c3a <__alltraps>

00101e07 <vector49>:
.globl vector49
vector49:
  pushl $0
  101e07:	6a 00                	push   $0x0
  pushl $49
  101e09:	6a 31                	push   $0x31
  jmp __alltraps
  101e0b:	e9 2a fe ff ff       	jmp    101c3a <__alltraps>

00101e10 <vector50>:
.globl vector50
vector50:
  pushl $0
  101e10:	6a 00                	push   $0x0
  pushl $50
  101e12:	6a 32                	push   $0x32
  jmp __alltraps
  101e14:	e9 21 fe ff ff       	jmp    101c3a <__alltraps>

00101e19 <vector51>:
.globl vector51
vector51:
  pushl $0
  101e19:	6a 00                	push   $0x0
  pushl $51
  101e1b:	6a 33                	push   $0x33
  jmp __alltraps
  101e1d:	e9 18 fe ff ff       	jmp    101c3a <__alltraps>

00101e22 <vector52>:
.globl vector52
vector52:
  pushl $0
  101e22:	6a 00                	push   $0x0
  pushl $52
  101e24:	6a 34                	push   $0x34
  jmp __alltraps
  101e26:	e9 0f fe ff ff       	jmp    101c3a <__alltraps>

00101e2b <vector53>:
.globl vector53
vector53:
  pushl $0
  101e2b:	6a 00                	push   $0x0
  pushl $53
  101e2d:	6a 35                	push   $0x35
  jmp __alltraps
  101e2f:	e9 06 fe ff ff       	jmp    101c3a <__alltraps>

00101e34 <vector54>:
.globl vector54
vector54:
  pushl $0
  101e34:	6a 00                	push   $0x0
  pushl $54
  101e36:	6a 36                	push   $0x36
  jmp __alltraps
  101e38:	e9 fd fd ff ff       	jmp    101c3a <__alltraps>

00101e3d <vector55>:
.globl vector55
vector55:
  pushl $0
  101e3d:	6a 00                	push   $0x0
  pushl $55
  101e3f:	6a 37                	push   $0x37
  jmp __alltraps
  101e41:	e9 f4 fd ff ff       	jmp    101c3a <__alltraps>

00101e46 <vector56>:
.globl vector56
vector56:
  pushl $0
  101e46:	6a 00                	push   $0x0
  pushl $56
  101e48:	6a 38                	push   $0x38
  jmp __alltraps
  101e4a:	e9 eb fd ff ff       	jmp    101c3a <__alltraps>

00101e4f <vector57>:
.globl vector57
vector57:
  pushl $0
  101e4f:	6a 00                	push   $0x0
  pushl $57
  101e51:	6a 39                	push   $0x39
  jmp __alltraps
  101e53:	e9 e2 fd ff ff       	jmp    101c3a <__alltraps>

00101e58 <vector58>:
.globl vector58
vector58:
  pushl $0
  101e58:	6a 00                	push   $0x0
  pushl $58
  101e5a:	6a 3a                	push   $0x3a
  jmp __alltraps
  101e5c:	e9 d9 fd ff ff       	jmp    101c3a <__alltraps>

00101e61 <vector59>:
.globl vector59
vector59:
  pushl $0
  101e61:	6a 00                	push   $0x0
  pushl $59
  101e63:	6a 3b                	push   $0x3b
  jmp __alltraps
  101e65:	e9 d0 fd ff ff       	jmp    101c3a <__alltraps>

00101e6a <vector60>:
.globl vector60
vector60:
  pushl $0
  101e6a:	6a 00                	push   $0x0
  pushl $60
  101e6c:	6a 3c                	push   $0x3c
  jmp __alltraps
  101e6e:	e9 c7 fd ff ff       	jmp    101c3a <__alltraps>

00101e73 <vector61>:
.globl vector61
vector61:
  pushl $0
  101e73:	6a 00                	push   $0x0
  pushl $61
  101e75:	6a 3d                	push   $0x3d
  jmp __alltraps
  101e77:	e9 be fd ff ff       	jmp    101c3a <__alltraps>

00101e7c <vector62>:
.globl vector62
vector62:
  pushl $0
  101e7c:	6a 00                	push   $0x0
  pushl $62
  101e7e:	6a 3e                	push   $0x3e
  jmp __alltraps
  101e80:	e9 b5 fd ff ff       	jmp    101c3a <__alltraps>

00101e85 <vector63>:
.globl vector63
vector63:
  pushl $0
  101e85:	6a 00                	push   $0x0
  pushl $63
  101e87:	6a 3f                	push   $0x3f
  jmp __alltraps
  101e89:	e9 ac fd ff ff       	jmp    101c3a <__alltraps>

00101e8e <vector64>:
.globl vector64
vector64:
  pushl $0
  101e8e:	6a 00                	push   $0x0
  pushl $64
  101e90:	6a 40                	push   $0x40
  jmp __alltraps
  101e92:	e9 a3 fd ff ff       	jmp    101c3a <__alltraps>

00101e97 <vector65>:
.globl vector65
vector65:
  pushl $0
  101e97:	6a 00                	push   $0x0
  pushl $65
  101e99:	6a 41                	push   $0x41
  jmp __alltraps
  101e9b:	e9 9a fd ff ff       	jmp    101c3a <__alltraps>

00101ea0 <vector66>:
.globl vector66
vector66:
  pushl $0
  101ea0:	6a 00                	push   $0x0
  pushl $66
  101ea2:	6a 42                	push   $0x42
  jmp __alltraps
  101ea4:	e9 91 fd ff ff       	jmp    101c3a <__alltraps>

00101ea9 <vector67>:
.globl vector67
vector67:
  pushl $0
  101ea9:	6a 00                	push   $0x0
  pushl $67
  101eab:	6a 43                	push   $0x43
  jmp __alltraps
  101ead:	e9 88 fd ff ff       	jmp    101c3a <__alltraps>

00101eb2 <vector68>:
.globl vector68
vector68:
  pushl $0
  101eb2:	6a 00                	push   $0x0
  pushl $68
  101eb4:	6a 44                	push   $0x44
  jmp __alltraps
  101eb6:	e9 7f fd ff ff       	jmp    101c3a <__alltraps>

00101ebb <vector69>:
.globl vector69
vector69:
  pushl $0
  101ebb:	6a 00                	push   $0x0
  pushl $69
  101ebd:	6a 45                	push   $0x45
  jmp __alltraps
  101ebf:	e9 76 fd ff ff       	jmp    101c3a <__alltraps>

00101ec4 <vector70>:
.globl vector70
vector70:
  pushl $0
  101ec4:	6a 00                	push   $0x0
  pushl $70
  101ec6:	6a 46                	push   $0x46
  jmp __alltraps
  101ec8:	e9 6d fd ff ff       	jmp    101c3a <__alltraps>

00101ecd <vector71>:
.globl vector71
vector71:
  pushl $0
  101ecd:	6a 00                	push   $0x0
  pushl $71
  101ecf:	6a 47                	push   $0x47
  jmp __alltraps
  101ed1:	e9 64 fd ff ff       	jmp    101c3a <__alltraps>

00101ed6 <vector72>:
.globl vector72
vector72:
  pushl $0
  101ed6:	6a 00                	push   $0x0
  pushl $72
  101ed8:	6a 48                	push   $0x48
  jmp __alltraps
  101eda:	e9 5b fd ff ff       	jmp    101c3a <__alltraps>

00101edf <vector73>:
.globl vector73
vector73:
  pushl $0
  101edf:	6a 00                	push   $0x0
  pushl $73
  101ee1:	6a 49                	push   $0x49
  jmp __alltraps
  101ee3:	e9 52 fd ff ff       	jmp    101c3a <__alltraps>

00101ee8 <vector74>:
.globl vector74
vector74:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $74
  101eea:	6a 4a                	push   $0x4a
  jmp __alltraps
  101eec:	e9 49 fd ff ff       	jmp    101c3a <__alltraps>

00101ef1 <vector75>:
.globl vector75
vector75:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $75
  101ef3:	6a 4b                	push   $0x4b
  jmp __alltraps
  101ef5:	e9 40 fd ff ff       	jmp    101c3a <__alltraps>

00101efa <vector76>:
.globl vector76
vector76:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $76
  101efc:	6a 4c                	push   $0x4c
  jmp __alltraps
  101efe:	e9 37 fd ff ff       	jmp    101c3a <__alltraps>

00101f03 <vector77>:
.globl vector77
vector77:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $77
  101f05:	6a 4d                	push   $0x4d
  jmp __alltraps
  101f07:	e9 2e fd ff ff       	jmp    101c3a <__alltraps>

00101f0c <vector78>:
.globl vector78
vector78:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $78
  101f0e:	6a 4e                	push   $0x4e
  jmp __alltraps
  101f10:	e9 25 fd ff ff       	jmp    101c3a <__alltraps>

00101f15 <vector79>:
.globl vector79
vector79:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $79
  101f17:	6a 4f                	push   $0x4f
  jmp __alltraps
  101f19:	e9 1c fd ff ff       	jmp    101c3a <__alltraps>

00101f1e <vector80>:
.globl vector80
vector80:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $80
  101f20:	6a 50                	push   $0x50
  jmp __alltraps
  101f22:	e9 13 fd ff ff       	jmp    101c3a <__alltraps>

00101f27 <vector81>:
.globl vector81
vector81:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $81
  101f29:	6a 51                	push   $0x51
  jmp __alltraps
  101f2b:	e9 0a fd ff ff       	jmp    101c3a <__alltraps>

00101f30 <vector82>:
.globl vector82
vector82:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $82
  101f32:	6a 52                	push   $0x52
  jmp __alltraps
  101f34:	e9 01 fd ff ff       	jmp    101c3a <__alltraps>

00101f39 <vector83>:
.globl vector83
vector83:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $83
  101f3b:	6a 53                	push   $0x53
  jmp __alltraps
  101f3d:	e9 f8 fc ff ff       	jmp    101c3a <__alltraps>

00101f42 <vector84>:
.globl vector84
vector84:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $84
  101f44:	6a 54                	push   $0x54
  jmp __alltraps
  101f46:	e9 ef fc ff ff       	jmp    101c3a <__alltraps>

00101f4b <vector85>:
.globl vector85
vector85:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $85
  101f4d:	6a 55                	push   $0x55
  jmp __alltraps
  101f4f:	e9 e6 fc ff ff       	jmp    101c3a <__alltraps>

00101f54 <vector86>:
.globl vector86
vector86:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $86
  101f56:	6a 56                	push   $0x56
  jmp __alltraps
  101f58:	e9 dd fc ff ff       	jmp    101c3a <__alltraps>

00101f5d <vector87>:
.globl vector87
vector87:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $87
  101f5f:	6a 57                	push   $0x57
  jmp __alltraps
  101f61:	e9 d4 fc ff ff       	jmp    101c3a <__alltraps>

00101f66 <vector88>:
.globl vector88
vector88:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $88
  101f68:	6a 58                	push   $0x58
  jmp __alltraps
  101f6a:	e9 cb fc ff ff       	jmp    101c3a <__alltraps>

00101f6f <vector89>:
.globl vector89
vector89:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $89
  101f71:	6a 59                	push   $0x59
  jmp __alltraps
  101f73:	e9 c2 fc ff ff       	jmp    101c3a <__alltraps>

00101f78 <vector90>:
.globl vector90
vector90:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $90
  101f7a:	6a 5a                	push   $0x5a
  jmp __alltraps
  101f7c:	e9 b9 fc ff ff       	jmp    101c3a <__alltraps>

00101f81 <vector91>:
.globl vector91
vector91:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $91
  101f83:	6a 5b                	push   $0x5b
  jmp __alltraps
  101f85:	e9 b0 fc ff ff       	jmp    101c3a <__alltraps>

00101f8a <vector92>:
.globl vector92
vector92:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $92
  101f8c:	6a 5c                	push   $0x5c
  jmp __alltraps
  101f8e:	e9 a7 fc ff ff       	jmp    101c3a <__alltraps>

00101f93 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $93
  101f95:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f97:	e9 9e fc ff ff       	jmp    101c3a <__alltraps>

00101f9c <vector94>:
.globl vector94
vector94:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $94
  101f9e:	6a 5e                	push   $0x5e
  jmp __alltraps
  101fa0:	e9 95 fc ff ff       	jmp    101c3a <__alltraps>

00101fa5 <vector95>:
.globl vector95
vector95:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $95
  101fa7:	6a 5f                	push   $0x5f
  jmp __alltraps
  101fa9:	e9 8c fc ff ff       	jmp    101c3a <__alltraps>

00101fae <vector96>:
.globl vector96
vector96:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $96
  101fb0:	6a 60                	push   $0x60
  jmp __alltraps
  101fb2:	e9 83 fc ff ff       	jmp    101c3a <__alltraps>

00101fb7 <vector97>:
.globl vector97
vector97:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $97
  101fb9:	6a 61                	push   $0x61
  jmp __alltraps
  101fbb:	e9 7a fc ff ff       	jmp    101c3a <__alltraps>

00101fc0 <vector98>:
.globl vector98
vector98:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $98
  101fc2:	6a 62                	push   $0x62
  jmp __alltraps
  101fc4:	e9 71 fc ff ff       	jmp    101c3a <__alltraps>

00101fc9 <vector99>:
.globl vector99
vector99:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $99
  101fcb:	6a 63                	push   $0x63
  jmp __alltraps
  101fcd:	e9 68 fc ff ff       	jmp    101c3a <__alltraps>

00101fd2 <vector100>:
.globl vector100
vector100:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $100
  101fd4:	6a 64                	push   $0x64
  jmp __alltraps
  101fd6:	e9 5f fc ff ff       	jmp    101c3a <__alltraps>

00101fdb <vector101>:
.globl vector101
vector101:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $101
  101fdd:	6a 65                	push   $0x65
  jmp __alltraps
  101fdf:	e9 56 fc ff ff       	jmp    101c3a <__alltraps>

00101fe4 <vector102>:
.globl vector102
vector102:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $102
  101fe6:	6a 66                	push   $0x66
  jmp __alltraps
  101fe8:	e9 4d fc ff ff       	jmp    101c3a <__alltraps>

00101fed <vector103>:
.globl vector103
vector103:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $103
  101fef:	6a 67                	push   $0x67
  jmp __alltraps
  101ff1:	e9 44 fc ff ff       	jmp    101c3a <__alltraps>

00101ff6 <vector104>:
.globl vector104
vector104:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $104
  101ff8:	6a 68                	push   $0x68
  jmp __alltraps
  101ffa:	e9 3b fc ff ff       	jmp    101c3a <__alltraps>

00101fff <vector105>:
.globl vector105
vector105:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $105
  102001:	6a 69                	push   $0x69
  jmp __alltraps
  102003:	e9 32 fc ff ff       	jmp    101c3a <__alltraps>

00102008 <vector106>:
.globl vector106
vector106:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $106
  10200a:	6a 6a                	push   $0x6a
  jmp __alltraps
  10200c:	e9 29 fc ff ff       	jmp    101c3a <__alltraps>

00102011 <vector107>:
.globl vector107
vector107:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $107
  102013:	6a 6b                	push   $0x6b
  jmp __alltraps
  102015:	e9 20 fc ff ff       	jmp    101c3a <__alltraps>

0010201a <vector108>:
.globl vector108
vector108:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $108
  10201c:	6a 6c                	push   $0x6c
  jmp __alltraps
  10201e:	e9 17 fc ff ff       	jmp    101c3a <__alltraps>

00102023 <vector109>:
.globl vector109
vector109:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $109
  102025:	6a 6d                	push   $0x6d
  jmp __alltraps
  102027:	e9 0e fc ff ff       	jmp    101c3a <__alltraps>

0010202c <vector110>:
.globl vector110
vector110:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $110
  10202e:	6a 6e                	push   $0x6e
  jmp __alltraps
  102030:	e9 05 fc ff ff       	jmp    101c3a <__alltraps>

00102035 <vector111>:
.globl vector111
vector111:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $111
  102037:	6a 6f                	push   $0x6f
  jmp __alltraps
  102039:	e9 fc fb ff ff       	jmp    101c3a <__alltraps>

0010203e <vector112>:
.globl vector112
vector112:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $112
  102040:	6a 70                	push   $0x70
  jmp __alltraps
  102042:	e9 f3 fb ff ff       	jmp    101c3a <__alltraps>

00102047 <vector113>:
.globl vector113
vector113:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $113
  102049:	6a 71                	push   $0x71
  jmp __alltraps
  10204b:	e9 ea fb ff ff       	jmp    101c3a <__alltraps>

00102050 <vector114>:
.globl vector114
vector114:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $114
  102052:	6a 72                	push   $0x72
  jmp __alltraps
  102054:	e9 e1 fb ff ff       	jmp    101c3a <__alltraps>

00102059 <vector115>:
.globl vector115
vector115:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $115
  10205b:	6a 73                	push   $0x73
  jmp __alltraps
  10205d:	e9 d8 fb ff ff       	jmp    101c3a <__alltraps>

00102062 <vector116>:
.globl vector116
vector116:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $116
  102064:	6a 74                	push   $0x74
  jmp __alltraps
  102066:	e9 cf fb ff ff       	jmp    101c3a <__alltraps>

0010206b <vector117>:
.globl vector117
vector117:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $117
  10206d:	6a 75                	push   $0x75
  jmp __alltraps
  10206f:	e9 c6 fb ff ff       	jmp    101c3a <__alltraps>

00102074 <vector118>:
.globl vector118
vector118:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $118
  102076:	6a 76                	push   $0x76
  jmp __alltraps
  102078:	e9 bd fb ff ff       	jmp    101c3a <__alltraps>

0010207d <vector119>:
.globl vector119
vector119:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $119
  10207f:	6a 77                	push   $0x77
  jmp __alltraps
  102081:	e9 b4 fb ff ff       	jmp    101c3a <__alltraps>

00102086 <vector120>:
.globl vector120
vector120:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $120
  102088:	6a 78                	push   $0x78
  jmp __alltraps
  10208a:	e9 ab fb ff ff       	jmp    101c3a <__alltraps>

0010208f <vector121>:
.globl vector121
vector121:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $121
  102091:	6a 79                	push   $0x79
  jmp __alltraps
  102093:	e9 a2 fb ff ff       	jmp    101c3a <__alltraps>

00102098 <vector122>:
.globl vector122
vector122:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $122
  10209a:	6a 7a                	push   $0x7a
  jmp __alltraps
  10209c:	e9 99 fb ff ff       	jmp    101c3a <__alltraps>

001020a1 <vector123>:
.globl vector123
vector123:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $123
  1020a3:	6a 7b                	push   $0x7b
  jmp __alltraps
  1020a5:	e9 90 fb ff ff       	jmp    101c3a <__alltraps>

001020aa <vector124>:
.globl vector124
vector124:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $124
  1020ac:	6a 7c                	push   $0x7c
  jmp __alltraps
  1020ae:	e9 87 fb ff ff       	jmp    101c3a <__alltraps>

001020b3 <vector125>:
.globl vector125
vector125:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $125
  1020b5:	6a 7d                	push   $0x7d
  jmp __alltraps
  1020b7:	e9 7e fb ff ff       	jmp    101c3a <__alltraps>

001020bc <vector126>:
.globl vector126
vector126:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $126
  1020be:	6a 7e                	push   $0x7e
  jmp __alltraps
  1020c0:	e9 75 fb ff ff       	jmp    101c3a <__alltraps>

001020c5 <vector127>:
.globl vector127
vector127:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $127
  1020c7:	6a 7f                	push   $0x7f
  jmp __alltraps
  1020c9:	e9 6c fb ff ff       	jmp    101c3a <__alltraps>

001020ce <vector128>:
.globl vector128
vector128:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $128
  1020d0:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1020d5:	e9 60 fb ff ff       	jmp    101c3a <__alltraps>

001020da <vector129>:
.globl vector129
vector129:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $129
  1020dc:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1020e1:	e9 54 fb ff ff       	jmp    101c3a <__alltraps>

001020e6 <vector130>:
.globl vector130
vector130:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $130
  1020e8:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1020ed:	e9 48 fb ff ff       	jmp    101c3a <__alltraps>

001020f2 <vector131>:
.globl vector131
vector131:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $131
  1020f4:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1020f9:	e9 3c fb ff ff       	jmp    101c3a <__alltraps>

001020fe <vector132>:
.globl vector132
vector132:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $132
  102100:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102105:	e9 30 fb ff ff       	jmp    101c3a <__alltraps>

0010210a <vector133>:
.globl vector133
vector133:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $133
  10210c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102111:	e9 24 fb ff ff       	jmp    101c3a <__alltraps>

00102116 <vector134>:
.globl vector134
vector134:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $134
  102118:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10211d:	e9 18 fb ff ff       	jmp    101c3a <__alltraps>

00102122 <vector135>:
.globl vector135
vector135:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $135
  102124:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102129:	e9 0c fb ff ff       	jmp    101c3a <__alltraps>

0010212e <vector136>:
.globl vector136
vector136:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $136
  102130:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102135:	e9 00 fb ff ff       	jmp    101c3a <__alltraps>

0010213a <vector137>:
.globl vector137
vector137:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $137
  10213c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102141:	e9 f4 fa ff ff       	jmp    101c3a <__alltraps>

00102146 <vector138>:
.globl vector138
vector138:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $138
  102148:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10214d:	e9 e8 fa ff ff       	jmp    101c3a <__alltraps>

00102152 <vector139>:
.globl vector139
vector139:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $139
  102154:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102159:	e9 dc fa ff ff       	jmp    101c3a <__alltraps>

0010215e <vector140>:
.globl vector140
vector140:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $140
  102160:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102165:	e9 d0 fa ff ff       	jmp    101c3a <__alltraps>

0010216a <vector141>:
.globl vector141
vector141:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $141
  10216c:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102171:	e9 c4 fa ff ff       	jmp    101c3a <__alltraps>

00102176 <vector142>:
.globl vector142
vector142:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $142
  102178:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10217d:	e9 b8 fa ff ff       	jmp    101c3a <__alltraps>

00102182 <vector143>:
.globl vector143
vector143:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $143
  102184:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102189:	e9 ac fa ff ff       	jmp    101c3a <__alltraps>

0010218e <vector144>:
.globl vector144
vector144:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $144
  102190:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102195:	e9 a0 fa ff ff       	jmp    101c3a <__alltraps>

0010219a <vector145>:
.globl vector145
vector145:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $145
  10219c:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1021a1:	e9 94 fa ff ff       	jmp    101c3a <__alltraps>

001021a6 <vector146>:
.globl vector146
vector146:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $146
  1021a8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1021ad:	e9 88 fa ff ff       	jmp    101c3a <__alltraps>

001021b2 <vector147>:
.globl vector147
vector147:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $147
  1021b4:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1021b9:	e9 7c fa ff ff       	jmp    101c3a <__alltraps>

001021be <vector148>:
.globl vector148
vector148:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $148
  1021c0:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1021c5:	e9 70 fa ff ff       	jmp    101c3a <__alltraps>

001021ca <vector149>:
.globl vector149
vector149:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $149
  1021cc:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1021d1:	e9 64 fa ff ff       	jmp    101c3a <__alltraps>

001021d6 <vector150>:
.globl vector150
vector150:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $150
  1021d8:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1021dd:	e9 58 fa ff ff       	jmp    101c3a <__alltraps>

001021e2 <vector151>:
.globl vector151
vector151:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $151
  1021e4:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1021e9:	e9 4c fa ff ff       	jmp    101c3a <__alltraps>

001021ee <vector152>:
.globl vector152
vector152:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $152
  1021f0:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1021f5:	e9 40 fa ff ff       	jmp    101c3a <__alltraps>

001021fa <vector153>:
.globl vector153
vector153:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $153
  1021fc:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102201:	e9 34 fa ff ff       	jmp    101c3a <__alltraps>

00102206 <vector154>:
.globl vector154
vector154:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $154
  102208:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10220d:	e9 28 fa ff ff       	jmp    101c3a <__alltraps>

00102212 <vector155>:
.globl vector155
vector155:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $155
  102214:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102219:	e9 1c fa ff ff       	jmp    101c3a <__alltraps>

0010221e <vector156>:
.globl vector156
vector156:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $156
  102220:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102225:	e9 10 fa ff ff       	jmp    101c3a <__alltraps>

0010222a <vector157>:
.globl vector157
vector157:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $157
  10222c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102231:	e9 04 fa ff ff       	jmp    101c3a <__alltraps>

00102236 <vector158>:
.globl vector158
vector158:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $158
  102238:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10223d:	e9 f8 f9 ff ff       	jmp    101c3a <__alltraps>

00102242 <vector159>:
.globl vector159
vector159:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $159
  102244:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102249:	e9 ec f9 ff ff       	jmp    101c3a <__alltraps>

0010224e <vector160>:
.globl vector160
vector160:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $160
  102250:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102255:	e9 e0 f9 ff ff       	jmp    101c3a <__alltraps>

0010225a <vector161>:
.globl vector161
vector161:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $161
  10225c:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102261:	e9 d4 f9 ff ff       	jmp    101c3a <__alltraps>

00102266 <vector162>:
.globl vector162
vector162:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $162
  102268:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10226d:	e9 c8 f9 ff ff       	jmp    101c3a <__alltraps>

00102272 <vector163>:
.globl vector163
vector163:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $163
  102274:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102279:	e9 bc f9 ff ff       	jmp    101c3a <__alltraps>

0010227e <vector164>:
.globl vector164
vector164:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $164
  102280:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102285:	e9 b0 f9 ff ff       	jmp    101c3a <__alltraps>

0010228a <vector165>:
.globl vector165
vector165:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $165
  10228c:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102291:	e9 a4 f9 ff ff       	jmp    101c3a <__alltraps>

00102296 <vector166>:
.globl vector166
vector166:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $166
  102298:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10229d:	e9 98 f9 ff ff       	jmp    101c3a <__alltraps>

001022a2 <vector167>:
.globl vector167
vector167:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $167
  1022a4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1022a9:	e9 8c f9 ff ff       	jmp    101c3a <__alltraps>

001022ae <vector168>:
.globl vector168
vector168:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $168
  1022b0:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1022b5:	e9 80 f9 ff ff       	jmp    101c3a <__alltraps>

001022ba <vector169>:
.globl vector169
vector169:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $169
  1022bc:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1022c1:	e9 74 f9 ff ff       	jmp    101c3a <__alltraps>

001022c6 <vector170>:
.globl vector170
vector170:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $170
  1022c8:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1022cd:	e9 68 f9 ff ff       	jmp    101c3a <__alltraps>

001022d2 <vector171>:
.globl vector171
vector171:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $171
  1022d4:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1022d9:	e9 5c f9 ff ff       	jmp    101c3a <__alltraps>

001022de <vector172>:
.globl vector172
vector172:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $172
  1022e0:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1022e5:	e9 50 f9 ff ff       	jmp    101c3a <__alltraps>

001022ea <vector173>:
.globl vector173
vector173:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $173
  1022ec:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1022f1:	e9 44 f9 ff ff       	jmp    101c3a <__alltraps>

001022f6 <vector174>:
.globl vector174
vector174:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $174
  1022f8:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1022fd:	e9 38 f9 ff ff       	jmp    101c3a <__alltraps>

00102302 <vector175>:
.globl vector175
vector175:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $175
  102304:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102309:	e9 2c f9 ff ff       	jmp    101c3a <__alltraps>

0010230e <vector176>:
.globl vector176
vector176:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $176
  102310:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102315:	e9 20 f9 ff ff       	jmp    101c3a <__alltraps>

0010231a <vector177>:
.globl vector177
vector177:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $177
  10231c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102321:	e9 14 f9 ff ff       	jmp    101c3a <__alltraps>

00102326 <vector178>:
.globl vector178
vector178:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $178
  102328:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10232d:	e9 08 f9 ff ff       	jmp    101c3a <__alltraps>

00102332 <vector179>:
.globl vector179
vector179:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $179
  102334:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102339:	e9 fc f8 ff ff       	jmp    101c3a <__alltraps>

0010233e <vector180>:
.globl vector180
vector180:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $180
  102340:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102345:	e9 f0 f8 ff ff       	jmp    101c3a <__alltraps>

0010234a <vector181>:
.globl vector181
vector181:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $181
  10234c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102351:	e9 e4 f8 ff ff       	jmp    101c3a <__alltraps>

00102356 <vector182>:
.globl vector182
vector182:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $182
  102358:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10235d:	e9 d8 f8 ff ff       	jmp    101c3a <__alltraps>

00102362 <vector183>:
.globl vector183
vector183:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $183
  102364:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102369:	e9 cc f8 ff ff       	jmp    101c3a <__alltraps>

0010236e <vector184>:
.globl vector184
vector184:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $184
  102370:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102375:	e9 c0 f8 ff ff       	jmp    101c3a <__alltraps>

0010237a <vector185>:
.globl vector185
vector185:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $185
  10237c:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102381:	e9 b4 f8 ff ff       	jmp    101c3a <__alltraps>

00102386 <vector186>:
.globl vector186
vector186:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $186
  102388:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10238d:	e9 a8 f8 ff ff       	jmp    101c3a <__alltraps>

00102392 <vector187>:
.globl vector187
vector187:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $187
  102394:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102399:	e9 9c f8 ff ff       	jmp    101c3a <__alltraps>

0010239e <vector188>:
.globl vector188
vector188:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $188
  1023a0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1023a5:	e9 90 f8 ff ff       	jmp    101c3a <__alltraps>

001023aa <vector189>:
.globl vector189
vector189:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $189
  1023ac:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1023b1:	e9 84 f8 ff ff       	jmp    101c3a <__alltraps>

001023b6 <vector190>:
.globl vector190
vector190:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $190
  1023b8:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1023bd:	e9 78 f8 ff ff       	jmp    101c3a <__alltraps>

001023c2 <vector191>:
.globl vector191
vector191:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $191
  1023c4:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1023c9:	e9 6c f8 ff ff       	jmp    101c3a <__alltraps>

001023ce <vector192>:
.globl vector192
vector192:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $192
  1023d0:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1023d5:	e9 60 f8 ff ff       	jmp    101c3a <__alltraps>

001023da <vector193>:
.globl vector193
vector193:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $193
  1023dc:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1023e1:	e9 54 f8 ff ff       	jmp    101c3a <__alltraps>

001023e6 <vector194>:
.globl vector194
vector194:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $194
  1023e8:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1023ed:	e9 48 f8 ff ff       	jmp    101c3a <__alltraps>

001023f2 <vector195>:
.globl vector195
vector195:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $195
  1023f4:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1023f9:	e9 3c f8 ff ff       	jmp    101c3a <__alltraps>

001023fe <vector196>:
.globl vector196
vector196:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $196
  102400:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102405:	e9 30 f8 ff ff       	jmp    101c3a <__alltraps>

0010240a <vector197>:
.globl vector197
vector197:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $197
  10240c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102411:	e9 24 f8 ff ff       	jmp    101c3a <__alltraps>

00102416 <vector198>:
.globl vector198
vector198:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $198
  102418:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10241d:	e9 18 f8 ff ff       	jmp    101c3a <__alltraps>

00102422 <vector199>:
.globl vector199
vector199:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $199
  102424:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102429:	e9 0c f8 ff ff       	jmp    101c3a <__alltraps>

0010242e <vector200>:
.globl vector200
vector200:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $200
  102430:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102435:	e9 00 f8 ff ff       	jmp    101c3a <__alltraps>

0010243a <vector201>:
.globl vector201
vector201:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $201
  10243c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102441:	e9 f4 f7 ff ff       	jmp    101c3a <__alltraps>

00102446 <vector202>:
.globl vector202
vector202:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $202
  102448:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10244d:	e9 e8 f7 ff ff       	jmp    101c3a <__alltraps>

00102452 <vector203>:
.globl vector203
vector203:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $203
  102454:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102459:	e9 dc f7 ff ff       	jmp    101c3a <__alltraps>

0010245e <vector204>:
.globl vector204
vector204:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $204
  102460:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102465:	e9 d0 f7 ff ff       	jmp    101c3a <__alltraps>

0010246a <vector205>:
.globl vector205
vector205:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $205
  10246c:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102471:	e9 c4 f7 ff ff       	jmp    101c3a <__alltraps>

00102476 <vector206>:
.globl vector206
vector206:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $206
  102478:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10247d:	e9 b8 f7 ff ff       	jmp    101c3a <__alltraps>

00102482 <vector207>:
.globl vector207
vector207:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $207
  102484:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102489:	e9 ac f7 ff ff       	jmp    101c3a <__alltraps>

0010248e <vector208>:
.globl vector208
vector208:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $208
  102490:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102495:	e9 a0 f7 ff ff       	jmp    101c3a <__alltraps>

0010249a <vector209>:
.globl vector209
vector209:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $209
  10249c:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1024a1:	e9 94 f7 ff ff       	jmp    101c3a <__alltraps>

001024a6 <vector210>:
.globl vector210
vector210:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $210
  1024a8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1024ad:	e9 88 f7 ff ff       	jmp    101c3a <__alltraps>

001024b2 <vector211>:
.globl vector211
vector211:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $211
  1024b4:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1024b9:	e9 7c f7 ff ff       	jmp    101c3a <__alltraps>

001024be <vector212>:
.globl vector212
vector212:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $212
  1024c0:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1024c5:	e9 70 f7 ff ff       	jmp    101c3a <__alltraps>

001024ca <vector213>:
.globl vector213
vector213:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $213
  1024cc:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1024d1:	e9 64 f7 ff ff       	jmp    101c3a <__alltraps>

001024d6 <vector214>:
.globl vector214
vector214:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $214
  1024d8:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1024dd:	e9 58 f7 ff ff       	jmp    101c3a <__alltraps>

001024e2 <vector215>:
.globl vector215
vector215:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $215
  1024e4:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1024e9:	e9 4c f7 ff ff       	jmp    101c3a <__alltraps>

001024ee <vector216>:
.globl vector216
vector216:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $216
  1024f0:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1024f5:	e9 40 f7 ff ff       	jmp    101c3a <__alltraps>

001024fa <vector217>:
.globl vector217
vector217:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $217
  1024fc:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102501:	e9 34 f7 ff ff       	jmp    101c3a <__alltraps>

00102506 <vector218>:
.globl vector218
vector218:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $218
  102508:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10250d:	e9 28 f7 ff ff       	jmp    101c3a <__alltraps>

00102512 <vector219>:
.globl vector219
vector219:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $219
  102514:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102519:	e9 1c f7 ff ff       	jmp    101c3a <__alltraps>

0010251e <vector220>:
.globl vector220
vector220:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $220
  102520:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102525:	e9 10 f7 ff ff       	jmp    101c3a <__alltraps>

0010252a <vector221>:
.globl vector221
vector221:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $221
  10252c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102531:	e9 04 f7 ff ff       	jmp    101c3a <__alltraps>

00102536 <vector222>:
.globl vector222
vector222:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $222
  102538:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10253d:	e9 f8 f6 ff ff       	jmp    101c3a <__alltraps>

00102542 <vector223>:
.globl vector223
vector223:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $223
  102544:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102549:	e9 ec f6 ff ff       	jmp    101c3a <__alltraps>

0010254e <vector224>:
.globl vector224
vector224:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $224
  102550:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102555:	e9 e0 f6 ff ff       	jmp    101c3a <__alltraps>

0010255a <vector225>:
.globl vector225
vector225:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $225
  10255c:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102561:	e9 d4 f6 ff ff       	jmp    101c3a <__alltraps>

00102566 <vector226>:
.globl vector226
vector226:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $226
  102568:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10256d:	e9 c8 f6 ff ff       	jmp    101c3a <__alltraps>

00102572 <vector227>:
.globl vector227
vector227:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $227
  102574:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102579:	e9 bc f6 ff ff       	jmp    101c3a <__alltraps>

0010257e <vector228>:
.globl vector228
vector228:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $228
  102580:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102585:	e9 b0 f6 ff ff       	jmp    101c3a <__alltraps>

0010258a <vector229>:
.globl vector229
vector229:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $229
  10258c:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102591:	e9 a4 f6 ff ff       	jmp    101c3a <__alltraps>

00102596 <vector230>:
.globl vector230
vector230:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $230
  102598:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10259d:	e9 98 f6 ff ff       	jmp    101c3a <__alltraps>

001025a2 <vector231>:
.globl vector231
vector231:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $231
  1025a4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1025a9:	e9 8c f6 ff ff       	jmp    101c3a <__alltraps>

001025ae <vector232>:
.globl vector232
vector232:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $232
  1025b0:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1025b5:	e9 80 f6 ff ff       	jmp    101c3a <__alltraps>

001025ba <vector233>:
.globl vector233
vector233:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $233
  1025bc:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1025c1:	e9 74 f6 ff ff       	jmp    101c3a <__alltraps>

001025c6 <vector234>:
.globl vector234
vector234:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $234
  1025c8:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1025cd:	e9 68 f6 ff ff       	jmp    101c3a <__alltraps>

001025d2 <vector235>:
.globl vector235
vector235:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $235
  1025d4:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1025d9:	e9 5c f6 ff ff       	jmp    101c3a <__alltraps>

001025de <vector236>:
.globl vector236
vector236:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $236
  1025e0:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1025e5:	e9 50 f6 ff ff       	jmp    101c3a <__alltraps>

001025ea <vector237>:
.globl vector237
vector237:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $237
  1025ec:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1025f1:	e9 44 f6 ff ff       	jmp    101c3a <__alltraps>

001025f6 <vector238>:
.globl vector238
vector238:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $238
  1025f8:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1025fd:	e9 38 f6 ff ff       	jmp    101c3a <__alltraps>

00102602 <vector239>:
.globl vector239
vector239:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $239
  102604:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102609:	e9 2c f6 ff ff       	jmp    101c3a <__alltraps>

0010260e <vector240>:
.globl vector240
vector240:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $240
  102610:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102615:	e9 20 f6 ff ff       	jmp    101c3a <__alltraps>

0010261a <vector241>:
.globl vector241
vector241:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $241
  10261c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102621:	e9 14 f6 ff ff       	jmp    101c3a <__alltraps>

00102626 <vector242>:
.globl vector242
vector242:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $242
  102628:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10262d:	e9 08 f6 ff ff       	jmp    101c3a <__alltraps>

00102632 <vector243>:
.globl vector243
vector243:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $243
  102634:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102639:	e9 fc f5 ff ff       	jmp    101c3a <__alltraps>

0010263e <vector244>:
.globl vector244
vector244:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $244
  102640:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102645:	e9 f0 f5 ff ff       	jmp    101c3a <__alltraps>

0010264a <vector245>:
.globl vector245
vector245:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $245
  10264c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102651:	e9 e4 f5 ff ff       	jmp    101c3a <__alltraps>

00102656 <vector246>:
.globl vector246
vector246:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $246
  102658:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10265d:	e9 d8 f5 ff ff       	jmp    101c3a <__alltraps>

00102662 <vector247>:
.globl vector247
vector247:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $247
  102664:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102669:	e9 cc f5 ff ff       	jmp    101c3a <__alltraps>

0010266e <vector248>:
.globl vector248
vector248:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $248
  102670:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102675:	e9 c0 f5 ff ff       	jmp    101c3a <__alltraps>

0010267a <vector249>:
.globl vector249
vector249:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $249
  10267c:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102681:	e9 b4 f5 ff ff       	jmp    101c3a <__alltraps>

00102686 <vector250>:
.globl vector250
vector250:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $250
  102688:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10268d:	e9 a8 f5 ff ff       	jmp    101c3a <__alltraps>

00102692 <vector251>:
.globl vector251
vector251:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $251
  102694:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102699:	e9 9c f5 ff ff       	jmp    101c3a <__alltraps>

0010269e <vector252>:
.globl vector252
vector252:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $252
  1026a0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1026a5:	e9 90 f5 ff ff       	jmp    101c3a <__alltraps>

001026aa <vector253>:
.globl vector253
vector253:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $253
  1026ac:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1026b1:	e9 84 f5 ff ff       	jmp    101c3a <__alltraps>

001026b6 <vector254>:
.globl vector254
vector254:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $254
  1026b8:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1026bd:	e9 78 f5 ff ff       	jmp    101c3a <__alltraps>

001026c2 <vector255>:
.globl vector255
vector255:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $255
  1026c4:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1026c9:	e9 6c f5 ff ff       	jmp    101c3a <__alltraps>

001026ce <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1026ce:	55                   	push   %ebp
  1026cf:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1026d1:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  1026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1026da:	29 d0                	sub    %edx,%eax
  1026dc:	c1 f8 02             	sar    $0x2,%eax
  1026df:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1026e5:	5d                   	pop    %ebp
  1026e6:	c3                   	ret    

001026e7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1026e7:	55                   	push   %ebp
  1026e8:	89 e5                	mov    %esp,%ebp
  1026ea:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1026ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1026f0:	89 04 24             	mov    %eax,(%esp)
  1026f3:	e8 d6 ff ff ff       	call   1026ce <page2ppn>
  1026f8:	c1 e0 0c             	shl    $0xc,%eax
}
  1026fb:	89 ec                	mov    %ebp,%esp
  1026fd:	5d                   	pop    %ebp
  1026fe:	c3                   	ret    

001026ff <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1026ff:	55                   	push   %ebp
  102700:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102702:	8b 45 08             	mov    0x8(%ebp),%eax
  102705:	8b 00                	mov    (%eax),%eax
}
  102707:	5d                   	pop    %ebp
  102708:	c3                   	ret    

00102709 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102709:	55                   	push   %ebp
  10270a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10270c:	8b 45 08             	mov    0x8(%ebp),%eax
  10270f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102712:	89 10                	mov    %edx,(%eax)
}
  102714:	90                   	nop
  102715:	5d                   	pop    %ebp
  102716:	c3                   	ret    

00102717 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102717:	55                   	push   %ebp
  102718:	89 e5                	mov    %esp,%ebp
  10271a:	83 ec 10             	sub    $0x10,%esp
  10271d:	c7 45 fc 80 be 11 00 	movl   $0x11be80,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102724:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102727:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10272a:	89 50 04             	mov    %edx,0x4(%eax)
  10272d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102730:	8b 50 04             	mov    0x4(%eax),%edx
  102733:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102736:	89 10                	mov    %edx,(%eax)
}
  102738:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  102739:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  102740:	00 00 00 
}
  102743:	90                   	nop
  102744:	89 ec                	mov    %ebp,%esp
  102746:	5d                   	pop    %ebp
  102747:	c3                   	ret    

00102748 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102748:	55                   	push   %ebp
  102749:	89 e5                	mov    %esp,%ebp
  10274b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10274e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102752:	75 24                	jne    102778 <default_init_memmap+0x30>
  102754:	c7 44 24 0c 10 63 10 	movl   $0x106310,0xc(%esp)
  10275b:	00 
  10275c:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102763:	00 
  102764:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  10276b:	00 
  10276c:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102773:	e8 ab e4 ff ff       	call   100c23 <__panic>
    struct Page *p = base;
  102778:	8b 45 08             	mov    0x8(%ebp),%eax
  10277b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10277e:	eb 7d                	jmp    1027fd <default_init_memmap+0xb5>
        assert(PageReserved(p));
  102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102783:	83 c0 04             	add    $0x4,%eax
  102786:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10278d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102793:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102796:	0f a3 10             	bt     %edx,(%eax)
  102799:	19 c0                	sbb    %eax,%eax
  10279b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10279e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1027a2:	0f 95 c0             	setne  %al
  1027a5:	0f b6 c0             	movzbl %al,%eax
  1027a8:	85 c0                	test   %eax,%eax
  1027aa:	75 24                	jne    1027d0 <default_init_memmap+0x88>
  1027ac:	c7 44 24 0c 41 63 10 	movl   $0x106341,0xc(%esp)
  1027b3:	00 
  1027b4:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1027bb:	00 
  1027bc:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  1027c3:	00 
  1027c4:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1027cb:	e8 53 e4 ff ff       	call   100c23 <__panic>
        p->flags = p->property = 0;
  1027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027d3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027dd:	8b 50 08             	mov    0x8(%eax),%edx
  1027e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027e3:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1027e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1027ed:	00 
  1027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027f1:	89 04 24             	mov    %eax,(%esp)
  1027f4:	e8 10 ff ff ff       	call   102709 <set_page_ref>
    for (; p != base + n; p ++) {
  1027f9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1027fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102800:	89 d0                	mov    %edx,%eax
  102802:	c1 e0 02             	shl    $0x2,%eax
  102805:	01 d0                	add    %edx,%eax
  102807:	c1 e0 02             	shl    $0x2,%eax
  10280a:	89 c2                	mov    %eax,%edx
  10280c:	8b 45 08             	mov    0x8(%ebp),%eax
  10280f:	01 d0                	add    %edx,%eax
  102811:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102814:	0f 85 66 ff ff ff    	jne    102780 <default_init_memmap+0x38>
    }
    base->property = n;
  10281a:	8b 45 08             	mov    0x8(%ebp),%eax
  10281d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102820:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102823:	8b 45 08             	mov    0x8(%ebp),%eax
  102826:	83 c0 04             	add    $0x4,%eax
  102829:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102830:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102833:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102836:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102839:	0f ab 10             	bts    %edx,(%eax)
}
  10283c:	90                   	nop
    nr_free += n;
  10283d:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102843:	8b 45 0c             	mov    0xc(%ebp),%eax
  102846:	01 d0                	add    %edx,%eax
  102848:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add(&free_list, &(base->page_link));
  10284d:	8b 45 08             	mov    0x8(%ebp),%eax
  102850:	83 c0 0c             	add    $0xc,%eax
  102853:	c7 45 e4 80 be 11 00 	movl   $0x11be80,-0x1c(%ebp)
  10285a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10285d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102860:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102863:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102866:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102869:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10286c:	8b 40 04             	mov    0x4(%eax),%eax
  10286f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102872:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102875:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102878:	89 55 d0             	mov    %edx,-0x30(%ebp)
  10287b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10287e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102881:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102884:	89 10                	mov    %edx,(%eax)
  102886:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102889:	8b 10                	mov    (%eax),%edx
  10288b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10288e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102894:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102897:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10289a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10289d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1028a0:	89 10                	mov    %edx,(%eax)
}
  1028a2:	90                   	nop
}
  1028a3:	90                   	nop
}
  1028a4:	90                   	nop
}
  1028a5:	90                   	nop
  1028a6:	89 ec                	mov    %ebp,%esp
  1028a8:	5d                   	pop    %ebp
  1028a9:	c3                   	ret    

001028aa <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1028aa:	55                   	push   %ebp
  1028ab:	89 e5                	mov    %esp,%ebp
  1028ad:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1028b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1028b4:	75 24                	jne    1028da <default_alloc_pages+0x30>
  1028b6:	c7 44 24 0c 10 63 10 	movl   $0x106310,0xc(%esp)
  1028bd:	00 
  1028be:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1028c5:	00 
  1028c6:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  1028cd:	00 
  1028ce:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1028d5:	e8 49 e3 ff ff       	call   100c23 <__panic>
    if (n > nr_free) {
  1028da:	a1 88 be 11 00       	mov    0x11be88,%eax
  1028df:	39 45 08             	cmp    %eax,0x8(%ebp)
  1028e2:	76 0a                	jbe    1028ee <default_alloc_pages+0x44>
        return NULL;
  1028e4:	b8 00 00 00 00       	mov    $0x0,%eax
  1028e9:	e9 34 01 00 00       	jmp    102a22 <default_alloc_pages+0x178>
    }
    struct Page *page = NULL;
  1028ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1028f5:	c7 45 f0 80 be 11 00 	movl   $0x11be80,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1028fc:	eb 1c                	jmp    10291a <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  1028fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102901:	83 e8 0c             	sub    $0xc,%eax
  102904:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10290a:	8b 40 08             	mov    0x8(%eax),%eax
  10290d:	39 45 08             	cmp    %eax,0x8(%ebp)
  102910:	77 08                	ja     10291a <default_alloc_pages+0x70>
            page = p;
  102912:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102915:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102918:	eb 18                	jmp    102932 <default_alloc_pages+0x88>
  10291a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10291d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  102920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102923:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  102926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102929:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102930:	75 cc                	jne    1028fe <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  102932:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102936:	0f 84 e3 00 00 00    	je     102a1f <default_alloc_pages+0x175>
        list_del(&(page->page_link));
  10293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10293f:	83 c0 0c             	add    $0xc,%eax
  102942:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  102945:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102948:	8b 40 04             	mov    0x4(%eax),%eax
  10294b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10294e:	8b 12                	mov    (%edx),%edx
  102950:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102953:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102956:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102959:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10295c:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10295f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102962:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102965:	89 10                	mov    %edx,(%eax)
}
  102967:	90                   	nop
}
  102968:	90                   	nop
        if (page->property > n) {
  102969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10296c:	8b 40 08             	mov    0x8(%eax),%eax
  10296f:	39 45 08             	cmp    %eax,0x8(%ebp)
  102972:	0f 83 80 00 00 00    	jae    1029f8 <default_alloc_pages+0x14e>
            struct Page *p = page + n;
  102978:	8b 55 08             	mov    0x8(%ebp),%edx
  10297b:	89 d0                	mov    %edx,%eax
  10297d:	c1 e0 02             	shl    $0x2,%eax
  102980:	01 d0                	add    %edx,%eax
  102982:	c1 e0 02             	shl    $0x2,%eax
  102985:	89 c2                	mov    %eax,%edx
  102987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10298a:	01 d0                	add    %edx,%eax
  10298c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  10298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102992:	8b 40 08             	mov    0x8(%eax),%eax
  102995:	2b 45 08             	sub    0x8(%ebp),%eax
  102998:	89 c2                	mov    %eax,%edx
  10299a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10299d:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  1029a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029a3:	83 c0 0c             	add    $0xc,%eax
  1029a6:	c7 45 d4 80 be 11 00 	movl   $0x11be80,-0x2c(%ebp)
  1029ad:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  1029b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029b9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  1029bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1029bf:	8b 40 04             	mov    0x4(%eax),%eax
  1029c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1029c5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  1029c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029cb:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1029ce:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  1029d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1029d4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1029d7:	89 10                	mov    %edx,(%eax)
  1029d9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1029dc:	8b 10                	mov    (%eax),%edx
  1029de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1029e1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1029e7:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1029ea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1029ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1029f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1029f3:	89 10                	mov    %edx,(%eax)
}
  1029f5:	90                   	nop
}
  1029f6:	90                   	nop
}
  1029f7:	90                   	nop
    }
        nr_free -= n;
  1029f8:	a1 88 be 11 00       	mov    0x11be88,%eax
  1029fd:	2b 45 08             	sub    0x8(%ebp),%eax
  102a00:	a3 88 be 11 00       	mov    %eax,0x11be88
        ClearPageProperty(page);
  102a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a08:	83 c0 04             	add    $0x4,%eax
  102a0b:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102a12:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a15:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102a18:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102a1b:	0f b3 10             	btr    %edx,(%eax)
}
  102a1e:	90                   	nop
    }
    return page;
  102a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102a22:	89 ec                	mov    %ebp,%esp
  102a24:	5d                   	pop    %ebp
  102a25:	c3                   	ret    

00102a26 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102a26:	55                   	push   %ebp
  102a27:	89 e5                	mov    %esp,%ebp
  102a29:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102a2f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a33:	75 24                	jne    102a59 <default_free_pages+0x33>
  102a35:	c7 44 24 0c 10 63 10 	movl   $0x106310,0xc(%esp)
  102a3c:	00 
  102a3d:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102a44:	00 
  102a45:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  102a4c:	00 
  102a4d:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102a54:	e8 ca e1 ff ff       	call   100c23 <__panic>
    struct Page *p = base;
  102a59:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102a5f:	e9 9d 00 00 00       	jmp    102b01 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a67:	83 c0 04             	add    $0x4,%eax
  102a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102a71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102a74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a7a:	0f a3 10             	bt     %edx,(%eax)
  102a7d:	19 c0                	sbb    %eax,%eax
  102a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102a82:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102a86:	0f 95 c0             	setne  %al
  102a89:	0f b6 c0             	movzbl %al,%eax
  102a8c:	85 c0                	test   %eax,%eax
  102a8e:	75 2c                	jne    102abc <default_free_pages+0x96>
  102a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a93:	83 c0 04             	add    $0x4,%eax
  102a96:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102a9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102aa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102aa6:	0f a3 10             	bt     %edx,(%eax)
  102aa9:	19 c0                	sbb    %eax,%eax
  102aab:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102aae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102ab2:	0f 95 c0             	setne  %al
  102ab5:	0f b6 c0             	movzbl %al,%eax
  102ab8:	85 c0                	test   %eax,%eax
  102aba:	74 24                	je     102ae0 <default_free_pages+0xba>
  102abc:	c7 44 24 0c 54 63 10 	movl   $0x106354,0xc(%esp)
  102ac3:	00 
  102ac4:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102acb:	00 
  102acc:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  102ad3:	00 
  102ad4:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102adb:	e8 43 e1 ff ff       	call   100c23 <__panic>
        p->flags = 0;
  102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102aea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102af1:	00 
  102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af5:	89 04 24             	mov    %eax,(%esp)
  102af8:	e8 0c fc ff ff       	call   102709 <set_page_ref>
    for (; p != base + n; p ++) {
  102afd:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b04:	89 d0                	mov    %edx,%eax
  102b06:	c1 e0 02             	shl    $0x2,%eax
  102b09:	01 d0                	add    %edx,%eax
  102b0b:	c1 e0 02             	shl    $0x2,%eax
  102b0e:	89 c2                	mov    %eax,%edx
  102b10:	8b 45 08             	mov    0x8(%ebp),%eax
  102b13:	01 d0                	add    %edx,%eax
  102b15:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102b18:	0f 85 46 ff ff ff    	jne    102a64 <default_free_pages+0x3e>
    }
    base->property = n;
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b24:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102b27:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2a:	83 c0 04             	add    $0x4,%eax
  102b2d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102b34:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b37:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b3a:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b3d:	0f ab 10             	bts    %edx,(%eax)
}
  102b40:	90                   	nop
  102b41:	c7 45 d4 80 be 11 00 	movl   $0x11be80,-0x2c(%ebp)
    return listelm->next;
  102b48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b4b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102b51:	e9 0e 01 00 00       	jmp    102c64 <default_free_pages+0x23e>
        p = le2page(le, page_link);
  102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b59:	83 e8 0c             	sub    $0xc,%eax
  102b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b62:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102b65:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b68:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b71:	8b 50 08             	mov    0x8(%eax),%edx
  102b74:	89 d0                	mov    %edx,%eax
  102b76:	c1 e0 02             	shl    $0x2,%eax
  102b79:	01 d0                	add    %edx,%eax
  102b7b:	c1 e0 02             	shl    $0x2,%eax
  102b7e:	89 c2                	mov    %eax,%edx
  102b80:	8b 45 08             	mov    0x8(%ebp),%eax
  102b83:	01 d0                	add    %edx,%eax
  102b85:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  102b88:	75 5d                	jne    102be7 <default_free_pages+0x1c1>
            base->property += p->property;
  102b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b8d:	8b 50 08             	mov    0x8(%eax),%edx
  102b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b93:	8b 40 08             	mov    0x8(%eax),%eax
  102b96:	01 c2                	add    %eax,%edx
  102b98:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9b:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba1:	83 c0 04             	add    $0x4,%eax
  102ba4:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102bab:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bae:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bb1:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bb4:	0f b3 10             	btr    %edx,(%eax)
}
  102bb7:	90                   	nop
            list_del(&(p->page_link));
  102bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bbb:	83 c0 0c             	add    $0xc,%eax
  102bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  102bc1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bc4:	8b 40 04             	mov    0x4(%eax),%eax
  102bc7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102bca:	8b 12                	mov    (%edx),%edx
  102bcc:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102bcf:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  102bd2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102bd5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102bd8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102bdb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102bde:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102be1:	89 10                	mov    %edx,(%eax)
}
  102be3:	90                   	nop
}
  102be4:	90                   	nop
  102be5:	eb 7d                	jmp    102c64 <default_free_pages+0x23e>
        }
        else if (p + p->property == base) {
  102be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bea:	8b 50 08             	mov    0x8(%eax),%edx
  102bed:	89 d0                	mov    %edx,%eax
  102bef:	c1 e0 02             	shl    $0x2,%eax
  102bf2:	01 d0                	add    %edx,%eax
  102bf4:	c1 e0 02             	shl    $0x2,%eax
  102bf7:	89 c2                	mov    %eax,%edx
  102bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bfc:	01 d0                	add    %edx,%eax
  102bfe:	39 45 08             	cmp    %eax,0x8(%ebp)
  102c01:	75 61                	jne    102c64 <default_free_pages+0x23e>
            p->property += base->property;
  102c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c06:	8b 50 08             	mov    0x8(%eax),%edx
  102c09:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0c:	8b 40 08             	mov    0x8(%eax),%eax
  102c0f:	01 c2                	add    %eax,%edx
  102c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c14:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102c17:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1a:	83 c0 04             	add    $0x4,%eax
  102c1d:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  102c24:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c27:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102c2a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102c2d:	0f b3 10             	btr    %edx,(%eax)
}
  102c30:	90                   	nop
            base = p;
  102c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c34:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3a:	83 c0 0c             	add    $0xc,%eax
  102c3d:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  102c40:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c43:	8b 40 04             	mov    0x4(%eax),%eax
  102c46:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102c49:	8b 12                	mov    (%edx),%edx
  102c4b:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102c4e:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  102c51:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102c54:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102c57:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102c5a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102c5d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102c60:	89 10                	mov    %edx,(%eax)
}
  102c62:	90                   	nop
}
  102c63:	90                   	nop
    while (le != &free_list) {
  102c64:	81 7d f0 80 be 11 00 	cmpl   $0x11be80,-0x10(%ebp)
  102c6b:	0f 85 e5 fe ff ff    	jne    102b56 <default_free_pages+0x130>
        }
    }
    nr_free += n;
  102c71:	8b 15 88 be 11 00    	mov    0x11be88,%edx
  102c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c7a:	01 d0                	add    %edx,%eax
  102c7c:	a3 88 be 11 00       	mov    %eax,0x11be88
    list_add(&free_list, &(base->page_link));
  102c81:	8b 45 08             	mov    0x8(%ebp),%eax
  102c84:	83 c0 0c             	add    $0xc,%eax
  102c87:	c7 45 9c 80 be 11 00 	movl   $0x11be80,-0x64(%ebp)
  102c8e:	89 45 98             	mov    %eax,-0x68(%ebp)
  102c91:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102c94:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102c97:	8b 45 98             	mov    -0x68(%ebp),%eax
  102c9a:	89 45 90             	mov    %eax,-0x70(%ebp)
    __list_add(elm, listelm, listelm->next);
  102c9d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102ca0:	8b 40 04             	mov    0x4(%eax),%eax
  102ca3:	8b 55 90             	mov    -0x70(%ebp),%edx
  102ca6:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102ca9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102cac:	89 55 88             	mov    %edx,-0x78(%ebp)
  102caf:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  102cb2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102cb5:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102cb8:	89 10                	mov    %edx,(%eax)
  102cba:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102cbd:	8b 10                	mov    (%eax),%edx
  102cbf:	8b 45 88             	mov    -0x78(%ebp),%eax
  102cc2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cc5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102cc8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102ccb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cce:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102cd1:	8b 55 88             	mov    -0x78(%ebp),%edx
  102cd4:	89 10                	mov    %edx,(%eax)
}
  102cd6:	90                   	nop
}
  102cd7:	90                   	nop
}
  102cd8:	90                   	nop
}
  102cd9:	90                   	nop
  102cda:	89 ec                	mov    %ebp,%esp
  102cdc:	5d                   	pop    %ebp
  102cdd:	c3                   	ret    

00102cde <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102cde:	55                   	push   %ebp
  102cdf:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102ce1:	a1 88 be 11 00       	mov    0x11be88,%eax
}
  102ce6:	5d                   	pop    %ebp
  102ce7:	c3                   	ret    

00102ce8 <basic_check>:

static void
basic_check(void) {
  102ce8:	55                   	push   %ebp
  102ce9:	89 e5                	mov    %esp,%ebp
  102ceb:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cf8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cfe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102d01:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d08:	e8 df 0e 00 00       	call   103bec <alloc_pages>
  102d0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102d14:	75 24                	jne    102d3a <basic_check+0x52>
  102d16:	c7 44 24 0c 79 63 10 	movl   $0x106379,0xc(%esp)
  102d1d:	00 
  102d1e:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102d25:	00 
  102d26:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  102d2d:	00 
  102d2e:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102d35:	e8 e9 de ff ff       	call   100c23 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102d3a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d41:	e8 a6 0e 00 00       	call   103bec <alloc_pages>
  102d46:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102d4d:	75 24                	jne    102d73 <basic_check+0x8b>
  102d4f:	c7 44 24 0c 95 63 10 	movl   $0x106395,0xc(%esp)
  102d56:	00 
  102d57:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102d5e:	00 
  102d5f:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  102d66:	00 
  102d67:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102d6e:	e8 b0 de ff ff       	call   100c23 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102d73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d7a:	e8 6d 0e 00 00       	call   103bec <alloc_pages>
  102d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102d86:	75 24                	jne    102dac <basic_check+0xc4>
  102d88:	c7 44 24 0c b1 63 10 	movl   $0x1063b1,0xc(%esp)
  102d8f:	00 
  102d90:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102d97:	00 
  102d98:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  102d9f:	00 
  102da0:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102da7:	e8 77 de ff ff       	call   100c23 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102daf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102db2:	74 10                	je     102dc4 <basic_check+0xdc>
  102db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102db7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102dba:	74 08                	je     102dc4 <basic_check+0xdc>
  102dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102dc2:	75 24                	jne    102de8 <basic_check+0x100>
  102dc4:	c7 44 24 0c d0 63 10 	movl   $0x1063d0,0xc(%esp)
  102dcb:	00 
  102dcc:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102dd3:	00 
  102dd4:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  102ddb:	00 
  102ddc:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102de3:	e8 3b de ff ff       	call   100c23 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102de8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102deb:	89 04 24             	mov    %eax,(%esp)
  102dee:	e8 0c f9 ff ff       	call   1026ff <page_ref>
  102df3:	85 c0                	test   %eax,%eax
  102df5:	75 1e                	jne    102e15 <basic_check+0x12d>
  102df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dfa:	89 04 24             	mov    %eax,(%esp)
  102dfd:	e8 fd f8 ff ff       	call   1026ff <page_ref>
  102e02:	85 c0                	test   %eax,%eax
  102e04:	75 0f                	jne    102e15 <basic_check+0x12d>
  102e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e09:	89 04 24             	mov    %eax,(%esp)
  102e0c:	e8 ee f8 ff ff       	call   1026ff <page_ref>
  102e11:	85 c0                	test   %eax,%eax
  102e13:	74 24                	je     102e39 <basic_check+0x151>
  102e15:	c7 44 24 0c f4 63 10 	movl   $0x1063f4,0xc(%esp)
  102e1c:	00 
  102e1d:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102e24:	00 
  102e25:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  102e2c:	00 
  102e2d:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102e34:	e8 ea dd ff ff       	call   100c23 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e3c:	89 04 24             	mov    %eax,(%esp)
  102e3f:	e8 a3 f8 ff ff       	call   1026e7 <page2pa>
  102e44:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  102e4a:	c1 e2 0c             	shl    $0xc,%edx
  102e4d:	39 d0                	cmp    %edx,%eax
  102e4f:	72 24                	jb     102e75 <basic_check+0x18d>
  102e51:	c7 44 24 0c 30 64 10 	movl   $0x106430,0xc(%esp)
  102e58:	00 
  102e59:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102e60:	00 
  102e61:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  102e68:	00 
  102e69:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102e70:	e8 ae dd ff ff       	call   100c23 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e78:	89 04 24             	mov    %eax,(%esp)
  102e7b:	e8 67 f8 ff ff       	call   1026e7 <page2pa>
  102e80:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  102e86:	c1 e2 0c             	shl    $0xc,%edx
  102e89:	39 d0                	cmp    %edx,%eax
  102e8b:	72 24                	jb     102eb1 <basic_check+0x1c9>
  102e8d:	c7 44 24 0c 4d 64 10 	movl   $0x10644d,0xc(%esp)
  102e94:	00 
  102e95:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102e9c:	00 
  102e9d:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  102ea4:	00 
  102ea5:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102eac:	e8 72 dd ff ff       	call   100c23 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb4:	89 04 24             	mov    %eax,(%esp)
  102eb7:	e8 2b f8 ff ff       	call   1026e7 <page2pa>
  102ebc:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  102ec2:	c1 e2 0c             	shl    $0xc,%edx
  102ec5:	39 d0                	cmp    %edx,%eax
  102ec7:	72 24                	jb     102eed <basic_check+0x205>
  102ec9:	c7 44 24 0c 6a 64 10 	movl   $0x10646a,0xc(%esp)
  102ed0:	00 
  102ed1:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102ed8:	00 
  102ed9:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  102ee0:	00 
  102ee1:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102ee8:	e8 36 dd ff ff       	call   100c23 <__panic>

    list_entry_t free_list_store = free_list;
  102eed:	a1 80 be 11 00       	mov    0x11be80,%eax
  102ef2:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  102ef8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102efb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102efe:	c7 45 dc 80 be 11 00 	movl   $0x11be80,-0x24(%ebp)
    elm->prev = elm->next = elm;
  102f05:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f0b:	89 50 04             	mov    %edx,0x4(%eax)
  102f0e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f11:	8b 50 04             	mov    0x4(%eax),%edx
  102f14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f17:	89 10                	mov    %edx,(%eax)
}
  102f19:	90                   	nop
  102f1a:	c7 45 e0 80 be 11 00 	movl   $0x11be80,-0x20(%ebp)
    return list->next == list;
  102f21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f24:	8b 40 04             	mov    0x4(%eax),%eax
  102f27:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  102f2a:	0f 94 c0             	sete   %al
  102f2d:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102f30:	85 c0                	test   %eax,%eax
  102f32:	75 24                	jne    102f58 <basic_check+0x270>
  102f34:	c7 44 24 0c 87 64 10 	movl   $0x106487,0xc(%esp)
  102f3b:	00 
  102f3c:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102f43:	00 
  102f44:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  102f4b:	00 
  102f4c:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102f53:	e8 cb dc ff ff       	call   100c23 <__panic>

    unsigned int nr_free_store = nr_free;
  102f58:	a1 88 be 11 00       	mov    0x11be88,%eax
  102f5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102f60:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  102f67:	00 00 00 

    assert(alloc_page() == NULL);
  102f6a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f71:	e8 76 0c 00 00       	call   103bec <alloc_pages>
  102f76:	85 c0                	test   %eax,%eax
  102f78:	74 24                	je     102f9e <basic_check+0x2b6>
  102f7a:	c7 44 24 0c 9e 64 10 	movl   $0x10649e,0xc(%esp)
  102f81:	00 
  102f82:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102f89:	00 
  102f8a:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  102f91:	00 
  102f92:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  102f99:	e8 85 dc ff ff       	call   100c23 <__panic>

    free_page(p0);
  102f9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102fa5:	00 
  102fa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fa9:	89 04 24             	mov    %eax,(%esp)
  102fac:	e8 75 0c 00 00       	call   103c26 <free_pages>
    free_page(p1);
  102fb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102fb8:	00 
  102fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbc:	89 04 24             	mov    %eax,(%esp)
  102fbf:	e8 62 0c 00 00       	call   103c26 <free_pages>
    free_page(p2);
  102fc4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102fcb:	00 
  102fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fcf:	89 04 24             	mov    %eax,(%esp)
  102fd2:	e8 4f 0c 00 00       	call   103c26 <free_pages>
    assert(nr_free == 3);
  102fd7:	a1 88 be 11 00       	mov    0x11be88,%eax
  102fdc:	83 f8 03             	cmp    $0x3,%eax
  102fdf:	74 24                	je     103005 <basic_check+0x31d>
  102fe1:	c7 44 24 0c b3 64 10 	movl   $0x1064b3,0xc(%esp)
  102fe8:	00 
  102fe9:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  102ff0:	00 
  102ff1:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  102ff8:	00 
  102ff9:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103000:	e8 1e dc ff ff       	call   100c23 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103005:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10300c:	e8 db 0b 00 00       	call   103bec <alloc_pages>
  103011:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103014:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103018:	75 24                	jne    10303e <basic_check+0x356>
  10301a:	c7 44 24 0c 79 63 10 	movl   $0x106379,0xc(%esp)
  103021:	00 
  103022:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103029:	00 
  10302a:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  103031:	00 
  103032:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103039:	e8 e5 db ff ff       	call   100c23 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10303e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103045:	e8 a2 0b 00 00       	call   103bec <alloc_pages>
  10304a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10304d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103051:	75 24                	jne    103077 <basic_check+0x38f>
  103053:	c7 44 24 0c 95 63 10 	movl   $0x106395,0xc(%esp)
  10305a:	00 
  10305b:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103062:	00 
  103063:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  10306a:	00 
  10306b:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103072:	e8 ac db ff ff       	call   100c23 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103077:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10307e:	e8 69 0b 00 00       	call   103bec <alloc_pages>
  103083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103086:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10308a:	75 24                	jne    1030b0 <basic_check+0x3c8>
  10308c:	c7 44 24 0c b1 63 10 	movl   $0x1063b1,0xc(%esp)
  103093:	00 
  103094:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10309b:	00 
  10309c:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1030a3:	00 
  1030a4:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1030ab:	e8 73 db ff ff       	call   100c23 <__panic>

    assert(alloc_page() == NULL);
  1030b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030b7:	e8 30 0b 00 00       	call   103bec <alloc_pages>
  1030bc:	85 c0                	test   %eax,%eax
  1030be:	74 24                	je     1030e4 <basic_check+0x3fc>
  1030c0:	c7 44 24 0c 9e 64 10 	movl   $0x10649e,0xc(%esp)
  1030c7:	00 
  1030c8:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1030cf:	00 
  1030d0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  1030d7:	00 
  1030d8:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1030df:	e8 3f db ff ff       	call   100c23 <__panic>

    free_page(p0);
  1030e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030eb:	00 
  1030ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030ef:	89 04 24             	mov    %eax,(%esp)
  1030f2:	e8 2f 0b 00 00       	call   103c26 <free_pages>
  1030f7:	c7 45 d8 80 be 11 00 	movl   $0x11be80,-0x28(%ebp)
  1030fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103101:	8b 40 04             	mov    0x4(%eax),%eax
  103104:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103107:	0f 94 c0             	sete   %al
  10310a:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10310d:	85 c0                	test   %eax,%eax
  10310f:	74 24                	je     103135 <basic_check+0x44d>
  103111:	c7 44 24 0c c0 64 10 	movl   $0x1064c0,0xc(%esp)
  103118:	00 
  103119:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103120:	00 
  103121:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  103128:	00 
  103129:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103130:	e8 ee da ff ff       	call   100c23 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103135:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10313c:	e8 ab 0a 00 00       	call   103bec <alloc_pages>
  103141:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103147:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10314a:	74 24                	je     103170 <basic_check+0x488>
  10314c:	c7 44 24 0c d8 64 10 	movl   $0x1064d8,0xc(%esp)
  103153:	00 
  103154:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10315b:	00 
  10315c:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  103163:	00 
  103164:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  10316b:	e8 b3 da ff ff       	call   100c23 <__panic>
    assert(alloc_page() == NULL);
  103170:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103177:	e8 70 0a 00 00       	call   103bec <alloc_pages>
  10317c:	85 c0                	test   %eax,%eax
  10317e:	74 24                	je     1031a4 <basic_check+0x4bc>
  103180:	c7 44 24 0c 9e 64 10 	movl   $0x10649e,0xc(%esp)
  103187:	00 
  103188:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10318f:	00 
  103190:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103197:	00 
  103198:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  10319f:	e8 7f da ff ff       	call   100c23 <__panic>

    assert(nr_free == 0);
  1031a4:	a1 88 be 11 00       	mov    0x11be88,%eax
  1031a9:	85 c0                	test   %eax,%eax
  1031ab:	74 24                	je     1031d1 <basic_check+0x4e9>
  1031ad:	c7 44 24 0c f1 64 10 	movl   $0x1064f1,0xc(%esp)
  1031b4:	00 
  1031b5:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1031bc:	00 
  1031bd:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  1031c4:	00 
  1031c5:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1031cc:	e8 52 da ff ff       	call   100c23 <__panic>
    free_list = free_list_store;
  1031d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1031d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1031d7:	a3 80 be 11 00       	mov    %eax,0x11be80
  1031dc:	89 15 84 be 11 00    	mov    %edx,0x11be84
    nr_free = nr_free_store;
  1031e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031e5:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_page(p);
  1031ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1031f1:	00 
  1031f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031f5:	89 04 24             	mov    %eax,(%esp)
  1031f8:	e8 29 0a 00 00       	call   103c26 <free_pages>
    free_page(p1);
  1031fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103204:	00 
  103205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103208:	89 04 24             	mov    %eax,(%esp)
  10320b:	e8 16 0a 00 00       	call   103c26 <free_pages>
    free_page(p2);
  103210:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103217:	00 
  103218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10321b:	89 04 24             	mov    %eax,(%esp)
  10321e:	e8 03 0a 00 00       	call   103c26 <free_pages>
}
  103223:	90                   	nop
  103224:	89 ec                	mov    %ebp,%esp
  103226:	5d                   	pop    %ebp
  103227:	c3                   	ret    

00103228 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103228:	55                   	push   %ebp
  103229:	89 e5                	mov    %esp,%ebp
  10322b:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  103231:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103238:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10323f:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103246:	eb 6a                	jmp    1032b2 <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  103248:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10324b:	83 e8 0c             	sub    $0xc,%eax
  10324e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  103251:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103254:	83 c0 04             	add    $0x4,%eax
  103257:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10325e:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103261:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103264:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103267:	0f a3 10             	bt     %edx,(%eax)
  10326a:	19 c0                	sbb    %eax,%eax
  10326c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10326f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103273:	0f 95 c0             	setne  %al
  103276:	0f b6 c0             	movzbl %al,%eax
  103279:	85 c0                	test   %eax,%eax
  10327b:	75 24                	jne    1032a1 <default_check+0x79>
  10327d:	c7 44 24 0c fe 64 10 	movl   $0x1064fe,0xc(%esp)
  103284:	00 
  103285:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10328c:	00 
  10328d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  103294:	00 
  103295:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  10329c:	e8 82 d9 ff ff       	call   100c23 <__panic>
        count ++, total += p->property;
  1032a1:	ff 45 f4             	incl   -0xc(%ebp)
  1032a4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1032a7:	8b 50 08             	mov    0x8(%eax),%edx
  1032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032ad:	01 d0                	add    %edx,%eax
  1032af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  1032b8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1032bb:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1032be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032c1:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  1032c8:	0f 85 7a ff ff ff    	jne    103248 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  1032ce:	e8 88 09 00 00       	call   103c5b <nr_free_pages>
  1032d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1032d6:	39 d0                	cmp    %edx,%eax
  1032d8:	74 24                	je     1032fe <default_check+0xd6>
  1032da:	c7 44 24 0c 0e 65 10 	movl   $0x10650e,0xc(%esp)
  1032e1:	00 
  1032e2:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1032e9:	00 
  1032ea:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1032f1:	00 
  1032f2:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1032f9:	e8 25 d9 ff ff       	call   100c23 <__panic>

    basic_check();
  1032fe:	e8 e5 f9 ff ff       	call   102ce8 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103303:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10330a:	e8 dd 08 00 00       	call   103bec <alloc_pages>
  10330f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  103312:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103316:	75 24                	jne    10333c <default_check+0x114>
  103318:	c7 44 24 0c 27 65 10 	movl   $0x106527,0xc(%esp)
  10331f:	00 
  103320:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103327:	00 
  103328:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  10332f:	00 
  103330:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103337:	e8 e7 d8 ff ff       	call   100c23 <__panic>
    assert(!PageProperty(p0));
  10333c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10333f:	83 c0 04             	add    $0x4,%eax
  103342:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103349:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10334c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10334f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103352:	0f a3 10             	bt     %edx,(%eax)
  103355:	19 c0                	sbb    %eax,%eax
  103357:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10335a:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10335e:	0f 95 c0             	setne  %al
  103361:	0f b6 c0             	movzbl %al,%eax
  103364:	85 c0                	test   %eax,%eax
  103366:	74 24                	je     10338c <default_check+0x164>
  103368:	c7 44 24 0c 32 65 10 	movl   $0x106532,0xc(%esp)
  10336f:	00 
  103370:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103377:	00 
  103378:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  10337f:	00 
  103380:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103387:	e8 97 d8 ff ff       	call   100c23 <__panic>

    list_entry_t free_list_store = free_list;
  10338c:	a1 80 be 11 00       	mov    0x11be80,%eax
  103391:	8b 15 84 be 11 00    	mov    0x11be84,%edx
  103397:	89 45 80             	mov    %eax,-0x80(%ebp)
  10339a:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10339d:	c7 45 b0 80 be 11 00 	movl   $0x11be80,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1033a4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1033a7:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1033aa:	89 50 04             	mov    %edx,0x4(%eax)
  1033ad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1033b0:	8b 50 04             	mov    0x4(%eax),%edx
  1033b3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1033b6:	89 10                	mov    %edx,(%eax)
}
  1033b8:	90                   	nop
  1033b9:	c7 45 b4 80 be 11 00 	movl   $0x11be80,-0x4c(%ebp)
    return list->next == list;
  1033c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1033c3:	8b 40 04             	mov    0x4(%eax),%eax
  1033c6:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1033c9:	0f 94 c0             	sete   %al
  1033cc:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1033cf:	85 c0                	test   %eax,%eax
  1033d1:	75 24                	jne    1033f7 <default_check+0x1cf>
  1033d3:	c7 44 24 0c 87 64 10 	movl   $0x106487,0xc(%esp)
  1033da:	00 
  1033db:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1033e2:	00 
  1033e3:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  1033ea:	00 
  1033eb:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1033f2:	e8 2c d8 ff ff       	call   100c23 <__panic>
    assert(alloc_page() == NULL);
  1033f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033fe:	e8 e9 07 00 00       	call   103bec <alloc_pages>
  103403:	85 c0                	test   %eax,%eax
  103405:	74 24                	je     10342b <default_check+0x203>
  103407:	c7 44 24 0c 9e 64 10 	movl   $0x10649e,0xc(%esp)
  10340e:	00 
  10340f:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103416:	00 
  103417:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  10341e:	00 
  10341f:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103426:	e8 f8 d7 ff ff       	call   100c23 <__panic>

    unsigned int nr_free_store = nr_free;
  10342b:	a1 88 be 11 00       	mov    0x11be88,%eax
  103430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  103433:	c7 05 88 be 11 00 00 	movl   $0x0,0x11be88
  10343a:	00 00 00 

    free_pages(p0 + 2, 3);
  10343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103440:	83 c0 28             	add    $0x28,%eax
  103443:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10344a:	00 
  10344b:	89 04 24             	mov    %eax,(%esp)
  10344e:	e8 d3 07 00 00       	call   103c26 <free_pages>
    assert(alloc_pages(4) == NULL);
  103453:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10345a:	e8 8d 07 00 00       	call   103bec <alloc_pages>
  10345f:	85 c0                	test   %eax,%eax
  103461:	74 24                	je     103487 <default_check+0x25f>
  103463:	c7 44 24 0c 44 65 10 	movl   $0x106544,0xc(%esp)
  10346a:	00 
  10346b:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103472:	00 
  103473:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  10347a:	00 
  10347b:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103482:	e8 9c d7 ff ff       	call   100c23 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103487:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10348a:	83 c0 28             	add    $0x28,%eax
  10348d:	83 c0 04             	add    $0x4,%eax
  103490:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103497:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10349a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10349d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1034a0:	0f a3 10             	bt     %edx,(%eax)
  1034a3:	19 c0                	sbb    %eax,%eax
  1034a5:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1034a8:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1034ac:	0f 95 c0             	setne  %al
  1034af:	0f b6 c0             	movzbl %al,%eax
  1034b2:	85 c0                	test   %eax,%eax
  1034b4:	74 0e                	je     1034c4 <default_check+0x29c>
  1034b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b9:	83 c0 28             	add    $0x28,%eax
  1034bc:	8b 40 08             	mov    0x8(%eax),%eax
  1034bf:	83 f8 03             	cmp    $0x3,%eax
  1034c2:	74 24                	je     1034e8 <default_check+0x2c0>
  1034c4:	c7 44 24 0c 5c 65 10 	movl   $0x10655c,0xc(%esp)
  1034cb:	00 
  1034cc:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1034d3:	00 
  1034d4:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1034db:	00 
  1034dc:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1034e3:	e8 3b d7 ff ff       	call   100c23 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1034e8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1034ef:	e8 f8 06 00 00       	call   103bec <alloc_pages>
  1034f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034f7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1034fb:	75 24                	jne    103521 <default_check+0x2f9>
  1034fd:	c7 44 24 0c 88 65 10 	movl   $0x106588,0xc(%esp)
  103504:	00 
  103505:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10350c:	00 
  10350d:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  103514:	00 
  103515:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  10351c:	e8 02 d7 ff ff       	call   100c23 <__panic>
    assert(alloc_page() == NULL);
  103521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103528:	e8 bf 06 00 00       	call   103bec <alloc_pages>
  10352d:	85 c0                	test   %eax,%eax
  10352f:	74 24                	je     103555 <default_check+0x32d>
  103531:	c7 44 24 0c 9e 64 10 	movl   $0x10649e,0xc(%esp)
  103538:	00 
  103539:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103540:	00 
  103541:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  103548:	00 
  103549:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103550:	e8 ce d6 ff ff       	call   100c23 <__panic>
    assert(p0 + 2 == p1);
  103555:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103558:	83 c0 28             	add    $0x28,%eax
  10355b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10355e:	74 24                	je     103584 <default_check+0x35c>
  103560:	c7 44 24 0c a6 65 10 	movl   $0x1065a6,0xc(%esp)
  103567:	00 
  103568:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10356f:	00 
  103570:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  103577:	00 
  103578:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  10357f:	e8 9f d6 ff ff       	call   100c23 <__panic>

    p2 = p0 + 1;
  103584:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103587:	83 c0 14             	add    $0x14,%eax
  10358a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  10358d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103594:	00 
  103595:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103598:	89 04 24             	mov    %eax,(%esp)
  10359b:	e8 86 06 00 00       	call   103c26 <free_pages>
    free_pages(p1, 3);
  1035a0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035a7:	00 
  1035a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035ab:	89 04 24             	mov    %eax,(%esp)
  1035ae:	e8 73 06 00 00       	call   103c26 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035b6:	83 c0 04             	add    $0x4,%eax
  1035b9:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1035c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1035c6:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1035c9:	0f a3 10             	bt     %edx,(%eax)
  1035cc:	19 c0                	sbb    %eax,%eax
  1035ce:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1035d1:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1035d5:	0f 95 c0             	setne  %al
  1035d8:	0f b6 c0             	movzbl %al,%eax
  1035db:	85 c0                	test   %eax,%eax
  1035dd:	74 0b                	je     1035ea <default_check+0x3c2>
  1035df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1035e2:	8b 40 08             	mov    0x8(%eax),%eax
  1035e5:	83 f8 01             	cmp    $0x1,%eax
  1035e8:	74 24                	je     10360e <default_check+0x3e6>
  1035ea:	c7 44 24 0c b4 65 10 	movl   $0x1065b4,0xc(%esp)
  1035f1:	00 
  1035f2:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1035f9:	00 
  1035fa:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  103601:	00 
  103602:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103609:	e8 15 d6 ff ff       	call   100c23 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10360e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103611:	83 c0 04             	add    $0x4,%eax
  103614:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10361b:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10361e:	8b 45 90             	mov    -0x70(%ebp),%eax
  103621:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103624:	0f a3 10             	bt     %edx,(%eax)
  103627:	19 c0                	sbb    %eax,%eax
  103629:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10362c:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103630:	0f 95 c0             	setne  %al
  103633:	0f b6 c0             	movzbl %al,%eax
  103636:	85 c0                	test   %eax,%eax
  103638:	74 0b                	je     103645 <default_check+0x41d>
  10363a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10363d:	8b 40 08             	mov    0x8(%eax),%eax
  103640:	83 f8 03             	cmp    $0x3,%eax
  103643:	74 24                	je     103669 <default_check+0x441>
  103645:	c7 44 24 0c dc 65 10 	movl   $0x1065dc,0xc(%esp)
  10364c:	00 
  10364d:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103654:	00 
  103655:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  10365c:	00 
  10365d:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103664:	e8 ba d5 ff ff       	call   100c23 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103669:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103670:	e8 77 05 00 00       	call   103bec <alloc_pages>
  103675:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10367b:	83 e8 14             	sub    $0x14,%eax
  10367e:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103681:	74 24                	je     1036a7 <default_check+0x47f>
  103683:	c7 44 24 0c 02 66 10 	movl   $0x106602,0xc(%esp)
  10368a:	00 
  10368b:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103692:	00 
  103693:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  10369a:	00 
  10369b:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1036a2:	e8 7c d5 ff ff       	call   100c23 <__panic>
    free_page(p0);
  1036a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036ae:	00 
  1036af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036b2:	89 04 24             	mov    %eax,(%esp)
  1036b5:	e8 6c 05 00 00       	call   103c26 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1036ba:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1036c1:	e8 26 05 00 00       	call   103bec <alloc_pages>
  1036c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1036c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036cc:	83 c0 14             	add    $0x14,%eax
  1036cf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1036d2:	74 24                	je     1036f8 <default_check+0x4d0>
  1036d4:	c7 44 24 0c 20 66 10 	movl   $0x106620,0xc(%esp)
  1036db:	00 
  1036dc:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1036e3:	00 
  1036e4:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  1036eb:	00 
  1036ec:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1036f3:	e8 2b d5 ff ff       	call   100c23 <__panic>

    free_pages(p0, 2);
  1036f8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1036ff:	00 
  103700:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103703:	89 04 24             	mov    %eax,(%esp)
  103706:	e8 1b 05 00 00       	call   103c26 <free_pages>
    free_page(p2);
  10370b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103712:	00 
  103713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103716:	89 04 24             	mov    %eax,(%esp)
  103719:	e8 08 05 00 00       	call   103c26 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10371e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103725:	e8 c2 04 00 00       	call   103bec <alloc_pages>
  10372a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10372d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103731:	75 24                	jne    103757 <default_check+0x52f>
  103733:	c7 44 24 0c 40 66 10 	movl   $0x106640,0xc(%esp)
  10373a:	00 
  10373b:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103742:	00 
  103743:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  10374a:	00 
  10374b:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103752:	e8 cc d4 ff ff       	call   100c23 <__panic>
    assert(alloc_page() == NULL);
  103757:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10375e:	e8 89 04 00 00       	call   103bec <alloc_pages>
  103763:	85 c0                	test   %eax,%eax
  103765:	74 24                	je     10378b <default_check+0x563>
  103767:	c7 44 24 0c 9e 64 10 	movl   $0x10649e,0xc(%esp)
  10376e:	00 
  10376f:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103776:	00 
  103777:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  10377e:	00 
  10377f:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103786:	e8 98 d4 ff ff       	call   100c23 <__panic>

    assert(nr_free == 0);
  10378b:	a1 88 be 11 00       	mov    0x11be88,%eax
  103790:	85 c0                	test   %eax,%eax
  103792:	74 24                	je     1037b8 <default_check+0x590>
  103794:	c7 44 24 0c f1 64 10 	movl   $0x1064f1,0xc(%esp)
  10379b:	00 
  10379c:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  1037a3:	00 
  1037a4:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1037ab:	00 
  1037ac:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1037b3:	e8 6b d4 ff ff       	call   100c23 <__panic>
    nr_free = nr_free_store;
  1037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037bb:	a3 88 be 11 00       	mov    %eax,0x11be88

    free_list = free_list_store;
  1037c0:	8b 45 80             	mov    -0x80(%ebp),%eax
  1037c3:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1037c6:	a3 80 be 11 00       	mov    %eax,0x11be80
  1037cb:	89 15 84 be 11 00    	mov    %edx,0x11be84
    free_pages(p0, 5);
  1037d1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1037d8:	00 
  1037d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1037dc:	89 04 24             	mov    %eax,(%esp)
  1037df:	e8 42 04 00 00       	call   103c26 <free_pages>

    le = &free_list;
  1037e4:	c7 45 ec 80 be 11 00 	movl   $0x11be80,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1037eb:	eb 5a                	jmp    103847 <default_check+0x61f>
        assert(le->next->prev == le && le->prev->next == le);
  1037ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037f0:	8b 40 04             	mov    0x4(%eax),%eax
  1037f3:	8b 00                	mov    (%eax),%eax
  1037f5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1037f8:	75 0d                	jne    103807 <default_check+0x5df>
  1037fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037fd:	8b 00                	mov    (%eax),%eax
  1037ff:	8b 40 04             	mov    0x4(%eax),%eax
  103802:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103805:	74 24                	je     10382b <default_check+0x603>
  103807:	c7 44 24 0c 60 66 10 	movl   $0x106660,0xc(%esp)
  10380e:	00 
  10380f:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103816:	00 
  103817:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  10381e:	00 
  10381f:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103826:	e8 f8 d3 ff ff       	call   100c23 <__panic>
        struct Page *p = le2page(le, page_link);
  10382b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10382e:	83 e8 0c             	sub    $0xc,%eax
  103831:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  103834:	ff 4d f4             	decl   -0xc(%ebp)
  103837:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10383a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10383d:	8b 48 08             	mov    0x8(%eax),%ecx
  103840:	89 d0                	mov    %edx,%eax
  103842:	29 c8                	sub    %ecx,%eax
  103844:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10384a:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  10384d:	8b 45 88             	mov    -0x78(%ebp),%eax
  103850:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  103853:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103856:	81 7d ec 80 be 11 00 	cmpl   $0x11be80,-0x14(%ebp)
  10385d:	75 8e                	jne    1037ed <default_check+0x5c5>
    }
    assert(count == 0);
  10385f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103863:	74 24                	je     103889 <default_check+0x661>
  103865:	c7 44 24 0c 8d 66 10 	movl   $0x10668d,0xc(%esp)
  10386c:	00 
  10386d:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  103874:	00 
  103875:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  10387c:	00 
  10387d:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  103884:	e8 9a d3 ff ff       	call   100c23 <__panic>
    assert(total == 0);
  103889:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10388d:	74 24                	je     1038b3 <default_check+0x68b>
  10388f:	c7 44 24 0c 98 66 10 	movl   $0x106698,0xc(%esp)
  103896:	00 
  103897:	c7 44 24 08 16 63 10 	movl   $0x106316,0x8(%esp)
  10389e:	00 
  10389f:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1038a6:	00 
  1038a7:	c7 04 24 2b 63 10 00 	movl   $0x10632b,(%esp)
  1038ae:	e8 70 d3 ff ff       	call   100c23 <__panic>
}
  1038b3:	90                   	nop
  1038b4:	89 ec                	mov    %ebp,%esp
  1038b6:	5d                   	pop    %ebp
  1038b7:	c3                   	ret    

001038b8 <page2ppn>:
page2ppn(struct Page *page) {
  1038b8:	55                   	push   %ebp
  1038b9:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1038bb:	8b 15 a0 be 11 00    	mov    0x11bea0,%edx
  1038c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1038c4:	29 d0                	sub    %edx,%eax
  1038c6:	c1 f8 02             	sar    $0x2,%eax
  1038c9:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1038cf:	5d                   	pop    %ebp
  1038d0:	c3                   	ret    

001038d1 <page2pa>:
page2pa(struct Page *page) {
  1038d1:	55                   	push   %ebp
  1038d2:	89 e5                	mov    %esp,%ebp
  1038d4:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1038d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1038da:	89 04 24             	mov    %eax,(%esp)
  1038dd:	e8 d6 ff ff ff       	call   1038b8 <page2ppn>
  1038e2:	c1 e0 0c             	shl    $0xc,%eax
}
  1038e5:	89 ec                	mov    %ebp,%esp
  1038e7:	5d                   	pop    %ebp
  1038e8:	c3                   	ret    

001038e9 <pa2page>:
pa2page(uintptr_t pa) {
  1038e9:	55                   	push   %ebp
  1038ea:	89 e5                	mov    %esp,%ebp
  1038ec:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1038f2:	c1 e8 0c             	shr    $0xc,%eax
  1038f5:	89 c2                	mov    %eax,%edx
  1038f7:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  1038fc:	39 c2                	cmp    %eax,%edx
  1038fe:	72 1c                	jb     10391c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103900:	c7 44 24 08 d4 66 10 	movl   $0x1066d4,0x8(%esp)
  103907:	00 
  103908:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  10390f:	00 
  103910:	c7 04 24 f3 66 10 00 	movl   $0x1066f3,(%esp)
  103917:	e8 07 d3 ff ff       	call   100c23 <__panic>
    return &pages[PPN(pa)];
  10391c:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  103922:	8b 45 08             	mov    0x8(%ebp),%eax
  103925:	c1 e8 0c             	shr    $0xc,%eax
  103928:	89 c2                	mov    %eax,%edx
  10392a:	89 d0                	mov    %edx,%eax
  10392c:	c1 e0 02             	shl    $0x2,%eax
  10392f:	01 d0                	add    %edx,%eax
  103931:	c1 e0 02             	shl    $0x2,%eax
  103934:	01 c8                	add    %ecx,%eax
}
  103936:	89 ec                	mov    %ebp,%esp
  103938:	5d                   	pop    %ebp
  103939:	c3                   	ret    

0010393a <page2kva>:
page2kva(struct Page *page) {
  10393a:	55                   	push   %ebp
  10393b:	89 e5                	mov    %esp,%ebp
  10393d:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103940:	8b 45 08             	mov    0x8(%ebp),%eax
  103943:	89 04 24             	mov    %eax,(%esp)
  103946:	e8 86 ff ff ff       	call   1038d1 <page2pa>
  10394b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10394e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103951:	c1 e8 0c             	shr    $0xc,%eax
  103954:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103957:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  10395c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10395f:	72 23                	jb     103984 <page2kva+0x4a>
  103961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103964:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103968:	c7 44 24 08 04 67 10 	movl   $0x106704,0x8(%esp)
  10396f:	00 
  103970:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103977:	00 
  103978:	c7 04 24 f3 66 10 00 	movl   $0x1066f3,(%esp)
  10397f:	e8 9f d2 ff ff       	call   100c23 <__panic>
  103984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103987:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  10398c:	89 ec                	mov    %ebp,%esp
  10398e:	5d                   	pop    %ebp
  10398f:	c3                   	ret    

00103990 <pte2page>:
pte2page(pte_t pte) {
  103990:	55                   	push   %ebp
  103991:	89 e5                	mov    %esp,%ebp
  103993:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103996:	8b 45 08             	mov    0x8(%ebp),%eax
  103999:	83 e0 01             	and    $0x1,%eax
  10399c:	85 c0                	test   %eax,%eax
  10399e:	75 1c                	jne    1039bc <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1039a0:	c7 44 24 08 28 67 10 	movl   $0x106728,0x8(%esp)
  1039a7:	00 
  1039a8:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  1039af:	00 
  1039b0:	c7 04 24 f3 66 10 00 	movl   $0x1066f3,(%esp)
  1039b7:	e8 67 d2 ff ff       	call   100c23 <__panic>
    return pa2page(PTE_ADDR(pte));
  1039bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1039bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039c4:	89 04 24             	mov    %eax,(%esp)
  1039c7:	e8 1d ff ff ff       	call   1038e9 <pa2page>
}
  1039cc:	89 ec                	mov    %ebp,%esp
  1039ce:	5d                   	pop    %ebp
  1039cf:	c3                   	ret    

001039d0 <pde2page>:
pde2page(pde_t pde) {
  1039d0:	55                   	push   %ebp
  1039d1:	89 e5                	mov    %esp,%ebp
  1039d3:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  1039d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1039d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1039de:	89 04 24             	mov    %eax,(%esp)
  1039e1:	e8 03 ff ff ff       	call   1038e9 <pa2page>
}
  1039e6:	89 ec                	mov    %ebp,%esp
  1039e8:	5d                   	pop    %ebp
  1039e9:	c3                   	ret    

001039ea <page_ref>:
page_ref(struct Page *page) {
  1039ea:	55                   	push   %ebp
  1039eb:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1039f0:	8b 00                	mov    (%eax),%eax
}
  1039f2:	5d                   	pop    %ebp
  1039f3:	c3                   	ret    

001039f4 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  1039f4:	55                   	push   %ebp
  1039f5:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1039fa:	8b 00                	mov    (%eax),%eax
  1039fc:	8d 50 01             	lea    0x1(%eax),%edx
  1039ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103a02:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a04:	8b 45 08             	mov    0x8(%ebp),%eax
  103a07:	8b 00                	mov    (%eax),%eax
}
  103a09:	5d                   	pop    %ebp
  103a0a:	c3                   	ret    

00103a0b <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103a0b:	55                   	push   %ebp
  103a0c:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a11:	8b 00                	mov    (%eax),%eax
  103a13:	8d 50 ff             	lea    -0x1(%eax),%edx
  103a16:	8b 45 08             	mov    0x8(%ebp),%eax
  103a19:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a1e:	8b 00                	mov    (%eax),%eax
}
  103a20:	5d                   	pop    %ebp
  103a21:	c3                   	ret    

00103a22 <__intr_save>:
__intr_save(void) {
  103a22:	55                   	push   %ebp
  103a23:	89 e5                	mov    %esp,%ebp
  103a25:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103a28:	9c                   	pushf  
  103a29:	58                   	pop    %eax
  103a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103a30:	25 00 02 00 00       	and    $0x200,%eax
  103a35:	85 c0                	test   %eax,%eax
  103a37:	74 0c                	je     103a45 <__intr_save+0x23>
        intr_disable();
  103a39:	e8 3e dc ff ff       	call   10167c <intr_disable>
        return 1;
  103a3e:	b8 01 00 00 00       	mov    $0x1,%eax
  103a43:	eb 05                	jmp    103a4a <__intr_save+0x28>
    return 0;
  103a45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103a4a:	89 ec                	mov    %ebp,%esp
  103a4c:	5d                   	pop    %ebp
  103a4d:	c3                   	ret    

00103a4e <__intr_restore>:
__intr_restore(bool flag) {
  103a4e:	55                   	push   %ebp
  103a4f:	89 e5                	mov    %esp,%ebp
  103a51:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103a58:	74 05                	je     103a5f <__intr_restore+0x11>
        intr_enable();
  103a5a:	e8 15 dc ff ff       	call   101674 <intr_enable>
}
  103a5f:	90                   	nop
  103a60:	89 ec                	mov    %ebp,%esp
  103a62:	5d                   	pop    %ebp
  103a63:	c3                   	ret    

00103a64 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103a64:	55                   	push   %ebp
  103a65:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103a67:	8b 45 08             	mov    0x8(%ebp),%eax
  103a6a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103a6d:	b8 23 00 00 00       	mov    $0x23,%eax
  103a72:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103a74:	b8 23 00 00 00       	mov    $0x23,%eax
  103a79:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103a7b:	b8 10 00 00 00       	mov    $0x10,%eax
  103a80:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103a82:	b8 10 00 00 00       	mov    $0x10,%eax
  103a87:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103a89:	b8 10 00 00 00       	mov    $0x10,%eax
  103a8e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103a90:	ea 97 3a 10 00 08 00 	ljmp   $0x8,$0x103a97
}
  103a97:	90                   	nop
  103a98:	5d                   	pop    %ebp
  103a99:	c3                   	ret    

00103a9a <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103a9a:	55                   	push   %ebp
  103a9b:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa0:	a3 c4 be 11 00       	mov    %eax,0x11bec4
}
  103aa5:	90                   	nop
  103aa6:	5d                   	pop    %ebp
  103aa7:	c3                   	ret    

00103aa8 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103aa8:	55                   	push   %ebp
  103aa9:	89 e5                	mov    %esp,%ebp
  103aab:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103aae:	b8 00 80 11 00       	mov    $0x118000,%eax
  103ab3:	89 04 24             	mov    %eax,(%esp)
  103ab6:	e8 df ff ff ff       	call   103a9a <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103abb:	66 c7 05 c8 be 11 00 	movw   $0x10,0x11bec8
  103ac2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103ac4:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103acb:	68 00 
  103acd:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103ad2:	0f b7 c0             	movzwl %ax,%eax
  103ad5:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103adb:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103ae0:	c1 e8 10             	shr    $0x10,%eax
  103ae3:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103ae8:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103aef:	24 f0                	and    $0xf0,%al
  103af1:	0c 09                	or     $0x9,%al
  103af3:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103af8:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103aff:	24 ef                	and    $0xef,%al
  103b01:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103b06:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103b0d:	24 9f                	and    $0x9f,%al
  103b0f:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103b14:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103b1b:	0c 80                	or     $0x80,%al
  103b1d:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103b22:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103b29:	24 f0                	and    $0xf0,%al
  103b2b:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103b30:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103b37:	24 ef                	and    $0xef,%al
  103b39:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103b3e:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103b45:	24 df                	and    $0xdf,%al
  103b47:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103b4c:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103b53:	0c 40                	or     $0x40,%al
  103b55:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103b5a:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103b61:	24 7f                	and    $0x7f,%al
  103b63:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103b68:	b8 c0 be 11 00       	mov    $0x11bec0,%eax
  103b6d:	c1 e8 18             	shr    $0x18,%eax
  103b70:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103b75:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103b7c:	e8 e3 fe ff ff       	call   103a64 <lgdt>
  103b81:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103b87:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103b8b:	0f 00 d8             	ltr    %ax
}
  103b8e:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  103b8f:	90                   	nop
  103b90:	89 ec                	mov    %ebp,%esp
  103b92:	5d                   	pop    %ebp
  103b93:	c3                   	ret    

00103b94 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103b94:	55                   	push   %ebp
  103b95:	89 e5                	mov    %esp,%ebp
  103b97:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103b9a:	c7 05 ac be 11 00 b8 	movl   $0x1066b8,0x11beac
  103ba1:	66 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ba4:	a1 ac be 11 00       	mov    0x11beac,%eax
  103ba9:	8b 00                	mov    (%eax),%eax
  103bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  103baf:	c7 04 24 54 67 10 00 	movl   $0x106754,(%esp)
  103bb6:	e8 9b c7 ff ff       	call   100356 <cprintf>
    pmm_manager->init();
  103bbb:	a1 ac be 11 00       	mov    0x11beac,%eax
  103bc0:	8b 40 04             	mov    0x4(%eax),%eax
  103bc3:	ff d0                	call   *%eax
}
  103bc5:	90                   	nop
  103bc6:	89 ec                	mov    %ebp,%esp
  103bc8:	5d                   	pop    %ebp
  103bc9:	c3                   	ret    

00103bca <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103bca:	55                   	push   %ebp
  103bcb:	89 e5                	mov    %esp,%ebp
  103bcd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103bd0:	a1 ac be 11 00       	mov    0x11beac,%eax
  103bd5:	8b 40 08             	mov    0x8(%eax),%eax
  103bd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  103bdb:	89 54 24 04          	mov    %edx,0x4(%esp)
  103bdf:	8b 55 08             	mov    0x8(%ebp),%edx
  103be2:	89 14 24             	mov    %edx,(%esp)
  103be5:	ff d0                	call   *%eax
}
  103be7:	90                   	nop
  103be8:	89 ec                	mov    %ebp,%esp
  103bea:	5d                   	pop    %ebp
  103beb:	c3                   	ret    

00103bec <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103bec:	55                   	push   %ebp
  103bed:	89 e5                	mov    %esp,%ebp
  103bef:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103bf9:	e8 24 fe ff ff       	call   103a22 <__intr_save>
  103bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103c01:	a1 ac be 11 00       	mov    0x11beac,%eax
  103c06:	8b 40 0c             	mov    0xc(%eax),%eax
  103c09:	8b 55 08             	mov    0x8(%ebp),%edx
  103c0c:	89 14 24             	mov    %edx,(%esp)
  103c0f:	ff d0                	call   *%eax
  103c11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c17:	89 04 24             	mov    %eax,(%esp)
  103c1a:	e8 2f fe ff ff       	call   103a4e <__intr_restore>
    return page;
  103c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103c22:	89 ec                	mov    %ebp,%esp
  103c24:	5d                   	pop    %ebp
  103c25:	c3                   	ret    

00103c26 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103c26:	55                   	push   %ebp
  103c27:	89 e5                	mov    %esp,%ebp
  103c29:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103c2c:	e8 f1 fd ff ff       	call   103a22 <__intr_save>
  103c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103c34:	a1 ac be 11 00       	mov    0x11beac,%eax
  103c39:	8b 40 10             	mov    0x10(%eax),%eax
  103c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c3f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c43:	8b 55 08             	mov    0x8(%ebp),%edx
  103c46:	89 14 24             	mov    %edx,(%esp)
  103c49:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c4e:	89 04 24             	mov    %eax,(%esp)
  103c51:	e8 f8 fd ff ff       	call   103a4e <__intr_restore>
}
  103c56:	90                   	nop
  103c57:	89 ec                	mov    %ebp,%esp
  103c59:	5d                   	pop    %ebp
  103c5a:	c3                   	ret    

00103c5b <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103c5b:	55                   	push   %ebp
  103c5c:	89 e5                	mov    %esp,%ebp
  103c5e:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103c61:	e8 bc fd ff ff       	call   103a22 <__intr_save>
  103c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103c69:	a1 ac be 11 00       	mov    0x11beac,%eax
  103c6e:	8b 40 14             	mov    0x14(%eax),%eax
  103c71:	ff d0                	call   *%eax
  103c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c79:	89 04 24             	mov    %eax,(%esp)
  103c7c:	e8 cd fd ff ff       	call   103a4e <__intr_restore>
    return ret;
  103c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103c84:	89 ec                	mov    %ebp,%esp
  103c86:	5d                   	pop    %ebp
  103c87:	c3                   	ret    

00103c88 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103c88:	55                   	push   %ebp
  103c89:	89 e5                	mov    %esp,%ebp
  103c8b:	57                   	push   %edi
  103c8c:	56                   	push   %esi
  103c8d:	53                   	push   %ebx
  103c8e:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103c94:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103c9b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103ca2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103ca9:	c7 04 24 6b 67 10 00 	movl   $0x10676b,(%esp)
  103cb0:	e8 a1 c6 ff ff       	call   100356 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103cb5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103cbc:	e9 0c 01 00 00       	jmp    103dcd <page_init+0x145>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103cc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103cc4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103cc7:	89 d0                	mov    %edx,%eax
  103cc9:	c1 e0 02             	shl    $0x2,%eax
  103ccc:	01 d0                	add    %edx,%eax
  103cce:	c1 e0 02             	shl    $0x2,%eax
  103cd1:	01 c8                	add    %ecx,%eax
  103cd3:	8b 50 08             	mov    0x8(%eax),%edx
  103cd6:	8b 40 04             	mov    0x4(%eax),%eax
  103cd9:	89 45 a0             	mov    %eax,-0x60(%ebp)
  103cdc:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  103cdf:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ce2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ce5:	89 d0                	mov    %edx,%eax
  103ce7:	c1 e0 02             	shl    $0x2,%eax
  103cea:	01 d0                	add    %edx,%eax
  103cec:	c1 e0 02             	shl    $0x2,%eax
  103cef:	01 c8                	add    %ecx,%eax
  103cf1:	8b 48 0c             	mov    0xc(%eax),%ecx
  103cf4:	8b 58 10             	mov    0x10(%eax),%ebx
  103cf7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103cfa:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103cfd:	01 c8                	add    %ecx,%eax
  103cff:	11 da                	adc    %ebx,%edx
  103d01:	89 45 98             	mov    %eax,-0x68(%ebp)
  103d04:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103d07:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d0d:	89 d0                	mov    %edx,%eax
  103d0f:	c1 e0 02             	shl    $0x2,%eax
  103d12:	01 d0                	add    %edx,%eax
  103d14:	c1 e0 02             	shl    $0x2,%eax
  103d17:	01 c8                	add    %ecx,%eax
  103d19:	83 c0 14             	add    $0x14,%eax
  103d1c:	8b 00                	mov    (%eax),%eax
  103d1e:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103d24:	8b 45 98             	mov    -0x68(%ebp),%eax
  103d27:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103d2a:	83 c0 ff             	add    $0xffffffff,%eax
  103d2d:	83 d2 ff             	adc    $0xffffffff,%edx
  103d30:	89 c6                	mov    %eax,%esi
  103d32:	89 d7                	mov    %edx,%edi
  103d34:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d37:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d3a:	89 d0                	mov    %edx,%eax
  103d3c:	c1 e0 02             	shl    $0x2,%eax
  103d3f:	01 d0                	add    %edx,%eax
  103d41:	c1 e0 02             	shl    $0x2,%eax
  103d44:	01 c8                	add    %ecx,%eax
  103d46:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d49:	8b 58 10             	mov    0x10(%eax),%ebx
  103d4c:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103d52:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103d56:	89 74 24 14          	mov    %esi,0x14(%esp)
  103d5a:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103d5e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103d61:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103d64:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d68:	89 54 24 10          	mov    %edx,0x10(%esp)
  103d6c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103d70:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103d74:	c7 04 24 78 67 10 00 	movl   $0x106778,(%esp)
  103d7b:	e8 d6 c5 ff ff       	call   100356 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103d80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d83:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d86:	89 d0                	mov    %edx,%eax
  103d88:	c1 e0 02             	shl    $0x2,%eax
  103d8b:	01 d0                	add    %edx,%eax
  103d8d:	c1 e0 02             	shl    $0x2,%eax
  103d90:	01 c8                	add    %ecx,%eax
  103d92:	83 c0 14             	add    $0x14,%eax
  103d95:	8b 00                	mov    (%eax),%eax
  103d97:	83 f8 01             	cmp    $0x1,%eax
  103d9a:	75 2e                	jne    103dca <page_init+0x142>
            if (maxpa < end && begin < KMEMSIZE) {
  103d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103d9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103da2:	3b 45 98             	cmp    -0x68(%ebp),%eax
  103da5:	89 d0                	mov    %edx,%eax
  103da7:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  103daa:	73 1e                	jae    103dca <page_init+0x142>
  103dac:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  103db1:	b8 00 00 00 00       	mov    $0x0,%eax
  103db6:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  103db9:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  103dbc:	72 0c                	jb     103dca <page_init+0x142>
                maxpa = end;
  103dbe:	8b 45 98             	mov    -0x68(%ebp),%eax
  103dc1:	8b 55 9c             	mov    -0x64(%ebp),%edx
  103dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103dc7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  103dca:	ff 45 dc             	incl   -0x24(%ebp)
  103dcd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103dd0:	8b 00                	mov    (%eax),%eax
  103dd2:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103dd5:	0f 8c e6 fe ff ff    	jl     103cc1 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103ddb:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103de0:	b8 00 00 00 00       	mov    $0x0,%eax
  103de5:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  103de8:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  103deb:	73 0e                	jae    103dfb <page_init+0x173>
        maxpa = KMEMSIZE;
  103ded:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103df4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103dfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103dfe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e01:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103e05:	c1 ea 0c             	shr    $0xc,%edx
  103e08:	a3 a4 be 11 00       	mov    %eax,0x11bea4
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103e0d:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  103e14:	b8 2c bf 11 00       	mov    $0x11bf2c,%eax
  103e19:	8d 50 ff             	lea    -0x1(%eax),%edx
  103e1c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  103e1f:	01 d0                	add    %edx,%eax
  103e21:	89 45 bc             	mov    %eax,-0x44(%ebp)
  103e24:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103e27:	ba 00 00 00 00       	mov    $0x0,%edx
  103e2c:	f7 75 c0             	divl   -0x40(%ebp)
  103e2f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103e32:	29 d0                	sub    %edx,%eax
  103e34:	a3 a0 be 11 00       	mov    %eax,0x11bea0

    for (i = 0; i < npage; i ++) {
  103e39:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e40:	eb 2f                	jmp    103e71 <page_init+0x1e9>
        SetPageReserved(pages + i);
  103e42:	8b 0d a0 be 11 00    	mov    0x11bea0,%ecx
  103e48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e4b:	89 d0                	mov    %edx,%eax
  103e4d:	c1 e0 02             	shl    $0x2,%eax
  103e50:	01 d0                	add    %edx,%eax
  103e52:	c1 e0 02             	shl    $0x2,%eax
  103e55:	01 c8                	add    %ecx,%eax
  103e57:	83 c0 04             	add    $0x4,%eax
  103e5a:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  103e61:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103e64:	8b 45 90             	mov    -0x70(%ebp),%eax
  103e67:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103e6a:	0f ab 10             	bts    %edx,(%eax)
}
  103e6d:	90                   	nop
    for (i = 0; i < npage; i ++) {
  103e6e:	ff 45 dc             	incl   -0x24(%ebp)
  103e71:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e74:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  103e79:	39 c2                	cmp    %eax,%edx
  103e7b:	72 c5                	jb     103e42 <page_init+0x1ba>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103e7d:	8b 15 a4 be 11 00    	mov    0x11bea4,%edx
  103e83:	89 d0                	mov    %edx,%eax
  103e85:	c1 e0 02             	shl    $0x2,%eax
  103e88:	01 d0                	add    %edx,%eax
  103e8a:	c1 e0 02             	shl    $0x2,%eax
  103e8d:	89 c2                	mov    %eax,%edx
  103e8f:	a1 a0 be 11 00       	mov    0x11bea0,%eax
  103e94:	01 d0                	add    %edx,%eax
  103e96:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e99:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  103ea0:	77 23                	ja     103ec5 <page_init+0x23d>
  103ea2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ea5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ea9:	c7 44 24 08 a8 67 10 	movl   $0x1067a8,0x8(%esp)
  103eb0:	00 
  103eb1:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103eb8:	00 
  103eb9:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  103ec0:	e8 5e cd ff ff       	call   100c23 <__panic>
  103ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ec8:	05 00 00 00 40       	add    $0x40000000,%eax
  103ecd:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103ed0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ed7:	e9 53 01 00 00       	jmp    10402f <page_init+0x3a7>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103edc:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103edf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ee2:	89 d0                	mov    %edx,%eax
  103ee4:	c1 e0 02             	shl    $0x2,%eax
  103ee7:	01 d0                	add    %edx,%eax
  103ee9:	c1 e0 02             	shl    $0x2,%eax
  103eec:	01 c8                	add    %ecx,%eax
  103eee:	8b 50 08             	mov    0x8(%eax),%edx
  103ef1:	8b 40 04             	mov    0x4(%eax),%eax
  103ef4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103ef7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103efa:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103efd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f00:	89 d0                	mov    %edx,%eax
  103f02:	c1 e0 02             	shl    $0x2,%eax
  103f05:	01 d0                	add    %edx,%eax
  103f07:	c1 e0 02             	shl    $0x2,%eax
  103f0a:	01 c8                	add    %ecx,%eax
  103f0c:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f0f:	8b 58 10             	mov    0x10(%eax),%ebx
  103f12:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f15:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f18:	01 c8                	add    %ecx,%eax
  103f1a:	11 da                	adc    %ebx,%edx
  103f1c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103f1f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103f22:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f25:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f28:	89 d0                	mov    %edx,%eax
  103f2a:	c1 e0 02             	shl    $0x2,%eax
  103f2d:	01 d0                	add    %edx,%eax
  103f2f:	c1 e0 02             	shl    $0x2,%eax
  103f32:	01 c8                	add    %ecx,%eax
  103f34:	83 c0 14             	add    $0x14,%eax
  103f37:	8b 00                	mov    (%eax),%eax
  103f39:	83 f8 01             	cmp    $0x1,%eax
  103f3c:	0f 85 ea 00 00 00    	jne    10402c <page_init+0x3a4>
            if (begin < freemem) {
  103f42:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103f45:	ba 00 00 00 00       	mov    $0x0,%edx
  103f4a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103f4d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103f50:	19 d1                	sbb    %edx,%ecx
  103f52:	73 0d                	jae    103f61 <page_init+0x2d9>
                begin = freemem;
  103f54:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103f57:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103f5a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103f61:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103f66:	b8 00 00 00 00       	mov    $0x0,%eax
  103f6b:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  103f6e:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103f71:	73 0e                	jae    103f81 <page_init+0x2f9>
                end = KMEMSIZE;
  103f73:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103f7a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103f81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f87:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103f8a:	89 d0                	mov    %edx,%eax
  103f8c:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103f8f:	0f 83 97 00 00 00    	jae    10402c <page_init+0x3a4>
                begin = ROUNDUP(begin, PGSIZE);
  103f95:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  103f9c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103f9f:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103fa2:	01 d0                	add    %edx,%eax
  103fa4:	48                   	dec    %eax
  103fa5:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103fa8:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103fab:	ba 00 00 00 00       	mov    $0x0,%edx
  103fb0:	f7 75 b0             	divl   -0x50(%ebp)
  103fb3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103fb6:	29 d0                	sub    %edx,%eax
  103fb8:	ba 00 00 00 00       	mov    $0x0,%edx
  103fbd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fc0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103fc3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103fc6:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103fc9:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103fcc:	ba 00 00 00 00       	mov    $0x0,%edx
  103fd1:	89 c7                	mov    %eax,%edi
  103fd3:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  103fd9:	89 7d 80             	mov    %edi,-0x80(%ebp)
  103fdc:	89 d0                	mov    %edx,%eax
  103fde:	83 e0 00             	and    $0x0,%eax
  103fe1:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103fe4:	8b 45 80             	mov    -0x80(%ebp),%eax
  103fe7:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103fea:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103fed:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  103ff0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103ff3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103ff6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103ff9:	89 d0                	mov    %edx,%eax
  103ffb:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103ffe:	73 2c                	jae    10402c <page_init+0x3a4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104000:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104003:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104006:	2b 45 d0             	sub    -0x30(%ebp),%eax
  104009:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  10400c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104010:	c1 ea 0c             	shr    $0xc,%edx
  104013:	89 c3                	mov    %eax,%ebx
  104015:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104018:	89 04 24             	mov    %eax,(%esp)
  10401b:	e8 c9 f8 ff ff       	call   1038e9 <pa2page>
  104020:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104024:	89 04 24             	mov    %eax,(%esp)
  104027:	e8 9e fb ff ff       	call   103bca <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10402c:	ff 45 dc             	incl   -0x24(%ebp)
  10402f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104032:	8b 00                	mov    (%eax),%eax
  104034:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104037:	0f 8c 9f fe ff ff    	jl     103edc <page_init+0x254>
                }
            }
        }
    }
}
  10403d:	90                   	nop
  10403e:	90                   	nop
  10403f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104045:	5b                   	pop    %ebx
  104046:	5e                   	pop    %esi
  104047:	5f                   	pop    %edi
  104048:	5d                   	pop    %ebp
  104049:	c3                   	ret    

0010404a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10404a:	55                   	push   %ebp
  10404b:	89 e5                	mov    %esp,%ebp
  10404d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104050:	8b 45 0c             	mov    0xc(%ebp),%eax
  104053:	33 45 14             	xor    0x14(%ebp),%eax
  104056:	25 ff 0f 00 00       	and    $0xfff,%eax
  10405b:	85 c0                	test   %eax,%eax
  10405d:	74 24                	je     104083 <boot_map_segment+0x39>
  10405f:	c7 44 24 0c da 67 10 	movl   $0x1067da,0xc(%esp)
  104066:	00 
  104067:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10406e:	00 
  10406f:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104076:	00 
  104077:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10407e:	e8 a0 cb ff ff       	call   100c23 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104083:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10408a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10408d:	25 ff 0f 00 00       	and    $0xfff,%eax
  104092:	89 c2                	mov    %eax,%edx
  104094:	8b 45 10             	mov    0x10(%ebp),%eax
  104097:	01 c2                	add    %eax,%edx
  104099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10409c:	01 d0                	add    %edx,%eax
  10409e:	48                   	dec    %eax
  10409f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1040a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040a5:	ba 00 00 00 00       	mov    $0x0,%edx
  1040aa:	f7 75 f0             	divl   -0x10(%ebp)
  1040ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040b0:	29 d0                	sub    %edx,%eax
  1040b2:	c1 e8 0c             	shr    $0xc,%eax
  1040b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1040b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1040bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1040be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1040c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1040c6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1040c9:	8b 45 14             	mov    0x14(%ebp),%eax
  1040cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1040cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1040d7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1040da:	eb 68                	jmp    104144 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1040dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1040e3:	00 
  1040e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1040e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1040eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1040ee:	89 04 24             	mov    %eax,(%esp)
  1040f1:	e8 88 01 00 00       	call   10427e <get_pte>
  1040f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1040f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1040fd:	75 24                	jne    104123 <boot_map_segment+0xd9>
  1040ff:	c7 44 24 0c 06 68 10 	movl   $0x106806,0xc(%esp)
  104106:	00 
  104107:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10410e:	00 
  10410f:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104116:	00 
  104117:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10411e:	e8 00 cb ff ff       	call   100c23 <__panic>
        *ptep = pa | PTE_P | perm;
  104123:	8b 45 14             	mov    0x14(%ebp),%eax
  104126:	0b 45 18             	or     0x18(%ebp),%eax
  104129:	83 c8 01             	or     $0x1,%eax
  10412c:	89 c2                	mov    %eax,%edx
  10412e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104131:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104133:	ff 4d f4             	decl   -0xc(%ebp)
  104136:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10413d:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104144:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104148:	75 92                	jne    1040dc <boot_map_segment+0x92>
    }
}
  10414a:	90                   	nop
  10414b:	90                   	nop
  10414c:	89 ec                	mov    %ebp,%esp
  10414e:	5d                   	pop    %ebp
  10414f:	c3                   	ret    

00104150 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104150:	55                   	push   %ebp
  104151:	89 e5                	mov    %esp,%ebp
  104153:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104156:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10415d:	e8 8a fa ff ff       	call   103bec <alloc_pages>
  104162:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104169:	75 1c                	jne    104187 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10416b:	c7 44 24 08 13 68 10 	movl   $0x106813,0x8(%esp)
  104172:	00 
  104173:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10417a:	00 
  10417b:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104182:	e8 9c ca ff ff       	call   100c23 <__panic>
    }
    return page2kva(p);
  104187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10418a:	89 04 24             	mov    %eax,(%esp)
  10418d:	e8 a8 f7 ff ff       	call   10393a <page2kva>
}
  104192:	89 ec                	mov    %ebp,%esp
  104194:	5d                   	pop    %ebp
  104195:	c3                   	ret    

00104196 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104196:	55                   	push   %ebp
  104197:	89 e5                	mov    %esp,%ebp
  104199:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10419c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1041a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1041a4:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1041ab:	77 23                	ja     1041d0 <pmm_init+0x3a>
  1041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1041b4:	c7 44 24 08 a8 67 10 	movl   $0x1067a8,0x8(%esp)
  1041bb:	00 
  1041bc:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1041c3:	00 
  1041c4:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1041cb:	e8 53 ca ff ff       	call   100c23 <__panic>
  1041d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1041d3:	05 00 00 00 40       	add    $0x40000000,%eax
  1041d8:	a3 a8 be 11 00       	mov    %eax,0x11bea8
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1041dd:	e8 b2 f9 ff ff       	call   103b94 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1041e2:	e8 a1 fa ff ff       	call   103c88 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1041e7:	e8 5a 02 00 00       	call   104446 <check_alloc_page>

    check_pgdir();
  1041ec:	e8 76 02 00 00       	call   104467 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1041f1:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1041f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1041f9:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104200:	77 23                	ja     104225 <pmm_init+0x8f>
  104202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104205:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104209:	c7 44 24 08 a8 67 10 	movl   $0x1067a8,0x8(%esp)
  104210:	00 
  104211:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104218:	00 
  104219:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104220:	e8 fe c9 ff ff       	call   100c23 <__panic>
  104225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104228:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  10422e:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104233:	05 ac 0f 00 00       	add    $0xfac,%eax
  104238:	83 ca 03             	or     $0x3,%edx
  10423b:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10423d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104242:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104249:	00 
  10424a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104251:	00 
  104252:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104259:	38 
  10425a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104261:	c0 
  104262:	89 04 24             	mov    %eax,(%esp)
  104265:	e8 e0 fd ff ff       	call   10404a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10426a:	e8 39 f8 ff ff       	call   103aa8 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10426f:	e8 91 08 00 00       	call   104b05 <check_boot_pgdir>

    print_pgdir();
  104274:	e8 0e 0d 00 00       	call   104f87 <print_pgdir>

}
  104279:	90                   	nop
  10427a:	89 ec                	mov    %ebp,%esp
  10427c:	5d                   	pop    %ebp
  10427d:	c3                   	ret    

0010427e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10427e:	55                   	push   %ebp
  10427f:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  104281:	90                   	nop
  104282:	5d                   	pop    %ebp
  104283:	c3                   	ret    

00104284 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104284:	55                   	push   %ebp
  104285:	89 e5                	mov    %esp,%ebp
  104287:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10428a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104291:	00 
  104292:	8b 45 0c             	mov    0xc(%ebp),%eax
  104295:	89 44 24 04          	mov    %eax,0x4(%esp)
  104299:	8b 45 08             	mov    0x8(%ebp),%eax
  10429c:	89 04 24             	mov    %eax,(%esp)
  10429f:	e8 da ff ff ff       	call   10427e <get_pte>
  1042a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1042a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1042ab:	74 08                	je     1042b5 <get_page+0x31>
        *ptep_store = ptep;
  1042ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1042b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1042b3:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1042b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042b9:	74 1b                	je     1042d6 <get_page+0x52>
  1042bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042be:	8b 00                	mov    (%eax),%eax
  1042c0:	83 e0 01             	and    $0x1,%eax
  1042c3:	85 c0                	test   %eax,%eax
  1042c5:	74 0f                	je     1042d6 <get_page+0x52>
        return pte2page(*ptep);
  1042c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042ca:	8b 00                	mov    (%eax),%eax
  1042cc:	89 04 24             	mov    %eax,(%esp)
  1042cf:	e8 bc f6 ff ff       	call   103990 <pte2page>
  1042d4:	eb 05                	jmp    1042db <get_page+0x57>
    }
    return NULL;
  1042d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1042db:	89 ec                	mov    %ebp,%esp
  1042dd:	5d                   	pop    %ebp
  1042de:	c3                   	ret    

001042df <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1042df:	55                   	push   %ebp
  1042e0:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1042e2:	90                   	nop
  1042e3:	5d                   	pop    %ebp
  1042e4:	c3                   	ret    

001042e5 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1042e5:	55                   	push   %ebp
  1042e6:	89 e5                	mov    %esp,%ebp
  1042e8:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1042eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1042f2:	00 
  1042f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1042fd:	89 04 24             	mov    %eax,(%esp)
  104300:	e8 79 ff ff ff       	call   10427e <get_pte>
  104305:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104308:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10430c:	74 19                	je     104327 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10430e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104311:	89 44 24 08          	mov    %eax,0x8(%esp)
  104315:	8b 45 0c             	mov    0xc(%ebp),%eax
  104318:	89 44 24 04          	mov    %eax,0x4(%esp)
  10431c:	8b 45 08             	mov    0x8(%ebp),%eax
  10431f:	89 04 24             	mov    %eax,(%esp)
  104322:	e8 b8 ff ff ff       	call   1042df <page_remove_pte>
    }
}
  104327:	90                   	nop
  104328:	89 ec                	mov    %ebp,%esp
  10432a:	5d                   	pop    %ebp
  10432b:	c3                   	ret    

0010432c <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10432c:	55                   	push   %ebp
  10432d:	89 e5                	mov    %esp,%ebp
  10432f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104332:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104339:	00 
  10433a:	8b 45 10             	mov    0x10(%ebp),%eax
  10433d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104341:	8b 45 08             	mov    0x8(%ebp),%eax
  104344:	89 04 24             	mov    %eax,(%esp)
  104347:	e8 32 ff ff ff       	call   10427e <get_pte>
  10434c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10434f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104353:	75 0a                	jne    10435f <page_insert+0x33>
        return -E_NO_MEM;
  104355:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10435a:	e9 84 00 00 00       	jmp    1043e3 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10435f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104362:	89 04 24             	mov    %eax,(%esp)
  104365:	e8 8a f6 ff ff       	call   1039f4 <page_ref_inc>
    if (*ptep & PTE_P) {
  10436a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10436d:	8b 00                	mov    (%eax),%eax
  10436f:	83 e0 01             	and    $0x1,%eax
  104372:	85 c0                	test   %eax,%eax
  104374:	74 3e                	je     1043b4 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104379:	8b 00                	mov    (%eax),%eax
  10437b:	89 04 24             	mov    %eax,(%esp)
  10437e:	e8 0d f6 ff ff       	call   103990 <pte2page>
  104383:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104386:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104389:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10438c:	75 0d                	jne    10439b <page_insert+0x6f>
            page_ref_dec(page);
  10438e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104391:	89 04 24             	mov    %eax,(%esp)
  104394:	e8 72 f6 ff ff       	call   103a0b <page_ref_dec>
  104399:	eb 19                	jmp    1043b4 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10439b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439e:	89 44 24 08          	mov    %eax,0x8(%esp)
  1043a2:	8b 45 10             	mov    0x10(%ebp),%eax
  1043a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1043ac:	89 04 24             	mov    %eax,(%esp)
  1043af:	e8 2b ff ff ff       	call   1042df <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1043b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043b7:	89 04 24             	mov    %eax,(%esp)
  1043ba:	e8 12 f5 ff ff       	call   1038d1 <page2pa>
  1043bf:	0b 45 14             	or     0x14(%ebp),%eax
  1043c2:	83 c8 01             	or     $0x1,%eax
  1043c5:	89 c2                	mov    %eax,%edx
  1043c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1043ca:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1043cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1043cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1043d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1043d6:	89 04 24             	mov    %eax,(%esp)
  1043d9:	e8 09 00 00 00       	call   1043e7 <tlb_invalidate>
    return 0;
  1043de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1043e3:	89 ec                	mov    %ebp,%esp
  1043e5:	5d                   	pop    %ebp
  1043e6:	c3                   	ret    

001043e7 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1043e7:	55                   	push   %ebp
  1043e8:	89 e5                	mov    %esp,%ebp
  1043ea:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1043ed:	0f 20 d8             	mov    %cr3,%eax
  1043f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1043f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  1043f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1043f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1043fc:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104403:	77 23                	ja     104428 <tlb_invalidate+0x41>
  104405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104408:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10440c:	c7 44 24 08 a8 67 10 	movl   $0x1067a8,0x8(%esp)
  104413:	00 
  104414:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  10441b:	00 
  10441c:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104423:	e8 fb c7 ff ff       	call   100c23 <__panic>
  104428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10442b:	05 00 00 00 40       	add    $0x40000000,%eax
  104430:	39 d0                	cmp    %edx,%eax
  104432:	75 0d                	jne    104441 <tlb_invalidate+0x5a>
        invlpg((void *)la);
  104434:	8b 45 0c             	mov    0xc(%ebp),%eax
  104437:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10443a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10443d:	0f 01 38             	invlpg (%eax)
}
  104440:	90                   	nop
    }
}
  104441:	90                   	nop
  104442:	89 ec                	mov    %ebp,%esp
  104444:	5d                   	pop    %ebp
  104445:	c3                   	ret    

00104446 <check_alloc_page>:

static void
check_alloc_page(void) {
  104446:	55                   	push   %ebp
  104447:	89 e5                	mov    %esp,%ebp
  104449:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10444c:	a1 ac be 11 00       	mov    0x11beac,%eax
  104451:	8b 40 18             	mov    0x18(%eax),%eax
  104454:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104456:	c7 04 24 2c 68 10 00 	movl   $0x10682c,(%esp)
  10445d:	e8 f4 be ff ff       	call   100356 <cprintf>
}
  104462:	90                   	nop
  104463:	89 ec                	mov    %ebp,%esp
  104465:	5d                   	pop    %ebp
  104466:	c3                   	ret    

00104467 <check_pgdir>:

static void
check_pgdir(void) {
  104467:	55                   	push   %ebp
  104468:	89 e5                	mov    %esp,%ebp
  10446a:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10446d:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104472:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104477:	76 24                	jbe    10449d <check_pgdir+0x36>
  104479:	c7 44 24 0c 4b 68 10 	movl   $0x10684b,0xc(%esp)
  104480:	00 
  104481:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104488:	00 
  104489:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  104490:	00 
  104491:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104498:	e8 86 c7 ff ff       	call   100c23 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10449d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1044a2:	85 c0                	test   %eax,%eax
  1044a4:	74 0e                	je     1044b4 <check_pgdir+0x4d>
  1044a6:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1044ab:	25 ff 0f 00 00       	and    $0xfff,%eax
  1044b0:	85 c0                	test   %eax,%eax
  1044b2:	74 24                	je     1044d8 <check_pgdir+0x71>
  1044b4:	c7 44 24 0c 68 68 10 	movl   $0x106868,0xc(%esp)
  1044bb:	00 
  1044bc:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1044c3:	00 
  1044c4:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  1044cb:	00 
  1044cc:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1044d3:	e8 4b c7 ff ff       	call   100c23 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1044d8:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1044dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044e4:	00 
  1044e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044ec:	00 
  1044ed:	89 04 24             	mov    %eax,(%esp)
  1044f0:	e8 8f fd ff ff       	call   104284 <get_page>
  1044f5:	85 c0                	test   %eax,%eax
  1044f7:	74 24                	je     10451d <check_pgdir+0xb6>
  1044f9:	c7 44 24 0c a0 68 10 	movl   $0x1068a0,0xc(%esp)
  104500:	00 
  104501:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104508:	00 
  104509:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  104510:	00 
  104511:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104518:	e8 06 c7 ff ff       	call   100c23 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10451d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104524:	e8 c3 f6 ff ff       	call   103bec <alloc_pages>
  104529:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10452c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104531:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104538:	00 
  104539:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104540:	00 
  104541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104544:	89 54 24 04          	mov    %edx,0x4(%esp)
  104548:	89 04 24             	mov    %eax,(%esp)
  10454b:	e8 dc fd ff ff       	call   10432c <page_insert>
  104550:	85 c0                	test   %eax,%eax
  104552:	74 24                	je     104578 <check_pgdir+0x111>
  104554:	c7 44 24 0c c8 68 10 	movl   $0x1068c8,0xc(%esp)
  10455b:	00 
  10455c:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104563:	00 
  104564:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  10456b:	00 
  10456c:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104573:	e8 ab c6 ff ff       	call   100c23 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104578:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  10457d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104584:	00 
  104585:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10458c:	00 
  10458d:	89 04 24             	mov    %eax,(%esp)
  104590:	e8 e9 fc ff ff       	call   10427e <get_pte>
  104595:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104598:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10459c:	75 24                	jne    1045c2 <check_pgdir+0x15b>
  10459e:	c7 44 24 0c f4 68 10 	movl   $0x1068f4,0xc(%esp)
  1045a5:	00 
  1045a6:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1045ad:	00 
  1045ae:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  1045b5:	00 
  1045b6:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1045bd:	e8 61 c6 ff ff       	call   100c23 <__panic>
    assert(pte2page(*ptep) == p1);
  1045c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045c5:	8b 00                	mov    (%eax),%eax
  1045c7:	89 04 24             	mov    %eax,(%esp)
  1045ca:	e8 c1 f3 ff ff       	call   103990 <pte2page>
  1045cf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1045d2:	74 24                	je     1045f8 <check_pgdir+0x191>
  1045d4:	c7 44 24 0c 21 69 10 	movl   $0x106921,0xc(%esp)
  1045db:	00 
  1045dc:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1045e3:	00 
  1045e4:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  1045eb:	00 
  1045ec:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1045f3:	e8 2b c6 ff ff       	call   100c23 <__panic>
    assert(page_ref(p1) == 1);
  1045f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045fb:	89 04 24             	mov    %eax,(%esp)
  1045fe:	e8 e7 f3 ff ff       	call   1039ea <page_ref>
  104603:	83 f8 01             	cmp    $0x1,%eax
  104606:	74 24                	je     10462c <check_pgdir+0x1c5>
  104608:	c7 44 24 0c 37 69 10 	movl   $0x106937,0xc(%esp)
  10460f:	00 
  104610:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104617:	00 
  104618:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  10461f:	00 
  104620:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104627:	e8 f7 c5 ff ff       	call   100c23 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10462c:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104631:	8b 00                	mov    (%eax),%eax
  104633:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104638:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10463b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10463e:	c1 e8 0c             	shr    $0xc,%eax
  104641:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104644:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104649:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10464c:	72 23                	jb     104671 <check_pgdir+0x20a>
  10464e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104651:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104655:	c7 44 24 08 04 67 10 	movl   $0x106704,0x8(%esp)
  10465c:	00 
  10465d:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  104664:	00 
  104665:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10466c:	e8 b2 c5 ff ff       	call   100c23 <__panic>
  104671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104674:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104679:	83 c0 04             	add    $0x4,%eax
  10467c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  10467f:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104684:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10468b:	00 
  10468c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104693:	00 
  104694:	89 04 24             	mov    %eax,(%esp)
  104697:	e8 e2 fb ff ff       	call   10427e <get_pte>
  10469c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10469f:	74 24                	je     1046c5 <check_pgdir+0x25e>
  1046a1:	c7 44 24 0c 4c 69 10 	movl   $0x10694c,0xc(%esp)
  1046a8:	00 
  1046a9:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1046b0:	00 
  1046b1:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  1046b8:	00 
  1046b9:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1046c0:	e8 5e c5 ff ff       	call   100c23 <__panic>

    p2 = alloc_page();
  1046c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046cc:	e8 1b f5 ff ff       	call   103bec <alloc_pages>
  1046d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1046d4:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1046d9:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  1046e0:	00 
  1046e1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1046e8:	00 
  1046e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1046ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046f0:	89 04 24             	mov    %eax,(%esp)
  1046f3:	e8 34 fc ff ff       	call   10432c <page_insert>
  1046f8:	85 c0                	test   %eax,%eax
  1046fa:	74 24                	je     104720 <check_pgdir+0x2b9>
  1046fc:	c7 44 24 0c 74 69 10 	movl   $0x106974,0xc(%esp)
  104703:	00 
  104704:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10470b:	00 
  10470c:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  104713:	00 
  104714:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10471b:	e8 03 c5 ff ff       	call   100c23 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104720:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104725:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10472c:	00 
  10472d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104734:	00 
  104735:	89 04 24             	mov    %eax,(%esp)
  104738:	e8 41 fb ff ff       	call   10427e <get_pte>
  10473d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104740:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104744:	75 24                	jne    10476a <check_pgdir+0x303>
  104746:	c7 44 24 0c ac 69 10 	movl   $0x1069ac,0xc(%esp)
  10474d:	00 
  10474e:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104755:	00 
  104756:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  10475d:	00 
  10475e:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104765:	e8 b9 c4 ff ff       	call   100c23 <__panic>
    assert(*ptep & PTE_U);
  10476a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10476d:	8b 00                	mov    (%eax),%eax
  10476f:	83 e0 04             	and    $0x4,%eax
  104772:	85 c0                	test   %eax,%eax
  104774:	75 24                	jne    10479a <check_pgdir+0x333>
  104776:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  10477d:	00 
  10477e:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104785:	00 
  104786:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  10478d:	00 
  10478e:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104795:	e8 89 c4 ff ff       	call   100c23 <__panic>
    assert(*ptep & PTE_W);
  10479a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10479d:	8b 00                	mov    (%eax),%eax
  10479f:	83 e0 02             	and    $0x2,%eax
  1047a2:	85 c0                	test   %eax,%eax
  1047a4:	75 24                	jne    1047ca <check_pgdir+0x363>
  1047a6:	c7 44 24 0c ea 69 10 	movl   $0x1069ea,0xc(%esp)
  1047ad:	00 
  1047ae:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1047b5:	00 
  1047b6:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  1047bd:	00 
  1047be:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1047c5:	e8 59 c4 ff ff       	call   100c23 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  1047ca:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1047cf:	8b 00                	mov    (%eax),%eax
  1047d1:	83 e0 04             	and    $0x4,%eax
  1047d4:	85 c0                	test   %eax,%eax
  1047d6:	75 24                	jne    1047fc <check_pgdir+0x395>
  1047d8:	c7 44 24 0c f8 69 10 	movl   $0x1069f8,0xc(%esp)
  1047df:	00 
  1047e0:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1047e7:	00 
  1047e8:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1047ef:	00 
  1047f0:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1047f7:	e8 27 c4 ff ff       	call   100c23 <__panic>
    assert(page_ref(p2) == 1);
  1047fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1047ff:	89 04 24             	mov    %eax,(%esp)
  104802:	e8 e3 f1 ff ff       	call   1039ea <page_ref>
  104807:	83 f8 01             	cmp    $0x1,%eax
  10480a:	74 24                	je     104830 <check_pgdir+0x3c9>
  10480c:	c7 44 24 0c 0e 6a 10 	movl   $0x106a0e,0xc(%esp)
  104813:	00 
  104814:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10481b:	00 
  10481c:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104823:	00 
  104824:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10482b:	e8 f3 c3 ff ff       	call   100c23 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104830:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104835:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10483c:	00 
  10483d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104844:	00 
  104845:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104848:	89 54 24 04          	mov    %edx,0x4(%esp)
  10484c:	89 04 24             	mov    %eax,(%esp)
  10484f:	e8 d8 fa ff ff       	call   10432c <page_insert>
  104854:	85 c0                	test   %eax,%eax
  104856:	74 24                	je     10487c <check_pgdir+0x415>
  104858:	c7 44 24 0c 20 6a 10 	movl   $0x106a20,0xc(%esp)
  10485f:	00 
  104860:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104867:	00 
  104868:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  10486f:	00 
  104870:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104877:	e8 a7 c3 ff ff       	call   100c23 <__panic>
    assert(page_ref(p1) == 2);
  10487c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10487f:	89 04 24             	mov    %eax,(%esp)
  104882:	e8 63 f1 ff ff       	call   1039ea <page_ref>
  104887:	83 f8 02             	cmp    $0x2,%eax
  10488a:	74 24                	je     1048b0 <check_pgdir+0x449>
  10488c:	c7 44 24 0c 4c 6a 10 	movl   $0x106a4c,0xc(%esp)
  104893:	00 
  104894:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10489b:	00 
  10489c:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  1048a3:	00 
  1048a4:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1048ab:	e8 73 c3 ff ff       	call   100c23 <__panic>
    assert(page_ref(p2) == 0);
  1048b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1048b3:	89 04 24             	mov    %eax,(%esp)
  1048b6:	e8 2f f1 ff ff       	call   1039ea <page_ref>
  1048bb:	85 c0                	test   %eax,%eax
  1048bd:	74 24                	je     1048e3 <check_pgdir+0x47c>
  1048bf:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  1048c6:	00 
  1048c7:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1048ce:	00 
  1048cf:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  1048d6:	00 
  1048d7:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1048de:	e8 40 c3 ff ff       	call   100c23 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1048e3:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  1048e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048ef:	00 
  1048f0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1048f7:	00 
  1048f8:	89 04 24             	mov    %eax,(%esp)
  1048fb:	e8 7e f9 ff ff       	call   10427e <get_pte>
  104900:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104907:	75 24                	jne    10492d <check_pgdir+0x4c6>
  104909:	c7 44 24 0c ac 69 10 	movl   $0x1069ac,0xc(%esp)
  104910:	00 
  104911:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104918:	00 
  104919:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104920:	00 
  104921:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104928:	e8 f6 c2 ff ff       	call   100c23 <__panic>
    assert(pte2page(*ptep) == p1);
  10492d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104930:	8b 00                	mov    (%eax),%eax
  104932:	89 04 24             	mov    %eax,(%esp)
  104935:	e8 56 f0 ff ff       	call   103990 <pte2page>
  10493a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10493d:	74 24                	je     104963 <check_pgdir+0x4fc>
  10493f:	c7 44 24 0c 21 69 10 	movl   $0x106921,0xc(%esp)
  104946:	00 
  104947:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10494e:	00 
  10494f:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104956:	00 
  104957:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10495e:	e8 c0 c2 ff ff       	call   100c23 <__panic>
    assert((*ptep & PTE_U) == 0);
  104963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104966:	8b 00                	mov    (%eax),%eax
  104968:	83 e0 04             	and    $0x4,%eax
  10496b:	85 c0                	test   %eax,%eax
  10496d:	74 24                	je     104993 <check_pgdir+0x52c>
  10496f:	c7 44 24 0c 70 6a 10 	movl   $0x106a70,0xc(%esp)
  104976:	00 
  104977:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  10497e:	00 
  10497f:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104986:	00 
  104987:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  10498e:	e8 90 c2 ff ff       	call   100c23 <__panic>

    page_remove(boot_pgdir, 0x0);
  104993:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104998:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10499f:	00 
  1049a0:	89 04 24             	mov    %eax,(%esp)
  1049a3:	e8 3d f9 ff ff       	call   1042e5 <page_remove>
    assert(page_ref(p1) == 1);
  1049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049ab:	89 04 24             	mov    %eax,(%esp)
  1049ae:	e8 37 f0 ff ff       	call   1039ea <page_ref>
  1049b3:	83 f8 01             	cmp    $0x1,%eax
  1049b6:	74 24                	je     1049dc <check_pgdir+0x575>
  1049b8:	c7 44 24 0c 37 69 10 	movl   $0x106937,0xc(%esp)
  1049bf:	00 
  1049c0:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1049c7:	00 
  1049c8:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  1049cf:	00 
  1049d0:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  1049d7:	e8 47 c2 ff ff       	call   100c23 <__panic>
    assert(page_ref(p2) == 0);
  1049dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049df:	89 04 24             	mov    %eax,(%esp)
  1049e2:	e8 03 f0 ff ff       	call   1039ea <page_ref>
  1049e7:	85 c0                	test   %eax,%eax
  1049e9:	74 24                	je     104a0f <check_pgdir+0x5a8>
  1049eb:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  1049f2:	00 
  1049f3:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  1049fa:	00 
  1049fb:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104a02:	00 
  104a03:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104a0a:	e8 14 c2 ff ff       	call   100c23 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104a0f:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a14:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a1b:	00 
  104a1c:	89 04 24             	mov    %eax,(%esp)
  104a1f:	e8 c1 f8 ff ff       	call   1042e5 <page_remove>
    assert(page_ref(p1) == 0);
  104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a27:	89 04 24             	mov    %eax,(%esp)
  104a2a:	e8 bb ef ff ff       	call   1039ea <page_ref>
  104a2f:	85 c0                	test   %eax,%eax
  104a31:	74 24                	je     104a57 <check_pgdir+0x5f0>
  104a33:	c7 44 24 0c 85 6a 10 	movl   $0x106a85,0xc(%esp)
  104a3a:	00 
  104a3b:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104a42:	00 
  104a43:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104a4a:	00 
  104a4b:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104a52:	e8 cc c1 ff ff       	call   100c23 <__panic>
    assert(page_ref(p2) == 0);
  104a57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a5a:	89 04 24             	mov    %eax,(%esp)
  104a5d:	e8 88 ef ff ff       	call   1039ea <page_ref>
  104a62:	85 c0                	test   %eax,%eax
  104a64:	74 24                	je     104a8a <check_pgdir+0x623>
  104a66:	c7 44 24 0c 5e 6a 10 	movl   $0x106a5e,0xc(%esp)
  104a6d:	00 
  104a6e:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104a75:	00 
  104a76:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104a7d:	00 
  104a7e:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104a85:	e8 99 c1 ff ff       	call   100c23 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104a8a:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104a8f:	8b 00                	mov    (%eax),%eax
  104a91:	89 04 24             	mov    %eax,(%esp)
  104a94:	e8 37 ef ff ff       	call   1039d0 <pde2page>
  104a99:	89 04 24             	mov    %eax,(%esp)
  104a9c:	e8 49 ef ff ff       	call   1039ea <page_ref>
  104aa1:	83 f8 01             	cmp    $0x1,%eax
  104aa4:	74 24                	je     104aca <check_pgdir+0x663>
  104aa6:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  104aad:	00 
  104aae:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104ab5:	00 
  104ab6:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104abd:	00 
  104abe:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104ac5:	e8 59 c1 ff ff       	call   100c23 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104aca:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104acf:	8b 00                	mov    (%eax),%eax
  104ad1:	89 04 24             	mov    %eax,(%esp)
  104ad4:	e8 f7 ee ff ff       	call   1039d0 <pde2page>
  104ad9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ae0:	00 
  104ae1:	89 04 24             	mov    %eax,(%esp)
  104ae4:	e8 3d f1 ff ff       	call   103c26 <free_pages>
    boot_pgdir[0] = 0;
  104ae9:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104af4:	c7 04 24 bf 6a 10 00 	movl   $0x106abf,(%esp)
  104afb:	e8 56 b8 ff ff       	call   100356 <cprintf>
}
  104b00:	90                   	nop
  104b01:	89 ec                	mov    %ebp,%esp
  104b03:	5d                   	pop    %ebp
  104b04:	c3                   	ret    

00104b05 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104b05:	55                   	push   %ebp
  104b06:	89 e5                	mov    %esp,%ebp
  104b08:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104b12:	e9 ca 00 00 00       	jmp    104be1 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104b1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b20:	c1 e8 0c             	shr    $0xc,%eax
  104b23:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104b26:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104b2b:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104b2e:	72 23                	jb     104b53 <check_boot_pgdir+0x4e>
  104b30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b37:	c7 44 24 08 04 67 10 	movl   $0x106704,0x8(%esp)
  104b3e:	00 
  104b3f:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104b46:	00 
  104b47:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104b4e:	e8 d0 c0 ff ff       	call   100c23 <__panic>
  104b53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b56:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104b5b:	89 c2                	mov    %eax,%edx
  104b5d:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104b62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b69:	00 
  104b6a:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b6e:	89 04 24             	mov    %eax,(%esp)
  104b71:	e8 08 f7 ff ff       	call   10427e <get_pte>
  104b76:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104b79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  104b7d:	75 24                	jne    104ba3 <check_boot_pgdir+0x9e>
  104b7f:	c7 44 24 0c dc 6a 10 	movl   $0x106adc,0xc(%esp)
  104b86:	00 
  104b87:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104b8e:	00 
  104b8f:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104b96:	00 
  104b97:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104b9e:	e8 80 c0 ff ff       	call   100c23 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104ba3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104ba6:	8b 00                	mov    (%eax),%eax
  104ba8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104bad:	89 c2                	mov    %eax,%edx
  104baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bb2:	39 c2                	cmp    %eax,%edx
  104bb4:	74 24                	je     104bda <check_boot_pgdir+0xd5>
  104bb6:	c7 44 24 0c 19 6b 10 	movl   $0x106b19,0xc(%esp)
  104bbd:	00 
  104bbe:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104bc5:	00 
  104bc6:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104bcd:	00 
  104bce:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104bd5:	e8 49 c0 ff ff       	call   100c23 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  104bda:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104be1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104be4:	a1 a4 be 11 00       	mov    0x11bea4,%eax
  104be9:	39 c2                	cmp    %eax,%edx
  104beb:	0f 82 26 ff ff ff    	jb     104b17 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104bf1:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104bf6:	05 ac 0f 00 00       	add    $0xfac,%eax
  104bfb:	8b 00                	mov    (%eax),%eax
  104bfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104c02:	89 c2                	mov    %eax,%edx
  104c04:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c0c:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104c13:	77 23                	ja     104c38 <check_boot_pgdir+0x133>
  104c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c18:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104c1c:	c7 44 24 08 a8 67 10 	movl   $0x1067a8,0x8(%esp)
  104c23:	00 
  104c24:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104c2b:	00 
  104c2c:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104c33:	e8 eb bf ff ff       	call   100c23 <__panic>
  104c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c3b:	05 00 00 00 40       	add    $0x40000000,%eax
  104c40:	39 d0                	cmp    %edx,%eax
  104c42:	74 24                	je     104c68 <check_boot_pgdir+0x163>
  104c44:	c7 44 24 0c 30 6b 10 	movl   $0x106b30,0xc(%esp)
  104c4b:	00 
  104c4c:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104c53:	00 
  104c54:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104c5b:	00 
  104c5c:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104c63:	e8 bb bf ff ff       	call   100c23 <__panic>

    assert(boot_pgdir[0] == 0);
  104c68:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104c6d:	8b 00                	mov    (%eax),%eax
  104c6f:	85 c0                	test   %eax,%eax
  104c71:	74 24                	je     104c97 <check_boot_pgdir+0x192>
  104c73:	c7 44 24 0c 64 6b 10 	movl   $0x106b64,0xc(%esp)
  104c7a:	00 
  104c7b:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104c82:	00 
  104c83:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104c8a:	00 
  104c8b:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104c92:	e8 8c bf ff ff       	call   100c23 <__panic>

    struct Page *p;
    p = alloc_page();
  104c97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c9e:	e8 49 ef ff ff       	call   103bec <alloc_pages>
  104ca3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104ca6:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104cab:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104cb2:	00 
  104cb3:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104cba:	00 
  104cbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104cbe:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cc2:	89 04 24             	mov    %eax,(%esp)
  104cc5:	e8 62 f6 ff ff       	call   10432c <page_insert>
  104cca:	85 c0                	test   %eax,%eax
  104ccc:	74 24                	je     104cf2 <check_boot_pgdir+0x1ed>
  104cce:	c7 44 24 0c 78 6b 10 	movl   $0x106b78,0xc(%esp)
  104cd5:	00 
  104cd6:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104cdd:	00 
  104cde:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104ce5:	00 
  104ce6:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104ced:	e8 31 bf ff ff       	call   100c23 <__panic>
    assert(page_ref(p) == 1);
  104cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cf5:	89 04 24             	mov    %eax,(%esp)
  104cf8:	e8 ed ec ff ff       	call   1039ea <page_ref>
  104cfd:	83 f8 01             	cmp    $0x1,%eax
  104d00:	74 24                	je     104d26 <check_boot_pgdir+0x221>
  104d02:	c7 44 24 0c a6 6b 10 	movl   $0x106ba6,0xc(%esp)
  104d09:	00 
  104d0a:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104d11:	00 
  104d12:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104d19:	00 
  104d1a:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104d21:	e8 fd be ff ff       	call   100c23 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104d26:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104d2b:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104d32:	00 
  104d33:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104d3a:	00 
  104d3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104d3e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d42:	89 04 24             	mov    %eax,(%esp)
  104d45:	e8 e2 f5 ff ff       	call   10432c <page_insert>
  104d4a:	85 c0                	test   %eax,%eax
  104d4c:	74 24                	je     104d72 <check_boot_pgdir+0x26d>
  104d4e:	c7 44 24 0c b8 6b 10 	movl   $0x106bb8,0xc(%esp)
  104d55:	00 
  104d56:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104d5d:	00 
  104d5e:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104d65:	00 
  104d66:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104d6d:	e8 b1 be ff ff       	call   100c23 <__panic>
    assert(page_ref(p) == 2);
  104d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d75:	89 04 24             	mov    %eax,(%esp)
  104d78:	e8 6d ec ff ff       	call   1039ea <page_ref>
  104d7d:	83 f8 02             	cmp    $0x2,%eax
  104d80:	74 24                	je     104da6 <check_boot_pgdir+0x2a1>
  104d82:	c7 44 24 0c ef 6b 10 	movl   $0x106bef,0xc(%esp)
  104d89:	00 
  104d8a:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104d91:	00 
  104d92:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104d99:	00 
  104d9a:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104da1:	e8 7d be ff ff       	call   100c23 <__panic>

    const char *str = "ucore: Hello world!!";
  104da6:	c7 45 e8 00 6c 10 00 	movl   $0x106c00,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104db0:	89 44 24 04          	mov    %eax,0x4(%esp)
  104db4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104dbb:	e8 fc 09 00 00       	call   1057bc <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104dc0:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104dc7:	00 
  104dc8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104dcf:	e8 60 0a 00 00       	call   105834 <strcmp>
  104dd4:	85 c0                	test   %eax,%eax
  104dd6:	74 24                	je     104dfc <check_boot_pgdir+0x2f7>
  104dd8:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  104ddf:	00 
  104de0:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104de7:	00 
  104de8:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104def:	00 
  104df0:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104df7:	e8 27 be ff ff       	call   100c23 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104dff:	89 04 24             	mov    %eax,(%esp)
  104e02:	e8 33 eb ff ff       	call   10393a <page2kva>
  104e07:	05 00 01 00 00       	add    $0x100,%eax
  104e0c:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104e0f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104e16:	e8 47 09 00 00       	call   105762 <strlen>
  104e1b:	85 c0                	test   %eax,%eax
  104e1d:	74 24                	je     104e43 <check_boot_pgdir+0x33e>
  104e1f:	c7 44 24 0c 50 6c 10 	movl   $0x106c50,0xc(%esp)
  104e26:	00 
  104e27:	c7 44 24 08 f1 67 10 	movl   $0x1067f1,0x8(%esp)
  104e2e:	00 
  104e2f:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104e36:	00 
  104e37:	c7 04 24 cc 67 10 00 	movl   $0x1067cc,(%esp)
  104e3e:	e8 e0 bd ff ff       	call   100c23 <__panic>

    free_page(p);
  104e43:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e4a:	00 
  104e4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e4e:	89 04 24             	mov    %eax,(%esp)
  104e51:	e8 d0 ed ff ff       	call   103c26 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104e56:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e5b:	8b 00                	mov    (%eax),%eax
  104e5d:	89 04 24             	mov    %eax,(%esp)
  104e60:	e8 6b eb ff ff       	call   1039d0 <pde2page>
  104e65:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e6c:	00 
  104e6d:	89 04 24             	mov    %eax,(%esp)
  104e70:	e8 b1 ed ff ff       	call   103c26 <free_pages>
    boot_pgdir[0] = 0;
  104e75:	a1 e0 89 11 00       	mov    0x1189e0,%eax
  104e7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104e80:	c7 04 24 74 6c 10 00 	movl   $0x106c74,(%esp)
  104e87:	e8 ca b4 ff ff       	call   100356 <cprintf>
}
  104e8c:	90                   	nop
  104e8d:	89 ec                	mov    %ebp,%esp
  104e8f:	5d                   	pop    %ebp
  104e90:	c3                   	ret    

00104e91 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104e91:	55                   	push   %ebp
  104e92:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104e94:	8b 45 08             	mov    0x8(%ebp),%eax
  104e97:	83 e0 04             	and    $0x4,%eax
  104e9a:	85 c0                	test   %eax,%eax
  104e9c:	74 04                	je     104ea2 <perm2str+0x11>
  104e9e:	b0 75                	mov    $0x75,%al
  104ea0:	eb 02                	jmp    104ea4 <perm2str+0x13>
  104ea2:	b0 2d                	mov    $0x2d,%al
  104ea4:	a2 28 bf 11 00       	mov    %al,0x11bf28
    str[1] = 'r';
  104ea9:	c6 05 29 bf 11 00 72 	movb   $0x72,0x11bf29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  104eb3:	83 e0 02             	and    $0x2,%eax
  104eb6:	85 c0                	test   %eax,%eax
  104eb8:	74 04                	je     104ebe <perm2str+0x2d>
  104eba:	b0 77                	mov    $0x77,%al
  104ebc:	eb 02                	jmp    104ec0 <perm2str+0x2f>
  104ebe:	b0 2d                	mov    $0x2d,%al
  104ec0:	a2 2a bf 11 00       	mov    %al,0x11bf2a
    str[3] = '\0';
  104ec5:	c6 05 2b bf 11 00 00 	movb   $0x0,0x11bf2b
    return str;
  104ecc:	b8 28 bf 11 00       	mov    $0x11bf28,%eax
}
  104ed1:	5d                   	pop    %ebp
  104ed2:	c3                   	ret    

00104ed3 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104ed3:	55                   	push   %ebp
  104ed4:	89 e5                	mov    %esp,%ebp
  104ed6:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  104edc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104edf:	72 0d                	jb     104eee <get_pgtable_items+0x1b>
        return 0;
  104ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  104ee6:	e9 98 00 00 00       	jmp    104f83 <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104eeb:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104eee:	8b 45 10             	mov    0x10(%ebp),%eax
  104ef1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104ef4:	73 18                	jae    104f0e <get_pgtable_items+0x3b>
  104ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  104ef9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104f00:	8b 45 14             	mov    0x14(%ebp),%eax
  104f03:	01 d0                	add    %edx,%eax
  104f05:	8b 00                	mov    (%eax),%eax
  104f07:	83 e0 01             	and    $0x1,%eax
  104f0a:	85 c0                	test   %eax,%eax
  104f0c:	74 dd                	je     104eeb <get_pgtable_items+0x18>
    }
    if (start < right) {
  104f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  104f11:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104f14:	73 68                	jae    104f7e <get_pgtable_items+0xab>
        if (left_store != NULL) {
  104f16:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104f1a:	74 08                	je     104f24 <get_pgtable_items+0x51>
            *left_store = start;
  104f1c:	8b 45 18             	mov    0x18(%ebp),%eax
  104f1f:	8b 55 10             	mov    0x10(%ebp),%edx
  104f22:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104f24:	8b 45 10             	mov    0x10(%ebp),%eax
  104f27:	8d 50 01             	lea    0x1(%eax),%edx
  104f2a:	89 55 10             	mov    %edx,0x10(%ebp)
  104f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104f34:	8b 45 14             	mov    0x14(%ebp),%eax
  104f37:	01 d0                	add    %edx,%eax
  104f39:	8b 00                	mov    (%eax),%eax
  104f3b:	83 e0 07             	and    $0x7,%eax
  104f3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104f41:	eb 03                	jmp    104f46 <get_pgtable_items+0x73>
            start ++;
  104f43:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104f46:	8b 45 10             	mov    0x10(%ebp),%eax
  104f49:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104f4c:	73 1d                	jae    104f6b <get_pgtable_items+0x98>
  104f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  104f51:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104f58:	8b 45 14             	mov    0x14(%ebp),%eax
  104f5b:	01 d0                	add    %edx,%eax
  104f5d:	8b 00                	mov    (%eax),%eax
  104f5f:	83 e0 07             	and    $0x7,%eax
  104f62:	89 c2                	mov    %eax,%edx
  104f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104f67:	39 c2                	cmp    %eax,%edx
  104f69:	74 d8                	je     104f43 <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  104f6b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104f6f:	74 08                	je     104f79 <get_pgtable_items+0xa6>
            *right_store = start;
  104f71:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104f74:	8b 55 10             	mov    0x10(%ebp),%edx
  104f77:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104f79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104f7c:	eb 05                	jmp    104f83 <get_pgtable_items+0xb0>
    }
    return 0;
  104f7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104f83:	89 ec                	mov    %ebp,%esp
  104f85:	5d                   	pop    %ebp
  104f86:	c3                   	ret    

00104f87 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104f87:	55                   	push   %ebp
  104f88:	89 e5                	mov    %esp,%ebp
  104f8a:	57                   	push   %edi
  104f8b:	56                   	push   %esi
  104f8c:	53                   	push   %ebx
  104f8d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104f90:	c7 04 24 94 6c 10 00 	movl   $0x106c94,(%esp)
  104f97:	e8 ba b3 ff ff       	call   100356 <cprintf>
    size_t left, right = 0, perm;
  104f9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104fa3:	e9 f2 00 00 00       	jmp    10509a <print_pgdir+0x113>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fab:	89 04 24             	mov    %eax,(%esp)
  104fae:	e8 de fe ff ff       	call   104e91 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104fb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104fb6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  104fb9:	29 ca                	sub    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104fbb:	89 d6                	mov    %edx,%esi
  104fbd:	c1 e6 16             	shl    $0x16,%esi
  104fc0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104fc3:	89 d3                	mov    %edx,%ebx
  104fc5:	c1 e3 16             	shl    $0x16,%ebx
  104fc8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fcb:	89 d1                	mov    %edx,%ecx
  104fcd:	c1 e1 16             	shl    $0x16,%ecx
  104fd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104fd3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  104fd6:	29 fa                	sub    %edi,%edx
  104fd8:	89 44 24 14          	mov    %eax,0x14(%esp)
  104fdc:	89 74 24 10          	mov    %esi,0x10(%esp)
  104fe0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104fe4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104fe8:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fec:	c7 04 24 c5 6c 10 00 	movl   $0x106cc5,(%esp)
  104ff3:	e8 5e b3 ff ff       	call   100356 <cprintf>
        size_t l, r = left * NPTEENTRY;
  104ff8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ffb:	c1 e0 0a             	shl    $0xa,%eax
  104ffe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105001:	eb 50                	jmp    105053 <print_pgdir+0xcc>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105003:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105006:	89 04 24             	mov    %eax,(%esp)
  105009:	e8 83 fe ff ff       	call   104e91 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10500e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105011:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  105014:	29 ca                	sub    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105016:	89 d6                	mov    %edx,%esi
  105018:	c1 e6 0c             	shl    $0xc,%esi
  10501b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10501e:	89 d3                	mov    %edx,%ebx
  105020:	c1 e3 0c             	shl    $0xc,%ebx
  105023:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105026:	89 d1                	mov    %edx,%ecx
  105028:	c1 e1 0c             	shl    $0xc,%ecx
  10502b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10502e:	8b 7d d8             	mov    -0x28(%ebp),%edi
  105031:	29 fa                	sub    %edi,%edx
  105033:	89 44 24 14          	mov    %eax,0x14(%esp)
  105037:	89 74 24 10          	mov    %esi,0x10(%esp)
  10503b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10503f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105043:	89 54 24 04          	mov    %edx,0x4(%esp)
  105047:	c7 04 24 e4 6c 10 00 	movl   $0x106ce4,(%esp)
  10504e:	e8 03 b3 ff ff       	call   100356 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105053:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  105058:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10505b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10505e:	89 d3                	mov    %edx,%ebx
  105060:	c1 e3 0a             	shl    $0xa,%ebx
  105063:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105066:	89 d1                	mov    %edx,%ecx
  105068:	c1 e1 0a             	shl    $0xa,%ecx
  10506b:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  10506e:	89 54 24 14          	mov    %edx,0x14(%esp)
  105072:	8d 55 d8             	lea    -0x28(%ebp),%edx
  105075:	89 54 24 10          	mov    %edx,0x10(%esp)
  105079:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10507d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105081:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  105085:	89 0c 24             	mov    %ecx,(%esp)
  105088:	e8 46 fe ff ff       	call   104ed3 <get_pgtable_items>
  10508d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105090:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105094:	0f 85 69 ff ff ff    	jne    105003 <print_pgdir+0x7c>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10509a:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  10509f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050a2:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1050a5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1050a9:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1050ac:	89 54 24 10          	mov    %edx,0x10(%esp)
  1050b0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1050b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1050b8:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1050bf:	00 
  1050c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1050c7:	e8 07 fe ff ff       	call   104ed3 <get_pgtable_items>
  1050cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1050cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1050d3:	0f 85 cf fe ff ff    	jne    104fa8 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1050d9:	c7 04 24 08 6d 10 00 	movl   $0x106d08,(%esp)
  1050e0:	e8 71 b2 ff ff       	call   100356 <cprintf>
}
  1050e5:	90                   	nop
  1050e6:	83 c4 4c             	add    $0x4c,%esp
  1050e9:	5b                   	pop    %ebx
  1050ea:	5e                   	pop    %esi
  1050eb:	5f                   	pop    %edi
  1050ec:	5d                   	pop    %ebp
  1050ed:	c3                   	ret    

001050ee <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1050ee:	55                   	push   %ebp
  1050ef:	89 e5                	mov    %esp,%ebp
  1050f1:	83 ec 58             	sub    $0x58,%esp
  1050f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1050f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1050fa:	8b 45 14             	mov    0x14(%ebp),%eax
  1050fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105100:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105103:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105106:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105109:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10510c:	8b 45 18             	mov    0x18(%ebp),%eax
  10510f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105112:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105115:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105118:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10511b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10511e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105128:	74 1c                	je     105146 <printnum+0x58>
  10512a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10512d:	ba 00 00 00 00       	mov    $0x0,%edx
  105132:	f7 75 e4             	divl   -0x1c(%ebp)
  105135:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10513b:	ba 00 00 00 00       	mov    $0x0,%edx
  105140:	f7 75 e4             	divl   -0x1c(%ebp)
  105143:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10514c:	f7 75 e4             	divl   -0x1c(%ebp)
  10514f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105152:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105155:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105158:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10515b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10515e:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105164:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105167:	8b 45 18             	mov    0x18(%ebp),%eax
  10516a:	ba 00 00 00 00       	mov    $0x0,%edx
  10516f:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105172:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105175:	19 d1                	sbb    %edx,%ecx
  105177:	72 4c                	jb     1051c5 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  105179:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10517c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10517f:	8b 45 20             	mov    0x20(%ebp),%eax
  105182:	89 44 24 18          	mov    %eax,0x18(%esp)
  105186:	89 54 24 14          	mov    %edx,0x14(%esp)
  10518a:	8b 45 18             	mov    0x18(%ebp),%eax
  10518d:	89 44 24 10          	mov    %eax,0x10(%esp)
  105191:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105194:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105197:	89 44 24 08          	mov    %eax,0x8(%esp)
  10519b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10519f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a9:	89 04 24             	mov    %eax,(%esp)
  1051ac:	e8 3d ff ff ff       	call   1050ee <printnum>
  1051b1:	eb 1b                	jmp    1051ce <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1051b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1051b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1051ba:	8b 45 20             	mov    0x20(%ebp),%eax
  1051bd:	89 04 24             	mov    %eax,(%esp)
  1051c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1051c3:	ff d0                	call   *%eax
        while (-- width > 0)
  1051c5:	ff 4d 1c             	decl   0x1c(%ebp)
  1051c8:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1051cc:	7f e5                	jg     1051b3 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1051ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1051d1:	05 bc 6d 10 00       	add    $0x106dbc,%eax
  1051d6:	0f b6 00             	movzbl (%eax),%eax
  1051d9:	0f be c0             	movsbl %al,%eax
  1051dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1051df:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051e3:	89 04 24             	mov    %eax,(%esp)
  1051e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1051e9:	ff d0                	call   *%eax
}
  1051eb:	90                   	nop
  1051ec:	89 ec                	mov    %ebp,%esp
  1051ee:	5d                   	pop    %ebp
  1051ef:	c3                   	ret    

001051f0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1051f0:	55                   	push   %ebp
  1051f1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1051f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1051f7:	7e 14                	jle    10520d <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1051f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1051fc:	8b 00                	mov    (%eax),%eax
  1051fe:	8d 48 08             	lea    0x8(%eax),%ecx
  105201:	8b 55 08             	mov    0x8(%ebp),%edx
  105204:	89 0a                	mov    %ecx,(%edx)
  105206:	8b 50 04             	mov    0x4(%eax),%edx
  105209:	8b 00                	mov    (%eax),%eax
  10520b:	eb 30                	jmp    10523d <getuint+0x4d>
    }
    else if (lflag) {
  10520d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105211:	74 16                	je     105229 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105213:	8b 45 08             	mov    0x8(%ebp),%eax
  105216:	8b 00                	mov    (%eax),%eax
  105218:	8d 48 04             	lea    0x4(%eax),%ecx
  10521b:	8b 55 08             	mov    0x8(%ebp),%edx
  10521e:	89 0a                	mov    %ecx,(%edx)
  105220:	8b 00                	mov    (%eax),%eax
  105222:	ba 00 00 00 00       	mov    $0x0,%edx
  105227:	eb 14                	jmp    10523d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105229:	8b 45 08             	mov    0x8(%ebp),%eax
  10522c:	8b 00                	mov    (%eax),%eax
  10522e:	8d 48 04             	lea    0x4(%eax),%ecx
  105231:	8b 55 08             	mov    0x8(%ebp),%edx
  105234:	89 0a                	mov    %ecx,(%edx)
  105236:	8b 00                	mov    (%eax),%eax
  105238:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10523d:	5d                   	pop    %ebp
  10523e:	c3                   	ret    

0010523f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10523f:	55                   	push   %ebp
  105240:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105242:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105246:	7e 14                	jle    10525c <getint+0x1d>
        return va_arg(*ap, long long);
  105248:	8b 45 08             	mov    0x8(%ebp),%eax
  10524b:	8b 00                	mov    (%eax),%eax
  10524d:	8d 48 08             	lea    0x8(%eax),%ecx
  105250:	8b 55 08             	mov    0x8(%ebp),%edx
  105253:	89 0a                	mov    %ecx,(%edx)
  105255:	8b 50 04             	mov    0x4(%eax),%edx
  105258:	8b 00                	mov    (%eax),%eax
  10525a:	eb 28                	jmp    105284 <getint+0x45>
    }
    else if (lflag) {
  10525c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105260:	74 12                	je     105274 <getint+0x35>
        return va_arg(*ap, long);
  105262:	8b 45 08             	mov    0x8(%ebp),%eax
  105265:	8b 00                	mov    (%eax),%eax
  105267:	8d 48 04             	lea    0x4(%eax),%ecx
  10526a:	8b 55 08             	mov    0x8(%ebp),%edx
  10526d:	89 0a                	mov    %ecx,(%edx)
  10526f:	8b 00                	mov    (%eax),%eax
  105271:	99                   	cltd   
  105272:	eb 10                	jmp    105284 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105274:	8b 45 08             	mov    0x8(%ebp),%eax
  105277:	8b 00                	mov    (%eax),%eax
  105279:	8d 48 04             	lea    0x4(%eax),%ecx
  10527c:	8b 55 08             	mov    0x8(%ebp),%edx
  10527f:	89 0a                	mov    %ecx,(%edx)
  105281:	8b 00                	mov    (%eax),%eax
  105283:	99                   	cltd   
    }
}
  105284:	5d                   	pop    %ebp
  105285:	c3                   	ret    

00105286 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105286:	55                   	push   %ebp
  105287:	89 e5                	mov    %esp,%ebp
  105289:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10528c:	8d 45 14             	lea    0x14(%ebp),%eax
  10528f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105295:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105299:	8b 45 10             	mov    0x10(%ebp),%eax
  10529c:	89 44 24 08          	mov    %eax,0x8(%esp)
  1052a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1052aa:	89 04 24             	mov    %eax,(%esp)
  1052ad:	e8 05 00 00 00       	call   1052b7 <vprintfmt>
    va_end(ap);
}
  1052b2:	90                   	nop
  1052b3:	89 ec                	mov    %ebp,%esp
  1052b5:	5d                   	pop    %ebp
  1052b6:	c3                   	ret    

001052b7 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1052b7:	55                   	push   %ebp
  1052b8:	89 e5                	mov    %esp,%ebp
  1052ba:	56                   	push   %esi
  1052bb:	53                   	push   %ebx
  1052bc:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1052bf:	eb 17                	jmp    1052d8 <vprintfmt+0x21>
            if (ch == '\0') {
  1052c1:	85 db                	test   %ebx,%ebx
  1052c3:	0f 84 bf 03 00 00    	je     105688 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  1052c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1052cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1052d0:	89 1c 24             	mov    %ebx,(%esp)
  1052d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1052d6:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1052d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1052db:	8d 50 01             	lea    0x1(%eax),%edx
  1052de:	89 55 10             	mov    %edx,0x10(%ebp)
  1052e1:	0f b6 00             	movzbl (%eax),%eax
  1052e4:	0f b6 d8             	movzbl %al,%ebx
  1052e7:	83 fb 25             	cmp    $0x25,%ebx
  1052ea:	75 d5                	jne    1052c1 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1052ec:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1052f0:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1052f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1052fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105304:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105307:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10530a:	8b 45 10             	mov    0x10(%ebp),%eax
  10530d:	8d 50 01             	lea    0x1(%eax),%edx
  105310:	89 55 10             	mov    %edx,0x10(%ebp)
  105313:	0f b6 00             	movzbl (%eax),%eax
  105316:	0f b6 d8             	movzbl %al,%ebx
  105319:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10531c:	83 f8 55             	cmp    $0x55,%eax
  10531f:	0f 87 37 03 00 00    	ja     10565c <vprintfmt+0x3a5>
  105325:	8b 04 85 e0 6d 10 00 	mov    0x106de0(,%eax,4),%eax
  10532c:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10532e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105332:	eb d6                	jmp    10530a <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105334:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105338:	eb d0                	jmp    10530a <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10533a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105341:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105344:	89 d0                	mov    %edx,%eax
  105346:	c1 e0 02             	shl    $0x2,%eax
  105349:	01 d0                	add    %edx,%eax
  10534b:	01 c0                	add    %eax,%eax
  10534d:	01 d8                	add    %ebx,%eax
  10534f:	83 e8 30             	sub    $0x30,%eax
  105352:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105355:	8b 45 10             	mov    0x10(%ebp),%eax
  105358:	0f b6 00             	movzbl (%eax),%eax
  10535b:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10535e:	83 fb 2f             	cmp    $0x2f,%ebx
  105361:	7e 38                	jle    10539b <vprintfmt+0xe4>
  105363:	83 fb 39             	cmp    $0x39,%ebx
  105366:	7f 33                	jg     10539b <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105368:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  10536b:	eb d4                	jmp    105341 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10536d:	8b 45 14             	mov    0x14(%ebp),%eax
  105370:	8d 50 04             	lea    0x4(%eax),%edx
  105373:	89 55 14             	mov    %edx,0x14(%ebp)
  105376:	8b 00                	mov    (%eax),%eax
  105378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10537b:	eb 1f                	jmp    10539c <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  10537d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105381:	79 87                	jns    10530a <vprintfmt+0x53>
                width = 0;
  105383:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10538a:	e9 7b ff ff ff       	jmp    10530a <vprintfmt+0x53>

        case '#':
            altflag = 1;
  10538f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105396:	e9 6f ff ff ff       	jmp    10530a <vprintfmt+0x53>
            goto process_precision;
  10539b:	90                   	nop

        process_precision:
            if (width < 0)
  10539c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1053a0:	0f 89 64 ff ff ff    	jns    10530a <vprintfmt+0x53>
                width = precision, precision = -1;
  1053a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053ac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1053b3:	e9 52 ff ff ff       	jmp    10530a <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1053b8:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1053bb:	e9 4a ff ff ff       	jmp    10530a <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1053c0:	8b 45 14             	mov    0x14(%ebp),%eax
  1053c3:	8d 50 04             	lea    0x4(%eax),%edx
  1053c6:	89 55 14             	mov    %edx,0x14(%ebp)
  1053c9:	8b 00                	mov    (%eax),%eax
  1053cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053d2:	89 04 24             	mov    %eax,(%esp)
  1053d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d8:	ff d0                	call   *%eax
            break;
  1053da:	e9 a4 02 00 00       	jmp    105683 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1053df:	8b 45 14             	mov    0x14(%ebp),%eax
  1053e2:	8d 50 04             	lea    0x4(%eax),%edx
  1053e5:	89 55 14             	mov    %edx,0x14(%ebp)
  1053e8:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1053ea:	85 db                	test   %ebx,%ebx
  1053ec:	79 02                	jns    1053f0 <vprintfmt+0x139>
                err = -err;
  1053ee:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1053f0:	83 fb 06             	cmp    $0x6,%ebx
  1053f3:	7f 0b                	jg     105400 <vprintfmt+0x149>
  1053f5:	8b 34 9d a0 6d 10 00 	mov    0x106da0(,%ebx,4),%esi
  1053fc:	85 f6                	test   %esi,%esi
  1053fe:	75 23                	jne    105423 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105400:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105404:	c7 44 24 08 cd 6d 10 	movl   $0x106dcd,0x8(%esp)
  10540b:	00 
  10540c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10540f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105413:	8b 45 08             	mov    0x8(%ebp),%eax
  105416:	89 04 24             	mov    %eax,(%esp)
  105419:	e8 68 fe ff ff       	call   105286 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10541e:	e9 60 02 00 00       	jmp    105683 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105423:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105427:	c7 44 24 08 d6 6d 10 	movl   $0x106dd6,0x8(%esp)
  10542e:	00 
  10542f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105432:	89 44 24 04          	mov    %eax,0x4(%esp)
  105436:	8b 45 08             	mov    0x8(%ebp),%eax
  105439:	89 04 24             	mov    %eax,(%esp)
  10543c:	e8 45 fe ff ff       	call   105286 <printfmt>
            break;
  105441:	e9 3d 02 00 00       	jmp    105683 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105446:	8b 45 14             	mov    0x14(%ebp),%eax
  105449:	8d 50 04             	lea    0x4(%eax),%edx
  10544c:	89 55 14             	mov    %edx,0x14(%ebp)
  10544f:	8b 30                	mov    (%eax),%esi
  105451:	85 f6                	test   %esi,%esi
  105453:	75 05                	jne    10545a <vprintfmt+0x1a3>
                p = "(null)";
  105455:	be d9 6d 10 00       	mov    $0x106dd9,%esi
            }
            if (width > 0 && padc != '-') {
  10545a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10545e:	7e 76                	jle    1054d6 <vprintfmt+0x21f>
  105460:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105464:	74 70                	je     1054d6 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105466:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105469:	89 44 24 04          	mov    %eax,0x4(%esp)
  10546d:	89 34 24             	mov    %esi,(%esp)
  105470:	e8 16 03 00 00       	call   10578b <strnlen>
  105475:	89 c2                	mov    %eax,%edx
  105477:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10547a:	29 d0                	sub    %edx,%eax
  10547c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10547f:	eb 16                	jmp    105497 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  105481:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105485:	8b 55 0c             	mov    0xc(%ebp),%edx
  105488:	89 54 24 04          	mov    %edx,0x4(%esp)
  10548c:	89 04 24             	mov    %eax,(%esp)
  10548f:	8b 45 08             	mov    0x8(%ebp),%eax
  105492:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105494:	ff 4d e8             	decl   -0x18(%ebp)
  105497:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10549b:	7f e4                	jg     105481 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10549d:	eb 37                	jmp    1054d6 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  10549f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1054a3:	74 1f                	je     1054c4 <vprintfmt+0x20d>
  1054a5:	83 fb 1f             	cmp    $0x1f,%ebx
  1054a8:	7e 05                	jle    1054af <vprintfmt+0x1f8>
  1054aa:	83 fb 7e             	cmp    $0x7e,%ebx
  1054ad:	7e 15                	jle    1054c4 <vprintfmt+0x20d>
                    putch('?', putdat);
  1054af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054b6:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1054bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1054c0:	ff d0                	call   *%eax
  1054c2:	eb 0f                	jmp    1054d3 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  1054c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054cb:	89 1c 24             	mov    %ebx,(%esp)
  1054ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1054d1:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1054d3:	ff 4d e8             	decl   -0x18(%ebp)
  1054d6:	89 f0                	mov    %esi,%eax
  1054d8:	8d 70 01             	lea    0x1(%eax),%esi
  1054db:	0f b6 00             	movzbl (%eax),%eax
  1054de:	0f be d8             	movsbl %al,%ebx
  1054e1:	85 db                	test   %ebx,%ebx
  1054e3:	74 27                	je     10550c <vprintfmt+0x255>
  1054e5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054e9:	78 b4                	js     10549f <vprintfmt+0x1e8>
  1054eb:	ff 4d e4             	decl   -0x1c(%ebp)
  1054ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1054f2:	79 ab                	jns    10549f <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1054f4:	eb 16                	jmp    10550c <vprintfmt+0x255>
                putch(' ', putdat);
  1054f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054fd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105504:	8b 45 08             	mov    0x8(%ebp),%eax
  105507:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105509:	ff 4d e8             	decl   -0x18(%ebp)
  10550c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105510:	7f e4                	jg     1054f6 <vprintfmt+0x23f>
            }
            break;
  105512:	e9 6c 01 00 00       	jmp    105683 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10551a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10551e:	8d 45 14             	lea    0x14(%ebp),%eax
  105521:	89 04 24             	mov    %eax,(%esp)
  105524:	e8 16 fd ff ff       	call   10523f <getint>
  105529:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10552c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  10552f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105535:	85 d2                	test   %edx,%edx
  105537:	79 26                	jns    10555f <vprintfmt+0x2a8>
                putch('-', putdat);
  105539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10553c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105540:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105547:	8b 45 08             	mov    0x8(%ebp),%eax
  10554a:	ff d0                	call   *%eax
                num = -(long long)num;
  10554c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10554f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105552:	f7 d8                	neg    %eax
  105554:	83 d2 00             	adc    $0x0,%edx
  105557:	f7 da                	neg    %edx
  105559:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10555c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  10555f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105566:	e9 a8 00 00 00       	jmp    105613 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10556b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10556e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105572:	8d 45 14             	lea    0x14(%ebp),%eax
  105575:	89 04 24             	mov    %eax,(%esp)
  105578:	e8 73 fc ff ff       	call   1051f0 <getuint>
  10557d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105580:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105583:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10558a:	e9 84 00 00 00       	jmp    105613 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10558f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105592:	89 44 24 04          	mov    %eax,0x4(%esp)
  105596:	8d 45 14             	lea    0x14(%ebp),%eax
  105599:	89 04 24             	mov    %eax,(%esp)
  10559c:	e8 4f fc ff ff       	call   1051f0 <getuint>
  1055a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1055a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1055a7:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1055ae:	eb 63                	jmp    105613 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  1055b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055b7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1055be:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c1:	ff d0                	call   *%eax
            putch('x', putdat);
  1055c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055ca:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1055d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d4:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1055d6:	8b 45 14             	mov    0x14(%ebp),%eax
  1055d9:	8d 50 04             	lea    0x4(%eax),%edx
  1055dc:	89 55 14             	mov    %edx,0x14(%ebp)
  1055df:	8b 00                	mov    (%eax),%eax
  1055e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1055e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1055eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1055f2:	eb 1f                	jmp    105613 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1055f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055fb:	8d 45 14             	lea    0x14(%ebp),%eax
  1055fe:	89 04 24             	mov    %eax,(%esp)
  105601:	e8 ea fb ff ff       	call   1051f0 <getuint>
  105606:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105609:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10560c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105613:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10561a:	89 54 24 18          	mov    %edx,0x18(%esp)
  10561e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105621:	89 54 24 14          	mov    %edx,0x14(%esp)
  105625:	89 44 24 10          	mov    %eax,0x10(%esp)
  105629:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10562c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10562f:	89 44 24 08          	mov    %eax,0x8(%esp)
  105633:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10563a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10563e:	8b 45 08             	mov    0x8(%ebp),%eax
  105641:	89 04 24             	mov    %eax,(%esp)
  105644:	e8 a5 fa ff ff       	call   1050ee <printnum>
            break;
  105649:	eb 38                	jmp    105683 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10564b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10564e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105652:	89 1c 24             	mov    %ebx,(%esp)
  105655:	8b 45 08             	mov    0x8(%ebp),%eax
  105658:	ff d0                	call   *%eax
            break;
  10565a:	eb 27                	jmp    105683 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10565c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10565f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105663:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10566a:	8b 45 08             	mov    0x8(%ebp),%eax
  10566d:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10566f:	ff 4d 10             	decl   0x10(%ebp)
  105672:	eb 03                	jmp    105677 <vprintfmt+0x3c0>
  105674:	ff 4d 10             	decl   0x10(%ebp)
  105677:	8b 45 10             	mov    0x10(%ebp),%eax
  10567a:	48                   	dec    %eax
  10567b:	0f b6 00             	movzbl (%eax),%eax
  10567e:	3c 25                	cmp    $0x25,%al
  105680:	75 f2                	jne    105674 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105682:	90                   	nop
    while (1) {
  105683:	e9 37 fc ff ff       	jmp    1052bf <vprintfmt+0x8>
                return;
  105688:	90                   	nop
        }
    }
}
  105689:	83 c4 40             	add    $0x40,%esp
  10568c:	5b                   	pop    %ebx
  10568d:	5e                   	pop    %esi
  10568e:	5d                   	pop    %ebp
  10568f:	c3                   	ret    

00105690 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105690:	55                   	push   %ebp
  105691:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105693:	8b 45 0c             	mov    0xc(%ebp),%eax
  105696:	8b 40 08             	mov    0x8(%eax),%eax
  105699:	8d 50 01             	lea    0x1(%eax),%edx
  10569c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10569f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1056a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a5:	8b 10                	mov    (%eax),%edx
  1056a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056aa:	8b 40 04             	mov    0x4(%eax),%eax
  1056ad:	39 c2                	cmp    %eax,%edx
  1056af:	73 12                	jae    1056c3 <sprintputch+0x33>
        *b->buf ++ = ch;
  1056b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056b4:	8b 00                	mov    (%eax),%eax
  1056b6:	8d 48 01             	lea    0x1(%eax),%ecx
  1056b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056bc:	89 0a                	mov    %ecx,(%edx)
  1056be:	8b 55 08             	mov    0x8(%ebp),%edx
  1056c1:	88 10                	mov    %dl,(%eax)
    }
}
  1056c3:	90                   	nop
  1056c4:	5d                   	pop    %ebp
  1056c5:	c3                   	ret    

001056c6 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1056c6:	55                   	push   %ebp
  1056c7:	89 e5                	mov    %esp,%ebp
  1056c9:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1056cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1056cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1056d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1056dc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ea:	89 04 24             	mov    %eax,(%esp)
  1056ed:	e8 0a 00 00 00       	call   1056fc <vsnprintf>
  1056f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1056f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1056f8:	89 ec                	mov    %ebp,%esp
  1056fa:	5d                   	pop    %ebp
  1056fb:	c3                   	ret    

001056fc <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1056fc:	55                   	push   %ebp
  1056fd:	89 e5                	mov    %esp,%ebp
  1056ff:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105702:	8b 45 08             	mov    0x8(%ebp),%eax
  105705:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105708:	8b 45 0c             	mov    0xc(%ebp),%eax
  10570b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10570e:	8b 45 08             	mov    0x8(%ebp),%eax
  105711:	01 d0                	add    %edx,%eax
  105713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10571d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105721:	74 0a                	je     10572d <vsnprintf+0x31>
  105723:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105726:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105729:	39 c2                	cmp    %eax,%edx
  10572b:	76 07                	jbe    105734 <vsnprintf+0x38>
        return -E_INVAL;
  10572d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105732:	eb 2a                	jmp    10575e <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105734:	8b 45 14             	mov    0x14(%ebp),%eax
  105737:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10573b:	8b 45 10             	mov    0x10(%ebp),%eax
  10573e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105742:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105745:	89 44 24 04          	mov    %eax,0x4(%esp)
  105749:	c7 04 24 90 56 10 00 	movl   $0x105690,(%esp)
  105750:	e8 62 fb ff ff       	call   1052b7 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105755:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105758:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10575b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10575e:	89 ec                	mov    %ebp,%esp
  105760:	5d                   	pop    %ebp
  105761:	c3                   	ret    

00105762 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105762:	55                   	push   %ebp
  105763:	89 e5                	mov    %esp,%ebp
  105765:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10576f:	eb 03                	jmp    105774 <strlen+0x12>
        cnt ++;
  105771:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  105774:	8b 45 08             	mov    0x8(%ebp),%eax
  105777:	8d 50 01             	lea    0x1(%eax),%edx
  10577a:	89 55 08             	mov    %edx,0x8(%ebp)
  10577d:	0f b6 00             	movzbl (%eax),%eax
  105780:	84 c0                	test   %al,%al
  105782:	75 ed                	jne    105771 <strlen+0xf>
    }
    return cnt;
  105784:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105787:	89 ec                	mov    %ebp,%esp
  105789:	5d                   	pop    %ebp
  10578a:	c3                   	ret    

0010578b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10578b:	55                   	push   %ebp
  10578c:	89 e5                	mov    %esp,%ebp
  10578e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105791:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105798:	eb 03                	jmp    10579d <strnlen+0x12>
        cnt ++;
  10579a:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10579d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1057a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1057a3:	73 10                	jae    1057b5 <strnlen+0x2a>
  1057a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a8:	8d 50 01             	lea    0x1(%eax),%edx
  1057ab:	89 55 08             	mov    %edx,0x8(%ebp)
  1057ae:	0f b6 00             	movzbl (%eax),%eax
  1057b1:	84 c0                	test   %al,%al
  1057b3:	75 e5                	jne    10579a <strnlen+0xf>
    }
    return cnt;
  1057b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1057b8:	89 ec                	mov    %ebp,%esp
  1057ba:	5d                   	pop    %ebp
  1057bb:	c3                   	ret    

001057bc <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1057bc:	55                   	push   %ebp
  1057bd:	89 e5                	mov    %esp,%ebp
  1057bf:	57                   	push   %edi
  1057c0:	56                   	push   %esi
  1057c1:	83 ec 20             	sub    $0x20,%esp
  1057c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1057d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1057d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1057d6:	89 d1                	mov    %edx,%ecx
  1057d8:	89 c2                	mov    %eax,%edx
  1057da:	89 ce                	mov    %ecx,%esi
  1057dc:	89 d7                	mov    %edx,%edi
  1057de:	ac                   	lods   %ds:(%esi),%al
  1057df:	aa                   	stos   %al,%es:(%edi)
  1057e0:	84 c0                	test   %al,%al
  1057e2:	75 fa                	jne    1057de <strcpy+0x22>
  1057e4:	89 fa                	mov    %edi,%edx
  1057e6:	89 f1                	mov    %esi,%ecx
  1057e8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1057eb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1057ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1057f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1057f4:	83 c4 20             	add    $0x20,%esp
  1057f7:	5e                   	pop    %esi
  1057f8:	5f                   	pop    %edi
  1057f9:	5d                   	pop    %ebp
  1057fa:	c3                   	ret    

001057fb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1057fb:	55                   	push   %ebp
  1057fc:	89 e5                	mov    %esp,%ebp
  1057fe:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105801:	8b 45 08             	mov    0x8(%ebp),%eax
  105804:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105807:	eb 1e                	jmp    105827 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580c:	0f b6 10             	movzbl (%eax),%edx
  10580f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105812:	88 10                	mov    %dl,(%eax)
  105814:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105817:	0f b6 00             	movzbl (%eax),%eax
  10581a:	84 c0                	test   %al,%al
  10581c:	74 03                	je     105821 <strncpy+0x26>
            src ++;
  10581e:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  105821:	ff 45 fc             	incl   -0x4(%ebp)
  105824:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105827:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10582b:	75 dc                	jne    105809 <strncpy+0xe>
    }
    return dst;
  10582d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105830:	89 ec                	mov    %ebp,%esp
  105832:	5d                   	pop    %ebp
  105833:	c3                   	ret    

00105834 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105834:	55                   	push   %ebp
  105835:	89 e5                	mov    %esp,%ebp
  105837:	57                   	push   %edi
  105838:	56                   	push   %esi
  105839:	83 ec 20             	sub    $0x20,%esp
  10583c:	8b 45 08             	mov    0x8(%ebp),%eax
  10583f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105842:	8b 45 0c             	mov    0xc(%ebp),%eax
  105845:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105848:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10584b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10584e:	89 d1                	mov    %edx,%ecx
  105850:	89 c2                	mov    %eax,%edx
  105852:	89 ce                	mov    %ecx,%esi
  105854:	89 d7                	mov    %edx,%edi
  105856:	ac                   	lods   %ds:(%esi),%al
  105857:	ae                   	scas   %es:(%edi),%al
  105858:	75 08                	jne    105862 <strcmp+0x2e>
  10585a:	84 c0                	test   %al,%al
  10585c:	75 f8                	jne    105856 <strcmp+0x22>
  10585e:	31 c0                	xor    %eax,%eax
  105860:	eb 04                	jmp    105866 <strcmp+0x32>
  105862:	19 c0                	sbb    %eax,%eax
  105864:	0c 01                	or     $0x1,%al
  105866:	89 fa                	mov    %edi,%edx
  105868:	89 f1                	mov    %esi,%ecx
  10586a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10586d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105870:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  105873:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105876:	83 c4 20             	add    $0x20,%esp
  105879:	5e                   	pop    %esi
  10587a:	5f                   	pop    %edi
  10587b:	5d                   	pop    %ebp
  10587c:	c3                   	ret    

0010587d <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10587d:	55                   	push   %ebp
  10587e:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105880:	eb 09                	jmp    10588b <strncmp+0xe>
        n --, s1 ++, s2 ++;
  105882:	ff 4d 10             	decl   0x10(%ebp)
  105885:	ff 45 08             	incl   0x8(%ebp)
  105888:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10588b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10588f:	74 1a                	je     1058ab <strncmp+0x2e>
  105891:	8b 45 08             	mov    0x8(%ebp),%eax
  105894:	0f b6 00             	movzbl (%eax),%eax
  105897:	84 c0                	test   %al,%al
  105899:	74 10                	je     1058ab <strncmp+0x2e>
  10589b:	8b 45 08             	mov    0x8(%ebp),%eax
  10589e:	0f b6 10             	movzbl (%eax),%edx
  1058a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a4:	0f b6 00             	movzbl (%eax),%eax
  1058a7:	38 c2                	cmp    %al,%dl
  1058a9:	74 d7                	je     105882 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1058ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1058af:	74 18                	je     1058c9 <strncmp+0x4c>
  1058b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058b4:	0f b6 00             	movzbl (%eax),%eax
  1058b7:	0f b6 d0             	movzbl %al,%edx
  1058ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058bd:	0f b6 00             	movzbl (%eax),%eax
  1058c0:	0f b6 c8             	movzbl %al,%ecx
  1058c3:	89 d0                	mov    %edx,%eax
  1058c5:	29 c8                	sub    %ecx,%eax
  1058c7:	eb 05                	jmp    1058ce <strncmp+0x51>
  1058c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1058ce:	5d                   	pop    %ebp
  1058cf:	c3                   	ret    

001058d0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1058d0:	55                   	push   %ebp
  1058d1:	89 e5                	mov    %esp,%ebp
  1058d3:	83 ec 04             	sub    $0x4,%esp
  1058d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058d9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1058dc:	eb 13                	jmp    1058f1 <strchr+0x21>
        if (*s == c) {
  1058de:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e1:	0f b6 00             	movzbl (%eax),%eax
  1058e4:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1058e7:	75 05                	jne    1058ee <strchr+0x1e>
            return (char *)s;
  1058e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ec:	eb 12                	jmp    105900 <strchr+0x30>
        }
        s ++;
  1058ee:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1058f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f4:	0f b6 00             	movzbl (%eax),%eax
  1058f7:	84 c0                	test   %al,%al
  1058f9:	75 e3                	jne    1058de <strchr+0xe>
    }
    return NULL;
  1058fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105900:	89 ec                	mov    %ebp,%esp
  105902:	5d                   	pop    %ebp
  105903:	c3                   	ret    

00105904 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105904:	55                   	push   %ebp
  105905:	89 e5                	mov    %esp,%ebp
  105907:	83 ec 04             	sub    $0x4,%esp
  10590a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10590d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105910:	eb 0e                	jmp    105920 <strfind+0x1c>
        if (*s == c) {
  105912:	8b 45 08             	mov    0x8(%ebp),%eax
  105915:	0f b6 00             	movzbl (%eax),%eax
  105918:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10591b:	74 0f                	je     10592c <strfind+0x28>
            break;
        }
        s ++;
  10591d:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105920:	8b 45 08             	mov    0x8(%ebp),%eax
  105923:	0f b6 00             	movzbl (%eax),%eax
  105926:	84 c0                	test   %al,%al
  105928:	75 e8                	jne    105912 <strfind+0xe>
  10592a:	eb 01                	jmp    10592d <strfind+0x29>
            break;
  10592c:	90                   	nop
    }
    return (char *)s;
  10592d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105930:	89 ec                	mov    %ebp,%esp
  105932:	5d                   	pop    %ebp
  105933:	c3                   	ret    

00105934 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105934:	55                   	push   %ebp
  105935:	89 e5                	mov    %esp,%ebp
  105937:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10593a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105941:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105948:	eb 03                	jmp    10594d <strtol+0x19>
        s ++;
  10594a:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  10594d:	8b 45 08             	mov    0x8(%ebp),%eax
  105950:	0f b6 00             	movzbl (%eax),%eax
  105953:	3c 20                	cmp    $0x20,%al
  105955:	74 f3                	je     10594a <strtol+0x16>
  105957:	8b 45 08             	mov    0x8(%ebp),%eax
  10595a:	0f b6 00             	movzbl (%eax),%eax
  10595d:	3c 09                	cmp    $0x9,%al
  10595f:	74 e9                	je     10594a <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105961:	8b 45 08             	mov    0x8(%ebp),%eax
  105964:	0f b6 00             	movzbl (%eax),%eax
  105967:	3c 2b                	cmp    $0x2b,%al
  105969:	75 05                	jne    105970 <strtol+0x3c>
        s ++;
  10596b:	ff 45 08             	incl   0x8(%ebp)
  10596e:	eb 14                	jmp    105984 <strtol+0x50>
    }
    else if (*s == '-') {
  105970:	8b 45 08             	mov    0x8(%ebp),%eax
  105973:	0f b6 00             	movzbl (%eax),%eax
  105976:	3c 2d                	cmp    $0x2d,%al
  105978:	75 0a                	jne    105984 <strtol+0x50>
        s ++, neg = 1;
  10597a:	ff 45 08             	incl   0x8(%ebp)
  10597d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105984:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105988:	74 06                	je     105990 <strtol+0x5c>
  10598a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10598e:	75 22                	jne    1059b2 <strtol+0x7e>
  105990:	8b 45 08             	mov    0x8(%ebp),%eax
  105993:	0f b6 00             	movzbl (%eax),%eax
  105996:	3c 30                	cmp    $0x30,%al
  105998:	75 18                	jne    1059b2 <strtol+0x7e>
  10599a:	8b 45 08             	mov    0x8(%ebp),%eax
  10599d:	40                   	inc    %eax
  10599e:	0f b6 00             	movzbl (%eax),%eax
  1059a1:	3c 78                	cmp    $0x78,%al
  1059a3:	75 0d                	jne    1059b2 <strtol+0x7e>
        s += 2, base = 16;
  1059a5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1059a9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1059b0:	eb 29                	jmp    1059db <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  1059b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059b6:	75 16                	jne    1059ce <strtol+0x9a>
  1059b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bb:	0f b6 00             	movzbl (%eax),%eax
  1059be:	3c 30                	cmp    $0x30,%al
  1059c0:	75 0c                	jne    1059ce <strtol+0x9a>
        s ++, base = 8;
  1059c2:	ff 45 08             	incl   0x8(%ebp)
  1059c5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1059cc:	eb 0d                	jmp    1059db <strtol+0xa7>
    }
    else if (base == 0) {
  1059ce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059d2:	75 07                	jne    1059db <strtol+0xa7>
        base = 10;
  1059d4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1059db:	8b 45 08             	mov    0x8(%ebp),%eax
  1059de:	0f b6 00             	movzbl (%eax),%eax
  1059e1:	3c 2f                	cmp    $0x2f,%al
  1059e3:	7e 1b                	jle    105a00 <strtol+0xcc>
  1059e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e8:	0f b6 00             	movzbl (%eax),%eax
  1059eb:	3c 39                	cmp    $0x39,%al
  1059ed:	7f 11                	jg     105a00 <strtol+0xcc>
            dig = *s - '0';
  1059ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f2:	0f b6 00             	movzbl (%eax),%eax
  1059f5:	0f be c0             	movsbl %al,%eax
  1059f8:	83 e8 30             	sub    $0x30,%eax
  1059fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059fe:	eb 48                	jmp    105a48 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105a00:	8b 45 08             	mov    0x8(%ebp),%eax
  105a03:	0f b6 00             	movzbl (%eax),%eax
  105a06:	3c 60                	cmp    $0x60,%al
  105a08:	7e 1b                	jle    105a25 <strtol+0xf1>
  105a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0d:	0f b6 00             	movzbl (%eax),%eax
  105a10:	3c 7a                	cmp    $0x7a,%al
  105a12:	7f 11                	jg     105a25 <strtol+0xf1>
            dig = *s - 'a' + 10;
  105a14:	8b 45 08             	mov    0x8(%ebp),%eax
  105a17:	0f b6 00             	movzbl (%eax),%eax
  105a1a:	0f be c0             	movsbl %al,%eax
  105a1d:	83 e8 57             	sub    $0x57,%eax
  105a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a23:	eb 23                	jmp    105a48 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105a25:	8b 45 08             	mov    0x8(%ebp),%eax
  105a28:	0f b6 00             	movzbl (%eax),%eax
  105a2b:	3c 40                	cmp    $0x40,%al
  105a2d:	7e 3b                	jle    105a6a <strtol+0x136>
  105a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a32:	0f b6 00             	movzbl (%eax),%eax
  105a35:	3c 5a                	cmp    $0x5a,%al
  105a37:	7f 31                	jg     105a6a <strtol+0x136>
            dig = *s - 'A' + 10;
  105a39:	8b 45 08             	mov    0x8(%ebp),%eax
  105a3c:	0f b6 00             	movzbl (%eax),%eax
  105a3f:	0f be c0             	movsbl %al,%eax
  105a42:	83 e8 37             	sub    $0x37,%eax
  105a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a4b:	3b 45 10             	cmp    0x10(%ebp),%eax
  105a4e:	7d 19                	jge    105a69 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  105a50:	ff 45 08             	incl   0x8(%ebp)
  105a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a56:	0f af 45 10          	imul   0x10(%ebp),%eax
  105a5a:	89 c2                	mov    %eax,%edx
  105a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a5f:	01 d0                	add    %edx,%eax
  105a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  105a64:	e9 72 ff ff ff       	jmp    1059db <strtol+0xa7>
            break;
  105a69:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  105a6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105a6e:	74 08                	je     105a78 <strtol+0x144>
        *endptr = (char *) s;
  105a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a73:	8b 55 08             	mov    0x8(%ebp),%edx
  105a76:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105a78:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105a7c:	74 07                	je     105a85 <strtol+0x151>
  105a7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a81:	f7 d8                	neg    %eax
  105a83:	eb 03                	jmp    105a88 <strtol+0x154>
  105a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105a88:	89 ec                	mov    %ebp,%esp
  105a8a:	5d                   	pop    %ebp
  105a8b:	c3                   	ret    

00105a8c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105a8c:	55                   	push   %ebp
  105a8d:	89 e5                	mov    %esp,%ebp
  105a8f:	83 ec 28             	sub    $0x28,%esp
  105a92:	89 7d fc             	mov    %edi,-0x4(%ebp)
  105a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a98:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105a9b:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  105a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105aa2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  105aa5:	88 55 f7             	mov    %dl,-0x9(%ebp)
  105aa8:	8b 45 10             	mov    0x10(%ebp),%eax
  105aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105aae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105ab1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105ab5:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105ab8:	89 d7                	mov    %edx,%edi
  105aba:	f3 aa                	rep stos %al,%es:(%edi)
  105abc:	89 fa                	mov    %edi,%edx
  105abe:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ac1:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105ac4:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105ac7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  105aca:	89 ec                	mov    %ebp,%esp
  105acc:	5d                   	pop    %ebp
  105acd:	c3                   	ret    

00105ace <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105ace:	55                   	push   %ebp
  105acf:	89 e5                	mov    %esp,%ebp
  105ad1:	57                   	push   %edi
  105ad2:	56                   	push   %esi
  105ad3:	53                   	push   %ebx
  105ad4:	83 ec 30             	sub    $0x30,%esp
  105ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  105ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105add:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ae3:	8b 45 10             	mov    0x10(%ebp),%eax
  105ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aec:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105aef:	73 42                	jae    105b33 <memmove+0x65>
  105af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105af4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105afa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105afd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b00:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105b03:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105b06:	c1 e8 02             	shr    $0x2,%eax
  105b09:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105b0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105b0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b11:	89 d7                	mov    %edx,%edi
  105b13:	89 c6                	mov    %eax,%esi
  105b15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105b17:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105b1a:	83 e1 03             	and    $0x3,%ecx
  105b1d:	74 02                	je     105b21 <memmove+0x53>
  105b1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105b21:	89 f0                	mov    %esi,%eax
  105b23:	89 fa                	mov    %edi,%edx
  105b25:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105b28:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105b2b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  105b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  105b31:	eb 36                	jmp    105b69 <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b36:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b3c:	01 c2                	add    %eax,%edx
  105b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b41:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b47:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105b4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b4d:	89 c1                	mov    %eax,%ecx
  105b4f:	89 d8                	mov    %ebx,%eax
  105b51:	89 d6                	mov    %edx,%esi
  105b53:	89 c7                	mov    %eax,%edi
  105b55:	fd                   	std    
  105b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105b58:	fc                   	cld    
  105b59:	89 f8                	mov    %edi,%eax
  105b5b:	89 f2                	mov    %esi,%edx
  105b5d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105b60:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105b63:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105b69:	83 c4 30             	add    $0x30,%esp
  105b6c:	5b                   	pop    %ebx
  105b6d:	5e                   	pop    %esi
  105b6e:	5f                   	pop    %edi
  105b6f:	5d                   	pop    %ebp
  105b70:	c3                   	ret    

00105b71 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105b71:	55                   	push   %ebp
  105b72:	89 e5                	mov    %esp,%ebp
  105b74:	57                   	push   %edi
  105b75:	56                   	push   %esi
  105b76:	83 ec 20             	sub    $0x20,%esp
  105b79:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b85:	8b 45 10             	mov    0x10(%ebp),%eax
  105b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105b8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b8e:	c1 e8 02             	shr    $0x2,%eax
  105b91:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b99:	89 d7                	mov    %edx,%edi
  105b9b:	89 c6                	mov    %eax,%esi
  105b9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105b9f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105ba2:	83 e1 03             	and    $0x3,%ecx
  105ba5:	74 02                	je     105ba9 <memcpy+0x38>
  105ba7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ba9:	89 f0                	mov    %esi,%eax
  105bab:	89 fa                	mov    %edi,%edx
  105bad:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bb0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105bb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105bb9:	83 c4 20             	add    $0x20,%esp
  105bbc:	5e                   	pop    %esi
  105bbd:	5f                   	pop    %edi
  105bbe:	5d                   	pop    %ebp
  105bbf:	c3                   	ret    

00105bc0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105bc0:	55                   	push   %ebp
  105bc1:	89 e5                	mov    %esp,%ebp
  105bc3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105bd2:	eb 2e                	jmp    105c02 <memcmp+0x42>
        if (*s1 != *s2) {
  105bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105bd7:	0f b6 10             	movzbl (%eax),%edx
  105bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bdd:	0f b6 00             	movzbl (%eax),%eax
  105be0:	38 c2                	cmp    %al,%dl
  105be2:	74 18                	je     105bfc <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105be7:	0f b6 00             	movzbl (%eax),%eax
  105bea:	0f b6 d0             	movzbl %al,%edx
  105bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bf0:	0f b6 00             	movzbl (%eax),%eax
  105bf3:	0f b6 c8             	movzbl %al,%ecx
  105bf6:	89 d0                	mov    %edx,%eax
  105bf8:	29 c8                	sub    %ecx,%eax
  105bfa:	eb 18                	jmp    105c14 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105bfc:	ff 45 fc             	incl   -0x4(%ebp)
  105bff:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105c02:	8b 45 10             	mov    0x10(%ebp),%eax
  105c05:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c08:	89 55 10             	mov    %edx,0x10(%ebp)
  105c0b:	85 c0                	test   %eax,%eax
  105c0d:	75 c5                	jne    105bd4 <memcmp+0x14>
    }
    return 0;
  105c0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c14:	89 ec                	mov    %ebp,%esp
  105c16:	5d                   	pop    %ebp
  105c17:	c3                   	ret    
