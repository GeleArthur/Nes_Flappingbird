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
    jsr HideAllAOMSprites ; All of these could be macros

    lda #MASK_SPR ;| MASK_BG
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI|CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

    OAM_WRITE_X 0, #100
    OAM_WRITE_Y 0, #100
    OAM_WRITE_TILE 0, #1


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