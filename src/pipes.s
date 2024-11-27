.segment "ZEROPAGE"
pipeUpperHighToLow: .res 1
pipeBottomHighToLow: .res 1

.segment "RODATA"
PipeData: ; The bird needs to be between these 2
.byte 5*8, 112
.byte 9*8, 144
.byte 5*8, 112
.byte 9*7, 144



.segment "CODE"
.proc CollisionPlayer1
    OAM_WRITE_X 3, #100
    OAM_WRITE_Y 3, #255
    OAM_WRITE_TILE 3, #2

    lda scrollPos
    adc p1_x
    and #%00100000
    beq end

    lda scrollPos
    adc p1_x

    lsr 
    lsr 
    lsr 
    lsr 
    lsr 
    lsr ; Divide by 64
    asl ; stride * 2
    tax ; Put in x

    lda PipeData, x
    cmp p1_y
    bpl collided

    lda PipeData+1, x
    cmp p1_y
    bmi collided

    jmp end


collided:
    OAM_WRITE_X 3, #100
    OAM_WRITE_Y 3, p1_y
    OAM_WRITE_TILE 3, #2


end:
    rts
.endproc