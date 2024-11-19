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

  LDA nametable01, x     ; load data from address (background + the value in x)
  STA PPU_VRAM_IO             ; write to PPU

  ; UGLY CODE
  CPX #$FF
  BNE :+
  INY
  : 
  ;

  INX                   ; X = X + 1

  CPX #$C0              ; Compare X to hex $80, decimal 128 - copying 128 bytes 
  BNE LoadBackgroundLoop
  CPY #$03
  BNE LoadBackgroundLoop  ; Branch to LoadBackgroundLoop if compare was Not Equal to zero
                        ; if compare was equal to 128, keep going down

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