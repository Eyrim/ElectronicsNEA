#picaxe 18m2 ; The type of chip
; setfreq mN ; Sets the clock speed (m = mega)

init:
	gosub configureADC
	gosub configureMaths
	gosub main
	
configureADC:
	adcconfig %000
	return
	
configureMaths:
	symbol PI = 

main:
	gosub setSineSymbols
	gosub generateSineWave
	
;===============================================;
; 			Subroutines to 			;
; 			Generate a wave to		;
;			Light up various			;
; 			Parts of the kit			;
;===============================================;
;Sine Stuff
{
setSineSymbols:
	symbol AMPLITUDE = b0
	let b0 = 5 ; The amplitude of the wave is now 5
	symbol FREQUENCY = b1
	let b1 = 5 / 10 ; The frequency of the wave is now 0.5
	symbol PHASE = b2
	let b2 = 0 ; The phase of the wave is now 0 (It's in phase with itself)
	symbol Y_VALUE = b3
	

generateSineWave:
	let Y_VALUE = 
}


;===============================================;
; 			Subroutines to 			;
; 			Light up various 			;
; 			Parts of the kit			;
;===============================================;
{
lightUpBass:
	return;
	
lightUpSnare:
	return;
	
lightUpHighTom:
	return;
	
lightUpFloorTom:
	return;
}