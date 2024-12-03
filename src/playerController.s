.struct PlayerStruct
    xpos .byte
    ypos .byte
    gravity .byte
    gravityCounter .byte
    jumpCounter .byte
.endstruct

.macro  SETUP_PLAYER   player, playerOAM 

   lda #180
   sta player+PlayerStruct::xpos

   lda #200
   sta player+PlayerStruct::ypos

   lda #$00
   sta player+PlayerStruct::jumpCounter


   OAM_WRITE_TILE playerOAM, #1
   OAM_WRITE_TILE (playerOAM+1), #2
   OAM_WRITE_TILE (playerOAM+2), #3
   OAM_WRITE_TILE (playerOAM+3), #4

   OAM_WRITE_ATTRIBUTE playerOAM, %10000000
.endmacro

.macro SET_XY  player, playerOAM
    lda player+PlayerStruct::ypos
    sec
    ; adc player+PlayerStruct::gravity ;gravity 
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

.segment "ZEROPAGE"
					   ;        2 to turn rendering off next NMI
player1: .res .sizeof(PlayerStruct)
player2: .res .sizeof(PlayerStruct)
player3: .res .sizeof(PlayerStruct)
player4: .res .sizeof(PlayerStruct)

; Arthur: Use the other 4 to see if they are dead?
plyr_jump_hold_and_death_state:.res 1 ; Players Holding Jump Button bools 1 bit per player (wastes 4 bits)

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

    SETUP_PLAYER player1, PLAYER_1A

    rts

.endproc

.proc UpdatePlayer1

    lda gamepad_1
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda player1+PlayerStruct::xpos
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta player1+PlayerStruct::xpos
    
    NOT_GAMEPAD_LEFT:

        lda gamepad_1
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda player1+PlayerStruct::xpos
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta player1+PlayerStruct::xpos

    NOT_GAMEPAD_RIGHT:
        lda #%00001110
        and plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to false 
        sta plyr_jump_hold_and_death_state
        
        lda gamepad_1
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda player1+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00000001
            ora plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to true for p1 (0000 0001) -> flips this one
            sta plyr_jump_hold_and_death_state 
            lda #$08   ;max value of player1+PlayerStruct::jumpCounter ;determines how long the player can hold A for and keep going up
            cmp player1+PlayerStruct::jumpCounter      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda player1+PlayerStruct::ypos
            sec
            sbc #$06   ;determines the intesity of elevation
            sta player1+PlayerStruct::ypos   
            inc player1+PlayerStruct::jumpCounter
            ;resets gravity acceleration
            lda #$0
            sta player1+PlayerStruct::gravity

    NOT_GAMEPAD_A:

    lda player1+PlayerStruct::xpos
    OAM_WRITE_X_A PLAYER_1A

    lda #$03
    cmp player1+PlayerStruct::gravity
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc player1+PlayerStruct::gravityCounter
    lda #$15  ;value for the counter to reach
    cmp player1+PlayerStruct::gravityCounter ;check if the player gravity counter is $15

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc player1+PlayerStruct::gravity
    lda #$0
    sta player1+PlayerStruct::gravityCounter

    BRANCH_ON_TERMINAL_VELOCITY:

    lda plyr_jump_hold_and_death_state
    and #%00000001  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_XY
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta player1+PlayerStruct::jumpCounter

    SET_PLAYER_XY:
    SET_XY player1,PLAYER_1A


    rts
.endproc

.proc SetupPlayer2

    SETUP_PLAYER player2, PLAYER_2A

    rts

.endproc

.proc UpdatePlayer2

    lda gamepad_2
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda player2+PlayerStruct::xpos
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta player2+PlayerStruct::xpos
    
    NOT_GAMEPAD_LEFT:

        lda gamepad_2
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda player2+PlayerStruct::xpos
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta player2+PlayerStruct::xpos

    NOT_GAMEPAD_RIGHT:
        lda gamepad_2
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda player2+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta player2+PlayerStruct::ypos

    NOT_GAMEPAD_UP:
        lda gamepad_2
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda player2+PlayerStruct::ypos
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta player2+PlayerStruct::ypos

    NOT_GAMEPAD_DOWN:
        lda #%00001101
        and plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to false 
        sta plyr_jump_hold_and_death_state
        
        lda gamepad_2
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda player2+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00000010
            ora plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to true for p1 (0000 0001) -> flips this one
            sta plyr_jump_hold_and_death_state 
            lda #$08   ;max value of player2+PlayerStruct::jumpCounter ;determines how long the player can hold A for and keep going up
            cmp player2+PlayerStruct::jumpCounter      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda player2+PlayerStruct::ypos
            sec
            sbc #$06   ;determines the intesity of elevation
            sta player2+PlayerStruct::ypos   
            inc player2+PlayerStruct::jumpCounter
            ;resets gravity acceleration
            lda #$0
            sta player2+PlayerStruct::gravity

    NOT_GAMEPAD_A:

    lda player2+PlayerStruct::xpos
    OAM_WRITE_X_A PLAYER_2A

    lda #$03
    cmp player2+PlayerStruct::gravity
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc player2+PlayerStruct::gravityCounter
    lda #$15  ;value for the counter to reach
    cmp player2+PlayerStruct::gravityCounter ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc player2+PlayerStruct::gravity
    lda #$0
    sta player2+PlayerStruct::gravityCounter

    BRANCH_ON_TERMINAL_VELOCITY:

    lda plyr_jump_hold_and_death_state
    and #%00000010  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_XY
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta player2+PlayerStruct::jumpCounter

    SET_PLAYER_XY:
    SET_XY player2,PLAYER_2A

    rts
.endproc

.proc SetupPlayer3

    SETUP_PLAYER player3,PLAYER_3A

    rts

.endproc

.proc UpdatePlayer3

    lda gamepad_3
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda player3+PlayerStruct::xpos
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta player3+PlayerStruct::xpos
    
    NOT_GAMEPAD_LEFT:

        lda gamepad_3
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda player3+PlayerStruct::xpos
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta player3+PlayerStruct::xpos

    NOT_GAMEPAD_RIGHT:
        lda gamepad_3
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda player3+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta player3+PlayerStruct::ypos

    NOT_GAMEPAD_UP:
        lda gamepad_3
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda player3+PlayerStruct::ypos
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta player3+PlayerStruct::ypos

    NOT_GAMEPAD_DOWN:
        lda #%00001011
        and plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to false 
        sta plyr_jump_hold_and_death_state
        
        lda gamepad_3
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda player3+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00000100
            ora plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to true for p1 (0000 0001) -> flips this one
            sta plyr_jump_hold_and_death_state 
            lda #$08   ;max value of player3+PlayerStruct::jumpCounter ;determines how long the player can hold A for and keep going up
            cmp player3+PlayerStruct::jumpCounter      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda player3+PlayerStruct::ypos
            sec
            sbc #$06   ;determines the intesity of elevation
            sta player3+PlayerStruct::ypos   
            inc player3+PlayerStruct::jumpCounter
            ;resets gravity acceleration
            lda #$0
            sta player3+PlayerStruct::gravity

    NOT_GAMEPAD_A:

    lda player3+PlayerStruct::xpos
    OAM_WRITE_X_A PLAYER_3A

    lda #$03
    cmp player3+PlayerStruct::gravity
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc player3+PlayerStruct::gravityCounter
    lda #$15  ;value for the counter to reach
    cmp player3+PlayerStruct::gravityCounter ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc player3+PlayerStruct::gravity
    lda #$0
    sta player3+PlayerStruct::gravityCounter

    BRANCH_ON_TERMINAL_VELOCITY:

    lda plyr_jump_hold_and_death_state
    and #%00000100  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_XY
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta player3+PlayerStruct::jumpCounter

    SET_PLAYER_XY:
    SET_XY player3,PLAYER_3A

    rts
.endproc

.proc SetupPlayer4

    SETUP_PLAYER player4,PLAYER_4A
    
    rts

.endproc

.proc UpdatePlayer4

    lda gamepad_4
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda player4+PlayerStruct::xpos
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta player4+PlayerStruct::xpos
    
    NOT_GAMEPAD_LEFT:

        lda gamepad_4
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda player4+PlayerStruct::xpos
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta player4+PlayerStruct::xpos

    NOT_GAMEPAD_RIGHT:
        lda gamepad_4
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda player4+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta player4+PlayerStruct::ypos

    NOT_GAMEPAD_UP:
        lda gamepad_4
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda player4+PlayerStruct::ypos
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta player4+PlayerStruct::ypos

    NOT_GAMEPAD_DOWN:
        lda #%00000111
        and plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to false 
        sta plyr_jump_hold_and_death_state
        
        lda gamepad_4
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda player4+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00001000
            ora plyr_jump_hold_and_death_state ;flip plyr_jump_hold_and_death_state to true for p1 (0000 0001) -> flips this one
            sta plyr_jump_hold_and_death_state 
            lda #$08   ;max value of player2+PlayerStruct::jumpCounter ;determines how long the player can hold A for and keep going up
            cmp player4+PlayerStruct::jumpCounter      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda player4+PlayerStruct::ypos
            sec
            sbc #$06   ;determines the intesity of elevation
            sta player4+PlayerStruct::ypos   
            inc player4+PlayerStruct::jumpCounter
            ;resets gravity acceleration
            lda #$0
            sta player4+PlayerStruct::gravity

    NOT_GAMEPAD_A:

    lda player4+PlayerStruct::xpos
    OAM_WRITE_X_A PLAYER_4A

    lda #$03
    cmp player4+PlayerStruct::gravity
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc player4+PlayerStruct::gravityCounter
    lda #$15  ;value for the counter to reach
    cmp player4+PlayerStruct::gravityCounter ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc player4+PlayerStruct::gravity
    lda #$0
    sta player4+PlayerStruct::gravityCounter

    BRANCH_ON_TERMINAL_VELOCITY:

    lda plyr_jump_hold_and_death_state
    and #%00001000  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_XY
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta player4+PlayerStruct::jumpCounter

    SET_PLAYER_XY:
    SET_XY player4,PLAYER_4A

    rts
.endproc

