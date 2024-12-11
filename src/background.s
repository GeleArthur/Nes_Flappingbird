.include "../assets/pipes.s"

.segment "ZEROPAGE"
nametable_ptr: .res 2

scroll_pos: .res 1
nametableIndex: .res 1

.segment "CODE"

.macro SET_NAMETABLE_DRAW_BACKGROUND nametableLocation
.scope

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
NTSwapCheck:
  lda scroll_pos       ; check if the scroll just wrapped from 255 to 0
  bne NTSwapCheckDone
  
NTSwap:
  lda nametableIndex    ; load current nametable number (0 or 1)
  eor #$01              ; exclusive OR of bit 0 will flip that bit
  sta nametableIndex    ; so if nametable was 0, now 1
                        ;    if nametable was 1, now 0
NTSwapCheckDone:


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