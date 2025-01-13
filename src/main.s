.include "helpers/definitions.s"
.include "helpers/macros.s"
.include "helpers/subroutines.s"

.include "../assets/nametableStartscreen.s"

.include "setup/header.s"
.include "setup/vectors.s"
.include "setup/nmi-vblank.s"
.include "setup/ppu-setup.s"

.segment "TILES"
.incbin "../assets/texture.chr"

.include "controllers.s"
.include "background.s"
.include "playerController.s"
.include "failstate.s"
.include "collision.s"
.include "startScreen.s"
.include "pauseGame.s"
.include "nametableSelector.s"

.include "audio.s"

.segment "CODE"
.proc sharedReset

    ; Setup background pointers
    jsr InitNameTableSelector
    
    ; Set all players alive
    lda #%00001111
    sta playerDeathStates
    jsr SetupScore

    jsr StartScreen ;only do this after setting up players deaths

    ; Disable rendering
    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL

    jsr audio_main_game

    ; Setup NMI
    lda #CTRL_NMI
    sta PPU_CTRL ; Enable NMI.

    WAIT_UNITL_FRAME_HAS_RENDERED ; We are done rendering lets wait for the ppu to be at the vblank before we start rendering

    ; Enable rendering again
    lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI|CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

    jsr PositionScore_Game
    jmp Main
.endproc

.proc reset
    NES_INIT ; Setup nes
    jsr sharedReset
.endproc

.proc GameEnded
    NES_INIT_END_OF_GAME ; Setup nes
    jsr sharedReset
.endproc

.proc Main

    jsr GamepadPoll

    jsr ShowScore

    jsr HandlePlayer1
    jsr HandlePlayer2
    jsr HandlePlayer3
    jsr HandlePlayer4

    jsr CollisionPlayer1
    jsr CollisionPlayer2
    jsr CollisionPlayer3
    jsr CollisionPlayer4

    jsr ScrollBackground

    jsr PauseGameCheck
    jsr EndOfGame
    jsr famistudio_update


    WAIT_UNITL_FRAME_HAS_RENDERED
    jmp Main
.endproc

