.struct PlayerStruct
    xpos .byte
    ypos .byte
    gravity .byte
    gravityCounter .byte
    jumpCounter .byte
.endstruct

; Setting the intial possitons of the players
.macro  SETUP_PLAYER   player, playerOAM ,  paletteIndex , XOffset

   ; Initialize player's position
   lda #90
   adc XOffset
   sta player+PlayerStruct::xpos

   lda #146
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

; Add to the player Y possition
.macro ADD_Y value,player
    lda player+PlayerStruct::ypos  
    sec
    sbc value
    sta player+PlayerStruct::ypos   
.endmacro

; Subtract to the player Y possition
.macro SUB_Y value,player
    lda player+PlayerStruct::ypos  
    sec
    adc value
    sta player+PlayerStruct::ypos   
.endmacro

; OAM Update of X and Y positions
.macro SET_XY  player, playerOAM
    ; Updates gravity and player Y position
    lda player+PlayerStruct::ypos
    sec
    adc player+PlayerStruct::gravity ;gravity 
    sta player+PlayerStruct::ypos
    OAM_WRITE_Y_A playerOAM
    OAM_WRITE_Y_A (playerOAM+1)

    ; Update other half of sprites
    sec 
    adc #7
    OAM_WRITE_Y_A (playerOAM+2)
    OAM_WRITE_Y_A (playerOAM+3)

    ; Update Player X position
    lda player+PlayerStruct::xpos
    OAM_WRITE_X_A playerOAM
    OAM_WRITE_X_A (playerOAM+2) 
    ; Update other half of sprite
    sec 
    adc #7
    OAM_WRITE_X_A (playerOAM+1)
    OAM_WRITE_X_A (playerOAM+3)
.endmacro

; Sets all the playersprite possitions to 1 location
; For a single player struct
; Mainly for putting stuff ofscreen.
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

; Updates the player poitions according to the controller input.
.macro UPDATE_PLAYER player, playerOAM, gamepad, plyrBitMask
    .local NOT_GAMEPAD_LEFT, NOT_GAMEPAD_RIGHT, NOT_GAMEPAD_A, BRANCH_ON_TERMINAL_VELOCITY, SET_PLAYER_XY
    ; Check gamepad L button
    lda gamepad
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        ; Check for not going over left screen border
        lda player+PlayerStruct::xpos
        cmp #0
        beq NOT_GAMEPAD_LEFT
        
        ; Move 1 pixels to the left.
        sec
        sbc #1
        sta player+PlayerStruct::xpos
    
NOT_GAMEPAD_LEFT:
        ; Check gamepad R button
        lda gamepad
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
            ; GOING RIGHT
            ; Check for not going over the right screen border
            lda player+PlayerStruct::xpos
            cmp #240                ; 256 - birdsize
            beq NOT_GAMEPAD_RIGHT

            ; Move 1 pixels to the right.
            clc
            adc #1
            sta player+PlayerStruct::xpos

NOT_GAMEPAD_RIGHT:
        ; Player Selector (For the A-press bitmask)
        lda plyrBitMask
        EOR #%11111111 ;flip plyr_jump_hold_button to false 
        sta plyr_jump_hold_button
        
        ; Check for gamepad A button
        lda gamepad
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            ; Check if we hit the top of the screen. [ BROKEN - OLD]
            lda player+PlayerStruct::ypos
            cmp #0
            beq NOT_GAMEPAD_A

            ; Update A press bitmask
            lda plyrBitMask
            ora plyr_jump_hold_button ;flip plyr_jump_hold_button to true for p1 (0000 0001) -> flips this one
            sta plyr_jump_hold_button 

            ; Update player Jump Counter 
            lda #$08   ;max value of player+PlayerStruct::jumpCounter ;determines how long the player can hold A for and keep going up
            cmp player+PlayerStruct::jumpCounter      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 

            ; If still able to jump
            ; Update the Y position + Counter.
            lda player+PlayerStruct::ypos
            sec
            sbc #$06   ;determines the intesity of elevation
            sta player+PlayerStruct::ypos   
            inc player+PlayerStruct::jumpCounter
            ;resets gravity acceleration
            lda #$0
            sta player+PlayerStruct::gravity

NOT_GAMEPAD_A:
    ; Check for terminal velocity
    lda #$03
    cmp player+PlayerStruct::gravity
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    ; Only inrease gravity every $15 (21) ticks.
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
    ; Update OAM
    SET_XY player,playerOAM
.endmacro

.segment "ZEROPAGE"
; Create player structs
player1: .tag PlayerStruct
player2: .tag PlayerStruct
player3: .tag PlayerStruct
player4: .tag PlayerStruct


plyr_jump_hold_button: .res 1 ; Players Holding Jump Button bools 1 bit per player (wastes 4 bits)

.segment "CODE"
; Player OAM Locations
PLAYER_1 = 0
PLAYER_2 = 4
PLAYER_3 = 8
PLAYER_4 = 12

.proc HandlePlayer1
    ; Check if player Died.
    lda playerDeathStates
    and #%00000001
    beq :+
    ; If not dead update player
    jsr UpdatePlayer1
    jmp :++
    :
    ; If player is dead
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

.proc UpdatePlayer1Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#255,player1,PLAYER_1
        rts
.endproc

.proc UpdatePlayer2Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#240,player2,PLAYER_2
        rts
.endproc

.proc UpdatePlayer3Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#240,player3,PLAYER_3
        rts
.endproc

.proc UpdatePlayer4Death
    ; Set all player sprites (of this player) to the end of the screen.
        SET_PLAYER_POSITION #255,#240,player4,PLAYER_4
        rts
.endproc

.proc UpdatePlayer1
    ; Call normal update function if player is not dead
    UPDATE_PLAYER player1, PLAYER_1, gamepad_1, #%00000001
    rts
.endproc

.proc UpdatePlayer2
    ; Call normal update function if player is not dead
   UPDATE_PLAYER player2, PLAYER_2, gamepad_2, #%00000010
    rts
.endproc

.proc UpdatePlayer3
    ; Call normal update function if player is not dead
    UPDATE_PLAYER player3, PLAYER_3, gamepad_3, #%00000100
    rts
.endproc

.proc UpdatePlayer4
    ; Call normal update function if player is not dead
    UPDATE_PLAYER player4, PLAYER_4, gamepad_4, #%00001000
    rts
.endproc