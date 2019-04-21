#include <stdint.h>

static int semihost_call(int service, void *opaque)
{
	/* line 6 ~ 8 are hard-coded, they are spec specified */
	register int r0 asm("r0") = service;
	register void *r1 asm("r1") = opaque;
	register int result asm("r0");
	asm volatile("bkpt 0xab" 
	             : "=r" (result) : "r" (r0), "r" (r1)); 
	/* trigger svc mode, with r0 as op number, r1 as input pointer and save
	   result (0 is success) to r0 , this is also hard-coded */
	return result;
}

enum SEMIHOST_SVC {
	SYS_WRITE = 0x05, /* hard-coded */
};

void main(void)
{
	char message[] = "Hello World!\n";
	uint32_t param[] = { 1, (uint32_t) message, sizeof(message) }; /* create three-word data block for SVC (SYS_WRITE use) */
	semihost_call(SYS_WRITE, (void *) param);
	while (1);
}
