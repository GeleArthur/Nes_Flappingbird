.segment "ZEROPAGE"
playerDeathStates: .res 1
Player1Score: .res 1
Player2Score: .res 1
Player3Score: .res 1
Player4Score: .res 1


.segment "CODE"

.macro CHECK_DEATH playerBit
    ; Check if player died already
    lda playerDeathStates
    and #playerBit
    
    beq :++++
    ; Save player State
    lda playerDeathStates
    eor #playerBit
    sta playerDeathStates

    ; Check if finalPlayer
    and #%0001111
    bne :++++

    ; Check if player 1 was last player
    lda #playerBit
    and #%00000001
    beq :+
    inc Player1Score
    jmp :++++
    :

    ; Check if player 2 was last player
    lda #playerBit
    and #%00000010
    beq :+
    inc Player2Score
    jmp :+++
    :

    ; Check if player 3 was last player
    lda #playerBit
    and #%00000100
    beq :+
    inc Player3Score
    jmp :++
    :

    ; Check if player 4 was last player
    lda #playerBit
    and #%00001000
    beq :+
    inc Player4Score
:
.endmacro

.proc CheckPlayerDeath
    CHECK_DEATH %00000001
    CHECK_DEATH %00000010
    CHECK_DEATH %00000100
    CHECK_DEATH %00001000
.endproc

.proc EndOfGame
    lda playerDeathStates
    and #%0001111
    bne endOfEndGameCheck

    jmp GameEnded

endOfEndGameCheck:
    rts
.endproc