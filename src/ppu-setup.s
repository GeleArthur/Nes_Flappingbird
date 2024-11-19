.proc SetPallet
    PPU_SETADDR $3f00
    ldy #$0
@loop:
    lda default_palette, Y
    sta PPU_DATA
    iny
    cpy #32
    bne @loop
    rts
.endproc

; We write 255 to all the x postions in the OAM. This way they are off screen. 
; Would it be better to do it in the Y?
.proc HideAllAOMSprites
    lda #255
    ldx #0
@loop:
    sta oam, x
    inx
    inx
    inx
    inx
    bne @loop

    rts
.endproc


.segment "RODATA"
default_palette:
.byte $1c ; background color. If you change this also change the mirrored background color
.byte $11,$26,$37 ; bg0 purple/pink
.byte $0F,$09,$19,$29 ; bg1 green
.byte $0F,$01,$11,$21 ; bg2 blue
.byte $0F,$00,$10,$30 ; bg3 greyscale

.byte $1c ; mirrored background color. 
.byte $18,$28,$38 ; sp0 yellow
.byte $0F,$14,$24,$34 ; sp1 purple
.byte $0F,$1B,$2B,$3B ; sp2 teal
.byte $0F,$12,$22,$1c ; sp3 marine