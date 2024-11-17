.include "header.s"
.include "vectors.s"
.include "zeropage.s"
.include "interrupt.s"
.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

;*****************************************************************
; Sprite OAM Data area - copied to VRAM in NMI routine
;*****************************************************************
.segment "OAM"
oam: .res 256 

; Why is this here????? we copy it from the ram anyway?
.segment "BSS"
palette: .res 32 ; Current palette

.segment "CODE"

.proc reset
    NES_INIT ; Disables everything and default setup stuff
    jmp WaitVBlank
    jmp ClearRam
    jmp ClearOAM
    jmp WaitVBlank
    

    ; NES is initialized and ready to begin
	; - enable the NMI for graphical updates and jump to our main program
    lda CTRL_NMI
    sta PPU_CTRL ; Enable NMI
    jmp main
.endproc


.proc main
mainloop:
 	; skip reading controls if and change has not been drawn
 	; lda nmi_ready
 	; cmp #0
 	; bne mainloop

    ; ; ensure our changes are rendered
    ; lda #1
    ; sta nmi_ready
    jmp mainloop

.endproc


.segment "RODATA"
default_palette:
.byte $0F,$15,$26,$37 ; bg0 purple/pink
.byte $0F,$09,$19,$29 ; bg1 green
.byte $0F,$01,$11,$21 ; bg2 blue
.byte $0F,$00,$10,$30 ; bg3 greyscale
.byte $0F,$18,$28,$38 ; sp0 yellow
.byte $0F,$14,$24,$34 ; sp1 purple
.byte $0F,$1B,$2B,$3B ; sp2 teal
.byte $0F,$12,$22,$32 ; sp3 marine

.segment "TILES"
.incbin "../assets/texture.chr"