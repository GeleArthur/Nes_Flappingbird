.segment "CODE"
.macro STARTSCREEN

    
    

    lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI|CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

@StayInStartScreen:
    jsr GamepadPoll

    lda gamepad_1
    and #%00010000
    beq @StayInStartScreen



    lda #0
    sta PPU_MASK ; Enable sprite and background rendering
    lda #0
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

.endmacro