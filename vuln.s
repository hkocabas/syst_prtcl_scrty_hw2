	.file	"vuln.c"
	.comm	hold,4,4
	.comm	i,4,4
	.text
	.globl	get_sp
	.type	get_sp, @function
get_sp:
	pushl	%ebp
	movl	%esp, %ebp
#APP
# 11 "vuln.c" 1
	movq %rsp,%rax
# 0 "" 2
#NO_APP
	popl	%ebp
	ret
	.size	get_sp, .-get_sp
	.section	.rodata
.LC0:
	.string	"\n\nValue of Test:%x"
.LC1:
	.string	"\nValue of filename[0]:%x\n"
	.align 4
.LC2:
	.string	"\nYou are going to need a buffer a little larger than:%d\n\n"
	.text
	.globl	dumb
	.type	dumb, @function
dumb:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$1060, %esp
	movl	8(%ebp), %eax
	movl	%eax, -1052(%ebp)
	movl	%gs:20, %eax
	movl	%eax, -12(%ebp)
	xorl	%eax, %eax
	leal	-1040(%ebp), %eax
	movl	%eax, hold
	leal	-1040(%ebp), %eax
	cltd
	movl	%eax, 4(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC0, (%esp)
	call	printf
	leal	-1036(%ebp), %eax
	cltd
	movl	%eax, 4(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC1, (%esp)
	call	printf
	leal	-1040(%ebp), %eax
	cltd
	leal	-1036(%ebp), %ecx
	movl	%ecx, %ebx
	sarl	$31, %ebx
	subl	%ecx, %eax
	sbbl	%ebx, %edx
	movl	%eax, 4(%esp)
	movl	$.LC2, (%esp)
	call	printf
	movl	-1052(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-1036(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	nop
	movl	-12(%ebp), %eax
	xorl	%gs:20, %eax
	je	.L4
	call	__stack_chk_fail
.L4:
	addl	$1060, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	dumb, .-dumb
	.section	.rodata
.LC3:
	.string	"\nLength of Input String:%d\n"
	.align 4
.LC4:
	.string	"\n\nError: No Command Line arg for vuln was given\n"
.LC5:
	.string	"Useless Text"
	.text
	.globl	main
	.type	main, @function
main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$10048, %esp
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%gs:20, %eax
	movl	%eax, 10044(%esp)
	xorl	%eax, %eax
	movl	12(%esp), %eax
	movl	4(%eax), %eax
	movl	%eax, 28(%esp)
	call	get_sp
	movl	%eax, 32(%esp)
	movl	%edx, 36(%esp)
	cmpl	$1, 8(%ebp)
	jle	.L6
	movl	28(%esp), %eax
	movl	%eax, (%esp)
	call	strlen
	movl	%eax, 4(%esp)
	movl	$.LC3, (%esp)
	call	printf
	movl	12(%esp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	dumb
	jmp	.L7
.L6:
	movl	$.LC4, (%esp)
	call	puts
	movl	$.LC5, (%esp)
	call	dumb
.L7:
	movl	$0, %eax
	movl	10044(%esp), %edx
	xorl	%gs:20, %edx
	je	.L9
	call	__stack_chk_fail
.L9:
	leave
	ret
	.size	main, .-main
	.ident	"GCC: (Ubuntu 4.8.4-2ubuntu1~14.04.3) 4.8.4"
	.section	.note.GNU-stack,"",@progbits
