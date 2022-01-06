// to compile: g++ traffic_lights.s -lwiringPi -g -o traffic_lights

.equ INPUT, 0
.equ OUTPUT, 1
.equ LOW, 0
.equ HIGH, 1
.equ RED_PIN, 3		// wiringPi 3, physical 11
.equ GRN_PIN, 0		// wiringPi 0, physical 15
.equ YLW_PIN, 2		// wiringPi 2 physical 13
.equ WALK_PIN, 23	// wiringPi 23, physical 33
.equ STOP_PIN, 25	// wiringPi 25, physical 37
.equ START_PIN, 29	// wiringPi 24, physical 35

.text
.global main
main:
	//setting pins to their correct modes
	push {lr}
	bl wiringPiSetup

	mov r0, #RED_PIN
	bl setPinOutput	

	mov r0, #YLW_PIN
	bl setPinOutput

	mov r0, #GRN_PIN
	bl setPinOutput

	mov r0, #WALK_PIN
	bl setPinOutput

	mov r0, #STOP_PIN
	bl setPinOutput

	mov r0, #START_PIN
	bl setPinInput
	
//Allows user to have time to press button after run begins
whl_loop:
	//Reads input from button
	mov r0, #START_PIN
	bl readStartButton 

	//Branches to start the lights
	cmp r0,#HIGH
	beq lightsStart

	//Sends program back to beginning to check if pressed
	cmp r0, #LOW
	beq whl_loop
	
	
		

setPinInput:
	push {lr}
	mov r1, #INPUT
	bl pinMode
	pop {pc}

setPinOutput:
	push {lr}
	mov r1, #OUTPUT
	bl pinMode
	pop {pc}

pinOn:
	push {lr}
	mov r1, #HIGH
	bl digitalWrite
	pop {pc}

pinOff:
	push {lr}
	mov r1, #LOW
	bl digitalWrite
	pop {pc}

readStartButton:
	push {lr}
	mov r3, #START_PIN
	bl digitalRead
	pop {pc}

lightsStart:
	push {lr}

	//Begins allow user to cross
	mov r0, #RED_PIN
	bl pinOn

	mov r0, #WALK_PIN
	bl pinOn

	ldr r0, =#10000
	bl delay
	
	//Turns off red light
	mov r0, #RED_PIN
	bl pinOff

	mov r0, #WALK_PIN
	bl pinOff

	ldr r0, =#500
	bl delay
	
	//Lights begin blinking
	mov r0, #WALK_PIN
	bl pinOn

	mov r0, #YLW_PIN
	bl pinOn

	ldr r0, =#500
	bl delay

	mov r0, #WALK_PIN
	bl pinOff

	mov r0, #YLW_PIN
	bl pinOff

	ldr r0, =#500
	bl delay

	mov r0, #WALK_PIN
	bl pinOn

	mov r0, #YLW_PIN
	bl pinOn
	
	ldr r0, =#500
	bl delay

	mov r0, #WALK_PIN
	bl pinOff

	mov r0, #YLW_PIN
	bl pinOff
	
	//Lights have stopped blinking
	mov r0, #GRN_PIN
	bl pinOn

	mov r0, #STOP_PIN
	bl pinOn

	ldr r0, =#10000
	bl delay
	
	//Program ends
	mov r0, #GRN_PIN
	bl pinOff

	mov r0, #STOP_PIN
	bl pinOff

	pop {pc}


