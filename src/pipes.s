.segment "ZEROPAGE"
pipelocationY: .res 1 ; We could combines these into 1 byte
pipesizeY: .res 1

.segment "RODATA"
PipeData:
.byte 128, 40
.byte 128, 50
.byte 128, 60
.byte 128, 70



.segment "CODE"
.proc CollisionPlayer1
    lda #128
    sta pipelocationY
    lda #30
    sta pipesizeY

    lda pipelocationY ; Check if its 0 then we skip
    beq end
    
    lda pipelocationY
    adc pipesizeY
    cmp p1_y
    bmi collided

    lda pipelocationY
    sbc pipesizeY
    cmp p1_y
    bpl collided



    ; 32 

    jmp end

collided:
    OAM_WRITE_X 3, #100
    OAM_WRITE_Y 3, p1_y
    OAM_WRITE_TILE 3, #2


end:
    rts
.endproc