.segment "ZEROPAGE"

; We use a ForScore NES
gamepad1:		.res 1 ; Controller 1
gamepad2:		.res 1 ; Controller 2
gamepad3:		.res 1 ; Controller 3
gamepad4:		.res 1 ; Controlelr 4

.segment "CODE"
.proc gamepad_poll
	lda #$01
	sta JOYPAD1
	sta JOYPAD2
	sta gamepad1

	lda #$00
	sta JOYPAD1
	sta JOYPAD2

	ldx #8
	loop1:
		lda JOYPAD1
		lsr a
		rol gamepad1

		lda JOYPAD2
		lsr
		rol gamepad2

		dex
		bne loop1

	ldx #8
	loop2:
		lda JOYPAD1
		lsr a
		rol gamepad3

		lda JOYPAD2
		lsr
		rol gamepad4

		dex
		bne loop2


    rts
.endproc