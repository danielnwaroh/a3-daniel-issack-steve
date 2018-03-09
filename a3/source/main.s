@ CPSC 359 L01 Assignment 3
@ Daniel Nwaroh & Issack John & Steve Khanna

@ASSIGNMENT CHECK LIST[]

@Display creator names & messages	  []
@Correctly reading/printing buttons   []
@Following APCS						  []
@using subroutines					  []
@Loop back (not "START")			  []
@Well documented code			 	  []






@ Code section
.section    .text

.global main
.global	getGpioPtr

main:
		ldr		r0,	=names
		bl		printf
		@b		request

stop:	b		stop

request:
		ldr		r0,	=pressButton
		bl		printf

		bl		getGpioPtr
		ldr		r0,	=label				@Base address
		str		r0,	[r0]

		mov		r0,	#9
		mov		r3,	#0b001
		bl		InitGPIO

		mov		r0,	#10
		mov		r3,	#0b00
		bl		InitGPIO

		mov		r0,	#11
		mov		r3,	#0b001
		bl		InitGPIO


@the subroutine initializes a GPIO line,
@the line number and function code must be passed
@as parameters. The subroutine needs to be general
Init_GPIO:
		push 	{ fp, lr}
		mov		fp,	sp

		cmp		r0,	#9
		beq		lineNine

		cmp		r0,	#10
		beq		lineTen

		b		lineElvn

@LATCH - output
lineNine:
		ldr		r0,	=label
		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#9

		bic		r1,	r2
		mov		r3,	#1

		lsl		r3,	#9
		orr		r1,	r3

		str		r1,	[r0]
@DATA - input
lineTen:
		ldr		r0,	=label
		ldr		r1,	[r0, #4]

		mov		r2,	#6
		lsl		r2,	#3

		bic		r1,	r2
		mov		r3,	#0

		orr 	r1,	r3

		str 	r1,	[r0]

@CLOCK - output
lineElvn:
		ldr		r0,	=label
		ldr		r1,	[r0, #4]

		mov		r2,	#7
		lsl		r2,	#3

		bic		r1,	r2
		mov		r3,	#3

		orr		r1,	r3
		str		r1,	[r0]


		pop		{fp, pc}
		mov		pc, lr

@Write a bit to the SNES latch line
Write_Latch:
		ldr		r2,	=label
		mov		r3,	#1
		lsl		r3,	#9												@ align bit for pin#9
		teq		r1,	#0
		streq	r3,	[r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0

@writes a bit to the SNES clock line
Write_Clock:
		ldr		r2,	=label
		mov 	r3,	#1
		lsl		r3,	#11												@ align bit for pin#11
		teq 	r1,	#0
		streq	r3, [r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0

@reads a bit from the SNES data line
Read_Data:
		ldr		r2,	=label
		ldr		r1,	[r2, #52]									@ GPLEV 0
		mov		r3,	#1
		lsl		r3,	#10												@ align bit for pin#10
		and		r1,	r3												@ mask everything else
		teq		r1,	#0
		moveq	r4,	#0												@ return 0
		movne	r4,	#1												@ return 1

@main SNES subroutine that reads input(buttons pressed) from a SNES controller. Returns the code of a pressed button in a register
Read_SNES:


printB:
		ldr		r0,	=butB
		bl		printf

		b		request

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

label:
.rept	64
.word

names:
.asciz	"Created by: Daniel Nwaroh, Issack John and Steve Khanna\n"

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
