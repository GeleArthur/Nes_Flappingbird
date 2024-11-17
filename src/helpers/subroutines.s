.proc WaitVBlank
    bit PPU_STATUS
	bpl WaitVBlank
    rts
.endproc

.proc ClearRam
    lda #0
    tax
clearRam:
    sta $0000,x
    sta $0100,x ; Are we clearing the stack?
    sta $0200,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx  ; Once x is at 0 we exit
    bne clearRam
    rts
.endproc

; BROKEN DONT USE
.proc ClearOAM
    lda #255
    ldx #0
clear_oam:
    sta oam,x
    inx
    inx
    inx
    inx 
    bne clear_oam

.endproc

