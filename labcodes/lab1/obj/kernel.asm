
bin/kernel：     文件格式 elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	b8 08 0d 11 00       	mov    $0x110d08,%eax
  10000b:	2d 16 fa 10 00       	sub    $0x10fa16,%eax
  100010:	89 44 24 08          	mov    %eax,0x8(%esp)
  100014:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001b:	00 
  10001c:	c7 04 24 16 fa 10 00 	movl   $0x10fa16,(%esp)
  100023:	e8 ee 32 00 00       	call   103316 <memset>

    cons_init();                // init the console
  100028:	e8 b4 15 00 00       	call   1015e1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10002d:	c7 45 f4 c0 34 10 00 	movl   $0x1034c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100037:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003b:	c7 04 24 dc 34 10 00 	movl   $0x1034dc,(%esp)
  100042:	e8 d9 02 00 00       	call   100320 <cprintf>

    print_kerninfo();
  100047:	e8 f7 07 00 00       	call   100843 <print_kerninfo>

    grade_backtrace();
  10004c:	e8 90 00 00 00       	call   1000e1 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100051:	e8 17 29 00 00       	call   10296d <pmm_init>

    pic_init();                 // init interrupt controller
  100056:	e8 e1 16 00 00       	call   10173c <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005b:	e8 68 18 00 00       	call   1018c8 <idt_init>

    clock_init();               // init clock interrupt
  100060:	e8 1d 0d 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100065:	e8 30 16 00 00       	call   10169a <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006a:	eb fe                	jmp    10006a <kern_init+0x6a>

0010006c <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10006c:	55                   	push   %ebp
  10006d:	89 e5                	mov    %esp,%ebp
  10006f:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100072:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100079:	00 
  10007a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100081:	00 
  100082:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100089:	e8 0f 0c 00 00       	call   100c9d <mon_backtrace>
}
  10008e:	90                   	nop
  10008f:	89 ec                	mov    %ebp,%esp
  100091:	5d                   	pop    %ebp
  100092:	c3                   	ret    

00100093 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100093:	55                   	push   %ebp
  100094:	89 e5                	mov    %esp,%ebp
  100096:	83 ec 18             	sub    $0x18,%esp
  100099:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b4:	89 04 24             	mov    %eax,(%esp)
  1000b7:	e8 b0 ff ff ff       	call   10006c <grade_backtrace2>
}
  1000bc:	90                   	nop
  1000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1000c0:	89 ec                	mov    %ebp,%esp
  1000c2:	5d                   	pop    %ebp
  1000c3:	c3                   	ret    

001000c4 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c4:	55                   	push   %ebp
  1000c5:	89 e5                	mov    %esp,%ebp
  1000c7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d4:	89 04 24             	mov    %eax,(%esp)
  1000d7:	e8 b7 ff ff ff       	call   100093 <grade_backtrace1>
}
  1000dc:	90                   	nop
  1000dd:	89 ec                	mov    %ebp,%esp
  1000df:	5d                   	pop    %ebp
  1000e0:	c3                   	ret    

001000e1 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e1:	55                   	push   %ebp
  1000e2:	89 e5                	mov    %esp,%ebp
  1000e4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e7:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ec:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f3:	ff 
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000ff:	e8 c0 ff ff ff       	call   1000c4 <grade_backtrace0>
}
  100104:	90                   	nop
  100105:	89 ec                	mov    %ebp,%esp
  100107:	5d                   	pop    %ebp
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 e1 34 10 00 	movl   $0x1034e1,(%esp)
  100138:	e8 e3 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 ef 34 10 00 	movl   $0x1034ef,(%esp)
  100157:	e8 c4 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 fd 34 10 00 	movl   $0x1034fd,(%esp)
  100176:	e8 a5 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 0b 35 10 00 	movl   $0x10350b,(%esp)
  100195:	e8 86 01 00 00       	call   100320 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 19 35 10 00 	movl   $0x103519,(%esp)
  1001b4:	e8 67 01 00 00       	call   100320 <cprintf>
    round ++;
  1001b9:	a1 20 fa 10 00       	mov    0x10fa20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 fa 10 00       	mov    %eax,0x10fa20
}
  1001c4:	90                   	nop
  1001c5:	89 ec                	mov    %ebp,%esp
  1001c7:	5d                   	pop    %ebp
  1001c8:	c3                   	ret    

001001c9 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c9:	55                   	push   %ebp
  1001ca:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001cc:	90                   	nop
  1001cd:	5d                   	pop    %ebp
  1001ce:	c3                   	ret    

001001cf <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cf:	55                   	push   %ebp
  1001d0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d2:	90                   	nop
  1001d3:	5d                   	pop    %ebp
  1001d4:	c3                   	ret    

001001d5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d5:	55                   	push   %ebp
  1001d6:	89 e5                	mov    %esp,%ebp
  1001d8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001db:	e8 29 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e0:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001e7:	e8 34 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_user();
  1001ec:	e8 d8 ff ff ff       	call   1001c9 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f1:	e8 13 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f6:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  1001fd:	e8 1e 01 00 00       	call   100320 <cprintf>
    lab1_switch_to_kernel();
  100202:	e8 c8 ff ff ff       	call   1001cf <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100207:	e8 fd fe ff ff       	call   100109 <lab1_print_cur_status>
}
  10020c:	90                   	nop
  10020d:	89 ec                	mov    %ebp,%esp
  10020f:	5d                   	pop    %ebp
  100210:	c3                   	ret    

00100211 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100211:	55                   	push   %ebp
  100212:	89 e5                	mov    %esp,%ebp
  100214:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100217:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10021b:	74 13                	je     100230 <readline+0x1f>
        cprintf("%s", prompt);
  10021d:	8b 45 08             	mov    0x8(%ebp),%eax
  100220:	89 44 24 04          	mov    %eax,0x4(%esp)
  100224:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  10022b:	e8 f0 00 00 00       	call   100320 <cprintf>
    }
    int i = 0, c;
  100230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100237:	e8 73 01 00 00       	call   1003af <getchar>
  10023c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100243:	79 07                	jns    10024c <readline+0x3b>
            return NULL;
  100245:	b8 00 00 00 00       	mov    $0x0,%eax
  10024a:	eb 78                	jmp    1002c4 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10024c:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100250:	7e 28                	jle    10027a <readline+0x69>
  100252:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100259:	7f 1f                	jg     10027a <readline+0x69>
            cputchar(c);
  10025b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025e:	89 04 24             	mov    %eax,(%esp)
  100261:	e8 e2 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  100266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100269:	8d 50 01             	lea    0x1(%eax),%edx
  10026c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10026f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100272:	88 90 40 fa 10 00    	mov    %dl,0x10fa40(%eax)
  100278:	eb 45                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10027a:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027e:	75 16                	jne    100296 <readline+0x85>
  100280:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100284:	7e 10                	jle    100296 <readline+0x85>
            cputchar(c);
  100286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100289:	89 04 24             	mov    %eax,(%esp)
  10028c:	e8 b7 00 00 00       	call   100348 <cputchar>
            i --;
  100291:	ff 4d f4             	decl   -0xc(%ebp)
  100294:	eb 29                	jmp    1002bf <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100296:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  10029a:	74 06                	je     1002a2 <readline+0x91>
  10029c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a0:	75 95                	jne    100237 <readline+0x26>
            cputchar(c);
  1002a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a5:	89 04 24             	mov    %eax,(%esp)
  1002a8:	e8 9b 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b0:	05 40 fa 10 00       	add    $0x10fa40,%eax
  1002b5:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b8:	b8 40 fa 10 00       	mov    $0x10fa40,%eax
  1002bd:	eb 05                	jmp    1002c4 <readline+0xb3>
        c = getchar();
  1002bf:	e9 73 ff ff ff       	jmp    100237 <readline+0x26>
        }
    }
}
  1002c4:	89 ec                	mov    %ebp,%esp
  1002c6:	5d                   	pop    %ebp
  1002c7:	c3                   	ret    

001002c8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c8:	55                   	push   %ebp
  1002c9:	89 e5                	mov    %esp,%ebp
  1002cb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d1:	89 04 24             	mov    %eax,(%esp)
  1002d4:	e8 37 13 00 00       	call   101610 <cons_putc>
    (*cnt) ++;
  1002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002dc:	8b 00                	mov    (%eax),%eax
  1002de:	8d 50 01             	lea    0x1(%eax),%edx
  1002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e4:	89 10                	mov    %edx,(%eax)
}
  1002e6:	90                   	nop
  1002e7:	89 ec                	mov    %ebp,%esp
  1002e9:	5d                   	pop    %ebp
  1002ea:	c3                   	ret    

001002eb <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002eb:	55                   	push   %ebp
  1002ec:	89 e5                	mov    %esp,%ebp
  1002ee:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  100302:	89 44 24 08          	mov    %eax,0x8(%esp)
  100306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100309:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030d:	c7 04 24 c8 02 10 00 	movl   $0x1002c8,(%esp)
  100314:	e8 28 28 00 00       	call   102b41 <vprintfmt>
    return cnt;
  100319:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031c:	89 ec                	mov    %ebp,%esp
  10031e:	5d                   	pop    %ebp
  10031f:	c3                   	ret    

00100320 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100320:	55                   	push   %ebp
  100321:	89 e5                	mov    %esp,%ebp
  100323:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100326:	8d 45 0c             	lea    0xc(%ebp),%eax
  100329:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10032f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100333:	8b 45 08             	mov    0x8(%ebp),%eax
  100336:	89 04 24             	mov    %eax,(%esp)
  100339:	e8 ad ff ff ff       	call   1002eb <vcprintf>
  10033e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100341:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100344:	89 ec                	mov    %ebp,%esp
  100346:	5d                   	pop    %ebp
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 b7 12 00 00       	call   101610 <cons_putc>
}
  100359:	90                   	nop
  10035a:	89 ec                	mov    %ebp,%esp
  10035c:	5d                   	pop    %ebp
  10035d:	c3                   	ret    

0010035e <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035e:	55                   	push   %ebp
  10035f:	89 e5                	mov    %esp,%ebp
  100361:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100364:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10036b:	eb 13                	jmp    100380 <cputs+0x22>
        cputch(c, &cnt);
  10036d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100371:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100374:	89 54 24 04          	mov    %edx,0x4(%esp)
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 48 ff ff ff       	call   1002c8 <cputch>
    while ((c = *str ++) != '\0') {
  100380:	8b 45 08             	mov    0x8(%ebp),%eax
  100383:	8d 50 01             	lea    0x1(%eax),%edx
  100386:	89 55 08             	mov    %edx,0x8(%ebp)
  100389:	0f b6 00             	movzbl (%eax),%eax
  10038c:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038f:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100393:	75 d8                	jne    10036d <cputs+0xf>
    }
    cputch('\n', &cnt);
  100395:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100398:	89 44 24 04          	mov    %eax,0x4(%esp)
  10039c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a3:	e8 20 ff ff ff       	call   1002c8 <cputch>
    return cnt;
  1003a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ab:	89 ec                	mov    %ebp,%esp
  1003ad:	5d                   	pop    %ebp
  1003ae:	c3                   	ret    

001003af <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003af:	55                   	push   %ebp
  1003b0:	89 e5                	mov    %esp,%ebp
  1003b2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b5:	90                   	nop
  1003b6:	e8 81 12 00 00       	call   10163c <cons_getc>
  1003bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003c2:	74 f2                	je     1003b6 <getchar+0x7>
        /* do nothing */;
    return c;
  1003c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c7:	89 ec                	mov    %ebp,%esp
  1003c9:	5d                   	pop    %ebp
  1003ca:	c3                   	ret    

001003cb <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003cb:	55                   	push   %ebp
  1003cc:	89 e5                	mov    %esp,%ebp
  1003ce:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1003dc:	8b 00                	mov    (%eax),%eax
  1003de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e8:	e9 ca 00 00 00       	jmp    1004b7 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1003ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003f3:	01 d0                	add    %edx,%eax
  1003f5:	89 c2                	mov    %eax,%edx
  1003f7:	c1 ea 1f             	shr    $0x1f,%edx
  1003fa:	01 d0                	add    %edx,%eax
  1003fc:	d1 f8                	sar    %eax
  1003fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100401:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100404:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100407:	eb 03                	jmp    10040c <stab_binsearch+0x41>
            m --;
  100409:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  10040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10040f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100412:	7c 1f                	jl     100433 <stab_binsearch+0x68>
  100414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100417:	89 d0                	mov    %edx,%eax
  100419:	01 c0                	add    %eax,%eax
  10041b:	01 d0                	add    %edx,%eax
  10041d:	c1 e0 02             	shl    $0x2,%eax
  100420:	89 c2                	mov    %eax,%edx
  100422:	8b 45 08             	mov    0x8(%ebp),%eax
  100425:	01 d0                	add    %edx,%eax
  100427:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10042b:	0f b6 c0             	movzbl %al,%eax
  10042e:	39 45 14             	cmp    %eax,0x14(%ebp)
  100431:	75 d6                	jne    100409 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100436:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100439:	7d 09                	jge    100444 <stab_binsearch+0x79>
            l = true_m + 1;
  10043b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10043e:	40                   	inc    %eax
  10043f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100442:	eb 73                	jmp    1004b7 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100444:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10044b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10044e:	89 d0                	mov    %edx,%eax
  100450:	01 c0                	add    %eax,%eax
  100452:	01 d0                	add    %edx,%eax
  100454:	c1 e0 02             	shl    $0x2,%eax
  100457:	89 c2                	mov    %eax,%edx
  100459:	8b 45 08             	mov    0x8(%ebp),%eax
  10045c:	01 d0                	add    %edx,%eax
  10045e:	8b 40 08             	mov    0x8(%eax),%eax
  100461:	39 45 18             	cmp    %eax,0x18(%ebp)
  100464:	76 11                	jbe    100477 <stab_binsearch+0xac>
            *region_left = m;
  100466:	8b 45 0c             	mov    0xc(%ebp),%eax
  100469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100471:	40                   	inc    %eax
  100472:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100475:	eb 40                	jmp    1004b7 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10047a:	89 d0                	mov    %edx,%eax
  10047c:	01 c0                	add    %eax,%eax
  10047e:	01 d0                	add    %edx,%eax
  100480:	c1 e0 02             	shl    $0x2,%eax
  100483:	89 c2                	mov    %eax,%edx
  100485:	8b 45 08             	mov    0x8(%ebp),%eax
  100488:	01 d0                	add    %edx,%eax
  10048a:	8b 40 08             	mov    0x8(%eax),%eax
  10048d:	39 45 18             	cmp    %eax,0x18(%ebp)
  100490:	73 14                	jae    1004a6 <stab_binsearch+0xdb>
            *region_right = m - 1;
  100492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100495:	8d 50 ff             	lea    -0x1(%eax),%edx
  100498:	8b 45 10             	mov    0x10(%ebp),%eax
  10049b:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	48                   	dec    %eax
  1004a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a4:	eb 11                	jmp    1004b7 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ac:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b4:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 2a ff ff ff    	jle    1003ed <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1004d6:	eb 3e                	jmp    100516 <stab_binsearch+0x14b>
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 03                	jmp    1004e5 <stab_binsearch+0x11a>
  1004e2:	ff 4d fc             	decl   -0x4(%ebp)
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1004ed:	7e 1f                	jle    10050e <stab_binsearch+0x143>
  1004ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f2:	89 d0                	mov    %edx,%eax
  1004f4:	01 c0                	add    %eax,%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	c1 e0 02             	shl    $0x2,%eax
  1004fb:	89 c2                	mov    %eax,%edx
  1004fd:	8b 45 08             	mov    0x8(%ebp),%eax
  100500:	01 d0                	add    %edx,%eax
  100502:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100506:	0f b6 c0             	movzbl %al,%eax
  100509:	39 45 14             	cmp    %eax,0x14(%ebp)
  10050c:	75 d4                	jne    1004e2 <stab_binsearch+0x117>
        *region_left = l;
  10050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 10                	mov    %edx,(%eax)
}
  100516:	90                   	nop
  100517:	89 ec                	mov    %ebp,%esp
  100519:	5d                   	pop    %ebp
  10051a:	c3                   	ret    

0010051b <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10051b:	55                   	push   %ebp
  10051c:	89 e5                	mov    %esp,%ebp
  10051e:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100521:	8b 45 0c             	mov    0xc(%ebp),%eax
  100524:	c7 00 6c 35 10 00    	movl   $0x10356c,(%eax)
    info->eip_line = 0;
  10052a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100534:	8b 45 0c             	mov    0xc(%ebp),%eax
  100537:	c7 40 08 6c 35 10 00 	movl   $0x10356c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100541:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100548:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054b:	8b 55 08             	mov    0x8(%ebp),%edx
  10054e:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100551:	8b 45 0c             	mov    0xc(%ebp),%eax
  100554:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10055b:	c7 45 f4 0c 3e 10 00 	movl   $0x103e0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100562:	c7 45 f0 10 bb 10 00 	movl   $0x10bb10,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100569:	c7 45 ec 11 bb 10 00 	movl   $0x10bb11,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100570:	c7 45 e8 70 e4 10 00 	movl   $0x10e470,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10057a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057d:	76 0b                	jbe    10058a <debuginfo_eip+0x6f>
  10057f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100582:	48                   	dec    %eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x79>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 ab 02 00 00       	jmp    10083f <debuginfo_eip+0x324>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059e:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1005a1:	c1 f8 02             	sar    $0x2,%eax
  1005a4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005aa:	48                   	dec    %eax
  1005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005bc:	00 
  1005bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ce:	89 04 24             	mov    %eax,(%esp)
  1005d1:	e8 f5 fd ff ff       	call   1003cb <stab_binsearch>
    if (lfile == 0)
  1005d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d9:	85 c0                	test   %eax,%eax
  1005db:	75 0a                	jne    1005e7 <debuginfo_eip+0xcc>
        return -1;
  1005dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e2:	e9 58 02 00 00       	jmp    10083f <debuginfo_eip+0x324>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005fa:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100601:	00 
  100602:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100605:	89 44 24 08          	mov    %eax,0x8(%esp)
  100609:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10060c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100613:	89 04 24             	mov    %eax,(%esp)
  100616:	e8 b0 fd ff ff       	call   1003cb <stab_binsearch>

    if (lfun <= rfun) {
  10061b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10061e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100621:	39 c2                	cmp    %eax,%edx
  100623:	7f 78                	jg     10069d <debuginfo_eip+0x182>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100625:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100628:	89 c2                	mov    %eax,%edx
  10062a:	89 d0                	mov    %edx,%eax
  10062c:	01 c0                	add    %eax,%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	c1 e0 02             	shl    $0x2,%eax
  100633:	89 c2                	mov    %eax,%edx
  100635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100638:	01 d0                	add    %edx,%eax
  10063a:	8b 10                	mov    (%eax),%edx
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100642:	39 c2                	cmp    %eax,%edx
  100644:	73 22                	jae    100668 <debuginfo_eip+0x14d>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100646:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100649:	89 c2                	mov    %eax,%edx
  10064b:	89 d0                	mov    %edx,%eax
  10064d:	01 c0                	add    %eax,%eax
  10064f:	01 d0                	add    %edx,%eax
  100651:	c1 e0 02             	shl    $0x2,%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	8b 10                	mov    (%eax),%edx
  10065d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100660:	01 c2                	add    %eax,%edx
  100662:	8b 45 0c             	mov    0xc(%ebp),%eax
  100665:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100668:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066b:	89 c2                	mov    %eax,%edx
  10066d:	89 d0                	mov    %edx,%eax
  10066f:	01 c0                	add    %eax,%eax
  100671:	01 d0                	add    %edx,%eax
  100673:	c1 e0 02             	shl    $0x2,%eax
  100676:	89 c2                	mov    %eax,%edx
  100678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	8b 50 08             	mov    0x8(%eax),%edx
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	8b 40 10             	mov    0x10(%eax),%eax
  10068c:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10068f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100692:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100695:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100698:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10069b:	eb 15                	jmp    1006b2 <debuginfo_eip+0x197>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006af:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b5:	8b 40 08             	mov    0x8(%eax),%eax
  1006b8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006bf:	00 
  1006c0:	89 04 24             	mov    %eax,(%esp)
  1006c3:	e8 c6 2a 00 00       	call   10318e <strfind>
  1006c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1006cb:	8b 4a 08             	mov    0x8(%edx),%ecx
  1006ce:	29 c8                	sub    %ecx,%eax
  1006d0:	89 c2                	mov    %eax,%edx
  1006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006db:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006df:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e6:	00 
  1006e7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ee:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f8:	89 04 24             	mov    %eax,(%esp)
  1006fb:	e8 cb fc ff ff       	call   1003cb <stab_binsearch>
    if (lline <= rline) {
  100700:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100703:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100706:	39 c2                	cmp    %eax,%edx
  100708:	7f 23                	jg     10072d <debuginfo_eip+0x212>
        info->eip_line = stabs[rline].n_desc;
  10070a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070d:	89 c2                	mov    %eax,%edx
  10070f:	89 d0                	mov    %edx,%eax
  100711:	01 c0                	add    %eax,%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	c1 e0 02             	shl    $0x2,%eax
  100718:	89 c2                	mov    %eax,%edx
  10071a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100723:	89 c2                	mov    %eax,%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10072b:	eb 11                	jmp    10073e <debuginfo_eip+0x223>
        return -1;
  10072d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100732:	e9 08 01 00 00       	jmp    10083f <debuginfo_eip+0x324>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073a:	48                   	dec    %eax
  10073b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10073e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100741:	8b 45 e4             	mov    -0x1c(%ebp),%eax
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100744:	39 c2                	cmp    %eax,%edx
  100746:	7c 56                	jl     10079e <debuginfo_eip+0x283>
           && stabs[lline].n_type != N_SOL
  100748:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074b:	89 c2                	mov    %eax,%edx
  10074d:	89 d0                	mov    %edx,%eax
  10074f:	01 c0                	add    %eax,%eax
  100751:	01 d0                	add    %edx,%eax
  100753:	c1 e0 02             	shl    $0x2,%eax
  100756:	89 c2                	mov    %eax,%edx
  100758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075b:	01 d0                	add    %edx,%eax
  10075d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100761:	3c 84                	cmp    $0x84,%al
  100763:	74 39                	je     10079e <debuginfo_eip+0x283>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100765:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100768:	89 c2                	mov    %eax,%edx
  10076a:	89 d0                	mov    %edx,%eax
  10076c:	01 c0                	add    %eax,%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	c1 e0 02             	shl    $0x2,%eax
  100773:	89 c2                	mov    %eax,%edx
  100775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077e:	3c 64                	cmp    $0x64,%al
  100780:	75 b5                	jne    100737 <debuginfo_eip+0x21c>
  100782:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 40 08             	mov    0x8(%eax),%eax
  10079a:	85 c0                	test   %eax,%eax
  10079c:	74 99                	je     100737 <debuginfo_eip+0x21c>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a4:	39 c2                	cmp    %eax,%edx
  1007a6:	7c 42                	jl     1007ea <debuginfo_eip+0x2cf>
  1007a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ab:	89 c2                	mov    %eax,%edx
  1007ad:	89 d0                	mov    %edx,%eax
  1007af:	01 c0                	add    %eax,%eax
  1007b1:	01 d0                	add    %edx,%eax
  1007b3:	c1 e0 02             	shl    $0x2,%eax
  1007b6:	89 c2                	mov    %eax,%edx
  1007b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bb:	01 d0                	add    %edx,%eax
  1007bd:	8b 10                	mov    (%eax),%edx
  1007bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1007c2:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1007c5:	39 c2                	cmp    %eax,%edx
  1007c7:	73 21                	jae    1007ea <debuginfo_eip+0x2cf>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007c9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cc:	89 c2                	mov    %eax,%edx
  1007ce:	89 d0                	mov    %edx,%eax
  1007d0:	01 c0                	add    %eax,%eax
  1007d2:	01 d0                	add    %edx,%eax
  1007d4:	c1 e0 02             	shl    $0x2,%eax
  1007d7:	89 c2                	mov    %eax,%edx
  1007d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dc:	01 d0                	add    %edx,%eax
  1007de:	8b 10                	mov    (%eax),%edx
  1007e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e3:	01 c2                	add    %eax,%edx
  1007e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e8:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	7d 46                	jge    10083a <debuginfo_eip+0x31f>
        for (lline = lfun + 1;
  1007f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f7:	40                   	inc    %eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fb:	eb 16                	jmp    100813 <debuginfo_eip+0x2f8>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100800:	8b 40 14             	mov    0x14(%eax),%eax
  100803:	8d 50 01             	lea    0x1(%eax),%edx
  100806:	8b 45 0c             	mov    0xc(%ebp),%eax
  100809:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10080c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10080f:	40                   	inc    %eax
  100810:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100813:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100816:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100819:	39 c2                	cmp    %eax,%edx
  10081b:	7d 1d                	jge    10083a <debuginfo_eip+0x31f>
  10081d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	89 d0                	mov    %edx,%eax
  100824:	01 c0                	add    %eax,%eax
  100826:	01 d0                	add    %edx,%eax
  100828:	c1 e0 02             	shl    $0x2,%eax
  10082b:	89 c2                	mov    %eax,%edx
  10082d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100836:	3c a0                	cmp    $0xa0,%al
  100838:	74 c3                	je     1007fd <debuginfo_eip+0x2e2>
        }
    }
    return 0;
  10083a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10083f:	89 ec                	mov    %ebp,%esp
  100841:	5d                   	pop    %ebp
  100842:	c3                   	ret    

00100843 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100843:	55                   	push   %ebp
  100844:	89 e5                	mov    %esp,%ebp
  100846:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100849:	c7 04 24 76 35 10 00 	movl   $0x103576,(%esp)
  100850:	e8 cb fa ff ff       	call   100320 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100855:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085c:	00 
  10085d:	c7 04 24 8f 35 10 00 	movl   $0x10358f,(%esp)
  100864:	e8 b7 fa ff ff       	call   100320 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100869:	c7 44 24 04 a2 34 10 	movl   $0x1034a2,0x4(%esp)
  100870:	00 
  100871:	c7 04 24 a7 35 10 00 	movl   $0x1035a7,(%esp)
  100878:	e8 a3 fa ff ff       	call   100320 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10087d:	c7 44 24 04 16 fa 10 	movl   $0x10fa16,0x4(%esp)
  100884:	00 
  100885:	c7 04 24 bf 35 10 00 	movl   $0x1035bf,(%esp)
  10088c:	e8 8f fa ff ff       	call   100320 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100891:	c7 44 24 04 08 0d 11 	movl   $0x110d08,0x4(%esp)
  100898:	00 
  100899:	c7 04 24 d7 35 10 00 	movl   $0x1035d7,(%esp)
  1008a0:	e8 7b fa ff ff       	call   100320 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a5:	b8 08 0d 11 00       	mov    $0x110d08,%eax
  1008aa:	2d 00 00 10 00       	sub    $0x100000,%eax
  1008af:	05 ff 03 00 00       	add    $0x3ff,%eax
  1008b4:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ba:	85 c0                	test   %eax,%eax
  1008bc:	0f 48 c2             	cmovs  %edx,%eax
  1008bf:	c1 f8 0a             	sar    $0xa,%eax
  1008c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008c6:	c7 04 24 f0 35 10 00 	movl   $0x1035f0,(%esp)
  1008cd:	e8 4e fa ff ff       	call   100320 <cprintf>
}
  1008d2:	90                   	nop
  1008d3:	89 ec                	mov    %ebp,%esp
  1008d5:	5d                   	pop    %ebp
  1008d6:	c3                   	ret    

001008d7 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008d7:	55                   	push   %ebp
  1008d8:	89 e5                	mov    %esp,%ebp
  1008da:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ea:	89 04 24             	mov    %eax,(%esp)
  1008ed:	e8 29 fc ff ff       	call   10051b <debuginfo_eip>
  1008f2:	85 c0                	test   %eax,%eax
  1008f4:	74 15                	je     10090b <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fd:	c7 04 24 1a 36 10 00 	movl   $0x10361a,(%esp)
  100904:	e8 17 fa ff ff       	call   100320 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100909:	eb 6c                	jmp    100977 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10090b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100912:	eb 1b                	jmp    10092f <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100914:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091a:	01 d0                	add    %edx,%eax
  10091c:	0f b6 10             	movzbl (%eax),%edx
  10091f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100928:	01 c8                	add    %ecx,%eax
  10092a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10092c:	ff 45 f4             	incl   -0xc(%ebp)
  10092f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100932:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100935:	7c dd                	jl     100914 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100937:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10093d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100940:	01 d0                	add    %edx,%eax
  100942:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100945:	8b 55 ec             	mov    -0x14(%ebp),%edx
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100948:	8b 45 08             	mov    0x8(%ebp),%eax
  10094b:	29 d0                	sub    %edx,%eax
  10094d:	89 c1                	mov    %eax,%ecx
  10094f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100952:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100955:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100959:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10095f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100963:	89 54 24 08          	mov    %edx,0x8(%esp)
  100967:	89 44 24 04          	mov    %eax,0x4(%esp)
  10096b:	c7 04 24 36 36 10 00 	movl   $0x103636,(%esp)
  100972:	e8 a9 f9 ff ff       	call   100320 <cprintf>
}
  100977:	90                   	nop
  100978:	89 ec                	mov    %ebp,%esp
  10097a:	5d                   	pop    %ebp
  10097b:	c3                   	ret    

0010097c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097c:	55                   	push   %ebp
  10097d:	89 e5                	mov    %esp,%ebp
  10097f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100982:	8b 45 04             	mov    0x4(%ebp),%eax
  100985:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100988:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098b:	89 ec                	mov    %ebp,%esp
  10098d:	5d                   	pop    %ebp
  10098e:	c3                   	ret    

0010098f <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 38             	sub    $0x38,%esp
  100995:	89 5d fc             	mov    %ebx,-0x4(%ebp)
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100998:	89 e8                	mov    %ebp,%eax
  10099a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  10099d:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
      uint32_t ebp=read_ebp();
  1009a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      uint32_t eip=read_eip();
  1009a3:	e8 d4 ff ff ff       	call   10097c <read_eip>
  1009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      for(int i=0;ebp&&eip&&i<STACKFRAME_DEPTH;i++){
  1009ab:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b2:	e9 84 00 00 00       	jmp    100a3b <print_stackframe+0xac>
      	cprintf("ebp:0x%08x ",ebp);
  1009b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009be:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1009c5:	e8 56 f9 ff ff       	call   100320 <cprintf>
	cprintf("eip:0x%08x ",eip);
  1009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d1:	c7 04 24 54 36 10 00 	movl   $0x103654,(%esp)
  1009d8:	e8 43 f9 ff ff       	call   100320 <cprintf>
	cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x\n",*(unsigned int*)(ebp+8),*(unsigned int*)(ebp+12),*(unsigned int*)(ebp+16),*(unsigned int*)(ebp+20) );
  1009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e0:	83 c0 14             	add    $0x14,%eax
  1009e3:	8b 18                	mov    (%eax),%ebx
  1009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e8:	83 c0 10             	add    $0x10,%eax
  1009eb:	8b 08                	mov    (%eax),%ecx
  1009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f0:	83 c0 0c             	add    $0xc,%eax
  1009f3:	8b 10                	mov    (%eax),%edx
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	83 c0 08             	add    $0x8,%eax
  1009fb:	8b 00                	mov    (%eax),%eax
  1009fd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a01:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a05:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0d:	c7 04 24 60 36 10 00 	movl   $0x103660,(%esp)
  100a14:	e8 07 f9 ff ff       	call   100320 <cprintf>
        print_debuginfo(eip-1);
  100a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1c:	48                   	dec    %eax
  100a1d:	89 04 24             	mov    %eax,(%esp)
  100a20:	e8 b2 fe ff ff       	call   1008d7 <print_debuginfo>
        eip=*(uint32_t*)(ebp+4);
  100a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a28:	83 c0 04             	add    $0x4,%eax
  100a2b:	8b 00                	mov    (%eax),%eax
  100a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	ebp=*(uint32_t*)ebp;
  100a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a33:	8b 00                	mov    (%eax),%eax
  100a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
      for(int i=0;ebp&&eip&&i<STACKFRAME_DEPTH;i++){
  100a38:	ff 45 ec             	incl   -0x14(%ebp)
  100a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a3f:	74 10                	je     100a51 <print_stackframe+0xc2>
  100a41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a45:	74 0a                	je     100a51 <print_stackframe+0xc2>
  100a47:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a4b:	0f 8e 66 ff ff ff    	jle    1009b7 <print_stackframe+0x28>
      }
}
  100a51:	90                   	nop
  100a52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100a55:	89 ec                	mov    %ebp,%esp
  100a57:	5d                   	pop    %ebp
  100a58:	c3                   	ret    

00100a59 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a59:	55                   	push   %ebp
  100a5a:	89 e5                	mov    %esp,%ebp
  100a5c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a66:	eb 0c                	jmp    100a74 <parse+0x1b>
            *buf ++ = '\0';
  100a68:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6b:	8d 50 01             	lea    0x1(%eax),%edx
  100a6e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a71:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	0f b6 00             	movzbl (%eax),%eax
  100a7a:	84 c0                	test   %al,%al
  100a7c:	74 1d                	je     100a9b <parse+0x42>
  100a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a81:	0f b6 00             	movzbl (%eax),%eax
  100a84:	0f be c0             	movsbl %al,%eax
  100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8b:	c7 04 24 04 37 10 00 	movl   $0x103704,(%esp)
  100a92:	e8 c3 26 00 00       	call   10315a <strchr>
  100a97:	85 c0                	test   %eax,%eax
  100a99:	75 cd                	jne    100a68 <parse+0xf>
        }
        if (*buf == '\0') {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 65                	je     100b0a <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa9:	75 14                	jne    100abf <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aab:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab2:	00 
  100ab3:	c7 04 24 09 37 10 00 	movl   $0x103709,(%esp)
  100aba:	e8 61 f8 ff ff       	call   100320 <cprintf>
        }
        argv[argc ++] = buf;
  100abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac2:	8d 50 01             	lea    0x1(%eax),%edx
  100ac5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100acf:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad2:	01 c2                	add    %eax,%edx
  100ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad9:	eb 03                	jmp    100ade <parse+0x85>
            buf ++;
  100adb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ade:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae1:	0f b6 00             	movzbl (%eax),%eax
  100ae4:	84 c0                	test   %al,%al
  100ae6:	74 8c                	je     100a74 <parse+0x1b>
  100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aeb:	0f b6 00             	movzbl (%eax),%eax
  100aee:	0f be c0             	movsbl %al,%eax
  100af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af5:	c7 04 24 04 37 10 00 	movl   $0x103704,(%esp)
  100afc:	e8 59 26 00 00       	call   10315a <strchr>
  100b01:	85 c0                	test   %eax,%eax
  100b03:	74 d6                	je     100adb <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b05:	e9 6a ff ff ff       	jmp    100a74 <parse+0x1b>
            break;
  100b0a:	90                   	nop
        }
    }
    return argc;
  100b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b0e:	89 ec                	mov    %ebp,%esp
  100b10:	5d                   	pop    %ebp
  100b11:	c3                   	ret    

00100b12 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b12:	55                   	push   %ebp
  100b13:	89 e5                	mov    %esp,%ebp
  100b15:	83 ec 68             	sub    $0x68,%esp
  100b18:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b22:	8b 45 08             	mov    0x8(%ebp),%eax
  100b25:	89 04 24             	mov    %eax,(%esp)
  100b28:	e8 2c ff ff ff       	call   100a59 <parse>
  100b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b34:	75 0a                	jne    100b40 <runcmd+0x2e>
        return 0;
  100b36:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3b:	e9 83 00 00 00       	jmp    100bc3 <runcmd+0xb1>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b47:	eb 5a                	jmp    100ba3 <runcmd+0x91>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b49:	8b 55 b0             	mov    -0x50(%ebp),%edx
  100b4c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100b4f:	89 c8                	mov    %ecx,%eax
  100b51:	01 c0                	add    %eax,%eax
  100b53:	01 c8                	add    %ecx,%eax
  100b55:	c1 e0 02             	shl    $0x2,%eax
  100b58:	05 00 f0 10 00       	add    $0x10f000,%eax
  100b5d:	8b 00                	mov    (%eax),%eax
  100b5f:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b63:	89 04 24             	mov    %eax,(%esp)
  100b66:	e8 53 25 00 00       	call   1030be <strcmp>
  100b6b:	85 c0                	test   %eax,%eax
  100b6d:	75 31                	jne    100ba0 <runcmd+0x8e>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b72:	89 d0                	mov    %edx,%eax
  100b74:	01 c0                	add    %eax,%eax
  100b76:	01 d0                	add    %edx,%eax
  100b78:	c1 e0 02             	shl    $0x2,%eax
  100b7b:	05 08 f0 10 00       	add    $0x10f008,%eax
  100b80:	8b 10                	mov    (%eax),%edx
  100b82:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b85:	83 c0 04             	add    $0x4,%eax
  100b88:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100b8b:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100b91:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b99:	89 1c 24             	mov    %ebx,(%esp)
  100b9c:	ff d2                	call   *%edx
  100b9e:	eb 23                	jmp    100bc3 <runcmd+0xb1>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba0:	ff 45 f4             	incl   -0xc(%ebp)
  100ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba6:	83 f8 02             	cmp    $0x2,%eax
  100ba9:	76 9e                	jbe    100b49 <runcmd+0x37>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb2:	c7 04 24 27 37 10 00 	movl   $0x103727,(%esp)
  100bb9:	e8 62 f7 ff ff       	call   100320 <cprintf>
    return 0;
  100bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  100bc6:	89 ec                	mov    %ebp,%esp
  100bc8:	5d                   	pop    %ebp
  100bc9:	c3                   	ret    

00100bca <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bca:	55                   	push   %ebp
  100bcb:	89 e5                	mov    %esp,%ebp
  100bcd:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd0:	c7 04 24 40 37 10 00 	movl   $0x103740,(%esp)
  100bd7:	e8 44 f7 ff ff       	call   100320 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bdc:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  100be3:	e8 38 f7 ff ff       	call   100320 <cprintf>

    if (tf != NULL) {
  100be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bec:	74 0b                	je     100bf9 <kmonitor+0x2f>
        print_trapframe(tf);
  100bee:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf1:	89 04 24             	mov    %eax,(%esp)
  100bf4:	e8 0b 0e 00 00       	call   101a04 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf9:	c7 04 24 8d 37 10 00 	movl   $0x10378d,(%esp)
  100c00:	e8 0c f6 ff ff       	call   100211 <readline>
  100c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0c:	74 eb                	je     100bf9 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c18:	89 04 24             	mov    %eax,(%esp)
  100c1b:	e8 f2 fe ff ff       	call   100b12 <runcmd>
  100c20:	85 c0                	test   %eax,%eax
  100c22:	78 02                	js     100c26 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100c24:	eb d3                	jmp    100bf9 <kmonitor+0x2f>
                break;
  100c26:	90                   	nop
            }
        }
    }
}
  100c27:	90                   	nop
  100c28:	89 ec                	mov    %ebp,%esp
  100c2a:	5d                   	pop    %ebp
  100c2b:	c3                   	ret    

00100c2c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c2c:	55                   	push   %ebp
  100c2d:	89 e5                	mov    %esp,%ebp
  100c2f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c39:	eb 3d                	jmp    100c78 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c3b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3e:	89 d0                	mov    %edx,%eax
  100c40:	01 c0                	add    %eax,%eax
  100c42:	01 d0                	add    %edx,%eax
  100c44:	c1 e0 02             	shl    $0x2,%eax
  100c47:	05 04 f0 10 00       	add    $0x10f004,%eax
  100c4c:	8b 10                	mov    (%eax),%edx
  100c4e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  100c51:	89 c8                	mov    %ecx,%eax
  100c53:	01 c0                	add    %eax,%eax
  100c55:	01 c8                	add    %ecx,%eax
  100c57:	c1 e0 02             	shl    $0x2,%eax
  100c5a:	05 00 f0 10 00       	add    $0x10f000,%eax
  100c5f:	8b 00                	mov    (%eax),%eax
  100c61:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c69:	c7 04 24 91 37 10 00 	movl   $0x103791,(%esp)
  100c70:	e8 ab f6 ff ff       	call   100320 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c75:	ff 45 f4             	incl   -0xc(%ebp)
  100c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7b:	83 f8 02             	cmp    $0x2,%eax
  100c7e:	76 bb                	jbe    100c3b <mon_help+0xf>
    }
    return 0;
  100c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c85:	89 ec                	mov    %ebp,%esp
  100c87:	5d                   	pop    %ebp
  100c88:	c3                   	ret    

00100c89 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c89:	55                   	push   %ebp
  100c8a:	89 e5                	mov    %esp,%ebp
  100c8c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c8f:	e8 af fb ff ff       	call   100843 <print_kerninfo>
    return 0;
  100c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c99:	89 ec                	mov    %ebp,%esp
  100c9b:	5d                   	pop    %ebp
  100c9c:	c3                   	ret    

00100c9d <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c9d:	55                   	push   %ebp
  100c9e:	89 e5                	mov    %esp,%ebp
  100ca0:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca3:	e8 e7 fc ff ff       	call   10098f <print_stackframe>
    return 0;
  100ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cad:	89 ec                	mov    %ebp,%esp
  100caf:	5d                   	pop    %ebp
  100cb0:	c3                   	ret    

00100cb1 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cb1:	55                   	push   %ebp
  100cb2:	89 e5                	mov    %esp,%ebp
  100cb4:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb7:	a1 40 fe 10 00       	mov    0x10fe40,%eax
  100cbc:	85 c0                	test   %eax,%eax
  100cbe:	75 5b                	jne    100d1b <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  100cc0:	c7 05 40 fe 10 00 01 	movl   $0x1,0x10fe40
  100cc7:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cca:	8d 45 14             	lea    0x14(%ebp),%eax
  100ccd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  100cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cde:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  100ce5:	e8 36 f6 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf1:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf4:	89 04 24             	mov    %eax,(%esp)
  100cf7:	e8 ef f5 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100cfc:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d03:	e8 18 f6 ff ff       	call   100320 <cprintf>
    
    cprintf("stack trackback:\n");
  100d08:	c7 04 24 b8 37 10 00 	movl   $0x1037b8,(%esp)
  100d0f:	e8 0c f6 ff ff       	call   100320 <cprintf>
    print_stackframe();
  100d14:	e8 76 fc ff ff       	call   10098f <print_stackframe>
  100d19:	eb 01                	jmp    100d1c <__panic+0x6b>
        goto panic_dead;
  100d1b:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d1c:	e8 81 09 00 00       	call   1016a2 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d28:	e8 9d fe ff ff       	call   100bca <kmonitor>
  100d2d:	eb f2                	jmp    100d21 <__panic+0x70>

00100d2f <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d2f:	55                   	push   %ebp
  100d30:	89 e5                	mov    %esp,%ebp
  100d32:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d35:	8d 45 14             	lea    0x14(%ebp),%eax
  100d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d42:	8b 45 08             	mov    0x8(%ebp),%eax
  100d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d49:	c7 04 24 ca 37 10 00 	movl   $0x1037ca,(%esp)
  100d50:	e8 cb f5 ff ff       	call   100320 <cprintf>
    vcprintf(fmt, ap);
  100d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  100d5f:	89 04 24             	mov    %eax,(%esp)
  100d62:	e8 84 f5 ff ff       	call   1002eb <vcprintf>
    cprintf("\n");
  100d67:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d6e:	e8 ad f5 ff ff       	call   100320 <cprintf>
    va_end(ap);
}
  100d73:	90                   	nop
  100d74:	89 ec                	mov    %ebp,%esp
  100d76:	5d                   	pop    %ebp
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 40 fe 10 00       	mov    0x10fe40,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d8e:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d92:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d96:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
}
  100d9b:	90                   	nop
  100d9c:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da2:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100da6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100daa:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dae:	ee                   	out    %al,(%dx)
}
  100daf:	90                   	nop
  100db0:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100db6:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dba:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dbe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc2:	ee                   	out    %al,(%dx)
}
  100dc3:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc4:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  100dcb:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dce:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  100dd5:	e8 46 f5 ff ff       	call   100320 <cprintf>
    pic_enable(IRQ_TIMER);
  100dda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de1:	e8 21 09 00 00       	call   101707 <pic_enable>
}
  100de6:	90                   	nop
  100de7:	89 ec                	mov    %ebp,%esp
  100de9:	5d                   	pop    %ebp
  100dea:	c3                   	ret    

00100deb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100deb:	55                   	push   %ebp
  100dec:	89 e5                	mov    %esp,%ebp
  100dee:	83 ec 10             	sub    $0x10,%esp
  100df1:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100df7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dfb:	89 c2                	mov    %eax,%edx
  100dfd:	ec                   	in     (%dx),%al
  100dfe:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e01:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e07:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0b:	89 c2                	mov    %eax,%edx
  100e0d:	ec                   	in     (%dx),%al
  100e0e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e11:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e17:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e1b:	89 c2                	mov    %eax,%edx
  100e1d:	ec                   	in     (%dx),%al
  100e1e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e21:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e27:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e2b:	89 c2                	mov    %eax,%edx
  100e2d:	ec                   	in     (%dx),%al
  100e2e:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e31:	90                   	nop
  100e32:	89 ec                	mov    %ebp,%esp
  100e34:	5d                   	pop    %ebp
  100e35:	c3                   	ret    

00100e36 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e36:	55                   	push   %ebp
  100e37:	89 e5                	mov    %esp,%ebp
  100e39:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e3c:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e46:	0f b7 00             	movzwl (%eax),%eax
  100e49:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e50:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e58:	0f b7 00             	movzwl (%eax),%eax
  100e5b:	0f b7 c0             	movzwl %ax,%eax
  100e5e:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e63:	74 12                	je     100e77 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e65:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e6c:	66 c7 05 66 fe 10 00 	movw   $0x3b4,0x10fe66
  100e73:	b4 03 
  100e75:	eb 13                	jmp    100e8a <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e7e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e81:	66 c7 05 66 fe 10 00 	movw   $0x3d4,0x10fe66
  100e88:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e8a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100e91:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e95:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e99:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e9d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ea1:	ee                   	out    %al,(%dx)
}
  100ea2:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ea3:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100eaa:	40                   	inc    %eax
  100eab:	0f b7 c0             	movzwl %ax,%eax
  100eae:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100eb6:	89 c2                	mov    %eax,%edx
  100eb8:	ec                   	in     (%dx),%al
  100eb9:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ebc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec0:	0f b6 c0             	movzbl %al,%eax
  100ec3:	c1 e0 08             	shl    $0x8,%eax
  100ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ec9:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ed0:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ed4:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100edc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ee0:	ee                   	out    %al,(%dx)
}
  100ee1:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ee2:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  100ee9:	40                   	inc    %eax
  100eea:	0f b7 c0             	movzwl %ax,%eax
  100eed:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ef5:	89 c2                	mov    %eax,%edx
  100ef7:	ec                   	in     (%dx),%al
  100ef8:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100efb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eff:	0f b6 c0             	movzbl %al,%eax
  100f02:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f08:	a3 60 fe 10 00       	mov    %eax,0x10fe60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f10:	0f b7 c0             	movzwl %ax,%eax
  100f13:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
}
  100f19:	90                   	nop
  100f1a:	89 ec                	mov    %ebp,%esp
  100f1c:	5d                   	pop    %ebp
  100f1d:	c3                   	ret    

00100f1e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f1e:	55                   	push   %ebp
  100f1f:	89 e5                	mov    %esp,%ebp
  100f21:	83 ec 48             	sub    $0x48,%esp
  100f24:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f2a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f32:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f36:	ee                   	out    %al,(%dx)
}
  100f37:	90                   	nop
  100f38:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f3e:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f42:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f46:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f4a:	ee                   	out    %al,(%dx)
}
  100f4b:	90                   	nop
  100f4c:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f52:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f56:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f5a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
}
  100f5f:	90                   	nop
  100f60:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f66:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f6a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f6e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f72:	ee                   	out    %al,(%dx)
}
  100f73:	90                   	nop
  100f74:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f7a:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f7e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f82:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f86:	ee                   	out    %al,(%dx)
}
  100f87:	90                   	nop
  100f88:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f8e:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f92:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f96:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f9a:	ee                   	out    %al,(%dx)
}
  100f9b:	90                   	nop
  100f9c:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fa2:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100faa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fae:	ee                   	out    %al,(%dx)
}
  100faf:	90                   	nop
  100fb0:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fba:	89 c2                	mov    %eax,%edx
  100fbc:	ec                   	in     (%dx),%al
  100fbd:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fc0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fc4:	3c ff                	cmp    $0xff,%al
  100fc6:	0f 95 c0             	setne  %al
  100fc9:	0f b6 c0             	movzbl %al,%eax
  100fcc:	a3 68 fe 10 00       	mov    %eax,0x10fe68
  100fd1:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fd7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fdb:	89 c2                	mov    %eax,%edx
  100fdd:	ec                   	in     (%dx),%al
  100fde:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fe1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fe7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100feb:	89 c2                	mov    %eax,%edx
  100fed:	ec                   	in     (%dx),%al
  100fee:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff1:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  100ff6:	85 c0                	test   %eax,%eax
  100ff8:	74 0c                	je     101006 <serial_init+0xe8>
        pic_enable(IRQ_COM1);
  100ffa:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101001:	e8 01 07 00 00       	call   101707 <pic_enable>
    }
}
  101006:	90                   	nop
  101007:	89 ec                	mov    %ebp,%esp
  101009:	5d                   	pop    %ebp
  10100a:	c3                   	ret    

0010100b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10100b:	55                   	push   %ebp
  10100c:	89 e5                	mov    %esp,%ebp
  10100e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101011:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101018:	eb 08                	jmp    101022 <lpt_putc_sub+0x17>
        delay();
  10101a:	e8 cc fd ff ff       	call   100deb <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10101f:	ff 45 fc             	incl   -0x4(%ebp)
  101022:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101028:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10102c:	89 c2                	mov    %eax,%edx
  10102e:	ec                   	in     (%dx),%al
  10102f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101032:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101036:	84 c0                	test   %al,%al
  101038:	78 09                	js     101043 <lpt_putc_sub+0x38>
  10103a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101041:	7e d7                	jle    10101a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101043:	8b 45 08             	mov    0x8(%ebp),%eax
  101046:	0f b6 c0             	movzbl %al,%eax
  101049:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10104f:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101052:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101056:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10105a:	ee                   	out    %al,(%dx)
}
  10105b:	90                   	nop
  10105c:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101062:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101066:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10106e:	ee                   	out    %al,(%dx)
}
  10106f:	90                   	nop
  101070:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101076:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10107a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101082:	ee                   	out    %al,(%dx)
}
  101083:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101084:	90                   	nop
  101085:	89 ec                	mov    %ebp,%esp
  101087:	5d                   	pop    %ebp
  101088:	c3                   	ret    

00101089 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101089:	55                   	push   %ebp
  10108a:	89 e5                	mov    %esp,%ebp
  10108c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10108f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101093:	74 0d                	je     1010a2 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101095:	8b 45 08             	mov    0x8(%ebp),%eax
  101098:	89 04 24             	mov    %eax,(%esp)
  10109b:	e8 6b ff ff ff       	call   10100b <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010a0:	eb 24                	jmp    1010c6 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010a2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010a9:	e8 5d ff ff ff       	call   10100b <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010ae:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010b5:	e8 51 ff ff ff       	call   10100b <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010ba:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c1:	e8 45 ff ff ff       	call   10100b <lpt_putc_sub>
}
  1010c6:	90                   	nop
  1010c7:	89 ec                	mov    %ebp,%esp
  1010c9:	5d                   	pop    %ebp
  1010ca:	c3                   	ret    

001010cb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010cb:	55                   	push   %ebp
  1010cc:	89 e5                	mov    %esp,%ebp
  1010ce:	83 ec 38             	sub    $0x38,%esp
  1010d1:	89 5d fc             	mov    %ebx,-0x4(%ebp)
    // set black on white
    if (!(c & ~0xFF)) {
  1010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d7:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010dc:	85 c0                	test   %eax,%eax
  1010de:	75 07                	jne    1010e7 <cga_putc+0x1c>
        c |= 0x0700;
  1010e0:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ea:	0f b6 c0             	movzbl %al,%eax
  1010ed:	83 f8 0d             	cmp    $0xd,%eax
  1010f0:	74 72                	je     101164 <cga_putc+0x99>
  1010f2:	83 f8 0d             	cmp    $0xd,%eax
  1010f5:	0f 8f a3 00 00 00    	jg     10119e <cga_putc+0xd3>
  1010fb:	83 f8 08             	cmp    $0x8,%eax
  1010fe:	74 0a                	je     10110a <cga_putc+0x3f>
  101100:	83 f8 0a             	cmp    $0xa,%eax
  101103:	74 4c                	je     101151 <cga_putc+0x86>
  101105:	e9 94 00 00 00       	jmp    10119e <cga_putc+0xd3>
    case '\b':
        if (crt_pos > 0) {
  10110a:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101111:	85 c0                	test   %eax,%eax
  101113:	0f 84 af 00 00 00    	je     1011c8 <cga_putc+0xfd>
            crt_pos --;
  101119:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101120:	48                   	dec    %eax
  101121:	0f b7 c0             	movzwl %ax,%eax
  101124:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10112a:	8b 45 08             	mov    0x8(%ebp),%eax
  10112d:	98                   	cwtl   
  10112e:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101133:	98                   	cwtl   
  101134:	83 c8 20             	or     $0x20,%eax
  101137:	98                   	cwtl   
  101138:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  10113e:	0f b7 15 64 fe 10 00 	movzwl 0x10fe64,%edx
  101145:	01 d2                	add    %edx,%edx
  101147:	01 ca                	add    %ecx,%edx
  101149:	0f b7 c0             	movzwl %ax,%eax
  10114c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10114f:	eb 77                	jmp    1011c8 <cga_putc+0xfd>
    case '\n':
        crt_pos += CRT_COLS;
  101151:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101158:	83 c0 50             	add    $0x50,%eax
  10115b:	0f b7 c0             	movzwl %ax,%eax
  10115e:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101164:	0f b7 1d 64 fe 10 00 	movzwl 0x10fe64,%ebx
  10116b:	0f b7 0d 64 fe 10 00 	movzwl 0x10fe64,%ecx
  101172:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101177:	89 c8                	mov    %ecx,%eax
  101179:	f7 e2                	mul    %edx
  10117b:	c1 ea 06             	shr    $0x6,%edx
  10117e:	89 d0                	mov    %edx,%eax
  101180:	c1 e0 02             	shl    $0x2,%eax
  101183:	01 d0                	add    %edx,%eax
  101185:	c1 e0 04             	shl    $0x4,%eax
  101188:	29 c1                	sub    %eax,%ecx
  10118a:	89 ca                	mov    %ecx,%edx
  10118c:	0f b7 d2             	movzwl %dx,%edx
  10118f:	89 d8                	mov    %ebx,%eax
  101191:	29 d0                	sub    %edx,%eax
  101193:	0f b7 c0             	movzwl %ax,%eax
  101196:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
        break;
  10119c:	eb 2b                	jmp    1011c9 <cga_putc+0xfe>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10119e:	8b 0d 60 fe 10 00    	mov    0x10fe60,%ecx
  1011a4:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011ab:	8d 50 01             	lea    0x1(%eax),%edx
  1011ae:	0f b7 d2             	movzwl %dx,%edx
  1011b1:	66 89 15 64 fe 10 00 	mov    %dx,0x10fe64
  1011b8:	01 c0                	add    %eax,%eax
  1011ba:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c0:	0f b7 c0             	movzwl %ax,%eax
  1011c3:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c6:	eb 01                	jmp    1011c9 <cga_putc+0xfe>
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  1011d0:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011d5:	76 5e                	jbe    101235 <cga_putc+0x16a>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d7:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011dc:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e2:	a1 60 fe 10 00       	mov    0x10fe60,%eax
  1011e7:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ee:	00 
  1011ef:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f3:	89 04 24             	mov    %eax,(%esp)
  1011f6:	e8 5d 21 00 00       	call   103358 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fb:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101202:	eb 15                	jmp    101219 <cga_putc+0x14e>
            crt_buf[i] = 0x0700 | ' ';
  101204:	8b 15 60 fe 10 00    	mov    0x10fe60,%edx
  10120a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10120d:	01 c0                	add    %eax,%eax
  10120f:	01 d0                	add    %edx,%eax
  101211:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101216:	ff 45 f4             	incl   -0xc(%ebp)
  101219:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101220:	7e e2                	jle    101204 <cga_putc+0x139>
        }
        crt_pos -= CRT_COLS;
  101222:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101229:	83 e8 50             	sub    $0x50,%eax
  10122c:	0f b7 c0             	movzwl %ax,%eax
  10122f:	66 a3 64 fe 10 00    	mov    %ax,0x10fe64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101235:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  10123c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101240:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101244:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101248:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10124c:	ee                   	out    %al,(%dx)
}
  10124d:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  10124e:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  101255:	c1 e8 08             	shr    $0x8,%eax
  101258:	0f b7 c0             	movzwl %ax,%eax
  10125b:	0f b6 c0             	movzbl %al,%eax
  10125e:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  101265:	42                   	inc    %edx
  101266:	0f b7 d2             	movzwl %dx,%edx
  101269:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10126d:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101270:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101274:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101278:	ee                   	out    %al,(%dx)
}
  101279:	90                   	nop
    outb(addr_6845, 15);
  10127a:	0f b7 05 66 fe 10 00 	movzwl 0x10fe66,%eax
  101281:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101285:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101289:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10128d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
}
  101292:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  101293:	0f b7 05 64 fe 10 00 	movzwl 0x10fe64,%eax
  10129a:	0f b6 c0             	movzbl %al,%eax
  10129d:	0f b7 15 66 fe 10 00 	movzwl 0x10fe66,%edx
  1012a4:	42                   	inc    %edx
  1012a5:	0f b7 d2             	movzwl %dx,%edx
  1012a8:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012ac:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012af:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012b3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012b7:	ee                   	out    %al,(%dx)
}
  1012b8:	90                   	nop
}
  1012b9:	90                   	nop
  1012ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  1012bd:	89 ec                	mov    %ebp,%esp
  1012bf:	5d                   	pop    %ebp
  1012c0:	c3                   	ret    

001012c1 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c1:	55                   	push   %ebp
  1012c2:	89 e5                	mov    %esp,%ebp
  1012c4:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012ce:	eb 08                	jmp    1012d8 <serial_putc_sub+0x17>
        delay();
  1012d0:	e8 16 fb ff ff       	call   100deb <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d5:	ff 45 fc             	incl   -0x4(%ebp)
  1012d8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012de:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e2:	89 c2                	mov    %eax,%edx
  1012e4:	ec                   	in     (%dx),%al
  1012e5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012ec:	0f b6 c0             	movzbl %al,%eax
  1012ef:	83 e0 20             	and    $0x20,%eax
  1012f2:	85 c0                	test   %eax,%eax
  1012f4:	75 09                	jne    1012ff <serial_putc_sub+0x3e>
  1012f6:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fd:	7e d1                	jle    1012d0 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101302:	0f b6 c0             	movzbl %al,%eax
  101305:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130b:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10130e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101312:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101316:	ee                   	out    %al,(%dx)
}
  101317:	90                   	nop
}
  101318:	90                   	nop
  101319:	89 ec                	mov    %ebp,%esp
  10131b:	5d                   	pop    %ebp
  10131c:	c3                   	ret    

0010131d <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131d:	55                   	push   %ebp
  10131e:	89 e5                	mov    %esp,%ebp
  101320:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101323:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101327:	74 0d                	je     101336 <serial_putc+0x19>
        serial_putc_sub(c);
  101329:	8b 45 08             	mov    0x8(%ebp),%eax
  10132c:	89 04 24             	mov    %eax,(%esp)
  10132f:	e8 8d ff ff ff       	call   1012c1 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101334:	eb 24                	jmp    10135a <serial_putc+0x3d>
        serial_putc_sub('\b');
  101336:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133d:	e8 7f ff ff ff       	call   1012c1 <serial_putc_sub>
        serial_putc_sub(' ');
  101342:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101349:	e8 73 ff ff ff       	call   1012c1 <serial_putc_sub>
        serial_putc_sub('\b');
  10134e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101355:	e8 67 ff ff ff       	call   1012c1 <serial_putc_sub>
}
  10135a:	90                   	nop
  10135b:	89 ec                	mov    %ebp,%esp
  10135d:	5d                   	pop    %ebp
  10135e:	c3                   	ret    

0010135f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135f:	55                   	push   %ebp
  101360:	89 e5                	mov    %esp,%ebp
  101362:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101365:	eb 33                	jmp    10139a <cons_intr+0x3b>
        if (c != 0) {
  101367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136b:	74 2d                	je     10139a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136d:	a1 84 00 11 00       	mov    0x110084,%eax
  101372:	8d 50 01             	lea    0x1(%eax),%edx
  101375:	89 15 84 00 11 00    	mov    %edx,0x110084
  10137b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137e:	88 90 80 fe 10 00    	mov    %dl,0x10fe80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101384:	a1 84 00 11 00       	mov    0x110084,%eax
  101389:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138e:	75 0a                	jne    10139a <cons_intr+0x3b>
                cons.wpos = 0;
  101390:	c7 05 84 00 11 00 00 	movl   $0x0,0x110084
  101397:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10139a:	8b 45 08             	mov    0x8(%ebp),%eax
  10139d:	ff d0                	call   *%eax
  10139f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a6:	75 bf                	jne    101367 <cons_intr+0x8>
            }
        }
    }
}
  1013a8:	90                   	nop
  1013a9:	90                   	nop
  1013aa:	89 ec                	mov    %ebp,%esp
  1013ac:	5d                   	pop    %ebp
  1013ad:	c3                   	ret    

001013ae <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ae:	55                   	push   %ebp
  1013af:	89 e5                	mov    %esp,%ebp
  1013b1:	83 ec 10             	sub    $0x10,%esp
  1013b4:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ba:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013be:	89 c2                	mov    %eax,%edx
  1013c0:	ec                   	in     (%dx),%al
  1013c1:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013c4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c8:	0f b6 c0             	movzbl %al,%eax
  1013cb:	83 e0 01             	and    $0x1,%eax
  1013ce:	85 c0                	test   %eax,%eax
  1013d0:	75 07                	jne    1013d9 <serial_proc_data+0x2b>
        return -1;
  1013d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d7:	eb 2a                	jmp    101403 <serial_proc_data+0x55>
  1013d9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013df:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013e3:	89 c2                	mov    %eax,%edx
  1013e5:	ec                   	in     (%dx),%al
  1013e6:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ed:	0f b6 c0             	movzbl %al,%eax
  1013f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013f3:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f7:	75 07                	jne    101400 <serial_proc_data+0x52>
        c = '\b';
  1013f9:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101400:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101403:	89 ec                	mov    %ebp,%esp
  101405:	5d                   	pop    %ebp
  101406:	c3                   	ret    

00101407 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101407:	55                   	push   %ebp
  101408:	89 e5                	mov    %esp,%ebp
  10140a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10140d:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  101412:	85 c0                	test   %eax,%eax
  101414:	74 0c                	je     101422 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101416:	c7 04 24 ae 13 10 00 	movl   $0x1013ae,(%esp)
  10141d:	e8 3d ff ff ff       	call   10135f <cons_intr>
    }
}
  101422:	90                   	nop
  101423:	89 ec                	mov    %ebp,%esp
  101425:	5d                   	pop    %ebp
  101426:	c3                   	ret    

00101427 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101427:	55                   	push   %ebp
  101428:	89 e5                	mov    %esp,%ebp
  10142a:	83 ec 38             	sub    $0x38,%esp
  10142d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101436:	89 c2                	mov    %eax,%edx
  101438:	ec                   	in     (%dx),%al
  101439:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10143c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101440:	0f b6 c0             	movzbl %al,%eax
  101443:	83 e0 01             	and    $0x1,%eax
  101446:	85 c0                	test   %eax,%eax
  101448:	75 0a                	jne    101454 <kbd_proc_data+0x2d>
        return -1;
  10144a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10144f:	e9 56 01 00 00       	jmp    1015aa <kbd_proc_data+0x183>
  101454:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10145a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10145d:	89 c2                	mov    %eax,%edx
  10145f:	ec                   	in     (%dx),%al
  101460:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101463:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101467:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10146a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10146e:	75 17                	jne    101487 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101470:	a1 88 00 11 00       	mov    0x110088,%eax
  101475:	83 c8 40             	or     $0x40,%eax
  101478:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  10147d:	b8 00 00 00 00       	mov    $0x0,%eax
  101482:	e9 23 01 00 00       	jmp    1015aa <kbd_proc_data+0x183>
    } else if (data & 0x80) {
  101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148b:	84 c0                	test   %al,%al
  10148d:	79 45                	jns    1014d4 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10148f:	a1 88 00 11 00       	mov    0x110088,%eax
  101494:	83 e0 40             	and    $0x40,%eax
  101497:	85 c0                	test   %eax,%eax
  101499:	75 08                	jne    1014a3 <kbd_proc_data+0x7c>
  10149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149f:	24 7f                	and    $0x7f,%al
  1014a1:	eb 04                	jmp    1014a7 <kbd_proc_data+0x80>
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014aa:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ae:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014b5:	0c 40                	or     $0x40,%al
  1014b7:	0f b6 c0             	movzbl %al,%eax
  1014ba:	f7 d0                	not    %eax
  1014bc:	89 c2                	mov    %eax,%edx
  1014be:	a1 88 00 11 00       	mov    0x110088,%eax
  1014c3:	21 d0                	and    %edx,%eax
  1014c5:	a3 88 00 11 00       	mov    %eax,0x110088
        return 0;
  1014ca:	b8 00 00 00 00       	mov    $0x0,%eax
  1014cf:	e9 d6 00 00 00       	jmp    1015aa <kbd_proc_data+0x183>
    } else if (shift & E0ESC) {
  1014d4:	a1 88 00 11 00       	mov    0x110088,%eax
  1014d9:	83 e0 40             	and    $0x40,%eax
  1014dc:	85 c0                	test   %eax,%eax
  1014de:	74 11                	je     1014f1 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014e0:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014e4:	a1 88 00 11 00       	mov    0x110088,%eax
  1014e9:	83 e0 bf             	and    $0xffffffbf,%eax
  1014ec:	a3 88 00 11 00       	mov    %eax,0x110088
    }

    shift |= shiftcode[data];
  1014f1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f5:	0f b6 80 40 f0 10 00 	movzbl 0x10f040(%eax),%eax
  1014fc:	0f b6 d0             	movzbl %al,%edx
  1014ff:	a1 88 00 11 00       	mov    0x110088,%eax
  101504:	09 d0                	or     %edx,%eax
  101506:	a3 88 00 11 00       	mov    %eax,0x110088
    shift ^= togglecode[data];
  10150b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150f:	0f b6 80 40 f1 10 00 	movzbl 0x10f140(%eax),%eax
  101516:	0f b6 d0             	movzbl %al,%edx
  101519:	a1 88 00 11 00       	mov    0x110088,%eax
  10151e:	31 d0                	xor    %edx,%eax
  101520:	a3 88 00 11 00       	mov    %eax,0x110088

    c = charcode[shift & (CTL | SHIFT)][data];
  101525:	a1 88 00 11 00       	mov    0x110088,%eax
  10152a:	83 e0 03             	and    $0x3,%eax
  10152d:	8b 14 85 40 f5 10 00 	mov    0x10f540(,%eax,4),%edx
  101534:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101538:	01 d0                	add    %edx,%eax
  10153a:	0f b6 00             	movzbl (%eax),%eax
  10153d:	0f b6 c0             	movzbl %al,%eax
  101540:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101543:	a1 88 00 11 00       	mov    0x110088,%eax
  101548:	83 e0 08             	and    $0x8,%eax
  10154b:	85 c0                	test   %eax,%eax
  10154d:	74 22                	je     101571 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  10154f:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101553:	7e 0c                	jle    101561 <kbd_proc_data+0x13a>
  101555:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101559:	7f 06                	jg     101561 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10155b:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10155f:	eb 10                	jmp    101571 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101561:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101565:	7e 0a                	jle    101571 <kbd_proc_data+0x14a>
  101567:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10156b:	7f 04                	jg     101571 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  10156d:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101571:	a1 88 00 11 00       	mov    0x110088,%eax
  101576:	f7 d0                	not    %eax
  101578:	83 e0 06             	and    $0x6,%eax
  10157b:	85 c0                	test   %eax,%eax
  10157d:	75 28                	jne    1015a7 <kbd_proc_data+0x180>
  10157f:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101586:	75 1f                	jne    1015a7 <kbd_proc_data+0x180>
        cprintf("Rebooting!\n");
  101588:	c7 04 24 03 38 10 00 	movl   $0x103803,(%esp)
  10158f:	e8 8c ed ff ff       	call   100320 <cprintf>
  101594:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10159a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10159e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1015a5:	ee                   	out    %al,(%dx)
}
  1015a6:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015aa:	89 ec                	mov    %ebp,%esp
  1015ac:	5d                   	pop    %ebp
  1015ad:	c3                   	ret    

001015ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015ae:	55                   	push   %ebp
  1015af:	89 e5                	mov    %esp,%ebp
  1015b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015b4:	c7 04 24 27 14 10 00 	movl   $0x101427,(%esp)
  1015bb:	e8 9f fd ff ff       	call   10135f <cons_intr>
}
  1015c0:	90                   	nop
  1015c1:	89 ec                	mov    %ebp,%esp
  1015c3:	5d                   	pop    %ebp
  1015c4:	c3                   	ret    

001015c5 <kbd_init>:

static void
kbd_init(void) {
  1015c5:	55                   	push   %ebp
  1015c6:	89 e5                	mov    %esp,%ebp
  1015c8:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015cb:	e8 de ff ff ff       	call   1015ae <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015d7:	e8 2b 01 00 00       	call   101707 <pic_enable>
}
  1015dc:	90                   	nop
  1015dd:	89 ec                	mov    %ebp,%esp
  1015df:	5d                   	pop    %ebp
  1015e0:	c3                   	ret    

001015e1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e1:	55                   	push   %ebp
  1015e2:	89 e5                	mov    %esp,%ebp
  1015e4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015e7:	e8 4a f8 ff ff       	call   100e36 <cga_init>
    serial_init();
  1015ec:	e8 2d f9 ff ff       	call   100f1e <serial_init>
    kbd_init();
  1015f1:	e8 cf ff ff ff       	call   1015c5 <kbd_init>
    if (!serial_exists) {
  1015f6:	a1 68 fe 10 00       	mov    0x10fe68,%eax
  1015fb:	85 c0                	test   %eax,%eax
  1015fd:	75 0c                	jne    10160b <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ff:	c7 04 24 0f 38 10 00 	movl   $0x10380f,(%esp)
  101606:	e8 15 ed ff ff       	call   100320 <cprintf>
    }
}
  10160b:	90                   	nop
  10160c:	89 ec                	mov    %ebp,%esp
  10160e:	5d                   	pop    %ebp
  10160f:	c3                   	ret    

00101610 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101610:	55                   	push   %ebp
  101611:	89 e5                	mov    %esp,%ebp
  101613:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101616:	8b 45 08             	mov    0x8(%ebp),%eax
  101619:	89 04 24             	mov    %eax,(%esp)
  10161c:	e8 68 fa ff ff       	call   101089 <lpt_putc>
    cga_putc(c);
  101621:	8b 45 08             	mov    0x8(%ebp),%eax
  101624:	89 04 24             	mov    %eax,(%esp)
  101627:	e8 9f fa ff ff       	call   1010cb <cga_putc>
    serial_putc(c);
  10162c:	8b 45 08             	mov    0x8(%ebp),%eax
  10162f:	89 04 24             	mov    %eax,(%esp)
  101632:	e8 e6 fc ff ff       	call   10131d <serial_putc>
}
  101637:	90                   	nop
  101638:	89 ec                	mov    %ebp,%esp
  10163a:	5d                   	pop    %ebp
  10163b:	c3                   	ret    

0010163c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163c:	55                   	push   %ebp
  10163d:	89 e5                	mov    %esp,%ebp
  10163f:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101642:	e8 c0 fd ff ff       	call   101407 <serial_intr>
    kbd_intr();
  101647:	e8 62 ff ff ff       	call   1015ae <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10164c:	8b 15 80 00 11 00    	mov    0x110080,%edx
  101652:	a1 84 00 11 00       	mov    0x110084,%eax
  101657:	39 c2                	cmp    %eax,%edx
  101659:	74 36                	je     101691 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10165b:	a1 80 00 11 00       	mov    0x110080,%eax
  101660:	8d 50 01             	lea    0x1(%eax),%edx
  101663:	89 15 80 00 11 00    	mov    %edx,0x110080
  101669:	0f b6 80 80 fe 10 00 	movzbl 0x10fe80(%eax),%eax
  101670:	0f b6 c0             	movzbl %al,%eax
  101673:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101676:	a1 80 00 11 00       	mov    0x110080,%eax
  10167b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101680:	75 0a                	jne    10168c <cons_getc+0x50>
            cons.rpos = 0;
  101682:	c7 05 80 00 11 00 00 	movl   $0x0,0x110080
  101689:	00 00 00 
        }
        return c;
  10168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10168f:	eb 05                	jmp    101696 <cons_getc+0x5a>
    }
    return 0;
  101691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101696:	89 ec                	mov    %ebp,%esp
  101698:	5d                   	pop    %ebp
  101699:	c3                   	ret    

0010169a <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10169a:	55                   	push   %ebp
  10169b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10169d:	fb                   	sti    
}
  10169e:	90                   	nop
    sti();
}
  10169f:	90                   	nop
  1016a0:	5d                   	pop    %ebp
  1016a1:	c3                   	ret    

001016a2 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a2:	55                   	push   %ebp
  1016a3:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  1016a5:	fa                   	cli    
}
  1016a6:	90                   	nop
    cli();
}
  1016a7:	90                   	nop
  1016a8:	5d                   	pop    %ebp
  1016a9:	c3                   	ret    

001016aa <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
  1016ad:	83 ec 14             	sub    $0x14,%esp
  1016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016ba:	66 a3 50 f5 10 00    	mov    %ax,0x10f550
    if (did_init) {
  1016c0:	a1 8c 00 11 00       	mov    0x11008c,%eax
  1016c5:	85 c0                	test   %eax,%eax
  1016c7:	74 39                	je     101702 <pic_setmask+0x58>
        outb(IO_PIC1 + 1, mask);
  1016c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016cc:	0f b6 c0             	movzbl %al,%eax
  1016cf:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016dc:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e0:	ee                   	out    %al,(%dx)
}
  1016e1:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1016e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e6:	c1 e8 08             	shr    $0x8,%eax
  1016e9:	0f b7 c0             	movzwl %ax,%eax
  1016ec:	0f b6 c0             	movzbl %al,%eax
  1016ef:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016f5:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1016f8:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016fc:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101700:	ee                   	out    %al,(%dx)
}
  101701:	90                   	nop
    }
}
  101702:	90                   	nop
  101703:	89 ec                	mov    %ebp,%esp
  101705:	5d                   	pop    %ebp
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	88 c1                	mov    %al,%cl
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	98                   	cwtl   
  10171c:	f7 d0                	not    %eax
  10171e:	0f bf d0             	movswl %ax,%edx
  101721:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101728:	98                   	cwtl   
  101729:	21 d0                	and    %edx,%eax
  10172b:	98                   	cwtl   
  10172c:	0f b7 c0             	movzwl %ax,%eax
  10172f:	89 04 24             	mov    %eax,(%esp)
  101732:	e8 73 ff ff ff       	call   1016aa <pic_setmask>
}
  101737:	90                   	nop
  101738:	89 ec                	mov    %ebp,%esp
  10173a:	5d                   	pop    %ebp
  10173b:	c3                   	ret    

0010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173c:	55                   	push   %ebp
  10173d:	89 e5                	mov    %esp,%ebp
  10173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101742:	c7 05 8c 00 11 00 01 	movl   $0x1,0x11008c
  101749:	00 00 00 
  10174c:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101752:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101756:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10175a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
}
  10175f:	90                   	nop
  101760:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101766:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10176a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10176e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101772:	ee                   	out    %al,(%dx)
}
  101773:	90                   	nop
  101774:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10177a:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10177e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101782:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
}
  101787:	90                   	nop
  101788:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10178e:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101792:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101796:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179a:	ee                   	out    %al,(%dx)
}
  10179b:	90                   	nop
  10179c:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1017a2:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017a6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017aa:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
}
  1017af:	90                   	nop
  1017b0:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017b6:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ba:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017be:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017c2:	ee                   	out    %al,(%dx)
}
  1017c3:	90                   	nop
  1017c4:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017ca:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
}
  1017d7:	90                   	nop
  1017d8:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017de:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017e2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
}
  1017eb:	90                   	nop
  1017ec:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017f2:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017f6:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017fa:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017fe:	ee                   	out    %al,(%dx)
}
  1017ff:	90                   	nop
  101800:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101806:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10180a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10180e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
}
  101813:	90                   	nop
  101814:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10181a:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10181e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101822:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101826:	ee                   	out    %al,(%dx)
}
  101827:	90                   	nop
  101828:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10182e:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101832:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101836:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10183a:	ee                   	out    %al,(%dx)
}
  10183b:	90                   	nop
  10183c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101842:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101846:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10184a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
}
  10184f:	90                   	nop
  101850:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101856:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10185a:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10185e:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101862:	ee                   	out    %al,(%dx)
}
  101863:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101864:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  10186b:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101870:	74 0f                	je     101881 <pic_init+0x145>
        pic_setmask(irq_mask);
  101872:	0f b7 05 50 f5 10 00 	movzwl 0x10f550,%eax
  101879:	89 04 24             	mov    %eax,(%esp)
  10187c:	e8 29 fe ff ff       	call   1016aa <pic_setmask>
    }
}
  101881:	90                   	nop
  101882:	89 ec                	mov    %ebp,%esp
  101884:	5d                   	pop    %ebp
  101885:	c3                   	ret    

00101886 <print_ticks>:
#include <kdebug.h>

#define TICK_NUM 100
extern uintptr_t __vectors[];

static void print_ticks() {
  101886:	55                   	push   %ebp
  101887:	89 e5                	mov    %esp,%ebp
  101889:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10188c:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101893:	00 
  101894:	c7 04 24 40 38 10 00 	movl   $0x103840,(%esp)
  10189b:	e8 80 ea ff ff       	call   100320 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018a0:	c7 04 24 4a 38 10 00 	movl   $0x10384a,(%esp)
  1018a7:	e8 74 ea ff ff       	call   100320 <cprintf>
    panic("EOT: kernel seems ok.");
  1018ac:	c7 44 24 08 58 38 10 	movl   $0x103858,0x8(%esp)
  1018b3:	00 
  1018b4:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  1018bb:	00 
  1018bc:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  1018c3:	e8 e9 f3 ff ff       	call   100cb1 <__panic>

001018c8 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018c8:	55                   	push   %ebp
  1018c9:	89 e5                	mov    %esp,%ebp
  1018cb:	83 ec 10             	sub    $0x10,%esp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
      for(int i=0;i<256;i++){
  1018ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018d5:	e9 c4 00 00 00       	jmp    10199e <idt_init+0xd6>
      	SETGATE(idt[i],0,KERNEL_CS,__vectors[i],DPL_KERNEL);
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  1018e4:	0f b7 d0             	movzwl %ax,%edx
  1018e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ea:	66 89 14 c5 a0 00 11 	mov    %dx,0x1100a0(,%eax,8)
  1018f1:	00 
  1018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f5:	66 c7 04 c5 a2 00 11 	movw   $0x8,0x1100a2(,%eax,8)
  1018fc:	00 08 00 
  1018ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101902:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  101909:	00 
  10190a:	80 e2 e0             	and    $0xe0,%dl
  10190d:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  101914:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101917:	0f b6 14 c5 a4 00 11 	movzbl 0x1100a4(,%eax,8),%edx
  10191e:	00 
  10191f:	80 e2 1f             	and    $0x1f,%dl
  101922:	88 14 c5 a4 00 11 00 	mov    %dl,0x1100a4(,%eax,8)
  101929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192c:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101933:	00 
  101934:	80 e2 f0             	and    $0xf0,%dl
  101937:	80 ca 0e             	or     $0xe,%dl
  10193a:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101941:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101944:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  10194b:	00 
  10194c:	80 e2 ef             	and    $0xef,%dl
  10194f:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101956:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101959:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101960:	00 
  101961:	80 e2 9f             	and    $0x9f,%dl
  101964:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  10196b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196e:	0f b6 14 c5 a5 00 11 	movzbl 0x1100a5(,%eax,8),%edx
  101975:	00 
  101976:	80 ca 80             	or     $0x80,%dl
  101979:	88 14 c5 a5 00 11 00 	mov    %dl,0x1100a5(,%eax,8)
  101980:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101983:	8b 04 85 e0 f5 10 00 	mov    0x10f5e0(,%eax,4),%eax
  10198a:	c1 e8 10             	shr    $0x10,%eax
  10198d:	0f b7 d0             	movzwl %ax,%edx
  101990:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101993:	66 89 14 c5 a6 00 11 	mov    %dx,0x1100a6(,%eax,8)
  10199a:	00 
      for(int i=0;i<256;i++){
  10199b:	ff 45 fc             	incl   -0x4(%ebp)
  10199e:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019a5:	0f 8e 2f ff ff ff    	jle    1018da <idt_init+0x12>
  1019ab:	c7 45 f8 60 f5 10 00 	movl   $0x10f560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019b5:	0f 01 18             	lidtl  (%eax)
}
  1019b8:	90                   	nop
      
      }
      lidt(&idt_pd);
}
  1019b9:	90                   	nop
  1019ba:	89 ec                	mov    %ebp,%esp
  1019bc:	5d                   	pop    %ebp
  1019bd:	c3                   	ret    

001019be <trapname>:

static const char *
trapname(int trapno) {
  1019be:	55                   	push   %ebp
  1019bf:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c4:	83 f8 13             	cmp    $0x13,%eax
  1019c7:	77 0c                	ja     1019d5 <trapname+0x17>
        return excnames[trapno];
  1019c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cc:	8b 04 85 c0 3b 10 00 	mov    0x103bc0(,%eax,4),%eax
  1019d3:	eb 18                	jmp    1019ed <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019d5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019d9:	7e 0d                	jle    1019e8 <trapname+0x2a>
  1019db:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019df:	7f 07                	jg     1019e8 <trapname+0x2a>
        return "Hardware Interrupt";
  1019e1:	b8 7f 38 10 00       	mov    $0x10387f,%eax
  1019e6:	eb 05                	jmp    1019ed <trapname+0x2f>
    }
    return "(unknown trap)";
  1019e8:	b8 92 38 10 00       	mov    $0x103892,%eax
}
  1019ed:	5d                   	pop    %ebp
  1019ee:	c3                   	ret    

001019ef <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019ef:	55                   	push   %ebp
  1019f0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019f9:	83 f8 08             	cmp    $0x8,%eax
  1019fc:	0f 94 c0             	sete   %al
  1019ff:	0f b6 c0             	movzbl %al,%eax
}
  101a02:	5d                   	pop    %ebp
  101a03:	c3                   	ret    

00101a04 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a04:	55                   	push   %ebp
  101a05:	89 e5                	mov    %esp,%ebp
  101a07:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a11:	c7 04 24 d3 38 10 00 	movl   $0x1038d3,(%esp)
  101a18:	e8 03 e9 ff ff       	call   100320 <cprintf>
    print_regs(&tf->tf_regs);
  101a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a20:	89 04 24             	mov    %eax,(%esp)
  101a23:	e8 8f 01 00 00       	call   101bb7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a28:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2b:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a33:	c7 04 24 e4 38 10 00 	movl   $0x1038e4,(%esp)
  101a3a:	e8 e1 e8 ff ff       	call   100320 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a42:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a4a:	c7 04 24 f7 38 10 00 	movl   $0x1038f7,(%esp)
  101a51:	e8 ca e8 ff ff       	call   100320 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a56:	8b 45 08             	mov    0x8(%ebp),%eax
  101a59:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a61:	c7 04 24 0a 39 10 00 	movl   $0x10390a,(%esp)
  101a68:	e8 b3 e8 ff ff       	call   100320 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a70:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a78:	c7 04 24 1d 39 10 00 	movl   $0x10391d,(%esp)
  101a7f:	e8 9c e8 ff ff       	call   100320 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a84:	8b 45 08             	mov    0x8(%ebp),%eax
  101a87:	8b 40 30             	mov    0x30(%eax),%eax
  101a8a:	89 04 24             	mov    %eax,(%esp)
  101a8d:	e8 2c ff ff ff       	call   1019be <trapname>
  101a92:	8b 55 08             	mov    0x8(%ebp),%edx
  101a95:	8b 52 30             	mov    0x30(%edx),%edx
  101a98:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a9c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aa0:	c7 04 24 30 39 10 00 	movl   $0x103930,(%esp)
  101aa7:	e8 74 e8 ff ff       	call   100320 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aac:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaf:	8b 40 34             	mov    0x34(%eax),%eax
  101ab2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab6:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  101abd:	e8 5e e8 ff ff       	call   100320 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac5:	8b 40 38             	mov    0x38(%eax),%eax
  101ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acc:	c7 04 24 51 39 10 00 	movl   $0x103951,(%esp)
  101ad3:	e8 48 e8 ff ff       	call   100320 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  101adb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae3:	c7 04 24 60 39 10 00 	movl   $0x103960,(%esp)
  101aea:	e8 31 e8 ff ff       	call   100320 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101aef:	8b 45 08             	mov    0x8(%ebp),%eax
  101af2:	8b 40 40             	mov    0x40(%eax),%eax
  101af5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af9:	c7 04 24 73 39 10 00 	movl   $0x103973,(%esp)
  101b00:	e8 1b e8 ff ff       	call   100320 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b0c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b13:	eb 3d                	jmp    101b52 <print_trapframe+0x14e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b15:	8b 45 08             	mov    0x8(%ebp),%eax
  101b18:	8b 50 40             	mov    0x40(%eax),%edx
  101b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b1e:	21 d0                	and    %edx,%eax
  101b20:	85 c0                	test   %eax,%eax
  101b22:	74 28                	je     101b4c <print_trapframe+0x148>
  101b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b27:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b2e:	85 c0                	test   %eax,%eax
  101b30:	74 1a                	je     101b4c <print_trapframe+0x148>
            cprintf("%s,", IA32flags[i]);
  101b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b35:	8b 04 85 80 f5 10 00 	mov    0x10f580(,%eax,4),%eax
  101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b40:	c7 04 24 82 39 10 00 	movl   $0x103982,(%esp)
  101b47:	e8 d4 e7 ff ff       	call   100320 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b4c:	ff 45 f4             	incl   -0xc(%ebp)
  101b4f:	d1 65 f0             	shll   -0x10(%ebp)
  101b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b55:	83 f8 17             	cmp    $0x17,%eax
  101b58:	76 bb                	jbe    101b15 <print_trapframe+0x111>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5d:	8b 40 40             	mov    0x40(%eax),%eax
  101b60:	c1 e8 0c             	shr    $0xc,%eax
  101b63:	83 e0 03             	and    $0x3,%eax
  101b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6a:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  101b71:	e8 aa e7 ff ff       	call   100320 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	89 04 24             	mov    %eax,(%esp)
  101b7c:	e8 6e fe ff ff       	call   1019ef <trap_in_kernel>
  101b81:	85 c0                	test   %eax,%eax
  101b83:	75 2d                	jne    101bb2 <print_trapframe+0x1ae>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b85:	8b 45 08             	mov    0x8(%ebp),%eax
  101b88:	8b 40 44             	mov    0x44(%eax),%eax
  101b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8f:	c7 04 24 8f 39 10 00 	movl   $0x10398f,(%esp)
  101b96:	e8 85 e7 ff ff       	call   100320 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9e:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba6:	c7 04 24 9e 39 10 00 	movl   $0x10399e,(%esp)
  101bad:	e8 6e e7 ff ff       	call   100320 <cprintf>
    }
}
  101bb2:	90                   	nop
  101bb3:	89 ec                	mov    %ebp,%esp
  101bb5:	5d                   	pop    %ebp
  101bb6:	c3                   	ret    

00101bb7 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb7:	55                   	push   %ebp
  101bb8:	89 e5                	mov    %esp,%ebp
  101bba:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	8b 00                	mov    (%eax),%eax
  101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc6:	c7 04 24 b1 39 10 00 	movl   $0x1039b1,(%esp)
  101bcd:	e8 4e e7 ff ff       	call   100320 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	8b 40 04             	mov    0x4(%eax),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  101be3:	e8 38 e7 ff ff       	call   100320 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be8:	8b 45 08             	mov    0x8(%ebp),%eax
  101beb:	8b 40 08             	mov    0x8(%eax),%eax
  101bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf2:	c7 04 24 cf 39 10 00 	movl   $0x1039cf,(%esp)
  101bf9:	e8 22 e7 ff ff       	call   100320 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101c01:	8b 40 0c             	mov    0xc(%eax),%eax
  101c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c08:	c7 04 24 de 39 10 00 	movl   $0x1039de,(%esp)
  101c0f:	e8 0c e7 ff ff       	call   100320 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c14:	8b 45 08             	mov    0x8(%ebp),%eax
  101c17:	8b 40 10             	mov    0x10(%eax),%eax
  101c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1e:	c7 04 24 ed 39 10 00 	movl   $0x1039ed,(%esp)
  101c25:	e8 f6 e6 ff ff       	call   100320 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2d:	8b 40 14             	mov    0x14(%eax),%eax
  101c30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c34:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  101c3b:	e8 e0 e6 ff ff       	call   100320 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c40:	8b 45 08             	mov    0x8(%ebp),%eax
  101c43:	8b 40 18             	mov    0x18(%eax),%eax
  101c46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4a:	c7 04 24 0b 3a 10 00 	movl   $0x103a0b,(%esp)
  101c51:	e8 ca e6 ff ff       	call   100320 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c56:	8b 45 08             	mov    0x8(%ebp),%eax
  101c59:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c60:	c7 04 24 1a 3a 10 00 	movl   $0x103a1a,(%esp)
  101c67:	e8 b4 e6 ff ff       	call   100320 <cprintf>
}
  101c6c:	90                   	nop
  101c6d:	89 ec                	mov    %ebp,%esp
  101c6f:	5d                   	pop    %ebp
  101c70:	c3                   	ret    

00101c71 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c71:	55                   	push   %ebp
  101c72:	89 e5                	mov    %esp,%ebp
  101c74:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 30             	mov    0x30(%eax),%eax
  101c7d:	83 f8 79             	cmp    $0x79,%eax
  101c80:	0f 87 cd 00 00 00    	ja     101d53 <trap_dispatch+0xe2>
  101c86:	83 f8 78             	cmp    $0x78,%eax
  101c89:	0f 83 a8 00 00 00    	jae    101d37 <trap_dispatch+0xc6>
  101c8f:	83 f8 2f             	cmp    $0x2f,%eax
  101c92:	0f 87 bb 00 00 00    	ja     101d53 <trap_dispatch+0xe2>
  101c98:	83 f8 2e             	cmp    $0x2e,%eax
  101c9b:	0f 83 e7 00 00 00    	jae    101d88 <trap_dispatch+0x117>
  101ca1:	83 f8 24             	cmp    $0x24,%eax
  101ca4:	74 45                	je     101ceb <trap_dispatch+0x7a>
  101ca6:	83 f8 24             	cmp    $0x24,%eax
  101ca9:	0f 87 a4 00 00 00    	ja     101d53 <trap_dispatch+0xe2>
  101caf:	83 f8 20             	cmp    $0x20,%eax
  101cb2:	74 0a                	je     101cbe <trap_dispatch+0x4d>
  101cb4:	83 f8 21             	cmp    $0x21,%eax
  101cb7:	74 58                	je     101d11 <trap_dispatch+0xa0>
  101cb9:	e9 95 00 00 00       	jmp    101d53 <trap_dispatch+0xe2>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
         ticks ++;
  101cbe:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101cc3:	40                   	inc    %eax
  101cc4:	a3 44 fe 10 00       	mov    %eax,0x10fe44
        if (ticks == TICK_NUM)
  101cc9:	a1 44 fe 10 00       	mov    0x10fe44,%eax
  101cce:	83 f8 64             	cmp    $0x64,%eax
  101cd1:	0f 85 b4 00 00 00    	jne    101d8b <trap_dispatch+0x11a>
        {
            ticks = 0;
  101cd7:	c7 05 44 fe 10 00 00 	movl   $0x0,0x10fe44
  101cde:	00 00 00 
            print_ticks();
  101ce1:	e8 a0 fb ff ff       	call   101886 <print_ticks>
        }
        break;
  101ce6:	e9 a0 00 00 00       	jmp    101d8b <trap_dispatch+0x11a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ceb:	e8 4c f9 ff ff       	call   10163c <cons_getc>
  101cf0:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cf3:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf7:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cfb:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d03:	c7 04 24 29 3a 10 00 	movl   $0x103a29,(%esp)
  101d0a:	e8 11 e6 ff ff       	call   100320 <cprintf>
        break;
  101d0f:	eb 7b                	jmp    101d8c <trap_dispatch+0x11b>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d11:	e8 26 f9 ff ff       	call   10163c <cons_getc>
  101d16:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d19:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d1d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d21:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d29:	c7 04 24 3b 3a 10 00 	movl   $0x103a3b,(%esp)
  101d30:	e8 eb e5 ff ff       	call   100320 <cprintf>
        break;
  101d35:	eb 55                	jmp    101d8c <trap_dispatch+0x11b>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d37:	c7 44 24 08 4a 3a 10 	movl   $0x103a4a,0x8(%esp)
  101d3e:	00 
  101d3f:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101d46:	00 
  101d47:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  101d4e:	e8 5e ef ff ff       	call   100cb1 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d53:	8b 45 08             	mov    0x8(%ebp),%eax
  101d56:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d5a:	83 e0 03             	and    $0x3,%eax
  101d5d:	85 c0                	test   %eax,%eax
  101d5f:	75 2b                	jne    101d8c <trap_dispatch+0x11b>
            print_trapframe(tf);
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	89 04 24             	mov    %eax,(%esp)
  101d67:	e8 98 fc ff ff       	call   101a04 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d6c:	c7 44 24 08 5a 3a 10 	movl   $0x103a5a,0x8(%esp)
  101d73:	00 
  101d74:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101d7b:	00 
  101d7c:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  101d83:	e8 29 ef ff ff       	call   100cb1 <__panic>
        break;
  101d88:	90                   	nop
  101d89:	eb 01                	jmp    101d8c <trap_dispatch+0x11b>
        break;
  101d8b:	90                   	nop
        }
    }
}
  101d8c:	90                   	nop
  101d8d:	89 ec                	mov    %ebp,%esp
  101d8f:	5d                   	pop    %ebp
  101d90:	c3                   	ret    

00101d91 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d91:	55                   	push   %ebp
  101d92:	89 e5                	mov    %esp,%ebp
  101d94:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d97:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9a:	89 04 24             	mov    %eax,(%esp)
  101d9d:	e8 cf fe ff ff       	call   101c71 <trap_dispatch>
}
  101da2:	90                   	nop
  101da3:	89 ec                	mov    %ebp,%esp
  101da5:	5d                   	pop    %ebp
  101da6:	c3                   	ret    

00101da7 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101da7:	1e                   	push   %ds
    pushl %es
  101da8:	06                   	push   %es
    pushl %fs
  101da9:	0f a0                	push   %fs
    pushl %gs
  101dab:	0f a8                	push   %gs
    pushal
  101dad:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dae:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101db3:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101db5:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101db7:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101db8:	e8 d4 ff ff ff       	call   101d91 <trap>

    # pop the pushed stack pointer
    popl %esp
  101dbd:	5c                   	pop    %esp

00101dbe <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101dbe:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dbf:	0f a9                	pop    %gs
    popl %fs
  101dc1:	0f a1                	pop    %fs
    popl %es
  101dc3:	07                   	pop    %es
    popl %ds
  101dc4:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dc5:	83 c4 08             	add    $0x8,%esp
    iret
  101dc8:	cf                   	iret   

00101dc9 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dc9:	6a 00                	push   $0x0
  pushl $0
  101dcb:	6a 00                	push   $0x0
  jmp __alltraps
  101dcd:	e9 d5 ff ff ff       	jmp    101da7 <__alltraps>

00101dd2 <vector1>:
.globl vector1
vector1:
  pushl $0
  101dd2:	6a 00                	push   $0x0
  pushl $1
  101dd4:	6a 01                	push   $0x1
  jmp __alltraps
  101dd6:	e9 cc ff ff ff       	jmp    101da7 <__alltraps>

00101ddb <vector2>:
.globl vector2
vector2:
  pushl $0
  101ddb:	6a 00                	push   $0x0
  pushl $2
  101ddd:	6a 02                	push   $0x2
  jmp __alltraps
  101ddf:	e9 c3 ff ff ff       	jmp    101da7 <__alltraps>

00101de4 <vector3>:
.globl vector3
vector3:
  pushl $0
  101de4:	6a 00                	push   $0x0
  pushl $3
  101de6:	6a 03                	push   $0x3
  jmp __alltraps
  101de8:	e9 ba ff ff ff       	jmp    101da7 <__alltraps>

00101ded <vector4>:
.globl vector4
vector4:
  pushl $0
  101ded:	6a 00                	push   $0x0
  pushl $4
  101def:	6a 04                	push   $0x4
  jmp __alltraps
  101df1:	e9 b1 ff ff ff       	jmp    101da7 <__alltraps>

00101df6 <vector5>:
.globl vector5
vector5:
  pushl $0
  101df6:	6a 00                	push   $0x0
  pushl $5
  101df8:	6a 05                	push   $0x5
  jmp __alltraps
  101dfa:	e9 a8 ff ff ff       	jmp    101da7 <__alltraps>

00101dff <vector6>:
.globl vector6
vector6:
  pushl $0
  101dff:	6a 00                	push   $0x0
  pushl $6
  101e01:	6a 06                	push   $0x6
  jmp __alltraps
  101e03:	e9 9f ff ff ff       	jmp    101da7 <__alltraps>

00101e08 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e08:	6a 00                	push   $0x0
  pushl $7
  101e0a:	6a 07                	push   $0x7
  jmp __alltraps
  101e0c:	e9 96 ff ff ff       	jmp    101da7 <__alltraps>

00101e11 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e11:	6a 08                	push   $0x8
  jmp __alltraps
  101e13:	e9 8f ff ff ff       	jmp    101da7 <__alltraps>

00101e18 <vector9>:
.globl vector9
vector9:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $9
  101e1a:	6a 09                	push   $0x9
  jmp __alltraps
  101e1c:	e9 86 ff ff ff       	jmp    101da7 <__alltraps>

00101e21 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e21:	6a 0a                	push   $0xa
  jmp __alltraps
  101e23:	e9 7f ff ff ff       	jmp    101da7 <__alltraps>

00101e28 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e28:	6a 0b                	push   $0xb
  jmp __alltraps
  101e2a:	e9 78 ff ff ff       	jmp    101da7 <__alltraps>

00101e2f <vector12>:
.globl vector12
vector12:
  pushl $12
  101e2f:	6a 0c                	push   $0xc
  jmp __alltraps
  101e31:	e9 71 ff ff ff       	jmp    101da7 <__alltraps>

00101e36 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e36:	6a 0d                	push   $0xd
  jmp __alltraps
  101e38:	e9 6a ff ff ff       	jmp    101da7 <__alltraps>

00101e3d <vector14>:
.globl vector14
vector14:
  pushl $14
  101e3d:	6a 0e                	push   $0xe
  jmp __alltraps
  101e3f:	e9 63 ff ff ff       	jmp    101da7 <__alltraps>

00101e44 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $15
  101e46:	6a 0f                	push   $0xf
  jmp __alltraps
  101e48:	e9 5a ff ff ff       	jmp    101da7 <__alltraps>

00101e4d <vector16>:
.globl vector16
vector16:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $16
  101e4f:	6a 10                	push   $0x10
  jmp __alltraps
  101e51:	e9 51 ff ff ff       	jmp    101da7 <__alltraps>

00101e56 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e56:	6a 11                	push   $0x11
  jmp __alltraps
  101e58:	e9 4a ff ff ff       	jmp    101da7 <__alltraps>

00101e5d <vector18>:
.globl vector18
vector18:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $18
  101e5f:	6a 12                	push   $0x12
  jmp __alltraps
  101e61:	e9 41 ff ff ff       	jmp    101da7 <__alltraps>

00101e66 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $19
  101e68:	6a 13                	push   $0x13
  jmp __alltraps
  101e6a:	e9 38 ff ff ff       	jmp    101da7 <__alltraps>

00101e6f <vector20>:
.globl vector20
vector20:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $20
  101e71:	6a 14                	push   $0x14
  jmp __alltraps
  101e73:	e9 2f ff ff ff       	jmp    101da7 <__alltraps>

00101e78 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $21
  101e7a:	6a 15                	push   $0x15
  jmp __alltraps
  101e7c:	e9 26 ff ff ff       	jmp    101da7 <__alltraps>

00101e81 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $22
  101e83:	6a 16                	push   $0x16
  jmp __alltraps
  101e85:	e9 1d ff ff ff       	jmp    101da7 <__alltraps>

00101e8a <vector23>:
.globl vector23
vector23:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $23
  101e8c:	6a 17                	push   $0x17
  jmp __alltraps
  101e8e:	e9 14 ff ff ff       	jmp    101da7 <__alltraps>

00101e93 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $24
  101e95:	6a 18                	push   $0x18
  jmp __alltraps
  101e97:	e9 0b ff ff ff       	jmp    101da7 <__alltraps>

00101e9c <vector25>:
.globl vector25
vector25:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $25
  101e9e:	6a 19                	push   $0x19
  jmp __alltraps
  101ea0:	e9 02 ff ff ff       	jmp    101da7 <__alltraps>

00101ea5 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $26
  101ea7:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ea9:	e9 f9 fe ff ff       	jmp    101da7 <__alltraps>

00101eae <vector27>:
.globl vector27
vector27:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $27
  101eb0:	6a 1b                	push   $0x1b
  jmp __alltraps
  101eb2:	e9 f0 fe ff ff       	jmp    101da7 <__alltraps>

00101eb7 <vector28>:
.globl vector28
vector28:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $28
  101eb9:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ebb:	e9 e7 fe ff ff       	jmp    101da7 <__alltraps>

00101ec0 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $29
  101ec2:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ec4:	e9 de fe ff ff       	jmp    101da7 <__alltraps>

00101ec9 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $30
  101ecb:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ecd:	e9 d5 fe ff ff       	jmp    101da7 <__alltraps>

00101ed2 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $31
  101ed4:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ed6:	e9 cc fe ff ff       	jmp    101da7 <__alltraps>

00101edb <vector32>:
.globl vector32
vector32:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $32
  101edd:	6a 20                	push   $0x20
  jmp __alltraps
  101edf:	e9 c3 fe ff ff       	jmp    101da7 <__alltraps>

00101ee4 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $33
  101ee6:	6a 21                	push   $0x21
  jmp __alltraps
  101ee8:	e9 ba fe ff ff       	jmp    101da7 <__alltraps>

00101eed <vector34>:
.globl vector34
vector34:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $34
  101eef:	6a 22                	push   $0x22
  jmp __alltraps
  101ef1:	e9 b1 fe ff ff       	jmp    101da7 <__alltraps>

00101ef6 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $35
  101ef8:	6a 23                	push   $0x23
  jmp __alltraps
  101efa:	e9 a8 fe ff ff       	jmp    101da7 <__alltraps>

00101eff <vector36>:
.globl vector36
vector36:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $36
  101f01:	6a 24                	push   $0x24
  jmp __alltraps
  101f03:	e9 9f fe ff ff       	jmp    101da7 <__alltraps>

00101f08 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $37
  101f0a:	6a 25                	push   $0x25
  jmp __alltraps
  101f0c:	e9 96 fe ff ff       	jmp    101da7 <__alltraps>

00101f11 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $38
  101f13:	6a 26                	push   $0x26
  jmp __alltraps
  101f15:	e9 8d fe ff ff       	jmp    101da7 <__alltraps>

00101f1a <vector39>:
.globl vector39
vector39:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $39
  101f1c:	6a 27                	push   $0x27
  jmp __alltraps
  101f1e:	e9 84 fe ff ff       	jmp    101da7 <__alltraps>

00101f23 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $40
  101f25:	6a 28                	push   $0x28
  jmp __alltraps
  101f27:	e9 7b fe ff ff       	jmp    101da7 <__alltraps>

00101f2c <vector41>:
.globl vector41
vector41:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $41
  101f2e:	6a 29                	push   $0x29
  jmp __alltraps
  101f30:	e9 72 fe ff ff       	jmp    101da7 <__alltraps>

00101f35 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $42
  101f37:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f39:	e9 69 fe ff ff       	jmp    101da7 <__alltraps>

00101f3e <vector43>:
.globl vector43
vector43:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $43
  101f40:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f42:	e9 60 fe ff ff       	jmp    101da7 <__alltraps>

00101f47 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $44
  101f49:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f4b:	e9 57 fe ff ff       	jmp    101da7 <__alltraps>

00101f50 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $45
  101f52:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f54:	e9 4e fe ff ff       	jmp    101da7 <__alltraps>

00101f59 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $46
  101f5b:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f5d:	e9 45 fe ff ff       	jmp    101da7 <__alltraps>

00101f62 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $47
  101f64:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f66:	e9 3c fe ff ff       	jmp    101da7 <__alltraps>

00101f6b <vector48>:
.globl vector48
vector48:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $48
  101f6d:	6a 30                	push   $0x30
  jmp __alltraps
  101f6f:	e9 33 fe ff ff       	jmp    101da7 <__alltraps>

00101f74 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $49
  101f76:	6a 31                	push   $0x31
  jmp __alltraps
  101f78:	e9 2a fe ff ff       	jmp    101da7 <__alltraps>

00101f7d <vector50>:
.globl vector50
vector50:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $50
  101f7f:	6a 32                	push   $0x32
  jmp __alltraps
  101f81:	e9 21 fe ff ff       	jmp    101da7 <__alltraps>

00101f86 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $51
  101f88:	6a 33                	push   $0x33
  jmp __alltraps
  101f8a:	e9 18 fe ff ff       	jmp    101da7 <__alltraps>

00101f8f <vector52>:
.globl vector52
vector52:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $52
  101f91:	6a 34                	push   $0x34
  jmp __alltraps
  101f93:	e9 0f fe ff ff       	jmp    101da7 <__alltraps>

00101f98 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $53
  101f9a:	6a 35                	push   $0x35
  jmp __alltraps
  101f9c:	e9 06 fe ff ff       	jmp    101da7 <__alltraps>

00101fa1 <vector54>:
.globl vector54
vector54:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $54
  101fa3:	6a 36                	push   $0x36
  jmp __alltraps
  101fa5:	e9 fd fd ff ff       	jmp    101da7 <__alltraps>

00101faa <vector55>:
.globl vector55
vector55:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $55
  101fac:	6a 37                	push   $0x37
  jmp __alltraps
  101fae:	e9 f4 fd ff ff       	jmp    101da7 <__alltraps>

00101fb3 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $56
  101fb5:	6a 38                	push   $0x38
  jmp __alltraps
  101fb7:	e9 eb fd ff ff       	jmp    101da7 <__alltraps>

00101fbc <vector57>:
.globl vector57
vector57:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $57
  101fbe:	6a 39                	push   $0x39
  jmp __alltraps
  101fc0:	e9 e2 fd ff ff       	jmp    101da7 <__alltraps>

00101fc5 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $58
  101fc7:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fc9:	e9 d9 fd ff ff       	jmp    101da7 <__alltraps>

00101fce <vector59>:
.globl vector59
vector59:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $59
  101fd0:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fd2:	e9 d0 fd ff ff       	jmp    101da7 <__alltraps>

00101fd7 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $60
  101fd9:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fdb:	e9 c7 fd ff ff       	jmp    101da7 <__alltraps>

00101fe0 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $61
  101fe2:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fe4:	e9 be fd ff ff       	jmp    101da7 <__alltraps>

00101fe9 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $62
  101feb:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fed:	e9 b5 fd ff ff       	jmp    101da7 <__alltraps>

00101ff2 <vector63>:
.globl vector63
vector63:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $63
  101ff4:	6a 3f                	push   $0x3f
  jmp __alltraps
  101ff6:	e9 ac fd ff ff       	jmp    101da7 <__alltraps>

00101ffb <vector64>:
.globl vector64
vector64:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $64
  101ffd:	6a 40                	push   $0x40
  jmp __alltraps
  101fff:	e9 a3 fd ff ff       	jmp    101da7 <__alltraps>

00102004 <vector65>:
.globl vector65
vector65:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $65
  102006:	6a 41                	push   $0x41
  jmp __alltraps
  102008:	e9 9a fd ff ff       	jmp    101da7 <__alltraps>

0010200d <vector66>:
.globl vector66
vector66:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $66
  10200f:	6a 42                	push   $0x42
  jmp __alltraps
  102011:	e9 91 fd ff ff       	jmp    101da7 <__alltraps>

00102016 <vector67>:
.globl vector67
vector67:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $67
  102018:	6a 43                	push   $0x43
  jmp __alltraps
  10201a:	e9 88 fd ff ff       	jmp    101da7 <__alltraps>

0010201f <vector68>:
.globl vector68
vector68:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $68
  102021:	6a 44                	push   $0x44
  jmp __alltraps
  102023:	e9 7f fd ff ff       	jmp    101da7 <__alltraps>

00102028 <vector69>:
.globl vector69
vector69:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $69
  10202a:	6a 45                	push   $0x45
  jmp __alltraps
  10202c:	e9 76 fd ff ff       	jmp    101da7 <__alltraps>

00102031 <vector70>:
.globl vector70
vector70:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $70
  102033:	6a 46                	push   $0x46
  jmp __alltraps
  102035:	e9 6d fd ff ff       	jmp    101da7 <__alltraps>

0010203a <vector71>:
.globl vector71
vector71:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $71
  10203c:	6a 47                	push   $0x47
  jmp __alltraps
  10203e:	e9 64 fd ff ff       	jmp    101da7 <__alltraps>

00102043 <vector72>:
.globl vector72
vector72:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $72
  102045:	6a 48                	push   $0x48
  jmp __alltraps
  102047:	e9 5b fd ff ff       	jmp    101da7 <__alltraps>

0010204c <vector73>:
.globl vector73
vector73:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $73
  10204e:	6a 49                	push   $0x49
  jmp __alltraps
  102050:	e9 52 fd ff ff       	jmp    101da7 <__alltraps>

00102055 <vector74>:
.globl vector74
vector74:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $74
  102057:	6a 4a                	push   $0x4a
  jmp __alltraps
  102059:	e9 49 fd ff ff       	jmp    101da7 <__alltraps>

0010205e <vector75>:
.globl vector75
vector75:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $75
  102060:	6a 4b                	push   $0x4b
  jmp __alltraps
  102062:	e9 40 fd ff ff       	jmp    101da7 <__alltraps>

00102067 <vector76>:
.globl vector76
vector76:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $76
  102069:	6a 4c                	push   $0x4c
  jmp __alltraps
  10206b:	e9 37 fd ff ff       	jmp    101da7 <__alltraps>

00102070 <vector77>:
.globl vector77
vector77:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $77
  102072:	6a 4d                	push   $0x4d
  jmp __alltraps
  102074:	e9 2e fd ff ff       	jmp    101da7 <__alltraps>

00102079 <vector78>:
.globl vector78
vector78:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $78
  10207b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10207d:	e9 25 fd ff ff       	jmp    101da7 <__alltraps>

00102082 <vector79>:
.globl vector79
vector79:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $79
  102084:	6a 4f                	push   $0x4f
  jmp __alltraps
  102086:	e9 1c fd ff ff       	jmp    101da7 <__alltraps>

0010208b <vector80>:
.globl vector80
vector80:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $80
  10208d:	6a 50                	push   $0x50
  jmp __alltraps
  10208f:	e9 13 fd ff ff       	jmp    101da7 <__alltraps>

00102094 <vector81>:
.globl vector81
vector81:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $81
  102096:	6a 51                	push   $0x51
  jmp __alltraps
  102098:	e9 0a fd ff ff       	jmp    101da7 <__alltraps>

0010209d <vector82>:
.globl vector82
vector82:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $82
  10209f:	6a 52                	push   $0x52
  jmp __alltraps
  1020a1:	e9 01 fd ff ff       	jmp    101da7 <__alltraps>

001020a6 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $83
  1020a8:	6a 53                	push   $0x53
  jmp __alltraps
  1020aa:	e9 f8 fc ff ff       	jmp    101da7 <__alltraps>

001020af <vector84>:
.globl vector84
vector84:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $84
  1020b1:	6a 54                	push   $0x54
  jmp __alltraps
  1020b3:	e9 ef fc ff ff       	jmp    101da7 <__alltraps>

001020b8 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $85
  1020ba:	6a 55                	push   $0x55
  jmp __alltraps
  1020bc:	e9 e6 fc ff ff       	jmp    101da7 <__alltraps>

001020c1 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $86
  1020c3:	6a 56                	push   $0x56
  jmp __alltraps
  1020c5:	e9 dd fc ff ff       	jmp    101da7 <__alltraps>

001020ca <vector87>:
.globl vector87
vector87:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $87
  1020cc:	6a 57                	push   $0x57
  jmp __alltraps
  1020ce:	e9 d4 fc ff ff       	jmp    101da7 <__alltraps>

001020d3 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $88
  1020d5:	6a 58                	push   $0x58
  jmp __alltraps
  1020d7:	e9 cb fc ff ff       	jmp    101da7 <__alltraps>

001020dc <vector89>:
.globl vector89
vector89:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $89
  1020de:	6a 59                	push   $0x59
  jmp __alltraps
  1020e0:	e9 c2 fc ff ff       	jmp    101da7 <__alltraps>

001020e5 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $90
  1020e7:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020e9:	e9 b9 fc ff ff       	jmp    101da7 <__alltraps>

001020ee <vector91>:
.globl vector91
vector91:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $91
  1020f0:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020f2:	e9 b0 fc ff ff       	jmp    101da7 <__alltraps>

001020f7 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $92
  1020f9:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020fb:	e9 a7 fc ff ff       	jmp    101da7 <__alltraps>

00102100 <vector93>:
.globl vector93
vector93:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $93
  102102:	6a 5d                	push   $0x5d
  jmp __alltraps
  102104:	e9 9e fc ff ff       	jmp    101da7 <__alltraps>

00102109 <vector94>:
.globl vector94
vector94:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $94
  10210b:	6a 5e                	push   $0x5e
  jmp __alltraps
  10210d:	e9 95 fc ff ff       	jmp    101da7 <__alltraps>

00102112 <vector95>:
.globl vector95
vector95:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $95
  102114:	6a 5f                	push   $0x5f
  jmp __alltraps
  102116:	e9 8c fc ff ff       	jmp    101da7 <__alltraps>

0010211b <vector96>:
.globl vector96
vector96:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $96
  10211d:	6a 60                	push   $0x60
  jmp __alltraps
  10211f:	e9 83 fc ff ff       	jmp    101da7 <__alltraps>

00102124 <vector97>:
.globl vector97
vector97:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $97
  102126:	6a 61                	push   $0x61
  jmp __alltraps
  102128:	e9 7a fc ff ff       	jmp    101da7 <__alltraps>

0010212d <vector98>:
.globl vector98
vector98:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $98
  10212f:	6a 62                	push   $0x62
  jmp __alltraps
  102131:	e9 71 fc ff ff       	jmp    101da7 <__alltraps>

00102136 <vector99>:
.globl vector99
vector99:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $99
  102138:	6a 63                	push   $0x63
  jmp __alltraps
  10213a:	e9 68 fc ff ff       	jmp    101da7 <__alltraps>

0010213f <vector100>:
.globl vector100
vector100:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $100
  102141:	6a 64                	push   $0x64
  jmp __alltraps
  102143:	e9 5f fc ff ff       	jmp    101da7 <__alltraps>

00102148 <vector101>:
.globl vector101
vector101:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $101
  10214a:	6a 65                	push   $0x65
  jmp __alltraps
  10214c:	e9 56 fc ff ff       	jmp    101da7 <__alltraps>

00102151 <vector102>:
.globl vector102
vector102:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $102
  102153:	6a 66                	push   $0x66
  jmp __alltraps
  102155:	e9 4d fc ff ff       	jmp    101da7 <__alltraps>

0010215a <vector103>:
.globl vector103
vector103:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $103
  10215c:	6a 67                	push   $0x67
  jmp __alltraps
  10215e:	e9 44 fc ff ff       	jmp    101da7 <__alltraps>

00102163 <vector104>:
.globl vector104
vector104:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $104
  102165:	6a 68                	push   $0x68
  jmp __alltraps
  102167:	e9 3b fc ff ff       	jmp    101da7 <__alltraps>

0010216c <vector105>:
.globl vector105
vector105:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $105
  10216e:	6a 69                	push   $0x69
  jmp __alltraps
  102170:	e9 32 fc ff ff       	jmp    101da7 <__alltraps>

00102175 <vector106>:
.globl vector106
vector106:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $106
  102177:	6a 6a                	push   $0x6a
  jmp __alltraps
  102179:	e9 29 fc ff ff       	jmp    101da7 <__alltraps>

0010217e <vector107>:
.globl vector107
vector107:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $107
  102180:	6a 6b                	push   $0x6b
  jmp __alltraps
  102182:	e9 20 fc ff ff       	jmp    101da7 <__alltraps>

00102187 <vector108>:
.globl vector108
vector108:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $108
  102189:	6a 6c                	push   $0x6c
  jmp __alltraps
  10218b:	e9 17 fc ff ff       	jmp    101da7 <__alltraps>

00102190 <vector109>:
.globl vector109
vector109:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $109
  102192:	6a 6d                	push   $0x6d
  jmp __alltraps
  102194:	e9 0e fc ff ff       	jmp    101da7 <__alltraps>

00102199 <vector110>:
.globl vector110
vector110:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $110
  10219b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10219d:	e9 05 fc ff ff       	jmp    101da7 <__alltraps>

001021a2 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $111
  1021a4:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021a6:	e9 fc fb ff ff       	jmp    101da7 <__alltraps>

001021ab <vector112>:
.globl vector112
vector112:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $112
  1021ad:	6a 70                	push   $0x70
  jmp __alltraps
  1021af:	e9 f3 fb ff ff       	jmp    101da7 <__alltraps>

001021b4 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $113
  1021b6:	6a 71                	push   $0x71
  jmp __alltraps
  1021b8:	e9 ea fb ff ff       	jmp    101da7 <__alltraps>

001021bd <vector114>:
.globl vector114
vector114:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $114
  1021bf:	6a 72                	push   $0x72
  jmp __alltraps
  1021c1:	e9 e1 fb ff ff       	jmp    101da7 <__alltraps>

001021c6 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $115
  1021c8:	6a 73                	push   $0x73
  jmp __alltraps
  1021ca:	e9 d8 fb ff ff       	jmp    101da7 <__alltraps>

001021cf <vector116>:
.globl vector116
vector116:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $116
  1021d1:	6a 74                	push   $0x74
  jmp __alltraps
  1021d3:	e9 cf fb ff ff       	jmp    101da7 <__alltraps>

001021d8 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $117
  1021da:	6a 75                	push   $0x75
  jmp __alltraps
  1021dc:	e9 c6 fb ff ff       	jmp    101da7 <__alltraps>

001021e1 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $118
  1021e3:	6a 76                	push   $0x76
  jmp __alltraps
  1021e5:	e9 bd fb ff ff       	jmp    101da7 <__alltraps>

001021ea <vector119>:
.globl vector119
vector119:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $119
  1021ec:	6a 77                	push   $0x77
  jmp __alltraps
  1021ee:	e9 b4 fb ff ff       	jmp    101da7 <__alltraps>

001021f3 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $120
  1021f5:	6a 78                	push   $0x78
  jmp __alltraps
  1021f7:	e9 ab fb ff ff       	jmp    101da7 <__alltraps>

001021fc <vector121>:
.globl vector121
vector121:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $121
  1021fe:	6a 79                	push   $0x79
  jmp __alltraps
  102200:	e9 a2 fb ff ff       	jmp    101da7 <__alltraps>

00102205 <vector122>:
.globl vector122
vector122:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $122
  102207:	6a 7a                	push   $0x7a
  jmp __alltraps
  102209:	e9 99 fb ff ff       	jmp    101da7 <__alltraps>

0010220e <vector123>:
.globl vector123
vector123:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $123
  102210:	6a 7b                	push   $0x7b
  jmp __alltraps
  102212:	e9 90 fb ff ff       	jmp    101da7 <__alltraps>

00102217 <vector124>:
.globl vector124
vector124:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $124
  102219:	6a 7c                	push   $0x7c
  jmp __alltraps
  10221b:	e9 87 fb ff ff       	jmp    101da7 <__alltraps>

00102220 <vector125>:
.globl vector125
vector125:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $125
  102222:	6a 7d                	push   $0x7d
  jmp __alltraps
  102224:	e9 7e fb ff ff       	jmp    101da7 <__alltraps>

00102229 <vector126>:
.globl vector126
vector126:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $126
  10222b:	6a 7e                	push   $0x7e
  jmp __alltraps
  10222d:	e9 75 fb ff ff       	jmp    101da7 <__alltraps>

00102232 <vector127>:
.globl vector127
vector127:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $127
  102234:	6a 7f                	push   $0x7f
  jmp __alltraps
  102236:	e9 6c fb ff ff       	jmp    101da7 <__alltraps>

0010223b <vector128>:
.globl vector128
vector128:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $128
  10223d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102242:	e9 60 fb ff ff       	jmp    101da7 <__alltraps>

00102247 <vector129>:
.globl vector129
vector129:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $129
  102249:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10224e:	e9 54 fb ff ff       	jmp    101da7 <__alltraps>

00102253 <vector130>:
.globl vector130
vector130:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $130
  102255:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10225a:	e9 48 fb ff ff       	jmp    101da7 <__alltraps>

0010225f <vector131>:
.globl vector131
vector131:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $131
  102261:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102266:	e9 3c fb ff ff       	jmp    101da7 <__alltraps>

0010226b <vector132>:
.globl vector132
vector132:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $132
  10226d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102272:	e9 30 fb ff ff       	jmp    101da7 <__alltraps>

00102277 <vector133>:
.globl vector133
vector133:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $133
  102279:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10227e:	e9 24 fb ff ff       	jmp    101da7 <__alltraps>

00102283 <vector134>:
.globl vector134
vector134:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $134
  102285:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10228a:	e9 18 fb ff ff       	jmp    101da7 <__alltraps>

0010228f <vector135>:
.globl vector135
vector135:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $135
  102291:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102296:	e9 0c fb ff ff       	jmp    101da7 <__alltraps>

0010229b <vector136>:
.globl vector136
vector136:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $136
  10229d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022a2:	e9 00 fb ff ff       	jmp    101da7 <__alltraps>

001022a7 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $137
  1022a9:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022ae:	e9 f4 fa ff ff       	jmp    101da7 <__alltraps>

001022b3 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $138
  1022b5:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022ba:	e9 e8 fa ff ff       	jmp    101da7 <__alltraps>

001022bf <vector139>:
.globl vector139
vector139:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $139
  1022c1:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022c6:	e9 dc fa ff ff       	jmp    101da7 <__alltraps>

001022cb <vector140>:
.globl vector140
vector140:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $140
  1022cd:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022d2:	e9 d0 fa ff ff       	jmp    101da7 <__alltraps>

001022d7 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $141
  1022d9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022de:	e9 c4 fa ff ff       	jmp    101da7 <__alltraps>

001022e3 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $142
  1022e5:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022ea:	e9 b8 fa ff ff       	jmp    101da7 <__alltraps>

001022ef <vector143>:
.globl vector143
vector143:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $143
  1022f1:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022f6:	e9 ac fa ff ff       	jmp    101da7 <__alltraps>

001022fb <vector144>:
.globl vector144
vector144:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $144
  1022fd:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102302:	e9 a0 fa ff ff       	jmp    101da7 <__alltraps>

00102307 <vector145>:
.globl vector145
vector145:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $145
  102309:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10230e:	e9 94 fa ff ff       	jmp    101da7 <__alltraps>

00102313 <vector146>:
.globl vector146
vector146:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $146
  102315:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10231a:	e9 88 fa ff ff       	jmp    101da7 <__alltraps>

0010231f <vector147>:
.globl vector147
vector147:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $147
  102321:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102326:	e9 7c fa ff ff       	jmp    101da7 <__alltraps>

0010232b <vector148>:
.globl vector148
vector148:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $148
  10232d:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102332:	e9 70 fa ff ff       	jmp    101da7 <__alltraps>

00102337 <vector149>:
.globl vector149
vector149:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $149
  102339:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10233e:	e9 64 fa ff ff       	jmp    101da7 <__alltraps>

00102343 <vector150>:
.globl vector150
vector150:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $150
  102345:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10234a:	e9 58 fa ff ff       	jmp    101da7 <__alltraps>

0010234f <vector151>:
.globl vector151
vector151:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $151
  102351:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102356:	e9 4c fa ff ff       	jmp    101da7 <__alltraps>

0010235b <vector152>:
.globl vector152
vector152:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $152
  10235d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102362:	e9 40 fa ff ff       	jmp    101da7 <__alltraps>

00102367 <vector153>:
.globl vector153
vector153:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $153
  102369:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10236e:	e9 34 fa ff ff       	jmp    101da7 <__alltraps>

00102373 <vector154>:
.globl vector154
vector154:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $154
  102375:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10237a:	e9 28 fa ff ff       	jmp    101da7 <__alltraps>

0010237f <vector155>:
.globl vector155
vector155:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $155
  102381:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102386:	e9 1c fa ff ff       	jmp    101da7 <__alltraps>

0010238b <vector156>:
.globl vector156
vector156:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $156
  10238d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102392:	e9 10 fa ff ff       	jmp    101da7 <__alltraps>

00102397 <vector157>:
.globl vector157
vector157:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $157
  102399:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10239e:	e9 04 fa ff ff       	jmp    101da7 <__alltraps>

001023a3 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $158
  1023a5:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023aa:	e9 f8 f9 ff ff       	jmp    101da7 <__alltraps>

001023af <vector159>:
.globl vector159
vector159:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $159
  1023b1:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023b6:	e9 ec f9 ff ff       	jmp    101da7 <__alltraps>

001023bb <vector160>:
.globl vector160
vector160:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $160
  1023bd:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023c2:	e9 e0 f9 ff ff       	jmp    101da7 <__alltraps>

001023c7 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $161
  1023c9:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023ce:	e9 d4 f9 ff ff       	jmp    101da7 <__alltraps>

001023d3 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $162
  1023d5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023da:	e9 c8 f9 ff ff       	jmp    101da7 <__alltraps>

001023df <vector163>:
.globl vector163
vector163:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $163
  1023e1:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023e6:	e9 bc f9 ff ff       	jmp    101da7 <__alltraps>

001023eb <vector164>:
.globl vector164
vector164:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $164
  1023ed:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023f2:	e9 b0 f9 ff ff       	jmp    101da7 <__alltraps>

001023f7 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $165
  1023f9:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023fe:	e9 a4 f9 ff ff       	jmp    101da7 <__alltraps>

00102403 <vector166>:
.globl vector166
vector166:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $166
  102405:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10240a:	e9 98 f9 ff ff       	jmp    101da7 <__alltraps>

0010240f <vector167>:
.globl vector167
vector167:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $167
  102411:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102416:	e9 8c f9 ff ff       	jmp    101da7 <__alltraps>

0010241b <vector168>:
.globl vector168
vector168:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $168
  10241d:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102422:	e9 80 f9 ff ff       	jmp    101da7 <__alltraps>

00102427 <vector169>:
.globl vector169
vector169:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $169
  102429:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10242e:	e9 74 f9 ff ff       	jmp    101da7 <__alltraps>

00102433 <vector170>:
.globl vector170
vector170:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $170
  102435:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10243a:	e9 68 f9 ff ff       	jmp    101da7 <__alltraps>

0010243f <vector171>:
.globl vector171
vector171:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $171
  102441:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102446:	e9 5c f9 ff ff       	jmp    101da7 <__alltraps>

0010244b <vector172>:
.globl vector172
vector172:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $172
  10244d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102452:	e9 50 f9 ff ff       	jmp    101da7 <__alltraps>

00102457 <vector173>:
.globl vector173
vector173:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $173
  102459:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10245e:	e9 44 f9 ff ff       	jmp    101da7 <__alltraps>

00102463 <vector174>:
.globl vector174
vector174:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $174
  102465:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10246a:	e9 38 f9 ff ff       	jmp    101da7 <__alltraps>

0010246f <vector175>:
.globl vector175
vector175:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $175
  102471:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102476:	e9 2c f9 ff ff       	jmp    101da7 <__alltraps>

0010247b <vector176>:
.globl vector176
vector176:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $176
  10247d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102482:	e9 20 f9 ff ff       	jmp    101da7 <__alltraps>

00102487 <vector177>:
.globl vector177
vector177:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $177
  102489:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10248e:	e9 14 f9 ff ff       	jmp    101da7 <__alltraps>

00102493 <vector178>:
.globl vector178
vector178:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $178
  102495:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10249a:	e9 08 f9 ff ff       	jmp    101da7 <__alltraps>

0010249f <vector179>:
.globl vector179
vector179:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $179
  1024a1:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024a6:	e9 fc f8 ff ff       	jmp    101da7 <__alltraps>

001024ab <vector180>:
.globl vector180
vector180:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $180
  1024ad:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024b2:	e9 f0 f8 ff ff       	jmp    101da7 <__alltraps>

001024b7 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $181
  1024b9:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024be:	e9 e4 f8 ff ff       	jmp    101da7 <__alltraps>

001024c3 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $182
  1024c5:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024ca:	e9 d8 f8 ff ff       	jmp    101da7 <__alltraps>

001024cf <vector183>:
.globl vector183
vector183:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $183
  1024d1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024d6:	e9 cc f8 ff ff       	jmp    101da7 <__alltraps>

001024db <vector184>:
.globl vector184
vector184:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $184
  1024dd:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024e2:	e9 c0 f8 ff ff       	jmp    101da7 <__alltraps>

001024e7 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $185
  1024e9:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024ee:	e9 b4 f8 ff ff       	jmp    101da7 <__alltraps>

001024f3 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $186
  1024f5:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024fa:	e9 a8 f8 ff ff       	jmp    101da7 <__alltraps>

001024ff <vector187>:
.globl vector187
vector187:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $187
  102501:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102506:	e9 9c f8 ff ff       	jmp    101da7 <__alltraps>

0010250b <vector188>:
.globl vector188
vector188:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $188
  10250d:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102512:	e9 90 f8 ff ff       	jmp    101da7 <__alltraps>

00102517 <vector189>:
.globl vector189
vector189:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $189
  102519:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10251e:	e9 84 f8 ff ff       	jmp    101da7 <__alltraps>

00102523 <vector190>:
.globl vector190
vector190:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $190
  102525:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10252a:	e9 78 f8 ff ff       	jmp    101da7 <__alltraps>

0010252f <vector191>:
.globl vector191
vector191:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $191
  102531:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102536:	e9 6c f8 ff ff       	jmp    101da7 <__alltraps>

0010253b <vector192>:
.globl vector192
vector192:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $192
  10253d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102542:	e9 60 f8 ff ff       	jmp    101da7 <__alltraps>

00102547 <vector193>:
.globl vector193
vector193:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $193
  102549:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10254e:	e9 54 f8 ff ff       	jmp    101da7 <__alltraps>

00102553 <vector194>:
.globl vector194
vector194:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $194
  102555:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10255a:	e9 48 f8 ff ff       	jmp    101da7 <__alltraps>

0010255f <vector195>:
.globl vector195
vector195:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $195
  102561:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102566:	e9 3c f8 ff ff       	jmp    101da7 <__alltraps>

0010256b <vector196>:
.globl vector196
vector196:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $196
  10256d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102572:	e9 30 f8 ff ff       	jmp    101da7 <__alltraps>

00102577 <vector197>:
.globl vector197
vector197:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $197
  102579:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10257e:	e9 24 f8 ff ff       	jmp    101da7 <__alltraps>

00102583 <vector198>:
.globl vector198
vector198:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $198
  102585:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10258a:	e9 18 f8 ff ff       	jmp    101da7 <__alltraps>

0010258f <vector199>:
.globl vector199
vector199:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $199
  102591:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102596:	e9 0c f8 ff ff       	jmp    101da7 <__alltraps>

0010259b <vector200>:
.globl vector200
vector200:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $200
  10259d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025a2:	e9 00 f8 ff ff       	jmp    101da7 <__alltraps>

001025a7 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $201
  1025a9:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025ae:	e9 f4 f7 ff ff       	jmp    101da7 <__alltraps>

001025b3 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $202
  1025b5:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025ba:	e9 e8 f7 ff ff       	jmp    101da7 <__alltraps>

001025bf <vector203>:
.globl vector203
vector203:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $203
  1025c1:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025c6:	e9 dc f7 ff ff       	jmp    101da7 <__alltraps>

001025cb <vector204>:
.globl vector204
vector204:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $204
  1025cd:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025d2:	e9 d0 f7 ff ff       	jmp    101da7 <__alltraps>

001025d7 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $205
  1025d9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025de:	e9 c4 f7 ff ff       	jmp    101da7 <__alltraps>

001025e3 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $206
  1025e5:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025ea:	e9 b8 f7 ff ff       	jmp    101da7 <__alltraps>

001025ef <vector207>:
.globl vector207
vector207:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $207
  1025f1:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025f6:	e9 ac f7 ff ff       	jmp    101da7 <__alltraps>

001025fb <vector208>:
.globl vector208
vector208:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $208
  1025fd:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102602:	e9 a0 f7 ff ff       	jmp    101da7 <__alltraps>

00102607 <vector209>:
.globl vector209
vector209:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $209
  102609:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10260e:	e9 94 f7 ff ff       	jmp    101da7 <__alltraps>

00102613 <vector210>:
.globl vector210
vector210:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $210
  102615:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10261a:	e9 88 f7 ff ff       	jmp    101da7 <__alltraps>

0010261f <vector211>:
.globl vector211
vector211:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $211
  102621:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102626:	e9 7c f7 ff ff       	jmp    101da7 <__alltraps>

0010262b <vector212>:
.globl vector212
vector212:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $212
  10262d:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102632:	e9 70 f7 ff ff       	jmp    101da7 <__alltraps>

00102637 <vector213>:
.globl vector213
vector213:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $213
  102639:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10263e:	e9 64 f7 ff ff       	jmp    101da7 <__alltraps>

00102643 <vector214>:
.globl vector214
vector214:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $214
  102645:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10264a:	e9 58 f7 ff ff       	jmp    101da7 <__alltraps>

0010264f <vector215>:
.globl vector215
vector215:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $215
  102651:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102656:	e9 4c f7 ff ff       	jmp    101da7 <__alltraps>

0010265b <vector216>:
.globl vector216
vector216:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $216
  10265d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102662:	e9 40 f7 ff ff       	jmp    101da7 <__alltraps>

00102667 <vector217>:
.globl vector217
vector217:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $217
  102669:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10266e:	e9 34 f7 ff ff       	jmp    101da7 <__alltraps>

00102673 <vector218>:
.globl vector218
vector218:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $218
  102675:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10267a:	e9 28 f7 ff ff       	jmp    101da7 <__alltraps>

0010267f <vector219>:
.globl vector219
vector219:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $219
  102681:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102686:	e9 1c f7 ff ff       	jmp    101da7 <__alltraps>

0010268b <vector220>:
.globl vector220
vector220:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $220
  10268d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102692:	e9 10 f7 ff ff       	jmp    101da7 <__alltraps>

00102697 <vector221>:
.globl vector221
vector221:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $221
  102699:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10269e:	e9 04 f7 ff ff       	jmp    101da7 <__alltraps>

001026a3 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $222
  1026a5:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026aa:	e9 f8 f6 ff ff       	jmp    101da7 <__alltraps>

001026af <vector223>:
.globl vector223
vector223:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $223
  1026b1:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026b6:	e9 ec f6 ff ff       	jmp    101da7 <__alltraps>

001026bb <vector224>:
.globl vector224
vector224:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $224
  1026bd:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026c2:	e9 e0 f6 ff ff       	jmp    101da7 <__alltraps>

001026c7 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $225
  1026c9:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026ce:	e9 d4 f6 ff ff       	jmp    101da7 <__alltraps>

001026d3 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $226
  1026d5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026da:	e9 c8 f6 ff ff       	jmp    101da7 <__alltraps>

001026df <vector227>:
.globl vector227
vector227:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $227
  1026e1:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026e6:	e9 bc f6 ff ff       	jmp    101da7 <__alltraps>

001026eb <vector228>:
.globl vector228
vector228:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $228
  1026ed:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026f2:	e9 b0 f6 ff ff       	jmp    101da7 <__alltraps>

001026f7 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $229
  1026f9:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026fe:	e9 a4 f6 ff ff       	jmp    101da7 <__alltraps>

00102703 <vector230>:
.globl vector230
vector230:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $230
  102705:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10270a:	e9 98 f6 ff ff       	jmp    101da7 <__alltraps>

0010270f <vector231>:
.globl vector231
vector231:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $231
  102711:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102716:	e9 8c f6 ff ff       	jmp    101da7 <__alltraps>

0010271b <vector232>:
.globl vector232
vector232:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $232
  10271d:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102722:	e9 80 f6 ff ff       	jmp    101da7 <__alltraps>

00102727 <vector233>:
.globl vector233
vector233:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $233
  102729:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10272e:	e9 74 f6 ff ff       	jmp    101da7 <__alltraps>

00102733 <vector234>:
.globl vector234
vector234:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $234
  102735:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10273a:	e9 68 f6 ff ff       	jmp    101da7 <__alltraps>

0010273f <vector235>:
.globl vector235
vector235:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $235
  102741:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102746:	e9 5c f6 ff ff       	jmp    101da7 <__alltraps>

0010274b <vector236>:
.globl vector236
vector236:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $236
  10274d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102752:	e9 50 f6 ff ff       	jmp    101da7 <__alltraps>

00102757 <vector237>:
.globl vector237
vector237:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $237
  102759:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10275e:	e9 44 f6 ff ff       	jmp    101da7 <__alltraps>

00102763 <vector238>:
.globl vector238
vector238:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $238
  102765:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10276a:	e9 38 f6 ff ff       	jmp    101da7 <__alltraps>

0010276f <vector239>:
.globl vector239
vector239:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $239
  102771:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102776:	e9 2c f6 ff ff       	jmp    101da7 <__alltraps>

0010277b <vector240>:
.globl vector240
vector240:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $240
  10277d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102782:	e9 20 f6 ff ff       	jmp    101da7 <__alltraps>

00102787 <vector241>:
.globl vector241
vector241:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $241
  102789:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10278e:	e9 14 f6 ff ff       	jmp    101da7 <__alltraps>

00102793 <vector242>:
.globl vector242
vector242:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $242
  102795:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10279a:	e9 08 f6 ff ff       	jmp    101da7 <__alltraps>

0010279f <vector243>:
.globl vector243
vector243:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $243
  1027a1:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027a6:	e9 fc f5 ff ff       	jmp    101da7 <__alltraps>

001027ab <vector244>:
.globl vector244
vector244:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $244
  1027ad:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027b2:	e9 f0 f5 ff ff       	jmp    101da7 <__alltraps>

001027b7 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $245
  1027b9:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027be:	e9 e4 f5 ff ff       	jmp    101da7 <__alltraps>

001027c3 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $246
  1027c5:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027ca:	e9 d8 f5 ff ff       	jmp    101da7 <__alltraps>

001027cf <vector247>:
.globl vector247
vector247:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $247
  1027d1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027d6:	e9 cc f5 ff ff       	jmp    101da7 <__alltraps>

001027db <vector248>:
.globl vector248
vector248:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $248
  1027dd:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027e2:	e9 c0 f5 ff ff       	jmp    101da7 <__alltraps>

001027e7 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $249
  1027e9:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027ee:	e9 b4 f5 ff ff       	jmp    101da7 <__alltraps>

001027f3 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $250
  1027f5:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027fa:	e9 a8 f5 ff ff       	jmp    101da7 <__alltraps>

001027ff <vector251>:
.globl vector251
vector251:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $251
  102801:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102806:	e9 9c f5 ff ff       	jmp    101da7 <__alltraps>

0010280b <vector252>:
.globl vector252
vector252:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $252
  10280d:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102812:	e9 90 f5 ff ff       	jmp    101da7 <__alltraps>

00102817 <vector253>:
.globl vector253
vector253:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $253
  102819:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10281e:	e9 84 f5 ff ff       	jmp    101da7 <__alltraps>

00102823 <vector254>:
.globl vector254
vector254:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $254
  102825:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10282a:	e9 78 f5 ff ff       	jmp    101da7 <__alltraps>

0010282f <vector255>:
.globl vector255
vector255:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $255
  102831:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102836:	e9 6c f5 ff ff       	jmp    101da7 <__alltraps>

0010283b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10283b:	55                   	push   %ebp
  10283c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10283e:	8b 45 08             	mov    0x8(%ebp),%eax
  102841:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102844:	b8 23 00 00 00       	mov    $0x23,%eax
  102849:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10284b:	b8 23 00 00 00       	mov    $0x23,%eax
  102850:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102852:	b8 10 00 00 00       	mov    $0x10,%eax
  102857:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102859:	b8 10 00 00 00       	mov    $0x10,%eax
  10285e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102860:	b8 10 00 00 00       	mov    $0x10,%eax
  102865:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102867:	ea 6e 28 10 00 08 00 	ljmp   $0x8,$0x10286e
}
  10286e:	90                   	nop
  10286f:	5d                   	pop    %ebp
  102870:	c3                   	ret    

00102871 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102871:	55                   	push   %ebp
  102872:	89 e5                	mov    %esp,%ebp
  102874:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102877:	b8 a0 08 11 00       	mov    $0x1108a0,%eax
  10287c:	05 00 04 00 00       	add    $0x400,%eax
  102881:	a3 a4 0c 11 00       	mov    %eax,0x110ca4
    ts.ts_ss0 = KERNEL_DS;
  102886:	66 c7 05 a8 0c 11 00 	movw   $0x10,0x110ca8
  10288d:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10288f:	66 c7 05 08 fa 10 00 	movw   $0x68,0x10fa08
  102896:	68 00 
  102898:	b8 a0 0c 11 00       	mov    $0x110ca0,%eax
  10289d:	0f b7 c0             	movzwl %ax,%eax
  1028a0:	66 a3 0a fa 10 00    	mov    %ax,0x10fa0a
  1028a6:	b8 a0 0c 11 00       	mov    $0x110ca0,%eax
  1028ab:	c1 e8 10             	shr    $0x10,%eax
  1028ae:	a2 0c fa 10 00       	mov    %al,0x10fa0c
  1028b3:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028ba:	24 f0                	and    $0xf0,%al
  1028bc:	0c 09                	or     $0x9,%al
  1028be:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028c3:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028ca:	0c 10                	or     $0x10,%al
  1028cc:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028d1:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028d8:	24 9f                	and    $0x9f,%al
  1028da:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028df:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  1028e6:	0c 80                	or     $0x80,%al
  1028e8:	a2 0d fa 10 00       	mov    %al,0x10fa0d
  1028ed:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  1028f4:	24 f0                	and    $0xf0,%al
  1028f6:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  1028fb:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102902:	24 ef                	and    $0xef,%al
  102904:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102909:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  102910:	24 df                	and    $0xdf,%al
  102912:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102917:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10291e:	0c 40                	or     $0x40,%al
  102920:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102925:	0f b6 05 0e fa 10 00 	movzbl 0x10fa0e,%eax
  10292c:	24 7f                	and    $0x7f,%al
  10292e:	a2 0e fa 10 00       	mov    %al,0x10fa0e
  102933:	b8 a0 0c 11 00       	mov    $0x110ca0,%eax
  102938:	c1 e8 18             	shr    $0x18,%eax
  10293b:	a2 0f fa 10 00       	mov    %al,0x10fa0f
    gdt[SEG_TSS].sd_s = 0;
  102940:	0f b6 05 0d fa 10 00 	movzbl 0x10fa0d,%eax
  102947:	24 ef                	and    $0xef,%al
  102949:	a2 0d fa 10 00       	mov    %al,0x10fa0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10294e:	c7 04 24 10 fa 10 00 	movl   $0x10fa10,(%esp)
  102955:	e8 e1 fe ff ff       	call   10283b <lgdt>
  10295a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102960:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102964:	0f 00 d8             	ltr    %ax
}
  102967:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102968:	90                   	nop
  102969:	89 ec                	mov    %ebp,%esp
  10296b:	5d                   	pop    %ebp
  10296c:	c3                   	ret    

0010296d <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10296d:	55                   	push   %ebp
  10296e:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102970:	e8 fc fe ff ff       	call   102871 <gdt_init>
}
  102975:	90                   	nop
  102976:	5d                   	pop    %ebp
  102977:	c3                   	ret    

00102978 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102978:	55                   	push   %ebp
  102979:	89 e5                	mov    %esp,%ebp
  10297b:	83 ec 58             	sub    $0x58,%esp
  10297e:	8b 45 10             	mov    0x10(%ebp),%eax
  102981:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102984:	8b 45 14             	mov    0x14(%ebp),%eax
  102987:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10298a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10298d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102990:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102993:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102996:	8b 45 18             	mov    0x18(%ebp),%eax
  102999:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10299c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10299f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1029b2:	74 1c                	je     1029d0 <printnum+0x58>
  1029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b7:	ba 00 00 00 00       	mov    $0x0,%edx
  1029bc:	f7 75 e4             	divl   -0x1c(%ebp)
  1029bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1029c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029c5:	ba 00 00 00 00       	mov    $0x0,%edx
  1029ca:	f7 75 e4             	divl   -0x1c(%ebp)
  1029cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029d6:	f7 75 e4             	divl   -0x1c(%ebp)
  1029d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029e8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029ee:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029f1:	8b 45 18             	mov    0x18(%ebp),%eax
  1029f4:	ba 00 00 00 00       	mov    $0x0,%edx
  1029f9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1029fc:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  1029ff:	19 d1                	sbb    %edx,%ecx
  102a01:	72 4c                	jb     102a4f <printnum+0xd7>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a03:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a06:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a09:	8b 45 20             	mov    0x20(%ebp),%eax
  102a0c:	89 44 24 18          	mov    %eax,0x18(%esp)
  102a10:	89 54 24 14          	mov    %edx,0x14(%esp)
  102a14:	8b 45 18             	mov    0x18(%ebp),%eax
  102a17:	89 44 24 10          	mov    %eax,0x10(%esp)
  102a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a21:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a25:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a30:	8b 45 08             	mov    0x8(%ebp),%eax
  102a33:	89 04 24             	mov    %eax,(%esp)
  102a36:	e8 3d ff ff ff       	call   102978 <printnum>
  102a3b:	eb 1b                	jmp    102a58 <printnum+0xe0>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a40:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a44:	8b 45 20             	mov    0x20(%ebp),%eax
  102a47:	89 04 24             	mov    %eax,(%esp)
  102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4d:	ff d0                	call   *%eax
        while (-- width > 0)
  102a4f:	ff 4d 1c             	decl   0x1c(%ebp)
  102a52:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a56:	7f e5                	jg     102a3d <printnum+0xc5>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a58:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a5b:	05 90 3c 10 00       	add    $0x103c90,%eax
  102a60:	0f b6 00             	movzbl (%eax),%eax
  102a63:	0f be c0             	movsbl %al,%eax
  102a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a69:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a6d:	89 04 24             	mov    %eax,(%esp)
  102a70:	8b 45 08             	mov    0x8(%ebp),%eax
  102a73:	ff d0                	call   *%eax
}
  102a75:	90                   	nop
  102a76:	89 ec                	mov    %ebp,%esp
  102a78:	5d                   	pop    %ebp
  102a79:	c3                   	ret    

00102a7a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a7a:	55                   	push   %ebp
  102a7b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a7d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a81:	7e 14                	jle    102a97 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a83:	8b 45 08             	mov    0x8(%ebp),%eax
  102a86:	8b 00                	mov    (%eax),%eax
  102a88:	8d 48 08             	lea    0x8(%eax),%ecx
  102a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  102a8e:	89 0a                	mov    %ecx,(%edx)
  102a90:	8b 50 04             	mov    0x4(%eax),%edx
  102a93:	8b 00                	mov    (%eax),%eax
  102a95:	eb 30                	jmp    102ac7 <getuint+0x4d>
    }
    else if (lflag) {
  102a97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a9b:	74 16                	je     102ab3 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa0:	8b 00                	mov    (%eax),%eax
  102aa2:	8d 48 04             	lea    0x4(%eax),%ecx
  102aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  102aa8:	89 0a                	mov    %ecx,(%edx)
  102aaa:	8b 00                	mov    (%eax),%eax
  102aac:	ba 00 00 00 00       	mov    $0x0,%edx
  102ab1:	eb 14                	jmp    102ac7 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab6:	8b 00                	mov    (%eax),%eax
  102ab8:	8d 48 04             	lea    0x4(%eax),%ecx
  102abb:	8b 55 08             	mov    0x8(%ebp),%edx
  102abe:	89 0a                	mov    %ecx,(%edx)
  102ac0:	8b 00                	mov    (%eax),%eax
  102ac2:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ac7:	5d                   	pop    %ebp
  102ac8:	c3                   	ret    

00102ac9 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ac9:	55                   	push   %ebp
  102aca:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102acc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ad0:	7e 14                	jle    102ae6 <getint+0x1d>
        return va_arg(*ap, long long);
  102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad5:	8b 00                	mov    (%eax),%eax
  102ad7:	8d 48 08             	lea    0x8(%eax),%ecx
  102ada:	8b 55 08             	mov    0x8(%ebp),%edx
  102add:	89 0a                	mov    %ecx,(%edx)
  102adf:	8b 50 04             	mov    0x4(%eax),%edx
  102ae2:	8b 00                	mov    (%eax),%eax
  102ae4:	eb 28                	jmp    102b0e <getint+0x45>
    }
    else if (lflag) {
  102ae6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102aea:	74 12                	je     102afe <getint+0x35>
        return va_arg(*ap, long);
  102aec:	8b 45 08             	mov    0x8(%ebp),%eax
  102aef:	8b 00                	mov    (%eax),%eax
  102af1:	8d 48 04             	lea    0x4(%eax),%ecx
  102af4:	8b 55 08             	mov    0x8(%ebp),%edx
  102af7:	89 0a                	mov    %ecx,(%edx)
  102af9:	8b 00                	mov    (%eax),%eax
  102afb:	99                   	cltd   
  102afc:	eb 10                	jmp    102b0e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102afe:	8b 45 08             	mov    0x8(%ebp),%eax
  102b01:	8b 00                	mov    (%eax),%eax
  102b03:	8d 48 04             	lea    0x4(%eax),%ecx
  102b06:	8b 55 08             	mov    0x8(%ebp),%edx
  102b09:	89 0a                	mov    %ecx,(%edx)
  102b0b:	8b 00                	mov    (%eax),%eax
  102b0d:	99                   	cltd   
    }
}
  102b0e:	5d                   	pop    %ebp
  102b0f:	c3                   	ret    

00102b10 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102b10:	55                   	push   %ebp
  102b11:	89 e5                	mov    %esp,%ebp
  102b13:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102b16:	8d 45 14             	lea    0x14(%ebp),%eax
  102b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b23:	8b 45 10             	mov    0x10(%ebp),%eax
  102b26:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b31:	8b 45 08             	mov    0x8(%ebp),%eax
  102b34:	89 04 24             	mov    %eax,(%esp)
  102b37:	e8 05 00 00 00       	call   102b41 <vprintfmt>
    va_end(ap);
}
  102b3c:	90                   	nop
  102b3d:	89 ec                	mov    %ebp,%esp
  102b3f:	5d                   	pop    %ebp
  102b40:	c3                   	ret    

00102b41 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b41:	55                   	push   %ebp
  102b42:	89 e5                	mov    %esp,%ebp
  102b44:	56                   	push   %esi
  102b45:	53                   	push   %ebx
  102b46:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b49:	eb 17                	jmp    102b62 <vprintfmt+0x21>
            if (ch == '\0') {
  102b4b:	85 db                	test   %ebx,%ebx
  102b4d:	0f 84 bf 03 00 00    	je     102f12 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b5a:	89 1c 24             	mov    %ebx,(%esp)
  102b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b60:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b62:	8b 45 10             	mov    0x10(%ebp),%eax
  102b65:	8d 50 01             	lea    0x1(%eax),%edx
  102b68:	89 55 10             	mov    %edx,0x10(%ebp)
  102b6b:	0f b6 00             	movzbl (%eax),%eax
  102b6e:	0f b6 d8             	movzbl %al,%ebx
  102b71:	83 fb 25             	cmp    $0x25,%ebx
  102b74:	75 d5                	jne    102b4b <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b76:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b7a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b84:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b87:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b8e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b91:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b94:	8b 45 10             	mov    0x10(%ebp),%eax
  102b97:	8d 50 01             	lea    0x1(%eax),%edx
  102b9a:	89 55 10             	mov    %edx,0x10(%ebp)
  102b9d:	0f b6 00             	movzbl (%eax),%eax
  102ba0:	0f b6 d8             	movzbl %al,%ebx
  102ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ba6:	83 f8 55             	cmp    $0x55,%eax
  102ba9:	0f 87 37 03 00 00    	ja     102ee6 <vprintfmt+0x3a5>
  102baf:	8b 04 85 b4 3c 10 00 	mov    0x103cb4(,%eax,4),%eax
  102bb6:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102bbc:	eb d6                	jmp    102b94 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102bc2:	eb d0                	jmp    102b94 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102bcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bce:	89 d0                	mov    %edx,%eax
  102bd0:	c1 e0 02             	shl    $0x2,%eax
  102bd3:	01 d0                	add    %edx,%eax
  102bd5:	01 c0                	add    %eax,%eax
  102bd7:	01 d8                	add    %ebx,%eax
  102bd9:	83 e8 30             	sub    $0x30,%eax
  102bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  102be2:	0f b6 00             	movzbl (%eax),%eax
  102be5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102be8:	83 fb 2f             	cmp    $0x2f,%ebx
  102beb:	7e 38                	jle    102c25 <vprintfmt+0xe4>
  102bed:	83 fb 39             	cmp    $0x39,%ebx
  102bf0:	7f 33                	jg     102c25 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102bf2:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102bf5:	eb d4                	jmp    102bcb <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  102bfa:	8d 50 04             	lea    0x4(%eax),%edx
  102bfd:	89 55 14             	mov    %edx,0x14(%ebp)
  102c00:	8b 00                	mov    (%eax),%eax
  102c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102c05:	eb 1f                	jmp    102c26 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102c07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c0b:	79 87                	jns    102b94 <vprintfmt+0x53>
                width = 0;
  102c0d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102c14:	e9 7b ff ff ff       	jmp    102b94 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102c19:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102c20:	e9 6f ff ff ff       	jmp    102b94 <vprintfmt+0x53>
            goto process_precision;
  102c25:	90                   	nop

        process_precision:
            if (width < 0)
  102c26:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c2a:	0f 89 64 ff ff ff    	jns    102b94 <vprintfmt+0x53>
                width = precision, precision = -1;
  102c30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c33:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c36:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c3d:	e9 52 ff ff ff       	jmp    102b94 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c42:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102c45:	e9 4a ff ff ff       	jmp    102b94 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c4a:	8b 45 14             	mov    0x14(%ebp),%eax
  102c4d:	8d 50 04             	lea    0x4(%eax),%edx
  102c50:	89 55 14             	mov    %edx,0x14(%ebp)
  102c53:	8b 00                	mov    (%eax),%eax
  102c55:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c58:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c5c:	89 04 24             	mov    %eax,(%esp)
  102c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c62:	ff d0                	call   *%eax
            break;
  102c64:	e9 a4 02 00 00       	jmp    102f0d <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c69:	8b 45 14             	mov    0x14(%ebp),%eax
  102c6c:	8d 50 04             	lea    0x4(%eax),%edx
  102c6f:	89 55 14             	mov    %edx,0x14(%ebp)
  102c72:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c74:	85 db                	test   %ebx,%ebx
  102c76:	79 02                	jns    102c7a <vprintfmt+0x139>
                err = -err;
  102c78:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c7a:	83 fb 06             	cmp    $0x6,%ebx
  102c7d:	7f 0b                	jg     102c8a <vprintfmt+0x149>
  102c7f:	8b 34 9d 74 3c 10 00 	mov    0x103c74(,%ebx,4),%esi
  102c86:	85 f6                	test   %esi,%esi
  102c88:	75 23                	jne    102cad <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102c8a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c8e:	c7 44 24 08 a1 3c 10 	movl   $0x103ca1,0x8(%esp)
  102c95:	00 
  102c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca0:	89 04 24             	mov    %eax,(%esp)
  102ca3:	e8 68 fe ff ff       	call   102b10 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102ca8:	e9 60 02 00 00       	jmp    102f0d <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102cad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102cb1:	c7 44 24 08 aa 3c 10 	movl   $0x103caa,0x8(%esp)
  102cb8:	00 
  102cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc3:	89 04 24             	mov    %eax,(%esp)
  102cc6:	e8 45 fe ff ff       	call   102b10 <printfmt>
            break;
  102ccb:	e9 3d 02 00 00       	jmp    102f0d <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  102cd3:	8d 50 04             	lea    0x4(%eax),%edx
  102cd6:	89 55 14             	mov    %edx,0x14(%ebp)
  102cd9:	8b 30                	mov    (%eax),%esi
  102cdb:	85 f6                	test   %esi,%esi
  102cdd:	75 05                	jne    102ce4 <vprintfmt+0x1a3>
                p = "(null)";
  102cdf:	be ad 3c 10 00       	mov    $0x103cad,%esi
            }
            if (width > 0 && padc != '-') {
  102ce4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ce8:	7e 76                	jle    102d60 <vprintfmt+0x21f>
  102cea:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cee:	74 70                	je     102d60 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cf0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cf7:	89 34 24             	mov    %esi,(%esp)
  102cfa:	e8 16 03 00 00       	call   103015 <strnlen>
  102cff:	89 c2                	mov    %eax,%edx
  102d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d04:	29 d0                	sub    %edx,%eax
  102d06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d09:	eb 16                	jmp    102d21 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102d0b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102d0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d12:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d16:	89 04 24             	mov    %eax,(%esp)
  102d19:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1c:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d1e:	ff 4d e8             	decl   -0x18(%ebp)
  102d21:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d25:	7f e4                	jg     102d0b <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d27:	eb 37                	jmp    102d60 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d29:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d2d:	74 1f                	je     102d4e <vprintfmt+0x20d>
  102d2f:	83 fb 1f             	cmp    $0x1f,%ebx
  102d32:	7e 05                	jle    102d39 <vprintfmt+0x1f8>
  102d34:	83 fb 7e             	cmp    $0x7e,%ebx
  102d37:	7e 15                	jle    102d4e <vprintfmt+0x20d>
                    putch('?', putdat);
  102d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d40:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d47:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4a:	ff d0                	call   *%eax
  102d4c:	eb 0f                	jmp    102d5d <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  102d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d55:	89 1c 24             	mov    %ebx,(%esp)
  102d58:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5b:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d5d:	ff 4d e8             	decl   -0x18(%ebp)
  102d60:	89 f0                	mov    %esi,%eax
  102d62:	8d 70 01             	lea    0x1(%eax),%esi
  102d65:	0f b6 00             	movzbl (%eax),%eax
  102d68:	0f be d8             	movsbl %al,%ebx
  102d6b:	85 db                	test   %ebx,%ebx
  102d6d:	74 27                	je     102d96 <vprintfmt+0x255>
  102d6f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d73:	78 b4                	js     102d29 <vprintfmt+0x1e8>
  102d75:	ff 4d e4             	decl   -0x1c(%ebp)
  102d78:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d7c:	79 ab                	jns    102d29 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  102d7e:	eb 16                	jmp    102d96 <vprintfmt+0x255>
                putch(' ', putdat);
  102d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d83:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d87:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d91:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  102d93:	ff 4d e8             	decl   -0x18(%ebp)
  102d96:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d9a:	7f e4                	jg     102d80 <vprintfmt+0x23f>
            }
            break;
  102d9c:	e9 6c 01 00 00       	jmp    102f0d <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102da8:	8d 45 14             	lea    0x14(%ebp),%eax
  102dab:	89 04 24             	mov    %eax,(%esp)
  102dae:	e8 16 fd ff ff       	call   102ac9 <getint>
  102db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102db6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dbf:	85 d2                	test   %edx,%edx
  102dc1:	79 26                	jns    102de9 <vprintfmt+0x2a8>
                putch('-', putdat);
  102dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dca:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd4:	ff d0                	call   *%eax
                num = -(long long)num;
  102dd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ddc:	f7 d8                	neg    %eax
  102dde:	83 d2 00             	adc    $0x0,%edx
  102de1:	f7 da                	neg    %edx
  102de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102de9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102df0:	e9 a8 00 00 00       	jmp    102e9d <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dfc:	8d 45 14             	lea    0x14(%ebp),%eax
  102dff:	89 04 24             	mov    %eax,(%esp)
  102e02:	e8 73 fc ff ff       	call   102a7a <getuint>
  102e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102e0d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e14:	e9 84 00 00 00       	jmp    102e9d <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e20:	8d 45 14             	lea    0x14(%ebp),%eax
  102e23:	89 04 24             	mov    %eax,(%esp)
  102e26:	e8 4f fc ff ff       	call   102a7a <getuint>
  102e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e31:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e38:	eb 63                	jmp    102e9d <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  102e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e41:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e48:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4b:	ff d0                	call   *%eax
            putch('x', putdat);
  102e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e54:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e60:	8b 45 14             	mov    0x14(%ebp),%eax
  102e63:	8d 50 04             	lea    0x4(%eax),%edx
  102e66:	89 55 14             	mov    %edx,0x14(%ebp)
  102e69:	8b 00                	mov    (%eax),%eax
  102e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e7c:	eb 1f                	jmp    102e9d <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e81:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e85:	8d 45 14             	lea    0x14(%ebp),%eax
  102e88:	89 04 24             	mov    %eax,(%esp)
  102e8b:	e8 ea fb ff ff       	call   102a7a <getuint>
  102e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e93:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e96:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e9d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ea1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ea4:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ea8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102eab:	89 54 24 14          	mov    %edx,0x14(%esp)
  102eaf:	89 44 24 10          	mov    %eax,0x10(%esp)
  102eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eb9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ebd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ecb:	89 04 24             	mov    %eax,(%esp)
  102ece:	e8 a5 fa ff ff       	call   102978 <printnum>
            break;
  102ed3:	eb 38                	jmp    102f0d <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102edc:	89 1c 24             	mov    %ebx,(%esp)
  102edf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee2:	ff d0                	call   *%eax
            break;
  102ee4:	eb 27                	jmp    102f0d <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eed:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ef9:	ff 4d 10             	decl   0x10(%ebp)
  102efc:	eb 03                	jmp    102f01 <vprintfmt+0x3c0>
  102efe:	ff 4d 10             	decl   0x10(%ebp)
  102f01:	8b 45 10             	mov    0x10(%ebp),%eax
  102f04:	48                   	dec    %eax
  102f05:	0f b6 00             	movzbl (%eax),%eax
  102f08:	3c 25                	cmp    $0x25,%al
  102f0a:	75 f2                	jne    102efe <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  102f0c:	90                   	nop
    while (1) {
  102f0d:	e9 37 fc ff ff       	jmp    102b49 <vprintfmt+0x8>
                return;
  102f12:	90                   	nop
        }
    }
}
  102f13:	83 c4 40             	add    $0x40,%esp
  102f16:	5b                   	pop    %ebx
  102f17:	5e                   	pop    %esi
  102f18:	5d                   	pop    %ebp
  102f19:	c3                   	ret    

00102f1a <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f1a:	55                   	push   %ebp
  102f1b:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f20:	8b 40 08             	mov    0x8(%eax),%eax
  102f23:	8d 50 01             	lea    0x1(%eax),%edx
  102f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f29:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f2f:	8b 10                	mov    (%eax),%edx
  102f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f34:	8b 40 04             	mov    0x4(%eax),%eax
  102f37:	39 c2                	cmp    %eax,%edx
  102f39:	73 12                	jae    102f4d <sprintputch+0x33>
        *b->buf ++ = ch;
  102f3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3e:	8b 00                	mov    (%eax),%eax
  102f40:	8d 48 01             	lea    0x1(%eax),%ecx
  102f43:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f46:	89 0a                	mov    %ecx,(%edx)
  102f48:	8b 55 08             	mov    0x8(%ebp),%edx
  102f4b:	88 10                	mov    %dl,(%eax)
    }
}
  102f4d:	90                   	nop
  102f4e:	5d                   	pop    %ebp
  102f4f:	c3                   	ret    

00102f50 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f50:	55                   	push   %ebp
  102f51:	89 e5                	mov    %esp,%ebp
  102f53:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f56:	8d 45 14             	lea    0x14(%ebp),%eax
  102f59:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f63:	8b 45 10             	mov    0x10(%ebp),%eax
  102f66:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f71:	8b 45 08             	mov    0x8(%ebp),%eax
  102f74:	89 04 24             	mov    %eax,(%esp)
  102f77:	e8 0a 00 00 00       	call   102f86 <vsnprintf>
  102f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f82:	89 ec                	mov    %ebp,%esp
  102f84:	5d                   	pop    %ebp
  102f85:	c3                   	ret    

00102f86 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f86:	55                   	push   %ebp
  102f87:	89 e5                	mov    %esp,%ebp
  102f89:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f95:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f98:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9b:	01 d0                	add    %edx,%eax
  102f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102fa7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102fab:	74 0a                	je     102fb7 <vsnprintf+0x31>
  102fad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb3:	39 c2                	cmp    %eax,%edx
  102fb5:	76 07                	jbe    102fbe <vsnprintf+0x38>
        return -E_INVAL;
  102fb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102fbc:	eb 2a                	jmp    102fe8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fbe:	8b 45 14             	mov    0x14(%ebp),%eax
  102fc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  102fc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fcc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd3:	c7 04 24 1a 2f 10 00 	movl   $0x102f1a,(%esp)
  102fda:	e8 62 fb ff ff       	call   102b41 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fe2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fe8:	89 ec                	mov    %ebp,%esp
  102fea:	5d                   	pop    %ebp
  102feb:	c3                   	ret    

00102fec <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fec:	55                   	push   %ebp
  102fed:	89 e5                	mov    %esp,%ebp
  102fef:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ff2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102ff9:	eb 03                	jmp    102ffe <strlen+0x12>
        cnt ++;
  102ffb:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  103001:	8d 50 01             	lea    0x1(%eax),%edx
  103004:	89 55 08             	mov    %edx,0x8(%ebp)
  103007:	0f b6 00             	movzbl (%eax),%eax
  10300a:	84 c0                	test   %al,%al
  10300c:	75 ed                	jne    102ffb <strlen+0xf>
    }
    return cnt;
  10300e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103011:	89 ec                	mov    %ebp,%esp
  103013:	5d                   	pop    %ebp
  103014:	c3                   	ret    

00103015 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103015:	55                   	push   %ebp
  103016:	89 e5                	mov    %esp,%ebp
  103018:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10301b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103022:	eb 03                	jmp    103027 <strnlen+0x12>
        cnt ++;
  103024:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103027:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10302a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10302d:	73 10                	jae    10303f <strnlen+0x2a>
  10302f:	8b 45 08             	mov    0x8(%ebp),%eax
  103032:	8d 50 01             	lea    0x1(%eax),%edx
  103035:	89 55 08             	mov    %edx,0x8(%ebp)
  103038:	0f b6 00             	movzbl (%eax),%eax
  10303b:	84 c0                	test   %al,%al
  10303d:	75 e5                	jne    103024 <strnlen+0xf>
    }
    return cnt;
  10303f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103042:	89 ec                	mov    %ebp,%esp
  103044:	5d                   	pop    %ebp
  103045:	c3                   	ret    

00103046 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103046:	55                   	push   %ebp
  103047:	89 e5                	mov    %esp,%ebp
  103049:	57                   	push   %edi
  10304a:	56                   	push   %esi
  10304b:	83 ec 20             	sub    $0x20,%esp
  10304e:	8b 45 08             	mov    0x8(%ebp),%eax
  103051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103054:	8b 45 0c             	mov    0xc(%ebp),%eax
  103057:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10305a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103060:	89 d1                	mov    %edx,%ecx
  103062:	89 c2                	mov    %eax,%edx
  103064:	89 ce                	mov    %ecx,%esi
  103066:	89 d7                	mov    %edx,%edi
  103068:	ac                   	lods   %ds:(%esi),%al
  103069:	aa                   	stos   %al,%es:(%edi)
  10306a:	84 c0                	test   %al,%al
  10306c:	75 fa                	jne    103068 <strcpy+0x22>
  10306e:	89 fa                	mov    %edi,%edx
  103070:	89 f1                	mov    %esi,%ecx
  103072:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103075:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103078:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10307e:	83 c4 20             	add    $0x20,%esp
  103081:	5e                   	pop    %esi
  103082:	5f                   	pop    %edi
  103083:	5d                   	pop    %ebp
  103084:	c3                   	ret    

00103085 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103085:	55                   	push   %ebp
  103086:	89 e5                	mov    %esp,%ebp
  103088:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10308b:	8b 45 08             	mov    0x8(%ebp),%eax
  10308e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103091:	eb 1e                	jmp    1030b1 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  103093:	8b 45 0c             	mov    0xc(%ebp),%eax
  103096:	0f b6 10             	movzbl (%eax),%edx
  103099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10309c:	88 10                	mov    %dl,(%eax)
  10309e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a1:	0f b6 00             	movzbl (%eax),%eax
  1030a4:	84 c0                	test   %al,%al
  1030a6:	74 03                	je     1030ab <strncpy+0x26>
            src ++;
  1030a8:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  1030ab:	ff 45 fc             	incl   -0x4(%ebp)
  1030ae:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1030b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030b5:	75 dc                	jne    103093 <strncpy+0xe>
    }
    return dst;
  1030b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1030ba:	89 ec                	mov    %ebp,%esp
  1030bc:	5d                   	pop    %ebp
  1030bd:	c3                   	ret    

001030be <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1030be:	55                   	push   %ebp
  1030bf:	89 e5                	mov    %esp,%ebp
  1030c1:	57                   	push   %edi
  1030c2:	56                   	push   %esi
  1030c3:	83 ec 20             	sub    $0x20,%esp
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1030d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030d8:	89 d1                	mov    %edx,%ecx
  1030da:	89 c2                	mov    %eax,%edx
  1030dc:	89 ce                	mov    %ecx,%esi
  1030de:	89 d7                	mov    %edx,%edi
  1030e0:	ac                   	lods   %ds:(%esi),%al
  1030e1:	ae                   	scas   %es:(%edi),%al
  1030e2:	75 08                	jne    1030ec <strcmp+0x2e>
  1030e4:	84 c0                	test   %al,%al
  1030e6:	75 f8                	jne    1030e0 <strcmp+0x22>
  1030e8:	31 c0                	xor    %eax,%eax
  1030ea:	eb 04                	jmp    1030f0 <strcmp+0x32>
  1030ec:	19 c0                	sbb    %eax,%eax
  1030ee:	0c 01                	or     $0x1,%al
  1030f0:	89 fa                	mov    %edi,%edx
  1030f2:	89 f1                	mov    %esi,%ecx
  1030f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030f7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1030fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103100:	83 c4 20             	add    $0x20,%esp
  103103:	5e                   	pop    %esi
  103104:	5f                   	pop    %edi
  103105:	5d                   	pop    %ebp
  103106:	c3                   	ret    

00103107 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103107:	55                   	push   %ebp
  103108:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10310a:	eb 09                	jmp    103115 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  10310c:	ff 4d 10             	decl   0x10(%ebp)
  10310f:	ff 45 08             	incl   0x8(%ebp)
  103112:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103119:	74 1a                	je     103135 <strncmp+0x2e>
  10311b:	8b 45 08             	mov    0x8(%ebp),%eax
  10311e:	0f b6 00             	movzbl (%eax),%eax
  103121:	84 c0                	test   %al,%al
  103123:	74 10                	je     103135 <strncmp+0x2e>
  103125:	8b 45 08             	mov    0x8(%ebp),%eax
  103128:	0f b6 10             	movzbl (%eax),%edx
  10312b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312e:	0f b6 00             	movzbl (%eax),%eax
  103131:	38 c2                	cmp    %al,%dl
  103133:	74 d7                	je     10310c <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103135:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103139:	74 18                	je     103153 <strncmp+0x4c>
  10313b:	8b 45 08             	mov    0x8(%ebp),%eax
  10313e:	0f b6 00             	movzbl (%eax),%eax
  103141:	0f b6 d0             	movzbl %al,%edx
  103144:	8b 45 0c             	mov    0xc(%ebp),%eax
  103147:	0f b6 00             	movzbl (%eax),%eax
  10314a:	0f b6 c8             	movzbl %al,%ecx
  10314d:	89 d0                	mov    %edx,%eax
  10314f:	29 c8                	sub    %ecx,%eax
  103151:	eb 05                	jmp    103158 <strncmp+0x51>
  103153:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103158:	5d                   	pop    %ebp
  103159:	c3                   	ret    

0010315a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10315a:	55                   	push   %ebp
  10315b:	89 e5                	mov    %esp,%ebp
  10315d:	83 ec 04             	sub    $0x4,%esp
  103160:	8b 45 0c             	mov    0xc(%ebp),%eax
  103163:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103166:	eb 13                	jmp    10317b <strchr+0x21>
        if (*s == c) {
  103168:	8b 45 08             	mov    0x8(%ebp),%eax
  10316b:	0f b6 00             	movzbl (%eax),%eax
  10316e:	38 45 fc             	cmp    %al,-0x4(%ebp)
  103171:	75 05                	jne    103178 <strchr+0x1e>
            return (char *)s;
  103173:	8b 45 08             	mov    0x8(%ebp),%eax
  103176:	eb 12                	jmp    10318a <strchr+0x30>
        }
        s ++;
  103178:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10317b:	8b 45 08             	mov    0x8(%ebp),%eax
  10317e:	0f b6 00             	movzbl (%eax),%eax
  103181:	84 c0                	test   %al,%al
  103183:	75 e3                	jne    103168 <strchr+0xe>
    }
    return NULL;
  103185:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10318a:	89 ec                	mov    %ebp,%esp
  10318c:	5d                   	pop    %ebp
  10318d:	c3                   	ret    

0010318e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10318e:	55                   	push   %ebp
  10318f:	89 e5                	mov    %esp,%ebp
  103191:	83 ec 04             	sub    $0x4,%esp
  103194:	8b 45 0c             	mov    0xc(%ebp),%eax
  103197:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10319a:	eb 0e                	jmp    1031aa <strfind+0x1c>
        if (*s == c) {
  10319c:	8b 45 08             	mov    0x8(%ebp),%eax
  10319f:	0f b6 00             	movzbl (%eax),%eax
  1031a2:	38 45 fc             	cmp    %al,-0x4(%ebp)
  1031a5:	74 0f                	je     1031b6 <strfind+0x28>
            break;
        }
        s ++;
  1031a7:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  1031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ad:	0f b6 00             	movzbl (%eax),%eax
  1031b0:	84 c0                	test   %al,%al
  1031b2:	75 e8                	jne    10319c <strfind+0xe>
  1031b4:	eb 01                	jmp    1031b7 <strfind+0x29>
            break;
  1031b6:	90                   	nop
    }
    return (char *)s;
  1031b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031ba:	89 ec                	mov    %ebp,%esp
  1031bc:	5d                   	pop    %ebp
  1031bd:	c3                   	ret    

001031be <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1031be:	55                   	push   %ebp
  1031bf:	89 e5                	mov    %esp,%ebp
  1031c1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031d2:	eb 03                	jmp    1031d7 <strtol+0x19>
        s ++;
  1031d4:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031da:	0f b6 00             	movzbl (%eax),%eax
  1031dd:	3c 20                	cmp    $0x20,%al
  1031df:	74 f3                	je     1031d4 <strtol+0x16>
  1031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e4:	0f b6 00             	movzbl (%eax),%eax
  1031e7:	3c 09                	cmp    $0x9,%al
  1031e9:	74 e9                	je     1031d4 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ee:	0f b6 00             	movzbl (%eax),%eax
  1031f1:	3c 2b                	cmp    $0x2b,%al
  1031f3:	75 05                	jne    1031fa <strtol+0x3c>
        s ++;
  1031f5:	ff 45 08             	incl   0x8(%ebp)
  1031f8:	eb 14                	jmp    10320e <strtol+0x50>
    }
    else if (*s == '-') {
  1031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fd:	0f b6 00             	movzbl (%eax),%eax
  103200:	3c 2d                	cmp    $0x2d,%al
  103202:	75 0a                	jne    10320e <strtol+0x50>
        s ++, neg = 1;
  103204:	ff 45 08             	incl   0x8(%ebp)
  103207:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10320e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103212:	74 06                	je     10321a <strtol+0x5c>
  103214:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103218:	75 22                	jne    10323c <strtol+0x7e>
  10321a:	8b 45 08             	mov    0x8(%ebp),%eax
  10321d:	0f b6 00             	movzbl (%eax),%eax
  103220:	3c 30                	cmp    $0x30,%al
  103222:	75 18                	jne    10323c <strtol+0x7e>
  103224:	8b 45 08             	mov    0x8(%ebp),%eax
  103227:	40                   	inc    %eax
  103228:	0f b6 00             	movzbl (%eax),%eax
  10322b:	3c 78                	cmp    $0x78,%al
  10322d:	75 0d                	jne    10323c <strtol+0x7e>
        s += 2, base = 16;
  10322f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103233:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10323a:	eb 29                	jmp    103265 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  10323c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103240:	75 16                	jne    103258 <strtol+0x9a>
  103242:	8b 45 08             	mov    0x8(%ebp),%eax
  103245:	0f b6 00             	movzbl (%eax),%eax
  103248:	3c 30                	cmp    $0x30,%al
  10324a:	75 0c                	jne    103258 <strtol+0x9a>
        s ++, base = 8;
  10324c:	ff 45 08             	incl   0x8(%ebp)
  10324f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103256:	eb 0d                	jmp    103265 <strtol+0xa7>
    }
    else if (base == 0) {
  103258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10325c:	75 07                	jne    103265 <strtol+0xa7>
        base = 10;
  10325e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103265:	8b 45 08             	mov    0x8(%ebp),%eax
  103268:	0f b6 00             	movzbl (%eax),%eax
  10326b:	3c 2f                	cmp    $0x2f,%al
  10326d:	7e 1b                	jle    10328a <strtol+0xcc>
  10326f:	8b 45 08             	mov    0x8(%ebp),%eax
  103272:	0f b6 00             	movzbl (%eax),%eax
  103275:	3c 39                	cmp    $0x39,%al
  103277:	7f 11                	jg     10328a <strtol+0xcc>
            dig = *s - '0';
  103279:	8b 45 08             	mov    0x8(%ebp),%eax
  10327c:	0f b6 00             	movzbl (%eax),%eax
  10327f:	0f be c0             	movsbl %al,%eax
  103282:	83 e8 30             	sub    $0x30,%eax
  103285:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103288:	eb 48                	jmp    1032d2 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10328a:	8b 45 08             	mov    0x8(%ebp),%eax
  10328d:	0f b6 00             	movzbl (%eax),%eax
  103290:	3c 60                	cmp    $0x60,%al
  103292:	7e 1b                	jle    1032af <strtol+0xf1>
  103294:	8b 45 08             	mov    0x8(%ebp),%eax
  103297:	0f b6 00             	movzbl (%eax),%eax
  10329a:	3c 7a                	cmp    $0x7a,%al
  10329c:	7f 11                	jg     1032af <strtol+0xf1>
            dig = *s - 'a' + 10;
  10329e:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a1:	0f b6 00             	movzbl (%eax),%eax
  1032a4:	0f be c0             	movsbl %al,%eax
  1032a7:	83 e8 57             	sub    $0x57,%eax
  1032aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032ad:	eb 23                	jmp    1032d2 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1032af:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b2:	0f b6 00             	movzbl (%eax),%eax
  1032b5:	3c 40                	cmp    $0x40,%al
  1032b7:	7e 3b                	jle    1032f4 <strtol+0x136>
  1032b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032bc:	0f b6 00             	movzbl (%eax),%eax
  1032bf:	3c 5a                	cmp    $0x5a,%al
  1032c1:	7f 31                	jg     1032f4 <strtol+0x136>
            dig = *s - 'A' + 10;
  1032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c6:	0f b6 00             	movzbl (%eax),%eax
  1032c9:	0f be c0             	movsbl %al,%eax
  1032cc:	83 e8 37             	sub    $0x37,%eax
  1032cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032d5:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032d8:	7d 19                	jge    1032f3 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1032da:	ff 45 08             	incl   0x8(%ebp)
  1032dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032e0:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032e4:	89 c2                	mov    %eax,%edx
  1032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e9:	01 d0                	add    %edx,%eax
  1032eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1032ee:	e9 72 ff ff ff       	jmp    103265 <strtol+0xa7>
            break;
  1032f3:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1032f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032f8:	74 08                	je     103302 <strtol+0x144>
        *endptr = (char *) s;
  1032fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032fd:	8b 55 08             	mov    0x8(%ebp),%edx
  103300:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103302:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103306:	74 07                	je     10330f <strtol+0x151>
  103308:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10330b:	f7 d8                	neg    %eax
  10330d:	eb 03                	jmp    103312 <strtol+0x154>
  10330f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103312:	89 ec                	mov    %ebp,%esp
  103314:	5d                   	pop    %ebp
  103315:	c3                   	ret    

00103316 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103316:	55                   	push   %ebp
  103317:	89 e5                	mov    %esp,%ebp
  103319:	83 ec 28             	sub    $0x28,%esp
  10331c:	89 7d fc             	mov    %edi,-0x4(%ebp)
  10331f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103322:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103325:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  103329:	8b 45 08             	mov    0x8(%ebp),%eax
  10332c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10332f:	88 55 f7             	mov    %dl,-0x9(%ebp)
  103332:	8b 45 10             	mov    0x10(%ebp),%eax
  103335:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10333b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10333f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103342:	89 d7                	mov    %edx,%edi
  103344:	f3 aa                	rep stos %al,%es:(%edi)
  103346:	89 fa                	mov    %edi,%edx
  103348:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10334b:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10334e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103351:	8b 7d fc             	mov    -0x4(%ebp),%edi
  103354:	89 ec                	mov    %ebp,%esp
  103356:	5d                   	pop    %ebp
  103357:	c3                   	ret    

00103358 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103358:	55                   	push   %ebp
  103359:	89 e5                	mov    %esp,%ebp
  10335b:	57                   	push   %edi
  10335c:	56                   	push   %esi
  10335d:	53                   	push   %ebx
  10335e:	83 ec 30             	sub    $0x30,%esp
  103361:	8b 45 08             	mov    0x8(%ebp),%eax
  103364:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103367:	8b 45 0c             	mov    0xc(%ebp),%eax
  10336a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10336d:	8b 45 10             	mov    0x10(%ebp),%eax
  103370:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103376:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103379:	73 42                	jae    1033bd <memmove+0x65>
  10337b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103384:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103387:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10338a:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10338d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103390:	c1 e8 02             	shr    $0x2,%eax
  103393:	89 c1                	mov    %eax,%ecx
    asm volatile (
  103395:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10339b:	89 d7                	mov    %edx,%edi
  10339d:	89 c6                	mov    %eax,%esi
  10339f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033a1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1033a4:	83 e1 03             	and    $0x3,%ecx
  1033a7:	74 02                	je     1033ab <memmove+0x53>
  1033a9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033ab:	89 f0                	mov    %esi,%eax
  1033ad:	89 fa                	mov    %edi,%edx
  1033af:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1033b2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  1033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  1033bb:	eb 36                	jmp    1033f3 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033c6:	01 c2                	add    %eax,%edx
  1033c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033cb:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d7:	89 c1                	mov    %eax,%ecx
  1033d9:	89 d8                	mov    %ebx,%eax
  1033db:	89 d6                	mov    %edx,%esi
  1033dd:	89 c7                	mov    %eax,%edi
  1033df:	fd                   	std    
  1033e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033e2:	fc                   	cld    
  1033e3:	89 f8                	mov    %edi,%eax
  1033e5:	89 f2                	mov    %esi,%edx
  1033e7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033ea:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033f3:	83 c4 30             	add    $0x30,%esp
  1033f6:	5b                   	pop    %ebx
  1033f7:	5e                   	pop    %esi
  1033f8:	5f                   	pop    %edi
  1033f9:	5d                   	pop    %ebp
  1033fa:	c3                   	ret    

001033fb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033fb:	55                   	push   %ebp
  1033fc:	89 e5                	mov    %esp,%ebp
  1033fe:	57                   	push   %edi
  1033ff:	56                   	push   %esi
  103400:	83 ec 20             	sub    $0x20,%esp
  103403:	8b 45 08             	mov    0x8(%ebp),%eax
  103406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103409:	8b 45 0c             	mov    0xc(%ebp),%eax
  10340c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10340f:	8b 45 10             	mov    0x10(%ebp),%eax
  103412:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103418:	c1 e8 02             	shr    $0x2,%eax
  10341b:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10341d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103423:	89 d7                	mov    %edx,%edi
  103425:	89 c6                	mov    %eax,%esi
  103427:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103429:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10342c:	83 e1 03             	and    $0x3,%ecx
  10342f:	74 02                	je     103433 <memcpy+0x38>
  103431:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103433:	89 f0                	mov    %esi,%eax
  103435:	89 fa                	mov    %edi,%edx
  103437:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10343a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10343d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  103440:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103443:	83 c4 20             	add    $0x20,%esp
  103446:	5e                   	pop    %esi
  103447:	5f                   	pop    %edi
  103448:	5d                   	pop    %ebp
  103449:	c3                   	ret    

0010344a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10344a:	55                   	push   %ebp
  10344b:	89 e5                	mov    %esp,%ebp
  10344d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103450:	8b 45 08             	mov    0x8(%ebp),%eax
  103453:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103456:	8b 45 0c             	mov    0xc(%ebp),%eax
  103459:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10345c:	eb 2e                	jmp    10348c <memcmp+0x42>
        if (*s1 != *s2) {
  10345e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103461:	0f b6 10             	movzbl (%eax),%edx
  103464:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103467:	0f b6 00             	movzbl (%eax),%eax
  10346a:	38 c2                	cmp    %al,%dl
  10346c:	74 18                	je     103486 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10346e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103471:	0f b6 00             	movzbl (%eax),%eax
  103474:	0f b6 d0             	movzbl %al,%edx
  103477:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10347a:	0f b6 00             	movzbl (%eax),%eax
  10347d:	0f b6 c8             	movzbl %al,%ecx
  103480:	89 d0                	mov    %edx,%eax
  103482:	29 c8                	sub    %ecx,%eax
  103484:	eb 18                	jmp    10349e <memcmp+0x54>
        }
        s1 ++, s2 ++;
  103486:	ff 45 fc             	incl   -0x4(%ebp)
  103489:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  10348c:	8b 45 10             	mov    0x10(%ebp),%eax
  10348f:	8d 50 ff             	lea    -0x1(%eax),%edx
  103492:	89 55 10             	mov    %edx,0x10(%ebp)
  103495:	85 c0                	test   %eax,%eax
  103497:	75 c5                	jne    10345e <memcmp+0x14>
    }
    return 0;
  103499:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10349e:	89 ec                	mov    %ebp,%esp
  1034a0:	5d                   	pop    %ebp
  1034a1:	c3                   	ret    
