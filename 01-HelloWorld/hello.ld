ENTRY(reset_handler)

MEMORY
{
	FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 128K
	RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 40K
}

SECTIONS
{
	.text :
	{
		KEEP(*(.isr_vector))
		*(.text)
		*(.text.*)
		*(.rodata)
		_sromdev = .;
		_eromdev = .;
		_sidata = .; 
		/* this kinds of variable can be used as extern variable in c code, and this one is used to indicate
		   start address of value of variables at .data section */
	} >FLASH

	/* AT(ldadr): Specifies address to load the section. Usually, value of .data section stores at end of .text
	   section, therefore we need to load them from ROM to RAM. Note that .data section may has its address to
	   load, but AT(ldadr) can specifies address to load the section anyway */
	.data : AT(_sidata)
	{
		_sdata = .;
		*(.data)
		*(.data*)
		_edata = .;
	} >RAM

	.bss :
	{
		_sbss = .;
		*(.bss)
		_ebss = .;
	} >RAM

	_estack = ORIGIN(RAM) + LENGTH(RAM);
}
