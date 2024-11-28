.segment "ZEROPAGE"

; We use a ForScore NES
gamepad_1:		.res 1 ; Controller 1
gamepad_2:		.res 1 ; Controller 2
gamepad_3:		.res 1 ; Controller 3
gamepad_4:		.res 1 ; Controller 4

.segment "CODE"
.proc GamepadPoll
	lda #$01
	sta JOYPAD1
	sta JOYPAD2
	sta gamepad_1

	lda #$00
	sta JOYPAD1
	sta JOYPAD2
	clc

	ldx #8
	loop1:
		lda JOYPAD1
		lsr a
		rol gamepad_1

		lda JOYPAD2
		lsr
		rol gamepad_2

		dex
		bne loop1

	ldx #8
	loop2:
		lda JOYPAD1
		lsr a
		rol gamepad_3

		lda JOYPAD2
		lsr
		rol gamepad_4

		dex
		bne loop2


    rts
.endproc