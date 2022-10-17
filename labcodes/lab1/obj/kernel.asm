
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100023:	e8 82 34 00 00       	call   1034aa <memset>

    cons_init();                // init the console
  100028:	e8 c4 15 00 00       	call   1015f1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 40 36 10 00 	movl   $0x103640,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 5c 36 10 00 	movl   $0x10365c,(%esp)
  100042:	e8 e9 02 00 00       	call   100330 <cprintf>

    print_kerninfo();
  100047:	e8 07 08 00 00       	call   100853 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 95 00 00 00       	call   1000e6 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 ab 2a 00 00       	call   102b01 <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 f1 16 00 00       	call   10174c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 55 18 00 00       	call   1018b5 <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 2d 0d 00 00       	call   100d92 <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 40 16 00 00       	call   1016aa <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006a:	e8 76 01 00 00       	call   1001e5 <lab1_switch_test>

    /* do nothing */
    while (1);
  10006f:	eb fe                	jmp    10006f <kern_init+0x6f>

00100071 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100071:	55                   	push   %ebp
  100072:	89 e5                	mov    %esp,%ebp
  100074:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100077:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007e:	00 
  10007f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100086:	00 
  100087:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008e:	e8 1a 0c 00 00       	call   100cad <mon_backtrace>
}
  100093:	90                   	nop
  100094:	89 ec                	mov    %ebp,%esp
  100096:	5d                   	pop    %ebp
  100097:	c3                   	ret    

00100098 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100098:	55                   	push   %ebp
  100099:	89 e5                	mov    %esp,%ebp
  10009b:	83 ec 18             	sub    $0x18,%esp
  10009e:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b0 ff ff ff       	call   100071 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c5:	89 ec                	mov    %ebp,%esp
  1000c7:	5d                   	pop    %ebp
  1000c8:	c3                   	ret    

001000c9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c9:	55                   	push   %ebp
  1000ca:	89 e5                	mov    %esp,%ebp
  1000cc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d9:	89 04 24             	mov    %eax,(%esp)
  1000dc:	e8 b7 ff ff ff       	call   100098 <grade_backtrace1>
}
  1000e1:	90                   	nop
  1000e2:	89 ec                	mov    %ebp,%esp
  1000e4:	5d                   	pop    %ebp
  1000e5:	c3                   	ret    

001000e6 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e6:	55                   	push   %ebp
  1000e7:	89 e5                	mov    %esp,%ebp
  1000e9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000ec:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000f1:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f8:	ff 
  1000f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100104:	e8 c0 ff ff ff       	call   1000c9 <grade_backtrace0>
}
  100109:	90                   	nop
  10010a:	89 ec                	mov    %ebp,%esp
  10010c:	5d                   	pop    %ebp
  10010d:	c3                   	ret    

0010010e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10010e:	55                   	push   %ebp
  10010f:	89 e5                	mov    %esp,%ebp
  100111:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100114:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100117:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10011a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10011d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100120:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100124:	83 e0 03             	and    $0x3,%eax
  100127:	89 c2                	mov    %eax,%edx
  100129:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10012e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100132:	89 44 24 04          	mov    %eax,0x4(%esp)
  100136:	c7 04 24 61 36 10 00 	movl   $0x103661,(%esp)
  10013d:	e8 ee 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100142:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 6f 36 10 00 	movl   $0x10366f,(%esp)
  10015c:	e8 cf 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100161:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100165:	89 c2                	mov    %eax,%edx
  100167:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10016c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100170:	89 44 24 04          	mov    %eax,0x4(%esp)
  100174:	c7 04 24 7d 36 10 00 	movl   $0x10367d,(%esp)
  10017b:	e8 b0 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100180:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100184:	89 c2                	mov    %eax,%edx
  100186:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  10018b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100193:	c7 04 24 8b 36 10 00 	movl   $0x10368b,(%esp)
  10019a:	e8 91 01 00 00       	call   100330 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a3:	89 c2                	mov    %eax,%edx
  1001a5:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001aa:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b2:	c7 04 24 99 36 10 00 	movl   $0x103699,(%esp)
  1001b9:	e8 72 01 00 00       	call   100330 <cprintf>
    round ++;
  1001be:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001c3:	40                   	inc    %eax
  1001c4:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c9:	90                   	nop
  1001ca:	89 ec                	mov    %ebp,%esp
  1001cc:	5d                   	pop    %ebp
  1001cd:	c3                   	ret    

001001ce <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001ce:	55                   	push   %ebp
  1001cf:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001d1:	83 ec 08             	sub    $0x8,%esp
  1001d4:	cd 78                	int    $0x78
  1001d6:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d8:	90                   	nop
  1001d9:	5d                   	pop    %ebp
  1001da:	c3                   	ret    

001001db <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001db:	55                   	push   %ebp
  1001dc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001de:	cd 79                	int    $0x79
  1001e0:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001e2:	90                   	nop
  1001e3:	5d                   	pop    %ebp
  1001e4:	c3                   	ret    

001001e5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e5:	55                   	push   %ebp
  1001e6:	89 e5                	mov    %esp,%ebp
  1001e8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001eb:	e8 1e ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001f0:	c7 04 24 a8 36 10 00 	movl   $0x1036a8,(%esp)
  1001f7:	e8 34 01 00 00       	call   100330 <cprintf>
    lab1_switch_to_user();
  1001fc:	e8 cd ff ff ff       	call   1001ce <lab1_switch_to_user>
    lab1_print_cur_status();
  100201:	e8 08 ff ff ff       	call   10010e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100206:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  10020d:	e8 1e 01 00 00       	call   100330 <cprintf>
    lab1_switch_to_kernel();
  100212:	e8 c4 ff ff ff       	call   1001db <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100217:	e8 f2 fe ff ff       	call   10010e <lab1_print_cur_status>
}
  10021c:	90                   	nop
  10021d:	89 ec                	mov    %ebp,%esp
  10021f:	5d                   	pop    %ebp
  100220:	c3                   	ret    

00100221 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100221:	55                   	push   %ebp
  100222:	89 e5                	mov    %esp,%ebp
  100224:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10022b:	74 13                	je     100240 <readline+0x1f>
        cprintf("%s", prompt);
  10022d:	8b 45 08             	mov    0x8(%ebp),%eax
  100230:	89 44 24 04          	mov    %eax,0x4(%esp)
  100234:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  10023b:	e8 f0 00 00 00       	call   100330 <cprintf>
    }
    int i = 0, c;
  100240:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100247:	e8 73 01 00 00       	call   1003bf <getchar>
  10024c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10024f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100253:	79 07                	jns    10025c <readline+0x3b>
            return NULL;
  100255:	b8 00 00 00 00       	mov    $0x0,%eax
  10025a:	eb 78                	jmp    1002d4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10025c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100260:	7e 28                	jle    10028a <readline+0x69>
  100262:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100269:	7f 1f                	jg     10028a <readline+0x69>
            cputchar(c);
  10026b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026e:	89 04 24             	mov    %eax,(%esp)
  100271:	e8 e2 00 00 00       	call   100358 <cputchar>
            buf[i ++] = c;
  100276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100279:	8d 50 01             	lea    0x1(%eax),%edx
  10027c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10027f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100282:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100288:	eb 45                	jmp    1002cf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10028a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10028e:	75 16                	jne    1002a6 <readline+0x85>
  100290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100294:	7e 10                	jle    1002a6 <readline+0x85>
            cputchar(c);
  100296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100299:	89 04 24             	mov    %eax,(%esp)
  10029c:	e8 b7 00 00 00       	call   100358 <cputchar>
            i --;
  1002a1:	ff 4d f4             	decl   -0xc(%ebp)
  1002a4:	eb 29                	jmp    1002cf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1002a6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002aa:	74 06                	je     1002b2 <readline+0x91>
  1002ac:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002b0:	75 95                	jne    100247 <readline+0x26>
            cputchar(c);
  1002b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b5:	89 04 24             	mov    %eax,(%esp)
  1002b8:	e8 9b 00 00 00       	call   100358 <cputchar>
            buf[i] = '\0';
  1002bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002c0:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002c5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c8:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002cd:	eb 05                	jmp    1002d4 <readline+0xb3>
        c = getchar();
  1002cf:	e9 73 ff ff ff       	jmp    100247 <readline+0x26>
        }
    }
}
  1002d4:	89 ec                	mov    %ebp,%esp
  1002d6:	5d                   	pop    %ebp
  1002d7:	c3                   	ret    

001002d8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002d8:	55                   	push   %ebp
  1002d9:	89 e5                	mov    %esp,%ebp
  1002db:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002de:	8b 45 08             	mov    0x8(%ebp),%eax
  1002e1:	89 04 24             	mov    %eax,(%esp)
  1002e4:	e8 37 13 00 00       	call   101620 <cons_putc>
    (*cnt) ++;
  1002e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ec:	8b 00                	mov    (%eax),%eax
  1002ee:	8d 50 01             	lea    0x1(%eax),%edx
  1002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f4:	89 10                	mov    %edx,(%eax)
}
  1002f6:	90                   	nop
  1002f7:	89 ec                	mov    %ebp,%esp
  1002f9:	5d                   	pop    %ebp
  1002fa:	c3                   	ret    

001002fb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002fb:	55                   	push   %ebp
  1002fc:	89 e5                	mov    %esp,%ebp
  1002fe:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100308:	8b 45 0c             	mov    0xc(%ebp),%eax
  10030b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10030f:	8b 45 08             	mov    0x8(%ebp),%eax
  100312:	89 44 24 08          	mov    %eax,0x8(%esp)
  100316:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100319:	89 44 24 04          	mov    %eax,0x4(%esp)
  10031d:	c7 04 24 d8 02 10 00 	movl   $0x1002d8,(%esp)
  100324:	e8 ac 29 00 00       	call   102cd5 <vprintfmt>
    return cnt;
  100329:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10032c:	89 ec                	mov    %ebp,%esp
  10032e:	5d                   	pop    %ebp
  10032f:	c3                   	ret    

00100330 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100330:	55                   	push   %ebp
  100331:	89 e5                	mov    %esp,%ebp
  100333:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100336:	8d 45 0c             	lea    0xc(%ebp),%eax
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10033c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10033f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100343:	8b 45 08             	mov    0x8(%ebp),%eax
  100346:	89 04 24             	mov    %eax,(%esp)
  100349:	e8 ad ff ff ff       	call   1002fb <vcprintf>
  10034e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100351:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100354:	89 ec                	mov    %ebp,%esp
  100356:	5d                   	pop    %ebp
  100357:	c3                   	ret    

00100358 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100358:	55                   	push   %ebp
  100359:	89 e5                	mov    %esp,%ebp
  10035b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10035e:	8b 45 08             	mov    0x8(%ebp),%eax
  100361:	89 04 24             	mov    %eax,(%esp)
  100364:	e8 b7 12 00 00       	call   101620 <cons_putc>
}
  100369:	90                   	nop
  10036a:	89 ec                	mov    %ebp,%esp
  10036c:	5d                   	pop    %ebp
  10036d:	c3                   	ret    

0010036e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100374:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10037b:	eb 13                	jmp    100390 <cputs+0x22>
        cputch(c, &cnt);
  10037d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100381:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100384:	89 54 24 04          	mov    %edx,0x4(%esp)
  100388:	89 04 24             	mov    %eax,(%esp)
  10038b:	e8 48 ff ff ff       	call   1002d8 <cputch>
    while ((c = *str ++) != '\0') {
  100390:	8b 45 08             	mov    0x8(%ebp),%eax
  100393:	8d 50 01             	lea    0x1(%eax),%edx
  100396:	89 55 08             	mov    %edx,0x8(%ebp)
  100399:	0f b6 00             	movzbl (%eax),%eax
  10039c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10039f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003a3:	75 d8                	jne    10037d <cputs+0xf>
    }
    cputch('\n', &cnt);
  1003a5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003ac:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003b3:	e8 20 ff ff ff       	call   1002d8 <cputch>
    return cnt;
  1003b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003bb:	89 ec                	mov    %ebp,%esp
  1003bd:	5d                   	pop    %ebp
  1003be:	c3                   	ret    

001003bf <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003bf:	55                   	push   %ebp
  1003c0:	89 e5                	mov    %esp,%ebp
  1003c2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003c5:	90                   	nop
  1003c6:	e8 81 12 00 00       	call   10164c <cons_getc>
  1003cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d2:	74 f2                	je     1003c6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003d7:	89 ec                	mov    %ebp,%esp
  1003d9:	5d                   	pop    %ebp
  1003da:	c3                   	ret    

001003db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003db:	55                   	push   %ebp
  1003dc:	89 e5                	mov    %esp,%ebp
  1003de:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e4:	8b 00                	mov    (%eax),%eax
  1003e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003e9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ec:	8b 00                	mov    (%eax),%eax
  1003ee:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003f8:	e9 ca 00 00 00       	jmp    1004c7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100400:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100403:	01 d0                	add    %edx,%eax
  100405:	89 c2                	mov    %eax,%edx
  100407:	c1 ea 1f             	shr    $0x1f,%edx
  10040a:	01 d0                	add    %edx,%eax
  10040c:	d1 f8                	sar    %eax
  10040e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100414:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100417:	eb 03                	jmp    10041c <stab_binsearch+0x41>
            m --;
  100419:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7c 1f                	jl     100443 <stab_binsearch+0x68>
  100424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100427:	89 d0                	mov    %edx,%eax
  100429:	01 c0                	add    %eax,%eax
  10042b:	01 d0                	add    %edx,%eax
  10042d:	c1 e0 02             	shl    $0x2,%eax
  100430:	89 c2                	mov    %eax,%edx
  100432:	8b 45 08             	mov    0x8(%ebp),%eax
  100435:	01 d0                	add    %edx,%eax
  100437:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043b:	0f b6 c0             	movzbl %al,%eax
  10043e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100441:	75 d6                	jne    100419 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100446:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100449:	7d 09                	jge    100454 <stab_binsearch+0x79>
            l = true_m + 1;
  10044b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10044e:	40                   	inc    %eax
  10044f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100452:	eb 73                	jmp    1004c7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100454:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10045b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045e:	89 d0                	mov    %edx,%eax
  100460:	01 c0                	add    %eax,%eax
  100462:	01 d0                	add    %edx,%eax
  100464:	c1 e0 02             	shl    $0x2,%eax
  100467:	89 c2                	mov    %eax,%edx
  100469:	8b 45 08             	mov    0x8(%ebp),%eax
  10046c:	01 d0                	add    %edx,%eax
  10046e:	8b 40 08             	mov    0x8(%eax),%eax
  100471:	39 45 18             	cmp    %eax,0x18(%ebp)
  100474:	76 11                	jbe    100487 <stab_binsearch+0xac>
            *region_left = m;
  100476:	8b 45 0c             	mov    0xc(%ebp),%eax
  100479:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10047e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100481:	40                   	inc    %eax
  100482:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100485:	eb 40                	jmp    1004c7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100487:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048a:	89 d0                	mov    %edx,%eax
  10048c:	01 c0                	add    %eax,%eax
  10048e:	01 d0                	add    %edx,%eax
  100490:	c1 e0 02             	shl    $0x2,%eax
  100493:	89 c2                	mov    %eax,%edx
  100495:	8b 45 08             	mov    0x8(%ebp),%eax
  100498:	01 d0                	add    %edx,%eax
  10049a:	8b 40 08             	mov    0x8(%eax),%eax
  10049d:	39 45 18             	cmp    %eax,0x18(%ebp)
  1004a0:	73 14                	jae    1004b6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  1004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ab:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	48                   	dec    %eax
  1004b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b4:	eb 11                	jmp    1004c7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004bc:	89 10                	mov    %edx,(%eax)
            l = m;
  1004be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004c4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004cd:	0f 8e 2a ff ff ff    	jle    1003fd <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004d7:	75 0f                	jne    1004e8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004dc:	8b 00                	mov    (%eax),%eax
  1004de:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004e4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004e6:	eb 3e                	jmp    100526 <stab_binsearch+0x14b>
        l = *region_right;
  1004e8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004eb:	8b 00                	mov    (%eax),%eax
  1004ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004f0:	eb 03                	jmp    1004f5 <stab_binsearch+0x11a>
  1004f2:	ff 4d fc             	decl   -0x4(%ebp)
  1004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f8:	8b 00                	mov    (%eax),%eax
  1004fa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004fd:	7e 1f                	jle    10051e <stab_binsearch+0x143>
  1004ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100502:	89 d0                	mov    %edx,%eax
  100504:	01 c0                	add    %eax,%eax
  100506:	01 d0                	add    %edx,%eax
  100508:	c1 e0 02             	shl    $0x2,%eax
  10050b:	89 c2                	mov    %eax,%edx
  10050d:	8b 45 08             	mov    0x8(%ebp),%eax
  100510:	01 d0                	add    %edx,%eax
  100512:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100516:	0f b6 c0             	movzbl %al,%eax
  100519:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051c:	75 d4                	jne    1004f2 <stab_binsearch+0x117>
        *region_left = l;
  10051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100524:	89 10                	mov    %edx,(%eax)
}
  100526:	90                   	nop
  100527:	89 ec                	mov    %ebp,%esp
  100529:	5d                   	pop    %ebp
  10052a:	c3                   	ret    

0010052b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10052b:	55                   	push   %ebp
  10052c:	89 e5                	mov    %esp,%ebp
  10052e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100531:	8b 45 0c             	mov    0xc(%ebp),%eax
  100534:	c7 00 ec 36 10 00    	movl   $0x1036ec,(%eax)
    info->eip_line = 0;
  10053a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 40 08 ec 36 10 00 	movl   $0x1036ec,0x8(%eax)
    info->eip_fn_namelen = 9;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	8b 55 08             	mov    0x8(%ebp),%edx
  10055e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100561:	8b 45 0c             	mov    0xc(%ebp),%eax
  100564:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10056b:	c7 45 f4 6c 3f 10 00 	movl   $0x103f6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100572:	c7 45 f0 2c be 10 00 	movl   $0x10be2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100579:	c7 45 ec 2d be 10 00 	movl   $0x10be2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100580:	c7 45 e8 a5 e7 10 00 	movl   $0x10e7a5,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10058a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10058d:	76 0b                	jbe    10059a <debuginfo_eip+0x6f>
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	48                   	dec    %eax
  100593:	0f b6 00             	movzbl (%eax),%eax
  100596:	84 c0                	test   %al,%al
  100598:	74 0a                	je     1005a4 <debuginfo_eip+0x79>
        return -1;
  10059a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10059f:	e9 ab 02 00 00       	jmp    10084f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005b1:	c1 f8 02             	sar    $0x2,%eax
  1005b4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ba:	48                   	dec    %eax
  1005bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005be:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005c5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005cc:	00 
  1005cd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005de:	89 04 24             	mov    %eax,(%esp)
  1005e1:	e8 f5 fd ff ff       	call   1003db <stab_binsearch>
    if (lfile == 0)
  1005e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e9:	85 c0                	test   %eax,%eax
  1005eb:	75 0a                	jne    1005f7 <debuginfo_eip+0xcc>
        return -1;
  1005ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005f2:	e9 58 02 00 00       	jmp    10084f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005fa:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100600:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100603:	8b 45 08             	mov    0x8(%ebp),%eax
  100606:	89 44 24 10          	mov    %eax,0x10(%esp)
  10060a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100611:	00 
  100612:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100615:	89 44 24 08          	mov    %eax,0x8(%esp)
  100619:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10061c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100623:	89 04 24             	mov    %eax,(%esp)
  100626:	e8 b0 fd ff ff       	call   1003db <stab_binsearch>

    if (lfun <= rfun) {
  10062b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10062e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100631:	39 c2                	cmp    %eax,%edx
  100633:	7f 78                	jg     1006ad <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100635:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100638:	89 c2                	mov    %eax,%edx
  10063a:	89 d0                	mov    %edx,%eax
  10063c:	01 c0                	add    %eax,%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	c1 e0 02             	shl    $0x2,%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100648:	01 d0                	add    %edx,%eax
  10064a:	8b 10                	mov    (%eax),%edx
  10064c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100652:	39 c2                	cmp    %eax,%edx
  100654:	73 22                	jae    100678 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100656:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100659:	89 c2                	mov    %eax,%edx
  10065b:	89 d0                	mov    %edx,%eax
  10065d:	01 c0                	add    %eax,%eax
  10065f:	01 d0                	add    %edx,%eax
  100661:	c1 e0 02             	shl    $0x2,%eax
  100664:	89 c2                	mov    %eax,%edx
  100666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100669:	01 d0                	add    %edx,%eax
  10066b:	8b 10                	mov    (%eax),%edx
  10066d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100670:	01 c2                	add    %eax,%edx
  100672:	8b 45 0c             	mov    0xc(%ebp),%eax
  100675:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100678:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10067b:	89 c2                	mov    %eax,%edx
  10067d:	89 d0                	mov    %edx,%eax
  10067f:	01 c0                	add    %eax,%eax
  100681:	01 d0                	add    %edx,%eax
  100683:	c1 e0 02             	shl    $0x2,%eax
  100686:	89 c2                	mov    %eax,%edx
  100688:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068b:	01 d0                	add    %edx,%eax
  10068d:	8b 50 08             	mov    0x8(%eax),%edx
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100696:	8b 45 0c             	mov    0xc(%ebp),%eax
  100699:	8b 40 10             	mov    0x10(%eax),%eax
  10069c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10069f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006a2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006ab:	eb 15                	jmp    1006c2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c5:	8b 40 08             	mov    0x8(%eax),%eax
  1006c8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006cf:	00 
  1006d0:	89 04 24             	mov    %eax,(%esp)
  1006d3:	e8 4a 2c 00 00       	call   103322 <strfind>
  1006d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006db:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006de:	29 c8                	sub    %ecx,%eax
  1006e0:	89 c2                	mov    %eax,%edx
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006eb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ef:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f6:	00 
  1006f7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006fe:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100701:	89 44 24 04          	mov    %eax,0x4(%esp)
  100705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100708:	89 04 24             	mov    %eax,(%esp)
  10070b:	e8 cb fc ff ff       	call   1003db <stab_binsearch>
    if (lline <= rline) {
  100710:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100713:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100716:	39 c2                	cmp    %eax,%edx
  100718:	7f 23                	jg     10073d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10071a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10071d:	89 c2                	mov    %eax,%edx
  10071f:	89 d0                	mov    %edx,%eax
  100721:	01 c0                	add    %eax,%eax
  100723:	01 d0                	add    %edx,%eax
  100725:	c1 e0 02             	shl    $0x2,%eax
  100728:	89 c2                	mov    %eax,%edx
  10072a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10072d:	01 d0                	add    %edx,%eax
  10072f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100733:	89 c2                	mov    %eax,%edx
  100735:	8b 45 0c             	mov    0xc(%ebp),%eax
  100738:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	eb 11                	jmp    10074e <debuginfo_eip+0x223>
        return -1;
  10073d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100742:	e9 08 01 00 00       	jmp    10084f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100747:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074a:	48                   	dec    %eax
  10074b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10074e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100754:	39 c2                	cmp    %eax,%edx
  100756:	7c 56                	jl     1007ae <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100758:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075b:	89 c2                	mov    %eax,%edx
  10075d:	89 d0                	mov    %edx,%eax
  10075f:	01 c0                	add    %eax,%eax
  100761:	01 d0                	add    %edx,%eax
  100763:	c1 e0 02             	shl    $0x2,%eax
  100766:	89 c2                	mov    %eax,%edx
  100768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100771:	3c 84                	cmp    $0x84,%al
  100773:	74 39                	je     1007ae <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100775:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100778:	89 c2                	mov    %eax,%edx
  10077a:	89 d0                	mov    %edx,%eax
  10077c:	01 c0                	add    %eax,%eax
  10077e:	01 d0                	add    %edx,%eax
  100780:	c1 e0 02             	shl    $0x2,%eax
  100783:	89 c2                	mov    %eax,%edx
  100785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078e:	3c 64                	cmp    $0x64,%al
  100790:	75 b5                	jne    100747 <debuginfo_eip+0x21c>
  100792:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100795:	89 c2                	mov    %eax,%edx
  100797:	89 d0                	mov    %edx,%eax
  100799:	01 c0                	add    %eax,%eax
  10079b:	01 d0                	add    %edx,%eax
  10079d:	c1 e0 02             	shl    $0x2,%eax
  1007a0:	89 c2                	mov    %eax,%edx
  1007a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a5:	01 d0                	add    %edx,%eax
  1007a7:	8b 40 08             	mov    0x8(%eax),%eax
  1007aa:	85 c0                	test   %eax,%eax
  1007ac:	74 99                	je     100747 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b4:	39 c2                	cmp    %eax,%edx
  1007b6:	7c 42                	jl     1007fa <debuginfo_eip+0x2cf>
  1007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	89 d0                	mov    %edx,%eax
  1007bf:	01 c0                	add    %eax,%eax
  1007c1:	01 d0                	add    %edx,%eax
  1007c3:	c1 e0 02             	shl    $0x2,%eax
  1007c6:	89 c2                	mov    %eax,%edx
  1007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cb:	01 d0                	add    %edx,%eax
  1007cd:	8b 10                	mov    (%eax),%edx
  1007cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007d2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007d5:	39 c2                	cmp    %eax,%edx
  1007d7:	73 21                	jae    1007fa <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007d9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dc:	89 c2                	mov    %eax,%edx
  1007de:	89 d0                	mov    %edx,%eax
  1007e0:	01 c0                	add    %eax,%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	c1 e0 02             	shl    $0x2,%eax
  1007e7:	89 c2                	mov    %eax,%edx
  1007e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ec:	01 d0                	add    %edx,%eax
  1007ee:	8b 10                	mov    (%eax),%edx
  1007f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f3:	01 c2                	add    %eax,%edx
  1007f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100800:	39 c2                	cmp    %eax,%edx
  100802:	7d 46                	jge    10084a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  100804:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100807:	40                   	inc    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080b:	eb 16                	jmp    100823 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100810:	8b 40 14             	mov    0x14(%eax),%eax
  100813:	8d 50 01             	lea    0x1(%eax),%edx
  100816:	8b 45 0c             	mov    0xc(%ebp),%eax
  100819:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10081c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10081f:	40                   	inc    %eax
  100820:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100826:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100829:	39 c2                	cmp    %eax,%edx
  10082b:	7d 1d                	jge    10084a <debuginfo_eip+0x31f>
  10082d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	89 d0                	mov    %edx,%eax
  100834:	01 c0                	add    %eax,%eax
  100836:	01 d0                	add    %edx,%eax
  100838:	c1 e0 02             	shl    $0x2,%eax
  10083b:	89 c2                	mov    %eax,%edx
  10083d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100840:	01 d0                	add    %edx,%eax
  100842:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100846:	3c a0                	cmp    $0xa0,%al
  100848:	74 c3                	je     10080d <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10084a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10084f:	89 ec                	mov    %ebp,%esp
  100851:	5d                   	pop    %ebp
  100852:	c3                   	ret    

00100853 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100853:	55                   	push   %ebp
  100854:	89 e5                	mov    %esp,%ebp
  100856:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100859:	c7 04 24 f6 36 10 00 	movl   $0x1036f6,(%esp)
  100860:	e8 cb fa ff ff       	call   100330 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100865:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086c:	00 
  10086d:	c7 04 24 0f 37 10 00 	movl   $0x10370f,(%esp)
  100874:	e8 b7 fa ff ff       	call   100330 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100879:	c7 44 24 04 36 36 10 	movl   $0x103636,0x4(%esp)
  100880:	00 
  100881:	c7 04 24 27 37 10 00 	movl   $0x103727,(%esp)
  100888:	e8 a3 fa ff ff       	call   100330 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10088d:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100894:	00 
  100895:	c7 04 24 3f 37 10 00 	movl   $0x10373f,(%esp)
  10089c:	e8 8f fa ff ff       	call   100330 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a1:	c7 44 24 04 68 0d 11 	movl   $0x110d68,0x4(%esp)
  1008a8:	00 
  1008a9:	c7 04 24 57 37 10 00 	movl   $0x103757,(%esp)
  1008b0:	e8 7b fa ff ff       	call   100330 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b5:	b8 68 0d 11 00       	mov    $0x110d68,%eax
  1008ba:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008bf:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008c4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ca:	85 c0                	test   %eax,%eax
  1008cc:	0f 48 c2             	cmovs  %edx,%eax
  1008cf:	c1 f8 0a             	sar    $0xa,%eax
  1008d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d6:	c7 04 24 70 37 10 00 	movl   $0x103770,(%esp)
  1008dd:	e8 4e fa ff ff       	call   100330 <cprintf>
}
  1008e2:	90                   	nop
  1008e3:	89 ec                	mov    %ebp,%esp
  1008e5:	5d                   	pop    %ebp
  1008e6:	c3                   	ret    

001008e7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e7:	55                   	push   %ebp
  1008e8:	89 e5                	mov    %esp,%ebp
  1008ea:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fa:	89 04 24             	mov    %eax,(%esp)
  1008fd:	e8 29 fc ff ff       	call   10052b <debuginfo_eip>
  100902:	85 c0                	test   %eax,%eax
  100904:	74 15                	je     10091b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100906:	8b 45 08             	mov    0x8(%ebp),%eax
  100909:	89 44 24 04          	mov    %eax,0x4(%esp)
  10090d:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  100914:	e8 17 fa ff ff       	call   100330 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100919:	eb 6c                	jmp    100987 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10091b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100922:	eb 1b                	jmp    10093f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100924:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092a:	01 d0                	add    %edx,%eax
  10092c:	0f b6 10             	movzbl (%eax),%edx
  10092f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100938:	01 c8                	add    %ecx,%eax
  10093a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093c:	ff 45 f4             	incl   -0xc(%ebp)
  10093f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100942:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100945:	7c dd                	jl     100924 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100947:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10094d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100950:	01 d0                	add    %edx,%eax
  100952:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100955:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100958:	8b 45 08             	mov    0x8(%ebp),%eax
  10095b:	29 d0                	sub    %edx,%eax
  10095d:	89 c1                	mov    %eax,%ecx
  10095f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100962:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100965:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100969:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100973:	89 54 24 08          	mov    %edx,0x8(%esp)
  100977:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097b:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100982:	e8 a9 f9 ff ff       	call   100330 <cprintf>
}
  100987:	90                   	nop
  100988:	89 ec                	mov    %ebp,%esp
  10098a:	5d                   	pop    %ebp
  10098b:	c3                   	ret    

0010098c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098c:	55                   	push   %ebp
  10098d:	89 e5                	mov    %esp,%ebp
  10098f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100992:	8b 45 04             	mov    0x4(%ebp),%eax
  100995:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100998:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099b:	89 ec                	mov    %ebp,%esp
  10099d:	5d                   	pop    %ebp
  10099e:	c3                   	ret    

0010099f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10099f:	55                   	push   %ebp
  1009a0:	89 e5                	mov    %esp,%ebp
  1009a2:	83 ec 38             	sub    $0x38,%esp
  1009a5:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a8:	89 e8                	mov    %ebp,%eax
  1009aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  1009ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp=read_ebp();
  1009b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip=read_eip();
  1009b3:	e8 d4 ff ff ff       	call   10098c <read_eip>
  1009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      for(int i=0;ebp&&eip&&i<STACKFRAME_DEPTH;i++){
  1009bb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c2:	e9 84 00 00 00       	jmp    100a4b <print_stackframe+0xac>
      	cprintf("ebp:0x%08x ",ebp);
  1009c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ce:	c7 04 24 c8 37 10 00 	movl   $0x1037c8,(%esp)
  1009d5:	e8 56 f9 ff ff       	call   100330 <cprintf>
	cprintf("eip:0x%08x ",eip);
  1009da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009e1:	c7 04 24 d4 37 10 00 	movl   $0x1037d4,(%esp)
  1009e8:	e8 43 f9 ff ff       	call   100330 <cprintf>
	cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n",*(unsigned int*)(ebp+8),*(unsigned int*)(ebp+12),*(unsigned int*)(ebp+16),*(unsigned int*)(ebp+20) );
  1009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f0:	83 c0 14             	add    $0x14,%eax
  1009f3:	8b 18                	mov    (%eax),%ebx
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	83 c0 10             	add    $0x10,%eax
  1009fb:	8b 08                	mov    (%eax),%ecx
  1009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a00:	83 c0 0c             	add    $0xc,%eax
  100a03:	8b 10                	mov    (%eax),%edx
  100a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a08:	83 c0 08             	add    $0x8,%eax
  100a0b:	8b 00                	mov    (%eax),%eax
  100a0d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a11:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a15:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a1d:	c7 04 24 e0 37 10 00 	movl   $0x1037e0,(%esp)
  100a24:	e8 07 f9 ff ff       	call   100330 <cprintf>
        print_debuginfo(eip-1);
  100a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a2c:	48                   	dec    %eax
  100a2d:	89 04 24             	mov    %eax,(%esp)
  100a30:	e8 b2 fe ff ff       	call   1008e7 <print_debuginfo>
        eip=*(uint32_t*)(ebp+4);
  100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a38:	83 c0 04             	add    $0x4,%eax
  100a3b:	8b 00                	mov    (%eax),%eax
  100a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	ebp=*(uint32_t*)ebp;
  100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a43:	8b 00                	mov    (%eax),%eax
  100a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
      for(int i=0;ebp&&eip&&i<STACKFRAME_DEPTH;i++){
  100a48:	ff 45 ec             	incl   -0x14(%ebp)
  100a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a4f:	74 10                	je     100a61 <print_stackframe+0xc2>
  100a51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a55:	74 0a                	je     100a61 <print_stackframe+0xc2>
  100a57:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a5b:	0f 8e 66 ff ff ff    	jle    1009c7 <print_stackframe+0x28>
      }
}
  100a61:	90                   	nop
  100a62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a65:	89 ec                	mov    %ebp,%esp
  100a67:	5d                   	pop    %ebp
  100a68:	c3                   	ret    

00100a69 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a69:	55                   	push   %ebp
  100a6a:	89 e5                	mov    %esp,%ebp
  100a6c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a76:	eb 0c                	jmp    100a84 <parse+0x1b>
            *buf ++ = '\0';
  100a78:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7b:	8d 50 01             	lea    0x1(%eax),%edx
  100a7e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a81:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a84:	8b 45 08             	mov    0x8(%ebp),%eax
  100a87:	0f b6 00             	movzbl (%eax),%eax
  100a8a:	84 c0                	test   %al,%al
  100a8c:	74 1d                	je     100aab <parse+0x42>
  100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a91:	0f b6 00             	movzbl (%eax),%eax
  100a94:	0f be c0             	movsbl %al,%eax
  100a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a9b:	c7 04 24 84 38 10 00 	movl   $0x103884,(%esp)
  100aa2:	e8 47 28 00 00       	call   1032ee <strchr>
  100aa7:	85 c0                	test   %eax,%eax
  100aa9:	75 cd                	jne    100a78 <parse+0xf>
        }
        if (*buf == '\0') {
  100aab:	8b 45 08             	mov    0x8(%ebp),%eax
  100aae:	0f b6 00             	movzbl (%eax),%eax
  100ab1:	84 c0                	test   %al,%al
  100ab3:	74 65                	je     100b1a <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ab5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab9:	75 14                	jne    100acf <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100abb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ac2:	00 
  100ac3:	c7 04 24 89 38 10 00 	movl   $0x103889,(%esp)
  100aca:	e8 61 f8 ff ff       	call   100330 <cprintf>
        }
        argv[argc ++] = buf;
  100acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad2:	8d 50 01             	lea    0x1(%eax),%edx
  100ad5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ad8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100adf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae2:	01 c2                	add    %eax,%edx
  100ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae9:	eb 03                	jmp    100aee <parse+0x85>
            buf ++;
  100aeb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aee:	8b 45 08             	mov    0x8(%ebp),%eax
  100af1:	0f b6 00             	movzbl (%eax),%eax
  100af4:	84 c0                	test   %al,%al
  100af6:	74 8c                	je     100a84 <parse+0x1b>
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	0f b6 00             	movzbl (%eax),%eax
  100afe:	0f be c0             	movsbl %al,%eax
  100b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b05:	c7 04 24 84 38 10 00 	movl   $0x103884,(%esp)
  100b0c:	e8 dd 27 00 00       	call   1032ee <strchr>
  100b11:	85 c0                	test   %eax,%eax
  100b13:	74 d6                	je     100aeb <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b15:	e9 6a ff ff ff       	jmp    100a84 <parse+0x1b>
            break;
  100b1a:	90                   	nop
        }
    }
    return argc;
  100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b1e:	89 ec                	mov    %ebp,%esp
  100b20:	5d                   	pop    %ebp
  100b21:	c3                   	ret    

00100b22 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b22:	55                   	push   %ebp
  100b23:	89 e5                	mov    %esp,%ebp
  100b25:	83 ec 68             	sub    $0x68,%esp
  100b28:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b2b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b32:	8b 45 08             	mov    0x8(%ebp),%eax
  100b35:	89 04 24             	mov    %eax,(%esp)
  100b38:	e8 2c ff ff ff       	call   100a69 <parse>
  100b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b44:	75 0a                	jne    100b50 <runcmd+0x2e>
        return 0;
  100b46:	b8 00 00 00 00       	mov    $0x0,%eax
  100b4b:	e9 83 00 00 00       	jmp    100bd3 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b57:	eb 5a                	jmp    100bb3 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b59:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b5c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b5f:	89 c8                	mov    %ecx,%eax
  100b61:	01 c0                	add    %eax,%eax
  100b63:	01 c8                	add    %ecx,%eax
  100b65:	c1 e0 02             	shl    $0x2,%eax
  100b68:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b6d:	8b 00                	mov    (%eax),%eax
  100b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b73:	89 04 24             	mov    %eax,(%esp)
  100b76:	e8 d7 26 00 00       	call   103252 <strcmp>
  100b7b:	85 c0                	test   %eax,%eax
  100b7d:	75 31                	jne    100bb0 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b82:	89 d0                	mov    %edx,%eax
  100b84:	01 c0                	add    %eax,%eax
  100b86:	01 d0                	add    %edx,%eax
  100b88:	c1 e0 02             	shl    $0x2,%eax
  100b8b:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b90:	8b 10                	mov    (%eax),%edx
  100b92:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b95:	83 c0 04             	add    $0x4,%eax
  100b98:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b9b:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ba1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba9:	89 1c 24             	mov    %ebx,(%esp)
  100bac:	ff d2                	call   *%edx
  100bae:	eb 23                	jmp    100bd3 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb0:	ff 45 f4             	incl   -0xc(%ebp)
  100bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb6:	83 f8 02             	cmp    $0x2,%eax
  100bb9:	76 9e                	jbe    100b59 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bbb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc2:	c7 04 24 a7 38 10 00 	movl   $0x1038a7,(%esp)
  100bc9:	e8 62 f7 ff ff       	call   100330 <cprintf>
    return 0;
  100bce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bd6:	89 ec                	mov    %ebp,%esp
  100bd8:	5d                   	pop    %ebp
  100bd9:	c3                   	ret    

00100bda <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bda:	55                   	push   %ebp
  100bdb:	89 e5                	mov    %esp,%ebp
  100bdd:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be0:	c7 04 24 c0 38 10 00 	movl   $0x1038c0,(%esp)
  100be7:	e8 44 f7 ff ff       	call   100330 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bec:	c7 04 24 e8 38 10 00 	movl   $0x1038e8,(%esp)
  100bf3:	e8 38 f7 ff ff       	call   100330 <cprintf>

    if (tf != NULL) {
  100bf8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bfc:	74 0b                	je     100c09 <kmonitor+0x2f>
        print_trapframe(tf);
  100bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  100c01:	89 04 24             	mov    %eax,(%esp)
  100c04:	e8 67 0e 00 00       	call   101a70 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c09:	c7 04 24 0d 39 10 00 	movl   $0x10390d,(%esp)
  100c10:	e8 0c f6 ff ff       	call   100221 <readline>
  100c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c1c:	74 eb                	je     100c09 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c28:	89 04 24             	mov    %eax,(%esp)
  100c2b:	e8 f2 fe ff ff       	call   100b22 <runcmd>
  100c30:	85 c0                	test   %eax,%eax
  100c32:	78 02                	js     100c36 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c34:	eb d3                	jmp    100c09 <kmonitor+0x2f>
                break;
  100c36:	90                   	nop
            }
        }
    }
}
  100c37:	90                   	nop
  100c38:	89 ec                	mov    %ebp,%esp
  100c3a:	5d                   	pop    %ebp
  100c3b:	c3                   	ret    

00100c3c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c3c:	55                   	push   %ebp
  100c3d:	89 e5                	mov    %esp,%ebp
  100c3f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c49:	eb 3d                	jmp    100c88 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4e:	89 d0                	mov    %edx,%eax
  100c50:	01 c0                	add    %eax,%eax
  100c52:	01 d0                	add    %edx,%eax
  100c54:	c1 e0 02             	shl    $0x2,%eax
  100c57:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c5c:	8b 10                	mov    (%eax),%edx
  100c5e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c61:	89 c8                	mov    %ecx,%eax
  100c63:	01 c0                	add    %eax,%eax
  100c65:	01 c8                	add    %ecx,%eax
  100c67:	c1 e0 02             	shl    $0x2,%eax
  100c6a:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c6f:	8b 00                	mov    (%eax),%eax
  100c71:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c79:	c7 04 24 11 39 10 00 	movl   $0x103911,(%esp)
  100c80:	e8 ab f6 ff ff       	call   100330 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c85:	ff 45 f4             	incl   -0xc(%ebp)
  100c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c8b:	83 f8 02             	cmp    $0x2,%eax
  100c8e:	76 bb                	jbe    100c4b <mon_help+0xf>
    }
    return 0;
  100c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c95:	89 ec                	mov    %ebp,%esp
  100c97:	5d                   	pop    %ebp
  100c98:	c3                   	ret    

00100c99 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c99:	55                   	push   %ebp
  100c9a:	89 e5                	mov    %esp,%ebp
  100c9c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c9f:	e8 af fb ff ff       	call   100853 <print_kerninfo>
    return 0;
  100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca9:	89 ec                	mov    %ebp,%esp
  100cab:	5d                   	pop    %ebp
  100cac:	c3                   	ret    

00100cad <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cad:	55                   	push   %ebp
  100cae:	89 e5                	mov    %esp,%ebp
  100cb0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb3:	e8 e7 fc ff ff       	call   10099f <print_stackframe>
    return 0;
  100cb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbd:	89 ec                	mov    %ebp,%esp
  100cbf:	5d                   	pop    %ebp
  100cc0:	c3                   	ret    

00100cc1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc1:	55                   	push   %ebp
  100cc2:	89 e5                	mov    %esp,%ebp
  100cc4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cc7:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100ccc:	85 c0                	test   %eax,%eax
  100cce:	75 5b                	jne    100d2b <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cd0:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100cd7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cda:	8d 45 14             	lea    0x14(%ebp),%eax
  100cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cee:	c7 04 24 1a 39 10 00 	movl   $0x10391a,(%esp)
  100cf5:	e8 36 f6 ff ff       	call   100330 <cprintf>
    vcprintf(fmt, ap);
  100cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d01:	8b 45 10             	mov    0x10(%ebp),%eax
  100d04:	89 04 24             	mov    %eax,(%esp)
  100d07:	e8 ef f5 ff ff       	call   1002fb <vcprintf>
    cprintf("\n");
  100d0c:	c7 04 24 36 39 10 00 	movl   $0x103936,(%esp)
  100d13:	e8 18 f6 ff ff       	call   100330 <cprintf>
    
    cprintf("stack trackback:\n");
  100d18:	c7 04 24 38 39 10 00 	movl   $0x103938,(%esp)
  100d1f:	e8 0c f6 ff ff       	call   100330 <cprintf>
    print_stackframe();
  100d24:	e8 76 fc ff ff       	call   10099f <print_stackframe>
  100d29:	eb 01                	jmp    100d2c <__panic+0x6b>
        goto panic_dead;
  100d2b:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d2c:	e8 81 09 00 00       	call   1016b2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d38:	e8 9d fe ff ff       	call   100bda <kmonitor>
  100d3d:	eb f2                	jmp    100d31 <__panic+0x70>

00100d3f <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3f:	55                   	push   %ebp
  100d40:	89 e5                	mov    %esp,%ebp
  100d42:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d45:	8d 45 14             	lea    0x14(%ebp),%eax
  100d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d52:	8b 45 08             	mov    0x8(%ebp),%eax
  100d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d59:	c7 04 24 4a 39 10 00 	movl   $0x10394a,(%esp)
  100d60:	e8 cb f5 ff ff       	call   100330 <cprintf>
    vcprintf(fmt, ap);
  100d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d68:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d6c:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6f:	89 04 24             	mov    %eax,(%esp)
  100d72:	e8 84 f5 ff ff       	call   1002fb <vcprintf>
    cprintf("\n");
  100d77:	c7 04 24 36 39 10 00 	movl   $0x103936,(%esp)
  100d7e:	e8 ad f5 ff ff       	call   100330 <cprintf>
    va_end(ap);
}
  100d83:	90                   	nop
  100d84:	89 ec                	mov    %ebp,%esp
  100d86:	5d                   	pop    %ebp
  100d87:	c3                   	ret    

00100d88 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d88:	55                   	push   %ebp
  100d89:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d8b:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d90:	5d                   	pop    %ebp
  100d91:	c3                   	ret    

00100d92 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d92:	55                   	push   %ebp
  100d93:	89 e5                	mov    %esp,%ebp
  100d95:	83 ec 28             	sub    $0x28,%esp
  100d98:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d9e:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100da2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100daa:	ee                   	out    %al,(%dx)
}
  100dab:	90                   	nop
  100dac:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100db6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dbe:	ee                   	out    %al,(%dx)
}
  100dbf:	90                   	nop
  100dc0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100dc6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dca:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dce:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dd2:	ee                   	out    %al,(%dx)
}
  100dd3:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd4:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100ddb:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dde:	c7 04 24 68 39 10 00 	movl   $0x103968,(%esp)
  100de5:	e8 46 f5 ff ff       	call   100330 <cprintf>
    pic_enable(IRQ_TIMER);
  100dea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df1:	e8 21 09 00 00       	call   101717 <pic_enable>
}
  100df6:	90                   	nop
  100df7:	89 ec                	mov    %ebp,%esp
  100df9:	5d                   	pop    %ebp
  100dfa:	c3                   	ret    

00100dfb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dfb:	55                   	push   %ebp
  100dfc:	89 e5                	mov    %esp,%ebp
  100dfe:	83 ec 10             	sub    $0x10,%esp
  100e01:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e07:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e0b:	89 c2                	mov    %eax,%edx
  100e0d:	ec                   	in     (%dx),%al
  100e0e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e11:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e17:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e1b:	89 c2                	mov    %eax,%edx
  100e1d:	ec                   	in     (%dx),%al
  100e1e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e21:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e27:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e2b:	89 c2                	mov    %eax,%edx
  100e2d:	ec                   	in     (%dx),%al
  100e2e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e31:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e37:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e3b:	89 c2                	mov    %eax,%edx
  100e3d:	ec                   	in     (%dx),%al
  100e3e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e41:	90                   	nop
  100e42:	89 ec                	mov    %ebp,%esp
  100e44:	5d                   	pop    %ebp
  100e45:	c3                   	ret    

00100e46 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e46:	55                   	push   %ebp
  100e47:	89 e5                	mov    %esp,%ebp
  100e49:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e4c:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e56:	0f b7 00             	movzwl (%eax),%eax
  100e59:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e60:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e68:	0f b7 00             	movzwl (%eax),%eax
  100e6b:	0f b7 c0             	movzwl %ax,%eax
  100e6e:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e73:	74 12                	je     100e87 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e75:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e7c:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e83:	b4 03 
  100e85:	eb 13                	jmp    100e9a <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e8e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e91:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e98:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e9a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ea1:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ea5:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ead:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100eb1:	ee                   	out    %al,(%dx)
}
  100eb2:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100eb3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eba:	40                   	inc    %eax
  100ebb:	0f b7 c0             	movzwl %ax,%eax
  100ebe:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100ec6:	89 c2                	mov    %eax,%edx
  100ec8:	ec                   	in     (%dx),%al
  100ec9:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ecc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ed0:	0f b6 c0             	movzbl %al,%eax
  100ed3:	c1 e0 08             	shl    $0x8,%eax
  100ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ed9:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ee0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ee4:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ee8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eec:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ef0:	ee                   	out    %al,(%dx)
}
  100ef1:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ef2:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ef9:	40                   	inc    %eax
  100efa:	0f b7 c0             	movzwl %ax,%eax
  100efd:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f01:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f05:	89 c2                	mov    %eax,%edx
  100f07:	ec                   	in     (%dx),%al
  100f08:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f0b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f0f:	0f b6 c0             	movzbl %al,%eax
  100f12:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f18:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f20:	0f b7 c0             	movzwl %ax,%eax
  100f23:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f29:	90                   	nop
  100f2a:	89 ec                	mov    %ebp,%esp
  100f2c:	5d                   	pop    %ebp
  100f2d:	c3                   	ret    

00100f2e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f2e:	55                   	push   %ebp
  100f2f:	89 e5                	mov    %esp,%ebp
  100f31:	83 ec 48             	sub    $0x48,%esp
  100f34:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f3a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f3e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f42:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f46:	ee                   	out    %al,(%dx)
}
  100f47:	90                   	nop
  100f48:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f4e:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f52:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f56:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f5a:	ee                   	out    %al,(%dx)
}
  100f5b:	90                   	nop
  100f5c:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f62:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f66:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f6a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f6e:	ee                   	out    %al,(%dx)
}
  100f6f:	90                   	nop
  100f70:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f76:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f7a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f7e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f82:	ee                   	out    %al,(%dx)
}
  100f83:	90                   	nop
  100f84:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f8a:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f92:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
}
  100f97:	90                   	nop
  100f98:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f9e:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fa6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100faa:	ee                   	out    %al,(%dx)
}
  100fab:	90                   	nop
  100fac:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fb2:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fba:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fbe:	ee                   	out    %al,(%dx)
}
  100fbf:	90                   	nop
  100fc0:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fc6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fca:	89 c2                	mov    %eax,%edx
  100fcc:	ec                   	in     (%dx),%al
  100fcd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fd0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fd4:	3c ff                	cmp    $0xff,%al
  100fd6:	0f 95 c0             	setne  %al
  100fd9:	0f b6 c0             	movzbl %al,%eax
  100fdc:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fe1:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fe7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100feb:	89 c2                	mov    %eax,%edx
  100fed:	ec                   	in     (%dx),%al
  100fee:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ff1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100ff7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ffb:	89 c2                	mov    %eax,%edx
  100ffd:	ec                   	in     (%dx),%al
  100ffe:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101001:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101006:	85 c0                	test   %eax,%eax
  101008:	74 0c                	je     101016 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  10100a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101011:	e8 01 07 00 00       	call   101717 <pic_enable>
    }
}
  101016:	90                   	nop
  101017:	89 ec                	mov    %ebp,%esp
  101019:	5d                   	pop    %ebp
  10101a:	c3                   	ret    

0010101b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10101b:	55                   	push   %ebp
  10101c:	89 e5                	mov    %esp,%ebp
  10101e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101021:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101028:	eb 08                	jmp    101032 <lpt_putc_sub+0x17>
        delay();
  10102a:	e8 cc fd ff ff       	call   100dfb <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10102f:	ff 45 fc             	incl   -0x4(%ebp)
  101032:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101038:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10103c:	89 c2                	mov    %eax,%edx
  10103e:	ec                   	in     (%dx),%al
  10103f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101042:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101046:	84 c0                	test   %al,%al
  101048:	78 09                	js     101053 <lpt_putc_sub+0x38>
  10104a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101051:	7e d7                	jle    10102a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101053:	8b 45 08             	mov    0x8(%ebp),%eax
  101056:	0f b6 c0             	movzbl %al,%eax
  101059:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10105f:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101062:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101066:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10106a:	ee                   	out    %al,(%dx)
}
  10106b:	90                   	nop
  10106c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101072:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101076:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10107a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10107e:	ee                   	out    %al,(%dx)
}
  10107f:	90                   	nop
  101080:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101086:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10108a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10108e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101092:	ee                   	out    %al,(%dx)
}
  101093:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101094:	90                   	nop
  101095:	89 ec                	mov    %ebp,%esp
  101097:	5d                   	pop    %ebp
  101098:	c3                   	ret    

00101099 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101099:	55                   	push   %ebp
  10109a:	89 e5                	mov    %esp,%ebp
  10109c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10109f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a3:	74 0d                	je     1010b2 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a8:	89 04 24             	mov    %eax,(%esp)
  1010ab:	e8 6b ff ff ff       	call   10101b <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b0:	eb 24                	jmp    1010d6 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010b9:	e8 5d ff ff ff       	call   10101b <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010c5:	e8 51 ff ff ff       	call   10101b <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d1:	e8 45 ff ff ff       	call   10101b <lpt_putc_sub>
}
  1010d6:	90                   	nop
  1010d7:	89 ec                	mov    %ebp,%esp
  1010d9:	5d                   	pop    %ebp
  1010da:	c3                   	ret    

001010db <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010db:	55                   	push   %ebp
  1010dc:	89 e5                	mov    %esp,%ebp
  1010de:	83 ec 38             	sub    $0x38,%esp
  1010e1:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e7:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010ec:	85 c0                	test   %eax,%eax
  1010ee:	75 07                	jne    1010f7 <cga_putc+0x1c>
        c |= 0x0700;
  1010f0:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fa:	0f b6 c0             	movzbl %al,%eax
  1010fd:	83 f8 0d             	cmp    $0xd,%eax
  101100:	74 72                	je     101174 <cga_putc+0x99>
  101102:	83 f8 0d             	cmp    $0xd,%eax
  101105:	0f 8f a3 00 00 00    	jg     1011ae <cga_putc+0xd3>
  10110b:	83 f8 08             	cmp    $0x8,%eax
  10110e:	74 0a                	je     10111a <cga_putc+0x3f>
  101110:	83 f8 0a             	cmp    $0xa,%eax
  101113:	74 4c                	je     101161 <cga_putc+0x86>
  101115:	e9 94 00 00 00       	jmp    1011ae <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10111a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101121:	85 c0                	test   %eax,%eax
  101123:	0f 84 af 00 00 00    	je     1011d8 <cga_putc+0xfd>
            crt_pos --;
  101129:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101130:	48                   	dec    %eax
  101131:	0f b7 c0             	movzwl %ax,%eax
  101134:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113a:	8b 45 08             	mov    0x8(%ebp),%eax
  10113d:	98                   	cwtl   
  10113e:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101143:	98                   	cwtl   
  101144:	83 c8 20             	or     $0x20,%eax
  101147:	98                   	cwtl   
  101148:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10114e:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101155:	01 d2                	add    %edx,%edx
  101157:	01 ca                	add    %ecx,%edx
  101159:	0f b7 c0             	movzwl %ax,%eax
  10115c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115f:	eb 77                	jmp    1011d8 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101161:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101168:	83 c0 50             	add    $0x50,%eax
  10116b:	0f b7 c0             	movzwl %ax,%eax
  10116e:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101174:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10117b:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101182:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101187:	89 c8                	mov    %ecx,%eax
  101189:	f7 e2                	mul    %edx
  10118b:	c1 ea 06             	shr    $0x6,%edx
  10118e:	89 d0                	mov    %edx,%eax
  101190:	c1 e0 02             	shl    $0x2,%eax
  101193:	01 d0                	add    %edx,%eax
  101195:	c1 e0 04             	shl    $0x4,%eax
  101198:	29 c1                	sub    %eax,%ecx
  10119a:	89 ca                	mov    %ecx,%edx
  10119c:	0f b7 d2             	movzwl %dx,%edx
  10119f:	89 d8                	mov    %ebx,%eax
  1011a1:	29 d0                	sub    %edx,%eax
  1011a3:	0f b7 c0             	movzwl %ax,%eax
  1011a6:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  1011ac:	eb 2b                	jmp    1011d9 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ae:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011b4:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011bb:	8d 50 01             	lea    0x1(%eax),%edx
  1011be:	0f b7 d2             	movzwl %dx,%edx
  1011c1:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011c8:	01 c0                	add    %eax,%eax
  1011ca:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d0:	0f b7 c0             	movzwl %ax,%eax
  1011d3:	66 89 02             	mov    %ax,(%edx)
        break;
  1011d6:	eb 01                	jmp    1011d9 <cga_putc+0xfe>
        break;
  1011d8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d9:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011e0:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011e5:	76 5e                	jbe    101245 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011e7:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011ec:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011f2:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011f7:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011fe:	00 
  1011ff:	89 54 24 04          	mov    %edx,0x4(%esp)
  101203:	89 04 24             	mov    %eax,(%esp)
  101206:	e8 e1 22 00 00       	call   1034ec <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10120b:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101212:	eb 15                	jmp    101229 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101214:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10121a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10121d:	01 c0                	add    %eax,%eax
  10121f:	01 d0                	add    %edx,%eax
  101221:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101226:	ff 45 f4             	incl   -0xc(%ebp)
  101229:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101230:	7e e2                	jle    101214 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101232:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101239:	83 e8 50             	sub    $0x50,%eax
  10123c:	0f b7 c0             	movzwl %ax,%eax
  10123f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101245:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  10124c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101250:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101254:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101258:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10125c:	ee                   	out    %al,(%dx)
}
  10125d:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10125e:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101265:	c1 e8 08             	shr    $0x8,%eax
  101268:	0f b7 c0             	movzwl %ax,%eax
  10126b:	0f b6 c0             	movzbl %al,%eax
  10126e:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101275:	42                   	inc    %edx
  101276:	0f b7 d2             	movzwl %dx,%edx
  101279:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10127d:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101280:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101284:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101288:	ee                   	out    %al,(%dx)
}
  101289:	90                   	nop
    outb(addr_6845, 15);
  10128a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101291:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101295:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101299:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10129d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012a1:	ee                   	out    %al,(%dx)
}
  1012a2:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012a3:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1012aa:	0f b6 c0             	movzbl %al,%eax
  1012ad:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012b4:	42                   	inc    %edx
  1012b5:	0f b7 d2             	movzwl %dx,%edx
  1012b8:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012bc:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012bf:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012c3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012c7:	ee                   	out    %al,(%dx)
}
  1012c8:	90                   	nop
}
  1012c9:	90                   	nop
  1012ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012cd:	89 ec                	mov    %ebp,%esp
  1012cf:	5d                   	pop    %ebp
  1012d0:	c3                   	ret    

001012d1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012d1:	55                   	push   %ebp
  1012d2:	89 e5                	mov    %esp,%ebp
  1012d4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012de:	eb 08                	jmp    1012e8 <serial_putc_sub+0x17>
        delay();
  1012e0:	e8 16 fb ff ff       	call   100dfb <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012e5:	ff 45 fc             	incl   -0x4(%ebp)
  1012e8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012ee:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f2:	89 c2                	mov    %eax,%edx
  1012f4:	ec                   	in     (%dx),%al
  1012f5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012f8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012fc:	0f b6 c0             	movzbl %al,%eax
  1012ff:	83 e0 20             	and    $0x20,%eax
  101302:	85 c0                	test   %eax,%eax
  101304:	75 09                	jne    10130f <serial_putc_sub+0x3e>
  101306:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10130d:	7e d1                	jle    1012e0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10130f:	8b 45 08             	mov    0x8(%ebp),%eax
  101312:	0f b6 c0             	movzbl %al,%eax
  101315:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10131b:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10131e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101322:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101326:	ee                   	out    %al,(%dx)
}
  101327:	90                   	nop
}
  101328:	90                   	nop
  101329:	89 ec                	mov    %ebp,%esp
  10132b:	5d                   	pop    %ebp
  10132c:	c3                   	ret    

0010132d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10132d:	55                   	push   %ebp
  10132e:	89 e5                	mov    %esp,%ebp
  101330:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101333:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101337:	74 0d                	je     101346 <serial_putc+0x19>
        serial_putc_sub(c);
  101339:	8b 45 08             	mov    0x8(%ebp),%eax
  10133c:	89 04 24             	mov    %eax,(%esp)
  10133f:	e8 8d ff ff ff       	call   1012d1 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101344:	eb 24                	jmp    10136a <serial_putc+0x3d>
        serial_putc_sub('\b');
  101346:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134d:	e8 7f ff ff ff       	call   1012d1 <serial_putc_sub>
        serial_putc_sub(' ');
  101352:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101359:	e8 73 ff ff ff       	call   1012d1 <serial_putc_sub>
        serial_putc_sub('\b');
  10135e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101365:	e8 67 ff ff ff       	call   1012d1 <serial_putc_sub>
}
  10136a:	90                   	nop
  10136b:	89 ec                	mov    %ebp,%esp
  10136d:	5d                   	pop    %ebp
  10136e:	c3                   	ret    

0010136f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10136f:	55                   	push   %ebp
  101370:	89 e5                	mov    %esp,%ebp
  101372:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101375:	eb 33                	jmp    1013aa <cons_intr+0x3b>
        if (c != 0) {
  101377:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10137b:	74 2d                	je     1013aa <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10137d:	a1 84 00 11 00       	mov    0x110084,%eax
  101382:	8d 50 01             	lea    0x1(%eax),%edx
  101385:	89 15 84 00 11 00    	mov    %edx,0x110084
  10138b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10138e:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101394:	a1 84 00 11 00       	mov    0x110084,%eax
  101399:	3d 00 02 00 00       	cmp    $0x200,%eax
  10139e:	75 0a                	jne    1013aa <cons_intr+0x3b>
                cons.wpos = 0;
  1013a0:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  1013a7:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ad:	ff d0                	call   *%eax
  1013af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013b2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013b6:	75 bf                	jne    101377 <cons_intr+0x8>
            }
        }
    }
}
  1013b8:	90                   	nop
  1013b9:	90                   	nop
  1013ba:	89 ec                	mov    %ebp,%esp
  1013bc:	5d                   	pop    %ebp
  1013bd:	c3                   	ret    

001013be <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013be:	55                   	push   %ebp
  1013bf:	89 e5                	mov    %esp,%ebp
  1013c1:	83 ec 10             	sub    $0x10,%esp
  1013c4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ca:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013ce:	89 c2                	mov    %eax,%edx
  1013d0:	ec                   	in     (%dx),%al
  1013d1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013d4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013d8:	0f b6 c0             	movzbl %al,%eax
  1013db:	83 e0 01             	and    $0x1,%eax
  1013de:	85 c0                	test   %eax,%eax
  1013e0:	75 07                	jne    1013e9 <serial_proc_data+0x2b>
        return -1;
  1013e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e7:	eb 2a                	jmp    101413 <serial_proc_data+0x55>
  1013e9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ef:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013f3:	89 c2                	mov    %eax,%edx
  1013f5:	ec                   	in     (%dx),%al
  1013f6:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013f9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013fd:	0f b6 c0             	movzbl %al,%eax
  101400:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101403:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101407:	75 07                	jne    101410 <serial_proc_data+0x52>
        c = '\b';
  101409:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101410:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101413:	89 ec                	mov    %ebp,%esp
  101415:	5d                   	pop    %ebp
  101416:	c3                   	ret    

00101417 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101417:	55                   	push   %ebp
  101418:	89 e5                	mov    %esp,%ebp
  10141a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10141d:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101422:	85 c0                	test   %eax,%eax
  101424:	74 0c                	je     101432 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101426:	c7 04 24 be 13 10 00 	movl   $0x1013be,(%esp)
  10142d:	e8 3d ff ff ff       	call   10136f <cons_intr>
    }
}
  101432:	90                   	nop
  101433:	89 ec                	mov    %ebp,%esp
  101435:	5d                   	pop    %ebp
  101436:	c3                   	ret    

00101437 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101437:	55                   	push   %ebp
  101438:	89 e5                	mov    %esp,%ebp
  10143a:	83 ec 38             	sub    $0x38,%esp
  10143d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101446:	89 c2                	mov    %eax,%edx
  101448:	ec                   	in     (%dx),%al
  101449:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10144c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101450:	0f b6 c0             	movzbl %al,%eax
  101453:	83 e0 01             	and    $0x1,%eax
  101456:	85 c0                	test   %eax,%eax
  101458:	75 0a                	jne    101464 <kbd_proc_data+0x2d>
        return -1;
  10145a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10145f:	e9 56 01 00 00       	jmp    1015ba <kbd_proc_data+0x183>
  101464:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10146a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10146d:	89 c2                	mov    %eax,%edx
  10146f:	ec                   	in     (%dx),%al
  101470:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101473:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101477:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10147a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10147e:	75 17                	jne    101497 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101480:	a1 88 00 11 00       	mov    0x110088,%eax
  101485:	83 c8 40             	or     $0x40,%eax
  101488:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10148d:	b8 00 00 00 00       	mov    $0x0,%eax
  101492:	e9 23 01 00 00       	jmp    1015ba <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101497:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149b:	84 c0                	test   %al,%al
  10149d:	79 45                	jns    1014e4 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10149f:	a1 88 00 11 00       	mov    0x110088,%eax
  1014a4:	83 e0 40             	and    $0x40,%eax
  1014a7:	85 c0                	test   %eax,%eax
  1014a9:	75 08                	jne    1014b3 <kbd_proc_data+0x7c>
  1014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014af:	24 7f                	and    $0x7f,%al
  1014b1:	eb 04                	jmp    1014b7 <kbd_proc_data+0x80>
  1014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b7:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014ba:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014be:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014c5:	0c 40                	or     $0x40,%al
  1014c7:	0f b6 c0             	movzbl %al,%eax
  1014ca:	f7 d0                	not    %eax
  1014cc:	89 c2                	mov    %eax,%edx
  1014ce:	a1 88 00 11 00       	mov    0x110088,%eax
  1014d3:	21 d0                	and    %edx,%eax
  1014d5:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014da:	b8 00 00 00 00       	mov    $0x0,%eax
  1014df:	e9 d6 00 00 00       	jmp    1015ba <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014e4:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e9:	83 e0 40             	and    $0x40,%eax
  1014ec:	85 c0                	test   %eax,%eax
  1014ee:	74 11                	je     101501 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014f0:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014f4:	a1 88 00 11 00       	mov    0x110088,%eax
  1014f9:	83 e0 bf             	and    $0xffffffbf,%eax
  1014fc:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  101501:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101505:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  10150c:	0f b6 d0             	movzbl %al,%edx
  10150f:	a1 88 00 11 00       	mov    0x110088,%eax
  101514:	09 d0                	or     %edx,%eax
  101516:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10151b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151f:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  101526:	0f b6 d0             	movzbl %al,%edx
  101529:	a1 88 00 11 00       	mov    0x110088,%eax
  10152e:	31 d0                	xor    %edx,%eax
  101530:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101535:	a1 88 00 11 00       	mov    0x110088,%eax
  10153a:	83 e0 03             	and    $0x3,%eax
  10153d:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101544:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101548:	01 d0                	add    %edx,%eax
  10154a:	0f b6 00             	movzbl (%eax),%eax
  10154d:	0f b6 c0             	movzbl %al,%eax
  101550:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101553:	a1 88 00 11 00       	mov    0x110088,%eax
  101558:	83 e0 08             	and    $0x8,%eax
  10155b:	85 c0                	test   %eax,%eax
  10155d:	74 22                	je     101581 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  10155f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101563:	7e 0c                	jle    101571 <kbd_proc_data+0x13a>
  101565:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101569:	7f 06                	jg     101571 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10156b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10156f:	eb 10                	jmp    101581 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101571:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101575:	7e 0a                	jle    101581 <kbd_proc_data+0x14a>
  101577:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10157b:	7f 04                	jg     101581 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10157d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101581:	a1 88 00 11 00       	mov    0x110088,%eax
  101586:	f7 d0                	not    %eax
  101588:	83 e0 06             	and    $0x6,%eax
  10158b:	85 c0                	test   %eax,%eax
  10158d:	75 28                	jne    1015b7 <kbd_proc_data+0x180>
  10158f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101596:	75 1f                	jne    1015b7 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101598:	c7 04 24 83 39 10 00 	movl   $0x103983,(%esp)
  10159f:	e8 8c ed ff ff       	call   100330 <cprintf>
  1015a4:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015aa:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1015ae:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015b5:	ee                   	out    %al,(%dx)
}
  1015b6:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015ba:	89 ec                	mov    %ebp,%esp
  1015bc:	5d                   	pop    %ebp
  1015bd:	c3                   	ret    

001015be <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015be:	55                   	push   %ebp
  1015bf:	89 e5                	mov    %esp,%ebp
  1015c1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015c4:	c7 04 24 37 14 10 00 	movl   $0x101437,(%esp)
  1015cb:	e8 9f fd ff ff       	call   10136f <cons_intr>
}
  1015d0:	90                   	nop
  1015d1:	89 ec                	mov    %ebp,%esp
  1015d3:	5d                   	pop    %ebp
  1015d4:	c3                   	ret    

001015d5 <kbd_init>:

static void
kbd_init(void) {
  1015d5:	55                   	push   %ebp
  1015d6:	89 e5                	mov    %esp,%ebp
  1015d8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015db:	e8 de ff ff ff       	call   1015be <kbd_intr>
    pic_enable(IRQ_KBD);
  1015e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015e7:	e8 2b 01 00 00       	call   101717 <pic_enable>
}
  1015ec:	90                   	nop
  1015ed:	89 ec                	mov    %ebp,%esp
  1015ef:	5d                   	pop    %ebp
  1015f0:	c3                   	ret    

001015f1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015f1:	55                   	push   %ebp
  1015f2:	89 e5                	mov    %esp,%ebp
  1015f4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015f7:	e8 4a f8 ff ff       	call   100e46 <cga_init>
    serial_init();
  1015fc:	e8 2d f9 ff ff       	call   100f2e <serial_init>
    kbd_init();
  101601:	e8 cf ff ff ff       	call   1015d5 <kbd_init>
    if (!serial_exists) {
  101606:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  10160b:	85 c0                	test   %eax,%eax
  10160d:	75 0c                	jne    10161b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10160f:	c7 04 24 8f 39 10 00 	movl   $0x10398f,(%esp)
  101616:	e8 15 ed ff ff       	call   100330 <cprintf>
    }
}
  10161b:	90                   	nop
  10161c:	89 ec                	mov    %ebp,%esp
  10161e:	5d                   	pop    %ebp
  10161f:	c3                   	ret    

00101620 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101626:	8b 45 08             	mov    0x8(%ebp),%eax
  101629:	89 04 24             	mov    %eax,(%esp)
  10162c:	e8 68 fa ff ff       	call   101099 <lpt_putc>
    cga_putc(c);
  101631:	8b 45 08             	mov    0x8(%ebp),%eax
  101634:	89 04 24             	mov    %eax,(%esp)
  101637:	e8 9f fa ff ff       	call   1010db <cga_putc>
    serial_putc(c);
  10163c:	8b 45 08             	mov    0x8(%ebp),%eax
  10163f:	89 04 24             	mov    %eax,(%esp)
  101642:	e8 e6 fc ff ff       	call   10132d <serial_putc>
}
  101647:	90                   	nop
  101648:	89 ec                	mov    %ebp,%esp
  10164a:	5d                   	pop    %ebp
  10164b:	c3                   	ret    

0010164c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10164c:	55                   	push   %ebp
  10164d:	89 e5                	mov    %esp,%ebp
  10164f:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101652:	e8 c0 fd ff ff       	call   101417 <serial_intr>
    kbd_intr();
  101657:	e8 62 ff ff ff       	call   1015be <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10165c:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101662:	a1 84 00 11 00       	mov    0x110084,%eax
  101667:	39 c2                	cmp    %eax,%edx
  101669:	74 36                	je     1016a1 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10166b:	a1 80 00 11 00       	mov    0x110080,%eax
  101670:	8d 50 01             	lea    0x1(%eax),%edx
  101673:	89 15 80 00 11 00    	mov    %edx,0x110080
  101679:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101680:	0f b6 c0             	movzbl %al,%eax
  101683:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101686:	a1 80 00 11 00       	mov    0x110080,%eax
  10168b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101690:	75 0a                	jne    10169c <cons_getc+0x50>
            cons.rpos = 0;
  101692:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  101699:	00 00 00 
        }
        return c;
  10169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10169f:	eb 05                	jmp    1016a6 <cons_getc+0x5a>
    }
    return 0;
  1016a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1016a6:	89 ec                	mov    %ebp,%esp
  1016a8:	5d                   	pop    %ebp
  1016a9:	c3                   	ret    

001016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ad:	fb                   	sti    
}
  1016ae:	90                   	nop
    sti();
}
  1016af:	90                   	nop
  1016b0:	5d                   	pop    %ebp
  1016b1:	c3                   	ret    

001016b2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1016b5:	fa                   	cli    
}
  1016b6:	90                   	nop
    cli();
}
  1016b7:	90                   	nop
  1016b8:	5d                   	pop    %ebp
  1016b9:	c3                   	ret    

001016ba <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
  1016bd:	83 ec 14             	sub    $0x14,%esp
  1016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ca:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016d0:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016d5:	85 c0                	test   %eax,%eax
  1016d7:	74 39                	je     101712 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016dc:	0f b6 c0             	movzbl %al,%eax
  1016df:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016e5:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016e8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ec:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f0:	ee                   	out    %al,(%dx)
}
  1016f1:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016f2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f6:	c1 e8 08             	shr    $0x8,%eax
  1016f9:	0f b7 c0             	movzwl %ax,%eax
  1016fc:	0f b6 c0             	movzbl %al,%eax
  1016ff:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101705:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101708:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10170c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101710:	ee                   	out    %al,(%dx)
}
  101711:	90                   	nop
    }
}
  101712:	90                   	nop
  101713:	89 ec                	mov    %ebp,%esp
  101715:	5d                   	pop    %ebp
  101716:	c3                   	ret    

00101717 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101717:	55                   	push   %ebp
  101718:	89 e5                	mov    %esp,%ebp
  10171a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10171d:	8b 45 08             	mov    0x8(%ebp),%eax
  101720:	ba 01 00 00 00       	mov    $0x1,%edx
  101725:	88 c1                	mov    %al,%cl
  101727:	d3 e2                	shl    %cl,%edx
  101729:	89 d0                	mov    %edx,%eax
  10172b:	98                   	cwtl   
  10172c:	f7 d0                	not    %eax
  10172e:	0f bf d0             	movswl %ax,%edx
  101731:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101738:	98                   	cwtl   
  101739:	21 d0                	and    %edx,%eax
  10173b:	98                   	cwtl   
  10173c:	0f b7 c0             	movzwl %ax,%eax
  10173f:	89 04 24             	mov    %eax,(%esp)
  101742:	e8 73 ff ff ff       	call   1016ba <pic_setmask>
}
  101747:	90                   	nop
  101748:	89 ec                	mov    %ebp,%esp
  10174a:	5d                   	pop    %ebp
  10174b:	c3                   	ret    

0010174c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10174c:	55                   	push   %ebp
  10174d:	89 e5                	mov    %esp,%ebp
  10174f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101752:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  101759:	00 00 00 
  10175c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101762:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101766:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10176a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
}
  10176f:	90                   	nop
  101770:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101776:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10177a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10177e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101782:	ee                   	out    %al,(%dx)
}
  101783:	90                   	nop
  101784:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10178a:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10178e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101792:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101796:	ee                   	out    %al,(%dx)
}
  101797:	90                   	nop
  101798:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10179e:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017aa:	ee                   	out    %al,(%dx)
}
  1017ab:	90                   	nop
  1017ac:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017b2:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017b6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017ba:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017be:	ee                   	out    %al,(%dx)
}
  1017bf:	90                   	nop
  1017c0:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017c6:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ca:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017ce:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017d2:	ee                   	out    %al,(%dx)
}
  1017d3:	90                   	nop
  1017d4:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017da:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017de:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017e2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e6:	ee                   	out    %al,(%dx)
}
  1017e7:	90                   	nop
  1017e8:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017ee:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017f6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017fa:	ee                   	out    %al,(%dx)
}
  1017fb:	90                   	nop
  1017fc:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101802:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101806:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10180a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10180e:	ee                   	out    %al,(%dx)
}
  10180f:	90                   	nop
  101810:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101816:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10181e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101822:	ee                   	out    %al,(%dx)
}
  101823:	90                   	nop
  101824:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10182a:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10182e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101832:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101836:	ee                   	out    %al,(%dx)
}
  101837:	90                   	nop
  101838:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10183e:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101842:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101846:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10184a:	ee                   	out    %al,(%dx)
}
  10184b:	90                   	nop
  10184c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101852:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101856:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10185a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10185e:	ee                   	out    %al,(%dx)
}
  10185f:	90                   	nop
  101860:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101866:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10186a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10186e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101872:	ee                   	out    %al,(%dx)
}
  101873:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101874:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10187b:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101880:	74 0f                	je     101891 <pic_init+0x145>
        pic_setmask(irq_mask);
  101882:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101889:	89 04 24             	mov    %eax,(%esp)
  10188c:	e8 29 fe ff ff       	call   1016ba <pic_setmask>
    }
}
  101891:	90                   	nop
  101892:	89 ec                	mov    %ebp,%esp
  101894:	5d                   	pop    %ebp
  101895:	c3                   	ret    

00101896 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101896:	55                   	push   %ebp
  101897:	89 e5                	mov    %esp,%ebp
  101899:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10189c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018a3:	00 
  1018a4:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  1018ab:	e8 80 ea ff ff       	call   100330 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018b0:	90                   	nop
  1018b1:	89 ec                	mov    %ebp,%esp
  1018b3:	5d                   	pop    %ebp
  1018b4:	c3                   	ret    

001018b5 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b5:	55                   	push   %ebp
  1018b6:	89 e5                	mov    %esp,%ebp
  1018b8:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c2:	e9 c4 00 00 00       	jmp    10198b <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ca:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018d1:	0f b7 d0             	movzwl %ax,%edx
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	66 89 14 c5 00 01 11 	mov    %dx,0x110100(,%eax,8)
  1018de:	00 
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	66 c7 04 c5 02 01 11 	movw   $0x8,0x110102(,%eax,8)
  1018e9:	00 08 00 
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  1018f6:	00 
  1018f7:	80 e2 e0             	and    $0xe0,%dl
  1018fa:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101904:	0f b6 14 c5 04 01 11 	movzbl 0x110104(,%eax,8),%edx
  10190b:	00 
  10190c:	80 e2 1f             	and    $0x1f,%dl
  10190f:	88 14 c5 04 01 11 00 	mov    %dl,0x110104(,%eax,8)
  101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101919:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101920:	00 
  101921:	80 e2 f0             	and    $0xf0,%dl
  101924:	80 ca 0e             	or     $0xe,%dl
  101927:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101938:	00 
  101939:	80 e2 ef             	and    $0xef,%dl
  10193c:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  10194d:	00 
  10194e:	80 e2 9f             	and    $0x9f,%dl
  101951:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	0f b6 14 c5 05 01 11 	movzbl 0x110105(,%eax,8),%edx
  101962:	00 
  101963:	80 ca 80             	or     $0x80,%dl
  101966:	88 14 c5 05 01 11 00 	mov    %dl,0x110105(,%eax,8)
  10196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101970:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  101977:	c1 e8 10             	shr    $0x10,%eax
  10197a:	0f b7 d0             	movzwl %ax,%edx
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	66 89 14 c5 06 01 11 	mov    %dx,0x110106(,%eax,8)
  101987:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101988:	ff 45 fc             	incl   -0x4(%ebp)
  10198b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198e:	3d ff 00 00 00       	cmp    $0xff,%eax
  101993:	0f 86 2e ff ff ff    	jbe    1018c7 <idt_init+0x12>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101999:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  10199e:	0f b7 c0             	movzwl %ax,%eax
  1019a1:	66 a3 c8 04 11 00    	mov    %ax,0x1104c8
  1019a7:	66 c7 05 ca 04 11 00 	movw   $0x8,0x1104ca
  1019ae:	08 00 
  1019b0:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019b7:	24 e0                	and    $0xe0,%al
  1019b9:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019be:	0f b6 05 cc 04 11 00 	movzbl 0x1104cc,%eax
  1019c5:	24 1f                	and    $0x1f,%al
  1019c7:	a2 cc 04 11 00       	mov    %al,0x1104cc
  1019cc:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019d3:	24 f0                	and    $0xf0,%al
  1019d5:	0c 0e                	or     $0xe,%al
  1019d7:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019dc:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019e3:	24 ef                	and    $0xef,%al
  1019e5:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019ea:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019f1:	0c 60                	or     $0x60,%al
  1019f3:	a2 cd 04 11 00       	mov    %al,0x1104cd
  1019f8:	0f b6 05 cd 04 11 00 	movzbl 0x1104cd,%eax
  1019ff:	0c 80                	or     $0x80,%al
  101a01:	a2 cd 04 11 00       	mov    %al,0x1104cd
  101a06:	a1 c4 f7 10 00       	mov    0x10f7c4,%eax
  101a0b:	c1 e8 10             	shr    $0x10,%eax
  101a0e:	0f b7 c0             	movzwl %ax,%eax
  101a11:	66 a3 ce 04 11 00    	mov    %ax,0x1104ce
  101a17:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a21:	0f 01 18             	lidtl  (%eax)
}
  101a24:	90                   	nop
	// load the IDT
    lidt(&idt_pd);
}
  101a25:	90                   	nop
  101a26:	89 ec                	mov    %ebp,%esp
  101a28:	5d                   	pop    %ebp
  101a29:	c3                   	ret    

00101a2a <trapname>:

static const char *
trapname(int trapno) {
  101a2a:	55                   	push   %ebp
  101a2b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a30:	83 f8 13             	cmp    $0x13,%eax
  101a33:	77 0c                	ja     101a41 <trapname+0x17>
        return excnames[trapno];
  101a35:	8b 45 08             	mov    0x8(%ebp),%eax
  101a38:	8b 04 85 20 3d 10 00 	mov    0x103d20(,%eax,4),%eax
  101a3f:	eb 18                	jmp    101a59 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a41:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a45:	7e 0d                	jle    101a54 <trapname+0x2a>
  101a47:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a4b:	7f 07                	jg     101a54 <trapname+0x2a>
        return "Hardware Interrupt";
  101a4d:	b8 ca 39 10 00       	mov    $0x1039ca,%eax
  101a52:	eb 05                	jmp    101a59 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a54:	b8 dd 39 10 00       	mov    $0x1039dd,%eax
}
  101a59:	5d                   	pop    %ebp
  101a5a:	c3                   	ret    

00101a5b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a5b:	55                   	push   %ebp
  101a5c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a61:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a65:	83 f8 08             	cmp    $0x8,%eax
  101a68:	0f 94 c0             	sete   %al
  101a6b:	0f b6 c0             	movzbl %al,%eax
}
  101a6e:	5d                   	pop    %ebp
  101a6f:	c3                   	ret    

00101a70 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a70:	55                   	push   %ebp
  101a71:	89 e5                	mov    %esp,%ebp
  101a73:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a76:	8b 45 08             	mov    0x8(%ebp),%eax
  101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7d:	c7 04 24 1e 3a 10 00 	movl   $0x103a1e,(%esp)
  101a84:	e8 a7 e8 ff ff       	call   100330 <cprintf>
    print_regs(&tf->tf_regs);
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	89 04 24             	mov    %eax,(%esp)
  101a8f:	e8 8f 01 00 00       	call   101c23 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a94:	8b 45 08             	mov    0x8(%ebp),%eax
  101a97:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9f:	c7 04 24 2f 3a 10 00 	movl   $0x103a2f,(%esp)
  101aa6:	e8 85 e8 ff ff       	call   100330 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab6:	c7 04 24 42 3a 10 00 	movl   $0x103a42,(%esp)
  101abd:	e8 6e e8 ff ff       	call   100330 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acd:	c7 04 24 55 3a 10 00 	movl   $0x103a55,(%esp)
  101ad4:	e8 57 e8 ff ff       	call   100330 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  101adc:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae4:	c7 04 24 68 3a 10 00 	movl   $0x103a68,(%esp)
  101aeb:	e8 40 e8 ff ff       	call   100330 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	8b 40 30             	mov    0x30(%eax),%eax
  101af6:	89 04 24             	mov    %eax,(%esp)
  101af9:	e8 2c ff ff ff       	call   101a2a <trapname>
  101afe:	8b 55 08             	mov    0x8(%ebp),%edx
  101b01:	8b 52 30             	mov    0x30(%edx),%edx
  101b04:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b08:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b0c:	c7 04 24 7b 3a 10 00 	movl   $0x103a7b,(%esp)
  101b13:	e8 18 e8 ff ff       	call   100330 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b18:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1b:	8b 40 34             	mov    0x34(%eax),%eax
  101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b22:	c7 04 24 8d 3a 10 00 	movl   $0x103a8d,(%esp)
  101b29:	e8 02 e8 ff ff       	call   100330 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	8b 40 38             	mov    0x38(%eax),%eax
  101b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b38:	c7 04 24 9c 3a 10 00 	movl   $0x103a9c,(%esp)
  101b3f:	e8 ec e7 ff ff       	call   100330 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b44:	8b 45 08             	mov    0x8(%ebp),%eax
  101b47:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4f:	c7 04 24 ab 3a 10 00 	movl   $0x103aab,(%esp)
  101b56:	e8 d5 e7 ff ff       	call   100330 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5e:	8b 40 40             	mov    0x40(%eax),%eax
  101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b65:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101b6c:	e8 bf e7 ff ff       	call   100330 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b78:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b7f:	eb 3d                	jmp    101bbe <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	8b 50 40             	mov    0x40(%eax),%edx
  101b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b8a:	21 d0                	and    %edx,%eax
  101b8c:	85 c0                	test   %eax,%eax
  101b8e:	74 28                	je     101bb8 <print_trapframe+0x148>
  101b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b93:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b9a:	85 c0                	test   %eax,%eax
  101b9c:	74 1a                	je     101bb8 <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101ba1:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bac:	c7 04 24 cd 3a 10 00 	movl   $0x103acd,(%esp)
  101bb3:	e8 78 e7 ff ff       	call   100330 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bb8:	ff 45 f4             	incl   -0xc(%ebp)
  101bbb:	d1 65 f0             	shll   -0x10(%ebp)
  101bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc1:	83 f8 17             	cmp    $0x17,%eax
  101bc4:	76 bb                	jbe    101b81 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc9:	8b 40 40             	mov    0x40(%eax),%eax
  101bcc:	c1 e8 0c             	shr    $0xc,%eax
  101bcf:	83 e0 03             	and    $0x3,%eax
  101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd6:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101bdd:	e8 4e e7 ff ff       	call   100330 <cprintf>

    if (!trap_in_kernel(tf)) {
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	89 04 24             	mov    %eax,(%esp)
  101be8:	e8 6e fe ff ff       	call   101a5b <trap_in_kernel>
  101bed:	85 c0                	test   %eax,%eax
  101bef:	75 2d                	jne    101c1e <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf4:	8b 40 44             	mov    0x44(%eax),%eax
  101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfb:	c7 04 24 da 3a 10 00 	movl   $0x103ada,(%esp)
  101c02:	e8 29 e7 ff ff       	call   100330 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c07:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 e9 3a 10 00 	movl   $0x103ae9,(%esp)
  101c19:	e8 12 e7 ff ff       	call   100330 <cprintf>
    }
}
  101c1e:	90                   	nop
  101c1f:	89 ec                	mov    %ebp,%esp
  101c21:	5d                   	pop    %ebp
  101c22:	c3                   	ret    

00101c23 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c23:	55                   	push   %ebp
  101c24:	89 e5                	mov    %esp,%ebp
  101c26:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c29:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2c:	8b 00                	mov    (%eax),%eax
  101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c32:	c7 04 24 fc 3a 10 00 	movl   $0x103afc,(%esp)
  101c39:	e8 f2 e6 ff ff       	call   100330 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c41:	8b 40 04             	mov    0x4(%eax),%eax
  101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c48:	c7 04 24 0b 3b 10 00 	movl   $0x103b0b,(%esp)
  101c4f:	e8 dc e6 ff ff       	call   100330 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c54:	8b 45 08             	mov    0x8(%ebp),%eax
  101c57:	8b 40 08             	mov    0x8(%eax),%eax
  101c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5e:	c7 04 24 1a 3b 10 00 	movl   $0x103b1a,(%esp)
  101c65:	e8 c6 e6 ff ff       	call   100330 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6d:	8b 40 0c             	mov    0xc(%eax),%eax
  101c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c74:	c7 04 24 29 3b 10 00 	movl   $0x103b29,(%esp)
  101c7b:	e8 b0 e6 ff ff       	call   100330 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c80:	8b 45 08             	mov    0x8(%ebp),%eax
  101c83:	8b 40 10             	mov    0x10(%eax),%eax
  101c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8a:	c7 04 24 38 3b 10 00 	movl   $0x103b38,(%esp)
  101c91:	e8 9a e6 ff ff       	call   100330 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c96:	8b 45 08             	mov    0x8(%ebp),%eax
  101c99:	8b 40 14             	mov    0x14(%eax),%eax
  101c9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca0:	c7 04 24 47 3b 10 00 	movl   $0x103b47,(%esp)
  101ca7:	e8 84 e6 ff ff       	call   100330 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cac:	8b 45 08             	mov    0x8(%ebp),%eax
  101caf:	8b 40 18             	mov    0x18(%eax),%eax
  101cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb6:	c7 04 24 56 3b 10 00 	movl   $0x103b56,(%esp)
  101cbd:	e8 6e e6 ff ff       	call   100330 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc5:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccc:	c7 04 24 65 3b 10 00 	movl   $0x103b65,(%esp)
  101cd3:	e8 58 e6 ff ff       	call   100330 <cprintf>
}
  101cd8:	90                   	nop
  101cd9:	89 ec                	mov    %ebp,%esp
  101cdb:	5d                   	pop    %ebp
  101cdc:	c3                   	ret    

00101cdd <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cdd:	55                   	push   %ebp
  101cde:	89 e5                	mov    %esp,%ebp
  101ce0:	83 ec 28             	sub    $0x28,%esp
  101ce3:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char c;

    switch (tf->tf_trapno) {
  101ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce9:	8b 40 30             	mov    0x30(%eax),%eax
  101cec:	83 f8 79             	cmp    $0x79,%eax
  101cef:	0f 84 6c 01 00 00    	je     101e61 <trap_dispatch+0x184>
  101cf5:	83 f8 79             	cmp    $0x79,%eax
  101cf8:	0f 87 e0 01 00 00    	ja     101ede <trap_dispatch+0x201>
  101cfe:	83 f8 78             	cmp    $0x78,%eax
  101d01:	0f 84 d0 00 00 00    	je     101dd7 <trap_dispatch+0xfa>
  101d07:	83 f8 78             	cmp    $0x78,%eax
  101d0a:	0f 87 ce 01 00 00    	ja     101ede <trap_dispatch+0x201>
  101d10:	83 f8 2f             	cmp    $0x2f,%eax
  101d13:	0f 87 c5 01 00 00    	ja     101ede <trap_dispatch+0x201>
  101d19:	83 f8 2e             	cmp    $0x2e,%eax
  101d1c:	0f 83 f1 01 00 00    	jae    101f13 <trap_dispatch+0x236>
  101d22:	83 f8 24             	cmp    $0x24,%eax
  101d25:	74 5e                	je     101d85 <trap_dispatch+0xa8>
  101d27:	83 f8 24             	cmp    $0x24,%eax
  101d2a:	0f 87 ae 01 00 00    	ja     101ede <trap_dispatch+0x201>
  101d30:	83 f8 20             	cmp    $0x20,%eax
  101d33:	74 0a                	je     101d3f <trap_dispatch+0x62>
  101d35:	83 f8 21             	cmp    $0x21,%eax
  101d38:	74 74                	je     101dae <trap_dispatch+0xd1>
  101d3a:	e9 9f 01 00 00       	jmp    101ede <trap_dispatch+0x201>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d3f:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101d44:	40                   	inc    %eax
  101d45:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks % TICK_NUM == 0) {
  101d4a:	8b 0d 44 fe 10 00    	mov    0x10fe44,%ecx
  101d50:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d55:	89 c8                	mov    %ecx,%eax
  101d57:	f7 e2                	mul    %edx
  101d59:	c1 ea 05             	shr    $0x5,%edx
  101d5c:	89 d0                	mov    %edx,%eax
  101d5e:	c1 e0 02             	shl    $0x2,%eax
  101d61:	01 d0                	add    %edx,%eax
  101d63:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101d6a:	01 d0                	add    %edx,%eax
  101d6c:	c1 e0 02             	shl    $0x2,%eax
  101d6f:	29 c1                	sub    %eax,%ecx
  101d71:	89 ca                	mov    %ecx,%edx
  101d73:	85 d2                	test   %edx,%edx
  101d75:	0f 85 9b 01 00 00    	jne    101f16 <trap_dispatch+0x239>
            print_ticks();
  101d7b:	e8 16 fb ff ff       	call   101896 <print_ticks>
        }
        break;
  101d80:	e9 91 01 00 00       	jmp    101f16 <trap_dispatch+0x239>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d85:	e8 c2 f8 ff ff       	call   10164c <cons_getc>
  101d8a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d8d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d91:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d95:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9d:	c7 04 24 74 3b 10 00 	movl   $0x103b74,(%esp)
  101da4:	e8 87 e5 ff ff       	call   100330 <cprintf>
        break;
  101da9:	e9 6f 01 00 00       	jmp    101f1d <trap_dispatch+0x240>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dae:	e8 99 f8 ff ff       	call   10164c <cons_getc>
  101db3:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101db6:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dba:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dbe:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dc6:	c7 04 24 86 3b 10 00 	movl   $0x103b86,(%esp)
  101dcd:	e8 5e e5 ff ff       	call   100330 <cprintf>
        break;
  101dd2:	e9 46 01 00 00       	jmp    101f1d <trap_dispatch+0x240>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {//若非用户态
  101dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dda:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dde:	83 f8 1b             	cmp    $0x1b,%eax
  101de1:	0f 84 32 01 00 00    	je     101f19 <trap_dispatch+0x23c>
            switchk2u = *tf;
  101de7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  101dea:	b8 4c 00 00 00       	mov    $0x4c,%eax
  101def:	83 e0 fc             	and    $0xfffffffc,%eax
  101df2:	89 c3                	mov    %eax,%ebx
  101df4:	b8 00 00 00 00       	mov    $0x0,%eax
  101df9:	8b 14 01             	mov    (%ecx,%eax,1),%edx
  101dfc:	89 90 a0 00 11 00    	mov    %edx,0x1100a0(%eax)
  101e02:	83 c0 04             	add    $0x4,%eax
  101e05:	39 d8                	cmp    %ebx,%eax
  101e07:	72 f0                	jb     101df9 <trap_dispatch+0x11c>
            switchk2u.tf_cs = USER_CS;//调整代码段选择子
  101e09:	66 c7 05 dc 00 11 00 	movw   $0x1b,0x1100dc
  101e10:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;//调整数据段选择子
  101e12:	66 c7 05 e8 00 11 00 	movw   $0x23,0x1100e8
  101e19:	23 00 
  101e1b:	0f b7 05 e8 00 11 00 	movzwl 0x1100e8,%eax
  101e22:	66 a3 c8 00 11 00    	mov    %ax,0x1100c8
  101e28:	0f b7 05 c8 00 11 00 	movzwl 0x1100c8,%eax
  101e2f:	66 a3 cc 00 11 00    	mov    %ax,0x1100cc
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;//将esp调整为调用sub之前所指向的位置
  101e35:	8b 45 08             	mov    0x8(%ebp),%eax
  101e38:	83 c0 44             	add    $0x44,%eax
  101e3b:	a3 e4 00 11 00       	mov    %eax,0x1100e4
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;//为了保证在用户态下也能使用I/O，将IOPL降低到了ring 3
  101e40:	a1 e0 00 11 00       	mov    0x1100e0,%eax
  101e45:	0d 00 30 00 00       	or     $0x3000,%eax
  101e4a:	a3 e0 00 11 00       	mov    %eax,0x1100e0
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e52:	83 e8 04             	sub    $0x4,%eax
  101e55:	ba a0 00 11 00       	mov    $0x1100a0,%edx
  101e5a:	89 10                	mov    %edx,(%eax)
        }
        break;
  101e5c:	e9 b8 00 00 00       	jmp    101f19 <trap_dispatch+0x23c>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101e61:	8b 45 08             	mov    0x8(%ebp),%eax
  101e64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e68:	83 f8 08             	cmp    $0x8,%eax
  101e6b:	0f 84 ab 00 00 00    	je     101f1c <trap_dispatch+0x23f>
            tf->tf_cs = KERNEL_CS;//临时栈上的伪造
  101e71:	8b 45 08             	mov    0x8(%ebp),%eax
  101e74:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7d:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e83:	8b 45 08             	mov    0x8(%ebp),%eax
  101e86:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8d:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e91:	8b 45 08             	mov    0x8(%ebp),%eax
  101e94:	8b 40 40             	mov    0x40(%eax),%eax
  101e97:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101e9c:	89 c2                	mov    %eax,%edx
  101e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea1:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea7:	8b 40 44             	mov    0x44(%eax),%eax
  101eaa:	83 e8 44             	sub    $0x44,%eax
  101ead:	a3 ec 00 11 00       	mov    %eax,0x1100ec
            //在原用户栈上开辟一块大小为不带ss与esp的frame
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101eb2:	a1 ec 00 11 00       	mov    0x1100ec,%eax
  101eb7:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ebe:	00 
  101ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  101ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ec6:	89 04 24             	mov    %eax,(%esp)
  101ec9:	e8 1e 16 00 00       	call   1034ec <memmove>
            //修改tf的参数指针，在返回时栈迁移到用户态栈
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ece:	8b 15 ec 00 11 00    	mov    0x1100ec,%edx
  101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed7:	83 e8 04             	sub    $0x4,%eax
  101eda:	89 10                	mov    %edx,(%eax)
        }
        break;
  101edc:	eb 3e                	jmp    101f1c <trap_dispatch+0x23f>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ede:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ee5:	83 e0 03             	and    $0x3,%eax
  101ee8:	85 c0                	test   %eax,%eax
  101eea:	75 31                	jne    101f1d <trap_dispatch+0x240>
            print_trapframe(tf);
  101eec:	8b 45 08             	mov    0x8(%ebp),%eax
  101eef:	89 04 24             	mov    %eax,(%esp)
  101ef2:	e8 79 fb ff ff       	call   101a70 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101ef7:	c7 44 24 08 95 3b 10 	movl   $0x103b95,0x8(%esp)
  101efe:	00 
  101eff:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  101f06:	00 
  101f07:	c7 04 24 b1 3b 10 00 	movl   $0x103bb1,(%esp)
  101f0e:	e8 ae ed ff ff       	call   100cc1 <__panic>
        break;
  101f13:	90                   	nop
  101f14:	eb 07                	jmp    101f1d <trap_dispatch+0x240>
        break;
  101f16:	90                   	nop
  101f17:	eb 04                	jmp    101f1d <trap_dispatch+0x240>
        break;
  101f19:	90                   	nop
  101f1a:	eb 01                	jmp    101f1d <trap_dispatch+0x240>
        break;
  101f1c:	90                   	nop
        }
    }
}
  101f1d:	90                   	nop
  101f1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  101f21:	89 ec                	mov    %ebp,%esp
  101f23:	5d                   	pop    %ebp
  101f24:	c3                   	ret    

00101f25 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f25:	55                   	push   %ebp
  101f26:	89 e5                	mov    %esp,%ebp
  101f28:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f2e:	89 04 24             	mov    %eax,(%esp)
  101f31:	e8 a7 fd ff ff       	call   101cdd <trap_dispatch>
}
  101f36:	90                   	nop
  101f37:	89 ec                	mov    %ebp,%esp
  101f39:	5d                   	pop    %ebp
  101f3a:	c3                   	ret    

00101f3b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f3b:	1e                   	push   %ds
    pushl %es
  101f3c:	06                   	push   %es
    pushl %fs
  101f3d:	0f a0                	push   %fs
    pushl %gs
  101f3f:	0f a8                	push   %gs
    pushal
  101f41:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f42:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f47:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f49:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f4b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f4c:	e8 d4 ff ff ff       	call   101f25 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f51:	5c                   	pop    %esp

00101f52 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f52:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f53:	0f a9                	pop    %gs
    popl %fs
  101f55:	0f a1                	pop    %fs
    popl %es
  101f57:	07                   	pop    %es
    popl %ds
  101f58:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f59:	83 c4 08             	add    $0x8,%esp
    iret
  101f5c:	cf                   	iret   

00101f5d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $0
  101f5f:	6a 00                	push   $0x0
  jmp __alltraps
  101f61:	e9 d5 ff ff ff       	jmp    101f3b <__alltraps>

00101f66 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $1
  101f68:	6a 01                	push   $0x1
  jmp __alltraps
  101f6a:	e9 cc ff ff ff       	jmp    101f3b <__alltraps>

00101f6f <vector2>:
.globl vector2
vector2:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $2
  101f71:	6a 02                	push   $0x2
  jmp __alltraps
  101f73:	e9 c3 ff ff ff       	jmp    101f3b <__alltraps>

00101f78 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $3
  101f7a:	6a 03                	push   $0x3
  jmp __alltraps
  101f7c:	e9 ba ff ff ff       	jmp    101f3b <__alltraps>

00101f81 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $4
  101f83:	6a 04                	push   $0x4
  jmp __alltraps
  101f85:	e9 b1 ff ff ff       	jmp    101f3b <__alltraps>

00101f8a <vector5>:
.globl vector5
vector5:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $5
  101f8c:	6a 05                	push   $0x5
  jmp __alltraps
  101f8e:	e9 a8 ff ff ff       	jmp    101f3b <__alltraps>

00101f93 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $6
  101f95:	6a 06                	push   $0x6
  jmp __alltraps
  101f97:	e9 9f ff ff ff       	jmp    101f3b <__alltraps>

00101f9c <vector7>:
.globl vector7
vector7:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $7
  101f9e:	6a 07                	push   $0x7
  jmp __alltraps
  101fa0:	e9 96 ff ff ff       	jmp    101f3b <__alltraps>

00101fa5 <vector8>:
.globl vector8
vector8:
  pushl $8
  101fa5:	6a 08                	push   $0x8
  jmp __alltraps
  101fa7:	e9 8f ff ff ff       	jmp    101f3b <__alltraps>

00101fac <vector9>:
.globl vector9
vector9:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $9
  101fae:	6a 09                	push   $0x9
  jmp __alltraps
  101fb0:	e9 86 ff ff ff       	jmp    101f3b <__alltraps>

00101fb5 <vector10>:
.globl vector10
vector10:
  pushl $10
  101fb5:	6a 0a                	push   $0xa
  jmp __alltraps
  101fb7:	e9 7f ff ff ff       	jmp    101f3b <__alltraps>

00101fbc <vector11>:
.globl vector11
vector11:
  pushl $11
  101fbc:	6a 0b                	push   $0xb
  jmp __alltraps
  101fbe:	e9 78 ff ff ff       	jmp    101f3b <__alltraps>

00101fc3 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fc3:	6a 0c                	push   $0xc
  jmp __alltraps
  101fc5:	e9 71 ff ff ff       	jmp    101f3b <__alltraps>

00101fca <vector13>:
.globl vector13
vector13:
  pushl $13
  101fca:	6a 0d                	push   $0xd
  jmp __alltraps
  101fcc:	e9 6a ff ff ff       	jmp    101f3b <__alltraps>

00101fd1 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fd1:	6a 0e                	push   $0xe
  jmp __alltraps
  101fd3:	e9 63 ff ff ff       	jmp    101f3b <__alltraps>

00101fd8 <vector15>:
.globl vector15
vector15:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $15
  101fda:	6a 0f                	push   $0xf
  jmp __alltraps
  101fdc:	e9 5a ff ff ff       	jmp    101f3b <__alltraps>

00101fe1 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $16
  101fe3:	6a 10                	push   $0x10
  jmp __alltraps
  101fe5:	e9 51 ff ff ff       	jmp    101f3b <__alltraps>

00101fea <vector17>:
.globl vector17
vector17:
  pushl $17
  101fea:	6a 11                	push   $0x11
  jmp __alltraps
  101fec:	e9 4a ff ff ff       	jmp    101f3b <__alltraps>

00101ff1 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $18
  101ff3:	6a 12                	push   $0x12
  jmp __alltraps
  101ff5:	e9 41 ff ff ff       	jmp    101f3b <__alltraps>

00101ffa <vector19>:
.globl vector19
vector19:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $19
  101ffc:	6a 13                	push   $0x13
  jmp __alltraps
  101ffe:	e9 38 ff ff ff       	jmp    101f3b <__alltraps>

00102003 <vector20>:
.globl vector20
vector20:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $20
  102005:	6a 14                	push   $0x14
  jmp __alltraps
  102007:	e9 2f ff ff ff       	jmp    101f3b <__alltraps>

0010200c <vector21>:
.globl vector21
vector21:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $21
  10200e:	6a 15                	push   $0x15
  jmp __alltraps
  102010:	e9 26 ff ff ff       	jmp    101f3b <__alltraps>

00102015 <vector22>:
.globl vector22
vector22:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $22
  102017:	6a 16                	push   $0x16
  jmp __alltraps
  102019:	e9 1d ff ff ff       	jmp    101f3b <__alltraps>

0010201e <vector23>:
.globl vector23
vector23:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $23
  102020:	6a 17                	push   $0x17
  jmp __alltraps
  102022:	e9 14 ff ff ff       	jmp    101f3b <__alltraps>

00102027 <vector24>:
.globl vector24
vector24:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $24
  102029:	6a 18                	push   $0x18
  jmp __alltraps
  10202b:	e9 0b ff ff ff       	jmp    101f3b <__alltraps>

00102030 <vector25>:
.globl vector25
vector25:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $25
  102032:	6a 19                	push   $0x19
  jmp __alltraps
  102034:	e9 02 ff ff ff       	jmp    101f3b <__alltraps>

00102039 <vector26>:
.globl vector26
vector26:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $26
  10203b:	6a 1a                	push   $0x1a
  jmp __alltraps
  10203d:	e9 f9 fe ff ff       	jmp    101f3b <__alltraps>

00102042 <vector27>:
.globl vector27
vector27:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $27
  102044:	6a 1b                	push   $0x1b
  jmp __alltraps
  102046:	e9 f0 fe ff ff       	jmp    101f3b <__alltraps>

0010204b <vector28>:
.globl vector28
vector28:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $28
  10204d:	6a 1c                	push   $0x1c
  jmp __alltraps
  10204f:	e9 e7 fe ff ff       	jmp    101f3b <__alltraps>

00102054 <vector29>:
.globl vector29
vector29:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $29
  102056:	6a 1d                	push   $0x1d
  jmp __alltraps
  102058:	e9 de fe ff ff       	jmp    101f3b <__alltraps>

0010205d <vector30>:
.globl vector30
vector30:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $30
  10205f:	6a 1e                	push   $0x1e
  jmp __alltraps
  102061:	e9 d5 fe ff ff       	jmp    101f3b <__alltraps>

00102066 <vector31>:
.globl vector31
vector31:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $31
  102068:	6a 1f                	push   $0x1f
  jmp __alltraps
  10206a:	e9 cc fe ff ff       	jmp    101f3b <__alltraps>

0010206f <vector32>:
.globl vector32
vector32:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $32
  102071:	6a 20                	push   $0x20
  jmp __alltraps
  102073:	e9 c3 fe ff ff       	jmp    101f3b <__alltraps>

00102078 <vector33>:
.globl vector33
vector33:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $33
  10207a:	6a 21                	push   $0x21
  jmp __alltraps
  10207c:	e9 ba fe ff ff       	jmp    101f3b <__alltraps>

00102081 <vector34>:
.globl vector34
vector34:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $34
  102083:	6a 22                	push   $0x22
  jmp __alltraps
  102085:	e9 b1 fe ff ff       	jmp    101f3b <__alltraps>

0010208a <vector35>:
.globl vector35
vector35:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $35
  10208c:	6a 23                	push   $0x23
  jmp __alltraps
  10208e:	e9 a8 fe ff ff       	jmp    101f3b <__alltraps>

00102093 <vector36>:
.globl vector36
vector36:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $36
  102095:	6a 24                	push   $0x24
  jmp __alltraps
  102097:	e9 9f fe ff ff       	jmp    101f3b <__alltraps>

0010209c <vector37>:
.globl vector37
vector37:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $37
  10209e:	6a 25                	push   $0x25
  jmp __alltraps
  1020a0:	e9 96 fe ff ff       	jmp    101f3b <__alltraps>

001020a5 <vector38>:
.globl vector38
vector38:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $38
  1020a7:	6a 26                	push   $0x26
  jmp __alltraps
  1020a9:	e9 8d fe ff ff       	jmp    101f3b <__alltraps>

001020ae <vector39>:
.globl vector39
vector39:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $39
  1020b0:	6a 27                	push   $0x27
  jmp __alltraps
  1020b2:	e9 84 fe ff ff       	jmp    101f3b <__alltraps>

001020b7 <vector40>:
.globl vector40
vector40:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $40
  1020b9:	6a 28                	push   $0x28
  jmp __alltraps
  1020bb:	e9 7b fe ff ff       	jmp    101f3b <__alltraps>

001020c0 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $41
  1020c2:	6a 29                	push   $0x29
  jmp __alltraps
  1020c4:	e9 72 fe ff ff       	jmp    101f3b <__alltraps>

001020c9 <vector42>:
.globl vector42
vector42:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $42
  1020cb:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020cd:	e9 69 fe ff ff       	jmp    101f3b <__alltraps>

001020d2 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $43
  1020d4:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020d6:	e9 60 fe ff ff       	jmp    101f3b <__alltraps>

001020db <vector44>:
.globl vector44
vector44:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $44
  1020dd:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020df:	e9 57 fe ff ff       	jmp    101f3b <__alltraps>

001020e4 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $45
  1020e6:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020e8:	e9 4e fe ff ff       	jmp    101f3b <__alltraps>

001020ed <vector46>:
.globl vector46
vector46:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $46
  1020ef:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020f1:	e9 45 fe ff ff       	jmp    101f3b <__alltraps>

001020f6 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $47
  1020f8:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020fa:	e9 3c fe ff ff       	jmp    101f3b <__alltraps>

001020ff <vector48>:
.globl vector48
vector48:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $48
  102101:	6a 30                	push   $0x30
  jmp __alltraps
  102103:	e9 33 fe ff ff       	jmp    101f3b <__alltraps>

00102108 <vector49>:
.globl vector49
vector49:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $49
  10210a:	6a 31                	push   $0x31
  jmp __alltraps
  10210c:	e9 2a fe ff ff       	jmp    101f3b <__alltraps>

00102111 <vector50>:
.globl vector50
vector50:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $50
  102113:	6a 32                	push   $0x32
  jmp __alltraps
  102115:	e9 21 fe ff ff       	jmp    101f3b <__alltraps>

0010211a <vector51>:
.globl vector51
vector51:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $51
  10211c:	6a 33                	push   $0x33
  jmp __alltraps
  10211e:	e9 18 fe ff ff       	jmp    101f3b <__alltraps>

00102123 <vector52>:
.globl vector52
vector52:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $52
  102125:	6a 34                	push   $0x34
  jmp __alltraps
  102127:	e9 0f fe ff ff       	jmp    101f3b <__alltraps>

0010212c <vector53>:
.globl vector53
vector53:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $53
  10212e:	6a 35                	push   $0x35
  jmp __alltraps
  102130:	e9 06 fe ff ff       	jmp    101f3b <__alltraps>

00102135 <vector54>:
.globl vector54
vector54:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $54
  102137:	6a 36                	push   $0x36
  jmp __alltraps
  102139:	e9 fd fd ff ff       	jmp    101f3b <__alltraps>

0010213e <vector55>:
.globl vector55
vector55:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $55
  102140:	6a 37                	push   $0x37
  jmp __alltraps
  102142:	e9 f4 fd ff ff       	jmp    101f3b <__alltraps>

00102147 <vector56>:
.globl vector56
vector56:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $56
  102149:	6a 38                	push   $0x38
  jmp __alltraps
  10214b:	e9 eb fd ff ff       	jmp    101f3b <__alltraps>

00102150 <vector57>:
.globl vector57
vector57:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $57
  102152:	6a 39                	push   $0x39
  jmp __alltraps
  102154:	e9 e2 fd ff ff       	jmp    101f3b <__alltraps>

00102159 <vector58>:
.globl vector58
vector58:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $58
  10215b:	6a 3a                	push   $0x3a
  jmp __alltraps
  10215d:	e9 d9 fd ff ff       	jmp    101f3b <__alltraps>

00102162 <vector59>:
.globl vector59
vector59:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $59
  102164:	6a 3b                	push   $0x3b
  jmp __alltraps
  102166:	e9 d0 fd ff ff       	jmp    101f3b <__alltraps>

0010216b <vector60>:
.globl vector60
vector60:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $60
  10216d:	6a 3c                	push   $0x3c
  jmp __alltraps
  10216f:	e9 c7 fd ff ff       	jmp    101f3b <__alltraps>

00102174 <vector61>:
.globl vector61
vector61:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $61
  102176:	6a 3d                	push   $0x3d
  jmp __alltraps
  102178:	e9 be fd ff ff       	jmp    101f3b <__alltraps>

0010217d <vector62>:
.globl vector62
vector62:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $62
  10217f:	6a 3e                	push   $0x3e
  jmp __alltraps
  102181:	e9 b5 fd ff ff       	jmp    101f3b <__alltraps>

00102186 <vector63>:
.globl vector63
vector63:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $63
  102188:	6a 3f                	push   $0x3f
  jmp __alltraps
  10218a:	e9 ac fd ff ff       	jmp    101f3b <__alltraps>

0010218f <vector64>:
.globl vector64
vector64:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $64
  102191:	6a 40                	push   $0x40
  jmp __alltraps
  102193:	e9 a3 fd ff ff       	jmp    101f3b <__alltraps>

00102198 <vector65>:
.globl vector65
vector65:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $65
  10219a:	6a 41                	push   $0x41
  jmp __alltraps
  10219c:	e9 9a fd ff ff       	jmp    101f3b <__alltraps>

001021a1 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $66
  1021a3:	6a 42                	push   $0x42
  jmp __alltraps
  1021a5:	e9 91 fd ff ff       	jmp    101f3b <__alltraps>

001021aa <vector67>:
.globl vector67
vector67:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $67
  1021ac:	6a 43                	push   $0x43
  jmp __alltraps
  1021ae:	e9 88 fd ff ff       	jmp    101f3b <__alltraps>

001021b3 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $68
  1021b5:	6a 44                	push   $0x44
  jmp __alltraps
  1021b7:	e9 7f fd ff ff       	jmp    101f3b <__alltraps>

001021bc <vector69>:
.globl vector69
vector69:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $69
  1021be:	6a 45                	push   $0x45
  jmp __alltraps
  1021c0:	e9 76 fd ff ff       	jmp    101f3b <__alltraps>

001021c5 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $70
  1021c7:	6a 46                	push   $0x46
  jmp __alltraps
  1021c9:	e9 6d fd ff ff       	jmp    101f3b <__alltraps>

001021ce <vector71>:
.globl vector71
vector71:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $71
  1021d0:	6a 47                	push   $0x47
  jmp __alltraps
  1021d2:	e9 64 fd ff ff       	jmp    101f3b <__alltraps>

001021d7 <vector72>:
.globl vector72
vector72:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $72
  1021d9:	6a 48                	push   $0x48
  jmp __alltraps
  1021db:	e9 5b fd ff ff       	jmp    101f3b <__alltraps>

001021e0 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $73
  1021e2:	6a 49                	push   $0x49
  jmp __alltraps
  1021e4:	e9 52 fd ff ff       	jmp    101f3b <__alltraps>

001021e9 <vector74>:
.globl vector74
vector74:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $74
  1021eb:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021ed:	e9 49 fd ff ff       	jmp    101f3b <__alltraps>

001021f2 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $75
  1021f4:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021f6:	e9 40 fd ff ff       	jmp    101f3b <__alltraps>

001021fb <vector76>:
.globl vector76
vector76:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $76
  1021fd:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021ff:	e9 37 fd ff ff       	jmp    101f3b <__alltraps>

00102204 <vector77>:
.globl vector77
vector77:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $77
  102206:	6a 4d                	push   $0x4d
  jmp __alltraps
  102208:	e9 2e fd ff ff       	jmp    101f3b <__alltraps>

0010220d <vector78>:
.globl vector78
vector78:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $78
  10220f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102211:	e9 25 fd ff ff       	jmp    101f3b <__alltraps>

00102216 <vector79>:
.globl vector79
vector79:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $79
  102218:	6a 4f                	push   $0x4f
  jmp __alltraps
  10221a:	e9 1c fd ff ff       	jmp    101f3b <__alltraps>

0010221f <vector80>:
.globl vector80
vector80:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $80
  102221:	6a 50                	push   $0x50
  jmp __alltraps
  102223:	e9 13 fd ff ff       	jmp    101f3b <__alltraps>

00102228 <vector81>:
.globl vector81
vector81:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $81
  10222a:	6a 51                	push   $0x51
  jmp __alltraps
  10222c:	e9 0a fd ff ff       	jmp    101f3b <__alltraps>

00102231 <vector82>:
.globl vector82
vector82:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $82
  102233:	6a 52                	push   $0x52
  jmp __alltraps
  102235:	e9 01 fd ff ff       	jmp    101f3b <__alltraps>

0010223a <vector83>:
.globl vector83
vector83:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $83
  10223c:	6a 53                	push   $0x53
  jmp __alltraps
  10223e:	e9 f8 fc ff ff       	jmp    101f3b <__alltraps>

00102243 <vector84>:
.globl vector84
vector84:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $84
  102245:	6a 54                	push   $0x54
  jmp __alltraps
  102247:	e9 ef fc ff ff       	jmp    101f3b <__alltraps>

0010224c <vector85>:
.globl vector85
vector85:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $85
  10224e:	6a 55                	push   $0x55
  jmp __alltraps
  102250:	e9 e6 fc ff ff       	jmp    101f3b <__alltraps>

00102255 <vector86>:
.globl vector86
vector86:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $86
  102257:	6a 56                	push   $0x56
  jmp __alltraps
  102259:	e9 dd fc ff ff       	jmp    101f3b <__alltraps>

0010225e <vector87>:
.globl vector87
vector87:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $87
  102260:	6a 57                	push   $0x57
  jmp __alltraps
  102262:	e9 d4 fc ff ff       	jmp    101f3b <__alltraps>

00102267 <vector88>:
.globl vector88
vector88:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $88
  102269:	6a 58                	push   $0x58
  jmp __alltraps
  10226b:	e9 cb fc ff ff       	jmp    101f3b <__alltraps>

00102270 <vector89>:
.globl vector89
vector89:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $89
  102272:	6a 59                	push   $0x59
  jmp __alltraps
  102274:	e9 c2 fc ff ff       	jmp    101f3b <__alltraps>

00102279 <vector90>:
.globl vector90
vector90:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $90
  10227b:	6a 5a                	push   $0x5a
  jmp __alltraps
  10227d:	e9 b9 fc ff ff       	jmp    101f3b <__alltraps>

00102282 <vector91>:
.globl vector91
vector91:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $91
  102284:	6a 5b                	push   $0x5b
  jmp __alltraps
  102286:	e9 b0 fc ff ff       	jmp    101f3b <__alltraps>

0010228b <vector92>:
.globl vector92
vector92:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $92
  10228d:	6a 5c                	push   $0x5c
  jmp __alltraps
  10228f:	e9 a7 fc ff ff       	jmp    101f3b <__alltraps>

00102294 <vector93>:
.globl vector93
vector93:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $93
  102296:	6a 5d                	push   $0x5d
  jmp __alltraps
  102298:	e9 9e fc ff ff       	jmp    101f3b <__alltraps>

0010229d <vector94>:
.globl vector94
vector94:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $94
  10229f:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022a1:	e9 95 fc ff ff       	jmp    101f3b <__alltraps>

001022a6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $95
  1022a8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022aa:	e9 8c fc ff ff       	jmp    101f3b <__alltraps>

001022af <vector96>:
.globl vector96
vector96:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $96
  1022b1:	6a 60                	push   $0x60
  jmp __alltraps
  1022b3:	e9 83 fc ff ff       	jmp    101f3b <__alltraps>

001022b8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $97
  1022ba:	6a 61                	push   $0x61
  jmp __alltraps
  1022bc:	e9 7a fc ff ff       	jmp    101f3b <__alltraps>

001022c1 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $98
  1022c3:	6a 62                	push   $0x62
  jmp __alltraps
  1022c5:	e9 71 fc ff ff       	jmp    101f3b <__alltraps>

001022ca <vector99>:
.globl vector99
vector99:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $99
  1022cc:	6a 63                	push   $0x63
  jmp __alltraps
  1022ce:	e9 68 fc ff ff       	jmp    101f3b <__alltraps>

001022d3 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $100
  1022d5:	6a 64                	push   $0x64
  jmp __alltraps
  1022d7:	e9 5f fc ff ff       	jmp    101f3b <__alltraps>

001022dc <vector101>:
.globl vector101
vector101:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $101
  1022de:	6a 65                	push   $0x65
  jmp __alltraps
  1022e0:	e9 56 fc ff ff       	jmp    101f3b <__alltraps>

001022e5 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $102
  1022e7:	6a 66                	push   $0x66
  jmp __alltraps
  1022e9:	e9 4d fc ff ff       	jmp    101f3b <__alltraps>

001022ee <vector103>:
.globl vector103
vector103:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $103
  1022f0:	6a 67                	push   $0x67
  jmp __alltraps
  1022f2:	e9 44 fc ff ff       	jmp    101f3b <__alltraps>

001022f7 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $104
  1022f9:	6a 68                	push   $0x68
  jmp __alltraps
  1022fb:	e9 3b fc ff ff       	jmp    101f3b <__alltraps>

00102300 <vector105>:
.globl vector105
vector105:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $105
  102302:	6a 69                	push   $0x69
  jmp __alltraps
  102304:	e9 32 fc ff ff       	jmp    101f3b <__alltraps>

00102309 <vector106>:
.globl vector106
vector106:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $106
  10230b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10230d:	e9 29 fc ff ff       	jmp    101f3b <__alltraps>

00102312 <vector107>:
.globl vector107
vector107:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $107
  102314:	6a 6b                	push   $0x6b
  jmp __alltraps
  102316:	e9 20 fc ff ff       	jmp    101f3b <__alltraps>

0010231b <vector108>:
.globl vector108
vector108:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $108
  10231d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10231f:	e9 17 fc ff ff       	jmp    101f3b <__alltraps>

00102324 <vector109>:
.globl vector109
vector109:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $109
  102326:	6a 6d                	push   $0x6d
  jmp __alltraps
  102328:	e9 0e fc ff ff       	jmp    101f3b <__alltraps>

0010232d <vector110>:
.globl vector110
vector110:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $110
  10232f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102331:	e9 05 fc ff ff       	jmp    101f3b <__alltraps>

00102336 <vector111>:
.globl vector111
vector111:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $111
  102338:	6a 6f                	push   $0x6f
  jmp __alltraps
  10233a:	e9 fc fb ff ff       	jmp    101f3b <__alltraps>

0010233f <vector112>:
.globl vector112
vector112:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $112
  102341:	6a 70                	push   $0x70
  jmp __alltraps
  102343:	e9 f3 fb ff ff       	jmp    101f3b <__alltraps>

00102348 <vector113>:
.globl vector113
vector113:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $113
  10234a:	6a 71                	push   $0x71
  jmp __alltraps
  10234c:	e9 ea fb ff ff       	jmp    101f3b <__alltraps>

00102351 <vector114>:
.globl vector114
vector114:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $114
  102353:	6a 72                	push   $0x72
  jmp __alltraps
  102355:	e9 e1 fb ff ff       	jmp    101f3b <__alltraps>

0010235a <vector115>:
.globl vector115
vector115:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $115
  10235c:	6a 73                	push   $0x73
  jmp __alltraps
  10235e:	e9 d8 fb ff ff       	jmp    101f3b <__alltraps>

00102363 <vector116>:
.globl vector116
vector116:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $116
  102365:	6a 74                	push   $0x74
  jmp __alltraps
  102367:	e9 cf fb ff ff       	jmp    101f3b <__alltraps>

0010236c <vector117>:
.globl vector117
vector117:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $117
  10236e:	6a 75                	push   $0x75
  jmp __alltraps
  102370:	e9 c6 fb ff ff       	jmp    101f3b <__alltraps>

00102375 <vector118>:
.globl vector118
vector118:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $118
  102377:	6a 76                	push   $0x76
  jmp __alltraps
  102379:	e9 bd fb ff ff       	jmp    101f3b <__alltraps>

0010237e <vector119>:
.globl vector119
vector119:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $119
  102380:	6a 77                	push   $0x77
  jmp __alltraps
  102382:	e9 b4 fb ff ff       	jmp    101f3b <__alltraps>

00102387 <vector120>:
.globl vector120
vector120:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $120
  102389:	6a 78                	push   $0x78
  jmp __alltraps
  10238b:	e9 ab fb ff ff       	jmp    101f3b <__alltraps>

00102390 <vector121>:
.globl vector121
vector121:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $121
  102392:	6a 79                	push   $0x79
  jmp __alltraps
  102394:	e9 a2 fb ff ff       	jmp    101f3b <__alltraps>

00102399 <vector122>:
.globl vector122
vector122:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $122
  10239b:	6a 7a                	push   $0x7a
  jmp __alltraps
  10239d:	e9 99 fb ff ff       	jmp    101f3b <__alltraps>

001023a2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $123
  1023a4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023a6:	e9 90 fb ff ff       	jmp    101f3b <__alltraps>

001023ab <vector124>:
.globl vector124
vector124:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $124
  1023ad:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023af:	e9 87 fb ff ff       	jmp    101f3b <__alltraps>

001023b4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $125
  1023b6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023b8:	e9 7e fb ff ff       	jmp    101f3b <__alltraps>

001023bd <vector126>:
.globl vector126
vector126:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $126
  1023bf:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023c1:	e9 75 fb ff ff       	jmp    101f3b <__alltraps>

001023c6 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $127
  1023c8:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023ca:	e9 6c fb ff ff       	jmp    101f3b <__alltraps>

001023cf <vector128>:
.globl vector128
vector128:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $128
  1023d1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023d6:	e9 60 fb ff ff       	jmp    101f3b <__alltraps>

001023db <vector129>:
.globl vector129
vector129:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $129
  1023dd:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023e2:	e9 54 fb ff ff       	jmp    101f3b <__alltraps>

001023e7 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $130
  1023e9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023ee:	e9 48 fb ff ff       	jmp    101f3b <__alltraps>

001023f3 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $131
  1023f5:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023fa:	e9 3c fb ff ff       	jmp    101f3b <__alltraps>

001023ff <vector132>:
.globl vector132
vector132:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $132
  102401:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102406:	e9 30 fb ff ff       	jmp    101f3b <__alltraps>

0010240b <vector133>:
.globl vector133
vector133:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $133
  10240d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102412:	e9 24 fb ff ff       	jmp    101f3b <__alltraps>

00102417 <vector134>:
.globl vector134
vector134:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $134
  102419:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10241e:	e9 18 fb ff ff       	jmp    101f3b <__alltraps>

00102423 <vector135>:
.globl vector135
vector135:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $135
  102425:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10242a:	e9 0c fb ff ff       	jmp    101f3b <__alltraps>

0010242f <vector136>:
.globl vector136
vector136:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $136
  102431:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102436:	e9 00 fb ff ff       	jmp    101f3b <__alltraps>

0010243b <vector137>:
.globl vector137
vector137:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $137
  10243d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102442:	e9 f4 fa ff ff       	jmp    101f3b <__alltraps>

00102447 <vector138>:
.globl vector138
vector138:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $138
  102449:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10244e:	e9 e8 fa ff ff       	jmp    101f3b <__alltraps>

00102453 <vector139>:
.globl vector139
vector139:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $139
  102455:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10245a:	e9 dc fa ff ff       	jmp    101f3b <__alltraps>

0010245f <vector140>:
.globl vector140
vector140:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $140
  102461:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102466:	e9 d0 fa ff ff       	jmp    101f3b <__alltraps>

0010246b <vector141>:
.globl vector141
vector141:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $141
  10246d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102472:	e9 c4 fa ff ff       	jmp    101f3b <__alltraps>

00102477 <vector142>:
.globl vector142
vector142:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $142
  102479:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10247e:	e9 b8 fa ff ff       	jmp    101f3b <__alltraps>

00102483 <vector143>:
.globl vector143
vector143:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $143
  102485:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10248a:	e9 ac fa ff ff       	jmp    101f3b <__alltraps>

0010248f <vector144>:
.globl vector144
vector144:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $144
  102491:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102496:	e9 a0 fa ff ff       	jmp    101f3b <__alltraps>

0010249b <vector145>:
.globl vector145
vector145:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $145
  10249d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024a2:	e9 94 fa ff ff       	jmp    101f3b <__alltraps>

001024a7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $146
  1024a9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024ae:	e9 88 fa ff ff       	jmp    101f3b <__alltraps>

001024b3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $147
  1024b5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024ba:	e9 7c fa ff ff       	jmp    101f3b <__alltraps>

001024bf <vector148>:
.globl vector148
vector148:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $148
  1024c1:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024c6:	e9 70 fa ff ff       	jmp    101f3b <__alltraps>

001024cb <vector149>:
.globl vector149
vector149:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $149
  1024cd:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024d2:	e9 64 fa ff ff       	jmp    101f3b <__alltraps>

001024d7 <vector150>:
.globl vector150
vector150:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $150
  1024d9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024de:	e9 58 fa ff ff       	jmp    101f3b <__alltraps>

001024e3 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $151
  1024e5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024ea:	e9 4c fa ff ff       	jmp    101f3b <__alltraps>

001024ef <vector152>:
.globl vector152
vector152:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $152
  1024f1:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024f6:	e9 40 fa ff ff       	jmp    101f3b <__alltraps>

001024fb <vector153>:
.globl vector153
vector153:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $153
  1024fd:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102502:	e9 34 fa ff ff       	jmp    101f3b <__alltraps>

00102507 <vector154>:
.globl vector154
vector154:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $154
  102509:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10250e:	e9 28 fa ff ff       	jmp    101f3b <__alltraps>

00102513 <vector155>:
.globl vector155
vector155:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $155
  102515:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10251a:	e9 1c fa ff ff       	jmp    101f3b <__alltraps>

0010251f <vector156>:
.globl vector156
vector156:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $156
  102521:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102526:	e9 10 fa ff ff       	jmp    101f3b <__alltraps>

0010252b <vector157>:
.globl vector157
vector157:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $157
  10252d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102532:	e9 04 fa ff ff       	jmp    101f3b <__alltraps>

00102537 <vector158>:
.globl vector158
vector158:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $158
  102539:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10253e:	e9 f8 f9 ff ff       	jmp    101f3b <__alltraps>

00102543 <vector159>:
.globl vector159
vector159:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $159
  102545:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10254a:	e9 ec f9 ff ff       	jmp    101f3b <__alltraps>

0010254f <vector160>:
.globl vector160
vector160:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $160
  102551:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102556:	e9 e0 f9 ff ff       	jmp    101f3b <__alltraps>

0010255b <vector161>:
.globl vector161
vector161:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $161
  10255d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102562:	e9 d4 f9 ff ff       	jmp    101f3b <__alltraps>

00102567 <vector162>:
.globl vector162
vector162:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $162
  102569:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10256e:	e9 c8 f9 ff ff       	jmp    101f3b <__alltraps>

00102573 <vector163>:
.globl vector163
vector163:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $163
  102575:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10257a:	e9 bc f9 ff ff       	jmp    101f3b <__alltraps>

0010257f <vector164>:
.globl vector164
vector164:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $164
  102581:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102586:	e9 b0 f9 ff ff       	jmp    101f3b <__alltraps>

0010258b <vector165>:
.globl vector165
vector165:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $165
  10258d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102592:	e9 a4 f9 ff ff       	jmp    101f3b <__alltraps>

00102597 <vector166>:
.globl vector166
vector166:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $166
  102599:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10259e:	e9 98 f9 ff ff       	jmp    101f3b <__alltraps>

001025a3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $167
  1025a5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025aa:	e9 8c f9 ff ff       	jmp    101f3b <__alltraps>

001025af <vector168>:
.globl vector168
vector168:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $168
  1025b1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025b6:	e9 80 f9 ff ff       	jmp    101f3b <__alltraps>

001025bb <vector169>:
.globl vector169
vector169:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $169
  1025bd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025c2:	e9 74 f9 ff ff       	jmp    101f3b <__alltraps>

001025c7 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $170
  1025c9:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025ce:	e9 68 f9 ff ff       	jmp    101f3b <__alltraps>

001025d3 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $171
  1025d5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025da:	e9 5c f9 ff ff       	jmp    101f3b <__alltraps>

001025df <vector172>:
.globl vector172
vector172:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $172
  1025e1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025e6:	e9 50 f9 ff ff       	jmp    101f3b <__alltraps>

001025eb <vector173>:
.globl vector173
vector173:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $173
  1025ed:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025f2:	e9 44 f9 ff ff       	jmp    101f3b <__alltraps>

001025f7 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $174
  1025f9:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025fe:	e9 38 f9 ff ff       	jmp    101f3b <__alltraps>

00102603 <vector175>:
.globl vector175
vector175:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $175
  102605:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10260a:	e9 2c f9 ff ff       	jmp    101f3b <__alltraps>

0010260f <vector176>:
.globl vector176
vector176:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $176
  102611:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102616:	e9 20 f9 ff ff       	jmp    101f3b <__alltraps>

0010261b <vector177>:
.globl vector177
vector177:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $177
  10261d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102622:	e9 14 f9 ff ff       	jmp    101f3b <__alltraps>

00102627 <vector178>:
.globl vector178
vector178:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $178
  102629:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10262e:	e9 08 f9 ff ff       	jmp    101f3b <__alltraps>

00102633 <vector179>:
.globl vector179
vector179:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $179
  102635:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10263a:	e9 fc f8 ff ff       	jmp    101f3b <__alltraps>

0010263f <vector180>:
.globl vector180
vector180:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $180
  102641:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102646:	e9 f0 f8 ff ff       	jmp    101f3b <__alltraps>

0010264b <vector181>:
.globl vector181
vector181:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $181
  10264d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102652:	e9 e4 f8 ff ff       	jmp    101f3b <__alltraps>

00102657 <vector182>:
.globl vector182
vector182:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $182
  102659:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10265e:	e9 d8 f8 ff ff       	jmp    101f3b <__alltraps>

00102663 <vector183>:
.globl vector183
vector183:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $183
  102665:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10266a:	e9 cc f8 ff ff       	jmp    101f3b <__alltraps>

0010266f <vector184>:
.globl vector184
vector184:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $184
  102671:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102676:	e9 c0 f8 ff ff       	jmp    101f3b <__alltraps>

0010267b <vector185>:
.globl vector185
vector185:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $185
  10267d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102682:	e9 b4 f8 ff ff       	jmp    101f3b <__alltraps>

00102687 <vector186>:
.globl vector186
vector186:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $186
  102689:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10268e:	e9 a8 f8 ff ff       	jmp    101f3b <__alltraps>

00102693 <vector187>:
.globl vector187
vector187:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $187
  102695:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10269a:	e9 9c f8 ff ff       	jmp    101f3b <__alltraps>

0010269f <vector188>:
.globl vector188
vector188:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $188
  1026a1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026a6:	e9 90 f8 ff ff       	jmp    101f3b <__alltraps>

001026ab <vector189>:
.globl vector189
vector189:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $189
  1026ad:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026b2:	e9 84 f8 ff ff       	jmp    101f3b <__alltraps>

001026b7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $190
  1026b9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026be:	e9 78 f8 ff ff       	jmp    101f3b <__alltraps>

001026c3 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $191
  1026c5:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026ca:	e9 6c f8 ff ff       	jmp    101f3b <__alltraps>

001026cf <vector192>:
.globl vector192
vector192:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $192
  1026d1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026d6:	e9 60 f8 ff ff       	jmp    101f3b <__alltraps>

001026db <vector193>:
.globl vector193
vector193:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $193
  1026dd:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026e2:	e9 54 f8 ff ff       	jmp    101f3b <__alltraps>

001026e7 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $194
  1026e9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026ee:	e9 48 f8 ff ff       	jmp    101f3b <__alltraps>

001026f3 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $195
  1026f5:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026fa:	e9 3c f8 ff ff       	jmp    101f3b <__alltraps>

001026ff <vector196>:
.globl vector196
vector196:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $196
  102701:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102706:	e9 30 f8 ff ff       	jmp    101f3b <__alltraps>

0010270b <vector197>:
.globl vector197
vector197:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $197
  10270d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102712:	e9 24 f8 ff ff       	jmp    101f3b <__alltraps>

00102717 <vector198>:
.globl vector198
vector198:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $198
  102719:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10271e:	e9 18 f8 ff ff       	jmp    101f3b <__alltraps>

00102723 <vector199>:
.globl vector199
vector199:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $199
  102725:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10272a:	e9 0c f8 ff ff       	jmp    101f3b <__alltraps>

0010272f <vector200>:
.globl vector200
vector200:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $200
  102731:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102736:	e9 00 f8 ff ff       	jmp    101f3b <__alltraps>

0010273b <vector201>:
.globl vector201
vector201:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $201
  10273d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102742:	e9 f4 f7 ff ff       	jmp    101f3b <__alltraps>

00102747 <vector202>:
.globl vector202
vector202:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $202
  102749:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10274e:	e9 e8 f7 ff ff       	jmp    101f3b <__alltraps>

00102753 <vector203>:
.globl vector203
vector203:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $203
  102755:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10275a:	e9 dc f7 ff ff       	jmp    101f3b <__alltraps>

0010275f <vector204>:
.globl vector204
vector204:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $204
  102761:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102766:	e9 d0 f7 ff ff       	jmp    101f3b <__alltraps>

0010276b <vector205>:
.globl vector205
vector205:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $205
  10276d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102772:	e9 c4 f7 ff ff       	jmp    101f3b <__alltraps>

00102777 <vector206>:
.globl vector206
vector206:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $206
  102779:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10277e:	e9 b8 f7 ff ff       	jmp    101f3b <__alltraps>

00102783 <vector207>:
.globl vector207
vector207:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $207
  102785:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10278a:	e9 ac f7 ff ff       	jmp    101f3b <__alltraps>

0010278f <vector208>:
.globl vector208
vector208:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $208
  102791:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102796:	e9 a0 f7 ff ff       	jmp    101f3b <__alltraps>

0010279b <vector209>:
.globl vector209
vector209:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $209
  10279d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027a2:	e9 94 f7 ff ff       	jmp    101f3b <__alltraps>

001027a7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $210
  1027a9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027ae:	e9 88 f7 ff ff       	jmp    101f3b <__alltraps>

001027b3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $211
  1027b5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027ba:	e9 7c f7 ff ff       	jmp    101f3b <__alltraps>

001027bf <vector212>:
.globl vector212
vector212:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $212
  1027c1:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027c6:	e9 70 f7 ff ff       	jmp    101f3b <__alltraps>

001027cb <vector213>:
.globl vector213
vector213:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $213
  1027cd:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027d2:	e9 64 f7 ff ff       	jmp    101f3b <__alltraps>

001027d7 <vector214>:
.globl vector214
vector214:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $214
  1027d9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027de:	e9 58 f7 ff ff       	jmp    101f3b <__alltraps>

001027e3 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $215
  1027e5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027ea:	e9 4c f7 ff ff       	jmp    101f3b <__alltraps>

001027ef <vector216>:
.globl vector216
vector216:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $216
  1027f1:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027f6:	e9 40 f7 ff ff       	jmp    101f3b <__alltraps>

001027fb <vector217>:
.globl vector217
vector217:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $217
  1027fd:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102802:	e9 34 f7 ff ff       	jmp    101f3b <__alltraps>

00102807 <vector218>:
.globl vector218
vector218:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $218
  102809:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10280e:	e9 28 f7 ff ff       	jmp    101f3b <__alltraps>

00102813 <vector219>:
.globl vector219
vector219:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $219
  102815:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10281a:	e9 1c f7 ff ff       	jmp    101f3b <__alltraps>

0010281f <vector220>:
.globl vector220
vector220:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $220
  102821:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102826:	e9 10 f7 ff ff       	jmp    101f3b <__alltraps>

0010282b <vector221>:
.globl vector221
vector221:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $221
  10282d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102832:	e9 04 f7 ff ff       	jmp    101f3b <__alltraps>

00102837 <vector222>:
.globl vector222
vector222:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $222
  102839:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10283e:	e9 f8 f6 ff ff       	jmp    101f3b <__alltraps>

00102843 <vector223>:
.globl vector223
vector223:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $223
  102845:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10284a:	e9 ec f6 ff ff       	jmp    101f3b <__alltraps>

0010284f <vector224>:
.globl vector224
vector224:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $224
  102851:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102856:	e9 e0 f6 ff ff       	jmp    101f3b <__alltraps>

0010285b <vector225>:
.globl vector225
vector225:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $225
  10285d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102862:	e9 d4 f6 ff ff       	jmp    101f3b <__alltraps>

00102867 <vector226>:
.globl vector226
vector226:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $226
  102869:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10286e:	e9 c8 f6 ff ff       	jmp    101f3b <__alltraps>

00102873 <vector227>:
.globl vector227
vector227:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $227
  102875:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10287a:	e9 bc f6 ff ff       	jmp    101f3b <__alltraps>

0010287f <vector228>:
.globl vector228
vector228:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $228
  102881:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102886:	e9 b0 f6 ff ff       	jmp    101f3b <__alltraps>

0010288b <vector229>:
.globl vector229
vector229:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $229
  10288d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102892:	e9 a4 f6 ff ff       	jmp    101f3b <__alltraps>

00102897 <vector230>:
.globl vector230
vector230:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $230
  102899:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10289e:	e9 98 f6 ff ff       	jmp    101f3b <__alltraps>

001028a3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $231
  1028a5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028aa:	e9 8c f6 ff ff       	jmp    101f3b <__alltraps>

001028af <vector232>:
.globl vector232
vector232:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $232
  1028b1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028b6:	e9 80 f6 ff ff       	jmp    101f3b <__alltraps>

001028bb <vector233>:
.globl vector233
vector233:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $233
  1028bd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028c2:	e9 74 f6 ff ff       	jmp    101f3b <__alltraps>

001028c7 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $234
  1028c9:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028ce:	e9 68 f6 ff ff       	jmp    101f3b <__alltraps>

001028d3 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $235
  1028d5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028da:	e9 5c f6 ff ff       	jmp    101f3b <__alltraps>

001028df <vector236>:
.globl vector236
vector236:
  pushl $0
  1028df:	6a 00                	push   $0x0
  pushl $236
  1028e1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028e6:	e9 50 f6 ff ff       	jmp    101f3b <__alltraps>

001028eb <vector237>:
.globl vector237
vector237:
  pushl $0
  1028eb:	6a 00                	push   $0x0
  pushl $237
  1028ed:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028f2:	e9 44 f6 ff ff       	jmp    101f3b <__alltraps>

001028f7 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028f7:	6a 00                	push   $0x0
  pushl $238
  1028f9:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028fe:	e9 38 f6 ff ff       	jmp    101f3b <__alltraps>

00102903 <vector239>:
.globl vector239
vector239:
  pushl $0
  102903:	6a 00                	push   $0x0
  pushl $239
  102905:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10290a:	e9 2c f6 ff ff       	jmp    101f3b <__alltraps>

0010290f <vector240>:
.globl vector240
vector240:
  pushl $0
  10290f:	6a 00                	push   $0x0
  pushl $240
  102911:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102916:	e9 20 f6 ff ff       	jmp    101f3b <__alltraps>

0010291b <vector241>:
.globl vector241
vector241:
  pushl $0
  10291b:	6a 00                	push   $0x0
  pushl $241
  10291d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102922:	e9 14 f6 ff ff       	jmp    101f3b <__alltraps>

00102927 <vector242>:
.globl vector242
vector242:
  pushl $0
  102927:	6a 00                	push   $0x0
  pushl $242
  102929:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10292e:	e9 08 f6 ff ff       	jmp    101f3b <__alltraps>

00102933 <vector243>:
.globl vector243
vector243:
  pushl $0
  102933:	6a 00                	push   $0x0
  pushl $243
  102935:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10293a:	e9 fc f5 ff ff       	jmp    101f3b <__alltraps>

0010293f <vector244>:
.globl vector244
vector244:
  pushl $0
  10293f:	6a 00                	push   $0x0
  pushl $244
  102941:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102946:	e9 f0 f5 ff ff       	jmp    101f3b <__alltraps>

0010294b <vector245>:
.globl vector245
vector245:
  pushl $0
  10294b:	6a 00                	push   $0x0
  pushl $245
  10294d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102952:	e9 e4 f5 ff ff       	jmp    101f3b <__alltraps>

00102957 <vector246>:
.globl vector246
vector246:
  pushl $0
  102957:	6a 00                	push   $0x0
  pushl $246
  102959:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10295e:	e9 d8 f5 ff ff       	jmp    101f3b <__alltraps>

00102963 <vector247>:
.globl vector247
vector247:
  pushl $0
  102963:	6a 00                	push   $0x0
  pushl $247
  102965:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10296a:	e9 cc f5 ff ff       	jmp    101f3b <__alltraps>

0010296f <vector248>:
.globl vector248
vector248:
  pushl $0
  10296f:	6a 00                	push   $0x0
  pushl $248
  102971:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102976:	e9 c0 f5 ff ff       	jmp    101f3b <__alltraps>

0010297b <vector249>:
.globl vector249
vector249:
  pushl $0
  10297b:	6a 00                	push   $0x0
  pushl $249
  10297d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102982:	e9 b4 f5 ff ff       	jmp    101f3b <__alltraps>

00102987 <vector250>:
.globl vector250
vector250:
  pushl $0
  102987:	6a 00                	push   $0x0
  pushl $250
  102989:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10298e:	e9 a8 f5 ff ff       	jmp    101f3b <__alltraps>

00102993 <vector251>:
.globl vector251
vector251:
  pushl $0
  102993:	6a 00                	push   $0x0
  pushl $251
  102995:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10299a:	e9 9c f5 ff ff       	jmp    101f3b <__alltraps>

0010299f <vector252>:
.globl vector252
vector252:
  pushl $0
  10299f:	6a 00                	push   $0x0
  pushl $252
  1029a1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029a6:	e9 90 f5 ff ff       	jmp    101f3b <__alltraps>

001029ab <vector253>:
.globl vector253
vector253:
  pushl $0
  1029ab:	6a 00                	push   $0x0
  pushl $253
  1029ad:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029b2:	e9 84 f5 ff ff       	jmp    101f3b <__alltraps>

001029b7 <vector254>:
.globl vector254
vector254:
  pushl $0
  1029b7:	6a 00                	push   $0x0
  pushl $254
  1029b9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029be:	e9 78 f5 ff ff       	jmp    101f3b <__alltraps>

001029c3 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029c3:	6a 00                	push   $0x0
  pushl $255
  1029c5:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029ca:	e9 6c f5 ff ff       	jmp    101f3b <__alltraps>

001029cf <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029cf:	55                   	push   %ebp
  1029d0:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d5:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029d8:	b8 23 00 00 00       	mov    $0x23,%eax
  1029dd:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029df:	b8 23 00 00 00       	mov    $0x23,%eax
  1029e4:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029e6:	b8 10 00 00 00       	mov    $0x10,%eax
  1029eb:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029ed:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f2:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029f4:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f9:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029fb:	ea 02 2a 10 00 08 00 	ljmp   $0x8,$0x102a02
}
  102a02:	90                   	nop
  102a03:	5d                   	pop    %ebp
  102a04:	c3                   	ret    

00102a05 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a05:	55                   	push   %ebp
  102a06:	89 e5                	mov    %esp,%ebp
  102a08:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a0b:	b8 00 09 11 00       	mov    $0x110900,%eax
  102a10:	05 00 04 00 00       	add    $0x400,%eax
  102a15:	a3 04 0d 11 00       	mov    %eax,0x110d04
    ts.ts_ss0 = KERNEL_DS;
  102a1a:	66 c7 05 08 0d 11 00 	movw   $0x10,0x110d08
  102a21:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a23:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102a2a:	68 00 
  102a2c:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a31:	0f b7 c0             	movzwl %ax,%eax
  102a34:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  102a3a:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102a3f:	c1 e8 10             	shr    $0x10,%eax
  102a42:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  102a47:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a4e:	24 f0                	and    $0xf0,%al
  102a50:	0c 09                	or     $0x9,%al
  102a52:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a57:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a5e:	0c 10                	or     $0x10,%al
  102a60:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a65:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a6c:	24 9f                	and    $0x9f,%al
  102a6e:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a73:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102a7a:	0c 80                	or     $0x80,%al
  102a7c:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  102a81:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a88:	24 f0                	and    $0xf0,%al
  102a8a:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a8f:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102a96:	24 ef                	and    $0xef,%al
  102a98:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102a9d:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102aa4:	24 df                	and    $0xdf,%al
  102aa6:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102aab:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ab2:	0c 40                	or     $0x40,%al
  102ab4:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ab9:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102ac0:	24 7f                	and    $0x7f,%al
  102ac2:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102ac7:	b8 00 0d 11 00       	mov    $0x110d00,%eax
  102acc:	c1 e8 18             	shr    $0x18,%eax
  102acf:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102ad4:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102adb:	24 ef                	and    $0xef,%al
  102add:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102ae2:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102ae9:	e8 e1 fe ff ff       	call   1029cf <lgdt>
  102aee:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102af4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102af8:	0f 00 d8             	ltr    %ax
}
  102afb:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102afc:	90                   	nop
  102afd:	89 ec                	mov    %ebp,%esp
  102aff:	5d                   	pop    %ebp
  102b00:	c3                   	ret    

00102b01 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b01:	55                   	push   %ebp
  102b02:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b04:	e8 fc fe ff ff       	call   102a05 <gdt_init>
}
  102b09:	90                   	nop
  102b0a:	5d                   	pop    %ebp
  102b0b:	c3                   	ret    

00102b0c <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102b0c:	55                   	push   %ebp
  102b0d:	89 e5                	mov    %esp,%ebp
  102b0f:	83 ec 58             	sub    $0x58,%esp
  102b12:	8b 45 10             	mov    0x10(%ebp),%eax
  102b15:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b18:	8b 45 14             	mov    0x14(%ebp),%eax
  102b1b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102b1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b21:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b24:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b27:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102b2a:	8b 45 18             	mov    0x18(%ebp),%eax
  102b2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b36:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b39:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b46:	74 1c                	je     102b64 <printnum+0x58>
  102b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  102b50:	f7 75 e4             	divl   -0x1c(%ebp)
  102b53:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b59:	ba 00 00 00 00       	mov    $0x0,%edx
  102b5e:	f7 75 e4             	divl   -0x1c(%ebp)
  102b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b6a:	f7 75 e4             	divl   -0x1c(%ebp)
  102b6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b70:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b79:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b7c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b82:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b85:	8b 45 18             	mov    0x18(%ebp),%eax
  102b88:	ba 00 00 00 00       	mov    $0x0,%edx
  102b8d:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  102b90:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102b93:	19 d1                	sbb    %edx,%ecx
  102b95:	72 4c                	jb     102be3 <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b97:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b9d:	8b 45 20             	mov    0x20(%ebp),%eax
  102ba0:	89 44 24 18          	mov    %eax,0x18(%esp)
  102ba4:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ba8:	8b 45 18             	mov    0x18(%ebp),%eax
  102bab:	89 44 24 10          	mov    %eax,0x10(%esp)
  102baf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bb9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc7:	89 04 24             	mov    %eax,(%esp)
  102bca:	e8 3d ff ff ff       	call   102b0c <printnum>
  102bcf:	eb 1b                	jmp    102bec <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102bd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bd8:	8b 45 20             	mov    0x20(%ebp),%eax
  102bdb:	89 04 24             	mov    %eax,(%esp)
  102bde:	8b 45 08             	mov    0x8(%ebp),%eax
  102be1:	ff d0                	call   *%eax
        while (-- width > 0)
  102be3:	ff 4d 1c             	decl   0x1c(%ebp)
  102be6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102bea:	7f e5                	jg     102bd1 <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102bec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bef:	05 f0 3d 10 00       	add    $0x103df0,%eax
  102bf4:	0f b6 00             	movzbl (%eax),%eax
  102bf7:	0f be c0             	movsbl %al,%eax
  102bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bfd:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c01:	89 04 24             	mov    %eax,(%esp)
  102c04:	8b 45 08             	mov    0x8(%ebp),%eax
  102c07:	ff d0                	call   *%eax
}
  102c09:	90                   	nop
  102c0a:	89 ec                	mov    %ebp,%esp
  102c0c:	5d                   	pop    %ebp
  102c0d:	c3                   	ret    

00102c0e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102c0e:	55                   	push   %ebp
  102c0f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c11:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c15:	7e 14                	jle    102c2b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102c17:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1a:	8b 00                	mov    (%eax),%eax
  102c1c:	8d 48 08             	lea    0x8(%eax),%ecx
  102c1f:	8b 55 08             	mov    0x8(%ebp),%edx
  102c22:	89 0a                	mov    %ecx,(%edx)
  102c24:	8b 50 04             	mov    0x4(%eax),%edx
  102c27:	8b 00                	mov    (%eax),%eax
  102c29:	eb 30                	jmp    102c5b <getuint+0x4d>
    }
    else if (lflag) {
  102c2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c2f:	74 16                	je     102c47 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102c31:	8b 45 08             	mov    0x8(%ebp),%eax
  102c34:	8b 00                	mov    (%eax),%eax
  102c36:	8d 48 04             	lea    0x4(%eax),%ecx
  102c39:	8b 55 08             	mov    0x8(%ebp),%edx
  102c3c:	89 0a                	mov    %ecx,(%edx)
  102c3e:	8b 00                	mov    (%eax),%eax
  102c40:	ba 00 00 00 00       	mov    $0x0,%edx
  102c45:	eb 14                	jmp    102c5b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102c47:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4a:	8b 00                	mov    (%eax),%eax
  102c4c:	8d 48 04             	lea    0x4(%eax),%ecx
  102c4f:	8b 55 08             	mov    0x8(%ebp),%edx
  102c52:	89 0a                	mov    %ecx,(%edx)
  102c54:	8b 00                	mov    (%eax),%eax
  102c56:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c5b:	5d                   	pop    %ebp
  102c5c:	c3                   	ret    

00102c5d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c5d:	55                   	push   %ebp
  102c5e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c60:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c64:	7e 14                	jle    102c7a <getint+0x1d>
        return va_arg(*ap, long long);
  102c66:	8b 45 08             	mov    0x8(%ebp),%eax
  102c69:	8b 00                	mov    (%eax),%eax
  102c6b:	8d 48 08             	lea    0x8(%eax),%ecx
  102c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  102c71:	89 0a                	mov    %ecx,(%edx)
  102c73:	8b 50 04             	mov    0x4(%eax),%edx
  102c76:	8b 00                	mov    (%eax),%eax
  102c78:	eb 28                	jmp    102ca2 <getint+0x45>
    }
    else if (lflag) {
  102c7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c7e:	74 12                	je     102c92 <getint+0x35>
        return va_arg(*ap, long);
  102c80:	8b 45 08             	mov    0x8(%ebp),%eax
  102c83:	8b 00                	mov    (%eax),%eax
  102c85:	8d 48 04             	lea    0x4(%eax),%ecx
  102c88:	8b 55 08             	mov    0x8(%ebp),%edx
  102c8b:	89 0a                	mov    %ecx,(%edx)
  102c8d:	8b 00                	mov    (%eax),%eax
  102c8f:	99                   	cltd   
  102c90:	eb 10                	jmp    102ca2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c92:	8b 45 08             	mov    0x8(%ebp),%eax
  102c95:	8b 00                	mov    (%eax),%eax
  102c97:	8d 48 04             	lea    0x4(%eax),%ecx
  102c9a:	8b 55 08             	mov    0x8(%ebp),%edx
  102c9d:	89 0a                	mov    %ecx,(%edx)
  102c9f:	8b 00                	mov    (%eax),%eax
  102ca1:	99                   	cltd   
    }
}
  102ca2:	5d                   	pop    %ebp
  102ca3:	c3                   	ret    

00102ca4 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ca4:	55                   	push   %ebp
  102ca5:	89 e5                	mov    %esp,%ebp
  102ca7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102caa:	8d 45 14             	lea    0x14(%ebp),%eax
  102cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  102cba:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc8:	89 04 24             	mov    %eax,(%esp)
  102ccb:	e8 05 00 00 00       	call   102cd5 <vprintfmt>
    va_end(ap);
}
  102cd0:	90                   	nop
  102cd1:	89 ec                	mov    %ebp,%esp
  102cd3:	5d                   	pop    %ebp
  102cd4:	c3                   	ret    

00102cd5 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102cd5:	55                   	push   %ebp
  102cd6:	89 e5                	mov    %esp,%ebp
  102cd8:	56                   	push   %esi
  102cd9:	53                   	push   %ebx
  102cda:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cdd:	eb 17                	jmp    102cf6 <vprintfmt+0x21>
            if (ch == '\0') {
  102cdf:	85 db                	test   %ebx,%ebx
  102ce1:	0f 84 bf 03 00 00    	je     1030a6 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cee:	89 1c 24             	mov    %ebx,(%esp)
  102cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf4:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  102cf9:	8d 50 01             	lea    0x1(%eax),%edx
  102cfc:	89 55 10             	mov    %edx,0x10(%ebp)
  102cff:	0f b6 00             	movzbl (%eax),%eax
  102d02:	0f b6 d8             	movzbl %al,%ebx
  102d05:	83 fb 25             	cmp    $0x25,%ebx
  102d08:	75 d5                	jne    102cdf <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102d0a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102d0e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d18:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d1b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d25:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d28:	8b 45 10             	mov    0x10(%ebp),%eax
  102d2b:	8d 50 01             	lea    0x1(%eax),%edx
  102d2e:	89 55 10             	mov    %edx,0x10(%ebp)
  102d31:	0f b6 00             	movzbl (%eax),%eax
  102d34:	0f b6 d8             	movzbl %al,%ebx
  102d37:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102d3a:	83 f8 55             	cmp    $0x55,%eax
  102d3d:	0f 87 37 03 00 00    	ja     10307a <vprintfmt+0x3a5>
  102d43:	8b 04 85 14 3e 10 00 	mov    0x103e14(,%eax,4),%eax
  102d4a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102d4c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d50:	eb d6                	jmp    102d28 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d52:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d56:	eb d0                	jmp    102d28 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d58:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d62:	89 d0                	mov    %edx,%eax
  102d64:	c1 e0 02             	shl    $0x2,%eax
  102d67:	01 d0                	add    %edx,%eax
  102d69:	01 c0                	add    %eax,%eax
  102d6b:	01 d8                	add    %ebx,%eax
  102d6d:	83 e8 30             	sub    $0x30,%eax
  102d70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d73:	8b 45 10             	mov    0x10(%ebp),%eax
  102d76:	0f b6 00             	movzbl (%eax),%eax
  102d79:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d7c:	83 fb 2f             	cmp    $0x2f,%ebx
  102d7f:	7e 38                	jle    102db9 <vprintfmt+0xe4>
  102d81:	83 fb 39             	cmp    $0x39,%ebx
  102d84:	7f 33                	jg     102db9 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102d86:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102d89:	eb d4                	jmp    102d5f <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102d8b:	8b 45 14             	mov    0x14(%ebp),%eax
  102d8e:	8d 50 04             	lea    0x4(%eax),%edx
  102d91:	89 55 14             	mov    %edx,0x14(%ebp)
  102d94:	8b 00                	mov    (%eax),%eax
  102d96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d99:	eb 1f                	jmp    102dba <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102d9b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d9f:	79 87                	jns    102d28 <vprintfmt+0x53>
                width = 0;
  102da1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102da8:	e9 7b ff ff ff       	jmp    102d28 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102dad:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102db4:	e9 6f ff ff ff       	jmp    102d28 <vprintfmt+0x53>
            goto process_precision;
  102db9:	90                   	nop

        process_precision:
            if (width < 0)
  102dba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dbe:	0f 89 64 ff ff ff    	jns    102d28 <vprintfmt+0x53>
                width = precision, precision = -1;
  102dc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102dc7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102dca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102dd1:	e9 52 ff ff ff       	jmp    102d28 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102dd6:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102dd9:	e9 4a ff ff ff       	jmp    102d28 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102dde:	8b 45 14             	mov    0x14(%ebp),%eax
  102de1:	8d 50 04             	lea    0x4(%eax),%edx
  102de4:	89 55 14             	mov    %edx,0x14(%ebp)
  102de7:	8b 00                	mov    (%eax),%eax
  102de9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102dec:	89 54 24 04          	mov    %edx,0x4(%esp)
  102df0:	89 04 24             	mov    %eax,(%esp)
  102df3:	8b 45 08             	mov    0x8(%ebp),%eax
  102df6:	ff d0                	call   *%eax
            break;
  102df8:	e9 a4 02 00 00       	jmp    1030a1 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102dfd:	8b 45 14             	mov    0x14(%ebp),%eax
  102e00:	8d 50 04             	lea    0x4(%eax),%edx
  102e03:	89 55 14             	mov    %edx,0x14(%ebp)
  102e06:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102e08:	85 db                	test   %ebx,%ebx
  102e0a:	79 02                	jns    102e0e <vprintfmt+0x139>
                err = -err;
  102e0c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102e0e:	83 fb 06             	cmp    $0x6,%ebx
  102e11:	7f 0b                	jg     102e1e <vprintfmt+0x149>
  102e13:	8b 34 9d d4 3d 10 00 	mov    0x103dd4(,%ebx,4),%esi
  102e1a:	85 f6                	test   %esi,%esi
  102e1c:	75 23                	jne    102e41 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102e1e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102e22:	c7 44 24 08 01 3e 10 	movl   $0x103e01,0x8(%esp)
  102e29:	00 
  102e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e31:	8b 45 08             	mov    0x8(%ebp),%eax
  102e34:	89 04 24             	mov    %eax,(%esp)
  102e37:	e8 68 fe ff ff       	call   102ca4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102e3c:	e9 60 02 00 00       	jmp    1030a1 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102e41:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102e45:	c7 44 24 08 0a 3e 10 	movl   $0x103e0a,0x8(%esp)
  102e4c:	00 
  102e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	89 04 24             	mov    %eax,(%esp)
  102e5a:	e8 45 fe ff ff       	call   102ca4 <printfmt>
            break;
  102e5f:	e9 3d 02 00 00       	jmp    1030a1 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e64:	8b 45 14             	mov    0x14(%ebp),%eax
  102e67:	8d 50 04             	lea    0x4(%eax),%edx
  102e6a:	89 55 14             	mov    %edx,0x14(%ebp)
  102e6d:	8b 30                	mov    (%eax),%esi
  102e6f:	85 f6                	test   %esi,%esi
  102e71:	75 05                	jne    102e78 <vprintfmt+0x1a3>
                p = "(null)";
  102e73:	be 0d 3e 10 00       	mov    $0x103e0d,%esi
            }
            if (width > 0 && padc != '-') {
  102e78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e7c:	7e 76                	jle    102ef4 <vprintfmt+0x21f>
  102e7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e82:	74 70                	je     102ef4 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e87:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8b:	89 34 24             	mov    %esi,(%esp)
  102e8e:	e8 16 03 00 00       	call   1031a9 <strnlen>
  102e93:	89 c2                	mov    %eax,%edx
  102e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e98:	29 d0                	sub    %edx,%eax
  102e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e9d:	eb 16                	jmp    102eb5 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102e9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ea6:	89 54 24 04          	mov    %edx,0x4(%esp)
  102eaa:	89 04 24             	mov    %eax,(%esp)
  102ead:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb0:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102eb2:	ff 4d e8             	decl   -0x18(%ebp)
  102eb5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102eb9:	7f e4                	jg     102e9f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ebb:	eb 37                	jmp    102ef4 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ebd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ec1:	74 1f                	je     102ee2 <vprintfmt+0x20d>
  102ec3:	83 fb 1f             	cmp    $0x1f,%ebx
  102ec6:	7e 05                	jle    102ecd <vprintfmt+0x1f8>
  102ec8:	83 fb 7e             	cmp    $0x7e,%ebx
  102ecb:	7e 15                	jle    102ee2 <vprintfmt+0x20d>
                    putch('?', putdat);
  102ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102edb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ede:	ff d0                	call   *%eax
  102ee0:	eb 0f                	jmp    102ef1 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ee9:	89 1c 24             	mov    %ebx,(%esp)
  102eec:	8b 45 08             	mov    0x8(%ebp),%eax
  102eef:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ef1:	ff 4d e8             	decl   -0x18(%ebp)
  102ef4:	89 f0                	mov    %esi,%eax
  102ef6:	8d 70 01             	lea    0x1(%eax),%esi
  102ef9:	0f b6 00             	movzbl (%eax),%eax
  102efc:	0f be d8             	movsbl %al,%ebx
  102eff:	85 db                	test   %ebx,%ebx
  102f01:	74 27                	je     102f2a <vprintfmt+0x255>
  102f03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f07:	78 b4                	js     102ebd <vprintfmt+0x1e8>
  102f09:	ff 4d e4             	decl   -0x1c(%ebp)
  102f0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f10:	79 ab                	jns    102ebd <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102f12:	eb 16                	jmp    102f2a <vprintfmt+0x255>
                putch(' ', putdat);
  102f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f17:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f1b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102f22:	8b 45 08             	mov    0x8(%ebp),%eax
  102f25:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102f27:	ff 4d e8             	decl   -0x18(%ebp)
  102f2a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f2e:	7f e4                	jg     102f14 <vprintfmt+0x23f>
            }
            break;
  102f30:	e9 6c 01 00 00       	jmp    1030a1 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f3c:	8d 45 14             	lea    0x14(%ebp),%eax
  102f3f:	89 04 24             	mov    %eax,(%esp)
  102f42:	e8 16 fd ff ff       	call   102c5d <getint>
  102f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f53:	85 d2                	test   %edx,%edx
  102f55:	79 26                	jns    102f7d <vprintfmt+0x2a8>
                putch('-', putdat);
  102f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f5e:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f65:	8b 45 08             	mov    0x8(%ebp),%eax
  102f68:	ff d0                	call   *%eax
                num = -(long long)num;
  102f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f70:	f7 d8                	neg    %eax
  102f72:	83 d2 00             	adc    $0x0,%edx
  102f75:	f7 da                	neg    %edx
  102f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f7d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f84:	e9 a8 00 00 00       	jmp    103031 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f90:	8d 45 14             	lea    0x14(%ebp),%eax
  102f93:	89 04 24             	mov    %eax,(%esp)
  102f96:	e8 73 fc ff ff       	call   102c0e <getuint>
  102f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102fa1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102fa8:	e9 84 00 00 00       	jmp    103031 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102fad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb4:	8d 45 14             	lea    0x14(%ebp),%eax
  102fb7:	89 04 24             	mov    %eax,(%esp)
  102fba:	e8 4f fc ff ff       	call   102c0e <getuint>
  102fbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102fc5:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102fcc:	eb 63                	jmp    103031 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd5:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdf:	ff d0                	call   *%eax
            putch('x', putdat);
  102fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe8:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102fef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff2:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102ff4:	8b 45 14             	mov    0x14(%ebp),%eax
  102ff7:	8d 50 04             	lea    0x4(%eax),%edx
  102ffa:	89 55 14             	mov    %edx,0x14(%ebp)
  102ffd:	8b 00                	mov    (%eax),%eax
  102fff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103002:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103009:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103010:	eb 1f                	jmp    103031 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103012:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103015:	89 44 24 04          	mov    %eax,0x4(%esp)
  103019:	8d 45 14             	lea    0x14(%ebp),%eax
  10301c:	89 04 24             	mov    %eax,(%esp)
  10301f:	e8 ea fb ff ff       	call   102c0e <getuint>
  103024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103027:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  10302a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103031:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103038:	89 54 24 18          	mov    %edx,0x18(%esp)
  10303c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10303f:	89 54 24 14          	mov    %edx,0x14(%esp)
  103043:	89 44 24 10          	mov    %eax,0x10(%esp)
  103047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10304a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10304d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103051:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103055:	8b 45 0c             	mov    0xc(%ebp),%eax
  103058:	89 44 24 04          	mov    %eax,0x4(%esp)
  10305c:	8b 45 08             	mov    0x8(%ebp),%eax
  10305f:	89 04 24             	mov    %eax,(%esp)
  103062:	e8 a5 fa ff ff       	call   102b0c <printnum>
            break;
  103067:	eb 38                	jmp    1030a1 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103069:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103070:	89 1c 24             	mov    %ebx,(%esp)
  103073:	8b 45 08             	mov    0x8(%ebp),%eax
  103076:	ff d0                	call   *%eax
            break;
  103078:	eb 27                	jmp    1030a1 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10307a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103081:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103088:	8b 45 08             	mov    0x8(%ebp),%eax
  10308b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10308d:	ff 4d 10             	decl   0x10(%ebp)
  103090:	eb 03                	jmp    103095 <vprintfmt+0x3c0>
  103092:	ff 4d 10             	decl   0x10(%ebp)
  103095:	8b 45 10             	mov    0x10(%ebp),%eax
  103098:	48                   	dec    %eax
  103099:	0f b6 00             	movzbl (%eax),%eax
  10309c:	3c 25                	cmp    $0x25,%al
  10309e:	75 f2                	jne    103092 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1030a0:	90                   	nop
    while (1) {
  1030a1:	e9 37 fc ff ff       	jmp    102cdd <vprintfmt+0x8>
                return;
  1030a6:	90                   	nop
        }
    }
}
  1030a7:	83 c4 40             	add    $0x40,%esp
  1030aa:	5b                   	pop    %ebx
  1030ab:	5e                   	pop    %esi
  1030ac:	5d                   	pop    %ebp
  1030ad:	c3                   	ret    

001030ae <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030ae:	55                   	push   %ebp
  1030af:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b4:	8b 40 08             	mov    0x8(%eax),%eax
  1030b7:	8d 50 01             	lea    0x1(%eax),%edx
  1030ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bd:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1030c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c3:	8b 10                	mov    (%eax),%edx
  1030c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c8:	8b 40 04             	mov    0x4(%eax),%eax
  1030cb:	39 c2                	cmp    %eax,%edx
  1030cd:	73 12                	jae    1030e1 <sprintputch+0x33>
        *b->buf ++ = ch;
  1030cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d2:	8b 00                	mov    (%eax),%eax
  1030d4:	8d 48 01             	lea    0x1(%eax),%ecx
  1030d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030da:	89 0a                	mov    %ecx,(%edx)
  1030dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1030df:	88 10                	mov    %dl,(%eax)
    }
}
  1030e1:	90                   	nop
  1030e2:	5d                   	pop    %ebp
  1030e3:	c3                   	ret    

001030e4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1030e4:	55                   	push   %ebp
  1030e5:	89 e5                	mov    %esp,%ebp
  1030e7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1030ea:	8d 45 14             	lea    0x14(%ebp),%eax
  1030ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1030f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1030fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103101:	89 44 24 04          	mov    %eax,0x4(%esp)
  103105:	8b 45 08             	mov    0x8(%ebp),%eax
  103108:	89 04 24             	mov    %eax,(%esp)
  10310b:	e8 0a 00 00 00       	call   10311a <vsnprintf>
  103110:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103113:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103116:	89 ec                	mov    %ebp,%esp
  103118:	5d                   	pop    %ebp
  103119:	c3                   	ret    

0010311a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10311a:	55                   	push   %ebp
  10311b:	89 e5                	mov    %esp,%ebp
  10311d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103120:	8b 45 08             	mov    0x8(%ebp),%eax
  103123:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103126:	8b 45 0c             	mov    0xc(%ebp),%eax
  103129:	8d 50 ff             	lea    -0x1(%eax),%edx
  10312c:	8b 45 08             	mov    0x8(%ebp),%eax
  10312f:	01 d0                	add    %edx,%eax
  103131:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103134:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10313b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10313f:	74 0a                	je     10314b <vsnprintf+0x31>
  103141:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103144:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103147:	39 c2                	cmp    %eax,%edx
  103149:	76 07                	jbe    103152 <vsnprintf+0x38>
        return -E_INVAL;
  10314b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103150:	eb 2a                	jmp    10317c <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103152:	8b 45 14             	mov    0x14(%ebp),%eax
  103155:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103159:	8b 45 10             	mov    0x10(%ebp),%eax
  10315c:	89 44 24 08          	mov    %eax,0x8(%esp)
  103160:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103163:	89 44 24 04          	mov    %eax,0x4(%esp)
  103167:	c7 04 24 ae 30 10 00 	movl   $0x1030ae,(%esp)
  10316e:	e8 62 fb ff ff       	call   102cd5 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103176:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103179:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10317c:	89 ec                	mov    %ebp,%esp
  10317e:	5d                   	pop    %ebp
  10317f:	c3                   	ret    

00103180 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103180:	55                   	push   %ebp
  103181:	89 e5                	mov    %esp,%ebp
  103183:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10318d:	eb 03                	jmp    103192 <strlen+0x12>
        cnt ++;
  10318f:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  103192:	8b 45 08             	mov    0x8(%ebp),%eax
  103195:	8d 50 01             	lea    0x1(%eax),%edx
  103198:	89 55 08             	mov    %edx,0x8(%ebp)
  10319b:	0f b6 00             	movzbl (%eax),%eax
  10319e:	84 c0                	test   %al,%al
  1031a0:	75 ed                	jne    10318f <strlen+0xf>
    }
    return cnt;
  1031a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031a5:	89 ec                	mov    %ebp,%esp
  1031a7:	5d                   	pop    %ebp
  1031a8:	c3                   	ret    

001031a9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1031a9:	55                   	push   %ebp
  1031aa:	89 e5                	mov    %esp,%ebp
  1031ac:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031b6:	eb 03                	jmp    1031bb <strnlen+0x12>
        cnt ++;
  1031b8:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1031c1:	73 10                	jae    1031d3 <strnlen+0x2a>
  1031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c6:	8d 50 01             	lea    0x1(%eax),%edx
  1031c9:	89 55 08             	mov    %edx,0x8(%ebp)
  1031cc:	0f b6 00             	movzbl (%eax),%eax
  1031cf:	84 c0                	test   %al,%al
  1031d1:	75 e5                	jne    1031b8 <strnlen+0xf>
    }
    return cnt;
  1031d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031d6:	89 ec                	mov    %ebp,%esp
  1031d8:	5d                   	pop    %ebp
  1031d9:	c3                   	ret    

001031da <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1031da:	55                   	push   %ebp
  1031db:	89 e5                	mov    %esp,%ebp
  1031dd:	57                   	push   %edi
  1031de:	56                   	push   %esi
  1031df:	83 ec 20             	sub    $0x20,%esp
  1031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1031ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031f4:	89 d1                	mov    %edx,%ecx
  1031f6:	89 c2                	mov    %eax,%edx
  1031f8:	89 ce                	mov    %ecx,%esi
  1031fa:	89 d7                	mov    %edx,%edi
  1031fc:	ac                   	lods   %ds:(%esi),%al
  1031fd:	aa                   	stos   %al,%es:(%edi)
  1031fe:	84 c0                	test   %al,%al
  103200:	75 fa                	jne    1031fc <strcpy+0x22>
  103202:	89 fa                	mov    %edi,%edx
  103204:	89 f1                	mov    %esi,%ecx
  103206:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103209:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10320c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103212:	83 c4 20             	add    $0x20,%esp
  103215:	5e                   	pop    %esi
  103216:	5f                   	pop    %edi
  103217:	5d                   	pop    %ebp
  103218:	c3                   	ret    

00103219 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103219:	55                   	push   %ebp
  10321a:	89 e5                	mov    %esp,%ebp
  10321c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10321f:	8b 45 08             	mov    0x8(%ebp),%eax
  103222:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103225:	eb 1e                	jmp    103245 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  103227:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322a:	0f b6 10             	movzbl (%eax),%edx
  10322d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103230:	88 10                	mov    %dl,(%eax)
  103232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103235:	0f b6 00             	movzbl (%eax),%eax
  103238:	84 c0                	test   %al,%al
  10323a:	74 03                	je     10323f <strncpy+0x26>
            src ++;
  10323c:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10323f:	ff 45 fc             	incl   -0x4(%ebp)
  103242:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  103245:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103249:	75 dc                	jne    103227 <strncpy+0xe>
    }
    return dst;
  10324b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10324e:	89 ec                	mov    %ebp,%esp
  103250:	5d                   	pop    %ebp
  103251:	c3                   	ret    

00103252 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103252:	55                   	push   %ebp
  103253:	89 e5                	mov    %esp,%ebp
  103255:	57                   	push   %edi
  103256:	56                   	push   %esi
  103257:	83 ec 20             	sub    $0x20,%esp
  10325a:	8b 45 08             	mov    0x8(%ebp),%eax
  10325d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103260:	8b 45 0c             	mov    0xc(%ebp),%eax
  103263:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  103266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10326c:	89 d1                	mov    %edx,%ecx
  10326e:	89 c2                	mov    %eax,%edx
  103270:	89 ce                	mov    %ecx,%esi
  103272:	89 d7                	mov    %edx,%edi
  103274:	ac                   	lods   %ds:(%esi),%al
  103275:	ae                   	scas   %es:(%edi),%al
  103276:	75 08                	jne    103280 <strcmp+0x2e>
  103278:	84 c0                	test   %al,%al
  10327a:	75 f8                	jne    103274 <strcmp+0x22>
  10327c:	31 c0                	xor    %eax,%eax
  10327e:	eb 04                	jmp    103284 <strcmp+0x32>
  103280:	19 c0                	sbb    %eax,%eax
  103282:	0c 01                	or     $0x1,%al
  103284:	89 fa                	mov    %edi,%edx
  103286:	89 f1                	mov    %esi,%ecx
  103288:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10328b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10328e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  103291:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103294:	83 c4 20             	add    $0x20,%esp
  103297:	5e                   	pop    %esi
  103298:	5f                   	pop    %edi
  103299:	5d                   	pop    %ebp
  10329a:	c3                   	ret    

0010329b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10329b:	55                   	push   %ebp
  10329c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10329e:	eb 09                	jmp    1032a9 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1032a0:	ff 4d 10             	decl   0x10(%ebp)
  1032a3:	ff 45 08             	incl   0x8(%ebp)
  1032a6:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032ad:	74 1a                	je     1032c9 <strncmp+0x2e>
  1032af:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b2:	0f b6 00             	movzbl (%eax),%eax
  1032b5:	84 c0                	test   %al,%al
  1032b7:	74 10                	je     1032c9 <strncmp+0x2e>
  1032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bc:	0f b6 10             	movzbl (%eax),%edx
  1032bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c2:	0f b6 00             	movzbl (%eax),%eax
  1032c5:	38 c2                	cmp    %al,%dl
  1032c7:	74 d7                	je     1032a0 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032cd:	74 18                	je     1032e7 <strncmp+0x4c>
  1032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d2:	0f b6 00             	movzbl (%eax),%eax
  1032d5:	0f b6 d0             	movzbl %al,%edx
  1032d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032db:	0f b6 00             	movzbl (%eax),%eax
  1032de:	0f b6 c8             	movzbl %al,%ecx
  1032e1:	89 d0                	mov    %edx,%eax
  1032e3:	29 c8                	sub    %ecx,%eax
  1032e5:	eb 05                	jmp    1032ec <strncmp+0x51>
  1032e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032ec:	5d                   	pop    %ebp
  1032ed:	c3                   	ret    

001032ee <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1032ee:	55                   	push   %ebp
  1032ef:	89 e5                	mov    %esp,%ebp
  1032f1:	83 ec 04             	sub    $0x4,%esp
  1032f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f7:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032fa:	eb 13                	jmp    10330f <strchr+0x21>
        if (*s == c) {
  1032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ff:	0f b6 00             	movzbl (%eax),%eax
  103302:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103305:	75 05                	jne    10330c <strchr+0x1e>
            return (char *)s;
  103307:	8b 45 08             	mov    0x8(%ebp),%eax
  10330a:	eb 12                	jmp    10331e <strchr+0x30>
        }
        s ++;
  10330c:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10330f:	8b 45 08             	mov    0x8(%ebp),%eax
  103312:	0f b6 00             	movzbl (%eax),%eax
  103315:	84 c0                	test   %al,%al
  103317:	75 e3                	jne    1032fc <strchr+0xe>
    }
    return NULL;
  103319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10331e:	89 ec                	mov    %ebp,%esp
  103320:	5d                   	pop    %ebp
  103321:	c3                   	ret    

00103322 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103322:	55                   	push   %ebp
  103323:	89 e5                	mov    %esp,%ebp
  103325:	83 ec 04             	sub    $0x4,%esp
  103328:	8b 45 0c             	mov    0xc(%ebp),%eax
  10332b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10332e:	eb 0e                	jmp    10333e <strfind+0x1c>
        if (*s == c) {
  103330:	8b 45 08             	mov    0x8(%ebp),%eax
  103333:	0f b6 00             	movzbl (%eax),%eax
  103336:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103339:	74 0f                	je     10334a <strfind+0x28>
            break;
        }
        s ++;
  10333b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10333e:	8b 45 08             	mov    0x8(%ebp),%eax
  103341:	0f b6 00             	movzbl (%eax),%eax
  103344:	84 c0                	test   %al,%al
  103346:	75 e8                	jne    103330 <strfind+0xe>
  103348:	eb 01                	jmp    10334b <strfind+0x29>
            break;
  10334a:	90                   	nop
    }
    return (char *)s;
  10334b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10334e:	89 ec                	mov    %ebp,%esp
  103350:	5d                   	pop    %ebp
  103351:	c3                   	ret    

00103352 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103352:	55                   	push   %ebp
  103353:	89 e5                	mov    %esp,%ebp
  103355:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103358:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10335f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103366:	eb 03                	jmp    10336b <strtol+0x19>
        s ++;
  103368:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  10336b:	8b 45 08             	mov    0x8(%ebp),%eax
  10336e:	0f b6 00             	movzbl (%eax),%eax
  103371:	3c 20                	cmp    $0x20,%al
  103373:	74 f3                	je     103368 <strtol+0x16>
  103375:	8b 45 08             	mov    0x8(%ebp),%eax
  103378:	0f b6 00             	movzbl (%eax),%eax
  10337b:	3c 09                	cmp    $0x9,%al
  10337d:	74 e9                	je     103368 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  10337f:	8b 45 08             	mov    0x8(%ebp),%eax
  103382:	0f b6 00             	movzbl (%eax),%eax
  103385:	3c 2b                	cmp    $0x2b,%al
  103387:	75 05                	jne    10338e <strtol+0x3c>
        s ++;
  103389:	ff 45 08             	incl   0x8(%ebp)
  10338c:	eb 14                	jmp    1033a2 <strtol+0x50>
    }
    else if (*s == '-') {
  10338e:	8b 45 08             	mov    0x8(%ebp),%eax
  103391:	0f b6 00             	movzbl (%eax),%eax
  103394:	3c 2d                	cmp    $0x2d,%al
  103396:	75 0a                	jne    1033a2 <strtol+0x50>
        s ++, neg = 1;
  103398:	ff 45 08             	incl   0x8(%ebp)
  10339b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1033a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033a6:	74 06                	je     1033ae <strtol+0x5c>
  1033a8:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1033ac:	75 22                	jne    1033d0 <strtol+0x7e>
  1033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b1:	0f b6 00             	movzbl (%eax),%eax
  1033b4:	3c 30                	cmp    $0x30,%al
  1033b6:	75 18                	jne    1033d0 <strtol+0x7e>
  1033b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1033bb:	40                   	inc    %eax
  1033bc:	0f b6 00             	movzbl (%eax),%eax
  1033bf:	3c 78                	cmp    $0x78,%al
  1033c1:	75 0d                	jne    1033d0 <strtol+0x7e>
        s += 2, base = 16;
  1033c3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1033c7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1033ce:	eb 29                	jmp    1033f9 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  1033d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033d4:	75 16                	jne    1033ec <strtol+0x9a>
  1033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d9:	0f b6 00             	movzbl (%eax),%eax
  1033dc:	3c 30                	cmp    $0x30,%al
  1033de:	75 0c                	jne    1033ec <strtol+0x9a>
        s ++, base = 8;
  1033e0:	ff 45 08             	incl   0x8(%ebp)
  1033e3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1033ea:	eb 0d                	jmp    1033f9 <strtol+0xa7>
    }
    else if (base == 0) {
  1033ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033f0:	75 07                	jne    1033f9 <strtol+0xa7>
        base = 10;
  1033f2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1033f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033fc:	0f b6 00             	movzbl (%eax),%eax
  1033ff:	3c 2f                	cmp    $0x2f,%al
  103401:	7e 1b                	jle    10341e <strtol+0xcc>
  103403:	8b 45 08             	mov    0x8(%ebp),%eax
  103406:	0f b6 00             	movzbl (%eax),%eax
  103409:	3c 39                	cmp    $0x39,%al
  10340b:	7f 11                	jg     10341e <strtol+0xcc>
            dig = *s - '0';
  10340d:	8b 45 08             	mov    0x8(%ebp),%eax
  103410:	0f b6 00             	movzbl (%eax),%eax
  103413:	0f be c0             	movsbl %al,%eax
  103416:	83 e8 30             	sub    $0x30,%eax
  103419:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10341c:	eb 48                	jmp    103466 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10341e:	8b 45 08             	mov    0x8(%ebp),%eax
  103421:	0f b6 00             	movzbl (%eax),%eax
  103424:	3c 60                	cmp    $0x60,%al
  103426:	7e 1b                	jle    103443 <strtol+0xf1>
  103428:	8b 45 08             	mov    0x8(%ebp),%eax
  10342b:	0f b6 00             	movzbl (%eax),%eax
  10342e:	3c 7a                	cmp    $0x7a,%al
  103430:	7f 11                	jg     103443 <strtol+0xf1>
            dig = *s - 'a' + 10;
  103432:	8b 45 08             	mov    0x8(%ebp),%eax
  103435:	0f b6 00             	movzbl (%eax),%eax
  103438:	0f be c0             	movsbl %al,%eax
  10343b:	83 e8 57             	sub    $0x57,%eax
  10343e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103441:	eb 23                	jmp    103466 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103443:	8b 45 08             	mov    0x8(%ebp),%eax
  103446:	0f b6 00             	movzbl (%eax),%eax
  103449:	3c 40                	cmp    $0x40,%al
  10344b:	7e 3b                	jle    103488 <strtol+0x136>
  10344d:	8b 45 08             	mov    0x8(%ebp),%eax
  103450:	0f b6 00             	movzbl (%eax),%eax
  103453:	3c 5a                	cmp    $0x5a,%al
  103455:	7f 31                	jg     103488 <strtol+0x136>
            dig = *s - 'A' + 10;
  103457:	8b 45 08             	mov    0x8(%ebp),%eax
  10345a:	0f b6 00             	movzbl (%eax),%eax
  10345d:	0f be c0             	movsbl %al,%eax
  103460:	83 e8 37             	sub    $0x37,%eax
  103463:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103469:	3b 45 10             	cmp    0x10(%ebp),%eax
  10346c:	7d 19                	jge    103487 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  10346e:	ff 45 08             	incl   0x8(%ebp)
  103471:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103474:	0f af 45 10          	imul   0x10(%ebp),%eax
  103478:	89 c2                	mov    %eax,%edx
  10347a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10347d:	01 d0                	add    %edx,%eax
  10347f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  103482:	e9 72 ff ff ff       	jmp    1033f9 <strtol+0xa7>
            break;
  103487:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  103488:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10348c:	74 08                	je     103496 <strtol+0x144>
        *endptr = (char *) s;
  10348e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103491:	8b 55 08             	mov    0x8(%ebp),%edx
  103494:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103496:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10349a:	74 07                	je     1034a3 <strtol+0x151>
  10349c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10349f:	f7 d8                	neg    %eax
  1034a1:	eb 03                	jmp    1034a6 <strtol+0x154>
  1034a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1034a6:	89 ec                	mov    %ebp,%esp
  1034a8:	5d                   	pop    %ebp
  1034a9:	c3                   	ret    

001034aa <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1034aa:	55                   	push   %ebp
  1034ab:	89 e5                	mov    %esp,%ebp
  1034ad:	83 ec 28             	sub    $0x28,%esp
  1034b0:	89 7d fc             	mov    %edi,-0x4(%ebp)
  1034b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b6:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1034b9:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1034c3:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1034c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1034cc:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1034cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1034d3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1034d6:	89 d7                	mov    %edx,%edi
  1034d8:	f3 aa                	rep stos %al,%es:(%edi)
  1034da:	89 fa                	mov    %edi,%edx
  1034dc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1034df:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1034e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1034e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  1034e8:	89 ec                	mov    %ebp,%esp
  1034ea:	5d                   	pop    %ebp
  1034eb:	c3                   	ret    

001034ec <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1034ec:	55                   	push   %ebp
  1034ed:	89 e5                	mov    %esp,%ebp
  1034ef:	57                   	push   %edi
  1034f0:	56                   	push   %esi
  1034f1:	53                   	push   %ebx
  1034f2:	83 ec 30             	sub    $0x30,%esp
  1034f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1034f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103501:	8b 45 10             	mov    0x10(%ebp),%eax
  103504:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10350a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10350d:	73 42                	jae    103551 <memmove+0x65>
  10350f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103512:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103518:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10351e:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103521:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103524:	c1 e8 02             	shr    $0x2,%eax
  103527:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10352c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10352f:	89 d7                	mov    %edx,%edi
  103531:	89 c6                	mov    %eax,%esi
  103533:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103535:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103538:	83 e1 03             	and    $0x3,%ecx
  10353b:	74 02                	je     10353f <memmove+0x53>
  10353d:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10353f:	89 f0                	mov    %esi,%eax
  103541:	89 fa                	mov    %edi,%edx
  103543:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103546:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103549:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  10354c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10354f:	eb 36                	jmp    103587 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103554:	8d 50 ff             	lea    -0x1(%eax),%edx
  103557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10355a:	01 c2                	add    %eax,%edx
  10355c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10355f:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103565:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  103568:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10356b:	89 c1                	mov    %eax,%ecx
  10356d:	89 d8                	mov    %ebx,%eax
  10356f:	89 d6                	mov    %edx,%esi
  103571:	89 c7                	mov    %eax,%edi
  103573:	fd                   	std    
  103574:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103576:	fc                   	cld    
  103577:	89 f8                	mov    %edi,%eax
  103579:	89 f2                	mov    %esi,%edx
  10357b:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10357e:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103581:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  103584:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103587:	83 c4 30             	add    $0x30,%esp
  10358a:	5b                   	pop    %ebx
  10358b:	5e                   	pop    %esi
  10358c:	5f                   	pop    %edi
  10358d:	5d                   	pop    %ebp
  10358e:	c3                   	ret    

0010358f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10358f:	55                   	push   %ebp
  103590:	89 e5                	mov    %esp,%ebp
  103592:	57                   	push   %edi
  103593:	56                   	push   %esi
  103594:	83 ec 20             	sub    $0x20,%esp
  103597:	8b 45 08             	mov    0x8(%ebp),%eax
  10359a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10359d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1035a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1035a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035ac:	c1 e8 02             	shr    $0x2,%eax
  1035af:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1035b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035b7:	89 d7                	mov    %edx,%edi
  1035b9:	89 c6                	mov    %eax,%esi
  1035bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035bd:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1035c0:	83 e1 03             	and    $0x3,%ecx
  1035c3:	74 02                	je     1035c7 <memcpy+0x38>
  1035c5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1035c7:	89 f0                	mov    %esi,%eax
  1035c9:	89 fa                	mov    %edi,%edx
  1035cb:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1035ce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1035d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1035d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1035d7:	83 c4 20             	add    $0x20,%esp
  1035da:	5e                   	pop    %esi
  1035db:	5f                   	pop    %edi
  1035dc:	5d                   	pop    %ebp
  1035dd:	c3                   	ret    

001035de <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1035de:	55                   	push   %ebp
  1035df:	89 e5                	mov    %esp,%ebp
  1035e1:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1035ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1035f0:	eb 2e                	jmp    103620 <memcmp+0x42>
        if (*s1 != *s2) {
  1035f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035f5:	0f b6 10             	movzbl (%eax),%edx
  1035f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035fb:	0f b6 00             	movzbl (%eax),%eax
  1035fe:	38 c2                	cmp    %al,%dl
  103600:	74 18                	je     10361a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103602:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103605:	0f b6 00             	movzbl (%eax),%eax
  103608:	0f b6 d0             	movzbl %al,%edx
  10360b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10360e:	0f b6 00             	movzbl (%eax),%eax
  103611:	0f b6 c8             	movzbl %al,%ecx
  103614:	89 d0                	mov    %edx,%eax
  103616:	29 c8                	sub    %ecx,%eax
  103618:	eb 18                	jmp    103632 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  10361a:	ff 45 fc             	incl   -0x4(%ebp)
  10361d:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  103620:	8b 45 10             	mov    0x10(%ebp),%eax
  103623:	8d 50 ff             	lea    -0x1(%eax),%edx
  103626:	89 55 10             	mov    %edx,0x10(%ebp)
  103629:	85 c0                	test   %eax,%eax
  10362b:	75 c5                	jne    1035f2 <memcmp+0x14>
    }
    return 0;
  10362d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103632:	89 ec                	mov    %ebp,%esp
  103634:	5d                   	pop    %ebp
  103635:	c3                   	ret    
