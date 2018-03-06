@ CPSC 359 L01 Assignment 3
@ Daniel Nwaroh & Issack John & Steve Khanna

@ Code section
.section    .text

.global main

main:
		ldr		r0,	=names
		bl		printf
		b		request

stop:	b		stop

request:
		ldr		r0,	=pressButton
		bl		printf





printB:
		ldr		r0,	=butB
		bl		printf

		b			request

printY:
		ldr		r0,	=butY
		bl		printf

		b		request

printSelect:
		ldr		r0,	=butSelect
		bl		printf

		b		request

printUp:
		ldr		r0,	=butUp
		bl		printf

		b		request
		
printDown:
		ldr		r0,	=butDown
		bl		printf

		b		request
		
printLeft:
		ldr		r0,	=butLeft
		bl		printf

		b		request
		
printRight:
		ldr		r0,	=butRight
		bl		printf

		b		request

printA:
		ldr		r0,	=butA
		bl		printf

		b		request
		
printX:
		ldr		r0,	=butX
		bl		printf

		b		request
		
printLb:
		ldr		r0,	=butLb
		bl		printf

		b		request
		
printRb:
		ldr		r0,	=butRb
		bl		printf

		b		request
		
printEnd:
		ldr		r0,	=end
		bl		printf
		
		b		stop

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
