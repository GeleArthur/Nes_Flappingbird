.segment "CODE"
.proc StartScreen
    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL
    
    lda #CTRL_NMI
    sta PPU_CTRL

    WAIT_UNITL_FRAME_HAS_RENDERED

    lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI | CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

@StayInStartScreen:
    jsr GamepadPoll

    lda gamepad_1
    and #%00010000
    beq @StayInStartScreen


    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL
    
    ; CALL TO pauseGame.s :(
    lda #1
    sta game_is_paused

    rts

.endproc