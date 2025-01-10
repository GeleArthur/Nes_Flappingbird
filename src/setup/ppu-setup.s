.macro NES_INIT
    sei ; disable interrupt as its never used.
    cld ; disable decible mode

    ldx #$FF
    txs ; Make sure stack pointer starts at FF

    inx ; increment x by 1 so it becomes $00
    stx PPU_CTRL ; disable V in NMI
    stx PPU_MASK ; Disable rendering
    ;stx DMC_FREQ ; Mute APU



    jsr WaitSync ; wait 
    jsr ClearRam
    jsr WaitSync
    jsr CopyPallet
    jsr HideAllAOMSprites ; All of these could be macros
    jsr ClearNameTableAndAttribute

.endmacro

.macro NES_INIT_END_OF_GAME
    sei ; disable interrupt as its never used.
    cld ; disable decible mode

    ldx #$FF
    txs ; Make sure stack pointer starts at FF

    inx ; increment x by 1 so it becomes $00
    stx PPU_CTRL ; disable V in NMI
    stx PPU_MASK ; Disable rendering
    ;stx DMC_FREQ ; Mute APU



    jsr WaitSync ; wait 
    jsr ClearRam_EndOfGame
    jsr WaitSync
    jsr CopyPallet
    jsr HideAllAOMSprites ; All of these could be macros
    jsr ClearNameTableAndAttribute

.endmacro



; We write 255 to all the x postions in the OAM. This way they are off screen. 
; Would it be better to do it in the Y? as then we also dont have scanline issues????
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

.proc CopyPallet
    PPU_SETADDR $3f00 ; Replace with pallet define
    ldy #$0
@loop:
    lda default_palette, Y
    sta PPU_DATA
    iny
    cpy #32
    bne @loop
    rts
.endproc

.segment "RODATA"
default_palette:
.byte $21 ; background color. If you change this also change the mirrored background color
.byte $29,$1A,$0F ; bg0 purple/pink
.byte $0F,$0C,$21,$32 ; bg1 green
.byte $0F,$29,$16,$27 ; bg2 blue
.byte $0F,$30,$2D,$29 ; bg3 greyscale

.byte $21 ; mirrored background color. 
.byte $18,$28,$38 ; sp0 yellow
.byte $0F,$14,$24,$34 ; sp1 purple
.byte $0F,$1B,$2B,$3B ; sp2 teal
.byte $0F,$12,$22,$1c ; sp3 marine


; CLears the first nametable + attribute
.segment "CODE"
.proc ClearNameTableAndAttribute
    PPU_SETADDR $2000

 	; empty nametable
 	lda #0
 	ldy #30 ; clear 30 rows
 	rowloop:
 		ldx #32 ; 32 columns
 		columnloop:
 			sta PPU_DATA
 			dex
 			bne columnloop
 		dey
 		bne rowloop

 	; empty attribute table
 	ldx #64 ; attribute table is 64 bytes
 	loop:
 		sta PPU_DATA
 		dex
 		bne loop
 	rts
 .endproc

; .proc TurnOffPPU
;     lda <PPU_MASK_VAR
;     and #%11100111
;     sta <PPU_MASK_VAR
;     jmp _ppu_wait_nmi
; .endproc