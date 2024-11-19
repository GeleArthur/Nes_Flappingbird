.proc WaitSync
    bit PPU_STATUS
	bpl WaitSync
    rts
.endproc

.proc ClearRam
	lda #0		; A = 0
    tax		; X = 0
clearRAM:
	sta $0,x	; clear $0-$ff
    cpx #$fe	; last 2 bytes of stack?
    bcs skipStack	; don't clear it
	sta $100,x	; clear $100-$1fd
skipStack:
	sta $200,x	; clear $200-$2ff
	sta $300,x	; clear $300-$3ff
	sta $400,x	; clear $400-$4ff
	sta $500,x	; clear $500-$5ff
	sta $600,x	; clear $600-$6ff
	sta $700,x	; clear $700-$7ff
    inx		; X = X + 1
    bne clearRAM	; loop 256 times
    rts

.endproc
