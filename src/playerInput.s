.segment "ZEROPAGE"
					   ;        2 to turn rendering off next NMI

p1_x:   .res 1 ; Player 1 x position
p1_y:   .res 1 ; Player 1 y position
p1_g:   .res 1 ; Player 1 gravity acceleration
p1_g_c: .res 1 ; Player 1 Gravity Counter
p1_j_m: .res 1 ; Player 1 Jump Memory              //stores the last y position of the player to allow to keep track of when the player can jump

p2_x:   .res 1 ; Player 2 x position
p2_y:   .res 1 ; Player 2 y position
p2_g:   .res 1 ; Player 2 gravity acceleration
p2_g_c: .res 1 ; Player 2 Gravity Counter
p2_j_m: .res 1 ; Player 2 Jump Memory  

p3_x:   .res 1 ; Player 3 x position
p3_y:   .res 1 ; Player 3 y position
p3_g:   .res 1 ; Player 3 gravity acceleration
p3_g_c: .res 1 ; Player 3 Gravity Counter
p3_j_m: .res 1 ; Player 3 Jump Memory  

p4_x:   .res 1 ; Player 4 x position
p4_y:   .res 1 ; Player 4 y position
p4_g:   .res 1 ; Player 4 gravity acceleration
p4_g_c: .res 1 ; Player 4 Gravity Counter
p4_j_m: .res 1 ; Player 4 Jump Memory  



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

    lda #$00FF
    sta p1_j_m

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
        lda gamepad1
        and #PAD_A

        beq NOT_GAMEPAD_A
            ;jumping
            lda p1_y
            cmp #0
            beq NOT_GAMEPAD_A
            cmp p1_j_m      ;compares the y with the last jump memory
            bpl NOT_GAMEPAD_A
            sec
            sbc #$00FF
            sta p1_y
            sta p1_j_m
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
    cmp p1_g_c ;check if the player gravity counter is $FF

    bne  BRANCH_ON_TERMINAL_VELOCITY ;Branches if the counter isnt equal to the A defined above
    inc p1_g
    lda #$0
    sta p1_g_c

    BRANCH_ON_TERMINAL_VELOCITY:
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
        lda gamepad2
        and #PAD_A

        beq NOT_GAMEPAD_A
            ; Flying
            lda p2_y
            cmp #0
            beq NOT_GAMEPAD_A
            sec
            sbc #$09
            sta p2_y
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
        lda gamepad3
        and #PAD_A

        beq NOT_GAMEPAD_A
            ; Flying
            lda p3_y
            cmp #0
            beq NOT_GAMEPAD_A
            sec
            sbc #$09
            sta p3_y
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
    lda p3_y
    sec
    adc p3_g ;gravity 
    sta p3_y
    OAM_WRITE_Y_A PLAYER_3

    rts
.endproc

.proc SetupPlayer4

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
        lda gamepad4
        and #PAD_A

        beq NOT_GAMEPAD_A
            ; Flying
            lda p4_y
            cmp #0
            beq NOT_GAMEPAD_A
            sec
            sbc #$09
            sta p4_y
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
    lda p4_y
    sec
    adc p4_g ;gravity 
    sta p4_y
    OAM_WRITE_Y_A PLAYER_4

    rts
.endproc