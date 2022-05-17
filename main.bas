#picaxe 18m2

init:
	bsf STATUS, RP0 ; Moves to bank 1
	call initPortsB ; Initialise Port B
	call initInterrupt ; Setup the interrupts
	call main ; "Entry Point"
	
initPortsB:
	movlw b'00001111' ; Sets B0-B3 to Input ; Sets B4-B7 as output
	movwf TRISB 
	bcf STATUS, RP0
	return
	
initInterrupt:
	W_SAVE equ B20 ; B20 should be reserved for the W_SAVE
	COUNTER equ b27 ; Set the counter (i) = 0 ; Used in interrupt looping
	bsf INTCON, INT0IE ; Enable external interrupt
	bsf INTCON, GIE ; Enable global interrupts
	return
	
main:
	bcf STATUS, RP0 ; Move to bank 0
	btfss TRISB, 0 ; If port B0
	call bassPulse
	btfss TRISB, 1 ; If port B1
	call snarePulse
	btfss TRISB, 2 ; If port B2
	call floorTomPulse
	btfss TRISB, 3 ; If port B3
	call highTomPulse
	goto main
end

bassPulse: ; Pulses the bass drum 4 times
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
		btfss BASS_COUNTER, 3 ; Change this bit to change how many pulses
		; If the counter is not done
		goto bassPulseLoop
		; If the counter is done
		nop
	return		

		
snarePulse: ; Pulse the snare once
	bsf STATUS, RP0 ; Move to bank 1
	bsf PORTB, 5
	call wait10ms
	bcf PORTB, 5
	return
	
floorTomPulse: ; Pulse the floor tom once
	bsf STATUS, RP0 ; Move to bank 1
	bsf PORTB, 6
	call wait10ms
	bcf PORTB, 6
	return
	
highTomPulse: ; Pulse the high tom once
	bsf STATUS, RP0 ; Move to bank 1
	bsf PORTB, 7
	call wait10ms
	bcf PORTB, 7
	return
	
end

resetBits:
	bcf PORTB, 4
	bcf PORTB, 5
	bcf PORTB, 6
	bcf PORTB, 7
	return
	
interrupt: ; A.7 = external interrupt
	movwf W_SAVE ; Backup working register
	btfss INTCON, INT0IF ; Check the correct interrupt has occured
				   ; If it did, then the next instruction will be skipped
	retfie ; Return and enable Global Interrupt Register
	
	; Reset the state of the bits
	call resetBits
	
	; Handle the interrupt
	bsf STATUS, RP0 ; Move to bank 0
	
	; Test A.0
	btfss PORTA, 0
	goto serialFlash
	goto allFlash
	
end
	
	
	
	; Flash the LEDs
	;TODO: Refactor
	serialFlash: 
			movlw b'00000000'
			movwf COUNTER
			
			serialFlashLoop: 
				bsf PORTB, 4
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
				btfss COUNTER, 5 ; If the loop has iterated 16 times ; CHANGE THIS TO BE 16 BEFORE HAND IN
				goto serialFlashLoop
				return
				 
		; Ran at the end to reset the interrupt 
		movf W_SAVE, W ; Move the saved values back into the working register
		retfie ; Return and enable Global Interrupt Register
		
	
	; Flashes all LEDS at once
	allFlash:
		movlw b'00000000'
		movwf COUNTER
		
		allFlashLoop:
			; Set all output bits
			bsf PORTB, 4
			bsf PORTB, 5
			bsf PORTB, 6
			bsf PORTB, 7
			call wait10ms
			
			incf COUNTER, 1 ; increment file register to itself
			btfss COUNTER, 4 ; If the loop has iterated 8 times ; CHANGE THIS TO BE 8 BEFORE HAND IN
			goto allFlashLoop
			return
			
	; Ran at the end to reset the interrupt 
	movf W_SAVE, W ; Move the saved values back into the working register
	retfie ; Return and enable Global Interrupt Register

end
