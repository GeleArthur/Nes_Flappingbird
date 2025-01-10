.segment "ZEROPAGE"

Have_Players_Pressed_A: .res 1
Player_Jmp_Counter: .res 1


.macro  CheckForA gamepad, plyrBit
.local @End
    lda gamepad   
    and #PAD_A      
    beq @End
    lda plyrBit
    ora Have_Players_Pressed_A ;flip Have_Players_Pressed_A to true for plyr (plyrbitmask) -> flips this one   
    ;also stores if setup of player has been done in first bit to avoid redudant calculations 
    sta Have_Players_Pressed_A 

@End:
.endmacro

.macro UpdateOrJumpingPlyr player, playerOAM , gamepad , plyrBitMask , jmpOffset
    .local End, UpdatePlayer
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

.endmacro

.macro PlyrJumping player, offset
    .local DontJump, Increment, ResetCounter, End
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
.endmacro

.segment "CODE"

SCORE_PLAYER_1 = 16
SCORE_PLAYER_2 = 19
SCORE_PLAYER_3 = 22
SCORE_PLAYER_4 = 25

.proc StartScreen
    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL
    
    lda #CTRL_NMI
    sta PPU_CTRL

    SET_NAMETABLE_DRAW_BACKGROUND nametableStartscreen

    jsr CopyPallet

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

    jsr ShowScore
    jsr PositionScore_Menu
    
    inc nmi_ready
    WAIT_UNITL_FRAME_HAS_RENDERED  

    jsr CheckForStart ;check if select is pressed in any gamepad
    ;if so immediately leave to gameplay
    lda Have_Players_Pressed_A
    and #%01000000            ;the second bit of this variable stores if players have pressed start and if leaves start screen
    bne LeaveStartScreen


    lda Have_Players_Pressed_A
    and #%10000000            ;the very first bit of this variable stores if player have been setup or not
    bne SkipSetup
    jsr SetupPlayers

    SkipSetup:
    jsr UpdateOrJumpingPlyrs
  
    jsr CheckForPlayersPressingA

    inc seed ; get a random number
    inc seed+1 ; get a random number

    lda Have_Players_Pressed_A
    cmp #%10001111  
    bne StayInStartScreen

    LeaveStartScreen:
    lda #0
    sta PPU_MASK 
    lda #0
    sta PPU_CTRL

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

.proc CheckForStart
    lda gamepad_1
    and #PAD_START
    bne HasPressedStart

    lda gamepad_2
    and #PAD_START
    bne HasPressedStart

    lda gamepad_3
    and #PAD_START
    bne HasPressedStart

    lda gamepad_4
    and #PAD_START
    bne HasPressedStart

    rts

    HasPressedStart:
    lda #%00000001      ;Prevents player 1 from pausing game
    sta game_is_paused  


    lda Have_Players_Pressed_A 
    sta playerDeathStates     ;kills players by storing  the players who have pressed A (if player 1 and 2 have pressed A that equal 0011. which means player 3 and 4 die)
    lda #%11001111  
    sta Have_Players_Pressed_A ;Sets Have_Players_Pressed_A to true for all bools (0100 0000) -> this one leaves start screen if someone presses start
.endproc


.macro SCORE_TO_OAM score, playerScoreOam
.local HundredsLoop, TensDigit, TensLoop, UnitsDigit

        ldx #0          ; Clear X register for later use
        lda #$10
        OAM_WRITE_TILE_A(playerScoreOam)            ; Initialize hundreds digit to 0
        OAM_WRITE_TILE_A(playerScoreOam + 1)        ; Initialize tens digit to 0
        OAM_WRITE_TILE_A(playerScoreOam + 2)        ; Initialize units digit to 0

        lda score       ; Load the score into A
        cmp #100
        bcc TensDigit   ; If less than 100, skip to tens calculation

HundredsLoop:
        sec             ; Set carry for subtraction
        sbc #100       
        inx             
        cmp #100
        bcs HundredsLoop ; Loop until A < 100

        pha
        txa
        adc #$10
        OAM_WRITE_TILE_A(playerScoreOam)    ; Store the hundreds digit 
        pla
TensDigit:
        ldx #0
        cmp #10
        bcc UnitsDigit  ; If less than 10, skip to units calculation

TensLoop:
        sec             ; Set carry for subtraction
        sbc #10     
        inx
        cmp #10
        bcs TensLoop    ; Loop until A < 10

        pha
        txa
        adc #$10
        OAM_WRITE_TILE_A((playerScoreOam + 1))    ; Store the hundreds digit 
        pla                                   
UnitsDigit:
        adc #$10
        OAM_WRITE_TILE_A((playerScoreOam + 2))    ; Store the hundreds digit 
.endmacro

.proc ShowScore

    SCORE_TO_OAM Player1Score, SCORE_PLAYER_1
    SCORE_TO_OAM Player2Score, SCORE_PLAYER_2
    SCORE_TO_OAM Player3Score, SCORE_PLAYER_3
    SCORE_TO_OAM Player4Score, SCORE_PLAYER_4
    rts
.endproc

.proc SetupScore

    OAM_WRITE_X SCORE_PLAYER_1, #8
    OAM_WRITE_X (SCORE_PLAYER_1 + 1), #16
    OAM_WRITE_X (SCORE_PLAYER_1 + 2), #24

    OAM_WRITE_ATTRIBUTE SCORE_PLAYER_1, #0
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_1 + 1), #0
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_1 + 2), #0

    OAM_WRITE_X SCORE_PLAYER_2, #40
    OAM_WRITE_X (SCORE_PLAYER_2 + 1), #48
    OAM_WRITE_X (SCORE_PLAYER_2 + 2), #56

    OAM_WRITE_ATTRIBUTE SCORE_PLAYER_2, #1
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_2 + 1), #1
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_2 + 2), #1

    OAM_WRITE_X SCORE_PLAYER_3, #8
    OAM_WRITE_X (SCORE_PLAYER_3 + 1), #16
    OAM_WRITE_X (SCORE_PLAYER_3 + 2), #24

    OAM_WRITE_ATTRIBUTE SCORE_PLAYER_3, #2
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_3 + 1), #2
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_3 + 2), #2

    OAM_WRITE_X SCORE_PLAYER_4, #40
    OAM_WRITE_X (SCORE_PLAYER_4 + 1), #48
    OAM_WRITE_X (SCORE_PLAYER_4 + 2), #56

    OAM_WRITE_ATTRIBUTE SCORE_PLAYER_4, #3
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_4 + 1), #3
    OAM_WRITE_ATTRIBUTE (SCORE_PLAYER_4 + 2), #3
    rts
.endproc

.proc PositionScore_Menu

    OAM_WRITE_Y SCORE_PLAYER_1, #16
    OAM_WRITE_Y (SCORE_PLAYER_1 + 1), #16
    OAM_WRITE_Y (SCORE_PLAYER_1 + 2), #16
    
    OAM_WRITE_Y SCORE_PLAYER_2, #16
    OAM_WRITE_Y (SCORE_PLAYER_2 + 1), #16
    OAM_WRITE_Y (SCORE_PLAYER_2 + 2), #16

    OAM_WRITE_Y SCORE_PLAYER_3, #24
    OAM_WRITE_Y (SCORE_PLAYER_3 + 1), #24
    OAM_WRITE_Y (SCORE_PLAYER_3 + 2), #24

    OAM_WRITE_Y SCORE_PLAYER_4, #24
    OAM_WRITE_Y (SCORE_PLAYER_4 + 1), #24
    OAM_WRITE_Y (SCORE_PLAYER_4 + 2), #24
    rts
.endproc

.proc PositionScore_Game
    
    OAM_WRITE_Y SCORE_PLAYER_1, #255
    OAM_WRITE_Y (SCORE_PLAYER_1 + 1), #255
    OAM_WRITE_Y (SCORE_PLAYER_1 + 2), #255

    OAM_WRITE_Y SCORE_PLAYER_2, #255
    OAM_WRITE_Y (SCORE_PLAYER_2 + 1), #255
    OAM_WRITE_Y (SCORE_PLAYER_2 + 2), #255

    OAM_WRITE_Y SCORE_PLAYER_3, #255
    OAM_WRITE_Y (SCORE_PLAYER_3 + 1), #255
    OAM_WRITE_Y (SCORE_PLAYER_3 + 2), #255

    OAM_WRITE_Y SCORE_PLAYER_4, #255
    OAM_WRITE_Y (SCORE_PLAYER_4 + 1), #255
    OAM_WRITE_Y (SCORE_PLAYER_4 + 2), #255
    rts
.endproc
