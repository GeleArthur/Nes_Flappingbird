.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

.include "setup/header.s"
.include "setup/vectors.s"
.include "setup/zeropage.s"
.include "setup/nmi-vblank.s"
.include "setup/ppu-setup.s"

.segment "TILES"
.incbin "../assets/texture.chr"


.include "../assets/nametable01.s"
.include "background.s"
.include "playerInput.s"


.segment "CODE"
.proc reset
    NES_INIT ; Setup nes

    ; INIT GAME CODE
    OAM_WRITE_X 0, #100
    OAM_WRITE_Y 0, #100
    OAM_WRITE_TILE 0, #1

    lda #180
    sta p1_x

    lda #120
    sta p1_y


    jsr setup_player_1
    jsr setup_player_2
    jsr setup_player_3
    jsr setup_player_4

    jsr setup_background


    jmp main
.endproc

.proc main

    jsr gamepad_poll

    jsr update_player_1
    jsr update_player_2
    jsr update_player_3
    jsr update_player_4

    jsr scroll_background

    WAIT_UNITL_FRAME_HAS_RENDERED
    jmp main
.endproc

