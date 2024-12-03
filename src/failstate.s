.segment "ZEROPAGE"
playerDeathStates: .res 1

.segment "CODE"

.macro CHECK_DEATH playerBit
    lda playerDeathStates
    and #playerBit
    
    beq :+
    lda playerDeathStates
    eor #playerBit
    sta playerDeathStates
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
    and #%0000011
    bne endOfEndGameCheck

    jmp reset

endOfEndGameCheck:
    rts
.endproc