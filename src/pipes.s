.segment "ZEROPAGE"
pipeUpperHighToLow: .res 1
pipeBottomHighToLow: .res 1

.segment "RODATA"
pipe_data: ; The bird needs to be between these 2
.byte 5*8, 13*8
.byte 9*8, 17*8
.byte 5*8, 13*8
.byte 9*8, 17*8

.macro ColliderPlayer which_player
    OAM_WRITE_X 32, #100
    OAM_WRITE_Y 32, #255
    OAM_WRITE_TILE 32, #2

    lda scroll_pos
    adc which_player+PlayerStruct::xpos
    and #%00100000
    bne checkY

    
    lda scroll_pos
    adc which_player+PlayerStruct::xpos
    adc #16
    and #%00100000
    bne checkY
    jmp end

checkY:
    lda scroll_pos
    adc which_player+PlayerStruct::xpos

    lsr 
    lsr 
    lsr 
    lsr 
    lsr 
    lsr ; Divide by 64
    asl ; stride * 2
    tax ; Put in x

    lda pipe_data, x
    cmp which_player+PlayerStruct::ypos
    bpl collided

    lda pipe_data+1, x
    cmp which_player+PlayerStruct::ypos
    bmi collided

    

    jmp end

collided:
    OAM_WRITE_X 32, #100
    OAM_WRITE_Y 32, which_player+PlayerStruct::ypos
    OAM_WRITE_TILE 32, #2

    
end:


.endmacro

.segment "CODE"
.proc CollisionPlayer1
    ColliderPlayer player1
    rts
.endproc

.proc CollisionPlayer2
    ColliderPlayer player2
    rts
.endproc

.proc CollisionPlayer3
    ColliderPlayer player3
    rts
.endproc

.proc CollisionPlayer4
    ColliderPlayer player4
    rts
.endproc