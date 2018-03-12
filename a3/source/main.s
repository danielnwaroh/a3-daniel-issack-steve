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
		mov		r10, #0
		mov		r7,	#0
		mov		r8,	#0xFFFF
		
		bl		request
		
top:	ldr		r0,	=pressButton
		bl		printf
		
looop:	
		bl		Read_SNES
		mov		r7,	r0
		
		mov		r0,	#60000
		bl		delayMicroseconds
		
		bl		Read_SNES
		cmp		r7,	r0
		beq		looop
		
		cmp		r7,	r8
		beq		looop
		
		mov		r7,	r0
		
		ldr		r1,	=#0b01111111111111111
		teq		r7,	r1
		beq		printB
		
		ldr		r1,	=#0b1011111111111111
		teq		r7,	r1
		beq		printY
		
		ldr		r1,	=#0b1101111111111111
		teq		r7,	r1
		beq		printSelect
		
		ldr		r1,	=#0b1110111111111111
		teq		r7,	r1
		beq		printEnd
		
		ldr		r1,	=#0b1111011111111111
		teq		r7,	r1
		beq		printUp
		
		ldr		r1,	=#0b1111101111111111
		teq		r7,	r1
		beq		printDown
		
		ldr		r1,	=#0b1111110111111111
		teq		r7,	r1
		beq		printLeft
		
		ldr		r1,	=#0b1111111011111111
		teq		r7,	r1
		beq		printRight
		
		ldr		r1,	=#0b1111111101111111
		teq		r7,	r1
		beq		printA
		
		ldr		r1,	=#0b1111111110111111
		teq		r7,	r1
		beq		printX
		
		ldr		r1,	=#0b1111111111011111
		teq		r7,	r1
		beq		printLb
		
		ldr		r1,	=#0b1111111111101111
		teq		r7,	r1
		beq		printRb
		
		b		top
		
printB:
		ldr		r0,	=butB
		bl		printf

		b		top

printY:
		ldr		r0,	=butY
		bl		printf
		
		b		top

printSelect:
		ldr		r0,	=butSelect
		bl		printf

		b		top

printUp:
		ldr		r0,	=butUp
		bl		printf

		b		top

printDown:
		ldr		r0,	=butDown
		bl		printf

		b		top

printLeft:
		ldr		r0,	=butLeft
		bl		printf

		b		top

printRight:
		ldr		r0,	=butRight
		bl		printf

		b		top

printA:
		ldr		r0,	=butA
		bl		printf

		b		top

printX:
		ldr		r0,	=butX
		bl		printf

		b		top

printLb:
		ldr		r0,	=butLb
		bl		printf

		b		top

printRb:
		ldr		r0,	=butRb
		bl		printf

		b		top

printEnd:
		ldr		r0,	=end
		bl		printf

		b		stop		
		

stop:	b		stop

request:
		push 	{ fp, lr}
		mov		fp,	sp

		bl		getGpioPtr
		ldr		r1,	=label				@Base address
		str		r0,	[r1]

		mov		r0,	#9
		mov		r1,	#1
		bl		InitGPIO

		mov		r0,	#10
		mov		r1,	#0
		bl		InitGPIO

		mov		r0,	#11
		mov		r1,	#1
		bl		InitGPIO
		
		pop		{fp, pc}
		mov		pc, lr

@the subroutine initializes a GPIO line,
@the line number and function code must be passed
@as parameters. The subroutine needs to be general
InitGPIO:
		mov		r4,	r0								@r4: 1st arg
		mov		r5,	r1								@r5: 2nd arg, function code 1 or 0
		
		//mov		r4,	r0
		
		//ldr		r0,	=test2
		//mov		r1,	r4
		//bl		printf

		cmp		r0,	#9
		beq		lineNine

		cmp		r0,	#10
		beq		lineTen

		b		lineElvn

@LATCH - output
lineNine:
		ldr		r0,	=label
		ldr		r0, [r0]
		
		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#27

		bic		r1,	r2
		mov		r3,	#1

		lsl		r3,	#27
		orr		r1,	r3

		str		r1,	[r0]
		
		b		ExitInitGPIO

@DATA - input
lineTen:
		mov		r4,	r0
		
		ldr		r0,	=label
		@ldr		r0,	[r0]
		ldr		r0, [r0]
		add		r0,	r0,	#4
		@sub		r4,	#10
		@ldr		r1,	[r0, #0x4]
		
		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#3

		bic		r1,	r2
		mov		r3,	#0
		
		lsl		r5,	r4

		orr 	r1,	r5

		str 	r1,	[r0]
		
		b		ExitInitGPIO

@CLOCK - output
lineElvn:
		ldr		r0,	=label
		@ldr		r0,	[r0]
		ldr		r0, [r0]
		add		r0,	r0,#4
		@ldr		r1,	[r0, #4]

		ldr		r1,	[r0]

		mov		r2,	#7
		lsl		r2,	#3

		bic		r1,	r2
		mov		r3,	#1
		
		lsl		r5,	r4
		orr		r1,	r5

		str		r1,	[r0]		
		

ExitInitGPIO:
		mov		pc, lr
		

@Write a bit to the SNES latch line
Write_Latch:
		mov		r1,	#9
		
		ldr		r2,	=label
		ldr		r2, [r2]
		
		mov		r3,	#1
		
		lsl		r3,	r1												@ align bit for pin#9
		teq		r0,	#0
		
		streq	r3,	[r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0
		
		mov		pc, lr

@writes a bit to the SNES clock line
Write_Clock:
		
		mov		r1, #11

		ldr		r2,	=label
		ldr		r2, [r2]
		
		mov 	r3,	#1
		lsl		r3,	r1											@ align bit for pin#11
		
		teq 	r0,	#0
		
		streq	r3, [r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0
		
		mov		pc, lr

@reads a bit from the SNES data line
Read_Data:
		mov		r0,	#10
		
		ldr		r2,	=label
		ldr		r2, [r2]
		ldr		r1,	[r2, #52]									@ GPLEV 0
		
		mov		r3,	#1
		lsl		r3,	r0												@ align bit for pin#10
		
		and		r1,	r3												@ mask everything else
		
		teq		r1,	#0
		
		moveq	r0,	#0												@ return 0
		movne	r0,	#1												@ return 1
		
		mov		pc, lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@main SNES subroutine that reads input(buttons pressed) from a SNES controller. Returns the code of a pressed button in a register
Read_SNES:
		push 	{r5, r6, lr}

		mov		r0,	#1
		bl		Write_Clock
		
		mov		r0,	#1
		bl		Write_Latch
		
		mov		r0,	#12
		bl		delayMicroseconds
		
		mov		r0,	#0
		bl		Write_Latch
		
		mov		r5,	#0										@r5 = i

		mov		r6,	#0x0000										@r6 is button
pulseLoop:	
		mov		r0,	#6
		bl		delayMicroseconds
		
		mov		r0,	#0
		bl		Write_Clock
		
		mov		r0,	#6
		bl		delayMicroseconds
		
		bl		Read_Data
		
		lsl		r6,	#1
		orr		r6,	r0

		mov		r0,	#1
		bl		Write_Clock
		
		add		r5,	r5,	#1
		
		cmp		r5,	#16
		blt		pulseLoop
		
		mov		r0,	r6
		
		pop		{r5, r6, pc}

@ Data section
.section    .data

.global label
label:
.int		0

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
test1:
.asciz	"Test 1 r0: %d\n"
test2:
.asciz	"here\n"

end:
.asciz 	"Program is terminating...\n"



