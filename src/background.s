.include "../assets/pipes.s"

.segment "ZEROPAGE"
nametable_ptr_1: .res 1
nametable_ptr_2: .res 1

scroll_pos: .res 1
nametableIndex: .res 1

.segment "CODE"

.proc SetupBackground
LoadBackground:
  LDA #0
  STA scroll_pos
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

.proc ScrollBackground
  inc scroll_pos
NTSwapCheck:
  LDA scroll_pos       ; check if the scroll just wrapped from 255 to 0
  BNE NTSwapCheckDone
  
NTSwap:
  LDA nametableIndex    ; load current nametable number (0 or 1)
  EOR #$01              ; exclusive OR of bit 0 will flip that bit
  STA nametableIndex    ; so if nametable was 0, now 1
                        ;    if nametable was 1, now 0
NTSwapCheckDone:


;This is the PPU clean up section, so rendering the next frame starts properly.
LDA #CTRL_NMI|CTRL_SPR_1000
ORA nametableIndex    ; select correct nametable for bit 0
STA PPU_CTRL

LDA #MASK_SPR | MASK_BG | MASK_SPR_CLIP | MASK_BG_CLIP   ; enable sprites, enable background, no clipping on left side
STA PPU_MASK


; Load the background to the PPU
  lda scroll_pos      ;HORIZONTAL
  sta PPU_SCROLL
  lda #0              ;(NO) VERTICAL
  sta PPU_SCROLL
  rts
.endproc