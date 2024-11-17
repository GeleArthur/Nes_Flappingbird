.proc WaitVBlank
    bit PPU_STATUS
	bpl WaitVBlank
    rts
.endproc

.proc ClearRam
    lda #0
    tax
    
.endproc

