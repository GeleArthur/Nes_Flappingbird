.segment "ZEROPAGE"
; If 1 the cpu is currently calulating the next frame.
; If 0 the cpu is waiting for the ppu
nmi_ready: .res 1


.segment "CODE"

.macro WAIT_UNITL_FRAME_HAS_RENDERED
waitVBlank:
    lda nmi_ready
 	cmp #0
 	bne waitVBlank
.endmacro
    
.macro FRAME_IS_DONE_RENDERING
    ldx #0
    stx nmi_ready 
.endmacro

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
    SAVE_REGISTERS
    lda nmi_ready
    bne skipRenderingFrame ; If the nmi_ready is 1 we skip as the cpu is not ready rendering the frame
    
    

    

    FRAME_IS_DONE_RENDERING
skipRenderingFrame:

    RESTORE_REGISTERS
    rti
.endproc

.proc irq
    rti
.endproc

