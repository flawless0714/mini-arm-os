ENTRY(reset_handler) /* program entry point */

MEMORY
{
	/*
	 * Location to flash application code,
	 * Start address,
	 * Size of storage can be flashed
	 */
	FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 128K 
}

SECTIONS
{
	.text : /* text section is the first section in target binary */
	{
		/* 
		 * {KEEP} makes the specified section not being recycled when link-time garbage collection is enabled,
		 * this also keep sections in intended order.
		 */
		KEEP(*(.isr_vector)) 
		*(.text)
	} >FLASH /* .text section will be flash to memory, FLASH. */
}
