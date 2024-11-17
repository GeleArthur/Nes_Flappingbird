
.macro NES_INIT
    sei ; disable interrupt as its never used.
    cld ; disable decible mode

    ldx #$FF
    tsx ; Make sure stack pointer starts at FF

    inx ; increment x by 1 so it becomes $00
    stx PPU_CTRL ; disable V in NMI
    stx PPU_MASK ; Disable rendering
    stx DMC_FREQ ; Mute APU
.endmacro

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
    lda #>newaddress
    sta PPU_ADDR
    lda #<newaddress
    sta PPU_ADDR
.endmacro

.macro PPU_SETDATA data
    lda #data
    sta PPU_DATA
.endmacro




.macro set_sprite_x index, xpos
   lda xpos
   sta oam + (index * 4) + 3
.endmacro

.macro set_sprite_x_a index
   sta oam + (index * 4) + 3
.endmacro

.macro set_sprite_y index, ypos
   lda ypos
   sta oam + (index * 4) + 0
.endmacro

.macro set_sprite_y_a index
   sta oam + (index * 4) + 0
.endmacro

.macro set_sprite_tile index, tile
   lda tile
   sta oam + (index * 4) + 1
.endmacro

.macro set_sprite_tile_a index
   sta oam + (index * 4) + 1
.endmacro

.macro set_sprite_attr index, attr
   lda attr
   sta oam + (index * 4) + 2
.endmacro

.macro set_sprite_attr_a index
   sta oam + (index * 4) + 2
.endmacro