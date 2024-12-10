.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

.include "setup/header.s"
.include "setup/vectors.s"
.include "setup/nmi-vblank.s"
.include "setup/ppu-setup.s"

.segment "TILES"
.incbin "../assets/texture.chr"

.include "controllers.s"
.include "../assets/nametable01.s"
.include "background.s"
.include "playerController.s"
.include "failstate.s"
.include "pipes.s"
.include "startScreen.s"
.include "pauseGame.s"

.include "audio.s"
.segment "CODE"


.proc reset
    NES_INIT ; Setup nes
    
    jsr StartScreen

    ; Setup player lives
    lda #%00001111
    sta playerDeathStates

    jsr SetupPlayer1
    jsr SetupPlayer2
    jsr SetupPlayer3
    jsr SetupPlayer4

    jsr SetupBackground
    
    jsr audio_main_game

    lda #CTRL_NMI
    sta PPU_CTRL ; Enable NMI.

    WAIT_UNITL_FRAME_HAS_RENDERED ; We are done rendering lets wait for the ppu to be at the vblank before we start rendering

    lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI|CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

    jmp Main
.endproc

.proc Main

    jsr GamepadPoll

    jsr HandlePlayer1
    jsr HandlePlayer2
    jsr HandlePlayer3
    jsr HandlePlayer4

    ;jsr CollisionPlayer1
    ;jsr CollisionPlayer2
    ;jsr CollisionPlayer3
    ;jsr CollisionPlayer4
    jsr ScrollBackground

    jsr PauseGameCheck
    jsr EndOfGame
    jsr famistudio_update


    WAIT_UNITL_FRAME_HAS_RENDERED
    jmp Main
.endproc

