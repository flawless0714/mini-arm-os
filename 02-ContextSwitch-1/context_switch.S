.thumb
.syntax unified

.global activate
activate:
	/* save kernel state (into main stack pointer instead of process pointer)*/
	mrs ip, psr /* store pse into ip (r12) */
	push {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr} /* push into MSP */

	/* switch to process stack */
	msr psp, r0 /* r0 stores function call arg, which is `usertask_stack_start` in this example */
	mov r0, #3 /* this one is not sure, since bit 0 is reserved, which means we can use #2 instead of set bit 0 also */
	msr control, r0 /* "control" is a register, which uses its bit[1] to control the current stack pointer,
					   0-> MSP is current SP, whereas 1 -> PSP is current SP */

	/* load user state */
	/* lr is now storing usertask (usertask_stack_start[8] correspond to ninth register, lr) */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, lr} 

	/* jump to user task (which then prints string "User Task #1\n") */
	bx lr
