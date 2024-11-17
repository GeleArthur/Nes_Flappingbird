;*****************************************************************
; Vectors
;*****************************************************************

.segment "VECTORS" ; Book up segments
.word nmi ; Not able to disable interupt. Its connected to the ppu ; vblank
.word reset ; On start (When the reset button is pressed on the nes)
.word irq ; Request an interupt which we just disable.