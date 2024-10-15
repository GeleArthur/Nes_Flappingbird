
;******************************************************************************
; Set the ram address pointer to the specified address
;******************************************************************************
.macro assign_16i dest, value

   lda #<value
   sta dest+0
   lda #>value
   sta dest+1

.endmacro

;******************************************************************************
; Set the vram address pointer to the specified address
;******************************************************************************
.macro vram_set_address newaddress

   lda PPU_STATUS
   lda #>newaddress
   sta PPU_VRAM_ADDRESS2
   lda #<newaddress
   sta PPU_VRAM_ADDRESS2

.endmacro

;******************************************************************************
; clear the vram address pointer
;******************************************************************************
.macro vram_clear_address

   lda #0
   sta PPU_VRAM_ADDRESS2
   sta PPU_VRAM_ADDRESS2

.endmacro


;******************************************************************************
; sets the sprite x position
;******************************************************************************
.macro set_sprite_x index, xpos
   lda xpos
   sta oam + (index * 4) + 3
.endmacro

;******************************************************************************
; sets the sprite x position (with the a register)
;******************************************************************************
.macro set_sprite_x_a index
   sta oam + (index * 4) + 3
.endmacro

;******************************************************************************
; sets the sprite y position
;******************************************************************************
.macro set_sprite_y index, ypos
   lda ypos
   sta oam + (index * 4) + 0
.endmacro

;******************************************************************************
; sets the sprite y position (with the a register)
;******************************************************************************
.macro set_sprite_y_a index
   sta oam + (index * 4) + 0
.endmacro

;******************************************************************************
; sets the sprite tile number
;******************************************************************************
.macro set_sprite_tile index, tile
   lda tile
   sta oam + (index * 4) + 1
.endmacro

;******************************************************************************
; sets the sprite attributes
;******************************************************************************
.macro set_sprite_attr index, attr
   lda attr
   sta oam + (index * 4) + 2
.endmacro