.proc SetPallet
    PPU_SETADDR $3f00
    ldy $0
@loop:
    lda default_palette, Y
    sta PPU_DATA
    iny
    cpy #32
    bne @loop
.endproc


.segment "RODATA"
default_palette:
.byte $3c,$15,$26,$37 ; bg0 purple/pink
.byte $0F,$09,$19,$29 ; bg1 green
.byte $0F,$01,$11,$21 ; bg2 blue
.byte $0F,$00,$10,$30 ; bg3 greyscale
.byte $0F,$18,$28,$38 ; sp0 yellow
.byte $0F,$14,$24,$34 ; sp1 purple
.byte $0F,$1B,$2B,$3B ; sp2 teal
.byte $0F,$12,$22,$32 ; sp3 marine