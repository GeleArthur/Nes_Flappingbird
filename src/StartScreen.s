.segment "ZEROPAGE"

Have_Players_Pressed_A: .res 1
Player_Jmp_Counter: .res 1


.macro  CheckForA gamepad, plyrBit
.scope
    lda gamepad   
    and #PAD_A      
    beq End
    lda plyrBit
    ora Have_Players_Pressed_A ;flip Have_Players_Pressed_A to true for plyr (plyrbitmask) -> flips this one
    sta Have_Players_Pressed_A 

    End:
.endscope
.endmacro

.macro UpdateOrJumpingPlyr player, playerOAM , gamepad , plyrBitMask , jmpOffset
.scope
    lda Have_Players_Pressed_A
    and plyrBitMask
    bne UpdatePlayer
    ;replace with a simple jumping loop
    PlyrJumping player, jmpOffset
    SET_XY player,playerOAM

    jmp End
    UpdatePlayer:
    UPDATE_PLAYER player, playerOAM, gamepad, plyrBitMask
    End:

.endscope
.endmacro

.macro PlyrJumping player, offset
.scope

    lda Player_Jmp_Counter
    cmp #$24
    bpl DontJump ; if greater than $04 than go down
    ADD_Y #$02, player
    jmp Increment

    DontJump:
    cmp #$47 ; if 41 reset the counter to 0 else go down
    beq ResetCounter
    ADD_Y #$01, player
    SUB_Y #$00, player
    jmp Increment


    Increment:
    inc Player_Jmp_Counter
    jmp End

    ResetCounter:
    lda #$0
    sta Player_Jmp_Counter

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

    jsr SetupTitleScreen
    

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

    lda Have_Players_Pressed_A
    and #%10000000
    bne SkipSetup
    jsr SetupPlayers

    SkipSetup:
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

.proc SetupPlayers

    SETUP_PLAYER player1,PLAYER_1, #$00, #$0 
    SETUP_PLAYER player2,PLAYER_2, #$01, #$10
    SETUP_PLAYER player3,PLAYER_3, #$02, #$20
    SETUP_PLAYER player4,PLAYER_4, #$03, #$30

    lda #%10000000
    ora Have_Players_Pressed_A ;flip Have_Players_Pressed_A to true for p1 (1000 0000) -> flips this one
    sta Have_Players_Pressed_A 

.endproc

.proc UpdateOrJumpingPlyrs

    UpdateOrJumpingPlyr player1,PLAYER_1, gamepad_1, #%00000001 , #$06
    UpdateOrJumpingPlyr player2,PLAYER_2, gamepad_2, #%00000010 , #$03
    UpdateOrJumpingPlyr player3,PLAYER_3, gamepad_3, #%00000100 , #$01
    UpdateOrJumpingPlyr player4,PLAYER_4, gamepad_4, #%00001000 , #$04

.endproc

.proc CheckForPlayersPressingA

    CheckForA gamepad_1,#%00000001
    CheckForA gamepad_2,#%00000010
    CheckForA gamepad_3,#%00000100
    CheckForA gamepad_4,#%00001000

.endproc
