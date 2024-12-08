.struct PlayerStruct
    xpos .byte
    ypos .byte
    gravity .byte
    gravityCounter .byte
    jumpCounter .byte
.endstruct

.macro  SETUP_PLAYER   player, playerOAM ,  paletteIndex

   ; Initialize player's position
   lda #180
   lda #32
   sta player+PlayerStruct::xpos

   lda #48
   sta player+PlayerStruct::ypos

   ; Initialize player's jump counter
   lda #$00
   sta player+PlayerStruct::jumpCounter

   ; Set up OAM tiles for the player
   OAM_WRITE_TILE playerOAM, #1
   OAM_WRITE_TILE (playerOAM+1), #2
   OAM_WRITE_TILE (playerOAM+2), #3
   OAM_WRITE_TILE (playerOAM+3), #4

   ; Calculate palette attribute (masking bits 0-1 for palette)
   lda paletteIndex
   and #%00000011
   ora #%00000000 ; Ensure other bits are zeroed (or customize for flipping/priority if needed)
   OAM_WRITE_ATTRIBUTE playerOAM, paletteIndex
   OAM_WRITE_ATTRIBUTE (playerOAM+1), paletteIndex
   OAM_WRITE_ATTRIBUTE (playerOAM+2), paletteIndex
   OAM_WRITE_ATTRIBUTE (playerOAM+3), paletteIndex

.endmacro

.macro SET_XY  player, playerOAM
    lda player+PlayerStruct::ypos
    sec
    adc player+PlayerStruct::gravity ;gravity 
    sta player+PlayerStruct::ypos
    OAM_WRITE_Y_A playerOAM
    OAM_WRITE_Y_A (playerOAM+1)
    sec 
    adc #7
    OAM_WRITE_Y_A (playerOAM+2)
    OAM_WRITE_Y_A (playerOAM+3)

    lda player+PlayerStruct::xpos
    OAM_WRITE_X_A playerOAM
    OAM_WRITE_X_A (playerOAM+2) 
    sec 
    adc #7
    OAM_WRITE_X_A (playerOAM+1)
    OAM_WRITE_X_A (playerOAM+3)
.endmacro

.macro SET_PLAYER_POSITION playerX,playerY,player,playerOAM
    lda playerY
    sta player+PlayerStruct::ypos
    OAM_WRITE_Y_A playerOAM
    OAM_WRITE_Y_A (playerOAM+1)
    OAM_WRITE_Y_A (playerOAM+2)
    OAM_WRITE_Y_A (playerOAM+3)

    lda playerX
    sta player+PlayerStruct::xpos
    OAM_WRITE_X_A playerOAM
    OAM_WRITE_X_A (playerOAM+2) 

    OAM_WRITE_X_A (playerOAM+1)
    OAM_WRITE_X_A (playerOAM+3)
.endmacro

.macro UPDATE_PLAYER player, playerOAM, gamepad, plyrBitMask
    lda gamepad
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda player+PlayerStruct::xpos
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta player+PlayerStruct::xpos
    
    NOT_GAMEPAD_LEFT:

        lda gamepad
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda player+PlayerStruct::xpos
            cmp #240
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta player+PlayerStruct::xpos

    NOT_GAMEPAD_RIGHT:
        lda plyrBitMask
        EOR #%11111111 ;flip plyr_jump_hold_button to false 
        sta plyr_jump_hold_button
        
        lda gamepad
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda player+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_A
            lda plyrBitMask
            ora plyr_jump_hold_button ;flip plyr_jump_hold_button to true for p1 (0000 0001) -> flips this one
            sta plyr_jump_hold_button 
            lda #$08   ;max value of player+PlayerStruct::jumpCounter ;determines how long the player can hold A for and keep going up
            cmp player+PlayerStruct::jumpCounter      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda player+PlayerStruct::ypos
            sec
            sbc #$06   ;determines the intesity of elevation
            sta player+PlayerStruct::ypos   
            inc player+PlayerStruct::jumpCounter
            ;resets gravity acceleration
            lda #$0
            sta player+PlayerStruct::gravity

    NOT_GAMEPAD_A:

    lda player+PlayerStruct::xpos
    OAM_WRITE_X_A playerOAM

    lda #$03
    cmp player+PlayerStruct::gravity
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc player+PlayerStruct::gravityCounter
    lda #$15  ;value for the counter to reach
    cmp player+PlayerStruct::gravityCounter ;check if the player gravity counter is $15

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc player+PlayerStruct::gravity
    lda #$0
    sta player+PlayerStruct::gravityCounter

    BRANCH_ON_TERMINAL_VELOCITY:

    lda plyr_jump_hold_button
    and plyrBitMask  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_XY
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta player+PlayerStruct::jumpCounter

    SET_PLAYER_XY:
    SET_XY player,playerOAM
.endmacro

.segment "ZEROPAGE"
					   ;        2 to turn rendering off next NMI
player1: .res .sizeof(PlayerStruct)
player2: .res .sizeof(PlayerStruct)
player3: .res .sizeof(PlayerStruct)
player4: .res .sizeof(PlayerStruct)

; Arthur: Use the other 4 to see if they are dead?
plyr_jump_hold_button:.res 1 ; Players Holding Jump Button bools 1 bit per player (wastes 4 bits)

.segment "CODE"

PLAYER_1A = 0
PLAYER_1B = 1
PLAYER_1C = 2
PLAYER_1D = 3

PLAYER_2A = 4
PLAYER_2B = 5
PLAYER_2C = 6
PLAYER_2D = 7

PLAYER_3A = 8
PLAYER_3B = 9
PLAYER_3C = 10
PLAYER_3D = 11

PLAYER_4A = 12
PLAYER_4B = 13
PLAYER_4C = 14
PLAYER_4D = 15

.proc SetupPlayer1

    SETUP_PLAYER player1, PLAYER_1A, #$00

    rts

.endproc

.proc HandlePlayer1
    lda playerDeathStates
    and #%00000001
    beq :+
    jsr UpdatePlayer1
    jmp :++
    :
    jsr UpdatePlayer1Death
    :
    rts
.endproc

.proc HandlePlayer2
    lda playerDeathStates
    and #%00000010
    beq :+
    jsr UpdatePlayer2
    jmp :++
    :
    jsr UpdatePlayer2Death
    :
    rts
.endproc

.proc HandlePlayer3
    lda playerDeathStates
    and #%00000100
    beq :+
    jsr UpdatePlayer3
    jmp :++
    :
    jsr UpdatePlayer3Death
    :
    rts
.endproc

.proc HandlePlayer4
    lda playerDeathStates
    and #%00001000
    beq :+
    jsr UpdatePlayer4
    jmp :++
    :
    jsr UpdatePlayer4Death
    :
    rts
.endproc

; ALL BUGGED TO BE FIXED By NEXT GONCALO PATCH
.proc UpdatePlayer1Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#255,player1,PLAYER_1A
        rts
.endproc

.proc UpdatePlayer2Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#240,player2,PLAYER_2A
        rts
.endproc

.proc UpdatePlayer3Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#240,player3,PLAYER_3A
        rts
.endproc

.proc UpdatePlayer4Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#240,player4,PLAYER_4A
        rts
.endproc

.proc UpdatePlayer1

    UPDATE_PLAYER player1, PLAYER_1A, gamepad_1, #%00000001

    rts
.endproc

.proc SetupPlayer2

    SETUP_PLAYER player2, PLAYER_2A, #$01

    rts

.endproc

.proc UpdatePlayer2

   UPDATE_PLAYER player2, PLAYER_2A, gamepad_2, #%00000010

    rts
.endproc

.proc SetupPlayer3

    SETUP_PLAYER player3,PLAYER_3A, #$02

    rts

.endproc

.proc UpdatePlayer3

    UPDATE_PLAYER player3, PLAYER_3A, gamepad_3, #%00000100

    rts
.endproc

.proc SetupPlayer4

    SETUP_PLAYER player4,PLAYER_4A, #$03
    
    rts

.endproc

.proc UpdatePlayer4

    UPDATE_PLAYER player4, PLAYER_4A, gamepad_4, #%00001000

    rts
.endproc