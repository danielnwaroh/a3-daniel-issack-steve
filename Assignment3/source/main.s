@ CPSC 359 L01 Assignment 3
@ Daniel Nwaroh & Issack John & Steve Khanna
@ Daniel Nwaroh: 30017476
@ Steve Khanna: 10153930
@ Issack John: 30031053

@ Code section
.section    .text

.global main
.global	getGpioPtr

main:
		ldr		r0,	=names										@Load creator names
		bl		printf											@Print Creator names
		mov		r10,	#0xffff									@Checker reg: meaning nothing is being pushed
		
		bl		getGpioPtr										@getting GPIO address	
		ldr		r1,	=gpioBaseAddress							@Base address
		str		r0,	[r1]						
		
		mov		r0,	#9											@GPIO pin 9 (Latch) passed as a param
		mov		r1,	#1											@Function code for output
		bl		InitGPIO

		mov		r0,	#10											@GPIO pin 10 (Data) passed as a param
		mov		r1,	#0											@Function code for input
		bl		InitGPIO

		mov		r0,	#11											@GPIO pin 11 (Clock) passed as a param
		mov		r1,	#1											@Function code for output
		bl		InitGPIO

@User prompt to press a button
request:		
		ldr		r0,	=pressButton
		bl		printf

@Program doesnt print anything till button is pressed
delay:	
		bl		Read_SNES										@Calls the function
		mov		r7,	r0											@Copy of returned val from func
		mov		r0,	#60000										@Delays 60000 us
		bl		delayMicroseconds		
		bl		Read_SNES
		cmp		r7, r0											@Checks if two buttons are pressed simulataneously
		beq		delay						
		cmp		r0, r10											@Makes sure a button was pressed
		beq		delay						
		bl		checkMsg										@If button was pressed, checks which one 
		b		request											@Loops back for a new prompt
@Checks which button was pressed		
checkMsg:
		push	{r6, lr}
		mov		r6,	r0
		
		ldr		r1,	=#0x7FFF
		teq		r6,	r1
		beq		printB
		
		ldr		r1,	=#0xBFFF
		teq		r6,	r1
		beq		printY
		
		ldr		r1,	=0xDFFF
		teq		r6,	r1
		beq		printSelect
		
		ldr		r1,	=0xEFFF
		teq		r6,	r1
		beq		printEnd
		
		ldr		r1,	=0xF7FF
		teq		r6,	r1
		beq		printUp
		
		ldr		r1,	=0xFBFF
		teq		r6,	r1
		beq		printDown
		
		ldr		r1,	=0xFDFF
		teq		r6,	r1
		beq		printLeft
		
		ldr		r1,	=0xFEFF
		teq		r6,	r1
		beq		printRight
		
		ldr		r1,	=0xFF7F
		teq		r6,	r1
		beq		printA
		
		ldr		r1,	=0xFFBF
		teq		r6,	r1
		beq		printX
		
		ldr		r1,	=0xFFDF
		teq		r6,	r1
		beq		printLb
		
		ldr		r1,	=0xFFEF
		teq		r6,	r1
		beq		printRb
		
		pop		{r8, pc}	
		
@Inf loop to end program
stop:	b		stop

@the subroutine initializes a GPIO line,
@the line number and function code must be passed
@as parameters. The subroutine needs to be general
InitGPIO:
		push 	{r4, r5, r7, r8}
		mov		r4,	r0											@r4: 1st arg
		mov		r5,	r1											@r5: 2nd arg, function code 1 or 0
		ldr		r0,	=gpioBaseAddress
		ldr		r0,[r0]
		cmp		r4,	#9
		beq		LineNine
		cmp		r4, #10
		beq		LineTen
		
LineEleven:
		ldr		r0, =gpioBaseAddress
		ldr		r0, [r0]
		add		r0, r0, #4										@Original address incremented by 4
		ldr		r1, [r0]										@Copy GPFSEL1 into r1
		mov		r8, #1											@Least sig bit
		mov		r2, #7											@b0111		
		lsl		r2, #3											@r2= 0 111 000
		bic		r1, r2											@Clear pin 11 bits
		lsl		r5, #3											@r5= 0 001 000
		orr		r1, r5											@set pin11 func in r1
		str		r1, [r0]										@write back to GPFSEL1
		b		ExitGPIO
				
LineTen:
		ldr		r0, =gpioBaseAddress
		ldr		r0, [r0]
		add		r0, r0, #4
		ldr		r1, [r0]
		mov		r2, #7
		mov		r7, #3
		bic		r1, r2
		str		r1, [r0]
		b		ExitGPIO
LineNine:
		ldr		r0, =gpioBaseAddress
		ldr		r0, [r0]
		ldr		r1, [r0]
		mov		r2, #7
		bic		r1, r0
		str		r1, [r0]
		b		ExitGPIO
		
ExitGPIO:
		pop	{r4, r5, r7, r8}	
		mov	pc, lr				
		
@Write a bit to the SNES latch line
Write_Latch:
		mov		r1,	r0											@Copy of val passed 
		mov		r0,	#9											@pin9 = latch line
		ldr		r2,	=gpioBaseAddress							@base GPIO reg
		ldr		r2, [r2]										
		mov		r3,	#1
		lsl		r3,	r0											@ align bit for pin#9
		teq		r1,	#0											
		streq	r3,	[r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0
		mov		pc, lr

@writes a bit to the SNES clock line
Write_Clock:
		
		mov		r1,	r0											@Copy of val passed
		mov		r0, #11											@pin 11 = clock line
		ldr		r2,	=gpioBaseAddress							@base GPIO reg
		ldr		r2, [r2]										
		mov 	r3,	#1										
		lsl		r3,	r0											@ align bit for pin#11
		teq 	r1,	#0
		streq	r3, [r2, #40]									@ GPCLR0
		strne	r3,	[r2, #28]									@ GPSET0
		mov		pc, lr

@reads a bit from the SNES data line
Read_Data:
		mov		r0,	#10											@Pin10 = Data line
		ldr		r1,	=gpioBaseAddress							@base GPIO reg
		ldr		r1, [r1]
		ldr		r2,	[r1, #52]									@ GPLEV 0
		mov		r3,	#1
		lsl		r3,	r0											@ align bit for pin#10
		and		r2,	r3											@ mask everything else
		teq		r2,	#0
		moveq	r0,	#0											@ return 0
		movne	r0,	#1											@ return 1
		mov		pc, lr
		
@main SNES subroutine that reads input(buttons pressed) from a SNES controller. Returns the code of a pressed button in a register
Read_SNES:
		push 	{r5, r6, lr}
		mov		r6,	#0										@register sampling buttons
		mov		r0,	#1										@Write 1 to clk
		bl		Write_Clock								
		mov		r0,	#1										@write 1 to lat
		bl		Write_Latch
		mov		r0,	#12										@delay 12 us
		bl		delayMicroseconds
		mov		r0,	#0										@write 0 to lat
		bl		Write_Latch
		mov		r5,	#0										@r5 = i

pulseLoop:	
		mov		r0,	#6										@Delay 6 us
		bl		delayMicroseconds
		mov		r0,	#0										@write 0 to clk
		bl		Write_Clock
		mov		r0,	#6										@delay 6 us
		bl		delayMicroseconds
		bl		Read_Data									@read bit 
		lsl		r6, #1										
		orr		r6, r0										@buttons[i] = b
		mov		r0,	#1										@write 1 to clk
		bl		Write_Clock
		add		r5,	r5,	#1									@i++
		cmp		r5,	#16										@if i<16 branch pulseLoop
		blt		pulseLoop
		mov		r0,	r6										@returning r6
		pop		{r5, r6, pc}

@PrintStatements: According to button pressed
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
gpioBaseAddress:
.int		0
names:
.asciz	"Created by: Daniel Nwaroh, Issack John and Steve Khanna\n"
pressButton:
.asciz	"Please press a button ...\n"
butB:
.asciz	"\nYou have pressed B\n\n"
butY:
.asciz	"\nYou have pressed Y\n\n"
butSelect:
.asciz	"\nYou have pressed select\n\n"
butUp:
.asciz	"\nYou have pressed Joy-pad UP\n\n"
butDown:
.asciz	"\nYou have pressed Joy-pad DOWN\n\n"
butLeft:
.asciz	"\nYou have pressed Joy-pad LEFT\n\n"
butRight:
.asciz	"\nYou have pressed Joy-pad RIGHT\n\n"
butA:
.asciz	"\nYou have pressed A\n\n"
butX:
.asciz	"\nYou have pressed X\n\n"
butLb:
.asciz	"\nYou have pressed LEFT BUMPER\n\n"
butRb:
.asciz	"\nYou have pressed RIGHT BUMPER\n\n"
end:
.asciz 	"\nProgram is terminating...\n\n"
