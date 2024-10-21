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
; sets the sprite tile number (with the a register)
;******************************************************************************
.macro set_sprite_tile_a index
   sta oam + (index * 4) + 1
.endmacro

;******************************************************************************
; sets the sprite attributes
;******************************************************************************
.macro set_sprite_attr index, attr
   lda attr
   sta oam + (index * 4) + 2
.endmacro

;******************************************************************************
; sets the sprite attributes (with the a register)
;******************************************************************************
.macro set_sprite_attr_a index
   sta oam + (index * 4) + 2
.endmacro
