; Saves all registers. Nice for interupt
.macro SAVE_REGISTERS:
    pha
    txa
    pha
    tya
    pha
.endmacro

; restores all registers. Nice for itterupt
.macro RESTORE_REGISTERS:
    pla
    tay
    pla
    tax
    pla
.endmacro

.macro PPU_SETADDRESS
    
.endmacro