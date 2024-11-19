.segment "ZEROPAGE"
; If 1 the cpu is done calulateing the frame and the ppu should render. The cpu should wait until the ppu is done rendering the frame set to 0
; If 0 the ppu is done and the cpu should calulate the next frame. the ppu should also wait for the next render until its set to 1
nmi_ready: .res 1
WTF: .res 1


.segment "OAM"
; A easy copy of the OAM we copy over every frame. We don't need this if we program smart ORRR naaaa.
oam: .res 256 



.segment "CODE"

.macro COPY_OAM

    lda #$00
    sta OAM_ADDR
    lda #>oam
    sta OAM_DMA ; Suppends the 
    
.endmacro

.macro WAIT_UNITL_FRAME_HAS_RENDERED
@waitVBlank:
    lda nmi_ready
 	bne @waitVBlank ; If nmi_ready == 1 -> wait
.endmacro
    
.macro FRAME_IS_DONE_RENDERING
    lda #0
    sta nmi_ready 
.endmacro




.proc nmi
    SAVE_REGISTERS
    lda nmi_ready
    beq skipRenderingFrame ; If the nmi_ready is 0 we skip as the cpu is not ready rendering the frame
    
    COPY_OAM

    ; Copy oam
    ; Copy background

    FRAME_IS_DONE_RENDERING 
skipRenderingFrame:

    RESTORE_REGISTERS
    rti
.endproc

.proc irq
    rti
.endproc



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



