
.macro NES_INIT
    sei ; disable interrupt as its never used.
    cld ; disable decible mode

    ldx #$FF
    txs ; Make sure stack pointer starts at FF

    inx ; increment x by 1 so it becomes $00
    stx PPU_CTRL ; disable V in NMI
    stx PPU_MASK ; Disable rendering
    ;stx DMC_FREQ ; Mute APU


    jsr WaitSync ; wait 
    jsr ClearRam
    jsr WaitSync
    jsr SetPallet
    jsr HideAllAOMSprites ; All of these could be macros

    lda #MASK_SPR ;| MASK_BG
    sta PPU_MASK ; Enable sprite and background rendering
    lda #CTRL_NMI|CTRL_SPR_1000
    sta PPU_CTRL ; Enable NMI. Set Sprite characters to use second sheet

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