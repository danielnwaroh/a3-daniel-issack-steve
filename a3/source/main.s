@ CPSC 359 L01 Assignment 3

@ Code section
.section    .text

.global main

main: 	
		ldr		r0,	=names
		bl		printf
		
stop:	b		stop

@ Data section
.section    .data

names:
.asciz	"Creatd by: Daniel Nwaroh, Issack John and Steve Khanna\n"

hello:
.asciz	"Hello World!\n"

press

butB:
butY:
butSelect:
butStart:
butUp:
butDown:
butLeft:
butRight:
butA:
butX:
butLb:
butRb:

end:
.asciz 	"Program is terminating...\n"
