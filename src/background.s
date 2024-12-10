.include "../assets/pipes.s"

.segment "ZEROPAGE"
nametable_ptr_1: .res 1
nametable_ptr_2: .res 1

columnLow:  .res 1  ; low byte of new column address
columnHigh: .res 1  ; high byte of new column address
sourceLow:  .res 1  ; source for column data
sourceHigh: .res 1
columnNumber: .res 1  ; which column of level data to draw

scroll_pos: .res 1
nametableIndex: .res 1

.segment "CODE"

.proc SetupBackground
LoadBackground:
  lda #0
  sta scroll_pos
  PPU_SETADDR $2000
  
LoadBackgroundLoop:
  lda #<pipes_name_table
  sta nametable_ptr_1
  lda #>pipes_name_table
  sta nametable_ptr_2
  ldx #4 ; do this loop 4 times
  ldy #0
:
	lda (<nametable_ptr_1), Y
	sta PPU_DATA
	iny
	bne :-
	dex
	beq :+ ; finished if X = 0
	inc nametable_ptr_2 ; ptr = ptr + 256
	jmp :- ; loop again: Y = 0, X -= 1, ptr += 256
:

LoadAttribute:
  PPU_SETADDR $23C0
  ldx #$00              ; start out at 0

LoadAttributeLoop:
  lda pipes_attribute_table, x      ; load data from address (attribute + the value in x)
  sta PPU_DATA                      ; write to PPU
  inx                               ; X = X + 1
  cpx #$40                          ; Compare X to hex $08, decimal 8 - copying 8 bytes
  bne LoadAttributeLoop
  rts
.endproc

.proc UpdateBackground
  lda scroll_pos       ; calculate new column address using scroll register
  lsr A
  lsr A
  lsr A            ; shift right 3 times = divide by 8
  sta columnLow    ; $00 to $1F, screen is 32 tiles wide

  lda nametableIndex     ; calculate new column address using current nametable
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
  adc #<(nametable01)
  sta sourceLow
  lda sourceHigh
  adc #>(nametable01)
  sta sourceHigh

DrawColumn:
  lda #%00000100        ; set to increment +32 mode
  sta $2000
  
  lda $2002             ; read PPU status to reset the high/low latch
  lda columnHigh
  sta $2006             ; write the high byte of column address
  lda columnLow
  sta $2006             ; write the low byte of column address
  ldx #$1E              ; copy 30 bytes
  ldy #$00
DrawColumnLoop:
  lda (sourceLow), y
  sta $2007
  iny
  dex
  bne DrawColumnLoop
rts
.endproc  
  
.proc UpdateAttributeBackground  
DrawNewAttributes:
  lda nametableIndex
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

.proc ScrollBackground
  inc scroll_pos
NTSwapCheck:
  lda scroll_pos       ; check if the scroll just wrapped from 255 to 0
  bne NTSwapCheckDone
  
NTSwap:
  lda nametableIndex    ; load current nametable number (0 or 1)
  eor #$01              ; exclusive OR of bit 0 will flip that bit
  sta nametableIndex    ; so if nametable was 0, now 1
                        ;    if nametable was 1, now 0
NTSwapCheckDone:
; Update background
NewAttribCheck:
  LDA scroll_pos
  AND #%00011111            ; check for multiple of 32
  BNE NewAttribCheckDone    ; if low 5 bits = 0, time to write new attribute bytes
  jsr UpdateAttributeBackground
NewAttribCheckDone:


NewColumnCheck:
  LDA scroll_pos
  AND #%00000111            ; throw away higher bits to check for multiple of 8
  BNE NewColumnCheckDone    ; done if lower bits != 0
  JSR UpdateBackground         ; if lower bits = 0, time for new column
  
  lda columnNumber
  clc
  adc #$01             ; go to next column
  and #%01111111       ; only 128 columns of data, throw away top bit to wrap
  sta columnNumber
NewColumnCheckDone:

;This is the PPU clean up section, so rendering the next frame starts properly.
lda #CTRL_NMI|CTRL_SPR_1000
ora nametableIndex    ; select correct nametable for bit 0
sta PPU_CTRL

lda #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP   ; enable sprites, enable background, no clipping on left side
sta PPU_MASK


; Load the background to the PPU
  lda scroll_pos      ;HORIZONTAL
  sta PPU_SCROLL
  lda #0              ;(NO) VERTICAL
  sta PPU_SCROLL
  rts
.endproc
