.include "../assets/pipes.s"

.segment "ZEROPAGE"
nametablePtr01: .res 1
nametablePtr02: .res 1

scrollPos: .res 1

.segment "CODE"

.proc setup_background
LoadBackground:
  LDA #255
  STA scrollPos
  PPU_SETADDR $2000
  LDX #$00              ; start out at 0
  LDY #$00

LoadBackgroundLoop:
  lda #<pipesNameTable
  sta nametablePtr01
  lda #>pipesNameTable
  sta nametablePtr02
  ldx #4 ; do this loop 4 times
  ldy #0
:
	lda (<nametablePtr01), Y
	sta PPU_DATA
	iny
	bne :-
	dex
	beq :+ ; finished if X = 0
	inc nametablePtr02 ; ptr = ptr + 256
	jmp :- ; loop again: Y = 0, X -= 1, ptr += 256
:

LoadAttribute:
  PPU_SETADDR $23C0
  LDX #$00              ; start out at 0

LoadAttributeLoop:
  LDA PipesattributeTable, x      ; load data from address (attribute + the value in x)
  STA PPU_DATA             ; write to PPU
  INX                   ; X = X + 1
  CPX #$40              ; Compare X to hex $08, decimal 8 - copying 8 bytes
  BNE LoadAttributeLoop
  RTS
.endproc

.proc scroll_background
  INC scrollPos
  LDA scrollPos
  STA PPU_SCROLL
  LDA #0
  STA PPU_SCROLL
  RTS
.endproc