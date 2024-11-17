.segment "ZEROPAGE"
nmi_ready: .res 1

.segment "CODE"
; .proc nmi
;     pha ; Push A X Y on the stack. Not P?
; 	txa
; 	pha
; 	tya
; 	pha

;     lda nmi_ready ; 
;     bne continue
;     jmp ppu_update_end

;     ; Copy stuff in the ppu? Doesn;t really tell me what
; continue:
;     cmp #2
;     bne cont_render
;     lda #%00000000
;     sta PPU_MASK
;     ldx #0
;     stx nmi_ready
;     jmp ppu_update_end
; cont_render:
;     ldx #0
;     stx PPU_SPRRAM_ADDRESS
;     lda #>oam
;     sta SPRITE_DMA

;     lda #%10001000
;     sta PPU_CONTROL
;     lda PPU_STATUS
;     lda #$3F
;     sta PPU_VRAM_ADDRESS2
;     stx PPU_VRAM_ADDRESS2
;     ldx #0

; loop:
;     lda palette, x
;     sta PPU_VRAM_IO
;     inx
;     cpx #32
;     bcc loop

;     lda #%00011110
;     sta PPU_MASK
;     ldx #0
;     stx nmi_ready
; ppu_update_end:
;     pla
;     tay
;     pla
;     tax
;     pla
;     rti
; .endproc

.proc nmi
    rti
.endproc

.proc irq
    rti
.endproc