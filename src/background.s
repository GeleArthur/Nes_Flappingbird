.segment "ZEROPAGE"
nametablePtr01: .res 1
nametablePtr02: .res 1


.segment "CODE"

.proc setup_background
LoadBackground:
  LDA PPU_STATUS             ; read PPU status to reset the high/low latch
  LDA #$20
  STA PPU_VRAM_ADDRESS2             ; write the high byte of $2000 address
  LDA #$00
  STA PPU_VRAM_ADDRESS2             ; write the low byte of $2000 address
  LDX #$00              ; start out at 0
  LDY #$00

LoadBackgroundLoop:
  lda #<nametable01
  sta nametablePtr01
  lda #>nametable01
  sta nametablePtr02
  ldx #4 ; do this loop 4 times
  ldy #0
:
	lda (<nametablePtr01), Y
	sta PPU_VRAM_IO
	iny
	bne :-
	dex
	beq :+ ; finished if X = 0
	inc nametablePtr02 ; ptr = ptr + 256
	jmp :- ; loop again: Y = 0, X -= 1, ptr += 256
:

LoadAttribute:
  LDA PPU_STATUS             ; read PPU status to reset the high/low latch
  LDA #$23
  STA PPU_VRAM_ADDRESS2             ; write the high byte of $23C0 address
  LDA #$C0
  STA PPU_VRAM_ADDRESS2             ; write the low byte of $23C0 address
  LDX #$00              ; start out at 0

LoadAttributeLoop:
  LDA attributeTable01, x      ; load data from address (attribute + the value in x)
  STA PPU_VRAM_IO             ; write to PPU
  INX                   ; X = X + 1
  CPX #$40              ; Compare X to hex $08, decimal 8 - copying 8 bytes
  BNE LoadAttributeLoop

.endproc