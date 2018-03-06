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

pressButton:
.asciz	"Please press a button ...\n"

butB:
.asciz	"You have pressed B\n"
butY:
.asciz	"You have pressed Y\n"
butSelect:
.asciz	"You have pressed select\n"
butStart:
butUp:
.asciz	"You have pressed Joy-pad UP\n"
butDown:
.asciz	"You have pressed Joy-pad DOWN\n"
butLeft:
.asciz	"You have pressed Joy-pad LEFT\n"
butRight:
.asciz	"You have pressed Joy-pad RIGHT\n"
butA:
.asciz	"You have pressed A\n"
butX:
.asciz	"You have pressed X\n"
butLb:
.asciz	"You have pressed LEFT\n"
butRb:
.asciz	"You have pressed RIGHT\n"

end:
.asciz 	"Program is terminating...\n"
