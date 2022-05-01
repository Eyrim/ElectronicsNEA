#picaxe 18m2 ; The type of chip
; setfreq mN ; Sets the clock speed (m = mega)
setfreq m32

init:
	gosub configureADC
	gosub configureMaths
	gosub main
	
configureADC:
	adcconfig %000
	return
	
configureMaths:
	;symbol PI = 

main:
	;gosub setSineSymbols
	;gosub generateSineWave
	
;===============================================;
; 			Subroutines to 			;
; 			Generate a wave to		;
;			Light up various			;
; 			Parts of the kit			;
;===============================================;
; Sine stuff not going to work
; Need decimals
; Sawtoth Stuff
{
setSawtoothSymbols:
	symbol INCREMENT = b0
	let INCREMENT = 1
	
	symbol X_VALUE_DEF = b2
	let X_VALUE_DEF = 0
	;symbol X_VALUE_OVER = b3
	;let X_VALUE_OVER = 0
	
	symbol Y_VALUE_DEF = b4
	let Y_VALUE_DEF = 0
	;symbol Y_VALUE_OVER = b5
	;let Y_VALUE_OVER = 0
	
	symbol LOOP_INDEX = b6
	let LOOP_INDEX = 0
	
	symbol LOOP_JINDEX = b7
	let LOOP_JINDEX = 0
	
	symbol NUMBER_OF_WAVES = b8
	let NUMBER_OF_WAVES = 5
}
generateSawtoothWaveRefac:
	do
		{
		do
			{
			let X_VALUE_DEF = X_VALUE_DEF + INCREMENT
			let Y_VALUE_DEF = Y_VALUE_DEF + INCREMENT
			
			inc LOOP_JINDEX
			
			;wait 5
			}
		loop until LOOP_JINDEX = 255
		}
		
		let X_VALUE_DEF = 0
		let Y_VALUE_DEF = 0
	loop until NUMBER_OF_WAVES =  LOOP_INDEX

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