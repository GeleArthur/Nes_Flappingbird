.include "../assets/pipes.s"
.include "../assets/LowPipesNameTable.s"


.segment "ZEROPAGE"
nametable_ptr: .res 2

scroll_pos: .res 1
flippingScroll: .res 1

ppuWriteLocation:  .res 2  ; low byte of new column address
sourcePtr:  .res 2  ; source for column data
columnNumber: .res 1  ; which column of level data to draw

temp1: .res 2 ; Big sad

.segment "CODE"

.macro SET_NAMETABLE_DRAW_BACKGROUND nametableLocation


  lda #<nametableLocation
  sta nametable_ptr
  lda #>nametableLocation
  sta nametable_ptr+1
  jsr FullScreenBackGroundDraw

.endmacro


.proc FullScreenBackGroundDraw
LoadBackground:
  lda #0
  sta scroll_pos
  PPU_SETADDR $2000
  
  ldx #4 ; do this loop 4 times
  ldy #0
@repeat:
	lda (nametable_ptr), y
	sta PPU_DATA
	iny
	bne @repeat
	inc nametable_ptr+1 ; ptr = ptr + 256
	dex
	bne @repeat ; finished if X = 0

  lda scroll_pos
  sta PPU_SCROLL
  lda #0
  sta PPU_SCROLL

  rts
.endproc




.proc DrawBackgroundSlice
  lda scroll_pos       ; calculate new column address using scroll register
  lsr A
  lsr A
  lsr A                   ; shift right 3 times = divide by 8
  sta ppuWriteLocation    ; $00 to $1F, screen is 32 tiles wide

  lda flippingScroll     ; calculate new column address using current nametable
  eor #$01          ; invert low bit, A = $00 or $01
  asl A             ; shift up, A = $00 or $02
  asl A             ; $00 or $04
  clc
  adc #$20          ; add high byte of nametable base address ($2000)
  sta ppuWriteLocation+1    ; now address = $20 or $24 for nametable 0 or 1


  ; Load pointers
  lda ptrActiveDrawnNameTable+1
  sta sourcePtr+1

  lda ptrActiveDrawnNameTable
  sta sourcePtr

  adc #BackgroundLayout::nameTable
  sta sourcePtr
  lda sourcePtr+1
  adc #$00
  sta sourcePtr+1

  lda sourcePtr
  adc columnNumber
  sta sourcePtr
  lda sourcePtr+1
  adc #$00
  sta sourcePtr+1

DrawColumn:
  lda #%00000100        ; set to increment +32 mode
  sta PPU_CTRL

  PPU_CLEAR_W             ; read PPU status to reset the high/low latch

  ; PPU_SETADDR ppuWriteLocation
  lda ppuWriteLocation+1
  sta PPU_ADDR             ; write the high byte of column address
  lda ppuWriteLocation
  sta PPU_ADDR             ; write the low byte of column address

  ldx #$1E              ; copy 30 bytes
  ldy #$00
  clc
DrawColumnLoop:
  lda (sourcePtr), y
  sta PPU_DATA
  lda sourcePtr
  adc #32
  sta sourcePtr

  bcc @overflowSkip
  inc sourcePtr+1
  clc
@overflowSkip:
  dex
  bne DrawColumnLoop
  rts
.endproc  
  
.proc DrawAttributeSlide  
DrawNewAttributes:
  lda flippingScroll
  eor #$01          ; invert low bit, A = $00 or $01
  asl            ; shift up, A = $00 or $02
  asl            ; $00 or $04
  clc
  adc #$23          ; add high byte of attribute base address ($23C0)
  sta ppuWriteLocation+1    ; now address = $23 or $27 for nametable 0 or 1
  
  lda scroll_pos
  lsr
  lsr
  lsr
  lsr
  lsr
  clc
  adc #$C0
  sta ppuWriteLocation     ; attribute base + scroll / 32


  ; Load pointers
  lda ptrActiveDrawnNameTable+1
  sta sourcePtr+1

  lda ptrActiveDrawnNameTable
  sta sourcePtr

  adc #BackgroundLayout::attributeTable
  sta sourcePtr
  lda sourcePtr+1
  adc #$00
  sta sourcePtr+1
  
  
  lda columnNumber  ; (column number / 4) = column data offset
  lsr
  lsr
  sta temp1
  lda sourcePtr
  adc temp1
  lda sourcePtr+1
  adc #$00
  sta sourcePtr+1

  lda #%00000000 ; Turn off +32 mode
  sta PPU_CTRL

  PPU_CLEAR_W
  ldy #$00

DrawNewAttributesLoop:
  lda ppuWriteLocation+1
  sta PPU_ADDR             ; write the high byte of column address
  lda ppuWriteLocation
  sta PPU_ADDR             ; write the low byte of column address
  lda (sourcePtr), y    ; copy new attribute byte
  sta PPU_DATA
  

  lda ppuWriteLocation ; Add 8 to sourcePtr
  clc
  adc #$08
  sta ppuWriteLocation
  
  tya ; Add 8 to y
  clc
  adc #$08
  tay

  cmp #64
  beq @end
  jmp DrawNewAttributesLoop
@end:
  rts
.endproc




.proc NMIBackgroundDraw
  lda Have_Players_Pressed_A
  cmp #%10001111  
  bne end


    lda scroll_pos
    and #%00011111            ; check for multiple of 32
    bne NewAttribCheckDone    ; if low 5 bits = 0, time to write new attribute bytes
    jsr DrawAttributeSlide
NewAttribCheckDone:



  lda scroll_pos
  and #%00000111            ; throw away higher bits to check for multiple of 8
  bne NewColumnCheckDone    ; done if lower bits != 0
  jsr DrawBackgroundSlice         ; if lower bits = 0, time for new column
  
  lda columnNumber
  clc
  adc #$01             ; go to next column
  and #%00001111       ; only 64 columns of data, throw away top bit to wrap
  sta columnNumber
NewColumnCheckDone:

  ;This is the PPU clean up section, so rendering the next frame starts properly.
  lda #CTRL_NMI|CTRL_SPR_1000
  ora flippingScroll    ; select correct nametable for bit 0
  sta PPU_CTRL
  
  lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP   ; enable sprites, enable background, no clipping on left side
  sta PPU_MASK
  
end:
  lda scroll_pos      ;HORIZONTAL
  sta PPU_SCROLL
  lda #0              ;(NO) VERTICAL
  sta PPU_SCROLL


  rts
.endproc
