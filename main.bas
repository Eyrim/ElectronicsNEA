#picaxe 18m2

init:
	bsf STATUS, RP0 ; Moves to bank 1
	call initPortsB ; Initialise Port B
	call initInterrupt ; Setup the interrupts
	call main ; "Entry Point"
	
initPortsB:
	movlw b'00001111' ; Sets B0-B3 to Input
	movwf TRISB ; Sets B4-B7
	bcf STATUS, RP0
	return
	
initInterrupt:
	W_SAVE equ B20 ; B20 should be reserved for the W_SAVE
	bsf INTCON, INT0IE ; Enable external interrupt
	bsf INTCON, GIE ; Enable global interrupts
	return
	
main:
	call bassPulse

bassPulse:
	BASS_COUNTER equ b19
	movlw b'00000100'
	movwf BASS_COUNTER
	
	bassPulseLoop:
		; Strobe the bass drum light (PORTB.3)
		bsf PORTB, 4 ; Turn it on
		call wait100ms ; Wait (to produce strobe effect)
		bcf PORTB, 4 ; Turn it off
	
		; Increment the counter
		incf BASS_COUNTER, 1
		; Test the counter
		btfss BASS_COUNTER, 3
		; If the counter is not done
		goto bassPulseLoop
		; If the counter is done
		return
	
end

interrupt:
	nop
end

interruptTest: ; A.7 = external interrupt
	;movwf W_SAVE ; Backup working register
	;btfss INTCON, INT0IF ; Check the correct interrupt has occured
				   ; If it did, then the next instruction will be skipped
	;retfie ; Return and enable Global Interrupt Register
	
	; Handle the interrupt
	bsf STATUS, RP0 ; Move to bank 0
	; Flash the LEDs
	;TODO: Refactor
	COUNTER equ b27 ; Set the counter (i) = 0
	movlw b'00000001'
	movwf COUNTER
	
	loop1: bsf PORTB, 4
		 call wait10ms
		 bsf PORTB, 5
		 call wait10ms
		 bcf PORTB, 4
		 call wait10ms
		 bsf PORTB, 6
		 call wait10ms
		 bcf PORTB, 5
		 call wait10ms
		 bsf PORTB, 7
		 call wait10ms
		 bcf PORTB, 6
		 call wait10ms
		 bcf PORTB, 7
		 call wait10ms
		 incf COUNTER, 1 ; increment the file register to itself
		 btfss COUNTER, 1 ; If the loop has iterated 16 times
		 goto loop1
		 return
	
	; Ran at the end to reset the interrupt 
	movf W_SAVE, W ; Move the saved values back into the working register
	retfie ; Return and enable Global Interrupt Register
	
