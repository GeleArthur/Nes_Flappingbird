

; Saves all registers. Nice for interupt
.macro SAVE_REGISTERS
    pha
    txa
    pha
    tya
    pha

.endmacro

; restores all registers. Nice for interupt
.macro RESTORE_REGISTERS
    pla
    tay
    pla
    tax
    pla
.endmacro

.macro PPU_SETADDR newaddress
    PPU_CLEAR_W
    lda #>newaddress
    sta PPU_ADDR
    lda #<newaddress
    sta PPU_ADDR
.endmacro

.macro PPU_SETDATA data
    lda #data
    sta PPU_DATA
.endmacro

.macro PPU_CLEAR_W
    lda PPU_STATUS
.endmacro



.macro OAM_WRITE_X index, xpos
   lda xpos
   sta oam + (index * 4) + 3
.endmacro

.macro OAM_WRITE_X_A index
   sta oam + (index * 4) + 3
.endmacro

.macro OAM_WRITE_Y index, ypos
   lda ypos
   sta oam + (index * 4) + 0
.endmacro

.macro OAM_WRITE_Y_A index
   sta oam + (index * 4) + 0
.endmacro

.macro OAM_WRITE_TILE index, tile
   lda tile
   sta oam + (index * 4) + 1
.endmacro

.macro OAM_WRITE_TILE_A index
   sta oam + (index * 4) + 1
.endmacro

.macro OAM_WRITE_ATTRUDE index, attr
   lda attr
   sta oam + (index * 4) + 2
.endmacro

.macro OAM_WRITE_ATTRUDE_A index
   sta oam + (index * 4) + 2
.endmacro