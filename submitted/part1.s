
.section	.data
data_items:
.ascii		"/bin/sh\0"

.section	.text
.globl		_start

_start:
	pushq	%rbp				#saves the old base pointer
	movq	%rsp, %rbp			#current stack pointer -> new base pointer
	subq	$16, %rsp			#allocate a stach having 2 rooms(each word is 8 byte)

	movq	$data_items, -16(%rbp)		#first room is holding our bin/sh(first parameter)
	movq	$0, -8(%rbp)			#second room is holding 0(NULL)

	# REVERSE order parametere assigning for execve
	pushq	$0x0				#push the NULL to the stack
	leaq	-16(%rbp), %rcx			#Load the address of bin/sh string on stack
	pushq	%rcx				#push the address into rcx
	movq	-16(%rbp), %rcx			#Load the value of string (i.e the actual string of /bin/sh)
	pushq	%rcx				#push the value into rcx
	movq	%rcx, %rdi			#push the rcx into rdi


	movq	$59, %rax			#system call for execve
	syscall

	movq	$60, %rax			#system call for exit
	syscall
