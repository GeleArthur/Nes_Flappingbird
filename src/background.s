.include "../assets/pipes.s"
.include "../assets/LowPipesNameTable.s"


.segment "ZEROPAGE"
nametable_ptr: .res 2

scroll_pos: .res 1
flippingScroll: .res 1

columnLow:  .res 1  ; low byte of new column address
columnHigh: .res 1  ; high byte of new column address
sourceLow:  .res 1  ; source for column data
sourceHigh: .res 1
columnNumber: .res 1  ; which column of level data to draw

.segment "CODE"

.macro SET_NAMETABLE_DRAW_BACKGROUND nametableLocation
.scope outer

  lda #<nametableLocation
  sta nametable_ptr
  lda #>nametableLocation
  sta nametable_ptr+1
  jsr FullScreenBackGroundDraw

.endscope
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

.proc ScrollBackground
  inc scroll_pos

  lda scroll_pos       ; check if the scroll just wrapped from 255 to 0
  bne NTSwapCheckDone
  
  lda flippingScroll    ; load current nametable number (0 or 1)
  eor #$01              ; exclusive OR of bit 0 will flip that bit
  sta flippingScroll    ; so if nametable was 0, now 1
                        ;    if nametable was 1, now 0
NTSwapCheckDone:

  rts
.endproc











.proc DrawBackgroundSlice
  lda scroll_pos       ; calculate new column address using scroll register
  lsr A
  lsr A
  lsr A            ; shift right 3 times = divide by 8
  sta columnLow    ; $00 to $1F, screen is 32 tiles wide

  lda flippingScroll     ; calculate new column address using current nametable
  eor #$01          ; invert low bit, A = $00 or $01
  asl A             ; shift up, A = $00 or $02
  asl A             ; $00 or $04
  clc
  adc #$20          ; add high byte of nametable base address ($2000)
  sta columnHigh    ; now address = $20 or $24 for nametable 0 or 1

  lda columnNumber  ; column number * 32 = column data offset
  asl A
  asl A
  asl A
  asl A
  asl A
  sta sourceLow
  lda columnNumber
  lsr A
  lsr A
  lsr A
  sta sourceHigh
  
  lda sourceLow       ; column data start + offset = address to load column data from
  clc 
  adc #<(LowPipesNameTable)
  sta sourceLow
  lda sourceHigh
  adc #>(LowPipesNameTable)
  sta sourceHigh

DrawColumn:
  lda #%00000100        ; set to increment +32 mode
  sta PPU_CTRL
  
  lda PPU_STATUS             ; read PPU status to reset the high/low latch

  lda columnHigh
  sta PPU_ADDR             ; write the high byte of column address
  lda columnLow
  sta PPU_ADDR             ; write the low byte of column address

  ldx #$1E              ; copy 30 bytes
  ldy #$00
DrawColumnLoop:
  lda (sourceLow), y
  sta PPU_DATA
  iny
  dex
  bne DrawColumnLoop
  rts
.endproc  
  
.proc DrawAttributeSlide  
DrawNewAttributes:
  lda flippingScroll
  eor #$01          ; invert low bit, A = $00 or $01
  asl A             ; shift up, A = $00 or $02
  asl A             ; $00 or $04
  clc
  adc #$23          ; add high byte of attribute base address ($23C0)
  sta columnHigh    ; now address = $23 or $27 for nametable 0 or 1
  
  lda scroll_pos
  lsr A
  lsr A
  lsr A
  lsr A
  lsr A
  clc
  adc #$C0
  sta columnLow     ; attribute base + scroll / 32

  lda columnNumber  ; (column number / 4) * 8 = column data offset
  and #%11111100
  asl A
  sta sourceLow
  lda columnNumber
  lsr A
  lsr A
  lsr A
  lsr A
  lsr A
  lsr A
  lsr A
  sta sourceHigh
  
  lda sourceLow       ; column data start + offset = address to load column data from
  clc 
  adc #<(attributeTable01)
  sta sourceLow
  lda sourceHigh
  adc #>(attributeTable01)
  sta sourceHigh

  ldy #$00
  lda $2002             ; read PPU status to reset the high/low latch
DrawNewAttributesLoop:
  lda columnHigh
  sta $2006             ; write the high byte of column address
  lda columnLow
  sta $2006             ; write the low byte of column address
  lda (sourceLow), y    ; copy new attribute byte
  sta $2007
  
  iny
  cpy #$08              ; copy 8 attribute bytes
  beq DrawNewAttributesLoopDone 
  
  lda columnLow         ; next attribute byte is at address + 8
  clc
  adc #$08
  sta columnLow
  jmp DrawNewAttributesLoop
DrawNewAttributesLoopDone:
  rts
.endproc




.proc NMIBackgroundDraw
  lda Have_Players_Pressed_A
  cmp #%10001111  
  bne end

; Update background
; NewAttribCheck:
;     lda scroll_pos
;     and #%00011111            ; check for multiple of 32
;     bne NewAttribCheckDone    ; if low 5 bits = 0, time to write new attribute bytes
;     jsr DrawAttributeSlide
; NewAttribCheckDone:


NewColumnCheck:
  lda scroll_pos
  and #%00000111            ; throw away higher bits to check for multiple of 8
  bne NewColumnCheckDone    ; done if lower bits != 0
  jsr DrawBackgroundSlice         ; if lower bits = 0, time for new column
  
  lda columnNumber
  clc
  adc #$01             ; go to next column
  and #%01111111       ; only 128 columns of data, throw away top bit to wrap
  sta columnNumber
NewColumnCheckDone:

  ;This is the PPU clean up section, so rendering the next frame starts properly.
  lda #CTRL_NMI|CTRL_SPR_1000
  ora flippingScroll    ; select correct nametable for bit 0
  sta PPU_CTRL
  
  lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP   ; enable sprites, enable background, no clipping on left side
  sta PPU_MASK
  
  ; Load the background to the PPU
  lda scroll_pos      ;HORIZONTAL
  sta PPU_SCROLL
  lda #0              ;(NO) VERTICAL
  sta PPU_SCROLL

end:
  rts
.endproc
