.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

.include "header.s"
.include "vectors.s"
.include "zeropage.s"
.include "nmi-vblank.s"
.include "ppu-setup.s"

.segment "CODE"
.proc reset
    NES_INIT ; Disables everything and default setup stuff
    jsr WaitSync
    jsr ClearRam
    jsr WaitSync
    jsr SetPallet


    lda #MASK_BG|MASK_SPR
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI
    sta PPU_CTRL ; Enable NMI

    jmp main
.endproc

.proc main
mainloop:
    WAIT_UNITL_FRAME_HAS_RENDERED

    ldx #$01
    stx WTF
    lda WTF

    ldx #$00
    stx WTF
    lda WTF


    lda #1 ; Done calulating the frame 
    sta nmi_ready
    jmp mainloop

.endproc




.segment "TILES"
.incbin "../assets/texture.chr"