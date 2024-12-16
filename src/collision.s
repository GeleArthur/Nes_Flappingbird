.segment "RODATA"
pipe_data: ; The bird needs to be between these 2
  .byte 5*8, 13*8
  .byte 9*8, 17*8
  .byte 5*8, 13*8
  .byte 9*8, 17*8

; TODO: Make this a function

.segment "ZEROPAGE"
SpriteBottom: .res 1
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
    bcs UseActiveCollision
    ; sta 
    ; IDEA basted on the positionof the player and scroll it will branch or not.
    ; Based on that we can flip between the active pointer or previousPointer.
    ldy ptrPreviousDrawnNametable
    sty temp1
    ldy ptrPreviousDrawnNametable+1
    sty temp1+1
    jmp UsePreviousCollision
UseActiveCollision:
    ldy ptrActiveDrawnNameTable
    sty temp1
    ldy ptrActiveDrawnNameTable+1
    sty temp1+1
UsePreviousCollision:
    
    lsr
    lsr
    lsr
    lsr
    lsr
    lsr ; Divide by 64
    asl ; stride * 2
    tay ; Put in x

    ; Check with the top pipe

    lda (temp1), y
    cmp which_player+PlayerStruct::ypos
    bcs collided

    iny

    ; CHECK WITH THE BOTTOM
    lda which_player+PlayerStruct::ypos
    adc #$10
    sta SpriteBottom

    lda (temp1), y
    cmp SpriteBottom
    bcc collided

    

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