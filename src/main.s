.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

.include "setup/header.s"
.include "setup/vectors.s"
.include "setup/zeropage.s"
.include "setup/nmi-vblank.s"
.include "setup/ppu-setup.s"

.segment "CODE"
.proc reset
    NES_INIT ; Setup nes

    ; INIT GAME CODE
    OAM_WRITE_X 0, #100
    OAM_WRITE_Y 0, #100
    OAM_WRITE_TILE 0, #1

    jmp main
.endproc

.proc main
mainloop:
    ; MAIN LOOP

    

    WAIT_UNITL_FRAME_HAS_RENDERED
    jmp mainloop
.endproc


.segment "TILES"
.incbin "../assets/texture.chr"