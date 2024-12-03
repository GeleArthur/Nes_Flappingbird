.segment "ZEROPAGE"
pipeUpperHighToLow: .res 1
pipeBottomHighToLow: .res 1

.segment "RODATA"
pipe_data: ; The bird needs to be between these 2
.byte 5*8, 13*8
.byte 9*8, 17*8
.byte 5*8, 13*8
.byte 9*8, 17*8



.segment "CODE"
.proc CollisionPlayer1
    OAM_WRITE_X 32, #100
    OAM_WRITE_Y 32, #255
    OAM_WRITE_TILE 32, #2

    lda scroll_pos
    adc player1+PlayerStruct::xpos
    and #%00100000
    beq end
    
    lda scroll_pos
    adc player1+PlayerStruct::xpos

    lsr 
    lsr 
    lsr 
    lsr 
    lsr 
    lsr ; Divide by 64
    asl ; stride * 2
    tax ; Put in x


    lda pipe_data, x
    cmp player1+PlayerStruct::ypos
    bpl collided

    lda pipe_data+1, x
    cmp player1+PlayerStruct::ypos
    bmi collided

    jmp end


collided:
    OAM_WRITE_X 32, #100
    OAM_WRITE_Y 32, player1+PlayerStruct::ypos
    OAM_WRITE_TILE 32, #2
    
    CHECK_DEATH %00000001
end:
    rts
.endproc