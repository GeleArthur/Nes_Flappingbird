
PLAYER_1 = 0
PLAYER_2 = 1
PLAYER_3 = 2
PLAYER_4 = 3

.proc setup_player_1
    lda #180
    sta p1_x

    lda #120
    sta p1_y

    lda p1_x
    set_sprite_x_a PLAYER_1

    lda p1_y
    set_sprite_y_a PLAYER_1

    set_sprite_tile PLAYER_1, #1

    set_sprite_attr PLAYER_1, %10000000

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

    lda p1_x
    set_sprite_x_a PLAYER_1

    lda p1_y
    set_sprite_y_a PLAYER_1

    rts
.endproc

.proc setup_player_2
    lda #180 + 8
    sta p2_x

    lda #120
    sta p2_y


    lda p2_x
    set_sprite_x_a PLAYER_2

    lda p2_y
    set_sprite_y_a PLAYER_2

    set_sprite_tile PLAYER_2, #2

    set_sprite_attr PLAYER_2, %10000000

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

    lda p2_x
    set_sprite_x_a PLAYER_2

    lda p2_y
    set_sprite_y_a PLAYER_2
    rts
.endproc

.proc setup_player_3
    lda #180
    sta p3_x

    lda #120 + 8
    sta p3_y


    lda p3_x
    set_sprite_x_a PLAYER_3

    lda p3_y
    set_sprite_y_a PLAYER_3

    set_sprite_tile PLAYER_3, #3

    set_sprite_attr PLAYER_3, %10000000

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

    lda p3_x
    set_sprite_x_a PLAYER_3

    lda p3_y
    set_sprite_y_a PLAYER_3
    rts
.endproc

.proc setup_player_4

    lda #180 + 8
    sta p4_x

    lda #120 + 8
    sta p4_y

    lda p4_x
    set_sprite_x_a PLAYER_4

    lda p4_y
    set_sprite_y_a PLAYER_4

    set_sprite_tile PLAYER_4, #4

    set_sprite_attr PLAYER_4, %10000000

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

    lda p4_x
    set_sprite_x_a PLAYER_4

    lda p4_y
    set_sprite_y_a PLAYER_4
    rts
.endproc



    jsr gamepad_poll

    jsr update_player_1
    jsr update_player_2
    jsr update_player_3
    jsr update_player_4



    ldx #0
paletteloop:
    lda default_palette, x
    sta palette, x
    inx
    cpx #32
    bcc paletteloop
    jsr clear_nametable

    lda PPU_STATUS
    lda #$20
    sta PPU_VRAM_ADDRESS2
    lda #$8A
    sta PPU_VRAM_ADDRESS2

    lda #180
    sta p1_x

    lda #120
    sta p1_y


    jsr setup_player_1
    jsr setup_player_2
    jsr setup_player_3
    jsr setup_player_4

    jsr ppu_update
