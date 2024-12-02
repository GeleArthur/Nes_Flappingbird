.segment "ZEROPAGE"
gamepad_1_prev: .byte 0
game_is_paused: .byte 0

.segment "CODE"


.proc PauseGameCheck
    jsr GamepadPoll
    
    lda gamepad_1
    and #PAD_START
    beq isGameStilPaused ; end
    lda gamepad_1_prev
    and #PAD_START
    bne isGameStilPaused
    
    lda game_is_paused
    eor #%00000001
    sta game_is_paused

isGameStilPaused:
    lda gamepad_1
    sta gamepad_1_prev

    lda game_is_paused
    bne PauseGameCheck

    rts

.endproc