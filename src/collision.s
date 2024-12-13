.segment "ZEROPAGE"
pipeUpperHighToLow: .res 1
pipeBottomHighToLow: .res 1

.segment "RODATA"
pipe_data: ; The bird needs to be between these 2
  .byte 5*8, 13*8
  .byte 9*8, 17*8
  .byte 5*8, 13*8
  .byte 9*8, 17*8

; TODO: Make this a function
.macro ColliderPlayer which_player, playerDeathStateBit


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

    CHECK_DEATH playerDeathStateBit
end:


.endmacro

.segment "CODE"
.proc CollisionPlayer1
    ColliderPlayer player1, %00000001
    rts
.endproc

.proc CollisionPlayer2
    ColliderPlayer player2, %00000010
    rts
.endproc

.proc CollisionPlayer3
    ColliderPlayer player3, %00000100
    rts
.endproc

.proc CollisionPlayer4
    ColliderPlayer player4, %00001000
    rts
.endproc