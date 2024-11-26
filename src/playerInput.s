.segment "ZEROPAGE"
					   ;        2 to turn rendering off next NMI

p1_x:   .res 1 ; Player 1 x position
p1_y:   .res 1 ; Player 1 y position
p1_g:   .res 1 ; Player 1 gravity acceleration
p1_g_c: .res 1 ; Player 1 Gravity Counter
p1_j_c: .res 1 ; Player 1 Jump Counter            //stores the last y position of the player to allow to keep track of when the player can jump

p2_x:   .res 1 ; Player 2 x position
p2_y:   .res 1 ; Player 2 y position
p2_g:   .res 1 ; Player 2 gravity acceleration
p2_g_c: .res 1 ; Player 2 Gravity Counter
p2_j_c: .res 1 ; Player 2 Jump Counter   

p3_x:   .res 1 ; Player 3 x position
p3_y:   .res 1 ; Player 3 y position
p3_g:   .res 1 ; Player 3 gravity acceleration
p3_g_c: .res 1 ; Player 3 Gravity Counter
p3_j_c: .res 1 ; Player 3 Jump Counter  

p4_x:   .res 1 ; Player 4 x position
p4_y:   .res 1 ; Player 4 y position
p4_g:   .res 1 ; Player 4 gravity acceleration
p4_g_c: .res 1 ; Player 4 Gravity Counter
p4_j_c: .res 1 ; Player 4 Jump Counter  

p_h_j_b:.res 1 ; Players Holding Jump Button bools 1 bit per player (wastes 4 bits)


.segment "CODE"

PLAYER_1 = 0
PLAYER_2 = 1
PLAYER_3 = 2
PLAYER_4 = 3

.proc setup_player_1
    lda #180
    sta p1_x

    lda #120
    sta p1_y

    lda #$00
    sta p1_j_c

    lda p1_x
    OAM_WRITE_X_A PLAYER_1

    lda p1_y
    OAM_WRITE_Y_A PLAYER_1

    OAM_WRITE_TILE PLAYER_1, #1

    OAM_WRITE_ATTRUDE PLAYER_1, %10000000

    rts

.endproc

.proc update_player_1

    lda gamepad1
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda p1_x
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta p1_x
    
    NOT_GAMEPAD_LEFT:

        lda gamepad1
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda p1_x
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta p1_x

    NOT_GAMEPAD_RIGHT:
        lda gamepad1
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda p1_y
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta p1_y

    NOT_GAMEPAD_UP:
        lda gamepad1
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda p1_y
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta p1_y

    NOT_GAMEPAD_DOWN:
        lda #%00001110
        and p_h_j_b ;flip p_h_j_b to false 
        sta p_h_j_b
        
        lda gamepad1
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda p1_y
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00000001
            ora p_h_j_b ;flip p_h_j_b to true for p1 (0000 0001) -> flips this one
            sta p_h_j_b 
            lda #$08   ;max value of p1_j_c ;determines how long the player can hold A for and keep going up
            cmp p1_j_c      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda p1_y
            sec
            sbc #$07   ;determines the intesity of elevation
            sta p1_y   
            inc p1_j_c
            ;resets gravity acceleration
            lda #$0
            sta p1_g

    NOT_GAMEPAD_A:

    lda p1_x
    OAM_WRITE_X_A PLAYER_1

    lda #$03
    cmp p1_g
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc p1_g_c
    lda #$15  ;value for the counter to reach
    cmp p1_g_c ;check if the player gravity counter is $15

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc p1_g
    lda #$0
    sta p1_g_c

    BRANCH_ON_TERMINAL_VELOCITY:

    lda #$00 ;time it takes to reset counter
    cmp p1_g ;compare it
    bpl SET_PLAYER_Y ;If p1_j_c_r != reset time  jump to set_player_y
    ;if it does equal the time to reset counter than reset values to 0
    lda p_h_j_b
    and #%00000001  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_Y
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta p1_j_c

    SET_PLAYER_Y:
    lda p1_y
    sec
    adc p1_g ;gravity 
    sta p1_y
    OAM_WRITE_Y_A PLAYER_1

    rts
.endproc

.proc setup_player_2
    lda #180 + 8
    sta p2_x

    lda #120
    sta p2_y


    lda p2_x
    OAM_WRITE_X_A PLAYER_2

    lda p2_y
    OAM_WRITE_Y_A PLAYER_2

    OAM_WRITE_TILE PLAYER_2, #2

    OAM_WRITE_ATTRUDE PLAYER_2, %10000000

    rts

.endproc

.proc update_player_2

    lda gamepad2
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda p2_x
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta p2_x
    
    NOT_GAMEPAD_LEFT:

        lda gamepad2
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda p2_x
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta p2_x

    NOT_GAMEPAD_RIGHT:
        lda gamepad2
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda p2_y
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta p2_y

    NOT_GAMEPAD_UP:
        lda gamepad2
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda p2_y
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta p2_y

    NOT_GAMEPAD_DOWN:
        lda #%00001101
        and p_h_j_b ;flip p_h_j_b to false 
        sta p_h_j_b
        
        lda gamepad2
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda p2_y
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00000010
            ora p_h_j_b ;flip p_h_j_b to true for p1 (0000 0001) -> flips this one
            sta p_h_j_b 
            lda #$08   ;max value of p2_j_c ;determines how long the player can hold A for and keep going up
            cmp p2_j_c      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda p2_y
            sec
            sbc #$07   ;determines the intesity of elevation
            sta p2_y   
            inc p2_j_c
            ;resets gravity acceleration
            lda #$0
            sta p2_g

    NOT_GAMEPAD_A:

    lda p2_x
    OAM_WRITE_X_A PLAYER_2

    lda #$03
    cmp p2_g
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc p2_g_c
    lda #$15  ;value for the counter to reach
    cmp p2_g_c ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc p2_g
    lda #$0
    sta p2_g_c

    BRANCH_ON_TERMINAL_VELOCITY:
    
    lda #$00 ;time it takes to reset counter
    cmp p2_g ;compare it
    bpl SET_PLAYER_Y ;If p1_j_c_r != reset time  jump to set_player_y
    ;if it does equal the time to reset counter than reset values to 0
    lda p_h_j_b
    and #%00000010  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_Y
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta p2_j_c

    SET_PLAYER_Y:
    lda p2_y
    sec
    adc p2_g ;gravity 
    sta p2_y
    OAM_WRITE_Y_A PLAYER_2

    rts
.endproc

.proc setup_player_3
    lda #180
    sta p3_x

    lda #120 + 8
    sta p3_y


    lda p3_x
    OAM_WRITE_X_A PLAYER_3

    lda p3_y
    OAM_WRITE_Y_A PLAYER_3

    OAM_WRITE_TILE PLAYER_3, #3

    OAM_WRITE_ATTRUDE PLAYER_3, %10000000

    rts

.endproc

.proc update_player_3

    lda gamepad3
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda p3_x
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta p3_x
    
    NOT_GAMEPAD_LEFT:

        lda gamepad3
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda p3_x
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta p3_x

    NOT_GAMEPAD_RIGHT:
        lda gamepad3
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda p3_y
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta p3_y

    NOT_GAMEPAD_UP:
        lda gamepad3
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda p3_y
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta p3_y

    NOT_GAMEPAD_DOWN:
        lda #%00001011
        and p_h_j_b ;flip p_h_j_b to false 
        sta p_h_j_b
        
        lda gamepad3
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda p3_y
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00000100
            ora p_h_j_b ;flip p_h_j_b to true for p1 (0000 0001) -> flips this one
            sta p_h_j_b 
            lda #$08   ;max value of p3_j_c ;determines how long the player can hold A for and keep going up
            cmp p3_j_c      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda p3_y
            sec
            sbc #$07   ;determines the intesity of elevation
            sta p3_y   
            inc p3_j_c
            ;resets gravity acceleration
            lda #$0
            sta p3_g

    NOT_GAMEPAD_A:

    lda p3_x
    OAM_WRITE_X_A PLAYER_3

    lda #$03
    cmp p3_g
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc p3_g_c
    lda #$15  ;value for the counter to reach
    cmp p3_g_c ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc p3_g
    lda #$0
    sta p3_g_c

    BRANCH_ON_TERMINAL_VELOCITY:

    lda #$00 ;time it takes to reset counter
    cmp p3_g ;compare it
    bpl SET_PLAYER_Y ;If p1_j_c_r != reset time  jump to set_player_y
    ;if it does equal the time to reset counter than reset values to 0
    lda p_h_j_b
    and #%00000100  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_Y
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta p3_j_c

    SET_PLAYER_Y:
    lda p3_y
    sec
    adc p3_g ;gravity 
    sta p3_y
    OAM_WRITE_Y_A PLAYER_3

    rts
.endproc

.proc setup_player_4

    lda #180 + 8
    sta p4_x

    lda #120 + 8
    sta p4_y

    lda p4_x
    OAM_WRITE_X_A PLAYER_4

    lda p4_y
    OAM_WRITE_Y_A PLAYER_4

    OAM_WRITE_TILE PLAYER_4, #4

    OAM_WRITE_ATTRUDE PLAYER_4, %10000000

    rts

.endproc

.proc update_player_4

    lda gamepad4
    and #PAD_L 

    beq NOT_GAMEPAD_LEFT
        ; GOING LEFT
        lda p4_x
        cmp #0
        beq NOT_GAMEPAD_LEFT
        sec
        sbc #1
        sta p4_x
    
    NOT_GAMEPAD_LEFT:

        lda gamepad4
        and #PAD_R

        beq NOT_GAMEPAD_RIGHT
        ; GOING RIGHT
            lda p4_x
            cmp #248
            beq NOT_GAMEPAD_RIGHT ; FREE OVERFLOW
            clc
            adc #1
            sta p4_x

    NOT_GAMEPAD_RIGHT:
        lda gamepad4
        and #PAD_U

        beq NOT_GAMEPAD_UP
            ; GOING UP
            lda p4_y
            cmp #0
            beq NOT_GAMEPAD_UP
            sec
            sbc #1
            sta p4_y

    NOT_GAMEPAD_UP:
        lda gamepad4
        and #PAD_D

        beq NOT_GAMEPAD_DOWN
            ; GOING DOWN
            lda p4_y
            cmp #230
            beq NOT_GAMEPAD_DOWN
            clc
            adc #1
            sta p4_y

    NOT_GAMEPAD_DOWN:
        lda #%00000111
        and p_h_j_b ;flip p_h_j_b to false 
        sta p_h_j_b
        
        lda gamepad4
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda p4_y
            cmp #0
            beq NOT_GAMEPAD_A
            lda #%00001000
            ora p_h_j_b ;flip p_h_j_b to true for p1 (0000 0001) -> flips this one
            sta p_h_j_b 
            lda #$08   ;max value of p2_j_c ;determines how long the player can hold A for and keep going up
            cmp p4_j_c      ;compares the J counter with its max value
            beq NOT_GAMEPAD_A 
            lda p4_y
            sec
            sbc #$07   ;determines the intesity of elevation
            sta p4_y   
            inc p4_j_c
            ;resets gravity acceleration
            lda #$0
            sta p4_g

    NOT_GAMEPAD_A:

    lda p4_x
    OAM_WRITE_X_A PLAYER_4

    lda #$03
    cmp p4_g
    beq BRANCH_ON_TERMINAL_VELOCITY ;Branches if its reached terminal velocity

    inc p4_g_c
    lda #$15  ;value for the counter to reach
    cmp p4_g_c ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc p4_g
    lda #$0
    sta p4_g_c

    BRANCH_ON_TERMINAL_VELOCITY:

    lda #$00 ;time it takes to reset counter
    cmp p4_g ;compare it
    bpl SET_PLAYER_Y ;If p1_j_c_r != reset time  jump to set_player_y
    ;if it does equal the time to reset counter than reset values to 0
    lda p_h_j_b
    and #%00001000  ;checks for that players bit
    cmp #$0
    bne SET_PLAYER_Y
    ;if the jump button isnt being held down than resets counter
    lda #$0
    sta p4_j_c

    SET_PLAYER_Y:
    lda p4_y
    sec
    adc p4_g ;gravity 
    sta p4_y
    OAM_WRITE_Y_A PLAYER_4

    rts
.endproc