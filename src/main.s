;*****************************************************************
; Define NES cartridge Header
;*****************************************************************

.segment "HEADER"
INES_MAPPER = 0 ; 0 = NROM
INES_MIRROR = 0 ; 0 = horizontal mirroring, 1 = vertical mirroring
INES_SRAM   = 0 ; 1 = battery backed SRAM at $6000-7FFF

.byte 'N', 'E', 'S', $1A ; ID 
.byte $02 ; 16k PRG bank count
.byte $01 ; 8k CHR bank count
.byte INES_MIRROR | (INES_SRAM << 1) | ((INES_MAPPER & $f) << 4)
.byte (INES_MAPPER & %11110000)
.byte $0, $0, $0, $0, $0, $0, $0, $0 ; padding

;*****************************************************************
; Tiles
;*****************************************************************

.segment "TILES"
.incbin "../assets/texture.chr"

;*****************************************************************
; Vectors
;*****************************************************************

.segment "VECTORS" ; Book up segments
.word nmi ; Not able to disable interupt. Its connected to the ppu
.word reset ; On start (When the reset button is pressed on the nes)
.word irq ; Request an interupt which we just disable.

;*****************************************************************
; Zeropage definitions
;*****************************************************************

.segment "ZEROPAGE"
					   ;        2 to turn rendering off next NMI

p1_x:   .res 1 ; Player 1 x position
p1_y:   .res 1 ; Player 1 y position
p1_g:   .res 1 ; Player 1 gravity acceleration
p1_g_c: .res 1 ; Player 1 Gravity Counter
p1_j_m: .res 1 ; Player 1 Jump Memory              //stores the last y position of the player to allow to keep track of when the player can jump

p2_x:   .res 1 ; Player 2 x position
p2_y:   .res 1 ; Player 2 y position
p2_g:   .res 1 ; Player 2 gravity acceleration
p2_g_c: .res 1 ; Player 2 Gravity Counter
p2_j_m: .res 1 ; Player 2 Jump Memory  

p3_x:   .res 1 ; Player 3 x position
p3_y:   .res 1 ; Player 3 y position
p3_g:   .res 1 ; Player 3 gravity acceleration
p3_g_c: .res 1 ; Player 3 Gravity Counter
p3_j_m: .res 1 ; Player 3 Jump Memory  

p4_x:   .res 1 ; Player 4 x position
p4_y:   .res 1 ; Player 4 y position
p4_g:   .res 1 ; Player 4 gravity acceleration
p4_g_c: .res 1 ; Player 4 Gravity Counter
p4_j_m: .res 1 ; Player 4 Jump Memory  



;*****************************************************************
; Sprite OAM Data area - copied to VRAM in NMI routine
;*****************************************************************

.segment "OAM"
oam: .res 256

;*****************************************************************
; Include NES Function Library
;*****************************************************************

.include "neslib.s"

;*****************************************************************
; Background code
;*****************************************************************
; nameTables
.include "../assets/nametable01.s"

.include "background.s"

;*****************************************************************
; Input related code
;*****************************************************************
.include "playerInput.s"



.segment "BSS"
palette: .res 32 ; Current palette


.segment "CODE"
.proc nmi
    pha ; Push A X Y on the stack. Not P?
	txa
	pha
	tya
	pha

    lda nmi_ready
    bne continue
    jmp ppu_update_end

    ; Copy stuff in the ppu? Doesn;t really tell me what
continue:
    cmp #2
    bne cont_render
    lda #%00000000
    sta PPU_MASK
    ldx #0
    stx nmi_ready
    jmp ppu_update_end
cont_render:
    ldx #0
    stx PPU_SPRRAM_ADDRESS
    lda #>oam
    sta SPRITE_DMA

    lda PPU_STATUS
    lda #$3F
    sta PPU_VRAM_ADDRESS2
    stx PPU_VRAM_ADDRESS2
    ldx #0
    
    lda #%10001000
    sta PPU_CONTROL

loop:
    lda palette, x
    sta PPU_VRAM_IO
    inx
    cpx #32
    bcc loop

    lda #%00011110
    sta PPU_MASK
    ldx #0
    stx nmi_ready
ppu_update_end:
    pla
    tay
    pla
    tax
    pla
    rti
.endproc

.proc irq
    rti
.endproc


.proc reset
    sei ; disable interrupt BUT we never enable???
    lda #0 
    sta PPU_CONTROL ; Disable NMI? 
    sta PPU_MASK
    sta APU_DM_CONTROL ; Turns off the ppu and apu
    lda #$40
    sta JOYPAD2 ; Set up for the second controller port?

    cld ; clear decimal mode
    ldx #$FF
    tsx ; Dont know why we set the stack pointer to FF here?

wait_vblank:
	bit PPU_STATUS
	bpl wait_vblank

    ; Clear all the ram
    lda #0
    ldx #0
    clear_ram:
    sta $0000,x
    sta $0100,x ; Are we clearing the stack?
    sta $0200,x
    sta $0300,x
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx ; does this change the negative flag???
    bne clear_ram

    lda #255
    ldx #0
    clear_oam:
    sta oam,x
    inx
    inx
    inx
    inx ; every 4 bytes we change something
    bne clear_oam


    ; We do anything wait check?
wait_vblank2:
    bit PPU_STATUS
    bpl wait_vblank2

    ; NES is initialized and ready to begin
	; - enable the NMI for graphical updates and jump to our main program
    lda #%10001000
    sta PPU_CONTROL ; Enable NMI
    jmp main
.endproc

.proc main

    ldx #0
paletteloop:
    lda default_palette, x
    sta palette, x
    inx
    cpx #32
    bcc paletteloop
    jsr clear_nametable

    lda PPU_STATUS
    lda #$20
    sta PPU_VRAM_ADDRESS2
    lda #$8A
    sta PPU_VRAM_ADDRESS2

    lda #180
    sta p1_x

    lda #120
    sta p1_y


    jsr setup_player_1
    jsr setup_player_2
    jsr setup_player_3
    jsr setup_player_4

    jsr setup_background
    
    jsr ppu_update

mainloop:
 	; skip reading controls if and change has not been drawn
 	lda nmi_ready
 	cmp #0
 	bne mainloop



    jsr gamepad_poll

    jsr update_player_1
    jsr update_player_2
    jsr update_player_3
    jsr update_player_4

    jsr scroll_background
    
 	; ensure our changes are rendered
 	lda #1
 	sta nmi_ready
 	jmp mainloop

.endproc




.segment "RODATA"
default_palette:
.byte $0F,$15,$26,$37 ; bg0 purple/pink
.byte $0F,$09,$19,$29 ; bg1 green
.byte $0F,$01,$11,$21 ; bg2 blue
.byte $0F,$00,$10,$30 ; bg3 greyscale
.byte $0F,$18,$28,$38 ; sp0 yellow
.byte $0F,$14,$24,$34 ; sp1 purple
.byte $0F,$1B,$2B,$3B ; sp2 teal
.byte $0F,$12,$22,$32 ; sp3 marine

welcome_txt:
.byte 'W','E','L','C', 'O', 'M', 'E', 0