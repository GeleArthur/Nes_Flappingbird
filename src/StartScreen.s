.segment "ZEROPAGE"

Have_Players_Pressed_A: .res 1


.macro  CheckForA gamepad, plyrBit
.scope
    lda gamepad   
    and #PAD_A      
    beq End
    lda plyrBit
    ora Have_Players_Pressed_A ;flip Have_Players_Pressed_A to true for p1 (0000 0001) -> flips this one
    sta Have_Players_Pressed_A 

    End:
.endscope
.endmacro

.macro UpdateOrJumpingPlyr player, playerOAM , gamepad ,paletteIndex , XOffset, plyrBitMask
.scope
    lda Have_Players_Pressed_A
    and plyrBitMask
    bne UpdatePlayer
    SETUP_PLAYER player, playerOAM, paletteIndex, XOffset
    SET_XY player,playerOAM

    jmp End
    UpdatePlayer:
    UPDATE_PLAYER player, playerOAM, gamepad, plyrBitMask
    End:

.endscope
.endmacro

.segment "CODE"
.proc StartScreen
    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL
    
    lda #CTRL_NMI
    sta PPU_CTRL

    WAIT_UNITL_FRAME_HAS_RENDERED

    lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI | CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

    jsr audio_init
    jsr audio_title_screen


StayInStartScreen:
    jsr famistudio_update
    jsr GamepadPoll
    
    inc nmi_ready
    @waitVBlank2:
        lda nmi_ready
    bne @waitVBlank2 ; If nmi_ready == 1 -> wait    

    jsr UpdateOrJumpingPlyrs
  
    jsr CheckForPlayersPressingA

    lda Have_Players_Pressed_A
    cmp #%00001111  
    bne StayInStartScreen


    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL
    
    ; CALL TO pauseGame.s :(
    ;lda #1
    ;sta game_is_paused

    rts

.endproc

.proc UpdateOrJumpingPlyrs

    UpdateOrJumpingPlyr player1,PLAYER_1, gamepad_1, #$00, #$0 , #%00000001
    UpdateOrJumpingPlyr player2,PLAYER_2, gamepad_2, #$01, #$10, #%00000010
    UpdateOrJumpingPlyr player3,PLAYER_3, gamepad_3, #$02, #$20, #%00000100
    UpdateOrJumpingPlyr player4,PLAYER_4, gamepad_4, #$03, #$30, #%00001000

.endproc

.proc CheckForPlayersPressingA

    CheckForA gamepad_1,#%00000001
    CheckForA gamepad_2,#%00000010
    CheckForA gamepad_3,#%00000100
    CheckForA gamepad_4,#%00001000

.endproc
