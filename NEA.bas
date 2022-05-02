#picaxe 18m2 ; The type of chip
setfreq m4 ; Sets clock speed to 4MHz

init:
	gosub configureADC
	gosub configureInputs
	gosub configureOutputs
	gosub setupInterrupt
	gosub main
	
configureInputs:
	input C.4
	input C.5
	input C.6
	input C.7
	return
	
configureOutputs:
	output C.0
	output C.1
	output C.2
	output C.3
	return
	
configureADC:
	adcconfig %000
	return

main:
	goto main
	
;===============================================;
; 			Subroutines to 			;
; 			Generate a wave to		;
;			Light up various			;
; 			Parts of the kit			;
;===============================================;
; Sine stuff not going to work
; Need floats
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

generateSawtoothWave:
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
}

;Linear Wave Stuff
{
setLinearSymbols:
	;output C.0
	;output C.1
	;output C.2
	;output C.3
	symbol LED0 = C.0
	symbol LED1 = C.1
	symbol LED2 = C.2
	symbol LED3 = C.3
	symbol NUMBER_OF_LINEAR_WAVES = b0
	let b0 = 5
	symbol LOOP_INDEX_LINEAR = b1
	let b1 = 0

generateLinearWave:
	do
		{
		high LED0
		low LED0
		
		high LED1
		low LED1
		
		high LED2
		low LED2
		
		high LED3
		low LED3
		
		inc LOOP_INDEX_LINEAR
		}
	loop until LOOP_INDEX_LINEAR = NUMBER_OF_LINEAR_WAVES
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

end

;===============================================;
; 			Subroutines to 			;
;			Handle Interrupts			;
;===============================================;
{
interrupt:
	if input0 = %1 then
		if input1 = %0 then
			gosub setSawtoothSymbols
			gosub generateSawtoothWave
		endif
	endif

	if input1 = %1 then
		if input0 = %0 then
			gosub setLinearSymbols
			gosub generateLinearWave
		endif
	endif
	

	if input4 = %1 then
		gosub lightUpBass
		
	endif
	
	if input5 = %1 then
		gosub lightUpSnare
		
	endif

	if input6 = %1 then
		gosub lightUpHighTom
		
	endif

	if input7 = %1 then
		gosub lightUpFloorTom
	endif

	gosub setupInterrupt ; Re-enable the interrupt
	return
	
setupInterrupt:
	setint and %11110011, %11110011
	return
}




















