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
		
		mov		r3,	#0					@register sampling buttons

		bl		getGpioPtr
		ldr		r1,	=gpioBaseAddress
		str		r0,	[r1]

		@mov		r0,	#1
		@bl		Write_Clock				@write 1 to CLK

		@mov		r0,	#1
		@bl		Write_Latch				@write 1 to LAT

		@mov		r0,	#12
		@bl		delayMicroseconds

@GPIO pin 11
@PIN 23
initCLK:
		@initializing SNES - CLOCK line, setting GPIO pin11(CLK) to output
		ldr		r0, =gpioBaseAddress	@save GPIO addy to a local variable
		ldr		r1, [r0]
		mov		r2,	#7					@(b0111)
		lsl		r2,	#3					@index of 1st bit for pin 11
		@r2 = 0 111 000
		bic		r1,	r2					@clear pin11 bits
		mov		r3,	#1					@output function code
		lsl		r3,	#3					@r3=0 001 000
		orr 	r1,	r3					@set pin11 function in r1
		str 	r1,	[r0]				@write back to GPFSEL1

@GPIO pin 9
@PIN 21
initLAT:
		@initializing SNES - LATCH line, setting GPIO pin9(LAT) to output
		ldr		r0, =gpioBaseAddress	@save GPIO addy to a local variable
		ldr		r1, [r0]
		mov		r2,	#7
		lsl		r2,	#3
		bic		r1,	r2
		mov		r3,	#1
		lsl		r3,	#3
		orr 	r1,	r3
		str 	r1,	[r0]

@GPIO pin 10
@PIN 19
initDAT:
		@initializing SNES - DATA line, setting GPIO pin10(DAT) to input
		ldr		r0, =gpioBaseAddress	@save GPIO addy to a local variable
		ldr		r1, [r0]
		mov		r2,	#6					@(b0110)
		lsl		r2,	#3					@
		bic		r1,	r2					@
		mov		r3,	#1
		lsl		r3,	#3
		orr 	r1,	r3
		str 	r1,	[r0]
		
@We need GPIO 9, 10, 11
@GPIO9: LATCH
@GPIO10: DATA
@GPIO11: CLOCK		
initGPIO:
		
		

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

.global gpioBaseAddress
gpioBaseAddress:
.int	0
