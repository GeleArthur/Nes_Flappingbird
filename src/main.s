.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

.include "header.s"
.include "vectors.s"
.include "zeropage.s"
.include "nmi-vblank.s"
.include "ppu-setup.s"


.segment "OAM"
oam: .res 256 

.segment "CODE"
.proc reset
    NES_INIT ; Disables everything and default setup stuff
    jsr WaitSync
    jsr ClearRam
    jsr WaitSync

	lda #$3f	; $3F -> A register
    sta PPU_ADDR	; write high byte first
	lda #$00	; $00 -> A register
    sta PPU_ADDR    ; $3F00 -> PPU address
    lda #$1c	; $1C = light blue color
    sta PPU_DATA    ; $1C -> PPU data

    jsr SetPallet


    lda #MASK_BG|MASK_SPR
    sta PPU_MASK
    lda CTRL_NMI
    sta PPU_CTRL ; Enable NMI

    jmp main
.endproc

.proc main
mainloop:
    WAIT_UNITL_FRAME_HAS_RENDERED

    


    lda #1 ; Done calulating the frame 
    sta nmi_ready
    jmp mainloop

.endproc




.segment "TILES"
.incbin "../assets/texture.chr"